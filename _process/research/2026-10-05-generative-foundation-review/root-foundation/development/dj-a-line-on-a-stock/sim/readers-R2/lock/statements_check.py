"""AI-written (Fable, reader R2:lock), 16 November 2026. Read-only check, seconds.

1. Every declaration of the tracked TurningInTime.lean has, in the scratch file, the same header
   byte for byte (from the declaration keyword line, modifiers and attributes included, up to the
   first `:=` / ` where` / match arm at bracket depth 0, comments NOT stripped inside the header).
2. Every tracked line that is gone from the scratch file (line diff) is classified:
   module header / section comment / docstring text, or a code line of ends_with_net.
3. Code with comments stripped: tracked code lines form a subsequence of scratch code lines except
   for the lines of ends_with_net's proof.
"""
import difflib
import re
import sys

T = '/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/TurningInTime.lean'
S = '/Users/ren/theories/tmp/r7/one-model/lean-scratch/Becoming/TurningInTime.lean'
if len(sys.argv) == 3:
    T, S = sys.argv[1], sys.argv[2]


def mask(text):
    """Return a list kind[i] for each character: 'c' code, 'd' docstring (/-- -/), 'm' module doc
    (/-! -/), 'b' other block comment, 'l' line comment. Block comments nest."""
    kind = []
    i, n = 0, len(text)
    while i < n:
        if text.startswith('/-', i):
            k = 'd' if text.startswith('/--', i) else 'm' if text.startswith('/-!', i) else 'b'
            depth, j = 1, i + 2
            while j < n and depth:
                if text.startswith('/-', j):
                    depth += 1
                    j += 2
                elif text.startswith('-/', j):
                    depth -= 1
                    j += 2
                else:
                    j += 1
            kind.extend(k * (j - i))
            i = j
        elif text.startswith('--', i):
            j = text.find('\n', i)
            j = n if j < 0 else j
            kind.extend('l' * (j - i))
            i = j
        else:
            kind.append('c')
            i += 1
    return kind


KEY = re.compile(r'^(?:@\[[^\]]*\]\s*)?(?:(?:private|protected|noncomputable|unsafe|partial)\s+)*'
                 r'(theorem|def|abbrev|instance|structure|inductive|lemma|class|opaque|axiom|example)\b[ \t]*(\S*)',
                 re.M)
NS = re.compile(r'^(namespace|section|end)\b[ \t]*(\S*)', re.M)


def declarations(text):
    kind = mask(text)
    code = ''.join(ch if k == 'c' else ('\n' if ch == '\n' else ' ') for ch, k in zip(text, kind))
    events = [(m.start(), 'ns', m) for m in NS.finditer(code)] + [(m.start(), 'decl', m) for m in KEY.finditer(code)]
    events.sort(key=lambda e: e[0])
    stack, out = [], []
    for pos, what, m in events:
        if what == 'ns':
            word, name = m.group(1), m.group(2)
            if word == 'namespace':
                stack.append(('ns', name))
            elif word == 'section':
                stack.append(('sec', name))
            else:
                if stack:
                    stack.pop()
            continue
        # header end: first `:=`, ` where` or `\n  |` at bracket depth 0 in code
        depth, j, end = 0, m.end(), None
        while j < len(code):
            ch = code[j]
            if ch in '([{⟨':
                depth += 1
            elif ch in ')]}⟩':
                depth -= 1
            elif depth == 0 and code.startswith(':=', j):
                end = j
                break
            elif depth == 0 and (code.startswith(' where', j) or code.startswith('\nwhere', j)) and not code[j + 6:j + 7].isalnum():
                end = j
                break
            elif depth == 0 and re.match(r'\n\s*\|', code[j:j + 12]):
                end = j
                break
            elif depth == 0 and code.startswith('\n\n', j):
                end = j
                break
            j += 1
        end = len(code) if end is None else end
        qual = '.'.join([n for k, n in stack if k == 'ns' and n] + [m.group(2) or '<anon>'])
        out.append((qual, m.group(1), text[pos:end], text[:pos].count('\n') + 1, text[:end].count('\n') + 1))
    return out, kind, code


