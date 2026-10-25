#!/usr/bin/env python3
"""UE9 records: write comparing-two-courses-on-what-they-admit (every declaration of Becoming.ComparingCourses, in
twenty-one law groups), and point eventual-widening's and what-keeping-widening-needs' next steps to it, each with a
related entry and a history note; what-keeping-widening-needs' passing laws stated with requirements never loosening
beside the World premises (its statement, law 9 and premises), as UE8's first review found. Asserts the receipt's hash and empty axiom reports for the module, and the style caps
(tools/research/style.py) on every field written. Mirrors UE7's make_records_ue7.py; no landed module changes, so no
record is re-pointed for Lean.
usage (from the checkout root, after texts_ue9.py): python3 -B make_records_ue9.py RECEIPT N
       python3 -B make_records_ue9.py --caps  (the caps and the declaration cover against the kit's scratch audit;
                                               writes nothing)"""
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT))
from tools.research import style  # noqa: E402

CAPS_ONLY = sys.argv[1] == '--caps'
RECEIPT_ID, N = ('RECEIPT', 0) if CAPS_ONLY else (sys.argv[1], int(sys.argv[2]))
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RF + 'BECOMING-RENEWAL-READING.md'
KITD = RF + 'development/ue9-comparing-courses/'
NOTE, REVIEW, RECHECK = KITD + 'NOTE.md', KITD + 'REVIEW-UE9.md', KITD + 'RECHECK-UE9.md'
CH7 = 'theories/becoming/chapters/07-SIGNIFICANCE.md'
LEAN = {m: f'{PKG}/Becoming/{m}.lean' for m in
        ('ComparingCourses', 'EventualWidening', 'EventualWideningInstances', 'Admission', 'Regions', 'Identity',
         'ContinuedClasses', 'Growth', 'Population')}
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
RID = 'comparing-two-courses-on-what-they-admit'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
DATE_EN, DATE_ZH = '26 October 2026', '2026年10月26日'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def capped(field, pair, item=False):
    caps = style.ITEM_CAPS_V2 if item else style.CAPS_V2
    en, zh = caps[field][:2]
    assert len(pair['en']) <= en and len(pair['zh']) <= zh, (field, len(pair['en']), en, len(pair['zh']), zh, pair['en'][:60])
    return pair


if CAPS_ONLY:
    audit = (HERE.parent / 'tree/.build/BecomingComparingCoursesAxiomAudit.lean').read_text(encoding='utf-8')
    names = set(re.findall(r'^#print axioms (\S+)$', audit, re.M))
else:
    core = json.loads((ROOT / RECEIPT).read_text())
    assert core['status'] == 'passed'
    module = 'Becoming.ComparingCourses'
    assert core['source_sha256'][module] == sha(LEAN['ComparingCourses']), module
    mod = next(x for x in core['modules'] if x['module'] == module)
    assert not any(mod['axiom_dependencies'].values()), module
    names = {d['name'] for d in mod['declarations']}
assert len(names) == 244, len(names)


def D(*short):
    out = ['Becoming.' + s for s in short]
    missing = [n for n in out if n not in names]
    assert not missing, missing
    return out


