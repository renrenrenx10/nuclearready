-- nr_companies_clear_clash_residue.sql
-- Run AFTER the four companies were re-linked in scc (keys 3484-3487).
--
-- The re-link worked: city/county/postcode now come from the right SharePoint
-- rows. Three fields could not follow, because sdbProfileFieldsFor only writes
-- a field when the SharePoint value is non-empty -- it never overwrites a
-- populated CRM field with a blank one. SharePoint holds no Address and (for
-- three of the four) no coordinates, so each row kept its clash partner's:
--     Longcliffe <- Ultramag (Bournemouth)      Navantia <- Vapormatt (Bridgwater)
--     Preformed  <- Underhill (Plymouth)        Orbital  <- Wakefield (Heckmondwike)
-- region is stale too: the sync deliberately never syncs it, because
-- SharePoint's field_9 "RegionalIA" is the advisor's name, not a region.
--
-- Coordinates below are from postcodes.io for each company's real postcode.
-- Navantia's already matched SharePoint exactly, so it is left as it is.
-- Safe to run more than once.

begin;

create table if not exists nr_companies_residue_backup as
  select * from nr_companies where sharepoint_company_id in ('3484','3485','3486','3487');

update nr_companies set
  address = null, region = 'East Midlands',
  lat = 53.098804, lng = -1.661899
where sharepoint_company_id = '3484';          -- Longcliffe Quarries, DE4 4HN

update nr_companies set
  address = null, region = 'Yorkshire and The Humber',
  lat = 53.345317, lng = -1.296847
where sharepoint_company_id = '3485';          -- Preformed Windings, S26 5NU

update nr_companies set
  address = null, region = 'Scotland'
where sharepoint_company_id = '3486';          -- Navantia, HS2 9JY (coords already correct)

update nr_companies set
  address = null, region = 'East of England',
  lat = 52.339063, lng = -0.065306
where sharepoint_company_id = '3487';          -- Orbital Fabrications, PE27 3WJ

commit;

-- check
select sharepoint_company_id, name, address, city, county, postcode, region, lat, lng
from nr_companies
where sharepoint_company_id in ('3484','3485','3486','3487')
order by sharepoint_company_id;
