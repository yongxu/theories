#!/usr/bin/env python3
"""The atlas: the account's dynamics as a curated layer beside the records, and its generated pages.

An entry is a dynamic (an attractor, lock, drain, absorption, cycle, closure or kept region): its mechanism, the
records and declarations that state it, its base, the hypotheses it holds under (by their place in its records), what
it forbids, its exits, transitions, tests and open items, and what it does beyond its couplings. The atlas creates no
result and strengthens no proof, and it adds nothing to how far anything has been seen: an entry shows each of its
records' status and kind as the record says, listed and never merged, and an entry with no record says how far it has
been seen without one (argued, conjectured, reading or open; the data key is `standing_without_record`) and cites its
source; so does an exit no law shows, in place of a strength. No entry marks a dynamic good or bad. The design:
_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aa-attractor-atlas/PLAN.md §3.

A correspondence is a claim of an earlier folder or of a domain of thought: its own sense first, what became of it in the
live account (carried, in part, changed, only in history, not carried, or a reading proposed here), its relation to what
it is read against, and those targets. Each is an AI reading of three reads; agreement is kept no more prominently than
divergence, and "not carried" is an outcome, not a defect.

Curated: theories/becoming/results/atlas/vocabulary.json, the closed lists, and entries/<kind>.json (dynamics,
correspondences and their groups; transitions, exits, premises, theses and tests, and open items come as files of their
own). Generated: theories/becoming/results/atlas/ATLAS.md with a page per family under families/, CROSSWALK.md with a
page per group under crosswalk/, theories/becoming/results/data/atlas.json and the index of the earlier theory folders,
theories/README.md, from the crosswalk's groups. No Markdown page exceeds PAGE_LIMIT, and a page the render no longer
writes is an error until it is removed by name. Each index keeps every anchor its single page had (the families' and
groups' ids and headings, each dynamic's id and heading and each correspondence's id), so a link made before the split
still lands. What they say
is a function of the curated files and the records; that declarations, anchors and test paths resolve is checked, not
rendered, so a chapter or Lean edit does not make the pages stale. `research.py check` fails on an error and on a page
a render would change; `research.py render` writes them.

usage (from the checkout root):
  python3 -B tools/research/atlas.py [--check] [--json]

  --check   compare the generated pages with the files as well; exit 1 on an error or on a page that differs
  --json    print the resolved atlas, not only its counts
"""
from __future__ import annotations

import argparse
from collections import Counter
import html
import json
import math
from pathlib import Path
import posixpath
import re
import subprocess
import sys
from urllib.parse import unquote

ROOT = Path(__file__).resolve().parents[2]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
from tools.research import navigation, paths, reading_catalogue, registry  # noqa: E402

ATLAS = 'theories/becoming/results/atlas'
VOCABULARY = ATLAS + '/vocabulary.json'
ENTRIES = ATLAS + '/entries'
PAGE = ATLAS + '/ATLAS.md'
STEP2B = ('_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aa-attractor-atlas/'
          'step2b/mapping.json')
SIX = ('_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aa-attractor-atlas/'
       'six/mapping.json')
BINDINGS_PAGE = ATLAS + '/BINDINGS.md'
SITUATIONS_PAGE = ATLAS + '/SITUATIONS.md'
# The tests table (curated rows; tools/research/tests_page.py), which a binding's test must name.
TESTS = 'theories/becoming/results/data/tests.json'
# Outcomes of a row that ran to no result a binding could read: such a row's binding is null.
NO_RESULT = ('not-run', 'held', 'dropped', 'refused', 'no-prediction', 'registered-rule')
PREMISES_PAGE = ATLAS + '/PREMISES.md'
PREMISE_PAGES = ATLAS + '/premises'  # the ledger's premises that only one family's laws take, a page per family
TERRAIN = ATLAS + '/TERRAIN.md'
TERRAIN_SVG = ATLAS + '/terrain.svg'
FAMILY_PAGES = ATLAS + '/families'
CROSSWALK = ATLAS + '/CROSSWALK.md'
CROSSWALK_PAGES = ATLAS + '/crosswalk'
# The map's overview as a picture, drawn by connection_map.py, which the crosswalk's index shows first.
OVERVIEW = ATLAS + '/connections.svg'
OVERVIEW_ZH = ATLAS + '/connections.zh.svg'  # the same picture, its words in Chinese (connection_map.overview_svg)
# GitHub stops showing a Markdown file somewhere between 1,035,845 bytes (ATLAS.md, shown on 8 November 2026) and
# 3,742,459 (CROSSWALK.md, not shown); no page written here exceeds 1 MiB. lean_catalogue.PAGE_LIMIT is the same bound.
PAGE_LIMIT = 1_048_576
# The index of the earlier theory folders, one row per folder from the crosswalk's groups of the earlier-folders domain.
FOLDERS = 'theories/README.md'
# What the critics of the crosswalk found, written from their files by the crosswalk's sample_summary.py.
CHECKS = ATLAS + '/crosswalk-checks.json'
DATA = 'theories/becoming/results/data/atlas.json'
RECORDS = 'theories/becoming/results/records'
RECEIPT = registry.CORE_RECEIPT
GENERATED = '<!-- Generated by tools/research/atlas.py from ' + ATLAS + '/; do not edit. -->'
ABOUT = ("The atlas of the account's dynamics, resolved: each entry with how far its records have been seen (status and "
         "kind, as each record says, never merged; the key `standing`) and the text of its hypotheses, copied from the "
         f"records. Generated by tools/research/atlas.py from {ATLAS}/; do not edit.")

NUMBER_WORDS = {n: w for n, w in enumerate('zero one two three four five six seven eight nine ten eleven twelve thirteen fourteen '
                                           'fifteen sixteen seventeen eighteen nineteen twenty'.split())}
FOLDERS_LEAD = ('The {n} folders beside `becoming/` hold the earlier theories: syntheses first written in September 2026 and '
                'kept in place, some with later additions, each first written before the live account, '
                '[the theory of becoming](becoming/ONE-PAGE.md). A folder\'s own assessments of standing and readiness are its view '
                'as of the date its banner gives, not the live account\'s, and each folder\'s README says so in a banner above its text as it was. '
                '[Chapter 5](becoming/chapters/05-COLLECTIVES.md#11-joint-plans-and-applications) counts five of them among '
                'applications elsewhere: design programmes, not results; correspondence not established. How the account grew from '
                'these folders and the writing before them is in [the lineage](LINEAGE.md).\n\n'
                'Each row links the folder\'s page in [the crosswalk](becoming/results/atlas/CROSSWALK.md): what it claimed in its '
                'own terms, and what became of that in the live account. The crosswalk creates no result, and every entry is an AI '
                'reading with no person\'s behind it. A shared word is not a correspondence, structural agreement is not agreement in '
                'meaning, and not carried is an outcome, not a defect.')
FOLDERS_FOOT = ('*Kind* is the crosswalk\'s: a theory, a design, an exploration or a method. The domains of thought the '
                'crosswalk also reads, from Chinese classical thought to psychology and logic, are in its own table. The originals the '
                'folders draw on are in `sources/`, except the chat logs, memory exports and recorded conversations '
                '(`sources/12-`, `13-` and `18-`, and the conversation\'s transcript in `drafts/2026-10-02-friend-conversation/`), which the '
                'repository has not tracked since 19 October 2026.')

# The entries' files and the kind each lists. Each further kind of the plan's §3.2 (transition, exit, premise, thesis
# and test, open item) adds its file here, its fields and its check.
KINDS = {'dynamics': 'dynamic', 'correspondences': 'correspondence', 'correspondence_groups': 'correspondence group',
         'premises': 'premise', 'bindings': 'binding', 'situations': 'situation'}
# Kinds whose file may be absent: none of them read yet (the premises came with step 2 of the next phase, PLAN §13).
OPTIONAL_KINDS = ('premises', 'bindings', 'situations')
FIELDS = {'dynamic': ('id', 'name', 'family', 'mechanism', 'records', 'declarations', 'base', 'hypotheses', 'forbids',
                      'exits', 'transitions', 'tests', 'open', 'valence', 'beyond', 'sources', 'standing_without_record'),
          'correspondence': ('id', 'name', 'domain', 'group', 'source', 'sense', 'quote', 'carried', 'relation', 'agreement_of',
                             'reading', 'targets', 'account_adds', 'source_adds', 'absence', 'same_as', 'labels', 'reads'),
          'correspondence group': ('id', 'domain', 'title', 'kind', 'summary', 'read', 'skimmed', 'searched', 'not_mapped',
                                   'coverage', 'reads', 'source'),
          'premise': ('id', 'name', 'statement', 'kind', 'lean', 'holds_in', 'fails_in', 'home', 'seeded_from'),
          'binding': ('id', 'test', 'bears_on', 'binding'),
          'situation': ('id', 'name', 'kind', 'standing', 'summary', 'formations', 'conditions', 'couplings', 'readers', 'rule',
                        'time', 'dynamics', 'premises', 'exits', 'bears', 'sources')}
# A binding's bridge between a test and the map (MS §2.3): what the test is, which conclusion it reads, what plays each
# role, how each premise of the identification fares, what was observed and came out, where the outcome marks, another
# explanation, and the README section it is read from.
BRIDGE = ('kind', 'target', 'roles', 'premises', 'observed', 'result', 'marks', 'marks_why', 'alternative', 'source')
# A dynamic's fields it may leave out: `premises`, each of its laws with the premises the law's binders take, present
# once the dynamic has been read for them (PLAN §13, step 2); absent, it has not been.
DYNAMIC_OPTIONAL = ('premises', 'compose')
# How two dynamics join (PLAN §13, the six-family pass): one's state read as the other's rule, reading or pool. A joining
# is proved where a Lean law's statement relates both sides (its joint law), stated where a theorem's home says it in
# words, or a reading where a chapter's marked AI reading proposes it.
COMPOSE = ('from', 'to', 'map', 'order_kept', 'premises', 'joint_law', 'exits_kept', 'standing', 'source')
COMPOSE_ROLES = ('rule', 'reading', 'pool')
ORDER_KEPT = ('kept', 'not kept', 'not checked', 'not needed')
COMPOSE_STANDING = ('proved', 'stated', 'reading')
# The fields of a dynamic's lists of objects, and those an object may leave out.
PARTS = {'hypotheses': ('record', 'index'), 'exits': ('to', 'law', 'edge', 'strength', 'records', 'source'),
         'transitions': ('kind', 'condition', 'declarations', 'records'), 'tests': ('path', 'thesis', 'state'),
         'open': ('en', 'source')}
OPTIONAL = {'open': ('zh',), 'exits': ('drops', 'to_law', 'standing_without_law'), 'transitions': ('between',)}
# The vocabulary's closed lists. A family is named by its letter (`id`), every other item by its `en`.
LISTS = ('families', 'bases', 'transition_kinds', 'exit_strengths', 'standings_without_record', 'test_states', 'domains',
         'carried', 'relations', 'agreement_of', 'target_roles', 'group_kinds', 'source_bases')
# Closed lists a vocabulary may leave out, where it lists no premise: a premise's kind and what seeded it.
OPTIONAL_LISTS = ('premise_kinds', 'premise_seeds', 'situation_kinds', 'premise_assessments', 'failure_marks', 'exit_openness')
# An exit's strength, from the one that most establishes a route to the one that least does: an exact or a sufficient
# exit gives a condition under which the course leaves; a witness shows one constructed course that leaves, with no
# condition; a necessary exit says only what leaving requires, not that it happens.
ROUTE_STRENGTH = ('exact', 'sufficient', 'witness', 'necessary')
# An exit no law shows says instead how far it has been seen, as an entry with no record does (`standing_without_law`,
# one of the vocabulary's standings without a record): it has no strength, rests on no record and cites the home text
# where it is argued or read. A route through it is weaker than through any exit a law shows, in this order.
ROUTE_STANDING = ROUTE_STRENGTH + ('argued', 'conjectured', 'reading', 'open')


def _seen(x: dict) -> str:
    """How far an exit has been seen: its strength where a law shows it, else its standing without a law."""
    return x['strength'] or x.get('standing_without_law')
# What became of a claim, and what each outcome must show: a relation and targets, or the search behind an absence.
STATED = ('carried', 'carried-in-part', 'changed', 'fresh-reading')
ABSENT = ('history-only', 'not-carried')
# The reads every correspondence has had: a mapper, a reviser, a checker told to refute, a repair after a critic, and a
# comparison across items.
READS = ['map', 'revise', 'check', 'repair', 'compare']
# A target's role, and the one whose connection rests on it: only that one counts in a total of what connects to what.
CARRIES = 'carries'
# A checked law, the only thing `agreement_of: law` may rest on.
LAW = ('recorded-checked', 'theorem')
# The live account: what a target may cite. History, studies, sources and the earlier folders are not.
LIVE = ('theories/becoming/ONE-PAGE', 'theories/becoming/THE-THEORY-OF-BECOMING', 'theories/becoming/chapters/',
        'theories/becoming/COLLECTIVE-DIRECTION', 'theories/becoming/FREE-ENERGY-PRINCIPLE', 'theories/becoming/ONE-ARGUMENT',
        'theories/becoming/review/', 'GLOSSARY', RECORDS + '/')
EARLIER = 'earlier-folders'
ID = re.compile(r'[a-z][a-z0-9-]+')
VALENCE = 'none asserted'
NOT_LIVE = ('superseded', 'withdrawn')


def _text(value) -> bool:
    """A text: {en, zh}, `en` a nonempty string and `zh`, where given, one too; nothing else."""
    return (isinstance(value, dict) and 'en' in value and set(value) <= {'en', 'zh'}
            and all(isinstance(v, str) and v.strip() for v in value.values()))


def _strings(value) -> bool:
    return isinstance(value, list) and all(isinstance(x, str) and x for x in value)


class Repository:
    """What the checks read of the repository, each file read and scanned once in a validation."""

    def __init__(self):
        self.sources = registry.Sources()
        self.core, self.lean, self.anchors = None, None, {}

    def declared(self, name: str) -> str | None:
        """Where `name` is declared: 'core' where the core receipt lists it, as written or under `Becoming.` as the
        chapters write it; else the first tracked live Lean file declaring its last component (the periphery); else
        None. A frozen copy or a history file may declare what the live tree no longer does, so it is not read."""
        if self.core is None:
            p = ROOT / RECEIPT
            self.core = registry.receipt_declaration_names(json.loads(p.read_text())) if p.is_file() else set()
        if name in self.core or 'Becoming.' + name in self.core:
            return 'core'
        if self.lean is None:
            listed = subprocess.run(['git', 'ls-files', '-z', '--', '*.lean'], cwd=ROOT, capture_output=True, text=True).stdout
            self.lean = [p for p in sorted(listed.split('\0')) if p and paths.role(p) == 'live' and (ROOT / p).is_file()]
        return next((p for p in self.lean if self.sources.declares(ROOT / p, name)), None)

    def missing(self, path: str) -> str | None:
        """Why `path` names nothing in the repository, or None."""
        p = (ROOT / path).resolve()
        if Path(path).is_absolute() or not p.is_relative_to(ROOT) or not p.exists():
            return f'no {path} in the repository'
        return None

    def unanchored(self, ref) -> str | None:
        """Why `ref` ("path#anchor") does not resolve, or None where the file has the anchor: an explicit id or a
        heading's slug, as reading_catalogue computes them."""
        path, mark, anchor = ref.partition('#') if isinstance(ref, str) else ('', '', '')
        if not path or not mark or not anchor:
            return f'{ref!r} is not path#anchor'
        if self.missing(path) or not (ROOT / path).is_file():
            return f'no file {path} in the repository'
        if path not in self.anchors:
            self.anchors[path] = reading_catalogue.anchors(ROOT / path)
        return None if unquote(anchor) in self.anchors[path] else f'{path} has no anchor {anchor}'


def _vocabulary_errors(vocabulary) -> list[str]:
    if not isinstance(vocabulary, dict):
        return ['vocabulary: not an object']
    errors = []
    for key in LISTS + tuple(k for k in OPTIONAL_LISTS if k in vocabulary):
        items = vocabulary.get(key)
        if not isinstance(items, list) or not items:
            errors.append(f'vocabulary: {key}: missing or empty')
            continue
        family, names = key == 'families', []
        for item in items:
            named = isinstance(item, dict) and (not family or isinstance(item.get('id'), str) and item['id'].strip())
            if not named or not _text({k: v for k, v in item.items() if not (family and k == 'id')}):
                errors.append(f'vocabulary: {key}: {item!r} is not an item ' + ('{id, en, zh}' if family else '{en, zh}'))
                continue
            names.append(item['id'] if family else item['en'])
        errors += [f'vocabulary: {key}: {n} listed twice' for n in sorted({n for n in names if names.count(n) > 1})]
    return errors


def validate(entries: dict, vocabulary: dict, records: list | None = None) -> list[str]:
    """Every error in the atlas's files (PLAN §3.5), each naming its entry and field. `entries` is {file stem: list},
    as `load` reads it; `records` defaults to the registry's."""
    errors = _vocabulary_errors(vocabulary)
    if errors:
        return errors
    if records is None:
        records = registry.load_records()[0]
    closed = {key: {item['id'] if key == 'families' else item['en'] for item in vocabulary.get(key, [])} for key in LISTS + OPTIONAL_LISTS}
    by_id = {r['id']: r for r in records}
    listed = {kind: entries.get(kind, [] if kind in OPTIONAL_KINDS else None) for kind in KINDS}
    errors += [f'{kind}: not a list of entries' for kind, value in listed.items() if not isinstance(value, list)]
    every = [e.get('id') for value in listed.values() if isinstance(value, list) for e in value if isinstance(e, dict)]
    known = {i for i in every if isinstance(i, str)}
    dynamic_ids = {e.get('id') for e in listed.get('dynamics') or [] if isinstance(e, dict) and isinstance(e.get('id'), str)}
    premise_ids = {e.get('id') for e in listed.get('premises') or [] if isinstance(e, dict) and isinstance(e.get('id'), str)}
    repo = Repository()
    seen = set()
    groups = {g.get('id'): g for g in listed.get('correspondence_groups') or [] if isinstance(g, dict)}
    check = {'dynamic': _dynamic, 'correspondence': _correspondence, 'correspondence group': _correspondence_group,
             'premise': _premise, 'binding': _binding, 'situation': _situation}
    tests = {}
    if listed.get('bindings'):
        try:
            tests = {t.get('id'): t for t in json.loads((ROOT / TESTS).read_text()).get('tests', []) if isinstance(t, dict)}
        except (OSError, ValueError) as e:
            errors.append(f'{TESTS}: {e}')
    context = {'dynamics': {d['id']: d for d in listed.get('dynamics') or [] if isinstance(d, dict) and isinstance(d.get('id'), str)},
               'premise_ids': premise_ids, 'tests': tests}
    for kind, value in listed.items():
        for n, e in enumerate(value if isinstance(value, list) else [], 1):
            at = e.get('id') if isinstance(e, dict) and isinstance(e.get('id'), str) else f'entry {n}'
            if at in seen:
                errors.append(f'{kind}: {at}: id: listed {every.count(at)} times; ids are unique across the atlas')
            seen.add(at)
            errors += check[KINDS[kind]](e, f'{kind}: {at}', closed, by_id, repo,
                                         (dynamic_ids, premise_ids) if kind == 'dynamics'
                                         else context if kind in ('bindings', 'situations') else groups)
    for e in listed.get('correspondences') or []:
        same = e.get('same_as') if isinstance(e, dict) else None
        if same is not None and not (_strings(same) and set(same) <= known):
            errors.append(f'correspondences: {e.get("id")}: same_as: not a list of other entries of the atlas')
    return errors


