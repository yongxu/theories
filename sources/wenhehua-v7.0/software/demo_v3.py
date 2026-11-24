"""v3 demonstration: interface evolution, stable-seam pasting, time & probability."""
from fractions import Fraction as Q
from wenhehua.core import Edge,Graph,Signature,Match,GrammarError
from wenhehua.higher import OpenGraph
from wenhehua.evolving import Evolution,InterfaceTrace,horizontal_evolution
from wenhehua.flow import MassFlow,Arc,External
from wenhehua.probability import Kernel,quotient_markov
from wenhehua.modes import Mode,ModeMachine

SIG=Signature(frozenset({'N'}),{'w':(('N',),('N',))})

def simple(tag):
    a,b=tag+'a',tag+'b'
    return OpenGraph(Graph({a:'N',b:'N'},{tag+'e':Edge('w',(a,),(b,))},
                           {'in:0':a,'out:0':b}),('N',),('N',))

def grow(base, tag, side):
    gr=base.graph
    nodes={**gr.nodes,tag+'new':'N'};edges=dict(gr.edges)
    if side=='in':
        edges[tag+'edge']=Edge('w',(tag+'new',),(gr.ports['out:0'],))
    else:
        edges[tag+'edge']=Edge('w',(gr.ports['in:0'],),(tag+'new',))
    ports={**gr.ports, f'{side}:1':tag+'new'}
    after=OpenGraph(Graph(nodes,edges,ports),
                    base.input_types+(('N',) if side=='in' else ()),
                    base.output_types+(('N',) if side=='out' else ()))
    common=Graph(dict(gr.nodes),dict(gr.edges))
    inclusions=Match({x:x for x in common.nodes},{x:x for x in common.edges})
    out=Evolution(base,after,common,inclusions,inclusions,
                  InterfaceTrace(((0,0),),((0,0),)))
    out.check(SIG);return out


def main():
    left=grow(simple('a'),'add_left','in')
    right=grow(simple('b'),'add_right','out')
    composed=horizontal_evolution(SIG,left,right)
    print('[界变] left interfaces:',len(composed.before.input_types),'->',len(composed.after.input_types))
    print('[界变] right interfaces:',len(composed.before.output_types),'->',len(composed.after.output_types))
    print('[界变] common graph nodes:',len(composed.common.nodes))
    machine=ModeMachine(
        {'healthy':Mode(('tick','damage'),('temp','humidity')),
         'damaged':Mode(('tick','repair'),('temp',))},
        {('healthy','tick'):{('healthy',(('temp','20'),('humidity','50'))):Q(1)},
         ('healthy','damage'):{('damaged',(('temp','20'),('humidity','50'))):Q(1)},
         ('damaged','tick'):{('damaged',(('temp','20'),)):Q(1)},
         ('damaged','repair'):{('healthy',(('temp','20'),)):Q(1)}})
    print('[时流] after damage:',tuple(machine.step('healthy','damage')))
    print('[时流] damaged next output:',tuple(machine.step('damaged','tick')))
    flow=MassFlow(('tank1','tank2'),(Arc('tank1','tank2',lambda x:x['tank1']/2),),
                  (External('tank1',lambda x:Q(3)),),
                  (External('tank2',lambda x:x['tank2']/3),))
    state={'tank1':Q(4),'tank2':Q(6)}
    print('[守恒] dx/dt:',flow.derivative(state),'boundary balance:',flow.boundary_balance(state),
          'verified:',flow.verify_balance(state))
    k=Kernel((0,1,2),(0,1,2),{0:{0:Q(1,2),1:Q(1,2)},
                                  1:{0:Q(1,2),1:Q(1,2)},2:{2:Q(1)}})
    macro=quotient_markov(k,{0:'A',1:'A',2:'B'})
    print('[观守] successful macro transition:',macro.rows)
    try:
        quotient_markov(k,{0:'A',1:'A',2:'B'},
                       {0:((),('temp',)),1:((),('temp','humidity')),2:((),('temp',))})
    except GrammarError as exc:
        print('[反例] rejected abstract interface:',exc)

if __name__=='__main__': main()
