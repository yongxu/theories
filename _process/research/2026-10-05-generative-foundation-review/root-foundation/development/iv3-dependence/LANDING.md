# IV3 landing sequence

From the root of a worktree at main's head (board rule 5; this kit's scripts take paths from the working directory):

1. `python3 -B <kit>/integrate.py`: the extended `Becoming.Weightings` into the package and its root doc bullet.
2. Core checker: `python3 -B check_becoming.py` in the package folder; the receipt goes with the landing.
3. Connectivity: `THEOREM-CONNECTIVITY.py --check`; register the apart roots it names (`apart.py`); `--check`, then
   `--write`.
4. Texts and records: `apply_text.py N RECEIPT`, `section9.py RECEIPT MAIN N`, `make_records.py RECEIPT N`,
   `sh repoint.sh RECEIPT`.
5. `make research-render`, `research-check`, `research-links`, `research-test`; logs into this folder.
6. `board.py land RECEIPT N THEOREMS DECLS`; the scratch `tree/` copy of the module goes (the module is in the package).
7. Commit the paths `git status` lists on the branch, merge main if it moved (take main's board and re-apply the row),
   then fast-forward main in the shared checkout.

N is the study section after the last one on main; RECEIPT the checker's run id; MAIN the main commit the worktree
started from.

Re-point: repoint.sh re-pointed every drifting record, including continuation-relative-to-a-class, whose drift (on one-unfolding-root/PLAN.md) is another session's; that record and its line in the rebind log were restored, so its drift stays with its owner.
The history file of the board had been truncated by the XL4 landing; restore_history.py restored it (a separate commit) before board.py land.

## IV3b

1. `integrate_b.py`; core checker; connectivity `--check` (no new apart roots) and `--write`.
2. `apply_text_b.py N RECEIPT`, `section9_b.py RECEIPT MAIN N`, `update_records_b.py RECEIPT N`, `sh repoint_b.sh RECEIPT` (drift filtered to the paths IV3b changed).
3. The scratch copy of the module goes (`tree/Becoming/Weightings.lean`; the IV3 landing had left it); `board_b.py land RECEIPT N THEOREMS DECLS`.
4. Render, check, links and test with logs outside the repository; commit; merge main, render and fast-forward.

## IV3c

1. `integrate_c.py`; core checker (a first run found `Shifts` taken in `Becoming.Wholes`, which the scratch build does not import; the witness was renamed `FeedersInTurn` and the run repeated); connectivity `--check` (no new apart roots) and `--write`.
2. `apply_text_c.py N RECEIPT`, `section9_c.py RECEIPT MAIN N`, `update_records_c.py RECEIPT N`, `sh repoint_c.sh RECEIPT`.
3. The scratch copy of the module goes; `board_c.py land RECEIPT N THEOREMS DECLS`; render, check, links and test with logs outside the repository; commit; fast-forward.

## IV3d

1. `integrate_d.py`; core checker; connectivity `--check` (register any new apart roots) and `--write`.
2. `apply_text_d.py N RECEIPT`, `canonical_d.py` (the chapter's dependence bullet, EN and ZH), `section9_d.py RECEIPT MAIN N`, `update_records_d.py RECEIPT N`, `sh repoint_d.sh RECEIPT`.
3. The scratch copy of the module goes; `board_d.py land RECEIPT N THEOREMS DECLS`; render, check, links and test with logs outside the repository; commit; fast-forward.

## IV3e

1. `integrate_e.py`; core checker; connectivity `--check` (register any new apart roots) and `--write`.
2. `apply_text_e.py N RECEIPT`, `canonical_e.py` (the chapter's dependence bullet, EN and ZH), `section9_e.py RECEIPT MAIN N`, `update_records_e.py RECEIPT N` (lint the record before render), `sh repoint_e.sh RECEIPT`.
3. The scratch copy of the module goes; `board_e.py land RECEIPT N THEOREMS DECLS`; render, check, links and test with logs outside the repository; commit; fast-forward.

## IV3f

1. `integrate_f.py`; core checker; connectivity `--check` (register any new apart roots) and `--write`.
2. `apply_text_f.py N RECEIPT`, `canonical_f.py`, `section9_f.py RECEIPT MAIN N`, `update_records_f.py RECEIPT N` (lint the record before render), `sh repoint_f.sh RECEIPT`.
3. The scratch copy of the module goes; `board_f.py land RECEIPT N THEOREMS DECLS`; render, check, links and test with logs outside the repository; commit; fast-forward.

## IV3g

1. `integrate_g.py`; core checker; connectivity `--check` and `--write`.
2. `apply_text_g.py N RECEIPT` (also removes two stale "(new …)" markers in THE-STEP-OF-INVARIANCE §1, from the RA defect list), `canonical_g.py`, `section9_g.py RECEIPT MAIN N`, `update_records_g.py RECEIPT N` (lint first), `sh repoint_g.sh RECEIPT`.
3. The scratch copy of the module goes; `board_g.py land RECEIPT N THEOREMS DECLS`; render, check, links and test; commit; merge main if it moved, render and fast-forward.

## IV3h

1. `integrate_h.py` (module and root bullet corrected); core checker; connectivity `--check` and `--write`.
2. `apply_text_h.py N RECEIPT` (THE-STEP-OF-INVARIANCE, D64, README rows, study §373 in place, new section), `canonical_h.py`, `section9_h.py RECEIPT MAIN N`, `update_records_h.py RECEIPT N` (lint first), `sh repoint_h.sh RECEIPT`.
3. The scratch copy of the module goes; `board_h.py land RECEIPT N THEOREMS DECLS`; render, check, links and test; commit; merge main if it moved, render and fast-forward.

## IV3i

1. `integrate_i.py`; core checker; connectivity `--check` and `--write`.
2. `apply_text_i.py N RECEIPT`, `section9_i.py RECEIPT MAIN N`, `update_records_i.py RECEIPT N` (lint first), `sh repoint_i.sh RECEIPT`.
3. The scratch copy goes (`git rm -f` if it was rebuilt after the kit commit); `board_i.py land RECEIPT N THEOREMS DECLS`; render, check, links and test; commit; merge main if it moved (board: take main's and re-land the row, history saved and restored), render and fast-forward.

## IV3j

1. `integrate_j.py`; core checker; connectivity `--check` and `--write`.
2. `apply_text_j.py N RECEIPT` (07-SIGNIFICANCE §4.3: a row, the witnesses, the reading; D64's where and item 13; the README rows; the study), `receipts_j.py RECEIPT` (08-METHOD's receipt and counts, read from the receipt; the canonical chapter's §9 is history since RA), `update_records_j.py RECEIPT N` (caps asserted), `sh repoint_j.sh RECEIPT`.
3. The scratch copy goes; `board_j.py land RECEIPT N THEOREMS DECLS`; render, check, links and test; commit; merge main if it moved (board: take main's and re-land the row, history saved and restored), render and fast-forward; where other sessions' edits sit uncommitted in the shared checkout, apply the patch to its index and working tree for these paths only.

The first version of the two-tier law assumed no store rises (kept as `iv3j_region_steady.lean`); the law landed holds with rises.

GS1 landed first with study §390. The branch merged main, took main's generated pages, board and study, re-ran the core checker on the merged tree (receipt `20261023T201939.645046Z`, 317 modules), and `rebase_j.py OLD NEW` appended the section as §391 and moved D64 item 13 and the record to the merged receipt; then `receipts_j.py`, connectivity, `board_j.py land`, re-pointing (another session's drift on 01-ROOT.md left to its owner), render, check, links and test.

RP then landed with §391, so `renumber_j.py 391 RECEIPT` moved the section to §392 (receipt unchanged: RP changed no Lean).