def binding_id(test: str) -> str:
    """A binding's id, made from its test row's id: 'LA4 (Stage A)' gives test-la4-stage-a."""
    return 'test-' + re.sub(r'[^a-z0-9]+', '-', test.lower()).strip('-')


def _pairs(value) -> bool:
    """A list of {role, as}, each a text."""
    return isinstance(value, list) and all(isinstance(r, dict) and set(r) == {'role', 'as'} and _text(r['role']) and _text(r['as'])
                                           for r in value)


def _binding(e, at: str, closed: dict, by_id: dict, repo: Repository, context: dict) -> list[str]:
    """The errors of one binding: a row of the tests table bound to the dynamics it bears on and, where it has a result,
    the bridge by which its outcome meets the map (MS §2.3)."""
    errors = []

    def fail(field, message):
        errors.append(f'{at}: {field}: {message}')

    if not isinstance(e, dict):
        return [f'{at}: not an object']
    for field in FIELDS['binding']:
        if field not in e:
            fail(field, 'missing (null where there is none)')
    for field in sorted(set(e) - set(FIELDS['binding'])):
        fail(field, 'not a field of a binding')
    if errors:
        return errors
    dynamics, tests = context['dynamics'], context['tests']
    row = tests.get(e['test']) if isinstance(e['test'], str) else None
    if row is None:
        fail('test', f'{e["test"]!r} is not a row of the tests table ({TESTS})')
    elif e['id'] != binding_id(e['test']):
        fail('id', f'a binding\'s id is made from its test: {binding_id(e["test"])}')
    if not isinstance(e['bears_on'], list) or not e['bears_on']:
        fail('bears_on', 'a nonempty list: the dynamics the row bears on')
    else:
        for i, b in enumerate(e['bears_on'], 1):
            where = f'bears_on {i}'
            if not isinstance(b, dict) or set(b) != {'dynamic', 'records', 'laws', 'how'}:
                fail(where, 'an object {dynamic, records, laws, how}')
                continue
            d = dynamics.get(b['dynamic'])
            if d is None:
                fail(where + '.dynamic', f'{b["dynamic"]} is not a dynamic of the atlas')
                continue
            if d.get('premises') is None:
                fail(where + '.dynamic', f'{b["dynamic"]} is not read for its premises yet (PLAN §13, step 2); only a read dynamic is bound')
            if not _strings(b['records']) or not b['records']:
                fail(where + '.records', 'a nonempty list of the dynamic\'s records through which the row bears')
            else:
                for r in b['records']:
                    if r not in (d.get('records') or []):
                        fail(where + '.records', f'{r} is not a record of {b["dynamic"]}')
            if not _strings(b['laws']) and b['laws'] != []:
                fail(where + '.laws', 'a list of declarations, empty where the row reads no single law')
            else:
                for name in b['laws']:
                    if repo.declared(name) is None:
                        fail(where + '.laws', f'{name} is declared neither in the core receipt nor in a tracked live Lean file')
            if not _text(b['how']):
                fail(where + '.how', 'not a text {en, zh}: what the row reads of the dynamic')
    outcome = row.get('outcome') if row else None
    bridge = e['binding']
    if bridge is None:
        if row is not None and outcome not in NO_RESULT:
            fail('binding', f'the row has a result ({outcome}); its binding says how the outcome meets the map')
        return errors
    if row is not None and outcome in NO_RESULT:
        fail('binding', f'the row ran to no result ({outcome}); null')
    if not isinstance(bridge, dict) or set(bridge) != set(BRIDGE):
        fail('binding', f'an object of exactly {", ".join(BRIDGE)}')
        return errors
    taken = {p for b in (e['bears_on'] if isinstance(e['bears_on'], list) else []) if isinstance(b, dict) and b.get('dynamic') in dynamics
             for h in dynamics[b['dynamic']].get('premises') or [] for p in h.get('takes', [])}
    if bridge['kind'] not in closed.get('situation_kinds', set()):
        fail('binding.kind', f'{bridge["kind"]!r} is not in the vocabulary\'s situation_kinds')
    t = bridge['target']
    if not isinstance(t, dict) or set(t) != {'records', 'laws', 'conclusion'}:
        fail('binding.target', 'an object {records, laws, conclusion}')
    else:
        for r in t['records'] if _strings(t['records']) else ['(not a list)']:
            if r not in by_id:
                fail('binding.target.records', f'{r} is not a record')
        for name in t['laws'] if _strings(t['laws']) or t['laws'] == [] else ['(not a list)']:
            if repo.declared(name) is None:
                fail('binding.target.laws', f'{name} is declared neither in the core receipt nor in a tracked live Lean file')
        if not t['records'] and not t['laws']:
            fail('binding.target', 'names at least one record or law whose conclusion the row reads')
        if not _text(t['conclusion']):
            fail('binding.target.conclusion', 'not a text {en, zh}')
    if not _pairs(bridge['roles']) or not bridge['roles']:
        fail('binding.roles', 'a nonempty list of {role, as}, each a text')
    if not isinstance(bridge['premises'], list):
        fail('binding.premises', 'a list of {premise, assessed, how}')
    else:
        for i, p in enumerate(bridge['premises'], 1):
            if not isinstance(p, dict) or set(p) != {'premise', 'assessed', 'how'}:
                fail(f'binding.premises {i}', 'an object {premise, assessed, how}')
                continue
            if p['premise'] not in context['premise_ids']:
                fail(f'binding.premises {i}', f'{p["premise"]} is not a premise of the ledger')
            elif p['premise'] not in taken:
                fail(f'binding.premises {i}', f'{p["premise"]} is taken by no law of a dynamic the row bears on')
            if p['assessed'] not in closed.get('premise_assessments', set()):
                fail(f'binding.premises {i}.assessed', f'{p["assessed"]!r} is not in the vocabulary\'s premise_assessments')
            if not _text(p['how']):
                fail(f'binding.premises {i}.how', 'not a text {en, zh}')
    for field in ('observed', 'result', 'marks_why', 'alternative'):
        if not _text(bridge[field]):
            fail(f'binding.{field}', 'not a text {en, zh}')
    if bridge['marks'] not in closed.get('failure_marks', set()):
        fail('binding.marks', f'{bridge["marks"]!r} is not in the vocabulary\'s failure_marks')
    why = repo.unanchored(bridge['source'])
    if why:
        fail('binding.source', why)
    return errors


def _situation(e, at: str, closed: dict, by_id: dict, repo: Repository, context: dict) -> list[str]:
    """The errors of one situation: a case written in the account's words (MS §2.3), its own graph of formations,
    conditions, couplings and readers, and the dynamics, premises and exits of the atlas it is read through."""
    errors = []

    def fail(field, message):
        errors.append(f'{at}: {field}: {message}')

    if not isinstance(e, dict):
        return [f'{at}: not an object']
    for field in FIELDS['situation']:
        if field not in e:
            fail(field, 'missing')
    for field in sorted(set(e) - set(FIELDS['situation'])):
        fail(field, 'not a field of a situation')
    if errors:
        return errors
    if not isinstance(e['id'], str) or not ID.fullmatch(e['id']):
        fail('id', 'not an id: [a-z][a-z0-9-]+')
    for field in ('name', 'summary', 'rule', 'time'):
        if not _text(e[field]):
            fail(field, 'not a text {en, zh}')
    if e['kind'] not in closed.get('situation_kinds', set()):
        fail('kind', f'{e["kind"]!r} is not in the vocabulary\'s situation_kinds')
    if e['standing'] not in closed.get('standings_without_record', set()):
        fail('standing', f'{e["standing"]!r} is not in the vocabulary\'s standings_without_record: a situation is no result')
    nodes = []
    for field in ('formations', 'conditions'):
        if not isinstance(e[field], list) or not e[field]:
            fail(field, 'a nonempty list of {id, en}')
            continue
        for i, n in enumerate(e[field], 1):
            if not isinstance(n, dict) or set(n) != {'id', 'en'} or not isinstance(n['id'], str) or not ID.fullmatch(n['id']) \
                    or not isinstance(n['en'], str) or not n['en'].strip():
                fail(f'{field} {i}', 'an object {id, en}, the id [a-z][a-z0-9-]+')
            elif n['id'] in nodes:
                fail(f'{field} {i}', f'{n["id"]} is listed twice in the situation')
            else:
                nodes.append(n['id'])
    formations = {n['id'] for n in e['formations'] if isinstance(n, dict)} if isinstance(e['formations'], list) else set()
    if not isinstance(e['couplings'], list):
        fail('couplings', 'a list of {from, to, en}')
    else:
        for i, c in enumerate(e['couplings'], 1):
            if not isinstance(c, dict) or set(c) != {'from', 'to', 'en'} or not isinstance(c['en'], str) or not c['en'].strip():
                fail(f'couplings {i}', 'an object {from, to, en}')
            elif c['from'] not in nodes or c['to'] not in nodes or c['from'] == c['to']:
                fail(f'couplings {i}', f'{c["from"]} to {c["to"]}: both a formation or condition of the situation, and two')
    readers = set()
    if not isinstance(e['readers'], list) or not e['readers']:
        fail('readers', 'a nonempty list of {id, reads, drawn_from} and optionally selects')
    else:
        for i, r in enumerate(e['readers'], 1):
            if not isinstance(r, dict) or not {'id', 'reads', 'drawn_from'} <= set(r) <= {'id', 'reads', 'drawn_from', 'selects'}:
                fail(f'readers {i}', 'an object {id, reads, drawn_from}, and optionally selects')
                continue
            if r['id'] not in formations:
                fail(f'readers {i}.id', f'{r["id"]} is not a formation of the situation')
            elif r['id'] in readers:
                fail(f'readers {i}.id', f'{r["id"]} is listed as a reader twice')
            readers.add(r['id'])
            if not _strings(r['reads']) or not r['reads'] or not set(r['reads']) <= set(nodes):
                fail(f'readers {i}.reads', 'a nonempty list of the situation\'s formations and conditions')
            if not _text(r['drawn_from']):
                fail(f'readers {i}.drawn_from', 'not a text {en, zh}')
            if 'selects' in r and (not _strings(r['selects']) or not r['selects'] or not set(r['selects']) <= formations):
                fail(f'readers {i}.selects', 'a nonempty list of the situation\'s formations its reading selects among')
    dynamics = context['dynamics']
    acting = set()
    if not isinstance(e['dynamics'], list) or not e['dynamics']:
        fail('dynamics', 'a nonempty list of {dynamic, as, roles}')
    else:
        for i, x in enumerate(e['dynamics'], 1):
            if not isinstance(x, dict) or set(x) != {'dynamic', 'as', 'roles'}:
                fail(f'dynamics {i}', 'an object {dynamic, as, roles}')
                continue
            d = dynamics.get(x['dynamic'])
            if d is None:
                fail(f'dynamics {i}', f'{x["dynamic"]} is not a dynamic of the atlas')
                continue
            if d.get('premises') is None:
                fail(f'dynamics {i}', f'{x["dynamic"]} is not read for its premises yet (PLAN §13, step 2)')
            else:
                acting.add(x['dynamic'])
            if not _text(x['as']):
                fail(f'dynamics {i}.as', 'not a text {en, zh}')
            if not _pairs(x['roles']):
                fail(f'dynamics {i}.roles', 'a list of {role, as}, each a text')
    taken = {p for d in acting for h in dynamics[d].get('premises') or [] for p in h.get('takes', [])}
    if not isinstance(e['premises'], list):
        fail('premises', 'a list of {premise, assessed, why}')
    else:
        for i, p in enumerate(e['premises'], 1):
            if not isinstance(p, dict) or set(p) != {'premise', 'assessed', 'why'}:
                fail(f'premises {i}', 'an object {premise, assessed, why}')
                continue
            if p['premise'] not in context['premise_ids']:
                fail(f'premises {i}', f'{p["premise"]} is not a premise of the ledger')
            elif p['premise'] not in taken:
                fail(f'premises {i}', f'{p["premise"]} is taken by no law of a dynamic the situation lists')
            if p['assessed'] not in closed.get('premise_assessments', set()):
                fail(f'premises {i}.assessed', f'{p["assessed"]!r} is not in the vocabulary\'s premise_assessments')
            if not _text(p['why']):
                fail(f'premises {i}.why', 'not a text {en, zh}')
    if not isinstance(e['exits'], list):
        fail('exits', 'a list of {dynamic, exit, open, why}')
    else:
        seen = set()
        for i, x in enumerate(e['exits'], 1):
            if not isinstance(x, dict) or set(x) != {'dynamic', 'exit', 'open', 'why'}:
                fail(f'exits {i}', 'an object {dynamic, exit, open, why}')
                continue
            if x['dynamic'] not in acting:
                fail(f'exits {i}', f'{x["dynamic"]} is not a dynamic the situation lists')
            elif not isinstance(x['exit'], int) or not 1 <= x['exit'] <= len(dynamics[x['dynamic']].get('exits') or []):
                fail(f'exits {i}.exit', f'{x["dynamic"]} has no exit {x["exit"]}')
            if (x['dynamic'], x['exit']) in seen:
                fail(f'exits {i}', f'{x["dynamic"]} exit {x["exit"]} is listed twice')
            seen.add((x['dynamic'], x['exit']))
            if x['open'] not in closed.get('exit_openness', set()):
                fail(f'exits {i}.open', f'{x["open"]!r} is not in the vocabulary\'s exit_openness')
            if not _text(x['why']):
                fail(f'exits {i}.why', 'not a text {en, zh}')
        for d in sorted(acting):
            for n in range(1, len(dynamics[d].get('exits') or []) + 1):
                if (d, n) not in seen:
                    fail('exits', f'{d} exit {n} is not read: a situation reads every exit of each dynamic it lists, open, closed or not read')
    if not isinstance(e['bears'], list) or not e['bears'] or not all(
            isinstance(b, dict) and set(b) == {'who', 'what'} and _text(b['who']) and _text(b['what']) for b in e['bears']):
        fail('bears', 'a nonempty list of {who, what}, each a text: who bears what the situation selects')
    if not _strings(e['sources']) or not e['sources']:
        fail('sources', 'a nonempty list of the records and readings it is written from')
    else:
        for ref in e['sources']:
            why = repo.unanchored(ref) if '#' in ref else repo.missing(ref)
            if why:
                fail('sources', why)
    return errors


def situation_sets(s: dict) -> list[dict]:
    """What the checker computes of a situation's graph, for each reader: its closure (the formations and conditions
    with a path of couplings into it, it included), what its acts reach (those with a path of couplings from it), what
    lies beyond it (reached and not in its closure: a selection read through it cannot tell these apart, by
    `Flow.unselected_beyond_pool` and `BeyondCoupling`, under those laws' premises, which the situation assesses), and
    what it reads among those it selects."""
    nodes = [n['id'] for n in s['formations'] + s['conditions']]
    into, out = {n: set() for n in nodes}, {n: set() for n in nodes}
    for c in s['couplings']:
        out[c['from']].add(c['to'])
        into[c['to']].add(c['from'])

    def along(start, edges):
        seen, todo = {start}, [start]
        while todo:
            for y in edges[todo.pop()]:
                if y not in seen:
                    seen.add(y)
                    todo.append(y)
        return seen

    order = {n: i for i, n in enumerate(nodes)}
    rows = []
    for r in s['readers']:
        closure = along(r['id'], into)
        reach = along(r['id'], out) - {r['id']}
        rows.append({'reader': r['id'], 'closure': sorted(closure, key=order.get), 'reaches': sorted(reach, key=order.get),
                     'beyond': sorted(reach - closure, key=order.get),
                     'reads_among_selected': sorted(set(r['reads']) & set(r.get('selects', [])), key=order.get)})
    return rows



