/* ═══════════════════════════════════════════════════════════
   NuclearReady — shared data layer
   Supabase config, the F4N taxonomy and the row mapper, in one
   place so the five pages cannot drift apart.

   TAXONOMY, REGION_MAP, MARKET_MAP, slugify, normaliseRegion,
   normaliseMarket, esc, safeUrl and mapCompany are lifted
   VERBATIM from directory.html (the current live Explorer).
   Do not edit them here without checking that page too.

   Public anon key only — read access is governed by RLS.
   ═══════════════════════════════════════════════════════════ */

const NR = {
  SUPA_URL : 'https://qkyvmtouwrzrcyagkheo.supabase.co',
  SUPA_ANON: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFreXZtdG91d3J6cmN5YWdraGVvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzUzODQzNjMsImV4cCI6MjA5MDk2MDM2M30.gKEgkVA-VjOnS_084W79kpzOdZhFQkhFp63MAe_FTd4'
};

/* REST helper — plain fetch, no SDK needed for read-only pages. */
async function nrGet(path) {
  const r = await fetch(`${NR.SUPA_URL}/rest/v1/${path}`, {
    headers: { apikey: NR.SUPA_ANON, Authorization: `Bearer ${NR.SUPA_ANON}` }
  });
  if (!r.ok) throw new Error(`Supabase ${r.status}: ${await r.text()}`);
  return r.json();
}

/* Every visible member, mapped. Pages share one shape. */
async function nrLoadCompanies() {
  const rows = await nrGet('nr_companies?select=*&hidden=eq.false&order=name.asc');
  return rows.map(r => nrWithGeo(mapCompany(r), r));
}

/* One member by slug — C resolves ?c=<slug> through this. */
async function nrLoadCompanyBySlug(slug) {
  const all = await nrLoadCompanies();
  return all.find(c => c.slug === slug) || null;
}

/* ── Lifted verbatim from directory.html ──────────────── */

