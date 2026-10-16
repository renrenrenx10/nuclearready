-- nr_companies_rekey_four.sql
-- Re-key the four newly-added members onto their new SharePoint CompanyIDs,
-- and repair the location fields that the item-ID key collision overwrote.
--
-- Background: these four had a blank CompanyID, so scc's `CompanyID ?? field_1`
-- fell through to the SharePoint item ID. Each item ID is already another
-- company's CompanyID, so those companies' syncs wrote their own addresses into
-- these rows:
--     3475 Longcliffe  <- ULTRAMAG INSPECTION   (Bournemouth BH4 9DW)
--     3476 Preformed   <- UNDERHILL ENGINEERING (Plymouth    PL7 5BG)
--     3477 Navantia    <- VAPORMATT             (Bridgwater  TA6 4DL)
--     3478 Orbital     <- WAKEFIELD ACOUSTICS   (Heckmondwike WF16 0EN)
-- Values below are from the SharePoint Companies export of 2026-10-15.
-- Safe to run more than once.

begin;

create table if not exists nr_companies_rekey_backup as
  select * from nr_companies where sharepoint_company_id in
    ('3475','3476','3477','3478','3484','3485','3486','3487');

-- Longcliffe Quarries Limited
update nr_companies set
  sharepoint_company_id = '3484',
  city = 'Matlock', county = 'Derbyshire', postcode = 'DE4 4HN',
  region = 'East Midlands', lat = null, lng = null
where sharepoint_company_id in ('3475','3484');

-- Preformed Windings Ltd
update nr_companies set
  sharepoint_company_id = '3485',
  city = 'Sheffield', county = 'South Yorkshire', postcode = 'S26 5NU',
  region = 'Yorkshire and The Humber', lat = null, lng = null
where sharepoint_company_id in ('3476','3485');

-- Navantia  (the only one of the four with coordinates in SharePoint)
update nr_companies set
  sharepoint_company_id = '3486',
  city = 'Isle of Lewis', county = 'Western Isles', postcode = 'HS2 9JY',
  region = 'Scotland', lat = 58.189473, lng = -6.375274
where sharepoint_company_id in ('3477','3486');

-- Orbital Fabrications
update nr_companies set
  sharepoint_company_id = '3487',
  city = 'St. Ives', county = 'Cambridgeshire', postcode = 'PE27 3WJ',
  region = 'East of England', lat = null, lng = null
where sharepoint_company_id in ('3478','3487');

commit;

notify pgrst, 'reload schema';

-- check
select sharepoint_company_id, name, city, county, postcode, region, lat, lng
from nr_companies
where sharepoint_company_id in ('3484','3485','3486','3487')
order by sharepoint_company_id;
