from wenhehua import *

sig=Signature(frozenset({'Signal'}),{'wire': (('Signal',), ('Signal',))})
a=Graph({'a':'Signal','b':'Signal'}, {'e':Edge('wire',('a',),('b',))}, {'in':'a','out':'b'})
b=Graph({'c':'Signal','d':'Signal'}, {'f':Edge('wire',('c',),('d',))}, {'in':'c','out':'d'})
c=glue(sig,a,b,{'out':'in'})
print('合：nodes=',len(c.nodes),'edges=',len(c.edges),'ports=',c.ports)
l=Graph({'a':'Signal','b':'Signal'}, {'e':Edge('wire',('a',),('b',))})
r=Graph({'a':'Signal','x':'Signal','b':'Signal'},
        {'e1':Edge('wire',('a',),('x',)),'e2':Edge('wire',('x',),('b',))})
out=rewrite(sig,a,Rule('insert',l,r,{'a':'a','b':'b'}))
print('化：nodes=',len(out.nodes),'edges=',len(out.edges),'ports=',out.ports)
# A deterministic quotient is not necessarily a dynamical quotient.
step=lambda x:{'0':'1','1':'2','2':'0'}[x]
alpha=lambda x:{'0':'A','1':'B','2':'A'}[x]
print('观：coherent abstraction?',compatible_abstraction(('0','1','2'),step,alpha))
petri=PetriModel({'H':'chemical','H2':'chemical'},
    {'form':Reaction({'H':2},{'H2':1})},{'H':4,'H2':0})
weights={'H':1,'H2':2}
print('守：reaction conserves weighted mass?',petri.reaction_preserves(weights))
print('守：before=',petri.total(weights),'after=',petri.fire('form'),petri.total(weights))
