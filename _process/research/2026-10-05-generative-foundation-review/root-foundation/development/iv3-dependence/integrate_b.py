#!/usr/bin/env python3
"""IV3b: put the extended Becoming.Weightings into the package and extend its bullet in the root module's doc, before
the core checker runs.
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_b.py"""
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'

shutil.copyfile(HERE / 'tree/Becoming/Weightings.lean', PKG / 'Becoming/Weightings.lean')

root = PKG / 'Becoming.lean'
text = root.read_text(encoding='utf-8')
old = """  (`Weighting.every_increasingInOwn_iff_includes`, `Weighting.ended_below`), and it is C's premise
  where its own continuation is everything listed. The readings are the AI's (D59, D60, D64).
"""
new = """  (`Weighting.every_increasingInOwn_iff_includes`, `Weighting.ended_below`), and it is C's premise
  where its own continuation is everything listed. Need holds over any courses with two readings, a
  member needed exactly where it is the only one (`needsPart_iff_only`); on the base, a formation
  drawing past its family's stock needs some feeder's giving, and a feeder's exactly where it is the
  only one (`Flow.needsSome_of_drawsPast`, `Flow.needs_giver_iff_only`, `Feeders`); and the coupled
  ending is ranked below by self-concern in one theorem (`Flow.coupled_ending_ranked_below`). The
  readings are the AI's (D59, D60, D64).
"""
assert text.count(old) == 1, text.count(old)
root.write_text(text.replace(old, new), encoding='utf-8')
print('integrated: Weightings copied, root bullet extended')
