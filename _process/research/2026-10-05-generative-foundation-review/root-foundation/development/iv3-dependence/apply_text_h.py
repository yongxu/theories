#!/usr/bin/env python3
"""IV3h: the independent review's fixes in the texts. THE-STEP-OF-INVARIANCE (§1 item 5, §4.4 bullets and paragraph,
§8 rows); D64 (items 7 and 11, a new item 12, Reasons, What would change it); the package README row (EN, ZH); study
§373 (one sentence, corrected in place) and the new study section.
usage (from the checkout root): python3 -B apply_text_h.py STUDY_SECTION RECEIPT"""
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
N, RECEIPT = int(sys.argv[1]), sys.argv[2]
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = ROOT / (RF + 'BECOMING-RENEWAL-READING.md')
CHOICES = ROOT / (RF + 'DELEGATED-CHOICES.md')
STEP = ROOT / 'theories/becoming/chapters/THE-STEP-OF-INVARIANCE.md'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
PENDING = {}


def text(path):
    return PENDING.get(path, path.read_text(encoding='utf-8'))


def insert_after(path, prefix, block):
    lines = text(path).split('\n')
    at = [i for i, line in enumerate(lines) if line.startswith(prefix)]
    assert len(at) == 1, (path.name, prefix[:60], len(at))
    PENDING[path] = '\n'.join(lines[:at[0] + 1] + block + lines[at[0] + 1:])


def replace_once(path, old, new):
    s = text(path)
    assert s.count(old) == 1, (path.name, old[:70], s.count(old))
    PENDING[path] = s.replace(old, new)


# ---- THE-STEP-OF-INVARIANCE ------------------------------------------------------------------------------
replace_once(STEP, "and centers that share one condition do (`Flow.centersWithin_feeding_of_common`). Drawn along need, it "
             "reaches a copy of what it needs only where the copy is the only one (`forced_member_iff_only`).",
             "and centers that each depend on one condition and exchange with it, or at one step each require it and give "
             "to it, do (`Flow.centersWithin_influence_of_common`, `Flow.centersWithin_feeding_of_common`). Drawn along "
             "need, where each copy could carry the need alone, it reaches a copy of what it needs only where the copy is "
             "the only one (`forced_member_iff_only`).")
replace_once(STEP, "and it needs a given feeder's giving exactly where that feeder is the only one able to feed the family "
             "alone (`Flow.needs_giver_iff_only`;",
             "and, where each member can feed the family alone, it needs a given feeder's giving exactly where that feeder "
             "is the only member (`Flow.needs_giver_iff_only`;")
replace_once(STEP, "needs a member's giving where, at some step calling for giving, that member is the only one active "
             "(`Flow.needs_giver_iff_alone`).",
             "needs a member's giving where, at some step calling for giving, no other member is active "
             "(`Flow.needs_giver_iff_alone`), which includes, vacuously, a step at which none is active.")
replace_once(STEP, "so drawing past what the whole hierarchy holds needs giving into its top (`Flow.needsSome_tiers`;",
             "so drawing past what the whole hierarchy holds needs some member of the class feeding its top "
             "(`Flow.needsSome_tiers`;")
replace_once(STEP, "Drawn along need, self-concern reaches what feeds its feeders, up to what feeds the top of every hierarchy "
             "it draws past.",
             "Read as reach, self-concern drawn along need extends to what feeds its feeders, up to what feeds the top of a "
             "hierarchy fed only from above that it draws past; for need with two readings, which is not its own closure, "
             "this is the AI's reading, not a theorem.")
replace_once(STEP, "and where it can give each, some possible flow has it give exactly that (`Flow.least_giving`): the least "
             "it gives is its degree of need, and need is a positive degree (`Flow.needs_giver_iff_shortfalls_pos`).",
             "and wherever some possible flow lets the consumer draw past the stock, some has it give exactly that "
             "(`Flow.least_giving_of_possible`): the least it gives is its degree of need, and need is a positive degree "
             "(`Flow.needs_giver_iff_shortfalls_pos`). A flow is possible exactly where the class can give each step's "
             "demand; elsewhere every member is needed vacuously (`Flow.possible_iff_covers`).")
replace_once(STEP, "Drawn along need, self-concern reaches a feeder in degree: for what the others cannot give, and only for "
             "that.",
             "Read as reach, self-concern drawn along need extends to a feeder in degree: for what the others cannot give, "
             "and only for that.")
replace_once(STEP, "or none that with the rest could give what they draw:",
             "or none that with the rest could give what each step demands:")
replace_once(STEP, "Nor does it stop at the conditions people draw on directly: what feeds those, up to whatever enters at "
             "the top of a hierarchy they draw past, is reached too (`Flow.needsSome_tiers`).",
             "Read as reach, it does not stop at the conditions people draw on directly: drawing past what a hierarchy fed "
             "only from above holds needs giving into its top (`Flow.needsSome_tiers`).")
