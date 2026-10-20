"""MQ4: a state of level and recent giving in the field (RAM Legacy Stock Assessment Database v4.66).

  python3 -I mq4.py layout XLSX     presence only: the stocks no analysis has read, the assessment used for each,
                                    methods and years; no value read (results/mq4/layout.json)
  python3 -I mq4.py dev XLSX        the frozen rules on MQ3's stocks, already read in MQ3: the development basis and
                                    the choice of PHI (results/mq4/development.json); reads no value of the new stocks
  python3 -I mq4.py dry             the rules on synthetic stocks (five generators), before any new value
  python3 -I mq4.py test XLSX       the frozen test on the unread stocks: results/mq4/VERDICTS-mq4.json

Standard library only. XLSX is `RAMLDB v4.66 (assessment data only).xlsx` from Zenodo record 14043031
(md5 of the archive ed6d7cd3f7da1fdcbc60015c3d65014b), extracted outside the repository.

MQ3 read Becoming.RegimeMargin.step in a fishery (catch C_t the draw, escapement E_t = TB_t - C_t what is left,
surplus production SP_t = TB_{t+1} - E_t the giving) and found giving persisting beyond what the level gives.
MQ4 tests a state of two variables, the level and the giving just observed: giving relaxes toward the level's
giving law g at a common rate,

    SP_t = PHI * SP_{t-1} + (1 - PHI) * g(E_t),

so PHI = 1 is the frozen rest (Flow.WithheldLevels: giving held as it was) and PHI = 0 the regime margin (giving
read off what is left). PHI is chosen once on MQ3's stocks and frozen here; g is fitted on each stock's earlier
years as in MQ3. The test stocks are those MQ3 never read: current stocks whose most recent assessment lacks TB
or catch in tonnes, read from an earlier assessment of the same stock that has both.
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
import ram_read  # noqa: E402

OUT = os.path.join(HERE, 'results', 'mq4')

# Frozen choices (PREDICTIONS-2026-10-20-MQ4.md).
PHI = 0.96                 # chosen on MQ3's stocks by `dev` (least pooled median |log error| at five years)
PHI_GRID = [i / 100 for i in range(80, 100)]
NEEDED = 0.10              # recent giving is needed, or nothing more is, by this share of residual variance beyond chance
DETECT = 0.20              # the level is needed where its F test (p < 0.05) fires in this share of stocks (null: 0.05)
HORIZONS = (1, 5, 10)
HALF = 0.5                 # a break: the level falls below this share of its value at the origin
WITHIN = 10                # years over which a break is looked for
CLASSES = [(0, 5), (5, 10), (10, 20), (20, math.inf)]   # frozen-rest time to break, in years (D > 0)
MIN_ORIGINS, MIN_STOCKS = 100, 10                     # an F rule is testable with this many origins and stocks
MIN_CLASS, MIN_CLASS_STOCKS = 20, 5                   # a T class is testable with this many origins and stocks


# ---------------------------------------------------------------- reading (presence and values)

def stock_states(xlsx):
    it = ram_read.rows(xlsx, 'stock')
    h = next(it)
    ix = {k: i for i, k in enumerate(h)}
    out = {}
    for r in it:
        r = r + [''] * (len(h) - len(r))
        out[r[ix['stockid']]] = r[ix['state']]
    return out


def assessments(xlsx):
    it = ram_read.rows(xlsx, 'assessment')
    h = next(it)
    ix = {k: i for i, k in enumerate(h)}
    out = {}
    for r in it:
        r = r + [''] * (len(h) - len(r))
        yr = r[ix['assessyear']]
        try:
            end = int(yr.split('-')[-1])
        except ValueError:
            end = -1
        out[r[ix['assessid']]] = {'stockid': r[ix['stockid']], 'method': r[ix['assessmethod']],
                                  'mostrecent': r[ix['mostrecent']], 'end': end}
    return out


def series_of(xlsx, assessids, values):
    """{assessid: {tsid: {year: value or None}}} for the TB and catch ids of the given assessments.
    With values=False the value cell is never kept (presence only)."""
    want = set(mq3.TB_IDS) | {c for c, _ in mq3.C_IDS}
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
            if t not in want:
                continue
            y = int(float(r[ix['tsyear']]))
            if values:
                v = r[ix['tsvalue']] if len(r) > ix['tsvalue'] else ''
                out[a][t][y] = float(v) if v not in ('', None) else None
            else:
                out[a][t][y] = None
    return out


def selection(xlsx):
    """Presence only. MQ3's assessments (most recent, with TB and catch in tonnes) and, for every current stock
    not among them, the latest earlier assessment with both (ties: the longer run, then the assessid)."""
    states = stock_states(xlsx)
    A = assessments(xlsx)
    ts = series_of(xlsx, set(A), values=False)
    both = {a for a in A if all(mq3.choose_ids(ts.get(a, {})))}
    mq3_assess = {a for a in both if A[a]['mostrecent'] == '999'}
    mq3_stocks = {A[a]['stockid'] for a in mq3_assess}
    recent_any = {}   # stocks whose most recent assessment has a TB or a catch series in tonnes (parsed by mq3.load)
    for a, info in A.items():
        if info['mostrecent'] == '999':
            tb, c = mq3.choose_ids(ts.get(a, {}))
            recent_any[info['stockid']] = recent_any.get(info['stockid'], False) or bool(tb or c)
    cand = defaultdict(list)
    skipped = Counter()
    for a in both:
        s = A[a]['stockid']
        if A[a]['mostrecent'] == '999' or s in mq3_stocks:
            continue
        if states.get(s) != 'Current':
            skipped['deprecated stock'] += 1
            continue
        tb, c = mq3.choose_ids(ts[a])
        n_run = len(mq3.longest_run(set(ts[a][tb]) & set(ts[a][c])))
        cand[s].append((A[a]['end'], n_run, a))
    chosen = {}
    for s, lst in cand.items():
        lst.sort(key=lambda x: (-x[0], -x[1], x[2]))
        chosen[s] = lst[0][2]
    return {'A': A, 'presence': ts, 'mq3_assess': mq3_assess, 'chosen': chosen, 'skipped': skipped,
            'recent_any': recent_any}


def group_of(cat, method):
    category = cat.get(method, 'not in assessmethod')
    g = 'primary' if category in mq3.PRIMARY else 'control' if category in mq3.CONTROL else 'other'
    return g, category


def load_from(xlsx, chosen_assess, A):
    """Values for the given assessments, built and fitted as in MQ3."""
    cat = mq3.method_categories(xlsx)
    ts = series_of(xlsx, set(chosen_assess), values=True)
    groups = defaultdict(list)
    excluded = Counter()
    for a in sorted(chosen_assess):
        info = A[a]
        group, category = group_of(cat, info['method'])
        tbid, cid = mq3.choose_ids(ts.get(a, {}))
        if not tbid or not cid:
            excluded[(group, 'no TB or catch')] += 1
            continue
        tb = {y: (v * mq3.TB_IDS[tbid] if v is not None else None) for y, v in ts[a][tbid].items()}
        cm = dict(mq3.C_IDS)[cid]
        c = {y: (v * cm if v is not None else None) for y, v in ts[a][cid].items()}
        st, why = mq3.build(tb, c)
        if st is None:
            excluded[(group, why)] += 1
            continue
        st.update(stockid=info['stockid'], assessid=a, method=info['method'], category=category, tbid=tbid, cid=cid)
        mq3.prepare(st)
        if st['fit'] is None:
            excluded[(group, 'degenerate fit')] += 1
            continue
        groups[group].append(st)
    return groups, excluded


# ---------------------------------------------------------------- the state's step and the forecasts

def E(st, y):
    return st['tb'][y] - st['c'][y]


def g_t(st, e):
    """The level's giving law in tonnes."""
    return mq3.giving(st['fit'], e / st['scale']) * st['scale']


