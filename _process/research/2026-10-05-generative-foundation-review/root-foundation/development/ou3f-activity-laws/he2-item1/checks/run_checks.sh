#!/bin/sh
# HE2's item 1: every check, rerun (writes only into this folder, the scratch trees' .build folders and the
# checker's shared step cache). Run from the worktree root. tree-main and tree-weakening are scratch:
# `rm -rf tree-main tree-weakening` here afterwards; tree/.build likewise once HE2 has landed.
#   1. the tree (item 5's laws in GrammarMap as its kit states them, then item 1 by the kit's script): Sampling,
#      PatternPassing and the check module built, every axiom report audited
#   2. main's Sampling, for the comparison
#   3. the weakening alone (Grammar and PatternPassing by the kit's script with --weakening-only, nothing of item 5):
#      PatternPassing built, Sampling's earlier proofs compiling over the weakened law
#   4. what the two proofs use, on main and in the tree; the measure of the proofs
set -e
W=$(pwd)
C="$W/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou3f-activity-laws/he2-item1"
P="$W/experiments/integrated-correction/general-framework/generative-basis/lean/becoming"
python3 -B "$C/checks/make_tree.py"
rm -rf "$C/checks/tree-main" "$C/checks/tree-weakening"
mkdir -p "$C/checks/tree-main" "$C/checks/tree-weakening/Becoming"
cp "$P/Becoming/Grammar.lean" "$P/Becoming/PatternPassing.lean" "$P/Becoming/Sampling.lean" \
  "$P/Becoming/GrammarMap.lean" "$C/checks/tree-weakening/Becoming/"
python3 -B "$C/kit/apply_he2_item1.py" "$C/checks/tree-weakening" --weakening-only > "$C/checks/weakening-apply.log"
# the weakening tree holds only what the script changed
rm "$C/checks/tree-weakening/Becoming/Sampling.lean" "$C/checks/tree-weakening/Becoming/GrammarMap.lean"
cd "$P"
python3 -B scratch_build.py "$C/tree" Becoming.Sampling Becoming.PatternPassing Becoming.HE2Item1Check > "$C/scratch-build.log" 2>&1
python3 -B scratch_build.py "$C/checks/tree-main" Becoming.Sampling > "$C/checks/scratch-main.log" 2>&1
python3 -B scratch_build.py "$C/checks/tree-weakening" Becoming.PatternPassing > "$C/checks/scratch-weakening.log" 2>&1
LEAN=$(elan which lean)
cd "$C/checks"
env LEAN_PATH="$C/checks/tree-main/.build" "$LEAN" HE2Item1Reach.lean.txt > reach-main.txt 2>&1
env LEAN_PATH="$C/tree/.build" "$LEAN" HE2Item1Reach.lean.txt > reach-new.txt 2>&1
cd "$C"
python3 -B checks/measure.py > checks/measure.out
echo done
