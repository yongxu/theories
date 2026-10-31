# Counting and amounts: one line (U4b)

31 October 2026, board item U4b; revised 1 November after [its independent review](REVIEW-U4B.md). The [deep unification review](../du-deep-unification-review/REVIEW.md) (§3, evolution) left U4's owner one decision. The design labels a law over lists and maps to `Nat` "counting" ([DESIGN-BOUNDARY](DESIGN-BOUNDARY.md) §1.4). Yet the record placed evolution rows 7, 8, 13 and 14, which compare sums of an arbitrary trait map, "at amounts". Both labels cannot stand as written.

## 1. The line

Both labels concern natural numbers, so neither can be told by whether a statement compares numbers:
- Price's covariance (`SelectionTerm.covariation`, row 6) is an equation of sums.
- `SelectionLevels.levels_sized` (row 12) has a hypothesis equating each group's length times its factor with `n`.
- `Drift.falls_back` (row 18) has one equating sums of its parameters, `(p + q) * h + g = N * p`.

What separates counting from the rest is what the statement says of the dynamics.

- **Counting.** The statement says nothing of the dynamics beyond the arbitrary predicate of a counting law. It holds for every carrier, listing, map and parameter it quantifies over, and none of its numbers is a state of a law's run.
  - Hypotheses that equate or order values of those maps are counting too: a common multiple, or exact transmission of an arbitrary trait.
  - Such a predicate may be the dynamics' terms, as a web's arising and ceasing are in `CensusWebs.keep_pace`.
