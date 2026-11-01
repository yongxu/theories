# ND part 2: how the stage was made

Reading time: two minutes.

ND's second part is the stage `20-nd` in OU7's kit ([its files](../../ou7-conditional-laws/kit/stages/20-nd/)). It was cut in a throwaway tree: ou5-design after the kit's `prepare` and `apply`, with U4c's stage `10-u4c` in place (from branch `u4c`, its folder `u4-one-root-to-its-edge/u4c-stage/10-u4c/`). Each patch is that tree's `git diff` for one file.

The scripts, in the order they ran, each taking the tree as its argument:

1. `nd_rename.py`: the core's names in `Becoming/*.lean`, the binders that go with them, and the backticked names and "obeys" in comments. HeldForReading is left out, because there a system obeys a stop. After it ran, Ren's words quoted in Parting and Situations were restored by hand, ReadingLoop's prose was rewritten by hand, and so were RegimeMargin's three headings, the "master law" docstrings (GrammarLaws, Amounts, ModelStatements, the root module) and the root module's two "obey"s. The witness predicate `PairwiseShared.good` was then renamed `leads` rather than `avoids`, so that the token `good` has one new name across the stage, as the kit's rename rule needs.
2. `nd_docs.py`: the live texts and the seven records that name the renamed declarations. A record's history is kept as it was, and each record gets one note, its date and study section left as `{DAY}`, `{DAY_ZH}` and `{N}`. Names written in single quotes escaped its pattern, so the decidability inventory's script was fixed by hand. The record `a-reading-kept-by-its-update`'s laws 2 to 6 and its counterexample, and 03's sentence on acts pairwise, were rewritten by hand in the new words.
3. `nd_obey.py`: the records whose fields said a case obeys a law, which their home sections stopped saying in part 1. Their en "obeys" becomes "satisfies", and the same field's zh 服从 becomes 满足.
4. `nd_expect.py`: sorts each changed module's declarations, with the kit's `statements()`, into renamed and restated. EXPECTED.json keeps `added`, `renamed` and `binders`; the kit's rule recognises a statement changed only by them.

Checks: the audit with HEAD at the commit before `apply`; a scratch build of the changed modules' closure (149 modules, nothing unclean, every axiom report empty), and ReadingLoop rebuilt after the witness rename; the kit's dry run, and its stage check on a tree after `apply` alone.

The audit passes only with one change to the kit's rename rule, proposed to the kit's owner in [proposed-kit-field-notation.patch](proposed-kit-field-notation.patch). The rule's pattern refuses a name right after a dot, so names reached through field notation (`w.CountsObey`, `(0).CountsObey`, `w.StandsObey`) are left unmapped. The change lets a name follow a dot whose left side is a term. It can only make the check stricter.
