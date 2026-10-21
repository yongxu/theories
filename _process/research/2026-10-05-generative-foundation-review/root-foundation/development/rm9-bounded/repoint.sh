#!/bin/sh
# RM9: after apply_text.py and make_record.py, re-point the records drifting only by RM9's chapter and package edits
# (read before re-pointing; the ids listed are exactly the check's source_drift at the landing) and rebind the proof
# bindings of Becoming.RegimeMargin (laws added; step_alike, run_alike and ends_alike now taking pointwise reading, their
# statements for mutual support unchanged in content; the header extended) to the RM9 core receipt.
# usage (from the checkout root): sh repoint.sh RECEIPT_ID
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "RM9 (thresholds beyond a band, new laws of Becoming.RegimeMargin): the chapter's coupled-web paragraph, thesis T1's sentence, the record table and section 9's receipt and counts; RegimeMargin gained laws, step_alike, run_alike and ends_alike now take pointwise reading (mutual support passes its case), its header extended; read before re-pointing" \
  --drift-json "$D" --ids coupled-regimes coupled-webs margin-of-a-regime regime-in-any-amounts regime-point-under-adjusting-giving rest-on-coupled-webs threshold-in-the-state-plane where-a-run-of-a-regime-comes-to-rest widening-along-a-reading \
  --receipt "$P/becoming-checks/$1/verification.json" --lean "$P/Becoming/RegimeMargin.lean" --apply
rm -f "$D"
