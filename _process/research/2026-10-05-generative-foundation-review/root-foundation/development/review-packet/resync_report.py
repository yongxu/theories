#!/usr/bin/env python3
"""What a dossier must be re-read against: what changed around its citations since it was last synced.

check_dossiers.py proves a quotation still occurs. It cannot see that the paragraph around it changed, or that a
section the dossier points to now says something else: the failure the 25 October cold read named (F3). This lists,
item by item, every quotation whose paragraph changed since PIN and every linked section that changed, as the changed
spans only, each shown once and a long one cut, and every linked file or folder that changed or is new, so the re-sync
reads those and opens the chapter for the rest. Whatever the summary counts gets a line: a change shown once still gets
its own line wherever else it is cited, and an anchor it cannot follow is listed to be read by hand.

usage: python3 -B resync_report.py PIN DOSSIER.md [--out FILE]    (run from the repository root)
"""
import collections, difflib, re, subprocess, sys
from pathlib import Path
from urllib.parse import unquote

sys.path.insert(0, str(Path(__file__).resolve().parents[6]))
from tools.research.moves import code_mask, github_slug

QUOTE = re.compile(r'(?:引|Quote)\s*[〔\[]([^〕\]]+)[〕\]]\s*[：:]\s*[「"“]([^」"”]+)[」"”]')
LINK = re.compile(r'\]\(([^)#\s]+\.md)#([^)\s]+)\)')
ITEM = re.compile(r'^#{2,3} ((?:[A-Z]-\d+|[A-Z]\d+)\b.*|.*)$', re.M)
NUMBERED = re.compile(r'[A-Z]-?\d+\b')
FILE_LINK = re.compile(r'\]\((?![A-Za-z][\w+.-]*:)([^)#\s]+)(#[^)\s]*)?\)')  # any file or folder; a URL is none
WHOLE, NEW_FILE, GONE = ('whole file changed: read what the link is for', 'file new since the pin: read what the link is for',
                         'linked file gone since the pin')
SKIP = ('sources/', '_process/history', 'theories/becoming/history/')  # fixed texts: nothing moves under them


def squash(s):
    return re.sub(r'\s+', '', s)


def plain(s):
    s = re.sub(r'-\{([^{}]*)\}-', r'\1', s)
    return re.sub(r'\[\[(?:[^\]|]*\|)?([^\]]*)\]\]', r'\1', s)


def at(rev, path, cache={}):
    if (rev, path) not in cache:
        r = subprocess.run(['git', 'show', f'{rev}:{path}'], capture_output=True, encoding='utf-8', errors='replace')
        text = r.stdout if r.returncode == 0 else None
        if text and text.startswith(f'tree {rev}:'):  # a folder: what is in it, by content
            text = subprocess.run(['git', 'ls-tree', '-r', rev, '--', path], capture_output=True, encoding='utf-8').stdout
        cache[(rev, path)] = text
    return cache[(rev, path)]


def diffstat(pin, path):
    r = subprocess.run(['git', 'diff', '--shortstat', pin, 'HEAD', '--', path], capture_output=True, encoding='utf-8')
    return r.stdout.strip()


def blocks(text):
    return [b for b in re.split(r'\n\s*\n', text) if b.strip()]


def block_with(text, part):
    for b in blocks(text):
        if part in squash(plain(b)):
            return b
    return None


def heading_at(text, anchor):
    """Where the heading with this implicit anchor starts, read as the link gate reads it (-1, -2 for repeats)."""
    wanted, counts = unquote(anchor), {}
    for m in re.finditer(r'^#{1,6}[ \t]+.*$', code_mask(text), re.M):
        slug = github_slug(re.sub(r'^#+[ \t]+|[ \t]+#+[ \t]*$', '', text[m.start():m.end()]))
        n = counts.get(slug, 0)
        counts[slug] = n + 1
        if (f'{slug}-{n}' if n else slug) in (wanted, wanted.lower()):
            return m.start()
    return None


