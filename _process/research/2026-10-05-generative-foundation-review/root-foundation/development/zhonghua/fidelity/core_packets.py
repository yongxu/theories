"""FC1 after the scope reduction (ANALYSIS-PLAN.md, amendment): table-pass packets of the main set's 經 (jing) and E1
(en) segments that a coder has not yet coded, one language per packet, shuffled, N segments each.

    python3 -I fidelity/core_packets.py CODER N     # writes data/packets/core_CODER/
"""
import json, random, sys
from pathlib import Path
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import segments as G  # noqa: E402

coder, n = sys.argv[1], int(sys.argv[2])
DATA = HERE / 'data'
L = {d['decl']: d for d in G.load('lean_table.jsonl')}
S = {s['seg_id']: s for s in G.load('segments.jsonl')}
units = [u for u in G.load('units.jsonl') if not u['calibration']]
done = set()
for d in (DATA / 'coded' / coder).glob('table_main*'):
    for p in d.glob('*.json'):
        for s in json.loads(p.read_text())['segments']:
            done.add(s['seg_id'])
want = {'zh': sorted({u['jing'] for u in units} - done), 'en': sorted({u['en'] for u in units} - done)}
out = DATA / 'packets' / ('core_' + coder)
out.mkdir(parents=True, exist_ok=True)
for old in out.glob('*.json'):
    old.unlink()
k = 0
for lang, ids in want.items():
    random.Random('core-%s-%s' % (coder, lang)).shuffle(ids)
    for j in range(0, len(ids), n):
        items = [{'seg_id': sid, 'language': 'classical Chinese' if lang == 'zh' else 'English', 'text': S[sid]['text'],
                  'candidates': S[sid]['candidates'], 'lean': [G.lean_form(L[d]) for d in S[sid]['D'] if d in L],
                  'key': S[sid]['key']} for sid in ids[j:j + n]]
        (out / ('core_%s_%03d.json' % (lang, j // n))).write_text(
            json.dumps({'pass': 'TABLE', 'segments': items}, ensure_ascii=False, indent=1))
        k += 1
print(coder, 'remaining zh', len(want['zh']), 'en', len(want['en']), 'packets', k)
