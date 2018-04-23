# Recetas electorales

*Nelson Amaya*
*2018-04-25*

¿Qué se puede aprender de las encuestas de intención de voto? 

La respuesta de [La Silla Vacía (LSV)](http://lasillavacia.com/blogs/la-carrera-de-caballos-en-la-silla-62772) es: nada. Y puede que tengan razón: las encuestas se han descachado en casi todas las elecciones en las que se han utilizado para pronosticar el resultado. A veces se descachan en la dirección: en un ejercicio de estadística con las ganas, [The Upshot del New York Times le dió 85% de probabilidad de ganar a Hillary Clinton en la víspera de las eleccicones en 2016](https://www.nytimes.com/interactive/2016/upshot/presidential-polls-forecast.html). Otras veces se descachan en tamaño: aunque las encuestas en Francia siempre dieron a Macron como ganador sobre Le Pen, [tuvieron un sesgo de más de 10 pp del resultado final](https://fivethirtyeight.com/features/macron-won-but-the-french-polls-were-way-off/). De pronto no se puede aprender nada de las encuestas.

Hay otra posibilidad. Otra explicación a la posición de LSV. Según Nate Silver, los medios de comunicación [parecen ser incapaces de lidiar con probabilidiades](https://fivethirtyeight.com/features/the-media-has-a-probability-problem/). Dice LSV: "Nuestro razonamiento es que si en realidad *no son un instrumento totalmente confiable* para sondear la intención electoral de los colombianos, *cualquier análisis* que haga La Silla con base en ellas más que informar puede despistar" (énfasis añadido). Este razonamiento casi que confirma la hipótesis de Silver. Es comprehensible que los medios no sepan cómo escudriñar o representar un pronóstico probabilístico; al fin y al cabo eso es difícil de hacer. Pero también parecen creer, juzgando por ese párrafo anterior, que si ellos no son capaces de hacerlo nadie lo puede hacer. 

Me pareció insoportable la vanidad de esa respuesta y desde que la leí comencé a preparar una alternativa: un menú completamente transparente, estadísticamente técnico, replicable y preparado con software open-source. La idea es llenar un espacio vacío: reconocer que en las encuestas puede haber información valiosa, que mirarlas requiere un lente estadístico y que sólo en conjunto se pueden entender su valor, cualquiera que sea.

Las encuestas son la única alternativa a la intuición. Tienen errores, algunos explícitos y otros implícitos. Usan diferentes metodologías y estrategias muestrales, unas mejores que otras. Algunas revelan la tasa de respuesta; otras se la guardan. Hay muchas razones para cuestionar, incluso desconfiar, de las encuestas, pero hay más razones para desconfiar de analistas y columnistas: a la carreta casi nunca se le lleva contabilidad.

Así que aquí va el menú, que se mejorará tanto como sea posible. Todas las recetas dan acceso directo a los datos, supuestos, modelos, estimación y resultados. Todo sobre la mesa. 

1. [*Entrada*](https://nelsonamayad.shinyapps.io/col2018_tend/): Applicación para ver las tendencias para cada candidato, en todas las encuestas públicamente disponibles. Hecha con [Shinyapps](https://www.shinyapps.io/).

2. [*Plato Simple*](https://nelsonamayad.github.io/simple): primera receta para un modelo bayesiano lineal que sigue las pocas encuestas de intencion de voto para cada candidato, e incluye efectos aleatorios por encuestadora para el intercepto. Permite un pronóstico básico, completamente transparente y replicable usando sólo información pública.

3. [*Plato Mixto*](https://nelsonamayad.github.io/mixto): La segunda receta es mejor que la primera, pero más complicada: introduce efectos aleatorios para interceptos y pendientes de la receta Simple. El *plato mixto* se ajusta muchísimo mejor a los datos. 

Más recetas en el horno.
