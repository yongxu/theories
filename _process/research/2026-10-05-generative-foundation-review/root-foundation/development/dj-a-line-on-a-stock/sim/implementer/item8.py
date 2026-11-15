def run(units, start, way, c, n=10):
    g=lambda z: min(z, max(c-z,0))
    w, x = list(way), start
    for k in range(n):
        print(k, ''.join(w) if len(w)<20 else len(w), len(w), x)
        t=sum(units[u][1] for u in w)
        w2=[v for u in w if units[u][0]<=x for v in units[u][2]]
        y=max(x-t,0); x=y+g(y); w=w2
print("kids need more"); run({'A':(4,2,'BAB'),'B':(9,1,'BB')},8,'BAB',10,4)
print("share"); run({'C':(1,2,'C'),'O':(1,2,'')},12,'CO',12,4)
print("doubling"); run({'D':(1,1,'DD')},12,'D',12,7)
print("from 6"); run({'A':(1,3,'BB'),'B':(3,1,'CB'),'C':(12,1,'A')},6,'A',12,5)
print("from 7"); run({'A':(1,3,'BB'),'B':(3,1,'CB'),'C':(12,1,'A')},7,'A',12,7)
print("nokids"); run({'E':(1,1,'')},12,'E',12,3)
