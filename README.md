# Recetas electorales

1. [_**Entrada**_](https://nelsonamayad.shinyapps.io/col2018_tend/): Applicación para ver las tendencias para cada candidato, en todas las encuestas públicamente disponibles. Preparada con [Shinyapps](https://www.shinyapps.io/).

2. [_**Aperitivo**_](https://nelsonamayad.github.io/poder/poder): ¿qué pueden detectar las encuestas? ¿Son demasiado pequeñas para ser útiles? Un intento imperfecto de medir el poder estadístico de las encuestas. Preparado con [pwr](https://cran.r-project.org/web/packages/pwr/vignettes/pwr-vignette.html) en R.

3. [_**Plato Simple**_](https://nelsonamayad.github.io/simple): primera receta para un modelo bayesiano lineal que sigue las pocas encuestas de intencion de voto para cada candidato, e incluye efectos aleatorios por encuestadora para el intercepto. Permite un pronóstico básico, completamente transparente y replicable usando sólo información pública. Preparada con [Stan](http://mc-stan.org/users/interfaces/rstan.html).

4. [_**Plato Mixto**_](https://nelsonamayad.github.io/mixto): esta segunda receta es mejor que la primera, pero más complicada: introduce efectos aleatorios para interceptos y pendientes a la receta Simple. Se ajusta mejor a los datos de las encuestas para todos los candidatos. Preparada con [Stan](http://mc-stan.org/users/interfaces/rstan.html).
