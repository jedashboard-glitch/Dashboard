-- Migració 012: Càrrega inicial de clients des del CSV
--
-- Buida les taules clients i factures_emeses (reinicia els id des de l'1,
-- CASCADE per si factures_emeses tingués alguna fila via client_id) i
-- torna a carregar clients amb els 43 registres del CSV. Confirmat amb
-- l'usuari que factures_emeses ja estava buida i que no hi ha cap
-- registre de mostra pendent a clients, així que el TRUNCATE és segur.
--
-- Duplicat resolt: el codi 4300005 (COLEGIO SAN CRISTOBAL SL) sortia dues
-- vegades al CSV, una amb actiu=true i una amb actiu=false; per indicació
-- de l'usuari es manté només la fila amb actiu=false.
--
-- La columna "id" del CSV (idèntica a "codi") és l'id intern de l'ERP
-- antic, no el nostre id de Postgres -- s'ignora i es deixa que la
-- seqüència pròpia assigni els ids nous. codi és la clau de referència
-- (estil PGC: 43XXXXX per a clients).
--
-- Camps no inclosos al CSV (adreca, telefon, email, notes) queden a
-- NULL -- es poden completar més endavant des de la fitxa de cada client.
--
-- Com sempre: després d'executar-ho, "Refresh schema cache" a Data API a
-- la consola de Neon.

BEGIN;

TRUNCATE TABLE clients, factures_emeses RESTART IDENTITY CASCADE;

