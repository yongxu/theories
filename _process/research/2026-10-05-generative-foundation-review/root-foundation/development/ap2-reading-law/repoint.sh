#!/bin/sh
# AP2: after apply_text.py and make_record.py, re-point the records drifting only by AP2's edits (read before
# re-pointing) and bind SelectionPool.lean's and Weightings.lean's proofs to the landing receipt.
# usage (from the checkout root): sh repoint.sh RECEIPT
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "AP2 (reading another's law; lexical priority within the class): Becoming.SelectionPool gained the anticipation laws and Becoming.Weightings lexical priority; the chapter's sections 6.5, 7.3, 7.7, 8.1 item 7 and 9, and THE-STEP-OF-INVARIANCE's sections 5, 6.5 and 8; read before re-pointing" \
  --drift-json "$D" --receipt "$P/becoming-checks/$1/verification.json" \
  --lean "$P/Becoming/SelectionPool.lean" "$P/Becoming/Weightings.lean" --apply
rm -f "$D"
