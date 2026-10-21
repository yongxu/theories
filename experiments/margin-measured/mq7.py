"""MQ7: fates on either side of the curve in the plane of level and recent giving, in the field.

  python3 -I mq7.py dev XLSX                 the frozen rules on the RAM Legacy stocks MQ3-MQ5 read (development, not a
                                             test): results/mq7/development.json
  python3 -I mq7.py dry                      the rules on synthetic stocks (results/mq7/dry-runs.json)
  python3 -I mq7.py layout SMART SAG         presence only: the test stocks no analysis has read, as match_mq7.py decided
                                             them (results/mq7/layout.json)
  python3 -I mq7.py test SMART SAG           the frozen test: results/mq7/VERDICTS-mq7.json

Standard library only. XLSX is `RAMLDB v4.66 (assessment data only).xlsx` (Zenodo record 14043031, md5 of the archive
ed6d7cd3f7da1fdcbc60015c3d65014b); SMART is the directory holding NOAA Stock SMART's `stock_assessment_data.rda` and
`stock_assessment_summary.rda` (github.com/NOAA-EDAB/stocksmart); SAG is the directory of ICES Stock Assessment Graphs
JSON files (sag.ices.dk SAG_API). Each is kept outside the repository.

The theorem (Becoming.RegimeMargin): where giving adjusts to what is left e and to the recent giving r by a law A(e, r)
rising in both, within a band, the runs that come to rest below the draw are exactly those from levels below a least
level for each recent giving (`Adjusted.falls_iff_below`), and that level does not rise as the recent giving rises
(`Adjusted.threshold_falls`); below the regime's point, recent giving above the draw can carry a condition across it
(`Crossing.crosses`). Under the regime's step (giving read off the level alone) the point is H + y at every recent
giving (`threshold_regime`), so recent giving changes no fate.

The field reading (MQ3's, with MQ5's readings and MQ5's post hoc findings, PREDICTIONS-2026-10-21-MQ7.md):
  episode   a test origin t0 whose catches over t0 .. t0 + K - 1 are held, each within HELD of their mean C;
            the draw on the level is H = kappa C
  state     the level x_t0 and the recent giving r = SP_{t0-1} = x_t0 - x_{t0-1} + kappa C_{t0-1}
  point     the regime's point TB*(H) = H + y(H), y(H) the least escapement whose fitted giving g meets H (MQ3); the
            episode is below it where x_t0 < TB*(H) / SEP or where g never meets H (beyond giving)
  low side  the escapement at the origin below g's peak, where the field's adjustment rises in both arguments
            (MQ5 post hoc, study section 280)
  deficit   z = g(E_t0) / H, what the level law gives at the origin against the draw: the regime's step's own measure
            of how far below the point the episode lies
  short     r < H (the recent giving falls short of the draw); meets: r >= H
  fate      falls: x_{t0+K} < x_t0
Episodes are compared within a stock and a bin of the deficit, so that the level and the stock's own (mis)measured
level law are the same on both sides of the comparison. Each series' timing is read before the balance is read off
it: the level as reported is the level after a share f of the year's draw, x_t = L_t + f kappa C_t, with f in TIMINGS
chosen where the balance fits best (`read_stock`).
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
import mq5  # noqa: E402

OUT = os.path.join(HERE, 'results', 'mq7')

# ---------------------------------------------------------------- frozen choices (PREDICTIONS-2026-10-21-MQ7.md)

K = 3                       # the episode's horizon in years (MQ3's F3)
K_REPORTED = 5              # a longer horizon, reported
HELD = mq3.HELD             # a held catch: each year within this factor of the episode's mean
SEP = mq3.SEP               # below the regime's point by this factor (MQ3's F3)
TIMINGS = (0.0, 0.5, 1.0)   # the share of the year's draw taken before the level is reported
Z_BIN = 0.2                 # width of the deficit's bins, g(E_t0) / H in [0, 1); below 0 one bin
STRATA_U = (0.5, 1 / SEP)   # reported pooled strata of x_t0 / TB*(H): beyond giving, under 0.5, 0.5 to 1 / SEP
BOOT = 2000                 # stock-level bootstrap resamples
SEED = 20261021
MIN_EPISODES = 10           # each compared class: at least this many episodes ...
MIN_CLASS_STOCKS = 3        # ... from at least this many stocks
MIN_STOCKS = 5              # stocks with any compared episode
# the reading the verdicts are on: every unread primary test stock carries spawning biomass and none total biomass
# (layout), and in the SSB reading the regime's step passes C1 unless the draw's share and the timing are fitted by
# MQ4's state (M2) rather than MQ5's state with the lag (M3) (design checks, dev_mq7.py ssb)
VERDICT_READING = 'SSB'
# how each reading is read: the timing grid and the model the draw's share and the timing are profiled by
READINGS = {'TB': {'timings': TIMINGS, 'model': 'M3'}, 'SSB': {'timings': TIMINGS, 'model': 'M2'},
            'survey': {'timings': TIMINGS, 'model': 'M3'}}


# ---------------------------------------------------------------- one stock: timing, the draw's share, the level law

PROFILE_MODELS = {'M1': 2, 'M2': 3, 'M3': 5}   # the level law; with recent giving; with the lag (columns used)


def read_stock(L, C, reading, timings=TIMINGS, model='M3'):
    """L, C: {year: value}, the level as reported and the catch. Returns the stock read as MQ5 reads it, with its
    timing, or a reason for excluding it.

    The timing: a level reported after a share f of the year's draw kappa C_t is x_t = L_t + f kappa C_t before it. Then
    what the draw leaves is L_t - (1 - f) kappa C_t, and the giving is L_{t+1} - L_t + kappa (C_t + f (C_{t+1} - C_t)):
    read at the wrong timing, the giving carries a term in the next year's change of catch that no state at t gives.
    f and the draw's share kappa (1 in the TB reading, MQ5's grid in the SSB reading) are profiled jointly on the
    training years by the least residual of a state's giving law: MQ4's state (model M2: giving at t on E_t, E_t^2,
    SP_{t-1}) in the SSB reading, MQ5's state with the lag (M3: with E_{t-1}, E_{t-1}^2 as well) in the TB reading
    (READINGS); ties go to the smaller f, then the smaller kappa. A pair is admissible only where every escapement over
    those years is positive. MQ5 fitted kappa with M3; under the regime's step that fit lets C1 pass in the SSB reading
    (dev_mq7.py), and M1 (the level law) is used only in the design checks."""
    st, why = mq5.build(L, C)
    if st is None:
        return None, why
    sp = st['sp_years']
    train = sp[:int(math.floor(mq3.TRAIN * len(sp)))]
    ys = [y for y in train if (y - 2) in st['b']]
    need = set(ys) | {y - 1 for y in ys} | {y - 2 for y in ys}
    sc = max(st['b'][y] for y in train)
    Lr, Cr = st['b'], st['c']
    best = None
    for f in timings:
        for kap in ([1.0] if reading == 'TB' else mq5.KAPPA_GRID):
            def esc(y):
                return (Lr[y] - (1 - f) * kap * Cr[y]) / sc

            def giv(y):
                return (Lr[y + 1] - Lr[y] + kap * (Cr[y] + f * (Cr[y + 1] - Cr[y]))) / sc
            if any(esc(y) <= 0 for y in need):
                continue
            cols = [[esc(y) for y in ys], [esc(y) ** 2 for y in ys], [giv(y - 1) for y in ys],
                    [esc(y - 1) for y in ys], [esc(y - 1) ** 2 for y in ys]][:PROFILE_MODELS[model]]
            v = mq3.ols_ss([giv(y) for y in ys], cols)
            if v is not None and (best is None or v < best[0] - 1e-12 * max(abs(best[0]), 1e-300)):
                best = (v, f, kap)
    if best is None:
        return None, 'no admissible timing and share'
    _, f, kap = best
    st['b'] = {y: Lr[y] + f * kap * Cr[y] for y in st['run']}
    st.update(reading=reading, timing=f, kappa=kap, scale=max(st['b'][y] for y in train), test=sp[len(train):])
    bad = {y for y in sp if mq5.esc(st, y) <= 0}
    if len(bad) > mq3.MAX_BAD_E * len(sp):
        return None, 'catch at or above biomass'
    st['bad'] = bad
    st['train'] = [y for y in train if y not in bad]
    st['fit'] = mq3.fit_quadratic([mq5.esc(st, y) / st['scale'] for y in st['train']],
                                  [mq5.gam(st, y) / st['scale'] for y in st['train']])
    if st['fit'] is None:
        return None, 'degenerate fit'
    return st, None


def peak(st):
    """What is left at the fitted level law's peak, in the level's units: infinite where g rises everywhere (b >= 0)
    and nothing where it never rises (b < 0, a <= 0)."""
    a, b = st['fit']
    if b >= 0:
        return math.inf
    return (-a / (2 * b)) * st['scale'] if a > 0 else 0.0


# ---------------------------------------------------------------- episodes

def episodes(st, k=K):
    """Every test origin t0 with t0 - 1 and t0 + k in the run, no bad year from t0 - 1 to t0 + k - 1, and the catches
    of t0 .. t0 + k - 1 held (each within HELD of their mean) with a positive draw kappa C on the level."""
    b, c, kap, sc = st['b'], st['c'], st['kappa'], st['scale']
    pk = peak(st)
    out = []
    for t0 in st['test']:
        if (t0 + k) not in b or (t0 - 1) not in b:
            continue
        if any((t0 + j) in st['bad'] for j in range(-1, k)):
            continue
        cs = [c[t0 + j] for j in range(k)]
        m = sum(cs) / k
        if m <= 0 or max(cs) > HELD * m or m > HELD * min(cs):
            continue
        h = kap * m
        if h <= 0:
            continue
        pt = mq3.regime_point(st['fit'], h / sc)
        e0 = mq5.esc(st, t0)
        r = mq5.gam(st, t0 - 1)
        out.append({'stock': st['stockid'], 't0': t0,
                    'u': None if pt is None else b[t0] / (pt * sc),
                    'z': mq3.giving(st['fit'], e0 / sc) * sc / h,
                    'v': r / h,
                    'low': e0 < pk,
                    'falls': b[t0 + k] < b[t0],
                    'falls_every_step': all(b[t0 + j + 1] < b[t0 + j] for j in range(k)),
                    'level_fell_last_year': b[t0] < b[t0 - 1],
                    'crosses': pt is not None and b[t0 + k] >= pt * sc})
    return out


def below_stratum(e):
    """The below-point strata of x_t0 / TB*(H), or None where the episode is not below the point."""
    if e['u'] is None:
        return 'beyond giving'
    if e['u'] < STRATA_U[0]:
        return f'u < {STRATA_U[0]}'
    if e['u'] < STRATA_U[1]:
        return f'{STRATA_U[0]} <= u < {STRATA_U[1]:.2f}'
    return None


def deficit_bin(e):
    """The bin of the deficit g(E_t0) / H: below 0 one bin, then bins of Z_BIN up to 1, anything above in the last."""
    if e['z'] < 0:
        return 'below 0'
    return min(int(e['z'] / Z_BIN), int(round(1 / Z_BIN)) - 1)


def c1_stratum(e):
    return (e['stock'], deficit_bin(e))


def c2_stratum(e):
    return (e['stock'], deficit_bin(e), e['level_fell_last_year'])


def short(e):
    return e['v'] < 1


def is_below_low(e):
    return below_stratum(e) is not None and e['low']


# ---------------------------------------------------------------- the comparison: a stratified difference, by stock

def pooled_difference(eps, cls, stratum):
    """The Mantel-Haenszel weighted difference in the share falling between the episodes of class cls (True) and the
    rest, within strata: sum_s w_s (p_s(True) - p_s(False)) / sum_s w_s, w_s = n_s(True) n_s(False) / n_s; strata
    with one class only carry no weight. Returns the difference and the cells."""
    cells = defaultdict(lambda: {True: [0, 0], False: [0, 0]})
    for e in eps:
        s = stratum(e)
        if s is None:
            continue
        cell = cells[s][bool(cls(e))]
        cell[0] += e['falls']
        cell[1] += 1
    num = den = 0.0
    for s, cl in cells.items():
        (f1, n1), (f0, n0) = cl[True], cl[False]
        if n1 and n0:
            w = n1 * n0 / (n1 + n0)
            num += w * (f1 / n1 - f0 / n0)
            den += w
    return (num / den if den > 0 else None), cells


def compare(eps, cls, stratum, seed=SEED, keep_cells=False, testable_on=None):
    """The pooled difference, its one-sided 95% lower bound from a bootstrap over stocks (origins overlap within a
    stock, so the stock is the unit resampled; a stock drawn twice is two stocks, its strata apart), and the counts
    the testable condition reads: the compared episodes (those in strata where both classes occur) in each class, and
    their stocks. testable_on, where given, picks the compared episodes the condition counts instead of a class.
    Passed where the difference is positive and its lower bound above zero."""
    d, cells = pooled_difference(eps, cls, stratum)
    both = {s for s, cl in cells.items() if cl[True][1] and cl[False][1]}
    used = [e for e in eps if stratum(e) in both]
    n = {c_: sum(bool(cls(e)) == c_ for e in used) for c_ in (True, False)}
    stocks = {c_: len({e['stock'] for e in used if bool(cls(e)) == c_}) for c_ in (True, False)}
    by = defaultdict(list)
    for e in eps:
        if stratum(e) is not None:
            by[e['stock']].append(e)
    keys = sorted(by, key=str)
    rng = random.Random(seed)
    ds = []
    if d is not None and keys:
        for _ in range(BOOT):
            sample = []
            for j, s in enumerate(rng.choice(keys) for _ in keys):
                sample += [(j, e) for e in by[s]]
            x = pooled_difference([e for _, e in sample], cls,
                                  _relabel(stratum, {id(e): j for j, e in sample}))[0] if sample else None
            if x is not None:
                ds.append(x)
    ds.sort()
    lower = ds[int(0.05 * len(ds))] if ds else None
    if testable_on is None:
        testable = (n[True] >= MIN_EPISODES and n[False] >= MIN_EPISODES and stocks[True] >= MIN_CLASS_STOCKS
                    and stocks[False] >= MIN_CLASS_STOCKS)
    else:
        counted = [e for e in used if testable_on(e)]
        testable = len(counted) >= MIN_EPISODES and len({e['stock'] for e in counted}) >= MIN_CLASS_STOCKS
    testable = testable and len({e['stock'] for e in used}) >= MIN_STOCKS
    out = {'difference': d, 'lower_95': lower, 'resamples': len(ds), 'episodes': {str(c_): n[c_] for c_ in n},
           'stocks': {str(c_): stocks[c_] for c_ in stocks}, 'stocks_compared': len({e['stock'] for e in used}),
           'strata_compared': len(both),
           'verdict': ('not testable' if not testable else
                       'passed' if (d > 0 and lower is not None and lower > 0) else 'failed')}
    if testable_on is not None:
        out['counted_for_testable'] = sum(bool(testable_on(e)) for e in used)
    if keep_cells:
        out['cells'] = {str(s): {'falls_true': cl[True][0], 'n_true': cl[True][1], 'falls_false': cl[False][0],
                                 'n_false': cl[False][1]} for s, cl in sorted(cells.items(), key=str)}
    return out


def _relabel(stratum, draw_of):
    """A stratum function that keeps the copies of a stock drawn more than once apart."""
    def f(e):
        s = stratum(e)
        return None if s is None else (draw_of.get(id(e)), s)
    return f


def discordant(e):
    """The recent giving's class differs from the level's last change: short where the level rose, or meeting the draw
    where it fell (the catch moved at the origin by more than the level did)."""
    return short(e) != e['level_fell_last_year']


# ---------------------------------------------------------------- the rules

def rules(stocks, k=K, report=True):
    """C1, the prediction: below the regime's point, on the low side of the level law's peak, the episodes whose recent
       giving falls short of the draw fall more often than those whose recent giving meets it, in the same stock and
       the same bin of the deficit g(E_t0) / H. Passed where the pooled difference is positive and its one-sided 95%
       stock-bootstrap lower bound is above zero.
    C2, beyond the level's last change: C1 within strata of the same sign of the level's change over the year before
       the origin as well. Under a held catch the recent giving falls short of the draw exactly where the level fell
       last year, less the catch's change at the origin (the balance), so C1 alone does not tell giving against the
       draw from a trend of the level; C2 compares only episodes of the same trend, whose classes differ through the
       catch's change at the origin. Momentum predicts no difference (or the reverse); the balance with persisting
       giving predicts C1's sign. Passed as C1; testable with at least MIN_EPISODES discordant episodes (the recent
       giving's class against the level's last change) from MIN_CLASS_STOCKS stocks among the compared.
    Reported (not verdicts): the share falling in each class, falling at every step and crossing the point by year K
    (`Crossing.crosses`); C1 pooled over stocks in MQ3's strata of the level (x_t0 / TB*(H)), as first drafted, which
    the regime's step itself passes in the dry runs; C1 over the high side of the peak and over both sides; above the
    point, short against meets; the level's part at the same class of recent giving (below the point against above it,
    on the low side: C3, reported, since over K years the theorem orders the eventual rest, not the next steps); the
    graded share falling by recent giving over the draw; the frozen rest's call (falls iff short) and momentum's
    (falls iff the level fell last year)."""
    E = [e for st in stocks for e in episodes(st, k)]
    below_low = [e for e in E if is_below_low(e)]
    out = {'stocks': len(stocks), 'episodes': len(E), 'below_low': len(below_low),
           'below_low_stocks': len({e['stock'] for e in below_low})}
    out['C1'] = compare(below_low, short, c1_stratum)
    out['C2'] = compare(below_low, short, c2_stratum, testable_on=discordant)
    out['C2']['discordant'] = {'short_level_rose': sum(short(e) and not e['level_fell_last_year'] for e in below_low),
                               'meets_level_fell': sum((not short(e)) and e['level_fell_last_year']
                                                       for e in below_low)}
    if not report:
        return out
    rep = {}
    for name, sel in (('short', lambda e: short(e)), ('meets', lambda e: not short(e))):
        x = [e for e in below_low if sel(e)]
        n = len(x)
        rep[name] = {'n': n, 'falls': sum(e['falls'] for e in x) / n if n else None,
                     'falls_every_step': sum(e['falls_every_step'] for e in x) / n if n else None,
                     'crosses_where_a_point': [sum(e['crosses'] for e in x if e['u'] is not None),
                                               sum(e['u'] is not None for e in x)]}
    rep['all_below_low_fall'] = sum(e['falls'] for e in below_low) / len(below_low) if below_low else None
    rep['C1_pooled_level_strata'] = compare(below_low, short, below_stratum, keep_cells=True)
    below_all = [e for e in E if below_stratum(e) is not None]
    rep['C1_high_side_only'] = compare([e for e in below_all if not e['low']], short, c1_stratum)
    rep['C1_both_sides'] = compare(below_all, short, c1_stratum)

    def side(e):
        if e['u'] is None or e['u'] < 1 / SEP:
            return 'below'
        if e['u'] > SEP:
            return 'above'
        return None
    above_low = [e for e in E if side(e) == 'above' and e['low']]
    rep['above_point_short_vs_meets'] = compare(above_low, short, lambda e: e['stock'])
    rep['C3_level_at_same_recent_giving'] = compare([e for e in E if e['low'] and side(e)],
                                                    lambda e: side(e) == 'below', lambda e: (e['stock'], short(e)))
    bins = [(-math.inf, 0.8), (0.8, 1.0), (1.0, 1.25), (1.25, math.inf)]
    rep['graded_by_r_over_H'] = [{'from': lo, 'to': hi, 'n': len(x), 'falls': (sum(e['falls'] for e in x) / len(x))
                                  if x else None}
                                 for lo, hi in bins for x in [[e for e in below_low if lo <= e['v'] < hi]]]
    n = len(below_low)
    rep['frozen_rest_call_right'] = sum(short(e) == e['falls'] for e in below_low) / n if n else None
    rep['momentum_call_right'] = sum(e['level_fell_last_year'] == e['falls'] for e in below_low) / n if n else None
    out['reported'] = rep
    return out


def run_rules(stocks):
    """The rules at K, with C1 and C2 at K_REPORTED years reported."""
    out = rules(stocks)
    r5 = rules(stocks, K_REPORTED, report=False)
    out['reported'][f'C1_k{K_REPORTED}'] = r5['C1']
    out['reported'][f'C2_k{K_REPORTED}'] = r5['C2']
    return out


def verdicts(res):
    return {r: res[r]['verdict'] for r in ('C1', 'C2')}


def brief(c):
    return {k: c.get(k) for k in ('difference', 'lower_95', 'episodes', 'stocks_compared', 'verdict')}


def summary(res):
    """The numbers a reader needs from one group's rules."""
    rep = res.get('reported', {})
    out = {'stocks': res['stocks'], 'episodes': res['episodes'], 'below_low': res['below_low'],
           'below_low_stocks': res['below_low_stocks'], 'C1': brief(res['C1']), 'C2': brief(res['C2']),
           'C2_discordant': res['C2']['discordant']}
    if rep:
        out.update({'falls_short_meets': [rep['short']['falls'], rep['meets']['falls']],
                    'C1_pooled_level_strata': brief(rep['C1_pooled_level_strata']),
                    'C3_reported': brief(rep['C3_level_at_same_recent_giving'])})
        if f'C1_k{K_REPORTED}' in rep:
            out[f'C1_k{K_REPORTED}'] = brief(rep[f'C1_k{K_REPORTED}'])
    return out


