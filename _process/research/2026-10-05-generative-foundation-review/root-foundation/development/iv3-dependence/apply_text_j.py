#!/usr/bin/env python3
"""IV3j: need across two tiers in the texts. The home section 07-SIGNIFICANCE §4.3 (a row of the table of laws, the
witnesses, the reading); D64 (where, and item 13); the package README row (EN, ZH); the study section.
usage (from the checkout root): python3 -B apply_text_j.py STUDY_SECTION RECEIPT"""
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


insert_after(HOME, "| a hierarchy of families in order, each balancing across the stretch", [
    '| two tiers: lower members each giving the family at most what it takes from its own store (outside the family, '
    'none shared), the stores given only by upper members within supplied capacities however each divides its giving, '
    'every store balancing; the consumer in neither tier and active across a stretch longer than the family\'s stock; '
    'activity and identity decided, the family (holding a named condition) and both tiers listed without repetition and '
    'apart | a formation\'s giving into the hierarchy (to the family or to a store), exactly where at some step the other '
    'active upper members cannot together give what the stores rise, or the falls of the other active lower members\' '
    'stores and, while one of them is active to route it, what the other active upper members can give beyond the '
    'stores\' rises fall short of the demand | '
    '`Flow.needs_iff_through_short` |',
])
replace_once(HOME, "in `TwoTiers` a user needs the giving of its feeder's source (`TwoTiers.needs_source`);",
             "in `TwoTiers` a user needs the giving of its feeder's source (`TwoTiers.needs_source`); across two tiers "
             "with capacities a lone upper member is needed (`Routing.top_needed`), and so is a lone lower member that "
             "holds nothing, everything passing through it (`Routing.lone_router_needed`), but neither of two lower "
             "members (`Routing.router_not_needed`), nor either of two upper members (`Routing.tops_not_needed`) until "
             "a lower store rises and takes what the other could have routed, when each is (`Routing.rise_needs_top`); "
             "where only one upper member can give a rising store, it is needed though the lower stores' falls could feed "
             "the user (`Routing.fill_needs_top`);")
replace_once(HOME, "up a hierarchy, the giving of some member into the top, which member the law does not fix.",
             "up a hierarchy, the giving of some member into the top, which member the law does not fix; across two "
             "tiers with capacities it does, and a member that holds nothing is reached where all the giving must pass "
             "through it.")

replace_once(CHOICES, "Where: the chapter [THE-STEP-OF-INVARIANCE](../../../../theories/becoming/history/THE-STEP-OF-INVARIANCE.md) "
             "§4.4, §5, §7 and §8;",
             "Where: the home section [07-SIGNIFICANCE §4.3](../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#dependence) "
             "(from 23 October 2026); the chapter [THE-STEP-OF-INVARIANCE](../../../../theories/becoming/history/"
             "THE-STEP-OF-INVARIANCE.md) §4.4, §5, §7 and §8;")
insert_after(CHOICES, "12. **Possible courses.** That some flow lets the consumer draw past the stock is read off the web", [
    "13. **Two tiers.** Across two tiers, lower members passing on what they take from their own stores and upper members "
    "giving the stores within supplied capacities, a formation's part is read as its giving into the hierarchy, to the "
    "family or to a store (`Flow.GivesInto`); what the upper members can route as what they can give beyond what the "
    "stores rise (`Web.othersThrough`); and a lower member that holds nothing as a route, needed where every route "
    "passes through it (`Flow.needs_iff_through_short`, `Routing.lone_router_needed`). As the family's rises are part of "
    "a step's demand (item 8), the stores' rises are part of what the web asks: the upper members give the rising stores "
    "first and only what remains can be routed, so a rise can make each of two upper members needed "
    "(`Routing.rise_needs_top`); and where only one upper member can give a store what the web has it rise, every flow of "
    "that web has it give, so the law counts it needed though the consumer could be fed without it "
    f"(`Routing.fill_needs_top`). Need is read off the whole web as given (study section {N}, IV3j).",
])
replace_once(PKG / 'README.md', "with capacities read off the stores alike (`Flow.least_giving_from_stores`, "
             "`OwnStores.first_in_degree`); the readings are the AI's",
             "with capacities read off the stores alike (`Flow.least_giving_from_stores`, `OwnStores.first_in_degree`); "
             "across two tiers, lower members passing on what they take from their own stores and upper members giving "
             "the stores within their capacities, a formation's giving into the hierarchy is needed exactly where the "
             "other upper members cannot give what the stores rise or the others cannot give the demand through the "
             "hierarchy, a lower member holding nothing needed where it is the only route (`Flow.needs_iff_through_short`, "
             "`Routing.lone_router_needed`, `Routing.rise_needs_top`); the readings are the AI's")
replace_once(PKG / 'README.zh.md', "以从库存读出的容量亦然（`Flow.least_giving_from_stores`、`OwnStores.first_in_degree`）；读法是 AI 的",
             "以从库存读出的容量亦然（`Flow.least_giving_from_stores`、`OwnStores.first_in_degree`）；跨两层（下层成员传递"
             "取自自身库存者，上层成员在其容量内给予诸库存），某构成向层级的给予恰在其余上层成员给不出诸库存的上升、或其余者经由层级"
             "给不出需求之处被需要，一无所持的下层成员在它是唯一通路时被需要（`Flow.needs_iff_through_short`、"
             "`Routing.lone_router_needed`、`Routing.rise_needs_top`）；读法是 AI 的")

st = text(STUDY)
assert '(IV3j)' not in st
last = max(int(m) for m in re.findall(r'^## (\d+)\. ', st, re.M))
assert N == last + 1, ('section number', N, last)
R = json.loads((PKG / 'becoming-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed'
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.Weightings')
sec = (HERE / 'study_iv3j.txt').read_text(encoding='utf-8')
sec = (sec.replace('## {N}.', f'## {N}.').replace('RECEIPT_ID', RECEIPT)
       .replace('THEOREMS', str(mod['theorems'])).replace('DECLS', str(len(mod['declarations']))))
assert '{N}' not in sec and 'THEOREMS' not in sec and 'DECLS' not in sec
PENDING[STUDY] = st.rstrip('\n') + '\n\n' + sec.rstrip('\n') + '\n'

for path, s in PENDING.items():
    path.write_text(s, encoding='utf-8')
    print('wrote', path.relative_to(ROOT))
