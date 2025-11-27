%[text] ## Diseño de controladores
%[text] El controlador diseñado está hecho para controlar un proceso de flujo de aire en el modo de operación de control regulatorio.
%[text] Modelo del proceso controlado y parámetros a partir de System Identification Toolbox:
clear;
clc;

s = tf('s');
K  = 0.92044;
T  = 1.0507;
L  = 0.1371;

tau_0 = L / T

P = (K * exp(-L * s)) / (T*s + 1);
P_nodelay = K/(T*s+1);
% Aproximación de Padé para cálculo de robustez
P0 = K/(T*s+1);
P0.InputDelay = L;
N = 10;
Pp = pade(P0, N); % Reemplazar el retardo
%%
%[text] ### RoPe
%[text] *Robust-Performance Tuning of 2DoF PI/PID Controllers for First- and Second-Order-Plus-Dead-Time Models*
%[text] Ms = 1.2
%[text] a = 0
a0 = 0.2319;
a1 = 0.1251;
a2 = 0.0298;

b0 = 0.1140;
b1 = 0.9722;
b2 = 0.5886;

c0 = 0.0007;
c1 = 0.3958;
c2 = 0.8415;

Kp = (a0 + a1*tau_0) / (K * (a2 + tau_0))
Ti = T * (b0 + b1*tau_0^b2)
Td = T * (c0 + c1*tau_0^c2)

% Función de transferencia del controlador
C = Kp * (1 + 1/(Ti*s) + (Td*s)/(0.1*Td*s + 1));

res_rope = analizar_control(C, Pp, 'controladores/orden1_sim.slx');
%%
%[text] ### Síntesis analítica
Ms = 1.2;  % Sensibilidad máxima deseada

% Cálculo de tau_c,min
k11 =  1.384 - 1.063*Ms + 0.262*Ms^2;
k12 = -1.915 + 1.415*Ms - 0.077*Ms^2;
k13 =  4.382 - 7.396*Ms + 3.000*Ms^2;

tau_c_min = k11 + (k12/k13)*tau_0;

%% Restricciones para tau_c
tau_c_lower = max(0.5, tau_c_min)
tau_c_upper = 1.50 + 0.3*tau_0

% Elección de tau_c (más robusto)
tau_c = 0.8;

% Formar parámetros
num = tau_c*(2 - tau_c) + tau_0;
Kp = num ./ ( K .* (tau_c + tau_0).^2 )
Ti = T * num ./ (1 + tau_0)
Td = 0;

C = Kp * (1 + 1/(Ti*s));

res_sintesis = analizar_control(C, Pp, 'controladores/orden1_sim.slx');
%%
%[text] ### Brambilla (1989)
%[text] p. 112
lambda = 0.5*(T)

Kp =  (T + 0.5*L) / (K * (lambda + L))
Ti = T + 0.5*L
Td = (T * L) / (2*T + L)

C = Kp * (1 + 1/(Ti*s) + (Td*s)/(0.1*Td*s + 1));

res_brambilla = analizar_control(C, Pp, 'controladores/orden1_sim.slx');
%%
%[text] ### Diseño LGR discreto
Ts = 0.0265; % Tiempo de muestreo
z  = tf('z', Ts); % Variable discreta

% Planta z
Pz = (0.01895 * z^(-1)) / (1 - 0.9796 * z^(-1));

% Descomentar para abrir sisotool
% sisotool('controladores/discreto.mat');

% Controlador diseñado
C = 5.5 * (z-0.9796) / (z-1);

% Determinar robustez
Sz = feedback(1, C*Pz); 

% Análisis de magnitud
[mag, ~, w] = bode(Sz);  % Frecuencia en rad/s
mag = squeeze(mag);
w = squeeze(w);

% Calcular Ms y frecuencia
[Ms, idx] = max(mag);
w_Ms = w(idx); % Frecuencia en rad/s

% Graficar magnitud absoluta
figure;
semilogx(w, mag, 'b');
grid on;
xlabel('Frecuencia (rad/s)');
ylabel('|S(e^{j\\omega})| (abs)');

