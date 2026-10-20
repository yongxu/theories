#!/usr/bin/env python3
"""EV7: register the apart roots of the sized division and of its witnesses.

The division for groups of any sizes holds of any finite family listed by groups, with no world; the base law
Flow.rises_iff_inactive_sized goes through rises_iff_sized and rises_exact_iff_sized. The roots below are the ones no
base law goes through: registered as general structure, and the witnesses as model witnesses.

usage: python3 -B apart.py   (once, from the checkout root)"""
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
REGISTER = HERE.parents[1] / 'THEOREM-CONNECTIVITY-APART.json'
register = json.loads(REGISTER.read_text())
SL, GE = 'Becoming.SelectionLevels', 'Becoming.GroupEnding'
FAM = ('a law of any finite family listed as groups of any sizes with a common multiple of the sizes, read with weights '
       'and amounts, with no world; on the base, groups whose members are not active leave no offspring '
       '(GroupEnding.Flow.endedBy_of_inactive), which is one case')
WIT = 'a fact about one constructed family, not a law of the unfolding'
NEW = {
    SL + '.none_iff_sized': (SL, 'general-structure',
        'the whole selects nothing exactly where the means\' and the scaled within-group terms balance: ' + FAM),
    SL + '.rises_exact_iff_within_of_alike': (SL, 'general-structure',
        'over generations with exact transmission, a generation listed as groups alike in mean raises its mean exactly '
        'as the scaled within-group terms go: ' + FAM),
    GE + '.rises_iff_ended_sized': (GE, 'general-structure',
        'where the groups with a lower mean leave nothing, the whole selects for the amount exactly where the scaled '
        'within-group discordance is below the scaled within-group concordance with the means\' concordance: ' + FAM),
    SL + '.ByMeans.common': (SL, 'model-witness',
        'the groups of one and of three have the common multiple three: ' + WIT),
    SL + '.ByMeans.by_means': (SL, 'model-witness',
        'groups of one and of three alike in their totals of holding back but not in their means: the whole\'s selection '
        'for it is all among the means, and the reading by totals sees none; ' + WIT),
    GE + '.Exhausted.first_listed': (GE, 'model-witness',
        'the first generation of the two-generation family is listed by its three groups: ' + WIT),
    GE + '.Exhausted.next_listed': (GE, 'model-witness',
        'the next generation is listed by the offspring of each keeping group: ' + WIT),
    GE + '.Exhausted.first_step': (GE, 'model-witness',
        'at the first step the group leaving nothing makes selection among groups go for holding back and the mean rises: '
        + WIT),
    GE + '.Exhausted.next_step': (GE, 'model-witness',
        'at the next step the groups formed by descent are alike in holding back, selection within goes against it and '
        'the mean falls below its start: ' + WIT),
}
for name, (module, category, reason) in NEW.items():
    assert name not in register['roots'], name
    register['roots'][name] = {'module': module, 'category': category, 'reason': reason}
REGISTER.write_text(json.dumps(register, ensure_ascii=False, indent=1) + '\n')
print('registered', len(NEW))
