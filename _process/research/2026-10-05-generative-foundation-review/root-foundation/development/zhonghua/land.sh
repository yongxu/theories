#!/bin/sh
# ZH landing, docs and records only (no Lean, no checker run): from the worktree root, on a branch rebased onto main.
#   sh land.sh STUDY_SECTION D_NUMBER
# 1. number the readings of this edition marked without a decision (global replacement, recorded), re-run the finish
#    step; 2. study section and decision (both registers); 3. the record; 4. render; 5. check, re-pointing only the
#    records whose drift is this landing's own edits (study, decision registers, the RO chapter, SOURCES); 6. links,
#    test; the board move is done by board_move.py with the state cell, after the commit hash is known for the note.
set -e
K=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/zhonghua
S=$1; D=$2
python3 -I - "$K" "$D" <<'EOF'
import json, sys
k, d = sys.argv[1], sys.argv[2]
p = k + '/work/global-replacements.json'
g = [x for x in json.load(open(p, encoding='utf-8')) if not x.get('readings')]
why = 'readings of the 中华本 not under an earlier decision are adopted by D%s' % d
g += [{'find': '讀（AI）', 'replace': '讀（AI，D%s）' % d, 'why': why, 'readings': True},
      {'find': '讀，AI）', 'replace': '讀，AI，D%s）' % d, 'why': why, 'readings': True}]
json.dump(g, open(p, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
EOF
python3 -I $K/finish.py | grep -v 'periphery:\|losing content'
python3 -I $K/landing_texts.py "$S" "$D"
python3 -I $K/make_record.py "$S" "$D"
make research-render
D_JSON=$(mktemp)
python3 -B tools/research/research.py check > "$D_JSON" 2>/dev/null || true
python3 -I - "$D_JSON" <<'EOF'
import json, sys
d = json.load(open(sys.argv[1]))
print('errors:', d['errors'])
print('drift:', sorted({x.get('id') or x.get('record') for x in d['source_drift']}))
EOF
echo "check $D_JSON"
