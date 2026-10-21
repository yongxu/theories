#!/usr/bin/env python3
"""EC1's records. Declarations that moved keep their full names: ClosedUnder, WithinClosure and their laws from
Becoming.Feedback to Becoming.Frame, Flow.FedFrom from Becoming.Feedback to Becoming.Interdependence. Each record
citing them under Feedback.lean cites them under the module that now holds them, with a proof binding to the core
receipt. levels-of-closure loses the two theorems beside the definition (Flow.withinFeeding_iff,
Flow.fedClosed_iff: the feeding closure is now the closure under being fed by definition) and gains reach as the
closure of the steps; feeding-closure gains Flow.FedFrom and Flow.FedFromAcross. Each changed record gets a history
note. Run before repoint.py --receipt (which rebinds the remaining bindings of the changed modules).
python3 -B records.py CORE_RECEIPT STUDY_SECTION   (from the checkout root, after land_text.py)"""
import hashlib, json, re, sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
RECORDS = ROOT / 'theories/becoming/results/records'
core_id, N = sys.argv[1], int(sys.argv[2])
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
assert re.search(rf'^## {N}\. One closure: the closure of a relation at the frame \(EC1\)$', (ROOT / STUDY).read_text(), re.M)
elab = {m['module']: {d['name'] for d in m['declarations']} for m in core['modules']}


def src(mod):
    return f'{PKG}/Becoming/{mod}.lean'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


TO_FRAME = ['Becoming.ClosedUnder', 'Becoming.WithinClosure', 'Becoming.WithinClosure.refl',
            'Becoming.WithinClosure.trans', 'Becoming.WithinClosure.of_rel', 'Becoming.WithinClosure.mono',
            'Becoming.WithinClosure.symm', 'Becoming.WithinClosure.not_rel', 'Becoming.closedUnder_withinClosure',
            'Becoming.closure_iff_certified', 'Becoming.not_within_of_closed']
TO_INTER = ['Becoming.Flow.FedFrom']
GONE = ['Becoming.Flow.withinFeeding_iff', 'Becoming.Flow.fedClosed_iff']
for n in TO_FRAME:
    assert n in elab['Becoming.Frame'], n
assert TO_INTER[0] in elab['Becoming.Interdependence']
for n in GONE:
    assert all(n not in v for v in elab.values()), n
SECTION = f'study section {N}'


