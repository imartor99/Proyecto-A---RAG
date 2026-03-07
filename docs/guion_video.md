# Guion para el Vídeo del Hito 3: Chatbot RAG Local

Este guion es mi guía personal para grabar el vídeo demostrativo con OBS, asegurando que cumplo con la rúbrica de evaluación y muestro todo el flujo de forma clara.

## Preparación antes de grabar (Off-camera)

1. Compruebo que Docker Desktop está abierto y tengo los 3 contenedores activos (n8n, Qdrant, y Postgres).
2. Dejo la terminal abierta y limpia, con el comando `ollama list` escrito pero sin pulsar intro aún.
3. Abro n8n (`localhost:5678`) con las pestañas de mis dos workflows cargadas.
4. Abro VS Code preparado con el archivo `tests/pruebas.http`.
5. Abro pgAdmin 4 conectado a `rag_db` y listo para cargar las tablas.

---

## Toma 1: Arquitectura e Infraestructura (1 minuto aprox)

_(Mostrar VS Code con `docker-compose.yml`)_  
**"Hola, soy Nacho y voy a presentar el funcionamiento de mi proyecto para el Hito 3. Para comenzar, he montado toda la infraestructura local utilizando Docker Compose para levantar n8n, una base de datos relacional PostgreSQL y una base de datos vectorial Qdrant."**

_(Mostrar pantalla de Docker Desktop con contenedores verdes)_  
**"Aquí podemos ver que los tres contenedores están activos y saludables."**

_(Cambiar a la terminal y tabular el intro en `ollama list`)_  
**"Por otro lado, estoy utilizando Ollama en local. Como se ve en consola, he descargado el modelo `nomic-embed-text` para procesar mis embeddings y `llama3.2` como cerebro del chatbot."**

## Toma 2: Workflow 1 - Ingesta de Documentos (1.5 minutos aprox)

_(Mostrar navegador con n8n, Workflow 1)_  
**"Este es mi flujo de Ingesta. Todo parte de un Webhook configurado para recibir peticiones POST. El PDF o texto que se mande pasa por un Text Splitter, que está configurado tal y como exige la rúbrica: divide el documento en chunks de 500 palabras con el overlap de 50."**

_(Señalar el bloque de guardado Vectorial y el bloque SQL)_  
**"A continuación, utilizo el motor Ollama para generar los embeddings matemáticos, que se alojan automáticamente en mi colección `documentos_rag` en Qdrant. Finalmente, guardo una metadata básica de confirmación en una tabla de PostgreSQL."**

_(Demostración práctica: darle a "Listen for test event" en n8n)_  
_(Cambiar a VS Code y pulsar "Send Request" en Ingesta, mostrando que da un 200 OK)_  
**"Veamos cómo funciona: lanzo la petición simulando la entrada de un documento..."**
_(Volver a n8n rápido para ver que todo pasa por verde)_  
**"Como vemos, el flujo se completa y si recargo pgAdmin en mi tabla documentos, aparece la fila confirmando que mi documento ha sido procesado."**

## Toma 3: Workflow 2 - Consultas RAG (2 minutos aprox)

_(Mostrar n8n, Workflow 2)_  
**"Ahora pasamos a la fase 2: el Chatbot con memoria RAG."**
**"Aquí uso el nodo nativo AI Agent alimentado por mi Llama 3.2 local. A este agente le he suministrado la herramienta de conexión a Qdrant, dándole instrucciones muy claras de que debe consultar los apuntes que insertamos antes de responder."**

_(Enseñar el nodo SQL final)_  
**"El último paso de este flujo, antes de devolver la respuesta al usuario, es guardar tanto la pregunta que nos han hecho como la respuesta generada dentro de la tabla `consultas_rag` de PostgreSQL, cumpliendo así con el historial exigido."**

_(Demostración Final)_  
**"Vamos a comprobarlo."** _(Dar clic a "Listen for test event" en n8n)_  
_(Ir a VS Code `pruebas.http`, dar a "Send Request" en la consulta RAG de ¿Qué es la IA?)_  
**"Lanzo la consulta. El agente tardará un par de segundos en vectorizar mi pregunta, compararla en Qdrant y leer el documento para redactar la respuesta final."**
_(Muestro cómo aparece el bloque inmenso de output en VS Code)._  
**"Ahí lo tenemos, el modelo me ha respondido a la perfección apoyándose en el documento ingestado."**

_(Cerrar el vídeo yendo a pgAdmin `consultas_rag` y darle a refrescar para ver el texto guardado)_  
**"Y si me voy a la base de datos, refresco mi tabla `consultas_rag` y vemos mi pregunta junto a la respuesta que me ha devuelto el bot y la rúbrica registrada. Muchas gracias, esto es todo el proceso para realizar este proyecto."**
