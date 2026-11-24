"""v5 proof-obligation regression: typed finite sets, spans, seams, lax comparison."""
import random
import unittest
from wenhehua.lineage import (
    TSet,TMap,Span,SeamState,SeamStep,LineageError,
    Pushout,identity,identity_span,compose_spans,
    pushout,pullback,horizontal,vertical,interchanger,example_interchange
)

class TestTypedSets(unittest.TestCase):
    def test_duplicate_identifiers_rejected(self):
        with self.assertRaises(LineageError): TSet((('a','T'),('a','T')))

    def test_total_maps_required(self):
        with self.assertRaises(LineageError): TMap(TSet.of(a='T'),TSet.of(z='T'),{})

    def test_type_mismatch_rejected(self):
        with self.assertRaises(LineageError):TMap(TSet.of(a='T'),TSet.of(z='U'),{'a':'z'})

    def test_many_to_one_is_allowed_but_not_injective(self):
        f=TMap(TSet.of(a='T',b='T'),TSet.of(z='T'),{'a':'z','b':'z'})
        self.assertFalse(f.injective)
        self.assertTrue(f.surjective)

    def test_bijection(self):
        f=TMap(TSet.of(a='T',b='T'),TSet.of(x='T',y='T'),{'a':'y','b':'x'})
        self.assertTrue(f.bijective)

class TestUniversalConstructions(unittest.TestCase):
    def test_pushout_single_join(self):
        j=TSet.of(j='T');l=TSet.of(a='T',b='T');r=TSet.of(c='T')
        q=pushout(j,l,r,TMap(j,l,{'j':'a'}),TMap(j,r,{'j':'c'}))
        self.assertEqual(len(q.apex),2)
        self.assertEqual(q.left('a'),q.right('c'))
        self.assertNotEqual(q.left('b'),q.right('c'))

    def test_pushout_empty_disjoint(self):
        j=TSet(()) ;l=TSet.of(a='T');r=TSet.of(a='T')
        q=pushout(j,l,r,TMap(j,l,{}),TMap(j,r,{}))
        self.assertEqual(len(q.apex),2)
        self.assertNotEqual(q.left('a'),q.right('a'))

    def test_pushout_many_to_one_explicit_quotient(self):
        j=TSet.of(j1='T',j2='T');l=TSet.of(x='T',y='T');r=TSet.of(z='T')
        q=pushout(j,l,r,TMap(j,l,{'j1':'x','j2':'y'}),
                   TMap(j,r,{'j1':'z','j2':'z'}))
        self.assertEqual(len(q.apex),1)
        self.assertEqual(q.left('x'),q.left('y'))

    def test_pullback_matches_not_cartesian_product(self):
        a=TSet.of(x='T',y='T');b=TSet.of(z='T');m=TSet.of(p='T',q='T')
        x=TMap(a,m,{'x':'p','y':'q'});y=TMap(b,m,{'z':'q'})
        p=pullback(x,y)
        self.assertEqual(len(p.object),1)
        self.assertEqual(p.first(p.object.keys()[0]),'y')

    def test_pullback_duplicate_witnesses_retained(self):
        a=TSet.of(x='T',y='T');b=TSet.of(u='T',v='T');m=TSet.of(p='T')
        p=pullback(TMap(a,m,{'x':'p','y':'p'}),TMap(b,m,{'u':'p','v':'p'}))
        self.assertEqual(len(p.object),4)

class TestSpanAlgebra(unittest.TestCase):
    def test_identity_unit_right(self):
        a=TSet.of(a='T');b=TSet.of(b='T');w=TSet.of(p='T',q='T')
        s=Span(a,b,w,TMap(w,a,{'p':'a','q':'a'}),TMap(w,b,{'p':'b','q':'b'}))
        self.assertEqual(compose_spans(s,identity_span(b)).signature(),s.signature())

    def test_identity_unit_left(self):
        a=TSet.of(a='T');b=TSet.of(b='T');w=TSet.of(p='T',q='T')
        s=Span(a,b,w,TMap(w,a,{'p':'a','q':'a'}),TMap(w,b,{'p':'b','q':'b'}))
        self.assertEqual(compose_spans(identity_span(a),s).signature(),s.signature())

    def test_temporal_composition_preserves_two_paths(self):
        a=TSet.of(a='T');b=TSet.of(x='T',y='T');c=TSet.of(c='T')
        w1=TSet.of(u='T',v='T');w2=TSet.of(p='T',q='T')
        x=Span(a,b,w1,TMap(w1,a,{'u':'a','v':'a'}),TMap(w1,b,{'u':'x','v':'y'}))
        y=Span(b,c,w2,TMap(w2,b,{'p':'x','q':'y'}),TMap(w2,c,{'p':'c','q':'c'}))
        composite=compose_spans(x,y)
        self.assertEqual(len(composite.witness),2)
        self.assertEqual(sum(composite.signature().values()),2)
        self.assertEqual(len(set((composite.to_before(t),composite.to_after(t))
                                 for t in composite.witness.keys())),1)

    def test_composition_rejects_incorrect_middle(self):
        a=TSet.of(a='T');b=TSet.of(b='T');c=TSet.of(c='T')
        with self.assertRaises(LineageError):compose_spans(identity_span(a),identity_span(b))

    def test_random_associativity_up_to_witness_isomorphism(self):
        rng=random.Random(2042)
        xs=[TSet.of(**{f'{chr(97+i)}{j}':'T' for j in range(2)}) for i in range(4)]
        def random_span(a,b,k):
            w=TSet.of(**{f'w{k}_{j}':'T' for j in range(rng.randrange(5))})
            return Span(a,b,w,TMap(w,a,{u:rng.choice(a.keys()) for u in w.keys()}),
                        TMap(w,b,{u:rng.choice(b.keys()) for u in w.keys()}))
        for k in range(250):
            s=[random_span(xs[i],xs[i+1],10*k+i) for i in range(3)]
            left=compose_spans(compose_spans(s[0],s[1]),s[2])
            right=compose_spans(s[0],compose_spans(s[1],s[2]))
            self.assertEqual(left.signature(),right.signature())

