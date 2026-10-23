#!/usr/bin/env python3
"""IV3c: put the extended Becoming.Weightings into the package and extend its bullet in the root module's doc, before
the core checker runs.
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_c.py"""
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'

shutil.copyfile(HERE / 'tree/Becoming/Weightings.lean', PKG / 'Becoming/Weightings.lean')

root = PKG / 'Becoming.lean'
text = root.read_text(encoding='utf-8')
old = """  ending is ranked below by self-concern in one theorem (`Flow.coupled_ending_ranked_below`). The
  readings are the AI's (D59, D60, D64).
"""
new = """  ending is ranked below by self-concern in one theorem (`Flow.coupled_ending_ranked_below`). Read
  off a web, a feeder can feed a family alone where it is active at every step calling for giving
  (`Flow.partAlone_on`), and a consumer needs a feeder's giving exactly where, at some step calling
  for giving, it is the only one active (`Flow.needs_giver_iff_alone`; `Shifts`). The readings are
  the AI's (D59, D60, D64).
"""
assert text.count(old) == 1, text.count(old)
root.write_text(text.replace(old, new), encoding='utf-8')
print('integrated: Weightings copied, root bullet extended')
