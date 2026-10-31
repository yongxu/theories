#!/bin/bash
# FA's landing, in its worktree on branch formation-accounts-renames (the fix and this kit committed there), after
# board_commit.sh head: merge main (the head clause and any commits since), rerun formal/check.py on the merged bytes,
# the gates (the receipt passed with every module's dependency audit clean and no sorryAx, it records the checkout's
# bytes, the three names pure renames by pure_rename.py, no axiom report worse than main's receipt by
# axioms_compare.py, the file's diff the three identifiers only), the board's landed clause and FA's row in the history
# file, render, strict check, links and tests, then one commit of every changed path. The fast-forward is ff.sh's.
# The branch holds one commit before this: FA's fix, its receipt, the README and the kit, and no generated view.
# REHEARSE=1 runs it in a detached throwaway worktree off the branch (rehearse.sh makes one): any head clause on the
# board copy is dropped and FA's put in its place, the merge and the commit happen there, and nothing is
# fast-forwarded.
# usage: FA_ORDER='Then, in the coordinator's order: ...' [REHEARSE=1] land.sh WORKTREE ASIDE
set -u
W=$(cd "$1" && pwd) || exit 1; ASIDE=$(cd "$2" && pwd) || exit 1
K2=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/formation-accounts-renames
F=experiments/shared-renewal-capability/regulation/retention/formation/formal
HELD=0
step() {
  echo "== $1: exit $2"
  if [ "$2" != 0 ]; then
    [ "$HELD" = 1 ] && echo "FA holds the head: release it with board_commit.sh release $ASIDE '<reason>' while this is settled"
    exit "$2"
  fi
}
[ -n "${FA_ORDER:-}" ]; step order-given $?
cd "$W" || exit 1
[ -z "$(git status --porcelain)" ]; step clean $?
mkdir -p "$K2/out"
if [ "${REHEARSE:-0}" = 1 ]; then
  echo "REHEARSAL: no head claim on main, nothing fast-forwarded"
  # Only in a detached throwaway worktree (rehearse.sh makes one), never on the branch or the shared checkout.
  [ -z "$(git branch --show-current)" ] && [ "$W" != /Users/ren/theories ]; step rehearsal-detached $?
else
  [ "$(git branch --show-current)" = formation-accounts-renames ]; step on-branch $?
  git show -s --format=%s main | grep -q '^Board: FA at the head of the queue'; step head-claim-on-main $?
  HELD=1
fi
MAIN=$(git rev-parse main); echo "$MAIN" > "$ASIDE/merged-main.txt"
# The branch carries the fix, its receipt and the kit only; generated views are rendered after the merge, so a
# landing since the branch was cut cannot conflict with them.
git diff --name-only "$(git merge-base HEAD "$MAIN")" HEAD | grep -v -e "^$F/" -e "^$K2/" && { echo "THE BRANCH CHANGES MORE THAN THE FIX AND THE KIT (above)"; step branch-paths 6; }
git merge -q --no-edit "$MAIN" > "$ASIDE/merge.log" 2>&1; M=$?
cat "$ASIDE/merge.log"
[ $M = 0 ] && [ -z "$(git diff --name-only --diff-filter=U)" ]; step merge $?
if [ "${REHEARSE:-0}" = 1 ]; then
  python3 - _process/BECOMING-WORKBOARD.md <<'PY'; step rehearsal-head $?
import sys
from pathlib import Path
p = Path(sys.argv[1]); lines = p.read_text(encoding="utf-8").split("\n")
q = [i for i, l in enumerate(lines) if l.startswith("- **Queue:** ")][0]
prefix, rest = "- **Queue:** ", lines[q][len("- **Queue:** "):]
while "(landing now" in rest[:400] and "at the head of the queue (" in rest[:400]:
    j = rest.index("(", rest.index("at the head of the queue"))
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
  grep -q '^| \*\*FA: ' _process/BECOMING-WORKBOARD.md || { python3 -B "$K2/board_fa.py" claim _process/BECOMING-WORKBOARD.md; step rehearsal-claim $?; }
  python3 -B "$K2/board_fa.py" head _process/BECOMING-WORKBOARD.md; step rehearsal-head-clause $?
