#!/usr/bin/env python3
"""LU1's text: chapter section 9 bullet, T7's standing and the relation to known results (EN, ZH), and the
significance review's observation check. usage: python3 -B apply_text.py   (from the checkout root; each edit once)"""
from pathlib import Path

ROOT = Path.cwd()
EN = ROOT / 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
ZH = ROOT / 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.zh.md'
REV = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-SIGNIFICANCE-REVIEW.md'
CHECK = '../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-SIGNIFICANCE-REVIEW.md#endogenous-observation-check'


def edit(path, pairs):
    s = path.read_text(encoding='utf-8')
    for old, new in pairs:
        assert s.count(old) == 1, (path.name, old[:90], s.count(old))
        s = s.replace(old, new)
    path.write_text(s, encoding='utf-8')


edit(EN, [
    ("courses from starts alike in share and rule stay alike in both at every step (`unread_course`), and the share's "
     "law joined",
     "courses from starts alike in share and rule stay alike in both at every step (`unread_course`), and exactly "
     "then along every schedule (`courses_alike_iff_unread`): this is the law of a part read alone "
     "(`Law.part_identifiesAlike_iff_step`) on the two-level step, what the loop reads making sense by itself exactly "
     "where nothing beyond the share is read (`identifiesAlike_iff_unread`); and the share's law joined"),
    ("- *Standing.* Proved in the model (`ClosedCapture.unread_course`, `ClosedCapture.lock_outlives_loss`, "
     "`ClosedCapture.turned_by_loss`, `ClosedCapture.readers_uniform_locks`, `RuleCapture.uniform_locks`). That actual "
     "metrics are formed from the share they select is conjectured. Neighbours: Goodhart (1975) and Campbell (1979) on "
     "measures that become targets; self-confirming equilibrium (Fudenberg and Levine 1993);",
     "- *Standing.* Proved in the model (`ClosedCapture.unread_course`, `ClosedCapture.lock_outlives_loss`, "
     "`ClosedCapture.turned_by_loss`, `ClosedCapture.readers_uniform_locks`, `RuleCapture.uniform_locks`). Its first "
     "half is the one law of lumping that also settles what a learner can identify and what a selection reaches: a "
     "loss the loop does not read changes nothing it does exactly where share and rule make sense by themselves "
     "(`ClosedCapture.identifiesAlike_iff_unread`, `ClosedCapture.courses_alike_iff_unread`), and a reader formed "
     "within the run is a reading of the run, with no outside reader. That actual "
     "metrics are formed from the share they select is conjectured. Neighbours: Goodhart (1975) and Campbell (1979) on "
     "measures that become targets; observability in supervisory control, with the reader inside the plant a reading "
     "of the joined whole (Wakaiki, Tabuada and Hespanha 2019, Theorem 4.1); a corrupted reward channel, where a "
     "consistent corruption is indistinguishable from none and a reading the loop does not form is the way out "
     "(Everitt, Krakovna, Orseau and Legg 2017, Theorems 11 and 19); closed-loop identifiability (Borkar and Varaiya "
     "1979) and self-confirming equilibrium (Fudenberg and Levine 1993) ([observation check](" + CHECK + "));"),
    ("`Web.break_not_bounded` holds because the stock is unobserved by hypothesis, and where it is observed the break "
     "can be seen coming (§3.4).",
     "`Web.break_not_bounded` holds because the stock is unobserved by hypothesis, and where it is observed the break "
     "can be seen coming (§3.4); capture through the rule and the closed loop (§4.5, T7) are observability under a "
     "reading of the joined whole, the reader inside the plant (Wakaiki, Tabuada and Hespanha 2019), the corrupted "
     "reward channel (Everitt et al. 2017) and closed-loop identifiability (Borkar and Varaiya 1979), with "
     "`ClosedCapture.Unread` exactly the law of a part read alone (`ClosedCapture.identifiesAlike_iff_unread`); a "
     "reading shaped by what it selects is neither harder than a bounded exogenous attack on the reading nor bounded by "
     "one, since what decides is what the reading lumps ([observation check](" + CHECK + ")).")])

