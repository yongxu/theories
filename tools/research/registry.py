#!/usr/bin/env python3
"""Render and check canonical claim records. Never compiles Lean or refreshes hashes.

Run from any directory. --check is read-only; --search searches claims and aliases.
A Markdown source changed only outside what a record cites keeps its review (RESULT-WORKFLOW.md).
Exit 1: invalid metadata/rendering. Exit 2: reviewed source bytes changed.
Source hashes mark documentary review, not a proof build or semantic equivalence.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / 'theories/becoming/results'
RECORDS = OUT / 'records'
STATUSES = {'recorded-checked', 'reviewed-scoped', 'open', 'superseded', 'withdrawn'}
KINDS = {'theorem', 'argument', 'assessment', 'target'}
RELATIONS = {'formal-reuse', 'application', 'interpretive'}
ROLES = {'statement', 'proof', 'receipt', 'review', 'integration', 'counterexample', 'provenance'}
# Schema 1 keeps its fields; schema 2 leads with a short statement and splits limitations
# into typed items, shared boundary keys, target scope and progress (see RESULT-WORKFLOW.md).
REQUIRED = {1: ('title', 'claim', 'correspondence', 'limitations', 'next_delta', 'validation_scope'),
            2: ('title', 'statement', 'correspondence', 'next_delta', 'validation_scope')}
V2_LISTS = ('laws', 'does_not_show', 'not_required', 'progress', 'standard_boundaries', 'text_versions')
NOT_SHOWN = {'non-implication', 'converse', 'correspondence', 'scope'}
SHA256 = re.compile(r'[0-9a-f]{64}')


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


# Where a Markdown source changed only outside what a record cites, the bytes the record
# was reviewed against are still there and its review stands. The reviewed version is
# found in the history of HEAD by its sha256; blob hashes are cached outside the
# repository, since a blob never changes. Lean and other sources still need exact bytes.
VERSION_CACHE = Path(os.environ.get('RESEARCH_SOURCE_CACHE') or Path.home() / '.cache' / 'research-source-versions.json')
# Comparing a reviewed version with the current text depends on the two texts alone and is
# most of a check's time, so each comparison is kept outside the repository too: one file per
# pair of texts, named by their sha256, under a tag of the algorithm and of Python's version
# (difflib's output may change with it). Sessions running at once never write one file.
DRIFT_CACHE = Path(os.environ.get('RESEARCH_DRIFT_CACHE') or Path.home() / '.cache' / 'research-drift-comparisons')
DRIFT_VERSION = 'sequence-matcher-lines-1-py{}.{}'.format(*sys.version_info[:2])
_versions, _comparisons = {}, {}


def reviewed_version(path, sha256):
    """The text of `path` as committed with this sha256 in HEAD's history, or None. A file the
    move receipts moved is also searched at its former paths (moved bytes keep their blobs),
    so a moved Markdown source that later changes still finds the version a record reviewed."""
    import subprocess
    if path not in _versions:
        try:
            from tools.research import moves
            names = [path] + moves.former_paths(path, ROOT)
        except (ImportError, OSError, ValueError):
            names = [path]
        try:
            log = subprocess.check_output(['git', 'log', '-m', '--format=', '--raw', '--no-abbrev', '--no-renames', 'HEAD', '--', *names],
                                          cwd=ROOT, text=True, stderr=subprocess.DEVNULL)
        except (OSError, subprocess.CalledProcessError):
            log = ''
        blobs = list(dict.fromkeys(blob for line in log.splitlines() if line.startswith(':')
                                   for blob in line.split()[2:4] if blob.strip('0')))
        try:
            cache = json.loads(VERSION_CACHE.read_text())
        except (OSError, ValueError):
            cache = {}
        missing = [b for b in blobs if b not in cache]
        if missing:
            p = subprocess.run(['git', 'cat-file', '--batch'], cwd=ROOT, input=''.join(b + '\n' for b in missing).encode(),
                               stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
            out, at = p.stdout, 0
            for blob in missing:
                header_end = out.index(b'\n', at)
                size = int(out[at:header_end].split()[2])
                cache[blob] = hashlib.sha256(out[header_end + 1:header_end + 1 + size]).hexdigest()
                at = header_end + 1 + size + 1
            try:
                VERSION_CACHE.parent.mkdir(parents=True, exist_ok=True)
                temporary = VERSION_CACHE.with_name(f'.{VERSION_CACHE.name}.{os.getpid()}')
                temporary.write_text(json.dumps(cache))
                os.replace(temporary, VERSION_CACHE)
            except OSError:
                pass  # The cache only saves work.
        _versions[path] = {cache[b]: b for b in blobs if b in cache}
    blob = _versions[path].get(sha256)
    if blob is None:
        return None
    import subprocess
    return subprocess.check_output(['git', 'cat-file', 'blob', blob], cwd=ROOT).decode()


def sections(lines):
    """For each line, the level-2 heading it falls under; None for the title and the text
    before the first such heading, which bear on every record."""
    current, out = None, []
    for line in lines:
        if re.match(r'##\s', line):
            current = line.strip()
        out.append(current)
    return out


def changed_lines(path, sha256, current):
    """Compare the reviewed version with the current text. None: the reviewed version is not
    in HEAD's history. Otherwise (heading, removed lines, replacing lines) for each place a
    line was removed or rewritten; lines only added are not listed. A Markdown paragraph,
    list item or table row is one line."""
    key = (path, sha256)
    if key not in _comparisons:
        old = reviewed_version(path, sha256)
        if old is None:
            _comparisons[key] = None
        else:
            a, b = old.splitlines(), current.splitlines()
            heads = sections(a)
            _comparisons[key] = [(heads[i1], a[i1:i2], b[j1:j2]) for op, i1, i2, j1, j2 in rewrites(old, a, current, b)]
    return _comparisons[key]


def rewrites(old, a, current, b):
    """difflib's replace and delete opcodes from lines `a` of `old` to lines `b` of `current`,
    from DRIFT_CACHE where these two texts were compared before. An entry that cannot be read,
    or whose spans do not fit the lines, is computed again and rewritten."""
    import difflib
    entry = DRIFT_CACHE / DRIFT_VERSION / '{}-{}.json'.format(*(hashlib.sha256(t.encode()).hexdigest() for t in (old, current)))
    try:
        cached = json.loads(entry.read_text())
    except (OSError, ValueError):
        cached = None
    fits = lambda x: (isinstance(x, list) and len(x) == 5 and x[0] in ('replace', 'delete') and all(type(n) is int for n in x[1:])
                      and 0 <= x[1] < x[2] <= len(a) and 0 <= x[3] <= x[4] <= len(b))
    if isinstance(cached, list) and all(fits(x) for x in cached):
        return cached
    ops = [x for x in difflib.SequenceMatcher(None, a, b, autojunk=False).get_opcodes() if x[0] in ('replace', 'delete')]
    try:
        entry.parent.mkdir(parents=True, exist_ok=True)
        temporary = entry.with_name(f'.{entry.name}.{os.getpid()}')
        temporary.write_text(json.dumps(ops))
        os.replace(temporary, entry)
    except OSError:
        pass  # The cache only saves work.
    return ops


def links_record(record, text):
    """Whether `text` links the record's page or file, at its id or a former id: a renamed
    record's former page is a redirect to it, so a source left linking that page still links it."""
    former = record.get('former_ids')
    ids = [record.get('id', ''), *(former if isinstance(former, list) else [])]
    return any(re.search(r'records/' + re.escape(i) + r'\.(?:md|json)\b', text) for i in ids if isinstance(i, str) and i)


def cited_headings(record, path):
    """Anchors of `path` the record cites (`path#anchor` anywhere in the record)."""
    return set(re.findall(re.escape(path) + r'#([^\s"\')\]]+)', json.dumps(record, ensure_ascii=False)))


def scoped_drift(record, path, expected, current_path):
    """For a source whose bytes changed since the record's review: None when every change lies
    outside what the record cites, otherwise where it does not. What a record cites in a
    Markdown source is each line linking the record's page and each section it cites by
    anchor; lines only added change nothing reviewed. A record the source neither links nor
    cites by anchor has no located part, so any rewritten line counts, as does a rewrite
    before the first heading. Other sources need their exact bytes."""
    from tools.research.reading_catalogue import anchors_from_text
    if not path.endswith('.md'):
        return ['(not Markdown: exact bytes required)']
    current = current_path.read_text()
    changes = changed_lines(path, expected, current)
    if changes is None:
        return ['(reviewed version not in history)']
    anchors = cited_headings(record, path)
    located = bool(anchors) or links_record(record, current)
    bearing = []
    for heading, removed, added in changes:
        if (not located or heading is None or links_record(record, '\n'.join(removed + added))
                or anchors & anchors_from_text(heading)):
            bearing.append(heading or '(before the first heading)')
    return sorted(set(bearing)) or None


LANGUAGES = ('en', 'zh')


def pair(value):
    """A text field: an object whose `en` and `zh`, where present, are strings, at least one of
    them nonempty. Full translation is no longer required (Ren, 17 October 2026); a record may
    carry English, Chinese or both."""
    return (isinstance(value, dict) and all(isinstance(value[k], str) for k in LANGUAGES if k in value)
            and any(isinstance(value.get(k), str) and value[k].strip() for k in LANGUAGES))


def en(value):
    """The text a generated page shows: the English, or the Chinese where English is missing.
    The Chinese stays in the record."""
    english = value.get('en')
    return english if isinstance(english, str) and english.strip() else value.get('zh', '')


bilingual = en  # older name, kept for callers; pages render one language


def heading(marks, text, former=None):
    """A heading line for `finish`. `former` is the heading's earlier text (the bilingual one),
    whose GitHub anchor `finish` keeps on the line before the heading."""
    return (marks, text, text if former is None else former)


