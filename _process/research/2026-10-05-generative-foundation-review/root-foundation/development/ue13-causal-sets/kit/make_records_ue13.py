#!/usr/bin/env python3
"""UE13 records: write precedence-and-its-links (law 1 of Becoming.CausalGrowth, homed at 01 §1) and
what-can-be-born-next (laws 2 to 8, homed at 07 §2), each declaration of the module cited by exactly one; relate
what-a-course-keeps-reachable and where-the-possible-grows to the second, each with a related entry and a history
note; neither's statement, next step or declarations change. Asserts the receipt's hash and empty axiom reports for
the module, and the style caps and lint (tools/research/style.py) on every field written. Mirrors UE12's
make_records_ue12.py; no landed module changes, so no record is re-pointed for Lean.
usage (from the checkout root, after texts_ue13.py): python3 -B make_records_ue13.py RECEIPT N
       python3 -B make_records_ue13.py --caps  (the caps, lint and the declaration cover against the kit's scratch
                                                audit; writes nothing)"""
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
RECEIPT_ID, N = ('20261028T000000.000000Z', 431) if CAPS_ONLY else (sys.argv[1], int(sys.argv[2]))
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RF + 'BECOMING-RENEWAL-READING.md'
KITD = RF + 'development/ue13-causal-sets/'
NOTE, REVIEW, RECHECK = KITD + 'NOTE.md', KITD + 'REVIEW-UE13.md', KITD + 'RECHECK-UE13.md'
CH1 = 'theories/becoming/chapters/01-ROOT.md'
CH7 = 'theories/becoming/chapters/07-SIGNIFICANCE.md'
LEAN = {m: f'{PKG}/Becoming/{m}.lean' for m in
        ('CausalGrowth', 'HeldPossible', 'ReachableRanges', 'Grammar', 'Frame')}
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
RIDP = 'precedence-and-its-links'
RIDG = 'what-can-be-born-next'
RID10 = 'what-a-course-keeps-reachable'
RID11 = 'where-the-possible-grows'
RIDC = 'continuation-relative-to-a-class'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
TODAY = datetime.date.today()
DATE_EN, DATE_ZH = f'{TODAY.day} {TODAY:%B} {TODAY.year}', f'{TODAY.year}年{TODAY.month}月{TODAY.day}日'
COUNT = 212


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def capped(field, pair, item=False):
    caps = style.ITEM_CAPS_V2 if item else style.CAPS_V2
    en, zh = caps[field][:2]
    assert len(pair['en']) <= en and len(pair['zh']) <= zh, (field, len(pair['en']), en, len(pair['zh']), zh, pair['en'][:60])
    return pair


if CAPS_ONLY:
    audit = (HERE.parent / 'tree/.build/BecomingCausalGrowthAxiomAudit.lean').read_text(encoding='utf-8')
    names = set(re.findall(r'^#print axioms (\S+)$', audit, re.M))
else:
    core = json.loads((ROOT / RECEIPT).read_text())
    assert core['status'] == 'passed'
    module = 'Becoming.CausalGrowth'
    assert core['source_sha256'][module] == sha(LEAN['CausalGrowth']), module
    mod = next(x for x in core['modules'] if x['module'] == module)
    assert not any(mod['axiom_dependencies'].values()), module
    names = {d['name'] for d in mod['declarations']}
assert len(names) == COUNT, len(names)


def C(*short):
    out = ['Becoming.CausalGrowth.' + s for s in short]
    missing = [n for n in out if n not in names]
    assert not missing, missing
    return out


# precedence and its links: law 1 of the note
groupsP = [
    ("Links. The links of a relation, causal set theory's term, are the pairs it relates with nothing it relates "
     "between (links, links_le); relations with the same pairs have the same links (links_of_iff). A link of the "
     "root's reach «及» R is a step of R, since a chain of two or more steps has a point between (link_of_reach), so "
     "every net whose reach is a relation contains its links, on any carrier (links_least).",
     "覆盖。一关系之覆盖（因果集理论称 link）谓其所关联而其间无其所关联者之对（links、links_le）；关联相同则覆盖相同（links_of_iff）。"
     "根之及 «及» R 之覆盖即 R 之一步，因二步以上之链有居间之点（link_of_reach）；故凡其及为一关系之网，皆含其覆盖，于任何载体（links_least）。",
     C('links', 'links_le', 'links_of_iff', 'link_of_reach', 'links_least')),
    ("Every pair is reached by links on a relation on the numbers in which each element is preceded only by smaller "
     "labels, with precedence decidable (reach_links): induction on the gap between labels with a bounded search for "
     "an element between (searchBelow, reach_links_within). No finiteness is needed: on all the numbers in their "
     "order every pair is reached by links (nat_reach_links).",
     "于数上之关系，每元仅为较小标号者所先，且先后可判定，则每一对皆由覆盖及之（reach_links）：以标号之差归纳，并有界搜索居间之元"
     "（searchBelow、reach_links_within）。无需有限：于依其序之全体自然数，每一对皆由覆盖及之（nat_reach_links）。",
     C('searchBelow', 'reach_links_within', 'reach_links', 'nat_reach_links')),
    ("With transitivity precedence is exactly the reach of its links (reach_links_le, reach_links_iff), so the links "
     "are the least net whose reach it is. Without transitivity only one inclusion holds: the links of the path "
     "0 → 1 → 2 reach (0, 2), which it does not relate (path, path_not_reach_of_links).",
     "加以可传递，先后恰为其覆盖之及（reach_links_le、reach_links_iff），故覆盖为其及即先后之最小之网。无可传递则仅一向包含成立："
     "路 0 → 1 → 2 之覆盖及于 (0, 2)，而路不关联之（path、path_not_reach_of_links）。",
     C('reach_links_le', 'reach_links_iff', 'path', 'path_not_reach_of_links')),
    ("Deciding what lies between suffices: where, for each pair and each element, whether the element lies between "
     "them is decided, every pair is reached by links, with no Decidable instance (searchBelow_or, "
     "reach_links_within_of_decided, reach_links_of_decided).",
     "判定居间者即足：凡于每一对与每一元，判定该元是否居其间，则每一对皆由覆盖及之，无需 Decidable 实例（searchBelow_or、"
     "reach_links_within_of_decided、reach_links_of_decided）。",
     C('searchBelow_or', 'reach_links_within_of_decided', 'reach_links_of_decided')),
    ("It cannot be dropped: that every pair of every causal set is reached by links is excluded middle "
     "(reach_links_all_iff_em), already on three elements whose relations through the middle are a proposition "
     "(Undecided: third, third_ordered, third_not_from_two, third_no_reach_from_two, em_of_reach_third). Telling a "
     "link, a direct condition, from a longer chain is deciding whether anything lies between.",
     "此判定不可去：每一因果集之每一对皆由覆盖及之，即排中律（reach_links_all_iff_em）；三元、其经中间者之关系为一命题时已然"
     "（Undecided：third 等）。分辨覆盖（直接之缘）与较长之链，即判定其间有无居间者。",
     C('Undecided.third', 'Undecided.third_ordered', 'Undecided.third_not_from_two',
       'Undecided.third_no_reach_from_two', 'Undecided.em_of_reach_third', 'reach_links_all_iff_em')),
    ("Causal sets. A configuration is a labelled finite causal set: precedence transitive, within its elements, each "
     "preceded only by smaller labels (Causet, Causet.Ordered). Reach along a naturally labelled relation raises the "
     "label (labelled_of_reach), so its precedence is irreflexive and acyclic "
     "(Causet.Ordered.irrefl, Causet.Ordered.acyclic), and, decidable, the reach of its links "
     "(ordered_reach_links_iff).",
     "构型为有标号之有限因果集：先后可传递，在元之内，每元仅为较小标号者所先（Causet、Causet.Ordered）。沿自然编号之关系之及使标号升高"
     "（labelled_of_reach），故先后非自反且无环（Causet.Ordered.irrefl、Causet.Ordered.acyclic），可判定时即其覆盖之及"
     "（ordered_reach_links_iff）。",
     C('Causet', 'Causet.Ordered', 'labelled_of_reach', 'Causet.Ordered.irrefl', 'Causet.Ordered.acyclic',
       'ordered_reach_links_iff')),
    ("Not on ω + 1. On the numbers with a top above them all the order is strict and every positive number lies "
     "between some 0 and the top; no link ends at the top and every reach of links ends at a number, so some 0 "
     "precedes the top and the links never reach it. The links reading can fail where an interval is infinite.",
     "于 ω + 1 则否。于其上有顶之数，序为严格，每一正数皆居 some 0 与顶之间；无覆盖终于顶，覆盖之及皆终于一数，故 some 0 先于顶而覆盖永不及之。"
     "区间无穷处，覆盖之读可失效。",
     C('OmegaPlusOne.prec', 'OmegaPlusOne.prec_irrefl', 'OmegaPlusOne.prec_trans', 'OmegaPlusOne.between',
       'OmegaPlusOne.no_link_into_top', 'OmegaPlusOne.link_lands', 'OmegaPlusOne.reach_lands',
       'OmegaPlusOne.not_reach_top')),
]