def section(text, anchor):
    """The text from <a id="anchor">, or the heading it names, to the next heading of the same or a higher level."""
    m = re.search(r'<a id="' + re.escape(anchor) + r'"></a>', text)
    start = m.end() if m else heading_at(text, anchor)
    if start is None:
        return None
    rest = text[start:]
    h = re.search(r'^(#+) ', rest, re.M)
    if not h or rest[:h.start()].strip():
        # an anchor inside a section: to the next heading of any level
        n = re.search(r'^#+ ', rest, re.M)
        return rest[:n.start()] if n else rest
    level = len(h.group(1))
    n = re.search(r'^#{1,' + str(level) + r'} ', rest[h.end():], re.M)
    return rest[:h.end() + n.start()] if n else rest


def cut(s, most=500):
    return s if len(s) <= most else f'{s[:most]} … ({len(s) - most} more characters: read the chapter)'


def spans(old, new, ctx=45):
    """The changed words only, with a little context: `…kept [-was-]{+now+} kept…`."""
    tok = lambda s: re.findall(r'\w+|\s+|[^\w\s]', s)
    a, b = tok(old), tok(new)
    sm = difflib.SequenceMatcher(None, a, b, autojunk=False)
    out = []
    for tag, i1, i2, j1, j2 in sm.get_opcodes():
        if tag == 'equal':
            continue
        before = ''.join(a[max(0, i1 - 24):i1])[-ctx:]
        after = ''.join(a[i2:i2 + 24])[:ctx]
        was, now = ''.join(a[i1:i2]).strip(), ''.join(b[j1:j2]).strip()
        if not was and not now:
            continue
        was, now = cut(was), cut(now)
        out.append(f'…{before}' + (f'[-{was}-]' if was else '') + (f'{{+{now}+}}' if now else '') + f'{after}…')
    return out


def changed_blocks(old, new):
    a, b = blocks(old), blocks(new)
    sm = difflib.SequenceMatcher(None, [squash(x) for x in a], [squash(x) for x in b], autojunk=False)
    return [(a[i1:i2], b[j1:j2]) for tag, i1, i2, j1, j2 in sm.get_opcodes() if tag != 'equal']


