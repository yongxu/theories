"""MQ3: the margin of a regime in the field (RAM Legacy Stock Assessment Database v4.66).

  python3 -I mq3.py layout XLSX     presence only (assessments, methods, which series, which years); no value read
  python3 -I mq3.py dry             the rules on synthetic stocks (three generators), before any real value
  python3 -I mq3.py test XLSX       the frozen test: reads the values and writes results/mq3/VERDICTS-mq3.json

Standard library only. XLSX is `RAMLDB v4.66 (assessment data only).xlsx` from Zenodo record 14043031
(md5 of the archive ed6d7cd3f7da1fdcbc60015c3d65014b), extracted outside the repository.

The regime's step is Becoming.RegimeMargin.step read in a fishery: the year's catch C_t is the draw,
taken from the total biomass TB_t, and what is left, the escapement E_t = TB_t - C_t, gives back
SP_t = TB_{t+1} - E_t (the surplus production). The giving law g is fitted on each stock's earlier
years as SP = a E + b E^2 (through the origin: nothing gives nothing), and tested on its later years.
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
import ram_read  # noqa: E402

OUT = os.path.join(HERE, 'results', 'mq3')

# Frozen choices (PREDICTIONS-2026-10-20-MQ3.md).
TB_IDS = {'TB-MT': 1.0, 'TB-E03MT': 1e3}
C_IDS = [('TC-MT', 1.0), ('TC-E03MT', 1e3), ('TL-MT', 1.0), ('TL-E03MT', 1e3), ('TL-E06MT', 1e6)]
PRIMARY = {'Statistical catch at age model', 'Statistical catch at length model', 'Integrated Analysis', 'VPA'}
CONTROL = {'Biomass dynamics model'}
MIN_SP = 25          # surplus-production years in the longest consecutive run
TRAIN = 0.6          # share of the SP years, earliest first, used to fit g
MAX_BAD_E = 0.10     # largest share of years with catch >= biomass before a stock is excluded
HELD = 1.25          # a held catch: each of three years within this factor of their mean
SEP = 1.25           # below / above the regime's point by this factor
FLOOR = 0.01         # forecasts floored at this share of the stock's largest training TB for log errors


# ---------------------------------------------------------------- reading

def method_categories(xlsx):
    it = ram_read.rows(xlsx, 'assessmethod')
    next(it)
    cat = {}
    for r in it:
        r = r + [''] * (3 - len(r))
        c, short = r[0], r[1]
        if short in cat and cat[short] != c:
            cat[short] = 'ambiguous'
        else:
            cat[short] = c
    # MSLM is listed twice (length-based and unknown); it is a multi-stock length-based model either way.
    if cat.get('MSLM') == 'ambiguous':
        cat['MSLM'] = 'Statistical catch at length model'
    return cat


def recent_assessments(xlsx):
    it = ram_read.rows(xlsx, 'assessment')
    h = next(it)
    ix = {k: i for i, k in enumerate(h)}
    out = {}
    for r in it:
        r = r + [''] * (len(h) - len(r))
        if r[ix['mostrecent']] == '999':
            out[r[ix['assessid']]] = {'stockid': r[ix['stockid']], 'method': r[ix['assessmethod']]}
    return out


def series(xlsx, recent, values):
    """{assessid: {tsid: {year: value or None}}} for the TB and catch ids of the recent assessments.
    With values=False the value cell is never kept (presence only)."""
    want = set(TB_IDS) | {c for c, _ in C_IDS}
    out = defaultdict(lambda: defaultdict(dict))
    for sheet in ('timeseries.1', 'timeseries.2', 'timeseries.3'):
        it = ram_read.rows(xlsx, sheet)
        h = next(it)
        ix = {k: i for i, k in enumerate(h)}
        for r in it:
            a = r[ix['assessid']] if len(r) > ix['assessid'] else ''
            if a not in recent:
                continue
            t = r[ix['tsid']]
            if t not in want:
                continue
            y = int(float(r[ix['tsyear']]))
            if values:
                v = r[ix['tsvalue']] if len(r) > ix['tsvalue'] else ''
                out[a][t][y] = float(v) if v not in ('', None) else None
            else:
                out[a][t][y] = None
    return out


def choose_ids(ts):
    tb = next((t for t in TB_IDS if t in ts), None)
    c = next((t for t, _ in C_IDS if t in ts), None)
    return tb, c


def longest_run(years):
    best, cur = [], []
    for y in sorted(years):
        if cur and y == cur[-1] + 1:
            cur.append(y)
        else:
            cur = [y]
        if len(cur) > len(best):
            best = list(cur)
    return best


# ---------------------------------------------------------------- the giving law

def fit_quadratic(xs, ys):
    """Least squares of y = a x + b x^2 (through the origin). None when degenerate."""
    s2 = sum(x * x for x in xs)
    s3 = sum(x ** 3 for x in xs)
    s4 = sum(x ** 4 for x in xs)
    t1 = sum(x * y for x, y in zip(xs, ys))
    t2 = sum(x * x * y for x, y in zip(xs, ys))
    det = s2 * s4 - s3 * s3
    if det <= 1e-12 * max(s2 * s4, 1e-300):
        return None
    a = (t1 * s4 - t2 * s3) / det
    b = (s2 * t2 - s3 * t1) / det
    return a, b


def giving(fit, e):
    a, b = fit
    return a * e + b * e * e


def least_meeting(fit, h):
    """The least e >= 0 with g(e) >= h (h > 0), or None where g never reaches h (beyond giving)."""
    a, b = fit
    if h <= 0:
        return 0.0
    if b < 0:
        if a <= 0:
            return None
        if h > -a * a / (4 * b):
            return None
        d = a * a + 4 * b * h
        return (-a + math.sqrt(max(d, 0.0))) / (2 * b)
    if b == 0:
        return h / a if a > 0 else None
    d = a * a + 4 * b * h
    return (-a + math.sqrt(d)) / (2 * b)


def regime_point(fit, h):
    """Becoming.RegimeMargin.ends_iff_below: the level H + y below which the condition ends."""
    y = least_meeting(fit, h)
    return None if y is None else h + y


# ---------------------------------------------------------------- one stock

def build(tb, c):
    """tb, c: {year: value}. Returns the stock's run or a reason for exclusion."""
    years = [y for y in tb if y in c and tb[y] is not None and c[y] is not None and tb[y] > 0 and c[y] >= 0]
    run = longest_run(years)
    sp_years = [y for y in run[:-1]]
    if len(sp_years) < MIN_SP:
        return None, 'short'
    bad = [y for y in sp_years if tb[y] - c[y] <= 0]
    if len(bad) > MAX_BAD_E * len(sp_years):
        return None, 'catch at or above biomass'
    return {'run': run, 'tb': {y: tb[y] for y in run}, 'c': {y: c[y] for y in run},
            'sp_years': sp_years, 'bad': set(bad)}, None


