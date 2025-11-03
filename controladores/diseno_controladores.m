%[text] ## Diseño de controladores
%[text] **Modo de uso**
%[text] - Ejecute el primer bloque: Carga de parámetros del proceso.
%[text] - Seleccione el algoritmo de control que desea utilizar y ejecute ese bloque.
%[text] - Ejecute el último bloque para obtener la simulación separada en servocontrol y control regulatorio. \
%[text] El controlador diseñado está hecho para controlar un proceso de flujo de aire en el modo de operación de control regulatorio.
%[text] Modelo del proceso controlado y parámetros a partir de System Identification Toolbox:
clear;
clc;

s = tf('s');
K = 0.920379287458449;
L = 0.089649500000000;
T = 1.047866225848407;
a = 0.049017947318623 / 1.047866225848407;

tau_0 = L / T

P = (K * exp(-L * s)) / ((T*s + 1)*(a*T*s + 1));

% Aproximación de Padé para cálculo de robustez
P0 = K/((T*s+1)*(a*T*s+1));
P0.InputDelay = L;
N = 15;
Pp = pade(P0, N); % Reemplazar el retardo
%%
%[text] ### USORT1
%[text] *Optimal Robust Tuning for 1DoF PI/PID Control Unifying FOPDT/SOPDT Models*
%[text] PID
%[text] Para a = 0
a0 = 0.155;
a1 = 0.455;
a2 = -0.939;

b0 = -0.198;
b1 = 1.291;
b2 = 0.485;

c0 = 0.004;
c1 = 0.389;
c2 = 0.869;

Kp_0 = (a0 + a1 * tau_0^a2) / K
Ti_0 = (b0 + b1 * tau_0^b2) * T
Td_0 = (c0 + c1 * tau_0^c2) * T
%[text] Para a = 0.25
a0 = 0.228;
a1 = 0.336;
a2 = -1.057;

b0 = 0.095;
b1 = 1.165;
b2 = 0.517;

c0 = 0.104;
c1 = 0.414;
c2 = 0.758;

Kp_25 = (a0 + a1 * tau_0^a2) / K
Ti_25 = (b0 + b1 * tau_0^b2) * T
Td_25 = (c0 + c1 * tau_0^c2) * T
%[text] Interpolación
% Parámetros
Kp = ((Kp_25 - Kp_0)/(0.25)) * a + (Kp_25 - (Kp_25 - Kp_0)/(0.25) * 0.25)
Ti = ((Ti_25 - Ti_0)/(0.25)) * a + (Ti_25 - (Ti_25 - Ti_0)/(0.25) * 0.25)
Td = ((Td_25 - Td_0)/(0.25)) * a + (Td_25 - (Td_25 - Td_0)/(0.25) * 0.25)

% Función de transferencia del controlador
C = Kp*(1 + (Td*s)/(0.1*Td*s + 1) + 1/(Ti*s));
%%
%[text] PI
%[text] Para a = 0
a0 = 0.016;
a1 = 0.476;
a2 = -0.708;

b0 = -1.382;
b1 = 2.837;
b2 = 0.211;

Kp_0 = (a0 + a1 * tau_0^a2) / K
Ti_0 = (b0 + b1 * tau_0^b2) * T
%[text] Para a = 0.25
a0 = -0.053;
a1 = 0.507;
a2 = -0.513;

b0 = 0.866;
b1 = 0.790;
b2 = 0.520;

Kp_25 = (a0 + a1 * tau_0^a2) / K
Ti_25 = (b0 + b1 * tau_0^b2) * T
%[text] Interpolación
% Parámetros
Kp = ((Kp_25 - Kp_0)/(0.25)) * a + (Kp_25 - (Kp_25 - Kp_0)/(0.25) * 0.25)
Ti = ((Ti_25 - Ti_0)/(0.25)) * a + (Ti_25 - (Ti_25 - Ti_0)/(0.25) * 0.25)
Td = 0;

% Función de transferencia del controlador
C = Kp*(1 + 1/(Ti*s));
%%
%[text] ### RoPe
%[text] *Robust-Performance Tuning of 2DoF PI/PID Controllers for First- and Second-Order-Plus-Dead-Time Models*
%[text] Ms = 1.4
%[text] a = 0
a0 = 0.4103;
a1 = 0.2079;
a2 = 0.0081;

b0 = 0.0081;
b1 = 1.0860;
b2 = 0.5683;

c0 = 0.0131;
c1 = 0.3769;
c2 = 0.8989;

d0 = 0.6850;
d1 = 0.7141;
d2 = -0.0697;

Kp_0 = (a0 + a1*tau_0) / (K * (a2 + tau_0))
Ti_0 = T * (b0 + b1*tau_0^b2)
Td_0 = T * (c0 + c1*tau_0^c2)
beta_0 = d0 + d1*tau_0 + d2*tau_0^2
%[text] a = 0.25
a0 = 0.3810;
a1 = 0.1918;
a2 = 0.0010;

