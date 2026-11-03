#!/bin/bash
# T2S, T2's statement from UE32's proposals 1, 2 and 4 (land_t2.sh's pattern, documents only), its kit from the branch
# t2-statement.
#   head WORKTREE: in the landing worktree, detached at main, the head clause and one commit of the board; then the
#     fast-forward of the shared checkout, only if main has not moved and no clause holds the head.
#   land WORKTREE ASIDE: on that head claim, this kit from the branch, the edits by script (every file is shared), the
#     records the check finds drifted re-pointed, only if they are the three read (bound to the overview's theses
#     section, where only T2's row changed), the sciences figures measured against READING-BUDGETS' new ones, the
#     board's landed clause, render, strict check, links, tests and both dossier checks on the exact tree, then one
#     commit of every changed path.
#   ff COMMIT: the fast-forward, only if main is the commit's parent and the head clause is this landing's.
# usage: land_t2s.sh head WORKTREE | land_t2s.sh land WORKTREE ASIDE | land_t2s.sh ff COMMIT
set -u
R=/Users/ren/theories; B=_process/BECOMING-WORKBOARD.md
DEV=_process/research/2026-10-05-generative-foundation-review/root-foundation/development
KIT=$DEV/ue-unified-explanation/t2-statement
MEASURE=$DEV/aj4-alignment-readers/kit/measure_layers.py
HEAD_RE="^- \*\*Queue:\*\* T2S at the head of the queue (landing now"
DRIFTED="loss-read-in-time-by-the-others readers-drawn-from-the-selected shaping-read-by-readers-drawn-from-the-selected"
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
case "${1:-}" in
head)
  W=$2; cd "$R" || exit 1
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD"; exit 3; }
  base=$(git rev-parse main)
  cd "$W" && git checkout -q -f --detach "$base" && [ -z "$(git status --porcelain)" ] || { echo "WORKTREE NOT CLEAN"; exit 2; }
  git show t2-statement:$KIT/board_t2s.py > "$W/.board_t2s.py" && python3 -B "$W/.board_t2s.py" head; rc=$?
  rm -f "$W/.board_t2s.py"; [ $rc = 0 ] || exit 2
  [ "$(git diff --name-only)" = "$B" ] || { echo "UNEXPECTED PATHS"; git diff --name-only; exit 2; }
  git commit -q -m "Board: T2S at the head of the queue (landing now, by readiness: documents only, no Lean, no record and no core run: T2's statement from UE32's proposals 1, 2 and 4 in T2's home, 08's row, the sciences dossier and the overview's row, with a study section; the records the change drifts re-pointed after reading; render, strict check, links, tests and both dossier checks, then the fast-forward)" -- $B
  new=$(git rev-parse HEAD); cd "$R" || exit 1
  [ "$(git rev-parse main)" = "$base" ] || { echo "MAIN MOVED; $new not landed"; exit 4; }
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD; $new not landed"; exit 3; }
  git merge --ff-only -q "$new" && echo "CLAIMED $new" || { echo "FF FAILED"; exit 5; } ;;
land)
  W=$2; ASIDE=$3
  cd "$W" || exit 1; mkdir -p "$ASIDE"
  [ -z "$(git status --porcelain)" ]; step clean $?
  git show -s --format=%s HEAD | grep -q "^Board: T2S at the head of the queue"; step head-claim $?
  git checkout t2-statement -- $KIT; step kit $?
  ! grep -q 'SECOND_SUMMARY\|SECOND_READING\|REVIEW_LINE' $KIT/*.txt $KIT/REVIEW.md; step no-placeholders $?
  [ -s $KIT/review_line.txt ]; step review-line $?
  python3 -B $KIT/edit_t2s.py > "$ASIDE/edit.log" 2>&1; step edit $?
  N=$(grep -o '§[0-9]*' "$ASIDE/edit.log" | tail -1); grep -q "study $N," $KIT/message.txt; step message-section $?
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
  REASON="T2S, 4 November 2026: T2's row in the overview's theses table (section 9) gives T2's third forbidden item among the main cases in place of the second, now conditional on a series not shown to sit at the regime's-step end (T2's home, 02 section 5). The three records bound to the overview read section 9 for the selection thesis's row, untouched; nothing they say changes."
  python3 -B tools/research/repoint.py --reason "$REASON" --drift-json "$ASIDE/drift.json" --apply > "$ASIDE/repoint.log" 2>&1; step repoint $?
  python3 -B $MEASURE > "$ASIDE/measure.txt" 2>&1; step measure $?
  grep -q '^| front: sciences | 1,351 |' "$ASIDE/measure.txt" && grep -q '^| sciences: its hour | 6,446 |' "$ASIDE/measure.txt" \
    && grep -q '^| overview | 7,223 | 19 |' "$ASIDE/measure.txt" && grep -q '^| overview, Chinese | 216 | 12,506 |' "$ASIDE/measure.txt" \
    && grep -q '^| whole: SCIENCES.md, and 60 lines of code | 18,910 | 27 | 145.6–189.2 |' "$ASIDE/measure.txt"; step budgets-as-written $?
  python3 -B $KIT/board_t2s.py land > "$ASIDE/board.log" 2>&1; step board $?
  make research-render > "$ASIDE/render.log" 2>&1; step render $?
  for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
  grep -q '^Ran [0-9]* tests' "$ASIDE/research-test.log"; step ran-tests $?
  python3 -B $DEV/review-packet/check_dossiers.py > "$ASIDE/dossiers.log" 2>&1; step dossiers $?
  python3 -B $DEV/review-packet/check_dossiers.py theories/becoming/review/SCIENCES.md > "$ASIDE/dossiers-sciences.log" 2>&1; step dossiers-sciences $?
  git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths.txt"
  grep -q '\.build/\|\.lake/\|__pycache__' "$ASIDE/paths.txt" && { echo "BUILD OUTPUT IN THE PATHS"; exit 8; }
  git add --pathspec-from-file="$ASIDE/paths.txt"; step add $?
  git commit -q -F $KIT/message.txt; step commit $?
  git log --oneline -1 | cut -c1-120 ;;
ff)
  NEW=$2; cd "$R" || exit 1
  [ "$(git branch --show-current)" = main ] || { echo "SHARED CHECKOUT NOT ON MAIN"; exit 7; }
  [ "$(git rev-parse main)" = "$(git rev-parse "$NEW^")" ] || { echo "MAIN MOVED"; exit 4; }
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q "$HEAD_RE" || { echo "HEAD NOT THIS LANDING'S"; exit 3; }
  git merge --ff-only -q "$NEW" && echo "LANDED $NEW" || { echo "FF FAILED"; exit 5; } ;;
*) sed -n '2,12p' "$0"; exit 1 ;;
esac
