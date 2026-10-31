#!/usr/bin/env python3
"""RR2's landing (make_records_rr.py's pattern): the record when-holding-for-a-reading-stands-above-a-route
(Becoming.RevisionPlans, home 07 §7) from the reviewed draft (record-draft.json), each declaration of its module cited
once; RF-M.2's record what-holding-for-a-reading-is-worth amended (term_go and term_off gone from its balances' law, a
law for going on, switching off and holding for a rule as plans, a related entry, a history entry), every declaration
of HeldForReading cited once and its references and proof binding moved to RR2's receipt; RR's record
when-no-route-stands-above-a-revision amended (the join gone from its next step, a related entry, a history entry);
and, where RF-M.3 has landed, its record a-reading-informed-and-revalued amended (a related entry, a history entry,
ListingValuation's proof binding moved to RR2's receipt). In the amended records the hashes of the paths RR2's
landing writes are refreshed, after the texts are in place.
Asserts the receipt's hashes and empty axiom reports for both modules, and the style caps and lint on every field
written.
usage (from the checkout root, after the texts are in place): python3 -B make_records_rr2.py RECEIPT N
       python3 -B make_records_rr2.py --caps  (caps, lint and declaration cover against the kit's scratch audits;
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
RECEIPT_ID, N = ('20261031T000000.000000Z', 470) if CAPS_ONLY else (sys.argv[1], int(sys.argv[2]))
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RFD = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RFD + 'BECOMING-RENEWAL-READING.md'
KITD = RFD + 'development/rr-revision-routes/'
NOTE, REVIEW = KITD + 'NOTE.md', KITD + 'REVIEW.md'
CH3, CH7 = 'theories/becoming/chapters/03-KNOWING.md', 'theories/becoming/chapters/07-SIGNIFICANCE.md'
LEAN = {m: f'{PKG}/Becoming/{m}.lean' for m in ('RevisionPlans', 'HeldForReading')}
# RF-M.3's module, whose forgone_lt_iff RR2's landing proves from the order of plans, once it is on main
LV = f'{PKG}/Becoming/ListingValuation.lean'
LVR = 'a-reading-informed-and-revalued'
HAS_LV = (ROOT / LV).exists()
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
TODAY = datetime.date.today()
DATE_EN, DATE_ZH = f'{TODAY.day} {TODAY:%B} {TODAY.year}', f'{TODAY.year}年{TODAY.month}月{TODAY.day}日'
RID, HFR, RR = ('when-holding-for-a-reading-stands-above-a-route', 'what-holding-for-a-reading-is-worth',
                'when-no-route-stands-above-a-revision')
# the paths RR2's landing writes, whose hashes the amended records may refresh
WRITTEN = {LEAN['HeldForReading'], LV, STUDY, NOTE, REVIEW, CH3, CH7}
NEW_HFR = [f'Becoming.HeldForReading.{n}' for n in
           ('gainOf_goOn', 'gainOf_off', 'gainOf_held', 'excess_goOn', 'excess_off', 'excess_held', 'moves_not_below_iff',
            'held_above_moves_iff', 'held_above_held_iff')]
GONE_HFR = ['Becoming.HeldForReading.term_go', 'Becoming.HeldForReading.term_off']


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


def linted(d):
    return ({k: d[k] for k in ('schema_version', 'id', 'title', 'statement', 'laws', 'hypotheses', 'does_not_show',
                               'validation_scope', 'next_delta', 'correspondence')}
            | {'counterexamples': [{'detail': x['detail']} for x in d['counterexamples']]})


names = {}
if CAPS_ONLY:
    for m in LEAN:
        audit = (HERE / f'tree/.build/Becoming{m}AxiomAudit.lean').read_text(encoding='utf-8')
        names[m] = set(re.findall(r'^#print axioms (\S+)$', audit, re.M))
else:
    core = json.loads((ROOT / RECEIPT).read_text())
    assert core['status'] == 'passed'
    for m in LEAN:
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
assert set(cited) == names['RevisionPlans'], (sorted(names['RevisionPlans'] - set(cited)),
                                              sorted(set(cited) - names['RevisionPlans']))
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
    'correspondence': draft['correspondence'], 'canonical_source': LEAN['RevisionPlans'], 'aliases': draft['aliases'],
    'dependencies': draft['dependencies'], 'related': draft['related'],
    'references': [{'path': LEAN['RevisionPlans'], 'role': 'proof', 'declarations': sorted(cited),
                    'sha256': sha(LEAN['RevisionPlans'])},
                   {'path': LEAN['HeldForReading'], 'role': 'proof', 'declarations': sorted(NEW_HFR),
                    'sha256': sha(LEAN['HeldForReading'])},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': NOTE, 'role': 'integration', 'sha256': sha(NOTE)},
                   {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
                   {'path': CH7, 'role': 'statement', 'sha256': sha(CH7)}],
    'proof_bindings': [{'source': LEAN['RevisionPlans'], 'receipt': RECEIPT,
                        'sha256_pointer': '/source_sha256/Becoming.RevisionPlans', 'success_pointer': '/status',
                        'success_value': 'passed'}],
    'history': [{'en': f'{DATE_EN}: added (RR2), when holding for a reading stands above a route of keeping: plans '
                       'keeping a law going on and switching it off at a model\'s candidates, each with a loss of its '
                       'own, on RR\'s order; the balance, every two plans splitting the weights gaining the same with '
                       'their excesses; RR\'s routes as plans on one candidate; HeldForReading taking its balances '
                       'from it; after a cross-model review and its re-check, every finding taken; study section '
                       f'{N}.',
                 'zh': f'{DATE_ZH}：新增（RR2），为读而持何时居守律之途之上：于模型诸候选续律与止律之策，各有己损，'
                       '居 RR 之序；衡，每二分权之策得加其余皆同；RR 之途为一候选上之策；HeldForReading 取其衡于此；'
                       f'经跨模型审查及其复查，凡所见皆取；研究第 {N} 节。'}],
}
assert not lint_errors(linted(record)), RID
for x in record['related']:
    assert (RECORDS / f"{x['id']}.json").exists(), x['id']
print(f'caps: {RID} ok; {len(cited)} declarations in {len(laws)} laws')

# --- RF-M.2's record ------------------------------------------------------------------------------------------------------
path_h = RECORDS / f'{HFR}.json'
h = json.loads(path_h.read_text(encoding='utf-8'))
L = h['laws']
k = [i for i, law in enumerate(L) if 'Becoming.HeldForReading.term_go' in law['declarations']]
assert len(k) == 1, k
for gone in GONE_HFR:
    L[k[0]]['declarations'].remove(gone)
L.insert(k[0] + 1, capped('laws', {
    'en': "Going on, switching off and holding for a rule are plans of the order of plans at a revision "
          "(RevisionPlans), their gains the moves' and the rule's values and holding's excess the rule's shortfall; "
          "that order compares them, and holding for two rules, as their values do, and the balances, ties, "
          "thresholds and comparisons with an amount forgone above are its laws (RevisionPlans.balance, above_iff).",
    'zh': '续、止与为规则而持，为修订之策之序（RevisionPlans）中之策，其得即二行与规则之值，持之余即规则之所缺；'
          '此序比之，及为二规则而持，皆如其值；上之衡、等、阈与舍一量之比皆其律（RevisionPlans.balance、above_iff）。',
    'declarations': NEW_HFR}, item=True))
h_cited = [x for law in L for x in law['declarations']]
assert len(h_cited) == len(set(h_cited)), 'a HeldForReading declaration cited twice'
assert set(h_cited) == names['HeldForReading'], (sorted(names['HeldForReading'] - set(h_cited)),
                                                 sorted(set(h_cited) - names['HeldForReading']))
assert RID not in [x['id'] for x in h['related']]
h['related'].append({'id': RID, 'detail': {
    'en': 'Its balances, ties, thresholds and comparisons with an amount forgone are proved from that record\'s order of plans, holding for '
          'a rule a plan whose excess is the rule\'s shortfall (HeldForReading.excess_held).',
    'zh': '其衡、等、阈与舍一量之比由彼记录之策之序证之，为规则而持为一策，其余即规则之所缺（HeldForReading.excess_held）。'}})
h['history'].append({
    'en': f'{DATE_EN}: its balances, after_byReading, shortfall_byReading, held_eq_go_iff, held_eq_off_iff, the '
          'thresholds, the comparisons with an amount forgone and across_le_iff proved from RevisionPlans (rule 9, RR2\'s landing), '
          'term_go and term_off gone, every other statement and name unchanged; going on, switching off and holding '
          'for a rule stated as plans, with held_above_moves_iff and held_above_held_iff.',
    'zh': f'{DATE_ZH}：其衡、after_byReading、shortfall_byReading、held_eq_go_iff、held_eq_off_iff、阈、舍一量之比与 '
          'across_le_iff 由 RevisionPlans 证之（规则九，RR2 之落地），term_go 与 term_off 去之，余之陈述与名不变；'
          '续、止与为规则而持述为策，并 held_above_moves_iff 与 held_above_held_iff。'})
assert not lint_errors(linted(h)), HFR
print(f'caps: {HFR} ok; {len(h_cited)} declarations in {len(L)} laws')

# --- RR's record ----------------------------------------------------------------------------------------------------------
path_r = RECORDS / f'{RR}.json'
r = json.loads(path_r.read_text(encoding='utf-8'))
nd = r['next_delta']
old_en = "Joining these prospects with RF-M.2's value of holding for a reading (the off-switch game); "
old_zh = '此诸望与 RF-M.2 之待读之值（关机博弈）相接；'
assert nd['en'].startswith(old_en) and nd['zh'].startswith(old_zh), (nd['en'][:80], nd['zh'][:30])
nd['en'] = nd['en'][len(old_en)].upper() + nd['en'][len(old_en) + 1:]
nd['zh'] = nd['zh'][len(old_zh):]
capped('next_delta', nd)
assert RID not in [x['id'] for x in r['related']]
r['related'].append({'id': RID, 'detail': {
    'en': 'Its revision and routes are plans on one candidate there, ordered by each one\'s loss with the value of the '
          'weight it leaves unkept, and joined with holding for a reading (RevisionPlans.routes_above_iff).',
    'zh': '其修订与诸途为彼处一候选上之策，以各自之损加其所未守之权之值排之，并与为读而持相接（RevisionPlans.routes_above_iff）。'}})
r['history'].append({
    'en': f'{DATE_EN}: joined with RF-M.2\'s value of holding for a reading on one order (RR2), the join gone from its '
          'next step; its statements and names unchanged.',
    'zh': f'{DATE_ZH}：与 RF-M.2 之待读之值同居一序（RR2），相接一项去于其下一步；其陈述与名不变。'})
assert not lint_errors(linted(r)), RR
print(f'caps: {RR} ok')

# --- RF-M.3's record, where it has landed --------------------------------------------------------------------------------
v = None
if (RECORDS / f'{LVR}.json').exists():
    path_v = RECORDS / f'{LVR}.json'
    v = json.loads(path_v.read_text(encoding='utf-8'))
    assert RID not in [x['id'] for x in v['related']]
    v['related'].append({'id': RID, 'detail': {
        'en': 'Its comparison of two rules held for, each forgoing an amount (ListingValuation.forgone_lt_iff), is the '
              'order of plans at two rules held for (RevisionPlans.above_iff, HeldForReading.held_above_held_iff).',
        'zh': '其比二规则之持，各舍一量（ListingValuation.forgone_lt_iff），即为二规则而持之策之序'
              '（RevisionPlans.above_iff、HeldForReading.held_above_held_iff）。'}})
    v['history'].append({
        'en': f'{DATE_EN}: forgone_lt_iff, and with it forgone_through_lt_iff, revalued_forgone_lt_iff and '
              'presented_forgone_lt_iff, proved from the order of plans (rule 9, RR2\'s landing); no statement or '
              'name changed.',
        'zh': f'{DATE_ZH}：forgone_lt_iff，并经之 forgone_through_lt_iff、revalued_forgone_lt_iff 与 '
              'presented_forgone_lt_iff，由策之序证之（规则九，RR2 之落地）；无一陈述或名改变。'})
    assert not lint_errors(linted(v)), LVR
    print(f'caps: {LVR} ok')
    record['related'].append({'id': LVR, 'detail': {
        'en': 'Its comparison of two rules held for, each forgoing an amount (ListingValuation.forgone_lt_iff), is this '
              'order at two rules held for, and the comparisons through it with it.',
        'zh': '其比二规则之持，各舍一量（ListingValuation.forgone_lt_iff），即此序于二规则之持，经之诸比随之。'}})
if CAPS_ONLY:
    raise SystemExit(0)

# rebinding RF-M.2's record: HeldForReading's source, RevisionPlans beside it, the receipt
refs = h['references']
proof = next(x for x in refs if x['path'] == LEAN['HeldForReading'])
proof['declarations'] = sorted(h_cited)
assert not any(x['path'] == LEAN['RevisionPlans'] for x in refs)
refs.insert(refs.index(proof) + 1, {'path': LEAN['RevisionPlans'], 'role': 'proof', 'sha256': sha(LEAN['RevisionPlans'])})
receipt = [x for x in refs if x['role'] == 'receipt']
assert len(receipt) == 1
receipt[0]['path'], receipt[0]['sha256'] = RECEIPT, sha(RECEIPT)
assert len(h['proof_bindings']) == 1 and h['proof_bindings'][0]['source'] == LEAN['HeldForReading']
h['proof_bindings'][0]['receipt'] = RECEIPT
# rebinding RF-M.3's record: ListingValuation's proof binding to RR2's receipt
if v is not None:
    assert HAS_LV
    core = json.loads((ROOT / RECEIPT).read_text())
    assert core['source_sha256']['Becoming.ListingValuation'] == sha(LV)
    vrec = [x for x in v['references'] if x['role'] == 'receipt']
    assert len(vrec) == 1
    vrec[0]['path'], vrec[0]['sha256'] = RECEIPT, sha(RECEIPT)
    for b in v['proof_bindings']:
        b['receipt'] = RECEIPT
# the paths RR2's landing writes, in every amended record
for d in (h, r) + ((v,) if v is not None else ()):
    for x in d['references']:
        if x['path'] in WRITTEN:
            x['sha256'] = sha(x['path'])
path_h.write_text(json.dumps(h, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
path_r.write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
if v is not None:
    path_v.write_text(json.dumps(v, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('records amended:', HFR, RR, LVR if v is not None else '(RF-M.3 not on main)')
out = RECORDS / f'{RID}.json'
assert not out.exists(), out
out.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record:', RID, len(cited), 'declarations in', len(laws), 'laws')
