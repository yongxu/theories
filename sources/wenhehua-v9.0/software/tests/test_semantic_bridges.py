"""v6 semantic bridge proofs-of-obligation, all with exact finite instances."""
import unittest
from fractions import Fraction as Q
from wenhehua.core import GrammarError
from wenhehua.probability import Kernel
from wenhehua.lineage import example_interchange, interchanger
from wenhehua.semantic_bridges import (
    Generator, Chain, FiniteFunction, interpret_functions, interpret_kernels,
    StoichEvent, StoichNetwork, LinearRate, ContinuousReaction,
    BinarySCM, MetricEdge, OpenMetricNetwork, check_markov_abstraction, demo_data, trace_coverage)

BIT = (0, 1)
FLIP = FiniteFunction(BIT, BIT, {0: 1, 1: 0})
IDENT = FiniteFunction(BIT, BIT, {0: 0, 1: 1})

class TestSyntaxAndTypedSemantics(unittest.TestCase):
    def test_invalid_chain(self):
        with self.assertRaises(GrammarError):
            Chain((Generator('f', 'A', 'B'), Generator('g', 'C', 'D'))).check()
    def test_empty_chain_not_implicitly_typed(self):
        with self.assertRaises(GrammarError): Chain(()).check()
    def test_typing_of_composition(self):
        c = Chain((Generator('a', 'Bit', 'Bit'), Generator('b', 'Bit', 'Bit')))
        self.assertEqual(c.type, ('Bit', 'Bit'))
    def test_typed_chain_associative(self):
        a = Chain((Generator('a','Bit','Bit'),))
        b = Chain((Generator('b','Bit','Bit'),))
        c = Chain((Generator('c','Bit','Bit'),))
        self.assertEqual(a.then(b).then(c), a.then(b.then(c)))
    def test_non_total_deterministic_rejected(self):
        with self.assertRaises(GrammarError): FiniteFunction(BIT, BIT, {0: 1}).check()
    def test_output_outside_codomain(self):
        with self.assertRaises(GrammarError): FiniteFunction(BIT, BIT, {0: 2, 1: 1}).check()
    def test_double_flip_identity(self):
        c = Chain((Generator('flip','Bit','Bit'), Generator('flip','Bit','Bit')))
        r = interpret_functions(c, {'flip': ('Bit','Bit',FLIP)})
        self.assertEqual(r.values, IDENT.values)
    def test_no_hidden_deterministic_meaning(self):
        with self.assertRaises(GrammarError):
            interpret_functions(Chain((Generator('noise','Bit','Bit'),)), {})
    def test_semantic_signature_mismatch(self):
        with self.assertRaises(GrammarError):
            interpret_functions(Chain((Generator('flip','Bit','Bit'),)), {'flip': ('A','B',FLIP)})
    def test_kernel_comp_and_image_of_function(self):
        p = Kernel(BIT, BIT, {0: {0: Q(3,4), 1: Q(1,4)},
                                   1: {0: Q(1,4), 1: Q(3,4)}})
        c = Chain((Generator('flip','Bit','Bit'), Generator('noise','Bit','Bit')))
        out = interpret_kernels(c, {'flip': ('Bit','Bit',FLIP.as_kernel()), 'noise': ('Bit','Bit',p)})
        self.assertEqual(out.rows[0][1], Q(3,4))
    def test_kernel_composition_associativity(self):
        p = Kernel(BIT,BIT,{0:{0:Q(1,3),1:Q(2,3)},1:{0:Q(2,5),1:Q(3,5)}})
        f = FLIP.as_kernel()
        self.assertEqual(p.then(f).then(p).rows, p.then(f.then(p)).rows)
    def test_kernel_wrong_boundary_rejected(self):
        with self.assertRaises(GrammarError):
            FLIP.as_kernel().then(Kernel(('yes','no'),('a','b'),{'yes':{'a':1},'no':{'b':1}}))
    def test_probabilistic_normalization_needed(self):
        with self.assertRaises(GrammarError):
            interpret_kernels(Chain((Generator('noise','Bit','Bit'),)),
              {'noise': ('Bit','Bit',Kernel(BIT,BIT,{0:{0:Q(2)},1:{1:Q(1)}}))})

