#!/usr/bin/env python3
# AI-written, 13 November 2026 (board item WM2, second part). The questions asked of a selection on the front pages,
# said from the centre paragraph, after three reader rounds on the drafts (rw-one-map/centre-words/readers/). "Four
# questions" now names the four questions for a sentence or a picture (AGENTS.md; 08 section 1), so these are "four
# things to ask". English only; the Chinese twins are set by fronts_zh.py. Each pair is (old, new, expected count).
#   fronts.py <root>
import os, sys
ROOT = sys.argv[1]

Q4 = ('what can make a difference to it; what makes none; whether there is room (is every allowed outcome that leaves more of what makes none beaten, '
      'on what makes a difference, by another?); and, where its rule is set again at each update from the share it already favours, whether it can lock')
Q5 = 'whose judgment can change with the loss, and when'

EDITS = {
    '_process/navigation/README-FIRST-SCREEN.md': [
        ('Its centre: a selection can meet its own criterion while what it cannot read is lost. Whether that loss counts forms within becoming too, in what people and AI come to read; the theorems, which read only the dynamics, do not settle it',
         'Its centre: a selection can go on meeting its own criterion while something is used up whose loss makes no difference to it. Whether that loss counts forms within becoming too, in people and AI; the theorems state the dynamics and do not settle it', 1),
        ('Four questions for any selection, a reward, a judge, a market or a vote: what does it read or need; what lies beyond that; can it do better on what it reads by lowering what lies beyond; can its rule lock on what it already selected. A judge has a fifth: who reads the loss, and when.',
         'Of any selection, a reward, a judge, a market or a vote, ask four things: ' + Q4 + '. Of a judge ask a fifth: ' + Q5 + '.', 1),
        ('[when doing best on what is read must drain what lies beyond]', '[when a selection at its best on what makes a difference to it, with room, leaves what makes none as low as any allowed outcome does]', 1),
        ('), as far as any allowed outcome does, and when a rule read from the share of its own winners, favouring them, locks on them, without noise, while a loss it does not read grows.',
         '), and when a rule set again from the share it already favours stays locked, without noise, however large a loss grows that makes no difference either to what is selected next or to the rule.', 1),
        ('refit to the clicks its own top results draw, its success read from those same clicks,', 'refit to the clicks its top results draw, its success measured by those same clicks,', 1),
    ],
    'theories/becoming/USES.md': [
        ('You can ask four questions of any selection, whether a reward, a judge, a market or a vote: what it reads or needs, what lies beyond that, whether it can do better on what it reads by lowering what lies beyond, and whether its rule can lock on what it already selected. A judge has a fifth: who reads the loss, and when.',
         'Of any selection, whether a reward, a judge, a market or a vote, you can ask four things: ' + Q4 + '. Of a judge, a fifth: ' + Q5 + '.', 1),
    ],
    'theories/becoming/USES-EXAMPLES.md': [
        ('The four questions for any selection, then a fifth for a judge:', 'The four things to ask of any selection, then a fifth for a judge:', 1),
        ('1. **What the judge reads.**', '1. **What makes a difference to the judge.**', 2),
        ('2. **What its selection can reach.**', '2. **What makes no difference to it.**', 2),
        ('5. **Who reads the loss, and when.**', '5. **Whose judgment can change with the loss, and when.**', 2),
        ('| 1. What the judge reads |', '| 1. What makes a difference to the judge |', 1),
        ('| 2. What its selection can reach |', '| 2. What makes no difference to it |', 1),
        ('| 5. Who reads the loss, and when |', '| 5. Whose judgment can change with the loss, and when |', 1),
        ('2. *Who reads the loss, and when?*', '2. *Whose judgment can change with the loss, and when?*', 1),
    ],
    'MAP.md': [
        ('it asks what the selection reads or needs, what lies beyond that, whether it can do better on what it reads by lowering what lies beyond, and whether its rule can lock on what it already selected;',
         'it asks what can make a difference to it, what makes none, whether there is room (every allowed outcome that leaves more of what makes none being beaten on what makes a difference), and, where its rule is set again from the share it already favours, whether it can lock;', 1),
    ],
    'theories/becoming/ONE-PAGE.md': [
        ('| **What sustains it, and what can see its loss?** |', '| **What sustains it, and to what does its loss make a difference?** |', 1),
        ("The selections through a selector's couplings (what it reads or needs), together, reach exactly what couples into it",
         "The selections through a selector's couplings (what can make a difference to it), together, reach exactly what couples into it", 1),
        ('With *room* (every eligible outcome left higher beyond is beaten on what couples in), every optimum of an order rising with what couples in drains what lies beyond as far as any eligible outcome does',
         'With *room* (every eligible outcome that leaves any of what makes no difference higher than another does is beaten on what makes a difference), every optimum of an order rising with what makes a difference, whatever it counts after, leaves the rest as low as any eligible outcome does', 1),
        ('A rule read from the share it raises can lock and outlive a growing loss it does not read',
         'A rule set again only from the share it already favours can lock and, on its conditions, stay locked however large a loss grows that makes no difference either to what is selected next or to the rule', 1),
    ],
    'tools/research/navigation.py': [
        ("'The selections through a selector\\'s couplings (what it reads or needs), together, reach exactly what couples into it'",
         "'The selections through a selector\\'s couplings (what can make a difference to it), together, reach exactly what couples into it'", 1),
        ("'A rule read from the share it raises can lock and outlive a growing loss it does not read'",
         "'A rule set again only from the share it already favours can lock and, on its conditions, stay locked however large a loss grows that makes no difference either to what is selected next or to the rule'", 1),
        ("'With *room* (every eligible outcome left higher beyond is beaten on what couples in), every optimum of an order rising with what couples in drains what lies beyond as far as any eligible outcome does'",
         "'With *room* (every eligible outcome that leaves any of what makes no difference higher than another does is beaten on what makes a difference), every optimum of an order rising with what makes a difference, whatever it counts after, leaves the rest as low as any eligible outcome does'", 1),
    ],
    'tools/research/tests/test_uses_pages.py': [
        ("self.assertIn('four questions of any selection', page(USES))", "self.assertIn('you can ask four things', page(USES))", 1),
        ("self.assertIn('The four questions for any selection, then a fifth for a judge', page(EXAMPLES))", "self.assertIn('The four things to ask of any selection, then a fifth for a judge', page(EXAMPLES))", 1),
    ],
    'tools/research/the_map.py': [
        ('Under each of the four questions stands the number of general theorems that conclude it;', 'Under each of the four marks (begins, lasts, changes, ends) stands the number of general theorems that conclude it;', 1),
        ("It answers none of the '\n        'four questions of the course itself and fills no square.'", "It concludes none of the '\n        'four marks of the course itself and fills no square.'", 1),
    ],
}
log = []
for f, pairs in EDITS.items():
    p = os.path.join(ROOT, f); s = open(p, encoding='utf-8').read()
    for old, new, n in pairs:
        assert s.count(old) == n, (f, old[:70], s.count(old))
        s = s.replace(old, new); log.append((f, n))
    open(p, 'w', encoding='utf-8').write(s)
print('edits', len(log), 'in', len(EDITS), 'files;', sum(n for _f, n in log), 'places')
