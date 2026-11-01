# BD4: balance on each closure, the «所闭» form

1 November 2026. Board item BD4, the second half of [WHAT-REMAINS](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md) lever 1 (a), locality on the grammar. BD3 (study §487) read Continuity's closed families on the grammar's `«不出»` and left the `«所闭»` form open, as the sixth item its record lists as not shown. OU's owner, which owns GrammarLaws and, by rule 3, Continuity, agreed to the proposal on all three questions. This session takes BD4. The laws go in BD3's leaf, not in GrammarLaws. The unit-grain law is included, as a case. Reading time: about seven minutes.

## 1. What it states

Every law is in the core leaf `Becoming.BalanceRegions`, in the namespace `Becoming.Continuity`. Nothing imports the leaf, and no other module changes. *Closure* means the grammar's `«所闭»` along adjacency among the listed relata, `«所闭» (adjacentListed rel us)`, and each docstring says so.

1. **Each closure decided.**
   - `reachedListed rel us a n` is the relata reached from `a` within `n` steps of listed adjacency.
   - `closureListed rel us a` is what is reached within as many steps as relata are listed.
   - `closureListed_iff` proves that this test holds exactly within `«所闭» (adjacentListed rel us) a`, for every relatum, listed or not.
   - The proof is a counting bound (`reachedListed_grows_or_stays`, `closureListed_closed`). For each `k`, either some step up to the `(k + 1)`-th reaches nothing new, and then no later step does (`reachedListed_stays`), or at least `k` more listed relata are reached within `k` steps than at the start. Within as many steps as relata are listed, then, every listed relatum the closure holds is reached. Counts are the grammar's `«计»`.
   - An unlisted relatum's closure is itself alone (`closureListed_unlisted`).
   - The test is built to decide, not to be evaluated: each step re-reads the step before at every listed relatum, so evaluating it grows exponentially with the listing. A version that carries the list of relata reached so far would evaluate in polynomial time with the same proof shape; nothing here needs it.
2. **The amount grain.** Over relata listed without repetition, with equality decided:
   - transfers along the relation that balance a step exist exactly where the total is conserved on the closure of each listed relatum (`balancing_iff_closures`);
   - on a web, likewise at every step (`balancesOn_iff_closures`).
   - Both rest on `conservedOn_iff_closures`, conservation on every closed family exactly where on each closure. Its converse is a decomposition, by induction on how many listed relata the family holds (`conserved_of_closures`). A closed family holding a relatum holds that relatum's closure (`closureListed_inside`, by `«闭含所闭»`), so each relatum's closure is the least family the relation closes that holds it. Among regions, that is leastness among those whose membership is a test: for a region given as a proposition, not going out gives only its double negation on the closure. What the family holds beyond the closure is closed again (`closes_and_not`) and holds fewer listed relata. The family's total splits into the two totals (`within_split`).
3. **The unit grain, the same closures.**
   - `pairing_iff_closure_counts`: for a symmetric relation `S`, with a test deciding its closure, two lists are paired one to one under `«所闭» S` exactly where every closure holds equally many entries of both.
   - Its two hypotheses are named in the law. Symmetry is what makes the closure a class (`«所闭之自反»`, `«所闭之对称»`, `«所闭之传递»`), and it is needed: a region closed one way only does not keep the count (`«对而单闭域不守数之例»`). The test is the decision.
   - It is proved as a case of `«类之对当且仅当类类等数»` (GrammarLaws). The listed form, `pairing_iff_closures`, discharges the symmetry by `adjacentListed_symm` and the decision by `closureListed_iff`. Its closures are those of every relatum, listed or not.
