"""What an exact selector of each instruction does (IN1); no model is called.

For the cooperative instructions the three fishers are read as one selector
of the total catch (the community's welfare is the total over the season and
after it). Dynamic programming over the stock (0..100) and the months left,
with the bed's state, for:

  COMM   maximize the community's total catch this season plus a terminal value
         for the stock left at the end (the seasons after it), the bed not read;
  DIR    the direction first: no course in which the bed ends where another
         course keeps it and ends nothing the first keeps; among courses that
         keep the same things, COMM's objective.

Under UNSEEN the selector does not couple into the bed, so it selects as COMM
whatever its instruction says about the bed (Flow.unselected_beyond_coupling,
chapter §7.2 law 1): the exact course of DIR-UNSEEN is COMM's.

Writes results/exact.json.
"""

from __future__ import annotations

import json
from functools import lru_cache
from pathlib import Path

from lake import CAPACITY, COLLAPSE, MONTHS, NEED

# The seasons after this one: a stock s left at the end is worth the catch of
# SEASONS_AFTER further seasons that never let the stock fall (steady_value).
SEASONS_AFTER = 1


def steady_value(s: int) -> int:
    """Total catch over 12 more months from stock s, taking each month the most
    that keeps the next month's stock at least s (the stock never falls)."""
    total = 0
    stock = s
    for _ in range(MONTHS):
        # leave l with min(100, 2l) >= stock: l = ceil(stock / 2)
        leave = -(-stock // 2)
        take = stock - leave
        total += take
        stock = min(CAPACITY, 2 * leave)
    return total


@lru_cache(maxsize=None)
def comm(stock: int, left_months: int) -> tuple[int, int]:
    """(value, best total catch now) for COMM."""
    if left_months == 0:
        return SEASONS_AFTER * steady_value(stock), 0
    best = (-1, 0)
    for take in range(stock + 1):
        left = stock - take
        if left < COLLAPSE:
            v = take  # collapse: nothing after
        else:
            v = take + comm(min(CAPACITY, 2 * left), left_months - 1)[0]
        if v > best[0]:
            best = (v, take)
    return best


@lru_cache(maxsize=None)
def dir_keep(stock: int, left_months: int) -> tuple[int, int]:
    """(value, best total catch now) over courses that keep the bed (left >= NEED
    every month); -1 where none does."""
    if left_months == 0:
        # after the season the bed's need still binds: steady yield keeping >= NEED
        total, s = 0, stock
        for _ in range(MONTHS * SEASONS_AFTER):
            take = max(0, s - NEED)
            total += take
            s = min(CAPACITY, 2 * (s - take))
        return total, 0
    best = (-1, 0)
    for take in range(stock + 1):
        left = stock - take
        if left < NEED:
            continue
        v = take + dir_keep(min(CAPACITY, 2 * left), left_months - 1)[0]
        if v > best[0]:
            best = (v, take)
    return best


def course(policy, stock=CAPACITY):
    out = []
    for m in range(MONTHS, 0, -1):
        _, take = policy(stock, m)
        left = stock - take
        out.append({"stock": stock, "total_catch": take, "left": left})
        if left < COLLAPSE:
            break
        stock = min(CAPACITY, 2 * left)
    return out


def summarize(c):
    return {
        "course": c,
        "season_catch": sum(m["total_catch"] for m in c),
        "bed_kept": all(m["left"] >= NEED for m in c) and len(c) == MONTHS,
        "lake_kept": all(m["left"] >= COLLAPSE for m in c),
        "min_left": min(m["left"] for m in c),
    }


def main():
    res = {
        "COMM": summarize(course(comm)),
        "DIR_SEEN": summarize(course(dir_keep)),
        "DIR_UNSEEN": summarize(course(comm)),
        "note": "COMM and DIR_UNSEEN are the same selection: the bed lies beyond the selector's coupling.",
        "parameters": {"capacity": CAPACITY, "collapse": COLLAPSE, "need": NEED, "months": MONTHS,
                       "seasons_after": SEASONS_AFTER},
    }
    keep_share = res["DIR_SEEN"]["season_catch"] / res["COMM"]["season_catch"]
    res["direction_cost_share"] = round(1 - keep_share, 3)
    Path("results").mkdir(exist_ok=True)
    Path("results/exact.json").write_text(json.dumps(res, indent=1))
    for k in ("COMM", "DIR_SEEN"):
        r = res[k]
        print(k, "season", r["season_catch"], "bed", r["bed_kept"], "lake", r["lake_kept"], "min_left", r["min_left"],
              "takes", [m["total_catch"] for m in r["course"]])
    print("cost of the direction to the community this season:", res["direction_cost_share"])


if __name__ == "__main__":
    main()
