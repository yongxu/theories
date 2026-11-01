#!/bin/zsh
# U4b's landing, in stages, from the checkout root of the landing worktree (u4b). No Lean and no core run. The head
# clause, the board's landed clause and the fast-forward are run by hand, each with its guard (re-read the Queue line
# before --ff-only).
#   LOG=DIR zsh land_u4b.sh prepare    merge main (refs/heads/main), with no tracked change left before it
#   LOG=DIR zsh land_u4b.sh post [N]   the amendment (record, 08 §7, the study's section N: the next free one, read
#                                      after main is merged; a given N must match), MV's data and U4's check, the
#                                      connectivity check, render, checks, tests
# LOG holds every log (outside the repository). Each stage stops at the first failure and says where.
set -u
LOG=${LOG:?}; mkdir -p $LOG
RF=_process/research/2026-10-05-generative-foundation-review/root-foundation; K=$RF/development/u4-one-root-to-its-edge
[ -e $K/land_u4b.sh ] || { echo "run from the landing worktree's root"; exit 2; }
fail() { echo "FAILED: $1 (see $LOG)"; exit 1; }
step() { echo "== $1"; }
case ${1:-} in
prepare)
  [ -z "$(git status --porcelain --untracked-files=no)" ] || fail "tracked changes: $(git status --short | head -3)"
  step merge; git merge --no-edit refs/heads/main > $LOG/merge.log 2>&1 || fail "merge (resolve, then rerun prepare)"
  tail -1 $LOG/merge.log ;;
post)
  N=$(python3 -c "import re; t = open('$RF/BECOMING-RENEWAL-READING.md', encoding='utf-8').read(); print(max(int(x) for x in re.findall(r'^## (\d+)\. ', t, re.M)) + 1)") || fail "the study's next section"
  [ -z "${2:-}" ] || [ "$2" = "$N" ] || fail "N given as $2, but the study's next free section is $N"
  echo "study section $N"
  step amend; python3 -B $K/amend_u4b.py $N > $LOG/amend.log 2>&1 || fail amend; cat $LOG/amend.log
  step mv; python3 -B tools/research/shared_laws.py > $LOG/mv.log 2>&1 || fail mv
  python3 -B $K/integrate_u4.py check > $LOG/u4check.log 2>&1 || fail "U4's check"; cut -c1-200 $LOG/u4check.log
  step connectivity; python3 -B $RF/THEOREM-CONNECTIVITY.py --check > $LOG/conn.log 2>&1 || fail "connectivity check"
  step render; python3 -B tools/research/research.py render > $LOG/render.log 2>&1 || fail render
  step strict; python3 -B tools/research/research.py check --strict-fresh > $LOG/strict.log 2>&1 || fail strict
  step links; python3 -B tools/research/research.py links > $LOG/links.log 2>&1 || fail links; grep '"broken"' $LOG/links.log
  step lint; python3 -B tools/research/research.py lint --ids one-root-to-its-edge > $LOG/lint.log 2>&1 || fail lint
  grep -q '"findings": 0' $LOG/lint.log || fail "the record's lint"
  step tests; python3 -B -m unittest discover -s tools/research/tests -p 'test_*.py' > $LOG/tests.log 2>&1 || fail tests
  grep -E "^Ran |^OK" $LOG/tests.log
  echo "== post done: study section $N" ;;
*) echo "stage: prepare | post [N]"; exit 2 ;;
esac
