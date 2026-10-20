"""Synthetic null for D1-D2 (written before any real value was read): files in the layout of Dai
et al.'s bifurcation data (8 x 11 plate per dilution factor and day, days 1-7), generated from the
Markov two-phase model of yeast.py (state = density only), with 88 populations per DF started on a
log-spaced series 1e2..1e6 cells/ul and additive measurement noise N(0, 50) on every reading (an
assumed instrument noise; it produces negative readings near zero, as the real files show).
yeast_data.py run on these files says how D1/D2 and D1'/D2' behave where density is the state.

    python3 synth_null.py <out_dir>
"""
import os
import random
import sys

import yeast as Y

DFS = [250, 500, 750, 1000, 1133, 1266, 1400, 1600]


def main(out):
    os.makedirs(out, exist_ok=True)
    rng = random.Random(1)
    for df in DFS:
        pops = []
        for i in range(88):
            c = Y.Culture(df, 10 ** (2 + 4 * (i % 11) / 10), rng)
            traj = []
            for _ in range(7):
                c.day()
                traj.append(c.x + rng.gauss(0, 50))
            pops.append(traj)
        for d in range(7):
            with open(os.path.join(out, f"dilution{df}_day{d + 1}.txt"), "w") as f:
                for r in range(8):
                    f.write("  ".join("%.7e" % pops[r * 11 + k][d] for k in range(11)) + "\n")


if __name__ == "__main__":
    main(sys.argv[1])
