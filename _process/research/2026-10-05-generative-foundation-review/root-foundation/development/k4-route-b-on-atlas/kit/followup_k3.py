"""K4's follow-up: K3's reading in time on the atlas, and the two open items K1 and K3 now partly answer. Run from the
checkout root. Writes dynamics.json in its own format."""
import json
from pathlib import Path

ENTRIES = Path('theories/becoming/results/atlas/entries/dynamics.json')
CH = 'theories/becoming/chapters/07-SIGNIFICANCE.md'
REC = 'theories/becoming/results/records/'
DNS = '.md#does-not-show--未表明'
B = 'Becoming.'
src = ENTRIES.read_text(encoding='utf-8')
d = json.loads(src)
assert json.dumps(d, ensure_ascii=False, indent=1) + '\n' == src
by = {e['id']: e for e in d}
t = lambda s: {'en': s}  # noqa: E731


def x(to, law, strength, edge, records, source, seen=None):
    e = {'to': to if isinstance(to, str) else t(to[0]), 'law': law, 'edge': t(edge), 'strength': strength,
         'records': records, 'source': source}
    if seen:
        e['standing_without_law'] = seen
    return e


R1, R2, R3 = 'when-a-selection-read-off-continuation-reads', 'a-loss-read-before-its-point-of-no-return', 'the-route-is-the-relation-in-time'
reading = {
    'id': 'reading-a-loss-in-time',
    'name': t('Reading in time: a selection read off continuation reads a loss before its point of no return, or too late'),
    'family': 'B',
    'mechanism': t(
        "World. A selection read off a group's continuations up to a step, the group fixed across two courses, can first "
        'tell them apart at their first step apart, the first step at which some member is admitted under one and not the '
        'other; a given family of such selections reads no earlier, and may never. Two things come before that step. The '
        "arriving gap crosses a member's margin: where one course admits a member, the other does wherever the gap on every "
        "condition it requires stays within its level less its need. And, under timely response's deadline premises, the "
        'closure in time of a source occurrence meets a member: what a potential route of exchanges has carried by a step is '
        "exactly what that closure meets, the condition in time's relation read through either course. A course is "
        'recoverable at a step where some feasible course agreeing with it so far keeps what is asked (feasible and kept '
        'supplied); its point of no return is the first step at which it is not. A loss is readable in time exactly where the '
        'first step apart comes before that point. Read off the continuation of what is lost alone, it is read only once it '
        'has happened. Which way a reading in time turns the course is not stated. Near-definitional laws and compositions; '
        'the witness is computed.'),
    'records': [R1, R2, R3],
    'declarations': [B + n for n in (
        'Web.FirstApart', 'Web.FirstApart.alike_before', 'Web.FirstApart.separates', 'Web.TellsApartAt.not_before',
        'Web.selectsAlike_unreached', 'Web.admits_iff_gap_within_margin', 'TimedResponse.reachedBy_iff_reachedInTime',
        'Flow.ReachedInTime', 'Recoverable', 'NoReturnAt', 'NoReturnAt.recoverable_iff', 'Web.ReadableInTime',
        'Web.readableInTime_iff', 'Web.ReadsInTime.readable', 'Web.too_late_of_alike', 'Web.too_late_of_unreached',
        'Web.too_late_within_margin', 'Web.too_late_of_own', 'FourReaders.recoverable_iff_regime', 'FourReaders.noReturn',
        'FourReaders.near_inTime', 'FourReaders.mid_atThePoint', 'FourReaders.listener_late')],
    'base': 'World',
    'hypotheses': [{'record': R1, 'index': i} for i in (1, 2, 3)] + [{'record': R2, 'index': i} for i in (1, 2, 3)]
    + [{'record': R3, 'index': 1}],
    'forbids': None,
    'exits': [
        x(('too late: no selection read off the group\'s continuations reads the loss before its point of no return',),
          B + 'Web.too_late_of_alike', 'sufficient',
          "Where every member is admitted alike under the two courses up to a step at which the losing course is past return, "
          'the loss is not readable in time, for the earliest reading and every family read off the group\'s continuations. '
          'Two ways it comes: under the deadline premises the route from the source meets no member by then '
          '(Web.too_late_of_unreached), or the other course admits every member and the gaps stay within their margins '
          'until then (Web.too_late_within_margin)', [R2], CH + '#r-a-loss-read-before-its-point-of-no-return'),
        x(('read only once it has happened: a group reading the continuation of what is lost',),
          B + 'Web.too_late_of_own', 'sufficient',
          "Where what is kept includes every member's admission at every step and the other course admits every member "
          'throughout, the courses are not readable in time: coupling in the one who bears the loss, the way the blindness '
          'beyond the coupling closure lifts, shows the loss only once it has happened', [R2],
          CH + '#r-a-loss-read-before-its-point-of-no-return'),
        x('margin-of-a-regime', B + 'FourReaders.recoverable_iff_regime', 'witness',
          'In FourReaders, once the clearer stops the habitat is a regime under the dweller\'s draw, its point exact at 2, '
          'and the cleared course is recoverable exactly while its level stands at that point or above: the point of no '
          'return is the regime\'s point, step 3, while the dweller ends at step 4 (FourReaders.noReturn). A gauge needing '
          'the habitat at 3 reads in time; one needing it at 2, and a listener two relays away, read at the point, too late',
          [R2], CH + '#r-a-loss-read-before-its-point-of-no-return'),
        x('loss-read-in-time-by-the-others', None, None,
          'In MA2\'s and MA4b\'s models the step at which the others read the loss is a supplied bound; read here, it is the '
          "first step apart of a selection read off the others' continuations, and MA4b's deadline bounds what is here the "
          'point of no return. Their models are pools of readers drawn from those they select, not flows, so no law joins them',
          [], CH + '#reading-in-time', seen='reading'),
    ],
    'transitions': [{
        'kind': 'window or deadline',
        'condition': t('Given the first step apart T and the point of no return N, the loss is readable in time exactly where '
                       'T < N.'),
        'declarations': [B + 'Web.readableInTime_iff', B + 'NoReturnAt.recoverable_iff'],
        'records': [R2],
        'between': {'from': t('readable in time'), 'to': t('too late')},
    }],
    'tests': [],
    'open': [
        {'en': 'A group or pool that changes with the course: the group is fixed across the comparison.', 'source': REC + R2 + DNS},
        {'en': 'That the feasible courses are those a law of exchange generates: they are supplied.', 'source': REC + R2 + DNS},
        {'en': 'That a reading in time keeps what is lost: which way it turns the course is not stated.', 'source': REC + R2 + DNS},
        {'en': 'That the first step apart comes when the route arrives: what arrives can stay within the members\' margins.',
         'source': REC + R1 + DNS},
    ],
    'valence': 'none asserted',
    'beyond': t('In FourReaders the dweller still stands at the point of no return and ends a step later; a reader of its own '
                'continuation is first apart only then, after the loss has happened (FourReaders.dweller_late, a witness).'),
    'sources': [CH + '#reading-in-time', CH + '#r-when-a-selection-read-off-continuation-reads',
                CH + '#r-a-loss-read-before-its-point-of-no-return', CH + '#r-the-route-is-the-relation-in-time'],
    'standing_without_record': None,
}
assert list(reading) == list(d[0]) or set(reading) == set(d[0]), set(reading) ^ set(d[0])
reading = {k: reading[k] for k in d[0]}
assert reading['id'] not in by
d.insert(d.index(by['selection-read-off-its-own-survivors']) + 1, reading)

