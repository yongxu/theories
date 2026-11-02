#!/usr/bin/env python3
"""UE31: the board edits and the experiments index row, made in a worktree (never the shared checkout); board_ue30.py's pattern.

head: put the clause "UE31 at the head of the queue (landing now: ...); " at the front of the Queue line, behind no
      other "landing now" clause.
land: drop the head clause and put the landed clause first; UE31's row stays open, its state now the design landed
      and the run waiting on Ren's yes.
index: insert the experiment's row in experiments/README.md after formations-that-read's (the index is shared, so
      the row is inserted, not the branch's copy checked out).
dated: in 08 §8's "Where the possible grows", the limit "is outside" dated as 01's Open list dates it (the
      coordinator's fix of 3 November 2026: no current limit worded as permanent).
usage (from the checkout root): python3 -B board_ue31.py head | land | index | dated"""
import re
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
INDEX = Path('experiments/README.md')
INDEX_AFTER = '| [formations-that-read](formations-that-read/README.md) |'
INDEX_ROW = ("| [state-named-in-advance](state-named-in-advance/README.md) | Thesis T2's three numbers against the flour "
             "beetle's life stages, the field's state (the LPA model), on the Beetle Team archive's complete censuses: the "
             "route 08 §9 leaves for the explanatory reading to do more than tie a field (UE31, designed and frozen 3 Nov "
             "2026; nothing downloaded or run; the answer expected, stated before the run: the field's state wins the next "
             "step by the life cycle, the course ties, the lag's sign is the one contrary prediction) |")
NAME = 'UE31'
HEAD_TEXT = ("landing now, by readiness: documents and dry runs only, no data, no Lean and no core run: the design of a "
             "test of T2's three numbers against the flour beetle's life stages, its class, grain, refuter, measured error "
             "and separating statistic frozen before any value is read, one independent reader's findings taken; with it, "
             "the coordinator's fix dating 08 §8's limit on the adjacent possible, the seven records binding 08 re-pointed "
             "after reading; render, strict check, links and tests, then the fast-forward")
HEAD = re.compile(re.escape(NAME) + r' at the head of the queue \([^()]*\); ')
LANDED = ("UE31's design landed (documents and dry runs only: no data, no Lean and no core run): T2's three numbers "
          "against the flour beetle's life stages, the LPA model, on the Beetle Team archive's complete censuses, with "
          "the class, the grain, the refuters, the measured error and the separating statistic frozen before any value is "
          "read. The answer expected is stated before the run: on the next giving the field's state wins by the life "
          "cycle, since the pupae counted now are the next recruits, so T2's class as worded is defeated by a class of "
          "fewer variables (in the dry runs under every generator where the pupae are the recruits to be, T2's own law "
          "included); on the adults' own course T2's three numbers, the lag at the delay of renewal, tie the field's "
          "state by construction, and fail where the life cycle is longer; the one contrary prediction is the lag's "
          "sign, which T2 forbids to change and the field's model changes with density, turning between about 76 and "
          "91 adults by two sets of estimates, one read and one recalled, its rule fixed before the run and read from each culture's "
          "counts without a fit, mostly not expected to decide at the archive's likely size in the field's world, and "
          "if it decides there, to go to the field. So the reading has not shown a class named in advance that does better than a field's state: a "
          "finding recorded now, with two proposals for T2's owner (its wording \"as far as anything in the condition's "
          "own course does\", its lag \"at the delay of renewal\"). One independent reader's findings from three reads "
          "and a narrow fourth taken (DESIGN §13); the download (two files, CC0) and the run wait on Ren's yes. "
          "With it, 08 §8's limit on the adjacent possible that cannot be prestated is dated as 01's Open list dates it "
          "(\"do not yet reach\", not \"is outside\"), the seven records binding 08 re-pointed in their rebinds line, "
          "nothing they say changed. ")
ROW_START = "| **UE31: a state named in advance, against the field's**"
OLD_STATE = "| claimed 2026-11-03 on `2cce0560a`; design in progress |"
NEW_STATE = ("| claimed 2026-11-03 on `2cce0560a`; design landed and frozen (no value read): "
             "[DESIGN](../experiments/state-named-in-advance/DESIGN.md), one independent reader's findings taken (its §13), "
             "the answer expected stated before the run (its §10); the download and the run wait on Ren's yes |")


def queue_line(lines):
    at = [i for i, line in enumerate(lines) if line.startswith('- **Queue:** ')]
    assert len(at) == 1, at
    return at[0]


def head():
    lines = BOARD.read_text(encoding='utf-8').split('\n')
    q = queue_line(lines)
    assert '(landing now' not in lines[q], 'another clause holds the head: ' + lines[q][:200]
    clause = f'{NAME} at the head of the queue ({HEAD_TEXT}); '
    assert HEAD.fullmatch(clause), clause
    lines[q] = lines[q].replace('- **Queue:** ', '- **Queue:** ' + clause, 1)
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('head: UE31 at the head of the queue')


def land():
    lines = BOARD.read_text(encoding='utf-8').split('\n')
    q = queue_line(lines)
    assert len(HEAD.findall(lines[q])) == 1 and lines[q].startswith('- **Queue:** ' + NAME + ' at the head'), 'not at the head'
    lines[q] = HEAD.sub('', lines[q], count=1)
    lines[q] = lines[q].replace('- **Queue:** ', '- **Queue:** ' + LANDED, 1)
    rows = [i for i, line in enumerate(lines) if line.startswith(ROW_START)]
    assert len(rows) == 1, rows
    assert lines[rows[0]].count(OLD_STATE) == 1, 'the row state'
    lines[rows[0]] = lines[rows[0]].replace(OLD_STATE, NEW_STATE, 1)
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('land: clause written, the row\'s state updated')


M08 = Path('theories/becoming/chapters/08-METHOD.md')
OUTSIDE = ("The adjacent possible that cannot be prestated (Longo, Montévil and Kauffman 2012) is outside. "
           "Each law is near-definitional or a witness.")
DATED = ("These laws do not yet reach the adjacent possible that cannot be prestated (Longo, Montévil and Kauffman "
         "2012): none is stated for a space of rules not given with the carrier ([01](01-ROOT.md#open)). "
         "Each law is near-definitional or a witness.")


def dated():
    s = M08.read_text(encoding='utf-8')
    assert s.count(OUTSIDE) == 1 and DATED not in s, 'the sentence'
    M08.write_text(s.replace(OUTSIDE, DATED, 1), encoding='utf-8')
    print('dated: 08 §8 sentence reworded')


def index():
    lines = INDEX.read_text(encoding='utf-8').split('\n')
    assert not any(line.startswith('| [state-named-in-advance]') for line in lines), 'the row is there already'
    at = [i for i, line in enumerate(lines) if line.startswith(INDEX_AFTER)]
    assert len(at) == 1, at
    lines.insert(at[0] + 1, INDEX_ROW)
    INDEX.write_text('\n'.join(lines), encoding='utf-8')
    print('index: row inserted after line', at[0] + 1)


if __name__ == '__main__':
    if sys.argv[1:] == ['head']:
        head()
    elif sys.argv[1:] == ['index']:
        index()
    elif sys.argv[1:] == ['dated']:
        dated()
    elif sys.argv[1:] == ['land']:
        land()
    else:
        sys.exit(__doc__)
