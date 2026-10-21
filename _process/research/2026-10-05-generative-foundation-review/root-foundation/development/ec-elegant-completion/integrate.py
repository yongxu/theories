#!/usr/bin/env python3
"""EC1: copy the scratch modules into the package and update the package's module bullets.
Run from the worktree root: EC_ROOT=$PWD python3 -B .../integrate.py"""
import os, shutil
from pathlib import Path
ROOT = Path(os.environ.get('EC_ROOT', '.')).resolve()
KIT = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
for src in sorted((KIT / 'tree/Becoming').glob('*.lean')):
    shutil.copyfile(src, PKG / 'Becoming' / src.name)
p = PKG / 'Becoming.lean'
t = p.read_text()
edits = [
    ("""* `Becoming.Frame` (L0): a frame is a process with realized claims; runs,
  reachability, invariants and new realization.""",
     """* `Becoming.Frame` (L0): a frame is a process with realized claims; runs, the one closure
  of a relation, reachability, invariants and new realization. A process's reach is the closure
  of its steps and an invariant is a region closed under them, so what is kept by the steps
  holds wherever the process reaches because the closure is closed; the closures of the later
  layers (feeding, influence, reach, sharing, coupling, a presupposition's scope) are this
  closure under their relations."""),
    ("""* `Becoming.Feedback` (L1): what feedback registers and what a part reaches, with no premise
  beyond the representation. Closures under relations give five levels:""",
     """* `Becoming.Feedback` (L1): what feedback registers and what a part reaches, with no premise
  beyond the representation. The frame's one closure under five relations gives five levels:"""),
    ("""* `Becoming.EdgeClosure` (L1): the seed–edge closure, what the process whose steps are the
  edges reaches from a seed, and the core's closure under a relation as this closure from one
  seed.""",
     """* `Becoming.EdgeClosure` (L1): the seed–edge closure, what the process whose steps are the
  edges reaches from a seed, and the core's closure under a relation as this closure from one
  seed, derived from reach being the closure of the steps; it imports only the frame."""),
]
for old, new in edits:
    assert t.count(old) == 1, old[:60]
    t = t.replace(old, new)
p.write_text(t)
readme = [
    (PKG / 'README.md', [
        ("| L0 | [`Becoming.Frame`](Becoming/Frame.lean) | a frame is a process with realized claims; runs, reach, invariants, novel realization |",
         "| L0 | [`Becoming.Frame`](Becoming/Frame.lean) | a frame is a process with realized claims; runs, the one closure of a relation (`WithinClosure`), reach as the closure of the steps, invariants as regions closed under them, novel realization |"),
        ("| L1 | [`Becoming.EdgeClosure`](Becoming/EdgeClosure.lean) | the seed–edge closure, what the process whose steps are the edges reaches from a seed; the core's closure under a relation is this closure from one seed |",
         "| L1 | [`Becoming.EdgeClosure`](Becoming/EdgeClosure.lean) | the seed–edge closure, what the process whose steps are the edges reaches from a seed; the core's closure under a relation is this closure from one seed, derived from reach being the closure of the steps |"),
        ("what a formation's continuation depends on is its feeding closure, the least region holding it that is closed under feeding (`Flow.WithinFeeding`), and",
         "what a formation's continuation depends on is its feeding closure, the least region holding it that is closed under feeding, by definition the frame's closure under being fed (`Flow.WithinFeeding`), and"),
        ("what feedback registers and what a part reaches, with no premise: closures under relations give five levels,",
         "what feedback registers and what a part reaches, with no premise: the frame's closure under five relations gives five levels,"),
    ]),
    (PKG / 'README.zh.md', [
        ("| L0 | [`Becoming.Frame`](Becoming/Frame.lean) | 框架：过程加上每个配置实现的主张；运行、可达、不变量、新实现 |",
         "| L0 | [`Becoming.Frame`](Becoming/Frame.lean) | 框架：过程加上每个配置实现的主张；运行、关系的唯一闭包（`WithinClosure`）、可达即步的闭包、不变量即对步封闭的区域、新实现 |"),
    ]),
]
for path, pairs in readme:
    s = path.read_text()
    for old, new in pairs:
        assert s.count(old) == 1, (path.name, old[:60])
        s = s.replace(old, new)
    path.write_text(s)
print('integrated')