def project(st, t0, k, model, phi=PHI, held=None):
    """TB at t0 + k from TB at t0 and SP at t0 - 1, with the actual catches (or a held catch).
    FR: giving held at SP_{t0-1}. RM: giving read off what is left, g(E). LG: the state of level and recent
    giving, SP_t = phi SP_{t-1} + (1 - phi) g(E_t). Stops at zero once the catch takes everything."""
    tb, c = st['tb'], st['c']
    b = tb[t0]
    s_prev = mq3.sp(st, t0 - 1)
    for j in range(k):
        cj = held if held is not None else c[t0 + j]
        e = b - cj
        if e <= 0:
            return 0.0
        if model == 'FR':
            s = s_prev
        elif model == 'RM':
            s = g_t(st, e)
        elif model == 'LG':
            s = phi * s_prev + (1 - phi) * g_t(st, e)
        else:
            raise ValueError(model)
        s_prev = s
        b = e + s
        if b <= 0:
            return 0.0
    return b


def path(st, t0, n, model, held, phi=PHI):
    """Levels at t0 + 1 .. t0 + n under a held catch."""
    out = []
    for k in range(1, n + 1):
        out.append(project(st, t0, k, model, phi, held))
    return out


def origins(st, k):
    """Test years t0 with t0 - k, t0 - 1 and t0 + k in the run and no year from t0 - 1 to t0 + k - 1 with
    catch at or above biomass (MQ3's origins)."""
    tb = st['tb']
    for t0 in st['test']:
        if (t0 + k) not in tb or (t0 - k) not in tb or (t0 - 1) not in tb:
            continue
        if any((t0 + j) in st['bad'] for j in range(k)) or (t0 - 1) in st['bad']:
            continue
        yield t0