tt, st = open(T, encoding='utf-8').read(), open(S, encoding='utf-8').read()
td, tk, tcode = declarations(tt)
sd, sk, scode = declarations(st)
print('tracked declarations', len(td), '; scratch declarations', len(sd))
smap = {}
for q, k, h, a, b in sd:
    smap.setdefault(q, []).append((k, h, a, b))
tnames = [q for q, *_ in td]
dups = sorted({q for q in tnames if tnames.count(q) > 1})
print('duplicate qualified names in tracked:', dups)
same = changed = missing = 0
seen = {}
for q, k, h, a, b in td:
    idx = seen.get(q, 0)
    seen[q] = idx + 1
    cands = smap.get(q, [])
    if not cands:
        missing += 1
        print('  MISSING in scratch:', q, 'tracked l.%d' % a)
        continue
    if any(h == hh and k == kk for kk, hh, _, _ in cands):
        same += 1
    else:
        changed += 1
        print('  CHANGED:', q, 'tracked l.%d' % a)
        print('   T:', repr(h[:400]))
        print('   S:', repr(cands[0][1][:400]))
print('headers byte-identical:', same, '; changed:', changed, '; missing:', missing)
new = [(q, k, a) for q, k, h, a, b in sd if q not in set(tnames)]
print('declarations only in scratch:', len(new))
for q, k, a in new:
    print('   l.%d %s %s' % (a, k, q))

# 2. removed tracked lines, classified by the mask
tl, sl = tt.split('\n'), st.split('\n')
# line start offsets
toff = [0]
for line in tl:
    toff.append(toff[-1] + len(line) + 1)


def linekind(i):
    """kinds of the non-blank characters on tracked line i (0-based)"""
    ks = {tk[p] for p in range(toff[i], toff[i] + len(tl[i])) if not tt[p].isspace()}
    return ks


# which declaration (by code range) a tracked line falls in
ranges = []
for n, (q, k, h, a, b) in enumerate(td):
    nxt = td[n + 1][3] if n + 1 < len(td) else len(tl) + 1
    ranges.append((a, nxt - 1, q))


def owner(lineno):
    for a, b, q in ranges:
        if a <= lineno <= b:
            return q
    return None


sm = difflib.SequenceMatcher(None, tl, sl, autojunk=False)
removed = []
for tag, i1, i2, j1, j2 in sm.get_opcodes():
    if tag in ('replace', 'delete'):
        removed.extend(range(i1, i2))
print('tracked lines removed or replaced (difflib):', len(removed))
klass = {}
codelines = []
for i in removed:
    ks = linekind(i)
    if not ks:
        c = 'blank'
    elif ks <= {'m'}:
        c = 'module-doc (/-! -/) text'
    elif ks <= {'d'}:
        c = 'docstring (/-- -/) text'
    elif ks <= {'b', 'l'}:
        c = 'plain comment'
    else:
        c = 'CODE'
        codelines.append(i)
    klass[c] = klass.get(c, 0) + 1
for c, n in sorted(klass.items()):
    print('  ', c, n)
sset = {}
for line in sl:
    sset[line] = sset.get(line, 0) + 1
for i in codelines:
    print('   code l.%d owner=%s reappears_in_scratch=%s : %s' % (i + 1, owner(i + 1), tl[i] in sset, tl[i][:110]))

# docstring lines: which declaration's docstring (the declaration that follows)
print('removed docstring/module-doc lines by place:')
for i in removed:
    ks = linekind(i)
    if ks and ks <= {'d', 'm', 'b', 'l'}:
        # next declaration start after this line
        nxt = next((q for q, k, h, a, b in td if a > i + 1), None)
        print('   l.%d [%s] before %s' % (i + 1, ''.join(sorted(ks)), nxt))

# 3. code-only comparison
def codelines_of(code):
    return [' '.join(l.split()) for l in code.split('\n') if l.strip()]


tc, sc = codelines_of(tcode), codelines_of(scode)
sm2 = difflib.SequenceMatcher(None, tc, sc, autojunk=False)
gone = []
for tag, i1, i2, j1, j2 in sm2.get_opcodes():
    if tag in ('replace', 'delete'):
        gone.extend(tc[i1:i2])
print('code-only: tracked code lines', len(tc), '; scratch', len(sc), '; tracked code lines not kept in order:', len(gone))
for g in gone:
    print('   -', g[:120], '| reappears:', g in set(sc))
