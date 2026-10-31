#!/bin/bash
# RV21c, first part: the runs. Only once the coordinator says the round's last core landing (U4's leaf) is in and main
# checks clean; no core landing may go between this script's start and RV21c's landing (docs-only ones may). Holds no
# head clause. In a new worktree detached at main, the kit copied in: the receipts to rerun read from the records
# (plan_receipts.py, out/receipts.json, which kit.py then reads; cross-checked against stale_bound.py and
# stale_all.py), the bindings read, the fresh core run on an empty step cache kept for this slot (ASIDE/lean-cache),
# the stale periphery runs one at a time on that cache, so each reuses only steps earlier runs of this slot ran and
# kept (a failure kept as a finding), the older-layout step (run_older.py: formal, evolution, development, the
# coordinator's word of 31 October), their checks, the comparison and the core receipt's README, then one commit of
# the runs, the pointers and the kit on branch rv21c. Before any run, the older-layout plan is checked (its stale
# receipts none or exactly run_older.py's chain, every closure followed); before the commit, the core run folder's
# size and the re-points' dry run. After the commit, gates.sh: an axiom report changed between a checker's two runs
# and an older-layout checker not renewed route to the coordinator; a stale receipt left after the runs other than a
# failed one, and 08 §3 not naming the core receipt the runs began from (texts.py --check), stop; on success
# ASIDE/gates-passed holds the run commit.
# The head is claimed after (claim_head.sh), then land.sh.
# usage: run.sh WORKTREE ASIDE   (ASIDE a folder outside the repository for logs and the slot cache)
set -u
R=/Users/ren/theories
mkdir -p "$2" && ASIDE=$(cd "$2" && pwd) || exit 1
W=$(cd "$(dirname "$1")" && pwd)/$(basename "$1") || exit 1
K=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rv21c-fresh-receipts
PKG=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
export RV21C_CACHE="$ASIDE/lean-cache"
[ -e "$RV21C_CACHE" ] && { echo "SLOT CACHE EXISTS: $RV21C_CACHE (this slot's cache must start empty)"; exit 2; }
cd "$R" || exit 1
git show main:_process/BECOMING-WORKBOARD.md | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD"; exit 3; }
BASE=$(git rev-parse main); echo "main $BASE" | tee "$ASIDE/base.txt"
[ -e "$W" ] && { echo "WORKTREE EXISTS: $W"; exit 2; }
mkdir -p "$RV21C_CACHE"
git worktree add -q --detach "$W" "$BASE"; step worktree $?
cd "$W" || exit 1
[ -z "$(git status --porcelain)" ]; step clean $?
mkdir -p "$K" && cp "$R/$K"/*.py "$R/$K"/*.sh "$R/$K"/*.json "$R/$K"/PLAN.md "$K/"; step kit $?
python3 -B "$K/plan_receipts.py" HEAD > "$ASIDE/plan.txt" 2>&1; step plan $?
grep -e '^OLDER LAYOUT' -e '^PERIPHERY TO RERUN' "$ASIDE/plan.txt"
# Before any run: the stale older-layout receipts are none or exactly run_older.py's chain, every older-layout
# closure was followed (no import with a live file left unresolved), so the older step cannot stop on its plan.
python3 - "$K" <<'PY'; step older-plan $?
import json, sys
sys.path.insert(0, sys.argv[1])
from kit import OUT
import run_older
plan = json.loads((OUT / "receipts.json").read_text())["older_layout"]
stale = sorted(r for r, v in plan.items() if v["stale"])
gaps = {r: v["unresolved_live"] for r, v in plan.items() if v.get("unresolved_live")}
print("older layout stale:", stale or "none", "; walk gaps:", gaps or "none")
sys.exit(0 if stale in ([], sorted(c["receipt"] for c in run_older.CHAIN[1:])) and not gaps else 1)
PY
python3 -B "$K/stale_all.py" HEAD > "$ASIDE/stale-before.txt" 2>&1; step stale-before $?
tail -1 "$ASIDE/stale-before.txt"
# The pointer scan (stale_all.py, 29 pointers) must find nothing the record scan left out.
python3 - "$ASIDE/stale-before.txt" "$K" <<'PY'; step stale-in-plan $?
import sys
sys.path.insert(0, sys.argv[2])
from kit import RECEIPTS, stem
line = [l for l in open(sys.argv[1]) if l.startswith("STALE ")][-1]
stale = set(line.split(":", 1)[1].split())
missing = stale - {stem(p) for p in RECEIPTS}
print("stale pointers not in the plan:", sorted(missing) or "none")
sys.exit(1 if missing else 0)
PY
# The record scan's periphery checkers are exactly stale_bound.py's non-core stale ones.
python3 -B "$K/stale_bound.py" HEAD --json "$ASIDE/stale-bound.json" > "$ASIDE/stale-bound.txt" 2>&1; step stale-bound $?
tail -1 "$ASIDE/stale-bound.txt"
python3 - "$ASIDE/stale-bound.json" "$K" <<'PY'; step stale-bound-is-plan $?
import json, sys
sys.path.insert(0, sys.argv[2])
from kit import RECEIPTS
from plan_receipts import pointer_of
stale = {pointer_of(r) for r, v in json.load(open(sys.argv[1])).items() if v.get("differ") and not v.get("core")}
print("stale_bound.py's checkers not in the plan:", sorted(stale - set(RECEIPTS)) or "none",
      "; in the plan, not stale there:", sorted(set(RECEIPTS) - stale) or "none")
sys.exit(0 if stale == set(RECEIPTS) else 1)
PY
python3 -B "$K/bindings.py" > "$ASIDE/bindings.txt" 2>&1; step bindings $?
tail -1 "$ASIDE/bindings.txt"
BEFORE=$(python3 -c "import json;print(json.load(open('$PKG/becoming-verification.json'))['utc'])")
START=$(date +%s)
(cd "$PKG" && BECOMING_FRESH=1 BECOMING_LEAN_CACHE="$RV21C_CACHE" python3 -B check_becoming.py > "$ASIDE/core.log" 2>&1); step core $?
ID=$(python3 -c "import json;print(json.load(open('$PKG/becoming-verification.json'))['utc'])")
[ "$ID" != "$BEFORE" ]; step new-core-receipt $?
echo "$ID" > "$ASIDE/core-utc.txt"
echo "core receipt $ID in $(( $(date +%s) - START )) s" | tee "$ASIDE/core-id.txt"
mkdir -p "$K/out" && cp "$ASIDE/core.log" "$K/out/core.log"; step core-log $?
python3 -B "$K/run_periphery.py" 2>&1 | tee "$ASIDE/periphery.txt"
# The older-layout step: a failure is a finding (its in-place files restored), not a stop.
python3 -B "$K/run_older.py" > "$ASIDE/older.txt" 2>&1; echo "== older layout: exit $?"
cat "$ASIDE/older.txt"
python3 -B "$K/verify_runs.py" "$ID" HEAD > "$ASIDE/verify.txt" 2>&1; V=$?
tail -40 "$ASIDE/verify.txt"
step verify $V
python3 -B "$K/compare.py" HEAD > "$K/out/compare.txt" 2>&1; step compare $?
python3 -B "$K/stale_all.py" HEAD > "$K/out/stale-after.txt" 2>&1; step stale-after $?
tail -1 "$K/out/stale-after.txt"
# The run folder holds logs only; past 40 MB (the 16 October fresh receipt held 7.6 MB) decide what a verifier
# needs before the README says nothing else was left out.
du -sk "$PKG/becoming-checks/$ID" | awk '{exit !($1 < 40000)}'; step core-folder-size $?
# The re-points dry run here, so an assertion in them stops before the head is claimed.
python3 -B "$K/repoint_all.py" > "$ASIDE/repoint-dry-run.txt" 2>&1; step repoint-dry $?
python3 -B "$K/readme.py" "$ID" > "$ASIDE/readme.log" 2>&1; step readme $?
cp "$ASIDE/plan.txt" "$ASIDE/stale-before.txt" "$ASIDE/stale-bound.txt" "$ASIDE/bindings.txt" "$ASIDE/periphery.txt" \
  "$ASIDE/older.txt" "$ASIDE/verify.txt" "$K/out/"
git switch -q -c rv21c; step branch $?
git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths-runs.txt"
python3 -c "import json,sys; d=json.load(open(sys.argv[1])); print('\n'.join(x for v in d.get('receipts', {}).values() for x in v.get('changed', []) if v.get('passed') or x in v.get('kept', [])))" \
  "$K/out/older.json" > "$ASIDE/paths-older.txt"; step older-paths $?
grep -v -e "^$PKG/becoming-checks/$ID/" -e "^$K/" -e '-checks/[0-9TZ.]*/' -e '-verification\.json$' "$ASIDE/paths-runs.txt" \
  | grep -v -x -F -f "$ASIDE/paths-older.txt" && { echo "UNEXPECTED PATHS (above)"; exit 6; }
