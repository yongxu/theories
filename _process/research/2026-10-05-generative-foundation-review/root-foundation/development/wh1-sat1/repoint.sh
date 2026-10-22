#!/bin/sh
# WH1 and SAT1: after apply_text.py and make_records.py, re-point the records drifting only by WH1's and SAT1's edits
# (the chapter's §2.2 paragraph on the wholes, §2.6 law of saturation, record links, the record table and section 9; the
# ZH map's five entries and its chapter's §八; Becoming.Wholes and Becoming.Frequency gaining laws, none changed), read
# before re-pointing, and rebind the proof bindings of the two modules to the WH1/SAT1 core receipt.
# usage (from the checkout root): sh repoint.sh RECEIPT_ID
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "WH1 and SAT1 (a whole of every part and a graded whole, new laws of Becoming.Wholes; a coupling saturated by what it has carried, new laws of Becoming.Frequency): the chapter's §2.2 paragraph on the wholes and §2.6 law of saturation with their record links, the record tables and section 9's receipt and counts; the ZH map's five gap entries and its chapter's §八; Wholes and Frequency gained laws and header text, no earlier statement changed; read before re-pointing" \
  --drift-json "$D" --receipt "$P/becoming-checks/$1/verification.json" --lean "$P/Becoming/Wholes.lean" "$P/Becoming/Frequency.lean" --apply
rm -f "$D"
