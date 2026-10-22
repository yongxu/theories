#!/bin/sh
# SG17: after apply_text.py and make_record.py, re-point the records drifting only by SG17's chapter and package edits
# (read before re-pointing; the ids listed are exactly the check's source_drift at the landing) and rebind the proof
# bindings of Becoming.Optimum (laws added; InTurn.step_ends, ends_at, perfect_ends and perfect_levels removed as the
# case k = 2 of the Many laws, the records citing them re-cited; Web.perfect_broken derived; the header extended) to the
# SG17 core receipt.
# usage (from the checkout root): sh repoint.sh RECEIPT_ID
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "SG17 (any number of drawers in turn, new laws of Becoming.Optimum): the chapter's section 3.4 and 7.1 sentences, item 10, the record table, section 9's receipt and counts, and its citations of the two drawers' perfect_ends and perfect_levels now the Many laws; Optimum gained laws, four two-drawer laws removed as the case k = 2, Web.perfect_broken derived with its statement unchanged, its header extended; read before re-pointing" \
  --drift-json "$D" --ids a-step-coupling-keeps-at-every-horizon a-weighting-faster-than-renewal-ends-the-base drawers-in-turn-draw-everything drawers-in-turn-within-capacities horizon-optima-hold-the-greatest-renewal keeping-forgoes-the-renewal-at-the-need optima-rebuild-a-depleted-base others-drawing-first-end-the-base raising-what-couples-in-draws-from-beyond re-optimizing-above-a-renewal-ends-it revision-comes-to-drawing-everything room-read-off-the-exchange several-optimizers-drain-by-their-joint-capacity steps-met-again-after-a-fall valuing-what-is-left-at-any-worth valuing-what-is-left-at-the-horizon what-a-rise-draws-from-beyond what-an-optimum-does-beyond-what-couples-in where-a-run-of-a-regime-comes-to-rest widening-along-a-reading \
  --receipt "$P/becoming-checks/$1/verification.json" --lean "$P/Becoming/Optimum.lean" --apply
rm -f "$D"
