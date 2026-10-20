"""MQ5: a lag and the draw's response in the field (RAM Legacy Stock Assessment Database v4.66).

  python3 -I mq5.py layout XLSX     presence only: the stocks no analysis has read (spawning biomass and catch in
                                    tonnes), the assessment used for each, methods and years; no value read
                                    (results/mq5/layout.json)
  python3 -I mq5.py dev XLSX        the frozen rules on MQ3's and MQ4's stocks, already read there, in both readings
                                    (total biomass, and spawning biomass with the draw's share fitted), and the
                                    choices of LAM and EPS; reads no value of the test stocks
                                    (results/mq5/development.json)
  python3 -I mq5.py dry             the rules on synthetic stocks (ten generators), before any test value
                                    (results/mq5/dry-runs.json)
  python3 -I mq5.py test XLSX       the frozen test on the unread stocks: results/mq5/VERDICTS-mq5.json

Standard library only. XLSX is `RAMLDB v4.66 (assessment data only).xlsx` from Zenodo record 14043031
(md5 of the archive ed6d7cd3f7da1fdcbc60015c3d65014b), extracted outside the repository.

MQ4 found in assessed stocks that the level and the recent giving are both part of a condition's state, that the pair
is not all of it (last year's escapement still adds), and that at ten years the level staying where it is beats every
forecast from the state, while the catch follows the stock. MQ5 tests two things on stocks no analysis has read:

  (a) the state is the level, the recent giving and a lag: the giving's law reads last year's escapement as well,
          SP_t = PHI SP_{t-1} + (1 - PHI) g(E_t) + LAM (E_{t-1} - E_t),
      and by the balance E_{t-1} - E_t = (the draw on the level at t) - SP_{t-1}, the lag is giving moving toward the
      draw;
  (b) the draw read as a law of the stock explains why persistence wins at ten years: with the catch following the
      level, C_t = C_{t0-1} (B_t / B_{t0-1})^EPS (EPS = 0 the held draw of the frozen rest, EPS = 1 a held
      exploitation rate), the loop of giving and draw forecasts without any future catch.

The test stocks carry spawning biomass (SSB) and catch, not total biomass, so the level is SSB and the draw on it is a
share KAPPA of the catch, fitted per stock on its earlier years (the reading, PREDICTIONS-2026-10-21-MQ5.md).
"""
from __future__ import annotations

import json
import math
import os
import random
import statistics
import sys
from collections import Counter, defaultdict

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import mq3  # noqa: E402
import mq4  # noqa: E402
import ram_read  # noqa: E402

OUT = os.path.join(HERE, 'results', 'mq5')

SSB_IDS = {'SSB-MT': 1.0, 'SSB-E03MT': 1e3, 'SSB-E05MT': 1e5, 'SSB-E06MT': 1e6}


# ---------------------------------------------------------------- reading (presence and values)

def series_ids(xlsx, assessids, ids, values):
    """{assessid: {tsid: {year: value or None}}} for the given series ids of the given assessments.
    With values=False the value cell is never kept (presence only)."""
    out = defaultdict(lambda: defaultdict(dict))
    for sheet in ('timeseries.1', 'timeseries.2', 'timeseries.3'):
        it = ram_read.rows(xlsx, sheet)
        h = next(it)
        ix = {k: i for i, k in enumerate(h)}
        for r in it:
            a = r[ix['assessid']] if len(r) > ix['assessid'] else ''
            if a not in assessids:
                continue
            t = r[ix['tsid']]
            if t not in ids:
                continue
            y = int(float(r[ix['tsyear']]))
            if values:
                v = r[ix['tsvalue']] if len(r) > ix['tsvalue'] else ''
                out[a][t][y] = float(v) if v not in ('', None) else None
            else:
                out[a][t][y] = None
    return out


def choose_ssb(ts):
    return next((t for t in SSB_IDS if t in ts), None)


def selection(xlsx):
    """Presence only. The stocks MQ3 and MQ4 read, and, for every current stock not among them, the assessment with
    SSB and catch in tonnes used here: the most recent assessment where it has both, else the latest earlier one
    (ties: the longer run, then the assessid)."""
    states = mq4.stock_states(xlsx)
    A = mq4.assessments(xlsx)
    ids = set(mq3.TB_IDS) | {c for c, _ in mq3.C_IDS} | set(SSB_IDS)
    ts = series_ids(xlsx, set(A), ids, values=False)
    tb_c = {a for a in A if all(mq3.choose_ids(ts.get(a, {})))}
    mq3_assess = {a for a in tb_c if A[a]['mostrecent'] == '999'}
    mq3_stocks = {A[a]['stockid'] for a in mq3_assess}
    mq4_stocks = {A[a]['stockid'] for a in tb_c if A[a]['stockid'] not in mq3_stocks
                  and states.get(A[a]['stockid']) == 'Current'}
    cand = defaultdict(list)
    skipped = Counter()
    for a, info in A.items():
        s = info['stockid']
        c = mq3.choose_ids(ts.get(a, {}))[1]
        b = choose_ssb(ts.get(a, {}))
        if not (b and c):
            continue
        if s in mq3_stocks or s in mq4_stocks:
            continue
        if states.get(s) != 'Current':
            skipped['deprecated stock'] += 1
            continue
        n_run = len(mq3.longest_run(set(ts[a][b]) & set(ts[a][c])))
        cand[s].append((info['mostrecent'] == '999', info['end'], n_run, a))
    chosen = {}
    for s, lst in cand.items():
        lst.sort(key=lambda x: (not x[0], -x[1], -x[2], x[3]))
        chosen[s] = lst[0][3]
    return {'A': A, 'presence': ts, 'mq3_stocks': mq3_stocks, 'mq4_stocks': mq4_stocks, 'chosen': chosen,
            'skipped': skipped}