class TestResourcesAndContinuousFlow(unittest.TestCase):
    def setUp(self):
        self.water = StoichNetwork(('H2','O2','H2O'),
            (StoichEvent('water', {'H2':-2,'O2':-1,'H2O':2}),),
            {s:'mol' for s in ('H2','O2','H2O')})
        self.net = StoichNetwork(('A','B','C'),
            (StoichEvent('ab',{'A':-1,'B':1}),StoichEvent('bc',{'B':-1,'C':1})),
            {s:'mol' for s in ('A','B','C')})
    def test_h_atoms_conserved(self):
        self.assertEqual(self.water.conservation_certificate({'H2':2,'O2':0,'H2O':2}), {'water': Q(0)})
    def test_o_atoms_conserved(self):
        self.assertEqual(self.water.conservation_certificate({'H2':0,'O2':2,'H2O':1}), {'water': Q(0)})
    def test_wrong_weights_expose_violation(self):
        self.assertEqual(self.water.conservation_certificate({'H2':1,'O2':1,'H2O':1})['water'], Q(-1))
    def test_cannot_hide_missing_weights(self):
        with self.assertRaises(GrammarError): self.water.conservation_certificate({'H2':2})
    def test_explicit_units_required(self):
        bad = StoichNetwork(('A','B'),(StoichEvent('ab',{'A':-1,'B':1}),),{'A':'mol','B':'kg'})
        with self.assertRaises(GrammarError): bad.check()
    def test_mass_balance_of_combined_event(self):
        self.assertEqual(self.net.combined_event(('ab','bc')), {'A':-1,'B':0,'C':1})
    def test_undeclared_species_rejected(self):
        with self.assertRaises(GrammarError):
            StoichNetwork(('A',),(StoichEvent('x', {'BAD':-1}),),{'A':'mol'}).check()
    def test_ode_linear_rates(self):
        ode = ContinuousReaction(self.net, {'ab':LinearRate('ab','A',Q(1,4)),
                                            'bc':LinearRate('bc','B',Q(1,3))})
        self.assertEqual(ode.derivative({'A':Q(8),'B':Q(6),'C':Q(1)}),
                         {'A':Q(-2),'B':Q(0),'C':Q(2)})
    def test_ode_conservation_at_multiple_states(self):
        ode = ContinuousReaction(self.net, {'ab':LinearRate('ab','A',Q(1,4)),
                                            'bc':LinearRate('bc','B',Q(1,3))})
        for x in range(5):
            for y in range(4):
                self.assertEqual(ode.weighted_balance({'A':Q(x),'B':Q(y),'C':Q(1)},
                                 {'A':Q(1),'B':Q(1),'C':Q(1)}), Q(0))
    def test_negative_concentration_rejected(self):
        ode = ContinuousReaction(self.net, {'ab':LinearRate('ab','A',Q(1)),
                                            'bc':LinearRate('bc','B',Q(1))})
        with self.assertRaises(GrammarError):ode.derivative({'A':Q(-1),'B':Q(0),'C':Q(1)})
    def test_external_flow_not_automatically_conserved(self):
        bad = StoichNetwork(('A','B'),(StoichEvent('source',{'A':1}),),{'A':'mol','B':'mol'})
        self.assertNotEqual(bad.conservation_certificate({'A':1,'B':1})['source'], Q(0))

class TestCausalityAndAbstraction(unittest.TestCase):
    def test_same_observation_different_interventions(self):
        a,b = BinarySCM('X','Y'),BinarySCM('Y','X')
        self.assertEqual(a.joint(), b.joint())
        self.assertEqual(a.marginal_y_one({'X':1}), Q(1))
        self.assertEqual(b.marginal_y_one({'X':1}), Q(1,2))
    def test_conditioning_is_not_intervening(self):
        a,b = BinarySCM('X','Y'),BinarySCM('Y','X')
        self.assertEqual(sum(p for (x,y),p in b.joint().items() if x==1 and y==1) / Q(1,2), Q(1))
        self.assertEqual(b.marginal_y_one({'X':1}), Q(1,2))
    def test_intervene_on_child_disables_incoming_mechanism(self):
        a = BinarySCM('X','Y')
        self.assertEqual(a.marginal_y_one({'Y':0}), Q(0))
        self.assertEqual(a.marginal_y_one({'Y':1}), Q(1))
    def test_invalid_intervention_rejected(self):
        with self.assertRaises(GrammarError): BinarySCM('X','Y').joint({'Z':1})
    def test_invalid_causal_model_rejected(self):
        with self.assertRaises(GrammarError): BinarySCM('X','X').check()
    def test_strong_lumpability_positive(self):
        k=Kernel(('a','b','c'),('a','b','c'),{
          'a': {'a':Q(1,2),'b':Q(1,4),'c':Q(1,4)},
          'b': {'a':Q(1,4),'b':Q(1,2),'c':Q(1,4)},
          'c': {'a':Q(1,4),'b':Q(1,4),'c':Q(1,2)}})
        m=check_markov_abstraction(k, {'a':'AB','b':'AB','c':'C'})
        self.assertEqual(m.rows['AB']['C'], Q(1,4))
        self.assertEqual(m.rows['C']['AB'], Q(1,2))
    def test_strong_lumpability_negative(self):
        k=Kernel(('a','b','c'),('a','b','c'),{
            'a':{'a':Q(1,2),'b':Q(0),'c':Q(1,2)},
            'b':{'a':Q(1),'b':Q(0),'c':Q(0)},
            'c':{'a':Q(0),'b':Q(0),'c':Q(1)}})
        with self.assertRaisesRegex(GrammarError,'lumpability'):
            check_markov_abstraction(k, {'a':'AB','b':'AB','c':'C'})
    def test_interfaces_not_erased_by_valid_probability_lumping(self):
        k=Kernel(('a','b'),('a','b'),{'a':{'a':Q(1)},'b':{'b':Q(1)}})
        with self.assertRaisesRegex(GrammarError, 'interface'):
            check_markov_abstraction(k,{'a':'same','b':'same'},
                                     {'a': (('temperature',),()),'b':(('humidity',),())})

