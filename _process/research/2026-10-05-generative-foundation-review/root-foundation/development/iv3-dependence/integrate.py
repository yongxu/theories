#!/usr/bin/env python3
"""IV3: put the extended Becoming.Weightings into the package and extend its bullet in the root module's doc, before
the core checker runs (the root's bytes are the checker's input).
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate.py"""
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'

shutil.copyfile(HERE / 'tree/Becoming/Weightings.lean', PKG / 'Becoming/Weightings.lean')

root = PKG / 'Becoming.lean'
text = root.read_text(encoding='utf-8')
old = """  each alone admits, the tilted weighting tying on the boundary; two disagree exactly where the ratio
  exceeds both `p / q` and `q / p`. The readings are the AI's (D59, D60).
"""
new = """  each alone admits, the tilted weighting tying on the boundary; two disagree exactly where the ratio
  exceeds both `p / q` and `q / p`. Held de se, self-concern is one from every standpoint exactly where
  the centers lie within one another's closures, and centers that share one condition do
  (`ownClosure_standpointInvariant_iff_centersWithin`, `Flow.centersWithin_feeding_of_common`); drawn
  along need it reaches a copy of what it needs exactly where the copy is the only one
  (`forced_member_iff_only`, `Copies`); an order increasing in its own continuation ranks a course
  above another, where it adds to that continuation, exactly where the other keeps nothing beyond it,
  so the ending of what everything needs is ranked below from every standpoint
  (`Weighting.every_increasingInOwn_iff_includes`, `Weighting.ended_below`), and it is C's premise
  where its own continuation is everything listed. The readings are the AI's (D59, D60, D64).
"""
assert text.count(old) == 1, text.count(old)
root.write_text(text.replace(old, new), encoding='utf-8')
print('integrated: Weightings copied, root bullet extended')