b0 = 0.2703;
b1 = 1.0230;
b2 = 0.5482;

c0 = 0.0866;
c1 = 0.4277;
c2 = 0.7427;

d0 = 0.5369;
d1 = 1.1420;
d2 = -0.2509;

Kp_25 = (a0 + a1*tau_0) / (K * (a2 + tau_0))
Ti_25 = T * (b0 + b1*tau_0^b2)
Td_25 = T * (c0 + c1*tau_0^c2)
beta_25 = d0 + d1*tau_0 + d2*tau_0^2
%[text] Interpolación
% Parámetros
Kp = ((Kp_25 - Kp_0)/(0.25)) * a + (Kp_25 - (Kp_25 - Kp_0)/(0.25) * 0.25)
Ti = ((Ti_25 - Ti_0)/(0.25)) * a + (Ti_25 - (Ti_25 - Ti_0)/(0.25) * 0.25)
Td = ((Td_25 - Td_0)/(0.25)) * a + (Td_25 - (Td_25 - Td_0)/(0.25) * 0.25)
beta = ((beta_25 - beta_0)/(0.25)) * a + (beta_25 - (beta_25 - beta_0)/(0.25) * 0.25)

% Función de transferencia del controlador
C = Kp * (1 + 1/(Ti*s) + (Td*s)/(0.1*Td*s + 1));
%%
%[text] ### Kristiansson 2003
% Cálculo de parámetros PID
Tm1 = sqrt(T * T * a);

xi_m = T*(a+1)/(2*Tm1);
Ms = 1.7;

% Parámetros
Kp = (2*xi_m*Tm1)/(K*L) * (1 - 1/Ms)
Ti = 2*xi_m*Tm1
Td =  Tm1/(2*xi_m)

% Función de transferencia del controlador
C = Kp * (1 + 1/(Ti*s) + (Td*s)/(0.1*Td*s + 1));
%%
%[text] ## Graficar respuestas del controlador
% Ejecución del Simulink
out = sim('controladores/sim_controladores.slx','StartTime','0','StopTime','30','FixedStep','0.01');

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
%[text] Sensibilidad máxima
% Robustez
Lr = C*Pp;
S  = feedback(1, Lr);

% Ms y frecuencia de pico
[Ms, w_peak] = getPeakGain(S)
%[text] Servocontrol
%% Vectores para servocontrol
t1 = t(401:1000)-4;
r1 = r(401:1000);
u1 = u(401:1000);
y1 = y(401:1000);

y1_final = 20;

% Índices de desempeño para servocontrol
IAEr = trapz(t1,abs(r1-y1))
TVur = sum(abs(diff(u1)))
Umaxr = max(abs(max(u1)),abs(min(u1)))

% Tiempo de asentamiento al 2%
y98 = 0.98*(y1_final);
y102 = 1.02*(y1_final);
ind_98 = find(abs(y1 - y98)<0.1,1,'last');
ind_102 = find(abs(y1 - y102)<0.1,1,'last');
ind_ta2 = max(ind_98,ind_102);
ta2 = t1(ind_ta2) - 1 % Resta tiempo antes de entrada

% Tiempo al pico
y_pico = max(abs(max(y1)), abs(min(y1)));
ind_pico = find(abs(y1-y_pico)<0.001,1);
t_pico = t1(ind_pico) - 1

% Sobrepaso máximo normalizado
Mp = 100*(y1(ind_pico)-y1_final)/y1_final

% Error permanente
e_permr = r1(length(r1)) - y1_final

% Graficar
fig1 = figure(2);
plt_y1 = plot(t1, y1);
hold on;
plt_r1 = plot(t1, r1, 'r');
plt_u1 = plot(t1, u1, 'Color', '#800080');
grid on;
xlabel('Tiempo (s)');
ylabel('Amplitud (%)');
legend('Salida y(t)','Referencia r(t)','Control u(t)');

% Marcar ta2%
%yline(y1(ind_ta2), '--', 'HandleVisibility', 'off');
%xline(t1(ind_ta2), '--', 'HandleVisibility', 'off');
%datatip(plt_y1, 'DataIndex', ind_ta2, 'Location','northeast');
%text(t1(ind_ta2),y1(ind_ta2)-1.5,'\leftarrow ta2%')

% Marcar tiempo al pico
%xline(t1(ind_pico), '--', 'HandleVisibility', 'off');
%datatip(plt_y1, 'DataIndex', ind_pico, 'Location','northwest');
%text(t1(ind_pico),y_pico-2,'\leftarrow tpico')

% Marcar sobrepaso máximo normalizado
%text(t1(ind_pico), y_pico,'\leftarrow Mpn')