def prepare(st):
    tb, c, sp_years = st['tb'], st['c'], st['sp_years']
    n_train = int(math.floor(TRAIN * len(sp_years)))
    train = [y for y in sp_years[:n_train] if y not in st['bad']]
    test = [y for y in sp_years[n_train:]]
    scale = max(tb[y] for y in sp_years[:n_train])
    xs = [(tb[y] - c[y]) / scale for y in train]
    ys = [(tb[y + 1] - tb[y] + c[y]) / scale for y in train]
    q = fit_quadratic(xs, ys)
    st.update(train=train, test=test, scale=scale, fit=q)
    return st


def sp(st, y):
    return st['tb'][y + 1] - st['tb'][y] + st['c'][y]


def forecast(st, t0, k, model):
    """TB at t0 + k from TB at t0 with the actual catches. model: 'RM' (giving read off the level by the
    fitted law) or 'FR' (the frozen rest: giving held at its last observed value, SP at t0 - 1)."""
    tb, c, scale = st['tb'], st['c'], st['scale']
    b = tb[t0]
    g0 = sp(st, t0 - 1)
    for j in range(k):
        e = b - c[t0 + j]
        if e <= 0:
            return 0.0
        b = e + (giving(st['fit'], e / scale) * scale if model == 'RM' else g0)
        if b <= 0:
            return 0.0
    return b


