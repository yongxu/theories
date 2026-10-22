#!/usr/bin/env python3
"""Build AL1's tree: Optimum with the converse of AtOnce.drains, whom restraint pays, and the whole standpoint.
usage: python3 -B build_tree.py   (AL1_ROOT names the checkout to read). Writes tree/Becoming/Optimum.lean."""
import os
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['AL1_ROOT']).resolve() if os.environ.get('AL1_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


op = (PKG / 'Becoming' / 'Optimum.lean').read_text(encoding='utf-8')
assert 'drain_perfect_iff' not in op, 'already built'
text = lambda n: (HERE / n).read_text(encoding='utf-8')
op = once(op, '\nend AtOnce\n', text('at_once.lean') + '\nend AtOnce\n')
i = op.index('theorem at_once_broken')
j = op.index('\nend Web\n', i)
op = op[:j] + '\n' + text('web.lean').rstrip('\n') + op[j:]
k = op.rindex('\nend Becoming')
op = op[:k] + text('halves.lean') + op[k:]
if (HERE / 'optimum_doc.py').exists():
    exec(text('optimum_doc.py'))
out = HERE / 'tree' / 'Becoming' / 'Optimum.lean'
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(op, encoding='utf-8')
print('wrote', out.name, len(op.splitlines()), 'lines')
