#!/usr/bin/env python3
"""UE29's board edits, made in a worktree (never the shared checkout); board_ue28.py's pattern.

claim: add UE29's row to the open claims, after UE8's row.
head: put UE29's clause "UE29 at the head of the queue (landing now: ...); " at the front of the Queue line, behind
      no other "landing now" clause.
land CORE FE EFE ORDER: drop the head clause and put the landed clause first, the coordinator's sentence ORDER after
      it verbatim; move UE29's row, its state the landing, and UE8's and UE's rows, each closed, to the history file
      after its last row, their links rebased there.
usage (from the checkout root): python3 -B board_ue29.py claim | head | land CORE FE EFE ORDER"""
import datetime
import re
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
STUDY = 'research/2026-10-05-generative-foundation-review/root-foundation/development'
WORK = f'{STUDY}/ue-unified-explanation/ue29-docstrings'
TODAY = datetime.date.today()
DAY = f'{TODAY.day} {TODAY:%B} {TODAY.year}'
ROW = (
    "| **UE29: core docstrings brought to what the Lean proves** (RECHECK-UE22's N2, "
    f"[RECHECK-UE22]({STUDY}/ue22-counting-and-real-forms/RECHECK-UE22.md); the text review's Ranking fix, folded in "
    "on the coordinator's word, as is the second Lean review's narrowing). Purpose: the core's docstrings saying what "
    "its Lean proves. "
    "`Becoming.FreeEnergyCounting`'s module docstring and `Witness.off_support`'s say the real form of "
    "`FreeEnergyReals` fails at that witness, where it holds at equality (`FreeEnergy.Witness.one_count_off_support`) "
    "and the core's bound is strict; each now says so, and where the real form fails (counts one and one against "
    "the same weights, `FreeEnergy.Witness.gap_counts_off_support`). `Becoming.Ranking`'s four docstrings read "
    "J1/J2 where they read J1, as `Becoming.Lexical` does. `Becoming.MapRegions` and `Becoming.BlanketCouplings` "
    "take the second Lean review's narrowed docstrings. Docstrings only, no statement or name changed: one "
    "incremental core run (sixteen modules: FreeEnergyCounting with CountedCodes, Ranking with its nine "
    "dependents, MapRegions with its two, BlanketCouplings), both free-energy periphery checkers rerun, eleven "
    "records' proof bindings moved; UE8's row and UE's row closed with it "
    "| Claude Code desktop session (farther than FEP), 2 November 2026 "
    "| claimed 2 November 2026 on the coordinator's word; staged on the branch ue29-docstrings "
    f"| `development/ue-unified-explanation/ue29-docstrings/` "
    "| RECHECK-UE22, the text review and the second Lean review → FreeEnergyCounting, Ranking, MapRegions, BlanketCouplings, eleven records |")
HEAD_TEXT = ("landing now: docstrings only, no statement changed: FreeEnergyCounting's off-support docstrings, "
             "Ranking's J1/J2 labels and the second Lean review's narrowing in MapRegions and BlanketCouplings; one "
             "incremental core run and both free-energy periphery checkers; eleven records' "
             "proof bindings moved; UE29's, UE8's and UE's rows to the history file; render, strict check, links, tests "
             "and both dossier checks, then the fast-forward")
HEAD = re.compile(r'UE29 at the head of the queue \([^()]*\); ')
UE8_CLOSE = (f"; closed {DAY} with UE29's landing: done, the dossier in UE's folder, and whether it joins the "
             "packet as a sixth dossier kept in Decisions pending Ren")
UE_CLOSE = (f"; closed {DAY} with UE29's landing, the pending docstrings corrected there: nothing in hand, the plan "
            "kept in its folder, and a new UE item opens its own row")


def queue_line(lines):
    at = [i for i, line in enumerate(lines) if line.startswith('- **Queue:** ')]
    assert len(at) == 1, at
    return at[0]


def one_row(lines, start):
    at = [i for i, line in enumerate(lines) if line.startswith(start)]
    assert len(at) == 1, (start, at)
    return at[0]


def rebase(row):
    row = re.sub(r'\]\(\.\./', '](../../../', row)
    row = re.sub(r'\]\(research/', '](../../research/', row)
    assert '](_process/' not in row and '](history/' not in row, 'a link the rebase does not cover'
    return row


