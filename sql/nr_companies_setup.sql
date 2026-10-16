-- ═══════════════════════════════════════════════════════════
-- NuclearReady: nr_companies table + seed data
-- Run this in Supabase SQL Editor
-- ═══════════════════════════════════════════════════════════

-- 1. Create nr_companies table
CREATE TABLE IF NOT EXISTS nr_companies (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name             text NOT NULL,
  status           text NOT NULL CHECK (status IN ('granted', 'in_progress')),
  description      text,
  website          text,
  logo_url         text,
  region           text,
  employees        text,
  capabilities     jsonb,
  contact_name     text,
  contact_email    text,
  linkedin         text,
  created_at       timestamptz DEFAULT now(),
  updated_at       timestamptz DEFAULT now()
);

-- 2. Seed companies (F4N Granted)
INSERT INTO nr_companies (name, status, description, website) VALUES
  ('Amazon Filters',                    'granted',     'A leading European supplier of high-quality filters and vessels, with expertise in bespoke filtration solutions.',                                                                                                                                                                    'https://www.amazonfilters.com'),
  ('BEP Surface Technologies',          'granted',     'Advanced chrome, nickel, and copper plating, precision grinding, and electroforming for energy, nuclear, and industrial sectors.',                                                                                                                                                   'https://bep-st.com'),
  ('Ellis Patents',                     'granted',     'Designs and manufactures high-performance cable cleats, protecting critical electrical systems across nuclear, transport, and renewable energy.',                                                                                                                                     'https://www.ellispatents.co.uk'),
  ('Caunton Engineering',               'granted',     'High-quality structural steel solutions combining 50+ years of experience with agility, innovation, and sustainable construction practices.',                                                                                                                                         'https://www.caunton.co.uk'),
  ('Fort Vale Nuclear Ltd',             'granted',     'World leader in precision manufacture of valves and fittings for the transportation of bulk liquids in tank container, road tanker, and rail industries.',                                                                                                                           'https://www.fortvale.com'),
  ('Graham Hart (Process Technology) Ltd', 'granted',  'Designs and manufactures high-integrity heat transfer and pressure equipment, including heat exchangers and reactor vessels.',                                                                                                                                                       'https://www.graham-hart.com'),
  ('Extract Technology',                'granted',     'Supplies containment and aseptic systems globally, serving pharmaceutical, healthcare, biotech, chemical, and nuclear markets.',                                                                                                                                                     'https://extract-technology.com'),
  ('Exalto Bearings UK',               'granted',     'Manufactures high-quality rubber-lined and composite cutlass bearings for pump and marine industries, in bespoke and standard sizes.',                                                                                                                                               'https://exalto.co.uk/en'),
  ('Oldham Engineering',                'granted',     'Long-established company providing in-house fabrication and machining for complex projects in the nuclear and defence sectors.',                                                                                                                                                     'https://www.oldham-eng.com'),
  ('RTR GmbH & Co. KG',                'granted',     'Delivers end-to-end steel solutions, from inventory and mill production to bespoke fabrication, with a global supply chain.',                                                                                                                                                       'https://www.rtr-group.com'),
  ('Score Europe',                      'granted',     'Specialises in valves, fuel systems, and components, delivering complex engineering solutions across energy, aerospace, defence, and nuclear.',                                                                                                                                       'https://score-group.com'),
  ('Landguard Engineering',             'granted',     'Delivers high-quality steel fabrication and installation, specialising in acoustic control, structural steel, and offshore projects.',                                                                                                                                               'https://www.landguardengineering.co.uk'),
  ('SYSPAL Ltd',                        'granted',     'Bespoke and standard stainless steel and aluminium equipment, supported by in-house design and over four decades of manufacturing experience.',                                                                                                                                     'https://www.syspal.com'),
  ('Rivencore Global Solutions',        'granted',     'Designs and manufactures advanced protection systems, precision sensors, enclosures, and naval lighting and navigation solutions for defence and civil customers worldwide, drawing on over 135 years of British engineering heritage.',                                              'https://www.rivencoreglobal.com'),
  ('XL Engineering',                   'granted',     'Provides complex and rapid short batch small to medium sheet metal fabrications from a purpose-built facility in Sandbach, Cheshire.',                                                                                                                                               'https://www.xl-eng.co.uk'),
  ('Trillium Flow Technologies',        'granted',     'Global designer, manufacturer, and aftermarket service provider of engineered valves and pumps for critical infrastructure and industrial applications.',                                                                                                                            'https://www.trilliumflow.com'),
  ('Hydrobolt',                         'granted',     'UK market leader specialising in manufacturing high integrity fasteners for the energy industries.',                                                                                                                                                                                'https://hydroboltgroup.com'),
  ('BHC',                               'granted',     'One of the UK''s leading structural steel fabrication and construction companies, supplying and erecting fabricated steel across the UK and Ireland.',                                                                                                                               'https://bhc.ltd.uk'),
  ('Rhyal Engineering',                 'granted',     'UK market-leading specialist in the design, construction, and refurbishment of large diameter site-built storage tanks and vessels, serving oil & gas, nuclear, and renewables sectors across the UK, Ireland, and overseas.',                                                       'https://www.rhyalengineering.com'),
  ('Eurofabs (UK) Ltd',                 'granted',     'Leading high-end fabrication company specialising in the design and manufacture of specialist stainless steel and precision-engineered solutions.',                                                                                                                                  'https://eurofabs.co.uk'),
  ('Koso Kent',                         'granted',     'Delivers globally trusted valves, combining quality engineering, customer focus, and rapid technical response for critical applications.',                                                                                                                                            'https://kentintrol.com'),
  ('Ace Polishing Services Ltd',        'granted',     'Over 30 years of metal polishing and beadblasting expertise across Nuclear, Pharmaceutical, Architectural, Aerospace, and Oil & Gas sectors.',                                                                                                                                     'https://acepolishingservices.co.uk'),
  ('MCE Group',                         'granted',     'Improving UK plant reliability since 1990. Provides 24/7 emergency services, diagnostic services, and comprehensive valve management solutions.',                                                                                                                                    'https://mce-group.com'),
  ('Vecom UK',                          'granted',     'Based in Bury, a leading specialist in metal surface treatments including pickling, passivation, and mechanical polishing.',                                                                                                                                                         'https://www.vecom-group.com/en-uk'),
  ('ASD Limited',                       'granted',     'One of the UK''s leading metal stockholders and processing suppliers and a proud member of the Hierros Añón Group.',                                                                                                                                                                'https://asd.ltd'),
  ('Dynamic Aerospace Fabrications',    'granted',     'Supplies complex, high-precision fabricated and machined metal parts and assemblies to market-leading aerospace companies.',                                                                                                                                                        'https://dynamicaerofabs.com'),
  ('Backer Heatrod',                    'granted',     'Greater Manchester based UK leader in manufacturing heating elements and associated process heating equipment for industrial applications.',                                                                                                                                         'https://shop.heatrod.com'),
  ('Agemaspark',                        'granted',     'Delivers bespoke manufacturing services, from single components to full assemblies, supported by extensive industry experience and supplier networks.',                                                                                                                               'https://agemaspark.com'),
  ('C2 Construction & Fabrication',     'granted',     'Specialises in complex construction projects, offering turnkey solutions, bespoke steel fabrication, and full principal contractor services.',                                                                                                                                       'https://www.c2-construction.co.uk'),
  ('Exentec',                           'granted',     'Part of the Exyte Group, providing tailored, mission-critical solutions for high-tech industries, combining reliability, innovation, and energy-efficient design.',                                                                                                                  'https://www.exentec.net'),
  ('BFS Enterprise (Fabrications) Ltd', 'granted',     'Specialises in bespoke structural steel fabrications and precision machining for the energy, oil & gas, and renewables sectors.',                                                                                                                                                   'https://bfs-fabs.com'),
  ('P.A.R.C. Ltd',                      'granted',     'One of the UK''s leading UKAS accredited test laboratories, offering a wide range of environmental tests using modern equipment and experienced engineers.',                                                                                                                         'https://www.parctest.co.uk'),
  ('Amarinth',                          'granted',     'Designs and manufactures bespoke centrifugal process pumps and engineered packages for the oil & gas, petrochemical, chemical, power, and marine sectors, with a global supply base.',                                                                                               'https://www.amarinth.com'),
  ('DPV',                               'granted',     'Manufactures and stocks cast and forged valves in carbon, stainless, and alloy materials, with over 40 years of experience serving the oil, gas, chemical, power, and utilities industries.',                                                                                       'https://dpv-uk.com'),
  ('Hawke International (Hubbell Group)','granted',    'Market-leading manufacturer of Ex-rated cable glands, enclosures, connectors, and control solutions, with over 70 years of experience serving hazardous and industrial locations across oil & gas, power, marine, and nuclear sectors.',                                            'https://www.hubbell.com/hawke/en'),
  ('Teledyne Valeport',                 'granted',     'Designs and manufactures precision oceanographic, hydrographic, and hydrometric instruments, with over 50 years of experience serving environmental monitoring, water survey, energy, and scientific research customers worldwide.',                                                  'https://www.valeport.co.uk'),

