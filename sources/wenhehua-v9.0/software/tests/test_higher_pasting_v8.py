import unittest
from wenhehua.higher_pasting_v8 import (Square, Witness, compare_local_global,
                                        is_pullback_square, fiber_counts)


def grid():
    a = Square.atom('a','t0','m0','l0','v0')
    b = Square.atom('b','t1','m1','v0','r0')
    c = Square.atom('c','m0','d0','l1','v1')
    d = Square.atom('d','m1','d1','v1','r1')
    return a,b,c,d


class PastingTests(unittest.TestCase):
    def test_interchange_typed_2x2(self):
        a,b,c,d = grid()
        self.assertEqual(a.horizontal(b).vertical(c.horizontal(d)),
                         a.vertical(c).horizontal(b.vertical(d)))

    def test_tiles_keep_history(self):
        a,b,c,d = grid()
        self.assertEqual(a.horizontal(b).vertical(c.horizontal(d)).tiles,
                         (('a','b'),('c','d')))

    def test_reject_bad_horizontal_interface(self):
        a,b,c,d = grid()
        with self.assertRaises(ValueError):
            a.horizontal(d)

    def test_reject_bad_vertical_interface(self):
        a,b,c,d = grid()
        with self.assertRaises(ValueError):
            a.vertical(d)

    def test_associativity_horizontal_three_tiles(self):
        a,b,_,_=grid()
        x=Square.atom('x','t2','m2','r0','q0')
        self.assertEqual(a.horizontal(b).horizontal(x),a.horizontal(b.horizontal(x)))

    def test_associativity_vertical_three_tiles(self):
        a,_,c,_=grid()
        z=Square.atom('z','d0','e0','l2','v2')
        self.assertEqual(a.vertical(c).vertical(z),a.vertical(c.vertical(z)))

    def test_local_to_global_iso_without_switch(self):
        first=(Witness('a01','A','a0','ka'),)
        second=(Witness('a12','A','ka','a2'),)
        c=compare_local_global(first,second,{'ka':'k'})
        self.assertEqual(len(c['local']),1)
        self.assertTrue(c['surjective'])

    def test_mixed_seam_switch_gives_four_vs_two(self):
        first=(Witness('a01','A','a0','ka'),Witness('b01','B','b0','kb'))
        second=(Witness('a12','A','ka','a2'),Witness('b12','B','kb','b2'))
        c=compare_local_global(first,second,{'ka':'k','kb':'k'})
        self.assertEqual(len(c['local']),2)
        self.assertEqual(len(c['global']),4)
        self.assertEqual(len(c['missing_global']),2)
        self.assertFalse(c['surjective'])

    def test_no_seam_no_switching(self):
        first=(Witness('a01','A','a0','ka'),Witness('b01','B','b0','kb'))
        second=(Witness('a12','A','ka','a2'),Witness('b12','B','kb','b2'))
        c=compare_local_global(first,second,{})
        self.assertEqual(c['global'],c['local'])

    def test_switch_only_can_give_zero_to_one(self):
        first=(Witness('a01','A','a0','ka'),)
        second=(Witness('b12','B','kb','b2'),)
        c=compare_local_global(first,second,{'ka':'k','kb':'k'})
        self.assertEqual(len(c['local']),0)
        self.assertEqual(len(c['global']),1)

    def test_pullback_bc_true(self):
        A=('a1','a2'); Bp=('x','y'); Ap=('a1x','a2x','a1y','a2y')
        f={'a1':'b','a2':'b'}; g={'x':'b','y':'b'}
        gp={'a1x':'a1','a2x':'a2','a1y':'a1','a2y':'a2'}
        fp={'a1x':'x','a2x':'x','a1y':'y','a2y':'y'}
        self.assertTrue(is_pullback_square(A,Bp,Ap,f,g,fp,gp))
        self.assertEqual(*fiber_counts(A,Bp,Ap,f,g,fp,gp,{'a1':2,'a2':1}))

    def test_nonpullback_bc_counterexample(self):
        A=('a1','a2'); Bp=('x','y'); Ap=('a1x','a1y','a2y')
        f={'a1':'b','a2':'b'}; g={'x':'b','y':'b'}
        gp={'a1x':'a1','a1y':'a1','a2y':'a2'}
        fp={'a1x':'x','a1y':'y','a2y':'y'}
        self.assertFalse(is_pullback_square(A,Bp,Ap,f,g,fp,gp))
        lhs,rhs=fiber_counts(A,Bp,Ap,f,g,fp,gp,{'a1':2,'a2':1})
        self.assertNotEqual(lhs['x'],rhs['x'])
        self.assertEqual(lhs['y'],rhs['y'])

    def test_reject_noncommutative_bc_square(self):
        A=('a',); Bp=('x',); Ap=('z',)
        f={'a':'b'}; g={'x':'other'}; fp={'z':'x'}; gp={'z':'a'}
        with self.assertRaises(ValueError):
            fiber_counts(A,Bp,Ap,f,g,fp,gp,{'a':1})

if __name__=='__main__': unittest.main()
