#!/bin/bash
# BD4's branch brought onto main before its landing, once main has moved past the claim base: EL's leaves added rows
# and bullets to the files BD4's texts go in, and OU7 changes one comment line of the leaf, the record's dependency on
# not-going-out-of-a-region with a history note, and the record's binding. Main is merged in without a commit. The
# seven files apply_bd4.py writes are taken from main and BD4's texts applied on them again, so every change main made
# to them is kept and BD4's history note follows main's; the leaf and every other path merge as git merges them, and a
# conflict anywhere else stops the script with the merge left for reading. Then the record check must report only the
# expected failures of a receipt not yet run, and the merge is committed on the branch.
# usage (BD4's worktree, clean): merge_bd4.sh REVIEWED_AT_UTC LOGDIR
#        BD4_DRY=1 for a dry run in a scratch worktree detached at bd4-design: nothing is committed
set -u
R=$1; LOG=$2
K=$(cd "$(dirname "$0")" && pwd)
PKG=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
F=("$PKG/Becoming.lean" "$PKG/check_becoming.py" "$PKG/README.md" "$PKG/README.zh.md"
   theories/becoming/results/data/regions.json
   theories/becoming/results/records/balance-from-conservation-along-a-relation.json
   theories/becoming/chapters/01-ROOT.md)
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
if [ "${BD4_DRY:-}" = 1 ]; then [ -z "$(git branch --show-current)" ]; else [ "$(git branch --show-current)" = bd4-design ]; fi
step branch $?
[ -z "$(git status --porcelain --untracked-files=no)" ]; step clean $?
mkdir -p "$LOG"
git rev-parse main > "$LOG/main-at-merge.txt"
git merge --no-commit --no-ff main > "$LOG/merge.log" 2>&1
echo "== merge: exit $? (a conflict in the seven files is resolved below)"
git diff --name-only --diff-filter=U > "$LOG/conflicts.txt"
others=$(grep -vxF -f <(printf '%s\n' "${F[@]}") "$LOG/conflicts.txt")
[ -z "$others" ]; step "no conflict outside the seven${others:+: $others}" $?
git checkout main -- "${F[@]}"; step take-main $?
python3 -B "$K/apply_bd4.py" "$R" 48 43 > "$LOG/apply.log" 2>&1; step apply $?
git add -- "${F[@]}"; step add $?
! git grep -n -E '^(<<<<<<<|>>>>>>>|=======)( |$)' -- "${F[@]}" "$PKG/Becoming/BalanceRegions.lean"
step no-markers $?
python3 -B tools/research/research.py check > "$LOG/check.log" 2>&1
python3 - "$LOG/check.log" <<'PY'
import json, sys
t = open(sys.argv[1], encoding='utf-8').read()
j = json.loads(t[:t.rindex('}') + 1])
other = [e for e in j['errors'] if not ('PENDING' in e or 'alias not elaborated' in e)]
print('check:', len(j['errors']), 'errors,', len(other), 'beyond the receipt not yet run; drift', j['source_drift'])
sys.exit(1 if other or j['source_drift'] else 0)
PY
step check-only-pending $?
if [ "${BD4_DRY:-}" = 1 ]; then echo "== dry run: merged and applied, nothing committed"; exit 0; fi
git commit -q -m "Merge branch 'main' into bd4-design: main's changes to the seven files BD4's texts go in are kept, the texts applied again on them by the kit, BD4's history note after main's; the leaf merged as git merges it"
step commit $?
git log --oneline -1 | cut -c1-120
