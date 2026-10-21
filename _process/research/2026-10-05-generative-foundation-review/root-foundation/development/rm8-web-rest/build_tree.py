#!/usr/bin/env python3
"""Build RM8's tree: RegimeMargin with rest and points of no return on coupled webs, the pair's laws their case.
usage: python3 -B build_tree.py   (RM8_ROOT names the checkout to read; RM8_BASE, a git ref of it, reads it at that ref).
Writes tree/Becoming/RegimeMargin.lean."""
import os
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['RM8_ROOT']).resolve() if os.environ.get('RM8_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


def read(name):
    if os.environ.get('RM8_BASE'):
        rel = (PKG / 'Becoming' / f'{name}.lean').relative_to(ROOT)
        return subprocess.run(['git', '-C', str(ROOT), 'show', f"{os.environ['RM8_BASE']}:{rel}"], check=True,
                              capture_output=True, text=True).stdout
    return (PKG / 'Becoming' / f'{name}.lean').read_text(encoding='utf-8')


rm = read('RegimeMargin')
assert 'theorem leftOver_bound' not in rm, 'already built'
WEB = (HERE / 'web_section.lean').read_text(encoding='utf-8')
rm = once(rm, '\n/-! ### Coupled conditions in whole numbers -/\n', WEB + '\n/-! ### Coupled conditions in whole numbers -/\n')
if (HERE / 'pair_edits.py').exists():
    exec((HERE / 'pair_edits.py').read_text(encoding='utf-8'))
if (HERE / 'regime_doc.py').exists():
    exec((HERE / 'regime_doc.py').read_text(encoding='utf-8'))
out = HERE / 'tree' / 'Becoming' / 'RegimeMargin.lean'
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(rm, encoding='utf-8')
print('wrote', out.name, len(rm.splitlines()), 'lines')
