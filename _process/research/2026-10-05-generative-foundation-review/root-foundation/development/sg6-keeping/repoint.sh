#!/bin/sh
# SG6: after apply_text.py and make_record.py, re-point the records drifting only by SG6's chapter, study, review and
# package edits (read before re-pointing) and rebind the proof bindings of Becoming.Optimum (new laws appended, earlier
# laws unchanged in statement, drawn_add_shortfall and drawn_add_shortfall_after now cases of the laws on the steps
# counted, holding the case of holdingTo, two docstrings and its header extended) to the SG6 receipt.
# usage (from the checkout root): sh repoint.sh RECEIPT_ID
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "SG6 (what keeping a dependence forgoes over a horizon, new laws of Becoming.Optimum): the chapter's sections 3.4 (the laws and their records), 7.1 (the coupling far-sight outweighs), T3's standing, 8.1 item 10, the relation-to-known-results row 6, the record table and section 9's receipt and counts; Optimum's earlier laws unchanged in statement, drawn_add_shortfall and drawn_add_shortfall_after now cases of the laws on the steps counted, holding the case of holdingTo, two docstrings saying what is drawn, its header and reading extended; read before re-pointing" \
  --drift-json "$D" --receipt "$P/becoming-checks/$1/verification.json" --lean "$P/Becoming/Optimum.lean" --apply
rm -f "$D"
