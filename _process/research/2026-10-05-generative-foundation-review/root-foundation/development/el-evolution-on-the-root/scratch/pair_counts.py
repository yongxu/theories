"""Counts of a pair's run for WS2's design: R = steps at which the partner gave,
K = steps at which the formation withheld, over steps 0..n-1. Histories before step 0
are all giving. An error turns one intended giving into withholding (one formation, one step).
Scratch for the design only; the laws are to be proved in Lean."""
import sys
def sparer(own, other): return True
def withholder(own, other): return False
def answers(own, other): return other[-1]                     # one step, partner only
def window2(own, other): return other[-1] or other[-2]        # withholds only after two withholdings in a row
def wsls(own, other): return own[-1] == other[-1]             # win-stay lose-shift, reads own and partner
def grim(own, other): return own[-1] and other[-1]            # waitsAll with the self-wait
def alternator(own, other): return not own[-1]                # withholds at every other step
LAWS = dict(sparer=sparer, answers=answers, window2=window2, wsls=wsls, grim=grim, withholder=withholder, alternator=alternator)
def run(f, g, n, err=None):
    ha, hb = [True, True], [True, True]
    for t in range(n):
        a, b = f(ha, hb), g(hb, ha)
        if err == ('a', t): a = False
        if err == ('b', t): b = False
        ha.append(a); hb.append(b)
    A, B = ha[2:], hb[2:]
    return (sum(B), A.count(False)), (sum(A), B.count(False))
n = int(sys.argv[1]) if len(sys.argv) > 1 else 20
print(f"n={n}; each cell: (R, K) of the row's formation against the column's")
names = list(LAWS)
print("no error:")
for x in names:
    print(f"  {x:10}", ' '.join(f"{str(run(LAWS[x], LAWS[y], n)[0]):9}" for y in names))
print("one error by the row's formation at step 5, partner of the same law:")
for x in names:
    print(f"  {x:10}", run(LAWS[x], LAWS[x], n, ('a', 5)))
