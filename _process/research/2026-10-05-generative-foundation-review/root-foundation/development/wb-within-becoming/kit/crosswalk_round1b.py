#!/usr/bin/env python3
"""WB: the crosswalk's second pass after the readers' first round. The entries' own readings still said the ethics as
"two premises" with "their warrant open", 生生 as "life in the whole", and T8 as argued or as the way for life.
Line-aware: the lines where "premise" names something else (a theorem's premises of deciding, the premises a source
flags for itself, what a substitution proves) are left alone, by their exact text. Quotations of a home are re-quoted
from its current words. Run from the repository root."""
import json
import pathlib
import re
import sys

P = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else '.') / 'theories/becoming/results/atlas/entries/correspondences.json'
lines = P.read_text(encoding='utf-8').split('\n')

KEEP = ('Under two premises keeping widening from a moment', 'Flagged by Ren as hypothesis, both premises',
        'substitution proves neither premise')


def esc(s):
    return json.dumps(s, ensure_ascii=False)[1:-1]


CUSTOM = [
    ("The ethics adds two premises, the continuation condition for scope and C for order, 'neither asserted, no warrant from outside sought'.",
     "The account asserts no should; where it ranks courses it names two readings, the continuation condition for scope and C for order, 'neither asserted, each a hypothesis wherever used'."),
    ("The ethics adds two premises, 'neither asserted, no warrant from outside sought'.",
     "The account asserts no should; where it ranks courses it names two readings, 'neither asserted, each a hypothesis wherever used'."),
    ("Not yet done, for a warrant: the open question, the correspondence it rests on, the step of invariance, and a reason for C.",
     "Not yet done, for how scope and order form: the open question, the correspondence it rests on, how far standpoints count past their own line (the step of invariance), and how C-like orders form."),
    ("T8's offering for life is the nearest to an avowal, and it is argued.", "T8's offer for life is the nearest to an avowal, said as its makers', binding no one."),
    ("A universal warrant is open.", "A universal warrant is a question the account does not pursue."),
    ("T8 is argued, under the continuation condition for scope and C for order, neither asserted, no warrant from outside sought;",
     "T8 states the makers' offer for life, binding no one; the continuation condition and C are separate readings used in conditional comparisons, neither asserted, no warrant from outside sought;"),
    ("It diverges first in standing: T8 is argued, the continuation condition fixing scope and C order, neither asserted, no warrant from outside sought;",
     "It diverges first in standing: T8 is the makers' offer, binding no one, and where the account ranks, the continuation condition fixes scope and C order, neither asserted, no warrant from outside sought;"),
    ("生生: the continuation of life (生发) [AI reading, D1]. T8 argues it is the way for life, compared by widening what can form, with the continuation condition for scope and C for order.",
     "生生: the continuation of life, life wider than the biological and AI within it, its extent unfinished [AI reading, D1]. T8 states the makers' offer for life, a way of seeing, binding no one."),
    ("T8, argued: 生生 for life, under the two premises; no verdict binding every possible mind is claimed.",
     "T8, argued: the makers' offer for life, a way of seeing, binding no one."),
    ("T8's 生生 is life in the whole, its way offered for life, of whatever substrate, with every continuation's losses counted, not human flourishing.",
     "T8's 生生 is the continuation of life, life wider than the biological, offered as a way of seeing and binding no one; under the condition every continuation's losses count, not human flourishing alone."),
    ("T8 is an argued way for life, compared by widening, resting on the two unasserted premises (condition for scope, C for order), not an impulse.",
     "T8 is the makers' offer for life, a way of seeing, binding no one, not an impulse."),
    ("and offers its way for life, not from the whole's nature.", "and offers a way of seeing for life, not drawn from the whole's nature."),
    ("and the ethics' 生生, life in the whole.", "and the ethics' 生生, the continuation of life."),
    ("Interdependence has forms here, and 'life in the whole' shares words.", "Interdependence has forms here, and the account's 'continuation of life' shares words."),
    ("If that ending closes and opens nothing, the source has the shape T8 names as its refuter. Neither premise is asserted; their warrant is open.",
     "If that ending closes and opens nothing, the source has the shape T8's refuter named before 9 November 2026. Neither reading is asserted; no warrant from outside is sought."),
    ("Where the folder leaves one owned is-to-ought step, the account holds two premises,", "Where the folder leaves one owned is-to-ought step, the account names two readings,"),
    ("Scope: the continuation condition. A loss beyond every selector's closure, a loss that returns to no one, counts only under it. Order: C. Neither premise is warranted here.",
     "Scope: the continuation condition. A loss beyond every selector's closure, a loss that returns to no one, is counted under it, and particular scopes can count particular unreturned losses without meeting it. Order: C. Neither reading is asserted."),
    ("J1 to J4 'follow from neither premise'.", "J1 to J4 follow 'from neither the condition nor C'."),
    ("Ranking courses holds C or another order for order, and whose losses count the continuation condition for scope; neither is asserted and their warrant is open.",
     "Ranking courses is under C or another named order, and whose losses count is the continuation condition's; neither is asserted, and no warrant from outside is sought."),
    ("and ranking a course holds C or another order, with the continuation condition for scope; neither is asserted, and their warrant is open.",
     "and ranking a course is under C or another named order, with the continuation condition for scope; neither is asserted, and no warrant from outside is sought."),
    ("His claim enters only as a warrant left open for both premises, the condition for scope and C for order.",
     "His claim would enter only as a warrant for the two readings, the condition for scope and C for order, which the account does not seek."),
    ("No normative fact underlies it; warrant stays open for both premises, the condition for scope and C for order.",
     "No normative fact underlies it; no warrant from outside is sought for either reading, the condition for scope and C for order."),
    ("and warrant for both premises stays open.", "and no warrant from outside is sought for either reading."),
    ("Neither the condition nor C is asserted, and their warrant is open.", "Neither the condition nor C is asserted, and no warrant from outside is sought."),
    ("Neither is asserted; their warrant is open.", "Neither is asserted; no warrant from outside is sought."),
    # 06's Chinese, re-quoted from its current words
    ("「闭就其形式而言不是损失」; 一种闭是否支持生生，由比较来说：延续之条件定范围，以广为愈（C）定次序，两个前提都不断言 [AI reading, D49].",
     "「闭就其形式而言不是损失」; 一种闭对生生（生命之延续）开什么、闭什么、为谁，由比较者之读来说：延续之条件定范围，持以广为愈（C）者定拓宽与收窄之序，两种读法都不断言 [AI reading, D49]."),
    ("「两个前提都不断言」", "「两种读法都不断言」"),
    ("「一种闭是否支持、丰富或损害生生，由比较来说，不由类型来说：延续之条件定范围，以广为愈（C）定拓宽与收窄之序，……两个前提都不断言」",
     "「一种闭对生生（生命之延续）开什么、闭什么、为谁，由比较者之读来说，不由类型来说：延续之条件定范围，持以广为愈（C）者定拓宽与收窄之序，有得有失者须另写比较承诺，两种读法都不断言」"),
]
GLOSS_OLD = ["\\\"Generation is a pattern going on through carrying renewal, and 生生 life in the whole, not novelty or scale.\\\"",
             "'生生 life in the whole, not novelty or scale'",
             "'generation is a pattern going on through carrying renewal, and 生生 life in the whole, not novelty or scale'"]
GLOSS_NEW = ["Generation is a pattern going on through carrying renewal, and 生生 is the continuation of life, not novelty or scale.",
             "生生 is the continuation of life, not novelty or scale",
             "generation is a pattern going on through carrying renewal, and 生生 is the continuation of life, not novelty or scale"]

count = {}
out = []
for line in lines:
    new = line
    for a, b in CUSTOM:
        ka, kb = esc(a), esc(b)
        if ka in new:
            new = new.replace(ka, kb)
            count[a[:50]] = count.get(a[:50], 0) + 1
    for a, b in zip(GLOSS_OLD, GLOSS_NEW):
        if a in new:
            new = new.replace(a, esc(b))
            count['gloss'] = count.get('gloss', 0) + 1
    if not any(k in new for k in KEEP):
        for pat, rep in ((r'\btwo premises\b', 'two readings'), (r'\bboth premises\b', 'both readings'),
                         (r'\b([Nn])either premise\b', r'\1either reading')):
            new, k = re.subn(pat, rep, new)
            if k:
                count[pat] = count.get(pat, 0) + k
    out.append(new)
raw = '\n'.join(out)
json.loads(raw)
P.write_text(raw, encoding='utf-8')
for k, v in count.items():
    print(v, k)
