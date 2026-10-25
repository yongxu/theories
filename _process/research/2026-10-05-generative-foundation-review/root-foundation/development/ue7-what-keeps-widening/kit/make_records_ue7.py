#!/usr/bin/env python3
"""UE7 records: write what-keeping-widening-needs (every declaration of Becoming.KeepingWidening, with Population's
length_le_count); extend support-passed-on (the uniform form), support-from-the-supported (the one first step) and
returning-novelty-forgetting-on-levels (the list form), each with a law of its own for the general laws below their
landed laws (board rule 9) and a history note; mark eventual-widening's first carrier form superseded, with a history
note. Asserts the receipt's hashes and empty axiom reports for the five modules, and the style caps (tools/research/
style.py) on every field written. The extended records' Lean references keep their old hashes: repoint_ue7.py re-points
them and rebinds their proof bindings to the landing's receipt. Mirrors UE4's make_records_ue4.py.
usage (from the checkout root, after texts_ue7.py): python3 -B make_records_ue7.py RECEIPT N"""
import datetime
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
sys.path.insert(0, str(ROOT))
from tools.research import style  # noqa: E402

RECEIPT_ID, N = sys.argv[1], int(sys.argv[2])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RF + 'BECOMING-RENEWAL-READING.md'
KITD = RF + 'development/ue7-what-keeps-widening/'
NOTE, DESIGN, REVIEW = KITD + 'NOTE.md', KITD + 'DESIGN.md', KITD + 'REVIEW-UE7.md'
CH7 = 'theories/becoming/chapters/07-SIGNIFICANCE.md'
LEAN = {m: f'{PKG}/Becoming/{m}.lean' for m in
        ('KeepingWidening', 'Population', 'Novelty', 'Gain', 'Admission', 'EventualWidening',
         'EventualWideningInstances', 'MapInstances', 'Thresholds', 'ContinuedClasses')}
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
RID = 'what-keeping-widening-needs'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
DATE_EN, DATE_ZH = '26 October 2026', '2026年10月26日'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def capped(field, pair, item=False):
    caps = style.ITEM_CAPS_V2 if item else style.CAPS_V2
    en, zh = caps[field][:2]
    assert len(pair['en']) <= en and len(pair['zh']) <= zh, (field, len(pair['en']), en, len(pair['zh']), zh, pair['en'][:60])
    return pair


core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
names_of = {}
for m in ('KeepingWidening', 'Population', 'Novelty', 'Gain', 'Admission'):
    module = f'Becoming.{m}'
    assert core['source_sha256'][module] == sha(LEAN[m]), module
    mod = next(x for x in core['modules'] if x['module'] == module)
    assert not any(mod['axiom_dependencies'].values()), module
    names_of[m] = {d['name'] for d in mod['declarations']}
NEW_BELOW = {'Population': ['Becoming.length_le_count'],
             'Novelty': ['Becoming.Web.exceeds_of_distinct_configs', 'Becoming.Web.unbounded_of_distinct_configs',
                         'Becoming.Web.distinct_configs_of_apart'],
             'Admission': ['Becoming.Flow.gain_given_by_supported_at', 'Becoming.Flow.gain_given_by_recent_gainer_at',
                           'Becoming.Flow.gain_given_by_recent_gainer']}
for m, ds in NEW_BELOW.items():
    assert set(ds) <= names_of[m], (m, set(ds) - names_of[m])
names = names_of['KeepingWidening'] | {'Becoming.length_le_count'}


def D(*short):
    out = ['Becoming.' + s for s in short]
    missing = [n for n in out if n not in names]
    assert not missing, missing
    return out


