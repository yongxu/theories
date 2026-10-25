#!/usr/bin/env python3
"""UE1b record: write what-a-set-point-optimum-does-beyond, citing every declaration of Becoming.SetPointOptimum.

Mirrors UE1's make_records_ue1.py. It asserts that the receipt passed and binds the module and Becoming/Optimum.lean
at the kit's bytes, with empty axiom reports; that the laws cite every declaration of the module exactly once; that
the three general laws of the exchange are in Optimum; that the home section and the records it links exist; that its
aliases are free; and that the record does not exist yet. The record claims the class of nearing orders, the optima at
the set point, the term counted after (in total only), the drain below the set point, the draw identity, and joint
excess for holders with no choice in that law. It does not claim that active-inference preferences are nearing, that a
set point protects what lies beyond, the quantilizer bound, or anything over a horizon or under noise. Its texts keep
the record lint's hard caps (tools/research/style.py).

usage (from the checkout root of the landing worktree, after texts_ue1b.py):
  python3 -B <kit>/make_records_ue1b.py RECEIPT N"""
import datetime
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
RECEIPT_ID, N = sys.argv[1], int(sys.argv[2])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RF + 'BECOMING-RENEWAL-READING.md'
KIT = RF + 'development/ue1b-set-points/'
NOTE = KIT + 'NOTE.md'
REVIEW = KIT + 'REVIEW-UE1b.md'
CH5 = 'theories/becoming/chapters/05-COLLECTIVES.md'
MOD = f'{PKG}/Becoming/SetPointOptimum.lean'
OPT = f'{PKG}/Becoming/Optimum.lean'
REG = f'{PKG}/Becoming/Regulation.lean'
PROP = f'{PKG}/Becoming/Propagation.lean'
DRAWN = f'{PKG}/Becoming/DrawnBeyond.lean'
CONT = f'{PKG}/Becoming/Continuation.lean'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
RID = 'what-a-set-point-optimum-does-beyond'
KIT_MODULE = '22b6140d3a4cc2631a1f125b3a39395f8140d264431ed0ef3d145864a204253a'
KIT_OPTIMUM = '6b8c4e2024cf6f5d8b1ffc1dd5cf8849f032e2bc118c23ed76c4f20f9eaeb6dc'
GENERAL = ['Becoming.Optimum.Above.floor_or_full_of_ranked', 'Becoming.Optimum.Above.full_of_ranked',
           'Becoming.Optimum.beyond_of_ranked']
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
DAY = datetime.datetime.strptime(RECEIPT_ID[:8], '%Y%m%d')
DATE_EN = f'{DAY.day} {DAY.strftime("%B")} {DAY.year}'
DATE_ZH = f'{DAY.year}年{DAY.month}月{DAY.day}日'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
assert core['source_sha256']['Becoming.SetPointOptimum'] == sha(MOD) == KIT_MODULE, 'SetPointOptimum is not the re-checked kit'
assert core['source_sha256']['Becoming.Optimum'] == sha(OPT) == KIT_OPTIMUM, 'Optimum is not the kit refactor'
mod = next(m for m in core['modules'] if m['module'] == 'Becoming.SetPointOptimum')
assert not any(mod['axiom_dependencies'].values())
names = {d['name'] for d in mod['declarations']}
assert len(names) == 124 and mod['theorems'] == 82, (len(names), mod['theorems'])
opt = next(m for m in core['modules'] if m['module'] == 'Becoming.Optimum')
assert not any(opt['axiom_dependencies'].values())
assert set(GENERAL) <= {d['name'] for d in opt['declarations']}


def D(*short):
    out = ['Becoming.' + s for s in short]
    missing = [n for n in out if n not in names]
    assert not missing, missing
    return out


