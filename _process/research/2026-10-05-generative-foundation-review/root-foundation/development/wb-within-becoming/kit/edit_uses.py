import sys
p=sys.argv[1]; s=open(p,encoding='utf-8').read()
def rep(a,b,n=1):
    global s
    assert s.count(a)==n,(s.count(a),a[:70]); s=s.replace(a,b)
rep("No law of the dynamics ranks courses. The ethics adds two premises, neither asserted, warrant open: the *continuation condition* fixes scope, whose losses count, and ranks nothing; *C*, widening what can form is better, gives order. A ranking of courses needs C or a premise in its place ([07 §4](chapters/07-SIGNIFICANCE.md#scope-and-order)).",
    "No law of the dynamics ranks courses, and the account asserts no should. Where a result ranks, it names the two readings it ranks under, neither asserted: the *continuation condition* fixes scope, whose losses count, and ranks nothing; *C*, widening what can form is better, gives order ([07 §4](chapters/07-SIGNIFICANCE.md#scope-and-order)).")
rep("it ranks no course without C, widening what can form is better, or a premise in its place;",
    "it ranks no course except under C, widening what can form is better, or another order it names;")
rep("that the continuation condition and C are warranted ([dossier]", "that anyone must hold the continuation condition or C ([dossier]")
rep("A direction, comparing plans as the constructed [handover case]", "A direction, offered by the account's makers and not as a law, comparing plans as the constructed [handover case]")
rep("a ranking of open rule-making above capture without C or a premise in its place", "a ranking of open rule-making above capture except under C or another order named")
rep("| **Human development, and 生生 as the way for life** |", "| **Human development, and 生生, the continuation of life** |")
rep("T8, argued: for life, the way is 生生, life in the whole and its continuing generation [AI reading], compared by widening, under the continuation condition (scope) and C (order), neither asserted, warrant open; no verdict binding every possible mind ([07 §8](chapters/07-SIGNIFICANCE.md#theses)).",
    "T8, argued: for life, the account's makers offer a way of seeing, not a verdict: what each course draws on, from what renewal and at which grain, what ends and what goes on, and who bears it; 生生 is the continuation of life [AI reading]; it binds no one ([07 §8](chapters/07-SIGNIFICANCE.md#theses)).")
rep("None ranks a course: calling the widening course better needs C or a premise in its place, counting the losses that return to no one needs the continuation condition, and neither is asserted.",
    "None ranks a course: calling the widening course better is C's, counting the losses that return to no one is the continuation condition's, and the account asserts neither.")
rep("- It is not advice. No law here ranks a course; a ranking needs C or a premise in its place, with the continuation condition for scope, and neither is asserted.",
    "- It is not advice. No law here ranks a course; a ranking holds C or another order, with the continuation condition for scope, and the account asserts neither.")
rep("- Human development, and 生生 as the way for life: [Three courses for a valley: T8 under its two premises](USES-EXAMPLES.md#three-courses-for-a-valley-t8-under-its-two-premises)",
    "- Human development, and 生生, the continuation of life: [Three courses for a valley: what the readings rank and what is offered](USES-EXAMPLES.md#three-courses-for-a-valley-what-the-readings-rank-and-what-is-offered)")
open(p,'w',encoding='utf-8').write(s); print('ok')