# ---------------------------------------------------------------- development (RAM stocks MQ3-MQ5 read; not a test)

def ram_stocks(ts, A, cat, assessids, reading, timings=TIMINGS, region=None):
    """The given RAM assessments read as stocks: the level is TB (kappa 1) or SSB (kappa fitted), MQ5's series ids."""
    groups, excluded = defaultdict(list), Counter()
    for a in sorted(assessids):
        info = A[a]
        group, category = mq4.group_of(cat, info['method'])
        tsa = ts.get(a, {})
        tbid, cid = mq3.choose_ids(tsa)
        lid = tbid if reading == 'TB' else mq5.choose_ssb(tsa)
        if not lid or not cid:
            excluded[(group, 'no level or catch')] += 1
            continue
        mult = mq3.TB_IDS[lid] if reading == 'TB' else mq5.SSB_IDS[lid]
        cm = dict(mq3.C_IDS)[cid]
        L = {y: v * mult for y, v in tsa[lid].items() if v is not None}
        C = {y: v * cm for y, v in tsa[cid].items() if v is not None}
        st, why = read_stock(L, C, reading, timings, READINGS[reading]['model'])
        if st is None:
            excluded[(group, why)] += 1
            continue
        st.update(stockid=info['stockid'], assessid=a, method=info['method'], category=category,
                  region=(region or {}).get(info['stockid'], ''))
        groups[group].append(st)
    return groups, excluded


