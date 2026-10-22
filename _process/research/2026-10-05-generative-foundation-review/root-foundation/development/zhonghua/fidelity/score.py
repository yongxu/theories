"""The fidelity count (FC1; FIDELITY.md §5 and ANALYSIS-PLAN.md): scores, reliability, comparisons and decisions.

Reads the two coders' answers (data/coded/{claude,codex}/{table,naive}_{calib,main}/*.json), recomputes every count
from their lists, forms the consensus (the mean of the two coders), and writes data/results_{SET}.json. Pure Python:
Krippendorff's α (interval, and nominal over spans matched with ≥50% overlap), a cluster bootstrap over 條 (10,000
resamples), the Wilcoxon signed-rank test (normal approximation, ties averaged, zeros dropped), McNemar's exact test,
and a Poisson rate ratio with cluster-robust (sandwich) errors over 條.

    python3 -I fidelity/score.py SET          # SET calib|main
"""
import json, math, random, sys
from collections import defaultdict
from pathlib import Path

HERE = Path(__file__).resolve().parent
DATA = HERE / 'data'
CODERS = ('claude', 'codex')
B = 10000


def load(name):
    return [json.loads(l) for l in open(DATA / name, encoding='utf-8')]


def codings(coder, pass_, which):
    out = {}
    for p in sorted((DATA / 'coded' / coder / ('%s_%s' % (pass_, which))).glob('*.json')):
        for s in json.loads(p.read_text())['segments']:
            out[s['seg_id']] = s
    return out


def n_binders(D, L):
    return sum(len(L[d]['binders']) for d in D if d in L)


def counts(c, D, L):
    exc, seen = [], set()
    for r in c['referents']:
        key = r['span'].strip()
        if key in seen:
            continue
        seen.add(key)
        exc.append(r)
    X = [r for r in exc if r['status'] == 'excess']
    m5 = [r for r in exc if r['status'] == 'matched' and r['rule'] == 'M5']
    O = len(set(o.strip() for o in c['omissions']))
    nb = n_binders(D, L)
    return {'X': len(X), 'X_A': sum(r['class'] == 'A' for r in X), 'X_R': sum(r['class'] == 'R' for r in X),
            'X_E': sum(r['class'] == 'E' for r in X), 'X_U0': len(X) + len(m5),
            'X_noneg': sum('neg' not in r['tags'] for r in X), 'O': O, 'O_rate': O / nb if nb else 0.0,
            'S': len(c['connective_mismatches']), 'P': len(c['predicate_excess']), 'refs': len(exc)}


# --- statistics -------------------------------------------------------------------------------------------------

def alpha_interval(units):
    """Krippendorff's α, interval metric; units: lists of values (≥2 per unit counted)."""
    vals = [v for u in units if len(u) >= 2 for v in u]
    n = len(vals)
    if n < 2:
        return None
    do = sum(sum((a - b) ** 2 for i, a in enumerate(u) for j, b in enumerate(u) if i != j) / (len(u) - 1)
             for u in units if len(u) >= 2) / n
    de = sum((a - b) ** 2 for i, a in enumerate(vals) for j, b in enumerate(vals) if i != j) / (n * (n - 1))
    return 1 - do / de if de else None


def alpha_nominal(pairs):
    vals = [v for p in pairs for v in p]
    n = len(vals)
    if n < 2:
        return None
    do = sum(2 * (a != b) for a, b in pairs) / n
    freq = defaultdict(int)
    for v in vals:
        freq[v] += 1
    de = sum(freq[a] * freq[b] for a in freq for b in freq if a != b) / (n * (n - 1))
    return 1 - do / de if de else None


def lcs(a, b):
    best = 0
    for i in range(len(a)):
        for j in range(len(b)):
            k = 0
            while i + k < len(a) and j + k < len(b) and a[i + k] == b[j + k]:
                k += 1
            best = max(best, k)
    return best


