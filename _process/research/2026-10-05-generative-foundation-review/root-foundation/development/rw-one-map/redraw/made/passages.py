# AI-written, 12 November 2026. Passages written by hand for the sheet's first two paths, from the laws the
# readers placed there (items.json) and round 1's settled arrows. Every one is to be set against its Lean
# statement by a second reader before it is shown as settled.
#
# kind:
#   law      a general law shows the course itself making it (sufficient, or exact one way)
#   line     an exact line between two conditions: which side a course is on, said both ways by one law
#   needs    the laws give only what it needs: something from beyond the course, or a necessary condition
#   built    one built case shows it can happen
#   reading  no law; a reading
#   same     the same condition seen from another row

H = []
def p(a, b, kind, en, zh, laws=(), paths=(), note=''):
    H.append({'from': a, 'to': b, 'kind': kind, 'en': en, 'zh': zh, 'laws': list(laws), 'paths': list(paths), 'note': note, 'hand': True})

# ---------------- the path "living on what comes back" (rows A1, A2, B0)
p('a1.within', 'a1.over', 'line',
  'The line is exact: the level holds where what is taken stays within what comes back, and falls where it does not. The laws say where the line lies, not what moves a taking across it.',
  '界线是确切的：取的不超过补的，存量守得住；超过了，就降。定律说的是界线在哪里，没有说是什么把取用推过界线。',
  ['Becoming.Web.course_kept_iff', 'Becoming.Web.course_lost_iff'], ['stock'])
p('b0.together', 'a1.over', 'law',
  'Each can stay within its own share while all together take more than comes back. No one\'s own count shows the excess.',
  '各自都守在自己的份内，合起来仍可以比补回来的多。谁自己的账上都看不出超了。',
  ['Becoming.Pair.own_not_joint', 'Becoming.Exceeding.own_not_joint', 'Becoming.Flow.joint_excess_ends'], ['stock'])
p('b0.pays', 'b0.lost', 'line',
  'Taking everything is a best course exactly where nothing left standing returns more than one for one to the one that leaves it.',
  '“全拿走”是最好的做法，恰好是在这样的时候：留下的任何一份，回到留下它的那一个手里，都不超过一比一。',
  ['Becoming.Optimum.AtOnce.drain_perfect_iff', 'Becoming.Optimum.AtOnce.whole_perfect_iff'], ['stock'])
p('b0.lost', 'a1.over', 'law',
  'Where what is left returns less than one for one at every level, every best course takes all there is at the first step.',
  '只要在每个水平上，留下的都回不到一比一，每一种最好的做法都在第一步就拿光。',
  ['Becoming.Optimum.frontier_exhausts'], ['stock'])
p('b0.pays', 'a1.up', 'law',
  'Where leaving pays up to some level, every best course takes nothing while the stock regrows to that level.',
  '在某个水平以下留着都划算的时候，每一种最好的做法都先不取，等存量长回到那个水平。',
  ['Becoming.Optimum.frontier_rebuilds'], ['stock'])
p('a1.over', 'a1.past', 'law',
  'At a standing take above what comes back, the spare above the need lasts a fixed number of steps. The point of no return comes while what lives on it still has what it needs.',
  '取用一直高于补给的时候，高出需要的那点余量只够撑固定的步数。回不了头的那一点，来的时候靠它延续的还够用。',
  ['Becoming.Optimum.reread_deadline_iff', 'Becoming.RegimeMargin.ends_iff_below'], ['stock'])
p('a1.over', 'a1.within', 'needs',
  'Taking less keeps it, if the change comes while the need is still met. No law here says what lowers a taking.',
  '少取就留得住，只要改得够早、需要还供得上。这里没有定律说是什么让取用降下来。',
  ['Becoming.Optimum.reread_kept_iff'], ['stock'])
p('a1.past', 'a2.ended', 'law',
  'Below the point it ends; from the point up, the level never falls below where it started.',
  '在那一点以下，它尽；从那一点往上，存量不会降到起点以下。',
  ['Becoming.RegimeMargin.ends_iff_below'], ['stock'])
p('a1.over', 'a2.ended', 'law',
  'A constant take above what comes back ends with nothing left, in at most as many steps as the level allows.',
  '取用恒定地高于补给，结局是一点不剩；能撑的步数不超过存量。',
  ['Becoming.RuleRebuilding.«恒取逾生则尽»', 'Becoming.Flow.Balances.unfed_consumption_ends'], ['stock'])
