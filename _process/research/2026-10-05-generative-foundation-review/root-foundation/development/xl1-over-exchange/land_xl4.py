#!/usr/bin/env python3
"""XL4's landing texts, from the worktree root on a branch at main, after the core checker run (OverExchange's new
sections) and the periphery run of Representation: python3 -I <kit>/land_xl4.py CORE_RECEIPT SECTION

Writes the study section, two records (requirement-is-the-weakest-sound-reading, laws-with-noise), the rate-one law
and history of what-discrete-steps-and-whole-amounts-represent, the warrant note of central-laws-over-every-exchange,
the chapter's text (§0 block C, §8.1 items 6 and 7, §8.5, §8.9; EN and ZH), BECOMING-FOUNDATION §9.1's (2) (EN, ZH)
and the goal record's next step. Each text edit must match exactly once; every declaration cited is resolved against
the receipts."""
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
LEAN = 'experiments/integrated-correction/general-framework/generative-basis/lean'
PKG, PER = LEAN + '/becoming', LEAN + '/representation'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
STUDY = RF + '/BECOMING-RENEWAL-READING.md'
CH, CHZ = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md', 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.zh.md'
FD, FDZ = 'theories/becoming/chapters/BECOMING-FOUNDATION.md', 'theories/becoming/chapters/BECOMING-FOUNDATION.zh.md'
GOAL = '_process/goals/theory-of-becoming.json'
RECORDS = ROOT / 'theories/becoming/results/records'
core_id, N = sys.argv[1], int(sys.argv[2])
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
PRECEIPT = f'{PER}/representation-verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
SRC = f'{PKG}/Becoming/OverExchange.lean'
PSRC = f'{PER}/Representation.lean'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def once(path, old, new):
    t = (ROOT / path).read_text(encoding='utf-8')
    assert t.count(old) == 1, ('edit does not match once', path, old[:100], t.count(old))
    (ROOT / path).write_text(t.replace(old, new), encoding='utf-8')


core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
mod = next(m for m in core['modules'] if m['module'] == 'Becoming.OverExchange')
assert core['source_sha256']['Becoming.OverExchange'] == sha(SRC)
assert not any(mod['axiom_dependencies'].values())
cnames = {d['name'] for d in mod['declarations']}
per = json.loads((ROOT / PRECEIPT).read_text())
assert per['status'] == 'passed' and per['source_sha256']['Representation'] == sha(PSRC)
pid, pm = per['utc'], per['modules'][0]
pnames = {d['name'] for d in pm['declarations']}
P, E = 'Becoming.Representation.', 'Becoming.ExchangeRelation.'


def cites(names, pool):
    for n in names:
        assert n in pool, n
    return sorted(names)


W = cites([E + x for x in ('Supports', 'Local', 'respondsBelow_supports', 'respondsBelow_local', 'respondsBelow_weakest',
                           'mayRespond_not_supports')], cnames)
NZ = cites(['Becoming.NoisyLaw', 'Becoming.NoisyLaw.relation', 'Becoming.NoisyLaw.realize', 'Becoming.NoisyLaw.course_runs',
            'Becoming.NoisyLaw.readOffExchange'], cnames)
NP = cites([P + x for x in ('expected_balance', 'RandomEnd.level', 'RandomEnd.rests', 'RandomEnd.weight',
                            'RandomEnd.summable_weighted', 'RandomEnd.expected', 'RandomEnd.rest_not_in_expectation')], pnames)
R1 = cites([P + x for x in ('rate_nonneg', 'rate_smul', 'subexponential', 'rate_one', 'shear', 'shear_pow_norm', 'shear_rate')], pnames)

