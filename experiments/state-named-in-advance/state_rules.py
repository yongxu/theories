"""UE31's rules: T2's state against the life stages, on a list of cultures (standard library only).

A culture is a dict with
  'id'     a name,
  'group'  'primary' (adult loss set by hand, recruitment left to the culture) or 'control' (neither set),
  'mu'     the adult loss set per census step (primary), or None (control: no draw),
  'L', 'P', 'A'  the census counts at t = 0 .. T, one census every two weeks, A the adults returned after the census,
  optionally 'recorded': 'counted' with 'D', the dead adults counted at each census, when the archive gives the adults
  as counted before the manipulation (returned_adults() then reconstructs the returned adults; DESIGN.md §9).

The reading in T2's terms (DESIGN.md §4): the level is the mature adults A_t; the draw is the set loss mu A_t (none in a
control); the escapement E_t = A_t - draw; the giving G_t = A_{t+1} - E_t, the recruits in a primary culture and the
level's net change in a control. Every count is divided by the culture's largest level over its training censuses.

T2's three numbers, the lag at the delay of renewal: the level E_t, the recent giving G_{t-1} and the escapement whose
eggs are now the pupae, E_{t-2} (two census steps, from the life cycle). With the draw a fixed share of the level,
G_{t-1} = E_t / (1 - mu) - E_{t-1}, so the three numbers span E_t, E_{t-1}, E_{t-2}. For the in-sample tests T2's
state (`T2`) is a law quadratic in the three, with every cross term, and cubic in the level, so that a wrong form of
the law does not count against the state; for forecasts, iterated, its law is MQ5's lean form (`T2F`). The one-step
reading (the lag one census back, MQ5's position) is reported (`ONE`).

The rules are fixed in DESIGN.md §6; this file computes them and nothing else.
"""
from __future__ import annotations

import math
import statistics

NEEDED = 0.10        # T2's bound: a further variable removing a tenth of the residual variance in the median series
ALPHA = 0.05         # detection
SPLIT = 0.6          # the training share of each culture's in-sample rows, in time order (forecasts)
HORIZON = 5          # census steps (ten weeks): T2's "five years" at this grain
FLOOR = 0.01         # forecasts and observations floored at 1% of the training level's peak
FIRST = 4            # the first in-sample census (E_{t-3} is read; the first censuses are the start's transient)
MIN_ROWS = 20        # in-sample rows a culture needs
MIN_TEST = 8         # test rows a culture needs for the forecasts
MIN_CULTURES = 6     # cultures a group needs for a verdict
MINORITY = 0.20      # V5: the less common sign's share among detected cultures, at least two of them
V5_MIN = 6           # V5: detected cultures it needs; the sign: cultures where the two sign rules differ (the fewest
                     # at which a two-sided sign test can reach p < 0.05)
CPA = 0.004619       # the field's adult-pupa cannibalism (Dennis et al. 2001, Table 1, CLS, controls); reported only
# the rival's sign for the lag (DESIGN.md §3): sign of sum_t w_t (1 - c_ea A_{t-2}), w_t = exp(-c_el L_{t-2} -
# c_ea A_{t-2} - c_pa A_t), under each set of the field's constants (c_el, c_ea, c_pa); a culture is predicted only where
# the sets agree, a robustness band. 2001: Dennis et al. 2001, Table 1 (read); recalled: a set recalled from memory,
# not checked, its source uncertain (perhaps Dennis et al. 1995). Turning points 1 / c_ea: about 76 and 91 adults.
FIELD = {'2001': (0.01731, 0.01310, 0.004619), 'recalled, source uncertain': (0.0093, 0.0110, 0.0178)}
TOL = 1e-10          # rank: the least pivot of a normalized cross-product matrix

LEVEL = ['E', 'E*E', 'E*E*E']                            # the level law
RECENT = ['E1', 'E1*E1', 'E*E1']                         # the recent giving, through E_{t-1}
LAG = ['E2', 'E2*E2', 'E*E2', 'E1*E2']                   # the lag at the delay, E_{t-2}
T2 = LEVEL + RECENT + LAG                                # T2's state: ten columns, three numbers

