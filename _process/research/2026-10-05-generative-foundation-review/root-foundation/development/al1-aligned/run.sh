#!/bin/zsh
K=${0:A:h}
cd $K && python3 -B build_tree.py || exit 1
cd /Users/ren/theories/.claude/worktrees/al1/experiments/integrated-correction/general-framework/generative-basis/lean/becoming
python3 -B scratch_build.py $K/tree Becoming.Optimum > $K/scratch.log 2>&1; echo exit $?
grep -n "error\|warning" $K/scratch.log | head -30
tail -25 $K/scratch.log
