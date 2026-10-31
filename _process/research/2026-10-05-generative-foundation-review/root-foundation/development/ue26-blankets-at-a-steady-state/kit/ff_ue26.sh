#!/bin/bash
# UE26's fast-forward of the shared checkout to the landing commit (ff_ue25.sh's pattern): only if main is the landing
# commit's parent and UE26 holds the head.
# usage: ff_ue26.sh COMMIT
set -u
NEW=$1; R=/Users/ren/theories
cd "$R" || exit 1
[ "$(git branch --show-current)" = main ] || { echo "SHARED CHECKOUT NOT ON MAIN"; exit 7; }
[ "$(git rev-parse main)" = "$(git rev-parse "$NEW^")" ] || { echo "MAIN MOVED"; exit 4; }
git show main:_process/BECOMING-WORKBOARD.md | grep -m1 '^- \*\*Queue:\*\*' | grep -q '^- \*\*Queue:\*\* UE26 at the head of the queue (landing now' || { echo "HEAD NOT UE26'S"; exit 3; }
[ -e _process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue26-blankets-at-a-steady-state ] && { echo "UE26 FOLDER IN THE SHARED CHECKOUT: move it aside first"; exit 6; }
git merge --ff-only -q "$NEW" && echo "LANDED $NEW" || { echo "FF FAILED"; exit 5; }
