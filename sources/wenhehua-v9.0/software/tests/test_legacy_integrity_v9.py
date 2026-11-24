"""Regression for two concrete encoding bugs found during the v9 audit."""
import unittest
from wenhehua.lineage import TSet,TMap,pushout


class TestLegacyRepresentationIntegrity(unittest.TestCase):
    def test_delimiter_label_cannot_collide_with_a_genuine_quotient_class(self):
        j=TSet.of(s='T')
        l=TSet((('x','T'),('x|R:y','T')))
        r=TSet.of(y='T')
        q=pushout(j,l,r,TMap(j,l,{'s':'x'}),TMap(j,r,{'s':'y'}))
        self.assertEqual(len(q.apex),2)
        self.assertEqual(q.left('x'),q.right('y'))
        self.assertNotEqual(q.left('x|R:y'),q.right('y'))

    def test_external_mutation_cannot_change_validated_typed_set_or_map(self):
        data=[['x','T'],['y','T']]
        x=TSet(data); data[0][0]='z'
        self.assertIn('x',x.keys())
        mapping={'x':'x','y':'y'}
        f=TMap(x,x,mapping);mapping['x']='y'
        self.assertEqual(f('x'),'x')
        with self.assertRaises(TypeError): f.mapping['x']='y'


if __name__=='__main__':unittest.main()
