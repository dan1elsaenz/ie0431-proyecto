%[text] ## Identificación del modelo del proceso
%[text] Lectura y preprocesamiento de los datos
M = readmatrix('delta_20a60.csv');

% Extraer datos
t = M(550:end, 1);
t = t - t(1);
u = M(550:end, 2);
y = M(550:end, 3);

Ts = t(2) - t(1);

% Tomar promedio inicial
yi_prom = mean(y(1:241)); % Rango del csv
yf_prom = mean(y(500:771));
u_i = u(1);

% Ajustar valores para gráficas
y_real = y(205:end) - yi_prom;
u_real = u(205:end) - u_i;

t_real = t(205:end)-t(205);
t_entrada = t(242) - t(205);

% Graficar
figure;
plot(t_real, y_real, 'r');
hold on;
plot(t_real, u_real, 'b');
hold off;
grid on;
xlabel('Tiempo (s)');
ylabel('Amplitud');
legend('Salida y(t)', 'Control u(t)', 'Location', 'southeast');
%%
%[text] ### System Identification Toolbox
%[text] Modelo P2D: `98.05%`
%[text] Modelo P1D: `98.04%`
systemIdentification('identificacion/identificacion_sistema.sid');
%%
%[text] Modelo SOMTM: Polos reales
% Modelo P2D
s = tf('s');
K = 0.920379287458449;
L = 0.089649500000000;
T = 1.047866225848407;
a = 0.049017947318623 / 1.047866225848407;
P2D = (K * exp(-L * s)) / ((T*s + 1)*(a*T*s + 1));


y_p2d_sim = lsim(P2D, u_real, t_real);

% Graficar
figure;
plot(t_real, y_p2d_sim, 'r');
hold on;
plot(t_real, y_real, 'y');
plot(t_real, u_real, 'b');
hold off;
grid on;
xlabel('Tiempo (s)');
ylabel('Amplitud');
legend('Modelo y(t) (P2D)', 'Salida y(t)', 'Control u(t)', 'Location','southeast');

% Índices integrales
IAE = trapz(t_real,abs(y_real-y_p2d_sim))
ISE = trapz(t_real, abs(y_real-y_p2d_sim).^2)
%%
%[text] ### Mínimos cuadrados
% Regresores
Phi = [ ...
  [0;          y_real(1:end-1)], ...   % y(k-1)
  [0;0;        y_real(1:end-2)], ...   % y(k-2)
  [0;          u_real(1:end-1)], ...   % u(k-1)
  [0;0;        u_real(1:end-2)]        % u(k-2)
];

% Coeficientes
theta = (Phi' * Phi) \ (Phi' * y_real);

H_ls = tf([0, theta(3:end)'], [1, -theta(1:2)'], Ts, 'Variable', 'z^-1');

% Simulación del modelo obtenido con mínimos cuadrados
y_ls_sim = lsim(H_ls, u_real, t_real);

% Índices integrales
IAE = trapz(t_real,abs(y_real-y_ls_sim))
ISE = trapz(t_real, abs(y_real-y_ls_sim).^2)

% Graficar
figure;
plot(t_real, y_ls_sim, 'k');
hold on;
plot(t_real, y_real, 'r');
plot(t_real, u_real, 'b');
hold off;
grid on;
xlabel('Tiempo (s)');
ylabel('Amplitud');
legend('Modelo y(t) (LS)', 'Salida y(t)', 'Control u(t)', 'Location','southeast');
%%
%[text] ### Alfaro 123c: Dos puntos y tres puntos
%[text] Método de dos puntos: POMTM
deltaY = yf_prom - yi_prom;
deltaU = u(end) - u_i;

% Tiempo al 25%
ind_t25 = find(y_real >= (0.25 * deltaY), 1, 'first');
t25 = t_real(ind_t25) - t_entrada;

% Tiempo al 75%
ind_t75 = find(y_real >= (0.75 * deltaY), 1, 'first');
t75 = t_real(ind_t75) - t_entrada;

% Para Alfaro 123c de dos puntos
ax = 0.910;
b = 1.262;

% Parámetros del modelo POMTM
K = deltaY / deltaU
tau = ax * (t75 - t25)
L = b * t25 + (1 - b) * t75

s = tf('s');
P_123c_1orden = (K * exp(-L*s)) / ((tau*s + 1));

% Simulación del modelo P123c
y_123c1_sim = lsim(P_123c_1orden, u_real, t_real);

% Índices integrales
IAE = trapz(t_real,abs(y_real-y_123c1_sim))
ISE = trapz(t_real, abs(y_real-y_123c1_sim).^2)

