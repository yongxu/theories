#!/bin/zsh
# AP2: rebase the landing onto main, resolve the generated and bookkeeping conflicts (board by board.py, generated
# pages, rebind log and records by main's side, AP2's rebind lines kept), re-point the chapter, re-render, check and
# fast-forward main if it has not moved. Stops on any conflict in a source it should not resolve.
set -e
K=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ap2-reading-law
H=_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md
RB=_process/architecture/rebinds.jsonl
T=$(mktemp -d)
git show HEAD:$RB | grep '"AP2' > $T/ap2rb.txt || true
M=$(git rev-parse main)
if ! git rebase $M > $T/rebase.log 2>&1; then
  git status --short | grep '^UU' | awk '{print $2}' > $T/conf.txt
  if grep -v '^_process/BECOMING-WORKBOARD.md$\|^_process/architecture/\|^_process/research/README.md$\|INDEX.md$\|^theories/becoming/results/records/\|^README.md$\|^RESULTS.md$\|^DEPENDENCIES.md$\|^theories/becoming/results/' $T/conf.txt; then
    echo "source conflict: stopping"; exit 3
  fi
  git checkout --ours --pathspec-from-file=$T/conf.txt
  git show $M:$H > $H
  python3 -B $K/board.py 20261021T111912.398950Z 305
  grep -qF -f $T/ap2rb.txt $RB || cat $T/ap2rb.txt >> $RB
  git add --pathspec-from-file=$T/conf.txt; git add $H $RB
  GIT_EDITOR=true git rebase --continue
fi
python3 -B tools/research/research.py check > $T/drift.json 2>/dev/null || true
python3 -B tools/research/repoint.py --reason "AP2 rebased onto main: the chapter merged with AP2's sections 6.5, 7.3, 7.7, 8.1 item 7 and 9; read before re-pointing" --drift-json $T/drift.json --paths theories/becoming/chapters/THE-THEORY-OF-BECOMING.md --apply > $K/repoint-rebase.log 2>&1
make research-render > $K/research-render.log 2>&1
make research-check > $K/research-check.log 2>&1
make research-links > $K/research-links.log 2>&1 || true
grep -o '"target": "[^"]*"' $K/research-links.log
git status --porcelain | sed 's/^...//' > $T/paths.txt
if [ -s $T/paths.txt ]; then git add --pathspec-from-file=$T/paths.txt; git commit -q --amend --no-edit; fi
if [ "$(git rev-parse main)" = "$(git merge-base main HEAD)" ]; then
  git -C /Users/ren/theories merge --ff-only $(git rev-parse --abbrev-ref HEAD) | tail -1; echo LANDED
else echo "main moved"; fi
