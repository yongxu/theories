#!/bin/bash
# FA's fast-forward of the shared checkout to the landing commit: only if main is still the main land.sh merged, FA
# holds the head, and the landing commit contains it. The kit is untracked in the shared checkout until then, so it
# must be moved aside first.
# usage: ff.sh COMMIT MERGED_MAIN
set -u
NEW=$1; MERGED=$2; R=/Users/ren/theories
K2=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/formation-accounts-renames
cd "$R" || exit 1
[ "$(git branch --show-current)" = main ] || { echo "SHARED CHECKOUT NOT ON MAIN"; exit 7; }
[ -e .git/MERGE_HEAD ] && { echo "SHARED CHECKOUT MID-MERGE"; exit 7; }
[ "$(git rev-parse main)" = "$(git rev-parse "$MERGED")" ] || { echo "MAIN MOVED since the merge"; exit 4; }
git merge-base --is-ancestor main "$NEW" || { echo "MAIN NOT AN ANCESTOR"; exit 4; }
git show main:_process/BECOMING-WORKBOARD.md | grep -m1 '^- \*\*Queue:\*\*' | grep -q '^- \*\*Queue:\*\* FA at the head of the queue (landing now' || { echo "HEAD NOT FA'S"; exit 3; }
[ -e "$K2" ] && { echo "FA's kit folder in the shared checkout: move it aside first (mv $K2 <aside>)"; exit 6; }
git merge --ff-only -q "$NEW" && echo "LANDED $NEW" || { echo "FF FAILED"; exit 5; }
