#!/bin/zsh
# WL3 landing, from the checkout root of the WL3 worktree with main merged in (main green, the queue's head landed):
#   zsh land.sh check            # integrate, the core checker (writes the receipt), connectivity's apart roots
#   (register the apart roots it lists: register.py)
#   zsh land.sh text N           # texts with study section N, chapter rebuild, records, section 9, render, check, links, test
set -e
D=_process/research/2026-10-05-generative-foundation-review/root-foundation
K=$D/development/wl3-wen-grammar
Z=$D/development/zhonghua
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
case $1 in
check)
  python3 -B $K/integrate.py
  (cd $P && python3 -B check_becoming.py) > $K/checker.log 2>&1
  python3 -B $D/THEOREM-CONNECTIVITY.py --check > $K/connectivity.log 2>&1 || true
  grep "apart roots without" $K/connectivity.log | cut -c1-3000 || true
  ;;
text)
  N=$2
  R=$(python3 -c "import json;print(json.load(open('$P/becoming-verification.json'))['utc'])")
  MAIN=$(git rev-parse --short=9 HEAD)
  python3 -B $D/THEOREM-CONNECTIVITY.py --check > $K/connectivity.log 2>&1
  python3 -B $K/apply_text.py $N $R > $K/apply_text.log
  python3 -I $Z/wenli/make_chapter.py
  python3 -I $Z/build_tables.py
  python3 -B $K/section9.py $R $MAIN $N
  python3 -B $K/make_records.py $R $N > $K/make_records.log
  make research-render > $K/render.log 2>&1 || true
  python3 -I $Z/verify_zh.py > $K/verify_zh.log 2>&1
  # read each drifting source first (RESULT-WORKFLOW, "Hashes"); re-point only drift caused by these edits
  python3 -B tools/research/research.py check > $K/drift.json 2>/dev/null || true
  ;;
finish)
  python3 -B $D/THEOREM-CONNECTIVITY.py --write > $K/connectivity_write.log 2>&1
  make research-render > $K/render.log 2>&1
  make research-check > $K/check.log 2>&1 || true
  make research-links > $K/links.log 2>&1
  make research-test > $K/test.log 2>&1
  ;;
esac
