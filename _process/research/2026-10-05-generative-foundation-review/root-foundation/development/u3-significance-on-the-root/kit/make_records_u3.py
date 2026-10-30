#!/usr/bin/env python3
"""U3's records. To each row's own record (four records) add its law on the root, one per row, with references to
the modules proving it, to the review that checked it, to the design, the study and the receipt, the modules' proof
bindings and a history note. A root form keeping its row's full generality (rows 5, 7 and 10) carries F5's field
`statements_at_model` (model `own`, MV's spec §1); a specialization at the own-closure reading (rows 1, 8 and 9)
carries none, since F5 takes no instance or specialization as an item (spec §4). Under each record's home section in
chapter 7, one bullet per law, with the row's base label. Every row's statement and proof, and every other field, are
unchanged. MV's rules are asserted as U2's kit asserts them:
- `declaration` is among the law's own declarations;
- `of` is among another law's declarations in the same record;
- no declaration of a law carrying items is any item's `of`;
- `review` is the path of a reference of role review in the record, and it names the theorem;
- each theorem is the declaration of at most one item.
Style caps and lint (tools/research/style.py) run on every record written.
usage (from the checkout root, after integrate_u3.py has put the sources in the package):
       python3 -B make_records_u3.py RECEIPT N REVIEW   (writes)
       python3 -B make_records_u3.py --caps REVIEW      (checks only; writes nothing; reads the package's sources)
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
from laws_u3 import LAWS, MODELS, BASES, SPECIALIZATIONS, source_of  # noqa: E402

CAPS_ONLY = sys.argv[1] == '--caps'
if CAPS_ONLY:
    RECEIPT_ID, N, REVIEW = '20261030T000000.000000Z', 0, sys.argv[2]
else:
    RECEIPT_ID, N, REVIEW = sys.argv[1], int(sys.argv[2]), sys.argv[3]
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
KITD = RF + 'development/u3-significance-on-the-root/'
STUDY = RF + 'BECOMING-RENEWAL-READING.md'
DESIGN = KITD + 'DESIGN.md'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
CHAPTERS = ROOT / 'theories/becoming/chapters'
TODAY = datetime.date.today()
DATE_EN, DATE_ZH = f'{TODAY.day} {TODAY:%B} {TODAY.year}', f'{TODAY.year}年{TODAY.month}月{TODAY.day}日'


def path_of(module):
    return f'{PKG}/Becoming/{module.split(".", 1)[1]}.lean'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


assert (ROOT / REVIEW).exists(), REVIEW
REVIEW_TEXT = (ROOT / REVIEW).read_text(encoding='utf-8')


def names_theorem(text, declaration):
    # the registry's guard (tools/research/registry.py): the review names the theorem in backticks, qualified or not
    short = declaration.split('.')[-1]
    return re.search(r'`(?:[^`\s]*\.)?' + re.escape(short) + '`', text) is not None


# the modules' declarations: from the receipt when writing, from the sources when checking
MODULES = sorted({source_of(x) for _, _, _, decls, *_ in LAWS for x in decls})
names = set()
if CAPS_ONLY:
    for module in MODULES:
        source = (ROOT / path_of(module)).read_text(encoding='utf-8')
        if module == 'Becoming.GrammarScope':
            for x in {x for _, _, _, decls, *_ in LAWS for x in decls if source_of(x) == module}:
                assert 'theorem ' + x.split('.', 1)[1] + ' ' in source, x
                names.add(x)
            continue
        ns = re.search(r'^namespace Becoming\s*\nnamespace (\S+)', source, re.M)
        for n in re.findall(r'^(?:theorem|def)\s+([A-Za-z_][A-Za-z0-9_\']*)', source, re.M):
            names.add(f'Becoming.{ns.group(1)}.{n}' if module == 'Becoming.SignificanceStatements' else f'Becoming.Weighting.{n}')
else:
    core = json.loads((ROOT / RECEIPT).read_text(encoding='utf-8'))
    assert core['status'] == 'passed'
    for module in MODULES:
        assert core['source_sha256'][module] == sha(path_of(module)), (module, 'hash')
        mod = next(x for x in core['modules'] if x['module'] == module)
        assert not any(mod['axiom_dependencies'].values()), (module, 'axioms')
        names |= {d['name'] for d in mod['declarations']}

laws_of = {}
for record, row, by, decls, en, zh in LAWS:
    assert set(decls) <= names, (record, sorted(set(decls) - names))
    laws_of.setdefault(record, []).append((row, by, decls, en, zh))

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
    for row, by, decls, en, zh in laws:
        assert any(row in s for s in old_decls), (record, 'row not among its laws', row)
        assert names_theorem(REVIEW_TEXT, by), ('the review does not name', by)
        law = {'en': en, 'zh': zh, 'declarations': decls}
        if row in MODELS:
            item = {'declaration': by, 'of': row, 'models': MODELS[row], 'review': REVIEW}
            assert item['declaration'] in decls and item['of'] not in decls, (record, item)
            assert by not in items_seen, ('one item per theorem', by)
            items_seen.add(by)
            law['statements_at_model'] = [item]
        else:
            assert row in SPECIALIZATIONS, row
        assert len(en) <= style.ITEM_CAPS_V2['laws'][0] and len(zh) <= style.ITEM_CAPS_V2['laws'][1], (record, row)
        new_laws.append(law)
    cited = set().union(*(set(x['declarations']) for x in new_laws))
    assert not any(cited & s for s in old_decls), (record, 'cited already')
    for law in new_laws:
        for item in law.get('statements_at_model', []):
            assert not any(item['of'] in set(x['declarations']) for x in new_laws), (record, 'of on a root law')
    d['laws'].extend(new_laws)
    assert len(d['laws']) <= style.ITEM_CAPS_V2['laws'][2], (record, len(d['laws']))
    refs = d.setdefault('references', [])
    by_module = {}
    for decl in sorted(cited):
        by_module.setdefault(source_of(decl), []).append(decl)
    new_refs = [{'path': path_of(m), 'role': 'proof', 'declarations': ds, 'sha256': sha(path_of(m))}
                for m, ds in sorted(by_module.items())]
    new_refs += [{'path': REVIEW, 'role': 'review', 'sha256': sha(REVIEW)},
                 {'path': DESIGN, 'role': 'integration', 'sha256': sha(DESIGN)},
                 {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)}]
    if not CAPS_ONLY:
        new_refs.append({'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)})
    for ref in new_refs:
        same = [r for r in refs if r['path'] == ref['path'] and r['role'] == ref['role']]
        if same:
            same[0].update({k: v for k, v in ref.items() if k != 'declarations'})
            if 'declarations' in ref:
                same[0]['declarations'] = sorted(set(same[0].get('declarations', [])) | set(ref['declarations']))
        else:
            refs.append(ref)
    assert any(r['path'] == REVIEW and r['role'] == 'review' for r in refs)
    bindings = d.setdefault('proof_bindings', [])
    for module in sorted(by_module):
        source = path_of(module)
        # every earlier binding of the source goes (U2's kit): an older receipt holds an older hash of a changed
        # source, and the new receipt binds the current file (checked above)
        bindings[:] = [b for b in bindings if b['source'] != source]
        bindings.append({'source': source, 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/{module}',
                         'success_pointer': '/status', 'success_value': 'passed'})
    stated = [row for row, *_ in laws if row in MODELS]
    special = [row for row, *_ in laws if row in SPECIALIZATIONS]
    parts_en, parts_zh = [], []
    if stated:
        listed = ', '.join(f'`{r}`' for r in stated)
        parts_en.append(f"stating {listed} in the grammar's terms on its own carrier, through the row (F5's "
                        f"statements_at_model, model own)")
        parts_zh.append(f"于其自身之载体上以文法之项陈述 {listed}，经其本行（F5 之 statements_at_model，模型 own）")
    if special:
        listed = ', '.join(f'`{r}`' for r in special)
        parts_en.append(f"specializing {listed} at the own-closure reading of significance, through the row (no F5 "
                        f"item: a specialization states less than its row)")
        parts_zh.append(f"于意义之自闭包读法下特化 {listed}，经其本行（无 F5 项：特化所述少于本行）")
    d['history'].append({
        'en': f"{DATE_EN} (U3, study section {N}): {'a law' if len(laws) == 1 else f'{len(laws)} laws'} on the root "
              f"added, {'; '.join(parts_en)}; reviewed in {Path(REVIEW).name}; a restatement or a specialization, not a derivation; "
              f"the row's statement, proof and every other law unchanged.",
        'zh': f"{DATE_ZH}（U3，研究第 {N} 节）：增根上之律{'' if len(laws) == 1 else f' {len(laws)} 条'}，"
              f"{'；'.join(parts_zh)}；经 {Path(REVIEW).name} 复核；为重述或特化，非推导；本行之陈述、证明与他律皆不改。"})
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

# the home sections: one bullet per law, after the section's last bullet, with the row's base label
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
    for row, by, decls, en, zh in laws:
        names_text = ', '.join(f'`{x}`' for x in decls)
        label = 'On its own carrier.' if row in MODELS else 'At the own-closure reading.'
        new.append(f"- {BASES[row]}. *{label}* {en[:-1]} ({names_text}).")
    assert not any(n in text for n in new), (record, 'bullet present already')
    lines[j:j] = gap + new
    bullets += len(new)
    if not CAPS_ONLY:
        chapter.write_text('\n'.join(lines), encoding='utf-8')

# the leaf's region
regions_path = ROOT / 'theories/becoming/results/data/regions.json'
regions = json.loads(regions_path.read_text(encoding='utf-8'))
entry = {'region': 'significance', 'base': 'grammar',
         'note': "U3: the significance rows stated on the root, rows 5, 7 and 10 on their own carrier and rows 1, 8 and 9 "
                "at the own-closure reading (each record's law on the root)"}
assert regions['modules'].get('Becoming.SignificanceStatements') in (None, entry)
if not CAPS_ONLY:
    regions['modules']['Becoming.SignificanceStatements'] = entry
    regions['modules'] = dict(sorted(regions['modules'].items()))
    regions_path.write_text(json.dumps(regions, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')

print(f"{'checked' if CAPS_ONLY else 'written'}: {len(laws_of)} records ({written} written), "
      f"{sum(len(v) for v in laws_of.values())} laws, {len(items_seen)} F5 items, {bullets} home-section bullets")