def finish(lines):
    """Join page lines. Each heading from `heading` whose earlier text had an anchor the page no
    longer has gets `<a id="earlier"></a>` before it, so inbound `page#anchor` links keep working.
    Plain heading lines count in GitHub's numbering of repeated anchors."""
    from tools.research.reading_catalogue import HEADING, numbered, slug
    rows = []  # (new text, former text) for every heading, in order
    for item in lines:
        if isinstance(item, tuple):
            rows.append((item[1], item[2]))
        else:
            rows += [(h, h) for h in HEADING.findall(item)]
    new, former = numbered([slug(a) for a, _ in rows]), numbered([slug(b) for _, b in rows])
    present = set(new) | set(re.findall(r'<a\s+(?:id|name)=["\']([^"\']+)["\']', '\n'.join(x for x in lines if isinstance(x, str))))
    out, at = [], 0
    for item in lines:
        if isinstance(item, tuple):
            if former[at] not in present:
                out.append(f'<a id="{former[at]}"></a>')
                present.add(former[at])
            out.append(item[0] + ' ' + item[1])
            at += 1
        else:
            at += len(HEADING.findall(item))
            out.append(item)
    return '\n'.join(out) + '\n'


def valid_overview(value):
    return isinstance(value, dict) and all(pair(value.get(key)) for key in ('title', 'summary', 'evidence'))


def path_in_repo(value):
    if not isinstance(value, str) or not value or Path(value).is_absolute():
        return None
    p = (ROOT / value).resolve()
    return p if p.is_relative_to(ROOT) and p.is_file() else None


def at_pointer(value, pointer):
    for token in pointer.strip('/').split('/'):
        token = token.replace('~1', '/').replace('~0', '~')
        value = value[int(token)] if isinstance(value, list) else value[token]
    return value


def declaration_in_source(text, name):
    """Existence aid only; receipt bindings check the full elaborated name.

    Lean instances may have a name and a priority before that name. Require the
    actual identifier after the command, so an anonymous instance's result type
    or binder cannot be mistaken for a named declaration.
    """
    command = (r'(?:theorem|lemma|def|abbrev|structure|inductive|'
               r'instance(?:\s+\(priority\s*:=\s*[^)\n]+\))?)')
    return re.search(
        r'^[ \t]*(?:@\[[^\]\n]*\]\s*)*'
        r'(?:(?:protected|private|noncomputable)\s+)*' + command +
        r'\s+(?:[\w\'.]+\.)?' + re.escape(name.split('.')[-1]) +
        r'(?=\s|\{|\(|\[|:)', text, re.M) is not None


DECLARATION = re.compile(
    r'^[ \t]*(?:@\[[^\]\n]*\]\s*)*(?:(?:protected|private|noncomputable)\s+)*'
    r'(?:theorem|lemma|def|abbrev|structure|inductive|instance(?:\s+\(priority\s*:=\s*[^)\n]+\))?)'
    r"\s+([\w'.]+)(?=\s|\{|\(|\[|:)", re.M)


class Sources:
    """Files read during one validation, each read, hashed, parsed or scanned once."""
    def __init__(self):
        self.texts, self.digests, self.receipts, self.listed, self.declared = {}, {}, {}, {}, {}

    def text(self, p):
        if p not in self.texts:
            self.texts[p] = p.read_text()
        return self.texts[p]

    def digest(self, p):
        if p not in self.digests:
            self.digests[p] = digest(p)
        return self.digests[p]

    def receipt(self, path):
        if path not in self.receipts:
            self.receipts[path] = json.loads((ROOT / path).read_text())
        return self.receipts[path]

    def receipt_names(self, path):
        if path not in self.listed:
            self.listed[path] = receipt_declaration_names(self.receipt(path))
        return self.listed[path]

    def elaborated(self, path, module):
        """Names Lean elaborated for `module`, as the receipt lists them."""
        key = (path, module)
        if key not in self.listed:
            data = self.receipt(path)
            self.listed[key] = {d.get('name') for m in data.get('modules', []) if isinstance(m, dict) and m.get('module') == module
                                for d in m.get('declarations', []) if isinstance(d, dict)}
        return self.listed[key]

    def declares(self, p, name):
        """`declaration_in_source`, with each source scanned once for plain identifiers."""
        last = name.split('.')[-1]
        if not re.fullmatch(r"[\w']+", last):
            return declaration_in_source(self.text(p), name)
        if p not in self.declared:
            self.declared[p] = {token.split('.')[-1] for token in DECLARATION.findall(self.text(p))}
        return last in self.declared[p]


def config():
    return json.loads((ROOT / '_process/research-config.json').read_text())


def standard_boundaries_path(settings=None):
    path = (config() if settings is None else settings).get('standard_boundaries')
    return path if isinstance(path, str) else None


def standard_boundaries(settings=None):
    """Shared boundary sentences, defined once and cited by key."""
    path = standard_boundaries_path(settings)
    if path is None or path_in_repo(path) is None:
        return {}
    try:
        data = json.loads((ROOT / path).read_text())
    except ValueError:
        return {}
    return data.get('boundaries', {}) if isinstance(data, dict) and isinstance(data.get('boundaries'), dict) else {}


def validate_standard_boundaries(settings=None):
    path = standard_boundaries_path(settings)
    if path is None:
        return []
    p = path_in_repo(path)
    if p is None:
        return [f'standard boundaries file missing: {path}']
    try:
        data = json.loads(p.read_text())
    except ValueError as exc:
        return [f'standard boundaries file is not JSON: {exc}']
    if not isinstance(data, dict) or not isinstance(data.get('boundaries'), dict):
        return ['standard boundaries file needs a "boundaries" object']
    errors = []
    for key, value in data['boundaries'].items():
        if not re.fullmatch(r'[a-z][a-z0-9-]+', key):
            errors.append(f'standard boundary key is not a stable name: {key}')
        if not pair(value):
            errors.append(f'standard boundary {key} requires nonempty English or Chinese')
        elif path_in_repo(value.get('source')) is None:
            errors.append(f'standard boundary {key} needs an existing source')
    return errors


def snapshot_directory(settings=None):
    path = (config() if settings is None else settings).get('record_snapshots')
    return path.rstrip('/') if isinstance(path, str) and path.strip('/') else None


LAW_KEYS = ('en', 'zh', 'declarations', 'statements_at_model')
AT_MODEL_KEYS = ('declaration', 'of', 'models', 'review')
# F5's field (architecture/mv/F5-MODEL-STATEMENTS.md): where a law states a row, in the order and words the page uses.
MODELS = {'occurrence': "a World's occurrence model", 'process': "a process's model", 'own': "the row's own carrier"}


def _review_text(path):
    p = path_in_repo(path)
    try:
        return p.read_text() if p is not None and p.is_file() else None
    except (OSError, UnicodeDecodeError):
        return None


def statements_at_model_errors(r):
    """F5's field: a law's theorems that state a row of the same record at a model, each naming its models and its
    review. Only the pair, its models and its review are declared; MV's generator verifies the rest from the Lean."""
    laws = [x for x in r.get('laws', []) if isinstance(x, dict)]
    errors = [f'law {i}: keys must lie among {", ".join(LAW_KEYS)}: ' + ', '.join(sorted(map(str, set(x) - set(LAW_KEYS))))
              for i, x in enumerate(laws, 1) if set(x) - set(LAW_KEYS)]
    carrying = [(i, x) for i, x in enumerate(laws, 1) if 'statements_at_model' in x]
    if not carrying:
        return errors
    if r.get('status') in {'superseded', 'withdrawn'}:
        errors.append('statements_at_model is not allowed on a superseded or withdrawn record')
    reviews = {x.get('path') for x in r.get('references', []) if isinstance(x, dict) and x.get('role') == 'review'}
    names = {i: [d for d in x.get('declarations', []) if isinstance(d, str)] if isinstance(x.get('declarations'), list) else []
             for i, x in enumerate(laws, 1)}
    items = []
    for i, law in carrying:
        block = law['statements_at_model']
        if not isinstance(block, list) or not block:
            errors.append(f'law {i}: statements_at_model must be a nonempty list')
            continue
        for item in block:
            if not isinstance(item, dict) or set(item) != set(AT_MODEL_KEYS):
                errors.append(f'law {i}: a statement at a model has exactly the keys {", ".join(AT_MODEL_KEYS)}')
                continue
            d, of, models, review = (item[k] for k in AT_MODEL_KEYS)
            if not all(isinstance(x, str) and x for x in (d, of, review)):
                errors.append(f'law {i}: declaration, of and review must be nonempty strings')
                continue
            items.append((i, item))
            if not isinstance(models, list) or not models or any(not isinstance(m, str) or m not in MODELS for m in models) \
                    or len(set(models)) != len(models):
                errors.append(f'law {i}: models must be a nonempty list of distinct values among {", ".join(MODELS)}')
            if d not in names[i]:
                errors.append(f'law {i}: its statement at a model {d} is not among its declarations')
            if not any(of in names[j] for j in names if j != i):
                errors.append(f'law {i}: the row {of} is among the declarations of no other law of the record')
            if review not in reviews:
                errors.append(f'law {i}: {review} is not a reference of role review in the record')
            elif (text := _review_text(review)) is not None and not re.search(r'`(?:[^`\s]*\.)?' + re.escape(d.rsplit('.', 1)[-1]) + '`', text):
                errors.append(f'law {i}: its review {review} does not name {d}')
    rows = {item['of'] for _, item in items}
    for i, _ in carrying:
        held = sorted(rows & set(names[i]))
        if held:
            errors.append(f'law {i} carries statements at a model and holds the row of one: ' + ', '.join(held))
    seen = {}
    for _, item in items:
        seen[item['declaration']] = seen.get(item['declaration'], 0) + 1
    twice = sorted(d for d, n in seen.items() if n > 1)
    if twice:
        errors.append('a theorem is the statement at a model of more than one item: ' + ', '.join(twice))
    return errors


def statements_at_model_across(records):
    """Across all records, a theorem states a row at a model in at most one record."""
    where = {}
    for r in records:
        for law in r.get('laws', []) if isinstance(r.get('laws'), list) else []:
            block = law.get('statements_at_model') if isinstance(law, dict) else None
            for item in block if isinstance(block, list) else []:
                if isinstance(item, dict) and isinstance(item.get('declaration'), str):
                    where.setdefault(item['declaration'], set()).add(r.get('id'))
    return [f'{d}: the statement at a model of items in more than one record: ' + ', '.join(sorted(map(str, ids)))
            for d, ids in sorted(where.items()) if len(ids) > 1]


