#!/usr/bin/env python3
"""UE28's two board edits, made in a worktree (never the shared checkout); board_ue27.py's pattern.

head: put UE28's clause, "UE28 at the head of the queue (landing now: ...); ", at the front of the Queue line, behind no
      other "landing now" clause.
land CORE N ORDER: drop UE28's head clause and put the landed clause first; move UE28's row, its first cell brought to
      what the Lean shows after the reviews and its state the landing, to the history file after the last landed row
      (its links rebased there); add UE28 to the UE row's landed items.
ORDER is the coordinator's sentence naming what comes after UE28, as the coordinator gives it with the word that the
head is free, written verbatim after the landed clause ("UE28 landed (...). Then, in the coordinator's order: ...; ask
the coordinator for a slot. "), so the next lander reads it off the Queue line.
usage (from the checkout root): python3 -B board_ue28.py head | land CORE N ORDER"""
import datetime
import json
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
WORK = 'research/2026-10-05-generative-foundation-review/root-foundation/development/ue28-a-formations-level-as-the-internal-part'
LEANR = 'experiments/integrated-correction/general-framework/generative-basis/lean'
HEAD_TEXT = ("landing now: `Becoming.BlanketCouplings` extended with a formation's level as the internal part, along one "
             "run; one incremental core run; the record a-formations-couplings-as-its-blanket and the blanket's record "
             "amended; 03 §1, 08 §8 and the principle's page; the records citing the rewritten sections re-pointed; "
             "then render, strict check, links and tests, then the fast-forward")
HEAD = re.compile(r'UE28 at the head of the queue \([^()]*\); ')
UE_OLD = "and UE26 and UE27 (1 November)"
_TODAY = datetime.date.today()
UE_NEW = ("and UE26, UE27 and UE28 (1 November)" if (_TODAY.month, _TODAY.day) == (11, 1)
          else f"and UE26 and UE27 (1 November), and UE28 ({_TODAY.day} {_TODAY:%B})")
REVIEWS = ('REVIEW-UE28-DESIGN', 'REVIEW-UE28-LEAN', 'REVIEW-UE28-LANDING')
CLAIMED = (HERE / 'claim_row.txt').read_text(encoding='utf-8').strip('\n').split(' | ')[0]
LANDED = (
    "| **UE28: a formation's level as the internal part** (the item UE27 leaves open in [the blanket's record]"
    "(../theories/becoming/results/records/the-markov-blanket-as-a-coupling-structure.md) and the principle's page "
    "§5: a formation's own record as the internal part of a blanketed law). Purpose: say when a World formation's own "
    "level, with no model beside it, is the internal part, what couples into it the sensory part. Along one course "
    "with the step as the external part, some law determined part by part admits the course exactly where its agent "
    "is consistent, at any two steps alike on the internal, sensory and active states the next ones agreeing, the "
    "world's side the run read by the step; given the functions, a blanketed law whose internal part moves by the "
    "sensory state at its own step. On a balanced World run read with the formation's level internal, a value "
    "across steps of what couples into it sensory (where admission is decided and the couplings listed, "
    "listed_values' value is one) and its act, its rows where it takes part, active: at any two steps alike on its "
    "level, its admission, the levels coupled into it and its act, what is given to it at one step plus what is "
    "taken from it at the other is the same with the steps exchanged and its next acts agree, pairwise, tested only "
    "where these recur. A drain in three phases fails it for every value across steps; a drain and feed in two "
    "phases, the level recurring, meets it for any value: whether what moves the level couples in does not decide "
    "the condition. The last part of the core leaf `Becoming.BlanketCouplings`; the record "
    "a-formations-couplings-as-its-blanket amended with six laws (03 §1), the blanket's record and the page's §5 "
    "narrowed to the formation's other records, its level across a family of runs, and a blanketed law for its "
    "level from consistency alone. Designed and reviewed, its Lean and its landing texts reviewed, every finding "
    "taken")


def queue_line(lines):
    at = [i for i, line in enumerate(lines) if line.startswith('- **Queue:** ')]
    assert len(at) == 1, at
    return at[0]


def head():
    lines = BOARD.read_text(encoding='utf-8').split('\n')
    q = queue_line(lines)
    assert '(landing now' not in lines[q], 'another clause holds the head: ' + lines[q][:200]
    clause = f'UE28 at the head of the queue ({HEAD_TEXT}); '
    assert HEAD.fullmatch(clause), clause
    lines[q] = lines[q].replace('- **Queue:** ', '- **Queue:** ' + clause, 1)
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('head: UE28 at the head of the queue')


def counts(core):
    r = json.loads(Path(f'{LEANR}/becoming/becoming-checks/{core}/verification.json').read_text())
    mod = next(m for m in r['modules'] if m['module'] == 'Becoming.BlanketCouplings')
    return f"{mod['theorems']} theorems in {len(mod['declarations'])} declarations"