def _correspondence(e, at: str, closed: dict, by_id: dict, repo: Repository, groups: dict) -> list[str]:
    """The errors of one correspondence, each as '<kind>: <id>: <field>: <what is wrong>'."""
    errors = []

    def fail(field, message):
        errors.append(f'{at}: {field}: {message}')

    if not isinstance(e, dict):
        return [f'{at}: not an object']
    for field in FIELDS['correspondence']:
        if field not in e:
            fail(field, 'missing (null or an empty list where there is none)')
    for field in sorted(set(e) - set(FIELDS['correspondence'])):
        fail(field, 'not a field of a correspondence')
    if errors:
        return errors
    if not isinstance(e['id'], str) or not ID.fullmatch(e['id']):
        fail('id', 'not an id: [a-z][a-z0-9-]+')
    for field in ('name', 'sense', 'reading'):
        if not _text(e[field]):
            fail(field, 'not a text {en, zh}')
    for field in ('account_adds', 'source_adds'):
        if e[field] is not None and not _text(e[field]):
            fail(field, 'neither null nor a text {en, zh}')
    if e['domain'] not in closed['domains']:
        fail('domain', f'{e["domain"]!r} is not in the vocabulary\'s domains')
    if e['group'] not in groups:
        fail('group', f'no correspondence group {e["group"]}')
    elif groups[e['group']].get('domain') != e['domain']:
        fail('domain', f'its group {e["group"]} is in {groups[e["group"]].get("domain")}')
    if not (isinstance(e['labels'], list) and 'AI reading' in e['labels']):
        fail('labels', 'every correspondence is labelled AI reading')
    if e['reads'] != READS:
        fail('reads', f'a correspondence has had its reads: {READS}')
    source = e['source']
    if not (isinstance(source, dict) and set(source) == {'work', 'locator', 'basis'}
            and all(isinstance(source[k], str) and source[k].strip() for k in source)):
        fail('source', 'not {work, locator, basis}')
    else:
        if source['basis'] not in closed['source_bases']:
            fail('source.basis', f'{source["basis"]!r} is not in the vocabulary\'s source_bases')
        if source['basis'] == 'read-in-repo':
            why = repo.missing(source['work'])
            if why:
                fail('source.work', why)
            elif e['quote'] and not (isinstance(e['quote'], str) and (ROOT / source['work']).is_file()
                                     and e['quote'] in (ROOT / source['work']).read_text(encoding='utf-8')):
                fail('quote', f'not verbatim in {source["work"]}')
        elif e['quote'] is not None:
            fail('quote', 'a source not stored here has no quote to check; paraphrase it')
    if e['carried'] not in closed['carried']:
        fail('carried', f'{e["carried"]!r} is not in the vocabulary\'s carried')
    if e['relation'] is not None and e['relation'] not in closed['relations']:
        fail('relation', f'{e["relation"]!r} is not in the vocabulary\'s relations')
    targets = e['targets'] if isinstance(e['targets'], list) else None
    if targets is None:
        fail('targets', 'not a list')
        targets = []
    carrying = [t for t in targets if isinstance(t, dict) and t.get('role') == CARRIES]
    if e['carried'] in STATED:
        if e['relation'] is None:
            fail('relation', f'{e["carried"]} needs a relation')
        if not targets:
            fail('targets', f'{e["carried"]} needs what it is read against')
        elif not carrying:
            fail('targets', f'{e["carried"]} needs a target whose role is {CARRIES}')
    if e['carried'] == 'history-only' and carrying:
        fail('targets', f'nothing is carried in a history-only entry; its targets are neighbours, not {CARRIES}')
    if e['relation'] == 'agreement':
        if e['agreement_of'] not in closed['agreement_of']:
            fail('agreement_of', f'{e["agreement_of"]!r} is not in the vocabulary\'s agreement_of; every agreement says what it is agreement with')
        elif e['agreement_of'] == 'law' and not any((by_id.get(t.get('record')) or {}).get('status') == LAW[0] and by_id[t['record']].get('kind') == LAW[1]
                                                    for t in carrying):
            fail('agreement_of', 'agreement of a law needs a carrying target that is a checked theorem')
    elif e['agreement_of'] is not None:
        fail('agreement_of', 'only for agreement')
    if e['carried'] == 'carried-in-part' and not e['source_adds']:
        fail('source_adds', 'carried-in-part says what is not stated')
    if e['carried'] == 'not-carried' and (e['relation'] is not None or targets):
        fail('relation', 'not-carried has no relation and no targets')
    if e['carried'] in ABSENT:
        absence = e['absence']
        if not (isinstance(absence, dict) and isinstance(absence.get('searched'), list) and absence['searched']):
            fail('absence', f'{e["carried"]} says what was searched')
    elif e['absence'] is not None:
        fail('absence', 'only for history-only and not-carried')
    for n, t in enumerate(targets):
        where = f'targets[{n}]'
        if not (isinstance(t, dict) and (t.get('record') or t.get('anchor')) and _text(t.get('says'))):
            fail(where, 'not {record or anchor, says}')
            continue
        if t.get('role') not in closed['target_roles']:
            fail(where + '.role', f'{t.get("role")!r} is not in the vocabulary\'s target_roles')
        if t.get('record'):
            if t['record'] not in by_id:
                fail(where + '.record', f'no record {t["record"]} in {RECORDS}')
            elif by_id[t['record']].get('status') in NOT_LIVE:
                fail(where + '.record', f'record {t["record"]} is {by_id[t["record"]]["status"]}; cite a live record')
        if t.get('anchor'):
            path = t['anchor'].partition('#')[0]
            why = repo.unanchored(t['anchor']) if '#' in t['anchor'] else repo.missing(path)
            if why:
                fail(where + '.anchor', why)
            elif not path.startswith(LIVE):
                fail(where + '.anchor', f'{path} is not in the live account')
    return errors


def _correspondence_group(g, at: str, closed: dict, by_id: dict, repo: Repository, groups: dict) -> list[str]:
    """The errors of one group of correspondences: a folder or a domain, and what its readers read."""
    errors = []

    def fail(field, message):
        errors.append(f'{at}: {field}: {message}')

    if not isinstance(g, dict):
        return [f'{at}: not an object']
    for field in FIELDS['correspondence group']:
        if field not in g:
            fail(field, 'missing (null or an empty list where there is none)')
    for field in sorted(set(g) - set(FIELDS['correspondence group'])):
        fail(field, 'not a field of a correspondence group')
    if errors:
        return errors
    if not isinstance(g['id'], str) or not ID.fullmatch(g['id']):
        fail('id', 'not an id: [a-z][a-z0-9-]+')
    for field in ('title', 'summary'):
        if not _text(g[field]):
            fail(field, 'not a text {en, zh}')
    if g['domain'] not in closed['domains']:
        fail('domain', f'{g["domain"]!r} is not in the vocabulary\'s domains')
    if g['kind'] not in closed['group_kinds']:
        fail('kind', f'{g["kind"]!r} is not in the vocabulary\'s group_kinds')
    for field in ('read', 'skimmed', 'searched'):
        if not _strings(g[field]):
            fail(field, 'not a list of strings')
    if not isinstance(g['not_mapped'], list):
        fail('not_mapped', 'not a list')
    if g['reads'] != READS:
        fail('reads', f'a group has had its reads: {READS}')
    why = repo.missing(g['source'])
    if why:
        fail('source', why)
    if g['domain'] == EARLIER and isinstance(g['id'], str):
        # the index of the earlier folders links each group's folder by its id
        why = repo.missing(f"theories/{g['id'].removeprefix('cxg-')}/README.md")
        if why:
            fail('id', f'an earlier folder\'s group is named cxg-<its folder>: {why}')
    if g['domain'] != EARLIER:
        cover = g['coverage']
        if not (isinstance(cover, dict) and isinstance(cover.get('present'), list) and isinstance(cover.get('absent'), list)):
            fail('coverage', 'a domain says what is present and what is absent')
    return errors


def _dynamic(e, at: str, closed: dict, by_id: dict, repo: Repository, known) -> list[str]:
    """The errors of one dynamic, each as '<kind>: <id>: <field>: <what is wrong>'. `known` is (the dynamics' ids, the
    premises' ids), or the dynamics' ids alone."""
    errors = []
    known, premise_ids = known if isinstance(known, tuple) else (known, set())

    def fail(field, message):
        errors.append(f'{at}: {field}: {message}')

    if not isinstance(e, dict):
        return [f'{at}: not an object']
    for field in FIELDS['dynamic']:
        if field not in e:
            fail(field, 'missing (an empty list or null where there is none)')
    for field in sorted(set(e) - set(FIELDS['dynamic']) - set(DYNAMIC_OPTIONAL)):
        fail(field, 'not a field of a dynamic')
    if errors:
        return errors

    def premised(field, ids):
        if not _strings(ids):
            fail(field, 'not a list of premise ids')
            return
        for p in ids:
            if p not in premise_ids:
                fail(field, f'{p} is not a premise of the atlas ({ENTRIES}/premises.json)')

    def placed(field, value):
        if isinstance(value, str):
            if value not in known:
                fail(field, f'{value} is not an entry of the atlas')
        elif value is not None and not _text(value):
            fail(field, 'neither null, an entry id nor a text {en, zh}')

    def recorded(field, ids):
        if not _strings(ids):
            fail(field, 'not a list of record ids')
            return
        for r in ids:
            if r not in by_id:
                fail(field, f'no record {r} in {RECORDS}')
            elif by_id[r].get('status') in NOT_LIVE:
                by = f' by {by_id[r]["superseded_by"]}' if by_id[r].get('superseded_by') else ''
                fail(field, f'record {r} is {by_id[r]["status"]}{by}; cite a live record')

    def declared(field, names):
        if not _strings(names):
            fail(field, 'not a list of declaration names')
            return
        for name in names:
            if repo.declared(name) is None:
                fail(field, f'{name} is declared neither in the core receipt nor in a tracked live Lean file')

    def anchored(field, ref):
        why = repo.unanchored(ref)
        if why:
            fail(field, why)

    def closed_in(field, value, key):
        if not isinstance(value, str) or value not in closed[key]:
            fail(field, f'{value!r} is not in the vocabulary\'s {key}')

    def parts(field):
        """The objects of a list field that have exactly its fields, each with its place for errors."""
        if not isinstance(e[field], list):
            fail(field, 'not a list')
            return []
        out, need, may = [], set(PARTS[field]), set(OPTIONAL.get(field, ()))
        for i, x in enumerate(e[field]):
            if not isinstance(x, dict) or not need <= set(x) <= need | may:
                fail(f'{field}[{i}]', 'needs ' + ', '.join(PARTS[field]) + (', and may have ' + ', '.join(OPTIONAL[field])
                                                                            if field in OPTIONAL else ', and nothing else'))
                continue
            out.append((f'{field}[{i}]', x))
        return out

    if not isinstance(e['id'], str) or not ID.fullmatch(e['id']):
        fail('id', f'{e["id"]!r} is not [a-z][a-z0-9-]+')
    for field in ('name', 'mechanism'):
        if not _text(e[field]):
            fail(field, 'not a text {en, zh}: en needed, zh where given')
    for field in ('forbids', 'beyond'):
        if e[field] is not None and not _text(e[field]):
            fail(field, 'neither null nor a text {en, zh}')
    closed_in('family', e['family'], 'families')
    if e['base'] is not None or e['standing_without_record'] is None:  # no theorem, no base: an entry with no record may have none
        closed_in('base', e['base'], 'bases')
    if e['valence'] != VALENCE:
        fail('valence', f'only "{VALENCE}": no dynamic is marked good or bad; what it does beyond its couplings goes in beyond')
    recorded('records', e['records'])
    declared('declarations', e['declarations'])
    own = set(e['records']) if _strings(e['records']) else set()
    for where, h in parts('hypotheses'):
        r, i = h['record'], h['index']
        if not isinstance(r, str) or r not in own:
            fail(where + '.record', f'{r!r} is not among the entry\'s records')
        elif r in by_id:
            count = len(by_id[r].get('hypotheses') or [])
            if type(i) is not int or not 1 <= i <= count:
                fail(where + '.index', f'{r} lists hypotheses 1 to {count}, not {i!r}')
    for where, x in parts('exits'):
        to = x['to']
        if isinstance(to, str):
            if to not in known or to == e['id']:
                fail(where + '.to', f'{to} is not another entry of the atlas')
        elif to is not None and not _text(to):  # null: where it leads has not been read; a text: a state in words
            fail(where + '.to', 'neither null, an entry id nor a text {en, zh}')
        if 'drops' in x:
            premised(where + '.drops', x['drops'])
        if 'to_law' in x:
            if not isinstance(to, str):
                fail(where + '.to_law', 'only an exit to a dynamic names the law that places it there')
            if not isinstance(x['to_law'], str):
                fail(where + '.to_law', 'not a declaration name')
            else:
                declared(where + '.to_law', [x['to_law']])
        if x['law'] is not None and not (isinstance(x['law'], str) and x['law']):
            fail(where + '.law', 'neither null nor a declaration name')
        elif x['law'] is not None:
            declared(where + '.law', [x['law']])
        if not _text(x['edge']):
            fail(where + '.edge', 'every exit names its edge, a text {en, zh}')
        if 'standing_without_law' in x:  # argued, conjectured, a reading or open: no law shows it
            closed_in(where + '.standing_without_law', x['standing_without_law'], 'standings_without_record')
            if x['law'] is not None:
                fail(where + '.standing_without_law', 'an exit a law shows takes its strength from it; leave this out')
            if x['strength'] is not None:
                fail(where + '.strength', 'an exit no law shows has no strength; null, its standing without a law says how far it is seen')
            if x['records']:
                fail(where + '.records', 'an exit no law shows rests on no record; empty, its source cites where it is argued or read')
            if 'to_law' in x:
                fail(where + '.to_law', 'an exit no law shows names no law placing it')
            if 'drops' in x:
                fail(where + '.drops', 'an exit no law shows drops no premise: an exit drops the premise its law shows failing')
        else:
            closed_in(where + '.strength', x['strength'], 'exit_strengths')
            if x['strength'] in ('exact', 'witness') and x['law'] is None:
                fail(where + '.law', ('an exact' if x['strength'] == 'exact' else 'a witness') + ' exit names its law')
        recorded(where + '.records', x['records'])
        anchored(where + '.source', x['source'])
    for where, t in parts('transitions'):
        closed_in(where + '.kind', t['kind'], 'transition_kinds')
        if not _text(t['condition']):
            fail(where + '.condition', 'not a text {en, zh}')
        declared(where + '.declarations', t['declarations'])
        recorded(where + '.records', t['records'])
        between = t.get('between')
        if between is not None:
            if not (isinstance(between, dict) and set(between) == {'from', 'to'}):
                fail(where + '.between', 'neither null nor {from, to}')
            else:
                placed(where + '.between.from', between['from'])
                placed(where + '.between.to', between['to'])
    if 'premises' in e:
        if not isinstance(e['premises'], list):
            fail('premises', 'not a list of {law, takes}')
        else:
            for i, h in enumerate(e['premises']):
                if not (isinstance(h, dict) and {'law', 'takes'} <= set(h) <= {'law', 'takes', 'case_of'}):
                    fail(f'premises[{i}]', 'needs law and takes, may have case_of, and nothing else')
                    continue
                declared(f'premises[{i}].law', [h['law']] if isinstance(h['law'], str) else h['law'])
                premised(f'premises[{i}].takes', h['takes'])
                if 'case_of' in h:  # the general laws it is a case of, where the Lean derives it
                    cases = h['case_of']
                    if not (isinstance(cases, list) and cases):
                        fail(f'premises[{i}].case_of', 'a nonempty list of {law, how}; leave it out where there is none')
                        continue
                    for j, c in enumerate(cases):
                        where = f'premises[{i}].case_of[{j}]'
                        if not (isinstance(c, dict) and set(c) == {'law', 'how'} and isinstance(c['law'], str)):
                            fail(where, 'needs law (a declaration) and how (a text), and nothing else')
                            continue
                        declared(where + '.law', [c['law']])
                        if c['law'] == h['law'] or c['law'] in (e['declarations'] if _strings(e['declarations']) else []):
                            fail(where + '.law', f'{c["law"]} is a law of this dynamic: a step within it, not a general law it is a case of')
                        if not _text(c['how']):
                            fail(where + '.how', 'not a text {en, zh}: which of the general law\'s roles this law fixes, and to what')
    if 'compose' in e:
        if not (isinstance(e['compose'], list) and e['compose']):
            fail('compose', 'a nonempty list of joinings; leave it out where there is none')
        else:
            for i, c in enumerate(e['compose']):
                where = f'compose[{i}]'
                if not (isinstance(c, dict) and set(c) == set(COMPOSE)):
                    fail(where, 'needs ' + ', '.join(COMPOSE) + ', and nothing else')
                    continue
                ends = []
                for side in ('from', 'to'):
                    s = c[side]
                    if not (isinstance(s, dict) and set(s) == {'dynamic', 'law', 'role'}):
                        fail(f'{where}.{side}', 'needs dynamic, law (a declaration or null) and role, and nothing else')
                        continue
                    ends.append(s['dynamic'])
                    if s['dynamic'] not in known:
                        fail(f'{where}.{side}.dynamic', f'{s["dynamic"]!r} is not an entry of the atlas')
                    if s['law'] is not None:
                        declared(f'{where}.{side}.law', [s['law']])
                    if not (isinstance(s['role'], str) and s['role'].strip()):
                        fail(f'{where}.{side}.role', 'not a role in words')
                if len(ends) == 2:
                    if e['id'] not in ends:
                        fail(where, 'a joining is written on one of the two dynamics it joins')
                    if ends[0] == ends[1]:
                        fail(where, 'a joining is between two dynamics')
                    if isinstance(c['to'].get('role'), str) and c['to']['role'] not in COMPOSE_ROLES:
                        fail(f'{where}.to.role', f'{c["to"]["role"]!r}: what the first\'s state becomes is a ' + ', a '.join(COMPOSE_ROLES[:-1]) + ' or a ' + COMPOSE_ROLES[-1])
                if not _text(c['map']):
                    fail(where + '.map', 'not a text {en, zh}: how the first\'s state is read as the second\'s role')
                if c['order_kept'] not in ORDER_KEPT:
                    fail(where + '.order_kept', f'{c["order_kept"]!r} is none of ' + ', '.join(ORDER_KEPT))
                premised(where + '.premises', c['premises'])
                if c['exits_kept'] is not None and not _text(c['exits_kept']):
                    fail(where + '.exits_kept', 'neither null nor a text {en, zh}')
                if c['standing'] not in COMPOSE_STANDING:
                    fail(where + '.standing', f'{c["standing"]!r}: proved (a joint law relates both), stated (a theorem\'s home says it) or reading (a chapter\'s AI reading proposes it)')
                elif c['standing'] == 'proved':
                    if not isinstance(c['joint_law'], str):
                        fail(where + '.joint_law', 'a proved joining names the Lean law whose statement relates both sides')
                    else:
                        declared(where + '.joint_law', [c['joint_law']])
                elif c['joint_law'] is not None:
                    fail(where + '.joint_law', f'a {c["standing"]} joining has no joint law; null, or proved with it')
                anchored(where + '.source', c['source'])
    for where, t in parts('tests'):
        why = repo.missing(t['path']) if isinstance(t['path'], str) and t['path'] else f'{t["path"]!r} is not a path'
        if why:
            fail(where + '.path', why)
        if t['thesis'] is not None and (not isinstance(t['thesis'], str) or not t['thesis'].strip()):  # null: a test of no thesis
            fail(where + '.thesis', 'neither null nor a thesis name')
        closed_in(where + '.state', t['state'], 'test_states')
    for where, o in parts('open'):
        if not _text({k: o[k] for k in ('en', 'zh') if k in o}):
            fail(where, 'en (and zh where given) not a text')
        anchored(where + '.source', o['source'])
    if not _strings(e['sources']):
        fail('sources', 'not a list of path#anchor')
    else:
        for i, ref in enumerate(e['sources']):
            anchored(f'sources[{i}]', ref)
    standing = e['standing_without_record']
    if standing is not None:
        closed_in('standing_without_record', standing, 'standings_without_record')
    if e['records'] and standing is not None:
        fail('standing_without_record', 'an entry with records takes its standing from them; null')
    if not e['records'] and standing is None:
        fail('standing_without_record', 'an entry with no record says which: ' + ', '.join(sorted(closed['standings_without_record'])))
    if not e['records'] and not e['sources']:
        fail('sources', 'an entry with no record cites its source')
    return errors


