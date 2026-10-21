#!/usr/bin/env python3
"""Write ST1's record stepwise-law-of-easing (a theorem), note it in ranking-under-readings (whose stepwise law and
restraint boundary it refines), and give the coverage file's row its law:
python3 -B make_record.py CORE_RECEIPT STUDY_SECTION PREVIOUS_RECEIPT   (from the checkout root, after apply_text.py)

The laws cite exactly the declarations Becoming.Ranking and Becoming.JointDraw gained since the previous receipt. Every
declaration cited is resolved against the receipt's audited declarations, and the receipt must bind each cited module's
current bytes."""
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
REVIEW = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-SIGNIFICANCE-REVIEW.md'
CHAPTER = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
COVERAGE = 'theories/becoming/results/completion/COVERAGE.json'
RECORDS = ROOT / 'theories/becoming/results/records'
core_id, N, previous = sys.argv[1], int(sys.argv[2]), sys.argv[3]
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
HEAD = f"## {N}. The stepwise law of easing, and restraint over any number of drawers under the stepwise reading (ST1)"
assert re.search('^' + re.escape(HEAD) + '$', (ROOT / STUDY).read_text(), re.M)


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def src(mod):
    return f'{PKG}/Becoming/{mod}.lean'


def decls(mod):
    m = next(m for m in core['modules'] if m['module'] == f'Becoming.{mod}')
    assert core['source_sha256'][f'Becoming.{mod}'] == sha(src(mod)), ('receipt does not bind', mod)
    assert not any(m['axiom_dependencies'].values())
    return [d['name'] for d in m['declarations']]


def resolve(mod, names):
    full = decls(mod)
    out = []
    for n in names:
        hits = [f for f in full if f == f'Becoming.{mod}.' + n]
        assert len(hits) == 1, (mod, n, hits)
        out.append(hits[0])
    return out


BOUNDS = ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical', 'names-provisional',
          'omission-not-refutation']

RID = 'stepwise-law-of-easing'
RR = 'ranking-under-readings'
RK, JD = 'Ranking', 'JointDraw'

laws = [
    ('Easing keeps activity: from a course where activity needs support to one where activity follows support and that '
     'eases it (asks no more, holds every condition as high, draws on nothing more), a formation active in the first is '
     'active in the second.',
     '缓和保持活动：从活动需要支持的进程到活动随支持且缓和它的进程（所求不多、各条件同样高、不多汲取），在前者活动的形成在后者也活动。',
     [(RK, ['active_of_eases'])]),
    ('The stepwise law of easing: under easing an event the stepwise reading includes in the first course stays included '
     'in the second exactly where the second does not undermine there, so the second extends the first exactly when it '
     'undermines no event the first includes and includes one the first withholds.',
     '逐步的缓和之律：在缓和下，逐步读法在前者记入的事件，恰在后者不在那里侵蚀之处在后者仍被记入，所以后者扩展前者，恰当它不侵蚀前者所记入的任何事件且记入前者扣下的某个事件。',
     [(RK, ['stepwise_kept_iff', 'stepwise_extends_iff_of_eases'])]),
    ('A course in which no condition\'s level falls undermines nothing: a level that never falls stays at or above every '
     'need it once met; so where no level falls in the easing course the stepwise law of easing is the whole-run one.',
     '没有条件水平下降的进程不侵蚀任何事件：从不下降的水平保持在它曾满足的每个所需之上；所以在缓和之进程中无水平下降之处，逐步的缓和之律即整段之律。',
     [(RK, ['level_never_falls', 'not_undermining_of_rising', 'stepwise_extends_iff_of_rising'])]),
    ('Restraint over any number of drawers under the stepwise reading: under the premises of the whole-run comparison, '
     'where moreover the restrained flow takes from no condition more than it gives, the restrained course extends the '
     'overdrawing one exactly when it includes an event the other withholds, and every comparison satisfying C ranks it '
     'higher.',
     '逐步读法下对任意多个汲取者的节制：在整段比较的前提下，若节制之流从任何条件所取不多于所给，节制的进程扩展过度汲取的进程，恰当它记入另一个扣下的某个事件，满足 C 的每个比较把它排得更高。',
     [(JD, ['Ranking.restraint_extends_iff_stepwise', 'Ranking.restraint_ranks_stepwise'])]),
    ('Where the premise fails: in ThirdParty the restrained course undermines at step 3 the focal event the overdrawing '
     'course includes, the third formation met at seven only in the restrained course falling below its need after the '
     'focal draw.',
     '前提不成立之处：在 ThirdParty 中节制的进程在第 3 步侵蚀过度汲取之进程所记入的焦点事件：只在节制进程中于七被满足的第三形成在焦点汲取后落到所需之下。',
     [(RK, ['ThirdParty.undermines_included'])]),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))


