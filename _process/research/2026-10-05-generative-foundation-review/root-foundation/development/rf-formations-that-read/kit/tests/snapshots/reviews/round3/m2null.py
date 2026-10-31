import random, tr4
ag=tr4.AGENTS[0]; rng=random.Random(777); hits=0; R=3000
for _ in range(R):
    units=[]
    for _u in range(60):
        acts,_=tr4.simulate_unit(rng,ag,rng.choice([1,2,3]),rng.choice(tr4.WORDINGS)); units.append(acts)
    p,_=tr4.perm_p(units,tr4.match_line,"m2"); hits+= p<=tr4.FIRST
print(hits,R,hits/R,tr4.FIRST)
