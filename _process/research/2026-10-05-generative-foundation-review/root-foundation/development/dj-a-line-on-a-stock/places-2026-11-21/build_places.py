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

It also lists, read off the scratch modules filed as text in this row's study, each check of the form
`theorem X : @A = @B := rfl`: that two statements are the same up to unfolding. For each it finds, by
search, the file that declares each side, reads the build log filed beside the module, and searches
the package for a theorem of the scratch statement's name. It runs no Lean (function `same_statements`).

Usage (from this folder): python3 -B build_places.py
"""
import json, os, re, subprocess
from collections import OrderedDict

TABLE = '../two-ways-table-2026-11-20/two-ways-table.json'
CAUTION = "a reader's return, unchecked; what the note mended is in the note"
STUDY = '..'  # this row's study folder; scratch modules filed as text are the tracked files Scratch*.lean.txt under it
PACKAGE = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/'
SAME = ('a check filed as scratch text, outside the package, written to close by rfl: where Lean accepted it (see the filed log on this line), '
        'the two statements are the same up to unfolding, that is, definitionally equal. The script read the text and the filed log and ran no Lean; '
        'nothing here checks that the text filed, or the file named for the other side, is the text that was built')
UP_TO = ('unfolding of definitions and the other reductions of Lean (definitional equality as the elaborator decides it), '
         'binder names and which arguments are implicit ignored')
READS = [
    ('kept', '20 November, things kept by goings-on', 'returns/kept.json', '../read-kept-by-goings-on-2026-11-20/',
     ['kept_by', 'source_and_cost', 'loop', 'going_on_laws', 'exact', 'handed_in']),
    ('future', '21 November, a future opening or closing', 'returns/future.json', '../read-a-future-2026-11-21/',
     ['what_stands_for_after', 'opening_laws', 'closing_laws', 'forms_change', 'from_where', 'way_related_to_widening']),
    ('register', '21 November, how a registering comes to be', 'returns/register.json', '../read-registering-2026-11-21/',
     ['what_registers_what', 'changes_by', 'comes_to_register', 'cost_and_keeping', 'lost', 'tied_to_what_it_rests_on']),
    ('choice', '21 November, a choice made from a reading', 'returns/choice.json', '../read-a-choice-from-a-reading-2026-11-21/',
     ['what_is_read_and_what_chooses', 'exact_law', 'within_one_reading', 'two_readings', 'time', 'the_lock']),
]
HEAD = {'kept_by': 'what is rested on, and whose doing', 'source_and_cost': 'from where, at what cost', 'loop': 'is there a loop',
        'going_on_laws': 'general laws concluding going on', 'exact': 'exact two-sided law', 'handed_in': 'what is handed in',
        'what_stands_for_after': 'what stands for what can go on after', 'opening_laws': 'laws concluding an opening',
        'closing_laws': 'laws concluding a closing', 'forms_change': 'forms changing while it continues', 'from_where': 'from where an opening comes',
        'way_related_to_widening': 'a way related to widening', 'what_registers_what': 'what registers what', 'changes_by': 'what changes it',
        'comes_to_register': 'laws where something comes to be registered', 'cost_and_keeping': 'cost and keeping', 'lost': 'a registering lost',
        'tied_to_what_it_rests_on': 'tied to what it rests on', 'what_is_read_and_what_chooses': 'what is read, and what chooses from it',
        'exact_law': 'the exact law', 'within_one_reading': 'within one reading', 'two_readings': 'two readings of one process',
        'time': 'when a reading tells apart, and what can still be kept', 'the_lock': 'the lock as a case'}


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


NS = re.compile(r'^\s*(namespace|section|mutual|end)\b[ \t]*([\w.«»]*)\s*$')
TH = re.compile(r"^\s*(?:@\[[^\]]*\]\s*)*(?:(?:private|protected|noncomputable)\s+)*(?:theorem|lemma)\s+([\w.«»']+)")
CHECK = re.compile(r"^\s*theorem\s+([\w']+)\s*:\s*@([\w.«»']+?)(\.\{[\w, ]+\})?\s*=\s*@([\w.«»']+?)(\.\{[\w, ]+\})?\s*:=\s*rfl[ \t]*$", re.M)


def uncommented(text):
    """The text with block comments (nested ones too) and line comments blanked, line breaks kept, so that line numbers stand."""
    out, depth, i, n = [], 0, 0, len(text)
    while i < n:
        two = text[i:i + 2]
        if two == '/-':
            depth += 1; i += 2
        elif two == '-/' and depth:
            depth -= 1; i += 2
        elif depth:
            out.append('\n' if text[i] == '\n' else ''); i += 1
        elif two == '--':
            while i < n and text[i] != '\n':
                i += 1
        else:
            out.append(text[i]); i += 1
    return ''.join(out)


def declared(text):
    """The theorems a file declares, each with its full name: the namespaces open at its line, then its own name.
    Read off the lines `namespace`, `section`, `mutual` and `end` with comments blanked; sections add nothing to a name.
    This is a reading of lines, not Lean's elaborator. Not read: a comment mark inside a string; `end A.B` closing two
    namespaces opened one by one; `noncomputable section`; a statement declared as a `def` or an `abbrev`."""
    stack, out = [], []
    for i, line in enumerate(uncommented(text).split('\n'), 1):
        m = NS.match(line)
        if m:
            kind, name = m.groups()
            if kind != 'end':
                stack.append((kind, name))
            elif stack and stack[-1][1] == name:
                stack.pop()
            continue
        m = TH.match(line)
        if m:
            ns = '.'.join(n for k, n in stack if k == 'namespace' and n)
            own = m.group(1)
            out.append({'name': own, 'full': own[len('_root_.'):] if own.startswith('_root_.') else (ns + '.' if ns else '') + own, 'namespace': ns, 'line': i})
    return out


def same_statements():
    """Checks `theorem X : @A = @B := rfl` in the scratch modules filed as text under this row's study.

    Each side's file is found by search, not typed: first the check's own file, trying the namespaces enclosing the check
    from the innermost out (`open` lines, imports and the order of declarations are not read: a reading of lines, not
    Lean's resolution of names); then every tracked Lean file with copies left out, and every tracked file named
    Scratch*.lean.txt in this study, for a theorem whose full name is the name written or ends with it at a dot. Where one
    file fits, that is the side's file; where none or more than one fits, the side is written as not resolved, with the
    files that fit. The build log read is the one filed beside the module that holds the check. The package is searched
    on each run for a theorem with the bare name of the left side; a find whose full name is the right side's is marked
    as the check's other side."""
    root = subprocess.run(['git', 'rev-parse', '--show-toplevel'], capture_output=True, text=True).stdout.strip()
    here = os.path.relpath(os.getcwd(), root)
    study = os.path.normpath(os.path.join(here, STUDY))
    scratch = sorted(f for f in subprocess.run(['git', '-C', root, 'ls-files', study], capture_output=True, text=True).stdout.split('\n')
                     if re.search(r'/Scratch[^/]*\.lean\.txt$', f))
    tracked = sorted(f for fs in lean_files().values() for f in fs)
    text = {f: open(os.path.join(root, f)).read() for f in scratch}
    found = []
    for f in scratch:
        own = declared(text[f])
        bare_text = uncommented(text[f])
        for m in CHECK.finditer(bare_text):
            line = bare_text.count('\n', 0, m.start() + len(m.group(0)) - len(m.group(0).lstrip())) + 1
            ns = next((d['namespace'] for d in own if d['name'] == m.group(1) and d['line'] == line), None)
            if ns is None:
                raise SystemExit('the check %s at line %d of %s: its own declaration was not read, so its namespace is not known' % (m.group(1), line, f))
            found.append({'check': m.group(1), 'file': f, 'line': line, 'namespace': ns, 'left': m.group(2), 'right': m.group(4),
                          'universes': {'left': m.group(3), 'right': m.group(5)}})
    bare = {x.split('.')[-1] for c in found for x in (c['left'], c['right'])}
    index = {}
    for f in tracked + scratch:
        t = text.get(f) or open(os.path.join(root, f)).read()
        if any(b in t for b in bare):
            for d in declared(t):
                if d['name'].split('.')[-1] in bare:
                    index.setdefault(d['full'].split('.')[-1], []).append((f, d))

    def side(name, c):
        cands = index.get(name.split('.')[-1], [])
        parts = c['namespace'].split('.') if c['namespace'] else []
        hits = []
        for k in range(len(parts), -1, -1):
            full = '.'.join(parts[:k] + [name])
            hits = [(f, d) for f, d in cands if f == c['file'] and d['full'] == full]
            if hits:
                break
        if not hits:
            hits = [(f, d) for f, d in cands if d['full'] == name or d['full'].endswith('.' + name)]
        fits = [{'file': f, 'line': d['line'], 'full': d['full']} for f, d in hits]
        one = fits[0] if len(fits) == 1 else None
        return {'written': name, 'resolved': bool(one), 'file': one['file'] if one else None, 'line': one['line'] if one else None,
                'full': one['full'] if one else None, 'fits': fits}

    def log(f):
        stem = os.path.basename(f)[:-len('.lean.txt')]
        for name in ('build-%s.log.txt' % stem, '%s.build.log.txt' % stem):
            path = os.path.join(os.path.dirname(f), name)
            if os.path.exists(os.path.join(root, path)):
                t = open(os.path.join(root, path)).read()
                out = {'file': path, 'exit': None, 'axioms': None, 'theorems': None, 'unclean': None}
                m = re.search(r'^exit (\d+)', t, re.M)
                if m:
                    out['exit'] = int(m.group(1))
                try:
                    j = json.loads(t[t.index('{'):t.rindex('}') + 1])
                    audit = j.get('audits', {}).get('Becoming.' + stem)
                    if audit is not None:
                        out['axioms'], out['theorems'] = audit.get('with_axioms'), audit.get('theorems')
                    out['unclean'] = j.get('unclean')
                except ValueError:
                    pass
                return out
        return None

    def says(lg):
        if lg is None:
            return 'no build log is filed beside the module'
        bits = ['exit %s' % lg['exit'] if lg['exit'] is not None else 'no exit line found']
        bits.append('axiom report not found' if lg['axioms'] is None else
                    ('axiom report empty (%s theorems audited)' % lg['theorems'] if lg['axioms'] == {} else 'axiom report not empty: %s' % json.dumps(lg['axioms'], ensure_ascii=False)))
        if lg['unclean']:
            bits.append('unclean: %s' % lg['unclean'])
        return '; '.join(bits)

    out = []
    for c in found:
        left, right = side(c['left'], c), side(c['right'], c)
        name = c['left'].split('.')[-1]
        inside = sorted({(f, d['full'], d['line']) for f, d in index.get(name, []) if f.startswith(PACKAGE)})
        lg = log(c['file'])
        out.append({'check': c['check'], 'check_file': c['file'], 'check_line': c['line'], 'statement': left, 'same_statement_as': right,
                    'up_to': UP_TO, 'universes_written': c['universes'], 'log': lg, 'log_says': says(lg),
                    'in_package': {'searched': 'tracked Lean files under %s, copies left out, for a theorem named %s' % (PACKAGE, name),
                                   'found': [{'file': f, 'full': full, 'line': n, 'is_the_other_side': full == right['full']} for f, full, n in inside]},
                    'record': os.path.relpath(os.path.join(root, os.path.dirname(c['file']), 'NOTE.md')), 'what': SAME})
    return out


def stem_of(path):
    b = path.rsplit('/', 1)[-1]
    return b[:-len('.lean.txt')] if b.endswith('.lean.txt') else b[:-len('.lean')]


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
    same = same_statements()
    for d in same:
        if d['same_statement_as']['resolved']:
            k = stem_of(d['same_statement_as']['file'])
            places.setdefault(k, {'key': k, 'table': [], 'reads': []}).setdefault('same_statement', []).append(d)
    files = lean_files()
    for p in places.values():
        p['files'] = sorted(files.get(p['key'], []))
        p['kind'] = 'one Lean file' if len(p['files']) == 1 else ('several Lean files of this name' if p['files'] else 'no Lean file of this name')
    by_file, by_record = joins()
    for p in places.values():
        p['records'] = sorted(set().union(*[by_file.get(f, set()) for f in p['files']])) if p['files'] else []
        p['dynamics'] = sorted(set().union(*[by_record.get(r, set()) for r in p['records']])) if p['records'] else []
    return list(places.values()), same


if __name__ == '__main__':
    places, same = build()
    json.dump({'made_by': 'build_places.py; never edited by hand', 'caution': CAUTION,
               'reads': [{'tag': t, 'title': ti, 'note': fo + 'NOTE.md', 'fields': f} for t, ti, _, fo, f in READS], 'same_statements': same, 'places': places},
              open('places.json', 'w'), indent=1, ensure_ascii=False)
    L = ['# Places: what one table and the place-by-place reads say of each, in the readers\' words', '',
         '*Made by `build_places.py` beside it; never edited by hand. AI-written (Claude Fable for the script). Each field under *read of …* is ' + CAUTION + '. The table\'s fields are from the table of 20 November; the file, the records, the dynamics and the *same statement* lines are computed by the script, as the note says. The page proves nothing, ranks nothing and holds no link. A place with no read under it was not in that read; that says nothing of the Lean. [The note](NOTE.md) says what this is and is not.*', '',
         'The table\'s letters (20 November, [its note](../two-ways-table-2026-11-20/NOTE.md)): **a** multiplies; **b** a level that can run down; **c** gives at a cost; **d** the source is said; **e** what comes back; **f** a rule set again from a share; **g** both outcomes, boundary exact; **h** no return, or a turn. Y yes, P in part, N no.', '',
         'A place is keyed by a Lean file\'s base name. Where several tracked files carry that name, or none does (a namespace inside a file, a program, a scratch module, a folder, a page), the row says so, since two places can then share a row; the readers\' own names for the place are kept under it.', '',
         '| place | file | in the table | read in | check in scratch |', '|---|---|---|---|---|']
    for p in sorted(places, key=lambda p: p['key'].lower()):
        where = ('`%s`' % p['files'][0]) if len(p['files']) == 1 else (p['kind'] + (': ' + '; '.join('`%s`' % f for f in p['files']) if p['files'] else ''))
        L.append('| %s | %s | %s | %s | %s |' % (p['key'], where, ' / '.join(t['letters'] for t in p['table']), ', '.join(sorted({r['read'] for r in p['reads']})),
                                             ', '.join('`%s`' % d['check'] for d in p.get('same_statement', []))))
    def where_is(x):
        if x['resolved']:
            return '`%s`, line %d of `%s`' % (x['full'], x['line'], x['file'])
        return '`%s`: place not resolved (%s)' % (x['written'], ('%d files fit: ' % len(x['fits']) + '; '.join('`%s`' % f['file'] for f in x['fits'])) if x['fits'] else 'no file found that declares it')

    def in_pkg(d):
        fnd = d['in_package']['found']
        name = d['statement']['written'].split('.')[-1]
        return ('a theorem named `%s` is declared under the package at this run: ' % name + '; '.join('`%s`, line %d of `%s`%s' % (f['full'], f['line'], f['file'], ' (this is the check\'s other side)' if f['is_the_other_side'] else '') for f in fnd)) if fnd \
            else 'no theorem named `%s` found under the package at this run' % name

    def log_line(d):
        return ('[`%s`](%s): ' % (d['log']['file'].rsplit('/', 1)[-1], os.path.relpath(os.path.join(os.path.dirname(d['record']), d['log']['file'].rsplit('/', 1)[-1]))) if d['log'] else '') + d['log_says']

    L += ['', '## Same statement, up to unfolding: checks filed in scratch', '',
          'Read off the scratch modules filed as text in this row\'s study, by pattern. Each line is ' + SAME + '. The file of each side was found by search for a file that declares a theorem whose full name is the name written, or ends with it at a dot (the check\'s own file first, under the namespaces enclosing the check); '
          'the log is the one filed beside the module that holds the check; the package (`' + PACKAGE + '`) was searched when this page was made. None of it is a link of the atlas. '
          'The note of each scratch folder says what each statement was proved from and who read it.', '',
          '| statement | same statement as, up to unfolding | check | filed build log of the check\'s module | in the package |', '|---|---|---|---|---|']
    for d in same:
        L.append('| %s | %s | `%s`, line %d of [`%s`](%s) ([note](%s)) | %s | %s |' % (
            where_is(d['statement']), where_is(d['same_statement_as']), d['check'], d['check_line'], d['check_file'].rsplit('/', 1)[-1],
            os.path.relpath(os.path.join(os.path.dirname(d['record']), d['check_file'].rsplit('/', 1)[-1])), d['record'], log_line(d), in_pkg(d)))
    L += ['', 'The reads: '
 + '; '.join('**%s** %s ([note](%sNOTE.md))' % (t, ti, fo) for t, ti, _, fo, _f in READS) + '.', '',
          '## Each place, in the readers\' words', '']
    for p in sorted(places, key=lambda p: p['key'].lower()):
        if not p['reads'] and not p.get('same_statement'):
            continue
        L.append('### %s (%s)' % (p['key'], ('readers\' returns of %s; not checked' % ', '.join(sorted({r['title'].split(',')[0] for r in p['reads']}))) if p['reads']
                                    else '; '.join(['no read'] + (['in the table'] if p['table'] else []) + ['a check in scratch'])))
        for t in p['table']:
            L.append('- *table:* %s, letters `%s`, standing %s%s' % (t['row'], t['letters'], t['standing'], (', told in ' + t['told_in']) if t['told_in'] else ''))
        if p['records']:
            L.append('- *result records that name this place\'s file as a source* (computed; not a link): ' + ', '.join('`%s`' % r for r in p['records']))
        if p['dynamics']:
            L.append('- *dynamics in the atlas that name one of those records* (computed; not a link): ' + ', '.join('`%s`' % d for d in p['dynamics']))
        for d in p.get('same_statement', []):
            L.append('- *same statement as, up to unfolding:* %s has the same statement as %s, by the check `%s` (line %d of [`%s`](%s); [note](%s)). Filed build log of the check\'s module: %s. In the package: %s. (%s.)' % (
                where_is(d['same_statement_as']), where_is(d['statement']), d['check'], d['check_line'], d['check_file'].rsplit('/', 1)[-1],
                os.path.relpath(os.path.join(os.path.dirname(d['record']), d['check_file'].rsplit('/', 1)[-1])), d['record'], log_line(d), in_pkg(d), SAME))
        for r in p['reads']:
            L.append('- *read of %s, reader %s, as "%s"* (%s: [note](%s), [report](%s)):' % (r['title'], r['reader'], r['place'].replace('\n', ' '), CAUTION, r['note'], r['report']))
            for f, v in r['fields'].items():
                L.append('  - %s: %s' % (HEAD[f], (v or '').replace('\n', ' ')))
        L.append('')
    open('PLACES.md', 'w').write('\n'.join(L) + '\n')
    print(len(places), sum(1 for p in places if p['table']), sum(1 for p in places if p['reads']))
