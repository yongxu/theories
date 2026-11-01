#!/bin/zsh
# U4's landing, in stages, from the checkout root of the landing worktree (u4-edge). The head claim, the board's
# landed clause and the fast-forward are run by hand, each with its guard (re-read the Queue line before --ff-only).
#   LOG=DIR zsh land_u4.sh prepare    merge main (refs/heads/main), with no tracked change left before it
#   LOG=DIR zsh land_u4.sh run        the checker in place (one incremental core run; RootForms joins the core)
#   LOG=DIR zsh land_u4.sh post [N]   the boundary table on the run, the record with 08 §7 and §3 and regions, MV's
#                                     data and U4's check, the apart register, the study's section N (the next free
#                                     one, read after main is merged; a given N must match), render, checks, tests
# LOG holds every log (outside the repository). Each stage stops at the first failure and says where.
set -u
LOG=${LOG:?}; mkdir -p $LOG
PKG=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
RF=_process/research/2026-10-05-generative-foundation-review/root-foundation; K=$RF/development/u4-one-root-to-its-edge
[ -e $K/land_u4.sh ] || { echo "run from the landing worktree's root"; exit 2; }
fail() { echo "FAILED: $1 (see $LOG)"; exit 1; }
step() { echo "== $1"; }
case ${1:-} in
prepare)
  [ -z "$(git status --porcelain --untracked-files=no)" ] || fail "tracked changes: $(git status --short | head -3)"
  step merge; git merge --no-edit refs/heads/main > $LOG/merge.log 2>&1 || fail "merge (resolve, then rerun prepare)"
  tail -1 $LOG/merge.log; grep -c '"Becoming.RootForms"' $PKG/check_becoming.py ;;
run)
  step checker; (cd $PKG && python3 -B check_becoming.py > $LOG/check.log 2>&1) || fail checker
  python3 - $PKG/becoming-verification.json <<'EOF' || fail "the run's summary"
import json, sys
d = json.load(open(sys.argv[1])); s = d['lean_steps']; ran = [x for x in s['ran'] if x in s['keys']]
assert d['status'] == 'passed', d['status']
print('passed', d['utc'], 'module steps run', len(ran), 'reused', len(s['reused']), 'of', len(s['keys']))
EOF
  ;;
post)
  N=$(python3 -c "import re; t = open('$RF/BECOMING-RENEWAL-READING.md', encoding='utf-8').read(); print(max(int(x) for x in re.findall(r'^## (\d+)\. ', t, re.M)) + 1)") || fail "the study's next section"
  [ -z "${2:-}" ] || [ "$2" = "$N" ] || fail "N given as $2, but the study's next free section is $N"
  echo "study section $N"
  ID=$(python3 -c "import json; print(json.load(open('$PKG/becoming-verification.json'))['utc'])")
  V=$PKG/becoming-checks/$ID/verification.json
  python3 - $V <<'EOF' || fail "axiom reports"
import json, sys
v = json.load(open(sys.argv[1])); assert v['status'] == 'passed'
bad = [(m['module'], n) for m in v['modules'] for n, a in m['axiom_dependencies'].items() if a]
assert not bad, bad[:5]
assert 'Becoming.RootForms' in {m['module'] for m in v['modules']}
print('receipt', sys.argv[1].split('/')[-2], len(v['modules']), 'modules, every axiom report empty')
EOF
  step table; python3 -B $K/boundary_table.py . --json $K/boundary-table.json > $LOG/bt.log 2>&1 || fail "boundary table"
  git diff --stat -- $K/boundary-table.json | tail -1
  step record; python3 -B $K/integrate_u4.py record $V $N > $LOG/record.log 2>&1 || fail record; tail -1 $LOG/record.log | cut -c1-200
  step mv; python3 -B tools/research/shared_laws.py > $LOG/mv.log 2>&1 || fail mv
  python3 -B $K/integrate_u4.py check > $LOG/u4check.log 2>&1 || fail "U4's check"; cut -c1-200 $LOG/u4check.log
  step register; M=$RF/THEOREM-CONNECTIVITY.py
  python3 -B $M --check > $LOG/conn-pre.log 2>&1
  python3 -B $K/integrate_u4.py register $LOG/conn-pre.log > $LOG/register.log 2>&1 || fail register; cat $LOG/register.log
  python3 -B $M --write > $LOG/conn-write.log 2>&1 || fail "connectivity write"
  python3 -B $M --check > $LOG/conn.log 2>&1 || fail "connectivity check"
  step study; python3 -B $K/integrate_u4.py study $N $V > $LOG/study.log 2>&1 || fail study; cat $LOG/study.log
  step render; python3 -B tools/research/research.py render > $LOG/render.log 2>&1 || fail render
  step strict; python3 -B tools/research/research.py check --strict-fresh > $LOG/strict.log 2>&1 || fail strict
  step links; python3 -B tools/research/research.py links > $LOG/links.log 2>&1 || fail links; grep '"broken"' $LOG/links.log
  step lint; python3 -B tools/research/research.py lint --ids one-root-to-its-edge > $LOG/lint.log 2>&1 || fail lint
  grep -q '"findings": 0' $LOG/lint.log || fail "the record's lint"
  step tests; python3 -B -m unittest discover -s tools/research/tests -p 'test_*.py' > $LOG/tests.log 2>&1 || fail tests
  grep -E "^Ran |^OK" $LOG/tests.log
  echo "== post done: receipt $ID, study section $N" ;;
*) echo "stage: prepare | run | post [N]"; exit 2 ;;
esac
