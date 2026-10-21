#!/bin/sh
# RM3: after apply_text.py and make_record.py, re-point the records drifting only by RM3's chapter, study, review,
# README and package edits (read before re-pointing) and rebind the proof bindings of Becoming.LastChange (a law's run
# with a bounded mark: three laws added, its header extended) and Becoming.RegimeMargin (where a run comes to rest:
# laws added, none removed or changed in statement, its imports and header extended) to the RM3 receipt.
# usage (from the checkout root): sh repoint.sh RECEIPT_ID
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "RM3 (where a run of a regime comes to rest, new laws of Becoming.LastChange and Becoming.RegimeMargin): the chapter's section 2.3 (the rest law), thesis T2's standing, the record table and section 9's receipt and counts; the margin-measured README's MQ5 note; LastChange and RegimeMargin gained laws, none removed or changed in statement, their headers extended and RegimeMargin's imports with them; read before re-pointing" \
  --drift-json "$D" --receipt "$P/becoming-checks/$1/verification.json" --lean "$P/Becoming/RegimeMargin.lean" "$P/Becoming/LastChange.lean" --apply
rm -f "$D"