p('a2.supplied', 'a2.short', 'line',
  'A need met at one step is cut off at the next exactly where the need, with all that is taken, exceeds the level with all that is given.',
  '这一步还供得上的需要，下一步断供，恰好是在这样的时候：需要加上全部取走的，超过了存量加上全部补进的。',
  ['Becoming.Flow.Balances.broken_iff'], ['stock'])
p('a2.short', 'a2.ended', 'law',
  'Unsupplied, it lasts as many steps as its reserve and no more.',
  '断了供，它能撑的步数等于它的储备，不会更多。',
  ['Becoming.Web.Carries.ends_within'], ['stock'])
p('a2.short', 'a2.supplied', 'needs',
  'Supplied again in time, it goes on as before. The laws give the window: so many steps, so much reserve.',
  '及时补上，它就照旧延续。定律给出的是时限：多少步，多少储备。',
  ['Becoming.Web.ends_within_on'], ['stock'])
p('a2.short', 'a2.else', 'needs',
  'Still going on after a loss that never returns means its need has changed.',
  '失去的再没回来，它却还在延续，那就是它的需要变了。',
  ['Becoming.Web.consumed_continues_transformed'], ['stock'])
p('a1.over', 'e2.rest', 'line',
  'With nothing coming in, change stops exactly where the total stops falling.',
  '没有东西进来的时候，变化停下，恰好是在总量不再下降的地方。',
  ['Becoming.World.InAmounts.change_stops_iff', 'Becoming.Flow.change_recurs_iff'], [])
p('a1.up', 'a1.new', 'needs',
  'Always something new needs more to come than goes. More is not yet new.',
  '“总有新的”需要来的比去的多；但多，还不等于新。',
  [], [], note='necessary only; from G')

# ---------------- the path "a rule that comes to hold itself" (rows B2, B1, Bs, B3)
p('a1.over', 'b2.uncounted', 'same',
  'The same taking, with a rule in play that leaves it out.',
  '同一种“取得比补得快”，只是多了一条不把它算进去的规则。',
  [], ['lock', 'stock'])
p('b2.uncounted', 'a2.ended', 'law',
  'With room to gain by it, every best outcome by the rule takes what it does not count as low as any allowed outcome leaves it. What lives on that thing is cut off where it needs more than remains.',
  '只要这么做在规则上还有得赚，按规则最好的结果都会把它不算的东西耗到允许的最低处。靠那东西延续的，需要的比剩下的多，就断了供。',
  ['Becoming.Optimum.least_of_room', 'Becoming.Web.optimum_broken_iff', 'Becoming.Web.optimum_ends_beyond'], ['lock'])
p('b2.uncounted', 'b2.felt', 'line',
  'It reaches what sets the rule in time exactly where the first moment anything with a say can tell comes before the point of no return.',
  '它及时传到，恰好是在这样的时候：说得上话的一方最早能察觉的那一刻，早于回不了头的那一点。',
  ['Becoming.Web.readableInTime_iff'], ['lock'])
p('b2.uncounted', 'a1.past', 'law',
  'It shows on nothing that sets the rule until what is being lost can no longer be kept.',
  '在正在失去的还留得住的时候，它在定规则的一方身上显不出任何差别。',
  ['Becoming.Web.too_late_of_alike', 'Becoming.Web.too_late_of_own'], ['lock'])
p('b2.felt', 'b2.counted', 'line',
  'The rule turns exactly where the rest count the loss while judgments taken together still go against what it favours.',
  '规则转向，恰好是在这样的时候：其余的开始把损耗算进去，而合起来的判断仍然不利于受偏向的一方。',
  ['Becoming.ReadInTime.turned_iff', 'Becoming.ClosedCapture.Thinned.kept_iff'], ['lock'])
p('b2.felt', 'b2.heard', 'line',
  'The hold stays exactly where, by the time the rest begin to count the loss, judgments taken together already favour what the rule favours.',
  '规则照旧定着，恰好是在这样的时候：等其余的开始算这笔损耗，合起来的判断已经偏向规则所偏向的一方。',
  ['Becoming.ReadInTime.kept_early_iff', 'Becoming.ReadInTime.deadline'], ['lock'])
p('b1.outside', 'b1.swing', 'needs',
  'A rule set from outside comes to be rebuilt from its results only where a chain of effects closes back on it. Nothing in the amounts carried so far shows that coming.',
  '由外面定的规则，要有一条因果的链子绕回它自己，才会变成跟着结果改。在此之前传过的数量里，看不出这一步要来。',
  ['Becoming.onLoop_succ_iff', 'Becoming.Closing.Onset.unforeseen'], ['lock'], note='how-loops-form, read on a rule: a reading of the general law')
