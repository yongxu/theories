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

Every changed sentence was checked against the current Lean statement by its editor and by a reviewer; the Lean changes are comments only (the code with comments removed is unchanged in all 14 files), and the core checker reran every affected step.