% Simular el resto
res_discreto = analizar_control(C, Pz, 'controladores/sim_discreto.slx');
%%
% Parámetros de simulación
Ts = 0.0265;                % Tiempo de muestreo
t_final = 1.6;              % Tiempo total de simulación
t = 0:Ts:t_final;           % Vector de tiempo

%% Definición de sistema en z
z = tf('z', Ts);

% Planta discreta
Pz = (0.01895 * z^(-1)) / (1 - 0.9796 * z^(-1));

% Controlador discreto
C = 5.5 * (z - 0.9796) / (z - 1);

%% Lazo cerrado
CP   = series(C, Pz);
T_yr = feedback(CP, 1);          % Y/R
T_ur = minreal(C / (1 + CP));    % U/R

%% Respuesta al escalón unitario
[y, t_out] = step(T_yr, t);      % salida
[u, ~]      = step(T_ur, t);     % señal de control
r           = ones(size(t_out)); % referencia

%% Cálculo del tiempo de asentamiento al 2%
y_final = y(end);                      % valor final
banda   = 0.02 * abs(y_final);         % 2% de tolerancia

idx_fuera = find(abs(y - y_final) > banda, 1, 'last');

if isempty(idx_fuera)
    t_a2 = t_out(1);
else
    if idx_fuera < length(t_out)
        t_a2 = t_out(idx_fuera + 1);
    else
        t_a2 = t_out(end);
    end
end

%% Gráfica
fig = figure;
h_ref = plot(t_out, r, 'r'); hold on;
h_y   = plot(t_out, y, 'b');
h_u   = plot(t_out, u, 'Color', '#800080');

% Línea vertical en gris (fuera de la leyenda)
h_xline = xline(t_a2, '--', 'Color', [0.5 0.5 0.5]);
set(h_xline, 'HandleVisibility', 'off');

% Punto en la señal de salida (fuera de la leyenda)
y_a2 = interp1(t_out, y, t_a2);
h_punto = plot(t_a2, y_a2, 'o', 'MarkerFaceColor', [0.5 0.5 0.5], ...
               'MarkerEdgeColor', [0.5 0.5 0.5]);
set(h_punto, 'HandleVisibility', 'off');

% Texto indicando el tiempo de asentamiento en gris
text(t_a2, y_a2, sprintf('  t_{a,2%%} = %.3f s', t_a2), ...
    'HorizontalAlignment', 'left', ...
    'VerticalAlignment',   'bottom', ...
    'FontSize', 10, ...
    'Color', [0.5 0.5 0.5]);

grid on;
xlabel('Tiempo (s)');
ylabel('Amplitud (%)');
legend([h_ref, h_y, h_u], ...
       {'Referencia', 'Salida y(k)', 'Control u(k)'}, ...
       'Location', 'Best');

set(fig, 'Units', 'inches');
fig.Position(3:4) = [3.5 2.5];
exportgraphics(fig, "salida_lgr.svg", 'ContentType', 'vector');

%%
% Tiempo para control regulatorio
t = [0:0.0001:10];

% Control regulatorio: salida
fig = figure;
% Referencia (rojo)
plot(t, res_rope.regulatorio.r2, 'r');
hold on;
% RoPe (verde)
plot(t, res_rope.regulatorio.y2, 'Color', '#50C878');
% Síntesis (morado)
plot(t, res_sintesis.regulatorio.y2, 'Color', '#800080');
% Brambilla (anaranjado)
plot(t, res_brambilla.regulatorio.y2, 'Color', '#FF4B00');
% Discreto (azul)
plot(t, res_discreto.regulatorio.y2, 'b');
% Perturbación (gris)
plot(t, res_rope.regulatorio.d2, 'Color', '#828282');
grid on;
xlabel('Tiempo (s)');
ylabel('Amplitud (%)');
legend('Referencia r(t)', ...
       'RoPe y(t)', ...
       'Síntesis y(t)', ...
       'Brambilla y(t)', ...  
       'Discreto y(k)', ...
       'Perturbación d(t)', ...
       'Location','southeast');

hold off;
% Exportar svg
set(fig, 'Units', 'inches');
fig.Position(3:4) = [3.5 2.5];
exportgraphics(fig, "y_reg.svg", 'ContentType', 'vector');


