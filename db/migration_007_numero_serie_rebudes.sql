-- Migració 007: Número de sèrie intern per a factures rebudes
--
-- Executa aquest script a la consola SQL de Neon connectat a la base de dades
-- d'aquest Dashboard. Després, com sempre, clica "Refresh schema cache" a
-- Data API a la consola de Neon.
--
-- numero_serie és el número de registre intern (mes + seqüencial de 4 xifres
-- que es reinicia cada mes/any), diferent de num_factura (el número que porta
-- la factura del proveïdor). Es genera sol en crear la factura i es renumera
-- en cancel·lar-ne una — no s'edita a mà.

BEGIN;

ALTER TABLE factures_rebudes ADD COLUMN IF NOT EXISTS numero_serie text;

COMMIT;
