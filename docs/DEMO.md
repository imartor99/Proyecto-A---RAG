# Demostracion del Proyecto A: Sistema RAG Educativo

El objetivo de este documento es explicar detalladamente el recorrido logico que sigue un documento desde que se sube al sistema hasta que es consultado y respondido por el Agente de Inteligencia Artificial ("Paso a Paso del caso de uso evaluable completo").

## Fase 1: Entendimiento e Ingesta del Documento

1. **Punto de Entrada**: Todo comienza elaborando un documento de texto o PDF, en este caso con informacion teórica (e.j., definicion de Inteligencia Artificial, Machine Learning o Redes Neuronales).
2. **Recepcion via Webhook**: El sistema n8n posee un servidor abierto (Webhook) escuchando peticiones POST en su ruta de ingesta. Mediante una herramienta como Postman, cURL o VS Code REST Client, enviamos el texto a este Webhook.
3. **Limpieza y Chunking (Text Splitter)**: No se puede enviar un documento entero a la IA vectorial. El nodo _Advanced Text Splitter_ se encarga de trocear los parrafos recibidos en bloques maximos de 500 palabras, dejando siempre un margen de solapamiento de 50 palabras para no cortar ideas o frases clave por la mitad.
4. **Traduccion Matematica (Embeddings)**: Cada uno de esos fragmentos se pasa por el modelo local `nomic-embed-text` de Ollama, que los convierte en listas de numeros denominadas "vectores" o embeddings.
5. **Almacenamiento Espacial (Qdrant)**: Estos vectores se guardan en la colección `documentos_rag` de la base de datos vectorial Qdrant. A partir de ahora, los conceptos similares viviran cerca los unos de los otros en un espacio multidimensional.
6. **Auditoria (PostgreSQL)**: Para asegurar la trazabilidad del proceso, una vez se sube a Qdrant, paralelamente se inserta un registro en la tabla `documentos` de Postgres indicando el nombre del archivo ingerido.

## Fase 2: Consulta e Inteligencia (Retrieval-Augmented Generation)

1. **Peticion del Usuario**: El usuario formula una pregunta concreta desde el cliente REST (ej. "¿Que es la Inteligencia Artificial?"). La envia empaquetada en un formato JSON hacia la ruta del Webhook de consultas del Workflow 2.
2. **Entrada al Cerebro (AI Agent)**: La pregunta llega en crudo al nodo `AI Agent`. Este agente se encuentra configurado para usar a `llama3.2` como modelo cognitivo y se le ha restringido mediante un "Prompt" estricto la obligacion de utilizar su Herramienta adjunta (Tool).
3. **Retrieval (Busqueda Vectorial)**: El Agente acata la orden y le pasa la pregunta al sub-nodo de Qdrant. Este nodo repite el mismo proceso que en la ingesta:
   - Convierte la pregunta "¿Que es la IA?" a vectores usando `nomic-embed-text`.
   - Busca en Qdrant que chunks literarios (de los subidos en la fase 1) estan matematicamente mas "cerquita" de la pregunta.
   - Extrae el texto legible y se lo devuelve al Agente.
4. **Generation (Respuesta Sintetizada)**: Ahora `llama3.2` posee dos piezas clave: Tu pregunta y tus trozos de apuntes. En fraccion de segundos, lee los apuntes, localiza la respuesta a tu cuestion y te la redacta humanamente, ignorando lo que el sepa de normal por internet y ciñendose a tu base de conocimiento local.
5. **Registro de la Conversacion (PostgreSQL)**: Al mismo tiempo que el Agente redacta la respuesta, el flujo desciende a un nodo relacional que deposita tu pregunta y la larga respueta final en la tabla `consultas_rag` de PostgreSQL.
6. **Entrega Final**: El usuario visualizará en su cliente de origen (VS Code, cURL, etc) el HTTP STATUS 200 OK seguido de la exquisita redaccion del modelo Llama.
