import json
PKG='experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
R='theories/becoming/results/records/'
LD=f'{PKG}/Becoming/LineDegeneration.lean'
GM,MI,KW=(f'{PKG}/Becoming/{m}.lean' for m in ('GrammarMap','MapInstances','KeepingWidening'))
REN={'Becoming.Map.not_not_end_of_ends':'Becoming.«尽则非无终»',
     'Becoming.Map.end_of_ends_decided':'Becoming.«尽而续可定则有终»',
     'Becoming.Map.end_of_ends_iff_excluded_middle':'Becoming.«尽则有终当且仅当排中»',
     'Becoming.Web.degenerates_of_gone':'Becoming.Web.end_of_gone',
     'Becoming.Map.Short.degeneration':'Becoming.Map.Short.reaches_end'}
def load(rid): return json.load(open(R+rid+'.json'))
def save(rid,d): open(R+rid+'.json','w').write(json.dumps(d,ensure_ascii=False,indent=2)+'\n')
def ren(xs): return [REN.get(x,x) for x in xs]
DATE='1 November 2026'
# ---------- degeneration-from-a-horizon
rid='degeneration-from-a-horizon'; d=load(rid)
assert d['laws'][3]['en'].startswith('Restatements, no result')
del d['laws'][3]
for l in d['laws']: l['declarations']=ren(l['declarations'])
assert 'Becoming.«尽则非无终»' in d['laws'][3]['declarations']
d['aliases']=ren(d['aliases'])
d['canonical_source']=MI
GMD=['Becoming.«尽则非无终»','Becoming.«尽而续可定则有终»','Becoming.«尽则有终当且仅当排中»',
     'Becoming.Map.StepWhere.relation','Becoming.Map.StepWhere.ends','Becoming.Map.StepWhere.has_next_iff','Becoming.Map.StepWhere.end_decides']
KWD=['Becoming.Map.Undecided.kind_degenerates','Becoming.Web.kind_every_branch_ends_of_gone']
old=[x for x in d['references'] if x['path']==LD]; assert len(old)==1
alld=ren(old[0]['declarations'])
alld=[x for x in alld if not x.startswith('Becoming.Web.Restated.')]
MID=sorted(x for x in alld if x not in GMD and x not in KWD)
assert set(GMD)<=set(alld) and set(KWD)<=set(alld), (set(GMD)-set(alld), set(KWD)-set(alld))
rec=[x for x in d['references'] if x['role']=='receipt']
d['references']=[{'path':GM,'role':'proof','sha256':'PENDING','declarations':sorted(GMD)},
                 {'path':MI,'role':'proof','sha256':'PENDING','declarations':MID},
                 {'path':KW,'role':'proof','sha256':'PENDING','declarations':sorted(KWD)}]
# the receipt reference is written by the landing (reland_el6.py)
d['proof_bindings']=[{'source':p,'receipt':f'{PKG}/becoming-checks/PENDING/verification.json',
                      'sha256_pointer':f'/source_sha256/Becoming.{m}','success_pointer':'/status','success_value':'passed'}
                     for p,m in ((GM,'GrammarMap'),(MI,'MapInstances'),(KW,'KeepingWidening'))]
for c in d['counterexamples']:
    assert c['path']==LD
    c['path']=GM if c['detail']['en'].startswith('Map.StepWhere') else MI
d['counterexamples'][1]['detail']={'en':'Map.StepWhere: on the grammar, the short life gated by P, its one step from false to true taken exactly where P holds; the line from false ends on every branch and any end decides P (Map.StepWhere.end_decides).',
 'zh':'Map.StepWhere：在文法上，以 P 为门的短命之线，自 false 到 true 的一步恰在 P 成立时发生；自 false 之线诸支皆尽，而任何终点都判定 P（Map.StepWhere.end_decides）。'}
d['validation_scope']={'en':'Checked by the core checker with Lean 4.29.1 from the prelude at receipt PENDING: the laws in Becoming.GrammarMap (GMCOUNT), Becoming.MapInstances (MICOUNT) and Becoming.KeepingWidening (KWCOUNT), each declaration with an empty axiom report; first checked as the leaf Becoming.LineDegeneration at receipt 20261101T024359.312453Z (45 declarations, 40 theorems), recompiled by independent AI verifiers in four review rounds, every finding taken.',
 'zh':'由核心检查器以 Lean 4.29.1 从前奏检查，回执 PENDING：Becoming.GrammarMap（GMCOUNT_ZH）、Becoming.MapInstances（MICOUNT_ZH）与 Becoming.KeepingWidening（KWCOUNT_ZH）中的诸律，每个声明的公理报告均为空；最初作为叶 Becoming.LineDegeneration 于回执 20261101T024359.312453Z 检查（45 个声明，40 条定理），经独立 AI 验证者在四轮审查中重新编译，所见皆采纳。'}
d['dependencies'][0]['detail']={'en':"The map's «尽», «退化» and «尽则非不穷» (Becoming.GrammarMap) and its reading on the World (Becoming.MapInstances): occurrences along a continuation's step, activity as the coarse class, and the laws that a line is not without end and that it reaches an end where going on is decided, which MapInstances proves from degeneration.",
 'zh':'复用地图的 «尽»、«退化» 与 «尽则非不穷»（Becoming.GrammarMap）及其在世界上的读法（Becoming.MapInstances）：沿续之步的事、以活动为粗类，以及"线非不穷"之律与延续可判定时"线有终"之律；MapInstances 由退化证明它们。'}
