#!/usr/bin/env python3
"""ZG1-ZG3: the ZH map's entries the new laws answer. Each reading's sentence naming the gap is revised (or, where none
does, a sentence is added), the gap note says what now states it, and the declarations and records grow by the new
ones. Every edit must match exactly once per entry; kinds are unchanged.
usage (from the checkout root): python3 -B zh_map_zg13.py"""
import json
from pathlib import Path

MAP = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/development/zhonghua/passages.json')
D = '（ZG{b}，2026年10月22日）'
NEG = ['Becoming.CeasesToBe.not_comes', 'Becoming.ComesToBe.not_ceases', 'Becoming.ComesToBe.of_not',
       'Becoming.CeasesToBe.of_not', 'Becoming.Web.ceasing_readings']
NEG_GAP = ('已补' + D.format(b=1) + '：CeasesToBe.not_comes、ComesToBe.not_ceases（无前提），反向 ComesToBe.of_not、'
           'CeasesToBe.of_not（须该规定在所读之处稳定）；在网上，Web.ceasing_readings。见记录 negation-change-and-stable-cases。')
E = {
 'mojing-yi-cheng-wang': (1, [('治病一例还显出：病之亡即愈之成，这是一条两行引理（见 gap），不是新结果。',
    '治病一例还显出：病之亡即愈之成：一规定之止息即其否定之生起，无前提（CeasesToBe.not_comes）；这是一条引理，不是新结果。')],
    None, NEG_GAP, NEG, ['negation-change-and-stable-cases']),
 'xici-gang-rou-xiang-tui': (1, [('逆向需要该规定可判定（见 gap）。', '逆向需要该规定在所读之处稳定（ComesToBe.of_not、CeasesToBe.of_not）。')],
    None, NEG_GAP, NEG, ['negation-change-and-stable-cases']),
 'zhuangzi-ri-ye-xiang-dai': (1, [('这是一条两行引理（见 gap）。', '这是一条两行引理（CeasesToBe.not_comes、ComesToBe.not_ceases）。')],
    None, NEG_GAP, NEG, ['negation-change-and-stable-cases']),
 'mobian-wu-qiong-ying-fou': (1, [], '此论证形式单列为 Decided.cases_stable：结论稳定时，由一命题与由其否定分别推出者成立，不需该命题定然否。',
    '已补' + D.format(b=1) + '：Becoming.Decided.cases_stable。见记录 negation-change-and-stable-cases。',
    ['Becoming.Decided.cases_stable'], ['negation-change-and-stable-cases']),
 'sunzi-wu-suo-bu-bei': (1, [('这一条是缺口，见 gap。', '最小一处不在平均之上（RelativePosition.least_not_ahead），处数增多而总量不增，则最小一处不增（RelativePosition.least_bound）：无所不备，则无所不寡。')],
    None, '已补' + D.format(b=1) + '：Becoming.RelativePosition.Least、least_not_ahead、least_exists、least_bound。见记录 least-parts-and-equal-shares。',
    ['Becoming.RelativePosition.least_not_ahead', 'Becoming.RelativePosition.least_bound'], ['least-parts-and-equal-shares']),
 'xugua-jin-bi-you-suo-gui': (1, [], '列出 m 个构形时，每一行程在第 m 步之前入复返之域（Law.enters_returning_within）。',
    '已补' + D.format(b=1) + '：Becoming.Law.enters_returning_within（存在 n < m）；Law.enters_returning 为其推论。见记录 basins-of-a-determined-law。',
    ['Becoming.Law.enters_returning_within'], ['basins-of-a-determined-law']),
 'cy-xiaoguo-jiaowang-guozheng': (1, [('（三）每步越界者永不就正：下一水平若为 m，则交换必在界内（withinGap_iff_between 的一步推论，AI 所推，未单列为定理，见缺口）；',
    '（三）每步越界者永不就正：下一水平若为 m，则交换必在界内，所以越界之步后水平不为 m（Flow.not_at_of_beyond），自某步起每步越界者此后永不为 m（Flow.never_at_of_beyond）；')],
    None, '已补' + D.format(b=1) + '：Becoming.Flow.not_at_of_beyond、Flow.never_at_of_beyond。见记录 regulation-from-one-side-and-locally。',
    ['Becoming.Flow.not_at_of_beyond', 'Becoming.Flow.never_at_of_beyond'], ['regulation-from-one-side-and-locally']),
 'lao-36-78-rou-sheng-gang': (1, [('一般的跨律单调未经 Lean，见缺口。', '一般的跨律单调已证：同一等待结构与同一起点，容忍逐点更大者每步给予不少于容忍小者（tolerating_mono，由 KeepsInclusionInto.course）。')],
    None, '已补' + D.format(b=1) + '：Becoming.Tolerance.tolerating_mono（由 KeepsInclusionInto.course、tolerating_into）。见记录 tolerance-monotone-across-laws。',
    ['Becoming.Tolerance.tolerating_mono', 'Becoming.Tolerance.KeepsInclusionInto.course'], ['tolerance-monotone-across-laws']),
 'daqu-ai-shang-shi-hou-shi': (1, [('脊柱还没有以时间为界的对手规则（只顾到某一步）的定理。', '以时间为界的对手规则（只顾到某一步，boundedInTime）在其时间之界内接受条件的规则，却不是延续之条件（bounded_in_time_rival）。'),
    ('在清除者的模型中，损失从第三步起在依存之外出现（Clearing.loses_beyond，见证），所以只顾今世的规则会许可终结后世（见 gap）。',
     '在清除者的模型中，损失从第三步起在依存之外出现（Clearing.loses_beyond，见证）；只顾前两步的规则下清除者之部分无所失，而在延续之条件下它失去居住者（Clearing.time_bounded_permits）：只顾今世的规则许可终结后世。')],
    None, '已补' + D.format(b=1) + '：Becoming.boundedInTime、bounded_in_time_rival（由 rival_of_outside）、Clearing.time_bounded_permits。见记录 rivals-bounded-in-time。',
    ['Becoming.boundedInTime', 'Becoming.bounded_in_time_rival', 'Becoming.Clearing.time_bounded_permits'], ['rivals-bounded-in-time']),
 'suzhe-22-xun-li': (1, [], '跨象一致恰是由象读出（through_iff_reads），故经象之择恰能选出要紧者，恰在要紧者由象读出之处（selects_right_iff）。',
    '已补' + D.format(b=1) + '：Becoming.Learning.through_iff_reads、Learning.selects_right_iff。见记录 selection-right-exactly-where-read。',
    ['Becoming.Learning.through_iff_reads', 'Becoming.Learning.selects_right_iff'], ['selection-right-exactly-where-read']),
 'wuzi-yi-ren-xue-zhan': (1, [('十倍之律本身脊柱尚未陈述（见缺口）。', 'b 倍抄录之律：每单元汲取 d 而成 b 个，n 轮恰在存量足其所汲之处走完，终有 k·bⁿ 个单元（Copying.copying_iff）；一教十，五轮自一成十万，耗存量 11,111（Copying.tenfold）。')],
    None, '已补' + D.format(b=1) + '：Becoming.Copying.copying_iff、requiredBy_add、copying_runs；倍增为 b = 2 之情形（doubling_iff）；见证 Copying.tenfold。见记录 copying-b-fold。',
    ['Becoming.Copying.copying_iff', 'Becoming.Copying.requiredBy_add', 'Becoming.Copying.tenfold'], ['copying-b-fold']),
 'lunyu-bu-huan-gua-er-huan-bu-jun': (1, [('均分时需要不高于均份者仍被支持，也只是算术，脊柱没有均分之律（见 gap）。',
    '均分之律：等份满足每一需要，恰当满足最大之需要（RelativePosition.equal_share_iff）；需要不等之处，均分所给多于需要之和（equal_share_exceeds），所以存在所给足以按需支持全体而均分仍使需要高者不被支持之情形（uneven_short）。')],
    None, '已补' + D.format(b=1) + '：Becoming.RelativePosition.equal_share_iff、equal_share_exceeds、equal_share_even，见证 uneven_short。见记录 least-parts-and-equal-shares。',
    ['Becoming.RelativePosition.equal_share_iff', 'Becoming.RelativePosition.equal_share_exceeds', 'Becoming.RelativePosition.uneven_short'], ['least-parts-and-equal-shares']),
 'sunzi-yuan-shu': (1, [('缺口见 gap。', '沿 N 程输送（每程自族之一员有所输送，族跨步衡且耗），族之存量至少降 N，起点存量为 S 者至多输送 S 程（Flow.conveyed_loses）。')],
    None, '已补' + D.format(b=1) + '：Becoming.Flow.conveyed_loses（由 Flow.takers_within_on）。见记录 far-conveying-runs-the-family-down。',
    ['Becoming.Flow.conveyed_loses'], ['far-conveying-runs-the-family-down']),
 'mojing-sun-er-bu-hai': (1, [('「能害飽」（过饱亦害）是另一侧的界：脊柱之容只读所需的下界，过多之害没有对应之律，见 gap。',
    '「能害飽」（过饱亦害）是另一侧的界：所需带上限时，水平须在所需与上限之间（Web.FitsBand）；平衡之下此带两侧皆确切，部分以给予自下开之，以给予越过上限之余地自上阖之（Flow.fitsBand_iff_within_margins_at）。')],
    None, '已补' + D.format(b=1) + '：Becoming.Web.FitsBand、Flow.fitsBand_iff_within_margins_at。见记录 a-need-with-a-cap。',
    ['Becoming.Web.FitsBand', 'Becoming.Flow.fitsBand_iff_within_margins_at'], ['a-need-with-a-cap']),
 'sunzi-qinfu-fa': (1, [('定域：脊柱尚无一个具体的见证，给出两步共享关系项而两种次序到达不同构形（gap）。',
    '定域：两步共享关系项时次序可以要紧：一个具体见证中，二交换共享其关系项，以两种次序自同一构形到达不同构形（Interleavings.Shared.order_matters），所以 act_comm 之前提不可去。')],
    None, '已补' + D.format(b=1) + '：Becoming.Interleavings.Shared.order_matters。见记录 order-of-exchanges-sharing-a-relatum。',
    ['Becoming.Interleavings.Shared.order_matters'], ['order-of-exchanges-sharing-a-relatum']),
 'lao-37-zhen-zhi': (2, [('有交换的单侧之律（只镇上而不举下）脊柱没有，见缺口。',
    '有交换的单侧之律（只镇上而不举下）：平衡之下，m 之下交换不给多于取，则水平一旦在 m 之下即不再回到 m（Flow.held_below、Flow.never_returns_below）；所以只镇一侧者只从该侧定之。')],
    None, '已补' + D.format(b=2) + '：Becoming.Flow.held_below、Flow.never_returns_below（Flow.stays_below 为其门控之情形）。见记录 regulation-from-one-side-and-locally。',
    ['Becoming.Flow.held_below', 'Becoming.Flow.never_returns_below'], ['regulation-from-one-side-and-locally']),
 'lao-29-qu-shen-qu-tai': (2, [('只对上侧回应之镜像与有交换的单侧之律未单列，见缺口。', '有交换的单侧之律：平衡之下，m 之下交换不给多于取者，水平在 m 之下时不回到 m（Flow.never_returns_below）。')],
    None, '已补' + D.format(b=2) + '：Becoming.Flow.held_below、Flow.never_returns_below。见记录 regulation-from-one-side-and-locally。',
    ['Becoming.Flow.never_returns_below'], ['regulation-from-one-side-and-locally']),
 'lao-57-fa-ling-zi-zhang': (2, [('脊柱有两侧调节之定（Flow.Opposes、Flow.WithinGap、Flow.settles），但相反与界是联合交换的特点，脊柱没有从各形成的局部之律导出联合交换两侧相反的定理，见缺口；',
    '脊柱有两侧调节之定（Flow.Opposes、Flow.WithinGap、Flow.settles）；各形成只读其所交换之条件、各自弱相反而有其一严格相反时，联合交换即相反（Flow.opposes_of_each），各形成之偏离以其份额为界、份额之和不过间距时，联合交换在界内（Flow.withinGap_of_shares）；一族中每一条件如此局部调节于其水平，则族之总量定于诸水平之和，无一形成读总量（Flow.stock_settles）；')],
    None, '已补' + D.format(b=2) + '：Becoming.Flow.opposes_of_each、Flow.withinGap_of_shares、Flow.stock_settles。见记录 regulation-from-one-side-and-locally。',
    ['Becoming.Flow.opposes_of_each', 'Becoming.Flow.withinGap_of_shares', 'Becoming.Flow.stock_settles'], ['regulation-from-one-side-and-locally']),
 'lao-60-peng-xiao-xian': (2, [('范围要紧：「數撓」是部分反复给出差异（σ≠0），正是 carried_le_count 所设为零者，脊柱没有，见缺口；',
    '范围要紧：「數撓」是部分反复给出差异（σ≠0）：每次扰动至多 E 时，携带量至多 (D + E·d)·(1 + M)^a，d 为扰动之步数，a 为耦合之步数（carried_le_disturbed；carried_le_count 为无扰动之情形），每次扰动所加者为其后之耦合所倍；')],
    None, '已补' + D.format(b=2) + '：Becoming.carried_le_disturbed（carried_le_count 为其情形）。见记录 repeated-disturbance。',
    ['Becoming.carried_le_disturbed'], ['repeated-disturbance']),
 'zhongyong-bu-xi-ze-jiu': (3, [('所以对整体，「不息則久」需要一个附加前提：每个生起之部分至少持续到下一个生起之时，见 gap。',
    '所以对整体，「不息則久」需要一个附加前提：每个生起之部分至少持续到下一个生起之时；有此前提，整体自 T + d 起每步活跃（Whole.persists_of_arising、Whole.persists_from），无此前提则不成（Gaps）。')],
    None, '已补' + D.format(b=3) + '：Becoming.Web.Whole.persists_of_arising、Whole.persists_from。见记录 a-whole-carried-by-lasting-parts。',
    ['Becoming.Web.Whole.persists_of_arising', 'Becoming.Web.Whole.persists_from'], ['a-whole-carried-by-lasting-parts']),
 'wangbi-fu-bu-su': (3, [('但现有的有界休眠之律要求自某步起永无支持，而复足恰是支持回来，从不活跃到迷（复足之时依存者已不再生起）还缺两件，见 gap。',
    '有界休眠之律只需其前提在一段上成立（Web.ends_within_on），终结为终局时，此后无论支持是否回来，依存者皆不再活跃（Web.ended_for_good）；所以期长于储备者，迟复成迷（Web.late_return_finds_none），储备足以跨过此段者可以不迷（Bridged.bridged，存在之例）。')],
    None, '已补' + D.format(b=3) + '：（i）Becoming.Web.decays_by_on、Web.ends_within_on；（ii）Web.ended_for_good、Web.late_return_finds_none；（iii）Bridged.bridged。见记录 dormancy-over-a-stretch。',
    ['Becoming.Web.ends_within_on', 'Becoming.Web.ended_for_good', 'Becoming.Web.late_return_finds_none', 'Becoming.Bridged.bridged'], ['dormancy-over-a-stretch']),
 'mengzi-yi-ri-pu-zhi': (3, [('（从此到“未有能生”还缺一条只问一段之律，见 gap）；', '（Web.ends_within_on、Web.late_return_finds_none）；'),
    ('（只是存在之例，亦见 gap）。', '（Bridged.bridged，只是存在之例）。')],
    None, '已补' + D.format(b=3) + '：同 wangbi-fu-bu-su，见记录 dormancy-over-a-stretch。',
    ['Becoming.Web.ends_within_on', 'Becoming.Web.late_return_finds_none', 'Becoming.Bridged.bridged'], ['dormancy-over-a-stretch']),
 'weishi-sha-na-mie': (3, [('不变者无能生之用，在脊柱上尚未找到对应定理，列为待查（见 gap）。',
    '不变者无能生之用：一个恰在受支持时活跃的形成，跨一步时若其所读者（所需、需要之量与各条件之水平）皆不变，就不生起（Web.not_arises_of_unchanged）；生起需要所读者有变。')],
    None, '已补' + D.format(b=3) + '：Becoming.Web.not_arises_of_unchanged。见记录 arising-needs-change。',
    ['Becoming.Web.not_arises_of_unchanged'], ['arising-needs-change']),
 'lunyu-yin-sun-yi': (3, [], '多步之界：沿世系每代所需漂移至多 δ，i + 1 代之后所需至多始祖所需（或其受支持之步之水平）加 (i + 1)·δ（Flow.transmitted_along、Flow.transmitted_along_supported）：所損益可知。',
    '已补' + D.format(b=3) + '：Becoming.Flow.transmitted_along、Flow.transmitted_along_supported。见记录 need-drift-along-a-lineage。',
    ['Becoming.Flow.transmitted_along', 'Becoming.Flow.transmitted_along_supported'], ['need-drift-along-a-lineage']),
 'xici-tong-gui-shu-tu': (3, [], '确定之法下，诸构形之行程相会是等价关系，相会者成势（Law.Meet、Law.Meet.trans）；构形有限时，每一行程在构形数之内入复返之域（Law.enters_returning_within），每势中复返之构形彼此可达，即一个回环（Law.Meet.reaches_returning、Law.basin_one_cycle）：同归而殊途。',
    '已补' + D.format(b=3) + '：Becoming.Law.Meet、Law.Meet.trans、Law.Meet.reaches_returning、Law.basin_one_cycle。见记录 basins-of-a-determined-law。',
    ['Becoming.Law.Meet.trans', 'Becoming.Law.Meet.reaches_returning', 'Becoming.Law.basin_one_cycle'], ['basins-of-a-determined-law']),
}

data = json.loads(MAP.read_text(encoding='utf-8'))
seen = {}
for cluster in data['clusters'].values():
    for e in cluster['entries']:
        spec = E.get(e['id'])
        if not spec or not e.get('gap'):
            continue
        seen[e['id']] = seen.get(e['id'], 0) + 1
        _, reps, add, gap, decls, recs = spec
        assert e.get('gap') and not e['gap'].startswith('已补'), (e['id'], 'already edited')
        for old, new in reps:
            assert e['reading'].count(old) == 1, (e['id'], old[:30], e['reading'].count(old))
            e['reading'] = e['reading'].replace(old, new)
        if add:
            e['reading'] = e['reading'].rstrip() + ('' if e['reading'].rstrip().endswith('。') else '。') + '已补：' + add
        e['gap'] = gap
        for field, xs in (('declarations', decls), ('records', recs)):
            for x in xs:
                if x not in e[field]:
                    e[field].append(x)
assert set(seen) == set(E), set(E) - set(seen)
MAP.write_text(json.dumps(data, ensure_ascii=False, indent=1), encoding='utf-8')
print('edited', len(seen), 'entries', sum(seen.values()), 'records of them')