groups = [
    ("One order lemma. A transitive relation joined to the strict part of a transitive relation containing it is "
     "transitive, and an irreflexive relation joined to the strict part of any relation is irreflexive; so widening "
     "joined to the strict part of any transitive relation containing inclusion is a strict partial order containing "
     "widening. Every order below is its case. Near-definitional.",
     "一条序之引理。传递关系并上包含它的传递关系之严格部分仍传递，非自反关系并上任一关系之严格部分仍非自反；故扩大并上任何包含“包含”的传递关系之"
     "严格部分，是包含扩大的严格偏序。下述诸序皆其特例。近乎定义。",
     D('strictJoin_trans', 'strictJoin_irrefl', 'Web.strictJoin_order')),
    ("Two rankings crossed by widening close a cycle, on every web: a transitive relation containing widening that "
     "ranks l above l' and k above k', where l' widens k and k' widens l, ranks l above itself. Ranking keeping "
     "widening over admitting alike puts every course keeping widening by name from the first step above every course "
     "admitting alike from it, wider up to it and mixed with it.",
     "为扩大所交叉的两个排序闭成一环，于每一网：包含扩大的传递关系若把 l 排在 l' 之上、k 排在 k' 之上，而 l' 扩大 k、k' 扩大 l，"
     "则把 l 排在自身之上。“持续扩大优于所纳相同”把每个自首步起按名持续扩大的进程，排在每个自首步起所纳相同、至首步更宽且与之混杂的进程之上。",
     D('Web.ranks_self_of_crossed', 'Web.RanksKeepingOverAlike')),
    ("Witness: formations on two sides, each needing its own condition at one. The growing course admits at step t "
     "one side's formations up to t; the other admits at every step the first of them and the whole other side. "
     "The growing course keeps widening by name; the other admits alike, was wider up to the first step and is "
     "mixed with it. Each static course widens the mirrored pair's keeping course, never conversely.",
     "见证：两侧之构成，各只需自身之条件，需求为一。生长之进程于第 t 步纳一侧至 t 之构成；另一进程每步纳该侧之首与另一侧之全部构成。"
     "生长之进程按名持续扩大；另一进程所纳相同、至首步更宽且与之混杂。每对之静态进程扩大另一对之持续进程，而无一持续进程扩大另一对之静态进程。",
     D('Sides.web', 'Sides.admits_iff', 'Sides.swap', 'Sides.growing', 'Sides.firstAndOther', 'Sides.growing_true',
       'Sides.not_growing_false', 'Sides.firstAndOther_true', 'Sides.firstAndOther_false', 'Sides.growing_keepsWidening',
       'Sides.firstAndOther_alike', 'Sides.firstAndOther_wider_first', 'Sides.growing_mixed',
       'Sides.firstAndOther_widens_swapped', 'Sides.swapped_widens_growing', 'Sides.not_growing_widens_swapped',
       'Sides.not_swapped_growing_widens')),
    ("Exchanging the sides carries admission, inclusion with any lag and exceeding to the mirror and back, so the "
     "mirrored pair meets the same four conditions: the mirror of the growing course keeps widening by name, and the "
     "mirror of the other admits alike, was wider up to the first step and is mixed with it.",
     "交换两侧把所纳、任一滞后之包含与超出带到镜像并带回，故镜像之对满足同样四个条件：生长之进程的镜像按名持续扩大，另一进程的镜像所纳相同、"
     "至首步更宽且与之混杂。",
     D('Sides.swap_admits', 'Sides.swap_admits_back', 'Sides.swap_false', 'Sides.swap_true', 'Sides.swap_growing_false',
       'Sides.not_swap_growing_true', 'Sides.swap_firstAndOther_true', 'Sides.swap_firstAndOther_false',
       'Sides.swap_growing_keepsWidening', 'Sides.swap_firstAndOther_alike', 'Sides.swap_wider_first',
       'Sides.swap_mixed', 'Sides.includesLater_swap', 'Sides.includesLater_of_swap', 'Sides.includes_swap',
       'Sides.exceeds_swap', 'Sides.swap_swap_includes', 'Sides.includes_swap_swap')),
    ("Law 1. On the two-sided web no strict partial order containing widening ranks keeping widening by name over "
     "admitting alike; the mirrored pair is in the class, so no invariance is needed. For one pair the exchange is "
     "needed: a transitive relation containing widening and unchanged by it ranks the growing course above itself if "
     "over the other, and widening with that pair added and closed is a strict partial order.",
     "律一。在两侧之网上，没有包含扩大的严格偏序能把按名持续扩大排在所纳相同之上：镜像之对亦在此类中，故不需不变性。就单对而言，"
     "包含扩大、不因交换而变、把生长之进程排在另一进程之上的传递关系，把它排在自身之上；扩大加上此一对并闭合后是严格偏序，故彼处交换为必需。",
     D('Sides.no_order_ranks_keeping_over_alike', 'Sides.keeping_over_alike_cycles', 'Sides.onePair',
       'Sides.not_firstAndOther_includes', 'Sides.exchange_needed')),
    ("One verdict only. Widening joined to ranking whatever includes the other course or its mirror above whatever "
     "the growing course or its mirror includes is a strict partial order containing widening and unchanged by the "
     "exchange; it ranks the other course above the growing one. The cycle forbids ranking the growing course above "
     "the other, not the reverse.",
     "只禁一种判定。扩大并上“凡包含另一进程或其镜像者，排在凡为生长之进程或其镜像所包含者之上”，是包含扩大、不因交换而变的严格偏序；"
     "它把另一进程排在生长之进程之上。此环禁止的是把生长之进程排在另一进程之上，而非其反。",
     D('Sides.Above', 'Sides.Below', 'Sides.reverseOrder', 'Sides.not_below_above', 'Sides.reverseOrder_irrefl',
       'Sides.Above.of_includes', 'Sides.Below.of_includes', 'Sides.reverseOrder_trans', 'Sides.Above.mirror',
       'Sides.Below.mirror', 'Sides.reverseOrder_exchanged', 'Sides.reverse_consistent')),
    ("The exchange admits counting scale. A course admits at least as many formations as another at every step when, "
     "at each step, a map one to one on what the other admits carries it into what the course admits; widening joined "
     "to the strict part of that is a strict partial order containing widening, unchanged by the exchange, and it "
     "ranks the other course above the growing one by scale alone.",
     "交换容许计规模。若每步皆有一映射，于另一进程所纳上为一对一，把它带入此进程所纳，则此进程每步所纳之构成至少一样多；扩大并上其严格部分，"
     "是包含扩大、不因交换而变的严格偏序，且仅凭规模把另一进程排在生长之进程之上。",
     D('Sides.flip', 'Sides.flip_flip', 'Sides.ScaleAtLeast', 'Sides.ScaleAtLeast.of_includes', 'Sides.ScaleAtLeast.trans',
       'Sides.ScaleAtLeast.exchanged', 'Sides.scaleOrder', 'Sides.growing_zero_eq', 'Sides.scale_firstAndOther_growing',
       'Sides.not_scale_growing_firstAndOther', 'Sides.scale_counts')),
    ("Scope: the cycle needs infinitely many admissions. A static course whose admissions a list holds includes no "
     "course keeping widening by name; so widening joined to ranking, for each such pair of the class, whatever "
     "includes its keeping course above whatever its static course includes is a strict partial order containing "
     "widening on every web, ranking the growing course above the first formations on the two-sided web.",
     "范围：此环需要无穷多所纳。所纳由列表持有的静态进程不包含任何按名持续扩大的进程；故扩大并上（对此类中静态所纳有列表的每一对）"
     "“凡包含持续扩大者，排在凡为静态者所包含者之上”，于每一网皆是包含扩大的严格偏序；于两侧之网上它把生长之进程排在两侧首构成之上。",
     D('Web.KeepingOverListedAlike', 'Web.not_listed_includes_keeping', 'Web.ListedOrder', 'Web.ListedOrder.irrefl',
       'Web.ListedOrder.trans', 'Web.ListedOrder.ranks', 'Sides.firsts', 'Sides.firsts_zero', 'Sides.not_firsts_succ',
       'Sides.growing_over_firsts', 'Sides.listed_consistent')),
    ("Infinite width does not suffice. On a web whose first side needs one condition at one and whose second side's "
     "formation m needs another at m + 1, no static course includes a course keeping widening by name; a static course "
     "admitting the whole first side, which no list holds, is in the class with the rising course, and ranking keeping "
     "widening by name over admitting alike is a strict partial order containing widening.",
     "无穷之宽不足。于一网上，第一侧之构成需一条件至一，第二侧之构成 m 需另一条件至 m + 1：无静态进程包含按名持续扩大的进程；纳整个第一侧的"
     "静态进程（无列表能持有其所纳）与上升之进程同在此类中，而把按名持续扩大排在所纳相同之上是包含扩大的严格偏序。",
     D('AllOrSegment.needOf', 'AllOrSegment.web', 'AllOrSegment.admits_iff', 'AllOrSegment.firstSide_all',
       'AllOrSegment.secondSide_opening', 'AllOrSegment.reaches_secondSide', 'AllOrSegment.not_static_includes',
       'AllOrSegment.KeepingOverAlike', 'AllOrSegment.ClassOrder', 'AllOrSegment.ClassOrder.irrefl',
       'AllOrSegment.ClassOrder.trans', 'AllOrSegment.rising', 'AllOrSegment.wide', 'AllOrSegment.rising_keeps',
       'AllOrSegment.rising_over_wide', 'AllOrSegment.firstSide', 'AllOrSegment.firstSide_below',
       'AllOrSegment.firstSide_distinct', 'AllOrSegment.firstSide_length', 'AllOrSegment.firstSide_fst',
       'AllOrSegment.wide_not_listed', 'AllOrSegment.unlisted_consistent')),
    ("By name is needed. On the own-condition web, along the continuation carrying every formation into formation 0, "
     "two courses keep widening, and two listed static courses, each alike from the first step, wider up to it and "
     "mixed with one of them, widen the other's keeping course; so with keeping widening read along a continuation, no "
     "strict partial order containing widening ranks every such pair.",
     "按名为必需。于自身条件之网上，沿把每一构成带入构成 0 的延续，两个进程持续扩大；两个所纳有列表的静态进程各自首步起所纳相同、至首步更宽且与"
     "其一混杂，并扩大另一对的持续进程；故持续扩大沿一延续读时，无包含扩大的严格偏序能排序每一此类之对。",
     D('AlongMerging.intoZero', 'AlongMerging.linked_cases', 'AlongMerging.linked_to_zero',
       'AlongMerging.not_linked_succ', 'AlongMerging.includesAcross_of_zero', 'AlongMerging.not_admits_of_zero',
       'AlongMerging.admits_of_one', 'AlongMerging.keepingA', 'AlongMerging.keepingB', 'AlongMerging.staticA',
       'AlongMerging.staticB', 'AlongMerging.keepingA_keeps', 'AlongMerging.keepingB_keeps',
       'AlongMerging.staticA_wider_first', 'AlongMerging.staticB_wider_first', 'AlongMerging.mixedA',
       'AlongMerging.mixedB', 'AlongMerging.listedA', 'AlongMerging.listedB', 'AlongMerging.staticA_widens_keepingB',
       'AlongMerging.staticB_widens_keepingA', 'AlongMerging.KeepingAlongOverListedAlike', 'AlongMerging.pairA',
       'AlongMerging.pairB', 'AlongMerging.no_order_ranks_along_listed')),
    ("Law 2. A course includes another with lag d when every formation the other admits at a step, it admits d steps "
     "later; it widens it with a lag when it includes it with some lag and the other includes it with none. Inclusion "
     "with a lag is a preorder, lags adding; widening or widening with a lag is a strict partial order containing "
     "widening, never reversing it; widening with a lag composes with widening on either side.",
     "律二。若另一进程于一步所纳之每一构成，此进程于 d 步之后皆纳，则此进程以滞后 d 包含它；若此进程以某滞后包含它，而它不以任何滞后包含此进程，"
     "则此进程带滞后地扩大它。带滞后之包含为前序，滞后相加；扩大或带滞后的扩大是包含扩大的严格偏序，从不逆转扩大，带滞后的扩大与扩大两侧皆可相接。",
     D('Web.IncludesLater', 'Web.IncludesWithLag', 'Web.WidensWithLag', 'Web.WidensOrWithLag',
       'Web.IncludesLater.of_includes', 'Web.IncludesLater.trans', 'Web.IncludesWithLag.refl', 'Web.IncludesWithLag.trans',
       'Web.IncludesWithLag.of_includes', 'Web.WidensWithLag.irrefl', 'Web.WidensWithLag.trans', 'Web.Widens.trans_withLag',
       'Web.WidensWithLag.trans_widens', 'Web.WidensOrWithLag.of_widens', 'Web.WidensOrWithLag.irrefl',
       'Web.WidensOrWithLag.trans', 'Web.Widens.not_reversed_withLag')),
    ("The lag's form does not matter for the order: a lag varying with the formation, and a lag for each admission, "
     "are again transitive and contain inclusion, so each joined to widening is a strict partial order containing "
     "widening. "
     "Widening or widening with a lag gives inclusion with a lag for each admission: what the other admits at a step, "
     "the course admits then or later.",
     "滞后之形式于序无关：随构成而变的滞后与每次所纳各自的滞后，仍传递且包含“包含”，故各自并上扩大皆是包含扩大的严格偏序。"
     "扩大或带滞后的扩大给出每次所纳各自滞后之包含：另一进程于一步所纳者，此进程于该步或更晚之步纳之。",
     D('Web.IncludesLaterBy', 'Web.IncludesWithFormationLag', 'Web.IncludesWithFormationLag.trans',
       'Web.IncludesWithFormationLag.of_includes', 'Web.IncludesEachLater', 'Web.IncludesEachLater.trans',
       'Web.IncludesEachLater.of_includes', 'Web.WidensOrWithFormationLag', 'Web.WidensOrEachLater',
       'Web.widensOrWithFormationLag_order', 'Web.widensOrEachLater_order', 'Web.WidensOrWithLag.includesEachLater')),
    ("The lag reads names across steps. Widening is unchanged by every re-identification of formations, even one "
     "varying with the step; widening or widening with a lag is unchanged by every renaming constant across steps "
     "and, on the two-sided web, by the exchange. On a web of two formations, exchanging their names from step one on "
     "changes its verdict.",
     "滞后跨步按名读构成。扩大不因构成之任何重新认同而变，即使随步而变者亦然；扩大或带滞后的扩大不因跨步恒定之任何更名而变，"
     "于两侧之网上亦不因交换而变。于两构成之网上，自第一步起交换其名会改变其判定。",
     D('Web.includes_reidentify', 'Web.exceeds_reidentify', 'Web.widens_reidentify', 'Web.includesLater_rename',
       'Web.widensOrWithLag_rename', 'Sides.widensOrWithLag_swap', 'NamesAcrossSteps.web', 'NamesAcrossSteps.flip',
       'NamesAcrossSteps.flip_flip', 'NamesAcrossSteps.exchange', 'NamesAcrossSteps.once', 'NamesAcrossSteps.later',
       'NamesAcrossSteps.admits_iff', 'NamesAcrossSteps.re_admits_iff', 'NamesAcrossSteps.later_withLag',
       'NamesAcrossSteps.not_later_withLag_renamed', 'NamesAcrossSteps.lag_reads_names')),
    ("Along a continuation the lag need not read names: a course includes another with lag d along it when what the "
     "other admits at a step is linked, d steps later, to what it admits. Widening joined to its strict part is a "
     "strict partial order containing widening; by name it is widening or widening with a lag; it is unchanged by "
     "every re-identification carrying the continuation, and the verdict renaming lost comes back.",
     "沿一延续，滞后不必按名读：若另一进程于一步所纳者，于 d 步之后与此进程所纳者相连，则此进程沿之以滞后 d 包含它。扩大并上其严格部分"
     "是包含扩大的严格偏序；按名即扩大或带滞后的扩大；它不因承载此延续的任何重新认同而变，因更名而失的判定复归。",
     D('Web.Linked.append', 'Web.IncludesLaterAlong', 'Web.IncludesLaterAlong.of_includes', 'Web.IncludesLaterAlong.trans',
       'Web.includesLaterAlong_itself_iff', 'Web.includesLaterAlong_reidentify', 'Web.WidensOrWithLagAlong',
       'Web.widensOrWithLagAlong_order', 'Web.widensOrWithLagAlong_itself_iff', 'Web.widensOrWithLagAlong_reidentify',
       'NamesAcrossSteps.along_restores')),
    ("The tail order: inclusion with a lag from some step on is a preorder containing widening and eventual widening, "
     "and widening or eventual widening joined to its strict part is a strict partial order containing both, on every "
     "web.",
     "尾序：自某步起带滞后之包含是包含扩大与最终扩大的前序；扩大或最终扩大并上其严格部分，于每一网皆是包含二者的严格偏序。",
     D('Web.IncludesLaterFrom', 'Web.TailLag', 'Web.TailLag.trans', 'Web.TailLag.of_widensOrEventually', 'Web.TailOrder',
       'Web.TailOrder.irrefl', 'Web.TailOrder.trans', 'Web.tailOrder_order')),
    ("UE4's lag decided: the course keeping every formation of the travelling one a step later widens it with lag "
     "one, where neither eventually widens the other; lags varying with the formation or for each admission, and the "
     "tail order, decide it as well.",
     "UE4 之滞后得判：晚一步保有行进进程每一构成的进程，以滞后一扩大它，而二者无一最终扩大对方；随构成而变或每次所纳各自的滞后，以及尾序，亦判定之。",
     D('LagWitness.includesLater_one', 'LagWitness.not_travelling_includes', 'LagWitness.widensWithLag',
       'LagWitness.decided', 'LagWitness.formationLag_decides', 'LagWitness.eachLag_decides',
       'LagWitness.tailOrder_decides')),
    ("Where it is silent: on the two-sided pair neither course includes the other at any lag. Widening with a lag "
     "alone does not contain widening: a rising course widens its copy one step late, which includes it with lag one, "
     "so the disjunction with widening is needed.",
     "其沉默之处：两侧之对中，无一进程以任何滞后包含对方。单独带滞后的扩大不包含扩大：上升之进程扩大其晚一步之副本，而副本以滞后一包含它，"
     "故须与扩大取析取。",
     D('Sides.silent', 'Delayed.rising_widens', 'Delayed.lagging_includes', 'Delayed.widens_not_withLag')),
    ("Law 3. On the own-condition web the course ahead admits at step t the formations from 1 to t + 1; the early "
     "course admits formation 0 at step 0 and those from 1 to t + 1 at step t + 1. The course ahead eventually widens "
     "the early one, which widens it with a lag, so no strict partial order there contains both, nor eventual widening "
     "and a lag varying with the formation or for each admission.",
     "律三。于自身条件之网上，领先之进程于第 t 步纳 1 至 t + 1 之构成；早先之进程于第 0 步纳构成 0，于第 t + 1 步纳 1 至 t + 1。"
     "领先者最终扩大早先者，早先者带滞后地扩大领先者，故彼处无严格偏序包含二者，亦无包含最终扩大与随构成而变或每次所纳各自之滞后者。",
     D('TailAndLag.ahead', 'TailAndLag.early', 'TailAndLag.not_ahead_zero', 'TailAndLag.ahead_succ',
       'TailAndLag.early_zero', 'TailAndLag.early_succ', 'TailAndLag.not_early_zero_succ',
       'TailAndLag.not_early_succ_zero', 'TailAndLag.includesFrom', 'TailAndLag.exceedsLate', 'TailAndLag.eventually',
       'TailAndLag.early_includes', 'TailAndLag.not_ahead_includes', 'TailAndLag.disagree',
       'TailAndLag.no_order_contains_both', 'TailAndLag.formationLag_conflict', 'TailAndLag.eachLag_conflict')),
    ("Why the choice matters: the tail order ranks the course ahead above the early one, which admitted formation 0 "
     "at step 0, a formation the course ahead never admits; widening or widening with a lag never ranks a course above "
     "one that admitted what it never admits.",
     "此选择何以要紧：尾序把领先之进程排在早先之进程之上，而后者于第 0 步纳了领先者从不纳的构成 0；扩大或带滞后的扩大从不把一进程排在"
     "纳过其从不纳者之进程之上。",
     D('TailAndLag.tailOrder_loses')),
    ("Law 4. A course keeps what another keeps when every formation the other admits at every step from some step on, "
     "it admits at every step from some step on. Widening or widening with a lag, and the tail order, rank a course "
     "above another only where it keeps what the other keeps; under it the two-sided pair is unranked both ways and "
     "the listed ranking above the first formations is excluded. A condition, not an order.",
     "律四。若另一进程自某步起每步皆纳之构成，此进程亦自某步起每步皆纳，则此进程保有另一进程所保有者。扩大或带滞后的扩大，以及尾序，"
     "只在此条件下把一进程排在另一进程之上；在此条件下两侧之对两向皆不排序，排在首构成之上的列表排序被排除。这是条件，不是序。",
     D('Web.KeepsWhatKept', 'Web.KeepsWhatKept.of_includesFrom', 'Web.KeepsWhatKept.of_includesLaterFrom',
       'Web.TailOrder.keepsWhatKept', 'Web.WidensOrWithLag.keepsWhatKept', 'Sides.not_keepsWhatKept_growing',
       'Sides.not_keepsWhatKept_firstAndOther', 'Sides.not_keepsWhatKept_firsts', 'Sides.keeping_reading')),
    ("Law 4 tells the lag's forms apart. A lag varying with the formation keeps what the other keeps, on every web. A "
     "lag for each admission need not: on the own-condition web its order ranks the course admitting formation 0 at "
     "even steps only, and formation 1 at step 0, above the course admitting formation 0 at every step, which keeps "
     "what the first drops; the other orders do not rank them so.",
     "律四区分滞后之诸形式。随构成而变的滞后保有对方所保有者，于每一网皆然。每次所纳各自的滞后则未必：于自身条件之网上，其序把只于偶数步纳构成 0、"
     "并于第 0 步纳构成 1 的进程，排在每步皆纳构成 0 的进程之上，而后者保有前者所舍者；其余诸序不如此排。",
     D('Web.IncludesWithFormationLag.keepsWhatKept', 'Web.WidensOrWithFormationLag.keepsWhatKept',
       'EachLagDrops.evenLevel', 'EachLagDrops.even_or_next', 'EachLagDrops.odd_or_next', 'EachLagDrops.steady',
       'EachLagDrops.alternate', 'EachLagDrops.steady_zero', 'EachLagDrops.steady_only', 'EachLagDrops.not_steady_one',
       'EachLagDrops.alternate_one', 'EachLagDrops.alternate_includesEachLater',
       'EachLagDrops.not_steady_includesEachLater', 'EachLagDrops.not_keeps', 'EachLagDrops.eachLag_not_keeping')),
]
cited = [n for _, _, ds in groups for n in ds]
assert len(cited) == len(set(cited)), [n for n in cited if cited.count(n) > 1]
assert set(cited) == names, (sorted(names - set(cited)), sorted(set(cited) - names))
laws = [capped('laws', {'en': en, 'zh': zh, 'declarations': ds}, item=True) for en, zh, ds in groups]

