"""Deterministic small exhaustive families; not a proof for arbitrary graphs."""
from __future__ import annotations
import unittest
from wenhehua.core import Graph,Match,Signature
from wenhehua.higher import OpenGraph
from wenhehua.evolving import Evolution,InterfaceTrace,horizontal_evolution
from wenhehua.seams import SeamContract,horizontal_changing_seam

SIG=Signature(frozenset({'N','T'}),{})

def make(side,k,tag):
    types=tuple('N' if i%2==0 else 'T' for i in range(k))
    nodes={f'{tag}_outer':'N'};ports={}
    if side=='left':
        ports['in:0']=f'{tag}_outer'
        for i,t in enumerate(types):
            n=f'{tag}_s_{i}';nodes[n]=t;ports[f'out:{i}']=n
        return OpenGraph(Graph(nodes,{},ports),('N',),types)
    ports['out:0']=f'{tag}_outer'
    for i,t in enumerate(types):
        n=f'{tag}_s_{i}';nodes[n]=t;ports[f'in:{i}']=n
    return OpenGraph(Graph(nodes,{},ports),types,('N',))

def shared(before,after,side,preserve):
    c_nodes={'outer':'N'}
    mb={'outer':before.graph.ports['in:0' if side=='left' else 'out:0']}
    ma={'outer':after.graph.ports['in:0' if side=='left' else 'out:0']}
    for i in range(preserve):
        typ=before.output_types[i] if side=='left' else before.input_types[i]
        c_nodes[f'c{i}']=typ
        p=f'out:{i}' if side=='left' else f'in:{i}'
        mb[f'c{i}']=before.graph.ports[p]
        ma[f'c{i}']=after.graph.ports[p]
    matched=tuple((i,i) for i in range(preserve))
    tr=InterfaceTrace(((0,0),),matched) if side=='left' else InterfaceTrace(matched,((0,0),))
    e=Evolution(before,after,Graph(c_nodes,{}),Match(mb,{}),Match(ma,{}),tr)
    e.check(SIG)
    return e

class ExhaustiveSmallFamilies(unittest.TestCase):
    def test_shared_seam_growth_0_to_4(self):
        for n in range(5):
            for m in range(n,5):
                with self.subTest(old=n,new=m):
                    le=shared(make('left',n,'L0'),make('left',m,'L1'),'left',n)
                    ri=shared(make('right',n,'R0'),make('right',m,'R1'),'right',n)
                    out=horizontal_changing_seam(SIG,le,ri,SeamContract(tuple((i,i) for i in range(n))))
                    out.check(SIG)
                    self.assertEqual(len(out.before.graph.nodes),2+n)
                    self.assertEqual(len(out.after.graph.nodes),2+m)
                    self.assertEqual(len(out.common.nodes),2+n)

    def test_shared_seam_shrink_0_to_4(self):
        for n in range(5):
            for m in range(n+1):
                with self.subTest(old=n,new=m):
                    le=shared(make('left',n,'L0'),make('left',m,'L1'),'left',m)
                    ri=shared(make('right',n,'R0'),make('right',m,'R1'),'right',m)
                    out=horizontal_changing_seam(SIG,le,ri,SeamContract(tuple((i,i) for i in range(m))))
                    out.check(SIG)
                    self.assertEqual(len(out.before.graph.nodes),2+n)
                    self.assertEqual(len(out.after.graph.nodes),2+m)
                    self.assertEqual(len(out.common.nodes),2+m)

    def test_identity_is_backward_compatible(self):
        for n in range(5):
            with self.subTest(n=n):
                l=Evolution.identity(SIG,make('left',n,'L'))
                r=Evolution.identity(SIG,make('right',n,'R'))
                out=horizontal_changing_seam(SIG,l,r,SeamContract(tuple((i,i) for i in range(n))))
                old=horizontal_evolution(SIG,l,r)
                self.assertEqual(out.before,old.before)
                self.assertEqual(out.after,old.after)
                self.assertEqual(out.trace,old.trace)
                self.assertEqual(len(out.common.nodes),len(old.common.nodes))
