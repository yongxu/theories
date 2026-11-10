#!/usr/bin/env python3
"""The landing gate: the checks a change can reach, each run once per tree, heavy runs a few at a time.

A check's result is a function of what it reads. So a landing runs only the checks whose inputs its changed
paths touch (CHECKS), and a pass is kept with the tree it passed on: it holds again on the same tree, and on a
later commit when the passed one is its ancestor (history only grows, so what the drift check finds in history
is still found) and the diff between them touches nothing the check reads. A changed path outside every area
the rules know selects every check, and a rule naming a path the tree lacks fails: a missing rule costs time,
a stale one stops the gate, and neither lets a change past a check that reads it. Heavy runs, the core run and
the render included (`gate.py hold`), take one of a few slots shared by every worktree of the repository; a slot
is a lock the kernel frees when its holder dies.

What writes (the core run, the render) runs before the gate and is committed; the strict check then fails on a
page a render would change or a record bound to Lean bytes no receipt covers, and no cache here or in the
checks lets a stale page or a changed hash pass. The design: _process/research/2026-10-05-repository-
reconciliation/architecture/gt/GATE.md.

usage (from a clean worktree of the merged commit, never the shared checkout):
  python3 -B tools/research/gate.py plan [--base main] [--train BRANCH ...]
  python3 -B tools/research/gate.py run [--base main] [--full [--fresh]] [--only NAME ...] [--train BRANCH ...]
  python3 -B tools/research/gate.py hold -- COMMAND ...   run a heavy command in a slot (the core run, the render)
  python3 -B tools/research/gate.py restated [--base main]
  python3 -B tools/research/gate.py status
"""
from __future__ import annotations

import argparse
from contextlib import contextmanager
from functools import lru_cache
from dataclasses import dataclass
import datetime as _dt
import fcntl
import hashlib
import json
import os
from pathlib import Path
import platform
import re
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parents[2]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
from tools.research import paths  # noqa: E402

LEAN = 'experiments/integrated-correction/general-framework/generative-basis/lean'
BECOMING = LEAN + '/becoming'
BOARD = '_process/BECOMING-WORKBOARD.md'
REVIEW = 'theories/becoming/review'
PACKET = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/review-packet'
CORPUS = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/one-unfolding-root/corpus'
PY = (sys.executable, '-B')
RESEARCH_TOOLS = ('tools/research/**', '_process/research-config.json', 'Makefile')
GLOB = re.compile(r'[*?\[]')
# check_dossiers.py's quotation pattern (its line 31), so the paths the dossiers quote are read as that checker reads them
QUOTE = re.compile(r'(原文|引|Source|Quote)\s*[〔\[]([^〕\]]+)[〕\]]\s*[：:]\s*[「"“]([^」"”]+)[」"”]')

# The repository's areas. A changed path outside all of them (a new top-level area) is placed by no rule, so it
# selects every check until a rule says what reads it.
AREAS = ('*', '.claude/**', '.github/**', '_process/**', 'drafts/**', 'experiments/**', 'output/**', 'sources/**', 'theories/**',
         'tools/**', 'worldbuilding/**')


@dataclass(frozen=True)
class Check:
    """A command and the paths that can change its result: `reads` (repository globs; a literal path must
    exist), `derived` (a function of the tree giving more paths, read from manifests), and `added` (any added
    or deleted path reaches it: a link target, a counted file)."""
    name: str
    command: tuple
    reads: tuple
    added: bool = False
    heavy: bool = False
    derived: str = ''        # name of a function in this module returning extra paths
    unread: tuple = ()       # globs whose modification (not addition or deletion) it never reads
    unread_when: tuple = ()  # (path, name of a predicate (before, path) -> bool): a modification it reads only when false
    env: tuple = ()          # commands whose output (a version) is part of the pass's key
    note: str = ''


@lru_cache(maxsize=None)
def frozen_paths() -> tuple:
    """Every path a freeze manifest lists, and the manifests: FROZEN.sha256, FREEZE*.json `files`, the pins."""
    out = list(FREEZE_RECORDS)  # a manifest or pin added or deleted anywhere reaches the check
    for m, entries in manifests().items():
        out.append(m)
        out.extend(p for p, _ in entries)
    for pin, folder in pins().items():
        out += [pin, folder + '/**']
    return tuple(out)


@lru_cache(maxsize=None)
def quoted_paths() -> tuple:
    """The repository files the dossiers quote (引〔PATH〕, Quote [PATH]), which check_dossiers.py reads."""
    found = set()
    for p in tracked(REVIEW + '/**/*.md'):
        for kind, ref, _ in QUOTE.findall((ROOT / p).read_text(errors='replace')):
            if kind in ('引', 'Quote'):
                found.add(ref.strip().split('#')[0])
    return tuple(sorted(found))


@lru_cache(maxsize=None)
def timed_paths() -> tuple:
    """The files README's first screen times ({{time:PATH}}), which navigation renders and a test reads."""
    text = (ROOT / '_process/navigation/README-FIRST-SCREEN.md').read_text(errors='replace')
    return tuple(sorted({m for m in re.findall(r'\{\{time:([^}]+)\}\}', text) if '/' in m or m.endswith('.md')}))


def _record_paths(data: dict) -> set:
    found = {r['path'] for r in data.get('references', []) if isinstance(r, dict) and isinstance(r.get('path'), str)}
    found |= {b['receipt'] for b in data.get('proof_bindings', []) if isinstance(b, dict) and isinstance(b.get('receipt'), str)}
    if isinstance(data.get('canonical_source'), str):
        found.add(data['canonical_source'])
    return {p.split('#')[0] for p in found}


@lru_cache(maxsize=None)
def registry_sources() -> tuple:
    """What test_registry reads beyond the records: the receipts any record's proof bindings name, and the
    canonical source of the first recorded-checked record by file name."""
    out, first = set(), None
    for p in sorted(tracked('theories/becoming/results/records/*.json')):
        try:
            data = json.loads((ROOT / p).read_text())
        except (OSError, ValueError):
            continue
        out |= {b['receipt'] for b in data.get('proof_bindings', []) if isinstance(b, dict) and isinstance(b.get('receipt'), str)}
        if first is None and data.get('status') == 'recorded-checked' and isinstance(data.get('canonical_source'), str):
            first = data['canonical_source'].split('#')[0]
    return tuple(sorted(out | ({first} if first else set())))


DRAFTS = '_process/research/2026-10-05-generative-foundation-review/history/root-foundation/development/becoming-general-laws-plan/readability/drafts'


@lru_cache(maxsize=None)
def draft_paths() -> tuple:
    """What the schema-2 migration drafts reference, which test_schema2 validates."""
    out = set()
    for p in tracked(DRAFTS + '/*.json'):
        try:
            out |= _record_paths(json.loads((ROOT / p).read_text()))
        except (OSError, ValueError, AttributeError):
            pass
    return tuple(sorted(out))


@lru_cache(maxsize=None)
def review_reads() -> tuple:
    return quoted_paths()


