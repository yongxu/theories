# U4, lever 2: evolution's rows on the root (audit, reviewed)

30 October 2026. An AI audit for U4's owner, carried on its terms: this file and [lever-2-scratch/](lever-2-scratch/) only, no board edit, no package Lean, no record. Branch `u4-lever-2`, cut from main at `282fda08f`, read beside [lever 1's design](DESIGN.md) (reviewed; `u4-edge` at `487906dcc`).

**Review.** Reviewed once, independently ([REVIEW-U4-L2.md](REVIEW-U4-L2.md)): sound with fixes, one finding blocking. That finding was the tally of rows "waiting on lever 1". Every finding is taken (§9).

**What it covers.** The 18 central rows whose row is "evolution" in the latest grammar measure ([measure-grammar-after.json](../gw-generation-and-widening/measure-grammar-after.json)), taken from the file, not typed by hand. For each, it gives the standing U4 defines ([WHAT-REMAINS](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md), "One root to its edge"):
1. derived;
2. on the root under a hypothesis stated in the grammar's terms, with a countermodel showing it cannot be dropped;
3. a premise;

or else the distance at which it stops. What each row reads was found by reading its statement and proof.

**Scratch.** [lever-2-scratch/Becoming/U4LeverTwo.lean](lever-2-scratch/Becoming/U4LeverTwo.lean): 65 theorems in 90 declarations, every axiom report empty.
- It was built with `scratch_build.py`, by module name, in this branch's worktree, whose package equals main's at `282fda08f` ([log](lever-2-scratch/scratch-build.log); the log's `tree` is that worktree's path).
- §2's constant check is [constant-check.txt](lever-2-scratch/constant-check.txt): the script, how it was run, and its output.
- These are working builds, not receipts.

## 0. The verdict (reviewed)

Lever 1 found that balance is represented on the root, not derived ([design](DESIGN.md) §0):
- the round trip fails its second test;
- U1's verdict stands;
- no amounts come onto the root.

So no evolution row moves by waiting on lever 1. The standings are these.

| Rows | Standing |
|---|---|
| 4 | A law of logic, already stated at the model by U2 (`ModelStatements.inheritsAt_iff`, `needsWithinAt_iff`, `transmits_at_one_kind`) |
| 6, 12, 18 | Laws of counting, under a label of their own and counted apart (§2) |
| 5, 13, 14, 17 | On the root under stated hypotheses (standing 2). Witnesses are built for row 5 (`Ungiven`), row 13 (`Raised`) and row 17 (`Ungated`), not for row 14. Rows 13 and 14 conclude comparisons of counts, so their standing rides on §2 |
| 1, 2, 3, 7, 8 | The gate fully as inclusions: `acting_iff`, and U2's `dependent_iff` and `supported_iff` on `needMet`. Their conclusions compare the model's amounts, so they are statements at the represented model, as U2's are. Witnesses not built |
| 9 | Premise of the account: dissipation, and U1 §4's injection from births to given units |
| 10, 11, 15, 16 | Balance, represented, unchanged, for U1's reason, which lever 1 confirms |

What the Lean shows:

- **Exact transmission is descent within the trait's class.**
  - Price's two transmission terms vanish exactly there.
  - Read as continuation, this is a representation of U2's kind, not a derivation, since `within_iff_continues` holds for every relation and class.
- **The levels rows use only cancellation.**
  - Rows 13 and 14 need the two terms equal, not zero (`rises_cancel_iff_levels`, `rises_iff_inactive_on_root`).
  - Equal terms are the same as equal totals, the weakest of the three strengths in §3.
  - Exactness is one sufficient condition. A pairing under the class, the most lever 1's count law reads, is another.
- **Both parts of the gate are inclusions.**
  - So the gate rows can now "become hypotheses on the root", as WHAT-REMAINS expects (rows 1–3, 7, 8, 14, 17).
  - Each still needs its witness. Here one is built only for row 17.

## 1. The rows

In the measure's order. "Inclusion" means a statement `«则» R S` on the grammar's relations, at the represented model where its relations are read off the model's amounts (§4).

