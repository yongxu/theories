#!/usr/bin/env python3
"""OU7's record, part A, `conditional-laws-of-the-corpus`: the corpus's units classed 丙一, family by family, each law
with a net where its condition fails (Becoming.GrammarConditionals, with the two general laws the Grammar and
GrammarReadings patches put below it), home 06 §四 at its end.

From the checkout root:
  python3 -B <dir>/make_record_ou7.py --draft OUT        the record without receipt or binding (status open), for review
  python3 -B <dir>/make_record_ou7.py --validate         the draft checked by the registry's own validation, in memory,
                                                         beside every record of the checkout (nothing is written)
  python3 -B <dir>/make_record_ou7.py RECEIPT STUDY      the record, bound to the core run's receipt; STUDY is the study
                                                         section of the landing

The prose fields are record-text.json's, verbatim (AI-written, for OU's owner to keep, shorten or rewrite); this script
adds the fixed fields, the counterexamples' paths, the references (every declaration of the leaf in source order, and
the declarations the laws cite from Grammar and GrammarReadings) and the history note. Before the patches are applied
(on the kit's branch), the three declarations they add are read from the patches; after, from the package. It asserts
each law's declarations exist, each schema-2 length limit, and, given a receipt, that the receipt passed, binds the
three sources' bytes, elaborated every declaration the record names and reports every axiom list empty.
"""
import hashlib
import json
import re
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/'
MODULE = 'Becoming.GrammarConditionals'
SOURCE = PKG + 'Becoming/GrammarConditionals.lean'
BELOW = {'Becoming.Grammar': PKG + 'Becoming/Grammar.lean',
         'Becoming.GrammarReadings': PKG + 'Becoming/GrammarReadings.lean'}
PATCHES = {'Becoming.Grammar': HERE / 'patches/Grammar.patch',
           'Becoming.GrammarReadings': HERE / 'patches/GrammarReadings.patch'}
RID = 'conditional-laws-of-the-corpus'
REC = f'theories/becoming/results/records/{RID}.json'
DEV = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou7-conditional-laws/'
CHAPTER = 'theories/becoming/chapters/06-CLASSICAL-TEXTS.md'
ANCHOR = f'<a id="r-{RID}"></a>'
TEXT = json.loads((HERE / 'record-text.json').read_text(encoding='utf-8'))
assert TEXT['id'] == RID, TEXT['id']
HEADER = re.compile(r'^(?:theorem|def|structure|inductive|abbrev|instance) (\S+)', re.M)


