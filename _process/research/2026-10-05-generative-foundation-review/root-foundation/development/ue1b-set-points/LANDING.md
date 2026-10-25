# UE1b landing: what it needs

25 October 2026. AI-authored, for the lander (the briefing session). It lists what landing UE1b, part 1, takes. It writes no script and changes no file outside this folder. The kit is [NOTE.md](NOTE.md) with its tree ([SetPointOptimum](tree/Becoming/SetPointOptimum.lean), [Optimum](tree/Becoming/Optimum.lean)), as revised after [REVIEW-UE1b.md](REVIEW-UE1b.md), with every finding taken (NOTE §6). The build and the statement comparison are in [scratch.log](scratch.log).

## 0. Decisions

- **The rule 9 refactor of `Optimum` lands with UE1b.** Optimum's owner is inactive. So the lander decides to land it, as board rule 9 asks: the general law lands below its special cases, here in `Optimum` itself, and the rising laws become its corollaries.
  - The refactor changes three proofs and adds three theorems.
  - It changes no statement of `Optimum` or `RegimeMargin`, its only importer (scratch.log §3).
  - Record the decision in the commit message and on the board row.
- **Re-check.** An optional re-check that the revision closes the review's findings. The review asked for text fixes, renames and the refactor, all done, and its own probes are now in the kit.

## 1. Lean (package `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/`)

1. **`Becoming/Optimum.lean`**: replace it with [tree/Becoming/Optimum.lean](tree/Becoming/Optimum.lean).
   - sha256 before `3da737a6…31621d3f`, after `6b8c4e20…f9eaeb6dc`.
   - The diff:
     - `Above.full_of_ranked` is inserted before `Above.full`, `Above.floor_or_full_of_ranked` before `Above.floor_or_full`, and `beyond_of_ranked` after `above_nothing`.
     - The three rising laws become two-line corollaries.
     - Five lines are added to the module docstring under *Every optimum beyond, exactly*.
   - The bytes match the tree the review tested. The shared cache already holds its compile and audit steps, and those of `RegimeMargin` and the root over it.
2. **`Becoming/SetPointOptimum.lean`**: new, from [tree/Becoming/SetPointOptimum.lean](tree/Becoming/SetPointOptimum.lean), sha256 `cfe9340e…37a5a142`. It imports `Becoming.Optimum` and `Becoming.Regulation`. It is an L1 leaf.
3. **Root `Becoming.lean`.**
   - Add `import Becoming.SetPointOptimum`, for example after `import Becoming.RegimeMargin`.
   - Add a bullet, for example after `Becoming.RegimeMargin`'s:

     > * `Becoming.SetPointOptimum` (L1): what an order with a set point does beyond what couples in. An order nearing a set point of the family ranks above every outcome lying, at each condition, between the set point and the other, nearer at one (`Nearing`, by `Regulation.Between`); asymmetric, it is not rising (`Nearing.not_rising`). Where an eligible outcome reaches the set point every optimum stands at it (`atSetPoint_of_reach`), and nearing alone asks nothing more of what lies beyond (`optima_iff`, `least_at_iff`); below the set point the order rises and the drain of `Optimum` returns (`least_below_iff`; in an exchange `nearing_beyond`, from `Optimum.beyond_of_ranked`). In a balanced step in which the whole gains nothing the beyond falls by the set point's shortfall with the loss (`Flow.Balances.atSetPoint_draws`, exactly with one condition beyond `atSetPoint_broken_iff`), for several optimizers as for one with their joint set point (`Flow.Balances.mutual_atSetPoint_breaks`). A term counted after the set point leaves the most beyond, in total, that any way of reaching it leaves (`counted_after_most`); counting less, it drains; after an aspiration level it keeps too: the plateau decides, not the set point. Formations holding their levels take at least their loss and end a gated condition jointly (`Flow.held_draws`, `Flow.held_excess_ends`, from `Flow.joint_excess_ends`). A leaf: its laws are cases of `Optimum`'s, `DrawnBeyond`'s and `Continuation`'s on one class of orders, read on active inference (board item UE1b).

   - `Optimum`'s own bullet may add: "One law carries the drain read off the exchange: an optimum takes the whole capacity beyond wherever its order ranks the unit moved into the family above it (`Above.full_of_ranked`, `Above.floor_or_full_of_ranked`, `beyond_of_ranked`)."
