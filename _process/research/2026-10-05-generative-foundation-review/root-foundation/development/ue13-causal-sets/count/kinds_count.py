"""UE13: the kinds of next birth (the births up to relabelling) of every causal set of one to five elements, by
brute force. A computation, not a law: it is not proved in Lean. For each naturally labelled strict order up to
relabelling it prints its pairs, its stems (the pasts a new element can be born with) and its kinds of birth
(the children up to isomorphism). The counts of causal sets up to relabelling, 1, 2, 5, 16 and 63, are the known
counts of finite orders. usage: python3 -I kinds_count.py > kinds_count.txt"""
import itertools


def closure(n, rel):
    r = set(rel)
    changed = True
    while changed:
        changed = False
        for (a, b) in list(r):
            for (c, d) in list(r):
                if b == c and (a, d) not in r:
                    r.add((a, d)); changed = True
    return frozenset(r)


def posets(n):
    """Naturally labelled strict orders on 0..n-1 (i < j for every pair), as frozensets of pairs."""
    pairs = [(i, j) for i in range(n) for j in range(i + 1, n)]
    seen = set()
    for bits in range(1 << len(pairs)):
        rel = [p for k, p in enumerate(pairs) if bits >> k & 1]
        c = closure(n, rel)
        if c == frozenset(rel) and c not in seen:
            seen.add(c)
            yield c


def canon(n, rel):
    return min(tuple(sorted((s[a], s[b]) for (a, b) in rel)) for s in itertools.permutations(range(n)))


def stems(n, rel):
    out = []
    for bits in range(1 << n):
        D = {i for i in range(n) if bits >> i & 1}
        if all((i in D) for (i, j) in rel if j in D):
            out.append(frozenset(D))
    return out


for n in range(1, 6):
    classes = {}
    for p in posets(n):
        k = canon(n, p)
        if k in classes:
            continue
        st = stems(n, p)
        kinds = {canon(n + 1, set(p) | {(i, n) for i in D}) for D in st}
        classes[k] = (len(st), len(kinds), len(p))
    print(f'n = {n}: {len(classes)} causal sets up to relabelling')
    for k, (s, kinds, pairs) in sorted(classes.items(), key=lambda kv: (-kv[1][1], kv[1][2])):
        print(f'   pairs {pairs:2d}  stems {s:2d}  kinds of birth {kinds:2d}   {list(k)}')
