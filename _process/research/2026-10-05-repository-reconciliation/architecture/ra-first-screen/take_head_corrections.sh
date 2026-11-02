#!/bin/bash
# Wait until PF3 is on main (main's pin on C reads 'gives order' without 'alone') and no clause holds the head, then commit
# the head clause on main and fast-forward the shared checkout, only if main has not moved and no clause holds the head.
# It works in the worktree WT, clean and on the branch BRANCH, and returns it there. It never touches a dirty worktree.
# usage: take_head_corrections.sh WT BRANCH TOOL_DIR
set -u
W=$1; BRANCH=$2; T=$3; R=/Users/ren/theories; B=_process/BECOMING-WORKBOARD.md; P=tools/research/tests/test_featured_results.py
held() { git -C "$R" show main:$B | grep -m1 '^- \*\*Queue:\*\*' | cut -c14- | awk -F'; ' '{print $1}' | grep -q 'at the head'; }
ours() { git -C "$R" show main:$B | grep -m1 '^- \*\*Queue:\*\*' | cut -c14- | awk -F'; ' '{print $1}' | grep -q "^README's three first-screen corrections at the head"; }
pf3() { ! git -C "$R" show main:$P | grep -q "assertIn('alone gives order', screen)"; }
back() { git -C "$W" checkout -q -f "$BRANCH" && [ -z "$(git -C "$W" status --porcelain)" ] || echo "WORKTREE NOT BACK ON $BRANCH"; }
MSG="Board: README's three first-screen corrections at the head of the queue (landing now, on the coordinator's word, behind PF3; documents only, no Lean, no record changed and no core run; then render, strict check, links, tests and both dossier checks, then the fast-forward)"
step() {
  local base new
  [ "$(git -C "$R" branch --show-current)" = main ] || { echo "SHARED CHECKOUT NOT ON MAIN"; return 7; }
  held && return 3
  [ -z "$(git -C "$W" status --porcelain)" ] || { echo "WORKTREE DIRTY BEFORE THE CHECKOUT"; return 2; }
  base=$(git -C "$R" rev-parse main)
  git -C "$W" checkout -q -f --detach "$base" && [ -z "$(git -C "$W" status --porcelain)" ] || { echo "WORKTREE NOT CLEAN"; return 2; }
  python3 -B "$T/board_corrections.py" head "$W/$B" || return 2
  [ "$(git -C "$W" diff --name-only)" = "$B" ] || { echo "UNEXPECTED PATHS"; git -C "$W" diff --name-only; return 2; }
  git -C "$W" diff --stat | tail -1
  git -C "$W" commit -q -m "$MSG" -- "$B" 2>/dev/null || return 2
  new=$(git -C "$W" rev-parse HEAD)
  [ "$(git -C "$R" rev-parse main)" = "$base" ] || { echo "MAIN MOVED; $new not landed"; return 4; }
  held && { echo "HEAD HELD; $new not landed"; return 3; }
  git -C "$R" merge --ff-only -q "$new" 2>/dev/null && { echo "DONE head $new"; return 0; }
  echo "FF FAILED"; return 5
}
n=0
while :; do
  n=$((n + 1))
  [ "$n" -gt 2880 ] && { echo "GAVE UP after 24 hours"; exit 9; }
  if ours; then echo "HEAD OURS $(git -C "$R" rev-parse main)"; exit 0; fi
  if ! pf3 || held; then sleep 30; continue; fi
  step; rc=$?
  case $rc in
    0) back; echo "HEAD TAKEN $(git -C "$R" rev-parse main)"; exit 0;;
    3|4) back; sleep 5; continue;;
    *) back; exit "$rc";;
  esac
done
