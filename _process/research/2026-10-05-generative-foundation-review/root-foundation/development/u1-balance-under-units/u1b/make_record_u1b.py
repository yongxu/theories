#!/usr/bin/env python3
"""U1b's record, `amounts-by-unit-matchings`: amounts, the root's second sort, by the interface Becoming.UnitMatchings
states (balance represented by selected unit matchings, not derived), home 01 §8.6 after the World's representation.

From the checkout root:
  python3 -B <dir>/make_record_u1b.py --draft OUT        the record without receipt or binding (status open), for review
  python3 -B <dir>/make_record_u1b.py --validate         the draft checked by the registry's own validation, in memory,
                                                         beside every record of the checkout (nothing is written)
  python3 -B <dir>/make_record_u1b.py RECEIPT STUDY      the record, bound to the core run's receipt; STUDY is the study
                                                         section of the landing

The prose fields are record-text.json's, verbatim (written by OU's owner); this script adds the fixed fields, the zh of
the drafted dependency and related details, the references (every declaration of the leaf, in source order) and the
history note. It asserts each law's declarations are the leaf's, each schema-2 length limit, and, given a receipt, that
the receipt passed, binds the leaf's bytes, elaborated every declaration and reports every axiom list empty.
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
MODULE = 'Becoming.UnitMatchings'
SOURCE = PKG + 'Becoming/UnitMatchings.lean'
RID = 'amounts-by-unit-matchings'
REC = f'theories/becoming/results/records/{RID}.json'
DEV = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u1-balance-under-units/'
KIT = DEV + 'u1b/'
CHAPTER = 'theories/becoming/chapters/01-ROOT.md'
TEXT = json.loads((HERE / 'record-text.json').read_text(encoding='utf-8'))
assert TEXT['id'] == RID, TEXT['id']


def digest(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


# The leaf's declarations, in source order; the kit's copy and the package's are the same bytes.
assert (ROOT / SOURCE).read_bytes() == (HERE / 'Becoming/UnitMatchings.lean').read_bytes(), 'the kit and package leaf differ'
LEAF = ['Becoming.UnitMatchings.' + n for n in
        re.findall(r'^(?:theorem|def|structure|inductive) (\S+)', (ROOT / SOURCE).read_text(encoding='utf-8'), re.M)]
THEOREMS = len(re.findall(r'^theorem ', (ROOT / SOURCE).read_text(encoding='utf-8'), re.M))
assert len(LEAF) == len(set(LEAF)) == 24 and THEOREMS == 16, (len(LEAF), THEOREMS)
for law in TEXT['laws']:
    missing = [d for d in law['declarations'] if d not in LEAF]
    assert not missing, ('a law names a declaration the leaf does not have', missing)

# The drafted fields' zh, in the register of record-text.json's own zh (AI-written, 31 October 2026).
DEPENDENCY_ZH = {
    'master-laws-on-the-grammar': '«对»、«对之逆»、«对之取»、«对之长»、«聚之长»、GrammarLaws.revisits_within、mem_middle、split_append 与 total_congr；余为算术（excess_balance、excess_pos、Flow.excess_zero_of_le）。',
    'a-rise-past-the-inflow-is-drawn-from-beyond': 'Flow.Balances.rise_draws_beyond_inflow 予二越界之律以其形成。',
}
RELATED_ZH = {
    'the-world-represented-both-ways': '世界于文法中两向得表示，其数量则否；此记录陈数量所代有者：以所选单位配对为接口。',
}
ALIASES = ['balance by selected unit matchings', '所选单位配对之平衡', 'the interface of amounts', '数量之接口',
           'Becoming.UnitMatchings.frameMatchings_iff_balances', 'Becoming.UnitMatchings.FrameMatch.eq',
           'Becoming.UnitMatchings.crossing_edge', 'Becoming.UnitMatchings.rise_crossing_strong',
           'Becoming.UnitMatchings.endings_count']
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


def receipt_module(receipt):
    data = json.loads((ROOT / receipt).read_text(encoding='utf-8'))
    assert data['status'] == 'passed', receipt
    assert data['source_sha256'][MODULE] == digest(SOURCE), 'the receipt does not bind the leaf as it is'
    m = {x['module']: x for x in data['modules']}[MODULE]
    names = [d['name'] for d in m['declarations']]
    assert set(LEAF) <= set(names), sorted(set(LEAF) - set(names))
    assert not any(m['axiom_dependencies'].values()), [n for n, a in m['axiom_dependencies'].items() if a]
    assert m['theorems'] == THEOREMS and len(names) == len(LEAF), (m['theorems'], len(names))
    return m


def record(receipt=None, study=None, reviewed=None):
    refs = [{'path': SOURCE, 'role': 'proof', 'declarations': LEAF, 'sha256': digest(SOURCE)}]
    if receipt:
        receipt_module(receipt)
        assert '<a id="r-amounts-by-unit-matchings"></a>' in (ROOT / CHAPTER).read_text(encoding='utf-8'), \
            'the home section is not in place: integrate_u1b.py record inserts it before writing the record'
        refs.append({'path': receipt, 'role': 'receipt', 'sha256': digest(receipt), 'declarations': []})
    for path, role in [(KIT + 'REVIEW-U1B.md', 'review'), (DEV + 'REVIEW-U1.md', 'review'),
                       (DEV + 'REVIEW-U1-2.md', 'review'), (DEV + 'DESIGN.md', 'integration'), (CHAPTER, 'statement')]:
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
        'counterexamples': [],
        'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'formal-not-empirical', 'names-provisional'],
        'validation_scope': {
            'en': vs['en'] + f' The leaf, {THEOREMS} theorems in {len(LEAF)} declarations, compiles with the whole '
                             'package in the core run whose receipt the record binds.',
            'zh': vs['zh'] + f'此叶 {len(LEAF)} 声明中定理 {THEOREMS}，与全包同编译于记录所系收据之核心运行。'},
        'next_delta': TEXT['next_delta'],
        'correspondence': TEXT['correspondence'],
        'canonical_source': SOURCE,
        'aliases': ALIASES,
        'dependencies': [{'id': d['id'], 'relation': d['relation'],
                          'detail': {'en': d['detail_en'], 'zh': DEPENDENCY_ZH[d['id']]}}
                         for d in TEXT['dependencies_draft']],
        'related': [{'id': d['id'], 'detail': {'en': d['detail_en'], 'zh': RELATED_ZH[d['id']]}}
                    for d in TEXT['related_draft']],
        'references': refs,
        'proof_bindings': ([{'source': SOURCE, 'receipt': receipt, 'sha256_pointer': f'/source_sha256/{MODULE}',
                             'success_pointer': '/status', 'success_value': 'passed'}] if receipt else []),
        'history': [{
            'en': f'{day.day} {day:%B %Y}, board item U1b (study section {study or "…"}): added. U1\'s limited interface '
                  'for amounts, the root\'s second sort, reviewed in U1\'s design and until then in scratch only, ported '
                  'into one core leaf, Becoming.UnitMatchings, with structural names, what the package already states '
                  'cited and not restated, U1\'s failures its boundary; a cross-model review of the leaf and its '
                  'recheck, every finding taken.',
            'zh': f'{day.year}年{day.month}月{day.day}日，工作板条目 U1b（研究第 {study or "…"} 节）：增。U1 为数量（根之第二类）'
                  '所立之有限接口，经 U1 之设计审阅，前此唯在草稿，移入一核心之叶 Becoming.UnitMatchings，名以结构，'
                  '本包已陈者引之而不重述，U1 之不成为其界；此叶经跨模型之审及其复读，所见皆取。'}],
    }
    limits(r)
    unused = {'about', 'home', 'validation_scope_draft', 'dependencies_draft', 'related_draft'}
    assert set(TEXT) - set(r) == unused, set(TEXT) - set(r) - unused
    return r


def validate(r):
    """The registry's validation of every record of the checkout with this one in place, in memory."""
    sys.path.insert(0, str(ROOT))
    from tools.research import registry
    loaded, errors = registry.load_records()
    assert not errors, errors[:3]
    records = [x for x in loaded if x.get('id') != RID] + [dict(r, _record_path=REC)]
    findings, drift = registry.validate(records)
    mine = [f for f in findings if f.startswith(RID + ':') or RID in f]
    others = [f for f in findings if f not in mine]
    for f in mine:
        print('FINDING', f)
    from tools.research import style
    for f in style.lint(r):
        print('lint', f['severity'], f['field'], f['rule'], str(f['detail'])[:160])
    print(f'{len(mine)} findings on {RID}; {len(others)} elsewhere in the checkout; drift entries {len(drift)}')
    return not mine


if __name__ == '__main__':
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
