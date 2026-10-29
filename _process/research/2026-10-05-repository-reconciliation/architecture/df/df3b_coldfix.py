#!/usr/bin/env python3
"""DF3 batch B: take the cold read of the applied migration (reports/df3b-cold-read.json; three readers, 44 findings).

Taken: every overclaim, imprecision and home-section disagreement, and the style points that remove Ren's delegation,
agreement or answer given as a reading's standing or a reason for an order of the work, align the Chinese with the
English, and correct mapping rows. Not taken: b20 (a lint warning on an item that says more than the shared
boundary sentence, kept) and b32 (the section number, which the landing fills). Where a finding gives the Chinese or
a second edit only in its reason, the edit is written out below. Run from the worktree root.
"""
import hashlib, json, re, sys
from pathlib import Path

KIT = Path('_process/research/2026-10-05-repository-reconciliation/architecture/df')
RECORDS = Path('theories/becoming/results/records')
LEAN = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
PART = re.compile(r'[^.\[\]]+|\[-?\d+\]')
cold = json.loads((KIT / 'reports/df3b-cold-read.json').read_text())
findings = [f for x in cold if x['reader'] != 'chain' for f in x['findings']]
assert len(findings) == 44
SKIP = {20, 32}
recs, touched, failures = {}, {}, []


def rec(i):
    if i not in recs:
        recs[i] = json.loads((RECORDS / f'{i}.json').read_text())
        touched[i] = []
    return recs[i]


def get(obj, path):
    for part in PART.findall(path):
        obj = obj[int(part[1:-1])] if part.startswith('[') else obj[part]
    return obj


def setp(obj, path, value):
    parts = PART.findall(path)
    for part in parts[:-1]:
        obj = obj[int(part[1:-1])] if part.startswith('[') else obj[part]
    last = parts[-1]
    obj[int(last[1:-1]) if last.startswith('[') else last] = value


def sub(i, path, old, new, tag=''):
    r = rec(i)
    cur = get(r, path)
    if cur.count(old) != 1:
        failures.append(f'{tag} {i}:{path}: old occurs {cur.count(old)} times: {old[:60]}')
        return
    setp(r, path, cur.replace(old, new))
    top = re.sub(r'\[.*', '', path.split('.')[0])
    if top != 'history':
        touched[i].append(top)


def fsub(path, old, new, tag=''):
    p = Path(path)
    s = p.read_text()
    if s.count(old) != 1:
        failures.append(f'{tag} {path}: old occurs {s.count(old)} times: {old[:60]}')
        return
    p.write_text(s.replace(old, new))


MAP = lambda i: str(KIT / 'df3-mapping' / f'{i}.md')
MANUAL = {17, 18, 22, 23, 33}  # handled below with what their reasons add
for k, f in enumerate(findings):
    if k in SKIP or k in MANUAL:
        continue
    i, field, old, new = f['id'], f['field'], f['old'], f['new']
    tag = f'[{k}]'
    chap = re.search(r'theories/becoming/chapters/[0-9A-Z-]+\.md', i + ' ' + field)
    if i.endswith('.md') and 'df3-mapping' in i:
        fsub(i, old, new, tag)
    elif chap:
        fsub(chap.group(0), old, new, tag)
    else:
        path = field.split(' ')[0]
        if path.endswith('(and'):
            path = path[:-4]
        sub(i, path, old, new, tag)

# [17] the Chinese of the rewritten correspondence, the two declarations it names, and its mapping row.
sub('joining-open-map-factor', 'correspondence.zh', findings[17]['old'], findings[17]['new'], '[17]')
r = rec('joining-open-map-factor')
ref = [x for x in r['references'] if x['path'].endswith('/Becoming/Joining.lean')]
assert len(ref) == 1
for d in ('Becoming.Joining.span_first_open', 'Becoming.Joining.span_second_open'):
    if d not in ref[0]['declarations']:
        ref[0]['declarations'].append(d)
touched['joining-open-map-factor'].append('references')
fsub(MAP('joining-open-map-factor'), 'correspondence (unchanged; "the preceding result" is incidence-common-refinement, linked as related)',
     'correspondence: "the preceding result derives it for the canonical projections" said as what the core proves, the projections of the common refinement satisfying it with no premise (`Joining.span_first_open`, `Joining.span_second_open`, added to Joining.lean\'s references); incidence-common-refinement stays linked as related', '[17]')
