#!/usr/bin/env python3
"""FA's board edits (board_rv21c.py's pattern), never in the shared checkout.

claim BOARD: insert FA's row after RV21c's, in a gap with no head clause (the coordinator's word of 31 October).
head BOARD: put FA's clause, "FA at the head of the queue (landing now: ...); ", at the front of the Queue line,
      behind no other "landing now" clause.
release BOARD REASON: drop FA's head clause and nothing else.
land DATE ORDER: in the landing worktree, drop FA's head clause and put the landed clause first; move FA's row, its
      state the landing on DATE (YYYY-MM-DD), to the history file after the last landed row (links rebased there).
      ORDER is the coordinator's sentence naming what comes after, given verbatim.
BOARD is a copy of main's board for the commits made without a worktree (board_commit.sh); land edits the checkout's.
usage (from the checkout root): python3 -B board_fa.py claim BOARD | head BOARD | release BOARD REASON | land DATE ORDER
"""
from pathlib import Path
import re
import sys

BOARD = Path("_process/BECOMING-WORKBOARD.md")
HISTORY = Path("_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md")
WORK = "research/2026-10-05-generative-foundation-review/root-foundation/development/formation-accounts-renames"
HEAD = re.compile(r"FA at the head of the queue \([^()]*\); ")
ROW = "| **FA: "
NAMES = ("`AccountLaw` → `SustainLaw`, `credited` → `arrivalEvent` and `support_trace_balance` → "
         "`support_trace_bound`")

CLAIM = (
    "| **FA: RV21c's prerequisite, FormationAccounts.lean brought to 51a975fdd's renames** (routed by the coordinator "
    "on 31 October 2026, from RV21c's rehearsal). Purpose: everything on main runs, so an outside verifier can repeat "
    "each check (RV21c). `formation/formal/FormationAccounts.lean` has not compiled on main since 6 October: the "
    f"vocabulary rename `51a975fdd` renamed {NAMES} in `conditional/ResourceContinuation.lean` and its users but "
    "missed this file, so `formal/check.py` fails there (elaboration errors, `sorryAx` in `root_account_balance`), and "
    "RV21c's older-layout step (formal first, then evolution and development, which inherit formal's receipt) cannot "
    "renew. The three identifiers only, each a pure rename in 51a975fdd's diff (the same statement and body, binder "
    "names aside; `f11eb55d6` later rewrote only `support_trace_bound`'s proof), so every statement of the file keeps "
    "its meaning; no other renaming (`root_account_balance` and the file name stay); `formal/check.py` passing with a "
    "clean dependency audit and no `sorryAx`, its receipt renewed in place; strict check, links and render in a clean "
    "worktree; one short head for the landing, no core run "
    "| Claude Code desktop session (the comprehensive review), 31 October 2026, for the coordinator "
    "| claimed 31 October 2026; the fix and its receipt prepared on branch `formation-accounts-renames`, nothing landed "
    "| `formation/formal/` (FormationAccounts.lean, the README's count of the conditional module's audits, "
    "verification.json, verification/), `development/formation-accounts-renames/` "
    "| → RV21c's older-layout step (all three renewed) |")

CLAUSE = ("FA at the head of the queue (landing now: `formation/formal/FormationAccounts.lean` brought to 51a975fdd's "
          "three renames, its formal receipt renewed in place and the README's count of the conditional module's "
          "audits; no other Lean, no record and no core run; then render, strict check, links and tests, then the "
          "fast-forward); ")


def queue_line(lines):
    at = [i for i, line in enumerate(lines) if line.startswith("- **Queue:** ")]
    assert len(at) == 1, at
    return at[0]


def read(board):
    return board.read_text(encoding="utf-8").split("\n")


def claim(board):
    lines = read(board)
    assert not any(line.startswith(ROW) for line in lines), "FA's row is already on the board"
    assert "(landing now" not in lines[queue_line(lines)], "a clause holds the head: claim in a gap"
    at = [i for i, line in enumerate(lines) if line.startswith("| **RV21c: ")]
    assert len(at) == 1, at
    assert len(CLAIM.split(" | ")) == 5
    lines.insert(at[0] + 1, CLAIM)
    board.write_text("\n".join(lines), encoding="utf-8")
    print("claim: FA's row after RV21c's")