# what can be born next against what continues: laws 2 to 8 of the note, and the courses' start
groupsG = [
    ("Sequential growth. A stem is a set of elements closed downward (Stem); a move chooses one and adds the element "
     "size, preceded exactly by it (birth, process), from the empty set (empty, empty_ordered). A birth keeps a causal "
     "set a causal set (birth_ordered), keeps the precedence below every existing element (birth_holds) and makes the "
     "new element maximal (birth_maximal).",
     "序贯生长。茎为向下封闭之元集（Stem）；一步择一茎，添元 size，恰为其所先（birth、process），始于空集（empty、empty_ordered）。"
     "生使因果集仍为因果集（birth_ordered），保持每一已有元之下之先后（birth_holds），并使新元为极大（birth_maximal）。",
     C('Stem', 'birth', 'process', 'empty', 'empty_ordered', 'birth_ordered', 'birth_holds', 'birth_maximal')),
    ("Internal temporality, with the parent kept as it was, is holding the past: every move keeps the elements and "
     "the order among them (HoldsPast, step_holdsPast), so the possible with the past held, UE11's possible relative "
     "to a held part, is the whole possible (possibleHeld_iff).",
     "内在时间性（亲构型保持原样）即持守过去：每一步皆保持诸元及其间之序（HoldsPast、step_holdsPast），故持守过去时之可能（UE11 相对于所持之部分之可能）"
     "即全部可能（possibleHeld_iff）。",
     C('HoldsPast', 'step_holdsPast', 'possibleHeld_iff')),
    ("What each configuration admits next keeps widening on every course from a causal set. Every stem stays a stem "
     "across a birth (Stem.after); after each birth the stem of all elements is new (all, stem_all, "
     "not_stem_all_birth); so the stems keep widening in UE10's sense (ordered_of_run, keepsWidening), each possible "
     "from the course's start, inside a whole possible that never grows (stem_possible_from_start).",
     "自因果集起之每一历程上，每一构型次所纳者不断扩大。每茎经一生仍为茎（Stem.after）；每生之后全体元之茎为新（all、stem_all、not_stem_all_birth）；"
     "故茎依 UE10 之义不断扩大（ordered_of_run、keepsWidening），皆自历程之始可能，于永不增长之全部可能之内（stem_possible_from_start）。",
     C('Stem.after', 'all', 'stem_all', 'not_stem_all_birth', 'ordered_of_run', 'keepsWidening',
       'stem_possible_from_start')),
    ("Stems reverse the inclusion of precedence. Of two configurations of one size, every stem of the first is a stem "
     "of the second exactly where the second's precedence is included in the first's (stems_included_iff); one "
     "direction takes the principal stem, an element and what precedes it (principal, stem_principal), the other is "
     "closure under the larger precedence.",
     "茎反转先后之包含。同大小之二构型，前者之每茎皆为后者之茎，恰当后者之先后含于前者之先后（stems_included_iff）；一向取主茎（一元及先之者，"
     "principal、stem_principal），另一向为于较大先后下之封闭。",
     C('principal', 'stem_principal', 'stems_included_iff')),
    ("On courses. Along a course from the empty set the configuration at offset t has t elements and is a causal set "
     "(size_of_run, ordered_of_empty). Of two such courses, one includes the other's stems at every offset exactly "
     "where its precedence is included in the other's at every offset (rangeIncludes_iff), and strictly exactly where "
     "strictly, with no decision (rangeIncludes_strict_iff).",
     "于历程上。自空集起之历程，偏移 t 处之构型有 t 元且为因果集（size_of_run、ordered_of_empty）。二如是之历程，一者于每一偏移含另一者之茎，"
     "恰当其先后于每一偏移皆含于另一者之先后（rangeIncludes_iff）；严格者恰当严格，无需判定（rangeIncludes_strict_iff）。",
     C('size_of_run', 'ordered_of_empty', 'rangeIncludes_iff', 'rangeIncludes_strict_iff')),
    ("Of two courses from the empty set, widening what can be born next loses precedence (rangeWidens_strict), and "
     "losing a pair, the precedence included, widens it (rangeWidens_of). One exceeds the other's stems where it "
     "lacks a pair of the other (rangeExceeds_of_pair), only where an offset's inclusion fails "
     "(not_included_of_rangeExceeds); decided, the pair is found (pair_of_not_included, rangeExceeds_iff_pair).",
     "自空集起之二历程，扩大次可生者则失先后（rangeWidens_strict），先后被含而失一对则扩大之（rangeWidens_of）。一者缺另一者之对则超出其茎"
     "（rangeExceeds_of_pair），唯某偏移不含时方然（not_included_of_rangeExceeds）；可判定则得其对（pair_of_not_included 等）。",
     C('rangeExceeds_of_pair', 'not_included_of_rangeExceeds', 'rangeWidens_of', 'rangeWidens_strict',
       'pair_of_not_included', 'rangeExceeds_iff_pair')),
    ("Finding that pair for every two courses from the empty set is excluded middle (pair_converse_iff_em), already "
     "for widenings (em_of_widening_pair_converse): wherever P is not refuted the antichain exceeds the stems of the "
     "course bearing 2 above 0 exactly where P, and a pair of that course gives P (Undecided: onlyIfPast, onlyIf, with "
     "laws; stems_of_two). Which pair a widening loses is found by deciding.",
     "对自空集起之每二历程皆求得该对，即排中律（pair_converse_iff_em），仅求于扩大亦然（em_of_widening_pair_converse）：凡 P 未被否证，"
     "反链即超出恰于 P 时以 2 生于 0 上之历程之茎，而其一对给出 P（Undecided：onlyIf 等；stems_of_two）。扩大所失之对须判定而得。",
     C('Undecided.onlyIfPast', 'Undecided.onlyIf_two', 'Undecided.onlyIf', 'Undecided.onlyIf_prec',
       'Undecided.antichain_exceeds_onlyIf', 'Undecided.notNot_em', 'stems_of_two', 'em_of_pair_converse',
       'em_of_widening_pair_converse', 'pair_converse_of_em', 'pair_converse_iff_em')),
    ("Of two courses from the empty set, widening adds no continuation of any class read on precedence "
     "(continuation_of_rangeIncludes). Within the one class continuation is precedence (continuation_one_iff), and on "
     "links too where precedence is decidable (continuation_links_one_iff), so there too including the other's stems "
     "adds none (continuation_links_one_of_rangeIncludes).",
     "自空集起之二历程，扩大不增任何读于先后之类之相续（continuation_of_rangeIncludes）。一类内相续即先后（continuation_one_iff），"
     "可判定时读于覆盖亦然（continuation_links_one_iff），故彼处含对方之茎亦不增相续（continuation_links_one_of_rangeIncludes）。",
     C('continuation_of_rangeIncludes', 'continuation_one_iff', 'continuation_links_one_iff',
       'continuation_links_one_of_rangeIncludes')),
    ("Compared by both, two courses from the empty set have the same precedence: where one includes the other's stems "
     "and continues at least as much within the one class, their precedence is the same (prec_iff_of_both), so "
     "neither widens what can be born next while continuing as much (not_widens_and_continues).",
     "兼较二者，自空集起之二历程先后相同：一者含另一者之茎且一类内相续不少，则二者先后相同（prec_iff_of_both）；故无一者既扩大次可生者又相续不少"
     "（not_widens_and_continues）。",
     C('prec_iff_of_both', 'not_widens_and_continues')),
    ("Courses given by their pasts. After births with given pasts the configuration has i before j exactly where j "
     "is born by then with i in its past (grown, grown_size, grown_prec_iff); given that each past is a stem when "
     "chosen, the births are a course from the empty set (course, course_start).",
     "以过去给出之历程。依所给之过去而生之后，构型中 i 先于 j，恰当 j 已生且 i 在其过去之中（grown、grown_size、grown_prec_iff）；"
     "设每一过去于被择时皆为茎，则诸生为自空集起之历程（course、course_start）。",
     C('grown', 'grown_size', 'grown_prec_iff', 'course', 'course_start')),
    ("Links on the growth: that every pair on every configuration of every course from the empty set is reached by "
     "links is excluded middle, since at offset 3 the growth reaches the three elements whose relations through the "
     "middle are a proposition (Undecided: thirdPast, thirdPast_stems, thirdCourse, thirdCourse_prec_iff; "
     "reach_links_courses_iff_em).",
     "生长上之覆盖：自空集起之每一历程之每一构型之每一对皆由覆盖及之，即排中律，因生长于偏移 3 达至经中间者之关系为一命题之三元"
     "（Undecided：thirdCourse 等；reach_links_courses_iff_em）。",
     C('Undecided.thirdPast', 'Undecided.thirdPast_stems', 'Undecided.thirdCourse', 'Undecided.thirdCourse_prec_iff',
       'reach_links_courses_iff_em')),
    ("Births with empty pasts (antichain, antichain_prec): the course includes the stems of every course from the "
     "empty set (antichain_rangeIncludes) and widens those of every such course with a pair (antichain_rangeWidens); "
     "in it every element begins and ends in every class, on precedence and on links (antichain_begins_ends).",
     "诸生皆以空过去（antichain、antichain_prec）：此历程含自空集起每一历程之茎（antichain_rangeIncludes），并扩大每一有一对者之茎"
     "（antichain_rangeWidens）；其中每元于每类皆生而即亡，读于先后与覆盖皆然（antichain_begins_ends）。",
     C('antichain', 'antichain_prec', 'antichain_rangeIncludes', 'antichain_rangeWidens', 'antichain_begins_ends')),
    ("Births above every element (chain, chain_prec_iff): each course from the empty set includes its stems "
     "(rangeIncludes_chain), each lacking a pair of it widens them (rangeWidens_chain), it continues most in each "
     "class read on precedence (continuation_le_chain). Each element is linked to the next (chain_link), each "
     "after the first abides on links once the next is born (chain_abides), the last ends (chain_last_ends).",
     "诸生皆在每元之上（chain 等）：自空集起之历程皆含其茎（rangeIncludes_chain），缺其一对者扩大之（rangeWidens_chain），"
     "读于先后，其于每类相续最多（continuation_le_chain）。每元与次元成覆盖（chain_link），首元后之每元于次元生后读于覆盖皆住"
     "（chain_abides），末元亡（chain_last_ends）。",
     C('chain', 'chain_prec_iff', 'rangeIncludes_chain', 'rangeWidens_chain', 'continuation_le_chain', 'chain_link',
       'chain_abides', 'chain_last_ends')),
    ("Two readings, reversed. Of two courses from the empty set, what continues in the one class (continuing) is "
     "included exactly where what can be born next is included the other way (rangeIncludes_continuing_iff); "
     "widening it is inclusion of precedence with a pair the other lacks (rangeWidens_continuing_iff), and narrows "
     "what can be born next (rangeWidens_stems_of_continuing).",
     "二读相反。自空集起之二历程，一类内之相续（continuing）之包含即次可生者之反向包含（rangeIncludes_continuing_iff）；扩大之即先后被含而有对方所无之对"
     "（rangeWidens_continuing_iff），并收窄次可生者（rangeWidens_stems_of_continuing）。",
     C('continuing', 'rangeIncludes_continuing_iff', 'rangeWidens_continuing_iff', 'rangeWidens_stems_of_continuing')),
    ("Read on what continues, the chain widens every course from the empty set lacking one of its pairs "
     "(chain_rangeWidens_continuing). That narrowing what can be born next always widens what continues is again "
     "excluded middle (em_of_stems_converse, stems_converse_of_em, stems_converse_iff_em).",
     "读于相续，链扩大自空集起而缺其一对之每一历程（chain_rangeWidens_continuing）。收窄次可生者恒扩大相续，此亦即排中律"
     "（em_of_stems_converse、stems_converse_of_em、stems_converse_iff_em）。",
     C('chain_rangeWidens_continuing', 'em_of_stems_converse', 'stems_converse_of_em', 'stems_converse_iff_em')),
    ("No strict order contains both widenings: one ranks the antichain above the chain, the other the chain above the "
     "antichain (no_order_contains_both). An order never reversing widening what can be born next ranks no course "
     "from the empty set with a pair above the antichain (not_above_antichain), and the chain above no such course "
     "lacking one of its pairs (chain_not_above).",
     "无一严格之序兼含二种扩大：一者以反链高于链，另一者以链高于反链（no_order_contains_both）。不反转次可生者之扩大之序，不以自空集起而有一对之历程"
     "高于反链（not_above_antichain），亦不以链高于缺其一对之如是历程（chain_not_above）。",
     C('no_order_contains_both', 'not_above_antichain', 'chain_not_above')),
    ("Read on both together (formsOrContinues), of two courses from the empty set neither widens the other "
     "(not_rangeWidens_formsOrContinues), and two such courses one of which lacks a pair of the other are mixed: each "
     "exceeds the other (mixed_of_pair).",
     "兼读二者（formsOrContinues），自空集起之二历程无一扩大另一者（not_rangeWidens_formsOrContinues）；一者缺另一者之一对时，二者相杂："
     "各超出对方（mixed_of_pair）。",
     C('formsOrContinues', 'not_rangeWidens_formsOrContinues', 'mixed_of_pair')),
    ("The courses' start. Most comparisons of two courses fail without the empty start. From a configuration, births "
     "with given pasts (Starts: grownFrom, with laws, fromEmptyPasts); from one element, every past empty (one, "
     "fromOne, with laws), a course widens the antichain's stems with the same, empty, precedence (fromOne_widens), so "
     "the strict and exceeding comparisons fail without the start (strict_needs_starts).",
     "历程之始。二历程之比较多需自空集起。自一构型依所给之过去而生（Starts：grownFrom 等、fromEmptyPasts）；自一元起、诸过去皆空（one、fromOne 等），"
     "一历程以相同之空先后扩大反链之茎（fromOne_widens），故无此始则严格与超出之比较不成立（strict_needs_starts）。",
     C('Starts.grownFrom', 'Starts.grownFrom_size', 'Starts.grownFrom_prec_iff', 'Starts.grownFrom_empty_prec',
       'Starts.fromEmptyPasts', 'Starts.one', 'Starts.fromOne', 'Starts.fromOne_prec', 'Starts.fromOne_size',
       'Starts.fromOne_stem_of_antichain', 'Starts.fromOne_stem_zero', 'Starts.not_stem_antichain_zero',
       'Starts.fromOne_widens', 'Starts.strict_needs_starts')),
    ("Against the antichain, in which nothing continues (Starts.antichain_not_continuing), that course also refutes, "
     "without the start, not_widens_and_continues, rangeIncludes_continuing_iff and not_rangeWidens_formsOrContinues "
     "(Starts: the three laws named for them with _needs_starts, and fromOne_widens_formsOrContinues).",
     "对反链（其中无相续，antichain_not_continuing），无此始该历程亦否证 not_widens_and_continues 等三律"
     "（Starts：各以其名加 _needs_starts，及 fromOne_widens_formsOrContinues）。",
     C('Starts.antichain_not_continuing', 'Starts.not_widens_and_continues_needs_starts',
       'Starts.rangeIncludes_continuing_iff_needs_starts', 'Starts.fromOne_widens_formsOrContinues',
       'Starts.not_rangeWidens_formsOrContinues_needs_starts')),
    ("The course bearing 1 above 0 (Starts: onePast, oneAbove, with laws) lacks at offset 0 the pair (0, 1) of the "
     "course from the two-chain, every past empty (twoChain, fromTwo, fromTwo_prec_iff), yet exceeds it on neither "
     "reading (rangeWidens_of_needs_starts, mixed_of_pair_needs_starts); an order never reversing widening can rank "
     "the latter above the antichain (not_above_antichain_needs_start, with two stem laws).",
     "以 1 生于 0 上之历程（Starts：oneAbove 等）于偏移 0 缺自二元链起、诸过去皆空之历程（fromTwo 等）之对 (0, 1)，而于二读皆不超出之"
     "（rangeWidens_of_needs_starts、mixed_of_pair_needs_starts）；不反转扩大之序可以后者高于反链（not_above_antichain_needs_start）。",
     C('Starts.onePast', 'Starts.onePast_stems', 'Starts.oneAbove', 'Starts.oneAbove_prec', 'Starts.twoChain',
       'Starts.fromTwo', 'Starts.fromTwo_prec_iff', 'Starts.rangeWidens_of_needs_starts',
       'Starts.mixed_of_pair_needs_starts', 'Starts.fromTwo_stem_all', 'Starts.not_stem_antichain_all',
       'Starts.not_above_antichain_needs_start')),
    ("The chain from one element (Starts: chainFromOnePast, chainFromOne, with laws) includes the chain's stems, "
     "continues at least as much in the one class and has a pair the chain lacks (prec_iff_of_both_needs_starts, "
     "continuation_of_rangeIncludes_needs_starts, rangeWidens_stems_of_continuing_needs_starts). Keeping widening "
     "needs a causal set at the start (full, full_stem_empty, keepsWidening_needs_start).",
     "自一元起之链（Starts：chainFromOne 等）含链之茎、一类内相续不少，且有链所无之对（prec_iff_of_both_needs_starts 等三律）。"
     "不断扩大需始于因果集（full、full_stem_empty、keepsWidening_needs_start）。",
     C('Starts.chainFromOnePast', 'Starts.chainFromOne_prec_iff', 'Starts.chainFromOne_labelled',
       'Starts.chainFromOne', 'Starts.not_continuing_chain_one', 'Starts.prec_iff_of_both_needs_starts',
       'Starts.continuation_of_rangeIncludes_needs_starts', 'Starts.rangeWidens_stems_of_continuing_needs_starts',
       'Starts.full', 'Starts.full_stem_empty', 'Starts.keepsWidening_needs_start')),
    ("No configuration renews without end. Where a relation raises the label and relates only below a bound, every "
     "element ceases under every class (ceases_of_bounded); so on every causal set of the growth every element "
     "ceases, on precedence and on links (ordered_ceases), and the grammar's «生生» holds on no configuration "
     "(ordered_not_renews).",
     "无构型生生不息。凡一关系使标号升高且仅关联于一界之下，每元于每类皆息（ceases_of_bounded）；故于生长之每一因果集，每元皆息，读于先后与覆盖皆然"
     "（ordered_ceases），文法之 «生生» 于任何构型皆不成立（ordered_not_renews）。",
     C('ceases_of_bounded', 'ordered_ceases', 'ordered_not_renews')),
    ("In the limits the extremes part. On the antichain's limit nothing renews without end in any class "
     "(antichainLimit, antichainLimit_not_renews). On the chain's limit, i before j exactly where i < j (chainLimit, "
     "chainLimit_iff), 1 renews without end under the class pairing 2m with 2m + 1 (chainLimit_renews; Halves: half, "
     "pairs, pairs_class, double_succ, half_double, half_double_succ, half_lt, odd).",
     "于极限，二极相分。反链之极限中，任何类下皆无生生不息者（antichainLimit、antichainLimit_not_renews）。链之极限中，i 先于 j 恰当 i < j"
     "（chainLimit、chainLimit_iff），于将 2m 与 2m + 1 相配之类下，1 生生不息（chainLimit_renews；Halves）。",
     C('antichainLimit', 'antichainLimit_not_renews', 'chainLimit', 'chainLimit_iff', 'chainLimit_renews',
       'Halves.half', 'Halves.pairs', 'Halves.pairs_class', 'Halves.double_succ', 'Halves.half_double',
       'Halves.half_double_succ', 'Halves.half_lt', 'Halves.odd')),
    ("On links a finer class can gain or lose continuation by widening. The wider course bears 2 above 0, the "
     "narrower 1 above 0 and 2 above both, and the class sets 1 apart (Finer: widePast, narrowPast, classOf, wide, "
     "narrow, with laws). The wider widens the narrower (widens); the class continues from 0 to 2 on links in it "
     "(continues), not in the narrower (not_continues), nor in the antichain, which widens it (loses).",
     "读于覆盖，较细之类可因扩大而得或失相续。较宽之历程以 2 生于 0 上，较窄者以 1 生于 0 上、2 生于二者之上；类将 1 单列（Finer）。较宽者扩大较窄者"
     "（widens），类于其中沿覆盖自 0 续至 2（continues），于较窄者中则否（not_continues），于扩大较宽者之反链中亦否（loses）。",
     C('Finer.widePast', 'Finer.narrowPast', 'Finer.classOf', 'Finer.classOf_class', 'Finer.wide_stems',
       'Finer.narrow_stems', 'Finer.wide', 'Finer.narrow', 'Finer.widens', 'Finer.continues', 'Finer.not_continues',
       'Finer.loses')),
    ("Up to relabelling the pasts reverse the inclusion of precedence (Kinds: Relabels, Isomorphic, Included): where "
     "the first configuration's elements are carried one to one into the second's, a stem of the second, carried "
     "over, is one of the first exactly where the first's precedence, carried back, is included in the second's "
     "(stems_carried_iff); one size is not needed (stems_carried_unequal).",
     "重新编号下，过去仍反转先后之包含（Kinds：Relabels、Isomorphic、Included）：前一构型之元一一携入后者，则后者之每茎携过来为前者之茎，"
     "恰当前者之先后携回含于后者之先后（stems_carried_iff）；二者无须同大小（stems_carried_unequal）。",
     C('Kinds.Relabels', 'Kinds.Isomorphic', 'Kinds.Included', 'Kinds.stems_carried_iff',
       'Kinds.stems_carried_unequal')),
    ("The kinds of birth do not. At offset 2 the antichain's births above 0 and above 1 are of one kind, by "
     "exchanging 0 and 1 (Kinds: swap, swap_fixed, swap_swap, swap_below, antichain_two_stems_one_kind), and neither "
     "extreme's kinds of birth are among the other's (not_included_antichain_chain, not_included_chain_antichain), "
     "while at offset 0 each is among the other's (included_at_zero).",
     "生之种类则否。于偏移 2，反链生于 0 上与 1 上者为一种（Kinds：swap 等、antichain_two_stems_one_kind）；二极之种类皆不全在对方之中"
     "（not_included_antichain_chain、not_included_chain_antichain），而于偏移 0 则互在其中（included_at_zero）。",
     C('Kinds.swap', 'Kinds.swap_fixed', 'Kinds.swap_swap', 'Kinds.swap_below', 'Kinds.antichain_two_stems_one_kind',
       'Kinds.not_included_antichain_chain', 'Kinds.not_included_chain_antichain', 'Kinds.included_at_zero')),
    ("The order on courses stays labelled. The course bearing 2 above 1 is Finer.wide with 0 and 1 exchanged (Kinds: "
     "swappedPast, swapped_two, swapped, swap_eq_two_iff, swap_eq_one_iff, wide_prec_iff_swapped); from offset 2 on "
     "the two grow configurations of one kind (wide_swapped_isomorphic), and each exceeds the other's stems "
     "(wide_swapped_mixed).",
     "历程之序仍依标号。以 2 生于 1 上之历程即 Finer.wide 交换 0 与 1 者（Kinds：swapped 等、wide_prec_iff_swapped）；自偏移 2 起二者所生之构型为一种"
     "（wide_swapped_isomorphic），而各超出对方之茎（wide_swapped_mixed）。",
     C('Kinds.swappedPast', 'Kinds.swapped_two', 'Kinds.swapped', 'Kinds.swap_eq_two_iff', 'Kinds.swap_eq_one_iff',
       'Kinds.wide_prec_iff_swapped', 'Kinds.wide_swapped_isomorphic', 'Kinds.wide_swapped_mixed')),
]

