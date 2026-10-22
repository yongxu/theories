#!/bin/sh
# UM2: re-point the records drifting only by UM2's chapter and package edits (read before re-pointing; the ids listed
# are exactly the check's source_drift at the landing) and rebind Becoming.Optimum's proof bindings to the UM2 receipt.
# usage (from the checkout root): sh repoint.sh RECEIPT_ID
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "UM2 (where floors bind, two drawers with no floor drain): the chapter's sections 3.4 and 7.1, row 6, item 10, the record row and section 9; Optimum's drain laws replaced by their general forms, its other laws unchanged, its header extended; read before re-pointing" \
  --drift-json "$D" --ids a-step-coupling-keeps-at-every-horizon a-weighting-faster-than-renewal-ends-the-base any-number-of-drawers-in-turn drawers-in-turn drawers-in-turn-draw-everything drawers-in-turn-within-capacities horizon-optima-hold-the-greatest-renewal keeping-forgoes-the-renewal-at-the-need optima-rebuild-a-depleted-base others-drawing-first-end-the-base raising-what-couples-in-draws-from-beyond re-optimizing-above-a-renewal-ends-it revision-comes-to-drawing-everything room-read-off-the-exchange several-optimizers-drain-by-their-joint-capacity steps-met-again-after-a-fall valuing-what-is-left-at-any-worth valuing-what-is-left-at-the-horizon what-a-rise-draws-from-beyond what-an-optimum-does-beyond-what-couples-in where-a-run-of-a-regime-comes-to-rest widening-along-a-reading \
  --receipt "$P/becoming-checks/$1/verification.json" --lean "$P/Becoming/Optimum.lean" --apply
rm -f "$D"
