# U4, lever 2: evolution's rows on the root (audit)

30 October 2026, on main at `282fda08f`, branch `u4-lever-2`, read beside [lever 1's design](DESIGN.md) (`u4-edge` at `90716974d`). An AI audit for U4's owner, carried on its terms: this file and [lever-2-scratch/](lever-2-scratch/) only, no board edit, no package Lean, no record. U4's owner places it with lever 1's design, after one independent review of both. Nothing here is reviewed yet.

**What it covers.** The 18 central rows whose row is "evolution" in the latest grammar measure ([measure-grammar-after.json](../gw-generation-and-widening/measure-grammar-after.json)), taken from the file, not typed by hand. For each, it gives the standing U4 defines ([WHAT-REMAINS](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md), "One root to its edge"): derived; on the root under a hypothesis stated in the grammar's terms, with a countermodel showing it is needed; a premise; or the reason it stops short. What each row reads was found by reading its statement and proof. A check of the constants each declaration uses has not been run.

**The scratch.** [lever-2-scratch/Becoming/U4LeverTwo.lean](lever-2-scratch/Becoming/U4LeverTwo.lean), built with `scratch_build.py` against main: 42 theorems in 61 declarations, every axiom report empty. That is a working build, not a receipt.

## 0. The verdict in brief

Of the 18 rows, 7 can stand on the root without lever 1, and 11 wait on it.

- **Three are laws of counting** (`SelectionTerm.covariation`, `SelectionLevels.levels_sized`, `Drift.falls_back`). They hold of every finite family and every map to `Nat`, and read nothing a model supplies. Placing them is a choice for U4 (§2).
- **Three are on the root under hypotheses stated as inclusions** (`SelectionLevels.rises_exact_iff_levels`, `GroupEnding.Flow.rises_iff_inactive`, `GroupEnding.Flow.all_end`). The hypotheses:
  - Exact transmission is descent lying within its own continuation under the trait's class (`exact_iff_continues`, in scratch).
  - "Only active formations give" is giving lying within giving from an active formation (`acting_iff`).
  - Listed descent lies within giving (`listed_within_gives`).

  The witness that exact transmission is needed is in scratch (`Raised.levels_fail`). The witnesses for the other hypotheses are not built.
- **One is definitional** (`Web.transmits_at_iff`). U2 states it at the model as two inclusions. Its inheritance half is an inclusion now; its half on need reads amounts.
- **Eleven read the World's amounts:** need, level, stock, uptake, replenishment, balance, dissipation. They wait on lever 1. Most of their other hypotheses are the inclusions above. Beyond amounts, two need more: row 7 needs transmission's one-sided form (never lowering), and row 9 needs an injection from births to given units. The audit found nothing else in the way.

The central reading checks out in Lean. Each offspring carries its parent's amount exactly where every step of descent is a step of continuation under the trait's class. Price's two transmission terms both vanish exactly there. A pairing under the class, the most lever 1's count law reads, only makes them cancel (§3).

## 1. The rows

In the measure's order. "Inclusion" means a statement `«则» R S` on the grammar's relations.

| # | Row | Measure's category | What it reads | Proposed standing |
|---|---|---|---|---|
| 1 | `Flow.selection_within` | premise of the account | the gate; need and level (activity needs support) | waits on lever 1: needs and levels |
| 2 | `Flow.transmitted_supported` | premise of the account | the gate; transmission with need within δ | waits on lever 1 |
| 3 | `Flow.selected_le` | premise of the account | the gate; need and level | waits on lever 1 |
| 4 | `Web.transmits_at_iff` | definitional or representational | inheritance (an inclusion of requiring) and need within δ | definitional; U2 states it at the model as two inclusions (`ModelStatements.transmits_at_one_kind`); the half on need waits on lever 1 |
| 5 | `Flow.no_new_dependence` | balance, represented | balance at one relatum across a step, inheritance, coming to stand | waits on lever 1; its proof uses balance only to find a giver for what comes to stand, which the census reading would supply, so it is the nearest candidate (§5) |
| 6 | `SelectionTerm.covariation` | counting identity | a list and two maps to `Nat` | a law of counting (§2) |
| 7 | `SelectionTerm.Flow.support_not_lower` | premise of the account | the gate; support (need and level); transmission never lowering the trait | waits on lever 1 for support; "never lowers" is descent within the trait's order, an inclusion like §3's, not in scratch |
| 8 | `SelectionTerm.Flow.support_moved_rises` | premise of the account | as row 7, with exact transmission | waits on lever 1 for support; exact transmission as in §3 |
| 9 | `Reproduction.Flow.number_within_take` | premise of the account | dissipation on a family, descent, distinct offspring | waits on lever 1; U1's design (§4, in its workspace, not yet committed) names an injection from births to distinct given units as an obligation of its own, which the census reading would meet if each birth is a unit arising at the family and counted in what is given |
| 10 | `Reproduction.Flow.lineage_ends` | balance, represented | balance and dissipation on a family, its stock | waits on lever 1 |
| 11 | `Reproduction.Flow.closed_lineage_lowered` | balance, represented | as row 10, read by offspring number | waits on lever 1 |
| 12 | `SelectionLevels.levels_sized` | counting identity | lists of lists and maps to `Nat`, a common multiple | a law of counting (§2) |
| 13 | `SelectionLevels.rises_exact_iff_levels` | counting identity | listed generations (descent and a trait), exact transmission | on the root under exact transmission (§3); witness `Raised.levels_fail` |
| 14 | `GroupEnding.Flow.rises_iff_inactive` | premise of the account | the gate, descent, exact transmission, inactive lower groups | on the root under the gate, descent and exact transmission (§3, §4); witnesses for the gate and the inactive groups not built |
| 15 | `GroupEnding.Flow.family_childless` | balance, represented | balance, uptake and replenishment, stock, need | waits on lever 1 |
| 16 | `GroupEnding.Flow.coupled_end_together` | balance, represented | as row 15, for groups | waits on lever 1 |
| 17 | `GroupEnding.Flow.all_end` | premise of the account | the gate, descent, inactivity | derived on the root from two inclusions (`all_end_on_root`); witness for the gate not built |
| 18 | `Drift.falls_back` | law of its model | all courses of `n` binary draws, each weighted | a law of counting (§2); reading it as drift is the model's hypothesis |

Rows 1–3, 7 and 8 are "premise of the account" because of the gate. The gate has two parts: only active formations give, and activity needs support. The first part is an inclusion on the root (§4). The second reads support, which compares need with level, so it is an inclusion only once amounts are on the root. This is why those rows wait on lever 1 and rows 14 and 17, which use only the first part, do not.

## 2. Laws of counting

`SelectionTerm.covariation` holds for any list and any two maps to `Nat`, and `SelectionLevels.levels_sized` for any list of lists, with no premise but a common multiple. `Drift.falls_back` bounds a weighted total over all courses of `n` binary draws (`Typicality.courses`). None reads a Flow, a Web or a World. They are identities and bounds of the arithmetic the core imports, true of every finite family.

This poses a choice for U4. Its first standing, "derived", reads "from the grammar's laws, for every relation and class". These rows need no grammar law: they hold before any relation is read. The plan's own convention already counts a theorem naming nothing beyond the grammar and the prelude as on the root (WHAT-REMAINS, the correction note under "From no gap to the root"). Beyond the prelude's `total`, these three name list-and-number definitions of their own modules (`excess`, `weighted`, `concord`, `discord`, `whole`, `courses`, `fallsBack`), so they fall just outside that convention. The proposal: count a law of the arithmetic the core imports, holding of every finite family, as derived. Then say so in the boundary record, as one says the logic is the prelude's. The dependency check named above should confirm that their closure reaches no model before this is claimed.

`Drift.falls_back`'s reading as drift, offspring sampled with these weights, is a hypothesis of the model, not of the counting. The root can state it only once a weighting of courses is stated on it (the counting forms of probability on UE's line).

