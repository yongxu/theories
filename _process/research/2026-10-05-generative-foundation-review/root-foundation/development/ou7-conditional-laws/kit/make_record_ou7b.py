#!/usr/bin/env python3
"""OU7's record, part B, `rooms-tested-by-a-window`: 验's model examples, one rule of rooms (an unheated room and two
thermostats) tested by a window on the net of the possible (Becoming.RoomNet on the grammar, Becoming.RoomRuns joining
it to RegimeMargin's runs and HeldPossible, both in the instance ring: they read the core's laws on one named carrier),
home 03 §3 after testing-within-the-net.

From the checkout root:
  python3 -B <dir>/make_record_ou7b.py --draft OUT        the record without receipt or binding (status open), for review
  python3 -B <dir>/make_record_ou7b.py --validate         the draft checked by the registry's own validation, in memory,
                                                          beside every record of the checkout (nothing is written)
  python3 -B <dir>/make_record_ou7b.py RECEIPT STUDY      the record, bound to the core run's receipt; STUDY is the study
                                                          section of the landing

The prose fields are part B's check/kit/record-text.json, verbatim (AI-written, for OU's owner to keep, shorten or
rewrite), without its keys about, home and modules. This script adds the fixed fields, the counts in the validation
scope (read from the leaves, and from the receipt at the landing), the references (every declaration of each leaf in
source order, the review, the design and the home section), the proof bindings and the history note. The leaves are
part B's scratch copies (check/scratch/Becoming) until the landing copies them into the package, after which the two
must be the same bytes. It asserts every declaration the record names is a leaf's, each schema-2 length limit, and,
given a receipt, that the receipt passed, binds both leaves' bytes, elaborated every declaration and reports every
axiom list empty.
"""
import hashlib
import importlib.util
import json
import re
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
if 'make_record_ou7' in sys.modules:
    mr = sys.modules['make_record_ou7']
else:
    spec = importlib.util.spec_from_file_location('make_record_ou7', HERE / 'make_record_ou7.py')
    mr = sys.modules['make_record_ou7'] = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mr)

PKG = mr.PKG
MODULES = {'Becoming.RoomNet': PKG + 'Becoming/RoomNet.lean', 'Becoming.RoomRuns': PKG + 'Becoming/RoomRuns.lean'}
SCRATCH = HERE.parent / 'check/scratch/Becoming'
KIT_LEAVES = {m: SCRATCH / Path(p).name for m, p in MODULES.items()}
RID = 'rooms-tested-by-a-window'
REC = f'theories/becoming/results/records/{RID}.json'
CHECK = mr.DEV + 'check/'
CHAPTER = 'theories/becoming/chapters/03-KNOWING.md'
ANCHOR = f'<a id="r-{RID}"></a>'
TEXT = json.loads((HERE.parent / 'check/kit/record-text.json').read_text(encoding='utf-8'))
assert TEXT['id'] == RID and TEXT['modules'] == MODULES, (TEXT['id'], TEXT['modules'])
HEAD = re.compile(r'^(?:(?:private|protected|noncomputable) )*(theorem|lemma|def|structure|inductive|abbrev|instance) (\S+)')


def declarations(text):
    """Each declaration's full name, in source order, from the code with comments blanked, with the namespaces open
    where it stands; and the number of theorems."""
    stack, names, theorems = [], [], 0
    for line in mr.code(text).splitlines():
        if m := re.match(r'namespace (\S+)', line):
            stack += m.group(1).split('.')
        elif re.match(r'section\b', line):
            stack.append(None)
        elif m := re.match(r'end\b ?(\S*)', line):
            parts = m.group(1).split('.') if m.group(1) else [None]
            assert stack[-len(parts):] == parts, ('an end that closes nothing open', line, stack)
            del stack[-len(parts):]
        elif m := HEAD.match(line):
            names.append('.'.join([s for s in stack if s] + [m.group(2)]))
            theorems += m.group(1) in ('theorem', 'lemma')
    assert not stack, stack
    return names, theorems


