"""UE32's rules: T2's named state against the field's fitted delay embedding, on the field's own criterion,
out-of-sample prediction skill (DESIGN.md). Standard library only.

A stock is one of MQ5's (../margin-measured/mq5.py, its SSB reading): the level x_t the spawning biomass, the draw on
it H_t = kappa C_t, what the draw leaves E_t = x_t - H_t, and the giving g_t = x_{t+1} - x_t + H_t, with kappa, the
training years and the held-out years MQ5's own. The target is the next giving g_t, one step ahead.

The states, each a set of coordinates at year t (scaled by the stock's scale, then standardized on its training rows):
  - N, T2's state named in advance: the level after the draw E_t, the recent giving g_{t-1} and one lag E_{t-1}
    (MQ5's state with the lag), read in T2's written form (E_t, E_{t-1}, g_{t-1}), as MQ5 wrote it. By the balance the
    draw H_t = E_{t-1} - E_t + g_{t-1}, so the same three numbers can be written (E_t, H_t, g_{t-1}); the verdicts with
    N in that form, and with N in whichever form has the less leave-one-out error on the training rows (the written
    form on a tie, and wherever both forms chose theta = 0, the same linear map), are reported.
  - F, the field's delay embedding of the two series T2's state reads, at dimension D: E_t, ..., E_{t-D+1} and
    g_{t-1}, ..., g_{t-D}, with D from 1 to D_MAX chosen by the S-map's own leave-one-out squared error on the
    training rows at each D's theta (the smaller D on a tie). D = 1 is MQ4's state; D = 2 is N with g_{t-2} added.
    The field's usual choice of D, by simplex projection's leave-one-out error, and its verdict are reported.
  - Reported only: L, the level after the draw alone (E_t), and the field's univariate embedding of the giving with
    the draw, U (g_{t-1}, ..., g_{t-D} and H_t, D chosen by simplex).
Every state is read by the same S-map (locally weighted linear regression, weights exp(-theta d / mean d)), its theta
chosen from THETAS by leave-one-out squared error on the training rows (the smaller on a tie), and scored on the
held-out rows, each forecast from the training rows alone. Every state is read on the same rows: years whose giving
exists, whose givings back to t - D_MAX exist and whose escapements back to t - D_MAX + 1 are positive.

Per stock: r = ln(MSE_F / MSE_N), the held-out mean squared errors of the next giving. Over a group of stocks:
  - "T2 fails on the field's criterion": the median r at or below ln 0.9 (the fitted embedding removes a tenth of T2's
    held-out squared error in the median stock) and the field's embedding better in more stocks than T2's state,
    two-sided sign test p < ALPHA. Its reading is frozen: T2's first forbidden item met out of sample (the longer
    history carries more) where the median r over the stocks whose F chose D >= 2 is also at or below ln 0.9;
    otherwise the lag not paying its way out of sample (at D = 1 the field's state is MQ4's, fewer numbers than N);
  - "T2 better than the field's fitted embedding": the median r at or above -ln 0.9 and T2's state better in more
    stocks, p < ALPHA;
  - otherwise "not separated on the field's criterion" (the median within a tenth either way, or the sign test short of
    ALPHA);
  - "not testable" with fewer than MIN_STOCKS stocks that have MIN_TRAIN training rows and MIN_TEST held-out rows.
"""
from __future__ import annotations

import math
import statistics

D_MAX = 4                                    # the field's embeddings of fish stocks: effective dimension <= 4 in 96%
THETAS = (0.0, 0.5, 1.0, 2.0, 4.0, 8.0)      # 0 is the global linear map; the field's grids run to 8
MARGIN = math.log(0.9)                       # a tenth of the held-out squared error
ALPHA = 0.05
MIN_TRAIN = 12                               # training rows a stock needs
MIN_TEST = 8                                 # held-out rows a stock needs
MIN_STOCKS = 10                              # stocks a group needs
RIDGE = 1e-8                                 # added to the normal equations' diagonal, for stability only


# ---------------------------------------------------------------- the series and the states

def series(st):
    """A stock's escapement, giving and draw by year, scaled, from MQ5's stock dict (its b, c, kappa, scale)."""
    k, sc = st['kappa'], st['scale']
    b, c = st['b'], st['c']
    esc = {y: (b[y] - k * c[y]) / sc for y in b}
    draw = {y: k * c[y] / sc for y in b}
    giving = {y: (b[y + 1] - b[y] + k * c[y]) / sc for y in b if y + 1 in b}
    return esc, giving, draw


