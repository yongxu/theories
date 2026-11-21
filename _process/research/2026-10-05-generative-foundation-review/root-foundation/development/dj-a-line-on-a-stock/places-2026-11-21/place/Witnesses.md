# Witnesses

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Witnesses.lean`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-21, as "Witnesses.lean: halted, single, profile, relay, relayWeb" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-21.md.txt)); pass b: reader whole-b-82, as "Witnesses.lean: halted, single, profile, emptyFlow, giving, unrequired, Member, relay, relayWeb" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-82.md.txt)); the third pass, where the two differed: reader whole-c-settle-31, as "Witnesses.lean: settled fields no_return, closed_region, forms_change" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-31.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `halted` (l. 42), `single` (l. 45) and `profile` (l. 50) define reusable processes and time profiles. `relay` (l. 80) and `relayWeb` (l. 93) build a one-condition example with a renewer and two takers from supplied participation, amounts, levels and activity.
  - *pass b:* Definitions only, of built model shapes with parameters, and no law: a process with no step, a process with one step, a course of values from a list then constant, the empty flow, one formation giving k, a web with no requirement, and a renewer and two takers sharing one condition. The account says nothing here is a law, so that it lies below every module that builds a witness.
- **moves**
  - *pass a:* B: `single` (l. 45) allows any move label on the single specified source–target pair, and `halted` (l. 42) admits no step. The restrictions are definitions of these processes.
  - *pass b:* B: `halted` (l. 42) is the process admitting no step, and `single` (l. 45) is the process with one step from a to b. No law about what a choice keeps.
- **a reading**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no reading and no law of what is registered.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no share among kinds.
- **a level that runs down**
  - *pass a:* B: `relayWeb` (l. 93) takes a natural level at each time and sets everyone's need to one. `relay` (l. 80) takes constant amounts separately. Neither definition computes replenishment from the level.
  - *pass b:* B: `relayWeb` (l. 93): one condition stands at a given `level t`, active members need it at 1, the takers draw on it and the renewer does not. `relay` (l. 80): the renewer gives `gives`, and the first and second take `first` and `second`. `profile` (l. 50) gives levels that take listed values then stay. No law of running down is stated here.
- **a giving that is itself a going-on**
  - *pass a:* B: `Member` (l. 72) and `relay` (l. 80) identify the renewer as a formation, with the list of participants at each step supplied. In `relayWeb` (l. 93) the renewer requires the condition at need one along with the takers. Its activity is an input.
  - *pass b:* B: in `relay` (l. 80) and `relayWeb` (l. 93) the giver is a member of the flow, `Member.renewer`, that itself depends on the condition at need one. Its presence (`present t`) and activity (`active t`) are parameters, so whether it can be lost is not stated here.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: in `relay` (l. 80) the renewer takes nothing and the takers give nothing. No cost to the one that gives is defined.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no units leave units.
- **a point of no return**
  - *settled by the third pass:* N: opened all nine declarations; the module has definitions only and no theorem. `halted` (l. 42) is the `Process S A` whose step is `False` at every state, by any move; `single` (l. 45) the process with the one step from `a` to `b`; `profile` (l. 50) the course that takes a list's values and is `rest` at every later index. None states that something once lost is not regained or that from some point no course keeps it; `halted` has no step from any state, which is not a point reached along a course. [which pass was right: b; opened: halted l.42; single l.45; profile l.50; emptyFlow l.58; giving l.62; unrequired l.66; Member l.72; relay l.80; relayWeb l.93 (the whole module).]
  - *pass a:* B: `halted` (l. 42) rules out a next step at every state by construction. `profile` (l. 50) takes the supplied rest value throughout the tail after its finite list. Neither derives loss from a prior course.
  - *pass b:* N: no point of no return.
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no statement.
- **a comparison between two**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no statement.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no statement. `profile` (l. 50) is a course that stays at `rest` after the listed values, but only as a definition.
- **a closed region**
  - *settled by the third pass:* N: opened all nine declarations; there is no law. `profile` (l. 50) is a function `List α → α → Nat → α` whose defining clauses give `rest` once the list is used up: a course of values with a constant tail by definition, with no step and no region stated closed under one; `halted` (l. 42) admits no step and nothing is stated of what it keeps. The account itself says the module holds definitions only. [which pass was right: b; opened: halted l.42; single l.45; profile l.50; emptyFlow l.58; giving l.62; unrequired l.66; relay l.80; relayWeb l.93.]
  - *pass a:* B: `profile` (l. 50) specifies a constant tail after the supplied list. This is a feature of the constructed trajectory.
  - *pass b:* N: no statement.
- **forms change while the going on continues, or more can go on after**
  - *settled by the third pass:* N: opened `relay` (l. 80), `relayWeb` (l. 93), `Member` (l. 72), `giving` (l. 62), `emptyFlow` (l. 58), `profile` (l. 50). `relay` takes `present : Nat → List Member` as a parameter, so which members take part may differ by step, and `relayWeb` takes `active : Nat → Member → Prop` likewise; no statement or fixed instance here sets them so that they change, or says anything goes on while they do. Pass b's description of the parameter is accurate; it is a capacity of the definition, not a statement or built case of the field. [which pass was right: a; opened: profile l.50; emptyFlow l.58; giving l.62; Member l.72; relay l.80; relayWeb l.93.]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* D: the account names "a renewer and two takers", and `relay`'s `present : Nat → List Member` (l. 80) lets the members taking part differ by step. No statement or fixed instance here makes them change.
- **how it was read**
  - *pass a:* S: I read the account and every declaration and docstring. States describes definitions, and moves, level, giving, no_return and closed_region report the limited features of those constructions. No theorem is declared. The other fields were not found, and none was unreached.
  - *pass b:* All of the account and every definition were read, ll. 1-105. The module has no theorems. Moves, level and giving are answered from built definitions, and forms_change from the account and a definition's parameter. The rest are N.
