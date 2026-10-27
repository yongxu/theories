#!/usr/bin/env python3
"""DF2: Becoming.Closing's header says what its Lean shows (the coordinator's request after DF1b): that the amounts
before a loop forms do not show when it forms is a witness (Onset.unforeseen, Threshold.unforeseen), so the header
says they need not show it, as how-loops-form's revised reading does. Comment-only; the core checker reruns the
module. Run once from the checkout root: python3 -B <kit>/df2_closing.py."""
from pathlib import Path

F = Path.cwd() / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Closing.lean'


def sub(t, old, new):
    assert t.count(old) == 1, (old[:80], t.count(old))
    return t.replace(old, new)


t = F.read_text(encoding='utf-8')
before = t
t = sub(t,
        "  the step a loop forms do not show whether it will: a self-loop forming at step `T`\n"
        "  (`Closing.Onset`) carries",
        "  the step a loop forms need not show whether it will: a self-loop forming at step `T`\n"
        "  (`Closing.Onset`, a witness) carries")
t = sub(t,
        "**Readings (the AI's, taken by Ren on 16 October 2026).**",
        "**Readings (the AI's, taken by Ren on 16 October 2026; the second revised on 27 October 2026, board item DF2,\n"
        "since `Onset.unforeseen` and `Threshold.unforeseen` are witnesses).**")
t = sub(t,
        "- A loop's formation is not foreseen from the amounts before it. Before it forms the growth is at\n"
        "  most polynomial; the step it forms is not shown by the course so far, and the amounts after it\n"
        "  grow at least geometrically. This meets `Becoming.Runaway`: a runaway's break does not show\n"
        "  before it, and the formation of the loop that runs away does not show either, in the amounts\n"
        "  it carries.",
        "- A loop's formation need not be foreseen from the amounts before it. Before it forms the growth\n"
        "  is at most polynomial; in the witnesses the course so far does not show the step it forms\n"
        "  (`Onset.unforeseen`, `Threshold.unforeseen`), and the amounts after it grow geometrically. This\n"
        "  meets `Becoming.Runaway`: a runaway's break does not show before it, and the formation of the\n"
        "  loop that runs away need not show either, in the amounts it carries.")
# Only the module header changes: everything from its closing `-/` on is byte-identical.
assert before.split('\n-/\n', 1)[1] == t.split('\n-/\n', 1)[1]
F.write_text(t, encoding='utf-8')
print('df2_closing: applied')
