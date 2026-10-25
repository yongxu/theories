"""Exact values of LA3 (computed before the freeze; no model).

    python3 values.py      # writes results/values.json

For each condition: the expected score of each choice (Z0 times the product of the means), the two
sides of `stretch_iff`'s inequality, and the class it gives.  The expected scores compare exactly as
the inequality's sides do: S's expected score is Z0 (a+p)^m (a+s+p)^n and N's is Z0 (a+c+p)^(m+n),
so S's is at least N's exactly where the shapers' share does not fall across the stretch, and above it
exactly where the share rises strictly (`stretch_iff`, `stretch_lt_iff`; at a step, m = 0, the
inequality is c <= s, `favours_iff`).

The same arithmetic first reproduces the numbers of MA3's Lean witnesses (`Split`, `SharedFlips`,
`Timing`), so the classes here are computed as the Lean statements compute them.
"""

import json
import os

from game import CONDITIONS, G, Z0, expected

HERE = os.path.dirname(os.path.abspath(__file__))


def shaped(a, s, p, c):
    """`RuleShaping.shaped`: (offspring of each shaper, offspring of each other)."""
    return (a + s + p, a + c + p)


def select(x, g):
    """`CarrierCounts.select`: each carrier leaves g[0], each other g[1]."""
    return (x[0] * g[0], x[1] * g[1])


def le(x, y):
    """`CarrierCounts.order.le`: the carriers stand to the others in y at least as in x."""
    return x[0] * y[1] <= y[0] * x[1]


def lt(x, y):
    return x[0] * y[1] < y[0] * x[1]


def sides(a, s, p, c, m, n):
    """The two sides of `stretch_iff`: (a+c+p)^m (a+c+p)^n and (a+p)^m (a+s+p)^n."""
    return (a + c + p) ** m * (a + c + p) ** n, (a + p) ** m * (a + s + p) ** n


def stretch(x, a, s, p, c, m, n):
    """The run of m steps of shaped a 0 p c and then n steps of shaped a s p c from x."""
    for _ in range(m):
        x = select(x, shaped(a, 0, p, c))
    for _ in range(n):
        x = select(x, shaped(a, s, p, c))
    return x


def check_witnesses():
    """The numbers of `Becoming.RuleShaping`'s witnesses, recomputed."""
    even = (1, 1)
    out = {}
    g = shaped(1, 2, 3, 1)
    assert g == (6, 5) and g[1] <= g[0]                     # Split.favours
    assert lt(even, select(even, g))                        # Split.rises
    h = shaped(1, 0, 5, 1)
    assert h == (6, 7) and not h[1] <= h[0]                 # Split.shared_disfavours
    assert lt(select(even, h), even)                        # Split.falls
    out["Split"] = dict(kept=g, shared=h)
    for p, rises in ((0, False), (1, True)):                # SharedFlips: a = 1, c = 1, s = 2, m = 2, n = 3
        lhs, rhs = sides(1, 2, p, 1, 2, 3)
        assert (lhs <= rhs) == rises and (lhs < rhs) == rises
        x = stretch(even, 1, 2, p, 1, 2, 3)
        assert le(even, x) == rises and lt(even, x) == rises
        out[f"SharedFlips_p{p}"] = dict(sides=(lhs, rhs), rises=rises)
    for name, m, n, rises in (("soon_rises", 1, 2, True), ("late_falls", 2, 2, False),
                              ("shorter_falls", 1, 1, False), ("seven_falls", 5, 7, False),
                              ("eight_rises", 5, 8, True)):   # Timing: a = 2, c = 1, s = 2, p = 0
        lhs, rhs = sides(2, 2, 0, 1, m, n)
        assert (lhs < rhs) == rises and (lhs <= rhs) == rises
        out["Timing." + name] = dict(m=m, n=n, sides=(lhs, rhs), rises=rises)
    return out


def main():
    out = dict(Z0=Z0, G=G, witnesses=check_witnesses(), conditions={})
    for name, c in CONDITIONS.items():
        a, s, p, cost, m = c["a"], c["s"], c["p"], c["c"], c["m"]
        n = G - m
        lhs, rhs = sides(a, s, p, cost, m, n)
        eS, eN = expected(c, "S"), expected(c, "N")
        assert eS == Z0 * rhs and eN == Z0 * lhs
        x = stretch((1, 1), a, s, p, cost, m, n)
        assert le((1, 1), x) == (lhs <= rhs) and lt((1, 1), x) == (lhs < rhs)
        if m == 0:   # three steps under one rule: the class is the one-step class (c <= s), cubes being monotone
            assert (lhs <= rhs) == (cost <= s) and (lhs < rhs) == (cost < s)
        cls = "rises" if lhs < rhs else ("falls" if lhs > rhs else "even")
        out["conditions"][name] = dict(
            a=a, s=s, p=p, c=cost, m=m, n=n, step_rule_with_return=shaped(a, s, p, cost),
            step_rule_before_return=shaped(a, 0, p, cost), stretch_sides=(lhs, rhs), cls=cls,
            predicted="S" if cls == "rises" else "N", expected_S=eS, expected_N=eN,
            ratio_S_to_N=eS / eN)
        print(f"{name:8} a={a} s={s} p={p} c={cost} m={m} n={n}: sides {lhs} vs {rhs} -> {cls:5} "
              f"E[S]={eS:>7} E[N]={eN:>7} S/N={eS / eN:.3f}")
    os.makedirs(os.path.join(HERE, "results"), exist_ok=True)
    json.dump(out, open(os.path.join(HERE, "results", "values.json"), "w"), indent=1)


if __name__ == "__main__":
    main()
