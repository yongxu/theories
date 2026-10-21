#!/bin/sh
# RS1: after apply_text.py and make_record.py, re-point the records drifting only by RS1's chapter edits (section 4.4's
# ReadingSchedule bullet and records, section 7.3's "How often, and how many" bullet and records, the constraint table's
# row 7, the relation to known results, the record table and section 9's receipt and counts; read before re-pointing).
# usage (from the checkout root): sh repoint.sh
set -e
K=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rs1-reading-schedule
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "RS1 (one reader, several conditions, new core module Becoming.ReadingSchedule): the chapter's section 4.4 bullet and records, section 7.3's bullet on how often and how many and its records, the constraint table's row 7, the relation to known results, the record table and section 9's receipt and counts (EN, ZH); no claim of the re-pointed records changed; read before re-pointing" \
  --drift-json "$D" --apply
rm -f "$D"
