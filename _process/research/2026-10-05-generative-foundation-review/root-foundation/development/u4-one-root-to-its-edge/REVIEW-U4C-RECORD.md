# Review of U4c's record and chapter texts

1 November 2026. AI-written independent review, read-only, of the record and chapter texts that U4c's landing writes ([make_u4c_records.py](u4c-stage/make_u4c_records.py) and [make_record_u4.py](make_record_u4.py) in U4c's state). The Lean design was reviewed in [REVIEW-U4C.md](REVIEW-U4C.md) and is not reviewed again here. Reading time: about twelve minutes.

## What was read and run

**Read.**
- CENSUS-ON-THE-ROOT.md: §0–§3, §5 and Appendix A.
- The full diff the two scripts produce against main: twenty-two records, 01-ROOT.md §7 and §9.5, and 08-METHOD.md §7. It was applied to a scratch copy, and every changed record was read whole as it would land.
- The Lean as it will land, in the throwaway tree:
  - GrammarLaws: the module doc and the census section;
  - Population: `Occurrences`, `across_at` and `coming_of_ceasing`;
  - Arising: `Steps.along*` and `Steps.alikeAt`;
  - Identity: `Counting`, `Continues`, `Continued` and `arisesFrom_of_more`;
  - Prelude: the moved lemmas and the three new ones;
  - Decidedness: `CountsAcross.keep_pace`, `Counts.over_stretch` and `over_stretch_decided`;
  - Listing: `CensusWebs.keep_pace`.
- `tools/research/boundary.py`: `walk`, `derived` (D1–D5) and `field_findings`.
- The EC2 notes in census-balance and laws-at-coarser-steps.
- GLOSSARY.md.

**Run.**
- `U4_U4C=1 python3 -B …/make_record_u4.py --names`: 11 derived, 1 under a stated hypothesis, 6 counting, and 22 + 32 + 18 + 16 + 7 + 2 + 3 = 100 at a distance, 118 in all.
- A script over all records, as patched:
  - each move note's list, checked against the declarations that actually moved into a Prelude reference;
  - the generalization clauses, checked against the three lemmas;
  - no moved lemma left under a non-Prelude reference in any record;
  - every law declaration held by a reference.
- The record dependency graph, before and after the change.
- Use counts of the lemmas the dependency texts name, in Identity.lean on main and as it will land.

No Lean was built, and `master_laws.py` was not run. The derived entry was walked by hand.

## What holds

- **The four statements.** 01 §7 and master law 4 state the four laws within what the Lean proves:
  - the step law's hypotheses: `Distinct after`, `«定后»`, the doubly negated arising test and the ceasing test on the units before;
  - "as far as can be refuted" is exact for both tests, because the ceasing condition is a negation, and a negation as far as can be refuted is the negation itself;
  - the mirror at `«定前»`;
  - the corollary, under HE2's hypotheses;
  - the run law with its four hypotheses and `«屡»` on both sides. The one gap is M1.
- **ceasing-needs-arising law 2** matches `Listed.coming_of_ceasing`'s re-proof: occurrences, `Steps.alikeAt`, the listing mapped, predecessors listed by the class, `Steps.along_fixed`. It no longer names `Listed.over_stretch` or `coming_iff_excess`, and the proof uses neither. World and standing go through `coming_of_ceasing_covered`; dependence goes through `Listed.coming_of_ceasing` (Population:1127).
- **census-balance-under-continuation.**
  - Law 4 matches `balanceFrom_at`: `R t`, with `E` "active at both ends"; the first half without splits and the mirror without merges; `total_mark_eq_count`.
  - "Laws 3, 6 and 9" are exactly the seven laws that go through it.
  - Law 3, the second hypotheses entry and the 01 §9.5 row state what the eight theorems now take: `[Decidable active]`, `[Decidable Continues]` and `[Decidable Continued]`. `Continues` and `Continued` read as the text says.
- **The twenty move notes are in EC2's form,** with English and Chinese saying the same. Each note's list matches the record's own moves. The generalization clause appears exactly where `mem_remove`, `length_le_of_matched` or `not_not_all` moved (identity-across-steps, laws-of-one-step, more-needs-renewers). ceasing-needs-arising's newly cited `gaining_of_losing_from` is said apart from the moves.
- **The emptied Change.lean references.** The two removed references held only `steps_last`. No law declaration in either record is in Change.lean, and neither record's text names a declaration of it.
- **08 §7's figures** (eleven, six, 100) match the generator.
- **Neither boundary entry fails a rule I could test** (below).
- **The glossary.** «生» and «亡» are "beginning" and "ending" throughout. "Arising" and "ceasing" keep HE2's census sense, and "generation" is not used for arising.

