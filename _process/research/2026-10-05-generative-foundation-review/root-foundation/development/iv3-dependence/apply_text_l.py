#!/usr/bin/env python3
"""IV3l: the independent review's fixes in the texts (findings F1-F19 and RP2's crux gap). 07 (§4.3 rows, witnesses,
planetary reading; §4.6 steps 1, 2, 4, conclusion, P2); 08 item 12; the overview (EN, ZH); D64 (where, items 5, 11, 14);
the package README rows (EN, ZH); the records (self-concern-through-dependence, need-and-feeding-read-with-time); study
§396 and §397 corrected in place; the new study section.
usage (from the checkout root): python3 -B apply_text_l.py STUDY_SECTION RECEIPT"""
import datetime
import hashlib
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
METHOD = ROOT / 'theories/becoming/chapters/08-METHOD.md'
OV = ROOT / 'theories/becoming/THE-THEORY-OF-BECOMING.md'
OVZ = ROOT / 'theories/becoming/THE-THEORY-OF-BECOMING.zh.md'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
PENDING = {}


def text(path):
    return PENDING.get(path, path.read_text(encoding='utf-8'))


def rep(path, old, new):
    s = text(path)
    assert s.count(old) == 1, (path.name, old[:80], s.count(old))
    PENDING[path] = s.replace(old, new)


# 07 §4.3
rep(HOME, "has a member give at least the sum of its shortfalls, and where it can give each, some such flow has it give exactly that",
    "has each member give at least the sum of its shortfalls, and where a member can give each, some such flow has it give exactly that")
rep(HOME, "| two tiers: lower members each giving the family at most what it takes from its own store (outside the family, none "
    "shared), the stores given only by upper members within supplied capacities however each divides its giving, every store "
    "balancing; the consumer",
    "| two tiers: the family balancing across the stretch and given only by lower members, each giving it at most what it takes "
    "from its own store (outside the family, none shared), the stores balancing and given only by upper members within "
    "supplied capacities however each divides its giving, only active formations giving and each taking part at most once a "
    "step; the consumer")
rep(HOME, "(`Routing.fill_needs_top`); in `FeedersInTurn`",
    "(`Routing.fill_needs_top`); in each of these `Routing` settings a flow is possible, so none of these needs is vacuous "
    "(`Routing.possible`, and `Routing.router_not_needed` for the first); in `FeedersInTurn`")
rep(HOME, "Whether they do is empirical. Read with time, that scope is among those whose lives overlap: need reaches only what is "
    "active within the stretch of the continuation it carries, and a feeding closure up to a step only what gives by then; read "
    "across every step, the closure runs forward through overlapping lives to those after, whom no continuation in it needs "
    "([above](#r-need-and-feeding-read-with-time)). What comes after every present center is reached by a line under a class "
    "that goes on past one's end ([§4.5](#r-reach-past-ones-own-end)) or by the step.",
    "Whether they do is empirical. Read with time, that scope reaches nothing after the step it is read up to: over flows in "
    "which only active formations give, need reaches, except vacuously, only what is active within the stretch of the "
    "continuation it carries, and a feeding closure read up to a step holds, besides its formation, only what gives by then, "
    "which may lie well before; read across every step, the closure can run forward through overlapping lives to formations "
    "the continuation it carries does not need ([above](#r-need-and-feeding-read-with-time)). What comes after every present "
    "center is reached by a line under a class that goes on past one's end ([§4.5](#r-reach-past-ones-own-end), "
    "[§4.6](#future-path)) or by the step.")
# 07 §4.6
rep(HOME, "1. *Need does not reach the future.* A formation active at no step of the stretch a continuation is read across is "
    "needed only where nothing lets that continuation go on (`Flow.needs_iff_none_of_inactive`). Read with time, the feeding "
    "closure holds only what gives by then (`Flow.gives_of_withinFeedingUpTo`), and read across every step it overreaches "
    "(`Overlapping.closure_overreaches`)",
    "1. *Need does not reach the future.* Over flows in which only active formations give, a formation active at no step of "
    "the stretch a continuation is read across is needed only where nothing lets that continuation go on "
    "(`Flow.needs_iff_none_of_inactive`). Read with time, the feeding closure holds, besides its formation, only what gives by "
    "then (`Flow.gives_of_withinFeedingUpTo`), and read across every step it can overreach (`Overlapping.closure_overreaches`)")
rep(HOME, "A class narrower than the one, a family line, is constant and carries the line with its core through each birth while "
    "each member's line ends (`TwoLines.core_through_birth`); where two family lines share nothing, even the line under the one "
    "from one family reaches no member of the other (`TwoLines.other_line_outside`; [01](01-ROOT.md#r-the-source-texts-test-systems)).",
    "In the witness of two family lines that share nothing, a family line is narrower than the one (`TwoLines.between`) and "
    "constant, since every family line there goes on without end (`TwoLines.family_constant`), and it carries the line with "
    "its core through each birth while each member's line ends (`TwoLines.core_through_birth`); every line stays within its "
    "family (`TwoLines.line_in_family`), so even the line under the one from one family's first birth does not reach the "
    "other's (`TwoLines.other_line_outside`; [01](01-ROOT.md#r-the-source-texts-test-systems)).")
