# AI-written (Fable, refuter), 16 November 2026. Read-only over the atlas entries; the edge
# definition is refuter-links/numbers.py's (an exit naming a dynamic, a case_of whose general law
# another dynamic lists, a compose). Which piece each dynamic of the regulation family is in now.
import json, collections
P = '/Users/ren/theories/theories/becoming/results/atlas/entries/dynamics.json'
d = json.load(open(P)); ids = [e['id'] for e in d]
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
def comp(extra=()):
    par = {i: i for i in ids}
    def f(a):
        while par[a] != a: par[a] = par[par[a]]; a = par[a]
        return a
    for p in list(base) + [frozenset(x) for x in extra]:
        a, b = tuple(p); par[f(a)] = f(b)
    groups = collections.defaultdict(list)
    for i in ids: groups[f(i)].append(i)
    return {i: groups[f(i)] for i in ids}, len(groups), sum(1 for g in groups.values() if len(g) == 1)
fam = ['two-sided-regulation-and-late-reading', 'overshoot-beyond-the-gap', 'late-relay-oscillates',
       'overshooting-thermostat-alternates', 'what-a-set-point-optimum-does-beyond',
       'a-reader-rebuilt-from-its-stock-ends-with-it', 'the-stock-buys-time-where-the-rebuild-draws-on-it',
       'formed-goal-revision-continuation', 'seeking-boundary', 'margin-of-a-regime', 'turning-in-time',
       'capture-through-the-rule', 'a-line-on-a-stock', 'loss-of-renewal-for-good']
g, n, alone = comp()
print('now: pieces', n, 'alone', alone)
for i in fam:
    if i in g: print(f'  {i}: piece of {len(g[i])}', '' if len(g[i]) > 6 else g[i])
    else: print('  MISSING', i)
# which dynamics list the laws the rooms' theorems are cases of
for law in ['Becoming.RegimeMargin.holds', 'Becoming.RegimeMargin.stays_ended', 'Becoming.RegimeMargin.step',
            'Becoming.RegimeMargin.Alternation.alternates', 'Becoming.Rooms.next_open',
            'Becoming.Rooms.Matched.window_held', 'Becoming.Rooms.Unheated.window_cold',
            'Becoming.Regulation.Between', 'Becoming.Optimum.Nearer', 'Becoming.Boundary',
            'Becoming.Boundary.closure', 'Becoming.unrestricted_iff_presupposed_along',
            'Becoming.boundaryInvariant_iff_all', 'Becoming.Pace.rule_until_reading', 'Becoming.Pace.paced',
            'Becoming.RuleCapture.against_not_rising', 'Becoming.Optimum.course_kept_iff',
            'Becoming.Optimum.frontier_holds', 'Becoming.Flow.restores', 'Becoming.Flow.never_returns_below']:
    print(' ', law, '->', sorted(lists.get(law, [])))
g2, n2, a2 = comp([('overshooting-thermostat-alternates', 'margin-of-a-regime')])
print('with the rooms entered as a case of the regime: pieces', n2, 'alone', a2,
      '| piece of margin-of-a-regime', len(g2['margin-of-a-regime']))
