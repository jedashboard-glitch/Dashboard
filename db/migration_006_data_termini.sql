-- Migració 006: Data termini a factures emeses/rebudes (per a la vista Previsional de Tresoreria)
--
-- Executa aquest script a la consola SQL de Neon connectat a la base de dades
-- d'aquest Dashboard. Després d'executar-lo, ves a Data API i clica
-- "Refresh schema cache" (afegir columnes també invalida la cache).

BEGIN;

ALTER TABLE factures_emeses ADD COLUMN IF NOT EXISTS data_termini date;
ALTER TABLE factures_rebudes ADD COLUMN IF NOT EXISTS data_termini date;

COMMIT;
