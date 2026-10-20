#!/bin/sh
# EV10: after apply_text.py and make_record.py, re-point the records drifting only by EV10's edits (read before
# re-pointing) and bind Drift.lean's proofs to the landing receipt.
# usage (from the checkout root): sh repoint.sh RECEIPT
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "EV10 (the additive part of Fisher's theorem): Becoming.Reproduction gained counted Cauchy-Schwarz and the additive bound; the chapter's section 2.4 Reproduction bullet, record table, section 8.1 item 9 and section 9, and the evolution chapter's summary, recovery row and next connection 2; read before re-pointing" \
  --drift-json "$D" --receipt "$P/becoming-checks/$1/verification.json" \
  --lean "$P/Becoming/Reproduction.lean" --apply
rm -f "$D"