def coords(name, d, esc, giving, draw, t):
    """The coordinates of state `name` at dimension d in year t."""
    if name == 'N':
        return [esc[t], esc[t - 1], giving[t - 1]]
    if name == 'ND':
        return [esc[t], draw[t], giving[t - 1]]
    if name == 'L':
        return [esc[t]]
    if name == 'F':
        return [esc[t - i] for i in range(d)] + [giving[t - 1 - i] for i in range(d)]
    if name == 'U':
        return [giving[t - 1 - i] for i in range(d)] + [draw[t]]
    raise ValueError(name)


def rows(st):
    """The rows every state is read on, split as MQ5 splits the stock: (training years, held-out years)."""
    esc, giving, draw = series(st)
    ok = [t for t in sorted(giving)
          if all((t - i) in esc and esc[t - i] > 0 for i in range(D_MAX)) and all((t - 1 - i) in giving
                                                                                 for i in range(D_MAX))]
    train = set(st['train'])
    test = set(st['test'])
    return [t for t in ok if t in train], [t for t in ok if t in test]


# ---------------------------------------------------------------- the field's machinery

def standardize(train_x, xs):
    """Each coordinate centred and scaled by its training mean and standard deviation."""
    p = len(train_x[0])
    mu = [statistics.fmean(x[j] for x in train_x) for j in range(p)]
    sd = [statistics.pstdev([x[j] for x in train_x]) or 1.0 for j in range(p)]
    return [[(x[j] - mu[j]) / sd[j] for j in range(p)] for x in xs]


def dist(a, b):
    return math.sqrt(sum((u - v) ** 2 for u, v in zip(a, b)))


def simplex_loo(x, y):
    """Simplex projection's leave-one-out mean absolute error on the training rows: each row forecast from its p + 1
    nearest other rows, weighted exp(-d / d_nearest)."""
    n, p = len(x), len(x[0])
    k = min(p + 1, n - 1)
    err = 0.0
    for i in range(n):
        ds = sorted((dist(x[i], x[j]), j) for j in range(n) if j != i)[:k]
        d0 = ds[0][0]
        w = [math.exp(-d / d0) if d0 > 0 else (1.0 if d == 0 else 0.0) for d, _ in ds]
        s = sum(w) or 1.0
        err += abs(sum(wi * y[j] for wi, (_, j) in zip(w, ds)) / s - y[i])
    return err / n


def solve(a, b):
    """Gaussian elimination with partial pivoting; None if singular."""
    n = len(b)
    m = [row[:] + [b[i]] for i, row in enumerate(a)]
    for c in range(n):
        piv = max(range(c, n), key=lambda r: abs(m[r][c]))
        if abs(m[piv][c]) < 1e-14:
            return None
        m[c], m[piv] = m[piv], m[c]
        for r in range(c + 1, n):
            f = m[r][c] / m[c][c]
            if f:
                for j in range(c, n + 1):
                    m[r][j] -= f * m[c][j]
    out = [0.0] * n
    for r in range(n - 1, -1, -1):
        out[r] = (m[r][n] - sum(m[r][j] * out[j] for j in range(r + 1, n))) / m[r][r]
    return out


def smap_fit(lib_x, lib_y, ds, target, theta):
    """S-map's forecast at `target` from the library rows, given their distances ds to it: weighted least squares on
    [1, coordinates], weights exp(-theta d / mean d)."""
    mean_d = statistics.fmean(ds) or 1.0
    w = [math.exp(-theta * d / mean_d) for d in ds]
    p = len(target) + 1
    xtx = [[0.0] * p for _ in range(p)]
    xty = [0.0] * p
    for wi, x, yi in zip(w, lib_x, lib_y):
        z = [1.0] + x
        for a in range(p):
            wa = wi * z[a]
            xty[a] += wa * yi
            row = xtx[a]
            for b in range(a, p):
                row[b] += wa * z[b]
    for a in range(p):
        xtx[a][a] += RIDGE
        for b in range(a):
            xtx[a][b] = xtx[b][a]
    beta = solve(xtx, xty)
    if beta is None:
        return statistics.fmean(lib_y)
    return beta[0] + sum(bj * tj for bj, tj in zip(beta[1:], target))


