#!/bin/bash
# RV21c, second part: the landing, in run.sh's worktree on branch rv21c, after claim_head.sh. Checks the bytes every new
# receipt binds are still main's, merges main (the head clause and any docs-only commits since the runs; a conflict
# stops it), re-reads the bindings (a record changed since the runs stops it), re-points the records binding the renewed
# runs (dry run first), brings the axiom sentences of the records whose bound module reports fewer axioms to the renewed
# receipt (axiom_texts.py, the coordinator's ruling of 31 October), swaps the stamps and the older records' passing
# dates under their guards (the coordinator's
# rulings, SWAP=1 and SWAP_DATES=1 in PLAN.md, so a landing without them stops), checks that the records changed only by
# bookkeeping and that the only receipts still stale are the failed ones, writes 08 §3's receipt and the study section,
# regenerates what the core receipt feeds, re-points the records drifting by those texts, writes the board's landed
# clause and the history row, renders and checks, then one commit of every changed path. The fast-forward is ff.sh's.
# On a stop after the head claim: release the head with release_head.sh, and, once land.sh has recorded the commit it
# began from, put the worktree back with reset_land.sh (the merge undone, the files land.sh wrote moved into ASIDE);
# settle the stop, and claim again. The order sentence
# is the one claim_head.sh checked (ASIDE/order.txt); the slot cache is ASIDE/lean-cache unless RV21C_CACHE names it;
# the coordinator's rulings on routed gates (ASIDE/acks.json, from gates.sh) go into out/ for the texts and the board.
# usage: [RV21C_CACHE=<slot cache>] land.sh WORKTREE ASIDE CORE_UTC
set -u
W=$(cd "$1" && pwd) || exit 1; ASIDE=$(cd "$2" && pwd) || exit 1; ID=$3
K=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rv21c-fresh-receipts
STUDY=_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md
C=_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY.py
HELD=0; RESET=0
step() {
  echo "== $1: exit $2"
  if [ "$2" != 0 ]; then
    [ "$HELD" = 1 ] && echo "RV21c holds the head: release it with release_head.sh $ASIDE '<reason>' while this is settled"
    [ "$RESET" = 1 ] && echo "and put the worktree back with reset_land.sh $W $ASIDE"
    [ "$HELD" = 1 ] && [ "$RESET" = 0 ] && echo "(land.sh changed nothing in the worktree yet, so there is nothing to reset)"
    exit "$2"
  fi
}
# Both swaps, as the coordinator ruled; anything else needs a new ruling and texts that report the kept stamps.
[ "${SWAP:-1}" = 1 ] && [ "${SWAP_DATES:-1}" = 1 ]; step swaps-as-ruled $?
RV21C_ORDER=$(cat "$ASIDE/order.txt" 2>/dev/null); [ -n "$RV21C_ORDER" ]; step order-from-claim $?
export RV21C_CACHE="${RV21C_CACHE:-$ASIDE/lean-cache}"
[ -d "$RV21C_CACHE" ]; step slot-cache $?
export BECOMING_LEAN_CACHE="$RV21C_CACHE"
cd "$W" || exit 1
# An earlier attempt still in the worktree is reset first (reset_land.sh reads the commit it recorded); the record is
# kept until then, and overwritten below only when the worktree is back at it and clean.
if [ -e "$ASIDE/pre-land-head.txt" ] && { [ "$(cat "$ASIDE/pre-land-head.txt")" != "$(git rev-parse HEAD)" ] || [ -n "$(git status --porcelain)" ]; }; then
  echo "AN EARLIER ATTEMPT IS STILL IN THE WORKTREE: reset_land.sh $W $ASIDE first (and release_head.sh $ASIDE '<reason>' if the head is held)"
  exit 9
