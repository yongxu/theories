# AI-written (Fable, refuter of the links), 16 November 2026. Read-only. The final sets, under both counts.
import json, collections
P = '/Users/ren/theories/theories/becoming/results/atlas/entries/dynamics.json'
d = json.load(open(P)); ids = [e['id'] for e in d]
lists = collections.defaultdict(set)
for e in d:
    for dec in e.get('declarations') or []: lists[dec].add(e['id'])
    for p in e.get('premises') or []: lists[p['law']].add(e['id'])
def pairs(law_only):
    out = set()
    for e in d:
        for x in e['exits']:
            if isinstance(x['to'], str) and (not law_only or (x.get('law') and x.get('strength'))): out.add(frozenset((e['id'], x['to'])))
        for p in e.get('premises') or []:
            for c in p.get('case_of') or []:
                for t in lists.get(c['law'], set()) - {e['id']}: out.add(frozenset((e['id'], t)))
        for c in e.get('compose') or []:
            if not law_only or c.get('standing') == 'proved': out.add(frozenset((c['from']['dynamic'], c['to']['dynamic'])))
    return {p for p in out if len(p) == 2}
def measure(base, extra=()):
    par = {i: i for i in ids}
    def f(a):
        while par[a] != a: par[a] = par[par[a]]; a = par[a]
        return a
    for p in list(base) + [frozenset(x) for x in extra]:
        a, b = tuple(p); par[f(a)] = f(b)
    c = collections.Counter(f(i) for i in ids); s = sorted(c.values(), reverse=True)
    return '%d pieces, %d alone, largest %d' % (len(c), sum(1 for v in s if v == 1), s[0]), {i: c[f(i)] for i in ids}
S, T, M = 'shaping-the-rule-selected-by-what-comes-back', 'turning-in-time', 'margin-of-a-regime'
CR, CC, PL = 'capture-through-the-rule', 'closed-capture', 'threshold-in-the-state-plane'
LR, UG = 'loss-of-renewal-for-good', 'unceasing-generation-needs-renewal'
sets = [('now', []), ('two exits', [(S, CR), (T, M)]), ('+ the compose and the case_of', [(S, CR), (T, M), (CR, T), (CC, CR)]),
        ('+ the law to build', [(S, CR), (T, M), (CR, T), (CC, CR), (LR, UG)]),
        ('+ threshold_regime, if a slot is made', [(S, CR), (T, M), (CR, T), (CC, CR), (LR, UG), (PL, M)])]
for lo in (False, True):
    print('BY A LAW ONLY' if lo else 'ALL LINKS (round 10 definition)')
    b = pairs(lo)
    for name, ex in sets:
        m, size = measure(b, ex)
        print('  %-40s %s | piece of turning-in-time %d, of confined-rise %d' % (name, m, size[T], size['confined-rise-within-a-whole']))