def boundary_errors(r):
    """The boundary field (architecture/mv/BOUNDARY-FIELD.md §2). Its rules are in tools/research/boundary.py, which the
    generator applies too; only the check reads whether each review names the item's names."""
    from tools.research import boundary
    return boundary.field_errors(r, _review_text)


def boundary_across(records):
    """One record at most carries the boundary field."""
    from tools.research import boundary
    ids = sorted(str(r.get('id')) for r in boundary.carriers(records))
    return ['the boundary field is carried by more than one record: ' + ', '.join(ids)] if len(ids) > 1 else []


def validate_v2_fields(r, settings=None):
    """Structure of the schema-2 fields; readability rules come from style.lint."""
    settings = config() if settings is None else settings
    errors = []
    if 'limitations' in r:
        errors.append('schema 2 replaces limitations with does_not_show, hypotheses, standard_boundaries and not_required')
    if 'claim' in r and not pair(r['claim']):
        errors.append('claim, when present, requires nonempty English or Chinese')
    malformed = [key for key in V2_LISTS if not isinstance(r.get(key, []), list)]
    if malformed:
        return errors + ['expected lists: ' + ', '.join(malformed)]
    if any(not isinstance(x, dict) for key in V2_LISTS if key != 'standard_boundaries' for x in r.get(key, [])):
        return errors + ['laws, does_not_show, not_required, progress and text_versions entries must be objects']
    for key in ('laws', 'does_not_show', 'not_required', 'progress'):
        if not all(pair(item) for item in r.get(key, [])):
            errors.append(f'{key} items require nonempty English or Chinese')
    references = [x for x in r.get('references', []) if isinstance(x, dict)]
    paths = {x.get('path') for x in references}
    declared = {d for x in references for d in x.get('declarations', []) if isinstance(d, str)}
    for item in r.get('laws', []):
        names = item.get('declarations', [])
        if not isinstance(names, list):
            errors.append('law declarations must be a list')
            continue
        unknown = [d for d in names if not isinstance(d, str) or d not in declared]
        if unknown:
            errors.append('law names undeclared references: ' + ', '.join(map(str, unknown)))
    errors += statements_at_model_errors(r)
    errors += boundary_errors(r)
    for item in r.get('does_not_show', []):
        if not isinstance(item.get('kind'), str) or item['kind'] not in NOT_SHOWN:
            errors.append(f'does_not_show kind must be one of {", ".join(sorted(NOT_SHOWN))}')
        if 'witness' in item and (not isinstance(item['witness'], str) or item['witness'] not in declared | set(map(str, r.get('aliases', [])))):
            errors.append(f'does_not_show witness is not a declared reference or alias: {item["witness"]}')
    from tools.research.reading_catalogue import anchors
    for item in r.get('progress', []):
        source = item.get('source')
        file, _, anchor = source.partition('#') if isinstance(source, str) else ('', '', '')
        if file not in paths:
            errors.append(f'progress source must be a hashed reference: {source}')
        elif anchor and file.endswith('.md') and anchor not in anchors(ROOT / file):
            errors.append(f'progress anchor missing: {source}')
    known = standard_boundaries(settings)
    keys = r.get('standard_boundaries', [])
    if len(keys) != len(set(map(str, keys))):
        errors.append('standard_boundaries lists a key twice')
    for key in keys:
        if not isinstance(key, str) or key not in known:
            errors.append(f'unknown standard boundary {key}')
    directory = snapshot_directory(settings)
    for version in r.get('text_versions', []):
        path, expected = version.get('path'), version.get('sha256')
        p = path_in_repo(path)
        if not pair(version.get('note')):
            errors.append('text version needs a note in English or Chinese')
        if p is None or not isinstance(expected, str) or not SHA256.fullmatch(expected) or digest(p) != expected:
            errors.append(f'text version missing or changed: {path}')
            continue
        if directory is None or not path.startswith(directory + '/'):
            errors.append(f'text version must be stored under record_snapshots ({directory}): {path}')
        try:
            earlier = json.loads(p.read_text())
        except ValueError:
            earlier = None
        if not isinstance(earlier, dict) or earlier.get('id') not in {r.get('id'), *r.get('former_ids', [])}:
            errors.append(f'text version is not an earlier version of this record: {path}')
    return errors


def snapshot_record(ident, settings=None):
    """Store a record's exact current bytes before migration; return its text_versions entry.

    The copy lives at <record_snapshots>/<sha256[:16]>/<id>.json, next to the preserved
    overview editions, and is never overwritten. The record itself is not edited.
    """
    settings = config() if settings is None else settings
    if not re.fullmatch(r'[a-z][a-z0-9-]+', ident):
        raise ValueError('not a record id: ' + ident)
    directory = snapshot_directory(settings)
    if directory is None:
        raise ValueError('record_snapshots is not configured in _process/research-config.json')
    source = next((ROOT / d / (ident + '.json') for d in settings['record_directories'] if (ROOT / d / (ident + '.json')).is_file()), None)
    if source is None:
        raise ValueError('no record with id ' + ident)
    raw = source.read_bytes()
    sha = hashlib.sha256(raw).hexdigest()
    target = ROOT / directory / sha[:16] / source.name
    if target.exists() and target.read_bytes() != raw:
        raise ValueError('Refusing to overwrite preservation artifact: ' + str(target.relative_to(ROOT)))
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_bytes(raw)
    schema = json.loads(raw).get('schema_version')
    return {'path': str(target.relative_to(ROOT)), 'sha256': sha,
            'note': {'zh': f'迁移前的记录原始字节（schema {schema}）。', 'en': f'Exact record bytes before the migration (schema {schema}).'}}


def receipt_declaration_names(data):
    """Declaration names a receipt lists for its modules, in any of the receipt formats in use:
    `declarations` and `audits` entries (names or objects with a `name`), `audited_declarations`
    and `empty_axiom_audits` lists, and the keys of `axioms_by_declaration`, `axiom_dependencies`,
    `standard_axiom_audits`, `standard_dependency_audits`, `nonempty_audits` and `empty_axiom_audits`."""
    names = set()
    for m in data.get('modules', []) if isinstance(data.get('modules'), list) else []:
        if not isinstance(m, dict):
            continue
        for key in ('declarations', 'audits', 'audited_declarations', 'empty_axiom_audits',
                    'axioms_by_declaration', 'axiom_dependencies', 'standard_axiom_audits',
                    'standard_dependency_audits', 'nonempty_audits'):
            value = m.get(key)
            if isinstance(value, dict):
                names |= {k for k in value if isinstance(k, str)}
            elif isinstance(value, list):
                names |= {d.get('name') if isinstance(d, dict) else d for d in value
                          if isinstance(d, str) or (isinstance(d, dict) and isinstance(d.get('name'), str))}
    return names


GROWN = []  # sources changed only outside what the record cites, from the last validate()
LAW_FAMILIES = 'theories/becoming/results/data/law-families.json'


def law_families():
    """The law families (twentieth review, E7): records stating one law and its readings, with a lead."""
    path = ROOT / LAW_FAMILIES
    return json.loads(path.read_text()).get('families', []) if path.is_file() else []


SHARED_LAWS = 'theories/becoming/results/data/shared-laws.json'
CORE_RECEIPT = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-verification.json'


def shared_laws():
    """MV: the shared laws each law of a record rests on, by Lean dependency (data/shared-laws.json, written by
    tools/research/shared_laws.py from the measure and the checker cache; it is not rendered here). A file that
    does not parse is reported by the check, not raised."""
    path = ROOT / SHARED_LAWS
    if not path.is_file():
        return {}
    try:
        return json.loads(path.read_text())
    except ValueError as e:
        return {'error': f'{SHARED_LAWS} does not parse: {e}'}


def _listed(names):
    return ' and '.join(names) if len(names) < 3 else ', '.join(names[:-1]) + ' and ' + names[-1]


# What the measure's category of a central declaration says it follows from, and a declaration's own dependence.
FOLLOWS = {'shared law': 'a shared law', 'balance, represented': 'balance, which the grammar represents',
           'premise of the account': 'a premise of the account', 'counting identity': 'a counting identity',
           'law of its model': 'a law of its model', 'single application': 'a single application',
           'definitional or representational': 'its definitions', 'derivation pending': 'a shared law, its derivation pending',
           'no reason given': 'nothing named'}
ALONE = {'grammar': 'reaching the grammar', 'balance, represented': 'on balance, not reaching the grammar',
         'anchor, not reached': 'on an anchor, not reaching the grammar', 'no shared law': "on no shared law's anchor"}
MARKER = re.compile(r"\s*\([A-Z]{2,4}\d+[a-z]?(?:'s review)?\)")  # a work item in the measure's reason, kept off the page


def shared_law_note(r, i, law):
    """The line under law i on a record page, where the data was computed for exactly these declarations."""
    m = r.get('_shared_laws')
    e = m['laws'].get(i) if m else None
    if not e or e.get('declarations') != law.get('declarations', []) or not e['declarations']:
        return ''
    label = '*Shared laws, by Lean dependency:* '
    if 'dependence' not in e:
        return label + 'not measured: none of its declarations is in the spine run the measure reads.'
    names = [m['names'].get(k, k) for k in e['shared_laws']]
    held = (_listed(names) if names else "no shared law's anchor") + '; its declarations'
    reach = "reach the grammar's vocabulary only" if e.get('grammar_vocabulary_only') else 'reach the grammar'
    text = {'grammar': f'{held} {reach}',
            'balance, represented': f'{held} do not reach the grammar, which represents balance and cannot state it without amounts',
            'anchor, not reached': f'{held} do not reach the grammar',
            'no shared law': "no shared law's anchor among the constants its declarations use"}.get(e['dependence'], f'{held}: {e["dependence"]}')
    if e.get('defines'):
        a = _listed(['`' + x + '`' for x in e['defines']])
        text = (f'its declarations include the anchor {a} itself; ' if len(e['defines']) == 1
                else f'its declarations include the anchors {a} themselves; ') + text
    for c in e.get('central', []):
        why = MARKER.sub('', c.get('reason', ''))
        if why and c['category'] == 'shared law':
            why = 'not reaching the grammar: ' + why
        if c['category'] == 'shared law' and c.get('dependence') == 'grammar' and not why:
            why = 'by reaching the grammar'
        if c['category'] == 'definitional or representational':
            why = 'definitional or representational' + (': ' + why if why else '')
        if c['category'] == 'no reason given':
            why = 'no reason given'
        own = c.get('shared_laws')
        if c.get('dependence') and (c['dependence'] != e['dependence'] or (own is not None and own != e['shared_laws'])):
            on = _listed([m['names'].get(k, k) for k in own]) if own else "no shared law's anchor"
            alone = f' (taken alone: {on}; ' + ('reaching' if c['dependence'] == 'grammar' else 'not reaching') + ' the grammar)'
        else:
            alone = ''
        text += (f'; the measure counts central declaration `{c["declaration"]}`{alone} as following from '
                 f'{FOLLOWS.get(c["category"], c["category"])}' + (f' ({why})' if why else ''))
    if e.get('outside'):
        n = len(e['outside'])
        text += f'; {n} of its declarations {"is" if n == 1 else "are"} not in the spine run and not measured, so this holds of the others only'
    return label + text + '.'