def ref_for(rec, mod):
    for r in rec['references']:
        if r['path'] == src(mod):
            return r
    r = {'path': src(mod), 'role': 'proof', 'sha256': sha(src(mod)), 'declarations': []}
    rec['references'].insert(0, r)
    if not any(b['source'] == src(mod) for b in rec['proof_bindings']):
        rec['proof_bindings'].append({'source': src(mod), 'receipt': RECEIPT,
                                      'sha256_pointer': f'/source_sha256/Becoming.{mod}',
                                      'success_pointer': '/status', 'success_value': 'passed'})
    if not any(x['path'] == RECEIPT for x in rec['references']):
        rec['references'].append({'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT), 'declarations': []})
    return r


def add(rec, mod, names):
    r = ref_for(rec, mod)
    for n in names:
        assert n in elab[f'Becoming.{mod}'], n
        if n not in r['declarations']:
            r['declarations'].append(n)


FROM_SELECTION = ['Becoming.WithinClosureOf', 'Becoming.WithinClosureOf.of_member',
                  'Becoming.closedUnder_withinClosureOf', 'Becoming.withinClosureOf_iff',
                  'Becoming.withinClosureOf_single']
for n in FROM_SELECTION:
    assert n in elab['Becoming.Frame'], n
changed = {}
for f in sorted(RECORDS.glob('*.json')):
    rec = json.loads(f.read_text())
    moved = []
    for r in list(rec['references']):
        if r['path'] not in (src('Feedback'), src('Selection')) or not r.get('declarations'):
            continue
        pairs = ((TO_FRAME, 'Frame'), (TO_INTER, 'Interdependence')) if r['path'] == src('Feedback') \
            else ((FROM_SELECTION, 'Frame'),)
        for names, mod in pairs:
            hit = [n for n in r['declarations'] if n in names]
            if hit:
                r['declarations'] = [n for n in r['declarations'] if n not in hit]
                add(rec, mod, hit)
                moved.append((mod, hit))
    if moved:
        changed[rec['id']] = (f, rec, moved)

# levels-of-closure: the theorems beside the definition go; reach as the closure of the steps comes in.
f = RECORDS / 'levels-of-closure.json'
f_, rec, moved = changed.get('levels-of-closure', (f, json.loads(f.read_text()), []))
for law in rec['laws']:
    law['declarations'] = [n for n in law['declarations'] if n not in GONE]
for r in rec['references']:
    if r.get('declarations'):
        r['declarations'] = [n for n in r['declarations'] if n not in GONE]
rec['aliases'] = [a for a in rec['aliases'] if a not in GONE]
NEW_FRAME = ['Becoming.Steps', 'Becoming.withinClosure_of_trace', 'Becoming.reach_iff_withinClosure',
             'Becoming.invariant_iff_closedUnder']
law1 = next(l for l in rec['laws'] if 'Becoming.withinClosure_iff_closure' in l['declarations'])
law1['declarations'] += NEW_FRAME
add(rec, 'Frame', NEW_FRAME)
rec['aliases'] += [n for n in NEW_FRAME if n not in rec['aliases']]
for dep in rec['dependencies']:
    i = dep.get('interface', {}).get('input')
    if i and 'withinFeeding_iff' in i.get('en', ''):
        i['en'] = 'Flow.WithinFeeding, the closure under being fed by definition (Flow.FedFrom), and Clearing.levels.'
        i['zh'] = 'Flow.WithinFeeding（按定义即对被供给的闭包，Flow.FedFrom）与 Clearing.levels。'
rec['history'].append({
    'en': f'21 October 2026, EC1 ({SECTION}): the closure of a relation and its laws (ClosedUnder, WithinClosure, '
          'closedUnder_withinClosure, closure_iff_certified, not_within_of_closed) moved unchanged, with their full '
          'names, from Becoming.Feedback to Becoming.Frame, and Flow.FedFrom to Becoming.Interdependence. The feeding '
          'closure is now the closure under being fed by definition, so the two theorems beside the definition, '
          'Flow.withinFeeding_iff and Flow.fedClosed_iff, are gone from the record. Added: a process\'s reach is the '
          'closure of its steps, and an invariant is a region closed under them (reach_iff_withinClosure, '
          'invariant_iff_closedUnder), from which the seed–edge closure is derived. The claim is unchanged.',
    'zh': f'2026年10月21日，EC1（研究第 {N} 节）：关系的闭包及其律（ClosedUnder、WithinClosure、closedUnder_withinClosure、'
          'closure_iff_certified、not_within_of_closed）以完整名称原样由 Becoming.Feedback 移至 Becoming.Frame，'
          'Flow.FedFrom 移至 Becoming.Interdependence。供给闭包按定义即对被供给的闭包，故定义旁的两条定理 '
          'Flow.withinFeeding_iff 与 Flow.fedClosed_iff 从本记录删去。新增：过程的所及即其步的闭包，不变量即对其步封闭的'
          '区域（reach_iff_withinClosure、invariant_iff_closedUnder），种子–边闭包由此导出。论断不变。'})
changed['levels-of-closure'] = (f, rec, None)

# feeding-closure: FedFrom and FedFromAcross, the relations whose closures the two closures are.
f = RECORDS / 'feeding-closure.json'
rec = json.loads(f.read_text()) if 'feeding-closure' not in changed else changed['feeding-closure'][1]
l0 = next(l for l in rec['laws'] if 'Becoming.Flow.WithinFeeding' in l['declarations'] and 'Becoming.Flow.FedBy' in l['declarations'])
l0['declarations'].append('Becoming.Flow.FedFrom')
add(rec, 'Interdependence', ['Becoming.Flow.FedFrom'])
l9 = next(l for l in rec['laws'] if 'Becoming.Flow.WithinFeedingAcross' in l['declarations'])
l9['declarations'].insert(0, 'Becoming.Flow.FedFromAcross')
add(rec, 'Feeding', ['Becoming.Flow.FedFromAcross'])
rec['aliases'] += [n for n in ('Becoming.Flow.FedFrom', 'Becoming.Flow.FedFromAcross') if n not in rec['aliases']]
rec['history'].append({
    'en': f'21 October 2026, EC1 ({SECTION}): the feeding closure and the closure across steps are now the frame\'s '
          'closure of a relation by definition (Flow.WithinFeeding is WithinClosure under Flow.FedFrom, '
          'Flow.WithinFeedingAcross under Flow.FedFromAcross), so their reflexivity, transitivity, closedness and '
          'what lies beyond them are proved through that closure\'s laws (WithinClosure.not_rel for '
          'Flow.beyond_gives_nothing and Flow.beyond_gives_nothing_across). Flow.FedFrom moved unchanged from '
          'Becoming.Feedback; Flow.FedFromAcross is new. The claim is unchanged.',
    'zh': f'2026年10月21日，EC1（研究第 {N} 节）：供给闭包与跨步闭包现按定义即框架上关系的闭包（Flow.WithinFeeding 是 '
          'Flow.FedFrom 下的 WithinClosure，Flow.WithinFeedingAcross 是 Flow.FedFromAcross 下的），故其自反、传递、封闭及'
          '其外者经该闭包之律证明（Flow.beyond_gives_nothing 与 Flow.beyond_gives_nothing_across 经 '
          'WithinClosure.not_rel）。Flow.FedFrom 原样由 Becoming.Feedback 移来；Flow.FedFromAcross 为新增。论断不变。'})
changed['feeding-closure'] = (f, rec, None)

for rid, (f, rec, moved) in changed.items():
    if moved:
        names = '; '.join(f'{", ".join(n.replace("Becoming.", "") for n in hit)} to Becoming.{mod}' for mod, hit in moved)
        rec['history'].append({
            'en': f'21 October 2026, EC1 ({SECTION}): declarations moved with their full names: {names}. '
                  'The cited Lean source and its proof binding follow them; the claim is unchanged.',
            'zh': f'2026年10月21日，EC1（研究第 {N} 节）：声明以完整名称移动：{names}。所引 Lean 源及其证明绑定随之；论断不变。'})
    f.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
    print('record', rid)
