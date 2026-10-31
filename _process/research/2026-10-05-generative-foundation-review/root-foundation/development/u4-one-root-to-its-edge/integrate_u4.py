#!/usr/bin/env python3
"""U4's landing, after the core run (the leaf, Becoming.RootForms, is already on the branch with its import, its root
module paragraph, its README rows and its place in the checker's core list):

  python3 -B <dir>/integrate_u4.py record RECEIPT STUDY   the record one-root-to-its-edge, bound to the core run's
                                                          receipt; 08 §7's home section; regions.json's two entries
  python3 -B <dir>/integrate_u4.py register LOG           the apart register, from THEOREM-CONNECTIVITY.py --check's log:
                                                          the leaf's roots with their reasons; others printed
  python3 -B <dir>/integrate_u4.py check                  after master_laws.py: the data reads this record, nothing is
                                                          unverified or unplaced, and its counts are the home section's

Before `record`, rerun boundary_table.py on the landing's core run (the rule's labels and the counts come from
boundary-table.json, computed before HE2), and keep `check` as the gate.

Run from the checkout root of the landing worktree. Each edit asserts that it applies exactly once, or that it is
already applied. After it: master_laws.py (its four boundary lists must be empty), render, check, links, tests.
"""
import importlib.util
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location('make_record_u4', HERE / 'make_record_u4.py')
mr = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mr)

CHAPTER = ROOT / 'theories/becoming/chapters/08-METHOD.md'
REGIONS = ROOT / 'theories/becoming/results/data/regions.json'
APART = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json'
ANCHOR = '\n<a id="known-results"></a>\n## 8. Known results\n'


def record(receipt, study):
    r, c = mr.record(receipt, study)
    assert c['unplaced'] == 0, c
    (ROOT / mr.REC).write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    text = CHAPTER.read_text(encoding='utf-8')
    section = mr.home(c)
    if '<a id="r-one-root-to-its-edge"></a>' in text:
        assert section in text, 'a different home section is in place: remove it and rerun'
    else:
        assert text.count(ANCHOR) == 1, ANCHOR
        CHAPTER.write_text(text.replace(ANCHOR, '\n' + section + ANCHOR), encoding='utf-8')
    regions = json.loads(REGIONS.read_text(encoding='utf-8'))
    regions['records'][mr.RID] = {
        'region': 'method', 'base': 'grammar',
        'note': "U4: each central declaration's standing on the edge of one root (MV's boundary field); RootForms, "
                "row 17's root form and row 5's relational part"}
    regions['modules']['Becoming.RootForms'] = {
        'region': 'method', 'base': 'grammar',
        'note': 'U4: rows stated on the grammar under named hypotheses, each with a countermodel and a fit; '
                'outside_leaves_no_offspring (GroupEnding.Flow.all_end), descent_forms_no_dependence'}
    for key in ('records', 'modules'):
        regions[key] = dict(sorted(regions[key].items()))
    REGIONS.write_text(json.dumps(regions, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
    print('record', mr.REC, 'counts', c)


def reason(name):
    """The leaf's apart roots: countermodels, fits and certificates, which nothing in the package uses."""
    short = name.removeprefix('Becoming.')
    m = re.fullmatch(r'RootForms\.(\w+)\.needs_(\w+)', short)
    if m:
        return 'model-witness', (f'{short}: a fact about one constructed model over one point: dropping the '
                                 f'hypothesis ({m.group(2)}), the conclusion of RootForms.{m.group(1)} fails '
                                 "(U4's countermodel, cited by the boundary record)")
    m = re.fullmatch(r'RootForms\.(\w+)\.(\w+)_needed', short)
    if m:
        return 'model-witness', (f'{short}: a fact about one constructed model over one point: the hypothesis '
                                 f'({m.group(2)}) fails there, by RootForms.{m.group(1)} (U4\'s fit, cited by the '
                                 'boundary record)')
    m = re.fullmatch(r'RootForms\.(\w+)_certified', short)
    if m:
        row = {'all_end': 'GroupEnding.Flow.all_end', 'no_new_dependence': 'Flow.no_new_dependence'}[m.group(1)]
        return 'restates', (f'{short}: the recovery states exactly {row}, by rfl; it restates that row through its '
                            "root form (U4's certificate, cited by the boundary record)")
    return None


def register(log_path):
    t = APART.read_text(encoding='utf-8')
    log = Path(log_path).read_text(encoding='utf-8')
    m = re.search(r"apart roots without a reason in [^:]+: (\[[^\]]*\])", log)
    listed = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]
    block, others = '', []
    for name in listed:
        got = reason(name) if name.startswith('Becoming.RootForms.') else None
        if got is None:
            others.append(name)
            continue
        if json.dumps(name, ensure_ascii=False) in t:
            continue
        cat, why = got
        block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "Becoming.RootForms",\n'
                  '   "category": "' + cat + '",\n   "reason": ' + json.dumps(why, ensure_ascii=False) + '\n  },\n')
    if block:
        anchor = '  }\n },\n "instances": {'
        assert t.count(anchor) == 1
        t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
        json.loads(t)
        APART.write_text(t, encoding='utf-8')
    print('registered', block.count('"module"'), 'roots of the leaf')
    if others:
        print("roots not the leaf's, for their owners:", ', '.join(others))


def check():
    data = json.loads((ROOT / 'theories/becoming/results/data/master-laws.json').read_text(encoding='utf-8'))
    b = data.get('boundary') or {}
    assert b.get('record') == mr.RID, ('the data has not read the record', b.get('record'), b.get('error'))
    problems = []
    if b.get('field_failures'):
        problems.append(('field failures', b['field_failures']))
    if b.get('unverified'):
        problems.append(('unverified', [(x.get('declaration'), x.get('failed')) for x in b['unverified']]))
    unplaced = [d for d, row in (b.get('rows') or {}).items() if row.get('label') == 'unplaced']
    if unplaced:
        problems.append(('unplaced', unplaced))
    bad_premises = [p for p in b.get('premises_of_the_ethics', []) if p.get('result') not in ('not entailed', 'not shown')]
    if bad_premises:
        problems.append(('premises', bad_premises))
    mine = mr.counts()
    theirs = {k: v for k, v in (b.get('counts') or {}).items() if k in mine}
    if theirs != mine:
        problems.append(('counts differ: rerun boundary_table.py and the record', {k: (mine[k], theirs.get(k))
                                                                                   for k in mine if mine[k] != theirs.get(k)}))
    if not b.get('lean_check', {}).get('ran'):
        problems.append(('the Lean check did not run', b.get('lean_check')))
    for p in problems:
        print('PROBLEM', p)
    assert not problems
    print('boundary report matches: counts', mine, '; premises', [p.get('result') for p in b['premises_of_the_ethics']])


if __name__ == '__main__':
    if sys.argv[1] == 'record':
        record(sys.argv[2], sys.argv[3])
    elif sys.argv[1] == 'register':
        register(sys.argv[2])
    elif sys.argv[1] == 'check':
        check()
    else:
        sys.exit(__doc__)
