"""UE31b's dry runs: the cell rules on synthetic archives of the adult-loss experiment's shape, before any of its values
is read.

  python3 -I -B dry_runs_cells.py [DRAWS]     writes results/dry-runs-cells.json and prints a summary

Each draw is one synthetic archive shaped as Data Set 2's adult-loss cultures (../LAYOUT.md): 2 strains x 5 set losses
(0.04, 0.27, 0.50, 0.73, 0.96) x 4 replicates, 40 cultures. Each culture starts at 250 larvae, 5 pupae and 100 adults
(Dennis et al. 2001's start; Data Set 2's own is not read), runs six census steps with the adults' natural loss (weeks
0 to 12), and has the loss set from the census at week 12 on, the adults returned there being the recruits since week
10 plus the set share of the adults returned at week 10; the rules read the 13 censuses from week 12 to week 36
(t = 0 to 12). Under T2's own law there is no natural loss to run, so its cultures run under the set loss from the start
and the rules read their last 13 censuses. Seed 2026110302. Standard library only.

Generators (cells/DESIGN.md §6), each strain at the parameters named:
  lpa           the demographic LPA model at Dennis et al. 2001's CLS estimates, both strains
  lpa-two       strain 1 at the 2001 estimates, strain 2 at the recalled set (../dry_runs.py; its source uncertain):
                two strains of different parameters, as the archive's two may be
  lpa-recalled  both strains at the recalled set
  lpa-env       lpa with the egg rate varying lognormally, sd 0.3, step to step
  lpaa          lpa with adults that matured in the last step laying and eating at half the rate
  lpa-long      lpa with the feeding larvae taking two census steps: the course needs four numbers (H1's power)
  t2-stage-*    T2's law with the lag at the delay (../dry_runs.py), the pupae the recruits to be
  t2-copy-*     T2's law with the pupae a noisy copy of the mean, not its source
                (* the rates (phi, lambda): mq5 = 0.96 and 0.55, b = 0.9 and 0.3, c = 0.5 and 0.4)
  t2-field-mq5  T2's law at MQ5's rates, the pupae the recruits to be, at the field's densities: at each loss the
                level law's carrying constant is set so that the adults' equilibrium equals the mean adults of lpa's
                cultures at that loss (t = 3 to 12, from a calibration batch), so that dense and sparse cells fall
                where the field's model puts them. In the other T2 worlds every cell is dense.
Beside the draws, one archive per generator with 30 replicates a cell shows where each rule goes when power is ample.
"""
from __future__ import annotations

import json
import math
import os
import random
import statistics
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.dirname(HERE))
import cell_rules as C  # noqa: E402
import dry_runs as D  # noqa: E402

SEED = 2026110302
BEFORE = 6                 # census steps before the onset (weeks 0 to 12)
UNDER = 12                 # census steps under the loss (t = 0 to 12, weeks 12 to 36)
STRAINS = (1, 2)
REPS = 4
LARGE_REPS = 30
DRAWS = 400
GENS = (['lpa', 'lpa-two', 'lpa-recalled', 'lpa-env', 'lpaa', 'lpa-long']
        + ['t2-%s-%s' % (k, r) for k in ('stage', 'copy') for r in D.RATES] + ['t2-field-mq5'])
CALIBRATION = 200          # lpa cultures a loss, for t2-field's densities
KEYS = ('W', 'H1', 'V2', 'V5', 'V4', 'sign', 'reading')


def params(gen, strain):
    if gen == 'lpa-recalled' or (gen == 'lpa-two' and strain == 2):
        return D.RECALLED
    return D.LPA


