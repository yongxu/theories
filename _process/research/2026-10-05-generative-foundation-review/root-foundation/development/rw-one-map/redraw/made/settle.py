# AI-written, 12 November 2026. Applies the second readers' verdicts (verified.json) to the hand-written and placed
# passages, with the coordinator's decisions on moves and on the passages the readers found missing.
# Writes settled.json, which build.py draws.
import json, os, sys, collections
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from passages import HAND
from data import CONDITIONS

V = json.load(open(os.path.join(HERE, 'verified.json')))
ids = {c['id'] for c in CONDITIONS}
hand_paths = {(h['from'], h['to']): h['paths'] for h in HAND}
ORDER = ['law', 'line', 'needs', 'built', 'reading', 'same']

P = collections.OrderedDict()     # (from, to) -> passage
STAYS = []
LOG = []

def way(kind, en, zh, laws, src):
    return {'kind': kind, 'en': en.strip(), 'zh': zh.strip(), 'laws': list(laws), 'src': src}

def add(a, b, w, paths=()):
    assert a in ids and b in ids, (a, b)
    if a == b:
        STAYS.append({'from': a, **w}); return
    k = (a, b)
    rk = (b, a)
    if k not in P and rk in P and P[rk]['ways'][0]['kind'] in ('line', 'same') and w['kind'] in ('line', 'same'):
        k = rk
    if k in P:
        P[k]['ways'].append(w); P[k]['paths'] = sorted(set(P[k]['paths']) | set(paths))
    else:
        P[k] = {'from': k[0], 'to': k[1], 'ways': [w], 'paths': sorted(set(paths))}

MOVES = {('b3.gone', 'b3.checkers'): ('b3.inside', 'b3.checkers'),
         ('a1.past', 'd1.round'): ('a2.short', 'a2.supplied'),
         ('e2.swing', 'e2.rest'): ('e2.norest', 'e2.rest')}

for g in V['groups']:
    for p in g['passages']:
        k = (p['from'], p['to'])
        if p['verdict'] == 'drop':
            LOG.append('dropped %s -> %s: %s' % (k[0], k[1], p['why'])); continue
        tgt = k
        if p['verdict'] == 'move':
            tgt = MOVES.get(k) or (p.get('new_from') or k[0], p.get('new_to') or k[1])
            LOG.append('moved %s -> %s to %s -> %s' % (k + tgt))
        add(tgt[0], tgt[1], way(p['kind'], p['en'], p['zh'], p['laws'], g['group'] + ':' + p['verdict']), hand_paths.get(k, ()))

# the passages the second readers found missing: which to take, and in whose wording where two readers gave one
SKIP_MISSING = {
    ('lock-closing', 'd2.handed', 'a2.ended'): 'the placed passage of the same ends already carries this law',
    ('lock-closing', 'b1.held', 'b1.swing'): 'taken in the lock-turning reader\'s wording, which gives both built cases',
    ('lock-closing', 'b3.gone', 'b3.inside'): 'taken in the lock-turning reader\'s wording',
    ('auto', 'b3.gone', 'a2.ended'): 'taken in the lock-turning reader\'s wording',
    ('auto', 'a1.within', 'a2.short'): 'another model outside the namespace Becoming (the market model); left for the full pass',
    ('lock-closing', 'b1.held', 'b2.counted'): 'said once, as what holds the hold (the lock-turning reader\'s wording), with the built case kept',
}
KIND_OVERRIDE = {('auto', 'e1.ring', 'e1.line'): ('needs', 'the premise is that the links stop acting; no law here says when they do')}
for g in V['groups']:
    for m in g['missing']:
        key = (g['group'], m['from'], m['to'])
        if key in SKIP_MISSING:
            LOG.append('missing not added %s -> %s (%s): %s' % (m['from'], m['to'], g['group'], SKIP_MISSING[key])); continue
        kind = m['kind']
        if key in KIND_OVERRIDE:
            kind, why = KIND_OVERRIDE[key]; LOG.append('kind of %s -> %s set to %s by the coordinator: %s' % (m['from'], m['to'], kind, why))
        if key == ('lock-turning', 'b1.held', 'b2.counted'):
            # a law of staying, and what leaving needs: shown as what holds the hold
            STAYS.append({'from': 'b1.held', **way('law', m['en'], m['zh'], m['laws'], g['group'] + ':missing')}); continue
        paths = ()
        if m['from'][:2] in ('a1', 'a2', 'b0') and m['to'][:2] in ('a1', 'a2', 'b0'): paths = ('stock',)
        if m['from'][:2] in ('b1', 'b2', 'b3', 'bs') or m['to'][:2] in ('b1', 'b2', 'b3', 'bs'): paths = ('lock',)
        add(m['from'], m['to'], way(kind, m['en'], m['zh'], m['laws'], g['group'] + ':missing'), paths)
# the built case the lock-closing reader gave for leaving the hold through the share itself
for g in V['groups']:
    for m in g['missing']:
        if (g['group'], m['from'], m['to']) == ('lock-closing', 'b1.held', 'b2.counted'):
            pass

out = []
for k, q in P.items():
    q['ways'].sort(key=lambda w: ORDER.index(w['kind']))
    q['kind'] = q['ways'][0]['kind']
    out.append(q)

# conditions: corrected glosses and the Lean anchors
fix = {}; anchors = collections.defaultdict(list)
PREFER = {'b1.held': 'lock-turning'}
for g in V['groups']:
    for c in g['conditions']:
        for a in c['anchors']:
            if a not in anchors[c['id']]: anchors[c['id']].append(a)
        if c['verdict'] == 'fix' and (c['id'] not in fix or PREFER.get(c['id']) == g['group']):
            fix[c['id']] = {'says_en': c['says_en'], 'says_zh': c['says_zh'], 'why': c['why'], 'by': g['group']}

json.dump({'passages': out, 'stays': STAYS, 'cond_fix': fix, 'anchors': anchors, 'log': LOG}, open(os.path.join(HERE, 'settled.json'), 'w'), ensure_ascii=False, indent=1)
print('passages', len(out), collections.Counter(q['kind'] for q in out), '| ways', sum(len(q['ways']) for q in out), '| stays', len(STAYS), '| condition glosses corrected', len(fix))
for l in LOG: print(' -', l[:170])