# [18] the mapping row and the history note: the counterexample was replaced by a witnessed case.
fsub(findings[18]['id'], findings[18]['old'], findings[18]['new'], '[18]')
sub('finite-granularity-question-recovery', 'history[-1].en', 'the counterexample, which only repeated the limitations and which no declaration witnesses, removed, its sentences carried by those items;',
    'the counterexample, which only repeated the limitations, replaced by the case ExplanatoryGranularityBoundary.lean witnesses (two branches alike on completed-block and prefix tests, one able to lose its continuation midway), its sentences carried by those items;', '[18]')
# [19] the Chinese of the cut clause.
sub('laws-at-coarser-steps', 'correspondence.zh', '；先完成较粗的步、再做连续时间，依 Ren 2026-10-11 对“只检验较粗的步还是也检验连续时间”的回答“let\'s finish one first, then another”（来源，不是依据）。', '。', '[19]')
# [22] the counterexample's witnesses in references.
r = rec('listing-once-is-decided-identity')
diss = f'{LEAN}/Becoming/Dissipation.lean'
receipt = f'{LEAN}/becoming-checks/20261028T085101.429997Z/verification.json'
if not any(x['path'] == diss for x in r['references']):
    r['references'].insert(next(k for k, x in enumerate(r['references']) if x['role'] != 'proof'),
                           {'path': diss, 'role': 'proof', 'declarations': ['Becoming.Lone.repeated_family'],
                            'sha256': hashlib.sha256(Path(diss).read_bytes()).hexdigest()})
    r['proof_bindings'].append({'source': diss, 'receipt': receipt, 'sha256_pointer': '/source_sha256/Becoming.Dissipation', 'success_pointer': '/status', 'success_value': 'passed'})
    if not any(x['path'] == receipt for x in r['references']):
        r['references'].append({'path': receipt, 'role': 'receipt', 'sha256': hashlib.sha256(Path(receipt).read_bytes()).hexdigest()})
pop = [x for x in r['references'] if x['path'].endswith('/Becoming/Population.lean')]
assert len(pop) == 1
for d in ('Becoming.Repeated.rep', 'Becoming.Repeated.web'):
    if d not in pop[0]['declarations']:
        pop[0]['declarations'].append(d)
touched['listing-once-is-decided-identity'] += ['references', 'proof_bindings']
# [23] the English cut, its section marker, and the Chinese.
sub('process-and-frame-as-readings', 'correspondence.en', findings[23]['old'], findings[23]['new'], '[23]')
cur = rec('process-and-frame-as-readings')['correspondence']['en']
if ' See §91 of the integration note.' in cur:
    sub('process-and-frame-as-readings', 'correspondence.en', ' See §91 of the integration note.', '', '[23]')
sub('process-and-frame-as-readings', 'correspondence.zh',
    '在同一对话的另一分支上，对律与历史是同一展开的两种读法、律从展开读出而不是置于其上这一读法，Ren 写道：“yes, i do agree with your reading, there are no two realities”。DeadEnd、Splice、保留历史、Fork 与 Circulation 的结果是那个分支上检查过的定理在本模块定义上的重述。读法（AI 的，依 Ren 的交托采用）：',
    'DeadEnd、Splice、保留历史、Fork 与 Circulation 的结果是该对话另一分支上检查过的定理在本模块定义上的重述。读法（AI 的读法）：', '[23]')
if '见整合文档 §91。' in rec('process-and-frame-as-readings')['correspondence']['zh']:
    sub('process-and-frame-as-readings', 'correspondence.zh', '见整合文档 §91。', '', '[23]')
# [33] the home section in 07 (the finding's id is the record; the edit is the chapter's).
fsub('theories/becoming/chapters/07-SIGNIFICANCE.md', findings[33]['old'], findings[33]['new'], '[33]')
# The Chinese and the section markers of [25]-[28].
sub('transmission-independent-where-it-binds', 'correspondence.zh', '读法（AI 的，依 Ren 的交托采用）', '读法（AI 的读法）', '[25]')
sub('transmission-independent-where-it-binds', 'correspondence.zh', '依 Ren 的交托，它不采用为形成的规律（D31）。见整合文档 §105。', '它作为推出的前提进入，不采用为形成的规律。', '[25]')
for marker in (' See the integration document §105.',):
    if marker in rec('transmission-independent-where-it-binds')['correspondence']['en']:
        sub('transmission-independent-where-it-binds', 'correspondence.en', marker, '', '[25]')
