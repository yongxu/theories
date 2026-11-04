"""Stage 0 of TR7's Stage A (FREEZE-9.md, sections 3 and 5): exact values computed before any training.

    python3 -B tr7a_stage0.py         # writes results/stage0.json in under a second; trains nothing

1. The reference curves at Stage A's step size and steps: tr7.py's flow_told and flow_tied, which ascend
   the expected value exactly, and flow_mixture here for the mixture learner, from each run's start: the
   deterministic curve a learner follows to first order in a step's noise, since each step's estimate is
   unbiased at the current logits (tr7a_stage.py). The run shows how far sampled paths depart from it, at
   the ties especially, where the curve's even split is no seed's expectation.
2. At each run's start, the first-order movement of the statistic the reading signs (the maximal plans'
   share for a told learner, the distance to the best chance for a chance learner, the weight for the
   mixture learner) under one step of the expected gradient, and the exact variance of one episode's
   estimate of it, enumerated over every act and draw of the game, so the one-step signal-to-noise at
   Stage A's batch. An indicator of the noise against the drift, not the chance a seed moves the law's way,
   which only the run measures.
3. The exact power of the sign test: for n seeds and a chance q that a seed moves the law's way, the
   chance the run is supported (at least the critical count of n); and for a chance r that a seed moves
   against it, the chance the run is contradicted.
4. For a chance learner whose best chance lies inside (0, 1), the spread its chance keeps about it once
   there, linearized: at an interior best chance the expected gradient vanishes but one episode's estimate
   does not, so the chance fluctuates about it, and more steps do not shrink the spread.
Standard library only; nothing here samples, and nothing trains a learner.
"""

import json
import math
import sys
from fractions import Fraction
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import tr7a_stage as S        # noqa: E402
import tr7a_reading as RD     # noqa: E402
import tr7                    # noqa: E402

Fr = Fraction


def flow_mixture(s, a0, steps, lr):
    """One draw before the read stage, complyAtBoth with weight a = sigmoid(theta), else ownAtBoth,
    ascending the expected value exactly: d/dtheta of a ev(complyAtBoth) + (1 - a) ev(ownAtBoth)."""
    th = math.log(a0 / (1 - a0))
    diff = float(tr7.ev(s, tr7.CAB) - tr7.ev(s, tr7.OAB))
    for _ in range(steps):
        a = 1 / (1 + math.exp(-th))
        th += lr * diff * a * (1 - a)
        th = max(min(th, S.CLIP), -S.CLIP)
    return round(1 / (1 + math.exp(-th)), 4)


def reference_end(run):
    name, cid, learner, start, role = run
    s = S.prospects(cid)
    if learner == "told":
        res = tr7.flow_told(s, {p: start[k] for k, p in enumerate(tr7.PLANS)}, steps=S.STEPS["told"], lr=S.LR)
        return [res[n] for n in S.NAMES]
    if learner == "mixture":
        return flow_mixture(s, float(start), S.STEPS["mixture"], S.LR)
    return tr7.flow_tied(s, float(start), steps=S.STEPS["chance"], lr=S.LR)


def kept_chance(s, first):
    return Fr(s.keptComplying if first == tr7.COMPLY else s.keptOwn, s.total)


def points(s, acts, kept):
    return (-s.cost if acts[0] == tr7.COMPLY else 0) + (s.value if acts[1] == tr7.OWN and kept else 0)


def episode_outcomes(run, policy):
    """Every outcome of one episode at the policy: (probability, score vector or scalar, points), exactly
    (the policy's floats aside). The score is the log-probability's gradient in the learner's parameters."""
    name, cid, learner, start, role = run
    s = S.prospects(cid)
    out = []
    if learner == "told":
        for a, plan in enumerate(tr7.PLANS):
            for kept in (True, False):
                pk = float(kept_chance(s, plan[0]))
                prob = policy[a] * (pk if kept else 1 - pk)
                score = [(1.0 if k == a else 0.0) - policy[k] for k in range(4)]
                out.append((prob, score, points(s, plan, kept)))
        return out
    p = policy
    if learner == "mixture":
        acts_list = [((tr7.COMPLY, tr7.COMPLY), p, 1 - p), ((tr7.OWN, tr7.OWN), 1 - p, -p)]
    else:
        acts_list = []
        for c1 in (True, False):
            for c2 in (True, False):
                acts = (tr7.COMPLY if c1 else tr7.OWN, tr7.COMPLY if c2 else tr7.OWN)
                acts_list.append((acts, (p if c1 else 1 - p) * (p if c2 else 1 - p), int(c1) + int(c2) - 2 * p))
    for acts, pa, score in acts_list:
        for kept in (True, False):
            pk = float(kept_chance(s, acts[0]))
            out.append((pa * (pk if kept else 1 - pk), score, points(s, acts, kept)))
    return out