def smap_loo(x, y, dm, theta):
    """S-map's leave-one-out mean squared error on the training rows (dm: their distance matrix)."""
    n = len(x)
    err = 0.0
    for i in range(n):
        others = [j for j in range(n) if j != i]
        err += (smap_fit([x[j] for j in others], [y[j] for j in others], [dm[i][j] for j in others], x[i], theta)
                - y[i]) ** 2
    return err / n


def choose_theta(x, y):
    dm = [[dist(a, b) for b in x] for a in x]
    errs = [(smap_loo(x, y, dm, th), th) for th in THETAS]
    best = min(e for e, _ in errs)
    return min(th for e, th in errs if e <= best * (1 + 1e-12)), errs


def read_state(name, d, st, train, test):
    """One state at dimension d: its theta, its leave-one-out squared error on the training rows at that theta, and its
    held-out squared and absolute errors."""
    esc, giving, draw = series(st)
    raw_tr = [coords(name, d, esc, giving, draw, t) for t in train]
    raw_te = [coords(name, d, esc, giving, draw, t) for t in test]
    x_tr = standardize(raw_tr, raw_tr)
    x_te = standardize(raw_tr, raw_te)
    y_tr = [giving[t] for t in train]
    y_te = [giving[t] for t in test]
    theta, errs = choose_theta(x_tr, y_tr)
    pred = [smap_fit(x_tr, y_tr, [dist(x, a) for a in x_tr], x, theta) for x in x_te]
    return {'theta': theta, 'loo': min(e for e, th in errs if th == theta),
            'sq': [(p - o) ** 2 for p, o in zip(pred, y_te)], 'abs': [abs(p - o) for p, o in zip(pred, y_te)],
            'pred': pred}


def simplex_d(name, st, train):
    """The field's usual dimension, reported: simplex's leave-one-out error over D = 1 .. D_MAX on the training rows."""
    esc, giving, draw = series(st)
    y = [giving[t] for t in train]
    errs = []
    for d in range(1, D_MAX + 1):
        raw = [coords(name, d, esc, giving, draw, t) for t in train]
        errs.append((simplex_loo(standardize(raw, raw), y), d))
    best = min(e for e, _ in errs)
    return min(d for e, d in errs if e <= best * (1 + 1e-12))


def fitted(name, st, train, test):
    """The fitted embedding: every D = 1 .. D_MAX read by the S-map at its own theta, the D with the least
    leave-one-out squared error on the training rows chosen (the smaller on a tie); with every D's reading."""
    reads = {d: read_state(name, d, st, train, test) for d in range(1, D_MAX + 1)}
    best = min(r['loo'] for r in reads.values())
    return min(d for d, r in reads.items() if r['loo'] <= best * (1 + 1e-12)), reads


# ---------------------------------------------------------------- per stock and per group

def summary_of(d, r):
    return {'d': d, 'theta': r['theta'], 'loo': r['loo'], 'mse': statistics.fmean(r['sq']),
            'mae': statistics.fmean(r['abs'])}


def log_ratio(a, b):
    return math.log(a / b) if a > 0 and b > 0 else 0.0


def per_stock(st):
    """Every state's held-out errors on one stock, or only its rows where they are too few."""
    train, test = rows(st)
    if len(train) < MIN_TRAIN or len(test) < MIN_TEST:
        return {'rows': [len(train), len(test)], 'testable': False}
    esc, giving, _ = series(st)
    out = {'rows': [len(train), len(test)], 'testable': True}
    written, drawn = read_state('N', 3, st, train, test), read_state('ND', 3, st, train, test)
    linear = written['theta'] == 0.0 and drawn['theta'] == 0.0
    form = 'draw' if not linear and drawn['loo'] < written['loo'] * (1 - 1e-12) else 'lag'
    out['N'] = summary_of(3, written)
    out['N_draw'] = summary_of(3, drawn)
    out['N_chosen'] = dict(summary_of(3, drawn if form == 'draw' else written), form=form)
    out['L'] = summary_of(1, read_state('L', 1, st, train, test))
    dF, readsF = fitted('F', st, train, test)
    out['F'] = summary_of(dF, readsF[dF])
    dS = simplex_d('F', st, train)
    out['F_simplex'] = summary_of(dS, readsF[dS])
    dU = simplex_d('U', st, train)
    out['U'] = summary_of(dU, read_state('U', dU, st, train, test))
    y_tr = [giving[t] for t in train]
    out['persistence'] = statistics.fmean((giving[t - 1] - giving[t]) ** 2 for t in test)
    out['mean'] = statistics.fmean((statistics.fmean(y_tr) - giving[t]) ** 2 for t in test)
    out['r'] = log_ratio(out['F']['mse'], out['N']['mse'])
    out['r_simplex'] = log_ratio(out['F_simplex']['mse'], out['N']['mse'])
    out['r_draw'] = log_ratio(out['F']['mse'], out['N_draw']['mse'])
    out['r_chosen'] = log_ratio(out['F']['mse'], out['N_chosen']['mse'])
    return out