edit(ZH, [
    ("- *地位。* 在模型中已证（`ClosedCapture.unread_course`、`ClosedCapture.lock_outlives_loss`、`ClosedCapture.turned_by_loss`、"
     "`ClosedCapture.readers_uniform_locks`、`RuleCapture.uniform_locks`）。",
     "- *地位。* 在模型中已证（`ClosedCapture.unread_course`、`ClosedCapture.lock_outlives_loss`、`ClosedCapture.turned_by_loss`、"
     "`ClosedCapture.readers_uniform_locks`、`RuleCapture.uniform_locks`）。其前一半就是同一条归并之律，它也决定学习者能辨识什么、"
     "选择能达到什么：回路不读的损失不改变它所做的任何事，恰在份额与规则自身成立之时（`ClosedCapture.identifiesAlike_iff_unread`、"
     "`ClosedCapture.courses_alike_iff_unread`）；在进程之内形成的读者是对进程的一种读取，没有外在的读者。"),
    ("自我确认均衡（Fudenberg 与 Levine 1993）；表现性稳定（Perdomo 等 2020）；路径依赖（Arthur 1989）。",
     "监督控制中的可观测性，读者在受控对象之内时是对合并整体的读取（Wakaiki、Tabuada 与 Hespanha 2019，定理 4.1）；"
     "被污染的奖励通道，一致的污染与没有污染无法区分，而回路不形成的读取是出路（Everitt、Krakovna、Orseau 与 Legg 2017，定理 11 与 19）；"
     "闭环可辨识性（Borkar 与 Varaiya 1979）；自我确认均衡（Fudenberg 与 Levine 1993）；表现性稳定（Perdomo 等 2020）；路径依赖（Arthur 1989）"
     "（[观测检查](" + CHECK + ")）。"),
    ("`Web.break_not_bounded` 成立是因为按假设存量不被观察，存量被观察之处断裂可以预先看到（§3.4）。",
     "`Web.break_not_bounded` 成立是因为按假设存量不被观察，存量被观察之处断裂可以预先看到（§3.4）；经规则的捕获与闭合的回路"
     "（§4.5，T7）是对合并整体之读取下的可观测性，读者在受控对象之内（Wakaiki、Tabuada 与 Hespanha 2019）、被污染的奖励通道"
     "（Everitt 等 2017）与闭环可辨识性（Borkar 与 Varaiya 1979），`ClosedCapture.Unread` 恰是单独读一部分之律"
     "（`ClosedCapture.identifiesAlike_iff_unread`）；被其所选塑造的读取既不比对读取的有界外来攻击更难，也不受其界限，"
     "因为决定者是读取所归并的（[观测检查](" + CHECK + ")）。")])

edit(REV, [
    ("What the spine adds is the statement with no premise beyond what each theorem names and with empty axiom reports, "
     "as the oversight check found for the selection laws.",
     "What the spine adds is the statement with no premise beyond what each theorem names and with empty axiom reports, "
     "as the oversight check found for the selection laws. Since board item LU1 (21 October 2026) the first of these is "
     "proved to be the spine's own law of lumping: `ClosedCapture.Unread` holds exactly where what the loop reads "
     "makes sense by itself along every schedule (`ClosedCapture.identifiesAlike_iff_unread`, from "
     "`Law.now_identifiesAlike_iff_goAlike`), and courses alike in share and rule stay alike exactly then "
     "(`ClosedCapture.courses_alike_iff_unread`), `unread_course` now derived from `Law.sameFuture_of_goAlike`. So the "
     "capture laws, the learning laws and the selection gap are one law at the spine's level, as point 1 of the "
     "reduction says they are in supervisory control."),
    ("**For integration (not done here).** LK1's relation-to-known-results section could cite",
     "**For integration (done by LU1, 21 October 2026, in T7's standing and the relation to known results).** LK1's "
     "relation-to-known-results section could cite")])
print('text applied')