citedP = [n for _, _, ds in groupsP for n in ds]
citedG = [n for _, _, ds in groupsG for n in ds]
cited = citedP + citedG
assert len(cited) == len(set(cited)), [n for n in cited if cited.count(n) > 1]
assert set(cited) == names, (sorted(names - set(cited)), sorted(set(cited) - names))
lawsP = [capped('laws', {'en': en, 'zh': zh, 'declarations': ds}, item=True) for en, zh, ds in groupsP]
lawsG = [capped('laws', {'en': en, 'zh': zh, 'declarations': ds}, item=True) for en, zh, ds in groupsG]
assert max(len(lawsP), len(lawsG)) <= style.ITEM_CAPS_V2['laws'][2]

MODELLING = (
    "Modelling choices: discrete steps; configurations finite and labelled, each element preceded only by smaller "
    "labels; precedence and pasts Prop-valued; courses compared at the same offsets and from the empty set, so the "
    "order on courses is labelled, pointwise, with no function extensionality; infinite causal sets read as courses "
    "and their limits; stems compared by inclusion, not counted.",
    "建模之选：离散之步；构型有限且有标号，每元仅为较小标号者所先；先后与过去皆为命题值；历程自空集起、于同偏移处逐点相较，故历程之序依标号，不用函数外延性；"
    "无穷因果集读作历程及其极限；茎以包含相较，不计数。")


