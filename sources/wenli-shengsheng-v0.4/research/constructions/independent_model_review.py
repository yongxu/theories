"""Independent finite-table review. Does not import the main validator or consume hand_checks/expected."""
import argparse
import hashlib
import json
from pathlib import Path

HERE=Path(__file__).resolve().parent
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--check',action='store_true',help='Recompute JSON and Markdown reports and compare them without writing files.')
args=parser.parse_args()
raw=(HERE/'constructions.json').read_bytes()
data=json.loads(raw)
cards={c['id']:c for c in data['focused_cards']}
checks=[]

def m(cid,n=0): return cards[cid]['micro_models'][n]
def edges(model,name): return [tuple(e) for e in model.get('programs',model.get('program_relations',{})).get(name,[])]
def nxt(frontier,relation):
    answer=set()
    for source,target in relation:
        if source in frontier: answer.add(target)
    return answer

def path(start,relations):
    states={start}
    for relation in relations: states=nxt(states,relation)
    return states

def closure(start,relation):
    seen={start}; frontier={start}
    while frontier:
        fresh=nxt(frontier,relation)-seen
        seen.update(fresh); frontier=fresh
    return seen

def sorted_json(x):
    if isinstance(x,set): return sorted(x)
    return x

def check(cid,title,actual,required,derivation):
    actual=sorted_json(actual); required=sorted_json(required)
    checks.append({'card':cid,'check':title,'computed':actual,'review_requirement':required,'passed':actual==required,'calculation_basis':derivation})

# CX01: evaluate the displayed GenT rather than replacing it with plain gen^n.
x=m('CX01'); alive=set(x['predicates']['Alive']); gen=edges(x,'gen'); ticks=edges(x,'tick')
def genT(start,n):
    if start not in alive: return False
    reachable={start}
    for _ in range(n): reachable={t for t in nxt(reachable,gen) if t in alive}
    return bool(reachable)
check('CX01','Alive agrees exactly with nonempty extant rows',alive,{s for s,es in x['extant'].items() if es},'Read predicates.Alive and every extant list independently.')
check('CX01','gen edges equal tick edges introducing a presently absent identity',set(gen),{(a,b) for a,b in ticks if set(x['extant'][b])-set(x['extant'][a])},'Compute destination-minus-source identity sets for each tick.')
check('CX01','GenT at s0 for T=0..5',[genT('s0',n) for n in range(6)],[True,True,True,False,False,False],'Start Alive guard, then apply gen and filter target Alive at every repetition.')
check('CX01','GenT(0) at all five states',{s:genT(s,0) for s in x['states']},{'s0':True,'s1':True,'s2':True,'s3':True,'s4':False},'Zero repetition retains the starting state; outer Alive remains mandatory.')
check('CX01','Alive at s2 does not enable gen',bool(alive & {'s2'}) and not nxt({'s2'},gen),True,'Check s2 membership and empty gen successor set separately.')
safe=[(a,b) for a,b in ticks if a in alive and b in alive]
check('CX01','three safe positive ticks succeed but four fail',[bool(path('s0',[safe]*n)) for n in [3,4]],[True,False],'Filter each actual tick by both endpoint Alive values, then advance frontier.')
# All supplied identities along the unique tick path are examined with a growing seen set.
seen=set(x['extant']['s0']); fresh_events=[]; current='s0'
while nxt({current},ticks):
    successors=nxt({current},ticks)
    if len(successors)!=1: raise RuntimeError('This audit expected the supplied CX01 chain, not a branch.')
    following=next(iter(successors)); fresh=set(x['extant'][following])-seen
    fresh_events.append({'edge':[current,following],'globally_new':sorted(fresh)})
    seen.update(x['extant'][following]); current=following
check('CX01','globally fresh births on the supplied chain',[e['globally_new'] for e in fresh_events],[['b'],['c'],[],[]],'Keep accumulated Seen identities; do not merely compare adjacent extant rows.')
check('CX01','all displayed horizons respect prefix monotonicity',all(not genT(s,n+1) or genT(s,n) for s in x['states'] for n in range(6)),True,'Direct evaluation for each state and T=0..6; the general result also follows by truncating witnesses.')

x=m('CX02'); response=[edges(x,'stimulus'),edges(x,'respond')]
check('CX02','response endpoint',path('s0',response),{'s2'},'Sequential frontier traversal of stimulus then respond.')
check('CX02','feedback closed endpoint',path('s0',response+[edges(x,'feedback'),edges(x,'reset')]),{'s0'},'Traverse all four named edge tables.')
check('CX02','removing feedback preserves response but destroys full episode',[bool(path('s0',response)),bool(path('s0',response+[[],edges(x,'reset')]))],[True,False],'Only the feedback table is replaced by empty.')

