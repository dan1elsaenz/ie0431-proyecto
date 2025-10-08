%[text] ## Identificación del proceso
%[text] Lectura y preprocesamiento de los datos
M = readmatrix('data/delta_20a60.csv');

% Extraer datos
t = M(550:end ,1);
t = t - t(1);
u = M(550:end ,2);
y = M(550:end ,3);

% Tomar promedio inicial
prom_inicio = mean(y(1:241));

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
systemIdentification('identificacion/identificacion_sistema.sid');

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright"}
%---