fi
# The head is RV21c's when main's Queue line begins with its clause, whatever board-only commits came after it.
git show main:_process/BECOMING-WORKBOARD.md | grep -m1 '^- \*\*Queue:\*\*' | grep -q '^- \*\*Queue:\*\* RV21c at the head of the queue (landing now'; step head-claim-on-main $?
HELD=1
[ "$(git branch --show-current)" = rv21c ]; step on-branch $?
[ -z "$(git status --porcelain)" ]; step clean $?
[ "$(cat "$ASIDE/gates-passed" 2>/dev/null)" = "$(git rev-parse HEAD)" ]; step gates-passed $?
git rev-parse HEAD > "$ASIDE/pre-land-head.txt"; step record-pre-land-head $?
[ "$(cat "$ASIDE/pre-land-head.txt")" = "$(git rev-parse HEAD)" ]; step record-check $?
RESET=1
MAIN=$(git rev-parse main); echo "$MAIN" > "$ASIDE/merged-main.txt"
RUNBASE=$(sed -n 's/^main //p' "$ASIDE/base.txt"); [ -n "$RUNBASE" ]; step run-base $?
git merge-base --is-ancestor "$RUNBASE" HEAD; step run-base-in-branch $?
# Only docs-only commits may have landed since the runs: the bytes every new receipt binds are main's, and no
# toolchain or package file changed.
git diff --name-only "$RUNBASE" "$MAIN" -- '*lean-toolchain' '*lakefile*' '*lake-manifest.json' | grep . && { echo "TOOLCHAIN OR PACKAGE FILES CHANGED"; step toolchain 8; }
python3 -B "$K/verify_runs.py" "$ID" "$MAIN" --no-write > "$ASIDE/verify-main.txt" 2>&1; step bound-bytes-on-main $?
git merge -q --no-edit "$MAIN" > "$ASIDE/merge.log" 2>&1; M=$?
cat "$ASIDE/merge.log"
[ $M = 0 ] && [ -z "$(git diff --name-only --diff-filter=U)" ]; step merge $?
python3 -B "$K/verify_runs.py" "$ID" HEAD > "$ASIDE/verify-merged.txt" 2>&1; step verify-merged $?
cp "$ASIDE/acks.json" "$K/out/acks.json"; step acks $?
# The records binding the checkers, read again after the merge: a docs-only landing since the runs must not have
# changed them, or the re-points below would miss it.
python3 -B "$K/bindings.py" --out bindings-merged.json > "$ASIDE/bindings-merged.txt" 2>&1; step bindings-merged $?
python3 - "$K/out/bindings-before.json" "$K/out/bindings-merged.json" <<'PY'; step bindings-unchanged $?
import json, sys
def bound(path):
    return {(s, rid, b["source"], b["receipt"]) for s, rows in json.load(open(path)).items()
            for rid, bs in rows.items() for b in bs if b["kind"] == "binding"}
before, after = bound(sys.argv[1]), bound(sys.argv[2])
print("bindings gained since the runs:", sorted(after - before) or "none")
print("bindings lost since the runs:", sorted(before - after) or "none")
sys.exit(0 if before == after else 1)
PY
N=$(( $(grep -E '^## [0-9]+\. ' $STUDY | tail -1 | sed -E 's/^## ([0-9]+)\..*/\1/') + 1 ))
echo "study section $N"
python3 -B "$K/repoint_all.py" > "$ASIDE/repoint-dry.txt" 2>&1; step repoint-dry $?
python3 -B "$K/repoint_all.py" --apply > "$K/out/repoint.txt" 2>&1; step repoint $?
python3 -B "$K/axiom_texts.py" "$RUNBASE" "$(date +%F)" "$N" > "$ASIDE/axiom-texts-dry.txt" 2>&1; A=$?
cat "$ASIDE/axiom-texts-dry.txt"; step axiom-sentences-dry $A
python3 -B "$K/axiom_texts.py" "$RUNBASE" "$(date +%F)" "$N" --apply > "$K/out/axiom-texts.txt" 2>&1; step axiom-sentences $?
python3 -B "$K/swap_stamps.py" --dates > "$ASIDE/swap-dry.txt" 2>&1; step swap-dry $?
python3 -B "$K/swap_stamps.py" --apply --dates > "$K/out/swap.txt" 2>&1; step swap $?
python3 -B "$K/check_repoint.py" HEAD > "$K/out/check-repoint.txt" 2>&1; R1=$?
cat "$K/out/check-repoint.txt"; step check-repoint $R1
# After the re-points, the receipts still to rerun are exactly the failed checkers.
python3 -B "$K/plan_receipts.py" HEAD --out receipts-after.json > "$K/out/plan-after.txt" 2>&1; step plan-after $?
python3 - "$K/out/receipts-after.json" "$K/out/status.json" "$K/out/older.json" <<'PY'; step stale-only-failed $?
import json, sys
from pathlib import Path
after = json.load(open(sys.argv[1]))
left = {Path(p).stem for p in after["receipts"]}
failed = {s for s, r in json.load(open(sys.argv[2])).items() if not r["passed"]}
older = json.load(open(sys.argv[3])).get("receipts", {})
older_left = {r for r, v in after.get("older_layout", {}).items() if v["stale"]}
older_failed = {r for r, v in older.items() if not v["passed"] and r in after.get("older_layout", {})}
print("still stale after the re-points:", sorted(left) or "none", "; failed:", sorted(failed) or "none")
print("older layout still stale:", sorted(older_left) or "none", "; not renewed:", sorted(older_failed) or "none")
sys.exit(0 if left == failed and older_left == older_failed else 1)
PY
python3 -B "$K/texts.py" "$ID" "$RUNBASE" "$N" > "$ASIDE/texts.log" 2>&1; T=$?
tail -3 "$ASIDE/texts.log"; step texts $T
python3 -B tools/research/shared_laws.py > "$ASIDE/master.log" 2>&1; step master-laws $?
python3 -B $C --check > "$ASIDE/conn1.log" 2>&1; CC=$?
echo "== connectivity check: exit $CC"
if [ $CC != 0 ]; then
  python3 -B $C --write > "$ASIDE/conn2.log" 2>&1; step connectivity-write $?
  python3 -B $C --check > "$ASIDE/conn3.log" 2>&1; step connectivity-check $?