% Graficar la simulación del modelo P123c
figure;
plot(t_real, y_123c1_sim, 'k');
hold on;
plot(t_real, y_real, 'r');
plot(t_real, u_real, 'b');
hold off;
grid on;
xlabel('Tiempo (s)');
ylabel('Amplitud');
legend('Modelo y(t) (123c)', 'Salida y(t)', 'Control u(t)', 'Location','southeast');
%[text] Método de tres puntos: SOMTM con polos reales
% Tiempo al 50%
ind_t50 = find(y_real >= (0.5 * deltaY), 1, 'first');
t50 = t_real(ind_t50) - t_entrada;

% Para Alfaro 123c de tres puntos
% Requiere 0<a<1
a = (-0.6240 * t25 + 0.9866 * t50 - 0.3626 * t75) / (0.3533 * t25 - 0.7036 * t50 + 0.3503 * t75)
T1 = (t75 - t25) / (0.9866 + 0.8036 * a)
T2 = T1 * a
L = t75 - (1.3421 + 1.3455 * a) * T1

s = tf('s');
P_123c_2orden = (K * exp(-L*s)) / ((T1*s + 1)*(T2*s + 1));

% Simulación del modelo P123c
y_123c2_sim = lsim(P_123c_2orden, u_real, t_real);

% Índices integrales
IAE = trapz(t_real,abs(y_real-y_123c2_sim))
ISE = trapz(t_real, abs(y_real-y_123c2_sim).^2)

% Graficar
figure;
plot(t_real, y_123c2_sim, 'k');
hold on;
plot(t_real, y_real, 'r');
plot(t_real, u_real, 'b');
hold off;
grid on;
xlabel('Tiempo (s)');
ylabel('Amplitud');
legend('Modelo y(t) (123c)', 'Salida y(t)', 'Control u(t)', 'Location','southeast');
%%
%[text] ### Ho
deltaY = yf_prom - yi_prom;
deltaU = u(end) - u_i;

% Tiempo al 35%
ind_t35 = find(y_real >= (0.35 * deltaY), 1, 'first');
t35 = t_real(ind_t35) - t_entrada;

% Tiempo al 85%
ind_t85 = find(y_real >= (0.85 * deltaY), 1, 'first');
t85 = t_real(ind_t85) - t_entrada;

% Para Ho et al de dos puntos
ax = 0.670;
b = 1.290;

% Parámetros del modelo POMTM
K = deltaY / deltaU
tau = ax * (t85 - t35)
L = b * t35 + (1 - b) * t85

s = tf('s');
P_ho = (K * exp(-L*s)) / ((tau*s + 1));

% Simulación del modelo P_ho
y_ho_sim = lsim(P_ho, u_real, t_real);

% Índices integrales
IAE = trapz(t_real,abs(y_real-y_ho_sim))
ISE = trapz(t_real, abs(y_real-y_ho_sim).^2)

% Graficar la simulación del modelo P_ho
figure;
plot(t_real, y_ho_sim, 'k');
hold on;
plot(t_real, y_real, 'r');
plot(t_real, u_real, 'b');
hold off;
grid on;
xlabel('Tiempo (s)');
ylabel('Amplitud');
legend('Modelo y(t) (Ho)', 'Salida y(t)', 'Control u(t)');
%%
%[text] ## Graficar todos los modelos juntos
%[text] Se les vuelve a sumar el *offset* inicial para tener la respuesta del 20% al 60%
fig = figure;
plot(t_real, y_real+yi_prom, 'Color', '#828282', 'LineWidth', 1.25); % Datos reales
hold on;
% Graficar la simulación de todos los modelos
plot(t_real, y_p2d_sim+yi_prom, 'r');                  % System Identification Toolbox
plot(t_real, y_123c1_sim+yi_prom, 'Color', '#800080'); % 123c primer orden
plot(t_real, y_ls_sim+yi_prom, 'Color', '#50C878');    % Mínimos cuadrados
plot(t_real, y_ho_sim+yi_prom, 'b');                   % Ho et al.
plot(t_real, u_real+u_i, 'Color', '#FF4B00');
hold off;
grid on;
xlabel('Tiempo (s)');
ylabel('Amplitud (%)');
legend('Proceso y(t)', 'Modelo ySIT(t)', 'Modelo y123c(t)', ...
      'Modelo yLS(t)', 'Modelo yHo(t)', 'Entrada u(t)', 'Location','southeast');

% Exportar svg
set(fig, 'Units', 'inches');
fig.Position(3:4) = [3.5 2.5]; % Ancho = 3.5 in, alto = 2.5 in
exportgraphics(fig, 'identificacion_modelos.svg', 'ContentType', 'vector');

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright"}
%---