def declared_items(law):
    """A law's statements at a model as its record declares them, in the form the data keeps them."""
    block = law.get('statements_at_model') if isinstance(law, dict) else None
    return [{k: x.get(k) for k in AT_MODEL_KEYS} for x in block if isinstance(x, dict)] if isinstance(block, list) else []


def at_model_notes(r, i, law, result_link, base):
    """F5's lines under law i: its own statements at a model, as the data verified them, and the statements at a model
    of its rows, wherever they are carried. Each appears only while the carrying record declares exactly the items the
    data read; an item the data did not verify shows nothing. Both mark what is declared and name its review, and an
    item only on its row's own carrier is not labelled as at a model."""
    m = r.get('_shared_laws')
    e = m['laws'].get(i) if m else None
    if not e or e.get('declarations') != law.get('declarations', []):
        return []
    def label(x):
        kind = 'At a model' if set(x['models']) & {'occurrence', 'process'} else 'On its own carrier'
        return f'*{kind} (declared; reviewed in {link(x["review"], base)}):*'
    lines = []
    shown = set(m.get('matched_at_model', []))
    if f'{r.get("id")}:{i}' in shown:
        for x in e['statements_at_model']:
            if x.get('verified'):
                kept = _listed(['`' + n + '`' for n in x.get('other_terms', [])]) or 'nothing'
                alone = ALONE.get(x.get('row_dependence'), x.get('row_dependence'))
                lines.append(f'{label(x)} `{x["declaration"]}` states `{x["of"]}` at {_listed([MODELS.get(k, k) for k in x["models"]])}. '
                             f'Computed: its proof reaches the row; its statement names, directly or through its module\'s definitions, '
                             f'{_listed(["`" + n + "`" for n in x["grammar_terms"]])}; it keeps {kept} in other terms. The row taken alone: {alone}.')
    for x in e.get('stated_at_model', []):
        if f'{x["record"]}:{x["law"]}' in shown:
            where = f'law {x["law"]} of this record' if x['record'] == r.get('id') else f'{result_link(x["record"])}, law {x["law"]}'
            lines.append(f'{label(x)} `{x["of"]}` is stated at {_listed([MODELS.get(k, k) for k in x["models"]])} by '
                         f'`{x["declaration"]}` ({where}).')
    return lines


def _names(names):
    return _listed(['`' + n + '`' for n in names])


def _rule_reason(row, label, e):
    """Why U4's rule gives `label` to a row (BOUNDARY-FIELD.md §5), with e the row's entry where it has one."""
    b = row['balance']
    models = sorted({m for x in row['at_model'] for m in x['models']} & {'occurrence', 'process'})
    case = 'not verified as a case of one' if e.get('standing') == 'derived' else 'not declared a case of one'
    return {'balance in its statement': f'{_names(b["anchor_in_statement"])} in its statement' if b['anchor_in_statement']
            else 'balance written out in its statement',
            'connected': (f'it reaches {_names(row["grammar_laws_reached"])} among its reasons' if row['grammar_laws_reached']
                          else 'the measure has it reaching the grammar') + '; ' + case,
            'at a represented model': f"F5's verified items at the {_listed(models)} model" + ('s' if len(models) > 1 else ''),
            'own carrier': "F5's verified items on its own carrier only",
            'unplaced': ('no standing verified' if e else 'no standing declared') + ", and none of the rule's tests holds"}.get(label, label)


def standing_line(d, row, record, result_link, base):
    """The line for central declaration d under a law that names it (BOUNDARY-FIELD.md §5): one sentence for its
    standing, as the data placed it from the boundary record (declared in `record`) or by U4's rule."""
    e = row.get('entry') or {}
    declared = f'declared in {result_link(record)}'
    if row['placed'] == 'checked entry' and e['standing'] == 'derived':
        rep = e.get('report', {})
        text = f'*Standing of `{d}`:* derived, a case of {_names(e["law"])}'
        if rep.get('forwarder'):
            text += f' (it forwards to `{rep["forwarder"]["law"]}`, of kind {rep["forwarder"]["kind"]})'
        if e.get('bridges'):
            text += f' through {_names(e["bridges"])}'
        if e.get('support'):
            text += f', with the support {_names(e["support"])}'
        if rep.get('laws_used_also'):
            text += f', using also {_names(rep["laws_used_also"])}'
        checked = 'the closed set checked against the Lean' + (', the bridges checked as equivalences' if e.get('bridges') else '')
        text += f' ({declared}; {checked}; the case read in {link(e["review"], base)}).'
        if rep.get('root_theorems_named'):
            text += f' Root theorems its proofs name: {_names(rep["root_theorems_named"])} (Init not shown).'
        return text
    if row['placed'] == 'checked entry':
        hyps = [h['hypothesis'] for h in e['hypotheses']]
        one = len(hyps) == 1
        text = (f'*Standing of `{d}`:* under a stated hypothesis, the root form `{e["form"]}` at its model, with '
                f'{"hypothesis" if one else "hypotheses"} {_names(hyps)}, {"with its" if one else "each with its"} countermodel and fit')
        if e.get('bridges'):
            text += f', through the bridges {_names(e["bridges"])}'
        return text + (f' ({declared}; checked in Lean: the form, its countermodels, the certificate and the discharge condition; '
                       f"the hypotheses read as the row's relational content in {link(e['review'], base)}).")
    if row['placed'] == 'reading':
        text = f'*Standing of `{d}`:* {e["standing"]}, a reading: {en(e["basis"]).strip().rstrip(".")} ({link(e["review"], base)})'
        if row['rule'] == e['standing']:
            text += '; the rule gives the same'
        else:
            why = "none of the rule's tests holds" if row['rule'] == 'unplaced' else _rule_reason(row, row['rule'], {})
            text += f'; the rule gives {row["rule"]} ({why})'
        if e.get('relational_part'):
            text += f'; its relational part: `{e["relational_part"]}`'
        return text + '.'
    why = _rule_reason(row, row['label'], e)
    if e:
        why += f'; the declared standing, {e.get("standing")}, is unverified: ' + '; '.join(e.get('failed', []))
    return f'*Standing of `{d}`, by the rule:* {row["label"]} ({why}).'


def boundary_section(r, base):
    """The boundary record's section (BOUNDARY-FIELD.md §5): the central declarations by group and label, headed by the
    counts and the premises of the ethics, while the data read the field this record carries."""
    from tools.research import boundary
    b = r.get('_boundary')
    if not b:
        return []
    lines = [heading('##', 'Standings on the edge'), '']
    if b['not_matched']:
        what = [d for d in b['not_matched'] if d != 'the field']
        cause = ('the record around this field (its status, schema, reviews or laws) or the field\'s own keys changed '
                 'since the data read it, so no entry of the field is matched' if 'the field' in b['not_matched']
                 else 'the data read another version of this field')
        return lines + [f'*Not matched:* {cause} (' + _listed(what[:5]) + (' and others' if len(what) > 5 else '')
                        + '); rerun `python3 -B tools/research/shared_laws.py`, then make research-render.', '']
    c, parts = b['counts'], []
    for group, labels in boundary.GROUPS.items():
        inner = ', '.join(f'{label} {c[label]}' for label in labels if c[label])
        parts.append(f'{group} {b["groups"][group]}' + (f' ({inner})' if inner and len(labels) > 1 else ''))
    lines += [f'**Counts** of the {sum(b["groups"].values())} central declarations: ' + '; '.join(parts) + '.', '']
    for p in b['premises_of_the_ethics']:
        absent = en(p['absent']).strip().rstrip('.') if isinstance(p.get('absent'), dict) else ''
        what = {'not entailed': f'not entailed by any statement reading only the dynamics, by `{p.get("not_entailed")}` '
                                '(computed: a theorem whose type names the definition; its statement read in the review)',
                'not shown': 'no theorem shows it unentailed by the dynamics' + (': ' + absent if absent else ''),
                'unverified': 'unverified: ' + '; '.join(map(str, p.get('failed', [])))}.get(p.get('result'), p.get('result'))
        name = en(p['name']) if isinstance(p.get('name'), dict) else p.get('name')
        lines += [f'- **For {p.get("role")}**, {name}: `{p.get("premise")}`; {what}.']
    for group, labels in boundary.GROUPS.items():
        rows = sorted(((d, x) for d, x in b['rows'].items() if x['label'] in labels), key=lambda dx: (labels.index(dx[1]['label']), dx[0]))
        if not rows:
            continue
        lines += ['', heading('###', group[0].upper() + group[1:]), '']
        for d, x in rows:
            e = x.get('entry') or {}
            if x['placed'] == 'checked entry' and e['standing'] == 'derived':
                more = f': a case of {_names(e["law"])}' + (f'; bridges {_names(e["bridges"])}' if e.get('bridges') else '') \
                       + (f'; support {_names(e["support"])}' if e.get('support') else '')
            elif x['placed'] == 'checked entry':
                more = (f': the form `{e["form"]}`; ' + '; '.join(f'`{h["hypothesis"]}` (countermodel `{h["countermodel"]}`, fit `{h["fit"]}`)'
                                                                for h in e['hypotheses'])
                        + f'; recovery `{e["recovery"]}`; certificate `{e["certificate"]}`'
                        + (f'; bridges {_names(e["bridges"])}' if e.get('bridges') else ''))
            else:
                more = ''
            how = {'checked entry': 'a checked entry',
                   'reading': 'a reading; the rule gives ' + ('the same' if x['rule'] == x['label'] else x['rule']),
                   'the rule': 'by the rule' + (f'; the declared standing, {e.get("standing")}, is unverified' if e else '')}[x['placed']]
            lines += [f'- `{d}`: {x["label"]} ({how}){more}.']
    return lines + ['']


