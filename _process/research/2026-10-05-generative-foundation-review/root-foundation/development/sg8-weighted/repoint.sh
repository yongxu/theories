#!/bin/sh
# SG8: after apply_text.py and make_record.py, re-point the records drifting only by SG8's chapter, study, review and
# package edits (read before re-pointing) and rebind the proof bindings of Becoming.Optimum (new laws appended, earlier
# laws unchanged in statement, its header, reading and limits extended) to the SG8 receipt.
# usage (from the checkout root): sh repoint.sh RECEIPT_ID
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "SG8 (an order weighting later draws less, new laws of Becoming.Optimum): the chapter's sections 3.4 (the laws and their records), 7.1 (far-sight keeps the own base only where the weighting falls slower than renewal), T3's standing, 8.1 item 10, the relation-to-known-results row 6, the record table and section 9's receipt and counts; Optimum's earlier laws unchanged in statement, its header, reading and limits extended; read before re-pointing" \
  --drift-json "$D" --receipt "$P/becoming-checks/$1/verification.json" --lean "$P/Becoming/Optimum.lean" --apply
rm -f "$D"
