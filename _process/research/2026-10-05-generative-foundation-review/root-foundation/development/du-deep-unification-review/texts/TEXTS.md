# DU's texts, drafted for their owners

AI-written drafts, 31 October 2026, on main `852985f8a`. They change nothing until the owner of each file reads its diff and applies it at DU's landing. Every figure here is read from the generated data at the landing, not copied from this draft.

## (a) 08 §7: the two figures, labelled (OU's owner)

Both figures are right; the labels are wrong. "45 of 127" counts rows: a declaration that stands in two rows is counted twice. OU3f's landing (`be5d6f241`) gave both: "45 of 127; of the 118 distinct 44". The paragraph calls the 127 "central declarations", but they are rows, and nine declarations stand in two of them.

Edits in the paragraph that opens "The column *On the grammar*":
- "Of 127 central declarations, 88 rest on at least one" becomes "Of the 127 central rows (nine declarations stand in two), 88 rest on at least one".
- "Of the 127, 45 now reach the grammar" becomes "Of the 127 rows, 45 now reach the grammar", with the figure recomputed by `measure_grammar.py` per row at the landing.

Edits in **Standings on the edge**, after the leaf lands, replacing "and C (`Comparison`) for order, with no such theorem. Neither stands on the edge: the condition's not-entailed theorem concerns its free form, which chapter 7 keeps off the root, and its root form at the own-closure reading, `«续无外»`, has none; C has neither.":

> and C (`Comparison`) for order, which no statement reading no order entails, on any frame with an extension (`ReadsNoOrder.not_entails`, immediate, since "better" is free). Neither stands on the edge. The condition's not-entailed theorem concerns its free form, which chapter 7 keeps off the root. Its root form at the own-closure reading, `«续无外»`, varies with the net: the endless line of descent meets it, and two family lines with no condition between them fail it (`«续无外随网»`, and `«族无外随网»` in families), so no law that holds of every net settles it.

