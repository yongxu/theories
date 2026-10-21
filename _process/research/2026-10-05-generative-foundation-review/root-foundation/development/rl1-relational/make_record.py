#!/usr/bin/env python3
"""Write RL1's record relation-level-law-of-easing (a theorem), note it in ranking-under-readings and
stepwise-law-of-easing (whose relation-level items it states):
python3 -B make_record.py CORE_RECEIPT STUDY_SECTION PREVIOUS_RECEIPT   (from the checkout root, after apply_text.py)

The laws cite exactly the declarations Becoming.Ranking, Becoming.Relevance and Becoming.JointDraw gained since the
previous receipt; every cited declaration is resolved against the receipt's audited declarations, and the receipt must
bind each cited module's current bytes."""
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
HEAD = f"## {N}. The relation-level reading's law of easing, and restraint under it (RL1)"
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

RID = 'relation-level-law-of-easing'
RR = 'ranking-under-readings'
SL = 'stepwise-law-of-easing'
RK, RV, JD = 'Ranking', 'Relevance', 'JointDraw'

laws = [
    ("The relation-level reading on courses: a claim is a formation's relation to a condition at a step, included when "
     "the formation is active, takes part in the condition and the relation does not undermine; it is the living of "
     "Web.relations.",
     '进程上的关系层读法：一个断言是一个形成在某步对一个条件的关系，在形成活动、参与该条件且该关系不侵蚀时被记入；它即 Web.relations 的 living。',
     [(RK, ['relational']), (RV, ['Ranking.relational_iff'])]),
    ('The relation-level law of easing: under easing a relation the reading includes in the first course stays included in '
     'the second exactly where the second still takes part and does not undermine there, so the second extends the first '
     'exactly when it takes part in and does not undermine every relation the first includes and includes one it withholds.',
     '关系层的缓和之律：在缓和下，读法在前者记入的关系，恰在后者仍参与且不在那里侵蚀之处在后者仍被记入；所以后者扩展前者，恰当它参与且不侵蚀前者记入的每个关系，并记入前者扣下的某个关系。',
     [(RK, ['relational_kept_iff', 'relational_extends_iff_of_eases'])]),
    ('Where no level falls in the easing course and it takes part wherever the other does, it extends the other under the '
     'relation-level reading exactly when it includes a relation the other withholds.',
     '在缓和之进程中无水平下降且它在另一进程参与之处皆参与时，它在关系层读法下扩展另一进程，恰当它记入另一进程扣下的某个关系。',
     [(RK, ['relational_extends_iff_of_rising'])]),
    ("In the two-part family the relation-level reading includes the focal formation's relation where the stepwise reading "
     "includes its event, so absence and occurrence are unranked, as under the stepwise reading.",
     '在二元族中，关系层读法在逐步读法记入焦点形成之事件处记入其关系，所以不在场与在场不被排序，如同逐步读法。',
     [(RK, ['relational_unranked'])]),
    ("Restraint over any number of drawers under the relation-level reading: under the stepwise restraint theorem's "
     "premises, where the restrained course also takes part in every condition wherever the other does, it extends the "
     "other exactly when it includes a relation the other withholds.",
     '关系层读法下对任意多个汲取者的节制：在逐步节制定理的前提下，若节制的进程在另一进程参与之处皆参与，它扩展另一进程，恰当它记入另一进程扣下的某个关系。',
     [(JD, ['Ranking.restraint_extends_iff_relational'])]),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))


def resolve_any(mod, names):
    full = decls(mod)
    out = []
    for n in names:
        hits = [f for f in full if f in (f'Becoming.{mod}.' + n, 'Becoming.' + n, 'Becoming.Ranking.' + n)]
        assert len(hits) == 1, (mod, n, hits)
        out.append(hits[0])
    return out


P = json.loads(Path(previous).read_text())
new_by = {}
for mod in [RK, RV, JD]:
    old_names = {d['name'] for d in next(m for m in P['modules'] if m['module'] == f'Becoming.{mod}')['declarations']}
    full = decls(mod)
    assert old_names <= set(full), old_names - set(full)
    new = sorted(d for d in full if d not in old_names)
    cited = sorted(d for _, _, groups in laws for m, names in groups if m == mod for d in resolve_any(mod, names))
    assert cited == new, (mod, set(new) - set(cited), set(cited) - set(new))
    new_by[mod] = new
EARLIER = {RK: ['Becoming.Ranking.active_of_eases', 'Becoming.Ranking.not_undermining_of_rising', 'Becoming.Ranking.Eases',
                'Becoming.Ranking.ActiveWhereSupported', 'Becoming.Ranking.ExtendsUnder', 'Becoming.Ranking.stepwise',
                'Becoming.Ranking.stepwise_unranked', 'Becoming.Ranking.absent_sustains'],
           RV: ['Becoming.Ranking.stepwise_iff'],
           JD: ['Becoming.Ranking.restraint_extends_iff_stepwise', 'Becoming.Flow.Balances.eases_of_restrained']}
