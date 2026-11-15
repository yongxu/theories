# AI-written (Fable reader, 16 Nov 2026). Simulation, not Lean. Second pass: refined break attempts.
import itertools
from e3_check import giving, step, course, unending, show
units = [(n, u) for n in (1, 4, 7, 10, 15) for u in (0, 1, 2, 3, 5)]
ways3 = list(itertools.combinations_with_replacement(units, 3))
# E3b: a unit met at the start is lost and no drawer is ever lost (some drawer present)
vin, vab, ex = 0, 0, None
for w in ways3:
    if not any(u[1] > 0 for u in w): continue
    for x in range(1, 21):
        last = course(giving, w, x, 25)[-1][0]
        lost = [u for u in w if u not in last]
        if any(u[0] <= x for u in lost) and not any(u[1] > 0 for u in lost):
            if x <= 12: vin += 1
            else:
                vab += 1
                if ex is None: ex = (w, x)
print("E3b: bystander lost, no drawer lost; start<=12:", vin, "; start>12:", vab, ex)
# many-unit greater_need, nontrivial: raise the need of a unit that is not of least need
cnt, found = 0, None
for w in ways3:
    for x in range(1, 13):
        if not unending(giving, w, x): continue
        lo = min(u[0] for u in w)
        for i in range(3):
            if w[i][0] == lo and sum(1 for u in w if u[0] == lo) == 1: continue
            for m2 in (4, 7, 10, 15):
                if m2 <= w[i][0]: continue
                w2 = list(w); w2[i] = (m2, w[i][1])
                if not unending(giving, w2, x):
                    cnt += 1
                    if found is None or sum(u[1] for u in w) < sum(u[1] for u in found[0]): found = (w, x, i, m2)
print("3 units: raising a non-least need ends a line that did not end:", cnt, found)
if found:
    w, x, i, m2 = found
    show("before", list(w), x, 8); w2 = list(w); w2[i] = (m2, w[i][1]); show("after ", w2, x, 8)
