-- Migració 005: Saldo inicial de Tresoreria (un valor per any)
--
-- Executa aquest script a la consola SQL de Neon connectat a la base de dades
-- d'aquest Dashboard. Després d'executar-lo, ves a la secció "Data API" de la
-- consola de Neon i clica "Refresh schema cache" (el NOTIFY per si sol no
-- sempre és suficient per a la Data API de Neon).

BEGIN;

CREATE TABLE IF NOT EXISTS saldo_inicial_tresoreria (
  any_liquidacio integer PRIMARY KEY,
  import numeric NOT NULL DEFAULT 0
);

GRANT SELECT, INSERT, UPDATE, DELETE ON saldo_inicial_tresoreria TO authenticated;

COMMIT;
