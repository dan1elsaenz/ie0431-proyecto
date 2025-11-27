%[text] ## Graficar datos experimentales con controladores
%[text] En este documento, se grafican los datos experimentales de la prueba de controladores y se analizan las especificaciones de interés de cada uno.
%[text] ### RoPe
clear;
clc;

M = readmatrix('exp/3-2_rope.csv');

% Extraer datos (25 s)
t = M(1:1919, 1);
t = t - t(1);
r = M(1:1919, 2);
y = M(1:1919, 3);
u = M(1:1919, 4);

% Graficar
fig1 = figure;
plot(t, y);
hold on;
plot(t, u, 'Color', '#800080');
plot(t, r, 'r')
hold off;
grid on;
xlabel('Tiempo (s)');
ylabel('Amplitud (%)');
legend('Salida y(t)', 'Control u(t)', 'Referencia r(t)', 'Location', 'best');

% Exportar svg
set(fig1, 'Units', 'inches');
fig1.Position(3:4) = [3.5 2.5]; % Ancho = 3.5 in, alto = 2.5 in
exportgraphics(fig1, 'exp_rope.svg', 'ContentType', 'vector');

% Especificaciones
e = r - y;

idx1 = t >= 0 & t <= 10;  % Perturbación 1
idx2 = t >= 15 & t <= 25; % Perturbación 2

% IAE
IAE_d1 = trapz(t(idx1), abs(e(idx1)))
IAE_d2 = trapz(t(idx2), abs(e(idx2)))

% Error máximo
Emax1 = max(abs(e(idx1)))
Emax2 = max(abs(e(idx2)))

% Esfuerzo de control
TVu1 = sum(abs(diff(u(idx1))))
TVu2 = sum(abs(diff(u(idx2))))

% Señal de control máxima
Umax1 = abs(max(u(idx1)) - u(1))
Umax2 = abs(min(u(idx2)) - u(1163)) % Desde 15 s
%%
%[text] ### Síntesis
clear;
clc;

M = readmatrix('exp/3-2_sintesis.csv');

% Extraer datos (25 s)
t = M(1:1462, 1);
t = t - t(1);
r = M(1:1462, 2);
y = M(1:1462, 3);
u = M(1:1462, 4);

% Graficar
fig1 = figure;
plot(t, y);
hold on;
plot(t, u, 'Color', '#800080');
plot(t, r, 'r')
hold off;
grid on;
xlabel('Tiempo (s)');
ylabel('Amplitud (%)');
legend('Salida y(t)', 'Control u(t)', 'Referencia r(t)', 'Location', 'best');

% Exportar svg
set(fig1, 'Units', 'inches');
fig1.Position(3:4) = [3.5 2.5]; % Ancho = 3.5 in, alto = 2.5 in
exportgraphics(fig1, 'exp_sintesis.svg', 'ContentType', 'vector');

% Especificaciones
e = r - y;

idx1 = 2 >= 0 & t <= 12; % Perturbación 1
idx2 = t >= 15 & t <= 25; % Perturbación 2

% IAE
IAE_d1 = trapz(t(idx1), abs(e(idx1)))
IAE_d2 = trapz(t(idx2), abs(e(idx2)))

% Error máximo
Emax1 = max(abs(e(idx1)))
Emax2 = max(abs(e(idx2)))

% Esfuerzo de control
TVu1 = sum(abs(diff(u(idx1))))
TVu2 = sum(abs(diff(u(idx2))))

% Señal de control máxima
Umax1 = abs(max(u(idx1)) - u(116)) % Desde 2 s
Umax2 = abs(min(u(idx2)) - u(883)) % Desde 15 s
%%
%[text] ### Brambilla
clear;
clc;

M = readmatrix('exp/3-2_brambilla.csv');

% Extraer datos (25 s)
t = M(1:1785, 1);
t = t - t(1);
r = M(1:1785, 2);
y = M(1:1785, 3);
u = M(1:1785, 4);

% Graficar
fig1 = figure;
plot(t, y);
hold on;
plot(t, u, 'Color', '#800080');
plot(t, r, 'r')
hold off;
grid on;
xlabel('Tiempo (s)');
ylabel('Amplitud (%)');
legend('Salida y(t)', 'Control u(t)', 'Referencia r(t)', 'Location', 'best');

% Exportar svg
set(fig1, 'Units', 'inches');
fig1.Position(3:4) = [3.5 2.5]; % Ancho = 3.5 in, alto = 2.5 in
exportgraphics(fig1, 'exp_brambilla.svg', 'ContentType', 'vector');

% Especificaciones
e = r - y;

idx1 = t >= 0 & t <= 10; % Perturbación 1
idx2 = t >= 10 & t <= 20; % Perturbación 2

% IAE
IAE_d1 = trapz(t(idx1), abs(e(idx1)))
IAE_d2 = trapz(t(idx2), abs(e(idx2)))

% Error máximo
Emax1 = max(abs(e(idx1)))
Emax2 = max(abs(e(idx2)))

% Esfuerzo de control
TVu1 = sum(abs(diff(u(idx1))))
TVu2 = sum(abs(diff(u(idx2))))

% Señal de control máxima
Umax1 = (max(u(idx1)) - u(1))
Umax2 = abs(min(u(idx2)) - u(732)) % Desde 10 s

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright"}
%---
