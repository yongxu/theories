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
- Premise "L, lifting": its witnesses become `Becoming.LiftModel.met_and_failed` and `Becoming.LiftModel.some_outcome_does_not_lift`, and its note becomes "met and failed on `LiftModel`'s frame (the move reaching 3 lifted above the move reaching 1, not the reverse); the choice of the rule is substantive (a response with a better and a worse outcome is comparable by neither direction)".

## (c) WHAT-REMAINS: a new section (OU's owner applies it)

```markdown
## The unit grain is balance, not atomism (DU, 31 October 2026)

One-to-one continuation of units is balance at the unit grain, not atomism. Balance holds exactly where some selection of one-to-one unit matchings exists at every frame (U1b's record `amounts-by-unit-matchings`: `FrameMatchings` and balance, `Becoming.UnitMatchings`). The matchings represent balance and do not derive it. Atomism is integrality, the modelling choice of natural-number amounts, which makes a positive loss at least one unit. The matchings presuppose it, since they match the units of such amounts, but it does not give them: the world `World.unbalanced` has natural-number amounts and fails balance while meeting every other premise (`World.unbalanced_but`, part of `World.independent`). So one-to-one continuation adds balance to integrality and is not integrality itself. U4's design (§0, *The verdict (reviewed)*, the sentence calling one-to-one continuation "U1's atomism") and the line in the section *U4's levers 1 and 2, reviewed (30 October 2026)* above conflate the two. Both stay as written, since they are cited; this section is the correction. Nothing in a record or a figure changes.
```

## (d) 04: Bases and Open (OU's owner; the rows' records unchanged)

Standings read from the boundary record `one-root-to-its-edge` on `852985f8a` (taken by OU's owner): 1 under a stated hypothesis, 3 counting, 1 at a represented model, **5** with balance in the statement and **8** at amounts. The split "6 and 7" in the review's attack and in OU's owner's note does not match the record, which places `Flow.no_new_dependence`, `Reproduction.Flow.lineage_ends`, `Reproduction.Flow.closed_lineage_lowered`, `GroupEnding.Flow.family_childless` and `GroupEnding.Flow.coupled_end_together` with balance in the statement, and the other eight at amounts. The figures are checked against the record again at the landing.

§Bases: replace "None is yet lifted onto the grammar; only the law of passing is read on it, in part ([below](#r-a-pattern-lasts-through-passing))." with:

> Of the chapter's 18 central declarations, the [boundary record](../results/records/one-root-to-its-edge.md) places:
> - one on the root under a stated hypothesis: `GroupEnding.Flow.all_end`, as `RootForms.outside_leaves_no_offspring`, each hypothesis needed;
> - three as counting, below the grammar: Price's covariance, the levels partition and the drift bound;
> - one at a represented model: `Web.transmits_at_iff`;
> - five with balance in their statements;
> - eight at amounts.
>
> The law of passing is read on the grammar, in part ([below](#r-a-pattern-lasts-through-passing)). None of the 18 is proved from the root's laws alone. Each is proved from the World premises it takes as hypotheses (balance, only active relata give, activity needing support, dissipation, bounded transmission, in 08's premise card's wording), and no one of those premises follows from the others (`World.independent`, `World.none_follows`).

Open: replace "Lifting these laws onto the grammar ([08](08-METHOD.md))." with:

> Moving a row past its standing in the boundary record: a row at amounts or with balance in its statement moves only through a root form whose hypotheses its model meets by definitions alone, as `GroupEnding.Flow.all_end` does ([08 §7](08-METHOD.md#r-one-root-to-its-edge)). The World premises stay hypotheses.

## Also touched by the leaf (the record's owner)

If the record's text changes, its home section in 08 §7 changes with it; edit (a) already covers that.

The boundary record `one-root-to-its-edge` says, for order: "no theorem shows it unentailed by the dynamics". Once the leaf lands, `ReadsNoOrder.not_entails` is that theorem for frames (immediate). Whether `boundary.py`'s Q1 computes it as such (a theorem whose type names `Comparison`), or the record's premise entry needs a reading, is checked at the rehearsal.
