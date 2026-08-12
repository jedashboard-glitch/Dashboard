-- Migració 004: desglossar SS treballador/empresa a nòmines + ajornaments de SS
--
-- Executa aquest script a la consola SQL de Neon (o via psql) connectat a la
-- base de dades d'aquest Dashboard.

BEGIN;

ALTER TABLE nomines ADD COLUMN IF NOT EXISTS ss_trab numeric NOT NULL DEFAULT 0;

-- Marca un mes concret com a "SS Empresa ajornada" (mateixa idea que
-- iva_ajornaments, però per mes ja que la SS es liquida mensualment).
CREATE TABLE IF NOT EXISTS ss_ajornaments (
  any_liquidacio integer NOT NULL,
  mes smallint NOT NULL CHECK (mes BETWEEN 0 AND 11),
  ajornat boolean NOT NULL DEFAULT true,
  PRIMARY KEY (any_liquidacio, mes)
);

COMMIT;
