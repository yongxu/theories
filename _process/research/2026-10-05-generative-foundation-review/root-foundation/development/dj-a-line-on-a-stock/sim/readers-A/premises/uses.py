# AI-written (reader, premises lens), 16 November 2026. Read-only scan: where each public theorem is used in code (comments stripped).
import re, sys
p = '/Users/ren/theories/tmp/r7/one-model/lean-scratch/Becoming/LineOnAStock.lean'
src = open(p).read()
# blank out comments, keeping line numbers
def blank(m):
    return ''.join(ch if ch == '\n' else ' ' for ch in m.group(0))
code = re.sub(r'/-.*?-/', blank, src, flags=re.S)
lines = code.split('\n')
names = []
for i, l in enumerate(lines, 1):
    m = re.match(r'\s*(theorem|def|abbrev|instance)\s+([^\s:({\[]+)', l)
    if m:
        names.append((m.group(2), i, m.group(1)))
for n, ln, kind in names:
    pat = re.compile(r'(?<![\w.«»\'])' + re.escape(n) + r'(?![\w\'«»])')
    used = [i for i, l in enumerate(lines, 1) if i != ln and pat.search(l)]
    print(f'{kind:8} {n:22} decl {ln:5}  used at {used if used else "NOWHERE in code"}')
