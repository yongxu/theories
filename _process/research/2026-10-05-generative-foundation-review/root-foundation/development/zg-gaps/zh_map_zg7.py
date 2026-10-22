#!/usr/bin/env python3
"""ZG7: the ZH map's last open gap notes. Entries the new laws answer are revised as in ZG4-ZG6; 老子七十九章 is answered
by laws already on the spine (Rejoining), its signed form marked out of scope; 孟子「亲亲而仁民」's graded order is a
scope remark; 唯识's necessary half stays open, its note saying why. Every edit must match exactly once per entry.
usage (from the checkout root): python3 -B zh_map_zg7.py"""
import json
from pathlib import Path

MAP = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/development/zhonghua/passages.json')
D = '（ZG7，2026年10月22日）'
POOL = ['Becoming.Web.majority_through_all', 'Becoming.Web.majority_outvoted']
TR = ['Becoming.TimedResponse.same_step_unreached', 'Becoming.TimedResponse.turned_at_juncture']
E = {
 'zhuangzi-quqie': ([('§7.4 的 AI 读法由此说池须到达规则怎样读，池作读取时是否解除锁定，脊柱尚无定律（G3，见 hanfei-er-bing）。',
    '两条规则（斗斛与权衡，或仁义与规则）同由份额单调读出、在每一份额都偏向时，自首个读取步之后同锁（RuleCapture.pair_locks），「并與仁義而竊之」即此。'
    '§7.4 的 AI 读法由此说池须到达规则怎样读：规则逆份额而读时，沿偏向之历程后读之规则不高于先读者（RuleCapture.against_not_rising），锁之所恃不成。')],
    None, '已补' + D + '：Becoming.RuleCapture.pair_locks（积形式，由 ReadsShare.pair）。见记录 two-rules-lock-together。',
    ['Becoming.RuleCapture.pair_locks', 'Becoming.RuleCapture.against_not_rising'], ['two-rules-lock-together']),
 'hanfei-er-bing': ([], '规则不锁定之条件：锁之所恃是规则随份额不降（locked_not_below，读法单调）；读法逆份额时（如池中被该选择压低者之读），沿偏向之历程份额不降，'
    '而后读之规则不高于先读者（RuleCapture.against_not_rising）；池按多数读时，份额决定其所读（Web.majority_outvoted）。',
    '已补' + D + '：Becoming.RuleCapture.against_not_rising（由 share_kept_along）；池按多数读之律 Becoming.Web.majority_outvoted。见记录 '
    'a-reading-against-the-share-does-not-ratchet、a-pool-read-by-its-majority。',
    ['Becoming.RuleCapture.against_not_rising', 'Becoming.Web.majority_outvoted'],
    ['a-reading-against-the-share-does-not-ratchet', 'a-pool-read-by-its-majority']),
 'hanfei-san-shou': ([('§7.4 的 AI 读法由此说池须到达规则怎样读，但池作读取时是否不锁定，脊柱尚无定律（见 hanfei-er-bing 的 G3）。',
    '§7.4 的 AI 读法由此说池须到达规则怎样读：池按多数读时，过半之成员读法相同处，无论多少成员能分开，其读皆同（Web.majority_outvoted），所以事劫使成员同辞，'
    '在多数之池中正是使份额压过分辨；规则逆份额而读时不棘轮（RuleCapture.against_not_rising）。')],
    None, '已补' + D + '：Becoming.Web.MajorityHolds、Web.majority_through_all、Web.majority_outvoted（按份额加权之池）。见记录 a-pool-read-by-its-majority。',
    POOL, ['a-pool-read-by-its-majority']),
 'wuzi-qun-chen-mo-ji': ([], '按份额加权之池：取过半成员之所读，是经合用之耦合之选择（Web.majority_through_all），不分开池所不分者；过半之成员对两历程读法相同处，'
    '无论多少成员能分开二者，其读皆同（Web.majority_outvoted）。合用之池只要一员能分开即分开（separates_all_iff_member），多数之池则看份额：群臣莫及而皆同于君，'
    '所分开者只余君之所分。',
    '已补' + D + '：Becoming.Web.MajorityHolds、Web.majority_through_all、Web.majority_outvoted。见记录 a-pool-read-by-its-majority。',
    POOL, ['a-pool-read-by-its-majority']),
 'zhongyong-shan-ji-ren-zhi-zhi': ([], '目标沿世系之递下：以「x 在第 t 步带目标」为谓词（carries），带目标者之后代皆带之，恰在目标跨每一自带目标者之降皆传之处'
    '（Flow.goal_descends_iff），沿一世系则还须每员在其给予之前守之（Flow.goal_along）；条件是单次之降之传，降本身不使之成立。「善繼人之志」即此条件。',
    '已补' + D + '：Becoming.Flow.goal_along、Flow.goal_descends_iff（条件律，条件为每一降之传与给予前之守）。见记录 a-goal-along-a-lineage。',
    ['Becoming.Flow.goal_along', 'Becoming.Flow.goal_descends_iff'], ['a-goal-along-a-lineage']),
 'jingshuo-ai-min-fei-yong-min': ([], '按步之资域：自第 s 步起之资域（Flow.WithinFeedingFrom）自第 0 步起即资域（withinFeedingFrom_zero），随时而缩'
    '（WithinFeedingFrom.earlier）；自 s 起不给任何所需者，不在他者自 s 起之资域内（not_withinFeedingFrom）。所以以每步之资域为界之顾，许可终结不再供给者'
    '（Flow.feedingFrom_permits），而在凡续皆有顾之下同一部分有丧（Flow.feedingFrom_parts）：「不若愛馬」之顾随供给停止而撤回。',
    '已补' + D + '：Becoming.Flow.WithinFeedingFrom、Flow.feedingFrom_permits、Flow.feedingFrom_parts（对任一流，不需见证）。见记录 feeding-from-a-step。',
    ['Becoming.Flow.WithinFeedingFrom', 'Becoming.Flow.feedingFrom_permits', 'Becoming.Flow.feedingFrom_parts'], ['feeding-from-a-step']),
 'mojing-daqu-sha-ji': ([('承诺层也已分开施加的基本剥夺与实际同意（J2、J3 的条件），但核心比较中没有失去由承受者自己承担与失去由他者的动作加于承受者之分。',
    '承诺层也已分开施加的基本剥夺与实际同意（J2、J3 的条件）；核心比较只读所实现之主张，所以二者实现同一主张时比较相同，无一优于另一'
    '（Lexical.BasicPriority.same_claims_alike）：只看构形所实现的主张，写不出这一不对称；把「无他者之部分加损于承受者」加为基本主张，则自承者在施加者之上'
    '（Lexical.Above.agent_adjoined）。')],
    None, '已补' + D + '：Becoming.Lexical.BasicPriority.same_claims_alike（不可写之一半）、Lexical.Above.agent_adjoined（加入动因之主张）。见记录 what-the-claims-do-not-read。',
    ['Becoming.Lexical.BasicPriority.same_claims_alike', 'Becoming.Lexical.Above.agent_adjoined'], ['what-the-claims-do-not-read']),
 'laozi-sz-weizhi-yuweiyou': ([('到达须在机之前，脊柱尚未把到达的时限与机放进同一个模型（G9，见 gap）。',
    '到达须在机之前，今在同一定理中：来源到期未达读者时，读者在机处所取之步于两历程相同，失之步于两者皆失（TimedResponse.same_step_unreached）；'
    '两历程在机处一保一失时，该处是机，且来源不能未达（TimedResponse.turned_at_juncture）。')],
    None, '已补' + D + '：Becoming.TimedResponse.same_step_unreached、TimedResponse.turned_at_juncture（读者在机处之构形为所设）。见记录 a-source-before-a-juncture。',
    TR, ['a-source-before-a-juncture']),
 'laozi-sz-bu-shishi': ([('两端合一见 G9（laozi-sz-weizhi-yuweiyou 之 gap）。',
    '两端合一：来源到期未达读者，读者在机处之步不改（TimedResponse.same_step_unreached），要改须先达（TimedResponse.turned_at_juncture）。')],
    None, '已补' + D + '：同 laozi-sz-weizhi-yuweiyou，见记录 a-source-before-a-juncture。', TR, ['a-source-before-a-juncture']),
 'lao-79-he-da-yuan': ([('余怨能否经新形成的关系化解，经文未说，脊柱也未证，见缺口。',
    '余怨能否经新形成的关系化解：恰经一个与该条件交换不同、把两历程耦合开之形成（Flow.closes_through_coupling_apart），化解时两流所交换者恰补其差'
    '（Flow.gap_made_up），见证 Replenishing.closes；响应所不及之条件上，差异保持其时之状（Flow.stays_beyond_response），此即余怨之所在。')],
    None, '已补' + D + '（现有之律）：Becoming.Flow.closes_through_coupling_apart、Flow.gap_made_up、Flow.stays_beyond_response，见证 Replenishing.closes。'
    '其余为范围：Remainder 之阶的计算只加（携带量为自然数之和），以相反之交换使携带量归零之律须有符号之量，不在此模型之内。',
    ['Becoming.Flow.closes_through_coupling_apart', 'Becoming.Flow.gap_made_up', 'Becoming.Flow.stays_beyond_response'], []),
}
SCOPE = {
 'ru-mengzi-qinqin-renmin-aiwu': '（1）按层限制意义而无丧立得（Web.Retains.of_fewer），分级不推翻保留；（2）两我之分级一致恰当层级诱导同一前序，一旦把走法抽象为所失之形成，'
    '即是层级之定义，其实质在网中是否有只失一者之走法，是网之性质，不是律。所以差等是加在凡续皆有顾之上的比较，与本条之相分同，不是待证之定理。',
}
OPEN = {
 'weishi-shiqi-wu-yin': '仍开（ZG7 复核，2026年10月22日）：这是主章 §8.1 第 9 项之开放问题（「a law of forming that is necessary as well as sufficient」）。'
    '只以汲取与依存陈述时，依存即汲取或持而不汲，充要之式退为传之定义；以给予、取用、水平陈述则不可（World.vacuous_of_drop_invariant）。所缺是依存如何结成之结构。原注：',
}
S = '范围之注（ZG7，2026年10月22日）：不是缺律。'