MODELS = {
    'NOLAG': LEVEL + RECENT,                             # the level and the recent giving
    'T2': T2,
    'H1': T2 + ['E3', 'E3*E3'],                          # H1: more of the condition's own course
    'W': T2 + ['P', 'P*E'],                              # W: the pupae, the recruits to be
    'RB': ['P', 'P*E', 'E'],                             # the rival's state for the next giving: pupae and adults
    'V2': ['P', 'P*E', 'E', 'E1', 'E2', 'E1*E1', 'E2*E2'],   # the rival's state with T2's numbers beyond it
    'T2F': LEVEL + ['E1', 'E2'],                         # T2's lean law for forecasts (MQ5's form, the lag at the delay)
    'M1': LEVEL,                                         # the level alone, with the same level law
    'TL': T2 + ['L', 'L*L'],                             # reported: the larvae beyond T2's state
    'TX': T2 + ['PX'],                                   # reported: the field's own recruitment term
    'ONE': ['E', 'E*E', 'E*E*E', 'E1', 'E1*E1'],         # reported: the one-step reading (MQ5's position)
    'ONEH': ['E', 'E*E', 'E*E*E', 'E1', 'E1*E1', 'E2', 'E2*E2'],
    'ONEW': ['E', 'E*E', 'E*E*E', 'E1', 'E1*E1', 'P', 'P*E'],
}
# the coarser grain (every other census, reported only): the delay is one step, so T2's numbers are E_t and E_{t-1}
COARSE = {
    'NOLAG': LEVEL,
    'T2': LEVEL + RECENT,
    'H1': LEVEL + RECENT + ['E2', 'E2*E2'],
    'W': LEVEL + RECENT + ['P', 'P*E', 'L', 'L*E'],
    'RB': ['P', 'P*E', 'L', 'L*E', 'E'],
    'V2': ['P', 'P*E', 'L', 'L*E', 'E', 'E1', 'E1*E1'],
    'T2F': LEVEL + ['E1'],
    'M1': LEVEL,
}


# ---------------------------------------------------------------- linear algebra and tests

def inverse(m, tol=TOL):
    """The inverse of a small square matrix by Gauss-Jordan elimination, or None where a pivot falls below tol."""
    n = len(m)
    a = [row[:] + [1.0 if i == j else 0.0 for j in range(n)] for i, row in enumerate(m)]
    for col in range(n):
        piv = max(range(col, n), key=lambda r: abs(a[r][col]))
        if abs(a[piv][col]) < tol:
            return None
        a[col], a[piv] = a[piv], a[col]
        pv = a[col][col]
        a[col] = [x / pv for x in a[col]]
        for r in range(n):
            if r != col and a[r][col] != 0:
                f = a[r][col]
                a[r] = [x - f * y for x, y in zip(a[r], a[col])]
    return [row[n:] for row in a]


def normalized(cols):
    """The columns scaled to unit norm, and the norms (every column here is nonzero: zero columns are dropped)."""
    norms = [math.sqrt(sum(v * v for v in c)) for c in cols]
    return [[v / s for v in c] for c, s in zip(cols, norms)], norms


def ols(y, cols):
    """Coefficients and residual sum of squares of y on the columns (no intercept), or None where the columns, scaled
    to unit norm, are of less than full rank."""
    p = len(cols)
    if p == 0:
        return [], sum(v * v for v in y)
    u, norms = normalized(cols)
    xtx = [[sum(ci * cj for ci, cj in zip(u[i], u[j])) for j in range(p)] for i in range(p)]
    inv = inverse(xtx)
    if inv is None:
        return None
    xty = [sum(c * v for c, v in zip(u[i], y)) for i in range(p)]
    b = [sum(inv[i][j] * xty[j] for j in range(p)) for i in range(p)]
    rss = sum((v - sum(b[j] * u[j][k] for j in range(p))) ** 2 for k, v in enumerate(y))
    return [bj / s for bj, s in zip(b, norms)], rss


