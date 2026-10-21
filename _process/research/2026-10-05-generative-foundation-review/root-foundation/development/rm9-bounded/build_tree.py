#!/usr/bin/env python3
"""Build RM9's tree: RegimeMargin with thresholds beyond a band, a bound on the run in its place.
usage: python3 -B build_tree.py   (RM9_ROOT names the checkout to read; RM9_BASE, a git ref of it, reads it at that ref).
Writes tree/Becoming/RegimeMargin.lean."""
import os
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['RM9_ROOT']).resolve() if os.environ.get('RM9_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


def read(name):
    if os.environ.get('RM9_BASE'):
        rel = (PKG / 'Becoming' / f'{name}.lean').relative_to(ROOT)
        return subprocess.run(['git', '-C', str(ROOT), 'show', f"{os.environ['RM9_BASE']}:{rel}"], check=True,
                              capture_output=True, text=True).stdout
    return (PKG / 'Becoming' / f'{name}.lean').read_text(encoding='utf-8')


rm = read('RegimeMargin')
assert 'def StaysWithin' not in rm, 'already built'
exec((HERE / 'pointwise_edits.py').read_text(encoding='utf-8'))
BOUNDED = (HERE / 'bounded.lean').read_text(encoding='utf-8')
rm = once(rm, '\nend Indexed\n\n/-! ### Coupled conditions in whole numbers -/\n',
          BOUNDED + '\nend Indexed\n\n/-! ### Coupled conditions in whole numbers -/\n')
RELAY = (HERE / 'relay.lean').read_text(encoding='utf-8')
rm = once(rm, '\nend Relay\n', RELAY + '\nend Relay\n')
exec((HERE / 'regime_doc.py').read_text(encoding='utf-8'))
out = HERE / 'tree' / 'Becoming' / 'RegimeMargin.lean'
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(rm, encoding='utf-8')
print('wrote', out.name, len(rm.splitlines()), 'lines')