def lpa_course(rng, mu, q, env=0.0, newly=False, long=False):
    """One culture: natural adult loss before the onset, the loss set from the census at week 12 on; returns the 13
    censuses from week 12."""
    l1, l2, p, a = D.START[0], 0, D.START[1], D.START[2]
    L, P, A = [l1 + l2], [p], [a]
    r_prev = 0
    for k in range(BEFORE + UNDER):
        b = q['b'] * (math.exp(rng.gauss(0, env)) if env else 1.0)
        mature = max(a - (1 - D.NEW_RATE) * r_prev, 0) if newly else a
        eggs = D.poisson(rng, b * mature * math.exp(-q['c_el'] * (l1 + l2) - q['c_ea'] * a))
        if long:
            nl1, nl2, np_ = eggs, D.binomial(rng, l1, 1 - q['mu_l'] / 2), D.binomial(rng, l2, 1 - q['mu_l'] / 2)
        else:
            nl1, nl2, np_ = eggs, 0, D.binomial(rng, l1, 1 - q['mu_l'])
        rec = D.binomial(rng, p, math.exp(-q['c_pa'] * mature))
        old = round((1 - mu) * a) if k + 1 >= BEFORE else D.binomial(rng, a, 1 - q['mu_a'])
        l1, l2, p, a = nl1, nl2, np_, rec + old
        L.append(l1 + l2)
        P.append(p)
        A.append(a)
        r_prev = rec
    return {'L': L[BEFORE:], 'P': P[BEFORE:], 'A': A[BEFORE:]}


def field_constants(rng):
    """t2-field's carrying constant at each loss: K with the equilibrium of T2's level law, r exp(-E/K) = mu / (1 - mu),
    at E = (1 - mu) times lpa's mean adults at that loss (t = 3 to 12), r = 30."""
    out = {}
    for mu in D.MUS:
        a = [x for _ in range(CALIBRATION) for x in lpa_course(rng, mu, D.LPA)['A'][3:]]
        out[mu] = (1 - mu) * statistics.fmean(a) / math.log(30.0 * (1 - mu) / mu)
    return out


def t2_course(rng, mu, phi, lam, copy, r=30.0, K=50.0):
    """T2's law under the set loss from the start (../dry_runs.py's t2_culture); returns the last 13 censuses."""
    n = BEFORE + UNDER
    A, P, L = [D.START[2]], [], []
    e_hist = [(1 - mu) * A[0]] * 2
    g_prev = r * e_hist[-1] * math.exp(-e_hist[-1] / K)
    for _ in range(n + 1):
        e = (1 - mu) * A[-1]
        m = max(phi * g_prev + (1 - phi) * r * e * math.exp(-e / K) + lam * (e_hist[-2] - e), 0.0)
        if copy:
            P.append(D.poisson(rng, 1.5 * m + 5))
            g = D.poisson(rng, m)
        else:
            P.append(D.poisson(rng, m / 0.8))
            g = D.binomial(rng, P[-1], 0.8)
        L.append(D.poisson(rng, 2 * e + 10))
        A.append(round(e) + g)
        e_hist.append(e)
        g_prev = g
    A = A[:n + 1]
    return {'L': L[BEFORE:n + 1], 'P': P[BEFORE:n + 1], 'A': A[BEFORE:]}


def culture(rng, gen, strain, mu, field=None):
    if gen == 't2-field-mq5':
        return t2_course(rng, mu, *D.RATES['mq5'], copy=False, K=field[mu])
    if gen.startswith('t2-'):
        _, kind, rates = gen.split('-')
        return t2_course(rng, mu, *D.RATES[rates], copy=(kind == 'copy'))
    q = params(gen, strain)
    return lpa_course(rng, mu, q, env=0.3 if gen == 'lpa-env' else 0.0, newly=(gen == 'lpaa'),
                      long=(gen == 'lpa-long'))


def archive(rng, gen, reps=REPS, field=None):
    cs = []
    for st in STRAINS:
        for mu in D.MUS:
            for i in range(reps):
                c = culture(rng, gen, st, mu, field)
                assert len(c['A']) == UNDER + 1 and len(c['P']) == UNDER + 1 and len(c['L']) == UNDER + 1
                cs.append(dict(c, id='%s-strain%d-loss%g-rep%d' % (gen, st, mu, i + 1), group='primary', mu=mu,
                               strain=st))
    return cs


