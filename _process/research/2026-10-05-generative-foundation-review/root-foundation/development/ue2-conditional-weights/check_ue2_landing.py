#!/usr/bin/env python3
"""UE2 landing check, read-only: no file is written. It runs none of the landing scripts; it reads their anchors and
calls the two record functions in memory.

1. Every anchor of integrate_ue2.py and texts_ue2.py, applied in order in memory, occurs exactly once; while UE4 is
   unlanded, again after UE4's integrate and texts edits are applied first, in memory.
2. The records UE2's edits would put out of date, by registry.scoped_drift's rule, simulated.
3. make_records_ue2.records() on the kit build's audited names: the partition, the schema-2 fields, the lint and the
   aliases. It needs the scratch build's audit files in tree/.build, which git ignores, so it is skipped without them.
4. update_typicality_record_ue2.update() on a copy of typicality-by-counting: its assertions, fields and lint.
usage (from a checkout root, before integrate_ue2.py): python3 -B <kit>/check_ue2_landing.py"""
import ast
import copy
import difflib
import importlib.util
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
sys.path.insert(0, str(ROOT))
from tools.research import registry, style  # noqa: E402
from tools.research.reading_catalogue import anchors_from_text  # noqa: E402

RF = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation'
KIT = RF / 'development/ue2-conditional-weights'
U4 = RF / 'development/ue4-second-order'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
CH = ROOT / 'theories/becoming/chapters'
RECORDS = ROOT / 'theories/becoming/results/records'
RA, RB = 'conditioning-by-restriction', 'exit-from-a-margin'
NS = {'CH': CH, 'RA': RA, 'RB': RB, 'RID': 'eventual-widening', 'Path': Path,
      'KIT': '../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue4-second-order/DESIGN.md',
      'root': PKG / 'Becoming.lean', 'checker': PKG / 'check_becoming.py', 'readme': PKG / 'README.md',
      'readme_zh': PKG / 'README.zh.md'}


def calls(script, names):
    """(function, evaluated args) of the top-level calls to `names`, in source order."""
    tree = ast.parse(script.read_text(encoding='utf-8'))
    out = []
    for node in tree.body:
        if isinstance(node, ast.Expr) and isinstance(node.value, ast.Call) and getattr(node.value.func, 'id', None) in names:
            args = [eval(compile(ast.Expression(a), script.name, 'eval'), dict(NS)) for a in node.value.args]
            out.append((node.value.func.id, args, node.lineno))
    return out


