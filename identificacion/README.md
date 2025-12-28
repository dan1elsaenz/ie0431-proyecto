# Identificación experimental del sistema

Como primera parte del proyecto, se solicitó implementar **cuatro métodos de
identificación experimental de lazo abierto** para el proceso analizado de
flujo de aire en una cabina de bioseguridad. El objetivo fue obtener **modelos
de orden reducido** que representen adecuadamente el comportamiento del proceso
en el rango de operación establecido (20 % – 60 %).

Los métodos de identificación utilizados fueron los siguientes:

- _System Identification Toolbox_ (MATLAB)
- Método 123c de Alfaro
- Método de Ho et al. (1995)
- Mínimos cuadrados (_least squares_) en tiempo discreto

---

## `System Identification Toolbox`

Como primer método de identificación, se utilizó la herramienta de _System
Identification Toolbox_ implementada en **MATLAB®**. A partir de los datos
experimentales de la respuesta en lazo abierto ante un escalón del 20 % al 60
%, se analizó la forma de la respuesta temporal y se observó que el proceso
presenta una dinámica dominante de **primer orden con un tiempo muerto
reducido**.

Inicialmente, se obtuvo un modelo de **segundo orden más tiempo muerto** con
polos reales. No obstante, uno de los polos resultó ser significativamente más
rápido que el dominante, por lo que su contribución dinámica no es relevante.
Por esta razón, se seleccionó un modelo de **primer orden más tiempo muerto**,
el cual ofrece un ajuste similar con menor complejidad.

- **Modelo seleccionado:** Primer orden más tiempo muerto (POMTM)

$$
P_{SIT}(s) = \frac{0.9204}{1.0507 s + 1} \, e^{-0.1371 s}
$$

Este modelo presentó el **mejor desempeño global** entre los métodos evaluados,
con un **IAE = 4.1709**, por lo que fue seleccionado como **modelo principal
del proceso** para el diseño de los controladores continuos.

---

## Método 123c de Alfaro

Como segundo método de identificación, se aplicó el método `123c` propuesto por
Alfaro para sistemas de **primer orden más tiempo muerto**. Este método se basa
en la identificación de los instantes en los que la respuesta alcanza el 25 %
y el 75 % de su valor final, a partir de los cuales se estiman los parámetros
del modelo.

El modelo obtenido corresponde a:

$$
P_{123c}(s) = \frac{0.9215}{0.9887 s + 1} \, e^{-0.1923 s}
$$

Este modelo presentó un desempeño adecuado, con un **IAE = 4.9764**, aunque
superior al obtenido mediante _System Identification Toolbox_.

---

## Método de `Ho et al. (1995)`

Como tercer método de identificación, se empleó el procedimiento propuesto por
Ho et al., el cual también permite obtener modelos de **primer orden más tiempo
muerto** a partir de características temporales de la respuesta al escalón.

El modelo identificado mediante este método corresponde a:

$$
P_{Ho}(s) = \frac{0.9215}{1.0653 s + 1} \, e^{-0.1484 s}
$$

El desempeño de este modelo fue comparable al método `123c`, con un **IAE =
4.4105**, aunque nuevamente superior al obtenido con _System Identification
Toolbox_.

---

## Mínimos cuadrados

Finalmente, se aplicó el método de **mínimos cuadrados** para obtener un modelo
del proceso en **tiempo discreto**. Dado que el enunciado del proyecto solicita
modelos de **orden reducido**, se seleccionó un modelo de **primer orden**
dependiente de una entrada y una salida retardada.

El modelo discreto identificado es:

$$
P_{LS}(z) = \frac{0.01895 z^{-1}}{1 - 0.9796 z^{-1}}
$$

Este modelo presentó un desempeño inferior respecto a los modelos continuos,
con un **IAE = 7.6184**, pero resultó adecuado para el **diseño del controlador
discreto mediante LGR**, donde se requiere una representación en el dominio
$z$.

---

## Comparación y selección del modelo

Para comparar los modelos obtenidos, se utilizó el **índice integral del error
absoluto (IAE)** como criterio principal. Los resultados obtenidos fueron:

- `System Identification Toolbox`: IAE = 4.1709
- `Ho et al.`: IAE = 4.4105
- `123c`: IAE = 4.9764
- `Mínimos cuadrados`: IAE = 7.6184

Con base en estos resultados, se seleccionó el modelo obtenido mediante
**System Identification Toolbox** como el **modelo representativo del proceso**
para el diseño de los controladores continuos, mientras que el modelo de
**mínimos cuadrados** se utilizó exclusivamente para el diseño del controlador
discreto.