def main():
    args = [a for a in sys.argv[1:] if a != '--out']
    pin, dossier = args[0], Path(args[1])
    out = Path(sys.argv[sys.argv.index('--out') + 1]) if '--out' in sys.argv else None
    if out:
        args = args[:2]
    body = dossier.read_text(encoding='utf-8')
    heads = [(m.start(), m.group(1)) for m in ITEM.finditer(body)]

    def item_at(pos):
        cur = 'front'
        for s, h in heads:
            if s > pos:
                break
            cur = h
        return cur[:60]

    q_total = q_fixed = q_changed = q_new = 0
    report, items = {}, set()
    for m in QUOTE.finditer(body):
        ref, quote = m.group(1).split('#')[0].strip(), m.group(2)
        q_total += 1
        if ref.startswith(SKIP):
            q_fixed += 1
            continue
        part = next((squash(x) for x in re.split(r'……|\.\.\.|…', quote) if squash(x)), '')
        new, old = at('HEAD', ref), at(pin, ref)
        if new is None:
            continue
        bn = block_with(new, part)
        bo = block_with(old, part) if old else None
        if bo is None:
            q_new += 1
            report.setdefault(item_at(m.start()), []).append(('quote new since pin', ref, quote[:50], '', bn or ''))
            items.add(item_at(m.start()))
        elif squash(bo) != squash(bn or ''):
            q_changed += 1
            report.setdefault(item_at(m.start()), []).append(('paragraph changed', ref, quote[:50], bo, bn or ''))
            items.add(item_at(m.start()))
    l_total = l_changed = l_missing = 0
    seen = set()
    for m in LINK.finditer(body):
        rel, anchor = m.group(1), m.group(2)
        ref = str((dossier.parent / rel).resolve().relative_to(Path.cwd().resolve()))
        if ref.startswith(SKIP) or (ref, anchor, item_at(m.start())) in seen:
            continue
        seen.add((ref, anchor, item_at(m.start())))
        l_total += 1
        new, old = at('HEAD', ref), at(pin, ref)
        sn, so = section(new or '', anchor), section(old or '', anchor)
        if sn is None:
            l_missing += 1
            items.add(item_at(m.start()))
            report.setdefault(item_at(m.start()), []).append(('anchor not found: read this one by hand', ref, anchor, '', ''))
            continue
        if so is None:
            report.setdefault(item_at(m.start()), []).append(('section new since pin', ref, anchor, '', sn[:600]))
            l_changed += 1
            items.add(item_at(m.start()))
        elif squash(so) != squash(sn):
            l_changed += 1
            items.add(item_at(m.start()))
            for a, b in changed_blocks(so, sn):
                report.setdefault(item_at(m.start()), []).append(('section changed', ref, anchor, '\n\n'.join(a), '\n\n'.join(b)))
    whole, seen = {}, set()
    for m in FILE_LINK.finditer(code_mask(body)):
        ref = str((dossier.parent / m.group(1)).resolve().relative_to(Path.cwd().resolve()))
        new, old = at('HEAD', ref), at(pin, ref)
        if (m.group(1).endswith('.md') and m.group(2)) or ref.startswith(SKIP) or (new is None and old is None):
            continue  # a linked section, read above; a fixed text; no file there, which the link gate answers for
        whole[ref] = (GONE if new is None else NEW_FILE if old is None else WHOLE if squash(old) != squash(new) else None)
        if whole[ref] and (ref, item_at(m.start())) not in seen:  # each item that links it, not only the first
            seen.add((ref, item_at(m.start())))
            items.add(item_at(m.start()))
            report.setdefault(item_at(m.start()), []).append((whole[ref], ref, diffstat(pin, ref), '', ''))
    files = collections.Counter(whole.values())
    numbered = {h for _, h in heads if NUMBERED.match(h)}
    flagged = {h[:60] for h in items}
    n_flagged = sum(1 for h in flagged if NUMBERED.match(h))
    print(f'{dossier.name} since {pin}: quotes {q_total} ({q_fixed} of fixed texts): {q_changed} paragraphs changed, {q_new} new; '
          f'linked sections {l_total}: {l_changed} changed, {l_missing} anchors not found; '
          f'linked files {len(whole)}: {files[WHOLE]} changed, {files[NEW_FILE]} new since the pin, {files[GONE]} gone; '
          f'items to re-read {n_flagged} of {len(numbered)}, and {len(flagged) - n_flagged} other parts')
    # results new since the pin in the chapters this dossier cites most: is each carried or rightly left out?
    cited = {}
    for m in QUOTE.finditer(body):
        r = m.group(1).split('#')[0].strip()
        if '/chapters/' in r:
            cited[r] = cited.get(r, 0) + 1
    for m in LINK.finditer(body):
        r = str((dossier.parent / m.group(1)).resolve().relative_to(Path.cwd().resolve()))
        if '/chapters/' in r:
            cited[r] = cited.get(r, 0) + 1
    fresh = []
    for r, n in sorted(cited.items(), key=lambda x: -x[1]):
        if n < 3:
            continue
        new, old = at('HEAD', r), at(pin, r)
        if not new or not old:
            continue
        for a in re.findall(r'<a id="(r-[^"]+)"></a>', new):
            if f'"{a}"' not in old and a not in body:
                fresh.append((r.rsplit('/', 1)[-1], a))
    print(f'   results new since the pin in its main chapters, not linked in it: {len(fresh)}')
    if out:
        lines = [f'# {dossier.name}: what changed around its citations since {pin}\n']
        first = {}
        for item, rows in report.items():
            lines.append(f'\n## {item}\n')
            for kind, ref, what, old, new in rows:
                key = (squash(old), squash(new)) if old or new else (ref, what)  # a row with no text: by what it points to
                name = ref.rsplit('/', 1)[-1]
                if key in first:
                    where = 'as above' if first[key] == item else f'as under {first[key]}'
                    lines.append(f'- **{kind}**, {name} ({what}): {where}')
                    continue
                first[key] = item
                lines.append(f'- **{kind}**, {name} ({what}):')
                shown = spans(old, new)
                lines += [f'  - {s}' for s in shown[:12]]
                if len(shown) > 12:
                    lines.append(f'  - … and {len(shown) - 12} more changes here: read the chapter')
        lines.append('\n## Results new since the pin, not linked in the dossier\n')
        lines += [f'- {r}: `{a}`' for r, a in fresh]
        out.write_text('\n'.join(lines) + '\n', encoding='utf-8')


if __name__ == '__main__':
    main()
