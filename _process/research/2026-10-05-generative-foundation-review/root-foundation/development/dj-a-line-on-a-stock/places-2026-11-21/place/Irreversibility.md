# Irreversibility

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Irreversibility.lean`
- *result records that name this place's file as a source* (computed; not a link): `endpoint-loss-and-return`
- *dynamics in the atlas that name one of those records* (computed; not a link): `necessarily-drawn-is-not-returning`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-08, as "Irreversibility.lean: deadEnd_no_return, same_change_different_return, constant_reading_hides_loss" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-08.md.txt)); pass b: reader whole-b-30, as "Irreversibility.lean: deadEnd_no_return, same_change_different_return, constant_reading_hides_loss, flip" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-30.md.txt)); the third pass, where the two differed: reader whole-c-settle-11, as "Irreversibility.lean: settled fields moves, closed_region" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-11.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* B: From false, both DeadEnd.law and flip take the same one-action trace to true, but only flip reaches false again (same_change_different_return, l. 41). In the dead end, every existential reach question on the constant reading agrees from the two starts despite loss of return (constant_reading_hides_loss, l. 50).
  - *pass b:* Of the core's dead end (`DeadEnd.law`) and the built `flip` on Bool: the dead end never reaches false from true (`deadEnd_no_return`); both take false to true while only flip returns (`same_change_different_return`); and through the constant reading every question about what is reached has the same answer from false and true, yet no return (`constant_reading_hides_loss`). All are built cases. The account names the general laws they instantiate (`keeps_reach_iff_returns`, `not_returns_iff_loses` in Becoming.Recurrence), which are not in this module.
- **moves**
  - *settled by the third pass:* N: `flip` (l. 31) is `Law.process not : Process Bool Unit` and `same_change_different_return` (l. 41) states `Trace DeadEnd.law false [()] true ∧ Trace flip false [()] true ∧ ¬ Reach DeadEnd.law true false ∧ Reach flip true false`; both processes have the one action `()`, so no statement is about a choice among steps or what some or every choice keeps; the comparison is of two laws. Opened: all four declarations (ll. 31, 34, 41, 50). [which pass was right: b; opened: flip l.31; deadEnd_no_return l.34; same_change_different_return l.41; constant_reading_hides_loss l.50]
  - *pass a:* B: same_change_different_return (l. 41) fixes the same single Unit action in both processes and proves opposite return possibilities.
  - *pass b:* N: no choice among steps; `flip` (l. 31) is `Law.process not` over `Unit` actions and DeadEnd.law is used with one step. B: the two built processes compared in `same_change_different_return` (l. 41).
- **a reading**
  - *pass a:* B: constant_reading_hides_loss (l. 50) proves indistinguishability for every predicate on the constant observation of reachable states from false and true.
  - *pass b:* B: `constant_reading_hides_loss` (l. 50): for every question q on the constant reading `fun _ => ()`, some state reached from false satisfies it iff some state reached from true does, and yet `¬ Reach DeadEnd.law true false`. What is registered decides nothing about the loss.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **a point of no return**
  - *pass a:* B: deadEnd_no_return (l. 34) concludes that no course from true reaches false in DeadEnd.law, with no stock or feeder premise.
  - *pass b:* B: `deadEnd_no_return` (l. 34): `¬ Reach DeadEnd.law true false`, concluded (the proof uses `Invariant.reach` with the invariant y = true) for the built dead end, at the low level of a Bool configuration, not at the loss of something that gives. D: the account says the general laws of return are in Becoming.Recurrence (not read).
- **both outcomes**
  - *pass a:* B: same_change_different_return (l. 41) exhibits return and nonreturn under two different laws after the same change.
  - *pass b:* B: `same_change_different_return` (l. 41) is a conjunction over two built laws: both trace false to true, flip reaches false from true, the dead end does not. It is a contrast, not an exactly-when.
- **a comparison between two**
  - *pass a:* B: constant_reading_hides_loss (l. 50) transfers all constant-summary existential reach queries between the two starts of DeadEnd.law.
  - *pass b:* B: `same_change_different_return` (l. 41) compares two processes taking the same change with different return. No law carries anything from one to the other.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **a closed region**
  - *settled by the third pass:* N: no statement of the module states a region closed under steps; `deadEnd_no_return` (l. 34) states `¬ Reach DeadEnd.law true false` with no premise. The invariant `fun y => y = true` appears only in its proof body (`Invariant.reach`, ll. 36-37), as pass b itself says. Opened: `deadEnd_no_return` (l. 34), `same_change_different_return` (l. 41), `constant_reading_hides_loss` (l. 50), `flip` (l. 31). [which pass was right: a; opened: deadEnd_no_return l.34 (statement and proof); same_change_different_return l.41; constant_reading_hides_loss l.50; flip l.31]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* B: in the proof of `deadEnd_no_return` (l. 36), y = true is used as an invariant of DeadEnd.law; no invariant is stated as a declaration here.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. built cases support states, moves, reading, no_return, both_outcomes, comparison. I found no matching statement for share, level, giving, cost, multiplying, rank, closed_region, forms_change. No answer rests on prose alone or was unreached.
  - *pass b:* Whole module read, all statements and proofs; answers from built statements (B) and the account (D); nothing unreached.

## 22 November, the third pass on an exact edge between both outcomes: reader whole-c-edge2-06

*As "Irreversibility.lean: the edge". A reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md), [report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-edge2-06.md.txt).*

- **an exact statement of both outcomes**: N, read strictly: no statement gives both outcomes of ONE process with an exact condition. B instead: `same_change_different_return` (l. 41), no premise: `Trace DeadEnd.law false [()] true ∧ Trace flip false [()] true ∧ ¬ Reach DeadEnd.law true false ∧ Reach flip true false`. It is a conjunction over two built laws (`DeadEnd.law` of Labelled l. 244; `flip := Law.process not`, l. 31), a contrast with no condition.
- **the side that keeps**: Not stated as a declaration. The no-return half, `deadEnd_no_return` (l. 34: `¬ Reach DeadEnd.law true false`), is proved with `Invariant.reach` at `I := fun y => y = true` (l. 36), an invariant used inside the proof only. The other half, `Reach flip true false`, asserts a return in one step.
- **the side that ends**: N. `¬ Reach DeadEnd.law true false` says only that `false` is not reached from `true`. Nothing is bounded and nothing falls. All four declarations opened (ll. 31, 34, 41, 50).
- **moves in that statement**: N. Both are `Process Bool Unit`; the action type is `Unit`; no choice is quantified. The two laws are two built processes, not two moves of one.
- **a reading in that statement**: N in l. 41. B in a separate statement: `constant_reading_hides_loss` (l. 50), no premise: for every `q : Unit → Prop`, some `t` reached from `false` has `q ((fun _ => ()) t)` iff some `t` reached from `true` does, and `¬ Reach DeadEnd.law true false`. The reading there is constant and decides nothing.
- **the carrier**: Two built `Process Bool Unit`: `DeadEnd.law` and `Irreversibility.flip`, with `Reach` and `Trace`.
- **what is handed in**: Nothing is a premise: no level, giving, share, favouring or turn occurs. The reading (`fun _ => ()`) is built into l. 50. All four conjuncts are concluded of the built laws.
- **links to other modules**: `deadEnd_no_return` (l. 34) names `DeadEnd.law` (Labelled) and `Reach` (Frame): no return in that built law. `same_change_different_return` (l. 41) names `Trace`, `Reach`, `DeadEnd.law`. `flip` (l. 31) is `Law.process not` (Recurrence l. 143). D only: the account says these instantiate `keeps_reach_iff_returns` and `not_returns_iff_loses` of Becoming.Recurrence; no statement here names them.
- **standing**: None seen. The account says no axiom occurs.
- **note**: The general exact law of return is named only in the opening account (Becoming.Recurrence), not in a statement of this module. What the module shows is that the same change occurs under a law that returns and under one that does not, and that a constant reading cannot tell the two starts apart; there is no rank and no stated closed region in it.
