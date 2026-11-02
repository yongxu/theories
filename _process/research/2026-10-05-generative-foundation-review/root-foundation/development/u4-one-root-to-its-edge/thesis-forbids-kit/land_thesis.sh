#!/bin/bash
# The landing, in the branch's worktree, once the clause holds the head: main merged in, the landed clause, render, strict
# check, links, tests and both dossier checks on the exact tree, and one commit of every changed path. The fast-forward
# is ff_thesis.sh's. With --rehearse: no head needed, no board edit, no commit; the tree is left for reading.
# usage: land_thesis.sh WORKTREE ASIDE [--rehearse]
set -u
W=$1; ASIDE=$2; MODE=${3:-}
K=$(cd "$(dirname "$0")" && pwd)
B=_process/BECOMING-WORKBOARD.md
D=_process/research/2026-10-05-generative-foundation-review/root-foundation/development
cd "$W" || exit 1
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
[ "$(git branch --show-current)" = thesis-forbids ]; step branch $?
[ -z "$(git status --porcelain --untracked-files=no)" ]; step clean $?
mkdir -p "$ASIDE"
base=$(git rev-parse main); echo "$base" > "$ASIDE/main-at-merge.txt"
if [ "$MODE" != --rehearse ]; then
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q "^- \*\*Queue:\*\* The philosophical thesis's statement at the head of the queue (landing now"; step head-claim $?
fi
git merge --no-edit -q "$base" > "$ASIDE/merge.log" 2>&1; step merge $?
if [ "$MODE" != --rehearse ]; then
  python3 -B "$K/board_thesis.py" landed > "$ASIDE/board.log" 2>&1; step board-landed $?
fi
make research-render > "$ASIDE/render.log" 2>&1; step render $?
for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
grep -q "^Ran [0-9]* tests" "$ASIDE/research-test.log" && grep -q "^OK" "$ASIDE/research-test.log"; step tests-ran $?
python3 -B $D/review-packet/check_dossiers.py > "$ASIDE/dossiers.log" 2>&1; step dossiers $?
python3 -B $D/review-packet/check_dossiers.py $D/ue8-sciences-dossier/SCIENCES.md > "$ASIDE/dossiers-sciences.log" 2>&1; step dossiers-sciences $?
git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths.txt"
if [ "$MODE" = --rehearse ]; then echo "== rehearsed: $(wc -l < "$ASIDE/paths.txt") paths changed, nothing committed"; exit 0; fi
git add --pathspec-from-file="$ASIDE/paths.txt"; step add $?
git commit -q -F - --pathspec-from-file="$ASIDE/paths.txt" <<MSG
The philosophical thesis's statement: what it forbids and what would defeat it (documents only: no Lean, no record and no core run). 08 §9's thesis of one relational unfolding said it would be refuted by two configurations that no test or relation tells apart and that go on differently. A cold read found this may be unmeetable, and the check against the Lean confirms the conclusion and corrects two of its steps. What two alike configurations can do cannot differ, by what likeness is (Alike.trace, Alike.tests, existential: some course ending in the claim). On a run alike configurations can go different ways where the law does not fix the outcome up to likeness (DeterminedAt.goAlike needs that premise; Decay.time_not_in_core, Decay.both_open), so read at runs the old sentence was met by a decaying nucleus without touching the thesis, and with one history as the net the time left tells them apart (Decay.history_apart). Outside the models a difference that recurs is a test, and refutes the claim that a stated family of relations is enough, not the thesis. So the section now says: the thesis forbids explanations and not observations; by the section's own measure it has no strength, and that no observation could refute it is argued, not proved, since the laws settle the three cases named and not every objection a measurement might support (an independent read's point, taken); three cases that look like refuters; what would defeat it, an argument, which measurements can support and cannot replace, with equality on the carrier named as the nearest case in the account, the thesis's reading of it not shown; and that its content is a demand on explanations. No record cites the section, so nothing is re-pointed. The fronts' sentence is the reader revision's. Render, strict check, links, the tests and both dossier checks pass on this tree.
MSG
step commit $?
git log --oneline -1 | cut -c1-120