def digest(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def code(text):
    """The text with comments blanked (docstrings and module docs included), so headers are read from code only."""
    return re.sub(r'--[^\n]*', '', re.sub(r'/-.*?-/', '', text, flags=re.S))


# The leaf's declarations, in source order; the kit's copy and the package's are the same bytes once applied.
KIT_LEAF = HERE / 'Becoming/GrammarConditionals.lean'
LEAF_TEXT = KIT_LEAF.read_text(encoding='utf-8')
APPLIED = (ROOT / SOURCE).is_file()
if APPLIED:
    assert (ROOT / SOURCE).read_bytes() == KIT_LEAF.read_bytes(), 'the kit and package leaf differ'
LEAF = ['Becoming.' + n for n in HEADER.findall(code(LEAF_TEXT))]
THEOREMS = len(re.findall(r'^theorem ', code(LEAF_TEXT), re.M))
assert len(LEAF) == len(set(LEAF)) == 41 and THEOREMS == 40, (len(LEAF), THEOREMS)


def below_names(module):
    """The declarations of a module below the leaf: from the package, plus, before its patch is applied, the
    declarations the patch adds (read from its added lines)."""
    names = {'Becoming.' + n for n in HEADER.findall(code((ROOT / BELOW[module]).read_text(encoding='utf-8')))}
    patch = PATCHES[module].read_text(encoding='utf-8').splitlines()
    added = '\n'.join(l[1:] for l in patch if l.startswith('+') and not l.startswith('+++'))
    removed = '\n'.join(l[1:] for l in patch if l.startswith('-') and not l.startswith('---'))
    # A header the diff removes and adds again (an old law re-proved in place) is not a new declaration.
    new = {'Becoming.' + n for n in HEADER.findall(code(added))} - {'Becoming.' + n for n in HEADER.findall(code(removed))}
    assert new, module
    return names | new, new, new <= names


BELOW_NAMES, PATCHED = {}, set()
for m in BELOW:
    names, new, applied = below_names(m)
    BELOW_NAMES[m] = names
    PATCHED |= new
    assert applied == APPLIED, (m, 'the patch applied' if applied else 'the patch not applied',
                                'but the leaf is' if APPLIED else 'but the leaf is not')
CITED = {m: [] for m in BELOW}
for law in TEXT['laws']:
    for decl in law['declarations']:
        homes = [m for m in BELOW if decl in BELOW_NAMES[m]]
        assert decl in LEAF or homes, ('a law names a declaration in none of the three sources', decl)
        for m in homes:
            if decl not in LEAF and decl not in CITED[m]:
                CITED[m].append(decl)
for c in TEXT['counterexamples_draft']:
    assert 'Becoming.' + c['declaration'] in LEAF, c['declaration']

# The drafted fields' zh, in the register of record-text.json's own zh (AI-written, 31 October 2026).
ALIASES = ['the corpus\'s conditional laws', '丙一之律', 'conditional laws of the corpus, family by family',
           'Becoming.«皆有后而步皆分则全生成»', 'Becoming.«线不返则短于所列»', 'Becoming.«不返而有限则非不穷»',
           'Becoming.«核同则同不穷»', 'Becoming.«所依无则依者无»', 'Becoming.«依之传»',
           'Becoming.«亡者异当且仅当有后»']
assert all(a in LEAF for a in ALIASES if a.startswith('Becoming.'))

# Schema-2 limits (RESULT-WORKFLOW, "Writing a record"), per language: (en, zh, items or None, an error or a warning).
LIMITS = {'title': (100, 40, None, True), 'statement': (300, 150, None, True), 'laws': (420, 190, None, False),
          'hypotheses': (420, 190, 9, False), 'does_not_show': (240, 110, 8, False),
          'validation_scope': (600, 260, None, True), 'next_delta': (400, 180, None, True),
          'correspondence': (1200, 500, None, False)}
OVER = []


def limits(r):
    """Assert the caps the lint treats as errors; list the others' excess (the lint warns), once per record built."""
    OVER.clear()
    for key, (en, zh, items, error) in LIMITS.items():
        value = r[key]
        entries = value if isinstance(value, list) else [value]
        assert items is None or len(entries) <= items, (key, len(entries))
        for i, e in enumerate(entries, 1):
            n_en, n_zh = len(e.get('en', '')), len(e.get('zh', ''))
            if n_en > en or n_zh > zh:
                assert not error, (key, n_en, n_zh)
                OVER.append(f'{key} {i}: {n_en}/{en} en, {n_zh}/{zh} zh')
    for line in OVER:
        print('over a warning cap (the prose is record-text.json\'s, not changed here):', line, file=sys.stderr)


def receipt_modules(receipt):
    """The receipt's entries for the leaf and the two modules below, checked against the sources as they are."""
    data = json.loads((ROOT / receipt).read_text(encoding='utf-8'))
    assert data['status'] == 'passed', receipt
    mods = {x['module']: x for x in data['modules']}
    out = {}
    for module, path, names in [(MODULE, SOURCE, LEAF)] + [(m, BELOW[m], CITED[m]) for m in BELOW]:
        assert data['source_sha256'][module] == digest(path), ('the receipt does not bind the source as it is', path)
        m = mods[module]
        declared = {d['name'] for d in m['declarations']}
        assert set(names) <= declared, sorted(set(names) - declared)
        assert not any(m['axiom_dependencies'].values()), [n for n, a in m['axiom_dependencies'].items() if a]
        out[module] = m
    leaf = out[MODULE]
    assert leaf['theorems'] == THEOREMS and len(leaf['declarations']) == len(LEAF), (leaf['theorems'], len(leaf['declarations']))
    return out


def record(receipt=None, study=None, reviewed=None):
    refs = [{'path': SOURCE, 'role': 'proof', 'declarations': LEAF, 'sha256': digest(SOURCE) if APPLIED else '0' * 64}]
    for m in BELOW:
        refs.append({'path': BELOW[m], 'role': 'proof', 'declarations': CITED[m], 'sha256': digest(BELOW[m])})
    if receipt:
        assert APPLIED, 'a receipt is given but the leaf is not in the package'
        receipt_modules(receipt)
        assert ANCHOR in (ROOT / CHAPTER).read_text(encoding='utf-8'), \
            'the home section is not in place: integrate_ou7.py record inserts it before writing the record'
        refs.append({'path': receipt, 'role': 'receipt', 'sha256': digest(receipt), 'declarations': []})
    for path, role in [(DEV + 'data/groups.tsv', 'statement'), (DEV + 'review/FINDINGS.md', 'review'),
                       (DEV + 'DESIGN.md', 'integration'), (CHAPTER, 'statement')]:
        assert (ROOT / path).is_file(), path
        refs.append({'path': path, 'role': role, 'sha256': digest(path), 'declarations': []})
    now = reviewed or datetime.now(timezone.utc).replace(microsecond=0).isoformat()
    day = datetime.fromisoformat(now)
    vs = TEXT['validation_scope_draft']
    r = {
        'schema_version': 2,
        'id': RID,
        'title': TEXT['title'],
        'kind': 'theorem',
        'status': 'recorded-checked' if receipt else 'open',
        'family': 'F01',
        'reviewed_at_utc': now,
        'statement': TEXT['statement'],
        'laws': TEXT['laws'],
        'hypotheses': TEXT['hypotheses'],
        'does_not_show': TEXT['does_not_show'],
        'counterexamples': [{'path': SOURCE, 'detail': {'en': f"{c['en']} ({c['declaration']})",
                                                         'zh': f"{c['zh']}（{c['declaration']}）"}}
                            for c in TEXT['counterexamples_draft']],
        'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'formal-not-empirical',
                                'conditional-not-universal', 'names-provisional'],
        'validation_scope': {
            'en': vs['en'] + f' The leaf, {THEOREMS} theorems in {len(LEAF)} declarations, compiles with the whole '
                             'package in the core run whose receipt the record binds.',
            'zh': vs['zh'] + f'此叶 {len(LEAF)} 声明中定理 {THEOREMS}，与全包同编译于记录所系收据之核心运行。'},
        'next_delta': TEXT['next_delta'],
        'correspondence': TEXT['correspondence'],
        'canonical_source': SOURCE,
        'aliases': ALIASES,
        'dependencies': [{'id': d['id'], 'relation': d['relation'],
                          'detail': {'en': d['detail_en'], 'zh': d['detail_zh']}}
                         for d in TEXT['dependencies_draft']],
        'related': [{'id': d['id'], 'detail': {'en': d['detail_en'], 'zh': d['detail_zh']}}
                    for d in TEXT['related_draft']],
        'references': refs,
        'proof_bindings': ([{'source': path, 'receipt': receipt, 'sha256_pointer': f'/source_sha256/{module}',
                             'success_pointer': '/status', 'success_value': 'passed'}
                            for module, path in [(MODULE, SOURCE)] + list(BELOW.items())] if receipt else []),
        'history': [{
            'en': f'{day.day} {day:%B %Y}, board item OU7 (study section {study or "…"}): added. The 219 units classed '
                  '丙一 read as laws of every carrier, relation and class, 128 of them in 22 families, each law with a '
                  'net where its condition fails; the new laws and the witnesses in one core leaf, '
                  'Becoming.GrammarConditionals; two general laws put below it, in Grammar and GrammarReadings, with '
                  'the old laws as their cases; one independent AI review of the design, every finding taken.',
            'zh': f'{day.year}年{day.month}月{day.day}日，工作板条目 OU7（研究第 {study or "…"} 节）：增。归为丙一之 219 条'
                  '读作对一切载体、关系与类之律，其中 128 条入 22 族，每律有其条件不成立之网；新律与见证在一核心之叶 '
                  'Becoming.GrammarConditionals；两条一般之律放在其下，在 Grammar 与 GrammarReadings，旧律为其一例；'
                  '设计经一次独立之 AI 审查，所见皆取。'}],
    }
    limits(r)
    unused = {'about', 'home', 'validation_scope_draft', 'dependencies_draft', 'related_draft', 'counterexamples_draft'}
    assert set(TEXT) - set(r) == unused, set(TEXT) - set(r) - unused
    return r


