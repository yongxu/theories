# Independent recomputation of the new worked courses in namespace Three (reader R-lock, AI-written)
def giving(z): return min(z, max(12 - z, 0))   # Nat subtraction truncates
def step(g, H, x):
    r = max(x - H, 0); return r + g(r)
def Short(g,H,y): return all(g(z) < H for z in range(y))
def Meets(g,H,y,hi): return all(H <= g(z) for z in range(y, hi+1) if z + H <= hi)
def Keeps(g,H,hi): return all(step(g,H,x) <= hi for x in range(hi+1))
lockRead = lambda a,g: 3 <= a
riseShare = lambda a,g: a+1 if g else a
lockShare = lambda a,g: a
use_rule = lambda g: 5 if g else 3
def windowAlone(fA,hA,w): a,g,n = w; return (fA(a,g), hA(a,g), n+1)
# --- rise_count_ends
print('== rise_count_ends: use = share, riseShare, start ((3,T,0),12), need 1')
w,x=(3,True,0),12; course=[(w,x)]
for i in range(9):
    w,x = windowAlone(riseShare,lockRead,w), step(giving, w[0], x); course.append((w,x))
for i,c in enumerate(course): print(i,c)
first_below=[i for i,(w,x) in enumerate(course) if x<1][0]
print('first step with level < need 1:',first_below,'config',course[first_below],'<= 12+1:',first_below<=13)
print('FromNothing',giving(0)==0,'Keeps giving 0 12',Keeps(giving,0,12))
print('step giving 3 12 =',step(giving,3,12))
bad=[(H,y) for H in range(0,4) for y in range(0,40) if Short(giving,H,y) and 12 < H+y]
print('H<=3, Short H y, 12<H+y :',bad)
print('Short giving 7 6',Short(giving,7,6),'| 7<=use(7,..)',7<=7,'| 12<7+6',12<13)
print('max giving',max(giving(z) for z in range(0,30)),'-> Short giving 7 y for every y:',all(Short(giving,7,y) for y in range(40)))
print('smallest H,y at each step j with H<=use_j, Short H y, level_j < H+y:')
for j,(w,x) in enumerate(course[:8]):
    ok=[(H,y) for H in range(0,w[0]+1) for y in range(0,20) if Short(giving,H,y) and x < H+y]
    print(' step',j,'share',w[0],'level',x,'exists:',bool(ok), ok[:1])
print('Locked(a,g) := g=True and lockRead(a)=True-ish; (10,True):',lockRead(10,True),'(7,True):',lockRead(7,True))
# --- share_read_goes_on
print('== share_read_goes_on: window [8,9) sets share 0, rule False; start ((3,T,0),9)')
def afterShare(w,x):
    a,g,n=w
    return (0,False,n+1) if 8<=x<9 else windowAlone(lockShare,lockRead,w)
w,x=(3,True,0),9; pc=[(w,x)]
for i in range(8):
    w,x = afterShare(w,x), step(giving,use_rule(w[1]),x); pc.append((w,x))
print('pair course:',pc)
w,x=(3,True,0),9; ac=[(w,x)]
for i in range(6):
    w,x = windowAlone(lockShare,lockRead,w), step(giving,use_rule(w[1]),x); ac.append((w,x))
print('course as it was:',ac)
T=1
print('RHS at T=1:', all(1<=ac[j][1] and not (8<=ac[j][1]<9) for j in range(T)), 1<=ac[T][1], 8<=ac[T][1]<9, 3+3<=ac[T+1][1])
print('other T possible?',[T for T in range(5) if all(1<=ac[j][1] and not (8<=ac[j][1]<9) for j in range(T)) and 1<=ac[T][1] and 8<=ac[T][1]<9 and 6<=ac[T+1][1]])
print('premises: Short 5 5',Short(giving,5,5),'below 9<10',9<10,'Short 3 3',Short(giving,3,3),'Meets 3 3 12',Meets(giving,3,3,12),'Keeps 3 12',Keeps(giving,3,12),'need<=6',1<=6,'high',9<=12)
print('from step 2: share<3 and rule False:',all(w[0]<3 and w[1] is False for w,_ in pc[2:]),'| at step T=1 share<3?',pc[1][0][0]<3)
# --- tightness of hi+1 in rising_takes_all / ends_with_net_rising
print('== tightness: giving z = hi - z (z>0), use_j = j, start hi, need 1')
for hi in range(1,6):
    g=lambda z,hi=hi: (hi - z if 0<z<=hi else 0)
    assert Keeps(g,0,hi) and g(0)==0
    x=hi; lv=[x]
    for j in range(hi+2): x=step(g,j,x); lv.append(x)
    print(' hi',hi,'levels',lv,'first below need:',[i for i,v in enumerate(lv) if v<1][0])