def betainc(a, b, x):
    """The regularized incomplete beta function I_x(a, b), by its continued fraction (modified Lentz)."""
    if x <= 0:
        return 0.0
    if x >= 1:
        return 1.0
    if x > (a + 1) / (a + b + 2):
        return 1.0 - betainc(b, a, 1.0 - x)
    lfront = math.lgamma(a + b) - math.lgamma(a) - math.lgamma(b) + a * math.log(x) + b * math.log(1 - x)
    tiny = 1e-300
    c, d = 1.0, 1.0 - (a + b) * x / (a + 1)
    d = 1.0 / (d if abs(d) > tiny else tiny)
    f = d
    for m in range(1, 300):
        for num in (m * (b - m) * x / ((a + 2 * m - 1) * (a + 2 * m)),
                    -(a + m) * (a + b + m) * x / ((a + 2 * m) * (a + 2 * m + 1))):
            d = 1.0 + num * d
            d = 1.0 / (d if abs(d) > tiny else tiny)
            c = 1.0 + num / c
            c = c if abs(c) > tiny else tiny
            f *= c * d
        if abs(c * d - 1.0) < 1e-12:
            break
    return math.exp(lfront) * f / a


def f_sf(f, q, dof):
    """P(F(q, dof) > f)."""
    if f <= 0:
        return 1.0
    return betainc(dof / 2.0, q / 2.0, dof / (dof + q * f))


def robust_p(y, base, added):
    """The added columns' heteroscedasticity-robust Wald test (HC3), W / q referred to F(q, n - p), or None. The
    statistic does not depend on the columns' scale, so they are taken at unit norm."""
    cols, _ = normalized(base + added)
    n, p, q = len(y), len(cols), len(added)
    if n - p <= 0 or q == 0:
        return None
    xtx = [[sum(ci * cj for ci, cj in zip(cols[i], cols[j])) for j in range(p)] for i in range(p)]
    inv = inverse(xtx)
    if inv is None:
        return None
    xty = [sum(c * v for c, v in zip(cols[i], y)) for i in range(p)]
    beta = [sum(inv[i][j] * xty[j] for j in range(p)) for i in range(p)]
    omega = [[0.0] * p for _ in range(p)]
    for k in range(n):
        x = [cols[j][k] for j in range(p)]
        e = y[k] - sum(bj * xj for bj, xj in zip(beta, x))
        ix = [sum(inv[a][b] * x[b] for b in range(p)) for a in range(p)]
        h = sum(xa * ia for xa, ia in zip(x, ix))
        if h >= 1 - 1e-12:
            return None
        w = e * e / (1 - h) ** 2
        for a in range(p):
            for b in range(p):
                omega[a][b] += w * x[a] * x[b]
    cov = [[sum(inv[a][i] * sum(omega[i][j] * inv[j][b] for j in range(p)) for i in range(p)) for b in range(p)]
           for a in range(p)]
    idx = list(range(p - q, p))
    d = [math.sqrt(cov[i][i]) if cov[i][i] > 0 else 0.0 for i in idx]
    if min(d) <= 0:
        return None
    sinv = inverse([[cov[i][j] / (d[a] * d[b]) for b, j in enumerate(idx)] for a, i in enumerate(idx)])
    if sinv is None:
        return None
    bq = [beta[i] / d[a] for a, i in enumerate(idx)]
    wald = sum(bq[i] * sinv[i][j] * bq[j] for i in range(q) for j in range(q))
    return f_sf(wald / q, q, n - p)


def binom_two_sided(k, n):
    """Two-sided sign test: twice the smaller tail of Binomial(n, 1/2), capped at 1."""
    if n == 0:
        return None
    tail = sum(math.comb(n, i) for i in range(0, min(k, n - k) + 1)) / 2 ** n
    return min(1.0, 2 * tail)


# ---------------------------------------------------------------- the reading

def returned_adults(c):
    """The adults returned after each census: as recorded, or reconstructed from adults counted before the manipulation
    and the dead adults counted (survivors = returned before less the dead; recruits = counted less survivors; the
    returned = recruits + the set share of the returned before, rounded half to even; the protocol's own rounding is
    read at the layout, DESIGN.md §9)."""
    if c.get('recorded', 'returned') == 'returned':
        return list(c['A'])
    A, D = c['A'], c['D']
    ret = [A[0]]
    for t in range(1, len(A)):
        survivors = ret[-1] - D[t]
        recruits = A[t] - survivors
        ret.append(recruits + (round((1 - c['mu']) * ret[-1]) if c['mu'] else survivors))
    return ret


