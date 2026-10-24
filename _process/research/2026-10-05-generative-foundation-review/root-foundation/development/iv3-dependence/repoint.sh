#!/bin/sh
# IV3: re-point the records drifting only by IV3's edits (Becoming.Weightings gained the route through dependence, its
# earlier declarations unchanged; THE-STEP-OF-INVARIANCE gained §4.4 and added lines in its other sections; the canonical
# chapter gained a bullet in §8.5 (EN, ZH) and §9's receipt and counts; the study, the significance review and the
# delegated choices gained sections; read before re-pointing) and rebind Weightings' proof bindings to the IV3 receipt.
# usage (from the checkout root, after make_records.py): sh repoint.sh RECEIPT_ID
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "IV3: Becoming.Weightings gained the route through dependence (centers within one another's closures, need and copies, orders increasing in their own continuation), its earlier declarations unchanged; THE-STEP-OF-INVARIANCE §4.4 and added lines, the canonical chapter §8.5 and §9, the study, the significance review and the delegated choices; read before re-pointing" \
  --drift-json "$D" \
  --receipt "$P/becoming-checks/$1/verification.json" --lean "$P/Becoming/Weightings.lean" --apply
rm -f "$D"
