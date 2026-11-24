import unittest
from dataclasses import replace
from wenhehua.diagrammatic_v9 import (
    Arrow, Shape, FSet, FMap, Diagram, Natural, DiagramError, DSpan, SEAM,
    fid, fthen, fpullback, nid, nthen, colimit, colimit_map, dpullback, didentity, glue,
    comparison, n_comparison, coherence_check, from_legacy_step, beck_chevalley_fiber,
)


def seam(s, l, r, sl, sr):
    objs = {'S': FSet.of(s), 'L': FSet.of(l), 'R': FSet.of(r)}
    return Diagram.build(SEAM, objs, {
        'sl': FMap(objs['S'], objs['L'], tuple(sl.items())),
        'sr': FMap(objs['S'], objs['R'], tuple(sr.items()))})


def natural(a, b, maps):
    return Natural(a, b, tuple((x, FMap(a.obj(x), b.obj(x), tuple(maps[x].items()))) for x in a.shape.objects))


def singleton_state():
    return seam(('s',), ('l',), ('r',), {'s': 'l'}, {'s': 'r'})


def to_singleton(a, b=None):
    b = b or singleton_state()
    return natural(a, b, {x: {k: b.obj(x).keys[0] for k in a.obj(x).keys} for x in a.shape.objects})


def merging_example():
    endpoint = singleton_state()
    middle = seam(('s1', 's2'), ('a',), ('b',), {'s1': 'a', 's2': 'a'}, {'s1': 'b', 's2': 'b'})
    w = seam(('x1', 'x2'), ('u1', 'u2'), ('v',), {'x1': 'u1', 'x2': 'u2'}, {'x1': 'v', 'x2': 'v'})
    v = seam(('y1', 'y2'), ('p',), ('q1', 'q2'), {'y1': 'p', 'y2': 'p'}, {'y1': 'q1', 'y2': 'q2'})
    wm = natural(w, middle, {'S': {'x1': 's1', 'x2': 's2'}, 'L': {'u1': 'a', 'u2': 'a'}, 'R': {'v': 'b'}})
    vm = natural(v, middle, {'S': {'y1': 's1', 'y2': 's2'}, 'L': {'p': 'a'}, 'R': {'q1': 'b', 'q2': 'b'}})
    return DSpan(endpoint, middle, w, to_singleton(w), wm), DSpan(middle, endpoint, v, vm, to_singleton(v))


def two_local_events(label=''):
    state = singleton_state()
    w = seam((), (label+'u',), (label+'v',), {}, {})
    return DSpan(state, state, w, to_singleton(w), to_singleton(w))


def trees(indices):
    if len(indices) == 1:
        return [indices[0]]
    return [(l, r) for k in range(1, len(indices))
            for l in trees(indices[:k]) for r in trees(indices[k:])]


def induce_into_pullback(first_leg, second_leg, first_cone, second_cone):
    """Independent universal lift, using projections rather than pair labels."""
    if first_cone.source != second_cone.source:
        raise DiagramError('pullback cone sources differ')
    if fthen(first_cone, first_leg) != fthen(second_cone, second_leg):
        raise DiagramError('pullback cone does not commute')
    apex, first_projection, second_projection = fpullback(first_leg, second_leg)
    by_coordinates = {(first_projection(w), second_projection(w)): w for w in apex.keys}
    return FMap(first_cone.source, apex, tuple(
        (w, by_coordinates[first_cone(w), second_cone(w)]) for w in first_cone.source.keys))


def relabel_witness(span, prefix):
    """Isomorphic witness with different labels, keeping exterior states fixed."""
    old = span.witness
    renamed = {x: {k: (prefix, x, k) for k in old.obj(x).keys} for x in old.shape.objects}
    objects = {x: FSet(tuple((renamed[x][k], typ) for k, typ in old.obj(x).items)) for x in old.shape.objects}
    maps = {a.name: FMap(objects[a.source], objects[a.target], tuple(
        (renamed[a.source][k], renamed[a.target][old.arrow(a.name)(k)])
        for k in old.obj(a.source).keys)) for a in old.shape.arrows}
    new = Diagram(old.shape, tuple(objects.items()), tuple(maps.items()))
    forward = Natural(old, new, tuple((x, FMap(old.obj(x), objects[x], tuple(renamed[x].items()))) for x in old.shape.objects))
    backward = Natural(new, old, tuple((x, FMap(objects[x], old.obj(x), tuple((v, k) for k, v in renamed[x].items()))) for x in old.shape.objects))
    return DSpan(span.before, span.after, new, nthen(backward, span.left), nthen(backward, span.right)), forward


