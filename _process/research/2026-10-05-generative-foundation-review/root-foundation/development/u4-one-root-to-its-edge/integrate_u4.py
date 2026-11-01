#!/usr/bin/env python3
"""U4's landing, after the core run (the leaf, Becoming.RootForms, is already on the branch with its import, its root
module paragraph, its README rows and its place in the checker's core list):

  python3 -B <dir>/integrate_u4.py record RECEIPT STUDY   the record one-root-to-its-edge, bound to the core run's
                                                          receipt; 08 §7's home section; 08 §3's receipt sentence,
                                                          every count read from the receipt; regions.json's two entries
  python3 -B <dir>/integrate_u4.py register LOG           the apart register, from THEOREM-CONNECTIVITY.py --check's log:
                                                          the leaf's roots with their reasons; others printed
  python3 -B <dir>/integrate_u4.py check                  after shared_laws.py: the data reads this record, nothing is
                                                          unverified or unplaced, and its counts are the home section's
  python3 -B <dir>/integrate_u4.py study N RECEIPT        the study's section N (the next free one), from the receipt
                                                          and the record's counts

Before `record`, rerun boundary_table.py on the landing's core run (the rule's labels and the counts come from
boundary-table.json, computed before HE2), and keep `check` as the gate.

Run from the checkout root of the landing worktree. Each edit asserts that it applies exactly once, or that it is
already applied. After it: shared_laws.py (its four boundary lists must be empty), render, check, links, tests.
"""
import importlib.util
import json
import re
import sys
import textwrap
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


# 08 §3's sentence naming the core receipt and its counts (RR2's reland_rr2.py pattern): RootForms joins the core, so
# the landing's own receipt replaces the earlier one.
SENTENCE = re.compile(
    r"At core receipt \[`[0-9TZ.]+`\]\([^)]*\) \(Lean 4\.29\.1\), the closure held \d+ modules \(\d+ foundation, "
    r"\d+ core, \d+ in the instance and application ring\) and [\d,]+ theorems; the \d+ core modules held [\d,]+ of "
    r"them; [\d,]+ declarations were audited; \d+ generated `injEq` lemmas depend on `propext`; \d+ superseded "
    r"modules were kept out of the run\.")


def receipt_sentence(receipt):
    r = json.loads((ROOT / receipt).read_text(encoding='utf-8'))
    assert r['status'] == 'passed'
    mods = {m['module']: m for m in r['modules']}
    assert 'Becoming.RootForms' in mods and not any(mods['Becoming.RootForms']['axiom_dependencies'].values())
    stamp = Path(receipt).parent.name
    layers = {}
    for m in r['modules']:
        count = layers.setdefault(m['layer'], [0, 0])
        count[0] += 1
        count[1] += m['theorems']
    assert set(layers) <= {'foundation', 'core', 'instance', 'application'}, set(layers)
    modules = sum(v[0] for v in layers.values())
    theorems = sum(v[1] for v in layers.values())
    assert modules == len(r['core_closure']), (modules, len(r['core_closure']))
    ring = layers.get('instance', [0, 0])[0] + layers.get('application', [0, 0])[0]
    declarations = sum(len(m['declarations']) for m in r['modules'])
    injeq = sum(1 for name, axioms in r['generated_axiom_dependencies'].items()
                if name.endswith('.injEq') and axioms == ['propext'])
    assert injeq == len(r['generated_axiom_dependencies']), 'a generated dependency other than injEq on propext'
    link = '../../../' + receipt
    counts = (f"At core receipt [`{stamp}`]({link}) (Lean 4.29.1), the closure held {modules} modules "
              f"({layers['foundation'][0]} foundation, {layers['core'][0]} core, {ring} in the instance and application "
              f"ring) and {theorems:,} theorems; the {layers['core'][0]} core modules held {layers['core'][1]:,} of them; "
              f"{declarations:,} declarations were audited; {injeq} generated `injEq` lemmas depend on `propext`; "
              f"{len(r['superseded_modules'])} superseded modules were kept out of the run.")
    text = CHAPTER.read_text(encoding='utf-8')
    text, k = SENTENCE.subn(lambda m: counts, text)
    assert k == 1, k
    CHAPTER.write_text(text, encoding='utf-8')
    print('08 §3:', counts[:160], '…')


def record(receipt, study):
    r, c = mr.record(receipt, study)
    receipt_sentence(receipt)
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


STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
DEVLINK = 'development/u4-one-root-to-its-edge/'