TOOLS = ('tools/research/*.py', '_process/research-config.json')
DATA = 'theories/becoming/results/data/'
RECORDS = 'theories/becoming/results/records/*.json'
ROOTF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
# Each test file's inputs, from the test-suite map (GATE.md §3.1): its code (every research tool, since research.py
# imports them all), the live files it asserts on, and derived inputs. A live assertion that the strict check also
# makes is left to the strict check, which every content change reaches. A test file with no entry here reads every
# path until it gets one.
TESTS = {
    'test_atlas': (),
    'test_lean_catalogue_links': (),
    'test_connection_map': (DATA + 'shared-laws.json',),
    # the Chinese fronts' navigation line: the fronts, their English editions and the line's targets
    'test_chinese_fronts': ('README.zh.md', 'README.md', 'GLOSSARY.zh.md', 'GLOSSARY.md', 'theories/LINEAGE.zh.md', 'theories/LINEAGE.md',
                            'theories/becoming/*.md', 'theories/becoming/review/README*.md',
                            'theories/becoming/chapters/06-CLASSICAL-TEXTS.md'),
    # spine.json's phrases at their homes are checked by every render; the test's live check repeats that one
    'test_spine': (),
    # lineage.json's evidence is checked by every render; the test reads fixtures and the live data's shape
    'test_lineage': (),
    'test_architecture': ('tools/research/boundary_check.lean', RECORDS, DATA + 'law-families.json', DATA + 'shared-laws.json'),
    'test_boundary': ('tools/research/boundary_check.lean', 'tools/research/tests/test_schema2.py', RECORDS, DATA + 'law-families.json',
                      DATA + 'shared-laws.json', DATA + 'standard-boundaries.json', ROOTF + '/THEOREM-CONNECTIVITY-DUMP.lean',
                      ROOTF + '/THEOREM-CONNECTIVITY.py', ROOTF + '/development/ou3b-master-laws-on-the-grammar/measure_grammar.py',
                      BECOMING + '/lean-toolchain'),
    'test_checker_steps': ('tools/research/tests/test_style.py', BECOMING + '/check_becoming.py', LEAN + '/universal-ethics/generative-capacity/check.py'),
    # The three classical-text verifiers it runs, what each reads (their maps, the preserved texts, the records, 06,
    # the frozen 易传 chapter, the newest core receipt and the receipts beside it, the modules they name), and
    # beyond the tree only RO's atlas archives, read where present and bound by their SHA-256.
    'test_classical_verifiers': (ROOTF + '/development/y1-changes/**', ROOTF + '/development/ro-relational-sources/**',
                                 ROOTF + '/development/zhonghua/**', 'sources/zhouyi-yizhuan/**',
                                 'sources/chinese-classical-texts/**', 'sources/civilization-thought-v1.0/**', RECORDS,
                                 'theories/becoming/chapters/06-CLASSICAL-TEXTS.md',
                                 'theories/becoming/history/YI-ZHUAN-AND-BECOMING.md',
                                 BECOMING + '/becoming-checks/*/verification.json', LEAN + '/*/*verification.json',
                                 BECOMING + '/Becoming/*.lean', 'experiments/integrated-correction/general-framework/generative-basis/noninstrumental-concern/SituatedPractice.lean'),
    'test_completion': ('theories/becoming/results/completion/COVERAGE.json', BECOMING + '/becoming-verification.json', LEAN + '/**/*.lean',
                        ROOTF + '/THEOREM-CONNECTIVITY.json', 'theories/becoming/chapters/08-METHOD.md', RECORDS),
    'test_credentials': (),
    'test_evidence_store': (),
    'test_gate': (),
    'test_featured_results': (RECORDS, DATA + 'law-families.json', DATA + 'shared-laws.json', DATA + 'standard-boundaries.json',
                              '_process/navigation/REPOSITORY.md', '_process/navigation/README-FIRST-SCREEN.md', '_process/navigation/README-LEAD.md',
                              'theories/becoming/OPENING.md', 'README.md', '?MAP.md', '?' + ROOTF + '/FOUNDATION-COMPOSITION.md', '_process/architecture/moves/*.json'),
    'test_history_notes': (),
    'test_indexes': (RECORDS, DATA + 'session-results.json', DATA + 'lean-index.json', DATA + 'source-index.json',
                     '_process/research/2026-10-05-generative-foundation-review/history/root-foundation/SESSION-OUTCOME-SNAPSHOT.json',
                     '_process/research/2026-10-05-generative-foundation-review/history/root-foundation/SESSION-PROOF-OVERLAP.json'),
    'test_law_families': (),
    'test_links': (),
    'test_moves': (),
    'test_navigation_pages': (RECORDS, DATA + 'law-families.json', DATA + 'shared-laws.json'),
    'test_registry': (RECORDS,),
    'test_rename_ids': (RECORDS, DATA + 'generativity-chain.json', DATA + 'law-families.json', DATA + 'shared-laws.json'),
    'test_repoint': (),
    'test_review_packet': (PACKET + '/check_dossiers.py', PACKET + '/resync_report.py', REVIEW + '/**', CORPUS + '/**',
                           ROOTF + '/development/one-unfolding-root/review-checks/**', BECOMING + '/Becoming/**', LEAN + '/physics/**',
                           LEAN + '/warning/**', LEAN + '/deeper/**'),
    'test_schema2': (RECORDS, DATA + 'law-families.json', DATA + 'shared-laws.json', DATA + 'standard-boundaries.json',
                     '_process/architecture/history/**', '_process/architecture/moves/*.json', DRAFTS + '/**'),
    'test_scoped_drift': (),
    'test_shared_laws': ('tools/research/boundary_check.lean', RECORDS, DATA + 'law-families.json', DATA + 'shared-laws.json', DATA + 'standard-boundaries.json'),
    'test_split_languages': (),
    'test_strict_fresh': ('theories/becoming/results/completion/**', BECOMING + '/becoming-verification.json', ROOTF + '/THEOREM-CONNECTIVITY.json',
                          'theories/becoming/chapters/08-METHOD.md', RECORDS),
    'test_style': (BECOMING + '/check_becoming.py', LEAN + '/universal-ethics/generative-capacity/check.py', DATA + 'standard-boundaries.json', RECORDS),
    'test_theory_graph': (RECORDS, DATA + 'regions.json', CORPUS + '/**', ROOTF + '/development/one-unfolding-root/classify/**',
                          ROOTF + '/development/ou2-candidates/outcomes.tsv', ROOTF + '/development/ou7-conditional-laws/data/groups.tsv',
                          REVIEW + '/*.md', 'theories/becoming/chapters/*.md', BECOMING + '/Becoming/**'),
}
TEST_DERIVED = {'test_featured_results': 'timed_paths', 'test_registry': 'registry_sources', 'test_schema2': 'draft_paths',
                'test_review_packet': 'review_reads'}
TEST_ENV = {'test_boundary': (('lean', '--version'),), 'test_moves': (('rg', '--version'),)}


def test_checks() -> tuple:
    out = []
    for f in sorted((ROOT / 'tools/research/tests').glob('test_*.py')):
        own = (f'tools/research/tests/{f.name}', 'tools/research/tests/*.py')
        extra = TESTS.get(f.stem)
        out.append(Check(f'test:{f.stem}', (*PY, '-m', 'unittest', 'discover', '-s', 'tools/research/tests', '-p', f.name),
                         (*TOOLS, *own, *extra) if extra is not None else ('**',), heavy=True, derived=TEST_DERIVED.get(f.stem, ''),
                         env=TEST_ENV.get(f.stem, ()), note='a research test' if extra is not None else 'a test with no entry: every path'))
    return tuple(out)


CHECKS: tuple[Check, ...] = (
    Check('secrets', (*PY, 'tools/research/research.py', 'secrets'), ('**',),
          note='every tracked file, for credential patterns'),
    Check('strict', (*PY, 'tools/research/research.py', 'check', '--strict-fresh'), ('**',), added=True, heavy=True,
          env=(('rg', '--version'),), unread=('tools/research/tests/**', '.github/**'),
          unread_when=((BOARD, 'same_headings'),),
          note='records, their sources and receipts, every generated page, the directory indexes and the Lean catalogue'),
    Check('links', (*PY, 'tools/research/research.py', 'links'), ('**/*.md', '**/.gitignore', '.gitattributes', *RESEARCH_TOOLS), added=True,
          note='relative links and anchors in Markdown: a target vanishes only by a deletion or a change to Markdown'),
    Check('board', (*PY, 'tools/research/gate.py', 'board'), (BOARD,),
          note='the board parses, its Queue line loses nothing but the head clause, it does not shrink sharply'),
    Check('frozen', (*PY, 'tools/research/gate.py', 'frozen'), (), derived='frozen_paths',
          note='every frozen file is the bytes its manifest names; nothing a pin froze has changed'),
    Check('receipt', (*PY, 'tools/research/gate.py', 'receipt'), (LEAN + '/**',),
          note='the committed core receipt passed and binds the bytes of every module it checks, so the core run ran on them'),
    Check('dossiers', (*PY, PACKET + '/check_dossiers.py'),
          (REVIEW + '/**', CORPUS + '/**', BECOMING + '/Becoming/**', LEAN + '/physics/**', LEAN + '/warning/**', LEAN + '/deeper/**',
           '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/one-unfolding-root/review-checks/**',
           PACKET + '/check_dossiers.py'), derived='quoted_paths',
          note="quotations, Lean names and Lean blocks in the review packet's dossiers"),
)
CHECKS = CHECKS[:3] + test_checks() + CHECKS[3:]
BY_NAME = {c.name: c for c in CHECKS}


