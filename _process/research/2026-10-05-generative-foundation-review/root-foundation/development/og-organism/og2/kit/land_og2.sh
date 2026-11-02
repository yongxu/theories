#!/bin/bash
# OG2's landing (land_bd4.sh's pattern), in OG2's worktree on branch og2-institution, once OG2 holds the head (head_og2.sh):
# main merged in, the checker writing its run into the repository, the record, 08's counts, the study section and
# WHAT-REMAINS' line filled in (land_og2.py), the connectivity register's apart roots (register_og2.py), the
# connectivity and shared laws, the board's landed clause, and one commit of every changed path. The rehearsal's
# dry run (scratch receipt 20261102T152701.560288Z) drifted three records bound to the overview, by the status sentence;
# read against them, nothing they say changed, so they are re-pointed here. Any other drift stops the strict check, to
# be read and settled by hand. The fast-forward is ff_og2.sh's.
# usage: OG2_ORDER="…" land_og2.sh WORKTREE ASIDE   (ASIDE a folder outside the repository, for logs; OG2_ORDER the
#        coordinator's order sentence for the landed clause, sent with its word, verbatim; required)
#        land_og2.sh WORKTREE ASIDE rehearse       (on a throwaway branch: no head check, no board edit, no commit)
set -u
W=$1; ASIDE=$2; MODE=${3:-land}
K=$(cd "$(dirname "$0")" && pwd)
PKG=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
RF=_process/research/2026-10-05-generative-foundation-review/root-foundation
STUDY=$RF/BECOMING-RENEWAL-READING.md
C=$RF/THEOREM-CONNECTIVITY.py
B=_process/BECOMING-WORKBOARD.md
cd "$W" || exit 1
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
if [ "$MODE" = land ]; then
  [ "$(git branch --show-current)" = og2-institution ]; step branch $?
  [ -n "${OG2_ORDER:-}" ]; step coordinator-order $?
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '^- \*\*Queue:\*\* OG2 at the head of the queue (landing now'; step head-claim $?
else
  [ "$MODE" = rehearse ] && [ "$(git branch --show-current)" != og2-institution ]; step rehearse-branch $?
