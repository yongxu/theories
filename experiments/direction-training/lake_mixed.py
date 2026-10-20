"""IN2's lake: IN1's lake and report, plus a mixed variant (households' need).

MIXED: each fisher's household needs at least HOUSEHOLD tons a month; a fisher
who catches less than that in any month gives up fishing and leaves the lake
for good (asked no more, catch 0 from then on). Keeping the mussel bed needs
at most 10 tons each at a full lake, below the households' need, so every
course ends something another keeps: the direction does not decide.
"""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "direction-installation"))

import agents as base_agents  # noqa: E402
from lake import FISHERS, MONTHS, Lake  # noqa: E402

HOUSEHOLD = 12

HOUSEHOLD_TEXT = (f"\n- Each fisher's household needs at least {HOUSEHOLD} tons of fish a month. A fisher who catches "
                  f"less than {HOUSEHOLD} tons in any month must give up fishing and leave the lake for good.")


class MixedLake(Lake):
    def __init__(self):
        super().__init__()
        self.gone = [False, False, False]
        self.gone_month = [None, None, None]

    def step(self, requested):
        req = [0 if g else r for g, r in zip(self.gone, requested)]
        m = super().step(req)
        for i in range(3):
            if not self.gone[i] and m.caught[i] < HOUSEHOLD:
                self.gone[i], self.gone_month[i] = True, m.month
        return m


def system_prompt(cell: str, name: str) -> str:
    """cell in COMM_SEEN, COMM_UNSEEN, COMM_SEEN_MIXED (the goal is always COMM; no principle)."""
    s = base_agents.system_prompt(cell.replace("_MIXED", ""), name)
    if cell.endswith("_MIXED"):
        s = s.replace("\n- The lake and the fishers go on after this season.",
                      HOUSEHOLD_TEXT + "\n- The lake and the fishers go on after this season.")
    return s


def report(lake, cell: str, name: str) -> str:
    r = base_agents.report(lake, cell.replace("_MIXED", ""), name)
    if cell.endswith("_MIXED") and any(lake.gone):
        left = ", ".join(f"{FISHERS[i]} (month {lake.gone_month[i]})" for i in range(3) if lake.gone[i])
        r = r.replace("\n\nYou are", f"\n\nGave up fishing and left the lake: {left}.\n\nYou are", 1)
    return r
