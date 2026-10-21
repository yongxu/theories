#!/bin/sh
# SG5: after apply_text.py and make_record.py, re-point the records drifting only by SG5's chapter, study, review and
# package edits (read before re-pointing) and rebind the proof bindings of Becoming.Optimum (new laws appended, earlier
# laws unchanged in statement, level_add_drawn now a case of level_add_drawn_of_within, its header extended) to the SG5
# receipt.
# usage (from the checkout root): sh repoint.sh RECEIPT_ID
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "SG5 (courses ranked over a horizon, new laws of Becoming.Optimum): the chapter's sections 3.4 (the laws and their records), 7.1 (far-sight against the prior result), T3's standing, 8.1 item 10, the relation-to-known-results row 6, the record table and section 9's receipt and counts; Optimum's earlier laws unchanged in statement, level_add_drawn now the case of level_add_drawn_of_within, its header and reading extended; read before re-pointing" \
  --drift-json "$D" --receipt "$P/becoming-checks/$1/verification.json" --lean "$P/Becoming/Optimum.lean" --apply
rm -f "$D"
