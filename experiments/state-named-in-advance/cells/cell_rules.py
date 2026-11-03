"""UE31b's rules: UE31's verdicts on the adult-loss cultures, read by cell (standard library only).

UE31's rules (../state_rules.py) fit each culture alone and need 20 rows a culture; the archive's adult-loss cultures
hold 13 censuses under the loss (../LAYOUT.md). Here the unit is the cell: the replicate cultures of one strain at one
set loss, read together under one law, since they share the strain, the loss and the incubator. Everything else is
UE31's, imported and unchanged: the reading in T2's terms, the models, the excess and its chance level, the robust
test, the rival's sign and its band, the measured error, the median of per-loss medians, the gate and the combination
(state_rules.combine, with a cell where UE31 has a culture). What differs (cells/DESIGN.md §3):
  - rows from t = 3, so that every lag the rules read, E_{t-3} included, is under the loss;
  - one scale a cell, its cultures' largest adult count (the excess does not depend on it);
  - a cell needs 24 rows, twice the largest model's columns;
  - the out-of-sample comparisons (V4, V3) leave one culture out: the laws are fitted on the cell's other cultures and
    forecast the culture left out from every origin with two censuses behind it and five ahead.

A culture is a dict as in state_rules, with 'strain' (or a strain in its id, 'strain<k>'), 'L', 'P', 'A' at t = 0 .. T
from the census at which the loss is first set, and 'mu' the set loss.
"""
from __future__ import annotations

import math
import os
import re
import statistics
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import state_rules as R  # noqa: E402

FIRST = 3            # the first row: E_{t-3}, the furthest lag read (H1), is the escapement at the census of the onset
CELL_MIN_ROWS = 24   # rows a cell needs: twice the columns of the largest model (12)
ORIGIN = 2           # the first forecast origin: E_{t-2} and E_{t-1} under the loss
MIN_CELLS = R.MIN_CULTURES   # a verdict needs at least 6 cells (state_rules.combine reads its units as given)
PROTOCOL_SHARE = 0.125  # the recording check: recruits above the pupae by more than half an animal in more than this
                        # share of the rows (46 or more of 360) and no verdict is read (DESIGN.md §7)
PROTOCOL_AGREES = "the reading's form and the stage counts agree with the protocol"
PROTOCOL_DISAGREES = "the reading's form or the stage counts disagree with the protocol"
VERDICTS = ('W', 'V2', 'H1', 'V5', 'sign', 'V4', 'reading')


def strain(c):
    if c.get('strain') is not None:
        return c['strain']
    m = re.search(r'strain(\d+)', c['id'])
    return int(m.group(1)) if m else None


def cells(cultures):
    """{(strain, set loss): [cultures]}, in sorted order."""
    out = {}
    for c in cultures:
        out.setdefault((strain(c), c['mu']), []).append(c)
    return dict(sorted(out.items(), key=lambda kv: (kv[0][0], kv[0][1])))


def last_alive(c):
    return max(t for t in range(len(c['A'])) if c['A'][t] + c['P'][t] + c['L'][t] > 0)


def scale_of(cs):
    """A cell's scale: its cultures' largest adult count, through each one's last census with any animal."""
    return max(max(R.returned_adults(c)[:last_alive(c) + 1]) for c in cs) or 1.0


def reading(c, s):
    """The culture in T2's terms (state_rules.reading's), at the cell's scale s, through its last census with any
    animal, with rows from FIRST."""
    A = R.returned_adults(c)
    end = last_alive(c)
    A, P, L = A[:end + 1], c['P'][:end + 1], c['L'][:end + 1]
    mu = c['mu'] or 0.0
    T = len(A) - 1
    a = [x / s for x in A]
    e = [(1 - mu) * x for x in a]
    g = [a[t + 1] - e[t] for t in range(T)]
    return {'id': c['id'], 'A': a, 'P': [x / s for x in P], 'L': [x / s for x in L], 'E': e, 'G': g, 'mu': mu,
            'rows': list(range(FIRST, T)), 'scale': s, 'rawA': A}


def design(rs, names):
    """The cell's columns and its giving over every culture's rows, culture after culture."""
    cols = [[R.column(r, n, t) for r in rs for t in r['rows']] for n in names]
    return cols, [r['G'][t] for r in rs for t in r['rows']]


