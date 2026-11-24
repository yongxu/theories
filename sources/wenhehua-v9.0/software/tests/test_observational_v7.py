"""Finite exact theorem, simultaneous-query and robust stochastic checks for v7."""
import unittest
from itertools import product
from fractions import Fraction as F
from wenhehua.lineage import TSet, TMap, example_interchange, interchanger
from wenhehua.probability import Kernel
from wenhehua.observational_v7 import (
    ObservationError, probability, tv, pushforward, optimal_observed_lift,
    joint_observation, common_lift, kernel_sup_tv, composition_error,
    parallel_error, observe_kernel, stochastic_data_processing,
    coarsen_observation, refinement_certificate,
)


def inclusion():
    u=TSet.of(a='H',b='H'); v=TSet.of(a='H',b='H',extra='H')
    return TMap(u,v,{'a':'a','b':'b'})


def square_diag():
    u=TSet.of(a='T',b='T');v=TSet.of(x00='T',x01='T',x10='T',x11='T')
    c=TMap(u,v,{'a':'x00','b':'x11'})
    left={x:int(x[1]) for x in v.keys()}
    right={x:int(x[2]) for x in v.keys()}
    return c,left,right


def K(p):
    return Kernel(('0','1'),('0','1'),{
      '0':{'0':F(1)-F(p),'1':F(p)},
      '1':{'0':F(p),'1':F(1)-F(p)}})


class ExactQueryLift(unittest.TestCase):
    def test_identity_observation_exact_when_supported(self):
        c=inclusion(); mu={'a':F(1,4),'b':F(3,4),'extra':F(0)}
        r=optimal_observed_lift(c,mu,{v:v for v in c.codomain.keys()})
        self.assertTrue(r.exact);self.assertEqual(r.tv_floor,0)
        self.assertEqual(r.observed_global,r.observed_lift)

    def test_missing_mass_exact_value(self):
        c=inclusion(); mu={'a':F(1,4),'b':F(1,4),'extra':F(1,2)}
        r=optimal_observed_lift(c,mu,{v:v for v in c.codomain.keys()})
        self.assertEqual(r.tv_floor,F(1,2));self.assertEqual(r.excluded_labels,('extra',))
        self.assertEqual(r.lift,{'a':F(1,2),'b':F(1,2)})
        self.assertEqual(tv(r.observed_global,r.observed_lift),F(1,2))

    def test_coarse_observation_erases_structural_gap(self):
        c=inclusion();mu={'a':F(1,4),'b':F(1,4),'extra':F(1,2)}
        q={'a':'seen','b':'seen','extra':'seen'}
        self.assertTrue(optimal_observed_lift(c,mu,q).exact)

    def test_partial_coarse_query(self):
        c=inclusion();mu={'a':F(1,4),'b':F(1,4),'extra':F(1,2)}
        q={'a':'L','b':'R','extra':'R'}
        r=optimal_observed_lift(c,mu,q)
        self.assertEqual(r.tv_floor,0)
        self.assertEqual(r.observed_lift,{'L':F(1,4),'R':F(3,4)})

    def test_all_missing_probability_fallback_is_valid(self):
        c=inclusion();mu={'a':F(0),'b':F(0),'extra':F(1)}
        r=optimal_observed_lift(c,mu,{v:v for v in c.codomain.keys()})
        self.assertEqual(r.tv_floor,1)
        self.assertEqual(sum(r.lift.values()),1)

    def test_noninjective_chi_may_have_many_lifts(self):
        u=TSet.of(a='H',b='H');v=TSet.of(z='H')
        c=TMap(u,v,{'a':'z','b':'z'})
        r=optimal_observed_lift(c,{'z':F(1)},{'z':'observed'})
        self.assertTrue(r.exact)
        self.assertEqual(r.lift,{'a':F(1),'b':F(0)})

    def test_empty_chi_domain_refused(self):
        c=TMap(TSet(()),TSet.of(x='H'),{})
        with self.assertRaisesRegex(ObservationError,'empty source'):
            optimal_observed_lift(c,{'x':F(1)},{'x':0})

    def test_probability_negative_refused(self):
        with self.assertRaises(ObservationError): probability(('a','b'),{'a':F(-1),'b':F(2)})

    def test_probability_not_normalized_refused(self):
        with self.assertRaises(ObservationError): probability(('a','b'),{'a':F(1,3),'b':F(1,3)})

    def test_probability_missing_key_refused(self):
        with self.assertRaises(ObservationError): probability(('a','b'),{'a':F(1)})

    def test_missing_observation_key_refused(self):
        c=inclusion()
        with self.assertRaises(ObservationError):
            optimal_observed_lift(c,{'a':F(1),'b':F(0),'extra':F(0)}, {'a':1,'b':2})

    def test_pushforward_totality(self):
        with self.assertRaises(ObservationError): pushforward({'a':F(1)},{'a':'X','b':'Y'})

    def test_tv_metric_simple(self):
        self.assertEqual(tv({'a':F(1)},{'b':F(1)}),1)
        self.assertEqual(tv({'a':F(1,2),'b':F(1,2)},{'a':F(1,2),'b':F(1,2)}),0)

    def test_report_on_v5_lax_example_cannot_assign_probability_to_empty_source(self):
        c=interchanger(*example_interchange(False)).comparison
        self.assertEqual(len(c.domain),0)
        with self.assertRaises(ObservationError):
            optimal_observed_lift(c,{v:F(1) for v in c.codomain.keys()},
                                 {v:v for v in c.codomain.keys()})

    def test_many_small_cases_attain_tv_floor(self):
        # 2 source witnesses, 3 target witnesses; all maps, all binary observations,
        # all probability 1/4 grid points.
        u=TSet.of(a='H',b='H');v=TSet.of(x='H',y='H',z='H')
        for codomain_images in product(v.keys(),repeat=2):
            c=TMap(u,v,dict(zip(u.keys(),codomain_images)))
            for labels in product((0,1),repeat=3):
                q=dict(zip(v.keys(),labels))
                for i in range(5):
                    for j in range(5-i):
                        mu={'x':F(i,4),'y':F(j,4),'z':F(4-i-j,4)}
                        r=optimal_observed_lift(c,mu,q)
                        self.assertEqual(tv(r.observed_global,r.observed_lift),r.tv_floor)


