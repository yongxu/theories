#!/bin/bash
# U4e's landing (land_u4d.sh's pattern), in U4e's worktree on its branch, once U4e holds the head (head_u4e.sh): main
# merged in, the checker writing its run into the repository, then the steps of steps_u4e.sh, and one commit of every
# changed path. The fast-forward is ff_u4e.sh's.
# usage: U4E_ORDER="…" land_u4e.sh WORKTREE ASIDE   (ASIDE a folder outside the repository, for logs; U4E_ORDER the
#        coordinator's order sentence for the landed clause, sent with its word, verbatim; required)
set -u
W=$1; ASIDE=$2
K=$(cd "$(dirname "$0")" && pwd)
PKG=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
STUDY=_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md
B=_process/BECOMING-WORKBOARD.md
cd "$W" || exit 1
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
[ "$(git branch --show-current)" = u4e ]; step branch $?
[ -n "${U4E_ORDER:-}" ] && ! printf %s "$U4E_ORDER" | grep -qw U4e; step coordinator-order $?
export U4E_ORDER
[ -z "$(git status --porcelain --untracked-files=no)" ]; step clean $?
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '^- \*\*Queue:\*\* U4e at the head of the queue (landing now'; step head-claim $?
mkdir -p "$ASIDE"
base=$(git rev-parse main); echo "$base" > "$ASIDE/main-at-merge.txt"
git merge --no-edit -q "$base" > "$ASIDE/merge.log" 2>&1; step merge $?
BEFORE=$(ls $PKG/becoming-checks | grep -v '^_' | tail -1)
(cd $PKG && LEAN_TIMEOUT=2400 python3 -B check_becoming.py > "$ASIDE/check.log" 2>&1); step checker $?
ID=$(ls $PKG/becoming-checks | grep -v '^_' | tail -1)
[ "$ID" != "$BEFORE" ]; step new-receipt $?
N=$(( $(grep -E '^## [0-9]+\. ' $STUDY | tail -1 | sed -E 's/^## ([0-9]+)\..*/\1/') + 1 ))
echo "receipt $ID, study section $N"
U4E_BASE=$(cat "$ASIDE/main-at-merge.txt"); export U4E_BASE
. "$K/steps_u4e.sh"
git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths.txt"
git add --pathspec-from-file="$ASIDE/paths.txt"; step add $?
git commit -q -F - --pathspec-from-file="$ASIDE/paths.txt" <<MSG
U4e landed: Identity's covering laws finished (core receipt $ID, every axiom report empty, study §$N). Web.arisingFrom_not_stopping_covered is re-proved as the root's «有覆而亡屡则生不止» at the formations' occurrences within activity onward, its statement unchanged, no longer through not_not_arisingFrom_covered; the root form, registered by U4d as an apart root with no use on the base, is used now and its register entry goes. The four census recurrence laws under a continuation (Web.Census.arisingFrom_of_ceasingFrom and its from-a-step form, Web.Census.ceasingFrom_of_arisingFrom and its from-a-step form) drop the decision binders their proofs do not use: the arising direction keeps whether a formation continues one active before, the ceasing direction whether one is continued by one active after, and neither decides activity; Persistence's Web.persisting_census drops decided holding activity and the decided continuation, keeping the two the census laws take. Each of the five statements is more general. RootForms.some_depends states its witness instead of only that it is not refuted (the Lean review's finding), its six uses applying the negations to it; the two certificates' docstrings say that stating them is their check, the type ascription already ensuring it, and that rfl then closes them by proof irrelevance (the Lean review's wording). The signature audit finds every other statement of Identity, Persistence and RootForms unchanged, nothing added, gone or moved, and no decision binder of Identity or Persistence left unused by both statement and proof. Records: census-balance-under-continuation (the second hypotheses entry and law 12 say which decision each law takes, law 4 names «有覆而亡屡则生不止» among the covering laws' routes, the Next drops the item now done) identity-across-steps (a history line for persisting_census) and one-root-to-its-edge (the Next drops a theorem that no statement reading only the dynamics entails C, which DU's ReadsNoOrder.not_entails gives); 01 §9.5's census row; Identity's covering-lists bullet and the four docstrings; 08's counts; the connectivity register; the shared laws' view rerun, 08 §7's figures unchanged. The records citing what changed re-pointed and the three modules' proof bindings rebound, nothing they say changed; U4e's row in the history file, and U4's row with it, what U4 leaves being the edge record's Next. Render, strict check, links, the tests and both dossier checks pass on this tree.
MSG
step commit $?
git log --oneline -1 | cut -c1-120
