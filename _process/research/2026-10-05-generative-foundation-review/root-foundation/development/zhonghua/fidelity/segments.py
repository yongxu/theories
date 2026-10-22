"""The fidelity count (FC1; FIDELITY.md §2–§4): the segments to code, their keys, candidates and packets.

Segments (each a wording judged against L(D), the union of the Lean statements it states):
  jing    a 條's 經 clauses that the final alignment assigns to declaration d; D = every declaration those clauses state
  en      the primary E1 clause of (條, d); D = the declarations it cites, resolved in the 條's context
  enrec   the laws[].en of a record cited in the 證 whose law names d; D = that law's declarations
  zhrec   the same law's laws[].zh
  shuo    a 條's 說 with quotations (「…」〔…〕) and sentences carrying a reading (讀（AI…）) removed; D = the 證
A pair (條, d) is scored where it has a jing and an en segment. The key (table pass only): for Chinese, each name of
the name table found in the segment with its adopted sense (所名) and anchors, and the not-adopted words found; for
English, each glossary term (§10 (a), (b)) found with its meaning and anchors. Candidates (both passes) are spans
only: names and terms found, agent-lexicon hits, variables and numerals. X_anchor: names or terms in the segment whose
anchors miss L(D) (a screening statistic). Packets: one language per packet, shuffled, N segments each.

    python3 -I fidelity/segments.py build              # needs data/align_final.json
    python3 -I fidelity/segments.py packets PASS SET N   # PASS table|naive; SET calib|main; writes data/packets/
"""
import csv, json, random, re, sys
from collections import defaultdict
from pathlib import Path

HERE = Path(__file__).resolve().parent
KIT = HERE.parent
ROOT = KIT.parents[5]
DATA = HERE / 'data'
sys.path.insert(0, str(KIT / 'work'))
from simplify import simp  # noqa: E402

EN = ROOT / 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
AGENT_ZH = ['君子', '知者', '圣人', '智者', '学者', '人', '我', '吾', '己', '求', '欲', '意', '谋', '择者', '读者', '观者']
AGENT_EN = ['we', 'us', 'our', 'one', 'someone', 'anyone', 'observer', 'learner', 'agent', 'reader', 'person',
            'people', 'who', 'seeks', 'wants', 'chooses', 'knows', 'intends', 'decides', 'tries', 'tests', 'owner']


def load(name):
    return [json.loads(l) for l in open(DATA / name, encoding='utf-8')]


def name_rows():
    rows = list(csv.DictReader(open(KIT / 'work/names-decisions.tsv', encoding='utf-8'), delimiter='\t'))
    out = []
    for r in rows:
        anchors = sorted({('Becoming.' + a.strip()) if not a.strip().startswith(('Becoming.', 'Generative.')) else a.strip()
                          for a in r['锚'].split('；') if a.strip() not in ('', '—')})
        out.append({'name': simp(r['名']), 'sense': r['所名'], 'anchors': anchors})
    na = list(csv.DictReader(open(KIT / 'work/symbols-not-adopted.tsv', encoding='utf-8'), delimiter='\t'))
    for r in na:
        out.append({'name': simp(r['字']), 'sense': '（不采为名）' + r['理由'][:120], 'anchors': []})
    out.sort(key=lambda x: -len(x['name']))
    return out


def glossary():
    lines = EN.read_text(encoding='utf-8').split('\n')
    out, mode = [], None
    for line in lines:
        if line.startswith('### (a) Core terms'):
            mode = 'a'
        elif line.startswith('### (b) Index of formal terms'):
            mode = 'b'
        elif line.startswith('### (c)'):
            mode = None
        if mode and line.startswith('| ') and not line.startswith('| Term') and not line.startswith('|---'):
            cells = [c.strip() for c in line.strip('|').split(' | ')]
            if mode == 'a' and len(cells) >= 4:
                terms, meaning, anchor = cells[0], cells[2], cells[3]
            elif mode == 'b' and len(cells) >= 3:
                terms, meaning, anchor = re.sub(r'\s*\([^)]*\)$', '', cells[0]), cells[1], cells[2]
            else:
                continue
            anchors = sorted({('Becoming.' + a) if not a.startswith(('Becoming.', 'Generative.')) else a
                              for a in re.findall(r'`([^`]+)`', anchor)})
            for term in re.split(r'[;,/]\s*|:\s*', re.sub(r'\([^)]*\)', '', terms)):
                term = term.strip().lower()
                if len(term) > 2:
                    out.append({'term': term, 'meaning': meaning[:200], 'anchors': anchors})
    out.sort(key=lambda x: -len(x['term']))
    return out


