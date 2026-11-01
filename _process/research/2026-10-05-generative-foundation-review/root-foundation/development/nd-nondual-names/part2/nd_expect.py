"""Classify ND's changes per module against HEAD, with the kit's statements(): renamed (old->new), and kept
declarations whose statement or definition changed."""
import sys, json, subprocess, re
sys.path.insert(0, 'tools/research'); sys.path.insert(0, sys.argv[1])
import integrate_ou7 as io
sys.path.pop(0)
exec(open(sys.argv[2]).read().split('changed = []')[0].split('T = Path')[0])   # NAMES etc. from nd_rename.py
src = open(sys.argv[2]).read()
ns = {}; exec(src.split('\nT = Path')[0] + '\n' + src[src.index('NAMES = {'):src.index('ID = r')], ns)
ren = {**ns['NAMES'], **ns['DOTTED'], **ns['READING']}
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/'
changed = [p for p in subprocess.run(['git', 'diff', '--name-only', 'HEAD', '--', PKG + 'Becoming/'], capture_output=True, text=True).stdout.split()]
out = {'added': {}, 'renamed': {}, 'restated': {}, 'issues': []}
for p in changed:
    mod = 'Becoming.' + p.rsplit('/', 1)[-1][:-5]
    b_text = subprocess.run(['git', 'show', 'HEAD:' + p], capture_output=True, text=True).stdout
    a_text = open(p, encoding='utf-8').read()
    if io.mr.code(b_text) == io.mr.code(a_text):
        print(mod, 'comments only'); continue
    b, bw = io.statements(b_text); a, aw = io.statements(a_text)
    gone = sorted(set(b) - set(a)); new = sorted(set(a) - set(b))
    rn = {}
    for o in gone:
        short = o[len('Becoming.'):]
        last = short.rsplit('.', 1)[-1]
        cand = [n for n in new if n[len('Becoming.'):] == short.replace(last, ren.get(last, ren.get(short, last)))
                or n[len('Becoming.'):] == ren.get(short, None)]
        if len(cand) == 1: rn[o] = cand[0]
        else: out['issues'].append((mod, 'gone without a match', o, cand))
    out['added'][mod] = [n for n in new if n not in rn.values()]
    for o, n in rn.items():
        out['renamed'][o] = n
        if a[n] != b[o].replace(o[9:], n[9:], 1):
            out['issues'].append((mod, 'renamed with statement changed', o, n))
    for k in b:
        if k in a and (b[k] != a[k] or (not bw[k].startswith('theorem ') and bw[k] != aw[k])):
            out['restated'][k] = mod
    print(mod, 'renamed', len(rn), 'restated', sum(1 for v in out['restated'].values() if v == mod))
json.dump(out, open(sys.argv[3], 'w'), ensure_ascii=False, indent=1)
for i in out['issues']: print('ISSUE', i)
