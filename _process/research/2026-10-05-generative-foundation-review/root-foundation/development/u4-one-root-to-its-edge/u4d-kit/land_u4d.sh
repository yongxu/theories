#!/bin/bash
# U4d's landing (land_el6.sh's pattern), in U4d's worktree on its branch, once U4d holds the head (head_u4d.sh): main
# merged in, the checker writing its run into the repository, then the steps of steps_u4d.sh, and one commit of every
# changed path. The fast-forward is ff_u4d.sh's.
# usage: U4D_ORDER="…" land_u4d.sh WORKTREE ASIDE   (ASIDE a folder outside the repository, for logs; U4D_ORDER the
#        coordinator's order sentence for the landed clause, sent with its word, verbatim; required)
set -u
W=$1; ASIDE=$2
K=$(cd "$(dirname "$0")" && pwd)
PKG=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
STUDY=_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md
B=_process/BECOMING-WORKBOARD.md
cd "$W" || exit 1
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
[ "$(git branch --show-current)" = u4d ]; step branch $?
[ -n "${U4D_ORDER:-}" ] && ! printf %s "$U4D_ORDER" | grep -qw U4d; step coordinator-order $?
export U4D_ORDER
[ -z "$(git status --porcelain --untracked-files=no)" ]; step clean $?
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '^- \*\*Queue:\*\* U4d at the head of the queue (landing now'; step head-claim $?
mkdir -p "$ASIDE"
base=$(git rev-parse main); echo "$base" > "$ASIDE/main-at-merge.txt"
git merge --no-edit -q "$base" > "$ASIDE/merge.log" 2>&1; step merge $?
BEFORE=$(ls $PKG/becoming-checks | grep -v '^_' | tail -1)
(cd $PKG && LEAN_TIMEOUT=2400 python3 -B check_becoming.py > "$ASIDE/check.log" 2>&1); step checker $?
ID=$(ls $PKG/becoming-checks | grep -v '^_' | tail -1)
[ "$ID" != "$BEFORE" ]; step new-receipt $?
N=$(( $(grep -E '^## [0-9]+\. ' $STUDY | tail -1 | sed -E 's/^## ([0-9]+)\..*/\1/') + 1 ))
echo "receipt $ID, study section $N"
U4D_BASE=$(cat "$ASIDE/main-at-merge.txt"); export U4D_BASE
. "$K/steps_u4d.sh"
git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths.txt"
git add --pathspec-from-file="$ASIDE/paths.txt"; step add $?
git commit -q -F - --pathspec-from-file="$ASIDE/paths.txt" <<MSG
U4d landed: the covering laws on the root (core receipt $ID, every axiom report empty, study §$N). One count on the grammar does the work: occurrences that end on lines traced back to a list, the successor fixed where the lines could part, number at most the list, with no decision («线终不过所列»); on the grammar endings on lines from a list and, at the converse, beginnings on lines to it («线亡不过所列», «线生不过所列», each with its not-refuted form), with the line lemmas «所闭当且仅当有迭», «分处定后则迭之定于» (of which «迭之定于» is now the case), «亡者不在长迭» and «定后则线至多一亡». At stages, each step of the continuation one stage on: a list covering one stage bounds the endings over a stretch with nothing beginning («间无生则间亡不过所覆»), mirrored for beginnings («间无亡则间生不过所覆»), and the run forms follow, decided and undecided, and their converses with bounded lists («有覆而亡屡则生屡», «所覆后亡屡则生未否», «有界覆而生屡则亡屡» and the others). The census of a run (GrammarLaws.census_run, «定后前者在前则亡屡者生屡») is proved through the stretch form, stronger: two hypotheses dropped, the units after each step listed once and the test of endings; its finite search by the count. Re-proved as cases, statements unchanged: Locality's Covers.coming_from_of_ceasing, Covers.ceasing_steps_within, Covers.not_not_coming_from and Covers.ceasing_stops_unrefuted; Decidedness' ceasing_steps_within and coming_steps_within; Identity's Web.not_not_arisingFrom_covered, Web.arisingFrom_not_stopping_covered and Web.ceasingFrom_not_stopping_covered, no longer by lineages. New at Identity: the exact forms from covering lists (Web.arisingFrom_of_ceasingFrom_covered, Web.ceasingFrom_of_arisingFrom_covered), with no census and no decision of activity, the census recurrence laws their cases. Gone, no consumer left: Locality's accumulates_or, ceases_once and ceasing_steps_unrefuted, Identity's Web.Lineage.ends, Web.ceasingFrom_found, Web.arisingFrom_found and Web.lineages_apart, Population's endTest; the prelude gains exists_pairs_over and distinct_of_map. The signature audit: the census of a run's two laws stronger, every other statement unchanged. Records: shared-laws-on-the-grammar (law 19, ends on lines; law 7's line lemmas; the census of a run moved from law 4), census-balance-under-continuation (law 12, the exact forms, the decision each needs read as a reduction to weak excluded middle), and six more naming their routes; one-root-to-its-edge's next step drops the covering laws' root form. 01 §7's ends-on-lines bullet and 01 §9.5's census row; the root module's bullet and both package READMEs; 08's counts; the connectivity register; the shared laws' view rerun, 08 §7's figures unchanged. The design (COVERING-ON-THE-ROOT.md) checked in scratch Lean and read by an independent AI review (REVIEW-U4D.md), every finding taken; the names GrammarLaws' owner's. The records citing what changed re-pointed and the changed modules' proof bindings rebound, nothing they say changed; U4d's row in the history file. Render, strict check, links, the tests and both dossier checks pass on this tree.
MSG
step commit $?
git log --oneline -1 | cut -c1-120
