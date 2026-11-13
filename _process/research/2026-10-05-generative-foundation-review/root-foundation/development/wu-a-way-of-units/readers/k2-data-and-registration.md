AI-written (Opus checker), 13 November 2026

# WU landing: the data and the registration, read to refute

Read only, in the worktree `/Users/ren/tmp/wu/wt` (branch `wu-way-of-units`). I changed no file but this one and ran no git command that changes state. Runs: `python3 -B -m unittest tools.research.tests.test_atlas`, `research.py lint --ids a-way-of-units`, `research.py check --ids a-way-of-units`. No Lean run: the lister output was checked against the source and the mapping instead. No core run, render, gate or full suite: those were deliberately not run here.

## Verdict

The data and the registration hold. I found nothing that makes a wrong claim about what the Lean proves. One item TT's model needs is not done yet (the word "leaf" in TT's record). The rest are small: two points in the study note, two failures not kept, and three judgment calls in the atlas data.

## (a) The atlas

- **The entry `turning-in-time`.** `records` gains `a-way-of-units`. The 34 `WayOfUnits` declarations listed are exactly the record's proof declarations and its laws' declarations, and every one exists in the file. The file has 66 declarations, 47 of them theorems, which matches `build.log`, NOTE and the record. The hypotheses refer to `a-way-of-units` indices 1 to 7 of its 7 hypotheses, 1-based as TT's do. There is one new `open` item and one new source anchor (`#r-a-way-of-units`, present in 02). There are twelve `premises` rows.
- **The mechanism sentence added to the entry** is not the coordinator's verbatim text. Its "under the regime's premises along the course" leaves out three premises: every unit of the start needing something, nothing given from nothing, and the start at most `hi`. Its "for two units this is the exact condition above" leaves out `n ≤ m` and the start below `h + H₂ + y₁`. This is minor, since the record carries the premises. A fix is below.
- **The nine new premises.** Each statement says its binder's proposition, checked against the Lean signatures:
  - `unit-above-level`: `mp`, `lt`.
  - `unit-met`: `mq`, `ge`.
  - `needs-positive`: `∀ u ∈ w, 0 < need u`.
  - `regime-along`: exactly `along`, with `j ≤ k`.
  - `order`: `n ≤ m`.
  - `greater-need`: `m ≤ m'`.
  - `same-sum`: `h + H₂ = h' + H₂'`.
  - `more-on-first`: `h ≤ h'`.
  - `first-line-unending`: the hygienic antecedent.

  The `holds_in` entries are right: `With.goes_on_holds` discharges `needs` and `along`, and `With.goes_on` discharges `order` and is the unending line.
- **Reused ids** are the same predicate at other arguments, as in TT's own rows:
  - `regimemargin-short`, `-meets` and `-keeps` at `H₂`, `H₂'` and `h + H₂`;
  - `turningintime-within` for `n ≤ H₂ + y₂` and `n ≤ H₂' + y₂'`;
  - `optimum-coupled-need-positive` for `0 < n`;
  - `regimemargin-start-below-point` for `x < h + H₂ + y₁` and `x < H₂ + y₁`;
  - `regimemargin-start-level-le-hi`.

  Like TT, WU does not touch the `lean` lists of the reused premises.
- **Possible duplicate.** `wayofunits-first-line-unending` is `«不穷» (net giving) «一» (…)`, an instance of `grammar-buqiong` (`«不穷» R L x`). The ledger reuses generic ids for instances. Either reuse that id, or keep the new one and say why: its role is the first of two lines compared. No other new premise duplicates one in the ledger. The two `n ≤ m` premises already there (`tolerance-later-step`, `withholding-later-step`) are about steps.
- **Rows against the lister output.** For all twelve laws, the mapping rows' binders, in position, name and type, are exactly the lister's. `source: lister` and `family: A` are set. The mapping holds 1677 rows; the diff adds rows and changes nothing else.
- **The assignment file** gives each binder the entry's premises. One inconsistency: `ends_while_net_goes` takes no `regimemargin-step`, while `takes_nothing_iff_alone` and `unending_iff_carrier`, also "under any giving", take it as a definition. The note's stated reason ("holds under any giving") does not tell them apart. A reason that does: "its proof does not use the level's step". This matches TT's `kind_ends_while_net_goes`, which takes none either.
- **The six README bullet** is accurate: nine new, the rest reused, and the hygienic binder named. Its "No checker set to refute read these twelve rows" is now out of date because of this reading. Whether to change it is the coordinator's call.

## (b) Registration against TT

TT's pre-core commit `20f2a22e7` registered the module in `Becoming.lean` (import and bullet), in `README.md` and `README.zh.md` (row), in `check_becoming.py` (`CORE` and `SCOPE`) and in `regions.json` (records and modules). WU does every one of these:

- the import goes after `TurningInTime`;
- TT's bullet "A leaf" becomes "Imported by `Becoming.WayOfUnits`";
- the `CORE` entry goes after `TurningInTime`, with a `SCOPE` paragraph;
- `regions.json` gets the record `a-way-of-units` and the module `Becoming.WayOfUnits`.

The signature, audit and prelude steps of the checker are chosen automatically, so they need no list entry.

