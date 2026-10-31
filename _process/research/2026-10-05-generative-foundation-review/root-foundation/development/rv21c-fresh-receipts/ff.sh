#!/bin/bash
# RV21c's fast-forward of the shared checkout to the landing commit: only if main is still the main land.sh merged,
# RV21c holds the head, and the landing commit contains it.
# usage: ff.sh COMMIT MERGED_MAIN
set -u
NEW=$1; MERGED=$2; R=/Users/ren/theories
K=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rv21c-fresh-receipts
cd "$R" || exit 1
[ "$(git branch --show-current)" = main ] || { echo "SHARED CHECKOUT NOT ON MAIN"; exit 7; }
[ -e .git/MERGE_HEAD ] && { echo "SHARED CHECKOUT MID-MERGE"; exit 7; }
[ "$(git rev-parse main)" = "$(git rev-parse "$MERGED")" ] || { echo "MAIN MOVED since the merge"; exit 4; }
git merge-base --is-ancestor main "$NEW" || { echo "MAIN NOT AN ANCESTOR"; exit 4; }
git show main:_process/BECOMING-WORKBOARD.md | grep -m1 '^- \*\*Queue:\*\*' | grep -q '^- \*\*Queue:\*\* RV21c at the head of the queue (landing now' || { echo "HEAD NOT RV21c'S"; exit 3; }
# The kit is untracked in the shared checkout; the landing commit carries it, so it must be moved aside first.
[ -e "$K" ] && { echo "RV21c's kit folder in the shared checkout: move it aside first (mv $K <aside>)"; exit 6; }
git merge --ff-only -q "$NEW" && echo "LANDED $NEW" || { echo "FF FAILED"; exit 5; }
