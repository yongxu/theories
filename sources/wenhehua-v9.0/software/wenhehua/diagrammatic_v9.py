"""Finite, typed implementation of Span(colim_J), with explicit oplax maps.

J is an explicitly checked finite category. Diagrams and natural transformations
are immutable. Colimit labels retain their complete equivalence classes: no
delimiter-based names, probabilistic weights, or history identifications are
silently introduced. This module checks finite instances; general coherence is
proved in the accompanying mathematical document, not established by tests.
"""
from __future__ import annotations

from dataclasses import dataclass
from itertools import product
from typing import Any


class DiagramError(ValueError):
    pass


def _label(x):
    return isinstance(x, str) or (isinstance(x, tuple) and all(_label(y) for y in x))


@dataclass(frozen=True)
class FSet:
    items: tuple[tuple[Any, str], ...]

    def __post_init__(self):
        xs = tuple(sorted((tuple(p) for p in self.items), key=lambda p: repr(p[0])))
        if any(not _label(k) or not isinstance(t, str) or not t for k, t in xs):
            raise DiagramError('labels must be strings/tuples; types nonempty strings')
        if len({k for k, _ in xs}) != len(xs):
            raise DiagramError('duplicate element')
        object.__setattr__(self, 'items', xs)

    @classmethod
    def of(cls, names, typ='T'):
        return cls(tuple((n, typ) for n in names))

    @property
    def keys(self):
        return tuple(k for k, _ in self.items)

    @property
    def types(self):
        return dict(self.items)

    def __len__(self):
        return len(self.items)


@dataclass(frozen=True)
class FMap:
    source: FSet
    target: FSet
    items: tuple[tuple[Any, Any], ...]

    def __post_init__(self):
        xs = tuple(sorted((tuple(p) for p in self.items), key=lambda p: repr(p[0])))
        d = dict(xs)
        if len(d) != len(xs) or set(d) != set(self.source.keys):
            raise DiagramError('map must have exactly one value per source element')
        st, tt = self.source.types, self.target.types
        if any(y not in tt or st[x] != tt[y] for x, y in xs):
            raise DiagramError('map target or type mismatch')
        object.__setattr__(self, 'items', xs)

    def __call__(self, x):
        return dict(self.items)[x]

    @property
    def injective(self):
        return len({y for _, y in self.items}) == len(self.items)

    @property
    def surjective(self):
        return {y for _, y in self.items} == set(self.target.keys)

    @property
    def bijective(self):
        return self.injective and self.surjective


def fid(x):
    return FMap(x, x, tuple((k, k) for k in x.keys))


def fthen(f, g):
    if f.target != g.source:
        raise DiagramError('map composition endpoints differ')
    return FMap(f.source, g.target, tuple((x, g(f(x))) for x in f.source.keys))


def fpullback(f, g):
    if f.target != g.target:
        raise DiagramError('pullback requires a common codomain')
    xs = [(('pair', x, y), f.source.types[x])
          for x in f.source.keys for y in g.source.keys if f(x) == g(y)]
    p = FSet(tuple(xs))
    return p, FMap(p, f.source, tuple((z, z[1]) for z in p.keys)), \
        FMap(p, g.source, tuple((z, z[2]) for z in p.keys))


@dataclass(frozen=True)
class Arrow:
    name: str
    source: str
    target: str

    def __post_init__(self):
        if any(not isinstance(x, str) or not x for x in (self.name, self.source, self.target)):
            raise DiagramError('arrow names and endpoints must be nonempty strings')


