#!/usr/bin/env python3
# AI-written, 13 November 2026 (board item WM2), second version after six readers' findings on the first
# (english-v1.py; their reports are tmp/r7/sheet/wm2/check-*.md). The English of the map's lead and first path, said
# from the centre paragraph: a selection; what makes a difference to it; the rule as how the selection selects at a
# step; an update as a step that sets the rule again; the pool as those an update sets the rule from; "a further
# premise" where the map said "given from outside". Kept from the old wording wherever it was already sound: the rest
# "count the loss" (the theorems do not ask that their judgment changes), "what lives on it", "gets back".
# Written by the coordinator. Each new string replaces a whole field.
#   english.py <root>   -> writes the data files, the tool's legend strings, and old-new.json (every changed field)
import json, os, re, sys

ROOT = sys.argv[1]
M = os.path.join(ROOT, 'theories/becoming/results/map')
T = os.path.join(ROOT, 'tools/research')
KIT = '/Users/ren/tmp/rw/wm2'

SHEET_LEAD = ('A map of how anything forms, lasts, changes and ends, drawn so that people and AI can see the way together. Its first path: '
              'a selection (a reward, a judge, a market, a training run) can use up something that makes no difference to it, which others live on; '
              'where each update sets its rule again from the shares selected under it, the rule can lock; and in built examples the using up removes '
              'those that would have counted the loss. One way out is proved from conditions on the loss and the judgments alone: where the rest count the loss, '
              'and the judgments together go against what the rule favoured at two updates running, the rule turns. No theorem drawn says what brings a loss '
              'to get back to those the rule is set from, or to be counted. Every other way out drawn is proved only with a further premise '
              '(how the rule is set, what is measured or allowed, or where the loss falls), or is shown only in a built example or as a reading.')

PASSAGES_ABOUT = ('AI-written. The arrows of the map. kind: law (proved under the conditions its sentence gives), line (a proved boundary: which side a thing is on), '
                  'needs (proved only with a further premise, which the arrow names, or a necessary condition), built (shown only in a built example), '
                  'reading (not proved), same (one box is a case of the other). readers: how many readers set the sentence against the Lean '
                  '(0: no Lean statement, or not yet read).')

ROWS = {'b3': 'What the rule is set from', 'bs': 'Whether shaping the rule keeps the shapers\' share'}
BANDS = {'B': 'What the selecting goes by'}

BOX_NAMES = {
    'b2.uncounted': 'Used up; no difference to the rule',
    'b1.swing': 'Set from the share, not yet locked',
    'b1.held': 'Locked',
    'b1.outside': 'Not set from what it selects',
    'b3.gone': 'None left that would count the loss',
    'b3.inside': 'Its updating follows the share too',
    'bs.costs': 'Shaping the rule loses share',
    'bs.pays': 'Shaping the rule keeps share',
    'b2.felt': 'Gets back to the rule early enough',
    'b3.rest': 'The rest judge too',
    'b2.counted': 'The loss makes a difference',
    'b3.checkers': 'The checks follow what it favours',
}

BOX_SAYS = {
    'b2.uncounted': 'Something is used up, and how much is left of it makes no difference to the rule. Outcomes that differ only in that are selected alike; what lives on that thing bears the loss.',
    'b1.swing': 'Each update sets the rule again from the shares selected under it, and neither side is locked: the rule can swing back and forth without settling.',
    'b1.held': 'What is selected next follows from what has been selected: the favoured side\'s share and the rule that favours it each keep the other from falling. A change to the rule that leaves it favouring the same side is absorbed at the next update: the rule is set again from the share, no lower than before, and locked again.',
    'b3.gone': 'Those that would have counted the loss have been removed by it, or were never in the pool. The measure is taken only among what is left, so nothing is recorded as missing.',
    'b3.inside': 'The rule and the way it is updated are both formed from the share of what the rule favours. A loss that changes neither what is selected next nor how the rule is set can grow without limit while the loop runs as it would with no loss. It is the lock, together with something used up that makes no difference to the rule. The account calls this the meta-attractor in its closed form.',
    'bs.costs': 'Shaping the rule to favour the shapers more costs them more than comes back to them alone, so, where any are present, their share falls.',
    'bs.pays': 'Shaping the rule to favour the shapers more brings back to them alone at least what it costs, so their share does not fall and, where any are present, rises where it brings back more: the shapers gain share by shaping.',
    'b2.counted': 'What used to make no difference to the rule now makes a difference to how it is set, and past some amount the rule stops favouring what it favoured.',
    'b2.heard': 'Some of the rest count the loss and are in the pool, and the rule goes on favouring what it favoured: they are too few, or began to count it too late.',
    'b1.outside': 'What is selected under the rule makes no difference to the rule. Whatever it favours does not lose share, and only a change to the rule changes which side that is.',
    'b3.checkers': 'The ways a loss could come to count (courts, press, statistics, audit) are filled by what the rule favours, or breaking them is what the rule favours.',
}

