"""AI-written (Fable, seat exact-model). (c) exploration: the value set again from what the stock just gave. A search, not a proof."""
import sys
from model import *

hi = int(sys.argv[1]) if len(sys.argv) > 1 else 12
L = int(sys.argv[2]) if len(sys.argv) > 2 else 1
g = tent(hi)
for mname, A in MOVES.items():
    print(f'--- tent {hi}, {mname}, read every {L}: rows start take 0..{hi+1}, columns start level 1..{hi}; one block per start held value')
    blocks = []
    for m0 in range(0, hi + 2):
        rows = []
        for x0 in range(0, hi + 2):
            row = ''
            for y0 in range(1, hi + 1):
                fate, step, _ = run(fast_O1(A, g), src_gave(g), every(L), ((x0, y0), m0), 2000, period=L)
                row += '.' if fate == 'goes on' else ('x' if fate == 'ends' else '?')
            rows.append(row)
        blocks.append(rows)
    for i in range(0, hi + 2, 7):
        chunk = blocks[i:i + 7]
        print('   ' + '  '.join(f'm0={i + j:<{hi - 3}}' for j in range(len(chunk))))
        for r in range(hi + 2):
            print(f'{r:2} ' + '  '.join(b[r] for b in chunk))
