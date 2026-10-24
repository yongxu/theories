#!/usr/bin/env python3
"""IV3k: need and feeding read with time, and chapter 7 led by the structure, in the texts. 07-SIGNIFICANCE (the thesis
line and §1 in SW's order; §4.3 the new record's home and the planetary reading read with time); D64 items 1, 5 and 14;
the package README row (EN, ZH); regions.json; the study section.
usage (from the checkout root): python3 -B apply_text_k.py STUDY_SECTION RECEIPT"""
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
HOME = ROOT / 'theories/becoming/chapters/07-SIGNIFICANCE.md'
REGIONS = ROOT / 'theories/becoming/results/data/regions.json'
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


replace_once(HOME, "**Thesis.** Dynamics do not entail significance: where there is a standpoint and a formation, no statement "
             "reading only the dynamics and holding of some dynamics entails the continuation condition. With no premise,",
             "**Thesis.** Read as lying within what a center continues with along a relation, the continuation condition is "
             "a statement about relations: held de se along a relation, it holds exactly where every center's closure under "
             "that relation is the whole (`ownClosure_unrestricted_iff`), and on the root it is `«续无外»` at the one of that "
             "relation ([§4.5](#r-the-continuation-condition-on-the-root)). What the represented dynamics leave open is which "
             "relation, or which class, is a center's own. Supplied instead as a free predicate, significance is fixed by no "
             "statement about the dynamics: where there is a standpoint and a formation, no statement reading only the "
             "dynamics and holding of some dynamics entails the condition, by construction of the representation "
             "([§1](#r-what-the-dynamics-leave-open)). With no premise,")
insert_after(HOME, "**Definition.** A *significance* `sig` says, for a standpoint `p`, a step `t` and a formation `f`", [
    "",
    "The definition ties `sig` to no region: it admits any predicate on standpoints, steps and formations, including one "
    "that no center's region bounds. Tied to a center's region, held de se as what lies within the center's closure "
    "along a relation (`selfAscribed (ownClosure rel) center`, [§4.2](#r-what-the-step-across-standpoints-reaches)), the "
    "condition reads only that relation and the centers (`ownClosure_unrestricted_iff`), and on the root it is `«续无外»` "
    "([§4.5](#r-the-continuation-condition-on-the-root)). The theorem below concerns the untied parameter.",
])
insert_after(HOME, "A step *calls for giving* where a condition of the family rises or none falls. Witnesses:", [
    "",
    '<a id="r-need-and-feeding-read-with-time"></a>',
    "**Theorem** (World). *Need and feeding, read with time.* Over any flows read off a web in which only active "
    "formations give, a formation active at no step of the stretch is needed exactly where no such flow lets the consumer "
    "draw past the stock (`Flow.needs_iff_none_of_inactive`; across two tiers, for giving into the hierarchy, "
    "`Flow.needs_into_iff_none_of_inactive`): need reaches only what is active within the stretch it is read across, and "
    "nothing active only after it, while a consumer drawing without end needs giving without end "
    "(`Flow.needsSome_without_end`). Read with time, each link no later than the one it feeds (`Flow.FedUpTo`), a "
    "formation's feeding closure up to a step holds, besides it, only what takes part and gives at some step up to that "
    "one, so, where only active formations give, only what is active by then (`Flow.WithinFeedingUpTo`, "
    "`Flow.gives_of_withinFeedingUpTo`, `Flow.active_of_withinFeedingUpTo`); it lies within the feeding closure read "
    "across every step (`Flow.withinFeeding_of_upTo`). That closure can run past the end of what it carries: of three "
    "formations overlapping in turn, the last, feeding the middle one after the first has ended, lies within the first's "
    "feeding closure but not within that closure read with time up to the first's last step, which holds the middle one, "
    "and the first, drawing past its condition's stock across its two steps, does not need the last's giving, though the "
    "last is among its possible feeders (`Overlapping.closure_overreaches`). "
    "([record](../results/records/need-and-feeding-read-with-time.md))",
])
replace_once(HOME, "if so, every human being's self-concern, held de se and drawn along what carries it, has one scope there. "
             "Whether they do is empirical.",
             "if so, every human being's self-concern, held de se and drawn along what carries it, has one scope there. "
             "Whether they do is empirical. Read with time, that scope is among those whose lives overlap: need reaches only "
             "what is active within the stretch of the continuation it carries, and a feeding closure up to a step only what "
             "gives by then; read across every step, the closure runs forward through overlapping lives to those after, whom "
             "no continuation in it needs ([above](#r-need-and-feeding-read-with-time)). What comes after every present "
             "center is reached by a line under a class that goes on past one's end ([§4.5](#r-reach-past-ones-own-end)) or "
             "by the step.")

