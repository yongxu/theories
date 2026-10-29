#!/usr/bin/env python3
"""U2's records. To each row's own record (sixteen records) add its law at the model, one per reading, with F5's
field `statements_at_model` in MV's final shape (mv/F5-MODEL-STATEMENTS.md §1), a reference to the leaf and to the
review that checked the items, the leaf's proof binding and a history note; and under each record's home section
in its chapter one bullet per law, with the record's base label. The rows' statements, proofs and every other field
are unchanged. Rules asserted (MV's §1): `declaration` among the law's own declarations; `of` among another law's
declarations in the same record; no declaration of a law carrying items is any item's `of`; `review` the path of a
reference of role review in the record; `models` nonempty and distinct among occurrence, process and own; each
theorem the declaration of at most one item. Style caps and lint (tools/research/style.py) on every record written.
usage (from the checkout root): python3 -B make_records_u2.py RECEIPT N REVIEW   (writes)
       python3 -B make_records_u2.py --caps REVIEW                               (checks only; writes nothing)
REVIEW is the review the items name, a path relative to the checkout root."""
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT))
sys.path.insert(0, str(HERE))
from tools.research import style  # noqa: E402
from laws_u2 import LAWS, MODELS, model_statements  # noqa: E402

CAPS_ONLY = sys.argv[1] == '--caps'
if CAPS_ONLY:
    RECEIPT_ID, N, REVIEW = '20261030T000000.000000Z', 0, sys.argv[2]
else:
    RECEIPT_ID, N, REVIEW = sys.argv[1], int(sys.argv[2]), sys.argv[3]
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
KITD = RF + 'development/u2-rows-on-the-root/'
STUDY = RF + 'BECOMING-RENEWAL-READING.md'
DESIGN = KITD + 'DESIGN.md'
LEAF = f'{PKG}/Becoming/ModelStatements.lean'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
CHAPTERS = ROOT / 'theories/becoming/chapters'
TODAY = datetime.date.today()
DATE_EN, DATE_ZH = f'{TODAY.day} {TODAY:%B} {TODAY.year}', f'{TODAY.year}年{TODAY.month}月{TODAY.day}日'
# Each law's base label: the row's own scope, which the reading keeps.
BASES = {
    'Becoming.Web.roles_supported': 'World', 'Becoming.Web.roles_dependent': 'World',
    'Becoming.Web.roles_alive': 'World', 'Becoming.Web.renewingAt_iff_over_all': 'World',
    'Becoming.Web.transmits_at_iff': 'World', 'Becoming.Limit.identifies_iff_tracks': 'any process',
    'Becoming.Ideals.verifiableBy_iff_interior': 'any type', 'Becoming.Valuation.significant_iff_held': 'any type',
    'Becoming.Web.significance_undetermined': 'World',
    'Becoming.Dependence.Overdetermined.only_together': 'any process; withholding a supplied map on configurations',
    'Becoming.ExchangeLaw.response_not_fixed_by_coupling': 'World', 'Becoming.Viability.kernel_and_iff': 'any process',
    'Becoming.Dependence.differenceOnlyTogether_iff': 'any process; withholding a supplied map on configurations',
    'Becoming.Run.not_fixes_of_untaken': 'any process', 'Becoming.SharedCodes.run_agrees_every_start_iff': 'any type',
    'Becoming.Web.optimum_broken_iff': 'World', 'Becoming.Web.living_on_reaches': 'World',
    'Becoming.Flow.descent_reaches': 'World', 'Becoming.Learning.Training.unselected_beyond_data': 'any type',
    'Becoming.Renewable.no_exact_finite_reading': 'the renewable process',
}
MODEL_WORDS = {'occurrence': ('the occurrence model', '出现模型'), 'process': ("a process's model", '过程之模型'),
               'own': ('its own carrier', '其自身之载体')}


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


assert (ROOT / REVIEW).exists(), REVIEW
REVIEW_TEXT = (ROOT / REVIEW).read_text(encoding='utf-8')


def names_theorem(text, declaration):
    # MV's review guard: the review's file names the item's theorem, its last component as a whole word
    short = declaration.split('.')[-1]
    return re.search(r'(?<![A-Za-z0-9_])' + re.escape(short) + r'(?![A-Za-z0-9_])', text) is not None


