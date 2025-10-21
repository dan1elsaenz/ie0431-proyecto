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
prom_inicio = mean(y(1:241)); % Rango del csv

% Ajustar a nivel inicial a 0
y = y - prom_inicio;
u = u - u(1);

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
%[text] #### Simulación del modelo
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
%%
%[text] ### Mínimos cuadrados
% for na = 1:3
%   for nb = 1:3
%     m = arx(data_prueba, [na nb 0]);
%     [~, fit] = compare(validate_ls, m);
%     na
%     nb
%     thisfit = fit(1)
%   end
% end
%[text] 
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

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright"}
%---
