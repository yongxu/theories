"""Regression tests for two revision rounds: boundaries, admissibility, semantics."""
import random
import unittest
from fractions import Fraction as F
import networkx as nx
from wenhehua import (Signature, Graph, Edge, Rule, Match, GrammarError,
    glue, compose_pair, compose_series, rename_ports, rewrite, match_graph,
    compatible_abstraction, strong_lumpability)
SIG = Signature(frozenset({'S'}), {'wire': (('S',), ('S',))})

def chain(a='a', b='b'):
    return Graph({a:'S', b:'S'}, {'e': Edge('wire',(a,),(b,))}, {'in':a,'out':b})

def incidence(g):
    """Port-name-preserving isomorphism of typed directed multigraphs."""
    x = nx.MultiDiGraph()
    for n,t in g.nodes.items(): x.add_node(('n',n), label=('node',t))
    for e,v in g.edges.items():
        x.add_node(('e',e), label=('edge',v.kind))
        for i,n in enumerate(v.sources): x.add_edge(('n',n),('e',e), role=('src',i))
        for i,n in enumerate(v.targets): x.add_edge(('e',e),('n',n), role=('tgt',i))
    for p,n in g.ports.items():
        x.add_node(('p',p),label=('port',p))
        x.add_edge(('p',p),('n',n),role=('at',0))
    return x

def equivalent(a,b):
    return nx.is_isomorphic(incidence(a),incidence(b),
        node_match=lambda a,b:a['label']==b['label'],
        edge_match=nx.algorithms.isomorphism.categorical_multiedge_match('role', None))