def multiple_local_events(prefix, count):
    state = singleton_state()
    witness = seam((), tuple(prefix + 'L' + str(i) for i in range(count)),
                   tuple(prefix + 'R' + str(i) for i in range(count)), {}, {})
    leg = to_singleton(witness, state)
    return DSpan(state, state, witness, leg, leg)


class TestFiniteCategoryAndDiagram(unittest.TestCase):
    def test_shape_rejects_missing_composite(self):
        with self.assertRaises(DiagramError):
            replace(SEAM, compositions=SEAM.compositions[:-1])

    def test_shape_rejects_wrong_unit_law(self):
        shape = Shape.bipartite(('A', 'B'), (('f', 'A', 'B'), ('g', 'A', 'B')))
        cs = tuple((f, g, 'g' if (f, g) == ('id:A', 'f') else h) for f, g, h in shape.compositions)
        with self.assertRaises(DiagramError):
            replace(shape, compositions=cs)

    def test_explicit_chain_functor_composition_checked(self):
        ids = [('A', 'iA'), ('B', 'iB'), ('C', 'iC')]
        arrows = [Arrow(n, x, x) for x, n in ids] + [Arrow('f','A','B'), Arrow('g','B','C'), Arrow('gf','A','C')]
        lookup = {x.name:x for x in arrows}
        cs=[]
        for a in arrows:
            for b in arrows:
                if a.target != b.source: continue
                name = b.name if a.source == a.target else a.name if b.source == b.target else 'gf'
                cs.append((a.name,b.name,name))
        shape=Shape(('A','B','C'),tuple(arrows),tuple(ids),tuple(cs))
        bit=FSet.of(('0','1')); flip=FMap(bit,bit,(('0','1'),('1','0')))
        good=Diagram.build(shape,dict.fromkeys(shape.objects,bit),{'f':flip,'g':flip,'gf':fid(bit)})
        with self.assertRaises(DiagramError):
            Diagram.build(shape,dict.fromkeys(shape.objects,bit),{'f':flip,'g':flip,'gf':flip})
        self.assertEqual(len(colimit(good).apex),2)

    def test_naturality_rejected(self):
        a=singleton_state()
        b=seam(('s',),('l','other'),('r',),{'s':'l'},{'s':'r'})
        with self.assertRaises(DiagramError):
            natural(a,b,{'S':{'s':'s'},'L':{'l':'other'},'R':{'r':'r'}})

    def test_typed_map_rejected(self):
        with self.assertRaises(DiagramError):
            FMap(FSet.of(('x',),'meter'),FSet.of(('y',),'second'),(('x','y'),))

    def test_mapping_input_copied_and_immutable(self):
        elems=[['a','T'],['b','T']]; x=FSet(elems)
        elems[0][0]='tampered'
        values=[['a','a'],['b','b']]
        f=FMap(x,x,values); values[0][1]='b'
        self.assertEqual(f,fid(x))
        self.assertEqual(x.keys,('a','b'))

    def test_colimit_uses_structural_identifiers(self):
        d=seam((),('a|R:b','a'),('b','L:a|R:b'),{}, {})
        self.assertEqual(len(colimit(d).apex),4)

    def test_empty_shape_and_empty_colimit(self):
        sh=Shape.bipartite((),())
        d=Diagram.build(sh,{}, {})
        self.assertEqual(len(colimit(d).apex),0)
        self.assertTrue(comparison(didentity(d),didentity(d)).cell.bijective)


