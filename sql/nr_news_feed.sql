-- NuclearReady landing page news feed (v2, 2026-09-24). Run the whole file in one go.
-- Adds Pin / Remove-from-site support for SCC, and rebuilds the public view.
alter table nr_news_submissions add column if not exists pinned boolean not null default false;
alter table nr_news_submissions add column if not exists unpublished_at timestamptz;

-- Public, read-only: approved and not removed; public columns only
drop view if exists public_nr_news;
create view public_nr_news as
select id, title, type, body, company_name, company_id, pinned,
       coalesce(reviewed_at, submitted_at) as published_at
from nr_news_submissions
where status = 'approved' and unpublished_at is null;

grant select on public_nr_news to anon, authenticated;
notify pgrst, 'reload schema';