title = capped('title', {'en': 'Comparing two courses on what they admit', 'zh': '就所纳比较两个进程'})
statement = capped('statement', {
    'en': "On a two-sided web, ranking every course keeping widening by name above every course admitting alike, "
          "wider at first and mixed with it, closes a cycle, never with listed static courses. Widening with a lag "
          "decides UE4's lag, as does a tail order; it and eventual widening rank a pair oppositely.",
    'zh': '在两侧之网上，把每个按名持续扩大的进程排在每个所纳相同、起初更宽且与之混杂者之上便闭成一环，静态所纳有列表时则从不。带滞后的扩大判定 UE4 '
          '的滞后，尾序亦然；带滞后的扩大与最终扩大对一对进程排序相反。'})
hypotheses = [capped('hypotheses', x, item=True) for x in (
    {'en': "No axiom. Law 1's class form uses a strict partial order containing widening; its one-pair form adds "
           "invariance under exchanging the sides; laws 2 and 3 state their orders on every web or on a witness; law 4 "
           "is a necessary condition checked on witnesses.",
     'zh': '不加公理。律一之类形式用包含扩大的严格偏序；其单对形式加上交换两侧下之不变；律二、律三于每一网或于一见证上陈其序；'
           '律四为在见证上检验的必要条件。'},
    {'en': "Modelling choices: discrete steps and whole-number levels; admission as meeting each need, by name, over a "
           "fixed type of formations; keeping widening read by name in law 1; the lag compares formations across steps "
           "by name (along a continuation it need not); law 1's cycle needs a static course admitting infinitely many "
           "formations, which does not suffice.",
     'zh': '建模之选：离散之步与整数水平；在固定的构成类型上按名满足每一需求即为所纳；律一按名读持续扩大；滞后跨步按名比较构成（沿一延续则不必）；'
           '律一之环需要纳无穷多构成的静态进程，而此不足够。'})]