groups = [
    # the class
    ("One outcome is nearer a family's set point than another where at each condition of the family it lies "
     "between the set point and the other (Regulation.Between: on the other's side, no farther) and at one it is "
     "strictly nearer, whatever either holds beyond; an order is nearing where it ranks above every nearer outcome: "
     "strictly single-peaked at the set point at each condition, each peak independent. Near-definitional.",
     '一结果较另一结果更近族之设定点，当且仅当在族的每个条件上它居于设定点与另一结果之间（Regulation.Between：在另一结果'
     '一侧且不更远），且在某一条件上严格更近，不论二者在别处如何；一个序为趋近的，当它把每个更近的结果排得更高，故在每个'
     '条件上于设定点严格单峰，各峰互不依赖。近乎定义。',
     D('Optimum.gapTo', 'Optimum.Nearer', 'Optimum.Nearing', 'Optimum.AtSetPoint', 'Optimum.UpToSetPoint',
       'Optimum.setPoint_between', 'Optimum.Nearer.gaps')),
    ("An order falling with the distance from the set point at each condition of the family, both sides alike, is "
     "nearing, the order by the family's total gap among them; every order ranking above wherever a nearing order does "
     "is nearing. At the set point the gap and the family's total gap are nothing, and a family of one condition is at "
     "its set point where that condition is.",
     '在族的每个条件上随与设定点之距离下降、两侧同等的序是趋近的，族的总差之序即其一；凡在一个趋近之序排得更高处都排得更高的'
     '序也是趋近的。在设定点，差与族的总差皆为零；只含一个条件的族，在该条件处于设定点时即处于设定点。',
     D('Optimum.byGap', 'Optimum.nearing_of_gaps', 'Optimum.byGap_nearing', 'Optimum.Nearing.mono',
       'Optimum.gapTo_eq_zero', 'Optimum.total_gapTo_eq_zero', 'Optimum.atSetPoint_single')),
    ("Where the family holds a condition, no nearing order that never ranks two outcomes above each other is rising: an "
     "outcome at the set point is nearer it than every outcome off it at a condition of the family, so the set point "
     "and the outcome one above it everywhere would each rank above the other.",
     '族含一个条件时，从不把两个结果互排在上的趋近之序都不是升高的：在设定点的结果比在族的某条件上偏离设定点的每个结果更近，'
     '故设定点与处处高一单位的结果将互排在上。',
     D('Optimum.nearer_of_atSetPoint', 'Optimum.Nearing.not_rising')),
    ("Where the family holds a condition, an order under which some outcome is ranked below none is not rising, the "
     "outcome one higher everywhere exceeding it on the family. Under the order by distance no outcome ranks above one "
     "at the set point, and an eligible outcome at the set point is an optimum; neither it nor the order with the "
     "beyond counted after, which never ranks two outcomes above each other, is rising.",
     '族含一个条件时，某结果不被任何结果排在其上的序不是升高的，处处高一单位的结果在族上超过它。距离之序下无结果排在设定点上'
     '的结果之上，设定点上的可选结果即为最优；距离之序与之外计于其后的距离之序（从不把两个结果互排在上）都不是升高的。',
     D('Optimum.not_rising_of_unbeaten', 'Optimum.byGap_unbeaten_at', 'Optimum.atSetPoint_frontier',
       'Optimum.byGap_not_rising', 'Optimum.byGapThen_asymm', 'Optimum.byGapThen_not_rising')),
    # at the set point
    ("Every order nearing a set point has its optima at the set point exactly where no eligible outcome off it at a "
     "condition of the family is unbeaten by an eligible outcome nearer it; so where some eligible outcome stands at "
     "the set point, every optimum of every nearing order does, whatever the room.",
     '每个趋近设定点之序的最优都在设定点，当且仅当在族的某条件上偏离设定点的每个可选结果都并非不被更近的可选结果胜过；故某'
     '可选结果立于设定点时，每个趋近之序的每个最优都立于其上，不论余地。',
     D('Optimum.atSetPoint_iff', 'Optimum.atSetPoint_of_reach')),
    ("Where the levels are, for each of several optimizers, an optimum among the outcomes eligible to it of an order "
     "nearing the set point on its family, one of those outcomes standing at the set point, the levels stand at the "
     "set point on every family the optimizers' families cover.",
     '对多个优化者中的每一个，水平都是其可选结果中趋近其族上设定点之序的最优、且其中一个结果立于设定点时，水平在诸优化者之族'
     '所覆盖的每个族上立于设定点。',
     D('Optimum.mutual_atSetPoint')),
    ("Where an eligible outcome stands at the set point, an outcome is an optimum of some nearing order exactly where "
     "it is eligible and at the set point (near-definitional), and every optimum of every nearing order stands beyond "
     "at the least level among the eligible outcomes at the set point exactly where those all stand alike beyond: the "
     "class asks nothing of what lies beyond.",
     '某可选结果立于设定点时，一结果为某个趋近之序的最优，当且仅当它可选且在设定点（近乎定义）；每个趋近之序的每个最优在之外'
     '立于设定点上可选结果中的最低水平，当且仅当这些结果在之外都相同：此类序对之外别无所求。',
     D('Optimum.optima_iff', 'Optimum.least_at_iff')),
    # counted after
    ("The order by distance with the beyond counted after (nearer first, then more beyond in total) is nearing; where "
     "an eligible outcome stands at the set point, every optimum of it stands there and leaves the beyond, in total, at "
     "least where every eligible outcome at the set point does (near-definitional), and with one condition beyond "
     "meets a need there exactly where some such outcome does.",
     '之外计于其后的距离之序（先较近者，再之外总量较多者）是趋近的；某可选结果立于设定点时，其每个最优都立于设定点，且使之外'
     '的总量至少如设定点上每个可选结果所留（近乎定义）；之外只有一个条件时，恰当设定点上某个可选结果满足该处的一个需要时满足之。',
     D('Optimum.byGapThen', 'Optimum.byGapThen_nearing', 'Optimum.counted_after_most',
       'Optimum.counted_after_keeps_iff')),
    ("The order by distance with less beyond counted after (nearer first, then less beyond in total) is nearing.",
     '之外较少者计于其后的距离之序（先较近者，再之外总量较少者）是趋近的。',
     D('Optimum.byGapLess', 'Optimum.byGapLess_nearing')),
    # below the set point
    ("Up to the set point the gap at a condition is what it falls short, so one outcome is nearer than another exactly "
     "where it exceeds the other on the family, and there a nearing order ranks above every exceeding outcome. Within a "
     "bound, one shortfall is at most, or less than, another exactly where its amount is at least, or greater than, "
     "the other's.",
     '设定点之下，某条件上的差即其缺额，故一结果较另一结果更近，当且仅当它在族上超过另一结果，在那里趋近之序把每个超过者排得'
     '更高。在一界之内，一缺额至多于或小于另一缺额，当且仅当其量至少或大于另一者之量。',
     D('Optimum.sub_le_sub_iff', 'Optimum.sub_lt_sub_iff', 'Optimum.gapTo_of_upTo', 'Optimum.nearer_iff_exceeds',
       'Optimum.Nearing.rises_below')),
    ("Among the eligible outcomes up to the set point, every nearing order has its optima at the least level beyond "
     "among them exactly where every such outcome standing above another at a condition beyond is not unbeaten on the "
     "family by one (Optimum.least_iff read up to the set point); with room among them, every optimum is there.",
     '在设定点之下的可选结果中，每个趋近之序的最优都在其中之外最低的水平，当且仅当其中每个在之外某条件上高于另一者的结果都'
     '并非在族上不被其中某个胜过（Optimum.least_iff 读于设定点之下）；其中有余地时，每个最优都在那里。',
     D('Optimum.least_below_iff', 'Optimum.least_below')),
    # the draw
    ("In a balanced flow, where the family with the conditions beyond gains nothing across a step and the family "
     "stands at its set point after it, the beyond after the step, with what the whole loses and the set point's "
     "total, is the family and the beyond before (from Flow.Balances.beyond_falls_exactly); with the set point held "
     "across the step, the beyond falls by the loss alone.",
     '在平衡的流中，族与之外的条件在一步中无所增益、族在步后立于其设定点时，步后之外加整体所失与设定点之总量，等于步前的族与'
     '之外（由 Flow.Balances.beyond_falls_exactly）；设定点在该步前后都保持时，之外只降低其损失。',
     D('Flow.Balances.atSetPoint_draws', 'Flow.Balances.held_draws_lost')),
    ("With each condition beyond depended on at a need it meets, some dependence breaks across such a step where the "
     "set point's total with the loss exceeds the family before with the slack; with one condition beyond, exactly "
     "there.",
     '之外每个条件被以其满足的需要依存时，设定点之总量加损失超过步前之族加余量处，该步打断某个依存；之外只有一个条件时，恰在'
     '该处。',
     D('Flow.Balances.atSetPoint_breaks', 'Flow.Balances.atSetPoint_broken_iff')),
    ("Every optimum of a nearing order whose set point an eligible outcome reaches draws so; several such optimizers, "
     "their families covering the family, draw their joint shortfall as one optimizer with their joint set point does, "
     "and break a dependence beyond where the joint set point's total with the loss exceeds the family before with the "
     "slack, whatever each one's own.",
     '设定点为某可选结果所达的趋近之序的每个最优都如此抽取；多个这样的优化者，其族覆盖该族，抽取其合计缺额，如以其共同设定点为'
     '设定点的一个优化者；共同设定点之总量加损失超过步前之族加余量处，打断之外的某个依存，不论各自如何。',
     D('Flow.nearing_optimum_draws', 'Flow.Balances.mutual_atSetPoint_draws', 'Flow.Balances.mutual_atSetPoint_breaks')),
    # the exchange
    ("One unit moved from a condition outside the family into one of the family below its set point gives a nearer "
     "outcome; so among the outcomes open to a part, every optimum of every nearing order standing below its set point "
     "at a condition of the family stands at each condition beyond where every rising optimum stands: at what the rest "
     "leaves less the part's whole capacity, or at nothing (from Optimum.beyond_of_ranked).",
     '把一单位自族外某条件移入族中低于设定点的条件，得到更近设定点的结果；故在部分可达的结果中，每个趋近之序的最优，若在族的某'
     '条件上低于设定点，则在之外每个条件上立于每个升高之序的最优所立之处：其余者所留减去部分的全部容量处，或为零'
     '（由 Optimum.beyond_of_ranked）。',
     D('Optimum.transfer_nearer', 'Optimum.nearing_beyond', 'Optimum.nearing_as_rising')),
    # holding and joint excess
    ("Where across a step the flow balances on a family, no other formation taking part exchanges with the family, and "
     "the family's stock after the step is its stock before, a formation taking part that gives the family and a "
     "condition, with a loss, at most what it takes from them takes from the condition at least what it gives there "
     "with the loss.",
     '一步中流在一族上平衡、无其他参与的构成与该族交换、该族步后存量等于步前存量时，一个参与的构成，若给族与某条件之量加一损失'
     '至多为其从二者所取，则从该条件所取至少为其在该处所给加该损失。',
     D('Flow.held_draws')),
    ("Over n steps, where each formation of a part alone keeps its family's stock, losing at least an amount there with a condition, their losses together exceeding what the rest gives the condition each step, from below n + m the gate at need m ends every dependent at need m or more from step n on, whatever each loss; none couples into it if its couplings lie in its family. From Flow.joint_excess_ends; no choice enters.",
     '在 n 步中，一部分的每个构成独自与其族交换而保持其族的存量，在其族与某条件上至少失去给定之量，其损失合计每步都超过其余者给该'
     '条件之量，该条件起于 n + m 之下，则需要 m 处的闸使以至少 m 的需要依存于它的每个构成自第 n 步起不再活动，不论每份损失多小；'
     '各自的耦合都在其族中而不含该条件时，无一耦合入它。由 Flow.joint_excess_ends；不入序或选择。',
     D('Flow.held_excess_ends')),
    ("A family at its set point at two steps holds its stock between them; over a list without repetition, a quantity "
     "that is nothing at every member but one totals at most its value at that one.",
     '族在两步都立于其设定点时，其间存量不变；在无重复的列上，除一成员外处处为零之量，其总量至多为其在该成员处之值。',
     D('Optimum.stock_eq_of_atSetPoint', 'Optimum.total_le_of_only')),
    # witnesses
    ("Witness on the splits of three units between a source and a store, a dweller needing two at the source, where "
     "room holds and every rising optimum empties the source: every optimum of every order nearing a store of k, k at "
     "most three, leaves the source at 3 - k, meeting the need exactly where k is at most one, the slack; at one the "
     "order by distance has such an optimum, and at two the source is left at one.",
     '见证，在源与库之间分三个单位，居住者在源处需要二，此处有余地，每个升高之序的最优都把源抽空：每个趋近库存 k（k 至多为三）'
     '之序的每个最优都使源为 3 - k，恰当 k 至多为一（即余量）时满足需要；k 为一时距离之序有这样的最优，k 为二时源留一。',
     D('Optimum.Drain.storedAt', 'Optimum.Drain.storedAt_split', 'Optimum.Drain.atSetPoint_source',
       'Optimum.Drain.kept_iff', 'Optimum.Drain.nearing_keeps', 'Optimum.Drain.nearing_breaks')),
    ("Among those splits, an aspiration level at a store of one with the source counted after leaves the source at "
     "two, as every order nearing a store of one does: the plateau of the first term lets the second decide.",
     '在这些分法中，库存为一的抱负水平、源计于其后，使源留二，与每个趋近库存一之序相同：第一项的平台让第二项作决定。',
     D('Optimum.Drain.satisficingThen', 'Optimum.Drain.satisficingThen_keeps')),
    ("Witness in an exchange from a store at its set point of one and two units at the source, a taker of capacity one "
     "there: every optimum of every order nearing a store of one stands at it; the step exchanging nothing and the "
     "step taking a unit of the source and losing it are both optima of the order by distance, leaving the source at "
     "the dweller's need of two and at one, while every rising optimum leaves one.",
     '见证，于一步交换中，库在其设定点一、源有二单位，取者在源处容量为一：每个趋近库存一之序的每个最优都立于其上；不交换的一步与'
     '取源一单位而失之的一步都是距离之序的最优，分别使源留在居住者的需要二与一，而每个升高之序的最优都使源留一。',
     D('Optimum.Topped.start', 'Optimum.Topped.one', 'Optimum.Topped.discarding', 'Optimum.Topped.drawnOne',
       'Optimum.Topped.Open', 'Optimum.Topped.idle_open', 'Optimum.Topped.discarding_open',
       'Optimum.Topped.nearing_either', 'Optimum.Topped.rising_drains')),
    ("There, with the source counted after the set point every optimum meets the need; with less source counted after, "
     "every optimum leaves it at most one; trading the source at any positive weight against the store's gap, every "
     "optimum meets the need; an order nearing a store of three, which no open outcome reaches (each leaves the store "
     "at most two), leaves the source at one, as a rising order does.",
     '在那里，源计于设定点之后，每个最优都满足需要；较少的源计于其后，每个最优都使源至多为一；对源以任一正权与库之差相权衡，每个'
     '最优都满足需要；趋近库存三之序（无可达结果达到之：每个都使库至多为二）使源留一，与升高之序相同。',
     D('Optimum.Topped.counted_after_keeps', 'Optimum.Topped.counted_less_drains', 'Optimum.Topped.weighted',
       'Optimum.Topped.weighted_keeps', 'Optimum.Topped.store_le_two', 'Optimum.Topped.out_of_reach')),
    ("Witness with one condition of the family at its set point of one and two conditions beyond: of two ways of "
     "reaching the set point, three and none beyond or one in each, every optimum of the order by distance with the "
     "beyond counted after empties the first condition beyond, though the even way keeps both.",
     '见证，族的一个条件在其设定点一、之外有两个条件：两种达到设定点的方式——之外为三与零，或各一——之中，之外计于其后的距离之序的'
     '每个最优都把之外第一个条件抽空，虽然均匀的方式两者都保留。',
     D('Optimum.Spread.Spot', 'Optimum.Spread.one', 'Optimum.Spread.lopsided', 'Optimum.Spread.even',
       'Optimum.Spread.Eligible', 'Optimum.Spread.counted_after_empties')),
    ("Witness that a nearing order need not weigh both sides alike: the order by a measure of deviation from two that "
     "counts each unit over three times and each unit under once, the smaller ranking above, is nearing, yet one unit "
     "over, nearer the set point than two under, ranks below.",
     '见证趋近之序不必两侧同等：以偏离二之量为序，超出每单位计三、不足每单位计一，较小者排得更高，此序是趋近的；而超出一单位比'
     '不足二单位更近设定点，却排得更低。',
     D('Optimum.Skew.cost', 'Optimum.Skew.order', 'Optimum.Skew.two', 'Optimum.Skew.nearing',
       'Optimum.Skew.not_by_gaps')),
    ("Witness of the joint draw: from a source of three of which a dweller needs two, each of two takers takes one "
     "unit into a store of its own; each step stands at its taker's set point of one and is an optimum of its order by "
     "distance among the outcomes eligible to it; each taker's own shortfall is within the slack of one, yet the "
     "dweller's dependence on the source is broken (from Flow.Balances.mutual_atSetPoint_breaks).",
     '联合抽取的见证：源有三，居住者需要二，两个取者各取一单位入其自己的库；每一步都立于其取者的设定点一，并且在其可选结果中为其'
     '距离之序的最优；每个取者自己的缺额都在余量一之内，而居住者对源的依存被打断（由 Flow.Balances.mutual_atSetPoint_breaks）。',
     D('Optimum.TwoStores.Place', 'Optimum.TwoStores.flow', 'Optimum.TwoStores.level', 'Optimum.TwoStores.web',
       'Optimum.TwoStores.one', 'Optimum.TwoStores.family', 'Optimum.TwoStores.Eligible', 'Optimum.TwoStores.balances',
       'Optimum.TwoStores.gainless', 'Optimum.TwoStores.best', 'Optimum.TwoStores.jointly_broken')),
    ("Witness of joint excess for holders: a renewer gives a pool one unit at each of two steps; two formations each "
     "hold a store at its set point of one by taking from the pool the unit they lose, each within what the step gives "
     "the pool while together they take two; from a pool of two the renewer, depending on it at need one, is inactive "
     "after two steps, and neither holder couples into the pool.",
     '持水平者之联合超额的见证：更新者在两步中每步给池一单位；两个构成各从池取其所失的一单位，使其库保持在设定点一，各自都在该步'
     '给池之量以内，而两者共取二；池自二起，依存于池（需要一）的更新者两步后不再活动，且两个持水平者都不耦合入池。',
     D('Optimum.HeldPair.Member', 'Optimum.HeldPair.Spot', 'Optimum.HeldPair.holders', 'Optimum.HeldPair.store',
       'Optimum.HeldPair.present', 'Optimum.HeldPair.flow', 'Optimum.HeldPair.poolLevel', 'Optimum.HeldPair.level',
       'Optimum.HeldPair.web', 'Optimum.HeldPair.observes', 'Optimum.HeldPair.one', 'Optimum.HeldPair.balances',
       'Optimum.HeldPair.acting', 'Optimum.HeldPair.dependent', 'Optimum.HeldPair.gated',
       'Optimum.HeldPair.members_distinct', 'Optimum.HeldPair.distinct', 'Optimum.HeldPair.alone',
       'Optimum.HeldPair.held', 'Optimum.HeldPair.loses', 'Optimum.HeldPair.exceeds', 'Optimum.HeldPair.listed',
       'Optimum.HeldPair.apart', 'Optimum.HeldPair.within', 'Optimum.HeldPair.held_end')),
]
cited = [n for _, _, ds in groups for n in ds]
assert len(cited) == len(set(cited))
assert set(cited) == names, sorted(names - set(cited))

