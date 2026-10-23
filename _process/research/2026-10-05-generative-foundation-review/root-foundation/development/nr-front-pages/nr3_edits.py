"""NR, third round: the front pages after GS2 (the continuation condition on the root, 07 §4.5).

Exact replacements that must match once, applied to HEAD's text. Run from the repository root:
python3 nr3_edits.py [--check].
"""
import sys
from pathlib import Path

ROOT_EN = "[07 §4.5](chapters/07-SIGNIFICANCE.md#r-the-continuation-condition-on-the-root)"

EDITS = {
    'theories/becoming/ONE-PAGE.md': [
        ("it holds exactly where every center's closure along that relation is the whole. What the represented dynamics leave open is which relation is a center's own;",
         "it holds exactly where every center's closure along that relation is the whole, which on the root is the condition that nothing lies outside every center's line under the full class of that relation. What the represented dynamics leave open is which class a center's own line runs under;"),
        ("- The root and the ethics are not yet one account: the continuation condition is stated on its own formalism, not on continuation.",
         "- The root and the ethics are one account only in part: held de se along a relation, the continuation condition is the root's condition that nothing lies outside every center's line under the full class of that relation, and along a net with no cycle it holds only with one center ([significance](chapters/07-SIGNIFICANCE.md#r-the-continuation-condition-on-the-root)). The free significance is not lifted onto the root, and which class a center's own line runs under is open."),
    ],
    'theories/becoming/ONE-PAGE.zh.md': [
        ("它恰在每一个中心沿该关系的闭包都是整体之处成立。所表示的动力学让什么保持开放，是哪一个关系是一个中心自己的；",
         "它恰在每一个中心沿该关系的闭包都是整体之处成立；在根上，这就是：在该关系的全类之下，没有任何东西位于每一个中心的相续之外。所表示的动力学让什么保持开放，是一个中心自己的相续在哪个类之下进行；"),
        ("- 根与伦理尚未成为一个说明：延续条件是在它自己的形式体系上陈述的，而不是在续上。",
         "- 根与伦理只在部分上是一个说明：以从己方式沿一个关系持有，延续条件就是根的条件，即在该关系的全类之下，没有任何东西位于每一个中心的相续之外；沿一个无环的网，它只在只有一个中心时成立（[意义](chapters/07-SIGNIFICANCE.md#r-the-continuation-condition-on-the-root)）。自由的意义尚未提升到根上，一个中心自己的相续在哪个类之下进行，仍属未决。"),
    ],
    'theories/becoming/THE-THEORY-OF-BECOMING.md': [
        ("(proved for every type, near-definitionally; [decomposition](chapters/07-SIGNIFICANCE.md#r-continuation-condition-decomposition)). What the represented dynamics leave open is which relation is a center's own, the step below.",
         "(proved for every type, near-definitionally; [decomposition](chapters/07-SIGNIFICANCE.md#r-continuation-condition-decomposition)). On the root, lying within a closure along a relation is being reached on a line under the full class of that relation, so the condition so held is the root's: nothing lies outside every center's line (`«续无外»`); along a net with no cycle it holds only with one center, which nothing conditions (proved for every type; " + ROOT_EN + "). What the represented dynamics leave open, held de se, is which class a center's own line runs under: what continues, under a class, an occurrence at which a line under a finer class ends is reached on the line under the coarser class and lies on no line under the finer one from that occurrence (proved for every type; [past one's own end](chapters/07-SIGNIFICANCE.md#r-reach-past-ones-own-end)), so under an organism's class nothing of the self follows its end, and under a coarser one a line can go on through new members [AI reading]. That is the step below."),
        ("- **The root and the ethics as one account.** The continuation condition is stated on the formalism of significance, not on continuation; until it is lifted they are not one account ([07](chapters/07-SIGNIFICANCE.md#open)).",
         "- **The root and the ethics as one account.** Held de se along a relation, the continuation condition is the root's: nothing lies outside every center's line under the full class of that relation (`«续无外»`), and along a net with no cycle it holds only with one center (" + ROOT_EN + "). The free significance of 07 §1 is not lifted onto the root, the chapter's other laws are instances not yet stated on it, and which class a center's own line runs under is open ([07](chapters/07-SIGNIFICANCE.md#open))."),
    ],
    'theories/becoming/THE-THEORY-OF-BECOMING.zh.md': [
        ("（对一切类型证明，近乎依定义；[分解](chapters/07-SIGNIFICANCE.md#r-continuation-condition-decomposition)）。所表示的动力学让什么保持开放，是哪一个关系是一个中心自己的，即下文的那一步。",
         "（对一切类型证明，近乎依定义；[分解](chapters/07-SIGNIFICANCE.md#r-continuation-condition-decomposition)）。在根上，位于沿一个关系的闭包之内，就是在该关系的全类之下的相续上被到达，所以如此持有的条件就是根的：没有任何东西位于每一个中心的相续之外（`«续无外»`）；沿一个无环的网，它只在只有一个中心、且无物为其缘时成立（对一切类型证明；[07 §4.5](chapters/07-SIGNIFICANCE.md#r-the-continuation-condition-on-the-root)）。以从己方式持有，所表示的动力学让什么保持开放，是一个中心自己的相续在哪个类之下进行：在一个类之下继续一个发生（一条较细之类下的相续于该发生处终止）者，在较粗之类的相续上被到达，而不在从该发生出发、较细之类下的任何相续上（对一切类型证明；[越过自身的终结](chapters/07-SIGNIFICANCE.md#r-reach-past-ones-own-end)），所以在一个有机体的类之下，自我在其终结之后什么也不继续，而在一个较粗的类之下，一条相续可以经由新的成员继续下去［AI 读法］。这就是下文的那一步。"),
        ("- **根与伦理作为一个说明。** 延续条件是在意义的形式体系上陈述的，而不是在续上；在它被提升之前，二者不是一个说明（[07](chapters/07-SIGNIFICANCE.md#open)）。",
         "- **根与伦理作为一个说明。** 以从己方式沿一个关系持有，延续条件就是根的：在该关系的全类之下，没有任何东西位于每一个中心的相续之外（`«续无外»`）；沿一个无环的网，它只在只有一个中心时成立（[07 §4.5](chapters/07-SIGNIFICANCE.md#r-the-continuation-condition-on-the-root)）。07 §1 的自由意义尚未提升到根上，该章的其他律是尚未在根上陈述的实例，一个中心自己的相续在哪个类之下进行，仍属未决（[07](chapters/07-SIGNIFICANCE.md#open)）。"),
    ],
}


def apply(text, path):
    for old, new in EDITS[path]:
        n = text.count(old)
        if n != 1:
            raise SystemExit(f'{path}: {n} matches for {old[:70]!r}')
        text = text.replace(old, new)
    return text


if __name__ == '__main__':
    check = '--check' in sys.argv
    for path in EDITS:
        p = Path(path)
        new = apply(p.read_text(), path)
        if not check:
            p.write_text(new)
        print(('checked ' if check else 'applied ') + path)