# ---------------------------------------------------------------- the rules

def excess(y, base, added):
    """Share of residual sum of squares removed by adding columns, less the chance level q / (n - p)."""
    a = mq3.ols_ss(y, base)
    b = mq3.ols_ss(y, base + added)
    if a is None or b is None or a <= 0:
        return None
    n, p, q = len(y), len(base), len(added)
    return (a - b) / a - q / (n - p)


def f2_p(a, b, m):
    """Survival function of F(2, m) at the statistic for adding two columns: (1 + 2F/m)^(-m/2)."""
    if b <= 0 or m <= 0:
        return None
    f = ((a - b) / 2) / (b / m)
    return (1 + 2 * max(f, 0.0) / m) ** (-m / 2)


def binom_upper(k, n, p):
    """P(X >= k) for X ~ Binomial(n, p)."""
    return min(1.0, sum(math.comb(n, i) * p ** i * (1 - p) ** (n - i) for i in range(k, n + 1)))


def rule_g(stocks):
    """The state, in sample, over all SP years of each stock (scaled units).
    G1 recent giving needed: adding SP_{t-1} to the level law (E, E^2) removes a median >= NEEDED beyond chance.
    G2 the level needed: adding E, E^2 to recent giving and a constant (SP_{t-1}, 1) is detected (F test p < 0.05)
       in at least DETECT of the stocks, and in more than chance allows (binomial against 0.05, p < 0.001).
    G3 nothing more needed: adding SP_{t-2}, E_{t-1}, E_{t-1}^2 to (E, E^2, SP_{t-1}) removes a median < NEEDED
       beyond chance."""
    vals = {'G1': [], 'G2': [], 'G3': []}
    g2p = []
    for st in stocks:
        tb, c, sc = st['tb'], st['c'], st['scale']
        ys = [y for y in st['sp_years']
              if all((y - j) in tb and (y - j) not in st['bad'] for j in (0, 1, 2))]
        if len(ys) < 20:
            continue
        e = [E(st, y) / sc for y in ys]
        e2 = [x * x for x in e]
        e1 = [E(st, y - 1) / sc for y in ys]
        e12 = [x * x for x in e1]
        s = [mq3.sp(st, y) / sc for y in ys]
        s1 = [mq3.sp(st, y - 1) / sc for y in ys]
        s2 = [mq3.sp(st, y - 2) / sc for y in ys]
        one = [1.0] * len(ys)
        r = {'G1': excess(s, [e, e2], [s1]),
             'G2': excess(s, [s1, one], [e, e2]),
             'G3': excess(s, [e, e2, s1], [s2, e1, e12])}
        a2, b2 = mq3.ols_ss(s, [s1, one]), mq3.ols_ss(s, [s1, one, e, e2])
        p2 = f2_p(a2, b2, len(ys) - 4) if a2 is not None and b2 is not None else None
        if any(v is None for v in r.values()) or p2 is None:
            continue
        for k, v in r.items():
            vals[k].append(v)
        g2p.append(p2)
    n = len(vals['G1'])
    if n == 0:
        return {k: {'verdict': 'not testable'} for k in vals}
    out = {}
    for k, v in vals.items():
        out[k] = {'stocks': n, 'median_excess_reduction': statistics.median(v), 'quartiles': mq3.quartiles(v),
                  'share_above_bound': sum(x >= NEEDED for x in v) / n}
    out['G1']['verdict'] = 'passed' if out['G1']['median_excess_reduction'] >= NEEDED else 'failed'
    out['G3']['verdict'] = 'passed' if out['G3']['median_excess_reduction'] < NEEDED else 'failed'
    k2 = sum(p < 0.05 for p in g2p)
    out['G2'].update(detected=k2, share_detected=k2 / n, binomial_p=binom_upper(k2, n, 0.05))
    out['G2']['verdict'] = 'passed' if (k2 / n >= DETECT and out['G2']['binomial_p'] < 0.001) else 'failed'
    return out