## 3. Exact transmission is continuation under the trait's class

`SelectionTerm.Exact ps kids a b` says that each offspring carries its parent's amount: `b k = a p` for every listed parent `p` and every `k` among its offspring. The scratch reads one step of descent on occurrences, `Bool × α`: a parent before the step, an offspring after it. Descent is read as condition (`descent`: the parent is among what the offspring comes from). The trait is a map to `Nat` (`trait a b`), and its sameness is a class (`alike_class`).

- **`exact_iff_within`:** exact transmission holds exactly where descent lies within sameness under the trait.
- **`exact_iff_continues`:** equally, exactly where descent lies within its own continuation under that class, `«则» D («续» D E)`. Every step of descent is a step of continuation. This is the root's definition of continuation read along descent: an occurrence is a condition of the next, and the two are alike under the class.
- **`exact_iff_terms_vanish`:** what transmission raised and what it lowered, Price's two transmission terms in counting form, are both zero exactly there.
- **`offspring_eq_selected_of_within`:** within the class, the offspring's total is the parents' amounts weighted by offspring number, Price's equation with no transmission term.
- **`Unexact`:** equal totals do not give exactness. One parent at 1 with two offspring at 0 and 2 has the offspring's total equal to the weighted total (`totals_alike`), and transmission is not exact (`not_exact`). The class reading is pointwise.
- **`Raised.levels_fail`:** the hypothesis is needed. One parent at 0 with one offspring at 1: the mean rises (`raises`), the levels' side is false (`levels_false`), so the equivalence of `rises_exact_iff_levels` fails without exact transmission. `Raised.listed` and `Raised.equal` show the row's other hypotheses hold there.

