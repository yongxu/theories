#!/usr/bin/env python3
"""Build RM6's tree: RegimeMargin with coupled conditions.
usage: python3 -B build_tree.py   (RM6_ROOT names the checkout to read, one whose RegimeMargin is RM5's; default the
checkout holding this kit; RM6_BASE, a git ref of that checkout, reads it at that ref instead).
Writes tree/Becoming/RegimeMargin.lean."""
import os
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['RM6_ROOT']).resolve() if os.environ.get('RM6_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


def read(name):
    if os.environ.get('RM6_BASE'):
        rel = (PKG / 'Becoming' / f'{name}.lean').relative_to(ROOT)
        return subprocess.run(['git', '-C', str(ROOT), 'show', f"{os.environ['RM6_BASE']}:{rel}"], check=True,
                              capture_output=True, text=True).stdout
    return (PKG / 'Becoming' / f'{name}.lean').read_text(encoding='utf-8')


rm = read('RegimeMargin')
assert 'namespace Coupled' not in rm, 'already built'
RM_END = '\nend RegimeMargin\n'
rm = once(rm, RM_END, '\n' + (HERE / 'coupled_section.lean').read_text(encoding='utf-8') + RM_END)
if (HERE / 'regime_doc.py').exists():
    exec((HERE / 'regime_doc.py').read_text(encoding='utf-8'))
out = HERE / 'tree' / 'Becoming' / 'RegimeMargin.lean'
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(rm, encoding='utf-8')
print('wrote', out, len(rm.splitlines()), 'lines')