def layout(xlsx):
    sel = selection(xlsx)
    A, ts, chosen = sel['A'], sel['presence'], sel['chosen']
    cat = mq3.method_categories(xlsx)
    counts = Counter()
    eligible = defaultdict(list)
    recent_catch_parsed = 0
    for s, a in sorted(chosen.items()):
        group, category = mq4.group_of(cat, A[a]['method'])
        b = choose_ssb(ts[a])
        c = mq3.choose_ids(ts[a])[1]
        n_sp = len(mq3.longest_run(set(ts[a][b]) & set(ts[a][c]))) - 1
        if n_sp < mq3.MIN_SP:
            counts[(group, 'short')] += 1
            continue
        counts[(group, 'eligible by presence')] += 1
        # mq3.load parsed in memory (never kept, printed or analysed) the catch of every most recent assessment
        # carrying a catch in tonnes; here, whether this stock's most recent assessment carried one
        recent = [x for x, i in A.items() if i['stockid'] == s and i['mostrecent'] == '999']
        parsed = any(mq3.choose_ids(ts.get(x, {}))[1] or mq3.choose_ids(ts.get(x, {}))[0] for x in recent)
        recent_catch_parsed += bool(parsed)
        eligible[group].append({'stockid': s, 'assessid': a, 'most_recent': A[a]['mostrecent'] == '999',
                                'method': A[a]['method'], 'category': category, 'ssb': b, 'catch': c,
                                'sp_years_present': n_sp})
    out = {'mq3_stocks': len(sel['mq3_stocks']), 'mq4_stocks': len(sel['mq4_stocks']),
           'new_current_stocks_with_ssb_and_catch': len(chosen),
           'skipped': dict(sel['skipped']),
           'by_group': {f'{k[0]} | {k[1]}': v for k, v in sorted(counts.items())},
           'eligible_whose_most_recent_tb_or_catch_was_parsed_by_mq3_load': recent_catch_parsed,
           'eligible': {k: v for k, v in sorted(eligible.items())},
           'scope': 'presence of series and years only; no value was read'}
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, 'layout.json'), 'w') as f:
        json.dump(out, f, indent=1)
    print(json.dumps({k: out[k] for k in out if k != 'eligible'}, indent=1))


# ---------------------------------------------------------------- frozen choices (PREDICTIONS-2026-10-21-MQ5.md)

PHI = mq4.PHI              # MQ4's frozen rate: giving closes 4% of its gap to the level's law each year
LAM = 0.55                 # the lag's weight, chosen on MQ3's and MQ4's stocks by `dev` (least five-year error)
LAM_GRID = [i / 20 for i in range(0, 21)]
EPS = 0.7                  # the draw's elasticity to the level, measured on the draw of MQ3's and MQ4's stocks by `dev`
KAPPA_GRID = [i / 20 for i in range(0, 41)]   # the draw's share on the spawning stock, 0 to 2
NEEDED = 0.10              # nothing more is needed below this median share of residual variance beyond chance
DETECT = 0.20              # a part of the state is detected where its F test (p < 0.05) fires in this share of stocks
SHARE = 0.5                # a reading explains persistence's win where it closes at least this share of the gap
HORIZONS = (1, 5, 10)
MIN_ORIGINS, MIN_STOCKS = 100, 10


# ---------------------------------------------------------------- one stock in a reading

def build(b, c):
    """b, c: {year: value}. The longest consecutive run with a positive level and a catch, or a reason."""
    years = [y for y in b if y in c and b[y] is not None and c[y] is not None and b[y] > 0 and c[y] >= 0]
    run = mq3.longest_run(years)
    sp_years = run[:-1]
    if len(sp_years) < mq3.MIN_SP:
        return None, 'short'
    return {'run': run, 'b': {y: b[y] for y in run}, 'c': {y: c[y] for y in run}, 'sp_years': sp_years}, None


def gam(st, y, k=None):
    """Giving: the level next year less what the draw on the level left this year."""
    k = st['kappa'] if k is None else k
    return st['b'][y + 1] - st['b'][y] + k * st['c'][y]


def esc(st, y, k=None):
    """What the draw leaves: the level less the draw on it."""
    k = st['kappa'] if k is None else k
    return st['b'][y] - k * st['c'][y]


def state_cols(st, ys, k, names):
    """Columns (scaled) for the in-sample regressions: E, EE escapement at t and its square; E1, E1E1 at t-1; E2, E2E2
    at t-2; G1, G2 giving at t-1, t-2; B, BB the level before the draw and its square; ONE a constant."""
    sc = st['scale']
    f = {'E': lambda y: esc(st, y, k) / sc, 'EE': lambda y: (esc(st, y, k) / sc) ** 2,
         'E1': lambda y: esc(st, y - 1, k) / sc, 'E1E1': lambda y: (esc(st, y - 1, k) / sc) ** 2,
         'E2': lambda y: esc(st, y - 2, k) / sc, 'E2E2': lambda y: (esc(st, y - 2, k) / sc) ** 2,
         'G1': lambda y: gam(st, y - 1, k) / sc, 'G2': lambda y: gam(st, y - 2, k) / sc,
         'B': lambda y: st['b'][y] / sc, 'BB': lambda y: (st['b'][y] / sc) ** 2,
         'ONE': lambda y: 1.0}
    return [[f[n](y) for y in ys] for n in names]


def kappas(st, years):
    """The admissible shares: every escapement over the years given positive (the TB reading: 1 only)."""
    if st['reading'] == 'TB':
        return [1.0]
    return [k for k in KAPPA_GRID if all(esc(st, y, k) > 0 for y in years)]


def rss(st, ys, names, ks):
    """The least residual sum of squares of the giving at t on the named columns over the admissible shares, and the
    share attaining it (the share profiled: each model its own). It is least squares in the level's change, since
    the giving is the change plus the draw on the level."""
    best = None
    for k in ks:
        y = [gam(st, t, k) / st['scale'] for t in ys]
        v = mq3.ols_ss(y, state_cols(st, ys, k, names))
        if v is not None and (best is None or v < best[0]):
            best = (v, k)
    return best


def fit_kappa(st, train):
    """The draw's share on the spawning stock, fitted on the training years: the share with the least residual of the
    state with the lag (the giving at t on E_t, E_t^2, the giving at t-1 and E_{t-1}, E_{t-1}^2). MQ4's state without
    the lag biases the share low where the lag holds (dry runs), and the state with it nests MQ4's."""
    ys = [y for y in train if (y - 2) in st['b']]
    ks = kappas(st, set(ys) | {y - 1 for y in ys} | {y - 2 for y in ys})
    best = rss(st, ys, MODELS['M3'], ks)
    return None if best is None else best[1]


def prepare(st, reading):
    """The split (MQ3's), the draw's share, the bad years and the level law g fitted on the training years."""
    sp = st['sp_years']
    n_train = int(math.floor(mq3.TRAIN * len(sp)))
    train = sp[:n_train]
    st.update(reading=reading, scale=max(st['b'][y] for y in train), test=sp[n_train:])
    k = 1.0 if reading == 'TB' else fit_kappa(st, train)
    if k is None:
        return 'no admissible share'
    st['kappa'] = k
    bad = {y for y in sp if esc(st, y) <= 0}
    if len(bad) > mq3.MAX_BAD_E * len(sp):
        return 'catch at or above biomass'
    st['bad'] = bad
    st['train'] = [y for y in train if y not in bad]
    sc = st['scale']
    st['fit'] = mq3.fit_quadratic([esc(st, y) / sc for y in st['train']], [gam(st, y) / sc for y in st['train']])
    if st['fit'] is None:
        return 'degenerate fit'
    return None


