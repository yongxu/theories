"""Landing review probe: each record's laws cite each declaration of its module exactly once."""
import json, re, sys, collections
R, F = sys.argv[1], sys.argv[2]
def decls(path, ns):
    names, stack = [], []
    for line in open(path, encoding='utf-8'):
        m = re.match(r'namespace (\S+)', line)
        if m: stack.append(m.group(1)); continue
        m = re.match(r'end (\S+)', line)
        if m and stack and stack[-1] == m.group(1): stack.pop(); continue
        m = re.match(r'(?:noncomputable )?(?:theorem|def|abbrev|inductive|structure) (\S+)', line)
        if m: names.append('.'.join(stack + [m.group(1)]))
    return names
for rec, lean in [('the-blanket-at-a-steady-state', R + '/kit/tree/Becoming/BlanketWeights.lean'),
                  ('the-blanket-in-a-linear-steady-state', F + '/LinearBlankets.lean')]:
    d = json.load(open(f'{R}/review-landing/records/{rec}.json'))
    cited = [x for l in d['laws'] for x in l['declarations']]
    c = collections.Counter(cited)
    have = set(decls(lean, []))
    print(rec, ': cited', len(cited), 'distinct', len(c), 'module', len(have),
          'dups', [k for k, v in c.items() if v > 1], 'missing', sorted(have - set(c)), 'extra', sorted(set(c) - have))
    refs = [x for r in d.get('references', []) for x in r.get('declarations', [])]
    print('   references list:', len(refs), 'distinct', len(set(refs)), 'equal to cited:', set(refs) == set(c))