def claim():
    lines = BOARD.read_text(encoding='utf-8').split('\n')
    assert not [line for line in lines if line.startswith('| **UE29: ')], 'UE29 is already claimed'
    assert ROW.count(' | ') == 4, ROW.count(' | ')
    lines.insert(one_row(lines, '| **UE8: a dossier for scientists**') + 1, ROW)
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('claim: UE29 after UE8')


def head():
    lines = BOARD.read_text(encoding='utf-8').split('\n')
    q = queue_line(lines)
    assert '(landing now' not in lines[q], 'another clause holds the head: ' + lines[q][:200]
    one_row(lines, '| **UE29: ')
    clause = f'UE29 at the head of the queue ({HEAD_TEXT}); '
    assert HEAD.fullmatch(clause), clause
    lines[q] = lines[q].replace('- **Queue:** ', '- **Queue:** ' + clause, 1)
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('head: UE29 at the head of the queue')


def land(core, fe, efe, order):
    order = order.strip()
    assert order.startswith("Then, in the coordinator's order: ") and order.endswith('ask the coordinator for a slot.'), order
    assert '); ' not in order and '\n' not in order and ' | ' not in order, 'the order sentence'
    lines = BOARD.read_text(encoding='utf-8').split('\n')
    moved = []
    i = one_row(lines, '| **UE29: ')
    cells = lines[i].split(' | ')
    assert len(cells) == 5, len(cells)
    cells[2] = (f"landed {TODAY.isoformat()} at core receipt `{core}` (incremental, every axiom report empty) and "
                f"periphery receipts `{fe}` (FreeEnergyReals) and `{efe}` (ExpectedFreeEnergyReals), each with its "
                "axioms reported: docstrings only, no statement changed; eleven records' proof bindings moved, nothing "
                "they say changed")
    assert cells[4].startswith('RECHECK-UE22, the text review'), cells[4]
    cells[4] = 'RECHECK-UE22, the text review and the second Lean review → FreeEnergyCounting, Ranking, MapRegions, BlanketCouplings, eleven records |'
    moved.append(' | '.join(cells))
    del lines[i]
    for start, close in (('| **UE8: a dossier for scientists**', UE8_CLOSE),
                         ('| **UE: a unified explanation of reality**', UE_CLOSE)):
        i = one_row(lines, start)
        cells = lines[i].split(' | ')
        assert len(cells) == 5, (start, len(cells))
        cells[2] = cells[2].rstrip() + close
        moved.append(' | '.join(cells))
        del lines[i]
    q = queue_line(lines)
    assert len(HEAD.findall(lines[q])) == 1 and lines[q].startswith('- **Queue:** UE29 at the head'), 'UE29 not at the head'
    lines[q] = HEAD.sub('', lines[q], count=1)
    landed = (f"UE29 landed (core receipt `{core}`, every axiom report empty, one incremental core run, and periphery "
              f"receipts `{fe}` and `{efe}`: docstrings only, no statement changed: FreeEnergyCounting's off-support "
              "docstrings say the real form is at equality at `Witness.off_support` and fails at counts one and one; "
              "Ranking's four docstrings read J1/J2; MapRegions and BlanketCouplings take the second Lean review's "
              "narrowing; eleven records' proof bindings moved, nothing they say changed; "
              "UE29's row, and UE8's and UE's rows closed, in the history file; render, strict check, links, tests and "
              f"both dossier checks pass). {order} ")
    lines[q] = lines[q].replace('- **Queue:** ', '- **Queue:** ' + landed, 1)
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    history = HISTORY.read_text(encoding='utf-8').split('\n')
    lapsed = history.index('## Lapsed claims (18 October 2026)')
    end = lapsed - 1
    while not history[end].startswith('| '):
        end -= 1
    for k, row in enumerate(moved):
        history.insert(end + 1 + k, rebase(row))
    HISTORY.write_text('\n'.join(history), encoding='utf-8')
    print(f'land: clause written, three rows moved after history line {end + 1}')


if __name__ == '__main__':
    if sys.argv[1:] in (['claim'], ['head']):
        {'claim': claim, 'head': head}[sys.argv[1]]()
    elif len(sys.argv) == 6 and sys.argv[1] == 'land':
        land(*sys.argv[2:])
    else:
        sys.exit(__doc__)