def study(n, receipt):
    """The study's section N (the next free one), from the landing's receipt and the record's counts."""
    text = STUDY.read_text(encoding='utf-8')
    free = max(int(x) for x in re.findall(r'^## (\d+)\. ', text, re.M)) + 1
    title = '## {}. One root to its edge: where each central declaration stands (U4)'
    if title.format(n) in text:
        print('study §', n, 'already in place')
        return
    assert int(n) == free, ('the next free section is', free)
    r = json.loads((ROOT / receipt).read_text(encoding='utf-8'))
    m = {x['module']: x for x in r['modules']}['Becoming.RootForms']
    assert r['status'] == 'passed' and not any(m['axiom_dependencies'].values())
    stamp = Path(receipt).parent.name
    c = mr.counts()
    on = c['derived'] + c['under a stated hypothesis']
    dist = sum(v for k, v in c.items() if k not in ('derived', 'under a stated hypothesis', 'premise', 'counting',
                                                     'unplaced'))
    total = on + c['counting'] + dist
    placing = textwrap.fill(
        f"The record places the {total} distinct central declarations: on the edge {on} ({c['derived']} derived, each a "
        f"case of grammar laws, through bridges checked as equivalences where a row has them; "
        f"{c['under a stated hypothesis']} under a stated hypothesis); below the grammar {c['counting']} (counting); at a "
        f"named distance {dist} ({c['connected']} connected, {c['balance in its statement']} with balance in their "
        f"statement, {c['amounts']} amounts, {c['at a represented model']} at a represented model, {c['own carrier']} on "
        f"their own carrier, {c['at its model']} at their model, {c['free significance']} with significance free); none "
        f"unplaced. The ethics' two premises are listed apart: the condition for scope, not entailed by statements "
        f"reading only the dynamics (ReadsOnlyDynamics.not_entails), and C for order, with no such theorem.",
        width=118, initial_indent='  - ', subsequent_indent='    ')
    section = f"""{title.format(n)}

Board item U4, one root to its edge: each central declaration placed against the edge of one root, by [the design]({DEVLINK}DESIGN-BOUNDARY.md), declared on MV's boundary field (§472) and checked by it. Levers 1 and 2 landed earlier as documents ([lever 2's audit]({DEVLINK}LEVER-2-AUDIT.md), [the connected rows]({DEVLINK}CONNECTED-ROWS-READING.md)); HE2 (§474) took lever 1's counting laws and U4's laws of a closure into GrammarLaws, so that two rows read as connected are now derived. Two reviews read the design ([first]({DEVLINK}REVIEW-U4-BOUNDARY.md), [second]({DEVLINK}REVIEW-U4-BOUNDARY-SECOND.md)); an independent reader reviewed the record against its review file, which names every declaration the record introduces (22 findings, every one taken: [the review]({DEVLINK}REVIEW-U4-RECORD.md)).

```text
Result(s): one-root-to-its-edge (new, home 08 §7).
Delta:
  - Root forms (Becoming.RootForms): a row stated on the grammar under named hypotheses, each a definition naming
    no model and no amount; beside each hypothesis H of a form, a witness over one point where the form with H
    dropped fails (needs_H) and the form applied there, so that H fails with the conclusion (H_needed); a recovery
    at the row's own type and a certificate by rfl.
  - outside_leaves_no_offspring: where giving lies within giving from a region (GivesFrom) and listed descent within
    giving (ListedWithin), a listing wholly outside the region (Outside) has no listed offspring.
    GroupEnding.Flow.all_end is this form at one step, each hypothesis met by definitions alone (all_end_at_model,
    all_end_certified): the row stands on the root under the three.
  - descent_forms_no_dependence: where what comes to stand is given to (GivenTo), dependence after a step is
    inherited along descent (Inherits) and nothing descended from depends before it (UndependedFrom), nothing
    coming to stand depends after it. Flow.no_new_dependence is this form at its one relatum
    (no_new_dependence_at_model, no_new_dependence_certified), but meets "given to" only through
    Flow.descends_of_comes, amount reasoning, so the form is its relational part and the row keeps its distance.
{placing}
Supplied premises / correspondence: none added beyond each form's hypotheses. The record's correspondence of a row
       to its laws or its form, and every reading, is the review's; MV's check bounds it (D1 to D6 for derived
       rows, the nine Lean tests for row 17) and does not show it. Modelling choices: lists for offspring, as the
       row lists them; regions and relations as Prop-valued predicates on any carrier.
Evidence: core receipt `{stamp}`; Becoming.RootForms ({m['theorems']} theorems in {len(m['declarations'])} declarations),
       a core leaf importing Grammar, Transmission and GroupEnding; every axiom report empty. shared_laws.py on
       that run: the boundary report reads the record, nothing unverified or unplaced, the Lean check ran.
Standing: near-definitional; each form is a few lines of logic, none of it claimed new as mathematics. What it
       adds is the placing: every central declaration has one standing and its reason, checked where a check
       exists.
Boundary:
  - That a row under a stated hypothesis uses the grammar's laws: neither form reaches one.
  - That the countermodels show more than that no hypothesis is redundant: they are over one point.
  - That either premise of the ethics is warranted; each warrant stays open.
  - That a distance is a gap or a failure: the measure records dependence, not meaning.
Output -> input: the record's next step (a root form for the census rows; a theorem that no statement reading
       only the dynamics entails C; the root reading of significance for the three rows keeping it free; HE2's
       laws read as cases at more connected rows).
```
"""
    STUDY.write_text(text.rstrip('\n') + '\n\n' + section, encoding='utf-8')
    print('study §', n, 'written')


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
    data = json.loads((ROOT / 'theories/becoming/results/data/shared-laws.json').read_text(encoding='utf-8'))
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
    elif sys.argv[1] == 'study':
        study(sys.argv[2], sys.argv[3])
    else:
        sys.exit(__doc__)
