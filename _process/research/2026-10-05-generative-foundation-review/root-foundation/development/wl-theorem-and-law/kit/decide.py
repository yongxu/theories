import sys, os, json, re
sys.path.insert(0, '/Users/ren/tmp/wl/kit')
from sheet import verdicts
d = '/Users/ren/theories/tmp/r7/words/run'
man = json.load(open(d + '/manifest.json'))
def P(s):  # "GLOSSARY/00#2" -> (piece, id)
    a, b = s.split('#'); return a.replace('/', '--'), b
KEEP = '''GLOSSARY/00#2 COLLECTIVE-DIRECTION/00#15 01-ROOT/02#13 01-ROOT/02#41 04-LIFE/02#13 07-SIGNIFICANCE/07#3
08-METHOD/02#31 08-METHOD/02#35 08-METHOD/02#41 GLOSSARY/00#23 08-METHOD/04#38 08-METHOD/04#39 03-KNOWING/05#20
COLLECTIVE-DIRECTION/00#12 05-COLLECTIVES/04#45 04-LIFE/01#12
GLOSSARY/00#8 GLOSSARY/00#11 THE-THEORY-OF-BECOMING/00#5 THE-THEORY-OF-BECOMING/00#19 THE-THEORY-OF-BECOMING/01#5 THE-THEORY-OF-BECOMING/01#6
THE-THEORY-OF-BECOMING/01#8 01-ROOT/01#8 01-ROOT/03#7 01-ROOT/03#10 01-ROOT/04#12 07-SIGNIFICANCE/01#5 07-SIGNIFICANCE/04#1 07-SIGNIFICANCE/06#11
07-SIGNIFICANCE/06#12 08-METHOD/00#12 05-COLLECTIVES/05#4 08-METHOD/01#29 08-METHOD/01#30 01-ROOT/02#38 03-KNOWING/05#19
USES/01#2 ONE-PAGE/00#11 THE-THEORY-OF-BECOMING/00#9 08-METHOD/01#6 03-KNOWING/02#12 03-KNOWING/03#12 08-METHOD/01#9 01-ROOT/02#31 USES/00#3 USES/01#8'''.split()
SWAP = '''ONE-PAGE/00#19 08-METHOD/00#4 08-METHOD/00#25 01-ROOT/04#4 05-COLLECTIVES/04#34'''.split()
dec = {}
for m in man:
    p = m['piece']
    if not os.path.exists(f'{d}/{p}.v1.txt'): continue
    for i, (c, note) in verdicts(d, p).items():
        if c in 'NG': dec.setdefault(p, {})[str(i)] = 'A'
for s in KEEP:
    p, i = P(s); dec.setdefault(p, {})[i] = 'K'
for s in SWAP:
    p, i = P(s); dec.setdefault(p, {})[i] = 'A'
with open(d + '/decisions.json', 'w') as f: json.dump(dec, f, indent=0)
manual = [
 {'piece': 'COLLECTIVE-DIRECTION--00', 'find': 'Each law below is a theorem on its stated model.', 'old': 'Each law below', 'new': 'Each statement below'},
 {'piece': '05-COLLECTIVES--04', 'find': 'no market law ranks arrangements', 'old': 'no market law ranks arrangements', 'new': 'no theorem on markets ranks arrangements'},
 {'piece': '01-ROOT--01', 'find': 'A law written in the grammar', 'old': 'A law written in the grammar', 'new': 'A statement written in the grammar'},
 {'piece': '05-COLLECTIVES--04', 'find': 'what holds instead is a law of the whole distribution', 'old': 'a law of the whole distribution', 'new': 'a theorem on the whole distribution'},
 {'piece': '05-COLLECTIVES--00', 'find': '[the outrun law](#r-the-rest-outruns-the-renewal)', 'old': '[the outrun law](', 'new': '[the outrun theorem]('},
]
import re as _re
# link texts naming a theorem whose prose name changed
for nm in ['the commuting law', 'commuting law', 'the set-point law']:
    for m in man:
        if m.get('skip'): continue
        L = open(f"{d}/{m['piece']}.orig.md", encoding='utf-8').read().split('\n')
        for i, l in enumerate(L, 1):
            if '[' + nm + '](' in l and l.count('[' + nm + '](') == 1:
                manual_extra = {'piece': m['piece'], 'line': i, 'old': '[' + nm + '](', 'new': '[' + nm.replace('law', 'theorem') + ']('}
                manual.append(dict(manual_extra, find=None))