def timing_table(stocks, known_after):
    """How the timing step reads the series whose timing is known: in RAM, New Zealand's CASAL assessments report the
    spawning biomass mid-season, after part of the year's catch (MQ5 post hoc); the rest are taken as before it."""
    t = Counter()
    for st in stocks:
        t[(('after part' if known_after(st) else 'before'), st['timing'])] += 1
    return {f'{k[0]} | f = {k[1]}': v for k, v in sorted(t.items())}


def dev(xlsx):
    import posthoc_mq5
    region = posthoc_mq5.regions(xlsx)
    A, devset = mq5.dev_assessments(xlsx)
    sel = mq5.selection(xlsx)
    mq5set = set(sel['chosen'].values())
    ts = mq5.load_values(xlsx, devset | mq5set)
    cat = mq3.method_categories(xlsx)
    A = {**sel['A'], **A}
    out = {'scope': "development: the RAM Legacy stocks MQ3, MQ4 and MQ5 read, already read there; not a test"}

    def nz(st):
        return st['region'] == 'New Zealand' and st['method'] == 'CASAL'
    for name, aset, reading in (('TB_mq3_mq4', devset, 'TB'), ('SSB_mq5', mq5set, 'SSB'),
                                ('SSB_mq3_mq4', devset, 'SSB')):
        groups, excluded = ram_stocks(ts, A, cat, aset, reading, region=region)
        g0, _ = ram_stocks(ts, A, cat, aset, reading, timings=(0.0,), region=region)
        part = {'excluded': {f'{k[0]} | {k[1]}': v for k, v in sorted(excluded.items())},
                'stocks': {g_: len(v) for g_, v in groups.items()},
                'timing_against_known': timing_table([s for v in groups.values() for s in v], nz)}
        for g_ in ('primary', 'control', 'other'):
            res = run_rules(groups.get(g_, []))
            res0 = rules(g0.get(g_, []), report=False)
            part[g_] = res
            part[g_ + '_summary'] = summary(res)
            part[g_ + '_at_f0'] = {r: brief(res0[r]) for r in ('C1', 'C2')}
        prim = groups.get('primary', [])
        for label, sub in (('New Zealand CASAL', [s for s in prim if nz(s)]), ('rest', [s for s in prim if not nz(s)])):
            part['primary | ' + label] = summary(rules(sub, report=False))
        out[name] = part
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, 'development.json'), 'w') as f:
        json.dump(out, f, indent=1, default=str)
    print(json.dumps({n: {k: v for k, v in p.items() if k.endswith('summary') or k.endswith('f0') or '|' in k
                          or k in ('stocks', 'timing_against_known')}
                      for n, p in out.items() if isinstance(p, dict)}, indent=1, default=str))


