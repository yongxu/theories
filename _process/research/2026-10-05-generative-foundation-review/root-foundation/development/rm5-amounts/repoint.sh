#!/bin/sh
# RM5: after apply_text.py and make_record.py, re-point the records drifting only by RM5's chapter, study, review,
# README and package edits (read before re-pointing) and rebind the proof bindings of Becoming.RegimeMargin (the regime
# in any amounts: laws added, none removed or changed in statement, its header extended) to the RM5 core receipt.
# usage (from the checkout root): sh repoint.sh RECEIPT_ID
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "RM5 (the regime in any amounts, new laws of Becoming.RegimeMargin and the periphery module RegimeReals): the chapter's section 2.3, thesis T2's standing, the record table and section 9's receipt, counts and periphery checks; the margin-measured README's MQ5 note; RegimeMargin gained laws, none removed or changed in statement, its header extended; read before re-pointing" \
  --drift-json "$D" --receipt "$P/becoming-checks/$1/verification.json" --lean "$P/Becoming/RegimeMargin.lean" --apply
rm -f "$D"
