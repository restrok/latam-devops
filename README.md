# Desafío Técnico DevSecOps/SRE

## Contexto
Se requiere un sistema para ingestar y almacenar datos en una DB con la finalidad de hacer analítica avanzada. Posteriormente, los datos almacenados deben ser expuestos mediante una API HTTP para que puedan ser consumidos por terceros.

## Objetivo
Desarrollar un sistema en la nube para ingestar, almacenar y exponer datos mediante el uso de IaC y despliegue con flujos CI/CD. Hacer  pruebas de calidad, monitoreo y alertas para asegurar y monitorear la salud del sistema.


## Parte 1: Infraestructura e IaC
### 1. Infraestructura para la Ingesta de Datos

- ApiGateway: Expondrá un endpoint HTTP que permitirá la recepción de datos mediante una solicitud POST. El path del endpoint se configurará para utilizar una Cloud Function como backend.

- Cloud Function (Ingesta): Recibirá el archivo CSV mediante una solicitud POST y lo almacenará en un bucket de Google Cloud Storage.

- Google Cloud Storage: Al recibir un nuevo archivo CSV, emitirá un evento que se comunicará con Google Cloud Pub/Sub.

- Google Cloud Pub/Sub: Al detectar un nuevo mensaje, activará otra Cloud Function encargada de procesar y almacenar los datos.

- Cloud Function (Procesamiento): Leerá el contenido del archivo CSV en el bucket y lo insertará en Google BigQuery para su almacenamiento y análisis.

- BigQuery: Se utilizará como base de datos para el almacenamiento de datos.

### 2. Infraestructura para la Exposición de Datos

- ApiGateway: Se añadirá un nuevo endpoint que, mediante una solicitud GET, activará otra Cloud Function.

- Cloud Function (Consulta): Realizará una consulta a Google BigQuery y devolverá los datos solicitados en respuesta a la solicitud GET.

- BigQuery: Se utilizará como fuente de datos para la consulta.

### 3. Terraform
- Todo el código de infraestructura se encuentra en la carpeta "infra" del repositorio.

- Se utilizó un esquema de consumo de módulos de Terraform para la infraestructura. Esto permite modularizar y reutilizar el código de infraestructura, lo que facilita la gestión y el mantenimiento a medida que el sistema crece y evoluciona. Los módulos de Terraform proporcionan una forma de encapsular y parametrizar componentes de infraestructura comunes, lo que simplifica la configuración y la implementación en diferentes entornos.

## Parte 2: Aplicaciones y flujo CI/CD

Se utilizará un único repositorio para la infraestructura y la aplicación, con pipelines diferenciados para las ramas 'develop' y 'master'.

**Nota:**
1. Se recomienda separar infraestructura y aplicación en repositorios distintos para entornos productivos.
2. Adicionalmente, como buena práctica, deberia armar pipelines diferenciados entre Continuous Integration y Continuous Deployment.


### Pasos del Pipeline:

#### [Push a la rama 'develop'](https://github.com/restrok/latam-devops/blob/master/infra/submodules/cloudbuild-trigger/tf-plan.yaml)

1. Paso uno: Ejecutar las pruebas unitarias.

2. Paso dos: Generar los artefactos para cada Cloud Function y subirlos al bucket correspondiente.

3. Paso tres: Validar la configuración de Terraform.

4. Paso cuatro: Inicializar Terraform.

5. Paso cinco: Ejecutar Terraform plan.



#### [Push a la rama 'master'](https://github.com/restrok/latam-devops/blob/master/infra/submodules/cloudbuild-trigger/tf-apply.yaml)

1. Paso uno: Ejecutar las pruebas unitarias.

2. Paso dos: Generar los artefactos para cada Cloud Function y subirlos al bucket correspondiente.

3. Paso tres: Validar la configuración de Terraform.

4. Paso cuatro: Inicializar Terraform.

5. Paso cinco: Ejecutar Terraform apply.

6. Prueba de Integración.

### Aclaraciones:

- Se recomienda separar la infraestructura y la aplicación en repositorios diferentes, especialmente en entornos productivos.

- Es recomendable tener pipelines separados para Continuous Integration y Continuous Deployment.

- Los Unit Test no se han generado en este momento, por lo que este paso se ha omitido.

