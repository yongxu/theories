# KS: where the text says less than what is proved (KD's three finds, and a fourth found reading them).
import json, os, sys
W = sys.argv[1]
R = os.path.join(W, 'theories/becoming/results/records')
NOTE = "3 November 2026, board item KS (found by KD's readers): "

def edit_record(rid, fn):
    p = os.path.join(R, rid + '.json')
    d = json.load(open(p, encoding='utf-8'))
    fn(d)
    open(p + '.tmp', 'w', encoding='utf-8').write(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    os.replace(p + '.tmp', p)

def swap(field, old_en, new_en, new_zh):
    assert field['en'] == old_en, field['en'][:80]
    field['en'], field['zh'] = new_en, new_zh

def bounds(d):
    swap(d['does_not_show'][0],
         "Fisher's theorem in general: the additive part through one carried amount is stated in record additive-part-of-offspring-variance (at most the whole variance, this record's case its top); several amounts at once and the rational reading (variance over mean) are not stated; the statement here is the case of exact transmission.",
         "Fisher's theorem in general: the additive part through one carried amount is stated in record additive-part-of-offspring-variance (at most the whole variance, this record's case its top), and several amounts at once with the reading over the mean (the additive variance over the mean offspring number) in record the-breeding-value, cross-multiplied, a breeding value meeting the normal equations given; inexact transmission, where Fisher's environment term enters, is not stated; the statement here is the case of exact transmission.",
         "一般的 Fisher 定理：经由一个所载之量的加性部分陈述于记录 additive-part-of-offspring-variance（至多为全部方差，本记录的情形是其顶端），同时经由多个量并按均值读（加性方差除以平均后代数）陈述于记录 the-breeding-value，以交叉相乘表示，满足正规方程的育种值为给定；传递不精确、Fisher 的环境项进入之处未陈述；此处陈述的是传递精确的情形。")
    swap(d['next_delta'],
         "The additive part through several carried amounts at once; offspring numbers bounded by what a parent takes from the conditions it depends on, with support; an independent review.",
         "Offspring numbers bounded by what a parent takes from the conditions it depends on, with support; an independent review.",
         "以亲代从其所依存条件所取之量、连同支持来约束后代数；独立审查。")
    assert not any(x['id'] == 'the-breeding-value' for x in d['related'])
    d['related'].append({'id': 'the-breeding-value', 'detail': {
        'en': "Fisher's theorem through several carried amounts, with the reading over the mean, of which this record's exact case is the top.",
        'zh': '经由多个所载之量、按均值读的 Fisher 定理，本记录的精确情形是其顶端。'}})
    d['history'].append({'en': NOTE + "the does-not-show and next delta said several carried amounts at once and the reading over the mean are not stated; record the-breeding-value (EV15, 22 October 2026) states them, now cross-referenced and related; its laws and their statements are unchanged.",
                         'zh': '2026年11月3日，工作板条目 KS（KD 的读者发现）：“未表明”与“下一步”曾说同时经由多个所载之量以及按均值读未陈述；记录 the-breeding-value（EV15，2026年10月22日）陈述了它们，今交叉引用并列为相关；定律及其陈述不变。'})

def additive(d):
    swap(d['does_not_show'][0],
         "Several carried amounts at once (the breeding value, a multiple regression) and Fisher's identity itself (the predicted mean rising by the additive variance over the mean offspring number), which needs the regression coefficient, a ratio, are not stated.",
         "Several carried amounts at once (the breeding value, a multiple regression) and Fisher's identity itself (the predicted mean rising by the additive variance over the mean offspring number) are not stated here: record the-breeding-value states both, cross-multiplied, with a breeding value meeting the normal equations given and, for the mean's rise, exact transmission; one carried amount is the case of a single pair.",
         "同时经由多个所载之量（育种值，多元回归），以及 Fisher 恒等式本身（预测均值按加性方差除以平均后代数上升），此处未陈述：记录 the-breeding-value 陈述二者，以交叉相乘表示，满足正规方程的育种值为给定，均值的上升另需传递精确；一个所载之量是单一对的情形。")
    swap(d['next_delta'],
         "Several carried amounts at once (the breeding value); the equality case; Fisher's identity with rational amounts; an independent review.",
         "The equality case; Fisher's identity with rational amounts; an independent review.",
         "取等情形；以有理数的量陈述的 Fisher 恒等式；独立审查。")
    d['history'].append({'en': NOTE + "the does-not-show said Fisher's identity needs a ratio and is not stated, and the next delta asked for several carried amounts; record the-breeding-value (EV15) states both, cross-multiplied, and is now named in both places; its laws and their statements are unchanged.",
                         'zh': '2026年11月3日，工作板条目 KS（KD 的读者发现）：“未表明”曾说 Fisher 恒等式需要比值而未陈述，“下一步”曾求同时经由多个所载之量；记录 the-breeding-value（EV15）以交叉相乘陈述二者，今两处均指名；定律及其陈述不变。'})

def hamilton(d):
    swap(d['does_not_show'][0],
         "Returns with synergy (depending on the product of own and groupmates' amounts) and groups of unequal size are not stated.",
         "Returns with synergy (depending on the product of own and groupmates' amounts) are not stated; for groups of unequal size the returns' among-group part and the verdict through the spread among groups are not stated, while the whole's verdict through a reading's covariation (law 1) holds on any list, the split weighted by size is record selection-within-and-among-groups-of-any-sizes, and within groups the returns go as stated for any sizes.",
         "有协同的回报（依赖自身与组员之量的乘积）未陈述；大小不等的组，回报的组间部分与经由组间离散的判定未陈述，而经由读数协变的整体判定（定律 1）对任何列表成立，按大小加权的分解见记录 selection-within-and-among-groups-of-any-sizes，组内的回报对任何大小如所陈述。")
    swap(d['next_delta'],
         "Returns with synergy; groups of unequal size; how assortment changes over generations; an independent review.",
         "Returns with synergy; the returns' among-group part for groups of unequal size; how assortment changes over generations; an independent review.",
         "有协同的回报；大小不等之组中回报的组间部分；聚合在世代中如何变化；独立审查。")
    d['history'].append({'en': NOTE + "the does-not-show and next delta said groups of unequal size are not stated, though law 1 (rises_iff_reading) gives the whole's verdict through a reading's covariation on any list, and the split weighted by size is another record's law; narrowed to the returns' among-group part and the verdict through the spread among groups; its laws and their statements are unchanged.",
                         'zh': '2026年11月3日，工作板条目 KS（KD 的读者发现）：“未表明”与“下一步”曾说大小不等的组未陈述，而定律 1（rises_iff_reading）对任何列表给出经由协变的整体判定，按大小加权的分解为另一记录之律；收窄为回报的组间部分与经由组间离散的判定；定律及其陈述不变。'})

edit_record('what-bounds-offspring-numbers', bounds)
edit_record('additive-part-of-offspring-variance', additive)
edit_record('selection-with-returns-to-groupmates', hamilton)

def limit(d):
    x = d['does_not_show'][2]
    swap(x, "That a method can be found for every union of closed readings, or that identification follows from deciding each of finitely many hypotheses in the limit.",
         "That a method can be found for every countable union of closed readings (the Σ⁰₂ readings, which formal learning theory verifies classically: Kelly 1996, after Putnam 1965 and Gold 1965), or that identification follows from deciding each of finitely many hypotheses in the limit.",
         "对闭读法的每个可数并（Σ⁰₂ 读法，形式学习理论在经典上证实之：Kelly 1996，承 Putnam 1965 与 Gold 1965）都能找到方法，或由在极限中判定有限多个假说中的每一个即得辨识。")
    d['history'].append({'en': NOTE + "the does-not-show's union of closed readings made countable (classically, every reading of runs is a union of closed ones, recurrence among them) and the classical converse credited, as 03 now does; its laws and their statements are unchanged.",
                         'zh': '2026年11月3日，工作板条目 KS（KD 的读者发现）：“未表明”中闭读法之并改为可数并（经典上，运行的每个读法都是闭读法之并，复现在内），并记经典逆命题之出处，与 03 今同；定律及其陈述不变。'})

edit_record('what-a-method-comes-to-say-in-the-limit', limit)

TEXT = {
 'theories/becoming/chapters/04-LIFE.md': [
  ("Witness: an amount can vary beside varying offspring numbers with no covariance (`Becoming.Reproduction.Unrelated.unrelated`). Fisher's identity itself, which needs the regression coefficient, a ratio, is not stated. [Record]",
   "Witness: an amount can vary beside varying offspring numbers with no covariance (`Becoming.Reproduction.Unrelated.unrelated`). Fisher's identity itself, through one carried amount or several, is stated with [the breeding value](#r-the-breeding-value), cross-multiplied (`Becoming.Reproduction.Breeding.breeding_balance`; the mean's rise under exact transmission, `Becoming.Reproduction.Breeding.response`), one amount the case of a single pair (`Breeding.one_amount`, a rising line). [Record]"),
  ("With the assortment the share of the spread among groups, this is Hamilton's rule, in counts with nothing subtracted.",
   "With the assortment the share of the spread among groups, this is Hamilton's rule, in counts with nothing subtracted. Its general additive form needs no groups: on any list, where each member's weight with *k* per unit of its own amount is a base with *b* per unit of a reading, the whole selects for the amount exactly where *b* times the reading's covariation with it exceeds *k* times its spread (`Becoming.SelectionLevels.rises_iff_reading`): over the rationals, where the amount varies, where *b* times the regression of the reading on the amount exceeds *k*. So, with a member's group total as the reading and *k* = *b* + *c*, the whole's verdict through that covariation, though not through the spread among groups, holds for groups of any sizes."),
  ("Synergy and unequal sizes are not stated. [Record](../results/records/selection-with-returns-to-groupmates.md).",
   "Synergy is not stated, nor, for groups of unequal size, the returns' among-group part or the verdict through the spread among groups; the split weighted by size is [the general law](#r-selection-within-and-among-groups-of-any-sizes), and within groups the returns go as stated for any sizes. [Record](../results/records/selection-with-returns-to-groupmates.md)."),
  ("synergy, unequal sizes with returns, groups each counted once.",
   "synergy, the returns' among-group part for unequal sizes, groups each counted once."),
 ],
 'theories/becoming/chapters/03-KNOWING.md': [
  ("A reading verified in the limit is a union of closed readings, one refuted in the limit a meet of verifiable ones; a method for every such union is not shown.",
   "A reading verified in the limit is a union of closed readings, one for each horizon, and one refuted in the limit a meet of verifiable ones; a method for every countable union of closed readings (the Σ⁰₂ readings), which formal learning theory gives classically (Kelly 1996, after Putnam 1965 and Gold 1965), is not shown."),
 ],
 'theories/becoming/review/SCIENCES.md': [
  ("- Quote [theories/becoming/chapters/04-LIFE.md]: \"Fisher's identity itself, which needs the regression coefficient, a ratio, is not stated.\" Of breeding values: Quote [theories/becoming/chapters/04-LIFE.md]: \"That the normal equations have such a solution is given, not shown\".",
   "- Of breeding values: Quote [theories/becoming/chapters/04-LIFE.md]: \"That the normal equations have such a solution is given, not shown\", and Quote [theories/becoming/chapters/04-LIFE.md]: \"inexact transmission of the breeding value is not stated\"."),
 ],
}
for rel, pairs in TEXT.items():
    p = os.path.join(W, rel); s = open(p, encoding='utf-8').read()
    for a, b in pairs:
        assert s.count(a) == 1, (rel, s.count(a), a[:60]); s = s.replace(a, b)
    open(p + '.tmp', 'w', encoding='utf-8').write(s); os.replace(p + '.tmp', p)
print('ok')
