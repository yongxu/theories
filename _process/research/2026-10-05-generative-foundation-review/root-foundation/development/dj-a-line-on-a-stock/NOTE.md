# DJ: a line on a stock (AI-written, 16 November 2026)

Board row DJ, steps 3 to 7 of [the plan](../../../../../LEAN-TOWARD-THE-DIRECTION.md), tried as laws of one model and not as five modules. Ren's words of 16 November, kept in [sources](../../../../../../sources/15-codex-theory-conversations/2026-11-13-the-map-one-model.md): "it is not about the language or being said again, we aim to reach an interconnected map that is elegant and unified". Lean: the new modules `Becoming.LineOnAStock` and `Becoming.LineOnAStockCases`; `Becoming.TurningInTime` extended; `Becoming.WayOfUnits` reworked to rest on the new module. Record: `a-line-on-a-stock`. This note is its home until a chapter tells it.

```text
Result(s): turning-in-time (TurningInTime.pair, asItWas, held_above, and the new rising_takes_all and
  kept_within); margin-of-a-regime (RegimeMargin.step, FromNothing, Short, Meets, Keeps, holds);
  a-way-of-units (now its case kids u = [u]); the-selection-term-and-a-lineages-fate
  (SelectionTerm.Generations, born_eq, total_flatMap); ReadingsPersist's kept_of_descent;
  going-alike-up-to-the-nets-end (Law.stepWhile and its theorems); when-a-selection-read-off-
  continuation-reads (first_of_decided); Prelude's balance_over_stretch_on.
Delta: one model in which units with a need and a use leave offspring on a renewed level. What makes a
  difference to the way, exactly (alike_iff); two courses whose levels meet the same needs have the same
  ways (ways_alike); a way whose offspring take more comes to a first unmet need within hi + 1 steps, its
  way until then its plain line of descent, and, with offspring needing no more than their parent, the
  level by then below a need the start met (need_unmet, falls_to_unmet); such a way ends (way_ends,
  line_ends); where offspring take the same, the exact condition for never ending (unending_iff_holds),
  of which WayOfUnits.unending_iff_holds is the case kids u = [u]; units that take nothing change neither
  the levels nor the rest of the way (takes_nothing), and can change whether the net ends; the account
  over a stretch (account). In TurningInTime: a use that rises against a capped level leaves nothing
  after hi + 1 steps (rising_takes_all), on which the lock's ending without a given overdraw
  (locked_ends_rising, count_rises) and need_unmet both rest; a window that sets the share as well as the
  rule, with the exact condition for turning in time (locked_turns_in_time_share_iff).
Supplied premises / correspondence: the needs, uses and offspring; that offspring take more (grows) or
  the same (even); that offspring need no more than their parent (down); the cap (Keeps giving 0 hi, the
  start at most hi) and nothing given from nothing; for unending_iff_holds the regime along the course;
  on the lock, that the use rises with each step (more), or that the share is a count every favouring
  rule raises strictly and the use is that count times a positive amount; that a reading sets the share
  low and the rule corrected (sets). The reading of falls_to_unmet as "draws down what it rests on while
  nothing in it yet differs" is an AI reading.
Evidence: scratch builds of 16 November 2026, the last buildR3-1.log: every axiom report empty, no
  warning (TurningInTime 78 theorems, LineOnAStock 113, WayOfUnits 68, LineOnAStockCases 9). Thirteen
  readings of the Lean by agents who did not write it, after six readings and one refuted join on paper,
  in readers/. Searches by script on small worlds are in sim/ and are not proofs. The core run's receipt
  at landing.
Boundary: one stock, whole-number levels; needs, uses and offspring are given and nothing makes a new
  kind; no way comes to respond to the fall because of the fall; no exact condition for a way whose
  offspring take more, or less, never ending; whether the net ends is not monotone in the start level;
  the two built examples match in sizes and levels only, and the laws add nothing about them; nothing
  about a trained system.
Integration: the record a-line-on-a-stock; the records turning-in-time and a-way-of-units brought up to
  their modules; the atlas; the Lean README rows, the checker's entries and scope, the root's imports
  and bullets (the registration, written apart from this note). No chapter tells it yet.
```

