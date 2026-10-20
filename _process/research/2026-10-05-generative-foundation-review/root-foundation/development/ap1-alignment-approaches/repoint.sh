#!/bin/sh
# AP1: after apply_text.py and make_record.py, re-point the records drifting only by AP1's edits (read before
# re-pointing) and bind SelectionPool.lean's, PoolResponse.lean's and Weightings.lean's proofs to the landing receipt.
# usage (from the checkout root): sh repoint.sh RECEIPT
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "AP1 (alignment approaches under the selection laws; reading another's couplings is pooling; widening as what every order increasing in admission shares): Becoming.SelectionPool gained the reading laws, Becoming.Weightings the class laws and PoolResponse's docstring a sentence; the chapter's sections 6.5, 7.3, 7.4, 7.7, 8.1 items 7 and 12, record table and section 9; read before re-pointing" \
  --drift-json "$D" --receipt "$P/becoming-checks/$1/verification.json" \
  --lean "$P/Becoming/SelectionPool.lean" "$P/Becoming/PoolResponse.lean" "$P/Becoming/Weightings.lean" --apply
rm -f "$D"
