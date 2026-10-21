#!/usr/bin/env python3
"""Build SG16's tree: Optimum with revision toward best responses for drawers in turn.
usage: python3 -B build_tree.py   (SG16_ROOT names the checkout to read; SG16_BASE, a git ref of it, reads it at that ref).
Writes tree/Becoming/Optimum.lean."""
import os
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['SG16_ROOT']).resolve() if os.environ.get('SG16_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


def read(name):
    if os.environ.get('SG16_BASE'):
        rel = (PKG / 'Becoming' / f'{name}.lean').relative_to(ROOT)
        return subprocess.run(['git', '-C', str(ROOT), 'show', f"{os.environ['SG16_BASE']}:{rel}"], check=True,
                              capture_output=True, text=True).stdout
    return (PKG / 'Becoming' / f'{name}.lean').read_text(encoding='utf-8')


op = read('Optimum')
assert 'def Revises' not in op, 'already built'
REV = (HERE / 'revision.lean').read_text(encoding='utf-8')
op = once(op, '''theorem perfect_levels {N : Nat} (perfect : Perfect G first second N) (s : Nat) {t : Nat}
    (before : t < N) : levels G first second s (t + 1) = G t 0 :=
  have zeros := perfect_ends perfect before
  congrArg (G t) ((congrArg (second t) (zeros.1 _)).trans (zeros.2 0))
''', '''theorem perfect_levels {N : Nat} (perfect : Perfect G first second N) (s : Nat) {t : Nat}
    (before : t < N) : levels G first second s (t + 1) = G t 0 :=
  levels_of_zero (fun _ lt => perfect_ends perfect lt) s before
''')
# levels_of_zero must precede perfect_levels: put the revision block's first lemma there, the rest at the end.
lz_end = REV.index('/-- Where both leave nothing at every step from `t` to the horizon')
LZ, REST = REV[:lz_end], REV[lz_end:]
op = once(op, '''/-- **The base stands at what stands at nothing.**''', LZ.lstrip('\n') + '''/-- **The base stands at what stands at nothing.**''')
i = op.index('namespace InTurn')
e = op.index('\nend InTurn\n', i)
op = op[:e] + '\n' + REST + op[e:]
WEBLAW = (HERE / 'web_witness.lean').read_text(encoding='utf-8')
WIT = (HERE / 'witness.lean').read_text(encoding='utf-8')
pb = op.index('theorem perfect_broken')
ew = op.index('\nend Web\n', pb)
op = op[:ew] + '\n' + WEBLAW + op[ew:]
gi = op.index('theorem gated_in_turn')
eh = op.index('\nend Holding\n', gi)
op = op[:eh] + '\n' + WIT + op[eh:]
if (HERE / 'optimum_doc.py').exists():
    exec((HERE / 'optimum_doc.py').read_text(encoding='utf-8'))
out = HERE / 'tree' / 'Becoming' / 'Optimum.lean'
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(op, encoding='utf-8')
print('wrote', out.name, len(op.splitlines()), 'lines')
