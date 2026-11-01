#!/bin/zsh
# DU's landing, in stages, from the checkout root of the landing worktree (branch du-claim), as U1b's land_u1b.sh. The
# package join (the two leaves, Becoming.lean's imports and notes, the checker's core list and scope, the rows of
# README.md and README.zh.md, as U1b's join carried both) and this kit are committed on the branch before prepare, by
# the lander. The head claim, the board's landed clause, the history row and the fast-forward are run by hand, each
# with its guard (re-read the Queue line before --ff-only).
#   LOG=DIR zsh land_du.sh prepare      merge main (refs/heads/main), with no tracked change left before it; the
#                                       leaves' places, and every text, pattern and prior state the later stages read
#                                       (integrate_du.py anchors), so a moved main stops here and not midway through post
#   LOG=DIR zsh land_du.sh run          the checker in place (one incremental core run; the two leaves join the core)
#   LOG=DIR zsh land_du.sh post [N]     both leaves' receipts; 08 §3's sentence, the three home sections, regions,
#                                       COVERAGE and the three records; MV's data and DU's check; the apart register;
#                                       the texts (08 §7, the edge paragraph and its generator, 04, WHAT-REMAINS, the
#                                       front pages, READING-BUDGETS, the Chinese README's rows checked); the three
#                                       records written again against the chapters as the texts leave them (08 §7
#                                       changes after the first writing); MV and DU's check again; the re-points as a
#                                       dry run, which lists the pairs to read. It stops there.
#   LOG=DIR zsh land_du.sh finish [N]   after the lander has read each pair the dry run lists under "read before
#                                       --apply" (the records citing 04, against its new Bases; those citing the
#                                       overview, against its two lines): the re-points written; the study's section N
#                                       (the next free one, read after main is merged; a given N must match); render,
#                                       checks, links, lint, tests
# LOG holds every log (outside the repository). Each stage stops at the first failure and says where. No stage commits.
set -u
LOG=${LOG:?}; mkdir -p $LOG
PKG=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
RF=_process/research/2026-10-05-generative-foundation-review/root-foundation; K=$RF/development/du-deep-unification-review/kit
RIDS=(premises-met-and-failed self-concern-and-c-under-the-condition standings-not-read-off-the-occurrence-model)
LEAVES=(PremiseWitnesses UnreadStandings)
[ -e $K/land_du.sh ] || { echo "run from the landing worktree's root"; exit 2; }
fail() { echo "FAILED: $1 (see $LOG)"; exit 1; }
step() { echo "== $1"; }
case ${1:-} in
prepare)
  [ -z "$(git status --porcelain --untracked-files=no)" ] || fail "tracked changes: $(git status --short | head -3)"
  for m in $LEAVES; do
    git ls-files --error-unmatch $PKG/Becoming/$m.lean $K/Becoming/$m.lean > /dev/null 2>&1 || fail "$m is not committed"
  done
  step merge; git merge --no-edit refs/heads/main > $LOG/merge.log 2>&1 || fail "merge (resolve, then rerun prepare)"
  tail -1 $LOG/merge.log
  # Each leaf's five places (the core list, the import, the two READMEs' rows; the note is in Becoming.lean beside its
  # import) survive the merge once each, and the kit's copy is still the package's bytes.
  for m in $LEAVES; do
    [ "$(grep -c "\"Becoming.$m\"" $PKG/check_becoming.py)" = 1 ] || fail "$m: the core list after the merge"
    [ "$(grep -c "^import Becoming.$m\$" $PKG/Becoming.lean)" = 1 ] || fail "$m: the import after the merge"
    [ "$(grep -c "^| L[12] | \[\`Becoming.$m\`\]" $PKG/README.md)" = 1 ] || fail "$m: the README row after the merge"
    [ "$(grep -c "^| L[12] | \[\`Becoming.$m\`\]" $PKG/README.zh.md)" = 1 ] || fail "$m: the Chinese README row after the merge"
    cmp -s $K/Becoming/$m.lean $PKG/Becoming/$m.lean || fail "$m: the kit's leaf and the package's differ"
  done
  # Every text, pattern and prior state the record, register and texts stages read is still where they read it, each
  # once, on the merged files: integrate_du.py anchors, a dry run that writes nothing.
  python3 -B $K/integrate_du.py anchors > $LOG/anchors.log 2>&1 || { cat $LOG/anchors.log; fail "the kit's anchors on the merged files"; }
  tail -1 $LOG/anchors.log
  echo "the leaves' places are intact" ;;
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
by = {x['module']: x for x in v['modules']}
print('receipt', sys.argv[1].split('/')[-2], len(v['modules']), 'modules, every axiom report empty;', '; '.join(
    f"{m.removeprefix('Becoming.')} {by[m]['theorems']} theorems in {len(by[m]['declarations'])} declarations, {by[m]['layer']}"
    for m in ('Becoming.PremiseWitnesses', 'Becoming.UnreadStandings')))
EOF
  step record; python3 -B $K/integrate_du.py record $V $N > $LOG/record.log 2>&1 || fail record; cut -c1-200 $LOG/record.log
  step mv; python3 -B tools/research/shared_laws.py > $LOG/mv.log 2>&1 || fail mv
  python3 -B $K/integrate_du.py check > $LOG/ducheck.log 2>&1 || fail "DU's check"; cut -c1-240 $LOG/ducheck.log
  step register; M=$RF/THEOREM-CONNECTIVITY.py
  python3 -B $M --check > $LOG/conn-pre.log 2>&1
  python3 -B $K/integrate_du.py register $LOG/conn-pre.log > $LOG/register.log 2>&1 || fail register; cat $LOG/register.log
  python3 -B $M --write > $LOG/conn-write.log 2>&1 || fail "connectivity write"
  python3 -B $M --check > $LOG/conn.log 2>&1 || fail "connectivity check"
  step texts; python3 -B $K/integrate_du.py texts $LOG $ID $N > $LOG/texts.log 2>&1 || fail texts; cut -c1-240 $LOG/texts.log
  # The texts rewrite 08 §7 after the record stage hashed 08 for premises-met-and-failed (its statement reference):
  # write the three records again from the chapters as they now stand. Every other edit of that stage is in place
  # (08 §3's sentence matches again, the homes are skipped, regions and COVERAGE are unchanged).
  step "record again"; python3 -B $K/integrate_du.py record $V $N > $LOG/record2.log 2>&1 || fail "record after the texts"
  cut -c1-200 $LOG/record2.log
  # The boundary record's history note and make_record_u4.py change after shared_laws.py read them: read again.
  python3 -B tools/research/shared_laws.py > $LOG/mv2.log 2>&1 || fail "mv after the texts"
  python3 -B $K/integrate_du.py check > $LOG/ducheck2.log 2>&1 || fail "DU's check after the texts"
  # Render exits non-zero while records drift, which they do until the re-points; accept that only with no error.
  step "render (for the re-points)"; python3 -B tools/research/research.py render > $LOG/render-pre.log 2>&1 || \
    python3 -c "import json, sys; d = json.load(open(sys.argv[1])); assert d['errors'] == [], d['errors']; print('render: no error,', len(d.get('source_drift', [])), 'records drift until the re-points')" $LOG/render-pre.log || fail "render"
  step repoint; python3 -B $K/integrate_du.py repoint > $LOG/repoint-dry.log 2>&1 || fail "repoint (dry run)"
  cut -c1-240 $LOG/repoint-dry.log
  echo "== post done: receipt $ID, study section $N. Read each pair under 'read before --apply' in $LOG/repoint-dry.log"
  echo "   against the new text (04's Bases; the overview's two lines), then: LOG=$LOG zsh $K/land_du.sh finish $N" ;;
finish)
  N=$(python3 -c "import re; t = open('$RF/BECOMING-RENEWAL-READING.md', encoding='utf-8').read(); print(max(int(x) for x in re.findall(r'^## (\d+)\. ', t, re.M)) + 1)") || fail "the study's next section"
  [ -z "${2:-}" ] || [ "$2" = "$N" ] || fail "N given as $2, but the study's next free section is $N"
  ID=$(python3 -c "import json; print(json.load(open('$PKG/becoming-verification.json'))['utc'])")
  V=$PKG/becoming-checks/$ID/verification.json
  [ -s $LOG/repoint-dry.log ] || fail "no dry run of the re-points in LOG: run post first"
  step repoint; python3 -B $K/integrate_du.py repoint --apply > $LOG/repoint.log 2>&1 || fail repoint; tail -3 $LOG/repoint.log
  step study; python3 -B $K/integrate_du.py study $N $V $LOG > $LOG/study.log 2>&1 || fail study; cat $LOG/study.log
  step render; python3 -B tools/research/research.py render > $LOG/render.log 2>&1 || fail render
  step strict; python3 -B tools/research/research.py check --strict-fresh > $LOG/strict.log 2>&1 || fail strict
  step links; python3 -B tools/research/research.py links > $LOG/links.log 2>&1 || fail links; grep '"broken"' $LOG/links.log
  # The records' lint: no error; their warnings are listed (records-text.json's prose, OU's owner's to shorten or keep).
  step lint; python3 -B tools/research/research.py lint --ids $RIDS > $LOG/lint.log 2>&1 || fail lint
  python3 - $LOG/lint.log <<'EOF' || fail "the records' lint"
import json, sys
d = json.load(open(sys.argv[1]))
errors = [f for f in d['findings'] if f['severity'] == 'error'] + d.get('errors', [])
for f in d['findings']:
    print(' ', f.get('id', ''), f['severity'], f['field'], f['rule'], f['detail'])
assert not errors, errors
print('lint: no error,', d['summary']['findings'], 'findings in all')
EOF
  step tests; python3 -B -m unittest discover -s tools/research/tests -p 'test_*.py' > $LOG/tests.log 2>&1 || fail tests
  grep -E "^Ran |^OK" $LOG/tests.log
  echo "== post done: receipt $ID, study section $N" ;;
*) echo "stage: prepare | run | post [N] | finish [N]"; exit 2 ;;
esac
