#!/bin/zsh
# OU4 + OU5, second half (after registering the roots). usage: zsh land45b.sh W L
set -e
W=$1; L=$2
RF=_process/research/2026-10-05-generative-foundation-review/root-foundation
K4=$RF/development/ou4-map; K5=$RF/development/ou5-testing; K6=$RF/development/ou2-candidates
cd $W
python3 -B $RF/THEOREM-CONNECTIVITY.py --check > $L/conn1.log 2>&1 || { echo connectivity failed; grep "apart roots without" $L/conn1.log | cut -c1-2000; exit 1; }
N=$(python3 -c "import re;s=open('$RF/BECOMING-RENEWAL-READING.md',encoding='utf-8').read();print(max(int(m) for m in re.findall(r'^## (\d+)\. ',s,re.M))+1)")
python3 -B $K4/land3.py $N
python3 -B $K5/land5.py
python3 -B $K6/land6.py
make research-render > $L/render.log 2>&1 || true
python3 -B tools/research/research.py check > $L/drift.json 2>/dev/null || true
echo done-texts
