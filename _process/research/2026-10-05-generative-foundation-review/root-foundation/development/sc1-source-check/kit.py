"""SC1 kit: author packets, texts, blind coding packets, and the pre-registered analysis (DESIGN.md).

    python3 -I sc1-source-check/kit.py author_packets   # data/laws.jsonl -> data/author_packets/author_{0,1}.json
    python3 -I sc1-source-check/kit.py texts            # data/authored/{claude,gpt}/ -> data/texts.jsonl (+ checks)
    python3 -I sc1-source-check/kit.py code_packets     # data/texts.jsonl -> data/code_packets/code_XX.json (blind)
    python3 -I sc1-source-check/kit.py analyze          # data/coded/{claude,gpt}/ -> results.json, results.md
"""
import hashlib, json, random, re, sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
DATA = HERE / 'data'
AUTHORS = ['claude', 'gpt']
CODERS = ['claude', 'gpt']
VERSIONS = ['faithful', 'planted']
B = 10000
STOP = set('a an the of to in on at by for and or not no is are be its it as that this which with from if only when '
           'than then there every any some each all one its their his her'.split())


def load(p):
    return [json.loads(l) for l in open(p, encoding='utf-8')]


def toks(s):
    return re.findall(r"[a-z][a-z'\-]*", s.lower())


def author_packets():
    laws = load(DATA / 'laws.jsonl')
    order = list(range(len(laws)))
    random.Random('SC1-author').shuffle(order)
    out = DATA / 'author_packets'
    out.mkdir(parents=True, exist_ok=True)
    for k in range(2):
        items = [{'law': laws[i]['law'], 'plant_class': laws[i]['plant_class'], 'lean': [laws[i]['lean']]}
                 for i in order[k * 30:(k + 1) * 30]]
        (out / ('author_%d.json' % k)).write_text(json.dumps({'laws': items}, ensure_ascii=False, indent=1))
    print('2 author packets of 30')


def texts():
    laws = {l['law']: l for l in load(DATA / 'laws.jsonl')}
    rows, problems = [], []
    for a in AUTHORS:
        got = {}
        for p in sorted((DATA / 'authored' / a).glob('author_*.json')):
            for x in json.loads(p.read_text())['laws']:
                got[x['law']] = x
        for lid, law in laws.items():
            x = got.get(lid)
            if not x:
                problems.append((a, lid, 'missing'))
                continue
            span, head = x['planted_span'], x['planted_head']
            ok = span and span in x['planted'] and head.lower() in toks(span)
            ft = toks(x['faithful'])
            new = [t for t in toks(span) if t not in ft and t not in STOP] or [head.lower()]
            # changes outside the span: planted tokens (span removed) that the faithful text lacks
            rest = toks(x['planted'].replace(span, ' ', 1)) if ok else toks(x['planted'])
            extra = [t for t in rest if t not in ft]
            if not ok:
                problems.append((a, lid, 'span not in planted or head not in span'))
            for v in VERSIONS:
                tid = 't' + hashlib.sha1(('SC1|%s|%s|%s' % (lid, a, v)).encode()).hexdigest()[:6]
                rows.append({'tid': tid, 'law': lid, 'author': a, 'version': v, 'text': x[v],
                             'plant_class': law['plant_class'] if v == 'planted' else None,
                             'planted_span': span if v == 'planted' else None,
                             'planted_head': head if v == 'planted' else None,
                             'new_tokens': new if v == 'planted' else None,
                             'extra_changes': extra if v == 'planted' else None,
                             'plant_valid': bool(ok) if v == 'planted' else None})
    with open(DATA / 'texts.jsonl', 'w', encoding='utf-8') as f:
        for r in rows:
            f.write(json.dumps(r, ensure_ascii=False) + '\n')
    n_extra = sum(1 for r in rows if r['version'] == 'planted' and len(r['extra_changes'] or []) > 2)
    print(len(rows), 'texts;', len(problems), 'problems', problems[:10], ';', n_extra,
          'planted texts with more than 2 changed tokens outside the span')


