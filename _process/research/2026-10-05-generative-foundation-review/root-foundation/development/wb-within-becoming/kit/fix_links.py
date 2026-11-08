"""Make absolute and root-relative link targets in WB's note folder repository-relative.
Text is unchanged; only link targets move. A :line suffix moves into the link text's
target as nothing (lines drift); targets outside the repository become plain text."""
import os, re, sys
root = sys.argv[1]
folder = os.path.join(root, '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/wb-within-becoming')
prefixes = ['/Users/ren/theories/', '/Users/ren/tmp/wb/wt/', '/Users/ren/tmp/wb/homes/']
link = re.compile(r'\[([^\]]*)\]\(<?([^)>\s]+)>?\)')
changed = 0
for dp, _, fs in os.walk(folder):
    for f in fs:
        if not f.endswith('.md'): continue
        p = os.path.join(dp, f); s = open(p, encoding='utf-8').read()
        def fix(m):
            global changed
            text, tgt = m.group(1), m.group(2)
            new = None
            for pre in prefixes:
                if tgt.startswith(pre):
                    rest = tgt[len(pre):]
                    anchor = ''
                    if '#' in rest: rest, anchor = rest.split('#', 1); anchor = '#' + anchor
                    rest = re.sub(r':\d+(-\d+)?$', '', rest)
                    rel = os.path.relpath(os.path.join(root, rest), dp)
                    new = f'[{text}]({rel}{anchor})'
            if new is None and tgt.startswith('/'):
                new = f'{text} (`{tgt}`)'
            if new is None and (tgt.startswith('theories/') or tgt.startswith('_process/') or tgt.startswith('sources/')) and not os.path.exists(os.path.join(dp, tgt.split('#')[0])):
                rest = tgt; anchor = ''
                if '#' in rest: rest, anchor = rest.split('#', 1); anchor = '#' + anchor
                rel = os.path.relpath(os.path.join(root, rest), dp)
                new = f'[{text}]({rel}{anchor})'
            if new is None: return m.group(0)
            changed += 1
            return new
        t = link.sub(fix, s)
        if t != s: open(p, 'w', encoding='utf-8').write(t)
print('links changed', changed)

# reference-style definitions: [label]: /abs/path
ref = re.compile(r'^(\[[^\]]+\]):\s+<?(/[^\s>]+)>?(.*)$', re.M)
changed2 = 0
for dp, _, fs in os.walk(folder):
    for f in fs:
        if not f.endswith('.md'): continue
        p = os.path.join(dp, f); s = open(p, encoding='utf-8').read()
        def fixref(m):
            global changed2
            label, tgt, rest = m.group(1), m.group(2), m.group(3)
            for pre in prefixes:
                if tgt.startswith(pre):
                    r = tgt[len(pre):]; anchor = ''
                    if '#' in r: r, anchor = r.split('#', 1); anchor = '#' + anchor
                    r = re.sub(r':\d+(-\d+)?$', '', r)
                    changed2 += 1
                    return f'{label}: {os.path.relpath(os.path.join(root, r), dp)}{anchor}{rest}'
            return m.group(0)
        t = ref.sub(fixref, s)
        if t != s: open(p, 'w', encoding='utf-8').write(t)
print('reference links changed', changed2)
