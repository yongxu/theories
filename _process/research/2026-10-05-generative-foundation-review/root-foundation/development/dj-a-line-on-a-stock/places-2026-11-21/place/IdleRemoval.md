# IdleRemoval

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/IdleRemoval.lean`
- *result records that name this place's file as a source* (computed; not a link): `only-the-order-of-change-shows`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-08, as "IdleRemoval.lean: World.withoutIdle_sameAt, World.withoutIdle_premises, World.withoutIdle_totals" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-08.md.txt)); pass b: reader whole-b-28, as "IdleRemoval.lean: World.withoutIdle, World.withoutIdle_sameAt, World.withoutIdle_premises, World.withoutIdle_totals, Stutter.Moves, Stutter.every_step" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-28.md.txt)); the third pass, where the two differed: reader whole-c-settle-10, as "IdleRemoval.lean: settled fields giving, rank" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-10.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: Given a stuttering, a function identifying its moving steps, and a world idle on the others, World.withoutIdle_premises (l. 136) preserves six world predicates in both directions. World.withoutIdle_totals (l. 211) equates exchanges and the amounts and counts of stock rises and falls over corresponding stretches.
  - *pass b:* S: The module proves general laws for every world and every stuttering `ρ` with moving steps `σ` (`Stutter.Moves`, l. 53), where the world is idle at the idle steps of `ρ` (`World.IdleAt`, l. 103). The world with idle steps removed (`World.withoutIdle`, l. 109) shows each relatum as the step it is read at (`withoutIdle_sameAt`, l. 120). It meets the same premises: balance, dissipation, acting, taking, dependent, embodied (`withoutIdle_premises`, l. 136); transmission (`withoutIdle_transmits`, l. 181); census (`withoutIdle_counted`, l. 203). It has the same totals of taken, given, rises and falls of a family's stock (`withoutIdle_totals`, l. 211), and the same comings and ceasings (`withoutIdle_counts`, l. 247).
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found. A stuttering is a re-timing of steps, not a choice among moves.
- **a reading**
  - *pass a:* S: World.withoutIdle_sameAt (l. 120) gives SameAt for every relatum between n and the moving step σ (ρ n), given stutter, moves and idleness.
  - *pass b:* S: The stuttering `ρ` reads steps of the world as steps of a coarser time. `withoutIdle_sameAt` (l. 120): given `Stutter ρ`, `Moves ρ σ` and `IdleAt ρ`, every relatum at step n is `SameAt` the step `σ (ρ n)`. `withoutIdle_premises` (l. 136): what the laws register (balance, activity premises) is the same under the reading. D: the opening account's reading (l. 24) says an idle step makes no difference.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **a level that runs down**
  - *pass a:* S: World.withoutIdle_totals (l. 211) preserves a family's stock falls and rises under idle removal when the stretch endpoints correspond. No dependence of the return on remaining stock is asserted.
  - *pass b:* S: `withoutIdle_totals` (l. 211): over any stretch, the totals of rises and falls of a family's stock `v.web.stock cs`, and their counts, equal those of the idle-removed stretch it reads (premise `ρ N + d = ρ (N + m)`). N: no law of running down, or of what comes back depending on what is left.
- **a giving that is itself a going-on**
  - *settled by the third pass:* S (in part): `World.withoutIdle_premises` (l. 136), under the section's included premises `Stutter ρ`, `Stutter.Moves ρ σ`, `v.IdleAt ρ` (l. 111-113), states six iffs between `v.withoutIdle σ` and `v`, among them `Acting` (only active relata give) and `Embodied`. `World.withoutIdle_counts` (l. 247), with activity decidable and `ρ N + d = ρ (N + m)`, states that the totals of `comings` and `ceasings` of a finite family over a stretch equal those of the stretch read. So what gives is a relatum of the world, whose activity and ceasing are in the statements; but these carry properties over between two worlds, and no statement here says that a giver is lost or what follows when it is. [which pass was right: both in part; opened: IdleAt l.103; withoutIdle l.109; section Removal variable and include l.111-113; withoutIdle_sameAt l.120; withoutIdle_premises l.136; withoutIdle_counted l.203; withoutIdle_totals l.211; withoutIdle_counts l.247; Flow.readAt l.96]
  - *pass a:* S: World.withoutIdle_premises (l. 136) preserves Acting and Embodied iff under idle removal. World.withoutIdle_counts (l. 247) preserves finite-family ceasing totals given decidable activity and corresponding stretches.
  - *pass b:* N: not found. Giving is the flow's `give` function. `withoutIdle_premises` keeps the premise that only active relata give (`Acting`), but no giver is a going-on that can be lost.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no units leaving units. S (counts only): `withoutIdle_counts` (l. 247): with activity decided, the totals of relata of a finite family arising (`comings`) and ceasing (`ceasings`) over a stretch equal those of the idle-removed stretch.
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found. The iffs in `withoutIdle_premises` (l. 136) and `withoutIdle_counted` (l. 203) are equivalences between two representations, not outcomes of going on and ending.
- **a comparison between two**
  - *pass a:* S: World.withoutIdle_transmits (l. 181) preserves TransmitsWithin in both directions at the same δ under the three removal hypotheses.
  - *pass b:* S: `withoutIdle_premises` (l. 136) carries six premises both ways between a world and the world with idle steps removed. `withoutIdle_transmits` (l. 181) carries `TransmitsWithin` with the same bound δ. `withoutIdle_counted` (l. 203) carries a census both ways. `withoutIdle_totals` (l. 211) and `withoutIdle_counts` (l. 247) carry totals. All general, under `Stutter ρ`, `Moves ρ σ` and `IdleAt ρ`.
- **a rank (an ending within a bound)**
  - *settled by the third pass:* N: opened `World.withoutIdle_transmits` (l. 181), `Stutter.le_moving` (l. 59), `Stutter.idle_before_moving` (l. 66), `World.withoutIdle_totals` (l. 211). `withoutIdle_transmits` states `(v.withoutIdle σ).flow.TransmitsWithin (v.withoutIdle σ).web c δ ↔ v.flow.TransmitsWithin v.web c δ` (same included premises); `TransmitsWithin` (Evolution.lean l. 256) bounds a descendant's need by its giver's need plus δ, so δ is not a deadline or a bound on ending. `le_moving` states `n ≤ σ (ρ n)`, an ordering of steps. [which pass was right: b; opened: Stutter.moving_unique l.42; Moves l.53; le_moving l.59; idle_before_moving l.66; withoutIdle_transmits l.181; withoutIdle_totals l.211; Evolution.lean Flow.TransmitsWithin l.256]
  - *pass a:* S: World.withoutIdle_transmits (l. 181) transports an assumed transmission deadline with the same bound.
  - *pass b:* N: not found. `Stutter.le_moving` (l. 59): n ≤ σ (ρ n). `Stutter.idle_before_moving` (l. 66): every step from n to that moving step is idle. These are orderings of steps, not a bound on ending.
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found. `Stutter.every_step` (l. 79): what holds at every idle step and at each moving step holds at every step. That is a principle of proof, not a closed region.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. General statements support states, reading, level, giving, comparison, rank. I found no matching statement for moves, share, cost, multiplying, no_return, both_outcomes, closed_region, forms_change. No answer rests on prose alone or was unreached.
  - *pass b:* Answered from statements: states, reading, level (in part), multiplying (counts only), comparison. Found absent after reading every statement: moves, share, giving, cost, no_return, both_outcomes, rank, closed_region, forms_change. The account alone is behind part of reading. I read the whole module (268 lines), all statements. `Stutter`, `SameAt` and `sample` are defined elsewhere and were not opened.
