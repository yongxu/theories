#!/bin/zsh
# OU6 landing in its worktree after the core checker passed there: connectivity, texts, re-points, render and checks,
# then one commit. Does not touch main. usage: zsh land6.sh W L
set -e
W=$1; L=$2; mkdir -p $L
RF=_process/research/2026-10-05-generative-foundation-review/root-foundation
K=$RF/development/ou6-corrections
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
cd $W
RID=$(python3 -c "import json;print(json.load(open('$P/becoming-verification.json'))['utc'])")
python3 -c "import json;assert json.load(open('$P/becoming-checks/$RID/verification.json'))['status']=='passed'"
python3 -B $RF/THEOREM-CONNECTIVITY.py --check > $L/conn0.log 2>&1 || true
python3 -B $K/register6.py $L/conn0.log
python3 -B $RF/THEOREM-CONNECTIVITY.py --check > $L/conn1.log 2>&1 || { echo "connectivity failed"; grep "apart roots without" $L/conn1.log | cut -c1-1500; exit 1; }
python3 -B $K/land6.py | tee $L/land6.log
python3 -B tools/research/repoint.py --reason "OU6: the three grammar modules corrected (renames, the flame witnesses, 通 with its 往来, 息 inductive, docstrings) and the one-unfolding plan's status lines brought to them; both read before re-pointing; proof bindings rebound to the passing receipt" --ids continuation-relative-to-a-class classical-definitions-in-the-grammar generation-and-degeneration-at-two-grains --paths $RF/development/one-unfolding-root/PLAN.md $P/Becoming/Grammar.lean $P/Becoming/GrammarReadings.lean $P/Becoming/GrammarMap.lean --receipt $P/becoming-checks/$RID/verification.json --lean $P/Becoming/Grammar.lean $P/Becoming/GrammarReadings.lean $P/Becoming/GrammarMap.lean --apply > $L/repoint-lean.log 2>&1
# (bounded with --ids and --paths: without them the tool re-points every reference whose bytes changed)
make research-render > $L/render1.log 2>&1 || true
python3 -B tools/research/research.py check > $L/drift.json 2>/dev/null || true
echo "drift written to $L/drift.json: read it before re-pointing"
