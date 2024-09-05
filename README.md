# Desafío Técnico DevSecOps/SRE

## Contexto
Se requiere un sistema para ingestar y almacenar datos en una DB con la finalidad de hacer analítica avanzada. Posteriormente, los datos almacenados deben ser expuestos mediante una API HTTP para que puedan ser consumidos por terceros.

## Objetivo
Desarrollar un sistema en la nube para ingestar, almacenar y exponer datos mediante el uso de IaC y despliegue con flujos CI/CD. Hacer  pruebas de calidad, monitoreo y alertas para asegurar y monitorear la salud del sistema.

## Parte 1: Infraestructura e IaC

### 1. Identificación de la Infraestructura Necesaria

1. **Ingesta de Datos (Pub/Sub)**
   - Utilizaremos el esquema Pub/Sub para la ingesta de datos. 
   - **Servicio Propuesto:** En este caso, implementaremos este patrón utilizando Google Cloud Pub/Sub, que permite la publicación de datos por parte de productores y la suscripción de consumidores para procesar estos datos.

2. **Almacenamiento de Datos**
   - Los datos serán almacenados en una base de datos optimizada para analítica.
   - **Servicio Propuesto:** Google BigQuery, una base de datos en la nube altamente escalable y optimizada para análisis de datos.

3. **Exposición de Datos mediante API HTTP**
   - Se levantará un endpoint HTTP que permita a terceros consumir los datos almacenados.
   - **Servicio Propuesto:** Google Cloud Functions para la ejecución de funciones serverless y Google Cloud Endpoints para gestionar las peticiones HTTP.

### 2. Despliegue de Infraestructura mediante Terraform (Opcional)
   - Se puede usar Terraform para definir y desplegar la infraestructura en GCP.
   - Esto incluiría la configuración de Pub/Sub, BigQuery, Cloud Functions y Cloud Endpoints.

### Diagrama de Arquitectura

![Diagrama de Arquitectura](./images/diagram.png)

### Descripción del Diagrama

1. **Productores de Datos** publican mensajes a través de Google Cloud Pub/Sub.
2. **Google Cloud Pub/Sub** distribuye estos mensajes a una suscripción.
3. **Google Cloud Functions (Ingesta)** se activa por mensajes en la suscripción de Pub/Sub y procesa los datos, almacenándolos en Google BigQuery.
4. **Google BigQuery** almacena los datos de manera optimizada para análisis.
5. **Google Cloud Functions (API HTTP)** se activa mediante peticiones HTTP gestionadas por Google Cloud Endpoints y consulta los datos en Google BigQuery.
6. **Google Cloud Endpoints** expone el endpoint HTTP para que terceros puedan consumir los datos almacenados.

Esta arquitectura proporciona un flujo end-to-end desde la ingesta de datos hasta su exposición mediante una API HTTP, utilizando servicios serverless y gestionados en la nube para optimizar el tiempo de desarrollo y mantenimiento.

## Parte 2: Aplicaciones y flujo CI/CD

### 1. API HTTP
Levantar un endpoint HTTP con lógica que lea datos de la base de datos y los exponga al recibir una petición GET.

### 2. Despliegue de la API HTTP en la nube mediante CI/CD
Deployar la API HTTP en la nube mediante CI/CD a tu elección. El flujo CI/CD y las ejecuciones deben estar visibles en el repositorio git.

### 3. (Opcional) Ingesta
Agregar suscripción al sistema Pub/Sub con lógica para ingresar los datos recibidos a la base de datos. El objetivo es que los mensajes recibidos en un tópico se guarden en la base de datos. No requiere CI/CD.

### 4. Diagrama de Arquitectura
Incluye un diagrama de arquitectura con la infraestructura del punto 1.1 y su interacción con los servicios/aplicaciones que demuestra el proceso end-to-end de ingesta hasta el consumo por la API HTTP.

## Parte 3: Pruebas de Integración y Puntos Críticos de Calidad

### 1. Implementación de Test de Integración
Implementa en el flujo CI/CD un test de integración que verifique que la API efectivamente está exponiendo los datos de la base de datos. Argumenta.

### 2. Otras Pruebas de Integración
Proponer otras pruebas de integración que validen que el sistema está funcionando correctamente y cómo se implementarían.

### 3. Identificación de Puntos Críticos
Identificar posibles puntos críticos del sistema (a nivel de fallo o performance) diferentes al punto anterior y proponer formas de testearlos o medirlos (no implementar).

### 4. Robustecimiento del Sistema
Proponer cómo robustecer técnicamente el sistema para compensar o solucionar dichos puntos críticos.

## Parte 4: Métricas y Monitoreo

### 1. Propuesta de Métricas
Proponer 3 métricas (además de las básicas CPU/RAM/DISK USAGE) críticas para entender la salud y rendimiento del sistema end-to-end.

### 2. Herramienta de Visualización
Proponer una herramienta de visualización y describir textualmente qué métricas mostraría, y cómo esta información nos permitiría entender la salud del sistema para tomar decisiones estratégicas.

### 3. Implementación de la Herramienta
Describe a grandes rasgos cómo sería la implementación de esta herramienta en la nube y cómo esta recolectaría las métricas del sistema.

### 4. Escalamiento de la Solución
Describe cómo cambiará la visualización si escalamos la solución a 50 sistemas similares y qué otras métricas o formas de visualización nos permite desbloquear este escalamiento.

### 5. Dificultades o Limitaciones
Comenta qué dificultades o limitaciones podrían surgir a nivel de observabilidad de los sistemas de no abordarse correctamente el problema de escalabilidad.

## Parte 5: Alertas y SRE (Opcional)

### 1. Reglas o Umbrales para Alertas
Define específicamente qué reglas o umbrales utilizarías para las métricas propuestas, de manera que se disparen alertas al equipo al decaer la performance del sistema. Argumenta.

### 2. Definición de SLIs y SLOs
Define métricas SLIs para los servicios del sistema y un SLO para cada uno de los SLIs. Argumenta por qué escogiste esos SLIs/SLOs y por qué desechaste otras métricas para utilizarlas dentro de la definición de SLIs.
```

Este `README.md` proporciona una estructura clara y completa del desafío técnico, detallando cada parte del ejercicio y las instrucciones correspondientes.


Notas que voy dejando para agregar luego:
- Teniendo la posibilidad de usar los servicios nativos de GCP no veo la necesidad de implementar herramietas opensource como FastAPI, MQTT, Prometheus/Grafana.
- Adicionalmente la implementacion de herramientas open source requeriria a futuro mantenimiento, sin contar todas las configuraciones de seguridad necesarias para correr en un ambiente productivo.
- Por cuestiones de tiempo aqui solo implementamos un ambiente unico, pero podria cambiarse el naming-convention para mostrar el ambiente en el nombre del recurso creado.
- 
