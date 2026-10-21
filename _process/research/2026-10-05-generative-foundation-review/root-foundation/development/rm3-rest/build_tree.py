#!/usr/bin/env python3
"""Build RM3's tree: LastChange with a law's run with a bounded mark coming to rest within the bound, and
RegimeMargin with where a run of the regime, or of an adjusting giving, comes to rest.
usage: python3 -B build_tree.py   (RM3_ROOT names the checkout to read, one whose LastChange and RegimeMargin are
RM2's; default the checkout holding this kit; RM3_BASE, a git ref of that checkout, reads them at that ref instead).
Writes tree/Becoming/LastChange.lean and tree/Becoming/RegimeMargin.lean."""
import os
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['RM3_ROOT']).resolve() if os.environ.get('RM3_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


def read(name):
    if os.environ.get('RM3_BASE'):
        rel = (PKG / 'Becoming' / f'{name}.lean').relative_to(ROOT)
        return subprocess.run(['git', '-C', str(ROOT), 'show', f"{os.environ['RM3_BASE']}:{rel}"], check=True,
                              capture_output=True, text=True).stdout
    return (PKG / 'Becoming' / f'{name}.lean').read_text(encoding='utf-8')


lc = read('LastChange')
assert 'section LawRuns' not in lc, 'already built'
END = '\nend LastChange\n'
lc = once(lc, END, '\n' + (HERE / 'lastchange_section.lean').read_text(encoding='utf-8') + END)
exec((HERE / 'lastchange_doc.py').read_text(encoding='utf-8'))
rm = read('RegimeMargin')
assert 'rises_to_rest' not in rm, 'already built'
rm = once(rm, 'import Becoming.Recurrence\n', 'import Becoming.Recurrence\nimport Becoming.Lasting\nimport Becoming.LastChange\nimport Becoming.Optimum\n')
RM_END = '\nend RegimeMargin\n'
rm = once(rm, RM_END, '\n' + (HERE / 'rest_section.lean').read_text(encoding='utf-8') + RM_END)
exec((HERE / 'regime_doc.py').read_text(encoding='utf-8'))
for name, text in [('LastChange', lc), ('RegimeMargin', rm)]:
    out = HERE / 'tree' / 'Becoming' / f'{name}.lean'
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(text, encoding='utf-8')
    print('wrote', out, len(text.splitlines()), 'lines')
