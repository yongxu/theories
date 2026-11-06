#!/usr/bin/env python3
"""Correct nine live places that give ranking to C alone, the error LM1 corrected elsewhere, found by CX's second round.

usage: python3 -B apply_ranking.py [--dry-run]

07 §4 says that a ranking of courses needs C or a premise in its place: C gives order, and an order rising with one's
own continuation ranks one case with no C. LM1 corrected thirteen records' "ranking needs C", searching by those words.
Two other wordings of the same claim stood:
- 05's D65 label, "any ranking is C's";
- eight records' non-implication line, "ranking goes through the comparison C" (排序经由比较 C).
The minimal change keeps each sentence and adds what 07 §4 adds, in LM1's words. Each record takes a history note.
Every replacement must match exactly once, or nothing is written.
"""
import argparse
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = next(p for p in HERE.parents if (p / 'AGENTS.md').is_file())
RECORDS = ['confined-rise-within-a-whole', 'fixation-with-selection', 'groups-formed-by-descent', 'mutation-and-the-balance-it-sets',
           'selection-among-groups-by-ending', 'selection-with-returns-to-groupmates', 'selection-within-and-among-groups', 'the-breeding-value']
EDITS = [('theories/becoming/chapters/05-COLLECTIVES.md',
          '**Reading** [AI reading, D65; any ranking is C\'s, under the two premises of 07].',
          '**Reading** [AI reading, D65; a ranking needs C or a premise in its place, under 07\'s premises].')]
for r in RECORDS:
    EDITS.append((f'theories/becoming/results/records/{r}.json', 'ranking goes through the comparison C', 'ranking goes through the comparison C or a premise in its place'))
    EDITS.append((f'theories/becoming/results/records/{r}.json', '排序经由比较 C', '排序经由比较 C 或代替它的前提'))
NOTE = {'en': '7 November 2026, CX: this said ranking goes through the comparison C, where a ranking of courses needs C or a premise in its place '
              '(07 §4), the correction LM1 made in other records; corrected. No law, premise or proof changed.',
        'zh': '2026年11月7日，CX：此处谓排序经由比较 C，而对进程的排序需要 C 或代替它的前提（07 §4），即 LM1 在其他记录所作之更正；已更正。诸律、前提与证明皆不变。'}


def main(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument('--dry-run', action='store_true')
    args = parser.parse_args(argv)
    texts, problems = {}, []
    for path, old, new in EDITS:
        text = texts.setdefault(path, (ROOT / path).read_text(encoding='utf-8'))
        if text.count(old) != 1:
            problems.append(f'{path}: {text.count(old)} occurrences of {old!r}')
            continue
        texts[path] = text.replace(old, new)
    for r in RECORDS:
        path = f'theories/becoming/results/records/{r}.json'
        data = json.loads(texts[path])
        data['history'].append(NOTE)
        original = (ROOT / path).read_text(encoding='utf-8')
        if json.dumps(json.loads(original), ensure_ascii=False, indent=2) + '\n' != original:
            problems.append(f'{path}: not in the indent-2 form; would reformat')
        texts[path] = json.dumps(data, ensure_ascii=False, indent=2) + '\n'
    if problems:
        print('\n'.join(problems))
        return 1
    if not args.dry_run:
        for path, text in texts.items():
            (ROOT / path).write_text(text, encoding='utf-8')
    print(f'{len(EDITS)} edits in {len(texts)} files; a history note in {len(RECORDS)} records')
    return 0


if __name__ == '__main__':
    sys.exit(main())