does_not_show = [capped('does_not_show', x, item=True) for x in (
    {'en': "That widening with a lag, or the tail order, is the second-order direction of 生生: widening with a lag "
           "ranks by what each keeps of the other's admissions over time.",
     'zh': '带滞后的扩大或尾序即生生的二阶方向：带滞后的扩大按各自随时间保有对方所纳者而排序。', 'kind': 'non-implication'},
    {'en': "Anything about what a course keeps reachable or what carries its openings, 07's other two candidates, which "
           "are not read on admitted ranges.",
     'zh': '关于进程保持可达者或承载其开出者（07 的另两个候选）的任何结论，二者不在所纳范围上读。', 'kind': 'scope'},
    {'en': "An impossibility on every web, or for comparisons that are not strict partial orders containing widening: "
           "with listed static admissions, or where no static course includes a keeping one, the ranking is consistent.",
     'zh': '于每一网之不可能性，或对非包含扩大之严格偏序者之不可能性：静态所纳有列表时，或无静态进程包含持续进程时，该排序一致。', 'kind': 'scope'},
    {'en': "That every form of the lag meets law 4: the order of a lag for each admission can rank a course above one "
           "keeping a formation it drops.",
     'zh': '滞后之每一形式皆满足律四：每次所纳各自之滞后的序可把一进程排在保有其所舍构成者之上。', 'kind': 'non-implication'},
    {'en': "That a comparison here ranks a course better: ranking needs C, and choosing between counting early steps "
           "and reading only tails is a further premise.",
     'zh': '此处之比较把某进程排得更好：排序需要 C，在计早期之步与只读尾之间作选择是又一前提。', 'kind': 'non-implication'},
    {'en': "A result no neighbouring field states: law 1's one-pair form has the shape of Askell's incomparability "
           "argument, and the other laws are near-definitional.",
     'zh': '近邻领域无人陈述的结果：律一之单对形式具 Askell 不可比论证之形，其余诸律近乎定义。', 'kind': 'correspondence'})]