def validation(count, other):
    return capped('validation_scope', {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): {count} of '
              f'Becoming.CausalGrowth\'s {len(names)} declarations, each with an empty axiom report, cited here, the '
              f'others by {other}. Built in one session; an independent read-only review by another AI agent '
              f'(REVIEW-UE13) and a re-check (RECHECK-UE13), study section {N}; not reviewed by a person. Many laws '
              f'restate known order theory.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：Becoming.CausalGrowth 之 {len(names)} 项声明中 {count} 项，公理报告皆空，'
              f'本记录引之，余者为 {other} 所引。于一会话中构建；另一 AI 代理作独立只读审查（REVIEW-UE13）并复查（RECHECK-UE13），见研究第 {N} 节；'
              f'未经人审。诸多律重述已知之序论。'})


# precedence and its links
titleP = capped('title', {'en': 'Precedence and its links', 'zh': '先后与其覆盖'})
statementP = capped('statement', {
    'en': "A link of the root's reach is a step, so every net whose reach is a relation contains its links. On a "
          "naturally labelled transitive relation with decidable precedence, as on causal sets, precedence is the reach "
          "of its links; the decision cannot be dropped, and on ω + 1 the links never reach the top.",
    'zh': '根之及之覆盖即一步，故凡其及为一关系之网皆含其覆盖。于自然编号、可传递且先后可判定之关系（因果集在其中），先后即其覆盖之及；'
          '此判定不可去，于 ω + 1 覆盖永不及顶。'})