class SimultaneousQueries(unittest.TestCase):
    def test_each_query_separately_exact_but_no_common_lift(self):
        c,left,right=square_diag()
        mu={'x00':F(1,10),'x01':F(7,10),'x10':F(1,10),'x11':F(1,10)}
        self.assertTrue(optimal_observed_lift(c,mu,left).exact)
        self.assertTrue(optimal_observed_lift(c,mu,right).exact)
        self.assertFalse(common_lift(c,mu,(left,right)).feasible)

    def test_compatible_marginals_have_one_lift(self):
        c,left,right=square_diag()
        mu={'x00':F(1,4),'x01':F(1,4),'x10':F(1,4),'x11':F(1,4)}
        rep=common_lift(c,mu,(left,right))
        self.assertTrue(rep.feasible);self.assertEqual(rep.lift['a'],F(1,2))

    def test_joint_query_detects_lost_correlation(self):
        c,left,right=square_diag()
        mu={k:F(1,4) for k in c.codomain.keys()}
        self.assertTrue(common_lift(c,mu,(left,right)).feasible)
        joint=joint_observation([left,right])
        self.assertFalse(common_lift(c,mu,(joint,)).feasible)
        self.assertEqual(optimal_observed_lift(c,mu,joint).tv_floor,F(1,2))

    def test_duplicate_identical_query_cannot_change_feasibility(self):
        c,left,_=square_diag()
        mu={k:F(1,4) for k in c.codomain.keys()}
        self.assertEqual(common_lift(c,mu,(left,)).feasible,common_lift(c,mu,(left,left)).feasible)

    def test_joint_observation_requires_matching_domain(self):
        with self.assertRaises(ObservationError):joint_observation([{'a':1},{'b':1}])

    def test_common_lift_requires_query(self):
        c,left,right=square_diag();mu={k:F(1,4) for k in c.codomain.keys()}
        with self.assertRaises(ObservationError):common_lift(c,mu,())

    def test_common_lift_rejects_large_exact_enumeration(self):
        u=TSet(tuple((str(i),'H') for i in range(13)));v=u
        c=TMap(u,v,{str(i):str(i) for i in range(13)})
        p={str(i):F(1,13) for i in range(13)}
        with self.assertRaisesRegex(ObservationError,'limited'):
            common_lift(c,p,({str(i):str(i) for i in range(13)},))


