#!/usr/bin/env python3
"""Build RM4's tree: LastChange with a run's one rest, and RegimeMargin with the threshold in the plane of level and
recent giving.
usage: python3 -B build_tree.py   (RM4_ROOT names the checkout to read, one whose LastChange and RegimeMargin are
RM3's; default the checkout holding this kit; RM4_BASE, a git ref of that checkout, reads them at that ref instead).
Writes tree/Becoming/LastChange.lean and tree/Becoming/RegimeMargin.lean."""
import os
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['RM4_ROOT']).resolve() if os.environ.get('RM4_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


def read(name):
    if os.environ.get('RM4_BASE'):
        rel = (PKG / 'Becoming' / f'{name}.lean').relative_to(ROOT)
        return subprocess.run(['git', '-C', str(ROOT), 'show', f"{os.environ['RM4_BASE']}:{rel}"], check=True,
                              capture_output=True, text=True).stdout
    return (PKG / 'Becoming' / f'{name}.lean').read_text(encoding='utf-8')


lc = read('LastChange')
assert 'still_same' not in lc, 'already built'
lc = once(lc, '\nend AnyProcess\n', '\n' + (HERE / 'lastchange_section.lean').read_text(encoding='utf-8') + '\nend AnyProcess\n')
exec((HERE / 'lastchange_doc.py').read_text(encoding='utf-8'))
rm = read('RegimeMargin')
assert 'threshold_regime' not in rm, 'already built'
RM_END = '\nend RegimeMargin\n'
rm = once(rm, RM_END, '\n' + (HERE / 'threshold_section.lean').read_text(encoding='utf-8') + RM_END)
exec((HERE / 'regime_doc.py').read_text(encoding='utf-8'))
for name, text in [('LastChange', lc), ('RegimeMargin', rm)]:
    out = HERE / 'tree' / 'Becoming' / f'{name}.lean'
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(text, encoding='utf-8')
    print('wrote', out, len(text.splitlines()), 'lines')