x=m('CX03'); records=x['state_predicates']['Expressed(Expression)']; norms=x['norm_table']['judgements']
he={s:len(records[s])>0 and all(norms[e[0]]=='admissible' for e in records[s]) for s in x['states']}
check('CX03','norm evaluation includes nonempty precondition',he,{'unexpressed':False,'soft_done':True,'harsh_done':False},'Read complete expression records and the independently specified V table.')
all_response=edges(x,'respond_soft')+edges(x,'respond_harsh'); ends=nxt({'unexpressed'},all_response)
check('CX03','exists approved successor but not all successors approved',[any(he[s] for s in ends),all(he[s] for s in ends)],[True,False],'Quantify over actual response successors, then consult He evaluation.')
check('CX03','deleting soft edge destroys approved reachability',any(he[s] for s in nxt({'unexpressed'},edges(x,'respond_harsh'))),False,'Keep the same V and expression tables; retain only harsh response edge.')

x=m('CX04'); done=set(x['predicates']['Done']); viable={s for s in x['states'] if closure(s,edges(x,'execute')) & done}
check('CX04','exact execute-star reachable-goal set',viable,{'routeA','done'},'Breadth first closure includes zero steps, not plain Open membership.')
ends=nxt({'blocked'},edges(x,'reconfigure'))
check('CX04','reconfiguration succeeds existentially but not universally',[bool(ends&viable),ends<=viable],[True,False],'Compute all three reconfiguration destinations and intersect viable states.')
check('CX04','target has no positive continuation',nxt(done,edges(x,'tick')),set(),'Read tick edge table at done; star reflexivity does not count as a next step.')

x=m('CX05'); split=edges(x,'split'); merge=edges(x,'merge')
check('CX05','split then merge at a',path('a',[split,merge]),{'a'},'Traverse split choices and merge their successors.')
check('CX05','merge then split at b admits changed partition',path('b',[merge,split]),{'b','c'},'Compute all branches, not only one witness.')
check('CX05','partitions are disjoint nonempty covers',all(all(len(block)>0 for block in blocks) and len([u for block in blocks for u in block])==len(set(u for block in blocks for u in block)) and set(u for block in blocks for u in block)==set(x['member_domain']) for blocks in x['partitions'].values()),True,'Check nonempty blocks, no repeated member, and exact member set at every configuration.')

x=m('CX06'); denotes={tuple(e) for e in x['fixed_predicates']['Denotes(Symbol,Entity)']}; uses=x['state_predicates']['UsedName(Symbol,Entity)']
consistent={s for s in x['states'] if all(tuple(p) in denotes for p in uses[s])}
check('CX06','exact consistent naming states',consistent,{'correct','repaired'},'Check each used symbol/object pair against the fixed denotation relation.')
check('CX06','repair reaches consistency but cannot recolor B',[bool(nxt({'confused'},edges(x,'repair'))&consistent),any(e==['B'] for e in x['fixed_predicates']['Red(Entity)'])],[True,False],'First compute repair targets; object color is a separately fixed predicate.')

x=m('CX07'); base=set(x['state_predicates']['BaseReady()']); work=set(x['state_predicates']['EndWorking()'])
check('CX07','dependency valid but base insufficient',[work<=base,base<=work],[True,False],'Necessary condition is set inclusion in the indicated direction only.')
check('CX07','repair alone fails while repair-activate succeeds',[bool(path('off',[edges(x,'repair')])&work),bool(path('off',[edges(x,'repair'),edges(x,'activate')])&work)],[False,True],'Use the raw two distinct action tables.')

x=m('CX08'); weak=x['state_predicates']['Weak(Route)']; strong=x['state_predicates']['Strong(Route)']
check('CX08','all configuration thresholds agree with explicit predicates',all(((res<3)==([r] in weak[s])) and ((res>=3)==([r] in strong[s])) for s,rs in x['configuration'].items() for r,res in rs.items()),True,'Compare all six numerical capacities to 3; terminal states are outside this classification domain.')
check('CX08','current A succeeds; stale A after reallocation fails',[sorted(path('r15',[edges(x,'try_A')])),sorted(path('r15',[edges(x,'reallocate'),edges(x,'try_A')]))],[['pass'],['fail']],'Directly propagate state frontiers using action tables.')
check('CX08','r33 has no weak channel',weak['r33'],[],'Read both capacities at 3 and evaluate the strict less-than threshold.')

