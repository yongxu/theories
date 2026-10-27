# OC5 landing sequence

OC5 states the crux's structure as laws in `Becoming.GrammarPath`. OC4's review proved them in scratch (`review-oc4/OC4Doubts.lean`, sections B, D, D2 and E), and study §423 left them for the next rebuild. `build_tree_oc5.py` adds:
- the reach with no regularity assumed (`«后皆同类则后皆续»`, `«后皆续当且仅当后皆同类»`, `«后皆续则所缘同于»`, `«后皆续当且仅当自与线皆闭»`, `«亡而网续则后不皆续»`);
- the witnesses `OtherLeaves`, at the end of the module under its own heading, and `FiniteFamilies.member_no_reach`;
- the condition at a member's class where it acts (`«本类常当且仅当与己相随»`);
- the division outside through its own leaving effects (`«外分唯系己出之同»`).

`«本类常闭则后皆续»` and `«闭则外分无关»` are now derived from these laws (board rule 9), with their statements unchanged. `deferred_grammarpath.py` applies the comment fixes OC3 and OC4 deferred to this rebuild, and `FinerWake.finer_class`.

One independent read-only review checked every text claim against the Lean ([report](REVIEW-OC5.md), with the reviewer's scratch Lean in `review-oc5/`), and its fixes went into these scripts before landing: three of its proposed declarations (`«后皆续当且仅当自与线皆闭»`, `«亡而网续则后不皆续»`, `OtherLeaves.other_off_line`) and its optional witness (`FiniteFamilies.member_no_reach`) are among the laws above. Scratch build after the fixes: 102 theorems in 152 declarations, empty axiom reports.

From the root of the landing worktree, merged with main (board rule 5; the scripts take paths from the working directory):

1. `integrate_oc5.py` rewrites the module unless the tree already has OC5's laws, then edits the root module's bullet, the checker's scope and the README rows (EN, ZH). `texts_oc5.py` edits 07 §4.6 and P-20.
2. In the shared checkout, run `board_oc5.py head`. Then run the core checker in the package folder: `python3 -B check_becoming.py`.
3. Run connectivity: `THEOREM-CONNECTIVITY.py --check`. Then run `register_oc5.py` with the roots it names (`--remove` for an entry that is no longer a root), run `--check` again, then `--write`.
4. Append the study section and record the receipt:
   1. `texts_oc5.py --study N`, which appends the study section only (step 1 made the chapter and dossier edits).
   2. `receipts_j.py RECEIPT` from the IV3 kit, for 08's receipt and counts.
   3. `make_record_oc5.py RECEIPT N`.
   4. `sh repoint_oc5.sh RECEIPT`.
5. Run `board_oc5.py land RECEIPT N THEOREMS DECLS FINDINGS`. Run render, check, links and test, with their logs outside the repository. Commit with no trailer, merge main if it moved, and fast-forward main in the shared checkout.

N is the study section after the last one on main. RECEIPT is the checker's run id.
