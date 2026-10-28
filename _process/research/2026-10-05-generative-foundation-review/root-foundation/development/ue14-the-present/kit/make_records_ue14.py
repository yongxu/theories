#!/usr/bin/env python3
"""UE14 record: write the-present-on-causal-set-growth (Becoming.Presence, homed at 01 §1 after precedence and its
links), each declaration of the module cited once; relate precedence-and-its-links and what-can-be-born-next to it,
each with a related entry and a history note; neither's statement, next step or declarations change. Asserts the
receipt's hash and empty axiom reports for the module, and the style caps and lint (tools/research/style.py) on every
field written. Mirrors UE13's make_records_ue13.py; no landed module changes, so no record is re-pointed for Lean.
usage (from the checkout root, after texts_ue14.py): python3 -B make_records_ue14.py RECEIPT N
       python3 -B make_records_ue14.py --caps  (the caps, lint and the declaration cover against the kit's scratch
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
RECEIPT_ID, N = ('20261028T000000.000000Z', 432) if CAPS_ONLY else (sys.argv[1], int(sys.argv[2]))
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RF + 'BECOMING-RENEWAL-READING.md'
KITD = RF + 'development/ue14-the-present/'
NOTE, REVIEW = KITD + 'NOTE.md', KITD + 'REVIEW-UE14.md'
CH1 = 'theories/becoming/chapters/01-ROOT.md'
LEAN = {m: f'{PKG}/Becoming/{m}.lean' for m in
        ('Presence', 'CausalGrowth', 'OrderNormal', 'Reordering', 'Grammar', 'Decidedness')}
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
RID = 'the-present-on-causal-set-growth'
RIDP = 'precedence-and-its-links'
RIDG = 'what-can-be-born-next'
RIDN = 'normal-forms-need-decided-apartness'
RIDO = 'order-of-exchanges-is-the-invariant'
RIDC = 'continuation-relative-to-a-class'
RIDD = 'counts-exist-where-decided'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
TODAY = datetime.date.today()
DATE_EN, DATE_ZH = f'{TODAY.day} {TODAY:%B} {TODAY.year}', f'{TODAY.year}年{TODAY.month}月{TODAY.day}日'
COUNT = 190


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def capped(field, pair, item=False):
    caps = style.ITEM_CAPS_V2 if item else style.CAPS_V2
    en, zh = caps[field][:2]
    assert len(pair['en']) <= en and len(pair['zh']) <= zh, (field, len(pair['en']), en, len(pair['zh']), zh, pair['en'][:60])
    return pair


if CAPS_ONLY:
    audit = (HERE.parent / 'tree/.build/BecomingPresenceAxiomAudit.lean').read_text(encoding='utf-8')
    names = set(re.findall(r'^#print axioms (\S+)$', audit, re.M))
else:
    core = json.loads((ROOT / RECEIPT).read_text())
    assert core['status'] == 'passed'
    module = 'Becoming.Presence'
    assert core['source_sha256'][module] == sha(LEAN['Presence']), module
    mod = next(x for x in core['modules'] if x['module'] == module)
    assert not any(mod['axiom_dependencies'].values()), module
    names = {d['name'] for d in mod['declarations']}
assert len(names) == COUNT, len(names)


def C(*short):
    out = ['Becoming.Presence.' + s for s in short]
    missing = [n for n in out if n not in names]
    assert not missing, missing
    return out


groups = [
    ("Natural labellings. A natural labelling of a causal set renumbers its elements keeping precedence, each placed "
     "after what precedes it (NaturalLabelling, NaturalLabelling.at, NaturalLabelling.back, NaturalLabelling.before); "
     "the labels as they are form one (natural_identity).",
     "自然编号：重编一因果集之元而守先后，每元置于先于之者之后（NaturalLabelling 及其 at、back、before）；原标号即其一（natural_identity）。",
     C('NaturalLabelling', 'NaturalLabelling.at', 'NaturalLabelling.back', 'NaturalLabelling.before',
       'natural_identity')),
    ("A natural labelling gives a causal set of the kind: reading the label a as the element σ a gives a causal set "
     "onto which the labelling carries the first (relabel, relabel_ordered, natural_relabels), and every relabelling "
     "onto a causal set of the same size is a natural labelling (natural_of_relabels).",
     "自然编号给出同种之因果集：读标号 a 为元 σ a，得一因果集，编号携原者至其上（relabel、relabel_ordered、natural_relabels）；"
     "凡至同大小因果集之重编号皆为自然编号（natural_of_relabels）。",
     C('relabel', 'relabel_ordered', 'natural_relabels', 'natural_of_relabels')),
    ("The orders of birth. Every causal set is grown from the empty set, bearing the element t at offset t with its "
     "past (pastIn, pastIn_stem, courseOf, courseOf_grows, courseOf_isomorphic), and the natural labellings are exactly "
     "the numberings of its elements by a course from the empty set whose configuration at its size is of its kind "
     "(natural_iff_course).",
     "生之次序：凡因果集皆自空集生，于偏移 t 以其过去生元 t（pastIn、pastIn_stem、courseOf、courseOf_grows、courseOf_isomorphic）；"
     "自然编号恰为自空集起、于其大小处构型与之同种之历程对其元之编号（natural_iff_course）。",
     C('pastIn', 'pastIn_stem', 'courseOf', 'courseOf_grows', 'courseOf_isomorphic', 'natural_iff_course')),
    ("What depends only on precedence: the natural labellings depend only on the size and the precedence "
     "(natural_congr), and so does whatever holds on every course or on some course, whatever is read on a course "
     "(every_congr, some_congr).",
     "唯依先后者：自然编号唯依大小与先后（natural_congr）；凡于每一历程或某一历程成立者亦然，无论于历程上读何（every_congr、some_congr）。",
     C('natural_congr', 'every_congr', 'some_congr')),
    ("Births of unrelated elements commute, and only they: from a natural labelling, a renumbering is reached by "
     "exchanging consecutive births of incomparable elements exactly where it is a natural labelling (Comparable, "
     "comparable_symm, natural_orients, rearranges_iff_natural), the core's theorem of Mazurkiewicz read on growth.",
     "无先后者之生可互换，且唯其可换：自一自然编号，一重编号由互换相邻不可比元之生而得，恰当其为自然编号（Comparable、comparable_symm、"
     "natural_orients、rearranges_iff_natural），即核心之 Mazurkiewicz 定理读于生长。",
     C('Comparable', 'comparable_symm', 'natural_orients', 'rearranges_iff_natural')),
    ("Counting what a Boolean test passes below m, the numbers Frequency.count computes, kept local: what passes is "
     "counted before what comes later, two passing numbers with as many passing below each are one, the count takes "
     "every value below it, and what passes and what fails make all (count and its laws, two Boolean lemmas).",
     "计 m 以下通过一布尔检验者，即 Frequency.count 所计之数，留于本模块：通过者先于其后者计，二通过之数其下通过者同数则为一，"
     "计数取其下每一值，通过与不通过者合为全体（count 及其律，二布尔引理）。",
     C('count', 'count_succ_of_true', 'count_succ_of_false', 'count_le_succ', 'count_le_add', 'count_mono',
       'count_le', 'count_lt_of', 'count_inj', 'count_reaches', 'count_add_not', 'not_false_of_true',
       'bool_absurd')),
    ("A down-set first. The stable partition places what passes first and then the rest, each in label order, its "
     "inverse found by bounded search; it is a renumbering of the first n numbers, and where the test is closed "
     "downward it keeps the order, so on a causal set it is a natural labelling (front, back and their laws, "
     "front_reindexes, front_keeps, front_natural).",
     "下集为先：稳定划分置通过者于先、余者于后，各依标号之序，其逆由有界搜索得之；其为前 n 数之重编号，检验向下封闭时守序，"
     "故于因果集上为自然编号（front、back 及其律、front_reindexes、front_keeps、front_natural）。",
     C('front', 'back', 'front_of_true', 'front_of_false', 'front_lt', 'front_true_lt_false', 'front_lt_count_iff',
       'front_inj', 'front_onto', 'lt_zero_add', 'of_lt_zero_add', 'front_reindexes', 'front_keeps',
       'front_natural')),
    ("What a course has born by a stage is closed downward, a stem (born_closed, born_stem), and every stem with "
     "decided membership is what some course bears first, in as many births as it has elements (stem_born_first): "
     "Brightwell and others' characterization of their stem sets, here on finite causal sets.",
     "一历程至某阶段所已生者向下封闭，为一茎（born_closed、born_stem）；成员可判定之每一茎，皆为某一历程所先生者，生数等于其元数"
     "（stem_born_first），即 Brightwell 等对其茎集之刻画，此处于有限因果集。",
     C('born_closed', 'born_stem', 'stem_born_first')),
    ("Tables of a test: every test on the first n numbers has a table doubly negated, a decided one has a table, and "
     "a table of a test closed downward gives a natural labelling (Tabulates, beq_false_of_ne, table_yes, table_no, "
     "table_not_not, table_of, natural_of_table, table_false, down_closed); whether some number below a bound has a "
     "property is weakly decided where it is for each (decided_true, weakly_exists_below).",
     "检验之表：前 n 数上之每一检验，其有表不可否证，可判定者有表，向下封闭之检验之表给出自然编号（Tabulates、table_yes、table_no、"
     "table_not_not、table_of、natural_of_table 等）；界下某数具一性质，各数弱可判定则此亦弱可判定（decided_true、weakly_exists_below）。",
     C('Tabulates', 'beq_false_of_ne', 'table_yes', 'table_no', 'table_not_not', 'table_of', 'natural_of_table',
       'table_false', 'down_closed', 'decided_true', 'weakly_exists_below')),
    ("Down-sets of an element: bearing first what precedes j, with j, is a natural labelling that bears j before "
     "everything not preceding it (downTo, downTo_closed, downTo_self, downTo_other, downTo_before).",
     "一元之下集：先生先于 j 者与 j，为一自然编号，生 j 于凡不先于之者之前（downTo、downTo_closed、downTo_self、downTo_other、"
     "downTo_before）。",
     C('downTo', 'downTo_closed', 'downTo_self', 'downTo_other', 'downTo_before')),
    ("Born before on every course is precedence: with precedence decided, i precedes j exactly where i is born before "
     "j in every natural labelling (prec_iff_every), so what is born no later than an element on every course is its "
     "past, itself included (past_every_iff), the largest relation every course respects (past_largest).",
     "于每一历程皆先生即先后：先后可判定时，i 先于 j 恰当于每一自然编号中 i 生于 j 前（prec_iff_every）；故于每一历程皆不后于一元而生者，"
     "即其过去连同其自身（past_every_iff），为诸历程皆守之最大关系（past_largest）。",
     C('prec_iff_every', 'past_every_iff', 'past_largest')),
    ("With no decision, born before on every course is exactly precedence not refuted (every_not_not, "
     "every_iff_not_not).",
     "无判定时，于每一历程皆先生恰为先后不可否证（every_not_not、every_iff_not_not）。",
     C('every_not_not', 'every_iff_not_not')),
    ("Born before on some course: with precedence weakly decided, i is born before j in some natural labelling exactly "
     "where they differ and j does not precede i (before_of_weakly, before_some_iff); two different unrelated elements "
     "are born in either order, so no order of birth of unrelated elements is common to all courses (either_order).",
     "于某一历程先生：先后弱可判定时，i 于某一自然编号中生于 j 前，恰当二者相异且 j 不先于 i（before_of_weakly、before_some_iff）；"
     "二相异而无先后之元二序皆可生，故无先后者之生序非诸历程所共（either_order）。",
     C('before_of_weakly', 'before_some_iff', 'either_order')),
    ("Asked of every causal set, born before on every course gives precedence exactly under excluded middle, and "
     "past_every_iff from left to right is exactly excluded middle too, on two elements whose one precedence is a "
     "proposition (pairIf, pairIf_ordered, every_needs_decision, every_iff_em, past_every_needs_decision, "
     "past_every_iff_em).",
     "问于每一因果集，于每一历程皆先生给出先后恰当排中律，past_every_iff 自左至右亦恰为排中律；二元、其唯一先后为一命题（pairIf、"
     "pairIf_ordered、every_needs_decision、every_iff_em、past_every_needs_decision、past_every_iff_em）。",
     C('pairIf', 'pairIf_ordered', 'every_needs_decision', 'every_iff_em', 'past_every_needs_decision',
       'past_every_iff_em')),
    ("Asked of every causal set, either_order and before_some_iff from right to left are each exactly weak excluded "
     "middle, through De Morgan's law on three elements whose precedences are propositions (weakly_of_deMorgan, "
     "middleIf and its laws, either_order_deMorgan, either_order_iff_weakly, before_some_iff_weakly).",
     "问于每一因果集，either_order 与 before_some_iff 自右至左各恰为弱排中律，经三元（其先后为命题）上之德摩根律（weakly_of_deMorgan、"
     "middleIf 及其律、either_order_deMorgan、either_order_iff_weakly、before_some_iff_weakly）。",
     C('weakly_of_deMorgan', 'middleIf', 'middleIf_ordered', 'middleIf_not_two_zero', 'middleIf_not_zero_two',
       'either_order_deMorgan', 'either_order_iff_weakly', 'before_some_iff_weakly')),
    ("The present at a stage: the maximal elements of what a course has born by then (bornBy, MaximalBorn), where the "
     "grammar's ending, «亡» under «一», holds on what is born (maximalBorn_iff_ends); two elements of one present are "
     "unrelated (maximalBorn_unrelated), and bearing first what a downward-closed test passes, the present after as "
     "many births is the passing elements preceding nothing passing (maximalBorn_front).",
     "某阶段之现在：一历程至彼时所已生者之极大元（bornBy、MaximalBorn），即文法之亡（«一» 下之 «亡»）于已生者上成立（maximalBorn_iff_ends）；"
     "同一现在之二元无先后（maximalBorn_unrelated）；先生向下封闭之检验所通过者，生如数之后，现在即不先于任何通过者之通过元（maximalBorn_front）。",
     C('bornBy', 'MaximalBorn', 'maximalBorn_iff_ends', 'maximalBorn_unrelated', 'maximalBorn_front')),
    ("With precedence weakly decided, every antichain given by a Boolean test is the present of some course at some "
     "stage (weakly_above, antichain_present), and two elements are in the present at some stage of some course "
     "exactly where neither precedes the other (together_some_iff).",
     "先后弱可判定时，以布尔检验给出之每一反链，皆为某一历程某阶段之现在（weakly_above、antichain_present）；二元于某一历程某阶段同处一现在，"
     "恰当二者互不相先（together_some_iff）。",
     C('weakly_above', 'antichain_present', 'together_some_iff')),
    ("Present together on every course: with precedence decided, exactly where the two have the same future "
     "(future_of_together_every, together_every_iff); with no decision, exactly where the same future holds doubly "
     "negated (together_not_not, together_every_iff_not_not).",
     "于每一历程同处一现在：先后可判定时，恰当二者其后相同（future_of_together_every、together_every_iff）；无判定时，恰当其后相同不可否证"
     "（together_not_not、together_every_iff_not_not）。",
     C('future_of_together_every', 'together_every_iff', 'together_not_not', 'together_every_iff_not_not')),
    ("Asked of every causal set, together_every_iff from left to right is exactly excluded middle (apartIf, "
     "apartIf_ordered, together_every_needs_decision, together_every_iff_em), and together_some_iff from right to "
     "left and antichain_present are each exactly weak excluded middle (together_some_deMorgan, "
     "together_some_iff_weakly, together_of_antichain, antichain_present_iff_weakly).",
     "问于每一因果集，together_every_iff 自左至右恰为排中律（together_every_iff_em 等）；together_some_iff 自右至左与 "
     "antichain_present 各恰为弱排中律（together_some_iff_weakly、antichain_present_iff_weakly 等）。",
     C('apartIf', 'apartIf_ordered', 'together_every_needs_decision', 'together_every_iff_em',
       'together_some_deMorgan', 'together_some_iff_weakly', 'together_of_antichain', 'antichain_present_iff_weakly')),
    ("Presence at a birth: i is present at j's birth where i precedes j and nothing i precedes is born before j, on a "
     "natural labelling exactly where i precedes j and is in the present at j's stage (PresentAt, "
     "present_iff_maximalBorn); present "
     "on some course, it is a link below j (link_of_present), and with precedence weakly decided every link is "
     "(present_some_iff_link).",
     "于其生时在：i 先于 j 且 i 所先者皆不生于 j 前；于自然编号上恰当 i 先于 j 且于 j 之阶段在现在（PresentAt、present_iff_maximalBorn）；"
     "于某一历程在，则为 j 下之覆盖（link_of_present）；先后弱可判定时，每一覆盖皆然（present_some_iff_link）。",
     C('PresentAt', 'present_iff_maximalBorn', 'link_of_present', 'present_some_iff_link')),
    ("The least element above: j is the least element above i where i precedes j and everything i precedes is j or "
     "above j (LeastAbove), a link (link_of_least); with precedence decided, i is present at j's birth on every course "
     "exactly there (present_every_iff), exactly where j is the one element i is linked to (least_iff_only_link).",
     "其上之最小元：i 先于 j 且 i 所先者皆为 j 或在 j 之上，则 j 为 i 之上之最小元（LeastAbove），为覆盖（link_of_least）；先后可判定时，"
     "i 于每一历程于 j 之生时在恰当于此（present_every_iff），即 j 为 i 唯一之覆盖（least_iff_only_link）。",
     C('LeastAbove', 'link_of_least', 'present_every_iff', 'least_iff_only_link')),
    ("On every course, the one link, with no decision: i is present at j's birth in every natural labelling exactly "
     "where j is the one element i is linked to (above_of_only_not_not, present_every_of_only_link, "
     "only_link_of_present_every, present_every_iff_only_link); everything i precedes is then at or above j doubly "
     "negated (above_of_every_not_not).",
     "于每一历程，唯一之覆盖，无需判定：i 于每一自然编号中于 j 之生时在，恰当 j 为 i 唯一之覆盖（present_every_iff_only_link 及其二向）；"
     "i 所先者在 j 或其上，不可否证（above_of_every_not_not）。",
     C('above_of_only_not_not', 'present_every_of_only_link', 'only_link_of_present_every',
       'present_every_iff_only_link', 'above_of_every_not_not')),
    ("Asked of every causal set, passing from presence on every course, or from the one link, to the least element "
     "above is exactly excluded middle (leastIf, leastIf_ordered, present_every_needs_decision, present_least_iff_em, "
     "only_link_least_iff_em), and present_some_iff_link from right to left is exactly weak excluded middle (linkIf, "
     "linkIf_ordered, present_some_deMorgan, present_some_iff_weakly).",
     "问于每一因果集，自于每一历程在、或自唯一之覆盖，推至其上之最小元，恰为排中律（present_least_iff_em、only_link_least_iff_em）；"
     "present_some_iff_link 自右至左恰为弱排中律（present_some_iff_weakly）。",
     C('leastIf', 'leastIf_ordered', 'present_every_needs_decision', 'present_least_iff_em', 'only_link_least_iff_em',
       'linkIf', 'linkIf_ordered', 'present_some_deMorgan', 'present_some_iff_weakly')),
    ("On three elements, 0 below 1 and 2: 0 is not present at 2's birth on the labels as they are and is with the "
     "births of 1 and 2 exchanged, so it is a link below 2 and 2 is not the least element above it; the present after "
     "two births is exactly 1 on one course and exactly 2 on another (below_three, swap12, swap12_three, Vee).",
     "三元，0 在 1 与 2 之下：依原标号，0 不于 2 之生时在，互换 1 与 2 之生则在，故其为 2 下之覆盖，而 2 非其上之最小元；生二元后之现在，"
     "于一历程恰为 1，于另一历程恰为 2（below_three、swap12、swap12_three、Vee）。",
     C('below_three', 'swap12', 'swap12_three', 'Vee.vee', 'Vee.ordered', 'Vee.natural_swap',
       'Vee.not_present_identity', 'Vee.present_swap', 'Vee.link', 'Vee.not_least', 'Vee.maximal_after_two_identity',
       'Vee.maximal_after_two_swap')),
    ("Wüthrich and Callender's four elements, 0 below 1 and 2, both below 3: their relation, each element with itself "
     "and its past and the two middle elements with each other, is reflexive and transitive and neither the past read "
     "reflexively nor universal (Diamond: diamond, prec_below, ordered, PastOrPair and its laws).",
     "Wüthrich 与 Callender 之四元，0 在 1 与 2 之下，二者皆在 3 之下：其关系，每元与自身及其过去、二中间元互相，自反且可传递，"
     "既非自反之过去，亦非全关系（Diamond：diamond、prec_below、ordered、PastOrPair 及其律）。",
     C('Diamond.diamond', 'Diamond.prec_below', 'Diamond.ordered', 'Diamond.PastOrPair', 'Diamond.pastOrPair_refl',
       'Diamond.pastOrPair_below', 'Diamond.pastOrPair_trans', 'Diamond.pastOrPair_pair')),
    ("Every automorphism keeps it: an automorphism carries the middle elements, those preceded and preceding, to "
     "middle elements one to one (Diamond: Middle, middle_iff, pair_of_middle, middle_of_pair, auto_middle, "
     "auto_middle_back, auto_inj, pastOrPair_kept).",
     "每一自同构皆守之：自同构一一携中间元（有所先者且先于他者之元）至中间元（Diamond：Middle、middle_iff、pair_of_middle、"
     "middle_of_pair、auto_middle、auto_middle_back、auto_inj、pastOrPair_kept）。",
     C('Diamond.Middle', 'Diamond.middle_iff', 'Diamond.pair_of_middle', 'Diamond.middle_of_pair',
       'Diamond.auto_middle', 'Diamond.auto_middle_back', 'Diamond.auto_inj', 'Diamond.pastOrPair_kept')),
    ("It is not what every course has born by a birth: in it 2 is definite as of 1, while on the labels as they are 2 "
     "is born after 1 (below_four, swap12_four, Diamond.courses_disagree, Diamond.kept_not_agreed); on the diamond it "
     "is the past joined with being present together on every course, the pair having the same future (PastOrTogether, "
     "Diamond.pastOrTogether_iff and two lemmas).",
     "其非每一历程于一生时所已生者：其中 2 于 1 为已定，而依原标号 2 生于 1 后（Diamond.kept_not_agreed 等）；于此四元，"
     "其即过去并于每一历程同处一现在，此对其后相同（PastOrTogether、Diamond.pastOrTogether_iff 等）。",
     C('below_four', 'swap12_four', 'Diamond.courses_disagree', 'Diamond.kept_not_agreed', 'PastOrTogether',
       'Diamond.future_one_two', 'Diamond.pastOrPair_iff_together', 'Diamond.pastOrTogether_iff')),
    ("Off the diamond the join need not be their relation: on four elements, 0 below 1 and 3, 1 and 2 below 3, the two "
     "have the same future and so are present together on every course with different pasts, and the past joined "
     "with being present together on every course is not transitive (SameFuture and its laws).",
     "此四元之外，此未必为其关系：四元，0 在 1 与 3 之下，1 与 2 在 3 之下，二者其后相同，故于每一历程同处一现在而其前不同；过去并于每一历程同处"
     "一现在不可传递（SameFuture 及其律）。",
     C('SameFuture.sameFuture', 'SameFuture.prec_below', 'SameFuture.ordered', 'SameFuture.future_one_two',
       'SameFuture.together_different_pasts', 'SameFuture.pastOrTogether_not_trans')),
    ("On the courses themselves: what holds in every natural labelling holds on every course of the growth from the "
     "empty set, read through a relabelling onto its configuration at c's size, and in some on some (every_course_iff, "
     "some_course_iff); so births of unrelated elements commute and only they, and every stem with decided membership "
     "is born first, on the courses (rearranges_iff_course, stem_born_first_course).",
     "于诸历程本身：于每一自然编号成立者，于自空集起之每一生长历程成立，经由至其于 c 之大小处构型之重编号读之；于某一者，则于某一历程"
     "（every_course_iff、some_course_iff）；故无先后者之生可互换且唯其可换，成员可判定之每一茎皆为某历程所先生，皆于诸历程上"
     "（rearranges_iff_course、stem_born_first_course）。",
     C('every_course_iff', 'some_course_iff', 'rearranges_iff_course', 'stem_born_first_course')),
    ("Born before on the courses, each with its law's decision: precedence is born before on every course, the past "
     "with the element is what is born no later on every course, the largest relation every course respects; with no "
     "decision, precedence not refuted; born before on some course is differing and not being preceded, and two "
     "different unrelated elements are born in either order (prec_iff_every_course and five more).",
     "诸历程上之先生，各带其律之判定：于每一历程皆先生即先后；过去连同该元为于每一历程皆不后生者，为诸历程皆守之最大关系；无判定时，于每一历程皆先生"
     "即先后不可否证；于某一历程先生即相异且不为所先；二相异而无先后之元二序皆可生（prec_iff_every_course 等六律）。",
     C('prec_iff_every_course', 'past_every_course', 'past_largest_course', 'every_course_not_not',
       'before_some_course', 'either_order_course')),
    ("Presents and presence on the courses: every antichain given by a test is a present; two elements are present "
     "together on some course where unrelated, on every course where they have the same future, with no decision "
     "where that holds doubly negated; a condition is present at a birth on some course where it is a link, on every "
     "course where it is the one link (antichain_present_course and five more).",
     "诸历程上之现在与在：以检验给出之每一反链皆为一现在；二元于某一历程同处现在即无先后，于每一历程即其后相同，无判定时即其后相同不可否证；"
     "缘于一生时在，于某一历程即为覆盖，于每一历程即为唯一之覆盖（antichain_present_course 等六律）。",
     C('antichain_present_course', 'together_some_course', 'together_every_course', 'together_every_course_not_not',
       'present_some_course', 'present_every_course_only_link')),
]
cited = [d for _, _, ds in groups for d in ds]
assert len(cited) == len(set(cited)) == COUNT, (len(cited), len(set(cited)))
assert set(cited) == names, sorted(names - set(cited))

laws = [capped('laws', {'en': en, 'zh': zh, 'declarations': ds}, item=True) for en, zh, ds in groups]
assert len(laws) <= style.ITEM_CAPS_V2['laws'][2]

validation = capped('validation_scope', {
    'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): all {COUNT} declarations of '
          f'Becoming.Presence, each with an empty axiom report. Built in one session; an independent read-only review '
          f'by another AI agent (REVIEW-UE14, 18 findings, every one taken) and a re-check, study section {N}; not '
          f'reviewed by a person. Most laws restate the order theory of linear extensions.',
    'zh': f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：Becoming.Presence 之全部 {COUNT} 项声明，公理报告皆空。于一会话中构建；'
          f'另一 AI 代理作独立只读审查（REVIEW-UE14，十八条，皆已采纳）并复查，见研究第 {N} 节；未经人审。多数律重述线性扩张之序论。'})

title = capped('title', {'en': 'The present on causal-set growth', 'zh': '因果集生长上之现在'})
statement = capped('statement', {
    'en': "On causal-set growth the present, read as the maximal elements of what a course has born, is a choice of "
          "course between bounds defined from precedence: a condition is present at a birth on some course exactly "
          "where it is a link (precedence weakly decided), on every course exactly at the one link.",
    'zh': '于因果集之生长上，现在读作一历程所已生者之极大元，则随历程而择，介于由先后定义之二界之间：缘于一生时在现在，于某一历程恰当其为覆盖'
          '（先后弱可判定），于每一历程恰当其为唯一之覆盖。'})
hypotheses = [capped('hypotheses', x, item=True) for x in (
    {'en': "No axiom. The laws on natural labellings, the stable partition, those defining the present at a stage "
           "(maximalBorn_iff_ends, maximalBorn_unrelated, maximalBorn_front) and the one link hold on every causal set "
           "of the growth (Causet.Ordered) with no decision on precedence, as do "
           "every_iff_not_not and together_every_iff_not_not. Each course form takes its law's decision.",
     'zh': '不加公理。自然编号、稳定划分、界定某阶段之现在者（maximalBorn_iff_ends、maximalBorn_unrelated、maximalBorn_front）与唯一覆盖之律，'
           '于每一因果集成立（Causet.Ordered），先后无需判定；'
           'every_iff_not_not 与 together_every_iff_not_not 亦然。每一历程形式带其律之判定。'},
    {'en': "The laws on some course (before_some_iff, either_order, together_some_iff, antichain_present, "
           "present_some_iff_link) take precedence weakly decided on the causal set: of any two elements, the one does "
           "not precede the other or that it does not is refuted (the core's WeaklyDecided).",
     'zh': '于某一历程之律（before_some_iff、either_order、together_some_iff、antichain_present、present_some_iff_link）'
           '需先后于该因果集弱可判定：任二元，或此不先于彼，或此说被否证（核心之 WeaklyDecided）。'},
    {'en': "prec_iff_every, past_every_iff, past_largest, together_every_iff, present_every_iff and "
           "least_iff_only_link take precedence decided (a Decidable instance); stem_born_first takes membership in "
           "the stem decided.",
     'zh': 'prec_iff_every、past_every_iff、past_largest、together_every_iff、present_every_iff 与 least_iff_only_link '
           '需先后可判定（Decidable 实例）；stem_born_first 需茎之成员可判定。'},
    {'en': "Asked of every causal set, the direction of each law that needs its decision is exactly its principle: "
           "excluded middle for prec_iff_every, past_every_iff, together_every_iff, present_every_iff and "
           "least_iff_only_link, weak excluded middle for the five laws on some course. Each calibration is "
           "a lemma of its law, its meaning for the unfolding stated in UE14's NOTE (law 8).",
     'zh': '问于每一因果集，每律需判定之一向恰为其原则：prec_iff_every、past_every_iff、together_every_iff、present_every_iff 与 '
           'least_iff_only_link 为排中律，于某一历程之五律为弱排中律。每一校准为其律之引理，'
           '其于展开之意义见 UE14 之 NOTE（律 8）。'},
    {'en': "Modelling choices: finite labelled causal sets; natural labellings renumber the first size numbers and leave "
           "other values free, so the laws about an element carry its bound; presence read as being among the maximal "
           "elements of what has been born; covariance read as relabelling, courses compared by their orders of "
           "birth; antichains given by a Boolean test; pointwise, with no function extensionality.",
     'zh': '建模之选：有限有标号之因果集；自然编号重编前 size 个数，余值自由，故关于一元之律皆带其界；在读作在已生者之极大元中；'
           '协变读作重编号，历程以其生序相较；反链以布尔检验给出；皆逐点，不用函数外延性。'})]
does_not_show = [capped('does_not_show', x, item=True) for x in (
    {'en': "Anything about continuous time, the present of a center or of experience, or presence on the theory's "
           "other models.",
     'zh': '关于连续时间、一中心或经验之现在、或本理论其他模型上之在之任何事。', 'kind': 'scope'},
    {'en': "Anything about transition probabilities, Bell causality, the continuum limit or infinite causal sets.",
     'zh': '关于转移概率、贝尔因果性、连续极限或无穷因果集之任何事。', 'kind': 'scope'},
    {'en': "That presence must be read so: being in the configuration, Dowker's birth and a maximal antichain of the "
           "whole configuration answer without varying with the course, stated in the note, not proved in Lean.",
     'zh': '在必如此读：在构型中、Dowker 之生、整个构型之极大反链，其答皆不随历程而变，述于 NOTE，未以 Lean 证之。',
     'kind': 'non-implication'},
    {'en': "A uniqueness theorem of Stein's kind: the past is singled out as the largest relation every course "
           "respects, not as the only one meeting conditions.",
     'zh': 'Stein 式之唯一性定理：过去被选出为诸历程皆守之最大关系，而非满足诸条件之唯一者。', 'kind': 'non-implication'},
    {'en': "Which presence or which course is better.",
     'zh': '何种在或何历程更好。', 'kind': 'non-implication'})]
next_delta = capped('next_delta', {
    'en': "Presence on the theory's other models, first the order of exchanges the World's interleavings leave; the "
          "present of a center; growths whose courses are weighted; review by a person.",
    'zh': '本理论其他模型上之在，先及世界之交错所留之交换之序；一中心之现在；历程有权重之生长；人之审查。'})
correspondence = capped('correspondence', {
    'en': "Causal set theory: natural labellings as linear extensions, links, partial stems with their correspondence "
          "to antichains, and discrete general covariance (Rideout and Sorkin 2000); stem sets through the first "
          "elements of natural labellings (Brightwell and others 2003), stem_born_first here "
          "on finite causal sets; each birth as the passage of time, unrelated births unordered (Dowker 2014), her "
          "present a birth, not this module's. Order theory: linear extensions are connected by exchanging adjacent "
          "incomparable elements (Mazurkiewicz 1977; the core's theorem), a finite order is the intersection of its "
          "linear extensions (Szpilrajn 1930; Dushnik and Miller 1941), and every antichain is the maximal elements "
          "of its down-closure; the laws on presence at a birth and on being present together are elementary "
          "consequences, not found stated there. Stein's theorem (1968, 1991), in Wüthrich and "
          "Callender's form (2017): the past is here the largest relation every course respects, a maximum, not "
          "uniqueness; on their four elements their relation is the past joined with being present together on "
          "every course, not in general. The calibrations: excluded middle and its weak form. Graded in UE14's NOTE.",
    'zh': '因果集理论：自然编号即线性扩张、覆盖、偏茎及其与反链之对应，及离散广义协变（Rideout、Sorkin 2000）；经自然编号之首元之茎集'
          '（Brightwell 等 2003），此处 stem_born_first 于有限因果集；每一生为时之流逝，无先后者之生无序（Dowker 2014），其现在为一生，非本模块之现在。'
          '序论：线性扩张由互换相邻不可比之元相连（Mazurkiewicz 1977，核心之定理），有限之序为其线性扩张之交（Szpilrajn 1930；Dushnik、Miller 1941），'
          '每一反链为其下闭包之极大元；于生时在与同处一现在之律为浅显推论，未见于诸源。Stein 定理（1968、1991），依 Wüthrich 与 Callender（2017）之形式：'
          '过去于此为诸历程皆守之最大关系，为最大而非其唯一；于其四元，其关系即过去并于每一历程同处一现在，他处未必然。校准为排中律及其弱形式。'
          '分级见 UE14 之 NOTE。'})
counterexamples = [
    {'en': 'On three elements, 0 below 1 and 2, 0 is present at 2\'s birth on one course and not on another, and the '
           'present after two births is exactly 1 on one course and exactly 2 on another (Vee.present_swap, '
           'Vee.not_present_identity, Vee.maximal_after_two_identity, Vee.maximal_after_two_swap).',
     'zh': '三元，0 在 1 与 2 之下：0 于一历程于 2 之生时在，于另一历程不在；生二元后之现在，于一历程恰为 1，于另一历程恰为 2'
           '（Vee.present_swap、Vee.not_present_identity、Vee.maximal_after_two_identity、Vee.maximal_after_two_swap）。'},
    {'en': 'Asked of every causal set, born before, present together and the least element above on every course are '
           'each exactly excluded middle in their decided forms, and the laws on some course each exactly weak '
           'excluded middle, on witnesses of two and three elements whose precedences are propositions (every_iff_em, '
           'past_every_iff_em, together_every_iff_em, present_least_iff_em, either_order_iff_weakly, '
           'present_some_iff_weakly).',
     'zh': '问于每一因果集，于每一历程皆先生、同处现在与其上之最小元，其可判定形式各恰为排中律，于某一历程之律各恰为弱排中律，见于二元、三元其先后'
           '为命题之例（every_iff_em、past_every_iff_em、together_every_iff_em、present_least_iff_em、either_order_iff_weakly、'
           'present_some_iff_weakly）。'},
    {'en': 'On Wüthrich and Callender\'s four elements their relation is kept by every automorphism and is not what '
           'every course has born by a birth (Diamond.kept_not_agreed).',
     'zh': '于 Wüthrich 与 Callender 之四元，其关系为每一自同构所守，而非每一历程于一生时所已生者（Diamond.kept_not_agreed）。'},
    {'en': 'Off the diamond, two elements with the same future and different pasts are present together on every '
           'course, and the past joined with being present together on every course is not transitive '
           '(SameFuture.together_different_pasts, SameFuture.pastOrTogether_not_trans).',
     'zh': '此四元之外，其后相同而其前不同之二元于每一历程同处一现在，过去并于每一历程同处一现在不可传递'
           '（SameFuture.together_different_pasts、SameFuture.pastOrTogether_not_trans）。'}]


def lint_errors(rec):
    found = style.lint(rec)
    for f in found:
        print('lint:', rec['id'], f['severity'], f['field'], f['rule'], f['detail'])
    return [f for f in found if f['severity'] == 'error']


assert not lint_errors({'schema_version': 2, 'id': RID, 'title': title, 'statement': statement, 'laws': laws,
                        'hypotheses': hypotheses, 'does_not_show': does_not_show,
                        'counterexamples': [{'detail': x} for x in counterexamples],
                        'validation_scope': validation, 'next_delta': next_delta,
                        'correspondence': correspondence})

if CAPS_ONLY:
    print(f'caps: ok; {len(cited)} declarations in {len(laws)} laws; statement', len(statement['en']),
          len(statement['zh']), '; validation', len(validation['en']), len(validation['zh']), '; next',
          len(next_delta['en']), len(next_delta['zh']), '; correspondence', len(correspondence['en']),
          len(correspondence['zh']), '; laws max', max(len(x['en']) for x in laws), max(len(x['zh']) for x in laws),
          '; hypotheses max', max(len(x['en']) for x in hypotheses), max(len(x['zh']) for x in hypotheses))
    raise SystemExit(0)

lean_refs = [{'path': LEAN[m], 'role': 'proof', 'sha256': sha(LEAN[m])}
             for m in ('CausalGrowth', 'OrderNormal', 'Reordering', 'Grammar', 'Decidedness')]
common_refs = [{'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
               {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
               {'path': NOTE, 'role': 'integration', 'sha256': sha(NOTE)},
               {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)}]
binding = [{'source': LEAN['Presence'], 'receipt': RECEIPT,
            'sha256_pointer': '/source_sha256/Becoming.Presence',
            'success_pointer': '/status', 'success_value': 'passed'}]

record = {
    'schema_version': 2,
    'id': RID,
    'title': title,
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F01',
    'reviewed_at_utc': NOW,
    'statement': statement,
    'laws': laws,
    'hypotheses': hypotheses,
    'does_not_show': does_not_show,
    'counterexamples': [{'path': LEAN['Presence'], 'detail': x} for x in counterexamples],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'formal-not-empirical', 'names-provisional',
                            'omission-not-refutation'],
    'validation_scope': validation,
    'next_delta': next_delta,
    'correspondence': correspondence,
    'canonical_source': LEAN['Presence'],
    'aliases': ['The present on causal-set growth', '因果集生长上之现在', 'presence in time on causal-set growth',
                'natural labellings as orders of birth', 'the past as the largest relation every course respects',
                'Becoming.Presence.natural_iff_course', 'Becoming.Presence.present_some_iff_link',
                'Becoming.Presence.present_every_iff_only_link', 'Becoming.Presence.prec_iff_every',
                'Becoming.Presence.past_every_iff', 'Becoming.Presence.present_every_course_only_link'],
    'dependencies': [
        {'id': RIDP, 'relation': 'formal-reuse',
         'detail': {'en': 'Causet, Causet.Ordered, links, reach_links_le and ordered_reach_links_iff: causal sets and '
                          'their links.',
                    'zh': 'Causet、Causet.Ordered、links、reach_links_le 与 ordered_reach_links_iff：因果集与其覆盖。'}},
        {'id': RIDG, 'relation': 'formal-reuse',
         'detail': {'en': 'Stem, grown, course, process, empty, ordered_of_empty, size_of_run, Kinds.Relabels and '
                          'Kinds.Isomorphic: sequential growth, its courses and relabelling.',
                    'zh': 'Stem、grown、course、process、empty、ordered_of_empty、size_of_run、Kinds.Relabels 与 '
                          'Kinds.Isomorphic：序贯生长、其历程与重编号。'}},
        {'id': RIDN, 'relation': 'formal-reuse',
         'detail': {'en': 'KeepsOrder, Orients, Rearranges and rearranges_iff: arrangements and their commutations '
                          '(firstWhere, the core\'s bounded search, is cited by no record).',
                    'zh': 'KeepsOrder、Orients、Rearranges 与 rearranges_iff：排列及其互换（firstWhere，核心之有界搜索，无记录引之）。'}},
        {'id': RIDO, 'relation': 'formal-reuse',
         'detail': {'en': 'Reindexes: renumberings of a stretch.', 'zh': 'Reindexes：一段之重编号。'}},
        {'id': RIDC, 'relation': 'formal-reuse',
         'detail': {'en': '«际», «亡» and «一»: relations, ending and the one class.',
                    'zh': '«际»、«亡» 与 «一»：关系、亡与一类。'}},
        {'id': RIDD, 'relation': 'formal-reuse',
         'detail': {'en': 'Decided, Decided.of_not_not and not_not_decided: deciding, and that a proposition is '
                          'decided cannot be refuted; WeaklyDecided, the weak form in the same module, is cited only '
                          'by chapter 7\'s records, so no edge is drawn to them.',
                    'zh': 'Decided、Decided.of_not_not 与 not_not_decided：判定，及一命题可判定不可否证；同模块之弱形式 WeaklyDecided '
                          '唯第七章之记录引之，故不连于彼。'}}],
    'related': [],
    'references': [{'path': LEAN['Presence'], 'role': 'proof', 'declarations': sorted(cited),
                    'sha256': sha(LEAN['Presence'])}] + lean_refs + common_refs
                  + [{'path': CH1, 'role': 'statement', 'sha256': sha(CH1)}],
    'proof_bindings': binding,
    'history': [{
        'en': f'{DATE_EN}: added (UE14), the present on causal-set growth, read as the maximal elements of what a '
              f'course has born: natural labellings exactly the orders of birth, births of unrelated elements '
              f'commuting; born before on every course precedence, the past the largest relation every course '
              f'respects; every antichain a present; present together on every course the same future; presence at a '
              f'birth on some course a link, on every course the one link with no decision; each calibrated decision exact; each '
              f'main law also stated on the courses; '
              f'Wüthrich and Callender\'s relation on the diamond and off it; after a review and a re-check; study '
              f'section {N}.',
        'zh': f'{DATE_ZH}：新增（UE14），因果集生长上之现在，读作一历程所已生者之极大元：自然编号恰为生序，无先后者之生可互换；于每一历程皆先生即先后，'
              f'过去为诸历程皆守之最大关系；每一反链皆为一现在；于每一历程同处一现在即其后相同；于生时在，于某一历程即覆盖，于每一历程即唯一之覆盖，无需判定；'
              f'每一校准之判定皆确切；每一主律亦述于诸历程之上；Wüthrich 与 Callender 之关系于其四元及其外；经审查与复查；研究第 {N} 节。'}],
}

for rid in [x['id'] for x in record['dependencies']]:
    assert (RECORDS / f'{rid}.json').exists(), rid
path = RECORDS / f'{RID}.json'
assert not path.exists(), path
path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record:', RID, len(cited), 'declarations in', len(groups), 'laws')


def load(rid):
    return json.loads((RECORDS / f'{rid}.json').read_text(encoding='utf-8'))


def save(rid, d):
    (RECORDS / f'{rid}.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def history(d, en, zh):
    d['history'].append({'en': f'{DATE_EN}, board item UE14 (study section {N}): {en}',
                         'zh': f'{DATE_ZH}，工作板条目 UE14（研究第 {N} 节）：{zh}'})


# precedence and its links, and what can be born next: related to the present
RELATED = {
    RIDP: {'en': 'The present on causal-set growth: a condition is present at the birth of what it conditions on some '
                 'course exactly where it is a link below it (precedence weakly decided), and on every course exactly '
                 'where that is the one element it is linked to.',
           'zh': '因果集生长上之现在：缘于其果之生时在现在，于某一历程恰当其为覆盖（先后弱可判定），于每一历程恰当其为唯一之覆盖。'},
    RIDG: {'en': 'The present on causal-set growth: the natural labellings of a causal set are exactly the orders of '
                 'birth of the courses from the empty set growing a configuration of its kind.',
           'zh': '因果集生长上之现在：一因果集之自然编号，恰为自空集起生同种构型之诸历程之生序。'}}
for rid, detail in RELATED.items():
    d = load(rid)
    assert RID not in [x['id'] for x in d['related']]
    d['related'].append({'id': RID, 'detail': detail})
    history(d, f'related to {RID}; no statement, next step or declaration changed.',
            f'与 {RID} 相关联；无一陈述、下一步或声明改变。')
    save(rid, d)
print('records related here:', RIDP, RIDG)
