"""Limited n-fold canonical comparison and one pasting-coherence identity."""
import unittest
from wenhehua.lineage import example_interchange, interchanger, vertical, pair_key, unpack_pair
from wenhehua.higher_comparison_v6 import n_interchanger

class NComparisonTests(unittest.TestCase):
    def test_length_two_agrees_with_v5(self):
        s1,s2=example_interchange(True)
        left=interchanger(s1,s2); right=n_interchanger((s1,s2))
        self.assertEqual(left.comparison.mapping,right.comparison.mapping)
    def test_length_two_lax_agrees_with_v5(self):
        s1,s2=example_interchange(False)
        left=interchanger(s1,s2); right=n_interchanger((s1,s2))
        self.assertEqual(left.comparison.mapping,right.comparison.mapping)
    def test_three_full_compatible_identity(self):
        s1,s2=example_interchange(True)
        new=n_interchanger((s1,s2,s1))
        self.assertTrue(new.invertible)
        self.assertEqual(len(new.vertical_after_horizontal.witness),1)
    def test_three_lax_remains_noninvertible(self):
        s1,s2=example_interchange(False)
        new=n_interchanger((s1,s2,s1))
        self.assertFalse(new.invertible)
        self.assertGreaterEqual(new.extra_mixed_histories,0)
    def test_three_stage_staged_interchanger_pasting(self):
        s1,s2=example_interchange(True)
        s3=s1
        direct=n_interchanger((s1,s2,s3))
        pair12=interchanger(s1,s2)
        outer=interchanger(vertical(s1,s2),s3)
        for w in direct.horizontal_after_vertical.witness.keys():
            # stage one comparison H(V12 V3) → H(V12)·H3
            w12,w3 = unpack_pair(outer.comparison(w))
            # stage two comparison H(V12) → H1·H2
            staged=pair_key(pair12.comparison(w12),w3)
            self.assertEqual(staged,direct.comparison(w))
    def test_refuse_missing_steps(self):
        with self.assertRaises(Exception): n_interchanger(())

if __name__=='__main__': unittest.main()
