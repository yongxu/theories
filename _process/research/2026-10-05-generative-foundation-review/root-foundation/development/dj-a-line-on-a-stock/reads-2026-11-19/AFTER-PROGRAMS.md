# What the programs returned

*AI-written (Claude Fable), 19 November 2026, 22:26 WIB by the clock, after `FROZEN-LOCK-ON-UNITS.md` (frozen 22:10; its hash is in `FROZEN.sha256`, the programs' in `PROGRAMS.sha256`). A search over small numbers shows where a statement fails; it does not show that it never does. Nobody but the writer had read these when this was written; four AI readers were at work.*

## One difference from the frozen text

The frozen text says the rule is set again by a reading of the share "of the new way". The programs read the share **before** the step, as the Lean's turn does (`TurningInTime.regroup_step`). Every count below is for that reading.

## What was run

Two kinds of unit, F (the favoured one) and O; two rules, one of which favours; the share is the number of F (first table) or F's proportion (second); the reading is a threshold on the share; the giving is a tent, which gives nothing from nothing and keeps the level within a bound `c` (8 or 12). `lock_on_units.py` starts every course locked with every need met. It asks `Raises` (the share not lowered under the favouring rule) only at the ways a course visits, not of every way as the Lean's `Raises` does; needs are odd numbers only.

| | count share | proportion share |
|---|---|---|
| instances | 10,707,552 | (same range) |
| L-a checked, failures | 1,824,162, 0 | 1,230,192, 0 |
| L-b checked, failures | 948,072, 0 | 487,158, 0 |
| L-b with offspring needing no more than their parent: the level at the first unmet need is not below a need the start met | 0 | 0 |
| L-b with only F's offspring taking more (O's no less): checked, failures | 271,137, 0 | 128,712, 0 |

## Against K2 (the lock does no work)

Six pairs were found (the search stops at six). One: bound 8, needs (1, 1), uses (1, 1); under the favouring rule F leaves two O, O leaves one F and one O; under the other rule each leaves itself. From one F, one O, the favouring rule, level 6:

- read with threshold 1 (locked): (1, 1, level 6), (1, 3, level 8), (3, 5, level 8), (5, 11, level 0): it ends;
- read with threshold 2 (not locked): (1, 1, level 6), (1, 3, rule not favouring, level 8), and the same again: it never ends.

The two differ in the reading's threshold, not in the units or the start. Whether that is a fair showing is the refuting reader's question. *(Corrected 22:42 after the refuting reader: in all six pairs F leaves no F under the favouring rule, so `Raises` of every way fails; they do not meet the lock's premise as the Lean states it. The reader's own pairs are in `reader-refute.md`.)*

## After the first unmet need (L-c, K4)

`lock_on_units_2.py`, on the instances L-b covers, by premises:

| premises | ends, still locked | ends, the lock left | never ends |
|---|---|---|---|
| every unit's offspring take more; offspring need no more | 582,932 | 30,604 | 0 |
| every unit's offspring take more; some offspring needs more | 1,633,076 | 18,548 | 3,016, still locked |
| only F's offspring take more; offspring need no more | 231,234 | 40,376 | 0 |
| only F's offspring take more; some offspring needs more | 370,980 | 5,152 | 1,056, still locked |

The "never ends, still locked" courses have offspring born each step into a need that is never met: bound 8, needs (1, 5), uses (1, 1), F leaves one F and one O, O leaves two O; from (1 F, level 3): (1, 0, level 3), (1, 1, level 4), (1, 1, level 4). With offspring needing no more than their parent, none was found.

`lock_on_units_3.py`, a wider search with offspring needing no more than their parent: ends still locked 14,640,576; ends with the lock left 3,735,068; **never ends with the lock left 10,276**. One: bound 12, needs (7, 1), uses (4, 1); under the favouring rule F leaves one F and one O, O leaves itself; from one F at level 7: (1, 0, level 7), (1, 1, level 6), (0, 1, level 2), then the rule no longer favours and (0, 1, level 2) repeats. F's need went unmet at level 6, F ended, O goes on. The start there already takes more than the level gives back (one F taking 4 at level 7). No never-ending course still locked was found in this search.

So three outcomes were found, not two; the third (the lock left and the rest goes on) only in the wider search, and in the example from a start that already overdraws.

## L-d (K7)

`lock_on_units_4.py`. As frozen, L-d is **false**: where O's need is above O's point of no return (`H + y` in `two_units_iff`'s terms) the two sides differ in 3,648 instances (the right side holds, the line ends) and agree in 6,612,456 (6,611,652 end, 804 never end). Where O's need is at most that point they agree in all 1,217,496 (1,214,068 end, 3,428 never end). That added premise is the one `WayOfUnits.two_units_iff` and `TurningInTime.unending_iff_above` carry. Whether L-d is then anything but `two_units_iff` applied after the favoured kind has gone is the refuting reader's question.

*Corrected 22:42 WIB after the refuting reader's check: the L-d agreement count (it read 804, the never-ending ones only), and the two limits of the first program now said under "What was run".*
