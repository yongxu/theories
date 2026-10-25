# OU3b: landing the master laws on the grammar

26 October 2026. AI-written landing note for board item OU3b, with OU3b-2 and OU3b-3. It says what lands, the decisions taken, the exact command sequence, and what a full rehearsal of that sequence showed. The scripts are in [kit/](kit/), and the rehearsal's logs are in [kit/rehearsal/](kit/rehearsal/). The rehearsal ran twice in a throwaway worktree, with nothing committed: first at `094257cc4`, then again at `ba3e42d27`, main after MA4, UE1b and UE2 had landed ([kit/rehearsal/main/](kit/rehearsal/main/)). The real landing runs the same scripts on a clean landing worktree at the then-current main.

## What lands

**Lean.** `Becoming.GrammarLaws` (from [tree/Becoming/](tree/Becoming/)) is a new core module below the frame. It imports `Becoming.Grammar`, `Becoming.GrammarMap` and `Becoming.Prelude`, and has 113 theorems in 133 declarations. `Becoming.Frame` imports it, so every model module reaches it. Fourteen model modules change by 3-way patches against their last commits (Frame, Recurrence, Attraction, Laws, Mechanism, IdentificationRuns, GrammarRegularity, GrammarScope, Regions, Admission, Flow, Amounts, InAmounts, Weightings):
- each original is proved from the grammar's law, keeping its name and statement (board rule 9);
- 40 representation and bridge declarations are added;
- no declaration is removed.

`GrammarLaws` is added:
- to `CORE` in `check_becoming.py` and to its scope text;
- to the root `Becoming.lean`, as an import and an L0 bullet; the Grammar, GrammarMap, Frame and Amounts bullets are updated;
- to the package README rows (EN, ZH), with the Frame and Amounts rows updated.

**The record** `master-laws-on-the-grammar`, *The master laws on the grammar*, standing theorem.
- It cites all 133 declarations of the module and the 40 bridges, in 16 law groups (EN, ZH).
- A 17th group names the 47 originals now proved from them, including the list lemmas that are now aliases.
- Balance is labelled near-definitional and represented, not derived.
- Premises: none beyond the grammar and the models' representation.
- Five witnesses, six does-not-show items and fifteen formal-reuse dependencies.

**Texts.**
- 01-ROOT §7 is the home section (`r-master-laws-on-the-grammar`), law by law. It adds the `[GrammarLaws]` link reference, and the Open item on lifting now names the master laws.
- 08-METHOD §7:
  - adds the column *On the grammar*;
  - replaces the finite-runs clause with [PROPOSED-08-7-FINITE-RUNS](PROPOSED-08-7-FINITE-RUNS.md)'s ("rest is not a case of being drawn");
  - adds a sentence on the column;
  - recounts the connectivity counts from THEOREM-CONNECTIVITY.json;
  - adds the grammar-reach measure.
- 08's receipt counts.
- COVERAGE.json's finite-runs statement, so that COMPLETION.md agrees with 08.
- The study section, the next § of BECOMING-RENEWAL-READING.md, computed at landing.
- regions.json: the module and the record (region root, base grammar), and Frame's note.

**Not applied.** [proposed_one_page_overview_ou3b.txt](kit/proposed_one_page_overview_ou3b.txt) gives exact old → new lines for ONE-PAGE, the overview and their Chinese editions. Those pages are NR's.

## Decisions

- **Balance represented, not routed.** The order anchors are routed through the grammar, and balance's consumers are not. The grammar's widening is the general law, and Web's is its instance. Balance's grammar form only encodes the numbers, so routing its consumers through lists would add a dependence and no content (AUDIT, review finding F13).
- **Frame's base stays `frame`.** Its note records that its closure is the grammar's `«所闭»`. The module and record are `root`/`grammar`.
- **No reverse dependencies.** The earlier records are not edited to list the new one, which keeps the dependency graph acyclic.
- **The measure counts «» names only**, as AUDIT row 8 reads the ASCII list lemmas: they are not statements of the grammar. `measure_grammar.py` is unchanged, and its output is committed beside `baseline.json` as `after.json`.
- **The connectivity register** takes the 34 apart roots OU3b makes, each with a category and a reason, and drops the two `Becoming.Grammar` entries that are no longer apart (`«一之续»`, `«则之传递»`). `register_ou3b.py` stops on any root that is not OU3b's.
- **Re-pointing is filtered** to OU3b's paths. The Lean drift is accepted only after the signature audit shows every theorem of the fourteen modules printing its old statement. Each other drifting pair must lie in a section OU3b writes, or in a JSON file whose only change is OU3b's edit.

## Commands

All commands run from the landing worktree's root. Set:
- `K=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou3b-master-laws-on-the-grammar/kit`, the kit copied into the worktree and committed with the landing;
- `P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming`;
- `RF=_process/research/2026-10-05-generative-foundation-review/root-foundation`.

