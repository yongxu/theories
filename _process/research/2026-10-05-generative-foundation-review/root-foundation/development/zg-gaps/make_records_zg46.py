#!/usr/bin/env python3
"""Write the ZG4-ZG6 records (theorems answering the ZH map's gaps) and note the record civilization-thought-on-the-spine:
python3 -B make_records_zg46.py CORE_RECEIPT SECTION_ZG1 PREVIOUS_RECEIPT   (from the checkout root, after apply_text_zg46.py;
the sections of ZG2 and ZG3 follow SECTION_ZG1)

Every cited declaration is resolved against the receipt, the receipt must bind each module's current bytes, and together
the records cite exactly the declarations the touched modules gained ."""
import datetime
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
REVIEW = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-SIGNIFICANCE-REVIEW.md'
CHAPTER = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
MAPCH = 'theories/becoming/chapters/CIVILIZATION-THOUGHT-AND-BECOMING.md'
ZHMAP = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/zhonghua/passages.json'
RECORDS = ROOT / 'theories/becoming/results/records'
core_id, N1, previous = sys.argv[1], int(sys.argv[2]), sys.argv[3]
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
P = json.loads(Path(previous).read_text())
sys.path.insert(0, str(Path(__file__).resolve().parent))
from spec_zg46 import MODS, REMOVED, spec  # noqa: E402



def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


full, new = {}, set()
for mod in MODS:
    src = f'{PKG}/Becoming/{mod}.lean'
    m = next(m for m in core['modules'] if m['module'] == f'Becoming.{mod}')
    assert core['source_sha256'][f'Becoming.{mod}'] == sha(src), mod
    assert not any(m['axiom_dependencies'].values())
    names = [d['name'] for d in m['declarations']]
    old = {d['name'] for d in next(x for x in P['modules'] if x['module'] == f'Becoming.{mod}')['declarations']}
    assert not (old - set(names) - REMOVED), old - set(names)
    for n in names:
        full[n] = mod
    new |= {n for n in names if n not in old}


def R(names):
    out = []
    for n in names:
        assert 'Becoming.' + n in full, n
        out.append('Becoming.' + n)
    return out


BOUNDS = ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical', 'names-provisional',
          'omission-not-refutation']
S1, S2, S3 = N1, N1 + 1, N1 + 2
SPEC = spec(S1, S2, S3)
cited = set()
recs = []
for rid, sec, mods, title, stmt, laws, hyp, dns, corr, deps, entries in SPEC:
    for en, zh, _ in laws:
        assert len(en) <= 420 and len(zh) <= 190, (rid, en[:40], len(en), len(zh))
    assert len(stmt[0]) <= 300 and len(stmt[1]) <= 150, (rid, len(stmt[0]), len(stmt[1]))
    decls = [d for _, _, names in laws for d in R(names)]
    cited |= set(decls)
    srcs = [f'{PKG}/Becoming/{m}.lean' for m in mods]
    n_new = sum(1 for d in decls if d in new)
    rec = {
        'schema_version': 2, 'id': rid, 'title': {'en': title[0], 'zh': title[1]},
        'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
        'statement': {'en': stmt[0], 'zh': stmt[1]},
        'laws': [{'en': en, 'zh': zh, 'declarations': R(names)} for en, zh, names in laws],
        'hypotheses': [{'en': hyp[0], 'zh': hyp[1]}],
        'does_not_show': [{'en': en, 'zh': zh, 'kind': k} for en, zh, k in dns],
        'counterexamples': [], 'standard_boundaries': BOUNDS,
        'validation_scope': {
            'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the {n_new} declarations cited '
                  f'here that the modules gained have empty axiom reports; the checker verifies core purity. Built and reviewed '
                  f'in one session; author review in study section {sec}; not independently reviewed by a person.',
            'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：本记录所引之新增 {n_new} 项声明公理报告为空；检查器并核对核心纯净。'
                  f'在一个会话中构建并审查；作者审查见研究第 {sec} 节；未经人的独立审查。'},
        'next_delta': {'en': 'An independent review.', 'zh': '独立审查。'},
        'correspondence': {'en': corr[0], 'zh': corr[1]},
        'canonical_source': srcs[0],
        'aliases': [title[0], title[1]] + R([laws[0][2][0]]),
        'dependencies': [{'id': i, 'relation': 'formal-reuse', 'detail': {'en': en, 'zh': zh}} for i, en, zh in deps],
        'related': [{'id': 'civilization-thought-on-the-spine', 'detail': {
            'en': 'States a gap its map found (entries ' + ', '.join(entries) + ').',
            'zh': '陈述其对应所发现之缺口（条目 ' + '、'.join(entries) + '）。'}}],
        'references': [{'path': s, 'role': 'proof', 'declarations': sorted(d for d in decls if full[d] == s.split('/')[-1][:-5]),
                        'sha256': sha(s)} for s in srcs]
        + [{'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
           {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
           {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
           {'path': ZHMAP, 'role': 'integration', 'sha256': sha(ZHMAP)},
           {'path': MAPCH, 'role': 'statement', 'sha256': sha(MAPCH)},
           {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)}],
        'proof_bindings': [{'source': s, 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{s.split("/")[-1][:-5]}',
                            'success_pointer': '/status', 'success_value': 'passed'} for s in srcs],
        'history': [{'en': f'22 October 2026: added (ZG), for the gap the ZH reading raised; study section {sec}.',
                     'zh': f'2026年10月22日：新增（ZG），补中华思想脉络之读所提出的缺口；研究第 {sec} 节。'}],
    }
    assert not (RECORDS / f'{rid}.json').exists(), rid
    recs.append(rec)
missing = new - cited
assert not missing, sorted(missing)
for rec in recs:
    (RECORDS / f'{rec["id"]}.json').write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
    print('written', rec['id'])
d = json.loads((RECORDS / 'civilization-thought-on-the-spine.json').read_text())
d['related'] += [{'id': rec['id'], 'detail': {'en': 'States gaps its map found (ZG).', 'zh': '陈述其对应所发现之缺口（ZG）。'}} for rec in recs]
d['history'].append({
    'en': f'22 October 2026, ZG4-ZG6: 21 entries\' gaps are stated (twelve records; study sections {S1}-{S3}), their readings '
          'revised and gap notes pointing to the laws; 13 gap notes that ask for no law are marked as scope remarks, their text '
          'kept. The map\'s kinds and counts are unchanged; three entries whose kind rested on a gap now proved say so.',
    'zh': f'2026年10月22日，ZG4-ZG6：21 个条目之缺口已陈述（十二项记录；研究第 {S1}-{S3} 节），其读法修订，gap 注指向新律；'
          '13 条不求律之 gap 注标为范围之注，原文保留。对应之类别与计数不变；三个以缺定类之条目注明其缺已补。'})
(RECORDS / 'civilization-thought-on-the-spine.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('noted civilization-thought-on-the-spine; cited', len(cited), 'new', len(new))
