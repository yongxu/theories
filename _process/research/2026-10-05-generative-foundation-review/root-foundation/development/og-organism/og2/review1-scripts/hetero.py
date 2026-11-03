# Tenure differs across entrants: holders are (age,tenure). l=5; entrants 9 of 10 short tenure 1, one long tenure 10
import itertools
def run(l,pattern,T):
    hs=[(0,pattern[0])];i=1;alive=[]
    for t in range(T):
        teach=any(g>=l for g,e in hs)
        nh=[(g+1,e) for g,e in hs if g+1<e]
        if teach:
            nh=[(0,pattern[i%len(pattern)])]+nh;i+=1
        hs=nh;alive.append(len(hs))
        if not hs: return t+1
    return None
pat=[10,1,1,1,1,1,1,1,1,1]
print('l=5, mean tenure',sum(pat)/len(pat),'first dies at',run(5,pat,2000))
print('all tenure 1.9-rounded 2, l=5, dies at',run(5,[2],2000))
for pat in ([10,1,1,1],[10,1,1,1,1],[7,1,1,1,1]):
    print('l=5',pat,'mean',sum(pat)/len(pat),'dies at',run(5,pat,5000))
