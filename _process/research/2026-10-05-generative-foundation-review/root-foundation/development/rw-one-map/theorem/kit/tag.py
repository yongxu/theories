#!/usr/bin/env python3
# AI-written, 13 November 2026 (the map's part of WL: the account's proved statements are called theorems).
# Tags every use of "law" (English) and of 定律 / 律 (Chinese) in the prose fields of the map's data, and writes
# pieces for readers to sort. Reads the data from a checkout (default: the main checkout); changes nothing there.
#   tag.py [root]   -> run/<piece>.marked.md, run/cands.json, run/skipped.json, run/units.json
import json, os, re, sys, collections

ROOT = sys.argv[1] if len(sys.argv) > 1 else '/Users/ren/theories'
MAP = os.path.join(ROOT, 'theories/becoming/results/map')
RUN = '/Users/ren/theories/tmp/r7/sheet/wm/run'
FILES = ('sheet', 'passages', 'paths', 'laid', 'web', 'cards', 'cases')
# leaf strings under these keys are ids, Lean, enums or quoted Lean statements: not prose, never tagged
SKIP = {'id', 'row', 'band', 'as_of', 'rows', 'from', 'to', 'kind', 'laws', 'at', 'bands', 'tone', 'on', 'eg', 'case', 'test',
        'records', 'setting', 'how', 'agree', 'found_at', 'used', 'passage', 'dynamic', 'dynamics', 'role', 'lean', 'tie',
        'items', 'form', 'mark', 'frame', 'about_role', 'main_ifs', 'evidence', 'legend', 'state', 'from_thesis',
        'from_laws', 'step', 'failed_at', 'outcome', 'anchors', 'known_src', 'needs', 'ends', 'ties', 'frozen'}
EN = re.compile(r"(?<![\w.\-`«/])(laws?|Laws?|LAWS?)(?![\w`»/])")
ZH = re.compile(r'定律|(?<![定规紀纪法一旋韵戒自])律(?![师令法])')
PER_UNIT = 85


def walk(o, p=()):
    if isinstance(o, dict):
        for k, v in o.items():
            yield from walk(v, p + (k,))
    elif isinstance(o, list):
        for i, v in enumerate(o):
            yield from walk(v, p + (i,))
    elif isinstance(o, str):
        yield p, o


def last_key(p):
    return next(x for x in reversed(p) if not isinstance(x, int))


def ticks(s):
    """Ranges inside backticks."""
    out, i = [], 0
    while True:
        a = s.find('`', i)
        if a < 0: break
        b = s.find('`', a + 1)
        if b < 0: break
        out.append((a, b + 1)); i = b + 1
    return out


def uses(s):
    """(start, end, word, lang, skip reason or '') for every candidate in a string."""
    tk = ticks(s)
    out = []
    for m in EN.finditer(s):
        a, b = m.span(1)
        why = ''
        if any(x <= a < y for x, y in tk): why = 'in backticks'
        elif s[b:b + 1] == '.' and s[b + 1:b + 2].isalpha(): why = 'a qualified name'
        elif s[b:b + 1] == '-' and s[b + 1:b + 2].isalnum(): why = 'a hyphenated id'
        elif s[a - 1:a] == '_' or s[b:b + 1] == '_': why = 'an identifier'
        out.append((a, b, m.group(1), 'en', why))
    for m in ZH.finditer(s):
        a, b = m.span()
        why = 'in backticks' if any(x <= a < y for x, y in tk) else ''
        out.append((a, b, m.group(0), 'zh', why))
    return sorted(out)


def record_of(name, d, p):
    """The record a path belongs to: (key for grouping, heading, context lines)."""
    if name == 'cards' and p[0] == 'cards':
        c = d['cards'][p[1]]
        return ('cards', p[1]), 'card of the dynamic ' + c['dynamic'], [
            'In plain words: ' + c['plain_en'],
            'The Lean statements this card reads (its "laws" list): ' + ('; '.join(l['lean'].split('.')[-1] for l in c['laws']) or 'none')]
    if name == 'cases' and p[0] == 'cases':
        c = d['cases'][p[1]]
        return ('cases', p[1]), 'case of the test ' + c['test'], ['The case: ' + c['case_en']]
    if name == 'passages' and p[0] in ('passages', 'stays'):
        x = d[p[0]][p[1]]
        if p[0] == 'passages':
            return (p[0], p[1]), 'arrow %s > %s' % (x['from'], x['to']), [
                'How this arrow is known (kind): %s. Lean statements it names: %s' % (x['kind'], ', '.join(x.get('laws') or []) or 'none')]
        return (p[0], p[1]), 'what stays at ' + x['at'], ['Lean statements it names: ' + (', '.join(x.get('laws') or []) or 'none')]
    if name == 'paths' and p[0] == 'paths':
        x = d['paths'][p[1]]
        return ('paths', p[1]), 'path ' + x['id'], ['The path in a sentence: ' + x['lead_en'][:400]]
    if name == 'laid' and p[0] == 'tests':
        x = d['tests'][p[1]]
        return ('tests', p[1]), 'test laid on the map: ' + x['id'], ['The test in a line: ' + x['line_en']]
    if name == 'sheet' and p[0] == 'boxes':
        x = d['boxes'][p[1]]
        return ('boxes', p[1]), 'box ' + x['id'] + ' (' + x['en'] + ')', []
    return (p[0],), 'the file\'s ' + str(p[0]), []