## The boundary entries

### `Listed.coming_of_ceasing`, derived

**Names.**
- Declaration: `Listed.coming_of_ceasing`.
- Law: `«定后前者在前则亡屡者生屡»`.
- Bridges: `comesToBe_iff_sheng_along` and `ceasesToBe_iff_wang_along`.
- Support: `Steps.along_fixed`, `Steps.along_hasPred_iff` and `Steps.along_hasSucc_iff`.
- The basis also cites `Steps.along`, `Steps.alikeAt` and `listedOccurrences`.

**The walk (D2).** The proof names:
- the law;
- both bridges and `Steps.along_fixed`;
- the Prelude theorems `distinct_map_on`, `mem_map_prodMk`, `prodMk_mem_map` and `not_decide_iff`, which are root theorems;
- Init's `Nat.succ.inj` and `congrArg`, which are not in the dump.

It walks through the definitions `Listed`, `Distinct`, `listedOccurrences`, `beginTest` (and its matcher), `endTest`, `Steps.along`, `Steps.alikeAt`, `ComesToBe` and `CeasesToBe`, and the grammar's `«续»`, `«合»`, `«有前»` and `«有后»`. None of their bodies names a theorem.

**The lemmas' own proofs.**
- The bridges use only `Steps.along_hasPred_iff` and `Steps.along_hasSucc_iff`, with Init.
- Those two use Init only.
- `Steps.along_fixed` uses `«定后之逐点»`, a grammar law, which will show under `laws_used_also`.

I found no theorem outside the admitted classes.

**D1 and D3.** The law is a GrammarLaws theorem stated on `«续»`, `«生»`, `«亡»` and `«屡»`, and the walk reaches it directly.

**D4.** Every declared lemma is reached: the bridges directly, and `along_hasPred_iff` and `along_hasSucc_iff` through them.

**D5.** The law's closure goes through:
- `gaining_of_losing_from`, `gaining_of_losing` and `recurring_accumulates`;
- `le_over_stretch`, which has its own induction (Prelude), not `balance_over_stretch_on`.

`Listed.over_stretch` and `coming_iff_excess` are not named.

**D6.** Both bridges are `↔` with no hypothesis.

**The basis.** It is accurate. "An occurrence's one predecessor and one successor" is a fair gloss: the two lemmas reduce having a predecessor or successor to the class at the same member one step apart. The phrase "as the connected rows were" is M5.

### `CensusWebs.keep_pace`, counting

**Names.**
- Declaration: `CensusWebs.keep_pace`.
- The basis cites `CountsAcross.keep_pace`.

**Checked against the Lean.**
- Listing.lean: `keep_pace` is `CountsAcross.keep_pace` at `fun f t => W.active t f`, on a fixed `fs` with no `Distinct`.
- Decidedness.lean: the conclusion is the two-sided `A ≤ as.length + D ∧ D ≤ as.length + A`, obtained by `Decidable.of_not_not`.
- Its route is `Counts.over_stretch`, then `over_stretch_decided`, then `balance_over_stretch_on`.

Every clause of the new basis is true. "A proof off the balance anchor" would follow from a re-proof through the summed halves, so the clause is redundant, but it is not wrong.

## Findings

### Blocking

None.

### Should fix

#### S1. master-laws' first hypothesis becomes false of the four new laws

- **Where.**
  - master-laws-on-the-grammar, hypotheses[0]: "Each global form takes a fixed successor … as a corollary of a local form that asks it only where the proof uses it".
  - GrammarLaws' module doc says the same ("where a global form uses more … it is a corollary of a local one stated beside it").
- **What is wrong.**
  - `«定后则后并亡不过前并生»`, its mirror, the corollary and the run law take `«定后»` or `«定前»` globally.
  - Their proofs use only no split (or no merge) among the listed units.
  - No local form is stated. The step law's docstring says so, and CENSUS-ON-THE-ROOT §2 and §7 leave it open.
  - HE2's census meets the rule, through `census_pairs`. The new laws do not.
