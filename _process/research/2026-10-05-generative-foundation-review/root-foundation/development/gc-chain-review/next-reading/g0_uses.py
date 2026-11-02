#!/usr/bin/env python3
"""GC4: the per-use list of G0 in the chain's entries, with what was decided for each. Run on the data as it stood before
apply_next_reading.py, for instance `git show <rev>:theories/becoming/results/data/generativity-chain.json > before.json`.
It counts the claim, scope and connection fields of the entries. Link paths and the key (the data's opening scope) are not uses
in entries. Uses set in backticks name the Lean `G0` under its present name, and are counted apart. The decided column is by
entry, as the section's test is, except M20's two rows; C19's scope rows are negatives, what was not proved, within that route.
usage: python3 -B g0_uses.py before.json > g0-uses.tsv"""
import json
import re
import sys
from collections import Counter

USE = re.compile(r'(?<![A-Za-z0-9`])G0(?![A-Za-z0-9`])')
LEAN = re.compile(r'`G0`')
FIELDS = ('claim_en', 'claim_zh', 'scope_en', 'scope_zh', 'connection_en', 'connection_zh')
DECIDED = {
    'C14': 'kept: reports a disclosure',
    'C18': 'kept: what the Lean does not give from G0 alone',
    'C19': 'kept: scoped to the G0 route',
    'C20': 'kept: dated in the sentence',
    'C26': "kept: a route's completion at its scope",
    'F08': 'kept: its Lean form of that time, with its own sentence that the route is not the current result',
    'F14': 'changed: names the route then taken',
    'M25': 'changed: names the route then taken',
    'C23': 'changed: names the route then taken',
    'M21': "kept: the entry's scope sentence is the note",
}
NOTE = 'kept: the entry carries the status clause'
M20_CHANGED = ('G0 retains its folded', 'G0 沿用折入')


def main():
    data = json.load(open(sys.argv[1]))
    uses = Counter()
    lean = Counter()
    print('entry\tfield\tdecided\twindow')
    for section in data['sections']:
        for e in section['entries']:
            for field in FIELDS:
                text = e.get(field, '')
                lean[e['id']] += len(LEAN.findall(text))
                for m in USE.finditer(text):
                    uses[field[-2:]] += 1
                    uses['all'] += 1
                    uses[e['id']] += 0
                    window = text[max(0, m.start() - 60):m.end() + 60].replace('\t', ' ').replace('\n', ' ')
                    decided = DECIDED.get(e['id'], NOTE)
                    if any(text[m.start():m.start() + len(s)] == s for s in M20_CHANGED):
                        decided = 'changed: went against the status clause beside it'
                    print(f"{e['id']}\t{field}\t{decided}\t{window}")
    entries = len([k for k in uses if k not in ('all', 'en', 'zh')])
    print(f"# uses {uses['all']} (en {uses['en']}, zh {uses['zh']}) in {entries} entries; "
          f"naming the Lean `G0`: {sum(lean.values())} in {len([k for k, v in lean.items() if v])} entries", file=sys.stderr)


if __name__ == '__main__':
    main()
