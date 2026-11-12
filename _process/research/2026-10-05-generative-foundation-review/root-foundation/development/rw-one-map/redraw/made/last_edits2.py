# AI-written, 12 November 2026. The last readers' notes beside their items, carried out in their own wording:
# - the premise both found unstated (the rest, once they count the loss, go on counting it and judge no more in the
#   favoured side's favour than that side does) is now said at every sentence that stands on those laws, as at step 9;
# - the arrow into "Gets back to the rule in time" says which kind of rule its law is about, as step 8 now does;
# - the fish stocks' "what was seen" and its two labels give 63% as "lower three years on" and 43% as "fell every
#   year", as the test's opening line does since this morning;
# - "it is not shown" in Chinese no longer reads "not yet proved".
# Each replaces a whole field. Run once.
import json, os
HERE = os.path.dirname(os.path.abspath(__file__))
data = {n: json.load(open(os.path.join(HERE, 'data', n + '.json'), encoding='utf-8')) for n in ('sheet', 'passages', 'paths', 'laid')}
P = {p['from'] + '>' + p['to']: p for p in data['passages']['passages']}


def put(obj, field, old, new):
    assert obj[field] == old, (field, obj[field][:80])
    obj[field] = new


SUP_EN = 'Suppose the rest, once they count the loss, go on counting it at every later update (in the law the loss only grows and none of the rest is removed), and judge no more in the favoured side\'s favour than that side does. '
SUP_ZH = '设其余的一旦把损耗算进去，此后每次重定都照旧算（在定律里，损耗只涨不落，其余的也没有哪一方被清走）；它们的判断又不比受偏向的一方自己更偏向这一方。'
p = P['b1.held>b2.counted']
put(p, 'en', 'Once the rest start counting the loss and the rule is updated twice running, the rule turns and is locked in the other way for good if, and only if, judgments taken together still go against what it favoured, ties included, at the second update. No law says what makes them start.',
    SUP_EN + 'Once they start counting and the rule is updated twice running, the rule turns and is locked in the other way for good if, and only if, judgments taken together still go against what it favoured, ties included, at the second update. No law says what makes them start.')
put(p, 'zh', '其余的开始把损耗算进去，规则接连重定两次：规则是不是就此转过去、定在另一边，只看第二次重定时，合起来的判断是不是仍然不利于它原先偏向的一方（打平也算不利）。是什么让它们开始算，没有定律说。',
    SUP_ZH + '其余的开始把损耗算进去，规则接连重定两次：规则是不是就此转过去、定在另一边，只看第二次重定时，合起来的判断是不是仍然不利于它原先偏向的一方（打平也算不利）。是什么让它们开始算，没有定律说。')
p = P['b2.felt>b2.heard']
put(p, 'en', 'The lock stays if, and only if, by the time the rest begin to count the loss, judgments taken together already favour what the rule favours.',
    'Where the rest judge no more in the favoured side\'s favour than that side does: the lock stays if, and only if, by the time the rest begin to count the loss, judgments taken together already favour what the rule favours.')
put(p, 'zh', '规则是不是照旧定着，只看一条：等其余的开始算这笔损耗的时候，合起来的判断是不是已经偏向规则所偏向的一方。',
    '要是其余的判断不比受偏向的一方自己更偏向这一方：规则是不是照旧定着，只看一条：等其余的开始算这笔损耗的时候，合起来的判断是不是已经偏向规则所偏向的一方。')
p = P['b2.uncounted>b2.felt']
put(p, 'en', 'It reaches what sets the rule in time if, and only if, the first moment anything that sets the rule can tell comes before the point of no return.',
    'For a rule that goes only by whether those that set it keep going: the loss reaches it in time if, and only if, the first step at which it makes a difference to whether one of them keeps going comes before the point of no return.')
put(p, 'zh', '它算不算及时传到，只看一条：定规则的各方里最早有一方能读到的那一刻，是不是早于回不了头的那一点。',
    '对只看定规则的各方还在不在的规则来说：损耗算不算及时传到，只看一条：它头一次让其中一方还在不在有了差别的那一步，是不是早于回不了头的那一点。')
lock = next(x for x in data['paths']['paths'] if x['id'] == 'lock')
st = [s for sec in lock['sections'] for s in sec['steps']][13]
put(st, 'say_en', 'If, by the time the rest begin to count the loss, the judgments together already favour what the rule favours, the lock stays.',
    'If, by the time the rest begin to count the loss, the judgments together already favour what the rule favours, the lock stays (the rest judging no more in the favoured side\'s favour than that side does).')
put(st, 'say_zh', '要是等其余的开始算这笔损耗的时候，合起来的判断已经偏向规则所偏向的一方：定局不改。',
    '要是等其余的开始算这笔损耗的时候，合起来的判断已经偏向规则所偏向的一方：定局不改（前提是其余的判断不比受偏向的一方自己更偏向这一方）。')
assert lock['want_zh'].endswith('这些是想要的，还没有证明。')
lock['want_zh'] = lock['want_zh'][:-len('这些是想要的，还没有证明。')] + '这些是想要的；图上没有哪一处显示它们已经成立。'
t = next(t for t in data['laid']['tests'] if t['id'] == 'stocks')
a = 'Above the point, 99.5% of 425 stretches stayed above it and 40% fell. Below it, 63% of 754 fell.'
assert t['seen_en'].count(a) == 1
t['seen_en'] = t['seen_en'].replace(a, 'Above the point, 99.5% of 425 stretches stayed above it and 40% ended lower than they began. Below it, 63% of 754 were lower three years on and 43% fell every year.')
a = '在那一点以上：425 个时段里 99.5% 仍在那一点以上，40% 下降了。以下：754 个时段里 63% 下降。'
assert t['seen_zh'].count(a) == 1
t['seen_zh'] = t['seen_zh'].replace(a, '在那一点以上：425 个时段里 99.5% 仍在那一点以上，40% 三年后比起点低。以下：754 个时段里 63% 三年后比起点低，年年下降的只有 43%。')
put(t['pins'][0], 'short_en', '99.5% above; 40% fell', '99.5% above; 40% lower')
put(t['pins'][0], 'short_zh', '99.5% 在其上；40% 降了', '99.5% 在其上；40% 更低')
put(t['pins'][1], 'short_en', 'said all; 63% fell', 'said all; 43% every year')
put(t['pins'][1], 'short_zh', '说全降；实际 63%', '说全降；年年降的 43%')
for name, d in data.items(): json.dump(d, open(os.path.join(HERE, 'data', name + '.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
print('ok')
