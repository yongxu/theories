# AI-written (Fable, refuter of the links), 16 November 2026. Read-only over the atlas entries.
# The map's own numbers (pieces, dynamics alone, largest piece), by round10/paths/graph.py's definition of an edge:
# an exit whose `to` names a dynamic; a premise row's case_of whose general law is listed under another dynamic; a compose.
import json, collections
P = '/Users/ren/theories/theories/becoming/results/atlas/entries/dynamics.json'
d = json.load(open(P)); ids = [e['id'] for e in d]; byid = {e['id']: e for e in d}
lists = collections.defaultdict(set)
for e in d:
    for dec in e.get('declarations') or []: lists[dec].add(e['id'])
    for p in e.get('premises') or []: lists[p['law']].add(e['id'])
base = set()
for e in d:
    for x in e['exits']:
        if isinstance(x['to'], str): base.add(frozenset((e['id'], x['to'])))
    for p in e.get('premises') or []:
        for c in p.get('case_of') or []:
            for t in lists.get(c['law'], set()) - {e['id']}: base.add(frozenset((e['id'], t)))
    for c in e.get('compose') or []:
        base.add(frozenset((c['from']['dynamic'], c['to']['dynamic'])))
base = {p for p in base if len(p) == 2}
def measure(extra=()):
    par = {i: i for i in ids}
    def f(a):
        while par[a] != a: par[a] = par[par[a]]; a = par[a]
        return a
    for p in list(base) + [frozenset(x) for x in extra]:
        a, b = tuple(p); assert a in par and b in par, p; par[f(a)] = f(b)
    c = collections.Counter(f(i) for i in ids)
    sizes = sorted(c.values(), reverse=True)
    return dict(pieces=len(c), alone=sum(1 for v in sizes if v == 1), largest=sizes[0], next=sizes[1:4]), {i: c[f(i)] for i in ids}
S, T, M = 'shaping-the-rule-selected-by-what-comes-back', 'turning-in-time', 'margin-of-a-regime'
CR, CC = 'capture-through-the-rule', 'closed-capture'
PL, LR, UG = 'threshold-in-the-state-plane', 'loss-of-renewal-for-good', 'unceasing-generation-needs-renewal'
LINE, CONF, RT, GUARD, REB = 'a-line-on-a-stock', 'confined-rise-within-a-whole', 'where-a-rising-take-ends', 'never-leaving-a-guard', 'a-rule-rebuilt-from-the-members-it-limits'
now, size = measure()
print('dynamics', len(ids), '| pairs', len(base), '| now', now)
for i in (S, CR, CC, T, M, PL, LR, UG, LINE, CONF, RT, GUARD, REB): print('   piece of', i, '=', size[i])
paths = [(S, CR), (T, M)]
joinings = [(CR, T), (CC, CR), (PL, M)]
build = [(LR, UG)]
refuted = [(LINE, CONF), (LINE, RT), (M, GUARD), (REB, T)]
steps = [('paths that show the leaving (2)', paths), ('+ joinings and cases, not paths (3)', paths + joinings),
         ('+ the one law to build (1)', paths + joinings + build),
         ('for comparison: + the four the seats refuted', paths + joinings + build + refuted)]
for name, ex in steps: print(name, measure(ex)[0])
for a, b in paths + joinings + build:
    print('   alone,', a, b, '->', measure([(a, b)])[0])

# The same counts on links that carry a law only: an exit with a law, a case_of, a compose that is proved.
law = set()
for e in d:
    for x in e['exits']:
        if isinstance(x['to'], str) and x.get('law') and x.get('strength'): law.add(frozenset((e['id'], x['to'])))
    for p in e.get('premises') or []:
        for c in p.get('case_of') or []:
            for t in lists.get(c['law'], set()) - {e['id']}: law.add(frozenset((e['id'], t)))
    for c in e.get('compose') or []:
        if c.get('standing') == 'proved': law.add(frozenset((c['from']['dynamic'], c['to']['dynamic'])))
law = {p for p in law if len(p) == 2}
base = law
now2, size2 = measure()
print('\nBY A LAW ONLY: pairs', len(law), '| now', now2)
for i in (S, CR, CC, T, M, PL, LR, UG): print('   piece of', i, '=', size2[i])
for name, ex in steps[:3]: print(name, measure(ex)[0])
