#!/bin/sh
# LU1: after land_text.py and update_record.py, re-point the records drifting only by LU1's chapter, study, review and
# package edits (read before re-pointing) and rebind the proof bindings of Becoming.ClosedCapture (four declarations
# added, unread_course's proof derived, statements unchanged, its header extended) to the LU1 receipt.
# usage (from the checkout root): sh repoint.sh RECEIPT_ID
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "LU1 (capture read as the part that makes sense alone, new laws of Becoming.ClosedCapture): the chapter's ClosedCapture bullet in section 4.5, T7's standing and the relation to known results (EN, ZH), section 9's receipt and counts; the significance review's observation check; ClosedCapture's earlier laws unchanged in statement, unread_course now derived from Law.sameFuture_of_goAlike, four declarations added, its header extended; read before re-pointing" \
  --drift-json "$D" --receipt "$P/becoming-checks/$1/verification.json" --lean "$P/Becoming/ClosedCapture.lean" --apply
rm -f "$D"
