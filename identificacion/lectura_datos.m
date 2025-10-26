%[text] ## Identificación del proceso
%[text] Lectura y preprocesamiento de los datos
M = readmatrix('data/delta_20a60.csv');

% Extraer datos
t = M(550:end ,1);
t = t - t(1);
u = M(550:end ,2);
y = M(550:end ,3);

Ts = t(2) - t(1);

% Tomar promedio inicial
yi_prom = mean(y(1:241)); % Rango del csv
u_i = u(1);

% Ajustar a nivel inicial a 0
y = y - yi_prom;
u = u - u_i;

% Graficar
figure;
plot(t, y, 'r');
hold on;
plot(t, u, 'b');
hold off;
grid on;
xlabel('Tiempo (s)');
ylabel('Amplitud');
legend('Salida y(t)', 'Control u(t)');
%%
%[text] ### System Identification Toolbox
%[text] Modelo P2D: `98.07%`
%[text] Modelo P1D: `98.06%`
systemIdentification('identificacion/identificacion_sistema.sid');
%%
%[text] #### Simulación del modelo de System Identification Toolbox
% Modelo P2D
y_p2d = lsim(P2D, u, t);

% Graficar
figure;
plot(t, y_p2d, 'r');
hold on;
plot(t, y, 'y');
plot(t, u, 'b');
hold off;
grid on;
xlabel('Tiempo (s)');
ylabel('Amplitud');
legend('Modelo y(t) (P2D)', 'Salida y(t)', 'Control u(t)');

IAE = trapz(t,abs(y-y_p2d))
%%
%[text] ### Mínimos cuadrados
y_ls = y(242:end);
u_ls = u(242:end);
t_ls = t(242:end)-t(242);

% Regresores
Phi = [ ...
  [0;          y_ls(1:end-1)], ...   % y(k-1)
  [0;0;        y_ls(1:end-2)], ...   % y(k-2)
  [0;0;0;      y_ls(1:end-3)], ...   % y(k-3)
  [0;          u_ls(1:end-1)], ...   % u(k-1)
  [0;0;        u_ls(1:end-2)], ...   % u(k-2)
  [0;0;0;      u_ls(1:end-3)]  ...   % u(k-3)
];

theta = (Phi' * Phi) \ (Phi' * y_ls);

H_ls = tf([0, theta(4:end)'], [1, -theta(1:3)'], Ts, 'Variable', 'z^-1');

% Simulación del modelo obtenido con mínimos cuadrados
y_ls_sim = lsim(H_ls, u_ls, t_ls);

% Utilizando el mismo fit que System Identification Toolbox
validate_ls = iddata(y_ls, u_ls, Ts);
[~, fit] = compare(validate_ls, H_ls)

IAE = trapz(t_ls,abs(y_ls-y_ls_sim))

figure;
plot(t_ls, y_ls_sim, 'k');
hold on;
plot(t_ls, y_ls, 'r');
plot(t_ls, u_ls, 'b');
hold off;
grid on;
xlabel('Tiempo (s)');
ylabel('Amplitud');
legend('Modelo yls(t)', 'Salida y(t)', 'Control u(t)');
%%
%[text] ### Alfaro 123c: Dos puntos y tres puntos
%[text] Método de dos puntos: POMTM
deltaY = mean(y(500:771)) - mean(y(1:241));
deltaU = u(end) - u(1);

% Tiempo al 25%
ind_t25 = find(y_ls >= (0.25 * deltaY + mean(y(1:241))), 1, 'first');
t25 = t_ls(ind_t25);

% Tiempo al 75%
ind_t75 = find(y_ls >= (0.75 * deltaY + mean(y(1:241))), 1, 'first');
t75 = t_ls(ind_t75);

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
y_123c_sim = lsim(P_123c_1orden, u_ls, t_ls);

% Utilizando el mismo fit que System Identification Toolbox
[~, fit] = compare(validate_ls, P_123c_1orden)

