-- ═══════════════════════════════════════════════════════════
-- nr_companies — APPLY the region rebuild
--
-- Run the whole file in one go. It backs up first, then writes.
-- This replaces the commented-out section 3 of
-- nr_companies_region_backfill.sql, which was a pain to uncomment.
--
-- WHAT IT FIXES: region currently holds the Regional Industry
-- Advisor's NAME for most rows (Andy Hinton, John Hilton, Dug
-- Harrison, Paul Hayes, Huw Jenkins, Nigel Goodrich, Sean Murphy,
-- Kevin Ross), with only Scotland and Wales being real regions.
-- SharePoint field_9 "RegionalIA" is a staff member, not a place.
-- The Region filter on the live Explorer therefore matches almost
-- nothing: every region reads 0 except those two.
--
-- Lookups are lifted verbatim from
-- NuccolSupplierMap_v1_frankie_theme.html (121 postcode areas,
-- 87 counties), so this resolves to exactly the regions the
-- supplier map already plots by. Regenerate from that file if it
-- ever changes; do not maintain a second copy by hand.
--
-- Postcode wins over county, matching postcodeToRegion() ||
-- COUNTY_REGION[] in that file. Where neither resolves this writes
-- NULL rather than falling back to the raw county — a null is
-- honest; a stray county in a region column is how this started.
--
-- SAFE TO RE-RUN: it recreates the backup each time, so run it
-- again after correcting a postcode and the regions follow.
-- ═══════════════════════════════════════════════════════════


-- ── 1. Backup (rolls the whole thing back) ─────────────────
drop table if exists nr_companies_region_backup;
create table nr_companies_region_backup as
  select id, name, region, postcode, county, now() as backed_up_at
  from nr_companies;