out = []
for e in manual:
    if e.get('find') is None:
        out.append({'piece': e['piece'], 'line': e['line'], 'old': e['old'], 'new': e['new']}); continue
    L = open(f"{d}/{e['piece']}.orig.md", encoding='utf-8').read().split('\n')
    idx = [i for i, l in enumerate(L, 1) if e['find'] in l]
    assert len(idx) == 1, (e, idx)
    out.append({'piece': e['piece'], 'line': idx[0], 'old': e['old'], 'new': e['new']})
with open(d + '/manual.json', 'w') as f: json.dump(out, f, indent=0)
# hold: the defining lines, rewritten by defs.py
hold = {}
for piece, starts in {'08-METHOD--04': ['**Law.** The word has three senses'], '08-METHOD--00': ['| law, theorem |'],
                      'GLOSSARY--00': ['| law (律, *lǜ*) |', '| shared law (共律']}.items():
    L = open(f'{d}/{piece}.orig.md', encoding='utf-8').read().split('\n')
    for s in starts:
        idx = [i for i, l in enumerate(L, 1) if l.startswith(s)]
        assert len(idx) == 1, (piece, s, idx)
        hold.setdefault(piece, []).append(idx[0])
with open(d + '/hold.json', 'w') as f: json.dump(hold, f)
print('decisions', sum(len(v) for v in dec.values()), 'manual', len(out), 'hold', hold)

# post edits: the second readers' REWORD findings, on the line as it stands after the swaps
import glob
SKIP = {('USES--01', 7, '2'), ('GLOSSARY--00', 72, '8'), ('FREE-ENERGY-PRINCIPLE--00', 123, '66'), ('05-COLLECTIVES--05', 12, '4'), ('08-METHOD--01', 169, '30')}
CUSTOM = {('THE-THEORY-OF-BECOMING--01', 62, '22'): ('A theorem, or a theorem of the root', 'A theorem as such, or one of the root'),
          ('THE-THEORY-OF-BECOMING--01', 63, '24'): ('Like any theorem it stands or falls', 'Like any other it stands or falls'),
          ('02-MAP--05', 33, '9'): ('Every theorem is a short composition', 'Every theorem here is a short composition')}
post = []
for f in sorted(glob.glob(d + '/R*.r1.txt')):
    for l in open(f, encoding='utf-8').read().split('\n'):
        m = re.match(r'(\S+) (\d+) (\S+) REWORD (.*?) => (.*)$', l.strip())
        if not m: continue
        key = (m.group(1), int(m.group(2)), m.group(3))
        if key in SKIP: continue
        old, new = CUSTOM.get(key, (m.group(4).strip(), m.group(5).strip()))
        post.append({'piece': key[0], 'line': key[1], 'old': old, 'new': new})
post.append({'piece': '08-METHOD--03', 'find': 'the stock theorem of the carrying lineages', 'old': 'the stock theorem of the carrying lineages', 'new': 'the stock theorem read on the carrying lineages'})
# 'theorem of X' where X is the subject and not the owner: 'theorem on X' (second pass of the coordinator)
if os.path.exists(d + '/of-on.json'):
    post += json.load(open(d + '/of-on.json'))
with open(d + '/post.json', 'w') as f: json.dump(post, f, indent=0, ensure_ascii=False)
print('post', len(post))
