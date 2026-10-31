# Review of U4b: counting and amounts, one line

31 October 2026. An independent, AI-written review of [COUNTING-AND-AMOUNTS.md](COUNTING-AND-AMOUNTS.md), its test [counting_test.py](counting_test.py), and the edits to [make_record_u4.py](make_record_u4.py) and [boundary_table.py](boundary_table.py) that place `SelectionLevels.rises_exact_iff_levels` (lever 2's row 13) at counting. It tried to refute the line, not to confirm it.

## What was read and run

- **Read.** The note and the test; the diff of the two scripts; DESIGN-BOUNDARY §0, §1.2, §1.4, §4 and §7; LEVER-2-AUDIT §0–§4 and §6; the first boundary review's B1; DU's REVIEW §3 (evolution); BOUNDARY-FIELD's labels table and §3.4; the record `one-root-to-its-edge.json` and 08 §7's home paragraph.
- **Read in the Lean** (statements and the definitions they unfold to):
  - `SelectionLevels.rises_exact_iff_levels` and `SelectionLevels.levels_sized`;
  - `SelectionTerm.Generations` with `family`, `offspringNumber`, `Raises`, `loweredAt` and `raisedAt`; `SelectionTerm.Exact`; `excess`, `raised` and `lowered`;
  - `SelectionTerm.Flow.support_not_lower`, `SelectionTerm.Flow.support_moved_rises` and `SelectionTerm.Flow.Descended`;
  - `GroupEnding.Flow.rises_iff_inactive` and `GroupEnding.Flow.all_end`;
  - the gate and descent: `Flow.Acting`, `Flow.DescendsAt`, `Web.ComesToStand`, `Web.Supported`, `Web.Dependent`;
  - `CensusWebs.keep_pace`, `Drift.falls_back`, `RegimeMargin.ends_iff_below`, `RegimeMargin.Adjusted.ends_iff_below`, `Law.run`, `Law.orbit`, `Law.process`;
  - `Reproduction.Flow.number_within_take` with `Flow.DissipatesOn`.
- **Ran**, from the worktree root (HEAD 3942f6177):
  - `counting_test.py` on the pickle `u4-counting/c.pickle`. It reproduces the note's table. Three rows are marked as differing: row 13, expected, since the record is not yet regenerated; and the two `RegimeMargin` rows, which the note places by reading.
  - `make_record_u4.py --names`: counting 7, amounts 18, derived 10, under a stated hypothesis 1, unplaced 0.
  - `make_record_u4.py --home`, compared with 08:438. Exactly three figures change: "Six" becomes "Seven", "101" becomes "100", and "19 on amounts" becomes "18 on amounts".
  - The same statement walk on further rows: `GroupEnding.Flow.all_end`, `SelectionLevels.rises_exact_iff_sized`, `GroupEnding.Flow.rises_iff_inactive_sized`, `Listed.coming_of_ceasing`, `RelativePosition.rise_needs_fall`.
  - A tally of the 18 evolution rows: the `rows` field of boundary-table.json crossed with the labels in master-laws.json's boundary report.

## What holds

- **Row 13 reaches nothing of the dynamics.** Its statement walk yields 28 constants:
  - `SelectionTerm.Generations` and its fields, `family`, `size`, `concordAt`, `discordAt`, `loweredAt`, `raisedAt`, `offspringNumber` and `Raises`;
  - `SelectionTerm.Exact`, `SelectionTerm.concord` and `SelectionTerm.discord`;
  - the within and among sums of `SelectionLevels`;
  - `excess`, `raised`, `lowered` and `total`.

  `Generations` is a structure over any carrier, with arbitrary `kids` and `amount` maps (SelectionTerm.lean:429-432). `Exact` says that each listed offspring's value is its parent's (SelectionTerm.lean:365-366). The hypotheses are `listed`, `equal` and `exact` (SelectionLevels.lean:553-555), with no gate and no descent. The measure's own category for the row is already "counting identity" (boundary-table.json; LEVER-2-AUDIT:72).
- **`CensusWebs.keep_pace` is honestly counting.** It is `CountsAcross.keep_pace` with its predicate instantiated at `W.active` (Listing.lean:1057-1061). `Web.Arises` and `Web.Ceases` unfold to `Dependence.active` only, which is Prop-valued.
- **The counts are right.** The record will have 7 counting and 18 at amounts, with 100 at a distance. Ten rows are derived, one is under a stated hypothesis, and none is unplaced.
- **The walk is as described.** `closure` (counting_test.py:34-42) is `statement_closure` (boundary_table.py:185-194) verbatim. It unfolds definitions, inductives, constructors and recursors, and takes only the types of theorems, so no proof is read.

## Findings

1. **Blocking. Once the record is regenerated, its bases for rows 7, 8 and 14 give the reason this note rejects, and they contradict row 13's new basis.**
   - *Evidence.*
     - Row 14's basis says that "exact transmission at the step, each offspring's amount its parent's, and inactivity compared on sums of the trait, constrain amounts" (make_record_u4.py:224-227; boundary_table.py:72-75).
     - Row 13's new basis says that exact transmission "equates values of that map", which is counting (make_record_u4.py:204-207).
     - Rows 7 and 8's basis says that "the conclusion compares sums of amounts over generations" (make_record_u4.py:220-223; boundary_table.py:110-113). Their conclusion is `G.size T * G.sum 0 ≤ G.size 0 * G.sum T` over the arbitrary `G.amount` (SelectionTerm.lean:670-676, 682-688).
     - The note's own reason is the opposite: "the trait they compare is arbitrary, but the gate they need is read off the dynamics' levels, needs and giving" (COUNTING-AND-AMOUNTS.md:30).
   - *Fix.* In the same change, rewrite the three bases in both scripts. Each should say three things:
     - the conclusion compares sums of an arbitrary trait map, and the hypotheses on the trait's values are counting (`top`, `unlowered`, `exact` and `moved` for rows 7 and 8; `exact` and `inactive` for row 14);
     - the row stands at amounts because its gate and descent are read, at the model, off levels, needs and giving (row 14: off giving and level only);
     - what keeps it off standing 2 is its hypotheses on the trait's values, as for row 13.

2. **Should fix. Rows 7, 8 and 14 stay at amounts by reaching relations that the record reads off amounts and admits on the edge. The line's wording claims more than that.**
   - *Evidence.*
     - The line says amounts "compares or constrains" the dynamics' natural numbers (COUNTING-AND-AMOUNTS.md:10).
     - Row 14 reaches `Flow.give` and `Dependence.level` only as positivity:
       - `Flow.Acting` is `0 < L.give t f c → W.active t f` (Flow.lean:280-281);
       - `Flow.DescendsAt` is `present ∧ 0 < give ∧ ComesToStand` (Evolution.lean:154-155);
       - `Web.ComesToStand` is `¬ 0 < level t ∧ 0 < level (t + 1)` (Flow.lean:230-231).
     - `GroupEnding.Flow.all_end` takes `acting`, `descended` and `inactive` (GroupEnding.lean:377-379). Its walk reaches exactly the same two amounts, `Dependence.level` and `Flow.give`, yet it stands under a stated hypothesis, because "amounts may still define the model's relations" (DESIGN-BOUNDARY:100).
     - Rows 7 and 8 reach `need ≤ level` only inside `Web.Supported`, through `dependent` and `top` (Dependence.lean:133-138). Lever 2 reads that as the relation `needMet`, "the gate fully as inclusions" (LEVER-2-AUDIT §0).
     - LEVER-2-AUDIT §6 (line 171) names the rows that would need amounts on the root: 1–3, 7 and 8. Row 14 is not among them.
     - So `AMOUNT`'s reach does not tell a compared amount from a relation defined by one. The partition is right, but for another reason.
   - *Fix.* State the line's split by hypotheses:
     - **Counting:** the statement holds for every carrier, listing, map and parameter it quantifies over, with no hypothesis about the dynamics. The dynamics' terms may only instantiate an arbitrary predicate of a counting law, as in `CensusWebs.keep_pace`.
     - **Not counting:** rows 7, 8 and 14 need the gate and descent, premises of the account (K3).
     - **The label amounts:** it records that those premises are read off levels, needs and giving at the model, as row 17's are.

     This gives the same partition on all 25 rows, settles `CensusWebs.keep_pace` without a separate reading, and does not depend on how the gate's relations are packaged. If the reach criterion is kept instead, say in the note and in row 14's basis that its amounts are only the positivity defining giving and coming to stand, as for row 17. The label then records reach, not the obstacle.

3. **Should fix. The evolution tally is wrong.** "Of the 18 evolution rows, 4 are now counting and 6 at amounts" (COUNTING-AND-AMOUNTS.md:37).
   - *Evidence.* The record now places the 18 as follows: 8 amounts, 5 with balance in their statements, 3 counting, 1 under a stated hypothesis and 1 at a represented model. After the move there are 4 counting and **7** at amounts: rows 1, 2, 3, 7, 8, 14 and `Reproduction.Flow.number_within_take` (row 9). DU's REVIEW:68-72 tally of 3/1/1/6/7 is itself off by one row, between balance and amounts.
   - *Fix.* Write "4 counting and 7 at amounts (and 5 with balance)". Tell DU's owner, since 04's Bases will quote these figures.

4. **Should fix. "What changes" leaves out generated and bound pieces.**
   - *Evidence.*
     - master-laws.json's boundary report carries the counts (counting 6, amounts 19), the groups (101), `against_f5` and row 13's label (theories/becoming/results/data/master-laws.json:60369). It changes only by rerunning `master_laws.py`.
     - `reading()` sets every reading's `review` to REVIEW-U4-RECORD.md (make_record_u4.py:114-115). That review read the amounts placement, and BOUNDARY-FIELD.md:116 binds an entry's names to its review.
     - The references list (make_record_u4.py:382) has neither COUNTING-AND-AMOUNTS.md nor this review.
     - `history` is rebuilt as a single "U4 … added" entry dated by the run (make_record_u4.py:480). Regenerating on another day, or with a new study section, would misdate U4's 31 October entry (§479).
   - *Fix.* Add `master_laws.py` and the render to the list. Give `reading()` a review argument and point row 13 at REVIEW-U4B.md. Add COUNTING-AND-AMOUNTS.md (integration) and REVIEW-U4B.md (review) to the references. Keep U4's history entry and append a U4b entry.

5. **Should fix. Design texts that the record cites still state the old placement, and the claim that the generator and the table agree is too broad.**
   - *Evidence.*
     - DESIGN-BOUNDARY states the old placement in four places: :22 (six counting), :127 ("Rows 13 and 14 are at amounts … the same shape"), :154 ("There are six") and :317 ("stay at amounts"). It is an integration reference of the record.
     - COUNTING-AND-AMOUNTS.md:36 says the generator and the table "agree with the record". `boundary_table.py`'s HAND still disagrees with the record on four rows: `carried_iff_rising` (at its model, :134), `GroupEnding.Flow.all_end` (witnessed at its model) and the two HE2 rows (connected). boundary-table.json is not regenerated and still has row 13 at amounts.
   - *Fix.* Add a dated note to DESIGN-BOUNDARY that points to COUNTING-AND-AMOUNTS.md, without rewriting the cited sections. Then either say "agree on row 13", or leave `boundary_table.py` as the design-phase script and revert its edit.

6. **Minor. The account of B1 is fair in substance, but incomplete.**
   - *Evidence.*
     - B1 also drew the distance: it said rows 1–3, 7 and 8 "have the same shape as row 13: the gate and descent as hypotheses" (REVIEW-U4-BOUNDARY.md:34). That is false of row 13, whose hypotheses are only `listed`, `equal` and `exact`.
     - "The review's reason" (COUNTING-AND-AMOUNTS.md:12) can be read as DU's review, which line 3 calls "the review".
   - *Fix.* Name "the first boundary review's finding B1". Say that its analogy misread row 13's hypotheses, and cite the measure's category "counting identity" as support.

7. **Minor. Several small statements in the note and the new basis are inexact.**
   - *Evidence and fix.*
     - Row 18's `gap : (p + q) * h + g = N * p` (Drift.lean:232) equates parameters, not lengths or map values (COUNTING-AND-AMOUNTS.md:7, :12).
     - The new basis says row 12's common multiple "equates lengths and weights" (make_record_u4.py:206). Row 12's `common` is `g.length * c g = n`, with `c` the groups' factor, not the weight. Write "equates each group's length times its factor with `n`", and name `SelectionLevels.levels_sized` rather than "row 12".
     - "For any carrier" (:9) does not fit `Drift.falls_back`, which is over courses of `Bool`. Write "for any carrier, listing, map or parameter the statement quantifies over".
     - Row 14 reaches the level through descent's `Web.ComesToStand`, not through "the gate and activity" (:24), and it reaches no need (:30).
     - `carried_iff_rising` reaches `Dependence.need`, not levels (:27).
     - `CensusWebs.keep_pace` gets the same test class as the `RegimeMargin` rows, so mark its verdict as a reading too (:21).
     - "The record's next step for the census rows" (:42) points at `CensusWebs.keep_pace` and `Listed.coming_of_ceasing` (DESIGN-BOUNDARY:22, :60), not at the gate rows. Point to lever 2's forms and LEVER-2-AUDIT §6 instead.

8. **Minor. The test's lists and their kind.**
   - *Evidence.*
     - `DYNAMICS` omits `Exchange` and `WebAt`, which lever 2's constant check counted as model constants (LEVER-2-AUDIT §2). No current row reaches them, so nothing flips.
     - The test is a name test on rows by namespace, which BOUNDARY-FIELD.md:311 says measures packaging. Declared under `Flow`, `Generations` would flip row 13.
   - *Fix.* Align the lists with lever 2's, and present the test as support for readings, as BOUNDARY-FIELD §3.4 makes counting a reading. The note already says the lists are stated, not measured.

9. **Minor. The `RegimeMargin` rows are defensible at amounts, but the line should say what decides them.**
   - *Evidence.*
     - The statement is `(∃ n, (Law.run (step g H) x).state n = 0) ↔ x < H + y`, with `g` an arbitrary `Nat → Nat` (RegimeMargin.lean:739-741).
     - `Law.run` is the run of any `next : S → S` (Recurrence.lean:143, :275-277).
     - The counting bullet's "values of maps … any map" also describes `g`. `Drift.falls_back` is the same kind of arithmetic, but without a run.
   - *Fix.* Add to the counting bullet: "no number is a state of a law's run". The placement then turns visibly on `Law.run` being the dynamics.

## Verdict

The move of `SelectionLevels.rises_exact_iff_levels` to counting is right and should land. The Lean shows that its statement is Price's partition over a structure of arbitrary lists and maps, with no gate, no descent and no dynamics, and the counts follow (7, 18, 100). Rows 7, 8 and 14 do differ from row 13 in what they reach, but the note's reason overstates it. They reach the dynamics' numbers only through relations that the record itself reads off amounts and admits on the edge in `GroupEnding.Flow.all_end`. A split by hypotheses about the dynamics gives the same partition on firmer ground. Before landing:
- rewrite the record bases of rows 7, 8 and 14 in the same change (blocking);
- correct the evolution tally to 4 counting and 7 at amounts;
- list `master_laws.py`, the references, the review pointer and a kept history;
- point DESIGN-BOUNDARY to the note.

## How the findings were taken

1 November 2026, by U4's owner. Every finding is taken.

1. **Taken.** The bases of rows 7, 8 and 14 in `make_record_u4.py` are rewritten in the same change. Each says three things:
   - the conclusion compares an arbitrary trait map, and its hypotheses on the trait's values are counting (`top` and `unlowered`; `top`, `exact` and `moved`; exact transmission and `inactive`);
   - it is not counting because it needs the gate and descent, premises of the account (row 14's read off giving and level only);
   - those hypotheses on values keep it off standing 2, as cancellation keeps row 13's form.

   `amend_u4b.py` replaces the four entries and asserts that no other entry differs from the generator.
2. **Taken.** The note's §1 states the split by hypotheses:
   - **counting** holds for every carrier, listing, map and parameter, with no hypothesis about the dynamics;
   - **not counting** needs the dynamics;
   - **amounts** is the distance for a statement that needs the dynamics and constrains numbers the grammar has no terms for.

   §1 also says that rows 7, 8 and 14 reach the dynamics' numbers only through relations defined from them, row 14 only as positivity, as row 17 does. The test is presented as giving the same partition.
3. **Taken.** "4 counting and 7 at amounts (and 5 with balance)", with the seven named, in the note and the study section. DU's owner had the corrected figures on 31 October.
4. **Taken.** The note's §3 lists `master_laws.py`, the render, the review pointer, the references and the kept history.
   - `make_record_u4.py` gives the four entries `REVIEW-U4B.md` as their review, through `REVIEWED`.
   - It lists the note, its test and this review among the references.
   - It keeps a landed record's history on a rerun.
   - `amend_u4b.py` appends a U4b line, dated by its run.
5. **Taken.**
   - DESIGN-BOUNDARY gains a dated §8 that points to the note and names the four passages, which are kept as written; its hash in the record is refreshed with it.
   - `boundary_table.py`'s edit is reverted. It and `boundary-table.json` stay the design phase's table, and the note says where they differ from the record and that the record stands.
6. **Taken.** The note names "the first boundary review's finding B1", says that its analogy misread row 13's hypotheses, and cites "counting identity".
7. **Taken.**
   - Row 18 is described as equating sums of its parameters.
   - Row 13's basis names `SelectionLevels.levels_sized`'s common multiple, "each group's length times its factor with n".
   - The counting bullet reads "every carrier, listing, map and parameter it quantifies over".
   - Row 14's route is through `Acting`, `DescendsAt` and `ComesToStand`, with no need.
   - `carried_iff_rising` reaches `Dependence.need`.
   - `CensusWebs.keep_pace`'s verdict is marked a reading.
   - §4 points to lever 2's forms and LEVER-2-AUDIT §6.
8. **Taken.**
   - `DYNAMICS` gains `Exchange` and `WebAt`, lever 2's model constants. No row flips.
   - The test now classes rows by whether they reach the dynamics, and names its three readings (`READ`) with their reasons.
   - Its docstring and the note call it a name test that supports readings and does not settle them (BOUNDARY-FIELD §3.4).
9. **Taken.** The counting bullet adds that no number is a state of a law's run. The `RegimeMargin` row of the note's table says that the placement turns on `Law.run` being the dynamics, with `Drift.falls_back` as the same arithmetic without a run.

## Re-check

1 November 2026, of the revision: the rewritten note, `counting_test.py`, the `make_record_u4.py` diff, `amend_u4b.py` (the record's four entries, its history line in English and Chinese, the study section's text), DESIGN-BOUNDARY §8, and the section above. The revision was read against the Lean statements again.

**What the run shows.**
- `make_record_u4.py --names` gives counting 7 and amounts 18, with 10 derived, 1 under a stated hypothesis and 0 unplaced.
- `counting_test.py` on the same pickle marks only row 13 as differing, since the record is not yet amended. `CensusWebs.keep_pace` and the two `RegimeMargin` rows are marked as readings.
- Adding `WebAt` and `Exchange` to `DYNAMICS` flips no row.
- `amend_u4b.py`'s preconditions hold on this checkout. Every entry other than the four equals the generator's, and the premises are unchanged. The generator's `review` override gives the four entries REVIEW-U4B.md, which names each of them in a code span.
- `git diff` shows that DESIGN-BOUNDARY only gains §8. `boundary_table.py` equals main. The table differs from the record on exactly the four rows §8 names, and on row 13.

**(a) Taken as claimed.** All nine findings are taken as the section above says. The new texts bring the inexactnesses below.

1. **Blocking. The new bases call two hypotheses that tie the trait to the dynamics "counting".**
   - *Evidence.*
     - Row 7's basis says that "its hypotheses on the trait's values (top, unlowered) are counting", and row 8's says the same of top, exact and moved.
     - `top` holds only at members where `W.Supported t p` (SelectionTerm.lean:672-673), so it is a hypothesis about the dynamics.
     - Row 14's basis calls exact transmission and inactivity "counting as in row 13". `inactive` concludes `¬ W.active t p` (GroupEnding.lean:285-286), and row 13 has no such hypothesis.
     - On the note's own line (§1: counting has "no hypothesis about the dynamics"), neither `top` nor `inactive` is counting.
   - *Fix.* Call only `unlowered`, `exact` and `moved` counting. Say that `top` orders the trait at the supported members and that `inactive` makes the groups lower in the trait inactive: both tie the trait's values to the dynamics. In row 14, drop "as in row 13". The note's table rows for rows 7, 8 and 14 can stay as written, since they say "constrains", not "counting".

2. **Should fix. "What the statement needs" is not exact on all 25 rows.**
   - *Evidence.* `carried_iff_rising` has no hypothesis at all (LevelCoupling.lean:904-909). Its only binders are `d c r t N`. The dynamics occurs only inside an existential on one side of an `Iff`, and the other side is a property of an arbitrary `r : Nat → Nat`. So the "Not counting" bullet (note:17, a hypothesis about the dynamics or a run's states) does not cover it. Neither do "Amounts … a statement that needs the dynamics" (note:20) or "what the statement needs" (note:12). It falls outside counting only by the counting bullet's last clause: "the dynamics' terms may enter only as the arbitrary predicate of a counting law". The two `RegimeMargin` rows also need no hypothesis about the dynamics; they are placed by their run's states. So "On all 25 rows, this split by hypotheses gives the same partition" (note:34) holds only with that clause.
   - *Fix.* Read the line as what the statement says of the dynamics:
     - **counting:** nothing, beyond an arbitrary predicate of a counting law;
     - **not counting:** it uses the dynamics as a hypothesis (the gate, descent), in its conclusion (`carried_iff_rising`'s existential), or through a run's states.

     Make the same change in note:12, :17, :20 and :38, and in the study's first Delta bullet.

3. **Minor. Descent is not one of K3's premises of the account.**
   - *Evidence.* The note (:17), the three bases and the study say "the gate and descent, premises of the account (K3)". K3's register (theories/becoming/results/completion/COVERAGE.json, `premises`) lists "only active relata give" (`Acting`) and "activity needing support" (`Dependent`). It has no entry for descent, and DESIGN-BOUNDARY:133-137 says the same: "The others have no entry".
   - *Fix.* Write "the gate (K3's premises) and descent in the flow".

4. **Minor. A trait's values are given two roles.**
   - *Evidence.* The note lists "beside the gate, an arbitrary trait's values" among the numbers that amounts constrains (:24). Yet §3 (:74) and the study's third Delta bullet call "trait comparisons constrain amounts" "the reason §1 rejects", and the bases call those hypotheses counting.
   - *Fix.* Write "the reason §1 rejects as a distance from counting". Say once that the label amounts records a row that needs the dynamics and constrains numbers, a trait's values included.

5. **Minor. DESIGN-BOUNDARY §8 says that "four passages above state the earlier placement".** There are three more: §0:15 ("6 stand below the grammar"), §0:35 ("The other 51 are 6 counting … 18 amounts") and §7:374 (B1's row, "Rows 13 and 14 go to amounts"). Fix: list all seven, or write "among them".

6. **Minor. The `RegimeMargin` reading misstates what is compared.**
   - *Evidence.* Note:63 says that "the statement compares the level the run reaches with `H + y`", and the study says "comparing the level a law's run reaches". The statement says that the run reaches nothing exactly where the start level `x` is below `H + y` (RegimeMargin.lean:674-678, 739-741).
   - *Fix.* Write "where its start is below `H + y`".

7. **Minor. The record texts use lever 2's bare row numbers, and the Chinese history line is shorter than the English.**
   - *Evidence.*
     - The bases say "row 13's form" and "counting as in row 13". The history line says "as rows 6, 12 and 18 do" and "Rows 7, 8 and 14". The record has no table to resolve these numbers; elsewhere it writes "row 17 of lever 2's table".
     - The English history line says "every carrier, listing and map", but row 18 quantifies parameters over a fixed carrier.
     - The Chinese line leaves out the English line's "(COUNTING-AND-AMOUNTS.md, reviewed in REVIEW-U4B.md)".
   - *Fix.* Name the declarations, or write "lever 2's row N". Use the note's "every carrier, listing, map and parameter". Add the two file names to the Chinese line.

8. **Minor. Order at landing.**
   - *Evidence.*
     - `amend_u4b.py` hashes REVIEW-U4B.md when it runs, and this section changes the file.
     - The study's Evidence sentence ("master_laws.py reads the amended record, nothing unverified or unplaced") is written before `master_laws.py` runs.
   - *Fix.* Run the amendment after the review's last change. Commit only if `integrate_u4.py check` and `master_laws.py`'s four lists pass.

**Verdict of the re-check.** The move of `SelectionLevels.rises_exact_iff_levels` stands. The counts are right, and the amendment's preconditions hold. Before landing:
- correct the bases' "counting" for `top` and `inactive` (finding 1);
- state the line by what a statement says of the dynamics, so that `carried_iff_rising` is covered exactly (finding 2).

The rest are wording.

### How the re-check's findings were taken

1 November 2026, by U4's owner. Every finding is taken.

1. **Taken.** The bases of rows 7, 8 and 14 now call only `unlowered`, `exact` and `moved` counting. `top` "orders the trait at the supported members", and `inactive` "makes the members of groups lower in the trait inactive"; each "so ties its values to the dynamics". "As in row 13" is gone. What keeps the three rows off standing 2 is named as their hypotheses on the trait's values, "as cancellation keeps lever 2's form `rises_cancel_iff_levels`". The note's §1 says the same once, and §3 names the counting hypotheses and the two that tie the trait to the dynamics.
2. **Taken.** The note's §1 states the line by what a statement says of the dynamics.
   - **Counting** says nothing of the dynamics beyond the arbitrary predicate of a counting law.
   - **Not counting** uses the dynamics in one of three ways: as a hypothesis (the gate and descent), in its conclusion (`carried_iff_rising`'s existential), or through a run's states (the `RegimeMargin` rows).
   - **Amounts** is the distance for a statement that uses the dynamics and constrains numbers.

   The same wording is in "Same partition", the test's docstring, DESIGN-BOUNDARY §8, the study's first Delta bullet and the board script's landed clause.
3. **Taken.** "The gate (K3's premises of the account) and descent in the flow", in the note, the bases and the study.
4. **Taken.** §3 says "the reason §1 rejects as a distance from counting". §1 says once that hypotheses on a trait's values are counting where the statement says nothing of the dynamics, keep a row off standing 2 beside the gate, and may tie the trait to the dynamics.
5. **Taken.** DESIGN-BOUNDARY §8 lists all seven passages.
6. **Taken.** The `RegimeMargin` reading now says that the run reaches 0 exactly where its start `x` is below `H + y`, in the note and in the study.
7. **Taken.**
   - The bases and the history line name declarations instead of lever 2's bare row numbers.
   - The history line says "every carrier, listing, map and parameter".
   - The Chinese line carries the two file names.
8. **Taken.** The amendment runs at landing, after this section, in `land_u4b.sh post`. It is followed by `master_laws.py` and `integrate_u4.py check`, and the stage stops at the first failure, so nothing is committed unless both pass. The study's Evidence sentence says that U4's check gates the landing.

## Third look

1 November 2026, of the fixes to the re-check's findings only. Read again:
- "How the re-check's findings were taken";
- the note's §1, §2's `RegimeMargin` row and §3;
- the bases of `SelectionTerm.Flow.support_not_lower`, `SelectionTerm.Flow.support_moved_rises` and `GroupEnding.Flow.rises_iff_inactive` in `make_record_u4.py`;
- DESIGN-BOUNDARY §8;
- `amend_u4b.py`'s history line (English and Chinese) and its study section;
- `counting_test.py`'s docstring;
- `board_u4b.py`'s landed clause.

The texts were checked against the Lean statements and lever 2's scratch.

**What holds.**
- Each of the eight fixes is in place as that section says.
- **The counts.** `make_record_u4.py --names` still gives counting 7 and amounts 18. `counting_test.py` marks only row 13 as differing, because the record is not yet amended.
- **The line.** "Says nothing of the dynamics beyond the arbitrary predicate of a counting law" is exact for the seven counting rows. Six of them reach nothing of the dynamics. `CensusWebs.keep_pace` reaches only its web and `Web.Arises` and `Web.Ceases`, as the predicate of `CountsAcross`. Each of the 18 amounts rows uses the dynamics in one of the note's three ways.
- **The bases.**
  - Rows 7 and 8: `unlowered`, `exact` and `moved` are hypotheses on the trait alone. `top` holds only at members where `W.Supported t p` holds (SelectionTerm.lean:672-673).
  - Row 14: `inactive` concludes `¬ W.active t p` (GroupEnding.lean:285-286).
- **Lever 2's form.** `rises_cancel_iff_levels` is lever 2's form for row 13 under cancellation. Its docstring calls it "Row 13 at its weakest hypothesis" (lever-2-scratch/Becoming/U4LeverTwo.lean:435-446; LEVER-2-AUDIT:72, :133).
- **The history line.** The Chinese line says what the English says: the move; "不言动力", for "says nothing of the dynamics"; every carrier, listing, map and parameter, with the same three declarations; the three rows kept at amounts, with the gate and descent as hypotheses, a trait's values constrained and their bases rewritten; and the two file names.

**Findings.**

1. **Minor. The three ways name one instance each, which reads as a complete list.**
   - *Evidence.* Note:18-20 gives one instance per way. Several amounts rows use the dynamics otherwise:
     - `Reproduction.Flow.number_within_take` takes dissipation, another of K3's premises;
     - `Flow.new_beyond_every` takes `Gainless`;
     - the frontier rows take hypotheses on `W.level`, `W.need` and `W.requires`;
     - `responses_le_missBound` has hypotheses (`start`, `into`) that bound an arbitrary `δ` and `inflow`, whose walk reaches nothing of the dynamics. It reaches the dynamics only through `carried` in its conclusion, an exchange law's levels (`ExchangeLaw.history`, `ExchangeLaw.levels`), which is a run, but not a `Law.run`.
   - *Fix.* Write "for example" before each instance. Write the third way as "a law's run (`Law.run` in the `RegimeMargin` rows, an exchange law's levels in `responses_le_missBound`)".
2. **Minor. A scratch form is named in record text with no pointer, and row 14 has a closer form.**
   - *Evidence.*
     - The three bases name `rises_cancel_iff_levels` (make_record_u4.py:225, :231, :238). It exists only in lever 2's scratch, and the record's text says nowhere where to find it.
     - Row 14's own lever 2 form is `rises_iff_inactive_on_root` (U4LeverTwo.lean:569-575). It carries `cancel` and `inactive`.
   - *Fix.* Write "lever 2's scratch form `rises_cancel_iff_levels` (LEVER-2-AUDIT §3)". Optionally, cite `rises_iff_inactive_on_root` for row 14.
3. **Minor. Row 14's basis says "the gate (K3's premises)", but row 14 has one of them.**
   - *Evidence.* Row 14's statement has `acting` and no `dependent` (GroupEnding.lean:281). So it uses one K3 premise, "only active relata give". Rows 7 and 8 have both.
   - *Fix.* Write "(K3's premise that only active relata give)" in row 14's basis.
4. **Minor. "Beside the gate" narrows a claim that holds generally.**
   - *Evidence.* The note (:31) says "Beside the gate, hypotheses on them keep a row off standing 2". Cancellation keeps `rises_cancel_iff_levels` off standing 2 with no gate, as the bases themselves say.
   - *Fix.* Drop "Beside the gate".
5. **Minor. The landed clause lacks a verb and does not count this look.**
   - *Evidence.* `board_u4b.py`'s clause reads "the record `one-root-to-its-edge` now {7} counting, {18} at amounts …".
   - *Fix.* Write "now places 7 counting, …". If this look's findings are counted, add them to "its re-check (K more)".

No finding is blocking or should-fix.

### How the third look's findings were taken

1 November 2026, by U4's owner. All five are taken.

1. **Taken.** Each of the note's three ways now gives "for example". The first adds dissipation and the frontier rows' hypotheses on levels and needs. The third reads "a law's run (`Law.run` in the `RegimeMargin` rows), or an exchange law's levels (`responses_le_missBound`)".
2. **Taken.**
   - The bases of rows 7 and 8 read "lever 2's scratch form `rises_cancel_iff_levels` (LEVER-2-AUDIT §3)".
   - Row 14's basis cites its own form: "cancellation and inactive keep its lever 2 scratch form `rises_iff_inactive_on_root` (LEVER-2-AUDIT §4)".
3. **Taken.** Row 14's basis reads "the gate's premise that only active relata give (K3)".
4. **Taken.** "Beside the gate" is gone. The note says that hypotheses on a trait's values keep a form off standing 2 with the gate or without it, and cites `rises_cancel_iff_levels`.
5. **Taken.** The landed clause reads "now places", and counts the re-check and this look together (13 more).
