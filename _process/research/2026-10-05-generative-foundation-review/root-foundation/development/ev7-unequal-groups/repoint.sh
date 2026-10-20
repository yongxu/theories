#!/bin/sh
# EV7: after apply_text.py and make_record.py, re-point the records drifting only by EV7's edits (read before
# re-pointing) and rebind the proof bindings of SelectionLevels.lean and GroupEnding.lean to the landing receipt.
# usage (from the checkout root): sh repoint.sh RECEIPT
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "EV7 (groups of any sizes and regrouping): SelectionLevels and GroupEnding gained the sized laws and witnesses, levels re-derived with its statement unchanged; the chapter's section 2.4 bullet, record table, section 8.1 item 9 and section 9, and the evolution chapter's summary and next connection 1; read before re-pointing" \
  --drift-json "$D" --receipt "$P/becoming-checks/$1/verification.json" \
  --lean "$P/Becoming/SelectionLevels.lean" "$P/Becoming/GroupEnding.lean" --apply
rm -f "$D"
