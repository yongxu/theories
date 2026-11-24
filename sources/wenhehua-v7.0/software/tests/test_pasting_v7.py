"""Fourth-stage associator/pasting tests in the *existing finite single-seam model*.

These tests check selected higher-coherence slices up to the canonical
reassociation of tuple-encoded witnesses.  They do NOT establish the full
intercategory coherence laws for all spatial configurations.
"""
import unittest
from wenhehua.lineage import (
    TSet,TMap,Span,SeamState,SeamStep, interchanger,vertical,
    pair_key, unpack_pair, example_interchange,
)
from wenhehua.higher_comparison_v6 import n_interchanger


def leftpair(items):
    result=items[0]
    for x in items[1:]: result=pair_key(result,x)
    return result


def flatten_right(name,n):
    if n==1:return [name]
    a,b=unpack_pair(name)
    return [a]+flatten_right(b,n-1)


def leftfold(steps):
    x=steps[0]
    for nxt in steps[1:]: x=vertical(x,nxt)
    return x


def rightfold(steps):
    if len(steps)==1:return steps[0]
    return vertical(steps[0],rightfold(steps[1:]))


def mapped_by_right_pasting(steps, local_right_key):
    """Apply recursively right-associated two-step chi, then reassociate."""
    if len(steps)==1:
        return [local_right_key]
    head=steps[0]
    tail=rightfold(steps[1:])
    chi=interchanger(head,tail)
    head_global, tail_local=unpack_pair(chi.comparison(local_right_key))
    return [head_global] + mapped_by_right_pasting(steps[1:],tail_local)


def rich_step(i):
    j=TSet.of(j='H');l=TSet.of(l='H');r=TSet.of(r='H')
    state=SeamState(j,l,r,TMap(j,l,{'j':'l'}),TMap(j,r,{'j':'r'}))
    a=TSet.of(**{f'a{i}_1':'H',f'a{i}_2':'H'})
    b=TSet.of(**{f'b{i}_1':'H',f'b{i}_2':'H'})
    w=TSet.of(**{f's{i}':'H'})
    la=Span(l,l,a,TMap(a,l,{k:'l' for k in a.keys()}),TMap(a,l,{k:'l' for k in a.keys()}))
    rb=Span(r,r,b,TMap(b,r,{k:'r' for k in b.keys()}),TMap(b,r,{k:'r' for k in b.keys()}))
    seam=Span(j,j,w,TMap(w,j,{f's{i}':'j'}),TMap(w,j,{f's{i}':'j'}))
    return SeamStep(state,state,la,seam,rb,
                    TMap(w,a,{f's{i}':f'a{i}_1'}),
                    TMap(w,b,{f's{i}':f'b{i}_1'}))


class FourStagePasting(unittest.TestCase):
    def test_right_vs_left_association_in_full_example(self):
        s1,s2=example_interchange(True)
        steps=(s1,s2,s1,s2)
        direct=n_interchanger(steps)
        right=rightfold(steps)
        from wenhehua.lineage import horizontal
        h_right=horizontal(right)
        h_direct=horizontal(leftfold(steps))
        for local, right_inject, direct_inject in (
          (right.left,h_right.from_left,h_direct.from_left),
          (right.right,h_right.from_right,h_direct.from_right)):
            for w in local.witness.keys():
                direct_key=direct_inject(leftpair(flatten_right(w,4)))
                outcome=mapped_by_right_pasting(steps,right_inject(w))
                self.assertEqual(leftpair(outcome),direct.comparison(direct_key))

    def test_rich_four_stage_lax_pasting_is_not_invertible_but_coherent(self):
        steps=tuple(rich_step(i) for i in range(4))
        direct=n_interchanger(steps)
        self.assertFalse(direct.invertible)
        self.assertEqual(len(direct.horizontal_after_vertical.witness),31)
        self.assertEqual(len(direct.vertical_after_horizontal.witness),81)
        right=rightfold(steps)
        from wenhehua.lineage import horizontal
        h_right=horizontal(right)
        h_direct=horizontal(leftfold(steps))
        for local, right_inject, direct_inject in (
          (right.left,h_right.from_left,h_direct.from_left),
          (right.right,h_right.from_right,h_direct.from_right)):
            for w in local.witness.keys():
                direct_key=direct_inject(leftpair(flatten_right(w,4)))
                result=leftpair(mapped_by_right_pasting(steps,right_inject(w)))
                self.assertEqual(result,direct.comparison(direct_key))

    def test_rich_typed_interchanger_respects_endpoints(self):
        steps=tuple(rich_step(i) for i in range(4))
        c=n_interchanger(steps)
        for w in c.comparison.domain.keys():
            g=c.comparison(w)
            self.assertEqual(c.horizontal_after_vertical.to_before(w),
                             c.vertical_after_horizontal.to_before(g))
            self.assertEqual(c.horizontal_after_vertical.to_after(w),
                             c.vertical_after_horizontal.to_after(g))

    def test_number_of_uncovered_rich_histories(self):
        c=n_interchanger(tuple(rich_step(i) for i in range(4)))
        self.assertEqual(c.extra_mixed_histories,50)

if __name__=='__main__': unittest.main()
