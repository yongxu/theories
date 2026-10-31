#!/usr/bin/env python3
"""UE27's two board edits, made in a worktree (never the shared checkout); board_ue26.py's pattern.

head: put UE27's clause, "UE27 at the head of the queue (landing now: ...); ", at the front of the Queue line, behind no
      other "landing now" clause.
land CORE N ORDER: drop UE27's head clause and put the landed clause first; move UE27's row, its first cell brought to
      what the Lean shows after the reviews of the design and of the Lean and its state the landing, to the history
      file after the last landed row (its links rebased there); add UE27 to the UE row's landed items.
ORDER is the coordinator's sentence naming what comes after UE27, as the coordinator gives it with the word that the
head is free, written verbatim after the landed clause ("UE27 landed (...). Then, in the coordinator's order: ...; ask
the coordinator for a slot. "), so the next lander reads it off the Queue line.
usage (from the checkout root): python3 -B board_ue27.py head | land CORE N ORDER"""
import datetime
import json
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
WORK = 'research/2026-10-05-generative-foundation-review/root-foundation/development/ue27-which-blanket-a-thing-has'
LEANR = 'experiments/integrated-correction/general-framework/generative-basis/lean'
HEAD_TEXT = ("landing now: `Becoming.BlanketCouplings` joined as a core leaf importing `Becoming.Blanket`, "
             "`Becoming.Histories` and `Becoming.IdentificationRuns`; one incremental core run; the new record "
             "a-formations-couplings-as-its-blanket and the blanket's record amended; 03 §1, 08 §8 and the "
             "principle's page; the records citing the rewritten sections re-pointed; then render, strict check, links "
             "and tests, then the fast-forward")
HEAD = re.compile(r'UE27 at the head of the queue \([^()]*\); ')
UE_OLD = "and UE26 (1 November)"
_TODAY = datetime.date.today()
UE_NEW = ("and UE26 and UE27 (1 November)" if (_TODAY.month, _TODAY.day) == (11, 1)
          else f"and UE26 (1 November), and UE27 ({_TODAY.day} {_TODAY:%B})")
CLAIMED = (HERE / 'claim_row.txt').read_text(encoding='utf-8').strip('\n').split(' | ')[0]
LANDED = (
    "| **UE27: which blanket a thing has, and a formation's couplings as its blanket** (the two items "
    "`Becoming.Blanket`'s header leaves out, which blanket a thing has and a World formation in general as the agent of "
    "a blanketed law, the latter the next delta of [the blanket's record](../theories/becoming/results/records/"
    "the-markov-blanket-as-a-coupling-structure.md) and in the principle's page §5). Purpose: state in the pure core "
    "when a blanket's existence constrains, and every formation's couplings as a blanket. The join, by construction: "
    "where a formation's couplings give the values of what couples into it, any model fed by them, with any policy and "
    "environment, reading the act or not, is the agent of a blanketed law whose sensory course is the formation's own "
    "course through its couplings, two of its courses alike on the blanket before n + 2 exactly where their level "
    "histories are alike through the couplings up to n, in the open loop every reading of its internal course a "
    "selection through them; ThresholdDrain's join its case, checked; a construction, not a test, forbidding nothing "
    "of the course. The law a family shows, part by part: determined part by part exactly where the family is "
    "consistent part by part, Determined an equivalent case. Three levels: readings of the course (which course and "
    "the step, or the future) give every family a blanketed law, the step alone not enough; degenerate readings of the "
    "configuration give every family, or exactly the determined ones, the blanket's form, an injective one only those "
    "and not always; a sparse partition fixed apart from the family can be refuted by one run. A core leaf "
    "`Becoming.BlanketCouplings` importing Blanket, Histories and IdentificationRuns; one record at 03 §1, the "
    "blanket's record narrowed to a formation's own record as the internal part; the page's In brief, claim table, "
    "§1, §2, §4, §5 and Standing. Designed and reviewed, its Lean reviewed with a probe, every finding taken")


def queue_line(lines):
    at = [i for i, line in enumerate(lines) if line.startswith('- **Queue:** ')]
    assert len(at) == 1, at
    return at[0]


