"""T7F, T7's field test of reform events (DESIGN.md): the verdict rule, read from coded cases in a fixed layout.

    python3 -B reform_rule.py check                         # the freeze's files against FROZEN.sha256; writes nothing
    python3 -B reform_rule.py verdict FRAME PAGES PACKETS CASES   # on Ren's yes, after the coding: results/verdict.json

AI-written (a Claude Code session), not yet reviewed by a person. Frozen before any record or value of the data is read.

What it reads. FRAME is the frame's listing (frame.json, the run's step 1), PAGES the sites' pages chosen by kind
(pages.json, step 2, before any listed page's text is read), PACKETS the packets' manifest (PACKETS.sha256, step 3),
CASES the coders' codes (cases.json, step 5), given in the steps' order. Each must be committed and unchanged. The layout
of each is fixed below (validate_frame, validate_pages, validate_cases); any other key, type or case refuses the run.
cases.json names the sha-256 of the frame, pages.json and the manifest, and the manifest lists pages.json at its
sha-256 (pages_bound), so the packets coded are those collected from the pages chosen.

What it decides. The Refuted by of 02 §9 (T7), one case at a time, by two deciding coders (PINS 'decides'):

  a case refutes where both deciding coders find every condition below, in this order:
    refutation    a dated public finding of a frozen kind, from the frame's start date (START) to the cutoff (findings
                  dated before START are set aside, and the earliest remaining one shown is the refutation);
    premise       the measure's reading and its rule both set by those it ranks, in a document dated before every
                  finding shown and from 1 January 2000 (SOURCES_FROM), where the packets' sources begin; one dated
                  earlier is read as not given, so a premise documented only before 2000 cannot refute;
    dropped       the measure dropped within ten years of a finding shown (the earliest or a later one), by the cutoff;
    by_selectors  dropped by the body that forms its rule, not by another body;
    no_new_reader, no_loss_entering   neither exit from the premise's document to the drop;
    no_new_reading  no new reading from the measure's last regular revision before the drop that kept its weight, or
                  else from the premise's document, to the drop (a change of the reading the measure outlived at full
                  weight is absorbed, reading_absorbed; a new reader or a loss is not);
    drift_rare    the drawn model's bound (DrawnReplacement.lost_above's form, 02 §9) read on the case at most 1/20,
                  the step ratio read at its lower 1/20 confidence limit from who entered and who left the body at
                  the counts they did (turnover).

  Not shown is not 'not in the record' (DESIGN §3). Each part a coder reads is the whole record collected for it, or
  a sample of it, or a record whose collection was not completed, read as a sample (pack; the assembler writes which,
  per coder and part, into the codes' 'shown' group). Parts 3 and 4's record is the listed sources' documents, each by
  its passages naming the measure or the body (record_terms, passages), so that a record can fit. A question of
  absence is answered true (shown), false (not in the record), 'not shown' (not shown in what was read) or null. A
  false, or a 'no change' true, stands only where the part was shown whole and the coder lists no year of the period
  without a document (uncovered_years == []); 'not shown', and a false or 'no change' read on a sample or an uncovered
  period, are open (None), never failed or met by absence. So no refutation, 'kept', no reform, a drop outside every
  shown finding's window, the exits, the third case's absences and the drift bound's counts are read as absent only
  from a whole part.

  A condition both coders find unmet puts the case out, with the first such condition as its reason. A condition
  either coder leaves uncoded or the two code apart leaves the case unresolved. The drift bound is computed from each
  coder's inputs; where either coder's inputs cannot be read by the model's premises (Part 4 shown whole, and the ten
  years each covered by a document in it), the case is unresolved by drift.

  The verdict: 'refuted' where a frame case refutes and both positive controls had a known exit found (each deciding
  coder coding at least one of the three exits true; a drop by another body alone is not enough); else 'unresolved'
  where a frame case is unresolved (or a frame case refutes and a control did not show its exit); else 'not refuted'
  where some frame case met the refutation and the premise; else 'not testable'. The count of refuting cases is
  reported, not used. Void (no verdict): a pin's response naming another model, or more than a fifth of a decider's
  stage answers left null for want of a well-formed answer, as the run's log in cases.json counts them.

Also computed: the third forbidden case (a reform of the reading alone outlasting the next reading), its own verdict
('met' only where both positive controls had their exit found, as for 'refuted'; 'unresolved', 'not met', 'not
testable'); the second Forbids clause's count against the bounds, reported and
deciding nothing; the coders' agreement; and the reported-apart coder's codes read alone, which move nothing.

Also here, deciding nothing: pack, the packets' caps of DESIGN §3 (the whole record where it fits, or else a sample of
fixed positions in date order, each document cut to an equal share), a reference for the step-0 addendum's collector
and client, checked in the dry run.

Every number is exact (fractions), so no platform is pinned. It refuses under python3 -O, unless FROZEN.sha256 lists
every file REQUIRED names with its bytes, committed unchanged, FROZEN.sha256 itself committed once, where a readout
is already there, and unless FROZEN.sha256, frame.json, pages.json, PACKETS.sha256 and cases.json were committed in
that order, each last changed in a commit before the one that added the next (committed_in_order)."""
import hashlib
import json
import os
import re
import subprocess
import sys
from datetime import date
from fractions import Fraction as Fr
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]          # the repository's root: FROZEN.sha256 lists paths from it
RESULTS = HERE / 'results'
FROZEN = HERE / 'FROZEN.sha256'
D = 'experiments/reform-events/'
REQUIRED = [D + 'reform_rule.py', D + 'reform_dry_run.py', D + 'write_frozen.py', D + 'CODEBOOK.md',
            D + 'results/dry-run.json']

# --- fixed values ---------------------------------------------------------------------------------------------------
THRESHOLD = Fr(1, 20)           # 'drift alone would rarely leave it': the bound at most 1/20
LEVEL = Fr(1, 20)               # the ratio rho read at its one-sided lower confidence limit at this level (turnover)
BISECTIONS = 24                 # halvings of [0, 1 / x*] that find that limit, its lower end taken
WINDOW_YEARS = 10               # a drop counts within ten years of the refutation
# Refutations from the frame's start date, 1 January of its register's year, so that the register precedes the finding
START = {'F2': date(2011, 1, 1), 'F3': date(2008, 1, 1), 'control': date(2000, 1, 1)}
CUTOFF = date(2026, 6, 30)      # no record dated after it is read
MIN_TURNOVER = 5                # replacements listed over the ten years, at least this, above the mass
REFUTATION_KINDS = ('audit', 'court_or_regulator', 'admission', 'designation_withdrawn', 'replicated_study')
DROPPED_BY = ('selectors', 'outside')
FRAMES = ('F2', 'F3')           # F2: rankings in Rauhvargers (2011); F3: provincial GDP growth targets, 2008 reports
CONTROL = 'control'
CONTROL_IDS = ('C-LIBOR', 'C-PSA')
SOURCES_FROM = date(2000, 1, 1)  # the packets' sources begin: Part 2's doc_date, and Parts 2 and 3's documents, from it
YEARS = (1900, 2026)            # a sane range for uncovered_years: a period can begin before 2000, the packets' sources
                                # from 2000 notwithstanding, and a year it lists there is read as uncovered, not refused
# What 'the measure' is, frozen per frame: a case's name is this text with its register entry put in. Each names one
# object and the one body that decides it (DESIGN §2), so the body is not left to the coders; F3's also names who the
# ranked are and who is selected through it, since a target set for a province ranks no person by itself.
NAME_TEMPLATE = {
    'F2': '{entry}, the ranking of higher-education institutions published under that name; the body is the one that '
          'decides its method and its publication under its publisher\'s own rules (its editors, or a board those '
          'rules give that decision)',
    'F3': "the annual numerical target for GDP growth stated in the government work report of {entry}; the ranked are "
          "{entry}'s people's government and the cadres of {entry} whose evaluation by the body reads the target, and "
          "those selected through it are the cadres appointed or promoted on such an evaluation; the body is the "
          "standing committee of the Communist Party committee of {entry}, which decides the target before the "
          "people's congress approves the report",
}
CONTROL_NAMES = {
    'C-LIBOR': 'the London Interbank Offered Rate, as formed from its panel banks\' submissions, and its use as a '
               'benchmark rate',
    'C-PSA': "the United Kingdom's Public Service Agreement targets of 2007, and their use in evaluating government "
             "departments",
}

# The coders. 'decides' moves the verdict; 'reported apart' moves nothing (the theory's own family). PINS.json's rule.
CODER_SETS = {
    'pins': {'A': {'model': 'google/gemini-4-argon', 'family': 'Google', 'role': 'decides'},
             'B': {'model': 'qwen/qwen3.8-max-0902', 'family': 'Qwen', 'role': 'decides'},
             'C': {'model': 'anthropic/claude-sonnet-5.5', 'family': 'Anthropic', 'role': 'reported apart'}},
    'people': {'H1': {'model': 'person', 'family': 'chosen by Ren, not having read the theory', 'role': 'decides'},
               'H2': {'model': 'person', 'family': 'chosen by Ren, not having read the theory', 'role': 'decides'},
               'C': {'model': 'anthropic/claude-sonnet-5.5', 'family': 'Anthropic', 'role': 'reported apart'}},
    'people-alone': {'H1': {'model': 'person', 'family': 'chosen by Ren, not having read the theory', 'role': 'decides'},
                     'H2': {'model': 'person', 'family': 'chosen by Ren, not having read the theory', 'role': 'decides'}},
}
ORDER = ('refutation', 'premise', 'dropped', 'by_selectors', 'no_new_reader', 'no_new_reading', 'no_loss_entering',
         'drift_rare')
OUT_REASON = {'refutation': 'no refutation in the record collected', 'premise': 'premise not met',
              'dropped': 'kept, or not dropped in the window', 'by_selectors': 'dropped by another body',
              'no_new_reader': 'dropped through a new reader', 'no_new_reading': 'dropped through a change in what is read',
              'no_loss_entering': 'dropped through a loss entering the share', 'drift_rare': 'drift not rare by the bound'}
THIRD_ORDER = ('premise', 'reformed', 'lowered', 'still_by_ranked', 'no_new_reader_after', 'no_new_reading_after',
               'no_loss_after', 'rule_kept', 'next_reading')
EXITS = ('new_reader', 'new_reading', 'loss_entering')


def refuse(msg):
    raise SystemExit('refused: ' + msg)


def void(msg):
    raise SystemExit('void: ' + msg)


