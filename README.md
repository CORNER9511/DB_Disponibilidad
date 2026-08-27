# DB_DISPONIBILIDAD - Scripts de Base de Datos

Exportación de la base de datos `DB_DISPONIBILIDAD` (Oracle), generada desde SQL Developer y dividida en archivos por tipo de objeto para facilitar su lectura y control de versiones en GitHub.

## Contenido

| Archivo | Contenido |
|---|---|
| `01_sequences.sql` | Secuencias (SEQ_*) usadas como generadores de ID |
| `02_tables.sql` | Definición de tablas (CREATE TABLE) y comentarios de columnas/tablas |
| `03_data.sql` | Datos de prueba (INSERT) |
| `04_indexes.sql` | Índices únicos y de búsqueda (PK/UK) |
| `05_packages.sql` | Paquete PL/SQL `PKG_APP_INDISPONIBILIDADES` (spec + body) |
| `06_constraints.sql` | Constraints de llave primaria/única y llaves foráneas (FK) |

## Orden de ejecución

Si necesitas recrear la base de datos desde cero, ejecuta los scripts **en este orden**:

1. `01_sequences.sql`
2. `02_tables.sql`
3. `04_indexes.sql`
4. `06_constraints.sql`
5. `05_packages.sql`
6. `03_data.sql` (opcional, solo si quieres cargar los datos de prueba)

> Nota: las llaves foráneas dependen de que las tablas referenciadas ya existan, por eso van después de `02_tables.sql`.

## Origen

Generado con Oracle SQL Developer (Database Export) el 27 de agosto de 2026.