# ---------------------------------------------------------------- the rules

def rule_f0(stocks):
    """The level as the state: adding last year's escapement to the giving law (all SP years)."""
    vals, acs = [], []
    for st in stocks:
        tb, c, scale = st['tb'], st['c'], st['scale']
        ys_ = [y for y in st['sp_years'] if y not in st['bad'] and (y - 1) in tb and (y - 1) not in st['bad']]
        n = len(ys_)
        if n < MIN_SP - 2:
            continue
        e = [(tb[y] - c[y]) / scale for y in ys_]
        e1 = [(tb[y - 1] - c[y - 1]) / scale for y in ys_]
        g = [sp(st, y) / scale for y in ys_]
        q = fit_quadratic(e, g)
        if q is None:
            continue
        ra = [gi - giving(q, ei) for gi, ei in zip(g, e)]
        ssa = sum(r * r for r in ra)
        ssb = ols_ss(g, [e, [x * x for x in e], e1, [x * x for x in e1]])
        if ssa <= 0 or ssb is None:
            continue
        rho = (ssa - ssb) / ssa
        vals.append(rho - 2.0 / (n - 2))
        acs.append(lag1(ra))
    if not vals:
        return {'verdict': 'not testable'}
    med = statistics.median(vals)
    return {'stocks': len(vals), 'median_excess_reduction': med,
            'quartiles': quartiles(vals), 'median_residual_lag1_autocorrelation': statistics.median(acs),
            'verdict': 'passed' if med < 0.10 else 'failed'}


def ols_ss(y, cols):
    """Residual sum of squares of y on the columns (no intercept), by the normal equations."""
    p = len(cols)
    m = [[sum(ci * cj for ci, cj in zip(cols[i], cols[j])) for j in range(p)] for i in range(p)]
    v = [sum(ci * yi for ci, yi in zip(cols[i], y)) for i in range(p)]
    sol = solve(m, v)
    if sol is None:
        return None
    return sum((yi - sum(sol[j] * cols[j][k] for j in range(p))) ** 2 for k, yi in enumerate(y))


def solve(m, v):
    n = len(v)
    a = [row[:] + [v[i]] for i, row in enumerate(m)]
    for col in range(n):
        piv = max(range(col, n), key=lambda r: abs(a[r][col]))
        if abs(a[piv][col]) < 1e-14:
            return None
        a[col], a[piv] = a[piv], a[col]
        for r in range(n):
            if r != col:
                f = a[r][col] / a[col][col]
                for k in range(col, n + 1):
                    a[r][k] -= f * a[col][k]
    return [a[i][n] / a[i][i] for i in range(n)]


def lag1(xs):
    m = sum(xs) / len(xs)
    d = [x - m for x in xs]
    den = sum(x * x for x in d)
    return sum(d[i] * d[i + 1] for i in range(len(d) - 1)) / den if den > 0 else 0.0


