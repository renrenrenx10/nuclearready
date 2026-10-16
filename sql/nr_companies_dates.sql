-- ═══════════════════════════════════════════════════════════
-- NuclearReady: Add granted_date + expiry_date columns
-- Run in Supabase SQL Editor
-- ═══════════════════════════════════════════════════════════

ALTER TABLE nr_companies ADD COLUMN IF NOT EXISTS granted_date date;
ALTER TABLE nr_companies ADD COLUMN IF NOT EXISTS expiry_date  date;

-- ── Update dates from F4N certificates ──────────────────────

-- Ace Polishing Services Ltd
UPDATE nr_companies SET granted_date = '2026-02-25', expiry_date = '2027-02-25'
  WHERE name ILIKE '%Ace Polishing%';

-- Agemaspark
UPDATE nr_companies SET granted_date = '2026-02-06', expiry_date = '2027-02-06'
  WHERE name ILIKE '%Agemaspark%';

-- BEP Surface Technologies
UPDATE nr_companies SET granted_date = '2025-06-25', expiry_date = '2026-06-25'
  WHERE name ILIKE '%BEP%';

-- BHC
UPDATE nr_companies SET granted_date = '2025-11-19', expiry_date = '2026-11-19'
  WHERE name ILIKE 'BHC%';

-- C2 Construction & Fabrication
UPDATE nr_companies SET granted_date = '2025-12-18', expiry_date = '2026-12-18'
  WHERE name ILIKE '%C2 Construction%';

-- Caunton Engineering
UPDATE nr_companies SET granted_date = '2025-09-17', expiry_date = '2026-09-17'
  WHERE name ILIKE '%Caunton%';

-- Ellis Patents
UPDATE nr_companies SET granted_date = '2025-09-24', expiry_date = '2026-09-24'
  WHERE name ILIKE '%Ellis Patents%';

-- Eurofabs (UK) Ltd
UPDATE nr_companies SET granted_date = '2025-12-12', expiry_date = '2026-12-12'
  WHERE name ILIKE '%Eurofabs%';

-- Exalto Bearings UK
UPDATE nr_companies SET granted_date = '2025-08-18', expiry_date = '2026-08-18'
  WHERE name ILIKE '%Exalto%';

-- Extract Technology
UPDATE nr_companies SET granted_date = '2025-10-08', expiry_date = '2026-10-08'
  WHERE name ILIKE '%Extract Technology%';

-- Hawke International (Hubbell Group)
UPDATE nr_companies SET granted_date = '2026-03-03', expiry_date = '2027-03-03'
  WHERE name ILIKE '%Hubbell%' OR name ILIKE '%Hawke%';

-- Koso Kent
UPDATE nr_companies SET granted_date = '2026-02-20', expiry_date = '2027-02-20'
  WHERE name ILIKE '%Koso%';

-- Landguard Engineering
UPDATE nr_companies SET granted_date = '2025-07-10', expiry_date = '2026-07-10'
  WHERE name ILIKE '%Landguard%';

-- Oldham Engineering
UPDATE nr_companies SET granted_date = '2025-07-24', expiry_date = '2026-07-24'
  WHERE name ILIKE '%Oldham%';

-- P.A.R.C. Ltd
UPDATE nr_companies SET granted_date = '2026-03-18', expiry_date = '2027-03-18'
  WHERE name ILIKE '%P.A.R.C%' OR name ILIKE '%PARC%' OR name ILIKE '%Product Assessment%';

-- RTR GmbH & Co. KG
UPDATE nr_companies SET granted_date = '2025-07-16', expiry_date = '2026-07-16'
  WHERE name ILIKE '%RTR%';

-- Rivencore Global Solutions
UPDATE nr_companies SET granted_date = '2025-07-23', expiry_date = '2026-07-23'
  WHERE name ILIKE '%Rivencore%';

-- SYSPAL Ltd
UPDATE nr_companies SET granted_date = '2025-07-08', expiry_date = '2026-07-08'
  WHERE name ILIKE '%Syspal%';

-- Trillium Flow Technologies
UPDATE nr_companies SET granted_date = '2025-09-08', expiry_date = '2026-09-08'
  WHERE name ILIKE '%Trillium%';

-- Vecom UK (cert says Vecom Sillavan)
UPDATE nr_companies SET granted_date = '2026-04-17', expiry_date = '2027-04-17'
  WHERE name ILIKE '%Vecom%';

-- ── Verify ──────────────────────────────────────────────────
SELECT name, status, granted_date, expiry_date
FROM nr_companies
WHERE granted_date IS NOT NULL
ORDER BY name;

