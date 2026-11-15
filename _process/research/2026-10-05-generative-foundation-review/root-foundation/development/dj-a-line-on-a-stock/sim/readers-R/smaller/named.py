# AI-written (reader "smaller"), 16 November 2026. Read only.
# Every WayOfUnits.<name> and TurningInTime.<name> named in the tracked records, atlas, mapping, chapters, shared-laws: does it still exist in scratch?
import re, glob, os, sys
sys.path.insert(0, os.path.dirname(__file__))
from compare import decls, PKG, SCR, R
srcs = [R + 'theories/becoming/results/data/shared-laws.json'] \
    + glob.glob(R + 'theories/becoming/results/records/**/*', recursive=True) \
    + glob.glob(R + 'theories/becoming/results/atlas/entries/**/*', recursive=True) \
    + [R + '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aa-attractor-atlas/six/mapping.json'] \
    + glob.glob(R + 'theories/becoming/chapters/**/*', recursive=True)
srcs = [p for p in srcs if os.path.isfile(p)]
for mod in ['WayOfUnits', 'TurningInTime']:
    d, order, raw = decls(SCR + 'Becoming/' + mod + '.lean')
    have = {n.split('Becoming.')[-1] for n in order}
    named = {}
    for p in srcs:
        t = open(p, encoding='utf-8', errors='replace').read()
        for m in re.finditer(r'(?<![\w.])' + mod + r"\.([A-Za-z_][\w'₁₂]*(?:\.[A-Za-z_][\w'₁₂]*)*)", t):
            named.setdefault(mod + '.' + m.group(1), set()).add(p.replace(R, ''))
    missing = {n: fs for n, fs in named.items() if n not in have and n.rsplit('.', 1)[0] not in have}
    print(mod, 'names named in tracked records etc.:', len(named), '; not a declaration of the scratch file:', len(missing))
    for n, fs in sorted(missing.items()):
        print('   ', n, sorted(fs)[:3])