class QuantitativeMarkovSemantics(unittest.TestCase):
    def test_same_kernels_distance_zero(self):
        self.assertEqual(kernel_sup_tv(K(F(1,4)),K(F(1,4))),0)

    def test_known_row_distance(self):
        self.assertEqual(kernel_sup_tv(K(F(1,4)),K(F(1,2))),F(1,4))

    def test_sequential_budget_valid(self):
        r=composition_error(((K(F(0)),K(F(1,4))),(K(F(0)),K(F(1,3)))))
        self.assertEqual(r.per_stage,(F(1,4),F(1,3)))
        self.assertLessEqual(r.actual_error,r.certified_bound)

    def test_tensor_budget_valid(self):
        r=parallel_error(((K(F(0)),K(F(1,4))),(K(F(0)),K(F(1,3)))))
        self.assertLessEqual(r.actual_error,r.certified_bound)

    def test_truncated_budget_at_one(self):
        r=composition_error(((K(F(0)),K(F(1))),(K(F(0)),K(F(1)))))
        self.assertEqual(r.certified_bound,1)

    def test_identity_stage(self):
        r=composition_error(((K(F(1,3)),K(F(1,3))),))
        self.assertEqual(r.actual_error,0)

    def test_domain_mismatch_refused(self):
        left=K(F(1,3));right=Kernel(('a',),('a',),{'a':{'a':F(1)}})
        with self.assertRaises(ObservationError):kernel_sup_tv(left,right)

    def test_data_processing_strict_contraction(self):
        blur=K(F(1,2))
        before,after=stochastic_data_processing({'0':F(1),'1':F(0)},
                                               {'0':F(0),'1':F(1)},blur)
        self.assertEqual((before,after),(F(1),F(0)))

    def test_data_processing_identity(self):
        identity=K(F(0))
        before,after=stochastic_data_processing({'0':F(1),'1':F(0)},
                                               {'0':F(0),'1':F(1)},identity)
        self.assertEqual((before,after),(F(1),F(1)))

    def test_data_processing_bad_distribution_refused(self):
        with self.assertRaises(ObservationError):
            stochastic_data_processing({'0':F(1,2),'1':F(0)},
                                       {'0':F(0),'1':F(1)},K(F(1,2)))

    def test_observation_can_hide_kernel_difference(self):
        a=K(F(0));b=K(F(1))
        self.assertEqual(kernel_sup_tv(a,b),1)
        self.assertEqual(kernel_sup_tv(observe_kernel(a,{'0':'one','1':'one'}),
                                       observe_kernel(b,{'0':'one','1':'one'})),0)

    def test_observation_interface_totality(self):
        with self.assertRaises(ObservationError):observe_kernel(K(F(0)),{'0':'only'})

    def test_exhaustive_small_sequential_bounds(self):
        grid=(F(0),F(1,4),F(1,2),F(3,4),F(1))
        for p,q,r,s in product(grid,repeat=4):
            result=composition_error(((K(p),K(q)),(K(r),K(s))))
            self.assertLessEqual(result.actual_error,result.certified_bound)

    def test_exhaustive_small_tensor_bounds(self):
        grid=(F(0),F(1,2),F(1))
        for p,q,r,s in product(grid,repeat=4):
            result=parallel_error(((K(p),K(q)),(K(r),K(s))))
            self.assertLessEqual(result.actual_error,result.certified_bound)

    def test_triple_sequential_and_tensor(self):
        p=((K(F(0)),K(F(1,4))),(K(F(0)),K(F(1,4))),(K(F(0)),K(F(1,4))))
        self.assertLessEqual(composition_error(p).actual_error,composition_error(p).certified_bound)
        self.assertLessEqual(parallel_error(p).actual_error,parallel_error(p).certified_bound)


class RefinementOrder(unittest.TestCase):
    def test_observation_coarsening_never_increases_missing_mass(self):
        c=inclusion();mu={'a':F(1,4),'b':F(1,4),'extra':F(1,2)}
        fine={v:v for v in c.codomain.keys()}
        r=refinement_certificate(c,mu,fine,{'a':'A','b':'B','extra':'B'})
        self.assertEqual((r.fine_defect,r.coarse_defect),(F(1,2),F(0)))

    def test_coarsen_refuses_partial_lump(self):
        with self.assertRaises(ObservationError):
            coarsen_observation({'a':1,'b':2},{1:'X'})

    def test_nontrivial_partial_loss_reduction(self):
        c=inclusion();mu={'a':F(1,4),'b':F(1,4),'extra':F(1,2)}
        fine={'a':'A','b':'B','extra':'C'}
        r=refinement_certificate(c,mu,fine,{'A':'G','B':'G','C':'H'})
        self.assertEqual((r.fine_defect,r.coarse_defect),(F(1,2),F(1,2)))

    def test_small_exhaustive_refinement_order(self):
        u=TSet.of(a='H',b='H');v=TSet.of(x='H',y='H',z='H')
        for images in product(v.keys(),repeat=2):
            c=TMap(u,v,dict(zip(u.keys(),images)))
            for observations in product(('a','b','c'),repeat=3):
                fine=dict(zip(v.keys(),observations))
                for lump_values in product((0,1),repeat=3):
                    lump=dict(zip(('a','b','c'),lump_values))
                    # Coarsening must be total ONLY over labels actually used.
                    used={label:lump[label] for label in fine.values()}
                    mu={'x':F(1,4),'y':F(1,2),'z':F(1,4)}
                    r=refinement_certificate(c,mu,fine,used)
                    self.assertTrue(r.monotone)

if __name__ == '__main__': unittest.main()