- **Not counting.** A statement is not a law of counting if it uses the dynamics in any of three ways:
  - as a hypothesis: for example the gate (K3's premises of the account) and descent in the flow, dissipation, or the frontier rows' hypotheses on levels and needs;
  - in its conclusion: for example the existential over an exchange law and a web in `carried_iff_rising`;
  - through a run's states: a law's run (`Law.run` in the `RegimeMargin` rows), or an exchange law's levels (`responses_le_missBound`).

  Where such a statement stands is decided above counting:
  - under a stated hypothesis when a strict root form passes (the design's §1.2); `GroupEnding.Flow.all_end`, lever 2's row 17, is the one such row;
  - otherwise at a named distance.
- **Amounts** is that distance for a statement that uses the dynamics and compares or constrains numbers the grammar has no terms for. Those numbers are:
  - the dynamics' levels, needs, giving and taking;
  - the amounts module;
  - a run's natural-number states;
  - an arbitrary trait's values.

  Hypotheses on a trait's values are counting where the statement says nothing of the dynamics, as in row 13. Hypotheses on them keep a form off standing 2, with the gate or without it, since a root form's hypotheses name no amount (the design's §1.2): cancellation keeps lever 2's scratch form `rises_cancel_iff_levels` off it (LEVER-2-AUDIT §3). Some of them also tie the trait to the dynamics: `top` orders the trait at the supported members (rows 7 and 8), and `inactive` makes the members of groups lower in the trait inactive (row 14).

**Finding B1.** The first boundary review's finding B1 placed rows 13 and 14 at amounts because cancellation constrains amounts (DESIGN-BOUNDARY §1.2).
- That reason concerns standing 2: no hypothesis of a root form may constrain an amount. It still holds there.
- As a reason for a distance from counting, it would move rows 12 and 18 as well, since their hypotheses equate numbers.
- B1's analogy also misread row 13. It said rows 1–3, 7 and 8 "have the same shape as row 13: the gate and descent as hypotheses" ([REVIEW-U4-BOUNDARY](REVIEW-U4-BOUNDARY.md)). Row 13's hypotheses are only `listed`, `equal` and `exact`.
- The measure's own category for row 13 was already "counting identity" ([LEVER-2-AUDIT](LEVER-2-AUDIT.md) §1).

**Same partition as the test.** On all 25 rows, this split by what a statement says of the dynamics gives the same partition as the reach the test below reports. The label does not say that a row compares the dynamics' own amounts. Rows 7, 8 and 14 reach the dynamics' numbers only through relations the model defines from them:
- Row 14 reaches `Flow.give` and `Dependence.level` only as positivity: in `Flow.Acting`, in descent's `Flow.DescendsAt` and in `Web.ComesToStand`, as row 17 does.
- Rows 7 and 8 reach `need ≤ level` only inside `Web.Supported`, which lever 2 reads as the relation `needMet`.

What the label records is that a row uses the dynamics and constrains numbers.

## 2. The test

[`counting_test.py`](counting_test.py) walks each counting or amounts row's statement on the constants of a core run.
- **What it reads.** The type and the definitions the type unfolds to, never a proof, as `boundary_table.py`'s `statement_closure` does.
- **What it reports.** For each row: the dynamics' terms the statement reaches, and the dynamics' amounts among them.
- **Its lists.** Both come from a stated list (`DYNAMICS`, `AMOUNT`): the theory's vocabulary for the dynamics, with lever 2's model constants (`Flow`, `Web`, `World`, `Dependence`, `WebAt`, `Exchange`; LEVER-2-AUDIT §2). They are not a measurement.
- **Its kind.** It is a name test by namespace, which measures packaging ([BOUNDARY-FIELD](../../../../2026-10-05-repository-reconciliation/architecture/mv/BOUNDARY-FIELD.md) §3.4). Were `Generations` declared under `Flow`, row 13 would flip. So it supports readings and does not settle them.
- **Its readings.** Three rows reach the dynamics and are decided by a reading the script names, with its reason.

On main 3942f6177 (core receipt `20261031T152525.956467Z`):

| Row | Was | Reaches | Now |
|---|---|---|---|
| `SelectionTerm.covariation` (6), `SelectionLevels.levels_sized` (12), `Drift.falls_back` (18), `RelativePosition.rise_needs_fall`, `Listed.coming_of_ceasing` | counting | nothing of the dynamics | counting |
| `CensusWebs.keep_pace` | counting | a web, its dependences, `Web.Arises`, `Web.Ceases`; no amount | counting, by reading: the dynamics only as the predicate `CountsAcross.keep_pace` is applied to |
| `SelectionLevels.rises_exact_iff_levels` (13) | amounts | nothing of the dynamics: `Generations`, `Exact`, the sums within and among groups, `excess`, `lowered`, `raised` | **counting** |
| `Flow.selection_within`, `Flow.transmitted_supported`, `Flow.selected_le` (1–3) | amounts | `Dependence.level`, `Dependence.need`, `Flow.give`, through the gate (`Supported`, `Dependent`, `Acting`) and descent | amounts: needs the gate and descent; compares needs with the level |
| `SelectionTerm.Flow.support_not_lower` (7), `SelectionTerm.Flow.support_moved_rises` (8) | amounts | the same, `need ≤ level` only inside `Supported` | amounts: needs the gate and descent; constrains an arbitrary trait's values (`top`, `unlowered`; `top`, `exact`, `moved`) |
| `GroupEnding.Flow.rises_iff_inactive` (14) | amounts | `Dependence.level` and `Flow.give` only as positivity, through `Acting`, `DescendsAt` and `ComesToStand`; no need | amounts: needs the gate and descent; exact transmission and `inactive` constrain an arbitrary trait's values |
| `Reproduction.Flow.number_within_take` (9), `Flow.new_beyond_every` | amounts | levels, giving and taking | amounts |
| the six frontier rows | amounts | the amounts module, levels and needs | amounts |
| `responses_le_missBound` | amounts | an exchange law's giving, taking and levels | amounts |
| `carried_iff_rising` | amounts | an exchange law's giving and taking, and `Dependence.need` | amounts |
| `RegimeMargin.ends_iff_below`, `RegimeMargin.Adjusted.ends_iff_below` | amounts | a law's run: `Law.run (step g H) x`, whose states are natural numbers, and `Law.run (step A H) (x, r)`, whose states are pairs of them, the level and the recent giving; `AMOUNT` names no run's state | amounts, by reading: the run reaches 0 exactly where its start `x` is below `H + y`. The placement turns on `Law.run` being the dynamics: `Drift.falls_back` is the same kind of arithmetic without a run, and is counting |

So rows 7, 8 and 14 stay at amounts. Row 13 moves to counting:
- It is Price's partition over listed generations with exact transmission of an arbitrary trait.
- It reaches nothing of the dynamics.
- Lever 2's audit had already said it "reaches no model constant" (LEVER-2-AUDIT, row 13).

## 3. What changes

- **The record `one-root-to-its-edge`.**
  - Row 13's standing is counting, and its basis is rewritten.
  - The bases of rows 7, 8 and 14 are rewritten on this line. They had said that their trait comparisons constrain amounts, the reason §1 rejects as a distance from counting. Of their hypotheses on the trait, `unlowered`, `exact` and `moved` are counting; `top` and `inactive` tie the trait to the dynamics.
  - The four entries' review is [REVIEW-U4B.md](REVIEW-U4B.md).
  - This note, its test and its review join the references. DESIGN-BOUNDARY's hash is refreshed for its dated pointer (its §8).
  - U4's history line is kept, and a U4b line is added.
  - The counts: 7 counting, 18 at amounts, 100 at a distance; 10 derived, 1 under a stated hypothesis, 0 unplaced.
- **08 §7's home paragraph.** Three figures change: seven counting, 100 at a distance, 18 on amounts.
- **The study.** One section.
- **The scripts.**
  - [`make_record_u4.py`](make_record_u4.py) gives the four entries, the references and a kept history, so a rerun keeps the amendment.
  - [`amend_u4b.py`](amend_u4b.py) applies it.
- **Generated.** master-laws.json's boundary report changes by rerunning `master_laws.py`, and the generated pages by the render.
- **Not changed: the design table.** [`boundary_table.py`](boundary_table.py) and [`boundary-table.json`](boundary-table.json) stay the design phase's table.
  - They still give row 13 at amounts.
  - They differ from the record on four rows the record placed after the design: `carried_iff_rising`, `GroupEnding.Flow.all_end` and HE2's two rows.
  - Where they differ, the record stands (DESIGN-BOUNDARY §8).
- **Not here: 04's Bases and Open.** DU's owner brings them to the record's standings. Of the 18 evolution rows:
  - 1 is under a stated hypothesis;
  - 4 are counting;
  - 1 is at a represented model;
  - 5 have balance in their statements;
  - 7 are at amounts: rows 1–3, 7, 8 and 14, and `Reproduction.Flow.number_within_take`.

## 4. What this does not show

- **That counting rows are derived.** They stand below the grammar, laws over any listing and map, as before.
- **That the gate rows' amounts are needed.** Lever 2 witnessed every hypothesis that is not counting.
  - Whether a root form could do without the amounts that define the gate is a question for lever 2's forms.
  - What amounts on the root would need is LEVER-2-AUDIT §6 and U1b's interface for amounts, not this line.
- **That `DYNAMICS` and `AMOUNT` are complete.** They are the dynamics' carriers and fields the central rows reach today, with lever 2's model constants. A new row reaching another carrier needs the list extended, or a reading.

## 5. The review

An independent review ([REVIEW-U4B.md](REVIEW-U4B.md)) tried to refute the line. It found the move of row 13 right, with one blocking finding and eight others. Every finding is taken, and its last section says how.
