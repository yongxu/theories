#!/bin/bash
# SJ's last landing (land_sj.sh's pattern), in SJ's worktree on its branch, once it holds the head (head_sj2.sh): main
# merged in, the checker writing its run into the repository, the receipt and study section filled in, the
# connectivity and shared laws, the citing records re-pointed, the board's landed clause, and one commit of every
# changed path. The fast-forward is ff_sj2.sh's.
# usage: SJ_ORDER="…" land_sj.sh WORKTREE ASIDE   (ASIDE a folder outside the repository, for logs; SJ_ORDER the
#        coordinator's order sentence for the landed clause, sent with its word, verbatim; required)
set -u
W=$1; ASIDE=$2
K=$(cd "$(dirname "$0")" && pwd)
PKG=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
STUDY=_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md
C=_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY.py
B=_process/BECOMING-WORKBOARD.md
cd "$W" || exit 1
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
# the load rule, before the Lean run and before every check on the landing tree
gate() { until l=$(sysctl -n vm.loadavg | awk '{print $3}'); m=$(memory_pressure | awk -F': ' '/free percentage/ {sub("%","",$2); print $2}'); f=$(df -g "$W" | awk 'NR==2 {print $4}'); awk -v l="$l" -v m="$m" -v f="$f" 'BEGIN {exit !(l < 24 && m >= 40 && f >= 5)}'; do echo "$(date +%H:%M:%S) $1 waiting: load5=$l mem=$m% free=${f}GiB" >> "$ASIDE/wait.log"; sleep 60; done; echo "$(date +%H:%M:%S) $1: load5=$l mem=$m% free=${f}GiB" >> "$ASIDE/wait.log"; }
[ "$(git branch --show-current)" = sj-claim ]; step branch $?
[ -n "${SJ_ORDER:-}" ] && ! printf %s "$SJ_ORDER" | grep -qwE "SJ1?"; step coordinator-order $?
[ -z "$(git status --porcelain --untracked-files=no)" ]; step clean $?
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -qF -- "- **Queue:** SJ's last parts at the head of the queue (landing now"; step head-claim $?
mkdir -p "$ASIDE"
git rev-parse main > "$ASIDE/main-at-merge.txt"
git merge --no-edit -q main > "$ASIDE/merge.log" 2>&1; step merge $?
BEFORE=$(ls $PKG/becoming-checks | grep -v '^_' | tail -1)
gate checker
(cd $PKG && LEAN_TIMEOUT=2400 python3 -B check_becoming.py > "$ASIDE/check.log" 2>&1); step checker $?
ID=$(ls $PKG/becoming-checks | grep -v '^_' | tail -1)
[ "$ID" != "$BEFORE" ]; step new-receipt $?
N=$(( $(grep -E '^## [0-9]+\. ' $STUDY | tail -1 | sed -E 's/^## ([0-9]+)\..*/\1/') + 1 ))
echo "receipt $ID, study section $N"
python3 -B "$K/reland_sj2.py" "$ID" "$N" > "$ASIDE/reland.log" 2>&1; step reland $?
python3 -B $C --check > "$ASIDE/conn1.log" 2>&1; echo "== connectivity before registering: exit $?"
python3 -B "$K/register_sj2.py" "$ASIDE/conn1.log" > "$ASIDE/register.log" 2>&1; step register $?
python3 -B $C --write > "$ASIDE/conn2.log" 2>&1; step connectivity-write $?
python3 -B $C --check > "$ASIDE/conn3.log" 2>&1; step connectivity-check $?
python3 -B tools/research/shared_laws.py > "$ASIDE/master.log" 2>&1; step master-laws $?
make research-render > "$ASIDE/render1.log" 2>&1; echo "== render before re-pointing: exit $?"
python3 -B "$K/repoint_sj2.py" "$ID" > "$ASIDE/repoint-dry.log" 2>&1; step repoint-dry $?
python3 -B "$K/repoint_sj2.py" "$ID" --apply > "$ASIDE/repoint.log" 2>&1; step repoint $?
python3 -B "$K/board_sj2.py" landed "$ID" "$N" > "$ASIDE/board.log" 2>&1; step board $?
make research-render > "$ASIDE/render2.log" 2>&1; step render $?
for t in research-check-strict research-links research-test; do gate $t; make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
D=_process/research/2026-10-05-generative-foundation-review/root-foundation/development
gate dossiers
python3 -B $D/review-packet/check_dossiers.py > "$ASIDE/dossiers.log" 2>&1 && grep -q '^0 problem(s)' "$ASIDE/dossiers.log"; step dossiers $?
python3 -B $D/review-packet/check_dossiers.py $D/ue8-sciences-dossier/SCIENCES.md > "$ASIDE/dossiers-sciences.log" 2>&1 && grep -q '^0 problem(s)' "$ASIDE/dossiers-sciences.log"; step dossiers-sciences $?
git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths.txt"
git add --pathspec-from-file="$ASIDE/paths.txt"; step add $?
git commit -q -F - --pathspec-from-file="$ASIDE/paths.txt" <<MSG
SJ's last parts landed, and SJ is done (core receipt $ID, every axiom report empty, study §$N; one incremental core run). In the ring module \`Becoming.GuardHorizon\`, GuardHorizon's bridge to the core's law of a common response: \`uniform_policy_iff_common\`, given choice over the readings and every reading given by some configuration, a choice from readings meeting the requirement exists exactly where a response common over the reading's sameness does, through the core's «自反传递则共应当且仅当承遍» and \`uniform_policy_iff_fiber_feasible\`, which keeps its direct proof; \`ungiven_reading_not_uniform\`, with that choice and a reading no configuration gives, a common response with no choice from readings, so the second hypothesis does work; \`statewise_not_uniform\` re-proved from the leaf's witness «共应之例».EachNotCommon, its statement unchanged. The seventh law of a-response-common-over-a-reading, with its hypothesis, reference and binding, the converse item narrowed to what is not shown; a history line on when-to-inquire-and-when-to-respond. 08 §7 gains the map of what a response takes in: the law of a common response and each input it takes, with the law up to it, at most two witnesses that it is needed, its home and the edge record's rows taking it by label, read by U4's owner; 07 §5 one sentence: where a requirement is filled from the practical choices, with the condition for scope and C for order, and fixed before the outcome, a common response exists within it exactly where the acts' kernels cover the situations, and the law says nothing of which requirement is better; 03 §12's home, the root module's bullet and the package README's row name the bridge; 08's counts; the text review REVIEW-4, every confirmed finding taken; the connectivity register brought to the bridge; the records citing the changed texts re-pointed and GuardHorizon's proof bindings rebound, nothing they say changed; SJ's row moved to the history file, done; OU7b's row, which its landing (941acfc0a) left out, added before GC2's, on the coordinator's word; the seven records binding 08 as a whole file read and re-pointed; the kit's history-row step from the previous gap carried. Render, strict check, links, tests and both dossier checks pass.
MSG
step commit $?
git log --oneline -1 | cut -c1-120
