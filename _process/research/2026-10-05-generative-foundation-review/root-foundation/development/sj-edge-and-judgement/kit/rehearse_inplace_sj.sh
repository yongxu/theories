#!/bin/bash
# SJ1's rehearsal run in SJ's own worktree, for when the disk cannot hold another checkout (1 November 2026: a
# checkout is 5.5 GB and 6.4 GiB were free). It waits for the load rule (5-minute load under 24, memory free at least
# 40%) and for at least MINFREE GiB of disk, detaches the worktree at sj-claim, runs rehearse_sj.sh in it, and then
# puts the worktree back exactly: the rehearsal's tracked changes saved as a diff and its new untracked files moved
# (not deleted) into ASIDE/untracked, the merge aborted, the branch checked out again. Nothing is committed.
# usage: [REHEARSE=rehearse_sj2.sh] rehearse_inplace_sj.sh WORKTREE ASIDE [MINFREE]   (ASIDE a folder outside the
#        repository; REHEARSE the kit's rehearsal script, rehearse_sj.sh by default)
set -u
W=$1; ASIDE=$2; MINFREE=${3:-5}
K=$(cd "$(dirname "$0")" && pwd)
mkdir -p "$ASIDE"
mkdir -p "$ASIDE/kit" && cp -p "$K"/* "$ASIDE/kit"/
cd "$W" || exit 1
[ "$(git branch --show-current)" = sj-claim ] || { echo "NOT ON sj-claim"; exit 2; }
[ -z "$(git status --porcelain --untracked-files=no)" ] || { echo "WORKTREE NOT CLEAN"; exit 2; }
until l=$(sysctl -n vm.loadavg | awk '{print $3}'); m=$(memory_pressure | awk -F': ' '/free percentage/ {sub("%","",$2); print $2}'); \
      f=$(df -g "$W" | awk 'NR==2 {print $4}'); \
      awk -v l="$l" -v m="$m" -v f="$f" -v n="$MINFREE" 'BEGIN {exit !(l < 24 && m >= 40 && f >= n)}'; do
  echo "$(date +%H:%M:%S) waiting: load5=$l mem=$m% free=${f}GiB" >> "$ASIDE/wait.log"; sleep 60
done
echo "$(date +%H:%M:%S) starting: load5=$l mem=$m% free=${f}GiB" | tee -a "$ASIDE/wait.log"
git status --porcelain --untracked-files=all | sed -n 's/^?? //p' | sort > "$ASIDE/untracked-before.txt"
git checkout -q --detach sj-claim || exit 2
"$ASIDE/kit/${REHEARSE:-rehearse_sj.sh}" "$W" "$ASIDE" > "$ASIDE/rehearse.out" 2>&1; rc=$?
cat "$ASIDE/rehearse.out"
git rev-parse HEAD > "$ASIDE/rehearsal-merge.txt"
git diff --binary sj-claim > "$ASIDE/rehearsal.diff"; git diff --stat sj-claim > "$ASIDE/rehearsal.diffstat"
git status --porcelain --untracked-files=all | sed -n 's/^?? //p' | sort > "$ASIDE/untracked-after.txt"
comm -13 "$ASIDE/untracked-before.txt" "$ASIDE/untracked-after.txt" > "$ASIDE/untracked-new.txt"
while IFS= read -r p; do mkdir -p "$ASIDE/untracked/$(dirname "$p")" && mv "$p" "$ASIDE/untracked/$p"; done < "$ASIDE/untracked-new.txt"
git merge --abort 2>/dev/null
git checkout -q -f sj-claim
[ -z "$(git status --porcelain --untracked-files=no)" ] && echo "== restored: worktree on sj-claim, clean" || echo "== RESTORE INCOMPLETE"
comm -13 "$ASIDE/untracked-before.txt" <(git status --porcelain --untracked-files=all | sed -n 's/^?? //p' | sort) | head
echo "== rehearsal exit $rc"
exit $rc
