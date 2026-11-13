import random,sys
exec(open('sim.py').read().split('# ---------- W1')[0])
exec(open('sim.py').read().split('def orb')[1].join(['def orb','']) if False else '')
src=open('sim.py').read(); i=src.index('def orb'); j=src.index('def w2'); exec(src[i:j])
random.seed(int(sys.argv[1]))
def root(g,H,hi):
    y=0
    while y<=hi+1 and g(y)<H: y+=1
    return y
def gen(nobelow=False):
    hi=random.randint(5,16); g=mkg(hi)
    H2=random.randint(0,hi//2); y2=root(g,H2,hi)
    if not(Short(g,H2,y2) and Meets(g,H2,y2,hi) and Keeps(g,H2,hi)): return None
    if H2+y2<1: return None
    h=random.randint(0,hi//2); y1=root(g,h+H2,hi)
    n=random.randint(1,min(H2+y2,hi)); m=random.randint(n,hi+1)
    top=hi if nobelow else min(hi,h+H2+y1-1)
    if top<0: return None
    x=random.randint(0,top)
    return g,hi,dict(m=m,h=h,n=n,H2=H2,y1=y1,y2=y2,x=x)
def U(g,m,h,n,H2,x): return unending(g,(((m,h),(n,H2)),x))
cnt={}
def rec(k,ok):
    a=cnt.setdefault(k,[0,0,None]); a[0]+=1
    if not ok: a[1]+=1
for _ in range(200000):
    r=gen()
    if r:
        g,hi,p=r
        if prem2(g,hi=hi,**p):
            l=U(g,p['m'],p['h'],p['n'],p['H2'],p['x']); rr=rhs2(g,p['m'],p['h'],p['n'],p['H2'],p['y2'],p['x'])
            rec('W2 all',l==rr); rec('W2 never-cases',True) if l else None
            if l:
                m2=random.randint(p['m'],hi+2); rec('W3',U(g,m2,p['h'],p['n'],p['H2'],p['x']))
                S=p['h']+p['H2']; h2=random.randint(p['h'],S); H2b=S-h2; y2b=root(g,H2b,hi)
                if Short(g,H2b,y2b) and Meets(g,H2b,y2b,hi) and Keeps(g,H2b,hi) and p['n']<=H2b+y2b:
                    rec('W4',U(g,p['m'],h2,p['n'],H2b,p['x']))
    # dropped-premise variants
    r=gen(nobelow=True)
    if r:
        g,hi,p=r
        if prem2(g,hi=hi,below=False,**p) and U(g,p['m'],p['h'],p['n'],p['H2'],p['x']):
            m2=random.randint(p['m'],hi+2); ok=U(g,m2,p['h'],p['n'],p['H2'],p['x'])
            rec('W3 without below',ok)
            if not ok and cnt['W3 without below'][2] is None: cnt['W3 without below'][2]=(p,m2,hi,[g(z) for z in range(hi+1)])
    # W4 without regime at H2: H2 arbitrary
    hi=random.randint(5,16); g=mkg(hi); H2=random.randint(0,hi//2); y2=random.randint(0,hi); h=random.randint(0,hi//2); y1=root(g,h+H2,hi)
    n=random.randint(1,hi); m=random.randint(n,hi+1); x=random.randint(0,max(0,min(hi,h+H2+y1-1)))
    if g(0)==0 and Short(g,h+H2,y1) and x<h+H2+y1 and U(g,m,h,n,H2,x):
        S=h+H2; h2=random.randint(h,S); H2b=S-h2; y2b=root(g,H2b,hi)
        if Short(g,H2b,y2b) and Meets(g,H2b,y2b,hi) and Keeps(g,H2b,hi) and n<=H2b+y2b:
            ok=U(g,m,h2,n,H2b,x); rec('W4 without regime at H2',ok)
            if not ok and cnt['W4 without regime at H2'][2] is None: cnt['W4 without regime at H2'][2]=(m,h,n,H2,h2,H2b,x,hi,[g(z) for z in range(hi+1)])
for k,v in cnt.items(): print(k,"tested",v[0],"fails",v[1],v[2] or '')