validation_scope = capped('validation_scope', {
    'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): Becoming.ComparingCourses, '
          f'{len(names)} declarations, every one with an empty axiom report, all cited here; Web.Linked.append '
          f'generalizes the landed Web.Linked.snoc and sits beside it until moved below. Built in one session; an '
          f'independent read-only review by a separate AI agent (REVIEW-UE9), every finding taken, and a re-check '
          f'(RECHECK-UE9), every finding taken but one, in study section {N}; not reviewed by a person.',
    'zh': f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：Becoming.ComparingCourses 之 {len(names)} 项声明，公理报告皆空，'
          f'本记录全引；Web.Linked.append 推广已落地之 Web.Linked.snoc，移至下层前与之并存。于一会话中构建；另一 AI 代理作独立只读审查'
          f'（REVIEW-UE9），其所见皆采，并作复查（RECHECK-UE9），其所见除一项外皆采，见研究第 {N} 节；未经人审。'})
next_delta = capped('next_delta', {
    'en': "07's other two candidates, what a course keeps reachable and what carries its openings; a reason, or a "
          "premise, for counting early steps or reading only tails; review by a person.",
    'zh': '07 的另两个候选：进程保持可达者与承载其开出者；计早期之步或只读尾的理由或前提；人之审查。'})
correspondence = capped('correspondence', {
    'en': "Infinite ethics and social choice: law 1's one-pair form has the shape of Askell's (2018) incomparability "
          "argument, in which Pareto, transitivity, permutability and invariance across qualitative duplicates force "
          "incomparability between infinite worlds, here in one direction only; the exchange is an instance of relative "
          "anonymity, or permutation invariance (Sen 1984; Asheim, d'Aspremont and Banerjee 2010; Goodman and Lederman 2024); "
          "Diamond (1965) and Basu and Mitra (2003) are distant; ranking by the number of options (Pattanaik and Xu "
          "1990) is the neighbour for counting scale. Suzumura consistency (1976) and Szpilrajn's extension theorem "
          "(1930) are vocabulary only. Read by the AI, eventual widening is decided by tails, like a dictatorship "
          "of the future (Chichilnisky 1996). Delayed simulation for Büchi automata (Etessami, Wilke and Schuller 2001; 2005) is the "
          "analogue of a lag for each admission, delay games with bounded lookahead (Hosch and Landweber 1972; "
          "Holtmann, Kaiser and Thomas 2012) of a uniform lag; overtaking and catching up (Atsumi 1965; von Weizsäcker "
          "1965; Gale 1967; Brock 1970) are scalar and distant. Graded in UE9's NOTE and REVIEW-UE9; the readings are the "
          "AI's.",
    'zh': '无限伦理与社会选择：律一之单对形式具 Askell（2018）不可比论证之形，此处只在一个方向上；交换是相对匿名或置换不变之一例（Sen 1984；'
          'Asheim、d\'Aspremont 与 Banerjee 2010；Goodman 与 Lederman 2024）；Diamond（1965）与 Basu、Mitra（2003）较远；'
          '按选项数目排序（Pattanaik 与 Xu 1990）是计规模之近邻。Suzumura 一致性与 Szpilrajn 延拓定理只是用语。依 AI 之读，最终扩大由尾决定，'
          '如未来之独裁（Chichilnisky 1996）。延迟模拟（Etessami、Wilke 与 Schuller 2001）类于每次所纳各自之滞后，有界前瞻之延迟博弈'
          '（Hosch 与 Landweber 1972）类于一致之滞后；超越与追赶（Atsumi 1965；von Weizsäcker 1965）为标量，较远。分级见 '
          'UE9 之 NOTE.md 与 REVIEW-UE9.md；读法皆 AI 之读。'})
