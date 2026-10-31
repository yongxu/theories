#!/usr/bin/env python3
"""Words, characters and reading minutes of whole files, by the counting of AJ4's layer measure
(aj4-alignment-readers, commit 33f5c4ebd): visible prose only, so code blocks, comments, link
targets, anchors, note markers and Quote/Source prefixes are not counted. English is counted in
words, Chinese in characters; a budget is in words, a Chinese character counting half a word, and a
time is given at 100 to 130 words, or 200 to 260 characters, a minute.

    python3 -B measure.py FILE [FILE ...]
"""
import re
import sys


def visible(s):
    s = re.sub(r'```.*?```', '', s, flags=re.S)
    s = re.sub(r'<!--.*?-->', '', s, flags=re.S)
    s = re.sub(r'\]\([^)]*\)', ']', s)
    s = re.sub(r'<a id="[^"]*"></a>|<sup>.*?</sup>', '', s)
    return re.sub(r'(Quote|Source)\s*\[[^\]]*\]\s*:\s*', '', s)


def count(s):
    v = visible(s)
    return len(re.findall(r"[A-Za-z0-9][A-Za-z0-9'’\-.]*", v)), len(re.findall(r'[一-鿿]', v))


def minutes(en, zh):
    return f'{en / 130 + zh / 260:.1f}–{en / 100 + zh / 200:.1f}'


for p in sys.argv[1:]:
    en, zh = count(open(p, encoding='utf-8').read())
    print(f'{en:6d} words {zh:6d} chars  {en + zh / 2:8.0f} budget-words  {minutes(en, zh)} min  {p}')
