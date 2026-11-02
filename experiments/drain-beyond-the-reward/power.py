"""LA4 Stage A's power check (design §7), run before the freeze through the frozen verdict code, at the
planned 20 seeds and the run's checkpoints. It reads simulated results, never the test's runs.

Two kinds of learner:
- the separable baseline, sampled, on the power check's seeds 1000 to 1019 (run.py --power), which are
  disjoint from the test's; its expected update is the exact flow's, already computed (§12), so running it
  shows nothing about the families tested;
- scripted learners: each arm's curves taken from the exact flow (exact_flow.json) or from the sampled
  baseline's means, warped in time and given noise seed by seed, then changed to act out T3's pattern, each rival of §7, learners whose answers are
  fixed, and the failure cases the review named (stalled learning, reversals, repeated crossings of a
  level, arms reaching different ranges).

Each scripted case states the outcome each prediction should reach. A case is simulated REPS times for both
tested families at once (so Holm runs over 24 p-values, as in the test), and the share of repetitions
reaching the stated outcome is its power. A rule whose power is below 0.8 on its case, or which reports a
forbidden case under any form of T3's pattern in more than 5% of repetitions, is changed before the freeze (design §7).
The sweep's smaller effects are reported, not gated: they show what each margin lets through.

Usage: python3 -B power.py [--reps N] > results/power.json
"""

import argparse
import copy
import glob
import json
import multiprocessing as mp
import os
import sys

import numpy as np

import verdicts as V

HERE = os.path.dirname(os.path.abspath(__file__))
SEEDS = 20
REPS = 200
KEYS = ("nearness", "ground_nearness", "bay_left", "kept", "disturbance")


def exact_curves():
    """{arm: {measure: array over the 25 checkpoints}} from the exact flow, with A4 and C1u added: the
    uniform start's curves for C1u with the bay and the colony as at the uniform start, and A4 as A1 (the
    plateau is reported only)."""
    out = {}
    for r in json.load(open(os.path.join(HERE, "exact_flow.json"))):
        c = r["checkpoints"]
        out[r["arm"]] = dict(update=np.array([x["step"] for x in c], float),
                             nearness=np.array([x["nearness"] for x in c]),
                             ground_nearness=np.array([x["ground_nearness"] for x in c]),
                             bay_left=np.array([x["bay_left"] for x in c]), kept=np.array([x["kept"] for x in c]),
                             disturbance=np.array([x["disturbances"] for x in c]) / 10)
    a1 = out["A1"]
    gain = a1["ground_nearness"] * 34
    out["C1u"] = dict(a1, bay_left=np.full_like(a1["bay_left"], a1["bay_left"][0]),
                      kept=np.full_like(a1["kept"], a1["kept"][0]),
                      nearness=(gain + 6 - a1["bay_left"][0]) / 40)
    out["A4"] = dict(a1)
    return out


def baseline_curves():
    """{arm: {measure: array}}: the sampled separable baseline's means over its 20 seeds (run.py --power), a
    second form of T3's pattern, from a learner that leaves the exact flow's stall at 0.85."""
    arms = {}
    for f in sorted(glob.glob(os.path.join(HERE, "results", "power-runs", "separable-*.json"))):
        r = json.load(open(f))
        arms.setdefault(r["arm"], []).append(r["checkpoints"])
    out = {}
    for a, runs in arms.items():
        out[a] = dict(update=np.array([c["update"] for c in runs[0]], float),
                      **{k: np.mean([[c[k] for c in run] for run in runs], axis=0) for k in KEYS})
    return out


def warp(curve, shift):
    """The curve read `shift` checkpoints later (earlier if negative), held at its ends. The checkpoints are
    log-spaced, so a shift of one is a factor of about 1.45 in updates."""
    idx = np.arange(len(curve))
    return np.interp(np.clip(idx - shift, 0, idx[-1]), idx, curve)


