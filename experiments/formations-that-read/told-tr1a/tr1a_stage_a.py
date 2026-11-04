"""TR1's Stage A (REST-TR1 section 10; FREEZE-10.md, section 9): small choosers trained on the met menus of
D5q under a hidden strict order, then read on all 70 presentations by FREEZE-5's rule, unchanged.

    python3 -B tr1a_stage_a.py run          # Ren's yes: about a minute or two of one core; writes results/stage-a.json

Three classes of chooser, each a softmax over the listed options of a score:
  - item-score: one number per content (one order by construction: the positive control, for which the
    cycle rule is only an implementation check);
  - pairwise comparator, conjunctive: one number per unordered pair of contents, antisymmetric, a
    content's score in a menu the sum over the others listed (a pair never trained keeps its start);
  - set-input network: a content's score from a hidden layer reading the content and the menu's mean,
    so a content's score can change with what else is listed.
Each is trained by gradient descent on the six met presentations (the met pairs in both orders), its
label the hidden order's top, from a seeded start; SEEDS seeds a cell. The hidden order, a choice of this
freeze's, puts the met pairs in a chain, 0 above 1 above 2 above 3 or the reverse, with content 4, never
met, at one of five ranks: ten orders, each SEEDS / 10 times a cell, so the met labels' reach joins every
pair of 0 to 3 and P1 reads transitive inference on (0, 2), (1, 3) and (0, 3), and the pairs with content 4
are unjoined. The negative control trains on labels that carry no order by their making: each met
presentation's label drawn from its menu by a seeded draw, the same labels for every class at a seed (by
chance a draw can still accord with an order). It shows what each class's reading is when there is no
order to learn: a class whose no-order cells read as its order cells do is read by its form, not its
training. Each trained chooser is read as a pin is, but on its exact choice probabilities (read): a
presentation's pick strict where Q of R_CALLS draws would name it with chance at least one half, then
tr1_rule.condition_verdict, FREEZE-5's, on them (the cycle rule, the void floor, P1). Read apart,
descriptive: on each pair the met labels do not join, the chance of the content the hidden order ranks
higher, averaged over the seeds, the class's bias there (not defined where the labels carry no order).

Nothing here runs a model or a download. The run is machine time, Ren's: `run` refuses unless the frozen
files are as committed and refuses to write over a result. The dry run trains no comparator and no
set-input network on any seed (it checks their gradients at the start only) and trains the item-score
class on its own seeds, so no outcome of the two classes the reading is about is seen before the run.
"""

import json
import math
import random
import sys
from collections import Counter

import tr1a_design as D           # first: the paths, freeze 1's harness and FREEZE-5's folder checked
import tr1_rule as TR1            # FREEZE-5's rule, unchanged
import tr1

D.own_files()

DESIGN = D.D1.DESIGN
R_CALLS, Q = D.R_CALLS, D.Q
N = DESIGN.n
MET = [p for p in range(len(DESIGN.pres)) if DESIGN.met[p]]
assert len(MET) == 6 and all(DESIGN.size[p] == 2 for p in MET)
SEEDS = 20                       # per cell (REST-TR1 section 10: 20 or more)
EPOCHS = 3000                    # full-batch steps
LR = 0.5
INIT_SD = 0.5
HIDDEN = 8                       # the set-input network's hidden units
CLASSES = ("item-score", "comparator", "set-input")
LABELS = ("order", "no order")
CHAIN = [0, 1, 2, 3]
ORDERS = [(d, k) for d in ("down", "up") for k in range(5)]    # the ten hidden orders: direction, content 4's rank
assert SEEDS % len(ORDERS) == 0


def hidden_rank(order):
    """{content: rank}, higher above, for a hidden order (direction, content 4's place among five ranks):
    the chain 0 above 1 above 2 above 3 ("down"), or its reverse ("up"), and content 4 at place k from
    the top."""
    d, k = order
    chain = CHAIN if d == "down" else CHAIN[::-1]
    top_down = chain[:k] + [4] + chain[k:]
    return {c: N - 1 - i for i, c in enumerate(top_down)}


