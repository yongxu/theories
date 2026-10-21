"""MQ6: the margin's time to break past the fold, in the lab (Dai, Korolev and Gore 2015, Dryad doi:10.5061/dryad.k30v3).

  python3 -I mq6.py layout DIR            layout only (lines and fields per file, token styles); no value printed
  python3 -I mq6.py dev BIF2012           the dilution map fitted on all eight DFs of Dai et al. 2012 (already read):
                                          results/mq6/development.json; stops if it differs from the frozen map
  python3 -I mq6.py dry                   the rules on synthetic experiments (four generators)
  python3 -I mq6.py fit-odd DIR           stage 1: the sucrose map fitted on the odd sucrose levels only; writes the
                                          frozen needs of the even levels (results/mq6/fit-odd.json)
  python3 -I mq6.py test-a DIR            stage 2: A1 on the even levels; the sucrose map fitted on all nine levels
                                          (results/mq6/fit-all.json, VERDICTS-mq6-a.json)
  python3 -I mq6.py test DIR              stage 3: T1, T2, C1 on the deteriorating and constant populations
                                          (results/mq6/VERDICTS-mq6.json)

DIR holds the three archives of the Dryad record extracted into deterioration/, SUCbifurcation/ and SUCindicator/.
Standard library only; the data are untrusted: run with python -I, from outside their directory.

The draw is the daily dilution. On day d the density n_d is read, then the culture is diluted by DF_d into fresh
medium with sucrose s_d (Table S1 of the paper's SI), and grows: n_{d+1} = G_{c_d}(n_d / DF_d). Read in
Becoming.RegimeMargin's terms, what is left is x = n_d / DF_d and the giving is G(x) - x; the regime's need is the
unstable point of n -> G(n / DF), its level the stable point, and past the fold no positive point is left
(ends_beyond_giving). The frozen rest holds the last observed giving and applies the known draw.
"""
from __future__ import annotations

import json
import math
import os
import random
import re
import statistics
import sys
import tempfile
from collections import Counter

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import mq2  # noqa: E402
import posthoc_mq2  # noqa: E402

OUT = os.path.join(HERE, 'results', 'mq6')
FLOOR = mq2.FLOOR                       # 0.01 in 1e5 cells/ul: at or below it a reading is "extinct"
SUCROSE = [2.0, 1.0, 0.8, 0.6, 0.5, 0.4, 0.3, 0.2, 0.16]   # sucrose{i}, i = 1..9 (README)
ODD = [1, 3, 5, 7, 9]                   # fit set of stage 1 (s = 2.0, 0.8, 0.5, 0.3, 0.16)
EVEN = [2, 4, 6, 8]                     # held out in stage 1 (s = 1.0, 0.6, 0.4, 0.2)
DF_SUC = 500.0                          # the sucrose experiments' dilution factor (SI, Supplementary Methods)
DF_START, SUC_START = 5, 7              # first origin day of the deteriorating runs (DF: the first raised transfer;
                                        # sucrose: the first day whose sucrose is within the fitted range)
HORIZONS = (1, 3, 5)
VERDICT_K = (3, 5)                      # T1a: every origin
LATE_K = (1, 3)                         # T1b: late origins, from the tenth day of deterioration on
LATE_AFTER = 9                          # late origins: t0 >= start + 9 (DF: day 14; sucrose: day 16)
BREAK_RATIO = 0.5                       # T2: the free-fall onset, the first day a population halves (the paper's criterion)
BREAK_TOL = 2                           # days
RESID_AC = 0.3                          # L: the level is the state where map residuals carry less than this
BREAK_SHARE = 0.75
LEVEL_FACTOR = 1.15                     # C1
SEP = 1.5                               # A1: outside a factor 1.5 of the need
SEP_SHARE = 0.9

# The dilution map, frozen from `dev` (two-phase with gl T = a - beta ln(DF / 1000), all eight DFs of Dai et al.
# 2012 at 2% sucrose): theta = (a, ln b, ln nc, ln k, beta).
DF_THETA = [4.943267586009312, 0.4840953667918918, -8.785884422160857, 0.6367081927217537, 0.2686736951117882]


# ---------------------------------------------------------------- schedules (SI Table S1)

def df_of_day(d):
    """Dilution factor of the day-d transfer in the deteriorating DF run: 500 on days 1-4, then up 10% a day."""
    return 500.0 if d <= 4 else 500.0 * 1.1 ** (d - 4)


def sucrose_of_day(d):
    """Sucrose (%) of the day-d transfer in the deteriorating sucrose run: 5% on days 1-3, then down 20% a day."""
    return 5.0 if d <= 3 else 5.0 * 0.8 ** (d - 3)


# ---------------------------------------------------------------- maps

def df_map(theta=DF_THETA):
    """G(x; DF): the dilution map. Returns a function of (x, DF)."""
    Gd = posthoc_mq2.two_phase_df(theta)
    cache = {}

    def G(x, df):
        key = round(df, 6)
        if key not in cache:
            cache[key] = Gd(df)
        return cache[key](x)
    return G


