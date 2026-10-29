#!/bin/sh
# Review of OU3f's coarse-to-fine pair: rerun every check (read-only on the repository; writes only into this folder,
# the scratch trees' .build folders and the checker's shared step cache). Run from the worktree root.
# The trees are scratch: `rm -rf tree-main tree-new recompile` here afterwards.
set -e
W=$(pwd)
C="$W/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou3f-activity-laws/coarse-to-fine/review/checks"
P="$W/experiments/integrated-correction/general-framework/generative-basis/lean/becoming"
cd "$P"
LEAN=$(elan which lean)
python3 -B "$C/make_trees.py"
# 1. builds: main's Persistence from the checkout, the tree's Persistence, then the modules holding OU3f's rows on main
#    and Persistence's cone (its 13 dependents besides the root module) with the tree's Persistence
python3 -B scratch_build.py "$C/tree-main" Becoming.Persistence > "$C/scratch-main.log"
python3 -B scratch_build.py "$C/tree-new" > "$C/scratch-new.log"
python3 -B scratch_build.py "$C/tree-main" Becoming.Identity Becoming.PatternPassing Becoming.ContinuedClasses \
  Becoming.Wholes Becoming.Exclusion Becoming.Reserve Becoming.Retaining Becoming.Persistence Becoming.MapInstances \
  Becoming.Arising Becoming.GrammarLaws > "$C/scratch-main-reach.log"
python3 -B scratch_build.py "$C/tree-new" Becoming.Persistence Becoming.CausalGrowth Becoming.ComparingCourses \
  Becoming.ContinuedClasses Becoming.EventualWidening Becoming.EventualWideningInstances Becoming.HeldPossible \
  Becoming.KeepingWidening Becoming.MapInstances Becoming.Presence Becoming.ReachableRanges Becoming.ReorderingGrowth \
  Becoming.Tasks Becoming.WorldRepresentation > "$C/scratch-cone.log"
# independent recompile of the tree's Persistence against the restored imports
mkdir -p "$C/recompile/Becoming"
(cd "$C/tree-new/.build" && env LEAN_PATH="$C/tree-new/.build" "$LEAN" -o "$C/recompile/Becoming/Persistence.olean" \
  Becoming/Persistence.lean > "$C/recompile/compile.log" 2>&1)
# 2. the Lean checks, against both builds
cd "$C"
for t in main new; do
  env LEAN_PATH="$C/tree-$t/.build" "$LEAN" ReviewCtfCheck.lean.txt > "out-$t.txt" 2>&1
  env LEAN_PATH="$C/tree-$t/.build" "$LEAN" BecomingPersistenceSignatures.lean.txt > "sig-$t.log" 2>&1
  env LEAN_PATH="$C/tree-$t/.build" "$LEAN" ReviewCtfAxioms.lean.txt > "axioms-$t.txt" 2>&1
  env LEAN_PATH="$C/tree-$t/.build" "$LEAN" ReviewCtfReachPair.lean.txt > "reach-pair-$t.txt" 2>&1
done
env LEAN_PATH="$C/tree-main/.build" "$LEAN" ReviewCtfReach.lean.txt > reach-main.txt 2>&1
diff out-main.txt out-new.txt || true
cmp sig-main.log sig-new.log && echo "signature logs identical"
# 3. the Python checks (from the worktree root)
cd "$W"
python3 -B "$C/emulate_signatures.py" > "$C/emulate_signatures.out"
python3 -B "$C/scanner_check.py" > "$C/scanner_check.out"
python3 -B "$C/scanner_bodies.py" > "$C/scanner_bodies.out"
python3 -B "$C/blank_vs_scrub.py" > "$C/blank_vs_scrub.out"
python3 -B "$C/blank_cases.py" > "$C/blank_cases.out"
python3 -B "$C/comment_edit_check.py" > "$C/comment_edit_check.out"
python3 -B "$C/scanner_history.py" > "$C/scanner_history.out"
echo "done; kit_dryrun.out was made by hand on scratch copies outside the repository (see REVIEW-CTF.md, check 5)"