HEAD = f'## {N}. Requirement as the weakest sound reading, laws with noise, and a web of rate one (XL4)'
ANCH = f'{N}-requirement-as-the-weakest-sound-reading-laws-with-noise-and-a-web-of-rate-one-xl4'
SLINK = f'../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{ANCH}'
SECTION = f'''{HEAD}

```text
Result(s): new records requirement-is-the-weakest-sound-reading and laws-with-noise; what-discrete-steps-and-whole-
       amounts-represent gains the rate-one law; central-laws-over-every-exchange's warrant note restated.
Delta: XL1-XL3 left three items open. (1) The warrant of reading requirement as necessary response: now
       necessary response is the weakest reading of requirement that does not read the current level of what is
       required and under which activity needs support on every run (respondsBelow_weakest), and possible
       response is not sound (mayRespond_not_supports), so the warrant reduces to locality. (2) Laws with noise: a
       law whose exchange also reads a noise is a relation of exchange and every realization's course a run of it
       (NoisyLaw.course_runs, NoisyLaw.readOffExchange), so the laws over relations of exchange hold path by path;
       balance passes to the expectation (expected_balance) and rest does not (RandomEnd.rest_not_in_expectation).
       (3) A web of rate exactly one: rate at most one is growth below every exponential (subexponential, through
       rate_smul), and the rate does not decide boundedness: the identity is bounded with rate one (rate_one) and
       the shear, the dual number 1 + ε, carries 1 + n with rate one (shear_rate).
Premises / correspondence: none in the core declarations; the periphery uses Lean's standard axioms through
       Mathlib (TrivSqZeroExt's L1 normed ring, Bochner integrals, geometric series).
Evidence: core receipt {core_id} (Becoming.OverExchange, {len(cnames)} declarations, empty axiom reports); periphery
       receipt {pid} (Representation, {pm['theorems']} theorems in {len(pnames)} declarations).
Boundary: locality of requirement is argued, not proved; the noise is a value read at each step, so laws that read
       a distribution of exchanges rather than a realization are not stated; the gap between the damped laws where
       a coupled step's norm exceeds its rate stays.
Output → input: chapter §0 block C, §8.1 items 6 and 7, §8.5, §8.9 (EN, ZH); BECOMING-FOUNDATION §9.1 (2) (EN, ZH);
       goal record next step.
```

**What was built.** In `Becoming.OverExchange`: {", ".join("`" + n.removeprefix("Becoming.") + "`" for n in W + NZ)}; empty axiom reports. In `Representation`: {", ".join("`" + n.removeprefix(P) + "`" for n in R1 + NP)}.

**The warrant of requirement.** A reading of requirement, a relation between a history, a step, a formation, a condition and a need, is *sound* over a relation of exchange where, whenever it holds and an open exchange has the formation exchange, the condition stands at the need; and *local* where changing only the required condition's level at that step does not change it. Necessary response is both. Every sound, local reading implies it: given the reading at a history, change the condition's level alone to below the need; locality keeps the reading, so an open exchange having the formation exchange there would contradict soundness. So necessary response is the weakest reading under which activity needs support that does not read whether the requirement is met, and possible response, which is not sound, is not a candidate. What is left to warrant is locality, argued in [BECOMING-FOUNDATION §9.1](../../../../theories/becoming/chapters/BECOMING-FOUNDATION.md#91-the-passage-from-inclusion-to-relation-argued): a requirement read off the current level would make being required depend on being met, and requirement is a counterfactual of the law (`ExchangeLaw.requirement_beyond_course`).

**Noise.** `NoisyLaw` reads a noise value at each step; its relation opens the exchanges some noise value gives. Along each realization the law is a law of exchange (`NoisyLaw.realize`) whose course is a run of the relation, so every form of `World.ReadOffExchange` holds of it, with requirement read as necessary response over every noise value: a formation requires a condition where no noise value lets it exchange with the condition below the need. Balance is linear and passes to the expectation over any distribution of the noise with integrable amounts. Rest is not: a condition standing at one until a random step, the step `ω` having weight one half to the power `ω + 1`, rests along every realization, while its expected level is one half to the power `t` and falls at every step. Laws that state that something stops, ends or rests hold path by path, not of the expectation.

**Rate one.** For the step of a web in a normed algebra over the reals, the rate of `c M` is `|c|` times the rate of `M`, so where the rate is at most one, the web scaled by `1 / r` for any `r > 1` has rate below one and vanishes: `‖M ^ n‖ / r ^ n → 0`. The identity has rate one and stays at one; the dual number `1 + ε` (two conditions, the second held and passed whole to the first) has `‖(1 + ε) ^ n‖ = 1 + n`, unbounded, and rate one, the infimum of `(k + 2) ^ (1 / (k + 1))`. So at rate one the growth is below every exponential and boundedness is not decided by the rate.
'''

