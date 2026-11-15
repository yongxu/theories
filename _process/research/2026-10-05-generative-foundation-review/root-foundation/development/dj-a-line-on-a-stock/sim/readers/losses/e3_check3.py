# AI-written (Fable reader, 16 Nov 2026). Simulation, not Lean. Third pass: premises of E3b, and the edge.
import io, contextlib
with contextlib.redirect_stdout(io.StringIO()):
    from e3_check import giving, course, unending
def show(g, label, w, x, n=6):
    c = course(g, w, x, n)
    print(label, [(list(way), lv) for way, lv in c], "unending" if unending(g, w, x) else "ENDS")
print("(i) a drawer that needs nothing, start 5 <= 12:")
show(giving, " A=(0,3), C=(5,0)", [(0, 3), (5, 0)], 5)
print("(iii) something given from nothing (WayOfUnits.GivenFromNothing.giving: 2 at 0 and at 2, else 0):")
def gfn(z): return 2 if z in (0, 2) else 0
for w, x in [([(1, 1), (3, 0)], 3), ([(2, 1), (4, 0)], 4), ([(1, 3), (6, 0)], 6)]:
    show(gfn, " " + str(w), w, x, 7)
print("edge: two drawers on Three.giving, start<=12, B met at start, B alone unending, B lost, A unending, use A > use B > 0:")
rows = []
for a in range(1, 13):
    for H in range(1, 8):
        for m in range(a + 1, 13):
            for h in range(1, H):
                for x in range(m, 13):
                    if not unending(giving, [(m, h)], x): continue
                    c = course(giving, [(a, H), (m, h)], x, 25)
                    if (m, h) in c[-1][0] or not unending(giving, [(a, H), (m, h)], x): continue
                    rows.append(((a, H), (m, h), x, c[-1][1], 2 * H))
print(" cases:", len(rows), "; final level != 2*useA:", sum(1 for r in rows if r[3] != r[4]), "; sample:", rows[:3])