@dataclass(frozen=True)
class Step:
    """A step that writes what the landing commits, so it runs before the gate (in a slot, `gate.py hold`)
    and its output is committed; the strict check then verifies that it ran."""
    name: str
    command: str
    reads: tuple
    note: str = ''
    follows: str = ''        # needed exactly when this check is selected (the render, when the strict check reads the change)
    when: str = ''           # name of a predicate (start, changed) -> bool that also selects it


STEPS: tuple[Step, ...] = (
    Step('core run', f'python3 -B tools/research/gate.py hold -- python3 -B {BECOMING}/check_becoming.py', (LEAN + '/**',),
         'commit its receipt and run folder; a record bound to a changed Lean file fails the strict check until then'),
    Step('shared laws', 'python3 -B tools/research/gate.py hold -- python3 -B tools/research/shared_laws.py',
         (LEAN + '/**', 'theories/becoming/results/completion/COVERAGE.json',
          '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou3b-master-laws-on-the-grammar/**',
          '_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY*',
          'tools/research/shared_laws.py', 'tools/research/boundary.py', 'tools/research/boundary_check.lean'),
         'after the core run passes: commit shared-laws.json; the check reports it stale but never fails on it', when='laws_changed'),
    Step('render', 'python3 -B tools/research/gate.py hold -- make research-render', (),
         'commit the pages it writes; the strict check fails on any page a render would change', follows='strict'),
)


# --- git -------------------------------------------------------------------------------------------------------

def git(*args, text=True, check=True, root=None):
    return subprocess.run(['git', *args], cwd=root or ROOT, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                          text=text, check=check).stdout


def common_dir() -> Path:
    path = Path(git('rev-parse', '--git-common-dir').strip())
    return path if path.is_absolute() else (ROOT / path).resolve()


def shared_checkout() -> bool:
    """Whether ROOT is the repository's main checkout, which other sessions fast-forward under one."""
    path = Path(git('rev-parse', '--git-dir').strip())
    return (path if path.is_absolute() else ROOT / path).resolve() == common_dir()


def state_dir() -> Path:
    d = Path(os.environ.get('GATE_DIR') or common_dir() / 'gate')
    d.mkdir(parents=True, exist_ok=True)
    return d


def tree(rev='HEAD') -> str:
    return git('rev-parse', rev + '^{tree}').strip()


def dirty() -> list[str]:
    """What makes the worktree more than its commit: uncommitted or untracked files, and ignored .lean files the Lean
    catalogue would read (it walks ignored files too, outside its EXCLUDED components). A pass is kept only for a
    worktree that is exactly its commit."""
    out = [line for line in git('status', '--porcelain', '--untracked-files=normal').splitlines() if line.strip()]
    from tools.research.lean_catalogue import EXCLUDED
    ignored = git('ls-files', '--others', '--ignored', '--exclude-standard', '-z', '--', '*.lean', '*.md').split('\0')
    docs = ('theories/', '_process/research/', 'experiments/')  # the Lean catalogue's documents
    out += [f'!! {p}' for p in ignored if p and not any(f'/{x}/' in f'/{p}' for x in EXCLUDED)
            and (p.endswith('.lean') or p.startswith(docs) or '/' not in p)]
    tracked_top = {p.split('/')[1] for p in files_at() if p.startswith('sources/') and p.count('/') >= 2}
    out += [f'!! sources/{d.name}/ (the sources index lists it; git tracks nothing in it)' for d in sorted((ROOT / 'sources').iterdir())
            if d.is_dir() and d.name not in tracked_top] if (ROOT / 'sources').is_dir() else []
    return out


def matches(path: str, patterns) -> bool:
    """`paths.matches` for git's paths, which are already POSIX and relative: literal patterns by equality,
    globs by `paths.glob_regex`."""
    return any(path == q if not GLOB.search(q) else paths.glob_regex(q).match(path) for q in patterns)


@lru_cache(maxsize=8)
def files_at(rev='HEAD') -> tuple:
    return tuple(p for p in git('ls-tree', '-r', '--name-only', '-z', rev).split('\0') if p)


def tracked(pattern: str, rev='HEAD') -> list[str]:
    rx = paths.glob_regex(pattern)
    return [p for p in files_at(rev) if rx.match(p)]


def changes(a: str, b: str) -> list[tuple[str, str]]:
    """(status, path) between two commits; a rename is a deletion and an addition."""
    out = git('diff', '--name-status', '-z', '--no-renames', a, b).split('\0')
    return [(out[i], out[i + 1]) for i in range(0, len(out) - 1, 2) if out[i]]


def base_commit(base: str) -> str:
    return git('merge-base', base, 'HEAD').strip()


# --- selection -------------------------------------------------------------------------------------------------

CODE = ('tools/research/*.py', '_process/research-config.json')  # every check runs the research tools or is read by them


def reads(check: Check) -> tuple:
    """Its globs (an optional one, marked '?', watches for a path that may appear), its derived paths, and its own
    code: the research tools and the script its command runs, which its pass's key holds too."""
    script = script_of(check)
    return (tuple(q.lstrip('?') for q in check.reads) + CODE + ((script,) if script else ())
            + tuple(globals()[check.derived]() if check.derived else ()))


def placed(path: str) -> bool:
    return matches(path, AREAS)


def same_headings(before: str, path: str) -> bool:
    """Whether the file's headings, which generated pages link by anchor, are those it had at `before`."""
    heads = lambda text: [l for l in text.splitlines() if l.startswith('#')]
    return heads(git('show', f'{before}:{path}', check=False)) == heads((ROOT / path).read_text())


def unread(check: Check, status: str, path: str, before) -> bool:
    if status != 'M':
        return False
    if matches(path, check.unread):
        return True
    return bool(before) and any(path == q and globals()[f](before, path) for q, f in check.unread_when)


def reached(check: Check, changed: list[tuple[str, str]], patterns=None, before=None) -> list[str]:
    """The changed paths that reach `check`; a path no area places reaches every check. `before` is the commit the
    changes are from, which a conditional unread rule needs; without it the rule does not apply."""
    patterns = reads(check) if patterns is None else patterns
    return [p for s, p in changed if (matches(p, patterns) and not unread(check, s, p, before))
            or (check.added and s in ('A', 'D')) or not placed(p)]


def script_of(check: Check) -> str | None:
    """The script a check's command runs, if it runs one; a test's command runs its test file. Neither a pattern
    argument (test_*.py) nor the value of -p is taken for a script."""
    args = list(check.command[len(PY):])
    if '-p' in args and args.index('-p') + 1 < len(args):
        name = args[args.index('-p') + 1]
        return None if GLOB.search(name) else f'tools/research/tests/{name}'
    return next((a for a in args if a.endswith('.py') and not GLOB.search(a)), None)


def stale_rules(checks=CHECKS) -> list[str]:
    """Rules naming what the tree lacks: a literal path that does not exist, a glob nothing tracked matches, a
    command's script that is gone. A stale rule could silently skip a check, so it fails the gate."""
    files = files_at()
    out = []
    for c in checks:
        for pattern in (q for q in c.reads if not q.startswith('?')):  # derived paths are their checks' own errors
            if GLOB.search(pattern):
                rx = paths.glob_regex(pattern)
                if not any(rx.match(p) for p in files):
                    out.append(f'{c.name}: no tracked file matches {pattern}')
            elif not (ROOT / pattern).exists():
                out.append(f'{c.name}: {pattern} does not exist')
        script = script_of(c)
        if script and not (ROOT / script).is_file():
            out.append(f'{c.name}: its command {script} does not exist')
    return out


