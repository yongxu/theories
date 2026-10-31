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

Pending.
