"""Reproducible high-order interchange demonstration."""
from wenhehua.higher import (horizontal_change, vertical_change, horizontal,
    isomorphic_witness, open_graph_isomorphic)
from tests.test_higher import SIG, network, modify

a1=modify(network('a'),'a1')
a2=modify(a1.after,'a2')
b1=modify(network('b'),'b1')
b2=modify(b1.after,'b2')
left=horizontal_change(SIG, vertical_change(SIG,a1,a2),vertical_change(SIG,b1,b2))
right=vertical_change(SIG,horizontal_change(SIG,a1,b1),horizontal_change(SIG,a2,b2))
print('Interchange square (fixed boundary, monic spans):',isomorphic_witness(SIG,left,right))
print('Two-stage preserved vertices:',len(left.common.nodes))
print('After-gluing nodes:',len(left.after.graph.nodes))
a,b,c=network('a'),network('b'),network('c')
print('Associativity up to boundary-aware graph isomorphism:',
      open_graph_isomorphic(SIG,horizontal(SIG,horizontal(SIG,a,b),c),
                              horizontal(SIG,a,horizontal(SIG,b,c))))
