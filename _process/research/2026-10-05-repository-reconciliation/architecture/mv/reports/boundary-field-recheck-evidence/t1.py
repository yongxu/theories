from lib import *
# proof condition of grammar law
rootthm = {n for n in root if C[n]['k']=='thm'}
bad = {}
for n in laws:
    w = walk(n)
    extra = [b for b in w if b not in rootthm and b not in laws]
    if extra: bad[n]=extra
print('laws',len(laws),'laws failing proof condition', len(bad))
for n,e in list(bad.items())[:20]: print(n, C[n]['m'], e[:5])
# root theorems whose proofs name non-root theorems
rb = {}
for n in rootthm:
    w = walk(n)
    ex = [b for b in w if b not in root]
    if ex: rb[n]=ex
print('root theorems whose proof walk names non-root theorems', len(rb))
for n,e in list(rb.items())[:15]: print(' ',n, C[n]['m'], e[:4])
# laws located in model modules
print([ (n,C[n]['m']) for n in laws if not located(n)])
# direct vs chain forwarders
print(sum(1 for n,g in forwarders.items() if C[n]['f']==g), 'direct of', len(forwarders))