PATH = {
    'en': 'A rule set from the shares selected under it',
    'lead_en': 'A reward, a judge, a market, a vote or a training run is a selection: at each step it selects among things by a rule. This path follows what can happen to such a rule where updates set it again from the shares selected under it, and what turns it.',
    'want_en': ('For people and AI selecting together: a selection in which what is used up makes a difference to how the rule is set, the rest count too when it is set, '
                'and shaping the rule loses share. On this map those are the three boxes outlined in green: "The loss makes a difference", "The rest judge too" and '
                '"Shaping the rule loses share". Four arrows on the whole map lead into the first, two of them on this path. One is proved with no further premise: '
                'where the rest count the loss and the judgments taken together go against what the rule favoured, the rule turns. The turn is for good if they still go against it '
                'at the next update, provided the rest go on counting the loss and judge no more for the favoured side than that side does. The other three need a further premise. '
                'No arrow drawn leads into the second, and it has no anchor in the Lean yet. One arrow leads into the third, a loss that falls on what shapes the rule, '
                'and that too needs a further premise. This is wanted; it is not shown.'),
}

CAST = {  # index -> (en, says_en)
    0: ('the rule', 'how the selection selects at a step: a reward, a score, a price, a count of votes.'),
    1: ('an update', 'a step that sets the rule again; between updates the rule stays as it was. What it is set from differs from step to step of this path, and each step says which: the shares selected under it, judgments, or which of the pool keep going.'),
    3: ('the favoured side and its share', 'the side the rule favours, and how much of the whole it is.'),
    4: ('the rest', 'what the selection selects among besides the favoured side. Where the rule is set from the judgments of what it has selected (steps 7, 9 and 14), the rest judge too, and count by their numbers.'),
    5: ('the loss', 'how much has been used up of something whose level makes no difference to the rule. Whatever lives on that thing bears the loss. The name stays once it does make a difference.'),
    6: ('those that count the loss', 'those in the pool that judge one way until the loss has passed a set amount and another way after it. The theorems do not ask that the two ways differ. In the built examples they judge against the favoured side, and the loss removes them.'),
    7: ('the pool', 'those an update sets the rule from. In steps 7, 9 and 14: what the selection has selected, each with a judgment, counted by their numbers. In steps 8 and 15: which of them keep going.'),
    8: ('the shapers', 'what spends to make the rule favour it more.'),
    9: ('proved; proved only with a further premise',
        'Unmarked steps are proved under the conditions their sentences give; from step 3 on, where they speak of the loss growing, under the premise stated there. A step marked as needing a further premise is proved only with one more assumption about the set-up, which it names: a way of setting the rule, a measure, a limit, or where the loss falls (in step 3, that the loss goes on growing; in step 17, that such an update comes). The marking is the map\'s own, not a difference between two kinds of proof.'),
}

