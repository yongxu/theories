#!/usr/bin/env python3
"""UE26's two board edits, made in a worktree (never the shared checkout); board_ue25.py's pattern.

head: put UE26's clause, "UE26 at the head of the queue (landing now: ...); ", at the front of the Queue line, behind no
      other "landing now" clause.
land CORE LINEAR N ORDER: drop UE26's head clause and put the landed clause first; move UE26's row, its first cell
      brought to what the Lean shows after the review and its recheck and its state the landing, to the history file
      after the last landed row (its links rebased there); add UE26 to the UE row's landed items.
ORDER is the coordinator's sentence naming what comes after UE26, as the coordinator gives it with the word that the
head is free, written verbatim after the landed clause ("UE26 landed (...). Then, in the coordinator's order: ...; ask
the coordinator for a slot. "), so the next lander reads it off the Queue line.
usage (from the checkout root): python3 -B board_ue26.py head | land CORE LINEAR N ORDER"""
import datetime
import json
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
WORK = 'research/2026-10-05-generative-foundation-review/root-foundation/development/ue26-blankets-at-a-steady-state'
LEANR = 'experiments/integrated-correction/general-framework/generative-basis/lean'
HEAD_TEXT = ("landing now: `Becoming.BlanketWeights` joined as a core leaf importing `Becoming.Blanket` and "
             "`Becoming.Flow`, and the periphery module `LinearBlankets` with its checker; one incremental core run "
             "and one periphery run; two new records, the-blanket-at-a-steady-state and "
             "the-blanket-in-a-linear-steady-state, and the blanket's record naming them; 03 §1, 08 §8 and the "
             "principle's page; the records citing the rewritten sections re-pointed; then render, strict check, links "
             "and tests, then the fast-forward")
HEAD = re.compile(r'UE26 at the head of the queue \([^()]*\); ')
UE_OLD = "and UE25 (31 October)"
_TODAY = datetime.date.today()
UE_NEW = ("and UE25 and UE26 (31 October)" if (_TODAY.month, _TODAY.day) == (10, 31)
          else f"and UE25 (31 October), and UE26 ({_TODAY.day} {_TODAY:%B})")
CLAIMED = (HERE / 'claim_row.txt').read_text(encoding='utf-8').strip('\n').split(' | ')[0]
LANDED = (
    "| **UE26: blankets at a steady state, the coupling form and the statistical form** (the principle's page §5: "
    "densities and steady states, the Helmholtz decomposition of a steady-state flow, and whether statistical and "
    "dynamical blankets coincide; the claim that sparse coupling implies a steady-state density with conditional "
    "independencies, Friston, Da Costa, Sajid, Heins, Ueltzhöffer, Pavliotis and Parr 2023, §4). Purpose: state where "
    "the principle's statistical blanket, internal and external states independent given the present blanket state "
    "at a steady state, holds, and how it stands to the theory's blanket, a coupling structure. In the pure core: "
    "independence given the blanket on ConditionalWeights is the cross form on listed states, the converse on "
    "listings listing each state once, restrict_independent its case at one blanket state; with positive weights, "
    "detailed balance of the internal moves within one closure («所闭») of moves present at every external state, "
    "each move's rate ratio reading no external state, gives it, Kelly's proof at "
    "the internal site, sufficient, not necessary; witnesses: a lag relay losing it, a turning chain circulating and "
    "keeping it, rates reading the external state keeping it, moves reading it losing it, a synchronous copy "
    "keeping it when exact and losing it with a miss, a blanketed run's occupation weighting. In the periphery, "
    "on Mathlib's real matrices: the Lyapunov equation as the Helmholtz form B = (D − Q)Π; row i of QΠ zero exactly "
    "where row i of Q is; footnote 13 as a law for any set of coordinates; the term-by-term corollaries of the 2023 "
    "paper's eq. 9 in the linear case; the internal mode; the Euler step of a sparsely coupled drift a blanketed law, "
    "and with additive noise the agent's course fixed by its start, its noise and its sensory course; the synchronous "
    "steady precision, Π − (h/2)ΠDΠ without circulation, keeping the four-part zero there, and in a circulating "
    "witness at h = 1/10 losing it, even under footnote 13 and eq. 9, a loss of the discrete step; witnesses labelled by the definition of sparse coupling they meet. A core leaf "
    "and a periphery module with its checker; two records at 03 §1; the page's §5 rows. Designed, reviewed, checked "
    "against the literature, rechecked, and its Lean and texts reviewed before landing")


def queue_line(lines):
    at = [i for i, line in enumerate(lines) if line.startswith('- **Queue:** ')]
    assert len(at) == 1, at
    return at[0]