def resolve_any(mod, names):
    full = decls(mod)
    out = []
    for n in names:
        hits = [f for f in full if f in (f'Becoming.{mod}.' + n, 'Becoming.' + n)]
        assert len(hits) == 1, (mod, n, hits)
        out.append(hits[0])
    return out


P = json.loads(Path(previous).read_text())
new_by = {}
for mod in [RK, JD]:
    old_names = {d['name'] for d in next(m for m in P['modules'] if m['module'] == f'Becoming.{mod}')['declarations']}
    full = decls(mod)
    assert old_names <= set(full), old_names - set(full)
    new = sorted(d for d in full if d not in old_names)
    cited = sorted(d for _, _, groups in laws for m, names in groups if m == mod for d in resolve_any(mod, names))
    assert cited == new, (mod, set(new) - set(cited), set(cited) - set(new))
    new_by[mod] = new
EARLIER = {RK: ['Becoming.Ranking.stepwise', 'Becoming.Ranking.wholeRun', 'Becoming.Ranking.Eases',
                'Becoming.Ranking.ActiveWhereSupported', 'Becoming.Ranking.ExtendsUnder', 'Becoming.Ranking.ComparisonUnder',
                'Becoming.Ranking.wholeRun_mono', 'Becoming.Ranking.wholeRun_extends_iff_of_eases',
                'Becoming.Ranking.ThirdParty.focal_three', 'Becoming.Ranking.ThirdParty.stepwise_not_monotone'],
           JD: ['Becoming.Ranking.restraint_extends_iff', 'Becoming.Flow.Balances.eases_of_restrained']}
for mod, names in EARLIER.items():
    have = set(decls(mod))
    missing = set(names) - have
    assert not missing, (mod, missing)