def plan(base='main', checks=CHECKS, train=()) -> dict:
    start = base_commit(base)
    changed = changes(start, 'HEAD')
    selected = {}
    for c in checks:
        patterns = reads(c)
        hits = reached(c, changed, patterns, start)
        if hits:
            selected[c.name] = {'paths': hits[:8], 'count': len(hits), 'heavy': c.heavy}
            if train:  # which landing's own change reaches it, so a red names the landing to take off
                selected[c.name]['landings'] = [b for b in train if reached(c, changes(git('merge-base', base, b).strip(), b), patterns)]
    before = [{'step': s.name, 'command': s.command, 'note': s.note} for s in STEPS
              if ((s.follows in selected) if s.follows else any(matches(p, s.reads) or not placed(p) for _, p in changed))
              or (s.when and globals()[s.when](start, changed))]
    board_only = bool(changed) and all(p == BOARD for _, p in changed)
    return {'base': base, 'changed': len(changed), 'unplaced': [p for _, p in changed if not placed(p)][:20],
            'board_only': board_only, 'stale_rules': stale_rules(checks), 'before_the_gate': before,
            'selected': selected, 'skipped': [c.name for c in checks if c.name not in selected]}


# --- passes kept -----------------------------------------------------------------------------------------------

def code_hash(check: Check) -> str:
    """The checkers' own code: the research tools and the command's script, by blob. The tree already holds
    them; keying on them too keeps a pass reused across commits from outliving a change to its checker."""
    script = script_of(check) or ''
    listing = '\n'.join(l for l in git('ls-tree', '-r', 'HEAD', '--', 'tools/research', *([script] if script else [])).splitlines()
                         if '\ttools/research/tests/' not in l or (script and l.endswith('\t' + script)))  # not the tests, but a test's own file
    return hashlib.sha256(listing.encode()).hexdigest()[:16]


def environment(check: Check, command=None) -> dict:
    """The pass's key beyond the tree: Python, the command as run (its arguments included), the checkers' code and any
    tool versions the check names."""
    env = {'python': platform.python_version(), 'command': list((command or check.command)[len(PY):]), 'code': code_hash(check)}
    for cmd in check.env:
        try:
            env[cmd[0]] = subprocess.run(list(cmd), cwd=ROOT, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL,
                                         text=True, timeout=60).stdout.strip()
        except (OSError, subprocess.SubprocessError):
            env[cmd[0]] = None
    return env


def key(check: Check, env: dict) -> str:
    return hashlib.sha256(json.dumps([check.name, env], sort_keys=True).encode()).hexdigest()[:16]


def passes_dir(check: Check, env: dict) -> Path:
    d = state_dir() / 'passes' / f'{check.name}-{key(check, env)}'
    d.mkdir(parents=True, exist_ok=True)
    return d


