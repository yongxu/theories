#!/usr/bin/env python3
"""OU3f, lineage laws: check the derivations against the dependency dump (one-unfolding-root/audit/dump.py's dump.jsonl,
made from the rehearsal's or the landing's run). For each of the six, its proof reaches the grammar law the design names
(transitively, through any constants), and its value neither names itself nor a recursor or `brecOn` (no induction of
its own). The two that follow reach the same laws through them. Lineage.cons, Lineage.line and line_lineage, which
stay, keep their own inductions (reported, not asserted).
usage: python3 -B <kit>/dump_check_lineage.py DUMPDIR"""
import json
import sys
from pathlib import Path

W = 'Becoming.Web.'
CLAIMS = {
    W + 'Lineage.unique': ['Becoming.«迭之定»'],
    W + 'Lineage.origin': ['Becoming.«迭之定前»'],
    W + 'Lineage.split': ['Becoming.«迭之分»'],
    W + 'Lineage.through': ['Becoming.«迭之分»', W + 'Lineage.split'],
    W + 'Lineage.onward': ['Becoming.«或有后则或迭»'],
    W + 'Lineage.back': ['Becoming.«或有后则或迭»', 'Becoming.«迭之逆»'],
}
FOLLOW = {W + 'Lineage.ends': ['Becoming.«迭之分»', 'Becoming.«迭之定»'],
          W + 'lineages_apart': ['Becoming.«迭之分»', 'Becoming.«迭之定前»']}
deps = {}
with (Path(sys.argv[1]) / 'dump.jsonl').open(encoding='utf-8') as f:
    for line in f:
        x = json.loads(line)
        if 'n' in x:
            deps[x['n']] = (set(x.get('t', [])), set(x.get('v', [])))


def reach(n):
    seen, stack = set(), [n]
    while stack:
        c = stack.pop()
        if c in seen:
            continue
        seen.add(c)
        t, v = deps.get(c, (set(), set()))
        stack.extend(t | v)
    return seen


def own_induction(n):
    """Constants of n's value (and of its own auxiliaries, n.match_k, n._unary and the like) that are recursors,
    brecOn or n itself."""
    values = set()
    for name, (_, v) in deps.items():
        if name == n or name.startswith(n + '.'):
            values |= v
    return sorted(c for c in values if c == n or c.endswith('.rec') or c.endswith('.brecOn') or c.endswith('.below')
                  or c.endswith('.binductionOn'))


bad = []
for n, laws in {**CLAIMS, **FOLLOW}.items():
    assert n in deps, n
    r = reach(n)
    missing = [law for law in laws if law not in r]
    rec = own_induction(n)
    print(n, '| reaches', 'all' if not missing else f'NOT {missing}', '| own induction:', rec or 'none')
    if missing or (n in CLAIMS and rec):
        bad.append(n)
for n in (W + 'Lineage.cons', W + 'Lineage.line', W + 'line_lineage', W + 'steps_iff_lineage', W + 'steps_advance'):
    print(n, '| own induction (kept):', own_induction(n) or 'none')
print('OK' if not bad else f'UNEXPECTED: {bad}')
sys.exit(1 if bad else 0)