4. **`check_becoming.py`.**
   - Add `"Becoming.SetPointOptimum"` to `CORE`, for example after `"Becoming.RegimeMargin"`.
   - Add a `SCOPE` sentence:

     > SetPointOptimum: an order nearing a set point of the family, ranking above every outcome lying between the set point and the other at each condition and nearer at one, is not rising where asymmetric; where an eligible outcome reaches the set point every optimum stands at it, and the optima of the class are exactly the eligible outcomes at the set point; below the set point it rises and the drain of Optimum returns, in an exchange by the whole capacity (from beyond_of_ranked); in a balanced step in which the whole gains nothing the beyond falls by the set point's shortfall with the loss, a dependence on one condition beyond breaking exactly where that exceeds its slack; a term counted after the set point leaves the most beyond in total that any way of reaching it leaves; formations holding their levels take at least their loss and end a gated condition jointly.

   - `Optimum`'s SCOPE sentence may name the general law.
5. **`README.md` and `README.zh.md`: an L1 row each** (draft; the ZH wording is the lander's to settle):
   - EN:

     ```text
     | L1 | [`Becoming.SetPointOptimum`](Becoming/SetPointOptimum.lean) | what an order with a set point does beyond what couples in (no premise beyond the hypotheses named): an order nearing a set point (`Optimum.Nearing`, by `Regulation.Between`) is not rising where asymmetric (`Optimum.Nearing.not_rising`); where the set point can be reached every optimum stands at it (`Optimum.atSetPoint_of_reach`) and the class asks nothing more of what lies beyond (`Optimum.optima_iff`, `Optimum.least_at_iff`); below it the drain returns (`Optimum.least_below_iff`, `Optimum.nearing_beyond`); the draw at the set point is the shortfall with the loss (`Flow.Balances.atSetPoint_draws`, `Flow.Balances.atSetPoint_broken_iff`), jointly as one (`Flow.Balances.mutual_atSetPoint_breaks`); counted after the set point, the most beyond in total (`Optimum.counted_after_most`, `Optimum.counted_after_keeps_iff`); holding a level takes at least the loss and ends a gated condition jointly (`Flow.held_draws`, `Flow.held_excess_ends`) |
     ```

   - ZH:

     ```text
     | L1 | [`Becoming.SetPointOptimum`](Becoming/SetPointOptimum.lean) | 有设定点之序在所耦合者之外所为（除所列假设外不加前提）：趋近设定点之序（`Optimum.Nearing`，以 `Regulation.Between` 定）凡不对称者皆非上升（`Optimum.Nearing.not_rising`）；设定点可及处，每个最优皆立于其上（`Optimum.atSetPoint_of_reach`），此类序于其外别无所求（`Optimum.optima_iff`、`Optimum.least_at_iff`）；设定点之下，抽取复现（`Optimum.least_below_iff`、`Optimum.nearing_beyond`）；在设定点所抽为其缺额连同损耗（`Flow.Balances.atSetPoint_draws`、`Flow.Balances.atSetPoint_broken_iff`），众者合抽如一（`Flow.Balances.mutual_atSetPoint_breaks`）；计于设定点之后者，留其外之总量最多（`Optimum.counted_after_most`、`Optimum.counted_after_keeps_iff`）；持其水平者至少取其损耗，合而终结受闸之条件（`Flow.held_draws`、`Flow.held_excess_ends`） |
     ```

   - `Optimum`'s L1 row may name the three general laws.
6. **The checker run.** Expect a core receipt with:
   - `Becoming.Optimum`: 506 theorems in 637 declarations (+3, +3);
   - `Becoming.SetPointOptimum`: 82 in 124;
   - `RegimeMargin` unchanged at 246 in 336;
   - every axiom report empty.

## 2. Records

1. **A new record.** Suggested id `what-a-set-point-optimum-does-beyond`; the id is the lander's choice.
   - *Statement:* the corrected wording of NOTE §3, without its last paragraph, which is a reading.
   - *Laws, each with its declarations:*
     1. orders nearing a set point and their relation to rising orders: `Optimum.Nearer`, `Nearing`, `nearing_of_gaps`, `byGap_nearing`, `Nearing.mono`, `Nearing.not_rising`, `not_rising_of_unbeaten`, `byGap_not_rising`, `byGapThen_not_rising`;
     2. at the set point: `atSetPoint_iff`, `atSetPoint_of_reach`, `mutual_atSetPoint`, `optima_iff`, `least_at_iff`;
     3. counted after: `byGapThen`, `byGapLess`, `counted_after_most`, `counted_after_keeps_iff`;
     4. below the set point: `nearer_iff_exceeds`, `Nearing.rises_below`, `least_below_iff`, `least_below`;
     5. the draw: `Flow.Balances.atSetPoint_draws`, `held_draws_lost`, `atSetPoint_breaks`, `atSetPoint_broken_iff`, `Flow.nearing_optimum_draws`, `mutual_atSetPoint_draws`, `mutual_atSetPoint_breaks`;
     6. the exchange: `transfer_nearer`, `nearing_beyond`, `nearing_as_rising`;
     7. holding and joint excess: `stock_eq_of_atSetPoint`, `Flow.held_draws`, `Flow.held_excess_ends`.
   - *Witnesses:* `Drain.atSetPoint_source`, `kept_iff`, `nearing_keeps`, `nearing_breaks`, `satisficingThen_keeps`; `Topped.nearing_either`, `rising_drains`, `counted_after_keeps`, `counted_less_drains`, `weighted_keeps`, `out_of_reach`; `Spread.counted_after_empties`; `Skew.nearing`, `Skew.not_by_gaps`; `TwoStores.jointly_broken`; `HeldPair.held_end`.
   - *Hypotheses and does-not-show:* NOTE §4.
   - *Correspondence* (cited from bibliographic knowledge; no source fetched):
     - Friston and others 2016: preferences as prior beliefs;
     - Keramati and Gutkin 2014: the homeostatic drive, a norm of the deviations;
     - Simon 1955: aspiration levels;
     - Taylor 2016: quantilizers, the choice among equal optima;
     - Zhuang and Hadfield-Menell 2020: the rising case, already cited by `what-an-optimum-does-beyond-what-couples-in`.
   - *Dependencies:* `what-an-optimum-does-beyond-what-couples-in`, `room-read-off-the-exchange`, `own-count-misses-joint-excess`, `what-a-rise-draws-from-beyond`, and the regulation record citing `Regulation.Between`, if one does.
   - *Proof bindings:* `SetPointOptimum.lean`, `Optimum.lean`, `Regulation.lean`, `DrawnBeyond.lean`, `Continuation.lean`, `Propagation.lean`, and the modules the record generator binds by default.
2. **The records to re-point, because `Optimum.lean`'s bytes change.** These 17 records bind `Becoming/Optimum.lean` at receipt `20261023T055339.893510Z`. Re-point each to the new core receipt; their statements and laws are unchanged:
   - `a-race-for-position-draws-everything`
   - `a-step-coupling-keeps-at-every-horizon`
   - `a-weighting-faster-than-renewal-ends-the-base`
   - `drawers-in-turn`
   - `horizon-optima-hold-the-greatest-renewal`
   - `keeping-forgoes-the-renewal-at-the-need`
   - `optima-rebuild-a-depleted-base`
   - `others-drawing-first-end-the-base`
   - `re-optimizing-above-a-renewal-ends-it`
   - `rest-by-balance`
   - `room-read-off-the-exchange`
   - `several-optimizers-drain-by-their-joint-capacity`
   - `steps-met-again-after-a-fall`
   - `valuing-what-is-left-at-any-worth`
   - `valuing-what-is-left-at-the-horizon`
   - `what-an-optimum-does-beyond-what-couples-in`
   - `where-a-run-of-a-regime-comes-to-rest`
3. **The records citing the three rising laws by name.**
   - `room-read-off-the-exchange`:
     - law 3 binds `Optimum.Above.full`, `Above.floor_or_full`, `above_nothing` and `optimum_beyond`; add `Optimum.Above.full_of_ranked`, `Above.floor_or_full_of_ranked` and `beyond_of_ranked`, which now carry the law;
     - add them to `references[0].declarations` too;
     - add a history line: "UE1b: `Above.full`, `Above.floor_or_full` and `optimum_beyond` are corollaries of `Above.full_of_ranked`, `Above.floor_or_full_of_ranked` and `beyond_of_ranked`, which take the ranked unit as hypothesis in place of the rising order (board rule 9); statements and this record's laws unchanged."
   - `re-optimizing-above-a-renewal-ends-it` and `several-optimizers-drain-by-their-joint-capacity` cite `optimum_beyond` or `Above.full` in their dependency details and references. Their texts stay true; the same history line is optional.

## 3. Chapter 05: the home section

- **Where.** In §7, after the paragraph of the optimum law ([`r-what-an-optimum-does-beyond-what-couples-in`](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#r-what-an-optimum-does-beyond-what-couples-in), ending "…without their continuous setting or updated proxy"), before `r-others-drawing-first-end-the-base`.
- **Anchor:** `r-` with the record id.
- **Draft**, to trim. In the chapter, `Optimum.` prefixes may be shortened as the chapter does elsewhere:

  > **Theorem** (any set of outcomes; the draw on the World, balance with the whole gaining nothing; the joint ending with activity needing support and only active giving, the gate local). *An order with a set point.* One outcome is *nearer* a set point of the family than another where at each condition of the family it lies between the set point and the other and at one is strictly nearer, whatever either holds beyond; an order is *nearing* where it ranks above every nearer outcome (`Optimum.Nearing`), single-peaked at the set point condition by condition. No asymmetric nearing order is rising (`Optimum.Nearing.not_rising`). Below the set point it rises: among outcomes up to the set point its optima stand at the least level beyond exactly where room holds there (`Optimum.least_below_iff`), and in an exchange every optimum below its set point takes the part's whole capacity beyond, where every rising optimum stands (`Optimum.nearing_beyond`, `Optimum.nearing_as_rising`, both from `Optimum.beyond_of_ranked`). Where an eligible outcome reaches the set point, every optimum stands at it, whatever the room (`Optimum.atSetPoint_of_reach`), and an outcome is an optimum of some nearing order exactly where it is eligible and at the set point (`Optimum.optima_iff`): the class asks nothing of what lies beyond. In a balanced step in which the whole gains nothing, the beyond then falls by exactly the family's shortfall from its set point with what the step loses (`Flow.Balances.atSetPoint_draws`); with one condition beyond, its dependence breaks exactly where that exceeds its slack (`Flow.Balances.atSetPoint_broken_iff`). Several nearing optimizers draw their joint shortfall, as one with their joint set point, and break a dependence beyond where it exceeds the slack, whatever each one's own (`Flow.Balances.mutual_atSetPoint_breaks`). A formation alone with its family, holding the family's stock, takes at least its loss from a condition (`Flow.held_draws`), so formations so holding, their losses together above what the rest gives, end a gated condition however small each one's loss (`Flow.held_excess_ends`, from `Flow.joint_excess_ends`); no choice enters.
  >
  > What protects at the set point is the choice among equal optima. Where the step can lose what it takes, the order by distance has the draining step among its optima beside the keeping one (`Topped.nearing_either`). A term on what lies beyond counted after the set point leaves it, in total, at the most any way of reaching the set point leaves (`Optimum.counted_after_most`). With one condition beyond, it keeps a need exactly where some way keeps it (`Optimum.counted_after_keeps_iff`); with several, it can empty one (`Spread.counted_after_empties`). Counting less, it drains (`Topped.counted_less_drains`). Counted after an aspiration level it keeps as well (`Drain.satisficingThen_keeps`); counted after a rising order with room it changes nothing (`Optimum.Rising.mono`, `Optimum.least_of_room`). The plateau decides, not the set point. Among the splits of three units, every optimum of every order nearing a store of `k` meets the dweller's need exactly where `k` is within the slack (`Drain.kept_iff`); a set point no open outcome reaches drains as a rising order does (`Topped.out_of_reach`); two holders, each within the renewal, end it (`HeldPair.held_end`). It does not show which optimum is taken, that preferences form a nearing order, or anything over a horizon under noise (record link `[record](../results/records/<id>.md)`, which resolves in the chapter).
  >
  > **Reading** [AI reading]. Active inference casts preferences as prior beliefs highest at the characteristic states; single-peaked at each observed condition, they form a nearing order. Such a chooser escapes the optimizer's drive at its set point, not the drain below it, nor joint excess. At its set point the class is undriven, and keeping depends on how the chooser picks among equal optima: mild optimization's point.

- **Thesis T3** (recommended). T3 forbids "where room exists, a side-effect term ranked after the reward protecting a condition". The clause concerns rewards rising with what they read. A sentence under *Standing* or *Forbids* keeps it exact: "Counted after an order with a plateau, a set point or an aspiration level, such a term decides within the plateau", linking the new home section (`#r-<id>`). The kit is no counterexample to T3, whose reward rises (REVIEW-UE1b, the section on satisficing).
- **Optional.**
  - The chapter's thesis line and *What this chapter does not show* may add the choice among equal optima, conflicting set points, and reserves under noise.
  - 08 §8 may list the correspondences (homeostatic reinforcement learning, aspiration levels, quantilizers) as restatements.

## 4. UE1's note

- **Leave `ue1-fep-bridge/NOTE.md` as it is.** Its record cites those bytes.
- **Update §2 of [NOTE-CORRECTIONS.md](../ue1-fep-bridge/NOTE-CORRECTIONS.md)** to the landed names (it predates the renames), for example:

  > **Corrected** (UE1b's review and the landed kit, `Becoming.SetPointOptimum`, record `<id>`).
  >
  > - An order nearing a set point is not rising where asymmetric (`Optimum.Nearing.not_rising`), so the optimum law does not reach it as stated. Below its set point it rises, and its optima drain as a maximizer's do (`Optimum.least_below`, `Optimum.nearing_beyond`).
  > - Where the set point can be reached, every optimum stands at it, and nearing alone asks nothing more of what lies beyond (`Optimum.optima_iff`). In a balanced step in which the whole gains nothing, the beyond falls by the family's shortfall from its set point with the loss (`Flow.Balances.atSetPoint_draws`).
  > - Where the step can lose what it takes, the set point alone does not protect what lies beyond: the order by distance has the draining step among its optima, beside the keeping one (`Topped.nearing_either`). A term on what lies beyond, counted after the set point, does protect it there (`Topped.counted_after_keeps`).
  > - That term leaves what lies beyond, in total, at the most any eligible way of reaching the set point leaves (`Optimum.counted_after_most`). With several conditions beyond, it can empty one of them (`Spread.counted_after_empties`). Counting less, it drains (`Topped.counted_less_drains`). After an aspiration level it keeps too (`Drain.satisficingThen_keeps`). What protects is how the choice among equal optima is made, not the set point.
  > - A formation holding its family's stock, by any means, takes at least its loss from what feeds it (`Flow.held_draws`), and joint excess applies to any such holders (`Flow.held_excess_ends`). That the holders are set-point choosers re-optimizing at every step is a reading.

- The UE1 record `capture-by-counted-choices` is unaffected.

## 5. Study, registries and generated pages

- **Study.** A section in `BECOMING-RENEWAL-READING.md`: the next free number, 410 after MA3a's 409 unless another lands first.
  - Title: "Set-point orders and the optimum: what an order with a point of enough does beyond what couples in (UE1b)".
  - Contents: the delta, the premises, the review and the refactor.
- **`regions.json`.**
  - The record: region `collective`, base `general`.
  - The module `Becoming.SetPointOptimum`: region `collective`, base `general`, a note.
  - `Becoming.Optimum`'s note: "503 thms" becomes 506.
- **Connectivity.** Register as apart roots the new declarations no record law reaches, mostly the witness worlds' hypothesis lemmas (`HeldPair.*`, `TwoStores.balances`, `TwoStores.gainless`, `Topped.idle_open`, `Topped.discarding_open`, `Topped.store_le_two`), and write `THEOREM-CONNECTIVITY`.
- **08.** The receipt and the counts.
- **Board.** The UE1b row to history, with the refactor decision.
- **Then:** `make research-render`, `research-check`, `research-links`, `research-test`.
  - Render in a clean worktree, as UE1's landing did.
  - The links check will meet this folder's relative links: NOTE.md links the chapter anchors that exist; LANDING.md links `NOTE-CORRECTIONS.md`.

## 6. Optional, not blocking

- **`Weightings.total_le_at_on`.** Move it down to `Dissipation`, beside `total_le_at`, and derive `Optimum.total_le_of_only` from it or drop it (review finding 17). Weightings' owner decides.
- **The prelude.** Move `Optimum.sub_le_sub_iff` and `Optimum.sub_lt_sub_iff` to `Naturals`, as R31's practice puts lemmas on Lean's numbers there (finding 17).
- **One evaluation of `transfer` on the family**, in `Optimum`, for `transfer_exceeds`, `transfer_above` and `transfer_nearer` (finding 17).
- **`MutualBest.full` and `mutual_beyond`.** Generalize them by the ranked unit, as the refactor did the one-part laws, reading several nearing optimizers below their set points off an exchange (finding 19). Optimum's owner decides; with the owner inactive, the lander may take it with this refactor or after.
