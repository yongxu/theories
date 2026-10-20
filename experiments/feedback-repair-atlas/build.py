#!/usr/bin/env python3
"""Build the offline atlas page from the checked model (Python standard library only)."""
import argparse
import hashlib
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def build():
    record = json.loads((HERE / 'model/atlas-verification.json').read_text())
    if record['status'] != 'passed' or record['axiom_dependencies']:
        raise ValueError('The model is not verified: model/atlas-verification.json')
    for path, expected in record['own_sha256'].items():
        if digest(ROOT / path) != expected:
            raise ValueError('Changed since verification; rerun model/verify_atlas.py: ' + path)
    components = json.loads((HERE / 'components.json').read_text())['components']
    for component in components:
        if 'code' in component:
            # A core excerpt is a snapshot at the commit the model was checked against.
            if component['commit'] != record['core']['checked_against_commit']:
                raise ValueError('Core excerpt is from another commit: ' + component['id'])
            continue
        if component['path'] not in record['own_sha256']:
            raise ValueError('Excerpt from an unverified file: ' + component['id'])
        lines = (ROOT / component['path']).read_text().splitlines()
        if not 1 <= component['line'] <= component['end'] <= len(lines):
            raise ValueError('Invalid source range: ' + component['id'])
        component['code'] = '\n'.join(lines[component['line'] - 1:component['end']])
    verification = {k: record[k] for k in ['checked_at_utc', 'lean_version', 'theorems', 'declarations']}
    verification['core_commit'] = record['core']['checked_against_commit']
    data = json.dumps(dict(components=components, verification=verification),
                      ensure_ascii=False).replace('</', '<\\/')
    fragment = (HERE / 'src/page.fragment.html').read_text()
    if fragment.count('__ATLAS_DATA__') != 1:
        raise ValueError('Expected exactly one data placeholder')
    fragment = fragment.replace('__ATLAS_DATA__', data)
    # Inline the dynamics: the delivered page needs no modules, network or CDN.
    fragment = '<script>\n' + (HERE / 'src/learning.js').read_text() + '\n</script>\n' + fragment
    shell = (HERE / 'src/shell.html').read_text()
    if shell.count('<!--__ATLAS_FRAGMENT__-->') != 1:
        raise ValueError('Expected exactly one fragment placeholder')
    return shell.replace('<!--__ATLAS_FRAGMENT__-->', fragment)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true', help='Fail if index.html needs rebuilding')
    args = parser.parse_args()
    result = build()
    output = HERE / 'index.html'
    if args.check:
        if not output.is_file() or output.read_text() != result:
            raise SystemExit('index.html is stale; run python3 -B build.py')
        print('Atlas is reproducible; the model and its excerpts match the verification record.')
    else:
        output.write_text(result)
        print('Built', output.relative_to(ROOT), '(' + str(output.stat().st_size) + ' bytes)')
