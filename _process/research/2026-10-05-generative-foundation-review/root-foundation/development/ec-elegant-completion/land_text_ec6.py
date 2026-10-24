#!/usr/bin/env python3
"""EC6's texts: the study section (from study_ec6.txt) appended to the study, and the chapter's master-law passage
(English and Chinese) extended with rest by balance and the new measure.
python3 -B land_text_ec6.py CORE_RECEIPT_ID STUDY_SECTION BASE   (from the checkout root)
The measure numbers are read from the measure's JSON outputs before.json (on BASE) and after.json (on the landed
sources), saved beside this script as measure-ec6-before.json and measure-ec6-after.json."""
import collections, json, re, sys
from pathlib import Path
ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
core_id, N, base = sys.argv[1], int(sys.argv[2]), sys.argv[3]
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
EN = ROOT / 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
ZH = ROOT / 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.zh.md'
before = json.loads((HERE / 'measure-ec6-before.json').read_text())
after = json.loads((HERE / 'measure-ec6-after.json').read_text())


def bylaw(r):
    c = collections.Counter()
    for row in r['rows']:
        for d in row['declarations']:
            for law in d['laws']:
                c[law] += 1
    return c


A = bylaw(after)
total = after['central_declarations']
none_after = after['resting_on_no_master_law']
on = total - none_after
gone = sorted(set(before['none']) - set(after['none']))
assert not set(after['none']) - set(before['none']), 'a declaration lost its master law'

# Study section.
study = STUDY.read_text()
last = max(int(m) for m in re.findall(r'^## (\d+)\. ', study, re.M))
assert N == last + 1, (N, last)
text = (HERE / 'study_ec6.txt').read_text()
text = (text.replace('@N@', str(N)).replace('@RECEIPT@', core_id).replace('@BASE@', base)
        .replace('@BEFORE@', str(before['resting_on_no_master_law'])).replace('@AFTER@', str(none_after))
        .replace('@BALANCE@', str(A['balance']))
        .replace('@NOTIONS_BEFORE@', str(before['defined_notions_in_central_statements']))
        .replace('@NOTIONS_AFTER@', str(after['defined_notions_in_central_statements']))
        .replace('@REST@', str(none_after - 5)))
assert '@' not in text, re.findall(r'@\w+@', text)
STUDY.write_text(study.rstrip('\n') + '\n\n' + text.rstrip('\n') + '\n')

link = (f'[study §{N}](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/'
        f'BECOMING-RENEWAL-READING.md#{N}-rest-by-balance-the-course-and-regime-series-as-its-cases-ec6)')

en = EN.read_text()
old_b = ('- *Balance* (`Flow.Balances`; over a stretch, `balance_over_stretch_on` in the prelude). A level changes by what '
         'is given and taken, at each step and over every stretch (§2.1–§2.3).\n')
assert en.count(old_b) == 1
new_b = old_b.rstrip('\n') + (
    ' In whole numbers it bounds how long a count can lose: balanced across each step and losing at least one more '
    "than it gains at each, a count falls by at least the number of steps, and two balanced counts compare by their "
    'exchanges (`Amounts.falls_by_stretch`, `Amounts.unmarked_within`, `Amounts.le_by_exchange`). The ending of a '
    "course above its renewal, the comparison of weighted draws, the rest of a law's run with a bounded mark, the fall "
    f"below a regime's point of no return and the rest of a coupled web are its cases ({link}).\n")
en = en.replace(old_b, new_b)
old_m = re.search(r'Of the 127 central declarations, 64 rest on at least one: closure 16, balance 39, finite runs 14, '
                  r'lumping 1 and order 9\. The report lists the other 63,', en)
assert old_m
en = en.replace(old_m.group(0),
                f'Of the {total} central declarations, {on} rest on at least one: closure {A["closure"]}, balance '
                f'{A["balance"]}, finite runs {A["return"]}, lumping {A["lumping"]} and order {A["order"]}. The report '
                f'lists the other {none_after},')
EN.write_text(en)

zh = ZH.read_text()
old_zb = '- *平衡*（`Flow.Balances`；跨段时为序言中的 `balance_over_stretch_on`）。水平按所给与所取而变，每一步如此，每一段亦然。\n'
assert zh.count(old_zb) == 1
zh_link = link.replace(f'study §{N}', f'研究第 {N} 节')
zh = zh.replace(old_zb, old_zb.rstrip('\n') + (
    '在整数中，它限定一个计数能失去多久：每步平衡、每步所失比所得至少多一的计数，至少下降所经的步数；两个平衡的计数由其交换相比较'
    '（`Amounts.falls_by_stretch`、`Amounts.unmarked_within`、`Amounts.le_by_exchange`）。过程在更新之上的终结、加权汲取的比较、'
    f'带有界标记的律之运行的静止、体制不归点之下的下降与耦合网的静止，都是它的情形（{zh_link}）。\n'))
old_zm = '127 个中心声明中有 64 个至少依于一条主律；其余 63 个列于报告，'
assert zh.count(old_zm) == 1
zh = zh.replace(old_zm, f'{total} 个中心声明中有 {on} 个至少依于一条主律；其余 {none_after} 个列于报告，')
ZH.write_text(zh)
print('study', N, 'measure', before['resting_on_no_master_law'], '->', none_after, dict(A), 'moved', len(gone))
