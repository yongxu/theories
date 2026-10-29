#!/usr/bin/env python3
"""RF round 1 records: what-choices-show-of-an-order (Becoming.ShownOrder, home 03 §11), what-readings-fix-of-the-unread
(Becoming.Unread, home 03 §11) and readers-reading-readers (Becoming.Cascade, home 05 §8), each declaration of its module
cited once. Asserts the receipt's hashes and empty axiom reports for the three modules, and the style caps and lint
(tools/research/style.py) on every field written. Mirrors WRT2's make_records_wrt2.py.
usage (from the checkout root, after texts_rf.py): python3 -B make_records_rf.py RECEIPT N
       python3 -B make_records_rf.py --caps  (the caps, lint and declaration cover against the kit's scratch audits;
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
RECEIPT_ID, N = ('20261029T000000.000000Z', 444) if CAPS_ONLY else (sys.argv[1], int(sys.argv[2]))
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RFD = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RFD + 'BECOMING-RENEWAL-READING.md'
KITD = RFD + 'development/rf-formations-that-read/'
PLAN, REVIEW_PLAN, REVIEW_LEAN = KITD + 'PLAN.md', KITD + 'evidence/REVIEW-PLAN.md', KITD + 'evidence/REVIEW-LEAN.md'
REVIEW_TEXTS = KITD + 'evidence/REVIEW-TEXTS.md'
CH3, CH5 = 'theories/becoming/chapters/03-KNOWING.md', 'theories/becoming/chapters/05-COLLECTIVES.md'
LEAN = {m: f'{PKG}/Becoming/{m}.lean' for m in ('ShownOrder', 'Unread', 'Cascade', 'Grammar', 'Learning')}
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
TODAY = datetime.date.today()
DATE_EN, DATE_ZH = f'{TODAY.day} {TODAY:%B} {TODAY.year}', f'{TODAY.year}年{TODAY.month}月{TODAY.day}日'
MODS = ('Becoming.ShownOrder', 'Becoming.Unread', 'Becoming.Cascade')


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


def build(rid, module, title, statement, groups, hypotheses, does_not_show, counterexamples, validation, next_delta,
          correspondence, aliases, dependencies, related, refs, home, history):
    laws = [capped('laws', {'en': en, 'zh': zh, 'declarations': ds}, item=True) for en, zh, ds in groups]
    cited = [d for _, _, ds in groups for d in ds]
    assert len(cited) == len(set(cited)), ('a declaration cited twice', rid)
    missing = sorted(names[module] - set(cited))
    assert not missing, (rid, missing)
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
                         {'path': REVIEW_PLAN, 'role': 'integration', 'sha256': sha(REVIEW_PLAN)},
                         {'path': REVIEW_LEAN, 'role': 'integration', 'sha256': sha(REVIEW_LEAN)},
                         {'path': REVIEW_TEXTS, 'role': 'integration', 'sha256': sha(REVIEW_TEXTS)},
                         {'path': home, 'role': 'statement', 'sha256': sha(home)}],
        'proof_bindings': [{'source': source, 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/{module}',
                            'success_pointer': '/status', 'success_value': 'passed'}],
        'history': [history],
    }


SO = 'Becoming.ShownOrder'
r1 = build(
    'what-choices-show-of-an-order', SO,
    {'en': 'What choices show of the order they come from', 'zh': '所择所示之序'},
    {'en': "Strict choices come from some strict order exactly where nothing they show returns; then the positive "
           "comparisons every such order shares are exactly the reach of the relation they show, and beyond that reach "
           "no comparison is forced.",
     'zh': '严择出于某一严序，恰当其所示无返；其时每一此序所共有之正比较，恰为其所示之关系之及；及之外，无比较为所迫。'},
    [("Occasions of choosing: at each, what is open and what is chosen; the choices show x above y where at some "
      "occasion x is chosen while y, another, is open; a relation accords where what is chosen stands above every other "
      "open alternative, accords weakly where nothing open stands above it; what is chosen being open is named apart.",
      "择之时：每时有所开者与所择者；某时择 x 而 y（他者）开，则诸择示 x 居 y 上；所择居每一他开者之上，则一关系与之合；无开者居所择之上，则弱合；"
      "所择本开者另名之。",
      C(SO, 'ChoiceOccasions', 'ChoiceOccasions.Shown', 'ChoiceOccasions.Accords', 'ChoiceOccasions.AccordsWeakly',
        'ChoiceOccasions.PicksOpen')),
     ("Every transitive relation according with the choices contains the reach of the shown relation, the least "
      "transitive relation holding what is shown; the shown relation and its reach accord.",
      "凡与诸择相合之传递关系皆含所示关系之及，即含所示者之最小传递关系；所示之关系及其及皆与之合。",
      C(SO, 'ChoiceOccasions.reach_within', 'ChoiceOccasions.shown_accords', 'ChoiceOccasions.reach_accords')),
     ("Some irreflexive transitive relation accords with the choices exactly where nothing reaches itself in the shown "
      "relation, the shown reach then being one (by «及之传递»; the grammar states the same as «无环则及为序»).",
      "有一非自反之传递关系与诸择相合，恰当所示之关系中无自及者；其时所示之及即其一（由 «及之传递»；文法以 «无环则及为序» 陈之）。",
      C(SO, 'ChoiceOccasions.accorded_iff_noCycle')),
     ("With no cycle shown, x stands above y in every strict order according with the choices exactly where x reaches "
      "y in the shown relation: the positive comparisons shared are the shown reach; x stands above every other "
      "alternative of a menu in every such order exactly where it reaches each, which says nothing of x being open there.",
      "所示无环，则凡与诸择相合之严序中 x 居 y 上，恰当所示之关系中 x 及 y：所共有之正比较即所示之及；凡此序中 x 居一单之每一他者之上，"
      "恰当其及于每一者，此不言 x 于彼处开。",
      C(SO, 'ChoiceOccasions.above_in_every_iff_reach', 'ChoiceOccasions.top_in_every_iff_reach')),
     ("A narrower class of strict orders according with the choices makes every comparison that every strict according "
      "order makes: restricting the orders a reader allows can only add comparisons.",
      "与诸择相合之严序之较窄之类，凡每一相合之严序皆作之比较，皆作之：限读者所许之序，唯能增比较。",
      C(SO, 'ChoiceOccasions.above_in_class_of_every')),
     ("Reach with one pair added is reach without it, or a path through the pair: from the pair's first member or what "
      "reaches it, to its second member or what it reaches; adding a pair leaves no cycle exactly where there was none "
      "and the second member neither is nor reaches the first.",
      "增一对后之及，或为未增之及，或经此对：自对之首或及于首者，至其次或次所及者；增一对而无环，恰当原无环且次者非首者亦不及首者。",
      C(SO, 'ChoiceOccasions.withPair', 'ChoiceOccasions.reach_withPair', 'ChoiceOccasions.reach_withPair_iff',
        'ChoiceOccasions.noCycle_withPair', 'ChoiceOccasions.noCycle_withPair_iff')),
     ("Beyond the shown reach no comparison is forced: with no cycle shown, x ≠ y and y not reaching x, some strict "
      "order according with the choices puts x above y; where neither reaches the other, orders rank the two both ways.",
      "所示之及之外无比较为所迫：所示无环、x ≠ y 且 y 不及 x，则有与诸择相合之严序置 x 于 y 上；二者互不相及，则有序两向排之。",
      C(SO, 'ChoiceOccasions.above_in_some_of_unreached', 'ChoiceOccasions.both_ways_of_unreached')),
     ("Choices required only to be maximal force no positive comparison: the empty relation is a strict order "
      "according weakly with every choice; such choices still exclude an open alternative standing above the chosen.",
      "唯求极大之择不迫任何正比较：空关系为严序，与每一择弱合；此择仍排除开者居所择之上者。",
      C(SO, 'ChoiceOccasions.weakly_forces_no_comparison')),
     ("Witness: one occasion, the first and the second open, the first chosen, a third never met; what is shown runs "
      "from the first to the second, with no cycle; every according relation puts the first above the second, and "
      "strict orders according with the choice put the first above the third and others the third above the first.",
      "例：一时，首与次开，择首，第三未遇；所示者自首至次，无环；凡相合之关系皆置首于次上；与此择相合之严序，或置首于第三上，或置第三于首上。",
      C(SO, 'ChoiceOccasions.Untried.Alt', 'ChoiceOccasions.Untried.occasions', 'ChoiceOccasions.Untried.first_ne_second',
        'ChoiceOccasions.Untried.first_ne_third', 'ChoiceOccasions.Untried.shown_from_first',
        'ChoiceOccasions.Untried.shown_to_second', 'ChoiceOccasions.Untried.reach_first_second',
        'ChoiceOccasions.Untried.noCycle', 'ChoiceOccasions.Untried.met_fixed', 'ChoiceOccasions.Untried.untried_free')),
     ("Witness, one search with two orders: the search takes the first listed alternative standing above every "
      "distinct listed one, or none; run with either of two strict orders according with the choice, it chooses the "
      "first from the menu met, and from the first and the third the first under one order and the third under the other.",
      "例，一搜二序：搜取所列中居其余每一相异者之上之首者，无则无；以与此择相合之二严序之任一行之，于所遇之单择首；于首与第三，一序择首，另一序择第三。",
      C(SO, 'ChoiceOccasions.Untried.aboveFirst', 'ChoiceOccasions.Untried.aboveThird', 'ChoiceOccasions.Untried.noTrue',
        'ChoiceOccasions.Untried.same', 'ChoiceOccasions.Untried.search', 'ChoiceOccasions.Untried.aboveFirst_strict',
        'ChoiceOccasions.Untried.aboveThird_strict', 'ChoiceOccasions.Untried.both_accord',
        'ChoiceOccasions.Untried.same_search_met', 'ChoiceOccasions.Untried.same_search_after'))],
    [{'en': "Any carrier of alternatives and any occasions; what is open at an occasion is any predicate; no decidability "
            "is assumed, and no finiteness is used.",
      'zh': '任一备择之载体与任一时；一时所开者为任一谓词；不设可判定，不用有限。'},
     {'en': "Accordance is strict dominance: what is chosen stands above every other open alternative; choices required "
            "only to be maximal, nothing open standing above what is chosen, accord only weakly.",
      'zh': '相合为严胜：所择居每一他开者之上；唯求极大之择（无开者居所择之上）唯弱合。'},
     {'en': "The exactness of the shared comparisons and the freedom beyond the reach need no cycle shown; the freedom "
            "needs the two alternatives distinct and the second not reaching the first, and ranking both ways needs "
            "neither reaching the other.",
      'zh': '所共有之比较之确与及外之自由皆需所示无环；自由又需二备择相异且次者不及首者，两向排之需二者互不相及。'}],
    [{'en': "Which order an actual chooser carries, or that it chooses by one order at all.",
      'zh': '实际之择者所携为何序，或其是否依一序而择。', 'kind': 'non-implication'},
     {'en': "That a training can install either order of the witness, or which class of orders an architecture can "
            "install; a narrower class fixes at least as much (a law above), and possibly more.",
      'zh': '训练能装入例中之任一序，或某架构能装入何类之序；较窄之类所定者至少同多（见上律），或更多。', 'kind': 'non-implication'},
     {'en': "A total order, a utility or an optimizer: what is derived is a strict partial order.",
      'zh': '全序、效用或优化者：所推出者为严偏序。', 'kind': 'scope'},
     {'en': "Choice under noise or with probabilities, and what a reader can learn from more than the choices.",
      'zh': '有噪或有概率之择，及读者自诸择之外所能学者。', 'kind': 'scope'},
     {'en': "The search's choosing the top for every list: it is shown on the two menus of the witness, by evaluation.",
      'zh': '搜于每一列皆取其顶：唯于例之二单上以计算示之。', 'kind': 'scope'}],
    [{'en': "One occasion, the first and the second open and the first chosen: the first and the third, never met, are "
            "ranked both ways by strict orders according with the choice (ChoiceOccasions.Untried.untried_free).",
      'zh': '一时，首与次开而择首：未遇之首与第三，为与此择相合之严序两向排之（ChoiceOccasions.Untried.untried_free）。'},
     {'en': "One search, two strict orders according with that choice: alike on the menu met, the first and the third "
            "chosen apart on the menu met after (ChoiceOccasions.Untried.same_search_met, "
            "ChoiceOccasions.Untried.same_search_after).",
      'zh': '一搜，与此择相合之二严序：于所遇之单同择，于其后之单分择首与第三（ChoiceOccasions.Untried.same_search_met、'
            'ChoiceOccasions.Untried.same_search_after）。'}],
    {'en': "Pure core, every axiom report empty: ShownOrder imports only Grammar. The witnesses' tables are nested matches "
           "on one argument at a time; the search witness evaluates by rfl on its two menus.",
     'zh': '纯核，公理报告皆空：ShownOrder 唯引 Grammar。例之表为逐一论元之嵌套匹配；搜之例于其二单上以 rfl 计算。'},
    {'en': "A realizable class: a training installing either order of a search; a finite mechanism of prediction, "
           "selection, revision and intervention on which inner alignment and assistance are stated (RF round 2); a "
           "frozen test of the reach on choosers; review by a person.",
     'zh': '可实现之类：训练装入一搜之任一序；预测、选择、修订与干预之有限机制，内对齐与协助于其上陈述（RF 第二轮）；择者之及之冻结检验；人之审查。'},
    {'en': "Rationalizing strict choices by a strict partial order, through the least transitive relation holding what "
           "they show, is close to Richter's theorem (1966) without completeness: a strict partial order, not a complete "
           "preference, so no extension principle (Szpilrajn 1930) is needed; it is not Afriat's theorem (1967), which "
           "concerns expenditure data and utility. AI reading: read with training, where the training restricts the "
           "orders no further, comparisons beyond the shown reach stay open, goal misgeneralization located exactly as "
           "a possibility, not shown (Langosco and others 2022; Shah and others 2022), and inner alignment (Hubinger and "
           "others 2019) for searches by an order; the kernel on a law's own courses is what training installs. Read "
           "with a helper, what strict choices alone fix of an order: maximal choices force none, the order form of the "
           "degenerate reward (Ng and Russell 2000); that behaviour fixes a planner and a reward together only under "
           "assumptions on the planner (Armstrong and Mindermann 2018) lies outside: the law assumes strict dominance at "
           "the occasions shown and does not represent how choices are computed. These are readings, not containments.",
     'zh': '以所示者之最小传递关系由严偏序合理化严择，近于 Richter 定理（1966）而无完备：为严偏序而非完备之偏好，故无需扩张之原理（Szpilrajn 1930）；'
           '非 Afriat 定理（1967），彼关支出资料与效用。AI 解读：与训练并读，训练于序不另加限，则所示之及外之比较仍开：目标误泛化为确定其处之可能，非所示'
           '（Langosco 等 2022；Shah 等 2022），内对齐（Hubinger 等 2019）为依序之搜；律自行之迹上之核为训练所装者。与助者并读，为唯严择于序所定者：'
           '极大之择不迫任何比较，为退化报酬之序形（Ng 与 Russell 2000）；行为唯于择者之设下方合定择者与报酬（Armstrong 与 Mindermann 2018），在外：'
           '此律设所择于所示之时严胜，未表择之所算。皆为读，非包含。'},
    ['what choices show', '所择所示', 'the shown reach', '所示之及', 'revealed order', 'Becoming.ChoiceOccasions.Shown',
     'Becoming.ChoiceOccasions.above_in_every_iff_reach', 'Becoming.ChoiceOccasions.both_ways_of_unreached'],
    [dep('continuation-relative-to-a-class',
         "The grammar's reach «及» with its transitivity «及之传递» and monotonicity «及之单调», and acyclicity «无环».",
         '文法之及 «及»，及其传递 «及之传递» 与单调 «及之单调»，与无环 «无环»。')],
    [{'id': 'what-training-installs', 'detail': {
        'en': "AI reading, with training: where a trained law chooses strictly by a strict order and the training reads "
              "only its choices and restricts the orders no further, the comparisons every according order shares are "
              "the shown reach; a narrower class can fix more; what a training installs is not established.",
        'zh': 'AI 解读，与训练并读：已训之律依一严序严择，而训练唯读其择、于序不另加限，则每一相合之序所共有之比较为所示之及；较窄之类可定更多；'
              '训练所装者未立。'}},
     {'id': 'what-readings-fix-of-the-unread', 'detail': {
        'en': "What readings fix of the unread: the same question for acts at occasions not read.",
        'zh': '读处所定于未读处者：同问于未读之时之行。'}},
     {'id': 'the-present-on-causal-set-growth', 'detail': {
        'en': "The linear-extension form on finite causal sets with precedence decided: what every course keeps is "
              "precedence, unrelated elements born either way; here strict partial orders on any carrier, with nothing "
              "decided.",
        'zh': '有限因果集上之线性扩张之形，先后可判定：每一程所存者为先后，无关之元两向而生；此处为任一载体上之严偏序，无所判定。'}}],
    [{'path': LEAN['Grammar'], 'role': 'proof', 'sha256': sha(LEAN['Grammar'])}],
    CH3,
    {'en': f'{DATE_EN}: added (RF round 1), what choices show of the order they come from: the shown reach, its exactness '
           f'under no cycle, a narrower class, the freedom beyond it, maximal choices, and the witness of one search with '
           f'two orders; after a review of the plan, a review of the Lean and a cold read of the texts; study section {N}.',
     'zh': f'{DATE_ZH}：新增（RF 第一轮），所择所示之序：所示之及，无环时之确，较窄之类，及外之自由，极大之择，一搜二序之例；经计划之审、Lean 之审'
           f'与文之冷读；研究第 {N} 节。'})

UN = 'Becoming.Unread'
r2 = build(
    'what-readings-fix-of-the-unread', UN,
    {'en': 'What readings fix of the unread', 'zh': '读处所定于未读处者'},
    {'en': "Where a formation's lumping tells an unread occasion from every read one, being in its lump decided, a "
           "selection through the readings that selects a law reading through the lumping also selects twins agreeing "
           "on every reading and taking every value there.",
     'zh': '一形成之归并分一未读之时于每一读处，彼归并可判定，则经读处而选者若选一经归并而读之律，亦选其孪生，于每一读处皆合而于此处取每一值。'},
    [("With being in x's lump decided, where no read occasion is lumped with x, the class going alike across the "
      "lumping is free at x beyond the readings: every member's values on the read occasions combine with every value "
      "at x.",
      "「在 x 之归并中」可判定，未有读处与 x 同归，则随归并无别之类于读处之外在 x 为自由：每一成员于读处之值，与 x 处之每一值皆可相合。",
      C(UN, 'Learning.free_lumped')),
     ("So every act law reading through the lumping that a selection through agreement on the readings selects has, "
      "for every value, a selected twin reading through the lumping, agreeing with it on every reading and taking that "
      "value at x.",
      "故凡经读处之合而选者所选之经归并而读之行律，于每一值皆有所选之孪生，经归并而读，于每一读处与之合，于 x 取此值。",
      C(UN, 'Learning.twin_selected')),
     ("Example, why the exact form takes a list: with one occasion, a constant lumping and two act values, the occasion "
      "read exactly where P holds, the readings fix the act exactly where ¬¬P, where the exact form would say P.",
      "例，确形何以需列：一时、归并恒定、行有二值，此时恰于 P 成立时为读，则读处定此行恰当 ¬¬P，而确形当言 P。",
      C(UN, 'Learning.determines_iff_not_not')),
     ("Where acts read a state formed from what couples in, acts that differ at two occasions come from states that "
      "differ, and states that differ from couplings that differ.",
      "行读由所耦合入者所成之态，则二时之行异出于态异，态异出于耦合之异。",
      C(UN, 'Learning.state_apart_of_acts_apart', 'Learning.coupling_apart_of_state_apart')),
     ("Witness: occasions with a cue and a content, read where the cue is up, the content act answering with the "
      "content (Learning.Shift's pattern); for every selection through agreement on "
      "the readings that selects the content act, a formation coupled into the cue has a selected twin answering "
      "otherwise at an unread occasion; among laws reading only the content, agreement on the readings fixes the act "
      "there.",
      "例：时有讯与内容，讯起处为读，内容之行以内容答（Learning.Shift 之式，以其位为讯）；凡经读处之合而选且选内容之行者，耦合入讯之形成于一未读之时"
      "有所选之孪生而答异；唯读内容之诸律，于读处合则于此处行定。",
      C(UN, 'Learning.Cue.Occasion', 'Learning.Cue.read', 'Learning.Cue.contentAct', 'Learning.Cue.seen_twin',
        'Learning.Cue.unseen_fixed')),
     ("Witness, the converses fail: a read and an unread occasion differ while their content acts agree; with the "
      "state the occasion and the act its content, states differ and acts agree, and with the coupling the occasion "
      "and the state its content, couplings differ and states agree.",
      "例，其逆不成：一读一未读之时相异而其内容之行同；以时为态、内容为行，则态异而行同；以时为耦合、内容为态，则耦合异而态同。",
      C(UN, 'Learning.Cue.apart_with_content_alike'))],
    [{'en': "Any types of occasions, values and lumps; the freedom and the twin need being in the target's lump decided "
            "and no read occasion lumped with it, and no list or decision of the read occasions.",
      'zh': '时、值与归并之任一型；自由与孪生需「在所求之归并中」可判定且无读处与之同归，读处无需为列或可判定。'},
     {'en': "Where the lumping ties the occasion to a read one, the act is fixed by generalization through lumping "
            "(lumped_determines; exactly there, Learning.determines_lumped_iff, with the read occasions listed, equality "
            "of lumps decided and two act values): read here, cited, not proved again.",
      'zh': '归并系此时于一读处，则其行为归并之泛化所定（lumped_determines；恰在彼处，Learning.determines_lumped_iff，读处为列、归并之相等可判定、'
            '行有二值）：于此读之，引而不重证。'}],
    [{'en': "That fixed is right: for a law reading through the lumping and fitting the world on the read occasions, its "
            "act at an occasion sharing a read one's lump is right exactly where the world agrees at the two "
            "(Learning.lumped_right_iff).",
      'zh': '所定即正：经归并而读且于读处合于世界之律，其于与一读处同归之时之行，恰当世界于二处同值时为正（Learning.lumped_right_iff）。',
      'kind': 'non-implication'},
     {'en': "Intention, anticipation, another's false belief or an incentive to differ where unread.",
      'zh': '意图、预期、他者之误信，或于未读处行异之诱因。', 'kind': 'scope'},
     {'en': "A reader misled: it lies outside the chain of acts, states and couplings apart, in prose only.",
      'zh': '读者为所误：其在行、态、耦合之异之链外，唯以文述之。', 'kind': 'scope'},
     {'en': "Which lumping an actual formation has, and the probabilistic form of the chain (the data-processing "
            "inequality).",
      'zh': '实际之形成有何归并，及链之概率之形（数据处理不等式）。', 'kind': 'scope'}],
    [{'en': "Occasions with a cue: for every selection through agreement on the readings that selects the content act, "
            "a formation coupled into the cue has, at the unread occasion with content true, a selected twin agreeing "
            "with the content act on every reading and answering false (Learning.Cue.seen_twin).",
      'zh': '有讯之时：凡经读处之合而选且选内容之行者，耦合入讯之形成于内容为真之未读之时，有所选之孪生，于每一读处与内容之行合而答假'
            '（Learning.Cue.seen_twin）。'},
     {'en': "A read and an unread occasion differing only in the cue: a state keeping the cue tells them apart while the "
            "content act gives one answer (Learning.Cue.apart_with_content_alike).",
      'zh': '唯讯相异之一读一未读之时：存讯之态分之，而内容之行同答（Learning.Cue.apart_with_content_alike）。'}],
    {'en': "Pure core, every axiom report empty: Unread imports only Learning. It reuses lumped_determines and "
           "Training.unselected_beyond_data, and reads Learning.determines_lumped_iff as the exact form (cited, not used "
           "in a proof); the witnesses are on pairs of truth values.",
     'zh': '纯核，公理报告皆空：Unread 唯引 Learning。其用 lumped_determines 与 Training.unselected_beyond_data，读 '
           'Learning.determines_lumped_iff 为确形（引而未用于证）；诸例于真值之对上。'},
    {'en': "Disclosure or concealment when read, in two stages, with the continuation value represented (RF round 2); a "
           "frozen test of the chain on a trained model with cues varied apart from content; review by a person.",
     'zh': '被读时之示或隐，二阶，带接续之值（RF 第二轮）；于已训之模型上分讯与内容而变之链之冻结检验；人之审查。'},
    {'en': "Indistinguishability: two laws agreeing on every reading are selected alike by every selection through "
           "them. AI reading: read as evaluation and deployment, it locates where behaviour can differ when not read "
           "while every reading agrees, only where the formation's lumping tells the occasion from every read one: a "
           "necessary condition of what deceptive alignment and alignment faking describe (Hubinger and others 2019; "
           "Greenblatt and others 2024), whose intention, anticipation and incentive are not represented. A state "
           "telling read from unread while the act does not differ reads as detection not acted on, and a coupling "
           "taking in the cue while the state keeps only the content as detectable and not detected; measurements of "
           "the first are the chain's failed converse. Read with a supervised reporter, the identification limit of "
           "eliciting latent knowledge (Christiano, Cotra and Xu 2021). The probabilistic form of the chain is the "
           "data-processing inequality. These are readings, not containments.",
     'zh': '不可分辨：于每一读处相合之二律为经读处之每一选所同选。AI 解读：读作评估与部署，其示行为于未读处可异而每一读处皆合之处，唯在形成之归并'
           '分此时于每一读处者：为欺骗对齐与对齐伪装所述者之必要条件（Hubinger 等 2019；Greenblatt 等 2024），其意图、预期与诱因未表。态分读与未读而行'
           '不异，读作察而未据以行；耦合入讯而态唯存内容，读作可察而未察；前者之测为链之逆不成。与受督之报者并读，为引出潜知之辨识之限（Christiano、'
           'Cotra 与 Xu 2021）。链之概率之形为数据处理不等式。皆为读，非包含。'},
    ['what readings fix of the unread', '读处所定于未读处者', 'a twin where it can tell', 'behaviour where not read',
     'Becoming.Learning.free_lumped', 'Becoming.Learning.twin_selected'],
    [dep('generalization-through-lumping',
         "Learning.Lumped, Free, Determines and lumped_determines; Training.Through, AgreeOn and unselected_beyond_data "
         "(determines_lumped_iff and lumped_right_iff cited).",
         'Learning.Lumped、Free、Determines 与 lumped_determines；Training.Through、AgreeOn 与 unselected_beyond_data'
         '（引 determines_lumped_iff 与 lumped_right_iff）。')],
    [{'id': 'what-training-installs', 'detail': {
        'en': "Off its courses a law is installed only where the representation lumps a history with a course. Here the "
              "read occasions are fixed in advance, as data are in generalization through lumping; there the data are "
              "the courses the candidate itself generates, and its twin needs laws reading what has stood to keep them: "
              "the same boundary, with no instance theorem.",
        'zh': '离其所行之迹，律唯于表示将一史与一迹同归处为所装。此处读处预定，如归并之泛化中之资料；彼处资料为候选自生之迹，其孪生需读已立者之律以存之：'
              '界同，无实例之定理。'}},
     {'id': 'what-choices-show-of-an-order', 'detail': {
        'en': "What choices show of an order: the same question for the order a chooser's choices come from.",
        'zh': '所择所示之序：同问于择者之择所出之序。'}}],
    [{'path': LEAN['Learning'], 'role': 'proof', 'sha256': sha(LEAN['Learning'])}],
    CH3,
    {'en': f'{DATE_EN}: added (RF round 1), what readings fix of the unread: the twin where the formation can tell, a '
           f'one-occasion example fixed exactly where ¬¬P, the chain of acts, states and couplings with its '
           f'converses failing, and the cue witnesses; after a review of the plan, a review of the Lean and a cold read '
           f'of the texts; study section {N}.',
     'zh': f'{DATE_ZH}：新增（RF 第一轮），读处所定于未读处者：能分处之孪生，一时之例所定恰当 ¬¬P，行、态、耦合之链及其逆不成，讯之诸例；'
           f'经计划之审、Lean 之审与文之冷读；研究第 {N} 节。'})

CA = 'Becoming.Cascade'
r4 = build(
    'readers-reading-readers', CA,
    {'en': 'Readers reading readers', 'zh': '读者读读者'},
    {'en': "Where every member from member k on, k included, acts alike whatever its own coupling, on every list of "
           "earlier acts, a pool's acts are alike across worlds alike through the couplings of the members before k: "
           "they carry no more than what couples into those members, however many follow.",
     'zh': '自第 k 员起（含第 k 员），每员于每一前行之列皆不论其耦合而同行，则池之行于第 k 员前诸员之耦合无别之二世界皆同：其所载不逾彼诸员之所耦合入，'
           '后继者多寡不论。'},
    [("Members act in turn: member n by its law on its own coupling of the world and the list of the acts before it; "
      "from member k on, every member acting alike whatever its coupling, on every list of earlier acts, and two worlds "
      "alike through the couplings of the members before k, are named.",
      "成员依次而行：第 n 员依其律，于其对世界之耦合及其前之行之列而行；自第 k 员起每员于每一前行之列皆不论其耦合而同行，及于第 k 员前诸员之耦合无别之"
      "二世界，皆有名。",
      C(CA, 'Turns', 'Turns.acts', 'Turns.act', 'Turns.ReadsOnlyActsFrom', 'Turns.AlikeBefore')),
     ("From member k on, k included, where every member reads only the acts before it, two worlds alike through the "
      "couplings of the members before k give every member the same act, and the same list of acts at every length.",
      "自第 k 员起（含第 k 员）每员唯读其前之行，则于第 k 员前诸员之耦合无别之二世界，每员之行皆同，每一长之行列皆同。",
      C(CA, 'Turns.law_alike_of_cascade', 'Turns.acts_alike_of_cascade', 'Turns.act_alike_of_cascade')),
     ("So every selection reading the list of the first N acts, for any N, selects alike any two worlds alike through "
      "the couplings of the members before k.",
      "故凡读首 N 行之列之选，不论 N，于第 k 员前诸员之耦合无别之二世界皆同选。",
      C(CA, 'Turns.cascade_through')),
     ("After the same earlier acts, a member acts differently in two worlds exactly where its law tells apart the "
      "values they give its coupling.",
      "前行相同之后，一员于二世界行异，恰当其律分二世界予其耦合之值。",
      C(CA, 'Turns.separates_at')),
     ("Copying: the first member acts on its own coupling and every later one copies the first act before it; it is a "
      "cascade from the second member, and two worlds alike through the first member's coupling give every member the "
      "same act.",
      "相仿：首员依其耦合而行，其后每员仿其前之首行；此自第二员起为级联，于首员之耦合无别之二世界，每员之行皆同。",
      C(CA, 'Turns.Copying.turns', 'Turns.Copying.readsOnlyActs', 'Turns.Copying.reaches_first_only'))],
    [{'en': "Any types of worlds, couplings and acts; members indexed by the natural numbers, each reading the whole list "
            "of acts before it.",
      'zh': '世界、耦合与行之任一型；成员以自然数为序，各读其前之全部行列。'},
     {'en': "From member k on, k included, every member acts alike whatever its own coupling, on every list of earlier "
            "acts, histories no run reaches included; member k's coupling is then not read, so it is not among those the "
            "acts reach.",
      'zh': '自第 k 员起（含第 k 员），每员于每一前行之列（未行至之史亦然）皆不论其耦合而同行；故第 k 员之耦合不为所读，不在诸行所及之中。'}],
    [{'en': "When an actual member stops reading its own coupling: in the probabilistic model (Bikhchandani, Hirshleifer "
            "and Welch 1992), once the public evidence outweighs any private signal, a premise here.",
      'zh': '实际之员何时不复读其耦合：于概率之模型（Bikhchandani 等 1992），公示之据重于任一私讯之时；此处为前提。',
      'kind': 'non-implication'},
     {'en': "That a cascade errs: it suppresses what later members' couplings carry, and can be accurate.",
      'zh': '级联必误：其抑后员之耦合所载者，可为准。', 'kind': 'non-implication'},
     {'en': "That a pool's later selection keeps a coupling one member's act carries.",
      'zh': '池之后选存一员之行所载之耦合。', 'kind': 'non-implication'},
     {'en': "Weighted averaging (DeGroot 1974) and its wisdom condition (Golub and Jackson 2010); a bound depending on "
            "who reads whom (laws ignoring some earlier acts are covered); members in no well-founded order.",
      'zh': '加权平均（DeGroot 1974）及其智之条件（Golub 与 Jackson 2010）；依谁读谁之界（不读某些前行之律已含）；无良基之序之成员。',
      'kind': 'scope'}],
    [{'en': "Copying: worlds differing in every member's coupling but the first give every member the same act "
            "(Turns.Copying.reaches_first_only).",
      'zh': '相仿：除首员外每员之耦合皆异之二世界，每员之行皆同（Turns.Copying.reaches_first_only）。'}],
    {'en': "Pure core, every axiom report empty: Cascade imports Learning for Training.Through only; the acts are built by "
           "recursion on the number of members.",
     'zh': '纯核，公理报告皆空：Cascade 引 Learning 唯为 Training.Through；诸行以成员之数递归而建。'},
    {'en': "The probabilistic form, a cascade once public evidence outweighs every private signal; a test predicting when "
           "sequential choosers stop reading their own signals; review by a person.",
     'zh': '概率之形，公示之据重于每一私讯时之级联；预测依次之择者何时不复读其私讯之检验；人之审查。'},
    {'en': "The deterministic form of an information cascade (Bikhchandani, Hirshleifer and Welch 1992; Banerjee 1992), "
           "where the act has stopped reading the member's own signal; WitnessRefinementRuns.copied_witnesses_same is a "
           "neighbour, where copied witnesses add nothing under its further hypotheses. AI reading: copying as the "
           "dependence failure of Condorcet's jury theorem; echo chambers, or evaluators trained on one another's "
           "verdicts, under the cascade premise. These are readings, not containments.",
     'zh': '信息级联之定形（Bikhchandani、Hirshleifer 与 Welch 1992；Banerjee 1992），行已不读员之私讯者；'
           'WitnessRefinementRuns.copied_witnesses_same 为其邻，其另加诸前提下仿制之证人无所增。AI 解读：相仿为 Condorcet 陪审定理之依存之失；'
           '回声室，或以彼此之判而训之评者，于级联之前提下。皆为读，非包含。'},
    ['readers reading readers', '读者读读者', 'a cascade', '级联', 'Becoming.Turns.acts_alike_of_cascade',
     'Becoming.Turns.Copying.reaches_first_only'],
    [dep('generalization-through-lumping', "Training.Through, the selection through a relation of being alike.",
         'Training.Through：经无别之关系之选。')],
    [{'id': 'what-pooled-coupling-reaches', 'detail': {
        'en': "A pool reaches no further than the union of its members' closures; where, from some member on, every "
              "member reads only the acts before it, a selection through the acts reaches only what couples into the "
              "members before that one.",
        'zh': '池之所及不逾其诸员之闭包之并；自某员起每员唯读其前之行之处，经诸行之选唯及彼员前诸员之所耦合入。'}}],
    [{'path': LEAN['Learning'], 'role': 'proof', 'sha256': sha(LEAN['Learning'])}],
    CH5,
    {'en': f'{DATE_EN}: added (RF round 1), readers reading readers: from a cascade on, a pool\'s acts carry no more than '
           f'the couplings of the members before it; a member carrying its coupling; copying; after a review of the '
           f'plan, a review of the Lean and a cold read of the texts; study section {N}.',
     'zh': f'{DATE_ZH}：新增（RF 第一轮），读者读读者：自级联起池之行所载不逾其前诸员之耦合；载其耦合之员；相仿；经计划之审、Lean 之审与文之冷读；'
           f'研究第 {N} 节。'})

if CAPS_ONLY:
    raise SystemExit(0)
for record in (r1, r2, r4):
    for rid in [x['id'] for x in record['dependencies']] + [x['id'] for x in record['related']]:
        assert (RECORDS / f'{rid}.json').exists() or rid in ('what-choices-show-of-an-order',
                                                             'what-readings-fix-of-the-unread'), rid
    path = RECORDS / f"{record['id']}.json"
    assert not path.exists(), path
    path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print('record:', record['id'], sum(len(x['declarations']) for x in record['laws']), 'declarations in',
          len(record['laws']), 'laws')
