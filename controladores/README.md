# Resultados obtenidos para los controladores diseñados

Los resultados presentados corresponden a métricas estándar de evaluación de desempeño en sistemas de control, tanto en **servocontrol** como en **control regulatorio**, así como indicadores de **robustez**.
Los indicadores utilizados se muestran a continuación:

- \(IAE\) (_Integral Absolute Error_): error acumulado en el tiempo.
- \(TV*u\) (\_Total Variation of control*): variación total de la señal de control, asociada al esfuerzo del actuador.
- \(U\_{\text{máx}}\): valor máximo alcanzado por la señal de control.
- \(t\_{a2}\): tiempo de asentamiento al 2 %.
- \(t\_{\text{pico}}\): instante en el que se alcanza el valor máximo de la respuesta.
- \(M\_{pn}\): sobrepaso máximo normalizado.
- \(E\_{\text{máx}}\): error máximo ante una perturbación.
- \(t*{E*{\text{máx}}}\): tiempo en el que ocurre el error máximo dado por la perturbación.
- \(e\_{\text{perm}}\): error permanente.
- \(M_s\): sensibilidad máxima (indicador de robustez).

---

## Método: **RoPe** – Controlador PID

### Parámetros del controlador

| Parámetro |    Valor |
| --------: | -------: |
|   \(K_p\) |   1.6825 |
|   \(T_i\) | 0.4279 s |
|   \(T_d\) | 0.0757 s |

### Indicadores de desempeño – Servocontrol

| Indicador       |    Valor |
| --------------- | -------: |
| \(IAE_r\)       |  14.1843 |
| \(TV\_{u,r}\)   | 211.8826 |
| \(U\_{max,r}\)  |      100 |
| \(t\_{a2,r}\)   | 3.8731 s |
| \(t\_{pico}\)   | 1.5412 s |
| \(M_p\)         |  18.8372 |
| \(e\_{perm,r}\) |   0.0042 |

### Indicadores de desempeño – Control regulatorio

| Indicador       |    Valor |
| --------------- | -------: |
| \(IAE_d\)       |   3.3032 |
| \(TV\_{u,d}\)   |  13.9822 |
| \(U\_{max,d}\)  |  11.7330 |
| \(E\_{max,d}\)  |   2.5446 |
| \(t\_{Emax,d}\) | 0.7532 s |
| \(e\_{perm,d}\) |        0 |

### Sensibilidad

| Indicador | Valor |
| --------- | ----: |
| \(M_s\)   | 1.222 |

## Método: **Síntesis Analítica** – Controlador PI

### Parámetros del controlador

| Parámetro |    Valor |
| --------: | -------: |
|   \(K_p\) |   1.3684 |
|   \(T_i\) | 1.0135 s |
|   \(T_d\) |        0 |

### Indicadores de desempeño – Servocontrol

| Indicador       |    Valor |
| --------------- | -------: |
| \(IAE_r\)       |  16.1524 |
| \(TV\_{u,r}\)   |  40.4101 |
| \(U\_{max,r}\)  |  31.0696 |
| \(t\_{a2,r}\)   | 2.5947 s |
| \(t\_{pico}\)   | 4.6273 s |
| \(M_p\)         |   0.0437 |
| \(e\_{perm,r}\) |  −0.0039 |

### Indicadores de desempeño – Control regulatorio

| Indicador       |    Valor |
| --------------- | -------: |
| \(IAE_d\)       |   7.4046 |
| \(TV\_{u,d}\)   |  10.0133 |
| \(U\_{max,d}\)  |  10.0068 |
| \(E\_{max,d}\)  |   3.2679 |
| \(t\_{Emax,d}\) | 0.9853 s |
| \(e\_{perm,d}\) |        0 |

### Sensibilidad

| Indicador |     Valor |
| --------- | --------: |
| \(M_s\)   | **1.158** |

## Método: **Brambilla** – Controlador PID

### Parámetros del controlador

| Parámetro |    Valor |
| --------: | -------: |
|   \(K_p\) |   1.8356 |
|   \(T_i\) | 1.1193 s |
|   \(T_d\) | 0.0644 s |

### Indicadores de desempeño – Servocontrol

| Indicador       |    Valor |
| --------------- | -------: |
| \(IAE_r\)       |  13.2998 |
| \(TV\_{u,r}\)   | 191.8743 |
| \(U\_{max,r}\)  |      100 |
| \(t\_{a2,r}\)   | 2.2219 s |
| \(t\_{pico}\)   | 4.1350 s |
| \(M_p\)         |   0.0433 |
| \(e\_{perm,r}\) |  −0.0021 |

### Indicadores de desempeño – Control regulatorio

| Indicador       |    Valor |
| --------------- | -------: |
| \(IAE_d\)       |   6.0944 |
| \(TV\_{u,d}\)   |  10.0000 |
| \(U\_{max,d}\)  |  10.0000 |
| \(E\_{max,d}\)  |   2.7632 |
| \(t\_{Emax,d}\) | 0.9148 s |
| \(e\_{perm,d}\) |        0 |

### Sensibilidad

| Indicador | Valor |
| --------- | ----: |
| \(M_s\)   | 1.170 |

## Método: **LGR Discreto** – Controlador PI

### Parámetros del controlador

| Parámetro |      Valor |
| --------: | ---------: |
|   \(K_p\) |     5.3878 |
|   \(K_i\) | 0.1122 s⁻¹ |

### Indicadores de desempeño – Servocontrol

| Indicador       |        Valor |
| --------------- | -----------: |
| \(IAE_r\)       |   **5.2848** |
| \(TV\_{u,r}\)   |     178.4697 |
| \(U\_{max,r}\)  |          100 |
| \(t\_{a2,r}\)   | **0.9625 s** |
| \(t\_{pico}\)   |     2.0490 s |
| \(M_p\)         |   **0.0347** |
| \(e\_{perm,r}\) |      −0.0002 |

### Indicadores de desempeño – Control regulatorio

| Indicador       |        Valor |
| --------------- | -----------: |
| \(IAE_d\)       |   **2.3592** |
| \(TV\_{u,d}\)   |      10.0000 |
| \(U\_{max,d}\)  |      10.0000 |
| \(E\_{max,d}\)  |   **1.2489** |
| \(t\_{Emax,d}\) | **0.5110 s** |
| \(e\_{perm,d}\) |            0 |

### Sensibilidad

| Indicador |     Valor |
| --------- | --------: |
| \(M_s\)   | **1.055** |