rep(HOME, "Under the one, the line reaches the other family's later members through the condition its members affect "
    "(`SharedCondition.affecting_reaches_other`), and through a common cause it reaches none (`SharedCondition.fed_outside`). A "
    "constant class holding a stage of the condition with a member takes in what the condition feeds "
    "(`ThirdFed.constant_takes_third`).",
    "Under the one, the line from the first family's first member reaches the second family's member two generations on, "
    "through the condition its members affect (`SharedCondition.affecting_reaches_other`), and through a common cause it reaches "
    "none (`SharedCondition.fed_outside`). A constant class holding a stage of the condition with a member holds the third "
    "thing's stage that the condition feeds alike with what the member conditions next (`ThirdFed.constant_takes_third`).")
rep(HOME, "*Conclusion.* Under P1–P3, one's concern for one's own continuation reaches what the conditions one's line runs "
    "through later feed, across lines and past one's own end: exactly so in the witnesses of steps 2–4, and in general where "
    "the open form of steps 3–4 holds.",
    "*Conclusion.* Under P1–P3, one's concern for one's own continuation reaches what the conditions one's line runs through "
    "later feed, across lines and past one's own end, in general where the open form of steps 3–4 holds. The witnesses show "
    "the parts apart, not together: going on past a member's end where nothing crosses between lines (`TwoLines`, "
    "`LineOfDescent`), and reaching across lines through an affected condition where no member's end is modelled "
    "(`SharedCondition`, `ThirdAffects`, `ThirdFed`), the shared-condition reach under the one, whose constancy is not shown "
    "there.")
rep(HOME, "- **P2 is the crux.** A class under which some line ends is not constant (`«有亡之续则不有常»`). So the narrow self, "
    "the organism's, is a class that is no regularity of its own: under it nothing of the self follows its end. Denying P2 is "
    "coherent,",
    "- **P2 is the crux.** A constant class is one under which no line ends after its first step (`«有常则相续不尽»`), so P2 "
    "asks that the line one's acts keep going be endless, which is not shown. A class under which some line ends is not "
    "constant (`«有亡之续则不有常»`): the organism's class fails P2, and under it nothing of the self follows its end, but its "
    "failing does not single that class out. In the descent that ends no line goes on without end under any relation "
    "(`LineOfDescent.Last.never_unending`), so there no class under which anything continues is constant, the one included (an "
    "inference from these laws that no landed theorem states); the family line meets P2 in `TwoLines` only because its "
    "generations go on without end (`TwoLines.family_constant`). Denying P2 is coherent,")
# 08 item 12
rep(METHOD, "; drawn along need it reaches nothing active only after the continuation it carries "
    "([07](07-SIGNIFICANCE.md#r-need-and-feeding-read-with-time)), and held de se of a line under a class it reaches past one's "
    "own end ([07 §4.5](07-SIGNIFICANCE.md#r-reach-past-ones-own-end)).",
    "; need, read as reach (D64), reaches, except vacuously and over flows in which only active formations give, nothing active "
    "only after the stretch of the continuation it carries ([07](07-SIGNIFICANCE.md#r-need-and-feeding-read-with-time)), and held "
    "de se of a line under a class it reaches past one's own end ([07 §4.5](07-SIGNIFICANCE.md#r-reach-past-ones-own-end), "
    "[§4.6](07-SIGNIFICANCE.md#future-path)).")
# overview
rep(OV, "the other members' capacities fall short of the demand", "the other active members' capacities fall short of the demand")
rep(OV, "Read with time, that scope is shared among those whose lives overlap: need reaches only what is active within the "
    "stretch of the continuation it carries, and a feeding closure read up to a step only what gives by then",
    "Read with time, that scope reaches nothing after the step it is read up to: over flows in which only active formations "
    "give, need reaches, except vacuously, only what is active within the stretch of the continuation it carries, and a feeding "
    "closure read up to a step holds, besides its formation, only what gives by then")
rep(OVZ, "其他成员的容量不足以满足需求", "其他活跃成员的容量不足以满足需求")
rep(OVZ, "带着时间来读，这一范围由生命交叠者共有：所需只达到在其所承担之延续的区间内活跃者，读至某步的供养闭包只含到那时为止给予者",
    "带着时间来读，这一范围达不到所读至之步以后的任何东西：在只有活跃构成给予的流上，所需除空真情形外只达到在其所承担之延续的区间内活跃者，"
    "读至某步的供养闭包除其构成外只含到那时为止给予者")
