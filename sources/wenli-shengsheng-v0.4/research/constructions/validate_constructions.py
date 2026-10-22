"""Check registry structure and explicit finite tables. This is not the G1 engine."""
import argparse
import hashlib
import json
from pathlib import Path

HERE=Path(__file__).resolve().parent
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--check',action='store_true',help='Recompute and compare saved results without overwriting them.')
args=parser.parse_args()
lexicon_name='08_组合文法逐字类型词典_v0.3.json'
lex_path=HERE.parent/'references'/lexicon_name
if not lex_path.is_file():
    lex_path=next((p/'outputs'/lexicon_name for p in HERE.parents if (p/'outputs'/lexicon_name).is_file()),None)
    if lex_path is None:
        raise SystemExit('Missing bundled ../references/'+lexicon_name+' and no compatible ancestor outputs copy was found.')
data=json.loads((HERE/'constructions.json').read_text())
lex=json.loads(lex_path.read_text())
cards={c['name']:c for c in data['focused_cards']}
results=[]

def check(group,name,actual,expected=True):
    passed=actual==expected
    results.append({'group':group,'check':name,'passed':passed,'actual':actual,'expected':expected})
    return passed

def rel(m,name):
    return {tuple(e) for e in m.get('programs',m.get('program_relations',{})).get(name,[])}

def seq(a,b):
    return {(x,z) for x,y in a for yy,z in b if y==yy}

def steps(r,n,states):
    out={(s,s) for s in states}
    for _ in range(n): out=seq(out,r)
    return out

def star(r,states):
    out={(s,s) for s in states}|r
    while True:
        more=out|seq(out,r)
        if more==out: return out
        out=more

def can(r,s,targets): return any(a==s and b in targets for a,b in r)
def all_after(r,s,targets): return all(b in targets for a,b in r if a==s)
def model(name,n=0): return cards[name]['micro_models'][n]
def calc(name,actual,expected=True): return check('finite_calculation',name,actual,expected)

check('structure','32 frozen row IDs',[r['id'] for r in data['registry']],[f'R{i:02}' for i in range(1,33)])
check('structure','67 surface labels',sum(len(r['surface_labels']) for r in data['registry']),67)
check('structure','12 requested focused cards',list(cards),['生生','感应','中和','变通','分合','名实','本末','虚实','阴阳','自然','无为','相生'])
check('structure','13 finite specifications',sum(len(c['micro_models']) for c in cards.values()),13)
check('structure','one supplement',data['supplementary_registry'][0]['label'],'分合')
check('structure','分合 does not claim inherited row',cards['分合']['source_row_ids'],[])
check('structure','然 unregistered explicitly',cards['自然']['character_coverage']['not_registered_in08'],['然'])
all_senses={s['sense_id'] for c in lex['core_lexemes'] for s in c['senses']}
all_senses|={s['sense_id'] for s in lex['syntax_entries']+lex['extension_entries']}
required=['id','name','unit','sources','selected_reading','components','component_relation','whole_meaning','non_compositional_residue','textual_constraints','modern_additions','facts_vs_norms','g1_interface','rules','consequences','micro_models','failure_example','evidence_status']
for c in cards.values():
    check('structure',c['name']+' complete fields',all(k in c and c[k] not in (None,[],{}) for k in required))
    for sid in c['existing_sense_ids']: check('structure',c['name']+' existing sense '+sid,sid in all_senses)
    for s in c['sources']:
        check('structure',c['name']+' source '+s['source_id'],s['source_id'] in lex['sources'] and bool(s['url']) and bool(s['short_quotes']))
    for m in c['micro_models']:
        check('structure',m['context_id']+' context/states',bool(m['context_id']) and len(set(m['states']))==len(m['states']))
        for name,edges in m.get('programs',m.get('program_relations',{})).items():
            check('structure',m['context_id']+'/'+name+' edge endpoints',all(len(e)==2 and all(x in m['states'] for x in e) for e in edges))
for r in data['registry']:
    check('structure',r['id']+' inherited source IDs',all(s in lex['sources'] for s in r['source_ids']))

