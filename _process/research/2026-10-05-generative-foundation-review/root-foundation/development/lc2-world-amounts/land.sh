#!/bin/zsh
# LC2 landing, replayable when main moves with Lean (run from the checkout root, on a tree reset to main with the kit
# in place). Step 1 runs the checker; step 2 (after it passes) writes the text, the record, connectivity, the pages.
#   zsh land.sh check            # integrate and run the core checker
#   zsh land.sh text RECEIPT     # connectivity, landing text, records, render, repoint, render/check/links/test
set -e
D=_process/research/2026-10-05-generative-foundation-review/root-foundation
K=$D/development/lc2-world-amounts
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
case $1 in
check)
  python3 -B $K/integrate.py
  (cd $P && python3 -B check_becoming.py) > $K/checker.log 2>&1
  ;;
text)
  RECEIPT=$2
  BASE=$(git rev-parse HEAD)
  python3 -B $D/THEOREM-CONNECTIVITY.py --check --write > $K/connectivity.log 2>&1
  N=$(python3 -B $K/land_text.py $RECEIPT $K/connectivity.log $BASE | tee $K/land_text.log | awk '/^STUDY_SECTION/ {print $2}')
  python3 -B $K/make_record.py $RECEIPT $N
  make research-render > $K/render.log 2>&1 || true
  python3 - $K <<'EOF'
import sys; K = sys.argv[1]
t = open(f'{K}/render.log').read(); open(f'{K}/drift.json', 'w').write(t[t.index('{'):t.rindex('}') + 1])
EOF
  # read each drifting source first (RESULT-WORKFLOW, "Hashes"); the reason below names what LC2 changed
  python3 -B tools/research/repoint.py --reason "chapter changed by LC2 only in the modelling-choices row of section 0, the rest bullet and records line of 1.3, the theorem map row, the relation-to-known-results row 4, 8.1 item 6 and the section 9 receipt and counts; Becoming.LeastLoss changed only in the finite-reading law, generalized (list from T on, unrefuted form); nothing these records cite changed" \
    --drift-json $K/drift.json --receipt $P/becoming-checks/$RECEIPT/verification.json --lean $P/Becoming/LeastLoss.lean --apply > $K/repoint.log
  make research-render > $K/render.log 2>&1
  make research-check > $K/check.log 2>&1
  make research-links > $K/links.log 2>&1
  make research-test > $K/test.log 2>&1
  ;;
esac
