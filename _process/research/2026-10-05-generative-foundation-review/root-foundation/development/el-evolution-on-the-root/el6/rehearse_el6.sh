#!/bin/bash
# EL6's landing rehearsed in a scratch worktree (rehearse_el.sh's pattern): detached at el6-kit, main merged in
# without a commit, the receipt written outside the repository (BECOMING_OUT) and copied in, then every later step
# of the landing as it will run, the board's head and landed clauses included. Nothing is committed.
# usage: EL6_SLOT="…" rehearse_el6.sh WORKTREE ASIDE   (WORKTREE a scratch worktree detached at el6-kit and clean,
#        ASIDE a folder outside the repository; EL6_SLOT the coordinator's word giving the core run its slot, quoted
#        verbatim: the run is a near-full rebuild, GrammarMap lying under most of the package, and needs it)
set -u
W=$1; ASIDE=$2
K=$(cd "$(dirname "$0")" && pwd)
PKG=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
STUDY=_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md
cd "$W" || exit 1
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
[ -n "${EL6_SLOT:-}" ]; step coordinator-slot $?
mkdir -p "$ASIDE/out" && printf '%s\n' "$EL6_SLOT" > "$ASIDE/slot.txt"; step slot-recorded $?
[ -z "$(git branch --show-current)" ]; step detached $?
[ "$(git rev-parse HEAD)" = "$(git rev-parse el6-kit)" ]; step at-kit $?
[ -z "$(git status --porcelain --untracked-files=no)" ]; step clean $?
base=$(git rev-parse main); echo "$base" > "$ASIDE/main-at-merge.txt"
git merge --no-commit --no-ff -q "$base" > "$ASIDE/merge.log" 2>&1; step merge $?
# the board's head before the run, so that a failure here costs no run; another item's head clause is stepped past
python3 -B "$K/board_el6.py" head --rehearse > "$ASIDE/board-head.log" 2>&1; step board-head $?
(cd $PKG && LEAN_TIMEOUT=2400 BECOMING_OUT="$ASIDE/out" python3 -B check_becoming.py > "$ASIDE/check.log" 2>&1); step checker $?
ID=$(ls "$ASIDE/out/becoming-checks" | grep -v '^_' | tail -1)
cp -Rp "$ASIDE/out/becoming-checks/$ID" $PKG/becoming-checks/ \
  && cp -p "$ASIDE/out/becoming-verification.json" $PKG/becoming-verification.json; step copy-receipt $?
N=$(( $(grep -E '^## [0-9]+\. ' $STUDY | tail -1 | sed -E 's/^## ([0-9]+)\..*/\1/') + 1 ))
echo "receipt $ID, study section $N"
EL6_ORDER="${EL6_ORDER:-the order the coordinator sends with its word (rehearsal placeholder)}"
EL6_BASE=$(cat "$ASIDE/main-at-merge.txt")
export EL6_ORDER EL6_BASE
. "$K/steps_el6.sh"
git status --porcelain --untracked-files=all > "$ASIDE/paths.txt"
echo "== rehearsed: receipt $ID, study section $N, $(wc -l < "$ASIDE/paths.txt") paths changed (nothing committed)"
