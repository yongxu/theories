#!/usr/bin/env python3
"""Find candidate uses of law/laws in a piece: outside backticks, links, anchors,
headings, blockquotes. Prints or returns (line_no, start, end, word)."""
import re, sys, json, collections
MASK = [re.compile(r'`[^`\n]*`'), re.compile(r'\[[^\]\n]*\]\([^)\n]*\)'),
        re.compile(r'\[[^\]\n]*\]\[[^\]\n]*\]'), re.compile(r'<a [^>]*>'), re.compile(r'<[^>\n]*>')]
W = re.compile(r'\b[Ll]aws?\b')
def mask(line):
    s = line
    for rx in MASK:
        s = rx.sub(lambda m: '\x00'*len(m.group(0)), s)
    return s
def cands(text):
    out = []
    for i, line in enumerate(text.split('\n'), 1):
        if line.startswith('#') or line.lstrip().startswith('>'):
            continue
        s = mask(line)
        for m in W.finditer(s):
            out.append((i, m.start(), m.end(), m.group(0)))
    return out
if __name__ == '__main__':
    import os, glob
    d = sys.argv[1]
    tot = 0; rows = []
    for p in sorted(glob.glob(d + '/*.orig.md')):
        t = open(p).read()
        c = cands(t)
        allw = len(re.findall(r'[Ll]aws?\b', t))
        rows.append((os.path.basename(p)[:-8], len(t.split()), allw, len(c)))
        tot += len(c)
    for r in rows: print('%-34s words %5d  all %4d  cand %4d' % r)
    print('pieces', len(rows), 'candidates', tot)