counterexamples_text = [
    {'en': 'On the two-sided web no strict partial order containing widening and unchanged by the exchange ranks the '
           'growing course above the other (Sides.keeping_over_alike_cycles), yet one ranks the other above it '
           '(Sides.reverse_consistent).',
     'zh': '在两侧之网上，没有包含扩大、不因交换而变的严格偏序能把生长之进程排在另一进程之上（Sides.keeping_over_alike_cycles），'
           '却有一个把另一进程排在其上（Sides.reverse_consistent）。'},
    {'en': 'Widening with a lag alone does not contain widening: the rising course widens its copy one step late, which '
           'includes it with lag one (Delayed.widens_not_withLag).',
     'zh': '单独带滞后的扩大不包含扩大：上升之进程扩大其晚一步之副本，而副本以滞后一包含它（Delayed.widens_not_withLag）。'},
    {'en': 'On the own-condition web the course ahead eventually widens the early one, which widens it with a lag '
           '(TailAndLag.disagree).',
     'zh': '于自身条件之网上，领先之进程最终扩大早先之进程，后者带滞后地扩大前者（TailAndLag.disagree）。'},
    {'en': "Exchanging two formations' names from step one on changes the lag order's verdict, where widening is "
           'unchanged by every re-identification (NamesAcrossSteps.lag_reads_names).',
     'zh': '自第一步起交换两构成之名会改变滞后之序的判定，而扩大不因任何重新认同而变（NamesAcrossSteps.lag_reads_names）。'},
    {'en': 'Along the continuation carrying every formation into one, listed static courses close the cycle '
           '(AlongMerging.no_order_ranks_along_listed).',
     'zh': '沿把每一构成带入其一的延续，所纳有列表的静态进程亦闭环（AlongMerging.no_order_ranks_along_listed）。'},
    {'en': 'An infinitely wide static course need not close it: on AllOrSegment.web the class is ranked consistently '
           '(AllOrSegment.unlisted_consistent).',
     'zh': '无穷之宽的静态进程未必闭环：于 AllOrSegment.web 上此类可一致地排序（AllOrSegment.unlisted_consistent）。'},
    {'en': 'The order of a lag for each admission ranks a course above one that keeps a formation it drops '
           '(EachLagDrops.eachLag_not_keeping).',
     'zh': '每次所纳各自之滞后的序把一进程排在保有其所舍构成者之上（EachLagDrops.eachLag_not_keeping）。'}]
history_entry = {
    'en': f'{DATE_EN}: added (UE9), comparing two courses on what they admit: the cycle of crossed rankings on the '
          f'two-sided web and its scope, widening with a lag and the tail order, which decide UE4\'s lag, the first ranking a '
          f'pair opposite to eventual widening, and keeping what the other keeps; near-definitional; after a review and a '
          f're-check; study section {N}.',
    'zh': f'{DATE_ZH}：新增（UE9），就所纳比较两个进程：交叉排序之环及其范围，带滞后的扩大与尾序（二者判定 UE4 之滞后，前者对一对进程之排序与最终扩大相反），'
          f'以及保有对方所保有者；近乎定义；经审查与复查；研究第 {N} 节。'}

# the two records pointed here
EW_ND = capped('next_delta', {
    'en': "The lag is decided by widening with a lag and by a tail order containing eventual widening; the first ranks a "
          f"pair opposite to eventual widening, so choosing is a premise ({RID}); the gain bridge and the givers law are "
          "proved, as restatements (what-keeping-widening-needs); widening of what can be reached over branching "
          "courses (UE10); review by a person.",
    'zh': f'滞后由带滞后的扩大与包含最终扩大的尾序判定，前者对一对进程之排序与最终扩大相反，故作选择是一前提（{RID}）；增益之桥与给予者之律已作为重述'
          '得证（what-keeping-widening-needs）；对分支进程的可达之扩大（UE10）；人之审查。'})