The lead order stays as it is (OU's owner declined the move). "Standings on the edge" is the home section of `one-root-to-its-edge`, and the connectivity paragraph is that of `master-laws-on-the-grammar`; moving either would re-hash every record that cites it, for no gain in content. The edits above stand alone.

The landing also reruns `master_laws.py` after COVERAGE's change (b) and fills the new F5 figures here and in (c)'s section.

## (b) COVERAGE.json (OU's owner)

- Significance row: `Becoming.Web.paths_comparison_widens` leaves `declarations`. Reason, added to the row's note: "an unfolding of C with better read as widening (Extension.lean, `paths_comparison_widens`); kept as C's meets witness, a trivial model (consistency only)".
- Premise "C, the widening comparison": its witnesses add `Becoming.ReadsNoOrder.not_entails`. Its note adds: "no statement reading no order, and holding at a datum with an extension, entails it (immediate: better is free)". Its existing witnesses stand (`Web.paths_comparison_widens`, relabelled trivial; `Regimes.no_comparison_through_marginals`).
- Premise "finite": its witnesses become `Becoming.World.strained_finite` (meets) and `Becoming.World.throughput_world` (fails: its last conjunct, `¬ throughput.Finite`), both on main already, and its note drops "not listed here" (added 31 October, on Ren's "close all gaps": the card's last premise listed without witnesses besides L).
- Premise "L, lifting": its witnesses become `Becoming.LiftModel.met_and_failed` and `Becoming.LiftModel.some_outcome_does_not_lift`, and its note becomes "met and failed on `LiftModel`'s frame (the move reaching 3 lifted above the move reaching 1, not the reverse); the choice of the rule is substantive (a response with a better and a worse outcome is comparable by neither direction)".

## (c) WHAT-REMAINS: a new section (OU's owner applies it)

```markdown
## The unit grain is balance, not atomism (DU, 31 October 2026)

One-to-one continuation of units is balance at the unit grain, not atomism. Balance holds exactly where some selection of one-to-one unit matchings exists at every frame (U1b's record `amounts-by-unit-matchings`: `FrameMatchings` and balance, `Becoming.UnitMatchings`). The matchings represent balance and do not derive it. Atomism is integrality, the modelling choice of natural-number amounts, which makes a positive loss at least one unit. The matchings presuppose it, since they match the units of such amounts, but it does not give them: the world `World.unbalanced` has natural-number amounts and fails balance while meeting every other premise (`World.unbalanced_but`, part of `World.independent`). So one-to-one continuation adds balance to integrality and is not integrality itself. U4's design (§0, *The verdict (reviewed)*, the sentence calling one-to-one continuation "U1's atomism") and the line in the section *U4's levers 1 and 2, reviewed (30 October 2026)* above conflate the two. Both stay as written, since they are cited; this section is the correction. Nothing in a record or a figure changes.
```

## (d) 04: Bases and Open (OU's owner; the rows' records unchanged)

Standings read from the boundary record `one-root-to-its-edge` on `852985f8a` (taken by OU's owner): 1 under a stated hypothesis, 3 counting, 1 at a represented model, **5** with balance in the statement and **8** at amounts. The split "6 and 7" in the review's attack and in OU's owner's note does not match the record, which places `Flow.no_new_dependence`, `Reproduction.Flow.lineage_ends`, `Reproduction.Flow.closed_lineage_lowered`, `GroupEnding.Flow.family_childless` and `GroupEnding.Flow.coupled_end_together` with balance in the statement, and the other eight at amounts. The figures are checked against the record again at the landing.

§Bases: replace ``None is yet lifted onto the grammar; only the law of passing is read on it, in part ([below](#r-a-pattern-lasts-through-passing)).`` with:

```markdown
Of the chapter's 18 central declarations, the [boundary record](../results/records/one-root-to-its-edge.md) places:
- one on the root under a stated hypothesis: `GroupEnding.Flow.all_end`, as `RootForms.outside_leaves_no_offspring`, each hypothesis needed;
- three as counting, below the grammar: Price's covariance, the levels partition and the drift bound;
- one at a represented model: `Web.transmits_at_iff`;
- five with balance in their statements;
- eight at amounts.

The law of passing is read on the grammar, in part ([below](#r-a-pattern-lasts-through-passing)). None of the 18 is proved from the root's laws alone. Each is proved from the World premises it takes as hypotheses (balance, only active relata give, activity needing support, dissipation, bounded transmission, in 08's premise card's wording), and no one of those premises follows from the others (`World.independent`, `World.none_follows`).
```

Open: replace ``Lifting these laws onto the grammar ([08](08-METHOD.md)).`` with:

```markdown
Moving a row past its standing in the boundary record: a row at amounts or with balance in its statement moves only through a root form whose hypotheses its model meets by definitions alone, as `GroupEnding.Flow.all_end` does ([08 §7](08-METHOD.md#r-one-root-to-its-edge)). The World premises stay hypotheses.
```

## Also touched by the leaf (the record's owner)

If the record's text changes, its home section in 08 §7 changes with it; edit (a) already covers that.

The boundary record `one-root-to-its-edge` says, for order: "no theorem shows it unentailed by the dynamics". Once the leaf lands, `ReadsNoOrder.not_entails` is that theorem for frames (immediate). Whether `boundary.py`'s Q1 computes it as such (a theorem whose type names `Comparison`), or the record's premise entry needs a reading, is checked at the rehearsal.

## Order with U4b (agreed with U4's owner, 31 October 2026)

U4b (claimed `753460b81`) moves `SelectionLevels.rises_exact_iff_levels` from amounts to counting. It is expected to land first.
- In 08 §7 it changes only the edge paragraph's three count phrases. DU's edits there are the labels in the connectivity paragraph and the C / `«续无外»` sentence, so the two do not collide.
- DU's landing edits `home()` in `development/u4-one-root-to-its-edge/make_record_u4.py` to carry the C / `«续无外»` sentence, so that the generator keeps matching 08. The sentence names declarations that exist only once the leaf lands.
- At DU's landing, 04's figures are read from the record as it then stands. After U4b they are 1 / 4 / 1 / 5 / 7.

U4b's final wording, from U4's owner on 1 November 2026 (kit `development/u4-one-root-to-its-edge/COUNTING-AND-AMOUNTS.md` on branch `u4b` at `79a6d4edb`). Its review, re-check and third look are taken, and it waits for a documents slot.
- **The line.** Counting and amounts are separated by what a statement says of the dynamics. A law of counting says nothing of them beyond a counting law's arbitrary predicate. Amounts is the distance for a statement that uses the dynamics and constrains numbers the grammar has no terms for, an arbitrary trait's values included.
- **Rows 7, 8 and 14 stay at amounts,** with rewritten bases. Their hypotheses on the trait's values keep them off standing 2: `top` and `inactive` tie the trait to the dynamics.
- **Record:** 7 counting, 18 amounts, 100 at a distance, 0 unplaced.
- **Evolution's 18 rows:** 1 under a stated hypothesis, 4 counting, 1 at a represented model, 5 with balance, 7 at amounts (rows 1–3, 7, 8, 14 and `Reproduction.Flow.number_within_take`). These are the figures for (d).
- **`home()` is untouched by U4b.** U4b replaces three figures in 08 §7's paragraph by targeted replacement, so DU's sentence lands before or after it.

## Overlap with SJ (asked by SJ's owner, 1 November 2026; answer, held while messages were paused)

SJ's design is on branch `sj-claim` at `134f92a08`. It maps the edge by input and proposes SJ1, a leaf of judgement from a reading.
- **Lean.** `Becoming.PremiseWitnesses` and `Becoming.UnreadStandings` state nothing SJ1 restates. SJ1 is about readings and requirements (`Licensed`, judgement through `E`), and DU's leaves are about premise standings, self-concern against C, and amounts not read off the root. They do not overlap.
- **The map's rows should cite DU's new declarations once DU lands.**
  - "Value": `ReadsNoOrder.not_entails` (C not entailed), `LiftModel.met_and_failed` (L met and failed), and `Web.extension_ranked_of_increasingInOwn` (where the de se condition holds and admission is decided, every self-concerned order ranks an extension between two level paths whose admissions are listed; one way only, and only for courses whose admissions end, `Web.admits_nothing_from_of_listed`). The earlier `Web.comparison_of_increasingInOwn` is withdrawn: its hypothesis cannot hold once there is a formation (`Web.not_listsAdmitted_every`), so it was vacuous (REVIEW-LEAF-2, third look).
  - "Chance and amounts": `World.standing_not_read` (for k > 1, no reading of the occurrence model's selected relations returns a positive standing both in a world and in it counted in a unit k times finer) and `World.standing_not_read_up_to_unit` (no single reading gives every world's standings up to a positive ratio; the refuting worlds are still worlds, and worlds with exchange are open). The relations are WorldRepresentation's stated selection with falling and the order of standings, which read amounts only through sign, comparison in one unit and conservation's equation, not the root.
  - "Which relation": `«续无外随网»` and `«逆缘续无外随网»` (the condition's root form varies with the net and the direction).
- **The hunks DU edits:**
  - 08 §7: the connectivity paragraph's labels; the edge paragraph's C / `«续无外»` sentence (through `make_record_u4.py`'s `home()`); and a new home section, `premises-met-and-failed`, placed after "Standings on the edge". If SJ's map also goes there, it goes after DU's section, or OU's owner orders the two.
  - 07: one new home section, `self-concern-and-c-under-the-condition`, at scope and order.
  - 01 §8.6: one new home section, `standings-not-read-off-the-occurrence-model`, after `amounts-by-unit-matchings`.
  - 04: Bases and Open.
  - DU does not edit 08 §5 or 01 §7.

## (e) The front pages: the condition is a statement on the root, not a law (OU's owner; from ND's cold read, 1 November 2026)

ONE-PAGE line 35, the overview's lines 115 and 164, and the same three lines of both Chinese editions say that the condition held de se "is a law of the root". It is not. A law of the root holds for every net, class and centers. Held de se, `«续无外»` is a statement on the root, true or false once those are given, and DU's leaf proves it is both (`«续无外随网»`: the endless line of descent meets it, two family lines with no condition between them fail it). 07 §4.5 already says it rightly ("on the root it is `«续无外»`"), so only the front pages change. Each replacement keeps the sentence's link and its second half.

- **ONE-PAGE.md, line 35 (OU's owner's word, 1 November):** "the condition is a law of the root: nothing lies outside every center's line under the one of that relation (`«续无外»`), and along a net" becomes "the condition is a statement on the root, met by some nets and failed by others: nothing lies outside every center's line under the one of that relation (`«续无外»`); along a net".
- **ONE-PAGE.md, line 23 (OU's owner's word, from ND's cold read; the same change, so the page changes once):** "the *continuation condition*, that for anything, its continuation has significance." becomes "the *continuation condition*, that from every standpoint, for anything, its continuation into the future has significance." This is 07 §3's definition and ND's glossary row word for word. Without "from every standpoint" the short form reads as intrinsic value. If ND's glossary row lands first, line 23 matches the row as it then stands on main.
- **THE-THEORY-OF-BECOMING.md, line 115:** "it holds exactly where every center's closure along that relation is the whole, and so is a law of the root: nothing lies outside every center's line under the one of that relation (`«续无外»`)." becomes `` it holds exactly where every center's closure along that relation is the whole, and is a statement on the root: nothing lies outside every center's line under the one of that relation (`«续无外»`). It is true or false once the net, its class and the centers are given, and some nets meet it while others fail it ([premises met and failed](chapters/08-METHOD.md#r-premises-met-and-failed)). ``
- **THE-THEORY-OF-BECOMING.md, line 164:** "Held de se along a relation, the condition is a law of the root:" becomes "Held de se along a relation, the condition is a statement on the root, met by some nets and failed by others:".
- **ONE-PAGE.zh.md, line 35 (OU's owner's word):** "延续条件就是根的一条律：" becomes "延续条件是根上的一个陈述，有的网满足它，有的不满足：". The rest of the line is unchanged.
- **ONE-PAGE.zh.md, line 23 (OU's owner's word):** "*延续条件*，即对任何东西，其延续都有意义。" becomes "*延续条件*，即从每一个立场看，对任何东西，其延续到未来都有意义。"
- **Reading time, checked on main `3d1528b36` with the edits applied to copies:** the English page grows by 13 words. On READING-BUDGETS' basis of 1,102 words, that gives 1,115 words, 8.6 to 11.2 minutes at 100 to 130 words a minute. The Chinese page grows from 1,858 to 1,880 characters, 7.6 to 9.9 minutes. "About ten minutes" holds on both pages. The English page now runs 15 words over the 1,100-word budget, which it already exceeded by 2. Recount at the landing.
- **THE-THEORY-OF-BECOMING.zh.md, line 115:** the clause "就是根的一条律" (or its wording there, read at the landing) becomes "是根上的一个陈述", followed by `` 它在网、其类与诸中心给定后或真或假，有的网满足它，有的不满足（[满足与不满足的前提](chapters/08-METHOD.md#r-premises-met-and-failed)）。 ``
- **THE-THEORY-OF-BECOMING.zh.md, line 164:** "该条件就是根的一条律：" becomes "该条件是根上的一个陈述，有的网满足它，有的不满足：".

The link to `r-premises-met-and-failed` exists once R1's home section lands in 08 §7. The front pages are being cut by OU's owner, so line numbers and wording are re-read at the landing, and the replacements are applied only to the sentence as it then stands. These edits land in DU's landing on the front-page owner's word, given 1 November 2026 for all six lines with the wording above, so each page changes once. The kit applies them after R1's home section is in 08 §7, because line 115's link `r-premises-met-and-failed` resolves only once that section exists, and research-links runs after both. At the landing, READING-BUDGETS' one-page row records the recounted figures, not the estimate here; the owner accepts a count of about 1,115 words.
