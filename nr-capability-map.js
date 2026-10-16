/* nr-capability-map.js
 *
 * Maps each SharePoint capability tag onto one of the NuclearReady product
 * categories. NOT YET WIRED IN - review it first, then see the note at the
 * bottom for how to switch it on.
 *
 * Why this exists: staff tag companies against the SharePoint Capabilities
 * list (262 entries, 101 of them currently in use). The public pages group
 * members under 21 product categories, which come from the members.html
 * vocabulary. Nothing in SharePoint says which capability belongs to which
 * category - there is no grouping column - so the directory was matching the
 * two by substring, which worked for a handful and silently missed the rest.
 * 'Precision Machining' is not a substring of 'Precision & General Machining'.
 *
 * Derived 2026-10-16 from the capability tags actually in use across the
 * 52 published members. Counts below are members holding that tag.
 *
 * MAINTENANCE: a capability missing from here falls into no category and
 * simply will not appear in the category tiles or the category filter. It is
 * not an error and nothing breaks - but the tile counts quietly understate.
 * Re-run the audit when new capability tags come into use.
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

  /* Enclosures - 9 member-tags across 6 capabilities */
  'Flasks, Casks & Containers': 'Enclosures',                             //  3  REVIEW: could equally be Pressure Vessels Heat exchangers & Tanks
  'Doors Airlocks Gates Hatches including Barriers Blast & Security': 'Enclosures', //  2
  'Containers Transportation & Storage': 'Enclosures',                    //  1
  'Gloveboxes': 'Enclosures',                                             //  1
  'Interior Walls Buildings': 'Enclosures',                               //  1
  'Shielding': 'Enclosures',                                              //  1

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
};

/* ---------------------------------------------------------------------
   101 capabilities mapped, 282 member-tags, every one placed.

   DECIDED on review:
     Materials Tubing & Pipework -> Pipework Systems & Seals
       Roy, 16 Oct: Material Supplier is too broad - a buyer searching pipework should find these

   STILL TO REVIEW - engineering calls, not coding ones:
     Flasks, Casks & Containers
       -> Enclosures: could equally be Pressure Vessels Heat exchangers & Tanks
     Fuel Handling
       -> Mechanical Handling & Cranes: grouped with handling equipment; may deserve its own category
     Fuel Transfer Equipment
       -> Mechanical Handling & Cranes: same question as Fuel Handling
     Form Work
       -> Civil & Construction: concrete shuttering, so Civil rather than Steel Fabrications
     Hydraulics
       -> Pumps & Valves: placed with Pumps & Valves; arguable
     Equipment Engineered
       -> Other: too vague to place - left in Other
     Resources Labour
       -> Other: not a product capability at all - left in Other

   TO SWITCH ON:
     1. Add the four proposed categories to TAXONOMY.categories in
        nr-data.js AND to NR_TAXONOMY.categories in members.html. The two
        lists are duplicated and must stay in step.
     2. In nr-data.js, have nrFieldMatches use this map for the category
        group instead of substring matching.
   Without step 1 the four new categories simply never render; the twenty
   existing ones work either way.
   --------------------------------------------------------------------- */
