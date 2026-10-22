#!/usr/bin/env python3
"""Write the ZG1-ZG3 records (theorems answering the ZH map's gaps) and note the record civilization-thought-on-the-spine:
python3 -B make_records_zg13.py CORE_RECEIPT SECTION_ZG1 PREVIOUS_RECEIPT   (from the checkout root, after apply_text_zg13.py;
the sections of ZG2 and ZG3 follow SECTION_ZG1)

Every cited declaration is resolved against the receipt, the receipt must bind each module's current bytes, and together
the records cite exactly the declarations the touched modules gained (two_mul_pow, removed, excepted)."""
import datetime
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
REVIEW = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-SIGNIFICANCE-REVIEW.md'
CHAPTER = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
MAPCH = 'theories/becoming/chapters/CIVILIZATION-THOUGHT-AND-BECOMING.md'
ZHMAP = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/zhonghua/passages.json'
RECORDS = ROOT / 'theories/becoming/results/records'
core_id, N1, previous = sys.argv[1], int(sys.argv[2]), sys.argv[3]
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
P = json.loads(Path(previous).read_text())
MODS = ['Change', 'Decidedness', 'RelativePosition', 'Attraction', 'Regulation', 'Tolerance', 'Significance', 'Copying',
        'Continuation', 'Admission', 'Interleavings', 'Learning', 'Frequency', 'Wholes', 'Reserve', 'Evolution']
REMOVED = {'Becoming.Copying.two_mul_pow'}


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


full, new = {}, set()
for mod in MODS:
    src = f'{PKG}/Becoming/{mod}.lean'
    m = next(m for m in core['modules'] if m['module'] == f'Becoming.{mod}')
    assert core['source_sha256'][f'Becoming.{mod}'] == sha(src), mod
    assert not any(m['axiom_dependencies'].values())
    names = [d['name'] for d in m['declarations']]
    old = {d['name'] for d in next(x for x in P['modules'] if x['module'] == f'Becoming.{mod}')['declarations']}
    assert not (old - set(names) - REMOVED), old - set(names)
    for n in names:
        full[n] = mod
    new |= {n for n in names if n not in old}


def R(names):
    out = []
    for n in names:
        assert 'Becoming.' + n in full, n
        out.append('Becoming.' + n)
    return out


BOUNDS = ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical', 'names-provisional',
          'omission-not-refutation']
