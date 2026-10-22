#!/bin/sh
# IF1 and RP1: re-point the records drifting only by IF1/RP1's edits (Entropy, SelectionReach, DrawnBeyond and Optimum
# gained the graded laws and the race for position, the gainless laws now derived as their case, no statement changed;
# chapter §3.4 rows and theorem map; OPENING [^race]; read before re-pointing) and rebind the four modules' proof
# bindings to the IF1/RP1 receipt.
# usage (from the checkout root): sh repoint.sh RECEIPT_ID
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "IF1 and RP1: Entropy, SelectionReach and DrawnBeyond gained the laws graded by the inflow, their gainless laws now derived as the case of no inflow with statements unchanged; Optimum gained InTurn's race for position and its web readings; chapter §3.4 rows and theorem map, OPENING [^race]; read before re-pointing" \
  --drift-json "$D" \
  --receipt "$P/becoming-checks/$1/verification.json" --lean "$P/Becoming/Entropy.lean" "$P/Becoming/SelectionReach.lean" "$P/Becoming/DrawnBeyond.lean" "$P/Becoming/Optimum.lean" --apply
rm -f "$D"
