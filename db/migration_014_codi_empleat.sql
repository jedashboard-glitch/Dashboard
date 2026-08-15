-- Migració 014: Codi d'empleat i DNI/NIE a nòmines
--
-- Dos camps nous per identificar cada empleat de forma robusta (com ja
-- fem amb "codi" a clients/proveïdors), en lloc de dependre nomes del
-- text del nom -- que ja hem vist que pot venir escrit de manera
-- inconsistent entre exportacions.
--
-- codi: ordre d'entrada (estil PGC, com codi a clients/proveïdors).
-- dni: identificador personal de l'empleat (DNI o NIE).
--
-- Com sempre: després d'executar-ho, "Refresh schema cache" a Data API a
-- la consola de Neon.

BEGIN;

ALTER TABLE nomines
  ADD COLUMN IF NOT EXISTS codi text,
  ADD COLUMN IF NOT EXISTS dni text;

COMMIT;
