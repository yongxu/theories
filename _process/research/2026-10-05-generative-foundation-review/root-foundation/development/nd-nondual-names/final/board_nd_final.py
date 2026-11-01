#!/usr/bin/env python3
"""ND's final stage: the board edits, made in a worktree (never the shared checkout); board_bd4.py's pattern.

head: put ND's clause at the head of the Queue line, behind no other "landing now" clause; the coordinator's order
      sentence is kept as it stands.
landed N: replace ND's head clause with the landed one, followed by the coordinator's order sentence, given verbatim
      in ND_ORDER (required: the coordinator sends it with its word, computed from what is still queued), and move
      ND's row to the history file (titled done, its status the landing, its links rebased there), after the last
      landed row.
usage (from the checkout root): python3 -B board_nd_final.py head | landed N"""
import datetime
import os
import re
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
TITLE = "| **ND: names that state relations, not rule (master law; law's senses; obeying and good)**"
HEAD = ("ND's final stage at the head of the queue (landing now: the record id master-laws-on-the-grammar renamed "
        "shared-laws-on-the-grammar by research.py rename-id, the old id kept in former_ids; the view's generator, "
        "data and test renamed shared_laws.py, shared-laws.json and test_shared_laws.py, and its keys and category "
        "values named for shared laws; documents and tools only, no Lean, no new record and no core run; the "
        "connectivity and the view regenerated from the checker's cache; then render, strict check, links and "
        "tests, then the fast-forward); ")


def queue(text):
    lines = text.split('\n')
    i = [k for k, l in enumerate(lines) if l.startswith('- **Queue:** ')]
    assert len(i) == 1, i
    return lines, i[0]


def head():
    lines, i = queue(BOARD.read_text(encoding='utf-8'))
    line = lines[i]
    assert '(landing now' not in line, 'another clause holds the head: ' + line[:200]
    assert sum(l.startswith(TITLE) for l in lines) == 1, 'ND not claimed'
    lines[i] = '- **Queue:** ' + HEAD + line[len('- **Queue:** '):]
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print("head: ND's final stage at the head")


def landed(n):
    lines, i = queue(BOARD.read_text(encoding='utf-8'))
    line = lines[i]
    assert line.startswith('- **Queue:** ' + HEAD), "ND's final stage does not hold the head"
    clause = (f"ND's final stage landed (§{n}, documents and tools only: no Lean, no new record and no core run): "
              "the record id master-laws-on-the-grammar renamed shared-laws-on-the-grammar by research.py "
              "rename-id, the old id in former_ids and its page a redirect, links and mentions in the live texts "
              "rewritten; "
              "paths, old → new: tools/research/master_laws.py → tools/research/shared_laws.py; tools/research/tests/test_master_laws.py → tools/research/tests/test_shared_laws.py; theories/becoming/results/data/master-laws.json → theories/becoming/results/data/shared-laws.json; the record id master-laws-on-the-grammar → shared-laws-on-the-grammar (theories/becoming/results/records/master-laws-on-the-grammar.json → shared-laws-on-the-grammar.json, the old .md a redirect); every kit script on main calling them by path updated, paths only, no shim under the old names; "
              "the view's generator, data and test renamed shared_laws.py, shared-laws.json and "
              "test_shared_laws.py, and in the research tools, the two measure scripts and the connectivity script "
              "every key, identifier and category value naming a master law names a shared law; the connectivity "
              "and the view regenerated from the checker's cache, equal to the old ones but for the names; 08 §10's "
              "sentence on where the old name stays, the glossary's note, the workflow's section on the view, the "
              "Lean README's two rows, regions.json, the coverage file's key and the connectivity register's "
              "reasons, `Concave.roots`'s naming rises_superadditive; the checker's scope text proposed for the next "
              "core landing; the records citing the changed texts re-pointed, nothing they say changed; ND's row in "
              "the history file; render, strict check, links, tests and both dossier checks pass. ")
    rest = line[len('- **Queue:** ' + HEAD):]
    steps = os.environ.get('ND_ORDER', '').strip()
    assert steps, "ND_ORDER, the coordinator's order sentence sent with its word, is required"
    assert 'ND' not in steps.split(), steps
    print('landed: order after ND:', steps)
    clause += f"Then, in the coordinator's order: {steps}; ask the coordinator for a slot. "
    lines[i] = '- **Queue:** ' + clause + rest
    rows = [k for k, l in enumerate(lines) if l.startswith(TITLE)]
    assert len(rows) == 1, rows
    row = lines.pop(rows[0])
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    row = row.replace(TITLE, TITLE[:-2] + ', done**', 1)
    cells = row.split(' | ')
    assert len(cells) == 5, len(cells)
    cells[2] = (f'claimed 1 November 2026; part 1 (documents) landed (§486); part 2, the Lean renames and docstrings, '
                f'landed with OU7 (§492, stage 20-nd); the final stage landed {datetime.date.today().isoformat()}, '
                f'study §{n}: the record id by research.py rename-id, the view\'s generator and data, keys and '
                'category values; findings passed to DU, the front pages kit and the collective page\'s owner '
                '(COLD-READ.md); the checker\'s scope text proposed for the next core landing')
    row = ' | '.join(cells)
    row = re.sub(r'\]\(\.\./theories/', '](../../../theories/', row)
    row = re.sub(r'\]\(research/', '](../../research/', row)
    row = re.sub(r'\]\(\.\./sources/', '](../../../sources/', row)
    hist = HISTORY.read_text(encoding='utf-8').split('\n')
    lapsed = hist.index('## Lapsed claims (18 October 2026)')
    k = lapsed - 1
    while k > 0 and not hist[k].startswith('| **'):
        k -= 1
    hist.insert(k + 1, row)
    HISTORY.write_text('\n'.join(hist), encoding='utf-8')
    print(f'landed: clause written, row moved after history line {k + 1}')


if __name__ == '__main__':
    if sys.argv[1:] == ['head']:
        head()
    elif len(sys.argv) == 3 and sys.argv[1] == 'landed':
        landed(int(sys.argv[2]))
    else:
        sys.exit(__doc__)
