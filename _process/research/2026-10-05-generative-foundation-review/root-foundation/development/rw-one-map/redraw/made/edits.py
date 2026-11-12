# AI-written, 12 November 2026. The coordinator's edits after six readers read the drawn sheet:
# a short tag for every passage (what carries it across), plainer words in the sentences, the kinds two readers
# found mislabelled, one passage restored from round 1, and the familiar names as the account's crosswalk has them.
# build.py applies these on top of settled.json; the second readers' sentences stay as they are otherwise.

# ---- a tag for each passage: from>to -> (English, Chinese)
TAGS = {
 'a1.within>a1.over': ('the line: what is taken against what comes back', '界线：取的比不比补的多'),
 'b0.together>a1.over': ('the same taking, seen share by share', '同一回事：一份份看都不多'),
 'b0.pays>b0.lost': ('does what is spared return one for one?', '留下的，回不回得到一比一'),
 'b0.lost>a1.over': ('so each takes all it can', '于是各自能拿就拿'),
 'b0.pays>a1.up': ('so the best course waits while it regrows', '于是先不取，等它长回来'),
 'a1.over>a1.past': ('the spare runs out at a fixed step', '余量只撑到固定的那一步'),
 'a1.over>a1.within': ('taking less, in time', '及时少取'),
 'a1.past>a2.ended': ('below the point it runs down to nothing', '过了那一点，一路降到零'),
 'a1.over>a2.ended': ('a steady excess ends it', '一直多取，终归用尽'),
 'a2.supplied>a2.short': ('the line: need and takings against level and givings', '界线：要的加取的，比不比存的加补的多'),
 'a2.short>a2.ended': ('it lasts only as long as its reserve', '储备撑多久，它就撑多久'),
 'a2.short>a2.supplied': ('supply returns before the reserve is spent', '储备用完之前，补给回来了'),
 'a2.short>a2.else': ('it comes to need that thing less', '它不那么需要那样东西了'),
 'a1.over>e2.rest': ('with nothing coming in, change stops where the total stops falling', '没有进项时：总量不降了，变化也就停了'),
 'a1.up>a1.new': ('new things need a rise without end', '要总有新的，得一直有得涨'),
 'a1.over>b2.uncounted': ('the same taking, left out by a rule', '同一回事：规则没把它算进去'),
 'b2.uncounted>a2.ended': ('the best by the rule takes it to the lowest allowed', '按规则做到最好，就把它压到最低'),
 'b1.outside>b1.swing': ('the rule comes to be updated from its results', '规则开始照自己的结果改'),
 'b1.swing>b1.held': ('every update favours the same side', '每次改都偏向同一方'),
 'b1.held>b3.inside': ('the same lock, with the judging inside too', '同一个定局：连评法也在圈里'),
 'bs.costs>bs.pays': ('does the return to the shapers cover the cost?', '单独回到改的一方的，抵不抵得过花费'),
 'bs.pays>b3.inside': ('the shapers come to set the rule', '改规则的一方定了规则'),
 'b2.uncounted>b3.gone': ('it uses up what would notice', '把会察觉的耗掉了'),
 'b3.gone>d3.one': ('all that is left holds one view', '剩下的都是一个看法'),
 'b3.inside>b3.checkers': ('the loop reaches its own checks', '圈子伸到了查错的途径上'),
 'b3.checkers>d2.handed': ('the pattern outlasts what carries it', '换了一茬，格局还在'),
 'b2.uncounted>b2.felt': ('can what sets the rule notice before it is too late?', '定规则的来不来得及察觉'),
 'b2.uncounted>a1.past': ('it shows only when it is too late', '等显出来，已经晚了'),
 'b2.felt>b2.counted': ('the rest count it, and outweigh', '其余的算进去了，而且压得过'),
 'b2.felt>b2.heard': ('the rest count it too late', '其余的算得太晚'),
 'b3.inside>b2.counted': ('a judging that stops favouring past a set loss', '损耗过了定量就不再偏向的评法'),
 'b1.held>b2.counted': ('the rest start counting the loss', '其余的开始算这笔损耗'),
 'b3.gone>b3.list': ('measure over all that began', '按最初的全部名单来量'),
 'a1.over>a1.up': ('a giver from beyond', '外面来了一份补给'),
 'a1.over>a2.else': ('it switches to another support', '它改靠别的'),
 'a1.past>a2.else': ('what keeps going no longer needs it as much', '还在延续的，已不那么靠它'),
 'a1.within>a2.short': ('by chance, and rarely', '偶然，而且少见'),
 'b1.held>d3.one': ('by chance alone', '单凭偶然'),
 'b2.uncounted>b2.counted': ('a rule that counts it', '换一条把它算进去的规则'),
 'b3.gone>b2.felt': ('the loss comes back on what sets the rule', '损失落回定规则的一方'),
 'd1.wait>d1.round': ('something gives without waiting', '有一个不等就给'),
 'd2.handed>a2.ended': ('handing on stops', '不再往下传'),
 'd3.merged>d3.one': ('a new name is made and heard by all', '新造一个名字，全体都听到'),
 'd3.merged>d3.several': ('a different name comes in from outside', '外面传进来另一个名字'),
 'd3.one>d3.several': ('a different way comes in from outside', '外面传进来另一种做法'),
 'd3.several>d3.one': ('each takes what it hears', '听到什么就用什么'),
 'e1.line>e1.ring': ('a link comes to answer to what lies downstream', '有个环节开始看下游的存量'),
 'e2.good>e2.swing': ('is the push back larger than the gap, or late?', '回推是不是超过缺口，或者来得晚'),
 'e2.norest>e2.rest': ('a score with a ceiling', '分数有个顶'),
 'e2.round>a1.past': ('one losing step at a fork', '岔口上走了丢掉回路的那一步'),
 'e2.round>e2.rest': ('is anything lost on the way round?', '路上有没有损耗'),
 'a1.up>a2.supplied': ('it regrows to the need', '长回到够用'),
 'b0.pays>a2.supplied': ('regrowth meets each need again', '长回来，需要又供上了'),
 'a1.past>a1.within': ('a lower take lowers the point', '少取，那一点也跟着降'),
 'b0.together>a1.within': ('shares that do not overlap', '分成互不重叠的几份'),
 'e2.rest>a1.up': ('something from beyond the closed set', '封闭范围之外有东西进来'),
 'b0.together>b0.lost': ('the rest alone already outrun it', '光是其余的就已经取过头'),
 'b2.uncounted>a2.supplied': ('only outcomes that keep every need are allowed', '只允许保住每份需要的结果'),
 'bs.pays>bs.costs': ('the loss falls on the shapers', '损耗落到改规则的一方身上'),
 'b1.held>b1.swing': ('the rule is turned round from outside', '规则被从外面翻了过来'),
 'b3.gone>a2.ended': ('what was removed had been renewing its remover', '被清走的，原本在补给清走它的'),
 'b2.counted>b3.gone': ('a large lead uses up what counts the loss', '领先的一方把算损耗的耗掉了'),
 'b3.gone>b3.inside': ('nothing left counts the loss', '算这笔损耗的一个都不剩'),
 'a2.ended>a2.supplied': ('a need loosens, or something beyond gives', '需要放松了，或者外面有补给'),
 'd1.gap>d1.round': ('each can do without the one that lapsed', '少了那一个，各自还过得去'),
 'd1.gap>d1.wait': ('one lapse spreads down the waits', '一处不给，顺着“等”传开'),
 'e1.ring>e1.line': ('a link wears out and stops', '有个环节磨损到停了'),
 'c1.road>c1.open': ('an act it actually takes is answered differently', '它真做的那一步，得到了不同的回应'),
 'c1.road>c1.checked': ('only what is tried is fixed by the record', '试过的才定得下来'),
 'c1.road>e2.rest': ('what it expects is what comes back', '回来的正是它料到的'),
 'c1.same>c1.open': ('a new kind of trial, from beyond', '得有外面来的新试法'),
 'c1.same>c1.nomeans': ('telling them apart uses up the last unit', '分清它们，用掉了最后一份'),
 'c1.open>c1.same': ('a new way of telling merges what the old kept apart', '新的分法把原先分开的并了'),
 'c1.open>c1.checked': ('each miss rules one out', '错一次，排除一个'),
 'c1.checked>c1.open': ('a change is foreseen', '预先知道要变'),
 'c1.checked>c1.old': ('the look ages', '这次对照旧了'),
 'c1.old>c1.checked': ('a fresh look, with enough in hand to revise', '重新对一次，而且有余力改'),
 'c1.old>c1.nomeans': ('the look spends all there was', '对照一次，就把本钱用光了'),
 'c1.nomeans>c1.checked': ('does the stock cover the act, and is it allowed?', '存量够不够，过程许不许'),
 'c1.nomeans>d2.stalled': ('the same lack, seen from the view', '同一种“缺一样”，从看法这边看'),
 'c1.open>c1.nomeans': ('one unit short of the act', '差一份，做不成'),
 'd0.line>a2.ended': ('the one it leans on ends', '它靠的那一个尽了'),
 'd0.line>a2.else': ('a descendant comes to need something outside', '后代改靠外面的东西'),
 'd1.round>d1.gap': ('a lapse as long as the wait', '中断长到了“等”的步数'),
 'd1.round>d1.wait': ('both lapse twice running', '双方连着两步都没给'),
 'a2.ended>d2.handed': ('something starts carrying it without being handed it', '有一个没经传授就开始承载'),
 'd2.handed>d2.stalled': ('does the stock cover the copying?', '存量够不够传这一轮'),
 'a1.over>d2.stalled': ('the reserve runs out midway', '储备半路用完'),
 'd2.stalled>a2.supplied': ('one unit is replenished', '补上了一份'),
 'd2.stalled>d2.handed': ('the missing thing arrives', '缺的那样来了'),
 'd0.ring>a1.past': ('the more the others hold, the lower the point', '别的存得多，那一点不升'),
 'e1.ring>e2.good': ('each turn returns less', '每转一圈回来的更少'),
 'e1.ring>e2.grow': ('each link passes on at least double', '每个环节都至少翻倍传下去'),
 'e1.ring>e2.rest': ('each turn returns no more', '每转一圈都不增'),
 'e1.ring>e2.round': ('each link passes on exactly what it gets', '每个环节原样传下去'),
 'e2.good>e2.rest': ('each push is against the gap and no larger', '每次回推都对着缺口，又不超过它'),
 'e2.round>e2.good': ('two differences are taken to one', '两个差别并成一个'),
 'e2.grow>e2.round': ('room runs out', '地方用完了'),
 'd0.ring>e2.rest': ('each gives more, the more is left', '剩得越多，给得越多'),
 'd0.ring>e2.round': ('a pair keeps each other going', '一对儿互相撑着转'),
 'd3.several>d3.merged': ('a form already used for another thing is taken', '用了一个已经另有所指的说法'),
 'd3.one>e2.rest': ('all on one is a rest', '都用同一个，就是停下了'),
 'e2.round>a1.up': ('being new at each step needs a giver', '每一步都新，得有给的一方'),
 'b3.rest>b2.felt': ('can at least one of those that set the rule tell?', '定规则的里头，有没有一个分辨得出'),
}

