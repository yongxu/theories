#!/usr/bin/env python3
"""Build WH1 and SAT1's tree: Wholes with the whole of every part and the graded whole, Frequency with a
coupling saturated by what it has carried.
usage: python3 -B build_tree.py   (WH1_ROOT names the checkout to read; WH1_BASE, a git ref of it, reads it at that ref).
Writes tree/Becoming/Wholes.lean and tree/Becoming/Frequency.lean."""
import os
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['WH1_ROOT']).resolve() if os.environ.get('WH1_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


def read(name):
    if os.environ.get('WH1_BASE'):
        rel = (PKG / 'Becoming' / f'{name}.lean').relative_to(ROOT)
        return subprocess.run(['git', '-C', str(ROOT), 'show', f"{os.environ['WH1_BASE']}:{rel}"], check=True,
                              capture_output=True, text=True).stdout
    return (PKG / 'Becoming' / f'{name}.lean').read_text(encoding='utf-8')


def frag(name):
    return (HERE / name).read_text(encoding='utf-8')


wh = read('Wholes')
assert 'def AllWhole' not in wh, 'already built'
wh = once(wh, 'import Becoming.Identity\nimport Becoming.Continuation\n',
          'import Becoming.Identity\nimport Becoming.Continuation\nimport Becoming.Decidedness\n')
exec(frag('wholes_doc.py'))
wh = once(wh, 'end Drawn\n\nend Web\n', 'end Drawn\n\n' + frag('every.lean') + '\nend Web\n')
wh = once(wh, 'end WholeUngated\n\nend Becoming\n', 'end WholeUngated\n\n' + frag('every_witnesses.lean') + '\nend Becoming\n')

fr = read('Frequency')
assert 'namespace Saturation' not in fr, 'already built'
exec(frag('frequency_doc.py'))
fr = once(fr, 'end EveryLaw\n\nend Becoming\n', 'end EveryLaw\n\n' + frag('saturation.lean') + '\nend Becoming\n')

for name, text in (('Wholes', wh), ('Frequency', fr)):
    out = HERE / 'tree' / 'Becoming' / f'{name}.lean'
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(text, encoding='utf-8')
    print('wrote', out.name, len(text.splitlines()), 'lines')
