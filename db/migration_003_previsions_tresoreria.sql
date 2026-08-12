-- Migració 003: Previsions manuals de Tresoreria
--
-- Executa aquest script a la consola SQL de Neon (o via psql) connectat a la
-- base de dades d'aquest Dashboard.
--
-- IMPORTANT: si factures_emeses / factures_rebudes tenen Row Level Security
-- (RLS) activat per exposar-se via la Neon Data API, revisa quines polítiques
-- tenen (taula pg_policies) i crea polítiques equivalents per a
-- `previsions_tresoreria`, perquè aquest script no les pot detectar ni copiar.

BEGIN;

CREATE TABLE IF NOT EXISTS previsions_tresoreria (
  id serial PRIMARY KEY,
  etiqueta text NOT NULL,
  tipus text NOT NULL CHECK (tipus IN ('cobrament','pagament')),
  data date NOT NULL,
  import numeric NOT NULL DEFAULT 0,
  notes text,
  created_at timestamptz NOT NULL DEFAULT now()
);

-- Marca un trimestre concret com a "ajornat a Hisenda": quan és ajornat, la
-- fila automàtica "Liquidació IVA trimestral" no inclou el pagament d'aquell
-- trimestre (l'usuari el reparteix manualment amb línies de previsió, p.ex.
-- "Hisenda IVA ajornat", als mesos que li hagi concedit Hisenda).
CREATE TABLE IF NOT EXISTS iva_ajornaments (
  any_liquidacio integer NOT NULL,
  trimestre smallint NOT NULL CHECK (trimestre BETWEEN 0 AND 3),
  ajornat boolean NOT NULL DEFAULT true,
  PRIMARY KEY (any_liquidacio, trimestre)
);

COMMIT;
