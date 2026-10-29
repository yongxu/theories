# UE16: what free-energy minimization does not guarantee (draft notes)

29 October 2026. AI-written notes on the draft kit for board item UE16, item 1 of [FEP-INTEGRATION](../ue-unified-explanation/FEP-INTEGRATION.md) §3. **The drafting record**, kept as it was before the review: the module as landed, its counts and its names are [NOTE.md](NOTE.md)'s, after the review ([REVIEW-UE16](REVIEW-UE16.md)).

## The kit

- **Module.** [`tree/Becoming/FreeEnergyGuarantees.lean`](tree/Becoming/FreeEnergyGuarantees.lean), `Becoming.FreeEnergyGuarantees` (name kept). It imports `Becoming.Commuting` and `Becoming.Exclusion`, and `Becoming.Continuation` comes in through `Exclusion`.
- **Final build** ([scratch-6.log](scratch-6.log)): **51 theorems in 74 declarations, every axiom report empty, no warnings.**
- **Earlier builds.** scratch-1 failed on `Option.noConfusion`'s new signature, fixed by `nomatch`. In scratch-3, `nomatch` on Nat literal equations brought in `propext`, fixed by `Nat.noConfusion`.
- **Tactics.** No `simp`, `omega`, `funext`, `decide`, `by_cases` or `Classical`.

## The laws

**A. Identical cells** (candidate 1, `IdenticalCells`)

- **The step.** A configuration is the list of the cells' states. The step `descent update field` moves every cell by one rule, from its own state and its field.
- **Commuting.** Where the field is `Exchangeable`, as the field of the other cells is (`othersField_exchangeable`), the step commutes exactly with exchanging cells `k` and `k + 1` (`descent_commutes`).
- **Instances of the commuting law.** `keeps_exchange_fixed` is `Law.Commutes.keeps_fixed`. `exchanged_run` is `iterate`, and `rests_exchanged` follows from it.
- **Alike cells stay alike.** `two_alike_stay_alike` and `all_alike_stay_alike`, through `alike_along`: both cells exist and are alike at every step.
- **Minima.** `freeEnergy_symmetric`, `minimum_exchanged`, `unique_minimum_alike` and `apart_not_unique`.
- **Witness `Parting`.** Each cell moves one unit away from the other's expectation, staying put at a tie.
  - From any `[a, a]` the free energy is 6 at every step (`alike_never_minimal`, by `two_alike_stay_alike`).
  - `[1, 2]` reaches `[0, 3]` and `[2, 1]` reaches `[3, 0]` (`parts`, `exchanged_parts`).
  - No configuration is the unique minimum (`minima`).

**B. Risk and needs** (candidate 2, `RiskAndNeeds`)

- **The chooser.** A `Chooser` has actions (amounts taken), a model `predict`, and a preferred level. Its risk is the `deviation` of the prediction from the preferred level. `chosen` is the first action of least risk (`chosen_minimizes`, `chosen_mem`).
- **`need_ends`** (`Flow.outrun_below`, `Flow.outrun_ends`). Whatever chooser gives a member's takes, the level stays below `m` from `T + n` on, and the dependent member is inactive.
- **`restraint_unread`** (`Flow.outrun_reading_alike`). Readings after the end score the risk-minimizing course and the restrained course alike.
- **`expectation_not_course`.** Where a choice predicts, at zero risk, a level of at least `m`, the level reached is below that prediction. This separates the paper's gloss, an expectation under the model, from a guarantee.

**C. Shared models** (candidate 3, `SharedModels`)

- **The forager.** The `forager` reads its own store, uses 2 units and prefers a store of 3. It takes 2 at zero risk, and its store is kept (`forager_choice`, `store_kept`). `Exceeding`'s takes are its choices (`exceeding_choices`).
- **`alike_not_one`.** The same forager, with the same readings and choices, ends in `Exceeding`: within its own draw, in joint excess, all members end from step 2. In `Alone` it continues. This is by `Exceeding.own_not_joint`, `Exceeding.all_end` and `Alone.all_continue`.
- **`OneGoal`** (one witness, not a law). Both takers read the shared level and prefer it at 4 (`regulator`). They take 2, then 0, by turns. The draw is in excess at step 0, yet all three members stay active (`continues`).

## Deviations from the brief

- **Lists, not functions.** With configurations as lists, `Law.Commutes` is equality of configurations, with no function extensionality. So `keeps_fixed` and `iterate` apply as stated, and no congruence hypothesis is needed. The one pointwise step is the Prelude's `map_eq_of`.
- **Neighbouring exchanges only.** Other transpositions are not stated.
- **`Flow.joint_excess_ends` does not fit `Exceeding`.** It needs a start below `n + m`, but `Exceeding` starts at level 4 with only two steps of excess. The ending is `Exceeding.all_end`, derived through `Flow.stays_below`.
- **Added beyond the brief.** `expectation_not_course`, `alike_never_minimal` and `OneGoal`.
- **No Part B witness.** The outrun premises say nothing of the member's takes, and any sequence of takes is some chooser's choices.

## What is new

- **Applications, not results.** `keeps_exchange_fixed`, `exchanged_run`, `need_ends` and `restraint_unread` apply landed laws. In `need_ends` and `restraint_unread` the chooser hypotheses are unused, and that is their content.
- **New.** `descent_commutes` and the cell-reading lemmas, the elementary minima lemmas, the chooser, `expectation_not_course` and the witnesses.
- **Standing.** These are known results in the principle's terms: Curie (1894) and Turing (1952) for A, and the commons (Lloyd 1833; Hardin 1968) for B and C.

## Refutation conditions

- **A.** The reading fails if the paper's scheme, run from identical expectations with no noise, differentiates. That would mean a cell-indexed term in the descent. Running it is the search's cheap frozen check.
- **B and C.** The readings fail for agents without a shared gated renewal, or with preferences over joint outcomes, as `OneGoal` shows.

## Left out

- **The principle's apparatus.** Densities, variational free energy, ambiguity and epistemic terms, softmax and precision, multi-step policies, learning, blankets, continuous time and noise (UE17 to UE19, or the periphery).
- **Landing work.** Records, home sections and the change to UE1's record, after review.
