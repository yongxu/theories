#!/bin/bash
# UE27's fast-forward of the shared checkout to the landing commit (ff_ue26.sh's pattern): only if main is the landing
# commit's parent and UE27 holds the head.
# usage: ff_ue27.sh COMMIT
set -u
NEW=$1; R=/Users/ren/theories
cd "$R" || exit 1
[ "$(git branch --show-current)" = main ] || { echo "SHARED CHECKOUT NOT ON MAIN"; exit 7; }
[ "$(git rev-parse main)" = "$(git rev-parse "$NEW^")" ] || { echo "MAIN MOVED"; exit 4; }
git show main:_process/BECOMING-WORKBOARD.md | grep -m1 '^- \*\*Queue:\*\*' | grep -q '^- \*\*Queue:\*\* UE27 at the head of the queue (landing now' || { echo "HEAD NOT UE27'S"; exit 3; }
[ -e _process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue27-which-blanket-a-thing-has ] && { echo "UE27 FOLDER IN THE SHARED CHECKOUT: move it aside first"; exit 6; }
git merge --ff-only -q "$NEW" && echo "LANDED $NEW" || { echo "FF FAILED"; exit 5; }
