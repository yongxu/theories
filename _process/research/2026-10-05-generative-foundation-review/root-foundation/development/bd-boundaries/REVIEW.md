# BD2: the independent review and its re-check

31 October 2026. Board item BD2, not going out of a region on the root ([note §6](NOTE.md#6-not-going-out-on-the-root-board-item-bd2)).

## The review

One independent AI reader (a fresh Claude Opus agent, read only, with no part in writing the kit) read the kit's diff from the board's claim (`095de350e..b51bdac3f`, branch `bd2-crossing`), the repository's rules (AGENTS.md, RESULT-WORKFLOW) and the Lean it builds on. It was asked to check five things:

1. that each new theorem states what its name, docstring and module header say;
2. that every sentence of the texts, records, README rows, root bullets and checker scope claims exactly what the cited Lean proves, with its hypotheses, and that the Chinese says what the English says;
3. the repository's rules: record caps and public fields, one sense per term, no retired labels, Ren's words as provenance only, the nondual method, the calibration rule, wrappers, names;
4. placement and coherence: the record's home, its links, the reading's flow and anchors;
5. anything a careful reader would object to.

It was given the author's description of the change to verify, not to trust, and the scratch build's figures. It did not run the checker.

## The findings and what was done

The reader found the Lean correct as written: every proof does what it claims, and the statement of `«所经必同»` is unchanged. Its twelve findings concern what the texts say of the Lean. Every one was taken.

1. **Error: the line law was read as giving more than it proves.** `«内至外之线则出»` proves only `¬ «不出» R P`; with no decision that names no member bearing the relation outside, and the name said "goes out". Taken: the law is now `«内至外之线则非不出»`. Its docstring, the module header, the record's third law in both languages, its third does_not_show item, 01 §9.9, the root module's bullet, both README rows, the checker's scope, the register's reason and the board row say that the region is not one nothing goes out of, and that no step is named.
2. **The split's hypothesis was misdescribed** as asking something only of steps from a member. Taken, in the first of the two ways offered: every text states the split the Lean takes, each step keeping to the region (its end a member wherever its start is) or going from a member to something outside. The second way, a stronger law asking only that every step from a member land decidedly inside or outside, is open in [note §6.5](NOTE.md#65-open): it is not the mark law as stated, which asks the split of every step.
3. **The excluded-middle law is a lemma of the logic, by 08's own precedent** (`World.law_iff_em`). Taken: `«不出皆闭当且仅当排中»` is no longer a law of the record, and neither 01 nor the module calls it a calibration. It is the witness of the record's first does_not_show item; the record's hypotheses say it is a lemma of the logic, the need coming from membership being any proposition; [note §6.3](NOTE.md#63-why-the-excluded-middle-law-is-a-lemma) says why; the reach-from-a-seed note is reworded; 08 gets no row. The connectivity register keeps the category `calibration`, which there means a lemma of the item that needs it, with its reason restated.
4. **"Settled" took a second sense**, beside a run that stops changing. Taken: "stable", 01's word for `¬ ¬ P → P`, everywhere, the hypotheses renamed `stable`; the Chinese texts state the condition (凡不外者皆内).
5. **The excluded-middle docstring's quantifiers read per instance.** Taken as suggested.
6. **"Along one that is not, a closed region can be come into" read as universal.** Taken: "some relation that is not symmetric has a closed region come into", in every text, and the witness states the positive form, `∃ x y, ¬ P x ∧ P y ∧ R x y`.
7. **Rule 9.** `«所闭不出»` is now proved as `«所闭之界»` applied. `Flow.Cut` keeps its definition beside `«不出»`: the board row, the module header and the root module's bullet say why (defining it as `«不出»` now adds an import to `Standpoints` and rebuilds its eighteen dependents; once `«不出»` stands in `GrammarLaws`, which the grammar's owner holds for the next near-full rebuild, it needs no import), and that `ConveyanceBoundaries` is a leaf, the World's case of the crossing laws.
8. **07 claimed what only the proof gives.** Taken: "(`«所经必同»`, proved from a step going out of the region, 01 §9.9)"; the root module's GrammarPath bullet and the line record's dependency and history note likewise.
9. **01's home paragraph left out the cut's laws, and the decided region and the class.** Taken: the cut's laws moved to 04's record (finding 10), so 01 points to them, and its pointer to `«所经必同»` reads "a line under a class leaving a decided region only into a set".
10. **Placement.** Taken: the World's cut is the seventh law of conveyance-crosses-the-boundary (home 04 §1), and the new record stays on the grammar. That record's correspondence reads "a continuing family's region is formed but no cut, so no boundary along conveyance" (1,196 of 1,200 characters). `Flow.conveyance_symm` and `Flow.cut_iff_not_come_into` are added to `ConveyanceBoundaries`, so 04 §1's crossing is exact in the glossary's sense, bearing something inside to something outside.
11. **Wording.** Taken: the record's statement as suggested (299 characters, "placed on it"); the module header ("states not going out for every carrier…", "is not outside"); `Flow.region_no_boundary`'s docstring; the checker's scope; the dependency list (`«所闭之界»` now used, `«所闭之闭»` no longer); the levels-of-closure note.
12. **The review was claimed before it happened.** The two validation scopes' sentences on the independent read are kept, true at landing once the re-check is taken; the conveyance record's now says the reader read its last two laws.

The reader's list of what it found sound noted that the Chinese `Boundaries` row also dropped the G0 and delegation clause and put 立场中立 for N_std, which the board row did not say; it now does.

## The grammar owner's notes

The grammar's owner read the module and `«所经必同»`'s new proof and had no objection. Its three notes are taken:

1. `«闭而有入»` became `«闭而有入之例»`, as the grammar names its witnesses.
2. The record says which `«不出皆闭当且仅当排中»` is: a lemma of the logic (finding 3).
3. `«所闭之界»` and `«所闭不出»` state one law twice, held for the next near-full rebuild, when `«不出»` moves into `GrammarLaws` beside `«闭»`. Note §6.5 and the study section say so, and `«所闭不出»` is now proved as `«所闭之界»` applied.

After the changes, a scratch build of `GrammarCrossing` (11 theorems in 12 declarations), `GrammarPath`, `ConveyanceBoundaries` (8 theorems), `GrammarCases` and the root module passes with no warning and every axiom report empty.

## The re-check

The same reader re-read the fixes (`35c0c24e6..78974a268`), read only, checking each claim against the files and not against this file. It found eleven of the twelve findings fully taken; the twelfth, the review claimed before it happened, is a landing condition, met once the re-check's own points are taken. It found the new Lean correct (`Flow.conveyance_symm`, the conveyance lemma on coming in, `«所闭不出»` as `«所闭之界»` applied, `«闭而有入之例»` in the positive form), the caps met with the receipt in place, no section number or status talk in public fields, the Chinese matching the English, and the board diff touching only BD2's row.

It judged the three choices put to it. Stating the split as the Lean takes it (finding 2) is acceptable, and note §6.5 describes the stronger law correctly. `Flow.Cut` keeping its definition is a sufficient reason under rule 9, as a deferral: no law is proved twice, and once `«不出»` is in `GrammarLaws` the change needs no import. The register's category is correct in its own sense, but the texts' words differed from it.

Its ten points, and what was done:

1. **Should-fix: the record's correspondence said "undecided" where it means "not stable".** Where membership is stable but undecided, `«不外者内则不出当且仅当闭»` puts what a member bears the relation to inside. Taken: "where membership is not stable" (非凡不外者皆内处).
2. **The witness did not state that its relation is not symmetric**, though the texts say "some relation that is not symmetric has a closed region come into". Taken: `«闭而有入之例»` states `¬ «则» R («逆» R)` as a third conjunct; its docstring and the record's counterexample say so.
3. **"For every region" where it means "for every relation and region"** (01 §9.9, the landed clause, the commit message): along the empty relation every region is closed, with no excluded middle. Taken.
4. **The regions note was stale.** Taken.
5. **A missing dependency.** The sixth and seventh laws of conveyance-crosses-the-boundary use `closedUnder_iff_closed` and `«缘在所闭»`, which belong to master-laws-on-the-grammar. Taken: that record is a formal-reuse dependency naming both, and the not-going-out dependency no longer names `closedUnder_iff_closed`.
6. **"The valuation's relation" where the law holds for every valuation** (04 §1, the seventh law). Taken: "a valuation's relation" (一赋值), also in the module header and the dependency's detail.
7. **The conveyance record's Chinese validation scope at 259 of 260 characters once the receipt is in.** Taken: 254.
8. **The record's fourth hypothesis was no premise.** Taken: folded into the first does_not_show item, whose witness the lemma is.
9. **The study draft listed the stable cases as decisions.** Taken: stability and decision are named apart.
10. **Nits.** Taken: `Flow.cut_iff_not_come_into` became `Flow.cut_iff_notComingIn`, pairing with `Flow.cut_iff_notGoingOut`; 01's two parentheticals are one; the record's fourth law no longer points back with "such a line".

On choice (b) it asked for two additions, made on the board row and in note §6.5. The first: the grammar's owner, which holds that rebuild, agreed to define `Flow.Cut` in `Standpoints` as `«不出»` then, on the one row it opens after RV21c. The second, what the deferral does to the master-law view, was first written as moving no figure, which the third look found false (below). On choice (c), every text now calls the excluded-middle law a lemma of `«不外者内则不出当且仅当闭»`, the law that needs it, as 08 calls `World.law_iff_em` a lemma of its law; the register keeps its category.

After these changes a scratch build of `GrammarCrossing` (11 theorems in 12 declarations), `GrammarPath`, `ConveyanceBoundaries` (8 theorems), `GrammarCases` and the root module passes with no warning and every axiom report empty.

## The third look

The same reader read the changes that take the re-check (`091f69184..1adbfce32`), read only. It found all ten points and choice (c) taken, the Lean of `«闭而有入之例»` correct (its third conjunct negates exactly the hypothesis of `«对称则不出当且仅当逆不出»`), every cap met with the receipt in place, and every changed Chinese sentence matching the English. It agreed, withdrawing its own earlier remark, that conveyance-crosses-the-boundary's second law already reaches the grammar through `Flow.region_not_a_cut`'s proof. It found two new points, both taken:

1. **Medium: "the deferral moves no master-law figure" was false.** The fifth law of conveyance-crosses-the-boundary cites `Clearing.resource_not_cut` and `Clearing.resource_not_cut_living_on`, which state that a region is no cut. The master-law view reads that law as reaching no master law, since `Flow.Cut`'s body has no «» name. Once `Flow.Cut` is `«不出»`, the law reaches the grammar through vocabulary alone. Taken: the board row, note §6.5 and the study draft say the deferral holds back that one law, and that no master law's count and no central reach moves. Checked against master-laws.json: the only other law citing a declaration that uses the cut, listing-once-is-decided-identity's fourteenth, already reaches the grammar.
2. **Low: dropping `Flow.cut_iff_notGoingOut` had no plan for what cites it**: the seventh law, 04 §1, the root module's bullet, both READMEs and the module's own proofs. Taken: it stays, still `Iff.rfl` once `Flow.Cut` is `«不出»`, as the seventh law's citation for "by definition". The grammar's owner is told.

These are texts only, with no change to the Lean or to any record.
