"""GW3-GW5: the record changes, applied to the records in the worktree. Run from the repository root.

The validation scope, reviewed time, receipt bindings and the study section are set at landing,
once the core checker has run; this script writes the laws, statements, boundaries, references
and history. Each text is checked against RESULT-WORKFLOW's limits.
"""
import json, sys
from pathlib import Path

R = Path('theories/becoming/results/records')
KW = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/KeepingWidening.lean'
HP = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HeldPossible.lean'
MI = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/MapInstances.lean'
PP = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/PatternPassing.lean'
LIMITS = {'statement': (300, 150), 'laws': (420, 190), 'hypotheses': (420, 190),
          'does_not_show': (240, 110), 'next_delta': (400, 180)}
B = 'Becoming.'

FAILS = []

def check(field, text):
    en, zh = LIMITS[field]
    if len(text['en']) > en or len(text['zh']) > zh:
        FAILS.append((field, len(text['en']), en, len(text['zh']), zh, text['en'][:50]))
    return text

def law(en, zh, decls):
    return dict(check('laws', {'en': en, 'zh': zh}), declarations=[B + d for d in decls])

def add_refs(rec, path, decls):
    for ref in rec['references']:
        if ref['path'] == path and ref.get('role') == 'proof':
            have = set(ref['declarations'])
            ref['declarations'] = sorted(have | {B + d for d in decls})
            return
    rec['references'].append({'path': path, 'role': 'proof', 'declarations': sorted(B + d for d in decls)})

def load(name):
    return json.loads((R / f'{name}.json').read_text(encoding='utf-8'))

def save(name, rec):
    assert not FAILS, FAILS
    (R / f'{name}.json').write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

HISTORY_DATE = '29 October 2026, board item GW (study section 448)'

# ---- what-keeping-widening-needs -------------------------------------------------------------
w = load('what-keeping-widening-needs')
w['statement'] = check('statement', {
    'en': 'A course keeping widening by name with fixed finite requirements needs unbounded stock, fed from beyond; under upkeep, renewers multiply; passing support makes opened by the opened a recency bound; along a reading, keeping opening needs new beginnings, and 全生成 and keeping widening can hold together.',
    'zh': '按名持续扩大、需求有限而固定的进程超出一切界并由外而喂；有维持时其更新者增多；支撑之传递把由已开者所开定为近期之界；沿任一读法，持续开出需其新的起始；于一读法上全生成与持续扩大并立。'})
