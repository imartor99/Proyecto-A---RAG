# Proyecto A: Sistema RAG Educativo

El objetivo de este proyecto es implementar un sistema de Retrieval-Augmented Generation (RAG) completamente funcional, disenado empleando infraestructura local con Docker y herramientas open source.

## Arquitectura del Proyecto

El proyecto se sustenta en tres pilares tecnologicos principales desplegados mediante contenedores Docker:

- **n8n**: Entorno de automatizacion que orquesta los dos flujos de trabajo principales (Workflow de Ingesta y Workflow de Consulta).
- **Qdrant**: Base de datos vectorial utilizada para almacenar los embeddings de los documentos y realizar busquedas de similitud.
- **PostgreSQL**: Base de datos relacional orientada a preservar metadatos de los documentos introducidos y el registro historico completo de todas las consultas realizadas al sistema.

Adicionalmente, se requiere ejecutar de manera local **Ollama**, utilizando:

- Modelo `nomic-embed-text` para procesar el texto y convertirlo en vectores (embeddings).
- Modelo `llama3.2` como generador de chat principal de las respuestas del Agente de Inteligencia Artificial.

## Estructura de Directorios

- `/docker`: Contiene el archivo de orquestacion `docker-compose.yml` y las variables de entorno de base (`.env.example`).
- `/n8n/workflows`: Directorio planeado para albergar los flujos de n8n exportados en formato JSON.
- `/postgres`: Incluye el script de inicializacion (`init.sql`) que auto-genera las tablas correspondientes (`documentos` y `consultas_rag`).
- `/tests`: Almacena el fichero `pruebas.http` disenado para simular llamadas web HTTP mediante POST hacia los Webhooks de n8n.
- `/docs`: Contiene documentacion adicional, capturas requeridas y guiones de demostracion.

## Instrucciones de Instalacion y Despliegue

1. Copiar el archivo de entorno de muestra para establecer las configuraciones de seguridad locales:
   `cp docker/.env.example docker/.env`

2. Reemplazar los valores por defecto del archivo `.env` por contrasenas robustas.

3. Iniciar la infraestructura de contenedores en segundo plano desde la raiz del proyecto:
   `docker compose -f docker/docker-compose.yml up -d`

4. Asegurar que los modelos fundamentales esten operativos en la instancia local de Ollama:
   `ollama pull nomic-embed-text`
   `ollama pull llama3.2`

5. Acceder a la interfaz de creacion de flujos n8n a traves de navegador:
   `http://localhost:5678`

## Proceso de Desarrollo (Flujos de n8n implementados)

### Workflow 1: Ingesta de Documentos

Este proceso es responsable de inyectar nueva informacion literaria o documental al conocimiento del sistema.

- Se ha creado un Webhook de n8n capaz de recibir subidas de informacion mediante peticiones POST.
- La etapa de procesamiento cuenta con un Text Splitter, configurado de manera estricta para segmentar documentos en bloques limitados a 500 palabras y un solapamiento (overlap) conservador de 50 palabras, manteniendo asi el contexto previo y posterior de cada oracion.
- Seguidamente, se conecta con Ollama Embeddings para convertir cada bloque en calculos de semantica vectorial que, postieriormente, se publican en una coleccion de Qdrant expresamente disenada para ello.
- Tras la subida silenciosa del bloque a Qdrant, el workflow cierra la confirmacion logistica insertando un registro con la identificacion del documento ingerido dentro de la tabla "documentos" habilitada en PostgreSQL.

### Workflow 2: Consultas RAG

Este proceso gestiona el mecanismo RAG puro mediante memoria y busqueda semantica de la inteligencia artificial.

- Arranca un flujo desde un Webhook a la espera del envio de preguntas literales desde sistemas externos por JSON.
- El control fluye de inmediato a un nodo AI Agent, cuyo motor conectivo esta vinculado al modelo generativo local LLama 3.2.
- Se ha parametrizado el sistema para que LLama 3.2 disponga de la herramienta "Qdrant Vector Store" habilitada expresamente ("Tool Calling"). Cuando la pregunta entra, el nodo fuerza al LLM a no utilizar nunca su base de conocimiento estandar, sino a invocar a esta herramienta, transformando la pregunta en vectores y buscando similitud entre los cientos de trozos subidos en la ingesta inicial.
- Una vez el motor Qdrant retorna los apuntes limpios extraidos del Vector Store, el AI Agent compila toda esa informacion leida en una unica respuesta concisa dirigida al usuario original.
- Antes de culminar con la entrega, las respuestas se vinculan en paralelo al nodo de Base de Datos relacional para ejecutar en vivo un INSERT SQL contra la arquitectura de Postgres. Esto asegura el registro auditado de cada pregunta y respuesta enmarcada en la sesion actual.

## Demostracion y Comprobacion de Casos de Uso

El uso y evaluacion objetiva del entorno se puede realizar sin clientes pesados, simplemente accionando el entorno desde la extension "REST Client" proporcionada por Visual Studio Code. Ejecutando progresivamente "Send Request" alojados en el fichero nativo incluido en la ruta `tests/pruebas.http`.
