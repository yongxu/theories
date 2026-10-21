#!/bin/sh
# RM2: after apply_text.py and make_record.py, re-point the records drifting only by RM2's chapter, study, review,
# README and package edits (read before re-pointing) and rebind the proof bindings of Becoming.RegimeMargin (new laws
# over every adjustment of giving; RM1's laws on ending and holding unchanged in statement, each now the regime's case;
# the regime forms of 7 lemmas removed, their general forms in their place; its header extended) to the RM2 receipt.
# usage (from the checkout root): sh repoint.sh RECEIPT_ID
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "RM2 (the regime's point over every adjustment of giving, new laws of Becoming.RegimeMargin): the chapter's section 2.3 (the adjusted laws), thesis T2's standing and evidence, the record table and section 9's receipt and counts; the margin-measured README's MQ5 note; RegimeMargin's laws on ending and holding unchanged in statement, each now the regime's case, the regime forms of 7 lemmas removed with their general forms in their place, its header extended; read before re-pointing" \
  --drift-json "$D" --receipt "$P/becoming-checks/$1/verification.json" --lean "$P/Becoming/RegimeMargin.lean" --apply
rm -f "$D"
