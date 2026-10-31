#!/bin/bash
# RV21c's release of its head clause, when land.sh stops after claim_head.sh: one board-only commit on main made
# without a worktree, removing the clause and nothing else, so the queue is free while the stop is settled. The
# worktree, its branch and the runs stay as they are; claim_head.sh claims again when land.sh can go on.
# usage: release_head.sh ASIDE REASON   (REASON one clause, e.g. "land.sh stopped at research-check-strict: drift outside RV21c's sections"; then reset_land.sh)
set -u
ASIDE=$(cd "$1" && pwd) || exit 1; WHY=$2
R=/Users/ren/theories; B=_process/BECOMING-WORKBOARD.md
cd "$R" || exit 1
[ "$(git branch --show-current)" = main ] || { echo "SHARED CHECKOUT NOT ON MAIN"; exit 7; }
[ -e .git/MERGE_HEAD ] && { echo "SHARED CHECKOUT MID-MERGE"; exit 7; }
case "$WHY" in *'); '*|*$'\n'*|*' | '*) echo "REASON must be one clause"; exit 2;; esac
base=$(git rev-parse main)
git show "$base:$B" > "$ASIDE/board-release.md"
python3 - "$ASIDE/board-release.md" <<'PY' || exit 2
import re, sys
from pathlib import Path
p = Path(sys.argv[1])
lines = p.read_text(encoding="utf-8").split("\n")
q = [i for i, l in enumerate(lines) if l.startswith("- **Queue:** ")]
assert len(q) == 1, q
head = re.compile(r"RV21c at the head of the queue \([^()]*\); ")
assert lines[q[0]].startswith("- **Queue:** RV21c at the head") and len(head.findall(lines[q[0]])) == 1, "RV21c does not hold the head"
lines[q[0]] = head.sub("", lines[q[0]], count=1)
p.write_text("\n".join(lines), encoding="utf-8")
PY
[ "$(git show "$base:$B" | diff - "$ASIDE/board-release.md" | grep -c '^[<>]')" = 2 ] || { echo "UNEXPECTED BOARD DIFF"; exit 2; }
git diff --quiet -- $B || { echo "THE SHARED CHECKOUT'S BOARD HAS UNCOMMITTED CHANGES"; exit 2; }
blob=$(git hash-object -w "$ASIDE/board-release.md")
export GIT_INDEX_FILE="$ASIDE/index-release"
rm -f "$GIT_INDEX_FILE"
git read-tree "$base" && git update-index --cacheinfo 100644,"$blob",$B && tree=$(git write-tree) || exit 2
unset GIT_INDEX_FILE
new=$(git commit-tree "$tree" -p "$base" -m "Board: RV21c's head clause released ($WHY); nothing of RV21c landed, its runs kept on its branch")
[ "$(git rev-parse main)" = "$base" ] || { echo "MAIN MOVED; $new not landed"; exit 4; }
git merge --ff-only -q "$new" && echo "RELEASED $new" || { echo "FF FAILED"; exit 5; }
