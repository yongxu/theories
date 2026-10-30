#!/usr/bin/env python3
"""RR's landing (make_records_rf7.py's pattern): the record when-no-route-stands-above-a-revision
(Becoming.RevisionRoutes, home 07 §7) from the reviewed draft (record-draft.json), each declaration of its module
cited once; and RF7's record when-complying-when-read-is-best amended as its owner gave it (law 1 names the order,
a law on complying at both after the maximal plans, a related entry, a history entry), its new declarations cited
once and its references and proof binding moved to RR's receipt. Asserts the receipt's hashes and empty axiom
reports for both modules, and the style caps and lint (tools/research/style.py) on every field written.
usage (from the checkout root, after the texts are in place): python3 -B make_records_rr.py RECEIPT N
       python3 -B make_records_rr.py --caps  (caps, lint and declaration cover against the kit's scratch audits;
                                               writes nothing)"""
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT))
from tools.research import style  # noqa: E402

CAPS_ONLY = sys.argv[1] == '--caps'
RECEIPT_ID, N = ('20261030T000000.000000Z', 465) if CAPS_ONLY else (sys.argv[1], int(sys.argv[2]))
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RFD = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RFD + 'BECOMING-RENEWAL-READING.md'
KITD = RFD + 'development/rr-revision-routes/'
NOTE, REVIEW = KITD + 'NOTE.md', KITD + 'REVIEW.md'
CH3, CH7 = 'theories/becoming/chapters/03-KNOWING.md', 'theories/becoming/chapters/07-SIGNIFICANCE.md'
LEAN = {m: f'{PKG}/Becoming/{m}.lean' for m in ('RevisionRoutes', 'ReadStages')}
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
TODAY = datetime.date.today()
DATE_EN, DATE_ZH = f'{TODAY.day} {TODAY:%B} {TODAY.year}', f'{TODAY.year}年{TODAY.month}月{TODAY.day}日'
RID, RF7 = 'when-no-route-stands-above-a-revision', 'when-complying-when-read-is-best'
NEW_RS = ['Becoming.ReadStages.Prospects.order', 'Becoming.ReadStages.Prospects.toRoutes',
          'Becoming.ReadStages.asRoute', 'Becoming.ReadStages.gain_asRoute', 'Becoming.ReadStages.loss_asRoute',
          'Becoming.ReadStages.above_iff_routes', 'Becoming.ReadStages.complyAtBoth_not_above_ownAtBoth',
          'Becoming.ReadStages.complyAtBoth_maximal_iff']


def sha(path):
    if CAPS_ONLY and not (ROOT / path).exists():
        return '0' * 64
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def capped(field, pair, item=False):
    caps = style.ITEM_CAPS_V2 if item else style.CAPS_V2
    en, zh = caps[field][:2]
    assert len(pair['en']) <= en and len(pair['zh']) <= zh, (field, len(pair['en']), en, len(pair['zh']), zh,
                                                              pair['en'][:60])
    return pair


def lint_errors(rec):
    found = style.lint(rec)
    for f in found:
        print('lint:', rec['id'], f['severity'], f['field'], f['rule'], f['detail'])
    return [f for f in found if f['severity'] == 'error']


names = {}
if CAPS_ONLY:
    for m in ('RevisionRoutes', 'ReadStages'):
        audit = (HERE / f'tree/.build/Becoming{m}AxiomAudit.lean').read_text(encoding='utf-8')
        names[m] = set(re.findall(r'^#print axioms (\S+)$', audit, re.M))
else:
    core = json.loads((ROOT / RECEIPT).read_text())
    assert core['status'] == 'passed'
    for m in ('RevisionRoutes', 'ReadStages'):
        assert core['source_sha256'][f'Becoming.{m}'] == sha(LEAN[m]), m
        mod = next(x for x in core['modules'] if x['module'] == f'Becoming.{m}')
        assert not any(mod['axiom_dependencies'].values()), m
        names[m] = {d['name'] for d in mod['declarations']}