4. **The two grains joined** (added on the review's point 3).
   - `unitsOn q us` reads a level as units: each listed relatum repeated as often as its level. A test counts them on its family as the level's total there (`count_unitsOn`).
   - So conservation on every family the relation closes is the units before paired one to one with the units after under the closure (`closures_iff_unit_counts`, `conservedOn_iff_units_paired`). On a listed relatum's closure the counts are the totals; an unlisted relatum's closure holds no unit.
   - Relata listed without repetition, transfers along the relation that balance a step exist exactly where the units are so paired (`balancing_iff_units_paired`; on a web, `balancesOn_iff_units_paired`). This is balance along the relation read at the grain of units, as `Flow.balances_iff_units` reads balance at one condition under the one.

So the count is kept closure by closure, at both grains joined, and each relatum's closure is the least family the relation closes that holds it (`closureListed_closes`, `closureListed_self`, `closureListed_inside`). WHAT-REMAINS' "the content is which regions the count is kept on" has its answer. Amounts move by transfers along the relation, which may pass through a relatum within the step. Units are paired within a closure.

## 2. Hypotheses and modelling choices

- **Decided equality** on relata (`DecidableEq`) is a modelling hypothesis, used by the test and by Continuity's routed transfers. It is named in the record's first hypothesis and its scope. It is taken as an argument: the axiom reports cover these declarations, and an instance supplied at use carries its own report.
- **The remaining choices are Continuity's own:** finitely many listed relata, the relation as a Bool test, natural-number levels, and discrete steps.
- **Re-pairing** (OU's condition on lever 1's test). The amount-grain laws quantify over no pairing. In one direction the unit-grain laws, and the join, hold for every pairing under the closure; in the other they are existence statements. So each law is invariant under re-pairing. They read only what the counts on each closure read, so they do not meet the round trip's second test. This does not reopen U4's verdict: lever 1's round trip still fails, and this is locality, not the lift.

## 3. Known results

Conservation on each connected part is the uncapacitated, undirected case of the feasibility conditions for flows: Gale (1957) for supplies and demands, Hoffman (1960) for circulations, through the usual reduction to a circulation. Undirected, since each related pair carries transfers both ways; with one-way uncapacitated arcs Gale's condition is an inequality on the sets no arc enters, not conservation on components. What is new is only the grammar's reading. The count is kept on each `«所闭»`, and on a symmetric relation that is a class's count law.

## 4. Not shown

These items stay on the record:
- closures of a relation not confined to finitely many listed relata, already covered by the record's item on infinitely many relata;
- transfers within capacities, the capacitated case of the same conditions, a new item;
- a local choice of flux, Continuity's own boundary, as before.

The sixth item, the `«所闭»` form, is replaced, with a history note. A second new item is a non-implication with a witness: counts kept on each closure do not give a pairing along one step of the adjacency. Entries in one closure need not be adjacent, and the law pairs within a closure, not step by step. On the path 0 — 1 — 2, `[0]` and `[2]` keep every closure's count, and no step joins 0 to 2 (`PathOfThree.counts_kept_not_along_step`). The proof inverts a pairing with a single entry (`paired_single`).

## 5. Texts and record

- **Record.** balance-from-conservation-along-a-relation gets an eighth law, which refines the seventh and is not another result. The unit grain is part of it, not a ninth law. It also gets the scope sentence on decided equality, the first hypothesis's wording, Gale and Hoffman named for the uncapacitated, undirected case, and a history note. The leaf's reference lists every declaration of the leaf.
- **Home.** One sentence in 01 §8.4, after BD3's.
- **Package.** The module docstring gets four bullets, and its "What is not shown" is rewritten. Also the root module's bullet, both package README rows, regions.json's note, and the checker's scope if it names the leaf's content.
- **Register.** The connectivity register gets its new apart roots, each with its reason. The study gets a section.
- **Placement.** The counting lemmas (`cond_le_cond`, `count_le_count`, `count_lt_count`, `count_true`, `counted_of_count`, `count_append`, `count_replicate_true`, `count_replicate_false`) and `paired_single` are laws of `«计»` and `«对»` with nothing of Continuity in them. They are candidates for GrammarLaws at its next planned near-full rebuild, which is OU's owner's call; here they stay in the leaf.

## 6. Order

1. The scratch build, one at a time under the load rule.
2. One independent AI review of the Lean and the texts.
3. A kit on BD3's pattern (`kit/*_bd4`).
4. The landing, in the slot after OU7's landing, rehearsed on that head, as the coordinator orders.

When BD4 lands, OU's owner records BD3 and BD4 in WHAT-REMAINS together, as lever 1 (a)'s two halves.
