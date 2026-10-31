#!/usr/bin/env python3
"""UE25's two board edits, made in a worktree (never the shared checkout); board_ue24.py's pattern.

head: put UE25's clause, "UE25 at the head of the queue (landing now: ...); ", at the front of the Queue line, behind no
      other "landing now" clause.
land RECEIPT N ORDER: drop UE25's head clause and put the landed clause first; move UE25's row, its first cell brought to
      what the Lean shows after the review and its recheck and its state the landing, to the history file after the
      last landed row (its links rebased there); add UE25 to the UE row's landed items.
ORDER is the coordinator's sentence naming what comes after UE25, as the coordinator gives it with the word that the
head is free, written verbatim after the landed clause ("UE25 landed (...). Then, in the coordinator's order: ...; ask
the coordinator for a slot. "), the form RP2b's landed clause has, so the next lander reads it off the Queue line.
usage (from the checkout root): python3 -B board_ue25.py head | land RECEIPT N ORDER"""
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
WORK = 'research/2026-10-05-generative-foundation-review/root-foundation/development/ue25-communicating-agents'
HEAD_TEXT = ("landing now: `Becoming.CountedCodes` joined as a core leaf importing `Becoming.SharedCodes` and "
             "`Becoming.FreeEnergyCounting`; one incremental core run; one new record, a-code-held-as-counts, and UE1's "
             "record naming it; 05 §9, 08 §8, the principle's page and a correction section in UE1's search; the "
             "records citing the rewritten sections re-pointed; then render, strict check, links and tests, then the "
             "fast-forward")
HEAD = re.compile(r'UE25 at the head of the queue \([^()]*\); ')
UE_OLD = "and UE20, UE21, UE22, UE23 and UE24 (30 October)"
UE_NEW = "and UE20, UE21, UE22, UE23 and UE24 (30 October), and UE25 (31 October)"
CLAIMED = (HERE / 'claim_row.txt').read_text(encoding='utf-8').strip('\n').split(' | ')[0]
LANDED = (
    "| **UE25: communicating agents in the principle's terms, a code held as counts and learned from what is heard** "
    "(the principle's page §3: the statements UE1's search grades as forbidden on their natural reading but not "
    "stated in the principle's terms, that communication ensures both agents come to share the same model, Friston "
    "and Frith 2015, that any dyad or ensemble comes to share a generative model, Friston, Ramstead and others 2024 "
    "§4.1, and that language is an emergent property of free-energy minimization, Friston, Parr and others 2024). "
    "Purpose: state 05 §9's law for agents whose beliefs are Dirichlet counts learned from what they hear, so the page "
    "can count what it forbids. In the pure core: beliefs as counts of each word for each meaning in any strict "
    "order, natural counts for learning and free energy; two words never both uniquely greatest; under a law keeping "
    "the exchange of agents together with a renaming of the words, from a start related to itself, two exchanged "
    "agents never hold one word as each one's uniquely greatest where the renaming moves every word and is onto, or "
    "the exchange is an involution; learning from what is heard, the hearer given the meaning, keeps the relation "
    "where the speaker map commutes with the exchange and the rule reads count by count and commutes with renaming, "
    "adding what is heard among such rules, and so does a weight on what is heard read off the whole model where the "
    "renaming leaves it unchanged; adding the speaker's own counts gives an involutive pair one model after one step, "
    "with no uniquely greatest word there from a related start; the free-energy bound in counts is unchanged by a "
    "renaming permuting the words, and under weights a renaming moving every word fixes, with a positive total, a "
    "belief at the bound over a listing of every word names no word. Witnesses: a preferred word, and an "
    "asymmetric start, each bring a shared uniquely greatest word. The page counts a fifth statement, federated "
    "inference's read universally with the ecosystems paper's as its general form; the duet, in continuous states, "
    "stays under the code law. A new core leaf importing Becoming.SharedCodes and Becoming.FreeEnergyCounting, one "
    "core run; a new record beside a-code-formed-between-formations; 05 §9, the principle's page §3, 08 §8. Reviewed "
    "and rechecked before landing")


