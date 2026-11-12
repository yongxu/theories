# AI-written, 12 November 2026. Freezes the kit's chain (data.py, settled.json, edits.py, last-read.json,
# told-check.json, stories.py, as built by ../build.py) into four clean data files, with the new layout:
# the row on sparing moves into the first band, and the second band is ordered so the lock reads as a ring.
import json, os, re, collections
HERE = os.path.dirname(os.path.abspath(__file__)); KIT = os.path.dirname(HERE)
b = json.load(open(os.path.join(KIT, 'built.json')))
D = json.loads(re.search(r'const D = (\{.*?\});\nconst \$', open(os.path.join(KIT, 'map.html')).read(), re.S).group(1))
items = json.load(open(os.path.join(KIT, 'items.json')))

ROW_ORDER = ['b0', 'a1', 'a2', 'b1', 'b2', 'b3', 'bs', 'c1', 'd0', 'd1', 'd2', 'd3', 'e1', 'e2']
ROW_BAND = {'b0': 'A'}
COL = {'b2.heard': 6, 'bs.costs': 4, 'bs.pays': 5}
WANTED = ['b2.counted', 'b3.rest', 'bs.costs']
WEB = [
  {'en': ['what takes', 'takes from', 'what is lived on'], 'zh': ['取的一方', '取', '所靠的存量'], 'rows': ['b0', 'a1']},
  {'en': ['what gives back', 'gives back to', 'what is lived on'], 'zh': ['补的一方', '补', '所靠的存量'], 'rows': ['a1']},
  {'en': ['what lives on it', 'needs', 'what is lived on'], 'zh': ['靠它延续的', '需要', '所靠的存量'], 'rows': ['a2']},
  {'en': ['what is lived on', 'reaches, or lies beyond', 'a rule'], 'zh': ['所靠的存量', '传得到，或者传不到', '规则'], 'rows': ['b2']},
  {'en': ['a rule', 'picks among, and is set from', 'what it picks among'], 'zh': ['规则', '在它们之间取舍，又由它们来定', '被取舍的'], 'rows': ['b1', 'bs']},
  {'en': ['a rule', 'is set through', 'what counts when it is set'], 'zh': ['规则', '经由它们来定', '定规则时算数的'], 'rows': ['b3']},
  {'en': ['a view', 'is of, and is revised by', 'how things are'], 'zh': ['看法', '说的是它，又照它来改', '实情'], 'rows': ['c1']},
  {'en': ['something that keeps going', 'leans on, gives to, waits on', 'another'], 'zh': ['延续着的', '靠着，给，等', '另一个'], 'rows': ['d0', 'd1']},
  {'en': ['something that keeps going', 'lasts through', 'what carries it'], 'zh': ['延续着的', '靠它们一茬茬传下去', '承载它的'], 'rows': ['d2', 'd3']},
]
rows = {r['id']: r for r in b['rows']}
dyn_at = collections.defaultdict(list)
for r in items:
    if r['kind'] in ('stays', 'inside') and r.get('at') in b['conds'] and r['dynamic'] not in dyn_at[r['at']]:
        dyn_at[r['at']].append(r['dynamic'])

sheet = {
  'schema_version': 1, 'as_of': '2026-11-12',
  'about': 'AI-written. The map of what happens: bands of rows, each row one thing asked of anything that keeps going; each box one way the answer can stand. Arrows are in passages.json, paths to read in paths.json, tests laid on the map in laid.json. A row is a tie of the web of roles (web.json); the laws and tests behind it are in cards.json and cases.json.',
  'lead_en': D['lead']['en'], 'lead_zh': D['lead']['zh'],
  'bands': [{'id': x['id'], 'en': x['en'], 'zh': x['zh']} for x in b['bands']],
  'rows': [{'id': i, 'band': ROW_BAND.get(i, rows[i]['band']), 'en': rows[i]['en'], 'zh': rows[i]['zh']} for i in ROW_ORDER],
  'web': WEB,
  'boxes': [{'id': c['id'], 'row': c['row'], 'col': COL.get(c['id'], c['col']), 'en': c['en'], 'zh': c['zh'], 'says_en': c['says_en'], 'says_zh': c['says_zh'],
             'eg_en': c['eg_en'], 'eg_zh': c['eg_zh'], 'known_en': c['known_as'], 'known_zh': c['known_zh'],
             'anchors': ['Becoming.' + a if not a.startswith(('Becoming.', 'SeededContinuation', 'RegimeBoundary')) and '.' in a or a[:1].islower() else a for a in c['anchors']],
             'dynamics': dyn_at.get(c['id'], []), 'wanted': c['id'] in WANTED}
            for c in sorted(b['conds'].values(), key=lambda c: (ROW_ORDER.index(c['row']), COL.get(c['id'], c['col'])))],
}
# anchors were shortened for display in the kit; keep them as the kit shows them (short names), the tool prints them as given
for bx, c in zip(sheet['boxes'], sorted(b['conds'].values(), key=lambda c: (ROW_ORDER.index(c['row']), COL.get(c['id'], c['col'])))):
    bx['anchors'] = c['anchors']