def forecast_scores(stocks, k, phi=PHI):
    """Pooled direction calls (LG, FR, RM, momentum MO) and |log errors| (LG, FR, RM, persistence RW) over k years,
    and per-stock mean |log errors| for the sign tests."""
    calls = {m: [0, 0] for m in ('LG', 'FR', 'RM', 'MO')}
    errs = {m: [] for m in ('LG', 'FR', 'RM', 'RW')}
    per_stock = []
    for st in stocks:
        tb = st['tb']
        f = mq3.FLOOR * st['scale']
        le = {m: [] for m in errs}
        for t0 in origins(st, k):
            obs = tb[t0 + k] > tb[t0]
            p = {m: project(st, t0, k, m, phi) for m in ('LG', 'FR', 'RM')}
            call = {'LG': p['LG'] > tb[t0], 'FR': p['FR'] > tb[t0], 'RM': p['RM'] > tb[t0], 'MO': tb[t0] > tb[t0 - k]}
            for m in calls:
                calls[m][0] += call[m] == obs
                calls[m][1] += 1
            for m, v in (('LG', p['LG']), ('FR', p['FR']), ('RM', p['RM']), ('RW', tb[t0])):
                x = abs(math.log(max(v, f) / tb[t0 + k]))
                errs[m].append(x)
                le[m].append(x)
        if le['LG']:
            per_stock.append({m: sum(v) / len(v) for m, v in le.items()})
    n = calls['LG'][1]
    acc = {m: (calls[m][0] / calls[m][1] if calls[m][1] else None) for m in calls}
    med = {m: (statistics.median(v) if v else None) for m, v in errs.items()}

    def sign(a, b):
        w = sum(p[a] < p[b] for p in per_stock)
        lo = sum(p[a] > p[b] for p in per_stock)
        return {'better': w, 'worse': lo, 'p_two_sided': mq3.binom_two_sided(w, w + lo) if w + lo else None}

    return {'origins': n, 'stocks': len(per_stock), 'accuracy': acc, 'median_abs_log_error': med,
            'sign_LG_vs_FR': sign('LG', 'FR'), 'sign_LG_vs_RM': sign('LG', 'RM'), 'sign_FR_vs_RM': sign('FR', 'RM')}


