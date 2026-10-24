#!/bin/sh
# XL1/XL2: after land_xl1.py, land_xl2.py and own_refs.py, re-point the records drifting only by XL1's and XL2's text
# edits (chapter §0 blocks A and C, §8.1 items 1 and 6, §8.5, §8.9, T8; the study's two new sections; COVERAGE.json's
# premises and natural-number laws; read before re-pointing). usage (from the checkout root): sh repoint.sh
set -e
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "XL1 and XL2 (the central laws over every relation of exchange, Becoming.OverExchange; what discrete steps and whole amounts represent, Becoming.WholeAmounts and the periphery Representation): the chapter's section 0 blocks A and C, section 8.1 items 1 and 6, section 8.5, section 8.9 and T8 (EN, ZH), the study's two new sections, COVERAGE.json's tying premises and natural-number laws; no claim of the re-pointed records changed; read before re-pointing" \
  --drift-json "$D" --apply
rm -f "$D"
