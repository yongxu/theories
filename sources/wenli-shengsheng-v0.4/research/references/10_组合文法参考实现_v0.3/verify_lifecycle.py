"""Independent finite-graph verification of the two lifecycle criteria.

Run with Python 3; prints results without changing model or source files.
"""
from pathlib import Path
import importlib.util, itertools, copy, json
p=Path(__file__).resolve().parent/'wenli.py'
spec=importlib.util.spec_from_file_location('wenli_independent_review',p)
wm=importlib.util.module_from_spec(spec);spec.loader.exec_module(wm)

def base(states,edges,K):
 return {'context_id':'independent-finite-review','closed_world':True,'states':states,'sorts':{},'constants':{},'predicates':{'K':{'sorts':[],'kind':'descriptive','true_at':{s:[[]] if s in K else [] for s in states}}},'programs':{'tick':edges}}

def atom(n,args=None):return {'op':'atom','name':n,'args':args or []}
def at(n):return {'op':'atomic','name':n}
def conj(*args):return {'op':'and','args':list(args)}
def dia(p,f):return {'op':'diamond','program':p,'body':f}
def box(p,f):return {'op':'box','program':p,'body':f}
def seq(*args):return {'op':'seq','args':list(args)}
def test(f):return {'op':'test','condition':f}
T={'op':'true'}
results={}
# Exhaustive finite graph semantics, independent greatest-fixed-point oracle.
states=['0','1','2']; all_edges=list(itertools.product(states,repeat=2)); cnt=0
safe=seq(test(atom('K')),at('tick'),test(atom('K')))
may=conj(atom('K'),dia({'op':'repeat','count':len(states),'body':safe},T))
allf=box({'op':'star','body':at('tick')},conj(atom('K'),dia(at('tick'),T)))
for bits in range(1<<len(all_edges)):
 edges=[list(e) for i,e in enumerate(all_edges) if bits>>i&1]
 for kb in range(1<<len(states)):
  K={s for i,s in enumerate(states) if kb>>i&1}
  M=wm.Model(base(states,edges,K))
  succ={s:{b for a,b in edges if a==s} for s in states}
  w=set(K)
  while True:
   v={s for s in w if succ[s]&w}
   if v==w:break
   w=v
  g=set(K)
  while True:
   h={s for s in g if succ[s] and succ[s]<=g}
   if h==g:break
   g=h
  for s in states:
   assert M.holds(may,s)==(s in w),(edges,K,s,'may')
   assert M.holds(allf,s)==(s in g),(edges,K,s,'all')
   cnt+=2
results['exhaustive_3state_forever_comparisons']=cnt
# Quantifier environment must persist through process tests and composition.
data=base(['a','b'],[['a','b']],{'a','b'})
data['sorts']={'Entity':['u','v']}
data['constants']={'u':{'sort':'Entity','value':'u'},'v':{'sort':'Entity','value':'v'}}
data['predicates']['P']={'sorts':['Entity'],'kind':'descriptive','true_at':{'a':[['u']],'b':[['v']]}}
M=wm.Model(data); x={'var':'x'}
query={'op':'forall','var':'x','sort':'Entity','body':box(seq(test(atom('P',[x])),at('tick')),atom('P',[x]))}
assert M.holds(query,'a') is False
results['quantifier_environment_preserved']=True
# A closed definition must not be captured by the referencing quantifier.
d2=copy.deepcopy(data)
d2['formula_defs']={'someP':{'op':'exists','var':'x','sort':'Entity','body':atom('P',[x])}}
M2=wm.Model(d2)
assert M2.holds({'op':'forall','var':'x','sort':'Entity','body':{'op':'fref','name':'someP'}},'a') is True
results['closed_definition_no_capture']=True
# Supervaluation must evaluate each whole formula, not Kleene combine unknowns.
d3=copy.deepcopy(data); d3['predicates']['K']['true_at']['a']=[]
M3=wm.Model(d3)
assert wm.assess([M,M3],atom('K'),'a')=='unknown'
assert wm.assess([M,M3],{'op':'or','args':[atom('K'),{'op':'not','arg':atom('K')}]},'a')=='true'
results['candidate_model_whole_formula']=True
# Context declarations and cross-context compatibility are enforced.
d4=copy.deepcopy(data);d4['context_id']='organism-lifetime'
M4=wm.Model(d4)
try:
 wm.assess([M,M4],atom('K'),'a')
 raise AssertionError('different contexts accepted')
except wm.GrammarError:pass
for invalid in [None,'','   ']:
 bad=copy.deepcopy(data)
 if invalid is None:bad.pop('context_id')
 else:bad['context_id']=invalid
 try:
  wm.Model(bad)
  raise AssertionError('invalid context accepted')
 except wm.GrammarError:pass
results['context_id_status']='missing, blank, and mismatched contexts correctly rejected'
print(json.dumps(results,ensure_ascii=False,indent=2))
