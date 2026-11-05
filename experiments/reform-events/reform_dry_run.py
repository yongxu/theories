"""T7F's dry run (DESIGN.md §10): the verdict rule on synthetic coded cases, no record read, no model called.

    python3 -B reform_dry_run.py        # writes results/dry-run.json, the same on every run

AI-written (a Claude Code session), not yet reviewed by a person. It plants every forbidden case and every passing case
the rule must tell apart and checks each is counted as planted; checks the drift bound against the Lean witness and
against the exact chance of the drawn chain; computes the coders' power under independent errors, exactly; checks
the packets' caps (pack) on synthetic documents; and exercises every refusal: a malformed, enlarged or incomplete run,
another frame, packets, pages or coder set, a readout already there, python3 -O, and FROZEN.sha256 missing, short, wrong,
uncommitted or committed twice (in a scratch repository); and runs the verdict path with its four files in a scratch
repository.
The result holds no timing and no path, so it is the same on every run."""
import copy
import hashlib
import json
import os
import random
import shutil
import subprocess
import sys
import tempfile
from datetime import date, timedelta
from fractions import Fraction as Fr
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import reform_rule as R  # noqa: E402

NOT_SHOWN = R.NOT_SHOWN

CODE = [R.D + f for f in ('reform_rule.py', 'reform_dry_run.py', 'write_frozen.py', 'CODEBOOK.md')]


def code_hashes():
    return {p: hashlib.sha256((R.ROOT / p).read_bytes()).hexdigest() for p in CODE}


# --- synthetic codes ------------------------------------------------------------------------------------------------
STEP = {'up': ('favoured', 'other'), 'down': ('other', 'favoured'), 'ff': ('favoured', 'favoured'),
        'oo': ('other', 'other')}