# ---- kinds two readers found mislabelled
KIND = {
 'b2.uncounted>a1.past': ('law', 'two sufficient laws, not an exact line (the truth reader and the whole-list reader)'),
}

# ---- one passage restored from round 1's settled arrows (settler and second reader, 11 November)
EXTRA = [
 {'from': 'b3.rest', 'to': 'b2.felt', 'kind': 'line',
  'en': 'Together, the ones that set the rule can tell two outcomes apart if, and only if, at least one of them can.',
  'zh': '定规则的那些合在一起，分不分得清两种结果，只看一条：其中至少有一个分得清。',
  'laws': ['Becoming.Web.separates_all_iff_member'], 'paths': ['lock'], 'src': 'round 1, settled'},
]

# ---- five English and five Chinese sentences rewritten by the words reader, to say no more and no less
EN = {
 'b1.swing>b1.held': 'If every update of the rule favours the same side, and favours it no less when that side\'s share is larger, then every run is locked in from the step after its second update. This holds whatever share, rule and way of judging it starts with.',
 'b3.inside>b2.counted': 'Suppose the way of judging never favours once the loss has passed a set amount. Then the lock-in ends: the loss keeps growing, and once it has passed that amount the rule, after every update, no longer favours the side it favoured, however far ahead that side is.',
 'b2.uncounted>a1.past': 'If the loss makes no difference to anything that sets the rule until what is being lost can no longer be kept, then no rule that goes only by whether those things keep going can notice it in time. The same holds if the only things that set the rule are the ones being lost.',
 'bs.costs>bs.pays': 'Within one step, shaping the rule pays if, and only if, the part of the return that comes back only to those shaping it covers the cost. What all get equally does not count. A return shared within a group counts by how far the shapers are gathered in the same groups.',
 'b0.together>b0.lost': 'Suppose what renews a stock also lives on it, and the others, without one more, take more than is renewed for long enough. Then the stock falls below what its renewer needs and stays below, whatever the one more takes or leaves. A count made afterwards scores its taking and its leaving the same.',
}
ZH = {
 'b0.pays>b0.lost': '“都拿光”是不是各自对其余的最好应对，只看一条：不管哪一个，它单独留下的每一份，回到它自己这里的都不多于一份。',
 'bs.costs>bs.pays': '就一步来说，改规则划不划得来，只看一条：只回到改的一方的那部分，抵不抵得过花费；各方一样都得的不算。只在一组之内分的那部分，改的一方在组里越集中，算进去的越多。',
 'b2.uncounted>a1.past': '如果损耗要等到留不住了，才在定规则的那些身上显出差别，那么只看它们还在不在的规则，没有一条来得及发觉。定规则的如果只有正在失去的那些，也一样。',
 'b2.felt>b2.counted': '其余的把损耗算进去了，合起来的判断不利于规则原先偏向的一方（打平也算不利）。规则是不是就此转过去，只看下一次重定时合起来的判断是不是仍然不利于它。',
 'b0.together>b0.lost': '补给这份存量的，自己也靠它延续；其余的光是它们自己，取的就一直比补的多。时间够长，存量就跌到那份需要以下，再也回不来，多出来的那一个取多取少都一样；事后再去看存量，它的取和它的留得分相同。',
}