# D64
rep(CHOICES, "study section 373 ([IV3](BECOMING-RENEWAL-READING.md#373-self-concern-through-dependence-iv3)). Decided in the one "
    "account of D45; continues D59, D60 and D61.",
    "study section 373 ([IV3](BECOMING-RENEWAL-READING.md#373-self-concern-through-dependence-iv3)); the record "
    "[need-and-feeding-read-with-time](../../../../theories/becoming/results/records/need-and-feeding-read-with-time.md); "
    "[07 §4.6](../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#future-path); study sections 388, 396, 397 and "
    f"{N}. Decided in the one account of D45; continues D59, D60 and D61.")
rep(CHOICES, "Read with time, the scope it gives is shared among those whose lives overlap, not over those who come after (item 14).",
    "Read with time, the scope it gives reaches nothing after the step it is read up to, so not those who come after (item 14).")
rep(CHOICES, "and with capacities read off the feeders' own stores alike (`Flow.least_giving_from_stores`; study section 388, IV3i).",
    "and with capacities read off the feeders' own stores where the feeder can give each shortfall "
    "(`Flow.least_giving_from_stores`; study section 388, IV3i).")
rep(CHOICES, "Need is read across the stretch of the continuation it carries: a formation active at no step of it is needed only "
    "where nothing lets the continuation go on",
    "Need is read across the stretch of the continuation it carries: over flows in which only active formations give, a "
    "formation active at no step of it is needed only where nothing lets the continuation go on")
rep(CHOICES, "read across every step, the closure runs forward through lives overlapping in turn to formations no continuation in "
    "it needs (`Overlapping.closure_overreaches`)",
    "read across every step, the closure can run forward through lives overlapping in turn to formations the first's "
    "continuation does not need (`Overlapping.closure_overreaches`)")
# README rows
rep(PKG / 'README.md', "with capacities read off the stores alike (`Flow.least_giving_from_stores`, `OwnStores.first_in_degree`)",
    "with capacities read off the stores where a member can give each shortfall (`Flow.least_giving_from_stores`, "
    "`OwnStores.first_in_degree`)")
rep(PKG / 'README.md', "read with time, need reaches only what is active within the stretch it is read across, and a feeding "
    "closure up to a step only what gives by then",
    "read with time, over flows in which only active formations give, need reaches, except vacuously, only what is active "
    "within the stretch it is read across, and a feeding closure up to a step holds, besides its formation, only what gives by then")
rep(PKG / 'README.zh.md', "以从库存读出的容量亦然（`Flow.least_giving_from_stores`、`OwnStores.first_in_degree`）",
    "以从库存读出的容量，在成员能给出每个缺额处亦然（`Flow.least_giving_from_stores`、`OwnStores.first_in_degree`）")
rep(PKG / 'README.zh.md', "带着时间来读，所需只达到在其所读区间内活跃者，至某步的供养闭包只含到那时为止给予者",
    "带着时间来读，在只有活跃构成给予的流上，所需除空真情形外只达到在其所读区间内活跃者，至某步的供养闭包除其构成外只含到那时为止给予者")
# study §396 and §397, corrected in place
rep(STUDY, "own store (outside the family, no two members sharing one)", "own store")
rep(STUDY, "Need reaches forward exactly as far as the continuation it is\n       read across.",
    "Need reaches forward no farther than the continuation it is\n       read across.")
rep(STUDY, "Both now have their exact form. Need reaches what is active within the stretch of the continuation it carries; the "
    "feeding closure read with time holds only what gives by the step it is read up to; read across every step it runs forward "
    "through lives that overlap in turn, to formations no continuation in it needs. So the planetary reading of D64 gives a "
    "shared scope among those whose lives overlap, not over those who come after.",
    "Both now have an exact form, and it corrects the first: need reaches, except vacuously, only what is active within the "
    "stretch of the continuation it carries, so neither predecessors nor successors active only outside it; the feeding closure "
    "read with time holds, besides its formation, only what gives by the step it is read up to; read across every step it can "
    "run forward through lives that overlap in turn, to formations the first's continuation does not need. So the planetary "
    f"reading of D64 gives a scope that reaches nothing after the step it is read up to. (Corrected in §{N}, IV3l.)")

st = text(STUDY)
assert '(IV3l)' not in st
last = max(int(m) for m in re.findall(r'^## (\d+)\. ', st, re.M))
assert N == last + 1, ('section number', N, last)
R = json.loads((PKG / 'becoming-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed'
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.Weightings')
sec = (HERE / 'study_iv3l.txt').read_text(encoding='utf-8')
sec = (sec.replace('## {N}.', f'## {N}.').replace('RECEIPT_ID', RECEIPT)
       .replace('THEOREMS', str(mod['theorems'])).replace('DECLS', str(len(mod['declarations']))))
assert '{N}' not in sec and 'THEOREMS' not in sec and 'DECLS' not in sec
PENDING[STUDY] = text(STUDY).rstrip('\n') + '\n\n' + sec.rstrip('\n') + '\n'

for path, s in PENDING.items():
    path.write_text(s, encoding='utf-8')
    print('wrote', path.relative_to(ROOT))
