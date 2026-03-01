# Proyecto A (Sistema RAG) y Proyecto B (Chatbot Multiherramienta)

Este repositorio contiene la infraestructura y los workflows de n8n para el Hito 3 del módulo.

## Estructura

- `/docker`: Configuración de contenedores (n8n, PostgreSQL, Qdrant).
- `/n8n/workflows`: Aquí se guardarán los JSON exportados de n8n.
- `/postgres`: Scripts de inicialización de la base de datos (`init.sql`).
- `/docs/capturas`: Imágenes para la documentación.

## Cómo levantar el proyecto

1. Copia el archivo de entorno: `cp docker/.env.example docker/.env`
2. Inicia los contenedores: `docker compose -f docker/docker-compose.yml up -d`
3. Accede a n8n en: [http://localhost:5678](http://localhost:5678)
4. (Opcional) Ollama debe estar ejecutándose en _localhost:11434_ en la máquina host.