def reading(c):
    """The culture in T2's terms, scaled, through its last census with any animal."""
    A = returned_adults(c)
    P, L = c['P'], c['L']
    last_alive = max(t for t in range(len(A)) if A[t] + P[t] + L[t] > 0)
    A, P, L = A[:last_alive + 1], P[:last_alive + 1], L[:last_alive + 1]
    mu = c['mu'] or 0.0
    T = len(A) - 1
    rows = list(range(FIRST, T))                  # t from FIRST, with t + 1 in the run
    ntrain = int(SPLIT * len(rows))
    last = rows[ntrain - 1] + 1 if ntrain else 1  # the last census a training row reads
    s = max(A[:last + 1]) or 1.0
    a = [x / s for x in A]
    e = [(1 - mu) * x for x in a]
    g = [a[t + 1] - e[t] for t in range(T)]
    return {'A': a, 'P': [x / s for x in P], 'L': [x / s for x in L], 'E': e, 'G': g, 'mu': mu,
            'rows': rows, 'ntrain': ntrain, 'scale': s, 'rawA': A}


def factor(r, f, t):
    if f[0] == 'E':
        return r['E'][t - int(f[1:] or 0)]
    if f == 'P':
        return r['P'][t]
    if f == 'L':
        return r['L'][t]
    if f == 'PX':
        return r['P'][t] * math.exp(-CPA * r['rawA'][t])
    raise KeyError(f)


def column(r, name, t):
    x = 1.0
    for f in name.split('*'):
        x *= factor(r, f, t)
    return x


def design(r, names, rows):
    return [[column(r, n, t) for t in rows] for n in names], [r['G'][t] for t in rows]


def zero_columns(r, models, rows):
    """The columns identically zero over the culture's rows (an adult count of zero at a regular phase makes a product
    vanish); they are dropped from every model alike in that culture, and recorded."""
    names = sorted({n for names in models.values() for n in names})
    return {n for n in names if all(column(r, n, t) == 0.0 for t in rows)}


def excess(rss_base, rss_full, n, p_base, q):
    """Share of the residual sum of squares removed by q added columns, less the chance level q / (n - p)."""
    if rss_base is None or rss_full is None or rss_base <= 0 or q <= 0:
        return None
    return (rss_base - rss_full) / rss_base - q / (n - p_base)


COMPARISONS = {   # name: (base, full), each an excess of the full model over its base
    'H1': ('T2', 'H1'), 'V2': ('RB', 'V2'), 'W': ('T2', 'W'), 'lag': ('NOLAG', 'T2'),
    'TL': ('T2', 'TL'), 'TX': ('T2', 'TX'), 'ONEH': ('ONE', 'ONEH'), 'ONEW': ('ONE', 'ONEW'),
}


