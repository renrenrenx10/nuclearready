-- nr_companies_links.sql
-- Member-supplied links: case studies, press, anything about themselves.
-- Shown on the company page under the full description.
--
-- Shape: a jsonb array of {"label": "...", "url": "..."} objects, e.g.
--   [{"label":"Our SMR case study","url":"https://example.com/smr"},
--    {"label":"Hinkley Point C profile","url":"https://example.com/hpc"}]
--
-- Label may be blank; the page falls back to showing the URL. Anything
-- without a usable URL is dropped at render time by safeUrl() in nr-data.js,
-- which also blocks javascript: and data: schemes. The page caps the list at
-- eight so a long paste cannot take over the layout.
--
-- Separate from the existing case_study_url, which stays as it is and keeps
-- driving the "Recent work" block.
--
-- Goes on nr_profile_updates too: members submit through there and staff
-- approve into nr_companies.
--
-- RUN THIS BEFORE loading the updated scc.html -- links is added to the
-- column lists, and without it that select 400s and scc drops to reduced
-- mode with field sync off. Same trap as the commodities column.
-- Safe to run more than once.

alter table nr_companies
  add column if not exists links jsonb;

alter table nr_profile_updates
  add column if not exists links jsonb;

comment on column nr_companies.links is
  'Member-supplied links as [{label,url}]. Rendered under the full description. URLs sanitised client-side by safeUrl().';

notify pgrst, 'reload schema';

-- check
select count(*) as members,
       count(links) as with_links
from nr_companies
where hidden = false;
