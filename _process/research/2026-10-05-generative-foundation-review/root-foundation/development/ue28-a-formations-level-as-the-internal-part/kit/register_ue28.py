#!/usr/bin/env python3
"""UE28's landing (register_ue27.py's pattern): register the apart roots the connectivity check lists without a
reason that are among UE28's new declarations of BlanketCouplings, each with a category and a reason; stop on any
other root, UE27's names included, which is read by hand, and another session's, which belongs to its owner.

* The general part (stepExternal, AgentConsistent, stepLaw, ValuesAcross, levelParts, presentRow and their laws) holds
  of any course, or of any web, flow and formation along one balanced run: the base supplies no reading of a
  formation's level as the internal part yet (general structure).
* The witnesses (PhasedDrain, Alternating and TwoRelata) are facts about one constructed model (model witness).

Textual edits, the rest of the file byte for byte.
usage (from the checkout root): python3 -B register_ue28.py CONNECTIVITY_LOG"""
import json
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
M = 'Becoming.BlanketCouplings'
WITNESS_SPACES = ('PhasedDrain', 'Alternating', 'TwoRelata')
NEW = {f'{M}.{n}' for n in (
    'stepExternal', 'AgentConsistent', 'stepExternal_consistent_iff', 'stepExternal_admitted_iff', 'stepLaw',
    'stepLaw_course', 'ValuesAcross', 'ValuesAcross.through', 'listed_valuesAcross', 'next_level_alike_iff',
    'levelParts', 'rowAct', 'presentRow', 'DecidesPresence', 'agentConsistent_iff_exchange', 'levelParts_admitted_iff',
    'TwoRelata', 'TwoRelata.g_not_mem_h')}
NEW |= {f'{M}.PhasedDrain.{n}' for n in (
    'phase', 'gLevel', 'hLevel', 'hTakesG', 'hGivesG', 'hTakesH', 'hGivesH', 'take', 'give', 'flow', 'level', 'web',
    'balance_g', 'balance_h', 'balances', 'uncoupled', 'one_value', 'values', 'presence', 'presence_decides', 'act',
    'not_admitted')}
NEW |= {f'{M}.Alternating.{n}' for n in (
    'phase', 'gLevel', 'hLevel', 'hTakesG', 'hGivesG', 'hTakesH', 'hGivesH', 'take', 'give', 'flow', 'level', 'web',
    'balance_g', 'balance_h', 'balances', 'uncoupled', 'values', 'presence', 'presence_decides', 'act', 'gLevel_inj',
    'recurs', 'agentConsistent', 'admitted')}
assert len(NEW) == 64, len(NEW)
log = Path(sys.argv[1]).read_text(encoding='utf-8')
m = re.search(r"apart roots without a reason in [^:]+: (\[[^\]]*\])", log)
unclassified = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]
stale = re.search(r"register entries no longer apart roots: (\[[^\]]*\])", log)
assert not (stale and stale.group(1).strip('[]').strip()), ('stale entries: read them', stale.group(1))
audit = (HERE.parent / 'tree/.build/BecomingBlanketCouplingsAxiomAudit.lean').read_text(encoding='utf-8')
NAMES = set(re.findall(r'^#print axioms (\S+)$', audit, re.M))
assert NEW <= NAMES, sorted(NEW - NAMES)
GENERAL = ('a law of any course read with the step as the external part, or of any web, flow and formation along '
           'one balanced run (a formation\'s level as the internal part); the base supplies no such reading of a '
           'formation yet (UE28)')
WITNESS = 'a fact about one constructed model: two relata, a drain in three phases or a drain and feed in two (UE28)'
reasons = {}
for name in unclassified:
    if name not in NEW:
        continue
    short = name.replace('Becoming.', '')
    if any(name.startswith(f'{M}.{w}.') or name == f'{M}.{w}' for w in WITNESS_SPACES):
        reasons[name] = ('model-witness', f'{short}: {WITNESS}')
    else:
        reasons[name] = ('general-structure', f'{short}: {GENERAL}')
others = [n for n in unclassified if n not in reasons]
assert not others, ("apart roots not registered here: read them; UE27's names are read by hand, another session's "
                    "belong to their owners", others)
t = F.read_text(encoding='utf-8')
block = ''
for name in unclassified:
    assert json.dumps(name, ensure_ascii=False) not in t, name
    cat, reason = reasons[name]
    block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "' + M + '",\n   "category": "' + cat
              + '",\n   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n')
if block:
    anchor = '  }\n },\n "instances": {'
    assert t.count(anchor) == 1
    t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
    json.loads(t)
    F.write_text(t, encoding='utf-8')
print('register: added', len(unclassified), unclassified)
