-- Migració 017: marcar com a "pagat" l'IVA, l'IRPF-111 i la SS des del
-- panell "Pagaments" de Financials.
--
-- Fins ara, iva_ajornaments i ss_ajornaments només guarden si un període
-- s'ha "ajornat" (i la fila es crea/esborra segons aquest únic booleà —
-- vegeu toggleAjornament/toggleSSAjornament a reports.html). Per no tocar
-- aquesta lògica ja existent i en producció, el "pagat" es guarda en taules
-- noves i independents, amb la mateixa idea: la fila només existeix quan
-- pagat=true (s'esborra en desmarcar-la). L'IRPF-111 no tenia cap taula
-- pròpia fins ara (no té ajornament), per això aquí en crea una de zero.
--
-- Executa aquest script a la consola SQL de Neon (o via psql) connectat a
-- la base de dades d'aquest Dashboard. Com sempre: després d'executar-ho,
-- cal clicar "Refresh schema cache" a Data API a la consola de Neon.
--
-- IMPORTANT: si iva_ajornaments/ss_ajornaments tenen Row Level Security
-- (RLS) activat per exposar-se via la Neon Data API, revisa les seves
-- polítiques (taula pg_policies) i crea polítiques equivalents per a
-- aquestes tres taules noves, perquè aquest script no les pot copiar.

BEGIN;

CREATE TABLE IF NOT EXISTS iva_pagaments (
  any_liquidacio integer NOT NULL,
  trimestre smallint NOT NULL CHECK (trimestre BETWEEN 0 AND 3),
  pagat boolean NOT NULL DEFAULT true,
  data_pagament date,
  PRIMARY KEY (any_liquidacio, trimestre)
);

CREATE TABLE IF NOT EXISTS ss_pagaments (
  any_liquidacio integer NOT NULL,
  mes smallint NOT NULL CHECK (mes BETWEEN 0 AND 11),
  pagat boolean NOT NULL DEFAULT true,
  data_pagament date,
  PRIMARY KEY (any_liquidacio, mes)
);

CREATE TABLE IF NOT EXISTS irpf_pagaments (
  any_liquidacio integer NOT NULL,
  trimestre smallint NOT NULL CHECK (trimestre BETWEEN 0 AND 3),
  pagat boolean NOT NULL DEFAULT true,
  data_pagament date,
  PRIMARY KEY (any_liquidacio, trimestre)
);

COMMIT;