def suc_params(theta, s):
    a0, alpha, logb, lognc, logk0, kappa = theta
    return [a0 + alpha * math.log(s / 2.0), logb, lognc, logk0 + kappa * math.log(s / 2.0)]


def suc_map(theta):
    """G(x; s): the sucrose map at DF 500, two-phase with the low-density rate and the carrying capacity
    power laws of sucrose: a(s) = a0 + alpha ln(s/2), ln k(s) = ln k0 + kappa ln(s/2); b and nc common."""
    cache = {}

    def G(x, s):
        key = round(s, 9)
        if key not in cache:
            cache[key] = mq2.two_phase(suc_params(theta, s))
        return cache[key](x)
    return G


def state_at(G1, df):
    """Need, level and margin of n -> G1(n / df) (mq2.state)."""
    return mq2.state(G1, df)


def past_fold(G1, df):
    st = state_at(G1, df)
    return st['stable'] is None


def fit_suc(pairs, starts):
    """Least squares of the censored log residual over (x, y, s) pairs; Nelder-Mead from each start, best kept."""
    def loss(th):
        try:
            G = suc_map(th)
            v = sum(mq2.resid(lambda z: G(z, s), x, y) ** 2 for x, y, s in pairs)
        except (OverflowError, ValueError, ZeroDivisionError):
            return 1e18
        return v if math.isfinite(v) else 1e18
    best = None
    for th0 in starts:
        th, v = mq2.nelder_mead(loss, th0)
        th, v = mq2.nelder_mead(loss, th, step=0.05)
        if best is None or v < best[1]:
            best = (th, v)
    return best


def suc_starts():
    """Fixed starts: the dilution map at DF 500 (a = a_DF - beta ln(500/1000)) with no sucrose dependence, and
    four variants."""
    a, logb, lognc, logk, beta = DF_THETA
    a500 = a - beta * math.log(500.0 / 1000.0)
    base = [a500, 0.0, logb, lognc, logk, 0.0]
    out = [base]
    for da, dk in ((0.5, 0.3), (1.0, 0.6), (0.3, 1.0), (1.5, 0.2)):
        out.append([a500, da, logb, lognc, logk, dk])
    return out


def suc_fold(Gs, lo=0.01, hi=2.0):
    """The least sucrose with a positive level at DF 500 (bisection on a log scale); None if none in range."""
    if past_fold(lambda z: Gs(z, hi), DF_SUC):
        return None
    if not past_fold(lambda z: Gs(z, lo), DF_SUC):
        return lo
    for _ in range(50):
        mid = math.sqrt(lo * hi)
        if past_fold(lambda z: Gs(z, mid), DF_SUC):
            lo = mid
        else:
            hi = mid
    return hi


def df_fold(Gdf, lo=500.0, hi=20000.0):
    for _ in range(60):
        mid = math.sqrt(lo * hi)
        if past_fold(lambda z: Gdf(z, mid), mid):
            hi = mid
        else:
            lo = mid
    return lo


# ---------------------------------------------------------------- reading

def read_matrix(path):
    return [[float(v) for v in line.split()] for line in open(path) if line.strip()]


def read_sucbif(directory, levels):
    """population -> [n_1..n_6] for each sucrose level i (8 replicates x 11 starts per level)."""
    data = {}
    for i in levels:
        days = [read_matrix(os.path.join(directory, 'SUCbifurcation', f'sucrose{i}_day{d}.txt')) for d in range(1, 7)]
        pops = []
        for r in range(len(days[0])):
            for c in range(len(days[0][r])):
                pops.append([days[d][r][c] for d in range(6)])
        data[i] = pops
    return data


def sucbif_pairs(data, levels):
    return [(p[t] / DF_SUC, p[t + 1], SUCROSE[i - 1]) for i in levels for p in data[i] for t in range(5) if p[t] > FLOOR]


def scale_rows(rows, expected):
    vals = [v for r in rows for v in r]
    sc = mq2.unit_scale(vals, expected)
    return [[v * sc for v in r] for r in rows], sc


# ---------------------------------------------------------------- forecasts

def forecast(series, t0, k, model, cond, G, df_of):
    """The density on day t0 + k from the readings up to day t0 (1-based days; series[d - 1] is day d).
    RM: the map under the known schedule; FR: the giving of day t0 - 1 held, the known draw applied;
    RW: the level held; TR: the last day's ratio continued."""
    n0 = series[t0 - 1]
    if model == 'RW':
        return n0
    if model == 'TR':
        prev = series[t0 - 2]
        return n0 * (n0 / prev) ** k if prev > 0 else n0
    if model == 'FR':
        g = n0 - series[t0 - 2] / df_of(t0 - 1)
        n = n0
        for j in range(k):
            n = n / df_of(t0 + j) + g
            if n <= 0:
                return 0.0
        return n
    if model == 'RM':
        n = n0
        for j in range(k):
            d = t0 + j
            n = G(n / df_of(d), cond(d))
        return n
    raise ValueError(model)