<a id="r-a-line-on-a-stock"></a>
## What it is

`Becoming.WayOfUnits` has a way of units, each with a need and a use, on `RegimeMargin`'s level: a unit goes on while the level meets its need, and every unit leaves exactly itself. Here a unit leaves offspring (`kids : U → List U`). After a step at level `x`, each unit of the way leaves its kids where `x` meets its need and nothing where it does not (`after`). The level becomes `RegimeMargin.step giving (taken use w) x`, where `taken` is what all units present take together. `WayOfUnits` is the case `kids u = [u]`, and the course of a way is a family of `SelectionTerm.Generations`.

The way and the level are one step read from two ends. The way reads the level only through which needs it meets (`after_alike`). The level reads the way only through what it takes (`left_of_taken`).

## What is proved

Each theorem's docstring names all its premises. This is the shape; "given" marks what is assumed and not derived.

1. **What makes a difference to a way.** Two levels leave the same next way where they meet the same needs among its units (`after_alike`), and exactly there if every unit of the way has a kid (`alike_iff`; without that, `AlikeFiner`). Along two courses from one way, under two givings, two uses and two start levels, whose levels meet the same needs step by step, the ways are the same (`ways_alike`), and the same number is born (`born_alike`, in `SelectionTerm`'s terms). These hold with no premise on the stock.
2. **A way that grows.** Given: each unit's kids together take more than it (`grows`); nothing is given from nothing; with nothing taken, a level at most `hi` stays at most `hi`; the start is at most `hi`, not empty, with every need met; every descendant needs something. Then there is a first step `n`, from 1 to `hi + 1`, at which some need is unmet, and up to it the way at step `j` is `generation kids j w`, in which no giving, use or level appears (`need_unmet`). Given also that kids need no more than their parent (`down`): at that step the level is below a need the start met, and below the start level (`falls_to_unmet`). Without `down` the level need not have fallen (`KidHigherNeed`). With `down` and positive needs the net ends (`way_ends`; for a closed line among other units, `line_ends`), with no bound on the step; without `down` it can go on (`KidsNeedMore`); with equal in place of more it can go on (`EqualInPlaceOfMore`). In a world of one need the net ends within `hi + 1` steps (`one_need_ends`).
3. **The same arithmetic on the lock.** `TurningInTime.rising_takes_all`: on the course as it was, a use that rises at each of the first `hi` steps against a level that cannot pass `hi` leaves nothing after `hi + 1` steps. `need_unmet` rests on it, and so does `TurningInTime.ends_with_net_rising`, from which a `Locked` start ends still `Locked` within `hi + 1` steps (`locked_ends_rising`). Given there: that no level at which the lock goes on is read (`un`), and that the use rises with each step of the lock (`more`), which `count_rises` gets where the share is a count every favouring rule raises strictly and the use is that count times a positive amount. What is concluded is an ending. No law concludes an overdraw, or that the use depends on the share or the rule.
4. **A reading that sets the share too.** `TurningInTime.windowAfterShare`, and `locked_turns_in_time_share_iff`: the line never ends exactly where, at the first step of the lock's own course at a level the window reads, the level one step later is at or above the corrected kind's point of no return. It is `turns_in_time_iff` at the kind "share low and rule corrected". Given: that a reading sets such a share and rule (`sets`), that they then stay (`lowRule`, `lowStays`), and the overdraw of the course as it was (`draws`, `below`). From the step after the first reading the share is low and the rule corrected (`share_corrected_on_course`).
5. **Offspring that take the same.** Given `even`, every unit having kids, `down`, positive needs, nothing from nothing, and the regime along the course: the net never ends exactly where its course comes to a configuration that holds (`unending_iff_holds`). `WayOfUnits.unending_iff_holds` is its case, statement unchanged; `TwoForOne` is a case whose offspring are not the unit itself.
6. **What is lost, and the account.** A line with no unit in the way never has one, and what is gone does not come back (`never_in`, `gone_from`, by `SelectionTerm.Generations.kept_of_descent`). Units that take nothing and leave only their like change neither the levels nor the way once they are taken out (`takes_nothing`); they can change whether the net ends (`NothingTakenEnds`). While what the way takes is within the level, level and takings and givings balance over any stretch (`account`).
7. **Two built examples.** `LineageRegimes.MultiplyingTakers` and `LineageDrawdown.Drain` (gated) have the sizes and levels of courses of this model on which the premises of `way_ends` and of `fall` hold (`LineOnAStockCases`). Each example's ending already follows from its own Lean, which the equalities take as input; the laws add nothing about them.

## What it bears on in the direction

AI-written; the direction is on [its page](../../../../../DIRECTION.md). Two of its sentences now have a proved form in one model, and a third beside it, on the lock, through one shared lemma. What is given is said beside each.

- *Two courses that differ in nothing that makes a difference to the selection are selected alike.* `ways_alike`, with `alike_iff` saying what makes a difference: which needs are met.
- *How much is left can be among what makes no difference; then the selection can use that up while nothing in it yet differs.* `falls_to_unmet`: until the first unmet need the way is its plain line of descent, on any stock; by then the level is below a need the start met; that step comes within `hi + 1`. Given: `grows`, every descendant needing something, the cap, nothing given from nothing, a start that is not empty with every need met, and `down`. That this is the direction's sentence is a reading.
- *Where each step sets the selection again only from the share it already favours, it goes on the same way until what sustains it gives out, unless that running down makes a difference early enough.* `locked_ends_rising` with `count_rises`; and `locked_turns_in_time_share_iff` for "early enough" when a reading sets the share too. These are laws of `TurningInTime`, not of this model, which has no rule and no share in it; the two meet at `rising_takes_all`. Given: that no level the lock goes on at is read, the rise of the use, and for the share law the overdraw before the reading and what a reading sets.

Not reached: an alignment design; a way that comes to read the fall because of the fall.

## What is given and not shown

- Needs, uses and offspring come with the carrier. Nothing makes a new kind or changes `kids`.
- No new difference arrives from a difference not yet made (`ways_alike`). So no reader of the fall forms because of the fall, and the open item of [01-ROOT](../../../../../../theories/becoming/chapters/01-ROOT.md) on how a difference comes to make a difference is not closed.
- No exact condition for a way whose kids take more, or less, never ending. With one way, whether the net ends is not monotone in the start level (`HigherStartEnds`).
- `unending_iff_holds` asks the regime along the course, as `WayOfUnits` did.
- The alikeness laws hold with no stock; they and the stock meet in `need_unmet` and `falls_to_unmet` only through "every need met", not through `after_alike`.
- `line_ends` and `way_ends` argue the rising take against the cap again in their own setting; only `need_unmet` and what is derived from it rest on `rising_takes_all`.
- The course read as a `Web` with a `Flow` is a dictionary: under balance each one-step `Flow` premise is its conclusion again ([the readers' report](readers/3-course-as-a-web-proposer-and-two-refuters.json)). A fold is owed when `Continuation` is next open.
- A share that falls under the corrected rule, and a reading at some steps only, are not tried. `ReadingsSpread.Commons` was not tried.

## The tests frozen before any Lean, and how they came out

They are in [the paper record](PAPER.md), under "What would count as nothing having changed".

- **A.** (1) passes thinly: `born_alike` uses `ways_alike` with `born_eq`. (2) passes: `WayOfUnits.course_unit`. (3) still fires for `after_alike`, `alike_iff`, `ways_alike`, `born_alike`: they hold with the stock removed, as the module says. (4) passes: `family_eq`.
- **B.** (1) passes: `grows` speaks of units. (2) by the letter only: Drain's sizes and levels are equated and `fall`'s premises hold on that course, and the law adds nothing about Drain; Commons was not tried. (3) passes: `locked_ends_rising` takes neither `draws` nor `below`; `more` is given.
- **C.** Fires in part: the regime is still assumed along the course; offspring that are not the unit itself are covered by one closed case.
- **D.** Passes: `Alike` is computed from the way, and `ways_alike` is on ways that change. No theorem says the relation coarsens along a course.
- **E.** (1) passes: `never_in` by descent. (3): `takes_nothing` stands under the computed case `TakesNothing.lost`.
- **The whole.** Passes: six declarations of `WayOfUnits` are derived from the new module, which rests on laws of `TurningInTime`, `RegimeMargin`, `SelectionTerm` and `ReadingsPersist`. Nothing of `RuleCapture`.

## How it was made, with what failed

All of 16 November 2026, by AI agents; no person has checked it. The dated sections of [the paper record](PAPER.md) say more.

1. **On paper.** A candidate model and laws, and the tests above, before any Lean. A first search (`sim/sim.py`).
2. **Six readers before any Lean** ([report](readers/1-before-any-lean-six-readers.json)). The model was not in the Lean; its parts were. Several of my candidate laws were false or too weak as worded: the alikeness laws held with no stock; one law was false as worded; a drawer's loss on one stock is what the rest goes on by; the fate is not monotone in the level.
3. **Stage A**, the module in scratch, read by three ([report](readers/2-stage-a-implementer-and-three-readers.json); [held version](held/LineOnAStock-stage-A.lean.txt)). Correct, and joined at definitions only: a dozen facts proved again, no existing theorem a case of a new one.
4. **The course as a web** tried on paper, proposer against two refuters ([report](readers/3-course-as-a-web-proposer-and-two-refuters.json)): a dictionary. Kept, not built.
5. **Three passes** (the lock; the import turned round so that `WayOfUnits` rests on the new module; the later laws), read by five ([report](readers/4-passes-c-a2-b-three-implementers-five-readers.json); held versions [of the new module](held/LineOnAStock-after-pass-B.lean.txt), [of `WayOfUnits`](held/WayOfUnits-after-pass-A2.lean.txt), [of `TurningInTime`](held/TurningInTime-after-pass-C.lean.txt)). No false statement. But I had told the lock's new law as an overdraw that comes about, and it concludes an ending; its bound was twice the true one; `WayOfUnits` had grown, not shrunk; a law of alikeness was its own definition chained; "units that take nothing make no difference" was false of whether the net ends; the built examples' endings were not derived.
6. **A repair**, read by three ([report](readers/5-repair-two-implementers-three-readers.json)): one public lemma under both laws, the tight bound, `WayOfUnits` below its tracked size with thirteen helpers removed that nothing used and no record named. The readers then found that `need_unmet`, without `down`, can name a kid's greater need at a level that never fell, so its telling as "uses up what it rests on" said more.
7. **Last fixes**, verified by two ([report](readers/6-last-fixes-implementer-two-verifiers.json)): `falls_to_unmet` with `down`, the kept countermodel `KidHigherNeed`, `ends_with_net` as a case of the split it shared, and docstrings. The coordinating session then applied the verifiers' sixteen wordings, comments only, and rebuilt.
8. **The texts that tell it** (the plan, the direction page and a page of questions for a case from outside) were drafted by the coordinating session and read by three before any was committed ([the plan](../../../../../LEAN-TOWARD-THE-DIRECTION.md) says what they found): the first drafts said more than the Lean in a dozen places, most by leaving out a premise, most often `down`, and told the lock's law as if it were inside this model; a second round found four clauses still wrong. This note had the last of these too, and was corrected with them.

## Files here

- [PAPER.md](PAPER.md): the candidate, the frozen tests, and dated sections on what each round found.
- `briefs/`: the seven briefs the implementers worked from.
- `readers/`: the ten reports, as the workflows returned them; 7 to 9 are the readings of the texts that tell it, and 10 is the landing's first run.
- `held/`: four earlier versions of the Lean, as text.
- `sim/`: the searches and recomputations the readers and implementers ran. They are not proofs.