# ---- plainer words, applied to every English sentence (phrases, in order)
EN_WORDS = [
 ('a rebuilding', 'an update'), ('rebuildings', 'updates'), ('rebuilding', 'update'), ('Rebuilt', 'Updated'), ('rebuilt', 'updated'),
 ('The same hold', 'The same lock'), ('the same hold', 'the same lock'),
 ("bending's", "shaping's"), ('Bending the rule', 'Shaping the rule'), ('bending the rule', 'shaping the rule'), ('its benders', 'those shaping it'),
 ('what bends the rule', 'what shapes the rule'), ('bends the rule', 'shapes the rule'), ('bending pays', 'shaping pays'), ('bending', 'shaping'),
 ('the ones that would tell', 'the ones that would read the loss'), ('what would tell', 'what would read the loss'), ('What would tell', 'What would read the loss'),
 ('anything with a say can tell', 'anything that sets the rule can tell'),
 ('The hold', 'The lock'), ('the hold', 'the lock'), ('a hold', 'a lock'), ('no hold', 'no lock'), ('A hold', 'A lock'),
 ('is held from', 'is locked in from'), ('is held:', 'is locked in:'), ('held neither way', 'locked in neither way'), ('held the other way', 'locked in the other way'),
 ('a held start', 'a locked start'), ('a held course', 'a locked course'), ('neither side is held again', 'neither side is locked in again'),
 ('the other side is held for good', 'the other side is locked in for good'),
 ('exactly where,', 'if, and only if,'), ('exactly where', 'if, and only if,'),
]
# applied after the readers' repaired sentences and tags, which still said 'notice'
EN_WORDS2 = [
 ('the ones that would notice', 'the ones that would read the loss'), ('what would notice', 'what would read the loss'), ('What would notice', 'What would read the loss'),
 ('can notice it in time', 'can read it in time'), ('notice in time', 'read it in time'), ('notice before it is too late', 'read it before it is too late'),
]
ZH_WORDS2 = [('会察觉的', '读得到损耗的'), ('察觉得到', '读得到'), ('察觉', '读到')]
ZH_WORDS = [
 ('“定住”', '定局'), ('进程', '过程'), ('说得上话的一方', '定规则时算数的一方'), ('有得赚', '还能多得'),
 ('回到它自己手里', '归它自己'), ('回到自己手里', '归自己'), ('本书', '这套理论'),
]