| # | Row | Measure's category | What it reads | Standing |
|---|---|---|---|---|
| 1 | `Flow.selection_within` | premise of the account | the gate; descent; dependence on one condition | at the model: the gate as inclusions; the conclusion compares weighted needs with the level |
| 2 | `Flow.transmitted_supported` | premise of the account | the gate; transmission with need within δ; descent | at the model: the gate and transmission as inclusions (U2's for transmission); the conclusion compares a need with a level plus δ |
| 3 | `Flow.selected_le` | premise of the account | the gate; descent; dependence on one condition | as row 1 |
| 4 | `Web.transmits_at_iff` | definitional or representational | `(A → B ∧ C) ↔ (A → B) ∧ (A → B → C)`, with A, B and C read as requiring, inheritance and need within δ | a law of logic, already stated at the model by U2 (`inheritsAt_iff`, `needsWithinAt_iff`, `transmits_at_one_kind`) |
| 5 | `Flow.no_new_dependence` | balance, represented | balance at one relatum across a step, used only to find a giver; inheritance; coming to stand | standing 2 under "coming to stand is given to" (`no_new_dependence_of_given`), witness `Ungiven` (§5) |
| 6 | `SelectionTerm.covariation` | counting identity | a list and two maps to `Nat` | a law of counting (§2); reaches no model constant |
| 7 | `SelectionTerm.Flow.support_not_lower` | premise of the account | the gate; a reading highest at the supported members; transmission never lowering (`loweredAt = 0`) | at the model: the gate as inclusions; "never lowers" as descent within the trait's order is not in scratch; the conclusion compares means |
| 8 | `SelectionTerm.Flow.support_moved_rises` | premise of the account | as row 7, with exact transmission | at the model, as row 7. Its proof uses exactness both as never lowering (`lowered_exact`, for `support_not_lower`) and as cancelling (`moved_by_selection`), and the two together are exactness (`exact_iff_terms_vanish`) |
| 9 | `Reproduction.Flow.number_within_take` | premise of the account | dissipation on a family; descent; distinct offspring | premise of the account: dissipation, and U1 §4's injection from births to distinct given units |
| 10 | `Reproduction.Flow.lineage_ends` | balance, represented | balance and dissipation on a family; its stock | balance, represented |
| 11 | `Reproduction.Flow.closed_lineage_lowered` | balance, represented | as row 10, read by offspring number | balance, represented |
| 12 | `SelectionLevels.levels_sized` | counting identity | lists of lists; maps to `Nat`; a common multiple | a law of counting (§2); reaches no model constant |
| 13 | `SelectionLevels.rises_exact_iff_levels` | counting identity | listed generations; exact transmission | standing 2 under cancellation (`rises_cancel_iff_levels`), witness `Raised`; reaches no model constant; rides on §2 |
| 14 | `GroupEnding.Flow.rises_iff_inactive` | premise of the account | the gate; descent; exact transmission; lower groups inactive (a comparison of trait sums) | standing 2 under the two inclusions, cancellation and the inactive hypothesis (`rises_iff_inactive_on_root`); witnesses not built; rides on §2 |
| 15 | `GroupEnding.Flow.family_childless` | balance, represented | balance; uptake and replenishment; stock; need | balance, represented |
| 16 | `GroupEnding.Flow.coupled_end_together` | balance, represented | as row 15, for groups | balance, represented |
| 17 | `GroupEnding.Flow.all_end` | premise of the account | the gate; descent; inactivity | standing 2 under the two inclusions (`all_end_on_root`), witness `Ungated` |
| 18 | `Drift.falls_back` | law of its model | all courses of `n` binary draws, each weighted | a law of counting (§2); reaches no model constant; reading it as drift is the model's hypothesis |

## 2. Laws of counting

`SelectionTerm.covariation` holds for any list and any two maps to `Nat`. `SelectionLevels.levels_sized` holds for any list of lists, with no premise but a common multiple. `Drift.falls_back` bounds a weighted total over all courses of `n` binary draws (`Typicality.courses`). They are identities and bounds of the arithmetic the core imports, true of every finite family.

**The constant check.** Rows 6, 12, 13 and 18 were checked: [constant-check.txt](lever-2-scratch/constant-check.txt), agreeing with the review's check of rows 6, 12 and 13.
- None reaches a constant of `Becoming.Flow`, `Web`, `World`, `Dependence`, `WebAt` or `Exchange`.
- Beyond the prelude, the grammar laws and their own modules' counting definitions, they reach only arithmetic:
  - `excess` (Change);
  - the top-level `total_*` lemmas placed in Flow.lean;
  - `total_const` (Evolution);
  - for row 18, Recurrence's `mem_cons_split` and Typicality's courses and weights.

They therefore meet the convention of WHAT-REMAINS's correction note ("name nothing beyond the grammar and the prelude, so they are on the root already") in substance, and miss it by file placement only. Moving `excess` and those lemmas to the prelude would close the gap, along with Typicality's courses for row 18. That move is for the owners of those modules, and is not proposed here.

**A label of their own.** They are not standing 1. Standing 1 is "it follows from the grammar's laws, for every relation and class", and these follow from no grammar law: they hold before any relation is read. The proposal:
- label them laws of counting: for every finite family and every map to `Nat`, reading no relation;
- count them apart, as F5's statements at a model are counted apart.

The line that keeps F13 coherent:
- a law of counting quantifies over every map to `Nat`;
- balance reads one model's levels.

So balance stays represented while laws of counting hold of every family. The choice is U4's owner's.

`Drift.falls_back`'s reading as drift, offspring sampled with these weights, is a hypothesis of the model, not of the counting. The root can state it only once a weighting of courses is stated on it (the counting forms of probability on UE's line).

