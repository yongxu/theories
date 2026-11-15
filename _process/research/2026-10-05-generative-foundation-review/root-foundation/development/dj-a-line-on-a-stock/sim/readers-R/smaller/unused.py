# AI-written (reader "smaller"), 16 November 2026. Read only.
# Declarations of each scratch file that no other declaration of the four scratch files uses in code.
import re, os, sys
sys.path.insert(0, os.path.dirname(__file__))
from compare import strip_comments, decls, PKG, SCR
files = ['TurningInTime.lean', 'LineOnAStock.lean', 'WayOfUnits.lean', 'LineOnAStockCases.lean']
D = {}
for f in files:
    d, order, raw = decls(SCR + 'Becoming/' + f)
    D[f] = (d, order)
allbodies = []
for f in files:
    d, order = D[f]
    for n in order: allbodies.append((f, n, d[n]['body']))
for f in sys.argv[1:]:
    d, order = D[f]
    print('==', f, 'declarations', len(order))
    kinds = {}
    for n in order: kinds[d[n]['kind']] = kinds.get(d[n]['kind'], 0) + 1
    print('   kinds', kinds)
    for n in order:
        short = n.split('.')[-1]
        pat = re.compile(r'(?<![\w])' + re.escape(short) + r"(?![\w'])")
        users = [(g, m) for g, m, b in allbodies if m != n and pat.search(b)]
        # restrict: users in same namespace prefix or qualified use
        if not users:
            print('   unused: %-34s %-8s line %d' % (n.split('Becoming.')[-1], d[n]['kind'], d[n]['line']))