@dataclass(frozen=True)
class Shape:
    """Composition triples use diagrammatic order: (f, g, g after f)."""
    objects: tuple[str, ...]
    arrows: tuple[Arrow, ...]
    identities: tuple[tuple[str, str], ...]
    compositions: tuple[tuple[str, str, str], ...]

    def __post_init__(self):
        for field in ('objects', 'arrows'):
            object.__setattr__(self, field, tuple(getattr(self, field)))
        for field in ('identities', 'compositions'):
            object.__setattr__(self, field, tuple(tuple(x) for x in getattr(self, field)))
        if any(not isinstance(x, str) or not x for x in self.objects):
            raise DiagramError('object names must be nonempty strings')
        if any(not isinstance(a, Arrow) for a in self.arrows):
            raise DiagramError('shape arrows must be Arrow instances')
        if len(set(self.objects)) != len(self.objects):
            raise DiagramError('duplicate object')
        a = {x.name: x for x in self.arrows}
        if len(a) != len(self.arrows):
            raise DiagramError('duplicate arrow')
        if any(x.source not in self.objects or x.target not in self.objects for x in a.values()):
            raise DiagramError('unknown arrow endpoint')
        ids = dict(self.identities)
        if len(ids) != len(self.identities) or set(ids) != set(self.objects):
            raise DiagramError('exactly one identity required per object')
        for obj, name in ids.items():
            if name not in a or a[name].source != obj or a[name].target != obj:
                raise DiagramError('invalid identity')
        comp = {(f, g): h for f, g, h in self.compositions}
        expected = {(f.name, g.name) for f in a.values() for g in a.values()
                    if f.target == g.source}
        if len(comp) != len(self.compositions) or set(comp) != expected:
            raise DiagramError('composition table must cover exactly composable pairs')
        for (f, g), h in comp.items():
            if h not in a or (a[h].source, a[h].target) != (a[f].source, a[g].target):
                raise DiagramError('composition endpoint mismatch')
        for f in a.values():
            if comp[ids[f.source], f.name] != f.name or comp[f.name, ids[f.target]] != f.name:
                raise DiagramError('identity law failed')
        for f, g in expected:
            for h in a:
                if a[g].target == a[h].source:
                    if comp[comp[f, g], h] != comp[f, comp[g, h]]:
                        raise DiagramError('category associativity failed')

    @classmethod
    def bipartite(cls, objects, edges):
        """Finite free category when no two nonidentity edges can compose."""
        objs = tuple(objects)
        nonids = tuple(Arrow(*e) for e in edges)
        if any(f.target == g.source for f in nonids for g in nonids):
            raise DiagramError('use an explicit composition table for longer paths')
        ids = tuple((x, 'id:' + x) for x in objs)
        arrows = tuple(Arrow(name, obj, obj) for obj, name in ids) + nonids
        iid = dict(ids)
        cs = []
        for f in arrows:
            for g in arrows:
                if f.target != g.source:
                    continue
                h = g.name if f.name == iid[f.source] else f.name
                cs.append((f.name, g.name, h))
        return cls(objs, arrows, ids, tuple(cs))


@dataclass(frozen=True)
class Diagram:
    shape: Shape
    objects: tuple[tuple[str, FSet], ...]
    maps: tuple[tuple[str, FMap], ...]

    def __post_init__(self):
        object.__setattr__(self, 'objects', tuple(sorted(tuple(x) for x in self.objects)))
        object.__setattr__(self, 'maps', tuple(sorted(tuple(x) for x in self.maps)))
        obj, maps = dict(self.objects), dict(self.maps)
        if len(obj) != len(self.objects) or set(obj) != set(self.shape.objects):
            raise DiagramError('diagram object assignment incomplete or duplicate')
        if len(maps) != len(self.maps) or set(maps) != {a.name for a in self.shape.arrows}:
            raise DiagramError('diagram arrow assignment incomplete or duplicate')
        for a in self.shape.arrows:
            if (maps[a.name].source, maps[a.name].target) != (obj[a.source], obj[a.target]):
                raise DiagramError('diagram arrow endpoints differ')
        for x, i in self.shape.identities:
            if maps[i] != fid(obj[x]):
                raise DiagramError('diagram does not preserve identities')
        for f, g, h in self.shape.compositions:
            if fthen(maps[f], maps[g]) != maps[h]:
                raise DiagramError('diagram does not preserve composition')

    def obj(self, name):
        return dict(self.objects)[name]

    def arrow(self, name):
        return dict(self.maps)[name]

    @classmethod
    def build(cls, shape, objects, nonidentity_maps):
        ms = dict(nonidentity_maps)
        for x, name in shape.identities:
            ms[name] = fid(objects[x])
        return cls(shape, tuple(objects.items()), tuple(ms.items()))


