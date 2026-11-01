#!/bin/bash
# EL's landing (land_bd3.sh's pattern), in EL's worktree on its branch, once EL holds the head (head_el.sh): main
# merged in, the checker writing its run into the repository, the receipt and study section filled in, the
# connectivity and shared laws, the citing records re-pointed, the board's landed clause, and one commit of every
# changed path. The fast-forward is ff_el.sh's.
# usage: EL_ORDER="…" land_el.sh WORKTREE ASIDE   (ASIDE a folder outside the repository, for logs; EL_ORDER the
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
[ "$(git branch --show-current)" = el-core ]; step branch $?
[ -n "${EL_ORDER:-}" ] && ! printf %s "$EL_ORDER" | grep -qw EL; step coordinator-order $?
[ -z "$(git status --porcelain --untracked-files=no)" ]; step clean $?
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '^- \*\*Queue:\*\* EL at the head of the queue (landing now'; step head-claim $?
mkdir -p "$ASIDE"
git rev-parse main > "$ASIDE/main-at-merge.txt"
git merge --no-edit -q main > "$ASIDE/merge.log" 2>&1; step merge $?
BEFORE=$(ls $PKG/becoming-checks | grep -v '^_' | tail -1)
(cd $PKG && LEAN_TIMEOUT=2400 python3 -B check_becoming.py > "$ASIDE/check.log" 2>&1); step checker $?
ID=$(ls $PKG/becoming-checks | grep -v '^_' | tail -1)
[ "$ID" != "$BEFORE" ]; step new-receipt $?
N=$(( $(grep -E '^## [0-9]+\. ' $STUDY | tail -1 | sed -E 's/^## ([0-9]+)\..*/\1/') + 1 ))
echo "receipt $ID, study section $N"
python3 -B "$K/reland_el.py" "$ID" "$N" > "$ASIDE/reland.log" 2>&1; step reland $?
python3 -B $C --check > "$ASIDE/conn1.log" 2>&1; echo "== connectivity before registering: exit $?"
python3 -B "$K/register_el.py" "$ASIDE/conn1.log" > "$ASIDE/register.log" 2>&1; step register $?
python3 -B $C --write > "$ASIDE/conn2.log" 2>&1; step connectivity-write $?
python3 -B $C --check > "$ASIDE/conn3.log" 2>&1; step connectivity-check $?
python3 -B tools/research/master_laws.py > "$ASIDE/master.log" 2>&1; step master-laws $?
make research-render > "$ASIDE/render1.log" 2>&1; echo "== render before re-pointing: exit $?"
python3 -B "$K/repoint_el.py" "$ID" > "$ASIDE/repoint-dry.log" 2>&1; step repoint-dry $?
python3 -B "$K/repoint_el.py" "$ID" --apply > "$ASIDE/repoint.log" 2>&1; step repoint $?
python3 -B "$K/board_el.py" landed "$ID" "$N" > "$ASIDE/board.log" 2>&1; step board $?
make research-render > "$ASIDE/render2.log" 2>&1; step render $?
for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths.txt"
git add --pathspec-from-file="$ASIDE/paths.txt"; step add $?
git commit -q -F - --pathspec-from-file="$ASIDE/paths.txt" <<MSG
EL landed: evolution read on the root (six core leaves, core receipt $ID, every axiom report empty, study §$N; no existing module changed). EL3, \`Becoming.LineDegeneration\`: along any class, a line whose reach at a step not before it ends on every branch ends on every branch, constructively, so at every class within activity a uniform horizon, not before the start, at which nothing reached is active gives degeneration («尽», «退化»), the activity and kind grains its instances and the three regimes of the map's old base degenerating through one step each; reaching an end (有终) from the law's premise is exactly excluded middle, on the base and on the grammar. EL1, \`Becoming.SelectionShift\` and \`Becoming.LineageRegions\`: a common shift of offspring numbers leaves the selection term proper unchanged and fixes no cohort's size; terms positive at unboundedly many steps force going on, exact transmission from a step with a positive term forces it, exactness at one step does not, and within any horizon a course's terms are shared by a course that goes on and one that ends; descent read as a lineage continuation on the map, a revival a birth at both grains; where listed offspring continue their parents a whole cohort degenerates only if a later one is empty, so a term positive at every nonempty cohort leaves not every member degenerating, while at a kind grain separating offspring from parents it is positive and every member degenerates. EL2, \`Becoming.LineageRegimes\`: gating with excess, dissipation and a draw on a condition given nothing, read as deciders of a lineage's region under a premise on the line's reach, are regimes whose horizon the stock sets, and from every stock of at least one, one course generates and one degenerates. EL4, \`Becoming.WindowedWaiting\` and \`Becoming.PairSelection\`: of the one-step laws of a pair keeping mutual giving, those keeping inclusion either never restore or never answer, agreement alone does both and does not keep inclusion, the window of two keeps inclusion and does both, and on configurations a window absorbs errors fewer than its length in a row and answers more; offspring read from a pair's run, with a withheld step weighing at least a received one no kind rises against withholders in a cohort listed as pairs, and under complete assortment waiting on giving is weakly favoured exactly where a received step weighs at least a withheld one; where a gift's surplus comes from, on the World's webs. Six new records: degeneration-from-a-horizon (02 §1), the-selection-term-and-a-lineages-fate (04 §3), ending-laws-as-regimes-on-a-lineage (04 §4), a-pair-tolerates-only-within-a-window and offspring-read-from-giving-that-waits (05 §5), what-giving-that-waits-draws-on (05 §6). 08's counts; the root module's bullets, the checker's core list and scope, both package READMEs and regions.json; the study's State of the Lean and the board row's conditional-laws item read as OU7 (OU5 was a wrong id); four rounds of independent AI verification of the Lean and a reading of the landing texts, every finding taken; the moves into GrammarMap, MapInstances and KeepingWidening and the rename of \`Web.degenerates_of_gone\` (it concludes an end, not degeneration) proposed in LineDegeneration's docstring, each on its owner's yes after OU7's rebuild; the connectivity register's new apart roots each with a reason; the records citing the changed sections re-pointed, nothing they say changed; EL's row in the history file. Render, strict check, links and tests pass.
MSG
step commit $?
git log --oneline -1 | cut -c1-120