hypothesesP = [capped('hypotheses', x, item=True) for x in (
    {'en': "No axiom. links, link_of_reach and links_least hold on every carrier and relation; reach_links on a relation "
           "on the numbers in which each element is preceded only by smaller labels, with precedence decidable, or "
           "with what lies between decided (reach_links_of_decided); reach_links_iff adds transitivity, and "
           "ordered_reach_links_iff takes a causal set with decidable precedence.",
     'zh': '不加公理。links、link_of_reach 与 links_least 于每一载体与关系成立；reach_links 于数上每元仅为较小标号者所先、先后可判定之关系，'
           '或判定居间者（reach_links_of_decided）；reach_links_iff 另加可传递，ordered_reach_links_iff 取先后可判定之因果集。'},
    {'en': "Modelling choices: orders on the numbers with a natural labelling, and ω + 1 on Option Nat; precedence "
           "Prop-valued; every result pointwise, with no function extensionality.",
     'zh': '建模之选：数上自然编号之序，ω + 1 取于 Option Nat；先后为命题值；诸结果皆逐点，不用函数外延性。'})]
does_not_showP = [capped('does_not_show', x, item=True) for x in (
    {'en': "That reach of links fails on every order that is not locally finite: an order with an infinite interval "
           "can be the reach of its links.",
     'zh': '覆盖之及于每一非局部有限之序皆失效：有无穷区间之序可为其覆盖之及。', 'kind': 'non-implication'},
    {'en': "That it holds on every locally finite order: classically it does, but the Lean proves the naturally "
           "labelled case, and orders such as the integers are not covered.",
     'zh': '其于每一局部有限之序皆成立：经典上然，然 Lean 只证自然编号之情形，整数之类之序不在其内。', 'kind': 'scope'},
    {'en': "That precedence on ω + 1 is the reach of no condition relation: a transitive relation is its own reach; "
           "only the links fail.",
     'zh': 'ω + 1 上之先后非任何缘关系之及：可传递之关系即其自身之及；失效者仅为覆盖。', 'kind': 'non-implication'})]
next_deltaP = capped('next_delta', {
    'en': "The locally finite case without a natural labelling, with intervals decided, and which nets of the models "
          "are the links of their precedence; review by a person.",
    'zh': '无自然编号而区间可判定之局部有限情形，以及诸模型中何网为其先后之覆盖；人之审查。'})
