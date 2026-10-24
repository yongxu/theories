#!/bin/zsh
# OU4 + OU5 landing in a fresh worktree at main's HEAD. usage: zsh land45.sh W L
set -e
W=$1; L=$2; mkdir -p $L
RF=_process/research/2026-10-05-generative-foundation-review/root-foundation
K4=$RF/development/ou4-map; K5=$RF/development/ou5-testing; K6=$RF/development/ou2-candidates
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
cd /Users/ren/theories && git worktree add --detach $W HEAD > /dev/null
cd $W
OU_ROOT=$W python3 -B $K4/integrate3.py
OU_ROOT=$W python3 -B $K5/integrate5.py
OU_ROOT=$W python3 -B $K6/integrate6.py
(cd $P && python3 -B check_becoming.py) > $L/checker.log 2>&1 || { echo checker failed; exit 1; }
python3 -B $RF/THEOREM-CONNECTIVITY.py --check > $L/conn0.log 2>&1 || true
grep "apart roots without" $L/conn0.log | cut -c1-3000 || true
