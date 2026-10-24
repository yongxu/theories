#!/usr/bin/env python3
"""IV3i: put the extended Becoming.Weightings into the package and extend its bullet in the root module's doc, before
the core checker runs.
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_i.py"""
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'

shutil.copyfile(HERE / 'tree/Becoming/Weightings.lean', PKG / 'Becoming/Weightings.lean')

root = PKG / 'Becoming.lean'
text = root.read_text(encoding='utf-8')
old = "  `Capacities.second_in_degree`). The readings are the AI's (D59, D60, D64).\n"
new = ("  `Capacities.second_in_degree`), and so it is with capacities read off the feeders' own stores\n"
       "  (`Flow.least_giving_from_stores`; `OwnStores.first_in_degree`). The readings are the AI's (D59, D60,\n"
       "  D64).\n")
assert text.count(old) == 1, text.count(old)
root.write_text(text.replace(old, new), encoding='utf-8')
print('integrated: Weightings copied, root bullet extended')
