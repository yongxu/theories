#!/bin/bash
# UE28's fast-forward of the shared checkout to the landing commit (ff_ue27.sh's pattern): only if main is the landing
# commit's parent and UE28 holds the head. An untracked copy of UE28's study folder in the shared checkout stops it
# (RESULT-WORKFLOW): compare it with the landing's folder, keep any difference in a commit under refs/salvage/... and
# move it aside, never delete it, then run this again.
# usage: ff_ue28.sh COMMIT
set -u
NEW=$1; R=/Users/ren/theories
D=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue28-a-formations-level-as-the-internal-part
cd "$R" || exit 1
[ "$(git branch --show-current)" = main ] || { echo "SHARED CHECKOUT NOT ON MAIN"; exit 7; }
[ "$(git rev-parse main)" = "$(git rev-parse "$NEW^")" ] || { echo "MAIN MOVED"; exit 4; }
git show main:_process/BECOMING-WORKBOARD.md | grep -m1 '^- \*\*Queue:\*\*' | grep -q '^- \*\*Queue:\*\* UE28 at the head of the queue (landing now' || { echo "HEAD NOT UE28'S"; exit 3; }
[ -e "$D" ] && { echo "UE28 FOLDER IN THE SHARED CHECKOUT: compare it with $NEW:$D, keep any difference under refs/salvage/, then move it aside"; exit 6; }
git merge --ff-only -q "$NEW" && echo "LANDED $NEW" || { echo "FF FAILED"; exit 5; }
