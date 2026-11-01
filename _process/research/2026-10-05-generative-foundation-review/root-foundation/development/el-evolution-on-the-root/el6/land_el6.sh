#!/bin/bash
# EL6's landing (land_el.sh's pattern), in EL6's worktree on its branch, once EL6 holds the head (head_el6.sh): main
# merged in, the checker writing its run into the repository, then the steps of steps_el6.sh, and one commit of
# every changed path. The fast-forward is ff_el6.sh's.
# usage: EL6_ORDER="…" land_el6.sh WORKTREE ASIDE   (ASIDE a folder outside the repository, for logs; EL6_ORDER the
#        coordinator's order sentence for the landed clause, sent with its word, verbatim; required)
set -u
W=$1; ASIDE=$2
K=$(cd "$(dirname "$0")" && pwd)
PKG=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
STUDY=_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md
B=_process/BECOMING-WORKBOARD.md
cd "$W" || exit 1
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
[ "$(git branch --show-current)" = el6-kit ]; step branch $?
[ -n "${EL6_ORDER:-}" ] && ! printf %s "$EL6_ORDER" | grep -qw EL6; step coordinator-order $?
export EL6_ORDER
[ -z "$(git status --porcelain --untracked-files=no)" ]; step clean $?
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '^- \*\*Queue:\*\* EL6 at the head of the queue (landing now'; step head-claim $?
mkdir -p "$ASIDE"
git rev-parse main > "$ASIDE/main-at-merge.txt"
git merge --no-edit -q main > "$ASIDE/merge.log" 2>&1; step merge $?
BEFORE=$(ls $PKG/becoming-checks | grep -v '^_' | tail -1)
(cd $PKG && LEAN_TIMEOUT=2400 python3 -B check_becoming.py > "$ASIDE/check.log" 2>&1); step checker $?
ID=$(ls $PKG/becoming-checks | grep -v '^_' | tail -1)
[ "$ID" != "$BEFORE" ]; step new-receipt $?
N=$(( $(grep -E '^## [0-9]+\. ' $STUDY | tail -1 | sed -E 's/^## ([0-9]+)\..*/\1/') + 1 ))
echo "receipt $ID, study section $N"
. "$K/steps_el6.sh"
git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths.txt"
git add --pathspec-from-file="$ASIDE/paths.txt"; step add $?
git commit -q -F - --pathspec-from-file="$ASIDE/paths.txt" <<MSG
EL6 landed: EL3 placed in its owners' modules (core receipt $ID, every axiom report empty, study §$N), each part on its owner's yes, and \`Becoming.LineDegeneration\` retired to the Lean history folder (research.py move, batch EL6-history). In \`Becoming.GrammarMap\`: «尽则非无终» and «尽而续可定则有终» beside «尽则非不穷», and «尽则有终当且仅当排中» after its witness \`Map.StepWhere\`, now the short life gated by a proposition (formerly Map.not_not_end_of_ends, Map.end_of_ends_decided and Map.end_of_ends_iff_excluded_middle). In \`Becoming.MapInstances\`: the constructive degeneration law at every class within activity, the regimes' gone lemmas and degeneration laws and the witnesses; the landed laws that a line is not without end proved in place from degeneration through «尽则非不穷», and the law concluding an end through «尽而续可定则有终», \`Web.Restated\` dropped. In \`Becoming.KeepingWidening\`: the kind instance after \`Web.kindClass_within\`, its witness after \`KindRelay\`, and a header bullet. Renamed, each stating a wrong meaning (08 §10: the name says degeneration, the law concludes an end, 有终): \`Web.degenerates_of_gone\` → \`Web.end_of_gone\`, \`Map.Short.degeneration\` → \`Map.Short.reaches_end\`. The signature audit: every statement unchanged, the moves, renames and five restatements gone as expected, one definition rewritten with its type unchanged. Records degeneration-from-a-horizon (bound to the three modules, its law of restatements dropped) and generation-and-degeneration-at-two-grains (the renames), each with a history note, and the two EL records reusing the laws; 02 §1's names; 08's counts; the root module's bullets, the checker's core list and scope, both package READMEs and regions.json; the connectivity register (Web.ends_or_reaches an apart root); the EL study note; the records citing what changed re-pointed and the changed modules' proof bindings rebound, nothing they say changed; EL6's row in the history file. Render, strict check, links, the tests and both dossier checks pass on this tree.
MSG
step commit $?
git log --oneline -1 | cut -c1-120
