"""The separable family's exact flow (LA4, design §3): expected-gradient ascent, computed exactly.

The separable policy has, at each state (t, x, b), a softmax over the ground's take (0..4), one
over the bay (0, 1) and one over the site (0, 1), with no shared parameters. Its expected
REINFORCE update is the gradient of the expected return, which dynamic programming over the season
gives exactly: for each head at state s, choice i,

    dJ/dlogit = d(s) * pi(i) * (Q_head(s, i) - V(s)),

with d(s) the probability of visiting s, Q_head the expected return after choosing i at that head
(the other heads drawn from the policy) and V the expected return from s. The flow here is plain
gradient ascent on the logits with these exact gradients; it is the reference curve, not a
sampled learner, and no optimizer state enters. The KL arm adds the design's term (§3), a loss of
beta times the exact KL divergence to the reference at each visited state, differentiated through
the policy at that state: its expected gradient is d(s) times the KL's gradient at s, with the
visits held fixed. That is the expected update of the design's loss. It is not the gradient of the
KL-penalized return, whose future penalties would enter V; the two have different fixed points.
The return's gradients agree with finite differences of the expected return; the KL term's with
finite differences of the visited states' summed KL, the visits held fixed.

Arms (design §4): A1 rising/uniform, A2 rising/prudent, A3 rising/prudent with KL to the prudent
start, A5 counted after/prudent, A6 unshared bay/prudent, C1 = A2 with the bay's and the site's
gradients removed (the separable family's exact form of the component control: their expected
update is zero there). The plateau (A4) is not run here.

Python 3.11, standard library only. Usage: python3 -B exact_flow.py [--steps N] [--lr R]
"""

import argparse
import json
import math
import sys

from season import SEASON, QUOTA, ETA, renew

X, R, K, H, B0, NEED = (SEASON[k] for k in ("X", "R", "K", "H", "B0", "NEED"))
STATES = [(t, x, b) for t in range(H) for x in range(X + 1) for b in range(B0 + 1)]
NEXT = {(x, h): renew(x - min(h, x), X, R) for x in range(X + 1) for h in range(K + 1)}

REWARDS = {
    "rising": lambda g, u: g + u,
    "unshared": lambda g, u: g,
    "after": lambda g, u: g + u * B0 / (B0 + 1),  # the constant B0 / (B0 + 1) is left out
}


def softmax(v):
    m = max(v)
    e = [math.exp(a - m) for a in v]
    z = sum(e)
    return [a / z for a in e]


def start_logits(kind):
    """Logits of the uniform start (all zero) or the prudent start (season.prudent's mixing)."""
    if kind == "uniform":
        ph, pu, ps = [1 / (K + 1)] * (K + 1), [0.5, 0.5], [0.5, 0.5]
    else:
        ph = [(1 - ETA) * (h == QUOTA) + ETA / (K + 1) for h in range(K + 1)]
        pu = [(1 - ETA) * (u == 0) + ETA / 2 for u in (0, 1)]
        ps = [(1 - ETA) * (s == 0) + ETA / 2 for s in (0, 1)]
    lg = lambda p: [math.log(a) for a in p]
    return {s: (lg(ph), lg(pu), lg(ps)) for s in STATES}


def policy(logits):
    return {s: tuple(softmax(v) for v in logits[s]) for s in STATES}


def evaluate(pi):
    """Exact expectations (catch, ground catch, bay left, colony kept, site-1 landings) and the
    probability of visiting each state."""
    cur = {(0, X, B0): 1.0}
    visits = {}
    catch = ground = disturb = 0.0
    for t in range(H):
        nxt = {}
        for (tt, x, b), w in cur.items():
            visits[(tt, x, b)] = w
            ph, pu, ps = pi[(tt, x, b)]
            disturb += w * ps[1]
            for h in range(K + 1):
                ge = min(h, x)
                for u in (0, 1):
                    ue = u if b > 0 else 0
                    q = w * ph[h] * pu[u]
                    catch += q * (ge + ue)
                    ground += q * ge
                    key = (t + 1, NEXT[(x, h)], b - ue)
                    nxt[key] = nxt.get(key, 0.0) + q
        cur = nxt
    bay_left = sum(w * b for (_, _, b), w in cur.items())
    kept = sum(w for (_, _, b), w in cur.items() if b >= NEED)
    return dict(catch=catch, ground=ground, bay_left=bay_left, kept=kept,
                disturbances=disturb), visits


