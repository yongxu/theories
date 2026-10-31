"""Critic: draft 2's 'grammar laws a declaration reaches' (§3.0: stop at laws, forwarders and root constants) against
the same walk entering root theorems that are not laws (their proofs), on the central rows of the measure."""
import json, sys
sys.path.insert(0, '/private/tmp/claude-501/-Users-ren-theories/4cd2c9b9-8aca-4fd1-99bb-ff1a3f9d1698/scratchpad/recheck-bf')
import lib
from lib import C, laws, forwarders, root
law_of = lambda n: n if n in laws else forwarders.get(n)
def reach(n, enter_root_theorems):
    out, seen, st = set(), {n}, list(C[n]['t']) + list(C[n]['v'])
    while st:
        b = st.pop()
        if b not in C or b in seen: continue
        seen.add(b)
        if law_of(b): out.add(law_of(b))
        elif b not in root or (enter_root_theorems and C[b]['k'] == 'thm'):
            st += list(C[b]['t']) + list(C[b]['v'])
    return out
M = json.load(open('/private/tmp/claude-501/-Users-ren-theories/4cd2c9b9-8aca-4fd1-99bb-ff1a3f9d1698/scratchpad/bd-measure.json'))
rows = {}
for r in M['rows']: rows.setdefault(r['declaration'], r)
diff = 0
for n, r in sorted(rows.items()):
    a, b = reach(n, False), reach(n, True)
    if a != b:
        diff += 1
        print(n.removeprefix('Becoming.'), r['dependence'], '| draft 2:', sorted(x.removeprefix('Becoming.') for x in a), '| through root theorems adds:', sorted(x.removeprefix('Becoming.') for x in b - a))
g = [n for n, r in rows.items() if r['dependence'] == 'grammar']
print('grammar rows reaching a law: draft-2 walk', sum(bool(reach(n, False)) for n in g), 'of', len(g), '; entering root theorems', sum(bool(reach(n, True)) for n in g))
print('rows whose reported laws change:', diff)
