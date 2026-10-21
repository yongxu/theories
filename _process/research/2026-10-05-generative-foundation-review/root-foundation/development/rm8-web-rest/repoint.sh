#!/bin/sh
# RM8: after apply_text.py and make_record.py, re-point the records drifting only by RM8's chapter and package edits
# (read before re-pointing; the ids listed are exactly the check's source_drift at the landing) and rebind the proof
# bindings of Becoming.RegimeMargin (laws added; the pair-only within_draw, run_within, left_falls, still_of_left and
# step_of_left removed, coupled-regimes citing their web forms; the header extended) to the RM8 core receipt.
# usage (from the checkout root): sh repoint.sh RECEIPT_ID
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "RM8 (rest and points of no return on coupled webs, new laws of Becoming.RegimeMargin): the chapter's coupled-web paragraph, thesis T1's sentence, the record table and section 9's receipt and counts; RegimeMargin gained laws, five pair-only helpers removed (coupled-regimes now cites their web forms), its header extended; read before re-pointing" \
  --drift-json "$D" --ids coupled-regimes coupled-webs margin-of-a-regime regime-in-any-amounts regime-point-under-adjusting-giving threshold-in-the-state-plane where-a-run-of-a-regime-comes-to-rest widening-along-a-reading \
  --receipt "$P/becoming-checks/$1/verification.json" --lean "$P/Becoming/RegimeMargin.lean" --apply
rm -f "$D"