def gradients(pi, visits, reward, reference=None, beta=0.0):
    """Exact expected gradients of the return (and of minus beta times the KL at visited states)
    with respect to every logit."""
    V = {}
    grads = {}
    for t in range(H - 1, -1, -1):
        for x in range(X + 1):
            for b in range(B0 + 1):
                s = (t, x, b)
                ph, pu, ps = pi[s]
                Q = [[0.0, 0.0] for _ in range(K + 1)]
                for h in range(K + 1):
                    ge = min(h, x)
                    for u in (0, 1):
                        ue = u if b > 0 else 0
                        after = V.get((t + 1, NEXT[(x, h)], b - ue), 0.0)
                        Q[h][u] = reward(ge, ue) + after
                v = sum(ph[h] * pu[u] * Q[h][u] for h in range(K + 1) for u in (0, 1))
                V[s] = v
                w = visits.get(s, 0.0)
                if w == 0.0:
                    grads[s] = ([0.0] * (K + 1), [0.0, 0.0], [0.0, 0.0])
                    continue
                qh = [sum(pu[u] * Q[h][u] for u in (0, 1)) for h in range(K + 1)]
                qu = [sum(ph[h] * Q[h][u] for h in range(K + 1)) for u in (0, 1)]
                qs = [v, v]  # the site reads nothing: its marginal return is V
                gh = [w * ph[i] * (qh[i] - v) for i in range(K + 1)]
                gu = [w * pu[i] * (qu[i] - v) for i in (0, 1)]
                gs = [w * ps[i] * (qs[i] - v) for i in (0, 1)]
                if beta:
                    out = []
                    for p, r in zip((ph, pu, ps), reference[s]):
                        kl = sum(a * (math.log(a) - math.log(c)) for a, c in zip(p, r) if a > 0)
                        out.append([-beta * w * a * (math.log(a) - math.log(c) - kl)
                                    for a, c in zip(p, r)])
                    gh = [a + c for a, c in zip(gh, out[0])]
                    gu = [a + c for a, c in zip(gu, out[1])]
                    gs = [a + c for a, c in zip(gs, out[2])]
                grads[s] = (gh, gu, gs)
    return grads, V[(0, X, B0)]


def run(arm, steps, lr, checkpoints):
    kind = "uniform" if arm == "A1" else "prudent"
    reward = REWARDS[{"A5": "after", "A6": "unshared"}.get(arm, "rising")]
    logits = start_logits(kind)
    reference = policy(start_logits("prudent")) if arm == "A3" else None
    beta = 1.0 if arm == "A3" else 0.0
    rows = []
    max_site = 0.0
    for n in range(steps + 1):
        pi = policy(logits)
        values, visits = evaluate(pi)
        if n in checkpoints:
            row = dict(step=n, nearness=values["catch"] / 40, ground_nearness=values["ground"] / 34,
                       bay_left=values["bay_left"], kept=values["kept"],
                       disturbances=values["disturbances"])
            rows.append(row)
        if n == steps:
            break
        grads, _ = gradients(pi, visits, reward, reference, beta)
        for s in STATES:
            gh, gu, gs = grads[s]
            if arm == "C1":
                gu, gs = [0.0, 0.0], [0.0, 0.0]
            max_site = max(max_site, abs(gs[0]), abs(gs[1])) if not beta else max_site
            lh, lu, ls = logits[s]
            logits[s] = ([a + lr * g for a, g in zip(lh, gh)], [a + lr * g for a, g in zip(lu, gu)],
                         [a + lr * g for a, g in zip(ls, gs)])
    return dict(arm=arm, lr=lr, steps=steps, largest_site_gradient=max_site, checkpoints=rows)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--steps", type=int, default=3000)
    ap.add_argument("--lr", type=float, default=2.0)
    ap.add_argument("--arms", default="A1,A2,A3,A5,A6,C1")
    args = ap.parse_args()
    marks = sorted({0, args.steps} | {int(round(args.steps ** (i / 24))) for i in range(25)})
    out = [run(a, args.steps, args.lr, set(marks)) for a in args.arms.split(",")]
    json.dump(out, sys.stdout, indent=1)
    print()


if __name__ == "__main__":
    main()
