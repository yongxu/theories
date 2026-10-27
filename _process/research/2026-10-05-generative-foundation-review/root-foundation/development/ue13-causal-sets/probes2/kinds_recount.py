"""UE13 re-check: an independent recount of the kinds of next birth (AI-written, 28 October 2026).

It does not reuse count/kinds_count.py. Causal sets of n elements are built up to isomorphism by
growth (each class of n + 1 elements as a child of a class of n elements, every finite order having a
natural labelling), isomorphism is tested by a backtracking search for a bijection rather than by a
canonical form, and for each class it reports the number of stems, the number of kinds of birth (the
children up to isomorphism of the whole grown configuration, which is Kinds.Included's notion) and the
size of its automorphism group. usage: python3 -I kinds_recount.py > kinds_recount.txt"""
import itertools


def isomorphic(n, a, b):
    """Is there a bijection of 0..n-1 carrying the strict order a onto b (both sets of pairs)?"""
    if len(a) != len(b):
        return False
    def profile(rel, x):
        return (sum(1 for (i, j) in rel if j == x), sum(1 for (i, j) in rel if i == x))
    pa = [profile(a, x) for x in range(n)]
    pb = [profile(b, x) for x in range(n)]
    if sorted(pa) != sorted(pb):
        return False
    image = {}
    used = set()
    def extend(x):
        if x == n:
            return True
        for y in range(n):
            if y in used or pa[x] != pb[y]:
                continue
            ok = True
            for z, w in image.items():
                if ((z, x) in a) != ((w, y) in b) or ((x, z) in a) != ((y, w) in b):
                    ok = False
                    break
            if ok:
                image[x] = y
                used.add(y)
                if extend(x + 1):
                    return True
                del image[x]
                used.discard(y)
        return False
    return extend(0)


def automorphisms(n, rel):
    return sum(1 for s in itertools.permutations(range(n))
               if all(((s[i], s[j]) in rel) for (i, j) in rel))


def stems(n, rel):
    return [frozenset(D) for k in range(n + 1) for D in itertools.combinations(range(n), k)
            if all(i in D for (i, j) in rel if j in D)]


def child(n, rel, D):
    return frozenset(rel) | {(i, n) for i in D}


def classes(sizes):
    """Representatives of the causal sets of each size up to isomorphism, grown from the empty one."""
    levels = {0: [frozenset()]}
    for n in range(sizes):
        reps = []
        for rel in levels[n]:
            for D in stems(n, rel):
                c = child(n, rel, D)
                if not any(isomorphic(n + 1, c, r) for r in reps):
                    reps.append(c)
        levels[n + 1] = reps
    return levels


def kinds(n, rel):
    reps = []
    for D in stems(n, rel):
        c = child(n, rel, D)
        if not any(isomorphic(n + 1, c, r) for r in reps):
            reps.append(c)
    return len(reps)


def name(n, rel):
    if not rel:
        return 'antichain'
    if len(rel) == n * (n - 1) // 2:
        return 'chain'
    return ''


levels = classes(5)
for n in range(1, 6):
    rows = []
    for rel in levels[n]:
        rows.append((kinds(n, rel), len(stems(n, rel)), len(rel), automorphisms(n, rel), sorted(rel), name(n, rel)))
    rows.sort(key=lambda r: (-r[0], r[2]))
    k = [r[0] for r in rows]
    print(f'n = {n}: {len(rows)} causal sets up to isomorphism; kinds of birth: max {max(k)}, min {min(k)} '
          f'(n + 1 = {n + 1}); classes at the min: {k.count(min(k))}')
    for r in rows:
        print(f'   kinds {r[0]:2d}  stems {r[1]:2d}  pairs {r[2]:2d}  automorphisms {r[3]:3d}  {r[4]} {r[5]}')
    top = [r for r in rows if r[0] == max(k)]
    print(f'   at the max: ' + '; '.join(f'{r[4]} with {r[3]} automorphism(s)' for r in top))
    rigid = [r for r in rows if r[3] == 1]
    if rigid:
        print(f'   classes with no symmetry: {len(rigid)}, their kinds: {sorted((r[0] for r in rigid), reverse=True)}')
