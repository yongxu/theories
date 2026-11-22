import Becoming.GuardedStep
import Becoming.GrammarRegularity
import Becoming.OwnClass
import Becoming.PoolFromCourse
import Becoming.ReadOffInTime

/-!
# Turning in time: a line that ends where the net ends, or while the net goes on

AI-written, 12 November 2026.

## What the root already has

A line under a class ends in one of two ways: where its last occurrence conditions nothing at all (the
net ends there), or where the occurrence still conditions something but nothing alike to it. The root
names the gap between the two. Constancy up to the net's end (`«至终有常»`, `Becoming.GrammarPath`)
asks that whatever an alike occurrence conditions, this one conditions something alike to it, unless
this one conditions nothing at all; at a member's class it is `«本类至终有常»`. A line that ends while its
last occurrence still conditions something breaks it (`«亡而网续则不至终有常»`,
`«亡而网续则本类不至终有常»`). With the successor fixed, it is going alike (`«同行»`) with whether the next
conditions anything decided (`«局定后则至终有常当且仅当同行可决»`), and constancy is constancy up to the
net's end with a next where the class leads (`«有常当且仅当至终有常可续»`). A determined law's step
(`Law.step`) never lets the net end; cut where it cannot go on (`Law.stepWhile`,
`Becoming.GuardedStep`), a line on it can.

## What the level's laws already have

A level `x` along a course, `g t` given to it and `d t` taken from it at each step, with
`x (t + 1) = x t + g t - d t`: where at most `r` is given and more than `r` taken at every step, the
level never rises (`Optimum.never_rises`), stays within its start (`Optimum.level_le_start`), and is
below any positive need `m` at every step `t` with `x 0 < m + t` (`Optimum.ends_within`). At a standing use
`H`, with giving short of `H` below `y` and nothing given from nothing, a level below `H + y` comes to
nothing (`RegimeMargin.ends_below`), and from a level at or above `H + y` up to `hi`, where giving
meets `H` from `y` and the step keeps the level within `hi`, it never falls below where it started
(`RegimeMargin.holds`); under all of these premises and `0 < H + y`, from a level up to `hi` it comes
to nothing exactly where it starts below `H + y` (`RegimeMargin.ends_iff_below`).

## What this module adds

Each bullet names the main premises; each law's own docstring names all of them. Way, level, need,
marked, alone, as it was, kept kind, giving and use are this model's labels for parts of its
configurations and step, not terms of the root.

* **The pair cut by a need.** One step takes a pair of a way `w` and a level `x` to
  `(after w x, left w x)` (`pair`): `Mechanism.adaptive`'s step with the level in the second place
  (`pair_adaptive`). The net (`net need after left`) is the pair's step where the level is at least
  `need`, and nothing where it is below; at a need of nothing it is the pair's whole step
  (`net_zero`). `AloneOutside marked alone after` says that at every level not marked, the way after
  a step is `alone` of the way; `asItWas alone left` is the step as it was, the way after a step
  `alone` of the way at every level.
* **Which differences of level make a difference.** The way's class is constant up to the net's end
  exactly where no two levels that meet the need give one way two different ways after a step
  (`toEnd_iff`, through `Law.stepWhile_toEnd_iff`); it is constant exactly where, from a level that
  meets the need, every level meets it and gives one way the same way after a step (`constant_iff`),
  so, where some way is given, exactly where nothing is needed and no level makes a difference
  (`constant_iff_needs_nothing`), which at a need of nothing is `adaptive_constant_iff`
  (`constant_adaptive`). With `AloneOutside` and no marked level that meets the need, the class of a
  kind `κ : W → K` is constant up to the net's end where `alone` takes ways of one kind to ways of one
  kind (`kind_toEnd_of_unmarked`), and the way's class is (`toEnd_of_unmarked`, the case `κ := id`);
  for marks between `low` and `high`, no level that meets the need is marked exactly where
  `high < low` or `high < need` (`unmarked_interval_iff`). The core of the way's class does not
  relate a configuration whose level meets the need to one of the same way whose level is below it
  (`core_apart_below_need`, by `«有常则可续»` at the core).
* **The course as it was.** With `AloneOutside`, up to the first marked level of the course as it was,
  the course is that course (`agrees_until_marked`), and its way is `alone` taken `n` times
  (`asItWas_way`). With no marked level that meets the need, lines of `n` steps from one way at two
  levels reach one way (`alike_along`, `«同行之迭»` through `«至终有常局定后则同行»`).
* **Ending where the net ends.** With `AloneOutside`, no marked level that meets a positive need and
  the level of the course as it was in `Optimum`'s form, at most `r` given and more than `r` taken at
  every step, the line from `s` reaches, within `s.2` steps, a configuration that conditions nothing,
  with the way `alone` taken that many times (`ends_with_net`, by `Optimum.ends_within`). With the
  step's level `RegimeMargin.step giving (use w) x` (`regime_step_eq`), nothing given from nothing,
  giving short of `H` below `y`, uses of at least `H` along `alone`'s orbit and a start below
  `H + y`, the premises hold (`ends_with_net_regime`). Where the step under no use keeps every level up
  to `hi` within `hi` (`kept_within`: then so does the step under any use), from a level at most `hi`,
  a use that rises strictly at each of the first `hi` steps of `alone`'s orbit (at least `j` after `j`
  steps, `rises_from`) takes the whole level: with nothing given from nothing, the level of the course
  as it was at step `hi + 1` is nothing (`rising_takes_all`), and the first step at which the use is at
  least the level comes within `hi` steps (`rising_meets_level`). With `AloneOutside`, a positive need
  and no marked level that meets it, the line then ends within `hi + 1` steps (`ends_with_net_rising`),
  with no floor on the use and no start below a point of no return given.
* **The split at the first marked level.** With `AloneOutside` and decided marks, where the course as
  it was comes to a level below the need, the line never ends exactly where there is a step `T` of
  the course as it was, the need met and no level marked before it, the need met and the level marked
  at it, from whose next configuration the line never ends (`unending_iff_first_marked`). That law
  is a case of the same split under a weaker premise, that at some step of the course as it was the
  need is unmet or the level is marked (`unending_iff_first_marked_wide`). The weaker law rests on
  the split at any step with no marked level before it (`unending_iff_marked_at`), which rests on
  the split, at a step, of a line under a step taken while it can go on (`unending_from`). From a way
  of a kind every step keeps, that uses `H₂`, with giving short of `H₂` below `y₂`, meeting it from
  `y₂` up to `hi` and the step keeping the level within `hi`, a positive need at most `H₂ + y₂` and
  the level at most `hi`, the line never ends exactly where the level is at or above `H₂ + y₂`
  (`unending_iff_above`). Composed, with a way after a marked step of the kept kind, uses of at least
  `H₁` along `alone`'s orbit, giving short of `H₁` below `y₁` and the course as it was starting below
  `H₁ + y₁`: the line never ends exactly where at the first marked level, the need met there and at
  every step before it, the level of the course as it was one step later is at or above `H₂ + y₂`
  (`turns_in_time_iff`). Where at a level that meets the need the way after the step is of another
  kind than the way, the line under the kind's class ends there while the net goes on
  (`kind_ends_while_net_goes`); with a kind `alone` keeps and some unmarked level that meets the need,
  the kind's class is then not constant up to the net's end at that member's class
  (`kind_not_toEnd_of_turn`, by `«出类不随则本类不至终有常»`).
* **Kept only below a level.** With nothing given from nothing and giving short of `H` below `y`, a
  positive level that a step under a use of at least `H` does not lower is at or above `H + y`
  (`held_above`). Let the kept kind be kept by every step at the levels from `H₂ + y₂` up to below a
  level `c`, and asked nothing elsewhere (`keptBelow`). Let every way's step take every level from `c`
  up to `hi` to a level from `c` up to `hi` (`safe`). With these in place of `kept`, every way the
  course reaches using at least `H₂` (`floor`), `0 < c` (`pos`) and `unending_iff_above`'s other
  premises, from a way of the kept kind the line never ends exactly where the level is at or above
  `H₂ + y₂` (`unending_iff_above_kept_below`), and `unending_iff_above` is that law at `c := hi + 1`.
  Composed with the split at the first marked level, with `keptBelow`, `safe`, `floor` and `pos` in
  place of `kept` and the level of the course as it was after a marked step at most `hi` in place of the
  start at most `hi`, the line never ends exactly where `turns_in_time_iff`'s right side holds
  (`turns_in_time_iff_kept_below`), and `turns_in_time_iff` is that law at `c := hi + 1`. With
  `AloneOutside`, decided marks and a way after a marked step of the kept kind, a kind kept over a band
  of levels is kept at every level, or every level of the band is marked (`kept_or_marked`).
* **The lock's courses as courses of the pair** (section 6; the lock's own names
  are cited there). `ClosedCapture`'s joined two-level step, regrouped with the share, the rule and
  the step count as the way and the loss as the level (`windowRegroup`), is the pair's step, and a
  total step is the net at a need of nothing (`net_zero`). The course that reads off the share is the
  window course as it was (`join_is_asItWas`); `PoolFromCourse`'s window course is the orbit of
  `pair (windowAfter …) (windowLeft fB)` (`window_is_pair`; on `paced`, `window_paced`), at every level
  outside `[N, K)` its way after a step is `windowAlone`, the rule read off the share by `hA` on the
  same schedule (`window_alone_outside`), and it agrees with the course that reads off the share until
  that course's loss first lies in `[N, K)` (`window_agrees_until_marked`). Under `RuleCapture`'s
  premises of `turn_locked` (`Raises`, `ReadsShare`, favouring kept upward), along the course that
  reads off the share the configurations whose share and rule are `Locked` form a region closed under
  the step, with no `Accrues` (`locked_closed`); so at a locked member the class
  `ClosedCapture.lockedAlike` meets `«本类至终有常»` and `«所缘同于»` (`locked_at_class`, by
  `«类闭则本类常闭»`). Along the way's step as it was (`windowAlone`), a `Locked` way stays `Locked`
  (`locked_alone`, under the same premises), and under those premises with `ends_with_net`'s (a
  positive need, no marked level that meets it, the level of the course as it was given at most `r`
  and losing more than `r` at every step) a `Locked` start reaches a configuration that conditions
  nothing, its share and rule still `Locked` (`locked_ends_with_net`). Along `windowAlone` from a
  `Locked` way the share and the rule are never below the start's (`locked_alone_not_below`). So where
  the level steps by the regime, still with a positive need and no marked level that meets it, with
  nothing given from nothing and giving short of `H` below `y`: a `Locked` way that uses at least `H`
  wherever its share and rule are not below the start's, from a level below `H + y`, ends `Locked`
  where the net ends, its way the lock's step as it was taken that many times
  (`locked_ends_with_net_regime`; on the window, with the levels in `[N, K)` marked and `K ≤ N` or
  `K ≤ need`, `locked_ends_on_window`). No premise there is on the level's course: the lock's premises
  keep the use from falling below `H` along it. What stays assumed: the start below `H + y`,
  `RegimeMargin`'s point of no return under a standing use `H` (`below` with `short`); the floor on the
  use where the share and the rule are not below the start's (`draws`); and the not-responding
  (`outside` with `un`). There the lock keeps an overdraw that stands; it does not bring one about. With a
  cap on the level (`keeps`, a start at most `hi`) and a use that rises under each step of the lock
  wherever the share and the rule are not below the start's (`more`) in place of `short`, `draws` and
  `below`, a `Locked` start ends `Locked` within `hi + 1` steps (`locked_ends_rising`, by
  `ends_with_net_rising`); `count_rises` gives `more` where the share is a count that every favouring
  rule raises strictly and the use is that count times a positive amount. Where
  every step reads and the window's reading gives, at every level in `[N, K)`, a rule of which a given
  predicate holds (written `kept` there; not section 5's premise `kept`), the rule after a step at such
  a level is one too (`window_corrected`). On a window that starts at or below
  `H₂ + y₂` (`low`) and ends at or above `c` (`covers`), with every step reading (`every`), the window's
  reading giving a rule that is `kept` there (`corrects`), a use of at least `H₂` at every way
  (`least`), `safe`, and the level of the lock's own course one step after a step the window reads at
  most `hi` (`high`), a `Locked` way from a level below `H₁ + y₁` never ends exactly where its first
  step at a level the window reads leaves the level at or above `H₂ + y₂`
  (`locked_turns_in_time_on_window_iff`, `turns_in_time_iff_kept_below` on the window). There the lock's
  premises, with the floor `H₁` on the use where the share and the rule are not below the start's
  (`draws`), give the uses of at least `H₁` along the lock's own course at every step, so the uses under
  which the level falls up to the first step the window reads are held at or above `H₁`; that the start
  is below `H₁ + y₁` stays given. From a start that is not `Locked` the statement can fail: on
  `Three.unlocked_goes_on` the line never ends with no step read, and every other premise is met there
  (argued in its docstring, not a Lean statement). A window that reads at every step and sets the share
  as well as the rule at a level in `[N, K)` (`windowAfterShare`, the share by `sA`, the rule by `hL`;
  `windowAfter` reading at every step is its case with the share set by `fA`, pointwise,
  `windowAfter_every_is_share`) is `windowAlone` at every other level (`window_share_alone_outside`).
  Where the share it sets is `Low` and the rule it sets `kept` (`sets`), the rule read off a `Low` share
  is `kept` (`lowRule`) and a `Low` share stays `Low` under a `kept` rule (`lowStays`),
  `turns_in_time_iff` at the kept kind `Low ∧ kept` holds on it from a `Locked` start below `H₁ + y₁`,
  with no premise on where the window lies (`locked_turns_in_time_share_iff`); after a step at a level
  the window reads, the pair's course has a `Low` share and a `kept` rule at every later step
  (`share_corrected_stays`), and so from the step after the first step the window reads on the course
  as it was (`share_corrected_on_course`).
* **The point of no return, a level and a step** (section 7). `RegimeMargin` calls the level `H + y`
  the point of no return under a standing use `H`; `Becoming.ReadOffInTime` calls the first step at
  which a course is not recoverable its point of no return (`NoReturnAt`). For any level course `X`
  that never rises and starts at most `hi`, with the feasible courses `X` turned to `H` at some step,
  the start included (`turned`, `Turned`), and what is asked of a course the need met at every step
  (`MeetsNeed`): under nothing given from nothing, giving short of `H` below `y`, meeting it from `y`
  up to `hi`, the step under `H` keeping the level within `hi`, and a positive need at most `H + y`,
  the course turned at `T` meets the need exactly where `H + y ≤ X T` (`turned_meets_iff`), `X` is
  recoverable at `N` exactly where `H + y ≤ X N` (`recoverable_iff_above`), and its point of no return
  is the first step at which its level is below `H + y` (`noReturnAt_iff_first_below`); where it comes
  below `H + y` it has one (`noReturnAt_of_below`). On the pair, with `AloneOutside`, `turns`, `kept`
  and `uses` and no premise on the need, the level course is the course as it was turned at `T + 1`,
  for `T` its first marked step (`course_turned`). Under `turns_in_time_iff`'s premises on the regime
  and on the course as it was (none on the marks or the kept kind) the course as it was has a point of
  no return `N ≤ x` (`noReturn_exists`); the premises on `H₂` decide recoverability at each step
  as in `recoverable_iff_above`, and that the course is not recoverable at step `x` needs only that
  its level there is below the need. Under all of `turns_in_time_iff`'s premises the line never ends
  exactly where the first marked step `T`, the need met there and before, has `T + 1 < N`
  (`turns_in_time_iff_before`, through `course_turned`, `turned_meets_iff` and
  `recoverable_iff_above`).
  The four laws of any level course `X` are also stated under less (ending `_of_stays_below`): in
  place of never rising, a level once below `H + y` staying below it (`below`); in place of the
  start at most `hi`, the level at most `hi` at `T`, at `N`, up to `N` or at every step (`high`).
* **Three courses from one start** (`Three`). Giving `min z (12 - z)`, a use of five as it was and of
  three for the kept kind, a need of one, from the level nine: first marked at step 0 or 1 the line
  never ends (`Three.goes_on`); first marked at step 2 it turns and ends (`Three.turned_and_ends`), and
  there the line under the way's class, continued from the step before, ends while the net goes on, so
  by the root's `«亡而网续则不至终有常»` the way's class is not constant up to the net's end
  (`Three.line_ends_while_net_goes`); with no marked level it ends as it was
  (`Three.ends_as_it_was`). On the lock's own types (a share by `≤`, a rule `false` below `true`, the
  rule read `true` from a share of three), with the same numbers, a `Locked` start at nine meets every
  premise of `locked_ends_with_net_regime` and ends `Locked` in four steps (`Three.lock_ends`); with
  the share raised by one at each step under the favouring rule it does the same, ending `Locked` at
  a share of seven (`Three.rise_lock_ends`), which does not show that the rise bears on the ending:
  the use reads only the rule. With
  the kept kind's use three and `y = 3`, the course as it was from
  nine (nine, eight, six, two, nothing) has its point of no return at step 3 (`Three.noReturn`).
  The cases on the lock's own types that follow include a start at seven and a start that is not
  `Locked`. On the lock's own types again, from the same start at nine (the way `(3, true, 0)`), with a
  window that reads the rule `false` off the level, every step reading: at `[8, 9)` the level is read
  at eight, the step from eight is still under the use of five and leaves six, six is outside the
  window, the rule is read off the share again and the line ends, while the right side of
  `turns_in_time_iff` holds; the premise of `locked_turns_in_time_on_window_iff` that fails there is
  `low`, the window starting above `H₂ + y₂ = 6` (`Three.read_at_eight_ends`; at `hi = 6` and `c = 7`
  the others hold, argued there, not a Lean statement). At `[6, 10)`, through
  `locked_turns_in_time_on_window_iff` with `c = 10`, the line goes on from nine, the rule read off the
  share again at ten and the level held at twelve under the use of five, and ends from seven
  (`Three.read_to_ten`). At `[6, 9)` the level is first read at step 1, at eight, and then holds at six
  inside the window, and the line from nine never ends, through `locked_turns_in_time_on_window_iff` at
  `hi = 6`, `c = 7` and `T = 1`, with the kind not kept at every level (`Three.held_at_six`). At
  `[6, 8)`, from the way `(2, true, 0)` at nine, which is not `Locked`, the rule read off the share two
  is `false`, the use falls to three without the level being read, and the line never ends with no step
  of the lock's own course at a level the window reads (`Three.unlocked_goes_on`). With the use the
  share (`drawerUse`), the share raised by one at each step under the favouring rule and the start
  `(3, true, 0)` at twelve, `locked_ends_rising` with its `more` from `count_rises` gives a line that
  ends `Locked` within `12 + 1` steps, and, as a separate computed conjunct, the line ends in seven
  steps at `((10, true, 7), 0)`; no `H` at most the start's use and `y` with giving short of `H` below `y` put twelve
  below `H + y`; at step 4, the way `(7, true, 4)` at twelve, giving is short of seven below six, the
  use is at least seven and twelve is below `7 + 6`, so that `locked_ends_with_net_regime` applies from
  there (`Three.rise_count_ends`; that it applies is argued there, not a Lean statement). On the band `[8, 9)` from nine, with the window setting
  the share to nothing as well as the rule to `false`, the line never ends, through
  `locked_turns_in_time_share_iff` at `T = 1`, and from step 2 the share is below three and the rule
  `false` (`Three.share_read_goes_on`); with the share left as it steps, `Three.read_at_eight_ends`
  ends on that band.

## What is given and what is not shown

`AloneOutside` and the marks are given, not derived: which levels make a difference to the way is a
premise of every law that uses them. `Kept` is kept by premise (`kept`), that a way after a marked
step is of the kept kind is a premise (`turns`), and every way of the kept kind has one standing use
(`uses : ∀ w, Kept w → use w = H₂`); with `kept` and `turns` this makes the course after the turn a
single threshold, and the exactness of `turns_in_time_iff` past `T` rests on it. In
`unending_iff_above_kept_below` and `turns_in_time_iff_kept_below` the premises `keptBelow`, `safe`,
`floor` and `pos`, and in `turns_in_time_iff_kept_below` also `high` (the level of the course as it
was after a marked step at most `hi`), are given, not derived: these laws are sufficient conditions,
and whether a line can go on where no `hi` and `c` meet them is not shown. On the window
(`locked_turns_in_time_on_window_iff`) `keptBelow` and `turns` are concluded from `corrects`, `every`,
`low` and `covers`, while `safe`, `pos`, `least` (which gives `floor`), `uses`, `draws`, `below` and
`high` stay given, with the regime premises, `short₁` and those on the need. A start at or above
`H₁ + y₁` that the window reads is not covered there. `window_corrected` and
`locked_turns_in_time_on_window_iff` ask that every step reads (`every`); a schedule that reads at some
steps only is not covered by them. By `held_above` a level `c` from one up to `hi` under `safe` is at or
above the point of no return of every way, the way as it was included (`use v + y` for every way `v` and
every `y` below which giving is short of `use v`; argued here from `held_above`, not a Lean statement),
so there the kind has to be kept at every level from `H₂ + y₂` up to below `c`, so at least up to below
that point, for these laws to apply; where `c` is above `hi`, `safe` asks nothing, and at `c = hi + 1`
the kind has to be kept from `H₂ + y₂` up to `hi`. With marks on levels, by `kept_or_marked`, a kind
kept over a band and not at every level has every level of the band marked, so a start in the band has
its first marked step at step 0; a start above the band can have a later one, as on the window `[6, 9)`
from nine (`Three.held_at_six`), and `turns_in_time_iff_kept_below` covers it (argued here, not a Lean
statement). `unending_iff_above`, `turns_in_time_iff`, `course_turned` and `turns_in_time_iff_before`
stay under `kept`; so with `keptBelow` in place of `kept` the pair's level course is not shown to be the
course as it was turned at `T + 1`. No course here that meets the new laws' premises has a pair's level
course other than that turn: `Three.read_at_eight_ends` is a pair course that is not that turn, but
there `kept` fails, no `c` above six meets `keptBelow`, and no `c` from one to six meets `safe` with
`high` (argued here, not a Lean statement); on `Three.read_to_ten` and `Three.held_at_six`, which meet
the premises of `locked_turns_in_time_on_window_iff`, the pair's level course is that turn (by
computation, not a Lean statement). A share whose step reads the level is not expressed by `windowAfter`
(its share steps by `fA` of the share and the rule in force); `windowAfterShare` sets the share at a
level the window reads (by `sA`), and in `locked_turns_in_time_share_iff` the correction reaches the
share because that reading sets it (`sets`, given); a share that falls under the rule the window reads,
so that the rule read off it changes, is not tried. In `ends_with_net_regime`,
`locked_ends_with_net_regime`, `locked_ends_on_window`, `ends_with_net_rising`, `locked_ends_rising`,
`unending_iff_above`, `unending_iff_above_kept_below`, `turns_in_time_iff_kept_below`,
`locked_turns_in_time_on_window_iff`, `locked_turns_in_time_share_iff` and `turns_in_time_iff` the
level's step is `RegimeMargin.step giving (use w)`, with one `giving` for
every way and nothing given from nothing (`RegimeMargin.FromNothing giving`): the way enters the level's
step only through `use`. That the marked levels are levels of the same quantity the going on needs is a
choice of the model, and so are these. `unending_iff_above`, `unending_iff_above_kept_below`,
`turns_in_time_iff_kept_below`, `locked_turns_in_time_on_window_iff`, `locked_turns_in_time_share_iff`
and `turns_in_time_iff` need giving
to meet `H₂` from `y₂` up to `hi` (`RegimeMargin.Meets`), the step under `H₂` to keep the level within
`hi` (`RegimeMargin.Keeps`), the need at most `H₂ + y₂` (`within`) and a level at most `hi` (`high`: in
`turns_in_time_iff_kept_below` and `locked_turns_in_time_on_window_iff` the level after a marked step,
in the others the start's).
`unending_iff_first_marked` has the premise that the course as it was comes below the need
(`asItWasEnds`); `unending_iff_first_marked_wide` asks less, that at some step of the course as it was
the need is unmet or the level is marked (the marks decided); a course never marked whose level never
falls below the need meets neither, and is a line that never ends with no such step `T` (argued here,
not a Lean statement). `turns_in_time_iff` and
`turns_in_time_iff_kept_below` need the decidability of the marks (`[DecidablePred marked]`) and the
course as it was below `H₁ + y₁` with uses of at least `H₁` along `alone`'s orbit.
`constant_iff_needs_nothing` needs a given way `w₀`. The closed form of the step `T` by
`Optimum.reread_deadline_iff` is not stated. Nothing here is about a trained system.
From `Becoming.ReadOffInTime` this module uses `first_of_decided`, and its point of no return of a
course (`Recoverable`, `NoReturnAt`, with `NoReturnAt.recoverable_iff` and `noReturnAt_of_past`),
which section 7 joins to `RegimeMargin`'s point of no return, a level. Its selection side
(`FirstApart`, `TellsApartAt`, `ReadableInTime`, `ReadsInTime`) is not instantiated: the pair has no
web. `FourReaders.recoverable_iff_regime` is not derived from `recoverable_iff_above`: its courses are
over three places, and its course as it was is not of `RegimeMargin.step`'s form; that the two say
the same of their models is a reading. In section 7 the feasible courses are the turns of `X` to one
standing use `H` at any step, the start included; other continuations are not considered, and the
marks stay given. Under `turns`, `kept` and `uses`, the pair's own courses are only the turns at
`T + 1` for a first marked step `T` (`course_turned`); `turned_meets_iff`, `recoverable_iff_above`
and `noReturnAt_iff_first_below` hold for any level course that never rises and starts at most `hi`,
however it arises, and need nothing of the pair.
This module lies in the package's second layer only through what it imports, `Becoming.OwnClass` (for
`«类闭则本类常闭»`) and `Becoming.ReadOffInTime` (for `first_of_decided` and the point of no return of a
course); it states no continuation condition and no valuation, and uses none.
Nothing here derives that a lock needs nothing of what it uses: that a lock's own models need nothing
is how they are built. They have a total step, so in them no line ends where the net ends, and
`ends_with_net` and the split at the first marked level, which ask for a positive need or a course as
it was that comes below the need, do not apply to them; the laws on a kind's class hold at every need.
Where the way's step as it was is the lock's, under `turn_locked`'s premises and `ends_with_net`'s (a
positive need among them), a `Locked` start ends `Locked` where the net ends (`locked_ends_with_net`).
In `locked_ends_with_net_regime`, `locked_ends_on_window`, `locked_turns_in_time_on_window_iff` and
`locked_turns_in_time_share_iff` the start below `H + y` (`below`; `H₁ + y₁` in the last two) and the floor on the use where the share and the rule are
not below the start's (`draws`) are given. In `locked_ends_rising` neither is; a cap on the level (`keeps`, `high`) and the
rise of the use under each step of the lock wherever the share and the rule are not below the start's
(`more`) are given instead, and what it concludes is the ending, not a step past a point of no return.
No law here concludes that the use depends on the share or the rule: `count_rises` asks it (`count`),
and `more` can be met by a use that reads neither (argued at `locked_ends_rising`, not a Lean
statement).
Under the regime the level of the course as it was is
`DrawHistory.underDraws` along `alone`'s orbit; that identification is not stated. `locked_at_class` is
stated where the beyond is a loss (`B = Nat`), as `ClosedCapture.lockedAlike` is. `locked_stays`,
`lock_line`, `window_never_read`, `window_past_course` and `course_past` are not re-proved.

Every declaration has an empty axiom report.
-/

namespace Becoming
namespace TurningInTime

universe u v

variable {W : Type u}

/-! ## 1. The pair and its net -/

/-- One step: the way becomes `after w x` and the level `left w x`. -/
def pair (after : W → Nat → W) (left : W → Nat → Nat) (s : W × Nat) : W × Nat :=
  (after s.1 s.2, left s.1 s.2)

/-- The step as it was: the way after a step is `alone` of the way at every level. -/
def asItWas (alone : W → W) (left : W → Nat → Nat) : W × Nat → W × Nat :=
  pair (fun w _ => alone w) left

/-- The pair's step is `Mechanism.adaptive`'s, with the level in the place `adaptive` gives to what it
calls the rule. -/
theorem pair_adaptive (after : W → Nat → W) (left : W → Nat → Nat) :
    «谓» (Law.step (pair after left))
      (moveRel (adaptive (fun (x : Nat) (w : W) (_ : Unit) => after w x) (fun x w => left w x)) ()) :=
  fun _ _ => Iff.rfl

/-- The net: a next only where the level meets the need. -/
def net (need : Nat) (after : W → Nat → W) (left : W → Nat → Nat) : «际» (W × Nat) :=
  Law.stepWhile (fun s => need ≤ s.2) (pair after left)

/-- At a need of nothing the net is the pair's whole step. -/
theorem net_zero (after : W → Nat → W) (left : W → Nat → Nat) :
    «谓» (net 0 after left) (Law.step (pair after left)) :=
  fun _ _ => ⟨fun h => h.2, fun h => ⟨Nat.zero_le _, h⟩⟩

/-- Outside the marked levels the way after a step is `alone` of the way: the level makes no
difference to it there. -/
def AloneOutside (marked : Nat → Prop) (alone : W → W) (after : W → Nat → W) : Prop :=
  ∀ w x, ¬ marked x → after w x = alone w

/-- Whether a configuration's level meets the need is decided. Needed to call
`Law.stepWhile_toEnd_iff` at the net. -/
private theorem need_decided {need : Nat} (s : W × Nat) : need ≤ s.2 ∨ ¬ need ≤ s.2 :=
  (Nat.lt_or_ge s.2 need).elim (fun lt => .inr (Nat.not_le_of_gt lt)) .inl

/-! ## 2. Which differences of level make a difference -/

/-- **The way's class is constant up to the net's end exactly where no two levels that meet the need
give one way two different ways after a step.** -/
theorem toEnd_iff (need : Nat) (after : W → Nat → W) (left : W → Nat → Nat) :
    «至终有常» (net need after left) (sameValue (Prod.fst : W × Nat → W)) ↔
      ∀ w x x', need ≤ x → need ≤ x' → after w x = after w x' :=
  (Law.stepWhile_toEnd_iff (can := fun s : W × Nat => need ≤ s.2) (next := pair after left)
    need_decided).trans
    (Law.stepWhile_goesAlike_iff.trans
      ⟨fun h w x x' ge ge' => h (w, x) (w, x') rfl ge ge',
       fun h s s' e ge ge' => (congrArg (fun v => after v s.2) e).trans (h s'.1 s.2 s'.2 ge ge')⟩)

/-- **The way's class is constant exactly where, from a level that meets the need, every level meets
it and gives one way the same way after a step.** -/
theorem constant_iff (need : Nat) (after : W → Nat → W) (left : W → Nat → Nat) :
    «有常» (net need after left) (sameValue (Prod.fst : W × Nat → W)) ↔
      ∀ w x x', need ≤ x → need ≤ x' ∧ after w x = after w x' :=
  Law.stepWhile_constant_iff.trans
    ⟨fun h w x x' ge => h (w, x) (w, x') rfl ge,
     fun h s s' e ge => match h s'.1 s.2 s'.2 ge with
       | ⟨c, same⟩ => ⟨c, (congrArg (fun v => after v s.2) e).trans same⟩⟩

/-- **Where some way `w₀` is given, the way's class is constant exactly where nothing is needed of
the level and no level makes a difference to the way after a step**; at `need = 0` the second clause
is `adaptive_constant_iff`'s (`constant_adaptive`). -/
theorem constant_iff_needs_nothing (w₀ : W) (need : Nat) (after : W → Nat → W)
    (left : W → Nat → Nat) :
    «有常» (net need after left) (sameValue (Prod.fst : W × Nat → W)) ↔
      need = 0 ∧ ∀ w x x', after w x = after w x' :=
  (constant_iff need after left).trans
    ⟨fun h =>
      have zero : need = 0 := Nat.eq_zero_of_le_zero (h w₀ need 0 (Nat.le_refl need)).1
      ⟨zero, fun w x x' => (h w x x' (Nat.le_trans (Nat.le_of_eq zero) (Nat.zero_le x))).2⟩,
     fun ⟨zero, h⟩ w x x' _ => ⟨Nat.le_trans (Nat.le_of_eq zero) (Nat.zero_le x'), h w x x'⟩⟩

