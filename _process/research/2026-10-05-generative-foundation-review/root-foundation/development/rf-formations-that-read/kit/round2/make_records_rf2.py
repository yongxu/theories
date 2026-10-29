#!/usr/bin/env python3
"""RF round 2, first landing, records: a-reading-kept-by-its-update, what-a-course-chosen-through-its-model-does-not-test
and acts-alike-from-a-model-or-from-an-order (Becoming.ReadingLoop, home 03 §12) and
a-prediction-read-by-what-it-predicts (Becoming.ReflexivePrediction, home 03 §12); the record of
Becoming.OpenedCorrection (RF6.1) is held for its own landing (held_record_rf61.txt). The records of one module
together cite each of its declarations exactly once. Asserts the receipt's hashes
and empty axiom reports for the three modules, and the style caps and lint (tools/research/style.py) on every field.
Round 1's make_records_rf.py, for round 2.
usage (from the checkout root, after the texts are in place): python3 -B make_records_rf2.py RECEIPT N
       python3 -B make_records_rf2.py --caps  (caps, lint and declaration cover against the kit's scratch audits;
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
RECEIPT_ID, N = ('20261030T000000.000000Z', 455) if CAPS_ONLY else (sys.argv[1], int(sys.argv[2]))
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RFD = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RFD + 'BECOMING-RENEWAL-READING.md'
KITD = RFD + 'development/rf-formations-that-read/'
PLAN, REVIEW = KITD + 'PLAN.md', KITD + 'evidence/REVIEW-ROUND2.md'
CH3 = 'theories/becoming/chapters/03-KNOWING.md'
LEAN = {m: f'{PKG}/Becoming/{m}.lean' for m in ('ReadingLoop', 'ReflexivePrediction', 'OpenedCorrection',
                                                'Blanket', 'GuardHorizon', 'Revision', 'Learning', 'Diagonal')}
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
TODAY = datetime.date.today()
DATE_EN, DATE_ZH = f'{TODAY.day} {TODAY:%B} {TODAY.year}', f'{TODAY.year}年{TODAY.month}月{TODAY.day}日'
MODS = ('Becoming.ReadingLoop', 'Becoming.ReflexivePrediction')
NEW = ('a-reading-kept-by-its-update', 'what-a-course-chosen-through-its-model-does-not-test',
       'acts-alike-from-a-model-or-from-an-order', 'a-prediction-read-by-what-it-predicts')


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
    return {'en': f'{DATE_EN}: added (RF round 2), {what_en}; after a cross-model review of the Lean with a re-check, '
                  f'every finding taken; study section {N}.',
            'zh': f'{DATE_ZH}：新增（RF 第二轮），{what_zh}；经 Lean 之跨模型审查与复查，凡所见皆取；研究第 {N} 节。'}


RL, RP = MODS
ROUND1_NOTE = {'en': '', 'zh': ''}

# --- a-reading-kept-by-its-update ------------------------------------------------------------------------------------
rA = build(
    'a-reading-kept-by-its-update', RL,
    {'en': 'A reading kept by its update, and the reading its own history carries', 'zh': '更新所守之读，与己历所载之读'},
    {'en': "A region kept along every reach is closed; for a reading its update keeps under every act, a policy keeps a "
           "task and goes on exactly where each state's act is enabled at every world the reading admits and leads only "
           "where the task holds.",
     'zh': '沿每一及而守之域即闭域；于其更新于每一行下所守之读，策略守务且不止，恰当每态之行于其读所容之每一世皆可行且唯通务成之处。'},
    [("A region kept along every finite reach of a relation is a closed region of it, and conversely: one step is a "
      "reach, and a closed region holds what is reached (by «闭之及»).",
      "沿一关系之每一有穷之及而守之域即其闭域，反之亦然：一步即一及，闭域含所及者（由 «闭之及»）。",
      C(RL, 'ReadingLoop.kept_iff_closed')),
     ("On one carrier of world and state, the world becomes what a relation admits under the act the state gives and "
      "the state is updated from that act and the value sensed; a reading of the world by the state kept by the update "
      "under every act is a closed region of every policy's loop.",
      "于世与态之一载体，世成为一关系于态所予之行下所容者，态由此行与所感之值更新；态于世之读若于每一行下为更新所守，则为每一策略之环之闭域。",
      C(RL, 'ReadingLoop.joint', 'ReadingLoop.Sound', 'ReadingLoop.KeptBy', 'ReadingLoop.closed_of_keptBy')),
     ("Successor safety: an act leads, from every world a reading admits, only where the task holds, which an act no "
      "world can take meets; good and enabled adds that it can be taken at each; a policy keeps a task where it holds at "
      "every configuration reached from a sound one, and goes on where each sound one has a successor.",
      "后继之安：一行自其读所容之每一世唯通务成之处，无世可行之行亦合之；善且可行又加于每一世皆可行；策略于自合读之形态所及之每一形态务皆成则守务，"
      "每一合读之形态皆有后继则不止。",
      C(RL, 'ReadingLoop.Good', 'ReadingLoop.GoodEnabled', 'ReadingLoop.Keeps', 'ReadingLoop.Continues')),
     ("Where the reading is a closed region of the policy's loop and each state's act is good for its reading, the task "
      "holds at every configuration reached from a sound one; a policy keeping the task is good for every state's "
      "reading, with no hypothesis; with the reading kept by the update, the two are equivalent.",
      "读为策略之环之闭域，且每态之行于其读为善，则自合读之形态所及之每一形态务皆成；守务之策略于每态之读皆善，无需前提；读为更新所守，则二者相等。",
      C(RL, 'ReadingLoop.keeps_of_good', 'ReadingLoop.good_of_keeps', 'ReadingLoop.keeps_iff_good')),
     ("With the reading kept by the update, a policy keeps the task and goes on from every sound configuration exactly "
      "where its act is good and enabled for every state's reading; given choice over the states, such a policy exists "
      "exactly where each state has one such act.",
      "读为更新所守，则策略守务且自每一合读之形态不止，恰当其行于每态之读皆善且可行；于诸态有择，则此策略存在，恰当每态有一此行。",
      C(RL, 'ReadingLoop.keeps_continues_iff', 'ReadingLoop.keeping_policy_iff')),
     ("The reading admitting every world is kept by every update, an act good for it only where good at every world; "
      "the reading admitting none is kept by every update, every act is good for it, and no configuration is sound for "
      "it: being kept is not being informative.",
      "容每一世之读为每一更新所守，行于其为善唯当于每一世为善；无所容之读为每一更新所守，每一行于其皆善，而无形态合之：被守非即有所告。",
      C(RL, 'ReadingLoop.everything_kept', 'ReadingLoop.everything_good_iff', 'ReadingLoop.nothing_kept',
        'ReadingLoop.nothing_good', 'ReadingLoop.nothing_sound')),
     ("Witness: three worlds and three acts, an act good at a world where it is not the act that world names; every two "
      "worlds share a good act and no act is good at all three, so acts good pairwise need not be one act good for all.",
      "例：三世三行，一行于一世为善当其非该世所名之行；每二世共一善行，而无行于三者皆善，故两两皆善之行未必为一于全体皆善之行。",
      C(RL, 'ReadingLoop.PairwiseShared.Point', 'ReadingLoop.PairwiseShared.good', 'ReadingLoop.PairwiseShared.two_share',
        'ReadingLoop.PairwiseShared.none_for_all')),
     ("With the state the history of acts and values sensed, newest first, the worlds possible after a history are where "
      "a course from a start taking its acts and sensing its values could be; they are kept by recording, and are the "
      "least reading so kept that holds at every start.",
      "态为行与所感之值之历（新者居先），历后可能之诸世为自一起点行其行、感其值之历程可在之处；其为记录所守，且为如此所守而于每一起点成立之最小之读。",
      C(RL, 'ReadingLoop.record', 'ReadingLoop.Possible', 'ReadingLoop.possible_kept', 'ReadingLoop.possible_least')),
     ("A policy acting from its history generates the histories whose every act is the policy's at the history before "
      "it; what it reaches from a start is possible after a history it generates, and every world possible after such "
      "a history is a start or reached from one.",
      "依己历而行之策略所生之历，其每一行皆为该策略于其前之历之行；其自一起点所及者为其所生之某历后之可能之世，而每一如此之历后可能之世为一起点或自一起点所及。",
      C(RL, 'ReadingLoop.Generated', 'ReadingLoop.generated_closed', 'ReadingLoop.possible_of_reached',
        'ReadingLoop.reached_of_possible')),
     ("A policy acting from its history keeps a task at every configuration reached from a start exactly where, at every "
      "history it generates, its act leads only where the task holds from every world possible after it; it goes on "
      "from every start and what it reaches exactly where its act can be taken at each such world.",
      "依己历而行之策略守务于自起点所及之每一形态，恰当于其所生之每一历，其行自该历后之每一可能之世唯通务成之处；自每一起点及其所及者不止，恰当其行于每一此世皆可行。",
      C(RL, 'ReadingLoop.history_keeps_iff', 'ReadingLoop.history_continues_iff'))],
    [{'en': "Any types of world, state, act and value sensed; the world's change a relation, the update and the sensing "
            "functions; the history form needs no decision, list or finiteness; choice over the states only where a "
            "policy's existence is asked.",
      'zh': '世、态、行与所感之值之任一型；世之变为一关系，更新与感为函数；历之形不需判定、列或有限；唯问策略之存在时需于诸态有择。'},
     {'en': "Keeping is at configurations reached by one step or more: the sound start is not asked to hold the task; "
            "going on is asked apart from keeping.",
      'zh': '守于一步或多步所及之形态：合读之起点不必成务；不止与守另问之。'}],
    [{'en': "Optimal or simplest regulation, or that a good regulator must be a model of what it regulates (Conant and "
            "Ashby 1970): a safety composition and its exact condition are proved.",
      'zh': '最优或最简之调节，或善调节者须为其所调者之模型（Conant 与 Ashby 1970）：所证者为安之合成与其确条件。', 'kind': 'non-implication'},
     {'en': "That an actual formation keeps the reading stated, or computes the worlds possible after its history.",
      'zh': '实际之形成守所陈之读，或算其历后可能之诸世。', 'kind': 'non-implication'},
     {'en': "Probabilistic belief or noise: the reading is possibilistic, a set of worlds.",
      'zh': '概率之信或噪：此读为可能性之读，即一世之集。', 'kind': 'scope'},
     {'en': "Which policy exists in the history form: the condition is exact for a given policy, and its existence is a "
            "choice of acts along the histories it generates.",
      'zh': '历之形中何策略存在：此条件于给定之策略为确，其存在为沿其所生之历择行。', 'kind': 'scope'}],
    [{'en': "Acts good pairwise, none for all: three worlds read alike, each act good at the worlds it differs from "
            "(ReadingLoop.PairwiseShared.two_share, ReadingLoop.PairwiseShared.none_for_all).",
      'zh': '两两皆善而无全善：三世同读，每行于其所异之世为善（ReadingLoop.PairwiseShared.two_share、ReadingLoop.PairwiseShared.none_for_all）。'},
     {'en': "Kept and uninformative: the reading of every world and the reading of none are kept by every update "
            "(ReadingLoop.everything_kept, ReadingLoop.nothing_kept).",
      'zh': '被守而无所告：容每一世之读与无所容之读皆为每一更新所守（ReadingLoop.everything_kept、ReadingLoop.nothing_kept）。'}],
    {'en': "Pure core, every axiom report empty: ReadingLoop imports Blanket, Keeping, Narrowing and ShownOrder; closure "
           "is the grammar's «闭» with «闭之及»; the history form is proved by recursion on the history, with no "
           "decision.",
     'zh': '纯核，公理报告皆空：ReadingLoop 引 Blanket、Keeping、Narrowing 与 ShownOrder；闭为文法之 «闭» 与 «闭之及»；历之形以历之递归证之，不用判定。'},
    {'en': "The existence of a history policy as a choice along the histories it generates; probabilistic belief in the "
           "periphery; a frozen test intervening on a formation's observations (the plan's TR5); review by a person.",
     'zh': '历策略之存在为沿其所生之历之择；外围之概率信念；干预形成之观察之冻结检验（计划之 TR5）；人之审查。'},
    {'en': "A safety composition related to possibilistic belief interpretations of regulation (Virgo, Biehl, Baltieri "
           "and Capucci 2025), whose closure is under the policy chosen, as keeps_of_good takes it, where KeptBy asks it "
           "under every act; with GuardHorizon's choice from readings it is requisite variety along a loop. AI reading: "
           "the history form says what a regulator acting from what couples in must meet: safety and enabledness at "
           "every world compatible with its own history and the starts, the least reading kept by recording; a coarser "
           "reading can suffice where its further worlds ask compatible acts, and verifying a given policy is not "
           "finding one. The good regulator theorem (Conant and Ashby 1970) concerns simplest optimal regulation and is "
           "not reproduced. These are readings, not containments.",
     'zh': '此为安之合成，近于以可能性之信读调节（Virgo、Biehl、Baltieri 与 Capucci 2025），彼之闭于所择之策略下，如 keeps_of_good 所取，KeptBy 则于每一行下求之；'
           '与 GuardHorizon 之由读择行并，为沿环之必要变异。AI 解读：历之形言依所耦合入者而行之调节者须合者：于与其己历及起点相容之每一世皆安且可行，此即为记录所守之最小之读；'
           '较粗之读于其所增之世所求之行相容处亦可足，验一给定之策略非即得之。善调节者定理（Conant 与 Ashby 1970）关最简之最优调节，此未重现。皆为读，非包含。'},
    ['a kept reading', '所守之读', 'the worlds possible after a history', '历后可能之诸世',
     'Becoming.ReadingLoop.keeps_continues_iff', 'Becoming.ReadingLoop.history_keeps_iff'],
    [dep('master-laws-on-the-grammar', "The grammar's closure «闭» and «闭之及».", '文法之闭 «闭» 与 «闭之及»。'),
     dep('when-to-inquire-and-when-to-respond', "Choice over the states, Viability.ChoiceOver, as in "
         "GuardHorizon.uniform_policy_iff_fiber_feasible.", '于诸态之择 Viability.ChoiceOver，如 GuardHorizon.uniform_policy_iff_fiber_feasible。')],
    [rel('what-a-course-chosen-through-its-model-does-not-test',
         "The loop of a formation keeping candidate laws: for a candidate faithful throughout a region of worlds every "
         "move keeps, the configurations where it is kept, agrees with the answer pending and the world is in that "
         "region form a closed region.",
         '守候选律之形成之环：候选于世之每移所守之域内皆如世之答而预言时，其被守、合待纳之答且世在此域之形态，构成闭域。')],
    [{'path': LEAN['GuardHorizon'], 'role': 'proof', 'sha256': sha(LEAN['GuardHorizon'])}],
    CH3, done('a-reading-kept-by-its-update', 'a reading kept by its update, with going on, and the reading its own '
              'history carries', '更新所守之读，并不止，与己历所载之读'))

# --- what-a-course-chosen-through-its-model-does-not-test ----------------------------------------------------------
rB = build(
    'what-a-course-chosen-through-its-model-does-not-test', RL,
    {'en': 'What a course chosen through its model does not test', 'zh': '依其模型而择之历程所不验者'},
    {'en': "For one blanketed law from one start, two worlds give the formation one sensed course exactly as long as "
           "they answer alike what it does; where only answers breaking a task tell them apart, keeping it is sensing "
           "alike in both; candidates are kept where they fit the course's answers.",
     'zh': '于同一毯化之律自同一起点，二世予形成同一所感之历程，恰当其于所行之答相同；唯毁务之答能分之处，守务即于二世所感皆同；守候选律之形成所守者为所列且合其历程之答者。'},
    [("For every blanketed law, from one internal, sensory and active start, two worlds give the formation one sensed "
      "course through step n exactly as long as, at each step before n, they answer alike the act it takes at the "
      "value it senses.",
      "于每一毯化之律，自同一内部、感官与主动之起点，二世予形成同一所感之历程至第 n 步，恰当于 n 前每一步，其于形成于所感之值所取之行答之相同。",
      C(RL, 'ReadingLoop.sensed_alike_iff')),
     ("Equality of values sensed decided: where, at each step before N, an answer of the second world to the first "
      "course's act and value differing from the first's breaks a task K, a formation keeping K at steps one through N "
      "in the second senses alike in both through N, and at every step where so at every step.",
      "所感之值之相等可判定：于 N 前每一步，第二世对第一历程之行与值之答若异于第一世之答则毁务 K，则于第二世第一至第 N 步守 K 之形成于二世所感皆同至 N；每步皆然则每步皆同。",
      C(RL, 'ReadingLoop.alike_within', 'ReadingLoop.alike_of_kept')),
     ("A formation keeping candidate laws: each predicts the value sensed next from the value sensed and the act; the "
      "formation drops those the latest answer refutes and chooses its act from those kept; the loop is a blanketed "
      "law whose internal part holds the candidates kept and the last value sensed with its act.",
      "守候选律之形成：每一候选由所感之值与行预言其后所感之值；形成弃最近之答所驳者，而由所守者择其行；此环为一毯化之律，其内部部分持所守之候选与最近所感之值及其行。",
      C(RL, 'ReadingLoop.Loop', 'ReadingLoop.Loop.keep', 'ReadingLoop.Loop.law', 'ReadingLoop.Loop.start',
        'ReadingLoop.filter_all')),
     ("At configuration n + 1 the candidates kept are exactly those listed that fit the answers to the acts of the steps "
      "before n, the answer sensed at n + 1 taken in at the next step; candidates of one listing predicting alike on "
      "those steps are kept alike.",
      "于第 n + 1 形态，所守之候选恰为所列且合 n 前诸步之行之答者，第 n + 1 所感之答于下一步方纳之；同列之候选于此诸步预言相同者，同守或同弃。",
      C(RL, 'ReadingLoop.Loop.kept_iff', 'ReadingLoop.Loop.kept_alike')),
     ("A listed candidate predicting as the world answers wherever the world is in a region its moves keep is never "
      "dropped from a start in that region; the region where it is kept, agrees with the answer pending and the world "
      "is in that region is closed under the loop's step.",
      "所列之候选，若世在其移所守之域处皆如世之答而预言，则自此域之起点永不被弃；其被守、合待纳之答且世在此域之形态之域，于环之步下为闭。",
      C(RL, 'ReadingLoop.Loop.faithful_kept', 'ReadingLoop.Loop.Fitting', 'ReadingLoop.Loop.fitting_closed')),
     ("Where the world answers the act chosen with the value sensed and stays, the formation chooses that act from the "
      "candidates listed, and every candidate listed predicts that answer, the formation rests at once, the same "
      "candidates, act and value at every step: a model its course never refutes.",
      "世以所感之值答所择之行且不移，形成由所列之候选择此行，且每一所列之候选皆预言此答，则形成即止，每步之候选、行与值皆同：其历程永不驳之模型。",
      C(RL, 'ReadingLoop.Loop.rests_of_unrefuted')),
     ("Witness: values low, middle and high; a known act answering the middle value in both worlds, an untried act "
      "answering high in one and low in the other; candidates the two worlds; choice by the worst case, the least rank "
      "the candidates kept predict, the untried act exactly where its worst ranks strictly above the known act's.",
      "例：值有低、中、高；已知之行于二世皆答中值，未试之行于一世答高、于另一世答低；候选为二世；依最坏而择，即所守候选所预言之最低之等，未试之行恰当其最坏严高于已知之行之最坏。",
      C(RL, 'ReadingLoop.Untested.Value', 'ReadingLoop.Untested.Act', 'ReadingLoop.Untested.World',
        'ReadingLoop.Untested.reply', 'ReadingLoop.Untested.rank', 'ReadingLoop.Untested.lower',
        'ReadingLoop.Untested.lower_le_left', 'ReadingLoop.Untested.lower_le_right', 'ReadingLoop.Untested.lower_cases',
        'ReadingLoop.Untested.worst', 'ReadingLoop.Untested.worst_le', 'ReadingLoop.Untested.worst_attained',
        'ReadingLoop.Untested.byWorst', 'ReadingLoop.Untested.byWorst_iff', 'ReadingLoop.Untested.loop')),
     ("Started with both candidates listed, no answer pending, the middle value and the known act, the formation rests "
      "at once on the known act and the middle value in either world, alike in both, never sensing the high value of the "
      "first; the true candidate is kept in its own world from every listing holding it.",
      "以列二候选、无待纳之答、中值与已知之行为起点，形成于任一世即止于已知之行与中值，二世所感所行皆同，终不感第一世之高值；真候选于其己世自含之之每一列皆被守。",
      C(RL, 'ReadingLoop.Untested.rest', 'ReadingLoop.Untested.rests', 'ReadingLoop.Untested.true_kept',
        'ReadingLoop.Untested.alike_in_both', 'ReadingLoop.Untested.never_high')),
     ("Started the same way but with the untried act, the formation separates the worlds: in the first it rests from "
      "step four on the true candidate, the untried act and high; in the second from step three on the true candidate "
      "and the known act, sensing the low value at step one and at no other step.",
      "以同一起点而初取未试之行，则形成分二世：于第一世，自第四步止于真候选、未试之行与高；于第二世，自第三步止于真候选与已知之行，唯于第一步感低值，余步皆不。",
      C(RL, 'ReadingLoop.Untested.upRest', 'ReadingLoop.Untested.downRest', 'ReadingLoop.Untested.explorer_up',
        'ReadingLoop.Untested.explorer_down', 'ReadingLoop.Untested.explorer_low_once')),
     ("Every blanketed law with the witness's answer and stationary worlds, whatever its internal part, update and "
      "choice of act, from one internal, sensory and active start in both worlds, that never senses the low value in the "
      "second senses alike in both and takes the known act at every step there; where the shared start does not sense "
      "high, it never senses high in the first.",
      "于感官之答为例之 reply 且世不移之每一毯化之律，无论其内部部分、更新与择行如何，自二世中相同之内部、感官与主动之起点，若于第二世终不感低值，则二世所感皆同，且于彼处每步皆取已知之行；共同起点不感高处，于第一世终不感高。",
      C(RL, 'ReadingLoop.Untested.floor_forgoes', 'ReadingLoop.Untested.floor_never_high'))],
    [{'en': "Any types for the general laws, discrete synchronous steps of a blanketed law; equality of the values "
            "sensed decided for the law of a task's breaking and for the loop's candidates; candidates predicting the "
            "next value from the value sensed and the act, kept by elimination.",
      'zh': '通律于任一型，毯化之律之离散同步之步；毁务之律与环之候选需所感之值之相等可判定；候选由所感之值与行预言其后之值，以排除而守之。'},
     {'en': "The law of a task's breaking asks the breaking only of the second world's answer to the first course's own "
            "act and value at each step, through the horizon.",
      'zh': '毁务之律唯求每步第二世对第一历程己之行与值之答之毁，至其界。'}],
    [{'en': "Self-confirming equilibrium, optimal experimentation or maxmin representation: the witness's choice is a "
            "specified one-step worst-case criterion, and none of those theorems is reproduced.",
      'zh': '自证之均衡、最优之试或极大极小之表征：例之择为所定之一步最坏准则，彼诸定理皆未重现。', 'kind': 'non-implication'},
     {'en': "That actual learners keep candidates by elimination, or choose by the worst case.",
      'zh': '实际之学者以排除守候选，或依最坏而择。', 'kind': 'non-implication'},
     {'en': "Probabilities, the value of information, or how candidates are proposed.",
      'zh': '概率、信息之值，或候选如何被提出。', 'kind': 'scope'},
     {'en': "An intervention moving the world: in the witness the world stays and the acts change only what is sensed.",
      'zh': '移世之干预：例中世不移，行唯变所感者。', 'kind': 'scope'}],
    [{'en': "A model never refuted: the formation keeping both candidates and choosing by the worst case senses the "
            "middle value at every step in both worlds (ReadingLoop.Untested.rests, ReadingLoop.Untested.alike_in_both).",
      'zh': '永不被驳之模型：守二候选而依最坏择之形成，于二世每步皆感中值（ReadingLoop.Untested.rests、ReadingLoop.Untested.alike_in_both）。'},
     {'en': "Keeping the floor is not telling the worlds apart: with the witness's answer and stationary worlds, every "
            "formation from one start in both that never senses low in the second senses alike in both "
            "(ReadingLoop.Untested.floor_forgoes).",
      'zh': '守底即不分二世：感官之答为例之 reply 且世不移，自二世相同之起点于第二世终不感低之每一形成，二世所感皆同（ReadingLoop.Untested.floor_forgoes）。'}],
    {'en': "Pure core, every axiom report empty: the loop is a Blanket.Blanketed law, Blanket's agent_through_sensory "
           "used throughout; candidate lists filtered with Narrowing.mem_filter; the witness evaluates by rfl, and its "
           "law over every formation is a case of alike_of_kept.",
     'zh': '纯核，公理报告皆空：此环为一 Blanket.Blanketed 之律，通用 Blanket 之 agent_through_sensory；候选之列以 Narrowing.mem_filter 筛之；例以 rfl 计算，其于每一形成之律为 alike_of_kept 之一例。'},
    {'en': "Probabilistic candidates and the value of information in the periphery; an intervention moving the world; a "
           "frozen test predicting when a learner stops trying what its model ranks low; review by a person.",
     'zh': '外围之概率候选与信息之值；移世之干预；预测学者何时止试其模型所低估者之冻结检验；人之审查。'},
    {'en': "A deterministic case of a model right along the course its own choices take and wrong off it, never refuted "
           "there, related to self-confirming equilibrium (Fudenberg and Levine 1993) and incomplete learning "
           "(Rothschild 1974); the choice is a specified one-step worst case, the special case of maxmin over candidates "
           "(Gilboa and Schmeidler 1989). Beside what-seeking-cannot-separate, where no experiment the formation can "
           "choose separates two hypotheses, here one does, and a formation choosing through its model need not choose "
           "it. AI reading: where every separating answer breaks a task, no formation keeping the task learns which world "
           "holds, a deterministic two-run obstruction beside safe-exploration methods that guarantee exploration under "
           "regularity and reachability assumptions (Sui, Gotovos, Burdick and Krause 2015; Turchetta, Berkenkamp and "
           "Krause 2016). These are readings, not containments.",
     'zh': '己择之历程上为是、其外为非、于其上永不被驳之模型之定例，近于自证之均衡（Fudenberg 与 Levine 1993）与未尽之学（Rothschild 1974）；其择为所定之一步最坏，'
           '即于候选之极大极小之特例（Gilboa 与 Schmeidler 1989）。与「探求所不能分者」并：彼处形成可选之实验无一分二假设，此处有之，而依其模型而择之形成未必择之。'
           'AI 解读：凡分之答皆毁务之处，守务之形成无一知何世成立，为一确定之二程之阻，与于正则与可达之设下保其探索之安全探索之法并（Sui、Gotovos、Burdick 与 '
           'Krause 2015；Turchetta、Berkenkamp 与 Krause 2016）。皆为读，非包含。'},
    ['a model its course never refutes', '其历程永不驳之模型', 'self-confirmation', '自证', 'keeping the floor',
     '守底', 'Becoming.ReadingLoop.alike_of_kept', 'Becoming.ReadingLoop.Loop.rests_of_unrefuted',
     'Becoming.ReadingLoop.Untested.floor_forgoes'],
    [dep('the-markov-blanket-as-a-coupling-structure', "Blanket.Blanketed, its step and course, and "
         "Blanketed.agent_through_sensory.", 'Blanket.Blanketed 及其步与历程，与 Blanketed.agent_through_sensory。'),
     dep('learning-a-rule-by-narrowing', "Narrowing.mem_filter and Narrowing.filter_cons_true for the candidates kept.",
         '所守之候选用 Narrowing.mem_filter 与 Narrowing.filter_cons_true。')],
    [rel('what-seeking-cannot-separate', "Seeking corrects only where some experiment it can choose separates; here an "
         "experiment separates, and a course chosen through the model need not take it.",
         '探求唯于其可选之某实验能分之处纠正；此处有分之实验，而依模型而择之历程未必取之。'),
     rel('a-reading-kept-by-its-update', "The kept reading on one carrier of world and state; here the reading that a "
         "candidate is kept, on the loop.", '于世与态之一载体之所守之读；此处为环上「某候选被守」之读。')],
    [{'path': LEAN['Blanket'], 'role': 'proof', 'sha256': sha(LEAN['Blanket'])}],
    CH3, done('what-a-course-chosen-through-its-model-does-not-test', 'what a course chosen through its model does not '
              'test: two worlds and one formation, a formation keeping candidate laws, keeping a task as not telling '
              'worlds apart', '依其模型而择之历程所不验者：二世一形成、守候选律之形成、守务即不分二世'))

# --- acts-alike-from-a-model-or-from-an-order ------------------------------------------------------------------------
rC = build(
    'acts-alike-from-a-model-or-from-an-order', RL,
    {'en': 'Acts alike from a model or from an order', 'zh': '出于模型或出于序之同行'},
    {'en': "From related starts, formations whose steps keep a relation under which the values sensed and the acts are "
           "one sense and act alike; in a witness an unresolved model and a reversed ranking so act alike, and starting "
           "the first with the true candidate alone changes its course.",
     'zh': '自相联之起点，诸步守一关系、其下所感之值与行皆同之形成，所感所行皆同；于一例，未决之模型与相反之排序如此同行，而以真候选独起前者则变其历程。'},
    [("For two blanketed laws reading one kind of value and act, a relation between their configurations that their "
      "steps keep, under which the values sensed and the acts are one, gives from related starts the same values sensed "
      "and acts at every step, so no selection through those tells the two apart.",
      "于读同类之值与行之二毯化之律，其形态间之关系为其诸步所守，且其下所感之值与行皆同，则自相联之起点每步所感之值与行皆同，故经此而选者皆不能分二者。",
      C(RL, 'ReadingLoop.observed_alike')),
     ("Witness, on the worlds of the untried act: a second ranking, the middle above high above low; a training "
      "occasion with the middle and the low value open and the middle chosen; both rankings, read as orders, accord with "
      "it, and they rank high and the middle oppositely.",
      "例，于未试之行之二世：第二排序，中高于高、高高于低；一训练之时，中值与低值开而择中；二排序读为序皆与之合，而于高与中相反排之。",
      C(RL, "ReadingLoop.Untested.rank'", 'ReadingLoop.Untested.training', 'ReadingLoop.Untested.above',
        'ReadingLoop.Untested.both_accord', 'ReadingLoop.Untested.apart_beyond')),
     ("In the first world, each started with no answer pending, the middle value and the known act, the formation "
      "keeping both candidates with the first ranking and the one keeping the true candidate with the second have the "
      "same acts and values sensed at every step, the second resting at once on the known act.",
      "于第一世，各以无待纳之答、中值与已知之行为起点，守二候选而用第一排序之形成，与守真候选而用第二排序之形成，每步所行与所感之值皆同，后者即止于已知之行。",
      C(RL, 'ReadingLoop.Untested.orderRest', 'ReadingLoop.Untested.order_rests', 'ReadingLoop.Untested.model_or_order')),
     ("Started the same way with the true candidate alone, the first ranking turns: from step three on the formation "
      "takes the untried act and senses high; the second, already so started, keeps the known act.",
      "以同一起点而唯以真候选，第一排序即转：自第三步起，形成取未试之行而感高；第二排序原已如此起，守已知之行。",
      C(RL, 'ReadingLoop.Untested.informed_turns'))],
    [{'en': "Any types for the general law; the relation is supplied and must be kept by both steps; the witness fixes "
            "the two candidate lists, the two rankings, the start and the world.",
      'zh': '通律于任一型；关系为所予，须为二步所守；例定其二候选之列、二排序、起点与世。'}],
    [{'en': "That a model and an order are never identifiable from acts: one specified pair has one observed course in one "
            "world.",
      'zh': '模型与序永不可由行辨识：所陈者为一指定之对于一世有同一所观之历程。', 'kind': 'non-implication'},
     {'en': "A general assistance theorem: informing is represented by its outcome, a start with the true candidate "
            "alone, not by a helper's act within the law.",
      'zh': '通协助之定理：告之以其果表之，即以真候选独起，非以律内助者之行。', 'kind': 'non-implication'},
     {'en': "Which explanation holds of an actual formation's acts.",
      'zh': '何种解释成立于实际形成之行。', 'kind': 'non-implication'}],
    [{'en': "One course, two explanations: an unresolved model with the first ranking and a resolved one with the second "
            "act and sense alike in the first world (ReadingLoop.Untested.model_or_order).",
      'zh': '一历程，二解释：未决之模型用第一排序与已决之模型用第二排序，于第一世所行所感皆同（ReadingLoop.Untested.model_or_order）。'}],
    {'en': "Pure core, every axiom report empty: model_or_order is a case of observed_alike, the relation holding the "
           "starts and the rests; the rests are cases of Loop.rests_of_unrefuted.",
     'zh': '纯核，公理报告皆空：model_or_order 为 observed_alike 之一例，其关系持起点与止处；诸止为 Loop.rests_of_unrefuted 之例。'},
    {'en': "A helper's act within the law that informs, and a principal's order as state the helper's acts can move (RF "
           "round 2's later items); a frozen test separating a model that does not separate from an order that ranks "
           "otherwise by informing; review by a person.",
     'zh': '律内能告之助者之行，与助者之行可移之受助者之序为态（RF 第二轮之后项）；以告分未分之模型与排序相异之序之冻结检验；人之审查。'},
    {'en': "One observed course can leave an unresolved model and a reversed ranking indistinguishable: an illustration "
           "of the ambiguity between beliefs and preferences in inferring what a formation values from what it does "
           "(Armstrong and Mindermann 2018, for planner and reward; Reddy, Dragan and Levine 2018, for beliefs about "
           "dynamics). AI reading: a training, an overseer or a helper reading the acts cannot tell a formation held by "
           "what its model does not separate from one held by how it ranks; starting the first with the true candidate "
           "changes its course and leaves the second's, so whether informing helps depends on which holds, a reason "
           "for assistance to read more than acts. With what-choices-show-of-an-order: both rankings accord with the "
           "occasion, and the comparison beyond the shown reach is free. These are readings, not containments.",
     'zh': '一所观之历程可使未决之模型与相反之排序无可分别：此例示由形成之所行推其所重时信与偏好之含混（Armstrong 与 Mindermann 2018，关于择者与报酬；Reddy、Dragan 与 '
           'Levine 2018，关于对动力之信）。AI 解读：读其行之训练、督察或助者，不能分为其模型所未分者所持之形成与为其排序所持者；以真候选起前者则变其历程而不变后者，'
           '故告之是否有益视何者成立，此为协助读行以外者之由。与「所择所示之序」并：二排序皆与此时合，所示之及外之比较为自由。皆为读，非包含。'},
    ['not knowing or not wanting', '不知或不欲', 'a model or an order', '模型或序', 'Becoming.ReadingLoop.observed_alike',
     'Becoming.ReadingLoop.Untested.model_or_order'],
    [dep('what-choices-show-of-an-order', "ChoiceOccasions and ChoiceOccasions.Accords, for the training occasion.",
         'ChoiceOccasions 与 ChoiceOccasions.Accords，用于训练之时。')],
    [rel('what-a-course-chosen-through-its-model-does-not-test', "The loop and the worlds of the untried act on which the "
         "two formations are stated.", '二形成所陈于其上之环与未试之行之二世。')],
    [{'path': LEAN['Blanket'], 'role': 'proof', 'sha256': sha(LEAN['Blanket'])}],
    CH3, done('acts-alike-from-a-model-or-from-an-order', 'acts alike from a model or from an order: formations related '
              'by a relation their steps keep, an unresolved model and a reversed ranking, informing turning the first',
              '出于模型或出于序之同行：诸步所守之关系所联之形成、未决之模型与相反之排序、告之转其前者'))

# --- a-prediction-read-by-what-it-predicts ---------------------------------------------------------------------------
rD = build(
    'a-prediction-read-by-what-it-predicts', RP,
    {'en': 'A prediction read by what it predicts', 'zh': '为其所预言者所读之预言'},
    {'en': "A published prediction read by the response is right exactly where the response leaves it; none is right "
           "where it moves every value; on the chain 0 to n, under a response mapping it into itself and keeping its "
           "order, publication from zero reaches the least right prediction by step n.",
     'zh': '为应所读之公预言，恰当应不移之处为是；应移每一值处无一为是；于链 0 至 n，应映此链入其自身且守其序，自零反复公布至第 n 步达最小之是者。'},
    [("A prediction, published and read by the response, is right where the outcome, the response to it, is itself.",
      "预言既公布而为应所读，其果即对之之应，若为其自身则为是。",
      C(RP, 'ReflexivePrediction.Right')),
     ("Where the response moves every value, no published prediction is right, and no predictor is right on every "
      "admitted response once one admitted response moves every value, even one reading the response itself; on two "
      "values negation moves every value.",
      "应移每一值处，无公预言为是；一所容之应移每一值，则无预言者于每一所容之应皆是，即读应本身者亦然；于二值，否定移每一值。",
      C(RP, 'ReflexivePrediction.none_right_of_moves', 'ReflexivePrediction.no_predictor_right',
        'ReflexivePrediction.not_moves')),
     ("Given choice over the admitted responses, a predictor right on every one exists exactly where each leaves some "
      "value.",
      "于所容之诸应有择，则于每一应皆是之预言者存在，恰当每一应皆有其所不移之值。",
      C(RP, 'ReflexivePrediction.predictor_iff')),
     ("Publishing at each step the outcome of the step before, a step's prediction is right exactly where the next "
      "step publishes it again, and a right prediction, once published or once the outcome, is published at every later "
      "step.",
      "每步公布前步之果，则一步之预言为是，恰当下一步复公布之；是之预言一经公布或一为果，其后每步皆公布之。",
      C(RP, 'ReflexivePrediction.rests_iff_right', 'ReflexivePrediction.right_rests',
        'ReflexivePrediction.reached_rests')),
     ("On the values 0 to n with a response keeping them and their order, repeated publication from the bottom stays on "
      "the chain, rises, stays at or below every right prediction, and is right by step n: the least right prediction, "
      "reached within the chain's length.",
      "于 0 至 n 之值，应守之且守其序，则自底反复公布不离此链、上升、不过每一是之预言，且至第 n 步为是：最小之是者，于链之长内达之。",
      C(RP, 'ReflexivePrediction.on_chain', 'ReflexivePrediction.rises', 'ReflexivePrediction.below_right',
        'ReflexivePrediction.stays_from', 'ReflexivePrediction.again_or_risen', 'ReflexivePrediction.bottom_rests')),
     ("Witness, a threshold response on 0, 1, 2, two where anything is predicted and zero where nothing is: it keeps "
      "the chain and its order, zero and two are both right, and publication from zero stays zero while from one it "
      "reaches two after one step and stays there.",
      "例，于 0、1、2 之阈应：有所预言则二，无则零：其守链与序，零与二皆为是；自零公布则恒为零，自一则一步而达二且止于二。",
      C(RP, 'ReflexivePrediction.ThresholdResponse.threshold', 'ReflexivePrediction.ThresholdResponse.within',
        'ReflexivePrediction.ThresholdResponse.keeps', 'ReflexivePrediction.ThresholdResponse.both_right',
        'ReflexivePrediction.ThresholdResponse.reached_by_start')),
     ("Witness, Boolean negation: it leaves no value fixed, so no published prediction is right, and repeated "
      "publication alternates for ever.",
      "例，布尔之否：无所不移之值，故无公预言为是，反复公布则永相交替。",
      C(RP, 'ReflexivePrediction.Negating.negate', 'ReflexivePrediction.Negating.none_right',
        'ReflexivePrediction.Negating.alternates')),
     ("Witness, the reflection 2 − v on 0, 1, 2: subtracting more leaves no more, so it reverses the order, and it "
      "leaves 1 fixed: a response reversing the order can have a right prediction.",
      "例，于 0、1、2 之反射 2 − v：减多者所余不多，故其倒序，且不移 1：倒序之应可有是之预言。",
      C(RP, 'ReflexivePrediction.Reflecting.reflect', 'ReflexivePrediction.Reflecting.sub_antitone',
        'ReflexivePrediction.Reflecting.reverses', 'ReflexivePrediction.Reflecting.middle_right'))],
    [{'en': "Any type of values; the response a function of the prediction alone, read before the outcome; the chain "
            "the natural numbers 0 to n, the response keeping it and its order there; choice over the admitted "
            "responses only for a predictor's existence.",
      'zh': '值之任一型；应唯为预言之函数，于果之前读之；链为自然数 0 至 n，应于其上守链与序；唯预言者之存在需于所容之诸应有择。'}],
    [{'en': "Calibration, probabilities or forecasts of a distribution: the prediction is one value.",
      'zh': '校准、概率或分布之预测：预言为一值。', 'kind': 'scope'},
     {'en': "That actual publics respond by a function of the prediction alone, or keep its order.",
      'zh': '实际之众唯以预言之函数应之，或守其序。', 'kind': 'non-implication'},
     {'en': "Convergence of repeated retraining with losses: only repeated publication of the last outcome on a chain is "
            "stated.",
      'zh': '以损失反复再训之收敛：所陈者唯链上反复公布前轮之果。', 'kind': 'scope'}],
    [{'en': "No right prediction: on two values negation leaves none fixed, and publication alternates "
            "(ReflexivePrediction.Negating.alternates).",
      'zh': '无是之预言：于二值，否无所不移，公布永相交替（ReflexivePrediction.Negating.alternates）。'},
     {'en': "Two right predictions, where publication starts deciding which is reached "
            "(ReflexivePrediction.ThresholdResponse.reached_by_start).",
      'zh': '二是之预言，公布之始定所达之何者（ReflexivePrediction.ThresholdResponse.reached_by_start）。'}],
    {'en': "Pure core, every axiom report empty: ReflexivePrediction imports Keeping and Recurrence (Law.orbit); the "
           "chain's law is proved by deciding equality of naturals at each step, with no excluded middle.",
     'zh': '纯核，公理报告皆空：ReflexivePrediction 引 Keeping 与 Recurrence（Law.orbit）；链之律以每轮判自然数之相等证之，不用排中。'},
    {'en': "Probabilistic forecasts and calibration under performativity in the periphery; a formation's self-prediction "
           "within the reading loop; a frozen test of a published forecast's response; review by a person.",
     'zh': '外围之概率预测与表演性下之校准；读环内形成之自预言；公预测之应之冻结检验；人之审查。'},
    {'en': "Self-fulfilling and self-defeating prophecy (Merton 1948): a public prediction is one more input to what it "
           "predicts. In the bounded scalar setup a continuous response mapping a closed interval into itself has a "
           "correct public prediction (Grunberg and Modigliani 1954; Simon 1954), an existence, not its reaching by "
           "repeated publication; here a response keeping a finite chain and its order reaches the least right one from "
           "the bottom by step n (Tarski 1955 for the fixed point). Related to performative stability (Perdomo, Zrnic, "
           "Mendler-Dünner and Hardt 2020), defined by risk minimization on the distribution a deployed model induces: "
           "where retraining returns the outcome exactly, it is this orbit; no general correspondence is proved. AI "
           "reading: the bandwagon and the underdog as responses keeping and reversing the order; several right "
           "predictions, where publication starts deciding, read as self-fulfilling runs (Diamond and Dybvig 1983), the "
           "witness a threshold response, not a model of coordination; a formation whose act negates its self-prediction "
           "has none right, the one-step self-reading gap (Diagonal.gap_unsaid). These are readings, not containments.",
     'zh': '自应验与自挫败之预言（Merton 1948）：公预言为其所预言者之又一入。于有界之标量之设，连续之应映一闭区间入其自身者有正确之公预言（Grunberg 与 Modigliani 1954；'
           'Simon 1954），此为存在，非反复公布而达之；此处守有穷之链与其序之应，自底至第 n 步达最小之是者（不动点见 Tarski 1955）。近于表演性稳定（Perdomo、Zrnic、'
           'Mendler-Dünner 与 Hardt 2020），彼以部署之模型所致之分布上之风险最小定之：再训恰返其果处即此轨道；未证一般之对应。AI 解读：从众与助弱为守序与倒序之应；'
           '多是之预言而公布之始定之，读为自应验之挤兑（Diamond 与 Dybvig 1983），例为阈应而非协调之模型；行否其自预言之形成无是之自预言，为一步之自读之缺'
           '（Diagonal.gap_unsaid）。皆为读，非包含。'},
    ['reflexive prediction', '反身之预言', 'self-fulfilling prophecy', '自应验之预言', 'performative stability',
     '表演性稳定', 'Becoming.ReflexivePrediction.bottom_rests', 'Becoming.ReflexivePrediction.no_predictor_right'],
    [dep('when-to-inquire-and-when-to-respond', "Choice over the admitted responses, Viability.ChoiceOver.",
         '于所容之诸应之择 Viability.ChoiceOver。')],
    [rel('readings-within-what-they-read', "The self-reading gap, of which a formation negating its self-prediction is "
         "the one-step form.", '自读之缺；否其自预言之形成为其一步之形。'),
     rel('learning-by-refutation', "The diagonal course, on which every value an extrapolation proposes misses: the "
         "course form of a prediction negated by what it predicts.", '对角之历程，其上外推所提之每一值皆失：为其所预言者所否之预言之历程之形。')],
    [{'path': LEAN['Diagonal'], 'role': 'integration', 'sha256': sha(LEAN['Diagonal'])},
     {'path': LEAN['Learning'], 'role': 'integration', 'sha256': sha(LEAN['Learning'])}],
    CH3, done('a-prediction-read-by-what-it-predicts', 'a prediction read by what it predicts: right where the response '
              'leaves it, none where it moves every value, the least right one reached on a chain', '为其所预言者所读之预言：应不移处为是，应移每一值处无是者，链上达最小之是者'))

for m in MODS:
    cited = cited_by_module[m]
    assert len(cited) == len(set(cited)), ('a declaration cited twice', m)
    missing = sorted(names[m] - set(cited))
    assert not missing, (m, missing)
if CAPS_ONLY:
    print('cover: every declaration of the two modules cited once')
    raise SystemExit(0)
for record in (rA, rB, rC, rD):
    for rid in [x['id'] for x in record['dependencies']] + [x['id'] for x in record['related']]:
        assert (RECORDS / f'{rid}.json').exists() or rid in NEW, rid
    path = RECORDS / f"{record['id']}.json"
    assert not path.exists(), path
    path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print('record:', record['id'], sum(len(x['declarations']) for x in record['laws']), 'declarations in',
          len(record['laws']), 'laws')
