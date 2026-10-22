#!/bin/zsh
# FL2 landing (from the checkout root on main, the kit in place):
#   zsh land.sh lean    # copy the module in and join it to the package (integrate.py); commit the Lean and module text
#   zsh land.sh check   # the core checker (writes the receipt), then connectivity
#   zsh land.sh text    # register, landing text, records, render (then read drift, repoint, checks)
set -e
D=_process/research/2026-10-05-generative-foundation-review/root-foundation
K=$D/development/fl2-continuity
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
case $1 in
lean)
  FL2_ROOT=$PWD python3 -B $K/integrate.py
  ;;
check)
  (cd $P && python3 -B check_becoming.py) > $K/checker.log 2>&1
  python3 -B $D/THEOREM-CONNECTIVITY.py --check > $K/connectivity.log 2>&1 || true
  ;;
text)
  R=$(python3 -c "import json;print(json.load(open('$P/becoming-verification.json'))['utc'])")
  BASE=$(python3 -c "import json;print(json.load(open('$P/becoming-checks/$R/verification.json'))['source_commit']['main'])")
  python3 -B $K/register.py
  python3 -B $D/THEOREM-CONNECTIVITY.py --check > $K/connectivity.log 2>&1 || true
  python3 -B $K/apply_text_fl2.py $R $K/connectivity.log $BASE > $K/apply_text.log
  N=$(awk '/^STUDY_SECTION/ {print $2}' $K/apply_text.log)
  python3 -B $K/make_record.py $N $R > $K/make_record.log
  make research-render > $K/render.log 2>&1 || true
  make research-check > $K/check.log 2>&1 || true
  ;;
finish)
  make research-render > $K/render.log 2>&1
  make research-check > $K/check.log 2>&1
  make research-links > $K/links.log 2>&1
  make research-test > $K/test.log 2>&1
  python3 -B $D/THEOREM-CONNECTIVITY.py --write > $K/connectivity_write.log 2>&1
  ;;
esac
