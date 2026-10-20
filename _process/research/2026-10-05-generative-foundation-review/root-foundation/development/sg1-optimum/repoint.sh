#!/bin/sh
# SG1: after apply_text.py and make_record.py, re-point the records drifting only by SG1's chapter edits (read before
# re-pointing). No existing Lean module changed, so no proof binding is rebound.
# usage (from the checkout root): sh repoint.sh
set -e
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "SG1 (what optimizing through couplings does beyond them, Becoming.Optimum): the chapter's sections 3.4 (a statement bullet and the in-words sentence), 7.1 (in words; prior statements of the proxy problem), 7.2 law 3, 8.1 item 10, the relation-to-known-results row 6, the record table and section 9's receipt and counts; additions and the law-3 sentence answered by DrawnBeyond; read before re-pointing" \
  --drift-json "$D" --apply
rm -f "$D"
