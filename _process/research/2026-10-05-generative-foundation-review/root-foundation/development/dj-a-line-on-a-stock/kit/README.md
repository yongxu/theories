# DJ's fill kit (AI-written, 16 November 2026)

`fill_records.py` binds the new record `a-line-on-a-stock` to a core run. It was adapted from WU's kit (`../../wu-a-way-of-units/kit/fill_records.py`) for a record whose anchor `r-a-line-on-a-stock` is in this study folder's `NOTE.md` and whose proof sources are two modules, `Becoming/LineOnAStock.lean` and `Becoming/LineOnAStockCases.lean`. It was first run, outside the repository, to bind the record to the core run `20261115T233900.527774Z`.

It sets the record's receipt reference to the run, the sha256 of every file the record references to that file's current bytes, one proof binding per Lean proof source (pointer `/source_sha256/Becoming.<Module>`), and `reviewed_at_utc` to now. It writes nothing if a referenced file is missing, if the receipt did not pass, if the receipt does not bind a proof source's current bytes, if a declaration the record names was not elaborated by that run, or if `NOTE.md` has no anchor `r-a-line-on-a-stock`.

Run it from the root of the landing worktree, never the shared checkout, after the core run, a dry run first:

```sh
python3 -B _process/research/2026-10-05-generative-foundation-review/root-foundation/development/dj-a-line-on-a-stock/kit/fill_records.py "$STAMP" --dry-run
python3 -B _process/research/2026-10-05-generative-foundation-review/root-foundation/development/dj-a-line-on-a-stock/kit/fill_records.py "$STAMP"
```

With no timestamp it takes the run named by `becoming-verification.json`'s `retained_run`.

The record hashes the two modules, the receipt, `NOTE.md`, `PAPER.md`, the six reports in `readers/` and `sources/15-codex-theory-conversations/2026-11-13-the-map-one-model.md`. A later edit to any of them drifts the record, and the kit must be run again; an edit to either module needs a new core run first, since the receipt must bind the module's current bytes.
