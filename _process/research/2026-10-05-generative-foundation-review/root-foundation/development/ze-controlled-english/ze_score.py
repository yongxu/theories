"""ZE step 4: the 經 against the controlled English (CE), scored as ANALYSIS-PLAN.md fixes, with FC1's functions.

Reads the Claude codings of the 經 and the E1 clauses from FC1 (fidelity/data/coded/claude/{table_main,core_claude,
table_calib}), the Claude codings of the CE segments (data/coded/claude/{ce_main,ce_calib}) and the GPT codings of the
sample (data/coded/codex/{gpt_zh,gpt_ce}); recomputes every count from the coders' lists with fidelity/score.py's
counts(); writes data/results.json.

    python3 -I -B ze_score.py
"""
import json, random, sys
from collections import defaultdict
from pathlib import Path

HERE = Path(__file__).resolve().parent
FID = HERE.parent / 'zhonghua' / 'fidelity'
DATA = HERE / 'data'
sys.path.insert(0, str(FID))
import score as F  # noqa: E402

KEYS = ('X', 'X_A', 'X_R', 'X_E', 'O', 'O_rate', 'S', 'P', 'X_U0', 'X_noneg')


def load(p):
    return [json.loads(l) for l in open(p, encoding='utf-8')]


def coded(dirs):
    out = {}
    for d in dirs:
        for p in sorted(d.glob('*.json')):
            for s in json.loads(p.read_text())['segments']:
                out[s['seg_id']] = s
    return out


def ratio_ci(units, fa, fb, fe, seed=20261023, B=10000):
    """Share of the 經's advantage over E1 that the CE recovers: mean(e − b) / mean(e − a) over 條, cluster bootstrap."""
    a, b, e = F.per_tiao(units, fa), F.per_tiao(units, fb), F.per_tiao(units, fe)
    ts = sorted(set(a) & set(b) & set(e))
    num = {t: e[t] - b[t] for t in ts}
    den = {t: e[t] - a[t] for t in ts}
    point = sum(num.values()) / sum(den.values()) if sum(den.values()) else None
    rnd, rs = random.Random(seed), []
    for _ in range(B):
        s = [ts[rnd.randrange(len(ts))] for _ in ts]
        d = sum(den[t] for t in s)
        if d > 0:
            rs.append(sum(num[t] for t in s) / d)
    rs.sort()
    return {'n_tiao': len(ts), 'share': point,
            'ci95': [rs[int(0.025 * len(rs))], rs[int(0.975 * len(rs)) - 1]] if rs else None, 'resamples_used': len(rs)}


def verdict(ci):
    if ci is None:
        return 'no data'
    if ci[1] < 0:
        return 'survives (經 below CE)'
    if ci[0] > 0:
        return 'reversed (CE below 經)'
    return 'does not survive (CI includes 0)'