def span_pairs(ca, cb):
    """Referents of two coders matched by span (longest common substring ≥ 50% of the shorter span)."""
    lab = lambda r: r['class'] if r['status'] == 'excess' else 'matched'
    used, out = set(), []
    for ra in ca['referents']:
        best, bj = 0, None
        for j, rb in enumerate(cb['referents']):
            if j in used:
                continue
            s = min(len(ra['span']), len(rb['span'])) or 1
            o = lcs(ra['span'], rb['span']) / s
            if o >= 0.5 and o > best:
                best, bj = o, j
        if bj is not None:
            used.add(bj)
            out.append((lab(ra), lab(cb['referents'][bj])))
    return out, len(ca['referents']) - len(out), len(cb['referents']) - len(used)


def boot_ci(diffs, seed=20261022):
    if not diffs:
        return None
    rnd = random.Random(seed)
    n = len(diffs)
    ms = sorted(sum(diffs[rnd.randrange(n)] for _ in range(n)) / n for _ in range(B))
    return [ms[int(0.025 * B)], ms[int(0.975 * B) - 1]]


def wilcoxon(diffs):
    d = [x for x in diffs if x != 0]
    n = len(d)
    if n == 0:
        return {'n': 0, 'p': 1.0}
    order = sorted(range(n), key=lambda i: abs(d[i]))
    ranks = [0.0] * n
    i = 0
    ties = 0
    while i < n:
        j = i
        while j + 1 < n and abs(d[order[j + 1]]) == abs(d[order[i]]):
            j += 1
        r = (i + j) / 2 + 1
        for k in range(i, j + 1):
            ranks[order[k]] = r
        t = j - i + 1
        ties += t ** 3 - t
        i = j + 1
    w = sum(r for r, x in zip(ranks, d) if x > 0)
    mu = n * (n + 1) / 4
    sd = math.sqrt(n * (n + 1) * (2 * n + 1) / 24 - ties / 48)
    z = (w - mu - (0.5 if w > mu else -0.5)) / sd if sd else 0
    p = math.erfc(abs(z) / math.sqrt(2))
    return {'n': n, 'W_plus': w, 'z': z, 'p': p}


def mcnemar(b, c):
    n = b + c
    if n == 0:
        return {'b': b, 'c': c, 'p': 1.0}
    k = min(b, c)
    p = min(1.0, 2 * sum(math.comb(n, i) for i in range(k + 1)) / 2 ** n)
    return {'b': b, 'c': c, 'p': p}


def poisson_rr(rows):
    """rows: (cluster, zh(0/1), y). log μ = b0 + b1 zh; rate ratio exp(b1) with cluster-robust 95% CI."""
    y0 = [y for _, z, y in rows if z == 0]
    y1 = [y for _, z, y in rows if z == 1]
    m0, m1 = sum(y0) / len(y0), sum(y1) / len(y1)
    if m0 <= 0 or m1 <= 0:
        return {'rr': None, 'mean_en': m0, 'mean_zh': m1}
    mu = {0: m0, 1: m1}
    Bm = [[0.0, 0.0], [0.0, 0.0]]
    U = defaultdict(lambda: [0.0, 0.0])
    for cl, z, y in rows:
        x = (1.0, float(z))
        m = mu[z]
        for a in range(2):
            for b in range(2):
                Bm[a][b] += m * x[a] * x[b]
            U[cl][a] += x[a] * (y - m)
    M = [[sum(u[a] * u[b] for u in U.values()) for b in range(2)] for a in range(2)]
    det = Bm[0][0] * Bm[1][1] - Bm[0][1] * Bm[1][0]
    Bi = [[Bm[1][1] / det, -Bm[0][1] / det], [-Bm[1][0] / det, Bm[0][0] / det]]
    V = [[sum(Bi[a][k] * M[k][l] * Bi[l][b] for k in range(2) for l in range(2)) for b in range(2)] for a in range(2)]
    b1, se = math.log(m1 / m0), math.sqrt(V[1][1])
    return {'rr': m1 / m0, 'ci': [math.exp(b1 - 1.96 * se), math.exp(b1 + 1.96 * se)], 'mean_en': m0, 'mean_zh': m1}


def per_tiao(units, f):
    """Per-條 means of f(unit) (f returns None to skip)."""
    acc = defaultdict(list)
    for u in units:
        v = f(u)
        if v is not None:
            acc[u['tiao']].append(v)
    return {t: sum(v) / len(v) for t, v in acc.items()}


