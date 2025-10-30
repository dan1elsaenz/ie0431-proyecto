# Resultados obtenidos para los controladores diseñados

## Método: USORT1 – Controlador PI

- Parámetros del Controlador

| Parámetro |   Valor    |
| :-------: | :--------: |
|  $$K_p$$  | $$4.5333$$ |
|  $$T_i$$  | $$0.4742$$ |

- Indicadores de desempeño para servocontrol

| Indicador      | Descripción                            |        Valor |
| -------------- | -------------------------------------- | -----------: |
| $$IAE_r$$      | Índice integral del error absoluto     |  $$28.2658$$ |
| $$TV_{u,r}$$   | Variación total de la señal de control | $$211.3404$$ |
| $$U_{max,r}$$  | Valor máximo de la señal de control    |      $$100$$ |
| $$t_{a2}$$     | Tiempo de asentamiento (2 %)           | $$2.0500$$ s |
| $$t_{pico}$$   | Tiempo al pico máximo                  | $$1.2300$$ s |
| $$M_p$$        | Sobrepaso (%)                          |  $$42.8790$$ |
| $$e_{perm,r}$$ | Error permanente                       |        $$0$$ |

- Indicadores de control regulatorio

| Indicador      | Descripción                            |                       Valor |
| -------------- | -------------------------------------- | --------------------------: |
| $$IAE_d$$      | Índice integral del error absoluto     |                  $$1.0461$$ |
| $$TV_{u,d}$$   | Variación total de la señal de control |                 $$16.1611$$ |
| $$U_{max,d}$$  | Valor máximo de la señal de control    |                 $$13.0301$$ |
| $$E_{max,d}$$  | Error máximo                           |                  $$1.7740$$ |
| $$t_{Emax,d}$$ | Tiempo al error máximo                 |        $$0.4700 \text{ s}$$ |
| $$e_{perm,d}$$ | Error permanente                       | $$-7.1054 \times 10^{-15}$$ |

- Sensibilidad

| Indicador | Descripción         |      Valor |
| --------- | ------------------- | ---------: |
| $$M_s$$   | Sensibilidad máxima | $$1.7991$$ |

## Método: USORT1 - Controlador PID

- Parámetros del Controlador

| Parámetro |   Valor    |
| :-------: | :--------: |
|  $$K_p$$  | $$6.7931$$ |
|  $$T_i$$  | $$0.2478$$ |
|  $$T_d$$  | $$0.0755$$ |

- Indicadores de desempeño para servocontrol

| Indicador      | Descripción                            |        Valor |
| -------------- | -------------------------------------- | -----------: |
| $$IAE_r$$      | Índice integral del error absoluto     |  $$40.0006$$ |
| $$TV_{u,r}$$   | Variación total de la señal de control | $$316.3231$$ |
| $$U_{max,r}$$  | Valor máximo de la señal de control    |      $$100$$ |
| $$t_{a2}$$     | Tiempo de asentamiento (2 %)           | $$3.3600$$ s |
| $$t_{pico}$$   | Tiempo al pico máximo                  | $$1.4700$$ s |
| $$M_p$$        | Sobrepaso (%)                          |  $$63.6537$$ |
| $$e_{perm,r}$$ | Error permanente                       |        $$0$$ |

- Indicadores de control regulatorio

| Indicador      | Descripción                            |                       Valor |
| -------------- | -------------------------------------- | --------------------------: |
| $$IAE_d$$      | Índice integral del error absoluto     |                  $$0.5641$$ |
| $$TV_{u,d}$$   | Variación total de la señal de control |                 $$18.1641$$ |
| $$U_{max,d}$$  | Valor máximo de la señal de control    |                 $$13.2249$$ |
| $$E_{max,d}$$  | Error máximo                           |                  $$1.1598$$ |
| $$t_{Emax,d}$$ | Tiempo al error máximo                 |        $$0.3500 \text{ s}$$ |
| $$e_{perm,d}$$ | Error permanente                       | $$-7.1054 \times 10^{-15}$$ |

- Sensibilidad

| Indicador | Descripción         |      Valor |
| --------- | ------------------- | ---------: |
| $$M_s$$   | Sensibilidad máxima | $$1.7124$$ |