def is_ancestor(a: str, b: str = 'HEAD') -> bool:
    return subprocess.run(['git', 'merge-base', '--is-ancestor', a, b], cwd=ROOT,
                          stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode == 0


def reusable(check: Check, env: dict, across=True, limit=40) -> dict | None:
    """A kept pass that holds for HEAD: on the same tree, or (with `across`) on an ancestor commit whose diff
    to HEAD reaches nothing this check reads."""
    here = tree()
    exact = passes_dir(check, env) / f'{here}.json'
    kept = ([exact] if exact.is_file() else []) + (sorted(passes_dir(check, env).glob('*.json'),
                                                         key=lambda p: p.stat().st_mtime, reverse=True)[:limit] if across else [])
    for p in kept:
        try:
            entry = json.loads(p.read_text())
        except (OSError, ValueError):
            continue
        commit = entry.get('commit')
        if not commit or not is_ancestor(commit):
            continue  # the drift check reads history: a pass holds only where its commit's history is HEAD's
        if entry.get('tree') == here:
            return entry
        if not reached(check, changes(commit, 'HEAD'), before=commit):
            return {**entry, 'reused_across': git('rev-parse', '--short', commit).strip()}
    return None


def keep(check: Check, env: dict, seconds: float, ran_on: tuple):
    """Keep a pass for the (tree, commit) the check began on, and only if HEAD is still that commit."""
    if (tree(), git('rev-parse', 'HEAD').strip()) != ran_on:
        return
    entry = {'check': check.name, 'tree': ran_on[0], 'commit': ran_on[1], 'seconds': round(seconds, 1),
             'utc': _dt.datetime.now(_dt.timezone.utc).strftime('%Y%m%dT%H%M%SZ'), 'env': env}
    target = passes_dir(check, env) / f'{entry["tree"]}.json'
    temporary = target.with_name(f'.{target.name}.{os.getpid()}')
    temporary.write_text(json.dumps(entry, indent=1))
    os.replace(temporary, target)


# --- slots -----------------------------------------------------------------------------------------------------

def slot_count() -> int:
    try:
        return max(1, int(os.environ.get('GATE_SLOTS', '2')))
    except ValueError:
        return 2


def holders() -> list[dict]:
    """What holds each slot now. A lock whose holder died is free: the kernel releases it."""
    d = state_dir() / 'slots'
    out = []
    for p in sorted(d.glob('slot-*.lock')) if d.is_dir() else []:
        with p.open('a+') as stream:
            try:
                fcntl.flock(stream, fcntl.LOCK_EX | fcntl.LOCK_NB)
                fcntl.flock(stream, fcntl.LOCK_UN)
            except BlockingIOError:
                stream.seek(0)
                try:
                    out.append(json.loads(stream.read() or '{}'))
                except ValueError:
                    out.append({'slot': p.name})
    return out


@contextmanager
def slot(label: str, wait=10.0):
    """One of the slots, held while the body runs; a run identical to one held now (same tree, same command) is
    refused rather than started twice."""
    d = state_dir() / 'slots'
    d.mkdir(exist_ok=True)
    me = {'pid': os.getpid(), 'run': label, 'root': str(ROOT), 'tree': tree()}
    waited, said = 0.0, -60.0
    while True:
        meta = (d / 'claim.lock').open('a+')
        fcntl.flock(meta, fcntl.LOCK_EX)  # the twin check and the taking of a slot as one step
        twin = next((h for h in holders() if h.get('run') == label and h.get('tree') == me['tree']), None)
        if twin:
            meta.close()
            raise ValueError(f'the same run is already in a slot (pid {twin.get("pid")}, {twin.get("root")}); '
                             'wait for it rather than starting a second copy')
        taken = None
        for i in range(slot_count()):
            stream = (d / f'slot-{i}.lock').open('a+')
            try:
                fcntl.flock(stream, fcntl.LOCK_EX | fcntl.LOCK_NB)
            except BlockingIOError:
                stream.close()
                continue
            stream.seek(0)
            stream.truncate()
            stream.write(json.dumps({**me, 'since': _dt.datetime.now(_dt.timezone.utc).strftime('%Y%m%dT%H%M%SZ')}))
            stream.flush()
            taken = (i, stream)
            break
        meta.close()
        if taken:
            i, stream = taken
            try:
                yield i
            finally:
                stream.seek(0)
                stream.truncate()
                fcntl.flock(stream, fcntl.LOCK_UN)
                stream.close()
            return
        if waited - said >= 60:
            print(f'gate: waiting for a slot for {label} ({slot_count()} held: gate.py status)', file=sys.stderr, flush=True)
            said = waited
        time.sleep(wait)
        waited += wait


def hold(command: list[str]) -> int:
    with slot(' '.join(command)):
        return subprocess.run(command, cwd=ROOT).returncode


# --- the checks the gate itself runs ---------------------------------------------------------------------------

def queue_line(text: str) -> str:
    return next((l[len('- **Queue:**'):].strip() for l in text.splitlines() if l.startswith('- **Queue:**')), '')


def clauses(line: str) -> list[str]:
    """The Queue line cut at '.' or ';' outside brackets: a head clause is its first."""
    out, depth, start = [], 0, 0
    for i, ch in enumerate(line):
        depth += ch in '([' and 1 or ch in ')]' and -1 or 0
        if depth <= 0 and ch in '.;' and (i + 1 == len(line) or line[i + 1] == ' '):
            out.append(line[start:i + 1].strip())
            start = i + 1
            depth = 0
    if line[start:].strip():
        out.append(line[start:].strip())
    return out


ORDER = 'Then, in the coordinator'
HEAD_CLAUSE = re.compile(r'\blanding (?:run )?now\b|\b(?:at|holds) the head of the queue \(')  # how head clauses have been worded


def clause_key(clause: str) -> str:
    """A clause as compared: its closing '.' or ';' set aside, which changes as clauses move along the line, and its
    spaces collapsed."""
    return ' '.join(clause.rstrip('.;').split())


def item_of(clause: str) -> str:
    """The item a clause is about: its first word, a possessive set aside ("OU3d's landing run now" is OU3d's)."""
    word = clause.split(' ', 1)[0]
    return word[:-2] if word.endswith("'s") else word


def board_check(base='main', shrink=0.8) -> dict:
    """The board after the change against the board at the base: it has its sections and one Queue line; the
    Queue line keeps every clause but the head clause (a landed clause replaces only the head clause); it is not
    a fifth shorter (landed rows that move to history are a few kilobytes each). GATE_BOARD_REWRITE='reason'
    accepts a deliberate rewrite, and the reason is printed with the pass."""
    old = git('show', f'{base_commit(base)}:{BOARD}', check=False)
    new = (ROOT / BOARD).read_text()
    errors = []
    for heading in ('## Rules', '## Now', '## Open claims', '## Landing queue', '## Decisions pending Ren'):
        if heading not in new:
            errors.append(f'the board has lost its section "{heading}"')
    if sum(l.startswith('- **Queue:**') for l in new.splitlines()) != 1:
        errors.append('the board must have exactly one Queue line')
    a, bl = clauses(queue_line(old)), clauses(queue_line(new))
    b = {clause_key(c) for c in bl}
    promoted = {item_of(c) for c in bl if HEAD_CLAUSE.search(c)}
    # A head clause (one per landing of a train, wherever the rule of its day put it) is replaced by its landed clause,
    # and a waiting clause ("RAE behind GT and AA") by its item's head clause;
    # the closing order ("Then, in the coordinator's order …") is the coordinator's to rewrite. Every other clause
    # stays, whole: clauses are compared with clauses, so one recurring inside another is still missed when it goes.
    end = next((i for i, c in enumerate(a) if c.startswith(ORDER)), len(a))
    lost = [c for c in a[:end] if clause_key(c) not in b and not HEAD_CLAUSE.search(c) and item_of(c) not in promoted]
    if lost:
        errors.append(f'the Queue line lost {len(lost)} clause(s) besides the head clause, {sum(map(len, lost))} '
                      f'characters, beginning: {lost[0][:160]!r}')
    if old and len(new) < shrink * len(old):
        errors.append(f'the board shrank from {len(old)} to {len(new)} characters')
    rewrite = os.environ.get('GATE_BOARD_REWRITE', '').strip()
    held = []
    first = clauses(queue_line(old))[:1]
    if first and HEAD_CLAUSE.search(first[0]) and changes(base_commit(base), 'HEAD') == [('M', BOARD)]:
        held.append('a clause holds the head; a board-only commit waits for a gap')
    return {'errors': held + ([] if rewrite else errors), 'accepted_rewrite': rewrite or None, 'would_fail': errors if rewrite else []}


FREEZE_RECORDS = ('experiments/**/*FROZEN*.sha256', 'experiments/**/*.json', 'experiments/**/*FROZEN-AT')
SHA = re.compile(r'[0-9a-f]{64}')
FREEZE_JSON = re.compile(r'(?i)freeze[^/]*\.json$')  # FREEZE.json, DISPATCH-FREEZE.json, protocol-freeze.json


def show(rev: str, path: str) -> str | None:
    out = subprocess.run(['git', 'show', f'{rev}:{path}'], cwd=ROOT, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
    return out.stdout.decode(errors='replace') if out.returncode == 0 else None


def entries_of(path: str, text: str) -> list[tuple[str, str]]:
    """A manifest's (path, sha256) entries: FROZEN.sha256 lines, or a freeze JSON's `files`, `sources` or
    `source_sha256`, each a list of {path, sha256} or a mapping of path to sha256 (or to {sha256}). A JSON whose hashes
    name no path yields none and is listed as unverified."""
    if path.endswith('.sha256'):
        return [(parts[1].strip().lstrip('*'), parts[0]) for parts in (line.split(None, 1) for line in text.splitlines() if line.strip())
                if len(parts) == 2]
    try:
        data = json.loads(text)
    except ValueError:
        return []
    out = []
    for files in (data.get(k) for k in ('files', 'sources', 'source_sha256')) if isinstance(data, dict) else ():
        if isinstance(files, dict):
            out += [(k, v if isinstance(v, str) else v.get('sha256')) for k, v in files.items()
                    if (isinstance(v, str) and SHA.fullmatch(v)) or (isinstance(v, dict) and isinstance(v.get('sha256'), str))]
        elif isinstance(files, list):
            out += [(f['path'], f['sha256']) for f in files
                    if isinstance(f, dict) and isinstance(f.get('path'), str) and isinstance(f.get('sha256'), str)]
    return out


@lru_cache(maxsize=8)
def manifests(rev='HEAD') -> dict:
    """Each freeze manifest at `rev` (a *FROZEN*.sha256, or a .json whose name contains 'freeze' in any case) and its
    (path, sha256) entries; an entry's path is repository-relative, or relative to the manifest's folder when the tree
    has no such repository path."""
    files = set(files_at(rev))
    out = {}
    for m in tracked(FREEZE_RECORDS[0], rev) + [p for p in tracked(FREEZE_RECORDS[1], rev) if FREEZE_JSON.search(p)]:
        if paths.role(m) != 'live':
            continue  # a record inside a run folder or history is evidence of that run, not a freeze on the live tree
        folder = m.rsplit('/', 1)[0]
        out[m] = [(e if e in files or f'{folder}/{e}' not in files else f'{folder}/{e}', sha)
                  for e, sha in entries_of(m, show(rev, m) or '')]
    return out


@lru_cache(maxsize=8)
def pins(rev='HEAD') -> dict:
    """Each pin at `rev` (FROZEN-AT, round2-FROZEN-AT, ...), with the experiment it froze (experiments/<name>)."""
    return {p: '/'.join(p.split('/')[:2]) for p in tracked(FREEZE_RECORDS[2], rev) if paths.role(p) == 'live'}


def pinned_commits(text: str) -> tuple[list[str], list[str]]:
    """The commits a pin names (it may name several, one per round), and the tokens that name none."""
    found, bad = [], []
    for token in dict.fromkeys(re.findall(r'\b[0-9a-f]{7,40}\b', text)):
        commit = git('rev-parse', '--verify', '-q', token + '^{commit}', check=False).strip()
        (found if commit else bad).append(commit or token)
    return found, bad


def salvaged(commit: str) -> bool:
    """Whether a commit is kept under refs/salvage/ (a pre-rebase original a pin names beside the rebased one)."""
    return bool(git('for-each-ref', '--contains', commit, '--format=%(refname)', 'refs/salvage/', check=False).strip())


LINK_TARGET = re.compile(r'\]\([^)\s]*\)')


def link_only(path: str, sha: str) -> bool:
    """Whether a frozen Markdown file differs from its frozen bytes only in link targets, as the repository's moves
    rewrite them: the frozen version is found in HEAD's history by its sha256 (registry.reviewed_version) and the two
    are compared with every `](…)` target set aside. Any other difference is a content change."""
    if not path.endswith('.md'):
        return False
    from tools.research import registry
    try:
        frozen = registry.reviewed_version(path, sha)
    except (OSError, ValueError, subprocess.CalledProcessError):
        return False
    if frozen is None:
        return False
    strip = lambda text: LINK_TARGET.sub('](…)', text)
    return strip(frozen) == strip((ROOT / path).read_text(errors='replace'))


def pinned_parent(manifest: str) -> str | None:
    """The commit a freeze JSON binds its sources to (`parent_commit`, `accepted_parent_commit`), if it names one."""
    try:
        data = json.loads(show('HEAD', manifest) or '{}')
    except ValueError:
        return None
    for k in ('parent_commit', 'accepted_parent_commit'):
        if isinstance(data, dict) and isinstance(data.get(k), str):
            commit = git('rev-parse', '--verify', '-q', data[k] + '^{commit}', check=False).strip()
            if commit:
                return commit
    return None


def sha_at(rev: str, path: str) -> str | None:
    out = subprocess.run(['git', 'show', f'{rev}:{path}'], cwd=ROOT, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
    return hashlib.sha256(out.stdout).hexdigest() if out.returncode == 0 else None


def ever_frozen(path: str, sha: str) -> bool:
    """Whether the file was ever committed at the bytes its record names (HEAD's history, its former paths included)."""
    from tools.research import registry
    try:
        return registry.reviewed_version(path, sha) is not None
    except (OSError, ValueError, subprocess.CalledProcessError):
        return True  # unknown: judged as an ordinary change


REBASED = re.compile(r'(?:on main, rebased,|rebased onto main as)\s+([0-9a-f]{7,40})')


def acknowledged() -> set:
    """The paths GATE_FROZEN_ACK names: entries separated by ';' or new lines, each 'path' or 'path: reason'."""
    raw = os.environ.get('GATE_FROZEN_ACK', '')
    return {e.split(':', 1)[0].strip() for e in re.split(r'[;\n]', raw) if e.strip()}


def frozen_check(base='main', everything=False) -> dict:
    """Every freeze, read from its own files, judged by what this landing does to it. The landing fails if it deletes
    or edits a freeze record (a manifest or a pin); if it changes a file a manifest lists, or a file a pin's experiment
    held at a pinned commit, unless GATE_FROZEN_ACK names that file with the reason; if a manifest it touches has an
    entry that is not the bytes it names; or if it changes a folder whose freeze the check cannot read. What already
    stands on main (an entry whose bytes moved on long after its experiment ran, a pin naming no commit in main's
    history) is listed for its owner and never fails: a landing cannot cause it, and history is not undone by a gate.
    With `everything` (the full set) the standing list is given whole, with each pinned file changed since its pin."""
    errors, standing, unverified, links, moved, never = [], [], [], [], [], []
    start = base_commit(base)
    changed = changes(start, 'HEAD')
    touched = {p for _, p in changed}
    modified = {p for s, p in changed if s != 'A'}
    ack = acknowledged()
    before, now = manifests(start), manifests()
    for m in before:
        if m not in now and m not in ack:
            errors.append(f'{m}: a freeze manifest was deleted')
        elif m in now and before[m] != now[m] and m not in ack:
            errors.append(f'{m}: a freeze manifest was edited; name it in GATE_FROZEN_ACK with the reason if that is meant')
    unverified += [f'{p}: named like a freeze record, read by no rule' for p in files_at()
                   if p.startswith('experiments/') and paths.role(p) == 'live' and re.search(r'(?i)froze|freeze', p.rsplit('/', 1)[-1])
                   and p not in now and p not in pins() and not p.endswith(('.md', '.py'))][:40]
    for m, entries in now.items():
        if not entries:
            unverified.append(f'{m}: no entries read')
            if any(p.startswith(m.rsplit('/', 1)[0] + '/') for p in touched) and m not in ack:
                errors.append(f'{m}: a freeze the check cannot read, in a folder this landing changes; read it and name it '
                              'in GATE_FROZEN_ACK with the reason')
        mine = m in touched or any(p in touched for p, _ in entries)
        parent = pinned_parent(m)
        for p, sha in entries:
            f = ROOT / p
            now = hashlib.sha256(f.read_bytes()).hexdigest() if f.is_file() else None
            if parent and sha_at(parent, p) is not None:
                # a record bound to a parent commit: its sources are judged there, and may move on after it; one written
                # after the parent to its frozen bytes, or differing from them in link targets only, holds too
                if sha_at(parent, p) == sha:
                    if now != sha:
                        moved.append(f'{m}: {p} moved on since its pinned parent {parent[:9]}')
                elif now == sha:
                    pass
                elif link_only(p, sha):
                    links.append(f'{m}: {p} differs from its frozen bytes in link targets only')
                else:
                    (errors if mine and p not in ack else standing).append(f'{m}: {p} is at its frozen bytes neither at its pinned parent {parent[:9]} nor now')
                continue
            if f.is_file() and hashlib.sha256(f.read_bytes()).hexdigest() != sha and link_only(p, sha):
                links.append(f'{m}: {p} differs from its frozen bytes in link targets only')
                continue  # a move rewrote its links; its content is the frozen content
            if f.is_file() and hashlib.sha256(f.read_bytes()).hexdigest() != sha and p not in modified and not ever_frozen(p, sha):
                never.append(f'{m}: {p} was never at its frozen bytes in history (the record states a state before its first commit)')
                continue
            if p in modified and p not in ack and m not in touched:
                errors.append(f'{m}: this landing changes {p}, which it froze; if that is meant, name it in GATE_FROZEN_ACK with the reason')
                continue
            problem = (f'{m}: {p} is missing' if not f.is_file() else
                       f'{m}: {p} is not the bytes frozen' if hashlib.sha256(f.read_bytes()).hexdigest() != sha else None)
            if problem:
                (errors if mine and p not in ack else standing).append(problem)
    for pin in pins(start):
        if pin not in pins() and pin not in ack:
            errors.append(f'{pin}: a pin was deleted')
    for pin, folder in pins().items():
        mine = pin in touched  # a pin this landing adds is judged as this landing's
        commits, bad = pinned_commits((ROOT / pin).read_text(errors='replace'))
        if not commits:
            (errors if mine else standing).append(f'{pin}: names no commit')
            continue
        if not any(is_ancestor(c) for c in commits):  # a pin may name a pre-rebase or salvage commit beside the one on main
            (errors if mine else standing).append(f'{pin}: names no commit in HEAD\'s history')
        for x in REBASED.findall((ROOT / pin).read_text(errors='replace')):
            c = git('rev-parse', '--verify', '-q', x + '^{commit}', check=False).strip()
            if not c or not is_ancestor(c):
                (errors if mine else standing).append(f'{pin}: its rebased commit {x} is not in HEAD\'s history')
        for c in commits:
            if not is_ancestor(c) and not salvaged(c):
                (errors if mine else standing).append(f'{pin}: {c[:9]} is neither in HEAD\'s history nor kept under refs/salvage/')
        if any(p == pin for s, p in changed if s != 'A'):
            errors.append(f'{pin}: a pin is committed once and never changed')
        held = set().union(*(set(git('ls-tree', '-r', '--name-only', '-z', c, '--', folder).split('\0')) - {''} for c in commits))
        for s, p in changed:
            if p in held and p != pin and p not in ack:
                errors.append(f'{pin}: changes {p}, which {folder} held at a pinned commit; if it is not frozen, '
                              'name it in GATE_FROZEN_ACK with the reason')
        if everything:
            since = {p for c in commits if is_ancestor(c) for _, p in changes(c, 'HEAD')} & held - {pin} - ack
            standing += [f'{pin}: {p} changed on main since its pin' for p in sorted(since)]
    by_record = {}
    for s in standing:
        by_record[s.split(':', 1)[0]] = by_record.get(s.split(':', 1)[0], 0) + 1
    return {'errors': errors, 'standing': standing if everything else sorted(f'{k}: {n}' for k, n in by_record.items()),
            'link_only': links, 'moved_on_since_parent': moved, 'never_at_frozen_bytes': never,
            'unverified': unverified, 'acknowledged': sorted(ack) or None}


def receipt_check(base='main') -> dict:
    """The package's receipts. The core's (becoming-verification.json) passed and binds the current bytes of every
    module it lists, so the core run ran on this Lean; a module under Becoming/ no receipt lists fails too. Another
    checker's receipt beside it (fallible-inquiry-verification.json) fails where this landing changes a source of its
    own that the core's does not list; where only the core modules it imports moved on, it is listed as an area check
    to run again."""
    errors, rerun, listed, seen = [], [], set(), {}
    touched = {p for _, p in changes(base_commit(base), 'HEAD')}
    core = BECOMING + '/becoming-verification.json'
    receipts = sorted(str(r.relative_to(ROOT)) for r in (ROOT / BECOMING).glob('*-verification.json'))
    core_sources = set((json.loads((ROOT / core).read_text()).get('source_paths') or {}).values()) if (ROOT / core).is_file() else set()
    for r in receipts:
        v = json.loads((ROOT / r).read_text())
        seen[r.rsplit('/', 1)[-1]] = v.get('utc')
        (errors if r == core else rerun).extend([f'{r}: its status is {v.get("status")!r}'] if v.get('status') != 'passed' else [])
        for name, rel in (v.get('source_paths') or {}).items():
            path, f = f'{LEAN}/{rel}', ROOT / LEAN / rel
            listed.add(path)
            if f.is_file() and hashlib.sha256(f.read_bytes()).hexdigest() == (v.get('source_sha256') or {}).get(name):
                continue
            problem = f'{r}: {path} is {"missing" if not f.is_file() else "not the bytes its checker ran on"}'
            if r == core or (path in touched and rel not in core_sources):
                errors.append(problem + ('; run the core run and commit its receipt' if r == core else '; run its checker'))
            else:
                rerun.append(problem)
    errors += [f'{p}: a module under Becoming/ that no receipt lists' for p in tracked(BECOMING + '/Becoming/*.lean') if p not in listed]
    return {'errors': errors, 'area_checks_to_rerun': sorted({x.split(':', 1)[0] for x in rerun}),
            'stale': len(rerun), 'receipts': seen}


# --- run ---------------------------------------------------------------------------------------------------------

def run(base='main', full=False, fresh=False, only=None, checks=CHECKS, train=(), keep_passes=True) -> tuple[int, dict]:
    if shared_checkout() and not os.environ.get('GATE_IN_SHARED_CHECKOUT'):
        return 1, {'errors': ['run the gate in a clean worktree of the merged commit, never the shared checkout']}
    unclean = dirty()
    if unclean and keep_passes:
        return 1, {'errors': ['the tree has uncommitted or untracked files; commit them or move them aside, so a pass '
                              'belongs to one tree'] + unclean[:20]}
    planned = plan(base, checks, train)
    if planned['stale_rules']:
        return 1, {'errors': ['a rule names what the tree lacks; fix the rule (GATE.md §3.1)'] + planned['stale_rules']}
    chosen = planned['selected'] if not full else {c.name: {'paths': ['(full)']} for c in checks}
    if only:
        chosen = {n: v for n, v in chosen.items() if n in only}
    results, failed = {}, []
    logs = state_dir() / 'logs'
    logs.mkdir(exist_ok=True)
    for c in checks:
        if c.name not in chosen:
            continue
        command = [*c.command, *(('--base', base) if c.name in ('board', 'frozen', 'receipt') else ()), *(('--all',) if full and c.name == 'frozen' else ())]
        env = environment(c, command)
        prior = None if fresh else reusable(c, env, across=not full)
        if prior:
            results[c.name] = {'status': 'reused', 'from': prior.get('reused_across') or prior['tree'][:12], 'utc': prior['utc']}
            continue
        log = logs / f'{c.name}-{tree()[:12]}.log'
        ran_on = (tree(), git('rev-parse', 'HEAD').strip())
        start = time.monotonic()

        def execute():
            with log.open('w') as out:
                return subprocess.run(['nice', '-n', '10', *command], cwd=ROOT, stdout=out, stderr=subprocess.STDOUT).returncode
        if c.heavy:
            with slot(c.name):
                code = execute()
        else:
            code = execute()
        seconds = time.monotonic() - start
        results[c.name] = {'status': 'passed' if code == 0 else 'failed', 'exit': code, 'seconds': round(seconds, 1),
                           'log': str(log), 'reached_by': chosen[c.name].get('paths'), 'landings': chosen[c.name].get('landings')}
        if code == 0 and keep_passes and not dirty():
            keep(c, env, seconds, ran_on)
        if code != 0:
            failed.append(c.name)
    note = ('A red under load: rerun that check alone (--only NAME) before calling it a failure. '
            'In a train, the landings listed under a failing check are the ones whose change reaches it.')
    return (1 if failed else 0), {'tree': tree()[:12], 'base': base, 'full': full, 'results': results, 'failed': failed,
                                  'before_the_gate': planned['before_the_gate'], 'note': note if failed else None}


# --- restatements --------------------------------------------------------------------------------------------------

ANCHOR = re.compile(r'<a id="(r-[^"]+)"></a>')
STUDIES = ('_process/research/',)
SAID = ('title', 'statement', 'laws', 'hypotheses', 'does_not_show', 'counterexamples', 'standard_boundaries', 'status', 'kind')


def said(rev: str, path: str) -> dict:
    """The fields of a record that a page restating it repeats."""
    try:
        data = json.loads(git('show', f'{rev}:{path}'))
    except (subprocess.CalledProcessError, ValueError):
        return {}
    return {k: data.get(k) for k in SAID} if isinstance(data, dict) else {}


ANY_ANCHOR = re.compile(r'<a id="[^"]+"></a>')


def bare_anchor(line: str) -> bool:
    return bool(ANY_ANCHOR.search(line)) and not ANY_ANCHOR.sub('', line).strip()


LAWS = ('laws', 'statements_at_model', 'boundary')


def laws_changed(start: str, changed) -> bool:
    """Whether a record's laws, its statements at the model or its boundary changed: what the shared-laws data reads
    of records (RESULT-WORKFLOW, "Shared laws under each law")."""
    def of(rev, p):
        text = show(rev, p)
        try:
            data = json.loads(text) if text else {}
        except ValueError:
            return None
        return {k: data.get(k) for k in LAWS} if isinstance(data, dict) else None
    return any(of(start, p) != of('HEAD', p) for s, p in changed
               if p.startswith('theories/becoming/results/records/') and p.endswith('.json'))


def blocks(lines: list[str]) -> list[tuple[set, int, int]]:
    """The home sections of a page, numbered from 1: a table row carrying `r-<id>` anchors is the home of those
    records; otherwise an anchor's block runs from it to the next anchor of any kind or heading. Anchors on bare lines
    stacked together, or over the heading they name, share one block, as do several anchors on one line."""
    out, current, first, previous = [], set(), 0, ''

    def close(last):
        nonlocal current
        if current:
            out.append((current, first, last))
            current = set()
    for n, line in enumerate(lines, 1):
        ids = set(ANCHOR.findall(line))
        if line.lstrip().startswith('|'):
            if ids:
                out.append((ids, n, n))
        else:
            if (ANY_ANCHOR.search(line) or line.startswith('#')) and not bare_anchor(previous):
                close(n - 1)
            if ids:
                if not current:
                    first = n
                current |= ids
        if line.strip():
            previous = line
    close(len(lines))
    return out


def restated(base='main') -> dict:
    """Live pages that restate what the change rewrote: for each home section (an `r-<id>` anchor's block) with a
    changed line, and each record whose said fields changed, the other live Markdown lines that link it, read at HEAD.
    Studies record past work and are left out, and so is the home section itself. A report for a reader other than the
    author, never a failure."""
    start = base_commit(base)
    touched, own = set(), {}
    for status, p in changes(start, 'HEAD'):
        if status == 'D':
            continue
        if p.startswith('theories/becoming/results/records/') and p.endswith('.json'):
            if status == 'A' or said(start, p) != said('HEAD', p):  # a re-point changes no field a page restates
                touched.add('r-' + Path(p).stem)
        elif p.endswith('.md') and paths.role(p) == 'live':
            lines = (show('HEAD', p) or '').splitlines()
            hunks = [tuple(int(x or 1) for x in m.groups()) for m in
                     re.finditer(r'^@@ -\S+ \+(\d+)(?:,(\d+))? @@', git('diff', '-U0', start, 'HEAD', '--', p), re.M)]
            changed = {n for first, count in hunks for n in range(first, first + max(count, 1))}
            for ids, first, last in blocks(lines):
                own.setdefault(p, []).append((ids, first, last))
                if changed & set(range(first, last + 1)):
                    touched |= ids
    found = {}
    if touched:
        pattern = '|'.join(re.escape(a) for a in sorted(touched)) + '|' + '|'.join(
            re.escape('records/' + a[2:] + '.md') for a in sorted(touched))
        out = subprocess.run(['git', 'grep', '-n', '-E', pattern, 'HEAD', '--', '*.md'], cwd=ROOT,
                             stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True).stdout
        for line in out.splitlines():
            _, p, n, text = line.split(':', 3)
            if paths.role(p) != 'live' or p.startswith(STUDIES):
                continue  # a study records past work; it is not kept in step with its sources
            for a in touched:
                links = re.search('#' + re.escape(a) + r'(?![\w-])', text) or f'records/{a[2:]}.md' in text
                home = any(a in ids and first <= int(n) <= last for ids, first, last in own.get(p, ()))
                if links and not home:
                    found.setdefault(a, []).append(f'{p}:{n}')
    return {'sections': sorted(touched), 'restated_at': {a: v[:30] for a, v in sorted(found.items())},
            'note': 'Re-read each line against its home, by a reader other than the author (RESULT-WORKFLOW, Integration and concurrent sessions).'}


REMOTE = os.environ.get('GATE_PUSH_REMOTE', 'git@github.com:yongxu/theories.git')


CORE_RECEIPT = re.compile(re.escape(BECOMING) + r'/becoming-checks/(\d{8}T\d{6}\.\d{6}Z)/verification\.json')


def core_receipt(path: str, tip: str) -> bool:
    """Whether a new file is a core run's receipt: at becoming-checks/<stamp>/verification.json, a JSON object whose
    `utc` is that stamp. Every core run adds one of about 5.3 MB, which the screen's size rule would flag."""
    m = CORE_RECEIPT.fullmatch(path)
    if not m:
        return False
    try:
        data = json.loads(git('show', f'{tip}:{path}'))
    except (ValueError, subprocess.CalledProcessError):
        return False
    return isinstance(data, dict) and data.get('utc') == m[1]


def push(tip='HEAD', base=None) -> tuple[int, dict]:
    """The push screen (tools/research/push_screen.sh, the coordinator's, unchanged) from the remote's main to `tip`.
    The base is read from the remote itself (`git ls-remote`), since a push by URL leaves refs/remotes stale. A binary
    or a new file over 2 MB is a finding to look at: one named in GATE_PUSH_ACK passes, and so does a core run's
    receipt (`core_receipt`); every other finding fails. Pushing stays Ren's."""
    if base is None:
        out = subprocess.run(['git', 'ls-remote', REMOTE, 'refs/heads/main'], cwd=ROOT, stdout=subprocess.PIPE,
                             stderr=subprocess.PIPE, text=True, timeout=120)
        if out.returncode != 0 or not out.stdout.split():
            return 1, {'errors': [f'cannot read the remote\'s main from {REMOTE}: {out.stderr.strip()[:200]}']}
        base = out.stdout.split()[0]
    if subprocess.run(['git', 'cat-file', '-e', base + '^{commit}'], cwd=ROOT, stderr=subprocess.DEVNULL).returncode != 0:
        return 1, {'errors': [f'the remote\'s main {base[:12]} is not here; fetch it first']}
    run_ = subprocess.run(['bash', str(ROOT / 'tools/research/push_screen.sh'), base, tip], cwd=ROOT,
                          stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    lines = run_.stdout.splitlines()
    ack = {e.split(':', 1)[0].strip() for e in re.split(r'[;\n]', os.environ.get('GATE_PUSH_ACK', '')) if e.strip()}
    sections, current = {}, None
    for line in lines:
        if line.endswith(':') and not line.startswith(' '):
            current = line[:-1]
            sections[current] = []
        elif current:
            sections[current].append(line)
    binaries = sections.pop('binary files (look at each)', [])
    large = [line.rsplit(' ', 1)[0] for line in sections.pop('files over 2 MB', [])]
    receipts = [f for f in large if core_receipt(f, tip)]
    other = {k: v for k, v in sections.items() if v} or ({'not a fast-forward': [l for l in lines if l.startswith('not a fast-forward')]}
                                                      if any(l.startswith('not a fast-forward') for l in lines) else {})
    unacked = [b for b in binaries if b not in ack]
    large_unacked = [f for f in large if f not in ack and f not in receipts]
    code = 0 if run_.returncode == 0 or (not other and not unacked and not large_unacked) else 1
    return code, {'base': base[:12], 'tip': git('rev-parse', '--short', tip).strip(), 'screen': lines,
                  'binaries_acknowledged': sorted(set(binaries) & ack), 'binaries_to_look_at': unacked,
                  'core_receipts_passed': receipts, 'large_acknowledged': sorted(set(large) & ack - set(receipts)),
                  'large_to_look_at': large_unacked, 'other_findings': other}


def status() -> dict:
    d = state_dir()
    kept = {p.name: len(list(p.glob('*.json'))) for p in sorted((d / 'passes').glob('*'))} if (d / 'passes').is_dir() else {}
    return {'slots': slot_count(), 'held': holders(), 'passes_kept': kept, 'dir': str(d)}


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = parser.add_subparsers(dest='command', required=True)
    for name in ('plan', 'run', 'restated', 'board', 'frozen', 'receipt'):
        p = sub.add_parser(name)
        p.add_argument('--base', default='main')
    sub.choices['frozen'].add_argument('--all', action='store_true', help='fail on every freeze, not only those the change touches')
    for name in ('plan', 'run'):
        sub.choices[name].add_argument('--train', nargs='+', default=(), help='the train\'s branches, in the Queue line\'s order')
    sub.choices['run'].add_argument('--full', action='store_true', help='every check: at a phase end, before a push')
    sub.choices['run'].add_argument('--fresh', action='store_true', help='with --full, reuse no pass')
    sub.choices['run'].add_argument('--only', nargs='+', choices=sorted(BY_NAME))
    p = sub.add_parser('push', help='the push screen from the remote\'s main to a tip (pushing itself is Ren\'s)')
    p.add_argument('--tip', default='HEAD')
    p.add_argument('--base', help='the remote main, where the remote cannot be read')
    p = sub.add_parser('hold')
    p.add_argument('cmd', nargs=argparse.REMAINDER)
    sub.add_parser('status')
    args = parser.parse_args(argv)
    if args.command == 'hold':
        cmd = args.cmd[1:] if args.cmd[:1] == ['--'] else args.cmd
        if not cmd:
            parser.error('give the command after --')
        return hold(cmd)
    if args.command == 'push':
        code, result = push(args.tip, args.base)
        print(json.dumps(result, ensure_ascii=False, indent=2))
        return code
    if args.command == 'plan':
        result, code = plan(args.base, train=args.train), 0
    elif args.command == 'run':
        code, result = run(args.base, args.full, args.fresh, args.only, train=args.train)
        if not args.full:
            result['restated'] = restated(args.base)
    elif args.command == 'restated':
        result, code = restated(args.base), 0
    elif args.command == 'board':
        result = board_check(args.base)
        code = 1 if result['errors'] else 0
    elif args.command == 'frozen':
        result = frozen_check(args.base, args.all)
        code = 1 if result['errors'] else 0
    elif args.command == 'receipt':
        result = receipt_check(args.base)
        code = 1 if result['errors'] else 0
    else:
        result, code = status(), 0
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return code


if __name__ == '__main__':
    try:
        raise SystemExit(main())
    except (ValueError, OSError, subprocess.CalledProcessError) as exc:
        print(json.dumps({'errors': [str(exc)]}))
        raise SystemExit(1)
