#!/usr/bin/env python3
"""follow2 <tree> <run> [--apply]: carry the changed sentences into shorter quotations of them:
the review packet's dossiers (Quote [PATH]: "...") and string literals in the tests."""
import sys, json, re, ast, glob, difflib, os
tree, run = sys.argv[1], sys.argv[2]; apply = '--apply' in sys.argv
ch = json.load(open(run + '/changes.json'))
def map_span(o, n, a, b):
    ops = difflib.SequenceMatcher(None, o, n, autojunk=False).get_opcodes()
    def at(x, end):
        for tag, i1, i2, j1, j2 in ops:
            if tag == 'equal' and i1 <= x <= i2 and (x < i2 or end or i2 == len(o)):
                if x == i1 and end and i1 != 0: continue  # an end at the start of an equal block belongs to the block before
                return j1 + (x - i1)
            if tag != 'equal' and i1 <= x <= i2:
                if end and x == i1: continue
                return j2 if end else j1
        return None
    return at(a, False), at(b, True)
def mapped(q, files=None):
    """q occurs in an old line (of the given files) and not in its new line: the same stretch of the new line."""
    for c in ch:
        if files and c['file'] not in files: continue
        k = c['old'].find(q)
        if k < 0 or q in c['new']: continue
        a, b = map_span(c['old'], c['new'], k, k + len(q))
        if a is None or b is None: return None
        return c['new'][a:b]
    return None
QUOTE = re.compile(r'(原文|引|Source|Quote)\s*[〔\[]([^〕\]]+)[〕\]]\s*[：:]\s*[「"“]([^」"”]+)[」"”]')
tot = 0; unresolved = []
for p in sorted(glob.glob(f'{tree}/theories/becoming/review/*.md')):
    s = open(p, encoding='utf-8').read(); t = s; n = 0
    for m in QUOTE.finditer(s):
        path, quote = m.group(2).strip(), m.group(3)
        if not os.path.exists(f'{tree}/{path}'): continue
        cur = open(f'{tree}/{path}', encoding='utf-8').read()
        for part in re.split(r'\s*(?:…|\.\.\.)\s*', quote):
            part = part.strip()
            if len(part) < 6 or part in cur: continue
            new = mapped(part, {path})
            if new is None or new not in cur:
                unresolved.append((os.path.basename(p), path.split('/')[-1], part[:80])); continue
            if t.count(part) >= 1:
                t = t.replace(part, new); n += 1
    if n:
        tot += n; print(f'{n:4d} {os.path.relpath(p, tree)}')
        if apply:
            with open(p, 'w', encoding='utf-8') as f: f.write(t)
pages = {c['file'] for c in ch}
cur_all = {f: open(f'{tree}/{f}', encoding='utf-8').read() for f in pages}
for p in sorted(glob.glob(f'{tree}/tools/research/tests/*.py')):
    s = open(p, encoding='utf-8').read(); t = s; n = 0
    lits = {node.value for node in ast.walk(ast.parse(s)) if isinstance(node, ast.Constant) and isinstance(node.value, str)}
    for q in sorted(lits, key=len, reverse=True):
        if len(q) < 12 or not re.search(r'\blaws?\b', q, re.I): continue
        if any(q in v for v in cur_all.values()): continue
        new = mapped(q)
        if new is None: continue
        if q in t:
            t = t.replace(q, new); n += 1; print('      ', os.path.basename(p), '|', q[:70], '=>', new[:70])
        else:
            unresolved.append((os.path.basename(p), 'literal not verbatim in source', q[:80]))
    if n:
        tot += n
        if apply:
            with open(p, 'w', encoding='utf-8') as f: f.write(t)
print('replacements', tot, '(applied)' if apply else '(dry run)')
for u in unresolved: print('UNRESOLVED', u)
