# OC1 landing sequence

OC1 rewrites `Becoming.GrammarPath` as PF2 landed it: `build_tree.py` adds constancy up to the net's end read at a member's class (`«本类至终有常»`) and the laws at the member's class. PF's and PF2's laws keep their statements, and their proofs become one-line corollaries (board rule 9). The script also adds how what lies outside is divided, the organism at its class, and the witnesses in `witnesses.lean`. `tree/` holds the scratch build (`scratch_build.py tree Becoming.GrammarPath`: 77 theorems in 118 declarations, empty axiom reports, before landing).

From the root of a worktree at main's head (board rule 5; the scripts take paths from the working directory):

1. `board_oc1.py head` in the shared checkout (the row at the head of the queue).
2. `integrate_oc1.py`: the module rewritten, the root module's bullet, the checker's scope and the README rows (EN, ZH). The result must equal `tree/Becoming/GrammarPath.lean`.
3. Core checker: `python3 -B check_becoming.py` in the package folder. The receipt goes with the landing.
4. Connectivity: `THEOREM-CONNECTIVITY.py --check`; `register_oc1.py` for the apart roots it names; `--check`, then `--write`.
5. `texts_oc1.py RECEIPT N` (07 §4.6, P-20's statement of P2, the study section, regions.json), then `receipts_j.py RECEIPT` from the IV3 kit (08's receipt and counts). Then `make_record_oc1.py RECEIPT N` (the new record; PF2's record's next step answered) and `sh repoint_oc1.sh RECEIPT`.
6. `board_oc1.py land RECEIPT N THEOREMS DECLS`. Run render, check, links and test with logs outside the repository. Commit; merge main if it moved; fast-forward main in the shared checkout. Before the fast-forward, move the shared checkout's untracked copy of this kit aside.

N is the study section after the last one on main; RECEIPT the checker's run id.