# ---- names: (id) -> English, Chinese (None keeps)
ROW_NAMES = {
 'b0': ('Whether what is spared comes back to the one that spared it', None),
 'b2': ('Whether what is used up gets back to the rule', '用掉的传不传得到规则'),
 'bs': ('Whether shaping the rule pays', None),
 'b3': ('What counts when the rule is set', None),
 'c1': ('How a view meets how things are', None),
 'e1': (None, '所做的会不会绕回自己'),
 'e2': ('How much comes back each turn', None),
}
BAND_NAMES = {'C': ('A view and how things are', None), 'D': ('Between things that keep going', None), 'E': ('Of anything that keeps going', None)}
COND_NAMES = {
 'a1.up': (None, '越积越多'),
 'a2.else': ('Keeps going as something else', None),
 'b0.pays': ('What it spares comes back to it', None),
 'b0.together': ('Each takes little, together too much', None),
 'b0.lost': ('What it spares is lost to it', None),
 'b2.felt': ('Gets back to the rule in time', None),
 'b2.uncounted': ('Using up what is not counted', None),
 'b2.heard': ('Gets back, but the lock stays', '传到了，定局不改'),
 'b1.outside': ('Set from outside', None),
 'b1.swing': ('Follows its own picks, not yet locked', None),
 'bs.costs': ('Shaping the rule costs', None),
 'bs.pays': ('Shaping the rule pays', None),
 'b3.inside': ('Judged only by its own picks', None),
 'b3.gone': ('What would read the loss is gone', '读得到损耗的不在了'),
 'b3.checkers': ('Even the checks are its own', None),
 'e2.norest': (None, '怎么都不算够'),
}