def on_own_carrier(row):
    return MODELS[row] == ['own']

# the leaf's declarations: from the receipt when writing, from the source when checking
source = (ROOT / LEAF).read_text(encoding='utf-8')
if CAPS_ONLY:
    names = {'Becoming.ModelStatements.' + n for n in re.findall(r'^(?:theorem|def)\s+([A-Za-z_][A-Za-z0-9_\']*)',
                                                                   source, re.M)}
else:
    core = json.loads((ROOT / RECEIPT).read_text(encoding='utf-8'))
    assert core['status'] == 'passed'
    assert core['source_sha256']['Becoming.ModelStatements'] == sha(LEAF), 'leaf hash'
    mod = next(x for x in core['modules'] if x['module'] == 'Becoming.ModelStatements')
    assert not any(mod['axiom_dependencies'].values()), 'axioms'
    names = {d['name'] for d in mod['declarations']}

laws_of = {}
for record, row, reading, decls, en, zh in LAWS:
    assert set(decls) <= names, (record, sorted(set(decls) - names))
    laws_of.setdefault(record, []).append((row, reading, decls, en, zh))
assert set(MODELS) == {row for _, row, *_ in LAWS} == set(BASES)

items_seen = set()
written = 0
for record, laws in laws_of.items():
    path = RECORDS / f'{record}.json'
    d = json.loads(path.read_text(encoding='utf-8'))
    assert d.get('status') not in ('superseded', 'withdrawn'), record
    before = json.dumps({k: v for k, v in d.items() if k not in ('laws', 'references', 'proof_bindings', 'history')},
                        ensure_ascii=False)
    old_decls = [set(x.get('declarations', [])) for x in d['laws']]
    new_laws = []
    for row, reading, decls, en, zh in laws:
        assert any(row in s for s in old_decls), (record, 'row not among its laws', row)
        items = [{'declaration': p['by'], 'of': p['states'], 'models': MODELS[row], 'review': REVIEW}
                 for p in model_statements(row, reading)]
        for item in items:
            assert item['declaration'] in decls and item['of'] not in decls, (record, item)
            assert item['declaration'] not in items_seen, ('one item per theorem', item['declaration'])
            items_seen.add(item['declaration'])
            assert item['models'] and len(set(item['models'])) == len(item['models'])
            assert set(item['models']) <= {'occurrence', 'process', 'own'}
            assert names_theorem(REVIEW_TEXT, item['declaration']), ('the review does not name', item['declaration'])
        law = {'en': en, 'zh': zh, 'declarations': decls, 'statements_at_model': items}
        assert len(en) <= style.ITEM_CAPS_V2['laws'][0] and len(zh) <= style.ITEM_CAPS_V2['laws'][1], (record, row)
        new_laws.append(law)
    cited = set().union(*(set(x['declarations']) for x in new_laws))
    assert not any(cited & s for s in old_decls), (record, 'cited already')
    for law in new_laws:
        for item in law['statements_at_model']:
            assert not any(item['of'] in set(x['declarations']) for x in new_laws), (record, 'of on an at-model law')
    d['laws'].extend(new_laws)
    assert len(d['laws']) <= style.ITEM_CAPS_V2['laws'][2], (record, len(d['laws']))
    refs = d.setdefault('references', [])
    for ref in ({'path': LEAF, 'role': 'proof', 'declarations': sorted(cited), 'sha256': sha(LEAF)},
                {'path': REVIEW, 'role': 'review', 'sha256': sha(REVIEW)},
                {'path': DESIGN, 'role': 'integration', 'sha256': sha(DESIGN)},
                {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)}) + (
            () if CAPS_ONLY else ({'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},)):
        same = [r for r in refs if r['path'] == ref['path'] and r['role'] == ref['role']]
        if same:
            same[0].update({k: v for k, v in ref.items() if k != 'declarations'})
            if 'declarations' in ref:
                same[0]['declarations'] = sorted(set(same[0].get('declarations', [])) | set(ref['declarations']))
        else:
            refs.append(ref)
    assert any(r['path'] == REVIEW and r['role'] == 'review' for r in refs)
    bindings = d.setdefault('proof_bindings', [])
    bindings[:] = [b for b in bindings if b['source'] != LEAF]
    bindings.append({'source': LEAF, 'receipt': RECEIPT, 'sha256_pointer': '/source_sha256/Becoming.ModelStatements',
                     'success_pointer': '/status', 'success_value': 'passed'})
    rows = ', '.join(f'`{row}`' for row, *_ in laws)
    own_only = all(on_own_carrier(row) for row, *_ in laws)
    where_en = 'on its own carrier' if own_only else 'at the model'
    where_zh = '于其自身之载体上' if own_only else '模型上'
    d['history'].append({
        'en': f"{DATE_EN} (U2, study section {N}): {'a law' if len(laws) == 1 else f'{len(laws)} laws'} {where_en} "
              f"added, stating {rows} where its terms are the grammar's, through the row (F5's statements_at_model, "
              f"reviewed in RECHECK-U2); the row's statement, proof and every other law unchanged.",
        'zh': f"{DATE_ZH}（U2，研究第 {N} 节）：增{where_zh}之律{'' if len(laws) == 1 else f' {len(laws)} 条'}，于其项为文法之处陈述 "
              f"{rows}，经其本行（F5 之 statements_at_model，经 RECHECK-U2 复核）；本行之陈述、证明与他律皆不改。"})
    after = json.dumps({k: v for k, v in d.items() if k not in ('laws', 'references', 'proof_bindings', 'history')},
                       ensure_ascii=False)
    assert after == before, (record, 'another field changed')
    errors = [f for f in style.lint(d) if f['severity'] == 'error']
    for f in errors:
        print('lint:', record, f['field'], f['rule'], f['detail'])
    assert not errors, record
    if not CAPS_ONLY:
        path.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
        written += 1

# the home sections: one bullet per law, after the section's last bullet, with the record's base label
bullets = 0
for record, laws in laws_of.items():
    hits = [p for p in CHAPTERS.glob('0*.md') if f'id="r-{record}"' in p.read_text(encoding='utf-8')]
    assert len(hits) == 1, (record, hits)
    chapter = hits[0]
    text = chapter.read_text(encoding='utf-8')
    lines = text.split('\n')
    start = next(i for i, l in enumerate(lines) if f'id="r-{record}"' in l)
    end = start + 1
    while end < len(lines) and not lines[end].startswith(('<a id=', '#')):
        end += 1
    bullet_lines = [i for i in range(start, end) if lines[i].startswith('- ')]
    if bullet_lines:
        j = bullet_lines[-1] + 1
        while j < end and lines[j].startswith('  '):
            j += 1
        gap = []
    else:
        j = max(i for i in range(start, end) if lines[i].strip()) + 1
        gap = ['']
    new = []
    for row, reading, decls, en, zh in laws:
        names_text = ', '.join(f'`{x}`' for x in decls)
        where = 'On its own carrier.' if on_own_carrier(row) else 'Stated at the model.'
        new.append(f"- **Theorem** ({BASES[row]}). *{where}* {en[:-1]} ({names_text}).")
    assert not any(n in text for n in new), (record, 'bullet present already')
    lines[j:j] = gap + new
    bullets += len(new)
    if not CAPS_ONLY:
        chapter.write_text('\n'.join(lines), encoding='utf-8')

# the leaf's region
regions_path = ROOT / 'theories/becoming/results/data/regions.json'
regions = json.loads(regions_path.read_text(encoding='utf-8'))
entry = {'region': 'root', 'base': 'grammar',
         'note': "U2 rows stated at the grammar's models: occurrence, process, own carrier (each record's law at the model)"}
assert regions['modules'].get('Becoming.ModelStatements') in (None, entry)
if not CAPS_ONLY:
    regions['modules']['Becoming.ModelStatements'] = entry
    regions['modules'] = dict(sorted(regions['modules'].items()))
    regions_path.write_text(json.dumps(regions, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')

print(f"{'checked' if CAPS_ONLY else 'written'}: {len(laws_of)} records ({written} written), "
      f"{sum(len(v) for v in laws_of.values())} laws, {len(items_seen)} items, {bullets} home-section bullets")
