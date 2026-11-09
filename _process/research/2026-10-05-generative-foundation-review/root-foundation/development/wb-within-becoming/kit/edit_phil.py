import sys
p=sys.argv[1]; s=open(p,encoding='utf-8').read()
def rep(a,b,n=1):
    global s
    assert s.count(a)==n,(s.count(a),a[:70]); s=s.replace(a,b)
rep("**Two premises, two roles** ([P-04](#p-04)).", "**Two readings, two roles** ([P-04](#p-04)). Evaluation forms within the unfolding, and no law evaluates; the account asserts no should, and where it ranks courses it names the reading it ranks under.")
rep("for anything, its continuation into the future has significance ([P-05](#p-05)).", "for anything, its continuation into the future is counted ([P-05](#p-05)).")
rep("C gives order, and a ranking needs C or a premise in its place; C leaves unranked courses each admitting something the other does not.",
    "C gives order, and whoever ranks courses holds C or another order; C leaves unranked courses each admitting something the other does not.")
rep("Neither is asserted: each is a hypothesis wherever used, and its warrant is open.", "Neither is asserted, and neither is the account's own: each is a hypothesis wherever used, and no warrant from outside is sought.")
rep("Neither result shows that no stronger warrant exists. Choices need further premises, none asserted ([P-21](#p-21)).",
    "Neither result shows that no stronger warrant exists; the account does not pursue one. Results on choices need further premises, none asserted ([P-21](#p-21)).")
rep("Ranking still needs C or a premise in its place ([P-16](#p-16)).", "Whoever ranks courses still holds C or another order ([P-16](#p-16)).")
rep("**Theses and tests** ([P-26](#p-26)). T8, argued: for life, that is for those whose own line runs through life, the way is 生生, life in the whole and its continuing generation (an AI reading), compared by widening what can form; whose losses count stays every continuation's.",
    "**Theses and tests** ([P-26](#p-26)). T8, argued: for life, the account's makers offer a way of seeing, not a verdict: what each course draws on, from what renewal and at which grain, what ends and what goes on, and who bears it; 生生 is the continuation of life (an AI reading); whose losses count stays every continuation's; it binds no one.")
rep("That the condition, C or the step is warranted, or any warrant binding every possible mind.", "That anyone must hold the condition, C or the step, or any warrant binding every possible mind; none from outside is sought.")
rep("That P2 and P4 are warranted, or that P3 holds of actual selves.", "That P2 and P4 hold, or that P3 holds of actual selves.")
open(p,'w',encoding='utf-8').write(s); print('ok')