def log_err(pred, obs):
    return abs(math.log(max(pred, FLOOR) / max(obs, FLOOR)))


def t1_scores(pops, first, cond, G, df_of, ks):
    out = {}
    for k in ks:
        errs = {m: [] for m in ('RM', 'FR', 'RW', 'TR')}
        right = Counter()
        n = 0
        for p in pops:
            last = len(p)
            for t0 in range(max(first, 2), last - k + 1):
                if p[t0 - 1] <= FLOOR:
                    continue
                obs = p[t0 - 1 + k]
                fell = obs < p[t0 - 1]
                for m in errs:
                    f = forecast(p, t0, k, m, cond, G, df_of)
                    errs[m].append(log_err(f, obs))
                    right[m] += (f < p[t0 - 1]) == fell
                n += 1
        out[f'k{k}'] = {'origins': n,
                        'median_abs_log_error': {m: (statistics.median(v) if v else None) for m, v in errs.items()},
                        'direction_accuracy': {m: (right[m] / n if n else None) for m in errs}}
    return out


def t1_verdict(scores, ks):
    ok, testable = True, True
    for k in ks:
        r = scores[f'k{k}']
        if r['origins'] < 30:
            testable = False
            continue
        e = r['median_abs_log_error']
        ok = ok and e['RM'] < e['FR'] and e['RM'] < e['RW'] and e['RM'] < e['TR']
    return 'not testable' if not testable else ('passed' if ok else 'failed')


def rule_t1(pops, start, cond, G, df_of):
    """T1: the regime margin (RM) against the frozen rest (FR), the level held (RW) and the last ratio continued (TR),
    by median |log error| over origins t0 with n_{t0} > f and t0 + k within the run. T1a: every origin from the start,
    k = 3 and 5. T1b: late origins (t0 >= start + LATE_AFTER), k = 1 and 3."""
    every = t1_scores(pops, start, cond, G, df_of, HORIZONS)
    late = t1_scores(pops, start + LATE_AFTER, cond, G, df_of, HORIZONS)
    return {'every_origin': every, 'late_origins': late,
            'verdict_a': t1_verdict(every, VERDICT_K), 'verdict_b': t1_verdict(late, LATE_K)}


def break_day(series, start=1):
    """The first day at or below the floor (reported)."""
    for d in range(start, len(series) + 1):
        if series[d - 1] <= FLOOR:
            return d
    return None


def fall_day(series, start):
    """The free-fall onset: the first day d >= start with n_{d+1} / n_d < BREAK_RATIO (n_d above the floor)."""
    for d in range(start, len(series)):
        if series[d - 1] > FLOOR and series[d] / series[d - 1] < BREAK_RATIO:
            return d
    return None


def predicted_path(p, start, cond, G, df_of):
    n = p[start - 1]
    out = [None] * (start - 1) + [n]
    for d in range(start, len(p)):
        n = G(n / df_of(d), cond(d))
        out.append(n)
    return out


def agree(obs, pred, last):
    if obs is None and pred is None:
        return True
    if obs is not None and pred is not None:
        return abs(obs - pred) <= BREAK_TOL
    fin = obs if obs is not None else pred
    return fin >= last - 1


def rule_t2(pops, start, cond, G, df_of):
    """T2: each population's free-fall onset against the regime margin's, the map iterated under the schedule from the
    reading on the start day. Agreement: both none; both within BREAK_TOL days; or one on the last day or the day
    before and the other none. Reported: the same for the first day at or below the floor."""
    rows = []
    for p in pops:
        if p[start - 1] <= FLOOR:
            continue
        last = len(p)
        path = predicted_path(p, start, cond, G, df_of)
        obs, pred = fall_day(p, start), fall_day(path, start)
        fobs, fpred = break_day(p, start + 1), break_day(path, start + 1)
        rows.append({'observed': obs, 'predicted': pred, 'agree': agree(obs, pred, last - 1),
                     'floor_observed': fobs, 'floor_predicted': fpred, 'floor_agree': agree(fobs, fpred, last)})
    n = len(rows)
    a = sum(r['agree'] for r in rows)
    fa = sum(r['floor_agree'] for r in rows)
    fin = lambda key: [r[key] for r in rows if r[key] is not None]
    out = {'populations': n, 'agreement': a / n if n else None,
           'observed_onsets': len(fin('observed')), 'predicted_onsets': len(fin('predicted')),
           'median_observed': statistics.median(fin('observed')) if fin('observed') else None,
           'median_predicted': statistics.median(fin('predicted')) if fin('predicted') else None,
           'floor_agreement': fa / n if n else None,
           'median_floor_observed': statistics.median(fin('floor_observed')) if fin('floor_observed') else None,
           'median_floor_predicted': statistics.median(fin('floor_predicted')) if fin('floor_predicted') else None,
           'rows': rows}
    out['verdict'] = 'not testable' if n < 10 else ('passed' if a / n >= BREAK_SHARE else 'failed')
    return out


