#!/usr/bin/env python3
"""SJ's last landing (reland_sj.py's pattern): 08's counts from the receipt, the study section from study_sj2.txt
appended as section N, SJ1's record given its seventh law (GuardHorizon's bridge) with the receipt, and GuardHorizon's
record (when-to-inquire-and-when-to-respond) one history line. The texts (03 §12, 07 §5, 08 §7, the root module's
bullet, the README row) are already on the branch. The receipt must have checked the very GuardHorizon.lean the
record names, with an empty axiom report for every declaration, the bridge's two among them.
usage (from the checkout root of the worktree): python3 -B <kit>/reland_sj2.py RECEIPT N"""
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
RECEIPT, N = sys.argv[1], int(sys.argv[2])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
STUDY = ROOT / f'{RF}/BECOMING-RENEWAL-READING.md'
CH = ROOT / 'theories/becoming/chapters'
RECORDS = ROOT / 'theories/becoming/results/records'
TITLE = "The edge where acting meets the situation: the map, 07 §5 and GuardHorizon's bridge (SJ's last parts)"
GH = f'{PKG}/Becoming/GuardHorizon.lean'
BRIDGE = ['Becoming.GuardHorizon.uniform_policy_iff_common', 'Becoming.GuardHorizon.ungiven_reading_not_uniform']
TODAY = '2 November 2026'

rpath = f'{PKG}/becoming-checks/{RECEIPT}/verification.json'
R = json.loads((ROOT / rpath).read_text())
assert R['status'] == 'passed'
mods = {m['module']: m for m in R['modules']}
gh = mods['Becoming.GuardHorizon']
assert gh['layer'] == 'application', gh['layer']
assert not any(gh['axiom_dependencies'].values()), 'an axiom in GuardHorizon'
gh_sha = hashlib.sha256((ROOT / GH).read_bytes()).hexdigest()
assert R['source_sha256']['Becoming.GuardHorizon'] == gh_sha, 'the receipt checked another GuardHorizon.lean'
declared = {x['name'] for x in gh['declarations']}
assert set(BRIDGE) <= declared, set(BRIDGE) - declared
assert 'Becoming.GuardHorizon.statewise_not_uniform' in declared

# 08: receipt and counts, every count read from the receipt (reland_sj.py's sentence)
layers = {}
for module in R['modules']:
    count = layers.setdefault(module['layer'], [0, 0])
    count[0] += 1
    count[1] += module['theorems']
assert set(layers) <= {'foundation', 'core', 'instance', 'application'}, set(layers)
modules = sum(v[0] for v in layers.values())
theorems = sum(v[1] for v in layers.values())
assert modules == len(R['core_closure']), (modules, len(R['core_closure']))
ring = layers.get('instance', [0, 0])[0] + layers.get('application', [0, 0])[0]
declarations = sum(len(m['declarations']) for m in R['modules'])
injeq = sum(1 for name, axioms in R['generated_axiom_dependencies'].items()
            if name.endswith('.injEq') and axioms == ['propext'])
assert injeq == len(R['generated_axiom_dependencies']), 'a generated dependency other than injEq on propext'
superseded = len(R['superseded_modules'])
link = f'../../../{PKG}/becoming-checks/{RECEIPT}/verification.json'
counts = (f"At core receipt [`{RECEIPT}`]({link}) (Lean 4.29.1), the closure held {modules} modules "
          f"({layers['foundation'][0]} foundation, {layers['core'][0]} core, {ring} in the instance and application ring) "
          f"and {theorems:,} theorems; the {layers['core'][0]} core modules held {layers['core'][1]:,} of them; "
          f"{declarations:,} declarations were audited; {injeq} generated `injEq` lemmas depend on `propext`; "
          f"{superseded} superseded modules were kept out of the run.")
path = CH / '08-METHOD.md'
s = path.read_text(encoding='utf-8')
s, k = re.subn(r"At core receipt \[`[0-9TZ.]+`\]\([^)]*\) \(Lean 4\.29\.1\), the closure held \d+ modules \(\d+ foundation, "
               r"\d+ core, \d+ in the instance and application ring\) and [\d,]+ theorems; the \d+ core modules held [\d,]+ of "
               r"them; [\d,]+ declarations were audited; \d+ generated `injEq` lemmas depend on `propext`; \d+ superseded "
               r"modules were kept out of the run\.", lambda m: counts, s)