def in_cell(rs, models=R.MODELS):
    """Each comparison's excess and robust test over the cell's rows (state_rules.in_sample's, the cell for the
    culture); the lag's effect at the cell's means, the rival's sign over the cell's rows, and the measured error."""
    n = sum(len(r['rows']) for r in rs)
    names = sorted({x for v in models.values() for x in v})
    zero = {x for x in names if all(R.column(r, x, t) == 0.0 for r in rs for t in r['rows'])}
    live = {m: [x for x in v if x not in zero] for m, v in models.items()}
    out = {'n': n, 'cultures': len(rs), 'zero_columns': sorted(zero)}
    fits = {}
    for m, v in live.items():
        cols, y = design(rs, v)
        fits[m] = R.ols(y, cols) if n - len(v) > 0 else None
    for key, (base, full) in R.COMPARISONS.items():
        fb, ff = fits[base], fits[full]
        added = [x for x in live[full] if x not in live[base]]
        out['x_' + key] = R.excess(fb and fb[1], ff and ff[1], n, len(live[base]), len(added))
        if out['x_' + key] is not None and key in ('H1', 'V2', 'W', 'lag'):
            bc, y = design(rs, live[base])
            ac, _ = design(rs, added)
            out['p_' + key] = R.robust_p(y, bc, ac)
    if fits.get('T2') is not None:
        beta = dict(zip(live['T2'], fits['T2'][0]))
        mean = {k: statistics.fmean(r['E'][t - j] for r in rs for t in r['rows'])
                for k, j in (('E', 0), ('E1', 1), ('E2', 2))}
        out['lag_effect'] = (beta.get('E2', 0.0) + 2 * beta.get('E2*E2', 0.0) * mean['E2']
                             + beta.get('E*E2', 0.0) * mean['E'] + beta.get('E1*E2', 0.0) * mean['E1'])
        signs = {}
        for name, (cel, cea, cpa) in R.FIELD.items():
            s = 0.0
            for r in rs:
                A, L = r['rawA'], [x * r['scale'] for x in r['L']]
                s += sum(math.exp(-cel * L[t - 2] - cea * A[t - 2] - cpa * A[t]) * (1 - cea * A[t - 2])
                         for t in r['rows'])
            signs[name] = 1 if s > 0 else -1 if s < 0 else 0
        out['rival_signs'] = signs
        out['rival_sign'] = signs['2001'] if len(set(signs.values())) == 1 else 0
    if rs and rs[0]['mu']:
        fl, bad = [], 0
        for r in rs:
            for t in r['rows']:
                g, p = r['G'][t] * r['scale'], r['P'][t] * r['scale']
                if g > p + 0.5 + 1e-6:
                    bad += 1
                if p > 0:
                    gg = min(max(g, 0.0), p)
                    fl.append(gg * (1 - gg / p) / r['scale'] ** 2)
        out['recruits_above_pupae'] = bad
        floor = statistics.fmean(fl) if fl else None
        if floor:
            for m in ('T2', 'RB'):
                if fits.get(m) is not None:
                    out['resid_over_floor_' + m] = fits[m][1] / n / floor
    return out


def left_out(cs, models=R.MODELS):
    """Each culture left out in turn: T2's lean law, the level alone and the rival's state fitted on the cell's other
    cultures (at their scale); the culture left out read at that scale; its one-step error on the next giving over its
    rows (T2's lean law and the rival's state), and its level forecast five steps ahead from every origin, the set loss
    known. None where a law cannot be fitted."""
    errs = {'M1': [], 'T2F': []}
    sq = {'T2F': [], 'RB': []}
    for k, held in enumerate(cs):
        train = [c for i, c in enumerate(cs) if i != k]
        if not train:
            return None
        s = scale_of(train)
        rs = [reading(c, s) for c in train]
        laws, live = {}, {}
        zero = {x for m in ('M1', 'T2F', 'RB') for x in models[m]
                if all(R.column(r, x, t) == 0.0 for r in rs for t in r['rows'])}
        for m in ('M1', 'T2F', 'RB'):
            live[m] = [x for x in models[m] if x not in zero]
            cols, y = design(rs, live[m])
            f = R.ols(y, cols) if len(y) > len(live[m]) else None
            if f is None:
                return None
            laws[m] = f[0]
        h = reading(held, s)
        for m in ('T2F', 'RB'):
            cols, y = design([h], live[m])
            sq[m] += [(v - sum(b * c[i] for b, c in zip(laws[m], cols))) ** 2 for i, v in enumerate(y)]
        A, E, mu = h['A'], h['E'], h['mu']
        T = len(A) - 1
        for t0 in range(ORIGIN, T - R.HORIZON + 1):
            for m in errs:
                hist = [E[t0 - 2], E[t0 - 1]]
                x = A[t0]
                for _ in range(R.HORIZON):
                    hist.append((1 - mu) * x)
                    x = max(hist[-1] + R.law_value(laws[m], live[m], hist), R.FLOOR)
                errs[m].append(abs(math.log(max(x, R.FLOOR) / max(A[t0 + R.HORIZON], R.FLOOR))))
    if not errs['M1'] or not sq['T2F']:
        return None
    return {'err': errs, 'mse_T2F': statistics.fmean(sq['T2F']), 'mse_RB': statistics.fmean(sq['RB'])}


def analyse(cultures, models=R.MODELS):
    """Every cell's numbers; a cell with fewer than CELL_MIN_ROWS rows is counted, not read."""
    per, short = [], 0
    for (st, mu), cs in cells(cultures).items():
        s = scale_of(cs)
        rs = [reading(c, s) for c in cs]
        if sum(len(r['rows']) for r in rs) < CELL_MIN_ROWS:
            short += 1
            continue
        per.append({'id': 'strain%s-loss%g' % (st, mu), 'strain': st, 'mu': mu, 'in': in_cell(rs, models),
                    'out': left_out(cs, models)})
    return per, short


def group_verdicts(cultures):
    """UE31's frozen verdicts (state_rules.combine), each cell a unit, read only where the reading and the counts
    agree with the protocol: recruits above the pupae by more than half an animal in at most PROTOCOL_SHARE of the
    rows."""
    per, short = analyse(cultures)
    res = R.combine(per, short)
    res['cells'] = res.pop('cultures')
    res['too_short_cells'] = res.pop('too_short')
    rows = sum(p['in']['n'] for p in per)
    above = sum(p['in'].get('recruits_above_pupae', 0) for p in per)
    res['protocol_rows'] = [above, rows]
    if rows and above > PROTOCOL_SHARE * rows:
        res['protocol'] = PROTOCOL_DISAGREES
        for k in VERDICTS:
            if k in res:
                res[k] = 'not read: ' + PROTOCOL_DISAGREES
    else:
        res['protocol'] = PROTOCOL_AGREES
    return res, per