def rule_l(pops, G, df=500.0, first=DF_START):
    """L: the level is the state (MQ1's D1 and MQ3's F0, in the lab): one-day log residuals of the map at a constant
    dilution, demeaned within each population, carry less than RESID_AC from one day to the next (pooled lag-1
    autocorrelation), over days with both readings above ten times the floor."""
    num = den = 0.0
    n = 0
    for p in pops:
        r = []
        for d in range(first, len(p)):
            if p[d - 1] > 10 * FLOOR and p[d] > 10 * FLOOR:
                r.append((d, math.log(p[d]) - math.log(max(G(p[d - 1] / df, df), FLOOR))))
        if len(r) < 5:
            continue
        m = sum(v for _, v in r) / len(r)
        dv = {d: v - m for d, v in r}
        for d, v in dv.items():
            den += v * v
            if d + 1 in dv:
                num += v * dv[d + 1]
                n += 1
    ac = num / den if den > 0 else None
    return {'pairs': n, 'lag1_autocorrelation': ac,
            'verdict': 'not testable' if ac is None or n < 50 else ('passed' if ac < RESID_AC else 'failed')}


def onset(pops, threshold=0.5):
    """Reported (the paper's criterion): the first day d whose mean ratio n_{d+1} / n_d over the populations alive on
    day d falls below the threshold."""
    last = min(len(p) for p in pops)
    for d in range(1, last):
        rs = [p[d] / p[d - 1] for p in pops if p[d - 1] > FLOOR]
        if rs and sum(rs) / len(rs) < threshold:
            return d
    return None


def fold_day(G, cond, df_of, last):
    """Reported: the first transfer day whose condition is past the map's fold."""
    for d in range(1, last + 1):
        if past_fold(lambda z, dd=d: G(z, cond(dd)), df_of(d)):
            return d
    return None


def survives(p, level):
    """A population's fate in the sucrose bifurcation (frozen): it survives where its day-6 density is above its day-1
    density, or above half the map's level at that sucrose; otherwise it is going extinct. Read by direction, not by the
    floor, because six days leave populations just below the need declining but above the floor."""
    if p[5] > p[0]:
        return True
    return level is not None and p[5] > 0.5 * level


def rule_a1(data, levels, Gs):
    """A1: at each held-out sucrose level with a predicted need, the need separates fates (day-1 density against day-6
    fate, outside a factor SEP, >= SEP_SHARE each side; MQ2's A1), and at each held-out level the map puts past the fold
    (ends_beyond_giving) >= SEP_SHARE of the populations above the floor on day 1 are lower on day 6.
    A2: at each held-out level with a predicted need and mixed fates, the need is within a factor SEP of the need read
    from the fates (the threshold that classifies most fates; MQ2's A2)."""
    rows = {}
    ok1, ok2, t1, t2 = True, True, 0, 0
    for i in levels:
        s = SUCROSE[i - 1]
        G1 = lambda z, s=s: Gs(z, s)
        st = state_at(G1, DF_SUC)
        u = st['need']
        starts = [p[0] for p in data[i]]
        alive = [survives(p, st['stable']) for p in data[i]]
        floor_alive = [p[5] > FLOOR for p in data[i]]
        row = {'sucrose': s, 'need': u, 'level': st['stable'], 'populations': len(starts), 'alive': sum(alive),
               'alive_by_floor': sum(floor_alive)}
        if 0 < sum(alive) < len(alive):
            ustar, acc = mq2.best_threshold(starts, alive)
            row.update(empirical_need=ustar, empirical_accuracy=acc)
        if 0 < sum(floor_alive) < len(floor_alive):
            row['empirical_need_by_floor'] = mq2.best_threshold(starts, floor_alive)[0]
        if st['stable'] is None:
            above = [p for p in data[i] if p[0] > FLOOR]
            fell = sum(1 for p in above if p[5] < p[0])
            row.update(past_fold=True, above_floor=len(above), fell=fell,
                       fell_share=(fell / len(above)) if above else None)
            if len(above) >= 10:
                t1 += 1
                row['A1'] = fell / len(above) >= SEP_SHARE
                ok1 = ok1 and row['A1']
            rows[i] = row
            continue
        if u is None:
            row['note'] = 'no need predicted'
            rows[i] = row
            continue
        hi = [a for x, a in zip(starts, alive) if x > SEP * u and x > FLOOR]
        lo = [a for x, a in zip(starts, alive) if x < u / SEP and (x > FLOOR or u / SEP >= FLOOR)]
        row.update(high_n=len(hi), low_n=len(lo),
                   high_alive=(sum(hi) / len(hi)) if hi else None,
                   low_extinct=(sum(1 for a in lo if not a) / len(lo)) if lo else None)
        row['testable'] = len(hi) >= 5 and len(lo) >= 5
        if row['testable']:
            t1 += 1
            row['A1'] = row['high_alive'] >= SEP_SHARE and row['low_extinct'] >= SEP_SHARE
            ok1 = ok1 and row['A1']
        if 'empirical_need' in row and u >= SEP * FLOOR:
            t2 += 1
            row['A2'] = abs(math.log(u / row['empirical_need'])) <= math.log(SEP)
            ok2 = ok2 and row['A2']
        rows[i] = row
    return {'by_level': rows, 'tested_levels_A1': t1, 'tested_levels_A2': t2,
            'verdict': 'not testable' if t1 < 2 else ('passed' if ok1 else 'failed'),
            'verdict_A2': 'not testable' if t2 < 2 else ('passed' if ok2 else 'failed')}


