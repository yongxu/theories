#!/usr/bin/env python3
"""Build one listing of places from the table of 20 November and the readers' structured returns.

AI-written (Claude Fable, 21 November 2026). Generated output: PLACES.md and places.json are made by
this script and never edited by hand. Whoever lands a place-by-place read adds its returns under
returns/ and an entry to READS below, and runs this script in that landing.

It decides nothing and writes no sentence of its own about any place: every field is one reader's
return, word for word, with which read and which reader gave it, and with the path of that read's
note, where a checker's mends are. A place is keyed by the first Lean file name in the reader's own
name for it, or the last part of a path; names with neither stay as their own rows. Nothing in the
output adds up per place.

Usage (from this folder): python3 -B build_places.py
"""
import json, re, subprocess
from collections import OrderedDict

TABLE = '../two-ways-table-2026-11-20/two-ways-table.json'
CAUTION = "a reader's return, unchecked; what the note mended is in the note"
READS = [
    ('kept', '20 November, things kept by goings-on', 'returns/kept.json', '../read-kept-by-goings-on-2026-11-20/',
     ['kept_by', 'source_and_cost', 'loop', 'going_on_laws', 'exact', 'handed_in']),
    ('future', '21 November, a future opening or closing', 'returns/future.json', '../read-a-future-2026-11-21/',
     ['what_stands_for_after', 'opening_laws', 'closing_laws', 'forms_change', 'from_where', 'way_related_to_widening']),
    ('register', '21 November, how a registering comes to be', 'returns/register.json', '../read-registering-2026-11-21/',
     ['what_registers_what', 'changes_by', 'comes_to_register', 'cost_and_keeping', 'lost', 'tied_to_what_it_rests_on']),
]
HEAD = {'kept_by': 'what is rested on, and whose doing', 'source_and_cost': 'from where, at what cost', 'loop': 'is there a loop',
        'going_on_laws': 'general laws concluding going on', 'exact': 'exact two-sided law', 'handed_in': 'what is handed in',
        'what_stands_for_after': 'what stands for what can go on after', 'opening_laws': 'laws concluding an opening',
        'closing_laws': 'laws concluding a closing', 'forms_change': 'forms changing while it continues', 'from_where': 'from where an opening comes',
        'way_related_to_widening': 'a way related to widening', 'what_registers_what': 'what registers what', 'changes_by': 'what changes it',
        'comes_to_register': 'laws where something comes to be registered', 'cost_and_keeping': 'cost and keeping', 'lost': 'a registering lost',
        'tied_to_what_it_rests_on': 'tied to what it rests on'}


def key(name):
    m = re.search(r'([A-Za-z][A-Za-z0-9_]*)\.lean', name)
    if m:
        return m.group(1)
    m = re.match(r'\s*`?([A-Za-z][A-Za-z0-9/_-]+)', name)
    if not m or m.group(1) in ('The', 'A', 'In'):
        return name.strip()[:60]
    tok = m.group(1)
    return tok if tok.startswith('conditional/') else tok.split('/')[-1]


def lean_files():
    """Tracked Lean files by base name, leaving out copies (anything under _process/, and folders of runs, checks, sources and verification)."""
    root = subprocess.run(['git', 'rev-parse', '--show-toplevel'], capture_output=True, text=True).stdout.strip()
    out = {}
    for f in subprocess.run(['git', '-C', root, 'ls-files', '*.lean'], capture_output=True, text=True).stdout.split('\n'):
        if not f or f.startswith('_process/') or any(x in f for x in ('/sources/', '-runs/', '-checks/', 'verification/')):
            continue
        out.setdefault(f.rsplit('/', 1)[-1][:-5], []).append(f)
    return out


def joins():
    """For each tracked file, the ids of the result records whose references name it; and for each record id, the ids of the
    atlas's dynamics that name it. Computed from the records and the atlas's entries as they stand; nothing is read in the Lean.
    Added on 21 November by the session that ran the survey of the repository. A record names a file as a source of its
    statement or proof; a dynamic names records. Neither says that the file states the dynamic, and nothing here is a link."""
    import glob, os
    root = subprocess.run(['git', 'rev-parse', '--show-toplevel'], capture_output=True, text=True).stdout.strip()
    by_file, by_record = {}, {}
    for path in sorted(glob.glob(os.path.join(root, 'theories/becoming/results/records/*.json'))):
        record = json.load(open(path))
        for ref in record.get('references', []):
            if ref.get('path'):
                by_file.setdefault(ref['path'], set()).add(record['id'])
    for dynamic in json.load(open(os.path.join(root, 'theories/becoming/results/atlas/entries/dynamics.json'))):
        for rid in dynamic.get('records', []):
            by_record.setdefault(rid, set()).add(dynamic['id'])
    return by_file, by_record