assert k == 1, k
path.write_text(s, encoding='utf-8')

# the study section, appended as section N
section = (HERE / 'study_sj2.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
assert section.count('(GH)') == 1
section = section.replace('(GH)', f"({gh['theorems']} theorems in {len(gh['declarations'])} declarations)")
assert '{' not in section and 'TODO' not in section, 'a placeholder left'
t = STUDY.read_text(encoding='utf-8')
assert TITLE not in t, "the section is already in the study"
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, N
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

now = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
digest = hashlib.sha256((ROOT / rpath).read_bytes()).hexdigest()

# SJ1's record: the seventh law, its hypothesis, the converse no longer open, the reference, binding and receipt
p = RECORDS / 'a-response-common-over-a-reading.json'
d = json.loads(p.read_text(encoding='utf-8'))
assert len(d['laws']) == 6, len(d['laws'])
d['laws'].append({
    'en': ("The rule's converse, at any type: given a choice over the readings and every reading given by some "
           "situation, a rule from readings meeting the requirement exists exactly where a response common over the "
           "reading's sameness does; with that choice, no situation and no act, a common response exists with no such "
           "rule, so the readings' being given cannot simply be dropped."),
    'zh': ("规则之逆，对任一类型：给定读数上的选择，且每一读数皆由某一情境给出，则合乎要求、由读数而定的规则存在，"
           "当且仅当对读之同的共应存在；有此选择而无情境亦无行时，共应存在而无此规则，故读数皆被给出不可径去。"),
    'declarations': BRIDGE,
})
d['hypotheses'].append({
    'en': ("For the seventh law only: a choice over the readings (`Viability.ChoiceOver`) and every reading given by "
           "some situation, each named as a hypothesis; the second cannot simply be dropped, by a witness with no situation and no act."),
    'zh': "仅第七律：读数上的选择（`Viability.ChoiceOver`）与每一读数皆由某一情境给出，各列为前提；第二者不可径去，见证中既无情境亦无行。",
})
conv = [x for x in d['does_not_show'] if x.get('kind') == 'converse']
assert len(conv) == 1, conv
conv[0]['en'] = ("That a rule fixed for each reading from a common response needs the choice over the readings: the "
                 "seventh law takes it as a hypothesis, and that such choice cannot be dropped is shown for plans "
                 "(Viability.plans_iff_choice), not for this rule.")
conv[0]['zh'] = ("由共应为每一读数确定之规则需要读数上的选择：第七律以之为前提；此类选择不可免去，已就计划证之"
                 "（Viability.plans_iff_choice），未就此规则证之。")
deps = [x for x in d['dependencies'] if x['id'] == 'when-to-inquire-and-when-to-respond']
assert not deps, deps
d['dependencies'].append({
    'id': 'when-to-inquire-and-when-to-respond',
    'relation': 'formal-reuse',
    'detail': {
        'en': ("The seventh law reads that record's uniform policy: uniform_policy_iff_common is its "
               "uniform_policy_iff_fiber_feasible with, every reading given, the condition rearranged into this record's covering law, and "
               "its example statewise_not_uniform is re-proved from this record's witness, its statement unchanged."),
        'zh': ("第七律读该记录之一致策略：uniform_policy_iff_common 即其 uniform_policy_iff_fiber_feasible，每一读数皆被给出时，条件改写为本记录之"
               "遍盖律；其例 statewise_not_uniform 由本记录之见证重证，陈述不变。"),
    },
})
d['related'] = [x for x in d['related'] if x['id'] != 'when-to-inquire-and-when-to-respond']
assert not [x for x in d['references'] if x['path'] == GH]
d['references'].insert(2, {'path': GH, 'role': 'proof', 'sha256': gh_sha,
                           'declarations': BRIDGE + ['Becoming.GuardHorizon.statewise_not_uniform']})
d['proof_bindings'].append({'source': GH, 'receipt': rpath, 'sha256_pointer': '/source_sha256/Becoming.GuardHorizon',
                            'success_pointer': '/status', 'success_value': 'passed'})
d['references'].append({'path': rpath, 'role': 'receipt', 'sha256': digest, 'declarations': []})
d['validation_scope'] = {
    'en': ("Checked by the core checker with Lean 4.29.1 from the prelude: Becoming.CommonResponse at receipt "
           "20261101T112708.430596Z (36 theorems) and Viability, whose two kernel laws are proved from the leaf with "
           f"their statements unchanged; the seventh law in the ring module Becoming.GuardHorizon at receipt {RECEIPT} "
           f"({gh['theorems']} theorems); every axiom report empty. Read by independent AI reviewers, the design, the "
           "Lean and the map, and the landing texts twice, each finding verified, every confirmed one taken."),
    'zh': ("由核心检查器以 Lean 4.29.1 从前奏检查：Becoming.CommonResponse 于回执 20261101T112708.430596Z（36 条定理），"
           "以及 Viability，其两条不变核之律由此叶证出、陈述不变；第七律在环模块 Becoming.GuardHorizon，于回执 "
           f"{RECEIPT}（{gh['theorems']} 条定理）；公理报告均为空。经独立 AI 审阅者阅读设计、Lean 与图，以及两轮落地文本，"
           "各有核验，所核实者皆采纳。"),
}
assert len(d['validation_scope']['en']) <= 600 and len(d['validation_scope']['zh']) <= 260, \
    (len(d['validation_scope']['en']), len(d['validation_scope']['zh']))
d['next_delta'] = {
    'en': ("The models' examples of PairsNotCommon (ReadingLoop.PairwiseShared, AssurancePlans.Routes) re-proved from "
           "this record's witness on their owners' word, and the reading's own formation stated within the law."),
    'zh': "模型中 PairsNotCommon 之例（ReadingLoop.PairwiseShared、AssurancePlans.Routes）经其所属者同意由本记录之见证重证，并在此律之内陈述读本身之形成。",
}
d['history'].append({
    'en': (f"{TODAY}, board item SJ's last parts: the seventh law, GuardHorizon's bridge (uniform_policy_iff_common "
           "and its witness ungiven_reading_not_uniform), with statewise_not_uniform re-proved from the sixth law's "
           f"witness; checked at core receipt {RECEIPT}; the map of what a response takes in at 08 §7 and one sentence "
           "in 07 §5 land with it."),
    'zh': (f"2026年11月2日，工作板条目 SJ 之余部：第七律，GuardHorizon 之桥（uniform_policy_iff_common 及其见证 "
           "ungiven_reading_not_uniform），statewise_not_uniform 由第六律之见证重证；由核心回执 "
           f"{RECEIPT} 检查；08 §7 之回应所取者之图与 07 §5 之一句随之落地。"),
})
d['reviewed_at_utc'] = now
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

# GuardHorizon's record: one history line; its laws and statements unchanged
p = RECORDS / 'when-to-inquire-and-when-to-respond.json'
d = json.loads(p.read_text(encoding='utf-8'))
d['history'].append({
    'en': (f"{TODAY}: statewise_not_uniform (law 2) re-proved from the core's witness «共应之例».EachNotCommon, its "
           "statement unchanged; GuardHorizon gains uniform_policy_iff_common: with every reading given by some "
           "configuration, law 1's equivalence with the condition read as a response common over the reading's "
           "sameness, recorded as the seventh law of "
           "a-response-common-over-a-reading."),
    'zh': (f"2026年11月2日：statewise_not_uniform（第 2 律）由核心见证 «共应之例».EachNotCommon 重证，陈述不变；"
           "GuardHorizon 新增 uniform_policy_iff_common：每一读数皆由某一配置给出时，即第 1 律之等价，其条件读作对读之同的共应，记为 "
           "a-response-common-over-a-reading 之第七律。"),
})
if not any(x['id'] == 'a-response-common-over-a-reading' for x in d.get('related', [])):
    d.setdefault('related', []).append({'id': 'a-response-common-over-a-reading', 'detail': {
        'en': "Its seventh law reads law 1's equivalence, with every reading given by some configuration, with the condition as a response common over the reading's sameness.",
        'zh': '其第七律在每一读数皆由某一配置给出时，把第 1 律之等价的条件读作对读之同的共应。'}})
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('reland:', counts[:110], '...; study section', N, '; two records written')