# ---- familiar names, only where the account's own one page or its crosswalk makes the reading
KNOWN = {
 'b0.together': ['the tragedy of the commons (Hardin)'],
 'b0.lost': ['the mechanism of the tragedy of the commons (Hardin): each gains the whole of what it adds and bears a part of the cost'],
 'b2.uncounted': ["Goodhart's law, in its popular wording", 'the proxy problem'],
 'b1.held': ['lock-in under increasing returns (Arthur)', 'cumulative advantage'],
 'bs.pays': ['regulatory capture (Stigler)'],
 'b3.rest': ['黄宗羲 (Huang Zongxi), 公其非是於學校: the ruler does not settle right and wrong alone; it is judged in common at the schools'],
}
KNOWN_ZH = {'b3.rest': ['黄宗羲：“天子亦遂不敢自为非是，而公其非是于学校”'],
            'b0.together': ['公地悲剧（哈丁）'], 'b0.lost': ['公地悲剧的机制（哈丁）：多取的全归自己，代价只担一份'], 'b2.uncounted': ['古德哈特定律（通行的说法）', '代理指标问题'],
            'b1.held': ['报酬递增下的锁定（阿瑟）', '累积优势（马太效应）'], 'bs.pays': ['监管俘获（施蒂格勒）']}
# the account's own name for a box, said in the box's sentence
OWN_NAME = {'b3.inside': ('The account calls this the meta-attractor in its closed form.', '这套理论把它叫作元吸引子的闭合形式。')}