def build():
    places = OrderedDict()
    table = json.load(open(TABLE))
    for g in table['groups']:
        for r in g['rows']:
            p = places.setdefault(key(r['row']), {'key': key(r['row']), 'table': [], 'reads': []})
            p['table'].append({'row': r['row'], 'group': g['group'],
                               'letters': ''.join(r['cells'][c]['v'] if len(r['cells'][c]['v']) == 1 else '?' for c in 'abcdefgh'),
                               'standing': r['standing'].get('A') or r['standing'].get('B'), 'told_in': r['told_in'].get('A') or r['told_in'].get('B')})
    for tag, title, path, folder, fields in READS:
        for item in json.load(open(path))['returns']:
            reader = item['reader'].replace('read:', '')
            for pl in item['return'].get('places', []):
                p = places.setdefault(key(pl['place']), {'key': key(pl['place']), 'table': [], 'reads': []})
                p['reads'].append({'read': tag, 'title': title, 'reader': reader, 'place': pl['place'], 'note': folder + 'NOTE.md',
                                   'report': folder + 'read-' + reader + '.md.txt', 'caution': CAUTION, 'fields': {f: pl.get(f, '') for f in fields}})
    files = lean_files()
    for p in places.values():
        p['files'] = sorted(files.get(p['key'], []))
        p['kind'] = 'one Lean file' if len(p['files']) == 1 else ('several Lean files of this name' if p['files'] else 'no Lean file of this name')
    by_file, by_record = joins()
    for p in places.values():
        p['records'] = sorted(set().union(*[by_file.get(f, set()) for f in p['files']])) if p['files'] else []
        p['dynamics'] = sorted(set().union(*[by_record.get(r, set()) for r in p['records']])) if p['records'] else []
    return list(places.values())


if __name__ == '__main__':
    places = build()
    json.dump({'made_by': 'build_places.py; never edited by hand', 'caution': CAUTION,
               'reads': [{'tag': t, 'title': ti, 'note': fo + 'NOTE.md', 'fields': f} for t, ti, _, fo, f in READS], 'places': places},
              open('places.json', 'w'), indent=1, ensure_ascii=False)
    L = ['# Places: what one table and three reads say of each, in the readers\' words', '',
         '*Made by `build_places.py` beside it; never edited by hand. AI-written (Claude Fable for the script). Every field below is ' + CAUTION + '. It proves nothing, ranks nothing and holds no link. A place with no read under it was not in that read; that says nothing of the Lean. [The note](NOTE.md) says what this is and is not.*', '',
         'The table\'s letters (20 November, [its note](../two-ways-table-2026-11-20/NOTE.md)): **a** multiplies; **b** a level that can run down; **c** gives at a cost; **d** the source is said; **e** what comes back; **f** a rule set again from a share; **g** both outcomes, boundary exact; **h** no return, or a turn. Y yes, P in part, N no.', '',
         'A place is keyed by a Lean file\'s base name. Where several tracked files carry that name, or none does (a namespace inside a file, a program, a scratch module, a folder, a page), the row says so, since two places can then share a row; the readers\' own names for the place are kept under it.', '',
         '| place | file | in the table | read in |', '|---|---|---|---|']
    for p in sorted(places, key=lambda p: p['key'].lower()):
        where = ('`%s`' % p['files'][0]) if len(p['files']) == 1 else (p['kind'] + (': ' + '; '.join('`%s`' % f for f in p['files']) if p['files'] else ''))
        L.append('| %s | %s | %s | %s |' % (p['key'], where, ' / '.join(t['letters'] for t in p['table']), ', '.join(sorted({r['read'] for r in p['reads']}))))
    L += ['', 'The reads: ' + '; '.join('**%s** %s ([note](%sNOTE.md))' % (t, ti, fo) for t, ti, _, fo, _f in READS) + '.', '',
          '## Each place, in the readers\' words', '']
    for p in sorted(places, key=lambda p: p['key'].lower()):
        if not p['reads']:
            continue
        L.append('### %s (readers\' returns of %s; not checked)' % (p['key'], ', '.join(sorted({r['title'].split(',')[0] for r in p['reads']}))))
        for t in p['table']:
            L.append('- *table:* %s, letters `%s`, standing %s%s' % (t['row'], t['letters'], t['standing'], (', told in ' + t['told_in']) if t['told_in'] else ''))
        if p['records']:
            L.append('- *result records that name this place\'s file as a source* (computed; not a link): ' + ', '.join('`%s`' % r for r in p['records']))
        if p['dynamics']:
            L.append('- *dynamics in the atlas that name one of those records* (computed; not a link): ' + ', '.join('`%s`' % d for d in p['dynamics']))
        for r in p['reads']:
            L.append('- *read of %s, reader %s, as "%s"* (%s: [note](%s), [report](%s)):' % (r['title'], r['reader'], r['place'].replace('\n', ' '), CAUTION, r['note'], r['report']))
            for f, v in r['fields'].items():
                L.append('  - %s: %s' % (HEAD[f], (v or '').replace('\n', ' ')))
        L.append('')
    open('PLACES.md', 'w').write('\n'.join(L) + '\n')
    print(len(places), sum(1 for p in places if p['table']), sum(1 for p in places if p['reads']))