TT's later commits are generated or post-core: the receipt, `rebinds.jsonl`, `shared-laws.json`, `source-index.json`, `lean-index.json` and the render.

The map's card (`map/cards.json`, hand-written in TT's `0307d749f`) does not name records, so nothing is missing there. Adding a WU theorem to the `turning-in-time` card is an optional follow-up.

No generated page is edited: `git status` shows none, and `atlas.json`, the indexes and the manifest are untouched.

The Lean file in the package is byte-identical to `/Users/ren/theories/tmp/r7/wu/lean/Becoming/WayOfUnits.lean` (`cmp`). The scratch build's copy differs from it in comments only (I read the diff).

**Not done: TT's record says "a leaf".** `turning-in-time`'s `validation_scope` still says "a leaf". That is false once `WayOfUnits` imports it. The kit README flags this but the worktree does not fix it. It must be corrected before TT's kit is rerun, since the 02 §11 change drifts both TT records anyway.

## (c) The study folder

- **The copies.** `DESIGN.md`, `DESIGN-attacked.md` and the six reports are byte-identical to the scratch copies. `sim/r3-logic/sim.py` is identical to the scratchpad's `sim.py`.
- **Links.** All links in NOTE, READER, the kit README and the six README resolve.
- **READER.md** says each report's findings, what was done and what stays open, and matches the reports I sampled (v1 §1–4, v2 header, v3 header) and the landed file. v3's point (1) is rightly kept open. The file does not make the result larger.
- **NOTE.md** is accurate on the theorems and premises. I checked:
  - `takes_nothing_ends`: four premises added to `order`, five in all;
  - the 66 declarations and 47 theorems;
  - `regime_levels` and `orbit_id` are private in TurningInTime.

  Points to fix:
  - **Word, line 15:** "a first unit that takes nothing leaves the line the second unit's alone" makes the unit a doer. This is the same wording v3 (4) had fixed in the Lean. Fix: "with a first unit that takes nothing the line is the second unit's alone".
  - **Line 74:** "Line numbers in `v1-statements.md` and `v2-premises.md` refer to an earlier form". The only line numbers in those reports are `Continuation.lean:480` and `RegimeMargin.lean:249–265`, which are other modules. None refers to `WayOfUnits`.
  - **Line 74, the earlier forms.** They are not kept "because it is not recorded which reader read which form". The file times largely settle it:
    - `WayOfUnits-v1.lean.bak` (817 lines, 08:32) was saved after v2-premises (08:28) and before the repairs;
    - `WayOfUnits-v2.lean.bak` (902 lines, 08:44) is the form v3-cold says it read ("902 lines", 08:43).

    TT kept its first attempt under `held/`. Keep both as `held/*.lean.txt`, with the reader-to-form match stated as an inference from file times.
  - **Failures not kept.** `g7.py`, `g7b.py` and `g7c.py` (07:24–07:26, before r3-logic's 07:35 report) and `sim_units.py` are dropped. The g7 scripts are most likely the search behind the G7 counterexample that the note itself lists among the corrections kept. AGENTS asks that failed tests be kept. Keep them under `sim/`, marked as named by no report.
  - **NOTE's table row for `DESIGN-attacked.md`:** "its first line calls the file `DESIGN-R3-attacked.md`". It is `DESIGN.md`'s first line that does.
- **The kit.** `fill_records.py` is TT's with `IDS` and the docstrings changed (diffed). It refuses on missing files, a failed receipt, an unbound hash or unknown declarations, as TT's does. Its README covers what TT's model adds for this landing:
  - rerunning TT's kit for the two drifted TT records;
  - the "leaf" correction;
  - re-pointing the ten records that cite the live receipt;
  - the shared theorems;
  - the render, with drift read before any re-point;
  - the focused checks.

## (d) Runs

- `python3 -B -m unittest tools.research.tests.test_atlas`: OK, 80 tests in 21 s at a load around 50. This includes `test_every_listing_holds_its_binders`.
- `research.py lint --ids a-way-of-units`: 0 errors and 1 warning, `status-restatement` on `does_not_show[1]`. That item is the coordinator's verbatim sentence and is kept.
- `research.py check --ids a-way-of-units`: rc 1, with 12 errors, all on `a-way-of-units`. Each waits for the core run and then WU's `fill_records.py`:
  - "UTC documentary review timestamp required": the kit sets `reviewed_at_utc`.
  - The missing receipt `becoming-checks/RECEIPT_TIMESTAMP/verification.json`: the core run, then the kit.
  - "invalid reviewed hash" ×9 (`FILLED-BY-KIT`): the kit hashes these files once they are final. They are `WayOfUnits.lean`, `NOTE.md`, `DESIGN.md`, `DESIGN-attacked.md`, `READER.md`, `readers/r3-logic.md`, `readers/v2-premises.md`, `02-MAP.md` and the sources file.
  - "recorded-checked needs a source hash binding in its existing receipt": the kit's `proof_bindings`.

  There are also 2 `source_drift` entries, for `going-alike-up-to-the-nets-end` and `turning-in-time`, both from 02 §11. These wait for TT's kit to be rerun after the core run, with the "leaf" fix first.

Selected evidence only; the full suite and the gate were deliberately not run here.