for mod, names in EARLIER.items():
    missing = set(names) - set(decls(mod))
    assert not missing, (mod, missing)
n_new = sum(len(v) for v in new_by.values())
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': "The relation-level reading's law of easing, and restraint under it",
              'zh': '关系层读法的缓和之律及其下的节制'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'Read relation by relation, easing withdraws exactly the relations the easing course no longer takes part in '
              'or undermines; restraint that lets no level fall and keeps taking part ranks above overdraw for any number '
              'of drawers under the relation-level reading too.',
        'zh': '逐个关系读时，缓和所撤回的恰是缓和之进程不再参与或所侵蚀的关系；不让任何水平下降且仍参与的节制，在关系层读法下也对任意多个汲取者排在过度汲取之上。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': [d for m, names in groups for d in resolve_any(m, names)]}
             for en, zh, groups in laws],
    'hypotheses': [
        {'en': "No axiom. The readings of living (relation-level: a formation's relation to a condition, active, taking part "
               "and not undermining); each law's own premises as hypotheses: the gating of activity, easing; for restraint, "
               "balanced flows, the restrained flow taking no more, giving no less and within what it gives, and taking "
               "part wherever the other does.",
         'zh': '不加公理。生命的读法（关系层：一个形成对一个条件的关系，活动、参与且不侵蚀）；各律自身的前提为假设：活动的门控、缓和；节制需平衡之流，节制之流所取不多、所给不少且不超过所给，'
               '并在另一进程参与之处皆参与。'}],
    'does_not_show': [
        {'en': 'That participation kept is needed beyond each relation the other includes: the exact law asks it relation '
               'by relation.',
         'zh': '在另一进程记入的各关系之外需保持参与：确切之律逐个关系要求。', 'kind': 'non-implication'},
        {'en': 'Restraint by abstaining: a course that stops drawing on and depending on a condition loses its relations to '
               'it, so this law does not rank it.',
         'zh': '以弃绝为节制：停止汲取且停止依赖某条件的进程失去对它的关系，故本律不对它排序。', 'kind': 'scope'},
        {'en': 'Which reading of living to use; the form of L under the condition; J1 step by step.',
         'zh': '应采用哪种生命读法；条件之下 L 的形式；逐步的 J1。', 'kind': 'scope'}],
    'counterexamples': [],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the {n_new} declarations '
              f'Becoming.Ranking, Becoming.Relevance and Becoming.JointDraw gained have empty axiom reports; the checker '
              f'verifies core purity. Built and reviewed in one session; author review in study section {N}; not '
              f'independently reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.Ranking、Becoming.Relevance 与 Becoming.JointDraw 新增的 {n_new} '
              f'项声明公理报告为空；检查器并核对核心纯净。在一个会话中构建并审查；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'A witness that participation kept cannot be dropped in the restraint theorem; the form of L under the '
              'condition; J1 step by step; an independent review.',
        'zh': '表明节制定理中保持参与不可去掉的见证；条件之下 L 的形式；逐步的 J1；独立审查。'},
    'correspondence': {
        'en': "The comparison laws are the theory's own. The three readings of living now each have an exact law of easing: "
              "the whole-run law needs easing and the gating of activity; the stepwise law adds that the easing course "
              "undermine no included event; the relation-level law adds that it keep taking part in every included relation.",
        'zh': '比较之律是本理论自己的。三种生命读法现在各有确切的缓和之律：整段之律需缓和与活动的门控；逐步之律加上缓和之进程不侵蚀被记入的事件；关系层之律再加上它对每个被记入的关系仍参与。'},
    'canonical_source': src(RK),
    'aliases': ['the relation-level law of easing', 'restraint under the relation-level reading', '关系层的缓和之律',
                'Becoming.Ranking.relational_extends_iff_of_eases', 'Becoming.Ranking.restraint_extends_iff_relational'],
    'dependencies': [
        {'id': SL, 'relation': 'formal-reuse',
         'detail': {'en': 'Easing keeps activity, a course whose levels never fall undermines nothing, and the stepwise '
                          'restraint theorem are reused.',
                    'zh': '沿用缓和保持活动、水平从不下降的进程不侵蚀任何事件，以及逐步节制定理。'},
         'interface': {
             'output': {'en': 'active_of_eases, not_undermining_of_rising, restraint_extends_iff_stepwise.',
                        'zh': 'active_of_eases、not_undermining_of_rising、restraint_extends_iff_stepwise。'},
             'input': {'en': 'The relation-level law of easing and restraint under it.',
                       'zh': '关系层的缓和之律及其下的节制。'},
             'conditions': {'en': 'Easing; the gating of activity; participation kept for the restraint theorem.',
                            'zh': '缓和；活动的门控；节制定理需保持参与。'},
             'evidence': src(RK)}},
        {'id': RR, 'relation': 'formal-reuse',
         'detail': {'en': 'The readings, easing and the two-part family are reused; the relation-level reading it left '
                          'unformalized on courses is stated.',
                    'zh': '沿用读法、缓和与二元族；陈述了它在进程上未形式化的关系层读法。'},
         'interface': {
             'output': {'en': 'stepwise, Eases, ExtendsUnder, stepwise_unranked, absent_sustains.',
                        'zh': 'stepwise、Eases、ExtendsUnder、stepwise_unranked、absent_sustains。'},
             'input': {'en': 'The relation-level reading on courses and its comparisons.', 'zh': '进程上的关系层读法及其比较。'},
             'conditions': {'en': 'The two-part family for the unranked instance.', 'zh': '不排序之实例需二元族。'},
             'evidence': src(RK)}}],
    'related': [],
    'references': [{'path': src(m), 'role': 'proof', 'declarations': sorted(new_by[m] + EARLIER[m]), 'sha256': sha(src(m))}
                   for m in [RK, RV, JD]]
                  + [{'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                     {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                     {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
                     {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)}],
    'proof_bindings': [{'source': src(mod), 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{mod}',
                        'success_pointer': '/status', 'success_value': 'passed'} for mod in [RK, RV, JD]],
    'history': [{
        'en': f'21 October 2026: added (RL1), the relation-level reading on courses, its exact law of easing, its whole-run '
              f'form, restraint over any number of drawers under it and the two-part family unranked; study section {N}.',
        'zh': f'2026年10月21日：新增（RL1），进程上的关系层读法、其确切的缓和之律、其整段形式、其下对任意多个汲取者的节制，以及二元族不排序；研究第 {N} 节。'}],
}
path = RECORDS / f'{RID}.json'
assert not path.exists(), 'record exists'
assert len(rec['statement']['en']) <= 300 and len(rec['statement']['zh']) <= 150, (len(rec['statement']['en']), len(rec['statement']['zh']))
for h in rec['hypotheses']:
    assert len(h['en']) <= 420, len(h['en'])
