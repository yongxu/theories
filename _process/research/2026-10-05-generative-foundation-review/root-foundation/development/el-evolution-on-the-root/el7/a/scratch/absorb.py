"""Minimal error counts to absorb a pair in total withholding; exact absorption probabilities under
i.i.d. one-way errors. Design checks only."""
from itertools import product
from fractions import Fraction as F
import sys

def window_law(w):
    return lambda own_hist, par_hist: any(par_hist[:w])   # hist[0] = last step

def run_hist(lawf, lawg, errs, n, H=4):
    """errs: set of (t, side). histories newest first, all giving before 0."""
    h1, h2 = [True]*H, [True]*H
    P, Q = [], []
    for t in range(n):
        a = lawf(h1, h2) and (t, 0) not in errs
        b = lawg(h2, h1) and (t, 1) not in errs
        P.append(a); Q.append(b)
        h1, h2 = [a] + h1[:-1], [b] + h2[:-1]
    return P, Q

def absorbed_at(P, Q, w):
    """first step from which both withhold at w consecutive steps (then total withholding is kept)"""
    for t in range(len(P) - w + 1):
        if not any(P[t:t+w]) and not any(Q[t:t+w]):
            return t + w - 1
    return None

def min_errors(lawf, lawg, w, n=10):
    best = None
    cells = [(t, s) for t in range(n) for s in (0, 1)]
    for k in range(1, 9):
        from itertools import combinations
        for c in combinations(cells, k):
            P, Q = run_hist(lawf, lawg, set(c), n + 6)
            # absorbed: both withhold for w consecutive steps at the end AND keep withholding with no more errors
            if not any(P[-w:]) and not any(Q[-w:]) and not any(P[n:]) and not any(Q[n:]):
                return k, c
    return None

answering = window_law(1)
for w in (1, 2, 3, 4):
    print('window', w, 'min errors to absorb a pair of holders:', min_errors(window_law(w), window_law(w), w, n=2*w+3))
grim = lambda o, p: o[0] and p[0]
print('grim (waitingBoth)', min_errors(grim, grim, 1, n=4))
