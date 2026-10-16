-- ═══════════════════════════════════════════════════════════════════════
-- NuclearReady: company-linked submissions  (2026-09-24)
-- Run AFTER nr_launch_lockdown.sql (uses is_staff()). Run the whole file in one go.
-- ═══════════════════════════════════════════════════════════════════════
begin;

-- 1. News submissions need a company_id (fixes "Could not find the 'company_id' column")
alter table nr_news_submissions add column if not exists company_id uuid references nr_companies(id);

-- helper: is the logged-in user a Portal User of this company?
create or replace function is_company_member(cid uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from company_members where company_id = cid and user_id = auth.uid())
      or exists (select 1 from nr_companies  where id = cid and member_user_id = auth.uid());
$$;

-- 2. Members can only submit profile updates / news for a company they're linked to
drop policy if exists "Users can insert own updates" on nr_profile_updates;
create policy "Users can insert own updates" on nr_profile_updates for insert
  with check (auth.uid() = user_id and (is_company_member(company_id) or is_staff()));

drop policy if exists "Users can insert own news" on nr_news_submissions;
create policy "Users can insert own news" on nr_news_submissions for insert
  with check (auth.uid() = user_id and (is_company_member(company_id) or is_staff()));

-- 3. Portal-user links: members see only their own; staff see all (SCC)
drop policy if exists "company_members_select" on company_members;
create policy "company_members_select" on company_members for select
  using (user_id = auth.uid() or is_staff());

commit;

-- Make PostgREST pick up the new column straight away
notify pgrst, 'reload schema';
