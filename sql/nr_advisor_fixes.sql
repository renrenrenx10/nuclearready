-- ═══════════════════════════════════════════════════════════════════════
-- Supabase Security Advisor fixes (2026-09-24). Run the whole file in one go.
-- ═══════════════════════════════════════════════════════════════════════
begin;

-- 1. rls_disabled_in_public: public.tags
--    Nothing in members.html, scc.html or the NuclearReady pages uses this table.
--    Switch RLS on: anyone can still read it, only staff can change it.
alter table public.tags enable row level security;
drop policy if exists "Anyone can read tags" on public.tags;
drop policy if exists "Staff can manage tags" on public.tags;
create policy "Anyone can read tags"  on public.tags for select using (true);
create policy "Staff can manage tags" on public.tags for all to authenticated
  using (is_staff()) with check (is_staff());

-- 2. security_definer_view: public.public_nr_news
--    Make the view run with the VISITOR's permissions, and give visitors (anon)
--    exactly what the view needs: approved, not-removed rows, public columns only.
alter view public.public_nr_news set (security_invoker = true);

drop policy if exists "Public can read published news" on nr_news_submissions;
create policy "Public can read published news" on nr_news_submissions for select to anon
  using (status = 'approved' and unpublished_at is null);

-- anon may only see these columns (no user ids, reviewer emails or notes)
revoke select on nr_news_submissions from anon;
grant select (id, title, type, body, company_name, company_id, pinned,
              reviewed_at, submitted_at, status, unpublished_at)
  on nr_news_submissions to anon;

commit;
notify pgrst, 'reload schema';

-- CHECK afterwards (should still show your approved story, and nothing else):
--   open NuclearReady_Landing.html and a company profile in NuclearReady.html
-- Then Advisors → Security Advisor → Rerun: both errors should be gone.
