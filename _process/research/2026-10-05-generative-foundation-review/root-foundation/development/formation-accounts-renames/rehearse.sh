#!/bin/bash
# FA's rehearsal: land.sh with REHEARSE=1 in a detached throwaway worktree off branch formation-accounts-renames,
# never committed anywhere that lands and never fast-forwarded. It merges main as it is now, drops any head clause on
# that worktree's board, claims and heads FA there, and runs every landing step to the commit.
# usage: rehearse.sh ASIDE   (the worktree is ASIDE/wt-fa-rehearsal; remove it with git worktree remove after reading)
set -u
mkdir -p "$1" && ASIDE=$(cd "$1" && pwd) || exit 1
R=/Users/ren/theories
K2=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/formation-accounts-renames
WT="$ASIDE/wt-fa-rehearsal"
[ -e "$WT" ] && { echo "WORKTREE EXISTS: $WT"; exit 2; }
cd "$R" || exit 1
git worktree add -q --detach "$WT" formation-accounts-renames || exit 1
DEFAULT="Then, in the coordinator's order: RR2 rehearses, then RV21c; ask the coordinator for a slot."
[ -n "${FA_ORDER:-}" ] || FA_ORDER=$DEFAULT
FA_ORDER=$FA_ORDER REHEARSE=1 bash "$WT/$K2/land.sh" "$WT" "$ASIDE"