@dataclass(frozen=True)
class Natural:
    source: Diagram
    target: Diagram
    components: tuple[tuple[str, FMap], ...]

    def __post_init__(self):
        object.__setattr__(self, 'components', tuple(sorted(tuple(x) for x in self.components)))
        cs = dict(self.components)
        if self.source.shape != self.target.shape:
            raise DiagramError('natural transformation requires the same shape')
        if len(cs) != len(self.components) or set(cs) != set(self.source.shape.objects):
            raise DiagramError('natural transformation components incomplete')
        for x in self.source.shape.objects:
            if (cs[x].source, cs[x].target) != (self.source.obj(x), self.target.obj(x)):
                raise DiagramError('natural transformation component endpoints differ')
        for a in self.source.shape.arrows:
            if fthen(self.source.arrow(a.name), cs[a.target]) != fthen(cs[a.source], self.target.arrow(a.name)):
                raise DiagramError('naturality square does not commute')

    def at(self, x):
        return dict(self.components)[x]


def nid(d):
    return Natural(d, d, tuple((x, fid(d.obj(x))) for x in d.shape.objects))


def nthen(f, g):
    if f.target != g.source:
        raise DiagramError('natural transformation composition endpoints differ')
    return Natural(f.source, g.target, tuple((x, fthen(f.at(x), g.at(x))) for x in f.source.shape.objects))


@dataclass(frozen=True)
class Colimit:
    diagram: Diagram
    apex: FSet
    injections: tuple[tuple[str, FMap], ...]

    def at(self, name):
        return dict(self.injections)[name]

    def descend(self, target, cocone):
        """Construct the unique mediating map, or reject an incompatible cocone."""
        cs = dict(cocone)
        if set(cs) != set(self.diagram.shape.objects):
            raise DiagramError('cocone components incomplete')
        for x in self.diagram.shape.objects:
            if (cs[x].source, cs[x].target) != (self.diagram.obj(x), target):
                raise DiagramError('cocone endpoints differ')
        out = {}
        for x in self.diagram.shape.objects:
            for k in self.diagram.obj(x).keys:
                q, y = self.at(x)(k), cs[x](k)
                if q in out and out[q] != y:
                    raise DiagramError('cocone fails descent')
                out[q] = y
        return FMap(self.apex, target, tuple(out.items()))


def colimit(d):
    tokens = [(x, k) for x in d.shape.objects for k in d.obj(x).keys]
    parent = {t: t for t in tokens}

    def root(t):
        while parent[t] != t:
            parent[t] = parent[parent[t]]
            t = parent[t]
        return t

    for a in d.shape.arrows:
        for x in d.obj(a.source).keys:
            p, q = root((a.source, x)), root((a.target, d.arrow(a.name)(x)))
            if p != q:
                parent[q] = p
    groups = {}
    for t in tokens:
        groups.setdefault(root(t), []).append(t)
    labels, types = {}, {}
    for members in groups.values():
        name = ('class', tuple(sorted(members, key=repr)))
        ts = {d.obj(obj).types[x] for obj, x in members}
        if len(ts) != 1:
            raise DiagramError('colimit identifies different types')
        types[name] = ts.pop()
        for t in members:
            labels[t] = name
    apex = FSet(tuple(types.items()))
    ins = tuple((obj, FMap(d.obj(obj), apex, tuple((x, labels[obj, x]) for x in d.obj(obj).keys)))
                for obj in d.shape.objects)
    return Colimit(d, apex, ins)


