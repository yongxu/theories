from itertools import product
# I = E = {0,1,2}; listings LI = LE = [2]; one blanket state.
w = {(i, e): 0 for i in range(3) for e in range(3)}
w[(0, 0)] = 1; w[(1, 1)] = 1          # unlisted block not of product form
for LI, LE in (([2], [2]), ([0, 1, 2], [0, 1, 2])):
    Wb = sum(w[(i, e)] for i in LI for e in LE)
    WI = lambda i: sum(w[(i, e)] for e in LE)
    WE = lambda e: sum(w[(i, e)] for i in LI)
    held = all(w[(i, e)] * Wb == WI(i) * WE(e) for i in range(3) for e in range(3))
    cross = all(w[(i, e)] * w[(j, f)] == w[(i, f)] * w[(j, e)] for i, j, e, f in product(range(3), repeat=4))
    print('listings', LI, LE, ': held apart in counts =', held, ', cross form =', cross)