n_new = sum(len(v) for v in new_by.values())
def lam(mod, names):
    return [d for d in resolve_any(mod, names)]
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'The stepwise law of easing, and restraint over any number of drawers under the stepwise reading',
              'zh': '逐步的缓和之律，以及逐步读法下对任意多个汲取者的节制'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'Under easing the stepwise reading withdraws exactly the events the easing course undermines; a course whose '
              'levels never fall undermines nothing, so restraint that takes within what it gives ranks above overdraw '
              'for any number of drawers under the stepwise reading too.',
        'zh': '在缓和下逐步读法所撤回的恰是缓和之进程所侵蚀的事件；水平从不下降的进程不侵蚀任何事件，所以所取不超过所给的节制在逐步读法下也对任意多个汲取者排在过度汲取之上。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': [d for m, names in groups for d in lam(m, names)]}
             for en, zh, groups in laws],
    'hypotheses': [
        {'en': 'No axiom. The readings of living (stepwise: active and not undermining); each law\'s '
               'own premises as hypotheses: activity needing support in one course and following it in the other, easing '
               '(asks no more, holds every condition as high, draws on nothing more); for restraint, balanced flows, levels '
               'as high at the start, the restrained flow taking no more, giving no less and taking within what it gives.',
         'zh': '不加公理。ranking-under-readings 的生命读法（逐步：活动且不侵蚀）；各律自身的前提为假设：一个进程中活动需要支持、另一个中随支持，缓和（所求不多、各条件同样高、不多汲取）；'
               '节制需平衡之流、起点水平同样高、节制之流所取不多、所给不少且所取不超过所给。'}],
    'does_not_show': [
        {'en': 'That taking within what is given is needed: it is sufficient; the exact condition is that the restrained '
               'course undermine no event the other includes.',
         'zh': '所取不超过所给是必要的：它是充分的；确切条件是节制的进程不侵蚀另一进程所记入的任何事件。', 'kind': 'non-implication'},
        {'en': 'The relation-level reading; the form of L under the condition; whether J1 yields "better without malignant '
               'growth" step by step.',
         'zh': '关系层读法；条件之下 L 的形式；J1 能否在逐步读法下给出“没有恶性增殖更好”。', 'kind': 'scope'},
        {'en': 'Which reading of living to use, or any duty to restrain: the laws rank courses under each reading.',
         'zh': '应采用哪种生命读法，或任何节制的义务：这些规律只在各读法下给进程排序。', 'kind': 'non-implication'}],
    'counterexamples': [
        {'path': src(RK), 'detail': {
            'en': 'Ranking.ThirdParty.undermines_included: a restrained course that eases the other yet undermines an event '
                  'the other includes is not ranked above it under the stepwise reading.',
            'zh': 'Ranking.ThirdParty.undermines_included：缓和另一进程却侵蚀其所记入事件的节制进程，在逐步读法下不被排在其上。'}}],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the {n_new} declarations '
              f'Becoming.Ranking and Becoming.JointDraw gained have empty axiom reports; the checker verifies core purity. '
              f'Built and reviewed in one session, with no separate reviewer; author review in study section {N}; not '
              f'independently reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.Ranking 与 Becoming.JointDraw 新增的 {n_new} 项声明公理报告为空；'
              f'检查器并核对核心纯净。在一个会话中构建并审查，没有另设审查者；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'A flow-level premise exactly equivalent to undermining no included event; the relation-level reading; the '
              'form of L under the condition; J1 step by step; an independent review.',
        'zh': '与不侵蚀被记入事件恰好等价的流层前提；关系层读法；条件之下 L 的形式；逐步的 J1；独立审查。'},
    'correspondence': {
        'en': 'The comparison laws are the theory\'s own: comparison principle C read through a frame whose realized claims '
              'are the events a reading includes, with the whole-run and stepwise readings of living. This record turns '
              'the stepwise reading\'s failure under easing (ThirdParty) into an exact law: what the stepwise valuation '
              'counts against a gentler course is exactly the undermining that course itself commits.',
        'zh': '比较之律是本理论自己的：比较原则 C 经由一个其实现之断言为读法所记入事件的框架来读，配以整段与逐步两种生命读法。本记录把逐步读法在缓和下的失败（ThirdParty）'
              '变为确切之律：逐步评价对较温和进程所计的，恰是该进程自己所犯的侵蚀。'},
    'canonical_source': src(RK),
    'aliases': ['the stepwise law of easing', 'restraint under the stepwise reading', 'a course whose levels never fall undermines nothing',
                '逐步的缓和之律', 'Becoming.Ranking.stepwise_extends_iff_of_eases', 'Becoming.Ranking.restraint_extends_iff_stepwise'],
    'dependencies': [
        {'id': RR, 'relation': 'formal-reuse',
         'detail': {'en': 'The readings, easing, the whole-run law of easing, ThirdParty and restraint under the whole-run '
                          'reading are reused; the stepwise law it left open is stated.',
                    'zh': '沿用读法、缓和、整段的缓和之律、ThirdParty 与整段读法下的节制；陈述了它留下的逐步之律。'},
         'interface': {
             'output': {'en': 'stepwise, Eases, ActiveWhereSupported, wholeRun_extends_iff_of_eases, ThirdParty, '
                              'restraint_extends_iff, Flow.Balances.eases_of_restrained.',
                        'zh': 'stepwise、Eases、ActiveWhereSupported、wholeRun_extends_iff_of_eases、ThirdParty、restraint_extends_iff、'
                              'Flow.Balances.eases_of_restrained。'},
             'input': {'en': 'The exact stepwise law of easing and restraint over any number of drawers under it.',
                       'zh': '确切的逐步缓和之律及其下对任意多个汲取者的节制。'},
             'conditions': {'en': 'Easing; the gating of activity; for restraint, balanced flows taking within what they give.',
                            'zh': '缓和；活动的门控；节制需所取不超过所给的平衡之流。'},
             'evidence': src(RK)}}],
    'related': [],
    'references': [{'path': src(m), 'role': 'proof', 'declarations': sorted(new_by[m] + EARLIER[m]), 'sha256': sha(src(m))}
                   for m in [RK, JD]]
                  + [{'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                     {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                     {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
                     {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)}],
    'proof_bindings': [{'source': src(mod), 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{mod}',
                        'success_pointer': '/status', 'success_value': 'passed'} for mod in [RK, JD]],
    'history': [{
        'en': f'21 October 2026: added (ST1), the stepwise law of easing: under easing the stepwise reading withdraws exactly '
              f'the events the easing course undermines; a course whose levels never fall undermines nothing; restraint over '
              f'any number of drawers under the stepwise reading where the restrained flow takes within what it gives; study '
              f'section {N}.',
        'zh': f'2026年10月21日：新增（ST1），逐步的缓和之律：在缓和下逐步读法所撤回的恰是缓和之进程所侵蚀的事件；水平从不下降的进程不侵蚀任何事件；节制之流所取不超过所给之处，'
              f'逐步读法下对任意多个汲取者的节制；研究第 {N} 节。'}],
}
path = RECORDS / f'{RID}.json'
assert not path.exists(), 'record exists'
assert len(rec['statement']['en']) <= 300 and len(rec['statement']['zh']) <= 150, (len(rec['statement']['en']), len(rec['statement']['zh']))
assert len(rec['correspondence']['en']) <= 1200 and len(rec['correspondence']['zh']) <= 500
for h in rec['hypotheses']:
    assert len(h['en']) <= 420, len(h['en'])