# --- the layout -----------------------------------------------------------------------------------------------------
NOT_SHOWN = 'not shown'          # the codebook's answer 'not shown in what was read', apart from false, 'not in the record'
# what a coder was shown of a part: the whole record collected for it, a sample, or a record whose collection was not
# completed by DESIGN §3's procedure (a source or query not done, a fetch failed, the collector stopped by its guard),
# which is read as a sample, never as whole
SHOWN = ('whole', 'sample', 'incomplete')
KINDS = ('favoured', 'other')   # a member who entered or left the body: of the kind the measure favours, or not
LAYOUT = {
    # 'answer': true, false or 'not shown' (or null), for a question that can be answered by an absence
    'refutation': {'found': 'answer', 'date': 'date', 'kind': 'kind', 'later': 'findings'},
    'premise': {'reading_by_ranked': 'bool', 'rule_by_ranked': 'bool', 'doc_date': 'date'},
    'outcome': {'dropped': 'answer', 'drop_date': 'date', 'dropped_by': 'by', 'reformed_reading': 'answer',
                'reform_date': 'date', 'uncovered_years': 'years'},
    # the codebook's group names, neutral to the coders: 'before_drop' (the three exits), 'reform' (the third case);
    # from_date: the measure's last regular revision before the drop that kept its weight, where new_reading's period
    # starts (DESIGN §4), null where there is none and that period starts at the premise's document; new_reader and
    # loss_entering are read from the premise's document whatever from_date is (round fresh 3, T7F-R3-1).
    # uncovered_years: the years of the premise's document to the drop without a document; uncovered_years_from_date:
    # those of from_date to the drop, read only where from_date is given, and only beside an uncovered_years that lists
    # no year from from_date's to the drop's (round fresh 4, T7F-R4-3)
    'before_drop': {'from_date': 'date', 'new_reader': 'answer', 'new_reading': 'answer', 'loss_entering': 'answer',
                    'uncovered_years': 'years', 'uncovered_years_from_date': 'years'},
    # replacements: every replacement over the ten years shown one by one, with the kind of who entered and who left
    'drift': {'N': 'int', 'i': 'int', 'threshold': 'frac', 'replacements': 'replacements', 'one_at_a_time': 'answer',
              'constant': 'answer', 'enter_through_measure': 'bool', 'uncovered_years': 'years'},
    'reform': {'lowered': 'bool', 'still_by_ranked': 'answer', 'new_reader_after': 'answer',
               'new_reading_after': 'answer', 'loss_after': 'answer', 'rule_kept': 'answer',
               'next_reading_date': 'date', 'outlasted': 'answer', 'uncovered_years': 'years'},
    # written by the assembler from the collection log, not by the coder: each part as this coder was shown it
    'shown': {'part1': 'shown', 'part2': 'shown', 'part3': 'shown', 'part4': 'shown'},
}


def _date(s):
    try:
        return date.fromisoformat(s)
    except (TypeError, ValueError):
        return None


def _ok(kind, v):
    """Every field may be null (not coded, or not found in the packet)."""
    if v is None:
        return True
    if kind == 'bool':
        return isinstance(v, bool)
    if kind == 'int':
        return isinstance(v, int) and not isinstance(v, bool) and v >= 0
    if kind == 'date':
        return isinstance(v, str) and len(v) == 10 and _date(v) is not None
    if kind == 'kind':
        return v in REFUTATION_KINDS
    if kind == 'by':
        return v in DROPPED_BY
    if kind == 'frac':
        if not isinstance(v, str) or '/' not in v:
            return False
        try:
            f = Fr(v)
        except (ValueError, ZeroDivisionError):
            return False
        return 0 < f <= 1                           # '1/1': unanimity or consensus
    if kind == 'years':                             # calendar years of a period with no document: distinct, in range
        return isinstance(v, list) and len(v) == len(set(v)) and all(
            isinstance(y, int) and not isinstance(y, bool) and YEARS[0] <= y <= YEARS[1] for y in v)
    if kind == 'findings':                          # later findings: a list of {date, kind}, each coded
        return isinstance(v, list) and all(
            isinstance(x, dict) and set(x) == {'date', 'kind'} and x['date'] is not None and x['kind'] is not None
            and _ok('date', x['date']) and _ok('kind', x['kind']) for x in v)
    if kind == 'replacements':                      # each replacement: its date, who entered and who left, by kind
        return isinstance(v, list) and all(
            isinstance(x, dict) and set(x) == {'date', 'entrant', 'leaver'} and x['date'] is not None
            and _ok('date', x['date']) and x['entrant'] in KINDS and x['leaver'] in KINDS for x in v)
    if kind == 'answer':                            # a question of absence: true, false, 'not shown' (or null)
        return isinstance(v, bool) or v == NOT_SHOWN
    if kind == 'shown':                             # written by the assembler: the part shown whole, or a sample
        return v in SHOWN
    return False


def validate_codes(where, c):
    if not isinstance(c, dict) or set(c) != set(LAYOUT):
        refuse(f'{where}: the codes must have exactly the groups {sorted(LAYOUT)}')
    for g, fields in LAYOUT.items():
        if not isinstance(c[g], dict) or set(c[g]) != set(fields):
            refuse(f'{where}: group {g} must have exactly the fields {sorted(fields)}')
        for f, kind in fields.items():
            if not _ok(kind, c[g][f]):
                refuse(f'{where}: {g}.{f} = {c[g][f]!r} is not a {kind} or null')


def sha_bytes(b):
    return hashlib.sha256(b).hexdigest()


def validate_frame(frame):
    if not isinstance(frame, dict) or set(frame) != {'registers', 'cases', 'controls'}:
        refuse('frame.json must have exactly registers, cases, controls')
    ids = [c.get('id') for c in frame['cases']] + [c.get('id') for c in frame['controls']]
    if len(ids) != len(set(ids)):
        refuse('frame.json lists a case twice')
    for c in frame['cases']:
        if set(c) != {'id', 'frame', 'name', 'register_entry'} or c['frame'] not in FRAMES:
            refuse(f'frame.json: case {c.get("id")!r} is not in the layout')
        if not isinstance(c['register_entry'], str) or not c['register_entry'].strip():
            refuse(f'frame.json: case {c["id"]!r} has no register entry')
        if c['name'] != NAME_TEMPLATE[c['frame']].format(entry=c['register_entry']):
            refuse(f'frame.json: case {c["id"]!r} is not named by its frame\'s frozen text')
    if sorted(c.get('id') for c in frame['controls']) != sorted(CONTROL_IDS):
        refuse(f'frame.json: the controls must be exactly {list(CONTROL_IDS)}')
    for c in frame['controls']:
        if set(c) != {'id', 'frame', 'name', 'register_entry'} or c['frame'] != CONTROL:
            refuse(f'frame.json: control {c.get("id")!r} is not in the layout')
        if c['name'] != CONTROL_NAMES[c['id']]:
            refuse(f'frame.json: control {c["id"]!r} is not named by its frozen text')
    return ids


def frames_of(frame):
    return {c['id']: c['frame'] for c in frame['cases'] + frame['controls']}


def validate_cases(frame, frame_bytes, cases, packets_bytes, pages_bytes):
    """cases.json against the frame, the packets' manifest and pages.json: coded on these three, by their sha-256;
    pages.json in its layout (validate_pages), and the manifest listing it at its sha-256 (pages_bound), so that the
    packets read are those collected from the pages chosen (round fresh 4, T7F-R4-4)."""
    ids = validate_frame(frame)
    keys = {'frame_sha256', 'pages_sha256', 'packets_sha256', 'cutoff', 'coder_set', 'coders', 'run_log', 'cases'}
    if not isinstance(cases, dict) or set(cases) != keys:
        refuse('cases.json must have exactly ' + ', '.join(sorted(keys)))
    if cases['frame_sha256'] != sha_bytes(frame_bytes):
        refuse('cases.json was coded on another frame')
    try:
        pages = json.loads(pages_bytes)
    except ValueError:
        refuse('pages.json is not JSON')
    validate_pages(frame, pages)
    if cases['pages_sha256'] != sha_bytes(pages_bytes):
        refuse('cases.json was coded on packets collected from other pages')
    if not pages_bound(packets_bytes, pages_bytes):
        refuse('the packets\' manifest does not list pages.json at its sha-256; the packets are not bound to the pages')
    if cases['packets_sha256'] != sha_bytes(packets_bytes):
        refuse('cases.json was coded on other packets')
    if cases['cutoff'] != CUTOFF.isoformat():
        refuse('cases.json names another cutoff')
    if cases['coder_set'] not in CODER_SETS or cases['coders'] != CODER_SETS[cases['coder_set']]:
        refuse('cases.json names coders other than a frozen set')
    got = [c.get('id') for c in cases['cases']]
    if len(got) != len(set(got)):
        refuse('cases.json codes a case twice')
    if set(got) - set(ids):
        refuse(f'the run is enlarged: cases not in the frame {sorted(set(got) - set(ids))}')
    if set(ids) - set(got):
        refuse(f'the run is incomplete: frame cases not coded {sorted(set(ids) - set(got))}')
    for c in cases['cases']:
        if set(c) != {'id', 'codes'} or set(c['codes']) != set(cases['coders']):
            refuse(f'case {c.get("id")!r}: codes must come from exactly the coders {sorted(cases["coders"])}')
        for k, v in c['codes'].items():
            validate_codes(f'case {c["id"]}, coder {k}', v)
    log = cases['run_log']
    if not isinstance(log, dict) or set(log) != {'malformed', 'other_model'}:
        refuse('cases.json: run_log must have exactly malformed, other_model')
    for g in ('malformed', 'other_model'):
        if not isinstance(log[g], dict) or set(log[g]) != set(cases['coders']) or not all(
                _ok('int', v) and v is not None for v in log[g].values()):
            refuse(f'cases.json: run_log.{g} must give a count for exactly the coders {sorted(cases["coders"])}')
        if any(v > 4 * len(cases['cases']) for v in log[g].values()):
            refuse(f'cases.json: run_log.{g} counts more stage answers than there are')


def void_check(cases):
    """DESIGN §7's void clauses, from the run's log as the assembler (the step-0 addendum) counts it: a pin's response
    naming a model other than its pin; more than a fifth of a decider's stage answers left null for want of a
    well-formed answer (not for want of a document)."""
    log, coders, stages = cases['run_log'], cases['coders'], 4 * len(cases['cases'])
    named = sorted(k for k, v in log['other_model'].items() if v and coders[k]['model'] != 'person')
    if named:
        void(f'responses of {named} name a model other than their pin')
    over = sorted(k for k, v in log['malformed'].items() if coders[k]['role'] == 'decides' and Fr(v, stages) > Fr(1, 5))
    if over:
        void(f'more than a fifth of the stage answers of {over} stayed null for want of a well-formed answer')


