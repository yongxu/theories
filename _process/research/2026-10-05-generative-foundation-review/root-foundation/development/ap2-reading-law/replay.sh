#!/bin/zsh
# AP2: replay the landing from the kit on current main: the work, receipt and kit commits rebased, then the text,
# records, re-point, pages and the landing commit rebuilt, and main fast-forwarded if it has not moved.
# usage (from the checkout root, with HEAD at the kit commit): zsh replay.sh
set -e
K=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ap2-reading-law
RF=_process/research/2026-10-05-generative-foundation-review/root-foundation
R=theories/becoming/results/records
RC=20261021T111912.398950Z
T=$(mktemp -d)
git rebase main > $T/rebase.log 2>&1
python3 -B $K/apply_text.py $RC $K/connectivity.log c03c85f00 "one new apart root, Weighting.increasing_lexical, registered as general structure; none in Becoming.SelectionPool" > $K/apply.log 2>&1
N=$(grep -o "STUDY_SECTION [0-9]*" $K/apply.log | grep -o "[0-9]*")
echo "section $N"
python3 -B $K/make_record.py $RC $N
git commit -q -m "AP2 docs (work in progress)" -- _process/BECOMING-WORKBOARD.md _process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md $RF/BECOMING-RENEWAL-READING.md theories/becoming/chapters/THE-STEP-OF-INVARIANCE.md theories/becoming/chapters/THE-THEORY-OF-BECOMING.md theories/becoming/chapters/THE-THEORY-OF-BECOMING.zh.md $R/reading-anothers-couplings-is-pooling.json $R/widening-as-what-every-weighting-ranks.json
python3 -B tools/research/research.py check > $T/drift.json 2>/dev/null || true
python3 - $T/drift.json <<'PY'
import json, sys
t = open(sys.argv[1]).read(); d = json.loads(t[t.index('{'):t.rindex('}') + 1])
mine = {'THE-THEORY-OF-BECOMING.md', 'THE-STEP-OF-INVARIANCE.md', 'SelectionPool.lean', 'Weightings.lean', 'BECOMING-RENEWAL-READING.md'}
other = [(x['id'], x['path']) for x in d['source_drift'] if x['path'].rsplit('/', 1)[-1] not in mine]
print('drift outside AP2 sources:', other)
d['source_drift'] = [x for x in d['source_drift'] if x['path'].rsplit('/', 1)[-1] in mine]
open(sys.argv[1], 'w').write(json.dumps(d))
PY
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
python3 -B tools/research/repoint.py --reason "AP2 (reading another's law; lexical priority within the class): Becoming.SelectionPool gained the anticipation laws and Becoming.Weightings lexical priority; the chapter's sections 6.5, 7.3, 7.7, 8.1 item 7 and 9, and THE-STEP-OF-INVARIANCE's sections 5, 6.5 and 8; read before re-pointing" --drift-json $T/drift.json --receipt $P/becoming-checks/$RC/verification.json --lean $P/Becoming/SelectionPool.lean $P/Becoming/Weightings.lean --apply > $K/repoint.log 2>&1
make research-render > $K/research-render.log 2>&1
make research-check > $K/research-check.log 2>&1
make research-links > $K/research-links.log 2>&1 || true
grep -o '"target": "[^"]*"' $K/research-links.log || true
git status --porcelain | sed 's/^...//' > $T/paths.txt
git add --pathspec-from-file=$T/paths.txt
git commit -q --pathspec-from-file=$T/paths.txt -m "AP2 pages"
git reset -q --soft HEAD~2
git commit -q -F $K/landing-message.txt
sed -i '' "s/study section [0-9]*;/study section $N;/" $K/landing-message.txt
git commit -q --amend -F $K/landing-message.txt
if [ "$(git rev-parse main)" = "$(git merge-base main HEAD)" ]; then
  git -C /Users/ren/theories merge --ff-only $(git rev-parse --abbrev-ref HEAD) | tail -1; echo LANDED
else echo "main moved"; fi
