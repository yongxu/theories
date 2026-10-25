# Proposed revision of 08 §7's finite-runs row

AI-written proposal, 26 October 2026, for board item OU3b-3 (review finding F2). The chapter is not edited here. The row goes in through the record at landing.

## Current row

| Law | Statement | Anchor | Central declarations on it |
|---|---|---|---:|
| Finite runs | where a list holds every configuration, a law merges nothing exactly where every configuration returns (`Law.lossless_iff_returns`); for every law, with no list, a configuration is drawn exactly where it does not return (`Law.drawn_iff_not_returns`); rest is a case of being drawn | `Branching.Returns`, `Amounts.rests` | 14 |

## Proposed row

| Law | Statement | Anchor | Central declarations on it |
|---|---|---|---:|
| Finite runs | where a list holds every configuration, a law merges nothing exactly where every configuration returns (`Law.lossless_iff_returns`); for every law, with no list, a configuration is drawn exactly where it does not return (`Law.drawn_iff_not_returns`); where every course of no rise then a least fall ends, falls along a line that does not rise do not recur, and within a finite budget a least loss makes those courses end (`Amounts.rests`); rest is not a case of being drawn | `Branching.Returns`, `Amounts.rests` | (recount at landing) |

## Why

The current clause "rest is a case of being drawn" is false on the grammar, and `Becoming.GrammarLaws` proves both directions of its failure:
- A fixed point is at rest and is not drawn (`«止而不入之例»`).
- A place can be drawn in while its marked steps recur (`«入而屡之例»`).

What gives rest is the ending of the courses (`«尽»`), a sufficient condition, not an identification. Where every course of no rise then a least fall ends from a line's place, the falls along the line do not recur (`«尽则不或屡»`). This holds as far as can be refuted, with no decision and no choice, and also outright (`«尽则不屡»`). `Amounts.rests_unrefuted`, and through it `Amounts.rests`, are now proved from this law. `Amounts.falls_end` gives the ending: within fewer than `m` least losses, every such course ends. `Amounts.FallsStop` is, by definition, the non-recurrence of strict falls (`Amounts.fallsStop_iff`).

The proposed clause names the mechanism (the ending gives rest) and keeps the anchor. A finite budget is one way to reach the ending, not the only one. No converse, from rest along a line to the ending of the courses, is established; a review found the general form fails even classically for arbitrary steps (REVIEW-ASTRA-3.md, finding 1).

If the chapter wants one phrase for the row's third clause: **the ending of the falls gives rest; rest is not being drawn**.