data = json.loads(MAP.read_text(encoding='utf-8'))
seen = {}
for cluster in data['clusters'].values():
    for e in cluster['entries']:
        if not e.get('gap') or e['gap'].startswith(('已补', '范围之注', '仍开')):
            continue
        i = e['id']
        if i in SCOPE:
            e['gap'] = S + SCOPE[i] + '原注：' + e['gap']
        elif i in OPEN:
            e['gap'] = OPEN[i] + e['gap']
        elif i in E:
            reps, add, gap, decls, recs = E[i]
            for old, new in reps:
                assert e['reading'].count(old) == 1, (i, old[:30], e['reading'].count(old))
                e['reading'] = e['reading'].replace(old, new)
            if add:
                e['reading'] = e['reading'].rstrip() + ('' if e['reading'].rstrip().endswith('。') else '。') + '已补：' + add
            e['gap'] = gap
            for field, xs in (('declarations', decls), ('records', recs)):
                for x in xs:
                    if x not in e[field]:
                        e[field].append(x)
        else:
            continue
        seen[i] = seen.get(i, 0) + 1
assert set(seen) == set(E) | set(SCOPE) | set(OPEN), (set(E) | set(SCOPE) | set(OPEN)) - set(seen)
MAP.write_text(json.dumps(data, ensure_ascii=False, indent=1), encoding='utf-8')
print('edited', len(seen), 'entries')
