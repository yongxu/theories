#!/bin/zsh
# U1b's landing, in stages, from the checkout root of the landing worktree (branch u1b). The head claim, the board's
# landed clause and the fast-forward are run by hand, each with its guard (re-read the Queue line before --ff-only).
#   LOG=DIR zsh land_u1b.sh prepare    merge main (refs/heads/main), with no tracked change left before it
#   LOG=DIR zsh land_u1b.sh run        the checker in place (one incremental core run; UnitMatchings joins the core)
#   LOG=DIR zsh land_u1b.sh post [N]   08 §3's sentence, 01 §8.6's home section, regions and the record; MV's data and
#                                      U1b's check; the apart register; the study's section N (the next free one, read
#                                      after main is merged; a given N must match); render, checks, links, lint, tests
# LOG holds every log (outside the repository). Each stage stops at the first failure and says where. No stage commits.
set -u
LOG=${LOG:?}; mkdir -p $LOG
PKG=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
RF=_process/research/2026-10-05-generative-foundation-review/root-foundation; K=$RF/development/u1-balance-under-units/u1b
RID=amounts-by-unit-matchings
[ -e $K/land_u1b.sh ] || { echo "run from the landing worktree's root"; exit 2; }
fail() { echo "FAILED: $1 (see $LOG)"; exit 1; }
step() { echo "== $1"; }
case ${1:-} in
prepare)
  [ -z "$(git status --porcelain --untracked-files=no)" ] || fail "tracked changes: $(git status --short | head -3)"
  step merge; git merge --no-edit refs/heads/main > $LOG/merge.log 2>&1 || fail "merge (resolve, then rerun prepare)"
  tail -1 $LOG/merge.log
  # The leaf's four places survive the merge once each, and the kit's copy is still the package's bytes.
  [ "$(grep -c '"Becoming.UnitMatchings"' $PKG/check_becoming.py)" = 1 ] || fail "the core list after the merge"
  [ "$(grep -c '^import Becoming.UnitMatchings$' $PKG/Becoming.lean)" = 1 ] || fail "the import after the merge"
  [ "$(grep -c '^| L1 | \[`Becoming.UnitMatchings`\]' $PKG/README.md)" = 1 ] || fail "the README row after the merge"
  cmp -s $K/Becoming/UnitMatchings.lean $PKG/Becoming/UnitMatchings.lean || fail "the kit's leaf and the package's differ"
  echo "the leaf's places are intact" ;;
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
m = {x['module']: x for x in v['modules']}['Becoming.UnitMatchings']
print('receipt', sys.argv[1].split('/')[-2], len(v['modules']), 'modules, every axiom report empty; UnitMatchings',
      m['theorems'], 'theorems in', len(m['declarations']), 'declarations')
EOF
  step record; python3 -B $K/integrate_u1b.py record $V $N > $LOG/record.log 2>&1 || fail record; cut -c1-200 $LOG/record.log
  step mv; python3 -B tools/research/master_laws.py > $LOG/mv.log 2>&1 || fail mv
  python3 -B $K/integrate_u1b.py check > $LOG/u1bcheck.log 2>&1 || fail "U1b's check"; cut -c1-200 $LOG/u1bcheck.log
  step register; M=$RF/THEOREM-CONNECTIVITY.py
  python3 -B $M --check > $LOG/conn-pre.log 2>&1
  python3 -B $K/integrate_u1b.py register $LOG/conn-pre.log > $LOG/register.log 2>&1 || fail register; cat $LOG/register.log
  python3 -B $M --write > $LOG/conn-write.log 2>&1 || fail "connectivity write"
  python3 -B $M --check > $LOG/conn.log 2>&1 || fail "connectivity check"
  step study; python3 -B $K/integrate_u1b.py study $N $V > $LOG/study.log 2>&1 || fail study; cat $LOG/study.log
  step render; python3 -B tools/research/research.py render > $LOG/render.log 2>&1 || fail render
  step strict; python3 -B tools/research/research.py check --strict-fresh > $LOG/strict.log 2>&1 || fail strict
  step links; python3 -B tools/research/research.py links > $LOG/links.log 2>&1 || fail links; grep '"broken"' $LOG/links.log
  # The record's lint: no error; its warnings are listed (record-text.json's prose, OU's owner's to shorten or keep).
  step lint; python3 -B tools/research/research.py lint --ids $RID > $LOG/lint.log 2>&1 || fail lint
  python3 - $LOG/lint.log <<'EOF' || fail "the record's lint"
import json, sys
d = json.load(open(sys.argv[1]))
errors = [f for f in d['findings'] if f['severity'] == 'error'] + d.get('errors', [])
for f in d['findings']:
    print(' ', f['severity'], f['field'], f['rule'], f['detail'])
assert not errors, errors
print('lint: no error,', d['summary']['findings'], 'findings in all')
EOF
  step tests; python3 -B -m unittest discover -s tools/research/tests -p 'test_*.py' > $LOG/tests.log 2>&1 || fail tests
  grep -E "^Ran |^OK" $LOG/tests.log
  echo "== post done: receipt $ID, study section $N" ;;
*) echo "stage: prepare | run | post [N]"; exit 2 ;;
esac
