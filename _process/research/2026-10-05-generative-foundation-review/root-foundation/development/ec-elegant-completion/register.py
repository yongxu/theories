#!/usr/bin/env python3
"""Register EC1's apart root in THEOREM-CONNECTIVITY-APART.json, found by THEOREM-CONNECTIVITY.py --check on the
integrated tree. usage: python3 -B register.py (from the checkout root)"""
import json
from pathlib import Path
P = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
d = json.loads(P.read_text())
d['roots']['Becoming.withinClosureOf_iff'] = {
    'module': 'Becoming.Frame', 'category': 'general-structure',
    'reason': 'A group\'s closure is the union of its members\' closures, by definition (Iff.rfl): a law of every '
              'relation on any type, kept by name because records, chapters and frozen predictions cite it. The base '
              'reads it through the pooled coupling closure (Flow.WithinPoolCoupling), whose laws use the definition '
              'directly.'}
P.write_text(json.dumps(d, indent=1, ensure_ascii=False) + '\n')
print('registered 1')
