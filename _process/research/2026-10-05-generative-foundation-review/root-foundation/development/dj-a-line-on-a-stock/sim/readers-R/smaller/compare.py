# AI-written (reader "smaller"), 16 November 2026. Read only.
# Compares the tracked WayOfUnits.lean with the scratch copy, and looks for the removed names.
import re, glob, os, sys
R = '/Users/ren/theories/'
PKG = R + 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/'
SCR = R + 'tmp/r7/one-model/lean-scratch/'
KW = r'(?:@\[[^\]]*\]\s*)?(?:private\s+|protected\s+|noncomputable\s+)*(?:theorem|def|abbrev|instance|structure|inductive|lemma|class)\b'

def strip_comments(t):
    out = []; i = 0; depth = 0
    while i < len(t):
        if t.startswith('/-', i): depth += 1; i += 2; continue
        if t.startswith('-/', i) and depth > 0: depth -= 1; i += 2; continue
        if depth == 0:
            if t.startswith('--', i):
                j = t.find('\n', i)
                i = len(t) if j < 0 else j
                continue
            out.append(t[i])
        elif t[i] == '\n': out.append('\n')
        i += 1
    return ''.join(out)

def decls(path):
    raw = open(path).read()
    t = strip_comments(raw)
    lines = t.split('\n')
    cur = []; nsat = {}; starts = []
    for n, l in enumerate(lines):
        m = re.match(r'^namespace\s+(\S+)', l)
        if m: cur.append(m.group(1))
        m = re.match(r'^end\s+(\S+)', l)
        if m and cur and cur[-1] == m.group(1): cur.pop()
        nsat[n] = '.'.join(cur)
        if re.match(r'^' + KW, l): starts.append(n)
    res = {}; order = []
    for k, s in enumerate(starts):
        e = starts[k + 1] if k + 1 < len(starts) else len(lines)
        body = '\n'.join(lines[s:e])
        # cut trailing namespace/end/section/open lines
        body = re.split(r'\n(?:namespace|end|section|open|variable)\b', body)[0].rstrip()
        m = re.search(r':=|\n\s*\|| where\b', body)
        head = body[:m.start()] if m else body
        nm = re.match(r'^' + KW + r'\s+(\S+)', head)
        kind = re.search(r'(theorem|def|abbrev|instance|structure|inductive|lemma|class)\b', head).group(1)
        name = nsat[s] + '.' + (nm.group(1) if nm else '?')
        res[name] = dict(head=' '.join(head.split()), line=s + 1, body=' '.join(body.split()), kind=kind,
                         priv='private' in head.split(kind)[0])
        order.append(name)
    return res, order, raw