const TAXONOMY = {
  categories: ["Bearings, Seals and Drives","Castings","Civil & Construction","Coatings & Treatments (Inc Heat Treatment)","Containment & Shielding","Enclosures","Fasteners","Forgings","Heating & Ventilation","Heavy Fabrications","Instrumentation & Control Equipment","Light and Medium Fabrications","Material Supplier","Mechanical Handling & Cranes","Modular & Skid Systems","Other","Pipework Systems & Seals","Power & Data Supply","Precision Machining","Pressure Vessels Heat exchangers & Tanks","Process & Fluid Systems","Pumps & Valves","Steel Fabrications","Testing & Inspection","Welding","Workshop Equipment"],
  commodities: ["Access Ladders Stairs & Platforms","Acoustic Systems","Additive - metal","Additive - polymer","Adhesives","Air Ejectors Dryers & Receivers","Alarms & Monitoring including Condition Monitoring","Analysers","Analysis","Antivibration","Apparatus","Arrestors Exciters & Inverters","Automation","Backfill & Shoring","Batteries and Battery Chargers","Bearings & Seals","Blowers","Bus Bars","Cable Supports Conduit Fixings Trays Trunking Ducting & Splicers","Cables","Chains & Hoists including Heavy Lift","Chemical Liquid & Resin Products","Circuit Breakers","Civil Works & Civil Engineering excluding Earthworks","Cladding","Class 1E & Non Class 1E Electrical Related Systems","Coatings Paints Protection Processes & Systems","Columns","Communications Systems","Composites","Compressors","Computer monitors & panels","Concrete & Cement","Concrete Panels Pre-cast","Condensers","Condition monitoring equipment","Connectors & Contactors","Construction Building","Consumables","Containers Transportation & Storage","Containment Structure","Control Rod Drive Mechanism","Control Rods","Control Systems","Cooling & Coolers","Core Components & Assemblies","Cranes & Lifting","Cranes Polar & Fuel Handling","Cyber Security","Decontamination","Deminalisation Systems & Equipment","Desalination Equipment","Detectors Sensors Transmitters & Detection Systems","Diesel Generators & Back-up Diesel or Gas Generators","Displacement Sensors","Doors Airlocks Gates Hatches including Barriers Blast & Security","Ducting","Earthworks","Effluent Management Systems","Electrical & Electronic Components, Connectors and PCB's","Electrical Feedthroughs","Electrical Generators","Electrical Protection","Electrical Supplies","Electrical Systems","Electricity","Elevators","Emergency Planning Systems","Equipment Engineered","Equipment Qualification Analysis / Simulation","Equipment Qualification Manufacturing Facility - In-house Physical Testing","Equipment Qualification Unclassified","Equipment Qualification Test Facility - Physical Testing","Exhaust Boot","Expansion Joints","Fabrication Hi-integrity & Complex Structures including Heavy","Fabrication Med-integrity Structures","Facilities","Fan Systems & Fans","Fasteners & Fixings","Fencing","Filtration Systems","Fire Alarms","Fire Protection","Fire Rated Structures","Fire Suppression","Fire Water System","Flasks, Casks & Containers","Flow Sensors","Food Services","Form Work","Freeze Protection","Fuel Components Nuclear","Fuel Handling","Fuel Other & Fuel Systems","Fuel Pool Gates","Fuel Transfer Equipment","Fuses & Switches","Geiger-Muller Tubes","Geotechnical Quality Assurance","Glands","Gloveboxes","Gratings Sumps Covers Plates & Drains","Grounding Devices","Grout & Equipment","Heaters Pressuriser","Heaters Systems","Heat Exchangers including Main Steam Generators","Heat Recovery","Hoses Pneumatic and Hydraulics","HVAC Blowers","HVAC Chillers & Compressors","HVAC Controllers","HVAC Cooling & Coolers","HVAC Dampers & Louvers","HVAC Ducting","HVAC Fan Systems & Fans","HVAC Filtration & Filters","HVAC Heaters & Heating Units","HVAC Humidifiers & Dehumidifiers","HVAC Plenums","HVAC Systems","Hydraulics","In-core monitoring and instrumentation","Inspection & Surveillance Services","Inspection Equipments & Services including NDE & Surveillance","Instrumentation control computers detectors transmitters monitors & panels","Insulation General & Specialist Thermal","Insulators","Integrated Head Assembly","Interior Walls Buildings","Interlock Controls","Ion Exchange Systems","IT Infrastructure including IT and Cyber Security","Laboratory Equipment","Laboratory Systems Titration","Level Control","Level Sensors","Lighting","Load Sensors","Lubrication Systems Generators & Others","Lubrication Systems Main Steam Turbine","Manipulators","Marine Barges","Marine Works","Material Plate & Bar","Materials Castings","Materials Distribution","Materials Embedments & Rebar","Materials Forgings & Steels","Materials Main Stack Discharge","Materials Structural Steels Flanged Beams & Sections","Materials Supplier - all forms","Materials Testing","Materials Tubing & Pipework","Materials Wire & Wire Rope","Mechanical & Electrical Engineering & Services (M&E)","Mechanical handling equipment","Meters & Gauges","Modularised & Skid Mounted Process Systems","Neutron Absorbers & Detectors","Off-site Facility Emergency","Operational Tools","Other Supplies & Support Services including Analysis & Health","Penetrations Electrical & Mechanical Systems","Penetrations, electrical","Penetrations, mechanical","Pest & Rodent Control","Piles and Caissons","Pipework","Pipework Fittings & Spools","Pipework GRP","Pipework Snubbers","Pipework Supports","Pipework Systems including Seals","Planning Structures","Plant and Machinery","Pool Liners","Portable Equipment","Power Distribution","Power Output","Power Supply","Precision & General Machining","Pressure Sensors","Pressure Vessels Heat Exchangers & Tanks including Internals","Protective Clothing","Protective Functions Alarms","Pumps","Pumps & Valves","Pumps including Main Reactor Circulation Pumps & Motors","Racking Devices","Radiation Protection Monitoring & Radiological Controls","Radwaste Processing","Railway","Reactor Cavity Interior","Reactor Control Detectors","Reactor Pressure Vessel","Reactor Pressure Vessel Internals","Receptacles","Recombiners","Regulators","Resin Beds","Resources Labour","Road and Road Materials","Robotics, robots and robotic equipment","Robotic Manipulators Crawlers & Automated Remote Operating Tools","Rotors & Shafts","Sampling","Seals & Metal O-rings","Seals Gaskets O-Rings & Metal O-Rings","Security Facilities & Physical","Separator Reheaters","Services Agents","Services Transport","Shafts Main Turbine Bearings & Seals","Shielding","Shutdown Systems Emergency","Siding","Simulators & Training Systems","Site Gas Supplies & Systems","Site Services","Smoke Detectors","Specialist Services & Processes including Engineering Manufacturing Design & Testing","Spray Nozzles","Spray Pond","Starters","Stators & Stator Cooling","Steelwork including Mezzanine & Gantry Systems","Storage Racks & Furniture including Pond","Structural Components Building","Structural Fabrications","Structures","Stud Tensioning","Surface coatings","Switchgear","Tanks","Temperature Sensors","Terminal Blocks & Boards","Thermal Insulation","Tooling Equipment","Trace Heating","Transfer Devices","Transformers","Tunnel Boring Machinery","Turbine Generators","Turbine Generators Bypass","Turbine Gland Systems","Ultimate Heat Sink","Valves","Valves including Main Isolation SQUIB & Actuators","Vehicles & Plant","Vessels including Main Reactor Pressure Vessel & Internals","Washing & Decontamination","Waste Management","Water Supply","Water Treatment Systems","Water Wells","Welding & Welding Systems","Workshop Equipment"],
  machining: ["3 Axis Milling","4 Axis Milling","5 Axis Milling","6 Axis Milling","Deep hole Drilling","Horizontal Milling (CNC)","Horizontal Milling (Conventional)","Horizontal Mill / Turn","Horizontal Turning (CNC)","Horizontal Turning (Conventional)","Multi-spindle drilling","Robotic machining","Vertical Milling (CNC)","Vertical Milling (Conventional)","Vertical Mill / Turn","Vertical Turning (Conventional)"],
  welding: ["Bulk Additive Manufacturing","Diode Laser Cladding","Electron Beam Welding","Electroslag Strip Cladding (ESSC)","Friction Stir Welding","Gas Tungsten Arc Welding (GTAW)","K-TIG (key hole GTAW)","Laser Welding","Manual Metal Arc Welding (MMA)","Metal Active Gas Welding (MAG)","Metal Inert Gas Welding (MIG)","Narrow Gap Welding (GTAW or SAW)","Orbital & Planetary (GTAW & SAW)","Plasma Arc Welding (PAW)","Robotics","Submerged Arc Strip Cladding (SASC)","Submerged Arc Welding (SAW)","Tube Sheet Welding (Using a laser or GTAW process)"],
  testing: ["Advanced testing facilities","Chemical","Clean room facilities","CMM machines","Drop Testing","Electrical","Electro-Magnetic Compatibility & Interference","Equipment Qualification","Fire Resistant","Non destructive testing - Magnetic Particle","Non destructive testing - Radiography","Non destructive testing - Ultrasonic","Pressure / Hydro Testing","Proof Load Testing","Radiation","Temperature controlled facility for inspection"],
  design: ["CAD Design - 2D","CAD Design - 3D","CAM Design - 2D","CAM Design - 3D"],
  regions: ["East Midlands","East of England","London","North East","Northern Ireland","North West","Scotland","South East","South West","Wales","West Midlands","Yorkshire and the Humber"],
  markets: ["Aerospace - Civil and Defence","Automotive","Construction - Civils","Construction - Strategic Platforms & Vessels","Electrical components & equipment","Marine Commercial & Naval","Material Supply","Nuclear Civil","Nuclear Defence - Naval Marine","Oil & Gas including LNG","Petrochemical & Refining","Pharmaceutical & Medical","Power Generation, Distribution & Transmission","Rail & Transport","Renewables - (Wind, Tidal, Solar, Biomass etc.)","Subsea and Offshore","Utilities"],
  services: ["3D laser scanning","Bending","Civil Construction including modular construction","Design services","Exotic materials","Geotechnical Quality Assurance","Heat treatment","Installation","Law","Logistics","Material handling","Modular construction","On Site services","Pipe inspection","Port services","Project management","Radiation monitor calibration","Safety, security and risk management","Stock holders","System integration"],
  companySizes: ["1–10","11–50","51–200","201–500","500+"]
};

