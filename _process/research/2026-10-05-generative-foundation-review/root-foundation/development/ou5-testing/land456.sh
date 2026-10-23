#!/bin/zsh
# OU4 + OU5 + OU2c: the whole landing in a fresh worktree at main's HEAD; fast-forwards main only if it has not moved.
# usage: zsh land456.sh W L
set -e
W=$1; L=$2; mkdir -p $L
RF=_process/research/2026-10-05-generative-foundation-review/root-foundation
K4=$RF/development/ou4-map; K5=$RF/development/ou5-testing; K6=$RF/development/ou2-candidates
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
cd /Users/ren/theories
BASE=$(git rev-parse HEAD)
git worktree add --detach $W $BASE > /dev/null 2>&1
cd $W
OU_ROOT=$W python3 -B $K4/integrate3.py
OU_ROOT=$W python3 -B $K5/integrate5.py
OU_ROOT=$W python3 -B $K6/integrate6.py
(cd $P && python3 -B check_becoming.py) > $L/checker.log 2>&1 || { echo "checker failed"; exit 1; }
echo "checker passed $(python3 -c "import json;print(json.load(open('$P/becoming-verification.json'))['utc'])")"
python3 -B $RF/THEOREM-CONNECTIVITY.py --check > $L/conn0.log 2>&1 || true
python3 -B $K5/register456.py $L/conn0.log
python3 -B $RF/THEOREM-CONNECTIVITY.py --check > $L/conn1.log 2>&1 || { echo "connectivity failed"; grep "apart roots without" $L/conn1.log | cut -c1-1500; exit 1; }
N=$(python3 -c "import re;s=open('$RF/BECOMING-RENEWAL-READING.md',encoding='utf-8').read();print(max(int(m) for m in re.findall(r'^## (\d+)\. ',s,re.M))+1)")
python3 -B $K4/land3.py $N
python3 -B $K5/land5.py
python3 -B $K6/land6.py
make research-render > $L/render1.log 2>&1 || true
python3 -B tools/research/research.py check > $L/drift.json 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "OU4, OU5 and OU2c: sources revised since the records were reviewed (the one-unfolding plan by the second-round classification and the earlier landings); no claim of the re-pointed records changed; read before re-pointing" --drift-json $L/drift.json --apply > $L/repoint.log 2>&1
make research-render > $L/render2.log 2>&1 || { echo "render failed"; tail -20 $L/render2.log; exit 1; }
make research-check > $L/check2.log 2>&1 || { echo "check failed"; grep -A8 '"errors"' $L/check2.log; exit 1; }
make research-links > $L/links.log 2>&1 || { echo "links failed"; tail -20 $L/links.log; exit 1; }
make research-test > $L/test.log 2>&1 || { echo "test failed"; tail -20 $L/test.log; exit 1; }
python3 -B $RF/THEOREM-CONNECTIVITY.py --write > $L/cwrite.log 2>&1
make research-render > $L/render3.log 2>&1 || { echo "render3 failed"; exit 1; }
make research-check > $L/check3.log 2>&1 || { echo "check3 failed"; grep -A8 '"errors"' $L/check3.log; exit 1; }
cp $L/checker.log $K5/checker-ou456.log
git add -A
git commit -q -F $K5/commit-msg.txt
C=$(git rev-parse HEAD)
cd /Users/ren/theories
if [ "$(git rev-parse HEAD)" = "$BASE" ]; then
  git merge --ff-only $C > /dev/null && echo "main fast-forwarded to $C"
else
  echo "main moved from $BASE to $(git rev-parse HEAD); landing commit $C kept in the worktree"
fi