STEPS = {
    1: 'Where something is being used up and how much is left of it makes no difference to a rule, outcomes that differ only in that are selected alike; whatever lives on that thing bears the loss.',
    2: 'Suppose each update sets the rule again from the favoured side\'s share, and being favoured never lowers a share. If every update favours the same side, and no less when its share is larger, the rule is locked from the step after its second update, wherever it started.',
    3: 'If the loss changes neither what is selected next nor how the rule is set, a lock runs the same however much is used up. That the loss goes on growing, locked or not, is a premise of the theorems, not proved.',
    4: 'In built examples, what is used up is what those that would have counted the loss lived on. They are removed.',
    5: 'Once none is left that counts the loss, and none comes back, a lock that stands stays for good, provided being favoured, with what is used up, never lowers that side\'s share.',
    6: 'Where the way the rule is updated is itself formed from that same share, the loop is closed: from a locked start it stays locked at every step, however far a loss grows that changes neither what is selected next nor how the rule is set. The account calls this loop the meta-attractor; this is its closed form.',
    7: 'The rule favours the shapers exactly where what comes back to them alone covers the cost of shaping. Where each update sets the rule from the judgments of what it has selected, and the shapers judge that return no lower than the rest do, a start at which the rule so set favours the shapers is locked.',
    8: 'Take a rule set only from which of the pool keep going. The loss can get back to it early enough exactly where, while what is being lost can still be kept, it changes whether at least one of them keeps going.',
    9: 'If the rest count the loss, each step adding to it, and at this update and the next the judgments taken together go against what the rule favoured, the rule turns. The turn is for good provided the rest go on counting the loss and judge no more for the favoured side than that side does.',
    10: 'Or the rule is set in a way that stops favouring once the loss passes a set amount. Then, where the loss goes on growing, the lock ends once the loss has passed that amount, however large the favoured side\'s share.',
    11: 'Or the loss falls on the shapers. It adds to the cost of shaping, and past a line the rule no longer favours them and their share falls.',
    12: 'Or whether each keeps going is measured over a fixed list of all that began, not only over what is left. Then the measure does not hold wherever one is removed.',
    13: 'Or only outcomes that keep every need are allowed. Then the best outcome by the rule takes only the spare.',
    14: 'If, by the time the rest begin to count the loss, the judgments taken together already favour what the rule favours, the lock stays (the rest judging no more for the favoured side than that side does).',
    15: 'If, until what is being lost can no longer be kept, the loss changes nothing about which of the pool keep going, it gets back too late to any rule set only from that. With room to gain, every best outcome by the rule leaves what the rule ranks nothing by at its lowest allowed level; what lives on that, still needing it, ends where that level is below its need.',
    16: 'In one built example the rule favoured the other side at two steps; but the first side\'s share, grown large, used up what those that judged against it lived on. They were gone, and from the next step the lock was back for good.',
    17: 'No theorem says what first brings a rule to be set again from the shares selected under it (that such an update comes is the further premise). What is proved: until the first such update the rule stays as it began, whatever is selected under it.',
    18: 'Two readings, with no theorem behind them. The checks too come to follow what the rule favours: the ways a loss could come to count are filled by what the rule favours, and breaking them is itself what the rule favours. And the loop goes on remaking the selection that favours it while what carries it is replaced.',
}

SHOWS = {
    1: 'Premises of the theorems, not derived (step 3): that something whose level makes no difference to the rule goes on being used up, whether the rule is locked or not; and, where a theorem draws on it, that a larger share uses up no less. No theorem drawn derives either from the lock.',
    2: 'Only in built examples (steps 4, 16): that those that would count the loss are removed.',
    3: ('The way out. Proved with no further premise (step 9): where the rest count the loss and the judgments went against what the rule favoured at one update, the rule turns for good '
        'exactly where they still do at the next. Step 8 is a separate theorem, in another model: when a loss can get back, early enough, to a rule set from which of the pool keep going. '
        'No theorem joins the two: taking step 8\'s getting back as the start of step 9\'s counting is a reading. Every other way out drawn (steps 10 to 13) is proved only with a further premise: '
        'a way of setting the rule that stops favouring past a set loss, a loss that falls on what shapes the rule, a measure over a fixed list, a limit on what is allowed. '
        'No theorem drawn says what brings a loss to get back to the pool, or to be counted. One built case (under step 10) has a lock given up with none counting the loss: '
        'the loss fell on what the rule favoured.'),
    4: 'In no theorem (steps 17, 18): what first brings a rule to be set again from the shares selected under it, and the checks coming to follow what the rule favours.',
}