def ols_coef(y, cols):
    p = len(cols)
    m = [[sum(ci * cj for ci, cj in zip(cols[i], cols[j])) for j in range(p)] for i in range(p)]
    v = [sum(ci * yi for ci, yi in zip(cols[i], y)) for i in range(p)]
    return mq3.solve(m, v)


def g(st, e):
    """The level's giving law, in the level's units."""
    return mq3.giving(st['fit'], e / st['scale']) * st['scale']


# ---------------------------------------------------------------- forecasts

def project(st, t0, k, giving, draw, phi=PHI, eps=EPS, lam=LAM):
    """The level at t0 + k from the state at t0: the level b_t0, last year's giving, escapement and catch.
    giving: FR (held: the frozen rest), RM (read off what is left, g(E): the regime's step), LG (MQ4's state,
      phi gamma + (1 - phi) g(E)), LGD (the state with the lag, phi gamma + (1 - phi) g(E) + lam (E_prev - E); by the
      balance E_prev - E = draw - gamma_prev, so the giving also moves by lam toward the draw).
    draw: 'actual' (the catches that were taken: the open loop) or 'law' (the closed loop, no future catch used: the
      catch follows the level, C_t = C_{t0-1} (b_t / b_{t0-1})^eps; eps = 0 holds the draw, as the frozen rest does).
    Stops at zero once the draw takes everything."""
    b, c, K = st['b'], st['c'], st['kappa']
    x = b[t0]
    s_prev, e_prev = gam(st, t0 - 1), esc(st, t0 - 1)
    c_ref, b_ref = c[t0 - 1], b[t0 - 1]
    for j in range(k):
        cj = c[t0 + j] if draw == 'actual' else c_ref * (x / b_ref) ** eps
        e = x - K * cj
        if e <= 0:
            return 0.0
        if giving == 'FR':
            s = s_prev
        elif giving == 'RM':
            s = g(st, e)
        elif giving == 'LG':
            s = phi * s_prev + (1 - phi) * g(st, e)
        elif giving == 'LGD':
            s = phi * s_prev + (1 - phi) * g(st, e) + lam * (e_prev - e)
        else:
            raise ValueError(giving)
        s_prev, e_prev = s, e
        x = e + s
        if x <= 0:
            return 0.0
    return x


def origins(st, k):
    """Test years t0 with t0 - k, t0 - 2 and t0 + k in the run and no bad year from t0 - 2 to t0 + k - 1."""
    b = st['b']
    for t0 in st['test']:
        if (t0 + k) not in b or (t0 - k) not in b or (t0 - 2) not in b:
            continue
        if any((t0 + j) in st['bad'] for j in range(-2, k)):
            continue
        yield t0


# name: (giving, draw); 'held' is the law with eps = 0
FORECASTS = {'FR': ('FR', 'actual'), 'RM': ('RM', 'actual'), 'LG': ('LG', 'actual'), 'LGD': ('LGD', 'actual'),
             'CLLG': ('LG', 'law'), 'CLLG0': ('LG', 'held'), 'CL': ('LGD', 'law'), 'CL0': ('LGD', 'held'),
             'FRH': ('FR', 'held')}


def forecast(st, t0, k, name, eps=EPS, phi=PHI, lam=LAM):
    giving, draw = FORECASTS[name]
    if draw == 'held':
        return project(st, t0, k, giving, 'law', phi, 0.0, lam)
    return project(st, t0, k, giving, draw, phi, eps, lam)


def scores(stocks, k, names, eps=EPS, phi=PHI, lam=LAM):
    """Pooled direction calls and |log errors| over k years for the named forecasts, persistence RW (the level stays)
    and, for direction, momentum MO; per-stock mean |log errors| for the sign tests."""
    calls = {m: [0, 0] for m in list(names) + ['MO']}
    errs = {m: [] for m in list(names) + ['RW']}
    per_stock = []
    for st in stocks:
        b = st['b']
        fl = mq3.FLOOR * st['scale']
        le = {m: [] for m in errs}
        for t0 in origins(st, k):
            obs = b[t0 + k] > b[t0]
            p = {m: forecast(st, t0, k, m, eps, phi, lam) for m in names}
            for m in names:
                calls[m][0] += (p[m] > b[t0]) == obs
                calls[m][1] += 1
            calls['MO'][0] += (b[t0] > b[t0 - k]) == obs
            calls['MO'][1] += 1
            p['RW'] = b[t0]
            for m in errs:
                x = abs(math.log(max(p[m], fl) / b[t0 + k]))
                errs[m].append(x)
                le[m].append(x)
        if le['RW']:
            per_stock.append({m: sum(v) / len(v) for m, v in le.items()})
    return {'origins': calls['MO'][1], 'stocks': len(per_stock),
            'accuracy': {m: (v[0] / v[1] if v[1] else None) for m, v in calls.items()},
            'median_abs_log_error': {m: (statistics.median(v) if v else None) for m, v in errs.items()},
            'per_stock': per_stock}


def sign(per_stock, a, b):
    """In how many stocks a's mean |log error| is below b's, and the two-sided sign test."""
    w = sum(p[a] < p[b] for p in per_stock)
    lo = sum(p[a] > p[b] for p in per_stock)
    return {'better': w, 'worse': lo, 'p_two_sided': mq3.binom_two_sided(w, w + lo) if w + lo else None}


def beats(r, a, b):
    """a beats b: a smaller pooled median |log error|, and a smaller mean in more stocks than not, sign test p < 0.05."""
    e, s = r['median_abs_log_error'], sign(r['per_stock'], a, b)
    return (e[a] < e[b] and s['better'] > s['worse'] and s['p_two_sided'] is not None and s['p_two_sided'] < 0.05), s


# ---------------------------------------------------------------- the state in sample

MODELS = {'M1': ['E', 'EE'],                                      # the level law (MQ3)
          'M2': ['E', 'EE', 'G1'],                                # level and recent giving (MQ4)
          'C2': ['G1', 'ONE'], 'C2L': ['G1', 'ONE', 'E', 'EE'],   # MQ4's G2: the level given recent giving
          'M3': ['E', 'EE', 'G1', 'E1', 'E1E1'],                  # with the lag: last year's escapement
          'M4': ['E', 'EE', 'G1', 'E1', 'E1E1', 'G2', 'E2', 'E2E2'],   # two years back as well
          'MO': ['E', 'EE', 'G1', 'B', 'BB']}                     # the other order: the level before the draw


