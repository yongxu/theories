"""AI-written (Fable). Checks model.py against kept examples of the Lean:
LineOnAStock.HigherStartEnds.from_six (:1810), from_seven (:1825), Doubling is not used.
Also the countermodel of the try of 16 November for order B (report.json, false_or_empty 1)."""
from model import *

A, B, C = 0, 1, 2
W = World(need=(1, 3, 12), use=(3, 1, 1), give=(0, 0, 0), kids=((B, B), (C, B), (A,)), g=hump12)
ok = True
for order in ("L", "B"):
    c6 = course(W, ((A,), 6), 5, order)
    c7 = course(W, ((A,), 7), 5, order)
    exp6 = {1: ((B, B), 6), 2: ((C, B, C, B), 8), 3: ((C, B, C, B), 8)}
    exp7 = {1: ((B, B), 8), 2: ((C, B, C, B), 12), 3: ((A, C, B, A, C, B), 12),
            4: ((B, B, A, C, B, B, B, A, C, B), 4)}
    for j, e in exp6.items():
        ok &= (c6[j] == e)
    for j, e in exp7.items():
        ok &= (c7[j] == e)
    ok &= len(c7[5][0]) == 16 and c7[5][1] == 0 and not goes(W, c7[5])
    ok &= all(goes(W, s) for s in c6)
    # counts agree with lists
    f6 = fate(W, (1, 0, 0), 6, order)
    f7 = fate(W, (1, 0, 0), 7, order)
    print(order, "from six", c6[:4], f6)
    print(order, "from seven", c7[:5], "len5", len(c7[5][0]), "level5", c7[5][1], f7)
    ok &= f6[0] == "never" and f7 == ("ends", 5)
print("HigherStartEnds reproduced in both orders at give = 0:", ok)

# 16 November's countermodel for order B: g = 0, a taker of 5 needing nothing, a giver (need 1, gives 4)
W2 = World(need=(1, 0), use=(0, 5), give=(4, 0), kids=((0,), (1,)), g=g_zero)
print("B from 4:", [s[1] for s in course(W2, ((0, 1), 4), 4, "B")], "(report: stays at 4)")
print("L from 4:", [s[1] for s in course(W2, ((0, 1), 4), 4, "L")])
