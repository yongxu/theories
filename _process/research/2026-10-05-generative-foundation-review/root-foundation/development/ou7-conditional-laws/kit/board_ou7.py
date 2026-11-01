#!/usr/bin/env python3
"""OU7's landed board edits, made in the landing worktree (never the shared checkout); board_ue28.py's pattern. The head
is claimed before the landing, on main's board, with the clause HEAD matches.

land CORE N ORDER: drop OU7's head clause and put the landed clause first, with the receipt's counts and the front pages'
      budget lines; move OU7's row, its first cell brought to what landed and its state the landing, to the history file
      after the last landed row (its links rebased there); add OU7 to the OU row's landed items, plan §八's next steps
      from 6.
ORDER is the coordinator's sentence naming what comes after OU7, as the coordinator gives it, written verbatim after the
landed clause ("OU7 landed (...). Then, in the coordinator's order: ...; ask the coordinator for a slot. "), so the next
lander reads it off the Queue line.
usage (from the checkout root, after post): python3 -B board_ou7.py land CORE N ORDER"""
import datetime
import json
import re
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
BUDGETS = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/development/'
               'aj4-alignment-readers/READING-BUDGETS.md')
WORK = 'research/2026-10-05-generative-foundation-review/root-foundation/development/ou7-conditional-laws'
LEANR = 'experiments/integrated-correction/general-framework/generative-basis/lean'
HEAD = re.compile(r"OU7's rebuild at the head of the queue \([^()]*\); ")
OU_OLD = 'Then plan §八 steps 5–10'
CLAIMED = '| **OU7: conditional laws and 验 (丙一与验)** (formerly OU5, '
LANDED = (
    "| **OU7: conditional laws and 验 (丙一与验)** (formerly OU5; OU plan §八 step 5 and §十三 item 4; the release gate's "
    "item 4 in [WHAT-REMAINS](research/2026-10-05-generative-foundation-review/root-foundation/development/"
    "ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md)). The classical corpus's 219 conditional statements (丙一) read "
    "on the grammar: 128 of them in 22 families of laws, each law with its condition in the grammar's words and a net "
    "where the condition fails and the conclusion with it; six statements false as read, each with a countermodel; the rest "
    "state a premise, turn on a valuation, define, or are not expressible, each with its reason (the record "
    "conditional-laws-of-the-corpus, 06 §四). Two laws they use generalize laws of the core, in Grammar and "
    "GrammarReadings, the old laws their cases. 验: one rule of rooms, tested by a window, derives the toy "
    "thermostat's branches, on the net of the possible (the record rooms-tested-by-a-window, 03 §3)")


def queue_line(lines):
    at = [i for i, line in enumerate(lines) if line.startswith('- **Queue:** ')]
    assert len(at) == 1, at
    return at[0]


def counts(core):
    r = json.loads(Path(f'{LEANR}/becoming/becoming-checks/{core}/verification.json').read_text())
    m = {x['module']: x for x in r['modules']}
    bad = [(x['module'], n) for x in r['modules'] for n, a in x['axiom_dependencies'].items() if a]
    assert r['status'] == 'passed' and not bad, (r['status'], bad[:3])
    return {n: f"{m['Becoming.' + n]['theorems']} theorems in {len(m['Becoming.' + n]['declarations'])} declarations"
            for n in ('GrammarConditionals', 'RoomNet', 'RoomRuns', 'GrammarLaws')}


def budgets():
    """The one page's and the overview's excess, from READING-BUDGETS' rows as the front refresh wrote them."""
    t = BUDGETS.read_text(encoding='utf-8')
    out = {}
    for name, head in (('one page', '| One page (and Chinese) |'), ('overview', '| Overview (and Chinese) |')):
        row = [line for line in t.split('\n') if line.startswith(head)]
        assert len(row) == 1, head
        found = re.search(r'\((\d+\.\d) to (\d+\.\d+) minutes\).*?Done: (\d+) over', row[0])
        assert found, ('the row is not one the front refresh wrote', row[0][:200])
        out[name] = (found.group(3), found.group(2))
    return out