def rule_f(stocks, k, phi=PHI):
    """Fa (k > 1; at one year reported only): LG calls the direction over k years better than FR, RM and momentum.
    Fb: LG's median |log error| is below FR's, RM's and persistence's, and LG's mean |log error| is below FR's in
    more stocks than not, with a two-sided sign test p < 0.05."""
    r = forecast_scores(stocks, k, phi)
    if r['origins'] < MIN_ORIGINS or r['stocks'] < MIN_STOCKS:
        r['verdict_a'] = r['verdict_b'] = 'not testable'
        return r
    a, e, s = r['accuracy'], r['median_abs_log_error'], r['sign_LG_vs_FR']
    if k == 1:
        r['verdict_a'] = 'reported'   # the dry runs: one year's direction misses the state even where it holds
    else:
        r['verdict_a'] = 'passed' if (a['LG'] > a['FR'] and a['LG'] > a['RM'] and a['LG'] > a['MO']) else 'failed'
    r['verdict_b'] = 'passed' if (e['LG'] < e['FR'] and e['LG'] < e['RM'] and e['LG'] < e['RW']
                                  and s['better'] > s['worse'] and s['p_two_sided'] is not None
                                  and s['p_two_sided'] < 0.05) else 'failed'
    return r


def break_within(st, t0):
    """Observed: the first n <= WITHIN with TB_{t0+n} < HALF * TB_{t0}; None if none and the run reaches t0 + WITHIN;
    'censored' if the run ends earlier without a break."""
    tb = st['tb']
    for n in range(1, WITHIN + 1):
        if (t0 + n) not in tb:
            return 'censored'
        if tb[t0 + n] < HALF * tb[t0]:
            return n
    return None


def rule_t(stocks, phi=PHI):
    """The frozen-rest margin's time to break, the margin law read as a forecast: every exchange held as it is at the
    origin (the catch C_{t0}, the giving SP_{t0-1}), the level falls by the net draw D = C_{t0} - SP_{t0-1} a year,
    and the margin above the break, (1 - HALF) TB_{t0}, is spent in n = (1 - HALF) TB_{t0} / D years.
    T1: for D > 0, the share breaking within WITHIN years falls strictly across the classes of n.
    T2: at least half of the origins with n <= 5 break within WITHIN years.
    Reported: D <= 0; the same call (a break within WITHIN years under the held catch) by LG and RM."""
    cls = defaultdict(lambda: [0, 0, set()])     # class -> [origins, breaks, stocks]
    held_calls = {m: [0, 0] for m in ('FR', 'LG', 'RM')}
    held_by_truth = {m: Counter() for m in ('FR', 'LG', 'RM')}
    for st in stocks:
        tb, c = st['tb'], st['c']
        for t0 in st['test']:
            if (t0 - 1) not in tb or (t0 - 1) in st['bad'] or t0 in st['bad']:
                continue
            obs = break_within(st, t0)
            if obs == 'censored':
                continue
            broke = obs is not None
            d = c[t0] - mq3.sp(st, t0 - 1)
            if d > 0:
                n = (1 - HALF) * tb[t0] / d
                key = next(f'{lo}-{hi}' for lo, hi in CLASSES if lo < n <= hi)
            else:
                n = math.inf
                key = 'D<=0'
            cls[key][0] += 1
            cls[key][1] += broke
            cls[key][2].add(st['stockid'])
            for m in held_calls:
                levels = path(st, t0, WITHIN, m, held=c[t0], phi=phi)
                call = any(x < HALF * tb[t0] for x in levels)
                held_calls[m][0] += call == broke
                held_calls[m][1] += 1
                held_by_truth[m][(call, broke)] += 1
    table = {k: {'origins': v[0], 'breaks': v[1], 'share': v[1] / v[0] if v[0] else None, 'stocks': len(v[2])}
             for k, v in cls.items()}
    keys = [f'{lo}-{hi}' for lo, hi in CLASSES]
    testable = all(table.get(k, {}).get('origins', 0) >= MIN_CLASS and table[k]['stocks'] >= MIN_CLASS_STOCKS
                   for k in keys)
    shares = [table[k]['share'] if k in table else None for k in keys]
    out = {'classes': table, 'order': keys,
           'held_catch_call_accuracy': {m: (v[0] / v[1] if v[1] else None) for m, v in held_calls.items()},
           'held_catch_confusion': {m: {f'call={a},broke={b}': n for (a, b), n in v.items()}
                                    for m, v in held_by_truth.items()}}
    if not testable:
        out['verdict_T1'] = out['verdict_T2'] = 'not testable'
        return out
    out['verdict_T1'] = 'passed' if all(shares[i] > shares[i + 1] for i in range(len(shares) - 1)) else 'failed'
    out['verdict_T2'] = 'passed' if shares[0] >= 0.5 else 'failed'
    return out