1. `python3 -B $K/integrate_ou3b.py`. It copies the module and 3-way applies the fourteen patches; it stops on any conflict or drift from the kit tree. Then it edits CORE, the scope, the root module and the READMEs. (`make_patches_ou3b.py` remakes the patches and is needed only if the kit tree changes.)
2. `(cd $P && python3 -B check_becoming.py)`. This produces `RECEIPT`. Frame changes, so most of the core rebuilds.
3. `python3 -B $K/signatures_ou3b.py RECEIPT`. It must print "statements unchanged in every changed module".
4. `python3 -B $RF/THEOREM-CONNECTIVITY.py --check > $K/conn-check.log 2>&1`. The command fails, listing the unclassified roots on stderr, so keep `2>&1`. Then run `python3 -B $K/register_ou3b.py $K/conn-check.log` and `python3 -B $RF/THEOREM-CONNECTIVITY.py --check --write`; the second must pass.
5. `python3 -B $RF/development/ou3b-master-laws-on-the-grammar/measure_grammar.py --json $PWD/$RF/development/ou3b-master-laws-on-the-grammar/after.json`. The measure changes directory, so the path must be absolute.
6. Optional (review finding F16): `python3 -B tools/research/research.py move --plan $K/move_ou3b.tsv --apply`. This moves DRAFT-NOTES.md and OU3bCheck.lean.txt to `history/`. Run it before step 8, because the record hashes OU3b2-NOTES.md.
7. `python3 -B $K/texts_ou3b.py RECEIPT N $PWD/$RF/development/ou3b-master-laws-on-the-grammar/after.json`, where `N` is the last § plus one. The script asserts this.
8. `python3 -B $K/make_records_ou3b.py RECEIPT N`.
9. `python3 -B $K/repoint_ou3b.py RECEIPT` (a dry run), then the same with `--apply`.
10. `python3 -B $K/board_ou3b.py land OU3b RECEIPT N "QUEUE" "STATE"`. QUEUE must contain `§N` and the receipt. Item 4 ("One root") of the board's *Now* section mentions OU3b and is edited by hand.
11. `make research-render research-check research-links research-test`. The kit, with its rehearsal logs, must be in the worktree before the render, or the research indexes come out stale. Then commit the owned paths with `git commit -m … -- <paths>`, naming no person or AI and with no co-author trailer, and merge or fast-forward through the queue.

## What the rehearsal showed

Every step passed, in the order above, against `094257cc4`. The figures below are from that run; the second run is summarized after them.

- **Integrate.** All fourteen patches applied cleanly and matched the kit tree.
- **Checker.** Receipt `20261025T172255.378622Z`: 1,223 steps run and 81 reused, in about four minutes. The closure has 326 modules, of which 310 are core, and 15,211 theorems. 20,774 declarations were audited, and every axiom report is empty.
- **Signatures.** All 990 theorems of the fourteen modules print unchanged. Only ClosedUnder, WithinClosure and skipAt have rewritten bodies, each equal to the old one by `rfl`.
- **Register.** 34 roots added (16 general structure, 12 support, 5 model witnesses, 1 calibration) and 2 dropped; `--check` then passes.
- **Measure after.** 28 of 127 central declarations reach the grammar; before, 0 did.

  | Law | Reach the grammar |
  |---|---|
  | Closure | 16 of 16 |
  | Finite runs | 9 of 14 |
  | Balance | 14 of 52 |
  | Order | 1 of 9 |
  | Lumping | 0 of 1 |

  Of the anchors, only `WithinClosure` and `Amounts.rests` reach the grammar.
- **Connectivity.** The master-law counts are unchanged: 77 of 127.
- **Re-pointing.** 305 pairs in 183 records: 304 Lean pairs, and one COVERAGE.json pair (`central-laws-over-every-exchange`, checked to differ only by the finite-runs statement). None was left to other owners, and the 01 and 08 edits made no drift. One rebinds line was written.
- **Generated pages.** Render, check and links (0 broken) pass. The test suite ran 212 tests, all OK, one skipped.
- **Record lint.** One finding, the status wording of a does-not-show item, was fixed in the kit.

**The second run, on main at `ba3e42d27`.** Every step passed again.
- Integrate applied all fourteen patches cleanly, though main had changed `Becoming.lean`, `check_becoming.py`, the README and 08.
- The checker gave receipt `20261025T180839.731606Z`: 27 steps run and 1,289 reused from the first run's cache, in about one and a half minutes.
- The signature audit (990 statements), the register (34 roots added, 2 dropped) and the measure (28 of 127) came out the same as in the first run.
- `N` was 417.
- Re-pointing covered 306 pairs in 184 records, one more than the first run because main had added a record citing a changed module. Again, nothing was left to other owners.
- Render, check, links (0 broken) and test (212 tests, all OK, one skipped) passed.

## For the lander to decide

- **N and the receipt.** N is the next free § at landing (417 at `ba3e42d27`). If another landing touches any of the fourteen modules, the 3-way apply stops; then re-derive the patches. A new apart root from another landing stops `register_ou3b.py`; that root belongs to its owner.
- **The board texts** (QUEUE and STATE), and item 4 of the *Now* section.
- **Step 6 (F16).** Whether to move the superseded drafts, or leave them as the study's history.
- **The proposals for the one page and the overview**, to hand to NR.
- **Cleanup after landing.** Remove `tree/.build` (build output, not data).
