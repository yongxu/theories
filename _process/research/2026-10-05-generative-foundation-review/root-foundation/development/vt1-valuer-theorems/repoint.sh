#!/bin/sh
# VT1: re-point the records drifting only by VT1's edits (Becoming.Weightings gained the net weightings, the rankings of
# presentations and the weights within a ratio, its earlier laws keeping their statements; chapter T5 and the record
# table (EN, ZH); THE-STEP-OF-INVARIANCE §5; OPENING [^good-evil]; the significance review's new section; the study
# section; read before re-pointing) and rebind Weightings' proof bindings to the VT1 receipt. The three records that cite
# Weightings by declaration were updated, with history notes, by make_records.py.
# usage (from the checkout root, after make_records.py): sh repoint.sh RECEIPT_ID
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "VT1: Becoming.Weightings gained the net weightings, the rankings of presentations and the weights within a ratio, its earlier laws keeping their statements (weighed_lt_of_widens, outweighs and neutral_ranks_by_number now derived); chapter T5, the relation to known results and the record table (EN, ZH), THE-STEP-OF-INVARIANCE §5, OPENING [^good-evil], the significance review and the study; read before re-pointing" \
  --drift-json "$D" \
  --receipt "$P/becoming-checks/$1/verification.json" --lean "$P/Becoming/Weightings.lean" --apply
rm -f "$D"