def colimit_map(n):
    a, b = colimit(n.source), colimit(n.target)
    return a.descend(b.apex, {x: fthen(n.at(x), b.at(x)) for x in n.source.shape.objects})


def dpullback(f, g):
    if f.target != g.target:
        raise DiagramError('diagram pullback needs common codomain')
    shape = f.source.shape
    ps = {x: fpullback(f.at(x), g.at(x)) for x in shape.objects}
    objs = {x: ps[x][0] for x in shape.objects}
    maps = {}
    for a in shape.arrows:
        maps[a.name] = FMap(objs[a.source], objs[a.target], tuple(
            (z, ('pair', f.source.arrow(a.name)(z[1]), g.source.arrow(a.name)(z[2])))
            for z in objs[a.source].keys))
    d = Diagram(shape, tuple(objs.items()), tuple(maps.items()))
    return d, Natural(d, f.source, tuple((x, ps[x][1]) for x in shape.objects)), \
        Natural(d, g.source, tuple((x, ps[x][2]) for x in shape.objects))


@dataclass(frozen=True)
class FSpan:
    before: FSet
    after: FSet
    witness: FSet
    left: FMap
    right: FMap

    def __post_init__(self):
        if (self.left.source, self.left.target, self.right.source, self.right.target) != \
                (self.witness, self.before, self.witness, self.after):
            raise DiagramError('finite span endpoints differ')


@dataclass(frozen=True)
class DSpan:
    before: Diagram
    after: Diagram
    witness: Diagram
    left: Natural
    right: Natural

    def __post_init__(self):
        if (self.left.source, self.left.target, self.right.source, self.right.target) != \
                (self.witness, self.before, self.witness, self.after):
            raise DiagramError('diagram span endpoints differ')


def didentity(d):
    return DSpan(d, d, d, nid(d), nid(d))


def dcompose(a, b):
    if a.after != b.before:
        raise DiagramError('diagram span middle differs')
    p, x, y = dpullback(a.right, b.left)
    return DSpan(a.before, b.after, p, nthen(x, a.left), nthen(y, b.right))


def fcompose(a, b):
    if a.after != b.before:
        raise DiagramError('finite span middle differs')
    p, x, y = fpullback(a.right, b.left)
    return FSpan(a.before, b.after, p, fthen(x, a.left), fthen(y, b.right))


def glue(s):
    return FSpan(colimit(s.before).apex, colimit(s.after).apex,
                 colimit(s.witness).apex, colimit_map(s.left), colimit_map(s.right))


@dataclass(frozen=True)
class SpanComparison:
    local: DSpan
    source: FSpan
    target: FSpan
    cell: FMap

    def __post_init__(self):
        if self.source != glue(self.local):
            raise DiagramError('comparison source must be glued local span')
        if (self.source.before, self.source.after) != (self.target.before, self.target.after):
            raise DiagramError('comparison exterior endpoints differ')
        if (self.cell.source, self.cell.target) != (self.source.witness, self.target.witness):
            raise DiagramError('comparison cell endpoints differ')
        if fthen(self.cell, self.target.left) != self.source.left or fthen(self.cell, self.target.right) != self.source.right:
            raise DiagramError('comparison does not preserve both endpoint maps')


def comparison(a, b):
    local = dcompose(a, b)
    source, target = glue(local), fcompose(glue(a), glue(b))
    c, ca, cb = colimit(local.witness), colimit(a.witness), colimit(b.witness)
    cone = {}
    for obj in local.witness.shape.objects:
        cone[obj] = FMap(local.witness.obj(obj), target.witness, tuple(
            (z, ('pair', ca.at(obj)(z[1]), cb.at(obj)(z[2])))
            for z in local.witness.obj(obj).keys))
    return SpanComparison(local, source, target, c.descend(target.witness, cone))


