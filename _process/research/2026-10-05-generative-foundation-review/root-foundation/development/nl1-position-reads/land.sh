#!/bin/zsh
# NL1 landing (run from the checkout root on main, the kit in place).
#   zsh land.sh check          # the core checker on the shared checkout
#   zsh land.sh text SECTION   # texts, opening v12, record, render (then read drift, repoint, checks)
set -e
D=_process/research/2026-10-05-generative-foundation-review/root-foundation
K=$D/development/nl1-position-reads
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
case $1 in
check)
  (cd $P && python3 -B check_becoming.py) > $K/checker.log 2>&1
  ;;
text)
  R=$(ls -t $P/becoming-checks | grep -v _objects | head -1)
  python3 -B $K/apply_text.py $2 $R > $K/apply_text.log
  python3 -B $K/opening_v12.py >> $K/apply_text.log
  python3 -B tools/research/research.py move --plan $K/move_v12.tsv --batch opening-v12 --apply > $K/move.log 2>&1
  python3 -B $K/make_record.py $2 $R > $K/make_record.log
  make research-render > $K/render.log 2>&1 || true
  ;;
esac
