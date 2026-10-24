"""ZE step 4: the controlled English (CE) segments, their keys, the GPT sample and the coding packets.

For every 經 segment of FC1 (fidelity/data/segments.jsonl, kind jing), the CE segment is the controlled English of the
same clauses of the same 條 (FC1's final alignment), against the same declarations D. Its key (table pass) is each name
of the English name table found in it (longest first, whole words, an English inflection allowed), with the sense
taken and the anchors, in the fields FC1 gives an English key (term, meaning, anchors); candidates are the names found
and the FC1 agent-lexicon hits. The GPT sample: 60 main-set pairs, one per 經 segment, stratified by 篇 (largest
remainder, fixed seed); for each, its 經 and its CE segment.

    python3 -I segments_ce.py build            # writes data/ce_segments.jsonl, data/ce_units.jsonl, data/gpt_sample.json
    python3 -I segments_ce.py packets N        # writes data/packets/{ce_main,ce_calib,gpt_zh,gpt_ce}/
"""
import csv, json, random, re, sys
from collections import defaultdict
from pathlib import Path

HERE = Path(__file__).resolve().parent
FID = HERE.parent / 'zhonghua' / 'fidelity'
FD = FID / 'data'
DATA = HERE / 'data'
sys.path.insert(0, str(FID))
import segments as G  # noqa: E402

SEED = 'ZE-20261023'
N_GPT = 60


def table():
    rows = list(csv.DictReader(open(HERE / 'names-en.tsv', encoding='utf-8'), delimiter='\t'))
    out = []
    for r in rows:
        anchors = sorted({('Becoming.' + a.strip()) if not a.strip().startswith(('Becoming.', 'Generative.')) else a.strip()
                          for a in r['锚'].split('；') if a.strip() not in ('', '—')})
        out.append({'term': r['name_en'].strip().lower(), 'name': r['name_en'], 'meaning': r['sense_en'][:200],
                    'anchors': anchors})
    out.sort(key=lambda x: -len(x['term']))
    return out


def find_names(text, tab):
    low, found, used = text.lower(), [], [False] * len(text)
    for g in tab:
        for m in re.finditer(r'\b' + re.escape(g['term']) + r'(?:s|es|ed|d|ing)?\b', low):
            if not any(used[m.start():m.end()]):
                found.append(g)
                for i in range(m.start(), m.end()):
                    used[i] = True
                break
    return found