def pair(p):
    """The path of the other language's field, or None."""
    k = last_key(p)
    i = max(j for j, x in enumerate(p) if x == k)
    for a, b in (('_en', '_zh'), ('_zh', '_en')):
        if k.endswith(a): return p[:i] + (k[:-len(a)] + b,) + p[i + 1:]
    if k in ('en', 'zh'): return p[:i] + ('zh' if k == 'en' else 'en',) + p[i + 1:]
    return None


def get(d, p):
    for x in p:
        try: d = d[x]
        except (KeyError, IndexError, TypeError): return None
    return d if isinstance(d, str) else None


def label(p):
    return '.'.join(str(x) for x in p[2:] if True) or str(p[-1])


def main():
    os.makedirs(RUN, exist_ok=True)
    cands, skipped, blocks = {}, [], []  # blocks: (file, heading, context, [(label, text marked or plain)], n tags)
    nid = 0
    for name in FILES:
        d = json.load(open(os.path.join(MAP, name + '.json'), encoding='utf-8'))
        groups = collections.OrderedDict()
        for p, s in walk(d):
            if last_key(p) in SKIP: continue
            us = uses(s)
            if not us: continue
            key, head, ctx = record_of(name, d, p)
            g = groups.setdefault(key, {'head': head, 'ctx': ctx, 'fields': []})
            marked, at, n = '', 0, 0
            for a, b, w, lang, why in us:
                if why:
                    skipped.append({'file': name, 'path': list(p), 'start': a, 'word': w, 'why': why, 'near': s[max(0, a - 40):b + 30]})
                    continue
                nid += 1; n += 1
                cands[nid] = {'file': name, 'path': list(p), 'start': a, 'end': b, 'word': w, 'lang': lang}
                marked += s[at:b] + '⟦%d⟧' % nid; at = b
            marked += s[at:]
            if not n: continue
            other = pair(p)
            g['fields'].append((label(p), marked, n, get(d, other) if other else None, label(other) if other else None,
                                [i for i in range(nid - n + 1, nid + 1)]))
        for key, g in groups.items():
            blocks.append((name, g))
    # pieces: consecutive blocks of one file up to PER_UNIT tags
    pieces, cur, cur_n, cur_file = [], [], 0, None
    for name, g in blocks:
        n = sum(f[2] for f in g['fields'])
        if cur and (name != cur_file or cur_n + n > PER_UNIT):
            pieces.append((cur_file, cur, cur_n)); cur, cur_n = [], 0
        cur.append(g); cur_n += n; cur_file = name
    if cur: pieces.append((cur_file, cur, cur_n))
    units, count = [], collections.Counter()
    for name, gs, n in pieces:
        count[name] += 1
        pid = '%s-%02d' % (name, count[name])
        out = ['# Piece %s: %d uses to sort, from theories/becoming/results/map/%s.json' % (pid, n, name), '']
        seen_pairs = set()
        for g in gs:
            out += ['=== ' + g['head']] + ['    (' + c + ')' for c in g['ctx']]
            for lab, marked, k, other, olab, ids in g['fields']:
                out.append('[%s] %s' % (lab, marked))
                for i in ids: cands[i]['piece'] = pid
                if other is not None and olab not in [f[0] for f in g['fields']] and (olab, other) not in seen_pairs:
                    out.append('    (the same field in the other language, for reference, not tagged: [%s] %s)' % (olab, other))
            out.append('')
        open(os.path.join(RUN, pid + '.marked.md'), 'w', encoding='utf-8').write('\n'.join(out))
        ids = [i for i, c in cands.items() if c.get('piece') == pid]
        units.append({'piece': pid, 'file': name, 'tags': n, 'first': min(ids), 'last': max(ids), 'chars': len('\n'.join(out))})
    json.dump({str(k): v for k, v in cands.items()}, open(os.path.join(RUN, 'cands.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=0)
    json.dump(skipped, open(os.path.join(RUN, 'skipped.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    json.dump(units, open(os.path.join(RUN, 'units.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    by = collections.Counter((c['file'], c['lang']) for c in cands.values())
    print('tags', nid, dict(sorted(by.items())))
    print('skipped', len(skipped), dict(collections.Counter((s['file'], s['why']) for s in skipped)))
    for u in units: print(' ', u['piece'], u['tags'], 'tags', u['chars'], 'chars')


if __name__ == '__main__':
    main()