ARROWS = {
    'a1.over>b2.uncounted': {'tag_en': 'the same taking, with no difference to a rule',
                             'en': 'The same taking, where a rule is in play and how much is left makes no difference to it.'},
    'b1.swing>b1.held': {'en': 'Where being favoured never lowers a share: if every update of the rule favours the same side, and favours it no less when that side\'s share is larger, then every course is locked from the step after its second update. This holds whatever share, rule and way of updating it starts with.'},
    'b1.held>b2.uncounted': {'tag_en': 'a premise, not derived: the loss grows, locked or not',
                             'en': ('That the loss goes on growing is a premise, not derived: the theorems take each step to add to what is used up, whether the rule is locked or not. '
                                    'What they prove is that where the loss changes neither what is selected next nor how the rule is set, the course runs as it would with no loss; so, under step 2\'s premises, '
                                    'from a locked start the lock stays while that loss passes every bound. A further theorem compares two courses in which those that count the loss stand until it reaches a bound: '
                                    'where it is also a premise that a share, loss and rule no lower leave a share no lower and no less used up, and that their judgment rises with share and loss and is never more '
                                    'for the favoured side than the share\'s own, the course that starts no lower in share, loss and rule, its counters removed no later, is no lower in all three at every step.')},
    'b2.uncounted>b3.gone': {'tag_en': 'built cases: those that would count the loss lived on it',
                             'en': 'What is used up is what those that would count the loss live on, so using it up removes them. Shown in built cases, and as a reading.'},
    'b3.gone>b3.inside': {'tag_en': 'none left counts the loss',
                          'en': 'Once none is left that counts the loss, and the course brings none back, a lock that stands stays for good, provided being favoured, with what is used up, never lowers that side\'s share; where each step adds to the loss (a premise, not derived), the loss meanwhile passes every bound. Whatever the removed would have judged changes nothing.'},
    'b1.held>b3.inside': {'tag_en': 'the same lock, with the way the rule is updated formed from the share too',
                          'en': 'The same lock, where the way the rule is updated is formed from the favoured share too.'},
    'bs.costs>bs.pays': {'en': 'Within one step, the rule favours those shaping it if, and only if, the part of the return that comes back only to them covers the cost. What all get equally does not change which side the rule favours at that step. A return shared within a group counts by how far the shapers are gathered in the same groups.'},
    'bs.pays>b3.inside': {'tag_en': 'the rule is set from the judgments of what it has selected',
                          'en': 'Where each update sets the rule from the judgments of what it has selected, and those shaping it judge shaping\'s return no lower than the rest do, a start at which the rule so set favours the shapers is locked: their share and the rule\'s favour never fall.'},
    'b2.uncounted>b2.felt': {'tag_en': 'can it get back to the pool early enough?',
                             'en': 'For a rule set only from which of the pool keep going: the loss can get back to it early enough if, and only if, the first step at which it makes a difference to whether one of them keeps going comes before the point of no return.'},
    'b3.rest>b2.felt': {'tag_en': 'does it differ for at least one of the pool?',
                        'en': 'A rule set from the whole pool, a finite list, can select two courses differently up to a step if, and only if, the two differ up to that step for at least one of the pool.'},
    'b2.felt>b2.counted': {'en': 'Suppose the rest, once they count the loss, go on counting it at every later update (in the theorem the loss only grows and none of the rest is removed), and judge no more for the favoured side than that side does. Where judgments taken together then go against what the rule favoured, ties included, the rule turns for good if, and only if, they still go against it at the next update.'},
    'b3.inside>b2.counted': {'tag_en': 'a way of setting the rule that stops favouring past a set loss',
                             'en': 'Suppose the rule is set in a way that never favours once the loss has passed a set amount, and the loss keeps growing (a premise too). Then the lock ends: once the loss has passed that amount the rule, after every update, no longer favours the side it favoured, however large that side\'s share.',
                             'more': {0: 'Built case: none counts the loss, but it falls on what the rule favours. That side\'s share shrinks for three steps while the lock still stands; then the lock gives way and the rule turns to the other side.'}},
    'bs.pays>bs.costs': {'en': 'A loss falling on what shapes the rule adds to its cost: the rule favours the shapers if, and only if, what comes back to them alone covers both. Past that, where any shaper is present, their share falls. Falling on the rest, the same loss counts as coming back to the shapers alone: the rule favours them if, and only if, what comes back to them alone, with the loss, covers the cost.'},
    'b2.uncounted>a2.supplied': {'en': 'Where the allowed outcomes are only those that keep every need on what the rule ranks nothing by, with room among them, no best outcome by the rule cuts any of those needs off. Where also the needs were met before the step, each can be left exactly met, and nothing comes from nothing, the best outcome takes exactly the spare above them.'},
    'b2.felt>b2.heard': {'en': 'Where the rest judge no more for the favoured side than that side does: the lock stays if, and only if, by the time the rest begin to count the loss, judgments taken together already favour what the rule favours.'},
    'b2.uncounted>a1.past': {'tag_en': 'it makes a difference only when it is too late',
                             'en': 'If the loss makes no difference to whether any of the pool keeps going until what is being lost can no longer be kept, then it gets back too late to any rule set only from which of them keep going. The same holds if the only ones in the pool are the ones being lost.'},
    'b2.uncounted>a2.ended': {'en': 'With room to gain, every best outcome by the rule leaves what the rule ranks nothing by at its lowest allowed level. What lives on that is cut off if, and only if, that level is below its need; still needing it, it stops.'},
    'b2.counted>b3.gone': {'tag_en': 'built case: the larger share removed those that judged against it',
                           'en': 'Built case: the rule favoured the other side at two steps. But the first side\'s share, grown large, drew faster on what those that judged against it lived on; they were gone, and from the next step the lock was back for good.'},
    'b1.outside>b1.swing': {'tag_en': 'the rule comes to be set again from what is selected under it',
                            'en': 'What is selected under a rule makes a difference to the rule only at a step where the rule is set again from it. Until the first such step the rule stays as it began, whatever is selected. No theorem says what brings such a step.'},
    'b3.inside>b3.checkers': {'tag_en': 'the checks too come to follow what the rule favours',
                              'en': 'The checks too come to follow what the rule favours: the ways a loss could come to count are filled by what the rule favours, and breaking them is itself what the rule favours. A reading; no theorem.'},
    'b3.checkers>d2.handed': {'tag_en': 'the pattern keeps remaking the selection that favours it',
                              'en': 'The pattern goes on remaking the selection that favours it while what carries it is replaced: the meta-attractor in the wide sense. Open; no theorem says this pattern is handed on.'},
}
STAYS = {'b3.inside': 'From a locked start the lock lasts at every step, however far a loss grows that changes neither what is selected next nor how the rule is set; where each step adds to that loss (a premise), it passes every bound.'}

