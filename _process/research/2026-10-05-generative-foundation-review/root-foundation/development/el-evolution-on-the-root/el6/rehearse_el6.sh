#!/bin/bash
# EL6's landing rehearsed in a scratch worktree (rehearse_el.sh's pattern): detached at el6-kit, main merged in
# without a commit, the receipt written outside the repository (BECOMING_OUT) and copied in, then every later step
# of the landing as it will run, the board's head and landed clauses included. Nothing is committed.
# usage: rehearse_el6.sh WORKTREE ASIDE   (WORKTREE a scratch worktree detached at el6-kit and clean, ASIDE a
#        folder outside the repository)
set -u
W=$1; ASIDE=$2
K=$(cd "$(dirname "$0")" && pwd)
PKG=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
STUDY=_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md
cd "$W" || exit 1
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
[ -z "$(git branch --show-current)" ]; step detached $?
[ -z "$(git status --porcelain --untracked-files=no)" ]; step clean $?
mkdir -p "$ASIDE/out"
git rev-parse main > "$ASIDE/main-at-merge.txt"
git merge --no-commit --no-ff -q main > "$ASIDE/merge.log" 2>&1; step merge $?
(cd $PKG && LEAN_TIMEOUT=2400 BECOMING_OUT="$ASIDE/out" python3 -B check_becoming.py > "$ASIDE/check.log" 2>&1); step checker $?
ID=$(ls "$ASIDE/out/becoming-checks" | grep -v '^_' | tail -1)
cp -Rp "$ASIDE/out/becoming-checks/$ID" $PKG/becoming-checks/ \
  && cp -p "$ASIDE/out/becoming-verification.json" $PKG/becoming-verification.json; step copy-receipt $?
N=$(( $(grep -E '^## [0-9]+\. ' $STUDY | tail -1 | sed -E 's/^## ([0-9]+)\..*/\1/') + 1 ))
echo "receipt $ID, study section $N"
python3 -B "$K/board_el6.py" head > "$ASIDE/board-head.log" 2>&1; step board-head $?
EL6_ORDER="${EL6_ORDER:-the order the coordinator sends with its word (rehearsal placeholder)}"
export EL6_ORDER
. "$K/steps_el6.sh"
git status --porcelain --untracked-files=all > "$ASIDE/paths.txt"
echo "== rehearsed: receipt $ID, study section $N, $(wc -l < "$ASIDE/paths.txt") paths changed (nothing committed)"