# ---------------------------------------------------------------- dry runs (synthetic stocks)

def adjusting_stock(rng, draw, phi=0.96, lam=0.29, n_years=60):
    """The hypothesis: giving that adjusts, rising in what is left and in the recent giving, at the field's in-sample
    rates (MQ5's development: giving closes about 0.3 of its gap to the draw each year). SP_t = (phi SP_{t-1} + (1 - phi)
    g(E_t) + lam (E_{t-1} - E_t)) times lognormal noise 0.1, which by the balance is (phi - lam) SP_{t-1} + lam H_t +
    (1 - phi) g(E_t): 0.67 of the recent giving, 0.29 of the draw and 0.04 of the level law's giving. Schaefer g with
    K = 1e5 t, r 0.2-0.8; the spawning stock a share 0.4-0.9 of the whole. draw: 'law' (the catch follows the level,
    C_t = C_{t-1} (b_t / b_{t-1})^0.7 with noise 0.1, from a share 0.05-0.35, at most 0.6 of the level: MQ5's) or
    'reset' (held catches reset every 3-6 years to a share of the level: MQ3's)."""
    K_ = 1e5
    r = rng.uniform(0.2, 0.8)
    b = rng.uniform(0.3, 0.9) * K_
    om = rng.uniform(0.4, 0.9)
    tb, ssb, c = {}, {}, {}
    until, catch, s_prev, e_prev, b_prev = 0, 0.0, None, None, None
    for i in range(n_years):
        if draw == 'reset':
            if i >= until:
                u = rng.uniform(0.0, 0.1) if b < 0.25 * K_ else rng.uniform(0.02, 0.5)
                catch = u * b
                until = i + rng.randint(3, 6)
        else:
            catch = (rng.uniform(0.05, 0.35) * b if b_prev is None
                     else catch * (b / b_prev) ** mq5.EPS * math.exp(rng.gauss(0, 0.1)))
            catch = min(catch, 0.6 * b)
        tb[1950 + i], ssb[1950 + i], c[1950 + i] = b, om * b, catch
        e = b - catch
        if e <= 0:
            break
        g = r * e * (1 - e / K_)
        if s_prev is None:
            s_prev, e_prev = g, e
        sp = (phi * s_prev + (1 - phi) * g + lam * (e_prev - e)) * math.exp(rng.gauss(0, 0.1))
        s_prev, e_prev, b_prev = sp, e, b
        b = max(e + sp, 0.0)
        if b <= 0:
            break
    return tb, ssb, c


