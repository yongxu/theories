#!/usr/bin/env python3
"""GW3-GW5: register the one apart root the connectivity check lists without a reason, KindRelay.Fed.not_listed, a
fact about the fed relay's conditions that no other theorem uses (model witness). Textual edit at the head of the
roots, the rest of the file byte for byte (register_wrp2.py's pattern); stops on any other unregistered root.
usage (from the checkout root): python3 -B register_gw.py CONNECTIVITY_LOG"""
import json
import re
import sys
from pathlib import Path

F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
log = Path(sys.argv[1]).read_text(encoding='utf-8')
m = re.search(r"apart roots without a reason in [^:]+: (\[[^\]]*\])", log)
unclassified = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]
OURS = {'Becoming.KindRelay.Fed.not_listed': (
    'model-witness',
    'No list holds every condition of the fed kind relay: the fuel of every step is a condition. A fact about one '
    'constructed model, used by no other theorem; with Fed.requirements_not_dissipated it says why the laws for '
    'dissipated requirements and for a listed world do not reach the fed relay (GW)')}
assert set(unclassified) <= set(OURS), ('not GW\'s roots; their owners\'', sorted(set(unclassified) - set(OURS)))
text = F.read_text(encoding='utf-8')
head = ' "roots": {\n'
assert text.count(head) == 1
add = ''.join('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "Becoming.KeepingWidening",\n'
              '   "category": ' + json.dumps(cat) + ',\n   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n'
              for name, (cat, reason) in OURS.items() if name in unclassified and f'"{name}"' not in text)
F.write_text(text.replace(head, head + add), encoding='utf-8')
json.loads(F.read_text(encoding='utf-8'))
print('registered', [n for n in OURS if n in unclassified])
