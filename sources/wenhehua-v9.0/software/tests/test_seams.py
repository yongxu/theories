from __future__ import annotations
import unittest
from wenhehua.core import Graph,Match,GrammarError,Signature
from wenhehua.higher import OpenGraph
from wenhehua.evolving import Evolution,InterfaceTrace
from wenhehua.seams import SeamContract,horizontal_changing_seam

SIG = Signature(frozenset({'N','T'}),{})


def mk_graph(p,ins,outs, *, shared=False):
    """Each port has one internal node; optional cross-side port alias."""
    nodes={};ports={}
    for side, ntypes in [('in',ins),('out',outs)]:
        for j,t in enumerate(ntypes):
            key=f'{p}_{side}_{j}'; nodes[key]=t;ports[f'{side}:{j}']=key
    return OpenGraph(Graph(nodes,{},ports),tuple(ins),tuple(outs))


def ev_with_trace(before,after,trace,keep_before,keep_after):
    """Matched pair of equal-length node name lists describing common graph."""
    assert len(keep_before)==len(keep_after)
    common=Graph({f'c{i}':before.graph.nodes[b] for i,b in enumerate(keep_before)}, {})
    maps_b={f'c{i}':b for i,b in enumerate(keep_before)}
    maps_a={f'c{i}':a for i,a in enumerate(keep_after)}
    evo=Evolution(before,after,common,Match(maps_b,{}),Match(maps_a,{}),trace)
    evo.check(SIG)
    return evo


def aligned(before,after,ins,outs,old_extras=(),new_extras=()):
    """Shared port identities by aligned integer positions, with opt-in extra persisting nodes."""
    bnames=[];anames=[]
    for side,pairs in [('in',ins),('out',outs)]:
        for i,j in pairs:
            bnames.append(before.graph.ports[f'{side}:{i}'])
            anames.append(after.graph.ports[f'{side}:{j}'])
    bnames.extend(old_extras);anames.extend(new_extras)
    return ev_with_trace(before,after,InterfaceTrace(tuple(ins),tuple(outs)),bnames,anames)

class SharedSeamTests(unittest.TestCase):
    def test_new_shared_port_creation_without_old_identity(self):
        lb=mk_graph('lb',['N'],['N'])
        la=mk_graph('la',['N'],['N','T'])
        rb=mk_graph('rb',['N'],['N'])
        ra=mk_graph('ra',['N','T'],['N'])
        left=aligned(lb,la,((0,0),),((0,0),))
        right=aligned(rb,ra,((0,0),),((0,0),))
        ev=horizontal_changing_seam(SIG,left,right,SeamContract(((0,0),)))
        self.assertEqual(len(ev.before.graph.nodes),3)
        self.assertEqual(len(ev.after.graph.nodes),4)
        self.assertEqual(ev.trace.inputs,((0,0),))
        self.assertEqual(ev.trace.outputs,((0,0),))
        ev.check(SIG)

    def test_old_shared_port_removal_without_preservation(self):
        lb=mk_graph('lb',['N'],['N','T'])
        la=mk_graph('la',['N'],['N'])
        rb=mk_graph('rb',['N','T'],['N'])
        ra=mk_graph('ra',['N'],['N'])
        left=aligned(lb,la,((0,0),),((0,0),))
        right=aligned(rb,ra,((0,0),),((0,0),))
        e=horizontal_changing_seam(SIG,left,right,SeamContract(((0,0),)))
        e.check(SIG)
        self.assertEqual(len(e.before.graph.nodes),4)
        self.assertEqual(len(e.after.graph.nodes),3)

    def test_empty_seam_growth_strict_when_fresh_vertices(self):
        lb=mk_graph('lb',['N'],[]);la=mk_graph('la',['N'],['T'])
        rb=mk_graph('rb',[],['N']);ra=mk_graph('ra',['T'],['N'])
        le=aligned(lb,la,((0,0),),())
        re=aligned(rb,ra,(),((0,0),))
        e=horizontal_changing_seam(SIG,le,re,SeamContract(()))
        self.assertEqual(len(e.before.graph.nodes),2)
        self.assertEqual(len(e.after.graph.nodes),3)
        e.check(SIG)

    def test_fusion_conflict_strict_and_forget(self):
        lb=mk_graph('lb',['N'],[]);la=mk_graph('la',['N'],['N'])
        rb=mk_graph('rb',[],['N']);ra=mk_graph('ra',['N'],['N'])
        # Both seam vertices preexist as private internal nodes in both parts;
        # exposing them makes them collide AFTER composition.
        lb.graph.nodes['lb_new']='N';la.graph.ports['out:0']='lb_new';la.graph.nodes['lb_new']='N'
        rb.graph.nodes['rb_new']='N';ra.graph.ports['in:0']='rb_new';ra.graph.nodes['rb_new']='N'
        le=aligned(lb,la,((0,0),),(),('lb_new',),('lb_new',))
        re=aligned(rb,ra,(),((0,0),),('rb_new',),('rb_new',))
        with self.assertRaisesRegex(GrammarError,'non-monic witness'):
            horizontal_changing_seam(SIG,le,re,SeamContract(()))
        out=horizontal_changing_seam(SIG,le,re,SeamContract((), 'forget_conflicts'))
        out.check(SIG)
        self.assertEqual(len(out.common.nodes),2)
        self.assertEqual(len(out.after.graph.nodes), len(la.graph.nodes)+len(ra.graph.nodes)-1)

    def test_fission_conflict_strict_and_forget(self):
        lb=mk_graph('lb',['N'],['N']);la=mk_graph('la',['N'],[])
        rb=mk_graph('rb',['N'],['N']);ra=mk_graph('ra',[],['N'])
        la.graph.nodes[lb.graph.ports['out:0']] = 'N'
        ra.graph.nodes[rb.graph.ports['in:0']] = 'N'
        le=aligned(lb,la,((0,0),),(),
               (lb.graph.ports['out:0'],),(lb.graph.ports['out:0'],))
        re=aligned(rb,ra,(),((0,0),),
               (rb.graph.ports['in:0'],),(rb.graph.ports['in:0'],))
        with self.assertRaisesRegex(GrammarError,'non-monic'):
            horizontal_changing_seam(SIG,le,re,SeamContract(()))
        out=horizontal_changing_seam(SIG,le,re,SeamContract((),'forget_conflicts'))
        out.check(SIG)
        self.assertEqual(len(out.common.nodes),2)

    def test_seam_contract_is_mandatory(self):
        lb=mk_graph('lb',['N'],['N']);rb=mk_graph('rb',['N'],['N'])
        le=Evolution.identity(SIG,lb);re=Evolution.identity(SIG,rb)
        with self.assertRaisesRegex(GrammarError,'explicitly certified'):
            horizontal_changing_seam(SIG,le,re,SeamContract(()))

    def test_disagreeing_persistent_seam_rejected(self):
        lb=mk_graph('lb',['N'],['N']);rb=mk_graph('rb',['N'],['N'])
        le=Evolution.identity(SIG,lb);re=Evolution.identity(SIG,rb)
        re.trace=InterfaceTrace((),((0,0),))
        with self.assertRaises(GrammarError):
            horizontal_changing_seam(SIG,le,re,SeamContract(((0,0),)))

    def test_type_mismatch_rejected(self):
        lb=mk_graph('lb',['N'],['T']);rb=mk_graph('rb',['N'],['N'])
        le=Evolution.identity(SIG,lb);re=Evolution.identity(SIG,rb)
        with self.assertRaisesRegex(GrammarError,'old shared seam types disagree'):
            horizontal_changing_seam(SIG,le,re,SeamContract(((0,0),)))

    def test_forget_cannot_break_outer_trace(self):
        lb=mk_graph('lb',['N'],[]);la=mk_graph('la',['N'],['N'])
        rb=mk_graph('rb',[],['N']);ra=mk_graph('ra',['N'],['N'])
        # Both future seam nodes alias outer traced ports, which cannot both
        # persist as distinct identities AFTER becoming identified.
        la.graph.ports['out:0'] = la.graph.ports['in:0']
        ra.graph.ports['in:0'] = ra.graph.ports['out:0']
        le=aligned(lb,la,((0,0),),())
        re=aligned(rb,ra,(),((0,0),))
        with self.assertRaises(GrammarError):
            horizontal_changing_seam(SIG,le,re,SeamContract((),'forget_conflicts'))

    def test_stable_seam_and_existing_operator_agree(self):
        from wenhehua.evolving import horizontal_evolution
        lb=mk_graph('lb',['N'],['N']);rb=mk_graph('rb',['N'],['N'])
        le=Evolution.identity(SIG,lb);re=Evolution.identity(SIG,rb)
        e=horizontal_changing_seam(SIG,le,re,SeamContract(((0,0),)))
        f=horizontal_evolution(SIG,le,re)
        self.assertEqual(e.before,f.before)
        self.assertEqual(e.after,f.after)
        self.assertEqual(e.trace,f.trace)