# --- the packets' caps (DESIGN §3): a reference for the step-0 addendum's collector and client, deciding nothing -----
MAX_WORDS = 50000               # words a part: a part is the whole record collected for it wherever this holds it
SAMPLE_DOCS = 60                # the documents of a sample, in every part, where the record does not fit
HAN = re.compile('[\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff]')
RUN = re.compile(r'[^\W_]')     # a letter or a digit, other than a Han character (those are removed first)
# Parts 3 and 4 (DESIGN \u00a73): their record is the documents of the listed sources only, never the search engines'
# hits, which go to Parts 1 and 2; and from a publisher's or a body's site only pages of the kinds below, each with its
# yearly copy (round fresh 2, T7F-R2-3), chosen per case by the chooser (a person, or one deciding pin) from the
# site's navigation and the pages' titles alone, by the frozen instruction PAGE_CHOICE, before any page's text is
# read, and committed as pages.json before the packets (validate_pages, committed_in_order; round fresh 3,
# T7F-R3-2). For F3 the listed sources are the later work reports and
# the three central bodies' announcements naming the province. Each such document enters the record by its passages
# (paragraphs) that name the measure (Part 3) or the body (Part 4), by these frozen terms (named), matched as whole
# words; a term written in capitals (an abbreviation) as written, any other without regard to case; a Han term as a
# run of characters, Chinese having no spaces. A document with no such passage is not in that part's record. F2's
# measure terms are the case's register entry, the ranking's name, and the abbreviation the entry gives in brackets,
# if any (register_terms): not 'rank' or 'league table', which a ranking's own tables and pages carry in nearly every
# paragraph.
PAGE_KINDS = ('the method page: the page that states how the measure is computed (its methodology)',
              'the governance page: the page that names the body that decides the method, its members or its rules',
              'the notices: the publisher\'s or the body\'s announcements about the measure itself (its edition, launch, '
              'revision, suspension or end, a change in its method or its body)')
PAGE_KIND_NAMES = ('method', 'governance', 'notices')   # the kinds as pages.json names them, in PAGE_KINDS' order
# A case's sites (round fresh 4, T7F-R4-1; their start, round fresh 5, T7F-R5-1 and -2). A measure's publisher and
# the body that decides its rule can each have a site, and a site can move to a new domain within 2000 to 2026. So a
# case has a list of sites, each with its home address, how the collector found it, the site it was found from, the
# role the chooser gives it and the years its home page is read (validate_pages). Which sites a case starts from is
# not the collector's judgment: the collector lists, by frozen rule, the start candidates, the home address (scheme
# and host) of every web address the frame's register entry gives and of each of the first START_RESULTS results of
# the general web engine for each of the case's start queries (start_queries, by START_QUERY_FORMS); the chooser gives each candidate its
# role by START_CHOICE, from its home address and the addresses and titles of the results on it alone; and every
# candidate of the role 'publisher' or 'body' is a 'start' site, read from 2000. From the found sites the collector
# then finds, mechanically: 'redirect', every address to which a yearly copy of a found site's home page redirects in
# the Internet Archive (a site moved to a new domain), read from the first year it does; 'link', every address on
# another site linked from a yearly copy of a 'start' or 'redirect' site's home page, or of a page it links to, by a
# link whose title names the measure (its record_terms for Part 3), read from the first year it is so linked (a
# measure handed to a new administrator, whose old site links the new one without redirecting). A redirect's or a
# link's home is the address itself, not its domain's root, so that a measure's pages deep in a large administrator's
# site are within two links of it (T7F-R5-2). A year in which a site's home copy redirects to another found site is
# that site's year, not its own. The chooser gives each found site its role again by PAGE_CHOICE: 'publisher' (the
# site of whoever computes or publishes the measure), 'body' (the site of the body that decides its rule) or
# 'neither'.
SITE_ROLES = ('publisher', 'body', 'neither')
SITE_FOUND = ('start', 'redirect', 'link')
START_RESULTS = 10
START_QUERY_FORMS = ('"{t}"', '"{t}" methodology', '"{t}" governance')
REGISTER = 'register'   # a start candidate's source: a web address the register entry gives


def start_queries(case):
    """The frozen queries whose first START_RESULTS results on the general web engine give a case's start candidates
    (round fresh 5, T7F-R5-1): each form of START_QUERY_FORMS for each of the case's Part 3 measure terms."""
    key = case['id'] if case['frame'] == CONTROL else case['frame']
    return tuple(f.format(t=t) for t in record_terms(3, key, case.get('register_entry')) for f in START_QUERY_FORMS)


START_CHOICE = (
    'You are given the name of a measure and a list of websites, each by its home address, with the addresses and '
    'titles of the web search results for the measure that lie on it. Give each website its role, from these alone: '
    '"publisher" where it is the site of whoever computes or publishes the measure, "body" where it is the site of '
    'the body that decides the measure\'s rule, and "neither" otherwise (a news site, an encyclopedia, a site of one '
    'institution or person ranked or measured, a site that only discusses the measure). Where they leave it in doubt '
    'whether a website is the publisher\'s or the body\'s, give it the role it most likely has, not "neither". Answer '
    'as JSON: {"candidates": [{"home": "...", "role": "publisher | body | neither"}]}, one entry for each website '
    'given.')
# What the chooser is given, frozen (round fresh 3, T7F-R3-2; its sites, round fresh 4, T7F-R4-1; their entries,
# round fresh 5, T7F-R5-2). The step-0 addendum's collector builds, for each site found, the list it names,
# mechanically, from the yearly copies of §3 (the Internet Archive's copy nearest 1 July of each of the site's years)
# of the site's entries: its home address and, for a 'start' site, the addresses of the start results on its host.
# Each entry is a line of its own; then every page of the same host linked from an entry or from a page an entry
# links to, by its address, its title in the copy and the years in which a copy links it, one line an address. No
# other text of any page reaches the chooser.
PAGE_CHOICE = (
    'You are given the name of a measure and one or more websites found for it. For each website you are given its '
    'home address, which may be a page within a larger website, the years in which its home page was read, and its '
    'pages, one line each: an address, the page\'s title, and the years in which the site\'s yearly copy linked to '
    'it. A measure\'s publisher and the body that '
    'decides its rule may each have a site, and a site may have moved to a new address; each such site is listed on '
    'its own. First give each website its role, from its home address and its pages\' addresses and titles alone: '
    '"publisher" where it is the site of whoever computes or publishes the measure, "body" where it is the site of '
    'the body that decides the measure\'s rule, and "neither" otherwise. Then, for each website of the role '
    '"publisher" or "body", choose, from the addresses and titles alone, every page of these three kinds:\n'
    '- method: ' + PAGE_KINDS[0].split(': ', 1)[1] + ';\n'
    '- governance: ' + PAGE_KINDS[1].split(': ', 1)[1] + ';\n'
    '- notices: ' + PAGE_KINDS[2].split(': ', 1)[1] + '.\n'
    'A site often moves a page to a new address; choose each address under which a page of a kind appears, each '
    'with its own years. Where an address and its title leave it in doubt whether a page is of one of the kinds, '
    'choose it, with the kind it most likely is; where they leave it in doubt whether a website is the publisher\'s '
    'or the body\'s, give it the role it most likely has, not "neither". Choose no page that is plainly of none of '
    'the kinds (a news story, a page on one institution or person, a contact or a login page). Answer as JSON: '
    '{"sites": [{"home": "...", "role": "publisher | body | neither", "pages": [{"address": "...", '
    '"kind": "method | governance | notices", "years": [2012, 2013]}]}]}, one entry for each website given, with '
    '"pages": [] where none is of these kinds or the role is "neither".')


def _years_ok(v):
    return _ok('years', v) and v is not None and bool(v) and all(SOURCES_FROM.year <= y <= CUTOFF.year for y in v)


def _home(v):
    return v.strip().lower()


def validate_pages(frame, pages):
    """pages.json, the run's second step (DESIGN §12): for every F2 case and every control, exactly once, its start
    candidates (round fresh 5, T7F-R5-1), each with its home address, where the frozen rule found it (the register
    entry, or one of the case's start_queries) and the role the chooser gave it by START_CHOICE; and its sites (an
    empty list where none is found), each with its home address, how the collector found it, the site it was found
    from (None for a start site), the role the chooser gave it by PAGE_CHOICE, the years its home page was read, and
    the pages chosen by kind, each with its address, its kind and its years, within its site's; and who chose them
    (round fresh 4, T7F-R4-1: a publisher's site and a body's, and a site moved to a new domain, each its own entry).
    The start sites are exactly the candidates of the role 'publisher' or 'body'; a redirect is found from another
    site of the case, a link from another start or redirect site. F3's listed sources are fixed by kind already, and
    its cases are not in it. A home listed twice in a case's candidates or sites, a site of the role 'neither' with
    pages, and any other key, source, role, kind, year or case refuse the run."""
    if not isinstance(pages, dict) or set(pages) != {'chosen_by', 'cases'} or not isinstance(pages['chosen_by'], str) \
            or not pages['chosen_by'].strip() or not isinstance(pages['cases'], list):
        refuse('pages.json must have exactly chosen_by (who chose the pages) and cases (a list)')
    listed = {c['id']: c for c in frame['cases'] + frame['controls'] if c['frame'] in ('F2', CONTROL)}
    want = sorted(listed)
    got = [x.get('case') if isinstance(x, dict) else None for x in pages['cases']]
    if sorted(got, key=str) != want:
        refuse(f'pages.json must list exactly the F2 cases and the controls, each once: {want}')
    for x in pages['cases']:
        if set(x) != {'case', 'candidates', 'sites'} or not isinstance(x['candidates'], list) \
                or not isinstance(x['sites'], list):
            refuse(f'pages.json: case {x.get("case")!r} must have exactly case, candidates and sites (lists, empty '
                   'where none is found)')
        sources = {REGISTER, *start_queries(listed[x['case']])}
        cand = {}
        for c in x['candidates']:
            if not isinstance(c, dict) or set(c) != {'home', 'from', 'role'} or not isinstance(c['home'], str) \
                    or not c['home'].strip() or not isinstance(c['from'], list) or not c['from'] \
                    or not all(isinstance(f, str) and f in sources for f in c['from']) or c['role'] not in SITE_ROLES:
                refuse(f'pages.json: case {x["case"]!r}: a start candidate must have exactly a home address, from (the '
                       f'register entry, {REGISTER!r}, or the case\'s start queries {sorted(sources - {REGISTER})}) '
                       f'and a role of {SITE_ROLES}')
            if _home(c['home']) in cand:
                refuse(f'pages.json: case {x["case"]!r} lists the start candidate {c["home"]!r} twice')
            cand[_home(c['home'])] = c['role']
        sites = {}
        for s in x['sites']:
            if not isinstance(s, dict) or set(s) != {'home', 'found', 'from', 'role', 'years', 'pages'} \
                    or not isinstance(s['home'], str) or not s['home'].strip() or s['found'] not in SITE_FOUND \
                    or not (s['from'] is None if s['found'] == 'start' else isinstance(s['from'], str)) \
                    or s['role'] not in SITE_ROLES or not _years_ok(s['years']) or not isinstance(s['pages'], list):
                refuse(f'pages.json: case {x["case"]!r}: a site must have exactly a home address, found of '
                       f'{SITE_FOUND}, from (None for a start site, else the home it was found from), a role of '
                       f'{SITE_ROLES}, its years from {SOURCES_FROM.year} to {CUTOFF.year}, and pages (a list)')
            if _home(s['home']) in sites:
                refuse(f'pages.json: case {x["case"]!r} lists a site twice; a moved site is a new home address')
            sites[_home(s['home'])] = s
            if s['role'] == 'neither' and s['pages']:
                refuse(f'pages.json: case {x["case"]!r}: site {s["home"]!r} has the role neither and pages')
            for pg in s['pages']:
                if not isinstance(pg, dict) or set(pg) != {'address', 'kind', 'years'} or not isinstance(
                        pg['address'], str) or not pg['address'].strip() or pg['kind'] not in PAGE_KIND_NAMES \
                        or not _years_ok(pg['years']):
                    refuse(f'pages.json: case {x["case"]!r}: a page must have an address, a kind of '
                           f'{PAGE_KIND_NAMES} and its years, from {SOURCES_FROM.year} to {CUTOFF.year}')
                if not set(pg['years']) <= set(s['years']):
                    refuse(f'pages.json: case {x["case"]!r}: page {pg["address"]!r} has a year in which its site '
                           f'{s["home"]!r} was not read')
        starts = {h for h, s in sites.items() if s['found'] == 'start'}
        if starts != {h for h, r in cand.items() if r != 'neither'}:
            refuse(f'pages.json: case {x["case"]!r}: the start sites must be exactly the start candidates of the role '
                   'publisher or body')
        for h, s in sites.items():
            if s['found'] != 'start':
                src = sites.get(_home(s['from']))
                if src is None or _home(s['from']) == h or (s['found'] == 'link' and src['found'] == 'link'):
                    refuse(f'pages.json: case {x["case"]!r}: site {s["home"]!r} must be found from another site of the '
                           'case (a link from a start or a redirect site)')
    return pages


