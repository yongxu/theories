#!/usr/bin/env python3
# AI-written, 13 November 2026 (board item WM2, second part). The things asked of a selection on the front pages,
# said from the centre paragraph. This is the English as landed: the first version (fronts-v1.py) was read by four
# AI readers (rw-one-map/centre-words/readers/check4-*.md), the second (fronts-v2.py) by one more (check5-english.md),
# and this one takes their findings. "Four questions" now
# names the four questions for a sentence or a picture (AGENTS.md; 08 section 1), so these are "four things to ask".
# English only; the Chinese twins are set by fronts_zh.py. Each pair is (old on main, new, expected count).
#   fronts.py <root>
import os, sys
ROOT = sys.argv[1]

ROOM = ('wherever one allowed outcome leaves any of what makes none higher than another does, %s no lower than the first '
        'on anything that makes a difference and higher on something')
Q4 = ('what can make a difference to it; what makes none; whether there is room (' + ROOM % 'is some allowed outcome' + '?); '
      'and, where its rule is set again only from the share it already favours, whether it can lock')
Q5 = 'whose judgment, among those its verdict is made from, can change as %s loss grows, and when'
ONE_COUPLINGS = "The selections through a selector%s couplings (what can make a difference to it), together, reach exactly what couples into it"
ONE_ROOM = ('With *room* (wherever an eligible outcome leaves any of what makes no difference to the selector higher than another does, '
            'some eligible outcome is no lower than the first on anything that does make a difference and higher on something), '
            'every optimum of an order rising with what makes a difference leaves each thing that makes none as low as any eligible outcome leaves it')
ONE_LOCK = ('A rule set again only from the share it already favours can lock and, on the theorem%s three conditions, stay locked '
            'however large a loss grows that makes no difference either to what is selected next or to the rule')
OLD_COUPLINGS = "The selections through a selector%s couplings (what it reads or needs), together, reach exactly what couples into it"
OLD_ROOM = ('With *room* (every eligible outcome left higher beyond is beaten on what couples in), every optimum of an order rising with what couples in '
            'drains what lies beyond as far as any eligible outcome does')
OLD_LOCK = 'A rule read from the share it raises can lock and outlive a growing loss it does not read'

EDITS = {
    '_process/navigation/README-FIRST-SCREEN.md': [
        ('Its centre: a selection can meet its own criterion while what it cannot read is lost. Whether that loss counts forms within becoming too, in what people and AI come to read; the theorems, which read only the dynamics, do not settle it',
         'Its centre: a selection can go on meeting its own criterion while something is being used up, even what sustains it, for as long as how much is left makes no difference to it. Whether that loss counts forms within becoming too, in people and AI; the theorems about the dynamics alone do not settle it', 1),
        ('Four questions for any selection, a reward, a judge, a market or a vote: what does it read or need; what lies beyond that; can it do better on what it reads by lowering what lies beyond; can its rule lock on what it already selected. A judge has a fifth: who reads the loss, and when.',
         'Of any selection, a reward, a judge, a market or a vote, ask four things: ' + Q4 + '. Of a judge ask a fifth: ' + Q5 % 'the' + '.', 1),
        ('[when doing best on what is read must drain what lies beyond]',
         '[that a selection at its best on what makes a difference to it, where there is room, leaves each thing that makes none as low as any allowed outcome leaves it]', 1),
        ('), as far as any allowed outcome does, and when a rule read from the share of its own winners, favouring them, locks on them, without noise, while a loss it does not read grows.',
         "), and that a rule set again only from the share it already favours, once locked, stays locked on three conditions named there, without noise, however large a loss grows that makes no difference either to what is selected next or to the rule.", 1),
        ('refit to the clicks its own top results draw, its success read from those same clicks,', 'refit to the clicks its top results draw, its success measured by those same clicks,', 1),
    ],
    'theories/becoming/USES.md': [
        ('You can ask four questions of any selection, whether a reward, a judge, a market or a vote: what it reads or needs, what lies beyond that, whether it can do better on what it reads by lowering what lies beyond, and whether its rule can lock on what it already selected. A judge has a fifth: who reads the loss, and when.',
         'Of any selection, whether a reward, a judge, a market or a vote, you can ask four things: ' + Q4 + '. Of a judge, a fifth: ' + Q5 % 'a' + '.', 1),
    ],
    'theories/becoming/USES-EXAMPLES.md': [
        ('07 §6 reads the first question, what the signal reads, for six published pipelines', '07 §6 reads the first question, what can make a difference to the signal, for six published pipelines', 1),
        ('The four questions for any selection, then a fifth for a judge: theorems answer the second, third and fourth on their premises; the first is a reading, and the fifth is an empirical question.',
         'The four things to ask of any selection, then a fifth for a judge: a theorem answers the second; for the third and fourth, theorems say what follows where their premises hold; the first is a reading, and the fifth is an empirical question.', 1),
        ('1. **What the judge reads.**', '1. **What can make a difference to the judge.**', 2),
        ('2. **What its selection can reach.**', '2. **What makes no difference to it.**', 2),
        ('5. **Who reads the loss, and when.**', '5. **Whose judgment can change with the loss, and when.**', 2),
        ('| 1. What the judge reads |', '| 1. What can make a difference to the judge |', 1),
        ('| 2. What its selection can reach |', '| 2. What makes no difference to it |', 1),
        ('| 5. Who reads the loss, and when |', '| 5. Whose judgment can change with the loss, and when |', 1),
        ('2. *Who reads the loss, and when?*', '2. *Whose judgment can change with the loss, and when?*', 1),
    ],
    'MAP.md': [
        ('it asks what the selection reads or needs, what lies beyond that, whether it can do better on what it reads by lowering what lies beyond, and whether its rule can lock on what it already selected; from it we [want to design]',
         'it asks what can make a difference to the selection, what makes none, whether there is room (' + ROOM % 'some allowed outcome is' + '), '
         'and, where its rule is set again only from the share it already favours, whether it can lock; from the map we [want to design]', 1),
    ],
    'theories/becoming/ONE-PAGE.md': [
        ('| **What sustains it, and what can see its loss?** |', '| **What sustains it, and to what does its loss make a difference?** |', 1),
        (OLD_COUPLINGS % "'s", ONE_COUPLINGS % "'s", 1),
        (OLD_ROOM, ONE_ROOM, 1),
        (OLD_LOCK, ONE_LOCK % "'s", 1),
    ],
    'tools/research/navigation.py': [
        ("'" + OLD_COUPLINGS % "\\'s" + "'", "'" + ONE_COUPLINGS % "\\'s" + "'", 1),
        ("'" + OLD_LOCK + "'", "'" + ONE_LOCK % "\\'s" + "'", 1),
        ("'" + OLD_ROOM + "'", "'" + ONE_ROOM + "'", 1),
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
if __name__ == '__main__':
    log = []
    for f, pairs in EDITS.items():
        p = os.path.join(ROOT, f); s = open(p, encoding='utf-8').read()
        for old, new, n in pairs:
            assert s.count(old) == n, (f, old[:70], s.count(old))
            s = s.replace(old, new); log.append((f, n))
        open(p, 'w', encoding='utf-8').write(s)
    print('edits', len(log), 'in', len(EDITS), 'files;', sum(n for _f, n in log), 'places')
