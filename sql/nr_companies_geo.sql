-- ═══════════════════════════════════════════════════════════
-- nr_companies — add geographic coordinates
-- Run once in the Supabase SQL editor, BEFORE applying the
-- scc.html patch in scc_geo_patch.md.
--
-- Why: the SharePoint Supplier Database (site: SCRLDatabase,
-- list: Companies) already stores 'lat'/'lng' — they are the
-- same columns NuccolSupplierMap plots its markers from. The
-- Supplier Database screen in scc.html already syncs city,
-- county, postcode, address, employees, turnover and
-- main_commodity_group onto the linked nr_companies row via
-- sdbProfileFieldsFor(); it just never carried the two
-- coordinate columns across. These columns are where they land.
--
-- numeric(9,6) rather than double precision on purpose:
-- sdbSyncTagsToCrm compares old and new values with String(),
-- so a float that round-trips as 53.590300000000006 would look
-- changed on every single load and rewrite the row forever.
-- 6 decimal places is ~0.11 m — far more than postcode-centroid
-- data justifies — and round-trips exactly.
-- ═══════════════════════════════════════════════════════════

alter table nr_companies
  add column if not exists lat numeric(9,6),
  add column if not exists lng numeric(9,6);

-- Tell PostgREST about the new column. Without this the REST API
-- keeps its cached schema, selecting the column 400s, and callers
-- that ask for it fall back to a reduced column set — which is how
-- scc.html quietly stopped syncing location fields.
notify pgrst, 'reload schema';


-- Sanity bounds. NOT VALID so the statement cannot fail on any
-- row already present; drop the NOT VALID once you have run the
-- validate statements at the bottom.
alter table nr_companies
  drop constraint if exists nr_companies_lat_range;
alter table nr_companies
  add constraint nr_companies_lat_range
  check (lat is null or (lat between -90 and 90)) not valid;

alter table nr_companies
  drop constraint if exists nr_companies_lng_range;
alter table nr_companies
  add constraint nr_companies_lng_range
  check (lng is null or (lng between -180 and 180)) not valid;

-- Partial index: every map query filters to rows that actually
-- have coordinates, so there is no point indexing the nulls.
create index if not exists nr_companies_latlng_idx
  on nr_companies(lat, lng)
  where lat is not null and lng is not null;

-- ── RLS ────────────────────────────────────────────────────
-- Nothing to do. nr_launch_lockdown.sql uses row-level policies
-- only (is_staff() for write, public read on nr_companies), and
-- Postgres RLS is row-level, not column-level. New columns are
-- covered by the existing policies automatically.

-- ── Checks to run after the scc.html patch is live ─────────
-- 1. How many members can ever receive coordinates? Only rows
--    linked to a SharePoint record inherit them:
--
--      select count(*) filter (where sharepoint_company_id is not null) as linked,
--             count(*) filter (where sharepoint_company_id is null)     as unlinked,
--             count(*)                                                  as total
--      from nr_companies where hidden = false;
--
-- 2. After a Supplier Database screen load, what landed:
--
--      select count(*) filter (where lat is not null)                   as mapped,
--             count(*) filter (where lat is null and postcode is not null) as geocodable,
--             count(*) filter (where lat is null and postcode is null)  as no_location
--      from nr_companies where hidden = false;
--
--    Anything in 'geocodable' is a job for Pythons_Updaters/Geocode/regeocode.py.
--    Anything in 'no_location' needs a postcode from the member first.
--
-- 3. Once you are happy the data is sane, validate the constraints:
--
--      alter table nr_companies validate constraint nr_companies_lat_range;
--      alter table nr_companies validate constraint nr_companies_lng_range;
