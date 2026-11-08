import sys
p = sys.argv[1]; s = open(p, encoding='utf-8').read()
def rep(a, b, n=1):
    global s
    assert s.count(a) == n, ("count", s.count(a), a[:90])
    s = s.replace(a, b)
rep("Where the chapter touches evaluation ([§2](#where-the-ethics-sits), [§4](#premise-card), [§12](#open-programme)), the ethics rests on two premises with two roles, neither asserted: the continuation condition fixes scope, C fixes order.",
    "Where the chapter touches evaluation ([§2](#where-the-ethics-sits), [§4](#premise-card), [§12](#open-programme)), evaluation forms within the unfolding and the ranking results use two readings, neither asserted: the continuation condition for scope, C for order.")
rep("The continuation condition fixes scope and ranks nothing, and C gives order; a ranking of courses needs C or a premise in its place.",
    "The continuation condition fixes scope and ranks nothing, and C gives order; whoever ranks courses holds C or another order, named where used.")
rep("""**Where the ethics sits.** The theory asserts no ethical axiom. Its two foundations have two roles, and neither is asserted:

- the continuation condition (`Unrestricted`: for anything, its continuation into the future has significance) fixes scope, that is, whose losses count;
- C fixes order: widening what can form is better.""",
"""**Where the ethics sits.** The theory asserts no ethical axiom and no should: evaluation forms within the unfolding ([07 §1](07-SIGNIFICANCE.md#evaluation)), and no law evaluates. Where a result ranks, it names the readings it ranks under, two roles, neither asserted:

- the continuation condition (`Unrestricted`: for anything, its continuation into the future is counted, from every standpoint) fixes scope, that is, whose losses count;
- C fixes order: a course above every course it widens, that is, widening what can form called better.""")
rep("So every ethical result is **Conditional** and names what it uses, and wherever the ethics is summarized both foundations are named with their roles.",
    "So every ethical result is **Conditional** and names what it uses, and wherever a ranking result is restated, the readings it uses are named with their roles. What the account's makers offer, for life, is said as theirs, not as a law ([07 §8](07-SIGNIFICANCE.md#theses), T8).")
rep("gives order; a ranking of courses needs it or a premise in its place (self-concern ranks one case with no C); warrant open |",
    "gives order; whoever ranks courses holds it or another order (self-concern ranks one case with no C); a reading, not asserted, no warrant from outside sought |")
rep("- that C or L is warranted or unwarranted: meeting and failing say what each asks of an order, and the ethics' two premises stay premises, the continuation condition for scope and C for order;",
    "- that anyone must hold C or L: meeting and failing say what each asks of an order, and the two readings stay readings, the continuation condition for scope and C for order;")
rep("(value into the requirement, supplied by the two premises)", "(value into the requirement, supplied by the two readings)")
rep("elsewhere a ranking still needs C or a premise in its place ([07 §4.4]", "elsewhere a ranking still holds C or another order ([07 §4.4]", 2)
rep("The ethics rests on its two premises either way, the continuation condition for scope and C for order.",
    "The ranking results rest on their two readings either way, the continuation condition for scope and C for order.")
rep("It requires warranting whatever universal content the theory asserts,", "It requires showing whatever universal content the theory asserts,")
rep("Explaining how evaluation forms is distinct from justifying what deserves favourable appraisal, though both happen within the same unfolding.",
    "Explaining how evaluation forms is distinct from holding an appraisal, though both happen within the same unfolding.")
rep("The ethical orientation is a second target. One derivation runs from the characterization of significance to the selection of grounded widening, its normative hypotheses named (K6). The ethics rests on the continuation condition for scope and C for order, and the practical results add the commitments named in them; what follows is checked, and the warrant is open.",
    "The ethical orientation is not a target to derive: what the account's makers offer is said as theirs ([07 §8](07-SIGNIFICANCE.md#theses), T8). One derivation runs from the characterization of significance to the selection of grounded widening, its hypotheses named (K6); the ranking results rest on the continuation condition for scope and C for order, and the practical results add the commitments named in them; what follows is checked, and no warrant from outside is sought.")
rep("C gives order, and a ranking of courses needs C or a premise in its place. The work serves the question by stating it where readers can take it up.",
    "C gives order, and whoever ranks courses holds C or another order. The work serves the question by stating it where readers can take it up.")
rep("12. **Warrant** (philosophical warrant). Is widening better (C, which orders), and does significance stop at no boundary (the step of invariance, which fixes scope)? With them,",
    "12. **How scope and order form** (philosophical; until 9 November 2026 \"Warrant\"). Which formations hold C, which count past their own line (the step of invariance, which fixes scope), and how such orders form, spread, lock and fare; no warrant from outside is sought. With them,")
rep("*Open:* P2 and P4 of [07 §4.6](07-SIGNIFICANCE.md#future-path), the step for what that path does not reach, a reason for C, and whether a stronger practical warrant exists, with no warrant binding every possible mind claimed (T8); no formal work settles them ([below](#philosophical-warrant)).",
    "*Open:* P2 and P4 of [07 §4.6](07-SIGNIFICANCE.md#future-path), and what that path does not reach, counted only by a standpoint taking the step; how C-like orders form; whether a universal practical warrant exists is kept as a question the account does not pursue (T8); no formal work settles them ([below](#philosophical-warrant)).")
rep("### Philosophical warrant\n", "### Philosophical questions\n")
rep("it stays open, and the ethics, life's stance, does not wait on it ([07](07-SIGNIFICANCE.md#r-universal-practical-warrant), T8).",
    "a question the account does not pursue: no warrant from outside is sought, and what it offers does not wait on one ([07](07-SIGNIFICANCE.md#r-universal-practical-warrant), T8).")
rep("C's no-loss extension is widening by definition, so the definition carries no warrant;",
    "C's no-loss extension is widening by definition, so the definition carries no \"better\": calling widening better is C's, a reading some hold and the account does not assert;")
rep("| T8. 生生 as the direction | [07](07-SIGNIFICANCE.md#theses) | argued; open: P2 and P4 of [07 §4.6](07-SIGNIFICANCE.md#future-path) (one's line a regularity of its own; its class holding one's effects), the crux of that path, with P3, a correspondence not shown for actual selves; the step of invariance, for what that path does not reach; and a reason for C | a mixed case argued better from every standpoint counting everything positively, with no further premise; a pure closing argued good for life | the finite theorem `Weighting.widens_iff_every_of_class` beneath it |",
    "| T8. 生生, the continuation of life, as what the makers offer | [07](07-SIGNIFICANCE.md#theses) | argued; its test beyond T4 named, not designed; open: P2 and P4 of [07 §4.6](07-SIGNIFICANCE.md#future-path) (one's line a regularity of its own; its class holding one's effects), the crux of that path, with P3, a correspondence not shown for actual selves; how readings that count beyond one's own line form | selections that read a course's draw and what ends with it leaving a draw beyond the renewal their readers depend on no less often than selections that do not | the finite theorem `Weighting.widens_iff_every_of_class` beside it, and T4's test |")
open(p, 'w', encoding='utf-8').write(s); print('ok')
