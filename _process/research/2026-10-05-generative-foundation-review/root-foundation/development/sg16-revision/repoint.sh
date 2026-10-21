#!/bin/sh
# SG16: after apply_text.py and make_record.py, re-point the records drifting only by SG16's chapter and package edits
# (read before re-pointing; the ids listed are exactly the check's source_drift at the landing) and rebind the proof
# bindings of Becoming.Optimum (laws added; perfect_levels now the case of levels_of_zero; the header extended) to the
# SG16 core receipt.
# usage (from the checkout root): sh repoint.sh RECEIPT_ID
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "SG16 (how drawers in turn come to a mutual best response, new laws of Becoming.Optimum): the chapter's item 10, section 7.1's citation, the record table and section 9's receipt and counts; Optimum gained laws, perfect_levels now derived from levels_of_zero, its header extended; read before re-pointing" \
  --drift-json "$D" --ids a-step-coupling-keeps-at-every-horizon a-weighting-faster-than-renewal-ends-the-base drawers-in-turn-draw-everything horizon-optima-hold-the-greatest-renewal keeping-forgoes-the-renewal-at-the-need optima-rebuild-a-depleted-base others-drawing-first-end-the-base raising-what-couples-in-draws-from-beyond re-optimizing-above-a-renewal-ends-it room-read-off-the-exchange several-optimizers-drain-by-their-joint-capacity steps-met-again-after-a-fall valuing-what-is-left-at-any-worth valuing-what-is-left-at-the-horizon what-a-rise-draws-from-beyond what-an-optimum-does-beyond-what-couples-in where-a-run-of-a-regime-comes-to-rest widening-along-a-reading \
  --receipt "$P/becoming-checks/$1/verification.json" --lean "$P/Becoming/Optimum.lean" --apply
rm -f "$D"
