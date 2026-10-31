#!/usr/bin/env python3
"""HE2's item 1: the derivations of Sampling's two theorems against the proofs they replace, measured on the
kit's own texts. A proof is what follows the statement: the lines after the two signature lines, and the `:=` the
new statements end with. Docstrings are not counted. Measured four ways: lines, characters other than spaces,
whitespace-separated tokens, and symbols (each name, «»-name or number one symbol, `:=`, `=>` and `→` one
each, every other mark one), the last the nearest to what Lean reads.
usage: python3 -B checks/measure.py (from the he2-item1 folder)"""
from pathlib import Path
import re
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / 'kit'))
import apply_he2_item1 as kit  # noqa: E402


def proofs(text):
    """Each theorem's proof, by name."""
    out = {}
    for m in re.finditer(r'^theorem (\S+) .*\n(.*)\n((?:  .*\n?)*)', text, re.M):
        signature_end, body = m.group(2), m.group(3)
        added = ':=' if signature_end.rstrip().endswith(':=') else ''
        out[m.group(1)] = (added, [line for line in body.split('\n') if line.strip()])
    return out


SYMBOL = re.compile(r"«[^»]*»|[^\W\d][\w'.!?₀-₉]*|\d+|:=|=>|→|\S")


def measure(proof):
    added, lines = proof
    text = added + ' ' + ' '.join(lines)
    return len(lines), len(re.sub(r'\s', '', text)), len(text.split()), len(SYMBOL.findall(text))


old, new = proofs(kit.SAMPLING_OLD), proofs(kit.SAMPLING_NEW)
assert sorted(old) == sorted(new) == ['arises_within', 'ceases_within'], (sorted(old), sorted(new))
total = {'old': [0, 0, 0, 0], 'new': [0, 0, 0, 0]}
print(f'{"":15} {"lines":>11} {"characters":>15} {"tokens":>11} {"symbols":>11}')
for name in ('arises_within', 'ceases_within'):
    a, b = measure(old[name]), measure(new[name])
    for i in range(4):
        total['old'][i] += a[i]
        total['new'][i] += b[i]
    print(f'{name:15} {a[0]:>5} -> {b[0]:<3} {a[1]:>7} -> {b[1]:<5} {a[2]:>5} -> {b[2]:<3} {a[3]:>5} -> {b[3]:<3}')
a, b = total['old'], total['new']
print(f'{"both":15} {a[0]:>5} -> {b[0]:<3} {a[1]:>7} -> {b[1]:<5} {a[2]:>5} -> {b[2]:<3} {a[3]:>5} -> {b[3]:<3}')