def _premise(e, at: str, closed: dict, by_id: dict, repo: Repository, _groups) -> list[str]:
    """The errors of one premise, each as '<kind>: <id>: <field>: <what is wrong>'."""
    errors = []

    def fail(field, message):
        errors.append(f'{at}: {field}: {message}')

    if not isinstance(e, dict):
        return [f'{at}: not an object']
    for field in FIELDS['premise']:
        if field not in e:
            fail(field, 'missing (an empty list or null where there is none)')
    for field in sorted(set(e) - set(FIELDS['premise'])):
        fail(field, 'not a field of a premise')
    if errors:
        return errors
    if not isinstance(e['id'], str) or not ID.fullmatch(e['id']):
        fail('id', f'{e["id"]!r} is not [a-z][a-z0-9-]+')
    if not _text(e['name']):
        fail('name', 'not a text {en, zh}')
    if e['statement'] is not None and not _text(e['statement']):  # null: its home is being re-said; the statement waits
        fail('statement', 'neither null nor a text {en, zh}')
    if e['kind'] not in closed.get('premise_kinds', set()):
        fail('kind', f'{e["kind"]!r} is not in the vocabulary\'s premise_kinds')
    if not _strings(e['lean']):
        fail('lean', 'not a list of declaration names')
    else:
        for name in e['lean']:
            if repo.declared(name) is None:
                fail('lean', f'{name} is declared neither in the core receipt nor in a tracked live Lean file')
    for field in ('holds_in', 'fails_in'):
        if not _strings(e[field]):
            fail(field, 'not a list of declarations or records')
            continue
        for x in e[field]:
            if x not in by_id and repo.declared(x) is None:
                fail(field, f'{x} is neither a record nor a declaration in the core receipt or a tracked live Lean file')
    why = repo.unanchored(e['home'])
    if why:
        fail('home', why)
    if not _strings(e['seeded_from']) or not e['seeded_from']:
        fail('seeded_from', 'not a nonempty list')
    else:
        for x in e['seeded_from']:
            if x not in closed.get('premise_seeds', set()):
                fail('seeded_from', f'{x!r} is not in the vocabulary\'s premise_seeds')
    return errors


def _paged(premises: list, dynamics: list) -> list:
    page = _premise_page_of({'dynamics': dynamics, 'premises': premises})
    return [{**q, 'page': page[q['id']]} for q in premises]


def build(entries: dict, vocabulary: dict, records: list) -> dict:
    """The resolved atlas, from validated entries: each entry with the standing of each record it and its exits and
    transitions cite (status and kind, as the record says), and the text of its hypotheses."""
    by_id = {r['id']: r for r in records}

    def standing(ids):
        return [{'record': r, 'status': by_id[r].get('status'), 'kind': by_id[r].get('kind')} for r in ids]

    dynamics = []
    for e in entries['dynamics']:
        d = {}
        for field in FIELDS['dynamic']:
            d[field] = e[field]
            if field == 'records':
                d['standing'] = standing(e['records'])
        for field in DYNAMIC_OPTIONAL:
            if field in e:
                d[field] = e[field]
        d['hypotheses'] = [{**h, 'text': {k: v for k, v in by_id[h['record']]['hypotheses'][h['index'] - 1].items() if k in ('en', 'zh')}}
                           for h in e['hypotheses']]
        d['exits'] = [{**x, 'standing': standing(x['records'])} for x in e['exits']]
        d['transitions'] = [{**t, 'standing': standing(t['records'])} for t in e['transitions']]
        dynamics.append(d)
    counts = {f['id']: sum(d['family'] == f['id'] for d in dynamics) for f in vocabulary['families']}
    correspondences = [{**e, 'targets': [{**t, 'standing': standing([t['record']])[0]} if t.get('record') else dict(t)
                                         for t in e['targets']]} for e in entries['correspondences']]
    groups = []
    for g in entries['correspondence_groups']:
        held = [e for e in correspondences if e['group'] == g['id']]
        groups.append({**g, 'entries': len(held),
                       'by_carried': {c['en']: sum(e['carried'] == c['en'] for e in held) for c in vocabulary['carried']},
                       'by_relation': {r['en']: sum(e['relation'] == r['en'] for e in held) for r in vocabulary['relations']},
                       'by_agreement_of': {a['en']: sum(e['agreement_of'] == a['en'] for e in held) for a in vocabulary['agreement_of']}})
    return {'schema_version': 1, 'about': ABOUT, 'vocabulary': vocabulary, 'counts': counts, 'dynamics': dynamics,
            'premises': _paged(entries.get('premises', []), dynamics), 'bindings': entries.get('bindings', []),
            'situations': [{**x, 'computed': situation_sets(x)} for x in entries.get('situations', [])],
            'correspondence_groups': groups, 'correspondences': correspondences}


# --- the page ----------------------------------------------------------------------------------------------------

def _line(value) -> str:
    """A text's English (its Chinese where it has none) on one line."""
    return ' '.join(registry.en(value).split())


def _cell(text: str) -> str:
    return text.replace('|', '\\|')


def _href(ref: str, at: str = ATLAS) -> str:
    """A link target from a page in the folder `at` to a repository path, with its #anchor."""
    path, mark, anchor = ref.partition('#')
    target = posixpath.relpath(path, at) + mark + anchor
    return f'<{target}>' if re.search(r'[\s()<>]', target) else target


def _source(ref: str, at: str = ATLAS) -> str:
    path, _, anchor = ref.partition('#')
    return f'[{posixpath.basename(path)}#{anchor}]({_href(ref, at)})'


def _record(r: str, at: str = ATLAS) -> str:
    return f'[{r}]({_href(f"{RECORDS}/{r}.md", at)})'


def _standings(standing: list, at: str = ATLAS) -> str:
    return '; '.join(f'{_record(s["record"], at)} {s["status"]} ({s["kind"]})' for s in standing)


def _name(d: dict) -> str:
    return d['name']['en'] + (f' ({d["name"]["zh"]})' if d['name'].get('zh') else '')


def _headings(titles: list[str]) -> list[str]:
    """GitHub's anchors for these headings in order, repeats numbered as GitHub numbers them."""
    return reading_catalogue.numbered([reading_catalogue.slug(t) for t in titles])


def _marks(ids: list[str], taken: set) -> str:
    """Anchors for a row, each once and none the page has already."""
    out = []
    for i in ids:
        if i not in taken:
            taken.add(i)
            out.append(f'<a id="{i}"></a>')
    return ''.join(out)


PLAN = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aa-attractor-atlas/PLAN.md'
PLAN_NEXT = PLAN + '#13-the-next-phase-the-maps-structures-9-november-2026'
JOINS = ATLAS + '/JOINS.md'


def views_line(here: str, atlas: dict) -> str:
    """The atlas's own views, each where it exists, the page itself bold."""
    views = [('the atlas', PAGE)]
    if atlas.get('premises'):
        views += [('the premise ledger', PREMISES_PAGE), ('the terrain', TERRAIN)]
    if atlas.get('bindings'):
        views.append(('tests bound', BINDINGS_PAGE))
    if atlas.get('situations'):
        views.append(('situations', SITUATIONS_PAGE))
    views += [('the crosswalk', CROSSWALK), ('what does not join', JOINS)]
    return "The atlas's views: " + ' · '.join(f'**{label}**' if path == here else f'[{label}]({_href(path, posixpath.dirname(here))})'
                                              for label, path in views)


def _navigation(here: str, atlas: dict | None = None) -> str:
    """The lines that open and close each page: the repository's shared navigation line, then the atlas's views."""
    return navigation.nav_line(here) + ('\n\n' + views_line(here, atlas) if atlas is not None else '')


def _finish(out: list[str]) -> str:
    """The page's lines, one blank line between sections and one newline at the end."""
    return re.sub(r'\n{3,}', '\n\n', '\n'.join(out)).rstrip('\n') + '\n'


# --- the atlas: an index, and a page for each family ---------------------------------------------------------------

def family_path(family: dict) -> str:
    """A family's page: families/<its letter>.md."""
    return f'{FAMILY_PAGES}/{family["id"].lower()}.md'


def _homes(atlas: dict) -> dict:
    """Each dynamic's page: its family's."""
    by_id = {f['id']: f for f in atlas['vocabulary']['families']}
    return {d['id']: family_path(by_id[d['family']]) for d in atlas['dynamics']}


def _section(dynamic: str, homes: dict, here: str) -> str:
    """The link from the page `here` to a dynamic's section."""
    home = homes[dynamic]
    return f'#{dynamic}' if home == here else _href(f'{home}#{dynamic}', posixpath.dirname(here))


def _atlas_lead(at: str) -> str:
    return ("The account's dynamics (attractors, locks, drains, absorptions, cycles, closures and kept regions), each with "
            'the records and declarations that state it. The atlas is a curated layer beside the records '
            f'([vocabulary]({_href(VOCABULARY, at)}), [entries]({_href(ENTRIES, at)})); it creates no result and strengthens no '
            "proof. It adds nothing to how far anything has been seen: an entry shows each of its records' status and kind "
            'as the record says, never merged into one scale, and an entry with no record says whether it is argued, '
            "conjectured, a reading or open, and cites where. Hypotheses are quoted from the records by their place in the "
            "record's list, counted from 1. The atlas maps dynamics: how what one opens or closes ranks is "
            f"[chapter 7's question]({_href('theories/becoming/chapters/07-SIGNIFICANCE.md', at)}), where widening and narrowing "
            'are more and less future, not good and evil, so no entry marks a dynamic good or bad, and what one does to what '
            'lies beyond its couplings is under *Beyond its couplings*.')


def _family_table(listed: list, homes: dict, here: str, keep: dict | None = None) -> list[str]:
    """A family's index: a row for each dynamic, linking its section. `keep` gives, by dynamic, the anchors its section
    had when the atlas was one page (its id and its heading's), which its row then holds, so a link made then still lands."""
    at = posixpath.dirname(here)
    rows = ['| Dynamic | Records | Base | How far seen | Exits | Open |', '|---|---|---|---|---:|---:|']
    for d in listed:
        standing = '; '.join(f'{s["status"]} ({s["kind"]})' for s in d['standing']) or f'{d["standing_without_record"]}, no record'
        mark = keep[d['id']] if keep else ''
        rows.append(f'| {mark}[{_cell(_name(d))}]({_section(d["id"], homes, here)}) | '
                    + (', '.join(_record(r, at) for r in d['records']) or '—')
                    + f' | {d["base"] or "—"} | {standing} | {len(d["exits"])} | {len(d["open"])} |')
    return rows


def premise_path(family: str) -> str:
    return f'{PREMISE_PAGES}/{family.lower()}.md'


def _premise_page_of(atlas: dict) -> dict:
    """Each premise's page: a family's own where only that family's laws take it or its exits drop it, else the ledger."""
    families = {}
    for d in atlas['dynamics']:
        for h in d.get('premises') or []:
            for q in h['takes']:
                families.setdefault(q, set()).add(d['family'])
        for x in d['exits']:
            for q in x.get('drops') or []:
                families.setdefault(q, set()).add(d['family'])
    return {q['id']: premise_path(next(iter(families[q['id']]))) if len(families.get(q['id'], ())) == 1
            and not q['id'].startswith(('k3-', 'card-')) else PREMISES_PAGE for q in atlas.get('premises', [])}


def _premise_link(p: str, premises: dict, at: str) -> str:
    page = premises[p].get('page', PREMISES_PAGE) if p in premises else PREMISES_PAGE
    return f'[{premises[p]["name"]["en"] if p in premises else p}]({_href(f"{page}#{p}", at)})'


def _links(atlas: dict) -> dict:
    """Read off the entries: the dynamics that list each declaration, and each dynamic's joinings, from either end."""
    owners, joins = {}, {}
    for d in atlas['dynamics']:
        for n in d['declarations']:
            owners.setdefault(n, []).append(d['id'])
        for c in d.get('compose') or []:
            for end in {c['from']['dynamic'], c['to']['dynamic']}:
                joins.setdefault(end, []).append(c)
    return {'owners': owners, 'joins': joins}


def _case(c: dict, names: dict, homes: dict, here: str, owners: dict) -> str:
    under = [f'[{names[o]}]({_section(o, homes, here)})' for o in owners.get(c['law'], [])]
    return (f'a case of `{c["law"]}` (' + (', '.join(under) if under else 'a law the atlas does not list') + f'): {_line(c["how"])}')


def _join(c: dict, names: dict, homes: dict, here: str, premises: dict) -> str:
    at = posixpath.dirname(here)

    def end(s):
        return f'[{names[s["dynamic"]]}]({_section(s["dynamic"], homes, here)})' + (f' (`{s["law"]}`)' if s['law'] else '')
    how = (f'proved by `{c["joint_law"]}`, whose statement relates both' if c['standing'] == 'proved'
           else 'stated in words where a theorem is at home, with no joint law in Lean' if c['standing'] == 'stated'
           else 'proposed in an AI reading of the chapter, with no joint law in Lean')
    prem = (' Premises: ' + ', '.join(_premise_link(p, premises, at) for p in c['premises']) + '.') if c['premises'] else ''
    kept = f' Exits kept: {_line(c["exits_kept"])}.' if c['exits_kept'] else ''
    role = c['from']['role'].rstrip('.')
    return (f'{end(c["from"])} → the {c["to"]["role"]} of {end(c["to"])}. What passes: {role}. How: {_line(c["map"]).rstrip(".")}. '
            f'Order {c["order_kept"]}.{prem}{kept} {how[0].upper() + how[1:]} ({_source(c["source"], at)}).')


def _entry(d: dict, names: dict, homes: dict, here: str, premises: dict | None = None, bound: dict | None = None,
           links: dict | None = None) -> list[str]:
    """One dynamic's section: its fields, its hypotheses quoted from its records, links to its sources."""
    at = posixpath.dirname(here)
    premises = premises or {}
    bound = (bound or {}).get(d['id'], [])
    links = links or {'owners': {}, 'joins': {}}

    def items(label, rows):
        return [f'- **{label}.**' + ('' if rows else ' None.')] + [f'  - {row}' for row in rows]

    standing = _standings(d['standing'], at) if d['standing'] else f'{d["standing_without_record"]}, with no record'
    exits = []
    for x in d['exits']:
        to = (f'[{names[x["to"]]}]({_section(x["to"], homes, here)})' if isinstance(x['to'], str)
              else 'a destination not yet read' if x['to'] is None else f'a state, in words: “{_line(x["to"])}”')
        if x.get('to_law'):
            to += f' (placed there by `{x["to_law"]}`)'
        law = f', by `{x["law"]}`' if x['law'] else ''
        recs = f' Records: {_standings(x["standing"], at)}.' if x['standing'] else ''
        drops = ''
        if 'drops' in x:
            drops = (' Drops ' + ', '.join(_premise_link(p, premises, at) for p in x['drops']) + '.' if x['drops']
                     else ' Drops no premise: it leaves within them.')
        seen = x['strength'] or f'{x["standing_without_law"]}, with no law'
        exits.append(f'To {to}: {seen}{law}. Its edge: {_line(x["edge"])}.{drops}{recs} ({_source(x["source"], at)})')
    transitions = []
    for t in d['transitions']:
        decls = ' (' + ', '.join(f'`{n}`' for n in t['declarations']) + ')' if t['declarations'] else ''
        recs = f' Records: {_standings(t["standing"], at)}.' if t['standing'] else ''
        between = ''
        if t.get('between'):
            ends = [f'[{names[v]}]({_section(v, homes, here)})' if isinstance(v, str) else '(an end not stated)' if v is None else _line(v)
                    for v in (t['between']['from'], t['between']['to'])]
            between = f' Between {ends[0]} and {ends[1]}.'
        transitions.append(f'{t["kind"]}: {_line(t["condition"])}{decls}.{between}{recs}')
    laws = None
    if d.get('premises') is not None:
        laws = [f'`{h["law"]}`: ' + (', '.join(_premise_link(p, premises, at) for p in h['takes']) or 'none listed')
                + ''.join(f'; {_case(c, names, homes, here, links["owners"])}' for c in h.get('case_of') or [])
                for h in d['premises']]
    return [f'<a id="{d["id"]}"></a>', f'### {_name(d)}', '',
            f'- **Mechanism.** {_line(d["mechanism"])}',
            f'- **Base.** {d["base"] or "none: no theorem states it yet"}',
            f'- **How far seen.** {standing}',
            '- **Declarations.** ' + (', '.join(f'`{n}`' for n in d['declarations']) or 'None.'),
            *items('Hypotheses, quoted from the records', [f'{_record(h["record"], at)}, hypothesis {h["index"]}: {_line(h["text"])}'
                                                          for h in d['hypotheses']]),
            *(([f'- **Premises, by law.** Every hypothesis its statement binds, and premises it takes another way: [how the lists are read]({_href(PREMISES_PAGE, at)}).']
               + [f'  - {row}' for row in laws] if laws else ['- **Premises, by law.** None.']) if laws is not None else []),
            f'- **Forbids.** {_line(d["forbids"]) if d["forbids"] else "Not stated."}',
            *(items('Joins', [_join(c, names, homes, here, premises) for c in links['joins'][d['id']]])
              if links['joins'].get(d['id']) else []),
            *items('Exits', exits),
            *items('Transitions', transitions),
            *items('Tests', [f'[{t["path"]}]({_href(t["path"], at)}): {t["thesis"]}, {t["state"]}' for t in d['tests']]),
            *(['- **Tests bound to it.** ' + ', '.join(f'[{b["test"]}]({_href(BINDINGS_PAGE + "#" + b["id"], at)})'
                                                    + (f' ({b["binding"]["marks"]})' if b['binding'] else ' (no result)') for b in bound)]
              if bound else []),
            *items('Open', [f'{_line(o)} ({_source(o["source"], at)})' for o in d['open']]),
            f'- **Beyond its couplings.** {_line(d["beyond"]) if d["beyond"] else "Not stated."}',
            '- **Sources.** ' + (', '.join(_source(s, at) for s in d['sources']) or 'None.'), '']