def land(core, n, order):
    order = order.strip()
    assert order.startswith("Then, in the coordinator's order: ") and order.endswith('ask the coordinator for a slot.'), order
    assert 'PLACEHOLDER' not in order, 'the order sentence is still the placeholder'
    assert '); ' not in order and '\n' not in order and ' | ' not in order, 'the order sentence'
    root = Path('_process') / WORK
    reviews = [r for r in REVIEWS if (root / f'{r}.md').exists()]
    assert reviews == list(REVIEWS), ('a review is missing', reviews)
    size = counts(core)
    lines = BOARD.read_text(encoding='utf-8').split('\n')
    rows = [i for i, line in enumerate(lines) if line.startswith('| **UE28: ')]
    assert len(rows) == 1, rows
    cells = lines[rows[0]].split(' | ')
    assert len(cells) == 5, len(cells)
    assert cells[0] == CLAIMED, 'the claimed first cell changed: read it, then bring claim_row.txt to it'
    assert LANDED.count(' | ') == 0
    cells[0] = LANDED
    cells[2] = (f"landed {datetime.date.today().isoformat()} at core receipt `{core}`, study §{n}: "
                f"`Becoming.BlanketCouplings` ({size}), the core leaf extended by a last part, every axiom report "
                "empty; the record a-formations-couplings-as-its-blanket amended with six laws, and the blanket's "
                f"record narrowed; the independent reviews of the design ([REVIEW-UE28-DESIGN](../../{WORK}/"
                f"REVIEW-UE28-DESIGN.md)), of the Lean ([REVIEW-UE28-LEAN](../../{WORK}/REVIEW-UE28-LEAN.md)) and of "
                f"the landing texts and records ([REVIEW-UE28-LANDING](../../{WORK}/REVIEW-UE28-LANDING.md)), every "
                "finding taken")
    row = ' | '.join(cells)
    row = re.sub(r'\]\(research/', '](../../research/', row)
    row = re.sub(r'\]\(\.\./sources/', '](../../../sources/', row)
    row = re.sub(r'\]\(\.\./theories/', '](../../../theories/', row)
    del lines[rows[0]]
    q = queue_line(lines)
    assert len(HEAD.findall(lines[q])) == 1 and lines[q].startswith('- **Queue:** UE28 at the head'), 'UE28 not at the head'
    lines[q] = HEAD.sub('', lines[q], count=1)
    landed = (f"UE28 landed (§{n}, core receipt `{core}`, every axiom report empty, one incremental core run: "
              f"`Becoming.BlanketCouplings` extended by a formation's level as the internal part, along one run, {size}: "
              "one course with the step external admitted by some law determined part by part exactly where its agent "
              "is consistent; on a balanced World run read with a formation's level internal, a value across steps "
              "of what couples in and its act, the condition on the World's records, an equation between what is "
              "given to it and taken from it at two steps and its next acts, tested only where these recur; a drain in three phases "
              "fails it, a drain and feed in two meets it; record a-formations-couplings-as-its-blanket amended with "
              "six laws, home 03 §1; the blanket's record narrowed to a formation's other records, its level "
              "across a family of runs and a blanketed law for its level from consistency alone; 08 §8, the page's In brief, claim table, §1, §4 and §5; reviews of the design, "
              "the Lean and the landing texts, every finding taken; the records citing the rewritten sections "
              "re-pointed, nothing they say changed; UE28's row in the history file; render, strict check, links and "
              f"tests pass). {order} ")
    lines[q] = lines[q].replace('- **Queue:** ', '- **Queue:** ' + landed, 1)
    ue = [i for i, line in enumerate(lines) if line.startswith('| **UE: a unified explanation of reality**')]
    assert len(ue) == 1, ue
    ue_cells = lines[ue[0]].split(' | ')
    assert len(ue_cells) == 5 and ue_cells[2].count(UE_OLD) == 1, 'the UE row'
    ue_cells[2] = ue_cells[2].replace(UE_OLD, UE_NEW)
    lines[ue[0]] = ' | '.join(ue_cells)
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    history = HISTORY.read_text(encoding='utf-8').split('\n')
    lapsed = history.index('## Lapsed claims (18 October 2026)')
    end = lapsed - 1
    while not history[end].startswith('| '):
        end -= 1
    history.insert(end + 1, row)
    HISTORY.write_text('\n'.join(history), encoding='utf-8')
    print(f'land: clause written, row moved after history line {end + 1}, UE row brought to UE28')


if __name__ == '__main__':
    if sys.argv[1:2] == ['head']:
        head()
    elif sys.argv[1:2] == ['land']:
        land(sys.argv[2], int(sys.argv[3]), sys.argv[4])
    else:
        raise SystemExit(__doc__)