% Control regulatorio: señal de control
fig = figure;
% Referencia (rojo)
plot(t, res_rope.regulatorio.r2, 'r');
hold on;
% RoPe (verde)
plot(t, res_rope.regulatorio.u2, 'Color', '#50C878');
% Síntesis (morado)
plot(t, res_sintesis.regulatorio.u2, 'Color', '#800080');
% Brambilla (anaranjado)
plot(t, res_brambilla.regulatorio.u2, 'Color', '#FF4B00');
% Discreto (azul)
plot(t, res_discreto.regulatorio.u2, 'b');
% Perturbación (gris)
plot(t, res_rope.regulatorio.d2, 'Color', '#828282');
grid on;
xlabel('Tiempo (s)');
ylabel('Amplitud (%)');
legend('Referencia r(t)', ...
       'RoPe u(t)', ...
       'Síntesis u(t)', ...
       'Brambilla u(t)', ...
       'Discreto u(k)', ...
       'Perturbación d(t)', ...
       'Location','southeast');

hold off;
% Exportar svg
set(fig, 'Units', 'inches');
fig.Position(3:4) = [3.5 2.5];
exportgraphics(fig, "u_reg.svg", 'ContentType', 'vector');

% Tiempo para servo
t = [0:0.0001:7.9999];

% Servocontrol: salida
fig = figure;
% Referencia (rojo)
plot(t, res_rope.servocontrol.r1, 'r');
hold on;
% RoPe (verde)
plot(t, res_rope.servocontrol.y1, 'Color', '#50C878');
% Síntesis (morado)
plot(t, res_sintesis.servocontrol.y1, 'Color', '#800080');
% Brambilla (anaranjado)
plot(t, res_brambilla.servocontrol.y1, 'Color', '#FF4B00');
% Discreto (azul)
plot(t, res_discreto.servocontrol.y1, 'b');
grid on;
xlabel('Tiempo (s)');
ylabel('Amplitud (%)');
legend('Referencia r(t)', ...
       'RoPe y(t)', ...
       'Síntesis y(t)', ...
       'Brambilla y(t)', ... 
       'Discreto y(k)', ...
       'Location','southeast');

hold off;
% Exportar svg
set(fig, 'Units', 'inches');
fig.Position(3:4) = [3.5 2.5];
exportgraphics(fig, "y_servo.svg", 'ContentType', 'vector');

% Servocontrol: señal de control
fig = figure;
% Referencia (rojo)
plot(t, res_rope.servocontrol.r1, 'r');
hold on;
% RoPe (verde)
plot(t, res_rope.servocontrol.u1, 'Color', '#50C878');
% Síntesis (morado)
plot(t, res_sintesis.servocontrol.u1, 'Color', '#800080');
% Brambilla (anaranjado)
plot(t, res_brambilla.servocontrol.u1, 'Color', '#FF4B00');
% Discreto (azul)
plot(t, res_discreto.servocontrol.u1, 'b');
grid on;
xlabel('Tiempo (s)');
ylabel('Amplitud (%)');
legend('Referencia r(t)', ...
       'RoPe u(t)', ...
       'Síntesis u(t)', ...
       'Brambilla u(t)', ...
       'Discreto u(k)', ...
       'Location','southeast');

hold off;
% Exportar svg
set(fig, 'Units', 'inches');
fig.Position(3:4) = [3.5 2.5];
exportgraphics(fig, "u_servo.svg", 'ContentType', 'vector');

% Sensibilidad máxima
fig = figure;
semilogx(res_rope.robustez.w,     res_rope.robustez.mag); hold on;
semilogx(res_sintesis.robustez.w, res_sintesis.robustez.mag);
semilogx(res_brambilla.robustez.w,res_brambilla.robustez.mag);
semilogx(w, mag, 'b');

% marcar máximos
plot(res_rope.robustez.w_peak,     res_rope.robustez.Ms, 'o');
%text(res_rope.robustez.w_peak, res_rope.robustez.Ms, sprintf('Ms = %.3f', res_rope.robustez.Ms));
plot(res_sintesis.robustez.w_peak, res_sintesis.robustez.Ms, 'o');
%text(res_sintesis.robustez.w_peak, res_sintesis.robustez.Ms, sprintf('Ms = %.3f', res_sintesis.robustez.Ms));
plot(res_brambilla.robustez.w_peak,res_brambilla.robustez.Ms, 'o');
%text(res_brambilla.robustez.w_peak, res_brambilla.robustez.Ms, sprintf('Ms = %.3f', res_brambilla.robustez.Ms));
plot(w(end),mag(end), 'o');
%text(w(end), mag(end), sprintf('Ms = %.3f', mag(end)));