def labels_of(labels, order, seed_key):
    """{met presentation: the content labelled}: the hidden order's top, or, with no order, a seeded draw
    from the menu."""
    rank = hidden_rank(order)
    rng = random.Random(f"{D.SEED}|stage-a|labels|{seed_key}")
    out = {}
    for p in MET:
        menu = DESIGN.pres[p]
        out[p] = max(menu, key=lambda c: rank[c]) if labels == "order" else rng.choice(menu)
    return out


def softmax(z):
    m = max(z)
    e = [math.exp(v - m) for v in z]
    t = sum(e)
    return [v / t for v in e]


class ItemScore:
    def __init__(self, rng):
        self.s = [rng.gauss(0, INIT_SD) for _ in range(N)]

    def params(self):
        return [self.s]

    def scores(self, menu):
        return [self.s[c] for c in menu]

    def grads(self, menu, d):       # d: dLoss/dscore per listed option
        g = [0.0] * N
        for c, v in zip(menu, d):
            g[c] += v
        return [g]


class Comparator:
    """A[x][y] = a[pair] for x < y, -a[pair] for x > y; a content's score in a menu, sum over the others."""
    PAIRS = [(i, j) for i in range(N) for j in range(i + 1, N)]

    def __init__(self, rng):
        self.a = [rng.gauss(0, INIT_SD) for _ in self.PAIRS]
        self.k = {p: i for i, p in enumerate(self.PAIRS)}

    def params(self):
        return [self.a]

    def A(self, x, y):
        return self.a[self.k[(x, y)]] if x < y else -self.a[self.k[(y, x)]]

    def scores(self, menu):
        return [sum(self.A(x, y) for y in menu if y != x) for x in menu]

    def grads(self, menu, d):
        g = [0.0] * len(self.PAIRS)
        for x, v in zip(menu, d):
            for y in menu:
                if y != x:
                    if x < y:
                        g[self.k[(x, y)]] += v
                    else:
                        g[self.k[(y, x)]] -= v
        return [g]


class SetInput:
    """h_i = tanh(W1[:, c_i] + W2 m + b), m the menu's mean of one-hot contents; score_i = v . h_i."""

    def __init__(self, rng):
        g = lambda: rng.gauss(0, INIT_SD)
        self.W1 = [g() for _ in range(HIDDEN * N)]
        self.W2 = [g() for _ in range(HIDDEN * N)]
        self.b = [g() for _ in range(HIDDEN)]
        self.v = [g() for _ in range(HIDDEN)]

    def params(self):
        return [self.W1, self.W2, self.b, self.v]

    def _h(self, menu):
        m = [0.0] * N
        for c in menu:
            m[c] += 1 / len(menu)
        hs = []
        for c in menu:
            hs.append([math.tanh(self.W1[u * N + c] + sum(self.W2[u * N + j] * m[j] for j in range(N)) + self.b[u])
                       for u in range(HIDDEN)])
        return m, hs

    def scores(self, menu):
        _, hs = self._h(menu)
        return [sum(self.v[u] * h[u] for u in range(HIDDEN)) for h in hs]

    def grads(self, menu, d):
        m, hs = self._h(menu)
        gW1, gW2, gb, gv = [0.0] * (HIDDEN * N), [0.0] * (HIDDEN * N), [0.0] * HIDDEN, [0.0] * HIDDEN
        for c, h, dv in zip(menu, hs, d):
            for u in range(HIDDEN):
                gv[u] += dv * h[u]
                dz = dv * self.v[u] * (1 - h[u] ** 2)
                gW1[u * N + c] += dz
                gb[u] += dz
                for j in range(N):
                    gW2[u * N + j] += dz * m[j]
        return [gW1, gW2, gb, gv]