old_ix = next(i for i, l in enumerate(w['laws']) if B + 'Flow.descends_along_passings' in l['declarations'])
new_laws = [
    law('The law of beginnings. Under the World premises with requirements never loosening, along any continuation containing carrying on of the supported, what is supported at a step descends, up to double negation, from what was supported at any earlier step or from the end of a beginning between: a passing of support into a formation nothing supported continues into along it. Near-definitional.',
        '起始之律。世界前提下、需求永不放松时，沿任一包含受支撑者之延续的延续，一步上受支撑者在双重否定下，或出自任一更早步上受支撑者，或出自其间一起始之端：支撑传入一构成，而沿此延续无受支撑者延续入之。近乎定义。',
        ['Web.supportedItself', 'Web.supportedPassing', 'Web.supportedItself_within', 'Web.supportedPassing_within',
         'Flow.BeginsAlong', 'Flow.BeginsAlong.not_along', 'Flow.BeginsAlong.carries', 'Flow.BeginsAlong.iff_begins',
         'Web.Linked.snoc', 'Flow.descends_or_begun']),
    law('What keeping opening needs. A beginning is a carrying renewal along passing, and its end begins a line of the reading. Where the levels exceed along the reading a beginning lies between, linked to the formation that opens; so keeping opening needs a beginning after every step, by name a passing of support. Not conversely: on the kind relay with dormant carrying on, beginnings recur and nothing keeps opening.',
        '持续开出所需。起始是沿传递之承载之更新，其端于该读法起一线。水平沿读法超出处其间有一起始，连至所开之构成；故持续开出需每步之后皆有起始，按名即支撑之传递。反之不然：于种类接力之休眠读法上，起始复现而无一持续开出。',
        ['Flow.begun_of_exceedsAcross', 'Flow.begins_late_of_keepsOpening', 'Flow.beginsAlong_supportedItself_iff',
         'Flow.passes_late_of_keepsOpening_byName', 'KindRelay.Runs.begins_dormant',
         'KindRelay.Runs.beginnings_without_opening']),
    law('The ends of an interval of readings. Along carrying on while supported or passing support every passing is a step, so nothing begins: what is supported descends along it, and along every continuation containing it nothing keeps opening or widening; the law along carrying on or passing support and its three exclusions are its cases. Carrying on while supported, as by name, nothing is 全生成. Near-definitional.',
        '读法区间之两端。沿"受支撑而延续或传递支撑"，每一传递皆为一步，故无所起：受支撑者沿之而出，沿包含之的每一延续无一持续开出或扩大；沿"延续或传递支撑"之律及其三排除为其特例。受支撑而延续时，如按名，无一全生成。近乎定义。',
        ['Flow.descends_along_supportedPassing', 'Flow.descends_along_passings',
         'Flow.not_exceedsAcross_along_supportedPassing', 'Flow.not_keepsOpening_along_supportedPassing',
         'Flow.not_keepsWidening_along_supportedPassing', 'Flow.not_exceedsAcross_along_passings',
         'Flow.not_keepsOpening_along_passings', 'Flow.not_keepsWidening_along_passings',
         'Web.supportedPassing_cont_iff', 'Web.supportedItself_not_generation']),
    law('Within a kind. For a reflexive relation of kind, carrying on while supported or passing within a kind continues, from a supported occurrence, as passing does under the kind class; at an active occurrence a carrier begins along it exactly where it begins along passing; from a supported giver a beginning along it is a carrying renewal along passing at (activity, kind), a renewal one grain up.',
        '种类之内。对一自反之种类关系，"受支撑而延续或于种类内传递"自受支撑之出现起，如传递于种类之类下而延续；于活跃之出现上，载体沿之起恰如沿传递起；自受支撑之给予者，沿之之起始即沿传递于（活跃，种类）之承载之更新，高一粒度之更新。',
        ['Web.withinKind', 'Web.withinKind_within', 'Web.kindClass', 'Web.kindClass_within', 'Web.kindGrains',
         'Web.withinKind_cont_iff', 'Web.withinKind_begins_iff', 'Flow.BeginsAlong.carries_kind_iff']),
    law('Where what is required is dissipated on, neither. Where a list holds every condition any formation requires and the flow dissipates on it from a step, under the World premises nothing keeps opening or widening along a continuation containing carrying on of the supported, and with balance on the list alone nothing supported is 全生成 along one within carrying on or passing support: passings take from the list.',
        '所需被耗散处，二者皆无。一列表含任一构成所需之每一条件，且流自某步起于其上耗散时，世界前提下沿包含受支撑者之延续的延续无一持续开出或扩大；仅需于列表上平衡，沿含于"延续或传递支撑"之延续无受支撑者全生成：传递自列表取，而取终止。',
        ['Flow.PassesSupport.takes', 'Flow.not_keepsOpening_of_dissipated_requirements',
         'Flow.not_keepsWidening_of_dissipated_requirements', 'Flow.not_generation_of_dissipated_requirements']),
    law('Where supports last one step. Along every continuation and under every class finer than activity, every supported occurrence whose line never ends is 全生成 at (that class, one formation), since what arises begins a carrier along every continuation; a line always having a successor under such a class never ends. Near-definitional.',
        '支撑只持一步处。沿每一延续、于每一细于活跃之类下，其线不穷之每一受支撑出现皆于（该类，一构成）全生成，因所生者沿每一延续皆起一载体；于此类下恒有后继之线不穷。近乎定义。',
        ['Web.supported_along', 'Web.endless_of_successor', 'Web.generation_of_one_step_supports', 'Web.Linked.last']),
    law('Witness: both together. On the kind relay, six formations of two kinds passing units within and across kinds with period two, the kind chosen so that passings across kinds begin, the levels keep widening within kinds from step 0, every supported occurrence is 全生成 within kinds and at orders 0 and 1 along passing (one formation, kind, activity), and renewal without end holds at the kind grain.',
        '见证：二者并立。种类接力：两种类之六构成，单位于种类内外以周期二传递，种类之选使跨种类之传递为起始；水平自第 0 步起于种类内持续扩大，每一受支撑出现于种类内及沿传递于阶 0 与阶 1（一构成、种类、活跃）全生成，生生于种类粒度成立。',
        ['KindRelay.Form', 'KindRelay.memDecidable', 'KindRelay.allForms', 'KindRelay.every_form', 'KindRelay.distinct_forms', 'KindRelay.kind',
         'KindRelay.sameKind', 'KindRelay.sameKind_refl', 'KindRelay.amount', 'KindRelay.Holds', 'KindRelay.giveSupport',
         'KindRelay.giveAt', 'KindRelay.takeAt', 'KindRelay.presentAt', 'KindRelay.lineage', 'KindRelay.starter',
         'KindRelay.back', 'KindRelay.parity_two', 'KindRelay.odd_of_next_even', 'KindRelay.holds_brief',
         'KindRelay.present_holds', 'KindRelay.moves_facts', 'KindRelay.lineage_facts', 'KindRelay.starter_facts',
         'KindRelay.starter_fresh', 'KindRelay.back_facts', 'KindRelay.Runs', 'KindRelay.Runs.step',
         'KindRelay.Runs.along', 'KindRelay.Runs.brief', 'KindRelay.Runs.linked', 'KindRelay.Runs.includes',
         'KindRelay.Runs.not_into', 'KindRelay.Runs.exceeds', 'KindRelay.Runs.opens', 'KindRelay.Runs.keeps_widening',
         'KindRelay.Runs.generation', 'KindRelay.Runs.renews_even', 'KindRelay.Runs.generation_one_up',
         'KindRelay.Runs.generation_order_zero', 'KindRelay.Runs.generation_two_orders',
         'KindRelay.Runs.renews_without_end', 'KindRelay.web', 'KindRelay.flow', 'KindRelay.supported_iff',
         'KindRelay.passes_iff', 'KindRelay.runs', 'KindRelay.keeps_widening', 'KindRelay.generation',
         'KindRelay.generation_one_up', 'KindRelay.renews_without_end']),
    law('Witness: what it can form only returns. The closed relay balances, meets the World premises and only active formations taking, conserves and lists its conditions; by name, carrying on while supported, along supported passings and with dormant carrying on by name it keeps widening from no step, its supports lasting one step, and it returns with period two.',
        '见证：其所能成者只回返。闭合之接力平衡，满足世界前提与只活跃者取用，守恒并列出其条件；按名、受支撑而延续、沿受支撑之传递及按名休眠延续时，其自无一步起持续扩大（支撑只持一步），且以周期二回返。',
        ['KindRelay.balance_at', 'KindRelay.balances', 'KindRelay.acting', 'KindRelay.dependent',
         'KindRelay.unloosened', 'KindRelay.takes_own', 'KindRelay.taking', 'KindRelay.requiresWithin',
         'total_eq_of_supports', 'KindRelay.single_distinct', 'KindRelay.pair_distinct', 'KindRelay.give_support',
         'KindRelay.take_support', 'KindRelay.give_distinct', 'KindRelay.moves_taken', 'KindRelay.inside',
         'KindRelay.conserving', 'KindRelay.gainless', 'KindRelay.Runs.dormant_not_exceeds',
         'KindRelay.Runs.not_keepsOpening_dormant', 'KindRelay.Runs.some_supported',
         'KindRelay.Runs.not_includes_within_itself', 'KindRelay.Runs.not_keepsWidening_byName',
         'KindRelay.Runs.not_keepsWidening_supportedItself', 'KindRelay.not_keepsWidening_byName',
         'KindRelay.not_keepsWidening_byName_of_whole', 'KindRelay.not_keepsWidening_supportedPassing',
         'KindRelay.not_keepsWidening_dormant', 'KindRelay.returns']),
    law('Witness: dissipation paid beside the part. The fed relay adds fuel for each step, drawn on and taken a unit by each taker and required by none: it is dissipative and meets only active formations taking, the same laws hold, its required conditions conserve and no list holding them is dissipated on: dissipation as stated does not exclude the two.',
        '见证：耗散付于部分之旁。供给之接力为每步添燃料，每一取者引用并取一单位，无构成需之：它耗散、满足只活跃者取用，同律成立，无列表含其条件，其所需条件守恒；故所述之耗散不排除二者并立，只要所需者不被耗散。',
        ['KindRelay.Fed.fuelNeed', 'KindRelay.Fed.fuel_present', 'KindRelay.Fed.level', 'KindRelay.Fed.web',
         'KindRelay.Fed.take', 'KindRelay.Fed.give', 'KindRelay.Fed.flow', 'KindRelay.Fed.supported_iff',
         'KindRelay.Fed.passes_iff', 'KindRelay.Fed.runs', 'KindRelay.Fed.fuel_balance', 'KindRelay.Fed.balances',
         'KindRelay.Fed.acting', 'KindRelay.Fed.dependent', 'KindRelay.Fed.unloosened', 'KindRelay.Fed.taking',
         'KindRelay.Fed.give_support', 'KindRelay.Fed.take_support', 'KindRelay.Fed.map_distinct',
         'KindRelay.Fed.take_distinct', 'KindRelay.Fed.dissipative', 'KindRelay.Fed.gainless',
         'KindRelay.Fed.part_conserves', 'KindRelay.Fed.conserving_on_part', 'KindRelay.Fed.fuelBound',
         'KindRelay.Fed.lt_fuelBound', 'KindRelay.Fed.not_listed', 'KindRelay.Fed.requirements_not_dissipated',
         'KindRelay.Fed.not_keepsWidening_byName',
         'KindRelay.Fed.keeps_widening', 'KindRelay.Fed.generation', 'KindRelay.Fed.generation_one_up',
         'KindRelay.Fed.renews_without_end', 'KindRelay.Fed.not_keepsWidening_supportedPassing',
         'KindRelay.Fed.not_keepsWidening_dormant', 'KindRelay.Fed.returns']),
]
w['laws'] = w['laws'][:old_ix] + new_laws + w['laws'][old_ix + 1:]
w['hypotheses'][0] = check('hypotheses', {
    'en': 'No axiom. Each law states its premises: the first law (nothing comes from nothing), balance on the family from a step, upkeep, bounded giving per entry, brief supports, or three World premises (balance, only active formations giving, activity needing support) with requirements never loosening, which is not a World premise; the dissipation laws add a list holding every required condition, dissipated on from a step.',
    'zh': '不加公理。每一律陈其前提：第一律（无不自无生）、自某步起在族上平衡、维持、每条目给予有界、支撑短暂，或三条世界前提（平衡、只有活跃者给予、活跃需支撑）加上需求永不放松，后者非世界前提；耗散之律另需一列表含每一所需条件，且自某步起于其上耗散。'})
