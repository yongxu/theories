# Landing LA4's formal part

The order, from a worktree on branch `la4-formal` (the kit's scripts run from the checkout root). Every script asserts what it expects and stops otherwise; nothing here needs a learner, PyTorch or a download.

1. **Slot.** The coordinator's order (30 October): GW, UE24, RR's Lean, RV21's item 13 with LW's follow-up, RV21b, AJ6b, MV, fm-cond1, then LA4. Claim the head once fm-cond1's clause on the Queue line says landed, with a clause behind every earlier claim, in this worktree; re-read the Queue line before every fast-forward. No session owns T3's text on the board, so its wording here is LA4's to land.
2. **Merge main** into the branch and read the whole output; on a conflict in a generated file, restore one side and re-render later.
3. `python3 -B …/kit/integrate_la4.py`: the two leaves into the package, the root module's imports and bullets, the checker's core list and descriptions, the README rows (no Chinese row for `Becoming.WeightedCommuting`, whose parent has none).
4. **The core run** (incremental; the scratch builds stored both modules' steps under the checker's keys): `python3 -B check_becoming.py` in the package. Every axiom report empty; note the receipt.
5. `python3 -B …/kit/texts_la4.py`: 05 §7 (case row, theorem and reading, F2's statement, standing, evidence), 08's T3 row, the overview's T3 row in both editions, experiments README.
6. **The study section**: `kit/study_la4.txt` with `{N}` the next free section of `BECOMING-RENEWAL-READING.md`, `{RECEIPT}` and the two modules' counts from the receipt, appended at the end.
7. `python3 -B …/kit/make_records_la4.py RECEIPT N …/la4-formal/REVIEW-LA4-FORMAL.md`: the two records and the regions of the records and the modules.
8. **Connectivity**: `THEOREM-CONNECTIVITY.py --check` (log to a file), `python3 -B …/kit/register_la4.py LOG`, then `--write`; then `master_laws.py` if the coverage report reads the run.
9. `python3 -B …/kit/board_la4.py RECEIPT N`: LA4's row gains the formal part, landed.
10. **Render and gates**, in a clean worktree if anything untracked could be counted: `make research-render`, `research-check-strict`, `research-links`, `research-test`; the dossier check if 05 §7 is quoted there.
11. **Commit** owned paths only (`git commit -m … -- <paths>`, no trailer), report on the Queue line, re-read it, `git merge --ff-only` into main, and tell the coordinator.

RV21b adds a lesson to 08's theses section (a frozen scoring rule can miss its construct, from LA2): after merging main, rebase `texts_la4.py`'s 08 edit on it if it touched T3's row.

What would stop it: a later change to 05 §7's last case row, T3's standing, F2's line or the evidence's "Outside:" bullet, to 08's T3 row, or to the overview's T3 rows (texts_la4.py asserts each passage); a new apart root of another session's in the connectivity log (register_la4.py stops on it).
