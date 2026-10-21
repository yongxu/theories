#!/bin/sh
# RM6: after apply_text.py and make_record.py, re-point the records drifting only by RM6's chapter, study, review,
# README and package edits (read before re-pointing) and rebind the proof bindings of Becoming.RegimeMargin (coupled
# regimes: laws added, none removed or changed in statement, its header extended) to the RM6 core receipt.
# usage (from the checkout root): sh repoint.sh RECEIPT_ID
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "RM6 (coupled regimes, new laws of Becoming.RegimeMargin): the chapter's section 2.3, theses T1's and T2's standing, the record table and section 9's receipt and counts; the margin-measured README's note; RegimeMargin gained laws, none removed or changed in statement, its header extended; read before re-pointing" \
  --drift-json "$D" --receipt "$P/becoming-checks/$1/verification.json" --lean "$P/Becoming/RegimeMargin.lean" --apply
rm -f "$D"