# Each leaf's declarations in source order; the scratch copy and the package's are the same bytes once applied.
APPLIED = {m: (ROOT / p).is_file() for m, p in MODULES.items()}
assert len(set(APPLIED.values())) == 1, ('one leaf in the package and not the other', APPLIED)
APPLIED = all(APPLIED.values())
LEAVES, THEOREMS = {}, {}
for m, kit in KIT_LEAVES.items():
    if APPLIED:
        assert (ROOT / MODULES[m]).read_bytes() == kit.read_bytes(), ('the scratch and package leaf differ', m)
    LEAVES[m], THEOREMS[m] = declarations(kit.read_text(encoding='utf-8'))
    assert len(LEAVES[m]) == len(set(LEAVES[m])), m
assert [(len(LEAVES[m]), THEOREMS[m]) for m in MODULES] == [(120, 94), (27, 24)], (
    [(len(LEAVES[m]), THEOREMS[m]) for m in MODULES])
NAMES = {n for m in MODULES for n in LEAVES[m]}
NAMED = ({d for law in TEXT['laws'] for d in law['declarations']}
         | {x['witness'] for x in TEXT['does_not_show'] if 'witness' in x}
         | {a for a in TEXT['aliases'] if a.startswith('Becoming.')})
assert NAMED <= NAMES, ('the record names a declaration neither leaf has', sorted(NAMED - NAMES))
for c in TEXT['counterexamples']:
    assert c['path'] in MODULES.values(), c['path']
for d in TEXT['dependencies']:
    assert d.get('interface', {}).get('evidence') in MODULES.values(), d['id']

PLACEHOLDER = {'en': ' (counts and receipt filled at landing)', 'zh': '（数目与收据于落地时填入）'}


def counts(receipt_modules=None):
    """The validation scope's counts, from the receipt at the landing (asserted equal to the leaves' own), or from
    the leaves before it."""
    if receipt_modules:
        for m in MODULES:
            got = (len(receipt_modules[m]['declarations']), receipt_modules[m]['theorems'])
            assert got == (len(LEAVES[m]), THEOREMS[m]), (m, got)
    (net, runs) = MODULES
    en = (f' (RoomNet {THEOREMS[net]} theorems in {len(LEAVES[net])} declarations, RoomRuns {THEOREMS[runs]} in '
          f'{len(LEAVES[runs])}, in the core run whose receipt the record binds)')
    zh = (f'（RoomNet {len(LEAVES[net])} 声明中定理 {THEOREMS[net]}，RoomRuns {len(LEAVES[runs])} 声明中定理 '
          f'{THEOREMS[runs]}，于记录所系收据之核心运行）')
    vs = TEXT['validation_scope']
    assert all(vs[k].count(PLACEHOLDER[k]) == 1 for k in PLACEHOLDER), 'the validation scope lost its placeholder'
    return {'en': vs['en'].replace(PLACEHOLDER['en'], en), 'zh': vs['zh'].replace(PLACEHOLDER['zh'], zh)}


def receipt_modules(receipt):
    """The receipt's entries for the two leaves, checked against the sources as they are."""
    data = json.loads((ROOT / receipt).read_text(encoding='utf-8'))
    assert data['status'] == 'passed', receipt
    mods = {x['module']: x for x in data['modules']}
    out = {}
    for module, path in MODULES.items():
        assert data['source_sha256'][module] == mr.digest(path), ('the receipt does not bind the source as it is', path)
        m = mods[module]
        declared = {d['name'] for d in m['declarations']}
        assert set(LEAVES[module]) <= declared, sorted(set(LEAVES[module]) - declared)
        assert not any(m['axiom_dependencies'].values()), [n for n, a in m['axiom_dependencies'].items() if a]
        out[module] = m
    return out