for h in rec['does_not_show']:
    assert len(h['en']) <= 240, len(h['en'])
assert len(rec['validation_scope']['zh']) <= 260, len(rec['validation_scope']['zh'])
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID, n_new, 'declarations')

p = RECORDS / f'{RR}.json'
d = json.loads(p.read_text())
law = [l for l in d['laws'] if l['en'] == 'Under the stepwise reading the renewal in the law of comparison cannot be dropped, and there is no law of easing.']
assert len(law) == 1
law[0]['en'] = ('Under the stepwise reading the renewal in the law of comparison cannot be dropped, and easing alone gives '
                f'no law of easing: the law needs that the easing course undermine no event the other includes (record {RID}).')
law[0]['zh'] = f'逐步读法下，比较之律不能去掉更新，单凭缓和也没有缓和之律：此律需要缓和之进程不侵蚀另一进程所记入的任何事件（记录 {RID}）。'
dns = [x for x in d['does_not_show'] if x['en'].startswith('The comparisons of absence with presence')]
assert len(dns) == 1
old_en = 'under the stepwise reading only in the two-part family, and ThirdParty shows that taking no more does not suffice there.'
assert dns[0]['en'].count(old_en) == 1
dns[0]['en'] = dns[0]['en'].replace(old_en, f'under the stepwise reading where it takes within what it gives (record {RID}).')
old_zh = '在逐步读法下只在二元族中证明，ThirdParty 表明在那里所取不多并不足够。'
assert dns[0]['zh'].count(old_zh) == 1
dns[0]['zh'] = dns[0]['zh'].replace(old_zh, f'在逐步读法下于所取不超过所给之处证明（记录 {RID}）。')
assert len(dns[0]['en']) <= len(old_en) + 340, len(dns[0]['en'])
for lang, old in [('en', 'A restraint theorem under the stepwise reading beyond the two-part family, with a premise beyond taking no more, since ThirdParty shows that alone does not suffice (amounts so that taking nothing does not undermine, for example); '),
                  ('zh', '逐步读法下二元族之外的节制定理，需要所取不多之外的前提，因为 ThirdParty 表明单此不足（例如带数量使不取者不侵蚀）；')]:
    assert d['next_delta'][lang].count(old) == 1, lang
    d['next_delta'][lang] = d['next_delta'][lang].replace(old, '')
d['next_delta']['en'] = d['next_delta']['en'][0].upper() + d['next_delta']['en'][1:]
d['related'] = d.get('related', []) + [{'id': RID, 'detail': {
    'en': 'The stepwise law of easing, exact: easing withdraws exactly the events the easing course undermines; restraint '
          'that takes within what it gives ranks above overdraw for any number of drawers under the stepwise reading.',
    'zh': '确切的逐步缓和之律：缓和所撤回的恰是缓和之进程所侵蚀的事件；所取不超过所给的节制在逐步读法下对任意多个汲取者排在过度汲取之上。'}}]
d['history'].append({
    'en': f'21 October 2026, ST1: the stepwise law of easing is stated exactly and restraint over any number of drawers under '
          f'the stepwise reading where the restrained flow takes within what it gives (record {RID}, study section {N}); the '
          f'law that said the stepwise reading has no law of easing now says easing alone gives none; what this record does '
          f'not show and its next step say so.',
    'zh': f'2026年10月21日，ST1：确切陈述了逐步的缓和之律，以及节制之流所取不超过所给之处逐步读法下对任意多个汲取者的节制（记录 {RID}，研究第 {N} 节）；'
          f'原说逐步读法没有缓和之律的规律现说单凭缓和没有；本记录所不表明者与其下一步如此说明。'})
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('noted', RR)
