#!/bin/sh
# TI1: after apply_text.py and make_record.py, re-point the records drifting only by TI1's chapter edits (section 7.1's
# Training bullet and proxy paragraph, section 7.7's bullets and records, section 8.1 item 7, the relation to known
# results, the glossary row, the record table and section 9's receipt and counts; read before re-pointing).
# usage (from the checkout root): sh repoint.sh
set -e
K=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ti1-training-installs
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "TI1 (what training installs, new core module Becoming.Training): the chapter's section 7.1 Training bullet and proxy paragraph, section 7.7's coupling and response bullets and records, section 8.1 item 7, the relation to known results, the glossary row, the record table and section 9's receipt and counts (EN, ZH); no claim of the re-pointed records changed; read before re-pointing" \
  --drift-json "$D" --apply
rm -f "$D"
