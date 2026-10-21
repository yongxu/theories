#!/bin/sh
# RM7: after apply_text.py and make_record.py, re-point the records drifting only by RM7's chapter, study, review and
# package edits (read before re-pointing) and rebind the proof bindings of Becoming.RegimeMargin (a web of coupled
# conditions: laws added, none removed, RM6's pair laws keeping their statements with new proofs, its header extended) to
# the RM7 core receipt.
# usage (from the checkout root): sh repoint.sh RECEIPT_ID
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "RM7 (coupled webs, new laws of Becoming.RegimeMargin): the chapter's section 2.3, thesis T1's standing, the record table and section 9's receipt and counts; RegimeMargin gained laws, none removed, RM6's pair laws keep their statements with proofs read off the web's, its header extended; read before re-pointing" \
  --drift-json "$D" --receipt "$P/becoming-checks/$1/verification.json" --lean "$P/Becoming/RegimeMargin.lean" --apply
rm -f "$D"