def head():
    lines = BOARD.read_text(encoding='utf-8').split('\n')
    q = queue_line(lines)
    assert '(landing now' not in lines[q], 'another clause holds the head: ' + lines[q][:200]
    clause = f'UE26 at the head of the queue ({HEAD_TEXT}); '
    assert HEAD.fullmatch(clause), clause
    lines[q] = lines[q].replace('- **Queue:** ', '- **Queue:** ' + clause, 1)
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('head: UE26 at the head of the queue')


def counts(core, linear):
    r = json.loads(Path(f'{LEANR}/becoming/becoming-checks/{core}/verification.json').read_text())
    mod = next(m for m in r['modules'] if m['module'] == 'Becoming.BlanketWeights')
    lr = json.loads(Path(f'{LEANR}/free-energy/linear-blankets-checks/{linear}/verification.json').read_text())
    lmod = lr['modules'][0]
    return (f"{mod['theorems']} theorems in {len(mod['declarations'])} declarations",
            f"{lmod['theorems']} theorems in {len(lmod['declarations'])} declarations")


def land(core, linear, n, order):
    order = order.strip()
    assert order.startswith("Then, in the coordinator's order: ") and order.endswith('ask the coordinator for a slot.'), order
    assert '); ' not in order and '\n' not in order and ' | ' not in order, 'the order sentence'
    size, lsize = counts(core, linear)
    lines = BOARD.read_text(encoding='utf-8').split('\n')
    rows = [i for i, line in enumerate(lines) if line.startswith('| **UE26: ')]
    assert len(rows) == 1, rows
    cells = lines[rows[0]].split(' | ')
    assert len(cells) == 5, len(cells)
    assert cells[0] == CLAIMED, 'the claimed first cell changed'
    assert LANDED.count(' | ') == 0
    cells[0] = LANDED
    cells[2] = (f"landed {datetime.date.today().isoformat()} at core receipt `{core}` and periphery receipt `{linear}`, study §{n}: "
                f"`Becoming.BlanketWeights` ({size}), a new core leaf importing `Becoming.Blanket` and `Becoming.Flow`, "
                f"every axiom report empty; `LinearBlankets` ({lsize}), Lean's standard axioms; the records "
                "the-blanket-at-a-steady-state and the-blanket-in-a-linear-steady-state, and the blanket's record "
                f"naming them; the independent review ([REVIEW-UE26-DESIGN](../../{WORK}/REVIEW-UE26-DESIGN.md)), the "
                f"literature check ([LITERATURE-CHECK](../../{WORK}/LITERATURE-CHECK.md)), the recheck "
                f"([RECHECK-UE26](../../{WORK}/RECHECK-UE26.md)) and the landing review "
                f"([REVIEW-UE26-LANDING](../../{WORK}/REVIEW-UE26-LANDING.md)), every finding taken")
    row = ' | '.join(cells)
    row = re.sub(r'\]\(research/', '](../../research/', row)
    row = re.sub(r'\]\(\.\./sources/', '](../../../sources/', row)
    del lines[rows[0]]
    q = queue_line(lines)
    assert len(HEAD.findall(lines[q])) == 1 and lines[q].startswith('- **Queue:** UE26 at the head'), 'UE26 not at the head'
    lines[q] = HEAD.sub('', lines[q], count=1)
    landed = (f"UE26 landed (§{n}, core receipt `{core}`, every axiom report empty, one incremental core run: "
              f"`Becoming.BlanketWeights` as a core leaf importing Blanket and Flow, {size}: the principle's "
              "statistical blanket on the theory's conditioning, the cross form, and detailed balance of the internal "
              "moves as a sufficient condition, with witnesses on either side; periphery receipt "
              f"`{linear}`: `LinearBlankets`, {lsize}, the linear steady state, footnote 13 as a law, the term-by-term "
              "corollaries, the join to the blanketed law with noise, and the synchronous scheme losing the four-part "
              "blanket in a circulating witness; records the-blanket-at-a-steady-state and "
              "the-blanket-in-a-linear-steady-state, home 03 §1; the blanket's record naming them; 08, the page's "
              "In brief, claim table, §1, §2, §5 and Standing; a review, a literature check, a recheck and a landing "
              "review, every finding taken; the records citing the rewritten sections re-pointed, nothing they say changed; UE26's "
              f"row in the history file; render, strict check, links and tests pass). {order} ")
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
    print(f'land: clause written, row moved after history line {end + 1}, UE row brought to UE26')


if __name__ == '__main__':
    if sys.argv[1:2] == ['head']:
        head()
    elif sys.argv[1:2] == ['land']:
        land(sys.argv[2], sys.argv[3], int(sys.argv[4]), sys.argv[5])
    else:
        raise SystemExit(__doc__)