## Método: Kristiansson (2003) – Controlador PID

- Parámetros del Controlador

| Parámetro |   Valor    |
| :-------: | :--------: |
|  $$K_p$$  | $$5.4739$$ |
|  $$T_i$$  | $$1.0969$$ |
|  $$T_d$$  | $$0.0468$$ |

- Indicadores de desempeño para servocontrol

| Indicador      | Descripción                            |        Valor |
| -------------- | -------------------------------------- | -----------: |
| $$IAE_r$$      | Índice integral del error absoluto     |  $$25.2168$$ |
| $$TV_{u,r}$$   | Variación total de la señal de control | $$556.5712$$ |
| $$U_{max,r}$$  | Valor máximo de la señal de control    |      $$100$$ |
| $$t_{a2}$$     | Tiempo de asentamiento (2 %)           | $$3.3900$$ s |
| $$t_{pico}$$   | Tiempo al pico máximo                  | $$1.0400$$ s |
| $$M_p$$        | Sobrepaso (%)                          |  $$15.3569$$ |
| $$e_{perm,r}$$ | Error permanente                       |        $$0$$ |

- Indicadores de control regulatorio

| Indicador      | Descripción                            |                      Valor |
| -------------- | -------------------------------------- | -------------------------: |
| $$IAE_d$$      | Índice integral del error absoluto     |                 $$2.0052$$ |
| $$TV_{u,d}$$   | Variación total de la señal de control |                $$10.0079$$ |
| $$U_{max,d}$$  | Valor máximo de la señal de control    |                $$10.0039$$ |
| $$E_{max,d}$$  | Error máximo                           |                 $$1.4846$$ |
| $$t_{Emax,d}$$ | Tiempo al error máximo                 |       $$0.4600 \text{ s}$$ |
| $$e_{perm,d}$$ | Error permanente                       | $$-1.5010 \times 10^{-6}$$ |

- Sensibilidad

| Indicador | Descripción         |      Valor |
| --------- | ------------------- | ---------: |
| $$M_s$$   | Sensibilidad máxima | $$1.4774$$ |

## Método: Shamsuzzoha & Lee (2007) – Controlador PID

- Parámetros del Controlador

| Parámetro |   Valor    |
| :-------: | :--------: |
|  $$K_p$$  | $$7.4857$$ |
|  $$T_i$$  | $$0.3915$$ |
|  $$T_d$$  | $$0.0417$$ |

- Indicadores de desempeño para servocontrol

| Indicador      | Descripción                            |                  Valor |
| -------------- | -------------------------------------- | ---------------------: |
| $$IAE_r$$      | Índice integral del error absoluto     |            $$34.3585$$ |
| $$TV_{u,r}$$   | Variación total de la señal de control | $$1.3711\times10^{3}$$ |
| $$U_{max,r}$$  | Valor máximo de la señal de control    |                $$100$$ |
| $$t_{a2}$$     | Tiempo de asentamiento (2 %)           |           $$2.0500$$ s |
| $$t_{pico}$$   | Tiempo al pico máximo                  |           $$1.4500$$ s |
| $$M_p$$        | Sobrepaso (%)                          |            $$58.5748$$ |
| $$e_{perm,r}$$ | Error permanente                       |                  $$0$$ |

- Indicadores de control regulatorio

| Indicador      | Descripción                            |                       Valor |
| -------------- | -------------------------------------- | --------------------------: |
| $$IAE_d$$      | Índice integral del error absoluto     |                  $$0.5230$$ |
| $$TV_{u,d}$$   | Variación total de la señal de control |                 $$16.7375$$ |
| $$U_{max,d}$$  | Valor máximo de la señal de control    |                 $$13.3688$$ |
| $$E_{max,d}$$  | Error máximo                           |                  $$1.2520$$ |
| $$t_{Emax,d}$$ | Tiempo al error máximo                 |        $$0.3700 \text{ s}$$ |
| $$e_{perm,d}$$ | Error permanente                       | $$-7.1054 \times 10^{-15}$$ |

- Sensibilidad

| Indicador | Descripción         |      Valor |
| --------- | ------------------- | ---------: |
| $$M_s$$   | Sensibilidad máxima | $$1.8415$$ |