class TestChangingSeam(unittest.TestCase):
    def test_full_seam_interchange_bijective(self):
        a,b=example_interchange(True)
        c=interchanger(a,b)
        self.assertEqual((len(c.horizontal_after_vertical.witness),
                          len(c.vertical_after_horizontal.witness)),(1,1))
        self.assertTrue(c.invertible)

    def test_mixed_handoff_noninvertible(self):
        a,b=example_interchange(False)
        c=interchanger(a,b)
        self.assertEqual(len(c.horizontal_after_vertical.witness),0)
        self.assertEqual(len(c.vertical_after_horizontal.witness),1)
        self.assertEqual(c.extra_mixed_histories,1)
        self.assertFalse(c.invertible)

    def test_nonempty_seam_with_no_lineage_is_permitted(self):
        a,b=example_interchange(False)
        self.assertEqual(len(a.old.seam),1)
        self.assertEqual(len(a.seam.witness),0)
        self.assertEqual(len(b.seam.witness),0)

    def test_bad_square_rejected(self):
        # Seam witness maps to a local event that arrives at the wrong new node.
        a,b=example_interchange(True)
        wrong=TSet.of(l='T',other='T')
        wrongnew=SeamState(a.new.seam,wrong,a.new.right,
            TMap(a.new.seam,wrong,{'j':'other'}),a.new.seam_to_right)
        altered_left=Span(a.old.left,wrong,a.left.witness,a.left.to_before,
            TMap(a.left.witness,wrong,{'left1':'l'}))
        with self.assertRaises(LineageError):
            SeamStep(a.old,wrongnew,altered_left,a.seam,a.right,a.seam_to_left,a.seam_to_right)

    def test_global_comparison_respects_both_endpoints(self):
        a,b=example_interchange(True)
        c=interchanger(a,b)
        for p in c.comparison.domain.keys():
            q=c.comparison(p)
            self.assertEqual(c.horizontal_after_vertical.to_before(p),
                             c.vertical_after_horizontal.to_before(q))
            self.assertEqual(c.horizontal_after_vertical.to_after(p),
                             c.vertical_after_horizontal.to_after(q))

    def test_same_label_not_automatically_identity(self):
        a,b=example_interchange(False)
        self.assertEqual(a.old,b.new)
        # Despite all interface labels/states equal, lineage witness is empty.
        self.assertEqual(len(a.seam.witness),0)

    def test_random_interchangers_are_well_defined(self):
        rng=random.Random(20261124)
        j=TSet.of(j='T');l=TSet.of(l='T');r=TSet.of(r='T')
        state=SeamState(j,l,r,TMap(j,l,{'j':'l'}),TMap(j,r,{'j':'r'}))
        def step(seed):
            nl=rng.randrange(4);nr=rng.randrange(4)
            nt=rng.randrange(3) if nl and nr else 0
            def sp(x,n,name):
                w=TSet(tuple((f'{name}{i}','T') for i in range(n)))
                d={k:x.keys()[0] for k in w.keys()}
                return Span(x,x,w,TMap(w,x,d),TMap(w,x,d))
            la=sp(l,nl,f'a{seed}_');rb=sp(r,nr,f'b{seed}_');st=sp(j,nt,f's{seed}_')
            return SeamStep(state,state,la,st,rb,
              TMap(st.witness,la.witness,{w:rng.choice(la.witness.keys()) for w in st.witness.keys()}),
              TMap(st.witness,rb.witness,{w:rng.choice(rb.witness.keys()) for w in st.witness.keys()}))
        saw_noniso=False;saw_iso=False
        for k in range(250):
            c=interchanger(step(2*k),step(2*k+1))
            self.assertGreaterEqual(c.extra_mixed_histories,0)
            saw_iso|=c.invertible;saw_noniso|=not c.invertible
        self.assertTrue(saw_iso and saw_noniso)

if __name__=='__main__':unittest.main()
