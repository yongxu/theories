#!/usr/bin/env python3
"""OG2's landing (register_og.py's pattern): register the apart roots the connectivity check lists without a reason
that are OG2's, each with a category and a reason; stop on any other root, which belongs to its owner, and on any
stale entry, which OG2's change (one new instance module, no other module changed) does not explain.

The rehearsal (receipt 20261102T152409.016828Z, in scratch) listed twenty-nine. Twenty-eight are facts about one
constructed family of models, or witnesses at one of its rules, and one is a count on lists: nothing on the base reads
the family, as nothing reads the rooms or the readers.

usage (from the checkout root): python3 -B register_og2.py CONNECTIVITY_LOG"""
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
assert not stale, ("stale entries OG2's change does not explain: read them", stale)
FAMILY = 'a fact about one constructed family of models, the rules kept by tenure and by who teaches entrants (OG2)'
WITNESS = 'a witness at one rule of the family of rules kept by tenure and by who teaches entrants (OG2)'
R = 'Becoming.RuleRebuilding.'
REASONS = {
    R + 'count_total': ('support', 'a count on lists of booleans, held plus empty is the length, a statement using only the prelude (OG2)'),
    R + 'run_gone': ('model-witness', 'A state with no level, holder or other stays so along every course: ' + FAMILY),
    R + '«三源之表»': ('model-witness', 'After an empty membership, at a level of at least one, with entrants on offer: taught from outside the rule has holders after one step, taught by members or not at all it has none: ' + FAMILY),
    R + '«及任之前持尽之例»': ('model-witness', 'Held at the start and no holder after a tenure, the premise of the law of draining met: ' + WITNESS),
    R + '«同规随类»': ('model-witness', 'One step with a revision inside the region continues under the class "held or not" and not under the class "the same quota", the grammar\'s continuation («续») relative to a class at these occurrences: ' + WITNESS),
    R + '«四境皆有»': ('model-witness', 'Each of the four cases of the steady state and open entry taking within the renewal occurs: witnesses at four rules of the family of rules kept by tenure and by who teaches entrants (OG2)'),
    R + '«域中任满皆新»': ('model-witness', 'In the region, with entrants on offer at every step, after a tenure the holders are exactly the cohorts entered in it: ' + FAMILY),
    R + '«域中储不减»': ('model-witness', 'The level does not fall on a step within the region: ' + FAMILY),
    R + '«外授之稳同带»': ('model-witness', 'Taught from outside, where a teacher\'s age falls within the tenure, the steady state stays held exactly on the same band: ' + FAMILY),
    R + '«带一至五»': ('model-witness', 'The band of quotas is one to five: ' + WITNESS),
    R + '«带不定改后»': ('model-witness', 'Five computed cases: two quotas in the band do not bound what a revision between them does: witnesses at three rules of the family of rules kept by tenure and by who teaches entrants (OG2)'),
    R + '«带唯二»': ('model-witness', 'The band of quotas is exactly two: ' + WITNESS),
    R + '«带无»': ('model-witness', 'The band of quotas is empty though a teacher\'s age falls within the tenure: ' + WITNESS),
    R + '«开存而稳不存之式»': ('model-witness', 'Where open entry takes within the renewal and the steady state does not, the quota exceeds those who would come untaught, or the door turns no one away: ' + FAMILY),
    R + '«弃而储增»': ('model-witness', 'With no one coming untaught, a quota of nothing and a renewal, after a tenure there is no member and the level has risen: ' + WITNESS),
    R + '«改而成隙则尽»': ('model-witness', 'A revision out of the band and back leaves gaps in the membership, and the level then ends along the same rule: ' + WITNESS),
    R + '«改额为零则持尽»': ('model-witness', 'Taught by members, a revision to nothing with no later revision to a nonzero quota leaves no holder a tenure after it: ' + FAMILY),
    R + '«无持者改不行»': ('model-witness', 'A revision without a holder leaves the quota as it was: ' + FAMILY),
    R + '«无持者额不与»': ('model-witness', 'Two states with no holder differing only in quota have the same later levels and members along every course: ' + FAMILY),
    R + '«无持而门开众在»': ('model-witness', 'With no holder, others are present after every step of open entry that takes within the renewal: ' + FAMILY),
    R + '«稳为域之例»': ('model-witness', 'The steady state is a case of the region: ' + FAMILY),
    R + '«稳存而开不存则门过一»': ('model-witness', 'Where the steady state takes within the renewal and open entry does not, a keeper turns away more than itself: ' + FAMILY),
    R + '«稳存而隙不存»': ('model-witness', 'Gaps can end the level, the rule held to the last state, where the steady state goes on: ' + WITNESS),
    R + '«稳存而隙不存之式»': ('support', 'an arithmetic form on the natural numbers behind the witness that gaps can end what the steady state keeps, a statement using only the prelude (OG2)'),
    R + '«稳开二试»': ('model-witness', 'Taught by members, the steady state goes on exactly where its take fits the renewal, and open entry exactly where its own does, and otherwise each ends: ' + FAMILY),
    R + '«稳者恒持当且仅当在带»': ('model-witness', 'Taught by members, the steady state stays held exactly on the band: ' + FAMILY),
    R + '«隙存而稳不存»': ('model-witness', 'Gaps can hold a quota that the steady state cannot: ' + WITNESS),
    R + '«隙存而稳不存之式»': ('support', 'an arithmetic form on the natural numbers behind the witness that gaps can hold what the steady state cannot, a statement using only the prelude (OG2)'),
    R + '«额小而不足者门必过一»': ('model-witness', 'Where a keeper turns away at most itself, every quota of at least one below one in the band is in the band: ' + FAMILY),
}
other = [x for x in unclassified if x not in REASONS]
assert not other, ("apart roots not OG2's: their owners register them", other)
text = F.read_text(encoding='utf-8')
d = json.loads(text)
assert json.dumps(d, ensure_ascii=False, indent=1) + '\n' == text, 'the register is not in its usual form'
for k in sorted(unclassified):
    assert k not in d['roots'], k
    cat, reason = REASONS[k]
    assert cat in d['categories'], cat
    d['roots'][k] = {'module': 'Becoming.RuleRebuilding', 'category': cat, 'reason': reason}
F.write_text(json.dumps(d, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('registered', len(unclassified), sorted(unclassified))
