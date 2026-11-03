#!/bin/bash
# T2's sentence on the life cycle (land_ue31.sh's pattern, documents only), from the branch t2-life-cycle.
#   head WORKTREE: in the landing worktree, detached at main, the head clause and one commit of the board; then the
#     fast-forward of the shared checkout, only if main has not moved and no clause holds the head.
#   land WORKTREE ASIDE: on that head claim, this kit from the branch, the two edits by script (02 and 08 are shared),
#     the fourteen records binding 02 and 08 re-pointed after reading, the board's landed clause, render, strict check,
#     links and tests on the exact tree, then one commit of every changed path.
#   ff COMMIT: the fast-forward, only if main is the commit's parent and the head clause is this landing's.
# usage: land_t2.sh head WORKTREE | land_t2.sh land WORKTREE ASIDE | land_t2.sh ff COMMIT
set -u
R=/Users/ren/theories; K=$(cd "$(dirname "$0")" && pwd); B=_process/BECOMING-WORKBOARD.md
KIT=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue-unified-explanation/ue31-state-named-in-advance
M02=theories/becoming/chapters/02-MAP.md
M08=theories/becoming/chapters/08-METHOD.md
HEAD_RE="^- \*\*Queue:\*\* T2's sentence on the life cycle at the head of the queue (landing now"
MSG="T2's sentence on the life cycle landed: T2's home (02 §5) and its row in 08's thesis table say what UE31's frozen test, not yet run, expects in one domain where a stage before recruitment is counted, the flour beetle: T2's wording 'as far as anything measured does' failing as the life cycle implies, 'as far as the level's own history does' remaining, and the lag's sign mostly undecided; the design's reader's seven points taken, and the sciences dossier's reader's two (the sign's condition; MQ6's yeast outside the settings T2's Refuted by names); the fourteen records binding 02 and 08 re-pointed after reading, nothing they say changed; the board's landed clause; generated pages rendered. Render, strict check, links and tests pass on this tree"
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
case "${1:-}" in
head)
  W=$2; cd "$R" || exit 1
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD"; exit 3; }
  base=$(git rev-parse main)
  cd "$W" && git checkout -q -f --detach "$base" && [ -z "$(git status --porcelain)" ] || { echo "WORKTREE NOT CLEAN"; exit 2; }
  python3 -B "$K/board_t2.py" head || exit 2
  [ "$(git diff --name-only)" = "$B" ] || { echo "UNEXPECTED PATHS"; git diff --name-only; exit 2; }
  git commit -q -m "Board: T2's sentence on the life cycle at the head of the queue (landing now, by readiness, before the freeze: documents only, no Lean, no new record and no core run; one sentence in T2's home and its row in 08's thesis table; the fourteen records binding 02 and 08 re-pointed after reading; render, strict check, links and tests, then the fast-forward)" -- $B
  new=$(git rev-parse HEAD); cd "$R" || exit 1
  [ "$(git rev-parse main)" = "$base" ] || { echo "MAIN MOVED; $new not landed"; exit 4; }
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD; $new not landed"; exit 3; }
  git merge --ff-only -q "$new" && echo "CLAIMED $new" || { echo "FF FAILED"; exit 5; } ;;
land)
  W=$2; ASIDE=$3
  cd "$W" || exit 1; mkdir -p "$ASIDE"
  [ -z "$(git status --porcelain)" ]; step clean $?
  git show -s --format=%s HEAD | grep -q "^Board: T2's sentence on the life cycle at the head of the queue"; step head-claim $?
  git checkout t2-life-cycle -- $KIT/board_t2.py $KIT/land_t2.sh; step kit $?
  python3 -B "$K/board_t2.py" edit; step edit $?
  REASON="T2's sentence on the life cycle, 3 November 2026: one sentence added after T2's Standing in 02 section 5 and the same in T2's Standing cell of 08's thesis table, saying what UE31's frozen test expects where a stage before recruitment is counted. The fourteen records binding 02 or 08 by their whole bytes have their home sections elsewhere in those chapters, untouched, and none cites T2; nothing they say changes."
  python3 -B tools/research/repoint.py --reason "$REASON" --paths $M02 $M08 > "$ASIDE/repoint-dry.log" 2>&1; step repoint-dry $?
  grep -q '"records": 14' "$ASIDE/repoint-dry.log"; step repoint-fourteen $?
  python3 -B tools/research/repoint.py --reason "$REASON" --paths $M02 $M08 --apply > "$ASIDE/repoint.log" 2>&1; step repoint $?
  python3 -B "$K/board_t2.py" land > "$ASIDE/board.log" 2>&1; step board $?
  make research-render > "$ASIDE/render.log" 2>&1; step render $?
  for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
  grep -q '^Ran [0-9]* tests' "$ASIDE/research-test.log"; step ran-tests $?
  git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths.txt"
  grep -q '\.build/\|\.lake/\|__pycache__' "$ASIDE/paths.txt" && { echo "BUILD OUTPUT IN THE PATHS"; exit 8; }
  git add --pathspec-from-file="$ASIDE/paths.txt"; step add $?
  git commit -q -m "$MSG" --pathspec-from-file="$ASIDE/paths.txt"; step commit $?
  git log --oneline -1 | cut -c1-120 ;;
ff)
  NEW=$2; cd "$R" || exit 1
  [ "$(git branch --show-current)" = main ] || { echo "SHARED CHECKOUT NOT ON MAIN"; exit 7; }
  [ "$(git rev-parse main)" = "$(git rev-parse "$NEW^")" ] || { echo "MAIN MOVED"; exit 4; }
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q "$HEAD_RE" || { echo "HEAD NOT THIS LANDING'S"; exit 3; }
  git merge --ff-only -q "$NEW" && echo "LANDED $NEW" || { echo "FF FAILED"; exit 5; } ;;
*) sed -n '2,9p' "$0"; exit 1 ;;
esac
