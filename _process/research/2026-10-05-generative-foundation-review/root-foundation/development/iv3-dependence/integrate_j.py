#!/usr/bin/env python3
"""IV3j: put the extended Becoming.Weightings into the package and extend its bullet in the root module's doc, before
the core checker runs.
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_j.py"""
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'

shutil.copyfile(HERE / 'tree/Becoming/Weightings.lean', PKG / 'Becoming/Weightings.lean')

root = PKG / 'Becoming.lean'
text = root.read_text(encoding='utf-8')
old = ("  (`Flow.least_giving_from_stores`; `OwnStores.first_in_degree`). The readings are the AI's (D59, D60,\n"
       "  D64).\n")
new = ("  (`Flow.least_giving_from_stores`; `OwnStores.first_in_degree`). Across two tiers, lower members passing on\n"
       "  what they take from their own stores and upper members giving the stores within their capacities, a\n"
       "  formation's giving into the hierarchy is needed exactly where, at some step, the other upper members\n"
       "  cannot give what the stores rise or the others cannot give the demand through the hierarchy\n"
       "  (`Flow.needs_iff_through_short`; `Routing`). The readings are the AI's (D59, D60, D64).\n")
assert text.count(old) == 1, text.count(old)
root.write_text(text.replace(old, new), encoding='utf-8')
print('integrated: Weightings copied, root bullet extended')
