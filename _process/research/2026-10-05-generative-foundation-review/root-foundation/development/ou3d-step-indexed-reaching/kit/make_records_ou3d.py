#!/usr/bin/env python3
"""OU3d record: extend master-laws-on-the-grammar with a group of steps counted after the group of steps (the last
step, within n steps and its composition, a step or staying, what every condition held, and the two laws of taking
on); the GrammarLaws proof reference gains the eight declarations; the design and the review as integration and
review references; the receipt; one does-not-show item (the models' step-indexed laws are not yet proved from these);
the validation scope's counts from the receipt; a history note. The re-pointing that follows (repoint --drift-json
with --receipt and --lean) rebinds the existing references.
usage (from the checkout root, after texts_ou3d.py): python3 -B make_records_ou3d.py RECEIPT N"""
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
RECEIPT_ID, N = sys.argv[1], int(sys.argv[2])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
DEV = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou3d-step-indexed-reaching'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
P = ROOT / 'theories/becoming/results/records/master-laws-on-the-grammar.json'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
gl = next(x for x in core['modules'] if x['module'] == 'Becoming.GrammarLaws')
assert not any(gl['axiom_dependencies'].values())
assert core['source_sha256']['Becoming.GrammarLaws'] == sha(f'{PKG}/Becoming/GrammarLaws.lean')
NEW = ['Becoming.«迭之末步»', 'Becoming.«迭内»', 'Becoming.«迭内之接»', 'Becoming.«静或缘»', 'Becoming.«迭内即静或缘之迭»',
       'Becoming.«承»', 'Becoming.«承之迭»', 'Becoming.«存承之迭»']
names = {d['name'] for d in gl['declarations']}
assert set(NEW) <= names, set(NEW) - names

r = json.loads(P.read_text(encoding='utf-8'))
steps = r['laws'][6]
assert steps['en'].startswith('Steps: the successor fixed'), steps['en'][:40]
assert not any('«迭内»' in d for g in r['laws'] for d in g['declarations'])
r['laws'].insert(7, {
    'en': 'Steps counted. n + 1 steps are n steps and then the last. Within m steps and then within n is within m + n, and '
          'within n steps is n steps each of which stays or steps. A course of regions each of whose rounds holds exactly what '
          'every condition held at the round before holds at round n exactly where everything reaching in n steps held '
          'at the start: n rounds of taking on along a relation are one taking on along its n steps. With memory, each '
          'round also keeping what it held, it holds exactly where everything reaching within n steps held, the law '
          'without memory under staying or a step.',
    'zh': '计步：n+1 步即 n 步而后一步。m 步以内而后 n 步以内，即 n+m 步以内；n 步以内即「静或缘」之 n 步。区域之程，'
          '每轮恰持前一轮诸缘皆持者，则第 n 轮恰持于凡 n 步及之者始皆持之处：沿一关系承 n 轮，即沿其 n 步承一次。'
          '有记忆者，每轮兼存其所持，则恰持于凡 n 步以内及之者皆持之处，即「静或缘」下无记忆之律。',
    'declarations': NEW})

refs = r['references']
gl_ref = next(x for x in refs if x['role'] == 'proof' and x['path'].endswith('/Becoming/GrammarLaws.lean'))
gl_ref['declarations'] = sorted(set(gl_ref['declarations']) | set(NEW))
refs.append({'path': f'{DEV}/DESIGN.md', 'role': 'integration', 'sha256': sha(f'{DEV}/DESIGN.md')})
if (ROOT / f'{DEV}/REVIEW-OU3d.md').exists():
    refs.append({'path': f'{DEV}/REVIEW-OU3d.md', 'role': 'review', 'sha256': sha(f'{DEV}/REVIEW-OU3d.md')})
refs.append({'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)})

r['does_not_show'].append({
    'en': "That the models' step-indexed laws are proved from the laws of steps counted (Withholding.answers_closed, "
          "Withholding.waitsAll_closed and withholding_spreads, Tolerance.answers_restores_iff, "
          "WithinMoves.after_course): their bridges, from a chain of waits and a trace to the grammar's steps, are a "
          "second step, with those modules' owners; a law's run is already a course whose rounds hold by definition.",
    'zh': '诸模型之计步之律由计步之律证出（Withholding.answers_closed、Withholding.waitsAll_closed 与 withholding_spreads、'
          'Tolerance.answers_restores_iff、WithinMoves.after_course）：其桥接（待之链与迹至文法之步）为第二步，与诸模块之主同为；'
          '律之运行本即区域之程，其轮依定义而成。',
    'kind': 'non-implication'})

vs = r['validation_scope']
vs['en'] = (f"Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): Becoming.GrammarLaws, "
            f"{gl['theorems']} theorems in {len(gl['declarations'])} declarations, the 40 representation and bridge "
            f"declarations in fourteen model modules, and OU3c's derivations in four more, every axiom report empty, all "
            f"cited. Read-only AI reviews, every finding taken: three of OU3b (study section 417), one of OU3c (433), "
            f"one of OU3d ({N}); not reviewed by a person.")
vs['zh'] = (f"Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：Becoming.GrammarLaws，{len(gl['declarations'])} 项声明中 "
            f"{gl['theorems']} 条定理，十四个模型模块中 40 项表示与桥接声明，及另四模块中 OU3c 之推导，公理报告皆空，本记录全引。"
            f"只读 AI 审查，所见皆采：OU3b 三次（研究第 417 节），OU3c 一次（第 433 节），OU3d 一次（第 {N} 节）；未经人审。")
assert len(vs['en']) <= 600, len(vs['en'])
r['history'].append({
    'en': f"28 October 2026 (OU3d, study section {N}): steps counted on the grammar, beside n steps: the last step, "
          f"within n steps and its composition, and the laws of taking on without memory and with, the closed forms of "
          f"the models' step-indexed laws, stated before any of them bridges to them.",
    'zh': f"2026年10月28日（OU3d，研究第 {N} 节）：于文法上计步，置于 n 步之旁：末一步、n 步以内及其接、无记忆与有记忆之承之律，"
          f"即诸模型计步之律之闭式，先于其桥接而立。"})
P.write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record extended: steps counted,', len(NEW), 'declarations; validation scope', len(vs['en']), 'chars')