-- ── 2. Apply ───────────────────────────────────────────────
with pc_map(area, region) as (values
    ('AB','Scotland'), ('AL','East of England'), ('B','West Midlands'), ('BA','South West'),
    ('BB','North West'), ('BD','Yorkshire and The Humber'), ('BH','South West'), ('BL','North West'),
    ('BN','South East'), ('BR','London'), ('BS','South West'), ('BT','Northern Ireland'),
    ('CA','North West'), ('CB','East of England'), ('CF','Wales'), ('CH','North West'),
    ('CM','East of England'), ('CO','East of England'), ('CR','London'), ('CT','South East'),
    ('CV','West Midlands'), ('CW','North West'), ('DA','South East'), ('DD','Scotland'),
    ('DE','East Midlands'), ('DG','Scotland'), ('DH','North East'), ('DL','North East'),
    ('DN','Yorkshire and The Humber'), ('DT','South West'), ('DY','West Midlands'), ('E','London'),
    ('EC','London'), ('EH','Scotland'), ('EN','London'), ('EX','South West'),
    ('FK','Scotland'), ('FY','North West'), ('G','Scotland'), ('GL','South West'),
    ('GU','South East'), ('HA','London'), ('HD','Yorkshire and The Humber'), ('HG','Yorkshire and The Humber'),
    ('HP','South East'), ('HR','West Midlands'), ('HS','Scotland'), ('HU','Yorkshire and The Humber'),
    ('HX','Yorkshire and The Humber'), ('IG','London'), ('IP','East of England'), ('IV','Scotland'),
    ('KA','Scotland'), ('KT','London'), ('KW','Scotland'), ('KY','Scotland'),
    ('L','North West'), ('LA','North West'), ('LD','Wales'), ('LE','East Midlands'),
    ('LL','Wales'), ('LN','East Midlands'), ('LS','Yorkshire and The Humber'), ('LU','East of England'),
    ('M','North West'), ('ME','South East'), ('MK','South East'), ('ML','Scotland'),
    ('N','London'), ('NE','North East'), ('NG','East Midlands'), ('NN','East Midlands'),
    ('NP','Wales'), ('NR','East of England'), ('NW','London'), ('OL','North West'),
    ('OX','South East'), ('PA','Scotland'), ('PE','East of England'), ('PH','Scotland'),
    ('PL','South West'), ('PO','South East'), ('PR','North West'), ('RG','South East'),
    ('RH','South East'), ('RM','London'), ('S','Yorkshire and The Humber'), ('SA','Wales'),
    ('SE','London'), ('SG','East of England'), ('SK','North West'), ('SL','South East'),
    ('SM','London'), ('SN','South West'), ('SO','South East'), ('SP','South West'),
    ('SR','North East'), ('SS','East of England'), ('ST','West Midlands'), ('SW','London'),
    ('SY','West Midlands'), ('TA','South West'), ('TD','Scotland'), ('TF','West Midlands'),
    ('TN','South East'), ('TQ','South West'), ('TR','South West'), ('TS','North East'),
    ('TW','London'), ('UB','London'), ('W','London'), ('WA','North West'),
    ('WC','London'), ('WD','East of England'), ('WF','Yorkshire and The Humber'), ('WN','North West'),
    ('WR','West Midlands'), ('WS','West Midlands'), ('WV','West Midlands'), ('YO','Yorkshire and The Humber'),
    ('ZE','Scotland')
), cty_map(county, region) as (values
    ('Carmarthenshire','Wales'), ('Berkshire','South East'), ('Devon','South West'), ('Warwickshire','West Midlands'),
    ('Cornwall','South West'), ('West Midlands','West Midlands'), ('Lanarkshire','Scotland'), ('Norfolk','East of England'),
    ('Merseyside','North West'), ('Nottinghamshire','East Midlands'), ('Staffordshire','West Midlands'), ('Tyne And Wear','North East'),
    ('Greater Manchester','North West'), ('Avon','South West'), ('Cumbria','North West'), ('Angus','Scotland'),
    ('Lancashire','North West'), ('London','London'), ('Kent','South East'), ('South Yorkshire','Yorkshire and The Humber'),
    ('Dorset','South West'), ('Hampshire','South East'), ('Surrey','South East'), ('Worcestershire','West Midlands'),
    ('West Yorkshire','Yorkshire and The Humber'), ('Wiltshire','South West'), ('Suffolk','East of England'), ('Buckinghamshire','South East'),
    ('Derbyshire','East Midlands'), ('Essex','East of England'), ('Stirlingshire','Scotland'), ('Shropshire','West Midlands'),
    ('Leicestershire','East Midlands'), ('Somerset','South West'), ('Cambridgeshire','East of England'), ('Gloucestershire','South West'),
    ('North Humberside','Yorkshire and The Humber'), ('North Yorkshire','Yorkshire and The Humber'), ('Oxfordshire','South East'), ('Aberdeenshire','Scotland'),
    ('Middlesex','London'), ('Midlothian','Scotland'), ('Hertfordshire','East of England'), ('Gwent','Wales'),
    ('County Durham','North East'), ('West Glamorgan','Wales'), ('Fife','Scotland'), ('Cheshire','North West'),
    ('Lincolnshire','East Midlands'), ('West Sussex','South East'), ('South Lanarkshire','Scotland'), ('Torfaen','Wales'),
    ('Greater London','London'), ('East Riding of Yorkshire','Yorkshire and The Humber'), ('West Lothian','Scotland'), ('Northamptonshire','East Midlands'),
    ('Gwynedd','Wales'), ('Bristol','South West'), ('Ayrshire','Scotland'), ('Bedfordshire','East of England'),
    ('Tyne & Wear','North East'), ('Clwyd','Wales'), ('Mid Glamorgan','Wales'), ('Renfrewshire','Scotland'),
    ('Northumberland','North East'), ('East Sussex','South East'), ('Deeside','Wales'), ('Cleveland','North East'),
    ('County Londonderry','Northern Ireland'), ('Inverness-Shire','Scotland'), ('Herefordshire','West Midlands'), ('Powys','Wales'),
    ('Isle Of Wight','South East'), ('Dyfed','Wales'), ('Pembrokeshire','Wales'), ('Co Armagh','Northern Ireland'),
    ('County Down','Northern Ireland'), ('Perthshire','Scotland'), ('Highland','Scotland'), ('Flintshire','Wales'),
    ('Redcar & Cleveland','North East'), ('Ross-shire','Scotland'), ('South Glamorgan','Wales'), ('Dunbartonshire','Scotland'),
    ('East Yorkshire','Yorkshire and The Humber'), ('County Antrim','Northern Ireland'), ('Wrexham','Wales')
)
update nr_companies c
set region = coalesce(
           (select p.region from pc_map p
             where p.area = substring(upper(trim(c.postcode)) from '^[A-Z]{1,2}')),
           (select m.region from cty_map m
             where lower(trim(m.county)) = lower(trim(c.county)))
         );


-- ── 3. Check what landed ───────────────────────────────────
with counted as (
  select coalesce(region, '*** UNRESOLVED ***') as region_out, count(*) as companies
  from nr_companies
  where hidden = false
  group by 1
)
select region_out as region, companies
from counted
order by (region_out = '*** UNRESOLVED ***'), companies desc, region_out;

-- Expect the twelve standard regions and no UNRESOLVED row.
-- Name anything that did not resolve:
--
--   select name, postcode, county from nr_companies
--   where hidden = false and region is null order by name;
--
-- A null means no postcode this mapping recognises and no county
-- in the table — fix the postcode in DataVault, refresh the
-- Supplier Database screen in scc.html, then re-run this file.


-- ── Undo ───────────────────────────────────────────────────
--   update nr_companies c set region = b.region
--   from nr_companies_region_backup b where b.id = c.id;
