#!/usr/bin/env python3
"""IV3k: put the extended Becoming.Weightings into the package and extend its bullet in the root module's doc, before
the core checker runs.
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_k.py"""
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'

shutil.copyfile(HERE / 'tree/Becoming/Weightings.lean', PKG / 'Becoming/Weightings.lean')

root = PKG / 'Becoming.lean'
text = root.read_text(encoding='utf-8')
old = ("  (`Flow.needs_iff_through_short`; `Routing`). The readings are the AI's (D59, D60, D64).\n")
new = ("  (`Flow.needs_iff_through_short`; `Routing`). Read with time, need reaches only what is active within\n"
       "  the stretch it is read across (`Flow.needs_iff_none_of_inactive`), and a feeding closure up to a step\n"
       "  only what gives by then (`Flow.gives_of_withinFeedingUpTo`), while the closure read across every step\n"
       "  can run past the end of what it carries (`Overlapping.closure_overreaches`). The readings are the AI's\n"
       "  (D59, D60, D64).\n")
if text.count(new) == 0:
    assert text.count(old) == 1, text.count(old)
    root.write_text(text.replace(old, new), encoding='utf-8')
print('integrated: Weightings copied, root bullet extended')