# ---------------------------------------------------------------- commands

def layout(directory):
    files = {}
    styles = Counter()
    for dp, _, fs in os.walk(directory):
        for f in sorted(fs):
            p = os.path.join(dp, f)
            text = open(p, 'rb').read().decode('latin-1')
            lines = [l for l in text.splitlines() if l.strip()]
            nf = Counter(len(l.split()) for l in lines)
            for l in lines:
                for t in l.split():
                    t2 = t.lstrip('+-')
                    if re.fullmatch(r'\d+', t2):
                        styles['integer'] += 1
                    elif re.fullmatch(r'\d*\.\d+', t2):
                        styles['fixed decimal'] += 1
                    elif re.fullmatch(r'\d*\.?\d*[eE][+-]?\d+', t2):
                        styles['scientific'] += 1
                    else:
                        styles['other'] += 1
            files[os.path.relpath(p, directory)] = {'lines': len(lines), 'fields_per_line': dict(nf)}
    out = {'files': files, 'token_styles_all_files': dict(styles), 'scope': 'layout only; no value printed'}
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, 'layout.json'), 'w') as f:
        json.dump(out, f, indent=1)
    print(json.dumps({'files': len(files), 'token_styles': dict(styles)}, indent=1))


def dev(bif2012):
    data = mq2.read_bifurcation(bif2012, mq2.ALL_DFS)
    pairs = [(x, y, df) for df in mq2.ALL_DFS for x, y in mq2.pairs_of(data, [df])]

    def loss(th):
        try:
            Gd = posthoc_mq2.two_phase_df(th)
            Gs = {df: Gd(df) for df in mq2.ALL_DFS}
            v = sum(mq2.resid(Gs[df], x, y) ** 2 for x, y, df in pairs)
        except (OverflowError, ValueError, ZeroDivisionError):
            return 1e18
        return v if math.isfinite(v) else 1e18
    f0 = json.load(open(os.path.join(mq2.OUT, 'posthoc-mq2.json')))['P2']['theta']
    th, v = mq2.nelder_mead(loss, f0)
    th, v = mq2.nelder_mead(loss, th, step=0.05)
    G = df_map(th)
    out = {'scope': 'development: Dai et al. 2012 bifurcation data, read in MQ1 and MQ2; not a test',
           'theta': th, 'theta_frozen': DF_THETA, 'pairs': len(pairs), 'rmse': math.sqrt(v / len(pairs)),
           'fold_df': df_fold(G),
           'states': {d: state_at(lambda z, d=d: G(z, d), d) for d in (500, 750, 1000, 1266, 1600, 1800, 1900)},
           'schedule': {d: {'df': df_of_day(d), 'past_fold': past_fold(lambda z, d=d: G(z, df_of_day(d)), df_of_day(d))}
                        for d in range(1, 22)},
           'mq2_frozen_fold_df': json.load(open(os.path.join(mq2.OUT, 'fit.json')))['models']['two_phase']['fold_df']}
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, 'development.json'), 'w') as f:
        json.dump(out, f, indent=1, default=str)
    print(json.dumps({k: out[k] for k in ('theta', 'rmse', 'fold_df', 'mq2_frozen_fold_df')}, indent=1))
    if max(abs(a - b) for a, b in zip(th, DF_THETA)) > 1e-9:
        raise SystemExit('the frozen dilution map is not the one development fits')


def fit_odd(directory):
    data = read_sucbif(directory, ODD)
    for i in ODD:
        rows, sc = scale_rows(data[i], 1.7)
        data[i] = rows
    pairs = sucbif_pairs(data, ODD)
    th, v = fit_suc(pairs, suc_starts())
    Gs = suc_map(th)
    out = {'stage': 'fit-odd: the sucrose map on the odd levels only; even levels unread',
           'levels_fitted': [SUCROSE[i - 1] for i in ODD], 'pairs': len(pairs), 'theta': th,
           'rmse': math.sqrt(v / len(pairs)), 'fold_sucrose': suc_fold(Gs),
           'predicted_even': {SUCROSE[i - 1]: state_at(lambda z, i=i: Gs(z, SUCROSE[i - 1]), DF_SUC) for i in EVEN},
           'fitted_odd': {SUCROSE[i - 1]: state_at(lambda z, i=i: Gs(z, SUCROSE[i - 1]), DF_SUC) for i in ODD}}
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, 'fit-odd.json'), 'w') as f:
        json.dump(out, f, indent=1, default=str)
    print(json.dumps(out, indent=1, default=str))


