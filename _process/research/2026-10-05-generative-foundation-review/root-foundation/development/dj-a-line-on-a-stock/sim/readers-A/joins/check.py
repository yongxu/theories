import re
p='/Users/ren/theories/tmp/r7/one-model/lean-scratch/Becoming/LineOnAStock.lean'
s=open(p).read()
print('theorems',len(re.findall(r'^theorem ',s,re.M)),'defs',len(re.findall(r'^(def|abbrev|instance|inductive) ',s,re.M)))
def run(need,use,kids,giving,w,x,n):
    out=[(list(w),x)]
    for _ in range(n):
        t=sum(use[u] for u in w)
        nw=[]
        for u in w:
            if need[u]<=x: nw+=kids[u]
        l=max(x-t,0); x=l+giving(l); w=nw
        out.append((list(w),x))
    return out
h10=lambda z:min(z,max(10-z,0)); h12=lambda z:min(z,max(12-z,0))
# KidsNeedMore: other premises of way_ends on hump10
print('hump10(0)=',h10(0),'Keeps 0 hi=10:',all(x+h10(x)<=10 for x in range(11)),'Keeps hi=8:',all(x+h10(x)<=8 for x in range(9)),'Keeps hi=9',all(x+h10(x)<=9 for x in range(10)))
r=run({'A':4,'B':9},{'A':2,'B':1},{'A':['B','A','B'],'B':['B','B']},h10,['B','A','B'],8,3); print(r)
r=run({'A':1,'B':3,'C':12},{'A':3,'B':1,'C':1},{'A':['B','B'],'B':['C','B'],'C':['A']},h12,['A'],6,4); print([(''.join(w),x) for w,x in r])
r=run({'A':1,'B':3,'C':12},{'A':3,'B':1,'C':1},{'A':['B','B'],'B':['C','B'],'C':['A']},h12,['A'],7,6); print([(''.join(w),x) for w,x in r])
r=run({'u':1},{'u':1},{'u':['u','u']},h12,['u'],12,6); print([(len(w),x) for w,x in r])
r=run({'C':1,'O':1},{'C':2,'O':2},{'C':['C'],'O':[]},h12,['C','O'],12,3); print(r)
