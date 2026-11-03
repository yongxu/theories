# Revise apply_ks.py with the independent reader's findings (review 1).
p='/Users/ren/tmp/prefreeze-fix/kskit/apply_ks.py'; s=open(p,encoding='utf-8').read()
def rep(a,b):
    global s
    assert s.count(a)==1,(s.count(a),a[:70]); s=s.replace(a,b)
rep("未表明与下一步曾说同时经由多个所载之量以及按均值读未陈述","“未表明”与“下一步”曾说同时经由多个所载之量以及按均值读未陈述")
rep("未表明曾说 Fisher 恒等式需要比值而未陈述，下一步曾求","“未表明”曾说 Fisher 恒等式需要比值而未陈述，“下一步”曾求")
rep("未表明与下一步曾说大小不等的组未陈述，而定律 1（rises_iff_reading）对任何列表给出整体判定；收窄为组内与组间之分","“未表明”与“下一步”曾说大小不等的组未陈述，而定律 1（rises_iff_reading）对任何列表给出经由协变的整体判定，按大小加权的分解为另一记录之律；收窄为回报的组间部分与经由组间离散的判定")
rep("with a breeding value meeting the normal equations given, one carried amount its case.","with a breeding value meeting the normal equations given and, for the mean's rise, exact transmission; one carried amount is the case of a single pair.")
rep("满足正规方程的育种值为给定，一个所载之量是其情形。","满足正规方程的育种值为给定，均值的上升另需传递精确；一个所载之量是单一对的情形。")
rep('''"Returns with synergy (depending on the product of own and groupmates' amounts) are not stated; groups of unequal size are not stated for the split within and among groups, while the whole's verdict through a reading (law 1) holds on any list, unequal groups included.",
         "有协同的回报（依赖自身与组员之量的乘积）未陈述；大小不等的组，就组内与组间之分而言未陈述，而经由读数的整体判定（定律 1）对任何列表成立，大小不等的组在内。")''',
'''"Returns with synergy (depending on the product of own and groupmates' amounts) are not stated; for groups of unequal size the returns' among-group part and the verdict through the spread among groups are not stated, while the whole's verdict through a reading's covariation (law 1) holds on any list, the split weighted by size is record selection-within-and-among-groups-of-any-sizes, and within groups the returns go as stated for any sizes.",
         "有协同的回报（依赖自身与组员之量的乘积）未陈述；大小不等的组，回报的组间部分与经由组间离散的判定未陈述，而经由读数协变的整体判定（定律 1）对任何列表成立，按大小加权的分解见记录 selection-within-and-among-groups-of-any-sizes，组内的回报对任何大小如所陈述。")''')
rep('''"Returns with synergy; the split within and among groups of unequal size; how assortment changes over generations; an independent review.",
         "有协同的回报；大小不等之组的组内与组间之分；聚合在世代中如何变化；独立审查。")''',
'''"Returns with synergy; the returns' among-group part for groups of unequal size; how assortment changes over generations; an independent review.",
         "有协同的回报；大小不等之组中回报的组间部分；聚合在世代中如何变化；独立审查。")''')
rep("gives the whole's verdict on any list; narrowed to the split within and among groups;","gives the whole's verdict through a reading's covariation on any list, and the split weighted by size is another record's law; narrowed to the returns' among-group part and the verdict through the spread among groups;")
rep("is stated with [the breeding value](#r-the-breeding-value), cross-multiplied, one amount its case (`Becoming.Reproduction.Breeding.one_amount`). [Record]",
    "is stated with [the breeding value](#r-the-breeding-value), cross-multiplied (`Becoming.Reproduction.Breeding.breeding_balance`; the mean's rise under exact transmission, `Becoming.Reproduction.Breeding.response`), one amount the case of a single pair (`Breeding.one_amount`). [Record]")
rep("(`Becoming.SelectionLevels.rises_iff_reading`), over the rationals where *b* times the regression of the reading on the amount exceeds *k*, so the whole's verdict holds for groups of any sizes.",
    "(`Becoming.SelectionLevels.rises_iff_reading`): over the rationals, where the amount varies, where *b* times the regression of the reading on the amount exceeds *k*. So, with a member's group total as the reading and *k* = *b* + *c*, the whole's verdict through that covariation, though not through the spread among groups, holds for groups of any sizes.")
rep('''"Synergy is not stated, nor the split within and among groups of unequal size. [Record]''',
    '''"Synergy is not stated, nor, for groups of unequal size, the returns' among-group part or the verdict through the spread among groups; the split weighted by size is [the general law](#r-selection-within-and-among-groups-of-any-sizes), and within groups the returns go as stated for any sizes. [Record]''')
rep(""" ],
 'theories/becoming/chapters/03-KNOWING.md': [""",
    """  ("synergy, unequal sizes with returns, groups each counted once.",
   "synergy, the returns' among-group part for unequal sizes, groups each counted once."),
 ],
 'theories/becoming/chapters/03-KNOWING.md': [""")
rep('''("a method for every such union is not shown.",
   "a method for every such union, which formal learning theory gives classically (Putnam 1965; Gold 1967; Kelly 1996), is not shown."),''',
    '''("A reading verified in the limit is a union of closed readings, one refuted in the limit a meet of verifiable ones; a method for every such union is not shown.",
   "A reading verified in the limit is a union of closed readings, one for each horizon, and one refuted in the limit a meet of verifiable ones; a method for every countable union of closed readings (the Σ⁰₂ readings), which formal learning theory gives classically (Kelly 1996, after Putnam 1965 and Gold 1965), is not shown."),''')
rep("edit_record('selection-with-returns-to-groupmates', hamilton)", '''edit_record('selection-with-returns-to-groupmates', hamilton)

def limit(d):
    x = d['does_not_show'][2]
    swap(x, "That a method can be found for every union of closed readings, or that identification follows from deciding each of finitely many hypotheses in the limit.",
         "That a method can be found for every countable union of closed readings (the Σ⁰₂ readings, which formal learning theory verifies classically: Kelly 1996, after Putnam 1965 and Gold 1965), or that identification follows from deciding each of finitely many hypotheses in the limit.",
         "对闭读法的每个可数并（Σ⁰₂ 读法，形式学习理论在经典上证实之：Kelly 1996，承 Putnam 1965 与 Gold 1965）都能找到方法，或由在极限中判定有限多个假说中的每一个即得辨识。")
    d['history'].append({'en': NOTE + "the does-not-show's union of closed readings made countable (every reading of runs is a union of closed ones, recurrence among them) and the classical converse credited, as 03 now does; its laws and their statements are unchanged.",
                         'zh': '2026年11月3日，工作板条目 KS（KD 的读者发现）：“未表明”中闭读法之并改为可数并（运行的每个读法都是闭读法之并，复现在内），并记经典逆命题之出处，与 03 今同；定律及其陈述不变。'})

edit_record('what-a-method-comes-to-say-in-the-limit', limit)''')
open(p,'w',encoding='utf-8').write(s); print('script revised')
