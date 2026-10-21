#!/bin/sh
# RM4: after apply_text.py and make_record.py, re-point the records drifting only by RM4's chapter, study, review,
# README and package edits (read before re-pointing) and rebind the proof bindings of Becoming.LastChange (a run has at
# most one rest: two laws added, its header extended) and Becoming.RegimeMargin (the threshold in the plane: laws added,
# none removed or changed in statement, its header extended) to the RM4 receipt.
# usage (from the checkout root): sh repoint.sh RECEIPT_ID
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "RM4 (the threshold in the plane of level and recent giving, new laws of Becoming.LastChange and Becoming.RegimeMargin): the chapter's section 2.3 (the threshold), thesis T2's standing, the record table and section 9's receipt and counts; the margin-measured README's MQ5 note; LastChange and RegimeMargin gained laws, none removed or changed in statement, their headers extended; read before re-pointing" \
  --drift-json "$D" --receipt "$P/becoming-checks/$1/verification.json" --lean "$P/Becoming/RegimeMargin.lean" "$P/Becoming/LastChange.lean" --apply
rm -f "$D"
