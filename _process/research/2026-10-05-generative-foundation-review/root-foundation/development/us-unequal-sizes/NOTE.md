# Returns in groups of unequal size (US)

Board item US, the coordinator's of 4 November 2026: 04 §7's Open item "the returns' among-group part for unequal sizes", and the record [selection-with-returns-to-groupmates](../../../../../../theories/becoming/results/records/selection-with-returns-to-groupmates.md)' Does not show. Reading time: eight minutes. AI-written.

## 1. What was open

For groups of equal size, [04 §5](../../../../../../theories/becoming/chapters/04-LIFE.md#r-selection-with-returns-to-groupmates) stated the returns kept and shared within the group at both levels and the whole's verdict through the spread among groups (`SelectionLevels.rises_iff_kept`). For groups of unequal size it stated the whole's verdict through a reading's covariation (`SelectionLevels.rises_iff_reading`), the size-weighted split of the selection term (`SelectionLevels.levels_sized`), and that the reading by totals misses selection among groups of unequal size (`SelectionLevels.ByMeans.by_means`). It did not state the returns' among-group part, or whether the verdict goes through the spread among groups.

## 2. Not a wrapper

The coordinator asked whether this is an instance of the existing Lean, needing only to be stated, or new Lean. It is new Lean. Among the groups' means, a group's mean offspring with `K` per unit of its mean amount is the base with `s + q n_g` per unit, `n_g` its size: the slope depends on the group's size, so no law of the equal-size form, in the spread among groups, carries over. What carries over is a covariation of what each member receives with the group means.

## 3. What is proved

All in the pure core (`Init` only), every axiom report empty (scratch builds of `SelectionLevels`, `RuleShaping`, `PairSelection` and `GroupEnding`; the landing's core receipt is the record's).

- `kept_balance`: on any list, where each member's weight with `k` per unit of its amount is a base with `s` per unit of the amount and `b` per unit of a reading, the weight's concordance with the amount, with `k` times its spread and `b` times the reading's discordance, is its discordance with `s` times the spread and `b` times the reading's concordance. From `returns_balance` and `combination_balance`, the balance of a combination of two readings.
- With `n` a common multiple of the groups' sizes, each group's factor `n` over its size, and what each unit kept shares reaching every member as `q` per unit of a reading `R` of the group: within each group by its factor, selection goes by `s` against `K` (`within_shared_by`); among the means, read member by member, by `s` against `K` with `n q` times the reading's covariation with them (`means_shared`); and the whole selects for keeping exactly where `K` times `n` times its spread, with `q` times the reading's discordance with the means, falls short of the same with `s` and the concordance (`rises_iff_shared_sized`, through `levels_sized`).
- Two readings, two modelling choices:
  - **Each member gaining `q` for every unit its group holds** (the reading the group's total; the equal-size laws' model): the verdict goes through the covariance, member by member, of a member's group total with its group's mean (`rises_iff_kept_sized`). With equal sizes `m` the total is `m` times the mean and this is `m q` times the spread among groups, `rises_iff_kept`'s form. With unequal sizes it is not a function of that spread.
  - **What each unit kept gives its group divided among the members** (the reading `n` times the group's mean): the verdict goes through the size-weighted spread of the group means (`rises_iff_divided_sized`): over the rationals `K < s + Q ρ`, `Q` what a unit gives its group, `ρ` the share of the variance among the means.
- The witness (`Sized`): two keepers and two others, in groups of three and one, either the keepers together (`[[held, mate, first], [second]]`) or one in each group (`ByMeans.unequal`). The whole's spread (4) and the size-weighted spread of the group means (12, with the factors three over the size) are the same. Each member gaining two for every unit its group keeps, at a cost of one to the keeper and nothing kept: together, the keepers leave three, their groupmate four and the member alone none, and the whole selects for keeping; one in each group, every member's group total is one, the keepers leave one and the others two, and the whole selects against it (`either_verdict`). With what is shared divided, the two listings give one verdict for any offspring meeting the same returns (`divided_one_verdict`).
- Shaping (02 §9): `RuleShaping.grouped_returns` holds for groups of any sizes, so `RuleShaping.grouped_rises_iff_sized` is the kept case for shaping; its witness is the same arithmetic.

## 4. Modelling choice

Which reading holds of actual groups is a premise. In the kept reading a larger group's members each gain `q` per keeper, so what a keeper gives grows with its group's size; in the divided reading what a unit gives its group is fixed and shared out. Hamilton's rule with `ρ` the share of the spread among group means is the divided reading's; read with the kept reading's returns on unequal groups, the share of the spread among means misleads, as the witness shows. Other readings of the group are stated only through `rises_iff_shared_sized`. Synergy, mixing beyond the listing and assortment over generations stay open.

## 5. Texts

04 §5 (the home) and §7, the record selection-with-returns-to-groupmates (laws 7 and 8, hypotheses, Does not show, Next, a counterexample), 02 §9 and the record shaping-selected-among-groups (the equal-size limit narrowed to the spread form), ALIGNMENT A-10's groups bullet, the package README's SelectionLevels and RuleShaping rows, the two modules' docstrings, 08's receipt sentence.

## 6. Review

One AI reader other than the author checks the restatements in 04, 02, A-10 and the records against the Lean: [below](#7-the-readers-findings).

## 7. The reader's findings

(Filled after the reading.)