class RevisionTests(unittest.TestCase):
    def test_01_missing_boundary_yields_grammar_error(self):
        with self.assertRaisesRegex(GrammarError, 'missing connection port'):
            glue(SIG,chain(),chain('c','d'),{'absent':'in'})
    def test_02_missing_right_boundary_yields_grammar_error(self):
        with self.assertRaisesRegex(GrammarError, 'missing connection port'):
            glue(SIG,chain(),chain('c','d'),{'out':'absent'})
    def test_03_unchecked_raw_names_are_not_interface_associative(self):
        a,b,c=chain(),chain('u','v'),chain('x','y')
        ab=glue(SIG,a,b,{'out':'in'})
        lhs=glue(SIG,ab,c,{'R.out':'in'})
        bc=glue(SIG,b,c,{'out':'in'})
        rhs=glue(SIG,a,bc,{'out':'L.in'})
        self.assertNotEqual(set(lhs.ports),set(rhs.ports))
        self.assertFalse(equivalent(lhs,rhs))
    def test_04_canonical_port_interface_restores_associativity(self):
        a,b,c=chain(),chain('u','v'),chain('x','y')
        lhs=compose_pair(SIG,compose_pair(SIG,a,b),c)
        rhs=compose_pair(SIG,a,compose_pair(SIG,b,c))
        self.assertEqual(set(lhs.ports),{'in','out'})
        self.assertTrue(equivalent(lhs,rhs))
    def test_05_serial_fold_is_equivalent_to_parenthesized(self):
        graphs=[chain('a','b'),chain('c','d'),chain('e','f'),chain('g','h')]
        folded=compose_series(SIG,graphs)
        grouped=compose_pair(SIG,compose_pair(SIG,graphs[0],graphs[1]),
                             compose_pair(SIG,graphs[2],graphs[3]))
        self.assertTrue(equivalent(folded,grouped))
    def test_06_randomized_relabeling_and_parenthesization(self):
        for seed in range(30):
            r=random.Random(seed)
            # Vary internal topology and parallel directed edges, not just IDs.
            gs=[]
            for i in range(r.randint(3,6)):
                names=[f'{seed}_{i}_{j}' for j in range(r.randint(2,5))]
                edges={f'e{k}':Edge('wire',(r.choice(names),),(r.choice(names),))
                       for k in range(r.randint(1,6))}
                gs.append(Graph({name:'S' for name in names},edges,
                                {'in':names[0], 'out':names[-1]}))
            def group(xs):
                if len(xs)==1: return xs[0]
                cut=r.randint(1,len(xs)-1)
                return compose_pair(SIG,group(xs[:cut]),group(xs[cut:]))
            self.assertTrue(equivalent(compose_series(SIG,gs),group(gs)))
    def test_07_renaming_collision_rejected(self):
        with self.assertRaisesRegex(GrammarError,'duplicate external port name'):
            rename_ports(SIG,chain(),{'in':'one','out':'one'})
    def test_08_incomplete_renaming_rejected(self):
        with self.assertRaisesRegex(GrammarError,'cover exactly'):
            rename_ports(SIG,chain(),{'in':'start'})
    def test_09_invalid_series_empty_rejected(self):
        with self.assertRaisesRegex(GrammarError,'empty series'):
            compose_series(SIG,[])
    def test_10_non_two_port_compose_rejected(self):
        with self.assertRaisesRegex(GrammarError,'in/out'):
            compose_pair(SIG,chain(),Graph({'n':'S'}, {}, {'in':'n'}))
    def test_11_auto_match_skips_inadmissible_first_match(self):
        host=Graph({'a':'S','b':'S'},{},{'external':'a'})
        rule=Rule('delete',Graph({'x':'S'},{}),Graph({},{}))
        out=rewrite(SIG,host,rule)
        self.assertEqual(out.nodes,{'a':'S'})
    def test_12_explicit_bad_match_still_rejected(self):
        host=Graph({'a':'S','b':'S'},{},{'external':'a'})
        rule=Rule('delete',Graph({'x':'S'},{}),Graph({},{}))
        with self.assertRaisesRegex(GrammarError,'dangling open port'):
            rewrite(SIG,host,rule,Match({'x':'a'},{}))
    def test_13_lhs_rule_port_not_silently_ignored(self):
        bad=Rule('bad',Graph({'x':'S'},{},{'p':'x'}),Graph({'x':'S'},{}),{'x':'x'})
        with self.assertRaisesRegex(GrammarError,'rule-local ports unsupported'):
            bad.check(SIG)
    def test_14_edge_identification_not_allowed_by_vertex_glue(self):
        a,b=chain(),chain('x','y')
        out=glue(SIG,a,b,{'in':'in','out':'out'})
        self.assertEqual(len(out.nodes),2)
        self.assertEqual(len(out.edges),2)
    def test_15_external_port_aliasing_does_not_imply_security(self):
        a=Graph({'a':'S','b':'S'},{'e':Edge('wire',('a',),('b',))},{'in':'a','out':'b','alias':'b'})
        out=glue(SIG,a,chain('c','d'),{'out':'in'})
        self.assertEqual(out.ports['L.alias'],out.nodes and out.edges['R::e'].sources[0])
    def test_16_state_space_not_closed_error(self):
        with self.assertRaisesRegex(GrammarError,'leave'):
            compatible_abstraction([0,1],lambda x:x+1,lambda x:x%2)
    def test_17_state_space_empty_error(self):
        with self.assertRaisesRegex(GrammarError,'nonempty'):
            compatible_abstraction([],lambda x:x,lambda x:x)
    def test_18_deterministic_macro_good(self):
        ok, macro, why=compatible_abstraction(range(4),lambda x:(x+2)%4,lambda x:x%2)
        self.assertTrue(ok); self.assertIsNone(why)
        self.assertEqual(macro,{0:0,1:1})
    def test_19_lumpability_good_with_microstate_variation(self):
        # Different micro outcomes, but each block's aggregate probability agrees.
        states=('a1','a2','b1','b2')
        p={'a1':{'a2':F(1,2),'b1':F(1,2)},
           'a2':{'a1':F(1,2),'b2':F(1,2)},
           'b1':{'b2':F(1,4),'a1':F(3,4)},
           'b2':{'b1':F(1,4),'a2':F(3,4)}}
        alpha=lambda s:s[0]
        ok,k,why=strong_lumpability(states,p,alpha)
        self.assertTrue(ok);self.assertIsNone(why)
        self.assertEqual(k['a'],{'a':F(1,2),'b':F(1,2)})
        self.assertEqual(k['b'],{'a':F(3,4),'b':F(1,4)})
    def test_20_non_lumpability_has_counterexample(self):
        s=('a1','a2','b1')
        p={'a1':{'a1':F(1,2),'b1':F(1,2)},'a2':{'a2':F(1,1)},'b1':{'b1':F(1,1)}}
        ok,_,why=strong_lumpability(s,p,lambda x:x[0])
        self.assertFalse(ok);self.assertEqual(why[1],'a')
    def test_21_reject_invalid_markov_row(self):
        with self.assertRaisesRegex(GrammarError,'sum to 1'):
            strong_lumpability([0,1],{0:{1:F(1,3)},1:{1:F(1,1)}},lambda x:x)
    def test_22_reject_probability_to_unknown_state(self):
        with self.assertRaisesRegex(GrammarError,'outside'):
            strong_lumpability([0],{0:{2:F(1)}},lambda x:x)
    def test_23_markov_missing_row_rejected(self):
        with self.assertRaisesRegex(GrammarError,'missing transition row'):
            strong_lumpability([0,1],{0:{0:F(1)}},lambda x:x)
    def test_24_petri_bool_resource_not_allowed(self):
        from wenhehua import PetriModel,Reaction
        p=PetriModel({'x':'resource'},{'bad':Reaction({'x':True},{})},{'x':1})
        with self.assertRaisesRegex(GrammarError,'invalid reaction stoichiometry'):
            p.check()
    def test_25_markov_deterministic_case_is_special_case(self):
        s=(0,1,2,3)
        p={x:{(x+2)%4:F(1)} for x in s}
        ok,_,_=strong_lumpability(s,p,lambda x:x%2)
        self.assertTrue(ok)

if __name__=='__main__':unittest.main()
