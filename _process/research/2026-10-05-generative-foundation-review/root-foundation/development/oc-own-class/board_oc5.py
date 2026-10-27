#!/usr/bin/env python3
"""OC5: the board row. `head` marks the row at the head of the landing queue while its checker runs, and writes its
clause at the front of the Queue line; `land RECEIPT SECTION THEOREMS DECLS FINDINGS` moves the row, its state set to
landed, into the history file after the last landed row (inserting it, the rest of the file byte for byte) and puts the
landing at the head of the queue note in place of the clause. FINDINGS is the review's count, in words, as the study
section gives it.
usage (from the checkout root): python3 -B board_oc5.py head | land RECEIPT SECTION THEOREMS DECLS FINDINGS"""
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
board = BOARD.read_text(encoding='utf-8').split('\n')
rows = [i for i, line in enumerate(board) if line.startswith("| **OC5: the crux's structure as laws**")]
assert len(rows) == 1, rows
cells = board[rows[0]].split(' | ')
assert len(cells) == 5, len(cells)
LAWS = ('`Becoming.GrammarPath` gains the reach with no regularity assumed (`«后皆同类则后皆续»`, `«后皆续当且仅当后皆同类»`, '
        '`«后皆续则所缘同于»`, `«后皆续当且仅当自与线皆闭»`, `«亡而网续则后不皆续»`), the witnesses `OtherLeaves` and '
        '`FiniteFamilies.member_no_reach`, the condition at a member\'s class where it acts (`«本类常当且仅当与己相随»`) '
        'and the division outside through its own leaving effects (`«外分唯系己出之同»`); `«本类常闭则后皆续»` and '
        '`«闭则外分无关»` now derived from them (rule 9), statements unchanged; the deferred comment fixes and '
        '`FinerWake.finer_class`')
HEAD = "OC5 at the head of the queue (the crux's structure as laws; core checker running in its landing worktree); "
queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
assert len(queue) == 1

if sys.argv[1:] == ['head']:
    cells[2] = (f'claimed 2026-10-27; {LAWS}; built in scratch, reviewed once independently and fixed; **at the head of '
                'the queue (checker running)**')
    assert HEAD not in board[queue[0]]
    board[queue[0]] = board[queue[0]].replace('- **Queue:** ', '- **Queue:** ' + HEAD, 1)
    BOARD.write_text('\n'.join(board[:rows[0]] + [' | '.join(cells)] + board[rows[0] + 1:]), encoding='utf-8')
    print('board head')
elif sys.argv[1:2] == ['land'] and len(sys.argv) == 7:
    receipt, section, theorems, decls, findings = sys.argv[2], int(sys.argv[3]), sys.argv[4], sys.argv[5], sys.argv[6]
    cells[2] = (f'landed {datetime.now(timezone.utc).date().isoformat()}, core receipt `{receipt}`; {LAWS}: '
                f'Becoming.GrammarPath {theorems} theorems in {decls} declarations, empty axiom reports; one independent '
                f'review ({findings}), every finding verified, each fixed but two (`development/oc-own-class/REVIEW-OC5.md`); '
                '07 §4.6 (the home section, P2, the conclusion, the denial of P2, which class P2 reads), P-20 with a sixth '
                'question, the record constancy-read-at-a-members-class (title and statement extended), 08\'s receipt and '
                f'counts, the root bullet, the checker scope and the README rows; study §{section}. **Left for the PF '
                'line\'s owner** (its wording, unchanged by OC5): the review\'s finding 8, "neither premise can be dropped '
                '*from these laws*" in 07\'s witnesses bullet, the module doc\'s bullet, the root bullet and the checker '
                'scope, and finding 18, "follows each alike occurrence" for "alike step" in the docstrings of '
                '`«本类出类随行»` and `«出类随行»`')
    row = ' | '.join(cells)
    board[queue[0]] = board[queue[0]].replace(HEAD, '', 1)
    del board[rows[0]]
    queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
    assert len(queue) == 1
    board[queue[0]] = board[queue[0]].replace(
        '- **Queue:** ',
        "- **Queue:** OC5 landed (the crux's structure as laws: the reach is exactly that the class holds the effects of "
        "oneself and of each stage of one's line, P4 its first step and P2 one regularity that carries it on, not needed "
        "for it; like P2, the reach excludes a line that ends while its last stage still conditions something; where one "
        "acts, the division outside bears only through one's own leaving effects; core "
        f'receipt `{receipt}`, study §{section}); ', 1)
    text = HISTORY.read_text(encoding='utf-8')
    history = text.split('\n')
    assert len(history) > 600, 'the history file looks cut; restore it first'
    lapsed = history.index('## Lapsed claims (18 October 2026)')
    end = lapsed - 1
    while not history[end].startswith('| '):
        end -= 1
    history.insert(end + 1, row)
    HISTORY.write_text('\n'.join(history), encoding='utf-8')
    assert HISTORY.read_text(encoding='utf-8').count('\n') == text.count('\n') + 1
    BOARD.write_text('\n'.join(board), encoding='utf-8')
    print('board land')
else:
    raise SystemExit(__doc__)