def level_law_stock(rng, n_years=60):
    """The null with the field's draw: giving read off the level (Schaefer, lognormal noise 0.2: MQ3's premise), the
    catch following the level as in adjusting_stock's 'law'."""
    K_ = 1e5
    r = rng.uniform(0.2, 0.8)
    b = rng.uniform(0.3, 0.9) * K_
    om = rng.uniform(0.4, 0.9)
    tb, ssb, c = {}, {}, {}
    catch, b_prev = None, None
    for i in range(n_years):
        catch = (rng.uniform(0.05, 0.35) * b if b_prev is None
                 else catch * (b / b_prev) ** mq5.EPS * math.exp(rng.gauss(0, 0.1)))
        catch = min(catch, 0.6 * b)
        tb[1950 + i], ssb[1950 + i], c[1950 + i] = b, om * b, catch
        e = b - catch
        if e <= 0:
            break
        b_prev = b
        b = max(e + r * e * (1 - e / K_) * math.exp(rng.gauss(0, 0.2)), 0.0)
        if b <= 0:
            break
    return tb, ssb, c


def trend_stock(rng, n_years=60):
    """A null in which the catch does not move the level: the level's log change follows an AR(1) of its own (rho
    0.7, innovations 0.1, pulled back toward its start at 0.1 a year) whatever is caught, and the catch is a share of
    the level reset every 3-6 years (0.05-0.4). Giving read off the balance then carries the trend, so the recent
    giving falls short of the draw where the level fell, and the catch's change at an origin changes no fate."""
    x = rng.uniform(0.3, 0.9) * 1e5
    x0 = x
    d = 0.0
    tb, c = {}, {}
    until, u = 0, 0.0
    for i in range(n_years):
        if i >= until:
            u = rng.uniform(0.05, 0.4)
            until = i + rng.randint(3, 6)
        tb[1950 + i] = x
        c[1950 + i] = u * x
        d = 0.7 * d - 0.1 * math.log(x / x0) + rng.gauss(0, 0.1)
        x = x * math.exp(d)
    return tb, dict(tb), c


# name: (maker, stocks generated per seed, seeds); 'level' and 'level-law' are the regime's step (giving read off the
# level, MQ3's premise), the null under which recent giving changes no fate (most of 'level''s stocks end before 25
# years, hence the larger draw); 'adjusting' the hypothesis at the field's in-sample rates; 'mq5-state' MQ5's frozen
# state with the lag (lam 0.55, giving moving faster toward the draw than in sample); 'relaxing' MQ4's state; 'trend'
# the null in which the catch moves no level; 'age' an age-structured stock (not the hypothesis).
DRY = {'level': (lambda rng: mq5.synthetic('level', rng), 2000, 4),
       'level-law': (level_law_stock, 400, 4),
       'adjusting-law': (lambda rng: adjusting_stock(rng, 'law'), 300, 4),
       'adjusting-reset': (lambda rng: adjusting_stock(rng, 'reset'), 300, 4),
       'mq5-state': (lambda rng: mq5.synthetic('hypothesis', rng), 300, 1),
       'relaxing': (lambda rng: mq5.synthetic('relaxing', rng), 600, 1),
       'trend': (trend_stock, 300, 2),
       'age': (lambda rng: mq5.synthetic('age', rng), 300, 1)}
MISTIMED = (0.5, 1.0)       # the hypothesis reported after these shares of the year's catch, in both readings


def dry_set(maker, n, seed, reading, f=0.0, timings=TIMINGS):
    """Synthetic stocks read as the field is read; the level reported after a share f of the year's catch."""
    rng = random.Random(seed)
    stocks, timing = [], Counter()
    for i in range(n):
        tb, ssb, c = maker(rng)
        level = tb if reading == 'TB' else ssb
        obs = {y: level[y] - f * (level[y] / tb[y]) * c[y] for y in level}
        obs = {y: v for y, v in obs.items() if v > 0}
        st, why = read_stock(obs, c, reading, timings, READINGS[reading]['model'])
        if st is None:
            continue
        st.update(stockid=f'{seed}-{i}', assessid=f'{seed}-{i}', method='synthetic', category='synthetic')
        stocks.append(st)
        timing[st['timing']] += 1
    return stocks, {str(k): v for k, v in sorted(timing.items())}