def main():
    L = {d['decl']: d for d in F.load('lean_table.jsonl')}
    S = {s['seg_id']: s for s in F.load('segments.jsonl')}
    S.update({s['seg_id']: s for s in load(DATA / 'ce_segments.jsonl')})
    units = load(DATA / 'ce_units.jsonl')
    sample = json.loads((DATA / 'gpt_sample.json').read_text())['units']
    CL = coded([FID / 'data/coded/claude/table_main', FID / 'data/coded/claude/core_claude',
                FID / 'data/coded/claude/table_calib', DATA / 'coded/claude/ce_main', DATA / 'coded/claude/ce_calib'])
    GP = coded([DATA / 'coded/codex/gpt_zh', DATA / 'coded/codex/gpt_ce'])
    cnt = {'claude': {k: F.counts(v, S[k]['D'], L) for k, v in CL.items() if k in S},
           'gpt': {k: F.counts(v, S[k]['D'], L) for k, v in GP.items() if k in S}}

    def val(coder, side, key):
        return lambda u: (cnt[coder].get(u[side]) or {}).get(key)

    res = {'coded': {c: {kind: sum(1 for k in cnt[c] if S[k]['kind'] == kind) for kind in ('jing', 'ce', 'en')}
                     for c in cnt}}
    out = {}
    for which in ('main', 'calib'):
        us = [u for u in units if u['calibration'] == (which == 'calib')]
        missing = sorted({u['ce'] for u in us if u['ce'] not in cnt['claude']} | {u['jing'] for u in us if u['jing'] not in cnt['claude']})
        r = {'units': len(us), 'tiao': len({u['tiao'] for u in us}), 'missing_codings': missing[:20],
             'n_missing': len(missing)}
        r['jing_vs_ce'] = {k: F.compare(us, val('claude', 'jing', k), val('claude', 'ce', k), '經 − CE, ' + k) for k in KEYS}
        r['ce_vs_en'] = {k: F.compare(us, val('claude', 'ce', k), val('claude', 'en', k), 'CE − E1, ' + k) for k in KEYS}
        r['jing_vs_en'] = {k: F.compare(us, val('claude', 'jing', k), val('claude', 'en', k), '經 − E1, ' + k)
                           for k in ('X', 'X_A', 'O_rate')}
        r['share_recovered'] = ratio_ci(us, val('claude', 'jing', 'X'), val('claude', 'ce', 'X'), val('claude', 'en', 'X'))
        nr = [u for u in us if not u['flags']['reading']]
        r['jing_vs_ce_noreading'] = F.compare(nr, val('claude', 'jing', 'X'), val('claude', 'ce', 'X'), '經 − CE, X, no readings')
        if which == 'main':
            r['by_pian'] = {p: F.compare([u for u in us if u['pian'] == p], val('claude', 'jing', 'X'),
                                         val('claude', 'ce', 'X'), p) for p in sorted({u['pian'] for u in us})}
            b_ = c_ = 0
            rows = []
            for u in us:
                z, e = val('claude', 'jing', 'X')(u), val('claude', 'ce', 'X')(u)
                if z is None or e is None:
                    continue
                b_ += (z >= 1) and not (e >= 1)
                c_ += (e >= 1) and not (z >= 1)
                rows += [(u['tiao'], 1, z), (u['tiao'], 0, e)]
            r['mcnemar_X_ge_1'] = F.mcnemar(b_, c_)
            r['poisson_jing_over_ce'] = F.poisson_rr(rows) if rows else None
        out[which] = r
    res['claude'] = out
    # the GPT sample: one unit per sampled 經 segment
    su = [u for u in units if any(u['tiao'] == s['tiao'] and u['decl'] == s['decl'] for s in sample)]
    g = {'units': len(su), 'tiao': len({u['tiao'] for u in su})}
    for coder in ('gpt', 'claude'):
        g[coder] = {k: F.compare(su, val(coder, 'jing', k), val(coder, 'ce', k), '經 − CE, %s (%s)' % (k, coder))
                    for k in ('X', 'X_A', 'X_R', 'X_E', 'O_rate', 'S', 'P')}
    g['mean'] = {}
    for k in ('X', 'O_rate'):
        def mv(side, k=k):
            def f(u):
                v = [cnt[c].get(u[side], {}).get(k) for c in ('claude', 'gpt')]
                return None if None in v else sum(v) / 2
            return f
        g['mean'][k] = F.compare(su, mv('jing'), mv('ce'), '經 − CE, %s (mean of coders)' % k)
    rel = {}
    for side in ('jing', 'ce'):
        sids = sorted({u[side] for u in su if u[side] in cnt['gpt'] and u[side] in cnt['claude']})
        rel[side] = {'n': len(sids)}
        for k in ('X', 'O'):
            rel[side]['alpha_' + k] = F.alpha_interval([[cnt[c][s][k] for c in ('claude', 'gpt')] for s in sids])
        rel[side]['mean_X'] = {c: (sum(cnt[c][s]['X'] for s in sids) / len(sids) if sids else None) for c in ('claude', 'gpt')}
    g['reliability'] = rel
    res['gpt_sample'] = g
    m = out['main']
    res['decisions'] = {
        'primary (Claude, main set, X)': verdict(m['jing_vs_ce']['X']['ci95']),
        'X_A (Claude, main)': verdict(m['jing_vs_ce']['X_A']['ci95']),
        'cross-family (GPT, sample, X)': verdict(g['gpt']['X']['ci95']),
        'Claude on the sample, X': verdict(g['claude']['X']['ci95']),
        'discipline in English (CE − E1, Claude, main, X)': ('CE below E1' if m['ce_vs_en']['X']['ci95'] and m['ce_vs_en']['X']['ci95'][1] < 0
                                                              else 'CE not below E1')}
    (DATA / 'results.json').write_text(json.dumps(res, ensure_ascii=False, indent=1))
    show = {'decisions': res['decisions'], 'coded': res['coded'],
            'main 經−CE X': m['jing_vs_ce']['X'], 'main CE−E1 X': m['ce_vs_en']['X'], 'share': m['share_recovered'],
            'gpt X': g['gpt']['X'], 'gpt claude X': g['claude']['X'], 'rel': rel}
    print(json.dumps(show, ensure_ascii=False, indent=1)[:4000])


if __name__ == '__main__':
    main()
