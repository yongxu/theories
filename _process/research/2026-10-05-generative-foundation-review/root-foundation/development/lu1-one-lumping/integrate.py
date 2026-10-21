#!/usr/bin/env python3
"""Join LU1 to the core package: copy the kit's Becoming.ClosedCapture in, extend its root doc bullet, its scope
text in check_becoming.py and its README rows (EN, ZH).
usage: python3 -B integrate.py   (LU1_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['LU1_ROOT']).resolve() if os.environ.get('LU1_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


target = PKG / 'Becoming' / 'ClosedCapture.lean'
assert 'loopPart' not in target.read_text(), 'already integrated'
shutil.copyfile(HERE / 'tree' / 'Becoming' / 'ClosedCapture.lean', target)

DOC_OLD = ('  stay alike in both, and the share\'s law joined with a step beyond runs exactly as the share\'s law\n'
           '  alone; so')
DOC_NEW = ('  stay alike in both, and the share\'s law joined with a step beyond runs exactly as the share\'s law\n'
           '  alone; this is the law of a part read alone (`IdentificationRuns`) on the two-level step: share,\n'
           '  rule and step count make sense by themselves along every schedule, and courses alike in share\n'
           '  and rule stay alike along every schedule, exactly where nothing beyond the share is read; so')
SCOPE_OLD = ('    "ClosedCapture: where neither the next share nor the rule read reads what lies beyond the share, "\n'
             '    "courses alike in share and rule stay alike in both whatever lies beyond, the share\'s law joined "\n')
SCOPE_NEW = ('    "ClosedCapture: where neither the next share nor the rule read reads what lies beyond the share, "\n'
             '    "courses alike in share and rule stay alike in both whatever lies beyond, and exactly then, along "\n'
             '    "every schedule, share, rule and step count read through themselves identify exactly the "\n'
             '    "configurations alike under the two-level step (IdentificationRuns\' law of a part read alone), "\n'
             '    "the share\'s law joined "\n')
README_OLD = ('courses alike in share and rule stay alike in both (`ClosedCapture.unread_course`, '
              '`ClosedCapture.reads_beyond_of_apart`)')
README_NEW = ('courses alike in share and rule stay alike in both (`ClosedCapture.unread_course`, '
              '`ClosedCapture.reads_beyond_of_apart`), exactly then along every schedule '
              '(`ClosedCapture.courses_alike_iff_unread`), the law of a part read alone on the two-level step: what the '
              'loop reads makes sense by itself exactly where nothing beyond the share is read '
              '(`ClosedCapture.identifiesAlike_iff_unread`, from `Law.now_identifiesAlike_iff_goAlike`)')
README_ZH_OLD = '份额与规则相同的进程在两者上始终相同（`ClosedCapture.unread_course`、`ClosedCapture.reads_beyond_of_apart`）'
README_ZH_NEW = ('份额与规则相同的进程在两者上始终相同（`ClosedCapture.unread_course`、`ClosedCapture.reads_beyond_of_apart`），'
                 '且对每种读步安排恰在此时如此（`ClosedCapture.courses_alike_iff_unread`）：这是“单独读一部分”之律在双层一步上的情形，'
                 '回路所读者恰在不读份额之外者时自身成立（`ClosedCapture.identifiesAlike_iff_unread`，出自 '
                 '`Law.now_identifiesAlike_iff_goAlike`）')

root = (PKG / 'Becoming.lean').read_text()
(PKG / 'Becoming.lean').write_text(once(root, DOC_OLD, DOC_NEW))
chk = (PKG / 'check_becoming.py').read_text()
(PKG / 'check_becoming.py').write_text(once(chk, SCOPE_OLD, SCOPE_NEW))
rd = (PKG / 'README.md').read_text()
(PKG / 'README.md').write_text(once(rd, README_OLD, README_NEW))
rz = (PKG / 'README.zh.md').read_text()
(PKG / 'README.zh.md').write_text(once(rz, README_ZH_OLD, README_ZH_NEW))
print('integrated')