def _f_history(spans):
    if not spans:
        raise DiagramError('history needs at least one span')
    for a, b in zip(spans, spans[1:]):
        if a.after != b.before:
            raise DiagramError('history middle differs')
    ws = []
    for tup in product(*(s.witness.keys for s in spans)):
        if all(spans[i].right(tup[i]) == spans[i+1].left(tup[i+1]) for i in range(len(spans)-1)):
            ws.append((('history', tup), spans[0].witness.types[tup[0]]))
    w = FSet(tuple(ws))
    return FSpan(spans[0].before, spans[-1].after, w,
                 FMap(w, spans[0].before, tuple((z, spans[0].left(z[1][0])) for z in w.keys)),
                 FMap(w, spans[-1].after, tuple((z, spans[-1].right(z[1][-1])) for z in w.keys)))


def n_comparison(spans):
    """Direct arbitrary finite history comparison, without choosing a binary tree."""
    spans = tuple(spans)
    if not spans:
        raise DiagramError('history needs at least one span')
    for a, b in zip(spans, spans[1:]):
        if a.after != b.before:
            raise DiagramError('history middle differs')
    shape = spans[0].before.shape
    point = {x: _f_history(tuple(FSpan(s.before.obj(x), s.after.obj(x), s.witness.obj(x),
                   s.left.at(x), s.right.at(x)) for s in spans)) for x in shape.objects}
    objs = {x: point[x].witness for x in shape.objects}
    maps = {}
    for a in shape.arrows:
        maps[a.name] = FMap(objs[a.source], objs[a.target], tuple(
            (z, ('history', tuple(s.witness.arrow(a.name)(w) for s, w in zip(spans, z[1]))))
            for z in objs[a.source].keys))
    d = Diagram(shape, tuple(objs.items()), tuple(maps.items()))
    local = DSpan(spans[0].before, spans[-1].after, d,
        Natural(d, spans[0].before, tuple((x, point[x].left) for x in shape.objects)),
        Natural(d, spans[-1].after, tuple((x, point[x].right) for x in shape.objects)))
    target = _f_history(tuple(glue(s) for s in spans))
    colimits = tuple(colimit(s.witness) for s in spans)
    cone = {x: FMap(objs[x], target.witness, tuple(
        (z, ('history', tuple(c.at(x)(w) for c, w in zip(colimits, z[1])))) for z in objs[x].keys))
        for x in shape.objects}
    cell = colimit(d).descend(target.witness, cone)
    return SpanComparison(local, glue(local), target, cell)


def bracketed_comparison(spans, tree):
    """Build the oplax composite along a supplied ordered binary tree.

    Leaves are consecutive indices. Unlike n_comparison, this actually composes
    binary comparison cells, making coherence checks independent computations.
    """
    spans = tuple(spans)

    def leaves(t):
        if type(t) is int:
            return (t,)
        if not isinstance(t, (tuple, list)) or len(t) != 2:
            raise DiagramError('binary tree needs integer leaves and two-child nodes')
        return leaves(t[0]) + leaves(t[1])

    if leaves(tree) != tuple(range(len(spans))):
        raise DiagramError('tree must use each span once, in order')

    def rec(t):
        if type(t) is int:
            s, g = spans[t], glue(spans[t])
            return SpanComparison(s, g, g, fid(g.witness))
        l, r = rec(t[0]), rec(t[1])
        c = comparison(l.local, r.local)
        target = fcompose(l.target, r.target)
        m = FMap(c.source.witness, target.witness, tuple(
            (w, ('pair', l.cell(c.cell(w)[1]), r.cell(c.cell(w)[2])))
            for w in c.source.witness.keys))
        return SpanComparison(c.local, c.source, target, m)

    return rec(tree)


def flatten_tree_witness(w, tree):
    if type(tree) is int:
        return (w,)
    if not isinstance(tree, (tuple, list)) or len(tree) != 2:
        raise DiagramError('malformed binary tree')
    if not isinstance(w, tuple) or len(w) != 3 or w[0] != 'pair':
        raise DiagramError('nested witness does not match its binary tree')
    return flatten_tree_witness(w[1], tree[0]) + flatten_tree_witness(w[2], tree[1])