def land(core, n, order):
    order = order.strip()
    assert order.startswith("Then, in the coordinator's order: ") and order.endswith('ask the coordinator for a slot.'), order
    assert '); ' not in order and '\n' not in order and ' | ' not in order, 'the order sentence'
    c, b = counts(core), budgets()
    lines = BOARD.read_text(encoding='utf-8').split('\n')
    rows = [i for i, line in enumerate(lines) if line.startswith('| **OU7: ')]
    assert len(rows) == 1, rows
    cells = lines[rows[0]].split(' | ')
    assert len(cells) == 5 and cells[0].startswith(CLAIMED), 'the claimed row changed: read it before landing'
    assert LANDED.count(' | ') == 0
    cells[0] = LANDED
    cells[2] = (f"landed {datetime.date.today().isoformat()} at core receipt `{core}`, study §{n}: "
                f"`Becoming.GrammarConditionals` ({c['GrammarConditionals']}) in the core, `Becoming.RoomNet` "
                f"({c['RoomNet']}) and `Becoming.RoomRuns` ({c['RoomRuns']}) in the instance ring, every axiom report "
                "empty; the grammar owner's patches and U4c's and ND's Lean stages in the same rebuild, GrammarLaws "
                f"{c['GrammarLaws']}; parts A and B designed, reviewed and rehearsed ([the kit](../../{WORK}/kit/"
                "README.md))")
    row = ' | '.join(cells)
    row = re.sub(r'\]\(research/', '](../../research/', row)
    row = re.sub(r'\]\(\.\./sources/', '](../../../sources/', row)
    row = re.sub(r'\]\(\.\./theories/', '](../../../theories/', row)
    del lines[rows[0]]
    q = queue_line(lines)
    assert len(HEAD.findall(lines[q])) == 1 and lines[q].startswith("- **Queue:** OU7's rebuild at the head"), \
        'OU7 not at the head'
    lines[q] = HEAD.sub('', lines[q], count=1)
    # The coordinator's earlier order, which named OU7's rebuild as still to come, gives way to ORDER.
    lines[q] = re.sub(r"Then, in the coordinator's order: [^.]*?OU7's rebuild[^.]*?ask the coordinator for a slot\. ", '',
                      lines[q])
    landed = (f"OU7 landed (§{n}, core receipt `{core}`, every axiom report empty, one core run reusing the full "
              "rehearsal's steps: part A, the corpus's conditional laws, `Becoming.GrammarConditionals` "
              f"({c['GrammarConditionals']}), record conditional-laws-of-the-corpus, home 06 §四, its two general "
              "laws stated in continuation-relative-to-a-class (01 §4) and classical-definitions-in-the-grammar "
              "(06 §三); part B, 验's rooms, `Becoming.RoomNet` and `Becoming.RoomRuns` in the instance ring, record "
              "rooms-tested-by-a-window, home 03 §3; the grammar owner's patches: `«不出»`, `«闭则不出»` and "
              "`«所闭不出»` stated in GrammarLaws, `Flow.Cut` defined as `«不出»`, the two readings of a region not "
              "crossed, GrammarScope's and GrammarCrossing's docstrings; U4c's census on the root and ND's names "
              f"that state relations, GrammarLaws {c['GrammarLaws']}; the text review's front-page fixes and OU's "
              f"owner's refresh, the one page {b['one page'][0]} over its budget (up to {b['one page'][1]} minutes) "
              f"and the overview {b['overview'][0]} over (up to {b['overview'][1]}), as READING-BUDGETS records; the "
              "records citing what changed re-pointed, nothing they say changed; OU7's row in the history file; "
              f"render, strict check, links, lint and tests pass). {order} ")
    lines[q] = lines[q].replace('- **Queue:** ', '- **Queue:** ' + landed, 1)
    ou = [i for i, line in enumerate(lines) if line.startswith('| **OU: one-unfolding root')]
    assert len(ou) == 1, ou
    ou_cells = lines[ou[0]].split(' | ')
    assert len(ou_cells) == 5 and ou_cells[2].count(OU_OLD) == 1, 'the OU row'
    ou_cells[2] = ou_cells[2].replace(OU_OLD, f"OU7 landed (§{n}, core receipt `{core}`: plan §八 step 5, the corpus's "
                                              "conditional laws and 验's rooms). Then plan §八 steps 6–10")
    lines[ou[0]] = ' | '.join(ou_cells)
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    history = HISTORY.read_text(encoding='utf-8').split('\n')
    lapsed = history.index('## Lapsed claims (18 October 2026)')
    end = lapsed - 1
    while not history[end].startswith('| '):
        end -= 1
    history.insert(end + 1, row)
    HISTORY.write_text('\n'.join(history), encoding='utf-8')
    print(f'land: clause written, row moved after history line {end + 1}, OU row brought to OU7')


if __name__ == '__main__':
    if sys.argv[1:2] == ['land']:
        land(sys.argv[2], int(sys.argv[3]), sys.argv[4])
    else:
        raise SystemExit(__doc__)