## 3. Exact transmission, and the three strengths

`SelectionTerm.Exact ps kids a b` says that each offspring carries its parent's amount: `b k = a p` for every listed parent `p` and every `k` among its offspring. The scratch reads one step of descent on occurrences, `Bool × α`: a parent before the step, an offspring after it.
- Descent is built from the generations' lists (`descent`: the parent is listed and the offspring is among its listed offspring).
- The trait is a map to `Nat` (`trait a b`), and its sameness is a class (`alike_class`).

The scratch proves:
- **`exact_iff_within`:** exact transmission holds exactly where descent lies within sameness under the trait. This is `Exact` unfolded.
- **`exact_iff_continues`:** equally, exactly where descent lies within its own continuation under that class, `«则» D («续» D E)`.
  - This is `within_iff_continues`, true of every relation and class, so the continuation form adds nothing beyond "within the class".
  - It is a representation of U2's kind ("a representation, not a derivation", in ModelStatements' header), not a derivation.
- **`exact_iff_terms_vanish`:** what transmission raised and what it lowered, Price's two transmission terms in counting form, are both zero exactly there.
- **`offspring_eq_selected_of_within`** (scratch; no package declaration has this name): within the class, the offspring's total is the parents' amounts weighted by offspring number. This is Price's equation with no transmission term.

**The three strengths.** [Lever 1's design](DESIGN.md) §2.2 gives the count law of a class: under a class decided by a test, two lists are paired exactly where every class holds equally many of each (`«类之对当且仅当类类等数»`), that is, per-class counts. Read on one step of descent, with the parents listed once for every offspring (`before`) and the offspring listed parent by parent (`after`), there are three strengths, each in Lean:

1. **Exact transmission.** It gives the descent pairing under continuation relative to the trait's class (`exact_pairs`), and so a pairing under the class (`exact_paired_class`, by `«对之单调»`, without lever 1's tree).
2. **A pairing under the trait's class.** By lever 1's law this is equal count in every class: the offspring's values are the parents' values, counted once per offspring, in some order. The class's test is `Nat.beq` (`alike_decided`). It gives equal totals (`totals_of_paired`).
3. **Equal totals:** `offspring = selected`. By Price's equation in counting form, this is the two transmission terms cancelling, raised equal to lowered (`totals_iff_cancel`).

