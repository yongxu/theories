#!/usr/bin/env python3
"""SJ1's landing (register_el.py's pattern): register the apart roots the connectivity check lists without a reason
that are SJ1's, each with a category and a reason; stop on any other root, which belongs to its owner, and on any
stale entry, which SJ1's change (one leaf, Viability's two kernel laws re-proved with their statements unchanged)
does not explain and is read first.

The categories follow the grammar's entries (GrammarLaws, GrammarCandidates): a law of every relation on any carrier
that nothing on the base uses is general structure; a constructed relation is a model witness; a one-line unpacking
of the grammar's definitions is support. The kernel's three parts are used by Viability, which reaches the base, so
they are expected to be connected; they are listed in case a part is not.

Textual edits, the rest of the file byte for byte (register_el.py's pattern).
usage (from the checkout root): python3 -B register_sj.py CONNECTIVITY_LOG"""
import json
import re
import sys
from pathlib import Path

F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
log = Path(sys.argv[1]).read_text(encoding='utf-8')
m = re.search(r"apart roots without a reason in [^:]+: (\[[^\]]*\])", log)
unclassified = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]
stale = re.search(r"register entries no longer apart roots: (\[[^\]]*\])", log)
stale = [] if not stale else [s.strip().strip("'\"") for s in stale.group(1).strip('[]').split(',') if s.strip()]
assert not stale, ("stale entries SJ1's change does not explain: read them", stale)

M, G, W, S = 'Becoming.CommonResponse', 'general-structure', 'model-witness', 'support'
LAW = ('a law of every reading and requirement on any carrier (SJ1, 共应 on the grammar); the models state the rule '
       'form with choice or the one-act form at their own carriers, so nothing on the base uses this one')
KERNEL = ("the grammar's kernel, a law of every relation on any carrier (SJ1); Viability's kernel laws are proved "
          'from it at a process\'s steps through Viability.kernel_iff_held')
UNPACK = "a one-line unpacking of the grammar's definitions and of this module's «共应» (SJ1)"
WIT = "a fact about one constructed reading and requirement: a witness that a hypothesis of SJ1's laws does work (SJ1)"
B, E = 'Becoming.', 'Becoming.«共应之例».'
REASONS = {
    B + '«所闭之承最大»': (M, G, "the grammar's kernel stated as one law, the conjunction of its three parts, for "
                       'every relation on any carrier (SJ1); Viability\'s kernel laws use the parts at a process\'s steps '
                       'through Viability.kernel_iff_held, and nothing uses the conjunction itself'),
    B + '«所闭之承在内»': (M, G, KERNEL),
    B + '«所闭之承闭»': (M, G, KERNEL),
    B + '«闭在内则在所闭之承»': (M, G, KERNEL),
    B + '«共应当且仅当所闭之承遍»': (M, G, 'a common response exists exactly where the acts\' kernels cover the '
                                 'situations: ' + LAW),
    B + '«自反传递则共应当且仅当承遍»': (M, G, 'for a reflexive and transitive reading, along the reading itself: ' + LAW),
    B + '«诸承在内当且仅当自反»': (M, G, 'what holds at every situation alike lies inside every region exactly where '
                                'the reading is reflexive: a law of every relation on any carrier (SJ1)'),
    B + '«诸承闭当且仅当传递»': (M, G, 'what holds at every situation alike is closed for every region exactly where '
                              'the reading is transitive: a law of every relation on any carrier (SJ1)'),
    B + '«自反则承在内»': (M, S, UNPACK),
    B + '«传递则承闭»': (M, S, UNPACK),
    B + '«闭在内则在承»': (M, S, UNPACK),
    B + '«共应之细»': (M, S, UNPACK),
    B + '«依读而应则共应»': (M, S, UNPACK),
    B + '«静之共应当且仅当遍»': (M, G, 'under staying the same a common response exists exactly where the requirement '
                              'covers every situation: ' + LAW),
    B + '«一之共应当且仅当一应遍»': (M, G, 'under the reading that tells nothing apart, on an inhabited carrier, exactly '
                                'where one act meets the requirement everywhere: ' + LAW),
    B + '«应际同行当且仅当同读同应»': (M, G, 'the response relation goes alike across a map\'s sameness exactly where '
                                  'situations read alike have the same act: ' + LAW),
    B + '«遍定应共应当且仅当同读同应»': (M, G, 'with one act at each situation, a common response over a map\'s sameness '
                                   'exactly where situations read alike have the same act: ' + LAW),
    B + '«遍定应共应当且仅当像定后»': (M, G, 'with one act at each situation, a common response exactly where the image '
                                  'of the response relation along the map has a fixed successor, through the lumping '
                                  'law: ' + LAW),
    B + '«映应共应当且仅当同读同应»': (M, G, 'at an act map, a common response exactly where situations read alike get '
                                  'the same act, Learning.Lumped unfolded: ' + LAW),
}
for name in ('NotReflexive.trans', 'NotReflexive.held_each', 'NotReflexive.none', 'NotTransitive.refl',
             'NotTransitive.symm', 'NotTransitive.held_each', 'NotTransitive.none', 'EachNotCommon.each',
             'EachNotCommon.none', 'PairsNotCommon.pairs', 'PairsNotCommon.none', 'NotCovering.fixed',
             'NotCovering.none', 'NotOne.common', 'NotOne.differ', 'OneCarrier.fixed', 'OneCarrier.none'):
    REASONS[E + name] = (M, W, WIT)
others = [n for n in unclassified if n not in REASONS]
assert not others, ("apart roots not registered here: read them; another session's belong to their owners", others)
t = F.read_text(encoding='utf-8')
block = ''
for name in unclassified:
    assert json.dumps(name, ensure_ascii=False) not in t, name
    module, cat, reason = REASONS[name]
    block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "' + module + '",\n   "category": "'
              + cat + '",\n   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n')
if block:
    anchor = '  }\n },\n "instances": {'
    assert t.count(anchor) == 1
    t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
    json.loads(t)
    F.write_text(t, encoding='utf-8')
missing = sorted(set(REASONS) - set(unclassified))
print('register: added', len(unclassified), '; listed here but not apart roots now:', missing)