x=m('CX09'); tick=edges(x,'tick')
check('CX09','two positive steps return yin',path('yin',[tick,tick]),{'yin'},'Two successor operations on the supplied flip relation.')
stationary=[tuple(e) for e in x['countermodel']['program_relations']['tick']]
check('CX09','same classification with stationary relation cannot reach yang',bool(closure('yin',stationary)&set(x['predicate_extensions']['YangPhase'])),False,'Use countermodel raw edges and unchanged classification; any finite path remains yin.')

x=m('CX10'); no_command=set(x['predicate_extensions']['NoExternalCommand']); natural=[(a,b) for a,b in edges(x,'local_tick') if a in no_command and b in no_command]; mature=set(x['predicate_extensions']['Mature'])
check('CX10','wet two-step maturation and dry impossibility',[bool(path('seed_wet',[natural,natural])&mature),bool(closure('seed_dry',natural)&mature)],[True,False],'Apply no-command tests at both ends of local edges before graph traversal.')
check('CX10','stated Water implication is true at every supplied state',all(s not in set(x['predicate_extensions']['Water']) or s not in no_command or bool(path(s,[natural,natural])&mature) for s in x['states']),True,'Evaluate antecedent and two-step consequent per state, including mature self-loop.')

x=m('CX11'); desire=set(x['predicate_extensions']['Desire']); policy=[e for e in edges(x,'let') if e[0] not in desire]+[e for e in edges(x,'restore') if e[0] in desire]
check('CX11','guarded policy vs blanket let',[sorted(path('d',[policy,policy])),sorted(path('d',[edges(x,'let')]*2))],[['stable'],['broken']],'Choose edges by Desire at the source; no decisions copied from normative table.')
bad=[e for e in edges(x,'let') if e[0] not in desire]+[('d','broken')]
check('CX11','permitted repair may still have a failed fact effect',nxt({'d'},bad),{'broken'},'Change only restore effect as specified; keeping V cannot change this endpoint.')

x=m('CX12'); relation={tuple(e) for e in x['predicate_extensions']['CoDetermines']}; cause={tuple(e) for e in x['predicate_extensions']['Causes']}
check('CX12','concept reciprocity does not imply populated cause table',[('有','无') in relation and ('无','有') in relation,bool(cause)],[True,False],'Separate the two declared predicates, without auto-bridging.')
x=m('CX12',1); tick=edges(x,'tick')
check('CX12','no direct reverse, five-step return',[bool(path('fire',[tick])&{'wood'}),bool(path('wood',[tick]*5)&{'wood'})],[False,True],'Compute one and five steps from the given ring.')
check('CX12','deleted resource edge blocks five-step return',path('wood',[[e for e in tick if e!=('water','wood')]]*5),set(),'Remove only the listed water-to-wood transition, then propagate five times.')

# Reviewer-added adversarial example isolates the CX01 rule wording gap.
rule_counterexample={'states':['dead','live'],'Alive':['live'],'gen':[['dead','live']],'tick':[['dead','live']],
 'old_R1_without_source_Alive_antecedent':True,'GenT1_at_dead':False,'status':'resolved_in_reviewed_revision','current_R1':cards['CX01']['rules'][0],
 'explanation':'A gen edge and live destination do not imply the source is Alive. Add the source Alive premise if R1 concludes GenT(1).'}
proof_boundary={'finite_domain_size':len(m('CX01')['entity_domain']),
 'initial_seen':m('CX01')['extant']['s0'],
 'max_fresh_identity_birth_steps_if_each_step_adds_one_or_more_never_seen_identity':len(set(m('CX01')['entity_domain'])-set(m('CX01')['extant']['s0'])),
 'reason':'With fixed finite Entity and globally unique nonreused identities, each qualifying step consumes at least one previously unseen domain element. No infinite sequence of distinct fresh identities fits in the domain. Current extant differences alone do not establish global novelty after a return cycle.',
 'distinction':'Finite states may support an infinite positive-time cycle, repeated events or reappearance of old IDs. That is different from infinitely many globally new unique identities.'}