class TestUniversalConstructions(unittest.TestCase):
    def test_colimit_descent_and_uniqueness(self):
        d=singleton_state(); c=colimit(d); out=FSet.of(('z','unused'))
        cone={x:FMap(d.obj(x),out,tuple((k,'z') for k in d.obj(x).keys)) for x in SEAM.objects}
        u=c.descend(out,cone)
        for x in SEAM.objects:
            self.assertEqual(fthen(c.at(x),u),cone[x])
        q=c.apex.keys[0]
        for y in out.keys:
            candidate=FMap(c.apex,out,((q,y),))
            if all(fthen(c.at(x),candidate)==cone[x] for x in SEAM.objects):
                self.assertEqual(candidate,u)

    def test_colimit_rejects_noncompatible_cocone(self):
        d=singleton_state(); c=colimit(d); out=FSet.of(('z','w'))
        cone={x:FMap(d.obj(x),out,tuple((k,'w' if x=='R' else 'z') for k in d.obj(x).keys)) for x in SEAM.objects}
        with self.assertRaises(DiagramError): c.descend(out,cone)

    def test_colimit_functor_identity_and_composition(self):
        a=two_local_events().witness; b=singleton_state(); f=to_singleton(a,b)
        self.assertEqual(colimit_map(nid(a)),fid(colimit(a).apex))
        self.assertEqual(colimit_map(nthen(f,nid(b))),fthen(colimit_map(f),colimit_map(nid(b))))

    def test_pointwise_pullback_projections_commute(self):
        a,b=merging_example()
        p,l,r=dpullback(a.right,b.left)
        self.assertEqual(nthen(l,a.right),nthen(r,b.left))
        self.assertEqual(len(colimit(p).apex),2)


