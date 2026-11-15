# AI-written (Fable reader, 16 November 2026). D2 courses with the new need at 9. Seconds.
from try_d import run, alike
def lv(kinds, w, x, steps=9):
    c = run(kinds, w, x, steps)
    return [("".join(way), l) for way, l, _ in c]
S = ("S", (1, 1, ["S"]))
def K(chain, hneed):
    k = dict([S]); names = ["G"] + [f"G{i}" for i in range(1, chain + 1)]
    for i, n in enumerate(names):
        k[n] = (1, 4, [names[i + 1]] if i + 1 < len(names) else ["H"])
    k["H"] = (hneed, 4, ["H"]); return k
for chain in (0, 1, 2):
    for start in (9, 8):
        print(f"H(need 9) arrives at step {chain+1}, start {start}:", lv(K(chain, 9), ["G", "S"], start))
print("no new kind, start 9:", lv({"G": (1, 4, ["G"]), **dict([S])}, ["G", "S"], 9))
k = K(0, 9)
print("9~8 to [G,S]:", alike(k, ["G", "S"], 9, 8), "| 9~8 to [H,S]:", alike(k, ["H", "S"], 9, 8))
# directed variation is impossible in L: next way is a function of (way, class of level)
ws = {tuple(u for u in ["G", "S"] if k[u][0] <= z) for z in range(1, 13)}
print("next-way sources over levels 1..12 alike to [G,S]:", ws)