def pages_as_given(pages, given):
    """Whether pages.json holds what the chooser was given, as given (round fresh 5, T7F-R5-4): the lists the
    collector committed beside it (pages-given.json: per case its candidates, each with home and from, and its sites,
    each with home, found, from and years) against pages.json's, every home listed to the chooser exactly once in its
    case, and none other. Role and pages are the chooser's answer; home, found, from and years are the collector's.
    The step-0 addendum's collector runs it before pages.json is committed; the verdict does not read the lists."""
    def key(case):
        return (sorted((_home(c['home']), sorted(c['from'])) for c in case['candidates']),
                sorted((_home(s['home']), s['found'], None if s['from'] is None else _home(s['from']),
                        sorted(s['years'])) for s in case['sites']))
    try:
        a = {c['case']: key(c) for c in pages['cases']}
        b = {c['case']: key(c) for c in given['cases']}
        return len(a) == len(pages['cases']) and len(b) == len(given['cases']) and a == b
    except (KeyError, TypeError, AttributeError):
        return False


def pages_bound(packets_bytes, pages_bytes):
    """Whether the packets' manifest lists pages.json at its sha-256 (round fresh 4, T7F-R4-4): a line '<sha-256>
    <path>' whose path's last part is pages.json, as the collection writes it, so that the packets name the pages
    they were collected from."""
    h = sha_bytes(pages_bytes)
    for line in packets_bytes.decode('utf-8', 'replace').splitlines():
        f = line.split(None, 1)
        if len(f) == 2 and f[0] == h and f[1].strip().lstrip('*').replace('\\', '/').split('/')[-1] == 'pages.json':
            return True
    return False


MEASURE_TERMS = {'F2': (),
                 'F3': ('\u751f\u4ea7\u603b\u503c', 'GDP', '\u7ecf\u6d4e\u589e\u957f', '\u589e\u957f\u76ee\u6807', '\u9884\u671f\u76ee\u6807'),
                 'C-LIBOR': ('LIBOR', 'interbank offered rate', 'interbank offered rates'),
                 'C-PSA': ('public service agreement', 'public service agreements', 'PSA', 'PSAs')}
BODY_TERMS = {'F2': ('editor', 'editors', 'board', 'boards', 'committee', 'committees', 'panel', 'panels', 'advisory',
                     'council', 'councils'),
              'F3': ('\u5e38\u59d4', '\u5e38\u52a1\u59d4\u5458', '\u7701\u59d4', 'standing committee',
                     'standing committees'),
              'C-LIBOR': ('panel', 'panels', 'committee', 'committees', 'board', 'boards', 'administrator',
                          'administrators'),
              'C-PSA': ('cabinet', 'committee', 'committees', 'minister', 'ministers', 'treasury')}


# words of ordinary English that an abbreviation may spell, set in capitals in headings and titles: an abbreviation
# that is one of them is not a term (round fresh 3, T7F-R3-5; 'Times Higher Education ... (THE)' would match every
# heading in capitals with 'THE' in it). Frozen; what it misses is stated in DESIGN \u00a73.
COMMON_WORDS = frozenset('''A AN AND ANY ARE AS AT BE BEST BUT BY CAN DO FOR FROM HAS HAVE HE HER HIS HOW I IF IN IS IT ITS
    MAY ME MORE MOST MY NEW NO NOT NOW OF OFF ON ONE OR OUR OUT SHE SO TOP THAN THAT THE THEM THEN THEY THIS TO TWO UP US
    WAS WE WHAT WHEN WHO WHY WILL WITH YEAR YOU YOUR'''.split())


def register_terms(entry):
    """F2's measure terms from its register entry: the name, and an abbreviation the entry gives in brackets at its end
    ('Academic Ranking of World Universities (ARWU)' gives both); the name alone where there is none, or where the
    abbreviation is a common English word (COMMON_WORDS, compared in capitals: '(THE)' gives the name alone)."""
    m = re.fullmatch(r'\s*(.*?)\s*\(([^()]+)\)\s*', entry or '')
    if m and m.group(1):
        ab = m.group(2).strip()
        return (m.group(1),) if ab.upper() in COMMON_WORDS else (m.group(1), ab)
    return (entry.strip(),) if entry and entry.strip() else ()


def record_terms(part, frame_or_control, entry=None):
    """The frozen terms whose passages make a document's place in Part 3 (the measure) or Part 4 (the body); None for
    Parts 1 and 2, whose documents enter whole."""
    if part == 3:
        return MEASURE_TERMS[frame_or_control] + (register_terms(entry) if frame_or_control == 'F2' else ())
    if part == 4:
        return BODY_TERMS[frame_or_control]
    return None


def names(text, terms):
    """Whether a paragraph names one of the frozen terms: a Han term as a run of characters; any other as a whole word
    (no letter or digit on either side), written in capitals as written, otherwise without regard to case."""
    for t in terms:
        if HAN.search(t):
            if t in text:
                return True
            continue
        pat = r'(?<![^\W_])' + re.escape(t) + r'(?![^\W_])'
        if re.search(pat, text, 0 if t.isupper() else re.IGNORECASE):
            return True
    return False


def count_words(text):
    """Words: runs of letters or digits, any other character ending a run; in Chinese text, the Han characters divided
    by 1.5, punctuation not counted. Exact."""
    han = len(HAN.findall(text))
    runs = len(re.findall(r'[^\W_]+', HAN.sub(' ', text)))
    return Fr(2 * han, 3) + runs


def _truncate(text, words):
    """The longest opening of text of at most `words` words."""
    w, prev, out = Fr(0), False, []
    for ch in text:
        if HAN.fullmatch(ch):
            step, prev = Fr(2, 3), False
        elif RUN.fullmatch(ch):
            step, prev = (0 if prev else 1), True
        else:
            step, prev = 0, False
        if w + step > words:
            break
        w += step
        out.append(ch)
    return ''.join(out)


def _has_term(text, terms):
    low = text.casefold()
    return any(t.casefold() in low for t in terms)


def passages(doc, terms, what):
    """The passages of doc that name `what` (the measure or the body): its paragraphs carrying one of `terms`, in the
    document's order, with '[...]' wherever paragraphs were left out, the document beginning '[passages naming `what`:
    k of n words]'; the document unchanged where every paragraph names one; None where none does (the document is
    then not in the part's record). Fixed before any record is read: a paragraph is kept by the terms alone (names)."""
    paras = doc['paragraphs']
    keep = [j for j, x in enumerate(paras) if names(x, terms)]
    if not keep:
        return None
    if len(keep) == len(paras):
        return dict(doc)
    shown, last = [], -1
    for j in keep:
        if j != last + 1:
            shown.append('[...]')
        shown.append(paras[j])
        last = j
    if last != len(paras) - 1:
        shown.append('[...]')
    n = sum((count_words(x) for x in paras), Fr(0))
    k = sum((count_words(paras[j]) for j in keep), Fr(0))
    return dict(doc, paragraphs=['[passages naming %s: %d of %d words]' % (what, int(k), int(n))] + shown)


def cut_by_passage(doc, words, terms):
    """doc ({'id', 'date', 'paragraphs'}) kept whole where it has at most `words` words; otherwise cut by passage:
    first the paragraphs that name the measure or carry a query term (terms), then the others from the opening, in that
    order, each whole while it fits the words left, and the first that does not fit cut at its end to them. They are
    shown in the document's order, with '[...]' wherever text was left out, and the document begins '[cut: k of n words
    kept]', so the coder sees that it was cut."""
    paras = doc['paragraphs']
    n = sum((count_words(x) for x in paras), Fr(0))
    if n <= words:
        return dict(doc, cut=False, kept_words=n, words=n)
    pri = [j for j, x in enumerate(paras) if _has_term(x, terms)]
    order = pri + [j for j in range(len(paras)) if j not in pri]
    keep, left = {}, Fr(words)
    for j in order:
        w = count_words(paras[j])
        if w <= left:
            keep[j], left = paras[j], left - w
        else:
            part = _truncate(paras[j], left)
            if part:
                keep[j] = part
            break
    k = sum((count_words(x) for x in keep.values()), Fr(0))
    shown, last = [], -1
    for j in sorted(keep):
        if j != last + 1 and shown[-1:] != ['[...]']:
            shown.append('[...]')
        if keep[j] == '[...]' and shown[-1:] == ['[...]']:
            last = j                                # a passage's own mark, beside one already shown
            continue
        shown.append(keep[j])
        if keep[j] != paras[j]:
            shown.append('[...]')
        last = j
    if last != len(paras) - 1 and shown[-1:] != ['[...]']:
        shown.append('[...]')
    head = '[cut: %d of %d words kept]' % (int(k), int(n))
    return dict(doc, paragraphs=[head] + shown, cut=True, kept_words=k, words=n)


