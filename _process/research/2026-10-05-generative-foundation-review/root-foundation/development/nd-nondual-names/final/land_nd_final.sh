#!/bin/bash
# ND's final stage (land_bd4.sh's pattern), in ND's worktree on branch nd-final, which holds only this kit:
# main merged in, the record id renamed, the names script, the connectivity and the view regenerated and compared
# with the old ones under the name map, the citing records re-pointed (names only), the study section, the board's
# landed clause and ND's row in the history file, the checks, and one commit of every changed path.
# The fast-forward is the landing's own last step, after the Queue line is re-read.
# usage: land_nd_final.sh WORKTREE ASIDE rehearse            (no board edits, no commit; ASIDE outside the repo)
#        ND_ORDER="…" land_nd_final.sh WORKTREE ASIDE land     (ND holds the head; ND_ORDER the coordinator's
#                                                             order sentence, sent with its word, verbatim)
set -u
W=$1; ASIDE=$2; MODE=$3
K=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/nd-nondual-names/final
RF=_process/research/2026-10-05-generative-foundation-review/root-foundation
STUDY=$RF/BECOMING-RENEWAL-READING.md
C=$RF/THEOREM-CONNECTIVITY.py
B=_process/BECOMING-WORKBOARD.md
cd "$W" || exit 1
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
[ "$(git branch --show-current)" = nd-final ]; step branch $?
[ "$MODE" = rehearse ] || [ "$MODE" = land ]; step mode $?
[ -z "$(git status --porcelain --untracked-files=no)" ]; step clean $?
if [ "$MODE" = land ]; then
  [ -n "${ND_ORDER:-}" ]; step coordinator-order $?
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q "^- \*\*Queue:\*\* ND's final stage at the head of the queue (landing now"; step head-claim $?
fi
mkdir -p "$ASIDE"
git rev-parse main > "$ASIDE/main-at-merge.txt"
git merge --no-edit -q main > "$ASIDE/merge.log" 2>&1; step merge $?
git show HEAD:$RF/THEOREM-CONNECTIVITY.json > "$ASIDE/conn-old.json"
git show HEAD:theories/becoming/results/data/master-laws.json > "$ASIDE/ml-old.json"
N=$(( $(grep -E '^## [0-9]+\. ' $STUDY | tail -1 | sed -E 's/^## ([0-9]+)\..*/\1/') + 1 ))
DAY=$(date '+%-d %B %Y'); DAY_ZH=$(date '+%Y年%-m月%-d日')
echo "study section $N, $DAY"
python3 -B tools/research/research.py rename-id --plan $K/rename-plan.tsv --apply --batch nd-shared-laws-id > "$ASIDE/rename-id.log" 2>&1; step rename-id $?
python3 -B $K/nd_final.py . --day "$DAY" --day-zh "$DAY_ZH" --n $N > "$ASIDE/names.log" 2>&1; step names $?
python3 -B $C --write > "$ASIDE/conn-write.log" 2>&1; step connectivity-write $?
python3 -B $C --check > "$ASIDE/conn-check.log" 2>&1; step connectivity-check $?
python3 -B tools/research/shared_laws.py > "$ASIDE/shared.log" 2>&1; step shared-laws $?
python3 -B $K/nd_final_verify.py "$ASIDE/conn-old.json" $RF/THEOREM-CONNECTIVITY.json "$ASIDE/ml-old.json" theories/becoming/results/data/shared-laws.json > "$ASIDE/verify.log" 2>&1
echo "== verify: exit $? (read it: only commit, core_receipt_at_commit and the edited checker's digest may differ)"
python3 -B $K/study_nd_final.py $N > "$ASIDE/study.log" 2>&1; step study $?
make research-render > "$ASIDE/render1.log" 2>&1; echo "== render before re-pointing: exit $?"
python3 -B $K/repoint_nd_final.py > "$ASIDE/repoint-dry.log" 2>&1; step repoint-dry $?
python3 -B $K/repoint_nd_final.py --apply > "$ASIDE/repoint.log" 2>&1; step repoint $?
[ "$MODE" = land ] && { python3 -B $K/board_nd_final.py landed $N > "$ASIDE/board.log" 2>&1; step board $?; }
make research-render > "$ASIDE/render2.log" 2>&1; step render $?
python3 -B tools/research/research.py check --strict-fresh > "$ASIDE/strict.log" 2>&1; step strict $?
make research-links > "$ASIDE/links.log" 2>&1; step links $?
python3 -B $RF/development/review-packet/check_dossiers.py > "$ASIDE/dossiers.log" 2>&1; step dossiers $?
python3 -B $RF/development/review-packet/check_dossiers.py $RF/development/ue8-sciences-dossier/SCIENCES.md > "$ASIDE/sciences.log" 2>&1; step sciences $?
make research-test > "$ASIDE/test.log" 2>&1; step tests $?
# every changed path, both sides of a rename (git mv stages them)
git status --porcelain --untracked-files=all | cut -c4- | awk '{n = split($0, a, " -> "); for (i = 1; i <= n; i++) print a[i]}' > "$ASIDE/paths.txt"
# git add takes the paths still in the tree; a rename's old side is staged by git mv and goes to the commit
while read -r p; do [ -e "$p" ] && echo "$p"; done < "$ASIDE/paths.txt" > "$ASIDE/add.txt"
[ "$MODE" = rehearse ] && { echo "rehearsal: $(wc -l < "$ASIDE/paths.txt") paths changed, nothing committed"; exit 0; }
git add -A --pathspec-from-file="$ASIDE/add.txt"; step add $?
git commit -q --pathspec-from-file="$ASIDE/paths.txt" -F - <<MSG
ND's final stage landed: names that state relations, not rule (study §$N; documents and tools only: no Lean, no new record and no core run). Paths, old → new: tools/research/master_laws.py → tools/research/shared_laws.py; tools/research/tests/test_master_laws.py → tools/research/tests/test_shared_laws.py; theories/becoming/results/data/master-laws.json → theories/becoming/results/data/shared-laws.json; the record id master-laws-on-the-grammar → shared-laws-on-the-grammar (theories/becoming/results/records/master-laws-on-the-grammar.json → shared-laws-on-the-grammar.json, the old .md a redirect). Every kit script on main that runs or reads them by path (land and rehearse scripts, integrate and board scripts, U4's make_record_u4.py and boundary_table.py) now names the new paths, in paths only; no shim is left under the old names. The record id master-laws-on-the-grammar is shared-laws-on-the-grammar, following the title ND part 1 gave it, by research.py rename-id: the old id kept in former_ids, its page a generated redirect, links and mentions in the live texts and the records' dependencies rewritten. The view's generator, data and test are tools/research/shared_laws.py, data/shared-laws.json and tests/test_shared_laws.py; in the research tools, the two measure scripts and the connectivity script every key, identifier and category value naming a master law names a shared law ('master law' → 'shared law', 'no master law' → 'no shared law', master_laws → shared_laws). The connectivity and the view regenerated from the checker's cache equal the old ones but for the names, the inputs' digests and the provenance of the run. 08 §10's sentence on where the old name stays (where it is matched, not read: the former id, anchors kept beside the new ones, the studies' paths), the glossary's note, the workflow's section on the view, the Lean README's two rows, two notes in regions.json, the coverage file's key, and the connectivity register's reasons, Concave.roots's naming rises_superadditive (stage 20-nd's name); one-root-to-its-edge names the generator, with history notes there and on the renamed record. AJ4's failure-mode map links the view's data by its new name; its prose on master laws is passed to its owner. The checker's scope text is proposed for the next core landing (proposed-checker-scope.patch): it is written into each core receipt, so edited without a core run it would stand apart from the latest receipt's. The records citing the changed texts re-pointed, nothing they say changed. The board's landed clause with the coordinator's order and ND's row in the history file. Render, strict check, links, tests and both dossier checks pass.
MSG
step commit $?
git log --oneline -1 | cut -c1-120
