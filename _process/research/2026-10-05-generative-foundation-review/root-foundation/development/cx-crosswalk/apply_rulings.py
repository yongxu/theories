#!/usr/bin/env python3
"""Apply the comparison's rulings to the repaired reads, and write each item's final file.

usage: python3 -B apply_rulings.py [--dry-run]

Reads reads/<item>.4-repair.json and every reads/compare-*.json, and writes reads/<item>.5-compare.json. Two rulings that
set one entry's field to different values are a conflict: nothing is written until reads/compare-resolved.json settles it,
as {"id", "field", "value", "why"}, a person or a coordinator having read both. `same_as` is then made symmetric and
transitive, since a set of entries stating one claim is one set. Each file's `changes` lists what the comparison changed,
with the reason and the cluster it came from. Validation is check_entries.py's.
"""
import argparse
import json
import sys
from pathlib import Path

READS = Path(__file__).resolve().parent / 'reads'
SETTABLE = {'carried', 'relation', 'agreement_of', 'same_as', 'reading', 'source_adds', 'account_adds', 'absence', 'targets'}


def key_of(target):
    return target.get('record') or target.get('anchor')


def main(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument('--dry-run', action='store_true')
    args = parser.parse_args(argv)
    files = {p.name.split('.')[0]: json.loads(p.read_text(encoding='utf-8')) for p in sorted(READS.glob('*.4-repair.json'))}
    entries = {e['id']: (item, e) for item, data in files.items() for e in data['entries']}
    resolved_file = READS / 'compare-resolved.json'
    resolved = {(r['id'], r['field']): r for r in json.loads(resolved_file.read_text(encoding='utf-8'))} if resolved_file.is_file() else {}
    wanted, roles, reasons, problems = {}, {}, {}, []
    for path in sorted(READS.glob('compare-*.json')):
        if path == resolved_file:
            continue
        cluster = path.stem.removeprefix('compare-')
        for r in json.loads(path.read_text(encoding='utf-8')).get('rulings', []):
            if r['id'] not in entries:
                problems.append(f'{cluster}: no entry {r["id"]}')
                continue
            reasons.setdefault(r['id'], []).append(f'{cluster}: {r.get("why", "")}')
            for field, value in (r.get('set') or {}).items():
                if field not in SETTABLE:
                    problems.append(f'{cluster}: {r["id"]}: {field} cannot be set')
                    continue
                wanted.setdefault((r['id'], field), []).append((cluster, value, r.get('why', '')))
            for change in r.get('roles') or []:
                for field in ('role', 'part'):
                    if field in change:
                        roles.setdefault((r['id'], change['target'], field), []).append((cluster, change[field], r.get('why', '')))
    settled = {}
    for (id_, field), rulings in wanted.items():
        values = {json.dumps(v, sort_keys=True, ensure_ascii=False) for _, v, _ in rulings}
        if (id_, field) in resolved:
            settled[(id_, field)] = resolved[(id_, field)]['value']
        elif len(values) > 1:
            problems.append(f'conflict: {id_}.{field}: ' + ' | '.join(f'{c}: {json.dumps(v, ensure_ascii=False)[:120]} ({w[:160]})' for c, v, w in rulings))
        else:
            settled[(id_, field)] = rulings[0][1]
    settled_roles = {}
    for key, rulings in roles.items():
        values = {v for _, v, _ in rulings}
        if len(values) > 1:
            problems.append(f'conflict: {key[0]}: target {key[1]}: {key[2]}: ' + ' | '.join(f'{c}: {v} ({w[:160]})' for c, v, w in rulings))
        else:
            settled_roles[key] = rulings[0][1]
    for (id_, target, field) in settled_roles:
        if not any(key_of(t) == target for t in entries[id_][1]['targets']):
            problems.append(f'{id_}: no target {target} to set {field} on')
    if problems:
        print('\n'.join(problems))
        print(f'{len(problems)} problems; nothing written')
        return 1
    changed = set()
    for (id_, field), value in settled.items():
        entries[id_][1][field] = value
        changed.add(id_)
    for (id_, target, field), value in settled_roles.items():
        for t in entries[id_][1]['targets']:
            if key_of(t) == target:
                t[field] = value
        changed.add(id_)
    # A set of entries stating one claim is one set.
    parent = {i: i for i in entries}

    def find(i):
        while parent[i] != i:
            parent[i] = parent[parent[i]]
            i = parent[i]
        return i

    for id_, (_, e) in entries.items():
        for other in e.get('same_as') or []:
            if other in entries:
                parent[find(id_)] = find(other)
    sets = {}
    for i in entries:
        sets.setdefault(find(i), []).append(i)
    for members in sets.values():
        for i in members:
            e = entries[i][1]
            e['same_as'] = sorted(set(members) - {i}) or None
    for item, data in files.items():
        data['changes'] = [{'id': e['id'], 'what': 'changed', 'why': ' / '.join(reasons.get(e['id'], ['same_as made symmetric']))}
                           for e in data['entries'] if e['id'] in changed]
        if not args.dry_run:
            (READS / f'{item}.5-compare.json').write_text(json.dumps(data, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
    print(f'{len(changed)} entries changed by {sum(len(v) for v in wanted.values())} field rulings and {len(roles)} target rulings, in {len(files)} items')
    return 0


if __name__ == '__main__':
    sys.exit(main())