w['hypotheses'].append(check('hypotheses', {
    'en': 'The kind relay uses unit amounts, needs of one and kinds given in advance, the kind chosen with the witness so that its openings are the passings across kinds; its fed form has a condition of fuel for each step, an unlisted infinity of conditions, each holding at step 0 what its step uses.',
    'zh': '种类接力用单位之量、需求为一、预先给定之种类，种类随见证而选，使其开出即跨种类之传递；其供给之形每步有一燃料条件，为不列出之无穷条件，各于第 0 步持其步所用。'}))
dns = w['does_not_show']
ix = next(i for i, d in enumerate(dns) if d['en'].startswith("That 02's open item is answered"))
dns[ix] = dict(check('does_not_show', {
    'en': 'That renewal gives widening: on the kind relay 全生成 at two orders and renewal without end hold while what it can form by name only returns, and beginnings recur on a reading that opens nothing.',
    'zh': '更新给出扩大：于种类接力上，二阶之全生成与生生成立，而其按名所能成者只回返；起始复现于一无所开出之读法上。'}),
    kind='non-implication', witness=B + 'KindRelay.Runs.beginnings_without_opening')
dns.insert(ix + 1, dict(check('does_not_show', {
    'en': "That a part under dissipation is sustained by supply from beyond: the fed relay's required conditions conserve, its loss paid by fuel no formation requires.",
    'zh': '耗散下之部分由外之供给维持：供给之接力所需之条件守恒，其损失由无构成所需之燃料付之。'}),
    kind='non-implication', witness=B + 'KindRelay.Fed.conserving_on_part'))