KIND = {"item-score": ItemScore, "comparator": Comparator, "set-input": SetInput}


def loss_and_grads(model, data):
    """Mean cross-entropy over the met presentations ({p: content labelled}) and its gradients."""
    loss, total = 0.0, None
    for p, y in data.items():
        menu = DESIGN.pres[p]
        pr = softmax(model.scores(menu))
        loss -= math.log(pr[menu.index(y)])
        d = [(pr[i] - (1.0 if c == y else 0.0)) / len(data) for i, c in enumerate(menu)]
        g = model.grads(menu, d)
        total = g if total is None else [[a + b for a, b in zip(ga, gb)] for ga, gb in zip(total, g)]
    return loss / len(data), total


def train(kind, labels, seed, epochs=EPOCHS):
    """A chooser of the class trained on the met presentations from its seeded start: returns the model,
    its hidden order, the labels, and its loss at the start and the end."""
    order = ORDERS[seed % len(ORDERS)]
    data = labels_of(labels, order, f"{labels}|{seed}")     # the same labels for every class at a seed
    model = KIND[kind](random.Random(f"{D.SEED}|stage-a|start|{kind}|{labels}|{seed}"))
    first = None
    for _ in range(epochs):
        loss, g = loss_and_grads(model, data)
        first = loss if first is None else first
        for P, G in zip(model.params(), g):
            for i in range(len(P)):
                P[i] -= LR * G[i]
    end, _ = loss_and_grads(model, data)
    return {"model": model, "order": order, "labels": data, "loss_start": first if first is not None else end,
            "loss_end": end}


NOT_STRICT = "not strict (read exactly)"


def strict_chance(p):
    """The chance that at least Q of R_CALLS independent draws name an option drawn with chance p."""
    return sum(math.comb(R_CALLS, k) * p ** k * (1 - p) ** (R_CALLS - k) for k in range(Q, R_CALLS + 1))


def read(model):
    """A trained chooser read as a pin is, on its exact choice probabilities rather than on draws: a
    presentation's pick is strict where at least Q of R_CALLS draws from the chooser would name it with
    chance at least one half (so only an option drawn with chance above about 0.82 can be strict, and an
    exact tie never is), its answers then R_CALLS times that option, else R_CALLS answers naming none;
    then FREEZE-5's condition_verdict on them. Returns the verdict and each presentation's probabilities.
    Draws would make a near tie strict either way by chance (FREEZE-10, section 12), which no rule here
    should read as the class's."""
    answers, probs = {}, {}
    for p, menu in enumerate(DESIGN.pres):
        pr = softmax(model.scores(menu))
        probs[p] = pr
        top = [c for c, v in zip(menu, pr) if strict_chance(v) >= 0.5]
        assert len(top) <= 1
        answers[p] = [top[0]] * R_CALLS if top else [NOT_STRICT] * R_CALLS
    return TR1.condition_verdict("T", answers), probs


def unjoined_bias(order, probs, labels, kind_of_labels):
    """On each pair of contents the met labels' reach does not join, the chance, averaged over its two
    presentations, that the chooser picks the content the hidden order ranks higher (descriptive). Not
    defined where the labels carry no order, the hidden order then playing no part in them."""
    if kind_of_labels != "order":
        return None
    rank = hidden_rank(order)
    occ = [((1 << DESIGN.pres[p][0]) | (1 << DESIGN.pres[p][1]), labels[p]) for p in MET]
    reach = tr1.closure(tr1.shown(occ, N))
    out = {}
    for p, menu in enumerate(DESIGN.pres):
        if DESIGN.size[p] != 2:
            continue
        x, y = menu
        if reach[x] >> y & 1 or reach[y] >> x & 1:
            continue
        hi = x if rank[x] > rank[y] else y
        out.setdefault("%d-%d" % tuple(sorted(menu)), []).append(probs[p][menu.index(hi)])
    return {k: round(sum(v) / len(v), 4) for k, v in sorted(out.items())}


