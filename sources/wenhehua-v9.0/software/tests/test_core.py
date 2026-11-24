import unittest
from wenhehua import *

WIRE = Signature(frozenset({'Signal','Energy'}), {'wire': (('Signal',),('Signal',)),
                                                'feed': (('Energy',),('Energy',))})

def link(a='a', b='b', edge='e'):
    return Graph({a:'Signal',b:'Signal'}, {edge:Edge('wire',(a,),(b,))},
                 {'in':a,'out':b})

class GrammarTests(unittest.TestCase):
    def test_glue_nodes_are_identified_and_connections_preserved(self):
        c = glue(WIRE, link(), link('c','d','f'), {'out':'in'})
        self.assertEqual(len(c.nodes),3)
        self.assertEqual(len(c.edges),2)
        self.assertEqual(c.edges['L::e'].targets, c.edges['R::f'].sources)
        self.assertEqual(set(c.ports), {'L.in','R.out'})

    def test_glue_mismatch_fails(self):
        a = link()
        b = Graph({'c':'Energy'}, {}, {'in':'c'})
        with self.assertRaises(GrammarError):
            glue(WIRE, a,b,{'out':'in'})

    def test_bad_port_fails(self):
        with self.assertRaises(GrammarError):
            Graph({'a':'Signal'}, {}, {'out':'nonexistent'}).check(WIRE)

    def test_rewrite_edge_into_two_edges(self):
        l=Graph({'a':'Signal','b':'Signal'},{'e':Edge('wire',('a',),('b',))})
        r=Graph({'a':'Signal','c':'Signal','b':'Signal'},
                {'e1':Edge('wire',('a',),('c',)), 'e2':Edge('wire',('c',),('b',))})
        rule=Rule('insert',l,r,{'a':'a','b':'b'})
        result = rewrite(WIRE,link(),rule)
        self.assertEqual(len(result.nodes),3)
        self.assertEqual(len(result.edges),2)
        self.assertEqual(result.ports['in'],'a')
        self.assertEqual(result.ports['out'],'b')

    def test_rule_interface_must_preserve_types(self):
        l = Graph({'a':'Signal'}, {})
        r = Graph({'a':'Energy'}, {})
        with self.assertRaises(GrammarError):
            Rule('bad',l,r,{'a':'a'}).check(WIRE)

    def test_dangling_host_edge_rejected(self):
        host=Graph({'a':'Signal','b':'Signal','c':'Signal'},
                   {'e':Edge('wire',('a',),('b',)), 'outside':Edge('wire',('c',),('b',))})
        l=Graph({'a':'Signal','b':'Signal'}, {'e':Edge('wire',('a',),('b',))})
        r=Graph({'a':'Signal'},{})
        rule=Rule('delete_b',l,r,{'a':'a'})
        match=Match({'a':'a','b':'b'},{'e':'e'})
        with self.assertRaisesRegex(GrammarError,'dangling edge'):
            rewrite(WIRE,host,rule,match)

    def test_cannot_delete_exposed_port(self):
        l=Graph({'a':'Signal'}, {})
        r=Graph({}, {})
        with self.assertRaisesRegex(GrammarError,'dangling open port'):
            rewrite(WIRE, Graph({'a':'Signal'},{},{'external':'a'}), Rule('del',l,r),Match({'a':'a'},{}))

    def test_match_injective(self):
        l = Graph({'x':'Signal','y':'Signal'},{})
        host = Graph({'a':'Signal'},{})
        self.assertIsNone(match_graph(l,host,WIRE))

    def test_rewrite_disjoint_context_interchange(self):
        l = Graph({'a':'Signal','b':'Signal'}, {'e':Edge('wire',('a',),('b',))})
        r = Graph({'a':'Signal','c':'Signal','b':'Signal'},
                  {'f':Edge('wire',('a',),('c',)), 'g':Edge('wire',('c',),('b',))})
        rho=Rule('split',l,r,{'a':'a','b':'b'})
        before = link()
        context = link('u','v','x')
        left = glue(WIRE, rewrite(WIRE,before,rho),context,{'out':'in'})
        glued = glue(WIRE,before,context,{'out':'in'})
        after = rewrite(WIRE,glued,rho,Match({'a':'L::a','b':'L::b'},{'e':'L::e'}))
        # Edges A->C->B->V in both, with interface endpoints preserved.
        self.assertEqual(len(left.nodes),len(after.nodes))
        self.assertEqual(len(left.edges),len(after.edges))
        import networkx as nx
        def as_incidence(g):
            G=nx.DiGraph()
            for n,k in g.nodes.items(): G.add_node('N:'+n, label='node:'+k)
            for e,edge in g.edges.items():
                G.add_node('E:'+e,label='edge:'+edge.kind)
                for i,n in enumerate(edge.sources):
                    G.add_edge('N:'+n,'E:'+e,label=f'src:{i}')
                for i,n in enumerate(edge.targets):
                    G.add_edge('E:'+e,'N:'+n,label=f'dst:{i}')
            for p,n in g.ports.items():
                G.add_node('P:'+p,label='port:'+p)
                G.add_edge('P:'+p,'N:'+n,label='at')
            return G
        self.assertTrue(nx.is_isomorphic(as_incidence(left),as_incidence(after),
                 node_match=lambda a,b:a['label']==b['label'],
                 edge_match=lambda a,b:a['label']==b['label']))

    def test_abstraction_failure(self):
        states = ('0','1','2')
        f = lambda x: {'0':'1','1':'2','2':'0'}[x]
        alpha = lambda x: {'0':'A','1':'B','2':'A'}[x]
        ok, m, witness = compatible_abstraction(states,f,alpha)
        self.assertFalse(ok)
        self.assertEqual(witness[1], 'A')

    def test_abstraction_success(self):
        states = (0,1,2,3)
        f = lambda x: (x+2)%4
        alpha = lambda x: x%2
        ok, m, witness = compatible_abstraction(states,f,alpha)
        self.assertTrue(ok)
        self.assertIsNone(witness)
        self.assertEqual(m,{0:0,1:1})

    def test_rule_conflict_is_not_false_confluence(self):
        l=Graph({'a':'Signal','b':'Signal'}, {'e':Edge('wire',('a',),('b',))})
        r1=Graph({'a':'Signal','c':'Signal','b':'Signal'},
                 {'f':Edge('wire',('a',),('c',)), 'g':Edge('wire',('c',),('b',))})
        r2=Graph({'a':'Signal','b':'Signal'},{})
        rho=Rule('split',l,r1,{'a':'a','b':'b'})
        sigma=Rule('cut',l,r2,{'a':'a','b':'b'})
        a=rewrite(WIRE,link(),rho)
        b=rewrite(WIRE,link(),sigma)
        self.assertNotEqual(len(a.edges),len(b.edges))
        self.assertEqual(len(b.edges),0)
        # Does not assert non-joinability under arbitrary future rule sets.

if __name__ == '__main__': unittest.main()
