"""UE31b's dry runs: the cell rules on synthetic archives of the adult-loss experiment's shape, before any of its values
is read.

  python3 -I -B dry_runs_cells.py [DRAWS]     writes results/dry-runs-cells.json and prints a summary

Each draw is one synthetic archive shaped as Data Set 2's adult-loss cultures (../LAYOUT.md): 2 strains x 5 set losses
(0.04, 0.27, 0.50, 0.73, 0.96) x 4 replicates, 40 cultures. Each culture starts at 250 larvae, 5 pupae and 100 adults
(Dennis et al. 2001's start; Data Set 2's own is not read), runs five census steps with the adults' natural loss (weeks
0 to 10), and has the loss set from the census at week 12 on, the adults returned there being the recruits since week
10 plus the set share of the adults returned at week 10; the rules read the 13 censuses from week 12 to week 36
(t = 0 to 12). Under T2's own law the escapement is the adults' natural share, 1 - 0.007629 a step (Dennis et al.
2001's estimate), until week 10's adults, and the set share from them on, so that week 12's adults are the first
returned under the loss, as in the LPA worlds. Seed 2026110302. Standard library only; about 40 minutes of CPU at 1,000 draws.

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
                level law's carrying constant is set so that T2's cultures hold on average the mean adults of lpa's
                cultures at that loss over the censuses the rival's sign reads, t = 1 to 9 (from calibration batches),
                so that the rival predicts where it does under lpa. In the other T2 worlds every cell is dense.
  lpa-jars      lpa with each culture's b, c_el, c_ea and c_pa varying lognormally, sd 0.2, around the 2001 estimates:
                replicates that differ in what neither state reads (the reader's finding 1)
  lpa-offband   lpa with c_ea halved, so the turning point (about 153 adults) lies outside the rival's band of 76 to 91
                (the reader's finding 2)
  lpa-counted   lpa with the adults recorded as counted before the manipulation from week 14 on, not as returned: the
                recording the frozen protocol check must catch
  lpa-counted-recalled  the same at the recalled set, where the counted form puts the fewest rows above the pupae
  lpa-miscount  lpa recorded as the protocol says but with count errors: the survivors' set share rounded up, 5% of
                the pupae missed at each census, and 0.2% of the larvae maturing within a step without being counted
                as pupae (the second reader's probe): the recording the check must let through
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
DRAWS = 1000
GENS = (['lpa', 'lpa-two', 'lpa-recalled', 'lpa-env', 'lpaa', 'lpa-long']
        + ['t2-%s-%s' % (k, r) for k in ('stage', 'copy') for r in D.RATES] + ['t2-field-mq5', 'lpa-jars', 'lpa-offband',
                                                                             'lpa-counted', 'lpa-counted-recalled',
                                                                             'lpa-miscount'])
MISCOUNT = {'up': True, 'missed': 0.05, 'larvae': 0.002}   # lpa-miscount's count errors
JAR_SD = 0.2               # lpa-jars: each culture's parameters, lognormal about the 2001 estimates
OFFBAND = 0.5              # lpa-offband: c_ea times this
CALIBRATION = 200          # cultures a loss, for t2-field's densities
BISECTIONS = 40            # steps of t2-field's bisection
READ = slice(1, 10)        # the adults the rival's sign reads, A_{t-2} for t = 3 to 11
KEYS = ('W', 'H1', 'V2', 'V5', 'V4', 'sign', 'reading')


def params(gen, strain):
    if gen in ('lpa-recalled', 'lpa-counted-recalled') or (gen == 'lpa-two' and strain == 2):
        return D.RECALLED
    return D.LPA


def lpa_course(rng, mu, q, env=0.0, newly=False, long=False, counted=False, miscount=None):
    """One culture: natural adult loss before the onset, the loss set from the census at week 12 on; returns the 13
    censuses from week 12, the adults as returned after each census (or, counted, as counted before the manipulation
    from week 14 on). miscount: the survivors' set share rounded up ('up'), a share of the pupae missed at each count
    ('missed'), and a share of the larvae maturing within a step uncounted as pupae ('larvae')."""
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
        if miscount and miscount['larvae']:
            rec += D.binomial(rng, l1, miscount['larvae'])
        if k + 1 >= BEFORE:
            old = a - math.floor(mu * a) if miscount and miscount['up'] else round((1 - mu) * a)
        else:
            old = D.binomial(rng, a, 1 - q['mu_a'])
        shown = rec + D.binomial(rng, a, 1 - q['mu_a']) if counted and k + 1 > BEFORE else rec + old
        l1, l2, p, a = nl1, nl2, np_, rec + old
        L.append(l1 + l2)
        P.append(p - D.binomial(rng, p, miscount['missed']) if miscount and miscount['missed'] else p)
        A.append(shown)
        r_prev = rec
    return {'L': L[BEFORE:], 'P': P[BEFORE:], 'A': A[BEFORE:]}


def field_constants(rng):
    """t2-field's carrying constant at each loss: the K at which T2's cultures at MQ5's rates (t2_course, the same K
    before the onset and after it) hold on average the mean adults of lpa's cultures at that loss over the censuses the
    rival's sign reads, A_{t-2} for t = 3 to 11 (t = 1 to 9). lpa's mean is from CALIBRATION cultures drawn with rng;
    T2's, for each K tried, from CALIBRATION cultures drawn at the seed SEED + 1; K is found by bisection on its
    logarithm, between 1 and 5000. Where even the least K leaves T2's cultures denser, K stays at 1; the means aimed at
    and reached are returned beside K."""
    out, fit = {}, {}
    for mu in D.MUS:
        target = statistics.fmean(x for _ in range(CALIBRATION) for x in lpa_course(rng, mu, D.LPA)['A'][READ])
        lo, hi = 1.0, 5000.0
        for _ in range(BISECTIONS):
            k = math.sqrt(lo * hi)
            draw = random.Random(SEED + 1)
            got = statistics.fmean(x for _ in range(CALIBRATION)
                                   for x in t2_course(draw, mu, *D.RATES['mq5'], copy=False, K=k)['A'][READ])
            lo, hi = (k, hi) if got < target else (lo, k)
        out[mu] = math.sqrt(lo * hi)
        draw = random.Random(SEED + 1)
        fit[str(mu)] = {'lpa': round(target, 1), 't2': round(statistics.fmean(
            x for _ in range(CALIBRATION) for x in t2_course(draw, mu, *D.RATES['mq5'], copy=False, K=out[mu])['A'][READ]),
            1)}
    return out, fit


def t2_course(rng, mu, phi, lam, copy, r=30.0, K=50.0):
    """T2's law (../dry_runs.py's t2_culture), the escapement the adults' natural share before the onset and the set
    share from week 10's adults on, so that week 12's are the first returned under the loss; returns the 13 censuses
    from week 12."""
    n = BEFORE + UNDER
    A, P, L = [D.START[2]], [], []
    e_hist = [(1 - D.LPA['mu_a']) * A[0]] * 2
    g_prev = r * e_hist[-1] * math.exp(-e_hist[-1] / K)
    for k in range(n + 1):
        e = (1 - (mu if k + 1 >= BEFORE else D.LPA['mu_a'])) * A[-1]
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
    if gen == 'lpa-jars':
        q = dict(q, **{k: q[k] * math.exp(rng.gauss(0, JAR_SD)) for k in ('b', 'c_el', 'c_ea', 'c_pa')})
    elif gen == 'lpa-offband':
        q = dict(q, c_ea=q['c_ea'] * OFFBAND)
    return lpa_course(rng, mu, q, env=0.3 if gen == 'lpa-env' else 0.0, newly=(gen == 'lpaa'),
                      long=(gen == 'lpa-long'), counted=gen.startswith('lpa-counted'),
                      miscount=MISCOUNT if gen == 'lpa-miscount' else None)


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
    tally, stats, most, byneg = {}, {}, {}, {}
    for res in results:
        for k, v in (('too_short_cells', res['too_short_cells']), ('protocol_rows_above', res['protocol_rows'][0]),
                     ('left_out', sum(res.get('left_out', {}).values())),
                     ('zero_columns_dropped', res.get('zero_columns_dropped', 0))):
            most[k] = max(most.get(k, 0), v)
        if res['protocol'] != C.PROTOCOL_AGREES:
            tally['protocol: ' + res['protocol']] = tally.get('protocol: ' + res['protocol'], 0) + 1
            continue
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
        if not res['sign'].startswith('not read'):
            k = byneg.setdefault(str(s['rival_predicts_negative']), [0, 0])
            k[0] += 1
            k[1] += res['sign'] == "separated on the sign: T2's"
        if s['rules_differ'] >= 6 and not res['sign'].startswith('not read'):
            name = 'sign read with at least six cells differing: ' + res['sign']
            tally[name] = tally.get(name, 0) + 1
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
            dict({k: round(statistics.median(v), 4) for k, v in sorted(stats.items())},
                 **{'most_' + k: v for k, v in sorted(most.items())},
                 sign_by_rival_negative={k: byneg[k] for k in sorted(byneg, key=int)}))


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
    field, fit = field_constants(rng)
    out = {'seed': SEED, 't2_field_constants': {str(k): round(v, 3) for k, v in field.items()},
           't2_field_mean_adults': fit, 'draws': draws, 'shape': {'strains': len(STRAINS), 'set_losses': D.MUS, 'replicates': REPS,
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