def readers(x): return 0 if not x['laws'] else (1 if x['single'] else 2)
passages = [{'from': q['from'], 'to': q['to'], 'kind': q['kind'], 'tag_en': q['tag_en'], 'tag_zh': q['tag_zh'], 'en': q['en'], 'zh': q['zh'], 'laws': q['laws'], 'readers': readers(q),
             'more': [{'kind': m['kind'], 'en': m['en'], 'zh': m['zh'], 'laws': m['laws'], 'readers': readers(m)} for m in q['more']]} for q in b['passages']]
# the link that closes the ring: written by the coordinator, to be set against the Lean by a reader
passages.append({'from': 'b1.held', 'to': 'b2.uncounted', 'kind': 'needs', 'tag_en': 'while locked, the uncounted loss goes on growing', 'tag_zh': '定住的时候，不算的损耗照旧在涨',
                 'en': 'The laws take the growing loss as given: where each step adds to what is used up beyond the count, a lock once formed stays while that loss passes every bound.',
                 'zh': '定律把“损耗在涨”当作给定的：只要每一步都往账外的损耗上再添一份，已经形成的定局就一直在，而损耗越过任何界限。',
                 'laws': ['Becoming.ClosedCapture.lock_outlives_loss'], 'readers': 0, 'more': []})
stays = [{'at': s['from'], 'en': s['en'], 'zh': s['zh'], 'laws': s['laws']} for s in b['stays']]

pid = {q['id']: q['from'] + '>' + q['to'] for q in D['passages']}
def on(st):
    out = []
    for r in st['refs']:
        out.append('box:' + r['c'] if 'c' in r else 'stay:' + r['stay'] if 'stay' in r else pid[r['p']])
    return out
paths = []
for P in D['paths']:
    paths.append({'id': P['id'], 'bands': P['bands'], 'en': P['en'], 'zh': P['zh'], 'lead_en': P['lead_en'], 'lead_zh': P['lead_zh'],
                  'sections': [{'en': S['en'], 'zh': S['zh'], 'tone': S['tone'],
                                'steps': [dict({'say_en': st['say_en'], 'say_zh': st['say_zh'], 'on': on(st)}, **({'eg': st['eg']} if st.get('eg') else {}), **({'test': st['test']} if st.get('test') else {})) for st in S['steps']]}
                               for S in P['sections']],
                  'shows_en': P['shows_en'], 'shows_zh': P['shows_zh'], 'want_en': P['want_en'], 'want_zh': P['want_zh']})
tests = []
for k in D['cases']:
    t = {x: k[x] for x in ('id', 'test', 'en', 'zh', 'what_en', 'what_zh', 'said_en', 'said_zh', 'seen_en', 'seen_zh', 'broke_en', 'broke_zh', 'after_en', 'after_zh', 'rival_en', 'rival_zh')}
    t['pins'] = [dict({x: p[x] for x in ('at', 'how', 'agree', 'en', 'zh', 'short_en', 'short_zh', 'seen_en', 'seen_zh')}, **({'found_at': p['found_at']} if p.get('found_at') else {})) for p in k['pins']]
    t['used'] = [pid[i] for i in k['used']]
    t['gave'] = [{'pin': g['pin']} if 'pin' in g else {'passage': pid[g['p']]} for g in k.get('gave', [])]
    t['view'] = k.get('view')
    tests.append(t)
def dump(name, obj): json.dump(obj, open(os.path.join(HERE, 'data', name), 'w'), ensure_ascii=False, indent=1); print(name, os.path.getsize(os.path.join(HERE, 'data', name)))
dump('sheet.json', sheet)
dump('passages.json', {'schema_version': 1, 'as_of': '2026-11-12', 'about': 'AI-written. The arrows of the map. kind: law (proved of the course itself, under its condition), line (a proved boundary: which side a thing is on), needs (proved only with something given from outside the course, or a necessary condition), built (shown only in a built example), reading (not proved), same (one box is a case of the other). readers: how many readers set the sentence against the Lean (0: no Lean statement, or not yet read).', 'passages': passages, 'stays': stays})
dump('paths.json', {'schema_version': 1, 'as_of': '2026-11-12', 'about': 'AI-written. Paths to read on the map. A step is told in one or two plain sentences and stands on boxes (box:id), arrows (from>to) or what is known about staying at a box (stay:id).', 'paths': paths})
dump('laid.json', {'schema_version': 1, 'as_of': '2026-11-12', 'about': 'AI-written. Tests laid on the map, each written from the test\'s own record: what was taken as which box, what the reasoning said, what was seen, what gave way.', 'tests': tests})
print(len(sheet['boxes']), 'boxes', len(passages), 'passages', len(stays), 'stays', [len([s for S in p['sections'] for s in S['steps']]) for p in paths], 'steps', len(tests), 'tests')
