*AI-written (Fable), 13 November 2026. A small design, to be attacked before any Lean. Nothing here is proved.*

# The point of no return on the pair, derived

## What stands apart now

Two places in the package say "in time", and no theorem joins them.

- `Becoming.ReadOffInTime` (section `NoReturn`) defines it for any courses: a course `l` is **recoverable** at step `N` where some feasible course agreeing with `l` up to `N` keeps what is asked (`Recoverable feasible keeps l N`); its **point of no return** is the first step at which it is not (`NoReturnAt`). `feasible` and `keeps` are given. Only one witness ties the point to a level (`FourReaders.recoverable_iff_regime`).
- `Becoming.TurningInTime` proves when a line turns in time on a pair of a way and a level: at the first marked level, the level one step later is at or above `H₂ + y₂` (`turns_in_time_iff`). Its header calls `H₂ + y₂` "the kept kind's point of no return" in words, and says ReadOffInTime's theorems "are not joined".

## The join

On TurningInTime's pair, under `turns_in_time_iff`'s premises, write `X j` for the level of the course as it was at step `j`. Let the feasible courses be the turned ones: `turned T` is `X` up to step `T` and from there the level's course under `H₂` (`RegimeMargin.step giving H₂`) from `X T`. Let a course keep where the need is met at every step. Courses are level histories over one condition (`C := Unit`).

**N1 `recoverable_iff_above`.** `Recoverable feasible keeps X N ↔ H₂ + y₂ ≤ X N`. Premises: nothing given from nothing; `Short`, `Meets`, `Keeps` at `H₂` with `y₂`, `hi`; `0 < need ≤ H₂ + y₂`; the course as it was never rises and starts at most `hi` (from `Short` at `H₁`, uses of at least `H₁` along `alone`'s orbit and the start below `H₁ + y₁`, as in `turns_in_time_iff`).

**N2 `noReturnAt_iff`.** `NoReturnAt feasible keeps X N ↔ X N < H₂ + y₂ ∧ ∀ n, n < N → H₂ + y₂ ≤ X n`: the point of no return of the course as it was is the first step at which its level is below `H₂ + y₂`. Such a step exists under the premises (the course as it was comes below the need).

**N3 `turned_course`.** The feasible courses are the pair's own: with `AloneOutside`, `turns`, `kept`, `uses`, where `T` is the first step at which the level of the course as it was is marked, the need met there and before, the pair's level course is `turned (T + 1)`. (The step at the marked level still takes as it was; the way after it is of the kept kind.)

**N4 `turns_in_time_iff_recoverable`.** Under `turns_in_time_iff`'s premises: the line never ends exactly where there is a first marked step `T` of the course as it was, the need met there and before, with the course as it was recoverable at `T + 1`; so, with `N` its point of no return, exactly where `T + 1 < N`.

## What it would let someone see

- "The point of no return" on the pair stops being a name given in words: it is ReadOffInTime's own definition, and it comes out as a level, `H₂ + y₂`.
- The one step between `T` and `T + 1` is the pace of the way: the level at which the fall first makes a difference, and the level that step leaves, are two levels. ReadOffInTime's `ReadableInTime` asks recoverability at the first step apart, `T`; here it is asked one step later.
- `FourReaders.recoverable_iff_regime` (one witness) and N1 (the pair, any giving under the regime's premises) say the same of their models.

## What it would not show

- `feasible` is the turned courses of this model, not every course there could be. The marks stay given.
- ReadOffInTime's selection side (`FirstApart`, `TellsApartAt`, `ReadableInTime` on a web) is not instantiated: the pair has no web. Whether FourReaders' theorem is an instance of N1 is not shown; its feasible courses are four stops, a subfamily.
- Nothing about a trained system.

## Where it would live

A new last section of `Becoming/TurningInTime.lean` before `Three`, or a small leaf module importing it. TurningInTime already imports ReadOffInTime, until now only for `first_of_decided`.

## Questions for the readers

1. Does the package already prove N1 or N2 under other names (ReadOffInTime, ConditionInTime, Optimum's `reread_kept_iff` and `reread_deadline_iff`, RegimeMargin)? Is N1 an honest instance of `Recoverable` as defined, or does the choice of `feasible` make it empty?
2. Is each of N1 to N4 true as stated? Simulate. Is the step `T + 1` right, or should it be `T`? Which premises are needed for each?
3. Is N4 only `turns_in_time_iff` with its last clause renamed? What is derived that was not?
4. Could FourReaders' witness be made an instance at small cost, and would that be worth a theorem?
5. Which sentences above say more than N1 to N4 would prove?
