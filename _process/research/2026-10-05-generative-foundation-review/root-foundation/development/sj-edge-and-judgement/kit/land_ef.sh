#!/bin/bash
# The note on how evaluation forms: documents only, in the worktree on its branch, once it holds the head (head_ef.sh).
# Main merged in, the board's landed clause and row, render and every check, one commit of every changed path. The
# fast-forward is ff_ef.sh's. usage: land_ef.sh WORKTREE ASIDE
set -u
W=$1; ASIDE=$2; K=$(cd "$(dirname "$0")" && pwd); B=_process/BECOMING-WORKBOARD.md
cd "$W" || exit 1
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
[ -z "$(git status --porcelain --untracked-files=no)" ]; step clean $?
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -qF -- "- **Queue:** The note on how evaluation forms at the head of the queue (landing now"; step head-claim $?
mkdir -p "$ASIDE"
git rev-parse main > "$ASIDE/main-at-merge.txt"
git merge --no-edit -q main > "$ASIDE/merge.log" 2>&1; step merge $?
python3 -B "$K/board_ef.py" landed > "$ASIDE/board.log" 2>&1; step board $?
make research-render > "$ASIDE/render.log" 2>&1; step render $?
for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
grep -q '^Ran 305 tests' "$ASIDE/research-test.log"; step ran-305 $?
D=_process/research/2026-10-05-generative-foundation-review/root-foundation/development
python3 -B $D/review-packet/check_dossiers.py > "$ASIDE/dossiers.log" 2>&1 && grep -q '^0 problem(s)' "$ASIDE/dossiers.log"; step dossiers $?
python3 -B $D/review-packet/check_dossiers.py $D/ue8-sciences-dossier/SCIENCES.md > "$ASIDE/dossiers-sciences.log" 2>&1 && grep -q '^0 problem(s)' "$ASIDE/dossiers-sciences.log"; step dossiers-sciences $?
git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths.txt"
git add --pathspec-from-file="$ASIDE/paths.txt"; step add $?
git commit -q -F - --pathspec-from-file="$ASIDE/paths.txt" <<MSG
The note on how evaluation forms landed (documents only: no Lean, no record and no core run). The cold read of the fronts asked whether how evaluation forms is only defined and read, or whether the work shows more. Neither as put: the word covers four standings. Shown under stated conditions: how needs form, how standards are shaped and gain influence, and what a response within one takes. Read: a significance tied to a center's least boundary along a relation, which no law picks. Supplied: the free sig, the requirement, the task, the set level, and for the ethics the condition, C, a reading of living, L, J1-J4 and the weights. Out of reach of the represented dynamics, for the untied sig: excluding a rival or entailing the condition. No law joins the first to the second; a standard held de se is the condition exactly where every center's closure is the whole, and a rival otherwise. The note in SJ's study, its home the added block at 07 §1, the fronts' sentence sent to the reader revision. The board's landed clause and the row in the history file. Render, strict check, links, the 305 tests and both dossier checks pass.
MSG
step commit $?
git log --oneline -1 | cut -c1-120
