# COVID-19

[_**Shiny App**_](https://nelsonamayad.shinyapps.io/COVID19/) para seguir la trayectoria del virus.

# Recetas electorales

Extra: [_**Entrada - Locales 2019**_](https://nelsonamayad.shinyapps.io/locales_2019): aplicación para ver las tendencias en la intención de voto para cada candidato de las elecciones de 3 principales ciudades según todas las encuestas públicamente disponibles. Preparada con [Shinyapps](https://www.shinyapps.io/).

1. [_**Entrada**_](https://nelsonamayad.shinyapps.io/col2018_tend/): Applicación para ver las tendencias para cada candidato, en todas las encuestas públicamente disponibles. Preparada con [Shinyapps](https://www.shinyapps.io/).

2. [_**Aperitivo**_](https://nelsonamayad.github.io/poder/poder): ¿qué pueden detectar las encuestas? ¿Son demasiado pequeñas para ser útiles? Un intento imperfecto de medir el poder estadístico de las encuestas. Preparado con [pwr](https://cran.r-project.org/web/packages/pwr/vignettes/pwr-vignette.html) en R.

3. [_**Plato Simple**_](https://nelsonamayad.github.io/simple): primera receta para un modelo bayesiano lineal que sigue las pocas encuestas de intencion de voto para cada candidato, e incluye efectos aleatorios por encuestadora para el intercepto. Permite un pronóstico básico, completamente transparente y replicable usando sólo información pública. Preparada con [Stan](http://mc-stan.org/users/interfaces/rstan.html).

4. [_**Plato Mixto**_](https://nelsonamayad.github.io/mixto): esta segunda receta es mejor que la primera, pero más complicada: introduce efectos aleatorios para interceptos y pendientes a la receta Simple. Se ajusta mejor a los datos de las encuestas para todos los candidatos. Preparada con [Stan](http://mc-stan.org/users/interfaces/rstan.html).

5. [_**Calentao**_](https://nelsonamayad.github.io/calentao/calentao): Este es un plato con todos los pronósticos, promedios y modelos que encontré y que se publicaron antes de la primera vuelta. Incluye los resultados de los platos Simple y Mixto, los pronósticos de Cifras y Conceptos, ANIF, El País y un promedio entre las encuestas como referencia.

6. [_**Caldo post electoral**_](https://nelsonamayad.github.io/caldo/caldo): Comparación entre los pronósticos y los resultados a la primera vuelta. Ganadores: las encuestas y los platos propios.

7. [_**Postre logístico**_](https://nelsonamayad.github.io/logis/logis): Un intento por hacer un pronóstico probabilístico para la segunda vuelta usando un modelo binomial. Preparado con [Stan](http://mc-stan.org/users/interfaces/rstan.html) y [map2stan](https://www.rdocumentation.org/packages/rethinking/versions/1.59/topics/map2stan).
