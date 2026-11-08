import sys
p = sys.argv[1]; s = open(p, encoding='utf-8').read()
def rep(a, b):
    global s
    assert s.count(a) == 1, ("count", s.count(a), a[:80])
    s = s.replace(a, b)

# Thesis
rep("With no premise, the laws give how two courses differ in what they admit (one widens the other, they admit the same, or they are mixed), and alignment is first what a selection reaches. The ethics rests on two premises with two roles, neither asserted: the continuation condition fixes scope (whose losses count), its content beyond the self's presupposition being the step of invariance; C fixes order (that widening is better), the order every positive weighting shares. Claimed: these laws; living significance as a theorem under the condition; reasons, choices and a direction for alignment under further named premises. Open: what still needs argument, with no warrant binding every possible mind claimed (T8, [§8](#theses)): P2 and P4, the crux of [§4.6](#future-path)'s path, which carries one's concern for one's own continuation past one's own end without the step; the step, for what that path does not reach; and a reason for C; whether",
    "With no premise, the laws give how two courses differ in what they admit (one widens the other, they admit the same, or they are mixed), and alignment is first what a selection reaches. Evaluation forms within the unfolding ([§1](#evaluation)): right and wrong, should and better are readings formed in some formations, real in what they condition, and no law evaluates. The chapter's ranking results are conditional on two readings it names, neither the account's own: the continuation condition fixes scope (every continuation counted, from every standpoint), its content beyond the self's presupposition being the step of invariance; C fixes order (a course above every course it widens), the order every positive weighting shares. Claimed: these laws; living significance as a theorem under the condition; reasons, choices and a direction for alignment under further named premises. Offered, by the account's makers and not as a law: to see what each course draws on, from what renewal and at which grain, what ends and what goes on through it, and who bears it ([§8](#theses)). Open: how such readings form and fare; P2 and P4, the crux of [§4.6](#future-path)'s path, which carries one's concern for one's own continuation past one's own end without the step; what that path does not reach, which only a standpoint taking the step counts; whether")
rep("and the condition on the root beyond the laws stated there.\n",
    "and the condition on the root beyond the laws stated there. No warrant from outside is sought.\n")

# Bases
rep("Evaluation enters through the ethics' two premises, each a hypothesis where used and neither asserted: the continuation condition for scope, C for order.",
    "Evaluation forms within the unfolding ([§1](#evaluation)); the ranking results take two readings as hypotheses where used, neither asserted: the continuation condition for scope, C for order.")

# Route (b)
rep("With no condition, \"should\" is what a center does once its represented boundary matches what it depends on, and since a loss returns to a center through its feeders, this gives, without warranting, a reason of its own to retain what lies within its closure (route (b) [AI reading, D17]).",
    "With no condition, there is no \"should\" apart from what a center does. Where its represented boundary matches what it depends on, a loss returns to it through its feeders, and that reading is one condition of a response retaining what lies within its closure, a reason of its own; it does not produce the response (told of the bed, one model of two kept it, [T4](#theses)), and the response so derived reaches only what the center depends on (route (b) [AI reading, D17]).")

# Section 4 heading and opening
rep("## 4. Scope and order: two premises, two roles\n\nA self acting for its own continuation presupposes that some continuation has significance; how far that reaches and which course is better are separate questions with separate premises.",
    "<a id=\"4-scope-and-order-two-premises-two-roles\"></a>\n## 4. Scope and order: two readings, two roles\n\nA self acting for its own continuation presupposes that some continuation is counted; how far that reaches and how courses are ranked are separate questions, and the results here answer each under a reading it names.")
rep("| Premise | Role | What it does | What it does not do |",
    "| Reading | Role | What it does | What it does not do |")
rep("Neither is asserted. The condition alone ranks nothing: under it living significance follows, the reasons of [§3.2](#yields) only with A or D and correspondence. A ranking of courses needs C or a premise in its place: C gives order, and an order rising with one's own continuation ranks one case with no C ([§4.4](#r-what-self-concern-alone-ranks)).",
    "Neither is asserted, and neither is the account's own: each is an order or scope some formations hold, and the results say what follows where it is held. The condition alone ranks nothing: under it living significance follows, the reasons of [§3.2](#yields) only with A or D and correspondence. Whoever ranks courses holds some order; C is the one ranking a course above every course it widens, and an order rising with one's own continuation ranks one case with no C ([§4.4](#r-what-self-concern-alone-ranks)).")
open(p, 'w', encoding='utf-8').write(s)
print("ok")
