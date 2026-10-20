#!/bin/bash
# PR1 landing, run from the worktree root after `git rebase main`, with no other checker running.
# 1 checkers, 2 comparison, 3 record rebinding, 4 PE2 rerun, 5 text, 6 render and checks.
set -e
K=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/pr1-periphery-receipts
W=${PE2_WORK:?scratch folder for the restored closures}
N=${SECTION:?study section number}
python3 -B $K/run_checkers.py | tee $K/out-final.txt
! grep -v " 0 passed " $K/out-final.txt
python3 -B $K/compare.py main > $K/out/compare.txt
python3 -B $K/repoint_all.py --apply > $K/out/repoint.txt
python3 -B $K/pe2_rerun.py "$W" > $K/pe2-rerun-final.log 2>&1
python3 -B $K/pe2_rerun.py --summary > $K/pe2/summary.txt
python3 -B $K/apply_text.py "$N"
