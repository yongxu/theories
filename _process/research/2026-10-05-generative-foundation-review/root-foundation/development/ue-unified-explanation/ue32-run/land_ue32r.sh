#!/bin/bash
# UE32's run, its result landed (land_t2s.sh's pattern, with land_ue31_run.sh's merge), from the branch ue32-run: Ren's
# words, the run's output, UE32's README and this kit.
#   head WORKTREE: in the landing worktree, detached at main, the head clause and one commit of the board; then the
#     fast-forward of the shared checkout, only if main has not moved and no clause holds the head.
#   land WORKTREE ASIDE: on that head claim, the branch merged without a commit (its step commits kept), the shared
#     texts' edits by script, the records the check finds drifted re-pointed, only if they are the three read (bound
#     to the overview's theses section, where only T2's row changed), the figures measured against READING-BUDGETS'
#     new ones, the board's landed clause, render, strict check, links, tests and both dossier checks on the exact
#     tree, then the merge's commit of every changed path.
#   ff COMMIT: the fast-forward, only if main is the commit's first parent and the head clause is this landing's.
# usage: land_ue32r.sh head WORKTREE | land_ue32r.sh land WORKTREE ASIDE | land_ue32r.sh ff COMMIT
set -u
R=/Users/ren/theories; B=_process/BECOMING-WORKBOARD.md; BRANCH=ue32-run
DEV=_process/research/2026-10-05-generative-foundation-review/root-foundation/development
KIT=$DEV/ue-unified-explanation/ue32-run
MEASURE=$DEV/aj4-alignment-readers/kit/measure_layers.py
HEAD_RE="^- \*\*Queue:\*\* UE32 at the head of the queue (landing now"
DRIFTED="loss-read-in-time-by-the-others readers-drawn-from-the-selected shaping-read-by-readers-drawn-from-the-selected"
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
case "${1:-}" in
head)
  W=$2; cd "$R" || exit 1
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD"; exit 3; }
  base=$(git rev-parse main)
  cd "$W" && git checkout -q -f --detach "$base" && [ -z "$(git status --porcelain)" ] || { echo "WORKTREE NOT CLEAN"; exit 2; }
  git show $BRANCH:$KIT/board_ue32r.py > "$W/.board_ue32r.py" && python3 -B "$W/.board_ue32r.py" head; rc=$?
  rm -f "$W/.board_ue32r.py"; [ $rc = 0 ] || exit 2
  [ "$(git diff --name-only)" = "$B" ] || { echo "UNEXPECTED PATHS"; git diff --name-only; exit 2; }
  git commit -q -m "Board: UE32 at the head of the queue (landing now, by readiness: UE32's run on Ren's yes, its output and result, documents and no Lean, no record and no core run: the result in UE32's README, T2's home and 08's row, S-15 and the whole's time, the overview's row, with a study section; the records the change drifts re-pointed after reading; render, strict check, links, tests and both dossier checks, then the fast-forward)" -- $B
  new=$(git rev-parse HEAD); cd "$R" || exit 1
  [ "$(git rev-parse main)" = "$base" ] || { echo "MAIN MOVED; $new not landed"; exit 4; }
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD; $new not landed"; exit 3; }
  git merge --ff-only -q "$new" && echo "CLAIMED $new" || { echo "FF FAILED"; exit 5; } ;;
