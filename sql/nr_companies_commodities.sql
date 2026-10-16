-- nr_companies_commodities.sql
-- Publish the commodity tags that already exist in SharePoint.
--
-- Company_Commodities holds 3,720 rows covering 1,007 companies, of which the
-- current F4N members account for 138 tags. None of it has ever reached
-- Supabase: scc.html fetched the list for its own filters but sdbTagsFor only
-- ever returned capabilities, accreditations and markets, and nr_companies had
-- nowhere to put commodities.
--
-- That gap is why NuclearReady's filter bar has a group labelled "commodity"
-- that actually filters on the capabilities field -- the real data was not
-- available, so it was pointed at the nearest thing that was.
--
-- jsonb to match capabilities / accreditations / markets.
-- RUN THIS BEFORE loading the updated scc.html: the new column is in
-- CRM_LINK_COLS_FULL, and without it that select 400s and scc silently falls
-- back to the reduced column set with field sync switched off.
-- Safe to run more than once.

alter table nr_companies
  add column if not exists commodities jsonb;

comment on column nr_companies.commodities is
  'Commodity tags from the SharePoint Company_Commodities list, synced by scc.html. Keyed on CompanyID, not the SharePoint item ID.';

notify pgrst, 'reload schema';

-- check: should list the column, and all-null until scc has refreshed once
select count(*) as members,
       count(commodities) as with_commodities
from nr_companies
where hidden = false;