groups = [
    ("The gain bridge. A course keeping widening by name on the actual levels from T, every formation supported from "
     "T on requiring at one need only members of a list cs, lists for every n some n steps from T with pairwise "
     "distinct configurations of cs. By Novelty's list form the stock of cs exceeds every bound, and rises, at "
     "arbitrarily late steps, deciding only the order of numbers at finitely many steps. A restatement.",
     "增益之桥。自 T 起于实有水平上按名持续扩大、自 T 起每一受支撑构成只需列表 cs 之成员（需求为一）的进程，对每一 n 列出自 T 起的 n 步，"
     "cs 于其上构型两两不同。故依 Novelty 的列表形式，cs 之存量于任意晚的步上超出一切界并上升。只于有限多列出之步上判定数之大小。重述。",
     D('Web.KeepsWidening.distinct_configs', 'Web.KeepsWidening.passes_every_bound', 'Web.KeepsWidening.rises_late')),
    ("Fed from beyond. Under the first law, cs without repetition, at arbitrarily late steps the rest gives cs net or "
     "cs is not closed; with balance on cs from a step as well, it is not closed at arbitrarily late steps. A finite, "
     "closed world balanced on all its conditions under the first law has no course keeping widening by name with what "
     "its formations require so fixed. A restatement.",
     "由外而喂。第一律下、cs 无重复时，于任意晚的步上其余部分净给予 cs，或 cs 不闭合；若自某步起亦在 cs 上平衡，则于任意晚的步上不闭合。"
     "第一律下于全部条件上平衡的有限闭合世界，没有其构成所需如此固定而按名持续扩大的进程。重述。",
     D('Web.KeepsWidening.from_rest_or_open', 'Web.KeepsWidening.open_late', 'Flow.whole_not_keepsWidening')),
    ("Takers multiply. Under upkeep, every formation supported from T on taking part and taking at least a unit a step "
     "from cs, a course keeping widening by name has more takers of cs without end. They are counted from below: a "
     "list without repetition, each member in another list with a positive quantity, is no longer than the count of "
     "that list's entries with a positive quantity, with no decision of equality.",
     "取用者增多。有维持时（自 T 起每一受支撑构成皆参与，且每步自 cs 至少取一单位），按名持续扩大的进程，其取 cs 者无尽增多。自下计之："
     "无重复的列表，若其每一成员皆在另一列表中且量为正，则其长不超过该列表量为正之条目数，不判定相等。",
     D('Flow.TakesWhileSupported', 'length_le_count', 'Web.KeepsWidening.more')),
    ("Renewers multiply. With cs balanced on from a step, a course keeping widening by name under upkeep has its "
     "replenishment bounded from no step on; with each entry giving cs at most g a step, so are its renewers. Takers "
     "and renewers count entries of the present list, with repetition, so they count formations only where the list "
     "repeats none. A restatement.",
     "更新者增多。自某步起在 cs 上平衡时，有维持而按名持续扩大的进程，其补给自无一步起有界；若每一条目每步给予 cs 至多 g，其更新者亦然。"
     "取用者与更新者计当前列表之条目，含重复，故唯列表无重复处方计构成。重述。",
     D('Web.KeepsWidening.replenishment_unbounded', 'Web.KeepsWidening.renewers_unbounded')),
    ("Opened by the opened within a recency bound, the form support passing on gives: gains of support recur, and "
     "every gain from step K on is given, up to double negation, on a rising condition the gainer requires, by a "
     "supported formation taking part that gained support within the K steps before. Gains before step K are exempt; "
     "within 0 holds of no flow, nor within any bound where nothing is supported from some step on.",
     "在一近期界内由已开者所开，即支撑之传递所给的形式：支撑之获得复现，且自第 K 步起每一获得，皆在双重否定下，于获得者所需且上升之条件上，"
     "由一参与的受支撑构成给予，该构成于此前 K 步内获得支撑。第 K 步之前的获得豁免；界为 0 时无流成立，自某步起无一受支撑处亦于任何界不成立。",
     D('Flow.OpenedByOpenedWithin', 'Flow.not_within_zero', 'Flow.OpenedByOpenedWithin.not_of_unsupported')),
    ("Its laws: brief supports give it; it is monotone in the bound; it gives the lagged form of a fixed origin; UE4's "
     "form at every origin gives it with bound one. With support decided, and what the gainer requires listed and "
     "decided, the giver and its step are found, no omniscience principle entering. Near-definitional.",
     "其律：支撑短暂即给出之；它对界单调；它给出固定起点的滞后形式；UE4 之形式于每一起点皆成立时给出界为一之此形式。支撑可判定、"
     "获得者所需被列出且可判定时，给予者及其步可被找到，不入任何全知原则。近乎定义。",
     D('Flow.openedByOpenedWithin_of_brief', 'Flow.OpenedByOpenedWithin.succ', 'Flow.OpenedByOpenedWithin.add',
       'Flow.OpenedByOpenedWithin.mono', 'Flow.OpenedByOpenedWithin.lagged', 'Flow.openedByOpenedWithin_of_opened',
       'Flow.gain_given_by_recent_gainer_decided')),
    ("The map reads keeping. Read the web through what levels admit: nothing admitted is lost along a continuation "
     "from T exactly where the admitted pattern's line from every admitted occurrence never ends (不穷); by name, "
     "nothing lost gives 全守, and nothing is 全生成. Near-definitional.",
     "图谱读保持。经水平所纳读网：沿一延续自 T 起所纳无失，恰是所纳模式自每一被纳之出现起之线不穷；按名，无失给出全守，且无一全生成。近乎定义。",
     D('Web.admitting', 'Web.Linked.steps_le', 'Web.Linked.same_of_at', 'Web.Linked.one_step', 'Web.linked_of_reached',
       'Web.includesAcrossFrom_iff_endless', 'Web.kept_of_includes_by_name')),
    ("The map reads carrying. Along carrying on or passing support, a carrying renewal (传) from a supported occurrence "
     "is exactly a passing of support, every gain of support is one up to double negation, and each successor comes "
     "with its case. Where no formation is supported at K + 1 consecutive steps, every supported endless line is "
     "全生成, and 全生成 is 生成 on the grammar. It answers part of 02's open item.",
     "图谱读承载。沿“延续或传递支撑”，自受支撑之出现起的承载之更新（传）恰为支撑之传递，每一支撑之获得在双重否定下皆是，每一后继皆带其情形。"
     "无一构成连续 K + 1 步受支撑之处，每一受支撑之不穷之线皆全生成，且于文法上全生成即生成。部分回答 02 之未决项。",
     D('Flow.PassesSupport', 'Flow.passesSupport_carries_iff', 'Flow.gain_carried', 'Flow.passes_or_carried_on',
       'Flow.generation_of_brief', 'Flow.generation_of_includes_brief', '«全生成则生成»')),
    ("Under the World premises, whatever is supported at a step is, up to double negation, linked along carrying on "
     "or passing support to something supported at any earlier step. So along every continuation containing it the "
     "levels exceed from no step to a later one, and nothing keeps opening or keeps widening there: on both readings "
     "used, 全生成 and keeping widening do not hold together. Near-definitional.",
     "在世界前提下，任一步上受支撑者，在双重否定下，沿“延续或传递支撑”与任一更早步上受支撑者相连。故沿包含它的每一延续，水平从无一步到更晚之步"
     "超出，彼处无一持续开出或持续扩大：于所用两种读法上，全生成与持续扩大不并立。近乎定义。",
     D('Web.Linked.snoc', 'Flow.descends_along_passings', 'Flow.not_exceedsAcross_along_passings',
       'Flow.not_keepsOpening_along_passings', 'Flow.not_keepsWidening_along_passings')),
    ("Witnesses on a ladder, formations climbing one condition, each new one needing a unit more: under the first law "
     "they meet the gain bridge's premises together, the family open at every step; under upkeep they meet those of "
     "renewers multiplying together, the renewers bounded from no step on. Dropping upkeep, capacity or balance, a flow "
     "with at most one renewer a step keeps widening by name.",
     "梯之见证（攀一条件的诸构成，每一新者多需一单位）：第一律下它们共同满足增益之桥的前提，该族每步皆开放；有维持时共同满足更新者增多的前提，"
     "更新者自无一步起有界。去掉维持、容量或平衡，每步至多一更新者的流按名持续扩大。",
     D('Ladder.atZero', 'Ladder.atZero_pos', 'Ladder.same', 'Ladder.same_self', 'Ladder.unusedAt', 'Ladder.unused_step',
       'Ladder.levelAt', 'Ladder.requiresOf', 'Ladder.needOf', 'Ladder.activeAt', 'Ladder.web', 'Ladder.supported_some',
       'Ladder.supported_none', 'Ladder.keeps_widening', 'Ladder.requiresWithin', 'Ladder.frontier',
       'Ladder.frontier_balances', 'Ladder.frontier_gainless', 'Ladder.frontier_open', 'Ladder.frontier_witness',
       'Ladder.stock_unbounded', 'Ladder.takingPart', 'Ladder.upkeepTake', 'Ladder.upkeepGive', 'Ladder.upkept',
       'Ladder.shift_balance', 'Ladder.upkept_balances', 'Ladder.upkept_takes', 'Ladder.upkept_capacity',
       'Ladder.upkept_gainless', 'Ladder.upkept_witness', 'Ladder.frontier_capacity', 'Ladder.frontier_renewers',
       'Ladder.upkeep_needed', 'Ladder.oneGive', 'Ladder.oneRenewer', 'Ladder.oneRenewer_balances',
       'Ladder.oneRenewer_renewers', 'Ladder.capacity_needed', 'Ladder.unbalanced', 'Ladder.balance_needed')),
    ("Witnesses on UE4's closed cycle: it keeps opening by name with stock one throughout, closed and never given from "
     "beyond, its renewers bounded, so both multiplying laws need nothing lost. It is opened by the opened within one, "
     "its supports brief, and along carrying on or passing support it is 全生成, hence 生成, at every supported "
     "occurrence while its levels exceed from no step to a later one: the exclusion's instance.",
     "UE4 闭环之见证：它按名持续开出，存量始终为一，闭合且从未自外受给，其更新者有界，故两条增多之律皆需无失。其支撑短暂，在界一内由已开者所开；"
     "沿“延续或传递支撑”，它于每一受支撑之出现皆全生成，故生成，而其水平从无一步到更晚之步超出：排除律之实例。",
     D('ClosedCycle.mark_sum', 'ClosedCycle.gainless', 'ClosedCycle.keeps_opening_by_name', 'ClosedCycle.requiresWithin',
       'ClosedCycle.stock_one', 'ClosedCycle.closed', 'ClosedCycle.distinct', 'ClosedCycle.bounded_while_opening',
       'ClosedCycle.takes_while_supported', 'ClosedCycle.capacity', 'ClosedCycle.renewers_le',
       'ClosedCycle.renewers_bounded_while_opening', 'ClosedCycle.brief', 'ClosedCycle.unloosened',
       'ClosedCycle.opened_within', 'ClosedCycle.cycle_within', 'ClosedCycle.passesSupport_next',
       'ClosedCycle.linked_along_passings', 'ClosedCycle.linked_along_passings_to',
       'ClosedCycle.includes_along_passings', 'ClosedCycle.not_opening_along',
       'ClosedCycle.generation_without_widening', 'ClosedCycle.generates')),
    ("Witnesses on UE4's opening chain: the rising course keeps widening by name with no finite family's stock passing "
     "its length, so a finite family is needed. The relay is opened by the opened within one and the single giver "
     "within no bound, the supports of both lasting: brevity is sufficient and not necessary, and needed for the single "
     "giver.",
     "UE4 开出之链之见证：上升进程按名持续扩大，而无一有限族之存量超过其长，故需有限族。接力在界一内由已开者所开，单一给予者于任何界皆否，"
     "二者支撑皆持久：短暂充分而非必要，对单一给予者则必需。",
     D('OpeningChain.keeps_widening', 'OpeningChain.stock_le', 'OpeningChain.fixed_but_unbounded',
       'OpeningChain.relay_within', 'OpeningChain.lasting', 'OpeningChain.oneGiver_not_within',
       'OpeningChain.carriers_within', 'OpeningChain.unloosened', 'OpeningChain.gains_recur',
       'OpeningChain.brevity_needed')),
    ("Witnesses that the two carrier forms are independent at a single origin: the lagged relay is opened by the opened "
     "within two and in UE4's form at no origin; the late single giver, formation 0 at step 0 and formation 1 after, "
     "is opened by the opened in UE4's form at origin 0 and within no bound. A change of class, not a relaxation.",
     "两种承载形式在单一起点上彼此独立之见证：滞后接力在界二内由已开者所开，而于任一起点皆不合 UE4 之形式；迟来的单一给予者（第 0 步为构成 0，"
     "此后为构成 1）于起点 0 合 UE4 之形式，而于任何界皆否。是类之改变，不是放宽。",
     D('OpeningChain.lagging', 'OpeningChain.laggedRelay', 'OpeningChain.laggedRelay_balances',
       'OpeningChain.laggedRelay_acting', 'OpeningChain.laggedRelay_within', 'OpeningChain.laggedRelay_not_opened',
       'OpeningChain.within_not_fixed_origin', 'OpeningChain.lateGiving', 'OpeningChain.lateGiving_succ',
       'OpeningChain.lateGiver', 'OpeningChain.lateGiver_balances', 'OpeningChain.lateGiver_acting',
       'OpeningChain.lateGiver_opened', 'OpeningChain.lateGiver_not_within', 'OpeningChain.forms_independent')),
    ("Witnesses on UE4's saturated and own-condition webs: with every support lasting, every line never ends and keeps "
     "and none is 全生成, so the map law needs brevity; the still flow is opened by the opened within no bound, and "
     "ranking by the recency form reverses widening as ranking by UE4's did; by name the rising course is kept and not "
     "全生成; on the own-condition web no flow is opened by the opened within any bound.",
     "UE4 饱和之网与自身条件之网之见证：每一支撑皆持久时，每一线皆不穷且保持，无一全生成，故图谱律需短暂；静止之流于任何界皆不由已开者所开，"
     "按近期形式排序逆转扩大，如按 UE4 之形式；按名上升进程得保持而不全生成；自身条件之网上无流于任何界由已开者所开。",
     D('Saturated.supported', 'Saturated.no_carry', 'Saturated.endless', 'Saturated.lasting_kept',
       'Saturated.still_not_within', 'Saturated.reverses_within', 'OwnCondition.rung_le_one', 'OwnCondition.rising_kept',
       'OwnCondition.not_within')),
    ("Witnesses that fixed needs and the first law are needed: on a loosening web, needs falling toward one, a course "
     "keeps widening by name with stock one throughout; with a source giving from nothing, a finite balanced world keeps "
     "widening by name, its family closed and never given from beyond, so without the first law the finite-world law "
     "fails.",
     "固定需求与第一律皆必需之见证：于放松之网上（需求降向一），一进程按名持续扩大而存量始终为一；有自无而给的源时，有限而平衡的世界按名持续扩大，"
     "其族闭合且从未自外受给，故无第一律则有限世界之律不成立。",
     D('Loosening.strict', 'Loosening.strict_le_one_iff', 'Loosening.web', 'Loosening.supported_iff',
       'Loosening.keeps_widening', 'Loosening.bounded_while_widening', 'Source.web', 'Source.flow',
       'Source.supported_iff', 'Source.balances', 'Source.keeps_widening', 'Source.every', 'Source.distinct',
       'Source.requiresWithin', 'Source.closed', 'Source.not_gainless', 'Source.from_nothing')),
]
cited = [n for _, _, ds in groups for n in ds]
assert len(cited) == len(set(cited))
assert set(cited) == names, (sorted(names - set(cited)), sorted(set(cited) - names))

