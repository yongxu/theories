# OC2 landing sequence

OC2 fixes what the independent review of OC1 found ([report](REVIEW-OC1.md)). `build_tree_oc2.py` rewrites `Becoming.GrammarPath` as OC1 landed it:
- the definition's docstring corrected;
- `«外分唯系出类之同»`, of which `«闭则外分无关»` is now a corollary;
- `«内外皆缘则二分本类常»`;
- `Inconstant.not_constant_at`, `CleanStep.not_constant_at` and `CleanStep.ends_where_net_ends`, with `not_all_follow` and `not_constant_to_end` now going through them;
- the witness `FinerWake`;
- "goes on" in OC1's own docstrings read as "conditions".

Earlier statements are unchanged. Scratch build before landing: 86 theorems in 132 declarations, empty axiom reports. `--pf` adds PF's and PF2's own uses of "goes on" in the same sense, and is passed only on the PF line owner's yes.

From the root of a worktree at main's head (board rule 5; the scripts take paths from the working directory):

1. In the shared checkout, `board_oc2.py head` marks the row at the head of the queue.
2. `integrate_oc2.py [--pf]` rewrites the module and corrects the root module's bullet, the checker's scope and the README rows (EN, ZH).
3. Run the core checker, `python3 -B check_becoming.py`, in the package folder. The receipt goes with the landing.
4. Run connectivity with `THEOREM-CONNECTIVITY.py --check`. Then run `register_oc2.py` with the roots it names (`--remove` for an entry that is no longer a root), `--check` again, and `--write`.
5. Run these in order:
   1. `texts_oc2.py RECEIPT N [--pf]` for 07 §4.6, P-20 and the study section;
   2. `receipts_j.py RECEIPT` from the IV3 kit, for 08's receipt and counts;
   3. `make_record_oc2.py RECEIPT N` for the record constancy-read-at-a-members-class, and the next step of what-leaves-a-class-follows-its-line;
   4. `sh repoint_oc2.sh RECEIPT`.
6. Run `board_oc2.py land RECEIPT N THEOREMS DECLS yes|no`. Run render, check, links and test with their logs outside the repository. Commit with no trailer, merge main if it moved, and fast-forward main in the shared checkout.

N is the study section after the last one on main; RECEIPT is the checker's run id.