d['dependencies'][1]['detail']={'en':'Web.kindClass and Web.kindClass_within (Becoming.KeepingWidening): the kind class is a class within activity, so the law holds at the kind grain, the lineage continuation Web.withinKind included; the kind instance is stated there, after Web.kindClass_within.',
 'zh':'复用 Web.kindClass 与 Web.kindClass_within（Becoming.KeepingWidening）：种类之类含于活动，故此律在种类粒度上成立，世系之续 Web.withinKind 亦在其中；种类实例即陈述于其处，在 Web.kindClass_within 之后。'}
d['next_delta']={'en':'Degeneration where no one step bounds every branch, and the some-branch regions (生成, 后守) on the World.',
 'zh':'没有一步能约束每一支时的退化，以及世界上的某支之域（生成、后守）。'}
d['history'].append({'en':f'{DATE}, board item EL6: placed in its owners\' modules, each on its owner\'s yes. The grammar part is in Becoming.GrammarMap, its laws named «尽则非无终», «尽而续可定则有终» and «尽则有终当且仅当排中» (formerly Map.not_not_end_of_ends, Map.end_of_ends_decided and Map.end_of_ends_iff_excluded_middle), with Map.StepWhere stated as Map.short gated by P; the kind instance is in Becoming.KeepingWidening; the rest is in Becoming.MapInstances, where the landed laws that a line is not without end, and the law concluding an end (renamed Web.end_of_gone), are proved from degeneration in place, so the restatements (Web.Restated) and their law here are dropped. Becoming.LineDegeneration is retired to the Lean history folder. No statement changed.',
 'zh':f'2026年11月1日，工作板条目 EL6：各部分经其所属者同意放入其模块。文法部分在 Becoming.GrammarMap，其律名为 «尽则非无终»、«尽而续可定则有终» 与 «尽则有终当且仅当排中»（原名 Map.not_not_end_of_ends、Map.end_of_ends_decided、Map.end_of_ends_iff_excluded_middle），Map.StepWhere 陈述为以 P 为门的 Map.short；种类实例在 Becoming.KeepingWidening；其余在 Becoming.MapInstances，在那里已落地的"线非不穷"诸律与推出有终之律（改名为 Web.end_of_gone）就地由退化证明，故重述（Web.Restated）及其在此的律一并去除。Becoming.LineDegeneration 移入 Lean 历史文件夹。无陈述改变。'})
save(rid,d)
# ---------- generation-and-degeneration-at-two-grains: the renames
rid='generation-and-degeneration-at-two-grains'; d=load(rid)
t=json.dumps(d,ensure_ascii=False)
n=sum(t.count(k) for k in ('"Becoming.Web.degenerates_of_gone"','"Becoming.Map.Short.degeneration"'))
for a,b in REN.items(): t=t.replace(f'"{a}"',f'"{b}"')
d=json.loads(t)
d['history'].append({'en':f'{DATE}, board item EL6: Web.degenerates_of_gone renamed Web.end_of_gone and Map.Short.degeneration renamed Map.Short.reaches_end, on their owner\'s yes: each law concludes an end (有终), not «退化»; nothing the record says changes. Web.end_of_gone and the laws that a line is not without end are now proved in Becoming.MapInstances from degeneration (record degeneration-from-a-horizon), their statements unchanged.',
 'zh':f'2026年11月1日，工作板条目 EL6：经所属者同意，Web.degenerates_of_gone 改名为 Web.end_of_gone，Map.Short.degeneration 改名为 Map.Short.reaches_end：两律所推出的是有终，不是 «退化»；记录所说无一改变。Web.end_of_gone 与"线非不穷"诸律今在 Becoming.MapInstances 中由退化证明（记录 degeneration-from-a-horizon），陈述不变。'})
save(rid,d); print('two-grains renamed', n)
# ---------- the two EL records reusing the laws
for rid,a,b in (('ending-laws-as-regimes-on-a-lineage','(Becoming.LineDegeneration)','(Becoming.MapInstances and Becoming.KeepingWidening)'),
                ('the-selection-term-and-a-lineages-fate','(Becoming.LineDegeneration, imported)','(Becoming.MapInstances and Becoming.KeepingWidening, imported)')):
    d=load(rid); t=json.dumps(d,ensure_ascii=False)
    za=a.replace('(','（').replace(')','）').replace(', imported','，已导入')
    zb=b.replace('(','（').replace(')','）').replace(' and ',' 与 ').replace(', imported','，已导入')
    assert t.count(a)==1 and t.count(za)==1,(rid,t.count(a),t.count(za))
    t=t.replace(a,b).replace(za,zb); d=json.loads(t)
    d['history'].append({'en':f'{DATE}, board item EL6: the reused laws named in the modules where they now lie, Becoming.LineDegeneration having been placed in MapInstances and KeepingWidening and retired; nothing the record says changes.',
                         'zh':f'2026年11月1日，工作板条目 EL6：所复用之律按其今所在的模块称名；Becoming.LineDegeneration 已放入 MapInstances 与 KeepingWidening 并退役；记录所说无一改变。'})
    save(rid,d)
print('ok')
