from __future__ import annotations
import unittest
from wenhehua.core import Edge,Graph,Signature,Match,GrammarError
from wenhehua.higher import OpenGraph,horizontal
from wenhehua.evolving import (InterfaceTrace,Evolution,horizontal_evolution,vertical_evolution)

SIG=Signature(frozenset({'N'}),{'w':(('N',),('N',))})

def net(p):
    a,b=p+'a',p+'b'
    return OpenGraph(Graph({a:'N',b:'N'}, {p+'w':Edge('w',(a,),(b,))},
                           {'in:0':a,'out:0':b}),('N',),('N',))

def expose_extra(original,tag,side='in'):
    gr=original.graph; new=tag+'node'
    nn=dict(gr.nodes); nn[new]='N'
    ee=dict(gr.edges);ee[tag+'edge']=Edge('w',
          (new,),(gr.ports['out:0'],)) if side=='in' else Edge('w',(gr.ports['in:0'],),(new,))
    pp=dict(gr.ports);pp[f'{side}:1']=new
    aft=OpenGraph(Graph(nn,ee,pp),
          original.input_types+(('N',) if side=='in' else ()),
          original.output_types+(('N',) if side=='out' else ()))
    com=Graph(dict(gr.nodes),dict(gr.edges))
    m=Match({n:n for n in com.nodes},{e:e for e in com.edges})
    tr=InterfaceTrace(((0,0),),((0,0),))
    ev=Evolution(original,aft,com,m,m,tr);ev.check(SIG);return ev

class TestEvolving(unittest.TestCase):
    def test_identity(self):
        x=net('a');e=Evolution.identity(SIG,x);self.assertEqual(e.trace.inputs,((0,0),))
    def test_gain_input(self):
        e=expose_extra(net('a'),'new','in');self.assertEqual(len(e.after.input_types),2)
    def test_gain_output(self):
        e=expose_extra(net('a'),'new','out');self.assertEqual(len(e.after.output_types),2)
    def test_remove_output(self):
        e=expose_extra(net('a'),'new','out')
        gr=e.after.graph;pp=dict(gr.ports);del pp['out:1']
        aft=OpenGraph(Graph(dict(gr.nodes),dict(gr.edges),pp),('N',),('N',))
        common=Graph(dict(gr.nodes),dict(gr.edges))
        m=Match({n:n for n in common.nodes},{n:n for n in common.edges})
        ch=Evolution(e.after,aft,common,m,m,InterfaceTrace(((0,0),),((0,0),)))
        ch.check(SIG)
    def test_remove_node_and_port(self):
        e=expose_extra(net('a'),'new','out')
        rec=Evolution(e.after,e.before,e.common,e.into_after,e.into_before,
                      InterfaceTrace(((0,0),),((0,0),)))
        rec.check(SIG)
    def test_noninjective_trace_rejected(self):
        e=expose_extra(net('a'),'new','out');e.trace=InterfaceTrace(((0,0),),((0,0),(0,1)))
        with self.assertRaises(GrammarError):e.check(SIG)
    def test_trace_type_mismatch(self):
        e=expose_extra(net('a'),'new','out');e.trace=InterfaceTrace(((0,0),),((0,1),))
        with self.assertRaises(GrammarError):e.check(SIG)
    def test_trace_missing_witness(self):
        e=expose_extra(net('a'),'new','out')
        e.into_after=Match({**e.into_after.nodes, 'ab':'aa'},e.into_after.edges)
        with self.assertRaises(GrammarError):e.check(SIG)
    def test_horizontal_preserves_seam_allows_outer_changes(self):
        x=expose_extra(net('a'),'addedA','in')
        y=expose_extra(net('b'),'addedB','out')
        z=horizontal_evolution(SIG,x,y)
        self.assertEqual(z.before.input_types,('N',))
        self.assertEqual(z.after.input_types,('N','N'))
        self.assertEqual(z.after.output_types,('N','N'))
        self.assertEqual(z.trace.inputs,((0,0),))
        z.check(SIG)
        self.assertEqual(len(z.before.graph.nodes),3)
        self.assertEqual(len(z.after.graph.nodes),5)
    def test_horizontal_seam_change_rejected(self):
        a=expose_extra(net('a'),'extraA','out'); b=net('b')
        y=Evolution.identity(SIG,b)
        with self.assertRaises(GrammarError):horizontal_evolution(SIG,a,y)
    def test_horizontal_trace_disagreement(self):
        a=Evolution.identity(SIG,net('a'))
        b=Evolution.identity(SIG,net('b'))
        b.trace=InterfaceTrace((),((0,0),))
        with self.assertRaises(GrammarError):horizontal_evolution(SIG,a,b)
    def test_vertical_growth_then_loss(self):
        a=expose_extra(net('a'),'new','out')
        b=Evolution(a.after,a.before,a.common,a.into_after,a.into_before,
                    InterfaceTrace(((0,0),),((0,0),)))
        c=vertical_evolution(SIG,a,b)
        c.check(SIG)
        self.assertEqual(c.trace.outputs,((0,0),))
    def test_vertical_identity(self):
        a=expose_extra(net('a'),'new','out')
        c=vertical_evolution(SIG,Evolution.identity(SIG,a.before),a)
        c.check(SIG);self.assertEqual(c.trace.outputs,((0,0),))
    def test_horizontal_evolving_identity(self):
        a=Evolution.identity(SIG,net('a')); b=Evolution.identity(SIG,net('b'))
        c=horizontal_evolution(SIG,a,b);c.check(SIG)
        self.assertEqual(c.before,c.after)
    def test_nonpreserved_port_cannot_be_misdeclared(self):
        a=expose_extra(net('a'),'new','out')
        # An old in:0 and a new out:1 cannot be matched as output identities.
        a.trace=InterfaceTrace(((0,0),),((0,1),))
        with self.assertRaises(GrammarError):a.check(SIG)