def quartiles(xs):
    s = sorted(xs)
    return [s[len(s) // 4], s[len(s) // 2], s[(3 * len(s)) // 4]]


def signs(stocks, k):
    """Origins t0 in each stock's test years with t0 + k and t0 - k in the run; RM, FR and momentum calls
    of whether TB rises over k years, and log errors of RM, FR and the persistence forecast TB_t0."""
    calls = {'RM': [0, 0], 'FR': [0, 0], 'MO': [0, 0]}
    errs = {'RM': [], 'FR': [], 'RW': []}
    per_stock = []
    for st in stocks:
        tb = st['tb']
        right = Counter()
        n = 0
        for t0 in st['test']:
            if (t0 + k) not in tb or (t0 - k) not in tb or (t0 - 1) not in tb:
                continue
            if any((t0 + j) in st['bad'] for j in range(k)) or (t0 - 1) in st['bad']:
                continue
            obs = tb[t0 + k] > tb[t0]
            pred = {'RM': forecast(st, t0, k, 'RM'), 'FR': forecast(st, t0, k, 'FR')}
            call = {'RM': pred['RM'] > tb[t0], 'FR': pred['FR'] > tb[t0], 'MO': tb[t0] > tb[t0 - k]}
            for m in calls:
                calls[m][0] += call[m] == obs
                calls[m][1] += 1
                right[m] += call[m] == obs
            f = FLOOR * st['scale']
            for m, p in (('RM', pred['RM']), ('FR', pred['FR']), ('RW', tb[t0])):
                errs[m].append(abs(math.log(max(p, f) / tb[t0 + k])))
            n += 1
        if n:
            per_stock.append({m: right[m] / n for m in calls})
    acc = {m: (calls[m][0] / calls[m][1] if calls[m][1] else None) for m in calls}
    med = {m: (statistics.median(errs[m]) if errs[m] else None) for m in errs}
    return {'origins': calls['RM'][1], 'stocks': len(per_stock), 'accuracy': acc, 'median_abs_log_error': med,
            'stock_mean_accuracy': {m: (statistics.mean(p[m] for p in per_stock) if per_stock else None) for m in calls}}


def rule_f1(stocks):
    r = signs(stocks, 1)
    a = r['accuracy']
    if not r['origins']:
        r['verdict'] = 'not testable'
        return r
    r['verdict'] = 'passed' if (a['RM'] >= 0.60 and a['RM'] > a['FR'] and a['RM'] > a['MO']) else 'failed'
    return r


def rule_f2(stocks):
    r = signs(stocks, 5)
    a, e = r['accuracy'], r['median_abs_log_error']
    if not r['origins']:
        r['verdict'] = 'not testable'
        return r
    r['verdict'] = 'passed' if (a['RM'] > a['FR'] and a['RM'] > a['MO']
                                and e['RM'] < e['FR'] and e['RM'] < e['RW']) else 'failed'
    return r


def rule_f3(stocks):
    """Under a held catch, the regime's point separates fates (ends_iff_below)."""
    below, above = [], []
    for st in stocks:
        tb, c, scale = st['tb'], st['c'], st['scale']
        for t0 in st['test']:
            if (t0 + 3) not in tb or (t0 - 1) not in tb:
                continue
            cs = [c[t0 + j] for j in range(3)]
            m = sum(cs) / 3
            if m <= 0 or max(cs) > HELD * m or m > HELD * min(cs):
                continue
            pt = regime_point(st['fit'], m / scale)
            ep = {'stock': st['stockid'], 'year': t0,
                  'fell': tb[t0 + 3] < tb[t0],
                  'fell_every': tb[t0 + 1] < tb[t0] and tb[t0 + 2] < tb[t0 + 1] and tb[t0 + 3] < tb[t0 + 2],
                  'fr_falls': m > sp(st, t0 - 1)}
            if pt is None:
                ep['beyond_giving'] = True
                below.append(ep)
            elif tb[t0] < pt * scale / SEP:
                ep['beyond_giving'] = False
                below.append(ep)
            elif tb[t0] > SEP * pt * scale:
                ep['held'] = tb[t0 + 3] >= pt * scale
                above.append(ep)
    nb, na = len(below), len(above)
    sb = len({e['stock'] for e in below})
    r = {'below': nb, 'below_stocks': sb, 'above': na,
         'below_fell': (sum(e['fell'] for e in below) / nb) if nb else None,
         'below_fell_every_step': (sum(e['fell_every'] for e in below) / nb) if nb else None,
         'below_beyond_giving': sum(e.get('beyond_giving', False) for e in below),
         'below_fr_called_fall': (sum(e['fr_falls'] for e in below) / nb) if nb else None,
         'above_held': (sum(e['held'] for e in above) / na) if na else None,
         'above_fell': (sum(e['fell'] for e in above) / na) if na else None}
    if nb < 10 or sb < 3 or na < 10:
        r['verdict'] = 'not testable'
    else:
        r['verdict'] = 'passed' if (r['below_fell'] >= 0.8 and r['above_held'] >= 0.9) else 'failed'
    r['below_episodes'] = below
    return r


def report_f4(stocks):
    """Descriptive (not a verdict): giving at equal escapement against the recent exploitation rate."""
    slopes = []
    for st in stocks:
        tb, c, scale = st['tb'], st['c'], st['scale']
        ys_ = [y for y in st['sp_years'] if y not in st['bad'] and all((y - j) in tb for j in (1, 2, 3))]
        if len(ys_) < 15:
            continue
        e = [(tb[y] - c[y]) / scale for y in ys_]
        g = [sp(st, y) / scale for y in ys_]
        q = fit_quadratic(e, g)
        if q is None:
            continue
        res = [gi - giving(q, ei) for gi, ei in zip(g, e)]
        er = [sum(c[y - j] / tb[y - j] for j in (1, 2, 3)) / 3 for y in ys_]
        m = sum(er) / len(er)
        den = sum((x - m) ** 2 for x in er)
        if den <= 0:
            continue
        slopes.append(sum((x - m) * r for x, r in zip(er, res)) / den)
    n = len(slopes)
    neg = sum(s < 0 for s in slopes)
    return {'stocks': n, 'negative_slopes': neg, 'share_negative': neg / n if n else None,
            'sign_test_p_two_sided': binom_two_sided(neg, n) if n else None,
            'note': 'descriptive: a falling productivity with sticky catches raises the exploitation rate too'}


def binom_two_sided(k, n):
    pk = [math.comb(n, i) / 2 ** n for i in range(n + 1)]
    return min(1.0, sum(p for p in pk if p <= pk[k] + 1e-15))


def run_rules(stocks):
    return {'F0': rule_f0(stocks), 'F1': rule_f1(stocks), 'F2': rule_f2(stocks), 'F3': rule_f3(stocks),
            'F4': report_f4(stocks)}


# ---------------------------------------------------------------- commands

def layout(xlsx):
    cat = method_categories(xlsx)
    recent = recent_assessments(xlsx)
    ts = series(xlsx, recent, values=False)
    counts = Counter()
    eligible = defaultdict(list)
    for a, info in recent.items():
        category = cat.get(info['method'], 'not in assessmethod')
        tb, c = choose_ids(ts.get(a, {}))
        if not tb or not c:
            counts[(category, 'no TB or catch in tonnes')] += 1
            continue
        years = set(ts[a][tb]) & set(ts[a][c])
        n_sp = len(longest_run(years)) - 1
        if n_sp < MIN_SP:
            counts[(category, 'short')] += 1
            continue
        counts[(category, 'eligible by presence')] += 1
        eligible[category].append(info['stockid'])
    out = {'recent_assessments': len(recent),
           'by_category': {f'{k[0]} | {k[1]}': v for k, v in sorted(counts.items())},
           'eligible_stockids': {k: sorted(v) for k, v in eligible.items()},
           'scope': 'presence of series and years only; no value was read'}
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, 'layout.json'), 'w') as f:
        json.dump(out, f, indent=1)
    print(json.dumps(out['by_category'], indent=1))