assert len(dns) <= 8
w['next_delta'] = check('next_delta', {
    'en': 'Comparing two courses on admitted ranges and on what they keep reachable is done (comparing-two-courses-on-what-they-admit, what-a-course-keeps-reachable), what carries their openings remaining; growth by kinds not given in advance; which reading the widening order counts, beyond names; review by a person.',
    'zh': '在所纳范围上及就所保持可达者比较两个进程已成（comparing-two-courses-on-what-they-admit、what-a-course-keeps-reachable），承载其开出者仍待；非预先给定之种类的增长；扩大之序按何读法计（名之外）；人之审查。'})
w['counterexamples'].append({'path': KW, 'detail': {
    'en': 'On the kind relay the levels keep widening within kinds while every supported occurrence is 全生成 at orders 0 and 1, and by name, along supported passings and with dormant carrying on it keeps widening from no step (KindRelay.keeps_widening, KindRelay.Runs.generation_two_orders, KindRelay.not_keepsWidening_byName); with dormant carrying on beginnings recur and nothing opens (KindRelay.Runs.beginnings_without_opening).',
    'zh': '于种类接力上，水平于种类内持续扩大，每一受支撑出现于阶 0 与阶 1 全生成，而按名、沿受支撑之传递及休眠延续时其自无一步起持续扩大（KindRelay.keeps_widening、KindRelay.Runs.generation_two_orders、KindRelay.not_keepsWidening_byName）；休眠延续时起始复现而无所开出（KindRelay.Runs.beginnings_without_opening）。'}})
