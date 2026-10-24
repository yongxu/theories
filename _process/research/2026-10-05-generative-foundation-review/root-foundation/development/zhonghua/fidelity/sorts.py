"""The fidelity count (FC1; FIDELITY.md §2 "Sorts"): one sort per Lean referent, from a registered table of type heads.

The table is fixed before any coding (registered with this file's first commit) and is a hint to the coders, who apply
the sort-preservation rule of §3. Each binder is also classed as a hypothesis (a non-dependent Prop binder), a
decidability instance, or a type parameter. The design's list of sorts has no sort for a move (an act along a step);
moves are given the sort `move` here, registered before scoring, and the coders may coarsen it to the step it labels.

    python3 -I fidelity/sorts.py      # needs data/lean_dump.jsonl; writes data/lean_table.jsonl
"""
import json, re
from pathlib import Path

HERE = Path(__file__).resolve().parent
DATA = HERE / 'data'

SORTS = ['relatum or role', 'configuration', 'step', 'amount', 'history or run', 'claim or predicate',
         'map, lumping or feature', 'class of functions', 'law or process', 'world, web or flow', 'family or list',
         'value', 'standpoint', 'significance', 'move']

# (regex on the binder's type, sort), first match wins; then the binder's own name for Nat and bare variables
TABLE = [
    (r'^(Type|Sort)\b|^Type\*', 'type'),
    (r'^Decidable|DecidableEq|DecidablePred|DecidableRel', 'instance'),
    (r'^(Becoming\.)?(Web|World|Flow|Frame|Network|Exchange|ExchangeLaw|Census|Situation)\b', 'world, web or flow'),
    (r'^(Becoming\.)?(Law|Process|Generative\.Process|Determined)\b', 'law or process'),
    (r'^(Becoming\.)?(Run|History|Labelled|Trace|Course)\b', 'history or run'),
    (r'^(Becoming\.)?(Valuation|Weighting|Significance)\b', 'significance'),
    (r'^(Becoming\.)?(Standpoint|Center)\b', 'standpoint'),
    (r'^List\b|^Finset\b|^Multiset\b', 'family or list'),
    (r'^\((Nat|ℕ) → .*\) → Prop$', 'claim or predicate'),
    (r'^\(.*→.*\) → Prop$|→ .* → Prop\) → Prop', 'class of functions'),
    (r'→ Prop$', 'claim or predicate'),
    (r'^(Nat|ℕ) → ', 'history or run'),
    (r'→', 'map, lumping or feature'),
    (r'^Prop$', 'claim or predicate'),
    (r'^ℕ$|^Nat$', 'nat'),
    (r'^(F|C|X|E|I|U|P|N)\b', 'relatum or role'),
    (r'^(S|Q)\b', 'configuration'),
    (r'^(A|M|B)\b', 'move'),
    (r'^(O|V|R|K|W|T|Y|Z|α|β|γ)\b', 'value'),
]
STEP_NAMES = re.compile(r'^(t|t₀|t₁|t\'|n|m|h|k|s₀|step|i|j|N|L|M|start|stop|until|T)\S*$')


def sort_of(b):
    ty = b['type'].strip()
    if b.get('prop') and not re.match(r'^(Type|Sort)', ty):
        return 'claim or predicate', 'hypothesis'
    for pat, sort in TABLE:
        if re.search(pat, ty):
            if sort == 'type':
                return None, 'type parameter'
            if sort == 'instance':
                return None, 'decidability instance'
            if sort == 'nat':
                return ('step' if STEP_NAMES.match(b['name']) and b['name'] not in ('N', 'L', 'M') else 'amount'), 'variable'
            return sort, 'variable'
    return 'value', 'variable'


def main():
    out = []
    for line in open(DATA / 'lean_dump.jsonl', encoding='utf-8'):
        d = json.loads(line)
        rows = []
        for b in d['binders']:
            s, role = sort_of(b)
            rows.append({'name': re.sub(r'\._@.*$', '', b['name']).replace('✝', ''), 'type': b['type'], 'sort': s, 'role': role,
                         'implicit': 'default' not in b.get('info', '')})
        nested = [{'q': n['q'], 'name': n['name'], 'type': n['type'],
                   'sort': sort_of({'name': n['name'], 'type': n['type'], 'prop': False})[0]} for n in d['nested']]
        out.append({'decl': d['decl'], 'kind': d['kind'], 'binders': rows, 'conclusion': d['conclusion'],
                    'nested': nested, 'consts': d['consts'], 'unfold1': d['unfold1'], 'self': d.get('self')})
    with open(DATA / 'lean_table.jsonl', 'w', encoding='utf-8') as f:
        for o in out:
            f.write(json.dumps(o, ensure_ascii=False) + '\n')
    from collections import Counter
    print(len(out), Counter(r['sort'] for o in out for r in o['binders']).most_common())


if __name__ == '__main__':
    main()