fi
# The file's change is the three identifiers and nothing else.
git diff -U0 "$MAIN" -- $F/FormationAccounts.lean > "$ASIDE/fa-diff.txt"
python3 - "$ASIDE/fa-diff.txt" <<'PY'; step three-identifiers-only $?
import re, sys
lines = open(sys.argv[1]).read().splitlines()
old = [l[1:] for l in lines if l.startswith("-") and not l.startswith("---")]
new = [l[1:] for l in lines if l.startswith("+") and not l.startswith("+++")]
assert old and len(old) == len(new), (old, new)
pairs = {"AccountLaw": "SustainLaw", "credited": "arrivalEvent", "support_trace_balance": "support_trace_bound"}
mapped = [re.sub(r"\b(" + "|".join(pairs) + r")\b", lambda m: pairs[m.group(1)], l) for l in old]
assert mapped == new, (old, new)
used = {k for k in pairs if any(re.search(rf"\b{k}\b", l) for l in old)}
assert used == set(pairs), used
print(f"{len(old)} lines changed, each by the three renames only")
PY
python3 -B "$K2/pure_rename.py" HEAD > "$K2/out/pure-rename.txt" 2>&1; P=$?; cat "$K2/out/pure-rename.txt"; step pure-rename $P
python3 -B $F/check.py > "$K2/out/formal-check.txt" 2>&1; step formal-check $?
python3 - $F/verification.json <<'PY'; step receipt $?
import hashlib, json, sys
from pathlib import Path
d = json.load(open(sys.argv[1]))
assert d["status"] == "passed", d["status"]
for m in d["modules"]:
    assert m["exit_code"] == 0 and m["clean_dependency_audit"] is True, m["module"]
    assert "sorryAx" not in m["axioms"], m["module"]
    src = Path(m["source"])
    h = m.get("sha256") or m.get("source_sha256")
    if h:
        assert hashlib.sha256(src.read_bytes()).hexdigest() == h, ("receipt does not record the checkout's bytes", src)
print(d["checked_at_utc"], len(d["modules"]), "modules passed, every dependency audit clean, no sorryAx")
PY
python3 -B "$K2/axioms_compare.py" "$MAIN" > "$K2/out/axioms.txt" 2>&1; A=$?; cat "$K2/out/axioms.txt"; step axioms $A
DATE=$(date +%F)
python3 -B "$K2/board_fa.py" land "$DATE" "$FA_ORDER" > "$ASIDE/board.log" 2>&1; B=$?; cat "$ASIDE/board.log"; step board $B
# The logs copied into out/ after the checks exist before the first render, so the generated indexes count them.
LOGS="render.log research-check-strict.log research-links.log research-test-tail.log"
for f in $LOGS; do touch "$K2/out/$f"; done
make research-render > "$ASIDE/render.log" 2>&1; step render $?
for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
cp "$ASIDE"/render.log "$ASIDE"/research-check-strict.log "$ASIDE"/research-links.log "$K2/out/"
tail -3 "$ASIDE/research-test.log" > "$K2/out/research-test-tail.log"
git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths-land.txt"
cat "$ASIDE/paths-land.txt"
# Only the formal folder, the kit, the board and its history, and generated views may change.
grep -v -e "^$F/" -e "^$K2/" -e '^_process/BECOMING-WORKBOARD.md$' -e '^_process/history/workboard/' \
  -e '^_process/architecture/generated-manifest.json$' -e '^theories/becoming/results/' -e '^README.md$' \
  -e '^RESULTS.md$' -e '^RESEARCH.md$' -e '^GOALS.md$' -e '^ROADMAP.md$' -e '^OPEN-QUESTIONS.md$' -e '^DEPENDENCIES.md$' \
  -e '^_process/research/README.md$' -e '^_process/research/.*INDEX' -e '/INDEX\.md$' "$ASIDE/paths-land.txt" && { echo "UNEXPECTED PATHS (above)"; step paths 6; }
TESTS=$(grep -Eo '[0-9]+ passed' "$ASIDE/research-test.log" | tail -1)
cat > "$ASIDE/msg-land.txt" <<MSG
FA landed: experiments/shared-renewal-capability/regulation/retention/formation/formal/FormationAccounts.lean brought to the three renames of 51a975fdd, AccountLaw to SustainLaw, credited to arrivalEvent and support_trace_balance to support_trace_bound. That vocabulary rename of 6 October renamed them in conditional/ResourceContinuation.lean and its users but missed this file, so formal/check.py had failed on main since then (elaboration errors and sorryAx in root_account_balance), and RV21c's older-layout step could not renew. Each was a pure rename: pure_rename.py reads the declarations before, at and after 51a975fdd and finds the same statements (and, for the two definitions and SupportTrace, the same bodies) once the rename's own table maps the old names, binder names included; of the three, f11eb55d6 later rewrote only support_trace_bound's proof. So every statement of FormationAccounts keeps its meaning, and nothing else in it is renamed (root_account_balance and the file name stay). formal/check.py passes on the merged bytes: 68 declarations audited, every dependency audit clean, no sorryAx; axioms_compare.py finds every axiom report the same as in the 5 October receipt or smaller (none gained, none dropped; three constructive lemmas added in ResourceContinuation by f11eb55d6). Its receipt and logs are renewed in place, the README's count of the conditional module's audits is brought to the 24 the receipt records, and the kit is in development/formation-accounts-renames/. No record and no core run. The board's landed clause and FA's row in the history file. Render, strict check, links and tests (${TESTS:-see log}) pass.
MSG
git add --pathspec-from-file="$ASIDE/paths-land.txt"; step add $?
git commit -q -F "$ASIDE/msg-land.txt" --pathspec-from-file="$ASIDE/paths-land.txt"; step commit $?
git log --oneline -1 | cut -c1-120
[ "${REHEARSE:-0}" = 1 ] && { echo "REHEARSAL DONE (nothing fast-forwarded)"; exit 0; }
echo "next: move the shared checkout's kit folder aside, then ff.sh $(git rev-parse HEAD) $MAIN"
