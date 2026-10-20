#!/bin/sh
# OB1: after apply_text.py and make_record.py, re-point the records drifting only by OB1's chapter edits (read before
# re-pointing) and rebind the proof bindings of Becoming.LevelCoupling (new laws appended, earlier ones unchanged) to
# the OB1 receipt.
# usage (from the checkout root): sh repoint.sh RECEIPT_ID
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "OB1 (what dependence alone carries of a level, new laws of Becoming.LevelCoupling): the chapter's sections 2.6 (the coupling-by-level paragraph, what is not derived, the readings and records), 5 (the supplied relation), 8.1 item 3, the record table and section 9's receipt and counts; LevelCoupling's earlier laws unchanged, its header extended; read before re-pointing" \
  --drift-json "$D" --receipt "$P/becoming-checks/$1/verification.json" --lean "$P/Becoming/LevelCoupling.lean" --apply
rm -f "$D"
