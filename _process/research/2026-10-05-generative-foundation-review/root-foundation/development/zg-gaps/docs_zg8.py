#!/usr/bin/env python3
"""ZG8 module text: for each module that gained laws, a bullet in its header, a sentence in its package-root
entry and in its checker scope, and a clause in its README rows (EN, ZH). Each anchor must match once.
usage (from the checkout root): python3 -B docs_zg8.py"""
import re
import textwrap
from pathlib import Path

PKG = Path('experiments/integrated-correction/general-framework/generative-basis/lean/becoming')
D = {
 'Transmission': ("**Forming anew, necessary and sufficient.** A dependence forms anew at a descent (`Web.NewAt`: the descendant holds it, the giver did not) exactly where inheritance fails, the giver's dependence stable (`Web.inheritsAt_iff_not_new`), and, depending and drawing coinciding at the giver, exactly where the descendant depends on what its giver did not draw on (`Web.new_iff_undrawn`). Inheritance gives the drawing reading at a descent exactly where the giver draws on what it holds and passes on (`Web.drawn_necessary_iff`), so the reading of drawing is inheritance with the givers drawing what they pass on (`Flow.PassesDrawn`, `Flow.dependsOnDrawn_iff`), the necessary half of `inherits_of_drawn`; with depending and drawing coinciding, inheritance, the reading of drawing and no descendant depending on what its giver did not draw on are one (`Flow.inherits_iff_none_undrawn`).",
   "A dependence forms anew exactly where the descendant depends on what its giver did not draw on; the reading of drawing is inheritance with the givers drawing what they pass on.",
   "forming anew, necessary and sufficient (`Web.NewAt`, `Web.inheritsAt_iff_not_new`, `Web.new_iff_undrawn`, `Web.drawn_necessary_iff`, `Flow.PassesDrawn`, `Flow.dependsOnDrawn_iff`, `Flow.inherits_iff_none_undrawn`)",
   "新结之依存，充要（`Web.NewAt`、`Web.inheritsAt_iff_not_new`、`Web.new_iff_undrawn`、`Web.drawn_necessary_iff`、`Flow.PassesDrawn`、`Flow.dependsOnDrawn_iff`、`Flow.inherits_iff_none_undrawn`）"),
}

def wrap(text, first, rest, width=100):
    lines = textwrap.wrap(text, width=width - len(rest), break_long_words=False, break_on_hyphens=False)
    return first + lines[0] + '\n' + ''.join(rest + l + '\n' for l in lines[1:])

root = (PKG / 'Becoming.lean').read_text(encoding='utf-8')
chk = (PKG / 'check_becoming.py').read_text(encoding='utf-8')
rd = (PKG / 'README.md').read_text(encoding='utf-8')
zh = (PKG / 'README.zh.md').read_text(encoding='utf-8')
missing = []
for mod, (head, rootline, readme, readme_zh) in D.items():
    p = PKG / 'Becoming' / f'{mod}.lean'
    s = p.read_text(encoding='utf-8')
    i = s.index('-/')
    s = s[:i].rstrip('\n') + '\n' + wrap(head, '* ', '  ') + s[i:]
    p.write_text(s, encoding='utf-8')
    # root entry: append before the next bullet
    start = root.index(f'* `Becoming.{mod}` (')
    nxt = root.index('\n* `Becoming.', start + 1)
    entry = root[start:nxt].rstrip('\n')
    new_entry = entry + '\n' + wrap(rootline, '  ', '  ')
    root = root[:start] + new_entry.rstrip('\n') + root[nxt:]
    # checker scope
    m = re.search(rf'^    "{mod}: ', chk, re.M)
    if m:
        after = re.search(r'^    "[A-Z][A-Za-z]+: ', chk[m.end():], re.M)
        pos = m.end() + after.start()
        prev_line_end = chk.rindex('\n', 0, pos - 1)
        assert chk[pos - 3:pos - 1] == ' "', (mod, chk[pos - 6:pos])
        chk = chk[:pos] + f'    "{rootline} "\n' + chk[pos:]
    else:
        missing.append(('scope', mod))
    # READMEs
    for name, text, clause in (('README.md', rd, readme), ('README.zh.md', zh, readme_zh)):
        key = f'[`Becoming.{mod}`](Becoming/{mod}.lean) |'
        lines = text.split('\n')
        hits = [k for k, l in enumerate(lines) if key in l]
        if len(hits) != 1:
            missing.append((name, mod, len(hits)))
            continue
        l = lines[hits[0]]
        assert l.endswith(' |'), (name, mod)
        sep = '；' if name == 'README.zh.md' else '; '
        lines[hits[0]] = l[:-2] + sep + clause + ' |'
        if name == 'README.md':
            rd = '\n'.join(lines)
        else:
            zh = '\n'.join(lines)
(PKG / 'Becoming.lean').write_text(root, encoding='utf-8')
(PKG / 'check_becoming.py').write_text(chk, encoding='utf-8')
(PKG / 'README.md').write_text(rd, encoding='utf-8')
(PKG / 'README.zh.md').write_text(zh, encoding='utf-8')
print('missing', missing)