class TestMetricAndHigherBoundary(unittest.TestCase):
    def test_shortest_composed_single_port(self):
        a=OpenMetricNetwork(('a','b'),(MetricEdge('a','b',Q(3)),),'a','b')
        b=OpenMetricNetwork(('x','y'),(MetricEdge('x','y',Q(4)),),'x','y')
        self.assertEqual(a.then(b).shortest_path(), Q(7))
    def test_metric_interface_type_rejected(self):
        a=OpenMetricNetwork(('a','b'),(MetricEdge('a','b',Q(1)),),'a','b',length_unit='m')
        b=OpenMetricNetwork(('x','y'),(MetricEdge('x','y',Q(1)),),'x','y',length_unit='km')
        with self.assertRaisesRegex(GrammarError, 'unit'):
            a.then(b)
    def test_negative_metric_length_rejected(self):
        bad=OpenMetricNetwork(('a','b'),(MetricEdge('a','b',Q(-1)),),'a','b')
        with self.assertRaises(GrammarError):bad.shortest_path()
    def test_unreachable_path_is_not_zero(self):
        graph=OpenMetricNetwork(('a','b'),(), 'a', 'b')
        self.assertIsNone(graph.shortest_path())
    def test_metric_parallel_alternative_shortest(self):
        graph=OpenMetricNetwork(('a','b','c'),
                       (MetricEdge('a','b',Q(1)),MetricEdge('b','c',Q(5)),
                        MetricEdge('a','c',Q(2))), 'a','c')
        self.assertEqual(graph.shortest_path(), Q(2))
    def test_noninvertible_weak_comparison_unchanged(self):
        x,y = example_interchange(False)
        self.assertFalse(interchanger(x,y).invertible)
    def test_invertible_weak_comparison_unchanged(self):
        x,y = example_interchange(True)
        self.assertTrue(interchanger(x,y).invertible)
    def test_noninvertible_trace_unrepresented_mass(self):
        x, y = example_interchange(False)
        comp = interchanger(x,y)
        names = comp.vertical_after_horizontal.witness.keys()
        result = trace_coverage(comp, {names[0]:Q(1)})
        self.assertFalse(result.full)
        self.assertEqual(result.unrepresented,Q(1))
    def test_invertible_trace_full_coverage(self):
        x,y = example_interchange(True)
        comp = interchanger(x,y)
        result = trace_coverage(comp, {k:Q(1) for k in comp.vertical_after_horizontal.witness.keys()})
        self.assertTrue(result.full)
    def test_trace_weights_are_explicit_and_nonnegative(self):
        x,y = example_interchange(True)
        comp = interchanger(x,y)
        with self.assertRaises(GrammarError):trace_coverage(comp,{})
        with self.assertRaises(GrammarError):trace_coverage(comp,{k:Q(-1) for k in comp.vertical_after_horizontal.witness.keys()})
    def test_dirac_embedding_respects_composition(self):
        f=FLIP
        g=IDENT
        self.assertEqual(f.then(g).as_kernel().rows, f.as_kernel().then(g.as_kernel()).rows)
    def test_demo_consistent(self):
        demo=demo_data()
        self.assertEqual(demo['stochastic'], '3/4')
        self.assertEqual(demo['resource_H_balance'],'0')
        self.assertEqual(demo['continuous_total_balance'],'0')
        self.assertEqual(demo['metric_sequential_distance'],'7')

if __name__=='__main__': unittest.main()
