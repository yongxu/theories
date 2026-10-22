#!/bin/sh
# EV13 and EV14: after apply_text.py and make_record.py, re-point the records drifting only by these edits (read before
# re-pointing) and bind Drift.lean's and Reproduction.lean's proofs to the landing receipt.
# usage (from the checkout root): sh repoint.sh RECEIPT
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "EV13-EV16 (selection in the draw; mutation; the breeding value; a dependence formed from drawing): Becoming.Drift gained the replacement chain, Becoming.Reproduction mutation and the breeding value, Becoming.Transmission the forming law where depending and drawing part; the chapter's section 2.4 Drift and Reproduction passages, record table, section 8.1 item 9 and section 9, and the evolution chapter's summary, recovery row and next connections 2 and 3; read before re-pointing" \
  --drift-json "$D" --receipt "$P/becoming-checks/$1/verification.json" \
  --lean "$P/Becoming/Drift.lean" "$P/Becoming/Reproduction.lean" "$P/Becoming/Transmission.lean" --apply
rm -f "$D"
