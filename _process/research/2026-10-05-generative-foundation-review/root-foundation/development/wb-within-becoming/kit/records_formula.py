import json,glob,re,sys,os
root=sys.argv[1]; apply='--apply' in sys.argv
EN=[("A ranking of courses still needs C or a premise in its place","Whoever ranks courses still holds C or another order"),
("a ranking of courses needs C or a premise in its place","whoever ranks courses holds C or another order"),
("ranking courses needs C or a premise in its place","a ranking of courses holds C or another order"),
("ranking needs C or a premise in its place","a ranking holds C or another order"),
("ranking goes through the comparison C or a premise in its place","a ranking holds the comparison C or another order"),
("What ranks lies in C or a premise in its place","What ranks is an order a reader holds, C or another"),
("what ranks lies in C or a premise in its place","what ranks is an order a reader holds, C or another"),
("that is asked under the ethics' two premises, the continuation condition for scope and C for order","that is ranked only under the two readings 07 names, the continuation condition for scope and C for order"),
("The ethics rests on two premises with two roles:","The ranking results rest on two readings with two roles:"),
("lists the ethics' two premises apart,","lists apart the two readings the ranking results use,"),
("for scope and C for order, with warrant open.","for scope and C for order, offered and not asserted, no warrant from outside sought."),
("Its warrant is open, and no warrant binding every possible mind is claimed","No warrant from outside is sought, and none binding every possible mind is claimed"),
("C's warrant is open.","C is a reading the account does not assert."),
("That either premise of the ethics is warranted:","That anyone must hold either reading the ranking results use:"),
("damages or supports 生生","closes or keeps 生生, the continuation of life,"),
("supports or damages 生生","keeps or closes 生生, the continuation of life"),
("a reading in time supports 生生","a reading in time keeps 生生, the continuation of life"),
]
ZH=[("排序经由比较 C 或代替它的前提","排序者持比较 C 或别一种次序"),
("这在伦理的两个前提下才被问及","这只在第七章所指名的两种读法之下才被排定"),
("这在伦理的两个前提下才问及","这只在第七章所指名的两种读法之下才被排定"),
("其根据开放","不求外来之根据"),
("排序进程须 C 或代替它的前提","排序进程者持 C 或别一种次序"),
("对进程的排序仍需要 C 或一个代替它的前提","凡对进程排序者，仍持 C 或别一种次序"),
("排序需要 C 或一个代替它的前提","排序者持 C 或别一种次序"),
("排序在于 C 或一个代替它的前提","排序在于读者所持之次序，C 或别一种"),
("排序须 C 或代替它的前提","排序者持 C 或别一种次序"),
("捕获损害或支持生生","捕获对生生（生命之延续）闭掉或保有什么"),
("停息支持或损害生生","停息对生生（生命之延续）保有或闭掉什么"),
("及时之读支持生生","及时之读保有生生（生命之延续）"),
("排序要在伦理的两个前提下才问及","排序只在第七章所指名的两种读法之下"),
]
NOTE={"en":"9 November 2026, board item WB: the ethics' framing re-said on Ren's words of 8–9 November 2026 (sources/15-codex-theory-conversations/2026-11-08-within-becoming-no-should.md): the two premises named as the readings the ranking results use, a ranking held by whoever ranks, no warrant from outside sought; no change to the claim, its hypotheses or its Lean.",
      "zh":"2026年11月9日，工作板条目 WB：据 Ren 11 月 8–9 日之言重述伦理之框架：两个前提称为排序之果所用之两种读法，排序为排序者所持，不求外来之根据；主张、假设与 Lean 皆不变。"}
changed=[]
for p in sorted(glob.glob(os.path.join(root,'theories/becoming/results/records/*.json'))):
    raw=open(p,encoding='utf-8').read(); d=json.loads(raw); n=[0]
    def walk(o,key=None):
        if isinstance(o,dict):
            return {k:(v if k=='history' else walk(v,k)) for k,v in o.items()}
        if isinstance(o,list): return [walk(x,key) for x in o]
        if isinstance(o,str):
            s=o
            for a,b in EN+ZH:
                if a in s: s=s.replace(a,b); n[0]+=1
            return s
        return o
    nd=walk(d)
    if n[0]:
        nd['history']=list(nd.get('history',[]))+[NOTE]
        changed.append((os.path.basename(p),n[0]))
        if apply:
            indent = 1 if raw.startswith('{\n "') else 2
            open(p,'w',encoding='utf-8').write(json.dumps(nd,ensure_ascii=False,indent=indent)+('\n' if raw.endswith('\n') else ''))
print(len(changed)); print(changed)