def _grouped(field):
    """A boundary field's standings by declaration, as written."""
    out = {}
    standings = field.get('standings') if isinstance(field, dict) else None
    for x in standings if isinstance(standings, list) else []:
        d = x.get('declaration') if isinstance(x, dict) else None
        out.setdefault(d if isinstance(d, str) else '(an entry without a declaration)', []).append(x)
    return out


def rows_of(b):
    """The rows of the data's boundary report, {} where it has none of the right shape."""
    rows = b.get('rows') if isinstance(b, dict) else None
    return {d: x for d, x in rows.items() if isinstance(x, dict)} if isinstance(rows, dict) else {}


def boundary_matching(records, data):
    """(matched, not matched) between the boundary field the data read and the one a record carries now: the central
    declarations whose entry, or its absence, is the one the data read; and the declarations whose entry differs, with
    premises_of_the_ethics where the premises differ. Where the record around the field changed since the data read it,
    'the field' comes first, every declaration the field names, in either version, differs, and premises_of_the_ethics
    closes the list, since Q1's verdicts may differ too. Where the data read another record, none matches."""
    from tools.research import boundary
    b = data.get('boundary') if isinstance(data, dict) else None
    carrying = boundary.carriers(records)
    now = carrying[0] if len(carrying) == 1 else None
    if isinstance(b, dict) and 'error' in b:
        return set(), []  # the status shows the error instead
    if not isinstance(b, dict):
        return set(), sorted({d for r in carrying for d in _grouped(r['boundary'])} | ({'premises_of_the_ethics'} if carrying else set()))
    if now is None or now.get('id') != b.get('record'):
        return set(), sorted({*_grouped(b.get('declared')), *(d for r in carrying for d in _grouped(r['boundary'])), 'premises_of_the_ethics'})
    read, declared = _grouped(b.get('declared')), _grouped(now['boundary'])
    keys = lambda f: sorted(map(str, f)) if isinstance(f, dict) else None
    if b.get('context') != boundary.context(now) or keys(b.get('declared')) != keys(now['boundary']):
        # the record around the field, or the field's own keys, changed: every verdict of the field may differ, while
        # a row the field names in neither version keeps the rule's, which reads only its statement and F5's items
        named = {*read, *declared}
        return ({d for d in rows_of(b) if d not in named},
                ['the field', *sorted(named), 'premises_of_the_ethics'])
    differ = {d for d in {*read, *declared} if read.get(d) != declared.get(d)}
    premises = lambda f: f.get('premises_of_the_ethics') if isinstance(f, dict) else None
    return ({d for d in rows_of(b) if d not in differ},
            sorted(differ) + (['premises_of_the_ethics'] if premises(b.get('declared')) != premises(now['boundary']) else []))


def boundary_status(records, data):
    """The status's four lists for the boundary field (BOUNDARY-FIELD.md §3.6), and its error where two records carry it."""
    b = data.get('boundary') if isinstance(data.get('boundary'), dict) else {}
    if 'error' in b:
        return {'boundary_error': f'{b["error"]}: ' + ', '.join(map(str, b.get('records', []))), 'boundary_unverified': [],
                'boundary_premises_unverified': [], 'boundary_unplaced': [], 'boundary_not_matched': []}
    unverified = [(f'{x["declaration"]} ({x.get("standing")})' if isinstance(x.get('declaration'), str) else f'standing {x.get("item")}')
                  + ': ' + '; '.join(x.get('failed', [])) for x in b.get('unverified', [])]
    return {'boundary_unverified': unverified or ['the field: ' + m for m in b.get('field_failures', [])],
            'boundary_premises_unverified': [(p['role'] if isinstance(p.get('role'), str) else f'premise {p.get("item")}')
                                             + f': {p.get("premise")} (' + '; '.join(p.get('failed', [])) + ')'
                                             for p in b.get('premises_of_the_ethics', []) if p.get('result') == 'unverified'],
            'boundary_unplaced': sorted(d for d, x in rows_of(b).items() if x.get('label') == 'unplaced'),
            'boundary_not_matched': boundary_matching(records, data)[1]}


def shared_laws_status(records):
    """How far data/shared-laws.json still matches: laws whose declarations changed or that it has not read, whether
    the core sources it was computed on are still the latest receipt's, and whether the measure, its coverage, the
    dump or the generator changed. Reported by the check, never an error: rerunning needs the checker's cache."""
    data = shared_laws()
    if not data:
        return {'measured': False}
    if 'error' in data:
        return {'measured': False, 'error': data['error']}
    unmatched = [f'{r["id"]}:{i}' for r in records for i, law in enumerate(r.get('laws', []), 1)
                 if law.get('declarations') and (not r.get('_shared_laws') or (e := r['_shared_laws']['laws'].get(i)) is None
                                                 or e.get('declarations') != law.get('declarations', [])
                                                 or declared_items(e) != declared_items(law))]
    unverified = [f'{ident}:{e["law"]}:{x.get("declaration")} ({"; ".join(x.get("failed", []))})'
                  for ident, entries in sorted(data.get('records', {}).items()) for e in entries
                  for x in e.get('statements_at_model', []) if not x.get('verified')]
    receipt = json.loads((ROOT / CORE_RECEIPT).read_text()) if (ROOT / CORE_RECEIPT).is_file() else {}
    same = receipt.get('status') == 'passed' and data.get('core_sources_sha256') == hashlib.sha256(json.dumps(receipt.get('source_sha256', {}), sort_keys=True).encode()).hexdigest()
    changed = sorted(p for p, h in data.get('inputs_sha256', {}).items() if not (ROOT / p).is_file() or digest(ROOT / p) != h)
    edge = boundary_status(records, data)
    return {'measured_against': data.get('core_receipt'), 'latest_core_receipt': receipt.get('utc'),
            'core_sources_current': same, 'inputs_changed': changed, 'from_dump': data.get('from_dump', False),
            'current': same and not changed and not unmatched and not data.get('from_dump', False)
            and not edge['boundary_not_matched'] and 'boundary_error' not in edge,
            'laws_not_matched': len(unmatched), 'first_not_matched': unmatched[:10],
            'statements_at_model_unverified': unverified, **edge,
            'refresh': 'python3 -B tools/research/shared_laws.py, then make research-render'}


def law_family_errors(records):
    ids, seen, errors = {r.get('id') for r in records}, {}, []
    for f in law_families():
        name = f.get('id', '<missing>')
        if not pair(f.get('title')) or not pair(f.get('statement')):
            errors.append(f'law family {name}: title and statement need English or Chinese')
        if f.get('lead') not in f.get('members', []):
            errors.append(f'law family {name}: the lead must be a member')
        for m in f.get('members', []):
            if m not in ids:
                errors.append(f'law family {name}: unknown record {m}')
            if m in seen:
                errors.append(f'law family {name}: {m} is already in law family {seen[m]}')
            seen[m] = name
    return errors


