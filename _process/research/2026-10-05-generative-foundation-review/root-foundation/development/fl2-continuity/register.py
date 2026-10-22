"""Register the apart roots FL2 adds: the two Teleport witnesses of Becoming.Continuity, facts about one constructed
law on two relata. Textual insertion at the end of the roots, the rest of the file byte for byte.
usage (from the checkout root): python3 -B register.py"""
import json
from pathlib import Path
F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
t = F.read_text(encoding='utf-8')
entries = {
    'Becoming.Continuity.Teleport.no_transfers_apart':
        'Swapping the levels of two relata conserves their total, and along the empty relation the family of one '
        'relatum is closed and loses its unit, so no transfers along that relation balance the swap: a fact about one '
        'constructed law showing that conservation of the whole total does not give balance along a relation (FL2).',
    'Becoming.Continuity.Teleport.balanced_together':
        'The same swap reads both relata, and along the full relation the routed transfers balance it from every '
        'configuration: the constructed law meeting the premises of conservedOn_of_law and route_balancing (FL2).',
}
block = ''
for name, reason in entries.items():
    assert f'"{name}"' not in t
    block += ('  "' + name + '": {\n'
              '   "module": "Becoming.Continuity",\n'
              '   "category": "model-witness",\n'
              '   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n'
              '  },\n')
anchor = '  }\n },\n "instances": {'
assert t.count(anchor) == 1
t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
d = json.loads(t)
assert all(d['roots'][n]['category'] == 'model-witness' for n in entries)
F.write_text(t, encoding='utf-8')
print('register:', len(entries), 'roots added')