p('b1.swing', 'b1.held', 'law',
  'Where every rebuilding favours what is ahead, every course is held from the step after its second rebuilding, whatever rule and reading it starts with.',
  '只要每一次重定都偏向领先的一方，无论从什么规则、什么读法开始，到第二次重定之后的那一步，就都定住了。',
  ['Becoming.ClosedCapture.readers_uniform_locks'], ['lock'])
p('b1.held', 'b3.inside', 'same',
  'The same hold, where how the rule is judged is formed from what it favours too.',
  '同一个“定住”，只是连怎么评这条规则，也由它偏向的一方来定了。',
  ['Becoming.ClosedCapture.reading_absorbed'], ['lock'])
p('b3.inside', 'b3.inside', 'law',
  'From a held start the hold lasts at every step while the loss beyond passes every bound.',
  '从定住的地方出发，每一步都还定着；而圈外的损耗越过任何界限。',
  ['Becoming.ClosedCapture.lock_outlives_loss'], ['lock'], note='stays')
p('bs.costs', 'bs.pays', 'line',
  'Bending the rule pays exactly where what comes back to its doers alone covers the cost, whatever all get alike.',
  '改规则划得来，恰好是在这样的时候：单独回到改的一方手里的，抵得过花费；大家一样都得的不算。',
  ['Becoming.RuleShaping.favours_iff', 'Becoming.RuleShaping.disfavours_iff', 'Becoming.RuleShaping.grouped_rises_iff'], ['lock'])
p('bs.pays', 'b3.inside', 'reading',
  'Where winning buys power over the rule that picks the winners, the hold and the judging close into one loop. The account calls this loop the meta-attractor. No law joins the two steps.',
  '赢了就能买到左右规则的力量，而规则又在选谁赢：这时“定住”和“自己评自己”合成一个圈。这个圈，本书叫作元吸引子。把这两步连起来的定律还没有。',
  [], ['lock'])
p('b2.uncounted', 'b3.gone', 'built',
  'What is used up is what the ones that would tell stand on, so it removes them. Shown in built cases, and as a reading.',
  '被耗掉的，正是会察觉的那一方立足的东西，所以它们被清走了。有构造出来的例子，也有一条解读；没有一般的定律。',
  ['Becoming.ReadingsSpread.Commons.cleared_spreads', 'Becoming.ReadingsPersist.Habitat.cleared_removes_its_readers'], ['lock'])
p('b3.gone', 'd3.one', 'law',
  'Everything left holds the one view, and each newcomer\'s view is copied from something still present.',
  '剩下的全都是同一个看法，新来的看法又是从还在场的那里学的。',
  ['Becoming.Flow.closedFrom_of_standing'], ['lock'])
p('b3.gone', 'b3.checkers', 'reading',
  'The second and third order: the ways a judgment could be corrected are themselves filled from inside, and then breaking them is rewarded. No law.',
  '第二阶和第三阶：纠正判断的那些途径，也由圈里的来填；再往后，弄坏这些途径反倒受奖励。没有定律。',
  [], ['lock'])
p('b3.checkers', 'd2.handed', 'reading',
  'The pattern goes on rebuilding what picks it while what carries it is replaced: the meta-attractor in the wide sense. Open; no law says this pattern is handed on.',
  '承载它的换了一茬又一茬，这个格局照旧重建出选中它的条件：这是广义的元吸引子。未定；还没有定律说这个格局会这样传下去。',
  [], ['lock'])
# the ways out
p('b3.inside', 'b2.counted', 'needs',
  'The hold is left where something reads what lies beyond the share: a judging that stops favouring past a set loss releases it after every rebuilding past that amount.',
  '要离开这个“定住”，得有一方读到份额之外的东西：一种过了定量的损耗就不再偏向的评法，会在此后每一次重定之后把它松开。',
  ['Becoming.ClosedCapture.turned_by_loss', 'Becoming.ClosedCapture.loss_ends_line'], ['lock'])
p('b1.held', 'b2.counted', 'needs',
  'The rest start counting the loss early enough: rejudged twice running, the rule no longer favours what it favoured.',
  '其余的够早开始把损耗算进去：连续两次重评之后，规则不再偏向原先的一方。',
  ['Becoming.ReadInTime.turned_early_iff'], ['lock'])
p('b3.gone', 'b3.list', 'needs',
  'The measure is taken over a fixed list of all that began, not only over what is left.',
  '衡量的时候按一开始就定下的全部名单，不只看剩下的。',
  ['Becoming.not_allPersist_of_removes'], ['lock'])

HAND = H
