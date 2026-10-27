#!/usr/bin/env python3
"""Build R/scratch/OC5Review.lean: the grammar's definitions and OC5's new and re-derived declarations copied
verbatim from the worktree (Init only), then the reviewer's checks (checks.lean). Reads only; writes only beside itself.
usage: python3 -I gen.py WORKTREE"""
import re
import sys
from pathlib import Path

WT = Path(sys.argv[1])
PKG = WT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming'
HERE = Path(__file__).resolve().parent


def blocks(path):
    """Top-level blocks separated by blank lines, with the namespace each sits in."""
    out, ns = [], []
    text = path.read_text(encoding='utf-8')
    for block in re.split(r'\n\s*\n', text):
        first = block.lstrip().splitlines()[0] if block.strip() else ''
        for line in block.splitlines():
            m = re.match(r'^namespace (\S+)', line)
            if m:
                ns.append(m.group(1))
            m = re.match(r'^end (\S+)', line)
            if m and ns and ns[-1] == m.group(1):
                ns.pop()
        out.append(('.'.join(ns), block))
    return out


def pick(path, names, namespace=''):
    found = {}
    for ns, block in blocks(path):
        for name in names:
            if re.search(r'^(?:theorem|def|inductive|abbrev|structure) ' + re.escape(name) + r'(?:\s|$)', block, re.M):
                if namespace and not ns.endswith(namespace):
                    continue
                found[name] = block.strip('\n')
    missing = [n for n in names if n not in found]
    assert not missing, (path.name, namespace, missing)
    return [found[n] for n in names]


grammar = PKG / 'Grammar.lean'
gmap = PKG / 'GrammarMap.lean'
gpath = PKG / 'GrammarPath.lean'

core = pick(grammar, ['«际»', '«而»', '«逆»', '«则»', '«合»', '«一»', '«及»', '«类»', '«及之传递»', '«及之单调»',
                      '«续»', '«相续»', '«有后»', '«亡»', '«有常»', '«有常之逐点»', '«线内同类»'])
core += pick(gmap, ['«所及»'])
laws = pick(gpath, ['«所缘同于»', '«后皆同类则后皆续»', '«后皆续当且仅当后皆同类»', '«后皆续则所缘同于»',
                    '«后皆同类当且仅当自与后皆闭»', '«至终有常»', '«本类至终有常»', '«至终有常则本类至终有常»',
                    '«本类常闭则所缘同类»', '«本类常闭则后皆续»', '«本类常则闭当且仅当后皆同类»',
                    '«本类常当且仅当与己相随»', '«外分唯系己出之同»', '«闭则外分无关»', '«二分»', '«二分为类»'])

other = (gpath.read_text(encoding='utf-8').split('namespace OtherLeaves', 1)[1].split('end OtherLeaves', 1)[0])
wake = pick(gpath, ['Occ', 'step', 'line', 'own', 'own_class', 'constant_to_end', 'not_held'], 'FiniteWake')
fam = pick(gpath, ['Occ', 'step', 'member', 'member_class'], 'FiniteFamilies')

head = ('/-! OC5 review scratch. The grammar\'s definitions and OC5\'s declarations are copied verbatim from the\n'
        'worktree (branch oc5) by gen.py; only Init is imported. The checks follow, then `#print axioms`. -/\n\n'
        'namespace Scratch\n\nuniverse u\n\nsection Path\n\nvariable {α : Type u}\n\n')
body = '\n\n'.join(core + laws)
tail = '\n\nend Path\n\n'
wit = ('namespace OtherLeaves' + other + 'end OtherLeaves\n\n'
       'namespace FiniteWake\n\n' + '\n\n'.join(wake) + '\n\nend FiniteWake\n\n'
       'namespace FiniteFamilies\n\n' + '\n\n'.join(fam) + '\n\nend FiniteFamilies\n\n')
checks = (HERE / 'checks.lean').read_text(encoding='utf-8')
(HERE / 'OC5Review.lean').write_text(head + body + tail + wit + checks + '\nend Scratch\n', encoding='utf-8')
print('written', HERE / 'OC5Review.lean')
