#!/usr/bin/env python3
"""OU7's section in WHAT-REMAINS, OU's owner's text (the note is theirs) with the landing's figures filled in, and
the release gate's item 4 marked met. Run in the landing worktree after post and board_ou7.py.

The figures come from the landing, not from this file: the study section N and the core receipt CORE as given, the
families from the record conditional-laws-of-the-corpus, GrammarLaws' counts from the receipt (every axiom report
empty), and F5's four counts from MV's data (central_reach), against HEAD's.
usage (from the checkout root): python3 -B what_remains_ou7.py CORE N"""
import json
import re
import subprocess
import sys
from pathlib import Path

NOTE = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/development/'
            'ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md')
RECEIPTS = Path('experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-checks')
MASTER = 'theories/becoming/results/data/master-laws.json'
RECORD = Path('theories/becoming/results/records/conditional-laws-of-the-corpus.json')
NEXT = '## What this note does not do'
ITEM4_END = 'That is what lets a reader check a law\'s hypotheses against a situation without reading the Lean.'
MET = ' **Met** with OU7 (see "OU7 landed" below).'
F5 = ('reaching the grammar', 'stated at a represented model', 'stated on its own carrier only', 'the rest')


def figures(core):
    v = json.loads((RECEIPTS / core / 'verification.json').read_text(encoding='utf-8'))
    bad = [(m['module'], n) for m in v['modules'] for n, a in m['axiom_dependencies'].items() if a]
    assert v['status'] == 'passed' and not bad, (v['status'], bad[:3])
    g = {m['module']: m for m in v['modules']}['Becoming.GrammarLaws']
    statement = json.loads(RECORD.read_text(encoding='utf-8'))['statement']['en']
    found = re.match(r"Of the corpus's (\d+) conditional units, (\d+) fall into (\d+) families of laws", statement)
    false_as_read = re.search(r'(\d+) laws false as read', statement)
    # OU's owner's text states 219 and six plainly; the record must say the same.
    assert found and found.group(1) == '219' and false_as_read and false_as_read.group(1) == '6', statement[:200]
    data = json.loads(Path(MASTER).read_text(encoding='utf-8'))
    head = json.loads(subprocess.run(['git', 'show', 'HEAD:' + MASTER], capture_output=True, text=True, check=True).stdout)
    now, then = data['central_reach']['counts'], head['central_reach']['counts']
    assert set(now) == set(F5) == set(then), (now, then)
    four = lambda c: f'{c[F5[0]]}, {c[F5[1]]}, {c[F5[2]]} and {c[F5[3]]}'
    f5 = f"{four(now)} ({', '.join(F5)})" + (', unchanged' if now == then else f', against {four(then)} before')
    # A change comes from the stages in place: name the rows whose standing moved, each now derived by U4c's census.
    moved = {d: ((head['boundary']['rows'].get(d) or {}).get('label'), (row or {}).get('label'))
             for d, row in data['boundary']['rows'].items()
             if (head['boundary']['rows'].get(d) or {}).get('label') != (row or {}).get('label')}
    if now != then:
        assert moved == {'Becoming.Listed.coming_of_ceasing': ('counting', 'derived')}, moved
        f5 += ', `Listed.coming_of_ceasing` now derived by U4c\'s census on the root'
    return g['theorems'], len(g['declarations']), found.group(2), found.group(3), f5


def section(core, n):
    theorems, declarations, in_families, families, f5 = figures(core)
    rec = '../../../../../../theories/becoming/results/records/'
    return (
        f"## OU7 landed: the release gate's item 4 (1 November 2026)\n\n"
        f"OU7 landed (study §{n}, core receipt `{core}`, every core and ring axiom report empty). Plan §八 step 5 "
        f"(丙一与验) is done. The classical corpus's 219 conditional statements are read on the grammar: {in_families} "
        f"fall into {families} families of laws, each with its condition in the grammar's words and a net where the "
        "condition fails and the conclusion fails with it. Six statements are false as read, each with a countermodel. "
        "The rest state a premise, turn on a valuation, define, or are not expressible, each with its reason "
        f"([record]({rec}conditional-laws-of-the-corpus.md), 06 §四). 验's model examples are one rule of rooms tested "
        f"by a window ([record]({rec}rooms-tested-by-a-window.md), 03 §3). The unheated room is thermal equilibrium, "
        "and the thermostats are its heated members. They rest alike until the window draws, and warm or not first "
        f"tells them apart at the stage the margin sets. GrammarLaws has {theorems} theorems in {declarations} "
        f"declarations, and F5 counts {f5}.\n\n"
        "- **The release gate's item 4 is met.** Items 1 to 6 are now met. Item 7, the freeze and the sending "
        "decisions, comes last and is not this note's.\n"
        "- **What item 4 leaves.** The models' conditional laws are each stated with their hypotheses at their homes; "
        "they are not yet each given a net where the condition fails. That does not hold a release. It is the kind of "
        "work plan §十三 items 6, 8, 9 and 11 still ask for, after the gate.\n"
        "- **After the gate.** The frontier is plan §十三's items still open: the map on each model class (6); pairing, "
        "power and the fragments of mutual translation (8); the test systems of plan §六, each with its model, the "
        "organism and the institution named on the one page as having none (9); and the three minimalities' report, "
        "with MDL and Pareto not yet done (11). The organism is next, as OG, with its design in review.\n\n")


def main(core, n):
    text = NOTE.read_text(encoding='utf-8')
    assert "## OU7 landed: the release gate's item 4" not in text, 'the section is already there'
    lines = text.split('\n')
    item4 = [i for i, line in enumerate(lines) if line.startswith('4. **Plan §八 step 5** (丙一与验).')]
    assert len(item4) == 1 and lines[item4[0]].endswith(ITEM4_END), 'item 4 of the release gate'
    lines[item4[0]] += MET
    text = '\n'.join(lines)
    assert text.count('\n' + NEXT + '\n') == 1, NEXT
    text = text.replace('\n' + NEXT + '\n', '\n' + section(core, n) + NEXT + '\n', 1)
    NOTE.write_text(text, encoding='utf-8')
    print(f"WHAT-REMAINS: OU7's section before \"{NEXT}\", item 4 marked met")


if __name__ == '__main__':
    if len(sys.argv) != 3:
        raise SystemExit(__doc__)
    main(sys.argv[1], int(sys.argv[2]))
