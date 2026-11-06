#!/usr/bin/env python3
"""Apply the live-text corrections the crosswalk's readers flagged and the verifiers prepared, as amended by their second
reader (CORRECTIONS.md), and add a history note to each record whose wording changed.

usage: python3 -B apply_corrections.py [--dry-run]

Each edit replaces text that must occur exactly once in its file; on any miss nothing is written. Generated pages are
never edited here: the render writes them from the JSON and the chapters.
"""
import argparse
import glob
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = next(p for p in HERE.parents if (p / 'AGENTS.md').is_file())
DATE = '7 November 2026'
DATE_ZH = '2026年11月7日'

# The second reader's amendments, by (path, the verifier's old text): the replacement to use instead, or None to drop.
AMEND = {
    ('theories/becoming/review/PHILOSOPHY.md', 'Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "Monotonicity at the standpoint is C\'s premise relocated: weaker, still a premise." The chapter credits'):
        lambda new: new.replace(', deriving C from nothing:', ':').replace('Since 6 November 2026 the chapter says', 'Since 6 November 2026 the chapter states'),
    ('theories/becoming/review/ALIGNMENT.md', "Goodhart's and Campbell's laws (Manheim and Garrabrant 2018; Campbell 1979) describe informally a measure that keeps its standing after it stops measuring. T7 states that as a conjecture about a lock."):
        lambda new: new.replace('That the measure is then kept is the record\'s addition: Quote [theories/becoming/results/records/closed-capture.md]: "Goodhart (1975) says a measure made a target stops measuring; this states why it is kept: what keeps it reads the share it gives, not what it fails to measure."',
                                'That the measure is then kept is the record\'s addition: Quote [theories/becoming/results/records/closed-capture.md]: "this states why it is kept: what keeps it reads the share it gives, not what it fails to measure."'),
    ('theories/becoming/COLLECTIVE-DIRECTION.md', 'No institution is modelled on the spine; no field test'):
        lambda new: 'One kind of institution has one minimal model on the root [AI reading], a rule rebuilt from the members it limits ([05 §12](chapters/05-COLLECTIVES.md#r-a-rule-rebuilt-from-the-members-it-limits)), and no actual institution is shown to meet its hypotheses; no field test',
    ('theories/becoming/chapters/03-KNOWING.md', '**Theorem** (any type; finitely many sentences closed among themselves).'):
        lambda new: '**Theorem** (Kleene\'s three-valued sentences, a named model; finitely many closed among themselves).',
    ('theories/becoming/results/records/loss-read-in-time-by-the-others.json', 'and the threshold the tipping point of Schelling (1978) and Granovetter (1978).'):
        lambda new: 'and the threshold the tipping point of Schelling (1978) and Granovetter (1978), Granovetter\'s thresholds distributed where here there is one.',
}
# Restatements the verifiers named and left for an owner: the dossier quotes 08's and 03's old wording.
EXTRA = [
    ('theories/becoming/review/LOGIC.md', '| Double-negation elimination | reach without a path |',
     '| Double-negation elimination | reach, which needs a path, where only every separation from the seeds is refuted |'),
    ('theories/becoming/review/LOGIC.md', '- [this dossier, AI] 08\'s gloss of the double-negation row, Quote [theories/becoming/chapters/08-METHOD.md]: "reach without a path", misdescribes the law: its conclusion is reach, which carries a path; what needs the principle is the step from the absence of an invariant separation to such a path.',
     '- [this dossier, AI] 08\'s gloss of the double-negation row read "reach without a path" until 7 November 2026, which misdescribed the law: its conclusion is reach, which carries a path; what needs the principle is the step from the absence of an invariant separation to such a path. 08 now says so.'),
    ('theories/becoming/review/LOGIC.md', 'no type parameter occurs, though 03 labels it "any type"',
     'no type parameter occurs, and 03 labels it a named model (until 7 November 2026 "any type")'),
]
NOTE = {'en': f'{DATE}, CX: the correspondence corrected where a reader of the crosswalk found it wider than its source or its home (the crosswalk\'s live flags, checked at home); no law, premise or scope of this record changed.',
        'zh': f'{DATE_ZH}，CX：交叉对照之读者发现对应说得比其来源或本处更宽，于本处查实后更正；本记录之律、前提与范围均未变。'}


def main(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument('--dry-run', action='store_true')
    args = parser.parse_args(argv)
    edits = []
    for f in sorted(glob.glob(str(HERE / 'reads/verify-*.json'))):
        for flag in json.load(open(f, encoding='utf-8'))['flags']:
            if flag['verdict'] != 'holds':
                continue
            for e in flag.get('edits', []):
                new = e['new']
                amend = AMEND.get((e['path'], e['old']))
                if amend:
                    new = amend(new)
                edits.append((e['path'], e['old'], new))
    edits += EXTRA
    texts, problems = {}, []
    for path, old, new in edits:
        text = texts.setdefault(path, (ROOT / path).read_text(encoding='utf-8'))
        n = text.count(old)
        if n != 1:
            problems.append(f'{path}: {n} occurrences of {old[:80]!r}')
            continue
        texts[path] = text.replace(old, new)
    records = sorted(p for p in texts if p.startswith('theories/becoming/results/records/') and p.endswith('.json'))
    for path in records:
        data = json.loads(texts[path])
        data['history'].append(NOTE)
        texts[path] = json.dumps(data, ensure_ascii=False, indent=2) + '\n'
        original = (ROOT / path).read_text(encoding='utf-8')
        if json.dumps(json.loads(original), ensure_ascii=False, indent=2) + '\n' != original:
            problems.append(f'{path}: not in the indent-2 form; would reformat')
    if problems:
        print('\n'.join(problems))
        return 1
    if not args.dry_run:
        for path, text in texts.items():
            (ROOT / path).write_text(text, encoding='utf-8')
    print(f'{len(edits)} edits in {len(texts)} files; a history note in {len(records)} records')
    return 0


if __name__ == '__main__':
    sys.exit(main())