report={'review_type':'独立有限表复算；非G1执行器、非原典解释认证、非经验因果验证',
 'input_sha256':hashlib.sha256(raw).hexdigest(),
 'method':'未导入validate_constructions.py，未读取模型hand_checks、calculations或expected用于求值。仅从状态、原始边、谓词外延、对象表、分区和显式V重新计算；review_requirement是审查者预期断言，computed由表运算生成。',
 'independence_limit':'本代理曾起草CX09—CX12的候选卡；本轮对计算采取另写实现复核，不宣称独立人类审查。',
 'summary':{'checks':len(checks),'passed':sum(c['passed'] for c in checks),'cards_checked':len(set(c['card'] for c in checks))},
 'checks':checks,
 'CX01_rule_wording_finding':rule_counterexample,
 'CX01_identity_boundary':proof_boundary,
 'implementation_scope_notes':['现有主脚本的finite_calculation实际读取表计算，并非直接抄expected；结构检查和有限表断言须分别计数。','当前主脚本已实现起点Alive及每步gen终点Alive；早版仅测plain gen^n的覆盖缺口已修正。本次以另写的逐步前沿算法复核guard。','CX08终局范围问题已解决：pass/fail的Weak、Strong均显式为空外延，赋值总定义；阈值及穷尽分类命题保留Config守卫，终局¬Strong不推出Weak。本轮仅复跑既有36项，不增加检查数。','主脚本检查字段和引用ID存在，不验证自然语言选义、源引精确性或全部G1类型接口。']}
