#!/usr/bin/env python3
# AI-written, 13 November 2026 (WM2, second part). The stated reading times that follow the changed pages, set to the
# times the tools compute (tests/test_uses_pages.py: StatedTimes, OnePage). Each pair is (old, new, count).
#   times.py <root>
import os, sys
ROOT = sys.argv[1]
EDITS = {
    'theories/becoming/ONE-PAGE.md': [
        ('*Thirty-one to forty minutes to read.', '*Thirty-one to forty-one minutes to read.', 1),
        ('**The ethics** (thirteen to seventeen minutes)', '**The ethics** (fourteen to eighteen minutes)', 1),
    ],
    'theories/becoming/review/README.md': [
        ('says the whole in thirty-one to forty minutes;', 'says the whole in thirty-one to forty-one minutes;', 1),
    ],
    'theories/becoming/USES.md': [
        ('(fifty to sixty-five minutes at the most)', '(fifty-one to sixty-six minutes at the most)', 1),
        ('(eleven to fifteen minutes for the longest)', '(twelve to fifteen minutes for the longest)', 1),
    ],
    'theories/becoming/USES.zh.md': [
        ('*约三十六至四十七分钟读完。', '*约三十七至四十八分钟读完。', 1),
    ],
    'theories/becoming/ONE-PAGE.zh.md': [
        ('那张表与**伦理**（约十五至十九分钟）', '那张表与**伦理**（约十五至二十分钟）', 1),
    ],
}
for f, pairs in EDITS.items():
    p = os.path.join(ROOT, f); s = open(p, encoding='utf-8').read()
    for old, new, n in pairs:
        assert s.count(old) == n, (f, old[:50], s.count(old))
        s = s.replace(old, new)
    open(p, 'w', encoding='utf-8').write(s)
print('times set in', len(EDITS), 'files')
