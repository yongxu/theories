#!/bin/zsh
# HE2's landing, in stages, from the checkout root of the landing worktree (he2-land). The design's steps 2 to 12;
# the head claim (step 2's first part), the board (13) and the fast-forward (14) are run by hand, each with its guard.
#   LOG=DIR zsh he2_land.sh prepare    restore the applied Lean files, merge main, scan for old names
#   LOG=DIR zsh he2_land.sh apply      every item's Lean part in the design's order, then every kit's check
#   LOG=DIR zsh he2_land.sh run        the checker in place (OUT=DIR writes the run outside the repository instead)
#   LOG=DIR zsh he2_land.sh post N     audit, records, register, texts, re-point, 08 and the study, MV, render, checks
# LOG holds every log (outside the repository). Each stage stops at the first failure and says where.
set -u
LOG=${LOG:?}; mkdir -p $LOG
PKG=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
RF=_process/research/2026-10-05-generative-foundation-review/root-foundation; D=$RF/development; K=$D/he2-held-edits/kit
[ -e $K/he2_land.sh ] || { echo "run from the landing worktree's root"; exit 2; }
fail() { echo "FAILED: $1 (see $LOG)"; exit 1; }
step() { echo "== $1"; }
case ${1:-} in
prepare)
  step restore; git diff -- $PKG > $LOG/applied-before-merge.diff
  A=(${(f)"$(git diff --name-only -- $PKG)"}); [ ${#A[@]} -gt 0 ] && [ -n "${A[1]}" ] && git checkout -- "${A[@]}"
  [ -z "$(git status --porcelain --untracked-files=no)" ] || fail "tracked changes remain: $(git status --short | head -3)"
  step merge; git merge --no-edit refs/heads/main > $LOG/merge.log 2>&1 || fail "merge (resolve, then rerun prepare)"
  tail -1 $LOG/merge.log
  step scan; python3 -B $D/rv21-one-sense/kit/he2_core_li.py --scan > $LOG/scan.log 2>&1 || fail scan; tail -2 $LOG/scan.log ;;
apply)
  step lean
  python3 -B $D/u4-one-root-to-its-edge/he2-items-2-to-4/he2_u4.py --apply lean > $LOG/apply24.log 2>&1 || fail "items 2-4"
  python3 -B $D/rv21-one-sense/kit/he2_core_li.py --apply lean > $LOG/apply67.log 2>&1 || fail "items 6-7"
  python3 -B $D/ou3b-master-laws-on-the-grammar/he2-item5/he2_item5.py --apply lean > $LOG/apply5.log 2>&1 || fail "item 5"
  python3 -B $D/ou3f-activity-laws/he2-item1/kit/apply_he2_item1.py $PKG > $LOG/apply1.log 2>&1 || fail "item 1"
  step checks
  python3 -B $D/u4-one-root-to-its-edge/he2-items-2-to-4/he2_u4.py --check > $LOG/check24.log 2>&1 || fail "items 2-4 check"
  python3 -B $D/rv21-one-sense/kit/he2_core_li.py --check > $LOG/check67.log 2>&1 || fail "items 6-7 check"
  python3 -B $D/ou3b-master-laws-on-the-grammar/he2-item5/he2_item5.py --check > $LOG/check5.log 2>&1 || fail "item 5 check"
  python3 -B $D/ou3f-activity-laws/he2-item1/kit/apply_he2_item1.py $PKG --check > $LOG/check1.log 2>&1 || fail "item 1 check"
  for f in check24 check67 check5 check1; do tail -1 $LOG/$f.log; done
  git diff --stat -- $PKG | tail -1 ;;
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
  N=${2:?the next study section N}
  ID=$(python3 -c "import json; print(json.load(open('$PKG/becoming-verification.json'))['utc'])")
  python3 - $PKG/becoming-checks/$ID/verification.json <<'EOF' || fail "axiom reports"
import json, sys
v = json.load(open(sys.argv[1])); assert v['status'] == 'passed'
bad = [(m['module'], n) for m in v['modules'] for n, a in m['axiom_dependencies'].items() if a]
assert not bad, bad[:5]
print('receipt', sys.argv[1].split('/')[-2], len(v['modules']), 'modules, every axiom report empty')
EOF
  step signatures; python3 -B $K/he2_signatures.py $ID > $LOG/sig.log 2>&1 || fail signatures; tail -1 $LOG/sig.log
  step records; python3 -B $K/he2_records.py $ID $N --check > $LOG/records-check.log 2>&1 || fail "records check"
  python3 -B $K/he2_records.py $ID $N > $LOG/records.log 2>&1 || fail records; tail -1 $LOG/records.log
  step register; M=$RF/THEOREM-CONNECTIVITY.py
  python3 -B $M --check > $LOG/conn-pre.log 2>&1
  python3 -B $D/u4-one-root-to-its-edge/he2-items-2-to-4/he2_u4.py --apply register $LOG/conn-pre.log > $LOG/reg24.log 2>&1 || fail "register 2-4"
  python3 -B $D/rv21-one-sense/kit/he2_core_li.py --apply register $LOG/conn-pre.log > $LOG/reg67.log 2>&1 || fail "register 6-7"
  python3 -B $M --write > $LOG/conn-write.log 2>&1 || fail "connectivity write"
  python3 -B $M --check > $LOG/conn.log 2>&1 || fail "connectivity check"
  step texts
  python3 -B $D/rv21-one-sense/kit/he2_core_li.py --apply texts > $LOG/texts67.log 2>&1 || fail "texts 6-7"
  python3 -B $D/ou3f-activity-laws/he2-item1/kit/apply_he2_item1.py --texts . --logic > $LOG/texts1.log 2>&1 || fail "texts 1"
  python3 tools/publishing/build_review_packet.py LOGIC.md PHILOSOPHY.md > $LOG/editions.log 2>&1 || fail editions
  python3 -B $D/review-packet/check_dossiers.py > $LOG/dossiers-texts.log 2>&1 || fail "dossiers after the texts"
  MK=$D/aj4-alignment-readers/kit/measure_layers.py; MKD=$D/aj4-alignment-readers/kit; MKNEW=; MKTMP=
  [ -d $MKD ] || { mkdir -p $MKD; MKNEW=1; }
  [ -e $MK ] || { git show 9e128d30e:$MK > $MK; MKTMP=1; }
  python3 -B $MK > $LOG/measure.log 2>&1; MS=$?; python3 -B $MK HEAD > $LOG/measure-before.log 2>&1
  [ -n "$MKTMP" ] && rm -f "./$MK"; [ -n "$MKNEW" ] && rmdir "./$MKD"
  [ $MS -eq 0 ] || fail measure; grep -i "front: logic" $LOG/measure-before.log $LOG/measure.log
  step repoint; python3 -B tools/research/research.py check > $LOG/rc.log 2>&1
  python3 - $LOG/rc.log $LOG/drift.json <<'EOF' || fail drift
import sys, json
t = open(sys.argv[1]).read(); d = json.loads(t[t.index('{'):t.rindex('}') + 1])
json.dump(d, open(sys.argv[2], 'w'), ensure_ascii=False, indent=1)
print('errors', len(d.get('errors', [])), 'drift', len(d.get('source_drift', [])))
EOF
  LEAN=(); for m in Grammar GrammarLaws GrammarRegularity GrammarScope GrammarCandidates GrammarMap MapRegions WideningOnTheMap HeldPossible PatternPassing Sampling Response SelectionPool; do LEAN+=($PKG/Becoming/$m.lean); done
  python3 -B tools/research/repoint.py --reason "$(sed "s/{N}/$N/" $K/he2_repoint_reason.txt)" --drift-json $LOG/drift.json \
    --receipt $PKG/becoming-checks/$ID/verification.json --lean "${LEAN[@]}" --apply > $LOG/repoint.log 2>&1 || fail repoint
  head -3 $LOG/repoint.log
  step study; python3 -B $K/he2_texts.py $ID $N $LOG/repoint.log $LOG/sig.log $LOG/conn.log --check > $LOG/texts-check.log 2>&1 || fail "study check"
  python3 -B $K/he2_texts.py $ID $N $LOG/repoint.log $LOG/sig.log $LOG/conn.log > $LOG/texts.log 2>&1 || fail study; tail -1 $LOG/texts.log
  step mv; python3 -B tools/research/master_laws.py > $LOG/mv.log 2>&1 || fail mv
  grep -o '"central_reach": {[^}]*}' $LOG/mv.log | tail -1
  step render; python3 -B tools/research/research.py render > $LOG/render.log 2>&1 || fail render
  step strict; python3 -B tools/research/research.py check --strict-fresh > $LOG/strict.log 2>&1 || fail strict
  step links; python3 -B tools/research/research.py links > $LOG/links.log 2>&1 || fail links
  step tests; python3 -B -m unittest discover -s tools/research/tests -p 'test_*.py' > $LOG/tests.log 2>&1 || fail tests
  grep -E "^Ran |^OK" $LOG/tests.log
  step dossiers; python3 -B $D/review-packet/check_dossiers.py > $LOG/dossiers.log 2>&1 || fail dossiers; tail -1 $LOG/dossiers.log
  echo "== post done: receipt $ID, study section $N" ;;
*) echo "stage: prepare | apply | run | post N"; exit 2 ;;
esac
