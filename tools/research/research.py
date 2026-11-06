#!/usr/bin/env python3
"""One entry point for research navigation, focused validation and discovery."""
from __future__ import annotations
import argparse
from collections import defaultdict
from contextlib import contextmanager
import fcntl
import json
import os
from pathlib import Path
import re
import subprocess
import sys
from urllib.parse import unquote, urlsplit

ROOT = Path(__file__).resolve().parents[2]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
from tools.research import registry, navigation, completion, lean_catalogue, reading_catalogue, style, paths, moves, indexes, session_map, history_notes, rename_ids, theory_graph, atlas, connection_map


@contextmanager
def render_lock():
    """Serialize cooperating writers; arbitrary prose editors retain hash guards."""
    path = subprocess.check_output(['git', 'rev-parse', '--git-path', 'research-navigation.lock'], cwd=ROOT, text=True).strip()
    with (ROOT / path).open('a') as stream:
        try:
            fcntl.flock(stream, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            raise ValueError('Another research renderer is active; retry after it finishes.') from None
        try:
            yield
        finally:
            fcntl.flock(stream, fcntl.LOCK_UN)


def input_snapshot():
    """Bind a render to the exact metadata/source inventory it began reading."""
    config = navigation.read(navigation.CONFIG)
    paths = {navigation.CONFIG, navigation.HISTORY, ROOT / registry.SHARED_LAWS, ROOT / registry.LAW_FAMILIES}  # both render on record pages
    for key in ('readme_first_screen', 'readme_opening', 'readme_lead', 'readme_repository'):
        if isinstance(config.get(key), str):
            paths.add(ROOT / config[key])
    paths.update(navigation.timed_paths(config))  # README's first screen times them
    if registry.standard_boundaries_path(config):
        paths.add(ROOT / registry.standard_boundaries_path(config))
    paths.update((ROOT / config['goal_directory']).glob('*.json'))
    paths.update(atlas.inputs())
    for directory in config['record_directories']:
        for path in (ROOT / directory).glob('*.json'):
            paths.add(path)
            try:
                data = json.loads(path.read_text())
                paths.update(ROOT / ref['path'] for ref in data.get('references', []) if isinstance(ref, dict) and isinstance(ref.get('path'), str))
            except (ValueError, AttributeError):
                pass  # The ordinary validator reports malformed input.
    return {str(p): registry.digest(p) if p.is_file() else None for p in paths}


def unchanged_inputs(before):
    return before == input_snapshot()


def revision(base):
    # Git validates the revision; never interpolate it into a shell command.
    return subprocess.check_output(['git', 'rev-parse', '--verify', base + '^{commit}'], cwd=ROOT, text=True).strip()


def changed_paths(base):
    rev = revision(base)
    changed = subprocess.check_output(['git', 'diff', '--name-only', '-z', rev, '--'], cwd=ROOT).decode().split('\0')
    new = subprocess.check_output(['git', 'ls-files', '--others', '--exclude-standard', '-z'], cwd=ROOT).decode().split('\0')
    return set(changed + new) - {''}


def ratchet(records, base, changed=None):
    """Growth findings for changed records against their bytes at `base` (errors), and
    a warning for a record created in schema 1 rather than schema 2."""
    rev = revision(base)
    changed = changed_paths(base) if changed is None else changed
    findings = []
    for r in records:
        path = str(registry.record_path(r).relative_to(ROOT))
        if path not in changed:
            continue
        try:
            old = json.loads(subprocess.check_output(['git', 'show', f'{rev}:{path}'], cwd=ROOT, stderr=subprocess.DEVNULL))
        except subprocess.CalledProcessError:
            if r.get('schema_version') != 2:
                findings.append({'id': r['id'], 'field': 'schema_version', 'rule': 'new-v1-record', 'severity': 'warning',
                                 'detail': 'write new records in schema 2'})
            continue
        except ValueError:
            continue  # The earlier bytes were not a record; nothing to compare.
        if isinstance(old, dict):
            findings += style.growth(old, r)
    return findings


def lint(ids=None, base=None):
    """Every readability finding, with the growth ratchet when a base commit is given."""
    records, errors = registry.load_records()
    selected = set(ids) if ids else registry.affected_ids(records, changed_paths(base)) if base else {r['id'] for r in records}
    findings = [f for r in records if r['id'] in selected for f in style.lint(r)]
    if base:
        findings += [f for f in ratchet(records, base) if f['id'] in selected]
    return {'records': len(selected), 'summary': style.summary(findings), 'findings': findings, 'errors': errors,
            'scope': 'Form only: length, process narration, shared boundaries written out. Whether a boundary is substantive is the author\'s reading.'}


def inventory():
    files = subprocess.check_output(['git', 'ls-files', '--cached', '--others', '--exclude-standard', '-z'], cwd=ROOT).decode().split('\0')
    return sorted({p for p in files if p and (ROOT / p).is_file()})


def working(path):
    parts = Path(path).parts
    # One shared classifier decides source, scratch, history and frozen evidence; a
    # component named `history` is history for every file type, Lean included.
    if paths.role(path) not in ('live', 'generated'):
        return False
    if path.endswith('.lean'):
        return lean_catalogue.role(path, {'declarations': [True], 'print_axioms_commands': 0}) == 'working-source'
    if parts[0] not in {'theories', '_process', 'tools', 'experiments'}:
        return len(parts) == 1 and path.endswith('.md')
    if any(x in parts for x in ['history', 'development', 'snapshots', 'verification-history']) or any(x.endswith(('-checks', '-verification', '-development')) for x in parts):
        return False
    if '/results/records/' in path and path.endswith('.md'):
        return False  # Search the editable record once, not its generated copy.
    return path.endswith(('.md', '.py'))


def search(query, archives=False, limit=30):
    records, errors = registry.load_records()
    needle = query.casefold()
    results = []
    for r in records:
        text = json.dumps({k: r.get(k) for k in ('id', 'former_ids', 'title', 'statement', 'claim', 'laws', 'does_not_show', 'aliases')}, ensure_ascii=False)
        if needle in text.casefold():
            results.append({'kind': 'result', 'path': str(registry.record_path(r).relative_to(ROOT)), 'id': r['id'], 'summary': registry.en(r['title'])})
    for path in inventory():
        if not archives and not working(path):
            continue
        if Path(path).suffix not in {'.md', '.lean', '.py', '.json', '.txt'}:
            continue
        if len(results) >= limit:
            break
        if needle in path.casefold():
            results.append({'kind': 'source', 'path': path})
            continue
        # Bound reading for large frozen evidence files when archives are requested.
        if (ROOT / path).stat().st_size > 2_000_000:
            continue
        body = (ROOT / path).read_text(errors='replace')
        for n, line in enumerate(body.splitlines(), 1):
            at = line.casefold().find(needle)
            if at >= 0:
                results.append({'kind': 'source', 'path': path, 'line': n, 'snippet': line[max(0, at-60):at+180]})
                break
    return {'archives_included': archives, 'results': results[:limit], 'errors': errors}


def import_graph():
    paths = [p for p in inventory() if p.endswith('.lean') and working(p)]
    names = defaultdict(list)
    for path in paths:
        names[Path(path).stem].append(path)
    edges, unresolved = [], []
    for path in paths:
        for mod in re.findall(r'^\s*import\s+(\S+)', lean_catalogue.scrub((ROOT / path).read_text()), re.M):
            matches = names.get(mod.split('.')[-1], [])
            if len(matches) == 1:
                edges.append({'consumer': path, 'producer': matches[0], 'module': mod, 'kind': 'textual-import-candidate'})
            else:
                unresolved.append({'consumer': path, 'module': mod, 'candidates': matches, 'reason': 'external-or-unresolved' if not matches else 'ambiguous-local-module'})
    return {'working_modules': len(paths), 'edges': edges, 'unresolved': unresolved, 'scope': 'Textual import candidates, not elaborated Lean resolution or proof of conceptual composition. Frozen copies are excluded.'}


def check_links(outputs, planned=()):
    errors = []
    available = {(ROOT / p).resolve() for p in planned}
    for name, body in outputs.items():
        for target in re.findall(r'\]\((<[^>]+>|[^\s)]+)\)', body):
            part = urlsplit(target.strip('<>'))
            if part.scheme or not part.path:
                continue
            p = ((ROOT / name).parent / unquote(part.path)).resolve()
            if not p.exists() and p not in available:
                errors.append(f'{name}: missing link {target}')
            elif part.fragment and p.suffix == '.md':
                relative = str(p.relative_to(ROOT)) if p.is_relative_to(ROOT) else None
                body = outputs.get(relative) if relative in planned else None
                found = reading_catalogue.anchors_from_text(body) if body is not None else reading_catalogue.anchors(p)
                if unquote(part.fragment) not in found:
                    errors.append(f'{name}: missing anchor {target}')
    return errors


SECRET_PATTERNS = {
    'openrouter': r'sk-or-v1-[0-9a-f]{64}',
    'anthropic': r'sk-ant-[A-Za-z0-9_-]{20,}',
    'openai': r'sk-proj-[A-Za-z0-9_-]{20,}',
    'github': r'(?<![A-Za-z0-9_])(?:ghp_[A-Za-z0-9]{36}|github_pat_[A-Za-z0-9_]{22,})',
    'aws': r'(?<![A-Z0-9])AKIA[0-9A-Z]{16}(?![A-Z0-9])',
    'google': r'AIza[0-9A-Za-z_-]{35}',
    'slack': r'xox[abprs]-[A-Za-z0-9-]{10,}',
    'huggingface': r'(?<![A-Za-z0-9_])hf_[A-Za-z0-9]{34}(?![A-Za-z0-9])',
    'private-key': r'-----BEGIN (?:[A-Z0-9]+ )*PRIVATE KEY-----',
}
SECRET_PREFIXES = ['sk-or-v1-', 'sk-ant-', 'sk-proj-', 'ghp_', 'github_pat_', 'AKIA', 'AIza',
                   'xoxa-', 'xoxb-', 'xoxp-', 'xoxr-', 'xoxs-', 'hf_', 'PRIVATE KEY-----']


def secrets(root=ROOT, allowlist=None):
    """Credential patterns in tracked text files. A match is reported by kind, place and the
    sha256 of the matched string, never by its text; `secrets_allowlist` lists accepted hashes."""
    import hashlib
    entries = registry.config().get('secrets_allowlist', []) if allowlist is None else allowlist
    allow = {a.get('sha256'): a.get('note', '') for a in entries if isinstance(a, dict)}
    args = ['git', 'grep', '-I', '-n', '-z', '-F'] + [x for p in SECRET_PREFIXES for x in ('-e', p)]
    out = subprocess.run(args, cwd=root, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if out.returncode not in (0, 1):
        raise ValueError('git grep failed: ' + out.stderr.decode(errors='replace')[:300])
    compiled = {k: re.compile(v) for k, v in SECRET_PATTERNS.items()}
    findings, allowed = [], []
    for row in out.stdout.split(b'\n'):
        fields = row.split(b'\0', 2)
        if len(fields) < 3:
            continue
        path, line, text = fields[0].decode(errors='replace'), int(fields[1]), fields[2].decode(errors='replace')
        for kind, pattern in compiled.items():
            for m in pattern.finditer(text):
                digest = hashlib.sha256(m.group(0).encode()).hexdigest()
                item = {'kind': kind, 'path': path, 'line': line, 'sha256': digest}
                (allowed if digest in allow else findings).append(item)
    return {'findings': findings, 'allowlisted': len(allowed),
            'allowlisted_by_note': {allow[d]: sum(1 for a in allowed if a['sha256'] == d) for d in sorted({a['sha256'] for a in allowed})},
            'scope': 'Tracked text files (git grep -I). Matches are shown by sha256 only. Add an accepted (for example revoked) '
                     'credential to secrets_allowlist in _process/research-config.json by its sha256 and a note.'}


def index_outputs(render=False):
    """Pages of the index and catalogue generators: (outputs, errors, reading drift). The Lean
    catalogue scans every .lean file, so it is rendered but compared by `check` only with
    `--strict-fresh`; its own `lean_catalogue.py --check` compares it as well."""
    out = dict(indexes.render())
    pages, errors, drift = reading_catalogue.render()
    out.update(pages)
    if render:
        out.update(lean_catalogue.render())
    return out, ['reading catalogue: ' + e for e in errors], drift


def check_or_render(render=False, base=None, ids=None, strict_fresh=False):
    """Check (or with `render`, write) the generated views. A stale directory index or
    catalogue is reported, not failed, so parallel sessions are not blocked by pages that
    follow chapters and studies; `strict_fresh` (CI) fails on it and also compares the Lean
    catalogue, so the check fails whenever a render would change a generated page."""
    before = input_snapshot()
    records, errors = registry.load_records()
    findings, drift = registry.validate(records)
    errors += findings + registry.orphan_pages(records) + navigation.validate_goals(records) + navigation.validate_history()
    changed = changed_paths(base) if base else None
    selected = set(ids) if ids else registry.affected_ids(records, changed) if base else {r['id'] for r in records}
    errors += ['unknown result id: ' + x for x in selected - {r['id'] for r in records}]
    if errors:
        return 1, {'errors': errors, 'source_drift': drift}
    outputs = navigation.render_views(records)
    # The completion criterion K1-K7 (R39): its report is a generated view; a malformed coverage file or a
    # central name the core does not have is an error, an unmet criterion is not.
    completion_pages, completion_errors = completion.render()
    outputs.update(completion_pages)
    errors += completion_errors
    # The theory graph (RA): one graph of concepts, results, modules, texts and chapter sections, and its index.
    outputs.update(theory_graph.render(records))
    # The atlas (AA): the dynamics as a curated layer beside the records; a broken entry is an error, as a record is.
    atlas_pages, atlas_errors = atlas.render(records)
    outputs.update(atlas_pages)
    errors += atlas_errors
    # The connection map (CX): the atlas's correspondences, the graph and the shared laws on one page.
    if atlas_pages:
        outputs.update(connection_map.render(atlas_pages[atlas.DATA], outputs[theory_graph.GRAPH]))
    index_pages, index_errors, reading_drift = index_outputs(render or strict_fresh)
    stale_indexes = []
    errors += index_errors
    outputs.update(index_pages)
    stale = {d['id'] for d in drift}
    record_outputs = {str(registry.record_path(r).with_suffix('.md').relative_to(ROOT)): registry.render_record(r) for r in records if r['id'] in selected and r['id'] not in stale}
    record_outputs[str((registry.OUT / 'RESULT-REGISTER.md').relative_to(ROOT))] = registry.render_index(records)
    record_outputs.update({str(p.relative_to(ROOT)): body for p, body in registry.redirect_pages(records).items()})
    # The index pages link one another; a check resolves those links against the pages render would write.
    planned = set(outputs) | set(record_outputs) if render else set(index_pages)
    errors += check_links({**outputs, **record_outputs}, planned)
    if render and not errors:
        initial = dict(indexes.adopted())
        for path in record_outputs:
            p = ROOT / path
            if p.is_file() and '<!-- Generated by ' in p.read_text():
                initial[path] = registry.digest(p)
        if not unchanged_inputs(before):
            errors.append('Research inputs changed during validation; no views written. Retry with current records.')
        else:
            errors += navigation.write_views({**outputs, **record_outputs}, initial)
            # The Lean catalogue reads the links of the documentation, generated pages among
            # them (README links Lean files), as they were before this write; a second pass
            # over it makes one render a fixed point, so a strict check passes after it.
            if not errors:
                settled = {path: body for path, body in lean_catalogue.render().items()
                           if not (ROOT / path).is_file() or (ROOT / path).read_text() != body}
                if settled:
                    errors += navigation.write_views(settled, initial)
    elif not render:
        for path, body in {**outputs, **record_outputs}.items():
            if not (ROOT / path).exists() or (ROOT / path).read_text() != body:
                if path in index_pages:
                    stale_indexes.append(path)  # freshness of a directory index or catalogue, not an error
                else:
                    errors.append('generated view differs; reconcile and run make research-render: ' + path)
        if strict_fresh:
            errors += ['generated index differs from what render would write (--strict-fresh); run make research-render: ' + path
                       for path in stale_indexes]
    # Readability: schema-2 errors are already among the validation errors; the rest warn.
    # The growth ratchet applies to records changed since the base commit.
    warnings = [f for r in records for f in style.lint(r) if f['severity'] == 'warning']
    grown = ratchet(records, base, changed) if base and not render else []
    errors += [f'{f["id"]}: {f["field"]}: {f["rule"]}: {f["detail"]}' for f in grown if f['severity'] == 'error']
    warnings += [f for f in grown if f['severity'] == 'warning']
    if not unchanged_inputs(before):
        errors.append('Research inputs changed during this operation; rerun against the latest source versions.')
    scoped = [d for d in drift if d['id'] in selected]
    result = {'records': len(records), 'selected_records': sorted(selected), 'errors': errors, 'source_drift': scoped, 'unrelated_source_drift': [d for d in drift if d['id'] not in selected],
              'style_warnings': {**style.summary(warnings), 'list': 'python3 -B tools/research/research.py lint [--ids ...]'},
              # Reviewed Markdown sources changed only outside what each record cites: the
              # reviewed lines are intact, so the record needs no new review.
              'changed_outside_cited': len([g for g in registry.GROWN if g['id'] in selected]),
              # Reading-catalogue entries whose source changed after the reading (shown on the
              # pages; reread before refreshing source_sha256).
              'reading_drift': len(reading_drift),
              # Directory indexes and catalogues that differ from what render would write; they
              # follow chapters, studies and sources and are refreshed by make research-render.
              'stale_indexes': stale_indexes,
              # MV: how far the computed view of shared laws still matches the records and the core receipt.
              'shared_laws': registry.shared_laws_status(records)}
    if ids or base:
        result['selected_style_warnings'] = [f for f in warnings if f['id'] in selected]
    result['scope'] = 'Metadata, navigation, preserved history and proof-receipt bindings only. No new Lean or empirical validation.'
    return (1 if errors else 2 if scoped else 0), result


def compact_history(ids=None, apply=False):
    """E3 (R35): condense the bookkeeping notes of record histories; see tools/research/history_notes.py."""
    from datetime import date
    settings = json.loads((ROOT / '_process/research-config.json').read_text())
    records = sorted(p for d in settings['record_directories'] for p in (ROOT / d).glob('*.json'))
    if ids:
        wanted = set(ids)
        records = [p for p in records if p.stem in wanted]
        missing = wanted - {p.stem for p in records}
        if missing:
            raise ValueError('no record with id ' + ', '.join(sorted(missing)))
    if apply:
        dirty = subprocess.run(['git', '-C', str(ROOT), 'status', '--porcelain', '--', *settings['record_directories']],
                               capture_output=True, text=True, check=True).stdout
        if dirty.strip():
            raise ValueError('Refusing to compact with uncommitted record changes; commit them first')
    receipt = ROOT / '_process/architecture/compactions' / f'{date.today().isoformat()}.json'
    result = history_notes.compact(ROOT, records, registry.snapshot_record, apply=apply, receipt=receipt)
    if apply:
        result['receipt'] = str(receipt.relative_to(ROOT))
    else:
        result['records'] = [{k: r[k] for k in ('id', 'notes_before', 'condensed', 'kept')} for r in result['records']]
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest='command', required=True)
    for cmd in ('check', 'render'):
        p = sub.add_parser(cmd)
        p.add_argument('--changed-since')
        p.add_argument('--ids', nargs='+')
    sub.choices['check'].add_argument('--strict-fresh', action='store_true',
                                      help='fail when a render would change any generated page, directory indexes and the Lean catalogue included (CI)')
    p = sub.add_parser('find')
    p.add_argument('query', nargs='?', default=os.environ.get('QUERY', ''))
    p.add_argument('--archives', action='store_true')
    p.add_argument('--limit', type=int, default=30)
    sub.add_parser('imports')
    p = sub.add_parser('lint', help='List readability findings (form only); with --changed-since, also the growth ratchet')
    p.add_argument('--changed-since')
    p.add_argument('--ids', nargs='+')
    p = sub.add_parser('snapshot', help='Before migrating a record, store its exact bytes and print the text_versions entry')
    p.add_argument('id')
    p = sub.add_parser('compact-history', help='Condense bookkeeping history notes of records (dry run unless --apply); snapshot each record first')
    p.add_argument('--apply', action='store_true')
    p.add_argument('--ids', nargs='+')
    p = sub.add_parser('rename-id', help='Rename record ids (dry run unless --apply); keep former_ids, rewrite live references, write a receipt')
    p.add_argument('--plan', required=True, help='TSV: old_id<TAB>new_id<TAB>reason')
    p.add_argument('--apply', action='store_true')
    p.add_argument('--batch')
    p = sub.add_parser('move', help='Move files to new paths (dry run unless --apply); rewrite live references; write receipts')
    what = p.add_mutually_exclusive_group(required=True)
    what.add_argument('--plan', help='TSV: old_path<TAB>new_path<TAB>reason')
    what.add_argument('--check', metavar='RECEIPT', help='verify an applied move receipt: new paths hold the recorded sha256, no live reference names an old path')
    p.add_argument('--apply', action='store_true')
    p.add_argument('--batch', help='receipt name (default moves-<date>-<plan name>)')
    p.add_argument('--summary', action='store_true', help='print the summary and conflicts only')
    p.add_argument('--keep-references', action='store_true',
                   help='move without rewriting references: the vacated paths receive new files afterwards (H1-replace, H6-replace)')
    p = sub.add_parser('evidence', add_help=False, help='Content-addressed store for checker run folders: plan, pack, restore, verify (tools/research/evidence_store.py)')
    p.add_argument('evidence_args', nargs=argparse.REMAINDER)
    p = sub.add_parser('links', help='Check relative links and #anchors in live Markdown files')
    p.add_argument('--paths', nargs='+', help='limit to these files or directories')
    p.add_argument('--live-only', action='store_true', help='leave generated pages out')
    p.add_argument('--limit', type=int, default=200, help='broken links listed (counts are always complete)')
    sub.add_parser('secrets', help='Scan tracked files for credential patterns (hashes only)')
    p = sub.add_parser('preserve-view', help='After reading and reconciling added prose, preserve it before rendering')
    p.add_argument('path')
    p.add_argument('--note', required=True, help='Where the reviewed additions were integrated, with their scope')
    if sys.argv[1:2] == ['evidence']:
        # The evidence store has its own subcommands and help; pass its arguments through.
        from tools.research import evidence_store
        return evidence_store.main(sys.argv[2:])
    args = parser.parse_args()
    if args.command == 'find':
        if not args.query.strip():
            parser.error('supply a query or use make research-find QUERY=topic')
        result, code = search(args.query, args.archives, args.limit), 0
    elif args.command == 'move' and args.check:
        result = moves.check_receipt(args.check)
        code = 1 if result['errors'] else 0
        if args.summary:
            result = {k: (v if not isinstance(v, list) or len(v) <= 20 else v[:20] + [f'... and {len(v) - 20} more'])
                      for k, v in result.items()}
    elif args.command == 'move':
        result = moves.run(args.plan, apply=args.apply, batch=args.batch, full=not args.summary,
                           keep_references=args.keep_references)
        code = 1 if result.get('conflicts') or result.get('verification_errors') else 0
    elif args.command == 'links':
        result = moves.check_links(ROOT, args.paths, include_generated=not args.live_only)
        code = 1 if result['broken'] else 0
        if args.limit >= 0 and len(result['list']) > args.limit:
            result['list_truncated_to'] = args.limit
            result['list'] = result['list'][:args.limit]
    elif args.command == 'secrets':
        result = secrets()
        code = 1 if result['findings'] else 0
    elif args.command == 'imports':
        result, code = import_graph(), 0
    elif args.command == 'lint':
        result = lint(args.ids, args.changed_since)
        code = 1 if result['errors'] or result['summary']['by_severity'].get('error') else 0
    elif args.command == 'rename-id':
        result = rename_ids.run(args.plan, apply=args.apply, batch=args.batch)
        code = 1 if result.get('errors') or result.get('conflicts') else 0
    elif args.command == 'compact-history':
        result, code = compact_history(args.ids, args.apply), 0
    elif args.command == 'snapshot':
        result, code = {'text_versions_entry': registry.snapshot_record(args.id),
                        'next': 'Add this entry to the record\'s text_versions, map every earlier sentence, and add a history note.'}, 0
    elif args.command == 'preserve-view':
        with render_lock():
            result, code = navigation.preserve_view(args.path, args.note), 0
    elif args.command == 'render':
        with render_lock():
            code, result = check_or_render(True, args.changed_since, args.ids)
    else:
        code, result = check_or_render(False, args.changed_since, args.ids, strict_fresh=args.strict_fresh)
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return code


if __name__ == '__main__':
    try:
        raise SystemExit(main())
    except (ValueError, OSError) as exc:
        print(json.dumps({'errors': [str(exc)]}))
        raise SystemExit(1)
