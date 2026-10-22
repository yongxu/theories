#!/bin/sh
# UM: after apply_text.py and make_record.py, re-point the records drifting only by UM's chapter and package edits
# (read before re-pointing; the ids listed are exactly the check's source_drift at the landing) and rebind the proof
# bindings of Becoming.Optimum and Becoming.RegimeMargin to the UM core receipt on the tree merged with main.
# usage (from the checkout root): sh repoint.sh RECEIPT_ID
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "UM (one model of drawers in turn and one law of exact thresholds): the chapter's sections 2.3, 3.4 and 7.1, row 6, item 10, the record table and section 9; Optimum's drawers replaced by one model, its other laws unchanged; RegimeMargin's threshold laws derived from one law, their statements unchanged; both headers extended; read before re-pointing" \
  --drift-json "$D" --ids a-step-coupling-keeps-at-every-horizon a-weighting-faster-than-renewal-ends-the-base any-number-of-drawers-in-turn coupled-regimes coupled-webs drawers-in-turn-draw-everything drawers-in-turn-within-capacities horizon-optima-hold-the-greatest-renewal keeping-forgoes-the-renewal-at-the-need margin-of-a-regime optima-rebuild-a-depleted-base others-drawing-first-end-the-base raising-what-couples-in-draws-from-beyond re-optimizing-above-a-renewal-ends-it regime-in-any-amounts regime-point-under-adjusting-giving rest-on-coupled-webs revision-comes-to-drawing-everything room-read-off-the-exchange several-optimizers-drain-by-their-joint-capacity steps-met-again-after-a-fall threshold-in-the-state-plane thresholds-beyond-a-band valuing-what-is-left-at-any-worth valuing-what-is-left-at-the-horizon webs-with-a-recent-giving what-a-rise-draws-from-beyond what-an-optimum-does-beyond-what-couples-in where-a-run-of-a-regime-comes-to-rest widening-along-a-reading \
  --receipt "$P/becoming-checks/$1/verification.json" --lean "$P/Becoming/Optimum.lean" "$P/Becoming/RegimeMargin.lean" --apply
rm -f "$D"