m=model('生生'); alive=set(m['predicates']['Alive']); gen=rel(m,'gen')
gen_safe={(a,b) for a,b in gen if b in alive}
gen_t=lambda s,n: s in alive and can(steps(gen_safe,n,m['states']),s,set(m['states']))
calc('生生 Alive agrees with nonempty extant table',alive,{s for s in m['states'] if m['extant'][s]})
calc('生生 gen is subset of positive tick',gen<=rel(m,'tick'))
calc('生生 two real generation steps',gen_t('s0',2))
calc('生生 third generation fails',gen_t('s0',3),False)
calc('生生 zero steps require initial Alive and can hold',gen_t('s0',0))
calc('生生 zero steps fail at dead initial state',gen_t('s4',0),False)
births=[set(m['extant'][b])-set(m['extant'][a]) for a,b in sorted(gen)]
calc('生生 each gen edge introduces an identity',all(bool(x) for x in births))
calc('生生 two births never reuse identities',sum(map(len,births))==len(set().union(*births))==2)
calc('生生 finite fresh identity budget exactly two',len(set(m['entity_domain'])-set(m['extant']['s0'])),2)
calc('生生 a dies while c appears','a' in m['extant']['s1'] and 'a' not in m['extant']['s2'] and 'c' not in m['extant']['s1'] and 'c' in m['extant']['s2'])
safe={(a,b) for a,b in rel(m,'tick') if a in alive and b in alive}
calc('生生 safe tick horizon 3',can(steps(safe,3,m['states']),'s0',alive))
calc('生生 safe tick horizon 4 fails',can(steps(safe,4,m['states']),'s0',alive),False)

m=model('感应'); response=seq(rel(m,'stimulus'),rel(m,'respond'))
loop=seq(seq(response,rel(m,'feedback')),rel(m,'reset'))
calc('感应 response completes',can(response,'s0',{'s2'}))
calc('感应 feedback returns',can(loop,'s0',{'s0'}))
calc('感应 removing feedback breaks loop',can(seq(seq(response,set()),rel(m,'reset')),'s0',{'s0'}),False)

m=model('中和'); vals=m['state_predicates']['Expressed(Expression)']; norms=m['norm_table']['judgements']
he=lambda s: bool(vals[s]) and all(norms[e[0]]=='admissible' for e in vals[s])
calc('中和 unexpressed is not vacuous He',he('unexpressed'),False)
calc('中和 soft fits explicit V',he('soft_done'))
calc('中和 harsh fails explicit V',he('harsh_done'),False)
responsive=rel(m,'respond_soft')|rel(m,'respond_harsh'); approved={s for s in m['states'] if he(s)}
calc('中和 some approved path',can(responsive,'unexpressed',approved))
calc('中和 not every allowed fact edge approved',all_after(responsive,'unexpressed',approved),False)

m=model('变通'); done=set(m['predicates']['Done']); reach=star(rel(m,'execute'),m['states']); cr={s for s in m['states'] if can(reach,s,done)}
calc('变通 exact CanReach set',sorted(cr),['done','routeA'])
calc('变通 a successful candidate',can(rel(m,'reconfigure'),'blocked',cr))
calc('变通 not all candidates successful',all_after(rel(m,'reconfigure'),'blocked',cr),False)
calc('变通 done need not have tick',can(rel(m,'tick'),'done',set(m['states'])),False)

m=model('分合'); split=rel(m,'split'); merge=rel(m,'merge')
calc('分合 split then merge',sorted(seq(split,merge)),[('a','a')])
calc('分合 merge then split not identity',len(seq(merge,split)),4)
calc('分合 can restore b',can(seq(merge,split),'b',{'b'}))
calc('分合 not guaranteed to restore b',all_after(seq(merge,split),'b',{'b'}),False)
calc('分合 each partition disjoint cover',all(sorted(x for block in p for x in block)==sorted(m['member_domain']) for p in m['partitions'].values()))

m=model('名实'); denotes={tuple(e) for e in m['fixed_predicates']['Denotes(Symbol,Entity)']}; used=m['state_predicates']['UsedName(Symbol,Entity)']
consistent={s for s in m['states'] if {tuple(e) for e in used[s]}<=denotes}
calc('名实 exact consistency states',sorted(consistent),['correct','repaired'])
calc('名实 repair restores consistency',can(rel(m,'repair'),'confused',consistent))
calc('名实 repair does not recolor B',['B'] in m['fixed_predicates']['Red(Entity)'],False)

m=model('本末'); base=set(m['state_predicates']['BaseReady()']); work=set(m['state_predicates']['EndWorking()'])
calc('本末 dependency invariant',work<=base)
calc('本末 repair not sufficient',can(rel(m,'repair'),'off',work),False)
calc('本末 repair plus activate works',can(seq(rel(m,'repair'),rel(m,'activate')),'off',work))