land)
  W=$2; ASIDE=$3
  cd "$W" || exit 1; mkdir -p "$ASIDE"
  [ -z "$(git status --porcelain)" ]; step clean $?
  git show -s --format=%s HEAD | grep -q "^Board: UE32 at the head of the queue"; step head-claim $?
  git merge --no-ff --no-commit -q $BRANCH > "$ASIDE/merge.log" 2>&1; step merge $?
  [ -z "$(git diff --name-only --diff-filter=U)" ]; step no-conflicts $?
  ! grep -q 'REVIEW_LINE\|TODO\|FIGURES\|REVIEW_SUMMARY\|(rehearsal)' $KIT/*.txt $KIT/REVIEW.md; step no-placeholders $?
  [ -s $KIT/review_line.txt ]; step review-line $?
  python3 -B $KIT/edit_ue32r.py > "$ASIDE/edit.log" 2>&1; step edit $?
  N=$(grep -o '§[0-9]*' "$ASIDE/edit.log" | tail -1); grep -q "study $N" $KIT/message.txt; step message-section $?
  python3 -B tools/research/research.py check > "$ASIDE/drift.json" 2> "$ASIDE/drift.err"; echo "check exit $? (2: drift)"
  python3 -B - "$ASIDE/drift.json" $DRIFTED <<'EOF'; step drift-is-the-three-read $?
import json, sys
t = open(sys.argv[1]).read()
d = json.loads(t[t.index('{'):t.rindex('}') + 1])
got = sorted((x['id'], x['path'], tuple(x['changed_sections'])) for x in d['source_drift'])
want = sorted((i, 'theories/becoming/THE-THEORY-OF-BECOMING.md', ('## 9. The theses',)) for i in sys.argv[2:])
assert not d['errors'] and not d['unrelated_source_drift'], (d['errors'], d['unrelated_source_drift'])
assert got == want, got
EOF
  REASON="UE32's run, 4 November 2026: T2's row in the overview's theses table (section 9) adds UE32's verdict to T2's standing, with both states behind persistence beside it (T2's home, 02 section 5). The three records bound to the overview read section 9 for the selection thesis's row, untouched; nothing they say changes."
  python3 -B tools/research/repoint.py --reason "$REASON" --drift-json "$ASIDE/drift.json" --apply > "$ASIDE/repoint.log" 2>&1; step repoint $?
  python3 -B $MEASURE > "$ASIDE/measure.txt" 2>&1; step measure $?
  grep -q '^| front: sciences | 1,365 |' "$ASIDE/measure.txt" && grep -q '^| sciences: its hour | 6,500 |' "$ASIDE/measure.txt" \
    && grep -q '^| overview | 7,270 | 19 |' "$ASIDE/measure.txt" && grep -q '^| overview, Chinese | 216 | 12,622 |' "$ASIDE/measure.txt" \
    && grep -q '^| whole: SCIENCES.md, and 60 lines of code | 19,012 | 27 | 146.3–190.3 |' "$ASIDE/measure.txt"; step budgets-as-written $?
  python3 -B $KIT/board_ue32r.py land > "$ASIDE/board.log" 2>&1; step board $?
  make research-render > "$ASIDE/render.log" 2>&1; step render $?
  for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
  grep -q '^Ran [0-9]* tests' "$ASIDE/research-test.log"; step ran-tests $?
  python3 -B $DEV/review-packet/check_dossiers.py > "$ASIDE/dossiers.log" 2>&1; step dossiers $?
  python3 -B $DEV/review-packet/check_dossiers.py theories/becoming/review/SCIENCES.md > "$ASIDE/dossiers-sciences.log" 2>&1; step dossiers-sciences $?
  git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths.txt"
  grep -q '\.build/\|\.lake/\|__pycache__\|\.xlsx' "$ASIDE/paths.txt" && { echo "BUILD OUTPUT OR DATA IN THE PATHS"; exit 8; }
  git add --pathspec-from-file="$ASIDE/paths.txt"; step add $?
  git commit -q -F $KIT/message.txt; step commit $?
  [ "$(git rev-parse HEAD^2)" = "$(git rev-parse $BRANCH)" ]; step merge-parent $?
  git log --oneline -1 | cut -c1-120 ;;
ff)
  NEW=$2; cd "$R" || exit 1
  [ "$(git branch --show-current)" = main ] || { echo "SHARED CHECKOUT NOT ON MAIN"; exit 7; }
  [ "$(git rev-parse main)" = "$(git rev-parse "$NEW^")" ] || { echo "MAIN MOVED"; exit 4; }
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q "$HEAD_RE" || { echo "HEAD NOT THIS LANDING'S"; exit 3; }
  git merge --ff-only -q "$NEW" && echo "LANDED $NEW" || { echo "FF FAILED"; exit 5; } ;;
*) sed -n '2,13p' "$0"; exit 1 ;;
esac