def compare(units, fz, fe, label):
    """Paired per-條 comparison of fz (zh side) against fe (en side)."""
    a, b = per_tiao(units, fz), per_tiao(units, fe)
    ts = sorted(set(a) & set(b))
    diffs = [a[t] - b[t] for t in ts]
    return {'label': label, 'n_tiao': len(ts), 'mean_zh': sum(a[t] for t in ts) / len(ts) if ts else None,
            'mean_en': sum(b[t] for t in ts) / len(ts) if ts else None,
            'mean_diff': sum(diffs) / len(diffs) if diffs else None, 'ci95': boot_ci(diffs),
            'wilcoxon': wilcoxon(diffs)}


def decide(ci, kind):
    if ci is None:
        return 'no data'
    lo, hi = ci
    if kind == 'lower':           # supported if below 0, refuted if above 0
        return 'refuted' if lo > 0 else ('supported' if hi < 0 else 'undecided')
    if kind == 'no_more':         # refuted if above 0, supported otherwise
        return 'refuted' if lo > 0 else 'supported'
    if kind == 'higher':
        return 'supported' if lo > 0 else ('refuted' if hi < 0 else 'undecided')


def main():
    which = sys.argv[1]
    L = {d['decl']: d for d in load('lean_table.jsonl')}
    S = {s['seg_id']: s for s in load('segments.jsonl')}
    units = [u for u in load('units.jsonl') if u['calibration'] == (which == 'calib')]
    C = {(c, p): codings(c, p, which) for c in CODERS for p in ('table', 'naive')}
    cnt = {}
    for (c, p), cod in C.items():
        for sid, x in cod.items():
            cnt[(c, p, sid)] = counts(x, S[sid]['D'], L)

    def val(coder, pass_, sid, key):
        if coder == 'consensus':
            v = [cnt.get((c, pass_, sid), {}).get(key) for c in CODERS]
            v = [x for x in v if x is not None]
            return sum(v) / len(v) if len(v) == len(CODERS) else None
        x = cnt.get((coder, pass_, sid))
        return x[key] if x else None

    res = {'set': which, 'units': len(units), 'tiao': len({u['tiao'] for u in units}),
           'coded_segments': {'%s/%s' % k: len(v) for k, v in C.items()}}
    # reliability
    rel = {}
    for pass_ in ('table', 'naive'):
        for lang in ('zh', 'en'):
            sids = [s for s in S if S[s]['lang'] == lang and all((c, pass_, s) in cnt for c in CODERS)]
            for key in ('X', 'O'):
                rel['%s/%s/%s' % (pass_, lang, key)] = {
                    'alpha': alpha_interval([[cnt[(c, pass_, s)][key] for c in CODERS] for s in sids]), 'n': len(sids)}
            sp, ua, ub = [], 0, 0
            for s in sids:
                p, a, b = span_pairs(C[('claude', pass_)][s], C[('codex', pass_)][s])
                sp += p
                ua += a
                ub += b
            rel['%s/%s/classes' % (pass_, lang)] = {'alpha_nominal': alpha_nominal(sp), 'matched_spans': len(sp),
                                                    'only_claude': ua, 'only_codex': ub}
    res['reliability'] = rel
    # comparisons
    comps = {}
    for coder in ('consensus',) + CODERS:
        cc = {}
        for key in ('X', 'X_A', 'X_R', 'X_E', 'O', 'O_rate', 'S', 'P', 'X_U0', 'X_noneg'):
            cc[key] = compare(units, lambda u, k=key: val(coder, 'table', u['jing'], k),
                              lambda u, k=key: val(coder, 'table', u['en'], k), '經 − E1, ' + key)
        cc['X_noreading'] = compare([u for u in units if not u['flags']['reading']],
                                    lambda u: val(coder, 'table', u['jing'], 'X'),
                                    lambda u: val(coder, 'table', u['en'], 'X'), '經 − E1, X, 條 without readings')

        def load_(u, side):
            a, b = val(coder, 'naive', u[side], 'X'), val(coder, 'table', u[side], 'X')
            return None if a is None or b is None else a - b
        cc['load'] = compare(units, lambda u: load_(u, 'jing'), lambda u: load_(u, 'en'), 'inherited-sense load')
        cc['naive_X'] = compare(units, lambda u: val(coder, 'naive', u['jing'], 'X'),
                                lambda u: val(coder, 'naive', u['en'], 'X'), '經 − E1, naive X')
        g = {}
        for name, zk, ek in (('jing_vs_enrec', 'jing', 'enrec'), ('zhrec_vs_enrec', 'zhrec', 'enrec'),
                             ('jing_vs_zhrec', 'jing', 'zhrec'), ('shuo_vs_en', 'shuo', 'en')):
            for key in ('X', 'O_rate'):
                g['%s/%s' % (name, key)] = compare(
                    [u for u in units if zk in u and ek in u],
                    lambda u, k=key, z=zk: val(coder, 'table', u[z], k),
                    lambda u, k=key, e=ek: val(coder, 'table', u[e], k), '%s − %s, %s' % (zk, ek, key))
        cc['genre'] = g
        comps[coder] = cc
    res['comparisons'] = comps
    # by 篇
    bp = {}
    for pian in sorted({u['pian'] for u in units}):
        bp[pian] = compare([u for u in units if u['pian'] == pian], lambda u: val('consensus', 'table', u['jing'], 'X'),
                           lambda u: val('consensus', 'table', u['en'], 'X'), pian)
    res['by_pian'] = bp
    # McNemar on X ≥ 1 over pairs, and the Poisson rate ratio
    b_ = c_ = 0
    rows = []
    for u in units:
        z, e = val('consensus', 'table', u['jing'], 'X'), val('consensus', 'table', u['en'], 'X')
        if z is None or e is None:
            continue
        b_ += (z >= 1) and not (e >= 1)
        c_ += (e >= 1) and not (z >= 1)
        rows += [(u['tiao'], 1, z), (u['tiao'], 0, e)]
    res['mcnemar_X_ge_1'] = mcnemar(b_, c_)
    res['poisson'] = poisson_rr(rows) if rows else None
    # X_anchor against coded X (Spearman), over table-pass segments
    xs = [(S[s]['x_anchor'], val('consensus', 'table', s, 'X')) for s in S if val('consensus', 'table', s, 'X') is not None]

    def rank(v):
        o = sorted(range(len(v)), key=lambda i: v[i])
        r = [0.0] * len(v)
        i = 0
        while i < len(v):
            j = i
            while j + 1 < len(v) and v[o[j + 1]] == v[o[i]]:
                j += 1
            for k in range(i, j + 1):
                r[o[k]] = (i + j) / 2
            i = j + 1
        return r
    if len(xs) > 2:
        ra, rb = rank([a for a, _ in xs]), rank([b for _, b in xs])
        ma, mb = sum(ra) / len(ra), sum(rb) / len(rb)
        num = sum((a - ma) * (b - mb) for a, b in zip(ra, rb))
        den = math.sqrt(sum((a - ma) ** 2 for a in ra) * sum((b - mb) ** 2 for b in rb))
        res['x_anchor_spearman'] = {'rho': num / den if den else None, 'n': len(xs)}
    cs = comps['consensus']
    dec = {'F1': decide(cs['X_A']['ci95'], 'lower'), 'F2': decide(cs['X']['ci95'], 'no_more'),
           'F4': decide(cs['load']['ci95'], 'higher')}
    if cs['X']['ci95'] and cs['X']['ci95'][1] < 0:
        gx, go = cs['genre']['jing_vs_enrec/X']['ci95'], cs['genre']['jing_vs_enrec/O_rate']['ci95']
        if gx and go and gx[1] < 0 and go[0] <= 0:
            dec['F3'] = 'supported'
        elif gx and go and gx[1] >= 0 and go[0] > 0:
            dec['F3'] = 'refuted'
        else:
            dec['F3'] = 'undecided'
    else:
        dec['F3'] = 'not read (F2 without a CI below 0)'
    res['decisions'] = dec
    (DATA / ('results_%s.json' % which)).write_text(json.dumps(res, ensure_ascii=False, indent=1))
    print(json.dumps({'decisions': dec, 'X': cs['X'], 'X_A': cs['X_A'], 'reliability': {k: v for k, v in rel.items() if k.startswith('table')}},
                     ensure_ascii=False, indent=1)[:3000])


if __name__ == '__main__':
    main()
