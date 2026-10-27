# DF: the record corrections of DEFECTS-FOUND

Board item DF, under RA. [DEFECTS-FOUND](../DEFECTS-FOUND.md) lists what the drafters of the eight chapters found wrong in records, regions, docstrings and chapter lines on 23 October 2026, with a section of 25 October. DF checks every entry against the repository as it is and corrects what is still wrong; each entry now ends with what became of it. The work is the AI's. DF1 lands the corrections; DF2 makes the records still missing ([LEFT](LEFT.md)).

What is here, in the order the work went:

- [`triage.json`](triage.json): 288 rows, each entry of DEFECTS-FOUND checked against the records, chapters and Lean at `0e368fbf2` (status: open, partly open, already fixed, not a defect, not ours; the evidence; a proposed fix). Each row's `section` and `entry` (its first 100 characters) name the entry it belongs to.
- [`units.json`](units.json): how the open rows were divided: three disjoint groups of records, one unit of non-record rows (regions, docstrings, chapter lines, small fixes), and the later sweep of retired labels in four groups of records with the specific instructions some had. Rows are indices into `triage.json`.
- [`reports/`](reports/): what each editor did and did not apply and why (`edit-*.json`), the skeptical reviews and the fixes (`review-nonrec.json`, `review-fix-records.json`), the cross-model review of the non-record changes (`cross-model-*`), the sweep with its reviews, fixes and completeness check (`sweep.json`), and the two checks of the statuses (`status.json`).
- [`NOTES.md`](NOTES.md): how the lander settled what the editors deferred, and the findings it took itself.
- [`LEFT.md`](LEFT.md): what DF1 leaves, for DF2 and for owners on the board.
- [`workflows/`](workflows/): the orchestration scripts, as run (the agents' briefs are in them).
- `land_df1.py`: the landing texts after a passing core checker (study section, history notes, the board's RA row).

DF1b (study §422) took ten weak points UE8's sciences dossier found ([DEFECTS-FOUND](../DEFECTS-FOUND.md), "Found while drafting the sciences dossier"):

- `df1b_edits.py`, `df1b_edits2.py`, `df1b_edits3.py`: the three rounds of corrections, as applied (each replacement asserted once).
- [`reports/review-df1b.json`](reports/review-df1b.json): the skeptical review of the first round and the completeness critic, 45 findings with what became of each; [`reports/recheck-df1b.txt`](reports/recheck-df1b.txt): the recheck of the second round and the cold read of the whole change, 26 findings, all taken in the third round.
- `workflows/6-df1b-review.js`, `workflows/7-df1b-recheck.js`: the two review runs.
- `binding_for.py`: the receipt that binds a Lean source's current bytes, for a record's references and proof binding.
- `land_df1b.py`: the landing texts after a passing periphery checker (study section, history notes, DEFECTS-FOUND's marks, the board's RA row).

Every changed sentence was checked against the current Lean statement by its editor and by a reviewer; the Lean changes are comments only (the code with comments removed is unchanged in all 14 files), and the core checker reran every affected step.

DF2 made the records still missing ([LEFT](LEFT.md) says what it leaves):

- [`DF2-PLAN.md`](DF2-PLAN.md): the four units, the rows each takes and the lander's part.
- `workflows/8-df2-records.js`: the four drafters and four reviewers, as run; [`reports/df2-draft-*.json`](reports/) the drafters' records, anchors, regions and proposed edits, [`reports/df2-review-*.json`](reports/) the reviews (189 edits), [`reports/df2-applied.json`](reports/df2-applied.json) and [`reports/df2-pending.json`](reports/df2-pending.json) which edits went to the records by field and which the lander placed.
- `df2_rest.py` (two statements, D69 and 01's labels), `df2_apply_records.py` and `df2_apply_records2.py` (the reviewers' record edits), `df2_chapters.py` (the chapter edits with the reviewers' corrections, the anchors, the record edits outside a unit's own records, regions.json), `df2_closing.py` (Closing.lean's header), `df2_layers.py` (the layer labels, recomputed and asserted), `df2_fix_check.py` (two errors check found), as applied; [`reports/recheck-df2.json`](reports/recheck-df2.json) the cold read of the applied state.
- `land_df2.py`: the landing texts after a passing core checker (study section, history notes, DEFECTS-FOUND's marks, the board).
