#!/usr/bin/env python3
"""HE2's item 1: make the scratch tree. Copies Grammar, GrammarMap, PatternPassing and Sampling from the package
(refused unless they and MapRegions match tree/BASE.sha256, the base the kit was written on), moves MapRegions'
three reach laws of the successor into GrammarMap whole, as item 5 does (a stand-in, for this check only: item 5's
script writes GrammarMap and deletes the three from MapRegions, which no module built here imports), then applies
item 1 with the kit's own script, so the tree is what the kit writes.
usage (from the worktree root): python3 -B <he2-item1>/checks/make_tree.py"""
import hashlib
from pathlib import Path
import re
import shutil
import subprocess
import sys

HERE = Path(__file__).resolve().parent.parent
PKG = Path('experiments/integrated-correction/general-framework/generative-basis/lean/becoming')
TREE = HERE / 'tree'
MODULES = ('Grammar', 'GrammarMap', 'PatternPassing', 'Sampling')

AFTER = '''\
theorem step_irrefl : ∀ n, ¬ step n n
  | 0, h => Nat.noConfusion h
  | n + 1, h => step_irrefl n (Nat.succ.inj h)
'''
# Item 5 moves these three laws of MapRegions into GrammarMap whole: names, statements and proofs unchanged.
MOVED = ('step_reached_le', 'step_reaches', 'step_reaches_of_le')


def block(lines, name):
    """A theorem with its docstring: the lines from the blank line before it to the blank line after it."""
    i = [k for k, line in enumerate(lines) if re.match(rf'theorem {name}\b', line)]
    assert len(i) == 1, (name, i)
    start, end = i[0], i[0]
    while lines[start - 1].strip():
        start -= 1
    while lines[end].strip():
        end += 1
    assert lines[start].startswith('/--'), name
    return '\n'.join(lines[start:end])


def main():
    base = dict(reversed(line.split('  ', 1)) for line in (TREE / 'BASE.sha256').read_text().split('\n') if line)
    (TREE / 'Becoming').mkdir(parents=True, exist_ok=True)
    for m in MODULES + ('MapRegions',):
        source = PKG / 'Becoming' / f'{m}.lean'
        digest = hashlib.sha256(source.read_bytes()).hexdigest()
        assert base[f'Becoming/{m}.lean'] == digest, f'{m}.lean is not the base the kit was written on'
        if m in MODULES:
            shutil.copyfile(source, TREE / 'Becoming' / f'{m}.lean')
    regions = (PKG / 'Becoming' / 'MapRegions.lean').read_text(encoding='utf-8').split('\n')
    moved = '\n\n'.join(block(regions, name) for name in MOVED)
    gm = TREE / 'Becoming' / 'GrammarMap.lean'
    text = gm.read_text(encoding='utf-8')
    assert text.count(AFTER) == 1 and not any(re.search(rf'theorem {name}\b', text) for name in MOVED)
    gm.write_text(text.replace(AFTER, AFTER + '\n' + moved + '\n'), encoding='utf-8')
    subprocess.run([sys.executable, '-B', str(HERE / 'kit' / 'apply_he2_item1.py'), str(TREE)], check=True)


if __name__ == '__main__':
    main()