**Lever 1's count law, checked against this.** [Lever 1's design](DESIGN.md) (§2.2, on `u4-edge` at `90716974d`) proves two things. Under a class decided by a test, two lists are paired exactly where every class holds equally many of each (`«类之对当且仅当类类等数»`). A pairing under `«续» R E` keeps the count in every class of `E` (`«续之对则类类等数»`). Read on one step of descent, with the parents listed once for every offspring (`before`) and the offspring listed parent by parent (`after`), there are three strengths, each in Lean:

1. **Exact transmission:** descent lies within its continuation under the trait's class (`exact_iff_continues`). This gives the descent pairing under that continuation (`exact_pairs`). By `«续之对则类类等数»`, every class of the trait then holds as many parents, counted once per offspring, as offspring.
2. **A pairing under the trait's class:** by lever 1's law, equal count in every class. The offspring's values are the parents' values, counted once per offspring, in some order. This gives equal totals (`totals_of_paired`).
3. **Equal totals:** `offspring = selected`. By Price's equation in counting form, this holds exactly where the two transmission terms cancel, raised equal to lowered (`totals_iff_cancel`).

Neither step reverses.

- `Swap` has (2) without (1). Two parents at 1 and 2 have offspring that carry 2 and 1: they pair under the class (`Swap.paired`), transmission is not exact (`Swap.not_exact`), and each transmission term is one (`Swap.terms`).
- `Unexact` has (3) without (2). Its offspring at 0 and 2, against one parent at 1 counted twice, leave the classes 0, 1 and 2 with different counts.

So the count law does not make Price's transmission terms vanish. They vanish exactly at (1) (`exact_iff_terms_vanish`). A pairing under the class, the most the count law reads, makes them only cancel. The gap between (1) and (2) is that a pairing under the class may pair a parent with another parent's offspring. What exactness adds is that the pairing runs along descent. This is the sense of lever 1's design §2.2: a pairing reads more than counts only through a relation that is not a class, such as continuation. The leaf decides how the landed `offspring_eq_selected_of_within` goes: through `raised_exact` and `lowered_exact`, or through `exact_pairs`, the class law and `totals_of_paired`.

## 4. The gate as inclusions

- **`acting_iff`:** "only active formations give" (`Flow.Acting`) is, at every step, giving (`gives`: taking part and giving a positive amount, read by its sign) lying within giving from an active formation (`«而» (activeAt W t) (gives L t)`, activity read as a partial identity).
- **`listed_within_gives`:** for generations of descent, listed descent lies within giving.
- **`size_zero_of_within`:** from these two inclusions alone, a generation whose members are all inactive has no offspring.
- **`all_end_on_root`:** this is `GroupEnding.Flow.all_end`, its hypotheses entering only as the two inclusions.

Descent (`Flow.DescendsAt`) also asks that the offspring comes to stand, which reads the sign of its level. The inclusions here do not use that part.

The gate's second part, `Web.Dependent` (activity needs support), compares need with level, so it waits on lever 1 like the rows that use it.

## 5. What lever 1 would have to supply for the eleven rows

- needs and levels, compared (support: rows 1, 2, 3, 7, 8);
- balance at one relatum across a step (row 5);
- balance and dissipation on a family, and its stock (rows 9, 10, 11);
- uptake and replenishment against a stock (rows 15, 16).

Row 5 is the one most directly in reach. Its proof uses balance only to find a giver for what comes to stand: a level that was zero and is positive must have been given to. Under the census reading, units arising at the condition are counted in what is given, which is that step.

## 6. Not done

- Witnesses for the gate's inclusion in rows 14 and 17, and for row 14's inactive lower groups. Each is a small model: an inactive member that gives has an offspring.
- "Never lowers" (row 7) as descent within the trait's order, the one-sided form of §3. Not in scratch.
- The join of `exact_pairs` with lever 1's `«续之对则类类等数»`. It is one line once both are in one leaf, with the test deciding the trait's class (`alike_decided`, in scratch). It is not built here, because lever 1's scratch is a separate tree.
- The check of the constants each counting row uses (§2).
- One independent review, which U4's owner runs for both levers.

## 7. Modelling choices

One step of descent is read at a time, on `Bool × α`. Amounts and traits are natural numbers. Families and offspring are listed by `List`. Generations are those of `SelectionTerm.Generations`: a first family, offspring at each step, and a trait read at each step.