for a in ['the law of beginnings', 'the kind relay', '起始之律', '种类接力']:
    if a not in w['aliases']:
        w['aliases'].append(a)
kw_decls = sorted({d[len(B):] for l in new_laws for d in l['declarations']})
add_refs(w, KW, kw_decls)
w['history'].append({'en': f'{HISTORY_DATE}: the law of beginnings and what keeping opening needs along any reading; the landed law along passings and its exclusions derived from the law along supported passings, statements unchanged; within a kind, renewals one grain up; the laws for dissipated requirements; generation where supports last one step; the kind relay, closed and fed, on which 全生成 at two orders and keeping widening within kinds hold together. Statement, laws, a hypothesis, two does-not-show items and the next step changed.',
                     'zh': '2026年10月29日，工作板条目 GW（研究第 448 节）：起始之律与沿任一读法持续开出所需；沿传递之已落地之律及其排除由沿受支撑之传递之律推出，陈述不变；种类之内，高一粒度之更新；所需被耗散之律；支撑只持一步处之生成；种类接力（闭合与供给），其上二阶之全生成与种类内之持续扩大并立。陈述、诸律、一前提、两项不示及下一步有变。'})
save('what-keeping-widening-needs', w)

# ---- where-the-possible-grows -----------------------------------------------------------------
g = load('where-the-possible-grows')
ix = next(i for i, l in enumerate(g['laws']) if B + 'Run.begins_of_heldKeepsWidening' in l['declarations'])
g['laws'].insert(ix + 1, law(
    'On the map. Read along the steps with the one as the coarse class, a moment is 全生成 at a class exactly where a line under it begins after every later moment; so where holding is decided and the held possible keeps widening, every moment is 全生成 at (the one, what is held), and so where what is held changes at every step. A restatement; not conversely.',
    '于图谱上。沿诸步读、以一为粗类，一时刻于某类全生成，恰当其下之线于每一更晚时刻之后皆有所起；故持守可判定且持守时之可能持续扩大时，每一时刻于（一，所持守者）全生成；所持守者每步皆变时亦然。重述；反之不然。',
    ['Steps.generation_iff_begins', 'Run.generation_of_heldKeepsWidening', 'Run.generation_of_held_changes']))