def validate(records):
    from tools.research import style
    errors, drift = [], []
    GROWN.clear()
    read = Sources()
    ids, aliases = {}, {}
    settings = config()
    errors += validate_standard_boundaries(settings)
    errors += law_family_errors(records)
    errors += statements_at_model_across(records)
    errors += boundary_across(records)
    for r in records:
        ident = r.get('id', '<missing>')
        def fail(message):
            errors.append(f'{ident}: {message}')
        if not isinstance(ident, str) or not re.fullmatch(r'[a-z][a-z0-9-]+', ident):
            fail('invalid stable id')
        if ident in ids:
            fail('duplicate id')
        ids[ident] = r
        schema = r.get('schema_version')
        if type(schema) is not int or schema not in REQUIRED or r.get('kind') not in KINDS or r.get('status') not in STATUSES:
            fail('invalid schema, kind or status')
        v2 = schema == 2
        malformed = [key for key in ('hypotheses', 'history', 'aliases', 'references', 'dependencies', 'related', 'counterexamples') if not isinstance(r.get(key), list)]
        if malformed:
            fail('expected lists: ' + ', '.join(malformed))
            ids.pop(ident, None)
            continue
        if any(not isinstance(x, dict) for key in ('references', 'dependencies', 'related', 'counterexamples') for x in r[key]):
            fail('reference, edge and boundary entries must be objects')
            ids.pop(ident, None)
            continue
        if r.get('kind') == 'target' and r.get('status') not in {'open', 'superseded', 'withdrawn'}:
            fail('a target cannot be marked completed')
        for key in REQUIRED[2 if v2 else 1]:
            if not pair(r.get(key)):
                fail(f'{key} requires nonempty English or Chinese')
        if v2:
            for message in validate_v2_fields(r, settings):
                fail(message)
        else:
            if 'statement' in r and not pair(r['statement']):
                fail('statement, when present, requires nonempty English or Chinese')
            later = [key for key in (*V2_LISTS, 'boundary') if key in r]
            if later:
                fail('schema-2 fields need schema_version 2: ' + ', '.join(later))
        for finding in style.lint(r):
            if finding['severity'] == 'error':
                fail(f'{finding["field"]}: {finding["rule"]}: {finding["detail"]}')
        if 'overview' in r and not valid_overview(r['overview']):
            fail('overview requires title, summary and evidence, each in English or Chinese')
        if not r.get('hypotheses') or not all(pair(x) for x in r['hypotheses']):
            fail('explicit hypotheses required, each in English or Chinese')
        if not re.fullmatch(r'F\d\d', r.get('family', '')):
            fail('session-map family required')
        if not isinstance(r.get('reviewed_at_utc'), str) or not r['reviewed_at_utc'].endswith('+00:00'):
            fail('UTC documentary review timestamp required')
        if not r.get('history') or not all(pair(x) for x in r['history']):
            fail('provenance/history required, each entry in English or Chinese')
        for alias in [ident] + r.get('aliases', []):
            if not isinstance(alias, str) or not alias.strip():
                fail('invalid alias')
                continue
            key = alias.casefold()
            if key in aliases:
                fail(f'duplicate alias {alias!r}; already owned by {aliases[key]}')
            aliases[key] = ident
        refs = r.get('references', [])
        paths, roles = set(), set()
        for ref in refs:
            path, role = ref.get('path'), ref.get('role')
            if path in paths:
                fail(f'duplicate reference {path}')
            paths.add(path)
            roles.add(role)
            if role not in ROLES:
                fail(f'invalid reference role {role}')
            p = path_in_repo(path)
            if p is None:
                fail(f'missing or unsafe reference {path}')
                continue
            expected = ref.get('sha256', '')
            if not re.fullmatch(r'[0-9a-f]{64}', expected):
                fail(f'invalid reviewed hash {path}')
            elif read.digest(p) != expected:
                bearing = scoped_drift(r, path, expected, p)
                entry = {'id': ident, 'path': path, 'reviewed_sha256': expected, 'current_sha256': read.digest(p)}
                if bearing:
                    drift.append({**entry, 'changed_sections': bearing})
                else:
                    GROWN.append(entry)
            for name in ref.get('declarations', []):
                if not read.declares(p, name):
                    fail(f'declaration not found: {name} in {path}')
        if r.get('canonical_source') not in paths:
            fail('canonical source must be a hashed reference')
        if r.get('status') == 'recorded-checked' and not {'proof', 'receipt'} <= roles:
            fail('recorded-checked needs proof source and existing receipt')
        if r.get('status') == 'recorded-checked' and not r.get('proof_bindings'):
            fail('recorded-checked needs a source hash binding in its existing receipt')
        refs_by_path = {x['path']: x for x in refs}
        listed = set()
        for binding in r.get('proof_bindings', []):
            try:
                source = refs_by_path[binding['source']]
                receipt = refs_by_path[binding['receipt']]
                if source['role'] != 'proof' or receipt['role'] != 'receipt':
                    raise ValueError('binding roles must be proof and receipt')
                data = read.receipt(receipt['path'])
                if at_pointer(data, binding['sha256_pointer']) != source['sha256']:
                    raise ValueError('receipt does not bind the reviewed proof source')
                if at_pointer(data, binding['success_pointer']) != binding['success_value'] or binding['success_value'] not in (True, 'passed'):
                    raise ValueError('receipt has no recorded success at the specified field')
                # Where the receipt lists the declarations Lean elaborated for the bound
                # module, each declaration the record names must be among them by full name.
                module = binding['sha256_pointer'].rsplit('/', 1)[-1]
                elaborated = read.elaborated(receipt['path'], module)
                listed |= read.receipt_names(receipt['path'])
                unknown = [n for n in source.get('declarations', []) if elaborated and n not in elaborated]
                if unknown:
                    raise ValueError(f'declarations not elaborated in {module}: {", ".join(unknown)}')
            except (KeyError, IndexError, ValueError, TypeError, OSError) as exc:
                fail(f'invalid proof receipt binding: {exc}')
        # An alias written as a Lean name, in a namespace the bound receipts list, must be
        # among the declarations they list.
        roots = {n.split('.')[0] for n in listed}
        for alias in r.get('aliases', []):
            if isinstance(alias, str) and re.fullmatch(r"[A-Za-z_][\w']*(?:\.[\w'!?]+)+", alias) \
                    and alias.split('.')[0] in roots and alias not in listed:
                fail(f'alias not elaborated in the bound receipts: {alias}')
        if r.get('status') == 'reviewed-scoped' and not {'statement', 'review'} <= roles:
            fail('reviewed-scoped needs statement and review')
        if not isinstance(r.get('dependencies'), list) or not isinstance(r.get('related'), list):
            fail('dependencies and related must be explicit lists')
        if not isinstance(r.get('counterexamples'), list) or not (r.get('counterexamples') or (v2 and r.get('does_not_show'))):
            fail('counterexamples or explicit scoped boundary required')
        for c in r.get('counterexamples', []):
            if not pair(c.get('detail')) or c.get('path') not in paths:
                fail('counterexample/boundary needs its scope in English or Chinese and a hashed source')
    formers = {}
    for ident, r in ids.items():
        former = r.get('former_ids', [])
        if not isinstance(former, list) or not all(isinstance(f, str) and re.fullmatch(r'[a-z][a-z0-9-]+', f) for f in former):
            errors.append(f'{ident}: former_ids must be a list of record ids')
            continue
        for f in former:
            if f in ids:
                errors.append(f'{ident}: former id {f} is a live record id')
            if f in formers:
                errors.append(f'{ident}: former id {f} is also a former id of {formers[f]}')
            formers[f] = ident
    for ident, r in ids.items():
        for edge in r.get('dependencies', []) + r.get('related', []):
            if edge.get('id') not in ids or edge.get('id') == ident:
                errors.append(f'{ident}: missing or self result link {edge.get("id")}')
            if not pair(edge.get('detail')):
                errors.append(f'{ident}: result link needs its scope in English or Chinese')
        for edge in r.get('dependencies', []):
            if edge.get('relation') not in RELATIONS:
                errors.append(f'{ident}: dependency requires an explicit relation type')
            if 'interface' in edge:
                contract = edge['interface']
                if not isinstance(contract, dict) or not all(pair(contract.get(k)) for k in ('output', 'input', 'conditions')):
                    errors.append(f'{ident}: dependency interface needs output, input and conditions, each in English or Chinese')
                elif contract.get('evidence') not in {x['path'] for x in r['references']}:
                    errors.append(f'{ident}: dependency interface evidence must be a reviewed reference')
        if r.get('status') == 'superseded' and r.get('superseded_by') not in ids:
            errors.append(f'{ident}: superseded status needs replacement id')
    # Only declared dependencies are directed inference edges; analogies are separate.
    visiting, done = set(), set()
    def visit(ident):
        if ident in visiting:
            errors.append(f'{ident}: circular result dependency')
            return
        if ident in done or ident not in ids:
            return
        visiting.add(ident)
        for edge in ids[ident].get('dependencies', []):
            visit(edge.get('id'))
        visiting.remove(ident)
        done.add(ident)
    for ident in ids:
        visit(ident)
    return errors, drift


def link(path, base, label=None):
    return f'[{label or Path(path).name}]({os.path.relpath(ROOT / path, base)})'


def statement_lines(statement):
    return ['> ' + en(statement), '']


# History entries that only rebind a record to new receipts or to source versions reread after a
# change, leaving the claim as it was. On a record page they fold into one counted line; the
# record keeps every entry. An entry that also says the record's own text changed stays visible.
REBINDING = re.compile(
    r're-pointed to (?:the )?(?:new |consolidated |current )?receipt|now points to the new receipt|'
    r'rebound to the new receipts?|\brehashed\b|reconciled after reading the changes to|'
    r'merge reconciliation|source maintenance: reviewed only|source reconciliation|documentary reconciliation|'
    r'documentary correspondence|shared-chapter review|Review of this main commit|restores the preceding review entry|'
    r'reran the consolidated checker|consolidated checker was rerun|only the receipt, counts and hashes are updated|'
    r'reviewed the added [^.;]{0,80}(?:paragraph|row)', re.I)
CHANGES_RECORD = re.compile(
    r'\b(?:claim|statement|premises?|hypothes[ie]s|status|title|does[- ]not[- ]show|limitations?|next[_ ]delta) '
    r'(?:now\b|became\b|was (?:changed|revised|corrected|narrowed|widened|replaced))|corrected this record|'
    r'this record is corrected|\bwithdrawn\b|\bsuperseded\b|\bnew theorem|\breadings? (?:adopted|decided)', re.I)
MONTHS = {m: i for i, m in enumerate(('January February March April May June July August September October '
                                      'November December').split(), 1)}


def rebinding(entry):
    """True for a history entry that only rebinds the record (see REBINDING)."""
    text = entry.get('en') or entry.get('zh') or ''
    return bool(REBINDING.search(text)) and not CHANGES_RECORD.search(text)


def entry_date(entry):
    text = entry.get('en') or ''
    m = re.match(r'\s*(20\d\d-\d\d-\d\d)', text)
    if m:
        return m[1]
    m = re.match(r'\s*(\d{1,2}) (' + '|'.join(MONTHS) + r') (20\d\d)', text)
    return f'{m[3]}-{MONTHS[m[2]]:02d}-{int(m[1]):02d}' if m else None


def history_lines(r):
    """Substantive history entries in order, then one line counting the folded rebindings."""
    kept = [h for h in r['history'] if not rebinding(h)]
    folded = [h for h in r['history'] if rebinding(h)]
    lines = ['- ' + en(h) for h in kept]
    if folded:
        dates = sorted(d for d in map(entry_date, folded) if d)
        span = f' ({dates[0]} to {dates[-1]})' if dates and dates[0] != dates[-1] else f' ({dates[0]})' if dates else ''
        lines += [f'- {len(folded)} rebinding {"entry" if len(folded) == 1 else "entries"}{span}: receipts re-pointed '
                  f'or sources rehashed after reading their changes, with the claim unchanged. Each is kept in the '
                  f'[record]({r["id"]}.json).']
    return lines


FOOTER = ('Hashes in the record bind the reviewed sources; the checker does not audit transitive Lean imports '
          'or establish premise warrant, and this page is not a proof receipt.')


def law_family_lines(r, result_link):
    """The law family the record belongs to (data/law-families.json), with its lead and members."""
    f = r.get('_law_family')
    if not f:
        return []
    others = ' · '.join(result_link(m) for m in f['members'] if m != r['id'])
    lead = 'this record' if f['lead'] == r['id'] else result_link(f['lead'])
    return ['', f'**Law family:** {en(f["title"])} (lead: {lead}). {en(f["statement"])} Members: {others}.']


def used_by_lines(r, result_link):
    """The reverse edges: results whose records name this one as a dependency."""
    used = r.get('_used_by', [])
    if not used:
        return []
    return ['', '**Used by:** ' + ' · '.join(result_link(c) + ('' if rel == 'formal-reuse' else f' ({rel})') for c, rel in used)]


