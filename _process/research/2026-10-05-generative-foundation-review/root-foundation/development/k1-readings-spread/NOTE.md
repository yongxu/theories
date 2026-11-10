# K1: how readings form, spread and lock (AI-written study note, Claude Opus 5.5, 10 November 2026)

Route (b), round K, piece K1 (board row K1; the round's brief is outside the repository, in `/Users/ren/tmp/za-how-far/route-b/K-ROUND.md`). Module [`Becoming.ReadingsSpread`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadingsSpread.lean) (a new core leaf; imports ReadingsPersist and LineageDrawdown), one rule-9 move into [`Becoming.ReadingsPersist`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadingsPersist.lean); home [07 §4.14](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#readings-spread); records `readings-revised-at-descent`, `where-a-reading-locks`, `a-narrow-reading-in-a-commons`. The design draft and the Fable reading it asked for: [DESIGN.md](DESIGN.md).

```text
Result(s): readings-revised-at-descent, where-a-reading-locks, a-narrow-reading-in-a-commons (new); readings-carried-on-their-course (its Flow.lineOf_carries now a case of the closure law moved below it)
Delta: readings vary at descent (revision as the reading loop's update across a step); a region of readings' share moves by Price's equation with revision as transmission; spread needs what feeds the carriers; read off the slots standing, the share is blind beyond the lines' coupling closure; a lock is a region closed under revision on the course, with variation drawn from what is present and removal of the other readings' carriers as its cases; a commons witness where a narrow reading spreads, with and without return
Supplied premises / correspondence: the acts each reading gives, what is sensed and the update; the commons' numbers; no correspondence claimed
Evidence: Becoming.ReadingsSpread (59 theorems, 109 declarations) and ReadingsPersist's three added theorems, every axiom report empty (scratch builds, 10 November 2026); the core receipt at landing
Boundary: everything near-definitional; the commons' readings are inherited, so its lock is trivial; the blindness law reads the slots standing, not the cohorts
Integration: Price's equation over cohorts (04), the reading loop (03 §12), the ledger of a lineage drawn below its need (04), Bound's blindness (07 §3.5), J2's lines and removal (07 §4.12)
```

## Which law each result is a case of (board rule 9)

| Result | The law it is a case of | Joins |
|---|---|---|
| `share_step` | `SelectionTerm.Generations.mean_step` (Price's equation, counting form) at a region's count | selection over cohorts and revision |
| `carrying_raisedAt`, `carrying_loweredAt` | Price's transmission terms, `raised` and `lowered`, at an indicator | revision is transmission |
| `revised_none_of_inherits`, `fixed_step` | `moved_by_selection`'s premise (exact transmission); `price` at uniform amounts (`concord_alike`) | inheritance, fixation |
| `Flow.supported_carriers_not_against` | `SelectionTerm.Flow.support_not_against` | support and selection |
| `Flow.carriers_inactive_step`, `Flow.carriers_drawn_down` | `Flow.DescendsAt.active`; `LineageDrawdown.below_iff` and `Flow.family_ends_below_at` | the ledger and the share |
| `standingCount_unselected` | `reader_kept_alike` (J2), so `act_courses_unselected_throughout` (Bound) | blindness beyond the closure |
| `kept_iff`, `kept_of_descent` (in ReadingsPersist) | the grammar's closure law `«闭之及»` on dated descent; `ReadingLoop.kept_iff_closed` reads the same law; `goal_descends_iff` is its form along one lineage | the reading loop and descent |
| `Flow.lineOf_carries` (J2's, statement unchanged) | `kept_of_descent` | J2 |
| `fixed_of_closedFrom`, `fixed_of_present`, `Flow.closedFrom_of_standing` | `kept_iff` | the lock |

Revision is the reading loop's update (`ReadingLoop.joint`: the state updated from the act and what is sensed), read across descent: `Generations.RevisesBy G read sense upd` says each kid's reading is `upd (read p) (sense t p)`. That is how K1 joins RF's loop (03 §8, §12): learning within a formation is the loop's update; learning across descent is the same update carried by the slot a kid stands in.

## Decisions (from the Fable reading of DESIGN.md)

1. Readings stay on slots, static, as in J2. Decisive: a member is in a cohort only where it comes to stand, so revision while standing is invisible to the cohorts whatever the type of `read`. Said in the home text.
2. The lock is the reading loop's: a region closed under the update on what the course gives its carriers (`ClosedFrom`), not "fixation under copying", which is a case (`fixed_of_present`), as is removal (`Flow.closedFrom_of_standing`). Not named `Locked` (RuleCapture's).
3. One World witness (`Commons`), both `back` values, three readings; the lock witnessed on supplied generations (`Contact`), said to be supplied. A World witness with revision built in, where removal and contact race, is the record's next step.
4. Everything is near-definitional; two compositions are stated as laws because they answer the questions: spread under drawdown (`carriers_drawn_down`, replacing the draft's unproved "for as long as what feeds them lasts") and blindness of the share (`standingCount_unselected`).
5. Rule 9: the closure law on dated descent lies in ReadingsPersist, `Flow.lineOf_carries` its one-line case, name and statement unchanged.

## Kept failures

- The draft's `Flow.RevisesAlong` (revision as a relation between readings) was dropped for `RevisesBy` (the loop's update); INTERFACES § K1 says so.
- The draft's lock "fixation under copying is absorbing" put all the work in a supplied transmission relation; kept as a case, not the notion.
- The draft's S2 sentence "a reading spreads for as long as what feeds its carriers lasts" was unproved; the laws now say what holds at a step where the carriers are inactive or drawn down.
- In the commons, matches with a wildcard over the ten-constructor relatum type compiled with `propext` in every dependent declaration; the matches are written out in full (as J2's Habitat does), and every axiom report is empty.
- A first attempt at the share's blindness on the line's cohorts was not pursued: the cohorts read who gives to whom, and gifts are not levels, so Bound's law does not reach them; the law is stated for the slots standing.
- The commons world has no revision, so it shows no lock; said in the record and the home text.

## Checks

Scratch builds of ReadingsPersist and ReadingsSpread (10 November 2026): 86 and 59 theorems, every axiom report empty, no warning. The new names were grepped across every module (two hits, both in other namespaces). The core run and the gate are recorded in the records and the board's history row at landing.
