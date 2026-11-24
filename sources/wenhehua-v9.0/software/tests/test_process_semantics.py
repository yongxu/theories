import unittest
from wenhehua.core import Graph, Edge, Match
from wenhehua.higher import OpenGraph, Change, horizontal
from wenhehua.process_semantics import one_port_reachable,preserves_reachability
from test_higher import SIG, network,modify

class TestProcessSemantics(unittest.TestCase):
    def test_reachability_horizontal_is_and(self):
        a=network('a')
        b=network('b')
        self.assertEqual(one_port_reachable(SIG,horizontal(SIG,a,b)),
                         one_port_reachable(SIG,a) and one_port_reachable(SIG,b))
        b_broken=OpenGraph(Graph(dict(b.graph.nodes),{},dict(b.graph.ports)),('N',),('N',))
        self.assertEqual(one_port_reachable(SIG,horizontal(SIG,a,b_broken)),
                         one_port_reachable(SIG,a) and one_port_reachable(SIG,b_broken))
        self.assertFalse(one_port_reachable(SIG,horizontal(SIG,a,b_broken)))

    def test_witness_does_not_guarantee_behavioral_equivalence(self):
        a=network('a')
        a2=OpenGraph(Graph(dict(a.graph.nodes),{},dict(a.graph.ports)),('N',),('N',))
        common=Graph(dict(a.graph.nodes),{})
        m=Match({n:n for n in common.nodes},{})
        change=Change(a,a2,common,m,m)
        self.assertTrue(change.check(SIG) is None)
        self.assertFalse(preserves_reachability(SIG,change))

    def test_add_unused_structure_can_preserve_behavior(self):
        a=network('a')
        after=OpenGraph(Graph({**a.graph.nodes,'extra':'N'},dict(a.graph.edges),
                              dict(a.graph.ports)),a.input_types,a.output_types)
        common=Graph(dict(a.graph.nodes),dict(a.graph.edges))
        m=Match({n:n for n in common.nodes},{e:e for e in common.edges})
        change=Change(a,after,common,m,m)
        self.assertTrue(preserves_reachability(SIG,change))

if __name__=='__main__':unittest.main()