-- F4N In Progress
  ('Mayflower Engineering',             'in_progress', 'Delivers high-quality engineered solutions across offshore, nuclear, renewable, rail, and military sectors, backed by 50 years of expertise.',                                                                                                                                      'https://www.mayflower-engineering.co.uk'),
  ('MSCM Limited',                      'in_progress', 'Designs and manufactures hydraulic distribution products and systems for subsea production, delivering fully in-house solutions with unmatched flexibility.',                                                                                                                       'https://www.mscmltd.co.uk'),
  ('Ovivo',                             'in_progress', 'Global leader in water treatment, delivering advanced equipment, technologies, and systems for purification and wastewater management.',                                                                                                                                            'https://www.ovivowater.com/en'),
  ('Preformed Windings',                'in_progress', 'Leading UK manufacturer of high-voltage coils, delivering customised, award-winning solutions with a 10-year performance guarantee.',                                                                                                                                               'https://www.preformedwindings.com'),
  ('Prism Power Group',                 'in_progress', 'Designs, manufactures, and maintains electrical switchgear, critical power systems, and monitoring solutions across diverse industries.',                                                                                                                                            'https://www.prismpower.co.uk'),
  ('Robert Stuart',                     'in_progress', 'Applies decades of aerospace expertise to provide integrated treatments and process evaluation for precision engineering across multiple industries.',                                                                                                                               'https://www.robert-stuart.co.uk'),
  ('Special Piping Materials',          'in_progress', 'Global leader in high-quality and exotic piping products, supplying pipes, fittings, flanges, and bar from trusted mills worldwide.',                                                                                                                                               'https://specialpipingmaterials.com/en'),
  ('Wright Engineering',                'in_progress', 'Provides global engineering solutions from bulk materials processing to mechanical services, backed by decades of industry leadership.',                                                                                                                                            'https://www.wrighteng.co.uk'),
  ('Orbital Fabrications',              'in_progress', 'Designs, manufactures, and installs high- and ultra-high-purity gas and liquid delivery systems using orbital TIG welding, serving the semiconductor, pharmaceutical, clean energy, and research sectors since 1988.',                                                              'https://orbitalfl.com')
