#!/usr/bin/env python3
"""Join RS1's module Becoming.ReadingSchedule to the core package: copy it in, import it after Becoming.Regulation, add
its root doc bullet after Regulation's, its CORE entry and scope text in check_becoming.py, and its README rows (EN
after Regulation's, ZH before RegimeMargin's, the Chinese table having no Regulation row).
usage: python3 -B integrate.py   (RS1_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['RS1_ROOT']).resolve() if os.environ.get('RS1_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


shutil.copyfile(HERE / 'tree' / 'Becoming' / 'ReadingSchedule.lean', PKG / 'Becoming' / 'ReadingSchedule.lean')

DOC = (
    '* `Becoming.ReadingSchedule` (L1): one reader, several conditions. A schedule reads one\n'
    '  condition a step, and a drawer on a condition is withdrawn `ℓ` steps after a step that reads\n'
    '  it: the selection only withdraws. With `(a + ℓ) d ≤ m < (a + 1 + ℓ) d`, a schedule keeps a\n'
    '  condition within the margin `m` against every balanced flow\'s draws of at most `d` a step\n'
    '  exactly where it reads the condition within every `a` steps (one side the margin law, the\n'
    '  other a witness drawer). Over every `P` steps the windows\' counts `q c` with `q c a c ≤ P`\n'
    '  total at most `P` (`k` readers: `P k`); windows 2, 3 and any `M` are never read together,\n'
    '  though for `M ≥ 7` a share `1/6 - 1/M` of the reader is idle; windows with reciprocals\n'
    '  summing to at most one half are read by one schedule, a dyadic code built from Kraft\'s\n'
    '  inequality, two readers interleaved being one at half speed. Pinwheel scheduling read as a\n'
    '  selection that only withdraws; the five-sixths threshold is cited, not proved.\n'
)
SCOPE = (
    '    "ReadingSchedule: a schedule keeps a condition within the margin m against every balanced "\n'
    '    "flow\'s draws of at most d a step, on that condition alone and withdrawn l steps after a step "\n'
    '    "at or after the draw\'s start that reads it, exactly where it reads it within every a steps, "\n'
    '    "for (a + l) d <= m < (a + 1 + l) d, several conditions kept at once by the margin law and "\n'
    '    "a stretch left unread losing what lies beyond the margin; over P steps the counts q c of "\n'
    '    "windows a c with q c a c <= P total at most P, and P k for readers naming k a step; no "\n'
    '    "schedule reads three conditions within 2, 3 and M steps, for every M, though for M >= 7 the "\n'
    '    "counts over 6 M steps total 5 M + 6; two schedules interleaved read within twice their "\n'
    '    "windows, a binary code reads a condition at depth k within 2^k steps, items with Kraft weights "\n'
    '    "at most 2^D are all read by one code, and windows with whole weights 2^(D+1) <= q c a c "\n'
    '    "totalling at most 2^D are read by one schedule and kept. "\n')
README_ROW = (
    '| L1 | [`Becoming.ReadingSchedule`](Becoming/ReadingSchedule.lean) | one reader, several conditions: pinwheel '
    'scheduling read as a selection that only withdraws (no premise beyond what each theorem names; balance, the draw '
    'bound, the start and the withdrawal `ℓ` steps after a reading are hypotheses where they enter): a schedule keeps a '
    'condition within its margin exactly where it reads it within its window (`ReadingSchedule.keeps_iff_within`, from '
    '`Flow.Balances.retains_of_read` and the witness `ReadingSchedule.within_of_keeps`), and a stretch left unread '
    'loses what lies beyond the margin (`Flow.Balances.loses_of_unread`); the windows\' counts fit the steps '
    '(`ReadingSchedule.density`, pools `ReadingSchedule.pool_density`, on the base `ReadingSchedule.keeps_density`); '
    'windows 2, 3 and any `M` are never read together, with room to spare (`ReadingSchedule.no_two_three`, '
    '`ReadingSchedule.spare_not_enough`); half a reader suffices, by a dyadic code from Kraft\'s inequality '
    '(`ReadingSchedule.kraft_reads`, `ReadingSchedule.half_suffices`, `ReadingSchedule.keeps_of_half`) |')
README_ZH_ROW = (
    '| L1 | [`Becoming.ReadingSchedule`](Becoming/ReadingSchedule.lean) | 一个读者，多个条件：把轮转调度（pinwheel scheduling）'
    '读作只撤回的选择（除各定理所列外不加前提；平衡、每步汲取的上界、起点与读到后 `ℓ` 步撤回，均为写在定理中的条件）：'
    '日程恰在每个窗口内读到一个条件时，才使它保持在余量之内（`ReadingSchedule.keeps_iff_within`），未被读到的一段失去余量之外者'
    '（`Flow.Balances.loses_of_unread`）；各窗口所需的读数不超过步数（`ReadingSchedule.density`、`ReadingSchedule.pool_density`、'
    '`ReadingSchedule.keeps_density`）；窗口 2、3 与任何 `M` 永远不能同时读到，尽管尚有空闲（`ReadingSchedule.no_two_three`、'
    '`ReadingSchedule.spare_not_enough`）；半个读者即足够，由 Kraft 不等式的二进码构成（`ReadingSchedule.kraft_reads`、'
    '`ReadingSchedule.half_suffices`、`ReadingSchedule.keeps_of_half`） |')

root = (PKG / 'Becoming.lean').read_text()
assert 'import Becoming.ReadingSchedule' not in root, 'already integrated'
root = once(root, 'import Becoming.Regulation\n', 'import Becoming.Regulation\nimport Becoming.ReadingSchedule\n')
root = once(root, '* `Becoming.RegimeMargin` (L1): the margin of a regime,',
            DOC + '* `Becoming.RegimeMargin` (L1): the margin of a regime,')
(PKG / 'Becoming.lean').write_text(root)

chk = (PKG / 'check_becoming.py').read_text()
chk = once(chk, '"Becoming.Regulation", "Becoming.RegimeMargin"',
           '"Becoming.Regulation", "Becoming.ReadingSchedule", "Becoming.RegimeMargin"')
chk = once(chk, '    "Loops: the amount carried by routes of at most j responses rises with j to the carried "\n',
           SCOPE + '    "Loops: the amount carried by routes of at most j responses rises with j to the carried "\n')
(PKG / 'check_becoming.py').write_text(chk)

for name, row, anchor, after in (
        ('README.md', README_ROW, '| L1 | [`Becoming.Regulation`](Becoming/Regulation.lean) |', True),
        ('README.zh.md', README_ZH_ROW, '| L1 | [`Becoming.RegimeMargin`](Becoming/RegimeMargin.lean) |', False)):
    rd = (PKG / name).read_text()
    lines = rd.split('\n')
    idx = [i for i, l in enumerate(lines) if l.startswith(anchor)]
    assert len(idx) == 1, (name, idx)
    at = idx[0] + 1 if after else idx[0]
    lines[at:at] = [row]
    (PKG / name).write_text('\n'.join(lines))
print('integrated')