def insample_years(st):
    b, bad = st['b'], st['bad']
    return [y for y in st['sp_years'] if all((y - j) in b and (y - j) not in bad for j in (0, 1, 2))]


def insample(st):
    """Profiled residual sums of squares of each model over every SP year with two years before it, or None."""
    ys = insample_years(st)
    if len(ys) < 20:
        return None
    ks = kappas(st, set(ys) | {y - 1 for y in ys} | {y - 2 for y in ys})
    out = {'n': len(ys), 'extra': 0 if st['reading'] == 'TB' else 1}
    for m, names in MODELS.items():
        r = rss(st, ys, names, ks)
        if r is None:
            return None
        out[m], out['kappa_' + m] = r
    for key, base, full in (('p_G1', 'M1', 'M2'), ('p_level', 'C2', 'C2L'), ('p_lag', 'M2', 'M3')):
        added = MODELS[full][len(MODELS[base]):]
        out[key] = robust_p(st, ys, MODELS[base], added, out['kappa_' + base], out['extra'])
    return out


def excess_of(r, base, full):
    """Share of the residual sum of squares removed by the added columns, less the chance level q / (n - p) (p counts
    the share where it is fitted)."""
    a, b = r[base], r[full]
    if a <= 0:
        return None
    p, q = len(MODELS[base]) + r['extra'], len(MODELS[full]) - len(MODELS[base])
    return (a - b) / a - q / (r['n'] - p)


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


def inverse(m):
    """The inverse of a small square matrix by Gauss-Jordan elimination, or None where it is singular."""
    n = len(m)
    a = [row[:] + [1.0 if i == j else 0.0 for j in range(n)] for i, row in enumerate(m)]
    for col in range(n):
        piv = max(range(col, n), key=lambda r_: abs(a[r_][col]))
        if abs(a[piv][col]) < 1e-14:
            return None
        a[col], a[piv] = a[piv], a[col]
        pv = a[col][col]
        a[col] = [x / pv for x in a[col]]
        for r_ in range(n):
            if r_ != col and a[r_][col] != 0:
                f = a[r_][col]
                a[r_] = [x - f * y for x, y in zip(a[r_], a[col])]
    return [row[n:] for row in a]


def robust_p(st, ys, base, added, k, extra):
    """A heteroscedasticity-robust test of the added columns, at the share k fitted with the base model: the Wald
    statistic with the HC3 sandwich covariance, W / q referred to F(q, n - p). Giving's noise grows with its size in
    the field and in the generators, and there the plain F test fires on columns the law does not read (dry runs).
    Where the share is fitted (extra = 1), the base also carries the residual's derivative in the share (a free
    shift of the share, linearized at k), so that a share misfitted at k cannot pass for the added columns, and the
    added columns cannot hide in the share (dry runs)."""
    y = [gam(st, t, k) / st['scale'] for t in ys]
    cols = state_cols(st, ys, k, base)
    if extra:
        b0 = ols_coef(y, cols)
        if b0 is None:
            return None
        h = 1e-4

        def resid(kk):
            yk = [gam(st, t, kk) / st['scale'] for t in ys]
            ck = state_cols(st, ys, kk, base)
            return [yi - sum(bj * cj[i] for bj, cj in zip(b0, ck)) for i, yi in enumerate(yk)]
        rp, rm = resid(k + h), resid(k - h)
        cols = cols + [[(a - b) / (2 * h) for a, b in zip(rp, rm)]]
    nb = len(cols)
    cols = cols + state_cols(st, ys, k, added)
    n, p, q = len(ys), len(cols), len(added)
    xtx = [[sum(ci * cj for ci, cj in zip(cols[i], cols[j])) for j in range(p)] for i in range(p)]
    inv = inverse(xtx)
    if inv is None or n - p <= 0:
        return None
    beta = [sum(inv[i][j] * sum(cj * yi for cj, yi in zip(cols[j], y)) for j in range(p)) for i in range(p)]
    rows = [[cols[j][i] for j in range(p)] for i in range(n)]
    omega = [[0.0] * p for _ in range(p)]
    for i, x in enumerate(rows):
        e = y[i] - sum(xj * bj for xj, bj in zip(x, beta))
        ix = [sum(inv[a][b] * x[b] for b in range(p)) for a in range(p)]
        h = sum(xa * ia for xa, ia in zip(x, ix))
        if h >= 1:
            return None
        w = e * e / (1 - h) ** 2
        for a in range(p):
            for b in range(p):
                omega[a][b] += w * x[a] * x[b]
    v = [[sum(inv[a][i] * sum(omega[i][j] * inv[j][b] for j in range(p)) for i in range(p)) for b in range(p)]
         for a in range(p)]
    ia = list(range(nb, p))
    vaa = inverse([[v[a][b] for b in ia] for a in ia])
    if vaa is None:
        return None
    ba = [beta[a] for a in ia]
    wald = sum(ba[i] * vaa[i][j] * ba[j] for i in range(q) for j in range(q))
    m = n - p
    f = max(wald / q, 0.0)
    return betainc(m / 2, q / 2, m / (m + q * f))


def f_p(r, base, full):
    """The F test for the added columns: the survival of F(q, m) at the statistic, I_{m / (m + qF)}(m / 2, q / 2)."""
    a, b = r[base], r[full]
    q = len(MODELS[full]) - len(MODELS[base])
    m = r['n'] - len(MODELS[full]) - r['extra']
    if b <= 0 or m <= 0:
        return None
    f = max((a - b) / q / (b / m), 0.0)
    return betainc(m / 2, q / 2, m / (m + q * f))


