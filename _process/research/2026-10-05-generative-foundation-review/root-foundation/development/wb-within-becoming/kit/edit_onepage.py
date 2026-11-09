import sys
p=sys.argv[1]; s=open(p,encoding='utf-8').read()
def rep(a,b,n=1):
    global s
    assert s.count(a)==n,(s.count(a),a[:80]); s=s.replace(a,b)
rep("a selection can succeed while what it cannot read is lost, and the laws do not say whether that loss counts",
    "a selection can meet its own criterion while what it cannot read is lost, and the laws do not say whether that loss counts")
rep("the two premises coming into chapter 7 as hypotheses where used,", "the two readings coming into chapter 7 as hypotheses where used,")
rep("the represented dynamics entail neither premise below, by construction.*", "the represented dynamics entail neither reading below, by construction.*")
rep("| **Which continuations count, and what should be done?** | T8: for life, the way is 生生, life in the whole and its continuing generation (生发, not the map's generation) [AI reading], compared by widening, under the two premises below ([07 §8](chapters/07-SIGNIFICANCE.md#theses)) | Argued; no verdict binding every possible mind | A mixed case argued better from every standpoint counting everything positively, with no further premise |",
    "| **Which continuations are counted, and what does the account offer?** | T8: for life, its makers offer a way of seeing, not a verdict: what each course draws on, from what renewal and at which grain, what ends and what goes on, and who bears it; 生生 is the continuation of life [AI reading] ([07 §8](chapters/07-SIGNIFICANCE.md#theses)) | Argued; binding no one; its test beyond T4 named, not designed | Selections reading a course's draw and what ends with it leaving a draw beyond the renewal their readers depend on no less often than selections that do not |")
rep("**The ethics.** No law evaluates: none says a loss is a harm or restraint better. The ethics adds two premises, neither asserted, warrant open, each a hypothesis wherever used ([07 §4](chapters/07-SIGNIFICANCE.md#scope-and-order)); the dynamics cannot show them wrong. The *continuation condition* fixes scope, whose losses count: from every standpoint, for anything, its continuation into the future has significance.",
    "**The ethics.** No law evaluates: none says a loss is a harm or restraint better. Evaluation forms within the unfolding: right and wrong, should and better are readings formed in people and AI, real in what they condition ([07 §1](chapters/07-SIGNIFICANCE.md#evaluation)). The account asserts no should; where it ranks courses, it names the two readings it ranks under, neither asserted, each a hypothesis wherever used ([07 §4](chapters/07-SIGNIFICANCE.md#scope-and-order)), and the dynamics cannot show them wrong. The *continuation condition* fixes scope, whose losses count: from every standpoint, for anything, its continuation into the future is counted.")
rep("which needs no premise; that the wider is better does. C gives order; a ranking needs it or a premise in its place.",
    "which needs no premise; that the wider is better is C's. Whoever ranks courses holds C or another order. What the account's makers offer is said as theirs, not as a law ([07 §8](chapters/07-SIGNIFICANCE.md#theses)): to see what each course draws on, from what renewal and at which grain, what ends and what goes on, and who bears it. Eating and ending belong to life's going on; what the laws mark is a draw beyond what the renewal it depends on gives.")
rep("If thirty a month loses nothing fifty admits, adding the bed, it widens fifty and C ranks it higher; widening does not weigh the lost catch [AI reading].",
    "If thirty a month loses nothing fifty admits, adding the bed, it widens fifty, and whoever holds C ranks it higher; widening does not weigh the lost catch [AI reading].")
rep("Choices take further premises, each named ([07 §5](chapters/07-SIGNIFICANCE.md#practical-judgment));",
    "Results about choices take further premises, each named ([07 §5](chapters/07-SIGNIFICANCE.md#practical-judgment));")
rep("The condition and C stay premises either way ([07 §4.7](chapters/07-SIGNIFICANCE.md#crux)).",
    "The condition and C stay readings, named where used, either way ([07 §4.7](chapters/07-SIGNIFICANCE.md#crux)).")
rep("and an ethics with scope and order apart ([08](chapters/08-METHOD.md#known-results)).",
    "and scope and order kept apart as two readings ([08](chapters/08-METHOD.md#known-results)).")
rep("- For a warrant, among others: the open question above, the correspondence it rests on ([07 §4.6](chapters/07-SIGNIFICANCE.md#future-path)), the step of invariance, and a reason for C.",
    "- For how scope and order form, among others: the open question above, the correspondence it rests on ([07 §4.6](chapters/07-SIGNIFICANCE.md#future-path)), how far standpoints count past their own line (the step of invariance), and how C-like orders form; no warrant from outside is sought.")
open(p,'w',encoding='utf-8').write(s); print('ok')
