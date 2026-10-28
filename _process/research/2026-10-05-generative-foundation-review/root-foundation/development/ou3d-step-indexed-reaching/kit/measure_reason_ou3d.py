#!/usr/bin/env python3
"""OU3d: the measure gives PartForms.goAlike its reason (a law of its model; OU3d's review found the image-law route a
rerouting), in place of a pending derivation. Run before the measure; texts_ou3d.py reads the rerun.
usage (from the checkout root of the landing worktree): python3 -B <kit>/measure_reason_ou3d.py"""
from pathlib import Path

ROOT = Path.cwd()


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


# PartForms.goAlike's reason, and no pending entry
measure = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou3b-master-laws-on-the-grammar/measure_grammar.py'
edit(measure, """    'Becoming.Weighting.widens_iff_every_positive': "weights: widening is what every positive weighting ranks higher; "
                                                    "the grammar has no weights",
}""", """    'Becoming.Weighting.widens_iff_every_positive': "weights: widening is what every positive weighting ranks higher; "
                                                    "the grammar has no weights",
    'Becoming.PartForms.goAlike': "a law of its model: the part's law determined at a move the part alone forms; the "
                                  "image law only reads it as carrying a law of its own (carries_law_iff), and a proof "
                                  "through it applies the law and undoes it (OU3d's review)",
}""")
edit(measure, """PENDING_ANCHOR = {
    'Becoming.PartForms.goAlike': "lumping on the grammar: constancy with a fixed successor («有常定后则同行») at the "
                                  "coupled step, with the part's sameness",
}""", """PENDING_ANCHOR = {}  # OU3d, 28 October 2026: PartForms.goAlike has its reason in REASONS (a law of its model)""")

print('measure: PartForms.goAlike given its reason; no pending anchor')