kw_decls = sorted(names_of['KeepingWidening'])
record = {
    'schema_version': 2,
    'id': RID,
    'title': capped('title', {'en': 'What keeping widening needs, and what carries it', 'zh': '持续扩大需要什么，以及承载它者'}),
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F07',
    'reviewed_at_utc': NOW,
    'statement': capped('statement', {
        'en': "A course keeping widening by name with fixed finite requirements needs unbounded stock, fed from beyond; under upkeep, renewers multiply; support passing on makes opened by the opened a recency bound; under the World premises nothing keeps opening along passing of support. None compares two courses.",
        'zh': '按名持续扩大、需求有限而固定的进程超出一切界并由外而喂；有维持时其更新者增多；支撑之传递把由已开者所开定为近期之界；在世界前提下沿支撑之传递无一持续开出。无一比较两个进程。'}),
    'laws': [capped('laws', {'en': en, 'zh': zh, 'declarations': ds}, item=True) for en, zh, ds in groups],
    'hypotheses': [capped('hypotheses', x, item=True) for x in (
        {'en': "No axiom. Each law states its premises: the first law (nothing comes from nothing), balance on the family "
               "from a step, upkeep, bounded giving per entry, brief supports, or the World premises (balance, only active "
               "formations giving, activity needing support, requirements never loosening).",
         'zh': '不加公理。每一律陈其前提：第一律（无不自无生）、自某步起在族上平衡、维持、每条目给予有界、支撑短暂，或世界前提（平衡、只有活跃者给予、'
               '活跃需支撑、需求永不放松）。'},
        {'en': "Modelling choices: discrete steps; natural-number amounts, on which passing every bound depends (in a dense "
               "order needs approaching a limit could support ever more formations at a bounded stock; argued, not proved "
               "in Lean); admission by name over a fixed type of formations; takers and renewers as entries of the present "
               "list.",
         'zh': '建模之选：离散之步；自然数之量，超出一切界依赖于此（于稠密之序中，趋近一极限的需求可在有界存量下支撑越来越多的构成；此为论证，'
               '未在 Lean 中证明）；在固定的构成类型上按名而纳；取用者与更新者为当前列表之条目。'})],
    'does_not_show': [capped('does_not_show', x, item=True) for x in (
        {'en': "A comparison of two courses: no law here compares two, so the second-order direction of 生生 stays open "
               "and eventual widening's lag stays undecided.",
         'zh': '两个进程之比较：此处无一律比较两者，故生生的二阶方向仍未定，最终扩大之滞后仍未决。', 'kind': 'scope'},
        {'en': "That 02's open item is answered: on both readings used 全生成 and keeping widening do not hold together, "
               "and 生成 is read on the World only where 全生成 gives it.",
         'zh': '02 之未决项已答：于所用两种读法上全生成与持续扩大不并立，且生成只于全生成给出之处在世界上被读。', 'kind': 'non-implication'},
        {'en': 'A third part against the TAP equation, assembly theory or Jones 1995: each leaves conservation or upkeep '
               'out as stated, and its own variants or neighbours supply it.',
         'zh': '对 TAP 方程、组装理论或 Jones 1995 的第三部分：各者所述皆略去守恒或维持，而其自身之变体或近邻补之。', 'kind': 'correspondence'},
        {'en': 'That the first carrier form was merely too strict: at a single origin the two forms are independent.',
         'zh': '承载之初形只是过严：在单一起点上两种形式彼此独立。', 'kind': 'non-implication'},
        {'en': 'That renewers count formations where the present list repeats one; growth by kinds not given in advance; '
               'which actual courses meet the premises.',
         'zh': '当前列表有重复时更新者即计构成；非预先给定之种类的增长；哪些实有进程满足这些前提。', 'kind': 'scope'})],
    'counterexamples': [
        {'path': LEAN['KeepingWidening'], 'detail': {
            'en': 'A closed cycle keeps opening by name with stock one throughout and is 全生成 with no widening '
                  '(ClosedCycle.bounded_while_opening, ClosedCycle.generation_without_widening).',
            'zh': '闭环按名持续开出而存量始终为一，且全生成而无扩大（ClosedCycle.bounded_while_opening、ClosedCycle.generation_without_widening）。'}},
        {'path': LEAN['KeepingWidening'], 'detail': {
            'en': 'With a source giving from nothing, a finite balanced world keeps widening by name, closed '
                  '(Source.from_nothing); on a loosening web a course keeps widening with stock one '
                  '(Loosening.bounded_while_widening).',
            'zh': '有自无而给的源时，有限而平衡的世界按名持续扩大且闭合（Source.from_nothing）；于放松之网上一进程以存量一持续扩大'
                  '（Loosening.bounded_while_widening）。'}},
        {'path': LEAN['KeepingWidening'], 'detail': {
            'en': 'A late single giver is opened by the opened in the first form and within no recency bound; a lagged '
                  'relay within two and in the first form at no origin (OpeningChain.forms_independent).',
            'zh': '迟来的单一给予者合初形，而于任何近期界皆否；滞后接力于界二内合，而于任一起点皆不合初形（OpeningChain.forms_independent）。'}}],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical',
                            'names-provisional', 'omission-not-refutation'],
    'validation_scope': capped('validation_scope', {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): Becoming.KeepingWidening, '
              f'{len(kw_decls)} declarations, and Population\'s length_le_count, every one with an empty axiom report, all '
              f'cited here; every theorem of Population, Novelty, Gain and Admission prints its old statement. Built in one '
              f'session; an independent read-only review by a separate AI agent (REVIEW-UE7), its findings taken but one, '
              f'in study section {N}; not reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：Becoming.KeepingWidening 之 {len(kw_decls)} 项声明与 Population 之 '
              f'length_le_count，公理报告皆空，本记录全引；Population、Novelty、Gain 与 Admission 之每一定理所印陈述不变。于一会话中构建；'
              f'另一 AI 代理作独立只读审查（REVIEW-UE7），其所见除一项外皆采，见研究第 {N} 节；未经人审。'}),
    'next_delta': capped('next_delta', {
        'en': 'A comparison of two courses on admitted ranges (UE9); growth by kinds not given in advance; a reading on '
              'which 全生成 and keeping widening hold together; review by a person.',
        'zh': '在所纳范围上对两个进程之比较（UE9）；非预先给定之种类的增长；全生成与持续扩大可并立的读法；人之审查。'}),
    'correspondence': capped('correspondence', {
        'en': "Open systems (Prigogine; Schrödinger) and finite recurrence; open-ended evolution measured against an "
              "isolated system's recurrence (Bedau and others 2000; Adams and others 2017); the TAP equation (Cortês and "
              "others), whose logistic variant limits innovation, and assembly theory (Sharma and others 2023), which "
              "notes mass constraints, so the gain bridge is the conservation they leave out as stated; autocatalytic "
              "sets, food-generated (Hordijk and Steel 2012; Vasas and others 2012); maintenance and depreciation, "
              "break-even investment (Solow 1956) and the maintenance coefficient (Pirt 1965), which semi-endogenous "
              "growth (Jones 1995) leaves out as stated; demography with a maximal lifespan for the uniform form; "
              "biogenesis for the exclusion. Graded in development/ue7-what-keeps-widening/NOTE.md and REVIEW-UE7.md; "
              "the readings are the AI's.",
        'zh': '开放系统（Prigogine；Schrödinger）与有限回复；以孤立系统之回复衡量的开放式演化（Bedau 等 2000；Adams 等 2017）；TAP 方程'
              '（Cortês 等），其逻辑斯谛变体限制创新，与组装理论（Sharma 等 2023），其注意到质量约束，故增益之桥即其所述略去之守恒；自催化集，'
              '由食物生成（Hordijk 与 Steel 2012；Vasas 等 2012）；维持与折旧，收支平衡之投资（Solow 1956）与维持系数（Pirt 1965），'
              '半内生增长（Jones 1995）所述略去之；一致形式对应有最大寿命的人口学；排除律对应生源说。分级见 '
              'development/ue7-what-keeps-widening/NOTE.md 与 REVIEW-UE7.md；读法皆 AI 之读。'}),
    'canonical_source': LEAN['KeepingWidening'],
    'aliases': ['What keeping widening needs, and what carries it', '持续扩大需要什么，以及承载它者', 'the gain bridge',
                'renewers multiply', 'opened by the opened within a recency bound', 'the exclusion along passing of support',
                'Becoming.Flow.OpenedByOpenedWithin', 'Becoming.Web.KeepsWidening.passes_every_bound'],
    'dependencies': [
        {'id': 'eventual-widening', 'relation': 'formal-reuse',
         'detail': {'en': 'Web.KeepsWidening, Web.KeepsOpening, Web.IncludesAcrossFrom, Web.KeepsWidening.gathers; '
                          'Flow.OpenedByOpened and the webs of OwnCondition, OpeningChain, Saturated and ClosedCycle.',
                    'zh': 'Web.KeepsWidening、Web.KeepsOpening、Web.IncludesAcrossFrom、Web.KeepsWidening.gathers；'
                          'Flow.OpenedByOpened 以及 OwnCondition、OpeningChain、Saturated 与 ClosedCycle 之网。'}},
        {'id': 'returning-novelty-forgetting-on-levels', 'relation': 'formal-reuse',
         'detail': {'en': 'Web.unbounded_of_distinct_configs and upto_or_fails, from which passes_every_bound and the '
                          'decided form follow.',
                    'zh': 'Web.unbounded_of_distinct_configs 与 upto_or_fails，passes_every_bound 与可判定形式由之推出。'}},
        {'id': 'where-novelty-gain-comes-from', 'relation': 'formal-reuse',
         'detail': {'en': 'Flow.newly_supported_from_rest_or_open and Flow.whole_recurs_of_rest_idle: fed by the rest or '
                          'open, and the finite whole.',
                    'zh': 'Flow.newly_supported_from_rest_or_open 与 Flow.whole_recurs_of_rest_idle：由其余部分喂或开放，以及有限之整体。'}},
        {'id': 'more-needs-renewers', 'relation': 'formal-reuse',
         'detail': {'en': 'Flow.More, Flow.Capacity, Flow.More.replenishment_unbounded_from and '
                          'Flow.More.renewers_unbounded_from.',
                    'zh': 'Flow.More、Flow.Capacity、Flow.More.replenishment_unbounded_from 与 Flow.More.renewers_unbounded_from。'}},
        {'id': 'support-passed-on', 'relation': 'formal-reuse',
         'detail': {'en': 'Flow.gain_given_by_recent_gainer and comes_within_not_not, the uniform law the recency form '
                          'reads.',
                    'zh': 'Flow.gain_given_by_recent_gainer 与 comes_within_not_not，即近期形式所读的一致律。'}},
        {'id': 'support-from-the-supported', 'relation': 'formal-reuse',
         'detail': {'en': 'Flow.gain_given_by_supported_at, Web.GainsSupport and Web.Supported: every gain carried.',
                    'zh': 'Flow.gain_given_by_supported_at、Web.GainsSupport 与 Web.Supported：每一获得皆被承载。'}},
        {'id': 'a-pattern-lasts-through-passing', 'relation': 'formal-reuse',
         'detail': {'en': 'Web.passingContinuation and Web.begins_within, beside which the map law is stated.',
                    'zh': 'Web.passingContinuation 与 Web.begins_within，图谱律陈于其旁。'}},
        {'id': 'generation-and-degeneration-at-two-grains', 'relation': 'formal-reuse',
         'detail': {'en': "Web.carries_iff, Web.itself_not_generation and the map's 不穷, 全守 and 全生成 on webs.",
                    'zh': 'Web.carries_iff、Web.itself_not_generation，以及图谱于网上之不穷、全守与全生成。'}},
        {'id': 'classes-along-a-continuation', 'relation': 'formal-reuse',
         'detail': {'en': 'Web.Linked and Web.itself.', 'zh': 'Web.Linked 与 Web.itself。'}},
        {'id': 'widening-along-a-reading', 'relation': 'formal-reuse',
         'detail': {'en': 'Web.IncludesAcross, Web.ExceedsAcross and ExceedsAcross.anti.',
                    'zh': 'Web.IncludesAcross、Web.ExceedsAcross 与 ExceedsAcross.anti。'}},
        {'id': 'loops-within-what-a-law-reads', 'relation': 'formal-reuse',
         'detail': {'en': 'Thresholds.le_of_not_not.', 'zh': 'Thresholds.le_of_not_not。'}}],
    'related': [
        {'id': 'eventual-widening',
         'detail': {'en': 'Its first carrier form is superseded by the recency form here; its witnesses are restated for it.',
                    'zh': '其承载之初形为此处的近期形式所取代；其见证为之重述。'}}],
    'references': [{'path': LEAN['KeepingWidening'], 'role': 'proof', 'declarations': kw_decls,
                    'sha256': sha(LEAN['KeepingWidening'])},
                   {'path': LEAN['Population'], 'role': 'proof', 'declarations': ['Becoming.length_le_count'],
                    'sha256': sha(LEAN['Population'])}]
                  + [{'path': LEAN[m], 'role': 'proof', 'sha256': sha(LEAN[m])}
                     for m in ('Novelty', 'Gain', 'Admission', 'EventualWidening', 'EventualWideningInstances',
                               'MapInstances', 'Thresholds', 'ContinuedClasses')]
                  + [{'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                     {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                     {'path': NOTE, 'role': 'integration', 'sha256': sha(NOTE)},
                     {'path': DESIGN, 'role': 'integration', 'sha256': sha(DESIGN)},
                     {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
                     {'path': CH7, 'role': 'statement', 'sha256': sha(CH7)}],
    'proof_bindings': [{'source': LEAN[m], 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{m}',
                        'success_pointer': '/status', 'success_value': 'passed'} for m in ('KeepingWidening', 'Population')],
    'history': [{'en': f'{DATE_EN}: added (UE7), what keeping widening needs and what carries it: the gain bridge and '
                       f'renewers multiplying, restatements; the recency form of opened by the opened, the map law and the '
                       f'exclusion along passing of support, near-definitional; none compares two courses; study section {N}.',
                 'zh': f'{DATE_ZH}：新增（UE7），持续扩大需要什么以及承载它者：增益之桥与更新者增多，皆为重述；由已开者所开之近期形式、图谱律与沿'
                       f'支撑之传递的排除律，近乎定义；无一比较两个进程；研究第 {N} 节。'}],
}
deps = [x['id'] for x in record['dependencies']] + [x['id'] for x in record['related']]
for rid in deps:
    assert (RECORDS / f'{rid}.json').exists(), rid
path = RECORDS / f'{RID}.json'
assert not path.exists()
path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record:', RID, len(names), 'declarations in', len(groups), 'laws')


# the extended records: general laws below the landed ones (board rule 9), each with a history note
def load(rid):
    return json.loads((RECORDS / f'{rid}.json').read_text(encoding='utf-8'))


def save(rid, d):
    (RECORDS / f'{rid}.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def add_declarations(d, module, ds):
    """List the declarations under the module's reference; its hash is left for repoint_ue7.py, which re-points it
    after the signature audit and rebinds the proof binding to the landing's receipt."""
    ref = [r for r in d['references'] if r['path'] == LEAN[module]]
    assert len(ref) == 1, (d['id'], module)
    assert not set(ds) & set(ref[0].get('declarations', [])), (d['id'], ds)
    ref[0]['declarations'] = ref[0].get('declarations', []) + list(ds)


def history(d, en, zh):
    d['history'].append({'en': f'{DATE_EN}, board item UE7 (study section {N}): {en}',
                         'zh': f'{DATE_ZH}，工作板条目 UE7（研究第 {N} 节）：{zh}'})


def validation(d, en, zh):
    d['validation_scope'] = capped('validation_scope', {'en': d['validation_scope']['en'].rstrip() + ' ' + en,
                                                        'zh': d['validation_scope']['zh'].rstrip() + zh})


CHECKED_EN = f'checked at receipt {RECEIPT_ID} and reviewed with UE7 (AI).'
CHECKED_ZH = f'于回执 {RECEIPT_ID} 实查，随 UE7 受 AI 审查。'

# support passed on: the uniform form
d = load('support-passed-on')
ds = ['Becoming.Flow.gain_given_by_recent_gainer_at', 'Becoming.Flow.gain_given_by_recent_gainer']
d['laws'].append(capped('laws', {
    'en': 'The uniform form: with balance at the conditions the gainer requires, those giving to them supported, '
          'requirements not loosening and no support lasting K + 1 steps, a gain across the step from S + K is, up to '
          'double negation, given on a rising required condition by a supported formation taking part that gained '
          'support within the K steps before; under the World premises at every step. The law above follows from it.',
    'zh': '一致形式：在获得者所需之诸条件上平衡、给予它们者受支撑、需求不放松、且无支撑持续 K + 1 步时，跨自 S + K 之步的获得，在双重否定下，'
          '于所需且上升之条件上，由一参与的受支撑构成给予，该构成于此前 K 步内获得支撑；于世界前提下每步皆然。上一律由之推出。',
    'declarations': ds}, item=True))
add_declarations(d, 'Admission', ds)
d['statement'] = capped('statement', {
    'en': 'Under balance, active giving, activity needing support, unloosened requirements and support spells of at most '
          'K + 1 steps, every gain of support is, up to double negation, given by a formation that gained support within '
          'the K steps before; so support gained ever later comes from ever later gainers.',
    'zh': '在平衡、只有活跃者给予、活跃需支撑、需求不放松、受支撑至多连续 K + 1 步时，每一支撑之获得在双重否定下皆由于此前 K 步内获得支撑之构成给予；'
          '故越来越晚所得之支撑来自越来越晚的获得者。'})
d['related'].append({'id': RID, 'detail': {
    'en': 'The recency form of opened by the opened reads the uniform form; with support decided, its decided form finds '
          'the giver and its step.',
    'zh': '由已开者所开之近期形式读此一致形式；支撑可判定时，其可判定形式找到给予者及其步。'}})
validation(d, 'The uniform form was ' + CHECKED_EN, '一致形式' + CHECKED_ZH)
history(d, 'the uniform form added as a second law (Flow.gain_given_by_recent_gainer_at, Flow.gain_given_by_recent_gainer) '
           'and the statement restated with it; support_passes_on is re-proved from it, its statement unchanged (board '
           f'rule 9); related to {RID}.',
        f'一致形式作为第二律加入（Flow.gain_given_by_recent_gainer_at、Flow.gain_given_by_recent_gainer），陈述随之重述；support_passes_on '
        f'由之重证，陈述不变（工作板规则 9）；与 {RID} 相关。')
save('support-passed-on', d)

# support from the supported: the one first step, a law of its own
d = load('support-from-the-supported')
assert any('Becoming.Flow.gains_from_supported_at' in x['declarations'] for x in d['laws'])
d['laws'].append(capped('laws', {
    'en': 'One first step for the local gaining law: with balance at the conditions the gainer requires and those giving '
          'to them supported, a formation whose requirements do not loosen across a step and that gains support there is '
          'given, up to double negation, on a rising required condition by a supported formation taking part. The local '
          'gaining law follows from it.',
    'zh': '局部获得之律的第一步：在获得者所需之诸条件上平衡、给予它们者受支撑时，跨一步需求不放松且于彼获得支撑之构成，在双重否定下，'
          '于所需且上升之条件上，由一参与的受支撑构成给予。局部获得之律由之推出。',
    'declarations': ['Becoming.Flow.gain_given_by_supported_at']}, item=True))
add_declarations(d, 'Admission', ['Becoming.Flow.gain_given_by_supported_at'])
validation(d, 'The first step was ' + CHECKED_EN, '第一步' + CHECKED_ZH)
history(d, 'a law added, the local gaining law\'s one first step (Flow.gain_given_by_supported_at), from which '
           'gains_from_supported_at is re-proved, its statement unchanged (board rule 9).',
        '加入一律，即局部获得之律的第一步（Flow.gain_given_by_supported_at），gains_from_supported_at 由之重证，陈述不变（工作板规则 9）。')
save('support-from-the-supported', d)

# returning, novelty, forgetting: the list form, a law of its own
d = load('returning-novelty-forgetting-on-levels')
assert any('Becoming.Web.exceeds_of_new' in x['declarations'] for x in d['laws'])
ds = NEW_BELOW['Novelty']
d['laws'].append(capped('laws', {
    'en': 'The list form: at any listed steps, in any order, with pairwise distinct configurations, more of them than the '
          'configurations within a bound, the stock exceeds the bound at one; with such lists of every length from every '
          'step on, at arbitrarily late steps. Steps whose configurations differ pairwise give such a list. The laws on '
          'consecutive steps are its case.',
    'zh': '列表形式：于任意列出之诸步（顺序不论），构型两两不同、其数多于界内构型之数时，存量于其中一步超出界；自每一步起皆有任意长的此类列表时，'
          '于任意晚的步上超出。构型两两相异的诸步给出此类列表。连续之步上的诸律为其一例。',
    'declarations': ds}, item=True))
add_declarations(d, 'Novelty', ds)
validation(d, 'The list form was ' + CHECKED_EN, '列表形式' + CHECKED_ZH)
history(d, 'a law added, the list form (Web.exceeds_of_distinct_configs, Web.unbounded_of_distinct_configs, '
           'Web.distinct_configs_of_apart), from which exceeds_of_new and unbounded_of_new are re-proved, their '
           'statements unchanged (board rule 9).',
        '加入一律，即列表形式（Web.exceeds_of_distinct_configs、Web.unbounded_of_distinct_configs、Web.distinct_configs_of_apart），'
        'exceeds_of_new 与 unbounded_of_new 由之重证，陈述不变（工作板规则 9）。')
save('returning-novelty-forgetting-on-levels', d)

# eventual widening: its first carrier form superseded
d = load('eventual-widening')
law = [x for x in d['laws'] if 'Becoming.Flow.OpenedByOpened' in x['declarations']]
assert len(law) == 1
old_en, old_zh = law[0]['en'], law[0]['zh']
PRE_EN, TAIL_EN = 'What carries a widening, provisionally: ', (
    ' Provisional: its first law, the uniform form of support passing on, would reach the giver only up to double negation.')
assert old_en.startswith(PRE_EN) and old_en.endswith(TAIL_EN), old_en
law[0]['en'] = ('What carries a widening, in its first form: ' + old_en[len(PRE_EN):-len(TAIL_EN)]
                + f' Superseded by the recency form ({RID}): at one origin this form counts a late single giver.')
PRE_ZH = '承载扩大者（暂定）：'
cut = old_zh.find('暂定：其第一律')
assert old_zh.startswith(PRE_ZH) and cut > 0, old_zh
law[0]['zh'] = ('承载扩大者（初形）：' + old_zh[len(PRE_ZH):cut]
                + f'已为近期形式（{RID}）取代：在单一起点上此形式计入迟来的单一给予者。')
dns = [x for x in d['does_not_show'] if 'provisional until its first law fixes its form' in x['en']]
assert len(dns) == 1
dns[0].update(capped('does_not_show', {
    'en': 'Which actual courses meet any of these readings; and the first form of opened by the opened is superseded: '
          f'its first law fixed a recency form ({RID}).',
    'zh': f'哪些实有进程合于这些读法；由已开者所开之初形已被取代：其第一律定出近期形式（{RID}）。'}, item=True))
d['next_delta'] = capped('next_delta', {
    'en': f'A comparison of two courses that decides the lag (UE9); the gain bridge and the givers law are proved, as '
          f'restatements ({RID}); widening of what can be reached over branching courses; review by a person.',
    'zh': f'决定滞后的两进程之比较（UE9）；增益之桥与给予者之律已作为重述得证（{RID}）；对分支进程的可达之扩大；人之审查。'})
d['related'].append({'id': RID, 'detail': {
    'en': "What keeping widening needs: the gain bridge, renewers multiplying, the recency form of opened by the opened "
          "with this record's witnesses restated, the map law and the exclusion along passing of support.",
    'zh': '持续扩大需要什么：增益之桥、更新者增多、由已开者所开之近期形式（本记录之见证为之重述）、图谱律与沿支撑之传递的排除律。'}})
history(d, f"the carrier law's first form marked superseded by the recency form of {RID}, with the reason (a late single "
           'giver); the provisional does-not-show item and the next step updated; the definition and its witnesses are '
           'unchanged.',
        f'承载之律的初形标为被 {RID} 之近期形式所取代，并陈其理由（迟来的单一给予者）；暂定之不显示项与下一步随之更新；定义与其见证不变。')
save('eventual-widening', d)
print('records extended: support-passed-on, support-from-the-supported, returning-novelty-forgetting-on-levels; '
      'eventual-widening revised')
