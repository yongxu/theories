#!/usr/bin/env python3
# AI-written, 13 November 2026 (board item WM2). The English of the map's lead and first path, said from the centre
# paragraph (development/dw-dualist-wording/centre/BLOCKS.md): a selection; what makes a difference to it; what sustains
# it; the rule as how the selection selects at a step; an update as a step that sets the rule again; "a further premise"
# where the map said "given from outside". Written by the coordinator. Each new string replaces a whole field.
#   english.py <root> apply   -> writes the four data files and old-new.json (every changed field, old and new)
import json, os, sys

ROOT = sys.argv[1]
M = os.path.join(ROOT, 'theories/becoming/results/map')
KIT = '/Users/ren/tmp/rw/wm2'

SHEET_LEAD = ('A map of how anything forms, lasts, changes and ends, drawn so that people and AI can see the way together. Its first path: '
              'a selection (a reward, a judge, a market, a training run) can use up what sustains it while that makes no difference to it; '
              'where each update sets its rule again only from the share it already favours, it goes on the same way; and in built examples '
              'the using up removes those whose judgment the loss would have changed. One way out is proved under its stated conditions alone: '
              'where the loss gets back early enough to change the rest\'s judgments, and the judgments together go against what the rule favoured '
              'at two updates running, the rule turns. No theorem drawn says what brings a loss to get back to those the rule is set from. '
              'Every other way out drawn is proved only with a further premise, or is shown only in a built example or as a reading.')

PASSAGES_ABOUT = ('AI-written. The arrows of the map. kind: law (proved under its stated condition alone), line (a proved boundary: which side a thing is on), '
                  'needs (proved only with a further premise, which the arrow names, or a necessary condition), built (shown only in a built example), '
                  'reading (not proved), same (one box is a case of the other). readers: how many readers set the sentence against the Lean '
                  '(0: no Lean statement, or not yet read).')

ROWS = {'b3': 'Whose judgments the rule is set from', 'bs': 'Whether shaping the rule covers its cost'}
BANDS = {'B': 'What the selecting goes by'}

BOX_NAMES = {
    'b2.uncounted': 'Used up; no difference to the rule',
    'b1.swing': 'Set from the share, not yet locked',
    'b1.held': 'Locked on the share it favours',
    'b1.outside': 'Not set from what it selects',
    'b3.gone': 'None left whose judgment it changes',
    'b3.inside': 'How it is set follows the share too',
    'bs.costs': 'Shaping does not cover its cost',
    'bs.pays': 'Shaping covers its cost',
    'b2.felt': 'Gets back to the rule early enough',
    'b3.rest': 'The rest judge too',
    'b2.counted': 'The loss enters the rule',
    'b3.checkers': 'The checks follow what it favours',
}

BOX_SAYS = {
    'b2.uncounted': 'Something that makes no difference to the rule is used up. Outcomes that differ only in how much is used are selected alike; what that thing sustains bears the loss.',
    'b1.swing': 'Each update sets the rule again from the shares it has brought about, and neither side is locked: the rule can swing back and forth without settling.',
    'b1.held': 'What is selected next follows from what has been selected: the favoured side\'s share and the rule that favours it each keep the other from falling. A push to the rule that leaves it favouring the same side is undone at the next update, whatever its size.',
    'b3.gone': 'Those whose judgment the loss would have changed have been removed by it, or were never among those the rule is set from. The measure is taken only among what is left, so it comes out the same as if nothing were missing.',
    'b3.inside': 'The rule and how it is set again are both formed from the share of what the rule favours. A loss that makes no difference to either can grow without limit while nothing in the loop changes. It is the lock, together with something used up that makes no difference to the rule. The account calls this the meta-attractor in its closed form.',
    'bs.costs': 'Moving the rule toward its side costs what does it more than comes back to it alone, so its share falls.',
    'bs.pays': 'Moving the rule toward its side returns to what does it at least what it costs, so its share does not fall, and rises where it returns more: shaping the rule is itself being selected for.',
    'b2.counted': 'What used to make no difference now enters what the rule is set from, and past some amount the rule stops favouring what it favoured.',
    'b2.heard': 'The loss changes the judgment of some that are not favoured, and they are among those the rule is set from; the rule goes on favouring what it favoured: they are too few, or the loss came to change their judgment too late.',
    'b1.outside': 'What is selected under the rule makes no difference to the rule. Whatever it favours gains share, and only a change to the rule changes what gains.',
    'b3.checkers': 'The ways a loss could come to make a difference (courts, press, statistics, audit) are filled by what the rule favours, or breaking them is what is selected for.',
}