def simulate(with_ue4):
    texts = {}

    def get(p):
        if p not in texts:
            texts[p] = p.read_text(encoding='utf-8')
        return texts[p]

    report = []
    if with_ue4:
        for script in (U4 / 'integrate_ue4.py', U4 / 'texts_ue4.py'):
            for f, (p, old, new), line in calls(script, {'edit'}):
                assert get(p).count(old) == 1, ('UE4 anchor', script.name, line)
                texts[p] = get(p).replace(old, new)
        for p in (PKG / 'README.md', PKG / 'README.zh.md'):  # UE4's rows after Regions' (line inserts)
            lines = get(p).split('\n')
            at = [i for i, l in enumerate(lines) if l.startswith('| L1 | [`Becoming.Regions`]')]
            assert len(at) == 1
            lines[at[0] + 1:at[0] + 1] = ['| L1 | [`Becoming.EventualWidening`](x) | y |',
                                          '| L1 | [`Becoming.EventualWideningInstances`](x) | y |']
            texts[p] = '\n'.join(lines)
        apart = RF / 'THEOREM-CONNECTIVITY-APART.json'  # UE4's register: entries before the anchor
        anchor = '  }\n },\n "instances": {'
        assert get(apart).count(anchor) == 1
        texts[apart] = get(apart).replace(anchor, '  },\n  "Becoming.EventualWidening.x": {\n   "module": "m",\n'
                                          '   "category": "support",\n   "reason": "r"\n  }\n },\n "instances": {')
    # UE2: integrate
    for f, (p, old, new), line in calls(KIT / 'integrate_ue2.py', {'edit'}):
        n = get(p).count(old)
        report.append((f'integrate:{line} {p.name}', n))
        if n == 1:
            texts[p] = get(p).replace(old, new)
    for p in (PKG / 'README.md', PKG / 'README.zh.md'):
        lines = get(p).split('\n')
        n = sum(l.startswith('| L1 | [`Becoming.Typicality`]') for l in lines)
        report.append((f'integrate: row after Typicality in {p.name}', n))
        at = [i for i, l in enumerate(lines) if l.startswith('| L1 | [`Becoming.Typicality`]')]
        lines[at[0] + 1:at[0] + 1] = ['| L1 | [`Becoming.ConditionalWeights`](Becoming/ConditionalWeights.lean) | z |']
        texts[p] = '\n'.join(lines)
    # UE2: texts
    for f, args, line in calls(KIT / 'texts_ue2.py', {'edit', 'insert_after_line'}):
        p = args[0]
        if f == 'edit':
            old, new = args[1], args[2]
            n = get(p).count(old)
            report.append((f'texts:{line} {p.name}', n))
            if n == 1:
                texts[p] = get(p).replace(old, new)
        else:
            start, block = args[1], args[2]
            lines = get(p).split('\n')
            at = [i for i, l in enumerate(lines) if l.startswith(start)]
            report.append((f'texts:{line} {p.name} (line start)', len(at)))
            if len(at) == 1:
                lines[at[0] + 1:at[0] + 1] = block.split('\n')
                texts[p] = '\n'.join(lines)
    pat = (r"At core receipt \[`[0-9TZ.]+`\]\([^)]*\) \(Lean 4\.29\.1\), the closure held \d+ modules \(\d+ foundation, "
           r"\d+ core, \d+ in the instance and application ring\) and [\d,]+ theorems; the \d+ core modules held [\d,]+ of "
           r"them; [\d,]+ declarations were audited; \d+ generated `injEq` lemmas depend on `propext`; \d+ superseded "
           r"modules were kept out of the run\.")
    p8 = CH / '08-METHOD.md'
    report.append(('texts: 08 counts sentence', len(re.findall(pat, get(p8)))))
    # emulate the counts rewrite with other numbers, so the drift check sees the rewritten line
    texts[p8] = re.sub(pat, lambda m: re.sub(r'\d', '7', m.group(0)), get(p8))
    apart = RF / 'THEOREM-CONNECTIVITY-APART.json'
    report.append(('register: apart anchor', get(apart).count('  }\n },\n "instances": {')))
    return report, texts


ue4_landed = 'import Becoming.EventualWidening\n' in (PKG / 'Becoming.lean').read_text(encoding='utf-8')
for scenario in ((False,) if ue4_landed else (False, True)):
    report, texts = simulate(scenario)
    bad = [r for r in report if r[1] != 1]
    print(('after UE4' if scenario else 'current main') + f': {len(report)} anchors, each once: {not bad}', bad or '')
    if not scenario:
        current_texts = texts

# 2. drift the UE2 text edits would cause, by registry.scoped_drift's rule
records = [json.loads(p.read_text(encoding='utf-8')) for p in sorted(RECORDS.glob('*.json'))]
edited_md = {p: t for p, t in current_texts.items() if p.suffix == '.md'}
edited_other = {p for p in current_texts if p.suffix != '.md'}
bearing = {}
for r in records:
    for ref in r.get('references', []):
        p = ROOT / ref['path']
        if p in edited_other:
            bearing.setdefault(r['id'], []).append(f'{p.name} (exact bytes)')
        if p not in edited_md:
            continue
        old = p.read_text(encoding='utf-8')
        insync = registry.digest(p) == ref.get('sha256')
        a, b = old.splitlines(), edited_md[p].splitlines()
        heads = registry.sections(a)
        changes = [(heads[i1], a[i1:i2], b[j1:j2]) for op, i1, i2, j1, j2 in
                   difflib.SequenceMatcher(None, a, b, autojunk=False).get_opcodes() if op in ('replace', 'delete')]
        rel = ref['path']
        anchors = registry.cited_headings(r, rel)
        located = bool(anchors) or registry.links_record(r, edited_md[p])
        hits = sorted({h or '(before the first heading)' for h, rem, add in changes
                       if not located or h is None or registry.links_record(r, '\n'.join(rem + add))
                       or anchors & anchors_from_text(h)})
        if hits:
            bearing.setdefault(r['id'], []).append(f'{p.name} {hits}' + ('' if insync else ' [already out of sync]'))
