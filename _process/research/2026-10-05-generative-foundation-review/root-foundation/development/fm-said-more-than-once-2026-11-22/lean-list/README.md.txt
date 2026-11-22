# Every theorem of the package: the head of its proof term, what it uses, and its recursors

*AI-written (Claude Fable, board row DJ), 22 November 2026, at the request of the session that holds row FM, for its sweep of inductions said more than once. Printed by Lean, not read by anyone. It finds candidates and proves nothing about two proofs being the same.*

- `AllProofHeads.lean`: the Lean file that printed it (after the atlas kit's `aaRow`). Run once, 23 s, against `.build` here: a stub importing the whole package (`Becoming/ScratchAllStub.lean`), every import restored from the shared cache at the bytes of main `125ec5a79` (no Lean changed since `0110d32a6`).
- `all-proof-heads.txt`: what Lean printed, one `ROW {json}` per theorem. `all-proof-heads.jsonl`: the same rows with two fields tidied by a script (below).
- One row per theorem declared in a module named `Becoming.*` (20,519 theorems in 407 modules), leaving out Lean's own generated theorems (names ending `eq_…`, `injEq`, `inj`, `sizeOf_spec`, matchers, internal names).

Fields: `module`; `name`; `head`, the constant at the head of the proof term after its leading lambdas and lets (null where the head is not a constant); `uses`, the package's theorems that occur in the term; `recursors`, every constant in the term whose last name is `brecOn`, `rec`, `recOn`, `binductionOn` or `fix` (in the `.jsonl`, with the `below` companions taken out); `inductions` (`.jsonl` only), the recursors other than `Eq.rec`, `HEq.rec` and `Acc.rec`, which are rewriting and accessibility and not an induction on a number, a list or a derivation.

What "occurs in the term" covers: the theorem's own value and the values of Lean's auxiliary declarations under the theorem's own name (matchers, abstracted proofs), followed to any depth. It does not follow other theorems: `uses` is one call deep.

Limits. (1) A recursor in the term shows that the proof has a recursion of its own, not what it is on or what it proves; a structural recursion Lean compiled some other way would not show. (2) `casesOn` is not listed: a case split is not counted as an induction. (3) A theorem proved by calling a private helper that carries the induction shows the helper in `uses` and no recursor; the helper has its own row. (4) Nothing here says two inductions are one.

Checked against the morning's run over 87 names (`../batch28/atlas22.lister.txt`): all 68 theorems there are here, with the same `uses`; five heads that the morning's function gave as none are given here, since this one also strips `let`.