def turnover(ups=0, downs=0, ff=0, oo=0, first=date(2005, 7, 1)):
    """A body's replacements over ten years, in date order: ups (a favoured member replacing an other), downs (the
    reverse), ff and oo (a member replaced by one of its own kind), each kind spread evenly through the years."""
    tags = sorted((Fr(2 * k + 1, 2 * n), r, name) for name, n, r in (('down', downs, 0), ('up', ups, 1), ('ff', ff, 2),
                                                                     ('oo', oo, 3)) for k in range(n))
    n = len(tags)
    return [{'date': (first + timedelta(days=(3650 * k) // max(n, 1))).isoformat(), 'entrant': STEP[o][0],
             'leaver': STEP[o][1]} for k, (_, _, o) in enumerate(tags)]


def refuting_codes():
    """One coder's codes for a case meeting every condition: a lock of 55 of 60 that rose from 40 over its ten years
    and was refilled 30 times by its own kind (u 17, d 2), two other entrants among 49, the slope's lower limit at
    the model's largest, the bound about 0.0012 with t 5 + 2."""
    return {
        'refutation': {'found': True, 'date': '2012-05-01', 'kind': 'audit', 'later': []},
        'premise': {'reading_by_ranked': True, 'rule_by_ranked': True, 'doc_date': '2008-01-15'},
        'outcome': {'dropped': True, 'drop_date': '2015-03-01', 'dropped_by': 'selectors', 'reformed_reading': False,
                    'reform_date': None, 'uncovered_years': []},
        'before_drop': {'from_date': None, 'new_reader': False, 'new_reading': False, 'loss_entering': False,
                        'uncovered_years': [], 'uncovered_years_from_date': None},
        'drift': {'N': 60, 'i': 55, 'threshold': '1/2', 'replacements': turnover(ups=17, downs=2, ff=30),
                  'one_at_a_time': True, 'constant': True, 'enter_through_measure': True, 'uncovered_years': []},
        'reform': {'lowered': None, 'still_by_ranked': None, 'new_reader_after': None, 'new_reading_after': None,
                   'loss_after': None, 'rule_kept': None, 'next_reading_date': None, 'outlasted': None,
                   'uncovered_years': None},
        'shown': {'part1': 'whole', 'part2': 'whole', 'part3': 'whole', 'part4': 'whole'},
    }


def with_(codes, **changes):
    c = copy.deepcopy(codes)
    for path, v in changes.items():
        g, f = path.split('__')
        c[g][f] = v
    return c


def kept_reformed(outlasted, **third):
    c = with_(refuting_codes(), outcome__dropped=False, outcome__drop_date=None, outcome__dropped_by=None,
              outcome__reformed_reading=True, outcome__reform_date='2014-02-01', before_drop__new_reader=None,
              before_drop__new_reading=None, before_drop__loss_entering=None)
    c['reform'] = {'lowered': True, 'still_by_ranked': True, 'new_reader_after': False, 'new_reading_after': False,
                   'loss_after': False, 'rule_kept': True, 'next_reading_date': '2015-02-01', 'outlasted': outlasted,
                   'uncovered_years': []}
    c['reform'].update(third)
    return c


def both(c, apart=None):
    return {'A': c, 'B': copy.deepcopy(c), 'C': copy.deepcopy(c if apart is None else apart)}


R0 = refuting_codes()
PLANTS = {
    'P01 refuting': (both(R0), 'refuting', 'every condition met by both deciders', 'not eligible'),
    'P02 dropped through a new reader': (both(with_(R0, before_drop__new_reader=True)), 'out',
                                         'dropped through a new reader', 'not eligible'),
    'P03 dropped through a change in what is read': (both(with_(R0, before_drop__new_reading=True)), 'out',
                                                     'dropped through a change in what is read', 'not eligible'),
    'P04 dropped through a loss entering the share': (both(with_(R0, before_drop__loss_entering=True)), 'out',
                                                      'dropped through a loss entering the share', 'not eligible'),
    'P05 a drop unresolved by drift': (both(with_(R0, drift__one_at_a_time=None, drift__replacements=None)),
                                       'unresolved', 'unresolved by drift', 'not eligible'),
    'P06 coders disagree on a new reader': ({'A': R0, 'B': with_(R0, before_drop__new_reader=True), 'C': R0}, 'unresolved',
                                            'unresolved: no_new_reader (disagree)', 'not eligible'),
    'P07 kept': (both(with_(R0, outcome__dropped=False, outcome__drop_date=None, outcome__dropped_by=None,
                            before_drop__new_reader=None, before_drop__new_reading=None, before_drop__loss_entering=None)),
                 'out', 'kept, or not dropped in the window', 'not eligible'),
    'P08 drift not rare (N 15, i 13)': (both(with_(R0, drift__N=15, drift__i=13,
                                                    drift__replacements=turnover(ups=6, ff=10))), 'out',
                                        'drift not rare by the bound', 'not eligible'),
    'P09 dropped by another body': (both(with_(R0, outcome__dropped_by='outside')), 'out', 'dropped by another body',
                                    'not eligible'),
    'P10 premise not met (rule set by others)': (both(with_(R0, premise__rule_by_ranked=False)), 'out',
                                                 'premise not met', 'not eligible'),
    'P11 premise documented only after the refutation': (both(with_(R0, premise__doc_date='2013-01-01')), 'out',
                                                         'premise not met', 'not eligible'),
    'P12 no refutation in the record collected, Part 1 shown whole': (
        both(with_(R0, refutation__found=False, refutation__date=None, refutation__kind=None)), 'out',
        'no refutation in the record collected', 'not eligible'),
    'P13 dropped twelve years after the refutation': (both(with_(R0, outcome__drop_date='2024-06-01')), 'out',
                                                      'kept, or not dropped in the window', 'not eligible'),
    'P14 a reform of the reading alone outlasting the next reading': (both(kept_reformed(True)), 'out',
                                                                      'kept, or not dropped in the window', 'met'),
    'P15 a reform of the reading absorbed at the next reading': (both(kept_reformed(False)), 'out',
                                                                 'kept, or not dropped in the window', 'absorbed'),
    'P16 a reform with a new reader': (both(kept_reformed(True, new_reader_after=True)), 'out',
                                       'kept, or not dropped in the window', 'not eligible'),
    'P17 the reported-apart coder alone finds no exit': (both(with_(R0, before_drop__new_reader=True), apart=R0), 'out',
                                                         'dropped through a new reader', 'not eligible'),
    # round 1 (REVIEW-FREEZE.md)
    'P18 one coder codes no new reader as null, the other as false (F1)': (
        {'A': R0, 'B': with_(R0, before_drop__new_reader=None), 'C': R0}, 'unresolved',
        'unresolved: no_new_reader (not coded)', 'not eligible'),
    'P19 a reform favouring the favoured, persisting (F4)': (both(kept_reformed(True, lowered=False)), 'out',
                                                            'kept, or not dropped in the window', 'not eligible'),
    'P20 a reform verified by an outside body, persisting (F4)': (both(kept_reformed(True, still_by_ranked=False)),
                                                                 'out', 'kept, or not dropped in the window',
                                                                 'not eligible'),
    'P21 not absorbed where no lowering is coded by both (F4)': (both(kept_reformed(False, lowered=None)), 'out',
                                                                'kept, or not dropped in the window', 'not eligible'),
    'P22 a reform beside a drop left uncoded (F11)': (both(with_(kept_reformed(True), outcome__dropped=None)),
                                                      'unresolved', None, 'unresolved'),
    'P23 a drop within ten years of a later finding, not the earliest (F8)': (
        both(with_(R0, refutation__date='2008-06-01', refutation__later=[{'date': '2017-04-01', 'kind': 'admission'}],
                   premise__doc_date='2008-01-15', outcome__drop_date='2019-03-01')),
        'refuting', 'every condition met by both deciders', 'not eligible'),
    'P24 an F2 case whose only finding precedes its frame\'s start (F8)': (
        both(with_(R0, refutation__date='2005-05-01', premise__doc_date='2004-01-15')), 'out',
        'no refutation in the record collected', 'not eligible', 'F2'),
    'P25 every member favoured, reverse replacements documented (F3)': (
        both(with_(R0, drift__N=15, drift__i=15, drift__replacements=turnover(ups=7, downs=7))), 'unresolved',
        'unresolved by drift',
        'not eligible'),
    'P26 every member favoured, a body of three (F3)': (
        both(with_(R0, drift__N=3, drift__i=3, drift__replacements=turnover(ups=2, ff=3))), 'out',
        'drift not rare by the bound',
        'not eligible'),
    'P27 new members not entering through the measure (F3)': (both(with_(R0, drift__enter_through_measure=False)),
                                                               'unresolved', 'unresolved by drift', 'not eligible'),
    'P28 a threshold under one half, read at x* = max(q, 1 - q) N (F7)': (
        both(with_(R0, drift__threshold='1/3')), 'out', 'drift not rare by the bound', 'not eligible'),
    'P29 a unanimity rule (F10)': (both(with_(R0, drift__threshold='1/1')), 'out', 'drift not rare by the bound',
                                   'not eligible'),
    # round 2 (REVIEW-FREEZE.md)
    'P30 the exits coded false on a packet with a year before the drop without a document (N1)': (
        both(with_(R0, before_drop__uncovered_years=[2014])), 'unresolved',
        'unresolved: no_new_reader (not coded), no_new_reading (not coded), no_loss_entering (not coded)',
        'not eligible'),
    'P31 the body\'s ten years with a year without a document (N1)': (
        both(with_(R0, drift__uncovered_years=[2010])), 'unresolved', 'unresolved by drift', 'not eligible'),
    'P32 a reform outlasting, with a year to the next revision without a document (N1)': (
        both(kept_reformed(True, uncovered_years=[2014])), 'out', 'kept, or not dropped in the window', 'unresolved'),
    'P33 every member favoured, twenty arrivals of the other kind (N60, i 60, u 30, d 20) (N3)': (
        both(with_(R0, drift__N=60, drift__i=60, drift__replacements=turnover(ups=30, downs=20))), 'unresolved',
        'unresolved by drift', 'not eligible'),
    'P34 a lowering standing through a new data source at the next revision (N4)': (
        both(kept_reformed(True, new_reading_after=True)), 'out', 'kept, or not dropped in the window', 'not eligible'),
    'P35 an F2 finding before the start and a later one after it, the drop within ten years of the later (N6)': (
        both(with_(R0, refutation__date='2009-03-01', refutation__kind='audit',
                   refutation__later=[{'date': '2013-04-01', 'kind': 'admission'}], outcome__drop_date='2016-03-01')),
        'refuting', 'every condition met by both deciders', 'not eligible', 'F2'),
    # round 3 (REVIEW-FREEZE.md)
    'P36 kept, coded on an outcome period with a year without a document (R3-7)': (
        both(with_(R0, outcome__dropped=False, outcome__drop_date=None, outcome__dropped_by=None,
                   outcome__uncovered_years=[2019], before_drop__new_reader=None, before_drop__new_reading=None,
                   before_drop__loss_entering=None, before_drop__uncovered_years=None)), 'unresolved',
        'unresolved: dropped (not coded), by_selectors (not coded), no_new_reader (not coded), no_new_reading (not coded), '
        'no_loss_entering (not coded)', 'unresolved'),
    'P37 the exits coded false, the coder listing 1998 and 1999 as without a document (R3-1)': (
        both(with_(R0, premise__doc_date='1996-04-01', before_drop__uncovered_years=[1998, 1999])), 'unresolved',
        'unresolved: premise (not coded), no_new_reader (not coded), no_new_reading (not coded), '
        'no_loss_entering (not coded)', 'not eligible'),
    'P38 one favoured member fewer than the body, twenty reverse replacements (N 60, i 59, u 30, d 20) (R3-2)': (
        both(with_(R0, drift__N=60, drift__i=59, drift__replacements=turnover(ups=30, downs=20))), 'unresolved',
        'unresolved by drift', 'not eligible'),
    # round 4 (REVIEW-FREEZE.md)
    'P39 a kept F2 measure, its 2026 covered by a June document, its October edition not kept (R4-2)': (
        both(with_(R0, outcome__dropped=False, outcome__drop_date=None, outcome__dropped_by=None,
                   outcome__uncovered_years=[], before_drop__new_reader=None, before_drop__new_reading=None,
                   before_drop__loss_entering=None, before_drop__uncovered_years=None)), 'out',
        'kept, or not dropped in the window', 'not eligible', 'F2'),
    'P40 a premise documented only before 2000, every exit coded false on a covered period (R4-3)': (
        both(with_(R0, premise__doc_date='1999-06-01')), 'unresolved', 'unresolved: premise (not coded)',
        'not eligible'),
    # round 5 (REVIEW-FREEZE.md), changed in the hold after round 6
    'P41 a kept F2 measure whose Part 3 is a sample of cut editions, each showing it in use (N2, R6)': (
        both(with_(R0, outcome__dropped=NOT_SHOWN, outcome__drop_date=None, outcome__dropped_by=None,
                   outcome__reformed_reading=NOT_SHOWN, outcome__uncovered_years=[], before_drop__new_reader=None,
                   before_drop__new_reading=None, before_drop__loss_entering=None, before_drop__uncovered_years=None,
                   shown__part3='sample')), 'unresolved', None, 'unresolved', 'F2'),
    # the hold after round 6 (REVIEW-FREEZE.md): not shown is never read as not in the record
    'P42 Part 1 a sample, no finding shown': (
        both(with_(R0, refutation__found=NOT_SHOWN, refutation__date=None, refutation__kind=None,
                   shown__part1='sample')), 'unresolved', None, 'not eligible'),
    'P43 Part 1 a sample, the coder coding no finding false': (
        both(with_(R0, refutation__found=False, refutation__date=None, refutation__kind=None,
                   shown__part1='sample')), 'unresolved', None, 'not eligible'),
    'P44 Part 1 a sample, the drop twelve years after the finding shown': (
        both(with_(R0, outcome__drop_date='2024-06-01', shown__part1='sample')), 'unresolved',
        'unresolved: dropped (not coded)', 'not eligible'),
    'P45 Part 3 a sample, every exit coded false, no year listed': (
        both(with_(R0, shown__part3='sample')), 'unresolved',
        'unresolved: no_new_reader (not coded), no_new_reading (not coded), no_loss_entering (not coded)',
        'unresolved'),
    'P46 Part 3 whole, every exit coded not shown': (
        both(with_(R0, before_drop__new_reader=NOT_SHOWN, before_drop__new_reading=NOT_SHOWN,
                   before_drop__loss_entering=NOT_SHOWN)), 'unresolved',
        'unresolved: no_new_reader (not coded), no_new_reading (not coded), no_loss_entering (not coded)',
        'not eligible'),
    'P47 kept, coded false on a Part 3 sample': (
        both(with_(R0, outcome__dropped=False, outcome__drop_date=None, outcome__dropped_by=None,
                   before_drop__new_reader=None, before_drop__new_reading=None, before_drop__loss_entering=None,
                   shown__part3='sample')), 'unresolved', None, 'unresolved'),
    'P48 Part 4 a sample': (both(with_(R0, shown__part4='sample')), 'unresolved', 'unresolved by drift',
                            'not eligible'),
    'P49 a reform outlasting, on a Part 3 sample': (both(with_(kept_reformed(True), shown__part3='sample')),
                                                    'unresolved', None, 'unresolved'),
    'P50 a reform whose lowering is coded not shown to stand, Part 3 whole': (
        both(kept_reformed(NOT_SHOWN)), 'out', 'kept, or not dropped in the window', 'unresolved'),
    # fresh round 1 (REVIEW-FREEZE.md)
    'P51 a lock that held its share (u = d), 80 same-kind: 3 other entrants among 86 do not reject rho = 1 (R1-2, R2-1)': (
        both(with_(R0, drift__replacements=turnover(ups=3, downs=3, ff=80))), 'unresolved',
        'unresolved by drift', 'not eligible'),
    'P52 a share that rose, its places filled often by the other kind (u 12, d 7), the old reading rare (R1-2)': (
        both(with_(R0, drift__replacements=turnover(ups=12, downs=7))), 'unresolved', 'unresolved by drift',
        'not eligible'),
    'P53 the exits from the last revision before the finding that kept the weight, none after it (R1-3)': (
        both(with_(R0, before_drop__from_date='2011-09-15', before_drop__uncovered_years_from_date=[])), 'refuting',
        'every condition met by both deciders',
        'not eligible'),
    'P54 the new reading\'s period set from a date after the drop: it alone open (R1-3, R2-2, R3-1)': (
        both(with_(R0, before_drop__from_date='2015-06-01', before_drop__uncovered_years_from_date=[])),
        'unresolved', 'unresolved: no_new_reading (not coded)', 'not eligible'),
    'P55 Part 3 shown whole but its collection not completed (R1-5)': (
        both(with_(R0, shown__part3='incomplete')), 'unresolved',
        'unresolved: no_new_reader (not coded), no_new_reading (not coded), no_loss_entering (not coded)',
        'unresolved'),
    # fresh round 2 (REVIEW-FREEZE.md)
    'P58 an exit after the finding that the measure outlived: the exits from its last full-weight revision before the '
    'drop (R2-2)': (
        both(with_(R0, before_drop__from_date='2014-09-15', before_drop__uncovered_years_from_date=[])), 'refuting',
        'every condition met by both deciders', 'not eligible'),
    'P59 an exit after the finding, no full-weight revision after it: out through a change in what is read (R2-2)': (
        both(with_(R0, before_drop__from_date='2012-09-15', before_drop__new_reading=True)), 'out',
        'dropped through a change in what is read', 'not eligible'),
    # fresh round 3 (REVIEW-FREEZE.md): a new reader and a loss are read from the premise's document, whatever
    # from_date is; only the new reading starts at the last full-weight revision before the drop
    'P61 a new reader that came before a full-weight revision before the drop: still an exit, out (R3-1)': (
        both(with_(R0, before_drop__from_date='2014-09-15', before_drop__uncovered_years_from_date=[],
                   before_drop__new_reader=True)), 'out', 'dropped through a new reader', 'not eligible'),
    'P62 the new reading\'s period covered from its revision, the longer period not: the new reader and the loss '
    'open (R3-1)': (
        both(with_(R0, before_drop__from_date='2014-09-15', before_drop__uncovered_years=[2010],
                   before_drop__uncovered_years_from_date=[])), 'unresolved',
        'unresolved: no_new_reader (not coded), no_loss_entering (not coded)', 'not eligible'),
    'P63 a from_date with the years from it not listed: the new reading open (R3-1)': (
        both(with_(R0, before_drop__from_date='2014-09-15')), 'unresolved', 'unresolved: no_new_reading (not coded)',
        'not eligible'),
    # fresh round 4: the from_date period lies within the longer one, so a year without a document in the longer list,
    # from from_date's year to the drop's, leaves the new reading open whatever the second list says (R4-3)
    'P64 the two lists disagreeing: a year without a document after from_date in the longer list, none in the '
    'second: the new reading open (R4-3)': (
        both(with_(R0, before_drop__from_date='2013-09-15', before_drop__uncovered_years=[2014],
                   before_drop__uncovered_years_from_date=[])), 'unresolved',
        'unresolved: no_new_reader (not coded), no_new_reading (not coded), no_loss_entering (not coded)',
        'not eligible'),
}
# P22's reason, as the rule writes it: every condition from the drop on is open
PLANTS['P22 a reform beside a drop left uncoded (F11)'] = PLANTS['P22 a reform beside a drop left uncoded (F11)'][:2] + (
    'unresolved: dropped (not coded), by_selectors (not coded), no_new_reader (not coded), no_new_reading (not coded), '
    'no_loss_entering (not coded)', 'unresolved')

# the reasons the rule writes for the plants whose every condition from the drop on, or from the refutation on, is open
_FROM_DROP = ('unresolved: dropped (not coded), by_selectors (not coded), no_new_reader (not coded), no_new_reading '
              '(not coded), no_loss_entering (not coded)')
_FROM_REFUTATION = 'unresolved: refutation (not coded), premise (not coded), dropped (not coded)'
for _k, _why in (('P41', _FROM_DROP), ('P42', _FROM_REFUTATION), ('P43', _FROM_REFUTATION), ('P47', _FROM_DROP),
                 ('P49', _FROM_DROP)):
    _n = next(n for n in PLANTS if n.startswith(_k))
    PLANTS[_n] = PLANTS[_n][:2] + (_why,) + PLANTS[_n][3:]


def frame_of(n):
    return PLANTS[n][4] if len(PLANTS[n]) > 4 else 'F3'


CTL_OK = {'C-LIBOR': both(with_(R0, outcome__dropped_by='outside', before_drop__new_reader=True)),
          'C-PSA': both(with_(R0, before_drop__new_reader=True, premise__rule_by_ranked=False))}
CTL_MISSED = dict(CTL_OK, **{'C-LIBOR': both(R0)})
NULL_EXITS = with_(R0, before_drop__new_reader=None, before_drop__new_reading=None, before_drop__loss_entering=None)
CTL_NULL = {'C-LIBOR': both(NULL_EXITS), 'C-PSA': both(NULL_EXITS)}
CTL_OUTSIDE_ONLY = dict(CTL_OK, **{'C-LIBOR': both(with_(R0, outcome__dropped_by='outside'))})
# a control whose known exit, a new reader, came before a revision that kept the measure's weight before its drop: the
# coders give that revision as from_date, and the exit is still found (R3-1)
CTL_BEFORE_REVISION = dict(CTL_OK, **{'C-LIBOR': both(with_(
    R0, outcome__dropped_by='outside', before_drop__from_date='2014-09-15', before_drop__uncovered_years_from_date=[],
    before_drop__new_reader=True))})


def site(home, found, role, years, pages=(), frm=None):
    return {'home': home, 'found': found, 'from': frm, 'role': role, 'years': list(years),
            'pages': [{'address': home + a, 'kind': k, 'years': list(y)} for a, k, y in pages]}


def cand(home, frm, role):
    return {'home': home, 'from': list(frm), 'role': role}


def pages_of(frame):
    """A synthetic pages.json for the frame: every F2 case and control, each with its start candidates found by the
    frozen queries (R5-1), a news site of neither role and its publisher's site read from 2000, a method page moved to
    a new address in 2014 (R3-2)."""
    cs = {x['id']: x for x in frame['cases'] + frame['controls'] if x['frame'] in ('F2', R.CONTROL)}
    out = []
    for k in sorted(cs):
        q = R.start_queries(cs[k])
        home = 'https://example.invalid/%s/' % k
        out.append({'case': k, 'candidates': [cand(home, q[:2], 'publisher'),
                                              cand('https://news.example.invalid/', q[:1], 'neither')],
                    'sites': [site(home, 'start', 'publisher', range(2000, 2027),
                                   [('method', 'method', [2012, 2013]), ('methodology', 'method', [2014])])]})
    return {'chosen_by': 'a deciding pin, by START_CHOICE and PAGE_CHOICE', 'cases': out}


def given_of(pages):
    """The lists the chooser was given, as the collector commits them beside pages.json (R5-4)."""
    return {'cases': [{'case': x['case'],
                       'candidates': [{'home': c['home'], 'from': c['from']} for c in x['candidates']],
                       'sites': [{k: s[k] for k in ('home', 'found', 'from', 'years')} for s in x['sites']]}
                      for x in pages['cases']]}


def manifest(pages_bytes, rest=b'synthetic packets\n'):
    """A synthetic packets' manifest, listing pages.json at its sha-256 as the collection writes it (R4-4)."""
    return rest + ('%s  run/pages.json\n' % R.sha_bytes(pages_bytes)).encode()


def documents(names, controls=CTL_OK, coder_set='pins'):
    frame = {'registers': {'F3': 'synthetic', 'F2': 'synthetic'},
             'cases': [{'id': n[:3], 'frame': frame_of(n), 'name': R.NAME_TEMPLATE[frame_of(n)].format(entry=n),
                        'register_entry': n} for n in names],
             'controls': [{'id': k, 'frame': 'control', 'name': R.CONTROL_NAMES[k], 'register_entry': 'synthetic'}
                          for k in R.CONTROL_IDS]}
    fb = json.dumps(frame, sort_keys=True).encode()
    gb = json.dumps(pages_of(frame), sort_keys=True).encode()
    packets = manifest(gb)
    coders = copy.deepcopy(R.CODER_SETS[coder_set])
    rename = dict(zip(('A', 'B', 'C'), sorted(coders)))   # the plants' coders A, B, C as the set's own

    def recode(codes):
        return {rename[k]: copy.deepcopy(v) for k, v in codes.items() if k in rename}
    cases = {'frame_sha256': R.sha_bytes(fb), 'pages_sha256': R.sha_bytes(gb), 'packets_sha256': R.sha_bytes(packets),
             'cutoff': R.CUTOFF.isoformat(),
             'coder_set': coder_set, 'coders': coders,
             'run_log': {'malformed': {k: 0 for k in coders}, 'other_model': {k: 0 for k in coders}},
             'cases': [{'id': n[:3], 'codes': recode(PLANTS[n][0])} for n in names] +
                      [{'id': k, 'codes': recode(v)} for k, v in controls.items()]}
    return frame, fb, cases, packets, gb


def run_verdict(*docs):
    return R.verdict(*copy.deepcopy(docs))


def refused(f, *a, word='refused'):
    try:
        f(*a)
    except SystemExit as e:
        return str(e).startswith(word)
    return False


def voided(f, *a):
    return refused(f, *a, word='void')


# --- the drift bound ------------------------------------------------------------------------------------------------
def rho_line(N, i, xs, rho):
    slope = (rho - 1) / (i - xs)
    return lambda j: 1 + slope * (j - xs)


def chance_lost(N, i, rho_of, s=0):
    """The drawn chain's exact chance, from i, of reaching s before N (s = 0: losing every shaper), the step ratio
    down / up at j being 1 / rho(j): the birth-death chain's ruin chance."""
    def prod(k):
        p = Fr(1)
        for j in range(s + 1, k + 1):
            p /= rho_of(j)
        return p
    num = sum((prod(k) for k in range(i, N)), Fr(0))
    den = sum((prod(k) for k in range(s, N)), Fr(0))
    return num / den


def drift_checks():
    out = {}
    # the Lean witness (DrawnReplacement.Strong): five members, a 1, p 0, c 9, hi 20, lo 0
    M, a, p, c, hi, lo = 4, 1, 0, 9, 20, 0
    up = lambda j: j * (a + hi + p) + (M + 1 - j) * (a + lo + p)
    down = (M + 1) * (a + c + p)
    s = min(j for j in range(M + 2) if down <= up(j))
    xs = Fr(down - (M + 1) * (a + lo + p), hi - lo)          # where up(x) = down
    b = R.bound_at(4, xs, Fr(up(4), down), 4, 1)
    line = rho_line(5, 4, xs, Fr(17, 10))
    out['the Lean witness: s is 3 and x* 9/4'] = (s == 3 and xs == Fr(9, 4))
    out["the Lean witness: the line through x* and rho(4) is up / down at every count 0..5"] = all(
        line(j) == Fr(up(j), down) for j in range(6))
    out["the Lean witness: the bound is lost_above's t down^n / ups, 10/17"] = (
        b == Fr(1) * Fr(down, up(4)) == Fr(10, 17))
    cases = {'witness N 5 i 4': (5, 4, Fr(9, 4), Fr(17, 10)), 'N 15 i 13 x* 15/2 rho 3/2': (15, 13, Fr(15, 2), Fr(3, 2)),
             'N 60 i 55 x* 30 rho 3/2': (60, 55, Fr(30), Fr(3, 2)), 'N 20 i 18 x* 10 rho 8/5': (20, 18, Fr(10), Fr(8, 5))}
    rows = {}
    for name, (N, i, x, r) in cases.items():
        b = R.bound_at(i, x, r, i, N - i)
        f = rho_line(N, i, x, r)
        sm = -((-x.numerator) // x.denominator)
        lost, reach = chance_lost(N, i, f), chance_lost(N, i, f, s=sm)
        rows[name] = {'bound': str(b), 'bound, decimal': '%.6f' % float(b),
                      'status': 'rare' if b <= R.THRESHOLD else 'not rare',
                      'exact chance of losing every shaper': '%.6f' % float(lost),
                      'exact chance of reaching s before the top': '%.6f' % float(reach),
                      'both at most the bound': lost <= reach <= b}
    out['the bound against the exact chain'] = rows
    out['every exact chance at most its bound'] = all(r['both at most the bound'] for r in rows.values())
    out['N 60 i 55 is rare and N 15 i 13 is not'] = (rows['N 60 i 55 x* 30 rho 3/2']['status'] == 'rare' and
                                                    rows['N 15 i 13 x* 15/2 rho 3/2']['status'] == 'not rare')
    # x* read from the voting threshold (F7): the larger of q N and (1 - q) N
    out['x* is max(q, 1 - q) N: 40 at q 1/3 and at q 2/3, 30 at q 1/2, 60 at q 1/1'] = (
        R.critical_count(60, '1/3') == R.critical_count(60, '2/3') == 40 and R.critical_count(60, '1/2') == 30
        and R.critical_count(60, '1/1') == 60)
    base = dict(R0['drift'])
    xs30 = Fr(30)

    def rho_at(dr):                                   # rho(i) on the line at the slope's lower limit, as the rule reads it
        beta = R.turnover(dr['N'], dr['i'], dr['replacements'], R.critical_count(dr['N'], dr['threshold']))[0]
        return 1 + beta * (dr['i'] - R.critical_count(dr['N'], dr['threshold']))
    rho0 = rho_at(base)
    half, third = R.drift_bound(base), R.drift_bound(dict(base, threshold='1/3'))
    out['N 60 i 55 at q 1/2 (u 17, d 2, 30 same-kind; a rise from 40): the slope at its cap, t = N - i + d = 7, rare'] = (
        half[0] == 'rare' and rho0 == Fr(55, 30) and half[1] == R.bound_at(55, xs30, rho0, 55, 7)
        and half[1] == Fr(7, 5) * R.bound_at(55, xs30, rho0, 55, 5))
    out['N 60 i 55 at q 1/3 is read at x* 40 (the ratio at its cap 11/8), not rare'] = (
        third[0] == 'not rare' and third[1] == R.bound_at(55, Fr(40), Fr(11, 8), 55, 7))
    out['a unanimity rule (1/1): not rare'] = R.drift_bound(dict(base, threshold='1/1'))[0] == 'not rare'
    out['readings of x*, reported'] = {'N 60 i 55, q 1/3': '%.6f' % float(third[1]),
                                       'N 60 i 55, q 1/2': '%.6f' % float(half[1])}
    # the estimate (R2-1): the slope of rho read at its lower 1/20 confidence limit from who filled the places at the
    # counts they were filled, not a point estimate
    p56 = dict(base, N=40, i=38, replacements=turnover(ups=8, downs=1, ff=40, first=date(2008, 7, 1)))
    js = R.counts_before(40, 38, p56['replacements'])
    bl, how, oth, _, _ = R.turnover(40, 38, p56['replacements'], Fr(20))
    step = (1 / Fr(20)) / 2 ** R.BISECTIONS
    out['the lower limit is bracketed (P56, 1 other entrant among 49): as few others rarer than 1/20 at it, not just '
        'above it'] = (how == 'limit' and R.others_at_most(40, Fr(20), js, oth, bl) < R.LEVEL
                       <= R.others_at_most(40, Fr(20), js, oth, bl + step))
    # a forced outcome carries nothing about the slope (R3-4): a favoured entrant at count 0, or at the top, leaves the
    # chance as it was, at the slope 0 and at 1/40; an other entrant at either is counted at no cost in chance
    forced = all(R.others_at_most(40, Fr(20), js + [jj], oth, b) == R.others_at_most(40, Fr(20), js, oth, b)
                 for jj in (0, 40) for b in (Fr(0), Fr(1, 40)))
    out['a trial whose outcome the model forces (count 0 or the top) is skipped: the chance unchanged (R3-4)'] = (
        forced and R.others_at_most(40, Fr(20), js + [0], oth + 1, Fr(1, 40)) >= R.others_at_most(
            40, Fr(20), js, oth, Fr(1, 40)))
    grid = [R.others_at_most(40, Fr(20), js, oth, Fr(k, 200)) for k in range(11)]
    out['as few other entrants grows likelier as the slope rises (P56, on a grid to the cap)'] = all(
        x < y for x, y in zip(grid, grid[1:]))
    p51 = turnover(ups=3, downs=3, ff=80)
    f51 = R.others_at_most(60, xs30, R.counts_before(60, 55, p51), 3, Fr(0))
    held = {n: R.drift_bound(dict(base, replacements=turnover(ups=3, downs=3, ff=n))) for n in (80, 120, 200)}
    out['the reader\'s P51 data (3 other entrants among 86 at about 55 of 60): their chance under rho = 1 is above 1/20, '
        'so the bound is not read (P51)'] = (f51 > R.LEVEL and held[80][0] == 'unreadable')
    least_held = next((n for n in range(80, 401, 10) if R.drift_bound(
        dict(base, replacements=turnover(ups=3, downs=3, ff=n)))[0] == 'rare'), None)
    steady = R.drift_bound(dict(base, replacements=turnover(ff=66, oo=4)))
    out['the drawn step\'s expected odds at 55 of 60 and rho 3/2, 66 favoured and 4 other entrants: not read, 70 '
        'entrants at that count not rejecting rho = 1'] = steady[0] == 'unreadable'
    rose = R.drift_bound(dict(base, replacements=turnover(ups=12, downs=7)))
    out['a share that rose by five, its places filled 7 times of 19 by the other kind: unreadable (P52)'] = (
        rose[0] == 'unreadable')
    out['replacements inconsistent with N and i (seven reverse ones at 15 of 15, none up): unreadable'] = (
        R.drift_bound(dict(base, N=15, i=15, replacements=turnover(downs=7)))[2] ==
        'N, i and the replacements inconsistent')
    out['the estimate, reported'] = {
        'N 60 i 55, u 17 d 2, 30 same-kind (R0)': {'rho(i) at the limit': str(rho0), 'bound': '%.6f' % float(half[1])},
        'N 40 i 38, u 8 d 1, 40 same-kind (P56)': {'slope at the limit': str(bl), 'bound': '%.6f' % float(
            R.drift_bound(p56)[1])},
        'N 60 i 55 held, u 3 d 3: the chance of at most 3 others among 86 under rho = 1 (P51)': '%.4f' % float(f51),
        'N 60 i 55 held, u 3 d 3, n same-kind': {
            str(n): {'status': v[0], 'bound': None if v[1] is None else '%.6f' % float(v[1])} for n, v in held.items()},
        'N 60 i 55 held, u 3 d 3: the least n same-kind, in tens, read rare': least_held,
        'N 60 i 55, 66 favoured and 4 other entrants': {'status': steady[0], 'note': steady[2]},
        'N 60 i 55, u 12 d 7, none same-kind': {'status': rose[0], 'note': rose[2]}}
    # every member favoured (F3): the bound from N - 1 with t = 1 + d
    top = dict(base, i=60, replacements=turnover(ups=35, downs=3, ff=10))
    st, b, note = R.drift_bound(top)
    one = R.bound_at(60, xs30, rho_at(top), 59, 1)
    out['every selector favoured (N 60, a rise of 32 to the top, d 3): read from N - 1 with t = 1 + d = 4, four times '
        'one arrival\'s'] = (st == 'rare' and b == 4 * one and 'N - 1' in note)
    many = R.drift_bound(dict(top, replacements=turnover(ups=30, downs=20)))
    out['every selector favoured, twenty arrivals of the other kind (N 60, u 30, d 20): unreadable, the arrivals '
        'weighing against the limit (P33)'] = many[0] == 'unreadable'
    below = dict(base, i=59, replacements=turnover(ups=33, downs=3))
    bb = R.drift_bound(below)
    out['below the top, N 60 i 59 (d 3): t = max(N - i, 1) + d = 4'] = (
        bb[1] == R.bound_at(59, xs30, rho_at(below), 59, 4))
    out['every selector favoured, reported'] = {
        'N 60 i 60, u 35 d 3': {'status': st, 'bound': '%.6f' % float(b), 'one arrival alone': '%.6f' % float(one)},
        'N 60 i 60, u 30 d 20': {'status': many[0], 'note': many[2]},
        'N 60 i 59, u 33 d 3': {'status': bb[0], 'bound': '%.6f' % float(bb[1])}}
    out['Part 4 shown as a sample: unreadable, whatever its counts (R6)'] = R.drift_bound(base, whole4=False)[0] == \
        'unreadable'
    out['the ten years not each covered by a document: unreadable'] = R.drift_bound(
        dict(base, uncovered_years=[2010]))[0] == 'unreadable' and R.drift_bound(
        dict(base, uncovered_years=None))[0] == 'unreadable'
    out['replacements not listed: unreadable'] = R.drift_bound(dict(base, replacements=None))[0] == 'unreadable'
    out['every selector favoured, a body of three: not rare'] = R.drift_bound(
        dict(base, N=3, i=3, replacements=turnover(ups=2, ff=3)))[0] == 'not rare'
    out['new members not entering through the measure: unreadable'] = R.drift_bound(
        dict(base, enter_through_measure=None))[0] == 'unreadable'
    b15 = dict(base, N=15, threshold='1/2', replacements=turnover(ups=6, ff=10))
    out['at or below the critical mass: not rare'] = R.drift_bound(dict(b15, i=7))[0] == 'not rare'
    out['premises not read: unreadable'] = R.drift_bound(dict(b15, i=13, constant=None))[0] == 'unreadable'
    out['fewer than five replacements: unreadable'] = R.drift_bound(
        dict(b15, i=13, replacements=turnover(ups=2, ff=2)))[0] == 'unreadable'
    out['a record not rejecting rho = 1: unreadable'] = R.drift_bound(
        dict(b15, i=13, replacements=turnover(ups=3, downs=2)))[0] == 'unreadable'
    capped = R.drift_bound(dict(b15, i=13, replacements=turnover(ups=6, ff=10)))   # no other entrant among 16
    out['a lower limit at the largest slope the model allows is taken there, rho(i) = i / x* (N 15, i 13: not rare)'] = (
        capped[0] == 'not rare' and capped[1] == R.bound_at(13, Fr(15, 2), Fr(26, 15), 13, 2) and 'largest' in capped[2])
    # how many selectors 'many enough' asks, by the bound itself: the least N at which it can be rare, the ratio at its
    # cap and no reverse replacement (the bound drift_bound reads where the estimate reaches the cap and d is 0)
    least = {}
    for q in ('1/2', '2/3'):
        least[q] = None
        for N in range(2, 201):
            xs = R.critical_count(N, q)
            if any(R.bound_at(i, xs, Fr(i) / xs, min(i, N - 1), max(N - i, 1)) <= R.THRESHOLD
                   for i in range(1, N + 1) if i > xs):
                least[q] = N
                break
    out['the least N at which the bound can be rare, the ratio at its cap (reported)'] = least
    capfit = R.drift_bound(dict(base, N=18, i=18, replacements=turnover(ups=17, ff=3)))
    out['at N 18, a rise to the top read at the cap: rare, as the least N says'] = (
        capfit[0] == 'rare' and 'largest' in capfit[2])
    return out


# --- the drift clause under drift alone (R2-1): a seeded simulation of the drawn step ---------------------------------
SIM_BODIES = 1000
SIM_SEED = 20261105


def simulate_body(rng, N, j0, n, rho_of):
    """n replacements of the drawn step from j0 of N favoured: whoever leaves is any member (favoured with chance
    j / N), and the entrant is favoured with odds j rho(j) : (N - j). Returns the count after and the replacements, in
    the coder's form."""
    j, reps = j0, []
    for k in range(n):
        leaves = rng.random() < j / N
        r = rho_of(j)
        enters = rng.random() < j * r / (j * r + N - j)
        reps.append({'date': (date(2010, 1, 1) + timedelta(days=k)).isoformat(),
                     'entrant': 'favoured' if enters else 'other', 'leaver': 'favoured' if leaves else 'other'})
        j += enters - leaves
    return j, reps


def drift_simulation():
    """How often the clause reads 'rare' where it should not: under rho = 1 (neutral drift), where the chance of falling
    from 55 to 30 of 60 before reaching 60 is 1/6, and under rho = 4/5 (a share wearing away); and, reported only, how
    often it does where the model's line is at its largest (rho(j) = j / x*). Seeded, so the same on every run.
    Each row says how many bodies the rule read at all (rare or not rare). A setting in which it read none checks
    nothing (every body unreadable makes 'rare' automatically rare): it is reported, and not counted among those
    checked (round fresh 3, T7F-R3-3). The settings from 38 of 40 are such; P56's own record is a rise from 31 to 38
    of 40, so the settings from 31 of 40 are the ones at its size."""
    rng = random.Random(SIM_SEED)
    base = dict(R0['drift'], threshold='1/2')
    checked = [('rho = 1', 1.0, 60, 55, 80), ('rho = 1', 1.0, 60, 55, 50), ('rho = 1', 1.0, 60, 55, 120),
               ('rho = 1', 1.0, 40, 38, 50), ('rho = 1', 1.0, 40, 31, 50), ('rho = 1', 1.0, 40, 31, 100),
               ('rho = 1', 1.0, 60, 45, 80), ('rho = 4/5', 0.8, 60, 55, 80), ('rho = 4/5', 0.8, 40, 38, 50),
               ('rho = 4/5', 0.8, 40, 31, 50)]
    largest = [('the largest line, rho(j) = j / x* (reported)', None, 60, 55, 80),
               ('the largest line, rho(j) = j / x* (reported)', None, 60, 45, 80)]
    rows, ok, counted = {}, True, {'rho = 1': 0, 'rho = 4/5': 0}
    for dname, r, N, j0, n in checked + largest:
        rho_of = (lambda j, r=r: r) if r is not None else (lambda j, N=N: j / (N / 2))
        tally = {'rare': 0, 'not rare': 0, 'unreadable': 0}
        for _ in range(SIM_BODIES):
            i, reps = simulate_body(rng, N, j0, n, rho_of)
            tally[R.drift_bound(dict(base, N=N, i=i, replacements=reps))[0]] += 1
        read = tally['rare'] + tally['not rare']
        row = dict(tally, **{'share read rare': '%.4f' % (tally['rare'] / SIM_BODIES), 'bodies read at all': read})
        if r is not None:
            if read == 0:
                row['counted'] = 'no: no body read, so it checks nothing'
            else:
                row['counted'] = 'yes'
                counted[dname] += 1
                ok = ok and Fr(tally['rare'], SIM_BODIES) <= R.THRESHOLD
        rows['%s, N %d from %d, %d replacements' % (dname, N, j0, n)] = row
    ok = ok and all(v > 0 for v in counted.values())
    return ok, rows, counted


# --- the packets' caps (R6): pack on synthetic documents -----------------------------------------------------------
TERMS = ['主要预期目标', 'audit', 'sanction']


def doc(i, d, paras):
    return {'id': i, 'date': d, 'paragraphs': paras}


def work_report(y):
    """A long yearly document of about 18,000 words: a review of the year before first, the target sentence late."""
    return doc('wr%d' % y, '%d-02-10' % y, ['review of the year before ' * 600 for _ in range(4)] +
               ['the main expected target 主要预期目标 growth of about 8 per cent'] + ['other tasks ' * 500 for _ in range(6)])


def ids_of(k):
    return [d['id'] for d in k['documents']]


# --- realistic packets (R1-1): Parts 3 and 4 by the listed sources and their passages, so that a record can fit ----
def f2_packets(complete=True):
    """An F2 ranking, 'the World Ranking', whose method an advisory board of 40 heads of ranked institutions decides.
    Part 3, its listed sources: the methodology page's yearly editions 2005 to 2017, each about 3,950 words (three
    paragraphs naming the ranking, seven of tables headed 'Rank'), the board's notice of June 2018 ending it, and the site's yearly
    copies 2019 to 2026, a line on the ranking's end beside 800 words of other pages. Part 4: the board's page, yearly
    2008 to 2017, and its decision of 2018. Whole, these documents pass 50,000 words; as their passages naming the
    measure and the body, they fit."""
    named = ['the World Ranking reads the survey of the heads of the ranked institutions ' * 12 for _ in range(3)]
    tables = ['Rank institution ' * 250 for _ in range(7)]      # a table's column word, not the ranking's name
    p3 = [doc('ed%d' % y, '%d-09-15' % y, named[:1] + tables[:3] + named[1:2] + tables[3:] + named[2:])
          for y in range(2005, 2018)]
    p3 += [doc('end2018', '2018-06-01', ['the advisory board ends the World Ranking by its vote ' * 30])]
    p3 += [doc('site%d' % y, '%d-07-01' % y, ['the World Ranking was ended in 2018',
                                               'news and contact pages of the publisher ' * 115]) for y in range(2019, 2027)]
    board = ['the advisory board of the World Ranking decides its method',
             'members of the board: ' + 'the head of a ranked institution, ' * 40, 'news and contact ' * 1000]
    p4 = [doc('bd%d' % y, '%d-07-01' % y, board) for y in range(2008, 2018)]
    p4 += [doc('end2018', '2018-06-01', ['the advisory board ends the World Ranking by its vote ' * 30])]
    t3, t4 = R.record_terms(3, 'F2', 'World Ranking'), R.record_terms(4, 'F2')
    return {'part 3, whole documents': R.pack(3, p3, TERMS, lo=D(2005, 9, 15), complete=complete),
            'part 3': R.pack(3, p3, TERMS, lo=D(2005, 9, 15), record=t3, complete=complete),
            'part 4': R.pack(4, p4, TERMS, hi=D(2018, 6, 1), record=t4, what='the body', complete=complete)}


def f3_packets():
    """An F3 province's Part 3, its listed sources: the work reports of 2008 to 2026, each about 15,300 words with
    three paragraphs on the GDP target, and twelve notices of the central bodies naming the province's GDP figures."""
    review = ['回顾过去一年的工作' * 250 for _ in range(10)]
    target = ['全省生产总值增长百分之八左右' * 10 for _ in range(3)]
    p3 = [doc('wr%d' % y, '%d-02-10' % y, review[:4] + target[:1] + review[4:7] + target[1:] + review[7:])
          for y in range(2008, 2027)]
    p3 += [doc('nb%d' % y, '%d-08-01' % y, ['国家统计局公布各省生产总值数据' * 20, '其他事项' * 100])
           for y in range(2009, 2021)]
    return {'part 3, whole documents': R.pack(3, p3, TERMS, lo=D(2008, 1, 15)),
            'part 3': R.pack(3, p3, TERMS, lo=D(2008, 1, 15), record=R.record_terms(3, 'F3'))}


D = R.date


F2P, F3P = f2_packets(), f3_packets()
PLANTS['P56 a realistic F2 case on its packets: Parts 3 and 4 whole by their passages, a board of 40 (R1-1)'] = (
    both(with_(R0, refutation__date='2013-04-01', refutation__kind='replicated_study', premise__doc_date='2005-09-15',
               outcome__drop_date='2018-06-01', before_drop__from_date='2012-09-15',
               before_drop__uncovered_years_from_date=[], drift__N=40, drift__i=38,
               drift__replacements=turnover(ups=8, downs=1, ff=40, first=date(2008, 7, 1)), shown__part1='sample',
               shown__part2='sample', shown__part3=F2P['part 3']['shown'], shown__part4=F2P['part 4']['shown'])),
    'refuting', 'every condition met by both deciders', 'not eligible', 'F2')
F2M = R.pack(3, [doc('ed%d' % y, '%d-09-15' % y, ['the World Ranking of %d and its method ' % y * 50] * 7 +
                    ['Rank institution ' * 250] * 3) for y in range(2004, 2026)], TERMS, lo=D(2004, 9, 15),
             record=R.record_terms(3, 'F2', 'World Ranking'))
PLANTS['P60 an F2 ranking whose 22 editions name it in most paragraphs: Part 3 a sample by its passages (R2-3)'] = (
    both(with_(R0, shown__part3=F2M['shown'])), 'unresolved',
    'unresolved: no_new_reader (not coded), no_new_reading (not coded), no_loss_entering (not coded)', 'unresolved',
    'F2')
PLANTS['P57 a realistic F3 case on its packet, kept: Part 3 whole by its passages (R1-1)'] = (
    both(with_(R0, outcome__dropped=False, outcome__drop_date=None, outcome__dropped_by=None,
               before_drop__new_reader=None, before_drop__new_reading=None, before_drop__loss_entering=None,
               before_drop__uncovered_years=None, drift__N=12, drift__i=11, shown__part1='sample',
               shown__part2='sample', shown__part3=F3P['part 3']['shown'], shown__part4='sample')),
    'out', 'kept, or not dropped in the window', 'not eligible')


def part1_read(k, found):
    """Part 1 as pack showed it, through the rule: the refutation a coder's 'none' gives there."""
    c = with_(R0, refutation__found=found, refutation__date=None, refutation__kind=None,
              shown__part1='whole' if k['whole'] else 'sample')
    return R.findings(c, R.START['F3'])[0]


def packing_checks():
    out, rep = {}, {}
    out['words: Han characters divided by 1.5, runs of letters or digits, punctuation not counted'] = (
        R.count_words('国内生产总值增长8%左右') == Fr(23, 3) and R.count_words('GDP growth of 8.5 per cent') == 7)
    # the whole record where it fits, whatever the number of its documents
    short = [doc('s%d' % y, '%d-05-01' % y, ['minutes ' * 1500]) for y in range(2000, 2027)]
    k = R.pack(3, short, TERMS)
    out['27 documents of 1,500 words (40,500 in all): the whole record, none cut, every year covered, the header '
        'saying so'] = (
        k['whole'] and len(k['documents']) == 27 and not any(d['cut'] for d in k['documents'])
        and R.uncovered(k['documents'], D(2000, 1, 1), D(2026, 6, 30)) == []
        and k['header'] == '[the whole record collected for this part: 27 documents, none cut]')
    notes = [doc('m%03d' % j, '%d-%02d-15' % (2000 + j // 12, j % 12 + 1), ['a short notice ' * 100])
             for j in range(150)]
    k = R.pack(3, notes, TERMS)
    out['150 notices of 300 words (45,000 in all): the whole record, though more than a sample holds'] = (
        k['whole'] and len(k['documents']) == 150 and k['not shown'] == [])
    # a record that does not fit: a sample, each document cut to an equal share, the header saying so
    audits = [doc('au%d' % y, '%d-09-01' % y, ['the audit office finds the figures unreliable ' * 40])
              for y in range(2008, 2018)]
    k = R.pack(3, [work_report(y) for y in range(2000, 2027)] + audits, TERMS)
    reports = [d for d in k['documents'] if d['id'].startswith('wr')]
    out['27 work reports of about 18,000 words and ten 280-word audit notices: a sample of all 37, each report cut '
        'to a 37th of the words and marked, keeping its late target sentence, each notice whole'] = (
        not k['whole'] and len(k['documents']) == 37 and len(reports) == 27
        and all(d['cut'] and d['paragraphs'][0].startswith('[cut: ') and d['kept_words'] <= Fr(R.MAX_WORDS, 37)
                and any('主要预期目标' in x for x in d['paragraphs']) for d in reports)
        and not any(d['cut'] for d in k['documents'] if d['id'].startswith('au'))
        and sum((d['kept_words'] for d in k['documents']), Fr(0)) <= R.MAX_WORDS
        and k['header'] == ('[a sample of the record collected for this part: 37 of 37 documents, chosen by their '
                            'place in date order alone; 27 of them cut]'))
    out['that sample covers every year with a document, yet it is a sample, so its absences are not shown (P45)'] = (
        R.uncovered(k['documents'], D(2000, 1, 1), D(2026, 6, 30)) == [] and not k['whole'])
    # the dates: none after the cutoff; Part 1 from the start; Parts 2 and 3 from 2000; a coder's stage narrows them
    eds = [doc('ed%d' % y, '%d-09-15' % y, ['the ranking of %d ' % y * 200]) for y in range(2011, 2026)]
    late = [doc('news2026', '2026-06-05', ['the ranking is criticised ' * 100]),
            doc('ed2026', '2026-10-01', ['the ranking of 2026 ' * 200])]
    k = R.pack(3, eds + late, TERMS)
    out['no document after the cutoff: the October 2026 edition not collected, the June item shown'] = (
        'ed2026' not in ids_of(k) and 'news2026' in ids_of(k) and k['collected'] == 16)
    out['a kept F2 measure, its record whole: its outcome period, 2012 to 30 June 2026, covered in every year'] = (
        k['whole'] and R.uncovered(k['documents'], D(2012, 5, 1), R.CUTOFF) == [])
    old = [doc('f%d' % y, '%d-03-01' % y, ['an audit of the figures ' * 4000]) for y in range(1996, 2015)]
    out['Part 1 from the case\'s start; Part 2 from 2000 and before a coder\'s refutation date; Part 3 from its '
        'doc_date'] = (
        ids_of(R.pack(1, old, TERMS, start=D(2008, 1, 1))) == ['f%d' % y for y in range(2008, 2015)]
        and ids_of(R.pack(2, old, TERMS, hi=D(2006, 2, 28))) == ['f%d' % y for y in range(2000, 2006)]
        and ids_of(R.pack(3, old, TERMS, lo=D(2005, 3, 1))) == ['f%d' % y for y in range(2005, 2015)])
    und = [doc('u1', None, ['an undated page ' * 100])]
    out['an undated document: shown last in a whole record, not in a sample'] = (
        ids_of(R.pack(3, short[:3] + und, TERMS))[-1] == 'u1'
        and 'u1' not in ids_of(R.pack(3, [work_report(y) for y in range(2000, 2004)] + und, TERMS)))
    # long F2 editions (N2): 22 of about 3,500 words, the name in a late paragraph, and a June 2026 news item
    eds = [doc('ed%d' % y, '%d-09-15' % y, ['methodology notes ' * 750, 'The %d edition of the World Ranking' % y,
                                            'tables ' * 2000]) for y in range(2004, 2026)]
    k = R.pack(3, eds + [doc('news2026', '2026-06-05', ['the World Ranking is criticised ' * 60])],
               TERMS + ['World Ranking'])
    out['22 F2 editions of about 3,500 words, whole: a sample, every edition cut and keeping its edition line, so '
        '"kept" is not shown there (P41)'] = (
        not k['whole'] and all(d['cut'] and any('edition of the World Ranking' in x for x in d['paragraphs'])
                               for d in k['documents'] if d['id'].startswith('ed')))
    kp = R.pack(3, eds + [doc('news2026', '2026-06-05', ['the World Ranking is criticised ' * 60])], TERMS,
                record=R.record_terms(3, 'F2', 'World Ranking'))
    out['the same editions as their passages naming the measure (R1-1): the whole record, each edition by its line'] = (
        kp['whole'] and kp['in the record'] == 23 and all(
            d['paragraphs'][0].startswith('[passages naming the measure: ') for d in kp['documents']
            if d['id'].startswith('ed')))
    # Part 1 (R6-1): the province's hits, a work report and a communiqué each year carrying 审计 (decoys), with a
    # November 2017 admission and a June 2020 audit finding; and an F2 ranking's editions carrying 'admissions' and
    # 'validity', with a 2022 regulator's fine
    prov = [doc('wr%d' % y, '%d-02-10' % y, ['the target in the report, 加强审计监督 ' * 1000]) for y in range(2008, 2027)]
    prov += [doc('cm%d' % y, '%d-03-01' % y, ['the communiqué on the target, 审计 ' * 1000]) for y in range(2008, 2027)]
    prov += [doc('nw%d-%d' % (y, j), '%d-%02d-01' % (y, 5 + 3 * j), ['the target, its audit and adjustment ' * 300])
             for y in range(2008, 2027) for j in range(2)]
    finds = [doc('adm2017', '2017-11-20', ['the province admits that its figures were falsified ' * 20]),
             doc('aud2020', '2020-06-15', ['the audit office finds the figures unreliable ' * 20])]
    k = R.pack(1, prov + finds, TERMS, start=D(2008, 1, 1))
    n = k['collected']
    order = sorted(prov + finds, key=lambda d: (d['date'], d['id']))
    places = [order.index(next(x for x in order if x['id'] == i)) for i in ids_of(k)]
    swapped = [dict(d, paragraphs=['the province admits that its figures were falsified ' * 250])
               if d['id'].startswith('cm') else dict(d, paragraphs=['the target in the report ' * 1250])
               for d in prov + finds]
    out['Part 1, 77 hits in 19 years (one dated after the cutoff not collected): a sample of 60, the earliest and the latest shown, as many places in the '
        'record\'s later half as in its earlier half'] = (
        not k['whole'] and n == 77 and len(places) == 60 and places[0] == 0 and places[-1] == n - 1
        and sum(1 for x in places if 2 * x < n - 1) == sum(1 for x in places if 2 * x > n - 1))
    out['Part 1: which documents are shown does not depend on what they say (the texts exchanged, the same shown)'] = (
        ids_of(R.pack(1, swapped, TERMS, start=D(2008, 1, 1))) == ids_of(k))
    out['Part 1, that sample: a coder\'s "none" there, false or not shown, is open, never "no refutation" (P43)'] = (
        part1_read(k, False) is None and part1_read(k, NOT_SHOWN) is None)
    rep['Part 1, the province: the findings shown in the sample (reported)'] = {
        i: i in ids_of(k) for i in ('adm2017', 'aud2020')}
    rank = [doc('ed%d' % y, '%d-09-15' % y, ['admissions data and the validity of the ranking ' * 600])
            for y in range(2011, 2026)]
    rank += [doc('nw%d-%d' % (y, j), '%d-%02d-01' % (y, 2 + 3 * j), ['the ranking, its admissions and validity ' * 500])
             for y in range(2011, 2027) for j in range(3)]
    fine = doc('fine2022', '2022-08-01', ['the regulator fines the publisher for misleading figures ' * 20])
    k2 = R.pack(1, rank + [fine], TERMS, start=D(2011, 1, 1))
    rep['Part 1, the F2 ranking: the 2022 fine shown in the sample (reported)'] = 'fine2022' in ids_of(k2)
    out['Part 1, the F2 ranking (63 hits): a sample of 60, so a "none" there is open'] = (
        not k2['whole'] and k2['collected'] == 63 and len(k2['documents']) == 60 and part1_read(k2, False) is None)
    k3 = R.pack(1, finds + [prov[0]], TERMS, start=D(2008, 1, 1))
    out['Part 1, a record that fits: the whole record, both findings shown, and only there a "none" is no '
        'refutation'] = (
        k3['whole'] and {'adm2017', 'aud2020'} <= set(ids_of(k3)) and part1_read(k3, False) is False)
    out['the sample\'s places: k of n at even steps of rank, the first and the last included, distinct'] = all(
        len(set(R.sample_positions(n_, k_))) == min(n_, k_) and R.sample_positions(n_, k_)[0] == 0
        and R.sample_positions(n_, k_)[-1] == n_ - 1 for n_ in range(2, 300) for k_ in (2, 30, R.SAMPLE_DOCS))
    # passages (R1-1): a paragraph is kept by the frozen terms alone
    pd = doc('x', '2012-01-01', ['the board meets', 'tables', 'the World Ranking reads a survey', 'tables',
                                 'contact'])
    ps = R.passages(pd, R.record_terms(3, 'F2', 'World Ranking'), 'the measure')
    out['passages: the paragraphs naming the measure kept in order, the rest marked, the document headed; none, not '
        'in the record; all, unchanged'] = (
        ps['paragraphs'] == ['[passages naming the measure: 6 of 12 words]', '[...]',
                             'the World Ranking reads a survey', '[...]']
        and R.passages(pd, ('生产总值',), 'the measure') is None
        and R.passages(doc('y', '2012-01-01', ['WORLD RANKING', 'the World Ranking']), ('World Ranking',),
                       'the measure')['paragraphs'] == ['WORLD RANKING', 'the World Ranking'])
    t = R.record_terms(3, 'F2', 'Academic Ranking of World Universities (ARWU)')
    out['the terms named (R2-3): whole words, an abbreviation as written, a Han term as characters; F2 by its register '
        'name and its abbreviation, not "rank"'] = (
        t == ('Academic Ranking of World Universities', 'ARWU') and R.record_terms(3, 'F2', 'World Ranking') ==
        ('World Ranking',) and not R.names('Frank and the Rank column', ('World Ranking',) + R.MEASURE_TERMS['F2'])
        and R.names('ARWU 2014', t) and not R.names('arwu', t) and not R.names('ARWUS', t)
        and R.names('the academic ranking of world universities', t)
        and R.names('全省生产总值增长', R.record_terms(3, 'F3')) and not R.names('the keyboard', R.record_terms(4, 'F2'))
        and R.names('the Board met', R.record_terms(4, 'F2')))
    the = R.record_terms(3, 'F2', 'Times Higher Education World University Rankings (THE)')
    out['an abbreviation that is a common English word is not a term (R3-5): "(THE)" gives the name alone, so a '
        'heading in capitals with "THE" in it is not a passage'] = (
        the == ('Times Higher Education World University Rankings',) and not R.names('THE RESULTS ARE IN', the)
        and R.names('the Times Higher Education World University Rankings', the)
        and R.register_terms('Leiden Ranking (CWTS)') == ('Leiden Ranking', 'CWTS'))
    out['an F2 ranking whose editions name it in most paragraphs (R2-3): by its passages, more than 50,000 words, '
        'a sample, so no absence is read from its Part 3 (P60)'] = (
        not F2M['whole'] and F2M['shown'] == 'sample' and F2M['in the record'] == 22)
    # the realistic packets (R1-1): whole documents do not fit, their passages do, with every year covered
    f2, f3 = F2P, F3P
    out['the F2 ranking: Part 3 as whole documents a sample; as its passages, the whole record, its years covered from '
        'the revision of 2012 to the drop and from the finding to the drop'] = (
        not f2['part 3, whole documents']['whole'] and f2['part 3']['whole'] and f2['part 3']['shown'] == 'whole'
        and R.uncovered(f2['part 3']['documents'], D(2012, 9, 15), D(2018, 6, 1)) == []
        and R.uncovered(f2['part 3']['documents'], D(2013, 4, 1), D(2018, 6, 1)) == [])
    out['the F2 ranking: Part 4 as the board\'s passages, the whole record, its ten years covered (2008 to 2018)'] = (
        f2['part 4']['whole'] and R.uncovered(f2['part 4']['documents'], D(2008, 6, 1), D(2018, 6, 1)) == [])
    out['the F3 province: Part 3 as whole documents a sample; as its passages, the whole record, every year from the '
        'finding to 30 June 2026 covered'] = (
        not f3['part 3, whole documents']['whole'] and f3['part 3']['whole']
        and R.uncovered(f3['part 3']['documents'], D(2012, 5, 1), R.CUTOFF) == [])
    snaps = [doc('sn%d' % y, '%d-07-01' % y, ['the ranking of the year and its method ' * 25] * 2 +
                 ['other pages ' * 100] * 8) for y in range(2000, 2027)]
    ksn, kws = R.pack(3, snaps, TERMS, record=R.record_terms(3, 'F2', 'X')), R.pack(3, snaps, TERMS)
    out['27 yearly copies of 2,000 words (the reader\'s probe): whole, a sample; as their passages, the whole '
        'record'] = (not kws['whole'] and ksn['whole'])
    rep['the realistic packets, reported'] = {
        'F2 part 3': {'documents in the record': f2['part 3']['in the record'],
                      'words, whole documents': str(sum((d['words'] for d in f2['part 3, whole documents']['documents']),
                                                        Fr(0)) if f2['part 3, whole documents']['whole'] else 'over 50,000'),
                      'words, passages': '%d' % sum((d['words'] for d in f2['part 3']['documents']), Fr(0)),
                      'header': f2['part 3']['header']},
        'F2 part 4': {'words, passages': '%d' % sum((d['words'] for d in f2['part 4']['documents']), Fr(0)),
                      'header': f2['part 4']['header']},
        'F3 part 3': {'documents in the record': f3['part 3']['in the record'],
                      'words, passages': '%d' % sum((d['words'] for d in f3['part 3']['documents']), Fr(0)),
                      'header': f3['part 3']['header']}}
    # a collection not completed (R1-5): never whole, the header saying so, written 'incomplete'
    inc = f2_packets(complete=False)['part 3']
    out['a part whose collection was not completed: shown as it is, never whole, written "incomplete", its header '
        'saying so (P55)'] = (
        not inc['whole'] and inc['shown'] == 'incomplete' and 'not completed' in inc['header']
        and ids_of(inc) == ids_of(f2['part 3']))
    return out, rep


# --- power under independent coder errors ---------------------------------------------------------------------------
def per_case(truth, e):
    """Exact chances of 'refuting', 'out', 'unresolved' for a case whose true conditions are truth, each coder misreading
    each condition independently with chance e (no condition left uncoded)."""
    # a condition None is open for both coders whatever their errors (an unread bound): never passed, never failed
    both_pass = [0 if t is None else (1 - e) ** 2 if t else e ** 2 for t in truth]
    both_fail = [0 if t is None else e ** 2 if t else (1 - e) ** 2 for t in truth]
    ref, none_fail = Fr(1), Fr(1)
    for p, q in zip(both_pass, both_fail):
        ref *= p
        none_fail *= 1 - q
    out = 1 - none_fail
    return ref, out, 1 - ref - out


def power():
    table = {}
    for e in (Fr(1, 50), Fr(1, 20), Fr(1, 10), Fr(1, 5)):
        r_true = per_case([True] * 8, e)
        r_exit = per_case([True] * 7 + [False], e)
        k3 = len(R.THIRD_ORDER) + 1                 # with outlasted
        t_met = per_case([True] * k3, e)
        t_abs = per_case([True] * (k3 - 1) + [False], e)
        false40 = 1 - (1 - r_exit[0]) ** 40
        table['e = %s' % e] = {
            'a refuting case: found refuting / out / unresolved': ['%.4f' % float(x) for x in r_true],
            'a case with one exit (or kept): coded refuting / out / unresolved': ['%.4f' % float(x) for x in r_exit],
            'forty cases each with one exit: chance some is coded refuting': '%.4f' % float(false40),
            'third case met: found met / not met / unresolved': ['%.4f' % float(x) for x in t_met],
            'third case absorbed: coded met / not met / unresolved': ['%.4f' % float(x) for x in t_abs],
        }
    return table


def frame_power():
    """The verdict across a frame of 51 cases and the two controls, under the same independent errors: each case's
    eight conditions as planted; each control with one known exit, a decider finding it (coding some exit true) unless
    it misreads that exit and reads neither other exit wrongly true."""
    frames = {'51 cases, each with one condition false (T7 holding)': [[True] * 7 + [False]] * 51,
              '51 cases, each with one condition false and the bound unread (T7 holding)':
                  [[True] * 6 + [False] + [None]] * 51,
              '51 cases, each with three conditions false (T7 holding)': [[True] * 5 + [False] * 3] * 51,
              '50 cases with three conditions false, 1 refuting': [[True] * 5 + [False] * 3] * 50 + [[True] * 8]}
    table = {}
    for e in (Fr(1, 50), Fr(1, 20), Fr(1, 10), Fr(1, 5)):
        ctl = (1 - e * (1 - e) ** 2) ** 4               # two controls, two deciders each
        row = {}
        for label, truths in frames.items():
            per = [per_case(t, e) for t in truths]
            none_ref, all_out = Fr(1), Fr(1)
            for r, o, _ in per:
                none_ref *= 1 - r
                all_out *= o
            ref = (1 - none_ref) * ctl
            row[label] = {'refuted': '%.4f' % float(ref), 'not refuted or not testable': '%.4f' % float(all_out),
                          'unresolved': '%.4f' % float(1 - ref - all_out)}
        row['both controls show their exit'] = '%.4f' % float(ctl)
        table['e = %s' % e] = row
    return table


# --- refusals of the run's inputs -----------------------------------------------------------------------------------
def input_refusals():
    names = list(PLANTS)
    frame, fb, cases, pb, gb = documents(names)
    out = {}
    out['the planted documents are read'] = not refused(run_verdict, frame, fb, cases, pb, gb)
    c = copy.deepcopy(cases)
    c['cases'].append({'id': 'P99', 'codes': both(R0)})
    out['an enlarged run'] = refused(run_verdict, frame, fb, c, pb, gb)
    c = copy.deepcopy(cases)
    c['cases'] = c['cases'][1:]
    out['an incomplete run'] = refused(run_verdict, frame, fb, c, pb, gb)
    c = copy.deepcopy(cases)
    c['cases'].append(copy.deepcopy(c['cases'][0]))
    out['a case coded twice'] = refused(run_verdict, frame, fb, c, pb, gb)
    out['another frame'] = refused(run_verdict, frame, fb + b' ', cases, pb, gb)
    out['other packets'] = refused(run_verdict, frame, fb, cases, pb + b' ', gb)
    # the packets bound to pages.json (R4-4): cases.json names its sha-256, and the manifest lists it at that sha-256
    g2 = json.loads(gb)
    g2['chosen_by'] = 'a person, by PAGE_CHOICE'
    gb2 = json.dumps(g2, sort_keys=True).encode()
    out['pages.json other than the one the packets were collected from (R4-4)'] = refused(
        run_verdict, frame, fb, cases, pb, gb2)
    pb2 = manifest(gb2)
    c = copy.deepcopy(cases)
    c['pages_sha256'], c['packets_sha256'] = R.sha_bytes(gb2), R.sha_bytes(pb2)
    out['the same pages.json, the codes and the manifest bound to it, is read (R4-4)'] = not refused(
        run_verdict, frame, fb, c, pb2, gb2, word='')
    c = copy.deepcopy(cases)
    c['pages_sha256'] = R.sha_bytes(gb2)
    out['cases.json naming pages.json, the manifest listing another (R4-4)'] = refused(
        run_verdict, frame, fb, c, pb, gb2)
    pb3 = b'synthetic packets\n'
    c = copy.deepcopy(cases)
    c['packets_sha256'] = R.sha_bytes(pb3)
    out['a manifest not listing pages.json (R4-4)'] = refused(run_verdict, frame, fb, c, pb3, gb)
    c = copy.deepcopy(cases)
    del c['pages_sha256']
    out['cases.json not naming pages.json (R4-4)'] = refused(run_verdict, frame, fb, c, pb, gb)
    c = copy.deepcopy(cases)
    c['coders']['A']['model'] = 'google/another-model'
    out['a coder other than the pin'] = refused(run_verdict, frame, fb, c, pb, gb)
    c = copy.deepcopy(cases)
    c['coders']['C']['role'] = 'decides'
    out['the reported-apart coder made a decider'] = refused(run_verdict, frame, fb, c, pb, gb)
    c = copy.deepcopy(cases)
    c['cutoff'] = '2026-10-01'
    out['another cutoff'] = refused(run_verdict, frame, fb, c, pb, gb)
    c = copy.deepcopy(cases)
    c['cases'][0]['codes']['A']['before_drop']['new_reader'] = 'no'
    out['a field of the wrong type'] = refused(run_verdict, frame, fb, c, pb, gb)
    c = copy.deepcopy(cases)
    c['cases'][0]['codes']['A']['before_drop']['why'] = 'a note'
    out['a field not in the layout'] = refused(run_verdict, frame, fb, c, pb, gb)
    c = copy.deepcopy(cases)
    del c['cases'][0]['codes']['B']
    out['a case without a decider'] = refused(run_verdict, frame, fb, c, pb, gb)
    c = copy.deepcopy(cases)
    c['cases'][0]['codes']['A']['drift']['threshold'] = '3/2'
    out['a threshold outside 0 to 1'] = refused(run_verdict, frame, fb, c, pb, gb)
    c = copy.deepcopy(cases)
    c['cases'][0]['codes']['A']['drift']['threshold'] = '1/1'
    out['a unanimity threshold (1/1) is read'] = not refused(run_verdict, frame, fb, c, pb, gb)
    c = copy.deepcopy(cases)
    c['cases'][0]['codes']['A']['refutation']['later'] = [{'date': None, 'kind': 'audit'}]
    out['a later finding without its date'] = refused(run_verdict, frame, fb, c, pb, gb)
    c = copy.deepcopy(cases)
    c['cases'][0]['codes']['A']['before_drop']['uncovered_years'] = ['2014']
    out['a year without a document given as a string'] = refused(run_verdict, frame, fb, c, pb, gb)
    c = copy.deepcopy(cases)
    c['cases'][0]['codes']['A']['drift']['uncovered_years'] = [1899]
    out['a year without a document outside 1900 to 2026'] = refused(run_verdict, frame, fb, c, pb, gb)
    c = copy.deepcopy(cases)
    c['cases'][0]['codes']['A']['outcome']['uncovered_years'] = [2027]
    out['a year without a document after 2026'] = refused(run_verdict, frame, fb, c, pb, gb)
    c = copy.deepcopy(cases)
    c['cases'][0]['codes']['A']['before_drop']['uncovered_years'] = [1998, 1999]
    c['cases'][0]['codes']['A']['drift']['uncovered_years'] = [1998]
    out['a year without a document before 2000 is read, not refused (R3-1)'] = not refused(
        run_verdict, frame, fb, c, pb, gb, word='')
    c = copy.deepcopy(cases)
    c['cases'][0]['codes']['A']['reform']['uncovered_years'] = [2014, 2014]
    out['a year without a document listed twice'] = refused(run_verdict, frame, fb, c, pb, gb)
    c = copy.deepcopy(cases)
    del c['cases'][0]['codes']['A']['shown']
    out['the codes without the parts as shown (R6)'] = refused(run_verdict, frame, fb, c, pb, gb)
    c = copy.deepcopy(cases)
    c['cases'][0]['codes']['A']['shown']['part3'] = 'part'
    out['a part shown as neither whole nor a sample (R6)'] = refused(run_verdict, frame, fb, c, pb, gb)
    c = copy.deepcopy(cases)
    c['cases'][0]['codes']['A']['before_drop']['new_reader'] = 'not in the record'
    out['an answer other than true, false, not shown or null (R6)'] = refused(run_verdict, frame, fb, c, pb, gb)
    c = copy.deepcopy(cases)
    c['cases'][0]['codes']['A']['premise']['rule_by_ranked'] = NOT_SHOWN
    out['not shown where the codebook does not offer it (Part 2) (R6)'] = refused(run_verdict, frame, fb, c, pb, gb)
    c = copy.deepcopy(cases)
    c['cases'][0]['codes']['A']['shown']['part2'] = None
    out['a part not recorded as shown is read, as not whole (R6)'] = not refused(run_verdict, frame, fb, c, pb, gb,
                                                                                    word='')
    c = copy.deepcopy(cases)
    c['cases'][0]['codes']['A']['shown']['part4'] = 'incomplete'
    out['a part whose collection was not completed is read, as not whole (R1-5)'] = not refused(
        run_verdict, frame, fb, c, pb, gb, word='')
    c = copy.deepcopy(cases)
    c['cases'][0]['codes']['A']['drift']['replacements'] = 12
    out['replacements given as a number (R1-2)'] = refused(run_verdict, frame, fb, c, pb, gb)
    c = copy.deepcopy(cases)
    c['cases'][0]['codes']['A']['drift']['replacements'][0]['entrant'] = 'ranked'
    out['a replacement whose entrant is neither favoured nor other (R1-2)'] = refused(run_verdict, frame, fb, c, pb, gb)
    c = copy.deepcopy(cases)
    c['cases'][0]['codes']['A']['drift']['replacements'][0]['date'] = None
    out['a replacement without its date (R1-2)'] = refused(run_verdict, frame, fb, c, pb, gb)
    c = copy.deepcopy(cases)
    c['cases'][0]['codes']['A']['before_drop']['from_date'] = '2012'
    out['an exits\' period start that is not a date (R1-3)'] = refused(run_verdict, frame, fb, c, pb, gb)
    c = copy.deepcopy(cases)
    del c['run_log']
    out['a run without its log'] = refused(run_verdict, frame, fb, c, pb, gb)
    c = copy.deepcopy(cases)
    c['run_log']['other_model']['A'] = 1
    out['void: a pin response naming another model'] = voided(run_verdict, frame, fb, c, pb, gb)
    stages = 4 * len(cases['cases'])
    c = copy.deepcopy(cases)
    c['run_log']['malformed']['B'] = stages // 5 + 1
    out['void: more than a fifth of a decider\'s stage answers malformed'] = voided(run_verdict, frame, fb, c, pb, gb)
    c = copy.deepcopy(cases)
    c['run_log']['malformed']['B'] = stages // 5
    out['a fifth of a decider\'s stage answers malformed, no more: read'] = not refused(
        run_verdict, frame, fb, c, pb, gb, word='')
    c = copy.deepcopy(cases)
    c['run_log']['malformed']['C'] = stages
    out['the reported-apart coder\'s malformed answers do not void'] = not refused(
        run_verdict, frame, fb, c, pb, gb, word='')
    out['the people-alone set, no reported-apart coder, is read'] = not refused(
        run_verdict, *documents(names, coder_set='people-alone'), word='')
    f3 = copy.deepcopy(frame)
    f3['cases'][0]['name'] = 'the province\'s reported GDP figures'
    fb3 = json.dumps(f3, sort_keys=True).encode()
    c = copy.deepcopy(cases)
    c['frame_sha256'] = R.sha_bytes(fb3)
    out['a case not named by its frame\'s frozen text'] = refused(run_verdict, f3, fb3, c, pb, gb)
    f3 = copy.deepcopy(frame)
    f3['controls'][0]['name'] = 'LIBOR'
    fb3 = json.dumps(f3, sort_keys=True).encode()
    c['frame_sha256'] = R.sha_bytes(fb3)
    out['a control not named by its frozen text'] = refused(run_verdict, f3, fb3, c, pb, gb)
    f2 = copy.deepcopy(frame)
    f2['controls'] = f2['controls'][:1]
    fb2 = json.dumps(f2, sort_keys=True).encode()
    c = copy.deepcopy(cases)
    c['frame_sha256'] = R.sha_bytes(fb2)
    c['cases'] = [x for x in c['cases'] if x['id'] != 'C-PSA']
    out['a frame without both controls'] = refused(run_verdict, f2, fb2, c, pb, gb)
    # pages.json, the pages chosen by kind before the packets (R3-2), a case's sites each its own entry (R4-1)
    good = pages_of(frame)
    out['pages.json chosen by kind, a moved page under each of its addresses, is read (R3-2)'] = not refused(
        R.validate_pages, frame, good, word='')
    g = copy.deepcopy(good)
    g['cases'][0]['sites'].append(site('https://board.example.invalid/', 'start', 'body', range(2000, 2027),
                                       [('members', 'governance', range(2005, 2027)), ('news', 'notices', [2015])]))
    g['cases'][0]['candidates'].append(cand('https://board.example.invalid/', g['cases'][0]['candidates'][0]['from'],
                                            'body'))
    out['pages.json with a publisher\'s site and a body\'s site for one case is read (R4-1)'] = not refused(
        R.validate_pages, frame, g, word='')
    g['cases'][1]['candidates'][0]['home'] = 'https://old.example.invalid/'
    g['cases'][1]['sites'] = [site('https://old.example.invalid/', 'start', 'publisher', range(2000, 2009),
                                   [('method', 'method', range(2003, 2009))]),
                              site('https://new.example.invalid/', 'redirect', 'publisher', range(2009, 2027),
                                   [('about/methodology', 'method', range(2009, 2027))],
                                   'https://old.example.invalid/')]
    out['pages.json with a site moved to a new domain in 2009, found by its redirect, is read (R4-1)'] = not refused(
        R.validate_pages, frame, g, word='')
    libor = next(x for x in g['cases'] if x['case'] == 'C-LIBOR')
    libor['candidates'] = [dict(libor['candidates'][0], home='https://old-administrator.example.invalid/'),
                           libor['candidates'][1]]
    old_admin = 'https://old-administrator.example.invalid/'
    libor['sites'] = [site(old_admin, 'start', 'publisher', range(2000, 2027),
                           [('libor/method', 'method', range(2000, 2015))]),
                      site('https://new-administrator.example.invalid/', 'link', 'publisher', range(2014, 2027),
                           [('benchmarks/libor/methodology', 'method', range(2014, 2027)),
                            ('benchmarks/libor/notices', 'notices', range(2014, 2027))], old_admin),
                      site('https://news.example.invalid/', 'link', 'neither', range(2012, 2027), (), old_admin)]
    out['pages.json with a measure handed to a new site linked from the old, beside a site of neither role, is '
        'read (R4-1)'] = not refused(R.validate_pages, frame, g, word='')
    deep = 'https://group.example.invalid/markets/benchmarks/rates/libor/'
    libor['sites'].append(site(deep, 'link', 'publisher', range(2015, 2027),
                               [('methodology', 'method', range(2015, 2027))], old_admin))
    out['pages.json with a link site whose home is the linked address deep in a large site, not its root, is read '
        '(R5-2)'] = not refused(R.validate_pages, frame, g, word='')
    out['pages.json as given, every home listed to the chooser once, is read (R5-4)'] = R.pages_as_given(
        g, given_of(g))
    h = copy.deepcopy(g)
    h['cases'][1]['sites'] = h['cases'][1]['sites'][:1]
    out['pages.json dropping a site the chooser was given (R5-4)'] = not R.pages_as_given(h, given_of(g))
    h = copy.deepcopy(g)
    h['cases'][0]['candidates'] = h['cases'][0]['candidates'][:-1]
    out['pages.json dropping a start candidate the chooser was given (R5-4)'] = not R.pages_as_given(h, given_of(g))
    h = copy.deepcopy(g)
    h['cases'][1]['sites'][1]['years'] = list(range(2010, 2027))
    out['pages.json with a site\'s years other than the collector\'s (R5-4)'] = not R.pages_as_given(h, given_of(g))
    h = copy.deepcopy(g)
    gv = given_of(g)
    gv['cases'][1]['sites'].append({'home': 'https://more.example.invalid/', 'found': 'link',
                                    'from': 'https://old.example.invalid/', 'years': [2020]})
    out['pages.json without a site listed to the chooser that it left out of its answer (R5-4)'] = \
        not R.pages_as_given(h, gv)
    g['cases'][2]['sites'] = []
    for c in g['cases'][2]['candidates']:
        c['role'] = 'neither'
    out['pages.json with a case for which no site is found, its start candidates all of the role neither, is read '
        '(R3-2)'] = not refused(
        R.validate_pages, frame, g, word='')
    g = copy.deepcopy(good)
    g['cases'] = g['cases'][1:]
    out['pages.json without an F2 case (R3-2)'] = refused(R.validate_pages, frame, g)
    g = copy.deepcopy(good)
    g['cases'].append({'case': next(x['id'] for x in frame['cases'] if x['frame'] == 'F3'), 'candidates': [],
                       'sites': []})
    out['pages.json with an F3 case, whose sources are fixed by kind (R3-2)'] = refused(R.validate_pages, frame, g)
    g = copy.deepcopy(good)
    g['cases'][0]['sites'][0]['pages'][0]['kind'] = 'news'
    out['pages.json with a page of another kind (R3-2)'] = refused(R.validate_pages, frame, g)
    g = copy.deepcopy(good)
    g['cases'][0]['sites'][0]['pages'][0]['years'] = [1999]
    out['pages.json with a page\'s year before 2000 (R3-2)'] = refused(R.validate_pages, frame, g)
    g = copy.deepcopy(good)
    del g['chosen_by']
    out['pages.json not saying who chose the pages (R3-2)'] = refused(R.validate_pages, frame, g)
    g = copy.deepcopy(good)
    g['cases'][0] = {'case': g['cases'][0]['case'], 'site': g['cases'][0]['sites'][0]['home'],
                     'pages': g['cases'][0]['sites'][0]['pages']}
    out['pages.json with one site field for a case, the earlier layout (R4-1)'] = refused(R.validate_pages, frame, g)
    g = copy.deepcopy(good)
    g['cases'][0]['sites'].append(copy.deepcopy(g['cases'][0]['sites'][0]))
    g['cases'][0]['sites'][1]['role'] = 'body'
    out['pages.json listing one home twice in a case (R4-1)'] = refused(R.validate_pages, frame, g)
    g = copy.deepcopy(good)
    g['cases'][0]['sites'][0]['years'] = list(range(2015, 2027))
    out['pages.json with a page of a year in which its site was not read (R4-1)'] = refused(
        R.validate_pages, frame, g)
    g = copy.deepcopy(good)
    g['cases'][0]['sites'][0]['role'] = 'neither'
    out['pages.json with pages on a site of neither role (R4-1)'] = refused(R.validate_pages, frame, g)
    g = copy.deepcopy(good)
    g['cases'][0]['sites'][0]['role'] = 'government'
    out['pages.json with a site\'s role other than publisher, body or neither (R4-1)'] = refused(
        R.validate_pages, frame, g)
    g = copy.deepcopy(good)
    g['cases'][0]['sites'][0]['found'] = 'search'
    out['pages.json with a site found otherwise than as a start, a redirect or a link (R4-1)'] = refused(
        R.validate_pages, frame, g)
    g = copy.deepcopy(good)
    g['cases'][0]['sites'][0]['years'] = [1999] + list(range(2000, 2027))
    out['pages.json with a site read in a year before 2000 (R4-1)'] = refused(R.validate_pages, frame, g)
    # the start sites found by the frozen rule (R5-1)
    g = copy.deepcopy(good)
    g['cases'][0]['candidates'][0]['from'] = ['the collector\'s own choice']
    out['pages.json with a start candidate from neither the register entry nor a frozen start query (R5-1)'] = \
        refused(R.validate_pages, frame, g)
    g = copy.deepcopy(good)
    g['cases'][0]['candidates'][0]['from'] = [R.REGISTER]
    out['pages.json with a start candidate from an address the register entry gives is read (R5-1)'] = not refused(
        R.validate_pages, frame, g, word='')
    g = copy.deepcopy(good)
    g['cases'][0]['candidates'] = g['cases'][0]['candidates'][1:]
    out['pages.json with a start site that is not a start candidate (R5-1)'] = refused(R.validate_pages, frame, g)
    g = copy.deepcopy(good)
    g['cases'][0]['candidates'][1]['role'] = 'body'
    out['pages.json with a start candidate of the role body but no start site for it (R5-1)'] = refused(
        R.validate_pages, frame, g)
    g = copy.deepcopy(good)
    g['cases'][0]['candidates'].append(copy.deepcopy(g['cases'][0]['candidates'][1]))
    out['pages.json listing one start candidate twice (R5-1)'] = refused(R.validate_pages, frame, g)
    g = copy.deepcopy(good)
    g['cases'][0]['sites'].append(site('https://new.example.invalid/', 'redirect', 'publisher', range(2010, 2027),
                                       (), 'https://elsewhere.example.invalid/'))
    out['pages.json with a redirect site found from no site of the case (R5-1)'] = refused(R.validate_pages, frame, g)
    g = copy.deepcopy(good)
    g['cases'][0]['sites'][0]['from'] = 'https://example.invalid/'
    out['pages.json with a start site said to be found from another (R5-1)'] = refused(R.validate_pages, frame, g)
    g = copy.deepcopy(good)
    a0 = g['cases'][0]['sites'][0]['home']
    g['cases'][0]['sites'] += [site('https://l1.example.invalid/', 'link', 'publisher', range(2010, 2027), (), a0),
                               site('https://l2.example.invalid/', 'link', 'publisher', range(2012, 2027), (),
                                    'https://l1.example.invalid/')]
    out['pages.json with a link found from a link site, not a start or a redirect site (R5-1)'] = refused(
        R.validate_pages, frame, g)
    g = copy.deepcopy(good)
    del g['cases'][0]['candidates']
    out['pages.json without a case\'s start candidates, the earlier layout (R5-1)'] = refused(
        R.validate_pages, frame, g)
    return out


# --- refusals of the freeze, in a scratch repository ----------------------------------------------------------------
def git(root, *a):
    return subprocess.run(['git', '-C', str(root), '-c', 'user.name=dry', '-c', 'user.email=dry@invalid',
                           '-c', 'commit.gpgsign=false', *a], capture_output=True, text=True)


def freeze_refusals():
    out = {}
    tmp = Path(tempfile.mkdtemp(prefix='t7f-dry-'))
    try:
        req = R.REQUIRED
        git(tmp, 'init', '-q')
        for p in req:
            (tmp / p).parent.mkdir(parents=True, exist_ok=True)
            (tmp / p).write_text('synthetic ' + p + '\n')
        frozen = tmp / R.D / 'FROZEN.sha256'
        check = lambda: R.frozen_check(frozen=frozen, root=tmp, required=req)
        out['no FROZEN.sha256'] = refused(check)
        git(tmp, 'add', '.')
        git(tmp, 'commit', '-q', '-m', 'files')
        lines = [R.sha(tmp / p) + '  ' + p for p in sorted(req)]
        frozen.write_text('\n'.join(lines[1:]) + '\n')
        out['FROZEN.sha256 not listing a required file'] = refused(check)
        frozen.write_text('\n'.join(lines) + '\n')
        out['FROZEN.sha256 uncommitted'] = refused(check)
        git(tmp, 'add', '.')
        git(tmp, 'commit', '-q', '-m', 'freeze')
        out['a clean freeze passes'] = not refused(check)
        target = tmp / req[0]
        keep = target.read_bytes()
        target.write_text('changed\n')
        out['a frozen file changed'] = refused(check)
        target.write_bytes(keep)
        frozen.write_text('\n'.join(lines) + '\n' + '\n')
        git(tmp, 'commit', '-q', '-am', 'second')
        out['FROZEN.sha256 committed twice'] = refused(check)
        # each step committed before the next (R1-7, R3-2): the freeze, frame.json, pages.json, PACKETS.sha256,
        # cases.json
        steps = [R.D + 'FROZEN.sha256', 'run/frame.json', 'run/pages.json', 'run/PACKETS.sha256', 'run/cases.json']
        (tmp / 'run').mkdir()
        order = lambda: R.committed_in_order(tmp, steps)
        for k, p in enumerate(steps[1:]):
            (tmp / p).write_text('step %d\n' % k)
            git(tmp, 'add', p)
            git(tmp, 'commit', '-q', '-m', p)
        out['the steps committed in order pass'] = not refused(order)
        late = tmp / 'run' / 'late.json'
        late.write_text('{}\n')
        out['a step never committed'] = refused(R.committed_in_order, tmp, steps[:4] + ['run/late.json'])
        git(tmp, 'add', 'run/late.json')
        git(tmp, 'commit', '-q', '-m', 'late')
        out['a coding committed before its packets\' manifest'] = refused(
            R.committed_in_order, tmp, [steps[1], 'run/late.json', steps[4]])
        (tmp / 'run' / 'a.json').write_text('a\n')
        (tmp / 'run' / 'b.json').write_text('b\n')
        git(tmp, 'add', 'run/a.json', 'run/b.json')
        git(tmp, 'commit', '-q', '-m', 'two steps at once')
        out['two steps in one commit'] = refused(R.committed_in_order, tmp, ['run/a.json', 'run/b.json'])
        # a step changed after the next was added (R2-4): the frame after the manifest, the manifest after the coding
        def commit(p, text):
            (tmp / p).parent.mkdir(exist_ok=True)
            (tmp / p).write_text(text)
            git(tmp, 'add', p)
            git(tmp, 'commit', '-q', '-m', p)
        two = [steps[0], 'run2/frame.json', 'run2/PACKETS.sha256', 'run2/cases.json']
        commit(two[1], 'frame\n')
        commit(two[2], 'packets\n')
        commit(two[1], 'frame, a case dropped after the packets were seen\n')
        commit(two[3], 'codes\n')
        out['a frame changed after the packets\' manifest was committed'] = refused(R.committed_in_order, tmp, two)
        three = [steps[0], 'run3/frame.json', 'run3/PACKETS.sha256', 'run3/cases.json']
        commit(three[1], 'frame\n')
        commit(three[2], 'packets\n')
        commit(three[3], 'codes\n')
        out['the same steps unchanged after the next pass'] = not refused(R.committed_in_order, tmp, three)
        four = [steps[0], 'run4/frame.json', 'run4/pages.json', 'run4/PACKETS.sha256', 'run4/cases.json']
        commit(four[1], 'frame\n')
        commit(four[3], 'packets, collected before the pages were chosen\n')
        commit(four[2], 'pages\n')
        commit(four[4], 'codes\n')
        out['pages chosen after the packets\' manifest was committed (R3-2)'] = refused(R.committed_in_order, tmp, four)
        five = [steps[0], 'run5/frame.json', 'run5/pages.json', 'run5/PACKETS.sha256', 'run5/cases.json']
        commit(five[1], 'frame\n')
        commit(five[2], 'pages\n')
        commit(five[3], 'packets\n')
        commit(five[2], 'pages, changed after the packets were read\n')
        commit(five[4], 'codes\n')
        out['pages changed after the packets\' manifest was committed (R3-2)'] = refused(R.committed_in_order, tmp, five)
        commit(three[2], 'packets, rewritten after the coding\n')
        commit(three[3], 'codes, written again\n')
        out['a packets\' manifest changed after the coding was committed'] = refused(R.committed_in_order, tmp, three)
        # a readout already there
        ro = tmp / 'verdict.json'
        R.write_once(ro, {'x': 1})
        out['a readout already there'] = refused(R.write_once, ro, {'x': 2})
        out['the readout written once is whole'] = json.loads(ro.read_text()) == {'x': 1}
    finally:
        shutil.rmtree(tmp, ignore_errors=True)
    env = dict(os.environ, PYTHONDONTWRITEBYTECODE='1')
    p = subprocess.run([sys.executable, '-B', '-O', str(HERE / 'reform_rule.py'), 'check'], capture_output=True,
                       text=True, env=env)
    out['python3 -O'] = p.returncode != 0 and 'refused: python3 -O' in p.stderr
    out['the required paths exist here (the result itself once written)'] = all(
        (R.ROOT / p).exists() for p in R.REQUIRED if not p.endswith('dry-run.json'))
    return out


def verdict_path_checks():
    """main's verdict path, verdict_from_files, with its four files, in a scratch repository (R4-4): the steps
    committed in order and bound to one another pass and write the readout once; the files given in another order,
    a pages.json other than the one the manifest lists, and a readout already there are refused."""
    out = {}
    tmp = Path(tempfile.mkdtemp(prefix='t7f-dry-verdict-'))
    try:
        req = R.REQUIRED
        git(tmp, 'init', '-q')
        for p in req:
            (tmp / p).parent.mkdir(parents=True, exist_ok=True)
            (tmp / p).write_text('synthetic ' + p + '\n')
        git(tmp, 'add', '.')
        git(tmp, 'commit', '-q', '-m', 'files')
        frozen = tmp / R.D / 'FROZEN.sha256'
        frozen.write_text('\n'.join(R.sha(tmp / p) + '  ' + p for p in sorted(req)) + '\n')
        git(tmp, 'add', '.')
        git(tmp, 'commit', '-q', '-m', 'freeze')
        name = next(n for n in PLANTS if n.startswith('P01'))

        def steps(run, frame_b, pages_b, packets_b, cases_obj):
            files = []
            for f, b in (('frame.json', frame_b), ('pages.json', pages_b), ('PACKETS.sha256', packets_b),
                         ('cases.json', json.dumps(cases_obj, sort_keys=True).encode())):
                q = tmp / run / f
                q.parent.mkdir(exist_ok=True)
                q.write_bytes(b)
                git(tmp, 'add', str(q.relative_to(tmp)))
                git(tmp, 'commit', '-q', '-m', run + '/' + f)
                files.append(q)
            return files
        kw = dict(root=tmp, frozen=frozen, required=req)
        frame, fb, cases, pb, gb = documents([name])
        files = steps('run', fb, gb, pb, cases)
        ro = tmp / 'verdict.json'
        try:
            res = R.verdict_from_files(*files, out=ro, **kw)
            out['the four files in the steps\' order, committed in order and bound, give the verdict (R4-4)'] = (
                res['refuted by']['verdict'] == 'refuted' and json.loads(ro.read_text())['refuted by']['verdict']
                == 'refuted')
        except SystemExit:
            out['the four files in the steps\' order, committed in order and bound, give the verdict (R4-4)'] = False
        out['the verdict path with a readout already there (R4-4)'] = refused(
            lambda: R.verdict_from_files(*files, out=ro, **kw))
        frame_f, pages_f, packets_f, cases_f = files
        out['the four files in the earlier order, frame, cases, packets, pages (R4-4)'] = refused(
            lambda: R.verdict_from_files(frame_f, cases_f, packets_f, pages_f, out=tmp / 'v2.json', **kw))
        g2 = json.loads(gb)
        g2['cases'][0]['sites'][0]['pages'] = g2['cases'][0]['sites'][0]['pages'][:1]
        gb2 = json.dumps(g2, sort_keys=True).encode()
        c = copy.deepcopy(cases)
        c['pages_sha256'] = R.sha_bytes(gb2)
        files2 = steps('run2', fb, gb2, pb, c)
        out['a committed pages.json other than the one the manifest lists (R4-4)'] = refused(
            lambda: R.verdict_from_files(*files2, out=tmp / 'v3.json', **kw))
        out['no readout written by a refused run (R4-4)'] = not (tmp / 'v2.json').exists() and not (
            tmp / 'v3.json').exists()
    finally:
        shutil.rmtree(tmp, ignore_errors=True)
    return out


# --- the plants -----------------------------------------------------------------------------------------------------
def plant_checks():
    names = list(PLANTS)
    res = run_verdict(*documents(names))
    rows = {r['id']: r for r in res['cases']}
    per = {}
    for n in names:
        _, st, reason, third = PLANTS[n][:4]
        r = rows[n[:3]]
        per[n] = {'status': r['refuted by']['status'], 'reason': r['refuted by']['reason'],
                  'third case': r['third case']['status'],
                  'as planted': (r['refuted by']['status'] == st and r['refuted by']['reason'] == reason
                                 and r['third case']['status'] == third
                                 and r['what each decider read'] == R.what_was_read(PLANTS[n][0], ('A', 'B')))}
    scen = {}

    def sc(label, ns, want, want3, controls=CTL_OK, apart=None):
        v = run_verdict(*documents(ns, controls))
        got = v['refuted by']['verdict'], v['third case']['verdict']
        row = {'cases': [n[:3] for n in ns], 'refuted by': got[0], 'why': v['refuted by']['why'], 'third case': got[1],
               'as planted': got == (want, want3)}
        if apart is not None:
            row['reported apart, read alone'] = v['reported apart']['C']['its codes read alone']
            row['as planted'] = row['as planted'] and row['reported apart, read alone'] == apart
        scen[label] = row
        return v

    allv = sc('every plant', names, 'refuted', 'met')
    sc('every plant but the refuting ones', [n for n in names if n[:3] not in ('P01', 'P23', 'P35', 'P53', 'P56', 'P58')],
       'unresolved', 'met')
    resolved = [n for n in names if n[:3] in ('P02', 'P03', 'P04', 'P07', 'P08', 'P09', 'P10', 'P11', 'P12', 'P13',
                                               'P15', 'P16', 'P17', 'P19', 'P20', 'P21', 'P24', 'P26', 'P28', 'P29',
                                               'P34', 'P39', 'P57', 'P59', 'P61')]
    sc('resolved cases only, none refuting; the reported-apart coder finds P17 refuting', resolved, 'not refuted',
       'not met', apart='refuted')
    sc('no case meets the premise and the refutation', [n for n in names if n[:3] in ('P10', 'P12')], 'not testable',
       'not testable')
    sc('a refuting case, but a control coded with its known exit missed', [names[0]], 'unresolved', 'not testable',
       controls=CTL_MISSED)
    sc('a refuting case beside two controls whose exits are all null (F2)', [names[0]], 'unresolved', 'not testable',
       controls=CTL_NULL)
    sc('a refuting case beside a control dropped by another body with no exit coded (F2)', [names[0]], 'unresolved',
       'not testable', controls=CTL_OUTSIDE_ONLY)
    sc('a refuting case beside a control whose new reader came before a full-weight revision before its drop (R3-1): '
       'the exit found', [names[0]], 'refuted', 'not testable', controls=CTL_BEFORE_REVISION)
    sc('the drift-unresolved drop alone', [n for n in names if n[:3] == 'P05'], 'unresolved', 'not testable')
    sc('a third case met, but a control coded with its known exit missed (N5)', [n for n in names if n[:3] == 'P14'],
       'not refuted', 'unresolved', controls=CTL_MISSED)
    sc('every case read on samples, each coder coding every absence false (R6): never out or not met by absence',
       [n for n in names if n[:3] in ('P43', 'P45', 'P47')], 'unresolved', 'unresolved')
    sc('the realistic F2 case alone, on its packets (R1-1): refuted, where both controls show their exit',
       [n for n in names if n[:3] == 'P56'], 'refuted', 'not testable')
    second = allv['second Forbids clause']
    return per, scen, allv['refuted by']['tally'], allv['refuted by']['controls'], second


def main():
    before = code_hashes()
    per, scen, tally, controls, second = plant_checks()
    caps, caps_reported = packing_checks()
    result = {
        'what this is': "T7F's dry run: synthetic coded cases through reform_rule.verdict; no record read, no model call",
        'fixed values': {'threshold': str(R.THRESHOLD), 'window years': R.WINDOW_YEARS,
                         'start': {k: v.isoformat() for k, v in sorted(R.START.items())},
                         'cutoff': R.CUTOFF.isoformat(), 'min turnover': R.MIN_TURNOVER},
        'plants, case by case': per,
        'scenarios': scen,
        'tally, every plant': tally,
        'controls, every plant': controls,
        'second Forbids clause, every plant (reported)': second,
        'drift bound': drift_checks(),
        'the drift clause under drift alone, simulated (R2-1)': None,
        "the packets' caps": caps,
        "the packets' caps, reported": caps_reported,
        'power under independent coder errors': power(),
        'power across a frame of 51 cases': frame_power(),
        'refusals of the inputs': input_refusals(),
        'refusals of the freeze': freeze_refusals(),
        'the verdict path, four files, in a scratch repository (R4-4)': verdict_path_checks(),
    }
    again = plant_checks()
    sim_ok, sim_rows, sim_counted = drift_simulation()
    result['the drift clause under drift alone, simulated (R2-1)'] = {
        'bodies per setting': SIM_BODIES, 'seed': SIM_SEED, 'rows': sim_rows,
        'settings counted (some body read)': sim_counted,
        'under rho = 1 and rho = 4/5, read rare in at most 1/20 of the bodies of every setting counted': sim_ok}
    result['the same twice'] = again == (per, scen, tally, controls, second)
    after = code_hashes()
    checks = [v['as planted'] for v in per.values()] + [v['as planted'] for v in scen.values()]
    d = result['drift bound']
    checks += [v for k, v in d.items() if isinstance(v, bool)]
    checks.append(sim_ok)
    checks += list(result["the packets' caps"].values())
    checks += list(result['refusals of the inputs'].values()) + list(result['refusals of the freeze'].values())
    checks += list(result['the verdict path, four files, in a scratch repository (R4-4)'].values())
    checks.append(result['the same twice'])
    result['checks'] = len(checks)
    result['ok'] = all(checks)
    result['code_hashes'] = before
    result['code_unchanged_during_the_run'] = before == after
    (HERE / 'results').mkdir(exist_ok=True)
    (HERE / 'results' / 'dry-run.json').write_text(json.dumps(result, indent=1, sort_keys=True, ensure_ascii=False)
                                                   + '\n', encoding='utf-8')
    print('ok' if result['ok'] else 'FAILED', result['checks'], 'checks')
    if not result['ok']:
        raise SystemExit(1)


if __name__ == '__main__':
    main()