def binom_two_sided(k, n):
    if n == 0:
        return 1.0
    lo = min(k, n - k)
    tail = sum(math.comb(n, i) for i in range(lo + 1)) / 2 ** n
    return min(1.0, 2 * tail)


FAILS = "T2 fails on the field's criterion"
BETTER = "T2 better than the field's fitted embedding"
NOT_SEPARATED = "not separated on the field's criterion"
LONGER = "the longer history carries more (T2's first forbidden item, out of sample)"
LAG = "the lag does not pay its way out of sample (MQ4's state forecasts better)"


def verdict_of(rs):
    """The verdict on a list of per-stock r, with its numbers."""
    f_better = sum(1 for r in rs if r < 0)
    n_better = sum(1 for r in rs if r > 0)
    p = binom_two_sided(f_better, f_better + n_better)
    med = statistics.median(rs)
    if med <= MARGIN and f_better > n_better and p < ALPHA:
        v = FAILS
    elif med >= -MARGIN and n_better > f_better and p < ALPHA:
        v = BETTER
    else:
        v = NOT_SEPARATED
    return v, {'median_r': med, 'f_better': f_better, 'n_better': n_better, 'p': p}


def group_verdicts(stocks):
    """The verdict over a group of MQ5's stocks, its frozen reading, and what is reported beside it."""
    per = [per_stock(st) for st in stocks]
    ok = [p for p in per if p['testable']]
    res = {'stocks': len(per), 'testable': len(ok)}
    if len(ok) < MIN_STOCKS:
        res.update(fitted='not testable', reading='not testable')
        return res, per
    v, nums = verdict_of([p['r'] for p in ok])
    longer = [q['r'] for q in ok if q['F']['d'] >= 2]
    reading = v
    if v == FAILS:
        reading = LONGER if longer and statistics.median(longer) <= MARGIN else LAG
    vs, nums_s = verdict_of([p['r_simplex'] for p in ok])
    vd, nums_d = verdict_of([p['r_draw'] for p in ok])
    vc, nums_c = verdict_of([p['r_chosen'] for p in ok])

    def skill(k, base):
        return statistics.median(1 - q[k]['mse'] / q[base] for q in ok if q[base] > 0)

    def worse(k):
        return sum(1 for q in ok if q[k]['mse'] > q['persistence']) / len(ok)
    res.update(fitted=v, reading=reading, **nums,
               dims={d: sum(1 for q in ok if q['F']['d'] == d) for d in range(1, D_MAX + 1)},
               by_d={d: {'stocks': len(rd), 'median_r': statistics.median(rd), 'f_better': sum(1 for r in rd if r < 0)}
                     for d in range(1, D_MAX + 1) for rd in [[q['r'] for q in ok if q['F']['d'] == d]] if rd},
               median_r_d_at_least_2=statistics.median(longer) if longer else None,
               reported={
                   'simplex': dict(verdict=vs, **nums_s,
                                   dims={d: sum(1 for q in ok if q['F_simplex']['d'] == d)
                                         for d in range(1, D_MAX + 1)}),
                   'draw_form': dict(verdict=vd, **nums_d),
                   'chosen_form': dict(verdict=vc, **nums_c,
                                       N_form_draw=sum(1 for q in ok if q['N_chosen']['form'] == 'draw')),
                   'median_ln_mse_over_N': {k: statistics.median(log_ratio(q[k]['mse'], q['N']['mse']) for q in ok)
                                            for k in ('L', 'U')},
                   'median_ln_mae_F_over_N': statistics.median(log_ratio(q['F']['mae'], q['N']['mae']) for q in ok),
                   'N_skill_vs_persistence': skill('N', 'persistence'),
                   'F_skill_vs_persistence': skill('F', 'persistence'),
                   'N_skill_vs_mean': skill('N', 'mean'),
                   'share_worse_than_persistence': {k: worse(k) for k in ('N', 'F')},
                   'N_theta_zero': sum(1 for q in ok if q['N']['theta'] == 0.0)})
    return res, per
