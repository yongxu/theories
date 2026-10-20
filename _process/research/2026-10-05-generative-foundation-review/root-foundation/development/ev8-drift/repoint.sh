#!/bin/sh
# EV8: after apply_text.py and make_record.py, re-point the records drifting only by EV8's edits (read before
# re-pointing) and bind Drift.lean's proofs to the landing receipt.
# usage (from the checkout root): sh repoint.sh RECEIPT
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "EV8 (drift, offspring sampled rather than listed): the new core module Becoming.Drift joined to the root and the checker scope; the chapter's section 2.4 bullet, record table, section 8.1 item 9 and section 9, and the evolution chapter's summary, recovery row and next connection 3; read before re-pointing" \
  --drift-json "$D" --receipt "$P/becoming-checks/$1/verification.json" \
  --lean "$P/Becoming/Drift.lean" --apply
rm -f "$D"