study = (ROOT / STUDY).read_text(encoding='utf-8')
assert HEAD not in study
last = max(int(x) for x in re.findall(r'^## (\d+)\. ', study, re.M))
assert N == last + 1, ('section number', N, last)
(ROOT / STUDY).write_text(study.rstrip('\n') + '\n\n' + SECTION.strip() + '\n', encoding='utf-8')

# --- chapter EN ----------------------------------------------------------------------------------------------------
once(CH, '''For a law of exchange the two readings are the law's (`ExchangeLaw.relation_readWeb_requires`, `ExchangeLaw.relation_readWeb_may`).
''', f'''For a law of exchange the two readings are the law's (`ExchangeLaw.relation_readWeb_requires`, `ExchangeLaw.relation_readWeb_may`). Necessary response is the weakest reading of requirement that does not read the current level of what is required and under which activity needs support on every run (`ExchangeRelation.respondsBelow_weakest`); possible response is not such a reading (`ExchangeRelation.mayRespond_not_supports`). A law with noise is a relation of exchange, every realization's course a run of it (`NoisyLaw.readOffExchange`; XL4, [study §{N}]({SLINK})).
''')
once(CH, '''the gap between the damped laws where a coupled step's norm exceeds its rate, the rate exactly one, and a law with noise. (Landed, XL2 and XL3,''',
     f'''the gap between the damped laws where a coupled step's norm exceeds its rate. (Landed, XL4, [study §{N}]({SLINK}): at rate at most one growth is below every exponential and the rate does not decide boundedness, `Representation.subexponential`, `Representation.shear_rate`; balance passes to the expectation over a noise and rest does not, `Representation.expected_balance`, `Representation.RandomEnd.rest_not_in_expectation`.) (Landed, XL2 and XL3,''')
once(CH, '''*Open:* the law of exchange itself, a law with noise and its course;''',
     '''*Open:* the law of exchange itself (a law with noise is a relation of exchange and every realization's course a run of it, so the laws over relations of exchange hold path by path, `NoisyLaw.readOffExchange`, XL4);''')
once(CH, '''Open: that every becoming has a law or relation of exchange of this kind (items 6 and 7), and the warrant of the readings, requirement read as necessary response above all.''',
     '''Open: that every becoming has a law or relation of exchange of this kind (items 6 and 7), and the warrant of the readings. For requirement the warrant is reduced to one step: necessary response is the weakest reading under which activity needs support that does not read the current level of what is required (`ExchangeRelation.respondsBelow_weakest`), so what remains is that requiring does not read whether it is met.''')
once(CH, '''and an argument that requirement is necessary response of the exchange rather than possible response.''',
     '''and an argument that requiring does not read the current level of what is required, which with `ExchangeRelation.respondsBelow_weakest` makes requirement necessary response ([foundation §9.1](BECOMING-FOUNDATION.md#91-the-passage-from-inclusion-to-relation-argued)).''')
# --- chapter ZH ----------------------------------------------------------------------------------------------------
once(CHZ, '''；耦合步的范数超过其速率时两条阻尼规律之间的间隙、速率恰为一，以及带噪声的规律。''',
     f'''；耦合步的范数超过其速率时两条阻尼规律之间的间隙。已落地（XL4，[研究第 {N} 节]({SLINK})）：速率至多为一时增长慢于任何指数，速率不决定是否有界（`Representation.subexponential`、`Representation.shear_rate`）；平衡在噪声上取期望后仍成立，停息则不然（`Representation.expected_balance`、`Representation.RandomEnd.rest_not_in_expectation`）。''')
once(CHZ, '''开放：*交换之律本身，带噪声的律及其历程；''',
     '''开放：*交换之律本身（带噪声的律是交换关系，每个实现的进程是其运行，所以交换关系上的规律逐路径成立，`NoisyLaw.readOffExchange`，XL4）；''')