KW_ND = capped('next_delta', {
    'en': f"Comparing two courses on admitted ranges is done ({RID}), what a course keeps reachable and what carries its "
          "openings remaining; growth by kinds not given in advance; a reading on which 全生成 and keeping widening hold "
          "together; review by a person.",
    'zh': f'在所纳范围上比较两个进程已成（{RID}），进程保持可达者与承载其开出者仍待；非预先给定之种类的增长；全生成与持续扩大可并立的读法；人之审查。'})

# what-keeping-widening-needs: the passing laws take requirements never loosening (Unloosened), not a World premise
KW_PREMISES = [
    ('statement',
     {'en': 'support passing on makes opened by the opened a recency bound; under the World premises nothing keeps '
            'opening along passing of support. None compares two courses.',
      'zh': '在世界前提下沿支撑之传递无一持续开出。无一比较两个进程。'},
     {'en': 'passing support makes opened by the opened a recency bound; nothing keeps opening along passing of support '
            'under the World premises if requirements never loosen.',
      'zh': '在世界前提且需求永不放松时，沿支撑之传递无一持续开出。'}),
    ('law 9',
     {'en': 'Under the World premises, whatever is supported', 'zh': '在世界前提下，任一步上受支撑者'},
     {'en': 'If requirements never loosen, under the World premises what is supported',
      'zh': '需求永不放松时，在世界前提下，任一步上受支撑者'}),
    ('law 9',
     {'en': 'and nothing keeps opening or keeps widening there', 'zh': '彼处无一持续开出或持续扩大'},
     {'en': 'and nothing keeps opening or widening there', 'zh': '彼处无一持续开出或持续扩大'}),
    ('hypotheses',
     {'en': 'or the World premises (balance, only active formations giving, activity needing support, requirements '
            'never loosening).',
      'zh': '或世界前提（平衡、只有活跃者给予、活跃需支撑、需求永不放松）。'},
     {'en': 'or three World premises (balance, only active formations giving, activity needing support) with '
            'requirements never loosening, which is not a World premise.',
      'zh': '或三条世界前提（平衡、只有活跃者给予、活跃需支撑）加上需求永不放松，后者非世界前提。'})]

if CAPS_ONLY:
    kw = json.loads((RECORDS / 'what-keeping-widening-needs.json').read_text(encoding='utf-8'))
    for field, old, new in KW_PREMISES:
        target = kw[field] if field == 'statement' else (kw['laws'][8] if field == 'law 9' else kw['hypotheses'][0])
        for lang in ('en', 'zh'):
            assert target[lang].count(old[lang]) == 1, (field, lang)
            target[lang] = target[lang].replace(old[lang], new[lang])
    capped('statement', kw['statement'])
    capped('laws', kw['laws'][8], item=True)
    capped('hypotheses', kw['hypotheses'][0], item=True)
    print('what-keeping-widening-needs after the premise correction:', len(kw['statement']['en']),
          len(kw['statement']['zh']), len(kw['laws'][8]['en']), len(kw['laws'][8]['zh']))
    for x in counterexamples_text:
        assert len(x['en']) <= 600 and len(x['zh']) <= 300
    print('caps and cover pass:', len(names), 'declarations in', len(groups), 'laws; statement',
          len(statement['en']), len(statement['zh']), '; correspondence', len(correspondence['en']),
          len(correspondence['zh']))
    raise SystemExit(0)

