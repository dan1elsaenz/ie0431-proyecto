%[text] ## Graficar datos experimentales con controladores
%[text] ### Kristiansson 2003
clear;
clc;

M = readmatrix('data/3-2_kristiansson.csv');

% Extraer datos
t = M(:, 1);
r = M(:, 2);
y = M(:, 3);
u = M(:, 4);

t1 = t(1:900);
r1 = r(1:900);
y1 = y(1:900);
u1 = u(1:900);

t2 = t(901:2000);
r2 = r(901:2000);
y2 = y(901:2000);
u2 = u(901:2000);


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
legend('Salida y(t)', 'Control u(t)', 'Referencia r(t)');

% Exportar svg
%set(fig1, 'Units', 'inches');
%fig1.Position(3:4) = [3.5 2.5]; % Ancho = 3.5 in, alto = 2.5 in
%exportgraphics(fig1, 'exp_kristiansson.svg', 'ContentType', 'vector');
%%
%[text] Cálculo de índices
IAEd1 = trapz(t,abs(r-y))
TVud1 = sum(abs(diff(u)))

min(y);
max(y);

u2_inicial = u2(1);
y2_final = 16;

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
e2 = r2 - y2;
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

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright"}
%---
