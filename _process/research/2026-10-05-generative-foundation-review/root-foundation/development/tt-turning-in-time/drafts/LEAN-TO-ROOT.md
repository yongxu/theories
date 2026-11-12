*AI-written, 12 November 2026, for Ren's read. Read from the statements and docstrings on main at `d7c380b25` and from the new scratch module. Nothing in the repository rests on it yet.*

# The centre's Lean statements, in the root's terms

The Lean that states the centre was written in the words of the fields it came from. This table gives each statement as it is named, the same thing in the root's terms, and how the tie stands. No existing declaration is renamed. The right column names where the new module, `Becoming.TurningInTime` ([scratch](../held/TurningInTime-first-attempt.lean.txt)), now says it.

Root terms used: a condition (缘); a respect (类); alike goes alike (同行); constant (有常: goes alike, and each can go on wherever its like can); the core (核: the greatest alikeness inside a respect that stays alike in all each can become); ends (亡); a line that never ends (不穷).

| Existing statement | Its words | In the root's terms | How the tie stands | In `TurningInTime` |
|---|---|---|---|---|
| `Laws.GoAlike` | configurations alike under a description go alike | 同行 of that description, at each move | proved, no hypothesis (`goAlikeUnder_iff_alike`) | used as 同行 itself |
| `ClosedCapture.Unread` | neither the share's next value nor the rule read reads what lies beyond the share | the respect "same share, same rule" goes alike: no difference in the rest makes a difference to its next | proved (`identifiesAlike_iff_unread`) | `goesAlike_iff` |
| `RuleCapture.locked_stays` | a locked configuration stays locked | a region the step keeps: what it holds, it goes on holding | by its proof (the closure law, `Pace.stays_turned`) | `way_alone`, `Turning.less_onward` |
| `ClosedCapture.Accrues`, `lock_outlives_loss` | every step adds one to the loss; a locked loop outlives its loss | it goes alike while a condition it uses changes at every step | `Accrues` is a hypothesis | derived from what the ways use: `falls` |
| `PoolFromCourse.windowRead`, `Stands` | the loss is read while it lies in `[N, K)`; its readers stand below `K` | two marks on one condition's level; between them a difference of level makes a difference to how it goes on | a definition there and here; loss counted up where the level counts down | `Between`, `renew`, `differs_between` |
| `PoolFromCourse.window_never_read` | where `K ≤ N`, the loss removes its readers before they read it | no level at which it goes on lies between the marks | a reading; no instance theorem joins the two models | `unmarked_iff`, `goesAlike_of_unmarked`, `used_up_alike` |
| `PoolFromCourse.window_locked_after_removal` | past the bound, a locked step stays locked for good | below the lower mark and falling, it renews alone from then on | a reading | `below_stays`, `way_alone` |
| `ReadOffInTime`'s `too_late_of_own` | read off the going on of those who bear it, a loss is read past its point of no return | where the only difference a condition makes is to whether it goes on, the difference arrives as its ending | a reading; that law is stated on another model and is not used | `between_ended` (`high < need`) |
| `RegimeMargin.ends_iff_below` | a condition under a standing draw ends exactly where it starts below `H + y` | the level of a condition has a point below which it only falls | used as it stands | `Turning.holds`; `falls` at a use that changes |
| `ClosedCapture.Thinned.kept_iff` | read late, the counts at that reading decide whether the lock is kept | what the level brings between the marks renews it into a way that uses less, and it stays so | the counts are not joined to the model | premises: `Turning.kept` and the clause `Less (withLevel …)` |
| `PoolFromCourse.drains`, `RuleCapture.Raises` | a larger share draws more; the favoured share does not fall | renewing alone, it never comes to use less | a hypothesis there and here | premises: `uses`, `Turning.more`, `Turning.alone` |
| `Optimum.least_of_room` | with room to trade, a best outcome leaves what the rule does not read at its least | at one step, what makes no difference is left at its least | a neighbour: nothing is renewed there | not stated |

What the table shows. The centre's law was already the root's: a respect that goes alike and is not constant, the gap being whether there is a next. `GrammarLaws` proves that this gap is exact (`«局定后则有常当且仅当同行可续»`), and the root's own example, the flame and its fuel, is the first half of the statement. The lock's modules proved the same form four times under other names.

What it does not show. Three rows are readings: the lock's course is not proved to be a case of the new model. Until those instance theorems exist, the two sit side by side, joined by this table and not by a proof.