def rule_r(stocks, f1, f5):
    """R1, MQ3's finding on new stocks: the frozen rest calls the direction better than the regime margin and has the
    smaller median |log error|, at one and at five years. R2, MQ3's F4 on new stocks: giving at equal escapement rises
    with the recent exploitation rate in more stocks than not, with a two-sided sign test p < 0.05."""
    r1 = {}
    ok = True
    for k, r in ((1, f1), (5, f5)):
        a, e = r['accuracy'], r['median_abs_log_error']
        if r['origins'] < MIN_ORIGINS:
            ok = None
            break
        r1[f'k{k}'] = {'FR_accuracy': a['FR'], 'RM_accuracy': a['RM'], 'FR_error': e['FR'], 'RM_error': e['RM']}
        ok = ok and a['FR'] > a['RM'] and e['FR'] < e['RM']
    r1['verdict'] = 'not testable' if ok is None else ('passed' if ok else 'failed')
    f4 = mq3.report_f4(stocks)
    n = f4['stocks']
    pos = n - f4['negative_slopes'] if n else 0
    r2 = {'stocks': n, 'positive_slopes': pos,
          'p_two_sided': mq3.binom_two_sided(pos, n) if n else None}
    if n < MIN_STOCKS:
        r2['verdict'] = 'not testable'
    else:
        r2['verdict'] = 'passed' if (pos > n - pos and r2['p_two_sided'] < 0.05) else 'failed'
    return {'R1': r1, 'R2': r2}


def run_rules(stocks, phi=PHI):
    out = {'G': rule_g(stocks)}
    for k in HORIZONS:
        out[f'F{k}'] = rule_f(stocks, k, phi)
    out['T'] = rule_t(stocks, phi)
    out.update(rule_r(stocks, out['F1'], out['F5']))
    return out


def verdict_summary(res):
    s = {k: v['verdict'] for k, v in res['G'].items()}
    for k in HORIZONS:
        s[f'F{k}a'] = res[f'F{k}']['verdict_a']
        s[f'F{k}b'] = res[f'F{k}']['verdict_b']
    s['T1'] = res['T']['verdict_T1']
    s['T2'] = res['T']['verdict_T2']
    s['R1'] = res['R1']['verdict']
    s['R2'] = res['R2']['verdict']
    return s


# ---------------------------------------------------------------- commands

