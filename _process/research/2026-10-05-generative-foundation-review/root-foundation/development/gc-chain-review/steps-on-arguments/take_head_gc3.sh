#!/bin/bash
# GC3's board commits on main, in one call: wait until no clause holds the head, then the claim row and the head clause,
# each one commit of the board on main and a fast-forward of the shared checkout, only if main has not moved and no clause
# holds the head. Run a copy outside the kit, since detaching the worktree at main removes the kit's committed files.
# It works in the worktree WT, clean and on the branch BRANCH, and returns it there.
# usage: take_head_gc3.sh WT BRANCH TOOL_DIR
set -u
W=$1; BRANCH=$2; T=$3; R=/Users/ren/theories; B=_process/BECOMING-WORKBOARD.md
held() { git -C "$R" show main:$B | grep -m1 '^- \*\*Queue:\*\*' | cut -c14- | awk -F'; ' '{print $1}' | grep -q 'at the head'; }
ours() { git -C "$R" show main:$B | grep -m1 '^- \*\*Queue:\*\*' | cut -c14- | awk -F'; ' '{print $1}' | grep -q '^GC3 at the head'; }
step() { # MODE MESSAGE
  local base new
  [ "$(git -C "$R" branch --show-current)" = main ] || { echo "SHARED CHECKOUT NOT ON MAIN"; return 7; }
  held && return 3
  base=$(git -C "$R" rev-parse main)
  git -C "$W" checkout -q -f --detach "$base" && [ -z "$(git -C "$W" status --porcelain)" ] || { echo "WORKTREE NOT CLEAN"; return 2; }
  python3 -B "$T/board_gc3.py" "$1" "$W/$B" || return 2
  [ "$(git -C "$W" diff --name-only)" = "$B" ] || { echo "UNEXPECTED PATHS"; git -C "$W" diff --name-only; return 2; }
  git -C "$W" diff --stat | tail -1
  git -C "$W" commit -q -m "$2" -- "$B" 2>/dev/null || return 2
  new=$(git -C "$W" rev-parse HEAD)
  [ "$(git -C "$R" rev-parse main)" = "$base" ] || { echo "MAIN MOVED; $new not landed"; return 4; }
  held && { echo "HEAD HELD; $new not landed"; return 3; }
  git -C "$R" merge --ff-only -q "$new" 2>/dev/null && { echo "DONE $1 $new"; return 0; }
  echo "FF FAILED"; return 5
}
back() { git -C "$W" checkout -q -f "$BRANCH" && [ -z "$(git -C "$W" status --porcelain)" ] || echo "WORKTREE NOT BACK ON $BRANCH"; }
CLAIM_MSG="Board: GC3 claimed (each step in the generativity chain that stood on a name given its argument, or marked as resting on none yet, through its maintenance record; documents only; on the coordinator's word, the head after SJ)"
HEAD_MSG="Board: GC3 at the head of the queue (landing now: each step in the generativity chain that stood on a name given its argument, or marked as resting on none yet, through its maintenance record; D43's dated line; documents only, no Lean, no record changed and no core run; then render, strict check, links, tests and both dossier checks, then the fast-forward)"
claimed=0; [ "$(git -C "$R" show main:$B | grep -c '^| \*\*GC3: each step')" = 1 ] && claimed=1
n=0
while :; do
  n=$((n + 1))
  [ "$n" -gt 2880 ] && { echo "GAVE UP after 24 hours"; back; exit 9; }
  if ours; then echo "HEAD OURS $(git -C "$R" rev-parse main)"; back; exit 0; fi
  if held; then sleep 30; continue; fi
  if [ "$claimed" = 0 ]; then
    step claim "$CLAIM_MSG"; rc=$?
    case $rc in 0) claimed=1;; 3|4) sleep 5; continue;; *) back; exit "$rc";; esac
  fi
  step head "$HEAD_MSG"; rc=$?
  case $rc in 0) echo "HEAD TAKEN $(git -C "$R" rev-parse main)"; back; exit 0;; 3|4) sleep 5; continue;; *) back; exit "$rc";; esac
done