# the same marking in the other paths' summaries
OTHER_SHOWS = [(r'[Pp]roved only with something given from outside(?: the course)?', None),
               ('only regrowth is proved of the course itself (step 12)', 'only regrowth is proved with no further premise (step 12)'),
               ('Proved of the course itself, each under the condition its sentence gives', 'Proved with no further premise, each under the condition its sentence gives')]

TOOL = {
    'map_sheet.py': [
        ("# not proved of the course itself: a hollow number", "# needs a further premise, or is a built example or a reading: a hollow number", 1),
        ("'needs': 'proved only with something given from outside'", "'needs': 'proved only with a further premise'", 1),
        ("dashed where it is proved only with something given from outside, dotted", "dashed where it is proved only with a further premise, which the arrow names, dotted", 1),
        ("a hollow number marks a step that is not proved of the course itself.", "a hollow number marks a step that needs a further premise, or is shown only in a built example or as a reading.", 1),
        ("(boundaries and the last band apart): %(rl)d of the %(r)d that run right are proved of the course itself; of the %(l)d that run back, %(ll)d are, %(ln)d need something given from outside and",
         "(boundaries, cases of another and the last band apart): %(rl)d of the %(r)d that run right are proved with no further premise; of the %(l)d that run back, %(ll)d are, %(ln)d need a further premise and", 1),
        ("'needs': '已证明，但要有过程之外给定的东西'", "'needs': '已证明，但另需一个前提'", 1),
        ("虚线是已证明、但要有过程之外给定的东西；", "虚线是已证明、但另需一个前提（箭头写明是哪一个）；", 1),
        ("标的是没有就过程本身证明的那几步。", "标的是另需一个前提、或只见于造出来的例子、或只是一种解读的那几步。", 1),
        ("%(rl)d 条是就过程本身证明的；往回的 %(l)d 条里，这样的有 %(ll)d 条，%(ln)d 条要有过程之外给定的东西，", "%(rl)d 条不另需前提就已证明；往回的 %(l)d 条里，这样的有 %(ll)d 条，%(ln)d 条另需一个前提，", 1),
    ],
    'map_sheet.html': [
        ("needs: 'proved, but only with something given from outside the course'", "needs: 'proved, but only with a further premise, which the arrow names'", 1),
        ("mk_needs: 'needs something given from outside'", "mk_needs: 'needs a further premise'", 1),
        ("dashed where it is proved only with something given from outside, dotted", "dashed where it is proved only with a further premise, dotted", 1),
        ("a hollow number marks a step that is not proved of the course itself.", "a hollow number marks a step that needs a further premise, or is shown only in a built example or as a reading.", 1),
        ("needs: '已证明，但要有过程之外给定的东西'", "needs: '已证明，但另需一个前提'", 1),
        ("mk_needs: '要有过程之外给定的东西'", "mk_needs: '另需一个前提'", 1),
        ("虚线是已证明、但要有过程之外给定的东西；", "虚线是已证明、但另需一个前提；", 1),
        ("标的是没有就过程本身证明的那几步。", "标的是另需一个前提、或只见于造出来的例子、或只是一种解读的那几步。", 1),
    ],
    'tests/test_map_sheet.py': [
        ("most that run right are proved of the course itself; most that run back need something given, or are built",
         "most that run right are proved with no further premise; most that run back need a further premise, or are built", 1),
    ],
}


