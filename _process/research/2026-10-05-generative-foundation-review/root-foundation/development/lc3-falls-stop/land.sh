#!/bin/zsh
# LC3 landing, replayable when main moves (run from the checkout root on a tree fast-forwarded to main, the kit in
# place). Rebuild the modules from main's sources first when main changed them:
#   zsh land.sh tree             # regenerate tree/ from main's LeastLoss and InAmounts with the edit scripts
#   zsh land.sh check            # join to the package and run the core checker
#   zsh land.sh text             # register, connectivity, landing text, records, render, repoint, render/check/links/test
set -e
D=_process/research/2026-10-05-generative-foundation-review/root-foundation
K=$D/development/lc3-falls-stop
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
case $1 in
tree)
  for m in LeastLoss InAmounts; do git show HEAD:$P/Becoming/$m.lean > $K/tree/Becoming/$m.lean; done
  python3 -B $K/edit_leastloss.py
  python3 -B $K/edit_inamounts.py
  python3 -B $K/edit_docs.py
  python3 -B $P/scratch_build.py $K/tree > $K/scratch.log 2>&1
  ;;
check)
  python3 -B $K/integrate.py
  (cd $P && python3 -B check_becoming.py) > $K/checker.log 2>&1
  ;;
text)
  R=$(ls -t $P/becoming-checks | head -1)
  BASE=$(python3 -c "import json;print(json.load(open('$P/becoming-checks/$R/verification.json'))['source_commit']['main'])")
  python3 -B $K/register.py
  python3 -B $D/THEOREM-CONNECTIVITY.py --check --write > $K/connectivity.log 2>&1
  python3 -B $K/land_text.py $R $K/connectivity.log $BASE > $K/land_text.log
  N=$(awk '/^STUDY_SECTION/ {print $2}' $K/land_text.log)
  python3 -B $K/make_record.py $R $N
  make research-render > $K/render.log 2>&1 || true
  # read each drifting source first (RESULT-WORKFLOW, "Hashes"); repoint.sh names the causes
  zsh $K/repoint.sh $R
  make research-render > $K/render.log 2>&1
  make research-check > $K/check.log 2>&1
  make research-links > $K/links.log 2>&1
  make research-test > $K/test.log 2>&1
  ;;
esac