def page(atlas: dict) -> str:
    """ATLAS.md, the atlas's index: each family's table, its rows linking the sections on the family's page."""
    families, homes = atlas['vocabulary']['families'], _homes(atlas)
    listed = {f['id']: [d for d in atlas['dynamics'] if d['family'] == f['id']] for f in families}
    # The single page's headings: its title, then each family's, then each of its dynamics'.
    titles = ['The atlas of dynamics'] + [t for f in families for t in [f'{f["id"]}. {f["en"]}'] + [_name(d) for d in listed[f['id']]]]
    old, slugs, at = {}, _headings(titles), 1
    for f in families:
        at += 1
        for d in listed[f['id']]:
            old[d['id']] = slugs[at]
            at += 1
    taken = set(_headings(['The atlas of dynamics'] + [f'{f["id"]}. {f["en"]}' for f in families])) | {f'family-{f["id"].lower()}' for f in families}
    keep = {d['id']: _marks([d['id'], old[d['id']]], taken) for d in atlas['dynamics']}
    read = [f for f in families if any(d['family'] == f['id'] for d in atlas['dynamics'])
            and all('premises' in d for d in atlas['dynamics'] if d['family'] == f['id'])]
    unread = [f for f in families if f not in read]
    out = [GENERATED, '', '# The atlas of dynamics', '', _navigation(PAGE, atlas), '',
           *([f'**How far it is read** ([AA\'s plan §13]({_href(PLAN_NEXT)})). Every dynamic is listed with the records and '
              'declarations that state it. '
              + (f'Famil{"ies" if len(read) != 1 else "y"} {_and([f["id"] for f in read])} '
                 f'{"are" if len(read) != 1 else "is"} read for the premises their laws take, every hypothesis a law binds, and '
                 f'for where their exits lead: [the premise ledger]({_href(PREMISES_PAGE)}), [the terrain]({_href(TERRAIN)}). '
                 if read else '')
              + (f'{len(atlas["bindings"])} rows of the tests table are bound to the dynamics they bear on ([the bindings]({_href(BINDINGS_PAGE)})). '
                 if atlas.get('bindings') else '')
              + (f'{len(atlas["situations"])} situation{"s are" if len(atlas["situations"]) != 1 else " is"} written in the account\'s '
                 f'words ([the situations]({_href(SITUATIONS_PAGE)})). ' if atlas.get('situations') else '')
              + (f'The other {len(unread)} famil{"ies are" if len(unread) != 1 else "y is"} not yet read for premises or exits.' if unread and read else ''),
              '', f'![The terrain: the eight families and the recorded exits between them, drawn from the entries alone]({_href(TERRAIN_SVG)})', '']
             if atlas.get('premises') else []),
           _atlas_lead(ATLAS), '',
           f'{len(atlas["dynamics"])} dynamics, by family. It is a catalogue to look things up in, not to read through: each '
           "family has a page, which opens with its index, and an entry's section there holds the rest.", '',
           '| Family | Dynamics |', '|---|---:|']
    out += [f'| [{f["id"]}. {f["en"]}]({_href(family_path(f))}) | {atlas["counts"][f["id"]]} |' for f in families]
    for f in families:
        out += ['', f'<a id="family-{f["id"].lower()}"></a>', f'## {f["id"]}. {f["en"]}', '',
                f'[Its page]({_href(family_path(f))}), with each entry\'s section.', '']
        out += _family_table(listed[f['id']], homes, PAGE, keep) if listed[f['id']] else ['No dynamic listed yet.']
    return _finish(out + ['', _navigation(PAGE, atlas)])


def family_page(atlas: dict, family: dict) -> str:
    """A family's page: its index, then each of its dynamics' sections."""
    families, homes = atlas['vocabulary']['families'], _homes(atlas)
    here = family_path(family)
    names = {d['id']: _name(d) for d in atlas['dynamics']}
    listed = [d for d in atlas['dynamics'] if d['family'] == family['id']]
    others = ', '.join(f'**{f["id"]}**' if f['id'] == family['id'] else f'[{f["id"]}]({_href(family_path(f), FAMILY_PAGES)})' for f in families)
    nav = f'[The atlas]({_href(PAGE, FAMILY_PAGES)}), with every family\'s index. Families: {others}.'
    out = [GENERATED, '', f'# The atlas of dynamics: {family["id"]}. {family["en"]}', '', _navigation(here, atlas), '', nav, '',
           _atlas_lead(FAMILY_PAGES), '']
    if not listed:
        return _finish(out + ['No dynamic listed yet.', '', nav])
    out += [f'{len(listed)} of the atlas\'s {len(atlas["dynamics"])} dynamics. A catalogue to look things up in, not to read '
            'through: the table is its index, and an entry\'s section holds the rest.', '']
    out += _family_table(listed, homes, here) + ['']
    premises = {p['id']: p for p in atlas.get('premises', [])}
    bound = {}
    for b in atlas.get('bindings', []):
        for x in b['bears_on']:
            bound.setdefault(x['dynamic'], []).append(b)
    links = _links(atlas)
    for d in listed:
        out += _entry(d, names, homes, here, premises, bound, links)
    return _finish(out + ['', nav])


# --- the crosswalk: an index, and a page for each folder and domain ------------------------------------------------

def _adds(label: str, value) -> list[str]:
    return [f'  - {label}: {_line(value)}'] if value else []


ROLE_WORD = {'carries': 'Read against', 'neighbour': 'Beside it, not carrying it:', 'limit': 'Where the account stops:'}
AGREEMENT_WORD = {'law': 'a law', 'thesis-or-method': 'a thesis or method', 'reading': 'a reading'}


# Where CROSSWALK.md's start-here table goes: connection_map.py, which counts the map's threads, writes it there when the
# render runs it after this page (a comment, so a page rendered without the map shows nothing).
START_HERE = '<!-- start here: the thickest threads, written by connection_map.py -->'


def group_path(group: dict) -> str:
    """A folder's or domain's page: crosswalk/<its id without cxg->.md."""
    return f'{CROSSWALK_PAGES}/{group["id"].removeprefix("cxg-")}.md'


ENTRY_ID = re.compile(r'(?<![\w#/\[-])(cx-[a-z0-9]+(?:-[a-z0-9]+)*)(?![\w-])')


def _linked(line: str, homes: dict, here: str) -> str:
    """A line whose mentions of other correspondences, by id, link their sections, on whichever page they are."""
    def link(m):
        i = m.group(1)
        if i not in homes:
            return i
        return f'[{i}](#{i})' if homes[i] == here else f'[{i}]({_href(homes[i] + "#" + i, posixpath.dirname(here))})'
    return ENTRY_ID.sub(link, line)


def _correspondence_lines(e: dict, at: str = ATLAS, homes: dict | None = None, here: str | None = None) -> list[str]:
    """One correspondence: the source's own sense first, then what became of it. With `homes` (each correspondence's
    page) and `here` (this page), a mention of another correspondence by its id links it."""
    source = e['source']
    work = f'[{source["work"]}]({_href(source["work"], at)})' if source['basis'] == 'read-in-repo' else source['work']
    where = f'{work}, {source["locator"]}' + ('' if source['basis'] == 'read-in-repo' else ' (from the AI\'s knowledge, not checked against a text)')
    relation = f', {e["relation"]}' if e['relation'] else ''
    if e['agreement_of']:
        relation += f' of {AGREEMENT_WORD[e["agreement_of"]]}'
    lines = [f'<a id="{e["id"]}"></a>', f'- **{e["name"]["en"]}** ({e["carried"]}{relation}). {where}.',
             f'  - Its own sense: {_line(e["sense"])}' + (f' 「{e["quote"]}」' if e['quote'] else ''),
             f'  - Reading [AI reading]: {_line(e["reading"])}']
    for t in e['targets']:
        cite = []
        if t.get('anchor'):
            cite.append(_source(t['anchor'], at) if '#' in t['anchor'] else f'[{posixpath.basename(t["anchor"])}]({_href(t["anchor"], at)})')
        if t.get('record'):
            cite.append(f'{_record(t["record"], at)} {t["standing"]["status"]} ({t["standing"]["kind"]})')
        part = f' ({t["part"]})' if t.get('part') else ''
        lines.append(f'  - {ROLE_WORD[t["role"]]} {"; ".join(cite)}{part}: {_line(t["says"])}')
    lines += _adds('The account adds', e['account_adds']) + _adds('The source adds', e['source_adds'])
    if e['absence']:
        lines.append('  - Searched: ' + '; '.join(map(str, e['absence'].get('searched', [])))
                     + ('. Read: ' + '; '.join(map(str, e['absence']['read'])) if e['absence'].get('read') else ''))
    if homes is not None:
        lines = lines[:1] + [_linked(line, homes, here) for line in lines[1:]]
    return lines


def _checks_lines(checks: dict | None) -> list[str]:
    """What the critics found, said before the counts so that no count is read without it."""
    if not checks:
        return []
    second, first = checks['second_critic'], checks['first_critic']
    est, v = second['estimate_percent'], second['verdicts']
    return [f'**How far to trust it.** Each item had a mapper, a reviser, a checker told to refute, a repair after a critic and a '
            f'comparison across items. A second critic then read {second["sampled"]} entries drawn at random, up to {second["per_stratum"]} '
            f'from each kind of verdict, against both sides: {v["holds"]} held, {v["label"]} had a label or a target\'s role wrong '
            f'and {v["fails"]} had a wrong reading. Weighted by how many entries each kind of verdict holds, that estimates {est["holds"]}% '
            f'holding, {est["label"]}% with a label or role wrong and {est["fails"]}% with a wrong reading over all {second["entries"]}; its fixes are '
            f'applied, and the other entries were not read again. The first critic\'s sample ({first["sampled"]}) was aimed at '
            f'suspects and gives no rate. Where the source is not stored here, a critic\'s check was memory against memory.', '']


def _crosswalk_lead(atlas: dict, at: str) -> list[str]:
    """What the crosswalk is and is not, the words its entries use and how far to trust it: on the index and on every
    page, since a reader may come to a folder's page first."""
    vocabulary = atlas['vocabulary']
    return ['Each earlier theory folder and each domain of thought: what it claimed in its own terms, and what became of that '
            'in the live account. The evidence layer, not for reading through. It creates no result, and every entry is an AI '
            'reading with no person\'s behind it. A shared word is not a correspondence, structural agreement is not agreement '
            'in meaning, and no tradition is spoken for. Not carried is an outcome, not a defect. Where a source is not stored '
            'here, what is said of it comes from the AI\'s knowledge and has not been checked against a text.', '',
            '**What became of it:** ' + '; '.join(f'*{c["en"]}*' for c in vocabulary['carried']) + '. *Fresh-reading* means the account '
            'does not state the connection and a reader proposes it here. **Relations**, from '
            f'[06]({_href("theories/becoming/chapters/06-CLASSICAL-TEXTS.md#three-relations", at)}): '
            + '; '.join(f'*{r["en"]}*' for r in vocabulary['relations'])
            + '. Agreement says what it is agreement with: a checked **law**, a **thesis or method**, or a **reading**, where the join '
            'is a reader\'s or descends from the source. Only what a target carries counts as a connection.', '',
            *_checks_lines(atlas.get('crosswalk_checks'))]


def _no_relation(entries: list, totals_r: list) -> str:
    """The sentence under the relations' sums: the entries with none, by what became of them, and the entries only in
    history that have one, which the map does not count."""
    none = Counter(e['carried'] for e in entries if not e.get('relation'))
    kept = Counter(e['carried'] for e in entries if e.get('relation') and e['carried'] in ABSENT)
    parts = ', '.join(f'{n} {k}' for k, n in sorted(none.items(), key=lambda kv: -kv[1]))
    out = f'The relations sum to {sum(totals_r):,}: the other {sum(none.values())} entries have none ({parts}).'
    if kept:
        n = sum(kept.values())
        out += (f' {n} {" and ".join(sorted(kept))} {"entry" if n == 1 else "entries"} {"has" if n == 1 else "have"} one, which '
                f'[the connection map]({_href(ATLAS + "/map.html")}) draws as a short end, not a thread, though its group counts include '
                f'{"it" if n == 1 else "them"}.')
    return out


def crosswalk_page(atlas: dict) -> str:
    """CROSSWALK.md, the crosswalk's index: each folder's and domain's counts, linking its page. Each row holds the anchor
    its group's section had when the crosswalk was one page, so that a link made then still lands."""
    vocabulary, groups, entries = atlas['vocabulary'], atlas['correspondence_groups'], atlas['correspondences']
    carried = [c['en'] for c in vocabulary['carried']]
    relations = [r['en'] for r in vocabulary['relations']]
    agreements = [a['en'] for a in vocabulary['agreement_of']]
    # The single page's headings: its title, then each group's; and each entry's id, now on its group's page.
    old = dict(zip((g['id'] for g in groups), _headings(['The crosswalk'] + [g['title']['en'] for g in groups])[1:]))
    taken = set(_headings(['The crosswalk']))
    totals_c = [sum(g['by_carried'][c] for g in groups) for c in carried]
    totals_r = [sum(g['by_relation'][r] for g in groups) for r in relations]
    out = [GENERATED, '', '# The crosswalk', '', _navigation(CROSSWALK, atlas), '',
           f'All {len(entries)} entries, in {len(groups)} groups, summed; every entry is an AI reading, no person\'s, and the [table below](#the-groups) gives each group:', '',
           '| What became of it | ' + ' | '.join(carried) + ' |', '|---|' + '---:|' * len(carried), '| Entries | ' + ' | '.join(map(str, totals_c)) + ' |', '',
           '| Relation | ' + ' | '.join(relations) + ' |', '|---|' + '---:|' * len(relations), '| Entries | ' + ' | '.join(map(str, totals_r)) + ' |', '',
           _no_relation(entries, totals_r), '',
           START_HERE, '',
           f'![How the earlier folders and the domains of thought meet the live account]({_href(OVERVIEW)})', '',
           '*Drawn by connection_map.py from the crosswalk’s claims, on the pages its table links: a row per folder or domain, a column per part of the account '
           'its claims are read against, and in each cell up to two dots per relation, filled for what the account takes up and, below it, a ring for what is proposed here; '
           'every dot is an AI reading, no person’s. To explore the same data, '
           f'open [the connection map]({_href(ATLAS + "/map.html")}) on the reader’s site, once it is published, or from a clone; GitHub shows it only as source.*', '',
           *_crosswalk_lead(atlas, ATLAS),
           '<a id="the-groups"></a>', '', f'{len(entries)} entries in {len(groups)} groups, each on its own page:', '',
           '| Group | Entries | ' + ' | '.join(carried) + ' | ' + ' | '.join(relations) + ' | ' + ' | '.join(f'agreement of {a}' for a in agreements) + ' |',
           '|---|---:|' + '---:|' * (len(carried) + len(relations) + len(agreements))]
    for g in groups:
        marks = _marks([g['id'], old[g['id']]] + [e['id'] for e in entries if e['group'] == g['id']], taken)
        out.append(f'| {marks}[{_cell(g["title"]["en"])}]({_href(group_path(g))}) | {g["entries"]} | '
                   + ' | '.join(str(g['by_carried'][c]) for c in carried) + ' | '
                   + ' | '.join(str(g['by_relation'][r]) for r in relations) + ' | '
                   + ' | '.join(str(g['by_agreement_of'][a]) for a in agreements) + ' |')
    out += ['', 'A link to a correspondence made while the crosswalk was one page lands on its group\'s row here; on the group\'s '
            'page the correspondence has the same id (`crosswalk/<group>.md#<id>`).']
    return _finish(out + ['', _navigation(CROSSWALK, atlas)])


def group_page(atlas: dict, g: dict) -> str:
    """A folder's or domain's page: what was read, what is present and absent, its entries and what was not mapped."""
    here = group_path(g)
    back = f'[The crosswalk]({_href(CROSSWALK, CROSSWALK_PAGES)}), with every folder and domain and their counts.'
    folder = (f' The folder itself: [its README]({_href(FOLDERS.rpartition("/")[0] + "/" + g["id"].removeprefix("cxg-") + "/README.md", CROSSWALK_PAGES)}).'
              if g['domain'] == EARLIER else '')
    homes = {e['id']: group_path(next(x for x in atlas['correspondence_groups'] if x['id'] == e['group'])) for e in atlas['correspondences']}

    def linked(line: str) -> str:
        return _linked(line, homes, here)

    out = [GENERATED, '', f'# The crosswalk: {g["title"]["en"]}', '', _navigation(here, atlas), '', back + folder, '',
           *_crosswalk_lead(atlas, CROSSWALK_PAGES), '## Summary and what was read', '', linked(_line(g['summary'])), '',
           linked(f'*Kind: {g["kind"]}. Read in full: {"; ".join(g["read"]) or "none listed"}. Skimmed: {"; ".join(g["skimmed"]) or "none listed"}. '
                  f'Searched only: {"; ".join(g["searched"]) or "none listed"}.*'), '']
    if g['coverage']:
        out += ['**Present in the account:**', '']
        for item in g['coverage'].get('present', []):
            where = item.get('where') or ''
            link = f' ([{posixpath.basename(where.partition("#")[0])}]({_href(where, CROSSWALK_PAGES)}))' if where and (ROOT / where.partition('#')[0]).exists() else ''
            out.append(linked(f'- {item.get("what", "")}{link}: {item.get("extent", "")}'))
        out += ['', '**Absent:**', '']
        out += [linked(f'- {_line(item)}') for item in g['coverage'].get('absent', [])] or ['- Nothing listed.']
        out.append('')
    listed = [e for e in atlas['correspondences'] if e['group'] == g['id']]
    out += ['## Its entries', '', f'{len(listed)} entries.', '']
    for e in listed:
        out += _correspondence_lines(e, CROSSWALK_PAGES, homes, here)
    if g['not_mapped']:
        out += ['', '**Found and not mapped:**', '']
        out += [linked(f'- {_line(item)}' + (f' ({item["why"]})' if item.get('why') else '')) for item in g['not_mapped']]
    return _finish(out + ['', back])


# --- the crosswalk's Chinese front ------------------------------------------------------------------------------------

CROSSWALK_ZH = ATLAS + '/CROSSWALK.zh.md'
ZH_CARRIED = {'carried': '承继', 'carried-in-part': '部分承继', 'changed': '改变', 'fresh-reading': '此处提出的新读法',
              'history-only': '仅存于历史', 'not-carried': '未承继'}
# Each group's name in Chinese (AI translation, as CROSSWALK.zh says), for CROSSWALK.zh's table and the Chinese
# connections picture: the folders keep the Chinese their titles carry; a group with no name here shows its English, marked.
GROUP_ZH = {
    'cxg-alignment-selection-on-cognition': '对齐即对认知的选择（心中的摩洛克）',
    'cxg-architecture-for-a-living-earth': '为一个活的地球的建筑',
    'cxg-context-as-existence-runtimes': '语境即存在：上下文运行时',
    'cxg-drives-narrative-attractors-and-mind': '驱力、叙事吸引子与心智的建构',
    'cxg-evolving-community-swarms': '演化的社群集群',
    'cxg-human-solutions-museum': '人类解决问题的方法博物馆',
    'cxg-jian-and-wenyan-as-formal-language': '間与文言作为形式语言',
    'cxg-keep-the-possibility-space-open': '保持可能性空间敞开（护开不闭）',
    'cxg-memories-and-working-style': '记忆与工作方式',
    'cxg-meta-attractor': '元吸引子',
    'cxg-relational-self-and-datong': '关系性的自我与大同',
    'cxg-selfishness-spiral-and-narrative-value-frames': '自私螺旋与叙事价值框架',
    'cxg-spirit-space-token-and-yi-substrate': 'Spirit、Token、Space 与易的基底',
    'cxg-the-fork-and-cooperative-infrastructure': '合作的丰裕与自由建造的世界（分岔）',
    'cxg-wamotopia-and-the-wamo-protocol': 'Wamotopia 与 Wamo 协议（瓦猫）',
    'cxg-zhishan-intelligence-must-be-good': '智善：智能必须向善',
    'cxg-chinese-classical': '中国古典思想：现有映射尚未到达之处',
    'cxg-buddhist': '佛教思想，就本论已到达之处而言',
    'cxg-other-indian': '佛教以外的印度思想',
    'cxg-greek-roman': '希腊与罗马思想',
    'cxg-abrahamic-islamic': '亚伯拉罕诸教与伊斯兰思想',
    'cxg-indigenous-african': '原住民与非洲思想',
    'cxg-modern-philosophy': '现代哲学',
    'cxg-systems-cybernetics': '系统思维与控制论',
    'cxg-dynamics-physics-complexity': '动力系统、物理与复杂性',
    'cxg-ecology-evolution': '生态与演化',
    'cxg-economics-politics-sociology': '经济、政治与社会学',
    'cxg-psychology-alignment-logic': '心理学、AI 对齐与逻辑'}
