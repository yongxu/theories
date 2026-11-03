#!/bin/bash
# The fast-forward of the shared checkout to the landing commit (ff_u4e.sh's pattern): only if main has not moved since
# land_thesis.sh merged it and this landing holds the head. usage: ff_thesis.sh COMMIT ASIDE
set -u
NEW=$1; ASIDE=$2; R=/Users/ren/theories
cd "$R" || exit 1
[ "$(git branch --show-current)" = main ] || { echo "SHARED CHECKOUT NOT ON MAIN"; exit 7; }
[ "$(git rev-parse main)" = "$(cat "$ASIDE/main-at-merge.txt")" ] || { echo "MAIN MOVED"; exit 4; }
git merge-base --is-ancestor main "$NEW" || { echo "NOT A DESCENDANT OF MAIN"; exit 4; }
git show main:_process/BECOMING-WORKBOARD.md | grep -m1 '^- \*\*Queue:\*\*' | grep -q "^- \*\*Queue:\*\* The philosophical thesis's statement at the head of the queue (landing now" || { echo "HEAD NOT THIS LANDING'S"; exit 3; }
git merge --ff-only -q "$NEW" && echo "LANDED $NEW" || { echo "FF FAILED"; exit 5; }
