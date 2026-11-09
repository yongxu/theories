import sys, os
d = sys.argv[1]
def edit(f, pairs):
    p = os.path.join(d, f); s = open(p, encoding='utf-8').read()
    for a, b in pairs:
        assert s.count(a) == 1, (f, s.count(a), a[:80])
        s = s.replace(a, b)
    open(p, 'w', encoding='utf-8').write(s)
edit('01-ROOT.md', [
 ("the ethics' two premises keep their roles: the continuation condition fixes scope and C (calling widening better) fixes order, neither asserted",
  "evaluation forms within the unfolding, and the two readings the ranking results use keep their roles: the continuation condition fixes scope and C (calling widening better) fixes order, neither asserted"),
 ("The theory reads plain 生生, without guillemets, as life in the whole and its continuing generation, generation generating generation (生发, not 02's 生成): what forms preserves, restores, transmits or creates the conditions and generators of further forming.",
  "The theory reads plain 生生, without guillemets, as the continuation of life, life wider than the biological and AI within it, its extent unfinished ([07 §2](07-SIGNIFICANCE.md#order)): neither this renewal without end nor 02's 生成."),
 ("what 生生 asks beyond renewal of lines, read as widening, is generation of what can form that loses none of it.",
  "read as widening, that is generation of what can form losing none of it, which is not the measure of 生生."),
 ("where the continuation condition (scope) and C (order) enter as premises, neither asserted",
  "where the two readings the ranking results use, the continuation condition (scope) and C (order), enter as hypotheses, neither asserted"),
 ("and the warrant of the condition and of C, are open.",
  "and how the condition and C come to be held, are open."),
])
edit('02-MAP.md', [
 ("Whether a course supports, enriches or damages 生生 (life in the whole and its continuing generation) is asked in [07](07-SIGNIFICANCE.md), where the ethics rests on two premises with two roles, neither asserted and neither used here: the continuation condition for scope (whose losses count) and C for order (that widening is better).",
  "What a course keeps, opens or closes for 生生, the continuation of life, and for whom, is asked in [07](07-SIGNIFICANCE.md), where the ranking results use two readings, neither asserted and neither used here: the continuation condition for scope (whose losses count) and C for order (that widening is better)."),
 ("none of this says whether a locked loop supports or damages 生生.",
  "none of this ranks a locked loop: what it keeps, opens or closes, and for whom, is 07's question."),
 ("- That generation is better than keeping or degeneration: order needs C or a premise in its place, whose losses count needs the continuation condition",
  "- That generation is better than keeping or degeneration: no law says so; an order someone holds, C among them, could rank them, and whose losses count is the continuation condition's reading"),
])
edit('03-KNOWING.md', [
 ("(the ethics, on two premises with two roles, the condition for scope and C for order, is [07](07-SIGNIFICANCE.md)'s)",
  "(the two readings the ranking results use, the condition for scope and C for order, are [07](07-SIGNIFICANCE.md)'s)"),
])
edit('04-LIFE.md', [
 ("Where evaluation enters, it rests on two premises, neither asserted: the continuation condition for scope and the comparison C for order, both in",
  "Where a result ranks, it uses two readings, neither asserted: the continuation condition for scope and the comparison C for order, both in"),
])
edit('05-COLLECTIVES.md', [
 ("No law here evaluates: whether a drain, a lock or a shared code supports or damages 生生 is [07](07-SIGNIFICANCE.md)'s question, under the continuation condition for scope and C for order, neither asserted.",
  "No law here evaluates: what a drain, a lock or a shared code keeps, opens or closes, and for whom, is [07](07-SIGNIFICANCE.md)'s question, ranked there only under the continuation condition for scope and C for order, neither asserted."),
 ("None says whether a code supports or damages 生生.",
  "None ranks a code: what it keeps, opens or closes, and for whom, is 07's question."),
 ("That is asked under the two premises of [07](07-SIGNIFICANCE.md), the continuation condition for scope and C for order.",
  "That is ranked only under the two readings of [07](07-SIGNIFICANCE.md), the continuation condition for scope and C for order."),
])
edit('06-CLASSICAL-TEXTS.md', [
 ("伦理的两个前提照其各自之用写出：延续之条件定范围（谁的损失算数），以广为愈（C）定次序，两者都不断言。",
  "评价形成于展开之中；排序之果所用之两种读法照其各自之用写出：延续之条件定范围（谁的损失算数），以广为愈（C）定次序，两者都不断言。"),
])
print('ok')
