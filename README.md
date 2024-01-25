# OEI course test api

Código para el "Code test para la OEI"

**Versiones:**

ruby 3.2.2 (2023-03-30 revision e51014f9c0) [x86_64-darwin21]

Rails 7.1.3

**Base de datos**

No aplica

**Organización del código**

El código está repartido entre el controlador radar_controller.rb y el modelo tableless radar.db

El modelo radar.rb contiene la lógica de negocio yse instancia con los parametros "criteria" y "editions".

Una vez inicializado con el metodo **run** se ejecuta el proceso de busqueda de cursos según los criterios datos.

El controlador se encarga de instanciar esta clase, ejecutar el proceso y de generar la respuesta tanto correcta como incorrectamente.

**Test**

Lanzar rails en el puerto 8888

Bajo la premisa que de que los cursos a obtener siempre tienen que ser futuros, he modificado el archivo de test_cases para modificar la fecha de los cursos, sutituyendo aquellas fecha de 2023 por 2024

Utilizar el archivo de casos de prueba [test_cases.txt](https://github.com/osquitarhero/test/blob/main/test_cases.txt)

Utilizar el archivo [test_attack.sh](https://github.com/osquitarhero/test/blob/main/test_attack.sh) para ejecutar los casos de prueba