def test_a(directory):
    fo = json.load(open(os.path.join(OUT, 'fit-odd.json')))
    Gs_odd = suc_map(fo['theta'])
    data = read_sucbif(directory, range(1, 10))
    for i in data:
        data[i], _ = scale_rows(data[i], 1.7)
    a1 = rule_a1(data, EVEN, Gs_odd)
    pairs = sucbif_pairs(data, range(1, 10))
    th, v = fit_suc(pairs, suc_starts())
    Gs = suc_map(th)
    fit_all = {'stage': 'fit-all: the sucrose map on all nine levels; the deteriorating runs unread',
               'pairs': len(pairs), 'theta': th, 'rmse': math.sqrt(v / len(pairs)), 'fold_sucrose': suc_fold(Gs),
               'states': {s: state_at(lambda z, s=s: Gs(z, s), DF_SUC) for s in SUCROSE},
               'schedule': {d: {'sucrose': sucrose_of_day(d),
                                'past_fold': past_fold(lambda z, d=d: Gs(z, sucrose_of_day(d)), DF_SUC)}
                            for d in range(1, 26)}}
    a3 = {'empirical_needs': {SUCROSE[i - 1]: rule_a1(data, [i], Gs_odd)['by_level'][i].get('empirical_need')
                              for i in range(1, 10)},
          'note': 'reported only: the paper (Fig. 2B) already shows the need rising as sucrose falls'}
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, 'fit-all.json'), 'w') as f:
        json.dump(fit_all, f, indent=1, default=str)
    with open(os.path.join(OUT, 'VERDICTS-mq6-a.json'), 'w') as f:
        json.dump({'A': a1, 'A3_reported': a3}, f, indent=1, default=str)
    print(json.dumps({'A1': a1['verdict'], 'A2': a1['verdict_A2'], 'tested': [a1['tested_levels_A1'], a1['tested_levels_A2']],
                      'fold_sucrose_all': fit_all['fold_sucrose']}, indent=1))


def deterioration_sets(directory):
    det = os.path.join(directory, 'deterioration')
    sets = {}
    for name in ('subset_DF', 'all_DF', 'subset_DF_control', 'all_DF_control', 'subset_SUC'):
        rows, sc = scale_rows(read_matrix(os.path.join(det, name + '.txt')), 1.7)
        sets[name] = (rows, sc)
    return sets


def run_t(sets, Gdf, Gs, shift=0):
    """T1, T2 and the reported onset for both runs; shift = 1 reads each transfer with the next day's condition."""
    cond_df = lambda d: df_of_day(d + shift)
    df_of_df = lambda d: df_of_day(d + shift)
    cond_s = lambda d: sucrose_of_day(d + shift)
    df_of_s = lambda d: DF_SUC
    out = {}
    for name in ('subset_DF', 'all_DF'):
        pops = sets[name][0]
        out[name] = {'T1': rule_t1(pops, DF_START, cond_df, Gdf, df_of_df),
                     'T2': rule_t2(pops, DF_START, cond_df, Gdf, df_of_df),
                     'onset_day': onset(pops), 'map_fold_day': fold_day(Gdf, cond_df, df_of_df, len(pops[0]))}
    pops = sets['subset_SUC'][0]
    out['subset_SUC'] = {'T1': rule_t1(pops, SUC_START, cond_s, Gs, df_of_s),
                         'T2': rule_t2(pops, SUC_START, cond_s, Gs, df_of_s),
                         'onset_day': onset(pops), 'map_fold_day': fold_day(Gs, cond_s, df_of_s, len(pops[0]))}
    return out