if __name__=='__main__':unittest.main()

class WeakeningIsNotFunctorial(unittest.TestCase):
    def test_transient_fusion_and_fission_loses_identity_information(self):
        """Proof by counterexample: lossful repair is not an interchange law.

        A and B each keep a private N-node across all steps. At the middle
        stage they expose the nodes as a shared connection (fusion), then
        withdraw it (fission). Pasting stepwise needs to forget both identity
        witnesses; composing each component's local evolution over two steps
        and then pasting does not. The two span witnesses differ.
        """
        def make(side,exposed):
            n={'outer':'N','private':'N'}
            p={'in:0':'outer'} if side=='left' else {'out:0':'outer'}
            if exposed:p['out:0' if side=='left' else 'in:0']='private'
            ins=('N',) if side=='left' else (('N',) if exposed else ())
            outs=(('N',) if exposed else ()) if side=='left' else ('N',)
            return OpenGraph(Graph(dict(n),{},p),ins,outs)
        a0,a1,a2=make('left',False),make('left',True),make('left',False)
        b0,b1,b2=make('right',False),make('right',True),make('right',False)
        def local(before,after,left):
            tr=InterfaceTrace(((0,0),),()) if left else InterfaceTrace((),((0,0),))
            return ev_with_trace(before,after,tr,('outer','private'),('outer','private'))
        al1,al2=local(a0,a1,True),local(a1,a2,True)
        br1,br2=local(b0,b1,False),local(b1,b2,False)
        stage1=horizontal_changing_seam(SIG,al1,br1,SeamContract((),'forget_conflicts'))
        stage2=horizontal_changing_seam(SIG,al2,br2,SeamContract((),'forget_conflicts'))
        from wenhehua.evolving import vertical_evolution
        stepwise=vertical_evolution(SIG,stage1,stage2)
        local_first=horizontal_changing_seam(
            SIG,vertical_evolution(SIG,al1,al2),
            vertical_evolution(SIG,br1,br2), SeamContract(()))
        stepwise.check(SIG);local_first.check(SIG)
        self.assertEqual(stepwise.before,local_first.before)
        self.assertEqual(stepwise.after,local_first.after)
        self.assertEqual(len(stepwise.common.nodes),2)  # only outer retained
        self.assertEqual(len(local_first.common.nodes),4) # private continuity retained
        self.assertNotEqual(len(stepwise.common.nodes),len(local_first.common.nodes))
