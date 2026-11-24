"""Reproducible shared seam evolution example (no external dependencies)."""
from __future__ import annotations
import json
from wenhehua import Signature,Graph,Match,GrammarError
from wenhehua.higher import OpenGraph
from wenhehua.evolving import Evolution,InterfaceTrace
from wenhehua.seams import SeamContract,horizontal_changing_seam
from wenhehua.adapters import junction,connect_with_adapter

sig=Signature(frozenset({'N','T'}),{'copy_N':(('N',),('N','N'))})

def open_case(side:str, newly:bool):
    if side=='left':
        node={'outer':'N','seam':'N'}
        if newly:node['new_seam']='T'
        port={'in:0':'outer','out:0':'seam'}
        if newly:port['out:1']='new_seam'
        return OpenGraph(Graph(node,{},port),('N',),('N','T') if newly else ('N',))
    node={'seam':'N','outer':'N'}
    if newly:node['new_seam']='T'
    port={'in:0':'seam','out:0':'outer'}
    if newly:port['in:1']='new_seam'
    return OpenGraph(Graph(node,{},port),('N','T') if newly else ('N',),('N',))

def growth(before,after,side):
    common=Graph({'outer':'N','seam':'N'},{})
    m=Match({'outer':'outer','seam':'seam'},{})
    trace=(InterfaceTrace(((0,0),),((0,0),)) if side=='left'
           else InterfaceTrace(((0,0),),((0,0),)))
    e=Evolution(before,after,common,m,m,trace)
    e.check(sig);return e

left=growth(open_case('left',False),open_case('left',True),'left')
right=growth(open_case('right',False),open_case('right',True),'right')
composite=horizontal_changing_seam(sig,left,right,SeamContract(((0,0),)))
composite.check(sig)

# Two wires into a two-input process: explicit declared copy hyperedge.
a=OpenGraph(Graph({'i':'N','o':'N'},{},{'in:0':'i','out:0':'o'}),('N',),('N',))
b=OpenGraph(Graph({'i':'N','j':'N','o':'N'},{},
                   {'in:0':'i','in:1':'j','out:0':'o'}),('N','N'),('N',))
copier=junction(sig,'copy_N',('N',),('N','N'))
mediated=connect_with_adapter(sig,a,copier,b)

result={
 'case':'new seam type T added while persistent N seam remains',
 'seam_trace':list(composite.trace.inputs),
 'old_seam_arity':len(left.before.output_types),
 'new_seam_arity':len(left.after.output_types),
 'old_joint_nodes':len(composite.before.graph.nodes),
 'new_joint_nodes':len(composite.after.graph.nodes),
 'persistent_joint_nodes':len(composite.common.nodes),
 'explicit_adapter_edge_types':sorted({e.kind for e in mediated.graph.edges.values()}),
 'claims':{'structural_witness_checked':True,'resource_conservation_proven':False,
           'behavioral_equivalence_proven':False}
}
print(json.dumps(result,ensure_ascii=False,indent=2))