def load(xlsx):
    cat = method_categories(xlsx)
    recent = recent_assessments(xlsx)
    ts = series(xlsx, recent, values=True)
    groups = defaultdict(list)
    excluded = Counter()
    for a, info in recent.items():
        category = cat.get(info['method'], 'not in assessmethod')
        group = 'primary' if category in PRIMARY else 'control' if category in CONTROL else 'other'
        tbid, cid = choose_ids(ts.get(a, {}))
        if not tbid or not cid:
            continue
        tb = {y: (v * TB_IDS[tbid] if v is not None else None) for y, v in ts[a][tbid].items()}
        cm = dict(C_IDS)[cid]
        c = {y: (v * cm if v is not None else None) for y, v in ts[a][cid].items()}
        st, why = build(tb, c)
        if st is None:
            excluded[(group, why)] += 1
            continue
        st.update(stockid=info['stockid'], assessid=a, method=info['method'], category=category,
                  tbid=tbid, cid=cid)
        prepare(st)
        if st['fit'] is None:
            excluded[(group, 'degenerate fit')] += 1
            continue
        groups[group].append(st)
    return groups, excluded


def test(xlsx):
    groups, excluded = load(xlsx)
    out = {'source': 'RAM Legacy Stock Assessment Database v4.66 (Zenodo 14043031), assessment data only',
           'excluded': {f'{k[0]} | {k[1]}': v for k, v in sorted(excluded.items())},
           'stocks': {g: len(v) for g, v in groups.items()}}
    for g in ('primary', 'control', 'other'):
        out[g] = run_rules(groups.get(g, []))
    out['fits'] = {g: [{'stockid': s['stockid'], 'method': s['method'], 'tb': s['tbid'], 'catch': s['cid'],
                        'years': [s['run'][0], s['run'][-1]], 'train_to': s['train'][-1] if s['train'] else None,
                        'a': s['fit'][0], 'b': s['fit'][1], 'scale_t': s['scale']} for s in v]
                   for g, v in groups.items()}
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, 'VERDICTS-mq3.json'), 'w') as f:
        json.dump(out, f, indent=1, default=str)
    summary = {g: {k: out[g][k].get('verdict', 'reported') for k in out[g]} for g in ('primary', 'control', 'other')}
    print(json.dumps({'stocks': out['stocks'], 'verdicts': summary}, indent=1))


