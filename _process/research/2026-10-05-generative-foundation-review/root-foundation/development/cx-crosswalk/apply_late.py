#!/usr/bin/env python3
"""The last layer of the crosswalk's reads: the second critic's fixes, then the live text's own corrections.

usage: python3 -B apply_late.py [--dry-run]

Reads reads/<item>.5-compare.json, applies every `fix` in reads/critic2-share-*.json (the second critic read both sides of
each), then replaces in entries what the live account no longer says since this crosswalk's corrections (LIVE_NOW below),
and writes reads/<item>.6-final.json, each with a `changes` list naming why. Stops on a fix to an unknown entry or field,
on a replacement that matches nothing, and writes nothing then. Validation is check_entries.py's.
"""
import argparse
import glob
import json
import sys
from pathlib import Path

READS = Path(__file__).resolve().parent / 'reads'
SETTABLE = {'carried', 'relation', 'agreement_of', 'same_as', 'reading', 'source_adds', 'account_adds', 'absence', 'targets'}
CD5 = ('One kind of institution has one minimal model on the root [AI reading], a rule rebuilt from the members it limits '
       '(05 §12), and no actual institution is shown to meet its hypotheses')
# COLLECTIVE-DIRECTION §5 said "No institution is modelled on the spine" until this crosswalk's correction; entries that
# quoted it now quote what it says. Each pair: an exact string in the entry's JSON text, and what replaces it.
LIVE_NOW = {
    'cx-asc-selection-on-cognition': [("'no institution is modelled on the spine'", 'no actual institution is shown to meet the hypotheses of the one minimal model of an institution on the root')],
    'cx-asc-training-ground': [("'No institution is modelled on the spine; no field test", f"'{CD5}; no field test")],
    'cx-asc-four-layer-loop': [("'No institution is modelled on the spine; no field test", f"'{CD5}; no field test")],
    'cx-fork-two-fates': [('No institution is modelled on the spine; no field test', f'{CD5}; no field test')],
    'cx-zhishan-present-diagnosis': [('no institution is modelled on the spine,', 'no actual institution is shown to meet the hypotheses of the one minimal model of an institution,'),
                                     ('No institution is modelled on the spine; no field test', f'{CD5}; no field test')],
}


def main(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument('--dry-run', action='store_true')
    args = parser.parse_args(argv)
    files = {p.name.split('.')[0]: json.loads(p.read_text(encoding='utf-8')) for p in sorted(READS.glob('*.5-compare.json'))}
    entries = {e['id']: e for data in files.values() for e in data['entries']}
    why, problems = {}, []
    for path in sorted(READS.glob('critic2-share-*.json')):
        for v in json.loads(path.read_text(encoding='utf-8'))['verdicts']:
            if v['verdict'] == 'holds' or not v.get('fix'):
                continue
            if v['id'] not in entries:
                problems.append(f'{path.name}: no entry {v["id"]}')
                continue
            for field, value in v['fix'].items():
                if field not in SETTABLE:
                    problems.append(f'{path.name}: {v["id"]}: {field} cannot be set')
                    continue
                entries[v['id']][field] = value
            why.setdefault(v['id'], []).append(f'second critic ({v["verdict"]}): {v["why"]}')
    for id_, pairs in LIVE_NOW.items():
        text = json.dumps(entries[id_], ensure_ascii=False)
        for old, new in pairs:
            if old not in text:
                problems.append(f'{id_}: {old[:60]!r} not found')
                continue
            text = text.replace(old, json.dumps(new, ensure_ascii=False)[1:-1])
        entries[id_].clear()
        entries[id_].update(json.loads(text))
        why.setdefault(id_, []).append('COLLECTIVE-DIRECTION §5 corrected by this crosswalk: the entry quotes what it says now')
    stale = [i for i, e in entries.items() if 'institution is modelled' in json.dumps(e, ensure_ascii=False)]
    problems += [f'{i}: still quotes the old CD §5 sentence' for i in stale]
    if problems:
        print('\n'.join(problems))
        return 1
    for item, data in files.items():
        data['changes'] = [{'id': e['id'], 'what': 'changed', 'why': ' / '.join(why[e['id']])} for e in data['entries'] if e['id'] in why]
        if not args.dry_run:
            (READS / f'{item}.6-final.json').write_text(json.dumps(data, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
    print(f'{len(why)} entries changed in {len(files)} items')
    return 0


if __name__ == '__main__':
    sys.exit(main())
