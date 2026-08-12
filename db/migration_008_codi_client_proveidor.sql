-- Migració 008: Codi comptable (estil PGC) per a clients i proveïdors
--
-- Executa aquest script a la consola SQL de Neon i, com sempre, clica
-- "Refresh schema cache" a Data API després.

BEGIN;

ALTER TABLE clients ADD COLUMN IF NOT EXISTS codi text;
ALTER TABLE proveidors ADD COLUMN IF NOT EXISTS codi text;

COMMIT;