fi
# The logs copied into out/ after the checks exist before the first render, so the generated indexes count them.
LOGS="render2.log research-check-strict.log research-links.log research-test-tail.log"
for f in $LOGS; do touch "$K/out/$f"; done
make research-render > "$ASIDE/render1.log" 2>&1; echo "== render before re-pointing texts: exit $?"
python3 -B "$K/repoint_texts.py" > "$ASIDE/repoint-texts-dry.txt" 2>&1; R2=$?
tail -20 "$ASIDE/repoint-texts-dry.txt"; step repoint-texts-dry $R2
python3 -B "$K/repoint_texts.py" --apply > "$K/out/repoint-texts.txt" 2>&1; step repoint-texts $?
python3 -B "$K/check_repoint.py" HEAD > "$K/out/check-repoint-final.txt" 2>&1; R3=$?
head -5 "$K/out/check-repoint-final.txt"; step check-repoint-final $R3
python3 -B "$K/board_rv21c.py" land "$ID" "$N" "$(date +%F)" "$RV21C_ORDER" > "$ASIDE/board.log" 2>&1; B=$?
cat "$ASIDE/board.log"; step board $B
make research-render > "$ASIDE/render2.log" 2>&1; step render $?
for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
cp "$ASIDE"/render2.log "$ASIDE"/research-check-strict.log "$ASIDE"/research-links.log "$K/out/"
tail -3 "$ASIDE/research-test.log" > "$K/out/research-test-tail.log"
git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths-land.txt"
# A chapter other than 08 may change only where axiom_texts.py brought a home section to a renewed receipt.
python3 - "$K/out/axiom_texts.json" "$ASIDE/paths-land.txt" <<'PY'; step chapters-as-recorded $?
import json, sys
from pathlib import Path
p = Path(sys.argv[1])
allowed = {c["file"] for v in (json.loads(p.read_text()) if p.exists() else {}).values() for c in v["chapter"]}
allowed.add("theories/becoming/chapters/08-METHOD.md")
changed = {x for x in open(sys.argv[2]).read().split() if x.startswith("theories/becoming/chapters/")}
print("chapters changed:", sorted(changed) or "none", "; allowed:", sorted(allowed))
sys.exit(0 if changed <= allowed else 1)
PY
# Only what RV21c writes may land: the records, 08, the study, the rebinds log, the board and its history file, the
# master laws and the connectivity data, the kit's outputs and the generated pages by role.
grep -v -e '^theories/becoming/results/' -e '^theories/becoming/chapters/0[1-8]-[A-Z-]*\.md$' -e "^$STUDY$" \
  -e '^_process/architecture/' -e '^_process/BECOMING-WORKBOARD.md$' -e '^_process/history/workboard/' \
  -e '^_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY' \
  -e "^$K/out/" -e '^README.md$' -e '^RESULTS.md$' -e '^RESEARCH.md$' -e '^GOALS.md$' -e '^ROADMAP.md$' \
  -e '^OPEN-QUESTIONS.md$' -e '^DEPENDENCIES.md$' -e '^_process/research/README.md$' -e '/INDEX\.md$' \
  -e '^_process/research/.*INDEX' "$ASIDE/paths-land.txt" && { echo "UNEXPECTED PATHS (above)"; step paths 6; }
python3 - "$K" "$ID" "$N" > "$ASIDE/msg-land.txt" <<'PY'; step message $?
import json, sys
sys.path.insert(0, sys.argv[1])
from kit import OUT, RECEIPTS, stem
status = json.loads((OUT / "status.json").read_text())
verify = json.loads((OUT / "verify.json").read_text())
texts = json.loads((OUT / "texts.json").read_text())
older = json.loads((OUT / "older.json").read_text()) if (OUT / "older.json").exists() else {}
swap = json.loads((OUT / "swap.json").read_text()) if (OUT / "swap.json").exists() else None
acks = json.loads((OUT / "acks.json").read_text()) if (OUT / "acks.json").exists() else {}
axioms = json.loads((OUT / "axiom_texts.json").read_text()) if (OUT / "axiom_texts.json").exists() else {}
passed = [stem(p) for p in RECEIPTS if status[stem(p)]["passed"]]
renewed = sum(1 for v in older.get("receipts", {}).values() if v["passed"])
fresh = all(verify[s]["reused"] == 0 for s in passed)
how = ("with every Lean step run" if fresh else
       "on this slot's step cache, each reusing only steps earlier runs of this slot ran and kept")
