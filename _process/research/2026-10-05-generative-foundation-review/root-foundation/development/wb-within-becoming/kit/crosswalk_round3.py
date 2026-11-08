#!/usr/bin/env python3
"""WB: the crosswalk after the readers' third round (round3-fable.md, finding 3). The entries still said that a ranking
"needs" the continuation condition and C, or "needs C or another order": the first makes the condition necessary for
any loss to count (07 §4, 07:481 and COLLECTIVE-DIRECTION:76 say narrower scopes count particular ones), the second
says ranking courses still needs an order, a framing Ren's words of 8 November 2026 set aside. Re-said as the homes
say it: a ranking rests on C or another named order, with the condition, or a narrower scope, for whose losses count."""
import json, pathlib, re, sys
P = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else '.') / 'theories/becoming/results/atlas/entries/correspondences.json'
s = P.read_text(encoding='utf-8')
n = {}
def sub(pat, rep, flags=0):
    global s
    s, k = re.subn(pat, rep, s, flags=flags); n[pat[:50]] = k
verb = lambda m: {'needs': 'rests', 'need': 'rest'}[m.group(1)]
sub(r'\b(needs|need) the continuation condition for scope and C for order\b',
    lambda m: f'{verb(m)} on a named scope and order, most often the continuation condition and C')
sub(r'whose losses count needs the continuation condition\b',
    "whose losses count is the continuation condition's reading, narrower scopes counting particular ones")
sub(r'Whether the loss counts needs the continuation condition; any ranking, C\.',
    "Whether the loss counts is the continuation condition's reading, narrower scopes counting particular ones; any ranking rests on C or another named order.")
sub(r'\b(needs|need) C,? \(order\) or another order\b', lambda m: f'{verb(m)} on C (order) or another named order')
sub(r'\b(needs|need) C,? for order,? or another order\b', lambda m: f'{verb(m)} on C or another named order')
sub(r'\b(needs|need) C,? or another order,? for order\b', lambda m: f'{verb(m)} on C or another named order')
sub(r'\b(needs|need) C,? or another order\b', lambda m: f'{verb(m)} on C or another named order')
sub(r'\bneeds C or a premise\b', 'rests on C or another named order')
json.loads(s)
P.write_text(s, encoding='utf-8')
for k, v in n.items(): print(v, k)