def dry():
    out = {'runs': {}, 'pass_rates': {}}
    for name, (maker, n, seeds) in DRY.items():
        for reading in ('TB', 'SSB'):
            tally = Counter()
            for s in range(seeds):
                seed = SEED + 100 * s
                stocks, timing = dry_set(maker, n, seed, reading)
                res = rules(stocks)
                key = f'{name} | {reading} | seed {seed}'
                out['runs'][key] = {'timing_read': timing, **summary(res)}
                for r in ('C1', 'C2'):
                    tally[(r, res[r]['verdict'])] += 1
            out['pass_rates'][f'{name} | {reading}'] = {f'{r} {v}': c for (r, v), c in sorted(tally.items())}
    for f in MISTIMED:
        for reading in ('TB', 'SSB'):
            for timings, label in ((TIMINGS, 'timing read'), ((0.0,), 'read at f = 0')):
                stocks, timing = dry_set(DRY['adjusting-law'][0], 300, SEED, reading, f, timings)
                res = rules(stocks)
                out['runs'][f'adjusting-law, mistimed f = {f} | {reading} | {label}'] = {'timing_read': timing,
                                                                                         **summary(res)}
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, 'dry-runs.json'), 'w') as fh:
        json.dump(out, fh, indent=1, default=str)
    for k, v in out['runs'].items():
        print(k, json.dumps({'stocks': v['stocks'], 'timing': v['timing_read'], 'C1': v['C1'], 'C2': v['C2']},
                            default=str), flush=True)
    print(json.dumps(out['pass_rates'], indent=1))


# ---------------------------------------------------------------- the stocks MQ3-MQ5 read (metadata, for matching)

def ram_read_stocks(xlsx):
    """The RAM Legacy stocks whose values MQ3, MQ4 or MQ5 read, with species, area and region (metadata only)."""
    import ram_read
    sel = mq5.selection(xlsx)
    read = sel['mq3_stocks'] | sel['mq4_stocks'] | set(sel['chosen'])
    it = ram_read.rows(xlsx, 'stock')
    h = next(it)
    ix = {k: i for i, k in enumerate(h)}
    out = []
    for r in it:
        r = r + [''] * (len(h) - len(r))
        if r[ix['stockid']] in read:
            out.append({k: r[ix[k]] for k in ('stockid', 'scientificname', 'commonname', 'areaid', 'stocklong',
                                              'region', 'tsn')})
    return out


# ---------------------------------------------------------------- the test data: NOAA Stock SMART

SMART_DATA, SMART_SUMMARY = 'stock_assessment_data.rda', 'stock_assessment_summary.rda'

# weight units to tonnes (every other unit, numbers, eggs, ratios and indices, is not a weight and is not read)
WEIGHT = {'metric tons': 1.0, 'mt': 1.0, 'thousand metric tons': 1e3, 'million metric tons': 1e6,
          'pounds': 0.45359237e-3, 'lbs': 0.45359237e-3, 'thousand pounds': 0.45359237, 'million pounds': 453.59237,
          'million lbs.': 453.59237, 'lbs x 1000000': 453.59237, 'tonnes': 1.0, 't': 1.0}
# the abundance series that are not a level of the stock as the draw takes it: survey, smoothed, adjusted, complex,
# relative and per-sex-of-the-other-kind readings
NOT_A_LEVEL = ('survey', 'random effects', 'area-swept', 'complex', 'retro', 'relative', 'ratio', '/', 'geometric',
               'running average', 'moving average', 'index', 'depletion', 'cpue', 'egg', 'larva', 'oocyte', 'output')
SPAWNING = ('spawn', 'mature', 'female', 'male')


def smart_reading(description, units):
    """The reading an abundance series of Stock SMART gives: 'TB' (a total, exploitable or age-k+ biomass), 'SSB' (a
    spawning, mature or one-sex biomass), 'survey' (a survey or survey-smoothed biomass in weight, reported apart) or
    None (not a weight, or not a level)."""
    d, u = (description or '').lower(), (units or '').lower().strip()
    if u not in WEIGHT or 'biomass' not in d:
        return None
    if any(w in d for w in ('survey', 'random effects', 'area-swept')):
        return 'survey'
    if any(w in d for w in NOT_A_LEVEL):
        return None
    return 'SSB' if any(w in d for w in SPAWNING) else 'TB'


CATCH_ORDER = ('total catch', 'estimated total catch', 'catch - total', 'reported catch - total',
               'landings + discards', 'landings and discards', 'catch', 'modeled catch - total', 'modeled total catch',
               'modeled catch')


GEARS = ('spear', 'hook', 'line', 'trawl', 'longline', 'gillnet', 'pot', 'trap', 'seine', 'sport')
FLEETS = ('commercial', 'recreational')


def partial_catch(d):
    """A catch series that names a single gear, or one of the commercial and recreational fleets, and is not a total:
    the draw it gives is part of the draw on the level, so it is not read."""
    if 'total' in d:
        return False
    if any(g in d.split() or g + ' ' in d or g + '-' in d for g in GEARS):
        return True
    return sum(f in d for f in FLEETS) == 1 and '+' not in d and ' and ' not in d


def smart_catch_rank(description, units):
    """The order in which an assessment's catch series are taken: total catch, reported or estimated, before modelled
    catch, and catch before landings or harvest (MQ3: total catch, else landings); None where not a weight or where
    the series is part of the draw (partial_catch)."""
    d, u = (description or '').lower().strip(), (units or '').lower().strip()
    if u not in WEIGHT or partial_catch(d):
        return None
    for i, k in enumerate(CATCH_ORDER):
        if d.startswith(k):
            return i
    if any(w in d for w in ('landings', 'harvest', 'retained')):
        return len(CATCH_ORDER) + 1
    return len(CATCH_ORDER)


PRIMARY_MODELS = ('vpa', 'cohort analysis', 'scaa', 'scal', 'stock synthesis', 'ss', 'ss3', 'asap', 'amak', 'gmacs',
                  'bam', 'wham', 'multifan', 'scale', 'beaufort', 'tcsam', 'adapt', 'casa', 'csa',
                  'age-structured', 'size-based', 'length-based', 'casal')
CONTROL_MODELS = ('production', 'jabba', 'aspic', 'bsp', 'schaefer', 'db-sra', 'spict')


def model_group(model):
    """primary: age-, length-, size- or stage-structured population models; control: biomass dynamics (production)
    models, in which the level is generated by a production function; other: index, survey, catch-only and the rest.
    Age-structured production models (SSASPM) are age-structured, so primary."""
    m = (model or '').lower()
    if 'age-structured' in m or 'age structured' in m:
        return 'primary'
    if 'index' in m:
        return 'other'
    if any(w in m for w in CONTROL_MODELS):
        return 'control'
    words = m.replace('(', ' ').replace(')', ' ').replace(',', ' ').replace('-', ' ').split()
    if any(w in m for w in PRIMARY_MODELS if len(w) > 3) or any(w in words for w in PRIMARY_MODELS if len(w) <= 3):
        return 'primary'
    return 'other'


def smart_tables(smart):
    import rda_read
    data = next(v for v in rda_read.load(os.path.join(smart, SMART_DATA)).values() if isinstance(v, rda_read.Frame))
    summ = next(v for v in rda_read.load(os.path.join(smart, SMART_SUMMARY)).values()
                if isinstance(v, rda_read.Frame))
    return data, summ