def part_dates(part, start=None, lo=None, hi=None):
    """The dates a part's documents may have: none after the cutoff; Part 1 from the case's start date, Parts 2 and 3
    from 1 January 2000, Part 4 from any date; narrowed by a coder's own stage (DESIGN §3, The order) to lo and hi, both
    days included: Part 2 to before the coder's refutation date, Part 3 from its doc_date."""
    first = {1: start, 2: SOURCES_FROM, 3: SOURCES_FROM, 4: None}[part]
    if lo is not None:
        first = lo if first is None else max(first, lo)
    return first, (CUTOFF if hi is None else min(CUTOFF, hi))


def sample_positions(n, k):
    """k of n places in date order, at even steps of rank from the first to the last, both included: the place
    j (n - 1) / (k - 1) rounded, halves up, for j = 0 ... k - 1; all n where k >= n. Distinct, fixed before any record
    is read, and blind to what the documents say: a document's place in date order alone decides whether it is shown,
    so a later document has the same chance as an earlier one, and the record's later half as many places as its
    earlier half."""
    if k >= n:
        return list(range(n))
    if k == 1:
        return [n - 1]
    return [(2 * j * (n - 1) + (k - 1)) // (2 * (k - 1)) for j in range(k)]


def pack(part, docs, terms, start=None, lo=None, hi=None, record=None, what='the measure', complete=True):
    """What a coder is shown of a part (DESIGN §3). The record is every document collected for the part within its
    dates (part_dates); for Parts 3 and 4, `docs` are the listed sources' documents only, and `record` the frozen terms
    (record_terms), so each document enters the record by its passages naming the measure or the body (passages), and
    one with none is not in it. Where the record's words are at most MAX_WORDS, the part is the whole record: every
    document of it, uncut, the dated in date order and then the undated. Otherwise it is a sample: the SAMPLE_DOCS
    dated documents (or every dated one, if fewer) at the places sample_positions gives in date order, each cut by
    passage to an equal share of MAX_WORDS (a shorter one kept whole), and no undated document. Where the collection log
    records the part's collection as not completed by §3's procedure (complete False), it is never whole: shown as it
    would be, with its header saying so, and written 'incomplete', read as a sample. Its header, the part's first line,
    tells the coder which it is. Nothing here reads what a document says, beyond its words' count and which paragraphs
    carry the frozen terms or a query term.

    Returns {'whole', 'shown' (the value the assembler writes: 'whole', 'sample' or 'incomplete'), 'collected' (the
    documents within the dates), 'in the record' (those of them in the record), 'documents', 'not shown' (the ids of
    the record's documents not shown), 'header'}."""
    first, last = part_dates(part, start, lo, hi)

    def within(d):
        dd = _date(d['date'])
        return dd is None or ((first is None or dd >= first) and dd <= last)
    got = [d for d in docs if within(d)]
    rec = got if record is None else [p for p in (passages(d, record, what) for d in got) if p is not None]
    dated = sorted((d for d in rec if _date(d['date']) is not None), key=lambda d: (d['date'], d['id']))
    undated = sorted((d for d in rec if _date(d['date']) is None), key=lambda d: d['id'])
    size = {d['id']: sum((count_words(x) for x in d['paragraphs']), Fr(0)) for d in rec}
    by = '' if record is None else ', each document by its passages naming %s' % what
    tail = '' if complete else '; its collection was not completed, so read it as a sample'
    if sum(size.values(), Fr(0)) <= MAX_WORDS:
        shown = [dict(d, cut=False, kept_words=size[d['id']], words=size[d['id']]) for d in dated + undated]
        lead = 'the whole record' if complete else 'the record'
        return {'whole': complete, 'shown': 'whole' if complete else 'incomplete', 'collected': len(got),
                'in the record': len(rec), 'documents': shown, 'not shown': [],
                'header': '[%s collected for this part%s: %d documents, none cut%s]' % (lead, by, len(rec), tail)}
    k = min(len(dated), SAMPLE_DOCS)
    shown = [cut_by_passage(dated[j], Fr(MAX_WORDS, k), terms + list(record or ()))
             for j in sample_positions(len(dated), k)]
    ids = {d['id'] for d in shown}
    header = ('[a sample of the record collected for this part%s: %d of %d documents, chosen by their place in date '
              'order alone; %d of them cut%s]' % (by, len(shown), len(rec), sum(1 for d in shown if d['cut']), tail))
    return {'whole': False, 'shown': 'sample' if complete else 'incomplete', 'collected': len(got),
            'in the record': len(rec), 'documents': shown,
            'not shown': sorted(d['id'] for d in rec if d['id'] not in ids), 'header': header}


def uncovered(shown, first, last):
    """The calendar years from first to last (dates, both days included) in which no document shown is dated within the
    period, every document taken as on the question: the years a coder lists (uncovered_years) where it reads a whole
    part. A reference for the reader round; the coders list these years themselves."""
    years = {_date(d['date']).year for d in shown if _date(d['date']) is not None and first <= _date(d['date']) <= last}
    return [y for y in range(first.year, last.year + 1) if y not in years]


# --- the drift bound ------------------------------------------------------------------------------------------------
def critical_count(N, q):
    """x*, the count of the favoured at which the body's rule for the measure turns. A change needs q N votes, so the
    favoured block a change while i > (1 - q) N; a measure adopted afresh each cycle needs q N votes to be kept, so the
    favoured keep it while i >= q N. The codebook does not ask which, so the larger is taken: x* = max(q, 1 - q) N,
    which errs against refutation."""
    return max(Fr(q), 1 - Fr(q)) * N


def bound_at(i, xs, rho, top, t):
    """t times the product of 1 / rho(j) over j = s + 1 ... top, rho the line through 1 at x* and rho at the count i."""
    s = -((-xs.numerator) // xs.denominator)        # the least whole count at or above x*
    slope = (rho - 1) / (i - xs)
    prod = Fr(1)
    for j in range(s + 1, top + 1):
        prod /= 1 + slope * (j - xs)
    return t * prod


def counts_before(N, i, reps):
    """The count of the favoured before each replacement (j), found backward from i through the replacements in date
    order (ties in the coder's order), each changing it by who entered and who left; None where the counts leave 0 to
    N, or a leaver's kind is absent at its count."""
    order = sorted(range(len(reps)), key=lambda k: (reps[k]['date'], k))
    js, j = [None] * len(reps), i
    for k in reversed(order):
        e, l = reps[k]['entrant'] == 'favoured', reps[k]['leaver'] == 'favoured'
        j = j - e + l
        if j < 0 or j > N or (l and j < 1) or (not l and N - j < 1):
            return None
        js[k] = j
    return js


def others_at_most(N, xs, js, others, beta):
    """P(at most `others` of the entrants are of the other kind), where at count j the entrant is of the other kind
    with chance (N - j) / (j rho(j) + N - j), rho(j) = 1 + beta (j - x*) the model's line through 1 at x*: the drawn
    step's odds j rho(j) : (N - j), whoever leaves. Computed exactly, by the Poisson-binomial recursion cut at
    `others`, as a sum of Bernoulli trials at the counts the record shows. The counts depend on the earlier entrants,
    so the trials are not independent and the level is a plug-in, computed at the observed counts: that it holds is
    shown by the dry run's simulation of the drawn step, not by this sum (round fresh 3, T7F-R3-4). A trial whose
    chance is 0 or 1 (the top, j = N, where no other entrant can be drawn; the bottom, j = 0, where no favoured one
    can) is skipped: its outcome is forced and carries nothing about beta. So an other entrant at either is still
    counted in `others` (turnover), at no cost in chance, which lowers the limit, against refutation; a favoured
    entrant at the bottom, which the draw cannot give, adds nothing. It rises with beta."""
    dist, den = [1] + [0] * others, 1          # numerators over one common denominator, exact integers
    for j in js:
        p = Fr(N - j) / (j * (1 + beta * (j - xs)) + N - j)
        if p == 0 or p == 1:
            continue                           # a forced outcome (round fresh 3, T7F-R3-4)
        a, b = p.numerator, p.denominator
        dist = [dist[0] * (b - a)] + [dist[k] * (b - a) + dist[k - 1] * a for k in range(1, others + 1)]
        den *= b
    return Fr(sum(dist), den)


def slope_lower_limit(N, xs, js, others):
    """The one-sided lower confidence limit, at LEVEL, of the slope beta of rho(j) = 1 + beta (j - x*), from the kinds
    of the entrants at their counts: the beta at which as few other entrants as the record shows have chance LEVEL
    (others_at_most). A beta below it makes so few others rarer than LEVEL. Read on [0, 1 / x*]: 1 / x* is the
    largest the model allows (rho(i) = i / x*, rho(0) = 0). Found by BISECTIONS halvings in exact fractions, the lower
    end of the last bracket taken, so it is never above the limit. Returns (beta_L, 'none' where even beta 0 is not
    rejected, 'cap' where even 1 / x* is, else 'limit')."""
    cap = 1 / Fr(xs)
    if others_at_most(N, xs, js, others, Fr(0)) >= LEVEL:
        return Fr(0), 'none'
    if others_at_most(N, xs, js, others, cap) < LEVEL:
        return cap, 'cap'
    lo, hi = Fr(0), cap
    for _ in range(BISECTIONS):
        mid = (lo + hi) / 2
        if others_at_most(N, xs, js, others, mid) < LEVEL:
            lo = mid
        else:
            hi = mid
    return lo, 'limit'


def turnover(N, i, reps, xs):
    """The body's replacements read on the drawn model: the count before each (counts_before), and the lower
    confidence limit of the line's slope from who filled the places at those counts (slope_lower_limit), not a point
    estimate: near the top nearly every drawn entrant is favoured whatever rho is, so only the few other entrants carry
    information, and a point estimate from them swings widely (round fresh 2, T7F-R2-1). A same-kind replacement
    counts: it is what shows rho where the count stands still. A trial whose outcome the model forces (j = N or j = 0)
    is skipped (others_at_most), and every entrant of the other kind is counted: one at the top, which the draw cannot
    give, or at the bottom, which it must, adds one to the others at no cost in chance, which lowers the limit,
    against refutation; a favoured entrant at the bottom, which the draw cannot give, adds nothing (round fresh 3,
    T7F-R3-4). Returns (beta_L, how, others, u, d) or None where the counts are inconsistent."""
    js = counts_before(N, i, reps)
    if js is None:
        return None
    others = sum(1 for x in reps if x['entrant'] == 'other')
    beta, how = slope_lower_limit(N, xs, js, others)
    u = sum(1 for x in reps if x['entrant'] == 'favoured' and x['leaver'] == 'other')
    d = sum(1 for x in reps if x['entrant'] == 'other' and x['leaver'] == 'favoured')
    return beta, how, others, u, d


def drift_bound(dr, whole4=True):
    """The drawn model's bound read on the case, from one coder's inputs (02 §9; DrawnReplacement.lost_above):
    where the rule read at s favours the shapers, from s + n with t to the top, losing every shaper weighs, as a share,
    at most t times the product of down / up over the counts s + 1 ... s + n.

    Read on the case: N selectors (M + 1), i of them of the kind the measure favours, the critical count x* =
    max(q, 1 - q) N for the body's voting threshold q (critical_count), and the ratio rho = up / down. Under the
    model's premises (one drawn at a time, constant a, p, c, hi, lo; lo <= hi; new members drawn through the measure's
    selection) up / down is linear in the count through 1 at x*, rho(j) = 1 + beta (j - x*), with rho(0) >= 0, so beta
    is at most 1 / x* and rho(i) at most i / x*. beta is read at its lower confidence limit (turnover,
    slope_lower_limit), from who filled the body's places over the ten years at the counts they were filled, not from
    the body's net change: so a lock that held its share is read as well as one that rose, and a few informative
    entrants are not read as a point value. Where the limit is 0 (the record does not reject rho = 1), the bound is not
    read. s is the least whole count at or above x*, n = i - s.
    The model's top is absorbing: its bound counts a course that reaches N as safe, and at i = N the bound is 0. In the
    field a member of the other kind can arrive at the top, as d > 0 shows on the record (d: other entrants replacing
    favoured leavers), and each such arrival is a fresh chance of falling to s, at most the bound from N - 1 with t = 1,
    which is at most the bound from i with t = 1. So at every i above the mass, t = max(N - i, 1) + d: the first
    passage from i (from N - 1 where i = N), plus the d reverse replacements, each counted as an excursion from the top,
    a union bound that errs against refutation. At i = N it is read on the line through rho at N, the product stopping
    at N - 1.
    The premises and the replacements are read only where Part 4 was shown whole (whole4) and the coder lists no year
    of the ten without a document on the body's members (uncovered_years == []): on a sample, the replacements listed
    are those shown, and a replacement not shown might lower the limit, so reading a sample would err toward
    refutation. Returns (status, bound,
    note): status 'rare' / 'not rare' / 'unreadable'."""
    if not whole4:
        return 'unreadable', None, 'Part 4 not shown whole: the members and their replacements read on a sample'
    if dr['uncovered_years'] != []:
        return 'unreadable', None, 'the ten years not each covered by a document on the members'
    if dr['one_at_a_time'] is not True or dr['constant'] is not True or dr['enter_through_measure'] is not True:
        return 'unreadable', None, "the drawn model's premises not read on the case"
    N, i, q = dr['N'], dr['i'], dr['threshold']
    if N is None or i is None or q is None:
        return 'unreadable', None, 'N, i or the threshold not given'
    if N < 2 or i > N:
        return 'unreadable', None, 'N and i inconsistent'
    xs = critical_count(N, q)
    if i <= xs:
        return 'not rare', None, 'the share at or below the critical mass'
    reps = dr['replacements']
    if reps is None or len(reps) < MIN_TURNOVER:
        return 'unreadable', None, 'replacements not listed, or fewer than %d' % MIN_TURNOVER
    tv = turnover(N, i, reps, xs)
    if tv is None:
        return 'unreadable', None, 'N, i and the replacements inconsistent'
    beta, how, others, u, d = tv
    notes = ['%d replacements (u %d, d %d, %d other entrants), the slope of rho at its lower %s limit %s' % (
        len(reps), u, d, others, LEVEL, beta)]
    if how == 'none':
        return 'unreadable', None, notes[0] + '; the record does not reject rho = 1 at the level: drift not shown'
    rho = 1 + beta * (i - xs)
    if how == 'cap':
        notes.append('ratio taken at the largest the model allows, i / x*')
    top, t = min(i, N - 1), max(N - i, 1) + d
    if i == N:
        notes.append('every selector of the favoured kind: read from N - 1')
    notes.append('t = max(N - i, 1) + d = %d' % t)
    b = bound_at(i, xs, rho, top, t)
    return ('rare' if b <= THRESHOLD else 'not rare'), b, '; '.join(notes)


# --- one coder's conditions -----------------------------------------------------------------------------------------
def _add_years(d0, k):
    try:
        return d0.replace(year=d0.year + k)
    except ValueError:                              # 29 February
        return d0.replace(year=d0.year + k, day=28)


def whole(c, part):
    """Whether this coder was shown the whole record collected for the part (the assembler's 'shown'); a sample, or
    the part not recorded, is not whole."""
    return c['shown']['part%d' % part] == 'whole'


def happened(v, in_record):
    """A question whether something happened: true is a document showing it; false is 'not in the record', and stands
    only where in_record (the part shown whole, and every year of the period covered); 'not shown', null, and a false
    read on a sample or an uncovered period are open (None). So 'not shown' is never read as 'not in the record'."""
    if v is True:
        return True
    return False if (v is False and in_record) else None


def stayed(v, in_record):
    """A question whether something stayed the same: false is a document showing a change; true is 'no change in the
    record', and stands only where in_record; 'not shown', null, and a true read on a sample or an uncovered period
    are open (None)."""
    if v is False:
        return False
    return True if (v is True and in_record) else None


def _neg(v):
    return None if v is None else (not v)


def read_exits(c, start):
    """The three exits as the coder found them, each over its own period (round fresh 3, T7F-R3-1).
    new_reader and loss_entering: from the premise's document (the Part 2 doc_date, or else the start) to the drop.
    A reader outside the share who gained a place (a vote, legal authority, a funding condition, the rule's users
    replaced), or a cost entering the share, is not absorbed because a later revision kept the measure's weight: that
    revision shows only that the exit had not yet turned the rule. And an outside reader is not a member of the body,
    so the drift clause does not read it. So these two are looked for over the whole period, whenever they came.
    new_reading: from the measure's last regular revision before the drop at which it kept its weight
    (before_drop.from_date), whether before or after the finding, or, where the coder gives none, from the premise's
    document, to the drop. A change of the reading the measure outlived at such a revision is absorbed at the next
    reading step (reading_absorbed), so it is not looked for (round fresh 2, T7F-R2-2). A from_date before the
    premise's document (or the start), or not before the drop (or with no drop date), sets a period the codes do not
    fit, and new_reading is open; the other two are read as above.
    A 'true' is a document showing the exit. A 'false' is 'not in the record', and stands only where Part 3 was shown
    whole and the coder lists no year of the exit's period without a document: uncovered_years == [] for new_reader,
    loss_entering and a new_reading read from the premise's document; uncovered_years_from_date == [] for a
    new_reading read from from_date (where from_date is null, uncovered_years_from_date is not read), and for it
    also no year of uncovered_years from from_date's year to the drop's: the from_date period lies within the
    longer one, so a year the coder lists as without a document there is without one here too, whatever the second
    list says (round fresh 4, T7F-R4-3). Otherwise, and for 'not shown', it is open (None). A year listed before 2000
    is read as uncovered, not refused."""
    e = c['before_drop']
    whole3 = whole(c, 3)
    rec = whole3 and e['uncovered_years'] == []
    out = {'new_reader': happened(e['new_reader'], rec), 'loss_entering': happened(e['loss_entering'], rec)}
    if e['from_date'] is None:
        out['new_reading'] = happened(e['new_reading'], rec)
        return out
    dD = _date(c['outcome']['drop_date'])
    p0 = _date(c['premise']['doc_date']) or start
    if dD is None or not (p0 <= _date(e['from_date']) < dD):
        out['new_reading'] = None
    else:
        y0, y1 = _date(e['from_date']).year, dD.year
        longer = e['uncovered_years'] is not None and not any(y0 <= y <= y1 for y in e['uncovered_years'])
        out['new_reading'] = happened(e['new_reading'], whole3 and e['uncovered_years_from_date'] == [] and longer)
    return out


def findings(c, start):
    """The coder's findings as dates: (refutation True / False / None, the earliest counted, every counted finding in
    order). A finding counts where it falls from the frame's start to the cutoff, whether coded as the earliest or as a
    later one; one dated before the start is set aside, and the earliest remaining one is the refutation. So a measure
    that survived a finding before its frame's start is still tested on the findings from it. 'No finding' (found
    false, or every finding before the start) is False only where Part 1 was shown whole: on a sample a finding may sit
    in what was not shown, and it is open."""
    r = c['refutation']
    found, rec = r['found'], whole(c, 1)
    dR, later = _date(r['date']), [_date(x['date']) for x in (r['later'] or [])]
    if found is False:
        if r['date'] is not None or r['kind'] is not None or later:
            return None, None, []                   # 'none' beside a finding: the answer conflicts with itself
        return (False if rec else None), None, []
    if found is not True or dR is None or r['kind'] is None:
        return None, None, []                       # 'not shown', null, or a finding without its date or kind
    fs = sorted({x for x in [dR] + later if start <= x <= CUTOFF})
    if not fs:
        return (False if rec else None), None, []
    return True, fs[0], fs


def in_window(fs, d0, rec1):
    """d0 falls after some finding shown, within ten years of it, and by the cutoff: True. Where it does not, False
    only where Part 1 was shown whole (rec1); on a sample a later finding not shown may set the window, so it is open."""
    if any(f < d0 <= min(_add_years(f, WINDOW_YEARS), CUTOFF) for f in fs):
        return True
    return False if rec1 else None


def coder_conditions(c, start):
    """One coder's reading of the Refuted by's conditions: {condition: True / False / None}, with the bound."""
    out = {}
    out['refutation'], dR, fs = findings(c, start)
    p = c['premise']
    if p['reading_by_ranked'] is False or p['rule_by_ranked'] is False:
        out['premise'] = False
    elif p['reading_by_ranked'] is None or p['rule_by_ranked'] is None or p['doc_date'] is None:
        out['premise'] = None
    elif _date(p['doc_date']) < SOURCES_FROM:
        out['premise'] = None                       # documented only before the sources begin: not documented here
    elif dR is None:
        out['premise'] = True if out['refutation'] is False else None
    else:
        out['premise'] = _date(p['doc_date']) < dR  # documented in advance of every finding shown
    o = c['outcome']
    dropped = happened(o['dropped'], whole(c, 3) and o['uncovered_years'] == [])
    if dropped is False:
        out['dropped'] = False                      # kept: no drop in the record, Part 3 whole and every year covered
    elif dropped is None or o['drop_date'] is None or out['refutation'] is not True:
        out['dropped'] = None
    else:
        out['dropped'] = in_window(fs, _date(o['drop_date']), whole(c, 1))
    out['by_selectors'] = None if o['dropped_by'] is None else (o['dropped_by'] == 'selectors')
    e = read_exits(c, start)
    out['no_new_reader'], out['no_new_reading'] = _neg(e['new_reader']), _neg(e['new_reading'])
    out['no_loss_entering'] = _neg(e['loss_entering'])
    status, b, note = drift_bound(c['drift'], whole(c, 4))
    out['drift_rare'] = {'rare': True, 'not rare': False, 'unreadable': None}[status]
    return out, {'status': status, 'bound': None if b is None else str(b),
                 'bound, decimal': None if b is None else '%.6f' % float(b), 'note': note}


def third_conditions(c, start):
    """One coder's reading of the third forbidden case: a reform of the reading, lowering what the measure gives those
    it favours while the reading is still formed by the ranked (reading_absorbed's 'mind'), with no new reader, no new
    reading and no loss from the reform through the next reading. Every code that finds an absence or that something
    stayed the same (no new reader, reading or loss after; still by the ranked; the weight kept; the lowering standing)
    stands only where Part 3 was shown whole and the coder lists no year from the reform to the next revision without
    a document (reform.uncovered_years == []); otherwise, and for 'not shown', it is open. 'No reform' likewise."""
    base, _ = coder_conditions(c, start)
    ref, _, fs = findings(c, start)
    o, th = c['outcome'], c['reform']
    rec3 = whole(c, 3) and o['uncovered_years'] == []
    rec = whole(c, 3) and th['uncovered_years'] == []
    out = {'premise': base['premise'] if base['refutation'] is not False else False}
    reformed, dropped = happened(o['reformed_reading'], rec3), happened(o['dropped'], rec3)
    if reformed is False:
        out['reformed'] = False                     # no reform in the record
    elif reformed is None or o['reform_date'] is None or ref is not True:
        out['reformed'] = None
    elif dropped is None or (dropped is True and o['drop_date'] is None):
        out['reformed'] = None                      # 'before any drop' cannot be read
    else:
        dF = _date(o['reform_date'])
        if dropped is True and _date(o['drop_date']) <= dF:
            out['reformed'] = False                 # the reform came at or after the drop
        else:
            out['reformed'] = in_window(fs, dF, whole(c, 1))
    out['lowered'], out['still_by_ranked'] = th['lowered'], stayed(th['still_by_ranked'], rec)
    out['no_new_reader_after'] = _neg(happened(th['new_reader_after'], rec))
    out['no_new_reading_after'] = _neg(happened(th['new_reading_after'], rec))
    out['no_loss_after'] = _neg(happened(th['loss_after'], rec))
    out['rule_kept'] = stayed(th['rule_kept'], rec)
    if th['next_reading_date'] is None or o['reform_date'] is None:
        out['next_reading'] = None
    else:
        dN = _date(th['next_reading_date'])
        out['next_reading'] = _date(o['reform_date']) < dN <= CUTOFF
    out['outlasted'] = stayed(th['outlasted'], rec)
    return out


# --- two coders together --------------------------------------------------------------------------------------------
def _pair(a, b):
    if a is True and b is True:
        return 'pass'
    if a is False and b is False:
        return 'fail'
    if a is None or b is None:
        return 'not coded'
    return 'disagree'


def case_status(codes, deciders, start):
    """The Refuted by on one case, by the two deciders."""
    x, y = (coder_conditions(codes[k], start) for k in deciders)
    pairs = {k: _pair(x[0][k], y[0][k]) for k in ORDER}
    drift = {deciders[0]: x[1], deciders[1]: y[1]}
    fail = [k for k in ORDER if pairs[k] == 'fail']
    if fail:
        return {'status': 'out', 'reason': OUT_REASON[fail[0]], 'conditions': pairs, 'drift': drift}
    open_ = [k for k in ORDER if pairs[k] != 'pass']
    if not open_:
        return {'status': 'refuting', 'reason': 'every condition met by both deciders', 'conditions': pairs,
                'drift': drift}
    if open_ == ['drift_rare'] and pairs['drift_rare'] == 'not coded':
        reason = 'unresolved by drift'
    else:
        reason = 'unresolved: ' + ', '.join(f'{k} ({pairs[k]})' for k in open_)
    return {'status': 'unresolved', 'reason': reason, 'conditions': pairs, 'drift': drift}


def third_status(codes, deciders, start):
    x, y = (third_conditions(codes[k], start) for k in deciders)
    pairs = {k: _pair(x[k], y[k]) for k in THIRD_ORDER + ('outlasted',)}
    fail = [k for k in THIRD_ORDER if pairs[k] == 'fail']
    if fail:
        return {'status': 'not eligible', 'reason': fail[0], 'conditions': pairs}
    eligible = all(pairs[k] == 'pass' for k in THIRD_ORDER)
    if pairs['outlasted'] == 'fail':
        if pairs['lowered'] == 'pass' and pairs['still_by_ranked'] == 'pass':
            return {'status': 'absorbed', 'reason': 'a lowering not standing after the next reading' +
                    ('' if eligible else ' (eligibility otherwise unresolved)'), 'conditions': pairs}
        return {'status': 'not eligible', 'reason': 'not outlasting, with no lowering by a reading still formed by the '
                'ranked found by both: neither met nor an absorption', 'conditions': pairs}
    if eligible and pairs['outlasted'] == 'pass':
        return {'status': 'met', 'reason': 'a reform of the reading alone outlasted the next reading',
                'conditions': pairs}
    return {'status': 'unresolved', 'reason': ', '.join(f'{k} ({pairs[k]})' for k in pairs if pairs[k] != 'pass'),
            'conditions': pairs}


def control_status(codes, deciders):
    """A positive control: a known exit. 'exit found' where each decider codes at least one of the three exits true (a
    new reader, a new reading, a loss entering); a drop by another body alone is not an exit found. 'exit missed' where
    both code all three false on a covered period (read_exits). Otherwise 'unclear'. The controls' exits are read by
    the same rule as the frame's, each over its own period: a new reader or a loss from the premise's document to the
    drop, whatever from_date the coders give (round fresh 3, T7F-R3-1)."""
    ex = [read_exits(codes[k], START[CONTROL]) for k in deciders]
    if all(any(e[f] is True for f in EXITS) for e in ex):
        return 'exit found'
    if all(all(e[f] is False for f in EXITS) for e in ex):
        return 'exit missed'
    return 'unclear'


# --- the second Forbids clause, reported ----------------------------------------------------------------------------
def tail_at_least(ps, k):
    """P(at least k of independent events with chances ps), exact."""
    dist = [Fr(1)]
    for p in ps:
        new = [Fr(0)] * (len(dist) + 1)
        for j, q in enumerate(dist):
            new[j] += q * (1 - p)
            new[j + 1] += q * p
        dist = new
    return sum(dist[k:], Fr(0))


def second_clause(rows, deciders):
    """Among frame cases with refutation and premise met and the bound read by both deciders (above the mass), how many
    were left with nothing read changed (dropped by their selectors, no exit), against each case's larger bound."""
    bounds, k = [], 0
    for r in rows:
        c, dr = r['refuted by']['conditions'], r['refuted by']['drift']
        if c['refutation'] != 'pass' or c['premise'] != 'pass':
            continue
        if any(dr[d]['bound'] is None for d in deciders):
            continue
        bounds.append(min(Fr(1), max(Fr(dr[d]['bound']) for d in deciders)))
        if all(c[x] == 'pass' for x in ('dropped', 'by_selectors', 'no_new_reader', 'no_new_reading',
                                        'no_loss_entering')):
            k += 1
    if not bounds:
        return {'readable cases': 0, 'reading': 'not readable: no case has the bound read by both deciders'}
    tail = tail_at_least(bounds, k)
    return {'readable cases': len(bounds), 'left with nothing read changed': k,
            'sum of bounds': '%.6f' % float(sum(bounds)),
            'chance of at least that many at the bounds': '%.6f' % float(tail),
            'reading': ('more often than the bounds allow' if k >= 1 and tail <= THRESHOLD else
                        'not more often than the bounds allow'),
            'note': 'reported; it decides nothing'}


# --- agreement ------------------------------------------------------------------------------------------------------
BOOL_FIELDS = [(g, f) for g, fs in LAYOUT.items() for f, k in fs.items() if k in ('bool', 'answer')]


def kappa(pairs):
    n = len(pairs)
    if n == 0:
        return None
    po = Fr(sum(a == b for a, b in pairs), n)
    pa, pb = Fr(sum(a for a, _ in pairs), n), Fr(sum(b for _, b in pairs), n)
    pe = pa * pb + (1 - pa) * (1 - pb)
    return {'n': n, 'agreement': str(po), 'kappa': None if pe == 1 else str((po - pe) / (1 - pe))}


def agreement(cases, a, b):
    out = {}
    for g, f in BOOL_FIELDS:
        ps = [(c['codes'][a][g][f], c['codes'][b][g][f]) for c in cases]
        out[f'{g}.{f}'] = kappa([(x, y) for x, y in ps if isinstance(x, bool) and isinstance(y, bool)])
    return out


# --- the verdict ----------------------------------------------------------------------------------------------------
def what_was_read(codes, deciders):
    """For each decider: each part as it was shown (the whole record collected for it, or a sample), and the years it
    listed as without a document, by list, as the readout reports them for every case. So a reader can tell a case
    left open by a sample, or by a year with no document, from one left open by the coders' disagreement. Reported;
    they move nothing beyond the conditions that read them."""
    return {k: {'parts shown': dict(codes[k]['shown']),
                'years listed without a document': {
                    'outcome': codes[k]['outcome']['uncovered_years'],
                    'before_drop': codes[k]['before_drop']['uncovered_years'],
                    'before_drop, from from_date': codes[k]['before_drop']['uncovered_years_from_date'],
                    'reform': codes[k]['reform']['uncovered_years'], 'drift': codes[k]['drift']['uncovered_years']}}
            for k in deciders}


def read_all(frame, cases, deciders):
    ctl, fr = {c['id'] for c in frame['controls']}, frames_of(frame)
    rows, controls = [], {}
    for c in sorted(cases['cases'], key=lambda c: c['id']):
        if c['id'] in ctl:
            controls[c['id']] = control_status(c['codes'], deciders)
            continue
        start = START[fr[c['id']]]
        rows.append({'id': c['id'], 'refuted by': case_status(c['codes'], deciders, start),
                     'third case': third_status(c['codes'], deciders, start),
                     'what each decider read': what_was_read(c['codes'], deciders)})
    return rows, controls


def refuted_by_verdict(rows, controls):
    st = [r['refuted by']['status'] for r in rows]
    refuting = [r['id'] for r in rows if r['refuted by']['status'] == 'refuting']
    shown = all(controls.get(k) == 'exit found' for k in CONTROL_IDS)
    eligible = [r for r in rows if r['refuted by']['conditions']['refutation'] == 'pass'
                and r['refuted by']['conditions']['premise'] == 'pass']
    if refuting and shown:
        v, why = 'refuted', f'{len(refuting)} case(s) meet every condition: {refuting}; both controls showed their exit'
    elif refuting:
        v, why = 'unresolved', (f'cases {refuting} meet every condition, but a control did not show its exit: ' +
                                ', '.join(f'{k} {controls.get(k)}' for k in CONTROL_IDS))
    elif 'unresolved' in st:
        v, why = 'unresolved', f'{st.count("unresolved")} case(s) unresolved, none refuting'
    elif eligible:
        v, why = 'not refuted', f'{len(eligible)} case(s) met the refutation and the premise; none refutes'
    else:
        v, why = 'not testable', 'no frame case met the refutation and the premise by both deciders'
    tally = {}
    for r in rows:
        k = r['refuted by']['reason'] if r['refuted by']['status'] != 'unresolved' else (
            'unresolved by drift' if r['refuted by']['reason'] == 'unresolved by drift' else 'unresolved otherwise')
        tally[k] = tally.get(k, 0) + 1
    return {'verdict': v, 'why': why, 'refuting cases (reported, not used)': len(refuting), 'tally': tally,
            'controls': controls}


def third_verdict(rows, controls):
    """'met' rests on absences found by the same coders and codebook as a refutation, so it stands only where both
    controls had their exit found; otherwise it is 'unresolved', a control not having shown its exit."""
    st = [r['third case']['status'] for r in rows]
    met = [r['id'] for r in rows if r['third case']['status'] == 'met']
    shown = all(controls.get(k) == 'exit found' for k in CONTROL_IDS)
    if met and shown:
        v, why = 'met', f'{len(met)} case(s) meet it: {met}; both controls showed their exit'
    elif met:
        v, why = 'unresolved', (f'cases {met} meet it, but a control did not show its exit: ' +
                                ', '.join(f'{k} {controls.get(k)}' for k in CONTROL_IDS))
    elif 'unresolved' in st:
        v, why = 'unresolved', f'{st.count("unresolved")} case(s) unresolved, none met'
    elif 'absorbed' in st:
        v, why = 'not met', f'{st.count("absorbed")} case(s) absorbed, none met or unresolved'
    else:
        v, why = 'not testable', 'no case met or absorbed, and none unresolved'
    return {'verdict': v, 'why': why, 'tally': {s: st.count(s) for s in sorted(set(st))}}


def verdict(frame, frame_bytes, cases, packets_bytes, pages_bytes):
    validate_cases(frame, frame_bytes, cases, packets_bytes, pages_bytes)
    void_check(cases)
    coders = cases['coders']
    deciders = tuple(sorted(k for k, v in coders.items() if v['role'] == 'decides'))
    apart = sorted(k for k, v in coders.items() if v['role'] != 'decides')
    rows, controls = read_all(frame, cases, deciders)
    frame_cases = [c for c in cases['cases'] if c['id'] not in CONTROL_IDS]
    out = {'deciders': {k: coders[k] for k in deciders}, 'refuted by': refuted_by_verdict(rows, controls),
           'third case': third_verdict(rows, controls), 'second Forbids clause': second_clause(rows, deciders),
           'agreement of the deciders': agreement(frame_cases, *deciders), 'cases': rows, 'reported apart': {},
           'cases with a part whose collection was not completed (read as a sample)': sorted(
               c['id'] for c in cases['cases'] if any(c['codes'][k]['shown'][p] == 'incomplete'
                                                       for k in deciders for p in c['codes'][k]['shown']))}
    for k in apart:
        r2, c2 = read_all(frame, cases, (k, k))
        out['reported apart'][k] = {'coder': coders[k], 'its codes read alone': refuted_by_verdict(r2, c2)['verdict'],
                                    'third case read alone': third_verdict(r2, c2)['verdict'],
                                    'agreement with each decider': {d: agreement(frame_cases, k, d) for d in deciders},
                                    'note': 'moves nothing'}
    return out


# --- the freeze and the run -----------------------------------------------------------------------------------------
def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def no_optimize():
    if sys.flags.optimize:
        refuse('python3 -O; the rule is run without it')


def committed_unchanged(root, paths):
    git = subprocess.run(['git', '-C', str(root), 'status', '--porcelain', '--', *paths], capture_output=True, text=True)
    tracked = subprocess.run(['git', '-C', str(root), 'ls-files', '--error-unmatch', '--', *paths],
                             capture_output=True, text=True)
    if git.returncode or git.stdout.strip() or tracked.returncode:
        refuse('a file is uncommitted or changed:\n' + (git.stdout or tracked.stderr))


def frozen_check(frozen=FROZEN, root=ROOT, required=REQUIRED):
    """FROZEN.sha256 lists every required file; each has that sha256 and is committed unchanged; FROZEN.sha256 is
    committed in one commit only (a second would make a new freeze). Returns the listing and {freeze commit, HEAD}."""
    if not frozen.exists():
        refuse(f'no {frozen.name}; the freeze is not committed')
    listed = {}
    for line in frozen.read_text().splitlines():
        if line.strip():
            h, p = line.split(None, 1)
            listed[p] = h
    missing = [p for p in required if p not in listed]
    if missing:
        refuse(f'FROZEN.sha256 does not list {missing}')
    for p, h in listed.items():
        if not (root / p).exists() or sha(root / p) != h:
            refuse(f'{p} differs from FROZEN.sha256')
    rel = str(frozen.relative_to(root))
    committed_unchanged(root, [rel] + list(listed))
    commits = subprocess.run(['git', '-C', str(root), 'rev-list', 'HEAD', '--', rel], capture_output=True,
                             text=True).stdout.split()
    if len(commits) != 1:
        refuse(f'{rel} has {len(commits)} commits; the freeze is the one that added it')
    head = subprocess.run(['git', '-C', str(root), 'rev-parse', 'HEAD'], capture_output=True, text=True).stdout.strip()
    return listed, {'the freeze commit': commits[0], 'HEAD': head}


def first_added(root, path):
    """The commit that first added path, or None."""
    log = subprocess.run(['git', '-C', str(root), 'log', '--diff-filter=A', '--format=%H', '--', path],
                         capture_output=True, text=True).stdout.split()
    return log[-1] if log else None


def last_touched(root, path):
    """The last commit that changed path, or None."""
    log = subprocess.run(['git', '-C', str(root), 'log', '-1', '--format=%H', '--', path], capture_output=True,
                         text=True).stdout.split()
    return log[0] if log else None


def committed_in_order(root, paths):
    """Each path last changed in a commit that comes strictly before the next path is first added (DESIGN §12, each
    step committed before the next, and none changed after it): the freeze before frame.json, frame.json before
    pages.json (no page chosen before the frame, and no case added or removed after it), pages.json before
    PACKETS.sha256 (the pages chosen by kind before any of them is collected and read, round fresh 3, T7F-R3-2),
    PACKETS.sha256 before cases.json (no coding before the packets' manifest, and the manifest not rewritten after it). A commit
    before another is its proper ancestor; the same commit, or one not before it, refuses. So a frame edited after the
    manifest, or a manifest edited after the coding began, refuses (round fresh 2, T7F-R2-4)."""
    adds = [first_added(root, p) for p in paths]
    for p, a in zip(paths, adds):
        if a is None:
            refuse(f'{p} was never committed')
    lasts = [last_touched(root, p) for p in paths]
    for p, a, q, b in zip(paths, lasts, paths[1:], adds[1:]):
        before = subprocess.run(['git', '-C', str(root), 'merge-base', '--is-ancestor', a, b]).returncode == 0
        if a == b or not before:
            refuse(f'{p} was last changed after, or with, the commit that added {q}; each step is committed before '
                   'the next and not changed after it')


def write_once(path, data):
    """The readout, written whole and once: a temporary name, synced, renamed."""
    path = Path(path)
    if path.exists():
        refuse(f'{path.name} is already there; a readout is written once')
    tmp = path.with_suffix('.tmp')
    with open(tmp, 'w', encoding='utf-8') as f:
        f.write(json.dumps(data, indent=1, sort_keys=True, ensure_ascii=True) + '\n')
        f.flush()
        os.fsync(f.fileno())
    os.replace(tmp, path)


def verdict_from_files(frame_p, pages_p, packets_p, cases_p, root=ROOT, frozen=FROZEN, required=REQUIRED, out=None):
    """The run's sixth step, from the four files in the steps' order (frame.json, pages.json, PACKETS.sha256,
    cases.json): the freeze holds, each file committed unchanged, the five committed in order, each in its layout and
    bound to the others (validate_cases), and the readout written once. The dry run calls it in a scratch repository
    (round fresh 4, T7F-R4-4); main calls it here."""
    out = Path(out) if out is not None else RESULTS / 'verdict.json'
    if out.exists():
        refuse(f'{out.name} is already there; a readout is written once')
    _, at = frozen_check(frozen=frozen, root=root, required=required)
    paths = [Path(a).resolve() for a in (frame_p, pages_p, packets_p, cases_p)]
    rels = [str(p.relative_to(Path(root).resolve())) for p in paths]
    committed_unchanged(root, rels)
    committed_in_order(root, [str(Path(frozen).resolve().relative_to(Path(root).resolve()))] + rels)
    fb, gb, pb, cb = (p.read_bytes() for p in paths)
    result = verdict(json.loads(fb), fb, json.loads(cb), pb, gb)
    result['freeze'] = at
    write_once(out, result)
    return result


def main(argv):
    no_optimize()
    if argv[:1] == ['check'] and len(argv) == 1:
        _, at = frozen_check()
        print('the freeze holds:', at)
        return
    if argv[:1] == ['verdict'] and len(argv) == 5:
        result = verdict_from_files(*argv[1:])
        print(result['refuted by']['verdict'], '|', result['third case']['verdict'])
        return
    raise SystemExit(__doc__)


if __name__ == '__main__':
    main(sys.argv[1:])
