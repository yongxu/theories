"""UE31's dry runs: the frozen rules on synthetic cultures, before any value of the archive is read.

  python3 -I -B dry_runs.py        writes results/dry-runs.json and prints a summary

Each generator makes cultures of 41 censuses (t = 0 to 40, 80 weeks, as in Dennis et al. 2001), and the rules of
state_rules.py read them as they would read the archive. Seed 20261103. Standard library only; under a minute of CPU.

Generators (DESIGN.md §8):
  lpa           the rival holds: the demographic LPA model (Dennis et al. 2001, Eqs. 4-8) at its CLS estimates, adult
                loss set at 0.04, 0.27, 0.50, 0.73 or 0.96 per step, recruitment left to the culture
  lpa-recalled  the same at a set of estimates recalled from memory, not checked, its source uncertain (perhaps Dennis
                et al. 1995, fitted to earlier cultures; not shown to be the adult-loss experiment's): b 11.68,
                mu_l 0.5129, c_el 0.0093, c_ea 0.0110, c_pa 0.0178, mu_a 0.1108; a second regime, not this archive's
  lpa-control   the 2001 estimates with nothing set: adults survive binomially at the estimated natural loss 0.007629
  lpa-env       lpa with environmental noise: the egg rate b varies lognormally, sd 0.3, step to step
  lpaa          adults that matured in the last step lay and eat at half the rate (the LPAA model's newly emerged
                class, of lower fecundity), so the rival's three stages are not the whole state
  lpa-long      the feeding larvae take two census steps, so eggs become pupae three steps on and the adults' own
                course needs four numbers: T2's lag, frozen at two steps, misses one (H1's power)
  t2-stage-*    T2 holds: the next giving's mean follows MQ5's law with the lag at the delay,
                phi G_{t-1} + (1 - phi) g(E_t) + lam (E_{t-2} - E_t), Ricker's g(E) = 30 E e^(-E/50); the pupae are the
                recruits to be, Poisson with mean m / 0.8, and the recruits a binomial share 0.8 of them
  t2-copy-*     the same law with the giving Poisson about it and the pupae a noisy copy of the mean, not its source,
                so the stages miss what T2's numbers carry
                (* is the rates: mq5 = MQ5's frozen 0.96 and 0.55; b = 0.9 and 0.3; c = 0.5 and 0.4)
  lpa-4wk       reported only: lpa read at every other census (four weeks)
The adults are recorded as returned after the census; one lpa culture per loss is also written as counted before the
manipulation with the dead counted, and its reconstruction is checked against the returned form (a check of the code:
the generator and the reconstruction follow the same rules).
"""
from __future__ import annotations

import json
import math
import os
import random
import statistics
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import state_rules as R  # noqa: E402

SEED = 20261103
CENSUSES = 40
MUS = (0.04, 0.27, 0.50, 0.73, 0.96)
PER_MU = 30
START = (250, 5, 100)                 # L, P, A at t = 0 (Dennis et al. 2001)
LPA = {'b': 10.45, 'mu_l': 0.2000, 'c_el': 0.01731, 'c_ea': 0.01310, 'c_pa': 0.004619, 'mu_a': 0.007629}
RECALLED = {'b': 11.68, 'mu_l': 0.5129, 'c_el': 0.0093, 'c_ea': 0.0110, 'c_pa': 0.0178, 'mu_a': 0.1108}
RATES = {'mq5': (0.96, 0.55), 'b': (0.9, 0.3), 'c': (0.5, 0.4)}
SHAPES = ('two replicates a loss', 'three replicates a loss', 'three at one loss, two at the rest',
          'three losses, three replicates')
DRAWS = 1000
NEW_RATE = 0.5                        # lpaa: the newly matured adults' share of a mature adult's laying and eating


def poisson(rng, m):
    if m <= 0:
        return 0
    if m > 60:
        return max(0, round(rng.gauss(m, math.sqrt(m))))
    k, p, lim = 0, 1.0, math.exp(-m)
    while True:
        p *= rng.random()
        if p <= lim:
            return k
        k += 1


def binomial(rng, n, p):
    if n <= 0 or p <= 0:
        return 0
    if p >= 1:
        return n
    if n * p * (1 - p) > 25:
        return min(n, max(0, round(rng.gauss(n * p, math.sqrt(n * p * (1 - p))))))
    return sum(1 for _ in range(n) if rng.random() < p)