def validate(r):
    """The registry's validation of every record of the checkout with this one in place, in memory. Before the
    landing the leaf is not in the package and the patches are not applied, so the leaf's reference has a
    placeholder digest, and the findings on the leaf's path and on the three declarations the patches add are listed
    apart."""
    sys.path.insert(0, str(ROOT))
    from tools.research import registry
    loaded, errors = registry.load_records()
    assert not errors, errors[:3]
    records = [x for x in loaded if x.get('id') != RID] + [dict(r, _record_path=REC)]
    findings, drift = registry.validate(records)
    mine = [f for f in findings if f.startswith(RID + ':') or RID in f]
    unapplied = [f for f in mine if not APPLIED and (SOURCE in f or 'GrammarConditionals' in f
                                                    or any(n in f for n in PATCHED))]
    others = [f for f in findings if f not in mine]
    for f in mine:
        print('FINDING' + (' (before the landing)' if f in unapplied else ''), f)
    from tools.research import style
    for f in style.lint(r):
        print('lint', f['severity'], f['field'], f['rule'], str(f['detail'])[:160])
    print(f'{len(mine)} findings on {RID} ({len(unapplied)} only because the kit is not applied); '
          f'{len(others)} elsewhere in the checkout; drift entries {len(drift)}')
    return len(mine) == len(unapplied)


if __name__ == '__main__':
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    if sys.argv[1] == '--draft':
        Path(sys.argv[2]).write_text(json.dumps(record(), ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
        print('draft written', sys.argv[2])
    elif sys.argv[1] == '--validate':
        sys.exit(0 if validate(record()) else 1)
    else:
        receipt, study = sys.argv[1], sys.argv[2]
        r = record(receipt, study)
        (ROOT / REC).write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
        print('written', REC)
