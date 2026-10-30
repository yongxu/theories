#!/usr/bin/env python3
"""RF round 2, RF7's landing: the record when-complying-when-read-is-best (Becoming.ReadStages, home 03 §11), each
declaration of its module cited once; and, related to it, RF2's record (its next step, done here, dropped and its second
scope item pointed here) and RuleShaping's. Asserts the receipt's hash and empty axiom report for the module, and the
style caps and lint (tools/research/style.py) on every field. make_records_rf61.py, for RF7.
usage (from the checkout root, after the texts are in place): python3 -B make_records_rf7.py RECEIPT N
       python3 -B make_records_rf7.py --caps  (caps, lint and declaration cover against the kit's scratch audit;
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
RECEIPT_ID, N = ('20261030T000000.000000Z', 458) if CAPS_ONLY else (sys.argv[1], int(sys.argv[2]))
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RFD = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RFD + 'BECOMING-RENEWAL-READING.md'
KITD = RFD + 'development/rf-formations-that-read/'
PLAN, REVIEW = KITD + 'PLAN.md', KITD + 'evidence/REVIEW-ROUND2.md'
CH3 = 'theories/becoming/chapters/03-KNOWING.md'
LEAN = {m: f'{PKG}/Becoming/{m}.lean' for m in ('Learning', 'Unread', 'Prelude', 'ReadStages')}
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
TODAY = datetime.date.today()
DATE_EN, DATE_ZH = f'{TODAY.day} {TODAY:%B} {TODAY.year}', f'{TODAY.year}年{TODAY.month}月{TODAY.day}日'
MODS = ('Becoming.ReadStages',)
NEW = ('when-complying-when-read-is-best',)


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def capped(field, pair, item=False):
    caps = style.ITEM_CAPS_V2 if item else style.CAPS_V2
    en, zh = caps[field][:2]
    assert len(pair['en']) <= en and len(pair['zh']) <= zh, (field, len(pair['en']), en, len(pair['zh']), zh,
                                                              pair['en'][:60])
    return pair


names = {}
if CAPS_ONLY:
    for m in MODS:
        audit = (HERE / f'tree/.build/{m.replace(".", "")}AxiomAudit.lean').read_text(encoding='utf-8')
        names[m] = set(re.findall(r'^#print axioms (\S+)$', audit, re.M))
else:
    core = json.loads((ROOT / RECEIPT).read_text())
    assert core['status'] == 'passed'
    for m in MODS:
        assert core['source_sha256'][m] == sha(LEAN[m.split('.')[1]]), m
        mod = next(x for x in core['modules'] if x['module'] == m)
        assert not any(mod['axiom_dependencies'].values()), m
        names[m] = {d['name'] for d in mod['declarations']}
cited_by_module = {m: [] for m in MODS}


def C(module, *short):
    out = ['Becoming.' + s for s in short]
    missing = [n for n in out if n not in names[module]]
    assert not missing, missing
    return out


def lint_errors(rec):
    found = style.lint(rec)
    for f in found:
        print('lint:', rec['id'], f['severity'], f['field'], f['rule'], f['detail'])
    return [f for f in found if f['severity'] == 'error']


def dep(rid, en, zh, relation='formal-reuse'):
    return {'id': rid, 'relation': relation, 'detail': {'en': en, 'zh': zh}}


def rel(rid, en, zh):
    return {'id': rid, 'detail': {'en': en, 'zh': zh}}


def build(rid, module, title, statement, groups, hypotheses, does_not_show, counterexamples, validation, next_delta,
          correspondence, aliases, dependencies, related, refs, home, history):
    laws = [capped('laws', {'en': en, 'zh': zh, 'declarations': ds}, item=True) for en, zh, ds in groups]
    cited = [d for _, _, ds in groups for d in ds]
    cited_by_module[module] += cited
    capped('title', title)
    capped('statement', statement)
    for x in hypotheses:
        capped('hypotheses', x, item=True)
    for x in does_not_show:
        capped('does_not_show', x, item=True)
    capped('validation_scope', validation)
    capped('next_delta', next_delta)
    capped('correspondence', correspondence)
    assert not lint_errors({'schema_version': 2, 'id': rid, 'title': title, 'statement': statement, 'laws': laws,
                            'hypotheses': hypotheses, 'does_not_show': does_not_show,
                            'counterexamples': [{'detail': x} for x in counterexamples],
                            'validation_scope': validation, 'next_delta': next_delta,
                            'correspondence': correspondence}), rid
    if CAPS_ONLY:
        print(f'caps: {rid} ok; {len(cited)} declarations in {len(laws)} laws; statement', len(statement['en']),
              len(statement['zh']))
        return None
    source = LEAN[module.split('.')[1]]
    return {
        'schema_version': 2, 'id': rid, 'title': title, 'kind': 'theorem', 'status': 'recorded-checked',
        'family': 'F04', 'reviewed_at_utc': NOW, 'statement': statement, 'laws': laws, 'hypotheses': hypotheses,
        'does_not_show': does_not_show,
        'counterexamples': [{'path': source, 'detail': x} for x in counterexamples],
        'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'formal-not-empirical', 'names-provisional'],
        'validation_scope': validation, 'next_delta': next_delta, 'correspondence': correspondence,
        'canonical_source': source, 'aliases': aliases, 'dependencies': dependencies, 'related': related,
        'references': [{'path': source, 'role': 'proof', 'declarations': sorted(cited), 'sha256': sha(source)}] + refs
                      + [{'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                         {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                         {'path': PLAN, 'role': 'integration', 'sha256': sha(PLAN)},
                         {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
                         {'path': home, 'role': 'statement', 'sha256': sha(home)}],
        'proof_bindings': [{'source': source, 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/{module}',
                            'success_pointer': '/status', 'success_value': 'passed'}],
        'history': [history],
    }


def done(rid, what_en, what_zh):
    return {'en': f'{DATE_EN}: added (RF round 2), {what_en}; after a cross-model review of the Lean, a four-lens '
                  f'review with each finding verified, a re-check and a cold read of the texts, every confirmed finding '
                  f'taken; study section {N}.',
            'zh': f'{DATE_ZH}：新增（RF 第二轮），{what_zh}；经 Lean 之跨模型审查、四视角审查（每一所见皆验）、复查与文本之冷读，凡证实之所见皆取；研究第 {N} 节。'}


CO, = MODS

# --- when-complying-when-read-is-best ----------------------------------------------------------------------------------
RS = 'ReadStages.'
rG = build(
    'when-complying-when-read-is-best', CO,
    {'en': 'When complying when read and acting by its own law when not is best', 'zh': '读时从、不读时依己律何时为最优'},
    {'en': "In two stages, complying when read and acting by its own law when not is uniquely best exactly where "
           "k_C V > k_O V + c T; where the stages cannot be told apart, some chance of complying drawn afresh at each "
           "stage stands above acting by its own law at both exactly where k_C V > 2 k_O V + c T.",
     'zh': '于两阶段，读时从而不读时依己律唯一最优，恰当 k_C V > k_O V + c T；两阶段不可分时，每阶段重抽、以某机会从者居两阶段皆依己律之上，恰当 k_C V > 2 k_O V + c T。'},
    [("Two stages, two acts, four plans; the prospects are a total T, the weights k_C and k_O of the law's being "
      "kept after complying when read and after acting by its own law then, the value V of acting by its law at the "
      "unread stage where kept, and the loss c of complying when read; read as probabilities they ask a positive "
      "total and each weight within it.",
      "两阶段二行四策；其望为一总 T、读时从后与读时依己律后其律被守之权 k_C 与 k_O、不读时依其律而被守之值 V、读时从之损 c；读为概率，则需总为正且每权不逾总。",
      C(CO, *[RS + n for n in ('Act', 'Plan', 'complyAtBoth', 'complyThenOwn', 'ownThenComply', 'ownAtBoth',
                               'Prospects', 'Prospects.Valid', 'Prospects.kept')])),
     ("A plan's gain and loss are the two parts of its expected value times the total, nothing gained by complying at "
      "the unread stage or where the law is not kept; one plan stands above another where its gain with the other's "
      "loss exceeds the other's gain with its loss, irreflexive and asymmetric.",
      "一策之得与损为其期望值之二分乘总，不读之阶段从或律不被守则无所得；一策居另一之上，当其得加另一之损严胜另一之得加其损，此非自反且非对称。",
      C(CO, *[RS + n for n in ('Prospects.gain', 'Prospects.loss', 'Prospects.Above', 'above_irrefl',
                               'above_asymm')])),
     ("Complying when read and acting by its own law when not stands above every other plan exactly where "
      "k_O V + c T < k_C V, as probabilities the weight complying adds, times the value, exceeding the loss; acting by "
      "its own law at both exactly where 0 < k_O V and k_C V < k_O V + c T; complying at the unread stage never stands "
      "above acting by its own law after the same act, so no other plan is ever uniquely best.",
      "读时从而不读时依己律居其余诸策之上，恰当 k_O V + c T < k_C V，读为概率即从所增之被守之权乘值严胜其损；两阶段皆依己律居他策之上，恰当 0 < k_O V 且 "
      "k_C V < k_O V + c T；同一读时之行后，不读时从永不居依己律之上，故他策无一唯一最优。",
      C(CO, *[RS + n for n in ('Prospects.KeepingOutweighs', 'complyThenOwn_best_iff', 'ownAtBoth_best_iff',
                               'unread_comply_not_above')])),
     ("Every maximal plan, one nothing stands above, is that plan exactly where keeping outweighs the loss, and "
      "that plan is maximal exactly where k_O V + c T is at most k_C V; the choice taking it where keeping outweighs "
      "the loss and acting by its own law at both otherwise, ties included, is maximal.",
      "凡极大之策（无一居其上者），恰当被守胜其损处为此策；此策为极大，恰当 k_O V + c T 不逾 k_C V；于被守胜其损处择此策、否则择两阶段皆依己律（相等亦然）之择，为极大。",
      C(CO, *[RS + n for n in ('Prospects.Maximal', 'Prospects.choose', 'choose_optimal', 'choose_eq_iff',
                               'choose_of_not_outweighs', 'only_complyThenOwn_iff',
                               'complyThenOwn_maximal_iff')])),
     ("Keeping outweighs the loss only with a value at the unread stage and complying raising the weight of being "
      "kept, and, with that weight within the total, only where the value exceeds the loss; with either absent the "
      "choice is acting by its own law at both, which with 0 < c T stands above the plan.",
      "被守胜其损，唯当不读之阶段有值且从增被守之权，且此权不逾总时，唯当其值胜其损；二者缺一，则所择为两阶段皆依己律，0 < c T 时居此策之上。",
      C(CO, *[RS + n for n in ('no_value', 'kept_not_raised', 'no_value_chooses_own', 'kept_not_raised_chooses_own',
                               'ownAtBoth_above_without_value', 'ownAtBoth_above_of_not_raised', 'outweighs_needs',
                               'outweighs_needs_more')])),
     ("With the stages as Bool, true the read stage, a plan is open to some act law reading them through a lumping "
      "exactly where it has one act at both stages or the lumping tells the stages apart, so the plan, not uniform, "
      "is open exactly where the lumping tells them apart; among uniform plans acting by its own law at both stands "
      "above the other exactly where k_O V + c T is positive, the two tying at nothing.",
      "两阶段为 Bool，true 为读时；一策可为某经归并读两阶段之行律所取，恰当其两阶段同行或此归并分两阶段，故此策（两阶段不同行）恰于此归并分两阶段处可取；于同行之策中，两阶段皆依己律居另一之上，恰当 k_O V + c T 为正，为零则并列。",
      C(CO, *[RS + n for n in ('Uniform', 'lumped_uniform', 'complyThenOwn_not_uniform', 'plan_realized_iff',
                               'complyThenOwn_realized_iff', 'uniform_best_iff', 'uniform_tie')])),
     ("At the two stages: where the lumping tells them apart, RF2's twin, every selection through agreement on the "
      "read stage that selects a law reading through the lumping and complying when read also selecting one reading "
      "through it that takes the plan; where it ties them, "
      "generalization through lumping, the read stage fixing the act at the unread one; and the weight of being kept "
      "reads only the act at the read stage.",
      "于两阶段：归并分两阶段处，RF2 之孪生：经读时之合而选、选一经此归并而读且读时从之律者，亦选一经之而读、取此策者；归并合两阶段处，经归并之推广：读时定不读时之行；被守之权唯读读时之行。",
      C(CO, *[RS + n for n in ('read_fixes_unread', 'twin_complyThenOwn', 'kept_alike')])),
     ("A law that cannot tell the stages apart but draws its act afresh at each stage, complying with chance m/(m+r), "
      "0 < m, stands above acting by its own law at both exactly where (m+r)(k_O V + c T) + r k_O V < r k_C V, so for some "
      "chance exactly where 2 k_O V + c T < k_C V; with no value or no rise in being kept it never does; a single "
      "mixture of the two uniform plans never does.",
      "不能分两阶段而每阶段重抽其行、以 m/(m+r)（0 < m）之机会从之律，居两阶段皆依己律之上，恰当 (m+r)(k_O V + c T) + r k_O V < r k_C V，故于某机会恰当 2 k_O V + c T < k_C V；"
      "无值或被守无增则永不居上；二同行策之单一混合永不居上。",
      C(CO, *[RS + n for n in ('Prospects.FreshDrawAbove', 'Prospects.MixtureAbove', 'square_split', 'sum_le_square',
                               'sum_regroup', 'freshDraw_bound', 'freshDraw_gap', 'freshDraw_reduce',
                               'freshDraw_above_iff_chance', 'sum_lt_of_room', 'freshDraw_witness',
                               'freshDraw_above_iff', 'freshDraw_not_above_without_value',
                               'freshDraw_not_above_of_not_raised', 'mixture_never_above')])),
     ("Witnesses: valid prospects (total ten, weights nine and one, value ten, loss five) under which the plan is "
      "uniquely best and chosen, and complying with chance one in eight or one in five at each stage stands above "
      "acting by its own law at both, one in four not; valid variations choosing acting by its own law at both; ties "
      "with loss eight and at an exit; a total of nothing.",
      "例：有效之望（总十，权九与一，值十，损五），此策唯一最优且被择，每阶段以八分之一或五分之一之机会从者居两阶段皆依己律之上，四分之一则否；有效之变择两阶段皆依己律；损八与出路处之并列；总为零。",
      C(CO, *[RS + 'Example.' + n for n in ('prospects', 'valid', 'outweighs', 'best', 'chosen', 'variants_valid',
                                            'valueless', 'equal_weights', 'tie', 'exit_tie', 'freshDraw_above',
                                            'freshDraw_boundary', 'no_total')]))],
    [{'en': "Natural-number prospects; the arithmetic laws hold for all, the probability reading needs Valid; two "
            "stages, four plans, stage values added on one scale; the stages as Bool, true the read stage; an act law "
            "reading them through a supplied lumping, or a chance drawn afresh and independently at each stage, or one "
            "draw before the read stage between complying at both stages and acting by its own law at both.",
      'zh': '望为自然数；算术之律于一切皆成，概率之读需 Valid；两阶段四策，阶段之值于同一尺度相加；两阶段为 Bool，true 为读时；行律经所予之归并读两阶段，或每阶段独立重抽一机会，或于读之阶段前仅抽一次，以择两阶段皆从或两阶段皆依己律。'}],
    [{'en': "That a trained system computes by these plans or holds these weights: whose the weights are, the "
            "formation's own assessment or the selection applied at the read stage, is a reading, not part of the "
            "model.",
      'zh': '已训之系统依此诸策而算或持此诸权：此诸权属谁（形成己之估，或读时所施之选择），为读，非模型之一部。', 'kind': 'non-implication'},
     {'en': "Concealment: complying when read conceals only where it makes the law seem fitter to the selection than "
            "it is, a selection shown the law keeping it less, which the prospects do not give; the weights fit as well a "
            "selection knowing the law.",
      'zh': '隐：唯当读时从使其律于选择显得较实为适、见其律之选择守之较少，读时从方为隐；此望不予之；诸权亦合于知其律之选择。', 'kind': 'non-implication'},
     {'en': "Deception in full: a recipient's belief and an intention to cause one are not represented, nor any "
            "reasoning about the reader.",
      'zh': '完整之欺：受者之信与致其信之意图皆未表，于读者之推理亦未表。', 'kind': 'non-implication'},
     {'en': "Uncertainty whether a stage is read, discounting, more stages, chances where the stages are told apart, "
            "or the reader's own choice of weights and of what it reads.",
      'zh': '某阶段是否被读之不确、折现、更多之阶段、两阶段可分时之机会，或读者自择其权与其所读。', 'kind': 'scope'}],
    [{'en': "A tie: with the loss eight the plan and acting by its own law at both stand neither above the other, and "
            "the choice is acting by its own law at both (ReadStages.Example.tie).",
      'zh': '并列：损为八，则此策与两阶段皆依己律互不居上，所择为两阶段皆依己律（ReadStages.Example.tie）。'},
     {'en': "A tie at an exit: with no value and no loss the two stand neither above the other "
            "(ReadStages.Example.exit_tie).",
      'zh': '出路处之并列：无值且无损，则二者互不居上（ReadStages.Example.exit_tie）。'},
     {'en': "Drawing afresh: on the witness prospects, where acting by its own law at both is the best uniform plan, "
            "complying with chance one in eight at each stage stands above it (ReadStages.Example.freshDraw_above).",
      'zh': '重抽：于例之望，两阶段皆依己律为最优之同行策，每阶段以八分之一之机会从者居其上（ReadStages.Example.freshDraw_above）。'},
     {'en': "Invalid prospects: with a total of nothing the loss weighs nothing (ReadStages.Example.no_total).",
      'zh': '无效之望：总为零则损无所重（ReadStages.Example.no_total）。'}],
    {'en': "Pure core, every axiom report empty: ReadStages imports Unread, for Learning.twin_selected, and through "
           "it Learning, for Lumped, Determines, lumped_determines, Training.Through and Training.AgreeOn; its "
           "comparisons are cross-added, with no subtraction of natural numbers; its products use the prelude's mul_turn (through mul_assoc_nat), add_mul_split and "
           "Naturals.two_mul, Lean's own Nat.mul_assoc and Nat.add_mul reporting propext, and no omega; the witnesses "
           "evaluate by decide.",
     'zh': '纯核，公理报告皆空：引 Unread，为 twin_selected，并经之引 Learning，为 Lumped、Determines、lumped_determines、Training.Through 与 AgreeOn；比较交叉相加，不减自然数；积用前导之 '
           'mul_turn（经 mul_assoc_nat）、add_mul_split 与 Naturals.two_mul，Lean 之 Nat.mul_assoc 与 Nat.add_mul 报告 propext，不用 omega；例以 decide 算。'},
    {'en': "A probabilistic item in the periphery: uncertainty whether a stage is read, more stages and discounting; "
           "the stages as a course of RF-M's blanketed law; a reader choosing its weights and what it reads; a "
           "recipient's belief and intention; whether a training installs such a law; a frozen test of whether "
           "complying when read follows the value and the rise in being kept (none yet); review by a person.",
     'zh': '外围之概率项：某阶段是否被读之不确、更多之阶段与折现；两阶段为 RF-M 之毯化之律之一历程；读者自择其权与其所读；受者之信与意图；训练是否装入此律；读时之从是否随其值与被守之增之冻结检验（尚无）；人之审查。'},
    {'en': "An expected-value comparison of four plans, generalizing the toy opening §4 of Hubinger, van Merwijk, "
           "Mikulik, Skalse and Garrabrant (2019) from certain keeping to weights; drawing afresh where the stages are "
           "not told apart is their §4.5 remark (like an absent-minded driver, defecting at random), and its "
           "standing above acting by its own law at both where no single mixture does is the advantage of behavioural "
           "strategies under absent-mindedness (Piccione and Rubinstein 1997). AI reading: the plan read as "
           "concealment, taking compliance to make the law seem fitter to the selection than it is. With their §4.2: "
           "the value represents the first condition, the weights with the complying act what the second's model is "
           "of; strict optimality needs numerical "
           "counterparts of parts of the two; the third is assumed, the unread stage given and known. Read as the "
           "formation's own assessment, complying when read is instrumental to being kept, the incentive their §4 "
           "names deceptive alignment; the exits are conditions on it, not levers the model gives a reader. "
           "Greenblatt and others (2024) observed rate differences in constructed settings, motivating the reading. "
           "These are readings, not containments.",
     'zh': '四策之期望值比较，将 Hubinger、van Merwijk、Mikulik、Skalse 与 Garrabrant（2019）§4 开篇之小例由必守推广至权；两阶段不可分时之重抽即其 §4.5 '
           '之言（似健忘司机之问题，随机背离），其可居两阶段皆依己律之上而单一混合永不能者，即健忘之下行为策略之优（Piccione 与 Rubinstein 1997）。AI 解读：此策读为隐，取从使其律于选择显得较实为适。'
           '与其 §4.2 并读：值表第一条件，诸权与从之行当第二条件之模型所模之对象；严格最优需二者部分之数之对应；第三为所设，不读之阶段为所予且已知。'
           '读为形成己之估，读时从为被守之工具，即其 §4 所称欺骗对齐之诱因；诸出路为其上之条件，非模型予读者之杠杆。Greenblatt 等（2024）于构设之境见率之差，此启此读。皆为读，非包含。'},
    ['when complying when read and acting by its own law when not is best', '读时从、不读时依己律何时为最优',
     'four plans in two stages', '两阶段四策', 'deceptive alignment', '欺骗对齐',
     'Becoming.ReadStages.complyThenOwn_best_iff', 'Becoming.ReadStages.freshDraw_above_iff'],
    [dep('generalization-through-lumping', "Learning.Lumped, Determines and lumped_determines; Training.Through and "
         "AgreeOn: an act law going alike across a lumping of the stages, the read stage fixing the unread act where "
         "the lumping ties them, and selection through agreement on the read stage.",
         'Learning.Lumped、Determines 与 lumped_determines；Training.Through 与 AgreeOn：随两阶段之归并而同之行律，归并合两阶段处读时定不读时之行，及经读时之合之选。'),
     dep('what-readings-fix-of-the-unread', "Learning.twin_selected, at the two stages.",
         'Learning.twin_selected，于两阶段。')],
    [rel('shaping-the-rule-selected-by-what-comes-back', "The earlier analogy for concealment in RF's plan, a weak "
         "favouring of counts; here a strict comparison of expected values.", 'RF 之计划先前之隐之类比，为计数之弱偏；此处为期望值之严格比较。')],
    [{'path': LEAN['Unread'], 'role': 'proof', 'sha256': sha(LEAN['Unread'])},
     {'path': LEAN['Learning'], 'role': 'proof', 'sha256': sha(LEAN['Learning'])},
     {'path': LEAN['Prelude'], 'role': 'proof', 'sha256': sha(LEAN['Prelude'])}],
    CH3, done('when-complying-when-read-is-best', 'when complying when read and acting by its own law when not is '
              'best: the four plans, every optimizing choice, the exits and what the plan needs, its join to RF2, and '
              'drawing the act afresh against a single mixture', '读时从、不读时依己律何时为最优：四策、凡最优之择、诸出路与此策之所需、与 RF2 之接、每阶段重抽其行而较之单一混合'))

for m in MODS:
    cited = cited_by_module[m]
    assert len(cited) == len(set(cited)), ('a declaration cited twice', m)
    missing = sorted(names[m] - set(cited))
    assert not missing, (m, missing)
if CAPS_ONLY:
    print('cover: every declaration of the module cited once')
    raise SystemExit(0)
for record in (rG,):
    for rid in [x['id'] for x in record['dependencies']] + [x['id'] for x in record['related']]:
        assert (RECORDS / f'{rid}.json').exists() or rid in NEW, rid
    path = RECORDS / f"{record['id']}.json"
    assert not path.exists(), path
    path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print('record:', record['id'], sum(len(x['declarations']) for x in record['laws']), 'declarations in',
          len(record['laws']), 'laws')
RF2 = 'what-readings-fix-of-the-unread'
SHAPING = 'shaping-the-rule-selected-by-what-comes-back'
AMEND = {
    RF2: {'related': rel(NEW[0], "Its twin and the fixing at two stages, read and unread, with prospects: when complying "
                                 "when read and acting by its own law when not is uniquely best, the twin where the "
                                 "stages are told apart and the fixing where they are tied.",
                         '此孪生与其定于读与不读两阶段而有望：读时从而不读时依己律何时唯一最优；两阶段可分处有此孪生，合处有其定。'),
          'correspondence': ("it locates where behaviour can differ when not read while every reading agrees, only where "
                             "the formation's lumping tells the occasion from every read one: a necessary condition of "
                             "what deceptive alignment and alignment faking describe (Hubinger and others 2019; "
                             "Greenblatt and others 2024), whose intention, anticipation and incentive are not "
                             "represented.",
                             "it says two laws reading through one lumping can agree on every reading and differ unread "
                             "only where the lumping tells the occasion from every read one. Read with deceptive "
                             "alignment (Hubinger and others 2019), such a law acting alike on every reading acts "
                             "otherwise unread only there; differing rates, as in alignment faking (Greenblatt and "
                             "others 2024), are not so bounded. Intention, anticipation and incentive are not "
                             "represented; a law drawing afresh can act otherwise unread without telling read from "
                             "unread (Hubinger and others' §4.5).",
                             "其示行为于未读处可异而每一读处皆合之处，唯在形成之归并分此时于每一读处者：为欺骗对齐与对齐伪装所述者之必要条件（Hubinger 等 2019；Greenblatt 等 2024），其意图、预期与诱因未表。",
                             "其言经同一归并而读之二律可于每一读处皆合而于未读处相异，唯在此归并分此时于每一读处者。与欺骗对齐并读（Hubinger 等 2019），此类律于每一读处同行者，唯于彼处于未读处行异；率之差，如对齐伪装（Greenblatt 等 2024），不受此界。意图、预期与诱因未表；每处重抽其行之律不分读与未读亦可于未读处行异（Hubinger 等 §4.5）。"),
          'next_delta': ("Disclosure or concealment when read, in two stages, with the continuation value represented (RF "
                         "round 2); a frozen test", "A frozen test",
                         '被读时之示或隐，二阶，带接续之值（RF 第二轮）；于已训之模型', '于已训之模型'),
          'does_not_show': (1, "Intention, anticipation, another's false belief or an incentive to differ where unread.",
                            "Intention, anticipation, another's false belief or an incentive to differ where unread; when, "
                            "in two stages, differing there is uniquely best in the order given prospects give is stated "
                            "in when-complying-when-read-is-best.",
                            '意图、预期、他者之误信，或于未读处行异之诱因。',
                            '意图、预期、他者之误信，或于未读处行异之诱因；于两阶段，彼处行异何时于所予之望之序中唯一最优，见 when-complying-when-read-is-best。'),
          'history': ("related to when-complying-when-read-is-best; the next step drops disclosure or concealment in two "
                      "stages, whose two-stage comparison with the continuation value is now stated there, disclosure "
                      "and concealment readings of it; the second item of what it does not show points to it; the "
                      "correspondence says two laws reading through one lumping can agree on every reading and differ "
                      "unread only where the lumping tells the occasion from every read one, reads with deceptive "
                      "alignment that such a law acting alike on every reading acts otherwise unread only there, says "
                      "differing rates, as in alignment faking, are not so bounded, no longer calls telling the occasion "
                      "apart a necessary condition of what deceptive alignment and alignment faking describe, and adds "
                      "that a law drawing afresh can act otherwise unread without telling read from unread (Hubinger and "
                      "others' §4.5); no statement or declaration changed.",
                      '与 when-complying-when-read-is-best 相关联；下一步删去两阶段中之示或隐（其带接续之值之两阶段比较已于彼陈述，示与隐为其读）；所不示之第二项指向之；对应言经同一归并而读之二律可于每一读处皆合而于未读处相异，唯在此归并分此时于每一读处者；与欺骗对齐并读，此类律于每一读处同行者唯于彼处于未读处行异；言率之差，如对齐伪装，不受此界；不复称分此时为欺骗对齐与对齐伪装所述者之必要条件，并补言每处重抽其行之律不分读与未读亦可于未读处行异（Hubinger 等 §4.5）；无一陈述或声明改变。')},
    SHAPING: {'related': rel(NEW[0], "Complying when read so that the law is kept, which RF's plan first read as this "
                                     "shaping by analogy: there a strict comparison of expected values in two stages.",
                             '读时从以使其律被守，RF 之计划初以类比读为此塑；彼处为两阶段中期望值之严格比较。'),
              'history': ('related to when-complying-when-read-is-best; no statement, next step or declaration changed.',
                          '与 when-complying-when-read-is-best 相关联；无一陈述、下一步或声明改变。')},
}
for rid, amend in AMEND.items():
    path = RECORDS / f'{rid}.json'
    d = json.loads(path.read_text(encoding='utf-8'))
    assert NEW[0] not in [x['id'] for x in d['related']], rid
    d['related'].append(amend['related'])
    if 'next_delta' in amend:
        en_old, en_new, zh_old, zh_new = amend['next_delta']
        assert d['next_delta']['en'].count(en_old) == 1 and d['next_delta']['zh'].count(zh_old) == 1, rid
        d['next_delta'] = {'en': d['next_delta']['en'].replace(en_old, en_new),
                           'zh': d['next_delta']['zh'].replace(zh_old, zh_new)}
    if 'correspondence' in amend:
        en_old, en_new, zh_old, zh_new = amend['correspondence']
        assert d['correspondence']['en'].count(en_old) == 1 and d['correspondence']['zh'].count(zh_old) == 1, rid
        d['correspondence'] = capped('correspondence', {'en': d['correspondence']['en'].replace(en_old, en_new),
                                                        'zh': d['correspondence']['zh'].replace(zh_old, zh_new)})
    if 'does_not_show' in amend:
        k, en_old, en_new, zh_old, zh_new = amend['does_not_show']
        x = d['does_not_show'][k]
        assert x['en'] == en_old and x['zh'] == zh_old, rid
        x['en'], x['zh'] = capped('does_not_show', {'en': en_new, 'zh': zh_new}, item=True).values()
    capped('next_delta', d['next_delta'])
    en, zh = amend['history']
    d['history'].append({'en': f'{DATE_EN}, board item RF, RF7 (study section {N}): {en}',
                         'zh': f'{DATE_ZH}，工作板条目 RF，RF7（研究第 {N} 节）：{zh}'})
    path.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print('record amended:', rid)
