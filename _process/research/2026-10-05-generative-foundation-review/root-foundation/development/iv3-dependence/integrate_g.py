#!/usr/bin/env python3
"""IV3g: put the extended Becoming.Weightings into the package and extend its bullet in the root module's doc, before
the core checker runs.
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_g.py"""
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'

shutil.copyfile(HERE / 'tree/Becoming/Weightings.lean', PKG / 'Becoming/Weightings.lean')

root = PKG / 'Becoming.lean'
text = root.read_text(encoding='utf-8')
old = """  hierarchy holds needs giving into its top (`Flow.needsSome_tiers`; `TwoTiers`). The readings are
  the AI's (D59, D60, D64).
"""
new = """  hierarchy holds needs giving into its top (`Flow.needsSome_tiers`; `TwoTiers`). A feeder's degree
  of need, the least it gives while the consumer draws past the stock, is the sum of what each step
  demands beyond what the others can give (`Flow.least_giving`; `Capacities.second_in_degree`). The
  readings are the AI's (D59, D60, D64).
"""
assert text.count(old) == 1, text.count(old)
root.write_text(text.replace(old, new), encoding='utf-8')
print('integrated: Weightings copied, root bullet extended')