correspondenceP = capped('correspondence', {
    'en': "Causal set theory (Bombelli, Lee, Meyer and Sorkin 1987; Surya 2019): its links are the covering pairs, and "
          "that a locally finite order is the transitive closure of its covering relation is known, failing where an "
          "interval is infinite, as on ω + 1. The calibration, excluded middle for reaching every pair, is a lemma "
          "of the law: telling a direct condition from a longer chain is deciding whether anything lies between. It "
          "answers in part the logic review's question whether precedence as the reach of a condition relation is a "
          "sound order of time (L-02). Graded in UE13's NOTE.",
    'zh': '因果集理论（Bombelli、Lee、Meyer、Sorkin 1987；Surya 2019）：其 link 即覆盖之对；局部有限之序为其覆盖关系之传递闭包为已知，'
          '区间无穷处则否，如 ω + 1。校准（每一对皆由覆盖及之即排中律）为此律之引理：分辨直接之缘与较长之链，即判定其间有无居间者。'
          '此部分回答逻辑审查之问：以缘关系之及为先后，是否为时间之可靠之序（L-02）。分级见 UE13 之 NOTE。'})
counterexamplesP = [
    {'en': 'On ω + 1 some 0 precedes the top and no reach of links reaches it (OmegaPlusOne.not_reach_top).',
     'zh': '于 ω + 1，some 0 先于顶，而无覆盖之及至之（OmegaPlusOne.not_reach_top）。'},
    {'en': 'The links of the path 0 → 1 → 2 reach (0, 2), which the path does not relate (path_not_reach_of_links).',
     'zh': '路 0 → 1 → 2 之覆盖及于 (0, 2)，而路不关联之（path_not_reach_of_links）。'},
    {'en': 'Three elements whose relations through the middle are a proposition P: the links reach 2 from 0 only '
           'where P is decided (Undecided.em_of_reach_third), so reaching every pair by links is excluded middle '
           '(reach_links_all_iff_em).',
     'zh': '三元，其经中间者之关系为命题 P：唯 P 可判定时覆盖自 0 及于 2（Undecided.em_of_reach_third），故每一对皆由覆盖及之即排中律'
           '（reach_links_all_iff_em）。'}]

# what can be born next against what continues
titleG = capped('title', {'en': 'What can be born next against what continues', 'zh': '次可生者与相续'})
statementG = capped('statement', {
    'en': "Of two courses of causal-set growth from the empty set, one includes the other's stems, what can be born "
          "next, exactly where its precedence is included in the other's, so widening adds no continuation. Read on "
          "what continues the order reverses; no strict order holds both.",
    'zh': '于因果集之生长上，次可生者反转先后之包含：自空集起之二历程，一者含另一者之茎，恰当其先后含于另一者之先后；故扩大不增相续。读于相续则序反转，'
          '无一严格之序兼含二者。'})
hypothesesG = [capped('hypotheses', x, item=True) for x in (
    {'en': "No axiom. Each law holds on every course of the growth, on every causal set, or on a witness; the "
           "comparisons take both courses from the empty set, and most fail without it (Starts); "
           "continuation_links_one_iff, continuation_links_one_of_rangeIncludes, pair_of_not_included and "
           "rangeExceeds_iff_pair take precedence decidable.",
     'zh': '不加公理。每一律于生长之每一历程、每一因果集或一见证上成立；历程之比较需二者皆自空集起，否则多不成立（Starts）；'
           'continuation_links_one_iff 等四律需先后可判定。'},
    {'en': MODELLING[0], 'zh': MODELLING[1]})]
does_not_showG = [capped('does_not_show', x, item=True) for x in (
    {'en': "That widening and continuation are opposed on every process: the reversal is shown on causal-set growth, "
           "labelled configurations compared at the same offsets from the empty set.",
     'zh': '扩大与相续于每一过程上皆相反：此反转仅示于因果集之生长上，有标号之构型自空集起于同偏移处相较。', 'kind': 'non-implication'},
    {'en': "Anything about transition probabilities, Bell causality, discrete general covariance as a condition on a "
           "dynamics, or the continuum limit.",
     'zh': '关于转移概率、贝尔因果性、作为动力学条件之离散广义协变或连续极限之任何事。', 'kind': 'scope'},
    {'en': "That continuation of a finer class read on links is ordered by widening: on witnesses it is gained and "
           "lost.",
     'zh': '读于覆盖之较细之类之相续为扩大所序：于见证上其或得或失。', 'kind': 'non-implication'},
    {'en': "How kinds of birth are ordered beyond the witnesses at offset 2; a count to five elements is a "
           "computation, not a law.",
     'zh': '生之种类于偏移 2 之见证之外如何排序；至五元之计数为计算，非律。', 'kind': 'scope'},
    {'en': "Which course is better: with every continuation's losses counted the reading is on both together, where "
           "C ranks no two courses; ordering them needs a measure, beyond C and the condition. AI readings.",
     'zh': '何历程更好：计每一相续之所失，则兼读二者，C 于此不排任何二历程；排之需度量，在 C 与条件之外。皆 AI 之读。', 'kind': 'non-implication'},
    {'en': "The second-order direction: every course keeps widening what can be born next, so a range whose widening "
           "keeps widening is not told apart from one merely wider now.",
     'zh': '二阶方向：每一历程皆使次可生者不断扩大，故其扩大不断扩大之范围与仅此刻较宽者于此不可分。', 'kind': 'non-implication'})]
next_deltaG = capped('next_delta', {
    'en': "Covariance on the growth: births of unrelated elements commuting up to relabelling, presence at a birth "
          "not invariant, an order on courses up to relabelling, and the kinds of birth counted with the stems "
          "decided; review by a person.",
    'zh': '生长上之协变：无关之元之生于重编号下可交换，于某生时之在场非不变量，重编号下历程之序，以及茎可判定时生之种类之计数；人之审查。'})
correspondenceG = capped('correspondence', {
    'en': "Rideout and Sorkin's classical sequential growth (2000) read as a process: internal temporality as holding "
          "the past, their timid and gregarious children as the chain's and the antichain's births. That stems reverse "
          "the inclusion of precedence is the order-reversing correspondence between orders on one set and their "
          "down-sets, the specialization order of an Alexandrov topology; Birkhoff's representation of finite "
          "distributive lattices is a neighbour. Kauffman's adjacent possible (2000), as two reviews report his "
          "tentative fourth law, read for a prestated space as what can be born next, on the pasts and on kinds of "
          "birth. Discrete general covariance read only as relabelling. The calibrations, excluded middle for "
          "finding the pair a widening loses and for narrowing always widening what continues, are lemmas: which pair "
          "a widening loses is found by deciding. Graded in UE13's NOTE.",
    'zh': 'Rideout 与 Sorkin 之经典序贯生长（2000）读作过程：内在时间性即持守过去，其怯子与群子为链与反链之生。茎反转先后之包含，即一集上之序与其下集间之'
          '保逆对应，亦即 Alexandrov 拓扑之特化序；有限分配格之 Birkhoff 表示为其近邻。Kauffman 之相邻可能（2000，据二书评所述其试探之第四律）'
          '读于可预先列出之空间上，为次可生者，读于过去及生之种类。离散广义协变仅读作重编号。校准（求扩大所失之对、收窄恒扩大相续，皆即排中律）为引理：'
          '扩大所失之对须判定而得。分级见 UE13 之 NOTE。'})