def rule_state(stocks):
    """In sample, over every SP year of each stock with two years before it.
    S1 MQ4's state on new stocks: recent giving is detected beyond the level (adding SP_{t-1} to E_t, E_t^2) and the
       level beyond recent giving and a constant (adding E_t, E_t^2 to SP_{t-1}, 1), each by its robust test (p < 0.05)
       in at least DETECT of the stocks and more than chance allows (binomial against 0.05, p < 0.001).
    S2 the lag is part of the state: adding E_{t-1}, E_{t-1}^2 to (E_t, E_t^2, SP_{t-1}) is detected (robust test
       p < 0.05) in more stocks than chance allows (binomial against 0.05, p < 0.001). No share floor: in the SSB
       reading the lag's linear part and a shift of the draw's share are one column, which bounds the test's power
       near DETECT where the lag holds (dry runs).
    The tests are robust_p's, at the share fitted with the smaller model, with a free shift of the share in it; the
    plain F tests (each model at its own share) are reported.
    S3 nothing more is needed: adding SP_{t-2}, E_{t-2}, E_{t-2}^2 to the state with the lag removes a median below
       NEEDED of the residual variance beyond chance.
    Reported: the lag's median excess; MQ4's G3 in this form (M2 -> M4); the lag against the other order of draw and
       giving (E_{t-1} and the level before the draw B_t give one linear column; which pair of squares fits better);
       the fitted shares."""
    rs = [r for r in (insample(st) for st in stocks) if r is not None]
    n = len(rs)
    out = {'stocks': n}
    if n < MIN_STOCKS:
        out.update(verdict_S1='not testable', verdict_S2='not testable', verdict_S3='not testable')
        return out
    g1 = [excess_of(r, 'M1', 'M2') for r in rs]
    g1p = [r['p_G1'] for r in rs]
    g2 = [r['p_level'] for r in rs]
    s2 = [r['p_lag'] for r in rs]
    plain = {'recent_giving': sum(p is not None and p < 0.05 for p in (f_p(r, 'M1', 'M2') for r in rs)),
             'level': sum(p is not None and p < 0.05 for p in (f_p(r, 'C2', 'C2L') for r in rs)),
             'lag': sum(p is not None and p < 0.05 for p in (f_p(r, 'M2', 'M3') for r in rs))}
    s2x = [excess_of(r, 'M2', 'M3') for r in rs]
    s3 = [excess_of(r, 'M3', 'M4') for r in rs]
    g3 = [excess_of(r, 'M2', 'M4') for r in rs]
    k_g1 = sum(p is not None and p < 0.05 for p in g1p)
    k_g2 = sum(p is not None and p < 0.05 for p in g2)
    k_s2 = sum(p is not None and p < 0.05 for p in s2)
    out.update({
        'S1_recent_giving_median_excess': statistics.median(g1), 'S1_recent_giving_detected': k_g1,
        'S1_recent_giving_binomial_p': mq4.binom_upper(k_g1, n, 0.05), 'S1_level_detected': k_g2,
        'S1_level_binomial_p': mq4.binom_upper(k_g2, n, 0.05),
        'S2_lag_detected': k_s2, 'S2_share_detected': k_s2 / n, 'S2_binomial_p': mq4.binom_upper(k_s2, n, 0.05),
        'S2_lag_median_excess': statistics.median(s2x), 'S2_lag_quartiles': mq3.quartiles(s2x),
        'S3_median_excess': statistics.median(s3), 'S3_quartiles': mq3.quartiles(s3),
        'S3_share_above_bound': sum(x >= NEEDED for x in s3) / n,
        'reported_MQ4_G3_form_median_excess': statistics.median(g3),
        'reported_lag_fits_better_than_other_order': sum(r['M3'] < r['MO'] for r in rs),
        'reported_kappa_quartiles_M3': mq3.quartiles([r['kappa_M3'] for r in rs]),
        'reported_plain_F_detected': plain})
    out['verdict_S1'] = 'passed' if (k_g1 / n >= DETECT and out['S1_recent_giving_binomial_p'] < 0.001
                                     and k_g2 / n >= DETECT and out['S1_level_binomial_p'] < 0.001) else 'failed'
    out['verdict_S2'] = 'passed' if out['S2_binomial_p'] < 0.001 else 'failed'
    out['verdict_S3'] = 'passed' if out['S3_median_excess'] < NEEDED else 'failed'
    return out


# ---------------------------------------------------------------- forecasts, persistence and the draw

def draw_follows(stocks):
    """D1, the draw follows the stock, in the form the closed loop uses: per stock, the log change in catch,
    log C_t - log C_{t-1}, regressed on the log change in the level, log b_t - log b_{t-1}, with the catch's own last
    level log C_{t-1} and a constant (a catch reverting to its own mean, blind to the stock, otherwise gives a positive
    slope: a high catch lowers the level and then reverts; dry runs). Passed if the slope on the level's change is
    positive in more stocks than not, two-sided sign test p < 0.05. Reported: MQ4's post-hoc form (next year's change
    in catch on the last change in the level, no control)."""
    slopes, lagged = [], []
    for st in stocks:
        b, c = st['b'], st['c']
        xs, zs, ys, xl, yl = [], [], [], [], []
        for t in st['run']:
            if (t - 1) in b and min(c[t], c[t - 1]) > 0:
                xs.append(math.log(b[t] / b[t - 1]))
                zs.append(math.log(c[t - 1]))
                ys.append(math.log(c[t] / c[t - 1]))
            if all(v in b for v in (t - 1, t, t + 1)) and min(c[t], c[t + 1]) > 0:
                xl.append(math.log(b[t] / b[t - 1]))
                yl.append(math.log(c[t + 1] / c[t]))
        if len(xs) < 15:
            continue
        co = ols_coef(ys, [xs, zs, [1.0] * len(xs)])
        if co is not None:
            slopes.append(co[0])
        mx, my = sum(xl) / len(xl), sum(yl) / len(yl)
        den = sum((x - mx) ** 2 for x in xl)
        if den > 0:
            lagged.append(sum((x - mx) * (y - my) for x, y in zip(xl, yl)) / den)
    n = len(slopes)
    pos = sum(x > 0 for x in slopes)
    out = {'stocks': n, 'positive_slopes': pos, 'median_slope': statistics.median(slopes) if slopes else None,
           'p_two_sided': mq3.binom_two_sided(pos, n) if n else None,
           'reported_lagged_uncontrolled': {'stocks': len(lagged), 'positive': sum(x > 0 for x in lagged),
                                            'median_slope': statistics.median(lagged) if lagged else None}}
    if n < MIN_STOCKS:
        out['verdict'] = 'not testable'
    else:
        out['verdict'] = 'passed' if (pos > n - pos and out['p_two_sided'] < 0.05) else 'failed'
    return out


def gap_share(e, start, end, base='RW'):
    """The share of the gap between start and persistence that end closes: (e_start - e_end) / (e_start - e_RW)."""
    if e[start] <= e[base]:
        return None
    return (e[start] - e[end]) / (e[start] - e[base])


