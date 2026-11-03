#!/bin/bash
# U4e's landing rehearsed in a scratch worktree (rehearse_u4d.sh's pattern): detached at u4e, main merged in without a
# commit, the receipt written outside the repository (BECOMING_OUT) and copied in, then every later step of the
# landing as it will run, the board's head and landed clauses included. Nothing is committed.
# usage: U4E_SLOT="…" rehearse_u4e.sh WORKTREE ASIDE [REUSE]   (WORKTREE a scratch worktree detached at u4e and clean,
#        ASIDE a folder outside the repository; U4E_SLOT the coordinator's word giving the core run its slot, quoted
#        verbatim; REUSE a finished rehearsal's BECOMING_OUT folder whose receipt checked these very Lean bytes, to
#        rehearse the later steps without a run: reland_u4e.py checks the two changed modules' bytes against it)
set -u
W=$1; ASIDE=$2; REUSE=${3:-}
K=$(cd "$(dirname "$0")" && pwd)
PKG=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
STUDY=_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md
cd "$W" || exit 1
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
[ -n "${U4E_SLOT:-}" ]; step coordinator-slot $?
mkdir -p "$ASIDE/out" && printf '%s\n' "$U4E_SLOT" > "$ASIDE/slot.txt"; step slot-recorded $?
[ -z "$(git branch --show-current)" ]; step detached $?
[ "$(git rev-parse HEAD)" = "$(git rev-parse u4e)" ]; step at-branch $?
[ -z "$(git status --porcelain --untracked-files=no)" ]; step clean $?
base=$(git rev-parse main); echo "$base" > "$ASIDE/main-at-merge.txt"
git merge --no-commit --no-ff -q "$base" > "$ASIDE/merge.log" 2>&1; step merge $?
python3 -B "$K/board_u4e.py" head --rehearse > "$ASIDE/board-head.log" 2>&1; step board-head $?
if [ -n "$REUSE" ]; then
  OUT=$REUSE; echo "== checker: reused $REUSE"
else
  OUT="$ASIDE/out"
  (cd $PKG && LEAN_TIMEOUT=2400 BECOMING_OUT="$OUT" python3 -B check_becoming.py > "$ASIDE/check.log" 2>&1); step checker $?
fi
ID=$(ls "$OUT/becoming-checks" | grep -v '^_' | tail -1)
cp -Rp "$OUT/becoming-checks/$ID" $PKG/becoming-checks/ \
  && cp -p "$OUT/becoming-verification.json" $PKG/becoming-verification.json; step copy-receipt $?
N=$(( $(grep -E '^## [0-9]+\. ' $STUDY | tail -1 | sed -E 's/^## ([0-9]+)\..*/\1/') + 1 ))
echo "receipt $ID, study section $N"
U4E_ORDER="${U4E_ORDER:-the order the coordinator sends with its word (rehearsal placeholder)}"
U4E_BASE=$(cat "$ASIDE/main-at-merge.txt")
export U4E_ORDER U4E_BASE
. "$K/steps_u4e.sh"
git status --porcelain --untracked-files=all > "$ASIDE/paths.txt"
echo "== rehearsed: receipt $ID, study section $N, $(wc -l < "$ASIDE/paths.txt") paths changed (nothing committed)"
