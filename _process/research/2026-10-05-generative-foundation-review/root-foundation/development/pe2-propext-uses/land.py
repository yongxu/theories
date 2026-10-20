#!/usr/bin/env python3
"""PE2 landing: append the study section under the next free number, move the board row to the
history file with a queue note, and update the record. Run from the repository root on a branch
that holds main's head and this kit; then `make research-render` and the checks.

usage: land.py
"""
import re
import subprocess
from pathlib import Path

KIT = Path("_process/research/2026-10-05-generative-foundation-review/root-foundation/development/pe2-propext-uses")
STUDY = Path("_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md")
BOARD = Path("_process/BECOMING-WORKBOARD.md")
HISTORY = Path("_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md")

study = STUDY.read_text()
assert "(PE2)\n" not in study, "already landed"
number = max(int(n) for n in re.findall(r"^## (\d+)\. ", study, re.M)) + 1
section = re.sub(r"^## \d+\. ", f"## {number}. ", (KIT / "section.md").read_text(), count=1)
STUDY.write_text(study.rstrip("\n") + "\n\n" + section)

board = BOARD.read_text()
start = board.index("| **PE2:")
end = board.index("\n", start) + 1
cells = board[start:end].rstrip("\n").split(" | ")
cells[2] = ("landed 2026-10-20, docs and records only, no checker run; 489 periphery declarations and 196 "
            "core injEq lemmas classified, no periphery value computed through an identification of "
            f"propositions; record proposition-identity; study §{number}")
row = " | ".join(cells) + "\n"
board = board[:start] + board[end:]
board = board.replace("- **Queue:** ", "- **Queue:** PE2 landed (every periphery use of `propext`, use by use: "
                      "proofs identify interderivable propositions, no definition computes a value through one; "
                      f"docs and records only, no checker run; study §{number}, row in the history file); ", 1)
BOARD.write_text(board)
history = HISTORY.read_text()
at = history.index("\n", history.index("| **PE1:")) + 1
HISTORY.write_text(history[:at] + row + history[at:])

subprocess.run(["python3", "-B", str(KIT / "update_record.py"), str(number)], check=True)
print("section", number)