# The two domains a Chinese reader reaches first, each with what its group holds and does not.
ZH_DOMAINS = (('cxg-chinese-classical', '中国古典思想',
               '本组只收现有映射尚未到达之处；中国古典的大部分在[第六章](../../chapters/06-CLASSICAL-TEXTS.md)，那里有段落的映射与一部图谱的条目'),
              ('cxg-buddhist', '佛教思想', '就本论已经到达之处而言；佛教论书的读法也在[第六章](../../chapters/06-CLASSICAL-TEXTS.md)'))


def _no_relation_zh(entries: list, relation: dict) -> str:
    """The Chinese of _no_relation, from the same counts."""
    none = Counter(e['carried'] for e in entries if not e.get('relation'))
    kept = Counter(e['carried'] for e in entries if e.get('relation') and e['carried'] in ABSENT)
    parts = '，'.join(f'{ZH_CARRIED.get(k, k)} {n}' for k, n in sorted(none.items(), key=lambda kv: -kv[1]))
    out = f'各关系相加为 {sum(n for _, n in relation.values()):,}，其余 {sum(none.values())} 条没有关系（{parts}）。'
    if kept:
        out += (f'另有 {sum(kept.values())} 条{"、".join(ZH_CARRIED.get(k, k) for k in sorted(kept))}者有关系，[连接图](map.html)把它们画作一个短端而非一条线，'
                f'但其分组计数包含它们。')
    return out


def _groups_zh(groups: list, vocabulary: dict) -> list:
    """CROSSWALK.zh's table: each group by its Chinese name, linking its English page, with its entries counted by what
    became of them and by relation, as CROSSWALK.md's table counts them."""
    carried = [c['en'] for c in vocabulary['carried']]
    relations = [(r['en'], r.get('zh') or r['en']) for r in vocabulary['relations']]
    out = ['| 组 | 类 | 条数 | ' + ' | '.join(ZH_CARRIED.get(c, c) for c in carried) + ' | ' + ' | '.join(zh for _, zh in relations) + ' |',
           '|---|---|---:|' + '---:|' * (len(carried) + len(relations))]
    for g in groups:
        name = GROUP_ZH.get(g['id']) or g['title']['en'] + '（英文）'
        out.append(f'| [{_cell(name)}]({_href(group_path(g), ATLAS)}) | {"文件夹" if g["domain"] == EARLIER else "领域"} | {g["entries"]} | '
                   + ' | '.join(str(g['by_carried'][c]) for c in carried) + ' | '
                   + ' | '.join(str(g['by_relation'][r]) for r, _ in relations) + ' |')
    return out


def crosswalk_zh_page(atlas: dict) -> str:
    """CROSSWALK.zh.md: the crosswalk's front for a Chinese reader: what it is and is not, how far to trust it, its
    counts, the picture, and the two domains nearest the Chinese texts, the entries themselves on the English pages."""
    from tools.research import zh_fronts
    groups, entries, vocabulary = atlas['correspondence_groups'], atlas['correspondences'], atlas['vocabulary']
    carried = {c['en']: sum(g['by_carried'].get(c['en'], 0) for g in groups) for c in vocabulary['carried']}
    relation = {r['en']: (r.get('zh') or r['en'], sum(g['by_relation'].get(r['en'], 0) for g in groups)) for r in vocabulary['relations']}
    folders = sum(g['domain'] == EARLIER for g in groups)
    of = {a['en']: sum(g['by_agreement_of'].get(a['en'], 0) for g in groups) for a in vocabulary['agreement_of']}
    agreement = (f'（其中与已检查之律相合 {of.get("law", 0):,}，与论题或方法相合 {of.get("thesis-or-method", 0):,}，与一种读法相合 '
                 f'{of.get("reading", 0):,}；这里的相合比[第六章](../../chapters/06-CLASSICAL-TEXTS.md#three-relations)所定的宽，第六章的相合只指与已检查之律结构相同）')
    second = ((atlas.get('crosswalk_checks') or {}).get('second_critic') or {})
    first = ((atlas.get('crosswalk_checks') or {}).get('first_critic') or {})
    est = second.get('estimate_percent')
    trust = (f'**多可信。** 每一项都经过一位映射者、一位修订者、一位受命去反驳的检查者、一次批评之后的修补，以及跨项的比较。之后，第二位批评者从每一类结局中随机抽取'
             f'至多 {second["per_stratum"]} 条，共 {second["sampled"]} 条，对照两边去读：{second["verdicts"]["holds"]} 条成立，'
             f'{second["verdicts"]["label"]} 条的标签或目标角色有误，{second["verdicts"]["fails"]} 条的读法有误。按各类结局的条数加权，估计全部 '
             f'{second["entries"]:,} 条中约 {est["holds"]:g}% 成立，约 {est["label"]:g}% 的标签或角色有误，约 {est["fails"]:g}% 的读法有误；'
             f'这些修正已经做了，其余各条没有再读。第一位批评者的样本（{first.get("sampled", 0)} 条）专挑可疑者，不给出比率。'
             '来源不存于此处时，批评者的核对是以记忆对记忆。') if est else ''
    by = {g['id']: g for g in groups}
    domains = []
    for gid, name, note in ZH_DOMAINS:
        if gid in by:
            domains.append(f'- **{name}**（{by[gid]["entries"]} 条，[英文页]({_href(group_path(by[gid]), ATLAS)})）：{note}。')
    out = [GENERATED, '', '# 对照表：早先的理论文件夹与各思想领域', '', zh_fronts.nav_line(CROSSWALK_ZH), '', '{{time}}', '',
           '*由 AI 依[英文的对照表](CROSSWALK.md)写成，尚无经人审查的记录；义以英文版为准。各组的条目在英文页上。*', '',
           f'![早先的文件夹与各思想领域怎样与现行的本论相接]({_href(OVERVIEW_ZH, ATLAS)})', '',
           f'*由 connection_map.py 依同一份数据画出，图中文字为 AI 所译（[英文图]({_href(OVERVIEW, ATLAS)})）：每一行是一个文件夹或领域，每一列是它的主张所对照的本论那一部分；每格中每种关系至多两个点：本论论及者为实心点，此处提出者为其下的空心圆环，按关系着色；每一个点都是 AI 的读法，没有人的。要浏览同一份数据，可打开[连接图](map.html)：读者网站发布之后可在网站上打开，也可在本地克隆中打开；GitHub 只显示它的源码。*', '',
           '**它是什么。** 每一个早先的理论文件夹与每一个思想领域：它以自己的话主张了什么，在现行的本论中又成了什么。它是证据层，不是用来通读的。它不产生任何结果；'
           '每一条都是 AI 的读法，没有人的。共用一个词不是对应，结构上的相合不是意义上的相合，它也不代表任何传统发言。未承继是一种结局，不是缺陷。'
           '来源不存于此处时，所说的出自 AI 的知识，没有对照原文核对过。', '']
    if trust:
        out += [trust, '']
    out += [f'**计数。** {len(entries):,} 条主张，来自 {folders} 个早先的理论文件夹与 {len(groups) - folders} 个思想领域：'
            + '，'.join(f'{ZH_CARRIED.get(k, k)} {n:,}' for k, n in carried.items()) + '。按关系：'
            + '，'.join(f'{zh} {n:,}' + (agreement if key == 'agreement' else '') for key, (zh, n) in relation.items()) + '。' + _no_relation_zh(entries, relation) + '只有一个目标所承载的才算作连接。', '',
            '**离中文文本最近的两个领域。**', '', *domains, '',
            f'**全部 {len(groups)} 组**，每组一页，都在英文页上：它以自己的话主张了什么，在现行的本论中成了什么，以及每一条的目标与各目标看到的程度。'
            f'下表列出每一组的条数，按结局与按关系各计（组名为 AI 所译，有的有所缩短；[英文索引](CROSSWALK.md#the-groups)有这些计数，并把相合再分为与已检查之律、与论题或方法、与一种读法相合三种）：', '',
            *_groups_zh(groups, vocabulary), '']
    body = _finish(out)
    return body.replace('{{time}}', f'*约 {zh_fronts.settle(lambda t: zh_fronts.zh_time(body.replace("{{time}}", f"*约 {t}读完。*")))}读完。*')


def folders_page(atlas: dict) -> str:
    """theories/README.md: the earlier folders, each with its kind and what became of its claims in the crosswalk."""
    vocabulary, groups = atlas['vocabulary'], atlas['correspondence_groups']
    carried = [c['en'] for c in vocabulary['carried']]
    folders = [g for g in groups if g['domain'] == EARLIER]
    est = ((atlas.get('crosswalk_checks') or {}).get('second_critic') or {}).get('estimate_percent')
    critic = (atlas.get('crosswalk_checks') or {}).get('second_critic') or {}
    trust = (f' A critic, the second of two, read {critic["sampled"]} entries drawn at random, up to {critic["per_stratum"]} from each kind of '
             f'verdict, against both sides; weighted by how many entries each kind of verdict holds, that estimates {est["holds"]}% holding, '
             f'{est["label"]}% with a label or a target\'s role wrong and {est["fails"]}% with a wrong reading over all '
             f'{critic["entries"]} entries, folders and domains together; its fixes are applied, and the other entries were not '
             f'read again.') if est else ''
    out = [GENERATED, '', '# The earlier theory folders', '', navigation.nav_line(FOLDERS), '',
           FOLDERS_LEAD.replace('{n}', NUMBER_WORDS.get(len(folders), str(len(folders)))) + trust, '',
           '| Folder | Kind | Entries | ' + ' | '.join(carried) + ' | In the crosswalk |',
           '|---|---|---:|' + '---:|' * len(carried) + '---|']
    for g in folders:
        slug = g['id'].removeprefix('cxg-')
        out.append(f'| [{_cell(g["title"]["en"])}]({slug}/README.md) | {g["kind"]} | {g["entries"]} | '
                   + ' | '.join(str(g['by_carried'][c]) for c in carried)
                   + f' | [what became of it]({_href(group_path(g), posixpath.dirname(FOLDERS))}) |')
    out += ['', FOLDERS_FOOT]
    return '\n'.join(out).rstrip('\n') + '\n'


# --- files ---------------------------------------------------------------------------------------------------------

def inputs() -> list[Path]:
    """The curated files a render reads, for research.py's input snapshot (the records are snapshotted already)."""
    files = {ROOT / VOCABULARY} | {ROOT / ENTRIES / f'{k}.json' for k in KINDS
                                   if k not in OPTIONAL_KINDS or (ROOT / ENTRIES / f'{k}.json').is_file()}
    if (ROOT / CHECKS).is_file():
        files.add(ROOT / CHECKS)
    if (ROOT / ENTRIES / 'bindings.json').is_file():
        files.add(ROOT / TESTS)
    return sorted(files | set((ROOT / ENTRIES).glob('*.json')))


def _checks() -> tuple[dict | None, list[str]]:
    """The crosswalk's checks, where written: the second critic's verdicts must count its sample, and its estimate
    must be given for each verdict."""
    path = ROOT / CHECKS
    if not path.is_file():
        return None, []
    try:
        checks = json.loads(path.read_text(encoding='utf-8'))
        second = checks['second_critic']
        if sum(second['verdicts'].values()) != second['sampled'] or set(second['estimate_percent']) != set(second['verdicts']):
            return None, [f'{CHECKS}: the verdicts do not count the sample, or the estimate leaves one out']
        return checks, []
    except (ValueError, KeyError, TypeError, AttributeError) as exc:
        return None, [f'{CHECKS}: {exc!r}']


def load() -> tuple[dict, dict, list[str]]:
    """The vocabulary and the entries by kind, read from the atlas's own files, and an error for each that is missing
    or does not parse."""
    vocabulary, entries, errors = {}, {}, []
    for rel, kind in [(VOCABULARY, None)] + [(f'{ENTRIES}/{k}.json', k) for k in KINDS]:
        if kind in OPTIONAL_KINDS and not (ROOT / rel).is_file():
            entries[kind] = []
            continue
        try:
            data = json.loads((ROOT / rel).read_text())
        except (OSError, ValueError) as e:
            errors.append(f'{rel}: {e}')
            continue
        if kind is None:
            vocabulary = data
        else:
            entries[kind] = data
    return vocabulary, entries, errors


def _mermaid(text: str) -> str:
    return re.sub(r'["<>{}|\[\]#;`]', "'", ' '.join(text.split()))


def _clip(text: str, n: int) -> str:
    """At most n characters, cut at a word and with no parenthesis left open."""
    if len(text) <= n:
        return text
    cut = text[:n].rsplit(' ', 1)[0]
    if cut.count('(') > cut.count(')'):
        cut = cut[:cut.rfind('(')].rstrip()
    return cut.rstrip(',;:') + '…'


def premise_pages(atlas: dict) -> dict:
    """PREMISES.md and premises/<f>.md: the premise ledger, by kind: each premise, its statement and Lean, where it holds
    and fails, the laws that take it and the exits that drop it, all read off the entries. The ledger page holds the
    lead, the seeds and the premises taken across families; a family's page, the premises only its laws take."""
    homes = _homes(atlas)
    names = {d['id']: _name(d) for d in atlas['dynamics']}
    taken, dropped = {}, {}
    for d in atlas['dynamics']:
        for h in d.get('premises') or []:
            for p in h['takes']:
                taken.setdefault(p, set()).add(d['id'])
        for i, x in enumerate(d['exits'], 1):
            for p in x.get('drops') or []:
                dropped.setdefault(p, []).append((d['id'], i))
    read = [d for d in atlas['dynamics'] if 'premises' in d]
    by_family = {}
    for d in read:
        by_family.setdefault(d['family'], 0)
        by_family[d['family']] += 1

    def dyn(i, here):
        return f'[{_cell(names[i])}]({_section(i, homes, here)})'

    def tables(held_ids, here):
        rows = []
        for kind in [k['en'] for k in atlas['vocabulary'].get('premise_kinds', [])]:
            held = [p for p in atlas.get('premises', []) if p['kind'] == kind and p['id'] in held_ids]
            if not held:
                continue
            rows += [f'## {kind[0].upper() + kind[1:]}', '', '| Premise | Statement | Lean | Holds in | Fails in | Taken by | Dropped by exits of | Home |',
                     '|---|---|---|---|---|---|---|---|']
            for p in held:
                statement = _cell(_line(p['statement'])) if p['statement'] else '*withheld: its home is being re-said*'
                lean = ', '.join(f'`{n}`' for n in p['lean']) or '—'
                holds = ', '.join(f'`{x}`' for x in p['holds_in']) or '—'
                fails = ', '.join(f'`{x}`' for x in p['fails_in']) or '—'
                by = ', '.join(dyn(i, here) for i in sorted(taken.get(p['id'], ()))) or ('every law read that runs on steps, not listed one by one'
                                                                                       if p['id'] == 'card-discrete-steps' else '—')
                drops = ', '.join(f'{dyn(i, here)} (exit {n})' for i, n in dropped.get(p['id'], [])) or '—'
                rows.append(f'| <a id="{p["id"]}"></a>**{_cell(p["name"]["en"])}** `{p["id"]}` | {statement} | {lean} | {holds} | {fails} | '
                            f'{by} | {drops} | {_source(p["home"], posixpath.dirname(here))} |')
            rows.append('')
        return rows

    on = {}
    for p in atlas.get('premises', []):
        on.setdefault(p.get('page', PREMISES_PAGE), set()).add(p['id'])
    families = {f['id']: f for f in atlas['vocabulary']['families']}
    own = sorted((page, ids) for page, ids in on.items() if page != PREMISES_PAGE)

    out = [GENERATED, '', '# The premise ledger', '', _navigation(PREMISES_PAGE, atlas), '',
           '*AI-written, from the entries (PLAN §13, step 2). A premise here is a hypothesis a law takes, a commitment the '
           'representation makes, or a premise of dynamics, correspondence, ethics or practice that 08 §4 lists, with the Lean that states it, where '
           'it is shown holding and failing, the dynamics whose laws take it and the exits that leave by dropping it. Every list '
           'is read off the entries at each render; none is typed. A premise is no result and the ledger proves nothing; whether '
           'one holds of an actual system is never established here.*', '',
           'How the lists are read. **For every family read, a law\'s list names every hypothesis its Lean statement binds:** '
           'each binder whose type is a proposition, explicit, implicit or an instance, before the colon or a leading hypothesis '
           'after it, mapped to the premise it states. For families C and D, on 10 November 2026, a script read them off the '
           'elaborated statements of the 344 laws in the Becoming core, the extractors read them off the source for the 40 in '
           f'the periphery, and a checker set to refute read every mapping ([their mapping]({_href(STEP2B)})). For families '
           'A, B, E, F, G and H, on 11 November, a script read them off the elaborated statements of 1,504 laws in the core, '
           'the extractors read them off the source for the 151 in the periphery, and a checker per share, set to refute, read '
           'in full every mapping to a premise new to the ledger and every one that departed from a script\'s guess, and sampled '
           f'the rest ([their mapping]({_href(SIX)})). A list also names '
           'premises a law takes another way, as the extractors, checkers and readers found them: definitions its statement is '
           'made through (the pool of readers, the rule after shaping, selection on listed counts; not every such definition is '
           'listed), commitments of the representation (natural-number amounts, requirements as thresholds, pointwise '
           'statements), premises a law holds '
           'by its form (Unread where nothing beyond the share is read; Accrues where the course\'s loss grows by one a step by '
           'its definition; the in-sync start where the course starts at the rule read from its counts), and premises taken '
           'through data, not through a proposition: decided, through binders of type Decidable, DecidableEq, DecidablePred or '
           'DecidableRel, instances or explicit (read off the elaborated statements for the six families\' core laws; a binder '
           'stating P ∨ ¬ P maps to decided as a proposition); a supplied law of exchange; and others present in every count of carriers and others, a field of '
           '`CarrierCounts`, on the 54 laws whose statements are on such counts (found by a script reading the statements\' '
           'constants, 51, and those of the definitions they name, 3 more on groups through `RuleShaping.Grouped`). So '
           '\u201cnone listed\u201d says the statement '
           'binds no hypothesis and none of the others was found; still read the law\'s statement before applying it. One '
           'proposition (the same definition, its parameters in the same roles) is one premise, whether or not a law passes it '
           'to another, with one pair kept as two because existing premises keep their ids: a positive mass under the first '
           'hypothesis\'s weight, under a likelihood (`lumpedseeking-weighs`) and under the seeking weight '
           '(`expectedfreeenergyreals-weighs`); one name with two senses (ReadsShare on the rule and on '
           'the reading) is two. A census of what stands (`Web.StandingCensus`), embodiment of what arises '
           '(`World.ArisingEmbodied`), and enclosure around a family (`Flow.Around`) or around what stands (`Flow.AroundStanding`) '
           'are premises of their own: K3\'s coverage counts them under its census, embodiment and enclosure, but each states '
           'another proposition in the Lean. '
           'Where two shares named one proposition twice, or one law\'s binder twice, one id is kept (the pass\'s README lists '
           'the merges). The ledger is not uniform in two respects: one proposition stated at one step and at every step of a '
           'stretch is one premise in some places (as `runaway-supported` already was) and two in others, and a bound with the '
           'same symbols in two modules is one premise in some places and two in others. Discrete steps is taken by every law read that runs on steps (a course, a run or an orbit) and is '
           'listed on none; laws with no step index (for example `Diagonal.gap_unsaid` and `claims_incomplete`, the fixed-point laws '
           'of reflexive prediction, the free-energy minimizer, and laws on the rule read at one share such as '
           '`DrawnShaping.critical_iff`) do not take it. Natural-number amounts is listed on every law taking Accrues (at least one '
           'a step) and where a reader found a statement turning on the least unit. An exit drops the premise its law shows failing '
           'as the course leaves; where its law reads beyond the share, it drops Unread. Where an exit drops several, its law may '
           'show only that not all of them hold, not which fails (`Web.consumed_continues_transformed`, `rise_from_rest_or_open`). The joined laws of the lock it leaves hold '
           'Unread by their form, the loss there unread, and list it (`ClosedCapture.lock_outlives_loss`, `lock_line`), as '
           '`ChoiceCountCapture.counted_outlives_loss` does, whose lock no exit leaves this way; elsewhere the laws of the lock '
           'left hold it by having nothing beyond the '
           'share, and do not list it (`ClosedCapture.Drawn.through_locks`, `DrawnShaping.drawn_locks`, `RuleCapture.locked_stays`).', '',
           f'{len(atlas.get("premises", []))} premise{"s" if len(atlas.get("premises", [])) != 1 else ""}. The laws and exits read for them so far: '
           + (', '.join(f'family {f} ({n} dynamics)' for f, n in sorted(by_family.items())) or 'none') + '. '
           'A premise whose statement is withheld is one whose home is being re-said; its statement waits for that.', '']
    out += ['## Where each premise is listed', '',
            'A premise only one family\'s laws take, or only its exits drop, is on that family\'s page; the seeds (K3\'s and 08\'s '
            'card) and the premises taken across families, or by no law read, are below.', '',
            '| Family | Its page | Premises only its laws take |', '|---|---|---|']
    for page, ids in own:
        f = families[page.rsplit('/', 1)[1][:-3].upper()]
        out.append(f'| {f["id"]}. {f["en"]} | [{f["id"].lower()}.md]({_href(page)}) | {len(ids)} |')
    here_n = len(on.get(PREMISES_PAGE, ()))
    out += ['', f'Here: {here_n} premise{"s" if here_n != 1 else ""}.' if here_n else 'None is listed here.', '']
    out += tables(on.get(PREMISES_PAGE, set()), PREMISES_PAGE)
    pages = {PREMISES_PAGE: _finish(out + ['', _navigation(PREMISES_PAGE, atlas)])}
    for page, ids in own:
        f = families[page.rsplit('/', 1)[1][:-3].upper()]
        head = [GENERATED, '', f'# The premise ledger: {f["id"]}. {f["en"]}', '', _navigation(page, atlas), '',
                f'*AI-written, from the entries (PLAN §13). The {len(ids)} premises that only family {f["id"]}\'s laws take, or only '
                f'its exits drop. The seeds and the premises taken across families are on [the premise ledger]({_href(PREMISES_PAGE, posixpath.dirname(page))}), '
                'which also says how the lists are read. A premise is no result and the ledger proves nothing; whether one holds '
                'of an actual system is never established here.*', '']
        pages[page] = _finish(head + tables(ids, page) + ['', _navigation(page, atlas)])
    return pages