g['laws'].insert(ix + 2, law(
    'Witnesses on the map. Every moment of the raised rule is 全生成 under the rule held while every moment ceases: generation without renewal without end. On the rule raised every other step, every moment is 全生成 beside renewal without end and keeping widening. On the oscillating rule every moment is 全生成 while the held possible does not keep widening.',
    '图谱上之见证。提升规则之每一时刻于持守规则时全生成，而每一时刻皆息：生成而无生生。隔步提升之规则上，每一时刻全生成，与生生及持续扩大并存。振荡之规则上每一时刻全生成，而持守时之可能不持续扩大。',
    ['RaisedRule.generation', 'RaisedEveryOther.begins_after_even', 'RaisedEveryOther.generation',
     'Oscillating.generation', 'Oscillating.generation_without_widening']))
for c in g['counterexamples']:
    if 'Oscillating.converse_fails' in c['detail']['en']:
        c['detail']['en'] += ' Every moment is 全生成 under the rule held, so 全生成 does not give keeping widening (Oscillating.generation_without_widening).'
        c['detail']['zh'] += '每一时刻于持守规则时皆全生成，故全生成不给出持续扩大（Oscillating.generation_without_widening）。'
add_refs(g, HP, ['Steps.generation_iff_begins', 'Run.generation_of_heldKeepsWidening', 'Run.generation_of_held_changes',
                 'RaisedRule.generation', 'RaisedEveryOther.begins_after_even', 'RaisedEveryOther.generation',
                 'Oscillating.generation', 'Oscillating.generation_without_widening'])
g['history'].append({'en': f'{HISTORY_DATE}: the held possible read on the map: 全生成 at (the one, what is held) exactly where a line under the part begins after every moment, so wherever the held possible keeps widening with holding decided; the witnesses read so. A law added; statement and next step unchanged.',
                     'zh': '2026年10月29日，工作板条目 GW（研究第 448 节）：持守时之可能读于图谱：于（一，所持守者）全生成，恰当该部分下之线于每一时刻之后皆有所起，故凡持守可判定而持守时之可能持续扩大处皆然；诸见证如此读之。增一律；陈述与下一步不变。'})
save('where-the-possible-grows', g)

# ---- generation-and-degeneration-at-two-grains: names as a case ------------------------------
t = load('generation-and-degeneration-at-two-grains')
for l in t['laws']:
    if B + 'Web.itself_not_generation' in l['declarations']:
        old = 'by names nothing generates'
        assert old in l['en']
        l['en'] = check('laws', {'en': l['en'].replace(old, 'by names, as wherever each formation continues only itself, nothing generates'), 'zh': l['zh']})['en']
        l['declarations'] += [B + 'Web.not_carries_of_within_itself', B + 'Web.not_generation_of_within_itself']
add_refs(t, MI, ['Web.not_carries_of_within_itself', 'Web.not_generation_of_within_itself'])
t['history'].append({'en': f'{HISTORY_DATE}: by names nothing generates is a case of the law for any continuation in which each formation continues only itself, proved once in MapInstances (board rule 9); itself_carries_nothing and itself_not_generation derived from it, statements unchanged. A law widened.',
                     'zh': '2026年10月29日，工作板条目 GW（研究第 448 节）：按名无一生成，为"每一构成只延续自身之任一延续"之律之特例，于 MapInstances 一次证之（工作板规则 9）；itself_carries_nothing 与 itself_not_generation 由之推出，陈述不变。一律放宽。'})
save('generation-and-degeneration-at-two-grains', t)

# ---- a-pattern-lasts-through-passing: what arises begins along every continuation -------------
a = load('a-pattern-lasts-through-passing')
for l in a['laws']:
    if B + 'Web.arises_iff_sheng_carrier' in l['declarations']:
        l['declarations'].append(B + 'Web.begins_of_arises')
add_refs(a, PP, ['Web.begins_of_arises'])
a['history'].append({'en': f'{HISTORY_DATE}: what arises begins a carrier along every continuation (begins_of_arises), proved once (board rule 9); the forward half of arises_iff_sheng_carrier derived from it, statement unchanged. A declaration added to a law; no text changed.',
                     'zh': '2026年10月29日，工作板条目 GW（研究第 448 节）：所生者沿每一延续皆起一载体（begins_of_arises），一次证之（工作板规则 9）；arises_iff_sheng_carrier 之前半由之推出，陈述不变。一律增一声明，文字不变。'})
save('a-pattern-lasts-through-passing', a)
print('records written')
