-- ═══════════════════════════════════════════════════════════
-- NuclearReady: add case_study_url to nr_companies
-- Run this in Supabase SQL Editor
-- ═══════════════════════════════════════════════════════════

-- 1. Add the column (safe to re-run)
ALTER TABLE nr_companies ADD COLUMN IF NOT EXISTS case_study_url text;

-- 2. Link Backer Heatrod's published F4N case study.
--    NOTE: this must be the FULL absolute URL (not "f4n-case-study.html?slug=..."),
--    because NuclearReady.html is served from a different site
--    (github.io/nuccol-tools) to the case study page (nuccol.co.uk) — a relative
--    path would resolve against the wrong domain.
UPDATE nr_companies
SET case_study_url = 'https://www.nuccol.co.uk/f4n-case-study.html?slug=backer-heatrod-ltd-addcca'
WHERE name = 'Backer Heatrod';
