#!/usr/bin/env python3
"""WL3 texts: the study section (appended), the WENLI-AND-BECOMING fragments (a bullet in the head's 建成了什么 and a
paragraph in §一 after 律 4; the chapter is then rebuilt with wenli/make_chapter.py and build_tables.py), and the board
row's state. Every edit adds lines.
usage (from the checkout root, after the core checker): python3 -B apply_text.py STUDY_SECTION RECEIPT"""
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
N, RECEIPT = int(sys.argv[1]), sys.argv[2]
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = ROOT / (RF + 'BECOMING-RENEWAL-READING.md')
WL = ROOT / (RF + 'development/zhonghua/wenli')
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
R = json.loads((ROOT / PKG / 'becoming-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed'
M = next(m for m in R['modules'] if m['module'] == 'Becoming.GrammarCourse')
assert not any(M['axiom_dependencies'].values())
THEOREMS, DECLS = M['theorems'], len(M['declarations'])
ANCHOR = f'#{N}-文-in-the-grammar-of-continuation-wl3'
SLINK = '../../../' + RF + 'BECOMING-RENEWAL-READING.md' + ANCHOR
MLINK = '../../../' + RF + 'development/wl3-wen-grammar/MAPPING.md'
REC = '../results/records/wen-in-the-grammar.md'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:60], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


# --- the study
s = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in s and '(WL3)' not in s
last = max(int(x) for x in re.findall(r'^## (\d+)\. ', s, flags=re.M))
assert last == N - 1, (last, N)
section = (HERE / 'study_wl3.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace(
    '{RECEIPT}', RECEIPT).replace('{THEOREMS}', str(THEOREMS)).replace('{DECLS}', str(DECLS))
STUDY.write_text(s.rstrip('\n') + '\n\n' + section.rstrip('\n') + '\n', encoding='utf-8')

# --- the chapter's head: what was built
head_old = '- 两项检验的设计：H2 的一个阅读试验，还没有运行；一个忠实之测，已运行（看板项 FC1，见「怎样检验」）。\n'
head_new = head_old + (
    f'- 文入续之文法（看板项 WL3，[研究第 {N} 节]({SLINK})）：文同即象之值之类之核，文之状即其沿步之核，有界之律与可知经核而述'
    f'（`Becoming.GrammarCourse`，见第一部分 §一「文入续之文法」）。\n')
edit(WL / 'head.fragment', head_old, head_new)

# --- the chapter's §一, after 律 4
centre_old = ('   - `Becoming.Law.sameFuture_iff_within`：法之下，一族之状闭于此法时，族中二状文同，恰当其文于族之员数减一步之前皆同；'
              '不须判定值之同异。\n')
centre_new = centre_old + f"""
**文入续之文法（WL3；讀，AI）。** 一元之根（看板项 OU）以续为中心，陈述于每一载体、每一关系（`Becoming.Grammar`）：续是缘与一类相合（`«续» R E`），一类于缘有常（`«有常» R E`）则其续不尽，一类之核（`«核» R E`）是类之内于缘有常之最大对称关系（`«根»`）。文同与文之状，就是这一文法在法与象上之核（[研究第 {N} 节]({SLINK})，记录 [wen-in-the-grammar]({REC})，逐项对照见[对照研究]({MLINK})）：

- 以法之步为缘（`Becoming.Law.step`），以象之值同为类（`Becoming.sameValue`）：一关系于步有常，恰当法守之（`Becoming.Law.constant_iff_keeps`）。
- 文同恰是此类之核（`Becoming.Law.core_is_sameFuture`），也恰是法经象所示之系辞中之同（`Becoming.Law.alike_iff_core`）。所以 `Becoming.Law.sameFuture_coarsest` 是根之定理在法上之读；守值载法之类，含核恰当它就是核（`Becoming.Law.coarsest_iff_core`）：守值之理中最粗者即值之类之核，较细之守值之理皆在核内。
- 文之二步为一状，恰当它们在此文沿步之核之一类中（`Becoming.SameAhead.is_core`）；状依自身而行，即核之有常（`Becoming.SameAhead.next_by_root`）；沿法之轨，步之核即状之核（`Becoming.course_core_iff`）。每步之值皆新之文，于其核下无续（`Becoming.SameAhead.no_continuation`），是火之例（`«以核为判据则火无续»`）在文上之形。
- 一步于核下续至次步，恰当自此于值之类下之续不尽，即自此文恒定（`Becoming.Law.continues_in_core_iff`、`Becoming.Law.unending_iff`）；值之类自身有常，恰当它即其核，此时一文守其值一步则永守之（`Becoming.Law.constant_iff_core`、`Becoming.Law.stays_of_constant`）。
- 律 4 经核而述：状不过 N 种，即核不过 N 类（`Becoming.statesBelow_iff_core`），核读自 N＋N－1 步（`Becoming.core_iff_below`、`Becoming.Law.core_iff_below`）；二文合为一网，其首步在核之一类中，恰当二文自此皆同，状各不过 N、N′ 种时即 N＋N′－1 步前皆同，此长确切（`Becoming.TwoCourses.core_iff_bounded`、`Becoming.TwoCourses.core_exact`）。可知亦经核而述（`Becoming.Law.learnable_iff_core`、`Becoming.Law.learnable_of_core_within`）。
- 所异：文同与状属文法之理（核），不属其续：值之类下之续只是守值之一步。文之类皆是象之值之同，文法之类是任一等价；Arising 与 Change 之二值之类（以 ↔ 比较）非其例，须 `propext`。法之缘是函数，不定之变之衢不读作可能之网。往、界之数、知来与「自某步起」，文法皆无，在核旁陈述。
"""
edit(WL / 'centre.fragment', centre_old, centre_new)
print('STUDY_SECTION', N)
print('applied: study section', N, 'and the WENLI fragments;', THEOREMS, 'theorems in', DECLS, 'declarations')