print('records the UE2 edits would put out of date:')
for k, v in sorted(bearing.items()):
    print('  ', k, v)

# 3. the records, in memory
audits = [('cw', 'BecomingConditionalWeightsAxiomAudit.lean'), ('ty', 'BecomingTypicalityAxiomAudit.lean')]
if not all((KIT / f'tree/.build/{f}').is_file() for _, f in audits):
    raise SystemExit('records: skipped, no scratch-build audit files in tree/.build')
audit = {m: [l.split()[-1] for l in (KIT / f'tree/.build/{f}').read_text().splitlines() if l.startswith('#print axioms')]
         for m, f in audits}
names_cw, names_ty = set(audit['cw']), set(audit['ty'])
print('audited:', len(names_cw), 'ConditionalWeights,', len(names_ty), 'Typicality')


def load(path, name):
    spec = importlib.util.spec_from_file_location(name, path)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)  # top level only: main() is behind __name__ == '__main__'
    return mod


mr = load(KIT / 'make_records_ue2.py', 'make_records_ue2')
receipt_id, n, now = '20261025T170203.123456Z', 412, '2026-10-25T17:05:00+00:00'
fake = lambda path: 'f' * 64  # noqa: E731
a, b = mr.records(receipt_id, n, names_cw, fake, now)  # asserts the partition
ca, cb = set(a['references'][0]['declarations']), set(b['references'][0]['declarations'])
print('partition:', len(ca), '+', len(cb), '=', len(ca | cb), 'disjoint', not (ca & cb), 'equal to the audit', (ca | cb) == names_cw)
src = (KIT / 'tree/Becoming/ConditionalWeights.lean').read_text(encoding='utf-8')
print('every cited name declared in the kit source:',
      all(registry.declaration_in_source(src, d) for d in ca | cb))

ty = load(KIT / 'update_typicality_record_ue2.py', 'update_typicality_record_ue2')
t = json.loads((RECORDS / 'typicality-by-counting.json').read_text(encoding='utf-8'))
t2 = ty.update(copy.deepcopy(t), receipt_id, n, 'e' * 64, 'd' * 64, names_ty, 52, now)
print('typicality-by-counting updated in memory: laws', len(t['laws']), '->', len(t2['laws']),
      '; Typicality declarations', len(t2['references'][0]['declarations']))

known = {x['id']: x for x in records}
others = {}
for r in records:
    if r['id'] == 'typicality-by-counting':
        continue
    for al in [r['id']] + r.get('aliases', []):
        others[al.casefold()] = r['id']
for rec, lean_names in ((a, names_cw), (b, names_cw | names_ty), (t2, names_ty)):
    errs = registry.validate_v2_fields(rec)
    lint = style.lint(rec)
    clash = [al for al in [rec['id']] + rec['aliases'] if al.casefold() in others and others[al.casefold()] != rec['id']]
    lean_like = [al for al in rec['aliases'] if re.fullmatch(r"[A-Za-z_][\w']*(?:\.[\w'!?]+)+", al)
                 and al.startswith('Becoming.') and al not in lean_names and al != 'Becoming.total']
    edges = [e['id'] for e in rec['dependencies'] + rec['related'] if e['id'] not in known and e['id'] not in (RA, RB)]
    rel = [e['relation'] for e in rec['dependencies'] if e['relation'] not in registry.RELATIONS]
    roles = {x['role'] for x in rec['references']}
    print(f"{rec['id']}: v2 errors {errs}; lint {[(f['severity'], f['field'], f['rule']) for f in lint]}; "
          f"alias clashes {clash}; Lean-named aliases not audited {lean_like}; unknown edges {edges}; bad relations {rel}; "
          f"proof+receipt {'proof' in roles and 'receipt' in roles}; bindings {len(rec.get('proof_bindings', []))}; "
          f"family {rec.get('family')}; status {rec.get('status')}")
    print('   deps:', [(e['id'], e['relation']) for e in rec['dependencies']], 'related:', [e['id'] for e in rec['related']])
print('history notes:', a['history'][-1]['en'][:40], '|', b['history'][-1]['en'][:40], '|', t2['history'][-1]['en'][:40])