if __name__ == "__main__":
    a, oa, ra = decls(PKG + 'Becoming/WayOfUnits.lean')
    b, ob, rb = decls(SCR + 'Becoming/WayOfUnits.lean')
    print('lines tracked', ra.count('\n'), 'scratch', rb.count('\n'))
    print('decls tracked', len(a), 'scratch', len(b))
    kinds = lambda d: {k: sum(1 for v in d.values() if v['kind'] == k) for k in sorted(set(v['kind'] for v in d.values()))}
    print('kinds tracked', kinds(a)); print('kinds scratch', kinds(b))
    removed = [n for n in oa if n not in b]
    added = [n for n in ob if n not in a]
    print('\nREMOVED (%d):' % len(removed))
    for n in removed: print('  ', n, 'tracked line', a[n]['line'], a[n]['kind'], 'private' if a[n]['priv'] else '')
    print('\nADDED (%d):' % len(added))
    for n in added: print('  ', n, 'scratch line', b[n]['line'], b[n]['kind'])
    print('\nHEADERS CHANGED (kept names):', [n for n in oa if n in b and a[n]['head'] != b[n]['head']])
    print('order of kept names same:', [n for n in ob if n in a] == [n for n in oa if n in b])
    defs_changed = [n for n in oa if n in b and a[n]['kind'] in ('def', 'abbrev', 'structure', 'inductive', 'class') and a[n]['body'] != b[n]['body']]
    print('DEFINITIONS CHANGED:', defs_changed)
    print('kept defs:', len([n for n in oa if n in b and a[n]['kind'] in ('def', 'abbrev', 'structure', 'inductive', 'class')]))
    bc = [n for n in oa if n in b and a[n]['body'] != b[n]['body']]
    print('BODIES CHANGED (%d):' % len(bc))
    for n in bc: print('  ', n, a[n]['kind'], 'tracked line', a[n]['line'], 'scratch line', b[n]['line'])

    # where are the removed names named?
    srcs = [R + 'theories/becoming/results/data/shared-laws.json'] \
        + glob.glob(R + 'theories/becoming/results/records/**/*', recursive=True) \
        + glob.glob(R + 'theories/becoming/results/atlas/entries/**/*', recursive=True) \
        + [R + '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aa-attractor-atlas/six/mapping.json'] \
        + glob.glob(R + 'theories/becoming/chapters/**/*', recursive=True)
    srcs = [p for p in srcs if os.path.isfile(p)]
    text = {}
    for p in srcs:
        try: text[p] = open(p, encoding='utf-8', errors='replace').read()
        except Exception as e: print('unreadable', p, e)
    print('\nsearched files:', len(text))
    way_files = [p for p, t in text.items() if 'WayOfUnits' in t]
    print('files that mention WayOfUnits at all:', len(way_files))
    for p in way_files: print('   ', p.replace(R, ''))
    print('\nREMOVED NAMES in records/atlas/mapping/chapters/shared-laws:')
    for n in removed:
        short = n.split('.')[-1]
        q = [p for p, t in text.items() if re.search(r'WayOfUnits\.' + re.escape(short) + r"(?![\w'])", t)]
        # bare name in a file that also mentions WayOfUnits
        bare = [p for p in way_files if re.search(r'(?<![\w.])' + re.escape(short) + r"(?![\w'])", text[p])]
        anyb = [p for p, t in text.items() if re.search(r'(?<![\w.])' + re.escape(short) + r"(?![\w'])", t)]
        print('  %-22s qualified:%d  bare in a WayOfUnits-mentioning file:%d  bare anywhere:%d %s' % (
            short, len(q), len(bare), len(anyb), [p.replace(R, '')[-70:] for p in (q or bare or anyb)[:3]]))

    # uses by other modules of the package (tracked) and by the four scratch modules
    mods = glob.glob(PKG + 'Becoming/**/*.lean', recursive=True) + [PKG + 'Becoming.lean']
    scr = {os.path.basename(p): p for p in glob.glob(SCR + 'Becoming/*.lean')}
    print('\npackage lean files:', len(mods))
    wu_users = []
    for p in mods:
        if p.endswith('/WayOfUnits.lean'): continue
        t = strip_comments(open(p).read())
        if 'WayOfUnits' in t: wu_users.append(p)
    print('tracked modules whose CODE (comments stripped) mentions WayOfUnits:', [p.replace(PKG, '') for p in wu_users])
    for p in mods:
        if p.endswith('/WayOfUnits.lean'): continue
        raw = open(p).read()
        if 'WayOfUnits' in raw and p not in wu_users:
            print('   mentions WayOfUnits only in comments/docstrings:', p.replace(PKG, ''))
    print('\nREMOVED NAMES used in other package modules (code and docstrings):')
    for n in removed:
        short = n.split('.')[-1]
        hits = []
        for p in mods:
            if p.endswith('/WayOfUnits.lean'): continue
            raw = open(p).read()
            for m in re.finditer(r'WayOfUnits\.' + re.escape(short) + r"(?![\w'])", raw):
                hits.append((p.replace(PKG, ''), raw.count('\n', 0, m.start()) + 1))
        # in scratch files (all four), qualified; and bare inside scratch WayOfUnits
        shits = []
        for nm, p in scr.items():
            raw = open(p).read()
            pat = (r'(?<![\w.])' + re.escape(short) + r"(?![\w'])") if nm == 'WayOfUnits.lean' else (r'WayOfUnits\.' + re.escape(short) + r"(?![\w'])")
            for m in re.finditer(pat, raw):
                shits.append((nm, raw.count('\n', 0, m.start()) + 1))
        print('  %-22s tracked-other:%s  scratch:%s' % (short, hits, shits))
