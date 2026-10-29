#!/usr/bin/env python3
"""OU3f, laws of steps: extend master-laws-on-the-grammar. The group of steps counted gains the five laws; the last group
gains reaches_onward, now proved from «不穷则迭», with steps_advance and a proof reference and binding for MapInstances;
the design and the review; the receipt; the validation scope, rewritten within its cap; a history note.
usage (from the checkout root, after texts_laws.py): python3 -B make_records_laws.py RECEIPT N"""
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
RECEIPT_ID, N = sys.argv[1], int(sys.argv[2])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
DEV = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou3f-activity-laws/laws'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
P = ROOT / 'theories/becoming/results/records/master-laws-on-the-grammar.json'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
gl = next(x for x in core['modules'] if x['module'] == 'Becoming.GrammarLaws')
mi = next(x for x in core['modules'] if x['module'] == 'Becoming.MapInstances')
for m, path in ((gl, 'GrammarLaws'), (mi, 'MapInstances')):
    assert not any(m['axiom_dependencies'].values()), path
    assert core['source_sha256'][f'Becoming.{path}'] == sha(f'{PKG}/Becoming/{path}.lean'), path
LAWS = ['Becoming.«迭之分»', 'Becoming.«迭之逆»', 'Becoming.«或有后则或迭»', 'Becoming.«迭则同一或及»', 'Becoming.«不穷则迭»']
WEB = ['Becoming.Web.reaches_onward', 'Becoming.Web.steps_advance']
assert set(LAWS) <= {d['name'] for d in gl['declarations']}
assert set(WEB) <= {d['name'] for d in mi['declarations']}

r = json.loads(P.read_text(encoding='utf-8'))
steps = r['laws'][7]
assert steps['en'].startswith('Steps counted.'), steps['en'][:30]
steps['en'] = steps['en'].rstrip() + (' Steps split as they compose, and steps read backward are steps of the converse; n steps '
                                      'end where they began or at what the start reaches. Where whatever is reached in fewer '
                                      'than n steps has a successor as far as can be refuted, n steps exist as far as can be '
                                      'refuted, and an unending line has steps of every length.')
steps['zh'] = steps['zh'].rstrip() + '步可分如其可接，逆读之步即逆缘之步；n 步止于其始，或止于其始之所及。凡少于 n 步所及者或有后，则 n 步或有；不穷之线有任意长之步。'
steps['declarations'] = steps['declarations'] + [x for x in LAWS if x not in steps['declarations']]
last = r['laws'][17]
assert last['en'].startswith("The models' laws of closure, return"), last['en'][:40]
END_EN, END_ZH = "a trace read as the grammar's steps.", '迹读为文法之步。'
assert last['en'].endswith(END_EN) and last['zh'].endswith(END_ZH), 'the last group has changed; re-read it'
last['en'] = last['en'][:-1] + ('; and an unending line reaching an occurrence at every later step, from its steps of every '
                                'length, k steps advancing the index by k.')
last['zh'] = last['zh'][:-1] + '；不穷之线于其后每一步皆有所及，出自其任意长之步，k 步则指标增 k。'
last['declarations'] = sorted(set(last['declarations']) | set(WEB))
refs = r['references']
gl_ref = next(x for x in refs if x['role'] == 'proof' and x['path'].endswith('/Becoming/GrammarLaws.lean'))
gl_ref['declarations'] = sorted(set(gl_ref['declarations']) | set(LAWS))
path = f'{PKG}/Becoming/MapInstances.lean'
assert not any(x['path'] == path for x in refs), path
at = max(i for i, x in enumerate(refs) if x['role'] == 'proof') + 1
refs.insert(at, {'path': path, 'role': 'proof', 'declarations': WEB, 'sha256': sha(path)})
r['proof_bindings'].append({'source': path, 'receipt': RECEIPT, 'sha256_pointer': '/source_sha256/Becoming.MapInstances',
                            'success_pointer': '/status', 'success_value': 'passed'})
refs.append({'path': f'{DEV}/DESIGN.md', 'role': 'integration', 'sha256': sha(f'{DEV}/DESIGN.md')})
refs.append({'path': f'{DEV}/REVIEW-LAWS.md', 'role': 'review', 'sha256': sha(f'{DEV}/REVIEW-LAWS.md')})
refs.append({'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)})
r['does_not_show'].append({
    'en': "That the models' lineage laws are proved from these laws of steps (Web.Lineage.split, through, onward, back, "
          "unique and origin): their bridge, from a lineage to the grammar's steps of a continuation restricted to active "
          "occurrences from a bound on, is OU3f's next part, with the derivations of the activity laws module by module.",
    'zh': 'Web.Lineage 诸律（split、through、onward、back、unique 与 origin）由此诸步之律证出：其桥接，自一 Lineage 至限于某界以后之活跃者之续之文法之步，'
          '为 OU3f 之下一部分，与诸只读活跃之律之推导逐模块同为。',
    'kind': 'non-implication'})
vs = r['validation_scope']
vs['en'] = (f"Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): Becoming.GrammarLaws, "
            f"{gl['theorems']} theorems in {len(gl['declarations'])} declarations, the 40 representation and bridge declarations "
            f"in fourteen model modules, and the derivations of OU3c, OU3e and OU3f in seven more, every axiom report empty, "
            f"all cited; every changed module's theorems keep their printed statements, but for the two relation laws moved "
            f"into the grammar at any universe. Read-only AI reviews, every finding taken: three of OU3b, one of OU3d with a "
            f"second pass, one each of OU3c, OU3e and OU3f; not reviewed by a person.")
vs['zh'] = (f"Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：Becoming.GrammarLaws，{len(gl['declarations'])} 项声明中 "
            f"{gl['theorems']} 条定理，十四个模型模块中 40 项表示与桥接声明，及另七模块中 OU3c、OU3e、OU3f 之推导，公理报告皆空，"
            f"本记录全引；诸改动模块之定理其所印陈述不变，唯移入文法之二关系律推广至任一宇宙。只读 AI 审查，所见皆采：OU3b 三次，"
            f"OU3d 一次并复审一遍，OU3c、OU3e、OU3f 各一次；未经人审。")
assert len(vs['en']) <= 600, len(vs['en'])
r['history'].append({
    'en': f"29 October 2026 (OU3f, study section {N}): laws of steps the grammar lacked, which the audit of the theorems "
          f"reading only activity found the lineage laws need, stated beside n steps before any of them bridges: steps "
          f"split as they compose and steps read backward, steps where successors are given as far as can be refuted, and "
          f"an unending line's steps of every length; the web lemma that an unending line reaches every later step proved "
          f"from the last (board rule 9), so the five activity laws resting on it reach the grammar.",
    'zh': f"2026年10月29日（OU3f，研究第 {N} 节）：文法所缺之步之律，即只读活跃之定理之审计所见 Lineage 诸律之所需，先于其桥接而置于 n 步之旁："
          f"步可分如其可接与逆读之步、后或有则步或有、不穷之线有任意长之步；不穷之线于其后每一步皆有所及之网之引理由末者证出（板规九），"
          f"故依之之五条活跃之律达于文法。"})
P.write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record extended; validation scope', len(vs['en']), 'chars')