def record(receipt=None, study=None, reviewed=None):
    # A leaf's digest is its bytes', the scratch copy's before the landing (the package's is the same bytes after).
    refs = [{'path': p, 'role': 'proof', 'declarations': LEAVES[m],
             'sha256': hashlib.sha256(KIT_LEAVES[m].read_bytes()).hexdigest()} for m, p in MODULES.items()]
    found = None
    if receipt:
        assert APPLIED, 'a receipt is given but the leaves are not in the package'
        found = receipt_modules(receipt)
        assert ANCHOR in (ROOT / CHAPTER).read_text(encoding='utf-8'), \
            'the home section is not in place: integrate_ou7.py record inserts it before writing the record'
        refs.append({'path': receipt, 'role': 'receipt', 'sha256': mr.digest(receipt), 'declarations': []})
    for path, role in [(CHECK + 'review/FINDINGS.md', 'review'), (CHECK + 'DESIGN.md', 'integration'),
                       (CHAPTER, 'statement')]:
        assert (ROOT / path).is_file(), path
        refs.append({'path': path, 'role': role, 'sha256': mr.digest(path), 'declarations': []})
    now = reviewed or datetime.now(timezone.utc).replace(microsecond=0).isoformat()
    day = datetime.fromisoformat(now)
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
        'counterexamples': TEXT['counterexamples'],
        'standard_boundaries': TEXT['standard_boundaries'],
        'validation_scope': counts(found),
        'next_delta': TEXT['next_delta'],
        'correspondence': TEXT['correspondence'],
        'canonical_source': MODULES['Becoming.RoomNet'],
        'aliases': TEXT['aliases'],
        'dependencies': TEXT['dependencies'],
        'related': TEXT['related'],
        'references': refs,
        'proof_bindings': ([{'source': path, 'receipt': receipt, 'sha256_pointer': f'/source_sha256/{module}',
                             'success_pointer': '/status', 'success_value': 'passed'}
                            for module, path in MODULES.items()] if receipt else []),
        'history': [{
            'en': f'{day.day} {day:%B %Y}, board item OU7 (study section {study or "…"}): added. 验\'s model examples '
                  'on the net of the possible: one rule of rooms, an unheated room and two thermostats, tested by a '
                  'window, in two modules of the instance ring, Becoming.RoomNet on the grammar and Becoming.RoomRuns '
                  'joining it to RegimeMargin\'s runs and HeldPossible; the toy «恒温与平衡» derived at a margin of one; '
                  'one independent AI review of the design and both modules and its re-check, every point taken.',
            'zh': f'{day.year}年{day.month}月{day.day}日，工作板条目 OU7（研究第 {study or "…"} 节）：增。可能之网上验之'
                  '模型之例：一则之诸室，无给之室与二恒温器，以窗验之，在实例之环之二模块，Becoming.RoomNet 在文法上，'
                  'Becoming.RoomRuns 接之于 RegimeMargin 之进程与 HeldPossible；«恒温与平衡» 之例于余量一推出；'
                  '设计与二模块经一次独立之 AI 审查及其复核，所见皆取。'}],
    }
    mr.limits(r)
    assert set(TEXT) - set(r) == {'about', 'home', 'modules'}, set(TEXT) - set(r)
    return r


def validate(r):
    """The registry's validation of every record of the checkout with this one in place, in memory. Before the
    landing the leaves are not in the package, so the findings on their paths and declarations are listed apart."""
    sys.path.insert(0, str(ROOT))
    from tools.research import registry, style
    loaded, errors = registry.load_records()
    assert not errors, errors[:3]
    records = [x for x in loaded if x.get('id') != RID] + [dict(r, _record_path=REC)]
    findings, drift = registry.validate(records)
    mine = [f for f in findings if f.startswith(RID + ':') or RID in f]
    unapplied = [f for f in mine if not APPLIED and any(p in f for p in MODULES.values())]
    others = [f for f in findings if f not in mine]
    for f in mine:
        print('FINDING' + (' (before the landing)' if f in unapplied else ''), f[:240])
    for f in style.lint(r):
        print('lint', f['severity'], f['field'], f['rule'], str(f['detail'])[:160])
    print(f'{len(mine)} findings on {RID} ({len(unapplied)} only because the leaves are not in the package); '
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