grid on;
xlabel('\\omega (rad/s)');
ylabel('|S(j\\omega)| (abs)');
legend('RoPe','Síntesis','Brambilla', 'Discreto','Location','best');

% Exportar svg
set(fig, 'Units', 'inches');
fig.Position(3:4) = [3.5 2.5];
exportgraphics(fig, "m_s.svg", 'ContentType', 'vector');
%%
function resultados = analizar_control(C, Pp, simFile)
% Ejecuta la simulación y calcula índices de desempeño.
%
%   - C      : controlador (en dominio s)
%   - Pp     : planta nominal (modelo del proceso)
%   - simFile: path al modelo de Simulink
%   - tag    : identificador

    % Ejecución del Simulink
    out = sim(simFile,'StartTime','0','StopTime','40','FixedStep','0.0001');

    t = out.sistema.Time;
    d = out.sistema.Data(:,1);
    u = out.sistema.Data(:,2);
    r = out.sistema.Data(:,3);
    y = out.sistema.Data(:,4);

    % Visualizar salida completa
    figure
    plot(t,u,t,r,t,d,t,y);
    legend('u','r','d','y')
    xlabel('Tiempo (s)')
    ylabel('Amplitud')
    grid on;

    %% Sensibilidad máxima (robustez)
    Lr = C*Pp;
    S  = feedback(1, Lr);

    w = logspace(-3, 3, 2000); % Barrido de frecuencias
    [mag, ~] = bode(S, w);
    mag = squeeze(mag);

    % Guardar datos de robustez en la estructura
    resultados.robustez.S      = S;
    resultados.robustez.w      = w;      % vector de frecuencias
    resultados.robustez.mag    = mag;    % |S(jw)| en valor absoluto

    % Buscar el máximo
    [Ms, idx] = max(mag);
    w_peak = w(idx);

    resultados.robustez.Ms     = Ms;
    resultados.robustez.w_peak = w_peak;

    % Gráfica de la sensibilidad (individual)
    fig2 = figure;
    semilogx(w, mag); grid on;
    xlabel('\\omega (rad/s)');
    ylabel('|S(j\\omega)| (abs)');
    hold on;
    semilogx(w_peak, Ms, 'o');
    text(w_peak, Ms, sprintf('Ms = %.3f', Ms));

    %% Servocontrol
    t1 = t(40001:120000)-4;
    r1 = r(40001:120000);
    u1 = u(40001:120000);
    y1 = y(40001:120000);

    y1_final = y1(end);

    IAEr  = trapz(t1,abs(r1-y1));
    TVur  = sum(abs(diff(u1)));
    Umaxr = max(abs(max(u1)),abs(min(u1)));

    % Tiempo de asentamiento al 2%
    tol_r = 0.02 * abs(y1_final);  % banda ±2%
    err_r = abs(y1 - y1_final);    % error respecto al valor final

    idx_last_out_r = find(err_r > tol_r, 1, 'last');  % último punto fuera de la banda

    if isempty(idx_last_out_r)
        % Nunca salió de la banda
        ta2r = 0;
    else
        idx_ta2_r = min(idx_last_out_r + 1, numel(t1));  % siguiente muestra
        ta2r      = t1(idx_ta2_r) - 1;                   % relativo al escalón
    end

    y_pico = max(abs(max(y1)), abs(min(y1)));
    ind_pico = find(abs(y1-y_pico)<0.001,1);
    t_pico = t1(ind_pico) - 1;
    Mp = 100*(y1(ind_pico)-y1_final)/y1_final;
    e_permr = r1(end) - y1_final;

    % Guardar en estructura
    resultados.servocontrol.IAE    = IAEr;
    resultados.servocontrol.TV_u   = TVur;
    resultados.servocontrol.Umax   = Umaxr;
    resultados.servocontrol.ta2    = ta2r;
    resultados.servocontrol.t_pico = t_pico;
    resultados.servocontrol.Mp     = Mp;
    resultados.servocontrol.e_perm = e_permr;
    resultados.servocontrol.y1     = y1;
    resultados.servocontrol.u1     = u1;
    resultados.servocontrol.r1     = r1;

    % Graficar servocontrol
    fig1 = figure;
    plot(t1, y1);
    hold on;
    plot(t1, r1, 'r');
    plot(t1, u1, 'Color', '#800080');
    grid on;
    xlabel('Tiempo (s)');
    ylabel('Amplitud (%)');
    legend('Salida y(t)','Referencia r(t)','Control u(t)');
    hold off;

    %% Control regulatorio
    t2 = t(190001:290001) - 19;
    r2 = r(190001:290001);
    u2 = u(190001:290001);
    y2 = y(190001:290001);
    d2 = d(190001:290001);
    e2 = r2 - y2;

    y2_final   = r2(end);
    u2_inicial = u2(1);

    IAEd = trapz(t2,abs(r2-y2));
    TVud = sum(abs(diff(u2)));

    [Upos, ind_pos] = max(u2);
    [Uneg, ind_neg] = min(u2);

    dUpos = Upos - u2_inicial;
    dUneg = Uneg - u2_inicial;

    if abs(dUpos) >= abs(dUneg)
        Umaxd     = abs(dUpos);
        Umax_val  = Upos;
        ind_Umaxd = ind_pos;
    else
        Umaxd     = abs(dUneg);
        Umax_val  = Uneg;
        ind_Umaxd = ind_neg;
    end

    [~, ind_Emaxd] = max(abs(e2));
    Emax_val = e2(ind_Emaxd);
    Emaxd    = abs(Emax_val);
    t_Emaxd  = t2(ind_Emaxd) - 1;

    e_permd = r2(end) - y2_final;

    % Guardar
    resultados.regulatorio.IAE    = IAEd;
    resultados.regulatorio.TV_u   = TVud;
    resultados.regulatorio.Umax   = Umaxd;
    resultados.regulatorio.Emax   = Emaxd;
    resultados.regulatorio.t_Emax = t_Emaxd;
    resultados.regulatorio.e_perm = e_permd;
    resultados.regulatorio.y2     = y2;
    resultados.regulatorio.u2     = u2;
    resultados.regulatorio.r2     = r2;
    resultados.regulatorio.d2     = d2;

    % Graficar regulatorio
    fig2 = figure;
    plot(t2, y2);
    hold on;
    plot(t2, r2, 'r');
    plot(t2, u2, 'Color', '#800080');
    plot(t2, d2, 'Color', '#2E6F40');
    grid on;
    xlabel('Tiempo (s)');
    ylabel('Amplitud (%)');
    legend('Salida y(t)','Referencia r(t)','Control u(t)', 'Perturbación d(t)', 'Location', 'southeast');
    hold off;

    % Imprimir resultados
    fprintf('\n[Robustez]\n');
    fprintf('Ms (sensibilidad máxima)      : %.3f\n', Ms);
    fprintf('Frecuencia de pico            : %.3f rad/s\n', w_peak);

    fprintf('\n[Servocontrol]\n');
    fprintf('IAE               : %.4f\n', IAEr);
    fprintf('TV_u              : %.4f\n', TVur);
    fprintf('Umax              : %.4f\n', Umaxr);
    fprintf('t_a2              : %.4f s\n', ta2r);
    fprintf('t_pico            : %.4f s\n', t_pico);
    fprintf('Mpn               : %.4f \n', Mp);
    fprintf('Error permanente  : %.4f\n', e_permr);

    fprintf('\n[Control regulatorio]\n');
    fprintf('IAE               : %.4f\n', IAEd);
    fprintf('TV_u              : %.4f\n', TVud);
    fprintf('Umax              : %.4f\n', Umaxd);
    fprintf('Emax              : %.4f\n', Emaxd);
    fprintf('t_{Emax}          : %.4f s\n', t_Emaxd);
    fprintf('Error permanente  : %.4f\n', e_permd);
end

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright","rightPanelPercent":41.7}
%---
