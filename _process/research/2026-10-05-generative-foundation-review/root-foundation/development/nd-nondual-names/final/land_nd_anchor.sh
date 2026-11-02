#!/bin/bash
# ND2's landing (land_nd_final.sh's pattern), in ND's worktree on branch nd-anchor, once ND2 holds the head
# (head_nd_anchor.sh): main merged in (generated pages taken from main, then re-rendered), the board's landed clause and
# ND2's row in the history file, the checks on the landing tree, and one commit. The fast-forward is ff_nd_anchor.sh's.
# usage: ND_ORDER="…" land_nd_anchor.sh WORKTREE ASIDE   (ND_ORDER the coordinator's order sentence, verbatim)
set -u
W=$1; ASIDE=$2
K=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/nd-nondual-names/final
RF=_process/research/2026-10-05-generative-foundation-review/root-foundation
B=_process/BECOMING-WORKBOARD.md
GEN="theories/becoming/results/THEORY-GRAPH.md theories/becoming/results/data/theory-graph.json _process/architecture/generated-manifest.json $RF/INDEX.md _process/research/README.md RESULTS.md"
cd "$W" || exit 1
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
[ "$(git branch --show-current)" = nd-anchor ]; step branch $?
[ -z "$(git status --porcelain --untracked-files=no)" ]; step clean $?
[ -n "${ND_ORDER:-}" ]; step coordinator-order $?
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '^- \*\*Queue:\*\* ND2 at the head of the queue (landing now'; step head-claim $?
mkdir -p "$ASIDE"
git rev-parse main > "$ASIDE/main-at-merge.txt"
git merge --no-edit -q main > "$ASIDE/merge.log" 2>&1
U=$(git diff --name-only --diff-filter=U)
for f in $U; do echo " $GEN " | grep -q " $f " || { echo "CONFLICT OUTSIDE GENERATED PAGES: $f"; exit 6; }; git checkout --theirs -- "$f" && git add "$f"; done
[ -z "$(git diff --name-only --diff-filter=U)" ]; step merge $?
git rev-parse -q --verify MERGE_HEAD >/dev/null && { git commit -q --no-edit; step merge-commit $?; }
grep -q 'id="r-shared-laws-on-the-grammar"' theories/becoming/chapters/01-ROOT.md && grep -q 'id="r-master-laws-on-the-grammar"' theories/becoming/chapters/01-ROOT.md; step both-anchors $?
python3 -B $K/board_nd_anchor.py landed 495 > "$ASIDE/board.log" 2>&1; step board $?
make research-render > "$ASIDE/render.log" 2>&1; step render $?
! git grep -q -E '^(<<<<<<<|>>>>>>>) ' -- theories _process tools; step markers $?
python3 -B tools/research/research.py check --strict-fresh > "$ASIDE/strict.log" 2>&1; step strict $?
make research-links > "$ASIDE/links.log" 2>&1; step links $?
python3 -B $RF/development/review-packet/check_dossiers.py > "$ASIDE/dossiers.log" 2>&1; step dossiers $?
python3 -B $RF/development/review-packet/check_dossiers.py $RF/development/ue8-sciences-dossier/SCIENCES.md > "$ASIDE/sciences.log" 2>&1; step sciences $?
make research-test > "$ASIDE/test.log" 2>&1; step tests $?
git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths.txt"
git add -A --pathspec-from-file="$ASIDE/paths.txt"; step add $?
git commit -q --pathspec-from-file="$ASIDE/paths.txt" -F - <<MSG
ND2 landed: the home anchor of shared-laws-on-the-grammar (documents only: no Lean, no record and no core run). research.py rename-id leaves anchors alone, so after ND's final stage 01 §7, the record's home section, kept only r-master-laws-on-the-grammar, where every other renamed record's home anchor is at its id. 01 §7 now carries <a id="r-shared-laws-on-the-grammar"></a> beside the old anchor, which stays for its citers in history and on branches; 01's three links, 08 §7's one and AJ4's failure-mode map's closure-law link (left to this landing on the coordinator's word) read the new anchor; a line in study §495; the theory graph re-rendered. No record drifts, since section hashes leave anchors and link targets out. The board's landed clause with the coordinator's order and ND2's row in the history file. Render, strict check, links, the 305 tests and both dossier checks pass.
MSG
step commit $?
git log --oneline -1 | cut -c1-100
