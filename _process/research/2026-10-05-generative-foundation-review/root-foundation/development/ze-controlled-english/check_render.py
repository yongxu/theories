"""ZE: check rendered 經 against their input batches (or, with no argument, the whole edition against tiao.jsonl).

Fails where a 條 is missing or repeated, where its clauses differ in number or order from the 經, where a clause is
empty, or where English holds Chinese characters outside a 條 id. Reports, without failing: personal or agent words
(the FC1 agent lexicon) and, per batch, the share of name hints whose English name the rendering uses.

    python3 -I check_render.py data/render-output/batch_K.jsonl     # one batch against data/render-input/batch_K.jsonl
    python3 -I check_render.py                                      # every batch against fidelity/data/tiao.jsonl
"""
import json, re, sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
FD = HERE.parent / 'zhonghua' / 'fidelity' / 'data'
AGENT_EN = ['we', 'us', 'our', 'someone', 'anyone', 'observer', 'learner', 'agent', 'reader', 'person', 'people',
            'who', 'wants', 'chooses', 'knows', 'intends', 'decides', 'tries', 'owner']
TIAO_ID = re.compile(r'[凡纲篇〇一二三四五六七八九十百]+·[〇一二三四五六七八九十百]+')
CJK = re.compile(r'[㐀-鿿]')


def load(p):
    return [json.loads(l) for l in open(p, encoding='utf-8')]


def check(inp, out):
    fail, notes = [], []
    got = {}
    for r in out:
        if r['tiao'] in got:
            fail.append('%s: twice' % r['tiao'])
        got[r['tiao']] = r
    hits = uses = 0
    for t in inp:
        tid = t['tiao']
        r = got.get(tid)
        if not r:
            fail.append('%s: missing' % tid)
            continue
        zc = t['clauses']
        ec = r.get('clauses', [])
        if [c['j'] for c in ec] != [c['j'] for c in zc]:
            fail.append('%s: clauses %s, the 經 has %s' % (tid, [c['j'] for c in ec], [c['j'] for c in zc]))
            continue
        for z, e in zip(zc, ec):
            en = (e.get('en') or '').strip()
            if not en:
                fail.append('%s/%d: empty' % (tid, e['j']))
                continue
            if CJK.search(TIAO_ID.sub('', en)):
                fail.append('%s/%d: Chinese characters: %s' % (tid, e['j'], en[:80]))
            words = [w for w in AGENT_EN if re.search(r'\b' + w + r'\b', en.lower())]
            if words:
                notes.append('%s/%d: personal or agent words %s' % (tid, e['j'], words))
            for _, name_en in z.get('names', []):
                hits += 1
                uses += bool(re.search(r'\b' + re.escape(name_en.lower()), en.lower()))
    extra = set(got) - {t['tiao'] for t in inp}
    if extra:
        fail.append('條 not in the input: %s' % sorted(extra)[:10])
    return fail, notes, hits, uses


def main():
    if len(sys.argv) > 1:
        p = Path(sys.argv[1])
        inp = load(HERE / 'data/render-input' / p.name)
        out = load(p)
    else:
        inp = [{'tiao': t['id'], 'clauses': [{'j': j, 'names': []} for j in range(1, len(t['jing_clauses']) + 1)]}
               for t in load(FD / 'tiao.jsonl')]
        out = [r for q in sorted((HERE / 'data/render-output').glob('batch_*.jsonl')) for r in load(q)]
    fail, notes, hits, uses = check(inp, out)
    for x in notes:
        print('note', x)
    for x in fail:
        print('FAIL', x)
    print('%d 條, %d clauses rendered; name hints used %d of %d; %d notes; %s' % (
        len(out), sum(len(r.get('clauses', [])) for r in out), uses, hits, len(notes),
        'FAILED %d' % len(fail) if fail else 'ok'))
    sys.exit(1 if fail else 0)


if __name__ == '__main__':
    main()