def in_sample(r, models, coarse=False):
    """Each comparison's excess and robust test over the in-sample rows; a comparison whose models are singular in this
    culture is None (the culture is left out of that comparison only)."""
    rows = r['rows']
    n = len(rows)
    zero = zero_columns(r, models, rows)
    live = {m: [c for c in names if c not in zero] for m, names in models.items()}
    out = {'n': n, 'zero_columns': sorted(zero)}
    fits = {}
    for m, names in live.items():
        cols, y = design(r, names, rows)
        fits[m] = ols(y, cols) if n - len(names) > 0 else None
    for key, (base, full) in COMPARISONS.items():
        if base not in live or full not in live:
            continue
        fb, ff = fits[base], fits[full]
        added = [c for c in live[full] if c not in live[base]]
        out['x_' + key] = excess(fb and fb[1], ff and ff[1], n, len(live[base]), len(added))
        if out['x_' + key] is not None and key in ('H1', 'V2', 'W', 'lag'):
            bc, y = design(r, live[base], rows)
            ac, _ = design(r, added, rows)
            out['p_' + key] = robust_p(y, bc, ac)
    # V5: the lag's effect, dG/dE_{t-2} at the culture's means, from T2's law (for a law quadratic in the numbers, the
    # mean of its slope over the rows); the rival's sign, the field's slope averaged over the same rows (DESIGN.md §3)
    if fits.get('T2') is not None and not coarse:
        beta = dict(zip(live['T2'], fits['T2'][0]))
        mean = {k: statistics.fmean(r['E'][t - j] for t in rows) for k, j in (('E', 0), ('E1', 1), ('E2', 2))}
        out['lag_effect'] = (beta.get('E2', 0.0) + 2 * beta.get('E2*E2', 0.0) * mean['E2']
                             + beta.get('E*E2', 0.0) * mean['E'] + beta.get('E1*E2', 0.0) * mean['E1'])
        A, L = r['rawA'], [x * r['scale'] for x in r['L']]
        signs = {}
        for name, (cel, cea, cpa) in FIELD.items():
            s = sum(math.exp(-cel * L[t - 2] - cea * A[t - 2] - cpa * A[t]) * (1 - cea * A[t - 2]) for t in rows)
            signs[name] = 1 if s > 0 else -1 if s < 0 else 0
        out['rival_signs'] = signs
        out['rival_sign'] = signs['2001'] if len(set(signs.values())) == 1 else 0
    # the measured error (primary cultures, the census grain): the binomial variance of recruitment given the pupae
    if r['mu'] and not coarse:
        fl, bad = [], 0
        for t in rows:
            g, p = r['G'][t] * r['scale'], r['P'][t] * r['scale']
            if p > 0:
                if g > p + 0.5 + 1e-6:
                    bad += 1
                gg = min(max(g, 0.0), p)
                fl.append(gg * (1 - gg / p) / r['scale'] ** 2)
        out['recruits_above_pupae'] = bad
        floor = statistics.fmean(fl) if fl else None
        if floor:
            for m in ('T2', 'RB'):
                if fits.get(m) is not None:
                    out['resid_over_floor_' + m] = fits[m][1] / n / floor
    return out


def law_value(beta, names, e_hist):
    """A fitted law's giving at a simulated course, e_hist[-1] the escapement now."""
    v = {'E': e_hist[-1], 'E1': e_hist[-2], 'E2': e_hist[-3]}
    total = 0.0
    for b, name in zip(beta, names):
        x = 1.0
        for f in name.split('*'):
            x *= v[f]
        total += b * x
    return total


def out_of_sample(r, models):
    """Each law fitted on the training rows: the mean squared error on the next giving over the test rows (T2's lean
    law and the rival's state), and five-step forecasts of the level by T2's lean law and by the level alone, the set
    loss known."""
    rows, k = r['rows'], r['ntrain']
    train, test = rows[:k], rows[k:]
    if len(test) < MIN_TEST:
        return None
    zero = zero_columns(r, {m: models[m] for m in ('M1', 'T2F', 'RB')}, train)
    live = {m: [c for c in models[m] if c not in zero] for m in ('M1', 'T2F', 'RB')}
    out = {}
    laws = {}
    for m, names in live.items():
        cols, y = design(r, names, train)
        f = ols(y, cols) if len(train) > len(names) else None
        if f is None:
            return None
        laws[m] = f[0]
    for m in ('T2F', 'RB'):
        cols, y = design(r, live[m], test)
        out['mse_' + m] = statistics.fmean((v - sum(b * c[i] for b, c in zip(laws[m], cols))) ** 2
                                           for i, v in enumerate(y))
    A, E, mu = r['A'], r['E'], r['mu']
    T = len(A) - 1
    errs = {'M1': [], 'T2F': []}
    for t0 in range(test[0], T - HORIZON + 1):
        for m in errs:
            hist = [E[t0 - 2], E[t0 - 1]]
            x = A[t0]
            for _ in range(HORIZON):
                hist.append((1 - mu) * x)
                x = max(hist[-1] + law_value(laws[m], live[m], hist), FLOOR)
            errs[m].append(abs(math.log(max(x, FLOOR) / max(A[t0 + HORIZON], FLOOR))))
    out['err'] = errs
    return out


def analyse(cultures, coarse=False, min_rows=MIN_ROWS):
    """Every culture's in-sample and forecast numbers; cultures with fewer than min_rows rows are counted, not read."""
    models = COARSE if coarse else MODELS
    per, short = [], 0
    for c in cultures:
        r = reading(c)
        if len(r['rows']) < min_rows:
            short += 1
            continue
        per.append({'id': c['id'], 'mu': c['mu'], 'in': in_sample(r, models, coarse), 'out': out_of_sample(r, models)})
    return per, short