def main():
    S = json.load(open(M + '/sheet.json', encoding='utf-8')); P = json.load(open(M + '/paths.json', encoding='utf-8'))
    A = json.load(open(M + '/passages.json', encoding='utf-8'))
    log = []

    def put(obj, field, new, where):
        old = obj[field]
        if old != new:
            log.append({'where': where, 'field': field, 'old': old, 'new': new})
            obj[field] = new

    put(S, 'lead_en', SHEET_LEAD, 'sheet')
    put(A, 'about', PASSAGES_ABOUT, 'passages')
    for r in S['rows']:
        if r['id'] in ROWS: put(r, 'en', ROWS[r['id']], 'row ' + r['id'])
    for b in S['bands']:
        if b['id'] in BANDS: put(b, 'en', BANDS[b['id']], 'band ' + b['id'])
    box = {b['id']: b for b in S['boxes']}
    for k, v in BOX_NAMES.items(): put(box[k], 'en', v, 'box ' + k)
    for k, v in BOX_SAYS.items(): put(box[k], 'says_en', v, 'box ' + k)
    lock = next(p for p in P['paths'] if p['id'] == 'lock')
    for f, v in PATH.items(): put(lock, f, v, 'path lock')
    for i, (en, says) in CAST.items():
        put(lock['cast'][i], 'en', en, 'path lock cast %d' % i); put(lock['cast'][i], 'says_en', says, 'path lock cast %d' % i)
    steps = [s for sec in lock['sections'] for s in sec['steps']]
    assert len(steps) == 18
    for n, v in STEPS.items(): put(steps[n - 1], 'say_en', v, 'path lock step %d' % n)
    for i, v in SHOWS.items(): put(lock['shows_en'], i, v, 'path lock shows %d' % i)
    for p in P['paths']:
        if p['id'] == 'lock': continue
        for i, s in enumerate(p['shows_en']):
            new = re.sub(r'Proved only with something given from outside(?: the course)?', 'Proved only with a further premise', s)
            new = re.sub(r'proved only with something given from outside(?: the course)?', 'proved only with a further premise', new)
            for a, b in OTHER_SHOWS[1:]: new = new.replace(a, b)
            put(p['shows_en'], i, new, 'path %s shows %d' % (p['id'], i))
    arr = {p['from'] + '>' + p['to']: p for p in A['passages']}
    for k, d in ARROWS.items():
        a = arr[k]
        for f in ('tag_en', 'en'):
            if f in d: put(a, f, d[f], 'arrow ' + k)
        for i, v in (d.get('more') or {}).items(): put(a['more'][i], 'en', v, 'arrow %s more %d' % (k, i))
    st = {s['at']: s for s in A['stays']}
    for k, v in STAYS.items(): put(st[k], 'en', v, 'stay ' + k)
    for name, d in (('sheet', S), ('paths', P), ('passages', A)):
        open('%s/%s.json' % (M, name), 'w', encoding='utf-8').write(json.dumps(d, ensure_ascii=False, indent=1))
    for f, pairs in TOOL.items():
        p = os.path.join(T, f); s = open(p, encoding='utf-8').read()
        for old, new, n in pairs:
            assert s.count(old) == n, (f, old[:60], s.count(old))
            s = s.replace(old, new)
        open(p, 'w', encoding='utf-8').write(s)
    json.dump(log, open(KIT + '/old-new.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    print('changed data fields:', len(log))


if __name__ == '__main__':
    main()