def head():
    lines = BOARD.read_text(encoding='utf-8').split('\n')
    q = queue_line(lines)
    assert '(landing now' not in lines[q], 'another clause holds the head: ' + lines[q][:200]
    clause = f'UE27 at the head of the queue ({HEAD_TEXT}); '
    assert HEAD.fullmatch(clause), clause
    lines[q] = lines[q].replace('- **Queue:** ', '- **Queue:** ' + clause, 1)
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('head: UE27 at the head of the queue')


def counts(core):
    r = json.loads(Path(f'{LEANR}/becoming/becoming-checks/{core}/verification.json').read_text())
    mod = next(m for m in r['modules'] if m['module'] == 'Becoming.BlanketCouplings')
    return f"{mod['theorems']} theorems in {len(mod['declarations'])} declarations"


def land(core, n, order):
    order = order.strip()
    assert order.startswith("Then, in the coordinator's order: ") and order.endswith('ask the coordinator for a slot.'), order
    assert '); ' not in order and '\n' not in order and ' | ' not in order, 'the order sentence'
    size = counts(core)
    lines = BOARD.read_text(encoding='utf-8').split('\n')
    rows = [i for i, line in enumerate(lines) if line.startswith('| **UE27: ')]
    assert len(rows) == 1, rows
    cells = lines[rows[0]].split(' | ')
    assert len(cells) == 5, len(cells)
    assert cells[0] == CLAIMED, 'the claimed first cell changed'
    assert LANDED.count(' | ') == 0
    cells[0] = LANDED
    cells[2] = (f"landed {datetime.date.today().isoformat()} at core receipt `{core}`, study §{n}: "
                f"`Becoming.BlanketCouplings` ({size}), a new core leaf importing `Becoming.Blanket`, "
                "`Becoming.Histories` and `Becoming.IdentificationRuns`, every axiom report empty; the record "
                "a-formations-couplings-as-its-blanket, and the blanket's record narrowed; the independent reviews of the "
                f"design ([REVIEW-UE27-DESIGN](../../{WORK}/REVIEW-UE27-DESIGN.md)), of the Lean "
                f"([REVIEW-UE27-LEAN](../../{WORK}/REVIEW-UE27-LEAN.md)) and of the landing texts and records "
                f"([REVIEW-UE27-LANDING](../../{WORK}/REVIEW-UE27-LANDING.md)), every finding taken")
    row = ' | '.join(cells)
    row = re.sub(r'\]\(research/', '](../../research/', row)
    row = re.sub(r'\]\(\.\./sources/', '](../../../sources/', row)
    row = re.sub(r'\]\(\.\./theories/', '](../../../theories/', row)
    del lines[rows[0]]
    q = queue_line(lines)
    assert len(HEAD.findall(lines[q])) == 1 and lines[q].startswith('- **Queue:** UE27 at the head'), 'UE27 not at the head'
    lines[q] = HEAD.sub('', lines[q], count=1)
    landed = (f"UE27 landed (§{n}, core receipt `{core}`, every axiom report empty, one incremental core run: "
              f"`Becoming.BlanketCouplings` as a core leaf importing Blanket, Histories and IdentificationRuns, {size}: "
              "any model fed by what couples into a formation the agent of a blanketed law whose sensory course is the "
              "formation's own course, by construction, ThresholdDrain's join its case; the law a family shows part by "
              "part; the three levels at which a blanket's existence constrains, a sparse partition fixed apart "
              "refuted by one run; record a-formations-couplings-as-its-blanket, home 03 §1; the blanket's record "
              "narrowed to a formation's own record as the internal part; 08, the page's In brief, claim table, §1, "
              "§2, §4, §5 and Standing; reviews of the design, the Lean and the landing texts, every finding taken; the records citing "
              "the rewritten sections re-pointed, nothing they say changed; UE27's row in the history file; render, "
              f"strict check, links and tests pass). {order} ")
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
    print(f'land: clause written, row moved after history line {end + 1}, UE row brought to UE27')


if __name__ == '__main__':
    if sys.argv[1:2] == ['head']:
        head()
    elif sys.argv[1:2] == ['land']:
        land(sys.argv[2], int(sys.argv[3]), sys.argv[4])
    else:
        raise SystemExit(__doc__)
