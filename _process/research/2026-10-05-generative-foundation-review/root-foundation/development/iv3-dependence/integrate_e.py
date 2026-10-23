#!/usr/bin/env python3
"""IV3e: put the extended Becoming.Weightings into the package and make its bullet in the root module's doc exact,
before the core checker runs.
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_e.py"""
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'

shutil.copyfile(HERE / 'tree/Becoming/Weightings.lean', PKG / 'Becoming/Weightings.lean')

root = PKG / 'Becoming.lean'
text = root.read_text(encoding='utf-8')
old = """  capacity covers each step's demand (`Flow.feedsAlone_iff`), and it is needed wherever the others
  active at some step could not together give the demand (`Flow.needs_giver_of_short`;
  `Capacities`). The readings are the AI's (D59, D60, D64).
"""
new = """  capacity covers each step's demand (`Flow.feedsAlone_iff`), and it is needed exactly where the
  others active at some step could not together give the demand, since otherwise they can share the
  giving (`Flow.needs_giver_iff_short`, `Flow.sharedDrawn`; `Capacities`, `SharedCopies`). The
  readings are the AI's (D59, D60, D64).
"""
assert text.count(old) == 1, text.count(old)
root.write_text(text.replace(old, new), encoding='utf-8')
print('integrated: Weightings copied, root bullet made exact')
