# ie0431-proyecto

En este repositorio, se muestra el trabajo desarrollado para el proyecto del curso **IE0431 - Sistemas de control** correspondiente al diseño de un sistema de control de flujo de aire enfocado en la aplicación para una cabina de bioseguridad.

## Herramientas de software utilizadas

Para la realización del proyecto, se utilizó:

- **MATLAB y Simulink (2025b)**: Para la identificación, diseño de algoritmos de control y análisis de las respuestas experimentales.
- **LaTeX y Beamer**: Para la redacción del informe académico y la presentación de los resultados del proyecto.

## Estructura del proyecto

A continuación, se muestra la estructura que presenta el repositorio:

```sh
.
├── controladores
│   ├── orden1_controladores.m  # Script para el diseño de los controladores
│   ├── orden1_sim.slx          # Simulink para la simulación temporal
│   ├── README.md               # Explicación de los algoritmos seleccionados
│   └── sim_discreto.slx        # Simulink para la simulación del discreto
├── docs
│   ├── presentation/           # Archivos de LaTeX de la presentación
│   └── report/                 # Archivos de LaTeX del informe
├── exp
│   ├── 3-2_brambilla.csv       # Datos experimentales de Brambilla
│   ├── 3-2_rope.csv            # Datos experimentales de RoPe
│   ├── 3-2_sintesis.csv        # Datos experimentales de Síntesis Analítica
│   └── prueba_experimental.m   # Script para el análisis experimental
├── identificacion
│   ├── delta_20a60.csv         # Datos para la identificación experimental
│   ├── lectura_datos.m         # Script para la identificación experimental
│   └── README.md               # Explicación de los modelos seleccionados
├── LICENSE
└── README.md
```