if __name__=='__main__':unittest.main()

class TestEvolutionLaws(unittest.TestCase):
    def test_trace_composition_is_associative(self):
        a=InterfaceTrace(((0,1),(1,0)),((0,0),))
        b=InterfaceTrace(((1,0),(0,1)),((0,0),))
        c=InterfaceTrace(((0,1),),((0,0),))
        self.assertEqual(a.then(b).then(c),a.then(b.then(c)))

    def test_interchange_stable_seam_with_outer_growth(self):
        from wenhehua.higher import signature
        def add_private(ev,prefix):
            old=ev.after;g=old.graph
            nn=dict(g.nodes);nn[prefix+'n']='N'
            ee=dict(g.edges)
            ee[prefix+'e']=Edge('w',(old.graph.ports['in:0'],),(prefix+'n',))
            aft=OpenGraph(Graph(nn,ee,dict(g.ports)), old.input_types,old.output_types)
            common=Graph(dict(g.nodes),dict(g.edges))
            m=Match({k:k for k in common.nodes},{k:k for k in common.edges})
            out=Evolution(old,aft,common,m,m,InterfaceTrace.identity(old))
            out.check(SIG);return out
        a=expose_extra(net('a'),'gain_a','in');b=add_private(a,'private_a')
        c=expose_extra(net('b'),'gain_b','out');d=add_private(c,'private_b')
        left=horizontal_evolution(SIG,vertical_evolution(SIG,a,b),vertical_evolution(SIG,c,d))
        right=vertical_evolution(SIG,horizontal_evolution(SIG,a,c),horizontal_evolution(SIG,b,d))
        left.check(SIG);right.check(SIG)
        self.assertEqual(left.before,right.before)
        self.assertEqual(left.after,right.after)
        self.assertEqual(left.trace,right.trace)
        self.assertEqual(signature(left),signature(right))

    def test_permuted_stable_seam_supported(self):
        # A seam with two ports, both retained but reordered *identically*.
        aa=OpenGraph(Graph({'la':'N','lb':'N','lc':'N'}, {},
                          {'in:0':'la','out:0':'lb','out:1':'lc'}),('N',),('N','N'))
        bb=OpenGraph(Graph({'ra':'N','rb':'N','rc':'N'}, {},
                          {'in:0':'ra','in:1':'rb','out:0':'rc'}),('N','N'),('N',))
        def permute(x,side):
            gr=x.graph;pp=dict(gr.ports)
            if side=='out':
                pp['out:0'],pp['out:1']=pp['out:1'],pp['out:0']
                tr=InterfaceTrace(((0,0),),((0,1),(1,0)))
            else:
                pp['in:0'],pp['in:1']=pp['in:1'],pp['in:0']
                tr=InterfaceTrace(((0,1),(1,0)),((0,0),))
            new=OpenGraph(Graph(dict(gr.nodes),dict(gr.edges),pp),x.input_types,x.output_types)
            co=Graph(dict(gr.nodes),dict(gr.edges))
            m=Match({n:n for n in co.nodes},{e:e for e in co.edges})
            return Evolution(x,new,co,m,m,tr)
        left,right=permute(aa,'out'),permute(bb,'in')
        ev=horizontal_evolution(SIG,left,right)
        ev.check(SIG);self.assertEqual(ev.trace.inputs,((0,0),))

class TestIdentityPersistence(unittest.TestCase):
    def test_reappearing_same_port_label_is_not_automatically_same_identity(self):
        old=OpenGraph(Graph({'a':'N','b':'N'}, {},{'in:0':'a','out:0':'a','out:1':'b'}),('N',),('N','N'))
        middle=OpenGraph(Graph({'a':'N'}, {},{'in:0':'a','out:0':'a'}),('N',),('N',))
        after=OpenGraph(Graph({'a':'N','b':'N'}, {},{'in:0':'a','out:0':'a','out:1':'b'}),('N',),('N','N'))
        c1=Graph({'a':'N'},{});m1=Match({'a':'a'}, {})
        drop=Evolution(old,middle,c1,m1,m1,InterfaceTrace(((0,0),),((0,0),)))
        rise=Evolution(middle,after,c1,m1,m1,InterfaceTrace(((0,0),),((0,0),)))
        total=vertical_evolution(SIG,drop,rise)
        self.assertEqual(total.trace.outputs,((0,0),))
        self.assertNotIn((1,1),total.trace.outputs)

class TestTypeTraceSafety(unittest.TestCase):
    def test_actual_type_changed_cannot_be_marked_persistent(self):
        from wenhehua.evolving import _pair_check
        with self.assertRaisesRegex(GrammarError,'trace type mismatch'):
            _pair_check(('Celsius',),('Kelvin',),((0,0),),'input')
