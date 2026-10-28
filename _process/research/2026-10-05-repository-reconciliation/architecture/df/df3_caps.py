#!/usr/bin/env python3
"""DF3: two Chinese evidence paragraphs brought back within the 260-character cap after the cold read
(the receipt named in one, the checker named in the other); the English is unchanged."""
import json
R = 'theories/becoming/results/records/'


def fix(i, pairs):
    p = R + i + '.json'
    d = json.load(open(p))
    z = d['validation_scope']['zh']
    for a, b in pairs:
        assert z.count(a) == 1, (i, a)
        z = z.replace(a, b)
    assert len(z) <= 260
    d['validation_scope']['zh'] = z
    open(p, 'w').write(json.dumps(d, ensure_ascii=False, indent=2) + '\n')


fix('joint-code-plan-lifting', [('Becoming.Composition、Becoming.JointCorrespondence 与 Becoming.JointPlans', 'Composition、JointCorrespondence 与 JointPlans'),
                                ('Becoming.Likeness 绑定', 'Likeness 绑定')])
fix('effective-capacity-and-eventual-reachability',
    [('核心 ActivationCapacity、Labelled、Bundles 由合并检查器（becoming-checks/），GenerativeCore 由 RelationalBecoming 检查（relational-becoming-checks/），所引声明公理报告皆空',
      '核心 ActivationCapacity、Labelled、Bundles（合并检查器，becoming-checks/）与 GenerativeCore（RelationalBecoming 检查，relational-becoming-checks/）所引声明公理报告皆空'),
     ('和／或', '或'), ('不另计成果', '不另计')])