- La prueba de integración solo espera una respuesta válida de estado 200. En un entorno productivo, se recomienda mejorar el código para validar que la información devuelta por el sistema sea la esperada.

   - ![Integration Test](./images/int-test.png)

- La validación de Terraform no se ejecuta para agilizar el proceso, pero se recomienda realizarla en un entorno de producción.

### Ejecuciones:
- Última ejecución de CI/CD: [Enlace a la ejecución](https://github.com/restrok/latam-devops/runs/29813460954)
- Última ejecución de CI: [Enlace a la ejecución](https://github.com/restrok/latam-devops/runs/29813402622)

![Ejecución de CI/CD](./images/cloud-build-full.png)

### Diagrama de Arquitectura

![Diagrama de Arquitectura](./images/diagram.png)


1. **Productores de Datos**: Publican mensajes utilizando un endpoint (API HTTP) de ApiGateway, que es recibido por una Cloud Function.

2. **Cloud Function**: Almacena el mensaje recibido en un bucket.

3. **Google Cloud Storage**: Envía una notificación a través de un tópico indicando que se ha cargado un nuevo elemento.

4. **Google Cloud Pub/Sub**: Activa una Cloud Function que carga los nuevos datos en BigQuery.

5. **Google Cloud Functions (Ingesta)**: Se activa por mensajes en la suscripción de Pub/Sub y procesa los datos, almacenándolos en Google BigQuery.

6. **Google BigQuery**: Almacena los datos de manera optimizada para su análisis.

7. **Google ApiGateway**: Expone un endpoint HTTP para que terceros puedan consumir los datos almacenados o cargar nuevos datos.

8. **Google Cloud Functions (API HTTP)**: Se activa mediante solicitudes HTTP gestionadas por Google Cloud ApiGateway y consulta los datos en Google BigQuery.

9. **Google BigQuery**: Sirve los datos solicitados en la consulta.


## Parte 3: Pruebas de Integración y Puntos Críticos de Calidad

### Pruebas de integracion

- Se ha implementado una prueba de integración como último paso en el pipeline de despliegue.

### API Request

- Actualmente, el sistema permite la ingestión de nuevos datos mediante una solicitud POST al endpoint https://my-gateway-5mjnasuv.uc.gateway.dev/upload con un archivo CSV. 
   - Dataset: https://www.kaggle.com/datasets/mahoora00135/flights

- Actualmente, el sistema permite la consulta de los datos almacenados mediante una solicitud GET al endpoint https://my-gateway-5mjnasuv.uc.gateway.dev/getdata. Por cuestiones de tiempo, el GET no permite suministrar una consulta personalizada, sino que está predefinido para devolver las primeras 10 filas de datos.

### Seguridad:

 - Por motivos de tiempo, no se ha implementado un sistema de autenticación para los requests de ApiGateway, pero se recomienda encarecidamente utilizar un sistema como JWT.

 - Se ha utilizado una única Service Account con permisos amplios para todo el ecosistema. Esto no es recomendado en un entorno de producción, donde se debe aplicar el principio de privilegio mínimo.


### Aclaraciones:

 - Por motivos de seguridad y costos, es probable que el endpoint de ApiGateway esté deshabilitado.

 - El sistema se ha diseñado para manejar archivos de gran tamaño durante el POST. Por eso, se utiliza la secuencia de función>bucket>Pub/Sub>función en lugar de Pub/Sub directamente para agregar la información a BigQuery.

 - La solución propuesta ha sido diseñada para abordar el problema planteado de manera sólida. A corto plazo, no se ven grandes áreas de mejora.

 - Se podría implementar una estrategia de auto-reparación en caso de que las Cloud Functions fallen debido a solicitudes demasiado grandes que resulten en un tiempo de espera agotado.

 - La función encargada de manejar los datos recibidos por el POST no realiza ninguna validación de los datos. Algunas recomendaciones para mejorar esto son:

   - Guardar en una tabla de BigQuery toda la información posible sobre la solicitud de carga de datos, incluyendo el nombre del archivo (si lo hay). Esto facilitará su posterior análisis.

   - Devolver un mensaje de error al usuario informando posibles soluciones estándar.


## Parte 4: Métricas y Monitoreo


### Cloud Functions 

#### Latencia de las solicitudes (Response Time)



   Descripción: La latencia es el tiempo que tarda una función en responder a una solicitud HTTP desde su recepción. Es un indicador crítico del rendimiento y la experiencia del usuario.



   Por qué es importante: Una latencia alta puede indicar problemas de rendimiento en la función o en los servicios con los que interactúa. El monitoreo de la latencia ayuda a identificar y solucionar cuellos de botella para mantener tiempos de respuesta rápidos.



#### Tasa de errores (Error Rate)



   Descripción: La tasa de errores es el porcentaje de solicitudes a la función que resultan en errores. Esto incluye errores de ejecución dentro de la función y errores de infraestructura como tiempos de espera agotados o problemas de recursos.



   Por qué es importante: Una alta tasa de errores puede afectar la confiabilidad de la aplicación y la satisfacción del usuario. El monitoreo de esta métrica permite detectar y responder a problemas que afectan la salud de la función.



#### Tiempo de inicio en frío (Cold Start Time):

   Descripción: El tiempo de inicio en frío se refiere al tiempo que tarda una función en manejar una solicitud después de un período de inactividad, durante el cual la infraestructura subyacente debe inicializar una nueva instancia de la función. Este tiempo incluye la carga del código, la inicialización del entorno de ejecución y cualquier inicialización de dependencias necesaria antes de poder procesar la solicitud.

   Por qué es importante: Los tiempos de inicio en frío pueden afectar significativamente la latencia de las solicitudes, especialmente para la primera solicitud después de un período de inactividad. El monitoreo de esta métrica permite comprender y mitigar el impacto de los tiempos de inicio en frío en la experiencia del usuario, y puede ayudar a tomar decisiones sobre estrategias como el precalentamiento de instancias o la optimización de la inicialización de la función.

### Cloud Storage

#### Eventos de Creación de Archivos

Descripción: Los eventos de creación de archivos son registros que se generan cada vez que se crea un nuevo archivo en un bucket de Cloud Storage. Estos eventos registran información como la hora de creación, el nombre del archivo y el tamaño del archivo.



Por qué es importante: El monitoreo de los eventos de creación de archivos proporciona un registro detallado de todas las operaciones de carga de archivos en el bucket. Esto es útil para rastrear y auditar las actividades de carga de datos, asegurando la integridad y trazabilidad de los archivos almacenados. Además, estos eventos pueden utilizarse para desencadenar acciones o procesos automatizados en función de la creación de nuevos archivos.



#### Contador de objetos

Descripción: El contador de objetos es una métrica que registra la cantidad total de objetos (archivos y carpetas) almacenados en un bucket de Cloud Storage.



Por qué es importante: El contador de objetos proporciona una visión general del volumen de datos almacenados en el bucket. Esta métrica es útil para monitorear el crecimiento y la utilización del almacenamiento, lo que permite tomar decisiones informadas sobre la capacidad y los costos asociados. Además, el seguimiento de esta métrica ayuda a identificar cualquier anomalía o discrepancia en la cantidad de objetos almacenados, lo que puede ser indicativo de problemas en la gestión de los archivos.
   

### ApiGateway

#### Tasa de errores (Error Rate):



   Descripción: La tasa de errores es el porcentaje de solicitudes que resultan en errores. Esto incluye errores del cliente (errores 4xx) y errores del servidor (errores 5xx).



   Por qué es importante: El monitoreo de la tasa de errores permite identificar problemas en la API que puedan afectar la experiencia del usuario, como errores de configuración, problemas de autenticación o errores en el backend. Un aumento repentino en la tasa de errores puede indicar un problema que requiere atención inmediata.



#### Latencia de las solicitudes (Request Latency):



   Descripción: La latencia mide el tiempo que tarda una solicitud en ser procesada por el API Gateway, incluyendo el tiempo de ida y vuelta de la red, el procesamiento del Gateway y el tiempo de respuesta del backend.



   Por qué es importante: La latencia es un indicador clave del rendimiento de la API. Una latencia alta puede afectar la experiencia del usuario final y puede indicar cuellos de botella en el procesamiento del API Gateway o en los servicios backend. El monitoreo de la latencia permite optimizar las APIs y escalar los recursos adecuadamente para manejar la carga de trabajo.



Todas estas métricas pueden generarse y visualizarse en un Dashboard personalizado utilizando el servicio Cloud Monitoring.



Ejemplo de algunas métricas de ApiGateway:



![Ejemplo de métricas](./images/api-gtw-metrics.png)

## Parte 5: Alertas y SRE (Opcional)



En la misma herramienta de Cloud Monitoring, se pueden configurar alertas basadas en las métricas definidas.



### Caso hipotético para generación de alertas

Podemos suponer que nuestro sistema será consumido por 50 aeropuertos y cada uno tiene una capacidad máxima de realizar hasta 10 despegues por hora. Como regla de negocio, se realizará una solicitud POST a nuestro sistema por cada despegue exitoso.



Tendríamos un máximo teórico de 500 solicitudes POST por hora en condiciones normales de funcionamiento.



### Ejemplo de Alerta



Alerta de Alta Tasa de Solicitudes (Posible Saturación o Ataque DDoS):



- Condición: Si el número de solicitudes POST por hora supera significativamente el umbral esperado de 500, esto podría indicar una posible saturación del sistema o un ataque DDoS.

- Configuración de la Alerta: Configurar una política de alerta para que se active si el número de solicitudes POST supera, por ejemplo, las 600 por hora, proporcionando un margen para variaciones normales pero aún siendo sensible a un aumento inusual.



Alerta de Baja Tasa de Solicitudes (Posible Interrupción del Servicio o Problema de Conectividad):



- Condición: Si el número de solicitudes POST por hora es significativamente menor que el umbral esperado, esto podría indicar una interrupción del servicio o un problema de conectividad con los sistemas de los aeropuertos.

- Configuración de la Alerta: Configurar una política de alerta para que se active si el número de solicitudes POST cae por debajo, por ejemplo, de las 400 por hora, lo que podría indicar que los aviones no se están registrando correctamente.



### SLIs y SLOs:

- SLI: Latencia de Respuesta de las Solicitudes POST

- SLO: El 95% de las solicitudes POST recibirán una respuesta en menos de 300 milisegundos.

- Argumento: La latencia de respuesta es crítica para un sistema que procesa despegues de aviones, ya que puede afectar las operaciones en tiempo real de los aeropuertos. Un SLO de 300 milisegundos garantiza un servicio ágil y eficiente. Se desechó un umbral más bajo ya que podría ser demasiado estricto y difícil de cumplir dado el tráfico variable y las dependencias de red.

--------------------

- SLI: Disponibilidad del API Gateway

- SLO: El API Gateway estará disponible el 99.9% del tiempo cada mes.

- Argumento: La alta disponibilidad es esencial para asegurar que los aeropuertos puedan realizar despegues sin interrupciones. Un SLO del 99.9% equilibra una alta confiabilidad con la necesidad de realizar mantenimiento programado y actualizaciones del sistema. Se desechó un SLO del 100% debido a que puede no ser realista y no permitir tiempo para el mantenimiento planificado.

--------------------

- SLI: Tasa de Errores de las Solicitudes POST

- SLO: Menos del 1% de las solicitudes POST resultarán en errores 5xx.

- Argumento: Una baja tasa de errores es crucial para garantizar la integridad de las operaciones de despegue. Un SLO del 1% permite cierto margen para errores inesperados o problemas transitorios sin comprometer significativamente la funcionalidad general del sistema. Se desechó un SLO más estricto debido a que podría requerir una infraestructura y una redundancia que excedan los recursos disponibles.

### Aclaraciones finales:

- Teniendo la posibilidad de utilizar los servicios nativos de GCP, no veo la necesidad de implementar herramientas de código abierto como FastAPI, MQTT, Prometheus/Grafana. El uso de servicios nativos facilita la integración y el mantenimiento del sistema en un entorno productivo sin requerir configuraciones adicionales de seguridad.
- Además, la implementación de herramientas de código abierto requeriría un esfuerzo adicional de mantenimiento y configuración de seguridad en comparación con el uso de servicios nativos de GCP.
- Por motivos de tiempo, en esta implementación solo se presenta un entorno. Sin embargo, se puede cambiar la convención de nomenclatura para que sea compatible con múltiples entornos (por ejemplo, desarrollo, producción, pruebas, etc.).
- Al haber elegido una solución serverless, la escalabilidad y la replicación no deberían ser un problema. Esto facilita tanto la escalabilidad horizontal como vertical del sistema.
- La captura de pantalla mostrada representa una posible estructura de flujo de trabajo utilizando el modelo GitFlow para la gestión de ramas y versiones del código fuente.

   ![GitFlow](./images/git-flow.png)

