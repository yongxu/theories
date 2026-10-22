#!/usr/bin/env python3
"""ZG4-ZG6: the ZH map's entries the new laws answer, and the gap notes that are scope remarks. For an answered entry the
reading's sentence naming the gap is revised (or, where none does, a sentence is added), the gap note says what now
states it, and the declarations and records grow by the new ones. A scope remark keeps its text after a prefix saying
why it asks for no law. Every edit must match exactly once per entry; kinds are unchanged (an entry whose kind rested on
the gap says so, its kind left to the ZH reading).
usage (from the checkout root): python3 -B zh_map_zg46.py"""
import json
from pathlib import Path

MAP = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/development/zhonghua/passages.json')
D = '（ZG{b}，2026年10月22日）'
KIND = '种类原以此缺定为定域，今未改判，留给中华本之重读。'
WIT = ['Becoming.WitnessRefinementRuns.copied_witnesses_same', 'Becoming.FaultEnvelopes.copied_roster_same']
JN = ['Becoming.Branching.reach_within_listed', 'Becoming.Branching.keeps_before_juncture']
EX = ['Becoming.Flow.withinJoint_of_plan', 'Becoming.Flow.level_kept_of_plans']
E = {
 'hanfei-bu-shi-xiang-yu': (4, [('见证相通时名单等同于其一之一般律未证（G1），故只标定域。',
    '见证相通时名单等同于其一：每一加入之见证抄录名单上一员之报告、支持与所在之故障集合时，检查之每一步与证书皆不变'
    '（WitnessRefinementRuns.copied_witnesses_same、FaultEnvelopes.copied_roster_same；完全重复之名单为其情形）。' + KIND)],
    None, '已补' + D.format(b=4) + '：Becoming.WitnessRefinementRuns.copied_witnesses_same、FaultEnvelopes.copied_roster_same'
    '（doubled_roster_same、duplicated_roster_same 为其情形）。见记录 copied-witnesses-change-nothing。', WIT,
    ['copied-witnesses-change-nothing']),
 'hanfei-shi-ren-yun-yi': (4, [('相传之众证不增分辨之一般律未证（G1），故标定域。',
    '相传之众证不增分辨：抄录名单上一员之见证不改检查之步与证书（WitnessRefinementRuns.copied_witnesses_same）。' + KIND)],
    None, '已补' + D.format(b=4) + '：同 hanfei-bu-shi-xiang-yu，见记录 copied-witnesses-change-nothing。', WIT,
    ['copied-witnesses-change-nothing']),
 'xunzi-zhi-ming-yong-li': (4, [], '一个义项可持多个形式之码，恰在无二义项共持一形之处，读回每一所持之形为其义项且只为之（SharedCodes.synonyms_read_iff；'
    '一义一形为其情形，one_form_reads_iff）：同义之名无害，同形异义有害，「单与兼无所相避则共」由此成立。',
    '已补' + D.format(b=4) + '：Becoming.SharedCodes.synonyms_read_iff、SharedCodes.one_form_reads_iff。见记录 synonyms-and-coined-forms。',
    ['Becoming.SharedCodes.synonyms_read_iff', 'Becoming.SharedCodes.one_form_reads_iff'], ['synonyms-and-coined-forms']),
 'xunzi-wang-zhe-zhi-ming': (4, [('范围：「有作于新名」是造新形，模型中听不造形（hearBy_held），模块中没有造形的一步，见缺口；',
    '范围：「有作于新名」是造新形；听不造形（hearBy_held），造形是另一步（SharedCodes.coin）：众持一合并 m 与 m′ 之码时，一形成在 m 造出此码不给 m′ 之形，'
    '众皆听之，则每一形成复分 m 与 m′（SharedCodes.coined_returns）；')],
    None, '已补' + D.format(b=4) + '：Becoming.SharedCodes.coin、SharedCodes.coined_returns。见记录 synonyms-and-coined-forms。',
    ['Becoming.SharedCodes.coin', 'Becoming.SharedCodes.coined_returns'], ['synonyms-and-coined-forms']),
 'hanfei-yi-duo-xin': (4, [('SharedCodes 只有读两个码的采纳规则，模块头也把读多于两码的规则列为未推出项，见缺口。',
    '读多于两码之规则，一例是从众（SharedCodes.majority：各形成在每一义项取多于半数所持之形，无则守己）：从众不造形（majority_held）；'
    '三中二同即一步一致（Majority.odd_agrees），二中一同则不动（Majority.even_rests），一致仍需打破对称。')],
    None, '已补' + D.format(b=4) + '：Becoming.SharedCodes.majority、majority_held、Majority.odd_agrees、Majority.even_rests。见记录 taking-what-most-hold。',
    ['Becoming.SharedCodes.majority_held', 'Becoming.SharedCodes.Majority.odd_agrees', 'Becoming.SharedCodes.Majority.even_rests'],
    ['taking-what-most-hold']),
 'wangbi-lueli-zhi-zhong-zhe-zhi-gua': (4, [('一般族见 gap；',
    '对任意族与任意形式，施加一码使众一步一致（impose_agrees），保持形成之交换（SharedCodes.impose_keeps_exchange），'
    '而凡移动其所给之形之改名皆不保持（SharedCodes.impose_privileges_forms）：无一形成居上而偏于形式，一般族亦然；')],
    None, '已补' + D.format(b=4) + '：前一半 Becoming.SharedCodes.impose_agrees、impose_keeps_exchange、impose_privileges_forms（一般族与一切形式）；'
    '后一半 never_agrees_of_both。见记录 imposing-a-code-breaks-the-symmetry。',
    ['Becoming.SharedCodes.impose_keeps_exchange', 'Becoming.SharedCodes.impose_privileges_forms'], ['imposing-a-code-breaks-the-symmetry']),
 'daqu-yushu-yuxiong': (4, [('「非彼其行益也」正是拒绝这种误归，但这一例不是一般律（见 gap）。',
    '「非彼其行益也」正是拒绝这种误归，今为一般律：凡一步之动作有两情境到达不同构形，细律以同一动作取二者，只由构形与动作给下一构形之律不能二者皆对'
    '（Situations.move_underdetermines；Confound.misattributes 为其一例）。')],
    None, '已补' + D.format(b=4) + '：Becoming.Situations.move_underdetermines。见记录 the-move-alone-underdetermines。',
    ['Becoming.Situations.move_underdetermines'], ['the-move-alone-underdetermines']),
 'xici-zhi-ji-qi-shen': (5, [], '构形列尽、步可判定而 s 复返时，凡仍可再得 s 者，在不多于构形数之步内得之（Branching.reach_within_listed）：'
    '机上保住之一步之后，s 在构形数之内可得；不是机之处，无一步可被驳为不保 s（Branching.keeps_before_juncture），择只在机上。'
    '机可延之步数（沿一路径 s 仍可得之最晚之步）一般无界：s 在回环上时，路径可无尽地停在可得之处，所以只有得之之界，没有待之之界。',
    '已补' + D.format(b=5) + '：Becoming.Branching.reach_within_listed（得之之界为构形数）、Branching.keeps_before_juncture；待之无一般之界（回环）。'
    '见记录 reaching-before-and-after-a-juncture。', JN, ['reaching-before-and-after-a-juncture']),
 'sunzi-bing-shi': (5, [], '入势之深与节之短各有界：列 m 个构形时，每一行程在第 m 步之前入复返之域（Law.enters_returning_within）；'
    '机上保住之一步之后，所护者在构形数之内可得（Branching.reach_within_listed）。',
    '已补' + D.format(b=5) + '：Becoming.Law.enters_returning_within（ZG1）、Branching.reach_within_listed。见记录 reaching-before-and-after-a-juncture。',
    ['Becoming.Law.enters_returning_within', 'Becoming.Branching.reach_within_listed'], ['reaching-before-and-after-a-juncture']),
 'hanfei-yulao-bian-que': (5, [], '机前保住之所需更少：不是机之处，无一步可被驳为不保所护者（Branching.keeps_before_juncture），'
    '在机上则须去掉失之之步（keeping_removes_at_juncture），失之之后无复得（losing_not_returns）。',
    '已补' + D.format(b=5) + '：Becoming.Branching.keeps_before_juncture。见记录 reaching-before-and-after-a-juncture。',
    ['Becoming.Branching.keeps_before_juncture'], ['reaching-before-and-after-a-juncture']),
 'xunzi-wangzhi-fa-er-bu-yi': (5, [], '读取与兼感合一之律：规则只经一池对快层构形之所读而读之时，读取步上两历程规则相同、池所读相同，则其后规则相同；'
    '所以规则在读取步上分开，只在池所读分开之处（Pace.rule_through_pool）。',
    '已补' + D.format(b=5) + '：Becoming.Pace.rule_through_pool。见记录 reading-through-a-pool。',
    ['Becoming.Pace.rule_through_pool'], ['reading-through-a-pool']),
 'xunzi-wangzhi-qun-fen-yi': (5, [('足迹之不交推出合取在所给之内，这一步没有定理，见 gap。',
    '足迹之不交推出合取在所给之内：所取由一实现了的联合计划给出，诸部分足迹在其整体之内且两两不交，根之足迹不多于所给，则合取在所给之内'
    '（Flow.withinJoint_of_plan），平衡之下每步如此则水平不降（Flow.level_kept_of_plans）。')],
    None, '已补' + D.format(b=5) + '：Becoming.Flow.withinJoint_of_plan、Flow.level_kept_of_plans。见记录 division-by-exclusive-footprints。',
    EX, ['division-by-exclusive-footprints']),
 'hanfei-yongren-shi-bu-xiang-gan': (5, [('由足迹不交到合取在所给之内、因而不争，这一步没有定理（见 xunzi-wangzhi-qun-fen-yi 之 gap），所以种类为定域：前一半与后一半各有律，桥未证。',
    '由足迹不交到合取在所给之内、因而不争，今有其律（Flow.withinJoint_of_plan、Flow.level_kept_of_plans）。' + KIND)],
    None, '已补' + D.format(b=5) + '：同 xunzi-wangzhi-qun-fen-yi，见记录 division-by-exclusive-footprints。', EX,
    ['division-by-exclusive-footprints']),
 'xici-sheng-sheng-zhi-wei-yi': (5, [('“生成生成”作为一条定律尚缺，见缺口。',
    '“生成生成”之传递一半今为定律：平衡之流中，只有活动者给予、活动需要支持、需求不松、每一形成连续受支持之步数有界时，若任意晚之步上有形成获得支持，'
    '则不能驳倒：任意晚之步上有形成从一个自身在 T 之后才获得支持之给予者获得支持（Flow.support_passes_on）。支持之链还不是生生，生生另需方向（章 §6.1）。')],
    None, '已补' + D.format(b=5) + '：Becoming.Flow.support_passes_on（由 comes_within_not_not）。见记录 support-passed-on。',
    ['Becoming.Flow.support_passes_on'], ['support-passed-on']),
 'xiaoxiang-weidang': (6, [], '恒九四「久非其位」与涣九五「正位也」入列，与其线之位相合（Hexagram.placeStatementsMore_agree）；'
    '噬嗑六五「得當也」不入列：其线柔居五位而不正，彖亦言「雖不當位」，「得當」不是位之陈述（理由记于 placeStatementsMore）。',
    '已补' + D.format(b=6) + '：Becoming.Hexagram.placeStatementsMore_agree。见记录 censuses-of-the-xiang-and-tuan。',
    ['Becoming.Hexagram.placeStatementsMore_agree'], ['censuses-of-the-xiang-and-tuan']),
 'xiaoxiang-zhongzheng': (6, [], '《彖》言中正者 11 句，所指之线皆居中且正（Hexagram.tuanCentreStatements_agree）。',
    '已补' + D.format(b=6) + '：Becoming.Hexagram.tuanCentreStatements_agree。见记录 censuses-of-the-xiang-and-tuan。',
    ['Becoming.Hexagram.tuanCentreStatements_agree'], ['censuses-of-the-xiang-and-tuan']),
 'xiaoxiang-yizhong': (6, [('相合于《小象》之例；《小象》单言中之句尚未普查（gap）。',
    '相合于《小象》之例；《小象》单言中之句已普查：说一线为中之 47 句皆在二、五（Hexagram.xiaoxiangMiddle_census），另 4 句含「中」而不说该线为中，'
    '其位皆不在中，震上六「中未得也」在其中。')],
    None, '已补' + D.format(b=6) + '：Becoming.Hexagram.xiaoxiangMiddle_census。见记录 censuses-of-the-xiang-and-tuan。',
    ['Becoming.Hexagram.xiaoxiangMiddle_census'], ['censuses-of-the-xiang-and-tuan']),
 'xiaoxiang-cheng-shangdao': (6, [], '言承、順乎剛者 4 处皆是 rises（Hexagram.riseStatements_agree）；归妹初九「相承也」同形异义，不入列。',
    '已补' + D.format(b=6) + '：Becoming.Hexagram.riseStatements_agree。见记录 censuses-of-the-xiang-and-tuan。',
    ['Becoming.Hexagram.riseStatements_agree'], ['censuses-of-the-xiang-and-tuan']),
 'xiaoxiang-shangqiong': (6, [('《易》中上位言「窮」者尚未普查。',
    '已普查：说一线之道穷、亢之 9 句皆在上位（Hexagram.exhausted_census），比彖「其道窮也」在其中；另 5 句之「窮」说志、孚、往之穷，其位皆在下'
    '（屯六三、豫初六、大壮初九、旅初六、巽九三），不是线之终端。')],
    None, '已补' + D.format(b=6) + '：Becoming.Hexagram.exhausted_census。见记录 censuses-of-the-xiang-and-tuan。',
    ['Becoming.Hexagram.exhausted_census'], ['censuses-of-the-xiang-and-tuan']),
 'shuogua-sancai-liuhua': (6, [('第二读的三才之带脊柱尚未定义，是本条的主要缺口（gap）。',
    '第二读的三才之带今已定义（Hexagram.bandOf）：带与高度是两种划分，合之定一位，各不为他之函数（Hexagram.bands_and_heights、Hexagram.neither_function），'
    '每带恰跨一缝，人带所跨之 s34 是两半之交（Hexagram.band_seams、Hexagram.band_seam_unique）。')],
    None, '已补' + D.format(b=6) + '：Becoming.Hexagram.bandOf、bands_and_heights、neither_function、band_seams、band_seam_unique。见记录 bands-of-the-three-powers。',
    ['Becoming.Hexagram.bands_and_heights', 'Becoming.Hexagram.neither_function', 'Becoming.Hexagram.band_seams'],
    ['bands-of-the-three-powers']),
 'shuogua-yi-suo': (6, [('说卦所言是三画卦，脊柱没有三画卦之型，三线上的同一陈述未单独证（见 gap）。',
    '说卦所言是三画卦：三线上，一线独异恰在其为乾或坤在该高度变一线之时（Hexagram.Trigram.sole_iff_searched），'
    '震、坎、艮为坤之一索、再索、三索，巽、离、兑为乾之（Hexagram.Trigram.searched）。')],
    None, '已补' + D.format(b=6) + '：Becoming.Hexagram.Trigram.sole_iff_searched、Trigram.searched。见记录 one-search-one-line。',
    ['Becoming.Hexagram.Trigram.sole_iff_searched', 'Becoming.Hexagram.Trigram.searched'], ['one-search-one-line']),
}
S = '范围之注（ZG，2026年10月22日）：不是缺律。'
SCOPE = {
 'zhuang-zhibeiyou-wu-chu-bu-de-xian-wu': '所言是已有两律之实例，步序起于 0 是模型之设，不立新律。',
 'zhuangzi-tianxia-jie-you-suo-chang': '所求之度量是比较之承诺（与以加宽为更好之 C 同类），须明言为设，不是待证之定理。',
 'tuan-kui': '「万物」一句之普遍形不立条件，反向不是此句所说，只记定域。',
 'xiaoqu-you-yi-tong': '论辩之规矩是辞之事，不是结构之律。',
 'xiaoqu-qi-ran-suo-yi-ran': '是引文之说明，不是缺律。',
 'lunyu-ju-yi-yu': '施教之规矩与同类之前提是读法之设，不是待证之律。',
 'xici-chu-lei-er-zhang': '是读法之注（AI 之结构读法），不是缺律。',
 'suzhe-20-yi-zhi': '不带入之层，是范围之界，不是缺律。',
 'mojing-ju-wu-sheng': '「當者勝」是读法之真在其成立：相反之谓不俱成立，无前提；俱不成立之排除即定然否（Decided），是定义层之事。',
 'mengzi-tui-en': '恩之模型是 AI 之设，应当不由依存之结构推出是理论本有之立场，不是缺律。',
 'mobian-bu-zhi-qi-shu': '此段不定所问之范围，是读法之注。',
 'mobian-xiaoqu-zhou-huo': '谓词各要求何量，取决于谓词之内容，不是结构之律。',
 'yinming-san-xiang': '三相之检验在宗外，是读法之注。',
}

data = json.loads(MAP.read_text(encoding='utf-8'))
seen, scoped = {}, {}
for cluster in data['clusters'].values():
    for e in cluster['entries']:
        if not e.get('gap'):
            continue
        if e['id'] in SCOPE:
            assert not e['gap'].startswith(('已补', '范围之注')), e['id']
            e['gap'] = S + SCOPE[e['id']] + '原注：' + e['gap']
            scoped[e['id']] = scoped.get(e['id'], 0) + 1
            continue
        spec = E.get(e['id'])
        if not spec:
            continue
        seen[e['id']] = seen.get(e['id'], 0) + 1
        _, reps, add, gap, decls, recs = spec
        assert not e['gap'].startswith('已补'), (e['id'], 'already edited')
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
assert set(scoped) == set(SCOPE), set(SCOPE) - set(scoped)
MAP.write_text(json.dumps(data, ensure_ascii=False, indent=1), encoding='utf-8')
print('edited', len(seen), 'entries', sum(seen.values()), 'of them; scope remarks', len(scoped))
