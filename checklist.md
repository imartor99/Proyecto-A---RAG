# Estado del Proyecto A: Sistema RAG Educativo

## Fases Completadas

- **Fase 1: Configuración Inicial y Repositorio**
  - [x] Estructura de directorios (`docker/`, `postgres/`, `tests/`, etc.).
  - [x] Archivo `.gitignore` configurado.
  - [x] Repositorio de Git inicializado, vinculado a GitHub con primer commit y tutor/a añadido como colaborador/a.
- **Fase 2: Base de Datos e Infraestructura (Docker)**
  - [x] Script SQL (`postgres/init.sql`) preparado con las tablas `documentos` y `consultas_rag`.
  - [x] Variables de entorno (`docker/.env.example` y `docker/.env`) creadas.
  - [x] Archivo `docker/docker-compose.yml` definido con los servicios requeridos (`postgres`, `qdrant`, `n8n`).
  - [x] Contenedores arrancados y funcionando correctamente de manera aislada.
- **Fase 3: Pruebas y Diseño de API Local**
  - [x] Credenciales internas creadas en el panel de n8n para enlazar con Postgres, Qdrant y Ollama.
  - [x] Archivo de extensiones REST Client (`tests/pruebas.http`) creado con las plantillas de llamadas a la API.

- **Fase 4: Workflow 1 (Ingesta de Documentos)**
  - [x] Recibir documento por Webhook.
  - [x] Extraer texto.
  - [x] Dividir en _chunks_ (~500 palabras / 50 solapamiento).
  - [x] Generar _embeddings_ con Ollama.
  - [x] Insertar vectores en Qdrant.
  - [x] Insertar historial de documento en PostgreSQL.
- **Fase 5: Workflow 2 (Consultas RAG)**
  - [x] Recibir pregunta por Webhook.
  - [x] Generar _embedding_ de la pregunta con Ollama.
  - [x] Buscar simulitudes con Qdrant (_similarity search_).
  - [x] Generar respuesta con Ollama Chat.
  - [x] Guardar consulta y contexto utilizado en PostgreSQL.
- **Fase 6 y 7: Documentación y Vídeo**
  - [x] Capturas de los workflows.
  - [x] Actualización del `README.md` y redacción del paso a paso `DEMO.md`.
  - [ ] Grabación y subida del vídeo con la demo (4-6 min).
- **Fase 8: Entrega Final**
  - [ ] Generación del Pull Request (PR) y revisión contra rúbrica.
