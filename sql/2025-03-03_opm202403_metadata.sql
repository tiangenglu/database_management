SELECT * FROM fact WHERE 1=0; /*colnames only*/
SELECT * FROM pg_catalog.pg_tables WHERE schemaname = 'public'; /*show all tables in schema*/
SELECT * FROM pg_database; /*all attributes of all databases, including templates*/
SELECT datname FROM pg_database; /*show name of databases*/
SELECT datname FROM pg_database WHERE datistemplate = FALSE; /*show non-template databases*/
SELECT table_schema, table_name FROM information_schema.tables 
ORDER BY table_schema, table_name; /*include table_schema = 'pg_catalog','information_schema','public'*/
SELECT * FROM information_schema.tables LIMIT 10; /*all tables in database*/
SELECT table_catalog, table_schema, table_name FROM information_schema.tables 
WHERE table_schema = 'public'; /*shows the actual tables I just created*/