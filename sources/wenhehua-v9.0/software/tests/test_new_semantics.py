from __future__ import annotations
import unittest
from fractions import Fraction as Q
from wenhehua.core import GrammarError
from wenhehua.probability import Kernel,quotient_markov
from wenhehua.flow import Arc,External,MassFlow
from wenhehua.modes import Mode,ModeMachine

class TestNewSemantics(unittest.TestCase):
    def test_sequential_kernel(self):
        a=Kernel(('x',),('y','z'),{'x':{'y':Q(1,4),'z':Q(3,4)}})
        b=Kernel(('y','z'),('p','q'),{'y':{'p':Q(1)},'z':{'q':Q(1)}})
        c=a.then(b);self.assertEqual(c.rows['x']['p'],Q(1,4))
    def test_tensor_kernel(self):
        a=Kernel(('s',),('h','t'),{'s':{'h':Q(1,2),'t':Q(1,2)}})
        b=Kernel(('w',),('0','1'),{'w':{'0':Q(1,3),'1':Q(2,3)}})
        c=a.tensor(b);self.assertEqual(c.rows[('s','w')][('h','1')],Q(1,3))
    def test_invalid_probability_rejected(self):
        a=Kernel(('x',),('y',),{'x':{'y':Q(2)}})
        with self.assertRaises(GrammarError):a.check()
    def test_kernel_mismatch_rejected(self):
        a=Kernel(('x',),('y',),{'x':{'y':Q(1)}})
        b=Kernel(('z',),('w',),{'z':{'w':Q(1)}})
        with self.assertRaises(GrammarError):a.then(b)
    def test_strong_lumping(self):
        k=Kernel((0,1,2),(0,1,2),{
          0:{0:Q(1,2),1:Q(1,2)},
          1:{0:Q(1,2),1:Q(1,2)},
          2:{2:Q(1)} })
        a={0:'A',1:'A',2:'B'}
        m=quotient_markov(k,a)
        self.assertEqual(m.rows['A']['B'],0)
    def test_nonlumpable_counterexample(self):
        k=Kernel((0,1,2),(0,1,2),{
          0:{0:Q(1)}, 1:{2:Q(1)}, 2:{2:Q(1)} })
        with self.assertRaisesRegex(GrammarError,'lumpability'):
          quotient_markov(k,{0:'A',1:'A',2:'B'})
    def test_same_macro_different_interface_rejected(self):
        k=Kernel((0,1),(0,1),{0:{0:Q(1)},1:{1:Q(1)}})
        with self.assertRaisesRegex(GrammarError,'interface abstraction'):
          quotient_markov(k,{0:'A',1:'A'},{0:(('input',),('temperature',)),
                                        1:(('input',),('temperature','humidity'))})
    def test_mass_balance(self):
        f=MassFlow(('A','B'),(Arc('A','B',lambda s:s['A']/2),),
           (External('A',lambda s:Q(3)),),
           (External('B',lambda s:s['B']/3),))
        st={'A':Q(4),'B':Q(6)}
        d=f.derivative(st)
        self.assertEqual(d,{'A':Q(1),'B':Q(0)})
        self.assertEqual(f.boundary_balance(st),Q(1))
        self.assertTrue(f.verify_balance(st))
    def test_closed_internal_flow_mass_constant(self):
        f=MassFlow(('A','B'),(Arc('A','B',lambda s:Q(17,7)),))
        self.assertTrue(f.verify_balance({'A':Q(3),'B':Q(5)}))
        self.assertEqual(sum(f.derivative({'A':Q(3),'B':Q(5)}).values()),0)
    def test_external_flux_missing_rejected(self):
        f=MassFlow(('A',),(Arc('A','missing',lambda s:Q(1)),))
        with self.assertRaises(GrammarError):f.check()
    def test_mode_change(self):
        m=ModeMachine({'healthy':Mode(('tick','damage'),('temp','humidity')),
                       'damaged':Mode(('tick','repair'),('temp',))},
            {('healthy','tick'):{('healthy',(('temp','20'),('humidity','40'))):Q(1)},
             ('healthy','damage'):{('damaged',(('temp','20'),('humidity','40'))):Q(1)},
             ('damaged','tick'):{('damaged',(('temp','20'),)):Q(1)},
             ('damaged','repair'):{('healthy',(('temp','20'),)):Q(1)}})
        m.check();self.assertEqual(len(next(iter(m.step('damaged','repair')))[1]),1)
        with self.assertRaises(GrammarError):m.step('damaged','damage')
    def test_mode_wrong_emission_rejected(self):
        m=ModeMachine({'x':Mode(('tick',),('one','two'))},
           {('x','tick'):{('x',(('one','only_one'),)):Q(1)}})
        with self.assertRaises(GrammarError):m.check()
    def test_mode_unbalanced_prob_rejected(self):
        m=ModeMachine({'x':Mode(('tick',),('one',))},
           {('x','tick'):{('x',(('one','one'),)):Q(1,3)}})
        with self.assertRaises(GrammarError):m.check()

if __name__=='__main__':unittest.main()

class TestTypeTaggedEmissions(unittest.TestCase):
    def test_equal_arity_wrong_output_label_rejected(self):
        m=ModeMachine({'healthy':Mode(('tick',),('temp','humidity'))},
          {('healthy','tick'):{('healthy',(('temp','20'),('light','80'))):Q(1)}})
        with self.assertRaisesRegex(GrammarError,'typed interface'):m.check()