def smart_assessments(smart, values=False):
    """{assessment_id: {'stock', 'stock_name', 'scientific_name', 'itis', 'stock_area', 'jurisdiction', 'year',
    'model', 'series': {(metric, description, units): {year: value or None}}}}. With values=False the value column is
    never read (presence only)."""
    data, summ = smart_tables(smart)
    model = {}
    for a, m in zip(summ.column('assessment_id'), summ.column('assessment_model')):
        model[a] = m
    cols = {n: data.column(n) for n in ('assessment_id', 'stock_id', 'stock_name', 'scientific_name', 'itis',
                                        'stock_area', 'jurisdiction', 'assessment_year', 'year', 'metric',
                                        'description', 'units')}
    vals = data.column('value') if values else None
    out = {}
    for i, a in enumerate(cols['assessment_id']):
        rec = out.get(a)
        if rec is None:
            rec = out[a] = {k: cols[c][i] for k, c in (('stock', 'stock_id'), ('stock_name', 'stock_name'),
                                                       ('scientific_name', 'scientific_name'), ('itis', 'itis'),
                                                       ('stock_area', 'stock_area'),
                                                       ('jurisdiction', 'jurisdiction'),
                                                       ('year', 'assessment_year'))}
            rec['model'] = model.get(a)
            rec['series'] = defaultdict(dict)
        if cols['year'][i] is None:
            continue
        rec['series'][(cols['metric'][i], cols['description'][i], cols['units'][i])][int(cols['year'][i])] = (
            vals[i] if values else None)
    return out


def smart_choice(A):
    """For each stock and reading, the assessment read: the most recent (assessment year, then the longer run, then the
    id) with a level of that reading and a catch, both in weight; for each the level series and the catch series
    (the first by smart_catch_rank). Presence only."""
    cand = defaultdict(list)
    for a, rec in A.items():
        levels = defaultdict(list)
        catches = []
        for (m, d, u), ys in rec['series'].items():
            if m == 'Abundance':
                rd = smart_reading(d, u)
                if rd:
                    levels[rd].append((m, d, u))
            elif m == 'Catch':
                rk = smart_catch_rank(d, u)
                if rk is not None:
                    catches.append((rk, (m, d, u)))
        if not catches:
            continue
        ckey = min(catches)[1]
        for rd, keys in levels.items():
            for lk in sorted(keys):
                n = len(mq3.longest_run(set(rec['series'][lk]) & set(rec['series'][ckey])))
                cand[(rec['stock'], rd)].append((rec['year'] or 0, n, a, lk, ckey))
    out = {}
    for (s, rd), lst in cand.items():
        lst.sort(key=lambda x: (-x[0], -x[1], x[2]))
        y, n, a, lk, ck = lst[0]
        out[(s, rd)] = {'assessment': a, 'assessment_year': y, 'run': n, 'level': lk, 'catch': ck}
    return out


# ---------------------------------------------------------------- the test data: ICES Stock Assessment Graphs

def sag_list(sag):
    """Every record of the SAG stock lists saved in the directory (StockList-YYYY.json)."""
    out = []
    for name in sorted(os.listdir(sag)):
        if name.startswith('StockList-') and name.endswith('.json'):
            with open(os.path.join(sag, name), encoding='utf-8') as f:
                out += json.load(f)
    return out


def sag_latest(sag):
    """For each ICES stock, its latest published advice assessment (the whole stock, not a component): by assessment
    year, then key."""
    latest = {}
    for r in sag_list(sag):
        if (r.get('Purpose') or '') != 'Advice' or (r.get('Status') or '').strip() != 'Published':
            continue
        if r.get('AssessmentComponent') not in (None, ''):
            continue
        k = r['StockKeyLabel']
        if k not in latest or (r['AssessmentYear'], r['AssessmentKey']) > (latest[k]['AssessmentYear'],
                                                                           latest[k]['AssessmentKey']):
            latest[k] = r
    return latest


def sag_summary(sag, key):
    """The SummaryTable of one assessment (SummaryTable-KEY.json), or None where it was not downloaded."""
    p = os.path.join(sag, f'SummaryTable-{key}.json')
    if not os.path.exists(p):
        return None
    with open(p, encoding='utf-8') as f:
        return json.load(f)


SAG_FIELDS = ('TBiomass', 'SSB', 'Catches', 'Landings')


def sag_series(d, values=False):
    """{field: {year: value or None}} for the level and catch fields of one SummaryTable, where present (non-null).
    With values=False only the presence of a value is kept."""
    out = {f: {} for f in SAG_FIELDS}
    for line in d.get('Lines') or []:
        y = line.get('Year')
        if y is None:
            continue
        for f in SAG_FIELDS:
            v = line.get(f)
            if v is not None and v != '':
                out[f][int(y)] = float(v) if values else None
    return out


def sag_reading(d, series):
    """The readings a SummaryTable gives, by the units it states: 'TB' where total biomass is present (SAG gives no
    unit for it apart from the table's; the table's stock size and catch units must be tonnes), 'SSB' where the stock
    size is described as SSB in tonnes; the catch is total catches, else landings, in the table's units (tonnes)."""
    su = (d.get('StockSizeUnits') or '').strip().lower()
    cu = (d.get('Units') or '').strip().lower()
    desc = (d.get('StockSizeDescription') or '').strip().lower()
    out = {}
    if cu not in WEIGHT:
        return out, None
    cid = 'Catches' if len(series['Catches']) >= len(series['Landings']) and series['Catches'] else (
        'Landings' if series['Landings'] else None)
    if cid is None:
        return out, None
    if series['TBiomass'] and su in WEIGHT:
        out['TB'] = 'TBiomass'
    if series['SSB'] and su in WEIGHT and ('ssb' in desc or 'spawning' in desc):
        out['SSB'] = 'SSB'
    return out, cid


def sag_group(model_type, model):
    """SAG's model type: age-based (A) and age-length (AL) models are primary, biomass dynamics (B) control; the rest
    by the model's name (model_group)."""
    if model_type in ('A', 'AL'):
        return 'primary'
    if model_type == 'B':
        return 'control'
    return model_group(model)


# ---------------------------------------------------------------- the test stocks: layout (presence) and values

def matching():
    with open(os.path.join(OUT, 'matching.json')) as f:
        return json.load(f)


