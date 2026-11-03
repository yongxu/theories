# Returns in groups of unequal size (US)

Board item US, the coordinator's of 4 November 2026: 04 §7's Open item "the returns' among-group part for unequal sizes", and the record [selection-with-returns-to-groupmates](../../../../../../theories/becoming/results/records/selection-with-returns-to-groupmates.md)' Does not show. Reading time: eight minutes. AI-written.

## 1. What was open

For groups of equal size, [04 §5](../../../../../../theories/becoming/chapters/04-LIFE.md#r-selection-with-returns-to-groupmates) stated the returns kept and shared within the group at both levels and the whole's verdict through the spread among groups (`SelectionLevels.rises_iff_kept`). For groups of unequal size it stated the whole's verdict through a reading's covariation (`SelectionLevels.rises_iff_reading`), the size-weighted split of the selection term (`SelectionLevels.levels_sized`), and that the reading by totals misses selection among groups of unequal size (`SelectionLevels.ByMeans.by_means`). It did not state the returns' among-group part, or whether the verdict goes through the spread among groups.

## 2. Not a wrapper

The coordinator asked whether this is an instance of the existing Lean, needing only to be stated, or new Lean. It is new Lean. Among the groups' means, a group's mean offspring with `K` per unit of its mean amount is the base with `s + q n_g` per unit, `n_g` its size: the slope depends on the group's size, so no law of the equal-size form, in the spread among groups, carries over. What carries over is a covariation of what each member receives with the group means.

## 3. What is proved

All in the pure core (`Init` only), every axiom report empty (scratch builds of `SelectionLevels`, `RuleShaping`, `PairSelection` and `GroupEnding`; the landing's core receipt is the record's).

- `kept_balance`: on any list, where each member's weight with `k` per unit of its amount is a base with `s` per unit of the amount and `b` per unit of a reading, the weight's concordance with the amount, with `k` times its spread and `b` times the reading's discordance, is its discordance with `s` times the spread and `b` times the reading's concordance. From `returns_balance` and `combination_balance`, the balance of a combination of two readings.
- With `n` a positive common multiple of the groups' sizes, each group's factor `n` over its size, and what each unit kept shares reaching every member as `q` per unit of a reading `R` of the group: within each group by its factor, selection goes by `s` against `K` (`within_shared_by`); among the means by their factors (`n` times each mean), read member by member, by `s` against `K` with `n q` times the reading's covariation with them (`means_shared`); and the whole selects for keeping exactly where `K` times `n` times its spread, with `q` times the reading's discordance with the means by their factors, falls short of the same with `s` and the concordance (`rises_iff_shared_sized`, through `levels_sized`).
- Two readings, two modelling choices:
  - **Each member gaining `q` for every unit its group holds** (the reading the group's total; the equal-size laws' model): the verdict goes through the covariance, member by member, of a member's group total with its group's mean (`rises_iff_kept_sized`). With equal sizes `m` the total is `m` times the mean and this reads as `m q` times the spread among groups, the form `rises_iff_kept` states (a reading, not stated as a theorem from the sized law). With unequal sizes it is not a function of the whole's spread and the size-weighted spread of the means.
  - **What each unit kept gives its group divided among the members** (the reading `n` times the group's mean): the verdict goes through the size-weighted spread of the group means (`rises_iff_divided_sized`): over the rationals, where the amount varies, `K < s + Q ρ`, `Q = n q` what a unit gives its group, `ρ` the share of the variance, weighted by size, among the means; two listings give the same verdict through it only with the same `K`, `s` and `Q`.
- The witness (`Sized`): two keepers and two others, in groups of unequal size in both listings: the keepers as a pair and each of the others alone (`together`, `[[held, mate], [first], [second]]`), or each keeper alone and the others as a pair (`apart`, `[[held], [mate], [first, second]]`). With the factors two over the size, the whole's spread of keeping (4) and the size-weighted spread of the group means (16) are the same, all of the spread lying among the means. Each unit kept gives two to every other member of its group at a cost of one to its keeper (`b = 2`, `c = 1`, so returns to groupmates in Hamilton's form; with something kept, `K = 3`, `q = 2`, nothing coming back to the keeper alone, base four): together, each keeper leaves five and each other four, and the whole selects for keeping; apart, each keeper leaves three and each other four, and the whole selects against it (`either_verdict`). The covariance of a member's group total with its group's mean by its factor is 16 together and 8 apart. With what is shared divided, the two listings give one verdict for any returns the same in both (`divided_one_verdict`). The reader's enumeration found this pair; an earlier witness in groups of three and one had `q` above `K`, so `c = −1`, and was not a case of returns to groupmates (§7, finding 12).
- Shaping (02 §9): `RuleShaping.grouped_returns` holds for groups of any sizes, so `RuleShaping.grouped_rises_iff_sized` is the kept case for shaping. The same pair is a `Grouped` instance, a base of one, nothing coming back to a shaper alone, a cost of three and two to every member of its group for each shaper in it (`RuleShaping.Sized.together_grouped`, `apart_grouped`): within every group the rule after shaping disfavours the shapers, and the whole selects for shaping together and against it apart (`RuleShaping.Sized.either_verdict`).

## 4. Modelling choice

Which reading holds of actual groups is a premise. In the kept reading a larger group's members each gain `q` per keeper, so what a keeper gives grows with its group's size; in the divided reading what a unit gives its group is fixed and shared out. Hamilton's rule with `ρ` the share of the spread among group means is the divided reading's; read with the kept reading's returns on unequal groups, the share of the spread among means misleads, as the witness shows. Other readings of the group are stated only through `rises_iff_shared_sized`. The witness also depends on one step with the groups listed as given and their sizes fixed over it, and on the spread among groups read by the means weighted by size. Synergy, mixing beyond the listing and assortment over generations stay open.

## 5. Texts

04 §5 (the home) and §7, the record selection-with-returns-to-groupmates (law 7, hypotheses, Does not show, Next, a counterexample), a new record unequal-groups-not-decided-by-the-spread-among-groups for the witness, at its own anchor in 04 §5 beside the positive law, so that 04 §7's open item is closed both ways (what the verdict goes through, and the form it does not go through), 02 §9 and the record shaping-selected-among-groups (the equal-size limit narrowed to the spread form), ALIGNMENT A-10's groups bullet, the package README's SelectionLevels and RuleShaping rows, the two modules' docstrings, 08's receipt sentence.

## 6. Review

One AI reader other than the author checks the restatements in 04, 02, A-10 and the records against the Lean: [below](#7-the-readers-findings).

## 7. The reader's findings

One AI reader other than the author read the restatements in 04, 02, A-10, the package README, the records kit and the modules' docstrings against the Lean, in three rounds, and ran small enumerations of its own; it edited and built nothing. Twenty-seven findings; all were taken, as follows.

1. "Not a function of the spread among groups" was not shown by the witness: read by totals (`concordAmong`), the old witness's spreads differed (4 against 0). Now "not a function of the whole's spread and the size-weighted spread of the means" everywhere (04, 02, A-10, records, docstrings, README rows).
2. and 12. The first witness had `q = 2` above `K = 1` (`c = −1`), so it was returns kept, not returns to groupmates, and said nothing about Hamilton's rule. Replaced by the reader's pair, `b = 2`, `c = 1`, with both listings of unequal size (§3); the statement's `b` became `q` where it means the general form.
3. "Means" in the sized laws are means by their factors: "`n` times each mean" added.
4. "A common multiple" became "a positive common multiple" (`0 < n` is a hypothesis).
5. and 14. The divided reading's `K < s + Q ρ` holds over the rationals where the amount varies, with `Q = n q` and `ρ` weighted by size; one verdict for two listings needs the same `K`, `s` and `Q`, and `divided_one_verdict` is proved for this pair only. Qualifiers added; the record's statement now says "these two listings", and the law reads for others.
6. The equal-size reduction of the sized law is a reading, not a theorem: marked so here and, after the third round, in 04 ("a reading; no theorem derives one from the other").
7. 02's sentence mixed counts and rationals: rewritten in one register.
8. The shaping witness was "the same arithmetic", not a `Grouped` instance: `RuleShaping.Sized` added.
9. and 15. The Chinese said "does not select" where the English and the Lean say "selects against": now 「整体之选择逆于保留」 and 「其选择可向保留，亦可逆之」.
10. The old `Sized.small` docstring: replaced with the witness.
11. and 13. "Nothing kept" clashed with "keepers": now "nothing coming back to the keeper alone", with `s = 0` in the record's hypotheses.
16. 02's reading of the lever: at any sizes it is `s` with `q` times the covariance over the variance of shaping, against `c`; at equal sizes that is `m q ρ`.
17. An unused dictionary in the records kit removed.
18. The correspondence now says "of the two readings, which one holds", and names the total against per-capita benefit distinction as familiar, not news.

The third round read the new witness by hand (every number above checks) and found nine more, all taken:

19. 04 said the equal-size covariance is the spread form "as the law above states": `rises_iff_kept` states the spread form, not the identity; now marked a reading (item 6).
20. 04 had "each shaper's group gaining two", the divided reading; now each member gaining two for each shaper in its group, at a cost of three.
21. "The keepers in a pair beside each other alone" read as "beside each other": now "the keepers as a pair and each of the others alone, or each keeper alone and the others as a pair", and so for shapers, in 04, 02, the records, this note and the docstrings.
22. and 23. This section misreported items 1 and 6; corrected.
24. 02 and A-10 cited only `RuleShaping.Sized.either_verdict` for the same spreads, which `SelectionLevels.Sized.either_verdict` proves; both cited.
25. A-10's sentence lacked a verb; given one.
26. The record's statement named "these two listings" before any; now "the witness's two listings".
27. Outside the item: the package README's row for returns to groupmates said each unit kept gives `b` to every member and takes `c` from the keeper; with `K = b + c` it is every *other* member. Corrected in both languages.

## 8. Restatements read

Changed, as now shown false where read without a size: three restatements gave the group law with no size, and the witness has groups of unequal size with the same spreads and either verdict. Each now says "of equal size", the hypothesis of the law it states: [COLLECTIVE-DIRECTION](../../../../../../theories/becoming/COLLECTIVE-DIRECTION.md)'s loops paragraph, [the meta-attractor README](../../../../../../theories/meta-attractor/README.md)'s second-order note (both languages), and [02 §9](../../../../../../theories/becoming/chapters/02-MAP.md)'s summary of the second order. 02's other mentions name the law with its equal size or point to it.

Only less exact, for the board's batched section:

- The alignment dossier's ten-minute front, item 4: "Listed in groups of equal size whose shapers give the group's shared part … Hamilton's rule holds with s added, assortment as relatedness" stays true of the equal-size law it states. It does not say that at unequal sizes the verdict goes through the covariance of a member's group's shapers with its group's share of them, not the assortment ([02 §9](../../../../../../theories/becoming/chapters/02-MAP.md#r-shaping-selected-among-groups)). Proposed for the next edition, if the front's budget allows: "; at unequal sizes through a covariance, not the assortment ([A-10](#a-10))".