def rule_forecast(stocks, eps=EPS, phi=PHI, lam=LAM):
    """S4 the lag in the forecast: at five years the state with the lag (LGD) beats MQ4's state (LG), both with the
       actual catches (smaller median |log error|, and smaller in more stocks than not, sign test p < 0.05).
    P1 persistence wins at ten years (MQ4's F10b): its median |log error| is below LG's.
    P2 the lag explains it: LGD closes at least SHARE of the gap between LG and persistence at ten years.
    D2 the draw read as a law of the stock explains it: with MQ4's giving and no future catch, the draw following the
       level (CLLG, eps) closes at least SHARE of the gap between the held draw (CLLG0, eps = 0) and persistence.
    P2 and D2 are not specific alone: any damping draws a forecast toward persistence (dry runs). The lag's specific
       tests are S2 and S4, the draw's D1.
    Reported, not verdicts (the hypothesis does not imply them; dry runs): whether the closed loop with the lag (CL)
       beats persistence at ten years, and whether it beats the same giving with the actual catches; every
       class at one, five and ten years (direction and error); the frozen rest with the draw held as well (FRH)."""
    names = ['FR', 'RM', 'LG', 'LGD', 'CLLG', 'CLLG0', 'CL', 'CL0', 'FRH']
    r = {k: scores(stocks, k, names, eps, phi, lam) for k in HORIZONS}
    out = {f'k{k}': {kk: v for kk, v in r[k].items() if kk != 'per_stock'} for k in HORIZONS}
    for k in HORIZONS:
        ps = r[k]['per_stock']
        out[f'k{k}']['signs'] = {f'{a}<{b}': sign(ps, a, b) for a, b in
                                 (('LGD', 'LG'), ('LG', 'RW'), ('LGD', 'RW'), ('CLLG', 'CLLG0'), ('CL', 'RW'),
                                  ('CL', 'LGD'), ('CL', 'CL0'))}
    ok = {k: r[k]['origins'] >= MIN_ORIGINS and r[k]['stocks'] >= MIN_STOCKS for k in HORIZONS}
    e5, e10 = r[5]['median_abs_log_error'], r[10]['median_abs_log_error']
    if ok[5]:
        out['verdict_S4'] = 'passed' if beats(r[5], 'LGD', 'LG')[0] else 'failed'
    else:
        out['verdict_S4'] = 'not testable'
    if not ok[10]:
        for v in ('P1', 'P2', 'D2'):
            out['verdict_' + v] = 'not testable'
        return out
    out['verdict_P1'] = 'passed' if e10['RW'] < e10['LG'] else 'failed'
    s = gap_share(e10, 'LG', 'LGD')
    out['P2_share'] = s
    out['verdict_P2'] = 'not testable' if s is None else ('passed' if s >= SHARE else 'failed')
    s = gap_share(e10, 'CLLG0', 'CLLG')
    out['D2_share'] = s
    out['verdict_D2'] = 'not testable' if s is None else ('passed' if s >= SHARE else 'failed')
    out['reported_CL_beats_RW_k10'] = beats(r[10], 'CL', 'RW')[0]
    out['reported_CL_beats_LGD_k10'] = beats(r[10], 'CL', 'LGD')[0]
    return out


def run_rules(stocks, eps=EPS, phi=PHI, lam=LAM):
    return {'state': rule_state(stocks), 'forecast': rule_forecast(stocks, eps, phi, lam), 'D1': draw_follows(stocks)}


def verdict_summary(res):
    s = {v: res['state']['verdict_' + v] for v in ('S1', 'S2', 'S3')}
    s['S4'] = res['forecast']['verdict_S4']
    for v in ('P1', 'P2'):
        s[v] = res['forecast']['verdict_' + v]
    s['D1'] = res['D1']['verdict']
    s['D2'] = res['forecast']['verdict_D2']
    return s


# ---------------------------------------------------------------- loading

def load_values(xlsx, assessids):
    ids = set(mq3.TB_IDS) | {c for c, _ in mq3.C_IDS} | set(SSB_IDS)
    return series_ids(xlsx, set(assessids), ids, values=True)


def stock_from(ts_a, reading):
    """One assessment's series read as a stock: TB (total biomass, the draw's share 1) or SSB (spawning biomass, the
    share fitted)."""
    tbid, cid = mq3.choose_ids(ts_a)
    lid = tbid if reading == 'TB' else choose_ssb(ts_a)
    if not lid or not cid:
        return None, 'no level or catch'
    mult = mq3.TB_IDS[lid] if reading == 'TB' else SSB_IDS[lid]
    b = {y: (v * mult if v is not None else None) for y, v in ts_a[lid].items()}
    cm = dict(mq3.C_IDS)[cid]
    c = {y: (v * cm if v is not None else None) for y, v in ts_a[cid].items()}
    st, why = build(b, c)
    if st is None:
        return None, why
    why = prepare(st, reading)
    if why:
        return None, why
    st.update(levelid=lid, cid=cid)
    return st, None


def stocks_of(ts, A, cat, assessids, reading):
    groups, excluded = defaultdict(list), Counter()
    for a in sorted(assessids):
        info = A[a]
        group, category = mq4.group_of(cat, info['method'])
        st, why = stock_from(ts.get(a, {}), reading)
        if st is None:
            excluded[(group, why)] += 1
            continue
        st.update(stockid=info['stockid'], assessid=a, method=info['method'], category=category)
        groups[group].append(st)
    return groups, excluded


def dev_assessments(xlsx):
    """MQ3's assessments (most recent, TB and catch in tonnes) and MQ4's (the earlier assessments it read)."""
    sel = mq4.selection(xlsx)
    return sel['A'], sel['mq3_assess'] | set(sel['chosen'].values())


# ---------------------------------------------------------------- development (MQ3's and MQ4's stocks, already read)

def draw_elasticity(stocks):
    """The draw's law measured on the draw itself: the pooled slope through the origin of log(C_{t0+j} / C_{t0-1}) on
    log(b_{t0+j} / b_{t0-1}), j = 0..9, over the ten-year origins (the form the closed loop uses)."""
    sxy = sxx = 0.0
    n = 0
    for st in stocks:
        b, c = st['b'], st['c']
        for t0 in origins(st, 10):
            for j in range(10):
                if c[t0 + j] > 0 and c[t0 - 1] > 0:
                    x, y = math.log(b[t0 + j] / b[t0 - 1]), math.log(c[t0 + j] / c[t0 - 1])
                    sxy += x * y
                    sxx += x * x
                    n += 1
    return (sxy / sxx if sxx > 0 else None), n


def bridge(tb_stocks, ssb_stocks):
    """The SSB reading against the TB reading on the stocks whose assessment carries both: the fitted share against
    the spawning stock's share of the whole, and the verdicts on the same stocks in each reading."""
    T = {s['assessid']: s for s in tb_stocks}
    S = {s['assessid']: s for s in ssb_stocks}
    both = sorted(set(T) & set(S))
    ratio = [statistics.median(S[a]['b'][y] / T[a]['b'][y] for y in S[a]['run'] if y in T[a]['b']) for a in both]
    kap = [S[a]['kappa'] for a in both]
    mx, my = statistics.mean(ratio), statistics.mean(kap)
    cov = sum((x - mx) * (y - my) for x, y in zip(ratio, kap))
    den = math.sqrt(sum((x - mx) ** 2 for x in ratio) * sum((y - my) ** 2 for y in kap))
    out = {'stocks': len(both), 'median_ssb_share_of_tb': statistics.median(ratio),
           'kappa_quartiles': mq3.quartiles(kap), 'kappa_at_zero': sum(k == 0 for k in kap),
           'correlation_kappa_ssb_share': cov / den if den > 0 else None}
    for name, grp in (('TB', [T[a] for a in both]), ('SSB', [S[a] for a in both])):
        res = run_rules(grp)
        out[name + '_verdicts'] = verdict_summary(res)
        out[name] = res
    return out