% Datatip para Umax
%ind_Umaxr = find(abs(u1-Umaxr)<0.001,1);
%datatip(plt_u1, 'DataIndex', ind_Umaxr, 'Location','southeast');
%text(t1(ind_Umaxr)-11,Umaxr,'Umax \rightarrow')

hold off;

% Exportar svg
set(fig1, 'Units', 'inches');
fig1.Position(3:4) = [3.5 2.5]; % Ancho = 3.5 in, alto = 2.5 in
exportgraphics(fig1, 'servocontrol.svg', 'ContentType', 'vector');
%[text] Control regulatorio
% Vectores para control regulatorio
t2 = t(1401:2001) - 14; % Restar tiempo de servo
r2 = r(1401:2001);
u2 = u(1401:2001);
y2 = y(1401:2001);
d2 = d(1401:2001);
e2 = r2 - y2;

y2_final = y2(end);
u2_inicial = u2(1);

% Índices de desempeño para control regulatorio
IAEd = trapz(t2,abs(r2-y2))
TVud = sum(abs(diff(u2)))

% Cambio máximo de la señal de control
% Extremos absolutos superior e inferior
[Upos, ind_pos] = max(u2);
[Uneg, ind_neg] = min(u2);

% Desvíos respecto a u2_inicial
dUpos = Upos - u2_inicial;
dUneg = Uneg - u2_inicial;

% Elegir el extremo más grande
if abs(dUpos) >= abs(dUneg)
    Umaxd       = abs(dUpos)  % magnitud del desvío máximo
    Umax_val    = Upos;       % valor de la señal de control en ese extremo
    ind_Umaxd   = ind_pos;    % índice del extremo
else
    Umaxd       = abs(dUneg)
    Umax_val    = Uneg;
    ind_Umaxd   = ind_neg;
end

% Tiempo al error máximo y Emaxd
[~, ind_Emaxd] = max(abs(e2));
Emax_val = e2(ind_Emaxd);   % valor con signo
Emaxd    = abs(Emax_val)   % magnitud
t_Emaxd  = t2(ind_Emaxd)   % instante de tiempo

% Error permanente
e_permd = r2(length(r2)) - y2_final

% Tiempo de asentamiento al 2%
ind_98  = find(abs(y2 - 0.98*y2_final) < 0.01, 1, 'last');
ind_102 = find(abs(y2 - 1.02*y2_final) < 0.01, 1, 'last');

% Selección del índice de asentamiento
if isempty(ind_98) && isempty(ind_102)
    ta2 = NaN;                 % no se detectó asentamiento
elseif isempty(ind_98)
    ind_ta2 = ind_102;         % solo existe ind_102
elseif isempty(ind_102)
    ind_ta2 = ind_98;          % solo existe ind_98
else
    ind_ta2 = max(ind_98, ind_102);  % Tomar el último si ambos existen
end

ta2 = t2(ind_ta2) - 1

% Graficar
fig2 = figure(3);
plt_y2 = plot(t2, y2);
hold on;
plt_r2 = plot(t2, r2, 'r');
plt_u2 = plot(t2, u2, 'Color', '#800080');
plt_d2 = plot(t2, d2, 'Color', '#2E6F40');
grid on;
xlabel('Tiempo (s)');
ylabel('Amplitud (%)');
legend('Salida y(t)','Referencia r(t)','Control u(t)', 'Perturbación d(t)', 'Location', 'southeast');

% Marcar error máximo
%xline(t_Emaxd, '--', 'HandleVisibility', 'off');
%datatip(plt_y2, 'DataIndex', ind_Emaxd, 'Location','southeast');
%text(t_Emaxd,y2(ind_Emaxd),'\leftarrow Emax');
%text(t_Emaxd,y2(ind_Emaxd)-2,'\leftarrow tEmax');

% Marcar Umaxd
%datatip(plt_u2, 'DataIndex', ind_Umaxd, 'Location','southeast');
%text(t2(ind_Umaxd),-Umaxd+u2_inicial,'Umax \rightarrow');

% Marcar ta2%
%yline(y1(ind_ta2), '--', 'HandleVisibility', 'off');
%xline(t1(ind_ta2), '--', 'HandleVisibility', 'off');
%datatip(plt_y1, 'DataIndex', ind_ta2, 'Location','northeast');
%text(t1(ind_ta2),y1(ind_ta2)-1.5,'\leftarrow ta2%')

hold off;

% Exportar svg
set(fig2, 'Units', 'inches');
fig2.Position(3:4) = [3.5 2.5]; % Ancho = 3.5 in, alto = 2.5 in
exportgraphics(fig2, 'control_regulatorio.svg', 'ContentType', 'vector');

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright","rightPanelPercent":41.7}
%---
