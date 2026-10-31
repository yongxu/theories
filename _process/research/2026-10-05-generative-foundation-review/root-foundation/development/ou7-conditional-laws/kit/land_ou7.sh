#!/bin/zsh
# OU7's landing, in stages, from the checkout root of the landing worktree (the branch holding parts A and B). The head
# claim, the board's landed clause and the fast-forward are run by hand, each with its guard (re-read the Queue line
# before --ff-only). The near-full rebuild comes last in the core round: no stage runs before OU's owner says.
#   LOG=DIR zsh land_ou7.sh prepare    merge main (refs/heads/main), with no tracked change left before it; every patch
#                                      of the kit checked against the merged tree
#   LOG=DIR zsh land_ou7.sh apply      the Grammar, GrammarReadings and OU plan patches, then patches/owner/ in name
#                                      order; the leaf and its joins; the patches' audit
#   LOG=DIR zsh land_ou7.sh run        the checker in place (OUT=DIR writes the run outside the repository instead)
#   LOG=DIR zsh land_ou7.sh post [N]   08 §3's sentence, 06's home section and lines, regions and the record; MV's data
#                                      and OU7's check; the apart register; the study's section N (the next free one,
#                                      read after main is merged; a given N must match); the re-point of the records
#                                      whose sources the patches changed; render, checks, links, lint, tests
# LOG holds every log (outside the repository). Each stage stops at the first failure and says where. No stage commits.
set -u
LOG=${LOG:?}; mkdir -p $LOG
PKG=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
RF=_process/research/2026-10-05-generative-foundation-review/root-foundation; K=$RF/development/ou7-conditional-laws/kit
RID=conditional-laws-of-the-corpus
[ -e $K/land_ou7.sh ] || { echo "run from the landing worktree's root"; exit 2; }
fail() { echo "FAILED: $1 (see $LOG)"; exit 1; }
step() { echo "== $1"; }
case ${1:-} in
prepare)
  [ -z "$(git status --porcelain --untracked-files=no)" ] || fail "tracked changes: $(git status --short | head -3)"
  step merge; git merge --no-edit refs/heads/main > $LOG/merge.log 2>&1 || fail "merge (resolve, then rerun prepare)"
  tail -1 $LOG/merge.log
  step patches
  for p in $K/patches/*.patch $K/patches/owner/*.patch(N); do
    git apply --check $p > $LOG/check-${p:t}.log 2>&1 || fail "${p:t} does not apply to the merged tree"
  done
  [ ! -e $PKG/Becoming/GrammarConditionals.lean ] || fail "the package already has a GrammarConditionals.lean"
  echo "every patch applies to the merged tree" ;;
apply)
  step apply; python3 -B $K/integrate_ou7.py apply > $LOG/apply.log 2>&1 || fail apply; cat $LOG/apply.log
  step audit; python3 -B $K/integrate_ou7.py audit > $LOG/audit.log 2>&1 || fail audit; tail -3 $LOG/audit.log
  git diff --stat | tail -1 ;;
run)
  step checker
  if [ -n "${OUT:-}" ]; then (cd $PKG && BECOMING_OUT=$OUT python3 -B check_becoming.py > $LOG/check.log 2>&1) || fail checker
  else (cd $PKG && python3 -B check_becoming.py > $LOG/check.log 2>&1) || fail checker; fi
  V=${OUT:-$PKG}/becoming-verification.json
  python3 - $V <<'EOF' || fail "the run's summary"
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
m = {x['module']: x for x in v['modules']}
c = m['Becoming.GrammarConditionals']
print('receipt', sys.argv[1].split('/')[-2], len(v['modules']), 'modules, every axiom report empty; GrammarConditionals',
      c['theorems'], 'theorems in', len(c['declarations']), 'declarations; Grammar', len(m['Becoming.Grammar']['declarations']),
      'and GrammarReadings', len(m['Becoming.GrammarReadings']['declarations']), 'declarations')
EOF
  step record; python3 -B $K/integrate_ou7.py record $V $N > $LOG/record.log 2>&1 || fail record; cut -c1-200 $LOG/record.log
  step mv; python3 -B tools/research/master_laws.py > $LOG/mv.log 2>&1 || fail mv
  python3 -B $K/integrate_ou7.py check > $LOG/ou7check.log 2>&1 || fail "OU7's check"; cut -c1-200 $LOG/ou7check.log
  step register; M=$RF/THEOREM-CONNECTIVITY.py
  python3 -B $M --check > $LOG/conn-pre.log 2>&1
  python3 -B $K/integrate_ou7.py register $LOG/conn-pre.log > $LOG/register.log 2>&1 || fail register; cat $LOG/register.log
  python3 -B $M --write > $LOG/conn-write.log 2>&1 || fail "connectivity write"
  python3 -B $M --check > $LOG/conn.log 2>&1 || fail "connectivity check"
  step study; python3 -B $K/integrate_ou7.py study $N $V > $LOG/study.log 2>&1 || fail study; cat $LOG/study.log
  # The records pinning a source the patches changed (Grammar, GrammarReadings, the OU plan, and whatever the owner's
  # patches change): read with each source before this stage, then re-pointed as bookkeeping, the Lean files' proof
  # bindings rebound to this receipt. Owner patches add their own reason to repoint_reason.txt.
  step repoint; python3 -B tools/research/research.py check > $LOG/rc.log 2>&1
  python3 - $LOG/rc.log $LOG/drift.json <<'EOF' || fail drift
import sys, json
t = open(sys.argv[1]).read(); d = json.loads(t[t.index('{'):t.rindex('}') + 1])
json.dump(d, open(sys.argv[2], 'w'), ensure_ascii=False, indent=1)
print('errors', len(d.get('errors', [])), 'drift', len(d.get('source_drift', [])),
      sorted({x['id'] for x in d.get('source_drift', [])}))
EOF
  LEAN=(${(f)"$(git diff --name-only HEAD -- $PKG/Becoming | grep '\.lean$')"})
  python3 -B tools/research/repoint.py --reason "$(sed "s/{N}/$N/" $K/repoint_reason.txt)" --drift-json $LOG/drift.json \
    --receipt $V --lean "${LEAN[@]}" --apply > $LOG/repoint.log 2>&1 || fail repoint
  head -3 $LOG/repoint.log
  step render; python3 -B tools/research/research.py render > $LOG/render.log 2>&1 || fail render
  step strict; python3 -B tools/research/research.py check --strict-fresh > $LOG/strict.log 2>&1 || fail strict
  python3 - $LOG/strict.log <<'EOF' || fail "drift after the re-point"
import sys, json
t = open(sys.argv[1]).read(); d = json.loads(t[t.index('{'):t.rindex('}') + 1])
assert not d.get('source_drift') and not d.get('unrelated_source_drift'), (d.get('source_drift'), d.get('unrelated_source_drift'))
print('no source drift')
EOF
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
*) echo "stage: prepare | apply | run | post [N]"; exit 2 ;;
esac