m=model('虚实'); wp=m['state_predicates']['Weak(Route)']; sp=m['state_predicates']['Strong(Route)']
calc('虚实 explicit threshold agrees with tables',all((([r] in wp[s])==(v<3) and ([r] in sp[s])==(v>=3)) for s,rv in m['configuration'].items() for r,v in rv.items()))
calc('虚实 A currently passable',can(rel(m,'try_A'),'r15',{'pass'}))
calc('虚实 stale A choice fails after reallocation',can(seq(rel(m,'reallocate'),rel(m,'try_A')),'r15',{'fail'}))
calc('虚实 no weak route is possible',wp['r33'],[])

m=model('阴阳'); tick=rel(m,'tick')
calc('阴阳 one specified step reaches yang',can(tick,'yin',{'yang'}))
calc('阴阳 two specified steps return yin',can(seq(tick,tick),'yin',{'yin'}))
stationary={tuple(e) for e in m['countermodel']['program_relations']['tick']}
calc('阴阳 same classification can be stationary',can(stationary,'yin',{'yang'}),False)

m=model('自然'); local=rel(m,'local_tick'); noc=set(m['predicate_extensions']['NoExternalCommand']); natural={(a,b) for a,b in local if a in noc and b in noc}
calc('自然 wet local process reaches mature',can(seq(natural,natural),'seed_wet',{'mature_wet'}))
calc('自然 dry no-command not sufficient',can(star(natural,m['states']),'seed_dry',{'mature_wet'}),False)
calc('自然 no-command compatible with failure','seed_dry' in noc and can(rel(m,'dry_tick'),'seed_dry',{'failed_dry'}))

m=model('无为'); desire=set(m['predicate_extensions']['Desire']); policy={(a,b) for a,b in rel(m,'let') if a not in desire}|{(a,b) for a,b in rel(m,'restore') if a in desire}
calc('无为 conditional policy reaches stable',can(seq(policy,policy),'d',{'stable'}))
calc('无为 blanket let fails',can(seq(rel(m,'let'),rel(m,'let')),'d',{'stable'}),False)
calc('无为 explicit permission is separate input',any(v['state']=='d' and v['action']=='restore' and v['decision']=='permitted' for v in cards['无为']['facts_vs_norms']['V_table']))
bad_policy={(a,b) for a,b in rel(m,'let') if a not in desire}|{('d','broken')}
calc('无为 same permission cannot fix broken effect',all_after(bad_policy,'d',set(m['states'])-{'broken'}),False)

m=model('相生'); cd={tuple(e) for e in m['predicate_extensions']['CoDetermines']}
calc('相生 conceptual relation is reciprocal',('有','无') in cd and ('无','有') in cd)
calc('相生 conceptual relation does not fill Causes',m['predicate_extensions']['Causes'],[])
m=model('相生',1); tick=rel(m,'tick')
calc('相生 direct reverse absent',can(tick,'fire',{'wood'}),False)
calc('相生 two-step path not direct edge',can(seq(tick,tick),'wood',{'earth'}) and ('wood','earth') not in tick)
calc('相生 five token steps return',can(steps(tick,5,m['states']),'wood',{'wood'}))
calc('相生 missing resource edge stops cycle',can(steps(tick-{('water','wood')},5,m['states']),'wood',{'wood'}),False)

summary={'checker':'independent finite-table assertions; not G1 engine',
 'input_sha256':hashlib.sha256((HERE/'constructions.json').read_bytes()).hexdigest(),
 'checks':len(results),'passed':sum(r['passed'] for r in results),
 'structure_checks':sum(r['group']=='structure' for r in results),
 'finite_calculations':sum(r['group']=='finite_calculation' for r in results),
 'scope':'核对显式表、引用与若干核心推论；不执行自然语言解析，不证明原典解释或经验因果。',
 'results':results}
# Normalize finite sets/tuples to deterministic JSON values before comparing a saved run.
summary=json.loads(json.dumps(summary,ensure_ascii=False,default=lambda v:sorted(v)))
result_path=HERE/'validation_results.json'
if args.check:
    saved=json.loads(result_path.read_text())
    if saved!=summary: raise SystemExit('CHECK FAILED: saved results or input fingerprint differ; nothing overwritten.')
else:
    result_path.write_text(json.dumps(summary,ensure_ascii=False,indent=2)+'\n')
print(json.dumps({k:v for k,v in summary.items() if k!='results'},ensure_ascii=False))
if not all(r['passed'] for r in results): raise SystemExit('FAILED: '+','.join(r['check'] for r in results if not r['passed']))