IAE = trapz(t_ls,abs(y_ls-y_123c_sim))

% Graficar la simulación del modelo P123c
figure;
plot(t_ls, y_123c_sim, 'k');
hold on;
plot(t_ls, y_ls, 'r');
plot(t_ls, u_ls, 'b');
hold off;
grid on;
xlabel('Tiempo (s)');
ylabel('Amplitud');
legend('Modelo y123c(t)', 'Salida y(t)', 'Control u(t)');
%[text] Método de tres puntos: SOMTM con polos reales
% Tiempo al 50%
ind_t50 = find(y_ls >= (0.5 * deltaY + mean(y(1:241))), 1, 'first');
t50 = t_ls(ind_t50);

% Para Alfaro 123c de tres puntos
% Requiere a>0
a = (-0.6240 * t25 + 0.9866 * t50 - 0.3626 * t75) / (0.3533 * t25 - 0.7036 * t50 + 0.3503 * t75)
T1 = (t75 - t25) / (0.9866 + 0.8036 * a)
T2 = T1 * a
L = t75 - (1.3421 + 1.3455 * a) * T1

s = tf('s');
P_123c_2orden = (K * exp(-L*s)) / ((T1*s + 1)*(T2*s + 1));

% Simulación del modelo P123c
y_123c_sim = lsim(P_123c_2orden, u_ls, t_ls);

% Utilizando el mismo fit que System Identification Toolbox
[~, fit] = compare(validate_ls, P_123c_2orden)

IAE = trapz(t_ls,abs(y_ls-y_123c_sim))

% Graficar la simulación del modelo P123c
figure;
plot(t_ls, y_123c_sim, 'k');
hold on;
plot(t_ls, y_ls, 'r');
plot(t_ls, u_ls, 'b');
hold off;
grid on;
xlabel('Tiempo (s)');
ylabel('Amplitud');
legend('Modelo y123c(t)', 'Salida y(t)', 'Control u(t)');
%%
%[text] ### Stark: Método de tres puntos
deltaY = mean(y(500:771)) - mean(y(1:241));
deltaU = u(end) - u(1);

% Tiempo al 15%
ind_t15 = find(y_ls >= (0.15 * deltaY + mean(y(1:241))), 1, 'first');
t15 = t_ls(ind_t15);

% Tiempo al 45%
ind_t45 = find(y_ls >= (0.45 * deltaY + mean(y(1:241))), 1, 'first');
t45 = t_ls(ind_t45);

% Tiempo al 75%
ind_t75 = find(y_ls >= (0.75 * deltaY + mean(y(1:241))), 1, 'first');
t75 = t_ls(ind_t75);

% Parámetros del modelo POMTM
K = deltaY / deltaU

x = (t45 - t15) / (t75 - t15);
xi = (0.0805 - 5.547 * (0.475 - x)^2) / (x - 0.356)
f_xi = 2.6*xi - 0.6;
wn = f_xi / (t75 - t15)

T1 = (xi + sqrt(xi^2 - 1)) / wn
T2 = (xi - sqrt(xi^2 - 1)) / wn

L = t45 - (0.922 * (1.66)^xi) / wn

% Función de transferencia
s = tf('s');
P_stark = (K) / ((T1*s + 1)*(T2*s + 1));

% Simulación del modelo Stark
y_stark_sim = lsim(P_stark, u_ls, t_ls);

IAE = trapz(t_ls,abs(y_ls-y_stark_sim))


% Graficar la simulación del modelo Stark
figure;
plot(t_ls, y_stark_sim, 'k');
hold on;
plot(t_ls, y_ls, 'r');
plot(t_ls, u_ls, 'b');
hold off;
grid on;
xlabel('Tiempo (s)');
ylabel('Amplitud');
legend('Modelo y123c(t)', 'Salida y(t)', 'Control u(t)');

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright"}
%---
