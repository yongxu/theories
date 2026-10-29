#!/usr/bin/env python3
"""RF round 2, RF6.1's landing: the record a-revision-that-opens-a-correction (Becoming.OpenedCorrection, an
application of the ring, home 03 §8), each declaration of its module cited once. Asserts the receipt's hash and empty
axiom report for the module, and the style caps and lint (tools/research/style.py) on every field. make_records_rf2.py,
for RF6.1.
usage (from the checkout root, after the texts are in place): python3 -B make_records_rf61.py RECEIPT N
       python3 -B make_records_rf61.py --caps  (caps, lint and declaration cover against the kit's scratch audit;
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
RECEIPT_ID, N = ('20261030T000000.000000Z', 457) if CAPS_ONLY else (sys.argv[1], int(sys.argv[2]))
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
MODS = ('Becoming.OpenedCorrection',)
NEW = ('a-revision-that-opens-a-correction',)


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


OC, = MODS

# --- a-revision-that-opens-a-correction ------------------------------------------------------------------------------
rE = build(
    'a-revision-that-opens-a-correction', OC,
    {'en': 'A revision of a reading that opens a correction, along one process', 'zh': '沿一过程开一更正之读之修订'},
    {'en': "A course of a process opens a correction where it leads to a configuration with a fitting uniform policy "
           "through the reading in force from one lacking it, acceptability fixed; on Revising's process, rebuilding the "
           "link from off opens it where a unit of stock remains after.",
     'zh': '一过程之历程开一更正，当其自经所行之读缺合之一致策略之形态，至有之之形态，可受者守定；于 Revising 之过程，初始联断时重建其联而后尚余一储处开之。'},
    [("Correctable at a configuration: through the reading in force there, a uniform policy exists whose act at each "
      "reading is acceptable at every situation giving it and executable there; given choice over the readings, exactly "
      "where each reading has one such act.",
      "于一形态可更正：经其时所行之读，有一致之策略，其于每一读之行于给此读之每一情形皆可受，且于此形态可行；于诸读有择，则恰当每一读有一此行。",
      C(OC, 'OpenedCorrection.Correctable', 'OpenedCorrection.correctable_iff')),
     ("A course opens a correction from x to x' where a trace of the process leads from x to x', no fitting uniform "
      "policy exists at x and one exists at x', with one acceptability throughout; the gain may come from the reading, "
      "from executability, or both.",
      "一历程开一更正自 x 至 x'，当过程之一迹自 x 至 x'，于 x 无合之一致策略而于 x' 有之，可受者始终同一；所得或来自读，或来自可行，或二者皆是。",
      C(OC, 'OpenedCorrection.OpensAlong')),
     ("With readings in one type and a supplied map f between them: where f (reading x' s) = reading x s at every "
      "situation and every act executable at x stays executable at x', correctability is kept; where "
      "f (reading x s) = reading x' s at every situation and every act executable at x' was executable at x, nothing "
      "is opened.",
      "诸读同属一型，给定映射 f：若每一情形皆 f (reading x' s) = reading x s，且于 x 可行之行于 x' 仍可行，则保持可更正；若每一情形皆 f (reading x s) = reading x' s，且于 x' 可行之行于 x 已可行，则无所开。",
      C(OC, 'OpenedCorrection.finer_keeps', 'OpenedCorrection.coarser_opens_nothing')),
     ("With every act counted acceptable, a configuration with an executable act is correctable already: an opening "
      "counts only with the acceptability fixed.",
      "凡行皆计为可受，则有一可行之行之形态已可更正：开唯于可受者守定时方算。",
      C(OC, 'OpenedCorrection.widened_correctable')),
     ("On Revising's stock-and-link process, the correction acceptable where it is needed and replenishing where it is "
      "not, executability the process's enabling: with the link off no configuration is correctable; with it on and a "
      "unit of stock every one is; with it on and no stock none is.",
      "于 Revising 之储与联之过程，需处更正为可受，不需处补储为可受，可行即过程之所使可行：联断则无形态可更正；联通且有一储则每一皆可；联通而无储则无一可。",
      C(OC, 'OpenedCorrection.Linked.acceptable', 'OpenedCorrection.Linked.executable',
        'OpenedCorrection.Linked.unlinked_uncorrectable', 'OpenedCorrection.Linked.linked_correctable',
        'OpenedCorrection.Linked.starved_uncorrectable')),
     ("Starting with the link off and at least two units, rebuilding it opens the correction in one step; starting with "
      "it off and one unit, rebuilding alone does not, the rebuild consuming the last unit, though rebuilding then "
      "replenishing does; with every act counted acceptable, the unlinked configuration is correctable already.",
      "初始联断且至少有二储时，重建其联一步而开更正；初始联断且仅有一储时，唯重建不能开之，重建耗尽最后之储，然重建而后补储则开之；凡行皆计为可受，则联断之形态已可更正。",
      C(OC, 'OpenedCorrection.Linked.opens', 'OpenedCorrection.Linked.rebuilt_starved',
        'OpenedCorrection.Linked.opens_after_replenishing', 'OpenedCorrection.Linked.widened_unlinked')),
     ("Replenishing alone opens the correction where the link is on and the stock is not: the reading unchanged, the "
      "gain is in what can be executed.",
      "联通而无储处，唯补储即开更正：读未变，所得在可行者。",
      C(OC, 'OpenedCorrection.Linked.opens_by_support'))],
    [{'en': "Any types of configurations, revision acts, situations, acts and readings; one type of readings in force at "
            "every configuration; acceptability on situations and acts, fixed; executability read at the configuration; "
            "choice over the readings only for the iff.",
      'zh': '形态、修订之行、情形、行与读之任一型；每一形态所行之读同属一型；可受者于情形与行上，守定；可行于形态上读之；唯 iff 需于诸读有择。'}],
    [{'en': "What a formation chooses: uniform-policy existence is not a controller's act or run (Revising's "
            "controlled_revision states one).",
      'zh': '形成之所择：一致策略之存在非一控者之行或其历程（Revising 之 controlled_revision 陈之）。', 'kind': 'non-implication'},
     {'en': "Double-loop learning in Argyris and Schön's sense, which turns on changing governing norms; here the "
            "acceptability is fixed.",
      'zh': 'Argyris 与 Schön 所谓之双环之学，其要在改所循之规；此处可受者守定。', 'kind': 'non-implication'},
     {'en': "Which revision an institution can make or makes, or what a finer reading draws on beyond Revising's unit of "
            "stock.",
      'zh': '一制度能作或所作之修订，或更细之读于 Revising 一储之外所耗者。', 'kind': 'scope'}],
    [{'en': "Rebuilding the link from one unit consumes the last unit, and the correction cannot be taken "
            "(OpenedCorrection.Linked.rebuilt_starved).",
      'zh': '自一储重建其联耗尽最后之储，更正不可行（OpenedCorrection.Linked.rebuilt_starved）。'},
     {'en': "With every act counted acceptable the unlinked configuration is correctable, so nothing is opened "
            "(OpenedCorrection.Linked.widened_unlinked).",
      'zh': '凡行皆计为可受，则联断之形态可更正，故无所开（OpenedCorrection.Linked.widened_unlinked）。'}],
    {'en': "The core's conditions, every axiom report empty, as an application of the ring: OpenedCorrection imports "
           "GuardHorizon, an application, and Revision; correctable_iff is GuardHorizon.uniform_policy_iff_fiber_feasible; "
           "the Linked witnesses evaluate Revising's process.",
     'zh': '合纯核之条件，公理报告皆空，为环中之应用：OpenedCorrection 引 GuardHorizon（一应用）与 Revision；correctable_iff 即 GuardHorizon.uniform_policy_iff_fiber_feasible；Linked 之例计算 Revising 之过程。'},
    {'en': "A supplied controller's run along which an opening is taken; an institution's rule of reading what its "
           "members report as its own process, with the members' acts; a frozen institution simulation with three "
           "controls (the plan's TR4); review by a person.",
     'zh': '一所予之控者沿之而取所开之历程；制度读成员所报之规为其己之过程，并成员之行；具三对照之冻结制度模拟（计划之 TR4）；人之审查。'},
    {'en': "AI reading: for an institution, the link is its rule of reading what its members report, by which line "
           "rather than how many, the stock what that reading draws on, and the correction the repair a report calls "
           "for. Revising an observation map is one formal mechanism that may take part in organizational learning; its "
           "relation to double-loop learning (Argyris and Schön 1978) depends on whether inquiry changes a governing "
           "norm or assumption, and here the acceptability is fixed and the law concerns uniform-policy existence along "
           "a course. Replacing a reading by one read off it through a supplied map, gaining no executability and with the "
           "acceptability fixed, opens no correction. With "
           "selection-under-registration-revision, where discrimination, support and enactment come apart, this states "
           "in policy form the correction they open. These are readings, not containments.",
     'zh': 'AI 解读：于一制度，联即其读成员所报之规（依何线而非几何），储为此读所耗者，更正为报告所求之修。修订一观察之映射为可参与组织之学之一形式机制；其与双环之学'
           '（Argyris 与 Schön 1978）之关系，视探究是否改所循之规或所设；此处可受者守定，律所关者为沿一历程之一致策略之存在。以经所予之映射由之读出之读代之，而不增可行者且可受者守定，'
           '无所开。与「注册修订下之选」并：彼处辨、支与施各异，此以策略之形陈其所开之更正。皆为读，非包含。'},
    ['opening a correction', '开更正', 'a correctable configuration', '可更正之形态',
     'Becoming.OpenedCorrection.OpensAlong', 'Becoming.OpenedCorrection.Linked.opens'],
    [dep('when-to-inquire-and-when-to-respond', "GuardHorizon.UniformPolicy and uniform_policy_iff_fiber_feasible.",
         'GuardHorizon.UniformPolicy 与 uniform_policy_iff_fiber_feasible。'),
     dep('selection-under-registration-revision', "Revising's process P, its reading read and its acts.",
         'Revising 之过程 P、其读 read 与其行。')],
    [rel('a-reading-kept-by-its-update', "Acts good and enabled for a reading the update keeps; here correctability "
         "is compared along a course of a process, where the reading in force, executability, or both may change.",
         '于更新所守之读善且可行之行；此处沿一过程之历程比较可更正性，所行之读、可行者，或二者皆可改变。')],
    [{'path': LEAN['GuardHorizon'], 'role': 'proof', 'sha256': sha(LEAN['GuardHorizon'])},
     {'path': LEAN['Revision'], 'role': 'proof', 'sha256': sha(LEAN['Revision'])}],
    CH3, done('a-revision-that-opens-a-correction', 'a revision of a reading that opens a correction along one '
              'process: correctable at a configuration, opening along a trace, the two monotonicities, acceptability '
              'held fixed, on Revising\'s process', '沿一过程开一更正之读之修订：于形态可更正、沿迹而开、二单调、可受者守定，于 Revising 之过程'))


for m in MODS:
    cited = cited_by_module[m]
    assert len(cited) == len(set(cited)), ('a declaration cited twice', m)
    missing = sorted(names[m] - set(cited))
    assert not missing, (m, missing)
if CAPS_ONLY:
    print('cover: every declaration of the module cited once')
    raise SystemExit(0)
for record in (rE,):
    for rid in [x['id'] for x in record['dependencies']] + [x['id'] for x in record['related']]:
        assert (RECORDS / f'{rid}.json').exists() or rid in NEW, rid
    path = RECORDS / f"{record['id']}.json"
    assert not path.exists(), path
    path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print('record:', record['id'], sum(len(x['declarations']) for x in record['laws']), 'declarations in',
          len(record['laws']), 'laws')