def _routes(atlas: dict) -> dict:
    """From each dynamic, the dynamics it reaches by following exits that name a dynamic, each with the weakest strength
    on the strongest route there (the route whose weakest step is strongest, by ROUTE_STANDING)."""
    rank = {s: i for i, s in enumerate(ROUTE_STANDING)}
    edges = {}
    for d in atlas['dynamics']:
        for x in d['exits']:
            if isinstance(x['to'], str):
                edges.setdefault(d['id'], []).append((x['to'], _seen(x)))
    out = {}
    for start in [d['id'] for d in atlas['dynamics']]:
        best = {}
        frontier = [(start, -1)]
        while frontier:
            node, weakest = frontier.pop()
            for to, strength in edges.get(node, []):
                w = max(weakest, rank[strength])
                if to != start and (to not in best or w < best[to]):
                    best[to] = w
                    frontier.append((to, w))
        out[start] = {to: ROUTE_STANDING[w] for to, w in best.items()}
    return out


def terrain_page(atlas: dict) -> str:
    """TERRAIN.md: for each family whose dynamics have been read for their premises (PLAN §13, step 2), its exits as a
    graph, the routes out of each dynamic and their weakest steps, and which premise each exit drops."""
    homes = _homes(atlas)
    names = {d['id']: _name(d) for d in atlas['dynamics']}
    premises = {p['id']: p for p in atlas.get('premises', [])}
    routes = _routes(atlas)
    out = [GENERATED, '', '# The terrain: where the read families lead', '', _navigation(TERRAIN, atlas), '',
           f'![The terrain at the scale of the families, drawn from the entries alone]({_href(TERRAIN_SVG)})', '',
           '*AI-written, from the entries (PLAN §13, step 2). Each exit is drawn as an edge: to a dynamic where a law places '
           'the course there, else to the state it reaches, in words. An edge is drawn bold for an exact exit, plain for a '
           'sufficient one, and dashed for a witness (a constructed course that leaves, with no condition) or a necessary '
           'one (what leaving requires, not that it happens), each edge labelled with its strength. A route follows exits that name a dynamic; its '
           'weakest step is ranked exact, sufficient, witness, necessary, from the step that most establishes the route to '
           'the one that least does. A route chains exits that name a dynamic without checking that one exit\'s destination '
           'meets the next exit\'s conditions: it says where the stated exits point, not that a course goes there. Nothing here '
           'ranks courses or says where a course should go.*', '']
    read_families = [f for f in atlas['vocabulary']['families']
                     if any(d['family'] == f['id'] for d in atlas['dynamics'])
                     and all('premises' in d for d in atlas['dynamics'] if d['family'] == f['id'])]
    if any(d['family'] in {f['id'] for f in read_families} and x.get('standing_without_law')
           for d in atlas['dynamics'] for x in d['exits']):
        out += ['*A dashed edge from an exit no law shows names, in words or as a dynamic, where its source argues, '
                'conjectures, reads or leaves open that the course goes; no law places it there, and a route through it '
                'ranks below every step a law shows.*', '']
    for f in atlas['vocabulary']['families']:
        listed = [d for d in atlas['dynamics'] if d['family'] == f['id']]
        if not listed or not all('premises' in d for d in listed):
            continue
        ids = {d['id'] for d in listed}
        nodes, lines, ends = {}, [], 0

        def node(i):
            nodes.setdefault(i, f'n{len(nodes)}')
            return nodes[i]
        # An exit no law shows (argued, a reading …) is dashed too; none is in a family read for its premises yet.
        arrows = {'exact': '==>', 'sufficient': '-->', **{s: '-.->' for s in ROUTE_STANDING[2:]}}
        for d in listed:
            node(d['id'])
            for x in d['exits']:
                if isinstance(x['to'], str):
                    target = node(x['to'])
                else:
                    ends += 1
                    target = f'e{ends}'
                    label = _mermaid(_line(x['to'])) if x['to'] else 'not yet read'
                    lines.append(f'  {target}(["{_clip(label, 70)}"])')
                lines.append(f'  {node(d["id"])} {arrows[_seen(x)]}|{_seen(x)}| {target}')
        decl = [f'  {n}["{_clip(_mermaid(names[i]), 60)}"]' + (':::other' if i not in ids else '') for i, n in nodes.items()]
        out += [f'## {f["id"]}. {f["en"]}', '', f'{len(listed)} dynamics, {sum(len(d["exits"]) for d in listed)} exits.', '',
                '```mermaid', 'flowchart LR', *decl, *lines, '  classDef other stroke-dasharray: 3 3', '```', '',
                '| Dynamic | Leaves to | Reaches by named exits (weakest step) |', '|---|---|---|']
        for d in listed:
            leaves = []
            for i, x in enumerate(d['exits'], 1):
                to = (f'[{_cell(names[x["to"]])}]({_section(x["to"], homes, TERRAIN)})' if isinstance(x['to'], str)
                      else 'not yet read' if x['to'] is None else _cell(_line(x['to'])))
                drop = (' dropping ' + ', '.join(_premise_link(p, premises, ATLAS) for p in x['drops'])) if x.get('drops') else ''
                said = isinstance(x['to'], dict) and re.search(r'\(a witness[;)][^()]*\)?$', _line(x['to']))
                tag = '' if x['strength'] == 'witness' and said else _seen(x)
                inner = '; '.join(p for p in (tag, drop.strip()) if p)
                leaves.append(f'{i}. {to}' + (f' ({inner})' if inner else ''))
            reach = ', '.join(f'[{_cell(names[t])}]({_section(t, homes, TERRAIN)}) ({w})' for t, w in sorted(routes[d['id']].items()))
            out.append(f'| [{_cell(names[d["id"]])}]({_section(d["id"], homes, TERRAIN)}) | '
                       + ('<br>'.join(leaves) or '**none: no exit is stated**') + f' | {reach or "—"} |')
        released = {}
        for d in listed:
            for i, x in enumerate(d['exits'], 1):
                for p in x.get('drops') or []:
                    released.setdefault(p, []).append(f'[{_cell(names[d["id"]])}]({_section(d["id"], homes, TERRAIN)}) (exit {i})')
        out += ['', '**Which premise releases which lock.** Each premise an exit of the family drops, and the exits that drop it.'
                + (' Where an exit\'s law reads beyond the share, the exit drops Unread: the joined laws of closed capture hold it '
                   'by their form, the loss there unread, and list it; the other locks hold it by having nothing beyond the share, '
                   'and do not list it.' if 'closedcapture-unread' in released else ''), '',
                '| Premise | Dropped by |', '|---|---|']
        out += [f'| {_premise_link(p, premises, ATLAS)} | {", ".join(v)} |' for p, v in sorted(released.items(), key=lambda kv: (-len(kv[1]), kv[0]))]
        out += ['' if released else 'No exit of the family drops a premise.', '']
    out += _unity(atlas, names, homes, premises)
    return _finish(out + ['', _navigation(TERRAIN, atlas)])


def _unity(atlas: dict, names: dict, homes: dict, premises: dict) -> list[str]:
    """TERRAIN's last two sections: each general law with the laws that are cases of it, where the Lean derives them,
    and the dynamics it gives cases in; then each joining of two dynamics."""
    links = _links(atlas)
    family = {d['id']: d['family'] for d in atlas['dynamics']}
    general = {}
    for d in atlas['dynamics']:
        for h in d.get('premises') or []:
            for c in h.get('case_of') or []:
                general.setdefault(c['law'], []).append((d['id'], h['law']))
    joins = [c for d in atlas['dynamics'] for c in d.get('compose') or []]
    if not general and not joins:
        return []
    out = []
    if general:
        out += ['## Laws given as cases of one law', '',
                '*A law here is a case of a general law where its Lean proof applies that law and its conclusion is the general '
                'law\'s, with some of its roles fixed (PLAN §13, the six-family pass). Where the general law is listed under '
                'another dynamic, a family\'s law and a law elsewhere are one law read twice. Where the atlas lists it under none, '
                'it is a general law or a lemma the atlas does not list; the case\'s line on its law says which. A case is read '
                'relative to the dynamic its law is listed under: a general law listed under no dynamic and stated in a record of '
                'that dynamic is a step within it, so a law listed under two dynamics may be a case on one and not on the other.*', '',
                '| General law | Listed under | Its cases (law, under) | Families |', '|---|---|---|---|']
        for g, cases in sorted(general.items(), key=lambda kv: (-len({family[i] for i, _ in kv[1]}), -len(kv[1]), kv[0])):
            under = ', '.join(f'[{_cell(names[o])}]({_section(o, homes, TERRAIN)})' for o in links['owners'].get(g, [])) or '—'
            rows = '<br>'.join(f'`{law}` ([{_cell(names[i])}]({_section(i, homes, TERRAIN)}))' for i, law in cases)
            fams = sorted({family[i] for i, _ in cases} | {family[o] for o in links['owners'].get(g, [])})
            out.append(f'| `{g}` | {under} | {rows} | {", ".join(fams)} |')
        out.append('')
    if joins:
        out += ['## How dynamics join', '',
                '*Where one dynamic\'s state is read as another\'s rule, reading or pool (PLAN §13, the six-family pass). Each '
                'says how far it is seen: proved where a Lean law\'s statement relates both sides; stated where a theorem\'s home '
                'says it in words, with no joint law; a reading where a chapter\'s marked AI reading proposes it. A joining seen '
                'only by an agent of the pass is not entered. A joining says the two can be one course\'s levels, not that a given '
                'course joins them.*', '',
                f'{sum(c["standing"] == "proved" for c in joins)} proved, {sum(c["standing"] == "stated" for c in joins)} stated, '
                f'{sum(c["standing"] == "reading" for c in joins)} a reading.', '']
        out += [f'- {_join(c, names, homes, TERRAIN, premises)}' for c in joins] + ['']
    return out


def _t(value) -> str:
    return _cell(_line(value))


def _and(items: list[str]) -> str:
    """'C', 'C and D', 'C, D and G'."""
    return items[0] if len(items) == 1 else ', '.join(items[:-1]) + ' and ' + items[-1]


# The terrain's picture, in the palette of the crosswalk's overview (connection_map.py), which imports this module.
TS_W, TS_H = 900, 1110
TS_INK, TS_MUTED, TS_PAPER, TS_RULE, TS_LAW, TS_READING = '#1e1a15', '#6d6355', '#fcfcfb', '#d6d3d1', '#1f6fbf', '#b58a00'
TS_FONT = "Helvetica, Arial, 'PingFang SC', 'Hiragino Sans GB', 'Noto Sans CJK SC', sans-serif"


def terrain_counts(atlas: dict) -> dict:
    """What the terrain's picture draws, counted from the entries: for each family whether it is read (every dynamic of it
    read for its premises), its dynamics, its exits within it, to a state in words and not yet read; and for each pair of
    families the exits from a dynamic of the first to a dynamic of the second, where a law places them and where none does."""
    family = {d['id']: d['family'] for d in atlas['dynamics']}
    fams = [f['id'] for f in atlas['vocabulary']['families']]
    out = {'families': {f: {'dynamics': 0, 'read': True, 'within_law': 0, 'within_reading': 0, 'to_state': 0, 'unread_to': 0, 'exits': 0}
                        for f in fams}, 'between': {}}
    for d in atlas['dynamics']:
        f = out['families'][d['family']]
        f['dynamics'] += 1
        f['read'] = f['read'] and d.get('premises') is not None
        for x in d['exits']:
            f['exits'] += 1
            kind = 'reading' if x.get('standing_without_law') else 'law'
            if isinstance(x['to'], str):
                g = family[x['to']]
                if g == d['family']:
                    f['within_' + kind] += 1
                else:
                    key = (d['family'], g)
                    out['between'].setdefault(key, {'law': 0, 'reading': 0})[kind] += 1
            elif x['to'] is None:
                f['unread_to'] += 1
            else:
                f['to_state'] += 1
    return out


def _ts_text(x, y, body, size=12.0, weight='normal', anchor='middle', fill=TS_INK) -> str:
    bold = ' font-weight="bold"' if weight == 'bold' else ''
    return f'<text x="{x:.1f}" y="{y:.1f}" font-size="{size:g}"{bold} text-anchor="{anchor}" fill="{fill}">{html.escape(body)}</text>'


def _wrap(text: str, width: int) -> list[str]:
    lines, line = [], ''
    for word in text.split():
        if line and len(line) + 1 + len(word) > width:
            lines.append(line)
            line = word
        else:
            line = f'{line} {word}'.strip()
    return lines + ([line] if line else [])


def _clip_to_box(cx, cy, tx, ty, w, h):
    """Where the segment from a box's centre toward (tx, ty) leaves the box."""
    dx, dy = tx - cx, ty - cy
    scale = min(w / 2 / abs(dx) if dx else math.inf, h / 2 / abs(dy) if dy else math.inf)
    return cx + dx * scale, cy + dy * scale


