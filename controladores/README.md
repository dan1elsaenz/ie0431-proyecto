# Resultados obtenidos para los controladores diseñados

Los resultados presentados corresponden a métricas estándar de evaluación de desempeño en sistemas de control, tanto en **servocontrol** como en **control regulatorio**, así como indicadores de **robustez**.
Los indicadores utilizados se muestran a continuación:

- $IAE$ (_Integral Absolute Error_): error acumulado en el tiempo.
- $TV_u$ (_Total Variation of control_): variación total de la señal de control, asociada al esfuerzo del actuador.
- $U_{\text{máx}}$: valor máximo alcanzado por la señal de control.
- $t_{a2}$: tiempo de asentamiento al 2 %.
- $t_{\text{pico}}$: instante en el que se alcanza el valor máximo de la respuesta.
- $M_{pn}$: sobrepaso máximo normalizado.
- $E_{\text{máx}}$: error máximo ante una perturbación.
- $t_{E_{\text{máx}}}$: tiempo en el que ocurre el error máximo dado por la perturbación.
- $e_{\text{perm}}$: error permanente.
- $M_s$: sensibilidad máxima (indicador de robustez).

---

## Método: **RoPe** – Controlador PID

### Parámetros del controlador

| Parámetro |    Valor |
| --------: | -------: |
|     $K_p$ |   1.6825 |
|     $T_i$ | 0.4279 s |
|     $T_d$ | 0.0757 s |

### Indicadores de desempeño – Servocontrol

| Indicador           |    Valor |
| ------------------- | -------: |
| $IAE_r$             |  14.1843 |
| $TV_{u,r}$          | 211.8826 |
| $U_{max,r}$         |      100 |
| $t_{a2,r}$          | 3.8731 s |
| $t_{\text{pico}}$   | 1.5412 s |
| $M_p$               |  18.8372 |
| $e_{\text{perm},r}$ |   0.0042 |

### Indicadores de desempeño – Control regulatorio

| Indicador           |    Valor |
| ------------------- | -------: |
| $IAE_d$             |   3.3032 |
| $TV_{u,d}$          |  13.9822 |
| $U_{max,d}$         |  11.7330 |
| $E_{max,d}$         |   2.5446 |
| $t_{Emax,d}$        | 0.7532 s |
| $e_{\text{perm},d}$ |        0 |

### Sensibilidad

| Indicador | Valor |
| --------- | ----: |
| $M_s$     | 1.222 |

---

## Método: **Síntesis Analítica** – Controlador PI

### Parámetros del controlador

| Parámetro |    Valor |
| --------: | -------: |
|     $K_p$ |   1.3684 |
|     $T_i$ | 1.0135 s |
|     $T_d$ |        0 |

### Indicadores de desempeño – Servocontrol

| Indicador           |    Valor |
| ------------------- | -------: |
| $IAE_r$             |  16.1524 |
| $TV_{u,r}$          |  40.4101 |
| $U_{max,r}$         |  31.0696 |
| $t_{a2,r}$          | 2.5947 s |
| $t_{\text{pico}}$   | 4.6273 s |
| $M_p$               |   0.0437 |
| $e_{\text{perm},r}$ |  −0.0039 |

### Indicadores de desempeño – Control regulatorio

| Indicador           |    Valor |
| ------------------- | -------: |
| $IAE_d$             |   7.4046 |
| $TV_{u,d}$          |  10.0133 |
| $U_{max,d}$         |  10.0068 |
| $E_{max,d}$         |   3.2679 |
| $t_{Emax,d}$        | 0.9853 s |
| $e_{\text{perm},d}$ |        0 |

### Sensibilidad

| Indicador |     Valor |
| --------- | --------: |
| $M_s$     | **1.158** |

---

## Método: **Brambilla** – Controlador PID

### Parámetros del controlador

| Parámetro |    Valor |
| --------: | -------: |
|     $K_p$ |   1.8356 |
|     $T_i$ | 1.1193 s |
|     $T_d$ | 0.0644 s |

### Indicadores de desempeño – Servocontrol

| Indicador           |    Valor |
| ------------------- | -------: |
| $IAE_r$             |  13.2998 |
| $TV_{u,r}$          | 191.8743 |
| $U_{max,r}$         |      100 |
| $t_{a2,r}$          | 2.2219 s |
| $t_{\text{pico}}$   | 4.1350 s |
| $M_p$               |   0.0433 |
| $e_{\text{perm},r}$ |  −0.0021 |

### Indicadores de desempeño – Control regulatorio

| Indicador           |    Valor |
| ------------------- | -------: |
| $IAE_d$             |   6.0944 |
| $TV_{u,d}$          |  10.0000 |
| $U_{max,d}$         |  10.0000 |
| $E_{max,d}$         |   2.7632 |
| $t_{Emax,d}$        | 0.9148 s |
| $e_{\text{perm},d}$ |        0 |

### Sensibilidad

| Indicador | Valor |
| --------- | ----: |
| $M_s$     | 1.170 |

---

## Método: **LGR Discreto** – Controlador PI

### Parámetros del controlador

| Parámetro |      Valor |
| --------: | ---------: |
|     $K_p$ |     5.3878 |
|     $K_i$ | 0.1122 s⁻¹ |

### Indicadores de desempeño – Servocontrol

| Indicador           |        Valor |
| ------------------- | -----------: |
| $IAE_r$             |   **5.2848** |
| $TV_{u,r}$          |     178.4697 |
| $U_{max,r}$         |          100 |
| $t_{a2,r}$          | **0.9625 s** |
| $t_{\text{pico}}$   |     2.0490 s |
| $M_p$               |   **0.0347** |
| $e_{\text{perm},r}$ |      −0.0002 |

### Indicadores de desempeño – Control regulatorio

| Indicador           |        Valor |
| ------------------- | -----------: |
| $IAE_d$             |   **2.3592** |
| $TV_{u,d}$          |      10.0000 |
| $U_{max,d}$         |      10.0000 |
| $E_{max,d}$         |   **1.2489** |
| $t_{Emax,d}$        | **0.5110 s** |
| $e_{\text{perm},d}$ |            0 |

### Sensibilidad

| Indicador |     Valor |
| --------- | --------: |
| $M_s$     | **1.055** |