counterexamplesG = [
    {'en': 'The course of births with empty pasts includes every course\'s stems, and in it every element begins and '
           'ends in every class (antichain_rangeIncludes, antichain_begins_ends).',
     'zh': '诸生皆以空过去之历程含每一历程之茎，其中每元于每类皆生而即亡（antichain_rangeIncludes、antichain_begins_ends）。'},
    {'en': 'The antichain and the chain rank each other on the two readings, so no strict order contains both '
           '(no_order_contains_both).',
     'zh': '反链与链于二读上互为高下，故无一严格之序兼含二者（no_order_contains_both）。'},
    {'en': 'Read on links, a class continues from 0 to 2 in one course and not in a course it widens, nor in the '
           'antichain, which widens it (Finer.continues, Finer.not_continues, Finer.loses).',
     'zh': '读于覆盖，类于一历程中自 0 续至 2，于其所扩大之历程中则否，于扩大之之反链中亦否（Finer.continues、Finer.not_continues、Finer.loses）。'},
    {'en': 'Two stems of the antichain whose births are of one kind, and at offset 2 neither extreme\'s kinds of '
           'birth among the other\'s (Kinds.antichain_two_stems_one_kind, Kinds.not_included_antichain_chain, '
           'Kinds.not_included_chain_antichain).',
     'zh': '反链之二茎，其生为一种；于偏移 2，二极之生之种类皆不全在对方之中（Kinds.antichain_two_stems_one_kind、'
           'Kinds.not_included_antichain_chain、Kinds.not_included_chain_antichain）。'},
    {'en': 'From one element, every past empty, a course widens the antichain\'s stems with the same, empty, precedence, '
           'so the strict comparison needs the empty start (Starts.fromOne_widens, Starts.strict_needs_starts).',
     'zh': '自一元起、诸过去皆空之历程，以相同之空先后扩大反链之茎，故严格之比较需自空集起（Starts.fromOne_widens、Starts.strict_needs_starts）。'},
    {'en': 'The course bearing 2 above 0 exactly where P: where P is not refuted the antichain exceeds its stems, and '
           'finding the pair decides P, so finding it for every two courses is excluded middle '
           '(Undecided.antichain_exceeds_onlyIf, pair_converse_iff_em).',
     'zh': '恰于 P 时以 2 生于 0 上之历程：凡 P 未被否证，反链超出其茎，而求得其对即判定 P，故对每二历程皆求得之即排中律'
           '（Undecided.antichain_exceeds_onlyIf、pair_converse_iff_em）。'},
    {'en': 'Two courses growing configurations of one kind at every offset from 2 on each exceed the other\'s stems '
           '(Kinds.wide_swapped_isomorphic, Kinds.wide_swapped_mixed).',
     'zh': '自偏移 2 起所生之构型为一种之二历程，各超出对方之茎（Kinds.wide_swapped_isomorphic、Kinds.wide_swapped_mixed）。'}]


def lint_errors(rec):
    found = style.lint(rec)
    for f in found:
        print('lint:', rec['id'], f['severity'], f['field'], f['rule'], f['detail'])
    return [f for f in found if f['severity'] == 'error']


# each record's lint (tools/research/style.py), hard rules and warnings, on every text field before anything is written
for rid, title, statement, laws, hypotheses, does_not_show, counterexamples, next_delta, correspondence, count, other in (
        (RIDP, titleP, statementP, lawsP, hypothesesP, does_not_showP, counterexamplesP, next_deltaP, correspondenceP,
         len(citedP), RIDG),
        (RIDG, titleG, statementG, lawsG, hypothesesG, does_not_showG, counterexamplesG, next_deltaG, correspondenceG,
         len(citedG), RIDP)):
    assert not lint_errors({'schema_version': 2, 'id': rid, 'title': title, 'statement': statement, 'laws': laws,
                            'hypotheses': hypotheses, 'does_not_show': does_not_show,
                            'counterexamples': [{'detail': x} for x in counterexamples],
                            'validation_scope': validation(count, other), 'next_delta': next_delta,
                            'correspondence': correspondence})

if CAPS_ONLY:
    for label, laws, statement, correspondence, nd, count, other in (
            ('precedence', lawsP, statementP, correspondenceP, next_deltaP, len(citedP), RIDG),
            ('growth', lawsG, statementG, correspondenceG, next_deltaG, len(citedG), RIDP)):
        v = validation(count, other)
        print(f'caps: {label} ok; {count} declarations in {len(laws)} laws; statement', len(statement['en']),
              len(statement['zh']), '; validation', len(v['en']), len(v['zh']), '; next', len(nd['en']), len(nd['zh']),
              '; correspondence', len(correspondence['en']), len(correspondence['zh']), '; laws max',
              max(len(x['en']) for x in laws), max(len(x['zh']) for x in laws))
    raise SystemExit(0)

