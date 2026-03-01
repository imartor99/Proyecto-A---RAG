-- Tabla 1: Documentos procesados
CREATE TABLE documentos (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(255) NOT NULL,
  ruta_archivo TEXT,
  num_chunks INTEGER,
  fecha_procesado TIMESTAMP DEFAULT NOW()
);

-- Índice para búsquedas rápidas
CREATE INDEX idx_documentos_nombre 
ON documentos(nombre);

-- Tabla 2: Historial de consultas RAG
CREATE TABLE consultas_rag (
  id SERIAL PRIMARY KEY,
  pregunta TEXT NOT NULL,
  respuesta TEXT NOT NULL,
  documentos_usados TEXT[], -- Array de nombres de docs
  timestamp TIMESTAMP DEFAULT NOW()
);

-- Índice para consultas recientes
CREATE INDEX idx_consultas_timestamp 
ON consultas_rag(timestamp DESC);
