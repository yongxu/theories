#!/usr/bin/env python3
"""UE0 texts: the audit's verdict in 08 §8, after "What survives" and before §9 (docs only, no checker run). The audit
found four of the 21 rows it read with a third part, three distinct, each forbidden statement known in a neighbouring
field; the chapter says so once, with the audit linked. Every edit asserts it applies exactly once.
usage (from the checkout root of the landing worktree): python3 -B <kit>/texts_ue0.py"""
from pathlib import Path

ROOT = Path.cwd()
CH8 = ROOT / 'theories/becoming/chapters/08-METHOD.md'
AUDIT = '../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue0-third-parts/AUDIT.md'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


edit(CH8, """A theorem a specialist would not foresee, a prediction that could fail and does not, or a premise derived from something weaker would change these verdicts.

<a id="theses"></a>""", f"""A theorem a specialist would not foresee, a prediction that could fail and does not, or a premise derived from something weaker would change these verdicts.

<a id="third-parts"></a>
**Third parts** (an AI audit of the rows above and of §9's unifications, against the literature it knew; [audit]({AUDIT})). A containment of a framework has a third part where the theory forbids something the framework leaves open. Of the 21 rows the audit read, four have one, three of them distinct:

- the order of what can form, weakly: under balance with requirements as thresholds, a part narrows what another can form only by a net draw beyond that formation's margin ([07](07-SIGNIFICANCE.md#r-closing-needs-net-draw));
- joint excess under the gate: steps of joint excess from below the renewal's reach end every dependent at that need, whatever each drawer's own draw ([05](05-COLLECTIVES.md#r-own-count-misses-joint-excess));
- the optimum laws, which carry the drain in §9's first and fourth unifications ([05](05-COLLECTIVES.md#r-what-an-optimum-does-beyond-what-couples-in)).

Price's equation and Fisher's theorem joined to the flow have one as well ([04](04-LIFE.md#r-what-bounds-offspring-numbers)). Each joins a framework that lacks conservation, renewal over time or a threshold to a premise or law of the theory, and forbids what the conjunction forbids. Each forbidden statement is known in a neighbouring field (critical depensation, the Malthusian bound, bioeconomics, scheduling), and none is one a specialist there would not foresee. So the theory reaches farther than each contained framework alone, and not yet farther than the sciences taken together.

<a id="theses"></a>""")
print('texts: 08 §8 third parts')