const REGION_MAP = {
  'Yorkshire': 'Yorkshire and the Humber',
  'Midlands': 'West Midlands',
  'East Anglia': 'East of England'
};

const MARKET_MAP = {
  'Aerospace': 'Aerospace - Civil and Defence',
  'Chemical': 'Petrochemical & Refining',
  'Defence': 'Nuclear Defence - Naval Marine',
  'Medical & Pharmaceuticals': 'Pharmaceutical & Medical',
  'Oil and Gas': 'Oil & Gas including LNG',
  'Rail': 'Rail & Transport',
  'Renewables': 'Renewables - (Wind, Tidal, Solar, Biomass etc.)',
  'Hydrogen': 'Renewables - (Wind, Tidal, Solar, Biomass etc.)',
};

function slugify(name) {
  return name.toLowerCase().replace(/[^a-z0-9]+/g,'-').replace(/^-|-$/g,'');
}

function normaliseRegion(r) { return REGION_MAP[r] || r; }

function normaliseMarket(m) { return MARKET_MAP[m] || m; }

function esc(v) {
  return String(v == null ? '' : v)
    .replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')
    .replace(/"/g,'&quot;').replace(/'/g,'&#39;');
}

function safeUrl(u) {
  u = String(u || '').trim();
  if (!u) return '';
  if (!/^https?:\/\//i.test(u)) {
    if (/^[a-z][a-z0-9+.-]*:/i.test(u)) return '';   // other schemes (javascript:, data: ...) blocked
    u = 'https://' + u;                               // bare "www.example.com"
  }
  return esc(u);
}

function mapCompany(row) {
  let caps = row.capabilities;
  if (typeof caps === 'string') { try { caps = JSON.parse(caps); } catch(e) { caps = caps ? [caps] : []; } }
  // Two shapes supported:
  //  (a) grouped object written by members.html: {categories:[],machining:[],...,services:[],markets:[]}
  //  (b) flat array written by SCC from the DataVault supplier DB: ["CNC Milling", ...]
  const capIsArray = Array.isArray(caps);
  caps = caps || {};
  const capFlat = capIsArray ? caps.filter(Boolean) : [
    ...(caps.categories  || []),
    ...(caps.commodities || []),
    ...(caps.machining   || []),
    ...(caps.welding     || []),
    ...(caps.testing     || []),
    ...(caps.design      || []),
  ];
  // markets / accreditations: prefer the flat DataVault columns when present,
  // otherwise fall back to the grouped-object keys.
  const marketsFlat = Array.isArray(row.markets) ? row.markets
    : (capIsArray ? [] : (caps.markets || []));
  const accredsFlat = Array.isArray(row.accreditations) ? row.accreditations : [];
  return {
    id:             row.id,
    name:           row.name,
    status:         row.status === 'granted' ? 'Granted' : 'On Journey',
    description:    row.description  || '',
    website:        row.website      || '',
    logo_url:       row.logo_url     || null,
    region:         normaliseRegion(row.region || ''),
    employees:      row.employees    || '',
    capabilities:   capFlat,
    services:       (capIsArray ? [] : (caps.services || [])),
    markets:        marketsFlat,
    accreditations: accredsFlat,
    year_joined:    row.created_at ? new Date(row.created_at).getFullYear() : null,
    city:           row.city || '',
    county:         row.county || '',
    postcode:       row.postcode || '',
    address:        row.address || '',
    turnover:       row.turnover || '',
    main_commodity_group: row.main_commodity_group || '',
    contact_name:   row.contact_name  || null,
    contact_phone:  row.contact_phone || null,
    contact_email:  row.contact_email || null,
    linkedin:       row.linkedin      || null,
    case_study_url: row.case_study_url || null,
    slug:           slugify(row.name),
  };
}

/* ── Added for v2 ────────────────────────────────────────── */

/* Columns added after mapCompany was written. Exposed here
   rather than editing the lifted function, so it stays a
   faithful copy of the live Explorer's.

   lat/lng       — nr_companies_geo.sql
   full_description — the long "about us" the company page shows
                   under its capabilities. nr_companies only has
                   `description`, which members.html collects as
                   "a clear, public-facing summary", so this is a
                   second field. Until the column exists this is
                   always empty and the page simply omits the box:
                     alter table nr_companies
                       add column if not exists full_description text; */
function nrWithGeo(c, row) {
  c.lat = row.lat != null && row.lat !== '' ? parseFloat(row.lat) : null;
  c.lng = row.lng != null && row.lng !== '' ? parseFloat(row.lng) : null;
  c.full_description = row.full_description || '';
  /* Commodity tags from the SharePoint Company_Commodities list, synced by
     scc.html. Distinct from the "commodities" group inside a member's own
     capabilities object, which is part of the members.html vocabulary.
     Empty until nr_companies_commodities.sql has run and scc has refreshed. */
  let coms = row.commodities;
  if (typeof coms === 'string') { try { coms = JSON.parse(coms); } catch (e) { coms = coms ? [coms] : []; } }
  c.commodities = Array.isArray(coms) ? coms.filter(Boolean) : [];
  return c;
}

/* How many members sit in each product category, counted live
   rather than hardcoded. Returns [{name, count}] sorted desc. */
function nrCategoryCounts(companies) {
  /* Use the same matcher the directory's category filter uses. This counted
     by exact string equality while the filter matched on substrings, so the
     landing page reported nothing tagged while the directory, on identical
     data, found plenty -- and a tile's count would not have survived being
     clicked through. */
  const cfg = GROUP_CONFIG.category;
  return TAXONOMY.categories
    .map(name => ({
      name,
      count: companies.filter(c => nrFieldMatches(cfg, c[cfg.field] || [], name)).length
    }))
    .sort((a, b) => b.count - a.count || a.name.localeCompare(b.name));
}

/* Filter group -> TAXONOMY key + company field. Lifted verbatim from
   directory.html; A and E both filter through this. */
/* Capability -> product category.
 *
 * Staff tag companies against the SharePoint Capabilities list; these pages
 * group members under product categories. Nothing in SharePoint connects the
 * two - there is no grouping column - so this is the connection, by hand.
 *
 * Previously the category filter matched the two vocabularies by substring,
 * which worked for "Pumps" -> "Pumps & Valves" and silently missed the rest:
 * "Precision Machining" is not a substring of "Precision & General Machining".
 * 14 of 21 categories came up empty as a result.
 *
 * Covers all 101 capability tags in use across the published members.
 * A capability missing from here lands in no category and will not appear in
 * the tiles or the category filter. Nothing breaks, but the counts quietly
 * understate, so re-check when new capability tags come into use.
 *
 * Decisions taken on review are recorded inline as DECIDED, with reasoning.
 * Entries marked REVIEW are still open engineering calls.
 */
const CAPABILITY_CATEGORY = {

  /* Bearings, Seals and Drives - 3 member-tags across 2 capabilities */
  'Bearings & Seals': 'Bearings, Seals and Drives',                       //  2
  'Seals & Metal O-rings': 'Bearings, Seals and Drives',                  //  1

  /* Castings - 2 member-tags across 1 capability */
  'Materials Castings': 'Castings',                                       //  2

  /* Coatings & Treatments (Inc Heat Treatment) - 12 member-tags across 3 capabilities */
  'Coatings Paints Protection Processes & Systems': 'Coatings & Treatments (Inc Heat Treatment)', //  7
  'Surface coatings': 'Coatings & Treatments (Inc Heat Treatment)',       //  3
  'cladding': 'Coatings & Treatments (Inc Heat Treatment)',               //  2

  /* Enclosures - 3 member-tags across 2 capabilities */
  'Doors Airlocks Gates Hatches including Barriers Blast & Security': 'Enclosures', //  2
  'Interior Walls Buildings': 'Enclosures',                               //  1

  /* Fasteners - 8 member-tags across 1 capability */
  'Fasteners & Fixings': 'Fasteners',                                     //  8

  /* Forgings - 2 member-tags across 1 capability */
  'Materials Forgings & Steels': 'Forgings',                              //  2

  /* Heating & Ventilation - 15 member-tags across 10 capabilities */
  'Heaters Systems': 'Heating & Ventilation',                             //  3
  'Ducting': 'Heating & Ventilation',                                     //  2
  'HVAC Dampers & Louvers': 'Heating & Ventilation',                      //  2
  'HVAC Systems': 'Heating & Ventilation',                                //  2
  'Cooling & Coolers': 'Heating & Ventilation',                           //  1
  'Fan Systems & Fans': 'Heating & Ventilation',                          //  1
  'HVAC Ducting': 'Heating & Ventilation',                                //  1
  'HVAC Fan Systems & Fans': 'Heating & Ventilation',                     //  1
  'HVAC Filtration & Filters': 'Heating & Ventilation',                   //  1
  'Trace Heating': 'Heating & Ventilation',                               //  1

  /* Heavy Fabrications - 15 member-tags across 1 capability */
  'Fabrication Hi-integrity & Complex Structures including Heavy': 'Heavy Fabrications', // 15

  /* Instrumentation & Control Equipment - 8 member-tags across 6 capabilities */
  'Condition monitoring equipment': 'Instrumentation & Control Equipment', //  2
  'Detectors Sensors Transmitters & Detection Systems': 'Instrumentation & Control Equipment', //  2
  'Displacement Sensors': 'Instrumentation & Control Equipment',          //  1
  'Flow Sensors': 'Instrumentation & Control Equipment',                  //  1
  'Level Sensors': 'Instrumentation & Control Equipment',                 //  1
  'Radiation Protection Monitoring & Radiological Controls': 'Instrumentation & Control Equipment', //  1

  /* Light and Medium Fabrications - 21 member-tags across 1 capability */
  'Fabrication Med-integrity Structures': 'Light and Medium Fabrications', // 21

  /* Material Supplier - 10 member-tags across 4 capabilities */
  'Material Plate & Bar': 'Material Supplier',                            //  3
  'Materials Structural Steels Flanged Beams & Sections': 'Material Supplier', //  3
  'Materials Supplier - all forms': 'Material Supplier',                  //  3
  'Consumables': 'Material Supplier',                                     //  1

  /* Mechanical Handling & Cranes - 9 member-tags across 5 capabilities */
  'Fuel Handling': 'Mechanical Handling & Cranes',                        //  3  REVIEW: grouped with handling equipment; may deserve its own category
  'Mechanical handling equipment': 'Mechanical Handling & Cranes',        //  3
  'Fuel Transfer Equipment': 'Mechanical Handling & Cranes',              //  1  REVIEW: same question as Fuel Handling
  'Robotic Manipulators Crawlers & Automated Remote Operating Tools': 'Mechanical Handling & Cranes', //  1
  'Robotics, robots and robotic equipment': 'Mechanical Handling & Cranes', //  1

  /* Pipework Systems & Seals - 28 member-tags across 8 capabilities */
  'Pipework': 'Pipework Systems & Seals',                                 // 11
  'Pipework Fittings & Spools': 'Pipework Systems & Seals',               //  6
  'Materials Tubing & Pipework': 'Pipework Systems & Seals',              //  4  DECIDED: Roy, 16 Oct: Material Supplier is too broad - a buyer searching pipework should find these
  'Pipework Systems including Seals': 'Pipework Systems & Seals',         //  3
  'Expansion Joints': 'Pipework Systems & Seals',                         //  1
  'Glands': 'Pipework Systems & Seals',                                   //  1
  'Pipework GRP': 'Pipework Systems & Seals',                             //  1
  'Pipework Supports': 'Pipework Systems & Seals',                        //  1

  /* Power & Data Supply - 9 member-tags across 8 capabilities */
  'Batteries and Battery Chargers': 'Power & Data Supply',                //  2
  'Bus Bars': 'Power & Data Supply',                                      //  1
  'Cable Supports Conduit Fixings Trays Trunking Ducting & Splicers': 'Power & Data Supply', //  1
  'Cables': 'Power & Data Supply',                                        //  1
  "Electrical & Electronic Components, Connectors and PCB's": 'Power & Data Supply', //  1
  'Electrical Feedthroughs': 'Power & Data Supply',                       //  1
  'Electrical Generators': 'Power & Data Supply',                         //  1
  'Electrical Protection': 'Power & Data Supply',                         //  1

  /* Precision Machining - 12 member-tags across 1 capability */
  'Precision & General Machining': 'Precision Machining',                 // 12

  /* Pressure Vessels Heat exchangers & Tanks - 20 member-tags across 7 capabilities */
  'Pressure Vessels Heat Exchangers & Tanks including Internals': 'Pressure Vessels Heat exchangers & Tanks', //  6
  'Tanks': 'Pressure Vessels Heat exchangers & Tanks',                    //  4
  'Heat Exchangers including Main Steam Generators': 'Pressure Vessels Heat exchangers & Tanks', //  3
  'Vessels including Main Reactor Pressure Vessel & Internals': 'Pressure Vessels Heat exchangers & Tanks', //  3
  'Condensers': 'Pressure Vessels Heat exchangers & Tanks',               //  2
  'Air Ejectors Dryers & Receivers': 'Pressure Vessels Heat exchangers & Tanks', //  1
  'Reactor Pressure Vessel': 'Pressure Vessels Heat exchangers & Tanks',  //  1

  /* Pumps & Valves - 13 member-tags across 5 capabilities */
  'Valves': 'Pumps & Valves',                                             //  5
  'Pumps': 'Pumps & Valves',                                              //  3
  'Pumps including Main Reactor Circulation Pumps & Motors': 'Pumps & Valves', //  2
  'Valves including Main Isolation SQUIB & Actuators': 'Pumps & Valves',  //  2
  'Hydraulics': 'Pumps & Valves',                                         //  1  REVIEW: placed with Pumps & Valves; arguable

  /* Steel Fabrications - 24 member-tags across 6 capabilities */
  'Structural Fabrications': 'Steel Fabrications',                        // 12
  'Structural Components Building': 'Steel Fabrications',                 //  4
  'Access Ladders Stairs & Platforms': 'Steel Fabrications',              //  3
  'Steelwork including Mezzanine & Gantry Systems': 'Steel Fabrications', //  2
  'Structures': 'Steel Fabrications',                                     //  2
  'Gratings Sumps Covers Plates & Drains': 'Steel Fabrications',          //  1

  /* Testing & Inspection - 17 member-tags across 6 capabilities */
  'Equipment Qualification Analysis / Simulation': 'Testing & Inspection', //  7
  'Equipment Qualification Manufacturing Facility - In-house Physic': 'Testing & Inspection', //  5
  'Inspection & Surveilance Services': 'Testing & Inspection',            //  2
  'Equipment Qualification Unclassified': 'Testing & Inspection',         //  1
  'Equipment Qualifification Test Facility - Physical Testing': 'Testing & Inspection', //  1
  'Inspection Equipments & Services including NDE & Surveillance': 'Testing & Inspection', //  1

  /* Workshop Equipment - 2 member-tags across 1 capability */
  'Tooling Equipment': 'Workshop Equipment',                              //  2

  /* Other - 7 member-tags across 6 capabilities */
  'Equipment Engineered': 'Other',                                        //  2  REVIEW: too vague to place - left in Other
  'Acoustic Systems': 'Other',                                            //  1
  'Fuel Other & Fuel Systems': 'Other',                                   //  1
  'Resources Labour': 'Other',                                            //  1  REVIEW: not a product capability at all - left in Other
  'Waste Management': 'Other',                                            //  1
  'fire suppression': 'Other',                                            //  1

  /* Welding (PROPOSED NEW CATEGORY) - 8 member-tags across 1 capability */
  'Welding & Welding Systems': 'Welding',                                 //  8

  /* Civil & Construction (PROPOSED NEW CATEGORY) - 14 member-tags across 4 capabilities */
  'Form Work': 'Civil & Construction',                                    //  6  REVIEW: concrete shuttering, so Civil rather than Steel Fabrications
  'Civil Works & Civil Engineering excluding Earthworks': 'Civil & Construction', //  5
  'Construction Building': 'Civil & Construction',                        //  2
  'Marine Works': 'Civil & Construction',                                 //  1

  /* Process & Fluid Systems (PROPOSED NEW CATEGORY) - 10 member-tags across 6 capabilities */
  'Filtration Systems': 'Process & Fluid Systems',                        //  5
  'Decontamination': 'Process & Fluid Systems',                           //  1
  'Desalination Equipment': 'Process & Fluid Systems',                    //  1
  'Effluent Management Systems': 'Process & Fluid Systems',               //  1
  'Washing & Decontamination': 'Process & Fluid Systems',                 //  1
  'Water Treatment Systems': 'Process & Fluid Systems',                   //  1

  /* Modular & Skid Systems (PROPOSED NEW CATEGORY) - 4 member-tags across 1 capability */
  'Modularised & Skid Mounted Process Systems': 'Modular & Skid Systems', //  4

  /* Containment & Shielding (PROPOSED NEW CATEGORY) - 6 member-tags across 4 capabilities */
  'Flasks, Casks & Containers': 'Containment & Shielding',                //  3  DECIDED: Roy, 16 Oct: nobody would search Enclosures for a cask. 3 of these 6 members are not reachable via Heavy Fab or Pressure Vessels, so the tag is their only route
  'Containers Transportation & Storage': 'Containment & Shielding',       //  1  DECIDED: with flasks and casks
  'Gloveboxes': 'Containment & Shielding',                                //  1  DECIDED: not a pressure vessel; Extract Technology has 3 tags total and this is one
  'Shielding': 'Containment & Shielding',                                 //  1  DECIDED: with the containment group
};

const GROUP_CONFIG = {
  /* category matches through the map above, not by substring */
  category:  { taxKey: 'categories',  field: 'capabilities', map: CAPABILITY_CATEGORY },
  commodity: { taxKey: 'commodities', field: 'capabilities', fuzzy: false },
  machining: { taxKey: 'machining',   field: 'capabilities', fuzzy: false },
  welding:   { taxKey: 'welding',     field: 'capabilities', fuzzy: false },
  testing:   { taxKey: 'testing',     field: 'capabilities', fuzzy: false },
  design:    { taxKey: 'design',      field: 'capabilities', fuzzy: false },
  services:  { taxKey: 'services',    field: 'services',     fuzzy: false },
  markets:   { taxKey: 'markets',     field: 'markets',      fuzzy: false }
};

const GROUP_LABELS = {
  category:  'Product category',
  commodity: 'Commodity',
  machining: 'Machining capability',
  welding:   'Welding & fabrication',
  testing:   'Testing capability',
  design:    'Design capability',
  services:  'Other capability',
  markets:   'Markets served'
};

/* Shared matcher — same comparison rules as the live Explorer. */
function nrFieldMatches(cfg, field, v) {
  /* A group with a map is matched exactly through it. Used by the category
     group, where the tag vocabulary and the category vocabulary are different
     lists and substring matching gave the wrong answer in both directions. */
  if (cfg.map) return field.some(f => cfg.map[f] === v);
  v = v.toLowerCase();
  if (cfg.fuzzy) {
    return field.some(f => f.toLowerCase().includes(v) || v.includes(f.toLowerCase().slice(0, 24)));
  }
  return field.some(f => f.toLowerCase() === v || f.toLowerCase().includes(v));
}
