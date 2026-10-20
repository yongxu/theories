#!/bin/sh
# EV11: after apply_text.py and make_record.py, re-point the records drifting only by EV11's edits (read before
# re-pointing) and bind SelectionLevels.lean's and GroupEnding.lean's proofs to the landing receipt.
# usage (from the checkout root): sh repoint.sh RECEIPT
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "EV11 (groups formed by descent): Becoming.SelectionLevels gained lineages and Becoming.GroupEnding the lineage laws on the base; the chapter's section 2.4 SelectionLevels bullet, record table, section 8.1 item 9 and section 9, and the evolution chapter's summary, recovery row and next connection 1; read before re-pointing" \
  --drift-json "$D" --receipt "$P/becoming-checks/$1/verification.json" \
  --lean "$P/Becoming/SelectionLevels.lean" "$P/Becoming/GroupEnding.lean" --apply
rm -f "$D"