replace_once(STEP, "a center that makes itself independent of a common condition leaves the common closure",
             "a center that makes itself independent of a common condition may leave the common closure")
replace_once(STEP, "within one another's closures; centers sharing one condition do |",
             "within one another's closures; centers that each depend on one condition and exchange with it do |")
replace_once(STEP, "| Need over any courses with two readings; a member needed exactly where it is the only one |",
             "| Need over any courses with two readings; where each can take its part alone, a member needed exactly where "
             "it is the only one |")
replace_once(STEP, "| On the base, drawing past a family's stock needs some feeder's giving, and a feeder's exactly where it "
             "is the only one |",
             "| On the base, drawing past a family's stock needs some feeder's giving, and, where each can feed alone, a "
             "feeder's exactly where it is the only one |")
replace_once(STEP, "| A feeder is needed exactly where, at some step calling for giving, it is the only one active |",
             "| A feeder is needed exactly where, at some step calling for giving, no other member is active |")
replace_once(STEP, "| A feeder is needed in degree: the least it gives while the consumer draws past the stock is the sum of "
             "its shortfalls | `Web.shortfall`, `Flow.shortfalls_le_given`, `Flow.least_giving`,",
             "| A feeder is needed in degree: wherever a flow is possible, the least it gives while the consumer draws past "
             "the stock is the sum of its shortfalls | `Web.shortfall`, `Flow.shortfalls_le_given`, `Flow.least_giving`, "
             "`Flow.least_giving_of_possible`,")
insert_after(STEP, '| A feeder is needed in degree: wherever a flow is possible,', [
    '| Some flow lets the consumer draw past the stock exactly where the class can give each step\'s demand, elsewhere '
    'every need vacuous; drawing without end needs giving without end | `Flow.possible_iff_covers`, `needsPart_of_none`, '
    '`Flow.able_of_covers`, `Flow.needsSome_without_end`, `FeedersInTurn.possible` | `Becoming.Weightings` | landed |',
])

# ---- D64 ---------------------------------------------------------------------------------------------------
replace_once(CHOICES, "being able to feed the family alone as being active at every step calling for giving "
             "(`Flow.partAlone_on`); and copies as a matter of the steps, a feeder needed where it alone is active at a "
             "step calling for giving (`Flow.needs_giver_iff_alone`;",
             "being active at every step calling for giving as enough to feed the family alone (`Flow.partAlone_on`); and "
             "copies as a matter of the steps, a feeder needed where no other member is active at a step calling for "
             "giving (`Flow.needs_giver_iff_alone`;")
replace_once(CHOICES, "A feeder's degree of need is read as the least it gives while the consumer draws past the stock, the "
             "sum of what each step demands beyond what the others can give (`Flow.least_giving`).",
             "A feeder's degree of need is read as the least it gives while the consumer draws past the stock, the sum of "
             "what each step demands beyond what the others can give, wherever some flow lets the consumer draw past it "
             "(`Flow.least_giving_of_possible`).")
insert_after(CHOICES, '11. **Need in degree.**', [
    '12. **Possible courses.** That some flow lets the consumer draw past the stock is read off the web: exactly where the '
    'class can give each step\'s demand (`Flow.possible_iff_covers`). Where none does, need holds vacuously '
    '(`needsPart_of_none`) and is not read as need: no reading here rests on a vacuous need '
    f'(study section {N}, IV3h).',
])
replace_once(CHOICES, "and they part exactly at copies, as transmission to facilitative and to necessary means part in the "
             "theory of reasons.",
             "and they part where the others could together give what a feeder gives (in `SharedCopies` no copy can feed "
             "alone, yet none is needed), as transmission to facilitative and to necessary means part in the theory of "
             "reasons.")
replace_once(CHOICES, "A representation of need with weights, under which a copy is needed in degree and the class's "
             "continuation is stated.",
             "A representation of the class's continuation as a whole; need in degree is now stated (item 11).")