def level_median(per, key):
    """The median of the per-loss medians over every set loss present (one level in a control group), with each loss's
    median and count."""
    levels = {}
    for p in per:
        v = p['in'].get(key)
        if v is not None:
            levels.setdefault(p['mu'], []).append(v)
    by = {str(mu): [statistics.median(v), len(v)] for mu, v in levels.items()}
    meds = [statistics.median(v) for v in levels.values()]
    return (statistics.median(meds) if meds else None), by


def combine(per, short=0):
    """The frozen verdicts on one group (DESIGN.md §6), with everything reported beside them."""
    res = {'cultures': len(per), 'too_short': short}
    if len(per) < MIN_CULTURES:
        res['testable'] = False
        return res
    res['testable'] = True
    res['losses'] = len({p['mu'] for p in per})

    def det(key):
        return sum(1 for p in per if p['in'].get(key) is not None and p['in'][key] < ALPHA)
    # W: T2's first forbidden item as worded ("as far as anything measured does"): the pupae, the recruits to be
    res['W_excess'], res['W_by_loss'] = level_median(per, 'x_W')
    res['W_detected'] = det('p_W')
    res['W'] = 'the wording holds' if res['W_excess'] is not None and res['W_excess'] < NEEDED else 'the wording fails'
    # H1: T2's first forbidden item read on the condition's own course
    res['H1_excess'], res['H1_by_loss'] = level_median(per, 'x_H1')
    res['H1_detected'] = det('p_H1')
    res['H1'] = 'T2 holds' if res['H1_excess'] is not None and res['H1_excess'] < NEEDED else 'T2 fails'
    # V2: the rival's own refuter, T2's numbers beyond the pupae and the adults
    res['V2_excess'], res['V2_by_loss'] = level_median(per, 'x_V2')
    res['V2_detected'] = det('p_V2')
    res['V2'] = 'the rival holds' if res['V2_excess'] is not None and res['V2_excess'] < NEEDED else 'the rival fails'
    # V5: T2's third forbidden item, the lag's coefficient changing sign between series (detected cultures)
    dets = [p for p in per if p['in'].get('p_lag') is not None and p['in']['p_lag'] < ALPHA
            and p['in'].get('lag_effect') is not None]
    pos = sum(1 for p in dets if p['in']['lag_effect'] > 0)
    neg = sum(1 for p in dets if p['in']['lag_effect'] < 0)
    res['V5_detected'], res['V5_signs'] = len(dets), [pos, neg]
    minority = min(pos, neg)
    if len(dets) < V5_MIN:
        res['V5'] = 'not testable'
    else:
        res['V5'] = 'T2 fails' if minority >= 2 and minority >= MINORITY * len(dets) else 'T2 holds'
    # the sign, between the two rules: T2's one sign for every series (the majority sign found over every culture with
    # a lag effect) against the rival's sign for each culture it predicts, fixed before the run; read on the cultures
    # where the two rules differ, detected or not (two-sided sign test)
    allc = [p for p in per if p['in'].get('lag_effect')]
    up = sum(1 for p in allc if p['in']['lag_effect'] > 0)
    one = 1 if 2 * up >= len(allc) else -1
    differ = [p for p in allc if p['in']['rival_sign'] and p['in']['rival_sign'] != one]
    rival_right = sum(1 for p in differ if (p['in']['lag_effect'] > 0) == (p['in']['rival_sign'] > 0))
    t2_right = len(differ) - rival_right
    ps = binom_two_sided(rival_right, len(differ))
    res['sign_counts'] = {'cultures': len(allc), 'positive': up, 'unpredicted':
                          sum(1 for p in allc if not p['in']['rival_sign']), 'rival_predicts_negative':
                          sum(1 for p in allc if p['in']['rival_sign'] < 0), 'rules_differ': len(differ),
                          'rival_right': rival_right, 'T2_right': t2_right, 'p': ps}
    # the gate: the sign reads T2's lag only where three numbers suffice on the course and the further lag is not
    # detected in more cultures than chance gives (one-sided binomial tail at ALPHA)
    n_h1 = sum(1 for p in per if p['in'].get('p_H1') is not None)
    k_h1 = res['H1_detected']
    tail = sum(math.comb(n_h1, i) * ALPHA ** i * (1 - ALPHA) ** (n_h1 - i) for i in range(k_h1, n_h1 + 1)) if n_h1 else 1
    res['H1_detected_tail'] = tail
    if res['H1'] != 'T2 holds':
        res['sign'] = 'not read: the course needs more than three numbers'
    elif tail < ALPHA:
        res['sign'] = 'not read: the further lag is detected in more cultures than chance gives'
    elif len(differ) < V5_MIN:
        res['sign'] = "not separated on the sign: the rival's turning point does not split the cultures"
    elif rival_right > t2_right and ps < ALPHA:
        res['sign'] = "separated on the sign: the rival's"
    elif t2_right > rival_right and ps < ALPHA:
        res['sign'] = "separated on the sign: T2's"
    else:
        res['sign'] = 'not separated on the sign'
    # V4: T2's second forbidden item, the level alone forecasting as well at five steps (MQ5's S4's two criteria, read
    # both ways: T2 holds where T2's law is better on both, fails where the level alone is better on both)
    oos = [p for p in per if p['out'] is not None and p['out']['err']['M1']]
    if len(oos) >= MIN_CULTURES:
        e1 = [x for p in oos for x in p['out']['err']['M1']]
        e3 = [x for p in oos for x in p['out']['err']['T2F']]
        pm = [(statistics.fmean(p['out']['err']['T2F']), statistics.fmean(p['out']['err']['M1'])) for p in oos]
        b3 = sum(1 for a, b in pm if a < b)
        w3 = sum(1 for a, b in pm if a > b)
        pv = binom_two_sided(b3, b3 + w3)
        res['V4_errors'] = {'T2': statistics.median(e3), 'level_alone': statistics.median(e1),
                            'T2_better': b3, 'T2_worse': w3, 'p': pv}
        sig = pv is not None and pv < ALPHA
        res['V4'] = ('T2 holds' if statistics.median(e3) < statistics.median(e1) and b3 > w3 and sig else
                     'T2 fails' if statistics.median(e3) > statistics.median(e1) and w3 > b3 and sig else
                     'not decided')
        ratios = [p['out']['mse_RB'] / p['out']['mse_T2F'] for p in oos if p['out']['mse_T2F'] > 0]
        better = sum(1 for p in oos if p['out']['mse_RB'] < p['out']['mse_T2F'])
        worse = sum(1 for p in oos if p['out']['mse_RB'] > p['out']['mse_T2F'])
        res['reported_V3'] = {'median_ratio': statistics.median(ratios), 'rival_better': better, 'rival_worse': worse,
                              'p': binom_two_sided(better, better + worse)}
    else:
        res['V4'] = 'not testable'
    # how the verdicts combine (DESIGN.md §6): the next step from W and V2, the course from H1
    w, v = res['W'] == 'the wording holds', res['V2'] == 'the rival holds'
    step = ('tie on the next step: both states suffice' if w and v else
            'separated on the next step: the rival\'s state' if v else
            'separated on the next step: T2\'s state' if w else
            'both states incomplete on the next step')
    course = ('three numbers suffice on the course' if res['H1'] == 'T2 holds' else
              'the course needs more than three numbers')
    res['reading'] = step + '; ' + course
    # reported, not verdicts
    for key in ('TL', 'TX', 'ONEH', 'ONEW', 'lag'):
        m, _ = level_median(per, 'x_' + key)
        res['reported_' + key] = m
    fl = [p['in'] for p in per if p['in'].get('resid_over_floor_T2') is not None]
    if fl:
        res['reported_resid_over_floor'] = {
            m: statistics.median(x['resid_over_floor_' + m] for x in fl if 'resid_over_floor_' + m in x)
            for m in ('T2', 'RB')}
        res['reported_rows_recruits_above_pupae'] = sum(x['recruits_above_pupae'] for x in fl)
    res['left_out'] = {k: sum(1 for p in per if p['in'].get('x_' + k) is None) for k in ('W', 'H1', 'V2')}
    res['zero_columns_dropped'] = sum(1 for p in per if p['in']['zero_columns'])
    return res


def group_verdicts(cultures, coarse=False, min_rows=MIN_ROWS):
    per, short = analyse(cultures, coarse, min_rows)
    return combine(per, short), per
