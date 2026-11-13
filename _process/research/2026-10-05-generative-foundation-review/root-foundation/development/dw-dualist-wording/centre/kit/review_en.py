#!/usr/bin/env python3
"""review_en <tree>: the review packet's own copies of the centre (README lead, three dossier leads), from the same blocks."""
import sys, glob, os
tree = sys.argv[1]
src = open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'centre_en.py'), encoding='utf-8').read()
ns = {}; exec(src.split("bad = 0\nfor path, lst in E.items():")[0].replace("tree = sys.argv[1]", "tree = ''"), ns)
g = ns
R = 'theories/becoming/review/'
E = {}
def ed(path, old, new, n=1): E.setdefault(path, []).append((old, new, n))
ed(R + 'README.md', 'what a selection (a reward, a judge, a market, a vote, a training run) reaches, what it drains beyond what it reads, how it comes to lock on what it already chose, and how winning comes to buy power over the rule that selects: the loop the work calls the [meta-attractor](../../meta-attractor/README.md); its closed form, where the rule and how it is read are both formed from the share it selects, can lock: on stated models, where selection does not lower the favoured share and the rule and its reading follow it upward and keep favouring it, a locked start stays locked however large an unread loss grows',
   f"{g['T']}. Where what a selection raises comes to set the selection, the loop is what the work calls the [meta-attractor](../../meta-attractor/README.md); its closed form, where what is selected next and {g['RULE']} as each step sets it again follow from the share and the rule alone, how the rule is set again being formed from the share too, can lock: on stated models, {g['L_LOCK']}, a locked start stays locked however large a loss grows that makes no difference to either")
for f in ('PHILOSOPHY.md', 'SCIENCES.md'):
    ed(R + f, 'drawn first for alignment: what a selection reaches, what it drains beyond what it reads, how it locks on what it already chose.', f"drawn first for alignment: {g['T0']}.")
ed(R + 'ALIGNMENT.md', 'what can it select for, and when does it come to select for control over its own rules?', 'which differences make a difference to it, and when does shaping its rule become what it selects for?')
bad = 0
for p in sorted(glob.glob(f'{tree}/{R}*.md')):
    if p.endswith('.zh.md'): continue
    rel = os.path.relpath(p, tree); s = open(p, encoding='utf-8').read(); t = s
    for old, new, n in E.get(rel, []):
        k = t.count(old)
        if k != n: print('MISMATCH', rel, k, old[:70]); bad += 1; continue
        t = t.replace(old, new)
    for a, b in ((g['AIM_OLD'], g['AIM']), (g['G1o'], g['G1']), (g['G2o'], g['G2']), (g['G3o'], g['G3']), (g['G4o'], g['G4'])):
        t = t.replace(a, b)
    if t != s:
        with open(p, 'w', encoding='utf-8') as fh: fh.write(t)
        print('edited', rel)
sys.exit(1 if bad else 0)