def lpa_culture(rng, mu, q=LPA, env=0.0, newly=False):
    """One culture of the demographic LPA model; mu None leaves adult loss to the culture (a control). Also returns the
    adults as counted before the manipulation, with the dead counted."""
    L, P, A, C, D = [START[0]], [START[1]], [START[2]], [START[2]], [0]
    r_prev = 0                                     # adults that matured in the last step (for lpaa)
    for _ in range(CENSUSES):
        l, p, a = L[-1], P[-1], A[-1]
        b = q['b'] * (math.exp(rng.gauss(0, env)) if env else 1.0)
        mature = max(a - (1 - NEW_RATE) * r_prev, 0) if newly else a
        nl = poisson(rng, b * mature * math.exp(-q['c_el'] * l - q['c_ea'] * a))
        np_ = binomial(rng, l, 1 - q['mu_l'])
        rec = binomial(rng, p, math.exp(-q['c_pa'] * mature))
        alive = binomial(rng, a, 1 - q['mu_a'])     # natural survivors, counted at the census
        old = round((1 - mu) * a) if mu is not None else alive
        L.append(nl)
        P.append(np_)
        A.append(rec + old)
        C.append(rec + alive)
        D.append(a - alive)
        r_prev = rec
    return {'L': L, 'P': P, 'A': A, 'counted': C, 'D': D}


def long_culture(rng, mu, q=LPA):
    """The LPA with the feeding larvae taking two census steps (L1, then L2), so eggs become pupae three steps on and
    the adults' course needs four numbers; the census counts the larvae together."""
    L1, L2, P, A = [START[0]], [0], [START[1]], [START[2]]
    for _ in range(CENSUSES):
        l1, l2, p, a = L1[-1], L2[-1], P[-1], A[-1]
        L1.append(poisson(rng, q['b'] * a * math.exp(-q['c_el'] * (l1 + l2) - q['c_ea'] * a)))
        L2.append(binomial(rng, l1, 1 - q['mu_l'] / 2))
        P.append(binomial(rng, l2, 1 - q['mu_l'] / 2))
        A.append(binomial(rng, p, math.exp(-q['c_pa'] * a)) + round((1 - mu) * a))
    return {'L': [x + y for x, y in zip(L1, L2)], 'P': P, 'A': A}


def t2_culture(rng, mu, phi, lam, copy, r=30.0, K=50.0):
    """T2 holds, the lag at the delay: the giving's mean m_t = phi G_{t-1} + (1 - phi) g(E_t) + lam (E_{t-2} - E_t)."""
    A, P, L, G = [START[2]], [], [], []
    e_hist = [(1 - mu) * A[0]] * 2
    g_prev = r * e_hist[-1] * math.exp(-e_hist[-1] / K)
    for _ in range(CENSUSES + 1):
        e = (1 - mu) * A[-1]
        m = max(phi * g_prev + (1 - phi) * r * e * math.exp(-e / K) + lam * (e_hist[-2] - e), 0.0)
        if copy:
            P.append(poisson(rng, 1.5 * m + 5))
            g = poisson(rng, m)
        else:
            P.append(poisson(rng, m / 0.8))
            g = binomial(rng, P[-1], 0.8)
        L.append(poisson(rng, 2 * e + 10))
        A.append(round(e) + g)
        e_hist.append(e)
        g_prev = g
    return {'L': L, 'P': P, 'A': A[:CENSUSES + 1]}


def make(rng, gen):
    cs = []
    if gen == 'lpa-control':
        for i in range(PER_MU):
            c = lpa_culture(rng, None)
            cs.append({'L': c['L'], 'P': c['P'], 'A': c['A'], 'id': '%s-%d' % (gen, i), 'group': 'control',
                       'mu': None})
        return cs
    for mu in MUS:
        for i in range(PER_MU):
            if gen in ('lpa', 'lpa-4wk'):
                c = lpa_culture(rng, mu)
            elif gen == 'lpa-recalled':
                c = lpa_culture(rng, mu, q=RECALLED)
            elif gen == 'lpa-env':
                c = lpa_culture(rng, mu, env=0.3)
            elif gen == 'lpaa':
                c = lpa_culture(rng, mu, newly=True)
            elif gen == 'lpa-long':
                c = long_culture(rng, mu)
            else:
                kind, rates = gen.split('-')[1], gen.split('-')[2]
                c = t2_culture(rng, mu, *RATES[rates], copy=(kind == 'copy'))
            m = mu
            if gen == 'lpa-4wk':
                c = {'L': c['L'][::2], 'P': c['P'][::2], 'A': c['A'][::2]}
                m = 1 - (1 - mu) ** 2
            cs.append({'L': c['L'], 'P': c['P'], 'A': c['A'], 'id': '%s-%g-%d' % (gen, mu, i), 'group': 'primary',
                       'mu': m})
    return cs