review_markdown_template='# 12构式卡有限模型复核\n\n审查对象：`constructions.json`、`validate_constructions.py`、`构式与微型模型.md`。本次最终核定JSON的SHA-256为`{{INPUT_SHA256}}`。\n\n**12张卡的所查成功与失败后果均与原始有限表相符。**另写的复核程序执行36项表运算检查，36项通过；此前修订版的主验证程序已由本代理以只读`--check`重算194项并通过，其中139项结构检查、55项有限表计算；本次新哈希仅复跑独立36项，当前主194项通过由作者报告。两组检查有重叠，不能相加当作230个独立案例或理论证据。\n\n本次发现并提出的CX01.R1起点条件缺口已修复。当前规则明确要求起点和终点均Alive，再断言GenT(1)，JSON与正文已同步。后续CX08终局外延提醒也已解决；此次只对新版本复跑原36项，36项全部通过，未扩展审计。主验证器194项的独立重跑记录来自上一修订版；本修订版主194项通过由作者再次报告，本次未重复执行主验证器。\n\n## 方法与独立性\n\n复核实现见`independent_model_review.py`，结果见`independent_model_review.json`。未导入主验证器，也未用模型里的`hand_checks`、`calculations`或`expected`作实际求值结果；从原始状态、边、谓词、对象、分区和V表重新计算后继集合。串联使用逐步状态前沿，闭包使用可达搜索，生成额外逐步检查Alive及历史已见身份。\n\n主验证器本身也确实从原始表计算实际值，再与预定断言比较，并非直接读取`expected`后宣告成功。本次复核为另写实现的交叉检查；本代理此前起草过阴阳、自然、无为、相生候选卡，所以不宣称独立人类审核或对内容盲化。\n\n这两个程序都**不是G1执行器**。结果只支持所列有限模型中的判断，不证明古文解释唯一正确、历史词界、经验因果、现实有效策略或词汇代表性比例。\n\n## 逐卡实际复算\n\n| 构式 | 从表复算的成立项 | 从表复算的失败或限制 |\n|---|---|---|\n| 生生 | 从s0，GenT(0)、GenT(1)、GenT(2)真；两次全新出现分别为b、c | GenT(3)假；s2仍Alive却无gen后继；s4的GenT(0)假 |\n| 感应 | stimulus;respond终点为s2；四步反馈序列返回s0 | 删去feedback后仍有响应，但完整反馈序列无终点 |\n| 中和 | soft_done在显式V下评为合节；存在可行合节表达路径 | 未发表达集为空不能靠全称空真评为和；harsh路径不合节；删soft边则许可仍在而可行性消失 |\n| 变通 | execute*可达Done的状态恰为routeA、done；有成功重配置 | 另两重配置后继不通；done没有tick后继，故完成不保证延续 |\n| 分合 | 从a分再合回a；三分区均为非空、不重叠、完整覆盖 | 从b合再分的后继集为{b,c}，不保证恢复b |\n| 名实 | Consistent的真值集为{correct,repaired}；repair可恢复匹配 | B的Red在固定对象表中为假，改正标签不会把B变红 |\n| 本末 | EndWorking⊆BaseReady；repair;activate可恢复工作 | BaseReady不蕴含EndWorking；repair一步不足 |\n| 虚实 | 六个配置值均与阈值3及Weak/Strong表一致；r15尝试A成功 | 重新配置后仍试A到fail；r33没有任何弱通道 |\n| 阴阳 | 给定翻转边使yin两步返回自身 | 保留分类而改为停留边，从yin任何有限步也到不了yang |\n| 自然 | 双端NoExternalCommand测试后的两步local路径使湿种子成熟 | 干种子无该路径；NoExternalCommand本身并不足；含Water的两步条件式在所列每状态成立 |\n| 无为 | 按Desire分支的两步策略从d到stable | 一律let从d到broken；保持V而改变restore后果仍可失败 |\n| 相生 | CoDetermines两向成立；令牌环五步回wood | Causes仍为空；fire无直接到wood边；删除water→wood后五步回路失败 |\n\n规范检查所据的V是输入；从可达性得不出同一规范表。表中“失败”是某个查询为假或反模型打破该结论，不是程序运行失败。\n\n## 生生的三个边界\n\n### 1. GenT必须同时保留起点与逐步条件\n\n当前定义为：\n\n`GenT(T) := Alive ∧ ⟨(gen;?Alive)^T⟩⊤`。\n\n起点Alive与每一步gen后的Alive都不可丢。复算得到：\n\n| 起点 | GenT(0) | GenT(1) | GenT(2) | GenT(3) |\n|---|---|---|---|---|\n| s0 | 真 | 真 | 真 | 假 |\n| s1 | 真 | 真 | 假 | 假 |\n| s2 | 真 | 假 | 假 | 假 |\n| s3 | 真 | 假 | 假 | 假 |\n| s4 | 假 | 假 | 假 | 假 |\n\nGenT(T+1)蕴含GenT(T)，因为可以截短同一条成功见证路径；反向在s0的T=2处即失败。这个一般证明基于路径前缀及相同模型，不是凭有限次测试推出无限命题。\n\n旧R1只写“gen边＋终点Alive”，缺少起点条件：另造dead→live生成边即可满足旧前提但不满足GenT(1)。当前R1已补起点Alive，且明确从非Alive起点发生的出生只能另行判断，不冒称该续存式成立。\n\n### 2. T=0是基线，不是生成事件或时间\n\n零次重复为恒等关系，但外层Alive仍在，所以s0真而s4假。GenT(0)不能读成发生过一次生成，更不能作为久的证据。当前模型gen均为实际tick子边，每条tick耗正时间1；可保持Alive三条tick，第四条到s4失败。test与skip不贡献时间。\n\nAlive表恰好等于Extant非空的状态集。s1→s2中a消失、c出现，该步仍是生成；而s2→s3虽仍有对象活着，却没有新对象出现，所以不是gen。存在、生成、个体保持是不同检查。\n\n### 3. 有限域能支持循环，不能容纳无限全新唯一身份\n\n固定Entity={a,b,c}，起点已见a；若每次合格新生必须至少引入一个此前从未出现、以后不作为新身份复用的ID，则最多还有2次这样的新生步骤。当前唯一tick链按累计Seen集合复算，新增依次为{b}、{c}、空、空，与上界相符。\n\n必须使用累计Seen区分“从未出现”与“上一状态不在场”。仅看相邻Extant差集时，一个有限ID可以消失再出现；这可形成无限事件序列，却不是无限全新身份。有限状态的正时间循环本身没有被排除，排除的是固定有限载体上无限多个互不相同的新身份。若要研究后者，须改变身份域/生成语义，而非用已有环宣告完成。\n\n## 留给正式G1接入的接口事项\n\n本轮没有发现剩余的有限表算术或可达性错误。一项此前提醒已解决，另一项执行范围仍须保留：\n\n- CX08终局范围提醒已解决：pass/fail的Weak、Strong现在都有明确空外延，有限赋值成为总定义。阈值分类及强弱穷尽命题必须保留Config守卫；在终局由¬Strong推出Weak仍不成立。本次读取确认这些改动，只复跑原36项，未将其另算新增测试。\n- 多张卡的G1接口仍是参数化文字与表，未成为已解析AST。结构字段存在、来源ID可解析与关系后继算对，不等于类型检查、自然语言编译和全套引擎执行已完成。\n'
review_markdown=review_markdown_template.replace('{{INPUT_SHA256}}',report['input_sha256'])
report_json=json.dumps(report,ensure_ascii=False,indent=2)+'\n'
json_path=HERE/'independent_model_review.json'
md_path=HERE/'independent_model_review.md'
if args.check:
    if json_path.read_text()!=report_json or md_path.read_text()!=review_markdown:
        raise SystemExit('CHECK FAILED: recomputed JSON or Markdown differs; nothing overwritten.')
else:
    json_path.write_text(report_json)
    md_path.write_text(review_markdown)
assert all(c['passed'] for c in checks),[c for c in checks if not c['passed']]
print(json.dumps(report['summary'],ensure_ascii=False))
print(report['input_sha256'])
