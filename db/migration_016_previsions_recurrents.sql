-- Migració 016: Previsions manuals recurrents + secció
--
-- Dos aspectes nous a previsions_tresoreria, discutits amb l'usuari:
--
-- 1) Secció: perquè cada previsió de pagament es pinti a la Tresoreria
--    sota la secció correcta (Proveïdors/Hisenda/Personal/Finançament)
--    en lloc de caure sempre sota "Finançament" com fins ara.
--
-- 2) Previsions recurrents: en lloc de crear una fila per mes (p.ex. 3
--    files per "Liquidació IVA trimestral T1 2026 (ajornaments)"), una
--    sola fila amb termini_mesos indica que "import" és l'import MENSUAL
--    i que s'ha de repetir termini_mesos mesos a partir de "data" (data
--    d'inici). Si termini_mesos és NULL, es comporta com fins ara: una
--    previsió puntual d'un sol mes. dia_pagament es guarda només per a
--    us futur (p.ex. un llistat de pagaments del mes amb el dia exacte);
--    la Tresoreria treballa sempre a nivell de mes sencer i l'ignora.
--
-- Com sempre: després d'executar-ho, "Refresh schema cache" a Data API a
-- la consola de Neon.

BEGIN;

ALTER TABLE previsions_tresoreria
  ADD COLUMN IF NOT EXISTS seccio text,
  ADD COLUMN IF NOT EXISTS termini_mesos integer,
  ADD COLUMN IF NOT EXISTS dia_pagament smallint;

ALTER TABLE previsions_tresoreria DROP CONSTRAINT IF EXISTS previsions_tresoreria_seccio_check;
ALTER TABLE previsions_tresoreria
  ADD CONSTRAINT previsions_tresoreria_seccio_check
  CHECK (seccio IS NULL OR seccio IN ('proveidors','hisenda','personal','financament'));

ALTER TABLE previsions_tresoreria DROP CONSTRAINT IF EXISTS previsions_tresoreria_dia_pagament_check;
ALTER TABLE previsions_tresoreria
  ADD CONSTRAINT previsions_tresoreria_dia_pagament_check
  CHECK (dia_pagament IS NULL OR dia_pagament BETWEEN 1 AND 31);

COMMIT;