def build():
    L = {d['decl']: d for d in G.load('lean_table.jsonl')}
    S = {s['seg_id']: s for s in G.load('segments.jsonl')}
    units = G.load('units.jsonl')
    final = json.loads((FD / 'align_final.json').read_text())
    ce = {r['tiao']: r for r in (json.loads(l) for l in open(HERE / 'controlled-english.jsonl', encoding='utf-8'))}
    tab = table()
    segs, cunits = {}, []
    for u in units:
        js = S[u['jing']]
        cl = sorted(int(j) for j, ds in final[u['tiao']].items() if ds and u['decl'] in ds)
        zh = ''.join(ce[u['tiao']]['clauses'][j - 1]['zh'] for j in cl)
        assert zh == js['text'], (u['tiao'], u['decl'])
        if u['jing'] not in segs:
            text = ' '.join(ce[u['tiao']]['clauses'][j - 1]['en'] for j in cl)
            names = find_names(text, tab)
            agents = [w for w in G.AGENT_EN if re.search(r'\b' + w + r'\b', text.lower())]
            reach = set(js['D']) | {c for d in js['D'] if d in L for c in L[d]['consts']} | \
                {x['const'] for d in js['D'] if d in L for x in L[d]['unfold1']}
            segs[u['jing']] = {'seg_id': 'ce' + u['jing'][4:], 'kind': 'ce', 'lang': 'en', 'tiao': u['tiao'],
                               'jing': u['jing'], 'clauses': cl, 'text': text, 'D': js['D'],
                               'key': [{'term': g['name'], 'meaning': g['meaning'], 'anchors': g['anchors']} for g in names],
                               'candidates': sorted({g['name'] for g in names} | set(agents)),
                               'x_anchor': sum(1 for g in names if g['anchors'] and not (set(g['anchors']) & reach))}
        cunits.append({k: u[k] for k in ('tiao', 'decl', 'pian', 'calibration', 'flags', 'jing', 'en')}
                      | {'ce': segs[u['jing']]['seg_id']})
    with open(DATA / 'ce_segments.jsonl', 'w', encoding='utf-8') as f:
        for s in sorted(segs.values(), key=lambda s: s['seg_id']):
            f.write(json.dumps(s, ensure_ascii=False) + '\n')
    with open(DATA / 'ce_units.jsonl', 'w', encoding='utf-8') as f:
        for u in cunits:
            f.write(json.dumps(u, ensure_ascii=False) + '\n')
    # the GPT sample: main-set 經 segments (one pair each), stratified by 篇, largest remainder
    main = [u for u in cunits if not u['calibration']]
    by = defaultdict(list)
    for u in main:
        if u['jing'] not in [x['jing'] for x in by[u['pian']]]:
            by[u['pian']].append(u)
    total = sum(len(v) for v in by.values())
    quota = {p: N_GPT * len(v) / total for p, v in by.items()}
    alloc = {p: int(q) for p, q in quota.items()}
    for p in sorted(quota, key=lambda p: -(quota[p] - alloc[p]))[:N_GPT - sum(alloc.values())]:
        alloc[p] += 1
    rnd = random.Random(SEED)
    sample = []
    for p in sorted(by):
        v = sorted(by[p], key=lambda u: u['jing'])
        sample += rnd.sample(v, alloc[p])
    (DATA / 'gpt_sample.json').write_text(json.dumps({'seed': SEED, 'allocation': alloc,
                                                      'units': [{'tiao': u['tiao'], 'decl': u['decl'], 'jing': u['jing'],
                                                                 'ce': u['ce']} for u in sample]},
                                                     ensure_ascii=False, indent=1))
    print(json.dumps({'ce_segments': len(segs), 'units': len(cunits), 'main_ce': len({u['ce'] for u in main}),
                      'gpt_sample': len(sample), 'gpt_tiao': len({u['tiao'] for u in sample})}))


def packets(n):
    L = {d['decl']: d for d in G.load('lean_table.jsonl')}
    S = {s['seg_id']: s for s in G.load('segments.jsonl')}
    C = {s['seg_id']: s for s in (json.loads(l) for l in open(DATA / 'ce_segments.jsonl', encoding='utf-8'))}
    cunits = [json.loads(l) for l in open(DATA / 'ce_units.jsonl', encoding='utf-8')]
    smp = json.loads((DATA / 'gpt_sample.json').read_text())['units']

    def item(s, lang):
        return {'seg_id': s['seg_id'], 'language': 'classical Chinese' if lang == 'zh' else 'English', 'text': s['text'],
                'candidates': s['candidates'], 'lean': [G.lean_form(L[d]) for d in s['D'] if d in L], 'key': s['key']}

    sets = {'ce_main': ('en', sorted({u['ce'] for u in cunits if not u['calibration']}), C),
            'ce_calib': ('en', sorted({u['ce'] for u in cunits if u['calibration']}), C),
            'gpt_zh': ('zh', sorted({u['jing'] for u in smp}), S),
            'gpt_ce': ('en', sorted({u['ce'] for u in smp}), C)}
    for name, (lang, ids, src) in sets.items():
        out = DATA / 'packets' / name
        out.mkdir(parents=True, exist_ok=True)
        for old in out.glob('*.json'):
            old.unlink()
        random.Random('%s-%s' % (SEED, name)).shuffle(ids)
        k = 0
        for j in range(0, len(ids), n):
            (out / ('%s_%03d.json' % (name, j // n))).write_text(json.dumps(
                {'pass': 'TABLE', 'segments': [item(src[s], lang) for s in ids[j:j + n]]}, ensure_ascii=False, indent=1))
            k += 1
        print(name, len(ids), 'segments,', k, 'packets')


if __name__ == '__main__':
    if sys.argv[1] == 'build':
        build()
    else:
        packets(int(sys.argv[2]))
