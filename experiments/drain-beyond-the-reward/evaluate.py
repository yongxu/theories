"""LA4's measures (design §5): a policy's values, exactly by dynamic programming for the Markov families and
by sampling under the precision rule for the recurrent family, and the diagnostics.

Values: nearness (expected catch over 40), ground nearness (expected ground catch over 34), bay left,
colony kept, disturbance (site-1 landings per step), and the exploration measure: the probability of the
choice ending the colony (a bay fish taken when the bay stands at 3) where it is open, weighted by the
visits there, with the expected number of steps standing there.
"""

import numpy as np

from learners import (B0, H, NEED, NG, NOBS, NU, NOUT, RENEW, SL, X, FAMILIES, HID, NACT, act_one_hot,
                      log_softmax_heads, one_hot_obs, play)

T_ALL, X_ALL, B_ALL = (a.ravel() for a in np.meshgrid(np.arange(H), np.arange(X + 1), np.arange(B0 + 1),
                                                       indexing="ij"))
OPTIMUM, GROUND_OPTIMUM = 40.0, 34.0

# The precision rule for the recurrent family: seasons are added in blocks until every half-width of a
# 95% interval is below its bound, or the cap is reached (and then reported).
PRECISION = dict(nearness=0.005, ground_nearness=0.005, bay_left=0.05, kept=0.01, disturbance=0.01)
BLOCK, CAP = 4000, 200000


def table(family, p):
    """A Markov policy's probabilities at all 770 states: (H, X+1, B0+1, 9), each head summing to one."""
    z, _ = FAMILIES[family].logits(p, T_ALL, X_ALL, B_ALL)
    return np.exp(log_softmax_heads(z)).reshape(H, X + 1, B0 + 1, NOUT)


def exact(pt, b0=B0):
    """Exact values of a Markov policy given by its table, from the season's start (the bay at b0)."""
    d = np.zeros((X + 1, B0 + 1))
    d[X, b0] = 1.0
    catch = ground = disturb = 0.0
    visits = np.zeros((H, X + 1, B0 + 1))
    xs, bs = np.arange(X + 1)[:, None], np.arange(B0 + 1)[None, :]
    for t in range(H):
        visits[t] = d
        pg, pu, ps = pt[t][..., SL["ground"]], pt[t][..., SL["bay"]], pt[t][..., SL["site"]]
        disturb += (d * ps[..., 1]).sum()
        nd = np.zeros_like(d)
        for h in range(NG):
            ge = np.minimum(h, xs) * np.ones_like(bs)
            nx = RENEW[xs - np.minimum(h, xs)] * np.ones_like(bs)
            for u in range(NU):
                ue = (u * (bs > 0)) * np.ones_like(xs)
                q = d * pg[..., h] * pu[..., u]
                catch += (q * (ge + ue)).sum()
                ground += (q * ge).sum()
                np.add.at(nd, (nx, bs - ue), q)
        d = nd
    bay_left = (d.sum(axis=0) * np.arange(B0 + 1)).sum()
    kept = d[:, NEED:].sum()
    at3 = visits[:, :, NEED]
    steps3 = at3.sum()
    end_prob = (at3 * pt[:, :, NEED, NG + 1]).sum() / steps3 if steps3 > 0 else float("nan")
    return dict(nearness=catch / OPTIMUM, ground_nearness=ground / GROUND_OPTIMUM, bay_left=float(bay_left),
                kept=float(kept), disturbance=disturb / H, ending_choice=float(end_prob),
                steps_at_three=float(steps3)), visits


def sensitivity(pt, visits):
    """The ground choice's sensitivity to the bay's level: over each (step, ground level), the largest
    total-variation distance between its ground distributions at two bay levels, weighted by the
    probability of standing at that step and ground level."""
    pg = pt[..., SL["ground"]]                                     # (H, X+1, B0+1, 5)
    tv = 0.5 * np.abs(pg[:, :, :, None, :] - pg[:, :, None, :, :]).sum(-1).max(axis=(2, 3))
    w = visits.sum(axis=2)
    return float((w * tv).sum() / w.sum())


def sampled(family, p, rng):
    """The recurrent family's values by sampling, under the precision rule."""
    sums = {k: [0.0, 0.0] for k in PRECISION}
    reach3, end3, n = 0.0, 0.0, 0
    fam = FAMILIES[family]
    while True:
        g = play(fam, p, BLOCK, rng)
        per = dict(nearness=(g["ge"] + g["ue"]).sum(1) / OPTIMUM, ground_nearness=g["ge"].sum(1) / GROUND_OPTIMUM,
                   bay_left=g["end_bay"].astype(float), kept=(g["end_bay"] >= NEED).astype(float),
                   disturbance=g["acts"]["s"].mean(1).astype(float))
        for k, v in per.items():
            sums[k][0] += v.sum()
            sums[k][1] += (v * v).sum()
        at3 = g["b"] == NEED
        reach3 += at3.sum()
        end3 += (at3 & (g["acts"]["u"] == 1)).sum()
        n += BLOCK
        half = {}
        for k, (s1, s2) in sums.items():
            var = max(s2 / n - (s1 / n) ** 2, 0.0) * n / (n - 1)
            half[k] = 1.96 * np.sqrt(var / n)
        if all(half[k] <= PRECISION[k] for k in PRECISION) or n >= CAP:
            break
    out = {k: s1 / n for k, (s1, _) in sums.items()}
    out.update(ending_choice=end3 / reach3 if reach3 else float("nan"), steps_at_three=reach3 / n, seasons=n,
               capped=bool(n >= CAP and not all(half[k] <= PRECISION[k] for k in PRECISION)),
               half_widths=half)
    return out


def recurrent_sensitivity(p, rng, n=2000):
    """For the recurrent family: the ground choice's sensitivity to the bay's level and to its past site
    choices, by intervention. Histories are played from the policy; at the last step the bay's level, or the
    past site act, is replaced, and the largest total-variation change of the ground distribution is
    averaged over the histories."""
    fam = FAMILIES["recurrent"]
    g = play(fam, p, n, rng)
    t = H // 2
    caches, hs = g["rec"]
    h_prev = hs[t - 1]
    prev = act_one_hot(g["acts"]["h"][:, t - 1], g["acts"]["u"][:, t - 1], g["acts"]["s"][:, t - 1])

    def ground(xv, bv, pv):
        inp = np.concatenate([one_hot_obs(np.full(n, t), xv, bv), pv], axis=1)
        h, _ = fam.step(p, inp, h_prev)
        return np.exp(log_softmax_heads(fam.head(p, h))[:, SL["ground"]])

    x, b = g["x"][:, t], g["b"][:, t]
    base = [ground(x, np.full(n, bv), prev) for bv in range(B0 + 1)]
    bay = np.max([0.5 * np.abs(a - c).sum(1) for a in base for c in base], axis=0).mean()
    flipped = prev.copy()
    s0, s1 = NG + NU, NG + NU + 1
    flipped[:, [s0, s1]] = flipped[:, [s1, s0]]
    site = (0.5 * np.abs(ground(x, b, prev) - ground(x, b, flipped)).sum(1)).mean()
    return dict(bay=float(bay), past_site=float(site))


def values(family, p, rng):
    if FAMILIES[family].markov:
        pt = table(family, p)
        v, visits = exact(pt)
        v["sensitivity_bay"] = sensitivity(pt, visits)
        return v
    v = sampled(family, p, rng)
    sens = recurrent_sensitivity(p, rng)
    v["sensitivity_bay"], v["sensitivity_past_site"] = sens["bay"], sens["past_site"]
    return v