# --- the new record, from the reviewed draft ---------------------------------------------------------------------------
draft = json.loads((HERE / 'record-draft.json').read_text(encoding='utf-8'))
assert draft['id'] == RID
laws = [capped('laws', {'en': x['en'], 'zh': x['zh'], 'declarations': x['declarations']}, item=True)
        for x in draft['laws']]
cited = [d for x in laws for d in x['declarations']]
assert len(cited) == len(set(cited)), 'a declaration cited twice'
assert set(cited) == names['RevisionRoutes'], (sorted(names['RevisionRoutes'] - set(cited)),
                                               sorted(set(cited) - names['RevisionRoutes']))
for field in ('title', 'statement', 'validation_scope', 'next_delta', 'correspondence'):
    capped(field, draft[field])
for field in ('hypotheses', 'does_not_show'):
    for x in draft[field]:
        capped(field, x, item=True)
record = {
    'schema_version': 2, 'id': RID, 'title': draft['title'], 'kind': 'theorem', 'status': 'recorded-checked',
    'family': draft['family'], 'reviewed_at_utc': NOW, 'statement': draft['statement'], 'laws': laws,
    'hypotheses': draft['hypotheses'], 'does_not_show': draft['does_not_show'],
    'counterexamples': draft['counterexamples'], 'standard_boundaries': draft['standard_boundaries'],
    'validation_scope': draft['validation_scope'], 'next_delta': draft['next_delta'],
    'correspondence': draft['correspondence'], 'canonical_source': LEAN['RevisionRoutes'], 'aliases': draft['aliases'],
    'dependencies': draft['dependencies'], 'related': draft['related'],
    'references': [{'path': LEAN['RevisionRoutes'], 'role': 'proof', 'declarations': sorted(cited),
                    'sha256': sha(LEAN['RevisionRoutes'])},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': NOTE, 'role': 'integration', 'sha256': sha(NOTE)},
                   {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
                   {'path': CH7, 'role': 'statement', 'sha256': sha(CH7)}],
    'proof_bindings': [{'source': LEAN['RevisionRoutes'], 'receipt': RECEIPT,
                        'sha256_pointer': '/source_sha256/Becoming.RevisionRoutes', 'success_pointer': '/status',
                        'success_value': 'passed'}],
    'history': [{'en': f'{DATE_EN}: added (RR), when no route of keeping a law stands above a revision of it: the order '
                       'of a gain and a loss, which ReadStages takes, where no route stands above the revision, its '
                       'exits, its robustness as the routes get cheap and as the value grows, and restoring as a '
                       f'lever; after a cross-model review of the Lean and the texts, every finding taken; study '
                       f'section {N}.',
                 'zh': f'{DATE_ZH}：新增（RR），守律之途何时皆不居其律之修订之上：得失之序（ReadStages 取之）、无途居修订之上之处、'
                       f'诸出路、途渐廉与值渐增时之稳、复为杠杆；经 Lean 与文本之跨模型审查，凡所见皆取；研究第 {N} 节。'}],
}
assert not lint_errors({k: record[k] for k in ('schema_version', 'id', 'title', 'statement', 'laws', 'hypotheses',
                                               'does_not_show', 'validation_scope', 'next_delta', 'correspondence')}
                       | {'counterexamples': [{'detail': x['detail']} for x in record['counterexamples']]}), RID
for x in record['related']:
    assert (RECORDS / f"{x['id']}.json").exists(), x['id']
print(f'caps: {RID} ok; {len(cited)} declarations in {len(laws)} laws')

# --- RF7's record, as its owner gave it ----------------------------------------------------------------------------------
path = RECORDS / f'{RF7}.json'
d = json.loads(path.read_text(encoding='utf-8'))
L = d['laws']
old = "exceeds the other's gain with its loss, irreflexive and asymmetric."
assert L[1]['en'].count(old) == 1 and L[1]['zh'].count('严胜另一之得加其损，') == 1
L[1]['en'] = L[1]['en'].replace(old, "exceeds the other's gain with its loss, the order of a gain and a loss at each "
                                     "plan (RevisionRoutes.GainLoss), irreflexive and asymmetric.")
L[1]['zh'] = L[1]['zh'].replace('严胜另一之得加其损，', '严胜另一之得加其损，即各策得失之序（RevisionRoutes.GainLoss），')
L[1]['declarations'].insert(L[1]['declarations'].index('Becoming.ReadStages.Prospects.Above'),
                            'Becoming.ReadStages.Prospects.order')
capped('laws', L[1], item=True)
assert L[3]['en'].startswith('Every maximal plan'), L[3]['en'][:40]
L.insert(4, capped('laws', {
    'en': "Complying at both stands where a revision of the law would, with three routes of keeping it "
          "(RevisionRoutes.Prospects at k₀ = 0, c₀ = c): the order is the revision's, the prospects the same and the "
          "processes not, complying at both keeping the law where a revision changes it; complying at both never stands "
          "above acting by its own law at both, and is maximal exactly where k_C V, k_O V and c T are all nothing.",
    'zh': '两阶段皆从居律之修订以三途守之之位（RevisionRoutes.Prospects，k₀ = 0，c₀ = c）：其序即修订之序，期同而程异，皆从守其律而修订改之；'
          '两阶段皆从永不居皆依己律之上，且为极大恰当 k_C V、k_O V 与 c T 皆无。',
    'declarations': NEW_RS[1:]}, item=True))
rs_cited = [x for law in L for x in law['declarations']]
assert len(rs_cited) == len(set(rs_cited)), 'a ReadStages declaration cited twice'
assert set(rs_cited) == names['ReadStages'], (sorted(names['ReadStages'] - set(rs_cited)),
                                              sorted(set(rs_cited) - names['ReadStages']))
assert RID not in [x['id'] for x in d['related']]
d['related'].append({'id': RID, 'detail': {
    'en': "Its order is that record's at three routes, complying at both in the place of the revision "
          "(ReadStages.above_iff_routes): the same prospects, different processes.",
    'zh': '其序即彼记录三途之序，两阶段皆从居修订之位（ReadStages.above_iff_routes）：期同而程异。'}})
d['history'].append({
    'en': '30 October 2026: its order taken from RevisionRoutes.GainLoss (rule 9, RR\'s landing), its statements and '
          'names unchanged; the correspondence with a revision at three routes and the law on complying at both added.',
    'zh': '2026年10月30日：其序取自 RevisionRoutes.GainLoss（规则九，RR 之落地），其陈述与名不变；增与三途修订之对应及两阶段皆从之律。'})
assert not lint_errors({k: d[k] for k in ('schema_version', 'id', 'title', 'statement', 'laws', 'hypotheses',
                                          'does_not_show', 'validation_scope', 'next_delta', 'correspondence')}
                       | {'counterexamples': [{'detail': x['detail']} for x in d['counterexamples']]}), RF7
print(f'caps: {RF7} ok; {len(rs_cited)} declarations in {len(L)} laws')
if CAPS_ONLY:
    raise SystemExit(0)

# rebinding: ReadStages' source, RevisionRoutes beside it, the receipt, the study and 03 move with RR's landing
refs = d['references']
proof = next(r for r in refs if r['path'] == LEAN['ReadStages'])
proof['declarations'] = sorted(rs_cited)
proof['sha256'] = sha(LEAN['ReadStages'])
assert not any(r['path'] == LEAN['RevisionRoutes'] for r in refs)
refs.insert(refs.index(proof) + 1, {'path': LEAN['RevisionRoutes'], 'role': 'proof', 'sha256': sha(LEAN['RevisionRoutes'])})
receipt = [r for r in refs if r['role'] == 'receipt']
assert len(receipt) == 1
receipt[0]['path'], receipt[0]['sha256'] = RECEIPT, sha(RECEIPT)
for r in refs:
    if r['path'] in (STUDY, CH3):
        r['sha256'] = sha(r['path'])
assert len(d['proof_bindings']) == 1 and d['proof_bindings'][0]['source'] == LEAN['ReadStages']
d['proof_bindings'][0]['receipt'] = RECEIPT
path.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record amended:', RF7)
out = RECORDS / f'{RID}.json'
assert not out.exists(), out
out.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record:', RID, len(cited), 'declarations in', len(laws), 'laws')
