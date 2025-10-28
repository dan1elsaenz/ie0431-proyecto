# Identificación experimental del sistema

Como primera parte del proyecto, se solicita implementar 4 métodos de
identificación experimental de lazo abierto para el proceso analizado de flujo
de aire. Los métodos utilizados fueron los siguientes:

- `System Identification Toolbox`
- Mínimos cuadrados (_least square_)
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

$$P(s) = \frac{K}{1 + T_{p1}s} e^{-L s}$$

con $$K = 0.92044$$, $$T_{p1} = 1.0507$$ s, $$L = 0.13711$$ s.
Este presenta un _fit_ del $$98.06$$%.

- **Propuesta 2:** Segundo orden más tiempo muerto con polos reales.

$$P(s) = \frac{K}{(1 + T_{p1}s)(1 + T_{p2}s)} e^{-L s}$$

con $$K = 0.92038$$, $$T_{p1} = 1.0479$$ s, $$T_{p2} = 0.049018$$ s, $$L =
0.08965$$ s.
Este presenta un _fit_ del $$98.07$$%.

## Mínimos cuadrados

Con este método se obtiene un modelo del proceso discreto. Se seleccionó un
modelo de tercer orden (tres polos y tres ceros). La función de transferencia
obtenida es:

$$
P(s) = \frac{0.004304 z^{-1} - 0.0036 z^{-2} + 0.02427 z^{-3}}{1 - 0.5794
z^{-1} - 0.5366 z^{-2} + 0.1429 z^{-3}}
$$

Este presenta un _fit_ del $$91.9963$$%.

> [!NOTE]
> Consultar si la complejidad de este modelo supera la indicada en el
> enunciado (**de orden reducido**).