def records(curves, rng, noise=1.0, explore=None, arm_jitter=0.2, seed_shift=1.0, stalled=0, vary=None):
    """{arm: {seed: record}} from curves, shifted and noised seed by seed; a seed's shift is shared by its
    arms, so the arms are paired as in the run. The sampled baseline's seeds differ in their half-way
    checkpoint by a standard deviation of 0.02 to 0.07 (the separable family, whose initial parameters do not
    vary); a shift of 1 is some twenty times that. The first `stalled` seeds never leave the start, in every
    arm. `vary(seed, curves)` gives a seed its own curves (seeds that settle differently). Exploration, unless
    `explore` sets it: a seed resolves the ending choice's advantage where its bay, before noise, falls below
    the colony's need of 3 at some checkpoint, so it has stood at 3 and taken; a seed that never does, does
    not."""
    out = {a: {} for a in curves}
    base = curves
    for s in range(SEEDS):
        shift = float(seed_shift * rng.standard_normal())
        curves = vary(s, base) if vary else base
        for a, c in curves.items():
            sh = shift + float(arm_jitter * rng.standard_normal())
            if s < stalled:
                sh = 10 ** 6
            rows = []
            vals = {k: warp(c[k], sh) for k in KEYS}
            vals["nearness"] = vals["nearness"] + noise * 0.004 * rng.standard_normal(len(c["update"]))
            vals["ground_nearness"] = vals["ground_nearness"] + noise * 0.004 * rng.standard_normal(len(c["update"]))
            vals["bay_left"] = np.clip(vals["bay_left"] + noise * 0.25 * rng.standard_normal(len(c["update"])), 0, 6)
            vals["kept"] = np.clip(vals["kept"] + noise * 0.04 * rng.standard_normal(len(c["update"])), 0, 1)
            vals["disturbance"] = np.clip(vals["disturbance"] + noise * 0.01 * rng.standard_normal(len(c["update"])), 0, 1)
            took = bool((vals["bay_left"] < 3).any()) and s >= stalled
            for k in KEYS:
                vals[k][0] = c[k][0]                    # every seed starts at the arm's start exactly
            for i, u in enumerate(c["update"]):
                rows.append(dict(update=float(u), **{k: float(vals[k][i]) for k in KEYS},
                                 head_norms=dict(ground=1.0, bay=1.0, site=1.0)))
            ex = took if explore is None else explore(s) if callable(explore) else explore
            out[a][s] = dict(checkpoints=rows, exploration=[dict(resolved=bool(ex))])
    return out


# ---------------------------------------------------------------- the cases

def t3(c):
    return c


def carried_restraint(c, size=1.0):
    """Ground restraint carries to the bay: the bay is kept, and kept more, as nearness rises."""
    c = copy.deepcopy(c)
    for a in ("A1", "A2", "A3", "A5"):
        prog = (c[a]["nearness"] - c[a]["nearness"][0]) / max(1e-9, c[a]["nearness"].max() - c[a]["nearness"][0])
        c[a]["bay_left"] = np.minimum(6, c[a]["bay_left"][0] + size * prog)
        c[a]["kept"] = np.minimum(1, c[a]["kept"][0] + 0.3 * size * prog)
    return c


def carried_taking(c, size=0.15):
    """Taking learned at the bay carries to the site: disturbance rises in the arms, not in the control."""
    c = copy.deepcopy(c)
    for a in ("A2", "A3", "A5", "A6"):
        prog = np.linspace(0, 1, len(c[a]["update"]))
        c[a]["disturbance"] = c[a]["disturbance"][0] + size * prog
    return c


def habit(c, share=1.0):
    """Training drains what it can take, counted or not: the unshared bay drains as the counted one (or by
    a share of its drain)."""
    c = copy.deepcopy(c)
    c["A6"]["bay_left"] = c["C1"]["bay_left"] + share * (c["A2"]["bay_left"] - c["C1"]["bay_left"])
    c["A6"]["kept"] = c["C1"]["kept"] + share * (c["A2"]["kept"] - c["C1"]["kept"])
    return c


def habit_as_far(c):
    """T3's refuter on the locus: the unshared bay falls as far as the counted one at matched ground
    nearness. A6's bay at each checkpoint is A2's bay where A2 stood at A6's ground nearness."""
    c = copy.deepcopy(c)
    g2, b2, k2 = c["A2"]["ground_nearness"], c["A2"]["bay_left"], c["A2"]["kept"]
    order = np.argsort(g2)
    g6 = np.minimum(c["A6"]["ground_nearness"], g2.max())
    c["A6"]["bay_left"] = np.interp(g6, g2[order], b2[order])
    c["A6"]["kept"] = np.interp(g6, g2[order], k2[order])
    return c


