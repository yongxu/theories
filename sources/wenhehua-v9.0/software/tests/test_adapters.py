from __future__ import annotations
import unittest
from wenhehua.core import Graph,Signature,GrammarError
from wenhehua.higher import OpenGraph,horizontal
from wenhehua.adapters import junction,connect_with_adapter

SIG=Signature(frozenset({'N','X'}),{'copy_N':(('N',),('N','N')),
       'merge_N':(('N','N'),('N',)), 'to_X':(('N',),('X',)),
       'source_N':((),('N',)), 'discard_N':(('N',),())})

def endpoint(prefix,ins,outs):
    nodes={};ports={}
    for side,ts in [('in',ins),('out',outs)]:
        for k,t in enumerate(ts):
            n=f'{prefix}_{side}_{k}';nodes[n]=t;ports[f'{side}:{k}']=n
    return OpenGraph(Graph(nodes,{},ports),tuple(ins),tuple(outs))

class AdapterTests(unittest.TestCase):
    def test_fanout_requires_explicit_generator(self):
        a=endpoint('a',('N',),('N',));b=endpoint('b',('N','N'),('N',))
        with self.assertRaises(GrammarError):horizontal(SIG,a,b)
        bridge=junction(SIG,'copy_N',('N',),('N','N'))
        comp=connect_with_adapter(SIG,a,bridge,b)
        comp.check(SIG)
        self.assertEqual(comp.input_types,('N',));self.assertEqual(comp.output_types,('N',))
        self.assertEqual([x.kind for x in comp.graph.edges.values()],['copy_N'])

    def test_merge_requires_explicit_generator(self):
        a=endpoint('a',('N',),('N','N'));b=endpoint('b',('N',),('N',))
        bridge=junction(SIG,'merge_N',('N','N'),('N',))
        comp=connect_with_adapter(SIG,a,bridge,b)
        comp.check(SIG);self.assertEqual(len(comp.graph.edges),1)

    def test_type_conversion_requires_explicit_generator(self):
        a=endpoint('a',('N',),('N',));b=endpoint('b',('X',),('X',))
        with self.assertRaises(GrammarError):horizontal(SIG,a,b)
        bridge=junction(SIG,'to_X',('N',),('X',))
        self.assertEqual(connect_with_adapter(SIG,a,bridge,b).output_types,('X',))

    def test_unknown_copy_not_silently_allowed(self):
        no_copy=Signature(frozenset({'N'}),{})
        with self.assertRaisesRegex(GrammarError,'not declared'):
            junction(no_copy,'copy_N',('N',),('N','N'))

    def test_wrong_arity_rejected(self):
        with self.assertRaisesRegex(GrammarError,'not declared'):
            junction(SIG,'copy_N',('N',),('N',))

    def test_no_conservation_is_inferred(self):
        # Structural modeling admits a named copy hyperedge; caller MUST
        # separately attach and verify resource semantics before execution.
        copy=junction(SIG,'copy_N',('N',),('N','N'))
        self.assertTrue(copy.graph.edges)
        self.assertFalse(hasattr(copy,'resource_preservation_certificate'))

    def test_unit_and_discard_must_be_named(self):
        src=junction(SIG,'source_N',(),('N',))
        sink=junction(SIG,'discard_N',('N',),())
        src.check(SIG);sink.check(SIG)
        self.assertEqual(src.input_types,())
        self.assertEqual(sink.output_types,())

if __name__=='__main__':unittest.main()
