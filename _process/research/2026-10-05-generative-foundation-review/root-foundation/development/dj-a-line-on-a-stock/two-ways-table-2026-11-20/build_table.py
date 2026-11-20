#!/usr/bin/env python3
"""Build the table of what the repository already has toward the two ways, from the readers' cells.

AI-written (Claude Fable, 20 November 2026). Reads the journal of the workflow run that filled the table
(two blind readers a group, a third where they differ) and writes:
  two-ways-table.json   every cell with both readers' values, declarations and notes, and the settling where they differed
  TABLE.md              a view of it: one line a place, eight letters, and under each group what carries each Y or P
It decides nothing: a cell both readers gave alike is that value; a cell they gave differently is the settler's;
a cell with no settling is marked "?".

Usage: python3 -B build_table.py JOURNAL.jsonl [DIRECTION.md]
"""
import json, re, sys
from collections import OrderedDict

COLS = 'abcdefgh'
HEAD = {'a': 'multiplies', 'b': 'a level that can run down', 'c': 'gives at a cost', 'd': 'the source is said',
        'e': 'what comes back', 'f': 'a rule set again from a share', 'g': 'both outcomes, boundary exact', 'h': 'no return, or a turn'}


def load(journal):
    label, res = {}, {}
    for line in open(journal):
        d = json.loads(line)
        if d.get('type') == 'started':
            label[d['key']] = d.get('label')
        elif d.get('type') == 'result':
            res[label.get(d['key'], d['key'])] = d.get('result')
    return res


def norm(s):
    return re.sub(r'\s+', ' ', s.strip().lower())


def build(res):
    groups = OrderedDict()
    for lab in res:
        m = re.match(r'fill-([AB]):(.+)$', lab or '')
        if m:
            groups.setdefault(m.group(2), {})[m.group(1)] = res[lab]
    for lab in res:
        m = re.match(r'settle:(.+)$', lab or '')
        if m and m.group(1) in groups:
            groups[m.group(1)]['S'] = res[lab]
    out, added = [], []
    for key, g in groups.items():
        A, B = g.get('A') or {}, g.get('B') or {}
        S = {(norm(s['row']), s['col']): s for s in ((g.get('S') or {}).get('settled') or [])}
        rb = {norm(r['row']): r for r in (B.get('rows') or [])}
        rows = []
        for ra in (A.get('rows') or []):
            b = rb.pop(norm(ra['row']), None)
            row = {'row': ra['row'], 'path': ra.get('path', ''), 'standing': {'A': ra.get('standing'), 'B': b.get('standing') if b else None},
                   'reach': {'A': ra.get('reach'), 'B': b.get('reach') if b else None},
                   'told_in': {'A': ra.get('told_in'), 'B': b.get('told_in') if b else None},
                   'read': {'A': ra.get('read'), 'B': b.get('read') if b else None}, 'cells': {}}
            for c in COLS:
                ca = ra['cells'][c]; cb = b['cells'][c] if b else None
                s = S.get((norm(ra['row']), c))
                if cb is not None and ca['v'] == cb['v']:
                    v, how = ca['v'], 'both readers'
                elif s:
                    v, how = s['v'], 'settled by a third'
                elif cb is None and s is None:
                    v, how = ca['v'] + '?', 'one reader only'
                else:
                    v, how = '?', 'readers differ, not settled'
                row['cells'][c] = {'v': v, 'how': how, 'A': ca, 'B': cb, 'settled': s}
            rows.append(row)
        for name, b in rb.items():       # rows only B returned
            row = {'row': b['row'], 'path': b.get('path', ''), 'standing': {'A': None, 'B': b.get('standing')}, 'reach': {'A': None, 'B': b.get('reach')},
                   'told_in': {'A': None, 'B': b.get('told_in')}, 'read': {'A': None, 'B': b.get('read')}, 'cells': {}}
            for c in COLS:
                s = S.get((name, c))
                row['cells'][c] = {'v': (s['v'] if s else b['cells'][c]['v'] + '?'), 'how': 'settled by a third' if s else 'one reader only', 'A': None, 'B': b['cells'][c], 'settled': s}
            rows.append(row)
        out.append({'group': key, 'rows': rows, 'not_read': {'A': A.get('not_read'), 'B': B.get('not_read')}})
        for who, x in (('A', A), ('B', B)):
            for a in (x.get('added') or []):
                added.append({'group': key, 'reader': who, **a})
    order = ['centre', 'lock-shaping', 'web-classes', 'resting-on-each-other', 'returns-pairs-groups', 'optima-drawers',
             'keepers-lineages-commons', 'keeping-lasting-ranking', 'added-descent', 'added-stock', 'market', 'meta-attractor', 'outside-and-unlanded']
    out.sort(key=lambda g: order.index(g['group']) if g['group'] in order else len(order))
    return out, added