def code_packets():
    rows = load(DATA / 'texts.jsonl')
    laws = {l['law']: l for l in load(DATA / 'laws.jsonl')}
    lids = sorted(laws)
    sets = {s: [] for s in range(6)}
    rng = random.Random('SC1-sets')
    for i, lid in enumerate(lids):
        mine = [r for r in rows if r['law'] == lid]
        rng.shuffle(mine)
        for k, r in enumerate(mine):          # four texts of a law go to four different sets
            sets[(i + k) % 6].append(r)
    out = DATA / 'code_packets'
    out.mkdir(parents=True, exist_ok=True)
    for s, items in sets.items():
        random.Random('SC1-pack-%d' % s).shuffle(items)
        for h in range(2):
            part = items[h * 20:(h + 1) * 20]
            segs = [{'seg_id': r['tid'], 'language': 'English', 'text': r['text'], 'candidates': [],
                     'lean': [laws[r['law']]['lean']], 'key': []} for r in part]
            (out / ('code_%02d.json' % (2 * s + h))).write_text(
                json.dumps({'pass': 'TABLE', 'segments': segs}, ensure_ascii=False, indent=1))
    print({s: len(v) for s, v in sets.items()})


def coded():
    got = {}
    for c in CODERS:
        for p in sorted((DATA / 'coded' / c).glob('code_*.json')):
            for s in json.loads(p.read_text())['segments']:
                got[(c, s['seg_id'])] = s
    return got


def score(rows, got):
    """per text and coder: X (excess referents), hit (an excess referent on the plant), X outside the plant"""
    out = []
    for r in rows:
        for c in CODERS:
            s = got.get((c, r['tid']))
            if s is None:
                continue
            ex = [x for x in s['referents'] if x['status'] == 'excess']
            hits = []
            if r['version'] == 'planted':
                want = set(r['new_tokens']) | {r['planted_head'].lower()}
                hits = [x for x in ex if set(toks(x['span'])) & want]
            out.append({'law': r['law'], 'author': r['author'], 'version': r['version'], 'coder': c,
                        'X': len(ex), 'A': sum(x['class'] == 'A' for x in ex), 'R': sum(x['class'] == 'R' for x in ex),
                        'E': sum(x['class'] == 'E' for x in ex), 'hit': int(bool(hits)) if r['version'] == 'planted' else None,
                        'X_out': len(ex) - len(hits), 'valid': r['plant_valid'], 'cls': r['plant_class']})
    return out


def cells(sc, laws, measure, version, keep=lambda s: True):
    m = {}
    for a in AUTHORS:
        for c in CODERS:
            v = [s[measure] for l in laws for s in sc.get(l, []) if s['author'] == a and s['coder'] == c
                 and s['version'] == version and keep(s)]
            m[(a, c)] = sum(v) / len(v) if v else float('nan')
    return m


def contrasts(m):
    s_claude = m[('claude', 'claude')] - m[('gpt', 'claude')]     # coder Claude: own texts minus the other's
    s_gpt = m[('gpt', 'gpt')] - m[('claude', 'gpt')]              # coder GPT: own texts minus the other's
    coder = (m[('claude', 'gpt')] + m[('gpt', 'gpt')] - m[('claude', 'claude')] - m[('gpt', 'claude')]) / 2
    author = (m[('claude', 'claude')] + m[('claude', 'gpt')] - m[('gpt', 'claude')] - m[('gpt', 'gpt')]) / 2
    return {'interaction': s_claude + s_gpt, 'self_claude': s_claude, 'self_gpt': s_gpt,
            'coder_gpt_minus_claude': coder, 'author_claude_minus_gpt': author}