grammar_ref = [{'path': LEAN['Grammar'], 'role': 'proof', 'sha256': sha(LEAN['Grammar'])}]
common_refs = [{'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
               {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
               {'path': NOTE, 'role': 'integration', 'sha256': sha(NOTE)},
               {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
               {'path': RECHECK, 'role': 'integration', 'sha256': sha(RECHECK)}]
binding = [{'source': LEAN['CausalGrowth'], 'receipt': RECEIPT,
            'sha256_pointer': '/source_sha256/Becoming.CausalGrowth',
            'success_pointer': '/status', 'success_value': 'passed'}]

recordP = {
    'schema_version': 2,
    'id': RIDP,
    'title': titleP,
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F01',
    'reviewed_at_utc': NOW,
    'statement': statementP,
    'laws': lawsP,
    'hypotheses': hypothesesP,
    'does_not_show': does_not_showP,
    'counterexamples': [{'path': LEAN['CausalGrowth'], 'detail': x} for x in counterexamplesP],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'formal-not-empirical', 'names-provisional',
                            'omission-not-refutation'],
    'validation_scope': validation(len(citedP), RIDG),
    'next_delta': next_deltaP,
    'correspondence': correspondenceP,
    'canonical_source': LEAN['CausalGrowth'],
    'aliases': ['Precedence and its links', '先后与其覆盖', 'links of a causal set', 'covering relation as conditions',
                'Becoming.CausalGrowth.reach_links', 'Becoming.CausalGrowth.links_least',
                'Becoming.CausalGrowth.reach_links_all_iff_em'],
    'dependencies': [
        {'id': RIDC, 'relation': 'formal-reuse',
         'detail': {'en': '«际», «及», «则», «及之传递» and «无环»: relations, reach and cycles.',
                    'zh': '«际»、«及»、«则»、«及之传递» 与 «无环»：关系、及与环。'}}],
    'related': [
        {'id': RIDG,
         'detail': {'en': 'The configurations of causal-set growth are the causal sets here, on which precedence is '
                          'the reach of its links where it is decidable.',
                    'zh': '因果集生长之构型即此处之因果集；先后可判定时，其先后即其覆盖之及。'}}],
    'references': [{'path': LEAN['CausalGrowth'], 'role': 'proof', 'declarations': sorted(citedP),
                    'sha256': sha(LEAN['CausalGrowth'])}] + grammar_ref + common_refs
                  + [{'path': CH1, 'role': 'statement', 'sha256': sha(CH1)}],
    'proof_bindings': binding,
    'history': [{
        'en': f'{DATE_EN}: added (UE13), precedence and its links: a link of the root\'s reach is a step, so every net '
              f'whose reach is a relation contains its links; on a naturally labelled transitive relation with '
              f'decidable precedence, precedence is the reach of its links, with no finiteness; deciding what lies '
              f'between cannot be dropped (excluded middle); not on ω + 1; after a review and a re-check; study '
              f'section {N}.',
        'zh': f'{DATE_ZH}：新增（UE13），先后与其覆盖：根之及之覆盖即一步，故凡其及为一关系之网皆含其覆盖；于自然编号、可传递且先后可判定之关系，先后即其覆盖之及，'
              f'无需有限；居间之判定不可去（排中律）；于 ω + 1 则否；经审查与复查；研究第 {N} 节。'}],
}

recordG = {
    'schema_version': 2,
    'id': RIDG,
    'title': titleG,
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F07',
    'reviewed_at_utc': NOW,
    'statement': statementG,
    'laws': lawsG,
    'hypotheses': hypothesesG,
    'does_not_show': does_not_showG,
    'counterexamples': [{'path': LEAN['CausalGrowth'], 'detail': x} for x in counterexamplesG],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical',
                            'names-provisional', 'omission-not-refutation'],
    'validation_scope': validation(len(citedG), RIDP),
    'next_delta': next_deltaG,
    'correspondence': correspondenceG,
    'canonical_source': LEAN['CausalGrowth'],
    'aliases': ['What can be born next against what continues', '次可生者与相续', 'sequential growth as a process',
                'what can be born next', 'Becoming.CausalGrowth.stems_included_iff',
                'Becoming.CausalGrowth.no_order_contains_both', 'Becoming.CausalGrowth.not_widens_and_continues'],
    'dependencies': [
        {'id': RIDP, 'relation': 'formal-reuse',
         'detail': {'en': 'Causet and Causet.Ordered, the links and links_of_iff, the reach of links where precedence is '
                          'decidable (in continuation_links_one_iff), and Undecided.third with its calibration (in '
                          'reach_links_courses_iff_em).',
                    'zh': 'Causet 与 Causet.Ordered、覆盖与 links_of_iff、先后可判定时覆盖之及（于 continuation_links_one_iff），'
                          '以及 Undecided.third 及其校准（于 reach_links_courses_iff_em）。'}},
        {'id': RID10, 'relation': 'formal-reuse',
         'detail': {'en': 'Run.RangeIncludes, Run.RangeExceeds, Run.RangeWidens, Reaching.KeepsWidening and '
                          'Run.possible_from_start: what a course admits compared at the same offsets, keeping '
                          'widening, and the possible from a course\'s start.',
                    'zh': 'Run.RangeIncludes、Run.RangeExceeds、Run.RangeWidens、Reaching.KeepsWidening 与 Run.possible_from_start：'
                          '历程于同偏移处所纳之比较、不断扩大与自历程之始之可能。'}},
        {'id': RID11, 'relation': 'formal-reuse',
         'detail': {'en': 'Reaching.heldMoves, Reaching.PossibleHeld and Reaching.PossibleHeld.possible: the possible '
                          'with the past held.',
                    'zh': 'Reaching.heldMoves、Reaching.PossibleHeld 与 Reaching.PossibleHeld.possible：持守过去时之可能。'}},
        {'id': RIDC, 'relation': 'formal-reuse',
         'detail': {'en': '«及», «续», «相续», «一», «类», «则», «生», «亡», «住», «息», «生生», «生生之展», «生生不息» and '
                          '«及之单调»: continuation, its positions, ceasing and renewal without end.',
                    'zh': '«及»、«续»、«相续»、«一»、«类»、«则»、«生»、«亡»、«住»、«息»、«生生»、«生生之展»、«生生不息» 与 «及之单调»：'
                          '续及其诸位、息与生生不息。'}}],
    'related': [
        {'id': RID10,
         'detail': {'en': 'Its same-offset comparison read on causal-set growth, where including what can be born next '
                          'is having precedence included, and keeping widening holds on every course from a causal set.',
                    'zh': '其同偏移之比较读于因果集之生长上：含次可生者即先后被含，自因果集起之每一历程皆不断扩大。'}},
        {'id': RID11,
         'detail': {'en': 'Internal temporality read as holding the past, so the held possible is the whole possible '
                          'on causal-set growth.',
                    'zh': '内在时间性读作持守过去，故于因果集之生长上持守之可能即全部可能。'}}],
    'references': [{'path': LEAN['CausalGrowth'], 'role': 'proof', 'declarations': sorted(citedG),
                    'sha256': sha(LEAN['CausalGrowth'])}]
                  + [{'path': LEAN[m], 'role': 'proof', 'sha256': sha(LEAN[m])}
                     for m in ('HeldPossible', 'ReachableRanges', 'Grammar', 'Frame')]
                  + common_refs + [{'path': CH7, 'role': 'statement', 'sha256': sha(CH7)}],
    'proof_bindings': binding,
    'history': [{
        'en': f'{DATE_EN}: added (UE13), what can be born next against what continues: sequential growth a process '
              f'holding the past, on whose every course from a causal set what can be born next keeps widening; the '
              f'stems reverse the inclusion of precedence, labelled or up to relabelling, so widening adds no '
              f'continuation; read on what continues the order reverses and no strict order contains both; finding '
              f'the pair a widening loses is excluded middle; most comparisons need the empty start; no configuration '
              f'renews without end; a finer class on links; kinds of birth not so ordered; after a review and a '
              f're-check; study section {N}.',
        'zh': f'{DATE_ZH}：新增（UE13），次可生者与相续：序贯生长为持守过去之过程，自因果集起之每一历程上次可生者不断扩大；茎反转先后之包含（有标号或重编号下皆然），'
              f'故扩大不增相续；读于相续则序反转，无一严格之序兼含二者；求扩大所失之对即排中律；多数比较需自空集起；无构型生生不息；读于覆盖之较细之类；'
              f'生之种类不如是排序；经审查与复查；研究第 {N} 节。'}],
}

for rec in (recordP, recordG):
    deps = [x['id'] for x in rec['dependencies']] + [x['id'] for x in rec['related']]
    for rid in deps:
        assert rid in (RIDP, RIDG) or (RECORDS / f'{rid}.json').exists(), rid
    path = RECORDS / f'{rec["id"]}.json'
    assert not path.exists(), path
for rec in (recordP, recordG):
    (RECORDS / f'{rec["id"]}.json').write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('records:', RIDP, len(citedP), 'declarations in', len(groupsP), 'laws;', RIDG, len(citedG), 'declarations in',
      len(groupsG), 'laws')


def load(rid):
    return json.loads((RECORDS / f'{rid}.json').read_text(encoding='utf-8'))


def save(rid, d):
    (RECORDS / f'{rid}.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def history(d, en, zh):
    d['history'].append({'en': f'{DATE_EN}, board item UE13 (study section {N}): {en}',
                         'zh': f'{DATE_ZH}，工作板条目 UE13（研究第 {N} 节）：{zh}'})


# what a course keeps reachable, and where the possible grows: related to the growth record
RELATED = {
    RID10: {'en': 'What can be born next against what continues: on causal-set growth, including what can be born next '
                  'at the same offsets is having precedence included, and every course from a causal set keeps '
                  'widening it.',
            'zh': '次可生者与相续：于因果集之生长上，于同偏移处含次可生者即先后被含，自因果集起之每一历程皆使之不断扩大。'},
    RID11: {'en': 'What can be born next against what continues: internal temporality is holding the past, so on '
                  'causal-set growth the held possible is the whole possible.',
            'zh': '次可生者与相续：内在时间性即持守过去，故于因果集之生长上持守之可能即全部可能。'}}
for rid, detail in RELATED.items():
    d = load(rid)
    assert RIDG not in [x['id'] for x in d['related']]
    d['related'].append({'id': RIDG, 'detail': detail})
    history(d, f'related to {RIDG}; no statement, next step or declaration changed.',
            f'与 {RIDG} 相关联；无一陈述、下一步或声明改变。')
    save(rid, d)
print('records related here:', RID10, RID11)
