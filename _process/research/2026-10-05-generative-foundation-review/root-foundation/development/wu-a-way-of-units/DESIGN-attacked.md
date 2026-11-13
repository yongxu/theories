*AI-written (Fable), 13 November 2026, about 07:22 WIB. A design to be attacked before any Lean is written. Nothing here is proved.*

# Where the marked levels come from: a way of parts

## What is given now

`Becoming.TurningInTime` (on main) has a way `w`, a level `x`, a step `(after w x, left w x)` and a net that has a next only where the level meets a need. Its exact condition, `turns_in_time_iff`, takes these as premises:

- `marked : Nat → Prop` and `AloneOutside marked alone after`: at which levels the level makes a difference to the way;
- `Kept`, `kept`, `turns`: that a way after a marked step is of a kind every step keeps;
- `uses`, `uses₁`: that the kept kind uses `H₂` and the way as it was at least `H₁`.

Its header says so: "the marks are given, not derived". The question: from what would they follow?

## The proposal

One structure, from which all six follow. **A way is the parts present. Each part goes on while the level meets its own need, and takes its own use from the level.**

```
structure Part where need : Nat; use : Nat
after w x := w.filter (fun p => p.need ≤ x)          -- the parts that go on
use w     := sum of p.use over w
left w x  := RegimeMargin.step giving (use w) x      -- every part present at the step uses
net       := Law.stepWhile (fun s => ∃ p ∈ s.1, p.need ≤ s.2) (pair after left)
```

The net has a next while some part goes on. No `marked`, `alone`, `Kept` or outer `need` is given.

## What would be proved (G1 to G7)

**G1. What is present.** A part is present after `n` steps exactly where it was present at the start and the level met its need at every step before `n`.

**G2. The marks, derived.** `after w x = w` exactly where every part present has its need met at `x`. So the level makes a difference to the way exactly where it lies below the need of a part present.

**G3. One step, two endings.** Where `x` is below the need of `p ∈ w` and meets the need of some `q ∈ w`: (i) `(w, x)` still conditions something in the net; (ii) the line under the class "`p` is present" ends there, so it ends while the net goes on (the root's `«亡而网续»`); (iii) in the net of `p` alone, `([p], x)` conditions nothing, so there the line ends where the net ends. The part's own ending where its net ends is the whole's turn.

**G4. Exact, any number of parts.** Every part needing something (`0 < need`), nothing given from nothing, the start level at most `hi`, and for every way `S` the course passes through a level `y S` with `Short`, `Meets` and `Keeps` for `use S`: the line from `(w, x)` never ends exactly where it reaches, the net going on until then, a configuration `(S, z)` with every part of `S` having its need met at `z` and `use S + y S ≤ z`. In words: parts end one after another until what remains holds on what is left, or nothing remains.

**G5. Two parts: `turns_in_time_iff` with nothing given about marks.** For `w = [(m, h), (n, H₂)]` with `n ≤ m`: the step is TurningInTime's pair with `marked := (· < m)`, `alone := id`, `Kept := the first part is absent`; `AloneOutside`, `kept`, `turns`, `uses`, `uses₁` are theorems. So, under the regime premises of `turns_in_time_iff`, the line never ends exactly where at the first level below `m` the lesser need `n` is still met and the level one step later is at or above `H₂ + y₂`.

**G6. Witness.** Giving `min z (12 − z)`, parts `(need m, use 2)` and `(need 1, use 3)`, from nine: as it was 9, 8, 6, 2, 0. With `m = 9` the first part ends at level 8, the next level is 6, and the line never ends. With `m = 8` it ends at level 6, the next level is 2, and the line ends.

**G7. A greater need never ends the line.** Under G5's premises, for `m ≤ m'`: if the line with the first part needing `m` never ends, neither does the line with it needing `m'`. Lowering the need of the part that uses most (shielding it from the level) can only make the turn later.

## What it would let someone see

- The mark is not something a reader adds. It is an ending of the same kind as the whole's, of a part that needs more, coming first.
- TurningInTime's three levels become two needs and a use: the part's need, the whole's need, and the level from which the rest holds.
- `ReadingLoop.Loop.keep` has the same shape: candidates kept are those listed that the answers have not refuted (`Loop.kept_iff`), a `filter` by a test of what is met. A candidate's ending while the formation goes on would be the same turn. Whether that can be stated as one definition with G1 is a question for the readers.
- G7 is the plain form of "do not shield what would end first".

## What it would not show

- Parts only end. Nothing here builds or rebuilds a part (`ReaderRebuilding` does on its own model). How a part that needs more comes to be there is not derived: among lines, G4 and G7 say which go on, and that is all.
- Why a part's use and its need should go together (the part that uses most needing most) is not derived. G5 assumes `n ≤ m` only.
- Nothing about a trained system.

## Questions for the readers

1. Does the package already state G1, G2 or G3, under other names (`Narrowing`, `Keeping`, `ReadingLoop`, `ReaderRebuilding`, `PoolFromCourse`, `ReadingsSpread`, `ReadOffInTime`)?
2. Is any of G1 to G7 false, vacuous, or true of every relation and so saying nothing?
3. Is G5 only `turns_in_time_iff` with a mark chosen and renamed? What makes it a derivation and not a relabelling, if anything?
4. Is "part" the right word against the package's and the chapters' own (`Blanket.Parts`, reader, member, holder, unit, candidate)?
5. Which sentences above say more than G1 to G7 would prove?