# --- foundation §9.1 (2) ---------------------------------------------------------------------------------------------
once(FD, '''(2) The warrant of the readings: activity needing support is internal only under requirement read as necessary response; read as possible response it fails (`ExchangeRelation.free_unsupported`). The case for necessary response is that a requirement the exchange can go on without is no requirement of that exchange, an argument, not a proof. ''',
     f'''(2) The warrant of the readings. Activity needing support is internal only under requirement read as necessary response; read as possible response it fails (`ExchangeRelation.free_unsupported`, `ExchangeRelation.mayRespond_not_supports`). Necessary response is the weakest reading of requirement that does not read the current level of what is required and under which activity needs support on every run (`ExchangeRelation.respondsBelow_weakest`, XL4, [study §{N}](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{ANCH})). So its warrant is that of locality: what a formation requires is fixed by what its exchange does under other levels of the required condition, not by the level that condition happens to have. The case for locality is that a requirement read off the current level would make being required depend on being met, so that any activity could be counted as supported by how requirement is read; requirement is a counterfactual of the law, which no course fixes (`ExchangeLaw.requirement_beyond_course`). An argument, not a proof. ''')
once(FDZ, '''读法的根据，尤其是需要读作必然回应（读作可能回应时活动需要支撑不成立，`ExchangeRelation.free_unsupported`）；''',
     '''读法的根据：需要读作必然回应时，活动需要支撑才是内在的；读作可能回应时它不成立（`ExchangeRelation.free_unsupported`、`ExchangeRelation.mayRespond_not_supports`）。必然回应是不读所需者当前水平、且使活动需要支撑的最弱读法（`ExchangeRelation.respondsBelow_weakest`，XL4），所以根据归结为局部性：需要什么，由交换在所需条件的其他水平下怎样做决定，而非由该条件恰好所处的水平决定，否则是否被需要就取决于是否已被满足（论证，而非证明）；''')
# --- goal record ---------------------------------------------------------------------------------------------------
goal = json.loads((ROOT / GOAL).read_text(encoding='utf-8'))
ns = goal['overview']['next_step']
for k, old, new in (
        ('en', 'open: that every becoming has a law or relation of exchange of this kind, and the warrant of reading requirement as necessary response.',
         'open: that every becoming has a law or relation of exchange of this kind; for requirement the warrant is reduced to locality, necessary response being the weakest reading under which activity needs support that does not read the current level of what is required (`ExchangeRelation.respondsBelow_weakest`, XL4).'),
        ('en', 'Open: the rate exactly one, and laws with noise.',
         'Settled too (XL4): at rate one growth is below every exponential and the rate does not decide boundedness; a law with noise is a relation of exchange, so the laws hold path by path, balance passing to the expectation and rest not. Open: the gap between the damped laws where a coupled step\'s norm exceeds its rate.'),
        ('zh', '开放：每个生成／变化是否都有这样的交换之律或关系，以及把需要读作必然回应的根据。',
         '开放：每个生成／变化是否都有这样的交换之律或关系；需要的根据已归结为局部性：必然回应是不读所需者当前水平、且使活动需要支撑的最弱读法（`ExchangeRelation.respondsBelow_weakest`，XL4）。'),
        ('zh', '开放：速率恰为一，以及带噪声的规律。',
         '亦已判明（XL4）：速率为一时增长慢于任何指数，速率不决定是否有界；带噪声的律是交换关系，规律逐路径成立，平衡在期望上成立而停息不然。开放：耦合步的范数超过其速率时两条阻尼规律之间的间隙。')):
    assert ns[k].count(old) == 1, (k, old[:60])
    ns[k] = ns[k].replace(old, new)
