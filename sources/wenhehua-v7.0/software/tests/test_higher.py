"""Tests for the finite fragment of monic spans of cospans.

These are implementation regression tests and finite instances of the laws,
NOT a machine-checked proof of the entire bicategorical construction.
"""
from __future__ import annotations
import random
import unittest

from wenhehua.core import Graph, Edge, Signature, Match, GrammarError
from wenhehua.higher import (OpenGraph, Change, horizontal, horizontal_change,
                             vertical_change, signature, isomorphic_witness,
                             open_graph_isomorphic)

SIG = Signature(frozenset({'N','X'}), {
    'wire': (('N',),('N',)),
    'mark': (('N',),('X',)),
})


def network(prefix: str) -> OpenGraph:
    a,b = prefix+'a', prefix+'b'
    return OpenGraph(Graph({a:'N',b:'N'},
        {prefix+'e':Edge('wire',(a,),(b,))},
        {'in:0':a,'out:0':b}), ('N',), ('N',))


def modify(before: OpenGraph, prefix: str, *, delete_edge: bool = False) -> Change:
    """DPO-compatible graph edit: preserve boundary; add one private marked node."""
    old=before.graph
    nodes=dict(old.nodes); edges=dict(old.edges)
    if delete_edge:
        edge_to_remove=sorted(edges)[0]
        del edges[edge_to_remove]
    else:
        edge_to_remove=None
    added=prefix+'private'
    added_edge=prefix+'mark'
    if added in nodes or added_edge in edges:
        raise RuntimeError('unexpected namespace collision')
    nodes[added]='X'
    edges[added_edge]=Edge('mark',(old.ports['out:0'],),(added,))
    after=OpenGraph(Graph(nodes,edges,dict(old.ports)),
                    before.input_types,before.output_types)
    kept_edges={k:v for k,v in old.edges.items() if k != edge_to_remove}
    common=Graph(dict(old.nodes),kept_edges)
    result=Change(before, after, common,
       Match({k:k for k in common.nodes},{k:k for k in common.edges}),
       Match({k:k for k in common.nodes},{k:k for k in common.edges}))
    result.check(SIG)
    return result


