# NuclearReady

Public directory of companies on the Fit For Nuclear (F4N) programme, run by
NucCol (Nuclear Collaboration Ltd). It serves two jobs: showcasing members, and
letting a buyer find a company that can make a given thing.

Static pages, no build step. Deployed from this repo by GitHub Pages.

## Pages

| File | Role |
|------|------|
| `index.html` | Landing — hero, live member/region counts, news feed, what F4N is |
| `directory.html` | The directory. Filter menu along the bottom of the navy band, OR logic across groups |
| `company.html` | One company — `?c=<slug>` |
| `map.html` | Map view — `?c=<slug>` focuses and opens a pin |
| `compare.html` | Capability matrix — `?caps=a\|b\|c`, needs two or more |
| `nr-brand.css` | Shared design system. Tokens taken from nuccol.co.uk |
| `nr-data.js` | Supabase client, taxonomy, filter config, shared helpers |

All links are relative and flat, so the whole site works from any subpath.

## Data

Supabase (`qkyvmtouwrzrcyagkheo`), read through PostgREST:

- `nr_companies` — one row per member, `hidden=false` for the public list
- `public_nr_news` — view behind the landing page news feed

The anon key in `nr-data.js` is public by design; row-level security decides what
it can see. It is not a secret and does not need hiding.

Companies are maintained in SharePoint (the Supplier Database) and pushed into
Supabase by the staff tool `scc.html` in the Frankie repo. The link key is
`nr_companies.sharepoint_company_id`.

## Basemap

`map.html` uses Esri ArcGIS Location Platform static basemap tiles on a NucCol
account. The key sits in the page source, which is fine — it is referrer-locked
to `renrenrenx10.github.io` and `nuccol.co.uk` in the ArcGIS portal and is inert
anywhere else. Free allowance is 2M tiles/month.

Two things that will bite:

- **The key expires 16 October 2027.** After that every tile 401s and the map
  shows its "basemap unavailable" banner until the key is regenerated.
- **Referrer entries must include the scheme.** `https://nuccol.co.uk` matches;
  a bare `nuccol.co.uk` does not, and fails as `498 Token Invalid`, which looks
  exactly like a bad key. Changing referrers also forces a key regeneration.
- Opening `map.html` straight off disk shows no tiles. `file://` sends no
  referrer, so the key correctly refuses it. Serve it over http to test locally,
  and add that origin to the referrers.

## sql/

Migrations against the Supabase schema, roughly in the order they were applied.
Each is re-runnable. Two are historical rather than live:

- `nr_companies_rekey_four.sql` — superseded. The four companies were re-linked
  through scc instead, which moved their keys for us.
- `nr_companies_region_backfill.sql` — the dry run. `nr_companies_region_apply.sql`
  is the one that writes.

After any DDL, run `notify pgrst, 'reload schema';` or PostgREST keeps serving a
stale schema and new columns 400 — which makes scc silently fall back to a
reduced column set and stop syncing location fields.