(ROOT / GOAL).write_text(json.dumps(goal, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')

# --- existing records ----------------------------------------------------------------------------------------------
p = RECORDS / 'what-discrete-steps-and-whole-amounts-represent.json'
r = json.loads(p.read_text(encoding='utf-8'))
r['laws'].append({'en': 'At rate at most one a web grows slower than every exponential; the rate does not decide whether it stays bounded: the identity is bounded with rate one, the shear (the dual number 1 + ε) carries 1 + n with rate one (XL4).',
                  'zh': '速率至多为一时，网的增长慢于任何指数；速率不决定它是否有界：恒等步以速率一保持有界，剪切（对偶数 1 + ε）以速率一携带 1 + n（XL4）。',
                  'declarations': R1})
r['does_not_show'] = [d for d in r['does_not_show'] if 'rate exactly one' not in d['en']] + [
    {'en': 'The gap between the damped laws where a coupled step\'s norm exceeds its rate; that the rate is the spectral radius (Gelfand\'s formula, cited).',
     'zh': '耦合步的范数超过其速率时两条阻尼规律之间的间隙；速率即谱半径（Gelfand 公式，引用）。', 'kind': 'scope'}]
for ref in r['references']:
    if ref['path'] == PSRC:
        ref['declarations'] = sorted(pnames)
r['next_delta'] = {'en': 'The gap between the damped laws; an independent review.', 'zh': '两条阻尼规律之间的间隙；独立审查。'}
r['history'].append({'en': f'22 October 2026: the rate-one law added (XL4, study section {N}); periphery receipt {pid}.',
                     'zh': f'2026年10月22日：增加速率为一的规律（XL4，研究第 {N} 节）；外围回执 {pid}。'})
p.write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

p = RECORDS / 'central-laws-over-every-exchange.json'
r = json.loads(p.read_text(encoding='utf-8'))
for d in r['does_not_show']:
    if d['en'].startswith('The warrant of reading requirement as necessary response'):
        d['en'] = 'The warrant of locality, on which reading requirement as necessary response rests: necessary response is the weakest local reading under which activity needs support (requirement-is-the-weakest-sound-reading); read as possible response, activity needing support fails.'
        d['zh'] = '局部性的根据，把需要读作必然回应依赖于它：必然回应是使活动需要支撑的最弱局部读法（requirement-is-the-weakest-sound-reading）；读作可能回应时，活动需要支撑不成立。'
r['history'].append({'en': f'22 October 2026: the warrant note restated after XL4 (study section {N}); no statement changed.',
                     'zh': f'2026年10月22日：XL4 之后重述根据一条（研究第 {N} 节）；陈述未变。'})
p.write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

# --- new records ---------------------------------------------------------------------------------------------------
BOUNDS = ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical', 'names-provisional',
          'omission-not-refutation']


def dep(rid, en, zh, ev):
    return {'id': rid, 'relation': 'formal-reuse', 'detail': {'en': en, 'zh': zh},
            'interface': {'output': {'en': en, 'zh': zh}, 'input': {'en': 'This record\'s laws.', 'zh': '本记录的规律。'},
                          'conditions': {'en': 'None.', 'zh': '无。'}, 'evidence': ev}}


def write(rid, rec):
    path = RECORDS / f'{rid}.json'
    assert not path.exists(), rid
    assert len(rec['statement']['en']) <= 300
    path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


base_refs = [{'path': SRC, 'role': 'proof', 'sha256': sha(SRC)}, {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
             {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)}, {'path': CH, 'role': 'statement', 'sha256': sha(CH)}]
write('requirement-is-the-weakest-sound-reading', {
    'schema_version': 2, 'id': 'requirement-is-the-weakest-sound-reading',
    'title': {'en': 'Necessary response is the weakest sound reading of requirement', 'zh': '必然回应是需要的最弱健全读法'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {'en': 'Over every relation of exchange, necessary response is the weakest reading of requirement that does not read the current level of what is required and under which activity needs support on every run; possible response is not sound.',
                  'zh': '在每个交换关系上，必然回应是不读所需者当前水平、且使活动在每段运行上需要支撑的最弱需要读法；可能回应不健全。'},
    'laws': [{'en': 'Necessary response is sound and local, and every sound, local reading of requirement implies it.',
              'zh': '必然回应健全且局部，每个健全而局部的需要读法都蕴含它。', 'declarations': W[:5] if False else sorted(set(W) - {E + 'mayRespond_not_supports'})},
             {'en': 'Possible response is not sound: under the free relation a formation taking from a condition at nothing possibly responds to it falling below one.',
              'zh': '可能回应不健全：在自由关系下，从处于零的条件取用的形成，可能回应它降到一以下。', 'declarations': [E + 'mayRespond_not_supports']}],
    'hypotheses': [{'en': 'No axiom and no premise.', 'zh': '不加公理，不加前提。'}],
    'does_not_show': [{'en': 'That requirement is local: that what a formation requires does not read the current level of what is required is argued in the foundation chapter, not proved.',
                       'zh': '需要是局部的：形成所需不读所需者当前水平，这一点在基础一章中论证，不是证明。', 'kind': 'non-implication'}],
    'counterexamples': [{'path': SRC, 'detail': {'en': 'mayRespond_not_supports: possible response under the free relation.', 'zh': 'mayRespond_not_supports：自由关系下的可能回应。'}}],
    'standard_boundaries': BOUNDS,
    'validation_scope': {'en': f'Machine-checked by the Lean 4.29.1 checker (receipt {core_id}); empty axiom reports. Author review in study section {N}; not independently reviewed.',
                         'zh': f'Lean 4.29.1 检查器实查（回执 {core_id}）；公理报告为空。作者审查见研究第 {N} 节；未经独立审查。'},
    'next_delta': {'en': 'An argument for or against locality; an independent review.', 'zh': '支持或反对局部性的论证；独立审查。'},
    'correspondence': {'en': 'The warrant of the reading on which the internal relatedness of activity and support rests (BECOMING-FOUNDATION §9.1, chapter §8.5). The reduction is the AI\'s.',
                       'zh': '活动与支撑的内在相关所依赖之读法的根据（BECOMING-FOUNDATION 第 9.1 节，第 8.5 节）。这一归结是 AI 的。'},
    'canonical_source': SRC,
    'aliases': ['necessary response is the weakest sound reading of requirement', '必然回应是需要的最弱健全读法',
                E + 'respondsBelow_weakest', E + 'mayRespond_not_supports'],
    'dependencies': [dep('requirement-over-open-exchanges', 'Reuses ExchangeRelation, RespondsBelow, MayRespondBelow and free_unsupported.',
                         '复用 ExchangeRelation、RespondsBelow、MayRespondBelow 与 free_unsupported。', SRC)],
    'related': [{'id': 'central-laws-over-every-exchange', 'detail': {'en': 'The reading the forms over a world read off a relation take.', 'zh': '从交换关系读出之世界上的形式所取的读法。'}}],
    'references': [{**base_refs[0], 'declarations': W}] + base_refs[1:] + [{'path': FD, 'role': 'statement', 'sha256': sha(FD)}],
    'proof_bindings': [{'source': SRC, 'receipt': RECEIPT, 'sha256_pointer': '/source_sha256/Becoming.OverExchange', 'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{'en': f'22 October 2026: added (XL4); study section {N}.', 'zh': f'2026年10月22日：新增（XL4）；研究第 {N} 节。'}]})
write('laws-with-noise', {
    'schema_version': 2, 'id': 'laws-with-noise',
    'title': {'en': 'Laws with noise: path by path, and in expectation', 'zh': '带噪声的规律：逐路径与取期望'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {'en': 'A law of exchange with noise is a relation of exchange, every realization\'s course a run of it, so the laws hold path by path; balance passes to the expectation, and rest does not.',
                  'zh': '带噪声的交换之律是交换关系，每个实现的进程是其运行，所以规律逐路径成立；平衡传到期望，停息则不然。'},
    'laws': [{'en': 'A law with noise is the relation of exchange opening what some noise value gives; along every realization its course is a run, and the world read off it a world read off a relation of exchange.',
              'zh': '带噪声的律是打开某个噪声值所给者的交换关系；沿每个实现，其进程是运行，从它读出的世界是从交换关系读出的世界。', 'declarations': NZ},
             {'en': 'Balance holds in expectation over any distribution of the noise with integrable amounts; a condition ending at a random step rests along every realization while its expected level falls at every step.',
              'zh': '对噪声的任何分布、量可积时，平衡在期望上成立；在随机一步终结的条件沿每个实现停息，而其期望水平每步都下降。', 'declarations': NP}],
    'hypotheses': [{'en': 'No premise in the core declarations; the periphery uses Lean\'s standard axioms through Mathlib and names integrability where it enters.',
                    'zh': '核心声明不加前提；外围经 Mathlib 使用 Lean 的标准公理，可积性在其进入处写明。'}],
    'does_not_show': [{'en': 'Laws reading a distribution of exchanges rather than a realization; that an actual noise is a value read at each step.',
                       'zh': '读交换之分布而非某一实现的规律；实际噪声是每步读取的一个值。', 'kind': 'scope'}],
    'counterexamples': [{'path': PSRC, 'detail': {'en': 'RandomEnd.rest_not_in_expectation: rest along every realization, none in expectation.', 'zh': 'RandomEnd.rest_not_in_expectation：沿每个实现停息，期望上不停息。'}}],
    'standard_boundaries': BOUNDS,
    'validation_scope': {'en': f'Core: Lean 4.29.1 checker, receipt {core_id}, empty axiom reports. Periphery: Lean 4.30.0-rc2 with Mathlib, receipt {pid}, Lean\'s standard axioms only. Author review in study section {N}; not independently reviewed.',
                         'zh': f'核心：Lean 4.29.1 检查器，回执 {core_id}，公理报告为空。外围：Lean 4.30.0-rc2 与 Mathlib，回执 {pid}，只用 Lean 的标准公理。作者审查见研究第 {N} 节；未经独立审查。'},
    'next_delta': {'en': 'Laws of the distribution of courses (variance, the seen half of T6 is one); an independent review.', 'zh': '进程分布的规律（方差，T6 的可见一半即其一）；独立审查。'},
    'correspondence': {'en': 'Chapter §8.1 item 7\'s "a law with noise and its course". The seen half of T6 (periphery SlowingDown) states a variance law of a linear step with noise.',
                       'zh': '第 8.1 节第 7 项的“带噪声的律及其历程”。T6 的可见一半（外围 SlowingDown）陈述带噪声线性步的方差规律。'},
    'canonical_source': SRC,
    'aliases': ['laws with noise', '带噪声的规律', 'Becoming.NoisyLaw.readOffExchange', P + 'expected_balance', P + 'RandomEnd.rest_not_in_expectation'],
    'dependencies': [dep('central-laws-over-every-exchange', 'Reuses World.ReadOffExchange and ExchangeRelation.Runs.readOffExchange.',
                         '复用 World.ReadOffExchange 与 ExchangeRelation.Runs.readOffExchange。', SRC)],
    'related': [{'id': 'what-discrete-steps-and-whole-amounts-represent', 'detail': {'en': 'The same periphery module.', 'zh': '同一外围模块。'}}],
    'references': [{**base_refs[0], 'declarations': NZ}, {'path': PSRC, 'role': 'proof', 'declarations': NP, 'sha256': sha(PSRC)},
                   base_refs[1], {'path': PRECEIPT, 'role': 'receipt', 'sha256': sha(PRECEIPT)}] + base_refs[2:],
    'proof_bindings': [{'source': SRC, 'receipt': RECEIPT, 'sha256_pointer': '/source_sha256/Becoming.OverExchange', 'success_pointer': '/status', 'success_value': 'passed'},
                       {'source': PSRC, 'receipt': PRECEIPT, 'sha256_pointer': '/source_sha256/Representation', 'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{'en': f'22 October 2026: added (XL4); study section {N}.', 'zh': f'2026年10月22日：新增（XL4）；研究第 {N} 节。'}]})

# bind the touched records' references to the files as left
for rid in ('requirement-is-the-weakest-sound-reading', 'laws-with-noise', 'what-discrete-steps-and-whole-amounts-represent',
            'central-laws-over-every-exchange'):
    p = RECORDS / f'{rid}.json'
    r = json.loads(p.read_text(encoding='utf-8'))
    for ref in r['references']:
        if 'sha256' in ref:
            ref['sha256'] = sha(ref['path'])
    p.write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('landed texts XL4 section', N, len(cnames), len(pnames))
