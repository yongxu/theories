#!/bin/sh
# CA1: after apply_text.py and make_record.py, re-point the records drifting only by CA1's edits (read before
# re-pointing: the chapter's section 2.4 bullet, the record table, section 8.1 item 9 and section 9's receipt and
# counts, the evolution chapter's summary, recovery row 4 and next connection 1, OPENING's [^transitions]).
# usage (from the checkout root): sh repoint.sh
set -e
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "CA1 (what cancer is, and what keeps a part from turning back): a new module Becoming.Founding; the chapter's section 2.4 gained a Founding bullet, the record table a row, section 8.1 item 9 a stated clause and two open items, section 9 the receipt and counts; the evolution chapter's summary, recovery row 4 and next connection 1 a sentence each; OPENING's [^transitions] restated; no cited statement changed; read before re-pointing" \
  --drift-json "$D" --apply
rm -f "$D"
