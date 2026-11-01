#!/bin/bash
# OG's landing (land_bd4.sh's pattern), in OG's worktree on branch og-organism, once OG holds the head (head_og.sh):
# main merged in, the checker writing its run into the repository, the record, 08's counts, the study section and
# WHAT-REMAINS' line filled in (land_og.py), the connectivity register's apart roots (register_og.py), the
# connectivity and shared laws, the board's landed clause, and one commit of every changed path. The rehearsal's
# dry run (scratch receipt 20261101T135208.604453Z) drifted no record, so there is no re-pointing step: a strict check
# failing on drift stops the script, to be read and settled by hand. The fast-forward is ff_og.sh's.
# usage: OG_ORDER="…" land_og.sh WORKTREE ASIDE   (ASIDE a folder outside the repository, for logs; OG_ORDER the
#        coordinator's order sentence for the landed clause, sent with its word, verbatim; required)
#        land_og.sh WORKTREE ASIDE rehearse       (on a throwaway branch: no head check, no board edit, no commit)
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
  [ "$(git branch --show-current)" = og-organism ]; step branch $?
  [ -n "${OG_ORDER:-}" ]; step coordinator-order $?
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '^- \*\*Queue:\*\* OG at the head of the queue (landing now'; step head-claim $?
else
  [ "$MODE" = rehearse ] && [ "$(git branch --show-current)" != og-organism ]; step rehearse-branch $?
fi
[ -z "$(git status --porcelain --untracked-files=no)" ]; step clean $?
mkdir -p "$ASIDE"
git rev-parse main > "$ASIDE/main-at-merge.txt"
git merge --no-edit -q main > "$ASIDE/merge.log" 2>&1; step merge $?
grep -c 'Becoming.ReaderRebuilding' $PKG/check_becoming.py | grep -qv '^0$'; step in-core-list $?
BEFORE=$(ls $PKG/becoming-checks | grep -v '^_' | tail -1)
(cd $PKG && LEAN_TIMEOUT=2400 python3 -B check_becoming.py > "$ASIDE/check.log" 2>&1); step checker $?
ID=$(ls $PKG/becoming-checks | grep -v '^_' | tail -1)
[ "$ID" != "$BEFORE" ]; step new-receipt $?
N=$(( $(grep -E '^## [0-9]+\. ' $STUDY | tail -1 | sed -E 's/^## ([0-9]+)\..*/\1/') + 1 ))
echo "receipt $ID, study section $N"
python3 -B "$K/land_og.py" "$ID" "$N" > "$ASIDE/land_og.log" 2>&1; step land-texts $?
python3 -B $C --check > "$ASIDE/conn1.log" 2>&1; echo "== connectivity before registering: exit $?"
python3 -B "$K/register_og.py" "$ASIDE/conn1.log" > "$ASIDE/register.log" 2>&1; step register $?
python3 -B $C --write > "$ASIDE/conn2.log" 2>&1; step connectivity-write $?
python3 -B $C --check > "$ASIDE/conn3.log" 2>&1; step connectivity-check $?
python3 -B tools/research/shared_laws.py > "$ASIDE/shared.log" 2>&1; step shared-laws $?
[ "$MODE" = land ] && { python3 -B "$K/board_og.py" landed "$ID" "$N" > "$ASIDE/board.log" 2>&1; step board $?; }
make research-render > "$ASIDE/render.log" 2>&1; step render $?
for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
python3 -B $RF/development/review-packet/check_dossiers.py > "$ASIDE/dossiers.log" 2>&1; step dossiers $?
python3 -B $RF/development/review-packet/check_dossiers.py $RF/development/ue8-sciences-dossier/SCIENCES.md > "$ASIDE/sciences.log" 2>&1; step sciences $?
git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths.txt"
[ "$MODE" = rehearse ] && { echo "rehearsal: $(wc -l < "$ASIDE/paths.txt") paths changed, nothing committed"; exit 0; }
git add --pathspec-from-file="$ASIDE/paths.txt"; step add $?
git commit -q -F - --pathspec-from-file="$ASIDE/paths.txt" <<MSG
OG landed: an organism's minimal model, a reader rebuilt from the level it reads (\`Becoming.ReaderRebuilding\`, a new instance of the ring on the grammar, core receipt $ID, 48 declarations (32 theorems), every axiom report empty, study §$N). One rule makes a family of four readers by where a spent unit is rebuilt from: a given reader, which does not age, and readers rebuilt from the supply, from the level, or not at all; the supply is chosen at every step, so every sequence of on and off is a course. Where the rebuild draws on the level, a present reader is present after a supplied step from every level, so the region where it is present is closed under the supplied step («供则读者不绝», «供则读者之域闭»); under a cut it is present after k + 1 steps from every level of at least 2 (k + 1) («断而有储则读者存»); where it ends the level is empty, and that state is closed under the net, the supply on or off («读者绝则无储», «取于储者绝而不复»). Rebuilt from the supply, or never, it is gone after its span from every level («断则取于供者尽», «不复建者尽»), and one rebuilt from the supply returns with it («取于供者复»). The family law: over the four members, the stock buys time under a cut, with an end from an empty stock, exactly where the rebuild draws on the level, at every span of at least one, so the rebuild's source separates the members, not the turnover («以储买时当且仅当取于储»). One unit's horizon is decided at spans two and three for small levels only; that each further s + 1 units buy s steps is a conjecture those cases check. Not proved: ending from every stock, a horizon never decreasing in the stock, any rate for more units. Not modelled: the flame and the equilibrium, the supply's and the sink's amounts, the turnover read as carrying. The new record the-stock-buys-time-where-the-rebuild-draws-on-it, home 04 §8 with an AI reading (a minimal case of self-maintenance, below closure of constraints, autopoiesis and Rosen's closure); 01's test-systems bullet; the one page's open item in both editions (four words more; READING-BUDGETS' row from the recount); 08's ring sentence and counts; WHAT-REMAINS' line after the gate. ND's checker-scope patch carried (two lines of the scope text, "master law" to ND's names). The root module's bullet, the checker's core list and scope, both package READMEs and regions.json. An independent AI reading of the design with its re-check by runs of the rule, and one of the Lean, every finding taken (REVIEW-1.md, REVIEW-2.md). The connectivity register's nine new apart roots each with a reason; OG's row in the history file. Render, strict check, links, tests and both dossier checks pass.
MSG
step commit $?
git log --oneline -1 | cut -c1-120