def summary(results):
    """The verdicts' shares over the draws, and the medians of the statistics."""
    tally, stats = {}, {}
    for res in results:
        if not res['testable']:
            tally['not testable'] = tally.get('not testable', 0) + 1
            continue
        for k in KEYS:
            name = k + ': ' + res[k]
            tally[name] = tally.get(name, 0) + 1
        for k in ('W_excess', 'H1_excess', 'V2_excess', 'V5_detected', 'W_detected', 'H1_detected', 'V2_detected'):
            if res.get(k) is not None:
                stats.setdefault(k, []).append(res[k])
        s = res['sign_counts']
        for k in ('rules_differ', 'rival_right', 'T2_right', 'unpredicted', 'rival_predicts_negative', 'positive'):
            stats.setdefault('sign_' + k, []).append(s[k])
        if 'V4_errors' in res:
            for k in ('T2', 'level_alone', 'T2_better', 'T2_worse'):
                stats.setdefault('V4_' + k, []).append(res['V4_errors'][k])
        if 'reported_V3' in res:
            stats.setdefault('V3_median_ratio', []).append(res['reported_V3']['median_ratio'])
        if 'reported_resid_over_floor' in res:
            for k, v in res['reported_resid_over_floor'].items():
                stats.setdefault('resid_over_floor_' + k, []).append(v)
            stats.setdefault('rows_recruits_above_pupae', []).append(res['reported_rows_recruits_above_pupae'])
        stats.setdefault('zero_columns_dropped', []).append(res['zero_columns_dropped'])
        stats.setdefault('left_out', []).append(sum(res['left_out'].values()))
    n = len(results)
    return ({k: round(v / n, 4) for k, v in sorted(tally.items())},
            {k: round(statistics.median(v), 4) for k, v in sorted(stats.items())})


def rounded(v):
    if isinstance(v, float):
        return round(v, 4)
    if isinstance(v, dict):
        return {a: rounded(b) for a, b in v.items()}
    if isinstance(v, list):
        return [rounded(x) for x in v]
    return v


def main(draws=DRAWS):
    rng = random.Random(SEED)
    field = field_constants(rng)
    out = {'seed': SEED, 't2_field_constants': {str(k): round(v, 3) for k, v in field.items()}, 'draws': draws, 'shape': {'strains': len(STRAINS), 'set_losses': D.MUS, 'replicates': REPS,
                                                   'censuses_under_the_loss': UNDER + 1, 'censuses_before': BEFORE},
           'large_replicates': LARGE_REPS, 'lpa_parameters': D.LPA, 'recalled_parameters': D.RECALLED,
           'rates': D.RATES, 'results': {}}
    for gen in GENS:
        t0 = time.process_time()
        results = [C.group_verdicts(archive(rng, gen, field=field))[0] for _ in range(draws)]
        shares, medians = summary(results)
        large, _ = C.group_verdicts(archive(rng, gen, LARGE_REPS, field))
        out['results'][gen] = {'shares': shares, 'medians': medians, 'large': rounded(large),
                               'cpu_seconds': round(time.process_time() - t0, 1)}
        print('%-14s %s' % (gen, json.dumps(shares)))
        print('%-14s medians %s' % ('', json.dumps(medians)))
        print('%-14s large: %s | sign %s | V5 %s %s | V4 %s' % ('', large['reading'], large['sign'], large['V5'],
                                                               large['V5_signs'], large['V4']))
        sys.stdout.flush()
    os.makedirs(os.path.join(HERE, 'results'), exist_ok=True)
    with open(os.path.join(HERE, 'results', 'dry-runs-cells.json'), 'w', encoding='utf-8') as f:
        json.dump(out, f, indent=1, sort_keys=True)
        f.write('\n')


if __name__ == '__main__':
    main(int(sys.argv[1]) if len(sys.argv) > 1 else DRAWS)