def one(x):
    """One value for standing, reach, told-in from the two readers."""
    return x.get('A') or x.get('B') or ''     # the view gives the first reader's words; the data file has both


def view(groups, added, direction=None):
    page = direction and open(direction).read()
    L = []
    L.append('| place | ' + ' | '.join(COLS) + ' | standing | reach | told in |')
    L.append('|---|' + '---|' * len(COLS) + '---|---|---|')
    stats = {'cells': 0, 'both': 0, 'settled': 0, 'open': 0}
    tally = []
    for g in groups:
        L.append('| **%s** |' % g['group'] + ' |' * (len(COLS) + 3))
        for r in g['rows']:
            vs = [r['cells'][c]['v'] for c in COLS]
            for c in COLS:
                stats['cells'] += 1
                how = r['cells'][c]['how']
                stats['both' if how == 'both readers' else 'settled' if how == 'settled by a third' else 'open'] += 1
            tally.append((sum(v == 'Y' for v in vs), sum(v == 'P' for v in vs), g['group'], r['row'], ''.join(v if len(v) == 1 else '?' for v in vs)))
            L.append('| %s | %s | %s | %s | %s |' % (r['row'], ' | '.join(vs), one(r['standing']), one(r['reach']).replace('|', '/'), one(r['told_in']).replace('|', '/')))
    return L, stats, sorted(tally, reverse=True)


def details(groups):
    L = []
    for g in groups:
        L.append('\n### %s\n' % g['group'])
        for r in g['rows']:
            L.append('**%s**' % r['row'])
            for c in COLS:
                cell = r['cells'][c]
                if cell['v'] in ('N',): continue
                src = cell['settled'] or cell['A'] or cell['B']
                note = (src.get('note') or '').replace('\n', ' ')
                decl = (src.get('decl') or '').replace('\n', ' ')
                L.append('- %s, %s (%s): %s%s' % (c, cell['v'], cell['how'], ('`%s`. ' % decl) if decl else '', note))
            L.append('')
    return L


if __name__ == '__main__':
    res = load(sys.argv[1])
    groups, added = build(res)
    json.dump({'columns': HEAD, 'groups': groups, 'added': added}, open('two-ways-table.json', 'w'), indent=1, ensure_ascii=False)
    L, stats, tally = view(groups, added, sys.argv[2] if len(sys.argv) > 2 else None)
    head = ['# What the repository already has toward the two ways: the table', '',
            '*Generated by `build_table.py` from `two-ways-table.json`; do not edit by hand. AI-written (Claude Fable); every cell is an AI reader\'s, taken from a statement and not from a proof. [The note](NOTE.md) says how it was made and what it shows; [the columns and rows](COLUMNS-AND-ROWS.md) were fixed first.*', '',
            'Columns: ' + '; '.join('**%s** %s' % (c, HEAD[c]) for c in COLS) + '. **Y** yes, **P** in part, **N** no, as the columns\' definitions have them.', '',
            '%d places, %d cells: %d on which two readers who did not see each other agreed, %d settled by a third from the statement.' % (sum(len(g['rows']) for g in groups), stats['cells'], stats['both'], stats['settled']), '']
    open('TABLE.md', 'w').write('\n'.join(head + L + ['', '## What carries each Y and P', '', 'For each place, each cell that is not N: its value, how it was reached, the declarations with their lines, and the reader\'s note. Where two readers agreed the first reader\'s words are given; both readers\' words for every cell are in the data file.'] + details(groups)) + '\n')
    print(json.dumps(stats))
    for t in tally[:25]: print(t)
    print('added:', len(added))
    for a in added: print('  ', a['group'], a['reader'], a['place'], '-', a['why'][:150])
