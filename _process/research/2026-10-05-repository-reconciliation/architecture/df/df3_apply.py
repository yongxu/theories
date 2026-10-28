#!/usr/bin/env python3
"""DF3: apply the skeptical reviews of the migrated records, and the chapter edits.

Every review edit is taken (reports/df3-migrate-review.json): errors, overclaims, imprecisions,
dropped and missing items, and the style points, which fix readings' labels, a quotation's
source, a retired label, round narration, duplicate bindings and witness-free counterexamples.
Records are written as the repository's tools write them (indent 2, final newline).
Run from the worktree root: python3 -B <kit>/df3_apply.py
"""
import json, re, sys
from pathlib import Path

KIT = Path('_process/research/2026-10-05-repository-reconciliation/architecture/df')
RECORDS = Path('theories/becoming/results/records')
res = json.loads((KIT / 'reports/df3-migrate-review.json').read_text())
IDS = [r['id'] for u in res for r in u['migrated']['records']]
recs = {i: json.loads((RECORDS / f'{i}.json').read_text()) for i in IDS}
changed = {i: [] for i in IDS}
failures = []


def get(obj, path):
    for part in re.findall(r'[^.\[\]]+|\[-?\d+\]', path):
        obj = obj[int(part[1:-1])] if part.startswith('[') else obj[part]
    return obj


def setp(obj, path, value):
    parts = re.findall(r'[^.\[\]]+|\[-?\d+\]', path)
    for part in parts[:-1]:
        obj = obj[int(part[1:-1])] if part.startswith('[') else obj[part]
    last = parts[-1]
    if last.startswith('['):
        obj[int(last[1:-1])] = value
    else:
        obj[last] = value


def note(i, field):
    top = field.split('.')[0]
    if not top.startswith('history'):
        changed[i].append(top)


def replace_in_file(path, old, new, tag):
    p = Path(path)
    s = p.read_text()
    if s.count(old) != 1:
        failures.append(f'{tag}: {path}: old occurs {s.count(old)} times: {old[:80]}')
        return
    p.write_text(s.replace(old, new))


def add_decls(lst, names):
    for n in names:
        if n not in lst:
            lst.append(n)


# Edits the generic rule cannot place: fragments of JSON lists, optional moves, duplicate bindings.
def manual(i, e):
    r, f = recs[i], e['field']
    if (i, f) == ('joint-plan-composition', 'references[0].declarations'):
        add_decls(r['references'][0]['declarations'], ['JointContinuation.joint_first_step'])
    elif (i, f) == ('control-coherence-loss', 'laws[2].declarations'):
        add_decls(r['laws'][2]['declarations'], ['Becoming.Dephasing.dephase_preserves_diagonal', 'Becoming.Dephasing.dephase_preserves_mass'])
    elif (i, f) == ('control-coherence-loss', 'references[1].declarations'):
        add_decls(r['references'][1]['declarations'], ['Becoming.Dephasing.dephase_preserves_diagonal', 'Becoming.Dephasing.dephase_preserves_mass'])
    elif f == 'proof_bindings':
        seen, out = set(), []
        for b in r['proof_bindings']:
            k = json.dumps(b, sort_keys=True)
            if k not in seen:
                seen.add(k)
                out.append(b)
        assert len(out) == len(r['proof_bindings']) - 1, i
        r['proof_bindings'] = out
    elif f == 'counterexamples' and i == 'joint-code-plan-lifting':
        assert len(r['counterexamples']) == 1
        r['counterexamples'] = []
        r.setdefault('does_not_show', []).append({'en': 'Existence of a witnessed plan does not make arbitrary designated parts composable.',
                                                  'zh': '不能把某个计划有见证升级为任意指定部分均能接合。', 'kind': 'non-implication'})
        mapping_note(i, 'The review moved the old counterexample, which no declaration witnesses, to a does-not-show item (non-implication): X0 and L0 now go to that item.')
    elif f == 'counterexamples' and i == 'finite-trace-transport':
        assert len(r['counterexamples']) == 1
        r['counterexamples'] = []
        r['does_not_show'] = [{'en': 'Step preservation alone does not give the converse: lifting needs a condition at every configuration of each starting fiber.',
                               'zh': '保步不独自给出逆：提升需要每个起始纤维中每个构形处的条件。', 'kind': 'converse', 'witness': 'Generative.projection_exact_iff'}]
        mapping_note(i, 'The review moved the old counterexample, which no declaration of GenerativeCore.lean witnesses, to a does-not-show item (converse, witness `Generative.projection_exact_iff`): X0, L0 and L1 now go to that item.')
    else:
        return False
    note(i, f)
    return True


def mapping_note(i, text):
    p = KIT / 'df3-mapping' / f'{i}.md'
    p.write_text(p.read_text().rstrip('\n') + '\n\n' + text + '\n')