Neither step reverses:
- `Swap` has (2) without (1). Two parents at 1 and 2 have offspring that carry 2 and 1. They are paired under the class (`Swap.paired`), transmission is not exact (`Swap.not_exact`), and each term is one (`Swap.terms`).
- `Unexact` has (3) without (2). One parent at 1 has offspring at 0 and 2. The totals are equal (`Unexact.totals_alike`), and there is no pairing under the class (`unexact_not_paired`): the class of trait one holds the parent twice before the step and nothing after it.

So the count law does not make Price's transmission terms vanish. They vanish exactly at (1). A pairing under the class makes them only cancel. The gap between (1) and (2) is that a pairing under the class may pair a parent with another parent's offspring; exactness adds that the pairing runs along descent.

**Cancellation is what the levels rows use.**
- `SelectionTerm.Generations.raises_exact_iff` uses exactness only to make the terms cancel. `rises_cancel_iff` states it with cancellation.
- So `rises_cancel_iff_levels` is row 13 with exact transmission weakened to strength (3), which is read on counts. Swap-type generations meet row 13's equivalence without exactness.
- `Raised` shows that the hypothesis cannot be dropped altogether. With one parent at 0 and one offspring at 1:
  - the mean rises (`Raised.raises`);
  - the levels' side is false (`Raised.levels_false`);
  - the terms do not cancel (`Raised.not_cancel`; raised one, lowered none).
- Exact transmission as continuation is therefore one sufficient condition for rows 13 and 14, not what they need. For row 8 it is what the proof uses (§1).

## 4. The gate as inclusions

**The first part, "only active formations give".**
- **`acting_iff`:** `Flow.Acting` holds exactly where, at every step, giving lies within giving from an active formation, `«而» (activeAt W t) (gives L t)`. Here `gives` reads the sign of a `Nat` give, and `activeAt` is a partial identity.
- **`listed_within_gives`:** for generations of descent, listed descent lies within giving. This direction drops `Flow.DescendsAt`'s "comes to stand".

**The second part, "activity needs support".** This is already an inclusion in the package: U2's `ModelStatements.dependent_iff` (requiring from the active occurrences lies within `needMet`) and `supported_iff`.
- `needMet` reads `need ≤ level`, as `gives` reads `0 < give`. Both are relations read off the model's amounts, so both parts of the gate stand at the represented model together.
- Rows 1–3, 7 and 8 therefore have the whole gate as inclusions now. What remains of their content is their conclusions, which compare the model's amounts. That is the same situation as rows 13 and 14.
- U2 reads on occurrences (`Nat × X`, within a step), while `acting_iff` reads step by step on `X`. A leaf would state `acting_iff` in U2's occurrence form. That is not done here.

**From the two inclusions alone:**
- **`size_zero_of_within`, `all_end_on_root`:** a generation whose members are all inactive has no offspring. This is `GroupEnding.Flow.all_end` read on the root. It carries the content of `GroupEnding.Flow.inactive_childless` and `offspring_zero`.
- **`offspring_zero_within`, `ended_within`, `rises_iff_inactive_on_root`:** this is `GroupEnding.Flow.rises_iff_inactive`, with the gate and descent as the two inclusions and exact transmission weakened to cancellation. Its `inactive` hypothesis compares sums of the trait across groups, so it is not an inclusion.

**`Ungated`, the witness for row 17.** No formation is active, yet each gives to everything, and the offspring come to stand. Every hypothesis of `all_end` but the gate holds, and the generation after the inactive one is not empty (`Ungated.gate_needed`). The witnesses for rows 1–3, 7, 8 and 14 are not built.

## 5. Row 5: what comes to stand is given to

`Flow.no_new_dependence` uses balance only through `Flow.descends_of_comes`, which uses `Flow.BalancesOn.rise_given`: a level that was zero and is positive must have been given to.
- **`no_new_dependence_of_given`:** the row with balance replaced by the inclusion that coming to stand lies within being given to by something taking part.
- **`no_new_dependence_from_balance`:** balance is one way to meet that inclusion, and it gives the row back.
- **`Ungiven`:** a relatum comes to stand with nothing taking part and depends, after the step, on a condition nothing held before it. Inheritance and "nothing taking part depends on it" hold, and the inclusion fails (`Ungiven.not_given`).

