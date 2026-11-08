import json,sys,re
p=sys.argv[1]; raw=open(p,encoding='utf-8').read(); entries=json.loads(raw)
T8="T8, argued: for life, the account's makers offer a way of seeing, not a verdict: what each course draws on, from what renewal and at which grain, what ends and what goes on, and who bears it; 生生 is the continuation of life; it binds no one. Forbids and refuted by: selections that read a course's draw and what ends with it leaving a draw beyond the renewal their readers depend on no less often than selections that do not."
S4="Neither is asserted, and neither is the account's own: each is an order or scope some formations hold, and the results say what follows where it is held. A self acting for its own continuation presupposes that some continuation is counted; how far that reaches and how courses are ranked are separate questions, and the results here answer each under a reading it names."
TXT=[("'Capability is a reason to pool, not to govern'","'Capability, on this reading, is a reason its makers offer to pool rather than to govern'"),
("Capability is a reason to pool, not to govern.","Capability, on this reading, is a reason its makers offer to pool rather than to govern."),
("resisting a capture that hides a loss needs a member admitted by what the pool does not yet read","a pool can gain the missing coupling through admission from beyond that answers the loss, or through recruitment its own course would undertake; how actual pools form is open"),
("a selection reaches exactly what couples into its selector","the selections through a selector's couplings, together, reach exactly what couples into it"),
("a selection reaches exactly what couples into the selector","the selections through a selector's couplings, together, reach exactly what couples into it"),
("a selection reaches exactly what couples in","the selections through a selector's couplings, together, reach exactly what couples in"),
("presupposes that some continuation has significance","presupposes that some continuation is counted"),
("anything's continuation has significance","anything's continuation is counted"),
("the way is 生生, the continuation of life","the makers offer a way of seeing; 生生 is the continuation of life"),
("T8 falls to a pure closing argued good for life","T8's refuter until 9 November 2026 was a pure closing argued good for life"),
("would meet T8's refuter","would have met T8's refuter before 9 November 2026"),
("T8 forbids only a pure closing argued good for life","until 9 November 2026 T8 forbade only a pure closing argued good for life"),
("T8 starts from what acting presupposes","T8 once started from what acting presupposes"),
]
nt=ns=nx=0
def fixstr(s):
    global nx
    for a,b in TXT:
        if a in s: s=s.replace(a,b); nx+=1
    return s
for c in entries:
    for t in c.get('targets',[]):
        a=t.get('anchor') or ''
        says=t.get('says')
        if isinstance(says,dict) and isinstance(says.get('en'),str):
            e=says['en']
            if a.endswith('07-SIGNIFICANCE.md#theses') and ('T8' in e) and ('T4' not in e and 'T5' not in e and 'T1' not in e):
                says['en']=T8; nt+=1
                if 'zh' in says: says.pop('zh')
            elif a.endswith('07-SIGNIFICANCE.md#scope-and-order') and ('separate questions with separate premises' in e):
                says['en']=S4; ns+=1
                if 'zh' in says: says.pop('zh')
            else:
                says['en']=fixstr(e)
    for k in ('reading','account_adds'):
        v=c.get(k)
        if isinstance(v,dict) and isinstance(v.get('en'),str): v['en']=fixstr(v['en'])
        elif isinstance(v,str): c[k]=fixstr(v)
print('T8 says',nt,'scope says',ns,'text fixes',nx)
indent = 1 if raw.startswith('[\n {') else 2
open(p,'w',encoding='utf-8').write(json.dumps(entries,ensure_ascii=False,indent=indent)+('\n' if raw.endswith('\n') else ''))
