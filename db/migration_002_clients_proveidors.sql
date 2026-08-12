-- Migració 002: Clients, Proveïdors, número de factura, IRPF i anul·lació de factures
--
-- Executa aquest script a la consola SQL de Neon (o via psql) connectat a la
-- base de dades d'aquest Dashboard. No té res a veure amb el projecte Neon de
-- l'ERP d'ACR Estruch (és un backend diferent).
--
-- IMPORTANT: si factures_emeses / factures_rebudes tenen Row Level Security
-- (RLS) activat per exposar-se via la Neon Data API, revisa quines polítiques
-- tenen (taula pg_policies) i crea polítiques equivalents per a `clients` i
-- `proveidors`, perquè aquest script no les pot detectar ni copiar.

BEGIN;

-- ── Clients ────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS clients (
  id serial PRIMARY KEY,
  nom text NOT NULL,
  nif text,
  adreca text,
  telefon text,
  email text,
  iva_pct numeric NOT NULL DEFAULT 21,
  irpf_pct numeric NOT NULL DEFAULT 0,
  notes text,
  actiu boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now()
);

-- ── Proveïdors ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS proveidors (
  id serial PRIMARY KEY,
  nom text NOT NULL,
  nif text,
  adreca text,
  telefon text,
  email text,
  iva_pct numeric NOT NULL DEFAULT 21,
  irpf_pct numeric NOT NULL DEFAULT 0,
  tipus_cost_default text CHECK (tipus_cost_default IN ('fix','variable')),
  notes text,
  actiu boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now()
);

-- ── Factures emeses: número, IRPF, vincle a client, anul·lació ─────────────
ALTER TABLE factures_emeses
  ADD COLUMN IF NOT EXISTS num_factura text,
  ADD COLUMN IF NOT EXISTS client_id integer REFERENCES clients(id),
  ADD COLUMN IF NOT EXISTS irpf_pct numeric NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS irpf_import numeric NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS estat text NOT NULL DEFAULT 'activa',
  ADD COLUMN IF NOT EXISTS data_anullacio date,
  ADD COLUMN IF NOT EXISTS motiu_anullacio text;

ALTER TABLE factures_emeses DROP CONSTRAINT IF EXISTS factures_emeses_estat_check;
ALTER TABLE factures_emeses
  ADD CONSTRAINT factures_emeses_estat_check CHECK (estat IN ('activa','anullada'));

-- ── Factures rebudes: número, IRPF, vincle a proveïdor, anul·lació ─────────
ALTER TABLE factures_rebudes
  ADD COLUMN IF NOT EXISTS num_factura text,
  ADD COLUMN IF NOT EXISTS proveidor_id integer REFERENCES proveidors(id),
  ADD COLUMN IF NOT EXISTS irpf_pct numeric NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS irpf_import numeric NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS estat text NOT NULL DEFAULT 'activa',
  ADD COLUMN IF NOT EXISTS data_anullacio date,
  ADD COLUMN IF NOT EXISTS motiu_anullacio text;

ALTER TABLE factures_rebudes DROP CONSTRAINT IF EXISTS factures_rebudes_estat_check;
ALTER TABLE factures_rebudes
  ADD CONSTRAINT factures_rebudes_estat_check CHECK (estat IN ('activa','anullada'));

-- ── Backfill: crea clients/proveïdors a partir dels noms de text existents
--    i vincula les factures ja creades ────────────────────────────────────
INSERT INTO clients (nom)
SELECT DISTINCT client FROM factures_emeses
WHERE client IS NOT NULL AND client <> ''
  AND client NOT IN (SELECT nom FROM clients);

UPDATE factures_emeses fe
SET client_id = c.id
FROM clients c
WHERE fe.client_id IS NULL AND c.nom = fe.client;

INSERT INTO proveidors (nom)
SELECT DISTINCT proveidor FROM factures_rebudes
WHERE proveidor IS NOT NULL AND proveidor <> ''
  AND proveidor NOT IN (SELECT nom FROM proveidors);

UPDATE factures_rebudes fr
SET proveidor_id = p.id
FROM proveidors p
WHERE fr.proveidor_id IS NULL AND p.nom = fr.proveidor;

COMMIT;
