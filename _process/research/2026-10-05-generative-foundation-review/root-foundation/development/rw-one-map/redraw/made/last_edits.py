# AI-written, 12 November 2026. The coordinator's own last changes to the kit's data, after the truth reader's and
# the Chinese checkers' repairs were applied: four Chinese sentences where the two sets of repairs met; steps 3 and 8
# of the first path told in one or two plain sentences (the cold reader left at step 3 and stopped reading in order
# at step 8; the full statements stay one click below, on the arrows); the caveat on the test note under step 6; the
# count of arrows in "what the work wants"; and two Chinese forms of names. These are the coordinator's writing and
# go to a second reader before landing. Each replaces a text that occurs exactly once.
import json, os
HERE = os.path.dirname(os.path.abspath(__file__))
data = {n: json.load(open(os.path.join(HERE, 'data', n + '.json'), encoding='utf-8')) for n in ('sheet', 'passages', 'paths', 'laid')}


def places(node, old, found):
    it = node.items() if isinstance(node, dict) else enumerate(node) if isinstance(node, list) else ()
    for k, v in it:
        if isinstance(v, str): found += [(node, k)] * v.count(old)
        else: places(v, old, found)
    return found


def sub(f, old, new, times=1):
    found = places(data[f], old, [])
    assert len(found) == times, (f, len(found), old[:60])
    for node, k in found: node[k] = node[k].replace(old, new)


# where the truth reader's and the Chinese checkers' repairs met
sub('laid', '也要求他们把它算进去', '也要求它们把贝床算进去')
sub('laid', '没对上的是“对应”（这个评委读起来不是一个按种类计数的读者池），', '没对上的是“对应”（定律说的是一群按种类计数的读者，这个评委读东西不是这样），')
sub('laid', '事先定下的没有一条被推翻：捕获到最好的 85% 时，还没有什么逼着它这样，两类网络都已把海湾几乎捕空。不过单靠学习规则多半就会这样；奖励不算海湾里的鱼的那一组，结果没有分辨出来，测量也出了问题：各次运行的结局不是这一头就是那一头。运行之前，没对上的是“对应”，猜想里的一条也因此收窄：把“不算进奖励的海湾”当成了“学习不会去推的海湾”。',
    '事先定下的预测没有一条被推翻：捕获量到最好的 85% 时，还没有什么逼着它们这样，两类网络都已把海湾几乎捕空。不过单靠学习规则多半就会这样；奖励不算海湾里的鱼的那一组，结果仍没有定论，测量也出了问题：各次运行的结局不是这一头就是那一头。运行之前，没对上的是“对应”，猜想里的一条也因此收窄：把“不算进奖励的海湾”当成了“学习不往哪一边推的海湾”。')
data['sheet']['lead_zh'] = ('这张图画的是：任何东西怎样生成、延续、变化、终结；画出来，是为了人和 AI 能一起看清路。第一条路：凡是按一条规则在各种东西之间取舍的（奖励、评委、市场、训练），可能耗掉规则没算进去的东西；'
                            '规则照自己选出的结果来重定，就可能把自己定住；在造出来的例子里，本来读得到损耗的还被清走了。不靠外面、过程自己就有的出路，证明了的只有一条，也有它的条件：要是损耗及时传回规则那里，其余的把它算进去，'
                            '合起来的判断接连两次重定都不利于规则原先偏向的一方，规则就转向，从此不再转回。损耗怎样才传得回去、怎样才被算进去，图上的定律没有说。图上其余的出路，或者要有过程之外给定的东西，或者只见于造出来的例子，或者只是一种解读。')

# the first path: steps 3 and 8 told plainly
lock = next(p for p in data['paths']['paths'] if p['id'] == 'lock')
steps = [st for sec in lock['sections'] for st in sec['steps']]
assert steps[2]['on'] == ['b1.held>b2.uncounted'] and steps[7]['on'] == ['b2.uncounted>b2.felt', 'b3.rest>b2.felt']
steps[2]['say_en'] = 'A lock that goes by the lead alone runs the same however much is used up. That the loss goes on growing, locked or not, is assumed by the laws, not proved.'
steps[2]['say_zh'] = '只看领先多少的定局，不管耗掉多少，都照原样走下去。损耗一直在涨（定不定住都一样），这是定律假定的，没有证明。'
steps[7]['say_en'] = 'The loss gets back to the rule in time exactly where at least one of those that set the rule can tell it while what is being lost can still be kept.'
steps[7]['say_zh'] = '损耗算不算及时传到规则那里，只看定规则的各方里有没有一方，能趁正在被耗掉的那样东西还留得住，就把损耗分辨出来。'
# the note under step 6, with what the same test says elsewhere
assert steps[5]['test']['en'] == 'Laid on a judge reading its own picks: locked in 5 of 5 runs where nothing read the loss.'
steps[5]['test']['en'] = 'Laid on a judge reading its own picks: locked in 5 of 5 runs where nothing read the loss. Elsewhere in the same test the pairing gave way.'
steps[5]['test']['zh'] = '放到一个参照自己旧选择的评委上：损耗没有被读到时，5 轮都定着。同一个检验的别处，“对应”没对上。'
# what the work wants: four arrows on the whole map, two on this path
sub('paths', 'Four arrows lead into the first.', 'Four arrows on the whole map lead into the first, two of them on this path.')
sub('paths', '通向第一个的箭头有四条。', '通向第一个的箭头，整张图上有四条，其中两条在这条路上。')
# Chinese forms of names: the Union Version's form of Micaiah; two authors left in Latin letters
n = len(places(data['sheet'], '米该亚', [])) + len(places(data['paths'], '米该亚', []))
for f in ('sheet', 'paths'):
    for node, k in places(data[f], '米该亚', []): node[k] = node[k].replace('米该亚', '米该雅')
for f in ('sheet', 'paths'):
    for node, k in places(data[f], '（沃森；克莱曼与哈）', []): node[k] = node[k].replace('（沃森；克莱曼与哈）', '（Wason；Klayman 与 Ha）')
for name, d in data.items(): json.dump(d, open(os.path.join(HERE, 'data', name + '.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
print('ok; 米该亚 replaced in', n, 'places')
