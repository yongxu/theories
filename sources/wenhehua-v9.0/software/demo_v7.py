"""Reproducible v7 numerical examples. Output is rational text, not simulation evidence."""
from fractions import Fraction as F
from itertools import product
import json
from wenhehua.lineage import TSet,TMap,example_interchange,interchanger
from wenhehua.observational_v7 import (
    optimal_observed_lift,refinement_certificate,common_lift,joint_observation,
    composition_error,parallel_error,kernel_sup_tv,observe_kernel,
)
from wenhehua.probability import Kernel
from wenhehua.semantic_bridges import BinarySCM
from wenhehua.higher_comparison_v6 import n_interchanger


def K(p):
    return Kernel(('0','1'),('0','1'),{'0':{'0':1-F(p),'1':F(p)},'1':{'0':F(p),'1':1-F(p)}})


def dump():
    u=TSet.of(a='H',b='H');v=TSet.of(a='H',b='H',extra='H')
    chi=TMap(u,v,{'a':'a','b':'b'})
    mu={'a':F(1,4),'b':F(1,4),'extra':F(1,2)}
    fine={k:k for k in v.keys()}
    coarse={'a':'A','b':'B','extra':'B'}
    loss_fine=optimal_observed_lift(chi,mu,fine)
    loss_coarse=optimal_observed_lift(chi,mu,coarse)
    c=TMap(TSet.of(a='H',b='H'),TSet.of(x00='H',x01='H',x10='H',x11='H'),
           {'a':'x00','b':'x11'})
    q1={x:int(x[1]) for x in c.codomain.keys()}
    q2={x:int(x[2]) for x in c.codomain.keys()}
    mu_mismatch={'x00':F(1,10),'x01':F(7,10),'x10':F(1,10),'x11':F(1,10)}
    each=[optimal_observed_lift(c,mu_mismatch,q).tv_floor for q in (q1,q2)]
    combined=common_lift(c,mu_mismatch,(q1,q2))
    qboth=joint_observation((q1,q2))
    mu_uniform={x:F(1,4) for x in c.codomain.keys()}
    seq=composition_error(((K(0),K(F(1,4))),(K(0),K(F(1,3)))))
    tensor=parallel_error(((K(0),K(F(1,4))),(K(0),K(F(1,3)))))
    s1,s2=example_interchange(False)
    comp=n_interchanger((s1,s2,s1,s2))
    mxy=BinarySCM('X','Y');myx=BinarySCM('Y','X')
    result={
      'release':'v7.0',
      'query_lift':{'fine_tv_floor':str(loss_fine.tv_floor),
                    'coarse_tv_floor':str(loss_coarse.tv_floor),
                    'fine_missing':list(loss_fine.excluded_labels),
                    'coarse_exact':loss_coarse.exact,
                    'fine_lift':{k:str(v) for k,v in loss_fine.lift.items()},
                    'coarse_lift':{k:str(v) for k,v in loss_coarse.lift.items()}},
      'multi_query':{'individual_tv_floors':[str(t) for t in each],
                      'single_common_lift_exists':combined.feasible,
                      'uniform_marginal_common_lift':common_lift(c,mu_uniform,(q1,q2)).feasible,
                      'uniform_joint_lift_exists':common_lift(c,mu_uniform,(qboth,)).feasible},
      'stochastic':{'sequential':{'certified_bound':str(seq.certified_bound),
                                  'actual':str(seq.actual_error)},
                     'independent_tensor':{'certified_bound':str(tensor.certified_bound),
                                           'actual':str(tensor.actual_error)},
                     'all_outputs_collapsed_error':str(kernel_sup_tv(
                          observe_kernel(K(0),{'0':'same','1':'same'}),
                          observe_kernel(K(1),{'0':'same','1':'same'})))},
      'higher_comparison':{'four_stage_source_witnesses':len(comp.comparison.domain),
                            'four_stage_global_witnesses':len(comp.comparison.codomain),
                            'is_iso':comp.invertible},
      'causal_query':{'observational_y_one_X_causes_Y':str(mxy.marginal_y_one()),
                       'observational_y_one_Y_causes_X':str(myx.marginal_y_one()),
                       'interventional_y_one_X_causes_Y':str(mxy.marginal_y_one({'X':1})),
                       'interventional_y_one_Y_causes_X':str(myx.marginal_y_one({'X':1}))},
      'disclaimer':'Exact finite symbolic examples; not universal coherence proof, empirical validation, or causal identification.'
    }
    return result

if __name__=='__main__':
    print(json.dumps(dump(),indent=2,ensure_ascii=False))
