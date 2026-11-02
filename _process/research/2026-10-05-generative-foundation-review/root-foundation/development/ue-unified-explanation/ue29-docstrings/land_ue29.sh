#!/bin/bash
# UE29: FreeEnergyCounting's off-support docstrings and Ranking's J1/J2 labels (land_ue28.sh's and UE22's patterns).
#   claim WORKTREE: UE29's row on the board, one board commit, fast-forward, only with no clause at the head.
#   head WORKTREE: UE29's head clause, one board commit, fast-forward, only with no clause at the head.
#   rehearse WORKTREE ASIDE: the landing's steps on a worktree detached at main, with no board edit and no commit.
#   land WORKTREE ASIDE: on UE29's head claim, the same steps, the board's landed clause with ORDER (the coordinator's
#     sentence, verbatim), then one commit of every changed path.
#   ff COMMIT: the fast-forward, only if main is the commit's parent and UE29 holds the head.
# Each Lean run waits for the gate: 5-minute load under 24, memory at least 40% free, at most one other Lean run.
# usage: land_ue29.sh claim|head WORKTREE | land_ue29.sh rehearse WORKTREE ASIDE
#        ORDER='...' land_ue29.sh land WORKTREE ASIDE | land_ue29.sh ff COMMIT
set -u
R=/Users/ren/theories; K=$(cd "$(dirname "$0")" && pwd); B=_process/BECOMING-WORKBOARD.md
KIT=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue-unified-explanation/ue29-docstrings
PKG=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
FEDIR=experiments/integrated-correction/general-framework/generative-basis/lean/free-energy
LEANS="$PKG/Becoming/FreeEnergyCounting.lean $PKG/Becoming/Ranking.lean $PKG/Becoming/MapRegions.lean $PKG/Becoming/BlanketCouplings.lean"
FILES="$LEANS _process/research/2026-10-05-generative-foundation-review/root-foundation/development/qr-quick-lean-review/FINDINGS.md"
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
ok() {
  l=$(sysctl -n vm.loadavg | awk '{print $3}'); m=$(memory_pressure | tail -1 | grep -o '[0-9]*')
  n=$(pgrep -f 'python3 -B [c]heck_becoming|python3 -B [s]cratch_build|python3 -B [c]heck_free_energy|python3 -B [c]heck_expected|python3 -B [c]heck_cells|python3 -B [c]heck_linear' | wc -l)
  awk -v l="$l" -v m="$m" -v n="$n" 'BEGIN{exit !(l<24 && m>=40 && n<=1)}'
}
gate() { until ok; do sleep 60; done; echo "gate $1 open at $(date +%H:%M:%S): load $(sysctl -n vm.loadavg)"; }
newest() { ls "$1" | tail -1; }
board_commit() {  # $1 WORKTREE, $2 board_ue29.py mode, $3 message
  cd "$R" || exit 1
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD"; exit 3; }
  base=$(git rev-parse main)
  cd "$1" && git checkout -q -f --detach "$base" && [ -z "$(git status --porcelain)" ] || { echo "WORKTREE NOT CLEAN"; exit 2; }
  python3 -B "$K/board_ue29.py" "$2" || exit 2
  [ "$(git diff --name-only)" = "$B" ] || { echo "UNEXPECTED PATHS"; git diff --name-only; exit 2; }
  git commit -q -m "$3" -- $B
  new=$(git rev-parse HEAD); cd "$R" || exit 1
  [ "$(git rev-parse main)" = "$base" ] || { echo "MAIN MOVED; $new not landed"; exit 4; }
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD; $new not landed"; exit 3; }
  git merge --ff-only -q "$new" && echo "LANDED $new" || { echo "FF FAILED"; exit 5; }
}
steps() {  # $1 WORKTREE, $2 ASIDE, $3 land|rehearse
  W=$1; ASIDE=$2; MODE=$3
  cd "$W" || exit 1; mkdir -p "$ASIDE"
  [ -z "$(git status --porcelain)" ]; step clean $?
  if [ "$MODE" = land ]; then
    git show -s --format=%s HEAD | grep -q '^Board: UE29 at the head of the queue'; step head-claim $?
  fi
  git checkout ue29-docstrings -- $FILES $KIT; step docstrings-and-kit $?
  [ "$(git diff HEAD --numstat -- $LEANS | awk '{a+=$1; d+=$2} END{print a" "d}')" = "15 10" ]; step docstrings-only-diff $?
  BEFORE=$(newest $PKG/becoming-checks); gate core
  (cd $PKG && LEAN_TIMEOUT=2400 python3 -B check_becoming.py > "$ASIDE/check.log" 2>&1); step core-checker $?
  CORE=$(newest $PKG/becoming-checks); [ "$CORE" != "$BEFORE" ]; step core-receipt $?
  BEFORE=$(newest $FEDIR/free-energy-reals-checks); gate free-energy-reals
  (cd $FEDIR && LEAN_TIMEOUT=2400 python3 -B check_free_energy_reals.py > "$ASIDE/check-fe.log" 2>&1); step free-energy-reals $?
  FE=$(newest $FEDIR/free-energy-reals-checks); [ "$FE" != "$BEFORE" ]; step fe-receipt $?
  BEFORE=$(newest $FEDIR/expected-free-energy-reals-checks); gate expected-free-energy-reals
  (cd $FEDIR && LEAN_TIMEOUT=2400 python3 -B check_expected_free_energy_reals.py > "$ASIDE/check-efe.log" 2>&1); step expected-free-energy-reals $?
  EFE=$(newest $FEDIR/expected-free-energy-reals-checks); [ "$EFE" != "$BEFORE" ]; step efe-receipt $?
  echo "receipts: core $CORE, FreeEnergyReals $FE, ExpectedFreeEnergyReals $EFE"
  echo "$CORE $FE $EFE" > "$ASIDE/receipts.txt"
  python3 -B "$K/rebind_ue29.py" "$CORE" "$FE" "$EFE" > "$ASIDE/rebind-dry.log" 2>&1; step rebind-dry $?
  python3 -B "$K/rebind_ue29.py" "$CORE" "$FE" "$EFE" --apply > "$ASIDE/rebind.log" 2>&1; step rebind $?
  python3 -B tools/research/shared_laws.py > "$ASIDE/shared-laws.log" 2>&1; step shared-laws $?
  if [ "$MODE" = land ]; then
    python3 -B "$K/board_ue29.py" land "$CORE" "$FE" "$EFE" "$ORDER" > "$ASIDE/board.log" 2>&1; step board $?
  fi
  make research-render > "$ASIDE/render.log" 2>&1; step render $?
  for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
  grep -q '^Ran 307 tests' "$ASIDE/research-test.log"; step ran-307 $?
  DC=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/review-packet/check_dossiers.py
  python3 -B $DC > "$ASIDE/dossiers-review.log" 2>&1; step dossiers-review $?
  python3 -B $DC _process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue8-sciences-dossier/SCIENCES.md > "$ASIDE/dossiers-sciences.log" 2>&1; step dossiers-sciences $?
  git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths.txt"
  grep -q '\.build/\|\.lake/' "$ASIDE/paths.txt" && { echo "BUILD OUTPUT IN THE PATHS"; exit 8; }
  [ "$MODE" = land ] || { echo "rehearsal passed: $(wc -l < "$ASIDE/paths.txt") paths changed"; return 0; }
  git add --pathspec-from-file="$ASIDE/paths.txt"; step add $?
  git commit -q -F - --pathspec-from-file="$ASIDE/paths.txt" <<MSG
UE29 landed: core docstrings brought to what the Lean proves, in FreeEnergyCounting, Ranking, MapRegions and BlanketCouplings (docstrings only, no statement, proof or declaration changed; core receipt $CORE, incremental, every axiom report empty; periphery receipts $FE for FreeEnergyReals and $EFE for ExpectedFreeEnergyReals, each with its axioms reported). RECHECK-UE22's N2: Becoming.FreeEnergyCounting's module docstring and Witness.off_support's said the real form of FreeEnergyReals fails at that witness, where under log 0 = 0 it holds at equality (FreeEnergy.Witness.one_count_off_support) and the core's bound is strict; each now says so, and that the real form fails at counts one and one against the same weights (FreeEnergy.Witness.gap_counts_off_support). The text review's Ranking fix, folded in on the coordinator's word: Becoming.Ranking's four docstrings read J1/J2 where they read J1, as Becoming.Lexical does. The second Lean review's narrowing, routed here by the coordinator (its findings file says where each finding went): MapRegions' Once.endless goes on from its first occurrence, as stated, and BlanketCouplings' header says ThresholdDrain's join is the case of the witness's web with no couplings (ThresholdCase.values). The proof bindings of eleven records moved to these receipts (basic-priority-step-by-step, becoming-renewal-reading, ranking-under-readings, relation-level-law-of-easing, relational-reading-comparison, stepwise-law-of-easing, free-energy-bound-in-counts, free-energy-bounds-surprisal, expected-free-energy-and-its-terms, a-formations-couplings-as-its-blanket, generation-and-degeneration-at-two-grains), each read against the change, nothing it says changed; 08's receipt sentence from the new receipt; the shared laws regenerated. The kit in the UE study (ue29-docstrings/). The board's landed clause with the coordinator's order; UE29's row, and UE8's (done, its sixth-dossier decision kept in Decisions pending Ren) and UE's (nothing in hand) rows closed, in the history file. Render, strict check, links, the 307 tests and both dossier checks pass on this tree.
MSG
  step commit $?
  git log --oneline -1 | cut -c1-120
}
case "${1:-}" in
claim) board_commit "$2" claim "Board: UE29 claimed (core docstrings brought to what the Lean proves: FreeEnergyCounting's off-support docstrings, RECHECK-UE22 N2, with Ranking's J1/J2 labels and the second Lean review's narrowing in MapRegions and BlanketCouplings folded in on the coordinator's word; docstrings only, one incremental core run and both free-energy periphery checkers; staged on the branch ue29-docstrings)" ;;
head) board_commit "$2" head "Board: UE29 at the head of the queue (landing now: docstrings only, no statement changed: FreeEnergyCounting's off-support docstrings, Ranking's J1/J2 labels, and MapRegions' and BlanketCouplings' narrowing; one incremental core run and both free-energy periphery checkers; eleven records' proof bindings moved; render, strict check, links, tests and both dossier checks, then the fast-forward)" ;;
rehearse) steps "$2" "$3" rehearse ;;
land) : "${ORDER:?set ORDER to the sentence the coordinator gives}"; steps "$2" "$3" land ;;
ff)
  NEW=$2; cd "$R" || exit 1
  [ "$(git branch --show-current)" = main ] || { echo "SHARED CHECKOUT NOT ON MAIN"; exit 7; }
  [ "$(git rev-parse main)" = "$(git rev-parse "$NEW^")" ] || { echo "MAIN MOVED"; exit 4; }
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '^- \*\*Queue:\*\* UE29 at the head of the queue (landing now' || { echo "HEAD NOT UE29'S"; exit 3; }
  [ -e "$KIT" ] && { echo "KIT FOLDER IN THE SHARED CHECKOUT: compare it with $NEW:$KIT, keep any difference under refs/salvage/, then move it aside"; exit 6; }
  git merge --ff-only -q "$NEW" && echo "LANDED $NEW" || { echo "FF FAILED"; exit 5; } ;;
*) sed -n '2,10p' "$0"; exit 1 ;;
esac