def find_names(text, rows):
    found, used = [], [False] * len(text)
    for r in rows:
        for m in re.finditer(re.escape(r['name']), text):
            if not any(used[m.start():m.end()]):
                found.append(r)
                for i in range(m.start(), m.end()):
                    used[i] = True
                break
    return found


def find_terms(text, gl):
    low, found, used = text.lower(), [], [False] * len(text)
    for g in gl:
        for m in re.finditer(r'\b' + re.escape(g['term']) + r'(?:s|es|ed|d)?\b', low):
            if not any(used[m.start():m.end()]):
                found.append(g)
                for i in range(m.start(), m.end()):
                    used[i] = True
                break
    return found


def lean_form(L, limit=300, max_unfold=8):
    def cut(s):
        return s if len(s) <= limit else s[:limit] + ' …'
    return {'decl': L['decl'], 'kind': L['kind'],
            'binders': [{'name': b['name'], 'type': cut(b['type']), 'sort': b['sort'], 'role': b['role']}
                        for b in L['binders']],
            'conclusion': cut(L['conclusion']),
            'nested': [{'q': n['q'], 'name': n['name'], 'type': cut(n['type'])} for n in L['nested']],
            'unfold1': [{'const': u['const'], 'kind': u.get('kind'),
                         'binders': ['%s : %s' % (b['name'], cut(b['type'])) for b in u.get('binders', [])],
                         'body': cut(u.get('body', '')) if u.get('body') else None,
                         'fields': ['%s : %s' % (f['field'], cut(f['type'])) for f in u.get('fields', [])] or None}
                        for u in L['unfold1'][:max_unfold]]}


def strip_shuo(s):
    s = re.sub(r'「[^」]*」〔[^〕]*〕', '', s)
    s = re.sub(r'`[^`]*`', '', s)
    parts = re.split(r'(?<=。)', s)
    return ''.join(p for p in parts if '讀（AI' not in p and '讀，AI' not in p).strip()