/-- **At a need of nothing, the way's class is constant under the net exactly where it is constant
under `Mechanism.adaptive`'s step** (`adaptive_constant_iff`, the level in the second place
of the pair). -/
theorem constant_adaptive (after : W → Nat → W) (left : W → Nat → Nat) :
    «有常» (net 0 after left) (sameValue (Prod.fst : W × Nat → W)) ↔
      ∀ u, «有常» (moveRel (adaptive (fun (x : Nat) (w : W) (_ : Unit) => after w x)
        (fun x w => left w x)) u) (sameValue (Prod.fst : W × Nat → W)) :=
  have same : (∀ w x x', 0 ≤ x → 0 ≤ x' ∧ after w x = after w x') ↔
      ∀ (g g' : Nat) (w : W) (_ : Unit), after w g = after w g' :=
    ⟨fun h g g' w _ => (h w g g' (Nat.zero_le g)).2,
     fun h w x x' _ => ⟨Nat.zero_le x', h x x' w ()⟩⟩
  (constant_iff 0 after left).trans (same.trans adaptive_constant_iff.symm)

/-- **With no marked level that meets the need, the class of a kind is constant up to the net's end
where `alone` takes ways of one kind to ways of one kind.** With `AloneOutside`, for a kind
`κ : W → K` of any type, where `κ w = κ w'` gives `κ (alone w) = κ (alone w')` (as it does where `alone`
keeps the kind, `κ (alone w) = κ w`). -/
theorem kind_toEnd_of_unmarked {K : Type v} {marked : Nat → Prop} {alone : W → W}
    {after : W → Nat → W} (outside : AloneOutside marked alone after) {need : Nat}
    (un : ∀ x, need ≤ x → ¬ marked x) {κ : W → K}
    (respects : ∀ w w', κ w = κ w' → κ (alone w) = κ (alone w')) (left : W → Nat → Nat) :
    «至终有常» (net need after left) (sameValue (fun s : W × Nat => κ s.1)) :=
  (Law.stepWhile_toEnd_iff (can := fun s : W × Nat => need ≤ s.2) (next := pair after left)
    need_decided).mpr
    (Law.stepWhile_goesAlike_iff.mpr fun s s' e ge ge' =>
      ((congrArg κ (outside s.1 s.2 (un _ ge))).trans (respects s.1 s'.1 e)).trans
        (congrArg κ (outside s'.1 s'.2 (un _ ge'))).symm)

/-- **With no marked level that meets the need, the way's class is constant up to the net's end.**
With `AloneOutside`; `kind_toEnd_of_unmarked` at `κ := id`. -/
theorem toEnd_of_unmarked {marked : Nat → Prop} {alone : W → W} {after : W → Nat → W}
    (outside : AloneOutside marked alone after) {need : Nat} (un : ∀ x, need ≤ x → ¬ marked x)
    (left : W → Nat → Nat) : «至终有常» (net need after left) (sameValue (Prod.fst : W × Nat → W)) :=
  kind_toEnd_of_unmarked (κ := id) outside un (fun _ _ e => congrArg alone e) left

/-- **No level that meets the need lies between `low` and `high` exactly where `high` is below `low`
or below the need.** -/
theorem unmarked_interval_iff {need low high : Nat} :
    (∀ x, need ≤ x → ¬ (low ≤ x ∧ x ≤ high)) ↔ high < low ∨ high < need :=
  ⟨fun un => (Nat.lt_or_ge high low).elim .inl fun low_le =>
    (Nat.lt_or_ge high need).elim .inr fun need_le =>
      (Nat.lt_or_ge need low).elim
        (fun lt => absurd ⟨Nat.le_refl low, low_le⟩ (un low (Nat.le_of_lt lt)))
        (fun ge => absurd ⟨ge, need_le⟩ (un need (Nat.le_refl need))),
   fun h _ ge between => h.elim
    (fun lt => Nat.not_le_of_gt lt (Nat.le_trans between.1 between.2))
    (fun lt => Nat.not_le_of_gt lt (Nat.le_trans ge between.2))⟩

/-- **The core of the way's class does not relate a configuration whose level meets the need to one of
the same way whose level is below it.** By `«有常则可续»` at the core, which is constant (`«根»`); no
new root law. -/
theorem core_apart_below_need {need : Nat} {after : W → Nat → W} {left : W → Nat → Nat} {w : W}
    {x x' : Nat} (ge : need ≤ x) (lt : x' < need) :
    ¬ «核» (net need after left) (sameValue (Prod.fst : W × Nat → W)) (w, x) (w, x') :=
  fun core =>
    match «有常则可续» («根» (net need after left) (sameValue (Prod.fst : W × Nat → W))).2.1
        (w, x) (w, x') (pair after left (w, x)) core ⟨ge, rfl⟩ with
    | ⟨_, c, _⟩ => Nat.not_le_of_gt lt c

/-! ## 3. The course as it was -/

/-- **Up to the first marked level of the course as it was, the course is the course as it was.**
With `AloneOutside`. -/
theorem agrees_until_marked {marked : Nat → Prop} {alone : W → W} {after : W → Nat → W}
    (outside : AloneOutside marked alone after) (left : W → Nat → Nat) (s : W × Nat) :
    ∀ n, (∀ j, j < n → ¬ marked (Law.orbit (asItWas alone left) s j).2) →
      Law.orbit (pair after left) s n = Law.orbit (asItWas alone left) s n
  | 0, _ => rfl
  | n + 1, before =>
    (congrArg (pair after left)
        (agrees_until_marked outside left s n fun j lt => before j (Nat.lt_succ_of_lt lt))).trans
      (congrArg (fun z => (z, left (Law.orbit (asItWas alone left) s n).1
          (Law.orbit (asItWas alone left) s n).2))
        (outside _ _ (before n (Nat.lt_succ_self n))))

/-- The way of the course as it was after `n` steps is `alone` taken `n` times. -/
theorem asItWas_way (alone : W → W) (left : W → Nat → Nat) (s : W × Nat) :
    ∀ n, (Law.orbit (asItWas alone left) s n).1 = Law.orbit alone s.1 n
  | 0 => rfl
  | n + 1 => congrArg alone (asItWas_way alone left s n)

/-- **With no marked level that meets the need, lines of `n` steps from one way at two levels reach
one way**: `«同行之迭»`, the way's class going alike by `«至终有常局定后则同行»` from
`toEnd_of_unmarked`. With `AloneOutside`. -/
theorem alike_along {marked : Nat → Prop} {alone : W → W} {after : W → Nat → W}
    (outside : AloneOutside marked alone after) {need : Nat} (un : ∀ x, need ≤ x → ¬ marked x)
    {left : W → Nat → Nat} (n : Nat) {w : W} {x x' : Nat} {t t' : W × Nat}
    (line : «迭» (net need after left) n (w, x) t) (line' : «迭» (net need after left) n (w, x') t') :
    t.1 = t'.1 :=
  «同行之迭»
    («至终有常局定后则同行» (toEnd_of_unmarked outside un left)
      (fun _ x' _ v v' r r' =>
        Law.stepWhile_fixed (fun s : W × Nat => need ≤ s.2) (pair after left) v v' ⟨x', r, r'⟩))
    n (show sameValue (Prod.fst : W × Nat → W) (w, x) (w, x') from rfl) line line'

/-! ## 4. Ending where the net ends -/

/-- Where the course as it was from `s` is at a level below the need at step `N`, within `N` steps the
line from `s` reaches a configuration that conditions nothing, its way `alone` taken that many times.
With `AloneOutside` and no marked level that meets the need. The split at the first
step below the need, by `first_of_decided`. Needed by `ends_with_net`, where `Optimum.ends_within` gives
the step `s.2`, and by `ends_with_net_rising`, where `rising_takes_all` gives the step `hi + 1`. -/
private theorem ends_of_below {marked : Nat → Prop} {alone : W → W} {after : W → Nat → W}
    {left : W → Nat → Nat} (outside : AloneOutside marked alone after)
    {need : Nat} (un : ∀ x, need ≤ x → ¬ marked x) {s : W × Nat} {N : Nat}
    (ended : (Law.orbit (asItWas alone left) s N).2 < need) :
    ∃ n t, n ≤ N ∧ «迭» (net need after left) n s t ∧ (∀ v, ¬ net need after left t v) ∧
      t.1 = Law.orbit alone s.1 n :=
  match first_of_decided (P := fun t => need ≤ (Law.orbit (asItWas alone left) s t).2)
      (Q := fun t => (Law.orbit (asItWas alone left) s t).2 < need)
      (fun t => (Nat.lt_or_ge (Law.orbit (asItWas alone left) s t).2 need).elim
        .inr .inl) N with
  | .inl all => absurd (all N (Nat.le_refl _)) (Nat.not_le_of_gt ended)
  | .inr ⟨m, within, below, before⟩ =>
    have agree : ∀ j, j ≤ m →
        Law.orbit (pair after left) s j = Law.orbit (asItWas alone left) s j :=
      fun j le => agrees_until_marked outside left s j
        (fun i lt => un _ (before i (Nat.lt_of_lt_of_le lt le)))
    ⟨m, Law.orbit (pair after left) s m, within,
      (Law.stepWhile_steps_iff m).mpr
        ⟨fun j lt => Eq.subst (motive := fun z : W × Nat => need ≤ z.2)
          (agree j (Nat.le_of_lt lt)).symm (before j lt), rfl⟩,
      Law.stepWhile_none_iff.mpr (Eq.subst (motive := fun z : W × Nat => ¬ need ≤ z.2)
        (agree m (Nat.le_refl m)).symm (Nat.not_le_of_gt below)),
      (congrArg Prod.fst (agree m (Nat.le_refl m))).trans (asItWas_way alone left s m)⟩

/-- **Ending where the net ends.** With `AloneOutside`, no marked level that meets the need, a
positive need, and the level of the course as it was in `Optimum`'s form (`step`), at most `r` given
(`renews`) and more than `r` taken (`over`) at every step: within `s.2` steps the line from `s`
reaches a configuration that conditions nothing, its way `alone` taken that many times. By
`Optimum.ends_within`, which puts the course as it was below the need at step `s.2`, and
`ends_of_below`. -/
theorem ends_with_net {marked : Nat → Prop} {alone : W → W} {after : W → Nat → W}
    {left : W → Nat → Nat} (outside : AloneOutside marked alone after)
    {need : Nat} (needs : 0 < need) (un : ∀ x, need ≤ x → ¬ marked x)
    {s : W × Nat} {g d : Nat → Nat} {r : Nat}
    (step : ∀ t, (Law.orbit (asItWas alone left) s (t + 1)).2 =
      (Law.orbit (asItWas alone left) s t).2 + g t - d t)
    (renews : ∀ t, g t ≤ r) (over : ∀ t, r < d t) :
    ∃ n t, n ≤ s.2 ∧ «迭» (net need after left) n s t ∧ (∀ v, ¬ net need after left t v) ∧
      t.1 = Law.orbit alone s.1 n :=
  ends_of_below outside un (Optimum.ends_within (x := fun t => (Law.orbit (asItWas alone left) s t).2)
    step renews over needs s.2 (Nat.lt_add_of_pos_left needs))

/-- `RegimeMargin.step` in `Optimum`'s form, where nothing gives from nothing. -/
theorem regime_step_eq {giving : Nat → Nat} (nothing : RegimeMargin.FromNothing giving) (d x : Nat) :
    RegimeMargin.step giving d x = x + giving (x - d) - d :=
  (Nat.lt_or_ge x d).elim
    (fun lt => by
      have gone : x - d = 0 := sub_eq_zero_of_le (Nat.le_of_lt lt)
      show x - d + giving (x - d) = x + giving (x - d) - d
      rw [gone, show giving 0 = 0 from nothing, Nat.add_zero, Nat.add_zero, gone])
    (fun ge =>
      (Naturals.add_sub_cancel (x - d + giving (x - d)) d).symm.trans
        (congrArg (· - d) ((Nat.add_right_comm (x - d) (giving (x - d)) d).trans
          (congrArg (· + giving (x - d)) (Naturals.sub_add_cancel ge)))))

/-- A level that steps by `RegimeMargin.step giving (D t)`, with every `D t` at least `H`, giving short
of `H` below `y`, and a start below `H + y`, is in `Optimum`'s form with at most `H - 1` given and more
than `H - 1` taken at every step. Needed by `ends_with_net_regime`, `turns_in_time_iff_kept_below`,
`turns_in_time_iff` and `asItWas_falls`, which read it off the course as it was, and by
`unending_iff_above_kept_below`, which reads it off the pair's course; what the draw leaves is
below `y` by `RegimeMargin.Adjusted.left_below`, and the level is kept within its start by a joint
induction with `Optimum.never_rises`. -/
private theorem regime_levels {giving : Nat → Nat} {H y : Nat} {X D : Nat → Nat}
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    (uses : ∀ t, H ≤ D t) (below : X 0 < H + y)
    (step : ∀ t, X (t + 1) = RegimeMargin.step giving (D t) (X t)) :
    (∀ t, X (t + 1) = X t + giving (X t - D t) - D t) ∧ (∀ t, giving (X t - D t) ≤ H - 1) ∧
      ∀ t, H - 1 < D t :=
  have pos : 0 < H := RegimeMargin.Adjusted.draw_pos short below
  have back : H - 1 + 1 = H := Naturals.sub_add_cancel pos
  have step' : ∀ t, X (t + 1) = X t + giving (X t - D t) - D t := fun t =>
    (step t).trans (regime_step_eq nothing (D t) (X t))
  have over : ∀ t, H - 1 < D t := fun t => Nat.lt_of_lt_of_le (Nat.le_of_eq back) (uses t)
  have short_at : ∀ z d, z < H + y → H ≤ d → giving (z - d) ≤ H - 1 := fun z d lt hd =>
    have small : giving (z - d) < H := (Nat.lt_or_ge z d).elim
      (fun zl => Nat.lt_of_le_of_lt
        (Nat.le_of_eq ((congrArg giving (sub_eq_zero_of_le (Nat.le_of_lt zl))).trans nothing)) pos)
      (fun zg =>
        have ypos : 0 < y := Naturals.lt_of_add_lt_add_left (k := H)
          (show H + 0 < H + y from Nat.lt_of_le_of_lt (Nat.le_trans hd zg) lt)
        short _ (Nat.lt_of_le_of_lt (Optimum.sub_le_sub_left_of_le hd z)
          (RegimeMargin.Adjusted.left_below ypos lt)))
    le_of_add_le_add_right 1 (Nat.le_trans small (Nat.le_of_eq back.symm))
  have bound : ∀ t, X t ≤ X 0 := fun t => by
    induction t with
    | zero => exact Nat.le_refl _
    | succ t ih =>
      exact Nat.le_trans
        (Optimum.never_rises (x := X) (g := fun t => giving (X t - D t)) (d := D) step'
          (short_at _ _ (Nat.lt_of_le_of_lt ih below) (uses t)) (over t)) ih
  ⟨step', fun t => short_at _ _ (Nat.lt_of_le_of_lt (bound t) below) (uses t), over⟩

/-- **The regime as one way to meet `ends_with_net`'s premises.** With `AloneOutside`, no marked
level that meets a positive need, nothing given from nothing, giving short of `H` below `y`, every way
on `alone`'s orbit from `w` using at least `H`, and the level `x` below `H + y`: within `x` steps the
line from `(w, x)` reaches a configuration that conditions nothing, its way `alone` taken that many
times. -/
theorem ends_with_net_regime {marked : Nat → Prop} {alone : W → W} {after : W → Nat → W}
    (outside : AloneOutside marked alone after) {need : Nat} (needs : 0 < need)
    (un : ∀ x, need ≤ x → ¬ marked x) {giving : Nat → Nat} {use : W → Nat} {H y : Nat}
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    {w : W} {x : Nat} (uses : ∀ j, H ≤ use (Law.orbit alone w j)) (below : x < H + y) :
    ∃ n t, n ≤ x ∧
      «迭» (net need after (fun w x => RegimeMargin.step giving (use w) x)) n (w, x) t ∧
      (∀ v, ¬ net need after (fun w x => RegimeMargin.step giving (use w) x) t v) ∧
      t.1 = Law.orbit alone w n :=
  have levels := regime_levels
    (X := fun t => (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2)
    (D := fun t => use (Law.orbit alone w t)) nothing short uses below
    (fun t => congrArg (fun v => RegimeMargin.step giving (use v) (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2) (asItWas_way alone _ (w, x) t))
  ends_with_net outside needs un (s := (w, x)) levels.1 levels.2.1 levels.2.2

/-- **A use that rises at each of the first `n` steps is at least `j` after `j` steps, up to `n`.**
Where the use strictly rises at each step `j < n` of `alone`'s orbit from `w` (`rises`), the use of
the way `alone` taken `j` times is at least `j`, for every `j` at most `n`. By induction on `j`. -/
theorem rises_from {use : W → Nat} {alone : W → W} {w : W} {n : Nat}
    (rises : ∀ j, j < n → use (Law.orbit alone w j) < use (Law.orbit alone w (j + 1))) :
    ∀ j, j ≤ n → j ≤ use (Law.orbit alone w j)
  | 0, _ => Nat.zero_le _
  | j + 1, le => Nat.succ_le_of_lt (Nat.lt_of_le_of_lt (rises_from rises j (Nat.le_of_succ_le le))
      (rises j (Nat.lt_of_succ_le le)))

/-- **Where the step under no use keeps every level up to `hi` within `hi`, so does the step under
any use.** With `RegimeMargin.Keeps giving 0 hi` (`keeps`), for every use `d` and every level `x` at
most `hi` (`high`), `RegimeMargin.step giving d x` is at most `hi`: it is the step under no use from
`x - d`, which is at most `x`. -/
theorem kept_within {giving : Nat → Nat} {hi : Nat} (keeps : RegimeMargin.Keeps giving 0 hi)
    (d : Nat) {x : Nat} (high : x ≤ hi) : RegimeMargin.step giving d x ≤ hi :=
  keeps (x - d) (Nat.le_trans (Nat.sub_le x d) high)

/-- Under `rising_takes_all`'s premises but `nothing`, the level of the course as it was at step `hi`
is at most the use there: every level of that course is at most `hi` (`kept_within`, step by step),
and the use at step `hi` is at least `hi` (`rises_from`). Needed by `rising_takes_all` and `rising_meets_level`. -/
private theorem takes_at_hi {alone : W → W} {giving : Nat → Nat} {use : W → Nat} {hi : Nat}
    (keeps : RegimeMargin.Keeps giving 0 hi) {w : W} {x : Nat} (high : x ≤ hi)
    (rises : ∀ j, j < hi → use (Law.orbit alone w j) < use (Law.orbit alone w (j + 1))) :
    (Law.orbit (asItWas alone (fun w x => RegimeMargin.step giving (use w) x)) (w, x) hi).2 ≤
      use (Law.orbit alone w hi) :=
  have within : ∀ t, (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2 ≤ hi := fun t => by
    induction t with
    | zero => exact high
    | succ t ih =>
      exact kept_within keeps (use (Law.orbit (asItWas alone
        (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).1) ih
  Nat.le_trans (within hi) (rises_from rises hi (Nat.le_refl hi))

/-- **Against a level that cannot pass `hi`, a use that rises for `hi` steps leaves nothing after
`hi + 1` steps of the course as it was.** On the course as it was from `(w, x)`, the way stepping by `alone` and
the level by `RegimeMargin.step giving (use w)`: with nothing given from nothing (`nothing`), the step
under no use keeping every level up to `hi` within `hi` (`keeps`, `RegimeMargin.Keeps giving 0 hi`),
the start's level `x` at most `hi` (`high`), and the use rising strictly at each of the first `hi`
steps of `alone`'s orbit from `w` (`rises`), the level at step `hi + 1` is nothing. Every level of the
course is at most `hi` (`kept_within`, step by step); the use at step `hi` is at least `hi`
(`rises_from`); so the use there takes the whole level, nothing is left, and nothing is given from
nothing (that the use is at least the level at some step up to `hi` is `rising_meets_level`; that it
is so at step `hi` itself is the private `takes_at_hi`, used in this proof and in
`rising_meets_level`'s, and not stated publicly). No floor on the use and no start below a point of no
return is asked: the use may start at nothing. -/
theorem rising_takes_all {alone : W → W} {giving : Nat → Nat} {use : W → Nat} {hi : Nat}
    (nothing : RegimeMargin.FromNothing giving) (keeps : RegimeMargin.Keeps giving 0 hi)
    {w : W} {x : Nat} (high : x ≤ hi)
    (rises : ∀ j, j < hi → use (Law.orbit alone w j) < use (Law.orbit alone w (j + 1))) :
    (Law.orbit (asItWas alone (fun w x => RegimeMargin.step giving (use w) x)) (w, x) (hi + 1)).2 = 0 :=
  have takes : (Law.orbit (asItWas alone (fun w x => RegimeMargin.step giving (use w) x)) (w, x) hi).2
      ≤ use (Law.orbit (asItWas alone (fun w x => RegimeMargin.step giving (use w) x)) (w, x) hi).1 :=
    Eq.subst (motive := fun v => (Law.orbit (asItWas alone
        (fun w x => RegimeMargin.step giving (use w) x)) (w, x) hi).2 ≤ use v)
      (asItWas_way alone _ (w, x) hi).symm (takes_at_hi keeps high rises)
  (congrArg (fun z => z + giving z) (sub_eq_zero_of_le takes)).trans
    ((Nat.zero_add (giving 0)).trans nothing)

/-- **Where a use rises for `hi` steps against a level that cannot pass `hi`, the first step at which
the use is at least the level comes within `hi` steps.** Under `rising_takes_all`'s premises but
`nothing` (that is, `keeps`, `high` and `rises`), there is a step `j` at most `hi` of the
course as it was from `(w, x)` at which the level is at most the use of the way `alone` taken `j` times,
the use below the level at every step before it. By `first_of_decided`, bounded at step `hi`, where the
level is at most the use (as in `rising_takes_all`). At that step the use takes the whole level. -/
theorem rising_meets_level {alone : W → W} {giving : Nat → Nat} {use : W → Nat} {hi : Nat}
    (keeps : RegimeMargin.Keeps giving 0 hi) {w : W} {x : Nat} (high : x ≤ hi)
    (rises : ∀ j, j < hi → use (Law.orbit alone w j) < use (Law.orbit alone w (j + 1))) :
    ∃ j, j ≤ hi ∧
      (Law.orbit (asItWas alone (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2 ≤
        use (Law.orbit alone w j) ∧
      ∀ i, i < j → use (Law.orbit alone w i) <
        (Law.orbit (asItWas alone (fun w x => RegimeMargin.step giving (use w) x)) (w, x) i).2 :=
  match first_of_decided
      (P := fun t => use (Law.orbit alone w t) <
        (Law.orbit (asItWas alone (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2)
      (Q := fun t =>
        (Law.orbit (asItWas alone (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2 ≤
          use (Law.orbit alone w t))
      (fun _ => Nat.lt_or_ge _ _) hi with
  | .inl all => absurd (takes_at_hi keeps high rises) (Nat.not_le_of_gt (all hi (Nat.le_refl hi)))
  | .inr ⟨j, le, takes, before⟩ => ⟨j, le, takes, before⟩

/-- **A use that rises against a level that cannot pass `hi` ends the line within `hi + 1` steps.**
With `AloneOutside` (`outside`), a positive need (`needs`) that no marked level meets (`un`), nothing
given from nothing (`nothing`), the step under no use keeping every level up to `hi` within `hi`
(`keeps`, `RegimeMargin.Keeps giving 0 hi`), the start's level `x` at most `hi` (`high`), and the use
rising strictly at each of the first `hi` steps of `alone`'s orbit from `w` (`rises`): within `hi + 1`
steps the line from `(w, x)` reaches a configuration that conditions nothing, its way `alone` taken
that many times. By `rising_takes_all` the level of the course as it was is nothing at step `hi + 1`,
below the need; the line ends at the first step of that course below the need (`ends_of_below`, through
which `ends_with_net` goes too). What is concluded is the ending; no step past a point of no return is
stated. In place of `ends_with_net_regime`'s floor on the use (`uses`) and start below a point of no
return (`below`, with `short`), a cap on the level (`keeps`, `high`) and the rise of the use for `hi`
steps (`rises`) are given. -/
theorem ends_with_net_rising {marked : Nat → Prop} {alone : W → W} {after : W → Nat → W}
    (outside : AloneOutside marked alone after) {need : Nat} (needs : 0 < need)
    (un : ∀ x, need ≤ x → ¬ marked x) {giving : Nat → Nat} {use : W → Nat} {hi : Nat}
    (nothing : RegimeMargin.FromNothing giving) (keeps : RegimeMargin.Keeps giving 0 hi)
    {w : W} {x : Nat} (high : x ≤ hi)
    (rises : ∀ j, j < hi → use (Law.orbit alone w j) < use (Law.orbit alone w (j + 1))) :
    ∃ n t, n ≤ hi + 1 ∧
      «迭» (net need after (fun w x => RegimeMargin.step giving (use w) x)) n (w, x) t ∧
      (∀ v, ¬ net need after (fun w x => RegimeMargin.step giving (use w) x) t v) ∧
      t.1 = Law.orbit alone w n :=
  ends_of_below outside un (left := fun w x => RegimeMargin.step giving (use w) x) (s := (w, x))
    (N := hi + 1)
    (Eq.subst (motive := fun z => z < need) (rising_takes_all nothing keeps high rises).symm needs)

/-! ## 5. Turning in time, exactly -/

/-- **A line under a step while it can go on, split at a step.** For any state type, any `can`, `next`
and start `s`, and any step `T`: the line from `s` under `Law.stepWhile can next` and the one (`«一»`) never ends exactly
where it can go on at every step of the orbit before `T` and the line from the orbit at `T` never
ends. No premise. By `Law.stepWhile_unending_iff` and `Law.orbit_add`. -/
theorem unending_from {X : Type u} {can : X → Prop} {next : X → X} {s : X} (T : Nat) :
    «不穷» (Law.stepWhile can next) «一» s ↔
      (∀ j, j < T → can (Law.orbit next s j)) ∧
        «不穷» (Law.stepWhile can next) «一» (Law.orbit next s T) :=
  ⟨fun never =>
    have all := Law.stepWhile_unending_iff.mp never
    ⟨fun j _ => all j, Law.stepWhile_unending_iff.mpr fun k =>
      Eq.subst (motive := can) (Law.orbit_add next s T k) (all (T + k))⟩,
   fun ⟨before, onward⟩ =>
    have rest := Law.stepWhile_unending_iff.mp onward
    Law.stepWhile_unending_iff.mpr fun i => (Nat.lt_or_ge i T).elim (before i) fun ge =>
      match le_dest ge with
      | ⟨k, e⟩ => Eq.subst (motive := fun i => can (Law.orbit next s i)) e.symm
          (Eq.subst (motive := can) (Law.orbit_add next s T k).symm (rest k))⟩

/-- **Split at a step with no marked level before it.** For this module's net at any need, with
`AloneOutside` (`outside`: outside the marked levels the way after a step is `alone` of the way) and a
step `T` of the course as it was from `s` with no marked level at any step before `T` (`before`): the
line from `s` never ends exactly where the need is met at every step up to and including `T` of the
course as it was, and the line never ends from the configuration the pair's step gives after the
course as it was at `T`. Nothing is asked of the level at `T`, of where the course as it was ends, or
of whether marks are decided. `unending_iff_first_marked_wide` below is this at the first step where the
need is unmet or the level marked, found by a search; where the line never ends, that step is the first
marked one. By `unending_from` at `T + 1` and `agrees_until_marked`. -/
theorem unending_iff_marked_at {W : Type u} {marked : Nat → Prop} {alone : W → W}
    {after : W → Nat → W} {left : W → Nat → Nat}
    (outside : AloneOutside marked alone after) {need : Nat} {s : W × Nat} {T : Nat}
    (before : ∀ j, j < T → ¬ marked (Law.orbit (asItWas alone left) s j).2) :
    «不穷» (net need after left) «一» s ↔
      (∀ j, j ≤ T → need ≤ (Law.orbit (asItWas alone left) s j).2) ∧
        «不穷» (net need after left) «一»
          (pair after left (Law.orbit (asItWas alone left) s T)) :=
  have agree : ∀ j, j ≤ T → Law.orbit (pair after left) s j =
      Law.orbit (asItWas alone left) s j :=
    fun j le => agrees_until_marked outside left s j
      fun i lt => before i (Nat.lt_of_lt_of_le lt le)
  (unending_from (can := fun s : W × Nat => need ≤ s.2) (next := pair after left)
      (s := s) (T + 1)).trans
    ⟨fun ⟨upto, onward⟩ =>
      ⟨fun j le => Eq.subst (motive := fun c : W × Nat => need ≤ c.2) (agree j le)
          (upto j (Nat.lt_succ_of_le le)),
        Eq.subst (motive := fun c : W × Nat =>
            «不穷» (net need after left) «一» (pair after left c))
          (agree T (Nat.le_refl T)) onward⟩,
     fun ⟨upto, onward⟩ =>
      ⟨fun j lt => Eq.subst (motive := fun c : W × Nat => need ≤ c.2)
          (agree j (Nat.le_of_lt_succ lt)).symm (upto j (Nat.le_of_lt_succ lt)),
        Eq.subst (motive := fun c : W × Nat =>
            «不穷» (net need after left) «一» (pair after left c))
          (agree T (Nat.le_refl T)).symm onward⟩⟩

/-- **Split at the first marked level, under a weaker premise.** The law
`unending_iff_first_marked` below, with its premise `asItWasEnds` (the course as it was comes
below the need)
replaced by `stops`: at some step of the course as it was it is not so that the need is met and the
level unmarked (with the marks decided, as here: the need is unmet or the level is marked).
The other premises are the same: `AloneOutside` (`outside`) and decided marks. The same conclusion:
the line from `s` never ends exactly where there is a step `T` of the course as it was, the need met
and no level marked before it, the need met and the level marked at it, from whose next configuration
the line never ends. A course as it was that reaches a marked level and never comes below the need
meets `stops` and not `asItWasEnds`. By `first_of_decided` and `unending_iff_marked_at`. -/
theorem unending_iff_first_marked_wide {W : Type u} {marked : Nat → Prop} [DecidablePred marked]
    {alone : W → W} {after : W → Nat → W} {left : W → Nat → Nat}
    (outside : AloneOutside marked alone after) {need : Nat} {s : W × Nat}
    (stops : ∃ n, ¬ (need ≤ (Law.orbit (asItWas alone left) s n).2 ∧
      ¬ marked (Law.orbit (asItWas alone left) s n).2)) :
    «不穷» (net need after left) «一» s ↔
      ∃ T, (∀ j, j < T → need ≤ (Law.orbit (asItWas alone left) s j).2 ∧
              ¬ marked (Law.orbit (asItWas alone left) s j).2) ∧
        need ≤ (Law.orbit (asItWas alone left) s T).2 ∧
        marked (Law.orbit (asItWas alone left) s T).2 ∧
        «不穷» (net need after left) «一»
          (pair after left (Law.orbit (asItWas alone left) s T)) :=
  ⟨fun never => match stops with
    | ⟨n, stop⟩ =>
      match first_of_decided
          (P := fun t => need ≤ (Law.orbit (asItWas alone left) s t).2 ∧
            ¬ marked (Law.orbit (asItWas alone left) s t).2)
          (Q := fun t => ¬ (need ≤ (Law.orbit (asItWas alone left) s t).2 ∧
            ¬ marked (Law.orbit (asItWas alone left) s t).2))
          (fun t => if h : need ≤ (Law.orbit (asItWas alone left) s t).2 ∧
              ¬ marked (Law.orbit (asItWas alone left) s t).2 then .inl h else .inr h)
          n with
      | .inl allP => absurd (allP n (Nat.le_refl n)) stop
      | .inr ⟨T, _, notP, before⟩ =>
        match (unending_iff_marked_at outside (T := T) fun j lt => (before j lt).2).mp never with
        | ⟨upto, onward⟩ =>
          ⟨T, before, upto T (Nat.le_refl T),
            (if h : marked (Law.orbit (asItWas alone left) s T).2 then h
              else absurd ⟨upto T (Nat.le_refl T), h⟩ notP), onward⟩,
   fun ⟨T, before, atT, _, onward⟩ =>
    (unending_iff_marked_at outside (T := T) fun j lt => (before j lt).2).mpr
      ⟨fun j le => (Nat.lt_or_eq_of_le le).elim (fun lt => (before j lt).1)
        (fun e => Eq.subst
          (motive := fun i => need ≤ (Law.orbit (asItWas alone left) s i).2)
          e.symm atT), onward⟩⟩

/-- **Split at the first marked level.** With `AloneOutside`, where the course as it was comes to a
level below the need (`asItWasEnds`), the line never ends exactly where there is a step `T` of the
course as it was, the need met and no level marked before it, the need met and the level marked at it,
from whose next configuration the line never ends. Whether a level is marked is decided
(`[DecidablePred marked]`). It is
`unending_iff_first_marked_wide` where the premise `asItWasEnds` gives that law's weaker premise: a
level below the need is a step at which the need is unmet. -/
theorem unending_iff_first_marked {marked : Nat → Prop} [DecidablePred marked] {alone : W → W}
    {after : W → Nat → W} {left : W → Nat → Nat} (outside : AloneOutside marked alone after)
    {need : Nat} {s : W × Nat}
    (asItWasEnds : ∃ n, (Law.orbit (asItWas alone left) s n).2 < need) :
    «不穷» (net need after left) «一» s ↔
      ∃ T, (∀ j, j < T → need ≤ (Law.orbit (asItWas alone left) s j).2 ∧
              ¬ marked (Law.orbit (asItWas alone left) s j).2) ∧
        need ≤ (Law.orbit (asItWas alone left) s T).2 ∧
        marked (Law.orbit (asItWas alone left) s T).2 ∧
        «不穷» (net need after left) «一»
          (pair after left (Law.orbit (asItWas alone left) s T)) :=
  unending_iff_first_marked_wide outside
    (match asItWasEnds with
      | ⟨n, ended⟩ => ⟨n, fun h => Nat.not_le_of_gt ended h.1⟩)

/-- **From a way of the kept kind the pair's level is the level's course under `H₂`.** From a way `w`
of a kind every step keeps (`kept`) whose ways use `H₂` (`uses`), at every step the pair's way is of
that kind and its level is `Law.orbit (RegimeMargin.step giving H₂) x` at that step. Needed by
`unending_iff_above`, `turns_in_time_iff` and `course_turned`. -/
private theorem kept_run {Kept : W → Prop} {after : W → Nat → W} {giving : Nat → Nat}
    {use : W → Nat} {H₂ : Nat}
    (kept : ∀ w x, Kept w → Kept (after w x)) (uses : ∀ w, Kept w → use w = H₂)
    {w : W} {x : Nat} (kind : Kept w) : ∀ n,
      Kept (Law.orbit (pair after (fun w x => RegimeMargin.step giving (use w) x)) (w, x) n).1 ∧
      (Law.orbit (pair after (fun w x => RegimeMargin.step giving (use w) x)) (w, x) n).2 =
        Law.orbit (RegimeMargin.step giving H₂) x n
  | 0 => ⟨kind, rfl⟩
  | n + 1 =>
    have ih := kept_run kept uses kind n
    ⟨kept _ _ ih.1,
      (congrArg (fun H => RegimeMargin.step giving H
        (Law.orbit (pair after (fun w x => RegimeMargin.step giving (use w) x)) (w, x) n).2)
        (uses _ ih.1)).trans (congrArg (RegimeMargin.step giving H₂) ih.2)⟩

/-- **A positive level that a step under a use of at least `H` does not lower is at or above
`H + y`.** With nothing given from nothing (`nothing`), giving short of `H` below `y` (`short`), a use
`U` at least `H` (`more`) and a level `c` above nothing (`pos`) that the step under `U` leaves no lower
(`held`): `H + y ≤ c`. Below `H + y`, where `c` is below `U` the step takes all of it and nothing is
given from nothing, so it leaves nothing, below `c`; otherwise what is left after the use is below
`y`, giving there is short of `H`, so of `U`, and the step leaves less than `c`.
`WayOfUnits.step_falls`, in a module that imports this one, states the same fact contraposed. -/
theorem held_above {giving : Nat → Nat} {H y U c : Nat}
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    (more : H ≤ U) (pos : 0 < c) (held : c ≤ RegimeMargin.step giving U c) : H + y ≤ c :=
  (Nat.lt_or_ge c (H + y)).elim
    (fun below => absurd held (Nat.not_le_of_gt ((Nat.lt_or_ge c U).elim
      (fun lt =>
        have gone : c - U = 0 := sub_eq_zero_of_le (Nat.le_of_lt lt)
        Nat.lt_of_le_of_lt (Nat.le_of_eq (show c - U + giving (c - U) = 0 by
          rw [gone]
          exact (Nat.zero_add (giving 0)).trans nothing)) pos)
      (fun ge =>
        have leftBelow : c - U < y := (Nat.lt_or_ge (c - U) y).elim id fun atLeast =>
          absurd (Nat.le_trans (Nat.add_le_add more atLeast) (Nat.le_of_eq (add_sub_of_le ge)))
            (Nat.not_le_of_gt below)
        have less : giving (c - U) < U := Nat.lt_of_lt_of_le (short (c - U) leftBelow) more
        Nat.lt_of_lt_of_le (Nat.add_lt_add_left less (c - U))
          (Nat.le_of_eq (Naturals.sub_add_cancel ge))))))
    id

/-- One step of the pair keeps one of two things true of a configuration: its way of the kept kind
and its level from `H₂ + y₂` up to `hi`, or its level from `c` up to `hi`. With the kept kind's use
`H₂` (`uses`), giving meeting `H₂` from `y₂` up to `hi` (`meets`), the step under `H₂` keeping the
level within `hi` (`keeps`), the kept kind kept by every step at a level from `H₂ + y₂` up to below
`c` (`keptBelow`), and every way's step taking a level from `c` up to `hi` to a level from `c` up to
`hi` (`safe`). Needed by `kept_below_run`. -/
private theorem kept_below_step {Kept : W → Prop} {after : W → Nat → W} {giving : Nat → Nat}
    {use : W → Nat} {H₂ y₂ hi c : Nat}
    (uses : ∀ w, Kept w → use w = H₂)
    (meets : RegimeMargin.Meets giving H₂ y₂ hi) (keeps : RegimeMargin.Keeps giving H₂ hi)
    (keptBelow : ∀ w x, Kept w → H₂ + y₂ ≤ x → x < c → Kept (after w x))
    (safe : ∀ w x, c ≤ x → x ≤ hi →
      c ≤ RegimeMargin.step giving (use w) x ∧ RegimeMargin.step giving (use w) x ≤ hi)
    {s : W × Nat} (now : (Kept s.1 ∧ H₂ + y₂ ≤ s.2 ∧ s.2 ≤ hi) ∨ (c ≤ s.2 ∧ s.2 ≤ hi)) :
    (Kept (pair after (fun w x => RegimeMargin.step giving (use w) x) s).1 ∧
        H₂ + y₂ ≤ (pair after (fun w x => RegimeMargin.step giving (use w) x) s).2 ∧
        (pair after (fun w x => RegimeMargin.step giving (use w) x) s).2 ≤ hi) ∨
      (c ≤ (pair after (fun w x => RegimeMargin.step giving (use w) x) s).2 ∧
        (pair after (fun w x => RegimeMargin.step giving (use w) x) s).2 ≤ hi) :=
  now.elim
    (fun ⟨kind, low, high⟩ => (Nat.lt_or_ge s.2 c).elim
      (fun lt =>
        have e : RegimeMargin.step giving H₂ s.2 = RegimeMargin.step giving (use s.1) s.2 :=
          congrArg (fun H => RegimeMargin.step giving H s.2) (uses s.1 kind).symm
        have up : s.2 ≤ RegimeMargin.step giving H₂ s.2 :=
          (RegimeMargin.holds meets keeps low high 1).1
        .inl ⟨keptBelow s.1 s.2 kind low lt, Nat.le_trans low (Nat.le_trans up (Nat.le_of_eq e)),
          Nat.le_trans (Nat.le_of_eq e.symm) (keeps s.2 high)⟩)
      (fun ge => .inr (safe s.1 s.2 ge high)))
    (fun ⟨ge, high⟩ => .inr (safe s.1 s.2 ge high))

/-- Along the pair from a way of the kept kind at a level from `H₂ + y₂` up to `hi`, one of two things
holds of every configuration: its way of the kept kind and its level from `H₂ + y₂` up to `hi`, or
its level from `c` up to `hi`. Under `kept_below_step`'s premises (`uses`, `meets`, `keeps`,
`keptBelow`, `safe`), by induction. Needed by `unending_iff_above_kept_below`. -/
private theorem kept_below_run {Kept : W → Prop} {after : W → Nat → W} {giving : Nat → Nat}
    {use : W → Nat} {H₂ y₂ hi c : Nat}
    (uses : ∀ w, Kept w → use w = H₂)
    (meets : RegimeMargin.Meets giving H₂ y₂ hi) (keeps : RegimeMargin.Keeps giving H₂ hi)
    (keptBelow : ∀ w x, Kept w → H₂ + y₂ ≤ x → x < c → Kept (after w x))
    (safe : ∀ w x, c ≤ x → x ≤ hi →
      c ≤ RegimeMargin.step giving (use w) x ∧ RegimeMargin.step giving (use w) x ≤ hi)
    {w : W} {x : Nat} (kind : Kept w) (low : H₂ + y₂ ≤ x) (high : x ≤ hi) : ∀ n,
      (Kept (Law.orbit (pair after (fun w x => RegimeMargin.step giving (use w) x)) (w, x) n).1 ∧
        H₂ + y₂ ≤ (Law.orbit (pair after (fun w x => RegimeMargin.step giving (use w) x)) (w, x) n).2 ∧
        (Law.orbit (pair after (fun w x => RegimeMargin.step giving (use w) x)) (w, x) n).2 ≤ hi) ∨
      (c ≤ (Law.orbit (pair after (fun w x => RegimeMargin.step giving (use w) x)) (w, x) n).2 ∧
        (Law.orbit (pair after (fun w x => RegimeMargin.step giving (use w) x)) (w, x) n).2 ≤ hi)
  | 0 => .inl ⟨kind, low, high⟩
  | n + 1 => kept_below_step uses meets keeps keptBelow safe
      (kept_below_run uses meets keeps keptBelow safe kind low high n)

/-- **From a way of the kept kind, the line never ends exactly where the level is at or above `H₂ + y₂`,
where the kind need be kept only from `H₂ + y₂` up to below a level `c` such that every way's step takes
every level from `c` up to `hi` to a level from `c` up to `hi`.** With the kept kind's use `H₂`
(`uses`); nothing given from nothing (`nothing`); giving short of `H₂` below `y₂` (`short`), meeting it
from `y₂` up to `hi` (`meets`), the step under `H₂` keeping the level within `hi` (`keeps`); a positive
need (`needs`) at most `H₂ + y₂` (`within`); `c` above nothing (`pos`); the kept kind kept by every step
at a level from `H₂ + y₂` up to below `c` (`keptBelow`); every way's step taking every level from `c` up
to `hi` to a level from `c` up to `hi`, both bounds (`safe`); the start's way of the kept kind (`kind`)
and its level at most `hi` (`high`); and every way the course from `(w, x)` reaches using at least `H₂`
(`floor`). From `c` up the way need not stay of the kept kind. The only-if direction uses `floor`,
`nothing`, `short` and `needs` (from a start below `H₂ + y₂` the level never rises, `regime_levels`, and
is below the need at step `x`, `Optimum.ends_within`); the if direction uses `uses`, `meets`, `keeps`,
`keptBelow`, `safe`, `within`, `pos`, `nothing`, `short`, `kind` and `high`: where a configuration's
level lies from `c` up to `hi`, `c` is at most `hi`, `safe` at the start's way and the level `c` and
`held_above` give `H₂ + y₂ ≤ c`, so the need is met there. By `held_above` a `c` from one up to `hi`
that meets `safe` is at or above `use v + y` for every way `v` and every `y` below which giving is short
of `use v`, so, where some way is of the kept kind, at or above `H₂ + y₂` (argued here from
`held_above`, not a Lean statement). `keptBelow`, `safe`, `floor` and `pos` are given, not derived;
whether a line can go on where no `hi` and `c` meet them is not shown. -/
theorem unending_iff_above_kept_below {Kept : W → Prop} {after : W → Nat → W} {giving : Nat → Nat}
    {use : W → Nat} {H₂ y₂ hi need c : Nat}
    (uses : ∀ w, Kept w → use w = H₂)
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H₂ y₂)
    (meets : RegimeMargin.Meets giving H₂ y₂ hi) (keeps : RegimeMargin.Keeps giving H₂ hi)
    (needs : 0 < need) (within : need ≤ H₂ + y₂) (pos : 0 < c)
    (keptBelow : ∀ w x, Kept w → H₂ + y₂ ≤ x → x < c → Kept (after w x))
    (safe : ∀ w x, c ≤ x → x ≤ hi →
      c ≤ RegimeMargin.step giving (use w) x ∧ RegimeMargin.step giving (use w) x ≤ hi)
    {w : W} {x : Nat} (kind : Kept w) (high : x ≤ hi)
    (floor : ∀ n, H₂ ≤ use
      (Law.orbit (pair after (fun w x => RegimeMargin.step giving (use w) x)) (w, x) n).1) :
    «不穷» (net need after (fun w x => RegimeMargin.step giving (use w) x)) «一» (w, x) ↔
      H₂ + y₂ ≤ x :=
  Law.stepWhile_unending_iff.trans
    ⟨fun all => (Nat.lt_or_ge x (H₂ + y₂)).elim
      (fun lt =>
        have levels := regime_levels
          (X := fun t => (Law.orbit (pair after
            (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2)
          (D := fun t => use (Law.orbit (pair after
            (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).1)
          nothing short floor lt (fun _ => rfl)
        absurd (all x) (Nat.not_le_of_gt (Optimum.ends_within (x := fun t => (Law.orbit (pair after
            (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2)
          levels.1 levels.2.1 levels.2.2 needs x (Nat.lt_add_of_pos_left needs))))
      id,
     fun low n => (kept_below_run uses meets keeps keptBelow safe kind low high n).elim
      (fun now => Nat.le_trans within now.2.1)
      (fun now => Nat.le_trans within (Nat.le_trans
        (held_above nothing short (Nat.le_of_eq (uses w kind).symm) pos
          (safe w c (Nat.le_refl c) (Nat.le_trans now.1 now.2)).1) now.1))⟩

/-- **From a way of a kind every step keeps, that uses `H₂`, the line never ends exactly where the
level is at or above `H₂ + y₂`**: with nothing given from nothing, giving short of `H₂` below `y₂`,
meeting it from `y₂` up to `hi` and the step keeping the level within `hi`, a positive need at most
`H₂ + y₂`, and the level at most `hi`. It is `unending_iff_above_kept_below` at `c := hi + 1`, where
`safe` asks nothing, `keptBelow` follows from `kept` and `floor` from `kept` and `uses`. -/
theorem unending_iff_above {Kept : W → Prop} {after : W → Nat → W} {giving : Nat → Nat}
    {use : W → Nat} {H₂ y₂ hi need : Nat}
    (kept : ∀ w x, Kept w → Kept (after w x)) (uses : ∀ w, Kept w → use w = H₂)
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H₂ y₂)
    (meets : RegimeMargin.Meets giving H₂ y₂ hi) (keeps : RegimeMargin.Keeps giving H₂ hi)
    (needs : 0 < need) (within : need ≤ H₂ + y₂) {w : W} {x : Nat} (kind : Kept w) (high : x ≤ hi) :
    «不穷» (net need after (fun w x => RegimeMargin.step giving (use w) x)) «一» (w, x) ↔
      H₂ + y₂ ≤ x :=
  unending_iff_above_kept_below (c := hi + 1) uses nothing short meets keeps needs within
    (Nat.succ_pos hi) (fun w x k _ _ => kept w x k)
    (fun _ _ ge top => absurd (Nat.le_trans ge top) (Nat.not_succ_le_self hi)) kind high
    (fun n => Nat.le_of_eq (uses _ (kept_run (giving := giving) (x := x) kept uses kind n).1).symm)

/-- **Turning in time, where the kept kind need be kept only below a level `c`.** `turns_in_time_iff`
with its premise `kept` replaced by four and its premise on the start's level replaced by one on the
level after a marked step: the kept kind kept by every step at a level from `H₂ + y₂` up to below `c`
(`keptBelow`); every way's step taking every level from `c` up to `hi` to a level from `c` up to `hi`
(`safe`); from every way of the kept kind at every level, every way the pair's course reaches using at
least `H₂` (`floor`); `c` above nothing (`pos`); and, at every step `T` of the course as it was whose
level is marked, the level of that course at `T + 1` at most `hi` (`high`). The other premises are
`turns_in_time_iff`'s: `AloneOutside` (`outside`) and decided marks; a way after a marked step of the
kept kind (`turns`); the kept kind's use `H₂` (`uses`); nothing given from nothing (`nothing`); giving
short of `H₂` below `y₂` (`short`), meeting it from `y₂` up to `hi` (`meets`), the step under `H₂`
keeping the level within `hi` (`keeps`); a positive need (`needs`) at most `H₂ + y₂` (`within`); giving
short of `H₁` below `y₁` (`short₁`), every way on `alone`'s orbit from `w` using at least `H₁`
(`uses₁`), and the start `x` below `H₁ + y₁` (`below`). The conclusion is `turns_in_time_iff`'s: the
line from `(w, x)` never ends exactly where there is a step `T` of the course as it was, the need met
and no level marked before it, the need met and the level marked at it, and the level of the course as
it was at `T + 1` at or above `H₂ + y₂`. By `unending_iff_first_marked`, and
`unending_iff_above_kept_below` from the way after the marked step. It is a sufficient condition:
`keptBelow`, `safe`, `floor`, `pos` and `high` are given, not derived. `hi` bounds the level after a
marked step, not the start, so the start may lie above `hi`. What it adds to `turns_in_time_iff` (argued
here, not a Lean statement): a start above `hi` whose level after a marked step is at most `hi`, since
`hi` now bounds only that level; and, by `kept_or_marked` at the band from `H₂ + y₂` up to below `c`,
where the kind is not kept at every level, the case of every level of that band marked. -/
theorem turns_in_time_iff_kept_below {marked : Nat → Prop} [DecidablePred marked] {alone : W → W}
    {after : W → Nat → W} {Kept : W → Prop} {giving : Nat → Nat} {use : W → Nat}
    {H₁ y₁ H₂ y₂ hi need c : Nat}
    (outside : AloneOutside marked alone after) (turns : ∀ w x, marked x → Kept (after w x))
    (uses : ∀ w, Kept w → use w = H₂)
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H₂ y₂)
    (meets : RegimeMargin.Meets giving H₂ y₂ hi) (keeps : RegimeMargin.Keeps giving H₂ hi)
    (needs : 0 < need) (within : need ≤ H₂ + y₂) (pos : 0 < c)
    (keptBelow : ∀ w x, Kept w → H₂ + y₂ ≤ x → x < c → Kept (after w x))
    (safe : ∀ w x, c ≤ x → x ≤ hi →
      c ≤ RegimeMargin.step giving (use w) x ∧ RegimeMargin.step giving (use w) x ≤ hi)
    (floor : ∀ w x, Kept w → ∀ n, H₂ ≤ use
      (Law.orbit (pair after (fun w x => RegimeMargin.step giving (use w) x)) (w, x) n).1)
    (short₁ : RegimeMargin.Short giving H₁ y₁) {w : W} {x : Nat}
    (uses₁ : ∀ j, H₁ ≤ use (Law.orbit alone w j)) (below : x < H₁ + y₁)
    (high : ∀ T, marked (Law.orbit (asItWas alone
        (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).2 →
      (Law.orbit (asItWas alone
        (fun w x => RegimeMargin.step giving (use w) x)) (w, x) (T + 1)).2 ≤ hi) :
    «不穷» (net need after (fun w x => RegimeMargin.step giving (use w) x)) «一» (w, x) ↔
      ∃ T, (∀ j, j < T →
          need ≤ (Law.orbit (asItWas alone
            (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2 ∧
          ¬ marked (Law.orbit (asItWas alone
            (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2) ∧
        need ≤ (Law.orbit (asItWas alone
          (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).2 ∧
        marked (Law.orbit (asItWas alone
          (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).2 ∧
        H₂ + y₂ ≤ (Law.orbit (asItWas alone
          (fun w x => RegimeMargin.step giving (use w) x)) (w, x) (T + 1)).2 :=
  have levels := regime_levels
    (X := fun t => (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2)
    (D := fun t => use (Law.orbit alone w t)) nothing short₁ uses₁ below
    (fun t => congrArg (fun v => RegimeMargin.step giving (use v) (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2) (asItWas_way alone _ (w, x) t))
  have ends : ∃ n, (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) n).2 < need :=
    ⟨x, Optimum.ends_within (x := fun t => (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2) levels.1 levels.2.1 levels.2.2
      needs x (Nat.lt_add_of_pos_left needs)⟩
  have above : ∀ T, marked (Law.orbit (asItWas alone
        (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).2 →
      («不穷» (net need after (fun w x => RegimeMargin.step giving (use w) x)) «一»
        (pair after (fun w x => RegimeMargin.step giving (use w) x)
          (Law.orbit (asItWas alone
            (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T)) ↔
        H₂ + y₂ ≤ (Law.orbit (asItWas alone
          (fun w x => RegimeMargin.step giving (use w) x)) (w, x) (T + 1)).2) :=
    fun T markedT => unending_iff_above_kept_below
      (w := after (Law.orbit (asItWas alone
        (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).1
        (Law.orbit (asItWas alone
          (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).2)
      (x := (Law.orbit (asItWas alone
        (fun w x => RegimeMargin.step giving (use w) x)) (w, x) (T + 1)).2)
      uses nothing short meets keeps needs within pos keptBelow safe (turns _ _ markedT)
      (high T markedT) (floor _ _ (turns _ _ markedT))
  (unending_iff_first_marked outside ends).trans
    ⟨fun ⟨T, before, atT, markedT, onward⟩ =>
      ⟨T, before, atT, markedT, (above T markedT).mp onward⟩,
     fun ⟨T, before, atT, markedT, enough⟩ =>
      ⟨T, before, atT, markedT, (above T markedT).mpr enough⟩⟩

/-- **Turning in time, exactly.** With `AloneOutside` and decided marks; a way after a marked step of
the kept kind (`turns`), a kind every step keeps (`kept`) that uses `H₂` (`uses`); nothing given from
nothing; giving short of `H₂` below `y₂`, meeting it from `y₂` up to `hi`, the step under `H₂` keeping
the level within `hi`; a positive need at most `H₂ + y₂`; giving short of `H₁` below `y₁`, every way on
`alone`'s orbit from `w` using at least `H₁`, and the start `x` below `H₁ + y₁` and at most `hi`: the
line from `(w, x)` never ends exactly where there is a step `T` of the course as it was, the need met
and no level marked before it, the need met and the level marked at it, and the level of the course as
it was at `T + 1` at or above `H₂ + y₂`. The level at `T + 1` of the course as it was is the level
after the turning step: both are `left` of the way and level at `T`. It is
`turns_in_time_iff_kept_below` at `c := hi + 1`, where `safe` asks nothing, `keptBelow` follows from
`kept`, `floor` from `kept` and `uses` (`kept_run`), and that law's `high` from the start at most `hi`,
since the level of the course as it was never rises. -/
theorem turns_in_time_iff {marked : Nat → Prop} [DecidablePred marked] {alone : W → W}
    {after : W → Nat → W} {Kept : W → Prop} {giving : Nat → Nat} {use : W → Nat}
    {H₁ y₁ H₂ y₂ hi need : Nat}
    (outside : AloneOutside marked alone after) (turns : ∀ w x, marked x → Kept (after w x))
    (kept : ∀ w x, Kept w → Kept (after w x)) (uses : ∀ w, Kept w → use w = H₂)
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H₂ y₂)
    (meets : RegimeMargin.Meets giving H₂ y₂ hi) (keeps : RegimeMargin.Keeps giving H₂ hi)
    (needs : 0 < need) (within : need ≤ H₂ + y₂)
    (short₁ : RegimeMargin.Short giving H₁ y₁) {w : W} {x : Nat}
    (uses₁ : ∀ j, H₁ ≤ use (Law.orbit alone w j)) (below : x < H₁ + y₁) (high : x ≤ hi) :
    «不穷» (net need after (fun w x => RegimeMargin.step giving (use w) x)) «一» (w, x) ↔
      ∃ T, (∀ j, j < T →
          need ≤ (Law.orbit (asItWas alone
            (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2 ∧
          ¬ marked (Law.orbit (asItWas alone
            (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2) ∧
        need ≤ (Law.orbit (asItWas alone
          (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).2 ∧
        marked (Law.orbit (asItWas alone
          (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).2 ∧
        H₂ + y₂ ≤ (Law.orbit (asItWas alone
          (fun w x => RegimeMargin.step giving (use w) x)) (w, x) (T + 1)).2 :=
  have levels := regime_levels
    (X := fun t => (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2)
    (D := fun t => use (Law.orbit alone w t)) nothing short₁ uses₁ below
    (fun t => congrArg (fun v => RegimeMargin.step giving (use v) (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2) (asItWas_way alone _ (w, x) t))
  have bound := Optimum.level_le_start (x := fun t => (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2) levels.1 levels.2.1 levels.2.2
  turns_in_time_iff_kept_below (c := hi + 1) outside turns uses nothing short meets keeps needs within
    (Nat.succ_pos hi) (fun w x k _ _ => kept w x k)
    (fun _ _ ge top => absurd (Nat.le_trans ge top) (Nat.not_succ_le_self hi))
    (fun _ x' k n => Nat.le_of_eq (uses _ (kept_run (giving := giving) (x := x') kept uses k n).1).symm)
    short₁ uses₁ below (fun T _ => Nat.le_trans (bound (T + 1)) high)

/-- **With marks on levels, a kind kept over a band of levels is kept at every level, or every level
of the band is marked.** With `AloneOutside` and decided marks, a way after a marked step of the kept
kind (`turns`), and the kept kind kept by every step at a level from `lo` up to below `c`
(`keptBelow`): every step keeps the kind, or every level from `lo` up to below `c` is marked. Where
some level `x₀` of the band is not marked, `outside` makes the way after a step at `x₀` `alone` of the
way, so `alone` keeps the kind; at a marked level `turns` keeps it, and at any other level the way
after a step is `alone` of the way again. By `first_of_decided`. For an empty band (`c ≤ lo`) the
second case holds and the law says nothing. What this means for turning in time (argued here, not a
Lean statement): where the kind is kept at every level and the start is at most `hi`,
`turns_in_time_iff` applies; where it is not kept at every level the band is marked throughout, so a
start in the band has its first marked step at step 0. A start above the band can have a later one,
and `turns_in_time_iff_kept_below` covers it: on the window `[6, 9)` from nine (`Three.held_at_six`)
the level is first read at step 1, and the line never ends. -/
theorem kept_or_marked {marked : Nat → Prop} [DecidablePred marked] {alone : W → W}
    {after : W → Nat → W} {Kept : W → Prop} {lo c : Nat}
    (outside : AloneOutside marked alone after) (turns : ∀ w x, marked x → Kept (after w x))
    (keptBelow : ∀ w x, Kept w → lo ≤ x → x < c → Kept (after w x)) :
    (∀ w x, Kept w → Kept (after w x)) ∨ ∀ x, lo ≤ x → x < c → marked x :=
  match first_of_decided (P := fun t => lo ≤ t → t < c → marked t)
      (Q := fun t => lo ≤ t ∧ t < c ∧ ¬ marked t)
      (fun t => if h : marked t then .inl fun _ _ => h
        else if hl : lo ≤ t then
          (if hc : t < c then .inr ⟨hl, hc, h⟩ else .inl fun _ lt => absurd lt hc)
        else .inl fun l => absurd l hl) c with
  | .inl all => .inr fun x lox lt => all x (Nat.le_of_lt lt) lox lt
  | .inr ⟨x₀, _, ⟨lo₀, lt₀, un₀⟩, _⟩ =>
    .inl fun w x kind =>
      have aloneKept : Kept (alone w) :=
        Eq.subst (motive := Kept) (outside w x₀ un₀) (keptBelow w x₀ kind lo₀ lt₀)
      if h : marked x then turns w x h
      else Eq.subst (motive := Kept) (outside w x h).symm aloneKept

/-- **The line under the kind ends while the net goes on.** At a level that meets the need, where the
way after the step is of another kind, the configuration ends under the kind's class and still
conditions something. -/
theorem kind_ends_while_net_goes {K : Type v} {κ : W → K} {need : Nat} {after : W → Nat → W}
    {left : W → Nat → Nat} {w : W} {x : Nat} (ge : need ≤ x) (other : ¬ κ (after w x) = κ w) :
    «亡» (net need after left) (sameValue (fun s : W × Nat => κ s.1)) (w, x) ∧
      ∃ v, net need after left (w, x) v :=
  ⟨fun ⟨_, ⟨_, e⟩, same⟩ =>
    other ((congrArg (fun z : W × Nat => κ z.1) e).symm.trans same.symm),
   ⟨pair after left (w, x), ge, rfl⟩⟩

/-- **Where at a level `x` that meets the need the way after the step is of another kind, and some
level `x₀` that meets the need is not marked, the class of a kind that `alone` keeps is not constant
up to the net's end at `(w, x)`'s class.** With `AloneOutside`, for a kind `κ : W → K` of any type.
That `x` is marked is not a premise: were it not marked, `outside` and `keeps` would give the way after
the step the kind of the way. The pair's case of `«出类不随则本类不至终有常»`: `(w, x)` conditions a
configuration of another kind, while `(w, x₀)`, of its kind, conditions something and nothing of that
other kind. -/
theorem kind_not_toEnd_of_turn {K : Type v} {marked : Nat → Prop} {alone : W → W}
    {after : W → Nat → W} (outside : AloneOutside marked alone after) {need : Nat} {κ : W → K}
    (keeps : ∀ w, κ (alone w) = κ w) {left : W → Nat → Nat} {w : W} {x x₀ : Nat}
    (ge : need ≤ x) (other : ¬ κ (after w x) = κ w) (ge₀ : need ≤ x₀) (un₀ : ¬ marked x₀) :
    ¬ «本类至终有常» (net need after left) (sameValue (fun s : W × Nat => κ s.1)) (w, x) :=
  «出类不随则本类不至终有常» (sameValue_class (fun s : W × Nat => κ s.1))
    (m := (w, x)) (c := (w, x₀)) (u := pair after left (w, x)) rfl ⟨ge, rfl⟩
    (fun e => other e.symm) ⟨pair after left (w, x₀), ge₀, rfl⟩
    (fun _ ⟨_, ey⟩ e => other (e.trans ((congrArg (fun z : W × Nat => κ z.1) ey).trans
      ((congrArg κ (outside w x₀ un₀)).trans (keeps w)))))

/-! ## 6. The lock's courses as courses of the pair

`RuleCapture`'s lock and `PoolFromCourse`'s window course, read in this module's terms; the lock's own
names are cited here. `ClosedCapture`'s joined two-level step, regrouped with the share, the rule and
the step count as the way and the loss as the level (`windowRegroup`), is the pair's step, and a total
step is the net at a need of nothing (`net_zero`). The course that reads off the share
(`ClosedCapture.joinRead`) is the window course as it was (`join_is_asItWas`): at every step, regrouped,
it is the orbit of `asItWas (windowAlone fA hA reads) (windowLeft fB)`. The window course is the orbit
of `pair (windowAfter …) (windowLeft fB)` (`window_is_pair`; on `PoolFromCourse`'s own course function
`paced`, `window_paced`); at every level outside `[N, K)` its way after a step is `windowAlone`, the
rule read off the share by `hA` on the same schedule (`window_alone_outside`); and it agrees with the
course that reads off the share until that course's loss first lies in `[N, K)`
(`window_agrees_until_marked`, which is `agrees_until_marked` read on the window). Along the course that
reads off the share the locked region is closed (`locked_closed`), which at a locked member is the
root's condition at its class (`locked_at_class`). Along the way's step as it was (`windowAlone`) a
`Locked` way stays `Locked` (`locked_alone`). Nothing here derives that a lock needs nothing of what it
uses: that a lock's own models need nothing is how they are built. They have a total step, so in them no
line ends where the net ends, and `ends_with_net` and the split at the first marked level do not apply
to them; the laws on a kind's class hold at every need. At a positive need the lock's way is no longer a
case that needs nothing: where the way's step as it was is the lock's, under `turn_locked`'s premises
and `ends_with_net`'s, a `Locked` start ends `Locked` where the net ends (`locked_ends_with_net`). Along
`windowAlone` from a `Locked` way the share and the rule are never below the start's
(`locked_alone_not_below`); with the level stepping by the regime, a `Locked` way that uses at least `H`
wherever its share and rule are not below the start's, from a level below `H + y`, ends `Locked` where
the net ends (`locked_ends_with_net_regime`), and so on the window with the levels in `[N, K)` marked
(`locked_ends_on_window`). The start below `H + y` and the floor on the use are given there; the lock's
premises keep the use from falling below `H`, and do not bring the start below `H + y`. With a cap on
the level (`keeps`, `high`) and a use that rises under each step of the lock wherever the share and the
rule are not below the start's (`more`) in their place, a `Locked` way ends `Locked` within `hi + 1`
steps (`locked_ends_rising`, by `ends_with_net_rising`); `count_rises` gives `more` where the share is a
count that every favouring rule raises strictly and the use is that count times a positive amount. Where every step
reads and the window's reading gives a rule that is `kept` at every level in `[N, K)`, the rule after a
step at such a level is `kept` (`window_corrected`), whatever the share's step `fA` and the reading off
the share `hA`. On a window that starts at or below `H₂ + y₂` and ends at or above `c`, a `Locked` way
from a level below `H₁ + y₁` never ends exactly where its first step at a level the window reads
leaves the level at or above `H₂ + y₂` (`locked_turns_in_time_on_window_iff`): the lock's premises,
with `draws`, give the uses of at least `H₁` along the lock's own course, and `window_corrected` gives
`turns` and `keptBelow` where the window starts at or below `H₂ + y₂` and ends at or above `c`. A
window that reads at every step and sets the share as well as the rule (`windowAfterShare`;
`windowAfter` reading at every step is its case with the share set by `fA`, pointwise,
`windowAfter_every_is_share`) is `windowAlone` outside `[N, K)` (`window_share_alone_outside`); where it
sets a `Low` share and a `kept` rule, the rule read off a `Low` share is `kept` and a `Low` share stays
`Low` under a `kept` rule, `turns_in_time_iff` at the kept kind `Low ∧ kept` holds from a `Locked`
start below `H₁ + y₁`, the floor `H₁` on the use given (`draws`), with no premise on where the window
lies (`locked_turns_in_time_share_iff`), and the share and
the rule stay so after a step the window reads (`share_corrected_stays`), so from the step after the
first step the window reads on the course as it was (`share_corrected_on_course`).
Nothing here re-proves `locked_stays`, `lock_line`, `window_never_read`, `window_past_course` or
`course_past`; `locked_alone` is
`locked_stays`'s counterpart on `windowAlone` from any step count, by the same law, `turn_locked`. -/

section Lock

open Pace RuleCapture ClosedCapture PoolFromCourse

universe w

variable {A : Type u} {B : Type v} {R : Type w}

/-- **The locked region is closed under the joined two-level step.** Where the selection raises the
share under every favouring rule (`Raises`), the rule read is monotone in the share (`ReadsShare`)
and favouring is kept by a rule not lower (`upper`), whatever
`Law.step (Pace.step (join fA fB) (joinRead hA) reads)` relates to a configuration whose share and rule
are `Locked` has its share and rule `Locked`, at reading steps and elsewhere. No `Accrues` is used: the
step on what lies beyond the share is any `fB`. -/
theorem locked_closed {P : Ideals.Preorder A} {M : Ideals.Preorder R} {favours : R → Prop}
    {fA : A → R → A} {fB : A × B → R → B} {hA : A → R → R} {reads : Nat → Bool}
    (raises : Raises P favours fA) (monotone : ReadsShare P M hA)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g') :
    «闭» (Law.step (Pace.step (join fA fB) (joinRead hA) reads))
      (fun q : (A × B) × R × Nat => Locked M favours hA (q.1.1, q.2.1)) :=
  fun q _ lock step =>
    have joined := turn_join fA fB hA (reads q.2.2) (q.1, q.2.1) (q.1.1, q.2.1) rfl rfl
    have kept := (turn_locked raises monotone upper (reads q.2.2) (q.1.1, q.2.1) lock).1
    Eq.subst (motive := fun q' : (A × B) × R × Nat => Locked M favours hA (q'.1.1, q'.2.1)) step.symm
      (Eq.subst (motive := fun p : A × R => Locked M favours hA p)
        (congr (congrArg Prod.mk joined.1) joined.2).symm kept)

/-- **At a locked member the class of being locked or not meets the root's condition at the member's
class (`«本类至终有常»`), and what the member conditions is alike to it (`«所缘同于»`).** Under the premises of `locked_closed`, at a configuration `m`
of the joined two-level step whose share and rule are `Locked`, `«本类至终有常»` and `«所缘同于»` hold
for `ClosedCapture.lockedAlike`: the locked region closed under the step (`locked_closed`) is the
member's block, and `«类闭则本类常闭»` gives both, its decidedness met because the step is total. -/
theorem locked_at_class {P : Ideals.Preorder A} {M : Ideals.Preorder R} {favours : R → Prop}
    {fA : A → R → A} {fB : A × Nat → R → Nat} {hA : A → R → R} {reads : Nat → Bool}
    (raises : Raises P favours fA) (monotone : ReadsShare P M hA)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g') {m : (A × Nat) × R × Nat}
    (locked : Locked M favours hA (m.1.1, m.2.1)) :
    «本类至终有常» (Law.step (Pace.step (join fA fB) (joinRead hA) reads)) (lockedAlike M favours hA) m ∧
      «所缘同于» (Law.step (Pace.step (join fA fB) (joinRead hA) reads)) (lockedAlike M favours hA) m :=
  «类闭则本类常闭» (lockedAlike_class M favours hA)
    (fun u v alike step =>
      ⟨fun _ => locked_closed raises monotone upper u v (alike.mp locked) step, fun _ => locked⟩)
    (fun _ _ => .inl ⟨_, rfl⟩)

/-- The regrouping of a configuration of the joined two-level step: what the loop reads
(`ClosedCapture.loopPart`: the share, the rule and the step count) as the way, the loss
(`ClosedCapture.loss`) as the level. -/
def windowRegroup (q : (A × Nat) × R × Nat) : (A × R × Nat) × Nat :=
  (ClosedCapture.loopPart q, ClosedCapture.loss q)

/-- The way after a step of the window course, read off `Pace.step`, `ClosedCapture.join` and
`PoolFromCourse.windowRead`: the share steps by `fA`, the rule is read through the window where the
schedule reads and kept elsewhere, and the step count goes up by one. -/
def windowAfter (fA : A → R → A) (hA : A → R → R) (hL : A × Nat → R → R) (N K : Nat)
    (reads : Nat → Bool) (w : A × R × Nat) (x : Nat) : A × R × Nat :=
  (fA w.1 w.2.1, bif reads w.2.2 then windowRead hA hL N K (w.1, x) w.2.1 else w.2.1, w.2.2 + 1)

/-- The level after a step of the window course: the loss steps by `fB`. -/
def windowLeft (fB : A × Nat → R → Nat) (w : A × R × Nat) (x : Nat) : Nat := fB (w.1, x) w.2.1

/-- The way after a step where the rule is read off the share alone, by `hA`, on the same schedule. -/
def windowAlone (fA : A → R → A) (hA : A → R → R) (reads : Nat → Bool) (w : A × R × Nat) :
    A × R × Nat :=
  (fA w.1 w.2.1, bif reads w.2.2 then hA w.1 w.2.1 else w.2.1, w.2.2 + 1)

/-- `windowAlone`'s share and rule are one `Pace.turn` of the share and rule, reading where the
schedule reads at the step count. Needed by `locked_alone`. -/
private theorem windowAlone_turn (fA : A → R → A) (hA : A → R → R) (reads : Nat → Bool)
    (v : A × R × Nat) :
    ((windowAlone fA hA reads v).1, (windowAlone fA hA reads v).2.1) =
      Pace.turn fA hA (reads v.2.2) (v.1, v.2.1) :=
  (fun b => match b with
    | true => (rfl : ((fA v.1 v.2.1, hA v.1 v.2.1) : A × R) = Pace.turn fA hA true (v.1, v.2.1))
    | false => (rfl : ((fA v.1 v.2.1, v.2.1) : A × R) = Pace.turn fA hA false (v.1, v.2.1)) :
    ∀ b : Bool, ((fA v.1 v.2.1, bif b then hA v.1 v.2.1 else v.2.1) : A × R) =
      Pace.turn fA hA b (v.1, v.2.1)) (reads v.2.2)

/-- **Along the way's step as it was, a way whose share and rule are `Locked` stays so.** Where the
selection raises the share under every favouring rule (`Raises`), the rule read is monotone in the
share (`ReadsShare`) and favouring is kept by a rule not lower (`upper`), from a way `w` whose share and
rule are `Locked`, the way `windowAlone fA hA reads` taken `n` times has its share and rule `Locked`,
for every `n`. By `RuleCapture.turn_locked`: `windowAlone`'s share and rule are
`Pace.turn fA hA (reads w.2.2) (w.1, w.2.1)`. -/
theorem locked_alone {P : Ideals.Preorder A} {M : Ideals.Preorder R} {favours : R → Prop}
    {fA : A → R → A} {hA : A → R → R} {reads : Nat → Bool}
    (raises : Raises P favours fA) (monotone : ReadsShare P M hA)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g') {w : A × R × Nat}
    (locked : Locked M favours hA (w.1, w.2.1)) :
    ∀ n, Locked M favours hA ((Law.orbit (windowAlone fA hA reads) w n).1,
      (Law.orbit (windowAlone fA hA reads) w n).2.1)
  | 0 => locked
  | n + 1 =>
    Eq.subst (motive := fun p : A × R => Locked M favours hA p)
      (windowAlone_turn fA hA reads (Law.orbit (windowAlone fA hA reads) w n)).symm
      (turn_locked raises monotone upper _ _ (locked_alone raises monotone upper locked n)).1

/-- **A `Locked` way that needs a level ends `Locked`, where the net ends.** The way's step as it was
is the lock's (`windowAlone`: the share steps by `fA`, the rule is read off the share by `hA` where the
schedule `reads` reads at the step count and kept elsewhere, the step count goes up by one); the
level's step `left` is any. Where the selection raises the share under every favouring rule
(`Raises`), the rule read is monotone in the share (`ReadsShare`) and favouring is kept by a rule not
lower (`upper`); at every level not marked the way after a step is `windowAlone` of the way
(`AloneOutside`); the need is positive (`needs`) and no marked level meets it (`un`); and the level of
the course as it was steps in `Optimum`'s form (`step`), at most `r` given (`renews`) and more than
`r` taken (`over`) at every step: then from a start `s` whose share and rule are `Locked`, within
`s.2` steps the line reaches a configuration that conditions nothing, its share and rule still
`Locked`. It is `ends_with_net` with `locked_alone`; no `Accrues` is used. It is read as the
counterpart of `ClosedCapture.lock_outlives_loss` where what is used up is a level the going on needs:
there the lock stays and the loss grows without end, here the lock stays and the line ends. That is a
reading of the two statements, not a derivation of one from the other. -/
theorem locked_ends_with_net {P : Ideals.Preorder A} {M : Ideals.Preorder R} {favours : R → Prop}
    {fA : A → R → A} {hA : A → R → R} {reads : Nat → Bool}
    (raises : Raises P favours fA) (monotone : ReadsShare P M hA)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g') {marked : Nat → Prop}
    {after : A × R × Nat → Nat → A × R × Nat} {left : A × R × Nat → Nat → Nat}
    (outside : AloneOutside marked (windowAlone fA hA reads) after) {need : Nat} (needs : 0 < need)
    (un : ∀ x, need ≤ x → ¬ marked x) {s : (A × R × Nat) × Nat}
    (locked : Locked M favours hA (s.1.1, s.1.2.1)) {g d : Nat → Nat} {r : Nat}
    (step : ∀ t, (Law.orbit (asItWas (windowAlone fA hA reads) left) s (t + 1)).2 =
      (Law.orbit (asItWas (windowAlone fA hA reads) left) s t).2 + g t - d t)
    (renews : ∀ t, g t ≤ r) (over : ∀ t, r < d t) :
    ∃ n t, n ≤ s.2 ∧ «迭» (net need after left) n s t ∧ (∀ v, ¬ net need after left t v) ∧
      Locked M favours hA (t.1.1, t.1.2.1) :=
  match ends_with_net outside needs un step renews over with
  | ⟨n, t, within, line, ends, way⟩ =>
    ⟨n, t, within, line, ends,
      Eq.subst (motive := fun z : A × R × Nat => Locked M favours hA (z.1, z.2.1)) way.symm
        (locked_alone raises monotone upper locked n)⟩

/-- **Along the way's step as it was, from a `Locked` way, the share and the rule are never below
the start's.** Where the selection raises the share under every favouring rule (`Raises`), the rule
read is monotone in the share (`ReadsShare`) and favouring is kept by a rule not lower (`upper`), from
a way `w` whose share and rule are `Locked`, the way `windowAlone fA hA reads` taken `n` times has its
share not below `w`'s (`P.le`) and its rule not below `w`'s (`M.le`), for every `n`. By
`RuleCapture.turn_locked`'s two not-below conjuncts at each step, the way there `Locked` by
`locked_alone`, with the orders' transitivity: `windowAlone`'s share and rule are
`Pace.turn fA hA (reads w.2.2) (w.1, w.2.1)`. It is `RuleCapture.locked_not_below`'s counterpart on
`windowAlone` from any step count, as `locked_alone` is `locked_stays`'s. -/
theorem locked_alone_not_below {P : Ideals.Preorder A} {M : Ideals.Preorder R} {favours : R → Prop}
    {fA : A → R → A} {hA : A → R → R} {reads : Nat → Bool}
    (raises : Raises P favours fA) (monotone : ReadsShare P M hA)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g') {w : A × R × Nat}
    (locked : Locked M favours hA (w.1, w.2.1)) :
    ∀ n, P.le w.1 (Law.orbit (windowAlone fA hA reads) w n).1 ∧
      M.le w.2.1 (Law.orbit (windowAlone fA hA reads) w n).2.1
  | 0 => ⟨P.refl _, M.refl _⟩
  | n + 1 =>
    have held := locked_alone_not_below raises monotone upper (reads := reads) locked n
    have turned := turn_locked raises monotone upper
      (reads (Law.orbit (windowAlone fA hA reads) w n).2.2) _
      (locked_alone raises monotone upper (reads := reads) locked n)
    Eq.subst (motive := fun p : A × R => P.le w.1 p.1 ∧ M.le w.2.1 p.2)
      (windowAlone_turn fA hA reads (Law.orbit (windowAlone fA hA reads) w n)).symm
      ⟨P.trans held.1 turned.2.1, M.trans held.2 turned.2.2⟩

/-- **A `Locked` way that uses at least `H` wherever its share and rule are not below the start's,
from a level below `H + y`, ends `Locked` where the net ends.** The way's step as it was is the lock's
(`windowAlone`), and the level's step is the regime's, `RegimeMargin.step giving (use w)`: the way
uses `use w` first and giving gives of what is left. Where the selection raises the share under every
favouring rule (`Raises`), the rule read is monotone in the share (`ReadsShare`) and favouring is kept
by a rule not lower (`upper`); at every level not marked the way after a step is `windowAlone` of the
way (`outside`, an `AloneOutside`; on the window it is `window_alone_outside`, with the levels in
`[N, K)` marked, and `locked_ends_on_window` states this law there); the need is positive (`needs`)
and no marked level meets it (`un`); nothing is given from nothing (`RegimeMargin.FromNothing giving`)
and giving falls short of `H` at every level below `y` (`RegimeMargin.Short giving H y`); every way
whose share and rule are not below the start's uses at least `H` (`draws`); and the start's level `x`
is below `H + y` (`below`): then from a start `(w, x)` whose share and rule are `Locked`, within `x`
steps the line reaches a configuration that conditions nothing, its way `windowAlone` taken that many
times, its share and rule still `Locked`. Unlike `locked_ends_with_net`, no premise is on the level's
course: the uses of at least `H` along `windowAlone`'s orbit, which `ends_with_net_regime` asks for and
from which it derives the level's fall, come from `draws` through `locked_alone_not_below`, so the
lock's premises are what keep the use from falling below `H` along the course. That the use reads the
rule (or the share) is a reading of `draws`, which asks only a floor. What stays assumed: the start
lies below `H + y` (`below`, with `short`: `H + y` is `RegimeMargin`'s point of no return under a
standing use `H`, so the start is already past it); the floor on the use wherever the share and the
rule are not below the start's (`draws`, asked at every step count, though only counts from the
start's on occur along the course); the not-responding, no marked level meeting the need (`un`) and
the lock's step as it was outside the marks (`outside`); and the positive need (`needs`). In this
law the lock keeps an overdraw that stands; it does not bring one about. By `ends_with_net_regime`,
`locked_alone_not_below` and `locked_alone`. `Three.lock_ends` meets every premise on the lock's own
types; `Three.rise_lock_ends` meets them where the share rises at each step, which does not show that
the rise bears on the ending, since the use there reads only the rule. -/
theorem locked_ends_with_net_regime {P : Ideals.Preorder A} {M : Ideals.Preorder R}
    {favours : R → Prop} {fA : A → R → A} {hA : A → R → R} {reads : Nat → Bool}
    (raises : Raises P favours fA) (monotone : ReadsShare P M hA)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g') {marked : Nat → Prop}
    {after : A × R × Nat → Nat → A × R × Nat}
    (outside : AloneOutside marked (windowAlone fA hA reads) after) {need : Nat} (needs : 0 < need)
    (un : ∀ x, need ≤ x → ¬ marked x) {giving : Nat → Nat} {use : A × R × Nat → Nat} {H y : Nat}
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    {w : A × R × Nat} {x : Nat} (locked : Locked M favours hA (w.1, w.2.1))
    (draws : ∀ v : A × R × Nat, P.le w.1 v.1 → M.le w.2.1 v.2.1 → H ≤ use v)
    (below : x < H + y) :
    ∃ n t, n ≤ x ∧
      «迭» (net need after (fun w x => RegimeMargin.step giving (use w) x)) n (w, x) t ∧
      (∀ v, ¬ net need after (fun w x => RegimeMargin.step giving (use w) x) t v) ∧
      t.1 = Law.orbit (windowAlone fA hA reads) w n ∧ Locked M favours hA (t.1.1, t.1.2.1) :=
  have held := locked_alone_not_below raises monotone upper (reads := reads) locked
  match ends_with_net_regime outside needs un nothing short (w := w) (x := x)
      (fun j => draws _ (held j).1 (held j).2) below with
  | ⟨n, t, within, line, ends, way⟩ =>
    ⟨n, t, within, line, ends, way,
      Eq.subst (motive := fun z : A × R × Nat => Locked M favours hA (z.1, z.2.1)) way.symm
        (locked_alone raises monotone upper (reads := reads) locked n)⟩

/-- **A `Locked` way whose use rises under each step of the lock, wherever its share and rule are not
below the start's, against a level that cannot pass `hi`, ends `Locked` within `hi + 1` steps.** As
`locked_ends_with_net_regime`, with its `short`, `draws` and `below` replaced: the step under no use
keeps every level up to `hi` within `hi` (`keeps`, `RegimeMargin.Keeps giving 0 hi`), the start's level
`x` is at most `hi` (`high`), and every way whose share and rule are not below the start's uses less
than the way the lock's step as it was makes of it (`more`). The other premises are
`locked_ends_with_net_regime`'s: `Raises`, `ReadsShare` and favouring kept upward (`raises`,
`monotone`, `upper`), `outside`, a positive need (`needs`) that no marked level meets (`un`), nothing
given from nothing (`nothing`) and the `Locked` start (`locked`). Then within `hi + 1` steps the line
from `(w, x)` reaches a configuration that conditions nothing, its way `windowAlone` taken that many
times, its share and rule still `Locked`. By `ends_with_net_rising`, its `rises` from `more` through
`locked_alone_not_below`, and `locked_alone`. The lock's premises keep the share and the rule along the
lock's own course not below the start's, so that `more` applies at each of its steps, and they give
the last conjunct, the end `Locked`; they are used for nothing else. `more` does not ask that the use
read the share or the rule: a use that reads only the step count meets it with the share never moving
(argued here from `windowAlone` adding one to the step count, not a Lean statement). That the use rises with the share is `count_rises`'s case. What is concluded is the ending; no step past
a point of no return is stated. -/
theorem locked_ends_rising {P : Ideals.Preorder A} {M : Ideals.Preorder R}
    {favours : R → Prop} {fA : A → R → A} {hA : A → R → R} {reads : Nat → Bool}
    (raises : Raises P favours fA) (monotone : ReadsShare P M hA)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g') {marked : Nat → Prop}
    {after : A × R × Nat → Nat → A × R × Nat}
    (outside : AloneOutside marked (windowAlone fA hA reads) after) {need : Nat} (needs : 0 < need)
    (un : ∀ x, need ≤ x → ¬ marked x) {giving : Nat → Nat} {use : A × R × Nat → Nat} {hi : Nat}
    (nothing : RegimeMargin.FromNothing giving) (keeps : RegimeMargin.Keeps giving 0 hi)
    {w : A × R × Nat} {x : Nat} (high : x ≤ hi) (locked : Locked M favours hA (w.1, w.2.1))
    (more : ∀ v : A × R × Nat, P.le w.1 v.1 → M.le w.2.1 v.2.1 →
      use v < use (windowAlone fA hA reads v)) :
    ∃ n t, n ≤ hi + 1 ∧
      «迭» (net need after (fun w x => RegimeMargin.step giving (use w) x)) n (w, x) t ∧
      (∀ v, ¬ net need after (fun w x => RegimeMargin.step giving (use w) x) t v) ∧
      t.1 = Law.orbit (windowAlone fA hA reads) w n ∧ Locked M favours hA (t.1.1, t.1.2.1) :=
  have held := locked_alone_not_below raises monotone upper (reads := reads) locked
  match ends_with_net_rising outside needs un nothing keeps (w := w) high
      (fun j _ => more _ (held j).1 (held j).2) with
  | ⟨n, t, within, line, ends, way⟩ =>
    ⟨n, t, within, line, ends, way,
      Eq.subst (motive := fun z : A × R × Nat => Locked M favours hA (z.1, z.2.1)) way.symm
        (locked_alone raises monotone upper (reads := reads) locked n)⟩

/-- **Where the share is a count that every favouring rule raises strictly and the use is that count
times a positive amount, the use rises under one step of the lock's step as it was, from every way whose rule
is not below a favouring rule.** The share a natural number (`A = Nat`, with any order `P`); every
favouring rule raises it strictly (`rise`); the use of a way its share times `u` (`count`), with `u`
positive (`pos`); favouring kept by a rule not lower (`upper`); and the rule of `w` favouring (`fav`):
then every way `v` whose rule is not below `w`'s uses less than `windowAlone fA hA reads v`. This is
`locked_ends_rising`'s premise `more` at a start `w` whose rule favours, as a `Locked` start's does
(the first half of `Locked`). Used: `v`'s rule favours (by `upper` from `w`'s), so the share rises by
`rise`, and the use with it by `count` and `pos`. Not used: the share's order (`P.le w.1 v.1`, asked
only so that the form is `more`'s) and the reading (`hA`, `reads`). -/
theorem count_rises {P : Ideals.Preorder Nat} {M : Ideals.Preorder R} {favours : R → Prop}
    {fA : Nat → R → Nat} {hA : Nat → R → R} {reads : Nat → Bool}
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g')
    (rise : ∀ a g, favours g → a < fA a g) {use : Nat × R × Nat → Nat} {u : Nat} (pos : 0 < u)
    (count : ∀ v, use v = v.1 * u) {w : Nat × R × Nat} (fav : favours w.2.1) :
    ∀ v : Nat × R × Nat, P.le w.1 v.1 → M.le w.2.1 v.2.1 →
      use v < use (windowAlone fA hA reads v) :=
  fun v _ ruleUp =>
    Eq.subst (motive := fun z => z < use (windowAlone fA hA reads v)) (count v).symm
      (Eq.subst (motive := fun z => v.1 * u < z) (count (windowAlone fA hA reads v)).symm
        (Nat.mul_lt_mul_of_pos_right (rise v.1 v.2.1 (upper ruleUp fav)) pos))

/-- One step of the joined two-level step with any reading `h`, regrouped, is one step of the pair.
Needed by `regroup_orbit`. -/
private theorem regroup_step (fA : A → R → A) (fB : A × Nat → R → Nat) (h : A × Nat → R → R)
    (reads : Nat → Bool) (q : (A × Nat) × R × Nat) :
    windowRegroup (Pace.step (join fA fB) h reads q) =
      pair (fun w x => (fA w.1 w.2.1, bif reads w.2.2 then h (w.1, x) w.2.1 else w.2.1, w.2.2 + 1))
        (windowLeft fB) (windowRegroup q) :=
  match q with
  | ((a, x), g, n) =>
    have each : ∀ b : Bool,
        (((Pace.turn (join fA fB) h b ((a, x), g)).1.1,
            (Pace.turn (join fA fB) h b ((a, x), g)).2, n + 1),
          (Pace.turn (join fA fB) h b ((a, x), g)).1.2) =
        ((fA a g, bif b then h (a, x) g else g, n + 1), fB (a, x) g)
      | true => rfl
      | false => rfl
    each (reads n)

/-- The joined two-level course with any reading `h`, regrouped, is at every step the orbit of the
pair. One induction, used by `window_is_pair` and `join_is_asItWas`. -/
private theorem regroup_orbit (fA : A → R → A) (fB : A × Nat → R → Nat) (h : A × Nat → R → R)
    (reads : Nat → Bool) (c : (A × Nat) × R × Nat) :
    ∀ t, windowRegroup (Law.orbit (Pace.step (join fA fB) h reads) c t) =
      Law.orbit (pair (fun w x => (fA w.1 w.2.1, bif reads w.2.2 then h (w.1, x) w.2.1 else w.2.1,
        w.2.2 + 1)) (windowLeft fB)) (windowRegroup c) t
  | 0 => rfl
  | t + 1 =>
    (regroup_step fA fB h reads _).trans
      (congrArg (pair (fun w x => (fA w.1 w.2.1, bif reads w.2.2 then h (w.1, x) w.2.1 else w.2.1,
        w.2.2 + 1)) (windowLeft fB)) (regroup_orbit fA fB h reads c t))

/-- Two configurations of the joined two-level step with one regrouping are one. Needed by
`window_agrees_until_marked`. -/
private theorem windowRegroup_inj {q q' : (A × Nat) × R × Nat}
    (e : windowRegroup q = windowRegroup q') : q = q' :=
  congrArg (fun p : (A × R × Nat) × Nat => ((p.1.1, p.2), p.1.2.1, p.1.2.2)) e

/-- **The window course is a course of the pair, by regrouping.** For every start `c` and step `t`,
the configuration `t` steps along `Pace.step (join fA fB) (windowRead hA hL N K) reads` from `c`,
regrouped by `windowRegroup`, is the configuration `t` steps along `pair (windowAfter …) (windowLeft fB)`
from `c` regrouped. On `PoolFromCourse`'s own course function, `window_paced`. -/
theorem window_is_pair (fA : A → R → A) (fB : A × Nat → R → Nat) (hA : A → R → R)
    (hL : A × Nat → R → R) (N K : Nat) (reads : Nat → Bool) (c : (A × Nat) × R × Nat) :
    ∀ t, windowRegroup (Law.orbit (Pace.step (join fA fB) (windowRead hA hL N K) reads) c t) =
      Law.orbit (pair (windowAfter fA hA hL N K reads) (windowLeft fB)) (windowRegroup c) t :=
  regroup_orbit fA fB (windowRead hA hL N K) reads c

/-- **The joined step that reads off the share, regrouped, is the window pair's step as it was.** For
every start `c` and step `t`, the configuration `t` steps along
`Pace.step (join fA fB) (joinRead hA) reads` from `c`, regrouped, is the configuration `t` steps along
`asItWas (windowAlone fA hA reads) (windowLeft fB)` from `c` regrouped. -/
theorem join_is_asItWas (fA : A → R → A) (fB : A × Nat → R → Nat) (hA : A → R → R)
    (reads : Nat → Bool) (c : (A × Nat) × R × Nat) :
    ∀ t, windowRegroup (Law.orbit (Pace.step (join fA fB) (joinRead hA) reads) c t) =
      Law.orbit (asItWas (windowAlone fA hA reads) (windowLeft fB)) (windowRegroup c) t :=
  regroup_orbit fA fB (joinRead hA) reads c

/-- **Outside the window the way after a step is the share's reading.** At every level not in
`[N, K)`, `windowAfter` is `windowAlone`: the window reads the rule off the share by `hA` there, on the
same schedule. -/
theorem window_alone_outside (fA : A → R → A) (hA : A → R → R) (hL : A × Nat → R → R) (N K : Nat)
    (reads : Nat → Bool) :
    AloneOutside (fun x => N ≤ x ∧ x < K) (windowAlone fA hA reads) (windowAfter fA hA hL N K reads) :=
  fun w _ outside =>
    congrArg (fun g => (fA w.1 w.2.1, bif reads w.2.2 then g else w.2.1, w.2.2 + 1))
      (if_neg outside)

/-- **On the window, a `Locked` way that uses at least `H` wherever its share and rule are not below
the start's, from a level below `H + y`, ends `Locked` where the net ends.** `locked_ends_with_net_regime`
with the way after a step `windowAfter fA hA hL N K reads`, the window's reading of the rule off the
share and the level by `hL` at levels in `[N, K)`, and the levels in `[N, K)` marked
(`window_alone_outside`). No marked level meets the need exactly where `K ≤ N` (the window holds no
level) or `K ≤ need` (the window lies below the need): `un` here. The level's step is the regime's,
`RegimeMargin.step giving (use w)`, not the window course's loss step `windowLeft fB`; that the loss
steps so is not stated. The premises are otherwise `locked_ends_with_net_regime`'s, and what stays
assumed there stays assumed here: the start below `H + y` (`below`), the floor on the use (`draws`) and
the not-responding, here `un`. -/
theorem locked_ends_on_window {P : Ideals.Preorder A} {M : Ideals.Preorder R} {favours : R → Prop}
    {fA : A → R → A} {hA : A → R → R} (hL : A × Nat → R → R) (N K : Nat) {reads : Nat → Bool}
    (raises : Raises P favours fA) (monotone : ReadsShare P M hA)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g') {need : Nat} (needs : 0 < need)
    (un : K ≤ N ∨ K ≤ need) {giving : Nat → Nat} {use : A × R × Nat → Nat} {H y : Nat}
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    {w : A × R × Nat} {x : Nat} (locked : Locked M favours hA (w.1, w.2.1))
    (draws : ∀ v : A × R × Nat, P.le w.1 v.1 → M.le w.2.1 v.2.1 → H ≤ use v)
    (below : x < H + y) :
    ∃ n t, n ≤ x ∧
      «迭» (net need (windowAfter fA hA hL N K reads)
        (fun w x => RegimeMargin.step giving (use w) x)) n (w, x) t ∧
      (∀ v, ¬ net need (windowAfter fA hA hL N K reads)
        (fun w x => RegimeMargin.step giving (use w) x) t v) ∧
      t.1 = Law.orbit (windowAlone fA hA reads) w n ∧ Locked M favours hA (t.1.1, t.1.2.1) :=
  locked_ends_with_net_regime raises monotone upper (window_alone_outside fA hA hL N K reads) needs
    (fun z ge inside => un.elim
      (fun kn => Nat.lt_irrefl z (Nat.lt_of_lt_of_le inside.2 (Nat.le_trans kn inside.1)))
      (fun kneed => Nat.lt_irrefl z (Nat.lt_of_lt_of_le inside.2 (Nat.le_trans kneed ge))))
    nothing short locked draws below

/-- **Where every step reads and the window's reading of the level gives a `kept` rule, at a level in
`[N, K)` the rule after a step of the window is `kept`.** Every step reads (`every`), and at every level
in `[N, K)` the window's reading `hL` gives a rule that is `kept`, whatever the share and the rule in
force (`corrects`): then from any way `v` at a level `z` with `N ≤ z` (`read`) and `z < K`
(`inside`), the rule of `windowAfter fA hA hL N K reads v z` is `kept`. The share's step `fA` and the
reading off the share `hA` are any. -/
theorem window_corrected (fA : A → R → A) (hA : A → R → R) (hL : A × Nat → R → R) (N K : Nat)
    {reads : Nat → Bool} (every : ∀ n, reads n = true) {kept : R → Prop}
    (corrects : ∀ (p : A × Nat) (g : R), N ≤ p.2 → p.2 < K → kept (hL p g))
    (v : A × R × Nat) (z : Nat) (read : N ≤ z) (inside : z < K) :
    kept (windowAfter fA hA hL N K reads v z).2.1 :=
  Eq.subst (motive := kept)
    ((congrArg (fun b : Bool => bif b then windowRead hA hL N K (v.1, z) v.2.1 else v.2.1)
      (every v.2.2)).trans (if_pos ⟨read, inside⟩)).symm
    (corrects (v.1, z) v.2.1 read inside)

/-- **On a window that starts at or below `H₂ + y₂` and ends at or above `c`, a `Locked` way from a
level below `H₁ + y₁` never ends exactly where its first step at a level the window reads leaves the
level at or above `H₂ + y₂`.** `turns_in_time_iff_kept_below`
with the levels in `[N, K)` marked, the lock's step as it was (`windowAlone fA hA reads`) as `alone`,
the way after a step `windowAfter fA hA hL N K reads` (`window_alone_outside`), and the kept kind the
ways whose rule is `kept`. The steps are those of the lock's own course, the orbit of
`asItWas (windowAlone fA hA reads)` from `(w, x)`: the line never ends exactly where there is a step `T`
of it, the need met and the level not one the window reads before it, the need met and the level one the
window reads at it, and its level at `T + 1` at or above `H₂ + y₂`. What the lock's premises do here:
under `Raises`, `ReadsShare` and favouring kept upward (`raises`, `monotone`, `upper`), from a `Locked`
start (`locked`) the share and the rule along the lock's own course are never below the start's
(`locked_alone_not_below`), so with `draws` every way on it uses at least `H₁`, at every step: the uses
under which the level falls up to the first step the window reads are held at or above `H₁` by the
lock's premises, as in `locked_ends_with_net_regime`, while that the start is below `H₁ + y₁` stays
given (`below`). From a start that is not `Locked` the statement can fail: on `Three.unlocked_goes_on`
the line never ends with no step read, and every other premise is met there (argued in its docstring,
not a Lean statement). Nothing is concluded about whether the way that goes on is `Locked`. The
level's step is the regime's, `RegimeMargin.step giving (use w)`, not the window course's loss step
`windowLeft fB`.
`turns` and `keptBelow` of the law used are concluded from where the window lies, by `window_corrected`:
every step reads (`every`), the window's reading gives a `kept` rule at every level in `[N, K)`
(`corrects`), the window starts at or below `H₂ + y₂` (`low`) and ends at or above `c` (`covers`). What
stays given: `corrects`, `every`, `low` and `covers`; every way's step taking every level from `c` up to
`hi` to a level from `c` up to `hi` (`safe`); a use of at least `H₂` at every way (`least`, which gives
the law's `floor`) and the use `H₂` of a way whose rule is `kept` (`uses`); the regime premises
(`nothing`, `short`, `meets`, `keeps`); the need, positive (`needs`) and at most `H₂ + y₂` (`within`);
`c` above nothing (`pos`); giving short of `H₁` below `y₁` (`short₁`); the floor `H₁` on the use where
the share and the rule are not below the start's (`draws`); the start below `H₁ + y₁` (`below`); and, at
every step of the lock's own course at a level the window reads, its level one step later at most `hi`
(`high`). Where `c` is at most `hi` (argued here, not a Lean statement): `safe` at the start's way and
the level `c`, with `draws` there and `held_above`, puts `H₁ + y₁` at or below `c`, so the start is
below `c`, so below `K`; the level of the lock's own course never rises, so if the window reads any of
its steps it reads step 0. A later first step the window reads occurs only where `c` is above `hi`, that
is, where after the turn the level stays below `c`, so below the window's end. -/
theorem locked_turns_in_time_on_window_iff {P : Ideals.Preorder A} {M : Ideals.Preorder R}
    {favours : R → Prop} {fA : A → R → A} {hA : A → R → R} (hL : A × Nat → R → R) (N K : Nat)
    {reads : Nat → Bool}
    (raises : Raises P favours fA) (monotone : ReadsShare P M hA)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g')
    (every : ∀ n, reads n = true)
    {kept : R → Prop} (corrects : ∀ (p : A × Nat) (g : R), N ≤ p.2 → p.2 < K → kept (hL p g))
    {giving : Nat → Nat} {use : A × R × Nat → Nat} {H₁ y₁ H₂ y₂ hi need c : Nat}
    (uses : ∀ v : A × R × Nat, kept v.2.1 → use v = H₂) (least : ∀ v : A × R × Nat, H₂ ≤ use v)
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H₂ y₂)
    (meets : RegimeMargin.Meets giving H₂ y₂ hi) (keeps : RegimeMargin.Keeps giving H₂ hi)
    (needs : 0 < need) (within : need ≤ H₂ + y₂) (pos : 0 < c)
    (low : N ≤ H₂ + y₂) (covers : c ≤ K)
    (safe : ∀ (v : A × R × Nat) (x : Nat), c ≤ x → x ≤ hi →
      c ≤ RegimeMargin.step giving (use v) x ∧ RegimeMargin.step giving (use v) x ≤ hi)
    (short₁ : RegimeMargin.Short giving H₁ y₁)
    {w : A × R × Nat} {x : Nat} (locked : Locked M favours hA (w.1, w.2.1))
    (draws : ∀ v : A × R × Nat, P.le w.1 v.1 → M.le w.2.1 v.2.1 → H₁ ≤ use v)
    (below : x < H₁ + y₁)
    (high : ∀ T, (N ≤ (Law.orbit (asItWas (windowAlone fA hA reads)
          (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).2 ∧
        (Law.orbit (asItWas (windowAlone fA hA reads)
          (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).2 < K) →
      (Law.orbit (asItWas (windowAlone fA hA reads)
        (fun w x => RegimeMargin.step giving (use w) x)) (w, x) (T + 1)).2 ≤ hi) :
    «不穷» (net need (windowAfter fA hA hL N K reads)
        (fun w x => RegimeMargin.step giving (use w) x)) «一» (w, x) ↔
      ∃ T, (∀ j, j < T →
          need ≤ (Law.orbit (asItWas (windowAlone fA hA reads)
            (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2 ∧
          ¬ (N ≤ (Law.orbit (asItWas (windowAlone fA hA reads)
              (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2 ∧
            (Law.orbit (asItWas (windowAlone fA hA reads)
              (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2 < K)) ∧
        need ≤ (Law.orbit (asItWas (windowAlone fA hA reads)
          (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).2 ∧
        (N ≤ (Law.orbit (asItWas (windowAlone fA hA reads)
            (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).2 ∧
          (Law.orbit (asItWas (windowAlone fA hA reads)
            (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).2 < K) ∧
        H₂ + y₂ ≤ (Law.orbit (asItWas (windowAlone fA hA reads)
          (fun w x => RegimeMargin.step giving (use w) x)) (w, x) (T + 1)).2 :=
  have held := locked_alone_not_below raises monotone upper (reads := reads) locked
  turns_in_time_iff_kept_below (marked := fun z => N ≤ z ∧ z < K) (alone := windowAlone fA hA reads)
    (after := windowAfter fA hA hL N K reads) (Kept := fun v => kept v.2.1)
    (window_alone_outside fA hA hL N K reads)
    (fun v z read => window_corrected fA hA hL N K every corrects v z read.1 read.2)
    uses nothing short meets keeps needs within pos
    (fun v z _ lo lt => window_corrected fA hA hL N K every corrects v z (Nat.le_trans low lo)
      (Nat.lt_of_lt_of_le lt covers))
    safe (fun _ _ _ _ => least _) short₁ (fun j => draws _ (held j).1 (held j).2) below high

/-- **The window course is the course that reads off the share up to the first step at which that
course's loss lies in `[N, K)`.** For every start `c` and step `n`: where at no step before `n` the
loss of the course along `Pace.step (join fA fB) (joinRead hA) reads` from `c` lies in `[N, K)`, the
window course from `c` is that course at `n`. `agrees_until_marked` read on the window, through
`window_is_pair`, `join_is_asItWas` and `window_alone_outside`. Its neighbours: `window_through` and
`window_past` (past `K` the window reads off the share, pointwise), `window_unread` (at `K ≤ N` it
reads off the share at every configuration: the case with no marked level),
`window_past_course` (past `K`, the window course is the share's own loop from where it is) and
`course_past` (two readings that agree past a bound give one course from a start past it); none of
them says that the window course is the course read off the share before its loss is first marked. -/
theorem window_agrees_until_marked (fA : A → R → A) (fB : A × Nat → R → Nat) (hA : A → R → R)
    (hL : A × Nat → R → R) (N K : Nat) (reads : Nat → Bool) (c : (A × Nat) × R × Nat) :
    ∀ n,
    (∀ j, j < n → ¬ (N ≤ (Law.orbit (Pace.step (join fA fB) (joinRead hA) reads) c j).1.2 ∧
        (Law.orbit (Pace.step (join fA fB) (joinRead hA) reads) c j).1.2 < K)) →
      Law.orbit (Pace.step (join fA fB) (windowRead hA hL N K) reads) c n =
        Law.orbit (Pace.step (join fA fB) (joinRead hA) reads) c n :=
  fun n before =>
    windowRegroup_inj ((window_is_pair fA fB hA hL N K reads c n).trans
      ((agrees_until_marked (window_alone_outside fA hA hL N K reads) (windowLeft fB)
          (windowRegroup c) n
          (fun j lt => Eq.subst (motive := fun z : (A × R × Nat) × Nat => ¬ (N ≤ z.2 ∧ z.2 < K))
            (join_is_asItWas fA fB hA reads c j) (before j lt))).trans
        (join_is_asItWas fA fB hA reads c n).symm))

/-- **The identification on PoolFromCourse's own course function.** For every start `c` and step `t`,
the window course `paced (join fA fB) (windowRead hA hL N K) reads c t` with the step count `t`,
regrouped, is the configuration `t` steps along `pair (windowAfter …) (windowLeft fB)` from `c` at step
count `0` regrouped: `window_is_pair` composed with `ClosedCapture.orbit_paced`. -/
theorem window_paced (fA : A → R → A) (fB : A × Nat → R → Nat) (hA : A → R → R)
    (hL : A × Nat → R → R) (N K : Nat) (reads : Nat → Bool) (c : (A × Nat) × R) (t : Nat) :
    (((paced (join fA fB) (windowRead hA hL N K) reads c t).1.1,
        (paced (join fA fB) (windowRead hA hL N K) reads c t).2, t),
      (paced (join fA fB) (windowRead hA hL N K) reads c t).1.2) =
      Law.orbit (pair (windowAfter fA hA hL N K reads) (windowLeft fB)) ((c.1.1, c.2, 0), c.1.2) t :=
  (congrArg windowRegroup
      (ClosedCapture.orbit_paced (join fA fB) (windowRead hA hL N K) reads c t)).symm.trans
    (window_is_pair fA fB hA hL N K reads (c.1, c.2, 0) t)

/-- The way after a step of a window that reads at every step and sets the share as well as the rule:
at a level `x` in `[N, K)` the share becomes `sA (w.1, x) w.2.1` and the rule `hL (w.1, x) w.2.1`;
elsewhere the way after the step is `windowAlone fA hA (fun _ => true) w`, the share stepping by `fA`
and the rule read off the share by `hA`. The step count goes up by one either way. Beside `windowAfter`,
whose share steps by `fA` at every level. -/
def windowAfterShare (fA : A → R → A) (hA : A → R → R) (sA : A × Nat → R → A)
    (hL : A × Nat → R → R) (N K : Nat) (w : A × R × Nat) (x : Nat) : A × R × Nat :=
  if N ≤ x ∧ x < K then (sA (w.1, x) w.2.1, hL (w.1, x) w.2.1, w.2.2 + 1)
  else windowAlone fA hA (fun _ => true) w

/-- **Outside the window that sets the share, the way after a step is the lock's step as it was.** At
every level not in `[N, K)`, `windowAfterShare` is `windowAlone fA hA (fun _ => true)`. -/
theorem window_share_alone_outside (fA : A → R → A) (hA : A → R → R) (sA : A × Nat → R → A)
    (hL : A × Nat → R → R) (N K : Nat) :
    AloneOutside (fun x => N ≤ x ∧ x < K) (windowAlone fA hA (fun _ => true))
      (windowAfterShare fA hA sA hL N K) :=
  fun _ _ outside => if_neg outside

/-- **The window that reads at every step is the window that sets the share, with the share set by
`fA`.** For every way `w` and level `x`, `windowAfter fA hA hL N K (fun _ => true) w x` is
`windowAfterShare fA hA (fun p g => fA p.1 g) hL N K w x`: in `[N, K)` both take the share by `fA` and
the rule by `hL`, and elsewhere both are `windowAlone fA hA (fun _ => true) w`. Pointwise, by the two
sides of `windowRead`'s condition; that the two nets or courses are one is not stated. -/
theorem windowAfter_every_is_share (fA : A → R → A) (hA : A → R → R) (hL : A × Nat → R → R)
    (N K : Nat) (w : A × R × Nat) (x : Nat) :
    windowAfter fA hA hL N K (fun _ => true) w x =
      windowAfterShare fA hA (fun p g => fA p.1 g) hL N K w x :=
  if read : N ≤ x ∧ x < K then
    (congrArg (fun g => (fA w.1 w.2.1, g, w.2.2 + 1))
      (if_pos read : windowRead hA hL N K (w.1, x) w.2.1 = hL (w.1, x) w.2.1)).trans
      (if_pos read : windowAfterShare fA hA (fun p g => fA p.1 g) hL N K w x =
        (fA w.1 w.2.1, hL (w.1, x) w.2.1, w.2.2 + 1)).symm
  else
    (congrArg (fun g => (fA w.1 w.2.1, g, w.2.2 + 1))
      (if_neg read : windowRead hA hL N K (w.1, x) w.2.1 = hA w.1 w.2.1)).trans
      (if_neg read : windowAfterShare fA hA (fun p g => fA p.1 g) hL N K w x =
        windowAlone fA hA (fun _ => true) w).symm

/-- At a level in `[N, K)`, where the window sets the share to a `Low` one and the rule to a `kept` one
(`sets`), the way after a step of `windowAfterShare` has a `Low` share and a `kept` rule. Needed by
`locked_turns_in_time_share_iff` and `share_corrected_stays`. -/
private theorem share_turns {Low : A → Prop} {kept : R → Prop} (fA : A → R → A) (hA : A → R → R)
    (sA : A × Nat → R → A) (hL : A × Nat → R → R) (N K : Nat)
    (sets : ∀ (p : A × Nat) (g : R), N ≤ p.2 → p.2 < K → Low (sA p g) ∧ kept (hL p g))
    (v : A × R × Nat) (z : Nat) (read : N ≤ z ∧ z < K) :
    Low (windowAfterShare fA hA sA hL N K v z).1 ∧ kept (windowAfterShare fA hA sA hL N K v z).2.1 :=
  Eq.subst (motive := fun u : A × R × Nat => Low u.1 ∧ kept u.2.1)
    (if_pos read : (if N ≤ z ∧ z < K then (sA (v.1, z) v.2.1, hL (v.1, z) v.2.1, v.2.2 + 1)
      else windowAlone fA hA (fun _ => true) v) = (sA (v.1, z) v.2.1, hL (v.1, z) v.2.1, v.2.2 + 1)).symm
    (sets (v.1, z) v.2.1 read.1 read.2)

/-- From a way with a `Low` share and a `kept` rule, the way after a step of `windowAfterShare` has a
`Low` share and a `kept` rule, at every level: in `[N, K)` by `sets`; elsewhere the share steps by `fA`,
which keeps a `Low` share `Low` under a `kept` rule (`lowStays`), and the rule is read off the `Low`
share by `hA`, which gives a `kept` rule there (`lowRule`). Needed by `locked_turns_in_time_share_iff`
and `share_corrected_stays`. -/
private theorem share_kept {Low : A → Prop} {kept : R → Prop} (fA : A → R → A) (hA : A → R → R)
    (sA : A × Nat → R → A) (hL : A × Nat → R → R) (N K : Nat)
    (sets : ∀ (p : A × Nat) (g : R), N ≤ p.2 → p.2 < K → Low (sA p g) ∧ kept (hL p g))
    (lowRule : ∀ a g, Low a → kept (hA a g)) (lowStays : ∀ a g, Low a → kept g → Low (fA a g))
    (v : A × R × Nat) (z : Nat) (kind : Low v.1 ∧ kept v.2.1) :
    Low (windowAfterShare fA hA sA hL N K v z).1 ∧ kept (windowAfterShare fA hA sA hL N K v z).2.1 :=
  if read : N ≤ z ∧ z < K then share_turns fA hA sA hL N K sets v z read
  else Eq.subst (motive := fun u : A × R × Nat => Low u.1 ∧ kept u.2.1)
    (if_neg read : (if N ≤ z ∧ z < K then (sA (v.1, z) v.2.1, hL (v.1, z) v.2.1, v.2.2 + 1)
      else windowAlone fA hA (fun _ => true) v) = windowAlone fA hA (fun _ => true) v).symm
    (⟨lowStays v.1 v.2.1 kind.1 kind.2, lowRule v.1 v.2.1 kind.1⟩ :
      Low (fA v.1 v.2.1) ∧ kept (hA v.1 v.2.1))

/-- **A correction that sets the share as well as the rule: a `Locked` way from a level below
`H₁ + y₁` never ends exactly where its first step at a level the window reads leaves the level at or
above `H₂ + y₂`.** It is `turns_in_time_iff` at the kept kind `Low ∧ kept`: the levels in `[N, K)`
marked, the lock's step as it was reading at every step (`windowAlone fA hA (fun _ => true)`) as
`alone`, the way after a step `windowAfterShare fA hA sA hL N K` (`window_share_alone_outside`), and the
kept kind the ways whose share is `Low` and whose rule is `kept`. That theorem's `turns` and `kept` are
met here from three given premises, with none on where the window lies: the window sets a `Low` share
and a `kept` rule (`sets`); off a `Low` share the rule read is `kept` (`lowRule`); under a `kept` rule a
`Low` share steps to a `Low` share (`lowStays`). So the correction reaches the share because the
window's reading sets it (`sets`, given), not because the share falls under the corrected rule. Its
`uses₁` is met from the lock's premises, as in `locked_turns_in_time_on_window_iff`: under `Raises`,
`ReadsShare` and favouring kept upward (`raises`, `monotone`, `upper`), from a `Locked` start (`locked`)
the share and the rule along the lock's own course are never below the start's
(`locked_alone_not_below`), so with `draws` every way on it uses at least `H₁`. The other premises are
`turns_in_time_iff`'s: the use `H₂` of a way with a `Low` share and a `kept` rule (`uses`); the regime
premises (`nothing`, `short`, `meets`, `keeps`); the need, positive (`needs`) and at most `H₂ + y₂`
(`within`); giving short of `H₁` below `y₁` (`short₁`); and the start at most `hi` (`high`). The
overdraw of the course as it was stays given, as in the laws before: the floor `H₁` on the use where the
share and the rule are not below the start's (`draws`) and the start below `H₁ + y₁` (`below`). The
right side is on the lock's own course, the orbit of `asItWas (windowAlone fA hA (fun _ => true))` from
`(w, x)`; from step `T + 1` on, for its `T`, the pair's course has a `Low` share and a `kept` rule
(`share_corrected_on_course`). The level's step is the regime's, `RegimeMargin.step giving (use w)`.
Only the "if" side has a worked case (`Three.share_read_goes_on`; on the same band with the share left
by `fA`, `Three.read_at_eight_ends` ends). -/
theorem locked_turns_in_time_share_iff {P : Ideals.Preorder A} {M : Ideals.Preorder R}
    {favours : R → Prop} {fA : A → R → A} {hA : A → R → R} (sA : A × Nat → R → A)
    (hL : A × Nat → R → R) (N K : Nat)
    (raises : Raises P favours fA) (monotone : ReadsShare P M hA)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g')
    {Low : A → Prop} {kept : R → Prop}
    (sets : ∀ (p : A × Nat) (g : R), N ≤ p.2 → p.2 < K → Low (sA p g) ∧ kept (hL p g))
    (lowRule : ∀ a g, Low a → kept (hA a g)) (lowStays : ∀ a g, Low a → kept g → Low (fA a g))
    {giving : Nat → Nat} {use : A × R × Nat → Nat} {H₁ y₁ H₂ y₂ hi need : Nat}
    (uses : ∀ v : A × R × Nat, Low v.1 → kept v.2.1 → use v = H₂)
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H₂ y₂)
    (meets : RegimeMargin.Meets giving H₂ y₂ hi) (keeps : RegimeMargin.Keeps giving H₂ hi)
    (needs : 0 < need) (within : need ≤ H₂ + y₂)
    (short₁ : RegimeMargin.Short giving H₁ y₁)
    {w : A × R × Nat} {x : Nat} (locked : Locked M favours hA (w.1, w.2.1))
    (draws : ∀ v : A × R × Nat, P.le w.1 v.1 → M.le w.2.1 v.2.1 → H₁ ≤ use v)
    (below : x < H₁ + y₁) (high : x ≤ hi) :
    «不穷» (net need (windowAfterShare fA hA sA hL N K)
        (fun w x => RegimeMargin.step giving (use w) x)) «一» (w, x) ↔
      ∃ T, (∀ j, j < T →
          need ≤ (Law.orbit (asItWas (windowAlone fA hA (fun _ => true))
            (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2 ∧
          ¬ (N ≤ (Law.orbit (asItWas (windowAlone fA hA (fun _ => true))
              (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2 ∧
            (Law.orbit (asItWas (windowAlone fA hA (fun _ => true))
              (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2 < K)) ∧
        need ≤ (Law.orbit (asItWas (windowAlone fA hA (fun _ => true))
          (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).2 ∧
        (N ≤ (Law.orbit (asItWas (windowAlone fA hA (fun _ => true))
            (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).2 ∧
          (Law.orbit (asItWas (windowAlone fA hA (fun _ => true))
            (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).2 < K) ∧
        H₂ + y₂ ≤ (Law.orbit (asItWas (windowAlone fA hA (fun _ => true))
          (fun w x => RegimeMargin.step giving (use w) x)) (w, x) (T + 1)).2 :=
  have held := locked_alone_not_below raises monotone upper (reads := fun _ => true) locked
  turns_in_time_iff (marked := fun z => N ≤ z ∧ z < K) (alone := windowAlone fA hA (fun _ => true))
    (after := windowAfterShare fA hA sA hL N K) (Kept := fun v => Low v.1 ∧ kept v.2.1)
    (window_share_alone_outside fA hA sA hL N K)
    (share_turns fA hA sA hL N K sets)
    (share_kept fA hA sA hL N K sets lowRule lowStays)
    (fun v kind => uses v kind.1 kind.2) nothing short meets keeps needs within short₁
    (fun j => draws _ (held j).1 (held j).2) below high

/-- **After a step at a level the window reads, the share is `Low` and the rule `kept` at every later
step.** Along the
pair's course with the way after a step `windowAfterShare fA hA sA hL N K` and any level's step `left`,
from any start `s`: where the level at step `T` of that course lies in `[N, K)` (`read`), for every `k`
the way at step `T + 1 + k` has a `Low` share and a `kept` rule. Under `sets`, `lowRule` and `lowStays`
(as in `locked_turns_in_time_share_iff`), by induction: the step at `T` sets them (`sets`), and every
later step keeps them, in the window by `sets` and outside it by `lowStays` and `lowRule`. It says
nothing of the level, the use, the need or whether the net's line goes on; the pair's course is total,
and the kind holds on it after the line has ended too. -/
theorem share_corrected_stays {Low : A → Prop} {kept : R → Prop} (fA : A → R → A) (hA : A → R → R)
    (sA : A × Nat → R → A) (hL : A × Nat → R → R) (N K : Nat)
    (sets : ∀ (p : A × Nat) (g : R), N ≤ p.2 → p.2 < K → Low (sA p g) ∧ kept (hL p g))
    (lowRule : ∀ a g, Low a → kept (hA a g)) (lowStays : ∀ a g, Low a → kept g → Low (fA a g))
    (left : A × R × Nat → Nat → Nat) (s : (A × R × Nat) × Nat) {T : Nat}
    (read : N ≤ (Law.orbit (pair (windowAfterShare fA hA sA hL N K) left) s T).2 ∧
      (Law.orbit (pair (windowAfterShare fA hA sA hL N K) left) s T).2 < K) :
    ∀ k, Low (Law.orbit (pair (windowAfterShare fA hA sA hL N K) left) s (T + 1 + k)).1.1 ∧
      kept (Law.orbit (pair (windowAfterShare fA hA sA hL N K) left) s (T + 1 + k)).1.2.1
  | 0 => share_turns fA hA sA hL N K sets
      (Law.orbit (pair (windowAfterShare fA hA sA hL N K) left) s T).1
      (Law.orbit (pair (windowAfterShare fA hA sA hL N K) left) s T).2 read
  | k + 1 => share_kept fA hA sA hL N K sets lowRule lowStays
      (Law.orbit (pair (windowAfterShare fA hA sA hL N K) left) s (T + 1 + k)).1
      (Law.orbit (pair (windowAfterShare fA hA sA hL N K) left) s (T + 1 + k)).2
      (share_corrected_stays fA hA sA hL N K sets lowRule lowStays left s read k)

/-- **From the step after the first step the window reads on the course as it was, the pair's course
has a `Low` share and a `kept` rule.** Under `sets`, `lowRule` and `lowStays`, for any level's step `left` and any
start `s`: where at no step before `T` the level of the course as it was (the orbit of
`asItWas (windowAlone fA hA (fun _ => true)) left` from `s`) lies in `[N, K)` (`before`) and at step `T`
it does (`read`), for every `k` the way at step `T + 1 + k` of the pair's course
(`pair (windowAfterShare fA hA sA hL N K) left` from `s`) has a `Low` share and a `kept` rule. Up to `T`
the pair's course is the course as it was (`agrees_until_marked` with `window_share_alone_outside`), so
its level at `T` is in `[N, K)`; then `share_corrected_stays`. Where the right side of
`locked_turns_in_time_share_iff` holds at `T`, `before` and `read` are two of its parts; no other
premise of that law is asked. -/
theorem share_corrected_on_course {Low : A → Prop} {kept : R → Prop} (fA : A → R → A)
    (hA : A → R → R) (sA : A × Nat → R → A) (hL : A × Nat → R → R) (N K : Nat)
    (sets : ∀ (p : A × Nat) (g : R), N ≤ p.2 → p.2 < K → Low (sA p g) ∧ kept (hL p g))
    (lowRule : ∀ a g, Low a → kept (hA a g)) (lowStays : ∀ a g, Low a → kept g → Low (fA a g))
    (left : A × R × Nat → Nat → Nat) (s : (A × R × Nat) × Nat) {T : Nat}
    (before : ∀ j, j < T →
      ¬ (N ≤ (Law.orbit (asItWas (windowAlone fA hA (fun _ => true)) left) s j).2 ∧
        (Law.orbit (asItWas (windowAlone fA hA (fun _ => true)) left) s j).2 < K))
    (read : N ≤ (Law.orbit (asItWas (windowAlone fA hA (fun _ => true)) left) s T).2 ∧
      (Law.orbit (asItWas (windowAlone fA hA (fun _ => true)) left) s T).2 < K) :
    ∀ k, Low (Law.orbit (pair (windowAfterShare fA hA sA hL N K) left) s (T + 1 + k)).1.1 ∧
      kept (Law.orbit (pair (windowAfterShare fA hA sA hL N K) left) s (T + 1 + k)).1.2.1 :=
  share_corrected_stays fA hA sA hL N K sets lowRule lowStays left s
    (Eq.subst (motive := fun z : (A × R × Nat) × Nat => N ≤ z.2 ∧ z.2 < K)
      (agrees_until_marked (window_share_alone_outside fA hA sA hL N K) left s T before).symm read)

end Lock

/-! ## 7. The point of no return, a level and a step

`RegimeMargin` calls the level `H + y` the point of no return under a standing use `H`
(`RegimeMargin.ends_iff_below`); `ReadOffInTime` calls the first step at which a course is not
recoverable its point of no return (`NoReturnAt`), with the feasible courses and what is asked of a
course given. Here the two are joined for any level course `X` that never rises and starts at most
`hi`. The feasible courses are `X` turned to the standing use `H` at some step, the start included
(`turned`, `Turned`); what is asked of a course is that the need be met at every step (`MeetsNeed`);
courses are over one condition (`Unit`). Under nothing given from nothing and `RegimeMargin`'s
`Short`, `Meets` and `Keeps` at `H` with `y` and `hi`, and a positive need at most `H + y`: the
course turned at `T` meets the need at every step exactly where `H + y ≤ X T` (`turned_meets_iff`);
`X` is recoverable at `N` exactly where `H + y ≤ X N` (`recoverable_iff_above`); and its point of no
return, a step, is the first step at which its level is below `H + y`
(`noReturnAt_iff_first_below`). On the pair, under `turns`, `kept` and `uses`, the level course from
`(w, x)` is the course as it was turned at `T + 1`, for `T` its first marked step (`course_turned`,
with no premise on the need); under `turns_in_time_iff`'s premises on the regime and on the course
as it was (none on the marks or the kept kind), the course as it was has a point of no return within
`x` steps (`noReturn_exists`); and under all of `turns_in_time_iff`'s premises the line never ends
exactly where, at the first marked step `T`, the need met there and before, `T + 1` is before the
point of no return of the course as it was (`turns_in_time_iff_before`, through `course_turned`,
`turned_meets_iff` and `recoverable_iff_above`). The three laws of a level course are also stated
under less, a level once below `H + y` staying below it and a bound on the level at the step of the
turn (the laws ending `_of_stays_below`); those above are their cases or follow from them. The
feasible courses are turns to one standing use; other continuations are not considered, and the
marks stay given. -/

section PointOfNoReturn

/-- **The course `X` turned at step `T` to the standing use `H`**: `X t` at every step `t` up to `T`,
and from there the level's course under `RegimeMargin.step giving H` from `X T`. -/
def turned (X : Nat → Nat) (giving : Nat → Nat) (H T t : Nat) : Nat :=
  if t ≤ T then X t else Law.orbit (RegimeMargin.step giving H) (X T) (t - T)

/-- **The feasible courses**: the courses over one condition that are `X` turned to `H` at some step
`T`, the start included. -/
def Turned (X : Nat → Nat) (giving : Nat → Nat) (H : Nat) (l : Nat → Unit → Nat) : Prop :=
  ∃ T, ∀ t c, l t c = turned X giving H T t

/-- **What is asked of a course**: the need met at every step. -/
def MeetsNeed (need : Nat) (l : Nat → Unit → Nat) : Prop := ∀ t c, need ≤ l t c

/-- Up to step `T` the course turned at `T` is `X`. No premise. -/
private theorem turned_before {X : Nat → Nat} {giving : Nat → Nat} {H T t : Nat} (le : t ≤ T) :
    turned X giving H T t = X t :=
  if_pos le

/-- `k` steps after `T` the course turned at `T` is the level's course under `H` from `X T`, `k` steps
on. No premise. -/
private theorem turned_after (X : Nat → Nat) (giving : Nat → Nat) (H T : Nat) :
    ∀ k, turned X giving H T (T + k) = Law.orbit (RegimeMargin.step giving H) (X T) k
  | 0 => if_pos (Nat.le_refl T)
  | k + 1 =>
    (if_neg (Nat.not_le_of_gt (Nat.lt_succ_of_le (Nat.le_add_right T k)))).trans
      (congrArg (Law.orbit (RegimeMargin.step giving H) (X T))
        (Naturals.add_sub_cancel_left T (k + 1)))

/-- A course that never rises at any step (`fall`) is, `k` steps after `j`, at most where it was at
`j`. -/
private theorem fall_by {X : Nat → Nat} (fall : ∀ t, X (t + 1) ≤ X t) (j : Nat) :
    ∀ k, X (j + k) ≤ X j
  | 0 => Nat.le_refl _
  | k + 1 => Nat.le_trans (fall (j + k)) (fall_by fall j k)

/-- A course that never rises at any step (`fall`) is not higher at a later step: `X T ≤ X j` for
`j ≤ T`. -/
private theorem later_le {X : Nat → Nat} (fall : ∀ t, X (t + 1) ≤ X t) {j T : Nat} (le : j ≤ T) :
    X T ≤ X j :=
  match le_dest le with
  | ⟨k, e⟩ => Eq.subst (motive := fun i => X i ≤ X j) e.symm (fall_by fall j k)

/-- **Where a level once below `c` stays below it, a level at or above `c` at a step is at or above
it at every earlier step.** With a level of `X` below `c` staying so at the next step (`below`):
`j ≤ T` and `c ≤ X T` give `c ≤ X j`; `below` read backward, the order on `Nat` being decided.
`below` asks less than a course that never rises (`fall`): `fall` gives it at every `c`, by
`Nat.lt_of_le_of_lt` (so in each theorem of this section proved as a case), and a course that rises
can meet it (by hand, not a Lean statement here: the levels 3, 3, 4, 4, 0, 0, … at `c = 2`). -/
theorem above_before_of_stays_below {X : Nat → Nat} {c : Nat}
    (below : ∀ t, X t < c → X (t + 1) < c) {j : Nat} : ∀ {T : Nat}, j ≤ T → c ≤ X T → c ≤ X j
  | _, .refl, above => above
  | _, @Nat.le.step _ m le, above => above_before_of_stays_below below le
      ((Nat.lt_or_ge (X m) c).elim (fun lt => absurd above (Nat.not_le_of_gt (below m lt))) id)

/-- **A level whose course under `H` meets a positive need at every step is at or above `H + y`.**
With nothing given from nothing and giving short of `H` below `y`; by `RegimeMargin.ends_below`. -/
private theorem above_of_run_meets {giving : Nat → Nat} {H y need z : Nat}
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    (needs : 0 < need) (meet : ∀ k, need ≤ Law.orbit (RegimeMargin.step giving H) z k) :
    H + y ≤ z :=
  (Nat.lt_or_ge z (H + y)).elim
    (fun lt => absurd (Nat.le_trans (meet z) (Nat.le_of_eq (RegimeMargin.ends_below short nothing lt)))
      (Nat.not_le_of_gt needs))
    id

/-- **Where the course turned at `T` meets a positive need at every step, it is at or above `H + y` at
every step from `T`.** With nothing given from nothing and giving short of `H` below `y`. -/
private theorem above_after {X : Nat → Nat} {giving : Nat → Nat} {H y need T : Nat}
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    (needs : 0 < need) (meet : ∀ t, need ≤ turned X giving H T t) {M : Nat} (le : T ≤ M) :
    H + y ≤ turned X giving H T M :=
  match le_dest le with
  | ⟨k, e⟩ =>
    Eq.subst (motive := fun i => H + y ≤ turned X giving H T i) e.symm
      (Eq.subst (motive := fun z => H + y ≤ z) (turned_after X giving H T k).symm
        (above_of_run_meets nothing short needs fun j =>
          Eq.subst (motive := fun z => need ≤ z)
            ((turned_after X giving H T (k + j)).trans
              (Law.orbit_add (RegimeMargin.step giving H) (X T) k j))
            (meet (T + (k + j)))))

/-- **The course turned at `T` meets the need at every step where `H + y ≤ X T`, for a course whose
level once below `H + y` stays below it** (R1, if, under less). With every level of `X` below
`H + y` below it at the next step (`below`), the level at the step of the turn at most `hi`
(`high : X T ≤ hi`), giving meeting `H` from `y` up to `hi` (`meets`), the step under `H` keeping
the level within `hi` (`keeps`), and the need at most `H + y` (`within`). Up to the turn the need is
met by `below` read backward (`above_before_of_stays_below`); after it by `RegimeMargin.holds`,
which asks the bound of the level the turn starts from, `X T`, and of no other. `below` asks less
than a course that never rises (told at `above_before_of_stays_below`), and `high` less than such a
course starting at most `hi`; `turned_meets_of_above` is the case. The bound cannot be dropped (by
hand, not a Lean statement: `H = 5`, `y = 1`, `hi = 6`, giving five at one and nothing elsewhere, a
need of one, the levels 7, 0, 0, …; every other premise holds at `T = 0`, and the turn at step 0
runs 7, 2, 0, below the need). -/
theorem turned_meets_of_above_of_stays_below {X : Nat → Nat} {giving : Nat → Nat}
    {H y hi need T : Nat}
    (below : ∀ t, X t < H + y → X (t + 1) < H + y) (high : X T ≤ hi)
    (meets : RegimeMargin.Meets giving H y hi) (keeps : RegimeMargin.Keeps giving H hi)
    (within : need ≤ H + y) (low : H + y ≤ X T) : ∀ t, need ≤ turned X giving H T t :=
  fun t => (Nat.lt_or_ge T t).elim
    (fun lt => match le_dest (Nat.le_of_lt lt) with
      | ⟨k, e⟩ => Eq.subst (motive := fun i => need ≤ turned X giving H T i) e.symm
          (Eq.subst (motive := fun z => need ≤ z) (turned_after X giving H T k).symm
            (Nat.le_trans within (Nat.le_trans low
              (RegimeMargin.holds meets keeps low high k).1))))
    (fun ge => Eq.subst (motive := fun z => need ≤ z) (turned_before ge).symm
      (Nat.le_trans within (above_before_of_stays_below below ge low)))

/-- **The course turned at `T` meets the need at every step where `H + y ≤ X T`** (R1, if). With `X`
never rising (`fall`) and starting at most `hi` (`top`), giving meeting `H` from `y` up to `hi`
(`meets`), the step under `H` keeping the level within `hi` (`keeps`), and the need at most `H + y`
(`within`); a case of `turned_meets_of_above_of_stays_below`, `fall` giving `below` and, with `top`,
the bound at `T`. -/
theorem turned_meets_of_above {X : Nat → Nat} {giving : Nat → Nat} {H y hi need T : Nat}
    (fall : ∀ t, X (t + 1) ≤ X t) (top : X 0 ≤ hi)
    (meets : RegimeMargin.Meets giving H y hi) (keeps : RegimeMargin.Keeps giving H hi)
    (within : need ≤ H + y) (low : H + y ≤ X T) : ∀ t, need ≤ turned X giving H T t :=
  turned_meets_of_above_of_stays_below (fun t lt => Nat.lt_of_le_of_lt (fall t) lt)
    (Nat.le_trans (later_le fall (Nat.zero_le T)) top) meets keeps within low

/-- **Where the course turned at `T` meets the need at every step, `H + y ≤ X T`** (R1, only if).
With nothing given from nothing, giving short of `H` below `y`, and a positive need; by
`RegimeMargin.ends_below`. Nothing about `X` is used. -/
theorem above_of_turned_meets {X : Nat → Nat} {giving : Nat → Nat} {H y need T : Nat}
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    (needs : 0 < need) (meet : ∀ t, need ≤ turned X giving H T t) : H + y ≤ X T :=
  Eq.subst (motive := fun z => H + y ≤ z) (turned_before (Nat.le_refl T))
    (above_after nothing short needs meet (Nat.le_refl T))

/-- **R1 under less. The course turned at `T` meets the need at every step exactly where
`H + y ≤ X T`, for a course whose level once below `H + y` stays below it.** With `below` and the
level at the step of the turn at most `hi` (`high : X T ≤ hi`) in place of `turned_meets_iff`'s
`fall` and `top`, and its other premises: nothing given from nothing, giving short of `H` below `y`,
meeting it from `y` up to `hi`, the step under `H` keeping the level within `hi`, and a positive
need at most `H + y`. The if direction uses `below`, `high`, `meets`, `keeps` and `within`
(`turned_meets_of_above_of_stays_below`, which tells why the bound is at `T` and that it cannot be
dropped); the only-if direction `nothing`, `short` and `needs` (`above_of_turned_meets`). `below`
asks less than a course that never rises (told at `above_before_of_stays_below`). `turned_meets_iff`
asks more and concludes the same; its proof is not a call of this law. -/
theorem turned_meets_iff_of_stays_below {X : Nat → Nat} {giving : Nat → Nat} {H y hi need T : Nat}
    (below : ∀ t, X t < H + y → X (t + 1) < H + y) (high : X T ≤ hi)
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    (meets : RegimeMargin.Meets giving H y hi) (keeps : RegimeMargin.Keeps giving H hi)
    (needs : 0 < need) (within : need ≤ H + y) :
    (∀ t, need ≤ turned X giving H T t) ↔ H + y ≤ X T :=
  ⟨above_of_turned_meets nothing short needs,
   turned_meets_of_above_of_stays_below below high meets keeps within⟩

/-- **R1. The course turned at `T` meets the need at every step exactly where `H + y ≤ X T`.** With
`X` never rising (`fall`) and starting at most `hi` (`top`), nothing given from nothing, giving short
of `H` below `y`, meeting it from `y` up to `hi`, the step under `H` keeping the level within `hi`,
and a positive need at most `H + y`. The if direction uses `fall`, `top`, `meets`, `keeps` and
`within` (`turned_meets_of_above`); the only-if direction `nothing`, `short` and `needs`
(`above_of_turned_meets`). Its if direction follows from `turned_meets_of_above_of_stays_below`
through `turned_meets_of_above`. -/
theorem turned_meets_iff {X : Nat → Nat} {giving : Nat → Nat} {H y hi need T : Nat}
    (fall : ∀ t, X (t + 1) ≤ X t) (top : X 0 ≤ hi)
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    (meets : RegimeMargin.Meets giving H y hi) (keeps : RegimeMargin.Keeps giving H hi)
    (needs : 0 < need) (within : need ≤ H + y) :
    (∀ t, need ≤ turned X giving H T t) ↔ H + y ≤ X T :=
  ⟨above_of_turned_meets nothing short needs, turned_meets_of_above fall top meets keeps within⟩

/-- **Where `H + y ≤ X N`, `X` is recoverable at `N`, for a course whose level once below `H + y`
stays below it** (R2, if, under less): the course turned at `N` agrees with `X` up to `N` and meets
the need at every step. With `below`, the level at the step of the turn at most `hi`
(`high : X N ≤ hi`), giving meeting `H` from `y` up to `hi` (`meets`), the step under `H` keeping
the level within `hi` (`keeps`), and the need at most `H + y` (`within`); by
`turned_meets_of_above_of_stays_below` at `T := N`, which tells why the bound is at the step of the
turn and that it cannot be dropped. `below` asks less than a course that never rises (told at
`above_before_of_stays_below`). `recoverable_of_above` asks more and concludes the same; its proof
is not a call of this law. -/
theorem recoverable_of_above_of_stays_below {X : Nat → Nat} {giving : Nat → Nat}
    {H y hi need N : Nat}
    (below : ∀ t, X t < H + y → X (t + 1) < H + y) (high : X N ≤ hi)
    (meets : RegimeMargin.Meets giving H y hi) (keeps : RegimeMargin.Keeps giving H hi)
    (within : need ≤ H + y) (low : H + y ≤ X N) :
    Recoverable (Turned X giving H) (MeetsNeed need) (fun t _ => X t) N :=
  ⟨fun t _ => turned X giving H N t, ⟨N, fun _ _ => rfl⟩, fun _ le _ => turned_before le,
   fun t _ => turned_meets_of_above_of_stays_below below high meets keeps within low t⟩

/-- **Where `H + y ≤ X N`, `X` is recoverable at `N`** (R2, if): the course turned at `N` agrees with
`X` up to `N` and meets the need at every step. With `X` never rising (`fall`) and starting at most
`hi` (`top`), giving meeting `H` from `y` up to `hi` (`meets`), the step under `H` keeping the level
within `hi` (`keeps`), and the need at most `H + y` (`within`). It follows from
`turned_meets_of_above_of_stays_below` through `turned_meets_of_above`. -/
theorem recoverable_of_above {X : Nat → Nat} {giving : Nat → Nat} {H y hi need N : Nat}
    (fall : ∀ t, X (t + 1) ≤ X t) (top : X 0 ≤ hi)
    (meets : RegimeMargin.Meets giving H y hi) (keeps : RegimeMargin.Keeps giving H hi)
    (within : need ≤ H + y) (low : H + y ≤ X N) :
    Recoverable (Turned X giving H) (MeetsNeed need) (fun t _ => X t) N :=
  ⟨fun t _ => turned X giving H N t, ⟨N, fun _ _ => rfl⟩, fun _ le _ => turned_before le,
   fun t _ => turned_meets_of_above fall top meets keeps within low t⟩

/-- **Where `X` is recoverable at `N`, `H + y ≤ X N`, for a course whose level once below `H + y`
stays below it** (R2, only if, under less). With `below`, nothing given from nothing, giving short
of `H` below `y`, and a positive need; no bound on the level is asked. By `RegimeMargin.ends_below`.
A turn at `T` at or before `N` that meets the need is at or above `H + y` from `T` on, `X N` among
them, and there nothing about `X` is used; a turn at `T` after `N` has `H + y ≤ X T`, so
`H + y ≤ X N` by `below` read backward (`above_before_of_stays_below`). `below` asks less than a
course that never rises (told at `above_before_of_stays_below`); `above_of_recoverable` is the case.
-/
theorem above_of_recoverable_of_stays_below {X : Nat → Nat} {giving : Nat → Nat} {H y need N : Nat}
    (below : ∀ t, X t < H + y → X (t + 1) < H + y)
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    (needs : 0 < need) (rec : Recoverable (Turned X giving H) (MeetsNeed need) (fun t _ => X t) N) :
    H + y ≤ X N :=
  match rec with
  | ⟨_, ⟨T, eq⟩, agree, meet⟩ =>
    have meetT : ∀ t, need ≤ turned X giving H T t := fun t =>
      Eq.subst (motive := fun z => need ≤ z) (eq t ()) (meet t ())
    (Nat.lt_or_ge N T).elim
      (fun lt => above_before_of_stays_below below (Nat.le_of_lt lt)
        (above_of_turned_meets nothing short needs meetT))
      (fun ge => Eq.subst (motive := fun z => H + y ≤ z)
        ((eq N ()).symm.trans (agree N (Nat.le_refl N) ()))
        (above_after nothing short needs meetT ge))

/-- **Where `X` is recoverable at `N`, `H + y ≤ X N`** (R2, only if). With `X` never rising (`fall`),
nothing given from nothing, giving short of `H` below `y`, and a positive need; a case of
`above_of_recoverable_of_stays_below`, `fall` giving `below`. -/
theorem above_of_recoverable {X : Nat → Nat} {giving : Nat → Nat} {H y need N : Nat}
    (fall : ∀ t, X (t + 1) ≤ X t)
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    (needs : 0 < need) (rec : Recoverable (Turned X giving H) (MeetsNeed need) (fun t _ => X t) N) :
    H + y ≤ X N :=
  above_of_recoverable_of_stays_below (fun t lt => Nat.lt_of_le_of_lt (fall t) lt) nothing short
    needs rec

/-- **R2 under less. `X` is recoverable at `N` exactly where `H + y ≤ X N`, for a course whose level
once below `H + y` stays below it**, with the turns of `X` to `H` as the feasible courses and the
need met at every step as what is asked. With `below` and the level at `N` at most `hi`
(`high : X N ≤ hi`) in place of `recoverable_iff_above`'s `fall` and `top`, and its other premises:
nothing given from nothing, giving short of `H` below `y`, meeting it from `y` up to `hi`, the step
under `H` keeping the level within `hi`, and a positive need at most `H + y`. The if direction uses
`below`, `high`, `meets`, `keeps` and `within` (`recoverable_of_above_of_stays_below`); the only-if
direction `below`, `nothing`, `short` and `needs` (`above_of_recoverable_of_stays_below`). The bound
is at `N` because the course that recovers there is the turn at `N`, and it cannot be dropped (by
hand, the course told at `turned_meets_of_above_of_stays_below`: its level at step 0 is at or above
`H + y` and it is not recoverable there, the turn at 0 and every later turn coming below the need).
`below` asks less than a course that never rises (told at `above_before_of_stays_below`).
`recoverable_iff_above` asks more and concludes the same; its proof is not a call of this law. -/
theorem recoverable_iff_above_of_stays_below {X : Nat → Nat} {giving : Nat → Nat}
    {H y hi need N : Nat}
    (below : ∀ t, X t < H + y → X (t + 1) < H + y) (high : X N ≤ hi)
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    (meets : RegimeMargin.Meets giving H y hi) (keeps : RegimeMargin.Keeps giving H hi)
    (needs : 0 < need) (within : need ≤ H + y) :
    Recoverable (Turned X giving H) (MeetsNeed need) (fun t _ => X t) N ↔ H + y ≤ X N :=
  ⟨above_of_recoverable_of_stays_below below nothing short needs,
   recoverable_of_above_of_stays_below below high meets keeps within⟩

/-- **R2. `X` is recoverable at `N` exactly where `H + y ≤ X N`**: `RegimeMargin`'s point of no
return, a level, read on `ReadOffInTime`'s `Recoverable` with the turns of `X` to `H` as the feasible
courses and the need met at every step as what is asked. With `X` never rising (`fall`) and starting at
most `hi` (`top`), nothing given from nothing, giving short of `H` below `y`, meeting it from `y` up to
`hi`, the step under `H` keeping the level within `hi`, and a positive need at most `H + y`. The if
direction uses `fall`, `top`, `meets`, `keeps` and `within` (`recoverable_of_above`); the only-if
direction `fall`, `nothing`, `short` and `needs` (`above_of_recoverable`). Through these two it
follows from `turned_meets_of_above_of_stays_below` and `above_of_recoverable_of_stays_below`. -/
theorem recoverable_iff_above {X : Nat → Nat} {giving : Nat → Nat} {H y hi need N : Nat}
    (fall : ∀ t, X (t + 1) ≤ X t) (top : X 0 ≤ hi)
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    (meets : RegimeMargin.Meets giving H y hi) (keeps : RegimeMargin.Keeps giving H hi)
    (needs : 0 < need) (within : need ≤ H + y) :
    Recoverable (Turned X giving H) (MeetsNeed need) (fun t _ => X t) N ↔ H + y ≤ X N :=
  ⟨above_of_recoverable fall nothing short needs, recoverable_of_above fall top meets keeps within⟩

/-- **R3 under less. The point of no return of `X`, a step, is the first step at which its level is
below `H + y`, for a course whose level once below `H + y` stays below it.** With `below` and the
level at most `hi` at every step up to `N` (`high : ∀ n, n ≤ N → X n ≤ hi`) in place of
`noReturnAt_iff_first_below`'s `fall` and `top`, and its other premises: nothing given from nothing,
giving short of `H` below `y`, meeting it from `y` up to `hi`, the step under `H` keeping the level
within `hi`, and a positive need at most `H + y`. By `recoverable_iff_above_of_stays_below` at `N`
and at each step before it, each with the bound at its own step, the step of the turn that recovers
there. With no bound the law fails (by hand, the course told at
`turned_meets_of_above_of_stays_below`: its point of no return is step 0, where its level is not
below `H + y`). `below` asks less than a course that never rises (told at
`above_before_of_stays_below`); `noReturnAt_iff_first_below` is the case. -/
theorem noReturnAt_iff_first_below_of_stays_below {X : Nat → Nat} {giving : Nat → Nat}
    {H y hi need N : Nat}
    (below : ∀ t, X t < H + y → X (t + 1) < H + y) (high : ∀ n, n ≤ N → X n ≤ hi)
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    (meets : RegimeMargin.Meets giving H y hi) (keeps : RegimeMargin.Keeps giving H hi)
    (needs : 0 < need) (within : need ≤ H + y) :
    NoReturnAt (Turned X giving H) (MeetsNeed need) (fun t _ => X t) N ↔
      X N < H + y ∧ ∀ n, n < N → H + y ≤ X n :=
  have iff := fun (n : Nat) (le : n ≤ N) => recoverable_iff_above_of_stays_below (X := X) (N := n)
    below (high n le) nothing short meets keeps needs within
  ⟨fun ⟨fails, before⟩ =>
    ⟨(Nat.lt_or_ge (X N) (H + y)).elim id
      (fun ge => absurd ((iff N (Nat.le_refl N)).mpr ge) fails),
     fun n lt => (iff n (Nat.le_of_lt lt)).mp (before n lt)⟩,
   fun ⟨under, before⟩ =>
    ⟨fun rec => Nat.not_le_of_gt under ((iff N (Nat.le_refl N)).mp rec),
     fun n lt => (iff n (Nat.le_of_lt lt)).mpr (before n lt)⟩⟩

/-- **R3. The point of no return of `X`, a step, is the first step at which its level is below
`H + y`, the point of no return of the regime it can turn to.** Under `recoverable_iff_above`'s
premises: `X` never rising and starting at most `hi`, nothing given from nothing, giving short of `H`
below `y`, meeting it from `y` up to `hi`, the step under `H` keeping the level within `hi`, and a
positive need at most `H + y`. A case of `noReturnAt_iff_first_below_of_stays_below`, `fall` giving
`below` and, with `top`, the bound at every step. -/
theorem noReturnAt_iff_first_below {X : Nat → Nat} {giving : Nat → Nat} {H y hi need N : Nat}
    (fall : ∀ t, X (t + 1) ≤ X t) (top : X 0 ≤ hi)
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    (meets : RegimeMargin.Meets giving H y hi) (keeps : RegimeMargin.Keeps giving H hi)
    (needs : 0 < need) (within : need ≤ H + y) :
    NoReturnAt (Turned X giving H) (MeetsNeed need) (fun t _ => X t) N ↔
      X N < H + y ∧ ∀ n, n < N → H + y ≤ X n :=
  noReturnAt_iff_first_below_of_stays_below (fun t lt => Nat.lt_of_le_of_lt (fall t) lt)
    (fun n _ => Nat.le_trans (later_le fall (Nat.zero_le n)) top) nothing short meets keeps needs
    within

/-- Recoverability of `X` is decided at every step, for a course whose level once below `H + y`
stays below it, through `recoverable_iff_above_of_stays_below`'s two directions. With `below` and
the level at most `hi` at every step (`high : ∀ t, X t ≤ hi`) in place of `recoverable_decided`'s
`fall` and `top`, and its other premises: nothing given from nothing, giving short of `H` below `y`,
meeting it from `y` up to `hi`, the step under `H` keeping the level within `hi`, and a positive
need at most `H + y`. The bound is used at a step only where the level there is at or above `H + y`,
as the bound of the turn at that step. -/
private theorem recoverable_decided_of_stays_below {X : Nat → Nat} {giving : Nat → Nat}
    {H y hi need : Nat}
    (below : ∀ t, X t < H + y → X (t + 1) < H + y) (high : ∀ t, X t ≤ hi)
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    (meets : RegimeMargin.Meets giving H y hi) (keeps : RegimeMargin.Keeps giving H hi)
    (needs : 0 < need) (within : need ≤ H + y) :
    ∀ m, Recoverable (Turned X giving H) (MeetsNeed need) (fun t _ => X t) m ∨
      ¬ Recoverable (Turned X giving H) (MeetsNeed need) (fun t _ => X t) m :=
  fun m => (Nat.lt_or_ge (X m) (H + y)).elim
    (fun lt => .inr fun rec =>
      Nat.not_le_of_gt lt (above_of_recoverable_of_stays_below below nothing short needs rec))
    (fun ge => .inl (recoverable_of_above_of_stays_below below (high m) meets keeps within ge))

/-- Recoverability of `X` is decided at every step: a case of `recoverable_decided_of_stays_below`,
`fall` giving `below` and, with `top`, the bound at every step. Under `recoverable_iff_above`'s
premises: `X` never rising (`fall`) and starting at most `hi` (`top`), nothing given from
nothing, giving short of `H` below `y`, meeting it from `y` up to `hi`, the step under `H` keeping the
level within `hi`, and a positive need at most `H + y`. -/
private theorem recoverable_decided {X : Nat → Nat} {giving : Nat → Nat} {H y hi need : Nat}
    (fall : ∀ t, X (t + 1) ≤ X t) (top : X 0 ≤ hi)
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    (meets : RegimeMargin.Meets giving H y hi) (keeps : RegimeMargin.Keeps giving H hi)
    (needs : 0 < need) (within : need ≤ H + y) :
    ∀ m, Recoverable (Turned X giving H) (MeetsNeed need) (fun t _ => X t) m ∨
      ¬ Recoverable (Turned X giving H) (MeetsNeed need) (fun t _ => X t) m :=
  recoverable_decided_of_stays_below (fun t lt => Nat.lt_of_le_of_lt (fall t) lt)
    (fun t => Nat.le_trans (later_le fall (Nat.zero_le t)) top) nothing short meets keeps needs
    within

/-- Where `X` is recoverable at `N`, with the need met at every step as what is asked, `X` meets the
need at every step up to `N`, whatever the feasible courses: the course that recovers agrees with `X`
there and meets the need. No premise. -/
private theorem met_of_recoverable {feasible : (Nat → Unit → Nat) → Prop} {X : Nat → Nat}
    {need N : Nat} (rec : Recoverable feasible (MeetsNeed need) (fun t _ => X t) N) :
    ∀ j, j ≤ N → need ≤ X j :=
  match rec with
  | ⟨_, _, agree, meet⟩ => fun j le =>
    Eq.subst (motive := fun z => need ≤ z) (agree j le ()) (meet j ())

/-- **Where `X` comes below `H + y`, it has a point of no return no later, for a course whose level
once below `H + y` stays below it.** With `below` and the level at most `hi` at every step
(`high : ∀ t, X t ≤ hi`) in place of `noReturnAt_of_below`'s `fall` and `top`, and its other
premises (nothing given from nothing, giving short of `H` below `y`, meeting it from `y` up to `hi`,
the step under `H` keeping the level within `hi`, a positive need at most `H + y`): where
`X n < H + y` (`under`; `noReturnAt_of_below` names that premise `below`) there is a point of no
return `N ≤ n`; by `noReturnAt_of_past`, recoverability decided through
`recoverable_iff_above_of_stays_below`'s two directions. `high`, `meets`, `keeps` and `within` serve
only to decide recoverability at each step, the bound at a step being that of the turn at it; that
`X` is not recoverable at `n` uses `below`, `nothing`, `short` and `needs`. Here it is not said that
the bound cannot be dropped: it enters only the deciding. `below` asks less than a course that never
rises (told at `above_before_of_stays_below`). `noReturnAt_of_below` asks more and concludes the
same; its proof is not a call of this law. -/
theorem noReturnAt_of_below_of_stays_below {X : Nat → Nat} {giving : Nat → Nat} {H y hi need : Nat}
    (below : ∀ t, X t < H + y → X (t + 1) < H + y) (high : ∀ t, X t ≤ hi)
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    (meets : RegimeMargin.Meets giving H y hi) (keeps : RegimeMargin.Keeps giving H hi)
    (needs : 0 < need) (within : need ≤ H + y) {n : Nat} (under : X n < H + y) :
    ∃ N, N ≤ n ∧ NoReturnAt (Turned X giving H) (MeetsNeed need) (fun t _ => X t) N :=
  noReturnAt_of_past
    (recoverable_decided_of_stays_below below high nothing short meets keeps needs within)
    (fun rec => Nat.not_le_of_gt under
      (above_of_recoverable_of_stays_below below nothing short needs rec))

/-- **Where `X` comes below `H + y`, it has a point of no return no later.** Under
`recoverable_iff_above`'s premises (`X` never rising and starting at most `hi`, nothing given from
nothing, giving short of `H` below `y`, meeting it from `y` up to `hi`, the step under `H` keeping the
level within `hi`, a positive need at most `H + y`), where `X n < H + y` there is a point of no return
`N ≤ n`; by `noReturnAt_of_past`, recoverability decided by `recoverable_decided`. `top`,
`meets`, `keeps` and `within` serve only to decide recoverability at each step; that `X` is not
recoverable at `n` uses `fall`, `nothing`, `short` and `needs`. It follows from
`recoverable_decided_of_stays_below` and `above_of_recoverable_of_stays_below` through
`recoverable_decided` and `above_of_recoverable`. -/
theorem noReturnAt_of_below {X : Nat → Nat} {giving : Nat → Nat} {H y hi need : Nat}
    (fall : ∀ t, X (t + 1) ≤ X t) (top : X 0 ≤ hi)
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    (meets : RegimeMargin.Meets giving H y hi) (keeps : RegimeMargin.Keeps giving H hi)
    (needs : 0 < need) (within : need ≤ H + y) {n : Nat} (below : X n < H + y) :
    ∃ N, N ≤ n ∧ NoReturnAt (Turned X giving H) (MeetsNeed need) (fun t _ => X t) N :=
  noReturnAt_of_past (recoverable_decided fall top nothing short meets keeps needs within)
    (fun rec => Nat.not_le_of_gt below (above_of_recoverable fall nothing short needs rec))

/-- Under the regime the level of the course as it was never rises, and at step `x` it is below every
positive need, so it is nothing there. With nothing given from nothing, giving short of `H₁` below `y₁`, every way on
`alone`'s orbit from `w` using at least `H₁`, and the start `x` below `H₁ + y₁`; by `regime_levels`,
`Optimum.never_rises` and `Optimum.ends_within`. Needed by `noReturn_exists`,
`turns_in_time_iff_before`, `Three.noReturn` and `Three.lock_falls`. -/
private theorem asItWas_falls {alone : W → W} {giving : Nat → Nat} {use : W → Nat} {H₁ y₁ : Nat}
    (nothing : RegimeMargin.FromNothing giving) (short₁ : RegimeMargin.Short giving H₁ y₁)
    {w : W} {x : Nat} (uses₁ : ∀ j, H₁ ≤ use (Law.orbit alone w j)) (below : x < H₁ + y₁) :
    (∀ t, (Law.orbit (asItWas alone (fun w x => RegimeMargin.step giving (use w) x)) (w, x)
        (t + 1)).2 ≤
      (Law.orbit (asItWas alone (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2) ∧
    ∀ m, 0 < m →
      (Law.orbit (asItWas alone (fun w x => RegimeMargin.step giving (use w) x)) (w, x) x).2 < m :=
  have levels := regime_levels
    (X := fun t => (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2)
    (D := fun t => use (Law.orbit alone w t)) nothing short₁ uses₁ below
    (fun t => congrArg (fun v => RegimeMargin.step giving (use v) (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2) (asItWas_way alone _ (w, x) t))
  ⟨fun t => Optimum.never_rises (x := fun t => (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2) levels.1 (levels.2.1 t)
      (levels.2.2 t),
   fun _ pos => Optimum.ends_within (x := fun t => (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2) levels.1 levels.2.1 levels.2.2
      pos x (Nat.lt_add_of_pos_left pos)⟩

/-- **R4. On the pair, the level course is the course as it was turned one step after its first
marked step.** With `AloneOutside`, a way after a marked step of the kept kind (`turns`), a kind every
step keeps (`kept`) that uses `H₂` (`uses`), and the level's step `RegimeMargin.step giving (use w)`:
where `T` is the first step at which the level of the course as it was from `(w, x)` is marked, the
pair's level course from `(w, x)` is, at every step, that course turned at `T + 1` to `H₂`. No premise
on the need, and none on `giving`. At the marked step `T` the way is still the way as it was, so the
level at `T + 1` is that of the course as it was; the way from `T + 1` on is of the kept kind. -/
theorem course_turned {marked : Nat → Prop} {alone : W → W} {after : W → Nat → W}
    {Kept : W → Prop} {giving : Nat → Nat} {use : W → Nat} {H₂ : Nat}
    (outside : AloneOutside marked alone after) (turns : ∀ w x, marked x → Kept (after w x))
    (kept : ∀ w x, Kept w → Kept (after w x)) (uses : ∀ w, Kept w → use w = H₂)
    {w : W} {x T : Nat}
    (before : ∀ j, j < T → ¬ marked (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2)
    (markedT : marked (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).2) :
    ∀ t, (Law.orbit (pair after (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2 =
      turned (fun j => (Law.orbit (asItWas alone
        (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2) giving H₂ (T + 1) t :=
  have agree : ∀ j, j ≤ T →
      Law.orbit (pair after (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j =
        Law.orbit (asItWas alone (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j :=
    fun j le => agrees_until_marked outside _ (w, x) j
      (fun i lt => before i (Nat.lt_of_lt_of_le lt le))
  have next : Law.orbit (pair after (fun w x => RegimeMargin.step giving (use w) x)) (w, x)
      (T + 1) =
      (after (Law.orbit (asItWas alone (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).1
        (Law.orbit (asItWas alone (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).2,
       (Law.orbit (asItWas alone (fun w x => RegimeMargin.step giving (use w) x)) (w, x)
        (T + 1)).2) :=
    congrArg (pair after (fun w x => RegimeMargin.step giving (use w) x)) (agree T (Nat.le_refl T))
  have run := kept_run (giving := giving) kept uses
    (w := after (Law.orbit (asItWas alone (fun w x => RegimeMargin.step giving (use w) x)) (w, x)
      T).1 (Law.orbit (asItWas alone (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).2)
    (x := (Law.orbit (asItWas alone (fun w x => RegimeMargin.step giving (use w) x)) (w, x)
      (T + 1)).2)
    (turns _ _ markedT)
  fun t => (Nat.lt_or_ge t (T + 1)).elim
    (fun lt => (congrArg Prod.snd (agree t (Nat.le_of_lt_succ lt))).trans
      (turned_before (X := fun j => (Law.orbit (asItWas alone
        (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2) (Nat.le_of_lt lt)).symm)
    (fun ge => match le_dest ge with
      | ⟨k, e⟩ =>
        Eq.subst (motive := fun i =>
            (Law.orbit (pair after (fun w x => RegimeMargin.step giving (use w) x)) (w, x) i).2 =
              turned (fun j => (Law.orbit (asItWas alone
                (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2) giving H₂ (T + 1) i)
          e.symm
          ((congrArg Prod.snd
              ((Law.orbit_add (pair after (fun w x => RegimeMargin.step giving (use w) x)) (w, x)
                  (T + 1) k).trans
                (congrArg (fun s => Law.orbit
                  (pair after (fun w x => RegimeMargin.step giving (use w) x)) s k) next))).trans
            ((run k).2.trans (turned_after (fun j => (Law.orbit (asItWas alone
              (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2) giving H₂ (T + 1)
              k).symm)))

/-- **R5. The course as it was has a point of no return, within `x` steps.** Under
`turns_in_time_iff`'s premises on the regime and on the course as it was (none on the marks or the
kept kind): nothing given from nothing; giving short of `H₂` below `y₂`, meeting it from `y₂` up to
`hi`, the step under `H₂` keeping the level within `hi`; a positive need at most `H₂ + y₂`; giving
short of `H₁` below `y₁`, every way on `alone`'s orbit from `w` using at least `H₁`, and the start `x`
below `H₁ + y₁` and at most `hi`. Then the level course as it was from `(w, x)`, with the turns to
`H₂` as the feasible courses and the need met at every step as what is asked, has a point of no
return `N ≤ x`. By `noReturnAt_of_past`. The premises on `H₂` (with `high`) decide recoverability at
each step as in `recoverable_iff_above`; that the course is not recoverable at step `x` needs only
that its level there is below the need (a course that agrees with it at `x` does not meet the need
there), which the premises on the course as it was give with a positive need
(`Optimum.ends_within`). -/
theorem noReturn_exists {alone : W → W} {giving : Nat → Nat} {use : W → Nat}
    {H₁ y₁ H₂ y₂ hi need : Nat}
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H₂ y₂)
    (meets : RegimeMargin.Meets giving H₂ y₂ hi) (keeps : RegimeMargin.Keeps giving H₂ hi)
    (needs : 0 < need) (within : need ≤ H₂ + y₂)
    (short₁ : RegimeMargin.Short giving H₁ y₁) {w : W} {x : Nat}
    (uses₁ : ∀ j, H₁ ≤ use (Law.orbit alone w j)) (below : x < H₁ + y₁) (high : x ≤ hi) :
    ∃ N, N ≤ x ∧ NoReturnAt
      (Turned (fun j => (Law.orbit (asItWas alone
        (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2) giving H₂)
      (MeetsNeed need)
      (fun t _ => (Law.orbit (asItWas alone
        (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2) N :=
  have regime := asItWas_falls nothing short₁ uses₁ below
  noReturnAt_of_past
    (recoverable_decided (X := fun j => (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2)
      regime.1 high nothing short meets keeps needs within)
    (fun rec => Nat.not_le_of_gt (regime.2 need needs) (met_of_recoverable rec x (Nat.le_refl x)))

/-- **R6. Turning in time is turning before the point of no return.** Under `turns_in_time_iff`'s
premises (`AloneOutside` and decided marks; a way after a marked step of the kept kind, a kind every
step keeps that uses `H₂`; nothing given from nothing; giving short of `H₂` below `y₂`, meeting it from
`y₂` up to `hi`, the step under `H₂` keeping the level within `hi`; a positive need at most
`H₂ + y₂`; giving short of `H₁` below `y₁`, every way on `alone`'s orbit from `w` using at least `H₁`,
and the start `x` below `H₁ + y₁` and at most `hi`): the line from `(w, x)` never ends exactly where
there is a step `T` of the course as it was, the need met and no level marked before it, the need met
and the level marked at it, and a point of no return `N` of the course as it was (the turns to `H₂`
feasible, the need met at every step asked) with `T + 1 < N`. The need met at and before `T` follows
from that point `N` with `T + 1 < N`, with no premise (the course that recovers at `T + 1` agrees with the course as it was
up to there and meets the need); it is kept to match `turns_in_time_iff`. Proved through
`course_turned`, `turned_meets_iff` and `recoverable_iff_above`: the pair's own level course is the
course as it was turned at `T + 1`, and that turn meets the need exactly where the course as it was is
recoverable at `T + 1`. `recoverable_iff_above` at `T + 1` is used in both directions: its only-if
direction, where `short` enters, in this theorem's if direction, and its if direction, with
`noReturn_exists` and `NoReturnAt.recoverable_iff`, in this theorem's only-if direction.
`unending_iff_first_marked` is used only to find `T`. -/
theorem turns_in_time_iff_before {marked : Nat → Prop} [DecidablePred marked] {alone : W → W}
    {after : W → Nat → W} {Kept : W → Prop} {giving : Nat → Nat} {use : W → Nat}
    {H₁ y₁ H₂ y₂ hi need : Nat}
    (outside : AloneOutside marked alone after) (turns : ∀ w x, marked x → Kept (after w x))
    (kept : ∀ w x, Kept w → Kept (after w x)) (uses : ∀ w, Kept w → use w = H₂)
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H₂ y₂)
    (meets : RegimeMargin.Meets giving H₂ y₂ hi) (keeps : RegimeMargin.Keeps giving H₂ hi)
    (needs : 0 < need) (within : need ≤ H₂ + y₂)
    (short₁ : RegimeMargin.Short giving H₁ y₁) {w : W} {x : Nat}
    (uses₁ : ∀ j, H₁ ≤ use (Law.orbit alone w j)) (below : x < H₁ + y₁) (high : x ≤ hi) :
    «不穷» (net need after (fun w x => RegimeMargin.step giving (use w) x)) «一» (w, x) ↔
      ∃ T, (∀ j, j < T →
          need ≤ (Law.orbit (asItWas alone
            (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2 ∧
          ¬ marked (Law.orbit (asItWas alone
            (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2) ∧
        need ≤ (Law.orbit (asItWas alone
          (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).2 ∧
        marked (Law.orbit (asItWas alone
          (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).2 ∧
        ∃ N, NoReturnAt
            (Turned (fun j => (Law.orbit (asItWas alone
              (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2) giving H₂)
            (MeetsNeed need)
            (fun t _ => (Law.orbit (asItWas alone
              (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2) N ∧
          T + 1 < N :=
  have regime := asItWas_falls nothing short₁ uses₁ below
  have recAt := fun n => recoverable_iff_above (N := n)
    (X := fun j => (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2)
    regime.1 high nothing short meets keeps needs within
  ⟨fun never =>
    match (unending_iff_first_marked outside ⟨x, regime.2 need needs⟩).mp never with
    | ⟨T, before, atT, markedT, _⟩ =>
      have line := course_turned (giving := giving) outside turns kept uses
        (fun j lt => (before j lt).2) markedT
      have low := above_of_turned_meets (X := fun j => (Law.orbit (asItWas alone
            (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2)
          nothing short needs fun t =>
        Eq.subst (motive := fun z => need ≤ z) (line t) (Law.stepWhile_unending_iff.mp never t)
      match noReturn_exists nothing short meets keeps needs within short₁ uses₁ below high with
      | ⟨N, _, point⟩ =>
        ⟨T, before, atT, markedT, N, point, point.recoverable_iff.mp ((recAt (T + 1)).mpr low)⟩,
   fun ⟨T, before, _, markedT, _, point, lt⟩ =>
    have line := course_turned (giving := giving) outside turns kept uses
      (fun j lt => (before j lt).2) markedT
    have low := (recAt (T + 1)).mp (point.2 (T + 1) lt)
    Law.stepWhile_unending_iff.mpr fun t =>
      Eq.subst (motive := fun z => need ≤ z) (line t).symm
        (turned_meets_of_above (X := fun j => (Law.orbit (asItWas alone
          (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2)
          regime.1 high meets keeps within low t)⟩

end PointOfNoReturn

/-! ## 8. Three courses from one start -/

namespace Three

/-- Giving that rises with the level to six at six and falls to nothing at twelve. -/
def giving (z : Nat) : Nat := min z (12 - z)

/-- Two kinds of way: as it was (`true`), which uses five, and the kept kind (`false`), which uses
three. -/
def use (w : Bool) : Nat := bif w then 5 else 3

/-- The level after a step: `RegimeMargin.step` under the way's use. -/
def left (w : Bool) (x : Nat) : Nat := RegimeMargin.step giving (use w) x

/-- At a level from `low` to `high` the way after a step is of the kept kind; elsewhere it is the
way. -/
def after (low high : Nat) (w : Bool) (x : Nat) : Bool := if low ≤ x ∧ x ≤ high then false else w

private theorem outside (low high : Nat) :
    AloneOutside (fun x => low ≤ x ∧ x ≤ high) id (after low high) :=
  fun _ _ h => if_neg h

private theorem turns (low high : Nat) :
    ∀ w x, (low ≤ x ∧ x ≤ high) → after low high w x = false :=
  fun _ _ h => if_pos h

private theorem kept (low high : Nat) :
    ∀ w x, w = false → after low high w x = false :=
  fun _ x k => if h : low ≤ x ∧ x ≤ high then if_pos h else (if_neg h).trans k

private theorem uses_kept : ∀ w, w = false → use w = 3 :=
  fun _ k => Eq.subst (motive := fun v => use v = 3) k.symm rfl

private theorem orbit_id : ∀ j, Law.orbit (id : Bool → Bool) true j = true
  | 0 => rfl
  | j + 1 => orbit_id j

private theorem uses_true : ∀ j, 5 ≤ use (Law.orbit id true j) :=
  fun j => Eq.subst (motive := fun v => 5 ≤ use v) (orbit_id j).symm (Nat.le_refl 5)

/-- **First marked at step 0 or at step 1, the line never ends.** From the level nine, with the mark
at nine the way turns at once and eight is left; with the mark at eight it turns one step later and
six is left, the kept kind's `H₂ + y₂`. -/
theorem goes_on : «不穷» (net 1 (after 9 9) left) «一» (true, 9) ∧
    «不穷» (net 1 (after 8 8) left) «一» (true, 9) :=
  have iff_at := fun low high =>
    turns_in_time_iff (marked := fun x => low ≤ x ∧ x ≤ high) (alone := id) (after := after low high)
      (Kept := fun w => w = false) (giving := giving) (use := use)
      (H₁ := 5) (y₁ := 5) (H₂ := 3) (y₂ := 3) (hi := 12) (need := 1) (w := true) (x := 9)
      (outside low high) (turns low high) (kept low high) uses_kept rfl
      (RegimeMargin.short_of_below rfl) (RegimeMargin.meets_of_below rfl)
      (RegimeMargin.keeps_of_below rfl) (by decide) (by decide) (RegimeMargin.short_of_below rfl)
      uses_true (by decide) (by decide)
  ⟨(iff_at 9 9).mpr ⟨0, by decide, by decide, by decide, by decide⟩,
   (iff_at 8 8).mpr ⟨1, by decide, by decide, by decide, by decide⟩⟩

/-- **First marked at step 2, it turns and ends.** With the mark at six, the course runs nine, eight,
six; there the way turns, two is left, below six, and after one more step nothing is left. At step 2,
the configuration `(true, 6)`, the line under the way's class ends while the net goes on
(`kind_ends_while_net_goes` at `κ := id`). -/
theorem turned_and_ends :
    Law.orbit (pair (after 6 6) left) (true, 9) 3 = (false, 2) ∧
    «迭» (net 1 (after 6 6) left) 4 (true, 9) (false, 0) ∧
    (∀ v, ¬ net 1 (after 6 6) left (false, 0) v) ∧
    ¬ «不穷» (net 1 (after 6 6) left) «一» (true, 9) ∧
    Law.orbit (pair (after 6 6) left) (true, 9) 2 = (true, 6) ∧
    «亡» (net 1 (after 6 6) left) (sameValue (fun s : Bool × Nat => s.1)) (true, 6) ∧
      ∃ v, net 1 (after 6 6) left (true, 6) v :=
  ⟨rfl, (Law.stepWhile_steps_iff 4).mpr ⟨by decide, rfl⟩,
   Law.stepWhile_none_iff.mpr (by decide),
   fun never => absurd (Law.stepWhile_unending_iff.mp never 4) (by decide),
   rfl,
   kind_ends_while_net_goes (κ := id) (need := 1) (after := after 6 6) (left := left) (w := true)
     (x := 6) (by decide) (by decide)⟩

/-- **With the mark at six, the line under the way's class ends while the net goes on, so the way's
class is not constant up to the net's end.** The step from `(true, 8)` to `(true, 6)` continues under
the way's class; `(true, 6)` ends under it and still conditions something
(`kind_ends_while_net_goes`); so by the root's `«亡而网续则不至终有常»` the class is not constant up to
the net's end, and by `kind_not_toEnd_of_turn`, with the unmarked level nine, not at `(true, 6)`'s
class. -/
theorem line_ends_while_net_goes :
    «续» (net 1 (after 6 6) left) (sameValue (fun s : Bool × Nat => s.1)) (true, 8) (true, 6) ∧
    ¬ «至终有常» (net 1 (after 6 6) left) (sameValue (fun s : Bool × Nat => s.1)) ∧
    ¬ «本类至终有常» (net 1 (after 6 6) left) (sameValue (fun s : Bool × Nat => s.1)) (true, 6) :=
  have continues : «续» (net 1 (after 6 6) left) (sameValue (fun s : Bool × Nat => s.1))
      (true, 8) (true, 6) := ⟨⟨by decide, rfl⟩, rfl⟩
  have ends := kind_ends_while_net_goes (κ := id) (need := 1) (after := after 6 6) (left := left)
    (w := true) (x := 6) (by decide) (by decide)
  ⟨continues, «亡而网续则不至终有常» continues ends.1 ends.2,
   kind_not_toEnd_of_turn (outside 6 6) (κ := id) (fun _ => rfl) (left := left) (w := true)
     (x := 6) (x₀ := 9) (by decide) (by decide) (by decide) (by decide)⟩

/-- **With no marked level, it ends as it was.** No level that meets the need is marked (marks from
ten down to nothing hold no level); the course runs nine, eight, six, two, nothing, and the line ends
there, its way as it was. -/
theorem ends_as_it_was :
    (∀ x, 1 ≤ x → ¬ (10 ≤ x ∧ x ≤ 0)) ∧
    «迭» (net 1 (after 10 0) left) 4 (true, 9) (true, 0) ∧
    (∀ v, ¬ net 1 (after 10 0) left (true, 0) v) ∧
    ¬ «不穷» (net 1 (after 10 0) left) «一» (true, 9) :=
  ⟨unmarked_interval_iff.mpr (.inl (by decide)), (Law.stepWhile_steps_iff 4).mpr ⟨by decide, rfl⟩,
   Law.stepWhile_none_iff.mpr (by decide),
   fun never => absurd (Law.stepWhile_unending_iff.mp never 4) (by decide)⟩

/-- **From nine as it was, the point of no return is step 3.** The course as it was runs nine, eight,
six, two, nothing; with the turns to the kept kind's use three as the feasible courses (`y = 3`, so
`H₂ + y₂ = 6`) and a need of one met at every step as what is asked, step 3 is the first at which it
is not recoverable (`noReturnAt_iff_first_below`). First marked at step 0 or 1, the pair's course is
the course as it was turned at step 1 or 2 (`course_turned`), before the point, and the line never
ends (`goes_on`); first marked at step 2 it is turned at step 3, the point itself, and the line ends
(`turned_and_ends`). -/
theorem noReturn :
    NoReturnAt (Turned (fun t => (Law.orbit (asItWas id left) (true, 9) t).2) giving 3)
      (MeetsNeed 1) (fun t _ => (Law.orbit (asItWas id left) (true, 9) t).2) 3 :=
  (noReturnAt_iff_first_below (X := fun t => (Law.orbit (asItWas id left) (true, 9) t).2)
    (giving := giving) (H := 3) (y := 3) (hi := 12) (need := 1) (N := 3)
    (asItWas_falls (giving := giving) (use := use) (H₁ := 5) (y₁ := 5) (w := true) (x := 9)
      rfl (RegimeMargin.short_of_below rfl) uses_true (by decide)).1
    (by decide) rfl (RegimeMargin.short_of_below rfl) (RegimeMargin.meets_of_below rfl)
    (RegimeMargin.keeps_of_below rfl) (by decide) (by decide)).mpr ⟨by decide, by decide⟩

/-- The share's order for the lock's case: a natural number, by `≤`. -/
def shareOrder : Ideals.Preorder Nat where
  le := Nat.le
  refl := Nat.le_refl
  trans := Nat.le_trans

/-- The rule's order for the lock's case: `false` below `true`. -/
def ruleOrder : Ideals.Preorder Bool where
  le g g' := g = true → g' = true
  refl _ := id
  trans h k e := k (h e)

/-- The share left as it is under every rule. -/
def lockShare (a : Nat) (_ : Bool) : Nat := a

/-- The rule read off the share: `true` from a share of three up. -/
def lockRead (a : Nat) (_ : Bool) : Bool := decide (3 ≤ a)

/-- The lock's way uses as `use` does at its rule: five where the rule is `true`, three where `false`. -/
def lockUse (v : Nat × Bool × Nat) : Nat := use v.2.1

/-- The lock's step as it was at every level: no level marked. -/
def lockAfter (v : Nat × Bool × Nat) (_ : Nat) : Nat × Bool × Nat :=
  windowAlone lockShare lockRead (fun _ => true) v

/-- **On the lock's own types, a `Locked` start that uses five from the level nine ends `Locked` in
four steps.** The share a natural number left as it is, the rule `false` below `true`, favouring the
rule `true`, the rule read `true` from a share of three up at every step, no level marked, giving
`min z (12 - z)`, a use of five where the rule is `true` and three where it is `false`, a need of one,
`H = y = 5`: every premise of `locked_ends_with_net_regime` holds from the way `(3, true, 0)` at the
level nine, and it gives a line that ends within nine steps, `Locked`. The line itself runs nine,
eight, six, two, nothing, the numbers of `ends_as_it_was`, and ends at the way `(3, true, 4)` at the
level nothing, which conditions nothing, its share three and rule `true` `Locked`. From
`(2, true, 0)` the start is not `Locked` (the rule read there is `false`, below the rule in force). -/
theorem lock_ends :
    (∃ n t, n ≤ 9 ∧
      «迭» (net 1 lockAfter (fun w x => RegimeMargin.step giving (lockUse w) x)) n ((3, true, 0), 9) t ∧
      (∀ v, ¬ net 1 lockAfter (fun w x => RegimeMargin.step giving (lockUse w) x) t v) ∧
      t.1 = Law.orbit (windowAlone lockShare lockRead (fun _ => true)) (3, true, 0) n ∧
      RuleCapture.Locked ruleOrder (fun g => g = true) lockRead (t.1.1, t.1.2.1)) ∧
    «迭» (net 1 lockAfter (fun w x => RegimeMargin.step giving (lockUse w) x)) 4
      ((3, true, 0), 9) ((3, true, 4), 0) ∧
    (∀ v, ¬ net 1 lockAfter (fun w x => RegimeMargin.step giving (lockUse w) x) ((3, true, 4), 0) v) ∧
    RuleCapture.Locked ruleOrder (fun g => g = true) lockRead (3, true) ∧
    ¬ RuleCapture.Locked ruleOrder (fun g => g = true) lockRead (2, true) :=
  ⟨locked_ends_with_net_regime (P := shareOrder) (M := ruleOrder) (favours := fun g => g = true)
      (fA := lockShare) (hA := lockRead) (reads := fun _ => true) (marked := fun _ => False)
      (after := lockAfter) (giving := giving) (use := lockUse) (H := 5) (y := 5)
      (w := (3, true, 0)) (x := 9)
      (fun x _ _ => Nat.le_refl x)
      (fun _ _ _ _ le read => decide_eq_true (Nat.le_trans (of_decide_eq_true read) le))
      (fun le f => le f) (fun _ _ _ => rfl) (by decide) (fun _ _ none => none) rfl
      (RegimeMargin.short_of_below rfl) ⟨rfl, fun _ => rfl⟩
      (fun v _ rule => Eq.subst (motive := fun b => 5 ≤ use b) (rule rfl).symm (Nat.le_refl 5))
      (by decide),
   (Law.stepWhile_steps_iff 4).mpr ⟨by decide, rfl⟩,
   Law.stepWhile_none_iff.mpr (by decide),
   ⟨rfl, fun _ => rfl⟩,
   fun lock => absurd (lock.2 rfl) (by decide)⟩

/-- The share raised by one where the rule favours (`true`) and left as it is where it does not. -/
def riseShare (a : Nat) (g : Bool) : Nat := bif g then a + 1 else a

/-- The rising lock's step as it was at every level: no level marked. -/
def riseAfter (v : Nat × Bool × Nat) (_ : Nat) : Nat × Bool × Nat :=
  windowAlone riseShare lockRead (fun _ => true) v

/-- **Along `lock_ends`'s course the share stays three.** Along
`windowAlone lockShare lockRead (fun _ => true)` from
`(3, true, 0)` the share after `n` steps is `3`, for every `n`: there the share-not-below conjunct of
`locked_alone_not_below` holds by `Nat.le_refl`. Stated to set beside `rise_orbit`. -/
theorem lock_share_stays : ∀ n,
    (Law.orbit (windowAlone lockShare lockRead (fun _ => true)) (3, true, 0) n).1 = 3
  | 0 => rfl
  | n + 1 => lock_share_stays n

/-- **Along the rising lock's own course the share rises by one at every step.** Along
`windowAlone riseShare lockRead (fun _ => true)` from `(3, true, 0)` the way after `n` steps is
`(3 + n, true, n)`, for every `n`: the rule in force is `true`, so `riseShare` adds one, and the rule
read off a share of `3 + n` is `true` again. -/
theorem rise_orbit : ∀ n,
    Law.orbit (windowAlone riseShare lockRead (fun _ => true)) (3, true, 0) n = (3 + n, true, n)
  | 0 => rfl
  | n + 1 =>
    (congrArg (windowAlone riseShare lockRead (fun _ => true)) (rise_orbit n)).trans
      (congrArg (fun b : Bool => ((3 + (n + 1) : Nat), b, n + 1))
        (decide_eq_true (Nat.le_add_right 3 n)))

/-- **Along the rising lock's course the share is strictly above the start's after every step.** For
every `n`, the share after `n + 1` steps along `windowAlone riseShare lockRead (fun _ => true)` from
`(3, true, 0)` is above three, and after one step it is four, which is not at or below three
(`¬ 4 ≤ 3` in `shareOrder`). So the
share-not-below conjunct of `locked_alone_not_below` is, on this course, not reflexivity: it holds at
a share that has moved. -/
theorem rise_above :
    (∀ n, 3 < (Law.orbit (windowAlone riseShare lockRead (fun _ => true)) (3, true, 0) (n + 1)).1) ∧
    (Law.orbit (windowAlone riseShare lockRead (fun _ => true)) (3, true, 0) 1).1 = 4 ∧
    ¬ shareOrder.le (Law.orbit (windowAlone riseShare lockRead (fun _ => true)) (3, true, 0) 1).1 3 :=
  ⟨fun n => Eq.subst (motive := fun v : Nat × Bool × Nat => 3 < v.1) (rise_orbit (n + 1)).symm
      (Nat.lt_succ_of_le (Nat.le_add_right 3 n)),
   rfl,
   fun le => Nat.not_succ_le_self 3 le⟩

/-- **A lock whose share rises under the favouring rule, used at five from the level nine, ends
`Locked` in four steps, its share risen to seven.** As `lock_ends`, with one difference: the share
steps by `riseShare`, which adds one where the rule is `true` (favouring) and leaves it where it is
`false`, in place of `lockShare`, which leaves it under every rule. The rule `false` below `true`,
favouring the rule `true`, the rule read `true` from a share of three up at every step (`lockRead`), no
level marked, giving `min z (12 - z)`, a use of five where the rule is `true` and three where it is
`false`, a need of one, `H = y = 5`: every premise of `locked_ends_with_net_regime` holds from the way
`(3, true, 0)` at the level nine, and it gives a line that ends within nine steps, `Locked`. `Raises`
holds by `Nat.le_succ` at the favouring rule, not by `Nat.le_refl`; `ReadsShare`, `upper`, the
`Locked` start, the floor on the use (`draws`, which reads only that the rule is not below `true`) and
the not-responding premises (`outside` by `rfl`, `un` with nothing marked) are met as `lock_ends` meets
them, and the start below `H + y` (nine below ten) is given, as there. The line runs nine, eight, six,
two, nothing, the numbers of `lock_ends`, and ends at the way `(7, true, 4)` at the level nothing,
which conditions nothing, its share seven and rule `true` `Locked` (the rule read off seven is
`true`, not below the rule in force); along it the share is `3 + n` after `n` steps (`rise_orbit`), above three
after every step (`rise_above`), where along `lock_ends`'s course it stays three
(`lock_share_stays`). What the case shows: the premises of `locked_ends_with_net_regime` met together
where the share moves, so that `locked_alone_not_below`'s share conjunct holds at a share that has
risen (through `Raises` at `Nat.le_succ`, chained by the order's transitivity), and the rule read off
each risen share stays `true` through `ReadsShare`. What it does not show: the rule conjunct is still
`true` not below `true` at every step, as in `lock_ends`; `draws` reads only that conjunct, so the
share conjunct, though not reflexivity here, is not what the floor on the use rests on; the rise draws
no more (the use reads only the rule); the lock does not bring the start below `H + y` (given); and
the case stands for no course beyond these numbers. -/
theorem rise_lock_ends :
    (∃ n t, n ≤ 9 ∧
      «迭» (net 1 riseAfter (fun w x => RegimeMargin.step giving (lockUse w) x)) n ((3, true, 0), 9) t ∧
      (∀ v, ¬ net 1 riseAfter (fun w x => RegimeMargin.step giving (lockUse w) x) t v) ∧
      t.1 = Law.orbit (windowAlone riseShare lockRead (fun _ => true)) (3, true, 0) n ∧
      RuleCapture.Locked ruleOrder (fun g => g = true) lockRead (t.1.1, t.1.2.1)) ∧
    «迭» (net 1 riseAfter (fun w x => RegimeMargin.step giving (lockUse w) x)) 4
      ((3, true, 0), 9) ((7, true, 4), 0) ∧
    (∀ v, ¬ net 1 riseAfter (fun w x => RegimeMargin.step giving (lockUse w) x) ((7, true, 4), 0) v) ∧
    RuleCapture.Locked ruleOrder (fun g => g = true) lockRead (7, true) :=
  ⟨locked_ends_with_net_regime (P := shareOrder) (M := ruleOrder) (favours := fun g => g = true)
      (fA := riseShare) (hA := lockRead) (reads := fun _ => true) (marked := fun _ => False)
      (after := riseAfter) (giving := giving) (use := lockUse) (H := 5) (y := 5)
      (w := (3, true, 0)) (x := 9)
      (fun x _ favoured =>
        Eq.subst (motive := fun b : Bool => x ≤ riseShare x b) favoured.symm (Nat.le_succ x))
      (fun _ _ _ _ le read => decide_eq_true (Nat.le_trans (of_decide_eq_true read) le))
      (fun le f => le f) (fun _ _ _ => rfl) (by decide) (fun _ _ none => none) rfl
      (RegimeMargin.short_of_below rfl) ⟨rfl, fun _ => rfl⟩
      (fun v _ rule => Eq.subst (motive := fun b => 5 ≤ use b) (rule rfl).symm (Nat.le_refl 5))
      (by decide),
   (Law.stepWhile_steps_iff 4).mpr ⟨by decide, rfl⟩,
   Law.stepWhile_none_iff.mpr (by decide),
   ⟨rfl, fun _ => rfl⟩⟩

/-- The reading of the level in the window: the rule `false`, whatever the share, the level and the
rule in force. -/
def noRule (_ : Nat × Nat) (_ : Bool) : Bool := false

/-- **Read at eight, in time, and the line still ends.** On the lock's own types (`lock_ends`'s share,
rule, reading off the share, use and giving, every step reading, a need of one), with the window
`[8, 9)` reading the rule `false` off the level (`noRule`), from the way `(3, true, 0)` at the level
nine: the course runs `((3, true, 0), 9)`, `((3, true, 1), 8)`, `((3, false, 2), 6)`,
`((3, true, 3), 6)`, `((3, true, 4), 2)`, `((3, true, 5), 0)`. The level is read at eight; the step from
eight is still under the use of five and leaves six, the kept kind's `H₂ + y₂`; at six, under the use of
three, six is left; six is outside the window, so the rule is read off the share again (`true`), the use
is five again and the line ends: in five steps it reaches `((3, true, 5), 0)`, which conditions nothing.
The start is `Locked`. The right side of `turns_in_time_iff` holds, at `T = 1` with the window's levels
marked and the lock's step as it was (`windowAlone`) as `alone`, while the line ends:
`turns_in_time_iff`'s premise `kept` fails here (it follows from the last conjunct, since `kept` gives
`keptBelow` at any `c`). The premise of `locked_turns_in_time_on_window_iff` that fails is `low`, the
others holding at `H₁ = y₁ = 5`, `H₂ = y₂ = 3`, `hi = 6` and `c = 7` (argued here, not a Lean
statement): the window starts at eight, above `H₂ + y₂ = 6`, so that `keptBelow` of
`turns_in_time_iff_kept_below` fails at the level six for every `c` above six (the last conjunct). -/
theorem read_at_eight_ends :
    Law.orbit (pair (windowAfter lockShare lockRead noRule 8 9 (fun _ => true))
        (fun w x => RegimeMargin.step giving (lockUse w) x)) ((3, true, 0), 9) 1 =
      ((3, true, 1), 8) ∧
    Law.orbit (pair (windowAfter lockShare lockRead noRule 8 9 (fun _ => true))
        (fun w x => RegimeMargin.step giving (lockUse w) x)) ((3, true, 0), 9) 2 =
      ((3, false, 2), 6) ∧
    Law.orbit (pair (windowAfter lockShare lockRead noRule 8 9 (fun _ => true))
        (fun w x => RegimeMargin.step giving (lockUse w) x)) ((3, true, 0), 9) 3 =
      ((3, true, 3), 6) ∧
    Law.orbit (pair (windowAfter lockShare lockRead noRule 8 9 (fun _ => true))
        (fun w x => RegimeMargin.step giving (lockUse w) x)) ((3, true, 0), 9) 4 =
      ((3, true, 4), 2) ∧
    «迭» (net 1 (windowAfter lockShare lockRead noRule 8 9 (fun _ => true))
        (fun w x => RegimeMargin.step giving (lockUse w) x)) 5 ((3, true, 0), 9) ((3, true, 5), 0) ∧
    (∀ v, ¬ net 1 (windowAfter lockShare lockRead noRule 8 9 (fun _ => true))
        (fun w x => RegimeMargin.step giving (lockUse w) x) ((3, true, 5), 0) v) ∧
    ¬ «不穷» (net 1 (windowAfter lockShare lockRead noRule 8 9 (fun _ => true))
        (fun w x => RegimeMargin.step giving (lockUse w) x)) «一» ((3, true, 0), 9) ∧
    RuleCapture.Locked ruleOrder (fun g => g = true) lockRead (3, true) ∧
    (∃ T, (∀ j, j < T →
          1 ≤ (Law.orbit (asItWas (windowAlone lockShare lockRead (fun _ => true))
            (fun w x => RegimeMargin.step giving (lockUse w) x)) ((3, true, 0), 9) j).2 ∧
          ¬ (8 ≤ (Law.orbit (asItWas (windowAlone lockShare lockRead (fun _ => true))
              (fun w x => RegimeMargin.step giving (lockUse w) x)) ((3, true, 0), 9) j).2 ∧
            (Law.orbit (asItWas (windowAlone lockShare lockRead (fun _ => true))
              (fun w x => RegimeMargin.step giving (lockUse w) x)) ((3, true, 0), 9) j).2 < 9)) ∧
        1 ≤ (Law.orbit (asItWas (windowAlone lockShare lockRead (fun _ => true))
          (fun w x => RegimeMargin.step giving (lockUse w) x)) ((3, true, 0), 9) T).2 ∧
        (8 ≤ (Law.orbit (asItWas (windowAlone lockShare lockRead (fun _ => true))
            (fun w x => RegimeMargin.step giving (lockUse w) x)) ((3, true, 0), 9) T).2 ∧
          (Law.orbit (asItWas (windowAlone lockShare lockRead (fun _ => true))
            (fun w x => RegimeMargin.step giving (lockUse w) x)) ((3, true, 0), 9) T).2 < 9) ∧
        3 + 3 ≤ (Law.orbit (asItWas (windowAlone lockShare lockRead (fun _ => true))
          (fun w x => RegimeMargin.step giving (lockUse w) x)) ((3, true, 0), 9) (T + 1)).2) ∧
    (∀ c, 6 < c → ¬ ∀ (v : Nat × Bool × Nat) (z : Nat), v.2.1 = false → 3 + 3 ≤ z → z < c →
      (windowAfter lockShare lockRead noRule 8 9 (fun _ => true) v z).2.1 = false) :=
  ⟨rfl, rfl, rfl, rfl, (Law.stepWhile_steps_iff 5).mpr ⟨by decide, rfl⟩,
   Law.stepWhile_none_iff.mpr (by decide),
   fun never => absurd (Law.stepWhile_unending_iff.mp never 5) (by decide),
   ⟨rfl, fun _ => rfl⟩,
   ⟨1, by decide, by decide, by decide, by decide⟩,
   fun _ above kb => absurd (kb (3, false, 2) 6 rfl (by decide) above) (by decide)⟩

/-- Levels from ten to twelve are safe under both rules: a use of five or of three steps each of them
to a level from ten to twelve. Checked over the levels below thirteen. Needed by `read_to_ten`. -/
private theorem safe_ten : ∀ (b : Bool) (x : Nat), x < 13 → 10 ≤ x →
    10 ≤ RegimeMargin.step giving (use b) x ∧ RegimeMargin.step giving (use b) x ≤ 12 :=
  fun b => Bool.rec (motive := fun b => ∀ x, x < 13 → 10 ≤ x →
      10 ≤ RegimeMargin.step giving (use b) x ∧ RegimeMargin.step giving (use b) x ≤ 12)
    (by decide) (by decide) b

/-- Along the lock's own course from the way `(3, true, 0)` the way after `n` steps is `(3, true, n)`,
for every `n`: the share stays three and the rule read off it is `true`. By induction, as
`rise_orbit`. Needed by `lock_falls`. -/
private theorem lock_orbit : ∀ n,
    Law.orbit (windowAlone lockShare lockRead (fun _ => true)) (3, true, 0) n = (3, true, n)
  | 0 => rfl
  | n + 1 => congrArg (windowAlone lockShare lockRead (fun _ => true)) (lock_orbit n)

/-- Along the lock's own course from the way `(3, true, 0)` at a level `x` below ten, the level never
rises: every way on it uses five (`lock_orbit`), and `asItWas_falls` applies at `H₁ = y₁ = 5`. Needed
by `read_to_ten` and `held_at_six`. -/
private theorem lock_falls {x : Nat} (below : x < 10) : ∀ t,
    (Law.orbit (asItWas (windowAlone lockShare lockRead (fun _ => true))
      (fun w x => RegimeMargin.step giving (lockUse w) x)) ((3, true, 0), x) (t + 1)).2 ≤
    (Law.orbit (asItWas (windowAlone lockShare lockRead (fun _ => true))
      (fun w x => RegimeMargin.step giving (lockUse w) x)) ((3, true, 0), x) t).2 :=
  (asItWas_falls (alone := windowAlone lockShare lockRead (fun _ => true)) (giving := giving)
    (use := lockUse) (H₁ := 5) (y₁ := 5) (w := (3, true, 0)) (x := x) rfl
    (RegimeMargin.short_of_below rfl)
    (fun j => Eq.subst (motive := fun v => 5 ≤ lockUse v) (lock_orbit j).symm (Nat.le_refl 5))
    below).1

/-- **Read up to ten: from nine the line goes on, from seven it ends.** On the lock's own types as in
`read_at_eight_ends`, with the window `[6, 10)` reading the rule `false` (`noRule`), through
`locked_turns_in_time_on_window_iff` at `H₁ = y₁ = 5`, `H₂ = y₂ = 3`, `hi = 12`, `c = 10`, with `kept`
saying that the rule is `false`. From the way `(3, true, 0)` at the level nine the course is
`((3, true, 0), 9)`, `((3, false, 1), 8)`, `((3, false, 2), 10)`, `((3, true, 3), 12)`,
`((3, true, 4), 12)`: nine is read at step 0, and the level of the lock's own course one step later is
`RegimeMargin.step giving 5 9`, eight, at or above six, so the line never ends; at ten, outside the
window, the rule is read off the share again (`true`); the step from ten is still under the use of three
and leaves twelve; from twelve a use of five is met and twelve is left. From the level seven the course
is `((3, true, 0), 7)`, `((3, false, 1), 4)`, `((3, true, 2), 2)`, `((3, true, 3), 0)`: the net reaches
`((3, true, 3), 0)` in three steps, which conditions nothing, and the line does not go on, by the law's
only-if direction: at `T = 0` the level of the lock's own course one step later is four, below six, and
a later `T` would be a step whose level, at most four since that level never rises (`lock_falls`), the
window reads, which it does not. The law's `high` holds: from a start below ten the level of the lock's
own course never rises (`lock_falls`), so it stays within twelve. The kind is not kept at every level:
at the level ten the way `(3, false, 2)` is followed by the rule `true`. The start is `Locked`. -/
theorem read_to_ten :
    «不穷» (net 1 (windowAfter lockShare lockRead noRule 6 10 (fun _ => true))
        (fun w x => RegimeMargin.step giving (lockUse w) x)) «一» ((3, true, 0), 9) ∧
    Law.orbit (pair (windowAfter lockShare lockRead noRule 6 10 (fun _ => true))
        (fun w x => RegimeMargin.step giving (lockUse w) x)) ((3, true, 0), 9) 1 =
      ((3, false, 1), 8) ∧
    Law.orbit (pair (windowAfter lockShare lockRead noRule 6 10 (fun _ => true))
        (fun w x => RegimeMargin.step giving (lockUse w) x)) ((3, true, 0), 9) 2 =
      ((3, false, 2), 10) ∧
    Law.orbit (pair (windowAfter lockShare lockRead noRule 6 10 (fun _ => true))
        (fun w x => RegimeMargin.step giving (lockUse w) x)) ((3, true, 0), 9) 3 =
      ((3, true, 3), 12) ∧
    Law.orbit (pair (windowAfter lockShare lockRead noRule 6 10 (fun _ => true))
        (fun w x => RegimeMargin.step giving (lockUse w) x)) ((3, true, 0), 9) 4 =
      ((3, true, 4), 12) ∧
    Law.orbit (pair (windowAfter lockShare lockRead noRule 6 10 (fun _ => true))
        (fun w x => RegimeMargin.step giving (lockUse w) x)) ((3, true, 0), 7) 1 =
      ((3, false, 1), 4) ∧
    Law.orbit (pair (windowAfter lockShare lockRead noRule 6 10 (fun _ => true))
        (fun w x => RegimeMargin.step giving (lockUse w) x)) ((3, true, 0), 7) 2 =
      ((3, true, 2), 2) ∧
    «迭» (net 1 (windowAfter lockShare lockRead noRule 6 10 (fun _ => true))
        (fun w x => RegimeMargin.step giving (lockUse w) x)) 3 ((3, true, 0), 7) ((3, true, 3), 0) ∧
    (∀ v, ¬ net 1 (windowAfter lockShare lockRead noRule 6 10 (fun _ => true))
        (fun w x => RegimeMargin.step giving (lockUse w) x) ((3, true, 3), 0) v) ∧
    ¬ «不穷» (net 1 (windowAfter lockShare lockRead noRule 6 10 (fun _ => true))
        (fun w x => RegimeMargin.step giving (lockUse w) x)) «一» ((3, true, 0), 7) ∧
    (¬ ∀ (v : Nat × Bool × Nat) (z : Nat), v.2.1 = false →
      (windowAfter lockShare lockRead noRule 6 10 (fun _ => true) v z).2.1 = false) ∧
    RuleCapture.Locked ruleOrder (fun g => g = true) lockRead (3, true) :=
  have iff_at := fun (x : Nat) (below : x < 10) =>
    locked_turns_in_time_on_window_iff (P := shareOrder) (M := ruleOrder)
      (favours := fun g => g = true) (fA := lockShare) (hA := lockRead) noRule 6 10
      (reads := fun _ => true) (kept := fun g => g = false) (giving := giving) (use := lockUse)
      (H₁ := 5) (y₁ := 5) (H₂ := 3) (y₂ := 3) (hi := 12) (need := 1) (c := 10)
      (w := (3, true, 0)) (x := x)
      (fun x _ _ => Nat.le_refl x)
      (fun _ _ _ _ le read => decide_eq_true (Nat.le_trans (of_decide_eq_true read) le))
      (fun le f => le f) (fun _ => rfl) (fun _ _ _ _ => rfl)
      (fun _ k => Eq.subst (motive := fun b => use b = 3) k.symm rfl)
      (fun v => Bool.rec (motive := fun b => 3 ≤ use b) (by decide) (by decide) v.2.1)
      rfl (RegimeMargin.short_of_below rfl) (RegimeMargin.meets_of_below rfl)
      (RegimeMargin.keeps_of_below rfl) (by decide) (by decide) (by decide) (by decide)
      (by decide) (fun v z ge top => safe_ten v.2.1 z (Nat.lt_succ_of_le top) ge)
      (RegimeMargin.short_of_below rfl) ⟨rfl, fun _ => rfl⟩
      (fun v _ rule => Eq.subst (motive := fun b => 5 ≤ use b) (rule rfl).symm (Nat.le_refl 5))
      below
      (fun T _ => Nat.le_trans
        (later_le (X := fun t => (Law.orbit (asItWas (windowAlone lockShare lockRead (fun _ => true))
          (fun w x => RegimeMargin.step giving (lockUse w) x)) ((3, true, 0), x) t).2)
          (lock_falls below) (Nat.zero_le (T + 1)))
        (Nat.le_of_lt_succ (Nat.lt_of_lt_of_le below (by decide))))
  ⟨(iff_at 9 (by decide)).mpr ⟨0, by decide, by decide, by decide, by decide⟩,
   rfl, rfl, rfl, rfl, rfl, rfl,
   (Law.stepWhile_steps_iff 3).mpr ⟨by decide, rfl⟩,
   Law.stepWhile_none_iff.mpr (by decide),
   fun never => match (iff_at 7 (by decide)).mp never with
     | ⟨T, _, _, read, up⟩ => match T, read, up with
       | 0, _, up => absurd up (by decide)
       | T + 1, read, _ => absurd (Nat.le_trans read.1
           (later_le (X := fun t => (Law.orbit (asItWas
             (windowAlone lockShare lockRead (fun _ => true))
             (fun w x => RegimeMargin.step giving (lockUse w) x)) ((3, true, 0), 7) t).2)
             (lock_falls (by decide)) (Nat.succ_le_succ (Nat.zero_le T))))
         (by decide),
   fun all => absurd (all (3, false, 2) 10 rfl) (by decide),
   ⟨rfl, fun _ => rfl⟩⟩

/-- From the way `(3, true, 0)` at the level nine on the window `[6, 9)` the configuration at
step `n + 2` is `((3, false, n + 2), 6)`, for every `n`: at six, inside the window, the rule
read is `false`, and the step under the use of three leaves six. By induction, as `rise_orbit`.
Needed by `held_at_six`. -/
private theorem held_orbit : ∀ n,
    Law.orbit (pair (windowAfter lockShare lockRead noRule 6 9 (fun _ => true))
        (fun w x => RegimeMargin.step giving (lockUse w) x)) ((3, true, 0), 9) (n + 2) =
      ((3, false, n + 2), 6)
  | 0 => rfl
  | n + 1 =>
    congrArg (pair (windowAfter lockShare lockRead noRule 6 9 (fun _ => true))
      (fun w x => RegimeMargin.step giving (lockUse w) x)) (held_orbit n)

/-- **Read from six to below nine: first read at step 1, in time, and the line never ends, with the kind
not kept at every level.** On the lock's own types as in `read_at_eight_ends`, with the window `[6, 9)`
reading the rule `false` (`noRule`), from the way `(3, true, 0)` at the level nine: the course is
`((3, true, 0), 9)`, `((3, true, 1), 8)`, `((3, false, 2), 6)`, and then `((3, false, n + 2), 6)` for
every `n` (the third conjunct, by the private `held_orbit`). The first step, under the use of five,
leaves eight; nine is outside the window, so the rule after it is read off the share (`true`); eight is
read, and the step from eight is still under the use of five and leaves six, the kept kind's `H₂ + y₂`;
six is read, and from then on the level holds at six, inside the window, under the use of three. The
line never ends by `locked_turns_in_time_on_window_iff` at `H₁ = y₁ = 5`, `H₂ = y₂ = 3`, `hi = 6`,
`c = 7` and `T = 1`: the lock's own course runs nine, eight, six, two, nothing, the window reads it
first at step 1, at eight, and one step later its level is six. There `safe` asks nothing, and the law's
`high` holds: the levels of the lock's own course that the window reads are eight and six, one step
after which it is at six and at two. The kind is not kept at every level: at the level nine the way
`(3, false, 0)` is followed by the rule read off the share, `true`. What goes on here is that after the
turn the level stays where the window reads it. -/
theorem held_at_six :
    Law.orbit (pair (windowAfter lockShare lockRead noRule 6 9 (fun _ => true))
        (fun w x => RegimeMargin.step giving (lockUse w) x)) ((3, true, 0), 9) 1 =
      ((3, true, 1), 8) ∧
    Law.orbit (pair (windowAfter lockShare lockRead noRule 6 9 (fun _ => true))
        (fun w x => RegimeMargin.step giving (lockUse w) x)) ((3, true, 0), 9) 2 =
      ((3, false, 2), 6) ∧
    (∀ n, Law.orbit (pair (windowAfter lockShare lockRead noRule 6 9 (fun _ => true))
        (fun w x => RegimeMargin.step giving (lockUse w) x)) ((3, true, 0), 9) (n + 2) =
      ((3, false, n + 2), 6)) ∧
    «不穷» (net 1 (windowAfter lockShare lockRead noRule 6 9 (fun _ => true))
        (fun w x => RegimeMargin.step giving (lockUse w) x)) «一» ((3, true, 0), 9) ∧
    ¬ ∀ (v : Nat × Bool × Nat) (z : Nat), v.2.1 = false →
      (windowAfter lockShare lockRead noRule 6 9 (fun _ => true) v z).2.1 = false :=
  ⟨rfl, rfl, held_orbit,
   (locked_turns_in_time_on_window_iff (P := shareOrder) (M := ruleOrder)
      (favours := fun g => g = true) (fA := lockShare) (hA := lockRead) noRule 6 9
      (reads := fun _ => true) (kept := fun g => g = false) (giving := giving) (use := lockUse)
      (H₁ := 5) (y₁ := 5) (H₂ := 3) (y₂ := 3) (hi := 6) (need := 1) (c := 7)
      (w := (3, true, 0)) (x := 9)
      (fun x _ _ => Nat.le_refl x)
      (fun _ _ _ _ le read => decide_eq_true (Nat.le_trans (of_decide_eq_true read) le))
      (fun le f => le f) (fun _ => rfl) (fun _ _ _ _ => rfl)
      (fun _ k => Eq.subst (motive := fun b => use b = 3) k.symm rfl)
      (fun v => Bool.rec (motive := fun b => 3 ≤ use b) (by decide) (by decide) v.2.1)
      rfl (RegimeMargin.short_of_below rfl) (RegimeMargin.meets_of_below rfl)
      (RegimeMargin.keeps_of_below rfl) (by decide) (by decide) (by decide) (by decide)
      (by decide) (fun _ _ ge top => absurd (Nat.le_trans ge top) (by decide))
      (RegimeMargin.short_of_below rfl) ⟨rfl, fun _ => rfl⟩
      (fun v _ rule => Eq.subst (motive := fun b => 5 ≤ use b) (rule rfl).symm (Nat.le_refl 5))
      (by decide)
      (fun T read => match T, read with
        | 0, read => absurd read.2 (by decide)
        | 1, _ => by decide
        | T + 2, _ => Nat.le_trans
            (later_le (X := fun t => (Law.orbit (asItWas
              (windowAlone lockShare lockRead (fun _ => true))
              (fun w x => RegimeMargin.step giving (lockUse w) x)) ((3, true, 0), 9) t).2)
              (lock_falls (by decide)) (Nat.le_add_left 3 T))
            (by decide))).mpr ⟨1, by decide, by decide, by decide, by decide⟩,
   fun all => absurd (all (3, false, 0) 9 rfl) (by decide)⟩

/-- From the way `(2, true, 0)` at the level nine on the window `[6, 8)` the configuration at step
`n + 3` is `((2, false, n + 3), 12)`, for every `n`: at twelve, outside the window, the rule read off
the share two is `false`, and the step under the use of three leaves twelve. By induction, as
`held_orbit`. Needed by `unlocked_goes_on`. -/
private theorem unlocked_orbit : ∀ n,
    Law.orbit (pair (windowAfter lockShare lockRead noRule 6 8 (fun _ => true))
        (fun w x => RegimeMargin.step giving (lockUse w) x)) ((2, true, 0), 9) (n + 3) =
      ((2, false, n + 3), 12)
  | 0 => rfl
  | n + 1 =>
    congrArg (pair (windowAfter lockShare lockRead noRule 6 8 (fun _ => true))
      (fun w x => RegimeMargin.step giving (lockUse w) x)) (unlocked_orbit n)

/-- Along the lock's own course from the way `(2, true, 0)` at the level nine the configuration at
step `n + 3` is `((2, false, n + 3), 12)`, for every `n`, as on the window `[6, 8)`
(`unlocked_orbit`). By induction. Needed by `unlocked_goes_on`. -/
private theorem unlocked_alone_orbit : ∀ n,
    Law.orbit (asItWas (windowAlone lockShare lockRead (fun _ => true))
        (fun w x => RegimeMargin.step giving (lockUse w) x)) ((2, true, 0), 9) (n + 3) =
      ((2, false, n + 3), 12)
  | 0 => rfl
  | n + 1 =>
    congrArg (asItWas (windowAlone lockShare lockRead (fun _ => true))
      (fun w x => RegimeMargin.step giving (lockUse w) x)) (unlocked_alone_orbit n)

/-- **From one start that is not `Locked`, the line goes on with no step at a level the window reads.**
On the lock's own types as in `read_at_eight_ends`, with the window `[6, 8)` reading the rule `false`
(`noRule`), from the way `(2, true, 0)` at the level nine, which is not `Locked` (the rule read off the
share two is `false`, below the rule `true` in force; the first conjunct). The pair's course and the
lock's own course are both `((2, true, 0), 9)`, `((2, false, 1), 8)`, `((2, false, 2), 10)`,
`((2, false, 3), 12)`, and then `((2, false, n + 3), 12)` for every `n` (from step 3 on by the private
`unlocked_orbit` and `unlocked_alone_orbit`; the configurations at steps 1 and 2 are not conjuncts: at
steps 0 to 2 the proof decides only that the need is met and that the level is not read): the rule read
off the share two is `false`, so the use falls to three without the level being read. The line never
ends (the second conjunct), and no step of the lock's own course is at a level the window reads (the
third conjunct), so the right side of `locked_turns_in_time_on_window_iff` fails here while the line
never ends. Every premise of that law other than `locked` holds here at `N = 6`, `K = 8`, `H₁ = y₁ = 5`,
`H₂ = y₂ = 3`, `hi = 6` and `c = 7` (argued here, not a Lean statement: each is met as `held_at_six`
meets it, with `K = 8`, so that `covers` is `7 ≤ 8`, and `draws` at the share two; `safe` asks nothing
since `c` is above `hi`, and `high` asks nothing by the third conjunct). -/
theorem unlocked_goes_on :
    ¬ RuleCapture.Locked ruleOrder (fun g => g = true) lockRead (2, true) ∧
    «不穷» (net 1 (windowAfter lockShare lockRead noRule 6 8 (fun _ => true))
        (fun w x => RegimeMargin.step giving (lockUse w) x)) «一» ((2, true, 0), 9) ∧
    ∀ T, ¬ (6 ≤ (Law.orbit (asItWas (windowAlone lockShare lockRead (fun _ => true))
          (fun w x => RegimeMargin.step giving (lockUse w) x)) ((2, true, 0), 9) T).2 ∧
        (Law.orbit (asItWas (windowAlone lockShare lockRead (fun _ => true))
          (fun w x => RegimeMargin.step giving (lockUse w) x)) ((2, true, 0), 9) T).2 < 8) :=
  ⟨fun lock => absurd (lock.2 rfl) (by decide),
   Law.stepWhile_unending_iff.mpr fun n => match n with
     | 0 => by decide
     | 1 => by decide
     | 2 => by decide
     | n + 3 => Eq.subst (motive := fun s : (Nat × Bool × Nat) × Nat => 1 ≤ s.2)
         (unlocked_orbit n).symm (by decide : 1 ≤ 12),
   fun T => match T with
     | 0 => by decide
     | 1 => by decide
     | 2 => by decide
     | n + 3 => fun read => absurd
         (Eq.subst (motive := fun s : (Nat × Bool × Nat) × Nat => s.2 < 8) (unlocked_alone_orbit n)
           read.2) (by decide : ¬ 12 < 8)⟩

/-- One use per drawer: the use of a way is its share. -/
def drawerUse (v : Nat × Bool × Nat) : Nat := v.1

/-- **A lock whose share rises, used one per drawer, from the level twelve: the line ends `Locked`
within `12 + 1` steps by `locked_ends_rising`, and in seven steps by a computed conjunct; at the start
no `H` at most the use and `y` with giving short of `H` below `y` put twelve below `H + y`, and at
step 4 `H = 7` and `y = 6` do (that the old law then applies is argued).** On the lock's own types as in
`rise_lock_ends` (the share by `riseShare`, the rule read `true` from a share of three up at every step,
`lockRead`, no level marked, giving `min z (12 - z)`, a need of one), with the use the share
(`drawerUse`), from the way `(3, true, 0)` at the level twelve. Every premise of `locked_ends_rising`
holds at `hi = 12`, with its `more` from `count_rises` at `u = 1` and the start's rule favouring (the
first conjunct: a line that ends within `12 + 1` steps, `Locked`). `Raises` and `ReadsShare` keep the
rule favouring along the course; the strict rise of the share is `count_rises`'s own premise `rise`,
met by `riseShare`. The course runs shares three to ten, levels twelve, twelve, twelve, twelve, twelve,
ten, four, nothing: `((3, true, 0), 12)`, `((4, true, 1), 12)`, `((5, true, 2), 12)`,
`((6, true, 3), 12)`, `((7, true, 4), 12)`, `((8, true, 5), 10)`, `((9, true, 6), 4)`, and in seven
steps it reaches `((10, true, 7), 0)`, which conditions nothing, its share ten and rule `true` `Locked`.
At the start the use of three leaves the level twelve where it is (`RegimeMargin.step giving 3 12 =
12`), and no `H` at most the start's use and `y` with giving short of `H` below `y` put twelve below
`H + y` (the conjunct after it). Since `ends_with_net_regime`'s `uses` at step 0 and
`locked_ends_with_net_regime`'s `draws` at the start itself ask a floor `H` at most three, and both ask
a start below `H + y` with giving short of `H` below `y`, their premises are not met from this start
(argued here from that conjunct). From step 4, the way `(7, true, 4)` at the level twelve, they are met
with `H = 7` and `y = 6`: giving is short of seven below six (`RegimeMargin.Short giving 7 6`), the use
there is at least seven (`7 ≤ drawerUse (7, true, 4)`), and twelve is below `7 + 6` (the three
conjuncts before the last); every way whose share is not below seven uses at least seven, since the use
is the share, and `(7, true)` is `Locked` (argued here, not Lean statements). In Lean the old law's
premises are excluded at step 0 only, and met at step 4 only by those three conjuncts. That at steps
1, 2 and 3 (shares four, five and six, the level twelve) no `H` at most the share and `y` with giving
short of `H` below `y` put twelve below `H + y`, so that the old law first applies at step 4 and the
four steps before it, held at twelve, are where `locked_ends_rising` reaches what the old law does
not, is by computation, not a Lean statement. The case stands for no course beyond these numbers. -/
theorem rise_count_ends :
    (∃ n t, n ≤ 12 + 1 ∧
      «迭» (net 1 riseAfter (fun w x => RegimeMargin.step giving (drawerUse w) x)) n
        ((3, true, 0), 12) t ∧
      (∀ v, ¬ net 1 riseAfter (fun w x => RegimeMargin.step giving (drawerUse w) x) t v) ∧
      t.1 = Law.orbit (windowAlone riseShare lockRead (fun _ => true)) (3, true, 0) n ∧
      RuleCapture.Locked ruleOrder (fun g => g = true) lockRead (t.1.1, t.1.2.1)) ∧
    Law.orbit (pair riseAfter (fun w x => RegimeMargin.step giving (drawerUse w) x))
        ((3, true, 0), 12) 1 = ((4, true, 1), 12) ∧
    Law.orbit (pair riseAfter (fun w x => RegimeMargin.step giving (drawerUse w) x))
        ((3, true, 0), 12) 2 = ((5, true, 2), 12) ∧
    Law.orbit (pair riseAfter (fun w x => RegimeMargin.step giving (drawerUse w) x))
        ((3, true, 0), 12) 3 = ((6, true, 3), 12) ∧
    Law.orbit (pair riseAfter (fun w x => RegimeMargin.step giving (drawerUse w) x))
        ((3, true, 0), 12) 4 = ((7, true, 4), 12) ∧
    Law.orbit (pair riseAfter (fun w x => RegimeMargin.step giving (drawerUse w) x))
        ((3, true, 0), 12) 5 = ((8, true, 5), 10) ∧
    Law.orbit (pair riseAfter (fun w x => RegimeMargin.step giving (drawerUse w) x))
        ((3, true, 0), 12) 6 = ((9, true, 6), 4) ∧
    «迭» (net 1 riseAfter (fun w x => RegimeMargin.step giving (drawerUse w) x)) 7
      ((3, true, 0), 12) ((10, true, 7), 0) ∧
    (∀ v, ¬ net 1 riseAfter (fun w x => RegimeMargin.step giving (drawerUse w) x)
      ((10, true, 7), 0) v) ∧
    RegimeMargin.step giving (drawerUse (3, true, 0)) 12 = 12 ∧
    (∀ H y, H ≤ drawerUse (3, true, 0) → RegimeMargin.Short giving H y → ¬ 12 < H + y) ∧
    RegimeMargin.Short giving 7 6 ∧ 7 ≤ drawerUse (7, true, 4) ∧ 12 < 7 + 6 ∧
    RuleCapture.Locked ruleOrder (fun g => g = true) lockRead (10, true) :=
  ⟨locked_ends_rising (P := shareOrder) (M := ruleOrder) (favours := fun g => g = true)
      (fA := riseShare) (hA := lockRead) (reads := fun _ => true) (marked := fun _ => False)
      (after := riseAfter) (giving := giving) (use := drawerUse) (hi := 12)
      (w := (3, true, 0)) (x := 12)
      (fun x _ favoured =>
        Eq.subst (motive := fun b : Bool => x ≤ riseShare x b) favoured.symm (Nat.le_succ x))
      (fun _ _ _ _ le read => decide_eq_true (Nat.le_trans (of_decide_eq_true read) le))
      (fun le f => le f) (fun _ _ _ => rfl) (by decide) (fun _ _ none => none) rfl
      (RegimeMargin.keeps_of_below rfl) (Nat.le_refl 12) ⟨rfl, fun _ => rfl⟩
      (count_rises (P := shareOrder) (M := ruleOrder) (favours := fun g => g = true)
        (fA := riseShare) (hA := lockRead) (reads := fun _ => true) (use := drawerUse) (u := 1)
        (w := (3, true, 0)) (fun le f => le f)
        (fun a _ favoured =>
          Eq.subst (motive := fun b : Bool => a < riseShare a b) favoured.symm (Nat.lt_succ_self a))
        (by decide) (fun v => (Nat.mul_one v.1).symm) rfl),
   rfl, rfl, rfl, rfl, rfl, rfl,
   (Law.stepWhile_steps_iff 7).mpr ⟨by decide, rfl⟩,
   Law.stepWhile_none_iff.mpr (by decide),
   rfl,
   fun _ y le short big =>
     have over : 12 < 3 + y := Nat.lt_of_lt_of_le big (Nat.add_le_add_right le y)
     have three : 3 < y := Naturals.lt_of_add_lt_add_left (k := 3)
       (Nat.lt_trans (by decide : 3 + 3 < 12) over)
     absurd (Nat.lt_of_lt_of_le (short 3 three) le) (by decide : ¬ giving 3 < 3),
   RegimeMargin.short_of_below rfl, Nat.le_refl 7, by decide,
   ⟨rfl, fun _ => rfl⟩⟩

/-- The share the window sets: nothing, whatever the share, the level and the rule in force. -/
def zeroShare (_ : Nat × Nat) (_ : Bool) : Nat := 0

/-- From the way `(3, true, 0)` at the level nine, with the window `[8, 9)` setting the share to
nothing and the rule to `false`, the configuration at step `n + 2` is `((0, false, n + 2), 6)`, for every
`n`: at six, outside the window, the rule read off the share nothing is `false`, and the step under the
use of three leaves six. By induction, as `held_orbit`. Needed by `share_read_goes_on`. -/
private theorem share_held_orbit : ∀ n,
    Law.orbit (pair (windowAfterShare lockShare lockRead zeroShare noRule 8 9)
        (fun w x => RegimeMargin.step giving (lockUse w) x)) ((3, true, 0), 9) (n + 2) =
      ((0, false, n + 2), 6)
  | 0 => rfl
  | n + 1 =>
    congrArg (pair (windowAfterShare lockShare lockRead zeroShare noRule 8 9)
      (fun w x => RegimeMargin.step giving (lockUse w) x)) (share_held_orbit n)

/-- **Read at eight, the share set as well as the rule: the line never ends, and from step 2 on the share
is below three and the rule `false`.** On the lock's own types as in `read_at_eight_ends` (`lockShare`, `lockRead`, `lockUse`,
giving `min z (12 - z)`, a need of one), on the same band `[8, 9)`, the window now setting the share to
nothing (`zeroShare`) as well as the rule to `false` (`noRule`), from the way `(3, true, 0)` at the level
nine. The course is `((3, true, 0), 9)`, `((3, true, 1), 8)`, `((0, false, 2), 6)`, and then
`((0, false, n + 2), 6)` for every `n` (the third conjunct): eight is read and the step from it, still
under the use of five, leaves six; at six, outside the window, the rule is read off the share nothing,
`false`, the use is three and six is left. The line never ends by `locked_turns_in_time_share_iff` at
`Low a := a < 3`, `kept g := g = false`, `H₁ = y₁ = 5`, `H₂ = y₂ = 3`, `hi = 12` and `T = 1` (the
fourth conjunct). From step 2 on the share is below three and the rule `false`, by
`share_corrected_on_course` at the same `T = 1` of the course as it was (the fifth). The start is `Locked`. On this band, with the share
left by `lockShare` where the window reads, `read_at_eight_ends` ends: six is outside the window, the
rule is read off the share three again (`true`) and the use is five again. -/
theorem share_read_goes_on :
    Law.orbit (pair (windowAfterShare lockShare lockRead zeroShare noRule 8 9)
        (fun w x => RegimeMargin.step giving (lockUse w) x)) ((3, true, 0), 9) 1 =
      ((3, true, 1), 8) ∧
    Law.orbit (pair (windowAfterShare lockShare lockRead zeroShare noRule 8 9)
        (fun w x => RegimeMargin.step giving (lockUse w) x)) ((3, true, 0), 9) 2 =
      ((0, false, 2), 6) ∧
    (∀ n, Law.orbit (pair (windowAfterShare lockShare lockRead zeroShare noRule 8 9)
        (fun w x => RegimeMargin.step giving (lockUse w) x)) ((3, true, 0), 9) (n + 2) =
      ((0, false, n + 2), 6)) ∧
    «不穷» (net 1 (windowAfterShare lockShare lockRead zeroShare noRule 8 9)
        (fun w x => RegimeMargin.step giving (lockUse w) x)) «一» ((3, true, 0), 9) ∧
    (∀ k, (Law.orbit (pair (windowAfterShare lockShare lockRead zeroShare noRule 8 9)
          (fun w x => RegimeMargin.step giving (lockUse w) x)) ((3, true, 0), 9) (1 + 1 + k)).1.1 < 3 ∧
      (Law.orbit (pair (windowAfterShare lockShare lockRead zeroShare noRule 8 9)
          (fun w x => RegimeMargin.step giving (lockUse w) x)) ((3, true, 0), 9)
          (1 + 1 + k)).1.2.1 = false) ∧
    RuleCapture.Locked ruleOrder (fun g => g = true) lockRead (3, true) :=
  have sets : ∀ (p : Nat × Nat) (g : Bool), 8 ≤ p.2 → p.2 < 9 →
      zeroShare p g < 3 ∧ noRule p g = false :=
    fun _ _ _ _ => ⟨(by decide : 0 < 3), rfl⟩
  have lowRule : ∀ (a : Nat) (g : Bool), a < 3 → lockRead a g = false :=
    fun _ _ low => decide_eq_false (Nat.not_le_of_gt low)
  have lowStays : ∀ (a : Nat) (g : Bool), a < 3 → g = false → lockShare a g < 3 :=
    fun _ _ low _ => low
  ⟨rfl, rfl, share_held_orbit,
   (locked_turns_in_time_share_iff (P := shareOrder) (M := ruleOrder)
      (favours := fun g => g = true) (fA := lockShare) (hA := lockRead) zeroShare noRule 8 9
      (fun x _ _ => Nat.le_refl x)
      (fun _ _ _ _ le read => decide_eq_true (Nat.le_trans (of_decide_eq_true read) le))
      (fun le f => le f) (Low := fun a => a < 3) (kept := fun g => g = false) sets lowRule lowStays
      (giving := giving) (use := lockUse) (H₁ := 5) (y₁ := 5) (H₂ := 3) (y₂ := 3) (hi := 12)
      (need := 1) (w := (3, true, 0)) (x := 9)
      (fun _ _ k => Eq.subst (motive := fun b => use b = 3) k.symm rfl)
      rfl (RegimeMargin.short_of_below rfl) (RegimeMargin.meets_of_below rfl)
      (RegimeMargin.keeps_of_below rfl) (by decide) (by decide) (RegimeMargin.short_of_below rfl)
      ⟨rfl, fun _ => rfl⟩
      (fun v _ rule => Eq.subst (motive := fun b => 5 ≤ use b) (rule rfl).symm (Nat.le_refl 5))
      (by decide) (by decide)).mpr ⟨1, by decide, by decide, by decide, by decide⟩,
   share_corrected_on_course lockShare lockRead zeroShare noRule 8 9 (Low := fun a => a < 3)
     (kept := fun g => g = false) sets lowRule lowStays
     (fun w x => RegimeMargin.step giving (lockUse w) x) ((3, true, 0), 9) (T := 1) (by decide)
     (by decide),
   ⟨rfl, fun _ => rfl⟩⟩

end Three

end TurningInTime
end Becoming