for u in res:
    for e in u['review']['edits']:
        i, f, old, new = e['id'], e['field'], e['old'], e['new']
        tag = f"{u['unit']}:{i}:{f}"
        if i.endswith('.md'):  # a mapping file or a chapter
            if 'chapters/' in i:
                continue  # chapter proposals are taken below, with the migrators'
            replace_in_file(i, old, new, tag)
            continue
        if i not in recs:
            failures.append(f'{tag}: unknown record')
            continue
        if manual(i, e):
            continue
        cur = get(recs[i], f)
        if isinstance(cur, list):
            if json.loads(old) != cur:
                failures.append(f'{tag}: list differs')
                continue
            setp(recs[i], f, json.loads(new))
        elif old == '':
            setp(recs[i], f, new)
        elif isinstance(cur, str) and cur.count(old) == 1:
            setp(recs[i], f, cur.replace(old, new))
        elif isinstance(cur, str) and cur == old:
            setp(recs[i], f, new)
        else:
            failures.append(f'{tag}: old occurs {cur.count(old) if isinstance(cur, str) else "?"} times')
            continue
        note(i, f)

# The Chinese of two style points the reviewer gave in English only.
for i, f, old, new in [('metaethical-core-characterization', 'correspondence.zh', 'living 读作生生；', 'living 读作生生（AI 的读法）；'),
                       ('classification-robust-generative-comparison', 'dependencies[0].interface.conditions.zh', '生生之意义、J 与实际对应', '生生之意义、实践承诺与实际对应')]:
    cur = get(recs[i], f)
    if cur.count(old) == 1:
        setp(recs[i], f, cur.replace(old, new))
    else:
        failures.append(f'extra:{i}:{f}: old occurs {cur.count(old)} times')

# Chapter edits: the migrators' proposals, with the reviewers' corrections of three, and one of the reviewers' own.
chapter = []
for u in res:
    for x in u['migrated']['records']:
        for c in x['chapter_edits']:
            chapter.append([x['id'], c['file'], c['old'], c['new']])
REVISED = {
    'becoming-context-coherence': ('otherwise pooling invents histories, and retaining the context realizes the union.',
                                   'where it is not, pooling is not exact, and in a witness it runs a history no single process runs (`CrossingContexts.pooled_crosses`); retaining the context realizes the union.'),
}
for c in chapter:
    if c[0] in REVISED:
        c[2], c[3] = REVISED[c[0]]
    if c[0] == 'market-partial-correction-boundary':
        a = 'for `β ≤ 5/12`, initial stock at least `K_N` carries the guarded run through the landing into the original protection'
        b = 'for `β ≤ 5/12` each such state has a landing time `N`, and initial stock at least `K_N` carries its guarded run through the landing into the original protection'
        assert c[3].count(a) == 1
        c[3] = c[3].replace(a, b)
    if c[0] == 'renewing-consuming-formation':
        assert c[3].count('loses capacity at its first step,') == 1
        c[3] = c[3].replace('loses capacity at its first step,', 'loses capacity from its first step on,')
chapter.append(['market-supported-finite-transition', 'theories/becoming/chapters/05-COLLECTIVES.md',
                'so initial support at least `K_N` carries every positive state through a finite correction into the original protection',
                'so each positive state has a horizon `N` at which initial support at least `K_N` carries it through a finite correction into the original protection (`RegimeTransition.supported_finite_transition`; no single `N` serves every positive share, `RegimeTransition.no_uniform_pulse_duration`)'])
for ident, file, old, new in chapter:
    replace_in_file(file, old, new, f'chapter:{ident}')

# The history note of each record says what the review changed.
EN = {'statement': 'the statement', 'laws': 'laws', 'does_not_show': 'does-not-show items', 'validation_scope': 'the evidence paragraph',
      'correspondence': 'the correspondence', 'next_delta': 'the next step', 'hypotheses': 'hypotheses', 'counterexamples': 'the counterexample (moved to a does-not-show item)',
      'references': 'the references (declarations added)', 'proof_bindings': 'a duplicate proof binding (dropped)', 'related': 'a related entry', 'dependencies': 'a dependency interface'}
ZH = {'statement': '陈述', 'laws': '规律', 'does_not_show': '“未表明”各项', 'validation_scope': '证据段', 'correspondence': '对应', 'next_delta': '下一步',
      'hypotheses': '前提', 'counterexamples': '反例（移入“未表明”）', 'references': '引用（增补声明）', 'proof_bindings': '重复的证明绑定（删去）', 'related': '相关条目', 'dependencies': '依赖接口'}
for i, r in recs.items():
    tops = []
    for f in changed[i]:
        k = re.sub(r'\[.*', '', f)
        if k not in tops:
            tops.append(k)
    if i in ('metaethical-core-characterization', 'classification-robust-generative-comparison'):
        for k in ('correspondence', 'dependencies'):
            if k in [re.sub(r'\[.*', '', x) for x in changed[i]] and k not in tops:
                tops.append(k)
    h = r['history'][-1]
    assert h['en'].startswith('28 October 2026: migrated to schema 2 (DF3'), i
    if tops:
        h['en'] = h['en'].rstrip() + ' The migration\'s skeptical review was taken in ' + ', '.join(EN[k] for k in tops) + ', each read against the Lean it cites.'
        h['zh'] = h['zh'].rstrip() + '迁移的审查意见已采纳，涉及' + '、'.join(ZH[k] for k in tops) + '，各条对照所引 Lean 核读。'

for i, r in recs.items():
    (RECORDS / f'{i}.json').write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n')
print(json.dumps({'records': len(recs), 'changed': {i: sorted(set(re.sub(r'\[.*', '', x) for x in v)) for i, v in changed.items() if v},
                  'chapter_edits': len(chapter), 'failures': failures}, ensure_ascii=False, indent=1))
sys.exit(1 if failures else 0)
