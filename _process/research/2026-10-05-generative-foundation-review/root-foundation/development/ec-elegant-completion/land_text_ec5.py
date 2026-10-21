#!/usr/bin/env python3
"""EC5 landing text (docs and tools, no Lean): the chapter's preface states the master laws (EN, ZH) with the counts the
connectivity measure records (THEOREM-CONNECTIVITY.json, master_laws); the study section; the board row.
usage (from the checkout root, after THEOREM-CONNECTIVITY.py --write and research-render): python3 -B land_text_ec5.py
Prints the study section number."""
import json, re, sys
from pathlib import Path
ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
CONN = '_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY.json'
CH = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
ZH = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.zh.md'
BOARD = '_process/BECOMING-WORKBOARD.md'
m = json.loads((ROOT / CONN).read_text())['master_laws']
T, NONE = m['central_declarations'], m['resting_on_no_master_law']
ON, BY = T - NONE, m['by_law']
stext = (ROOT / STUDY).read_text(encoding='utf-8')
N = max(int(x) for x in re.findall(r'^## (\d+)\. ', stext, re.M)) + 1
SLUG = f'{N}-the-master-laws-stated-and-measured-ec5'
SA = f'../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{SLUG}'


def edit(path, old, new):
    p = ROOT / path
    t = p.read_text(encoding='utf-8')
    assert t.count(old) == 1, (path, old[:80])
    p.write_text(t.replace(old, new), encoding='utf-8')
    print('edited', path)


EN_ANCHOR = ('None of the ten is new mathematics: each is near-definitional or a known result restated in the theory\'s '
             'vocabulary, and [the relation to known results](#relation-to-known-results) names the closest prior result of each.\n')
EN = EN_ANCHOR + f'''
<a id="master-laws"></a>
**The master laws.** Five laws are each stated once, at the lowest layer that holds them, and the central results that rest on one are proved through it rather than beside it (board item EC, [study §{N}]({SA})):
- *Closure* (`WithinClosure`, in the frame). What a relation carries reaches exactly its closure, and nothing within a closure bears the relation to what lies beyond it. A process's reach is the closure of its steps (`reach_iff_withinClosure`). Feeding, influence, reach, the system, coupling and pooled coupling are this closure under their relations (§2.5, §3.4), and so is the scope that the two neutralities force (`Valuation.forced_iff_reach`, §6.5).
- *Balance* (`Flow.Balances`; over a stretch, `balance_over_stretch_on` in the prelude). A level changes by what is given and taken, at each step and over every stretch (§2.1–§2.3).
- *Finite runs* (`Branching.Returns`, `revisits_within`; rest, `Amounts.rests`). Within finitely many configurations a law returns every configuration or is drawn, and rest comes where an amount's falls stop (`Amounts.FallsStop`; §1.2, §1.3).
- *Lumping* (`GoAlikeUnder`). A part read alone carries a law exactly where the rest makes no difference to its next value. Learning, selection's reach and capture are its cases (§3.3, §3.4).
- *Order* (`Web.Widens`; on a listing, `Weighting.WidensOn`). Widening is retaining and adding (§6.1). The ethics adds its two premises here:
  - the continuation condition, for scope, read as the claim that the relation carrying significance connects everything living (`Valuation.forced_whole_iff_connected`);
  - C, for order (§6.4, §6.5).

The connectivity measure counts, at each landing, the laws among each central declaration's compiled reasons ([completion report](../results/completion/COMPLETION.md#master-laws)). Of the {T} central declarations, {ON} rest on at least one: closure {BY['closure']}, balance {BY['balance']}, finite runs {BY['return']}, lumping {BY['lumping']} and order {BY['order']}. The report lists the other {NONE}, each either definitional or a law not yet derived through a master law. They are what an elegant completion still has to derive or show to be definitional; elegance is not a criterion of K1–K7.
'''
edit(CH, EN_ANCHOR, EN)
ZH_ANCHOR = '这十项都不是新的数学：每项或近乎定义，或是已知结果在本理论词汇中的重述；'
z = (ROOT / ZH).read_text(encoding='utf-8')
i = z.index(ZH_ANCHOR)
j = z.index('\n', i) + 1
ZH_TEXT = f'''
**主律。** 五条律各只陈述一次，置于能容纳它的最低一层；依于其中一条的中心结果经它证明，而不在其旁另证（工作项 EC，[研究第 {N} 节]({SA})）。
- *闭包*（`WithinClosure`，在框架中）。一个关系所带的恰及于其闭包，闭包之内无物以此关系通向其外。过程的所及即其步的闭包。供给、影响、所及、系统、耦合与合池的耦合都是各自关系下的这一闭包，两种中立所迫出的范围也是（`Valuation.forced_iff_reach`）。
- *平衡*（`Flow.Balances`；跨段时为序言中的 `balance_over_stretch_on`）。水平按所给与所取而变，每一步如此，每一段亦然。
- *有限的运行*（`Branching.Returns`、`revisits_within`；停息，`Amounts.rests`）。在有限多个构形之内，律或使每个构形返回，或被吸引；停息在量的下降停止之处到来（`Amounts.FallsStop`）。
- *归并*（`GoAlikeUnder`）。单独读出的部分恰在其余对其下一值不造成差别之处带有一条律。学习、选择之所及与俘获都是其情形。
- *次序*（`Web.Widens`；在列举上，`Weighting.WidensOn`）。扩大是保持并增添。伦理在此加上两个前提：延续条件，为范围，读作承载意义的关系连通一切存活者（`Valuation.forced_whole_iff_connected`）；C，为次序。

连通度量在每次落地时，对每个中心声明的编译依据计入其中的主律（[完成报告](../results/completion/COMPLETION.md#master-laws)）。{T} 个中心声明中有 {ON} 个至少依于一条主律；其余 {NONE} 个列于报告，或属定义层面，或尚未经主律导出。它们是一个优雅的完成仍须导出或表明为定义的；优雅不是 K1–K7 的判据。
'''
(ROOT / ZH).write_text(z[:j] + ZH_TEXT + z[j:], encoding='utf-8')
print('edited', ZH)
study = (HERE / 'study_ec5.txt').read_text(encoding='utf-8').replace('@N@', str(N)).replace('@T@', str(T)).replace(
    '@ON@', str(ON)).replace('@NONE@', str(NONE)).replace('@BY@', ', '.join(f'{k} {v}' for k, v in BY.items()))
(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
b = (ROOT / BOARD).read_text(encoding='utf-8')
i = b.index('| **EC: an elegant completion**')
row = b[i:b.index('\n', i) + 1]
old = 'EC5 the statement and the measure in the connectivity run, each claimed here before its Lean'
assert row.count(old) == 1, row[-400:]
new_row = row.replace(old, f'**EC5 landed** (the master laws stated in the chapter\'s preface, EN and ZH; the measure in the connectivity run and the completion report; {ON} of {T} central declarations on at least one master law; study §{N}); the remaining {NONE}, listed in the report, are the next steps, each claimed here before its Lean')
new_row = new_row.replace('; open for EC3 and EC5 |', f'; EC5 landed 2026-10-21 (study §{N}); open for EC3 and the remaining declarations |')
b = b.replace(row, new_row)
assert b.count('- **Queue:** ') == 1
b = b.replace('- **Queue:** ', f'- **Queue:** EC5 landed (docs and tools, no checker run: the master laws in the chapter\'s preface, the measure in the connectivity run and the completion report, study §{N}); ')
(ROOT / BOARD).write_text(b, encoding='utf-8')
print('board row updated')
print('STUDY_SECTION', N)
