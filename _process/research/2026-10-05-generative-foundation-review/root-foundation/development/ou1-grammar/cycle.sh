#!/bin/zsh
# OU1: one landing cycle in a scratch worktree at main's HEAD (W); logs to L.
# usage: zsh cycle.sh W L
set -e
W=$1; L=$2; mkdir -p $L
RF=_process/research/2026-10-05-generative-foundation-review/root-foundation
K=/Users/ren/theories/$RF/development/ou1-grammar
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
cd $W
mkdir -p $RF/development/ou1-grammar/tree/Becoming
cp $K/tree/Becoming/Grammar.lean $RF/development/ou1-grammar/tree/Becoming/Grammar.lean
OU1_ROOT=$W python3 -B $K/integrate.py
(cd $P && python3 -B check_becoming.py) > $L/checker.log 2>&1 || { echo checker failed; exit 1; }
python3 -B $K/register.py
python3 -B $RF/THEOREM-CONNECTIVITY.py --check > $L/conn.log 2>&1 || { echo connectivity failed; tail -c 2000 $L/conn.log; exit 1; }
python3 -B $K/land_ou1.py 371
make research-render > $L/render.log 2>&1 || true
make research-check > $L/check.log 2>&1 || true
echo cycle done