def terrain_svg(atlas: dict) -> str:
    """The terrain at the scale of the families, drawn from the entries alone (terrain_counts): an arrow is a count of
    recorded exits, never a route, and nothing here ranks courses or says where a course should go."""
    c = terrain_counts(atlas)
    fams = atlas['vocabulary']['families']
    read = [f['id'] for f in fams if c['families'][f['id']]['read'] and c['families'][f['id']]['dynamics']]
    cx, cy, r, bw, bh = TS_W / 2, 545, 345, 184, 100
    pos = {f['id']: (cx + r * math.cos(math.radians(-90 + 360 * i / len(fams))), cy + r * math.sin(math.radians(-90 + 360 * i / len(fams))))
           for i, f in enumerate(fams)}
    between = c['between']
    n_law = sum(v['law'] for v in between.values())
    n_reading = sum(v['reading'] for v in between.values())
    title = 'The terrain: where the atlas\'s families of dynamics lead'
    desc = (f'Drawn from the atlas\'s entries alone. Each of the eight boxes is a family of dynamics, with its count. Each arrow '
            f'counts the recorded exits from a dynamic of one family to a dynamic of another: {n_law} such exits a law places, '
            f'drawn solid, and {n_reading} that no law shows (argued, conjectured, a reading or open), drawn dashed. Inside each '
            'box are the exits that stay within the family and those whose destination is a state said in words. '
            + (f'Famil{"ies" if len(read) != 1 else "y"} {_and(read)} {"are" if len(read) != 1 else "is"} read for the premises '
               'their laws take and where their exits lead; ' if read else '')
            + ('the families drawn dashed are not yet read so, their exits as first entered. ' if len(read) < len(fams) else '')
            + 'An arrow is an exit, not a route: '
            'nothing here checks that one exit\'s destination meets the next one\'s conditions, ranks courses, or says where a '
            'course should go.')
    out = [f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {TS_W} {TS_H}" width="{TS_W}" height="{TS_H}" role="img" '
           f'aria-labelledby="ts-title ts-desc" font-family="{html.escape(TS_FONT)}">',
           f'<title id="ts-title">{html.escape(title)}</title>', f'<desc id="ts-desc">{html.escape(desc)}</desc>',
           '<defs>'
           f'<marker id="ts-law" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse"><path d="M0,0 L10,5 L0,10 z" fill="{TS_LAW}"/></marker>'
           f'<marker id="ts-reading" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse"><path d="M0,0 L10,5 L0,10 z" fill="{TS_READING}"/></marker>'
           '</defs>',
           f'<rect x="0.5" y="0.5" width="{TS_W - 1}" height="{TS_H - 1}" rx="10" fill="{TS_PAPER}" stroke="{TS_RULE}"/>',
           _ts_text(24, 36, title, 18, 'bold', 'start'),
           _ts_text(24, 58, 'Drawn from the atlas\'s entries alone: an arrow counts recorded exits between two families, not a route.', 13, anchor='start', fill=TS_MUTED),
           _ts_text(24, 78, (f'Read for premises and exits: {_and(read)}.' + (' Dashed boxes: not yet read, their exits as first entered.'
                                                                             if len(read) < len(fams) else '')
                             if read else 'No family is read for premises and exits yet.'), 13, anchor='start', fill=TS_MUTED)]
    # Arrows first, under the boxes: each a curve bowed toward the centre, so that it passes no other box; the two kinds
    # of a pair, and its two directions, bow apart.
    for (a, b) in sorted(between):
        for kind, colour, dash, off in (('law', TS_LAW, '', -1), ('reading', TS_READING, ' stroke-dasharray="6 4"', 1)):
            n = between[(a, b)][kind]
            if not n:
                continue
            (ax, ay), (bx, by) = pos[a], pos[b]
            mx, my = (ax + bx) / 2, (ay + by) / 2
            length = math.hypot(bx - ax, by - ay) or 1
            nx, ny = -(by - ay) / length, (bx - ax) / length
            apart = 20 * off + (34 if (b, a) in between else 0)
            qx = mx + (cx - mx) * 0.38 + nx * apart
            qy = my + (cy - my) * 0.38 + ny * apart
            sx, sy = _clip_to_box(ax, ay, qx, qy, bw + 10, bh + 10)
            ex, ey = _clip_to_box(bx, by, qx, qy, bw + 10, bh + 10)
            out.append(f'<path d="M{sx:.1f},{sy:.1f} Q{qx:.1f},{qy:.1f} {ex:.1f},{ey:.1f}" fill="none" stroke="{colour}" '
                       f'stroke-width="{1.4 + min(n, 6) * 0.4:.1f}"{dash} marker-end="url(#ts-{kind})"/>')
            t = 0.32  # a third of the way from the family the exits leave
            lx = (1 - t) ** 2 * sx + 2 * t * (1 - t) * qx + t ** 2 * ex
            ly = (1 - t) ** 2 * sy + 2 * t * (1 - t) * qy + t ** 2 * ey
            out.append(f'<rect x="{lx - 11:.1f}" y="{ly - 9:.1f}" width="22" height="16" rx="3" fill="{TS_PAPER}" stroke="{colour}" stroke-width="0.8"/>')
            out.append(_ts_text(lx, ly + 3.5, str(n), 11, 'bold', fill=colour))
    for f in fams:
        x, y = pos[f['id']]
        k = c['families'][f['id']]
        is_read = f['id'] in read
        out.append(f'<rect x="{x - bw / 2:.1f}" y="{y - bh / 2:.1f}" width="{bw}" height="{bh}" rx="8" fill="#ffffff" '
                   f'stroke="{TS_INK if is_read else TS_MUTED}" stroke-width="{1.6 if is_read else 1.1}"' + ('' if is_read else ' stroke-dasharray="5 4"') + '/>')
        name = _wrap(f'{f["id"]}. {f["en"]}', 26)
        top = y - bh / 2 + 18
        for i, line in enumerate(name[:2]):
            out.append(_ts_text(x, top + i * 15, line, 12.5, 'bold', fill=TS_INK if is_read else TS_MUTED))
        y1 = top + len(name[:2]) * 15 + 4
        out.append(_ts_text(x, y1, f'{k["dynamics"]} dynamics · ' + ('read' if is_read else 'not yet read'), 11.5, fill=TS_INK if is_read else TS_MUTED))
        within = k['within_law'] + k['within_reading']
        out.append(_ts_text(x, y1 + 15, f'{within} exit{"s" if within != 1 else ""} within · {k["to_state"]} to a state in words', 11, fill=TS_MUTED))
        if k['unread_to']:
            out.append(_ts_text(x, y1 + 29, f'{k["unread_to"]} with no destination read', 11, fill=TS_MUTED))
    ly = TS_H - 74
    out += [f'<line x1="32" y1="{ly}" x2="82" y2="{ly}" stroke="{TS_LAW}" stroke-width="2.2" marker-end="url(#ts-law)"/>',
            _ts_text(92, ly + 4, 'exits a law places in a dynamic of another family, their count nearer the family they leave', 12, anchor='start'),
            f'<line x1="32" y1="{ly + 24}" x2="82" y2="{ly + 24}" stroke="{TS_READING}" stroke-width="2.2" stroke-dasharray="6 4" marker-end="url(#ts-reading)"/>',
            _ts_text(92, ly + 28, 'exits no law shows: argued, conjectured, a reading or open', 12, anchor='start'),
            *([f'<rect x="32" y="{ly + 40}" width="50" height="16" rx="4" fill="#ffffff" stroke="{TS_MUTED}" stroke-dasharray="5 4"/>',
               _ts_text(92, ly + 52, 'a family not yet read for its premises and exits', 12, anchor='start')] if len(read) < len(fams) else []),
            '</svg>']
    return '\n'.join(out) + '\n'



def bindings_page(atlas: dict) -> str:
    """BINDINGS.md: the rows of the tests table bound to the dynamics they bear on, each with the bridge by which its
    outcome meets the map, and a matrix of the dynamics against the rows."""
    homes, names = _homes(atlas), {d['id']: _name(d) for d in atlas['dynamics']}
    premises = {p['id']: p for p in atlas.get('premises', [])}
    try:
        rows = {t.get('id'): t for t in json.loads((ROOT / TESTS).read_text()).get('tests', [])}
    except (OSError, ValueError):
        rows = {}
    at = ATLAS
    out = [GENERATED, '', '# Tests bound to the map', '', _navigation(BINDINGS_PAGE, atlas), '',
           '*AI-written, from the entries (PLAN §13, step 3: a first slice on families C and D). A binding says how a test '
           'the account ran meets the map: the dynamics it bears on, the conclusion it reads, what plays each role of the law, '
           'how each premise of that identification fares, what was observed and came out, and where the outcome marks: on '
           '`the law` (a prediction it makes under premises met failed), on `the binding` (a premise of the identification '
           'failed, so the outcome does not reach the law), on `the measurement` (what was measured did not measure the role), '
           'or `nothing failed`. A binding is no new evidence: it is read from the test\'s own README, and where the README '
           'does not say, it says so. A test of kind `model` is never evidence about the world.*', '']
    by_dynamic = {}
    for b in atlas['bindings']:
        for x in b['bears_on']:
            by_dynamic.setdefault(x['dynamic'], []).append(b)
    out += ['| Dynamic | Tests that bear on it (outcome; where it marks) |', '|---|---|']
    for d in [d for d in atlas['dynamics'] if d['id'] in by_dynamic]:
        cells = [f'[{_cell(b["test"])}](#{b["id"]}) ({rows.get(b["test"], {}).get("outcome", "?")}; '
                 + (b['binding']['marks'] if b['binding'] else 'no result') + ')' for b in by_dynamic[d['id']]]
        out.append(f'| [{_cell(names[d["id"]])}]({_section(d["id"], homes, BINDINGS_PAGE)}) | {", ".join(cells)} |')
    out.append('')
    for b in atlas['bindings']:
        row = rows.get(b['test'], {})
        out += [f'<a id="{b["id"]}"></a>', f'## {b["test"]}: {row.get("name", "")}', '',
                f'- **Outcome.** {row.get("outcome", "?")}' + (f': {_line({"en": row["gloss"]})}' if row.get('gloss') else '')
                + (f' ([its README]({_href(row["folder"], at)}))' if row.get('folder') else ''),
                '- **Bears on.**']
        for x in b['bears_on']:
            out.append(f'  - [{_cell(names[x["dynamic"]])}]({_section(x["dynamic"], homes, BINDINGS_PAGE)}), through '
                       + ', '.join(_record(r, at) for r in x['records'])
                       + (' and ' + ', '.join(f'`{n}`' for n in x['laws']) if x['laws'] else '') + f': {_line(x["how"])}')
        g = b['binding']
        if g is None:
            out += [f'- **Binding.** None: the row is {row.get("outcome", "?")}, with no result a binding could read.', '']
            continue
        out += [f'- **Kind.** {g["kind"]}.',
                f'- **Reads.** {_line(g["target"]["conclusion"])} ('
                + ', '.join([_record(r, at) for r in g['target']['records']] + [f'`{n}`' for n in g['target']['laws']]) + ')',
                '- **Roles.**'] + [f'  - {_line(r["role"])}: {_line(r["as"])}' for r in g['roles']]
        out += ['- **Premises of the identification.**' + ('' if g['premises'] else ' None named.')]
        out += [f'  - {_premise_link(p["premise"], premises, at)}: {p["assessed"]}. {_line(p["how"])}' for p in g['premises']]
        out += [f'- **Observed.** {_line(g["observed"])}', f'- **Result.** {_line(g["result"])}',
                f'- **Where it marks.** {g["marks"]}: {_line(g["marks_why"])}',
                f'- **Another explanation.** {_line(g["alternative"])}', f'- **Read from.** {_source(g["source"], at)}', '']
    return _finish(out + ['', _navigation(BINDINGS_PAGE, atlas)])


def situations_page(atlas: dict) -> str:
    """SITUATIONS.md: each situation, its own graph, what the checker computes of each reader, and the dynamics,
    premises, exits and bearers of the atlas it is read through."""
    homes, names = _homes(atlas), {d['id']: _name(d) for d in atlas['dynamics']}
    premises = {p['id']: p for p in atlas.get('premises', [])}
    dynamics = {d['id']: d for d in atlas['dynamics']}
    at = ATLAS
    out = [GENERATED, '', '# Situations', '', _navigation(SITUATIONS_PAGE, atlas), '',
           '*AI-written, from the entries (PLAN §13, step 4: a first slice on families C and D). A situation is a case '
           'written in the account\'s own words: who forms, what they draw on, what reaches whom, who reads what, what the '
           'rule forms from, and when. Its standing is a reading: it says how the map meets the case, not that the case is so, '
           'and a situation of kind `model` is no evidence about the world. For each reader the checker computes, from the '
           'situation\'s own couplings, its closure (what has a path of couplings into it), what its acts reach, and what lies '
           'beyond it: reached and not in its closure. By `Flow.unselected_beyond_pool` and `BeyondCoupling` a selection read '
           'through that reader cannot tell apart what lies beyond it, under those laws\' premises (balance on what couples into '
           'the closure and the rest of the exchange fixed; or the rest reading through coupling, both courses feasible), which '
           'the situation assesses below. The sets are only as right as the couplings written.*', '']
    for s in atlas['situations']:
        node = {n['id']: n['en'] for n in s['formations'] + s['conditions']}

        def nm(i):
            return f'{node.get(i, i)} (`{i}`)'

        out += [f'<a id="{s["id"]}"></a>', f'## {_line(s["name"])}', '', _line(s['summary']), '',
                f'- **Kind.** {s["kind"]}. **Standing.** {s["standing"]}.',
                '- **Formations.** ' + '; '.join(nm(n['id']) for n in s['formations']) + '.',
                '- **Conditions.** ' + '; '.join(nm(n['id']) for n in s['conditions']) + '.',
                f'- **The rule.** {_line(s["rule"])}', f'- **Time.** {_line(s["time"])}', '',
                '**Couplings** (what the first does reaches the second).', '', '| From | To | How |', '|---|---|---|']
        out += [f'| {_cell(nm(c["from"]))} | {_cell(nm(c["to"]))} | {_cell(c["en"])} |' for c in s['couplings']]
        out += ['', '**Readers.**', '', '| Reader | Reads | Drawn from | Selects among |', '|---|---|---|---|']
        out += [f'| {_cell(nm(r["id"]))} | {_cell(", ".join(nm(x) for x in r["reads"]))} | {_t(r["drawn_from"])} | '
                f'{_cell(", ".join(nm(x) for x in r.get("selects", [])) or "—")} |' for r in s['readers']]
        out += ['', '**Computed by the checker** (from the couplings above).', '',
                '| Reader | Its closure | What its acts reach | Beyond it | Reads among those it selects |', '|---|---|---|---|---|']
        out += [f'| {_cell(nm(c["reader"]))} | {_cell(", ".join(nm(x) for x in c["closure"]))} | '
                f'{_cell(", ".join(nm(x) for x in c["reaches"]) or "nothing")} | {_cell(", ".join(nm(x) for x in c["beyond"]) or "nothing")} | '
                f'{_cell(", ".join(nm(x) for x in c["reads_among_selected"]) or "—")} |' for c in s['computed']]
        out += ['', '**The dynamics it is read through.**', '']
        for x in s['dynamics']:
            out.append(f'- [{_cell(names[x["dynamic"]])}]({_section(x["dynamic"], homes, SITUATIONS_PAGE)}): {_line(x["as"])}'
                       + ''.join(f' {_line(r["role"])}: {_line(r["as"])}.' for r in x['roles']))
        out += ['', '**Premises** (taken by laws of those dynamics).', '', '| Premise | Here | Why |', '|---|---|---|']
        out += [f'| {_premise_link(p["premise"], premises, at)} | {p["assessed"]} | {_t(p["why"])} |' for p in s['premises']]
        out += ['', '**Exits.**', '', '| Dynamic | Exit | Here | Why |', '|---|---|---|---|']
        for x in s['exits']:
            ex = dynamics[x['dynamic']]['exits'][x['exit'] - 1]
            to = names[ex['to']] if isinstance(ex['to'], str) else (_line(ex['to']) if ex['to'] else 'a destination not yet read')
            out.append(f'| [{_cell(names[x["dynamic"]])}]({_section(x["dynamic"], homes, SITUATIONS_PAGE)}) | {x["exit"]}: '
                       f'{_cell(_clip(to, 120))} | {x["open"]} | {_t(x["why"])} |')
        out += ['', '**Who bears what.**', ''] + [f'- {_line(b["who"])}: {_line(b["what"])}' for b in s['bears']]
        out += ['', '**Written from.** ' + ', '.join(_source(r, at) if '#' in r else f'[{r}]({_href(r, at)})' for r in s['sources']), '']
    return _finish(out + ['', _navigation(SITUATIONS_PAGE, atlas)])



def render(records: list) -> tuple[dict, list[str]]:
    """Pages to write and errors, for research.py render and check; no page where there is an error."""
    vocabulary, entries, errors = load()
    errors = errors or validate(entries, vocabulary, records)
    if errors:
        return {}, ['atlas: ' + e for e in errors]
    checks, errors = _checks()
    if errors:
        return {}, ['atlas: ' + e for e in errors]
    atlas = build(entries, vocabulary, records)
    atlas['crosswalk_checks'] = checks
    pages = {PAGE: page(atlas), CROSSWALK: crosswalk_page(atlas), FOLDERS: folders_page(atlas),
             DATA: json.dumps(atlas, ensure_ascii=False, indent=1) + '\n'}
    if atlas['premises']:
        pages.update(premise_pages(atlas))
        pages[TERRAIN] = terrain_page(atlas)
        pages[TERRAIN_SVG] = terrain_svg(atlas)
    if atlas['bindings']:
        pages[BINDINGS_PAGE] = bindings_page(atlas)
    if atlas['situations']:
        pages[SITUATIONS_PAGE] = situations_page(atlas)
    pages.update({family_path(f): family_page(atlas, f) for f in vocabulary['families']})
    pages.update({group_path(g): group_page(atlas, g) for g in atlas['correspondence_groups']})
    pages[CROSSWALK_ZH] = crosswalk_zh_page(atlas)
    errors = [f'{path}: {len(body.encode()):,} bytes, more than the {PAGE_LIMIT:,} this render allows (GitHub showed a page of '
              f'1,035,845 bytes and not one of 3,742,459); split it further'
              for path, body in pages.items() if path.endswith('.md') and len(body.encode()) > PAGE_LIMIT]
    errors += [f'{path}: a page the atlas no longer writes; remove it by name'
               for folder in (FAMILY_PAGES, CROSSWALK_PAGES, PREMISE_PAGES) for path in sorted(p.relative_to(ROOT).as_posix() for p in (ROOT / folder).glob('*.md'))
               if path not in pages]
    return ({}, ['atlas: ' + e for e in errors]) if errors else (pages, [])


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--check', action='store_true', help='compare the generated pages with the files as well')
    ap.add_argument('--json', action='store_true', help='print the resolved atlas')
    a = ap.parse_args(argv)
    records, record_errors = registry.load_records()
    pages, errors = render(records)
    errors = ['records: ' + e for e in record_errors] + errors
    atlas = json.loads(pages[DATA]) if pages else None
    summary = {'errors': errors, 'dynamics': len(atlas['dynamics']) if atlas else None, 'by_family': atlas['counts'] if atlas else None,
               'correspondences': len(atlas['correspondences']) if atlas else None}
    differs = []
    if a.check:
        differs = [p for p, body in pages.items() if not (ROOT / p).is_file() or (ROOT / p).read_text() != body]
        summary['differs'] = differs
    if a.json:
        summary['atlas'] = atlas
    print(json.dumps(summary, ensure_ascii=False, indent=1))
    return 1 if errors or differs else 0


if __name__ == '__main__':
    raise SystemExit(main())