def render_record_v2(r):
    """Schema 2: what the result does first, then exact conditions; sources and history folded."""
    base = record_path(r).parent
    def result_link(ident):
        target = r.get('_record_links', {}).get(ident)
        return link(str(Path(target).with_suffix('.md')), base, ident) if target else f'[{ident}]({ident}.md)'
    def anchored(source):
        file, sep, anchor = source.partition('#')
        return f'[study]({os.path.relpath(ROOT / file, base)}{sep}{anchor})'
    title = r['title']
    lines = [heading('#', en(title), f'{title.get("en", "")} / {title.get("zh", "")}'), '',
             '<!-- Generated by tools/research/registry.py; edit the matching JSON record. -->', '',
             f'`{r["id"]}` · **{r["status"]}** · {r["kind"]} · {r["family"]} · [record]({r["id"]}.json) · ' + link('RESULTS.md', base, 'register'), '']
    lines += statement_lines(r['statement'])
    if 'overview' in r:
        o = r['overview']
        lines += ['<details><summary>README overview</summary>', '', '**' + en(o['title']) + '**', '',
                  en(o['summary']), '', '**Evidence:** ' + en(o['evidence']), '', '</details>', '']
    progress = [heading('##', 'Progress', 'Progress / 已接通'), ''] + [f'{i}. ' + en(x) + ' ' + anchored(x['source']) for i, x in enumerate(r.get('progress', []), 1)] + ['']
    if r.get('progress') and r['kind'] == 'target':
        lines += progress  # for an open target, what is already connected comes first
    if 'claim' in r:
        lines += [heading('##', 'Exact statement', 'Exact statement / 确切陈述'), '', en(r['claim']), '']
    if r.get('laws'):
        lines += [heading('##', 'Laws', 'Laws / 规律'), '']
        for i, law in enumerate(r['laws'], 1):
            names = ', '.join('`' + d + '`' for d in law.get('declarations', []))
            lines += [f'{i}. ' + en(law) + (f' ({names})' if names else '')]
            note = shared_law_note(r, i, law)
            standings = r.get('_standings', {})
            edge = [standing_line(d, standings['rows'][d], standings['record'], result_link, base)
                    for d in dict.fromkeys(law.get('declarations', [])) if d in standings.get('rows', {})]
            for line in ([note] if note else []) + at_model_notes(r, i, law, result_link, base) + edge:
                lines += [' ' * len(f'{i}. ') + '- ' + line]  # a child of item i: as wide as its marker
        lines += ['']
    lines += boundary_section(r, base)
    lines += [heading('##', 'Conditions', 'Conditions / 条件'), '']
    lines += ['- ' + en(x) for x in r['hypotheses']]
    if r.get('not_required'):
        lines += ['', '**Not required by this target:**', '']
        lines += ['- ' + en(x) for x in r['not_required']]
    if r.get('does_not_show') or r.get('counterexamples'):
        lines += ['', heading('##', 'Does not show', 'Does not show / 未表明'), '']
        lines += ['- ' + en(x) + (f' Witness: `{x["witness"]}`.' if x.get('witness') else '') for x in r.get('does_not_show', [])]
        lines += ['- **Counterexample:** ' + en(c['detail']) + ' ' + link(c['path'], base, 'source') for c in r['counterexamples']]
    if r.get('standard_boundaries'):
        known = standard_boundaries()
        lines += ['', '**Standard boundaries:** ' + ' · '.join(en(known[k]) for k in r['standard_boundaries'])]
    if r.get('progress') and r['kind'] != 'target':
        lines += [''] + progress[:-1]
    lines += ['', heading('##', 'Evidence', 'Evidence / 证据'), '', en(r['validation_scope']), '', 'Canonical source: ' + link(r['canonical_source'], base), '',
              heading('##', 'Next', 'Next / 下一步'), '',
              (f'Superseded by {result_link(r["superseded_by"])}, whose record carries the next step. When this record was current, its next step read: ' + en(r['next_delta'])) if r.get('status') == 'superseded' else en(r['next_delta']), '',
              '<details><summary>Correspondence, dependencies, sources and history</summary>', '',
              heading('###', 'Correspondence', 'Correspondence / 对应'), '', en(r['correspondence']), '',
              heading('###', 'Dependencies', 'Dependencies / 依赖'), '']
    for e in r['dependencies']:
        lines += [f'- **{e["relation"]}**: {result_link(e["id"])}. {en(e["detail"])}']
        if 'interface' in e:
            c = e['interface']
            lines += ['  - Output: ' + en(c['output']), '  - Input: ' + en(c['input']),
                      '  - Preserved conditions: ' + en(c['conditions']) + ' ' + link(c['evidence'], base)]
    if not r['dependencies']:
        lines += ['- none']
    lines += [f'- related, not a proved adapter: {result_link(e["id"])}. {en(e["detail"])}' for e in r['related']]
    lines += used_by_lines(r, result_link)
    lines += law_family_lines(r, result_link)
    lines += ['', heading('###', 'Sources', 'Sources / 来源'), '', '| Role | Source | Declarations |', '|---|---|---|']
    lines += [f'| {x["role"]} | {link(x["path"], base)} | {", ".join("`" + d + "`" for d in x.get("declarations", [])) or "—"} |' for x in r['references']]
    lines += ['', 'Aliases: ' + (', '.join('`' + a + '`' for a in r['aliases']) or '—'), '', heading('###', 'History', 'History / 沿革'), '']
    lines += history_lines(r)
    if r.get('text_versions'):
        lines += ['', heading('###', 'Earlier text', 'Earlier text / 早期文本'), '']
        lines += ['- ' + link(v['path'], base, Path(v['path']).name) + f' (sha256 `{v["sha256"][:16]}…`): ' + en(v['note']) for v in r['text_versions']]
    lines += ['', '</details>', '', f'Documentary review UTC: `{r["reviewed_at_utc"]}`. ' + FOOTER]
    return finish(lines)


def render_record(r):
    if r.get('schema_version') == 2:
        return render_record_v2(r)
    base = record_path(r).parent
    def result_link(ident):
        target = r.get('_record_links', {}).get(ident)
        return link(str(Path(target).with_suffix('.md')), base, ident) if target else f'[{ident}]({ident}.md)'
    title = r['title']
    lines = [heading('#', en(title), f'{title.get("zh", "")} / {title.get("en", "")}'), '',
             '<!-- Generated by build_result_registry.py; edit the matching JSON record. -->', '']
    if 'statement' in r:
        lines += statement_lines(r['statement'])  # optional on schema 1: what the result does, first
    lines += [f'`{r["id"]}` · **{r["status"]}** · {r["kind"]} · {r["family"]}', '',
             f'Editable record: [{r["id"]}.json]({r["id"]}.json) · ' + link('RESULTS.md', base, 'Register'), '',
             f'Documentary review UTC: `{r["reviewed_at_utc"]}`. Run the registry checker for source drift; this page is not a fresh proof receipt.', '']
    if 'overview' in r:
        overview = r['overview']
        lines += [heading('##', 'Overview', 'Overview / 首页摘要'), '', '**' + en(overview['title']) + '**', '',
                  en(overview['summary']), '', '**Evidence:** ' + en(overview['evidence']), '']
    lines += [heading('##', 'Claim', '主张 Claim'), '', en(r['claim']), '',
             'Canonical source: ' + link(r['canonical_source'], base), '',
             heading('##', 'Hypotheses and correspondence', '前提与对应 Hypotheses and correspondence'), '']
    lines += ['- ' + en(x) for x in r['hypotheses']]
    lines += ['', en(r['correspondence']), '', heading('##', 'Validation and boundaries', '检验与边界 Validation and boundaries'), '',
              en(r['validation_scope']), '', en(r['limitations']), '']
    lines += [('Boundary source: ' if c['detail'] == r['limitations'] else '- ' + en(c['detail']) + ' ') + link(c['path'], base) for c in r['counterexamples']]
    lines += ['', heading('##', 'Dependencies and related results', '依赖与关联 Dependencies and related results'), '']
    lines += [f'- **{e["relation"]}**: {result_link(e["id"])}. {en(e["detail"])}' for e in r['dependencies']]
    for e in r['dependencies']:
        if 'interface' in e:
            c = e['interface']
            lines += ['', '**Output:** ' + en(c['output']), '', '**Input:** ' + en(c['input']), '', '**Preserved conditions:** ' + en(c['conditions']) + ' ' + link(c['evidence'], base), '']
    if not r['dependencies']:
        lines += ['No dependency on another migrated record is asserted; source imports and supplied premises remain in scope.', '']
    lines += [f'- Related, not a proved adapter: {result_link(e["id"])}. {en(e["detail"])}' for e in r['related']]
    lines += used_by_lines(r, result_link)
    lines += law_family_lines(r, result_link)
    lines += ['', heading('##', 'Sources and existing receipts', '来源与既有回执 Sources and existing receipts'), '', '| Role | Source | Declarations |', '|---|---|---|']
    lines += [f'| {x["role"]} | {link(x["path"], base)} | {", ".join("`" + d + "`" for d in x.get("declarations", [])) or "—"} |' for x in r['references']]
    lines += ['', 'Hashes in the editable record bind the reviewed source versions. The checker does not audit transitive Lean imports or establish premise warrant.', '',
              heading('##', 'Reuse and next delta', '复用与下一增量 Reuse and next delta'), '', en(r['next_delta']), '',
              'Aliases: ' + (', '.join('`' + a + '`' for a in r['aliases']) or '—'), '', heading('##', 'History', '沿革 History'), '']
    lines += history_lines(r)
    return finish(lines)


def render_index(records):
    """The earlier register, now a pointer to RESULTS.md; its anchors are kept."""
    root = os.path.relpath(ROOT, OUT)
    to = lambda target, label: f'[{label}]({root}/{target})'
    lines = [heading('#', 'Canonical result register', '成果登记表 Canonical result register'), '', '<!-- Generated by tools/research/registry.py; edit records/*.json. -->', '',
             'This page earlier repeated the register of results. It is kept so that links to it resolve. The single register is '
             + to('RESULTS.md', 'RESULTS.md') + f' ({len(records)} records); each record page is generated next to its JSON record in [records](records/).', '',
             to('_process/RESULT-WORKFLOW.md', 'Contribution workflow') + ' · [Chapter readings of 8 October 2026 and later](README.md)', '',
             heading('##', 'Where to look first', '先查哪一项 Where to look first'), '', 'Now in ' + to('RESULTS.md#where-to-look-first', 'the register') + '.', '',
             heading('##', 'Check and search', '检查与检索 Check and search'), '', 'From the repository root:', '', '```sh',
             'make research-check',
             'make research-find QUERY=support',
             '```', '',
             'The checker verifies record structure, aliases, links, named-declaration presence, dependency cycles, reviewed source hashes and generated views. It does not compile Lean, prove semantic equivalence, establish empirical correspondence or replace substantive review.']
    return finish(lines)


