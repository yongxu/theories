#!/bin/bash
# RR2's fast-forward of the shared checkout to the landing commit: only if main is the landing commit's parent and RR2
# holds the head. The shared checkout's untracked kit2 (the folder the landing commit adds) is moved to ASIDE first and
# compared with the landed copy after; on a failed fast-forward it is put back.
# usage: ff_rr2.sh COMMIT ASIDE
set -u
NEW=$1; ASIDE=$2; R=/Users/ren/theories
D=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rr-revision-routes
cd "$R" || exit 1
[ "$(git branch --show-current)" = main ] || { echo "SHARED CHECKOUT NOT ON MAIN"; exit 7; }
[ "$(git rev-parse main)" = "$(git rev-parse "$NEW^")" ] || { echo "MAIN MOVED"; exit 4; }
git show main:_process/BECOMING-WORKBOARD.md | grep -m1 '^- \*\*Queue:\*\*' | grep -q '^- \*\*Queue:\*\* RR2 at the head of the queue (landing now' || { echo "HEAD NOT RR2'S"; exit 3; }
mkdir -p "$ASIDE/shared"
moved=()
for p in kit2; do [ -e "$D/$p" ] && mv "$D/$p" "$ASIDE/shared/$p" && moved+=("$p"); done
if git merge --ff-only -q "$NEW"; then
  echo "LANDED $NEW"
  for p in "${moved[@]}"; do diff -rq -x .build -x __pycache__ -x '*.staged' "$ASIDE/shared/$p" "$D/$p" && echo "same: $p"; done
else
  for p in "${moved[@]}"; do mv "$ASIDE/shared/$p" "$D/$p"; done
  echo "FF FAILED; folder files put back"; exit 5
fi
