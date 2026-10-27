#!/usr/bin/env python3
"""UE10 records: write what-a-course-keeps-reachable (every declaration of Becoming.ReachableRanges, in twenty-three law
groups), and point comparing-two-courses-on-what-they-admit's, eventual-widening's and what-keeping-widening-needs' next
steps to it, each with a related entry and a history note. Asserts the receipt's hash and empty axiom reports for the
module, and the style caps (tools/research/style.py) on every field written. Mirrors UE9's make_records_ue9.py; no
landed module changes, so no record is re-pointed for Lean.
usage (from the checkout root, after texts_ue10.py): python3 -B make_records_ue10.py RECEIPT N
       python3 -B make_records_ue10.py --caps  (the caps and the declaration cover against the kit's scratch audit;
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
RECEIPT_ID, N = ('20261027T000000.000000Z', 423) if CAPS_ONLY else (sys.argv[1], int(sys.argv[2]))
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RF + 'BECOMING-RENEWAL-READING.md'
KITD = RF + 'development/ue10-what-can-be-reached/'
NOTE, REVIEW, RECHECK, RECHECK2 = (KITD + 'NOTE.md', KITD + 'REVIEW-UE10.md', KITD + 'RECHECK-UE10.md',
                                   KITD + 'RECHECK2-UE10.md')
CH7 = 'theories/becoming/chapters/07-SIGNIFICANCE.md'
LEAN = {m: f'{PKG}/Becoming/{m}.lean' for m in
        ('ReachableRanges', 'Frame', 'Labelled', 'Onward', 'Extension', 'Lexical', 'Bundles', 'EventualWidening',
         'Branching', 'Population', 'Prelude', 'Grammar', 'GrammarLaws', 'LawAlongRun')}
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
RID = 'what-a-course-keeps-reachable'
RID9 = 'comparing-two-courses-on-what-they-admit'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
TODAY = datetime.date.today()
DATE_EN, DATE_ZH = f'{TODAY.day} {TODAY:%B} {TODAY.year}', f'{TODAY.year}年{TODAY.month}月{TODAY.day}日'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def capped(field, pair, item=False):
    caps = style.ITEM_CAPS_V2 if item else style.CAPS_V2
    en, zh = caps[field][:2]
    assert len(pair['en']) <= en and len(pair['zh']) <= zh, (field, len(pair['en']), en, len(pair['zh']), zh, pair['en'][:60])
    return pair


if CAPS_ONLY:
    audit = (HERE.parent / 'tree/.build/BecomingReachableRangesAxiomAudit.lean').read_text(encoding='utf-8')
    names = set(re.findall(r'^#print axioms (\S+)$', audit, re.M))
else:
    core = json.loads((ROOT / RECEIPT).read_text())
    assert core['status'] == 'passed'
    module = 'Becoming.ReachableRanges'
    assert core['source_sha256'][module] == sha(LEAN['ReachableRanges']), module
    mod = next(x for x in core['modules'] if x['module'] == module)
    assert not any(mod['axiom_dependencies'].values()), module
    names = {d['name'] for d in mod['declarations']}
assert len(names) == 196, len(names)


def D(*short):
    out = ['Becoming.' + s for s in short]
    missing = [n for n in out if n not in names]
    assert not missing, missing
    return out


groups = [
    ("Ranges of courses. A course's range includes another's where what the other admits at an offset it admits "
     "there; exceeding and widening as for levels. These are the grammar's inclusion and exceeding of what the courses "
     "admit as (offset, formation) claims, and with fixed conditions 07's inclusion and widening. Range inclusion is a "
     "preorder, range widening irreflexive and transitive.",
     "进程之范围。一进程之范围包含另一者，若后者于某偏移所纳，前者于该偏移亦纳；超出与扩大同水平之例。此即语法对进程所纳（偏移、构成）之包含与超出，"
     "条件固定时即 07 之包含与扩大。范围包含为预序，范围扩大非自反且传递。",
     D('Run.RangeIncludes', 'Run.RangeExceeds', 'Run.RangeWidens', 'Run.admitted', 'Run.RangeIncludes.refl',
       'Run.RangeIncludes.trans', 'Run.RangeExceeds.not_included', 'Run.RangeWidens.irrefl', 'Run.RangeWidens.trans',
       'Run.rangeIncludes_iff', 'Run.rangeExceeds_iff', 'Run.rangeIncludes_conditions_iff',
       'Run.rangeWidens_conditions_iff')),
    ("Covering and widening what can be reached. A configuration covers another where every course from the other is "
     "included by some course from it, and widens what can be reached over it where it covers it and some course from "
     "it is included by none from the other. Covering is a preorder; widening what can be reached is irreflexive and "
     "transitive, composes with covering on either side and is not covered back; no premise.",
     "覆盖与可达之扩大。一构型覆盖另一者，若后者出发之每一进程皆为前者出发之某进程所包含；若覆盖之且前者出发之某进程不为后者出发之任何进程所包含，"
     "则扩大可达者。覆盖为预序；可达之扩大非自反、传递，两侧皆与覆盖相合，且不被反向覆盖；无前提。",
     D('Reaching.Covers', 'Reaching.Widens', 'Reaching.Covers.refl', 'Reaching.Covers.trans', 'Reaching.Widens.covers',
       'Reaching.Widens.irrefl', 'Reaching.Widens.trans_covers', 'Reaching.Covers.trans_widens',
       'Reaching.Widens.trans', 'Reaching.widens_not_covered')),
    ("Covering implies inclusion now: a configuration covering one that starts a course admits now all it admits now; "
     "the converse fails (WiderNow), and one starting no course is covered by every configuration. So where s' starts a "
     "course and admits now what s does not, widening what can be reached does not rank s above s', nor, the realized "
     "courses starting at their configurations, does the lexical order.",
     "覆盖蕴含当下之包含：覆盖一起进程之构型者，当下纳后者当下所纳之一切；当下之包含不给出覆盖（WiderNow 上），不起进程之构型为每一构型所覆盖。"
     "故 s' 起进程且当下纳 s 所不纳时，可达之扩大不把 s 排在 s' 之上；实现之进程起于其构型时，字典序亦然。",
     D('Reaching.Covers.now', 'Reaching.not_widens_of_wider_now', 'Reaching.covers_of_no_course',
       'Reaching.not_above_wider_now', 'WiderNow.inclusion_now_not_covering')),
    ("Witness EndsNow: some n climbs, admitting the formations up to n; none has no step and admits every formation. "
     "What the climb from some 0 admits keeps widening, none admits now what it does not, and some 0 widens what can be "
     "reached over none, which starts no course: the premise that the configuration wider now starts a course is "
     "needed.",
     "见证 EndsNow：some n 攀升，纳至 n 之构成；none 无步而纳每一构成。自 some 0 之攀升所纳持续扩大，none 当下纳其所不纳，而 some 0 扩大可达者于"
     "不起进程之 none 之上：当下更宽之构型起进程之前提不可少。",
     D('EndsNow.process', 'EndsNow.adm', 'EndsNow.climb', 'EndsNow.no_course', 'EndsNow.climb_keeps',
       'EndsNow.keeps_widening_above_wider_now')),
    ("Greatest courses and determined processes. Where each configuration has a course including every course from "
     "it, widening what can be reached is the strict part of range inclusion of those courses; such a course can exist "
     "where courses differ. Where any two courses from one configuration agree, as for a determined law, every course "
     "is greatest, so it is the strict part of range inclusion of the two courses.",
     "最大进程与决定性过程。每一构型皆有包含其出发之每一进程者时，可达之扩大即这些进程之范围包含的严格部分；进程不一时亦可有此进程。"
     "同一构型出发之任二进程一致时（如决定性律），每一进程皆最大，故即两进程范围包含之严格部分。",
     D('Reaching.widens_iff_of_greatest', 'Reaching.widens_of_rangeWidens_greatest', 'Reaching.greatest_of_unique',
       'Reaching.widens_iff_of_unique', 'Reaching.widens_of_rangeWidens', 'Law.runs_agree')),
    ("Covering with a lag: every course from the other is included d offsets later by a course from it, UE9's "
     "inclusion with a lag read on courses; lag 0 is covering and lags add. Widening with a lag is covering with some "
     "lag and covered back with none; joined to widening what can be reached as UE9 joins its orders, it is a strict "
     "partial order ranking no configuration above one covering it, so never reversing widening.",
     "带滞后之覆盖：后者出发之每一进程皆于 d 个偏移之后为前者出发之某进程所包含，即 UE9 之带滞后包含读于进程；滞后 0 即覆盖，滞后相加。带滞后之扩大即"
     "以某滞后覆盖而不被反向覆盖；如 UE9 合其序那样并入可达之扩大，得一严格偏序，从不把构型排在覆盖它者之上，故从不逆转扩大。",
     D('Reaching.CoversLater', 'Reaching.CoversLater.zero', 'Reaching.CoversLater.trans', 'Reaching.WidensWithLag',
       'Reaching.WidensOrLater', 'Reaching.WidensOrLater.irrefl', 'Reaching.WidensOrLater.trans',
       'Reaching.WidensOrLater.not_covered', 'Reaching.WidensOrLater.not_reversed')),
    ("On a determined process covering with lag d is inclusion with lag d of the two courses, and the lagged order is the strict part of their range inclusion joined "
     "to the strict part of their inclusion with some lag. Along a course widening with a lag never ranks a "
     "configuration above its predecessor, so the lagged order ranks a successor above it exactly where same-offset "
     "widening does.",
     "决定性过程上，滞后 d 之覆盖即两进程滞后 d 之包含，滞后之序即其范围包含之严格部分并入其某滞后包含之严格部分。"
     "沿一进程，带滞后之扩大从不把构型排在其前驱之上，故滞后之序把后继排在前驱之上，恰在同偏移之扩大如此之处。",
     D('Reaching.coversLater_iff_of_unique', 'Reaching.widensOrLater_iff_of_unique', 'Run.not_widensWithLag_next',
       'Run.widensOrLater_next_iff')),
    ("Witness WiderNow, a determined law: none stays, admitting formations 0 and 1; some n climbs, admitting those up "
     "to n. What the climb from some 0 admits keeps widening, none admits now what it does not, and each course exceeds "
     "the other; same-offset widening and the lexical order are silent both ways, and the lagged order ranks the climb "
     "above none and not conversely.",
     "见证 WiderNow，决定性律：none 停留，纳构成 0 与 1；some n 攀升，纳至 n 者。自 some 0 之攀升所纳持续扩大，none 当下纳其所不纳，二进程互相超出；"
     "同偏移之扩大与字典序两向皆默，滞后之序把攀升排在 none 之上而非反之。",
     D('WiderNow.next', 'WiderNow.process', 'WiderNow.adm', 'WiderNow.course', 'WiderNow.course_start',
       'WiderNow.silent', 'WiderNow.decided')),
    ("On WiderNow's process, with none admitting one side's first formation and every formation of the other, each "
     "course exceeds the other and the lagged order is silent both ways; with none admitting every formation, it ranks "
     "none above the climb, as it must. Widening what can be reached and the lagged order satisfy C on the frame of "
     "reachable ranges and differ on WiderNow: the lag's verdict is a premise beyond C.",
     "WiderNow 之过程上，none 纳一侧之首构成与另一侧之每一构成时，二进程互相超出而滞后之序两向皆默；none 纳每一构成时，它把 none "
     "排在攀升之上，理当如此。可达之扩大与滞后之序皆于可达范围之框上满足 C，而于 WiderNow 上相异：滞后之判定是 C 之外之前提。",
     D('WiderNow.TwoSided.adm', 'WiderNow.TwoSided.silent', 'WiderNow.Full.adm', 'WiderNow.Full.not_silent',
       'Reaching.comparison_widens', 'Reaching.comparison_widensOrLater', 'WiderNow.comparison_undecided')),
    ("The possible. The whole possible from s is what some configuration reachable from s admits; the possible within "
     "k, what some configuration reached in at most k steps admits. They are realizability of the one-formation bundle "
     "within some bound and within k moves (Labelled's WithinMoves). The possible within a horizon is possible, grows "
     "with the horizon and contains the present.",
     "可能者。自 s 之全部可能，即自 s 可达之某构型所纳；k 内之可能，即至多 k 步所达之某构型所纳。二者即单一构成之束于某界内、于 k 步内可实现"
     "（Labelled 之 WithinMoves）。一视界内之可能皆可能，随视界增大，且含当下。",
     D('Reaching.Possible', 'Reaching.PossibleWithin', 'Reaching.possibleWithin_iff_withinMoves',
       'Reaching.possible_iff_withinMoves', 'Reaching.PossibleWithin.possible', 'Reaching.PossibleWithin.mono',
       'Reaching.PossibleWithin.present')),
    ("Nothing is added to the whole possible along a course: what is possible from a reachable configuration is "
     "possible from the first (from together_after_reach), so from no later configuration of a course is anything new "
     "possible; a step losing a possibility has no way back (from lost_together_not_returns); what is possible within k "
     "of the next configuration is possible within k + 1 of the present one.",
     "沿一进程全部可能无所增：自可达构型可能者自起点亦可能（出自 together_after_reach），故进程之后续构型无一新者可能；失去一可能之步无回路"
     "（出自 lost_together_not_returns）；自下一构型 k 内可能者，自当下 k + 1 内亦可能。",
     D('Reaching.Possible.of_reach', 'Run.possible_of_next', 'Run.possible_of_later', 'Run.possible_from_start',
       'Run.possibleWithin_moves', 'Run.not_possible_returns')),
    ("Covering carries the possible where courses exist. A trace into a course's start gives a course whose states "
     "from some step on are the other's (the strong form of Onward.run_of_trace). So where every configuration "
     "reachable from s' starts a course, a configuration covering s' has all that is possible from it, and a step whose "
     "later configuration covers the earlier leaves the whole possible unchanged.",
     "进程存在处覆盖承载可能。进入一进程起点之迹给出一进程，其自某步起之状态即后者之状态（Onward.run_of_trace 之强形式）。故自 s' "
     "可达之每一构型皆起进程时，覆盖 s' 之构型有自其可能之一切；后一构型覆盖前者之步令全部可能不变。",
     D('Run.tail_of_trace', 'Run.tail_of_reach', 'Reaching.Covers.possible', 'Run.possible_same_of_covers_next')),
    ("Witness NoCourse: true stays, admitting nothing; false has no step and admits every formation. Covering reads "
     "infinite courses only, so true widens what can be reached over false, which starts no course, while everything "
     "is possible from false and nothing from true: covering carrying the possible needs its premise.",
     "见证 NoCourse：true 停留，无所纳；false 无步而纳每一构成。覆盖只读无穷进程，故 true 扩大可达者于不起进程之 false 之上，而自 false 一切皆可能、"
     "自 true 无一可能：覆盖承载可能需其前提。",
     D('NoCourse.process', 'NoCourse.adm', 'NoCourse.stay', 'NoCourse.no_course', 'NoCourse.from_true',
       'NoCourse.widens_reversed')),
    ("The rise. With a lag of one step each configuration of a course covers its successor; on a determined process "
     "the next configuration widens what can be reached over the present one exactly when the course one step on "
     "strictly includes the course. On Rise's rising step it rises while the whole possible and the possible within "
     "each horizon past the present stay the same.",
     "上升。滞后一步时，进程之每一构型覆盖其后继；决定性过程上，下一构型扩大可达者于当下者之上，恰当后移一步之进程严格包含进程本身。"
     "Rise 之上升步上，可达之扩大上升，而全部可能及当下以外每一视界内之可能皆不变。",
     D('Run.coversLater_next', 'Reaching.widens_next_iff_rising', 'Rise.process', 'Rise.process_eq_law', 'Rise.adm',
       'Rise.stay', 'Rise.course', 'Rise.adm_le', 'Rise.rises', 'Rise.possible_same', 'Rise.possibleWithin_same')),
    ("Keeping widening needs an unlisted range. A chain keeps widening (07's form) where nothing held is lost and "
     "after every step something not held is held later; it gathers n distinct members at one step for every "
     "n, so no list holds it. Along a course the possible within k does not keep widening where a list holds it or "
     "the whole possible. By name, keeping widening is exactly such a chain, which gives its law by name.",
     "持续扩大需无列表之范围。一链持续扩大，若所持无一后失，且每步之后有未持者后被持，即自首步起之 07 形式；它对每一 n 于一步聚 n 个不同成员，"
     "故无列表持之。沿一进程，有列表持 k 内之可能或全部可能时，k 内之可能不持续扩大。按名持续扩大恰为此种链，由之得其按名之律。",
     D('Reaching.KeepsWidening', 'Reaching.KeepsWidening.gathers', 'Reaching.KeepsWidening.not_listed',
       'Reaching.not_keepsWidening_of_listed_along', 'Reaching.listed_along_of_listed',
       'Reaching.not_keepsWidening_of_listed', 'Web.KeepsWidening.chain', 'Web.KeepsWidening.of_chain',
       'Web.keepsWidening_iff_chain', 'Web.KeepsWidening.not_listed_via_chain')),
    ("Witnesses. On Climb, the determined law of the successor with n admitting the formations up to n, the possible "
     "within every horizon keeps widening and no list holds the whole possible. The converse fails: from AllAtOnce's "
     "one configuration, admitting every formation, no list holds the whole possible, and along no course does the "
     "possible within any horizon keep widening.",
     "见证。Climb 为后继之决定性律，n 纳至 n 之构成，其上每一视界内之可能持续扩大，无列表持全部可能。其逆不成立：AllAtOnce 之唯一构型纳每一构成，"
     "无列表持全部可能，而沿任一进程，无一视界内之可能持续扩大。",
     D('Climb.process', 'Climb.process_eq_law', 'Climb.adm', 'Climb.course', 'Climb.trace_units', 'Climb.trace_end',
       'Climb.within_le', 'Climb.within_of_le', 'Climb.keeps', 'Climb.not_listed', 'AllAtOnce.process',
       'AllAtOnce.adm', 'AllAtOnce.converse_fails')),
    ("Witness KeptAlternative. E's course runs through configurations admitting formations 0 and 1. From k two "
     "branches: the realized one admits 0, a wide one not realized admits at each later step t the formations up to "
     "t + 1; from single only the realized one; k and single admit 0 and 1. The realized course from each configuration "
     "starts there; the wide branch includes every course from k, though courses from k differ.",
     "见证 KeptAlternative。E 之进程经过纳构成 0 与 1 之构型。自 k 有二分支：实现者纳 0，未实现之宽分支于其后每一步 t 纳至 t + 1 者；"
     "自 single 仅实现者；k 与 single 纳 0 与 1。各构型之实现进程起于该处；宽分支包含自 k 之每一进程，虽自 k 之进程不一。",
     D('KeptAlternative.Config', 'KeptAlternative.process', 'KeptAlternative.adm', 'KeptAlternative.realized',
       'KeptAlternative.unrealized', 'KeptAlternative.fromSingle', 'KeptAlternative.course',
       'KeptAlternative.course_start', 'KeptAlternative.fromE_states', 'KeptAlternative.fromSingle_states',
       'KeptAlternative.from_k', 'KeptAlternative.realized_le', 'KeptAlternative.unrealized_of_le',
       'KeptAlternative.greatest_not_unique')),
    ("Realized and reachable widening rank a pair oppositely, on this witness: E's realized course widens k's, while k "
     "widens what can be reached over E through its course not realized; so no strict partial order contains both, nor "
     "satisfies C on both the realized courses and the reachable ranges. On a determined process, with realized "
     "courses starting at their configurations, realized widening gives reachable widening.",
     "于此见证上，实现之扩大与可达之扩大对一对排序相反：E 之实现进程扩大 k 者，而 k 经未实现之进程扩大可达者于 E 之上；故无严格偏序兼含二者，"
     "亦无一既于实现进程上又于可达范围上满足 C。决定性过程上，实现之进程起于其构型时，实现之扩大给出可达之扩大。",
     D('KeptAlternative.disagree', 'KeptAlternative.no_order_contains_both', 'KeptAlternative.no_comparison_both')),
    ("The lexical order, realized widening or the same realized range and widening what can be reached, is a strict "
     "partial order containing realized widening and never reversing it. It lies inside the two-tier lexical order read "
     "on realized claims, then reachable ranges, which gives it back where inclusions are decided. It ranks k above "
     "single, with the same realized ranges, which realized widening leaves unranked.",
     "字典序：实现之扩大，或实现范围相同而扩大可达者，为包含实现之扩大且从不逆转之的严格偏序。它位于本包之二层字典序之内（先读实现之断言，再读可达范围）；"
     "包含可判定时二层之序给回它。它把 k 排在 single 之上，二者实现范围相同，实现之扩大不排之。",
     D('Reaching.Lexical', 'Reaching.Lexical.irrefl', 'Reaching.Lexical.trans', 'Reaching.Lexical.of_rangeWidens',
       'Reaching.Lexical.not_reversed', 'Reaching.realizedClaims', 'Reaching.realizedFrame', 'Reaching.lexical_above',
       'Reaching.lexical_of_above_decided', 'KeptAlternative.same_realized', 'KeptAlternative.tie')),
    ("Covering is the lower (Hoare) preorder of the families of course ranges: inclusion of the ranges some course "
     "includes, dominance for every criterion on ranges closed upward under inclusion, and carrying the profiles of the "
     "courses on the frame of courses, so preserving every bundle of their (offset, formation) admissions.",
     "覆盖是进程范围之族的下（Hoare）预序：某进程所包含之范围的包含，对范围上每一向上封闭于包含之判据的支配，且于进程之框上承载进程之轮廓，"
     "故保持其（偏移、构成）所纳之每一束。",
     D('Reaching.reachableRanges', 'Reaching.covers_iff_included', 'Reaching.covers_iff_criteria',
       'Reaching.coursesFrame', 'Reaching.covers_iff_carries', 'Reaching.covers_iff_preserves')),
    ("Widening what can be reached is extension, every claim living, on the frame of reachable ranges, both ways and "
     "with no premise; so C read on reachable ranges is Comparison (Reaching.reachFrame P adm) (fun _ => True), a "
     "definition.",
     "可达之扩大即可达范围之框上的延展（每一断言皆活），两向且无前提；故读于可达范围之 C 即 "
     "Comparison (Reaching.reachFrame P adm) (fun _ => True)，乃一定义。",
     D('Reaching.reachFrame', 'Reaching.widens_iff_extension')),
    ("Witness DeferredBranching: late steps to mid, which steps to a or to b; early steps at once to ma or to mb, which "
     "step to a and to b. late and early cover each other, yet one step on the next configuration of every course from "
     "late widens what can be reached over that of every course from early; late simulates early, and no simulation "
     "relates late to early. Covering cannot see when a commitment is made.",
     "见证 DeferredBranching：late 步至 mid，mid 步至 a 或 b；early 即步至 ma 或 mb，二者分别步至 a 与 b。late 与 early 互相覆盖，然一步之后，"
     "自 late 之每一进程的下一构型扩大可达者于自 early 者之上；late 模拟 early，而无模拟把 late 关联于 early。覆盖看不见承诺何时作出。",
     D('DeferredBranching.Config', 'DeferredBranching.process', 'DeferredBranching.adm', 'DeferredBranching.lateA',
       'DeferredBranching.lateB', 'DeferredBranching.earlyA', 'DeferredBranching.earlyB', 'DeferredBranching.midA',
       'DeferredBranching.midB', 'DeferredBranching.stepped', 'DeferredBranching.at_a', 'DeferredBranching.at_b',
       'DeferredBranching.from_early', 'DeferredBranching.from_late', 'DeferredBranching.includes_of', 'DeferredBranching.moved',
       'DeferredBranching.cover_both', 'DeferredBranching.mid_widens_ma', 'DeferredBranching.mid_widens_mb',
       'DeferredBranching.widens_after_one_step', 'DeferredBranching.Simulation', 'DeferredBranching.early_not_simulating_late',
       'DeferredBranching.lateOverEarly', 'DeferredBranching.late_simulates_early')),
    ("Witness KeptTogether: both stays; split steps to zero or to one, each staying. The two have the same whole "
     "possible and the same bundles realizable within every bound, yet both widens what can be reached over split: a "
     "course from both holds the two formations at every offset, each from split only at its start. So here no "
     "irreflexive comparison of descriptions the bundles determine satisfies C on reachable ranges.",
     "见证 KeptTogether：both 停留；split 步至 zero 或 one，各自停留。二者全部可能相同，每一界内可共同实现之束亦同，然 both 扩大可达者于 split 之上："
     "自 both 之一进程于每一偏移共持二构成，自 split 之每一进程仅于起点共持。故于此读自这些束所定之描述、不比较任一描述与自身之比较，无一于可达范围上满足 C。",
     D('KeptTogether.Config', 'KeptTogether.process', 'KeptTogether.adm', 'KeptTogether.adm_le', 'KeptTogether.loop',
       'KeptTogether.stays', 'KeptTogether.split_courses', 'KeptTogether.possible_le', 'KeptTogether.same_possible',
       'KeptTogether.same_bundles', 'KeptTogether.widens', 'KeptTogether.no_comparison_through_bundles')),
]
cited = [n for _, _, ds in groups for n in ds]
assert len(cited) == len(set(cited)), [n for n in cited if cited.count(n) > 1]
assert set(cited) == names, (sorted(names - set(cited)), sorted(set(cited) - names))
laws = [capped('laws', {'en': en, 'zh': zh, 'declarations': ds}, item=True) for en, zh, ds in groups]

title = capped('title', {'en': 'What a course keeps reachable', 'zh': '进程保持可达者'})
statement = capped('statement', {
    'en': "Covering, comparing what courses keep reachable offset by offset, implies inclusion now, so only with a lag "
          "does it rank a range that keeps widening above one wider now that starts a course, a verdict C leaves open. "
          "On a branching witness realized and reachable widening rank a pair oppositely.",
    'zh': '覆盖即逐偏移比较进程保持可达者，它蕴含当下之包含，故仅带滞后时才把持续扩大的范围排在起进程且当下更宽者之上，此判定 C 不定。'
          '在一分支见证上，实现之扩大与可达之扩大对一对排序相反。'})
hypotheses = [capped('hypotheses', x, item=True) for x in (
    {'en': "No axiom. Each law holds on every process with what each configuration admits given, or on a witness; "
           "inclusion now and the laws on it take the configuration wider now to start a course, covering carrying the "
           "possible takes every configuration reachable from the covered one to start one, and the laws on realized "
           "courses take each to start at its configuration.",
     'zh': '不加公理。每一律于每一过程（各构型所纳给定）或于一见证上成立；当下之包含及其上之律需当下更宽之构型起进程；覆盖承载可能，需自被覆盖者可达之每一构型皆起进程；'
           '关于实现进程之律需其起于其构型。'},
    {'en': "Modelling choices: discrete steps; courses are infinite runs, so a configuration starting no course is "
           "covered by every configuration; the possible reads finite traces; courses compared at the same offsets, or "
           "with one lag for every offset; formations compared by name over one fixed type; one fixed process; the "
           "realized course a function on configurations.",
     'zh': '建模之选：离散之步；进程为无穷之运行，故不起进程之构型为每一构型所覆盖；可能者读有穷之迹；进程按同一偏移比较，或每一偏移同一滞后；'
           '构成在一固定类型上按名比较；一个固定过程；实现之进程为构型之函数。'})]
does_not_show = [capped('does_not_show', x, item=True) for x in (
    {'en': "That the lagged order, the lexical order or any order here is the second-order direction of 生生 or ranks a "
           "course better: ranking needs C, and the lag's verdict, which C leaves open, or a rule of precedence is a "
           "further premise.",
     'zh': '滞后之序、字典序或此处任一序即生生的二阶方向或把进程排得更好：排序需要 C，而 C 不定之滞后判定或优先之规则是又一前提。', 'kind': 'non-implication'},
    {'en': "That read with a lag covering decides every pair of a range that keeps widening and one wider now that "
           "starts a course: it decides one witness's pair, and on another, each course exceeding the other, it is "
           "silent both ways.",
     'zh': '带滞后读时覆盖判定每一持续扩大之范围与起进程且当下更宽者之对：它判定一见证之对，于另一处（二进程互相超出）两向皆默。', 'kind': 'non-implication'},
    {'en': "That the lagged order is UE9's: it is built as UE9's is, on families of courses, and UE9's laws on its order "
           "(names read across steps, the conflict with eventual widening) are not proved of it.",
     'zh': '滞后之序即 UE9 之序：它如 UE9 之序那样构于进程之族，UE9 关于其序之律（跨步读名、与最终扩大之冲突）未对其证明。', 'kind': 'scope'},
    {'en': "A branching witness for keeping the possible within a horizon widening: Rise, Climb and WiderNow are "
           "determined, so on them every notion here is a property of single courses.",
     'zh': '一视界内之可能持续扩大之分支见证：Rise、Climb 与 WiderNow 皆决定性，其上此处每一概念皆单一进程之性质。', 'kind': 'scope'},
    {'en': "Anything about learning or quasi-option value: covering cannot see when a commitment is made.",
     'zh': '关于学习或准选择价值之任何结论：覆盖看不见承诺何时作出。', 'kind': 'scope'},
    {'en': "The adjacent possible that cannot be prestated, or a process that changes itself: one process, one type of "
           "formations and one reading are fixed.",
     'zh': '不可预先陈述之邻近可能，或自我改变之过程：一个过程、一种构成类型与一种读法皆固定。', 'kind': 'scope'},
    {'en': "Anything about what carries a course's openings, 07's remaining candidate.",
     'zh': '关于承载进程之开出者（07 余下之候选）之任何结论。', 'kind': 'scope'},
    {'en': "A result no neighbouring field states: covering is the lower preorder, and the irreversibility premise and "
           "the pigeonhole of finite recurrence are restated; each law is near-definitional or a witness.",
     'zh': '近邻领域无人陈述的结果：覆盖即下预序，不可逆前提与有限复现之鸽巢原理为重述；每一律近乎定义或为见证。', 'kind': 'correspondence'})]
validation_scope = capped('validation_scope', {
    'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): Becoming.ReachableRanges, '
          f'{len(names)} declarations, every one with an empty axiom report, all cited here; Web.KeepsWidening.chain, '
          f'.of_chain, .not_listed_via_chain, Web.keepsWidening_iff_chain and Law.runs_agree sit in the leaf until the owners '
          f'of the definitions they concern move them. Built in one session; an independent read-only review by a separate AI agent (REVIEW-UE10) and '
          f'two re-checks (RECHECK-UE10, RECHECK2-UE10), in study section {N}; not reviewed by a person.',
    'zh': f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：Becoming.ReachableRanges 之 {len(names)} 项声明，公理报告皆空，本记录全引；'
          f'按名持续扩大之链之律诸定理与 Law.runs_agree 暂居此叶，待其所涉定义之主移之。于一会话中构建；另一 AI '
          f'代理作独立只读审查（REVIEW-UE10）并两次复查（RECHECK-UE10、RECHECK2-UE10），见研究第 {N} 节；未经人审。'})
next_delta = capped('next_delta', {
    'en': "What carries a course's openings, 07's remaining candidate; a branching witness for keeping the possible "
          "within a horizon widening; a reason, or a premise, for a rule of precedence between realized and reachable "
          "widening, or for a lag's verdict; review by a person.",
    'zh': '承载进程之开出者，07 余下之候选；一视界内之可能持续扩大之分支见证；实现与可达之扩大间优先规则或滞后之理由或前提；人之审查。'})
correspondence = capped('correspondence', {
    'en': "Covering is the lower (Hoare) preorder of the families of course ranges, exactly dominance for every "
          "criterion closed upward under inclusion; read by the AI, the unanimous ordinal form of a preference for "
          "flexibility (Kreps 1979). With options unordered it is the inclusion opportunity-set rankings share (Jones "
          "and Sugden 1982; Bossert, Pattanaik and Xu 1994), while Pattanaik and Xu (1990) count options. Nothing "
          "added to the whole possible is the irreversibility premise of Arrow and Fisher (1974) and Henry (1974); "
          "quasi-option value, needing learning and deferral, is not captured, covering being linear-time (van "
          "Glabbeek 1990). The possible within a horizon restates Kauffman's adjacent possible (2000) for a prestated "
          "space, not the one that cannot be prestated (Longo, Montévil and Kauffman 2012); no listed range keeping "
          "widening is the pigeonhole of finite recurrence, with the open-ended evolution papers (Bedau and others "
          "2000; Taylor and others 2016; Adams and others 2017) as neighbours. The lexical order is the two-tier order, "
          "near Sen's achievement and freedom (1985); assembly theory is an analogy. Graded in UE10's NOTE, "
          "REVIEW-UE10 and RECHECK-UE10.",
    'zh': '覆盖是进程范围之族的下（Hoare）预序，恰为对每一向上封闭于包含之判据的支配；依 AI 之读，即偏好灵活性之一致序形式（Kreps 1979）。选项无序时即机会集排序'
          '共有之包含（Jones 与 Sugden 1982；Bossert、Pattanaik 与 Xu 1994），Pattanaik 与 Xu（1990）则计选项。全部可能无所增即 Arrow 与 Fisher（1974）'
          '及 Henry（1974）之不可逆前提；准选择价值需学习与延迟，未被捕捉，覆盖为线性时间（van Glabbeek 1990）。视界内之可能为预先陈述之空间重述 Kauffman 之'
          '邻近可能（2000），非不可预先陈述者（Longo、Montévil 与 Kauffman 2012）；无列表之范围持续扩大即有限复现之鸽巢原理，开放式演化诸文为近邻。字典序即二层之序，'
          '近 Sen 之成就与自由（1985）；组装理论为类比。分级见 UE10 之 NOTE、REVIEW-UE10 与 RECHECK-UE10。'})
counterexamples_text = [
    {'en': 'Same-offset covering is silent on a climb that keeps widening against a configuration wider now '
           '(WiderNow.silent), which the lagged order decides (WiderNow.decided).',
     'zh': '同偏移之覆盖对持续扩大之攀升与当下更宽之构型沉默（WiderNow.silent），滞后之序判定之（WiderNow.decided）。'},
    {'en': 'With other admissions on the same process, each course exceeding the other, the lagged order is silent '
           'both ways (WiderNow.TwoSided.silent); where the configuration wider now also widens what can be reached '
           'over the climb, it ranks that configuration above (WiderNow.Full.not_silent).',
     'zh': '同一过程上换一种所纳，二进程互相超出，滞后之序两向皆默（WiderNow.TwoSided.silent）；当下更宽之构型亦扩大可达者于攀升之上时，'
           '它把该构型排在上（WiderNow.Full.not_silent）。'},
    {'en': 'Where the configuration wider now starts no course, widening what can be reached ranks a climb that keeps '
           'widening above it (EndsNow.keeps_widening_above_wider_now).',
     'zh': '当下更宽之构型不起进程时，可达之扩大把持续扩大之攀升排在其上（EndsNow.keeps_widening_above_wider_now）。'},
    {'en': 'Inclusion now does not give covering (WiderNow.inclusion_now_not_covering).',
     'zh': '当下之包含不给出覆盖（WiderNow.inclusion_now_not_covering）。'},
    {'en': 'A configuration starting no course is covered by every configuration, and one from which nothing is '
           'possible widens what can be reached over it, everything being possible from it (NoCourse.widens_reversed).',
     'zh': '不起进程之构型为每一构型所覆盖，且自其无一可能之构型扩大可达者于其上，而自其一切皆可能（NoCourse.widens_reversed）。'},
    {'en': 'Same-offset widening of what can be reached rises along a course while the whole possible stays the same '
           '(Rise.rises, Rise.possible_same).',
     'zh': '同偏移之可达扩大沿一进程上升，而全部可能不变（Rise.rises、Rise.possible_same）。'},
    {'en': 'From one configuration admitting every formation no list holds the whole possible, and the possible within '
           'no horizon keeps widening (AllAtOnce.converse_fails).',
     'zh': '自纳每一构成之唯一构型，无列表持全部可能，而无一视界内之可能持续扩大（AllAtOnce.converse_fails）。'},
    {'en': "E's realized course widens k's while k widens what can be reached over E (KeptAlternative.disagree).",
     'zh': 'E 之实现进程扩大 k 者，而 k 扩大可达者于 E 之上（KeptAlternative.disagree）。'},
    {'en': 'Two configurations with the same whole possible and the same bundles within every bound differ in what can '
           'be reached (KeptTogether.same_bundles, KeptTogether.widens).',
     'zh': '全部可能相同、每一界内之束亦同之二构型，其可达者不同（KeptTogether.same_bundles、KeptTogether.widens）。'},
    {'en': 'late and early cover each other while only late simulates early (DeferredBranching.cover_both, '
           'DeferredBranching.early_not_simulating_late).',
     'zh': 'late 与 early 互相覆盖，而仅 late 模拟 early（DeferredBranching.cover_both、DeferredBranching.early_not_simulating_late）。'}]
history_entry = {
    'en': f'{DATE_EN}: added (UE10), what a course keeps reachable: covering implies inclusion now, so it never ranks a '
          f'configuration above one that starts a course and admits now what it does not; the lagged order on families '
          f'of courses decides one witness\'s pair, not every such pair, a verdict C leaves open; nothing is added to the '
          f'whole possible along a course; realized and reachable widening rank a pair '
          f'oppositely on a branching witness; covering is the lower preorder; near-definitional; after a review and two '
          f're-checks; study section {N}.',
    'zh': f'{DATE_ZH}：新增（UE10），进程保持可达者：覆盖蕴含当下之包含，故从不把一构型排在起进程且当下纳其所不纳者之上；进程之族上之滞后之序判定一见证之对，'
          f'非每一此种对，此判定 C 不定；'
          f'沿一进程全部可能无所增；在一分支见证上实现与可达之扩大对一对排序相反；覆盖即下预序；近乎定义；经审查与两次复查；研究第 {N} 节。'}

# the three records pointed here
C9_ND = capped('next_delta', {
    'en': f"What a course keeps reachable is read ({RID}): with a lag it is built as this record's lagged order is, on "
          "families of courses; what carries a course's openings remains; a reason, or a premise, for counting early "
          "steps or reading only tails; review by a person.",
    'zh': f'进程保持可达者已读（{RID}）：带滞后时如本记录之滞后之序那样构于进程之族；承载进程之开出者仍待；计早期之步或只读尾的理由或前提；人之审查。'})
EW_ND = capped('next_delta', {
    'en': "The lag is decided by widening with a lag and by a tail order containing eventual widening, which rank a pair "
          f"oppositely, so choosing is a premise ({RID9}); what a course keeps reachable is read: a lag decides one "
          f"witness's pair ({RID}); the gain bridge and the givers law are restatements (what-keeping-widening-needs); review by a "
          "person.",
    'zh': f'滞后由带滞后的扩大与包含最终扩大的尾序判定，二者对一对排序相反，故作选择是前提（{RID9}）；进程保持可达者已读：滞后定一见证之对（{RID}）；'
          '增益之桥与给予者之律为重述（what-keeping-widening-needs）；人之审查。'})
EW_OLD_START = ('The lag is decided by widening with a lag and by a tail order containing eventual widening; the first ranks '
                'a pair opposite to eventual widening, so choosing is a premise ')
KW_OLD = (f'Comparing two courses on admitted ranges is done ({RID9}), what a course keeps reachable and what carries its '
          'openings remaining;',
          f'在所纳范围上比较两个进程已成（{RID9}），进程保持可达者与承载其开出者仍待；')
KW_NEW = (f'Comparing two courses on admitted ranges and on what they keep reachable is done ({RID9}, {RID}), what '
          'carries their openings remaining;',
          f'在所纳范围上及就所保持可达者比较两个进程已成（{RID9}、{RID}），承载其开出者仍待；')

C9_OLD_START = "07's other two candidates, what a course keeps reachable and what carries its openings; "

if CAPS_ONLY:
    c9 = json.loads((RECORDS / f'{RID9}.json').read_text(encoding='utf-8'))
    assert c9['next_delta']['en'].startswith(C9_OLD_START), c9['next_delta']
    ew = json.loads((RECORDS / 'eventual-widening.json').read_text(encoding='utf-8'))
    assert ew['next_delta']['en'].startswith(EW_OLD_START), ew['next_delta']
    kw = json.loads((RECORDS / 'what-keeping-widening-needs.json').read_text(encoding='utf-8'))
    for d, old, new in ((kw, KW_OLD, KW_NEW),):
        for i, lang in enumerate(('en', 'zh')):
            assert d['next_delta'][lang].count(old[i]) == 1, (d['id'], lang)
            d['next_delta'][lang] = d['next_delta'][lang].replace(old[i], new[i])
        capped('next_delta', d['next_delta'])
    for x in counterexamples_text:
        assert len(x['en']) <= 600 and len(x['zh']) <= 300
    print('caps and cover pass:', len(names), 'declarations in', len(groups), 'laws; statement',
          len(statement['en']), len(statement['zh']), '; correspondence', len(correspondence['en']),
          len(correspondence['zh']), '; laws max', max(len(x['en']) for x in laws), max(len(x['zh']) for x in laws))
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
    'counterexamples': [{'path': LEAN['ReachableRanges'], 'detail': x} for x in counterexamples_text],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical',
                            'names-provisional', 'omission-not-refutation'],
    'validation_scope': validation_scope,
    'next_delta': next_delta,
    'correspondence': correspondence,
    'canonical_source': LEAN['ReachableRanges'],
    'aliases': ['What a course keeps reachable', '进程保持可达者', 'covering', 'widening what can be reached',
                'the whole possible', 'Becoming.Reaching.Widens', 'Becoming.Reaching.not_above_wider_now'],
    'dependencies': [
        {'id': RID9, 'relation': 'interpretive',
         'detail': {'en': 'The lagged order is built as its widening or widening with a lag is, on families of courses, '
                          'and covering with a lag reads Web.IncludesLater on courses; the module does not import it.',
                    'zh': '滞后之序如其带滞后或不带之扩大那样构于进程之族，带滞后之覆盖把 Web.IncludesLater 读于进程；本模块不引入之。'}},
        {'id': 'eventual-widening', 'relation': 'formal-reuse',
         'detail': {'en': 'Web.KeepsWidening and Web.KeepsWidening.not_listed: the chain law reads the first both '
                          'ways (Web.keepsWidening_iff_chain) and re-derives the second '
                          '(Web.KeepsWidening.not_listed_via_chain).',
                    'zh': 'Web.KeepsWidening 与 Web.KeepsWidening.not_listed：链之律双向读前者（Web.keepsWidening_iff_chain），'
                          '并重新推出后者（Web.KeepsWidening.not_listed_via_chain）。'}},
        {'id': 'effective-capacity-and-eventual-reachability', 'relation': 'formal-reuse',
         'detail': {'en': 'WithinMoves, withinMoves_iff_reach, together_after_reach, lost_together_not_returns and '
                          'WithinMoves.before: the possible as realizability of one formation, and nothing added from them.',
                    'zh': 'WithinMoves、withinMoves_iff_reach、together_after_reach、lost_together_not_returns 与 WithinMoves.before：'
                          '可能者即单一构成之可实现，全部可能无所增出自它们。'}},
        {'id': 'where-a-run-goes-on', 'relation': 'formal-reuse',
         'detail': {'en': 'Onward.run_of_trace, Onward.reach_of_run, Run.reach and Run.cons: courses built by prefixing.',
                    'zh': 'Onward.run_of_trace、Onward.reach_of_run、Run.reach 与 Run.cons：以前缀构建进程。'}},
        {'id': 'relational-generative-comparison', 'relation': 'formal-reuse',
         'detail': {'en': 'Extension, Comparison, Comparison.separates and carries_iff_preserves: widening what can be '
                          'reached as extension, C read on reachable ranges, and the separation by bundles.',
                    'zh': 'Extension、Comparison、Comparison.separates 与 carries_iff_preserves：可达之扩大即延展，读于可达范围之 C，及以束之分离。'}},
        {'id': 'becoming-spine-instances', 'relation': 'formal-reuse',
         'detail': {'en': 'CarriesProfiles and Lexical.Above: covering as carrying profiles, and the two-tier order the '
                          'lexical order lies inside.',
                    'zh': 'CarriesProfiles 与 Lexical.Above：覆盖即承载轮廓，及字典序所居之二层之序。'}},
        {'id': 'four-cases-of-a-part', 'relation': 'formal-reuse',
         'detail': {'en': 'Web.Includes and Web.Widens, which range inclusion and widening are with fixed conditions.',
                    'zh': 'Web.Includes 与 Web.Widens，条件固定时范围包含与扩大即此。'}},
        {'id': 'a-law-through-a-projection-along-one-run', 'relation': 'formal-reuse',
         'detail': {'en': 'Dependence.AdmitsAt, Dependence.along and Conditions, through which a dependence gives what '
                          'each configuration admits.',
                    'zh': 'Dependence.AdmitsAt、Dependence.along 与 Conditions，由之一依赖给出各构型所纳。'}},
        {'id': 'bounded-census-keeps-pace', 'relation': 'formal-reuse',
         'detail': {'en': 'length_le_of_sub, the pigeonhole of the chain law.',
                    'zh': 'length_le_of_sub，链之律之鸽巢原理。'}},
        {'id': 'continuation-relative-to-a-class', 'relation': 'formal-reuse',
         'detail': {'en': '«际» and «则», the grammar\'s relation and inclusion, which range inclusion is.',
                    'zh': '«际» 与 «则»，语法之关系与包含，范围包含即此。'}},
        {'id': 'master-laws-on-the-grammar', 'relation': 'formal-reuse',
         'detail': {'en': '«逾», the grammar\'s exceeding, which range exceeding is.',
                    'zh': '«逾»，语法之超出，范围超出即此。'}}],
    'related': [
        {'id': RID9,
         'detail': {'en': 'Its lagged order, built again on families of courses, decides one witness\'s pair where '
                          'same-offset covering is silent; admitted ranges carry no alternatives, which covering adds.',
                    'zh': '其滞后之序重构于进程之族，判定同偏移之覆盖沉默之一见证之对；所纳范围不带替代，覆盖添之。'}},
        {'id': 'eventual-widening',
         'detail': {'en': "Eventual widening's second order: covering implies inclusion now, so what a course keeps "
                          'reachable ranks a range that keeps widening above one wider now that starts a course only '
                          'with a lag, and not every such pair.',
                    'zh': '最终扩大之二阶：覆盖蕴含当下之包含，故进程保持可达者仅带滞后时把持续扩大之范围排在起进程且当下更宽者之上，且非每一此种对。'}},
        {'id': 'what-keeping-widening-needs',
         'detail': {'en': 'What one course keeping widening needs; here the possible within a horizon keeping widening '
                          'needs an unlisted range, by the same pigeonhole.',
                    'zh': '一个持续扩大的进程需要什么；此处一视界内之可能持续扩大需无列表之范围，同一鸽巢原理。'}},
        {'id': 'widening-as-what-every-weighting-ranks',
         'detail': {'en': "C read as widening; widening what can be reached is C's extension on the frame of reachable "
                          'ranges, and no order here is adopted by C.',
                    'zh': '读作扩大的 C；可达之扩大即 C 于可达范围之框上之延展，此处无一序为 C 所采。'}}],
    'references': [{'path': LEAN['ReachableRanges'], 'role': 'proof', 'declarations': sorted(names),
                    'sha256': sha(LEAN['ReachableRanges'])}]
                  + [{'path': LEAN[m], 'role': 'proof', 'sha256': sha(LEAN[m])}
                     for m in ('Frame', 'Labelled', 'Onward', 'Extension', 'Lexical', 'Bundles', 'EventualWidening',
                               'Branching', 'Population', 'Prelude', 'Grammar', 'GrammarLaws', 'LawAlongRun')]
                  + [{'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                     {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                     {'path': NOTE, 'role': 'integration', 'sha256': sha(NOTE)},
                     {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
                     {'path': RECHECK, 'role': 'integration', 'sha256': sha(RECHECK)},
                     {'path': RECHECK2, 'role': 'integration', 'sha256': sha(RECHECK2)},
                     {'path': CH7, 'role': 'statement', 'sha256': sha(CH7)}],
    'proof_bindings': [{'source': LEAN['ReachableRanges'], 'receipt': RECEIPT,
                        'sha256_pointer': '/source_sha256/Becoming.ReachableRanges',
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
    d['history'].append({'en': f'{DATE_EN}, board item UE10 (study section {N}): {en}',
                         'zh': f'{DATE_ZH}，工作板条目 UE10（研究第 {N} 节）：{zh}'})


# comparing two courses: what a course keeps reachable now read
d = load(RID9)
assert d['next_delta']['en'].startswith(C9_OLD_START), d['next_delta']
d['next_delta'] = C9_ND
assert RID not in [x['id'] for x in d['related']]
d['related'].append({'id': RID, 'detail': {
    'en': 'What a course keeps reachable: same-offset covering implies inclusion now, and the lagged order built on '
          'families of courses decides one witness\'s pair, not every such pair.',
    'zh': '进程保持可达者：同偏移之覆盖蕴含当下之包含，构于进程之族之滞后之序判定一见证之对，非每一此种对。'}})
history(d, f'the next step updated: what a course keeps reachable is read in {RID}; no declaration changed.',
        f'下一步随之更新：进程保持可达者于 {RID} 中得读；无一声明改变。')
save(RID9, d)

# eventual widening and what keeping widening needs: their next steps pointed here
for rid in ('eventual-widening', 'what-keeping-widening-needs'):
    d = load(rid)
    if rid == 'eventual-widening':
        assert d['next_delta']['en'].startswith(EW_OLD_START), d['next_delta']
        d['next_delta'] = EW_ND
    else:
        for i, lang in enumerate(('en', 'zh')):
            assert d['next_delta'][lang].count(KW_OLD[i]) == 1, (rid, lang)
            d['next_delta'][lang] = d['next_delta'][lang].replace(KW_OLD[i], KW_NEW[i])
    capped('next_delta', d['next_delta'])
    assert RID not in [x['id'] for x in d['related']]
    d['related'].append({'id': RID, 'detail': {
        'en': 'What a course keeps reachable: covering implies inclusion now, so it ranks a range that keeps '
              'widening above one wider now that starts a course only with a lag, and not every such pair.',
        'zh': '进程保持可达者：覆盖蕴含当下之包含，故仅带滞后时把持续扩大之范围排在起进程且当下更宽者之上，且非每一此种对。'}})
    history(d, f'the next step updated: what a course keeps reachable is read in {RID}; no declaration changed.',
            f'下一步随之更新：进程保持可达者于 {RID} 中得读；无一声明改变。')
    save(rid, d)
print('records pointed here:', RID9, 'eventual-widening, what-keeping-widening-needs')