PATH = {
    'en': 'A rule set again from what it already favours',
    'lead_en': 'A reward, a judge, a market, a vote or a training run is a selection: at each step it selects among things by a rule. This path follows a rule that each update sets again from what it already favours: what that uses up, and what turns it.',
    'want_en': ('For people and AI selecting together: what sustains them keeps making a difference, early enough, to how they select; the rule is set from the rest\'s judgments too; '
                'and shaping how they select does not become what they select for. On this map those are the three boxes outlined in green: "The loss enters the rule", "The rest judge too" and '
                '"Shaping does not cover its cost". Four arrows on the whole map lead into the first, two of them on this path. One is proved under its stated conditions alone: where the loss changes '
                'the rest\'s judgments and the judgments taken together go against what the rule favoured, the rule turns. The turn is for good if they still go against it at the next update, '
                'provided the loss goes on changing those judgments and the rest judge no more for the favoured side than that side does. The other three need a further premise. '
                'No arrow drawn leads into the second, and it has no anchor in the Lean yet. One arrow leads into the third, a loss that falls on what shapes the rule, and that too is a further premise. '
                'This is wanted; it is not shown.'),
}

CAST = {  # index -> (en, says_en); None keeps the field
    0: ('the rule', 'how the selection selects at a step: a reward, a score, a price, a count of votes.'),
    1: ('an update', 'a step that sets the rule again; between updates the rule stays as it was. What it is set from differs from step to step of this path, and each step says which: the share it already favours, or judgments.'),
    3: ('the favoured side and its share', 'what goes on more under the rule, and how much of the whole it is.'),
    4: ('the rest', 'what the selection selects among besides the favoured side. Where the rule is set from judgments (steps 7, 9 and 14), the rest judge too, and count by their numbers.'),
    5: ('the loss', 'how much has been used up of something that makes no difference to the rule. What that thing sustains bears it. It is still called the loss once it does make a difference.'),
    6: ('those whose judgment the loss changes', 'any of those the rule is set from whose judgment differs where the loss differs.'),
    7: ('those the rule is set from', 'from their judgments in steps 7, 9 and 14; in steps 8 and 15, from whether each of them keeps going.'),
    8: ('the shapers', 'what spends to move the rule toward its side.'),
    9: ('proved under its stated conditions alone; proved with a further premise',
        'the first: proved under the conditions its sentence gives, with nothing else put in. The second: proved only with a further premise, which the step names: that the loss goes on growing, a way of setting the rule, a measure, a limit, or on whom the loss falls. No theorem drawn says what brings such a premise about. Which premises are marked so is the map\'s own marking, not a difference between two kinds of proof.'),
}

STEPS = {
    1: 'Where something makes no difference to a rule and is being used up, outcomes that differ only in how much of it is used are selected alike; what that thing sustains bears the loss.',
    2: 'Where each update sets the rule again from the favoured side\'s share, and selecting under a rule that favours a side does not lower its share: if every update favours the same side, and no less when its share is larger, the rule is locked from the step after its second update, wherever it started.',
    3: 'A lock in which the loss makes a difference neither to what is selected next nor to how the rule is set runs the same however much is used up. That the loss goes on growing, locked or not, is a premise of the theorems, not proved.',
    4: 'In built examples, what is used up is what sustained those whose judgment the loss would have changed. They are removed.',
    5: 'Once none is left whose judgment the loss changes, and none comes back, a lock that stands stays for good, provided what is used up never lowers the favoured side\'s share.',
    6: 'Where how the rule is set again is formed from that same share too, the loop is closed: from a locked start it stays locked at every step, however far a loss grows that makes no difference to the share or the rule. The account calls this loop the meta-attractor; this is its closed form.',
    7: 'The rule favours those who shape it toward their side exactly where what comes back to them alone covers the cost of shaping. Where each update sets the rule from the judgments of what it has selected, and the shapers judge that return no lower than the rest do, a start at which it covers the cost is locked.',
    8: 'For a rule set only from whether each of those it is set from keeps going: the loss gets back to it early enough exactly where it makes a difference to whether at least one of them keeps going while what is being lost can still be kept.',
    9: 'If the loss changes the rest\'s judgments, and the judgments taken together go against what the rule favoured at this update and the next, the rule turns. The turn is for good provided the loss goes on changing those judgments at every later update and the rest judge no more for the favoured side than that side does.',
    10: 'Or the way the rule is set is one that stops favouring once the loss passes a set amount (a further premise). Then, where the loss goes on growing (a premise too), the lock ends once the loss has passed that amount, however large the favoured side\'s share.',
    11: 'Or the loss falls on the shapers (a further premise). It adds to the cost of shaping, and past a line what comes back to them no longer covers it.',
    12: 'Or whether each keeps going is measured over a fixed list of all that began, not only over what is left (a further premise). Then the measure fails wherever one is removed.',
    13: 'Or only outcomes that keep every need are allowed (a further premise). Then the best outcome by the rule takes only the spare.',
    14: 'If, by the update at which the loss first changes the rest\'s judgments, the judgments taken together already favour what the rule favours, the lock stays (the rest judging no more for the favoured side than that side does).',
    15: 'If the loss makes no difference to whether any of those the rule is set from keeps going until what is being lost can no longer be kept, it gets back early enough to no rule set only from whether they keep going. With room to gain, every best outcome by the rule leaves what makes no difference to it at its lowest allowed level; what that sustains, still needing it, ends where that level is below its need.',
    16: 'In one built example the rule favoured the other side for two updates; but the first side\'s share, grown large, used up what sustained those whose judgment the loss changed. They were gone, and the lock came back for good.',
    17: 'No theorem says what first brings a rule to be set again from the shares it has brought about. Until the first such update it stays as it began, whatever is selected under it.',
    18: 'Two readings, with no theorem behind them. The loop takes in the checks: the ways a loss could come to make a difference are filled by what the rule favours, and then breaking them is what is selected for. And the loop goes on remaking what selects for it while what carries it is replaced.',
}

