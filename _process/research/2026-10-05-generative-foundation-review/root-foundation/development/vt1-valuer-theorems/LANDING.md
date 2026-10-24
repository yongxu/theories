# VT1 landing sequence

From the worktree root, at the head of the queue (board rule 5):

1. Merge main into the branch (`becoming-verification.json` takes main's side; the checker rewrites it).
2. Core checker on the merged tree: `python3 -B check_becoming.py` in the package folder; commit the receipt.
3. Connectivity: `THEOREM-CONNECTIVITY.py --check` (eleven roots in `Becoming.Weightings` unregistered), `apart.py`,
   then `--check` again and `--write`.
4. Texts and records: `apply_text.py N RECEIPT`, `section9.py RECEIPT MAIN N`, `make_records.py RECEIPT N`,
   `sh repoint.sh RECEIPT`.
5. `make research-render`, `research-check`, `research-links`, `research-test`; logs into this folder.
6. `board.py land RECEIPT N`; the scratch `tree/` copy of the module goes (the module is in the package).
7. Commit the paths `git status` lists, then fast-forward main in the shared checkout.

N is the study section after the last one on main; RECEIPT the checker's run id; MAIN the main commit merged.