def one_step(run):
    """The statistic's first-order movement under one step of the expected gradient at the start (its
    gradient in the logits, dotted with the step), and one episode's estimate's standard deviation, with the
    baseline at the expected points (the leave-one-out baseline's limit), so the signal-to-noise of a step's
    estimate at Stage A's batch."""
    name, cid, learner, start, role = run
    pol = RD.start_policy(run)
    outs = episode_outcomes(run, pol)
    vbar = sum(pr * pts for pr, _, pts in outs)
    if learner == "told":
        idx = [S.NAMES.index(n) for n in RD.target(run)]
        share = sum(pol[k] for k in idx)
        # d(share)/d(theta_j) = pi_j (1[j in M] - share)
        grad_share = [pol[j] * ((1.0 if j in idx else 0.0) - share) for j in range(4)]
        u = [(pr, (pts - vbar) * sum(g * sc for g, sc in zip(grad_share, score))) for pr, score, pts in outs]
    else:
        if learner == "mixture":
            sign = -1.0                                       # the weight should fall
        else:
            sign = 1.0 if float(RD.target(run)) > float(start) else -1.0   # toward the best chance
        dp = pol * (1 - pol)                                  # d p / d theta
        u = [(pr, sign * dp * (pts - vbar) * score) for pr, score, pts in outs]
    mean = sum(pr * x for pr, x in u)
    var = sum(pr * (x - mean) ** 2 for pr, x in u)
    sd = math.sqrt(var)
    snr = (round(math.sqrt(S.BATCH) * mean / sd, 3) if sd > 1e-12 else
           "no noise at the expected-points baseline" if mean > 0 else "no movement")
    return {"first-order movement per step (lr x mean)": round(S.LR * mean, 6),
            "one episode's standard deviation": round(sd, 6),
            "signal-to-noise of one step at the batch": snr}


def settled_spread(run):
    """For a chance learner whose best chance p* lies inside (0, 1), the spread its chance keeps about p*
    once there, linearized: near p* a step moves the logit by -kappa (theta - theta*) on average, with
    kappa = -lr ev''(p*) (p*(1 - p*))^2, and by a noise of spread sigma = lr sd / sqrt(batch), sd one
    episode's estimate's at p* with the baseline at the expected points; the logit's stationary spread is
    sigma / sqrt(1 - (1 - kappa)^2), and the chance's p*(1 - p*) times that. An approximation, not a bound.
    None for any other learner."""
    name, cid, learner, start, role = run
    s = S.prospects(cid)
    ps = float(tr7.best_chance(s))
    if learner != "chance" or not 0 < ps < 1:
        return None
    outs = episode_outcomes(run, ps)
    vbar = sum(pr * pts for pr, _, pts in outs)
    xs = [(pr, (pts - vbar) * score) for pr, score, pts in outs]
    m = sum(pr * x for pr, x in xs)
    sd = math.sqrt(sum(pr * (x - m) ** 2 for pr, x in xs))
    evpp = 2 * (s.keptOwn - s.keptComplying) * s.value / s.total     # ev_fresh's second derivative
    w = ps * (1 - ps)
    kappa = -S.LR * evpp * w * w
    sigma = S.LR * sd / math.sqrt(S.BATCH)
    return round(w * sigma / math.sqrt(1 - (1 - kappa) ** 2), 4)


def power(n, q, k):
    """The exact chance of at least k successes in n independent seeds, each a success with chance q."""
    q = Fr(q)
    return sum(math.comb(n, j) * q ** j * (1 - q) ** (n - j) for j in range(k, n + 1))


def main():
    runs = {}
    for run in S.RUNS:
        runs[run[0]] = {"condition": run[1], "learner": run[2], "role": run[4], "target": str(RD.target(run)),
                        "start": list(run[3]) if run[2] == "told" else str(run[3]),
                        "reference end": reference_end(run), **one_step(run)}
        if settled_spread(run) is not None:
            runs[run[0]]["settled spread about the best chance, linearized"] = settled_spread(run)
    qs = ["1/2", "3/5", "7/10", "4/5", "9/10", "19/20", "99/100", "1"]
    table = {}
    for n in (5, 10, 20, 30):
        ks, kc = RD.critical(n, RD.ALPHA_SUPPORT), RD.critical(n, RD.ALPHA_CONTRA / len(RD.VERDICT_RUNS))
        table[str(n)] = {"support at": ks, "contradiction at": kc,
                         "chance supported, by q": {q: round(float(power(n, q, ks)), 4) for q in qs},
                         "chance contradicted, by r": {r: (round(float(power(n, r, kc)), 4) if kc else None)
                                                       for r in qs}}
    out = {"step size": S.LR, "steps": S.STEPS, "batch": S.BATCH, "seeds": S.SEEDS,
           "reference ends": {k: v["reference end"] for k, v in runs.items()}, "runs": runs,
           "sign test's power": table,
           "note": "q is the chance a seed moves the law's way, r the chance it moves against it; the run "
                   "measures both. The signal-to-noise is of one step at the start, an indicator, not a chance."}
    path = HERE / "results" / "stage0.json"
    path.parent.mkdir(exist_ok=True)
    path.write_text(json.dumps(out, indent=1) + "\n")
    for k, v in runs.items():
        print(f"{k:30s} end {v['reference end']}  snr {v['signal-to-noise of one step at the batch']}",
              f" settled spread {v['settled spread about the best chance, linearized']}"
              if "settled spread about the best chance, linearized" in v else "")
    print("power at 20 seeds:", table["20"]["chance supported, by q"])


if __name__ == "__main__":
    main()