ON CONFLICT DO NOTHING;

-- 3. Add company_id FK to nr_profile_updates
ALTER TABLE nr_profile_updates
  ADD COLUMN IF NOT EXISTS company_id uuid REFERENCES nr_companies(id);

-- 4. Add nr_company_id to profiles (links a member account to their company)
ALTER TABLE profiles
  ADD COLUMN IF NOT EXISTS nr_company_id uuid REFERENCES nr_companies(id);

-- 5. RLS on nr_companies (public read, staff write)
ALTER TABLE nr_companies ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public can read companies" ON nr_companies;
CREATE POLICY "Public can read companies"
  ON nr_companies FOR SELECT
  USING (true);

DROP POLICY IF EXISTS "Staff can update companies" ON nr_companies;
CREATE POLICY "Staff can update companies"
  ON nr_companies FOR UPDATE
  TO authenticated
  USING (true);

-- 6. Auto-update updated_at on change
CREATE OR REPLACE FUNCTION update_nr_companies_updated_at()
RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = now(); RETURN NEW; END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS nr_companies_updated_at ON nr_companies;
CREATE TRIGGER nr_companies_updated_at
  BEFORE UPDATE ON nr_companies
  FOR EACH ROW EXECUTE FUNCTION update_nr_companies_updated_at();


-- ═══════════════════════════════════════════════════════════
-- Run this AFTER nr_companies_setup.sql
-- Adds hidden flag and delete policy for staff
-- ═══════════════════════════════════════════════════════════
ALTER TABLE nr_companies ADD COLUMN IF NOT EXISTS hidden boolean DEFAULT false;

DROP POLICY IF EXISTS "Staff can delete companies" ON nr_companies;
CREATE POLICY "Staff can delete companies"
  ON nr_companies FOR DELETE
  TO authenticated
  USING (true);

DROP POLICY IF EXISTS "Staff can insert companies" ON nr_companies;
CREATE POLICY "Staff can insert companies"
  ON nr_companies FOR INSERT
  TO authenticated
  WITH CHECK (true);
