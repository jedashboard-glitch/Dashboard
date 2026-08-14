-- Migració 011: CP, Localitat i Província a clients
--
-- Camps addicionals a l'adreça, per preparar la càrrega massiva de
-- clients i factures emeses.
--
-- Com sempre: després d'executar-ho, cal clicar "Refresh schema cache"
-- a Data API a la consola de Neon.

BEGIN;

ALTER TABLE clients
  ADD COLUMN IF NOT EXISTS cp text,
  ADD COLUMN IF NOT EXISTS localitat text,
  ADD COLUMN IF NOT EXISTS provincia text;

COMMIT;
