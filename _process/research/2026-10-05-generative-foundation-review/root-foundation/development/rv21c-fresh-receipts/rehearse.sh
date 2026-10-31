#!/bin/bash
# RV21c's rehearsal, in a throwaway worktree detached at main (never committed, never landed), with no core run: the
# plan narrowed to the chosen checkers (so every later script takes them as the whole list), the bindings, those
# checkers on an empty slot cache (the first on each toolchain compiles what it needs), the older-layout step (run for
# real here: formal, evolution, development, minutes on Std), the checks (the core's reported not fresh, as expected),
# the comparison, the README and texts.py --check (the core receipt on main
# standing in for the fresh one), then land.sh's steps without the merge and the head claim: the re-points, the stamp
# swap, check_repoint, the plan after, the texts, master laws, the connectivity, render, the text re-points, the board's
# head and landed clauses on the worktree's board, render, strict check, links and tests. It tests the scripts, not
# the receipts.
# usage: rehearse.sh WORKTREE ASIDE STEM [STEM ...]
set -u
R=/Users/ren/theories
mkdir -p "$2" && ASIDE=$(cd "$2" && pwd) || exit 1
W=$(cd "$(dirname "$1")" && pwd)/$(basename "$1") || exit 1
shift 2
K=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rv21c-fresh-receipts
PKG=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
STUDY=_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md
C=_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY.py
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
export RV21C_CACHE="$ASIDE/lean-cache"
[ -e "$RV21C_CACHE" ] && { echo "SLOT CACHE EXISTS: $RV21C_CACHE"; exit 2; }
mkdir -p "$RV21C_CACHE"
export BECOMING_LEAN_CACHE="$RV21C_CACHE"
cd "$R" || exit 1
[ -e "$W" ] && { echo "WORKTREE EXISTS: $W"; exit 2; }
BASE=$(git rev-parse main)
git worktree add -q --detach "$W" "$BASE"; step worktree $?
cd "$W" || exit 1
mkdir -p "$K" && cp "$R/$K"/*.py "$R/$K"/*.sh "$R/$K"/*.json "$R/$K"/PLAN.md "$K/"; step kit $?
python3 -B "$K/plan_receipts.py" HEAD > "$ASIDE/plan.txt" 2>&1; step plan $?
grep -e '^OLDER LAYOUT' -e '^PERIPHERY TO RERUN' "$ASIDE/plan.txt"
python3 - "$K/out/receipts.json" "$@" <<'PY'; step narrow $?
import json, sys
from pathlib import Path
p = Path(sys.argv[1]); plan = json.loads(p.read_text()); want = set(sys.argv[2:])
plan["receipts"] = [r for r in plan["receipts"] if Path(r).stem in want]
assert {Path(r).stem for r in plan["receipts"]} == want, "a chosen checker is not in the plan"
for k in ("stale_bound_runs", "records"):
    plan[k] = {r: v for r, v in plan[k].items() if r in plan["receipts"]}
p.write_text(json.dumps(plan, indent=1) + "\n")
print("rehearsing", plan["receipts"])
PY
python3 -B "$K/bindings.py" > "$ASIDE/bindings.txt" 2>&1; step bindings $?
tail -1 "$ASIDE/bindings.txt"
ID=$(python3 -c "import json;print(json.load(open('$PKG/becoming-verification.json'))['utc'])")
python3 -B "$K/run_periphery.py" 2>&1 | tee "$ASIDE/periphery.txt"
python3 -B "$K/run_older.py" > "$ASIDE/older.txt" 2>&1; echo "== older layout: exit $?"
cat "$ASIDE/older.txt"
python3 - "$K/out/older.json" <<'PY'
import json, sys
for r, v in json.load(open(sys.argv[1])).get("receipts", {}).items():
    print(r.split("formation/")[-1], "passed" if v["passed"] else "FAILED", v.get("audits"),
          "axioms changed in", sorted(v.get("axioms_changed", {})), "bound", v.get("bound_modules"), v.get("changed"))
PY
python3 -B "$K/verify_runs.py" "$ID" HEAD > "$ASIDE/verify.txt" 2>&1; echo "== verify (core not fresh expected): exit $?"
cat "$ASIDE/verify.txt"
python3 -B "$K/verify_runs.py" "$ID" main --no-write > "$ASIDE/verify-main.txt" 2>&1; echo "== verify --no-write against main: exit $?"
python3 -B "$K/compare.py" HEAD > "$ASIDE/compare.txt" 2>&1; step compare $?
cat "$ASIDE/compare.txt"
python3 -B "$K/readme.py" "$ID" > "$ASIDE/readme.log" 2>&1; step readme $?
python3 -B "$K/texts.py" --check "$ID" "$BASE" > "$ASIDE/texts-check.txt" 2>&1; T=$?; cat "$ASIDE/texts-check.txt"; step texts-check $T
git show "main:theories/becoming/chapters/08-METHOD.md" > "$ASIDE/08-main.md"
python3 -B "$K/texts.py" --check "$ID" "$BASE" --chapter "$ASIDE/08-main.md" > "$ASIDE/texts-check2.txt" 2>&1; step texts-check-chapter $?
# main's queue may be held by another landing; the rehearsal board drops any head clause first.
python3 - _process/BECOMING-WORKBOARD.md <<'PY'; step strip-head $?
import sys
from pathlib import Path
p = Path(sys.argv[1]); lines = p.read_text(encoding="utf-8").split("\n")
q = [i for i, l in enumerate(lines) if l.startswith("- **Queue:** ")][0]
prefix, rest = "- **Queue:** ", lines[q][len("- **Queue:** "):]
# Any clause holding the head, however it is worded ("at the head of the queue (landing now", "at the head (landing
# now, ..."): the first clause of the line, up to the "; " after the parenthesis that opens with "(landing now".
while "(landing now" in rest[:400]:
    j = rest.index("(landing now")
    depth = 0
    for k in range(j, len(rest)):
        depth += {"(": 1, ")": -1}.get(rest[k], 0)
        if depth == 0:
            break
    assert rest[k + 1:k + 3] == "; ", rest[k:k + 20]
    print("dropped:", rest[:60], "...")
    rest = rest[k + 3:]
lines[q] = prefix + rest
p.write_text("\n".join(lines), encoding="utf-8")
PY
python3 -B "$K/board_rv21c.py" check _process/BECOMING-WORKBOARD.md \
  _process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md \
  "Then, in the coordinator's order: UE26; ask the coordinator for a slot." > "$ASIDE/board-check.log" 2>&1; step board-check $?
# The head clause with a failed periphery checker and a failed older checker still matches the regex every board
# script finds it by (a self-test on fabricated rows, in ASIDE).
python3 -B - "$K" "$ASIDE/headtest" <<'PY'; step head-clause-with-failures $?
import json, sys
from pathlib import Path
sys.path.insert(0, sys.argv[1])
import board_rv21c as b
from kit import RECEIPTS, stem
out = Path(sys.argv[2]); out.mkdir(exist_ok=True)
(out / "status.json").write_text(json.dumps({stem(p): {"passed": i != 0} for i, p in enumerate(RECEIPTS)}))
(out / "older.json").write_text(json.dumps({"receipts": {
    "a/formation/formal/verification.json": {"passed": False},
    "a/formation/evolution/verification.json": {"passed": False, "not_run": "formal failed first"}}}))
b.OUT = out
clause = f"RV21c at the head of the queue ({b.head_text()}); "
assert b.HEAD.fullmatch(clause), clause
print("head clause with failures matches:", clause[:120])
PY
python3 -B "$K/board_rv21c.py" head > "$ASIDE/board-head.log" 2>&1; step board-head $?
python3 -B -c "import sys; sys.path.insert(0, '$K'); import board_rv21c; print(board_rv21c.head_text())"
python3 -B "$K/repoint_all.py" > "$ASIDE/repoint-dry.txt" 2>&1; step repoint-dry $?
grep -v 'no record binds' "$ASIDE/repoint-dry.txt"
python3 -B "$K/repoint_all.py" --apply > "$K/out/repoint.txt" 2>&1; step repoint $?
# As gates.sh (the check) and land.sh (the rewrite) run it, with the main the runs began from as the earlier receipts.
N=$(( $(grep -E '^## [0-9]+\. ' $STUDY | tail -1 | sed -E 's/^## ([0-9]+)\..*/\1/') + 1 ))
python3 -B "$K/axiom_texts.py" "$BASE" --check > "$ASIDE/axiom-texts-check.txt" 2>&1; A=$?
cat "$ASIDE/axiom-texts-check.txt"; step axiom-sentences-check $A
python3 -B "$K/axiom_texts.py" "$BASE" "$(date +%F)" "$N" --apply > "$K/out/axiom-texts.txt" 2>&1; A=$?
cat "$K/out/axiom-texts.txt"; step axiom-sentences $A
# As the landing runs it (SWAP=1 SWAP_DATES=1, the coordinator's word of 31 October); the dry run without --dates
# shows the records that keep their date.
python3 -B "$K/swap_stamps.py" > "$ASIDE/swap-dry.txt" 2>&1; step swap-dry $?
python3 -B "$K/swap_stamps.py" --dates > "$ASIDE/swap-dry-dates.txt" 2>&1; step swap-dry-dates $?
grep -e '^dates' "$ASIDE/swap-dry-dates.txt" "$ASIDE/swap-dry.txt"
python3 -B "$K/swap_stamps.py" --apply --dates > "$K/out/swap.txt" 2>&1; step swap $?
cat "$K/out/swap.txt"
python3 -B "$K/check_repoint.py" HEAD > "$K/out/check-repoint.txt" 2>&1; R1=$?
cat "$K/out/check-repoint.txt"; step check-repoint $R1
python3 -B "$K/plan_receipts.py" HEAD --out receipts-after.json > "$K/out/plan-after.txt" 2>&1; step plan-after $?
# As in land.sh: a failed checker is a finding, so what stays stale must be exactly what failed or was not run.
python3 - "$K/out/receipts-after.json" "$K/out/status.json" "$K/out/older.json" "$@" <<'PY'; step chosen-stale-only-failed $?
import json, sys
from pathlib import Path
after = json.load(open(sys.argv[1]))
failed = {s for s, r in json.load(open(sys.argv[2])).items() if not r["passed"]}
left = {Path(p).stem for p in after["receipts"]} & set(sys.argv[4:])
older = json.load(open(sys.argv[3])).get("receipts", {})
older_left = {r for r, v in after.get("older_layout", {}).items() if v["stale"]}
older_failed = {r for r, v in older.items() if not v["passed"] and r in after.get("older_layout", {})}
print("chosen checkers still stale:", sorted(left) or "none", "; failed:", sorted(failed) or "none")
print("older layout still stale:", sorted(older_left) or "none", "; not renewed:", sorted(older_failed) or "none")
sys.exit(0 if left == failed & set(sys.argv[4:]) and older_left == older_failed else 1)
PY
python3 -B "$K/texts.py" "$ID" "$BASE" "$N" > "$ASIDE/texts.log" 2>&1; T=$?; tail -3 "$ASIDE/texts.log"; step texts $T
# The rehearsal makes no core run, so its slot cache holds no core step: master_laws.py and the connectivity check
# restore the core from the default cache instead (main's core run). In the landing the fresh core run is in the slot.
env -u BECOMING_LEAN_CACHE python3 -B tools/research/master_laws.py > "$ASIDE/master.log" 2>&1; step master-laws $?
env -u BECOMING_LEAN_CACHE python3 -B $C --check > "$ASIDE/conn1.log" 2>&1; echo "== connectivity check: exit $?"
LOGS="render2.log research-check-strict.log research-links.log research-test-tail.log"
for f in $LOGS; do touch "$K/out/$f"; done
make research-render > "$ASIDE/render1.log" 2>&1; echo "== render 1: exit $?"
python3 -B "$K/repoint_texts.py" > "$ASIDE/repoint-texts-dry.txt" 2>&1; R2=$?
tail -20 "$ASIDE/repoint-texts-dry.txt"; step repoint-texts-dry $R2
python3 -B "$K/repoint_texts.py" --apply > "$K/out/repoint-texts.txt" 2>&1; step repoint-texts $?
python3 -B "$K/check_repoint.py" HEAD > "$K/out/check-repoint-final.txt" 2>&1; R3=$?
head -5 "$K/out/check-repoint-final.txt"; step check-repoint-final $R3
python3 -B "$K/board_rv21c.py" land "$ID" "$N" "$(date +%F)" "Then, in the coordinator's order: UE26; ask the coordinator for a slot." > "$ASIDE/board.log" 2>&1; B=$?
cat "$ASIDE/board.log"; step board-land $B
make research-render > "$ASIDE/render2.log" 2>&1; step render $?
for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
cp "$ASIDE"/render2.log "$ASIDE"/research-check-strict.log "$ASIDE"/research-links.log "$K/out/"
tail -3 "$ASIDE/research-test.log" > "$K/out/research-test-tail.log"
git status --porcelain --untracked-files=all | cut -c4- | grep -v -e '-checks/[0-9TZ.]*/' -e "^$K/" > "$ASIDE/changed.txt"
cat "$ASIDE/changed.txt"
echo "REHEARSAL DONE"
