#!/bin/bash
# LA4's head claim: in a claim worktree detached at main, one clause at the head of the Queue line and one commit of the
# board; then the fast-forward of the shared checkout, only if main has not moved and no clause holds the head.
# usage: claim_la4.sh WORKTREE
set -u
W=$1; R=/Users/ren/theories; B=_process/BECOMING-WORKBOARD.md
CLAUSE=" LA4 at the head of the queue (landing now: its formal part, the core leaves Becoming.OptimumSeason and Becoming.WeightedCommuting importing only the prelude; one incremental core run; two new records; 05 §7, 08's T3 row, the overview's T3 row in both editions and the experiments README; the connectivity register and the board row; render, strict check, links and tests, then the fast-forward);"
cd "$R" || exit 1
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD"; exit 3; }
base=$(git rev-parse main)
cd "$W" && git checkout -q -f --detach "$base" && [ -z "$(git status --porcelain)" ] || { echo "WORKTREE NOT CLEAN"; exit 2; }
CLAUSE="$CLAUSE" python3 -B - <<'PY' || exit 2
import os
from pathlib import Path
p = Path('_process/BECOMING-WORKBOARD.md'); lines = p.read_text(encoding='utf-8').split('\n')
hits = [i for i, l in enumerate(lines) if l.startswith('- **Queue:**')]
assert len(hits) == 1, hits
head = '- **Queue:**'
lines[hits[0]] = head + os.environ['CLAUSE'] + lines[hits[0]][len(head):]
p.write_text('\n'.join(lines), encoding='utf-8')
PY
[ "$(git diff --name-only)" = "$B" ] || { echo "UNEXPECTED PATHS"; git diff --name-only; exit 2; }
[ "$(git diff --numstat | cut -f1,2)" = "$(printf '1\t1')" ] || { echo "UNEXPECTED LINES"; git diff --numstat; exit 2; }
git commit -q -m "Board: LA4 at the head of the queue (landing now: its formal part, the core leaves Becoming.OptimumSeason and Becoming.WeightedCommuting; one incremental core run; two new records; 05 §7, 08, the overview and the experiments README; render, strict check, links and tests, then the fast-forward)" -- $B
new=$(git rev-parse HEAD)
cd "$R"
[ "$(git rev-parse main)" = "$base" ] || { echo "MAIN MOVED; $new not landed"; exit 4; }
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD; $new not landed"; exit 3; }
git merge --ff-only -q "$new" && echo "CLAIMED $new" || { echo "FF FAILED"; exit 5; }