python3 - "$K" "$ID" "$BASE" > "$ASIDE/msg-runs.txt" <<'PY'; step message $?
import json, sys
sys.path.insert(0, sys.argv[1])
from kit import OUT, RECEIPTS, stem
status = json.loads((OUT / "status.json").read_text())
older = json.loads((OUT / "older.json").read_text())
passed = sum(1 for p in RECEIPTS if status[stem(p)]["passed"])
renewed = [r for r, v in older.get("receipts", {}).items() if v["passed"]]
print(f"RV21c's runs, before its head clause: the fresh core receipt {sys.argv[2]} (BECOMING_FRESH=1 on an empty step "
      f"cache kept for this slot, every Lean step run, every log kept, on main {sys.argv[3][:9]}, with its README) and "
      f"the {len(RECEIPTS)} periphery receipts whose record-bound runs bind core bytes changed since (plan_receipts.py), "
      "rerun one at a time on that cache, each reusing only steps earlier runs of this slot ran and kept: "
      f"{passed} passed, {len(RECEIPTS) - passed} failed and kept as findings (out/status.json). "
      + (f"Then the older-layout step: {len(renewed)} of {len(older['receipts'])} receipts renewed in place by "
         "their own checkers (out/older.json). " if older.get("receipts") else "")
      + "With the kit, the bindings read before the runs, the checks of the new receipts and the comparison with "
      "the receipts they replace. No record, text or board line changed yet.")
PY
git add --pathspec-from-file="$ASIDE/paths-runs.txt"; step add $?
git commit -q -F "$ASIDE/msg-runs.txt" --pathspec-from-file="$ASIDE/paths-runs.txt"; step commit $?
git log --oneline -1 | cut -c1-120
# Gates, after the runs are kept on the branch and before anything is held on main (gates.sh, which can be rerun
# alone with a coordinator's ruling).
bash "$K/gates.sh" "$W" "$ASIDE"; step gates $?
echo "next: claim_head.sh $W $ASIDE '<the coordinator's order sentence>', then land.sh $W $ASIDE $ID"
