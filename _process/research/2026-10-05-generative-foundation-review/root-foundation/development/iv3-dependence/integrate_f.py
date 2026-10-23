#!/usr/bin/env python3
"""IV3f: put the extended Becoming.Weightings into the package and extend its bullet in the root module's doc, before
the core checker runs.
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_f.py"""
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'

shutil.copyfile(HERE / 'tree/Becoming/Weightings.lean', PKG / 'Becoming/Weightings.lean')

root = PKG / 'Becoming.lean'
text = root.read_text(encoding='utf-8')
old = """  giving (`Flow.needs_giver_iff_short`, `Flow.sharedDrawn`; `Capacities`, `SharedCopies`). The
  readings are the AI's (D59, D60, D64).
"""
new = """  giving (`Flow.needs_giver_iff_short`, `Flow.sharedDrawn`; `Capacities`, `SharedCopies`). Read
  off a feeder's own store, which nothing feeds, its capacity at a step is what the store falls, and
  the exact law holds with it (`Flow.needs_giver_iff_store_short`; `OwnStores`); over a hierarchy of
  families, each given only what is passed on from the one above, drawing past what the whole
  hierarchy holds needs giving into its top (`Flow.needsSome_tiers`; `TwoTiers`). The readings are
  the AI's (D59, D60, D64).
"""
assert text.count(old) == 1, text.count(old)
root.write_text(text.replace(old, new), encoding='utf-8')
print('integrated: Weightings copied, root bullet extended')
