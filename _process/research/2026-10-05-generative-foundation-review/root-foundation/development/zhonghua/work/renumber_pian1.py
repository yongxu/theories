"""Shift references to 篇一 條 一·二十一 … 一·二十六 by one, for text written before 文与文同 (WEN-1) was
inserted as 一·二十一 (board item WL). A reference preceded by 十 (十一·二十二) is in another part and is kept.

    python3 -I work/renumber_pian1.py FILE...      # rewrites each file in place, prints the count
"""
import re, sys

N = '一二三四五六七'
SHIFT = {'一·二十' + N[i]: '一·二十' + N[i + 1] for i in range(6)}
PAT = re.compile(r'(?<![十])一·二十[一二三四五六](?![一二三四五六七八九十])')


def renumber(s):
    return PAT.subn(lambda m: SHIFT[m.group(0)], s)


if __name__ == '__main__':
    for p in sys.argv[1:]:
        s, n = renumber(open(p, encoding='utf-8').read())
        open(p, 'w', encoding='utf-8').write(s)
        print(p, n)
