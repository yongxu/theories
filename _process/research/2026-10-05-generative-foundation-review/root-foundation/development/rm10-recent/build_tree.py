#!/usr/bin/env python3
"""Build RM10's tree: RegimeMargin with RM9's bounded laws stated for any law read condition by condition, and webs
with a recent giving.
usage: python3 -B build_tree.py   (RM10_ROOT names the checkout to read; RM10_BASE, a git ref of it, reads it at that ref).
Writes tree/Becoming/RegimeMargin.lean."""
import os
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['RM10_ROOT']).resolve() if os.environ.get('RM10_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


def read(name):
    if os.environ.get('RM10_BASE'):
        rel = (PKG / 'Becoming' / f'{name}.lean').relative_to(ROOT)
        return subprocess.run(['git', '-C', str(ROOT), 'show', f"{os.environ['RM10_BASE']}:{rel}"], check=True,
                              capture_output=True, text=True).stdout
    return (PKG / 'Becoming' / f'{name}.lean').read_text(encoding='utf-8')


rm = read('RegimeMargin')
assert 'def KeepsBelow' not in rm, 'already built'
exec((HERE / 'alike_edits.py').read_text(encoding='utf-8'))
# RM9's bounded section, replaced by its statement for any law read condition by condition.
OLD9 = (HERE / 'rm9_bounded.lean').read_text(encoding='utf-8')
rm = once(rm, OLD9, (HERE / 'general.lean').read_text(encoding='utf-8') + (HERE / 'recent.lean').read_text(encoding='utf-8'))
exec((HERE / 'regime_doc.py').read_text(encoding='utf-8'))
out = HERE / 'tree' / 'Becoming' / 'RegimeMargin.lean'
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(rm, encoding='utf-8')
print('wrote', out.name, len(rm.splitlines()), 'lines')
