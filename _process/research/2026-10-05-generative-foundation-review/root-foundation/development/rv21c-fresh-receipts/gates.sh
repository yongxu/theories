#!/bin/bash
# RV21c's gates, after run.sh has kept the runs on branch rv21c and before anything is held on main. run.sh calls it
# last; it can be rerun alone once the coordinator has ruled on a routed gate. Each gate that routes to the
# coordinator stops here: an axiom report changed between a checker's two runs (condition 5), and an older-layout
# checker that failed or was not run (condition 8). A ruling is given as ACK_AXIOMS or ACK_OLDER, in the
# coordinator's words (parentheses balanced, no '); ', no ' | ', one line), and lets that gate pass; only the
# rulings for gates that tripped are kept, in ASIDE/acks.json (one given for a gate that passed is printed and
# dropped, so no text reports a route that did not happen), which land.sh copies into out/ so the landed clause and
# the study name them. A changed report the ruling covers must still leave every record's axiom sentences true:
# axiom_texts.py --check stops on a record that states reports which changed and has no template, or on a report that
# gained an axiom (the coordinator's ruling of 31 October covers fewer only); and the engine's tests pass
# (axiom_tests.py, on the records and chapters at the run base). The other gates: a
# stale receipt left after the runs is a failed one, and 08 §3 names the core receipt the runs began from (texts.py
# --check). When every gate passes, ASIDE/gates-passed holds the run commit, which claim_head.sh requires.
# usage: [ACK_AXIOMS='...'] [ACK_OLDER='...'] gates.sh WORKTREE ASIDE
set -u
W=$(cd "$1" && pwd) || exit 1; ASIDE=$(cd "$2" && pwd) || exit 1
K=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rv21c-fresh-receipts
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
cd "$W" || exit 1
rm -f "$ASIDE/gates-passed" "$ASIDE/acks.json" "$ASIDE/tripped.txt"
ID=$(cat "$ASIDE/core-utc.txt") || exit 1
BASE=$(sed -n 's/^main //p' "$ASIDE/base.txt"); [ -n "$BASE" ]; step run-base $?
[ "$(git branch --show-current)" = rv21c ] && [ -z "$(git status --porcelain)" ]; step committed-runs $?
python3 - "$ASIDE/acks-given.json" <<'PY'; step acks $?
import json, os, sys
acks = {k: os.environ[v].strip() for k, v in (("axioms", "ACK_AXIOMS"), ("older", "ACK_OLDER")) if os.environ.get(v)}
for k, t in acks.items():
    assert not any(x in t for x in ("); ", " | ", "\n")), (k, "a ruling has no '); ', no ' | ' and one line")
    depth = 0
    for ch in t:
        depth += {"(": 1, ")": -1}.get(ch, 0)
        assert depth >= 0, (k, "a ruling's parentheses are balanced")
    assert depth == 0, (k, "a ruling's parentheses are balanced")
json.dump(acks, open(sys.argv[1], "w"), ensure_ascii=False, indent=1)
print("rulings given:", acks or "none")
PY
touch "$ASIDE/tripped.txt"
python3 - "$K/out/compare.json" "$K/out/status.json" "$K/out/older.json" "$ASIDE/acks-given.json" "$ASIDE/tripped.txt" <<'PY'; step axioms-unchanged $?
import json, sys
compare, status, older, acks = (json.load(open(a)) for a in sys.argv[1:5])
axioms = {s: {m: v["axioms_changed"] for m, v in row["modules"].items() if v["axioms_changed"]}
          for s, row in compare.items() if status.get(s, {}).get("passed")}
axioms = {s: v for s, v in axioms.items() if v}
other = {s: {m: {k: v[k] for k in ("removed", "added") if v[k]} for m, v in row["modules"].items()
             if v["removed"] or v["added"]} for s, row in compare.items()}
