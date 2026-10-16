# scc.html — carry lat/lng through to NuclearReady

Two edits. Nothing else in `scc.html` changes, and no SharePoint
call changes.

**Run `nr_companies_geo.sql` first.** The second edit is gated by
`sdbFieldSyncAvailable`, which is set by whether the `CRM_LINK_COLS_FULL`
select succeeds — so if the columns do not exist yet, the first edit makes
that select fail and the screen silently falls back to tags-only sync. That
is the existing designed behaviour, not a new failure mode, but it does mean
the patch is inert until the migration has run.

Back up `scc.html` before editing — the file is ~1.8 MB and has very long
lines. Edit it with a script, not by retyping, and confirm the byte count
only grew by the size of what you added.

---

## Edit 1 — ask Supabase for the two columns

Without this, `sdbSyncTagsToCrm` compares against a `crmRow.lat` that is
always `undefined`, so it would rewrite the coordinates on every load.

**Find** (one line, inside `sdbLoad`):

```js
const CRM_LINK_COLS_FULL = 'id,name,sharepoint_company_id,capabilities,accreditations,markets,region,city,county,postcode,address,employees,turnover,main_commodity_group';
```

**Replace with:**

```js
const CRM_LINK_COLS_FULL = 'id,name,sharepoint_company_id,capabilities,accreditations,markets,region,city,county,postcode,address,employees,turnover,main_commodity_group,lat,lng';
```

---

## Edit 2 — copy the coordinates across

**Find** the end of `sdbProfileFieldsFor(c)`:

```js
  const out = {};
  Object.keys(fields).forEach(k => {
    const v = fields[k];
    if (v !== undefined && v !== null && String(v).trim() !== '') out[k] = v;
  });
  return out;
}
```

**Replace with:**

```js
  const out = {};
  Object.keys(fields).forEach(k => {
    const v = fields[k];
    if (v !== undefined && v !== null && String(v).trim() !== '') out[k] = v;
  });

  // Coordinates. Kept out of the loop above for three reasons:
  //  - they must reach Supabase as numbers, not strings;
  //  - 0,0 is what a failed geocode looks like, not a place in the sea
  //    off Ghana, so it is rejected rather than stored;
  //  - rounding to 6dp keeps the String() comparison in sdbSyncTagsToCrm
  //    stable, otherwise float formatting makes every row look changed
  //    on every load.
  // c.lat / c.lng survive sdbNormaliseCompany untouched (it spreads ...c),
  // and sdbLoad fetches Companies with an empty $select, so both columns
  // are already in the payload — no SharePoint change needed.
  const lat = parseFloat(c.lat);
  const lng = parseFloat(c.lng);
  if (Number.isFinite(lat) && Number.isFinite(lng) && !(lat === 0 && lng === 0)) {
    out.lat = Math.round(lat * 1e6) / 1e6;
    out.lng = Math.round(lng * 1e6) / 1e6;
  }

  return out;
}
```

Both call sites pick this up with no further change: `sdbSyncTagsToCrm`
(refreshes linked companies on every Supplier Database load) and
`sdbCreateCrmCompany` (new company created from a SharePoint record).

The existing "never overwrite a populated CRM value with a blank" rule still
holds — if SharePoint has no coordinates, nothing is written.

---

## Optional — expose them in NuclearReady.html

Only needed if the Explorer is going to plot points itself. `loadCompanies()`
already does `.select('*')`, so both columns arrive with no query change; they
just are not mapped onto the company object. In `mapCompany(row)`, alongside
`postcode` / `address`:

```js
    lat:            row.lat != null ? parseFloat(row.lat) : null,
    lng:            row.lng != null ? parseFloat(row.lng) : null,
```

Note the existing "View on map" button in the detail drawer does **not** need
this. It builds a Google Maps text-search URL from name + postcode + 'UK' and
lets Google do the geocoding at click time:

```js
const mapQuery = encodeURIComponent(c.postcode
  ? [c.name, c.postcode, 'UK'].filter(Boolean).join(' ')
  : [c.name, c.city, c.county, 'UK'].filter(Boolean).join(' '));
```

That is worth keeping either way — it still works for a member with no
coordinates, which an embedded map cannot.

---

## What this does not fix

Coordinates only reach members that have been **linked** to a SharePoint
record. A row with `sharepoint_company_id` null inherits nothing, however
good its postcode is. Query 1 in the SQL file tells you how many of the 52
that is, and that number is the real ceiling on map coverage — run it before
deciding the map view is viable.

For anything linked but still missing coordinates upstream, the geocoder
already exists: `Pythons_Updaters/Geocode/regeocode.py` (postcodes.io bulk,
Nominatim fallback for Eircodes and dead postcodes). It reads an xlsx and
writes `updated_coords.csv` — it would need repointing at Supabase, or the
CSV loading by hand.