def head(board):
    lines = read(board)
    q = queue_line(lines)
    assert "(landing now" not in lines[q], "another clause holds the head: " + lines[q][:200]
    assert any(line.startswith(ROW) for line in lines), "FA's row is not on the board: claim first"
    assert HEAD.fullmatch(CLAUSE)
    lines[q] = lines[q].replace("- **Queue:** ", "- **Queue:** " + CLAUSE, 1)
    board.write_text("\n".join(lines), encoding="utf-8")
    print("head: " + CLAUSE)


def release(board, why):
    lines = read(board)
    q = queue_line(lines)
    assert lines[q].startswith("- **Queue:** FA at the head") and len(HEAD.findall(lines[q])) == 1, "FA does not hold the head"
    lines[q] = HEAD.sub("", lines[q], count=1)
    board.write_text("\n".join(lines), encoding="utf-8")
    print("released: " + why)


def land(date, order):
    assert re.fullmatch(r"\d{4}-\d{2}-\d{2}", date), date
    assert order.startswith("Then") and order.endswith("."), order
    lines = read(BOARD)
    rows = [i for i, line in enumerate(lines) if line.startswith(ROW)]
    assert len(rows) == 1, rows
    cells = lines[rows[0]].split(" | ")
    assert len(cells) == 5, len(cells)
    # The claim, brought to what was done before the row moves: the proof rewrite is said of the three only.
    a = "`f11eb55d6` later rewrote only `support_trace_bound`'s proof"
    assert cells[0].count(a) == 1, a
    cells[0] = cells[0].replace(a, "of the three, `f11eb55d6` later rewrote only `support_trace_bound`'s proof")
    cells[2] = (f"landed {date}: the three identifiers renamed, nothing else in the file; `formal/check.py` passes "
                "(68 declarations audited, every axiom report the same as on 5 October or smaller), its receipt "
                "renewed in place; the README's count of the conditional module's audits 21 → 24; kit and logs in "
                f"[formation-accounts-renames](../../{WORK}/)")
    row = " | ".join(cells)
    row = re.sub(r"\]\(research/", "](../../research/", row)
    row = re.sub(r"\]\(\.\./sources/", "](../../../sources/", row)
    del lines[rows[0]]
    q = queue_line(lines)
    assert lines[q].startswith("- **Queue:** FA at the head") and len(HEAD.findall(lines[q])) == 1, "FA not at the head"
    lines[q] = HEAD.sub("", lines[q], count=1)
    landed = ("FA landed (one Lean file, its receipt and its README; no record and no core run: "
              "`formation/formal/FormationAccounts.lean`, which had not compiled on main since the vocabulary rename "
              f"of 6 October missed it, brought to 51a975fdd's three renames, {NAMES}, each a pure rename in that "
              "commit's diff, so every statement of the file keeps its meaning, and nothing else renamed; "
              "`formal/check.py` passes, 68 declarations audited with a clean dependency audit and no `sorryAx`, "
              "every axiom report the same as on 5 October or smaller; its receipt renewed in place, and the README's "
              "count of the conditional module's audits brought to the 24 it now records; FA's row in the history "
              f"file; render, strict check, links and tests pass). {order} ")
    lines[q] = lines[q].replace("- **Queue:** ", "- **Queue:** " + landed, 1)
    BOARD.write_text("\n".join(lines), encoding="utf-8")
    history = read(HISTORY)
    lapsed = history.index("## Lapsed claims (18 October 2026)")
    end = lapsed - 1
    while not history[end].startswith("| "):
        end -= 1
    history.insert(end + 1, row)
    HISTORY.write_text("\n".join(history), encoding="utf-8")
    print(f"land: clause written, row moved after history line {end + 1}")


if __name__ == "__main__":
    mode = sys.argv[1:2]
    if mode == ["claim"] and len(sys.argv) == 3:
        claim(Path(sys.argv[2]))
    elif mode == ["head"] and len(sys.argv) == 3:
        head(Path(sys.argv[2]))
    elif mode == ["release"] and len(sys.argv) == 4:
        release(Path(sys.argv[2]), sys.argv[3])
    elif mode == ["land"] and len(sys.argv) == 4:
        land(sys.argv[2], sys.argv[3])
    else:
        raise SystemExit(__doc__)