def rule_c1(rows, Gdf):
    vals = sorted(v for r in rows for v in r[DF_START - 1:] if v > FLOOR)
    med = vals[len(vals) // 2] if vals else None
    lvl = state_at(lambda z: Gdf(z, 500.0), 500.0)['stable']
    ratio = (lvl / med) if med else None
    return {'median_reading': med, 'map_level': lvl, 'ratio': ratio,
            'verdict': 'not testable' if med is None else
            ('passed' if abs(math.log(ratio)) <= math.log(LEVEL_FACTOR) else 'failed')}


def test(directory):
    fa = json.load(open(os.path.join(OUT, 'fit-all.json')))
    Gs = suc_map(fa['theta'])
    Gdf = df_map()
    sets = deterioration_sets(directory)
    main = run_t(sets, Gdf, Gs)
    alt = run_t(sets, Gdf, Gs, shift=1)
    G_mq2 = mq2.two_phase(json.load(open(os.path.join(mq2.OUT, 'fit.json')))['models']['two_phase']['theta'])
    G_mq2df = lambda x, df: G_mq2(x)
    mq2_rows = {name: {'T1': rule_t1(sets[name][0], DF_START, df_of_day, G_mq2df, df_of_day),
                       'T2': rule_t2(sets[name][0], DF_START, df_of_day, G_mq2df, df_of_day)}
                for name in ('subset_DF',)}
    c1 = rule_c1(sets['subset_DF_control'][0], Gdf)
    c1_all = rule_c1(sets['all_DF_control'][0], Gdf)
    l_ctl = rule_l(sets['subset_DF_control'][0], Gdf)
    out = {'source': 'Dai, Korolev and Gore 2015, Dryad doi:10.5061/dryad.k30v3 (CC0)',
           'unit_scales': {k: v[1] for k, v in sets.items()},
           'shapes': {k: [len(v[0]), len(v[0][0])] for k, v in sets.items()},
           'main': main,
           'verdicts': {'T1a-DF': main['subset_DF']['T1']['verdict_a'], 'T1b-DF': main['subset_DF']['T1']['verdict_b'],
                        'T2-DF': main['subset_DF']['T2']['verdict'],
                        'T1a-SUC': main['subset_SUC']['T1']['verdict_a'], 'T1b-SUC': main['subset_SUC']['T1']['verdict_b'],
                        'T2-SUC': main['subset_SUC']['T2']['verdict'],
                        'C1': c1['verdict'], 'L': l_ctl['verdict']},
           'C1': c1, 'L': l_ctl,
           'reported': {'C1_all_control': c1_all, 'L_all_control': rule_l(sets['all_DF_control'][0], Gdf),
                        'shifted_reading': alt, 'mq2_frozen_map': mq2_rows}}
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, 'VERDICTS-mq6.json'), 'w') as f:
        json.dump(out, f, indent=1, default=str)
    print(json.dumps({'verdicts': out['verdicts'], 'shapes': out['shapes']}, indent=1))


# ---------------------------------------------------------------- dry runs (synthetic experiments)

def simulate(G_true, n0, days, cond, df_of, rng, sigma=0.08, lag=0.0):
    """One synthetic population: n_{d+1} = G(n_d / DF_d) e^{eps_d} with Poisson sampling of the transferred cells
    (200 ul, 1e5 cells/ul units) and, with lag > 0, a carried anomaly eps_d = lag eps_{d-1} + noise."""
    out = [n0]
    n, e = n0, 0.0
    for d in range(1, days):
        cells = n * 2e7 / df_of(d)
        if cells < 1e4:
            cells = poisson(rng, cells)
        x = cells / 2e7
        e = lag * e + rng.gauss(0, sigma)
        n = G_true(x, cond(d)) * math.exp(e) if x > 0 else 0.0
        out.append(n)
    return out


def poisson(rng, lam):
    if lam <= 0:
        return 0
    if lam > 50:
        return max(0, int(round(rng.gauss(lam, math.sqrt(lam)))))
    L, k, p = math.exp(-lam), 0, 1.0
    while True:
        p *= rng.random()
        if p <= L:
            return k
        k += 1


def write_matrix(path, rows):
    with open(path, 'w') as f:
        for r in rows:
            f.write(' '.join(f'{v:.7e}' for v in r) + '\n')


def synth_experiment(root, G_df, G_s, rng, lag=0.0):
    """Synthetic files in the Dryad layout: SUCbifurcation (9 levels x 6 days, 8 x 11), deterioration subsets."""
    os.makedirs(os.path.join(root, 'SUCbifurcation'), exist_ok=True)
    os.makedirs(os.path.join(root, 'deterioration'), exist_ok=True)
    for i, s in enumerate(SUCROSE, 1):
        days = [[[0.0] * 11 for _ in range(8)] for _ in range(6)]
        for r in range(8):
            for c in range(11):
                x0 = 0.05 / 2 ** c
                n1 = G_s(x0, s) * math.exp(rng.gauss(0, 0.08))
                seq = simulate(lambda x, ss: G_s(x, ss), n1, 6, lambda d: s, lambda d: DF_SUC, rng, lag=lag)
                for d in range(6):
                    days[d][r][c] = seq[d]
        for d in range(6):
            write_matrix(os.path.join(root, 'SUCbifurcation', f'sucrose{i}_day{d + 1}.txt'), days[d])
    lvl = state_at(lambda z: G_df(z, 500.0), 500.0)['stable']
    for name, n_pop, days, kind in (('subset_DF', 20, 21, 'df'), ('all_DF', 48, 21, 'df'),
                                    ('subset_DF_control', 20, 21, 'ctl'), ('all_DF_control', 48, 21, 'ctl'),
                                    ('subset_SUC', 20, 25, 'suc')):
        rows = []
        for _ in range(n_pop):
            if kind == 'df':
                rows.append(simulate(G_df, lvl, days, df_of_day, df_of_day, rng, lag=lag))
            elif kind == 'ctl':
                rows.append(simulate(G_df, lvl, days, lambda d: 500.0, lambda d: 500.0, rng, lag=lag))
            else:
                l5 = state_at(lambda z: G_s(z, 2.0), DF_SUC)['stable'] or lvl
                rows.append(simulate(G_s, l5, days, sucrose_of_day, lambda d: DF_SUC, rng, lag=lag))
        write_matrix(os.path.join(root, 'deterioration', name + '.txt'), rows)