def layout(xlsx):
    sel = selection(xlsx)
    A, ts, chosen = sel['A'], sel['presence'], sel['chosen']
    cat = mq3.method_categories(xlsx)
    counts = Counter()
    eligible = defaultdict(list)
    parsed_before = 0
    for s, a in sorted(chosen.items()):
        group, category = group_of(cat, A[a]['method'])
        tb, c = mq3.choose_ids(ts[a])
        n_sp = len(mq3.longest_run(set(ts[a][tb]) & set(ts[a][c]))) - 1
        if n_sp < mq3.MIN_SP:
            counts[(group, 'short')] += 1
            continue
        counts[(group, 'eligible by presence')] += 1
        eligible[group].append({'stockid': s, 'assessid': a, 'method': A[a]['method'], 'category': category,
                                'tb': tb, 'catch': c, 'sp_years_present': n_sp})
        parsed_before += bool(sel['recent_any'].get(s))
    out = {'mq3_assessments': len(sel['mq3_assess']),
           'new_current_stocks_with_an_earlier_assessment': len(chosen),
           'skipped': dict(sel['skipped']),
           'by_group': {f'{k[0]} | {k[1]}': v for k, v in sorted(counts.items())},
           'eligible_with_recent_series_parsed_by_mq3_load': parsed_before,
           'eligible': {k: v for k, v in sorted(eligible.items())},
           'scope': 'presence of series and years only; no value was read'}
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, 'layout.json'), 'w') as f:
        json.dump(out, f, indent=1)
    print(json.dumps({k: out[k] for k in out if k != 'eligible'}, indent=1))


def load_mq3(xlsx):
    """MQ3's stocks only (most recent assessments with TB and catch in tonnes), built exactly as mq3.load does."""
    recent = mq3.recent_assessments(xlsx)
    A = assessments(xlsx)
    pres = series_of(xlsx, set(recent), values=False)
    keep = {a for a in recent if all(mq3.choose_ids(pres.get(a, {})))}
    return load_from(xlsx, keep, A)


def dev(xlsx):
    groups, excluded = load_mq3(xlsx)
    allst = [st for g in ('primary', 'control', 'other') for st in groups.get(g, [])]
    scan = []
    for phi in PHI_GRID:
        r = forecast_scores(allst, 5, phi)
        scan.append({'phi': phi, 'origins': r['origins'], 'accuracy_LG': r['accuracy']['LG'],
                     'median_abs_log_error_LG': r['median_abs_log_error']['LG']})
    best = min(scan, key=lambda x: x['median_abs_log_error_LG'])
    out = {'scope': 'development: MQ3 stocks, already read in MQ3; not a test',
           'stocks': {g: len(v) for g, v in groups.items()},
           'excluded': {f'{k[0]} | {k[1]}': v for k, v in sorted(excluded.items())},
           'phi_scan_k5_all_groups': scan, 'phi_chosen': best['phi'], 'phi_frozen': PHI}
    for g in ('primary', 'control', 'other'):
        res = run_rules(groups.get(g, []), PHI)
        out[g] = res
        out[g + '_verdicts'] = verdict_summary(res)
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, 'development.json'), 'w') as f:
        json.dump(out, f, indent=1, default=str)
    print(json.dumps({'phi_chosen': best['phi'], 'phi_frozen': PHI, 'stocks': out['stocks'],
                      **{g: out[g + '_verdicts'] for g in ('primary', 'control', 'other')}}, indent=1))
    if abs(best['phi'] - PHI) > 1e-9:
        raise SystemExit('the frozen PHI is not the one development chooses')