fi
[ -z "$(git status --porcelain --untracked-files=no)" ]; step clean $?
mkdir -p "$ASIDE"
git rev-parse main > "$ASIDE/main-at-merge.txt"
git merge --no-edit -q main > "$ASIDE/merge.log" 2>&1; step merge $?
grep -c 'Becoming.RuleRebuilding' $PKG/check_becoming.py | grep -qv '^0$'; step in-core-list $?
BEFORE=$(ls $PKG/becoming-checks | grep -v '^_' | tail -1)
(cd $PKG && LEAN_TIMEOUT=2400 python3 -B check_becoming.py > "$ASIDE/check.log" 2>&1); step checker $?
ID=$(ls $PKG/becoming-checks | grep -v '^_' | tail -1)
[ "$ID" != "$BEFORE" ]; step new-receipt $?
N=$(( $(grep -E '^## [0-9]+\. ' $STUDY | tail -1 | sed -E 's/^## ([0-9]+)\..*/\1/') + 1 ))
echo "receipt $ID, study section $N"
python3 -B "$K/land_og2.py" "$ID" "$N" > "$ASIDE/land_og.log" 2>&1; step land-texts $?
python3 -B "$K/fronts_og2.py" > "$ASIDE/fronts.log" 2>&1; step fronts $?
python3 -B "$K/budgets_og2.py" > "$ASIDE/budgets.log" 2>&1; step budgets $?
python3 -B tools/research/repoint.py --reason "OG2's status sentence in the overview's section 10 now names one kind of institution's model beside the organism's; the overview names these three results elsewhere and links to 02 for their statements, restating none of them in the sentence changed and contradicting none; read against the records, nothing they say changed." --paths theories/becoming/THE-THEORY-OF-BECOMING.md --ids loss-read-in-time-by-the-others readers-drawn-from-the-selected shaping-read-by-readers-drawn-from-the-selected --apply > "$ASIDE/repoint.log" 2>&1; step repoint $?
python3 -B $C --check > "$ASIDE/conn1.log" 2>&1; echo "== connectivity before registering: exit $?"
python3 -B "$K/register_og2.py" "$ASIDE/conn1.log" > "$ASIDE/register.log" 2>&1; step register $?
python3 -B $C --write > "$ASIDE/conn2.log" 2>&1; step connectivity-write $?
python3 -B $C --check > "$ASIDE/conn3.log" 2>&1; step connectivity-check $?
python3 -B tools/research/shared_laws.py > "$ASIDE/shared.log" 2>&1; step shared-laws $?
[ "$MODE" = land ] && { python3 -B "$K/board_og2.py" landed "$ID" "$N" > "$ASIDE/board.log" 2>&1; step board $?; }
make research-render > "$ASIDE/render.log" 2>&1; step render $?
for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
python3 -B $RF/development/review-packet/check_dossiers.py > "$ASIDE/dossiers.log" 2>&1; step dossiers $?
python3 -B $RF/development/review-packet/check_dossiers.py $RF/development/ue8-sciences-dossier/SCIENCES.md > "$ASIDE/sciences.log" 2>&1; step sciences $?
git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths.txt"
[ "$MODE" = rehearse ] && { echo "rehearsal: $(wc -l < "$ASIDE/paths.txt") paths changed, nothing committed"; exit 0; }
git add --pathspec-from-file="$ASIDE/paths.txt"; step add $?
COUNTS=$(cat _process/research/2026-10-05-generative-foundation-review/root-foundation/development/og-organism/og2/LANDED-COUNTS.txt)
git commit -q -F - --pathspec-from-file="$ASIDE/paths.txt" <<MSG
OG2 landed: one kind of institution's minimal model, a rule of entry rebuilt from the members it limits (\`Becoming.RuleRebuilding\`, a new instance of the ring on the grammar, core receipt $ID, $COUNTS, every axiom report empty, study §$N). One rule makes a family of nets by where the rule is taught from (members, outside, nowhere); others enter past a door of a strength per teacher, every member draws one unit, and an overdraw ends everything, a clause with the form of Flow's gated ending which uses no law of it. From the steady state the rule is held at every step exactly where teaching fits a tenure, the quota is at least one and the take fits the renewal («稳者恒持当且仅当在带»); a region is closed under a revision inside it, and the band does not settle what follows a revision («域闭», «带不定改后»); no holder comes from no holder, and at s ≤ l or a quota of 0 the holders drain («无持者不复», «不及任则持尽», «额零则持尽»); the steady state and open entry are two tests, each its own («稳开二试»); at l = s − 1 held and empty cohorts rotate and the rule is held exactly where their joint take fits, the count of held ones weighing one take against the other, with what each side of that needs stated as laws («隙之律», «隙存而稳不存之式», «稳存而隙不存之式»). Not proved: a classification of the ends, gaps at l < s − 1, the interval the band solves to, a bridge to Flow. Not modelled: why a teacher turns anyone away, conduct other than entry, sanctions, who decides a revision, mixed tenures, schism, records, purposes, capture. The new record a-rule-rebuilt-from-the-members-it-limits, home 05 §12 with an AI reading; 01's test-systems bullet; the status sentence on the one page and overview in both editions; 08's ring sentence and counts; WHAT-REMAINS' lines after the gate. The root module's bullet, the checker's core list and scope, both package READMEs and regions.json. Two independent AI readings of the design with a re-check by runs of the rule, one of the Lean, every finding taken (REVIEW-1.md to REVIEW-4.md); the Lean step and the simulation agree on 699,840 cases. The connectivity register's new apart roots each with a reason; OG2's row in the history file. Render, strict check, links, tests and both dossier checks pass.
MSG
step commit $?
git log --oneline -1 | cut -c1-120
