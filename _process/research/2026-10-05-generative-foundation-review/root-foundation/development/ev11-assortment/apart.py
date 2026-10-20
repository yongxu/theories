#!/usr/bin/env python3
"""EV11: register the apart roots of groups formed by descent in Becoming.SelectionLevels and Becoming.GroupEnding.

The lineage laws hold over any listed generations with exact transmission, with no world: registered as general
structure, the witness facts as model witnesses.

usage: python3 -B apart.py   (once, from the checkout root)"""
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
REGISTER = HERE.parents[1] / 'THEOREM-CONNECTIVITY-APART.json'
register = json.loads(REGISTER.read_text())
SL, GE = 'Becoming.SelectionLevels', 'Becoming.GroupEnding'
LAW = 'a law of any listed generations with exact transmission, read by the lineages of groups of the first generation'
WIT = 'a fact about one constructed family, not a law of the unfolding'
NEW = {
    SL + '.lineage_total': (SL, 'general-structure',
        'a lineage founded at a value has its size times the value as its total at every generation: ' + LAW),
    SL + '.lineages_within_none': (SL, 'general-structure',
        'lineages of groups uniform in an amount have nothing selected within them at any generation, for any '
        'weight: ' + LAW),
    SL + '.rises_iff_lineages': (SL, 'general-structure',
        'the mean rises exactly where the lineages\' means select for the amount, selection among the lineages being '
        'all there is: ' + LAW),
    GE + '.Assorted.first_listed': (GE, 'model-witness',
        'the first generation of the assorted family is listed by its two groups: ' + WIT),
    GE + '.Assorted.uniform': (GE, 'model-witness',
        'each group of the assorted family is uniform in holding back: ' + WIT),
    GE + '.Assorted.kept': (GE, 'model-witness',
        'with the groups formed by descent, the group not holding back ends, holding back rises and stays above where '
        'it started, where the mixed groups of Exhausted fell back: ' + WIT),
}
for name, (module, category, reason) in NEW.items():
    assert name not in register['roots'], name
    register['roots'][name] = {'module': module, 'category': category, 'reason': reason}
REGISTER.write_text(json.dumps(register, ensure_ascii=False, indent=1) + '\n')
print('registered', len(NEW))
