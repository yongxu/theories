# AI-written, 16 November 2026 (copied from the reader "joins" script, unchanged in method). Read only.
# of the tracked WayOfUnits.lean and its scratch copy, and counts in-file uses of each declaration.
import re, sys
PKG='/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/'
SCR='/Users/ren/theories/tmp/r7/one-model/lean-scratch/Becoming/'
KW=r'(?:private\s+)?(?:theorem|def|abbrev|instance|structure|inductive|lemma)\b'
def strip_comments(t):
    # remove block comments (incl. docstrings), nested not expected
    out=[];i=0;depth=0
    while i<len(t):
        if t.startswith('/-',i): depth+=1;i+=2;continue
        if t.startswith('-/',i) and depth>0: depth-=1;i+=2;continue
        if depth==0: out.append(t[i])
        elif t[i]=='\n': out.append('\n')
        i+=1
    return ''.join(out)
def decls(path):
    t=strip_comments(open(path).read())
    lines=t.split('\n')
    ds=[];ns=[]
    i=0
    starts=[]
    for n,l in enumerate(lines):
        m=re.match(r'^(namespace|end)\s+(\S+)',l)
        if re.match(r'^'+KW,l): starts.append(n)
    # namespace tracking
    cur=[];nsat={}
    for n,l in enumerate(lines):
        m=re.match(r'^namespace\s+(\S+)',l)
        if m: cur.append(m.group(1))
        m=re.match(r'^end\s+(\S+)',l)
        if m and cur and cur[-1]==m.group(1): cur.pop()
        nsat[n]='.'.join(cur)
    res={}
    order=[]
    for k,s in enumerate(starts):
        e=starts[k+1] if k+1<len(starts) else len(lines)
        body='\n'.join(lines[s:e])
        # header: up to first ':=' or first line starting with '  |' pattern-match or ' where'
        m=re.search(r':=|\n\s*\|| where\b',body)
        head=body[:m.start()] if m else body
        nm=re.match(r'^'+KW+r'\s+(\S+)',head)
        name=nsat[s]+'.'+(nm.group(1) if nm else '?')
        res[name]=(head.rstrip(), s+1, e-s, body)
        order.append(name)
    return res,order,t
a,oa,ta=decls(PKG+'WayOfUnits.lean')
b,ob,tb=decls(SCR+'WayOfUnits.lean')
print('tracked decls',len(a),'copy decls',len(b))
miss=[n for n in oa if n not in b]
print('missing in copy:',miss)
chg=[n for n in oa if n in b and a[n][0]!=b[n][0]]
print('headers changed:',chg)
new=[n for n in ob if n not in a]
print('new in copy (%d):'%len(new),[n.split('.')[-1] for n in new])
print('order kept:', [n for n in ob if n in a]==oa)
# proof body change
pc=[n for n in oa if n in b and a[n][3].strip()!=b[n][3].strip()]
for n in pc:
    la=len([l for l in a[n][3].strip().split('\n')]); lb=len([l for l in b[n][3].strip().split('\n')])
    ha=len(a[n][0].split('\n')); hb=len(b[n][0].split('\n'))
    print('proof changed: %-28s decl lines %d -> %d (proof part %d -> %d)'%(n.split('Units.')[-1],la,lb,la-ha+1,lb-hb+1))
# uses of each decl inside the copy (other than own body)
def uses(res,order,text):
    out={}
    for n in order:
        short=n.split('.')[-1]
        cnt=0
        for m in order:
            if m==n: continue
            if re.search(r'(?<![\w.])'+re.escape(short)+r"(?![\w'])",res[m][3]): cnt+=1
        out[n]=cnt
    return out
ub=uses(b,ob,tb); ua=uses(a,oa,ta)
print('used by no other declaration in copy:',[n.split('Units.')[-1] for n in ob if ub[n]==0 and (n in a and ua[n]>0)])
print('  (of those unused already in tracked: not listed) newly unused only above')