by['unselected-beyond-the-coupling-closure']['exits'].append(
    x('reading-a-loss-in-time', B + 'Web.selectsAlike_unreached', 'sufficient',
      'Read up to a step rather than over the whole run, the blindness has a front: under timely response\'s deadline '
      'premises, where the closure in time of no source occurrence meets a member by a step, every selection read off the '
      "group's continuations up to then selects the two courses alike", [R1], CH + '#r-when-a-selection-read-off-continuation-reads'))
by['mutual-dependence-and-its-pace']['exits'].append(
    x('reading-a-loss-in-time', B + 'TimedResponse.reachedBy_iff_reachedInTime', 'exact',
      "The condition in time's relation is the route by which a difference reaches a reader: with the same formations "
      'present before a step and a source that goes on, what a potential route of exchanges has carried by then is exactly '
      'what the closure in time of a source occurrence meets, read through either course with coupling by level',
      [R3], CH + '#r-the-route-is-the-relation-in-time'))

# the open items K1 and K3 now partly answer
rc = by['readings-carried-and-filtered']['open']
hit = [o for o in rc if o['en'].startswith('How a reading arises or changes')]
assert len(hit) == 1
hit[0]['en'] = ('Occasions picking different readings: they need a run made of the picks, not built here. How readings are '
                'revised at descent, spread and lock is readings-revised-spread-and-locked, not these records.')
sv = by['selection-read-off-its-own-survivors']['open']
hit = [o for o in sv if o['en'].startswith('A reading in time')]
assert len(hit) == 1
hit[0]['en'] = ('A reading in time for a pool read off the course: reading-a-loss-in-time states it for a group fixed across '
                'the two courses.')
hit[0]['source'] = REC + R2 + DNS

ENTRIES.write_text(json.dumps(d, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('dynamics', len(d))