S1, S2, S3 = N1, N1 + 1, N1 + 2
# id, batch section, modules, title, statement, laws [(en, zh, names)], hypotheses, does_not_show [(en, zh, kind)],
# correspondence, dependencies [(id, en, zh)], zh entries
SPEC = [
 ('negation-change-and-stable-cases', S1, ['Change', 'Decidedness'],
  ('A negation\'s change, and cases into a stable conclusion', '否定之变与归于稳定结论之分情形'),
  ('What ceases to be is the coming to be of its negation, and back where the determination is stable; a conclusion following from a proposition and from its failure holds wherever it is stable, the proposition undecided.',
   '止息即其否定之生起，规定稳定处反之亦然；由一命题与其否定分别推出之结论，凡稳定处即成立，该命题不须定然否。'),
  [('What ceases to be is the coming to be of its negation, and what comes to be the ceasing of its negation, with no premise; read back, the determination must be stable where it is read; on a web, a formation ceasing is its inactivity coming to be.',
    '止息即其否定之生起，生起即其否定之止息，无前提；反读时该规定须在所读之处稳定；在网上，一形成之止息即其不活跃之生起。',
    ['CeasesToBe.not_comes', 'ComesToBe.not_ceases', 'ComesToBe.of_not', 'CeasesToBe.of_not', 'Web.ceasing_readings']),
   ('A conclusion following from a proposition and from its failure holds wherever it is stable, the proposition left undecided; every negation and every equation of numbers is stable.',
    '由一命题与其否定分别推出之结论，凡稳定处即成立，该命题不须判定；一切否定与数之等式皆稳定。', ['Decided.cases_stable'])],
  ('No axiom; a determination is any predicate of steps; stability (double negation elimination at the point read) where stated.',
   '不加公理；规定是步上之任一谓词；所述之处须稳定（在所读之点双重否定可消去）。'),
  [('That a determination is decided: only stability where read is used.', '规定可判定：只用所读之处之稳定。', 'non-implication')],
  ('Constructive logic: double negation is stable on negations and on decidable propositions.', '构造逻辑：否定与可判定之命题上双重否定稳定。'),
  [('coming-and-ceasing-keep-pace', 'Change read as coming to be and ceasing to be; the negation reading is added.', '以生起与止息读变；增否定之读。'),
   ('counts-exist-where-decided', 'The census laws argue by the same stable cases.', '普查之律以同样稳定之分情形论证。')],
  ['mojing-yi-cheng-wang', 'xici-gang-rou-xiang-tui', 'zhuangzi-ri-ye-xiang-dai', 'mobian-wu-qiong-ying-fou']),
 ('least-parts-and-equal-shares', S1, ['RelativePosition'],
  ('Least parts and equal shares', '最小之处与均分'),
  ('A least part is not above the family\'s average, and with no more in all more parts leave it no more; equal shares meet every need exactly where they meet the greatest, giving more than the total need where needs differ.',
   '最小之处不在族之平均之上，总量不增而处数增多则最小之处不增；等份满足每一需要恰当满足最大者，需要不等处所给多于需要之和。'),
  [('A least part\'s amount counted once for each part is at most the family\'s total, and every nonempty family has a least part; with the total at most T and at least n parts, n times the least amount is at most T.',
    '最小之处之量乘以处数至多为族之总，每一非空之族有最小之处；总量至多 T、处数至少 n 时，n 乘最小之量至多 T。',
    ['RelativePosition.Least', 'RelativePosition.least_not_ahead', 'RelativePosition.least_exists', 'RelativePosition.least_bound']),
   ('Equal shares meet every need exactly where they meet the greatest; they give more than the total need where some need falls short of the greatest, exactly the total where none does; two parts needing one and three are short in equal shares of what suffices by need.',
    '等份满足每一需要恰当满足最大者；有需要少于最大者时所给多于需要之和，无则恰等；需一与需三之两处，按需足够之量均分则后者不足。',
    ['RelativePosition.equal_share_iff', 'RelativePosition.equal_share_exceeds', 'RelativePosition.equal_share_even', 'RelativePosition.uneven_short'])],
  ('No axiom; whole-number amounts on a finite list of parts.', '不加公理；有限列表上之整数之量。'),
  [('That an actual distribution is by equal shares or by need.', '实际之分配是均分或按需。', 'non-implication')],
  ('The minimum is at most the mean (an averaging inequality); equal versus needs-based allocation.', '最小值不超过平均值（平均之不等式）；均分与按需分配。'),
  [('relative-position-is-zero-sum', 'The least part is the dual of its greatest part.', '最小之处是其最大之处之对偶。')],
  ['sunzi-wu-suo-bu-bei', 'lunyu-bu-huan-gua-er-huan-bu-jun']),
 ('copying-b-fold', S1, ['Copying'],
  ('Copying b-fold', 'b 倍抄录'),
  ('Where every unit draws d from one stock and becomes b, n rounds from k units run exactly where the stock covers d times what they draw for, ending with k times b to the n units; doubling is the case b = 2.',
   '每单元自一存量汲 d 而成 b 个，自 k 单元之 n 轮恰在存量足 d 乘其所汲之处走完，终有 k 乘 b 之 n 次方个单元；倍增为 b = 2 之情形。'),
  [('What n rounds of copying c + 1 fold draw for, times c, with the k units of the start, is k times (c + 1) to the n; doubling\'s count is its case.',
    'c + 1 倍抄录 n 轮所汲乘以 c，加起始之 k 单元，为 k 乘 (c + 1) 之 n 次方；倍增之数为其情形。',
    ['Copying.requiredBy', 'Copying.mul_pow_succ', 'Copying.requiredBy_add']),
   ('Copying b-fold runs n rounds exactly where the stock covers d times what they draw for, ending with k times b to the n units and what is left; doubling is its case.',
    'b 倍抄录恰在存量足 d 乘其所汲之处走完 n 轮，终有 k 乘 b 之 n 次方个单元与余量；倍增为其情形。',
    ['Copying.copying', 'Copying.copying_iff', 'Copying.copying_runs']),
   ('One teaching ten, five rounds from one unit run from a stock of 11,111 and end with 100,000 units and none left.',
    '一教十，自一单元之五轮以 11,111 之存量走完，终有十万单元，存量无余。', ['Copying.tenfold'])],
  ('No axiom; whole-number units and stock; each unit drawing the same d each round.', '不加公理；整数之单元与存量；每轮每单元汲同一 d。'),
  [('That teaching or reproduction copies at a fixed factor.', '教或繁殖以固定倍数抄录。', 'non-implication')],
  ('Geometric growth and the geometric series of what it consumes.', '几何增长及其所耗之几何级数。'),
  [('recurrent-chain-assembly', 'Its doubling is the case b = 2.', '其倍增为 b = 2 之情形。')],
  ['wuzi-yi-ren-xue-zhan']),
 ('far-conveying-runs-the-family-down', S1, ['Continuation'],
  ('Far conveying runs the family down', '远输使族耗减'),
  ('Balanced and dissipated on across N steps, each conveying from a member of the family, the family\'s stock falls by at least N; so from a stock of S at most S stages are conveyed.',
   '族跨 N 步皆衡且耗、每步自族之一员有所输送，则族之存量至少降 N；所以起点存量为 S 者至多输送 S 程。'),
  [('A step conveying from a member of a family has a formation taking from the family; balanced and dissipated on across N such steps, the family\'s stock falls by at least N, and N is at most its stock at the start.',
    '自族之一员有所输送之步有取于族之形成；跨 N 个如此之步皆衡且耗，族之存量至少降 N，且 N 至多为起点存量。',
    ['Flow.takers_pos_of_conveys', 'Flow.conveyed_loses'])],
  ('No axiom; balance and dissipation on the family at each step of the stretch; whole-number amounts.', '不加公理；该段每步族上衡且耗；整数之量。'),
  [('That actual supply lines dissipate at each stage.', '实际之补给线每程皆耗。', 'non-implication')],
  ('Loss along a supply chain; transport cost proportional to distance.', '补给链上之损耗；运输之耗与程数成比例。'),
  [('no-finite-part-bears-taking', 'Its loss law over a stretch (takers_within_on) is used.', '用其一段上之损失之律（takers_within_on）。')],
  ['sunzi-yuan-shu']),
 ('a-need-with-a-cap', S1, ['Admission'],
  ('A need with a cap', '带上限之需'),
  ('Where a need has a cap, levels keep a formation within its band between need and cap; with balance the band is exact on both sides, a part opening it from below by giving and closing it from above by giving beyond the margin to the cap.',
   '所需带上限时，水平使形成在所需与上限之间之带内；平衡之下此带两侧皆确切，部分以给予自下开之，以越过上限余地之给予自上阖之。'),
  [('Levels keep a formation within its band at a step where each condition it requires stands between its need and its cap; levels within the band admit it.',
    '水平使形成在某步处于其带内，恰当其所需之每一条件在所需与上限之间；带内之水平容之。', ['Web.FitsBand', 'Web.FitsBand.admits']),
   ('With balance at the conditions required across the steps before, the levels that stand keep the formation within its band exactly where, at each, need plus what the part took is at most the level without the part plus what it gave, which is at most the cap plus what it took.',
    '此前各步所需条件上皆衡时，现水平使形成在带内，恰当每一条件上所需加部分所取至多为无部分之水平加其所给，后者至多为上限加其所取。',
    ['Flow.fitsBand_iff_within_margins_at'])],
  ('No axiom; balance at the conditions the formation requires, across the steps before; whole-number levels.', '不加公理；此前各步形成所需之条件上衡；整数之水平。'),
  [('Which needs have caps in an actual world.', '实际世界中哪些所需带上限。', 'non-implication')],
  ('Tolerance ranges: too much harms as too little does (an optimal band).', '耐受范围：过多与过少皆害（适宜之带）。'),
  [('closing-needs-net-draw', 'Its margin below is the lower side of the band.', '其下侧余地是带之下侧。')],
  ['mojing-sun-er-bu-hai']),
 ('regulation-from-one-side-and-locally', S2, ['Regulation', 'Continuation'],
  ('Regulation from one side, beyond the gap, and locally', '单侧、越界与局部之调节'),
  ('With balance, a level below m with no exchange raising it there never returns to m; overcorrecting never rests at m; formations each opposing on their own condition regulate it, and a family so regulated settles in total with nothing reading the total.',
   '平衡之下，m 之下无交换举之者不回到 m；矫枉过正者永不止于 m；各形成在其条件上相反即调节之，如此调节之族其总量定，无一形成读总量。'),
  [('With balance from T, the joint exchange giving no more than it takes wherever the level is below m, a level below m at T is at most that level after and never returns to m; gated renewal, nothing given below m, is its case.',
    '自 T 起衡，水平在 m 之下处联合交换所给不多于所取，则 T 时在 m 之下之水平此后至多为该水平，永不回到 m；门控之更新（m 之下无所给）为其情形。',
    ['Flow.held_below', 'Flow.never_returns_below', 'Flow.given_zero_below']),
   ('With balance, a joint exchange beyond the gap to m leaves the next level off m, so beyond it at every step from T the level is off m at every later step.',
    '平衡之下，联合交换越出与 m 之距，则下一水平不为 m；自 T 起每步越出者此后每步皆不为 m。', ['Flow.not_at_of_beyond', 'Flow.never_at_of_beyond']),
   ('Each formation weakly opposing departure from m on its condition, some strictly on each side, makes the joint exchange oppose; shares of the gap bounding each formation\'s departure, totalling at most the gap, keep the joint exchange within it.',
    '各形成在其条件上弱相反、两侧皆有其一严格相反，则联合交换相反；以份额为界、份额之和不过间距，则联合交换在界内。',
    ['Flow.total_lt_of_le_of_mem', 'Flow.opposes_of_each', 'Flow.withinGap_of_shares']),
   ('Under balance, each condition of a family within the gap to its own level and opposing at every step from T, the family\'s stock is the total of those levels from the step by which each has settled; no formation reads the stock.',
    '平衡之下，族之每一条件自 T 起每步在其水平之间距内且相反，则自各已定之步起族之存量为诸水平之和；无一形成读存量。', ['Flow.stock_settles'])],
  ('No axiom; balance at the conditions; the per-formation and per-condition premises as stated; whole-number levels.', '不加公理；条件上衡；各形成与各条件之前提如所述；整数之水平。'),
  [('That actual formations read only their own conditions.', '实际之形成只读其自身之条件。', 'non-implication'),
   ('Rest at m from one side only, under exchanges reading the whole: not stated.', '读整体之交换下仅自一侧之定：未述。', 'scope')],
  ('Decentralized control: local feedback loops whose sum regulates the aggregate; one-sided (ratchet) control.', '分散控制：其和调节总量之局部反馈；单侧（棘轮式）控制。'),
  [('two-sided-regulation-and-late-reading', 'Its two-sided law (withinGap_iff_between, settles) is used and read locally.', '用其两侧之律（withinGap_iff_between、settles）并局部读之。'),
   ('the-rest-outruns-the-renewal', 'Its gated stays_below is now the case of never_returns_below.', '其门控之 stays_below 今为 never_returns_below 之情形。')],
  ['cy-xiaoguo-jiaowang-guozheng', 'lao-37-zhen-zhi', 'lao-29-qu-shen-qu-tai', 'lao-57-fa-ling-zi-zhang']),
 ('repeated-disturbance', S2, ['Frequency'],
  ('Repeated disturbance', '反复扰动'),
  ('With the part giving gaps at most E at the steps a schedule marks, the carried amount is at most (D + E d) times (1 + M) to the a, d the disturbed steps and a the coupling steps; each disturbance adds what the later couplings multiply.',
   '部分在时程所标之步给出至多 E 之差时，携带量至多 (D + E·d)·(1 + M)^a，d 为扰动步数，a 为耦合步数；每次扰动所加者为其后之耦合所倍。'),
  [('A formation\'s gift with the part\'s gaps is its gift with none and the part\'s gap; a disturbance of E at a marked step adds E to E times the count.',
    '含部分之差之所给为无差之所给加部分之差；所标之步之扰动 E 使 E 乘计数增 E。', ['carriedGive_with_gaps', 'count_step', 'one_le_pow_add']),
   ('With starting gaps at most D, strengths into each condition at most M and none at unmarked steps, part gaps at most E at disturbed steps and none else, the carried amount is at most (D + E d)(1 + M)^a; with no disturbance it is the rate D (1 + M)^a.',
    '起始之差至多 D、入每一条件之强度至多 M 且未标之步为零、部分之差在扰动之步至多 E 余步为零，则携带量至多 (D + E·d)(1 + M)^a；无扰动时即速率 D(1 + M)^a。',
    ['carried_le_disturbed', 'carried_le_count'])],
  ('No axiom; whole-number amounts and strengths; the schedules of coupling and disturbance given.', '不加公理；整数之量与强度；耦合与扰动之时程给定。'),
  [('That the bound is attained with disturbance (attainment is shown without it).', '有扰动时此界可达（无扰动时之可达已证）。', 'scope'),
   ('That governing disturbs at a given rate.', '治理以给定之频率扰动。', 'non-implication')],
  ('Forced linear systems: the response to repeated impulses sums each impulse\'s propagated effect.', '受迫线性系统：对反复冲击之响应为各冲击传播之效之和。'),
  [('how-often-couplings-act', 'Its rate is the case of no disturbance.', '其速率为无扰动之情形。')],
  ['lao-60-peng-xiao-xian']),
 ('tolerance-monotone-across-laws', S1, ['Tolerance'],
  ('Tolerance monotone across laws', '容忍之跨律单调'),
  ('For the same waits and the same start, a formation giving under a tolerating law gives under every law tolerating at least as much, at every step: a law keeping inclusion into another keeps it along their courses.',
   '同一等待结构与同一起点，容忍律下给予之形成，在容忍不少之每一律下每步皆给予：保持包含入另一律者沿其行程保持之。'),
  [('One law keeps inclusion into another where, from configurations within others, it gives only where the other does; it then keeps it along their courses, keeping inclusion its case.',
    '一律保持包含入另一律，恰当自包含于他者之构形它只在另一律给予之处给予；则沿其行程保持之，保持包含为其情形。',
    ['Tolerance.KeepsInclusionInto', 'Tolerance.KeepsInclusionInto.course']),
   ('The tolerating law keeps inclusion into the tolerating law of tolerances no smaller, so more tolerance gives no less at every step.',
    '容忍律保持包含入容忍不小之容忍律，所以更大之容忍每步给予不少。', ['Tolerance.tolerating_into', 'Tolerance.tolerating_mono'])],
  ('No axiom; tolerances and waits given; any start.', '不加公理；容忍与等待给定；任一起点。'),
  [('That more tolerance is better: only that it gives no less.', '更大之容忍更好：只说给予不少。', 'non-implication')],
  ('Monotone threshold dynamics (lower thresholds activate supersets).', '单调阈值动力学（较低阈值激活超集）。'),
  [('thresholds-of-waiting', 'Its KeepsInclusion.course is the case of one law.', '其 KeepsInclusion.course 为一律之情形。')],
  ['lao-36-78-rou-sheng-gang']),
 ('rivals-bounded-in-time', S1, ['Significance'],
  ('Rivals bounded in time', '以时为界之对手'),
  ('A rule holding exactly within a region accepts the continuation condition\'s rule there and is not it where something lies outside; a rule bounded in time is such a rival, and in the clearer\'s witness it permits what the condition counts as a loss.',
   '恰在一域内成立之规则在其中接受条件之规则，域外有物则非之；以时为界之规则即此对手，在清除者之见证中它许可条件所计之失。'),
  [('A rule holding exactly within a region of standpoints, steps and formations is a rival wherever something lies outside it; the bounded significance is its case.',
    '恰在立场、步与形成之一域内成立之规则，域外有物处即为对手；有界之意义为其情形。', ['rival_of_outside']),
   ('A significance bounded in time accepts the rule within its bound and is not the continuation condition.',
    '以时为界之意义在其界内接受规则，而非延续之条件。', ['boundedInTime', 'bounded_in_time_rival']),
   ('In the clearer\'s witness every formation is admitted at the first two steps; under the significance bounded at the second step the levels with the clearer\'s part retain what has significance, under the continuation condition they do not.',
    '清除者之见证中前两步容一切形成；以第二步为界之意义下，有清除者部分之水平保留有意义者，延续之条件下则否。',
    ['Clearing.admits_early', 'Clearing.time_bounded_permits'])],
  ('No axiom; the continuation condition only as a hypothesis where stated.', '不加公理；延续之条件只在所述之处作为前提。'),
  [('Which significance holds: rivals are consistent with every law of the dynamics.', '何种意义成立：对手与动力之一切律相容。', 'non-implication')],
  ('Discounting and time-bounded horizons in welfare evaluation.', '福利评价中之贴现与有时界之视野。'),
  [('whole-first-and-bounded-centers', 'Its bounded_rival is the case of a region of standpoints and formations.', '其 bounded_rival 为立场与形成之域之情形。')],
  ['daqu-ai-shang-shi-hou-shi']),
 ('order-of-exchanges-sharing-a-relatum', S1, ['Interleavings'],
  ('Exchanges sharing a relatum need not commute', '共享关系项之交换不必可交换'),
  ('Two exchanges sharing their relatum, taken in two orders from one configuration, can reach different configurations: the condition of act_comm cannot be dropped.',
   '二交换共享其关系项，以两种次序自同一构形可到达不同构形：act_comm 之前提不可去。'),
  [('One relatum, two exchanges touching it, one adding one and one doubling: they share the relatum, and adding then doubling gives two while doubling then adding gives one.',
    '一个关系项，二交换皆触之，一加一，一倍之：二者共享关系项，先加后倍得二，先倍后加得一。',
    ['Interleavings.Shared.law', 'Interleavings.Shared.order_matters'])],
  ('No axiom; one constructed local law.', '不加公理；一个构造之局部律。'),
  [('Which actual exchanges share relata.', '实际之交换何者共享关系项。', 'non-implication')],
  ('Non-commuting operations; order dependence.', '不可交换之运算；次序依赖。'),
  [('the-step-index-from-own-courses', 'Its act_comm needs the exchanges apart.', '其 act_comm 需交换不相交。')],
  ['sunzi-qinfu-fa']),
 ('selection-right-exactly-where-read', S1, ['Learning'],
  ('Selection right exactly where what matters is read', '择恰在要紧者由象读出处为对'),
  ('What matters goes alike across a map\'s lumping exactly where it is read off the map, so some selection through the map selects exactly what matters exactly where the map reads it.',
   '要紧者跨象之归并一致，恰当它由象读出；所以经象之某择恰选出要紧者，恰在象读出它之处。'),
  [('What matters goes alike across the alternatives a map lumps together exactly where it is read off the map, through what holds of some alternative the map gives that entry.',
    '要紧者在象所归并之选项上一致，恰当它由象读出，经象给某一项之某选项所成立者。', ['Learning.through_iff_reads']),
   ('A selection through a map selecting exactly what matters exists exactly where what matters is read off the map.',
    '经象而恰选出要紧者之择存在，恰当要紧者由象读出。', ['Learning.selects_right_iff'])],
  ('No axiom; any types of alternatives and entries.', '不加公理；选项与项之任意类型。'),
  [('Which map a selector uses.', '择者用何象。', 'non-implication')],
  ('Measurability: a function factors through a map exactly where it is constant on its fibres.', '可测性：一函数经一映射分解恰当它在其纤维上为常值。'),
  [('selection-through-a-model-of-the-options', 'Its necessary and sufficient directions are joined.', '合其必要与充分两向。')],
  ['suzhe-22-xun-li']),
 ('basins-of-a-determined-law', S3, ['Attraction'],
  ('Basins of a determined law', '确定之律之势'),
  ('Under any determined law, courses meeting is an equivalence whose classes are basins; a course reaches every returning configuration of its basin, so within finitely many configurations each basin holds one cycle, entered before as many steps as there are configurations.',
   '任一确定之律下，行程相会是等价关系，其类为势；行程达其势中每一复返之构形，故构形有限时每势一个回环，在构形数之内入之。'),
  [('Within m listed configurations every course enters what returns before step m.',
    '列出 m 个构形时，每一行程在第 m 步之前入复返之域。', ['Law.enters_returning_within']),
   ('The courses of two configurations meet where at some steps they are at one configuration; after meeting they run together, and meeting is reflexive, symmetric and transitive under any determined law.',
    '二构形之行程于某步同处一构形即相会；相会后同行，任一确定之律下相会自反、对称、传递。',
    ['Law.Meet', 'Law.Meet.refl', 'Law.Meet.symm', 'Law.Meet.later', 'Law.Meet.trans']),
   ('A course reaches every returning configuration of its basin; within finitely many configurations each basin holds one cycle.',
    '行程达其势中每一复返之构形；构形有限时每势一个回环。', ['Law.Meet.reaches_returning', 'Law.basin_one_cycle'])],
  ('No axiom; a determined law; finitely many configurations listed where stated.', '不加公理；确定之律；所述之处构形有限且列出。'),
  [('How many basins an actual law has.', '实际之律有几势。', 'non-implication')],
  ('Basins of attraction of a finite map: its functional graph splits into components, each with one cycle.', '有限映射之吸引域：其函数图分为诸分支，每支一个回环。'),
  [('attraction-is-not-returning', 'Its enters_returning is derived from the bound within the count.', '其 enters_returning 由构形数内之界导出。')],
  ['xugua-jin-bi-you-suo-gui', 'xici-tong-gui-shu-tu']),
 ('a-whole-carried-by-lasting-parts', S3, ['Wholes'],
  ('A whole carried by lasting parts', '持续之部分承整体'),
  ('Where from T on a part arises within every d steps and each arising part lasts d steps, the whole is active at every step from T + d on: the converse of a whole\'s needing its parts\' arising, which needs the parts to last.',
   '自 T 起每 d 步内有部分生起、且每一生起之部分持续 d 步，则整体自 T + d 起每步活跃：整体需部分生起之逆，须部分持续。'),
  [('A part arising within every d consecutive steps from T, each lasting d steps after arising, the whole of some part is active at the step d after every step from T on, so at every step from T + d on.',
    '自 T 起每 d 个相继之步内有部分生起、生起后各持续 d 步，则某部分之整体在自 T 起每步之后第 d 步活跃，故自 T + d 起每步活跃。',
    ['Web.Whole.persists_of_arising', 'Web.Whole.persists_from'])],
  ('No axiom; the parts\' arising and lasting as stated; discrete steps.', '不加公理；部分之生起与持续如所述；离散步。'),
  [('That actual parts last until the next arises.', '实际之部分持续至下一生起。', 'non-implication')],
  ('Covering a timeline by intervals: renewal processes with overlapping lifetimes.', '以区间覆盖时间线：寿命重叠之更新过程。'),
  [('whole-persists-through-generation', 'The converse of its Whole.arises_within; its Gaps shows lasting needed.', 'Whole.arises_within 之逆；其 Gaps 显示须持续。')],
  ['zhongyong-bu-xi-ze-jiu']),
 ('dormancy-over-a-stretch', S3, ['Reserve'],
  ('Dormancy over a stretch, and final ending', '一段上之休眠与终局之终结'),
  ('Bounded dormancy needs its premises only over the stretch; an ending that is final stays whatever support returns, so a return later than the reserve finds none, while a reserve spanning the gap bridges it.',
   '有界休眠只需其前提在一段上成立；终局之终结无论支持是否回来皆持续，所以迟于储备之复足无所得，而跨过此段之储备可以架之。'),
  [('Carried, decaying and unsupported across the n steps from S, a reserve has fallen by n or been spent; with a reserve at most n, the formation is inactive at S + n with its reserve spent. The from-S laws are their cases.',
    '自 S 起 n 步皆承载、衰减且无支持，储备降 n 或耗尽；储备至多 n 时，形成在 S + n 不活跃且储备耗尽；自 S 起之律为其情形。',
    ['Web.decays_by_on', 'Web.ends_within_on']),
   ('Where from U on a formation inactive with its reserve spent neither arises nor regains reserve, one inactive and spent at U is inactive at every later step; so support returning after the reserve is spent finds no dependent.',
    '自 U 起不活跃且储备耗尽之形成既不生起亦不复其储备，则 U 时如此者此后每步不活跃；所以储备耗尽之后之复足无依存者。',
    ['Web.ended_for_good', 'Web.late_return_finds_none']),
   ('Unsupported at the first three steps with a reserve of three, a formation is active at every step: the reserve bridges the gap.',
    '前三步无支持而储备为三之形成每步活跃：储备跨过此段。',
    ['Bridged.standing', 'Bridged.reserve', 'Bridged.web', 'Bridged.bridged'])],
  ('No axiom; reserve, decay and finality as stated; discrete steps.', '不加公理；储备、衰减与终局如所述；离散步。'),
  [('That ending is final for actual dependents.', '实际依存者之终结为终局。', 'non-implication')],
  ('Seed viability and dormancy; hysteresis of collapse.', '种子活力与休眠；崩溃之滞后。'),
  [('reserve-defers-ending', 'Its from-S laws are the stretch laws\' cases.', '其自 S 起之律为一段之律之情形。')],
  ['wangbi-fu-bu-su', 'mengzi-yi-ri-pu-zhi']),
 ('arising-needs-change', S3, ['Admission'],
  ('Arising needs change', '生起需变'),
  ('A formation active exactly where it is supported does not arise across a step at which its requirements do not grow and its needs and every level stay: what does not change gives no arising.',
   '恰在受支持时活跃之形成，跨一步若其所需不增、需要之量与各水平皆不变，则不生起：不变者无生起。'),
  [('A formation active exactly where supported at a step and the next, its requirements not growing, needs and levels the same across the step, does not arise across it.',
    '在一步与下一步恰在受支持时活跃之形成，所需不增、需要之量与水平跨步皆同，则不跨此步生起。', ['Web.not_arises_of_unchanged'])],
  ('No axiom; activity exactly where supported at the two steps.', '不加公理；在两步上恰在受支持时活跃。'),
  [('Arising where activity is not read off support.', '活动不由支持读出时之生起。', 'scope')],
  ('No cause, no change: a state function of unchanged inputs does not change.', '无因则无变：输入不变之状态函数不变。'),
  [('support-from-the-supported', 'Support changes only through relations; this is its arising form.', '支持只经关系而变；此为其生起之形。')],
  ['weishi-sha-na-mie']),
 ('need-drift-along-a-lineage', S3, ['Evolution'],
  ('Need drift along a lineage', '世系上之需要漂移'),
  ('Along a lineage each member depending on c with its need not rising until it gives, transmission within δ keeps the need after i + 1 descents within the founder\'s need, or the level where the founder was supported, plus (i + 1) δ.',
   '世系每员依 c 且所需在其给予前不升时，在 δ 内之传使 i + 1 代后之所需至多为始祖所需（或始祖受支持处之水平）加 (i + 1)·δ。'),
  [('With the dependence transmitted within δ, each member descending, depending on c at its first standing step, and its need not rising until it gives in turn, the need after i + 1 descents is at most the founder\'s plus (i + 1) δ, or the level where the founder was supported plus (i + 1) δ.',
    '依赖在 δ 内传递，每员出生、首立之步依 c、所需至其给予时不升，则 i + 1 代后之所需至多为始祖所需加 (i + 1)·δ，或始祖受支持处之水平加 (i + 1)·δ。',
    ['Flow.transmitted_along', 'Flow.transmitted_along_supported'])],
  ('No axiom; descents as given; whole-number needs.', '不加公理；出生如所给；整数之需要。'),
  [('That actual inheritance drifts by at most a fixed δ.', '实际之遗传漂移至多一固定 δ。', 'non-implication')],
  ('Bounded mutation accumulating along a lineage.', '沿世系累积之有界变异。'),
  [('transmission-is-inheritance-and-need', 'Its one-step law is applied along a lineage.', '其一步之律沿世系应用。')],
  ['lunyu-yin-sun-yi']),
]
cited = set()
recs = []
for rid, sec, mods, title, stmt, laws, hyp, dns, corr, deps, entries in SPEC:
    for en, zh, _ in laws:
        assert len(en) <= 420 and len(zh) <= 190, (rid, en[:40], len(en), len(zh))
    assert len(stmt[0]) <= 300 and len(stmt[1]) <= 150, (rid, len(stmt[0]), len(stmt[1]))
    decls = [d for _, _, names in laws for d in R(names)]
    cited |= set(decls)
    srcs = [f'{PKG}/Becoming/{m}.lean' for m in mods]
    n_new = sum(1 for d in decls if d in new)
    rec = {
        'schema_version': 2, 'id': rid, 'title': {'en': title[0], 'zh': title[1]},
        'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
        'statement': {'en': stmt[0], 'zh': stmt[1]},
        'laws': [{'en': en, 'zh': zh, 'declarations': R(names)} for en, zh, names in laws],
        'hypotheses': [{'en': hyp[0], 'zh': hyp[1]}],
        'does_not_show': [{'en': en, 'zh': zh, 'kind': k} for en, zh, k in dns],
        'counterexamples': [], 'standard_boundaries': BOUNDS,
        'validation_scope': {
            'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the {n_new} declarations cited '
                  f'here that the modules gained have empty axiom reports; the checker verifies core purity. Built and reviewed '
                  f'in one session; author review in study section {sec}; not independently reviewed by a person.',
            'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：本记录所引之新增 {n_new} 项声明公理报告为空；检查器并核对核心纯净。'
                  f'在一个会话中构建并审查；作者审查见研究第 {sec} 节；未经人的独立审查。'},
        'next_delta': {'en': 'An independent review.', 'zh': '独立审查。'},
        'correspondence': {'en': corr[0], 'zh': corr[1]},
        'canonical_source': srcs[0],
        'aliases': [title[0], title[1]] + R([laws[0][2][0]]),
        'dependencies': [{'id': i, 'relation': 'formal-reuse', 'detail': {'en': en, 'zh': zh}} for i, en, zh in deps],
        'related': [{'id': 'civilization-thought-on-the-spine', 'detail': {
            'en': 'States a gap its map found (entries ' + ', '.join(entries) + ').',
            'zh': '陈述其对应所发现之缺口（条目 ' + '、'.join(entries) + '）。'}}],
        'references': [{'path': s, 'role': 'proof', 'declarations': sorted(d for d in decls if full[d] == s.split('/')[-1][:-5]),
                        'sha256': sha(s)} for s in srcs]
        + [{'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
           {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
           {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
           {'path': ZHMAP, 'role': 'integration', 'sha256': sha(ZHMAP)},
           {'path': MAPCH, 'role': 'statement', 'sha256': sha(MAPCH)},
           {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)}],
        'proof_bindings': [{'source': s, 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{s.split("/")[-1][:-5]}',
                            'success_pointer': '/status', 'success_value': 'passed'} for s in srcs],
        'history': [{'en': f'22 October 2026: added (ZG), for the gap the ZH reading raised; study section {sec}.',
                     'zh': f'2026年10月22日：新增（ZG），补中华思想脉络之读所提出的缺口；研究第 {sec} 节。'}],
    }
    assert not (RECORDS / f'{rid}.json').exists(), rid
    recs.append(rec)
missing = new - cited
assert not missing, sorted(missing)
for rec in recs:
    (RECORDS / f'{rec["id"]}.json').write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
    print('written', rec['id'])
d = json.loads((RECORDS / 'civilization-thought-on-the-spine.json').read_text())
for lang, old_ in (('en', 'one-sided and local regulation; equal division; copying growth; '), ('zh', '单侧与局部的调节；均分；抄录之增；')):
    assert d['next_delta'][lang].count(old_) == 1, lang
    d['next_delta'][lang] = d['next_delta'][lang].replace(old_, '')
d['related'] += [{'id': rec['id'], 'detail': {'en': 'States gaps its map found (ZG).', 'zh': '陈述其对应所发现之缺口（ZG）。'}} for rec in recs]
d['history'].append({
    'en': f'22 October 2026, ZG1-ZG3: 25 entries\' gaps are stated (sixteen records; study sections {S1}-{S3}), their readings '
          'revised and gap notes pointing to the laws; one-sided and local regulation, equal division and copying growth leave '
          'the gap list. The map\'s kinds and counts are unchanged.',
    'zh': f'2026年10月22日，ZG1-ZG3：25 个条目之缺口已陈述（十六项记录；研究第 {S1}-{S3} 节），其读法修订，gap 注指向新律；单侧与局部的调节、'
          '均分、抄录之增离开缺口之列。对应之类别与计数不变。'})
(RECORDS / 'civilization-thought-on-the-spine.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('noted civilization-thought-on-the-spine; cited', len(cited), 'new', len(new))
