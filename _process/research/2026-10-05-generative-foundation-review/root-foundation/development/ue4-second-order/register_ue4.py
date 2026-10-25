#!/usr/bin/env python3
"""UE4: register the apart roots of Becoming.EventualWidening and Becoming.EventualWideningInstances that connectivity
lists without a reason, each with a category and a reason; textual edits, the rest of the file byte for byte (UE1's
register_ue1.py).
usage (from the checkout root): python3 -B register_ue4.py CONNECTIVITY_LOG"""
import json
import re
import sys
from pathlib import Path

F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
log = Path(sys.argv[1]).read_text(encoding='utf-8')
m = re.search(r"apart roots without a reason in [^:]+: (\[[^\]]*\])", log)
unclassified = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]

MODULE = 'Becoming.EventualWidening'
INSTANCES = 'Becoming.EventualWideningInstances'
# every declaration of the two modules (the kit's scratch audit), so that a root is placed in its own module
DECLS = {
    MODULE: '''Web.after Web.tailFrom Web.EventuallyWidens Web.IncludesFrom Web.ExceedsLate Web.WidensWithoutEnd
        Web.WidensUpTo Web.WidensOrEventually Web.Includes.after Web.EventuallyWidens.irrefl Web.EventuallyWidens.trans
        Web.EventuallyWidens.not_reverse Web.eventuallyWidens_iff Web.ExceedsLate.exceeds Web.Includes.not_exceedsLate
        Web.EventuallyWidens.not_included Web.Widens.not_eventually_reversed Web.Includes.trans_eventually
        Web.EventuallyWidens.trans_includes Web.WidensOrEventually.irrefl Web.WidensOrEventually.trans
        Web.WidensWithoutEnd.widens Web.WidensWithoutEnd.eventually Web.EventuallyWidens.of_agree_left
        Web.EventuallyWidens.of_agree_right Web.eventually_of_vanishing Web.IncludesAcrossFrom Web.KeepsOpening
        Web.KeepsWidening Web.AdmitsAlikeFrom Web.KeepsWidening.later Web.keepsWidening_reidentify
        Web.KeepsWidening.gathers Web.KeepsWidening.not_listed Web.KeepsOpening.eventually_widens
        Web.KeepsWidening.eventually_widens_of_within'''.split(),
    INSTANCES: '''Web.splice Web.splice_before Web.splice_from Web.eventually_dense Web.not_eventually_dense
        Web.eventually_neither Web.eventually_insulated Web.stepBound Web.lt_stepBound Web.not_eventually_of_listed
        Flow.OpenedByOpened Flow.OpenedByOpened.not_of_unsupported'''.split(),
}
WITNESS_SPACES = ('OwnCondition.', 'LagWitness.', 'MergedWitness.', 'OpeningChain.', 'Saturated.', 'ClosedCycle.')
FULL = {module: {'Becoming.' + s for s in shorts} for module, shorts in DECLS.items()}


def module_of(name):
    for module, full in FULL.items():
        if name in full:
            return module
    if name.startswith(tuple('Becoming.' + w for w in WITNESS_SPACES)):
        return INSTANCES
    return None


mine = [n for n in unclassified if module_of(n)]
others = [n for n in unclassified if not module_of(n)]
assert not others, ('apart roots of other modules unclassified; not UE4\'s to register', others)

W = 'a witness of eventual widening, keeping widening or what carries a widening (Becoming.EventualWideningInstances, UE4)'
LAW = ('a law of eventual widening (widening read on late tails) or of keeping widening; the base states no comparison '
       'in the long run, so nothing on it uses this law (a leaf tool until a gain or giver law imports it, UE4)')
FRAME = ('an instance of chapter 03\'s density laws on the sequences of levels (eventual widening dense both ways, '
         'neither verifiable nor refutable, insulable); nothing on the base uses it (UE4)')
LISTED = ('where the weighting characterization of C is silent: a course whose admissions are listed eventually widens '
          'nothing; nothing on the base uses it (UE4)')
CARRIER = ('a law of the provisional property of what carries a widening (opened by the opened); the base states no such '
           'property, so nothing on it uses this law (UE4)')
SUPPORT_UNPACK = 'a one-line unpacking of the module\'s own definitions'
support_unpack = {'Web.splice_before', 'Web.splice_from', 'Web.lt_stepBound', 'Web.Includes.after',
                  'Web.ExceedsLate.exceeds', 'Web.Includes.not_exceedsLate'}
frame = {'Web.eventually_dense', 'Web.not_eventually_dense', 'Web.eventually_neither', 'Web.eventually_insulated'}


def classify(name):
    short = name[len('Becoming.'):]
    if short.startswith(WITNESS_SPACES):
        return 'model-witness', W
    if short in support_unpack:
        return 'support', SUPPORT_UNPACK
    if short in frame:
        return 'general-structure', FRAME
    if short == 'Web.not_eventually_of_listed':
        return 'general-structure', LISTED
    if short.startswith('Flow.OpenedByOpened'):
        return 'general-structure', CARRIER
    return 'general-structure', LAW


t = F.read_text(encoding='utf-8')
block = ''
for name in mine:
    assert json.dumps(name, ensure_ascii=False) not in t, name
    cat, reason = classify(name)
    block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "' + module_of(name) + '",\n   "category": "'
              + cat + '",\n   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n')
if block:
    anchor = '  }\n },\n "instances": {'
    assert t.count(anchor) == 1
    t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
    json.loads(t)
    F.write_text(t, encoding='utf-8')
print('register: added', len(mine), {c: sum(1 for n in mine if classify(n)[0] == c) for c in
                                      ('general-structure', 'support', 'model-witness')})