SHOWS = {
    1: 'Premises of the theorems, not derived (step 3): that what makes no difference to the rule goes on being used up, whether the rule is locked or not; and, where a theorem draws on it, that a larger share uses up no less. No theorem drawn derives either from the lock.',
    2: 'Only in built examples (steps 4, 16): that those whose judgment the loss would change are removed.',
    3: ('The way out. Proved under its stated conditions alone (step 9): exactly when a loss that changes the rest\'s judgments turns the rule for good. Step 8 is a separate theorem, in another model: '
        'when a loss gets back, early enough, to those the rule is set from. No theorem joins the two: taking step 8\'s getting back as the start of step 9\'s change of judgments is a reading. '
        'Every other way out drawn (steps 10 to 13) is proved only with a further premise: a way of setting the rule that stops favouring past a set loss, a loss that falls on what shapes the rule, '
        'a measure over a fixed list, a limit on what is allowed. No theorem drawn says what brings a loss to change the judgment of any of those the rule is set from. '
        'One built case (under step 10) has a lock given up while the loss changed no judgment: the loss fell on what the rule favoured.'),
    4: 'In no theorem (steps 17, 18): what first brings a rule to be set again from the shares it has brought about, and the loop taking in the checks.',
}

ARROWS = {  # key -> dict of fields to set (tag_en, en, more: {index: en})
    'a1.over>b2.uncounted': {'tag_en': 'the same taking, with no difference to a rule',
                             'en': 'The same taking, where a rule is in play and the taking makes no difference to it.'},
    'b1.swing>b1.held': {'en': 'Where selecting under a rule that favours a side does not lower that side\'s share: if every update of the rule favours the same side, and favours it no less when that side\'s share is larger, then every course is locked from the step after its second update. This holds whatever share, rule and way of setting the rule it starts with.'},
    'b1.held>b2.uncounted': {'tag_en': 'a premise, not derived: the loss grows, locked or not',
                             'en': 'That the loss goes on growing is a premise, not derived: the theorems take each step to add to what is used up, whether the rule is locked or not. What they prove is that a lock in which the loss makes a difference neither to what is selected next nor to how the rule is set runs the same however much is used up, so from a locked start it stays while that loss passes every bound. Where it is also a premise that at each step a larger share leaves no less used up, no smaller a share and a rule favouring no less, the course that starts with the larger share has used up no less at every step.'},
    'b2.uncounted>b3.gone': {'tag_en': 'built cases: it sustained those whose judgment the loss would change',
                             'en': 'What is used up is what sustains those whose judgment the loss would change, so using it up removes them. Shown in built cases, and as a reading.'},
    'b3.gone>b3.inside': {'tag_en': 'the loss changes no judgment that is left',
                          'en': 'Once none is left whose judgment the loss changes, and the course brings none back, a lock that stands stays for good, provided what is used up never lowers the favoured side\'s share; where each step adds to the loss (a premise, not derived), the loss meanwhile passes every bound. Whatever the removed would have judged changes nothing.'},
    'b1.held>b3.inside': {'tag_en': 'the same lock, with how the rule is set formed from the share too',
                          'en': 'The same lock, where how the rule is set again is formed from the favoured share too.'},
    'bs.costs>bs.pays': {'en': 'Within one step, the rule favours those shaping it if, and only if, the part of the return that comes back only to them covers the cost. What all get equally makes no difference. A return shared within a group enters by how far the shapers are gathered in the same groups.'},
    'bs.pays>b3.inside': {'tag_en': 'the rule is set from the judgments of what it has selected',
                          'en': 'Where each update sets the rule from the judgments of what it has selected, and those shaping it judge shaping\'s return no lower than the rest do, a start at which that return covers the cost is locked: their share and the rule\'s favour never fall.'},
    'b2.uncounted>b2.felt': {'tag_en': 'does it get back early enough to those the rule is set from?',
                             'en': 'For a rule set only from whether each of those it is set from keeps going: the loss gets back to it early enough if, and only if, the first step at which it makes a difference to whether one of them keeps going comes before the point of no return.'},
    'b3.rest>b2.felt': {'tag_en': 'does it make a difference for at least one of them?',
                        'en': 'Two outcomes differ for those the rule is set from, taken together, if, and only if, they differ for at least one of them.'},
    'b2.felt>b2.counted': {'tag_en': 'the loss changes the rest\'s judgments, and they outweigh',
                           'en': 'Suppose the loss, once it changes the rest\'s judgments, goes on changing them at every later update (in the theorem the loss only grows and none of the rest is removed), and the rest judge no more for the favoured side than that side does. Where judgments taken together then go against what the rule favoured, ties included, the rule turns for good if, and only if, they still go against it at the next update.'},
    'b3.inside>b2.counted': {'tag_en': 'a way of setting the rule that stops favouring past a set loss',
                             'en': 'Suppose the way the rule is set never favours once the loss has passed a set amount, and the loss keeps growing (a premise too). Then the lock ends: once the loss has passed that amount the rule, after every update, no longer favours the side it favoured, however large that side\'s share.',
                             'more': {0: 'Built case: the loss changes no judgment, but it falls on what the rule favours. That side\'s share shrinks for three steps while the lock still stands; then the lock gives way and the rule turns to the other side.'}},
    'bs.pays>bs.costs': {'en': 'A loss falling on what shapes the rule adds to its cost: the rule favours the shapers if, and only if, what comes back to them alone covers both. Past that their share falls. Falling on the rest, the same loss adds to what shaping brings back to the shapers alone.'},
    'b2.uncounted>a2.supplied': {'en': 'Where the allowed outcomes are only those that keep every need on the thing that makes no difference to the rule, with room among them, no best outcome by the rule cuts any of those needs off. Where also the needs were met before the step, each can be left exactly met, and nothing comes from nothing, the best outcome takes exactly the spare above them.'},
    'b2.felt>b2.heard': {'tag_en': 'the loss changes the rest\'s judgments too late',
                         'en': 'Where the rest judge no more for the favoured side than that side does: the lock stays if, and only if, by the update at which the loss first changes the rest\'s judgments, judgments taken together already favour what the rule favours.'},
    'b2.uncounted>a1.past': {'tag_en': 'it makes a difference only when it is too late',
                             'en': 'If the loss makes no difference to whether any of those the rule is set from keeps going until what is being lost can no longer be kept, then it gets back early enough to no rule set only from whether they keep going. The same holds if the only ones the rule is set from are the ones being lost.'},
    'b2.uncounted>a2.ended': {'en': 'With room to gain, every best outcome by the rule leaves the thing that makes no difference to it at its lowest allowed level. What that thing sustains is cut off if, and only if, that level is below its need; still needing it, it stops.'},
    'b2.counted>b3.gone': {'tag_en': 'built case: the larger share removed those whose judgment the loss changed',
                           'en': 'Built case: the rule favoured the other side for two updates. But the first side\'s share, grown large, drew faster on what sustained those whose judgment the loss changed; after two updates they were gone, and the lock returned for good.'},
    'b1.outside>b1.swing': {'tag_en': 'the rule comes to be set again from what is selected under it',
                            'en': 'What is selected under a rule makes a difference to the rule only at a step where the rule is set again from it. Until the first such step the rule stays as it began, whatever is selected. No theorem says what brings such a step.'},
    'b3.inside>b3.checkers': {'tag_en': 'the loop takes in the checks',
                              'en': 'The loop takes in its ways out. First the ways a loss could come to make a difference are filled by what the rule favours; then breaking them is what is selected for. A reading; no theorem.'},
    'b3.checkers>d2.handed': {'tag_en': 'the pattern keeps remaking what selects for it',
                              'en': 'The pattern goes on remaking what selects for it while what carries it is replaced: the meta-attractor in the wide sense. Open; no theorem says this pattern is handed on.'},
}
STAYS = {'b3.inside': 'From a locked start the lock lasts at every step, however far a loss grows that makes no difference to the share or to how the rule is set; where each step adds to that loss (a premise), it passes every bound.'}


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
    json.dump(log, open(KIT + '/old-new.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    print('changed fields:', len(log))


if __name__ == '__main__':
    main()
