-- NuclearReady site analytics (v1, 2026-10-30). Run the whole file in one go.
--
-- Anonymous, cookieless event log written by the five public pages through
-- nrTrack() in nr-data.js, and read by Frankie's "NuclearReady Analytics"
-- panel in scc.html.
--
-- Companion to public_events (the Manufacturing UK pages) and member_events
-- (members.html). Deliberately a SEPARATE table rather than reusing
-- public_events: that panel's muRender() counts views and visits across every
-- row it reads, so mixing sites in one table silently inflates its figures.
--
-- No IP addresses and no personal data are stored. visit_id is a random id
-- held in sessionStorage for the tab's lifetime, so it groups one visit's
-- events together and is gone when the tab closes. It is not a cookie and
-- cannot follow anyone between visits.

create table if not exists nr_events (
  id            bigint generated always as identity primary key,
  visit_id      text        not null,
  page          text        not null,   -- home | directory | company | compare | map
  event_type    text        not null,   -- view | company_view | search | filter | outbound
  detail        text,                   -- company slug, search term, filter value, link host
  referrer      text,                   -- document.referrer host, where the browser sent one
  utm_source    text,
  utm_medium    text,
  utm_campaign  text,
  created_at    timestamptz not null default now()
);

create index if not exists nr_events_created_at_idx on nr_events (created_at desc);
create index if not exists nr_events_type_time_idx   on nr_events (event_type, created_at desc);
create index if not exists nr_events_visit_idx       on nr_events (visit_id);

alter table nr_events enable row level security;

-- Visitors may only append. They cannot read, amend or delete anything, and
-- the length checks cap what a scripted client can push through the anon key,
-- which is public by design in the page source.
drop policy if exists "Anyone can log an event" on nr_events;
create policy "Anyone can log an event" on nr_events for insert to anon, authenticated
  with check (
        length(visit_id)                  between 8 and 64
    and length(page)                      <= 32
    and length(event_type)                <= 32
    and length(coalesce(detail, ''))      <= 200
    and length(coalesce(referrer, ''))    <= 300
    and length(coalesce(utm_source, ''))  <= 100
    and length(coalesce(utm_medium, ''))  <= 100
    and length(coalesce(utm_campaign,'')) <= 100
  );

-- Staff read it through Frankie.
drop policy if exists "Staff can read events" on nr_events;
create policy "Staff can read events" on nr_events for select to authenticated using (true);

grant insert on nr_events to anon;
grant select on nr_events to authenticated;

notify pgrst, 'reload schema';
