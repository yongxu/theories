#!/usr/bin/env python3
"""IV3h: the canonical chapter's bullet on what self-concern reaches through dependence (EN, ZH), corrected after the
independent review: centers that each depend on and exchange with one condition; the step's demand, not what is
drawn; need stated as need, reach named a reading; the degree where a flow is possible.
usage (from the checkout root): python3 -B canonical_h.py"""
from pathlib import Path

ROOT = Path.cwd()
CH = ROOT / 'theories/becoming/chapters'
EDITS = [
    (CH / 'THE-THEORY-OF-BECOMING.md',
     "and centers that share one condition do. Drawn along need, it reaches a copy only where the copy is the only one, "
     "when each copy could carry the need alone; copies count by capacity, and it reaches a copy exactly where the "
     "others could not together give what is drawn. Need climbs a hierarchy: drawing past what the families it draws "
     "on, and those feeding them, hold, it reaches what feeds their top. It reaches a feeder in degree: the least the "
     "feeder gives while the center draws past the stock is the sum of what each step demands beyond what the others "
     "can give. ",
     "and centers that each depend on one condition and exchange with it do. Drawn along need, it reaches a copy only "
     "where the copy is the only one, when each copy could carry the need alone. On the base copies count by capacity: "
     "a consumer needs a feeder exactly where the others could not together give what a step demands; drawing past "
     "what a hierarchy fed only from above holds needs giving into its top; and wherever some flow lets the consumer "
     "draw past the stock, the least a feeder gives is the sum of what each step demands beyond what the others can "
     "give. That self-concern reaches what is so needed is a reading: need with two readings is not its own closure. "),
    (CH / 'THE-THEORY-OF-BECOMING.zh.md',
     "共有一个条件的诸中心即如此。沿“所需”来画，在每个副本都能单独承担所需时，它只在某个副本是唯一者时达到该副本；副本按容量而非数目计，"
     "它恰在其余者合起来给不出所汲取者之处达到该副本。“所需”沿层级上溯：汲取超出它所取用的诸族及供给这些族的诸族所持有者时，它达到供给其"
     "顶层者。它按程度达到供给者：中心汲取超出存量时供给者至少要给的，是每步需求超出其余者合起来能给者之和。",
     "各自依存于同一条件并与之交换的诸中心即如此。沿“所需”来画，在每个副本都能单独承担所需时，它只在某个副本是唯一者时达到该副本。在基底上，"
     "副本按容量计：消耗者恰在其余者合起来给不出某步需求之处需要某供给者；汲取超出只从上方供给的层级所持有者，需要向其顶层的给予；凡有某个流"
     "使消耗者汲取超出存量，供给者至少要给的是每步需求超出其余者合起来能给者之和。自我关切达到如此所需者，是一种读法：两种读法的“所需”不是它"
     "自身的闭包。"),
]
for path, old, new in EDITS:
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')
    print('wrote', path.relative_to(ROOT))
