#!/usr/bin/env python3
"""OG's landing (register_bd4.py's pattern): register the apart roots the connectivity check lists without a reason
that are OG's, each with a category and a reason; stop on any other root, which belongs to its owner, and on any
stale entry, which OG's change (one new instance module, no other module changed) does not explain.

The rehearsal (receipt 20261101T135208.604453Z, in scratch) listed nine. Every one is a fact about one constructed
family of models, or an arithmetic step: nothing on the base reads the reader family, as nothing reads the rooms.
The laws that the others use («供则读者不绝», «断而有储则读者存», «断则取于供者尽», «不复建者尽») are not roots.

usage (from the checkout root): python3 -B register_og.py CONNECTIVITY_LOG"""
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
assert not stale, ("stale entries OG's change does not explain: read them", stale)
FAMILY = 'a fact about one constructed family of models, the readers by where they are rebuilt from (OG)'
R = 'Becoming.ReaderRebuilding.'
REASONS = {
    R + '«以储买时当且仅当取于储»': ('model-witness',
        'The family law: over the four readers, at one unit wanted and a span of at least one, the stock buys time '
        'under a cut, with an end from an empty stock, exactly where the rebuild draws on the level: ' + FAMILY),
    R + '«供则读者之域闭»': ('model-witness',
        'The region where the reader rebuilt from the level is present is closed («闭») under the supplied step: '
        + FAMILY),
    R + '«读者绝则无储»': ('model-witness',
        'Where the reader rebuilt from the level is gone after a step, the level is empty: ' + FAMILY),
    R + '«取于储者绝而不复»': ('model-witness',
        'The reader rebuilt from the level, gone at an empty level, stays gone on every branch of the net, the supply '
        'on or off («闭» of that state): ' + FAMILY),
    R + '«取于供者复»': ('model-witness',
        'A reader rebuilt from the supply is present again after one supplied step: ' + FAMILY),
    R + '«一元二期之时»': ('model-witness',
        "One unit's horizon under a cut at a span of two, decided for the levels below fifteen: " + FAMILY),
    R + '«一元三期之时»': ('model-witness',
        "One unit's horizon under a cut at a span of three, decided for small levels: " + FAMILY),
    R + '«取于供者之时»': ('model-witness',
        'A reader of one unit rebuilt from the supply, at a span of three, ends at step three from every level, '
        'decided: ' + FAMILY),
    R + 'one_le_of_lt': ('support', 'an arithmetic lemma on the natural numbers, a statement using only the prelude (OG)'),
}
other = [x for x in unclassified if x not in REASONS]
assert not other, ("apart roots not OG's: their owners register them", other)
text = F.read_text(encoding='utf-8')
d = json.loads(text)
assert json.dumps(d, ensure_ascii=False, indent=1) + '\n' == text, 'the register is not in its usual form'
for k in sorted(unclassified):
    assert k not in d['roots'], k
    cat, reason = REASONS[k]
    assert cat in d['categories'], cat
    d['roots'][k] = {'module': 'Becoming.ReaderRebuilding', 'category': cat, 'reason': reason}
F.write_text(json.dumps(d, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('registered', len(unclassified), sorted(unclassified))
