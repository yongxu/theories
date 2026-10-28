#!/usr/bin/env python3
"""OU3e: the measure drops its pending entries for the three step-indexed rows, which now reach the grammar through
the bridges (their category follows from their dependence). Run before the measure; texts_ou3e.py reads the rerun.
usage (from the checkout root of the landing worktree): python3 -B <kit>/measure_ou3e.py"""
from pathlib import Path

M = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou3b-master-laws-on-the-grammar/measure_grammar.py')
s = M.read_text(encoding='utf-8')
for line in (
        """    'Becoming.Withholding.withholding_spreads': (PENDING, "reaching within n steps: OU3d's law, and its bridge from here"),\n""",
        """    'Becoming.Tolerance.answers_restores_iff': (PENDING, "reaching in n steps: OU3d's law, and its bridge from here"),\n""",
        """    'Becoming.WithinMoves.after_course': (PENDING, "reaching within n steps: OU3d's law, and its bridge from here"),\n"""):
    assert s.count(line) == 1, line[:60]
    s = s.replace(line, '')
M.write_text(s, encoding='utf-8')
print('measure: the three step-indexed pending entries dropped (OU3e)')