class TestOplaxComparison(unittest.TestCase):
    def assert_comparison_natural(self, a, b, renamed_a, renamed_b, u, v):
        # u and v are actual span maps over unchanged exterior/middle diagrams.
        self.assertEqual(nthen(u, renamed_a.left), a.left)
        self.assertEqual(nthen(u, renamed_a.right), a.right)
        self.assertEqual(nthen(v, renamed_b.left), b.left)
        self.assertEqual(nthen(v, renamed_b.right), b.right)

        local, local_first, local_second = dpullback(a.right, b.left)
        local_new, local_new_first, local_new_second = dpullback(renamed_a.right, renamed_b.left)
        local_map = Natural(local, local_new, tuple((x, induce_into_pullback(
            renamed_a.right.at(x), renamed_b.left.at(x),
            fthen(local_first.at(x), u.at(x)), fthen(local_second.at(x), v.at(x))))
            for x in local.shape.objects))
        self.assertEqual(nthen(local_map, local_new_first), nthen(local_first, u))
        self.assertEqual(nthen(local_map, local_new_second), nthen(local_second, v))

        ga, gb, ga_new, gb_new = map(glue, (a, b, renamed_a, renamed_b))
        _, global_first, global_second = fpullback(ga.right, gb.left)
        global_map = induce_into_pullback(ga_new.right, gb_new.left,
            fthen(global_first, colimit_map(u)), fthen(global_second, colimit_map(v)))

        # Two independently constructed routes around the naturality square.
        # Neither expected map is obtained by reimplementing comparison's formula.
        old_comparison = comparison(a, b)
        new_comparison = comparison(renamed_a, renamed_b)
        self.assertEqual(fthen(colimit_map(local_map), new_comparison.cell),
                         fthen(old_comparison.cell, global_map))

    def test_comparison_naturality_for_nonidentity_relabeling(self):
        a, b = merging_example()  # Nonempty seams; kappa itself is 2 -> 1.
        a_new, u = relabel_witness(a, 'renamed-first')
        b_new, v = relabel_witness(b, 'renamed-second')
        self.assertNotEqual(u.source, u.target)
        self.assertTrue(colimit_map(u).bijective)
        self.assertFalse(comparison(a, b).cell.injective)
        self.assert_comparison_natural(a, b, a_new, b_new, u, v)

    def test_comparison_naturality_for_noninjective_span_maps(self):
        a, b = multiple_local_events('first-', 2), multiple_local_events('second-', 2)
        a_new, b_new = multiple_local_events('collapsed-first-', 1), multiple_local_events('collapsed-second-', 1)
        u = natural(a.witness, a_new.witness,
                    {x: {w: a_new.witness.obj(x).keys[0] for w in a.witness.obj(x).keys} for x in SEAM.objects})
        v = natural(b.witness, b_new.witness,
                    {x: {w: b_new.witness.obj(x).keys[0] for w in b.witness.obj(x).keys} for x in SEAM.objects})
        self.assertFalse(u.at('L').injective)
        self.assertFalse(colimit_map(u).injective)
        self.assertEqual((len(comparison(a,b).cell.source), len(comparison(a,b).cell.target)), (8,16))
        self.assert_comparison_natural(a, b, a_new, b_new, u, v)

    def test_exact_singleton_comparison(self):
        from wenhehua.lineage import example_interchange
        a,b=map(from_legacy_step,example_interchange(True))
        c=comparison(a,b)
        self.assertTrue(c.cell.bijective)
        self.assertEqual((len(c.cell.source),len(c.cell.target)),(1,1))

    def test_empty_local_but_global_handoff(self):
        from wenhehua.lineage import example_interchange
        a,b=map(from_legacy_step,example_interchange(False))
        c=comparison(a,b)
        self.assertEqual((len(c.cell.source),len(c.cell.target)),(0,1))
        self.assertFalse(c.cell.surjective)

    def test_two_to_four_is_not_strict_interchange(self):
        c=comparison(two_local_events('a'),two_local_events('b'))
        self.assertEqual((len(c.cell.source),len(c.cell.target)),(2,4))
        self.assertTrue(c.cell.injective)
        self.assertFalse(c.cell.surjective)

    def test_two_to_one_is_not_a_history_inclusion(self):
        c=comparison(*merging_example())
        self.assertEqual((len(c.cell.source),len(c.cell.target)),(2,1))
        self.assertFalse(c.cell.injective)
        self.assertTrue(c.cell.surjective)

    def test_identity_comparison_both_sides(self):
        s=multiple_local_events('unit-',2)
        for side,a,b in [('left',didentity(s.before),s),('right',s,didentity(s.after))]:
            with self.subTest(side=side):
                c=comparison(a,b)
                self.assertTrue(c.cell.bijective)
                _,local_first,local_second=dpullback(a.right,b.left)
                ga,gb=glue(a),glue(b)
                _,global_first,global_second=fpullback(ga.right,gb.left)
                # The unitors are the surviving-witness projections. Compare
                # complete maps, not merely bijectivity or cardinalities.
                local_projection=local_second if side=='left' else local_first
                global_projection=global_second if side=='left' else global_first
                self.assertEqual(fthen(c.cell,global_projection),colimit_map(local_projection))

    def test_all_five_four_stage_bracketings(self):
        steps=tuple(two_local_events(str(i)) for i in range(4))
        c=n_comparison(steps)
        self.assertEqual((len(c.cell.source),len(c.cell.target)),(2,16))
        tt=trees(tuple(range(4)));self.assertEqual(len(tt),5)
        for t in tt:
            with self.subTest(tree=t): self.assertTrue(coherence_check(steps,t))

    def test_coherence_with_noninjective_intermediate_cell(self):
        a,b=merging_example(); steps=(a,b,two_local_events('c'))
        for t in trees((0,1,2)):
            with self.subTest(tree=t): self.assertTrue(coherence_check(steps,t))

    def test_wrong_order_tree_rejected(self):
        with self.assertRaises(DiagramError): coherence_check((two_local_events(),two_local_events()),(1,0))
        with self.assertRaises(DiagramError): coherence_check((two_local_events(),two_local_events()),(0,))
        with self.assertRaises(DiagramError): coherence_check((two_local_events(),two_local_events()),(0,1,2))
        self.assertTrue(coherence_check(iter((two_local_events(),two_local_events())),(0,1)))

    def test_group_orbits_forget_relative_orientation(self):
        shape=Shape(('X',),(Arrow('e','X','X'),Arrow('t','X','X')),
                    (('X','e'),),(('e','e','e'),('e','t','t'),('t','e','t'),('t','t','e')))
        one=FSet.of(('x',)); bits=FSet.of(('0','1'))
        d=Diagram.build(shape,{'X':one},{'t':fid(one)})
        w=Diagram.build(shape,{'X':bits},{'t':FMap(bits,bits,(('0','1'),('1','0')))})
        n=natural(w,d,{'X':{'0':'x','1':'x'}})
        s=DSpan(d,d,w,n,n)
        c=comparison(s,s)
        self.assertEqual((len(c.cell.source),len(c.cell.target)),(2,1))
        self.assertFalse(c.cell.injective)
        triple=n_comparison((s,s,s))
        self.assertEqual((len(triple.cell.source),len(triple.cell.target)),(4,1))
        self.assertTrue(coherence_check((s,s,s),(0,(1,2))))

    def test_general_shape_three_components(self):
        shape=Shape.bipartite(('S1','S2','A','B','C'),
            (('s1a','S1','A'),('s1b','S1','B'),('s2b','S2','B'),('s2c','S2','C')))
        objs={x:FSet.of(('x',)) for x in shape.objects}
        maps={a.name:FMap(objs[a.source],objs[a.target],(('x','x'),)) for a in shape.arrows}
        d=Diagram(shape,tuple(objs.items()),tuple(maps.items()))
        wobj={x:FSet.of(()) if x.startswith('S') else FSet.of(('x',)) for x in shape.objects}
        wmap={a.name:FMap(wobj[a.source],wobj[a.target],tuple((k,k) for k in wobj[a.source].keys)) for a in shape.arrows}
        w=Diagram(shape,tuple(wobj.items()),tuple(wmap.items()))
        n=natural(w,d,{x:{k:'x' for k in w.obj(x).keys} for x in shape.objects})
        s=DSpan(d,d,w,n,n)
        c=comparison(s,s)
        self.assertEqual((len(c.cell.source),len(c.cell.target)),(3,9))
        self.assertTrue(coherence_check((s,s,s),(0,(1,2))))

    def test_legacy_comparison_commutes_with_explicit_isomorphisms(self):
        from wenhehua.lineage import example_interchange,interchanger,pair_key,horizontal,vertical

        def old_class(q, left, right, pair=False):
            values=set()
            for obj,w in q[1]:
                if obj not in ('L','R'): continue
                key=pair_key(w[1],w[2]) if pair else w
                values.add((left if obj=='L' else right)(key))
            self.assertEqual(len(values),1)
            return values.pop()

        for full in (True,False):
            a,b=example_interchange(full)
            old=interchanger(a,b); new=comparison(from_legacy_step(a),from_legacy_step(b))
            old_a,old_b=horizontal(a),horizontal(b)
            old_local=horizontal(vertical(a,b))
            source_iso={q:old_class(q,old_local.from_left,old_local.from_right,True) for q in new.cell.source.keys}
            target_iso={q:pair_key(old_class(q[1],old_a.from_left,old_a.from_right),
                                  old_class(q[2],old_b.from_left,old_b.from_right)) for q in new.cell.target.keys}
            self.assertEqual(set(source_iso.values()),set(old.comparison.domain.keys()))
            self.assertEqual(set(target_iso.values()),set(old.comparison.codomain.keys()))
            self.assertEqual(len(source_iso),len(set(source_iso.values())))
            self.assertEqual(len(target_iso),len(set(target_iso.values())))
            for q in new.cell.source.keys:
                self.assertEqual(old.comparison(source_iso[q]),target_iso[new.cell(q)])
            self.assertEqual(len(new.cell.source),len(old.comparison.domain))
            self.assertEqual(len(new.cell.target),len(old.comparison.codomain))
            self.assertEqual(new.cell.bijective,old.comparison.bijective)


