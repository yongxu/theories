#!/usr/bin/env python3
"""CA1: register the apart roots of Becoming.Founding.

The founding laws hold of any wholes read over generations (Nested), with no world: registered as general structure.
The witness facts of Body and Germline that no base law goes through are registered as model witnesses.

usage: python3 -B apart.py   (once, from the checkout root)"""
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
REGISTER = HERE.parents[1] / 'THEOREM-CONNECTIVITY-APART.json'
register = json.loads(REGISTER.read_text())
M = 'Becoming.Founding'
LAW = ('a law of any wholes read over generations, each founded by one part and founding the next from its members, '
       'with no world')
WIT = 'a fact about one constructed family, not a law of the unfolding'
NEW = {
    M + '.Nested.raises_iff_carried': ('general-structure',
        'the mean founding value rises across a generation of wholes exactly where selection among wholes, with the '
        'change carried within the wholes to the next founders as the transmission term, comes out positive: ' + LAW),
    M + '.Nested.varied_within': ('general-structure',
        'within each whole of a founded reading, selection at a step needs transmission that raised or lowered the '
        'amount at some step before it: ' + LAW),
    M + '.Body.spread_outlasts': ('model-witness',
        'the spreading lineage, whose descendant depends on a condition outside the body, has a member at the second '
        'generation: ' + WIT),
    M + '.Germline.unsequestered_founded': ('model-witness',
        'the reading with the next founders drawn from the variants is founded: ' + WIT),
    M + '.Germline.within_against': ('model-witness',
        'within the first whole a variant arises from the founder and selection within goes against holding back: '
        + WIT),
    M + '.Germline.sequestered_rises': ('model-witness',
        'with the next founder from the line carrying the founder\'s value, the mean founding value rises: ' + WIT),
    M + '.Germline.unsequestered_falls': ('model-witness',
        'with the next founders from the variants, the mean founding value falls although selection among wholes goes '
        'for holding back: ' + WIT),
}
for name, (category, reason) in NEW.items():
    assert name not in register['roots'], name
    register['roots'][name] = {'module': M, 'category': category, 'reason': reason}
REGISTER.write_text(json.dumps(register, ensure_ascii=False, indent=1) + '\n')
print('registered', len(NEW))
