#!/bin/sh
# XL1/XL2: after land_xl1.py, land_xl2.py and own_refs.py, re-point the records drifting only by XL1's and XL2's text
# edits (chapter §0 blocks A and C, §8.1 items 1 and 6, §8.5, §8.9, T8; the study's two new sections; COVERAGE.json's
# premises and natural-number laws; read before re-pointing). usage (from the checkout root): sh repoint.sh
set -e
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "XL4 (requirement as the weakest sound reading, laws with noise, a web of rate one; Becoming.OverExchange and the periphery Representation): the chapter's section 0 block C, section 8.1 items 6 and 7, section 8.5 and section 8.9 (EN, ZH), the study's new section; no claim of the re-pointed records changed; read before re-pointing" \
  --drift-json "$D" --apply
rm -f "$D"