M = 'Becoming.Optimum.'
record = {
    'schema_version': 2,
    'id': RID,
    'title': {'en': 'What a set-point optimum does beyond what couples in',
              'zh': '设定点最优对耦合入者之外做什么'},
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F04',
    'reviewed_at_utc': NOW,
    'statement': {
        'en': 'Where an eligible outcome reaches its set point, every optimum of a nearing order stands there, the '
              'class asking nothing more of what lies beyond; below it the order rises and drains; the draw at it is '
              'the shortfall with the loss; holders losing together more than a condition is given end it.',
        'zh': '某可选结果达到设定点时，趋近之序的每个最优都立于其上，此类序对之外别无所求；设定点之下，此序升高而抽取；设定点处所抽'
              '为其缺额加损失；持其水平者合计所失多于条件所得时，终结该条件。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': ds} for en, zh, ds in groups],
    'hypotheses': [
        {'en': "No axiom and no premise beyond each law's own. Any outcomes (level functions after a step, amounts "
               "natural numbers) and orders; which outcomes are eligible, whether one reaches the set point, and room up "
               "to it are supplied wherever they enter.",
         'zh': '不加公理，除各律所带者外不加前提。任意结果（一步后的水平函数，量为自然数）与任意序；哪些结果可选、是否有结果达到设定点、'
               '设定点之下的余地，在其进入处给定。'},
        {'en': 'For the draw, balance with the whole (the family with the conditions beyond) gaining nothing across the '
               'step, and for the breaks each condition beyond depended on at a need it meets; for the exchange, the '
               'outcomes open to a part within its capacities, the rest exchanging as it does (Flow.Outcome).',
         'zh': '于抽取，整体（族与之外的条件）在该步无所增益且平衡，于打断，之外每个条件被以其满足的需要依存；于交换，部分在其容量内、'
               '其余者照常交换时可达的结果（Flow.Outcome）。'},
        {'en': 'For several optimizers, one set point on shared conditions, the outcomes eligible to each supplied. For '
               'joint excess, activity needing support (Dependent), only active formations giving (Acting), the gate '
               'local at need m, and the holders alone exchanging with their families, holding their stocks and losing '
               'at least the amounts supplied.',
         'zh': '于多个优化者，共享条件上的一个设定点，各自的可选结果给定。于联合超额，活动需要支持（Dependent）、只有活动的构成给出'
               '（Acting）、需要 m 处的闸为局部的，以及持水平者独自与其族交换、保持其存量、至少失去所给之量。'}],
    'does_not_show': [
        {'en': "That an agent's preferences form a nearing order: they do where strictly single-peaked at each observed "
               "condition, each peak independent; a tolerance band around the set point is not one, nor is a best level "
               "depending on other conditions.",
         'zh': '主体的偏好构成趋近之序：其在每个所观察的条件上严格单峰、各峰独立时才是；设定点周围的容差带不是，某条件之最佳水平依赖于'
               '其他条件者亦不是。',
         'kind': 'correspondence'},
        {'en': "Any probability, surprisal, expected free energy or precision: active inference's preferences, prior "
               "beliefs over outcomes, are read as a nearing order at the high-precision limit.",
         'zh': '任何概率、惊异、期望自由能或精度：主动推断的偏好，即对结果的先验信念，在高精度极限处读作趋近之序。',
         'kind': 'scope'},
        {'en': 'That a set point protects what lies beyond: where a step can lose what it takes, the order by distance '
               'has the draining step among its optima beside the keeping one; what protects is the choice among equal '
               'optima.',
         'zh': '设定点保护之外：一步可失其所取时，距离之序的最优中既有抽取的一步，也有保持的一步；保护者是同等最优中的选择。',
         'kind': 'non-implication', 'witness': M + 'Topped.nearing_either'},
        {'en': 'The quantilizer bound: a choice drawn from a base distribution over the ways of reaching the set point '
               'would inherit it (Taylor 2016); that is a reading, not proved here.',
         'zh': '量化器之界：自达到设定点之诸方式上的基础分布中抽取的选择，将承其界（Taylor 2016）；此为读法，此处未证。',
         'kind': 'scope'},
        {'en': 'Anything over a horizon or under noise: every law is of one step or of supplied courses, and '
               'deterministic; under noise a set point on later states makes reserves worth holding, so a rising drive '
               'on stores can return.',
         'zh': '任何时限上或噪声下之事：每条律都属于一步或给定的进程，且是确定的；有噪声时，对后来状态的设定点使储备值得持有，故对库存'
               '的升高驱动可以复返。',
         'kind': 'scope'},
        {'en': 'Which optimum is taken where several stand at the set point; the optima where none reaches it and some '
               'stand above, or in an exchange at or above it beyond the witnesses.',
         'zh': '多个最优立于设定点时取哪一个；无结果达到设定点而有结果高于它时的最优，或交换中在设定点或其上、见证之外的最优。',
         'kind': 'scope'},
        {'en': 'Conflicting set points, or optimizers read off an exchange: several share one set point, their eligible '
               'outcomes supplied; terms counted after are lexicographic, a weighted term trading against the set point '
               '(Topped.weighted_keeps).',
         'zh': '相冲突的设定点，或自交换读出的优化者：多个优化者共一设定点，各自的可选结果为给定；计于其后的项是词典序的，加权项则与设定点'
               '相权衡（Topped.weighted_keeps）。',
         'kind': 'scope'},
        {'en': "That the beyond's fall is a harm, or that keeping is better: no evaluation enters; ranking courses needs "
               "C.",
         'zh': '之外的降低是伤害、保持更好：没有评价进入；排序进程须 C。',
         'kind': 'non-implication'}],
    'counterexamples': [
        {'path': MOD, 'detail': {
            'en': 'The set point alone does not protect: from a store at its set point, the step exchanging nothing and '
                  'the step taking a unit of the source and losing it are both optima of the order by distance, the '
                  "first meeting the dweller's need and the second not (Topped.nearing_either).",
            'zh': '单是设定点不保护：库在其设定点时，不交换的一步与取源一单位而失之的一步都是距离之序的最优，前者满足居住者的需要，后者'
                  '不满足（Topped.nearing_either）。'}},
        {'path': MOD, 'detail': {
            'en': 'Counted after the set point, the beyond is maximized in total, not at each condition: of two ways of '
                  'reaching the set point, every optimum empties a condition beyond that the even way keeps '
                  '(Spread.counted_after_empties).',
            'zh': '计于设定点之后，之外是在总量上最大，不是在每个条件上：两种达到设定点的方式中，每个最优都抽空均匀方式所保留的之外某条件'
                  '（Spread.counted_after_empties）。'}},
        {'path': MOD, 'detail': {
            'en': 'A nearing order can drive the drain at its set point: with less source counted after, every optimum '
                  "leaves the source below the dweller's need (Topped.counted_less_drains).",
            'zh': '趋近之序可在其设定点驱动抽取：较少的源计于其后时，每个最优都使源低于居住者的需要（Topped.counted_less_drains）。'}},
        {'path': MOD, 'detail': {
            'en': "Each within the slack, together past it: two takers each short of its set point by no more than the "
                  "slack break the dweller at their joint best response (TwoStores.jointly_broken).",
            'zh': '各在余量之内，合则越过：两个取者各自距其设定点的缺额都不超过余量，在其联合最优回应处打断居住者'
                  '（TwoStores.jointly_broken）。'}}],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical',
                            'names-provisional', 'omission-not-refutation'],
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): Becoming.SetPointOptimum, '
              f'{len(names)} declarations ({mod["theorems"]} theorems), every one with an empty axiom report, all cited '
              f'here; the three general laws of the exchange it uses moved into Becoming.Optimum with no statement of '
              f'Optimum or RegimeMargin changed (declaration types compared). Built in one session; an independent '
              f'read-only review by a separate AI agent, its findings taken and the revision re-checked, in study '
              f'section {N}; not reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：Becoming.SetPointOptimum，{len(names)} 项声明'
              f'（{mod["theorems"]} 项定理），公理报告皆空，本记录全引；其所用的交换之三条一般定律移入 Becoming.Optimum，Optimum '
              f'与 RegimeMargin 的陈述皆不变（比较声明类型）。于一会话中构建；另一 AI 代理作独立只读审查，其所见皆采，修订复查，'
              f'见研究第 {N} 节；未经人审。'},
    'next_delta': {
        'en': "Which optimum is taken where several reach the set point, with a quantilizer's bound over the ways of "
              "reaching it; several nearing optimizers read off an exchange; conflicting set points; a weighted term "
              "traded against the set point; choices over a horizon under noise, where reserves become worth holding; "
              "review by a person.",
        'zh': '多个最优达到设定点时取哪一个，及在达到设定点之诸方式上的量化器之界；自交换读出的多个趋近之优化者；相冲突的设定点；与设定点'
              '相权衡的加权项；在时限上有噪声时的选择，其中储备变得值得持有；人之审查。'},
    'correspondence': {
        'en': "Active inference (Friston, FitzGerald, Rigoli, Schwartenbeck, O'Doherty and Pezzulo 2016, 'Active "
              "inference and learning', Neuroscience & Biobehavioral Reviews 68): preferences are prior beliefs over "
              "outcomes, highest at the characteristic states; strictly single-peaked at each observed condition, each "
              "peak independent, they form a nearing order. Homeostatic reinforcement learning (Keramati and Gutkin "
              "2014, eLife 3): the drive, a norm of the deviations from set points, falls with the distance alike on "
              "both sides, so its order is nearing. Satisficing (Simon 1955, Quarterly Journal of Economics 69): an "
              "aspiration level has a plateau, as a set point reached has, and a term counted after either decides "
              "within it. Quantilizers (Taylor 2016): what protects at the set point is the choice among equal optima, "
              "mild optimization's point; its bound is a reading. Zhuang and Hadfield-Menell (NeurIPS 2020): the rising "
              "case, which a nearing order meets below its set point. Neighbours, not containments; cited from "
              "bibliographic knowledge, no source fetched; the readings are the AI's, in "
              "development/ue1b-set-points/NOTE.md, with the review in REVIEW-UE1b.md.",
        'zh': '主动推断（Friston、FitzGerald、Rigoli、Schwartenbeck、O\'Doherty、Pezzulo 2016）：偏好是对结果的先验信念，在特征'
              '状态处最高；在每个所观察的条件上严格单峰、各峰独立时，构成趋近之序。稳态强化学习（Keramati 与 Gutkin 2014）：其驱动为'
              '偏离设定点之量的范数，两侧同等地随距离下降，故其序是趋近的。满足化（Simon 1955）：抱负水平有平台，与达到的设定点相同，'
              '计于二者之后的项在平台内作决定。量化器（Taylor 2016）：在设定点保护者是同等最优中的选择，即温和优化之要点；其界为读法。'
              'Zhuang 与 Hadfield-Menell（NeurIPS 2020）：升高的情形，趋近之序在其设定点之下即遇之。为近邻，非包含；据文献知识所引，'
              '未取任何源；读法皆 AI 之读，载于 development/ue1b-set-points/NOTE.md，审查见 REVIEW-UE1b.md。'},
    'canonical_source': MOD,
    'aliases': ['What a set-point optimum does beyond what couples in', '设定点最优对耦合入者之外做什么',
                'orders nearing a set point', 'set-point orders', M + 'Nearing.not_rising', M + 'optima_iff',
                M + 'counted_after_most', 'Becoming.Flow.Balances.atSetPoint_draws', 'Becoming.Flow.held_excess_ends'],
    'dependencies': [
        {'id': 'what-an-optimum-does-beyond-what-couples-in', 'relation': 'formal-reuse',
         'detail': {'en': "Exceeds, Rising, Room, Least and least_iff: below the set point a nearing order rises, and "
                          "least_below_iff is least_iff read up to the set point; Rising.mono and least_of_room for a "
                          "term counted after a rising order; the Drain world (Diversion's splits, WithinSlack's "
                          "dweller) for the witnesses.",
                    'zh': 'Exceeds、Rising、Room、Least 与 least_iff：设定点之下趋近之序升高，least_below_iff 即读于设定点之下的 '
                          'least_iff；Rising.mono 与 least_of_room 用于计于升高之序之后的项；见证用 Drain 世界（Diversion 的分法、'
                          'WithinSlack 的居住者）。'}},
        {'id': 'room-read-off-the-exchange', 'relation': 'formal-reuse',
         'detail': {'en': 'Flow.Outcome, ActsWithin, Above and the general law of the exchange, beyond_of_ranked (its '
                          'fourth law, moved into Becoming.Optimum by this landing): nearing_beyond is its case, the unit '
                          'moved in being nearer; optimum_beyond for Topped.rising_drains.',
                    'zh': 'Flow.Outcome、ActsWithin、Above 与交换之一般定律 beyond_of_ranked（其第四条定律，此次落地移入 '
                          'Becoming.Optimum）：nearing_beyond 是其情形，移入的单位更近；optimum_beyond 用于 Topped.rising_drains。'}},
        {'id': 'what-a-rise-draws-from-beyond', 'relation': 'formal-reuse',
         'detail': {'en': 'Flow.Balances.beyond_falls_exactly and breaks_beyond, Web.MetOn and Web.slack: the draw at the '
                          'set point and its breaks are their case at the set point.',
                    'zh': 'Flow.Balances.beyond_falls_exactly 与 breaks_beyond、Web.MetOn 与 Web.slack：设定点处的抽取及其打断'
                          '是它们在设定点的情形。'}},
        {'id': 'own-count-misses-joint-excess', 'relation': 'formal-reuse',
         'detail': {'en': 'Flow.joint_excess_ends: held_excess_ends is its case for formations holding their levels.',
                    'zh': 'Flow.joint_excess_ends：held_excess_ends 是其于持水平之构成的情形。'}},
        {'id': 'two-sided-regulation-and-late-reading', 'relation': 'formal-reuse',
         'detail': {'en': "Regulation.Between, regulation's no overshoot, with gap_of_le and gap_of_ge: nearer is read by "
                          "betweenness.",
                    'zh': 'Regulation.Between（调节之不过冲），及 gap_of_le 与 gap_of_ge：更近以居间而读。'}}],
    'related': [
        {'id': 'several-optimizers-drain-by-their-joint-capacity',
         'detail': {'en': 'Several rising optimizers read off an exchange; several nearing optimizers here have their '
                          'eligible outcomes supplied.',
                    'zh': '自交换读出的多个升高之优化者；此处多个趋近之优化者的可选结果为给定。'}},
        {'id': 'capture-by-counted-choices',
         'detail': {'en': "UE1's chooser reading what couples in; its note's reading 3, that a chooser with set points "
                          "escapes the optimizer's drain, is tested here and holds in part.",
                    'zh': 'UE1 之读其所耦合者之择者；其笔记的读法三——有设定点之择者逃脱优化者之抽取——于此检验，部分成立。'}}],
    'references': [{'path': MOD, 'role': 'proof', 'declarations': sorted(names), 'sha256': sha(MOD)},
                   {'path': OPT, 'role': 'proof', 'declarations': GENERAL, 'sha256': sha(OPT)},
                   {'path': REG, 'role': 'proof', 'sha256': sha(REG)},
                   {'path': PROP, 'role': 'proof', 'sha256': sha(PROP)},
                   {'path': DRAWN, 'role': 'proof', 'sha256': sha(DRAWN)},
                   {'path': CONT, 'role': 'proof', 'sha256': sha(CONT)},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': NOTE, 'role': 'integration', 'sha256': sha(NOTE)},
                   {'path': REVIEW, 'role': 'review', 'sha256': sha(REVIEW)},
                   {'path': CH5, 'role': 'statement', 'sha256': sha(CH5)}],
    'proof_bindings': [{'source': MOD, 'receipt': RECEIPT, 'sha256_pointer': '/source_sha256/Becoming.SetPointOptimum',
                        'success_pointer': '/status', 'success_value': 'passed'},
                       {'source': OPT, 'receipt': RECEIPT, 'sha256_pointer': '/source_sha256/Becoming.Optimum',
                        'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{'en': f'{DATE_EN}: added (UE1b), what an order with a set point does beyond what couples in: the drain '
                       f'below the set point, the draw at it, and joint excess for holders with no choice in that law; '
                       f'the three general laws of the exchange moved into Becoming.Optimum (board rule 9); reviewed '
                       f'independently and re-checked; study section {N}.',
                 'zh': f'{DATE_ZH}：新增（UE1b），有设定点之序在耦合入者之外做什么：设定点之下的抽取、设定点处的抽取，以及持水平者的'
                       f'联合超额，该律中不入选择；交换之三条一般定律移入 Becoming.Optimum（看板规则 9）；经独立审查并复查；研究第 '
                       f'{N} 节。'}],
}
assert (ROOT / CH5).read_text(encoding='utf-8').count(f'<a id="r-{RID}"></a>') == 1, 'run texts_ue1b.py first'
for rid in ('what-an-optimum-does-beyond-what-couples-in', 'room-read-off-the-exchange', 'what-a-rise-draws-from-beyond',
            'own-count-misses-joint-excess', 'two-sided-regulation-and-late-reading',
            'several-optimizers-drain-by-their-joint-capacity', 'capture-by-counted-choices'):
    assert (RECORDS / f'{rid}.json').exists(), rid
taken = {}
for f in RECORDS.glob('*.json'):
    other = json.loads(f.read_text(encoding='utf-8'))
    for alias in [other['id']] + other.get('aliases', []):
        taken[alias.casefold()] = other['id']
clash = [a for a in [RID] + record['aliases'] if a.casefold() in taken]
assert not clash, ('aliases already owned', {a: taken[a.casefold()] for a in clash})
path = RECORDS / f'{RID}.json'
assert not path.exists()
path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record:', RID, len(names), 'declarations cited,', len(groups), 'laws')
