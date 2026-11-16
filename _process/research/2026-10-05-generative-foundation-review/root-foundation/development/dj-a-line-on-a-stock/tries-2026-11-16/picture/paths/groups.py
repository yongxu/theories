# AI-written (Fable), 16 November 2026. Read-only. Four hand-curated groups over the atlas's dynamics and the links between them.
import json, collections, itertools
P = '/Users/ren/theories/theories/becoming/results/atlas/entries/dynamics.json'
d = json.load(open(P)); byid = {e['id']: e for e in d}; fam = {e['id']: e['family'] for e in d}
G = {
 'a-lock': '''closed-capture capture-through-the-rule capture-by-counted-choices capture-reaching-the-routes-of-correction
  selection-for-narrowing-what-couples-in self-reproducing-selection-across-carriers target-capture habit-lock-in-active-inference
  a-counter-rule-read-from-its-own-share a-reading-against-the-share-does-not-ratchet shaping-the-rule-selected-by-what-comes-back
  shaping-read-by-readers-drawn-from-the-selected readers-drawn-from-the-selected the-lock-draws-its-readers-out locked-seeking
  readings-revised-spread-and-locked a-rule-rebuilt-from-the-members-it-limits a-rule-with-no-holder-does-not-return
  a-reader-rebuilt-from-its-stock-ends-with-it rule-raised-every-other-step selection-read-off-its-own-survivors
  a-pool-that-recruits-through-itself''',
 'b-renewal': '''closed-cycle-without-dissipation unceasing-generation-needs-renewal more-needs-renewers becoming-renewal-reading
  renewing-consuming-formation becoming-return-grades generation-and-degeneration-at-two-grains whole-persists-through-generation
  a-pattern-lasts-through-passing copying-from-a-stock continuing-self-fed-from-beyond supported-renewal-recovery
  optima-rebuild-a-depleted-base ceasing-needs-arising where-the-possible-grows what-keeping-widening-needs
  kind-relay-keeps-widening-within-kinds a-token-moved-back-and-forth-on-a-net lossless-exchange-continues-and-returns
  horizon-optima-hold-the-greatest-renewal continued-change-needs-openness regime-in-any-amounts joint-practice-forms-continuation
  mutual-dependence-and-its-pace''',
 'c-drain': '''consumption-ends-with-feeders loss-of-renewal-for-good three-outcomes-of-a-loss substitution-preserves-consumption
  a-cascade-along-total-dependence co-ending-along-dependence degeneration-from-a-horizon market-finite-support-obstruction
  reserve-defers-ending dormancy-over-a-stretch ending-laws-as-regimes-on-a-lineage a-line-on-a-stock exit-from-a-margin
  every-loss-passes-a-juncture the-rest-outruns-the-renewal whole-drawing-beyond-renewal-ends where-a-rising-take-ends
  others-drawing-first-end-the-base a-weighting-faster-than-renewal-ends-the-base re-optimizing-above-a-renewal-ends-it
  several-optimizers-drain-by-their-joint-capacity own-count-misses-joint-excess drawers-in-turn a-race-for-position-draws-everything
  what-an-optimum-does-beyond-what-couples-in what-a-rise-draws-from-beyond no-finite-part-bears-taking
  unselected-beyond-the-coupling-closure closing-needs-net-draw a-whole-of-every-part what-taking-all-excludes
  position-does-not-protect risk-minimization-on-a-shared-renewal''',
 'd-turning': '''turning-in-time reading-a-loss-in-time loss-read-in-time-by-the-others two-sided-regulation-and-late-reading
  late-relay-oscillates threshold-reading-read-late-alternates a-revision-that-opens-a-correction correction-is-not-calibration
  recoverable-mediated-change slowing-down-before-an-own-end a-break-read-only-by-threshold never-leaving-a-guard
  a-step-coupling-keeps-at-every-horizon keeping-forgoes-the-renewal-at-the-need restraint-within-the-joint-slack
  the-stock-buys-time-where-the-rebuild-draws-on-it coupled-drawers-keep-a-need-only-where-the-coupling-reaches-it
  margin-of-a-regime threshold-in-the-state-plane overshoot-beyond-the-gap what-a-set-point-optimum-does-beyond''',
}
G = {k: v.split() for k, v in G.items()}
for k, v in G.items():
    for x in v:
        assert x in byid, x
grp = collections.defaultdict(list)
for k, v in G.items():
    for x in v: grp[x].append(k)
dup = {x: g for x, g in grp.items() if len(g) > 1}
print('in two groups:', dup)
print('sizes', {k: len(v) for k, v in G.items()}, 'covered', len(grp), 'of', len(d))
edges = json.load(open('/Users/ren/theories/tmp/r7/one-model/check/round10/paths/edges.json'))
# law-less exits
nolaw = {(e['id'], x['to']) for e in d for x in e['exits'] if isinstance(x['to'], str) and not x.get('law')}
adj = collections.defaultdict(set)
for f, t, k, l, s in edges:
    adj[f].add(t); adj[t].add(f)
print()
print('within-group linking: members with a neighbour in the same group / any neighbour / none')
for k, v in G.items():
    same = [x for x in v if any(y in v for y in adj[x])]
    anyn = [x for x in v if adj[x]]
    print(' ', k, len(v), 'same-group', len(same), 'any', len(anyn), 'none', len(v) - len(anyn))
print()
pairs = collections.defaultdict(list)
for f, t, k, l, s in edges:
    for gf in grp.get(f, []):
        for gt in grp.get(t, []):
            if gf != gt:
                pairs[(gf, gt)].append((f, t, k, l, s))
for a, b in itertools.permutations(G.keys(), 2):
    L = pairs.get((a, b), [])
    print('==', a, '->', b, len(L))
    for f, t, k, l, s in L:
        tag = k
        if k == 'exit': tag = 'exit/' + (str(s) if l else 'NO-LAW')
        if k == 'compose': tag = 'compose/' + ('reading' if l.endswith('None') else 'law-both') + '/' + str(s)[:20]
        print('   ', tag, '|', f, '->', t, '|', (l or '')[:150])
# shortest paths between group sets in the undirected graph
print()
import collections as C
def dist_from(src):
    D = {s: 0 for s in src}; q = C.deque(src)
    while q:
        u = q.popleft()
        for v in adj[u]:
            if v not in D: D[v] = D[u] + 1; q.append(v)
    return D
for a, b in itertools.combinations(G.keys(), 2):
    D = dist_from(G[a])
    reach = [x for x in G[b] if x in D]
    print(a, '~', b, ': members of', b, 'reachable from', a, 'by any links:', len(reach), 'of', len(G[b]))