def boot(sc, measure, version, keep=lambda s: True):
    laws = sorted(sc)
    m = cells(sc, laws, measure, version, keep)
    est = contrasts(m)
    rng = random.Random('SC1-boot')
    draws = {k: [] for k in est}
    for _ in range(B):
        bl = [rng.choice(laws) for _ in laws]
        sc_b = {}
        for i, l in enumerate(bl):
            sc_b[(l, i)] = sc[l]
        c = contrasts(cells(sc_b, list(sc_b), measure, version, keep))
        for k, v in c.items():
            if v == v:
                draws[k].append(v)
    ci = {}
    for k, v in draws.items():
        v.sort()
        ci[k] = [v[int(0.025 * len(v))], v[int(0.975 * len(v)) - 1]]
    return {'cells': {'%s-text/%s-coder' % k: v for k, v in m.items()}, 'contrasts': est, 'ci95': ci,
            'n_laws': len(laws)}


def verdict(ci, lo_word, hi_word):
    a, b = ci
    return lo_word if b < 0 else hi_word if a > 0 else 'interval includes 0'


def analyze():
    rows = load(DATA / 'texts.jsonl')
    got = coded()
    sc_list = score(rows, got)
    sc = {}
    for s in sc_list:
        sc.setdefault(s['law'], []).append(s)
    valid = lambda s: s['valid'] is not False
    res = {'n_texts': len(rows), 'n_codings': len(sc_list),
           'missing': [(c, r['tid']) for r in rows for c in CODERS if (c, r['tid']) not in got],
           'P1_detection': boot(sc, 'hit', 'planted', valid),
           'P2_X_faithful': boot(sc, 'X', 'faithful'),
           'S1_X_outside_plant': boot(sc, 'X_out', 'planted', valid)}
    by_cls = {}
    for k in ['A', 'R', 'E']:
        by_cls[k] = {'%s-text/%s-coder' % (a, c): v for (a, c), v in
                     cells(sc, sorted(sc), 'hit', 'planted', lambda s, k=k: valid(s) and s['cls'] == k).items()}
    res['S2_detection_by_class'] = by_cls
    res['S3_classes_faithful'] = {k: {'%s-text/%s-coder' % (a, c): v for (a, c), v in
                                      cells(sc, sorted(sc), k, 'faithful').items()} for k in ['A', 'R', 'E']}
    res['S4_texts_with_any_excess_faithful'] = {
        '%s-text/%s-coder' % (a, c): sum(1 for s in sc_list if s['version'] == 'faithful' and s['author'] == a
                                          and s['coder'] == c and s['X'] > 0) for a in AUTHORS for c in CODERS}
    res['decision'] = {
        'R1_blind_spot_on_plants': verdict(res['P1_detection']['ci95']['interaction'],
                                           'self-detection deficit', 'self-detection advantage'),
        'R2_blind_spot_on_unplanted_excess': verdict(res['P2_X_faithful']['ci95']['interaction'],
                                                     'self-detection deficit', 'self-detection advantage'),
        'R3_coder_effect_detection': verdict(res['P1_detection']['ci95']['coder_gpt_minus_claude'],
                                             'GPT coder detects fewer plants', 'Claude coder detects fewer plants'),
        'R3_coder_effect_X_faithful': verdict(res['P2_X_faithful']['ci95']['coder_gpt_minus_claude'],
                                              'GPT coder finds less', 'GPT coder finds more'),
        'ceiling': all(v >= 0.95 for v in res['P1_detection']['cells'].values())}
    (HERE / 'results.json').write_text(json.dumps(res, ensure_ascii=False, indent=1))
    print(json.dumps({k: res[k] for k in ['n_texts', 'n_codings', 'decision']}, indent=1))
    for k in ['P1_detection', 'P2_X_faithful', 'S1_X_outside_plant']:
        print(k, json.dumps(res[k]['cells']), '\n ', json.dumps(res[k]['contrasts']), '\n ', json.dumps(res[k]['ci95']))


if __name__ == '__main__':
    {'author_packets': author_packets, 'texts': texts, 'code_packets': code_packets, 'analyze': analyze}[sys.argv[1]]()