def record_path(record):
    return ROOT / record.get('_record_path', str((RECORDS / (record['id'] + '.json')).relative_to(ROOT)))


def attach_standings(records, measured, matched_at_model):
    """The boundary field on the pages: a central declaration's standing line shows under the laws naming it while its
    entry, or its absence, is what the data read; a line whose label, or the rule's label beside a reading, U4's rule
    draws from F5's items, while each F5 law it cites is matched too. The record carrying the field gets the data's report for its section, or, where the data read another
    version of the field or none, the declarations not matched."""
    from tools.research import boundary
    b = measured.get('boundary')
    if isinstance(b, dict) and 'error' in b:
        return  # two records carry the field: the check refuses it and nothing renders
    shown, not_matched = boundary_matching(records, measured)
    if not isinstance(b, dict) or not isinstance(b.get('rows'), dict):
        for r in boundary.carriers(records):
            r['_boundary'] = {'not_matched': not_matched}
        return
    def cites(row):
        return row['placed'] == 'checked entry' or not {row['label'], row.get('rule')} & {'at a represented model', 'own carrier'} \
            or all(f'{x["record"]}:{x["law"]}' in matched_at_model for x in row['at_model'])
    rows_b = rows_of(b)
    for r in records:
        rows = {d: rows_b[d] for d in sorted(law_names(r) & shown) if d in rows_b and cites(rows_b[d])}
        if rows:
            r['_standings'] = {'record': b['record'], 'rows': rows}
        if 'boundary' in r:
            r['_boundary'] = {**b, 'not_matched': not_matched} if r.get('id') == b.get('record') else {'not_matched': not_matched}


def law_names(r):
    """The declarations a record's laws name."""
    laws = r.get('laws') if isinstance(r.get('laws'), list) else []
    return {d for law in laws if isinstance(law, dict) and isinstance(law.get('declarations'), list)
            for d in law['declarations'] if isinstance(d, str)}


def load_records():
    config = json.loads((ROOT / '_process/research-config.json').read_text())
    records, errors = [], []
    for directory in config['record_directories']:
        for path in sorted((ROOT / directory).glob('*.json')):
            try:
                r = json.loads(path.read_text())
                if not isinstance(r, dict) or r.get('id') != path.stem:
                    errors.append(f'{path.name}: filename/id mismatch or not an object')
                else:
                    r['_record_path'] = str(path.relative_to(ROOT))
                    records.append(r)
            except (ValueError, OSError) as e:
                errors.append(f'{path.name}: {e}')
    if not records:
        errors.append('no records found')
    paths = {r['id']: r['_record_path'] for r in records}
    used_by = {}
    for r in records:
        for e in r.get('dependencies', []) if isinstance(r.get('dependencies'), list) else []:
            if isinstance(e, dict) and isinstance(e.get('id'), str):
                used_by.setdefault(e['id'], []).append((r['id'], e.get('relation')))
    for r in records:
        r['_record_links'] = paths
        r['_used_by'] = sorted(used_by.get(r['id'], []))  # reverse edges, shown as "Used by" on the page
    family = {m: f for f in law_families() for m in f.get('members', [])}
    for r in records:
        if r['id'] in family:
            r['_law_family'] = family[r['id']]
    measured = shared_laws()
    for r in records:
        if isinstance(measured.get('records'), dict) and r['id'] in measured['records']:
            r['_shared_laws'] = {'names': measured.get('names', {}), 'laws': {e['law']: e for e in measured['records'][r['id']]}}
    # F5: the laws whose statements at a model the data read exactly as their records now declare them; the lines of
    # an item, under its own law and under its row's laws in any record, are shown only for these.
    matched = {f'{r["id"]}:{i}' for r in records if '_shared_laws' in r and isinstance(r.get('laws'), list)
               for i, law in enumerate(r['laws'], 1)
               if isinstance(law, dict) and law.get('statements_at_model') is not None
               and (e := r['_shared_laws']['laws'].get(i)) is not None and e.get('statements_at_model') is not None
               and e.get('declarations') == law.get('declarations', []) and declared_items(e) == declared_items(law)}
    for r in records:
        if '_shared_laws' in r:
            r['_shared_laws']['matched_at_model'] = sorted(matched)  # a list: records are dumped as JSON elsewhere
    attach_standings(records, measured, matched)
    return sorted(records, key=lambda r: r['id']), errors


def affected_ids(records, changed):
    shared = standard_boundaries_path() in changed  # its text renders on every citing page
    families = LAW_FAMILIES in changed  # its text renders on every member's page
    measured = SHARED_LAWS in changed  # it renders under the laws of every record it reads
    # A change to the boundary record changes the standing lines under every law naming a central declaration.
    from tools.research import boundary
    data = shared_laws()
    b = data.get('boundary') if isinstance(data.get('boundary'), dict) else {}
    holders = {b.get('record')} | {r['id'] for r in boundary.carriers(records)}
    paths = {str(record_path(r).relative_to(ROOT)) for r in records if r['id'] in holders}
    if isinstance(b.get('record'), str):
        paths.add(str((RECORDS / (b['record'] + '.json')).relative_to(ROOT)))  # the data's record, though it is gone
    edge = set()
    if paths & changed:
        edge = {c['declaration'] for entries in (data.get('records') or {}).values() for e in entries for c in e.get('central', [])}
        edge |= set(rows_of(b))
    # A change to an F5 carrier shows or hides the lines that cite its laws.
    touched = {r['id'] for r in records if str(record_path(r).relative_to(ROOT)) in changed}
    edge |= {d for d, x in rows_of(b).items() if isinstance(x.get('at_model'), list)
             and any(isinstance(i, dict) and i.get('record') in touched for i in x['at_model'])}
    selected = {r['id'] for r in records if str(record_path(r).relative_to(ROOT)) in changed or any(x['path'] in changed for x in r['references'])
                or any(v.get('path') in changed for v in r.get('text_versions', []) if isinstance(v, dict))
                or (shared and r.get('standard_boundaries')) or (families and r.get('_law_family'))
                or (measured and (r.get('laws') or r['id'] in holders)) or (edge and any(d in edge for d in law_names(r)))}
    # A changed record's producers list it under "Used by" on their pages.
    selected |= {e['id'] for r in records if r['id'] in selected for e in r['dependencies']}
    while True:
        more = {r['id'] for r in records if any(e['id'] in selected for e in r['dependencies'])}
        if more <= selected:
            return selected
        selected |= more


def redirect_pages(records):
    """{path of a former id's page: its generated redirect} (R35, E4): old links keep resolving."""
    pages = {}
    for r in records:
        page = record_path(r).with_suffix('.md')
        for old in r.get('former_ids', []) if isinstance(r.get('former_ids'), list) else []:
            pages[page.with_name(old + '.md')] = finish([
                heading('#', f'{old} (renamed)', f'{old} (renamed)'), '',
                '<!-- Generated by tools/research/registry.py from the former_ids of the record it names. -->', '',
                f'The record `{old}` is now `{r["id"]}`: [{en(r["title"])}]({r["id"]}.md). '
                'Its history, earlier text and sources are kept under the new id; this page keeps old links resolving.', ''])
    return pages


def orphan_pages(records):
    expected = {record_path(r).with_suffix('.md') for r in records} | set(redirect_pages(records))
    directories = json.loads((ROOT / '_process/research-config.json').read_text())['record_directories']
    return [f'orphan generated page: {p.relative_to(ROOT)}; preserve/migrate deliberately'
            for directory in directories for p in (ROOT / directory).glob('*.md') if p not in expected]


def write_views(records, drift, selected=None):
    """One stale record never prevents healthy records or the index rendering."""
    stale = {d['id'] for d in drift}
    (OUT / 'RESULT-REGISTER.md').write_text(render_index(records))
    written = []
    for r in records:
        if r['id'] not in stale and (selected is None or r['id'] in selected):
            path = record_path(r).with_suffix('.md')
            path.write_text(render_record(r))
            written.append(r['id'])
    return written


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--check', action='store_true')
    ap.add_argument('--search')
    ap.add_argument('--ids', nargs='+', help='Limit freshness and per-record rendering; global metadata remains checked')
    args = ap.parse_args()
    if not args.check and not args.search:
        from tools.research import research
        with research.render_lock():
            code, result = research.check_or_render(True, ids=args.ids)
        print(json.dumps(result, ensure_ascii=False, indent=2))
        return code
    records, errors = load_records()
    if args.search:
        needle = args.search.casefold()
        for r in records:
            if needle in json.dumps(r, ensure_ascii=False).casefold():
                print(f'{r["id"]}\t{r["status"]}\t{en(r["title"])}')
        return 1 if errors else 0
    findings, drift = validate(records)
    errors += findings
    selected = set(args.ids) if args.ids else {r['id'] for r in records}
    errors += [f'unknown result id: {x}' for x in selected - {r['id'] for r in records}]
    stale = {d['id'] for d in drift}
    outputs = {} if errors else {OUT / 'RESULT-REGISTER.md': render_index(records), **{record_path(r).with_suffix('.md'): render_record(r) for r in records if r['id'] in selected and r['id'] not in stale}}
    for path, body in outputs.items():
        if args.check:
            if not path.exists() or path.read_text() != body:
                errors.append(f'outdated generated view: {path.relative_to(ROOT)}')
        else:
            path.write_text(body)
    errors += orphan_pages(records)
    scoped_drift = [d for d in drift if d['id'] in selected]
    print(json.dumps({'records': len(records), 'errors': errors, 'source_drift': scoped_drift, 'other_record_drift': [d for d in drift if d['id'] not in selected],
                      'scope': 'Documentary checks only; no Lean build or semantic proof audit.'}, ensure_ascii=False, indent=2))
    return 1 if errors else 2 if scoped_drift else 0


if __name__ == '__main__':
    raise SystemExit(main())