def dev(xlsx):
    A, devset = dev_assessments(xlsx)
    ts = load_values(xlsx, devset)
    cat = mq3.method_categories(xlsx)
    out = {'scope': "development: MQ3's and MQ4's stocks, already read there; not a test"}
    groups = {}
    for reading in ('SSB', 'TB'):
        groups[reading], excluded = stocks_of(ts, A, cat, devset, reading)
        out[reading] = {'stocks': {g_: len(v) for g_, v in groups[reading].items()},
                        'excluded': {f'{k[0]} | {k[1]}': v for k, v in sorted(excluded.items())}}
    allssb = [st for v in groups['SSB'].values() for st in v]
    scan = []
    for lam in LAM_GRID:
        r = scores(allssb, 5, ['LGD'], lam=lam)
        scan.append({'lam': lam, 'origins': r['origins'], 'median_abs_log_error_LGD': r['median_abs_log_error']['LGD']})
    best = min(scan, key=lambda x: x['median_abs_log_error_LGD'])
    eps, n_eps = draw_elasticity(allssb)
    out['choices'] = {'lam_scan_k5_all_groups_SSB': scan, 'lam_chosen': best['lam'], 'lam_frozen': LAM,
                      'eps_measured_all_groups_SSB': eps, 'eps_pairs': n_eps, 'eps_chosen': round(eps, 1),
                      'eps_frozen': EPS,
                      'eps_measured_all_groups_TB': draw_elasticity([st for v in groups['TB'].values() for st in v])[0]}
    for reading in ('SSB', 'TB'):
        for g_ in ('primary', 'control', 'other'):
            res = run_rules(groups[reading].get(g_, []))
            out[reading][g_] = res
            out[reading][g_ + '_verdicts'] = verdict_summary(res)
    out['bridge_primary'] = bridge(groups['TB'].get('primary', []), groups['SSB'].get('primary', []))
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, 'development.json'), 'w') as f:
        json.dump(out, f, indent=1, default=str)
    print(json.dumps({'choices': {k: v for k, v in out['choices'].items() if 'scan' not in k},
                      **{r_: {'stocks': out[r_]['stocks'],
                              **{g_: out[r_][g_ + '_verdicts'] for g_ in ('primary', 'control', 'other')}}
                         for r_ in ('SSB', 'TB')},
                      'bridge': {k: v for k, v in out['bridge_primary'].items() if k not in ('TB', 'SSB')}},
                     indent=1, default=str))
    if abs(best['lam'] - LAM) > 1e-9 or abs(round(eps, 1) - EPS) > 1e-9:
        raise SystemExit('the frozen LAM or EPS is not the one development chooses')


# ---------------------------------------------------------------- the test (stocks no analysis has read)

def test(xlsx):
    sel = selection(xlsx)
    A = sel['A']
    chosen = set(sel['chosen'].values())
    ts = load_values(xlsx, chosen)
    cat = mq3.method_categories(xlsx)
    groups, excluded = stocks_of(ts, A, cat, chosen, 'SSB')
    out = {'source': 'RAM Legacy Stock Assessment Database v4.66 (Zenodo 14043031), assessment data only',
           'reading': 'SSB: the level is the spawning biomass, the draw on it a share kappa of the catch',
           'phi': PHI, 'lam': LAM, 'eps': EPS,
           'excluded': {f'{k[0]} | {k[1]}': v for k, v in sorted(excluded.items())},
           'stocks': {g_: len(v) for g_, v in groups.items()}}
    for g_ in ('primary', 'control', 'other'):
        res = run_rules(groups.get(g_, []))
        out[g_] = res
        out[g_ + '_verdicts'] = verdict_summary(res)
    out['fits'] = {g_: [{'stockid': s['stockid'], 'assessid': s['assessid'], 'method': s['method'],
                         'ssb': s['levelid'], 'catch': s['cid'], 'years': [s['run'][0], s['run'][-1]],
                         'train_to': s['train'][-1] if s['train'] else None, 'kappa': s['kappa'],
                         'a': s['fit'][0], 'b': s['fit'][1], 'scale_t': s['scale']} for s in v]
                   for g_, v in groups.items()}
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, 'VERDICTS-mq5.json'), 'w') as f:
        json.dump(out, f, indent=1, default=str)
    print(json.dumps({'stocks': out['stocks'], 'excluded': out['excluded'],
                      'verdicts': {g_: out[g_ + '_verdicts'] for g_ in ('primary', 'control', 'other')}}, indent=1))


# ---------------------------------------------------------------- dry runs (synthetic stocks)

GENERATORS = {'level': ('level', 'reset', 0.0), 'relaxing': ('relaxing', 'reset', 0.0),
              'hypothesis': ('lag', 'law', 0.0), 'hypothesis-noisy': ('lag', 'law', 0.02),
              'lag-reset': ('lag', 'reset', 0.0), 'blind': ('lag', 'blind', 0.0), 'draw-only': ('relaxing', 'law', 0.0),
              'two-lags': ('two-lags', 'law', 0.0), 'drifting': ('drifting', 'reset', 0.0), 'age': ('age', 'age', 0.0)}