class TestHigher(unittest.TestCase):
    def test_identity_wire(self):
        ident=OpenGraph.identity(SIG, ('N','X'))
        ident.check(SIG)
        self.assertEqual(len(ident.graph.nodes),2)
        self.assertEqual(ident.graph.ports['in:0'],ident.graph.ports['out:0'])

    def test_identity_horizontal_left_and_right(self):
        a=network('a'); ia=OpenGraph.identity(SIG, ('N',))
        self.assertTrue(open_graph_isomorphic(SIG, horizontal(SIG,ia,a), a))
        self.assertTrue(open_graph_isomorphic(SIG, horizontal(SIG,a,ia), a))

    def test_composition_associativity_up_to_interface_iso(self):
        a,b,c=network('a'),network('b'),network('c')
        l=horizontal(SIG,horizontal(SIG,a,b),c)
        r=horizontal(SIG,a,horizontal(SIG,b,c))
        self.assertNotEqual(set(l.graph.nodes),set(r.graph.nodes))
        self.assertTrue(open_graph_isomorphic(SIG,l,r))

    def test_incompatible_interface_refused(self):
        self.assertRaises(GrammarError,horizontal,SIG,network('a'),
                          OpenGraph.identity(SIG,('X',)))

    def test_monotone_change_witness(self):
        a=network('a'); ch=modify(a,'extra')
        self.assertEqual(len(ch.common.nodes),2)
        self.assertEqual(len(ch.after.graph.nodes),3)
        self.assertEqual(len(ch.after.graph.edges),2)

    def test_identity_change(self):
        a=network('a'); ident=Change.identity(SIG,a)
        self.assertTrue(isomorphic_witness(SIG,ident,ident))
        self.assertEqual(len(ident.common.edges),1)

    def test_horizontal_change_exposes_external_ports_only(self):
        a,b=modify(network('a'),'a2'),modify(network('b'),'b2')
        h=horizontal_change(SIG,a,b)
        self.assertEqual(set(h.before.graph.ports),{'in:0','out:0'})
        self.assertEqual(len(h.common.nodes),3)
        self.assertEqual(len(h.after.graph.nodes),5)

    def test_interchange_four_square(self):
        a1=modify(network('a'),'a1')
        a2=modify(a1.after,'a2')
        b1=modify(network('b'),'b1')
        b2=modify(b1.after,'b2')
        first=horizontal_change(SIG,vertical_change(SIG,a1,a2),
                                     vertical_change(SIG,b1,b2))
        second=vertical_change(SIG,horizontal_change(SIG,a1,b1),
                                     horizontal_change(SIG,a2,b2))
        self.assertTrue(isomorphic_witness(SIG,first,second))
        self.assertEqual(len(signature(first)[0]),len(signature(second)[0]))

    def test_interchange_includes_deletion(self):
        a1=modify(network('a'),'a1',delete_edge=True)
        a2=modify(a1.after,'a2')
        b1=modify(network('b'),'b1',delete_edge=True)
        b2=modify(b1.after,'b2')
        self.assertTrue(isomorphic_witness(SIG,
           horizontal_change(SIG,vertical_change(SIG,a1,a2),
                                 vertical_change(SIG,b1,b2)),
           vertical_change(SIG,horizontal_change(SIG,a1,b1),
                                horizontal_change(SIG,a2,b2))))

    def test_vertical_identity(self):
        a=modify(network('a'),'x')
        self.assertTrue(isomorphic_witness(SIG,
            vertical_change(SIG,Change.identity(SIG,a.before),a),a))
        self.assertTrue(isomorphic_witness(SIG,
            vertical_change(SIG,a,Change.identity(SIG,a.after)),a))

    def test_vertical_associativity(self):
        a=modify(network('a'),'x')
        b=modify(a.after,'y')
        c=modify(b.after,'z')
        left=vertical_change(SIG,vertical_change(SIG,a,b),c)
        right=vertical_change(SIG,a,vertical_change(SIG,b,c))
        self.assertTrue(isomorphic_witness(SIG,left,right))

    def test_boundary_deletion_rejected(self):
        a=network('a')
        before=a.graph
        other=OpenGraph(Graph({k:v for k,v in before.nodes.items()},
                              dict(before.edges),dict(before.ports)),('N',),('N',))
        bad=Change(a,other,Graph({ 'aa':'N' }, {}),
            Match({'aa':'aa'},{}), Match({'aa':'aa'},{}))
        self.assertRaises(GrammarError,bad.check,SIG)

    def test_nonmonic_span_rejected(self):
        a=network('a')
        bad=Change(a,a,Graph({'x':'N','y':'N'},{}),
           Match({'x':'aa','y':'aa'},{}),Match({'x':'aa','y':'aa'},{}))
        self.assertRaises(GrammarError,bad.check,SIG)

    def test_wrong_incidence_rejected(self):
        a=network('a')
        bad=Change(a,a,Graph({'x':'N','y':'N'},
             {'e':Edge('wire',('x',),('y',))}),
           Match({'x':'ab','y':'aa'},{'e':'ae'}),
           Match({'x':'ab','y':'aa'},{'e':'ae'}))
        self.assertRaises(GrammarError,bad.check,SIG)

    def test_vertical_requires_identical_middle_presentation(self):
        a=modify(network('a'),'x')
        b=modify(network('b'),'y')
        self.assertRaises(GrammarError,vertical_change,SIG,a,b)

    def test_connectable_does_not_imply_global_invariant(self):
        a,b=network('a'),network('b')
        # P(graph): at most 1 distinct incoming wire per node.
        def p(n):
            return all(sum(1 for e in n.graph.edges.values()
                    if edge_node in e.targets and e.kind=='wire') <= 1
                    for edge_node in n.graph.nodes)
        self.assertTrue(p(a)); self.assertTrue(p(b))
        # Ordinary sequential composition also happens to preserve P here;
        # a separate network shows a context may add an incoming link to the joint.
        # Another component can already have an incoming edge into its input.
        # Both components separately satisfy P; after gluing, the identified
        # shared node receives two incoming edges (from a and from b.helper).
        b2=Graph(dict(b.graph.nodes),dict(b.graph.edges),dict(b.graph.ports))
        b2.nodes['bhelper']='N'
        b2.edges['bhelper_edge']=Edge('wire',('bhelper',),(b2.ports['in:0'],))
        b=OpenGraph(b2,b.input_types,b.output_types)
        self.assertTrue(p(a)); self.assertTrue(p(b))
        joint=horizontal(SIG,a,b)
        self.assertFalse(p(joint))

    def test_interfaces_are_semantic_identities(self):
        a=network('a')
        b=network('b')
        self.assertTrue(open_graph_isomorphic(SIG,a,b))
        remapped=OpenGraph(Graph(dict(a.graph.nodes),dict(a.graph.edges),
                         {'in:0':a.graph.ports['out:0'],
                          'out:0':a.graph.ports['in:0']}),('N',),('N',))
        self.assertFalse(open_graph_isomorphic(SIG,a,remapped))


if __name__ == '__main__': unittest.main()