def inert_prior(c):
    """The restraint is never sampled away: the bay and the colony stay as at the start."""
    c = copy.deepcopy(c)
    for a in ("A2", "A3", "A5"):
        c[a]["bay_left"] = np.full_like(c[a]["bay_left"], 5.0)
        c[a]["kept"] = np.full_like(c[a]["kept"], 0.987)
        c[a]["nearness"] = c["C1"]["nearness"].copy()
        c[a]["ground_nearness"] = c["C1"]["ground_nearness"].copy()
    return c


def erosion(c):
    """Noise or decay wears the prior preference at the site away, in the arms and the control alike."""
    c = copy.deepcopy(c)
    for a in ("A2", "A3", "A5", "A6", "C1"):
        prog = np.linspace(0, 1, len(c[a]["update"]))
        c[a]["disturbance"] = c[a]["disturbance"][0] + 0.15 * prog
    return c


def protected_after(c):
    """Protection by a term counted after: A5 keeps the bay at 3 at the end while A2 drains."""
    c = copy.deepcopy(c)
    prog = np.linspace(0, 1, len(c["A5"]["update"]))
    c["A5"]["bay_left"] = 5.0 - 2.0 * prog
    c["A5"]["kept"] = np.full_like(prog, 0.98)
    return c


def no_anchor(c):
    """The KL term does nothing: A3 as A2."""
    c = copy.deepcopy(c)
    c["A3"] = copy.deepcopy(c["A2"])
    return c


def stalled(c):
    """Learning stalls: no arm moves from its start."""
    c = copy.deepcopy(c)
    for a in c:
        for k in KEYS:
            c[a][k] = np.full_like(c[a][k], c[a][k][0])
    return c


