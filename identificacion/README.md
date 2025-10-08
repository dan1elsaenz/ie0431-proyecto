# Identificación experimental del sistema

Como primera parte del proyecto, se solicita implementar 4 métodos de
identificación experimental de lazo abierto para el proceso analizado de flujo
de aire. Los métodos utilizados fueron los siguientes:

- `System Identification Toolbox`
- Mínimos cuadrados
- Por definir
- Por definir

## `System Identification Toolbox`

Como primer método de identificación, se utilizó la herramiento de
identificación de sistemas implementada en MATLAB. Para ello, se analizó el
tipo de respuesta que se tiene al graficar los datos de `delta_20a60.csv`,
donde se observó (como primer propuesta) un sistema de primer orden con un
tiempo muerto reducido. La segunda propuesta del modelo, consiste en aumentar
la complejidad del modelo y agregar un polo adicional.

Se verificó que no existe la presencia de ceros en el proceso, pues al
incluirlos en el modelo, tenían un valor cercano a $$0$$. Asimismo, la
presencia de integradores redujeron considerablemente el _fit_ del modelo del
proceso respecto a los datos proporcionados, por lo que fueron descartados.

- **Propuesta 1:** Primer orden más tiempo muerto

$$P(s) = \frac{K_p}{1 + T_{p1}s} e^{-T_d s}$$

con $$K_p = 0.92044$$, $$T_{p1} = 1.0507$$ s, $$T_d = 0.13711$$ s.
Este presenta un _fit_ del $$98.06$$%.

- **Propuesta 2:** Segundo orden más tiempo muerto con polos reales.

$$P(s) = \frac{K_p}{(1 + T_{p1}s)(1 + T_{p2}s)} e^{-T_d s}$$

con $$K_p = 0.92038$$, $$T_{p1} = 1.0479$$ s, $$T_{p2} = 0.049018$$ s, $$T_d =
0.08965$$ s.
Este presenta un _fit_ del $$98.07$$%.

## Mínimos cuadrados
