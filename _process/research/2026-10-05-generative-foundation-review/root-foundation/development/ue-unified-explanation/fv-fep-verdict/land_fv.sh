#!/bin/bash
# FV, where the free-energy principle stands in 08's verdict (land_t2s.sh's pattern, documents only), its kit from the
# branch fv.
#   head WORKTREE: in the landing worktree, detached at main, the head clause and one commit of the board; then the
#     fast-forward of the shared checkout, only if main has not moved and no clause holds the head.
#   land WORKTREE ASIDE: on that head claim, this kit from the branch, the edits by script (every file is shared), the
#     records the check finds drifted re-pointed, only if they are the four read (bound to the principle's page as a
#     whole, where only its list of what the theory does not state changed), the sciences whole measured against
#     READING-BUDGETS' new figure, the board's landed clause, render, strict check, links, tests and both dossier checks
#     on the exact tree, then one commit of every changed path.
#   ff COMMIT: the fast-forward, only if main is the commit's parent and the head clause is this landing's.
# usage: land_fv.sh head WORKTREE | land_fv.sh land WORKTREE ASIDE | land_fv.sh ff COMMIT
set -u
R=/Users/ren/theories; B=_process/BECOMING-WORKBOARD.md
DEV=_process/research/2026-10-05-generative-foundation-review/root-foundation/development
KIT=$DEV/ue-unified-explanation/fv-fep-verdict
MEASURE=$DEV/aj4-alignment-readers/kit/measure_layers.py
HEAD_RE="^- \*\*Queue:\*\* FV at the head of the queue (landing now"
DRIFTED="a-code-held-as-counts a-formations-couplings-as-its-blanket the-blanket-at-a-steady-state the-blanket-in-a-linear-steady-state"
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
case "${1:-}" in
head)
  W=$2; cd "$R" || exit 1
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD"; exit 3; }
  base=$(git rev-parse main)
  cd "$W" && git checkout -q -f --detach "$base" && [ -z "$(git status --porcelain)" ] || { echo "WORKTREE NOT CLEAN"; exit 2; }
  git show fv:$KIT/board_fv.py | python3 -B - head || exit 2
  [ "$(git diff --name-only)" = "$B" ] || { echo "UNEXPECTED PATHS"; git diff --name-only; exit 2; }
  git commit -q -m "Board: FV at the head of the queue (landing now, by readiness: documents only, no Lean, no record and no core run: where the free-energy principle stands in 08's verdict, both sides in its page's words, S-02 following and the page's list of what the theory does not state made exact; the records the change drifts re-pointed after reading; render, strict check, links, tests and both dossier checks, then the fast-forward)" -- $B
  new=$(git rev-parse HEAD); cd "$R" || exit 1
  [ "$(git rev-parse main)" = "$base" ] || { echo "MAIN MOVED; $new not landed"; exit 4; }
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD; $new not landed"; exit 3; }
  git merge --ff-only -q "$new" && echo "CLAIMED $new" || { echo "FF FAILED"; exit 5; } ;;
land)
  W=$2; ASIDE=$3
  cd "$W" || exit 1; mkdir -p "$ASIDE"
  [ -z "$(git status --porcelain)" ]; step clean $?
  git show -s --format=%s HEAD | grep -q "^Board: FV at the head of the queue"; step head-claim $?
  git checkout fv -- $KIT; step kit $?
  ! grep -q 'FIGURES\|TODO' $KIT/*.txt $KIT/REVIEW.md; step no-placeholders $?
  python3 -B $KIT/edit_fv.py > "$ASIDE/edit.log" 2>&1; step edit $?
  python3 -B tools/research/research.py check > "$ASIDE/drift.json" 2> "$ASIDE/drift.err"; echo "check exit $? (2: drift)"
  python3 -B - "$ASIDE/drift.json" $DRIFTED <<'PY'; step drift-is-the-four-read $?
import json, sys
t = open(sys.argv[1]).read()
d = json.loads(t[t.index('{'):t.rindex('}') + 1])
got = sorted((x['id'], x['path']) for x in d['source_drift'])
want = sorted((i, 'theories/becoming/FREE-ENERGY-PRINCIPLE.md') for i in sys.argv[2:])
assert not d['errors'] and not d['unrelated_source_drift'], (d['errors'], d['unrelated_source_drift'])
assert got == want, got
PY
  REASON="FV, 4 November 2026: the free-energy principle's page names, in its brief and its section 5, the softmax over policies as unstated beyond the tied order it keeps (its section 3 states that order). The four records bound to the page as a whole state laws of a code and of the blanket; nothing they say changes."
  python3 -B tools/research/repoint.py --reason "$REASON" --drift-json "$ASIDE/drift.json" --apply > "$ASIDE/repoint.log" 2>&1; step repoint $?
  python3 -B $MEASURE > "$ASIDE/measure.txt" 2>&1; step measure $?
  grep -q "$(cat $KIT/whole.txt)" "$ASIDE/measure.txt"; step budgets-as-written $?
  python3 -B $KIT/board_fv.py land > "$ASIDE/board.log" 2>&1; step board $?
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
