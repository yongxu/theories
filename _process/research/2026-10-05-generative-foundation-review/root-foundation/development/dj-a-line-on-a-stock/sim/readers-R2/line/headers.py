#!/usr/bin/env python3
"""AI-written (Fable, reader), 16 November 2026. Compare declaration headers (up to the first `:=`,
or for pattern-matching definitions up to the first line starting with `|`) between the tracked
and the scratch copy of a module, comments and docstrings stripped (nested block comments handled).
Also lists, for the scratch file, the declarations that are not in the tracked one."""
import re, sys

def strip_comments(src):
    out = []; i = 0; depth = 0; n = len(src)
    while i < n:
        if src.startswith('/-', i):
            depth += 1; i += 2; continue
        if depth and src.startswith('-/', i):
            depth -= 1; i += 2; continue
        if depth:
            if src[i] == '\n': out.append('\n')
            i += 1; continue
        if src.startswith('--', i):
            while i < n and src[i] != '\n': i += 1
            continue
        out.append(src[i]); i += 1
    return ''.join(out)

DECL = re.compile(r'^(?:@\[[^\]]*\]\s*)?(?:private\s+|protected\s+|noncomputable\s+)*'
                  r'(theorem|def|abbrev|instance|inductive|structure|lemma|opaque|axiom)\s+([^\s:({\[]+)?', re.M)
NS = re.compile(r'^(namespace|end|section)\b[ \t]*([^\s]*)', re.M)

def decls(path):
    src = strip_comments(open(path, encoding='utf-8').read())
    lines = src.split('\n')
    # namespace tracking by line
    stack = []; found = {}; order = []
    starts = []
    for ln, line in enumerate(lines):
        m = NS.match(line)
        if m:
            if m.group(1) == 'namespace': stack.append(('ns', m.group(2)))
            elif m.group(1) == 'section': stack.append(('sec', m.group(2)))
            else:
                if stack: stack.pop()
            continue
        m = DECL.match(line)
        if m:
            ns = '.'.join(n for k, n in stack if k == 'ns')
            starts.append((ln, m.group(1), m.group(2) or '<anon>', ns))
    for idx, (ln, kind, name, ns) in enumerate(starts):
        end = starts[idx + 1][0] if idx + 1 < len(starts) else len(lines)
        body = '\n'.join(lines[ln:end])
        cut = len(body)
        m = re.search(r':=', body)
        if m: cut = min(cut, m.start())
        m = re.search(r'\n\s*\|', body)
        if m: cut = min(cut, m.start())
        m = re.search(r'\bwhere\b', body)
        if m: cut = min(cut, m.start())
        header = ' '.join(body[:cut].split())
        full = (ns + '.' + name) if ns else name
        key = full
        k = 2
        while key in found:
            key = f'{full}#{k}'; k += 1
        found[key] = (header, ln + 1); order.append(key)
    return found, order

tracked, scratch = sys.argv[1], sys.argv[2]
T, To = decls(tracked); S, So = decls(scratch)
kept = [k for k in To if k in S]
changed = [k for k in kept if T[k][0] != S[k][0]]
removed = [k for k in To if k not in S]
added = [k for k in So if k not in T]
print(f'tracked {len(To)}  scratch {len(So)}  kept {len(kept)}  changed {len(changed)}  removed {len(removed)}  added {len(added)}')
for k in changed:
    print('CHANGED', k); print('  tracked:', T[k][0]); print('  scratch:', S[k][0])
print('removed:', ', '.join(removed))
print('added:', ', '.join(f'{k}@{S[k][1]}' for k in added))