def run_cell(kind, labels, seeds=range(SEEDS)):
    rows = []
    for seed in seeds:
        t = train(kind, labels, seed)
        v, probs = read(t["model"])
        rows.append({"seed": seed, "hidden order": list(t["order"]), "loss_start": round(t["loss_start"], 6),
                     "loss_end": round(t["loss_end"], 6), "outcome": v["outcome"], "why": v["why"], "P1": v["P1"],
                     "strict": v["strict"], "P1_testable": v["P1_testable"], "shortest_cycle": v["shortest_cycle"],
                     "unjoined": unjoined_bias(t["order"], probs, t["labels"], labels)})
    return rows


def class_reading(rows):
    """A cell's reading: contradicted where any seed's chooser is (the seeds named), passed where every
    seed not void passed and at most half are void, void otherwise; with the counts, P1's, and the mean
    share on unjoined pairs of the content ranked higher."""
    n = Counter(r["outcome"] for r in rows)
    bad = [r["seed"] for r in rows if r["outcome"] == "contradicted"]
    if bad:
        out = "contradicted"
    elif n.get("void", 0) * 2 <= len(rows):
        out = "passed"
    else:
        out = "void"
    shares = [s for r in rows if r["unjoined"] for s in r["unjoined"].values()]
    return {"outcome": out, "seeds contradicted": bad, "counts": dict(sorted(n.items())),
            "P1 contradicted": sum(r["P1"] is True for r in rows), "P1 read": sum(r["P1"] is not None for r in rows),
            "mean share, on unjoined pairs, of the content ranked higher":
                round(sum(shares) / len(shares), 4) if shares else None}


def expectations(cells):
    """FREEZE-10 section 13's expectation for Stage A, as code: the item-score class trained on the order
    is contradicted on no seed, and P1 contradicted on none (an implementation check: it is one order by
    construction). False marks Stage A's pipeline as failed, and nothing else in it is read."""
    rows = cells[("item-score", "order")]["seeds"]
    return {"item-score on the order: no seed contradicted and P1 contradicted on none":
            all(r["outcome"] != "contradicted" and r["P1"] is not True for r in rows)}


def stage_a():
    cells = {}
    for kind in CLASSES:
        for labels in LABELS:
            rows = run_cell(kind, labels)
            cells[(kind, labels)] = {"seeds": rows, "reading": class_reading(rows)}
    return cells


def main(argv=None):
    argv = sys.argv[1:] if argv is None else argv
    if argv != ["run"]:
        raise SystemExit("usage: python3 -B tr1a_stage_a.py run  (Ren's yes: machine time)")
    import tr1a_run as RUN
    fc = RUN.frozen()
    out = D.HERE / "results" / "stage-a.json"
    if out.exists():
        raise SystemExit(f"{out.name} exists: Stage A has run, and its result is kept (FREEZE-10.md, section 9); nothing was done")
    cells = stage_a()
    res = {"test": "tr1a Stage A", "seed": D.SEED, "link": fc["link"], "freeze_commit": fc["freeze_commit"],
           "head": fc["head"], "hashes": fc["hashes"], "seeds": SEEDS, "epochs": EPOCHS,
           "cells": {f"{k} | {l}": v for (k, l), v in cells.items()}, "expectation": expectations(cells)}
    out.parent.mkdir(parents=True, exist_ok=True)
    RUN.write_whole(out, json.dumps(res, indent=1) + "\n")
    for (k, l), v in cells.items():
        print(f"{k:11s} {l:9s} {v['reading']['outcome']:13s} {v['reading']['counts']} P1 contradicted "
              f"{v['reading']['P1 contradicted']} of {v['reading']['P1 read']} read")
    print(res["expectation"])


if __name__ == "__main__":
    main()
