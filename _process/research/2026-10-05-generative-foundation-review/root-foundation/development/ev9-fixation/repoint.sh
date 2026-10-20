#!/bin/sh
# EV9: after apply_text.py and make_record.py, re-point the records drifting only by EV9's edits (read before
# re-pointing) and bind Drift.lean's proofs to the landing receipt.
# usage (from the checkout root): sh repoint.sh RECEIPT
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "EV9 (fixation by drift): Becoming.Drift gained many sampled generations; the chapter's section 2.4 Drift bullet, record table, section 8.1 item 9 and section 9, and the evolution chapter's drift bullet, recovery row and next connection 3; read before re-pointing" \
  --drift-json "$D" --receipt "$P/becoming-checks/$1/verification.json" \
  --lean "$P/Becoming/Drift.lean" --apply
rm -f "$D"