class TestBeckChevalley(unittest.TestCase):
    def test_full_pullback_has_actual_family_bijection(self):
        from wenhehua.lineage import example_interchange
        a,b=map(from_legacy_step,example_interchange(True))
        family={w:FSet.of(('e1','e2')) for w in colimit(a.witness).apex.keys}
        for v in colimit(b.witness).apex.keys:
            m=beck_chevalley_fiber(a,b,family,v)
            self.assertTrue(m.bijective)
            self.assertEqual(len(m.source),2)

    def test_bc_detects_missing_mixed_histories(self):
        a,b=two_local_events('a'),two_local_events('b')
        family={w:FSet.of(('e',)) for w in colimit(a.witness).apex.keys}
        for v in colimit(b.witness).apex.keys:
            m=beck_chevalley_fiber(a,b,family,v)
            self.assertEqual((len(m.source),len(m.target)),(1,2))
            self.assertFalse(m.surjective)

    def test_bc_detects_merged_local_histories(self):
        a,b=merging_example()
        family={w:FSet.of(('e',)) for w in colimit(a.witness).apex.keys}
        v=colimit(b.witness).apex.keys[0]
        m=beck_chevalley_fiber(a,b,family,v)
        self.assertEqual((len(m.source),len(m.target)),(2,1))
        self.assertFalse(m.injective)

    def test_one_empty_family_is_not_sufficient_to_infer_exactness(self):
        a,b=two_local_events('a'),two_local_events('b')
        family={w:FSet.of(()) for w in colimit(a.witness).apex.keys}
        self.assertFalse(comparison(a,b).cell.bijective)
        for v in colimit(b.witness).apex.keys:
            self.assertTrue(beck_chevalley_fiber(a,b,family,v).bijective)


if __name__=='__main__':
    unittest.main()
