#!/bin/sh
# RM10: after apply_text.py and make_record.py, re-point the records drifting only by RM10's chapter and package edits
# (read before re-pointing; the ids listed are exactly the check's source_drift at the landing) and rebind the proof
# bindings of Becoming.RegimeMargin (laws added; RM9's bounded laws now stated for any law read condition by condition,
# the web's step an instance; run_alike derived from run_alike_of; the header extended) to the RM10 core receipt.
# usage (from the checkout root): sh repoint.sh RECEIPT_ID
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "RM10 (webs with a recent giving, new laws of Becoming.RegimeMargin): the chapter's coupled-web paragraph, thesis T1's sentence, the record table and section 9's receipt and counts; RegimeMargin gained laws, RM9's bounded laws now take a law read condition by condition (the web's step an instance, their content for the web unchanged), run_alike derived from run_alike_of, its header extended; read before re-pointing" \
  --drift-json "$D" --ids coupled-regimes coupled-webs margin-of-a-regime regime-in-any-amounts regime-point-under-adjusting-giving rest-on-coupled-webs threshold-in-the-state-plane thresholds-beyond-a-band where-a-run-of-a-regime-comes-to-rest widening-along-a-reading \
  --receipt "$P/becoming-checks/$1/verification.json" --lean "$P/Becoming/RegimeMargin.lean" --apply
rm -f "$D"