def queue_line(lines):
    at = [i for i, line in enumerate(lines) if line.startswith('- **Queue:** ')]
    assert len(at) == 1, at
    return at[0]


def head():
    lines = BOARD.read_text(encoding='utf-8').split('\n')
    q = queue_line(lines)
    assert '(landing now' not in lines[q], 'another clause holds the head: ' + lines[q][:200]
    clause = f'UE25 at the head of the queue ({HEAD_TEXT}); '
    assert HEAD.fullmatch(clause), clause
    lines[q] = lines[q].replace('- **Queue:** ', '- **Queue:** ' + clause, 1)
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('head: UE25 at the head of the queue')


def counts(receipt):
    import json
    r = json.loads(Path('experiments/integrated-correction/general-framework/generative-basis/lean/becoming/'
                        f'becoming-checks/{receipt}/verification.json').read_text())
    mod = next(m for m in r['modules'] if m['module'] == 'Becoming.CountedCodes')
    return f"{mod['theorems']} theorems in {len(mod['declarations'])} declarations"


def land(receipt, n, order):
    order = order.strip()
    assert order.startswith("Then, in the coordinator's order: ") and order.endswith('ask the coordinator for a slot.'), order
    assert '); ' not in order and '\n' not in order and ' | ' not in order, 'the order sentence'
    size = counts(receipt)
    lines = BOARD.read_text(encoding='utf-8').split('\n')
    rows = [i for i, line in enumerate(lines) if line.startswith('| **UE25: ')]
    assert len(rows) == 1, rows
    cells = lines[rows[0]].split(' | ')
    assert len(cells) == 5, len(cells)
    assert cells[0] == CLAIMED, 'the claimed first cell changed'
    assert LANDED.count(' | ') == 0
    cells[0] = LANDED
    cells[2] = (f"landed 2026-10-31 at core receipt `{receipt}`, study §{n}: `Becoming.CountedCodes` ({size}), "
                "a new core leaf importing `Becoming.SharedCodes` and `Becoming.FreeEnergyCounting`, "
                "every axiom report empty; the record a-code-held-as-counts, and UE1's record naming it among the "
                f"third parts; the independent review ([REVIEW-UE25](../../{WORK}/REVIEW-UE25.md)), every finding "
                f"taken, and its recheck ([RECHECK-UE25](../../{WORK}/RECHECK-UE25.md))")
    row = ' | '.join(cells)
    row = re.sub(r'\]\(research/', '](../../research/', row)
    row = re.sub(r'\]\(\.\./sources/', '](../../../sources/', row)
    del lines[rows[0]]
    q = queue_line(lines)
    assert len(HEAD.findall(lines[q])) == 1 and lines[q].startswith('- **Queue:** UE25 at the head'), 'UE25 not at the head'
    lines[q] = HEAD.sub('', lines[q], count=1)
    landed = (f"UE25 landed (§{n}, core receipt `{receipt}`, every axiom report empty, one incremental core run: "
              f"`Becoming.CountedCodes` as a core leaf importing SharedCodes and FreeEnergyCounting, {size}: "
              "the code law for beliefs held as counts and learned from what is heard, joined to the "
              "free-energy bound in counts; record a-code-held-as-counts, home 05 §9; the principle's page counts a "
              "fifth statement, the duet staying under the code law; 05, 08, the page, a correction section in UE1's "
              "search and UE1's record naming the fifth third part; an independent review and its recheck, every "
              "finding taken; the records citing the rewritten sections re-pointed, nothing they say changed; UE25's "
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
    print(f'land: clause written, row moved after history line {end + 1}, UE row brought to UE25')


if __name__ == '__main__':
    if sys.argv[1:2] == ['head']:
        head()
    elif sys.argv[1:2] == ['land']:
        land(sys.argv[2], int(sys.argv[3]), sys.argv[4])
    else:
        raise SystemExit(__doc__)