chapter = ("08 §3's receipt sentence, every count the same" if not texts["stale_08"] else
           "08 §3's receipt sentence and counts, the same as the core receipt the runs began from")
swaps = ""
if swap:
    ids = lambda d: ", ".join(f"{rid} ({why.split(':')[0]})" for rid, why in sorted(d.items()))
    parts = ([f"the run's stamp swapped for the renewed run's in {len(swap['swapped'])}, the module unchanged "
              "between the two runs"
              + (", or only its axiom reports changed and the record's axiom sentences were brought to the renewed "
                 "receipt" if set(swap["swapped"]) & set(axioms) else "")] if swap["swapped"] else [])
    parts += [f"left as it was in {len(swap['left'])}: {ids(swap['left'])}"] if swap["left"] else []
    parts += ([f"the earlier passing date swapped for the renewed older-layout receipt's in {len(swap['dated'])}, on "
               "the coordinator's word, where the audit total is unchanged and "
               + ("either the bound module keeps every axiom report or the record's axiom sentences were brought to "
                  "the renewed receipt" if set(swap["dated"]) & set(axioms) else
                  "the bound module keeps every axiom report")] if swap.get("dated") else [])
    parts += ([f"the earlier passing date kept in {len(swap['left_dated'])}, the guard failing: "
               f"{ids(swap['left_dated'])}"] if swap.get("left_dated") else [])
    parts += ([f"the earlier passing date kept in {len(swap['dates_kept'])}, the date swap not run"]
              if swap.get("dates_kept") else [])
    logged = "out/swap.json, rebinds.jsonl" if swap["swapped"] or swap.get("dated") else "out/swap.json"
    swaps = (f"In validation_scope ({logged}): " + "; ".join(parts) + ". ") if parts else ""
changed = swap and (swap["swapped"] or swap.get("dated"))
homes = len({(c["file"], rid) for rid, v in axioms.items() for c in v["chapter"]})
sentences = ("" if not axioms else
             f"For that reason the axiom sentences of {len(axioms)} record{'s' * (len(axioms) != 1)}"
             + (f" and {homes} home section{'s' * (homes != 1)}" if homes else "")
             + " were brought to the renewed receipts' reports, mechanically from their data (axiom_texts.py, "
             "AXIOM-SPECS.json, out/axiom_texts.json), each record with one history note: "
             + ", ".join(sorted(axioms)) + ". "
             + (f"The records citing the changed part of those home sections were re-pointed by hash: "
                f"{', '.join(texts.get('home_drift', []))}. " if texts.get("home_drift") else ""))
rulings = "".join(f"The coordinator ruled on {'a changed axiom report' if k == 'axioms' else 'the older-layout step'}: "
                  f"{v}. " for k, v in sorted(acks.items()))
print(f"RV21c landed: fresh receipts, the twenty-first review's §6 item 9 as the coordinator widened it (study "
      f"§{sys.argv[3]}). Core receipt {sys.argv[2]} ran every one of its Lean steps with BECOMING_FRESH=1 on an empty "
      f"step cache and keeps every log, so a verifier needs no cache. The {len(RECEIPTS)} periphery receipts binding "
      f"core bytes changed since were rerun one at a time {how}: {len(passed)} renewed, "
      f"{len(RECEIPTS) - len(passed)} kept as findings (out/status.json). "
      + (f"The older-layout step renewed {renewed} of {len(older['receipts'])} receipts in place by their own checkers "
         "(out/older.json), as the coordinator set it. " if older.get("receipts") else "")
      + rulings + "The records binding a renewed run are "
      "re-pointed to it with tools/research/repoint.py (rebinds.jsonl), and check_repoint.py confirms nothing else in "
      f"them changed{' but the axiom sentences and swaps named next' if axioms else ' but the swaps named next' if changed else ''}. "
      f"{sentences}{swaps}Then {chapter}; the study section; shared-laws.json and the generated views rerun; the records "
      "drifting by those texts re-pointed, repoint_texts.py having checked section by section that only 08 §3, "
      f"the new study section{' and those home sections' if homes else ''} changed; the board's landed clause and RV21c's row in the history "
      "file. No Lean and no statement changed. Render, strict check, links and tests pass.")
PY
git add --pathspec-from-file="$ASIDE/paths-land.txt"; step add $?
git commit -q -F "$ASIDE/msg-land.txt" --pathspec-from-file="$ASIDE/paths-land.txt"; step commit $?
git log --oneline -1 | cut -c1-120
echo "next: move the shared checkout's kit folder aside, then ff.sh $(git rev-parse HEAD) $MAIN (if main moves by"
echo "board-only commits first: remerge.sh $W $ASIDE, then ff.sh with what it prints)"
