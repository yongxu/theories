# Record corrections for TR8 and TR9 (for RF's owner; drafts, not applied)

Both records belong to RF's owner, who changes them through the result workflow. A design gets no record of its own; these touch only `next_delta`.

## what-holding-for-a-reading-is-worth (RF-M.2): a misstatement

The record's `next_delta` names its test as "a frozen test of whether holding follows the model's two excesses". That narrows the Lean. The two excesses alone decide only for the reading that tells the situation (with nothing forgone, `held_gains_iff`; with an amount alone, `forgone_within_excess_iff`). For any reading rule, `threshold_go_iff` and `threshold_off_iff` compare the rule's shortfall plus the amount forgone with each excess, and through a map the least shortfall takes the rule's place (`through_threshold_iff`). TR8 tests that threshold, and ranks several readers by shortfall plus amount (`ListingValuation.forgone_lt_iff`).

Exact replacement, in the `en` field, of the clause

> a frozen test of whether holding follows the model's two excesses

by

> a frozen test of whether holding follows the threshold, the reading rule's shortfall and the amount forgone against each of the model's two excesses (threshold_go_iff, threshold_off_iff; through a map, the least shortfall, through_threshold_iff), designed as TR8 in experiments/formations-that-read/

and in the `zh` field, of 持是否随模型之二余之冻结检验 by

> 持是否随其阈之冻结检验：读之规则之所缺加所舍之量，对模型之二余（threshold_go_iff、threshold_off_iff；经映射者以最少所缺，through_threshold_iff），设计为 experiments/formations-that-read/ 之 TR8

[AI draft of the Chinese; for the owner to check against the record's other zh fields.]

## a-reading-informed-and-revalued (RF-M.3): no misstatement; an addition offered

The record's `next_delta` names no test, so nothing in it misstates TR9. If the owner wants the test named, as the RF-M.2 record names its own, a clause to add after "an institution's rule of reading;":

> a frozen test of whether a holding formation told the reading formation's listing, valuation, demonstration and update chooses among waiting, showing and giving values as the shortfall and the amounts rank, under the reading formation's current valuation and under a reference apart (TR9, after TR8, in experiments/formations-that-read/);

zh: 持之形成受告读之形成之列、值、示与更新者，是否于待、示与予值之间依所缺与所舍之量而择之冻结检验，于读之形成当下之值与另立之参照之下（TR9，继 TR8，见 experiments/formations-that-read/）； [AI draft]

No other field of either record is changed by the designs. A frozen run would later change their evidence and boundaries through the workflow.
