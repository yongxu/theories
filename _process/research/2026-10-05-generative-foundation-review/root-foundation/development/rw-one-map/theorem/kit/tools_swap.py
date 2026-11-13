#!/usr/bin/env python3
# AI-written, 13 November 2026 (the map's part of WL). Swaps "law" for "theorem" in the prose of the map's two tools:
# only inside Python string literals and comments (never in code), never inside an f-string's braces or a format
# placeholder, never a bare key ('law', 'laws', 'law-to-prediction'), never an all-capitals name (LAWS.md, /*LAWS*/),
# never "Goodhart's law". For the .html templates: text outside {{..}}, ${..} and the listed code patterns.
# Every change is printed; the coordinator reads the diff. Run: tools_swap.py <worktree root>
import io, re, sys, tokenize

ROOT = sys.argv[1]
WORD = re.compile(r"(?<![\w.\-/{'\"])(laws?|Laws?)(?![\w\-}/]|\.\w)")
SW = {'law': 'theorem', 'laws': 'theorems', 'Law': 'Theorem', 'Laws': 'Theorems'}
KEEP_BEFORE = re.compile(r"(Goodhart(\\?'|’)s |Campbell(\\?'|’)s |Zipf(\\?'|’)s )$")


def swap_text(s):
    def f(m):
        if KEEP_BEFORE.search(s[:m.start()]): return m.group(0)
        return SW[m.group(1)]
    return WORD.sub(f, s)


def literal_parts(body, is_f):
    """(start, end) spans of a string body that are literal text (outside an f-string's {...})."""
    if not is_f: return [(0, len(body))]
    out, i, a, depth = [], 0, 0, 0
    while i < len(body):
        ch = body[i]
        if depth == 0:
            if ch == '{' and body[i + 1:i + 2] == '{': i += 2; continue
            if ch == '}' and body[i + 1:i + 2] == '}': i += 2; continue
            if ch == '{':
                out.append((a, i)); depth = 1
        else:
            if ch == '{': depth += 1
            elif ch == '}':
                depth -= 1
                if depth == 0: a = i + 1
        i += 1
    if depth == 0: out.append((a, len(body)))
    return out


def py(path):
    src = open(path, encoding='utf-8').read()
    lines = src.split('\n')
    offs, n = [], 0
    for l in lines:
        offs.append(n); n += len(l) + 1
    edits = []
    for tok in tokenize.generate_tokens(io.StringIO(src).readline):
        if tok.type not in (tokenize.STRING, tokenize.COMMENT): continue
        a = offs[tok.start[0] - 1] + tok.start[1]; b = offs[tok.end[0] - 1] + tok.end[1]
        text = src[a:b]
        if tok.type == tokenize.COMMENT:
            new = swap_text(text)
        else:
            m = re.match(r"([A-Za-z]*)('''|\"\"\"|'|\")", text)
            pre, q = m.group(1), m.group(2)
            body = text[len(pre) + len(q):len(text) - len(q)]
            if re.fullmatch(r'[A-Za-z_\-]+', body): continue  # a bare key or id
            parts, out, at = literal_parts(body, 'f' in pre.lower()), '', 0
            for x, y in parts:
                out += body[at:x] + swap_text(body[x:y]); at = y
            out += body[at:]
            new = pre + q + out + q
        if new != text: edits.append((a, b, new))
    for a, b, new in sorted(edits, reverse=True):
        src = src[:a] + new + src[b:]
    open(path, 'w', encoding='utf-8').write(src)
    return len(edits)


HTML_KEEP = re.compile(r"\{\{.*?\}\}|\$\{(?:[^{}]|\{[^{}]*\})*\}")


def html(path, only_lines):
    lines = open(path, encoding='utf-8').read().split('\n')
    n = 0
    for k in only_lines:
        s = lines[k - 1]
        out, at = '', 0
        for m in HTML_KEEP.finditer(s):
            out += swap_text(s[at:m.start()]) + m.group(0); at = m.end()
        out += swap_text(s[at:])
        if out != s: lines[k - 1] = out; n += 1
    open(path, 'w', encoding='utf-8').write('\n'.join(lines))
    return n


if __name__ == '__main__':
    T = ROOT + '/tools/research/'
    print('map_sheet.py', py(T + 'map_sheet.py'), 'tokens')
    print('the_map.py', py(T + 'the_map.py'), 'tokens')
    print('map_sheet.html', html(T + 'map_sheet.html', [183, 413]), 'lines')
    print('the_map.html', html(T + 'the_map.html', [94, 95, 96, 109, 116, 118, 119, 121, 132, 149, 150, 155, 157, 161, 196, 206, 207, 209, 210, 218, 225, 238, 241, 251, 255, 269, 288]), 'lines')