def check_reconstruction(rng):
    """One culture per loss written as counted before the manipulation: its reconstruction equals the returned form."""
    ok = 0
    for mu in MUS:
        c = lpa_culture(rng, mu)
        counted = {'L': c['L'], 'P': c['P'], 'A': c['counted'], 'D': c['D'], 'mu': mu, 'recorded': 'counted'}
        assert R.returned_adults(counted) == c['A'], mu
        ok += 1
    return ok


def rounded(v):
    if isinstance(v, float):
        return round(v, 4)
    if isinstance(v, dict):
        return {a: rounded(b) for a, b in v.items()}
    if isinstance(v, list):
        return [rounded(x) for x in v]
    return v


def shape(rng, losses, label):
    """How many replicates each loss gets in one drawn group of the shape named."""
    if label == 'two replicates a loss':
        return {mu: 2 for mu in losses}
    if label == 'three replicates a loss':
        return {mu: 3 for mu in losses}
    if label == 'three at one loss, two at the rest':
        three = rng.choice(losses)
        return {mu: 3 if mu == three else 2 for mu in losses}
    return {mu: 3 for mu in rng.sample(losses, 3)}


def small_groups(rng, per):
    """Groups shaped like the archive's (a few replicates at each of a few losses), drawn DRAWS times: how often each
    verdict and each combined reading comes out. A shape is not drawn where a loss has too few cultures."""
    by = {}
    for p in per:
        by.setdefault(p['mu'], []).append(p)
    losses = sorted(by)
    out = {}
    for label in SHAPES:
        if any(len(v) < 3 for v in by.values()) or len(losses) < 3:
            continue
        tally = {}
        for _ in range(DRAWS):
            sub = [p for mu, k in shape(rng, losses, label).items() for p in rng.sample(by[mu], k)]
            res = R.combine(sub)
            if not res['testable']:
                key = 'not testable'
                tally[key] = tally.get(key, 0) + 1
                continue
            for key in ('W', 'H1', 'V2', 'V5', 'V4', 'sign', 'reading'):
                name = key + ': ' + res[key]
                tally[name] = tally.get(name, 0) + 1
        out[label] = {a: round(b / DRAWS, 3) for a, b in sorted(tally.items())}
    return out


def main():
    rng = random.Random(SEED)
    gens = (['lpa', 'lpa-recalled', 'lpa-control', 'lpa-env', 'lpaa', 'lpa-long']
            + ['t2-%s-%s' % (k, r) for k in ('stage', 'copy') for r in RATES] + ['lpa-4wk'])
    results = {}
    for gen in gens:
        cs = make(rng, gen)
        if gen == 'lpa-4wk':                      # reported only: the coarser grain has 16 rows a culture
            res, per = R.group_verdicts(cs, coarse=True, min_rows=15)
        else:
            res, per = R.group_verdicts(cs)
        results[gen] = {'verdicts': rounded(res), 'small_groups': small_groups(rng, per) if gen != 'lpa-4wk' else {}}
        v = res
        s = v['sign_counts']
        print('%-14s %3d (+%d short) W %6.3f | H1 %7.3f | V2 %7.3f | V5 %s %s | V4 %s | sign: rules differ in %d, '
              'rival right %d, T2 right %d: %s | %s | left out %s' % (
                  gen, v['cultures'], v['too_short'], v['W_excess'], v['H1_excess'], v['V2_excess'], v['V5'],
                  v['V5_signs'], v['V4'], s['rules_differ'], s['rival_right'], s['T2_right'], v['sign'],
                  v['reading'], v['left_out']))
    rec = check_reconstruction(rng)
    print('reconstruction from counted adults and the dead: %d of %d cultures equal' % (rec, len(MUS)))
    here = os.path.dirname(os.path.abspath(__file__))
    os.makedirs(os.path.join(here, 'results'), exist_ok=True)
    with open(os.path.join(here, 'results', 'dry-runs.json'), 'w', encoding='utf-8') as f:
        json.dump({'seed': SEED, 'censuses': CENSUSES, 'set_losses': MUS, 'per_set_loss': PER_MU,
                   'lpa_parameters': LPA, 'recalled_parameters': RECALLED, 'rates': RATES,
                   'reconstruction_checked': rec, 'results': results}, f, indent=1, sort_keys=True)
        f.write('\n')


if __name__ == '__main__':
    main()