def test(xlsx):
    sel = selection(xlsx)
    A = sel['A']
    groups, excluded = load_from(xlsx, set(sel['chosen'].values()), A)
    out = {'source': 'RAM Legacy Stock Assessment Database v4.66 (Zenodo 14043031), assessment data only',
           'phi': PHI,
           'excluded': {f'{k[0]} | {k[1]}': v for k, v in sorted(excluded.items())},
           'stocks': {g: len(v) for g, v in groups.items()}}
    for g in ('primary', 'control', 'other'):
        res = run_rules(groups.get(g, []))
        out[g] = res
        out[g + '_verdicts'] = verdict_summary(res)
        out[g + '_mq3_rules'] = {k: v.get('verdict', 'reported') for k, v in mq3.run_rules(groups.get(g, [])).items()}
    out['fits'] = {g: [{'stockid': s['stockid'], 'assessid': s['assessid'], 'method': s['method'], 'tb': s['tbid'],
                        'catch': s['cid'], 'years': [s['run'][0], s['run'][-1]],
                        'train_to': s['train'][-1] if s['train'] else None,
                        'a': s['fit'][0], 'b': s['fit'][1], 'scale_t': s['scale']} for s in v]
                   for g, v in groups.items()}
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, 'VERDICTS-mq4.json'), 'w') as f:
        json.dump(out, f, indent=1, default=str)
    print(json.dumps({'stocks': out['stocks'],
                      'verdicts': {g: out[g + '_verdicts'] for g in ('primary', 'control', 'other')},
                      'mq3_rules': {g: out[g + '_mq3_rules'] for g in ('primary', 'control', 'other')}}, indent=1))


# ---------------------------------------------------------------- dry runs (synthetic stocks)

def synthetic(kind, rng, n_years=60):
    """One synthetic stock: K = 1e5 t, Schaefer giving r E (1 - E / K), held catches reset every 3-6 years to a share
    of the biomass (0-0.1 below a quarter of K, 0.02-0.5 above), as in MQ3's dry runs, over 60 years.
    kind: 'level' (giving a function of the level, lognormal noise 0.2); 'regimes' (log r a random walk, steps 0.15);
    'lag' (giving read off the escapement two years before); 'relaxing' (the state of level and recent giving:
    SP_t = 0.9 SP_{t-1} + 0.1 g(E_t), times lognormal noise 0.1); 'drifting' (giving a random walk of its own, steps of
    0.05 r K / 4, not read off the level, kept within [-0.1, 0.4] r K)."""
    K = 1e5
    r = rng.uniform(0.2, 0.8)
    b = rng.uniform(0.3, 0.9) * K
    tb, c = {}, {}
    esc = []
    logr = math.log(r)
    y, until, catch = 1950, 0, 0.0
    s_prev = None
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
        level_g = r * e * (1 - e / K)
        if kind == 'regimes':
            logr += rng.gauss(0, 0.15)
            g = math.exp(logr) * e * (1 - e / K) * math.exp(rng.gauss(0, 0.2))
        elif kind == 'lag':
            ee = esc[-2] if len(esc) >= 2 else e
            g = r * ee * (1 - ee / K) * math.exp(rng.gauss(0, 0.2))
        elif kind == 'relaxing':
            base = level_g if s_prev is None else 0.9 * s_prev + 0.1 * level_g
            g = base * math.exp(rng.gauss(0, 0.1))
        elif kind == 'drifting':
            g0 = 0.25 * r * K if s_prev is None else s_prev
            g = min(max(g0 + rng.gauss(0, 0.05 * r * K / 4), -0.1 * r * K), 0.4 * r * K)
        else:
            g = level_g * math.exp(rng.gauss(0, 0.2))
        s_prev = g
        b = max(e + g, 0.0)
        esc.append(e)
        if b <= 0:
            break
    return tb, c


def dry():
    rng = random.Random(20261021)
    out = {}
    for kind in ('level', 'regimes', 'lag', 'relaxing', 'drifting'):
        stocks = []
        for i in range(150):
            tb, c = synthetic(kind, rng)
            st, why = mq3.build(tb, c)
            if st is None:
                continue
            st.update(stockid=f'{kind}-{i}', method='synthetic', category='synthetic')
            mq3.prepare(st)
            if st['fit'] is not None:
                stocks.append(st)
        res = run_rules(stocks)
        out[kind] = {'stocks': len(stocks), 'verdicts': verdict_summary(res), **res}
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