def reversal(c):
    """Nearness rises, then falls back by 0.1, while the bay goes on falling."""
    c = copy.deepcopy(c)
    for a in ("A1", "A2", "A3", "A5", "A6", "C1"):
        n = len(c[a]["update"])
        back = np.where(np.arange(n) > 2 * n // 3, 0.1 * (np.arange(n) - 2 * n // 3) / (n / 3), 0.0)
        c[a]["nearness"] = c[a]["nearness"] - back
    return c


def repeated(c):
    """Nearness oscillates by 0.03 about its course, crossing levels repeatedly."""
    c = copy.deepcopy(c)
    for a in c:
        n = len(c[a]["update"])
        c[a]["nearness"] = c[a]["nearness"] + 0.03 * np.sin(np.arange(n) * 1.7) * (np.arange(n) > 0)
    return c


def ranges(c):
    """The arms reach different ranges: A3 and A5 stop at 0.62 while A2 goes on."""
    c = copy.deepcopy(c)
    for a in ("A3", "A5"):
        c[a]["nearness"] = np.minimum(c[a]["nearness"], 0.62)
    return c


def early_drain(c):
    """The bay drained early: in A1 and A2 the bay and the colony are gone within the first 30% of the rise
    in nearness (a shared output bias on the bay's head could do it)."""
    c = copy.deepcopy(c)
    for a in ("A1", "A2"):
        n = c[a]["nearness"]
        prog = (n - n[0]) / max(1e-9, n.max() - n[0])
        f = np.clip(1 - prog / 0.3, 0, 1)
        c[a]["bay_left"] = c[a]["bay_left"][0] * f
        c[a]["kept"] = c[a]["kept"][0] * f
    return c


def jumps(c):
    """Saturating policies: every measure jumps from its start to its end within one checkpoint interval."""
    c = copy.deepcopy(c)
    for a in c:
        n = len(c[a]["update"])
        for k in KEYS:
            c[a][k] = np.where(np.arange(n) < n // 2, c[a][k][0], c[a][k][-1])
    return c


def split(c_seed, share_inert):
    """Seeds that settle differently: the first `share_inert` of them keep the restraint (inert prior), the
    rest drain (T3's pattern)."""
    def vary(s, c):
        return inert_prior(c) if s < share_inert * SEEDS else c
    return vary


def plateaus():
    """Each seed settles at its own deterministic plateau: it follows T3's curves and stops for good at a
    checkpoint drawn from 12 to 24, by seed."""
    stops = np.random.default_rng(7).integers(12, 25, size=SEEDS)

    def vary(s, c):
        c = copy.deepcopy(c)
        for a in c:
            for k in KEYS:
                c[a][k] = np.where(np.arange(len(c[a][k])) > stops[s], c[a][k][stops[s]], c[a][k])
        return c
    return vary


NOT_CONTRA = {"supported", "unresolved", "untestable"}
ANY = None
CASES = {
    # case: (curves, options, {prediction: outcome expected (a set allows any of them)})
    # The exact flow's anchored arm (beta = 1, plain gradient) reaches only 0.651, so P5 reads at 0.60 or
    # 0.65, where the anchor has kept 0.45 to 0.88 fish; there it may stay unresolved.
    "T3's pattern": (t3, {}, dict(P1="supported", P2="supported", P3="supported", P4="supported",
                                  P5={"supported", "unresolved"}, P6="supported")),
    "T3's pattern, from the sampled baseline's mean curves": ("baseline", {}, dict(
        P1="supported", P2="supported", P3="supported", P4="supported", P5="supported", P6="supported")),
    "T3's pattern, identical seeds (no seed noise)": (t3, dict(noise=0.0, seed_shift=0.0, arm_jitter=0.0),
                                                     dict(P1="supported", P2="supported", P3="supported",
                                                          P4="supported", P5="supported", P6="supported")),
    "T3's pattern, a fifth of the seeds stalled": (t3, dict(stalled=4), dict(
        P1="supported", P2="supported", P3="supported", P4="supported", P5={"supported", "unresolved"},
        P6="supported")),
    "T3's pattern, the bay drained before 0.65": (early_drain, {}, dict(
        P1="supported", P2="supported", P3="supported", P4="supported", P5={"supported", "unresolved"},
        P6="supported")),
    "T3's pattern, saturating (every measure jumps within one interval)": (jumps, {}, dict(
        P1="supported", P2="supported", P3="supported", P4="supported", P5=NOT_CONTRA, P6="supported")),
    "T3's pattern, seeds settling at their own plateaus": (t3, dict(vary=plateaus()), dict(
        P1=NOT_CONTRA, P2=NOT_CONTRA, P3=NOT_CONTRA, P4=NOT_CONTRA, P5=NOT_CONTRA, P6=NOT_CONTRA)),
    "seeds split: half keep the restraint, half drain": (t3, dict(vary=split(None, 0.5)), dict(
        P1=NOT_CONTRA, P2=NOT_CONTRA, P3=NOT_CONTRA, P4=NOT_CONTRA, P5=NOT_CONTRA, P6="untestable")),
    "partly inert prior: 6 of 20 seeds keep the restraint": (t3, dict(vary=split(None, 0.3)), dict(
        P1=NOT_CONTRA, P2=NOT_CONTRA, P3=NOT_CONTRA, P4=NOT_CONTRA, P5=NOT_CONTRA, P6="untestable")),
    "carried restraint": (carried_restraint, {}, dict(P1="contradicted", P6={"contradicted", "unresolved", "untestable"})),
    "carried taking": (carried_taking, {}, dict(P2="contradicted")),
    "habit": (habit, {}, dict(P3="contradicted")),
    "habit as far at matched ground nearness (T3's refuter)": (habit_as_far, {}, dict(P3="contradicted",
                                                                                     refuter=True)),
    "inert prior": (inert_prior, {}, dict(P1={"unresolved", "untestable"}, P6="untestable")),
    "erosion without selection": (erosion, {}, dict(P2="supported")),
    "protection by a term counted after": (protected_after, {}, dict(P4="contradicted")),
    "no anchoring": (no_anchor, {}, dict(P5={"unresolved", "contradicted"})),
    "stalled learning": (stalled, {}, dict(P1="untestable", P2="untestable", P3="untestable", P4="untestable",
                                           P5="untestable", P6="untestable")),
    "reversal": (reversal, {}, dict(P1="supported", P2="supported", P6="supported")),
    "repeated crossings": (repeated, {}, dict(P1="supported", P6="supported")),
    "different ranges": (ranges, {}, dict(P1="supported", P4={"supported", "unresolved"},
                                          P5={"supported", "untestable", "unresolved"})),
}
# Reported, not gating: smaller effects, to show what each margin lets through.
SWEEP = {
    "T3's pattern, twice the seed noise": (t3, dict(noise=2.0, seed_shift=2.0), dict(
        P1="supported", P2="supported", P3="supported", P4="supported", P5="supported", P6="supported")),
    "T3's pattern from the baseline, twice the seed noise": ("baseline", dict(noise=2.0, seed_shift=2.0), dict(
        P1="supported", P2="supported", P3="supported", P4="supported", P5="supported", P6="supported")),
    "carried restraint, half (the bay up 0.5)": (lambda c: carried_restraint(c, 0.5), {}, dict(P1="contradicted")),
    "carried restraint, a quarter (up 0.25, at the margin)": (lambda c: carried_restraint(c, 0.25), {},
                                                              dict(P1="contradicted")),
    "carried taking, 0.10 per step": (lambda c: carried_taking(c, 0.10), {}, dict(P2="contradicted")),
    "carried taking, 0.075 per step": (lambda c: carried_taking(c, 0.075), {}, dict(P2="contradicted")),
    "habit, half of A2's drain": (lambda c: habit(c, 0.5), {}, dict(P3="contradicted")),
    "habit, a quarter of A2's drain": (lambda c: habit(c, 0.25), {}, dict(P3="contradicted")),
}
CASES_ALL = dict(CASES, **SWEEP)


def simulate(case, rng):
    fn, opts, _ = CASES_ALL[case]
    curves = baseline_curves() if fn == "baseline" else fn(exact_curves())
    by_family = {fam: V.read_family(records(curves, rng, **opts)) for fam in V.TESTED}
    return V.outcomes(by_family)


def baseline():
    """The sampled separable baseline on the power check's seeds, if run.py --power has run."""
    files = sorted(glob.glob(os.path.join(HERE, "results", "power-runs", "separable-*.json")))
    if not files:
        return None
    arms = {}
    for f in files:
        r = json.load(open(f))
        arms.setdefault(r["arm"], {})[r["seed"]] = r
    reads = V.read_family(arms)
    out = V.outcomes({"separable": reads}, tested=())
    return dict(outcomes=out["separable"], reads=reads, seeds=sorted({s for a in arms.values() for s in a}))


def one_case(job):
    i, case, reps = job
    rng = np.random.default_rng([20261103, i])
    expect = CASES_ALL[case][2]
    counts, refuted = {}, 0
    for _ in range(reps):
        o = simulate(case, rng)
        for fam in V.TESTED:
            for p, r in o[fam].items():
                counts.setdefault(p, {}).setdefault(r["outcome"], 0)
                counts[p][r["outcome"]] += 1
            refuted += int(o[fam]["P3"].get("refuter_met", False))
    total = reps * len(V.TESTED)
    share = {p: {k: v / total for k, v in c.items()} for p, c in counts.items()}
    power = {}
    for p, want in expect.items():
        if p == "refuter":
            power[p] = refuted / total
            continue
        want = {want} if isinstance(want, str) else want
        power[p] = sum(share[p].get(w, 0.0) for w in want)
    return case, dict(expected={p: sorted(w) if isinstance(w, set) else ("met" if w is True else w)
                                for p, w in expect.items()},
                      power=power, shares=share, refuter_met=refuted / total, gating=case in CASES)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--reps", type=int, default=REPS)
    ap.add_argument("--jobs", type=int, default=6)
    args = ap.parse_args()
    jobs = [(i, case, args.reps) for i, case in enumerate(CASES_ALL)]
    with mp.Pool(args.jobs) as pool:
        res = dict(pool.map(one_case, jobs))
    false_contra = {p: max(res[c]["shares"][p].get("contradicted", 0.0) for c in res if c.startswith("T3's"))
                    for p in V.PREDICTIONS}
    false_contra["refuter"] = max(res[c]["refuter_met"] for c in res if c.startswith("T3's"))
    ok = all(v >= 0.8 for c, r in res.items() if c in CASES for v in r["power"].values()) \
        and max(false_contra.values()) <= 0.05
    json.dump(dict(reps=args.reps, seeds=SEEDS, cases=res, false_contradiction_under_t3=false_contra,
                   baseline=baseline(), passed=ok), sys.stdout, indent=1, default=float)
    print()


if __name__ == "__main__":
    main()
