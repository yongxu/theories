# What the programs returned

*AI-written (Claude Fable), 20 November 2026, 09:48 WIB by the clock, after `FROZEN-REGIONS.md` (09:40; hash in `FROZEN.sha256`; the programs' in `PROGRAMS.sha256`). A search over small numbers shows where a statement fails, not that it holds. When this was written nobody but the writer had read the programs or these numbers. Every process here is the writer's construction: the Lean's courses of November have no moves in them.*

Programs: `regions.py` (`three`, `course`, `sweep`) and `regions_2.py` (`anti`, `clocks`, `other0`), with `results-*.json`. Regions, innermost first: **K** kept whatever the moves; **const** kept by one rule held for ever; **mono** kept by a reading of the lock's kind (rule 1 where the number of F is at least a threshold); **share** kept by some function of the number of F; **share+level**; **Kp** kept by some sequence of moves; **none**. Unless said, a move sets the rule in force at the next step, and the rule that does not favour is a standstill (each unit leaves itself).

## `Three` (the take in force five or three; the level gives back `min z (12 − z)`; need one)

Kept by some takes: with three in force, from level 6 up; with five in force, from level 8 up. Kept whatever the takes: with three in force from 8 up, with five in force from 10 up. From nine as it was, taking five: (five, 9) and (five, 8) are kept by some takes, (five, 6) and (five, 2) by none. So the last configuration from which a turn keeps it is at step 1. The Lean's `noReturn` names step 3 for the same course; whether the two say the same thing under their two ways of counting is a reader's question.

## The course of 19 November (bound 32, needs 27 and 1, uses 14 and 1)

At the start, one favoured unit at level 28 with the favouring rule in force:

| what is asked | region |
|---|---|
| something goes on | const: one rule held keeps it (the rule that does not favour); not K, since the rule held favouring ends it |
| a favoured unit goes on | none: no course keeps it |
| the level stays at least 20 | const |

Along the course with the rule set again from the share, every configuration is in const for "something goes on". Along the twin with the rule held favouring, the configurations are the same up to step 3; at step 4 the twin has the favouring rule in force over twelve small units at level 24 and is in none. So the rule set again from the share stopped favouring at the last step at which that could still keep anything.

With the move setting the rule of this step and not the next, the start is in const for the favoured unit too: one step's difference in when a rule takes hold decides whether the counted unit could have been kept.

**With the counted unit's need 26 and not 27** (the astra reader's prediction, G5): the start is in const, and the next configuration (one favoured, one small, the favouring rule in force, level 28) is in none. The course ends at step 4 with the rule favouring throughout; the share never moved. Holding the rule that does not favour from the start, something goes on for ever.

## The sweep (5,184 instances, bounds 8 and 12; 670,464 configurations in which something goes on)

| what is asked | none | const | K | mono | share | share+level | Kp only |
|---|---|---|---|---|---|---|---|
| something goes on | 402,866 | 215,992 | 51,506 | 0 | 9 | 91 | 0 |
| a favoured unit goes on | 273,431 | 129,404 | 32,588 | 0 | 9 | 24 | 0 |
| a unit of the other kind goes on | 337,662 | 139,651 | 20,344 | 0 | 0 | 7 | 0 |

- Nearly everything that some course keeps is kept by one rule held for ever. A reading of the lock's kind keeps nothing here that one rule held does not.
- Of the 100 configurations kept by some course and by no one rule held: 9 are kept by a reading of the reverse kind (favour while the favoured are below a threshold, stop above it) and by no reading of the lock's kind; 91 are kept by no function of the share at all, and are kept by the share and the level together (`results-anti.json`).
- The kind's region is not the way's region in 1,359 configurations for the favoured kind and 21,261 for the other.
- With the move setting the rule of this step: 310 share and 18 share+level, of 335,232 configurations.

## Where the rule that does not favour is not a standstill (bound 8 only; `results-other0.json`)

| the rule that does not favour | none | const | K | mono | share | share+level | Kp only |
|---|---|---|---|---|---|---|---|
| each leaves itself | 175,126 | 61,636 | 15,495 | 0 | 0 | 31 | 0 |
| F leaves itself and an O, O itself | 217,258 | 29,734 | 5,233 | 0 | 0 | 7 | 56 |
| F leaves itself, O two O | 216,207 | 26,903 | 7,304 | 0 | 260 | 1,182 | 432 |
| F leaves two F, O nothing | 239,213 | 12,355 | 0 | 667 | 2 | 27 | 24 |

So "nearly everything kept is kept by one rule held" belongs to the standstill. With two rules that both change the way, configurations kept by some course and by no choice from the share are 1,614 of 36,081 kept in the third row.

## The clocks, along each lock's own course (rule 1 in force, read by threshold 1), from starts that some course keeps (`results-clocks.json`)

| | courses |
|---|---|
| never ends; the start is kept whatever the rule | 16,986 |
| never ends; the rule favours throughout | 280 |
| never ends; the rule stops favouring at some step | 144 |
| ends; the rule favours to the end | 34,611 |
| ends; the rule stopped favouring after the point of no return | 96 |
| ends; the rule stopped favouring at or before the point of no return | 0 |

The lock's courses from starts that no course keeps (200,171 in the sweep, all ending) are not in this table.

## Against the guesses, by the writer's reading only

G1 (`Three` is not new): for a reader. G2 (two notions of "some course keeps it"): for a reader. G3 (a gap on the units): it is there and small with a standstill (91 of 267,598 kept), larger without one. G4 (grain sorts the course of 19 November): as guessed. G5: as predicted. G6 (the clocks come in one order): the order is forced; what differs is whether the reading moves at all before the point of no return, and in this family it almost never does.
