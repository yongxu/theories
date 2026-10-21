#!/bin/sh
# SG10: after apply_text.py and make_record.py, re-point the records drifting only by SG10's chapter, study, review and
# package edits (read before re-pointing) and rebind the proof bindings of Becoming.Optimum (new laws over every law
# of what stands and on others drawing first; the earlier laws still read in the renewal form unchanged in statement,
# each now the case of its general form; the renewal forms of 26 lemmas and the definition drawable removed, their
# general forms in their place; its header, reading and limits extended) to the SG10 receipt.
# usage (from the checkout root): sh repoint.sh RECEIPT_ID
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "SG10 (over every law of what stands, new laws of Becoming.Optimum): the chapter's sections 3.4 (the laws over every law of what stands and on others drawing first, and their records; two lemmas cited by their general forms), 7.1 (others drawing first end what far-sight alone rebuilds), 8.1 item 10, the relation-to-known-results row 6, the record table and section 9's receipt and counts; Optimum's earlier laws still read in the renewal form unchanged in statement, each now the case of its general form, the renewal forms of 26 lemmas and the definition drawable removed with their general forms in their place, its header, reading and limits extended; read before re-pointing" \
  --drift-json "$D" --receipt "$P/becoming-checks/$1/verification.json" --lean "$P/Becoming/Optimum.lean" --apply
rm -f "$D"