def dry():
    """Six generators. 'hypothesis': the true maps are the frozen dilution map and a sucrose map S (fold 0.15%).
    'carried anomaly': the same with a giving anomaly carried at 0.8 a day. 'earlier dilution fold': the low-density rate
    falls faster with the dilution (beta 1.2; fold DF 1401, passed on day 15). 'level offset': carrying capacity 20% lower
    in both maps. 'sucrose kink within range': S's sucrose exponents 2.5 times steeper below 0.5%. 'sucrose threshold below
    the fitted levels': S's exponents 3 times steeper below 0.16%."""
    global OUT
    base_out = OUT
    rng = random.Random(20261021)
    a, logb, lognc, logk, beta = DF_THETA
    a500 = a - beta * math.log(0.5)
    S = [a500, 0.45, logb, lognc + 1.0, logk, 0.2]

    def kinked(theta, at, factor):
        def G(x, s):
            if s >= at:
                return mq2.two_phase(suc_params(theta, s))(x)
            p_at = suc_params(theta, at)
            th = [p_at[0] + factor * theta[1] * math.log(s / at), p_at[1], p_at[2],
                  p_at[3] + factor * theta[5] * math.log(s / at)]
            return mq2.two_phase(th)(x)
        return G

    def offset_df(theta, d):
        th = list(theta)
        th[3] += d
        return df_map(th)

    G_df = df_map()
    early = list(DF_THETA)
    early[4] = 1.2
    S_off = list(S)
    S_off[4] += math.log(0.8)
    gens = {
        'hypothesis': (G_df, suc_map(S), 0.0),
        'carried anomaly': (G_df, suc_map(S), 0.8),
        'earlier dilution fold': (df_map(early), suc_map(S), 0.0),
        'level offset': (offset_df(DF_THETA, math.log(0.8)), suc_map(S_off), 0.0),
        'sucrose kink within range': (G_df, kinked(S, 0.5, 2.5), 0.0),
        'sucrose threshold below the fitted levels': (G_df, kinked(S, 0.16, 3.0), 0.0),
    }
    results = {}
    scratch = os.environ.get('MQ6_DRY_DIR') or tempfile.mkdtemp(prefix='mq6-dry-')
    for name, (gdf, gs, lag) in gens.items():
        root = os.path.join(scratch, re.sub(r'\W+', '_', name))
        synth_experiment(root, gdf, gs, rng, lag=lag)
        OUT = os.path.join(root, '_out')
        os.makedirs(OUT, exist_ok=True)
        fit_odd(root)
        test_a(root)
        test(root)            # the test's dilution map is the frozen one, whatever the generator's
        v = json.load(open(os.path.join(OUT, 'VERDICTS-mq6.json')))
        va = json.load(open(os.path.join(OUT, 'VERDICTS-mq6-a.json')))
        fa = json.load(open(os.path.join(OUT, 'fit-all.json')))
        m = v['main']
        summ = lambda run: {
            'T1a_k3': m[run]['T1']['every_origin']['k3']['median_abs_log_error'],
            'T1b_k3': m[run]['T1']['late_origins']['k3']['median_abs_log_error'],
            'T2': {k: m[run]['T2'][k] for k in ('agreement', 'median_observed', 'median_predicted')},
            'onset_day': m[run]['onset_day'], 'map_fold_day': m[run]['map_fold_day']}
        results[name] = {'verdicts': {'A1': va['A']['verdict'], 'A2': va['A']['verdict_A2'], **v['verdicts']},
                         'A_tested_levels': [va['A']['tested_levels_A1'], va['A']['tested_levels_A2']],
                         'DF': summ('subset_DF'), 'SUC': summ('subset_SUC'),
                         'fold_sucrose_fitted': fa['fold_sucrose'], 'C1_ratio': v['C1']['ratio'],
                         'L_ac': v['L']['lag1_autocorrelation']}
    OUT = base_out
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, 'dry-runs.json'), 'w') as f:
        json.dump(results, f, indent=1, default=str)
    print(json.dumps({k: r['verdicts'] for k, r in results.items()}, indent=1))


def main(argv):
    if len(argv) < 2:
        raise SystemExit(__doc__)
    cmd = argv[1]
    if cmd == 'layout':
        layout(argv[2])
    elif cmd == 'dev':
        dev(argv[2])
    elif cmd == 'dry':
        dry()
    elif cmd == 'fit-odd':
        fit_odd(argv[2])
    elif cmd == 'test-a':
        test_a(argv[2])
    elif cmd == 'test':
        test(argv[2])
    else:
        raise SystemExit(__doc__)


if __name__ == '__main__':
    main(sys.argv)
