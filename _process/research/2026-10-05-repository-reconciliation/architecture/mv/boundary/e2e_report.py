"""MV, the boundary field: the report end to end on one run, with a synthetic carrier record (BOUNDARY-FIELD.md §8).

python3 -B e2e_report.py CHECKOUT INPUTS OUT

CHECKOUT is a checkout at the run's commit (the Lean check restores its modules from the checker's cache; on 31
October, the mv-probe worktree at main e332ae87a, core run 20261030T152859.871907Z). INPUTS holds that run's
constants.pickle, measure.json and probe.json (probe.py's output). The carrier holds U4's eight derived rows with the
probe's bridges and support, the three readings equal to the rule, act_courses_unselected declared derived (which
must fail), and the two premises of the ethics. OUT receives the report (e2e-report.json beside this file). The run
asserts the outcomes: the Lean check ran, the eight derived rows and the three readings stand as declared, only
act_courses_unselected is unverified, failing D2, D3 and D5, the premises are not entailed and not shown, and the
counts are 8 derived, 24 connected, 32 balance in its statement, 16 at a represented model, 7 own carrier and 31
unplaced, summing to the central declarations.
"""
import json, pickle, sys, importlib.util
from pathlib import Path
MV = Path(__file__).resolve().parents[6]
PROBE, SP, OUT = Path(sys.argv[1]), Path(sys.argv[2]), Path(sys.argv[3])
sys.path.insert(0, str(MV))
from tools.research import boundary
boundary.TC = PROBE / '_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY.py'
C = pickle.load(open(SP / 'constants.pickle', 'rb'))
measure = json.load(open(SP / 'measure.json'))
f5 = json.load(open(PROBE / 'theories/becoming/results/data/shared-laws.json'))
probe = json.load(open(SP / 'probe.json'))
central = {}
for r in measure['rows']:
    central.setdefault(r['declaration'], {'category': r['category'], 'dependence': r['dependence']})
at_model = f5['central_reach']['rows']
f5_class = {}
for n, row in central.items():
    models = {m for x in at_model.get(n, []) for m in x['models']}
    f5_class[n] = ('reaching the grammar' if row['dependence'] == 'grammar' else 'stated at a represented model'
                   if models & {'occurrence', 'process'} else 'stated on its own carrier only' if models else 'the rest')
B = lambda xs: ['Becoming.' + x for x in xs]
standings = []
for d, e in probe['summary']['eight'].items():
    s = {'declaration': 'Becoming.' + d, 'standing': 'derived', 'basis': {'en': 'A case.'}, 'review': 'R.md', 'law': B([e['law']])}
    if e['bridges']: s['bridges'] = B(e['bridges'])
    if e['support']: s['support'] = B(e['support'])
    standings.append(s)
acts = [n for n in central if n.endswith('act_courses_unselected')][0]
standings += [
    {'declaration': 'Becoming.Flow.mutuallyDependent_iff_reach', 'standing': 'connected', 'basis': {'en': 'Connected.'}, 'review': 'R.md'},
    {'declaration': 'Becoming.Flow.withinCoupling_reads_iff', 'standing': 'connected', 'basis': {'en': 'Connected.'}, 'review': 'R.md'},
    {'declaration': 'Becoming.Flow.no_new_dependence', 'standing': 'balance in its statement', 'basis': {'en': 'Balance.'}, 'review': 'R.md'},
    {'declaration': acts, 'standing': 'derived', 'basis': {'en': 'Steps?'}, 'review': 'R.md', 'law': ['Becoming.«所闭之传递»']},
]
record = {'id': 'u4-test', 'schema_version': 2, 'status': 'recorded-checked', 'references': [{'role': 'review', 'path': 'R.md'}],
          'laws': [{'en': 'x', 'declarations': [s['declaration'] for s in standings]}],
          'boundary': {'standings': standings, 'premises_of_the_ethics': [
              {'role': 'scope', 'name': {'en': 'the continuation condition'}, 'premise': 'Becoming.Unrestricted',
               'not_entailed': 'Becoming.ReadsOnlyDynamics.not_entails', 'basis': {'en': 'b'}, 'review': 'R.md'},
              {'role': 'order', 'name': {'en': 'C'}, 'premise': 'Becoming.Comparison', 'not_entailed': None,
               'absent': {'en': 'no theorem shows it'}, 'basis': {'en': 'b'}, 'review': 'R.md'}]}}
print('field findings:', boundary.field_findings(record))
import time; t = time.time()
mg_spec = importlib.util.spec_from_file_location('mg', PROBE / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou3b-master-laws-on-the-grammar/measure_grammar.py')
mg = importlib.util.module_from_spec(mg_spec); mg_spec.loader.exec_module(mg)
rep = boundary.report(C, central, at_model, f5_class, record, getattr(mg, 'ANCHORS', mg.ec.LAWS)['balance'])
print('seconds', round(time.time() - t, 1))
json.dump(rep, open(OUT, 'w'), indent=1, ensure_ascii=False)
print(json.dumps({k: rep[k] for k in ('counts', 'groups', 'derived_by_forwarder', 'premises_of_the_ethics', 'lean_check')}, ensure_ascii=False, indent=1))
for x in rep['unverified']:
    print('UNVERIFIED', x['declaration'], x['failed'])
print(json.dumps(rep['against_f5'], ensure_ascii=False))
eight = ['Becoming.' + d for d in probe['summary']['eight']]
assert rep['lean_check']['ran'], rep['lean_check']
assert all((rep['rows'][d]['label'], rep['rows'][d]['placed']) == ('derived', 'checked entry') for d in eight), eight
assert all(rep['rows'][s['declaration']]['placed'] == 'reading' for s in standings[len(eight):-1])
assert [x['declaration'] for x in rep['unverified']] == [acts], rep['unverified']
assert sorted({f[:2] for f in rep['unverified'][0]['failed']}) == ['D2', 'D3', 'D5'], rep['unverified'][0]['failed']
assert [p['result'] for p in rep['premises_of_the_ethics']] == ['not entailed', 'not shown'], rep['premises_of_the_ethics']
assert sum(rep['counts'].values()) == sum(rep['groups'].values()) == len(central)
assert {k: v for k, v in rep['counts'].items() if v} == {'derived': 8, 'connected': 24, 'balance in its statement': 32,
                                                         'at a represented model': 16, 'own carrier': 7, 'unplaced': 31}, rep['counts']
print('the expected outcomes hold')