for h in rec['does_not_show']:
    assert len(h['en']) <= 240, len(h['en'])
assert len(rec['validation_scope']['zh']) <= 260, len(rec['validation_scope']['zh'])

notes = [
    (RR, [("The relation-level reading also includes the focal formation's first relation but is not formalized separately.",
           f'The relation-level reading beyond easing and restraint: record {RID} states those.'),
          ('关系层读法同样记入焦点形成的第一个关系，但未单独形式化。', f'关系层读法在缓和与节制之外的比较：记录 {RID} 陈述了这两者。')],
         [('The same comparison under the relation-level reading; whether', 'Whether'), ('形式化关系层读法下的同一比较；', '')]),
    (SL, [('The relation-level reading; the form of L', 'The form of L'), ('关系层读法；条件之下 L 的形式', '条件之下 L 的形式')],
         [('the relation-level reading; ', ''), ('关系层读法；', '')])]
loaded = {}
for rid, dns_pairs, nd_pairs in notes:
    d = json.loads((RECORDS / f'{rid}.json').read_text())
    for old, new in dns_pairs:
        lang = 'zh' if re.search('[一-鿿]', old) else 'en'
        hits = [x for x in d['does_not_show'] if old in x[lang]]
        assert len(hits) == 1, (rid, old)
        hits[0][lang] = hits[0][lang].replace(old, new)
    for old, new in nd_pairs:
        lang = 'zh' if re.search('[一-鿿]', old) else 'en'
        assert d['next_delta'][lang].count(old) == 1, (rid, lang, old)
        d['next_delta'][lang] = d['next_delta'][lang].replace(old, new)
    d['related'] = d.get('related', []) + [{'id': RID, 'detail': {
        'en': 'The relation-level reading on courses: under easing it withdraws exactly the relations the easing course no '
              'longer takes part in or undermines; restraint that keeps taking part ranks above overdraw under it too.',
        'zh': '进程上的关系层读法：在缓和下它所撤回的恰是缓和之进程不再参与或所侵蚀的关系；仍参与的节制在它之下也排在过度汲取之上。'}}]
    d['history'].append({
        'en': f'21 October 2026, RL1: the relation-level reading is formalized on courses with its exact law of easing and '
              f'restraint under it (record {RID}, study section {N}); what this record does not show and its next step say '
              f'so. Its laws are unchanged.',
        'zh': f'2026年10月21日，RL1：关系层读法在进程上形式化，带确切的缓和之律及其下的节制（记录 {RID}，研究第 {N} 节）；本记录所不表明者与其下一步如此说明。其规律不变。'})
    loaded[rid] = d
# every edit checked before anything is written
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID, n_new, 'declarations')
for rid, d in loaded.items():
    (RECORDS / f'{rid}.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print('noted', rid)
