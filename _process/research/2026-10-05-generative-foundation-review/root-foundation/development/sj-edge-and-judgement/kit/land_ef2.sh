#!/bin/bash
# The note on how evaluation forms: documents only, in the worktree on its branch, once it holds the head (head_ef2.sh).
# Main merged in, the board's landed clause and row, render and every check, one commit of every changed path. The
# fast-forward is ff_ef2.sh's. usage: land_ef.sh WORKTREE ASIDE
set -u
W=$1; ASIDE=$2; K=$(cd "$(dirname "$0")" && pwd); B=_process/BECOMING-WORKBOARD.md
cd "$W" || exit 1
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
[ -z "$(git status --porcelain --untracked-files=no)" ]; step clean $?
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -qF -- "- **Queue:** The independent read of the note on how evaluation forms at the head of the queue (landing now"; step head-claim $?
mkdir -p "$ASIDE"
git rev-parse main > "$ASIDE/main-at-merge.txt"
git merge --no-edit -q main > "$ASIDE/merge.log" 2>&1; step merge $?
python3 -B "$K/board_ef2.py" landed > "$ASIDE/board.log" 2>&1; step board $?
make research-render > "$ASIDE/render.log" 2>&1; step render $?
for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
grep -q '^Ran 305 tests' "$ASIDE/research-test.log"; step ran-305 $?
D=_process/research/2026-10-05-generative-foundation-review/root-foundation/development
python3 -B $D/review-packet/check_dossiers.py > "$ASIDE/dossiers.log" 2>&1 && grep -q '^0 problem(s)' "$ASIDE/dossiers.log"; step dossiers $?
python3 -B $D/review-packet/check_dossiers.py $D/ue8-sciences-dossier/SCIENCES.md > "$ASIDE/dossiers-sciences.log" 2>&1 && grep -q '^0 problem(s)' "$ASIDE/dossiers-sciences.log"; step dossiers-sciences $?
git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths.txt"
git add --pathspec-from-file="$ASIDE/paths.txt"; step add $?
git commit -q -F - --pathspec-from-file="$ASIDE/paths.txt" <<MSG
The independent read of the note on how evaluation forms landed (documents only: no Lean, no result record and no core run). Two independent AI readers read the note as landed in 6500dce37, one for exactness against the Lean and the records, one adversarially on the argument; REVIEW-5 keeps their reports and the dispositions. Corrected: the wrong declaration for a dependence forming anew, now Web.formsAnew_iff_drawn_unheld with its conjunct and near-definitional; a requirement's law narrowed to a bound on what it can say; the tied condition's variation with the net moved under the reading; rows at one step and with their supplied inputs; the search claim narrowed to generation by dynamics that supply none. Withdrawn: that what forms is in general a rival of the condition and that this is why the condition is a premise; the laws say which carriers spread, not what a standard is about. Stated: the sorting as one of the account's statements, with its basis, scope and omissions; three things and a limit on the free parameter; no law alone can supply the identification of a standard with a significance; three open positions, with route (b), P1 and the de se question. A glossary row for standard; the block at 07 §1 rewritten under its anchor. The fronts' sentences sent to the reader revision again. The board's landed clause and the row in the history file. Render, strict check, links, the 305 tests and both dossier checks pass.
MSG
step commit $?
git log --oneline -1 | cut -c1-120