INSERT INTO clients (codi, nom, nif, cp, localitat, provincia, iva_pct, irpf_pct, actiu) VALUES
('4300000', 'CLIENTES CONTADO  MAPES', NULL, NULL, NULL, NULL, 21, 0, true),
('4300001', 'CENTRO DE NEGOCIOS ASERGALICIA SL', 'B36587301', '36450', 'SALVATERRA DE MIÑO', 'PONTEVEDRA', 21, 0, true),
('4300003', 'AFFINITY PECARES SA', NULL, NULL, NULL, NULL, 21, 0, false),
('4300005', 'COLEGIO SAN CRISTOBAL SL', NULL, NULL, NULL, NULL, 21, 0, false),
('4300006', 'DIPUTACION DE HUELVA', NULL, NULL, NULL, NULL, 21, 0, false),
('4300007', 'AFA INSTITUT D AURO', NULL, NULL, NULL, NULL, 21, 0, false),
('4300008', 'UNIVERSIDAD DE LA RIOJA', NULL, NULL, NULL, NULL, 21, 0, false),
('4300009', 'LAUAXETA IKASTOLA', NULL, NULL, NULL, NULL, 21, 0, false),
('4300010', 'BESELF BRANDS SL', NULL, NULL, NULL, NULL, 21, 0, false),
('4300011', 'ESCOLA MONTESSORI, SL', NULL, NULL, NULL, NULL, 21, 0, false),
('4300012', 'MDA GESTION Y ORGANIZACION DE EVENTOS Y COMUNICACION SL', NULL, NULL, NULL, NULL, 21, 0, false),
('4300013', 'FUNDACION EUROPEA EDUCACION Y LIBERTAD', NULL, NULL, NULL, NULL, 21, 0, false),
('4300014', 'SORAYA MANZANO SANCHEZ', NULL, NULL, NULL, NULL, 21, 0, true),
('4300015', 'COLEGIO SANTO ANGEL', NULL, NULL, NULL, NULL, 21, 0, false),
('4300016', 'MARIA BELTRAN ORTEGA', NULL, NULL, NULL, NULL, 21, 0, false),
('4300017', 'FINGAL ASESORAMIENTO INTEGRAL', NULL, NULL, NULL, NULL, 21, 0, true),
('4300018', 'FUNDACION PRINCESA DE GIRONA', NULL, NULL, NULL, NULL, 21, 0, false),
('4300019', 'ASSOCIACION DE EMPRESARIOS Y PROFESSIONALES DE LA CARNE Y DERIVADOS DE MADRID (CARNIMAD)', NULL, NULL, NULL, NULL, 21, 0, false),
('4300020', 'HAKABOOKS, SCP', NULL, NULL, NULL, NULL, 21, 0, false),
('4300021', 'ANALY BEATRIZ SILVA MORALES', NULL, NULL, NULL, NULL, 21, 0, false),
('4300022', 'INSTITUCIO PEDAGOGICA SANT ISIDOR', NULL, NULL, NULL, NULL, 21, 0, false),
('4300023', 'CRUIX RESTAURANT SL', 'B02971950', '08015', 'BARCELONA', 'BARCELONA', 21, 0, true),
('4300024', 'AYUNTAMIENTO DE SAX', 'P0312300G', '03630', 'SAX', 'ALICANTE', 21, 0, true),
('4300025', 'CINEMES GIRONA, SL', 'B65251092', '08037', 'BARCELONA', 'BARCELONA', 21, 0, true),
('4300026', 'INNER MIND, SL', 'B21780010', '08201', 'SABADELL', 'BARCELONA', 21, 0, true),
('4300027', 'ASSOCIACIÓ VEÏNAL DE SANT ANTONI', 'G58145178', '08015', 'BARCELONA', 'BARCELONA', 21, 0, true),
('4300028', 'INDUSTRIAL CARROCERA ARBUCIENSE, SA', 'A17227935', '17401', 'ARBUCIES', 'GIRONA', 21, 0, true),
('4300029', 'AMPA LA SALLE MOLLERUSSA', 'G25304098', '25230', 'MOLLERUSSA', 'LLEIDA', 21, 0, true),
('4300030', 'AJUNTAMENT DE MONTCADA I REIXAC', 'P0812400J', '08110', 'MONTCADA I REIXAC', 'BARCELONA', 21, 0, true),
('4300031', 'ANA GOMEZ DE CABO', '70887714N', '46758', 'BARX', 'VALENCIA', 21, 0, true),
('4300032', 'AJUNTAMENT DE PUIG-REIG', 'P0817400E', '08692', 'PUIG-REIG', 'BARCELONA', 21, 0, true),
('4300033', 'AJUNTAMENT DE CANALS', 'P4608300B', '46650', 'CANALS', 'VALENCIA', 21, 0, true),
('4300034', 'OFICINA DE SUPORT A LA INICIATIVA CULTURAL (OSIC)', 'Q0801883J', '08029', 'BARCELONA', 'BARCELONA', 21, 0, true),
('4300300', 'CLIENTS COMPTAT EDITORIAL', NULL, NULL, NULL, NULL, 21, 0, true),
('4300301', 'ROSANA BEATRIZ DEBELLIS', 'X6033426C', '28055', 'MADRID', 'MADRID', 21, 0, true),
('4300302', 'CARMEN FERNANDEZ VARGAS', '75012483F', '28821', 'MADRID', 'MADRID', 21, 0, true),
('4300303', 'MARIA CONSOLACIÓN CANO SANCHEZ', '26242755P', NULL, NULL, NULL, 21, 0, true),
('4300304', 'SANTI CASANELLAS SOLER', '77307549H', '08734', 'MOJA', 'BARCELONA', 21, 0, true),
('4300305', 'ANA BELEN GONZALEZ', NULL, NULL, NULL, NULL, 21, 0, false),
('4300500', 'AJUNTAMENT DE LLAVANERES', NULL, NULL, NULL, NULL, 21, 0, false),
('4300800', 'CLIENTS COMPTAT PSICOLOGIA', NULL, NULL, NULL, NULL, 21, 0, true),
('4300900', 'VENDA MERXANDATGE', NULL, NULL, NULL, NULL, 21, 0, false),
('4300999', 'CLIENTES VENDA ENTRADAS', NULL, NULL, NULL, NULL, 21, 0, false);

COMMIT;