# ---------------------------------------------------------------- dry runs (synthetic stocks)

def synthetic(kind, rng, n_years=45):
    """One synthetic stock: K = 1e5 t, Schaefer giving, held catches reset every 3-6 years to a share of the
    biomass (0-0.1 below a quarter of K, 0.02-0.5 above), so a held catch can overshoot as the stock falls.
    kind: 'level' (giving a function of the level, lognormal noise 0.2), 'regimes' (log r a random walk,
    steps 0.15), 'lag' (giving read off the escapement two years before)."""
    K = 1e5
    r = rng.uniform(0.2, 0.8)
    b = rng.uniform(0.3, 0.9) * K
    tb, c = {}, {}
    esc = []
    logr = math.log(r)
    y, until, catch = 1960, 0, 0.0
    for i in range(n_years):
        if i >= until:
            u = rng.uniform(0.0, 0.1) if b < 0.25 * K else rng.uniform(0.02, 0.5)
            catch = u * b
            until = i + rng.randint(3, 6)
        tb[y + i] = b
        c[y + i] = catch
        e = b - catch
        if e <= 0:
            break
        if kind == 'regimes':
            logr += rng.gauss(0, 0.15)
            rr, ee = math.exp(logr), e
        elif kind == 'lag':
            rr, ee = r, (esc[-2] if len(esc) >= 2 else e)
        else:
            rr, ee = r, e
        g = rr * ee * (1 - ee / K) * math.exp(rng.gauss(0, 0.2))
        b = max(e + g, 0.0)
        esc.append(e)
        if b <= 0:
            break
    return tb, c


def dry():
    rng = random.Random(20261020)
    out = {}
    for kind in ('level', 'regimes', 'lag'):
        stocks = []
        for i in range(150):
            tb, c = synthetic(kind, rng)
            st, why = build(tb, c)
            if st is None:
                continue
            st.update(stockid=f'{kind}-{i}', method='synthetic', category='synthetic')
            prepare(st)
            if st['fit'] is not None:
                stocks.append(st)
        res = run_rules(stocks)
        res['F3'].pop('below_episodes', None)
        out[kind] = {'stocks': len(stocks), **res}
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, 'dry-runs.json'), 'w') as f:
        json.dump(out, f, indent=1)
    print(json.dumps({k: {r: v[r].get('verdict', 'reported') if isinstance(v[r], dict) else v[r]
                          for r in v} for k, v in out.items()}, indent=1))


def main(argv):
    if len(argv) < 2:
        raise SystemExit(__doc__)
    cmd = argv[1]
    if cmd == 'layout':
        layout(argv[2])
    elif cmd == 'dry':
        dry()
    elif cmd == 'test':
        test(argv[2])
    else:
        raise SystemExit(__doc__)


if __name__ == '__main__':
    main(sys.argv)
