#!/bin/zsh
# PL1 (+ CK1, CK2, CR1, EM1) reland on the current main: python files and Lean modules from SRC, everything else
# rebuilt by the scripts.  usage: zsh reland.sh SRC_WORKTREE   (from a clean worktree whose HEAD is main)
set -e
SRC=$1
L=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
D=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/pl1-pool-course
LOGS=${TMPDIR:-/tmp}/pl1-reland
mkdir -p $LOGS
for f in $L/Becoming/PoolCourse.lean $L/Becoming/Latency.lean $L/Becoming/Centers.lean; do cp $SRC/$f $f; done
mkdir -p $D && cp $SRC/$D/*.py $SRC/$D/reland.sh $D/
python3 -B $D/join_modules.py
(cd $L && python3 -B check_becoming.py > $LOGS/checker.log 2>&1)
TS=$(python3 -c "import json,sys; d=json.loads(open('$LOGS/checker.log').read().splitlines()[0]); assert d['status']=='passed' and d['core_axioms']==[]; print(d['receipt'])" >/dev/null && ls $L/becoming-checks | grep -v _objects | sort | tail -1)
echo "receipt $TS"
BEFORE=$(shasum -a 256 theories/becoming/chapters/THE-THEORY-OF-BECOMING.md | cut -d' ' -f1)
python3 -B $D/land_docs.py $TS
python3 -B -c "import sys; sys.path.insert(0,'$PWD/$D'); import land_ck2; land_ck2.main('$TS')"
python3 -B $D/repoint_drift.py $BEFORE
make research-render > $LOGS/render1.log 2>&1 || true
make research-check > $LOGS/check1.log 2>&1 || true
IDS=$(python3 - $LOGS/check1.log <<'EOF'
import json, sys
t = open(sys.argv[1]).read()
i = t.find('"source_drift"')
if i < 0:
    sys.exit(0)
j = t.index('[', i); depth = 0
for k in range(j, len(t)):
    if t[k] == '[': depth += 1
    elif t[k] == ']':
        depth -= 1
        if depth == 0: break
ok = {'## 5. How evaluation forms', '## 7. AI alignment', '## 8. Open programme'}
print(' '.join(x['id'] for x in json.loads(t[j:k + 1])
               if x['path'].endswith('THE-THEORY-OF-BECOMING.md') and set(x['changed_sections']) <= ok))
EOF
)
echo "drift: $IDS"
[ -n "$IDS" ] && python3 -B $D/repoint_drift.py 0000 ${=IDS}
make research-render > $LOGS/render.log 2>&1
make research-check > $LOGS/check.log 2>&1
make research-links > $LOGS/links.log 2>&1
make research-test > $LOGS/test.log 2>&1
echo "reland passed on $(git rev-parse --short HEAD), receipt $TS"