The first version of this audit routed row 5 through the census: units arising at the condition are counted in what is given. That is lever 1's bridge equation, which lever 1's review (F1) found to be balance restated, and row 5 does not need it. Lever 1's design §5 still names row 5 as a candidate for that route.

## 6. What amounts on the root would need

U1's verdict stands (lever 1, §0). The numbers stay the root's second sort, and no row moves by waiting.

If amounts were on the root, these rows would need the following:
- **Rows 1–3, 7 and 8:** the comparison of need with level as a law of the root rather than a relation read off the model.
- **Row 9:** dissipation on a family, and an injection from births to given units.
- **Rows 10, 11, 15 and 16:** balance on a family, with its stock, uptake and replenishment.

Each would need a law of unit lines that holds over every pairing the counts admit and reads what they do not (lever 1, §6). None is known.

## 7. Not done

- The witnesses for rows 1–3, 7, 8 and 14.
- "Never lowers" (row 7) as descent within the trait's order, the one-sided form of §3.
- `acting_iff` in U2's occurrence form (§4).
- Moving the counting rows' arithmetic to the prelude (§2). This is for the modules' owners.

## 8. Modelling choices

- **One step of descent at a time,** read on `Bool × α`.
- **Amounts and traits** are natural numbers.
- **Families and offspring** are listed by `List`. The generations' lists may repeat members.
- **`before` lists each parent once per offspring.** That multiplicity makes `selected` appear.
- **`descent` is built from the generations' lists,** not from the World's `Flow.DescendsAt`:
  - row 13 has no World at all;
  - rows 14 and 17 join the World only through `SelectionTerm.Flow.Descended`.
- **`gives` reads the sign of a `Nat` give,** and `activeAt` is a partial identity. `listed_within_gives` drops "comes to stand".
- **The trait's class** is decided by `Nat.beq` (`alike_decided`).
- **Formations and conditions** are one type (`Flow X X`).
- **The witnesses** (`Ungated`, `Ungiven`) are worlds on `Bool` with levels equal to the step.

## 9. The review's findings and where each is taken

| Finding | Taken in |
|---|---|
| B1 (blocking): the tally "11 wait on lever 1" | §0 and §1, re-tallied as the review proposed, with "waits on lever 1" dropped. §6 rewritten as what amounts on the root would need, with U1's verdict standing. §4 says both parts of the gate are inclusions (U2's `dependent_iff`, `supported_iff`). Row 4 is a law of logic at the model. Row 5 is under an inclusion (§5) |
| S1: rows 13 and 14 rest on more than they use; row 14 has no Lean; `within_iff_continues` is general | §3 (`rises_cancel_iff`, `rises_cancel_iff_levels`; "cannot be dropped", with `Raised.not_cancel`). §4 (`rises_iff_inactive_on_root`). Rows 13 and 14 ride on §2. The continuation form is called a representation of U2's kind (§0, §3) |
| S2: counting laws as "derived"; the constant check | §2: a label of their own, counted apart; the check run for rows 6, 12, 13 and 18 ([constant-check.txt](lever-2-scratch/constant-check.txt)); the line that keeps F13 coherent |
| S3: `Unexact` "(3) without (2)" in prose only | `unexact_not_paired`, a core proof through `total_of_paired` (§3) |
| S4: row 17 labelled "derived"; its countermodel | Row 17 is standing 2 (§0, §1), with witness `Ungated` (§4) |
| S5: known package results not cited | `exact_paired_class` by `«对之单调»`; `dependent_iff`, `supported_iff`, `needsWithinAt_iff`, `inheritsAt_iff`; `inactive_childless` and `offspring_zero`; `descends_of_comes` and `BalancesOn.rise_given`; `raises_exact_iff` (§1, §3, §4, §5) |
| S6: unstated modelling assumptions | §8 |
| M1: "the landed `offspring_eq_selected_of_within`"; the build log's tree; l.65's wording | §3 says it is scratch. The header names the log's tree as this branch's worktree. §3 names `within_iff_continues` in place of l.65's wording |
