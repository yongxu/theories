"""Tally the marks: per reader, per question, per pass; then round one against round two, item by item."""
import re, sys
S = sys.argv[1]
STAR = set('1.1 1.2 1.3 1.4 1.5 1.6 2.1 2.2 2.3 2.4 2.6 2.7 2.9 2.11 2.12 2.14 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 4.1 4.2 4.4 4.5 4.6 5.1 5.2 5.4 5.5 6.1 6.2 6.3 6.4'.split())
def read(name, cols):
    out = {}
    raw = open(f'{S}/{name}', encoding='utf-8').read()
    i = raw.find('\n── cx ·')
    if i >= 0:
        raw = raw[:i]
    for line in raw.split('\n'):
        m = re.match(r'\|\s*(\d\.\d+)\s*\|(.*)\|\s*$', line)
        if m:
            cells = [c.strip() for c in m[2].split('|')]
            out[m[1]] = dict(zip(cols, cells[:len(cols)]))
    return out
two = {'claude': read('marks-claude-reader.txt', ['FIRST', 'SECOND', 'CLOSED']), 'gpt': read('marks-gpt-reader.txt', ['FIRST', 'SECOND', 'CLOSED'])}
one = {'claude': read('marks-round-one-claude-reader.txt', ['FIRST', 'SECOND']), 'gpt': read('marks-round-one-gpt-reader.txt', ['FIRST', 'SECOND'])}
print({k: len(v) for k, v in two.items()}, {k: len(v) for k, v in one.items()})
def tally(marks, col, q=None, items=None):
    c = {'R': 0, 'P': 0, 'A': 0, 'W': 0}
    for item, row in marks.items():
        if (q is None or item.startswith(q + '.')) and (items is None or item in items) and row.get(col) in c:
            c[row[col]] += 1
    return c
def fmt(c):
    return f"{c['R']}R {c['P']}P {c['A']}A {c['W']}W"
print('\nby question: reader | round one FIRST SECOND | round two FIRST SECOND CLOSED')
for q in ['1', '2', '3', '4', '5', '6', '7', None]:
    for r in ['claude', 'gpt']:
        print(f"Q{q or ' all'} {r:6} | {fmt(tally(one[r],'FIRST',q)):14} {fmt(tally(one[r],'SECOND',q)):14} | {fmt(tally(two[r],'FIRST',q)):14} {fmt(tally(two[r],'SECOND',q)):14} {fmt(tally(two[r],'CLOSED',q))}")
print('\nstarred items')
for r in ['claude', 'gpt']:
    print(r, fmt(tally(one[r],'FIRST',items=STAR)), '|', fmt(tally(one[r],'SECOND',items=STAR)), '||', fmt(tally(two[r],'FIRST',items=STAR)), '|', fmt(tally(two[r],'SECOND',items=STAR)), '|', fmt(tally(two[r],'CLOSED',items=STAR)))
rank = {'R': 3, 'P': 2, 'A': 1, 'W': 0}
print('\nitem moves after the whole path (SECOND): up and down, both readers')
for r in ['claude', 'gpt']:
    up = [(i, one[r][i]['SECOND'], two[r][i]['SECOND']) for i in two[r] if i in one[r] and rank.get(two[r][i]['SECOND'],0) > rank.get(one[r][i]['SECOND'],0)]
    down = [(i, one[r][i]['SECOND'], two[r][i]['SECOND']) for i in two[r] if i in one[r] and rank.get(two[r][i]['SECOND'],0) < rank.get(one[r][i]['SECOND'],0)]
    print(r, 'UP', ' '.join(f'{a}:{b}>{c}' for a,b,c in up))
    print(r, 'DOWN', ' '.join(f'{a}:{b}>{c}' for a,b,c in down))
print('\nitem moves after ten minutes (FIRST)')
for r in ['claude', 'gpt']:
    up = [(i, one[r][i]['FIRST'], two[r][i]['FIRST']) for i in two[r] if i in one[r] and rank.get(two[r][i]['FIRST'],0) > rank.get(one[r][i]['FIRST'],0)]
    down = [(i, one[r][i]['FIRST'], two[r][i]['FIRST']) for i in two[r] if i in one[r] and rank.get(two[r][i]['FIRST'],0) < rank.get(one[r][i]['FIRST'],0)]
    print(r, 'UP', ' '.join(f'{a}:{b}>{c}' for a,b,c in up))
    print(r, 'DOWN', ' '.join(f'{a}:{b}>{c}' for a,b,c in down))
print('\nW marks')
for label, m, cols in [('one', one, ['FIRST','SECOND']), ('two', two, ['FIRST','SECOND','CLOSED'])]:
    for r in m:
        print(label, r, [(i, c) for i, row in m[r].items() for c in cols if row.get(c) == 'W'])

print('\n=== agreement between markers on the same answers (round two)')
check = {'claude': read('marks-check-claude-reader-by-claude.txt', ['FIRST', 'SECOND', 'CLOSED']), 'gpt': read('marks-check-gpt-reader-by-gpt.txt', ['FIRST', 'SECOND', 'CLOSED'])}
pool = {'n': 0, 'same': 0, 'one': 0}
for r in ['claude', 'gpt']:
    for col in ['FIRST', 'SECOND', 'CLOSED']:
        n = same = adjacent = apart = 0
        for i, row in two[r].items():
            a, b = row.get(col), check[r].get(i, {}).get(col)
            if a not in rank or b not in rank:
                continue
            n += 1
            if a == b:
                same += 1
            elif abs(rank[a] - rank[b]) == 1:
                adjacent += 1
            else:
                apart += 1
        print(f'{r:6} {col:6} n={n} same={same} ({100*same//n}%) one step={adjacent} further={apart} | first marker {fmt(tally(two[r],col))} | second marker {fmt(tally(check[r],col))}')
        pool['n'] += n; pool['same'] += same; pool['one'] += adjacent
print('pooled', pool, f"{100*pool['same']//pool['n']}% exact")
print('\nitem 5.1, all marks')
for r in ['claude', 'gpt']:
    print(r, 'round one', one[r]['5.1'].get('FIRST'), one[r]['5.1'].get('SECOND'), '| round two', two[r]['5.1'].get('FIRST'), two[r]['5.1'].get('SECOND'), two[r]['5.1'].get('CLOSED'), '| check', check[r]['5.1'].get('FIRST'), check[r]['5.1'].get('SECOND'), check[r]['5.1'].get('CLOSED'))
print('\nQ5 by second marker'); 
for r in ['claude', 'gpt']:
    print(r, fmt(tally(check[r],'FIRST','5')), fmt(tally(check[r],'SECOND','5')), fmt(tally(check[r],'CLOSED','5')))
print('\nW by second marker', {r: [(i, c) for i, row in check[r].items() for c in ['FIRST','SECOND','CLOSED'] if row.get(c) == 'W'] for r in check})
print('\nclosed: both readers, both markers, items R or P in all four / A in all four')
items = list(two['claude'])
all_right = [i for i in items if all(m[r][i].get('CLOSED') == 'R' for m in (two, check) for r in ('claude','gpt'))]
all_absent = [i for i in items if all(m[r][i].get('CLOSED') == 'A' for m in (two, check) for r in ('claude','gpt'))]
print('all R', all_right); print('all A', all_absent)
