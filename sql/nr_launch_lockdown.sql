-- ═══════════════════════════════════════════════════════════════════════
-- NuclearReady pre-launch lock-down  (2026-09-24, v2 — based on your Step 0 output)
-- Supabase → SQL Editor. Run PART 1, check the result, then run PART 2.
-- Problem being fixed: "authenticated" = ANY logged-in member, so these rules
-- currently let members edit companies, approve updates, edit the tracker etc.
-- ═══════════════════════════════════════════════════════════════════════

-- ─────────────────────────── PART 1 — staff list ───────────────────────────
alter table nr_companies add column if not exists contact_phone text;

create table if not exists staff_users (
  user_id uuid primary key references auth.users on delete cascade,
  email   text
);
alter table staff_users enable row level security;   -- no policies = not readable via the API

-- Everyone with a @nuccol.co.uk login becomes staff. Add associates by email below.
insert into staff_users (user_id, email)
select id, email from auth.users
where email ilike '%@nuccol.co.uk'
   -- or lower(email) in ('associate@example.com')
on conflict (user_id) do nothing;

create or replace function is_staff()
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from staff_users where user_id = auth.uid());
$$;

select * from staff_users;   -- ← CHECK: everyone who uses SCC is here, and no members are.

-- ─────────────────────────── PART 2 — rules (all-or-nothing) ───────────────
begin;

-- nr_companies: public read stays; only staff write
drop policy if exists "Staff can update companies" on nr_companies;
drop policy if exists "Staff can insert companies" on nr_companies;
drop policy if exists "Staff can delete companies" on nr_companies;
create policy "Staff can update companies" on nr_companies for update to authenticated using (is_staff()) with check (is_staff());
create policy "Staff can insert companies" on nr_companies for insert to authenticated with check (is_staff());
create policy "Staff can delete companies" on nr_companies for delete to authenticated using (is_staff());

-- nr_profile_updates: members keep insert/view-own; review is staff only
drop policy if exists "Staff can read all profile updates" on nr_profile_updates;
drop policy if exists "Staff can update profile updates"   on nr_profile_updates;
create policy "Staff can read all profile updates" on nr_profile_updates for select to authenticated using (is_staff());
create policy "Staff can update profile updates"   on nr_profile_updates for update to authenticated using (is_staff()) with check (is_staff());

-- nr_news_submissions: same pattern
drop policy if exists "Staff can read all news submissions" on nr_news_submissions;
drop policy if exists "Staff can update news submissions"   on nr_news_submissions;
create policy "Staff can read all news submissions" on nr_news_submissions for select to authenticated using (is_staff());
create policy "Staff can update news submissions"   on nr_news_submissions for update to authenticated using (is_staff()) with check (is_staff());

-- f4n_journey_submissions: staff review (members keep insert/view-own)
drop policy if exists "Staff can update journey submissions" on f4n_journey_submissions;
drop policy if exists "Staff can read journey submissions"   on f4n_journey_submissions;
create policy "Staff can update journey submissions" on f4n_journey_submissions for update to authenticated using (is_staff()) with check (is_staff());
create policy "Staff can read journey submissions"   on f4n_journey_submissions for select to authenticated using (is_staff());

-- Internal SCC tables: staff only
drop policy if exists "staff full access" on nr_actions;
create policy "staff full access" on nr_actions for all to authenticated using (is_staff()) with check (is_staff());
drop policy if exists "staff full access" on nr_f4n_tracker;
create policy "staff full access" on nr_f4n_tracker for all to authenticated using (is_staff()) with check (is_staff());
drop policy if exists "company_members_write" on company_members;
create policy "company_members_write" on company_members for all to authenticated using (is_staff()) with check (is_staff());

-- nr_site_settings: members.html reads it, so read stays; only staff write
drop policy if exists "authenticated write access" on nr_site_settings;
create policy "authenticated write access" on nr_site_settings for all to authenticated using (is_staff()) with check (is_staff());

-- member_events: members log their own; only staff read the whole log
drop policy if exists "Authenticated users can view all events" on member_events;
create policy "Authenticated users can view all events" on member_events for select to authenticated
  using (auth.uid() = user_id or is_staff());

-- Member-owned company data: "OR any logged-in user" → "OR staff"
-- (stops members reading other companies' personnel, SQEP, self-assessment answers etc.)
drop policy if exists "nr_evidence_analysis_member_select" on nr_evidence_analysis;
create policy "nr_evidence_analysis_member_select" on nr_evidence_analysis for select
  using (company_id in (select id from nr_companies where member_user_id = auth.uid()) or is_staff());
drop policy if exists "nr_evidence_analysis_member_update" on nr_evidence_analysis;
create policy "nr_evidence_analysis_member_update" on nr_evidence_analysis for update
  using (company_id in (select id from nr_companies where member_user_id = auth.uid()) or is_staff());

drop policy if exists "nr_personnel_member_select" on nr_personnel;
create policy "nr_personnel_member_select" on nr_personnel for select
  using (company_id in (select id from nr_companies where member_user_id = auth.uid()) or is_staff());

drop policy if exists "nr_quiz_completions_member_select" on nr_quiz_completions;
create policy "nr_quiz_completions_member_select" on nr_quiz_completions for select
  using (company_id in (select id from nr_companies where member_user_id = auth.uid()) or is_staff());

drop policy if exists "nr_self_assessment_answers_member_select" on nr_self_assessment_answers;
create policy "nr_self_assessment_answers_member_select" on nr_self_assessment_answers for select
  using (company_id in (select id from nr_companies where member_user_id = auth.uid()) or is_staff());

drop policy if exists "nr_skills_entries_member_select" on nr_skills_entries;
create policy "nr_skills_entries_member_select" on nr_skills_entries for select
  using (company_id in (select id from nr_companies where member_user_id = auth.uid()) or is_staff());

drop policy if exists "nr_sqep_entries_member_select" on nr_sqep_entries;
create policy "nr_sqep_entries_member_select" on nr_sqep_entries for select
  using (company_id in (select id from nr_companies where member_user_id = auth.uid()) or is_staff());

commit;

-- ─────────────────────────── PART 3 — test ────────────────────────────────
-- A) Log in to members.html as a TEST member (not staff). F12 → Console:
--      await db.from('nr_companies').update({name:'Amazon Filters'}).eq('name','Amazon Filters').select()
--    PASS = data: []   (harmless if it fails: it rewrites the name to the same value)
-- B) Log in to SCC as staff: open the tracker, actions, NR review queue; approve a test update.
-- Undo if SCC breaks: someone is missing from staff_users — add them (PART 1 insert) and retry.