# ---- the package README row (EN, ZH) ------------------------------------------------------------------------
EN = PKG / 'README.md'
for old, new in [
    ("within one another's closures, and centers sharing one condition do (",
     "within one another's closures, and centers that each depend on one condition and exchange with it do ("),
    ("drawn along need it reaches a copy only where the copy is the only one (`forced_needs_iff`",
     "drawn along need, where each copy can carry it alone, it reaches a copy only where the copy is the only one "
     "(`forced_needs_iff`"),
    ("need over any courses with two readings, a member needed exactly where it is the only one (`needsPart_iff_only`)",
     "need over any courses with two readings, where each can take its part alone a member needed exactly where it is "
     "the only one (`needsPart_iff_only`)"),
    ("needs some feeder's giving, and a feeder's exactly where it is the only one (`Flow.needsSome_of_drawsPast`",
     "needs some feeder's giving, and, where each can feed alone, a feeder's exactly where it is the only one "
     "(`Flow.needsSome_of_drawsPast`"),
    ("exactly where, at some step calling for giving, it is the only one active (`Web.CallsForGiving`",
     "exactly where, at some step calling for giving, no other member is active (`Web.CallsForGiving`"),
    ("a feeder can feed a family alone exactly where its capacity covers each step's demand, and it is needed",
     "a feeder can feed a family alone exactly where, at every step calling for giving, it is active and its capacity "
     "covers the demand, and it is needed"),
    ("a feeder's degree of need, the least it gives while the consumer draws past the stock, is the sum of what each "
     "step demands beyond what the others can give (`Flow.least_giving`, `Capacities.second_in_degree`)",
     "some flow lets the consumer draw past the stock exactly where the class can give each step's demand, every need "
     "holding vacuously elsewhere, and wherever one does a feeder's degree of need, the least it gives, is the sum of "
     "what each step demands beyond what the others can give (`Flow.possible_iff_covers`, "
     "`Flow.least_giving_of_possible`, `Capacities.second_in_degree`)"),
]:
    replace_once(EN, old, new)
ZH = PKG / 'README.zh.md'
for old, new in [
    ("自我关切恰在诸中心彼此位于对方闭包之内处对每个立场都相同，共有一个条件的诸中心即如此（",
     "自我关切恰在诸中心彼此位于对方闭包之内处对每个立场都相同，各自依存于同一条件并与之交换的诸中心即如此（"),
    ("沿“所需”来画，它只在某个副本是唯一者时达到该副本（",
     "沿“所需”来画，在每个副本都能单独承担所需时，它只在某个副本是唯一者时达到该副本（"),
    ("任意进程与两种读法的“所需”，某成员恰在其为唯一者时被需要（",
     "任意进程与两种读法的“所需”，在每个成员都能单独担当其部分时，某成员恰在其为唯一者时被需要（"),
    ("需要某个供给者的给予，恰在某供给者为唯一者时需要它的给予（",
     "需要某个供给者的给予；在每个都能单独供给时，恰在某供给者为唯一者时需要它的给予（"),
    ("而消耗者恰在某个需要给予的步上某供给者是唯一活跃者时需要它的给予（",
     "而消耗者恰在某个需要给予的步上没有其他成员活跃时需要某供给者的给予（"),
    ("供给者恰在其容量覆盖每个需要给予之步的需求时能单独供给该族",
     "供给者恰在每个需要给予之步上都活跃且其容量覆盖需求时能单独供给该族"),
    ("供给者被需要的程度，即消耗者汲取超出存量时它至少要给的，是每步需求超出其余者合起来能给者之和（`Flow.least_giving`、"
     "`Capacities.second_in_degree`）",
     "恰在该类能给出每步需求之处，某个流使消耗者汲取超出存量，别处一切“所需”都是空真的；凡有这样的流，供给者被需要的程度，即它至少要给的，"
     "是每步需求超出其余者合起来能给者之和（`Flow.possible_iff_covers`、`Flow.least_giving_of_possible`、"
     "`Capacities.second_in_degree`）"),
]:
    replace_once(ZH, old, new)

# ---- the study: §373 corrected in place, then the new section ------------------------------------------------
replace_once(STUDY, "C's premise is then self-concern's monotonicity in its own continuation, so scope and order both rest "
             "on one premise, self-concern monotone in what carries it.",
             "C's premise is then self-concern's monotonicity in its own continuation: scope rests on the self's "
             "presupposition drawn along what carries it, and order on that monotonicity, two premises with their two "
             f"roles (corrected in §{N}).")
st = text(STUDY)
assert '(IV3h)' not in st
last = max(int(m) for m in re.findall(r'^## (\d+)\. ', st, re.M))
assert N == last + 1, ('section number', N, last)
R = json.loads((PKG / 'becoming-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed'
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.Weightings')
sec = (HERE / 'study_iv3h.txt').read_text(encoding='utf-8')
sec = (sec.replace('## {N}.', f'## {N}.').replace('RECEIPT_ID', RECEIPT)
       .replace('THEOREMS', str(mod['theorems'])).replace('DECLS', str(len(mod['declarations']))))
assert '{N}' not in sec and 'THEOREMS' not in sec and 'DECLS' not in sec
PENDING[STUDY] = st.rstrip('\n') + '\n\n' + sec.rstrip('\n') + '\n'

for path, s in PENDING.items():
    path.write_text(s, encoding='utf-8')
    print('wrote', path.relative_to(ROOT))