def synthetic(kind, rng, n_years=60):
    """One synthetic stock: total biomass, spawning biomass (a share omega of it, 0.4-0.9, exact or with lognormal
    noise 0.02) and catch, over 60 years; K = 1e5 t and Schaefer giving r E (1 - E / K).
    giving: 'level' (read off the level, noise 0.2: MQ3's), 'relaxing' (SP_t = 0.9 SP_{t-1} + 0.1 g(E_t), noise 0.1:
    MQ4's), 'lag' (relaxing + LAM (E_{t-1} - E_t): the hypothesis' giving), 'two-lags' (lag + LAM (E_{t-2} -
    E_{t-1})), 'drifting' (a random walk of its own, MQ4's).
    draw: 'reset' (held catches reset every 3-6 years to a share of the level: MQ3's and MQ4's), 'law' (the catch
    follows the level: C_t = C_{t-1} (b_t / b_{t-1})^EPS with lognormal noise 0.1, from a share 0.05-0.35, at most 0.6
    of the level: the hypothesis' draw), 'blind' (log catch an AR(1) of its own about a share 0.05-0.25 of the first
    level, rho 0.7, innovations 0.15, never reading the level: the stock may end under it)."""
    giving, draw, ssb_noise = GENERATORS[kind]
    if giving == 'age':
        return age_structured(rng, n_years)
    K = 1e5
    r = rng.uniform(0.2, 0.8)
    b = rng.uniform(0.3, 0.9) * K
    omega = rng.uniform(0.4, 0.9)
    tb, ssb, c = {}, {}, {}
    y, until, catch = 1950, 0, 0.0
    s_prev = None
    e_hist = []
    b_prev = None
    for i in range(n_years):
        if draw == 'reset':
            if i >= until:
                u = rng.uniform(0.0, 0.1) if b < 0.25 * K else rng.uniform(0.02, 0.5)
                catch = u * b
                until = i + rng.randint(3, 6)
        else:
            if draw == 'law':
                if b_prev is None:
                    catch = rng.uniform(0.05, 0.35) * b
                else:
                    catch = catch * (b / b_prev) ** EPS * math.exp(rng.gauss(0, 0.1))
                catch = min(catch, 0.6 * b)
            else:   # blind
                if b_prev is None:
                    c_bar, walk = rng.uniform(0.05, 0.25) * b, 0.0
                walk = 0.7 * walk + rng.gauss(0, 0.15)
                catch = c_bar * math.exp(walk)
        tb[y + i] = b
        ssb[y + i] = omega * b * math.exp(rng.gauss(0, ssb_noise)) if ssb_noise else omega * b
        c[y + i] = catch
        e = b - catch
        if e <= 0:
            break
        level_g = r * e * (1 - e / K)
        if s_prev is None:
            s_prev = level_g
        e1 = e_hist[-1] if e_hist else e
        e2 = e_hist[-2] if len(e_hist) >= 2 else e1
        if giving == 'level':
            sp = level_g * math.exp(rng.gauss(0, 0.2))
        elif giving == 'relaxing':
            sp = (0.9 * s_prev + 0.1 * level_g) * math.exp(rng.gauss(0, 0.1))
        elif giving == 'lag':
            sp = (0.9 * s_prev + 0.1 * level_g + LAM * (e1 - e)) * math.exp(rng.gauss(0, 0.1))
        elif giving == 'two-lags':
            sp = (0.9 * s_prev + 0.1 * level_g + LAM * (e1 - e) + LAM * (e2 - e1)) * math.exp(rng.gauss(0, 0.1))
        else:   # drifting
            sp = min(max(s_prev + rng.gauss(0, 0.05 * r * K / 4), -0.1 * r * K), 0.4 * r * K)
        s_prev = sp
        e_hist.append(e)
        b_prev = b
        b = max(e + sp, 0.0)
        if b <= 0:
            break
    return tb, ssb, c


def age_structured(rng, n_years=60):
    """An age-structured stock (ages 1-12), not the hypothesis, reported to see what age structure alone gives:
    natural mortality 0.2, weight (1 - exp(-0.3 a))^3, maturity and selectivity logistic at ages 4 and 3, Beverton-Holt
    recruitment from the spawning biomass (steepness 0.5-0.9) with AR(1) lognormal deviations (rho 0.3-0.8, sigma
    0.4), fishing mortality a bounded random walk (steps 0.15, 0.02-1.0) from 0.05-0.4, catch by Baranov's equation
    over the year. Levels at the start of the year, scaled to an unfished total biomass of 1e5 t."""
    A, M = 12, 0.2
    w = [(1 - math.exp(-0.3 * (a + 1))) ** 3 for a in range(A)]
    mat = [1 / (1 + math.exp(-1.5 * (a + 1 - 4))) for a in range(A)]
    sel = [1 / (1 + math.exp(-1.5 * (a + 1 - 3))) for a in range(A)]
    n = [math.exp(-M * a) for a in range(A)]
    n[-1] /= (1 - math.exp(-M))
    tb0 = sum(x * wa for x, wa in zip(n, w))
    s0 = sum(x * wa * m for x, wa, m in zip(n, w, mat))
    h = rng.uniform(0.5, 0.9)
    rho, dev = rng.uniform(0.3, 0.8), 0.0
    f = rng.uniform(0.05, 0.4)
    tb, ssb, c = {}, {}, {}
    for i in range(n_years):
        y = 1950 + i
        tb[y] = 1e5 * sum(x * wa for x, wa in zip(n, w)) / tb0
        s = sum(x * wa * m for x, wa, m in zip(n, w, mat))
        ssb[y] = 1e5 * s / tb0
        z = [sa * f + M for sa in sel]
        c[y] = 1e5 * sum(x * wa * sa * f / za * (1 - math.exp(-za)) for x, wa, sa, za in zip(n, w, sel, z)) / tb0
        dev = rho * dev + math.sqrt(1 - rho * rho) * rng.gauss(0, 0.4)
        rec = 4 * h * s / (s0 * (1 - h) + s * (5 * h - 1)) * math.exp(dev - 0.08)
        surv = [x * math.exp(-za) for x, za in zip(n, z)]
        n = [rec] + surv[:A - 2] + [surv[A - 2] + surv[A - 1]]
        f = min(max(f * math.exp(rng.gauss(0, 0.15)), 0.02), 1.0)
    return tb, ssb, c


def dry():
    rng = random.Random(20261021)
    out = {}
    for kind in GENERATORS:
        made = [synthetic(kind, rng) for _ in range(150)]
        for reading in ('SSB', 'TB'):
            if reading == 'TB' and kind not in ('hypothesis', 'hypothesis-noisy', 'age'):
                continue
            stocks = []
            for i, (tb, ssb, c) in enumerate(made):
                st, why = build(ssb if reading == 'SSB' else tb, c)
                if st is None or prepare(st, reading):
                    continue
                st.update(stockid=f'{kind}-{i}', assessid=f'{kind}-{i}', method='synthetic', category='synthetic')
                stocks.append(st)
            res = run_rules(stocks)
            out[f'{kind} | {reading}'] = {'stocks': len(stocks), 'verdicts': verdict_summary(res), **res}
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, 'dry-runs.json'), 'w') as f:
        json.dump(out, f, indent=1, default=str)
    print(json.dumps({k: {'stocks': v['stocks'], **v['verdicts']} for k, v in out.items()}, indent=1))


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
    elif cmd == 'test':
        test(argv[2])
    else:
        raise SystemExit(__doc__)


if __name__ == '__main__':
    main(sys.argv)
