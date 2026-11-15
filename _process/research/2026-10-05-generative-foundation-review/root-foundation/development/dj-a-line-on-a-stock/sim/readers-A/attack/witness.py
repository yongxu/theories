# AI-written (Fable, reader), 16 November 2026. Witnesses that the premises of fall and of line_ends
# (with a line that is a proper part of the way) hold together with a unit of the line present,
# and my own model for fall without `one`. Counts per kind.
from hand import step
three = lambda z: min(z, max(0, 12 - z))
def run(need, use, kids, g, c, x, n):
    out = []
    for _ in range(n):
        out.append("%s@%d" % (list(c), x)); c, x = step(need, use, kids, g, c, x)
    return " -> ".join(out)
print("fall, every premise (S = all, m = 1, use 7 > every giving of hump 12, kid itself):", run((1,), (7,), ((0,),), three, (1,), 12, 6))
print("line_ends, S = {D} of [D, O] (D doubles, O takes nothing and leaves itself):", run((1, 1), (1, 0), ((0, 0), (1,)), three, (1, 1), 12, 8))
g = lambda z: 0 if z == 0 else 3
print("fall without `one` (A need 1 use 3, B need 9 use 1, each leaves itself; giving 0 at 0, 3 above; takes 4 > 3):", run((1, 9), (3, 1), ((0,), (1,)), g, (1, 1), 10, 8))
