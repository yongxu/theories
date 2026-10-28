#!/usr/bin/env python3
"""UE15 record: write reorderings-as-courses-of-growth (Becoming.ReorderingGrowth, homed at 01 §9.6 after the order
of exchanges as the invariant), each declaration of the module cited once; relate the-present-on-causal-set-growth
and order-of-exchanges-is-the-invariant to it, each with a related entry and a history note; neither's statement,
next step or declarations change. Asserts the receipt's hash and empty axiom reports for the module, and the style
caps and lint (tools/research/style.py) on every field written. Mirrors UE14's make_records_ue14.py; no landed module
changes, so no record is re-pointed for Lean.
usage (from the checkout root, after texts_ue15.py): python3 -B make_records_ue15.py RECEIPT N
       python3 -B make_records_ue15.py --caps  (the caps, lint and the declaration cover against the kit's scratch
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
RECEIPT_ID, N = ('20261028T000000.000000Z', 433) if CAPS_ONLY else (sys.argv[1], int(sys.argv[2]))
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RF + 'BECOMING-RENEWAL-READING.md'
KITD = RF + 'development/ue15-reorderings-as-growth/'
NOTE, REVIEW = KITD + 'NOTE.md', KITD + 'REVIEW-UE15.md'
CH1 = 'theories/becoming/chapters/01-ROOT.md'
LEAN = {m: f'{PKG}/Becoming/{m}.lean' for m in
        ('ReorderingGrowth', 'Presence', 'CausalGrowth', 'OrderNormal', 'Reordering', 'Decidedness')}
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
RID = 'reorderings-as-courses-of-growth'
RIDP = 'the-present-on-causal-set-growth'
RIDO = 'order-of-exchanges-is-the-invariant'
RIDN = 'normal-forms-need-decided-apartness'
RIDX = 'exchanges-commute-unless-joined'
RIDL = 'precedence-and-its-links'
RIDG = 'what-can-be-born-next'
RIDD = 'counts-exist-where-decided'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
TODAY = datetime.date.today()
DATE_EN, DATE_ZH = f'{TODAY.day} {TODAY:%B} {TODAY.year}', f'{TODAY.year}年{TODAY.month}月{TODAY.day}日'
COUNT = 76
M = 'Becoming.ReorderingGrowth'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def capped(field, pair, item=False):
    caps = style.ITEM_CAPS_V2 if item else style.CAPS_V2
    en, zh = caps[field][:2]
    assert len(pair['en']) <= en and len(pair['zh']) <= zh, (field, len(pair['en']), en, len(pair['zh']), zh, pair['en'][:60])
    return pair


if CAPS_ONLY:
    audit = (HERE.parent / 'tree/.build/BecomingReorderingGrowthAxiomAudit.lean').read_text(encoding='utf-8')
    names = set(re.findall(r'^#print axioms (\S+)$', audit, re.M))
else:
    core = json.loads((ROOT / RECEIPT).read_text())
    assert core['status'] == 'passed'
    assert core['source_sha256'][M] == sha(LEAN['ReorderingGrowth']), M
    mod = next(x for x in core['modules'] if x['module'] == M)
    assert not any(mod['axiom_dependencies'].values()), M
    names = {d['name'] for d in mod['declarations']}
assert len(names) == COUNT, len(names)


def C(*short):
    out = [f'{M}.' + s for s in short]
    missing = [n for n in out if n not in names]
    assert not missing, missing
    return out


groups = [
    ("The exchanges of a stretch form a causal set: the first m steps, the exchange across i preceding that across j "
     "where both lie in the stretch and the order of joined exchanges relates them (exchanges, exchanges_ordered); a "
     "reordering of the stretch is a list of commutations within it, each of two exchanges not joined (Reordering).",
     "一段之交换成因果集：前 m 步，i 之交换先于 j 之交换，当二者皆在段内且相接交换之序联之（exchanges、exchanges_ordered）；"
     "段之重排为段内互换之列，每次互换二不相接之交换（Reordering）。",
     C('exchanges', 'exchanges_ordered', 'Reordering')),
    ("Its natural labellings are the renumberings of the stretch keeping the order of joined exchanges, with no "
     "hypothesis on the footprint: increasing along each joined pair, the earlier first, a renumbering increases along "
     "every chain of them (keeps_precedes, natural_iff).",
     "其自然编号即守相接交换之序之段重编号，足迹无需假设：沿每一相接之对（先者在前）递增之重编号，沿其每一链递增（keeps_precedes、natural_iff）。",
     C('keeps_precedes', 'natural_iff')),
    ("The numberings a world's reorderings give a stretch are the orders of birth of the courses of growth of its "
     "order of exchanges: with the footprint containing the exchanges, a renumbering is a reordering's numbering "
     "exactly where it is a natural labelling, and exactly where a course of growth from the empty set relabels the "
     "exchanges onto its configuration at the stretch's size (reordering_iff_course).",
     "世界之重排给一段之编号，即其交换之序之生长历程之生序：足迹含诸交换时，段之重编号为某重排之编号，恰当其为自然编号，"
     "亦恰当某一自空集起之因果集生长历程将诸交换重编于其段长处之构型（reordering_iff_course）。",
     C('reordering_iff_course')),
    ("Each reordering is a natural labelling and each natural labelling a reordering's, so what is read on the stretch "
     "holds on every natural labelling, or on some, exactly where it holds on every reordering, or on some; where every "
     "two consecutive exchanges are joined, the only reordering is the world as it is (reordering_natural and four "
     "more).",
     "每一重排皆为自然编号，每一自然编号皆为某重排之编号；故段上所读者，于每一（某一）自然编号成立，恰当于每一（某一）重排成立"
     "；相邻二交换皆相接时，唯一之重排即世界本身（reordering_natural 等五律）。",
     C('reordering_natural', 'natural_reordering', 'every_reordering_iff', 'some_reordering_iff', 'reordering_nil')),
    ("A world whose footprint contains its exchanges, taking the stretch's exchanges in the order of a course of growth, "
     "with the same footprints and changes and the same start, agrees over the stretch with a reordering "
     "(course_converse, by Footprinted.converse).",
     "足迹含其交换之世界，依某一生长历程之序取段之交换、足迹与变化相同、起点相同，于段上与某重排相合（course_converse，依 Footprinted.converse）。",
     C('course_converse')),
    ("The last link: an exchange precedes a later one exactly where it is joined to it, or precedes an exchange between "
     "them joined to it (last_of_precedes, precedes_iff_last).",
     "末链：一交换先于后者，恰当其与之相接，或先于二者之间与之相接之交换（last_of_precedes、precedes_iff_last）。",
     C('last_of_precedes', 'precedes_iff_last')),
    ("Joining decided on the stretch decides the order of exchanges on it, by search over the steps between, and "
     "joining weakly decided weakly decides it; precedence weakly decided on the stretch weakly decides that of its "
     "causal set (precedes_decided, precedes_weakly and their steps, exchanges_weakly).",
     "段上相接可判定，则段上交换之序可判定，依于其间诸步之搜索；相接弱可判定则序弱可判定；段上先后弱可判定，则其因果集之先后弱可判定"
     "（precedes_decided、precedes_weakly 及其步、exchanges_weakly）。",
     C('precedes_decided_below', 'precedes_decided', 'precedes_weakly_below', 'precedes_weakly', 'exchanges_weakly')),
    ("Below an exchange of the stretch, the links of its causal set are the links of the order of exchanges "
     "(links_exchanges).",
     "段内一交换之下，其因果集之覆盖即交换之序之覆盖（links_exchanges）。",
     C('links_exchanges')),
    ("Which of two exchanges a numbering takes first, its present at a stage and presence when an exchange is taken "
     "are read on the stretch (before_stretch, maximalBorn_stretch, presentAt_stretch).",
     "一编号先取二交换之何者、其某阶段之现在、一交换被取时之在，皆读于段上（before_stretch、maximalBorn_stretch、presentAt_stretch）。",
     C('before_stretch', 'maximalBorn_stretch', 'presentAt_stretch')),
    ("Taken before on every reordering: with no decision, exactly where the precedence is not refuted; with the pair's "
     "precedence decided, exactly where it holds (Szpilrajn read on the World), and so with joining decided on the "
     "stretch (every_reordering_not_not, precedes_iff_every_reordering, precedes_iff_every_reordering_of_joined).",
     "于每一重排皆先取：无判定时，恰当其先后不可否证；该对之先后可判定时，恰当其成立（Szpilrajn 读于世界），段上相接可判定时亦然"
     "（every_reordering_not_not、precedes_iff_every_reordering、precedes_iff_every_reordering_of_joined）。",
     C('every_reordering_not_not', 'precedes_iff_every_reordering', 'precedes_iff_every_reordering_of_joined')),
    ("Taken before on some reordering: with precedence weakly decided on the stretch, exactly where the two differ and "
     "the other does not precede the one, so two different unrelated exchanges are taken in either order "
     "(before_some_reordering, either_order_reordering).",
     "于某一重排先取：段上先后弱可判定时，恰当二者相异且他者不先于此者；故二相异而无先后之交换二序皆可取（before_some_reordering、"
     "either_order_reordering）。",
     C('before_some_reordering', 'either_order_reordering')),
    ("The present of any numbering at a stage is an antichain of the order of exchanges; with precedence weakly "
     "decided, every antichain given by a test is the present of some reordering, and two exchanges are present "
     "together on some reordering exactly where unrelated; with no decision, on every reordering exactly where, doubly "
     "negated, they precede the same exchanges of the stretch (present_unrelated and three more).",
     "任一编号某阶段之现在为交换之序之反链；先后弱可判定时，以检验给出之每一反链为某重排之现在，二交换于某一重排同处现在恰当其无先后；"
     "无判定时，于每一重排同处现在恰当其先于段内同一诸交换不可否证（present_unrelated 等四律）。",
     C('present_unrelated', 'antichain_present_reordering', 'together_some_reordering',
       'together_every_reordering_not_not')),
    ("An exchange is present when another is taken on some reordering exactly where it is a link below it in the order "
     "of exchanges (precedence weakly decided), and on every reordering exactly where it is a link below it and a link "
     "below no other exchange of the stretch (no decision) (present_some_reordering, present_every_reordering).",
     "一交换于另一交换被取时在：于某一重排，恰当其于交换之序中为其下之覆盖（先后弱可判定）；于每一重排，恰当其为其下之覆盖且不为段内他交换之覆盖"
     "（无需判定）（present_some_reordering、present_every_reordering）。",
     C('present_some_reordering', 'present_every_reordering')),
    ("Presence on the world as it is is precedence with no exchange between joined to the earlier one; so, with the "
     "footprint containing the exchanges, an exchange present when another is taken leaves every relatum it touched "
     "shown then as right after its own step, on the world and on every reordering where it is present "
     "(present_identity_iff, persists_of_present and three more).",
     "世界本身之在，即先后且其间无交换与先者相接；故足迹含诸交换时，一交换于另一交换被取时在，则其所触之每一关系项于彼时之显如其本步之后；"
     "于世界本身与其在之每一重排皆然（first_of_precedes、present_identity_iff、sameAt_of_unmoved、persists_of_present 及其重排之形）。",
     C('first_of_precedes', 'present_identity_iff', 'sameAt_of_unmoved', 'persists_of_present',
       'persists_of_present_reordering')),
    ("Not conversely, through a dependence: in a world of three exchanges with an empty flow, whose middle exchange "
     "touches nothing the first touches and is joined to it through a dependence, what the first touched persists to "
     "the last step, yet on no reordering is the first present then (ByDependence and its laws).",
     "反之不然，经依赖：三交换之世界，流为空，其中间交换不触首交换所触者，而经依赖与之相接；首交换所触者持存至末步，而于任何重排首交换彼时皆不在"
     "（ByDependence 及其律）。",
     C('ByDependence.standing', 'ByDependence.web', 'ByDependence.dependent', 'ByDependence.touch',
       'ByDependence.world', 'ByDependence.contains', 'ByDependence.joined_first_middle',
       'ByDependence.joined_first_last', 'ByDependence.joined_middle_last', 'ByDependence.persists_not_present',
       'ByDependence.only_reordering')),
    ("Not conversely, with no dependence and the least footprint: in a world of four exchanges each touching only the "
     "relatum 0, which rises, rises, falls back and rises, the footprint touches only what moves, every two exchanges "
     "are joined, and what the first touched persists to the last step, yet the first is present then on no reordering "
     "(MovedBack and its laws).",
     "反之不然，无依赖且足迹最小：四交换之世界，各唯触关系项 0，其升、升、回落、升；足迹唯触所动者，任二交换相接；首交换所触者持存至末步，"
     "而于任何重排首交换彼时皆不在（MovedBack 及其律）。",
     C('MovedBack.standing', 'MovedBack.web', 'MovedBack.touch', 'MovedBack.world', 'MovedBack.contains',
       'MovedBack.touches_moved', 'MovedBack.joined', 'MovedBack.persists_not_present', 'MovedBack.only_reordering')),
    ("The vee as a world: one exchange changing two relata, then one changing each; its order of exchanges is the vee "
     "of the present on causal-set growth, commuting the later two is a reordering, and the first is present when the "
     "last is taken on that reordering and not on the world as it is, the two numberings being by one course "
     "(VeeWorld and its laws).",
     "作为世界之叉：一交换改二关系项，继之各改其一者；其交换之序即因果集生长上之现在之叉，互换后二者为一重排，首交换于末交换被取时，"
     "于该重排在，于世界本身不在，二编号同属一历程（VeeWorld 及其律）。",
     C('VeeWorld.standing', 'VeeWorld.web', 'VeeWorld.touch', 'VeeWorld.world', 'VeeWorld.contains',
       'VeeWorld.joined_first_second', 'VeeWorld.joined_first_third', 'VeeWorld.apart', 'VeeWorld.not_second_third',
       'VeeWorld.vee_of_precedes', 'VeeWorld.prec_iff_vee', 'VeeWorld.natural_iff_vee', 'VeeWorld.reordering',
       'VeeWorld.presence_varies', 'VeeWorld.swap_below', 'VeeWorld.vee_swap', 'VeeWorld.one_course_two_numberings')),
]
cited = [d for _, _, ds in groups for d in ds]
assert len(cited) == len(set(cited)) == COUNT, (len(cited), len(set(cited)))
assert set(cited) == names, sorted(names - set(cited))

laws = [capped('laws', {'en': en, 'zh': zh, 'declarations': ds}, item=True) for en, zh, ds in groups]
assert len(laws) <= style.ITEM_CAPS_V2['laws'][2]

validation = capped('validation_scope', {
    'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): all {COUNT} declarations of '
          f'{M}, each with an empty axiom report. Drafted by an AI agent and read in the session; an independent '
          f'read-only review by another AI agent (REVIEW-UE15) and a re-check, study section {N}; not reviewed by a '
          f'person. Most laws compose landed theorems.',
    'zh': f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：{M} 之全部 {COUNT} 项声明，公理报告皆空。由一 AI 代理起草，会话中审读；'
          f'另一 AI 代理作独立只读审查（REVIEW-UE15）并复查，见研究第 {N} 节；未经人审。多数律组合已落地之定理。'})

title = capped('title', {'en': "A world's reorderings as courses of growth", 'zh': '世界之重排作为生长之历程'})
statement = capped('statement', {
    'en': "With a footprint containing the exchanges, the numberings a world's reorderings give its first m steps are "
          "exactly the orders of birth of the courses of growth of its order of exchanges, so the laws of presence on "
          "that growth hold on the World; presence gives persistence, not conversely.",
    'zh': '足迹含诸交换时，世界之重排给其前 m 步之编号，恰为其交换之序之生长历程之生序，故该生长上之在之诸律于世界成立；在给出持存，反之不然。'})
hypotheses = [capped('hypotheses', x, item=True) for x in (
    {'en': "No axiom. The causal set of a stretch, its natural labellings, the last link, the decisions, presence on "
           "the world as it is, the present as an antichain and the witnesses take no hypothesis on the footprint; the "
           "representation, the laws on reorderings and persistence take the footprint containing the exchanges "
           "(Footprinted.Contains).",
     'zh': '不加公理。段之因果集、其自然编号、末链、诸判定、世界本身之在、现在为反链与诸例，于足迹无需假设；表示、诸重排上之律与持存需足迹含诸交换'
           '（Footprinted.Contains）。'},
    {'en': "Decisions are Prop-valued (the core's Decided and WeaklyDecided): joining decided or weakly decided for the "
           "pairs of the stretch gives precedence so decided; the laws on some reordering and on antichains take "
           "precedence weakly decided on the stretch; the law on every reordering takes the pair's precedence decided "
           "or none.",
     'zh': '判定取命题值（核心之 Decided、WeaklyDecided）：段内诸对之相接可判定或弱可判定，给出先后之同等判定；于某一重排与反链之律需段上先后弱可判定；'
           '于每一重排之律需该对先后可判定，或无需判定。'},
    {'en': "Modelling choices: the stretch is the first m steps; the footprint is given, decided relatum by relatum, "
           "may touch a relatum it does not move, and the order of exchanges is relative to it; presence is read as "
           "the present on causal-set growth reads it; antichains are given by a Boolean test; the witnesses' flows "
           "are empty; pointwise, with no function extensionality.",
     'zh': '建模之选：段为前 m 步；足迹给定，逐关系项可判定，可触其不动之关系项，交换之序相对于之；在之读法同因果集生长上之现在；反链以布尔检验给出；诸例之流为空；'
           '皆逐点，不用函数外延性。'})]
does_not_show = [capped('does_not_show', x, item=True) for x in (
    {'en': "Anything about processes without a footprint, continuous time, infinite stretches, stretches from another "
           "step, or the present of a center.",
     'zh': '关于无足迹之过程、连续时间、无穷之段、自他步起之段或一中心之现在之任何事。', 'kind': 'scope'},
    {'en': "The laws of the present on causal-set growth that take a Decidable instance of the whole precedence, on the "
           "World; three of their forms with no decision are instanced, and past_every_iff has none.",
     'zh': '因果集生长上之现在中需整体先后之 Decidable 实例之律，于世界之形；其无需判定之形三者已实例化，past_every_iff 无此形。',
     'kind': 'non-implication'},
    {'en': "The World's representation theorem of the one-unfolding plan: this is one aspect of it, the interleavings.",
     'zh': '一体展开计划中世界之表示定理：此为其一面，即交错。', 'kind': 'non-implication'},
    {'en': "That the World gives the footprint: it is supplied, and the order of exchanges is relative to it.",
     'zh': '足迹由世界给出：其为所给，交换之序相对于之。', 'kind': 'non-implication'},
    {'en': "Which presence or which reordering is better.",
     'zh': '何种在或何重排更好。', 'kind': 'non-implication'})]
next_delta = capped('next_delta', {
    'en': "Presence on processes without a footprint; stretches from any step and infinite ones; the present of a "
          "center; review by a person.",
    'zh': '无足迹之过程上之在；自任一步起之段与无穷之段；一中心之现在；人之审查。'})
correspondence = capped('correspondence', {
    'en': "Trace theory: the linear extensions of a trace's dependence order are exactly its interleavings "
          "(Mazurkiewicz 1977; Diekert and Rozenberg 1995), here the World's own form of it (Footprinted.sorts_iff, "
          "landed), and the prefixes of a trace correspond to the down-sets of its dependence order, the "
          "configurations of its event structure (Nielsen, Plotkin and Winskel 1981). Szpilrajn's extension theorem in "
          "Dushnik and Miller's intersection form (1930, 1941) gives the law on every reordering. Causal set theory "
          "reads the natural labellings as the paths of sequential growth (Rideout and Sorkin 2000); the composition "
          "follows at once from these two facts, and a light search found no paper connecting traces with causal-set "
          "growth. Presence giving persistence is an elementary consequence of a footprint containing the exchanges. "
          "Graded in UE15's NOTE.",
    'zh': '迹论：迹之依赖序之线性扩张恰为其交错（Mazurkiewicz 1977；Diekert、Rozenberg 1995），此处为世界自身之形（Footprinted.sorts_iff，已落地）；'
          '迹之前缀对应于其依赖序之下集，即其事件结构之构型（Nielsen、Plotkin、Winskel 1981）。Szpilrajn 扩张定理之 Dushnik 与 Miller 交之形（1930、1941）'
          '给出于每一重排之律。因果集理论读自然编号为序贯生长之路径（Rideout、Sorkin 2000）；组合由此二事立得，粗略搜索未见连迹论与因果集生长之文。在则持存为足迹含诸交换之浅显推论。'
          '分级见 UE15 之 NOTE。'})
counterexamples = [
    {'en': 'In a world of three exchanges whose middle exchange is joined to the first only through a dependence, what '
           'the first touched persists to the last step, yet on no reordering is the first present when the last is '
           'taken (ByDependence.persists_not_present).',
     'zh': '三交换之世界，其中间交换唯经依赖与首交换相接：首交换所触者持存至末步，而于任何重排首交换于末交换被取时皆不在'
           '（ByDependence.persists_not_present）。'},
    {'en': 'In a world of four exchanges on one relatum, moved and moved back, with no dependence and the least '
           'footprint, what the first touched persists to the last step, yet the first is present then on no '
           'reordering (MovedBack.persists_not_present).',
     'zh': '四交换于一关系项之世界，动而复回，无依赖且足迹最小：首交换所触者持存至末步，而于任何重排首交换彼时皆不在（MovedBack.persists_not_present）。'},
    {'en': 'On the vee as a world the first exchange is present when the last is taken on one reordering and not on the '
           'world as it is, the two numberings being by one course (VeeWorld.presence_varies, '
           'VeeWorld.one_course_two_numberings).',
     'zh': '于作为世界之叉，首交换于末交换被取时，于一重排在，于世界本身不在，二编号同属一历程（VeeWorld.presence_varies、'
           'VeeWorld.one_course_two_numberings）。'}]


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
             for m in ('Presence', 'CausalGrowth', 'OrderNormal', 'Reordering', 'Decidedness')]
common_refs = [{'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
               {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
               {'path': NOTE, 'role': 'integration', 'sha256': sha(NOTE)},
               {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)}]
binding = [{'source': LEAN['ReorderingGrowth'], 'receipt': RECEIPT,
            'sha256_pointer': f'/source_sha256/{M}',
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
    'counterexamples': [{'path': LEAN['ReorderingGrowth'], 'detail': x} for x in counterexamples],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'formal-not-empirical', 'names-provisional',
                            'omission-not-refutation'],
    'validation_scope': validation,
    'next_delta': next_delta,
    'correspondence': correspondence,
    'canonical_source': LEAN['ReorderingGrowth'],
    'aliases': ["A world's reorderings as courses of growth", '世界之重排作为生长之历程',
                'interleavings as causal-set growth', 'presence on the World', 'presence gives persistence',
                f'{M}.reordering_iff_course', f'{M}.persists_of_present', f'{M}.present_every_reordering',
                f'{M}.present_identity_iff'],
    'dependencies': [
        {'id': RIDO, 'relation': 'formal-reuse',
         'detail': {'en': 'Footprinted, Contains, Joined, Precedes, Keeps, sorts, sorts_iff, converse, reorder_shows, '
                          'precedes_place, place_origin, Web.SameAt and Web.Unmoved: the World\'s order of exchanges '
                          'and its reorderings.',
                    'zh': 'Footprinted、Contains、Joined、Precedes、Keeps、sorts、sorts_iff、converse、reorder_shows、precedes_place、'
                          'place_origin、Web.SameAt 与 Web.Unmoved：世界之交换之序及其重排。'}},
        {'id': RIDN, 'relation': 'formal-reuse',
         'detail': {'en': 'reindexes_of_within and Footprinted.reorder_determined: a reordering renumbers its stretch, '
                          'and reorderings giving one numbering agree over it.',
                    'zh': 'reindexes_of_within 与 Footprinted.reorder_determined：一重排重编其段，给同一编号之诸重排于段上相合。'}},
        {'id': RIDX, 'relation': 'formal-reuse',
         'detail': {'en': 'Web.Dependent and swapAt: activity needing support, met by the witness, and the exchange of '
                          'two neighbours; Witnesses.emptyFlow, the empty flow, is cited by no record.',
                    'zh': 'Web.Dependent 与 swapAt：活动需支持（例中满足之），及二邻之互换；空流 Witnesses.emptyFlow 无记录引之。'}},
        {'id': RIDP, 'relation': 'formal-reuse',
         'detail': {'en': 'NaturalLabelling, natural_iff_course, natural_congr, courseOf, MaximalBorn, PresentAt, the '
                          'laws on every and some course and Vee.vee: the present on causal-set growth.',
                    'zh': 'NaturalLabelling、natural_iff_course、natural_congr、MaximalBorn、PresentAt 及于每一与某一历程之律：'
                          '因果集生长上之现在。'}},
        {'id': RIDL, 'relation': 'formal-reuse',
         'detail': {'en': 'Causet and links: causal sets and their links.', 'zh': 'Causet 与 links：因果集与其覆盖。'}},
        {'id': RIDG, 'relation': 'formal-reuse',
         'detail': {'en': 'process, empty and Kinds.Relabels: the growth and relabelling.',
                    'zh': 'process、empty 与 Kinds.Relabels：生长与重编号。'}},
        {'id': RIDD, 'relation': 'formal-reuse',
         'detail': {'en': 'Decided, Decided.of_not_not and Decided.exists_below: deciding, and searching below a bound.',
                    'zh': 'Decided、Decided.of_not_not 与 Decided.exists_below：判定，及于界下搜索。'}}],
    'related': [],
    'references': [{'path': LEAN['ReorderingGrowth'], 'role': 'proof', 'declarations': sorted(cited),
                    'sha256': sha(LEAN['ReorderingGrowth'])}] + lean_refs + common_refs
                  + [{'path': CH1, 'role': 'statement', 'sha256': sha(CH1)}],
    'proof_bindings': binding,
    'history': [{
        'en': f'{DATE_EN}: added (UE15), a world\'s reorderings as courses of growth: the exchanges of a stretch a '
              f'causal set under the order of joined exchanges, its natural labellings the renumberings keeping it, so '
              f'with the footprint containing the exchanges the reorderings the courses of causal-set growth; the laws '
              f'of presence on the reorderings by instance, each with its decision; presence on the world as it is '
              f'precedence with nothing between joined to the earlier exchange, giving persistence of what it touched, '
              f'not conversely, through a dependence or by moving and moving back; the vee as a world; after a review '
              f'and a re-check; study section {N}.',
        'zh': f'{DATE_ZH}：新增（UE15），世界之重排作为生长之历程：一段之交换在相接交换之序下成因果集，其自然编号即守此序之重编号，故足迹含诸交换时，'
              f'诸重排即因果集生长之历程；在之诸律依实例成立于诸重排，各带其判定；世界本身之在即先后且其间无交换与先者相接，给出所触者之持存，反之不然，'
              f'经依赖或动而复回；作为世界之叉；经审查与复查；研究第 {N} 节。'}],
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
    d['history'].append({'en': f'{DATE_EN}, board item UE15 (study section {N}): {en}',
                         'zh': f'{DATE_ZH}，工作板条目 UE15（研究第 {N} 节）：{zh}'})


RELATED = {
    RIDP: {'en': "A world's reorderings as courses of growth: with a footprint containing the exchanges, the laws of "
                 "presence on causal-set growth hold on a world's reorderings of its first m steps by instance.",
           'zh': '世界之重排作为生长之历程：足迹含诸交换时，因果集生长上之在之诸律依实例成立于世界前 m 步之诸重排。'},
    RIDO: {'en': "A world's reorderings as courses of growth: the renumberings keeping the order of joined exchanges "
                 "are the natural labellings of the stretch's causal set, so the orders of birth of causal-set growth.",
           'zh': '世界之重排作为生长之历程：守相接交换之序之重编号，即段之因果集之自然编号，故即因果集生长之生序。'}}
for rid, detail in RELATED.items():
    d = load(rid)
    assert RID not in [x['id'] for x in d['related']]
    d['related'].append({'id': RID, 'detail': detail})
    history(d, f'related to {RID}; no statement, next step or declaration changed.',
            f'与 {RID} 相关联；无一陈述、下一步或声明改变。')
    save(rid, d)
print('records related here:', RIDP, RIDO)
