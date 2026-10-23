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