sig = {s: sorted(row["signatures_changed"]) for s, row in compare.items() if row.get("signatures_changed")}
uncompared = {s: row.get("signatures") for s, row in compare.items() if "signatures_compared" not in row}
print("declarations added or removed (left and listed by the swap):", {s: v for s, v in other.items() if v} or "none")
print("signatures changed (left and listed by the swap):", sig or "none")
print("signatures not compared (left and listed by the swap):", uncompared or "none")
for r, v in older.get("receipts", {}).items():
    if not v.get("passed"):
        continue
    bound = {m for ms in v["bound_modules"].values() for m in ms}
    hit = {m: c for m, c in v["axioms_changed"].items() if m in bound}
    if hit:
        axioms["older:" + r] = hit
    rest = sorted(m for m in v["axioms_changed"] if m not in bound)
    print(f"older {r}: axiom reports changed in modules no record binds (listed): {rest or 'none'}; "
          f"audits {v['audits'][0]} -> {v['audits'][1]}")
print("axiom reports changed:", json.dumps(axioms, ensure_ascii=False)[:3000] if axioms else "none")
if axioms and not acks.get("axioms"):
    print("AXIOM REPORT CHANGED between a checker's two runs: route to the coordinator before claiming the head")
    sys.exit(1)
if axioms:
    print("the coordinator ruled:", acks["axioms"])
    open(sys.argv[5], "a").write("axioms\n")
PY
python3 -B "$K/axiom_texts.py" "$BASE" --check > "$ASIDE/axiom-texts-check.txt" 2>&1; A=$?
cat "$ASIDE/axiom-texts-check.txt"; step axiom-sentences $A
python3 -B "$K/axiom_tests.py" "$BASE" > "$ASIDE/axiom-tests.txt" 2>&1; A=$?
grep -v '^PASS' "$ASIDE/axiom-tests.txt"; step axiom-engine-tests $A
python3 - "$K/out/older.json" "$ASIDE/acks-given.json" "$ASIDE/tripped.txt" <<'PY'; step older-renewed $?
import json, sys
older, acks = json.load(open(sys.argv[1])), json.load(open(sys.argv[2]))
if older.get("error"):
    print("OLDER-LAYOUT STEP ERROR:", older["error"])
    sys.exit(1)
bad = {r: v.get("not_run") or "failed" for r, v in older.get("receipts", {}).items() if not v["passed"]}
print("older-layout receipts not renewed:", bad or "none")
if bad and not acks.get("older"):
    print("OLDER-LAYOUT FAILURE: route to the coordinator before claiming the head")
    sys.exit(1)
if bad:
    print("the coordinator ruled:", acks["older"])
    open(sys.argv[3], "a").write("older\n")
PY
python3 - "$K/out/stale-after.txt" "$K/out/status.json" <<'PY'; step stale-after-only-failed $?
import json, sys
line = [l for l in open(sys.argv[1]) if l.startswith("STALE ")][-1]
stale = set(line.split(":", 1)[1].split())
failed = {s for s, r in json.load(open(sys.argv[2])).items() if not r["passed"]}
print("still stale:", sorted(stale) or "none", "; failed:", sorted(failed) or "none")
sys.exit(0 if stale <= failed else 1)
PY
python3 -B "$K/texts.py" --check "$ID" "$BASE" > "$ASIDE/texts-check.txt" 2>&1; T=$?
tail -3 "$ASIDE/texts-check.txt"; step texts-check $T
python3 - "$ASIDE/acks-given.json" "$ASIDE/tripped.txt" "$ASIDE/acks.json" <<'PY'; step acks-kept $?
import json, sys
given, tripped = json.load(open(sys.argv[1])), set(open(sys.argv[2]).read().split())
kept = {k: v for k, v in given.items() if k in tripped}
for k in sorted(set(given) - tripped):
    print(f"ruling for the {k} gate dropped: that gate passed without it")
json.dump(kept, open(sys.argv[3], "w"), ensure_ascii=False, indent=1)
print("rulings kept:", kept or "none")
PY
git rev-parse HEAD > "$ASIDE/gates-passed"
echo "gates passed on $(cut -c1-9 "$ASIDE/gates-passed")"
