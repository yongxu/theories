# AI-written (reader "smaller"), 16 November 2026. Read only.
# Which declarations of other modules the scratch files use in code (comments stripped), and of what kind.
import re, os, sys, glob
sys.path.insert(0, os.path.dirname(__file__))
from compare import strip_comments, decls, PKG, SCR

def path(m):
    rel = m.replace('.', '/') + '.lean'
    for b in (SCR, PKG):
        if os.path.exists(b + rel): return b + rel

def kinds_of(mod):
    d, order, raw = decls(path('Becoming.' + mod))
    out = {}
    for n in order:
        short = n.split('Becoming.')[-1]
        out[short] = (d[n]['kind'], d[n]['line'], d[n]['priv'])
    return out

SRC = ['RegimeMargin', 'TurningInTime', 'SelectionTerm', 'Flow', 'Prelude', 'ReadingsPersist', 'LineOnAStock',
       'Law', 'GrammarLaws', 'ListTests', 'Optimum', 'Naturals', 'CrossSituational', 'LineageDrawdown', 'LineageRegimes', 'WayOfUnits']
K = {}
for m in SRC:
    p = path('Becoming.' + m)
    if p: K[m] = kinds_of(m)
    else: print('no file for', m)

def uses(fname, own):
    raw = open(SCR + 'Becoming/' + fname).read()
    code = strip_comments(raw)
    res = {}
    for m in SRC:
        if m == own or m not in K: continue
        for mt in re.finditer(r'(?<![\w.])' + m + r"\.([A-Za-z_][\w'.₁₂]*)", code):
            name = mt.group(1).rstrip('.')
            line = code.count('\n', 0, mt.start()) + 1
            res.setdefault((m, name), []).append(line)
    return res, code

# Prelude: unqualified names (namespace Becoming root). collect theorem names of Prelude that live at root
def root_names(mod):
    d, order, raw = decls(path('Becoming.' + mod))
    return {n.split('.')[-1]: (d[n]['kind'], d[n]['line'], n) for n in order}

PRE = root_names('Prelude')

for fname, own in [('LineOnAStock.lean', 'LineOnAStock'), ('WayOfUnits.lean', 'WayOfUnits'), ('LineOnAStockCases.lean', 'LineOnAStockCases')]:
    res, code = uses(fname, own)
    print('=' * 10, fname)
    for (m, name), lines in sorted(res.items()):
        key = m + '.' + name
        # find the kind: try full then progressively shorter
        k = None
        for cand in (key,):
            for kk, v in K[m].items():
                if kk == cand or kk.endswith('.' + name) and kk.startswith(m):
                    k = v; break
        print('  %-58s %-9s uses:%d first at %s' % (key, (k[0] if k else '?') + (' priv' if k and k[2] else ''), len(lines), lines[:4]))
    # Prelude unqualified theorems
    hits = {}
    own_d, own_o, _ = decls(SCR + 'Becoming/' + fname)
    own_short = {n.split('.')[-1] for n in own_o}
    for nm, (kind, line, full) in PRE.items():
        if kind != 'theorem' or nm in own_short or len(nm) < 4: continue
        ls = [code.count('\n', 0, mt.start()) + 1 for mt in re.finditer(r'(?<![\w.])' + re.escape(nm) + r"(?![\w'])", code)]
        if ls: hits[full] = ls
    print('  -- Prelude theorems used unqualified:')
    for full, ls in sorted(hits.items()):
        print('     %-50s uses:%d first at %s' % (full, len(ls), ls[:4]))