def test_series(smart, sag, values):
    """Every unread stock of matching.json as series to read: {(source, stock, reading): {'group', 'model', 'level',
    'catch', 'assessment', 'name', 'L': {year: value}, 'C': {year: value}}}, values in tonnes; with values=False the
    values are None (presence only)."""
    M = matching()
    out = {}
    unread = {int(k) for k, v in M['Stock SMART'].items() if v['decision'] == 'unread'}
    A = smart_assessments(smart, values)
    for (sid, rd), c in sorted(smart_choice(A).items(), key=str):
        if int(sid) not in unread:
            continue
        rec = A[c['assessment']]
        lk, ck = c['level'], c['catch']
        lm, cm = WEIGHT[lk[2].lower().strip()], WEIGHT[ck[2].lower().strip()]
        out[('Stock SMART', str(int(sid)), rd)] = {
            'group': model_group(rec['model']), 'model': rec['model'], 'level': lk[1], 'catch': ck[1],
            'assessment': c['assessment'], 'assessment_year': c['assessment_year'], 'name': rec['stock_name'],
            'L': {y: (v * lm if values and v is not None else None) for y, v in rec['series'][lk].items()},
            'C': {y: (v * cm if values and v is not None else None) for y, v in rec['series'][ck].items()}}
    for k, v in sorted(M['ICES SAG'].items()):
        if v['decision'] != 'unread':
            continue
        d = sag_summary(sag, v['assessment_key'])
        if d is None:
            continue
        s = sag_series(d, values)
        rds, cid = sag_reading(d, s)
        for rd, lf in rds.items():
            out[('ICES SAG', k, rd)] = {
                'group': sag_group(v['model_type'], v['model']), 'model': v['model'], 'level': lf, 'catch': cid,
                'assessment': v['assessment_key'], 'assessment_year': v['assessment_year'], 'name': v['description'],
                'L': s[lf], 'C': s[cid]}
    return out


def layout(smart, sag):
    S = test_series(smart, sag, values=False)
    counts = Counter()
    eligible = defaultdict(list)
    for (src, sid, rd), r in sorted(S.items()):
        n_sp = len(mq3.longest_run(set(r['L']) & set(r['C']))) - 1
        ok = n_sp >= mq3.MIN_SP
        counts[f'{src} | {rd} | {r["group"]} | {"eligible by presence" if ok else "short"}'] += 1
        if ok:
            eligible[f'{rd} | {r["group"]}'].append({'source': src, 'stock': sid, 'name': r['name'], 'model': r['model'],
                                                    'assessment': r['assessment'],
                                                    'assessment_year': r['assessment_year'], 'level': r['level'],
                                                    'catch': r['catch'], 'sp_years_present': n_sp})
    out = {'scope': 'presence of series and years only; no value was read',
           'sources': {'Stock SMART': 'github.com/NOAA-EDAB/stocksmart, data/stock_assessment_data.rda and '
                                      'data/stock_assessment_summary.rda (pull of 2026-10-17)',
                       'ICES SAG': 'sag.ices.dk/SAG_API: StockList 2015-2025 and the SummaryTable of each unread stock'},
           'counts': dict(sorted(counts.items())), 'eligible': dict(sorted(eligible.items()))}
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, 'layout.json'), 'w') as f:
        json.dump(out, f, indent=1, default=str)
    print(json.dumps(out['counts'], indent=1))


def test_stocks(smart, sag, timings=None):
    """The test stocks read: {(reading, group): [stock]}, each reading as the verdicts read it, and the exclusions."""
    S = test_series(smart, sag, values=True)
    groups, excluded = defaultdict(list), Counter()
    for (src, sid, rd), r in sorted(S.items()):
        L = {y: v for y, v in r['L'].items() if v is not None}
        C = {y: v for y, v in r['C'].items() if v is not None}
        tm = READINGS[rd]['timings'] if timings is None else timings
        st, why = read_stock(L, C, 'TB' if rd in ('TB', 'survey') else 'SSB', tm, READINGS[rd]['model'])
        if st is None:
            excluded[f'{src} | {rd} | {r["group"]} | {why}'] += 1
            continue
        st.update(stockid=f'{src}:{sid}', source=src, method=r['model'], category=r['group'], name=r['name'],
                  levelid=r['level'], cid=r['catch'], assessid=r['assessment'], test_reading=rd)
        groups[(rd, r['group'])].append(st)
    return groups, excluded


def test(smart, sag):
    groups, excluded = test_stocks(smart, sag)
    g0, _ = test_stocks(smart, sag, timings=(0.0,))
    out = {'sources': 'NOAA Stock SMART (pull of 2026-10-17) and ICES Stock Assessment Graphs, the unread stocks of '
                      'results/mq7/matching.json',
           'readings': READINGS, 'verdict_reading': VERDICT_READING,
           'excluded': dict(sorted(excluded.items())),
           'stocks': {f'{k[0]} | {k[1]}': len(v) for k, v in sorted(groups.items())}}
    for (rd, g_), sts in sorted(groups.items()):
        key = f'{rd} | {g_}'
        res = run_rules(sts)
        out[key] = res
        out[key + ' | summary'] = summary(res)
        r0 = rules(g0.get((rd, g_), []), report=False)
        out[key + ' | at f = 0'] = {r: brief(r0[r]) for r in ('C1', 'C2')}
        for src in ('Stock SMART', 'ICES SAG'):
            sub = [s for s in sts if s['source'] == src]
            if sub:
                out[key + ' | ' + src] = summary(rules(sub, report=False))
    vr = out.get(f'{VERDICT_READING} | primary')
    out['verdicts'] = verdicts(vr) if vr else {'C1': 'not testable', 'C2': 'not testable'}
    out['fits'] = {f'{k[0]} | {k[1]}': [{'stock': s['stockid'], 'name': s['name'], 'model': s['method'],
                                         'level': s['levelid'], 'catch': s['cid'], 'years': [s['run'][0], s['run'][-1]],
                                         'train_to': s['train'][-1] if s['train'] else None, 'timing': s['timing'],
                                         'kappa': s['kappa'], 'a': s['fit'][0], 'b': s['fit'][1], 'scale_t': s['scale']}
                                        for s in v] for k, v in sorted(groups.items())}
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, 'VERDICTS-mq7.json'), 'w') as f:
        json.dump(out, f, indent=1, default=str)
    print(json.dumps({'stocks': out['stocks'], 'excluded': out['excluded'], 'verdicts': out['verdicts'],
                      **{k: v for k, v in out.items() if k.endswith('summary') or k.endswith('f = 0')
                         or k.endswith('Stock SMART') or k.endswith('ICES SAG')}}, indent=1, default=str))


# ---------------------------------------------------------------- commands

def main(argv):
    if len(argv) < 2:
        raise SystemExit(__doc__)
    cmd = argv[1]
    if cmd == 'dev':
        dev(argv[2])
    elif cmd == 'dry':
        dry()
    elif cmd == 'layout':
        layout(argv[2], argv[3])
    elif cmd == 'test':
        test(argv[2], argv[3])
    else:
        raise SystemExit(__doc__)


if __name__ == '__main__':
    main(sys.argv)
