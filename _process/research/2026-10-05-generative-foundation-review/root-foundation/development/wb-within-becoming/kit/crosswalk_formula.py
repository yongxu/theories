import json,sys,re
paths=sys.argv[1:]
EN=[("A ranking of courses still needs C or a premise in its place","Whoever ranks courses still holds C or another order"),
("a ranking of courses needs C or a premise in its place","whoever ranks courses holds C or another order"),
("A ranking of courses needs C or a premise in its place","Whoever ranks courses holds C or another order"),
("ranking courses needs C or a premise in its place","a ranking of courses holds C or another order"),
("a ranking needs C or a premise in its place","a ranking holds C or another order"),
("A ranking needs C or a premise in its place","A ranking holds C or another order"),
("ranking needs C or a premise in its place","a ranking holds C or another order"),
("needs C or a premise in its place","holds C or another order"),
("C or a premise in its place","C or another order"),
("The ethics adds two premises, neither asserted, warrant open","Where the account ranks, it names two readings, neither asserted"),
("The ethics rests on two premises with two roles","The ranking results rest on two readings with two roles"),
("the ethics' two premises","the two readings the ranking results use"),
("The ethics' two premises","The two readings the ranking results use"),
("neither asserted, warrant open","neither asserted, no warrant from outside sought"),
("neither asserted; warrant open","neither asserted; no warrant from outside sought"),
("not asserted; warrant open","not asserted; no warrant from outside sought"),
("their warrant open","no warrant from outside sought"),
("its warrant is open","no warrant from outside is sought"),
("warrant open","no warrant from outside sought"),
("its continuation into the future has significance","its continuation into the future is counted"),
("a selection can succeed while what it cannot read is lost","a selection can meet its own criterion while what it cannot read is lost"),
("supports, enriches or damages 生生","keeps, opens or closes for 生生, the continuation of life,"),
("supports or damages 生生","keeps or closes for 生生, the continuation of life"),
("damages or supports 生生","closes or keeps 生生, the continuation of life,"),
("No ending is licensed","No ending is ranked above keeping by retaining"),
("so C never ranks it above","so C does not ask that it be ranked above"),
("life in the whole and its continuing generation","the continuation of life"),
]
tot=0
for p in paths:
    raw=open(p,encoding='utf-8').read(); n=0
    for a,b in EN:
        # replace inside JSON strings only: the phrases contain no quotes or backslashes
        c=raw.count(a)
        if c: raw=raw.replace(a,b); n+=c
    open(p,'w',encoding='utf-8').write(raw); print(p.split('/')[-1], n); tot+=n
    json.loads(raw)
print('total',tot)
