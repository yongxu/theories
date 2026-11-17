#!/usr/bin/env python3
"""D5 refuter. AI-written (Claude Fable 5.2), 17 November 2026. Integers only.

D5: "Under balance, on one condition, a unit that takes h and gives b <= h back to the same
condition across the same step leaves the level as a unit taking h - b does."

Gross way  : units (h_i, b_i), each takes h_i and gives b_i back.
Net way    : units (h_i - b_i, 0).

Five readings of "a step" on one condition at level x, with an optional named source giving s:

 S0  Flow.Balances as defined (Flow.lean:278): next + taken = level + given, no order inside the
     step.  next exists iff taken <= level + given.
 S1  RegimeMargin.step reading (RegimeMargin.lean:249) with a level-dependent giving g:
     next = (x - H) + g(x - H), truncated subtraction, the units' own giving-back added after:
     gross: (x - sum h) + g(x - sum h) + sum b      net: (x - sum(h-b)) + g(x - sum(h-b))
 S2  S1 with g constant (the source gives s whatever the level): isolates the truncation.
 S3  Takers in order, each takes h only if h is there at its turn (else it is unmet and takes and
     gives nothing); giving back lands (a) at once, (b) at the end of the step.
 S4  A need threshold m read on the level: (a) at the start of the step (LineOnAStock.after reads
     need u <= x before anything is taken), (b) after the takes and before the giving back.

Also the package's own counts under S0: takers, renewers, uptake, replenishment (Flow.lean:305-319).
"""
from itertools import product

def hump10(z):            # LineOnAStock.hump10 (LineOnAStock.lean:1466), min z (10 - z), truncated
    return min(z, max(10 - z, 0))

def monus(a, b):
    return a - b if a >= b else 0

def sign(n):
    return 1 if n > 0 else 0

UNITS = [(h, b) for h in range(0, 5) for b in range(0, h + 1)]

def ways(maxlen):
    for n in range(1, maxlen + 1):
        for w in product(UNITS, repeat=n):
            yield w

def s0(x, s, w):
    taken = sum(h for h, _ in w); given = s + sum(b for _, b in w)
    if taken > x + given:
        return None
    return x + given - taken

def report(name, total, diff, first):
    print(f"{name}: cases {total}, gross != net in {diff}" + (f"; first: {first}" if first else ""))

def main():
    # ---- S0: level, feasibility, and the package's counts
    tot = d_level = d_feas = d_takers = d_renewers = d_uptake = d_repl = 0
    ex_counts = None
    for x in range(0, 7):
        for s in range(0, 3):
            for w in ways(3):
                net = tuple((h - b, 0) for h, b in w)
                a, c = s0(x, s, w), s0(x, s, net)
                tot += 1
                if (a is None) != (c is None): d_feas += 1
                elif a != c: d_level += 1
                tk = (sum(sign(h) for h, _ in w), sum(sign(h) for h, _ in net))
                rn = (sum(sign(b) for _, b in w), 0)
                up = (sum(h for h, _ in w), sum(h for h, _ in net))
                rp = (s + sum(b for _, b in w), s)
                d_takers += tk[0] != tk[1]; d_renewers += rn[0] != rn[1]
                d_uptake += up[0] != up[1]; d_repl += rp[0] != rp[1]
                if ex_counts is None and tk[0] != tk[1]:
                    ex_counts = (x, s, w, 'takers gross/net', tk, 'renewers', rn)
    print(f"S0 Flow.Balances: cases {tot}; level differs {d_level}; feasibility differs {d_feas}")
    print(f"   package counts differ: takers {d_takers}, renewers {d_renewers}, uptake {d_uptake}, "
          f"replenishment {d_repl}; first takers example {ex_counts}")
    # the Cycle witness (Flow.lean:983-1029) in net form: t units, each takes 1 gives 1, level 1
    for t in (1, 5, 50):
        w = tuple((1, 1) for _ in range(t))
        print(f"   Cycle at t={t}: gross takers {t}, net takers 0; level next gross {s0(1,0,w)}, "
              f"net {s0(1,0,tuple((0,0) for _ in w))}")

    # ---- S1: RegimeMargin.step with hump10, giving back added after
    tot = diff = 0; first = None; d_trunc = d_g = 0
    for x in range(0, 11):
        for w in ways(3):
            H = sum(h for h, _ in w); B = sum(b for _, b in w)
            gross = monus(x, H) + hump10(monus(x, H)) + B
            net = monus(x, H - B) + hump10(monus(x, H - B))
            tot += 1
            if gross != net:
                diff += 1
                if H > x: d_trunc += 1
                else: d_g += 1
                if first is None and H <= x: first = dict(x=x, way=w, gross=gross, net=net)
    report("S1 step with hump10", tot, diff, first)
    print(f"   of these: overdrawn (sum h > x) {d_trunc}; not overdrawn, g read at a lower level {d_g}")

    # ---- S2: constant source
    tot = diff = 0; first = None; d_not_over = 0
    for x in range(0, 9):
        for s in range(0, 3):
            for w in ways(3):
                H = sum(h for h, _ in w); B = sum(b for _, b in w)
                gross = monus(x, H) + s + B
                net = monus(x, H - B) + s
                tot += 1
                if gross != net:
                    diff += 1
                    if H <= x: d_not_over += 1
                    if first is None: first = dict(x=x, s=s, way=w, gross=gross, net=net)
    report("S2 step with constant source", tot, diff, first)
    print(f"   differing cases with sum h <= x: {d_not_over} (so the difference is the truncation alone)")

    # ---- S3: takers in order
    def seq(x, w, at_once):
        lvl = x; pend = 0; met = []
        for h, b in w:
            if h <= lvl:
                lvl -= h; met.append(True)
                if at_once: lvl += b
                else: pend += b
            else:
                met.append(False)
        return lvl + pend, tuple(met)
    for at_once in (True, False):
        tot = d_lvl = d_met = 0; first = None; d_perm = 0
        for x in range(0, 7):
            for w in ways(3):
                net = tuple((h - b, 0) for h, b in w)
                g, n = seq(x, w, at_once), seq(x, net, at_once)
                tot += 1
                if g[0] != n[0]: d_lvl += 1
                if g[1] != n[1]:
                    d_met += 1
                    if first is None: first = dict(x=x, way=w, gross=g, net=n)
                if seq(x, tuple(reversed(w)), at_once)[0] != g[0]: d_perm += 1
        print(f"S3 takers in order, giving back {'at once' if at_once else 'at the end'}: cases {tot}; "
              f"level differs {d_lvl}; who is met differs {d_met}; first {first}; "
              f"gross level depends on the order in {d_perm}")

    # ---- S4: need threshold
    tot = d_a = d_b = 0; first = None
    for x in range(0, 7):
        for m in range(1, 7):
            for w in ways(2):
                H = sum(h for h, _ in w); B = sum(b for _, b in w)
                if H > x: continue
                tot += 1
                # (a) read at the start: same x both ways
                # (b) read after the takes, before the giving back
                gb = (m <= x - H); nb = (m <= x - (H - B))
                if gb != nb:
                    d_b += 1
                    if first is None: first = dict(x=x, need=m, way=w, gross_met=gb, net_met=nb)
    print(f"S4 need read at the start: differs 0 of {tot} (same level, same reading); "
          f"read after the takes and before the giving back: differs {d_b}; first {first}")

if __name__ == "__main__":
    main()
