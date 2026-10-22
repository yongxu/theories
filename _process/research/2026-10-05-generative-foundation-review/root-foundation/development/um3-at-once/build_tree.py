#!/usr/bin/env python3
"""Build UM3's tree: Optimum with drawing at once on the same law, the law's strict form stated once.
usage: python3 -B build_tree.py   (UM3_ROOT names the checkout to read; UM3_BASE, a git ref of it, reads it at that ref).
Writes tree/Becoming/Optimum.lean."""
import os
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['UM3_ROOT']).resolve() if os.environ.get('UM3_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


def region(text, start, stop, new):
    assert text.count(start) == 1, ('start not once', start[:80], text.count(start))
    i = text.index(start)
    j = text.index(stop, i)
    return text[:i] + new + text[j:]


def read(name):
    if os.environ.get('UM3_BASE'):
        rel = (PKG / 'Becoming' / f'{name}.lean').relative_to(ROOT)
        return subprocess.run(['git', '-C', str(ROOT), 'show', f"{os.environ['UM3_BASE']}:{rel}"], check=True,
                              capture_output=True, text=True).stdout
    return (PKG / 'Becoming' / f'{name}.lean').read_text(encoding='utf-8')


op = read('Optimum')
assert 'namespace AtOnce' not in op, 'already built'
text = lambda n: (HERE / n).read_text(encoding='utf-8')
op = region(op, '/-- **A best response leaves its floor wherever nothing it keeps above the floor returns to it.** -/',
            '\nvariable {G : Nat → Nat → Nat} {low rules rules\' : Nat → Nat → Nat → Nat} {k N : Nat}', text('law.lean'))
op = once(op, '\nend InTurn\n', '\nend InTurn\n' + text('at_once.lean'))
i = op.index('theorem drained_broken')
j = op.index('\nend Web\n', i)
op = op[:j] + '\n' + text('web.lean').rstrip('\n') + op[j:]
if (HERE / 'optimum_doc.py').exists():
    exec(text('optimum_doc.py'))
out = HERE / 'tree' / 'Becoming' / 'Optimum.lean'
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(op, encoding='utf-8')
print('wrote', out.name, len(op.splitlines()), 'lines')