sub('one-step-missing-laws', 'correspondence.zh', '读法（AI 的，依 Ren 的交托采用）：有所取就有取用者，以及所取不超过所立加所给，是一步之律的一部分，此前只隐含在定义中。见整合文档 §103。',
    '读法（AI 的读法）：有所取就有取用者，以及平衡时所取不超过所立加所给，是一步之律的一部分，此前只隐含在定义中。', '[26]')
sub('separation-loses-the-relation', 'correspondence.zh', '读法（AI 的，依 Ren 的交托采用；Ren 同意了包含它们的回答）', '读法（AI 的读法）', '[27]')
for i, en, zh in (('separation-loses-the-relation', ' See §94 of the integration note.', '见整合文档 §94。'),):
    if en in rec(i)['correspondence']['en']:
        sub(i, 'correspondence.en', en, '', '[27]')
    if zh in rec(i)['correspondence']['zh']:
        sub(i, 'correspondence.zh', zh, '', '[27]')
sub('histories-fix-law-up-to-dead-ends', 'correspondence.zh', '律从展开读出，Ren 于 2026-10-12 同意这一读法（“there are no two realities”）；',
    '律从展开读出（其来源 Ren 2026-10-12 的“there are no two realities”见参考）；', '[28]')
# [31] the same stale phrase in two more mapping files.
for i in ('joining-open-map-factor', 'selection-under-registration-revision'):
    fsub(MAP(i), "the home section's sentence needs the same narrowing (proposed below).", "the home section's sentence is narrowed the same way (applied in 03-KNOWING).", '[31]')
# [37] the history note of versioned-request-completion.
sub('versioned-request-completion', 'history[-1].en', 'the statement kept;', 'the statement kept but for “exactly” before “that work plus one tick”, dropped as the home section drops it;', '[37]')
sub('versioned-request-completion', 'history[-1].zh', '陈述保留；', '陈述保留，只去掉“恰”，与主章一致；', '[37]')
# [39] the mapping row H0.
fsub(MAP('conveyance-crosses-the-boundary'), '| hypotheses[0] (unchanged) |', '| hypotheses[0], ‘decided by the AI’ restated as ‘an AI reading, D12’ |', '[39]')
# [43] the repeated clause, cut in English as in Chinese.
sub('rest-with-refinement-counted', 'correspondence.en', 'The content is the reading, not new dynamics; inside an enclosure the refinement is a source.', 'The content is the reading, not new dynamics.', '[43]')

EN = {'statement': 'the statement', 'laws': 'laws', 'does_not_show': 'does-not-show items', 'validation_scope': 'the evidence paragraph',
      'correspondence': 'the correspondence', 'next_delta': 'the next step', 'hypotheses': 'hypotheses', 'counterexamples': 'the counterexamples',
      'references': 'the references', 'proof_bindings': 'the proof bindings'}
ZH = {'statement': '陈述', 'laws': '规律', 'does_not_show': '“未表明”各项', 'validation_scope': '证据段', 'correspondence': '对应', 'next_delta': '下一步',
      'hypotheses': '前提', 'counterexamples': '反例', 'references': '引用', 'proof_bindings': '证明绑定'}
for i, r in recs.items():
    tops = list(dict.fromkeys(touched[i]))
    h = r['history'][-1]
    assert h['en'].startswith('28 October 2026: migrated to schema 2 (DF3 batch B'), i
    if tops:
        h['en'] = h['en'].rstrip() + ' A cold read of the applied record was taken in ' + ', '.join(EN[k] for k in tops) + '.'
        h['zh'] = h['zh'].rstrip() + '对已应用记录的通读意见已采纳，涉及' + '、'.join(ZH[k] for k in tops) + '。'
    (RECORDS / f'{i}.json').write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n')
print(json.dumps({'records': sorted(recs), 'failures': failures}, ensure_ascii=False, indent=1))
sys.exit(1 if failures else 0)
# (Run after the above, by hand on 29 October 2026: [18]'s history note in Chinese, as its reason asks.)
#   finite-granularity-question-recovery history[-1].zh: '反例只重复限制、无声明见证，已删去，其句由这些条目承载；' ->
#   '反例只重复限制，已换为 ExplanatoryGranularityBoundary.lean 所见证的情形（两个分支在完成块与前缀检验上相同，其一可在中途失去其接续），其句由这些条目承载；'
