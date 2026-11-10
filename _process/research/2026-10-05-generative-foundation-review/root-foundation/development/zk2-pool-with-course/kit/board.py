#!/usr/bin/env python3
"""K2's board edits for its landing (AI-written kit, 10 November 2026).

usage:
  python3 -B board.py held BOARD                      print every head clause on the Queue line; exit 1 if any
  python3 -B board.py head BOARD                      put K2's head clause first on the Queue line
  python3 -B board.py landed BOARD HISTORY TIP RECEIPT
      replace K2's head clause with its landed clause and move K2's row to the history file

Every edit keeps the Queue line one line, keeps every other clause, and checks its length.
"""
import re
import sys

HEAD_RE = re.compile(r"at the head of the queue|at the head \(landing|\(landing now")
QUEUE = "- **Queue:** "
HEAD = ("K2 at the head of the queue (landing now: `Becoming.PoolFromCourse`, a core leaf; 02 §10 \"Readers the "
        "course removes\"; three records; nothing paid); ")
ROW_START = "| **K2: "


def read(path):
    return open(path, encoding="utf-8").read()


def queue_index(lines):
    found = [i for i, l in enumerate(lines) if l.startswith(QUEUE)]
    assert len(found) == 1, found
    return found[0]


def heads(queue):
    clauses = queue[len(QUEUE):].split("; ")
    return [c for c in clauses if HEAD_RE.search(c)]


def held(board):
    lines = read(board).split("\n")
    hs = heads(lines[queue_index(lines)])
    for h in hs:
        print("HEAD:", h[:300])
    return 1 if hs else 0


def head(board):
    s = read(board)
    lines = s.split("\n")
    i = queue_index(lines)
    assert not heads(lines[i]), heads(lines[i])
    before = len(lines[i])
    lines[i] = QUEUE + HEAD + lines[i][len(QUEUE):]
    assert len(lines[i]) == before + len(HEAD)
    open(board, "w", encoding="utf-8").write("\n".join(lines))
    print("head clause added; Queue line", before, "->", len(lines[i]))
    return 0


def landed(board, history, tip, receipt):
    landed_clause = (
        f"K2 landed (content tip `{tip}`; a core leaf and texts, nothing paid; core receipt `{receipt}`, every axiom "
        "report empty): readers the course removes, the meta-attractor as a dynamic (`Becoming.PoolFromCourse`, 02 §10): "
        "the rule read through a pool whose readers of what lies beyond the share stand only where the course leaves "
        "them; a lock read off the share is left only along a stretch with a reading step read otherwise or a fall of "
        "the share, and closed it stays closed; readers a loss removes are not readmitted, and past their bound the "
        "course is the share's own loop whatever they read; with the loss drawn monotonically off the share two courses "
        "keep their order, the bound reversed (the higher the share, the sooner the readers go); a loss borne by the "
        "shapers is a cost on the rule after shaping, by the others a return; witnesses `Drained` and `Borne`; records "
        "`a-pool-read-off-the-course`, `the-lock-draws-its-readers-out`, `on-whom-the-loss-falls`")
    assert "\n" not in landed_clause
    s = read(board)
    lines = s.split("\n")
    i = queue_index(lines)
    q = lines[i]
    assert q.startswith(QUEUE + HEAD), q[:200]
    others_before = q[len(QUEUE) + len(HEAD):]
    assert not heads(QUEUE + others_before), heads(QUEUE + others_before)
    lines[i] = QUEUE + landed_clause + "; " + others_before
    assert lines[i].endswith(others_before)
    rows = [k for k, l in enumerate(lines) if l.startswith(ROW_START)]
    assert len(rows) == 1, rows
    row = lines.pop(rows[0])
    cells = row.split(" | ")
    assert len(cells) == 5, len(cells)
    cells[0] = cells[0].replace(
        "| **K2: the meta-attractor as a dynamic: a selection whose pool of readers is read off its own course**",
        "| **K2: the meta-attractor as a dynamic: a selection whose pool of readers is read off its own course, done**")
    cells[2] = (cells[2] + f"; landed (content tip `{tip}`, core receipt `{receipt}`, [the note](../../research/"
                "2026-10-05-generative-foundation-review/root-foundation/development/zk2-pool-with-course/NOTE.md)): "
                "`Becoming.PoolFromCourse`, the records `a-pool-read-off-the-course`, `the-lock-draws-its-readers-out` "
                "and `on-whom-the-loss-falls`, 02 §10; the atlas entry and exits sent to K4; left to the next pieces: "
                "presence read off K1's lines, readers reading late inside a window the loss closes (K3)")
    row = " | ".join(cells)
    row = row.replace("](../sources/", "](../../../sources/").replace("](research/", "](../../research/")
    open(board, "w", encoding="utf-8").write("\n".join(lines))
    h = read(history).split("\n")
    marker = [k for k, l in enumerate(h) if l.startswith("### The batched precision pass, taken by edition 5")]
    assert len(marker) == 1, marker
    k = marker[0]
    assert h[k - 1].startswith("| **"), h[k - 1][:80]
    h.insert(k, row)
    open(history, "w", encoding="utf-8").write("\n".join(h))
    print("landed clause written; Queue line", len(q), "->", len(lines[i]), "; row moved to history")
    return 0


def main():
    cmd = sys.argv[1]
    if cmd == "held":
        return held(sys.argv[2])
    if cmd == "head":
        return head(sys.argv[2])
    if cmd == "landed":
        return landed(*sys.argv[2:6])
    raise SystemExit(__doc__)


if __name__ == "__main__":
    sys.exit(main())
