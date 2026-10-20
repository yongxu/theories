"""POST HOC (after MQ2's frozen verdicts; nothing here is a verdict). Three questions the failures
of S, S2, C1 and C2 raised:

P1  Does the daily growth map depend on the dilution factor at equal start density? Least squares
    of log(n_{t+1} / x) on a cubic in log x plus beta * log DF, over every live pair (x = n_t / DF,
    both readings > f) at all eight DFs with x < 10^-3 (low densities, where the need lies).
P2  A growth map whose low-density rate falls with the draw: the two-phase class with
    gl T = a - beta * ln(DF / 1000), fitted on the fit set only, scored on the held-out set by the
    frozen rules' quantities (held-out RMSE, needs against the empirical needs, levels).
P3  The salt-shock regime located by one measured number: the column's pre-shock level (median of
    days 2-4) gives the frozen map's effective dilution DF_eff with s(DF_eff) = that level; then
    need = u(DF_eff), and each population is predicted alive on day 9 iff its day-5 reading > need.

    python3 -I posthoc_mq2.py <bifurcation dir> <saltshock dir> <indicator dir>
"""

import json
import math
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))   # this study's code, not the data
import mq2  # noqa: E402


def p1(data):
    rows = []
    for df in mq2.ALL_DFS:
        for x, y in mq2.pairs_of(data, [df]):
            if y > mq2.FLOOR and x < 1e-3:
                rows.append((math.log(x), math.log(df), math.log(y / x)))
    m = sum(r[0] for r in rows) / len(rows)
    sd = math.sqrt(sum((r[0] - m) ** 2 for r in rows) / len(rows))
    X = [[1.0, (r[0] - m) / sd, ((r[0] - m) / sd) ** 2, ((r[0] - m) / sd) ** 3, r[1]] for r in rows]
    y = [r[2] for r in rows]
    from yeast_data import lstsq
    beta, rss = lstsq(X, y)
    # standard error of the log DF coefficient from (X'X)^-1
    k = len(X[0])
    A = [[sum(r[i] * r[j] for r in X) for j in range(k)] for i in range(k)]
    inv = [[float(i == j) for j in range(k)] for i in range(k)]
    for c in range(k):
        p = max(range(c, k), key=lambda r: abs(A[r][c]))
        A[c], A[p], inv[c], inv[p] = A[p], A[c], inv[p], inv[c]
        piv = A[c][c]
        A[c] = [v / piv for v in A[c]]
        inv[c] = [v / piv for v in inv[c]]
        for r in range(k):
            if r != c:
                f = A[r][c]
                A[r] = [a - f * b for a, b in zip(A[r], A[c])]
                inv[r] = [a - f * b for a, b in zip(inv[r], inv[c])]
    s2 = rss / (len(rows) - k)
    return dict(pairs=len(rows), beta_log_df=beta[4], se=math.sqrt(s2 * inv[4][4]),
                note="per-capita daily growth at equal start density scales as DF^beta")


def two_phase_df(theta):
    a, logb, lognc, logk, beta = theta
    return lambda df: mq2.two_phase([a - beta * math.log(df / 1000.0), logb, lognc, logk])


def p2(fit_data, held):
    pairs = [(x, y, df) for df in mq2.FIT_DFS for x, y in mq2.pairs_of(fit_data, [df])]

    def loss(th):
        try:
            Gd = two_phase_df(th)
            Gs = {df: Gd(df) for df in mq2.FIT_DFS}
            v = sum(mq2.resid(Gs[df], x, y) ** 2 for x, y, df in pairs)
        except (OverflowError, ValueError, ZeroDivisionError):
            return 1e18
        return v if math.isfinite(v) else 1e18
    f0 = json.load(open(os.path.join(mq2.OUT, "fit.json")))["models"]["two_phase"]["theta"]
    th, v = mq2.nelder_mead(loss, f0 + [0.0])
    th, v = mq2.nelder_mead(loss, th, step=0.05)
    Gd = two_phase_df(th)
    out = dict(theta=th, fit_rmse=math.sqrt(v / len(pairs)), by_df={})
    hp = 0.0
    n = 0
    for df in mq2.HELD_DFS:
        G = Gd(df)
        ps = mq2.pairs_of(held, [df])
        hp += mq2.sse(G, ps)
        n += len(ps)
        st = mq2.state(G, df)
        out["by_df"][df] = dict(need=st["need"], stable=st["stable"])
    out["held_rmse"] = math.sqrt(hp / n)
    # fold: largest DF with a positive state under the DF-dependent map
    lo, hi = 1000.0, 20000.0
    for _ in range(60):
        mid = math.sqrt(lo * hi)
        if mq2.state(Gd(mid), mid)["stable"] is not None:
            lo = mid
        else:
            hi = mid
    out["fold_df"] = lo
    for df in (250, 500, 750, 825):
        st = mq2.state(Gd(df), df)
        out["by_df"].setdefault(df, dict(need=st["need"], stable=st["stable"]))
    return out


def p3(salt_dir, st2_theta):
    G = mq2.two_phase(st2_theta)
    days = {d: mq2.read_matrix(os.path.join(salt_dir, f"saltshock_day{d}.txt")) for d in range(1, 10)}
    rows, preds, outs = {}, [], []
    for j, df in enumerate(mq2.SALT_DFS):
        pre = sorted(days[d][r][j] for d in (2, 3, 4) for r in range(8))
        level = pre[len(pre) // 2]
        lo, hi = 10.0, 20000.0           # s(DF) falls with DF: bisect for s(DF_eff) = level
        for _ in range(60):
            mid = math.sqrt(lo * hi)
            s = mq2.state(G, mid)["stable"]
            if s is not None and s > level:
                lo = mid
            else:
                hi = mid
        dfe = lo
        u = mq2.state(G, dfe)["need"]
        post = [days[5][r][j] for r in range(8)]
        fate = [days[9][r][j] > mq2.FLOOR for r in range(8)]
        pr = [p > u for p in post]
        preds += pr
        outs += fate
        rows[df] = dict(pre_level=level, df_eff=dfe, need=u, correct=sum(a == b for a, b in zip(pr, fate)))
    return dict(by_df=rows, accuracy=sum(a == b for a, b in zip(preds, outs)) / len(outs))


def main(bif, salt, ind):
    fitres = json.load(open(os.path.join(mq2.OUT, "fit.json")))
    data = mq2.read_bifurcation(bif, mq2.ALL_DFS)
    fit_data = {df: data[df] for df in mq2.FIT_DFS}
    held = {df: data[df] for df in mq2.HELD_DFS}
    res = dict(note="POST HOC, not a verdict", P1=p1(data), P2=p2(fit_data, held),
               P3=p3(salt, fitres["models"]["two_phase"]["theta"]))
    with open(os.path.join(mq2.OUT, "posthoc-mq2.json"), "w") as fh:
        json.dump(res, fh, indent=1)
    print(json.dumps(res, indent=1))


if __name__ == "__main__":
    main(*sys.argv[1:4])