def build():
    L = {d['decl']: d for d in load('lean_table.jsonl')}
    tiao = {t['id']: t for t in load('tiao.jsonl')}
    props = {r['tiao']: r for r in load('align_proposal.jsonl')}
    final = json.loads((DATA / 'align_final.json').read_text())
    pairs = load('pairs.jsonl')
    rows, gl = name_rows(), glossary()
    segs, units = {}, []

    def seg(kind, lang, text, D, tid):
        key = (kind, text, tuple(sorted(D)))
        sid = segs.get(key, {}).get('seg_id')
        if not sid:
            sid = '%s%04d' % (kind, sum(1 for k in segs if k[0] == kind))
            if lang == 'zh':
                names = find_names(text, rows)
                keyinfo = [{'name': n['name'], 'sense': n['sense'], 'anchors': n['anchors']} for n in names]
                agents = [w for w in AGENT_ZH if w in text]
                anch = [a for n in names for a in n['anchors']]
            else:
                terms = find_terms(text, gl)
                keyinfo = [{'term': g['term'], 'meaning': g['meaning'], 'anchors': g['anchors']} for g in terms]
                agents = [w for w in AGENT_EN if re.search(r'\b' + w + r'\b', text.lower())]
                anch = [a for g in terms for a in g['anchors']]
            reach = set(D) | {c for d in D if d in L for c in L[d]['consts']} | \
                {u['const'] for d in D if d in L for u in L[d]['unfold1']}
            x_anchor = sum(1 for k in keyinfo if k['anchors'] and not (set(k['anchors']) & reach))
            segs[key] = {'seg_id': sid, 'kind': kind, 'lang': lang, 'tiao': tid, 'text': text, 'D': sorted(D),
                         'key': keyinfo, 'candidates': sorted({(k.get('name') or k.get('term')) for k in keyinfo} | set(agents)),
                         'x_anchor': x_anchor}
        return segs[key]['seg_id']

    stats = defaultdict(int)
    for p in pairs:
        if not p['e1'] or p['tiao'] not in final:
            continue
        t, d = tiao[p['tiao']], p['decl']
        fa = final[p['tiao']]
        cl = [int(j) for j, ds in fa.items() if ds and d in ds]
        if not cl:
            stats['no_jing_clause'] += 1
            continue
        cl.sort()
        text = ''.join(props[p['tiao']]['clauses'][j - 1] for j in cl)
        D = sorted({x for j in cl for x in fa[str(j)] if x in L})
        u = {'tiao': p['tiao'], 'decl': d, 'pian': p['pian'], 'calibration': props[p['tiao']]['calibration'],
             'flags': t['flags'],
             'jing': seg('jing', 'zh', text, D, p['tiao']),
             'en': seg('en', 'en', p['e1']['text'], [x for x in p['e1']['cites_in_context'] if x in L], p['tiao'])}
        if p['e2']:
            law = p['e2'][0]
            Dl = [x for x in law['declarations'] if x in L]
            if law.get('en'):
                u['enrec'] = seg('enrec', 'en', law['en'], Dl, p['tiao'])
            if law.get('zh'):
                u['zhrec'] = seg('zhrec', 'zh', law['zh'], Dl, p['tiao'])
        sh = strip_shuo(t['shuo'])
        if sh:
            u['shuo'] = seg('shuo', 'zh', sh, [x for x in t['decls'] if x in L], p['tiao'])
        units.append(u)
        stats['units'] += 1
    S = sorted(segs.values(), key=lambda s: s['seg_id'])
    with open(DATA / 'segments.jsonl', 'w', encoding='utf-8') as f:
        for s in S:
            f.write(json.dumps(s, ensure_ascii=False) + '\n')
    with open(DATA / 'units.jsonl', 'w', encoding='utf-8') as f:
        for u in units:
            f.write(json.dumps(u, ensure_ascii=False) + '\n')
    count = defaultdict(int)
    for s in S:
        count[s['kind']] += 1
    print(json.dumps({**stats, 'segments': dict(count), 'calibration_units': sum(u['calibration'] for u in units)}))


def packets(pass_, which, n):
    L = {d['decl']: d for d in load('lean_table.jsonl')}
    units = load('units.jsonl')
    S = {s['seg_id']: s for s in load('segments.jsonl')}
    want = defaultdict(set)
    kinds = ('jing', 'en') if pass_ == 'naive' else ('jing', 'en', 'enrec', 'zhrec', 'shuo')
    for u in units:
        if u['calibration'] != (which == 'calib'):
            continue
        for k in kinds:
            if k in u:
                want[S[u[k]]['lang']].add(u[k])
    out = DATA / 'packets' / ('%s_%s' % (pass_, which))
    out.mkdir(parents=True, exist_ok=True)
    for old in out.glob('*.json'):
        old.unlink()
    total = 0
    for lang in ('zh', 'en'):
        ids = sorted(want[lang])
        random.Random('%s-%s-%s' % (pass_, which, lang)).shuffle(ids)
        for j in range(0, len(ids), n):
            items = []
            for sid in ids[j:j + n]:
                s = S[sid]
                item = {'seg_id': sid, 'language': 'classical Chinese' if lang == 'zh' else 'English',
                        'text': s['text'], 'candidates': s['candidates'],
                        'lean': [lean_form(L[d]) for d in s['D'] if d in L]}
                if pass_ == 'table':
                    item['key'] = s['key']
                items.append(item)
            (out / ('%s_%s_%03d.json' % (pass_, lang, j // n))).write_text(
                json.dumps({'pass': pass_.upper(), 'segments': items}, ensure_ascii=False, indent=1))
            total += 1
    print(total, 'packets in', out)


if __name__ == '__main__':
    if sys.argv[1] == 'build':
        build()
    else:
        packets(sys.argv[2], sys.argv[3], int(sys.argv[4]))