record = {
    'schema_version': 2,
    'id': RID,
    'title': title,
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F07',
    'reviewed_at_utc': NOW,
    'statement': statement,
    'laws': laws,
    'hypotheses': hypotheses,
    'does_not_show': does_not_show,
    'counterexamples': [{'path': LEAN['ComparingCourses'], 'detail': x} for x in counterexamples_text],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical',
                            'names-provisional', 'omission-not-refutation'],
    'validation_scope': validation_scope,
    'next_delta': next_delta,
    'correspondence': correspondence,
    'canonical_source': LEAN['ComparingCourses'],
    'aliases': ['Comparing two courses on what they admit', '就所纳比较两个进程', 'widening with a lag', 'the tail order',
                'keeping what the other keeps', 'Becoming.Web.WidensOrWithLag',
                'Becoming.Sides.no_order_ranks_keeping_over_alike'],
    'dependencies': [
        {'id': 'eventual-widening', 'relation': 'formal-reuse',
         'detail': {'en': 'Web.EventuallyWidens, Web.WidensOrEventually, Web.KeepsWidening with KeepsWidening.gathers, '
                          'Web.AdmitsAlikeFrom, Web.WidensUpTo, Web.IncludesFrom and Web.ExceedsLate; the own-condition '
                          "web and UE4's lag witness.",
                    'zh': 'Web.EventuallyWidens、Web.WidensOrEventually、Web.KeepsWidening 及 KeepsWidening.gathers、'
                          'Web.AdmitsAlikeFrom、Web.WidensUpTo、Web.IncludesFrom 与 Web.ExceedsLate；自身条件之网与 UE4 之滞后见证。'}},
        {'id': 'four-cases-of-a-part', 'relation': 'formal-reuse',
         'detail': {'en': 'Web.Includes, Web.Exceeds, Web.Widens and Web.Mixed, the comparison every law here extends.',
                    'zh': 'Web.Includes、Web.Exceeds、Web.Widens 与 Web.Mixed，此处每一律所扩展的比较。'}},
        {'id': 'identity-across-steps', 'relation': 'formal-reuse',
         'detail': {'en': 'Reidentify, Web.reidentify and Reidentify.rename: the re-identifications and renamings the '
                          'lag is read under.',
                    'zh': 'Reidentify、Web.reidentify 与 Reidentify.rename：读滞后时所依之重新认同与更名。'}},
        {'id': 'classes-along-a-continuation', 'relation': 'formal-reuse',
         'detail': {'en': 'Web.Linked, Web.itself, Reidentify.carry and the links carried, for the lag along a '
                          'continuation.',
                    'zh': 'Web.Linked、Web.itself、Reidentify.carry 与被承载之链接，用于沿一延续之滞后。'}},
        {'id': 'widening-along-a-reading', 'relation': 'formal-reuse',
         'detail': {'en': 'Web.Linked.itself_of_le and Web.Linked.itself_same, by which the lag along itself is the lag '
                          'by name.',
                    'zh': 'Web.Linked.itself_of_le 与 Web.Linked.itself_same，由之沿自身之滞后即按名之滞后。'}},
        {'id': 'bounded-census-keeps-pace', 'relation': 'formal-reuse',
         'detail': {'en': 'length_le_of_sub, the pigeonhole by which a listed static course includes no course keeping '
                          'widening by name.',
                    'zh': 'length_le_of_sub，由此鸽巢原理，所纳有列表的静态进程不包含任何按名持续扩大的进程。'}}],
    'related': [
        {'id': 'eventual-widening',
         'detail': {'en': "Its lag is decided here, by widening with a lag and by the tail order, which contains eventual "
                          'widening; the two rank a pair oppositely.',
                    'zh': '其滞后在此得判，由带滞后的扩大与包含最终扩大的尾序；二者对一对进程排序相反。'}},
        {'id': 'what-keeping-widening-needs',
         'detail': {'en': 'What one course keeping widening needs; here two courses are compared on what they admit.',
                    'zh': '一个持续扩大的进程需要什么；此处就所纳比较两个进程。'}},
        {'id': 'widening-as-what-every-weighting-ranks',
         'detail': {'en': 'C read as widening; no order here is adopted by C, and choosing one is a further premise.',
                    'zh': '读作扩大的 C；此处无一序为 C 所采，选取其一是又一前提。'}}],
    'references': [{'path': LEAN['ComparingCourses'], 'role': 'proof', 'declarations': sorted(names),
                    'sha256': sha(LEAN['ComparingCourses'])}]
                  + [{'path': LEAN[m], 'role': 'proof', 'sha256': sha(LEAN[m])}
                     for m in ('EventualWidening', 'EventualWideningInstances', 'Admission', 'Regions', 'Identity',
                               'ContinuedClasses', 'Growth', 'Population')]
                  + [{'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                     {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                     {'path': NOTE, 'role': 'integration', 'sha256': sha(NOTE)},
                     {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
                     {'path': RECHECK, 'role': 'integration', 'sha256': sha(RECHECK)},
                     {'path': CH7, 'role': 'statement', 'sha256': sha(CH7)}],
    'proof_bindings': [{'source': LEAN['ComparingCourses'], 'receipt': RECEIPT,
                        'sha256_pointer': '/source_sha256/Becoming.ComparingCourses',
                        'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [history_entry],
}
deps = [x['id'] for x in record['dependencies']] + [x['id'] for x in record['related']]
for rid in deps:
    assert (RECORDS / f'{rid}.json').exists(), rid
path = RECORDS / f'{RID}.json'
assert not path.exists()
path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record:', RID, len(names), 'declarations in', len(groups), 'laws')


def load(rid):
    return json.loads((RECORDS / f'{rid}.json').read_text(encoding='utf-8'))


def save(rid, d):
    (RECORDS / f'{rid}.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def history(d, en, zh):
    d['history'].append({'en': f'{DATE_EN}, board item UE9 (study section {N}): {en}',
                         'zh': f'{DATE_ZH}，工作板条目 UE9（研究第 {N} 节）：{zh}'})


# eventual widening: its lag decided, the next step pointed here
d = load('eventual-widening')
assert d['next_delta']['en'].startswith('A comparison of two courses that decides the lag (UE9); '), d['next_delta']
assert d['next_delta']['zh'].startswith('决定滞后的两进程之比较（UE9）；'), d['next_delta']
d['next_delta'] = EW_ND
assert RID not in [x['id'] for x in d['related']]
d['related'].append({'id': RID, 'detail': {
    'en': 'Comparing two courses on what they admit: widening with a lag decides the lag, as does a tail order, and '
          'widening with a lag and eventual widening rank a pair oppositely.',
    'zh': '就所纳比较两个进程：带滞后的扩大判定滞后，尾序亦然，而带滞后的扩大与最终扩大对一对进程排序相反。'}})
history(d, f'the next step updated: the lag is decided in {RID}; the counterexample (a lag defeats eventual widening) '
           'stands, and no declaration changed.',
        f'下一步随之更新：滞后于 {RID} 中得判；反例（滞后挫败最终扩大）仍立，无一声明改变。')
save('eventual-widening', d)

# what keeping widening needs: the comparison done, the next step pointed here
d = load('what-keeping-widening-needs')
assert d['next_delta']['en'].startswith('A comparison of two courses on admitted ranges (UE9); '), d['next_delta']
assert d['next_delta']['zh'].startswith('在所纳范围上对两个进程之比较（UE9）；'), d['next_delta']
d['next_delta'] = KW_ND
assert RID not in [x['id'] for x in d['related']]
d['related'].append({'id': RID, 'detail': {
    'en': 'Comparing two courses on what they admit, which no law here does.',
    'zh': '就所纳比较两个进程，此处无一律为之。'}})
history(d, f'the next step updated: two courses are compared on admitted ranges in {RID}; no declaration changed.',
        f'下一步随之更新：两个进程于 {RID} 中在所纳范围上得比较；无一声明改变。')
for field, old, new in KW_PREMISES:
    target = d[field] if field == 'statement' else (d['laws'][8] if field == 'law 9' else d['hypotheses'][0])
    for lang in ('en', 'zh'):
        assert target[lang].count(old[lang]) == 1, (field, lang)
        target[lang] = target[lang].replace(old[lang], new[lang])
capped('statement', d['statement'])
capped('laws', d['laws'][8], item=True)
capped('hypotheses', d['hypotheses'][0], item=True)
history(d, "the passing laws stated with requirements never loosening, a hypothesis beside the World premises, as UE8's "
           'first review found (the statement, law 9 and the premises, with 07 §2 and the Open items of 07 and 02); the '
           "statement's last sentence, none compares two courses, left to the first does-not-show item for the length "
           'cap; no declaration changed.',
        '支撑传递诸律陈明需求永不放松，此为世界前提之外的假设，如 UE8 首审所见（陈述、律九与前提，连同 07 §2 及 07、02 之未决项）；'
        '陈述末句“无一比较两个进程”因长度上限留于首条“未示”；无一声明改变。')
save('what-keeping-widening-needs', d)
print('records pointed here: eventual-widening, what-keeping-widening-needs')
