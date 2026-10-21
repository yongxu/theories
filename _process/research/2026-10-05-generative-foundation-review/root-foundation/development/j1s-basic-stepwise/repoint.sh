#!/bin/sh
# J1S: after apply_text.py and make_record.py, re-point the records drifting only by J1S's chapter, study, review and
# package edits (read before re-pointing) and rebind the proof bindings of Becoming.Ranking and Becoming.JointDraw (laws
# added, none removed; the whole-run monotonicity now reads a shared lemma, its statement unchanged; headers extended)
# to the J1S core receipt.
# usage (from the checkout root): sh repoint.sh RECEIPT_ID
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "J1S (the priority of basic conditions step by step, new laws of Becoming.Ranking): the chapter's ranking bullet in section 6, section 8.1's item 11, the record table and section 9's receipt and counts; Ranking and JointDraw gained laws, none removed, their headers extended; read before re-pointing" \
  --drift-json "$D" --receipt "$P/becoming-checks/$1/verification.json" --lean "$P/Becoming/Ranking.lean" --apply
rm -f "$D"
