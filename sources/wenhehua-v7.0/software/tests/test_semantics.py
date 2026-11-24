import unittest
from wenhehua import PetriModel,Reaction,GrammarError

class ResourceSemanticsTests(unittest.TestCase):
    def model(self):
        return PetriModel({'H':'chemical','H2':'chemical'},
             {'form':Reaction({'H':2},{'H2':1})}, {'H':4,'H2':0})
    def test_mass_conserved(self):
        p=self.model(); w={'H':1,'H2':2}
        self.assertEqual(p.reaction_preserves(w), {'form':True})
        before=p.total(w)
        self.assertEqual(p.fire('form'), {'H':2,'H2':1})
        self.assertEqual(p.total(w),before)
        self.assertEqual(p.fire('form'), {'H':0,'H2':2})
        with self.assertRaisesRegex(GrammarError,'resource shortage'):p.fire('form')
    def test_nonconserving_reaction_is_exposed(self):
        p=PetriModel({'H':'chemical','H2':'chemical'},
              {'bad':Reaction({'H':1},{'H2':1})}, {'H':3,'H2':0})
        self.assertEqual(p.reaction_preserves({'H':1,'H2':2}), {'bad':False})
    def test_no_negative_resources(self):
        p=self.model();p.marking['H']=-1
        with self.assertRaises(GrammarError):p.check()

if __name__=='__main__':unittest.main()
