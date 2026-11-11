"""Map the three proposals' places onto one list and compare their assignments item by item (read-only aid)."""
import json, re, collections
M = {
 'from-the-sentences': {'favoured-gaining':'fixed-rule','unsettled':'several-ways','held':'holds-itself','held-other-side':'holds-itself',
   'held-loss-growing':'judged-inside','outside-the-count':'uncounted','noticers-leaving':'noticers-gone','one-view-left':'all-on-one',
   'loss-registers':'felt','too-late':'past-turning-back','pays-doers':'shaping-pays','costs-doers':'shaping-costs',
   'checks-inside':'checkers-inside','outlives-members':'outlives-members'},
 'from-what-people-know': {'not-settled':'several-ways','all-on-one':'all-on-one','used-because-used':'holds-itself','pays':'shaping-pays','costs':'shaping-costs',
   'uncounted-used-up':'uncounted','nothing-outside-counts':'judged-inside','watchers-gone':'noticers-gone','in-view':'felt','left-out-counts':'cost-counts',
   'past-no-return':'past-turning-back','ended':'ended','checks-follow-winners':'checkers-inside','carries-on-across-people':'outlives-members'},
 'one-loop-its-regimes': {'several-ways':'several-ways','rule-apart':'shaping-costs','winners-set-rule':'shaping-pays','holding':'holds-itself','all-on-one':'all-on-one',
   'uncounted':'uncounted','judged-inside':'judged-inside','felt':'felt','noticers-gone':'noticers-gone','past-turning-back':'past-turning-back',
   'cost-counts':'cost-counts','ended':'ended','checkers-inside':'checkers-inside','outlives-members':'outlives-members'},
}
def norm(s):
    m = re.search(r'(exit|transition|compose)\D*(\d+)', s.lower())
    return f'{m.group(1)} {m.group(2)}' if m else s.lower()
ds = json.load(open('/Users/ren/theories/theories/becoming/results/atlas/entries/dynamics.json')); by = {d['id']: d for d in ds}
scope = json.load(open('scope.json')) + ['what-an-optimum-does-beyond-what-couples-in']
items = []
for i in scope:
    d = by[i]
    items += [(i, f'exit {n+1}') for n in range(len(d['exits']))] + [(i, f'transition {n+1}') for n in range(len(d.get('transitions') or []))] + [(i, f'compose {n+1}') for n in range(len(d.get('compose') or []))]
got = {k: collections.defaultdict(list) for k in M}
for k in M:
    r = json.load(open(f'proposal-{k}.json'))
    for a in r['arrows']:
        got[k][(a['dynamic'], norm(a['item']))].append((M[k].get(a['from'], '?' + a['from']), M[k].get(a['to'], '?' + a['to']), a.get('both_ways', False), a))
    for u in r['unresolved']:
        got[k][(u['dynamic'], norm(u['item']))].append(('UNRESOLVED', u.get('seems_to_lead') or '', False, u))
rows = []; agree = part = dis = 0
for it in items:
    votes = []
    for k in M:
        v = got[k].get(it)
        votes.append(tuple(sorted({(x[0], x[1]) for x in v})) if v else (('STAYS', ''),))
    pairs = [frozenset((a, b) if a not in ('UNRESOLVED',) else ('UNRESOLVED',) for a, b in v) for v in votes]
    c = collections.Counter(pairs); top, n = c.most_common(1)[0]
    status = 'all3' if n == 3 else 'two' if n == 2 else 'split'
    agree += n == 3; part += n == 2; dis += n == 1
    rows.append({'dynamic': it[0], 'item': it[1], 'status': status, 'votes': {k: [list(p) for p in v] for k, v in zip(M, votes)}})
print(len(items), 'items | all three agree', agree, '| two agree', part, '| split', dis)
json.dump(rows, open('compare.json', 'w'), indent=1, ensure_ascii=False)
for r in rows:
    if r['status'] != 'all3':
        print(r['status'], r['dynamic'][:44], r['item'], '|', ' || '.join('/'.join('>'.join(p) for p in v) for v in r['votes'].values()))