- **Fix.** Either state the local forms (`census_pairs`'s form; the review re-check, R9, judged the proof unchanged), or qualify the hypothesis in both languages. For example: "…; the counted census laws take the fixed successor (predecessor) globally though their proofs use it only among the listed units, a local form being left open."

#### S2. census-balance still states the old routes

- **Where.** census-balance:
  - law 1, ": the members kept across the step are counted alike on both lists", which declares `marks_le_of_sub`;
  - law 5, "The census law and the bounded law follow from it";
  - the related note on ceasing-needs-arising, "The census law follows from this balance (P30)".
- **What is wrong.**
  - On main, `across_at` was proved through `keeps_at`, which uses `marks_le_of_sub`. It now goes through the two halves, and law 8's new related note says so.
  - ceasing-needs-arising's rewritten note says the census law *followed* from the balance "until U4c". Census-balance still says it follows, in the present tense.
  - Read as proof routes, as R3 read the other two records' route laws, these are now false.
- **Fix.**
  - In law 1, write "…came to be (`Listed.across`, a case of the root's census of a step, law 8); the members kept across the step are counted alike on both lists (`Listed.keeps`)". Declare `Listed.keeps` in place of, or beside, `marks_le_of_sub`.
  - In law 5 and the related note, write "the bounded law follows from it; the census law did until U4c and still follows from it by content".
  - Add both to the history note.

#### S3. census-balance-under-continuation's dependency text names lemmas the record no longer uses

- **Where.** The census-balance dependency's detail: "Reuses counting by marks (`marks_le_of_sub`, `mark_add_not`, `total_congr_on`)".
- **What is wrong.**
  - In Identity.lean, `mark_add_not` and `total_congr_on` go from 2 uses on main to 0.
  - `marks_le_of_sub` is used by none of the record's theorems.
  - The counting by marks is now `total_mark_eq_count`.
  - The Population and Flow references still declare `mark_add_not`, `marks_le_of_sub`, `mark_le_total`, `total_le_mark`, `total_swap` and `total_le`, which nothing in the record uses now.
- **Fix.**
  - Rewrite the detail in both languages: "Reuses counting by marks (`total_mark_eq_count`) and the stretch form of the balance as inequalities (`le_over_stretch`, `ge_over_stretch`)".
  - Optionally prune the dead declarations.
  - Name both changes in the history note.

#### S4. Design and review provenance is missing or misattributed

- **Where.**
  1. master-laws-on-the-grammar gains four laws, but no reference to CENSUS-ON-THE-ROOT.md or REVIEW-U4C.md. Its new validation scope says "Read-only AI reviews of each item", and every earlier item's review is a reference of role review.
  2. The same scope's reason, in Appendix A and in the note ("leaves the list of changed statements and each item's reviews to these notes"), is not true. The notes of OU3c–OU3f and HE name no reviews: the references carry them.
  3. The edge record's note says the design was "reviewed in REVIEW-U4C-RECORD.md". The design and its Lean were reviewed in REVIEW-U4C.md, which is not among the edge record's references.
  4. The U4c note in master-laws says "its review: one, with a second pass". With this review there are two.
- **Fix.**
  - Add CENSUS-ON-THE-ROOT.md (integration) and REVIEW-U4C.md and REVIEW-U4C-RECORD.md (review) to master-laws' references, and REVIEW-U4C.md to the edge record's.
  - Write "(CENSUS-ON-THE-ROOT.md, reviewed in REVIEW-U4C.md, its record texts in REVIEW-U4C-RECORD.md)".
  - Say "to these notes and the references".
  - Count two reviews, one with a second pass.
  - Optionally name U4c's core receipt in the validation scopes of ceasing-needs-arising and census-balance-under-continuation once the re-point pass binds it, since their rewritten laws rest on it.

#### S5. The reason for "related, not dependencies" is wrong for one record

- **Where.** Appendix A: "master-laws-on-the-grammar lists … census-balance among them, so a dependency back would close a cycle".
- **What is found** (the dependency graph as patched):
  - **census-balance:** true, directly.
  - **ceasing-needs-arising:** true, but not through census-balance, from which it no longer depends. The path is master-laws → least-loss-rest → continued-change-needs-openness → ceasing-needs-arising.
  - **census-balance-under-continuation:** false. master-laws does not reach it, and no record depends on it.
- **Why it matters.** Law 4 is proved through master-laws' two halves. That is formal reuse, and it is admissible as a dependency here.
- **Fix.**
  - Make master-laws-on-the-grammar a `formal-reuse` dependency of census-balance-under-continuation, with an interface:
    - output: the two halves;
    - input: `balanceFrom_at`;
    - conditions: the tests, and no split or no merge at the step.
  - Or keep it under related and give the true reason (uniformity).
  - Either way, correct Appendix A's path.

### Minor

#### M1. The run law, "from some step on"

- **Where.** 01 §7 and master law 4.
- **What is wrong.** Both state the run law's hypotheses at every step. The Lean takes them from `T` on (all but `«定后»`). The text is weaker than the theorem, not wrong.
- **Fix.** Add "from some step on".

#### M2. ceasing-needs-arising law 2 and its note

- **The readings.** "The listing and dependence readings go through it" leaves out the census reading of law 3, which also goes through `Listed.coming_of_ceasing`. Write "The listing, census and dependence readings…".
- **The Chinese.** "它不是本律的情形" can read 本律 as the record's own law. Write "它不是根上一程之清点的情形", and "经过该律" for the first 本律.
- **The note.** It says `gaining_of_losing_from` is something "which law 2 now names". Law 2 declares it; its text does not name it. Write "declares".

#### M3. 01 §7's Theorem (root) sentence

- **Where.** "each model's law is proved from the grammar's in its own module, keeping its name and statement".
- **What is wrong.** `balanceFrom_at` and the seven laws through it lose one instance argument.
- **Fix.** Add "or a more general statement".

#### M4. "keep_pace's stretch form on positions"

- **Where.** The edge record's `next_delta` and its note, in both languages.
- **What is wrong.** `keep_pace` is already a stretch law. What is next is the census's stretch form on positions.
- **Fix.** Write "a stretch form of the census on positions, of which `CensusWebs.keep_pace` would be a case".

#### M5. "as the connected rows were"

- **Where.** The edge entry's basis and its note.
- **What is wrong.** "Connected" is also a distance label: 22 rows stand at connected without being derived.
- **Fix.** Write "as the eight connected rows taken as derived were".

#### M6. "decided activity and continuation"

- **Where.** census-balance-under-continuation, the identity-across-steps dependency's interface conditions.
- **What is wrong.** Now that law 3 and the hypotheses disclaim a decided continuation, this reads against them. `arisesFrom_of_more` takes decided `Continues`.
- **Fix.** Write "decided activity, and decided continuing of an active formation".

#### M7. master-laws law 3 and hypotheses[2]

- **Law 3.** "the census of a step and the count laws need" should read "the census of a step, of a run, and the count laws need".
- **Hypotheses[2].** It names the continuation as a test but not the counted census's tests of beginnings and endings, on which the four new laws depend. Add them.

#### M8. Process texts outside the diff

- **Where.** WHAT-REMAINS:343 ("The two census rows … are a candidate item of their own") and the board's U4c row.
- **What is wrong.** Both go stale at landing.
- **Fix.** Update them with the landing. No chapter text outside the diff says the census law goes through the balance or that the census rows are counting, apart from S2. 01 §9.5's framing of ceasing-needs-arising as a case of counting's one law still holds by content.

## Verdict

The record and chapter texts say what the Lean proves. The derived entry for `Listed.coming_of_ceasing` meets D1–D6 by a hand walk, with complete `bridges` and `support`. `CensusWebs.keep_pace`'s basis is accurate. The move notes are exact.

Before landing, take S1–S5:
- **S1:** a record hypothesis, also stated in the module doc, that the new laws make false;
- **S2:** two route statements and a declaration in census-balance that the re-proof outdates;
- **S3:** a dependency text naming lemmas no longer used;
- **S4:** the missing design and review references, and the misattributed review;
- **S5:** the cycle reason, false for one record.

M1–M8 are small. With S1–S5 taken, the texts are ready. This review should then be re-read against the regenerated diff only where S1–S5 changed it.

## Second pass, 1 November

AI-written second look, read-only, at what S1–S5 and M1–M8 changed and at the new Lean. Reading time: about eight minutes.

### What was read and run

**Read.**
- `u4c-recheck/grammarlaws-local.diff`, the census section and the header of the staged GrammarLaws.lean (`wt-u4c-stage`).
- `records-v2.diff` and `scripts-v2.diff`.
- The records as they land in `wt-u4c-cut2` (main a91c84d35 with the stage), compared field by field with the first pass's records.
- CENSUS-ON-THE-ROOT.md §2, §7 and §9.

**Run.**
- **Grammar, GrammarMap, Prelude and the staged GrammarLaws, compiled with Lean 4.29.1** in a scratch directory.
  - No error and no warning; 191 `theorem` declarations in the source.
  - `#print axioms` is empty for the four local forms and the four laws.
  - The four laws' statements are text-identical to the first pass's, compared by a hash of the normalized statements.
  - No "HE2" is left in GrammarLaws.
- **A witness, which compiles.** Under a continuation where `0` continues as `1` and as `2`, `«定后»` fails, yet `GrammarLaws.census_le` applies with `[0]` before and `[1]` after. So the local forms are strictly more general.
- **A cycle check** (Tarjan) over all 517 records in `wt-u4c-cut2`.
- **Use counts** in the staged Identity.lean.
- **`make_record_u4.py`** run with `--names` and `--home` on `wt-u4c-cut2`, both as staged and three-way-merged onto main's copy.
- **Second-pass sections**, counted in the fifteen reviews that master-laws references.

### What holds

- **Question 1: the local forms.**
  - Each hypothesis is used, and only at the memberships the proof has.
    - `census_le`'s matching relation carries `x ∈ keep (!e) before`, which gives `x ∈ before`. The `keep (!b) after` lists give `y ∈ after` and `y' ∈ after`.
    - `census_le_converse` is `census_le` at the converse, so its no-merge hypothesis is the converse's no-split.
    - `census_count` asks exactly `census_pairs`' hypotheses, in its order: the unit binders, then the memberships, then the two continuations.
    - `census_run` asks no split only from `T` on, and only between `u t` and `u (t + 1)`.
  - A further weakening, to units the tests leave unmarked, would depend on the tests. It is not worth taking.
  - `census_run` takes `noSplit` second, as `census_le` does. The global law keeps its statement, with `fixedAfter` third, and its corollary passes it explicitly, so the difference in order is harmless.
  - The four laws discharge the local hypotheses through `«定后之逐点»` and `«定前之逐点»`, and they build.
  - master-laws' first hypothesis and the module doc's rule are now true of the census.
- **Question 2 (S5).** On `wt-u4c-cut2` there is no dependency cycle. master-laws-on-the-grammar does not reach census-balance-under-continuation, and no record depends on it. The new dependency's interface has its output, input, conditions and evidence.
- **Question 3 (S3).**
  - The six pruned declarations have zero uses in the staged Identity.lean, and none is named by a law or text of the record. Every law declaration is still held by a reference.
  - Identity uses `total_mark_eq_count` (two uses), `gaining_of_losing_from` and `losing_of_gaining_from`.
  - Those two reach `le_over_stretch` and `ge_over_stretch` through `gaining_of_losing` and `losing_of_gaining` (Prelude). So the detail is true.
- **S2.**
  - `Listed.keeps` states a common `k` for the members kept, as law 1 says.
  - The bounded law still goes through the balance: `ceasing_of_returning` goes through `ceasing_iff_shortfall`.
  - "Still follows from it" rests on the pre-U4c proof, whose premises and conclusion are unchanged.
- **S4.** The scope is 598 characters in English and 240 in Chinese, within its caps. The design and both U4c reviews are references, and the edge note attributes each review.
- **M1–M8** are taken as §9 says, each checked in the landed text. ceasing-needs-arising's law 2 agrees in both languages.
- **Question 5.** These texts are accurate:
  - 01 §7's root-theorem sentence ("its statement or a more general one");
  - the WHAT-REMAINS line;
  - the edge record's next step and note, in both languages.
- **08 §7's figures** (117 distinct, eleven derived, six counting, 99 at a distance) are right for main with U4c.

### Findings

#### Blocking

**B1. The staged `make_record_u4.py` reverts DU's two changes to the generator.**

- **What is found.**
  - `wt-u4c-cut2` stages a copy built on the pre-DU file (f61530cea).
  - Against a91c84d35 it deletes DU's `central` filter in `counts()`, main's lines 321–327, which drops `Web.paths_comparison_widens`.
  - It also restores the old premises sentence in `home()`, main's lines 370–380.
- **The effect, as run.**
  - The staged generator counts own carrier 7, so 118 distinct and 100 at a distance.
  - Its `--home` writes "Each of the 118", "The other 100" and "with no such theorem".
  - 08 §7 in the stage is right only because `make_u4c_records.py` edits main's paragraph and asserts only the derived and counting counts.
  - The next run of the generator would undo DU's landed text.
- **Fix.**
  - Take the three-way merge (base f61530cea, main a91c84d35, the stage). It is clean.
  - With it, `--names` gives 11/1/6/22/32/18/16/6/2/3, which is 117, and `--home` equals the stage's 08 §7 paragraph byte for byte.
  - Before landing, compare every shared file the stage changes against main with `git diff --stat`, and read each deletion. I found none in the other shared files.

#### Should fix

**S6. "Read-only AI reviews of each item, in the references" is not true of WRP2.**

- **What is found.**
  - WRP2 (29 October, study section 447) is an item of master-laws-on-the-grammar: it changed the laws of n steps with «历».
  - Its review, `process-representation/REVIEW-WRP2.md`, is referenced only by processes-represented-both-ways.
  - ND, which only renamed, has no law to review.
- **Fix.** Add REVIEW-WRP2.md as a review reference, and count its "After the changes" section if it is a second pass. Or write "of each item but WRP2".

**S7. The second-pass count, and this file's hash.**

- **What is found.**
  - Among the references, second passes stand in REVIEW-OU3d, REVIEW-CLOSURE and REVIEW-LINEAGE, plus REVIEW-U4C's re-check: four.
  - With this section, REVIEW-U4C-RECORD.md has one too: five.
- **Fix.**
  - Write "five" in the scope; the length is unchanged.
  - Write "(REVIEW-U4C.md and REVIEW-U4C-RECORD.md, each with a second pass)" in master-laws' note, in both languages, and in any count S6 adds.
  - Rerun the record script after this append. The bound hash of this file (075c7bc1…) is now stale in master-laws and in the edge record.
  - The records bind the design copy in `wt-u4c-cut2` (0f529a76…). The copy in `wt-u4c` differs at lines 186 and 188. Land the one that is bound.

**S8. The local-forms sentence says of the four laws what is true of their local forms.**

- **Where.**
  - 01 §7: "Each of the four asks the fixed successor or predecessor only among the listed units, in a local form beside it".
  - Master law 4: "Each asks …".
  - Master law 4 in Chinese: "每一律只在所列单位之中要求定后或定前，其局部之形在旁".
- **What is wrong.** The four laws take `«定后»` or `«定前»` everywhere. The Chinese, especially, states the restriction of the law itself.
- **Fix.** Use the header's and the master-laws note's wording.
  - English: "Each is the corollary of a local form beside it that asks no split (no merge) only among the listed units (…)".
  - Chinese: "各为其旁一局部之形之推论，后者只在所列单位之中要求无分裂（无合并）".

#### Minor

- **M9. HE2 in the master-laws note.** The English note still says "the count of HE2's census"; the Chinese says 成对清点. Write "the paired census", as the docstrings do.
- **M10. "Ending" and "beginning" in the header.** GrammarLaws' "The census, counted" bullet says "the units after with those ending are at most the units before with those beginning". The tests mark ceasing and arising, which need not be `«亡»` and `«生»`. Write "with those a test marks as ceasing … as arising", as 01 §7 does.
- **M11. Who declares the reused lemmas.** In census-balance-under-continuation's dependency on census-balance, `total_mark_eq_count`, `le_over_stretch` and `ge_over_stretch` are declared by this record, not by census-balance. That record declares `balance_over_stretch`, `mark` and `Listed.keeps`. The detail is true. Optionally:
  - add "through `gaining_of_losing_from` and `losing_of_gaining_from`";
  - have census-balance declare `total_mark_eq_count`, which its `across_at` uses.

### Verdict

The local forms are right: minimal, ordered as `census_pairs` is, strictly more general, and built with empty axiom reports, and the four laws are their corollaries with unchanged statements. S1–S5 and M1–M8 are taken as §9 says.

One new blocker, B1: the staged generator would revert DU's generator changes. The merged generator fixes it, and was checked against 08 §7. S6–S8 are small text fixes, and M9–M11 are wording.