replace_once(CHOICES, "whether it is the right relation is argued in THE-STEP-OF-INVARIANCE §4.4.",
             "whether it is the right relation is argued in THE-STEP-OF-INVARIANCE §4.4. Feeding is read with time (item 14).")
replace_once(CHOICES, "have no second copy, is an empirical reading, not a theorem.",
             "have no second copy, is an empirical reading, not a theorem. Read with time, the scope it gives is shared among "
             "those whose lives overlap, not over those who come after (item 14).")
insert_after(CHOICES, "13. **Two tiers.** Across two tiers, lower members passing on what they take from their own stores", [
    "14. **Need and feeding, read with time.** Need is read across the stretch of the continuation it carries: a "
    "formation active at no step of it is needed only where nothing lets the continuation go on "
    "(`Flow.needs_iff_none_of_inactive`), so need does not reach past the end of what it carries, while a continuation "
    "without end needs giving without end (`Flow.needsSome_without_end`). The feeding closure that carries a continuation "
    "is read with time, each link no later than the one it feeds (`Flow.WithinFeedingUpTo`); read across every step, the "
    "closure runs forward through lives overlapping in turn to formations no continuation in it needs "
    "(`Overlapping.closure_overreaches`), and no reading here takes that run as carrying. What lies after every present "
    "center's end is reached by a line under a class that goes on past it (07 §4.5) or by the step "
    f"(study section {N}, IV3k).",
])
replace_once(PKG / 'README.md', "`Routing.lone_router_needed`, `Routing.rise_needs_top`); the readings are the AI's",
             "`Routing.lone_router_needed`, `Routing.rise_needs_top`); read with time, need reaches only what is active "
             "within the stretch it is read across, and a feeding closure up to a step only what gives by then, while the "
             "closure read across every step can run past the end of what it carries (`Flow.needs_iff_none_of_inactive`, "
             "`Flow.gives_of_withinFeedingUpTo`, `Overlapping.closure_overreaches`); the readings are the AI's")
replace_once(PKG / 'README.zh.md', "`Routing.lone_router_needed`、`Routing.rise_needs_top`）；读法是 AI 的",
             "`Routing.lone_router_needed`、`Routing.rise_needs_top`）；带着时间来读，所需只达到在其所读区间内活跃者，至某步的供养闭包"
             "只含到那时为止给予者，而跨一切步来读的闭包可越过所承担者的终结（`Flow.needs_iff_none_of_inactive`、"
             "`Flow.gives_of_withinFeedingUpTo`、`Overlapping.closure_overreaches`）；读法是 AI 的")

regions = json.loads(text(REGIONS))
assert 'need-and-feeding-read-with-time' not in regions['records']
regions['records']['need-and-feeding-read-with-time'] = {'region': 'significance', 'base': 'old-base',
                                                         'note': 'IV3k Weightings'}
regions['records'] = dict(sorted(regions['records'].items()))
PENDING[REGIONS] = json.dumps(regions, ensure_ascii=False, indent=1) + '\n'

st = text(STUDY)
assert '(IV3k)' not in st
last = max(int(m) for m in re.findall(r'^## (\d+)\. ', st, re.M))
assert N == last + 1, ('section number', N, last)
R = json.loads((PKG / 'becoming-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed'
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.Weightings')
sec = (HERE / 'study_iv3k.txt').read_text(encoding='utf-8')
sec = (sec.replace('## {N}.', f'## {N}.').replace('RECEIPT_ID', RECEIPT)
       .replace('THEOREMS', str(mod['theorems'])).replace('DECLS', str(len(mod['declarations']))))
assert '{N}' not in sec and 'THEOREMS' not in sec and 'DECLS' not in sec
PENDING[STUDY] = st.rstrip('\n') + '\n\n' + sec.rstrip('\n') + '\n'

for path, s in PENDING.items():
    path.write_text(s, encoding='utf-8')
    print('wrote', path.relative_to(ROOT))
