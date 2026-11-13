# AI-written, 13 November 2026. The second readers' findings, decided by the coordinator: six uses back to "law"
# (three inside verbatim quotations of a test's files, one a process's step, two the arising-ceasing law of World.law_iff_em),
# and the rewordings taken. Rebuilds the scratch copy, finds each phrase's field there, and rewrites rewrites.json.
import json, shutil, subprocess, sys
KIT='/Users/ren/tmp/rw/wm'
D=json.load(open(KIT+'/decisions.json'))
D.update({'822':'D','823':'D','845':'D','1058':'B','703':'E','704':'E'})
json.dump({k:D[k] for k in sorted(D,key=int)}, open(KIT+'/decisions.json','w'), indent=0)
old=json.load(open(KIT+'/rewrites.json',encoding='utf-8'))
RW=[(r['file'],r['old'],r['new']) for r in old]
RW=list(dict.fromkeys(RW))
def swap(o,n):
    k=[i for i,r in enumerate(RW) if r[2]==o]
    assert len(k)==1,(o,len(k)); RW[k[0]]=(RW[k[0]][0],RW[k[0]][1],n)
swap('a theorem on every course, every process or every relation','a theorem about every course, every process or every relation')
swap('they are not theorems on every course','they are not theorems about every course')
swap('it is not a theorem on every course','it is not a theorem about every course')
swap('not a theorem on every circular dependence','not a theorem about every circular dependence')
RW += [
 ('laid',"would also count as moving the theorem's way in some runs",'would also count as moving toward what the theorem gives as best in some runs'),
 ('laid','同样会被算作朝定理的方向走','同样会被算作朝定理给出的最好走'),
 ('laid',"moves these learners toward the theorem's ends, the direction",'moves these learners toward what the theorem gives as best, the direction'),
 ('laid','会朝定理的终点走','会朝定理给出的最好走'),
 ('paths','过程自己的定理（第 9 步），条件写在那一步里','就过程本身证明的（第 9 步），条件写在那一步里'),
 ('paths','过程自己的定理，各在句子里写明的条件之下','就过程本身证明的，各在句子里写明的条件之下'),
 ('cards',"no form is a relation's theorem",'no form fits a theorem on a relation'),
 ('cards','is a definitional unfolding and is not written as a theorem',"is a definitional unfolding and is not listed among the card's theorems"),
 ('cards',"is the model's own clause, not a derived theorem","is the model's own clause, not a theorem"),
 ('cards','is not a theorem of this dynamic','is stated by no theorem of this dynamic'),
 ('cards',"active inference's habit read as this theorem","active inference's habit read as a case of this theorem"),
 ('cards','is a second model no proof here joins to hearing','is on a second model no proof here joins to hearing'),
 ('cards','so each sits between a theorem and a built case','so each sits between a general theorem and a built case'),
 ('cards',"Both theorems are of Confound's process only","Both theorems hold of Confound's process only"),
 ('cards','theorems, proved elsewhere, of giving that waits','theorems, proved elsewhere, on giving that waits'),
 ('cards','this place meets the regulation theorems by reading only','this place comes under the regulation theorems by reading only'),
 ('cards','Every theorem is of one built course','Every theorem is about one built course'),
 ('cards','Theorems of every carrier, relation and class','Theorems about every carrier, relation and class'),
 ('cards','so it is a built case, not a theorem.','so it is a built case, not a general theorem.'),
 ('cards','so it is among the built cases and not a theorem.','so it is among the built cases and not a general theorem.'),
 ('cards','so it is a built case and not a theorem.','so it is a built case and not a general theorem.'),
 ('cards','six-law','six-theorem'), ('cards','three-law','three-theorem'),
 ('cases','the theorem for optima','the theorem on optima'),
 ('cases','The theorem is of optima','The theorem is on optima'),
 ('cases','the theorems are of optima over outcomes, not of a trained model','the theorems are on optima over outcomes, not on a trained model'),
 ('cases','the theorem verifies a given policy, not how one chooses','the theorem holds of a given policy, not of how one chooses'),
 ('cases','两条已证的定理','两条定理'),
 ('cases',"never on the theorem's forbidden cases",'never on the cases the theorem rules out'),
 ('cases','不看定理所禁的情形','不看定理排除的情形'),
 ('cases','Mixtures pass only near the theorem (nine calls in ten: 0.89)',"Mixtures pass only near the theorem's plan (nine calls in ten: 0.89)"),
 ('cases',"proved the regime's theorems for giving that adjusts",'proved theorems on the regime for giving that adjusts'),
 ('cases','the counts theorems say rises','the theorems on counts say rises'),
 ('cases','A reading of proved theorems','A reading of theorems'),
 ('cases','把已证的定理读作','把定理读作'),
]
# rebuild the scratch copy with the swaps only, then place every rewrite
for f in ('sheet','passages','paths','laid','web','cards','cases'):
    shutil.copy(KIT+'/orig/theories/becoming/results/map/%s.json'%f, KIT+'/scratch/theories/becoming/results/map/%s.json'%f)
json.dump([], open(KIT+'/rewrites.json','w'))
print(subprocess.run([sys.executable,'-B',KIT+'/apply.py','write',KIT+'/scratch'],capture_output=True,text=True).stdout.strip())
def walk(o,p=()):
    if isinstance(o,dict):
        for k,v in o.items(): yield from walk(v,p+(k,))
    elif isinstance(o,list):
        for i,v in enumerate(o): yield from walk(v,p+(i,))
    elif isinstance(o,str): yield p,o
out=[]; data={}; bad=0
for f,o,n in RW:
    d=data.setdefault(f,json.load(open(KIT+'/scratch/theories/becoming/results/map/%s.json'%f,encoding='utf-8')))
    hits=[(p,s) for p,s in walk(d) if o in s]
    if not hits or any(s.count(o)!=1 for p,s in hits): bad+=1; print('MISMATCH',f,o[:60],len(hits),[s.count(o) for p,s in hits])
    for p,s in hits: out.append({'file':f,'path':list(p),'old':o,'new':n})
json.dump(out,open(KIT+'/rewrites.json','w',encoding='utf-8'),ensure_ascii=False,indent=1)
print('rewrites',len(out),'from',len(RW),'phrases; mismatches',bad)