def coherence_check(spans, tree):
    """Compare two independently computed maps after explicit reassociation."""
    spans = tuple(spans)
    direct = n_comparison(spans)
    staged = bracketed_comparison(spans, tree)
    qc = colimit(direct.local.witness)
    images = {}
    for x in staged.source.witness.keys:
        reps = x[1]
        canonical = {qc.at(obj)(('history', flatten_tree_witness(w, tree))) for obj, w in reps}
        if len(canonical) != 1:
            return False
        key = canonical.pop()
        image = ('history', flatten_tree_witness(staged.cell(x), tree))
        if direct.cell(key) != image or (key in images and images[key] != image):
            return False
        images[key] = image
    target_images = {('history', flatten_tree_witness(w, tree)) for w in staged.target.witness.keys}
    return (set(images) == set(direct.source.witness.keys)
            and len(images) == len(staged.source.witness)
            and target_images == set(direct.target.witness.keys)
            and len(target_images) == len(staged.target.witness))


def beck_chevalley_fiber(a, b, family, v):
    """The actual BC map on a specified fiber for the square F(P)->F(V).

    ``family`` assigns one typed finite set to every element of F(W). For a
    chosen v in F(V), map (u,e) to (Fp(u),e). This is a function on elements,
    rather than only a comparison of fiber cardinalities. It is bijective for
    every family and every v precisely when the binary comparison is bijective.
    """
    c = comparison(a, b)
    fw, fv = colimit(a.witness).apex, colimit(b.witness).apex
    family = dict(family)
    if set(family) != set(fw.keys) or any(not isinstance(e, FSet) for e in family.values()):
        raise DiagramError('family must provide a finite set for every F(W) element')
    if v not in fv.keys:
        raise DiagramError('BC fiber is not an element of F(V)')
    domain_items, target_items, values = [], [], []
    for u in c.cell.source.keys:
        _, w, v0 = c.cell(u)
        if v0 == v:
            for e, typ in family[w].items:
                key = ('dependent', u, e)
                domain_items.append((key, typ))
                values.append((key, ('dependent', w, e)))
    for _, w, v0 in c.cell.target.keys:
        if v0 == v:
            for e, typ in family[w].items:
                target_items.append((('dependent', w, e), typ))
    return FMap(FSet(tuple(domain_items)), FSet(tuple(target_items)), tuple(values))


SEAM = Shape.bipartite(('S', 'L', 'R'), (('sl', 'S', 'L'), ('sr', 'S', 'R')))


def from_legacy_state(s):
    """Exact translation of mathematical v5 SeamState data, with new labels."""
    objs = {'S': FSet(s.seam.items), 'L': FSet(s.left.items), 'R': FSet(s.right.items)}
    ms = {'sl': FMap(objs['S'], objs['L'], tuple(s.seam_to_left.mapping.items())),
          'sr': FMap(objs['S'], objs['R'], tuple(s.seam_to_right.mapping.items()))}
    return Diagram.build(SEAM, objs, ms)


def from_legacy_step(s):
    before, after = from_legacy_state(s.old), from_legacy_state(s.new)
    objs = {'S': FSet(s.seam.witness.items), 'L': FSet(s.left.witness.items), 'R': FSet(s.right.witness.items)}
    witness = Diagram.build(SEAM, objs,
        {'sl': FMap(objs['S'], objs['L'], tuple(s.seam_to_left.mapping.items())),
         'sr': FMap(objs['S'], objs['R'], tuple(s.seam_to_right.mapping.items()))})
    old = {'S': s.seam, 'L': s.left, 'R': s.right}
    left = Natural(witness, before, tuple((x, FMap(objs[x], before.obj(x), tuple(old[x].to_before.mapping.items()))) for x in SEAM.objects))
    right = Natural(witness, after, tuple((x, FMap(objs[x], after.obj(x), tuple(old[x].to_after.mapping.items()))) for x in SEAM.objects))
    return DSpan(before, after, witness, left, right)
