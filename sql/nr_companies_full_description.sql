-- ═══════════════════════════════════════════════════════════
-- nr_companies / nr_profile_updates — add full_description
-- Run this ONCE in the Supabase SQL editor BEFORE deploying the
-- members.html and scc.html patches.
--
-- WHY: nr_companies has a single `description`, which
-- members.html collects as "a clear, public-facing summary of
-- what your company does". The v2 company page shows that at the
-- top, and wants a longer "about us" underneath the capabilities.
-- That is a second field, not a longer version of the same one.
--
-- ORDER MATTERS: scc.html's Companies screen selects FULL_COLS,
-- which will now ask for full_description. If the column does not
-- exist that select errors and the screen silently falls back to
-- its reduced column set (losing the Supplier Database field
-- sync). That fallback is by design, but it means SQL first,
-- deploy second.
--
-- RLS: nothing to do. nr_launch_lockdown.sql uses row-level
-- policies only, and Postgres RLS is row-level, not column-level,
-- so the new column is covered by the existing policies.
-- ═══════════════════════════════════════════════════════════

alter table nr_companies
  add column if not exists full_description text;

-- The member-submitted copy, pending staff review. nrApprove in
-- scc.html copies it across to nr_companies on approval.
alter table nr_profile_updates
  add column if not exists full_description text;

-- Tell PostgREST about the new column. Without this the REST API
-- keeps its cached schema, selecting the column 400s, and callers
-- that ask for it fall back to a reduced column set — which is how
-- scc.html quietly stopped syncing location fields.
notify pgrst, 'reload schema';


-- ── Check ──────────────────────────────────────────────────
-- Confirm both columns exist before deploying the HTML:
--
--   select table_name, column_name, data_type
--   from information_schema.columns
--   where column_name = 'full_description'
--     and table_name in ('nr_companies','nr_profile_updates');
--
-- Two rows back = good to deploy.
--
-- To seed one by hand while testing:
--   update nr_companies set full_description =
--     'First paragraph.' || chr(10) || chr(10) || 'Second paragraph.'
--   where name = 'Navantia';
-- Blank lines become paragraphs on the public page.
