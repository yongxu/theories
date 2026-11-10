# K2: the meta-attractor as a dynamic — design (AI-written, Claude Opus 5.5, 10 November 2026)

Route (b)'s round K, piece K2 (board row K2; brief `/Users/ren/tmp/za-how-far/route-b/K-ROUND.md`). Home: 02 §10 (new, after §9 Capture). This is the design read by a cold reader before the Lean.

## The question

J2 (07 §4.12) stated a selection that removes its readers, with persistence as the selection: read off the pool its own course gives, it registers no removal. 02 §9 states capture with its readers fixed by premise: MA2's readers drawn from the selected (`ClosedCapture.Drawn`), the others reading the loss late (`Thinned`), MA3's lever (`RuleShaping`), MA4's critical mass, MA4b's window (`ReadInTime`). AJ's plan §1 says what is missing: "what the rule reads is fixed by the readers' premise, not by the shaping". K2 states the loop in which **what the rule reads is changed by the course the selection makes**: the pool of the rule's readers is read off the course, and the course can remove its readers of what lies beyond the share.

Three questions (the brief): how the pool changes with the course; when the loop closes (a reader of the beyond removed, the lock held); what keeps it open.

## Where it lives

On capture's two-level course (`Pace.paced`; `RuleCapture`, `ClosedCapture`), where 02 §9 already lives. The fast configuration is `A × B`: the share `A` (what the share's selection and the share-readers read) and the beyond `B` (a loss, a habitat drawn on). The rule `R`. No new notion of line: the readers of the beyond are a predicate on the configuration, `present : A × B → Prop` (some reader of what lies beyond the share is in the pool there). K1's lines carrying readings, once fixed, can supply it (a reading's share positive), and K1's variation at descent is a readmission (below).

## Definitions

- `ReadsThroughPresent present hA h` — where no reader of the beyond is present, the rule read is the share-readers' rule read off the share alone: `∀ p g, ¬ present p → h p g = hA p.1 g`.
- `NotReadmitted present f` — the selection does not bring a reader of the beyond back once none is present: `∀ p g, ¬ present p → ¬ present (f p g)`. (PoolCourse's `RecruitsThrough` read on presence: a pool comes to read what it does not yet read only through an admission not made through it.)
- `windowRead hA hL N K` (the beyond a loss `B = Nat`): readers of the loss read it as `hL` while the loss lies in `[N, K)` and the rule is read as `hA` off the share elsewhere: before `N` they have not read it, from `K` they are gone, their continuation hanging on what the loss takes. `present p := p.2 < K`.
- `bear onShapers onOthers g` (counts): the rule in force with a loss borne, written as MA3 writes a cost and a return: what the loss takes from the shapers (carriers) is added to the others' count, what it takes from the others to the shapers'. `borneStep onShapers onOthers (x, b) g := (select x (bear (onShapers b) (onOthers b) g), b + 1)`.

## Laws (all near-definitional compositions; the new part is the statement)

**A. What a pool read off the course registers (any type).**

- A1. At a configuration with no reader of the beyond present, the rule read is the share-readers'; two such configurations alike in share give the same rule read whatever lies beyond (`ReadsThroughPresent`, definitional).
- A2. *The exits from a lock, exactly.* A configuration locked under the share-readers' rule (`RuleCapture.Locked M favours hA`) stays locked along any stretch of the course at whose reading steps the rule read is the share-readers' (in particular: no reader of the beyond present) and at whose steps the share does not fall; neither share nor rule ends below where they were. Proof: RuleCapture's one-step lock law `turn_locked`, applied at the two shares a step joins (a two-point share order pulled back from `P`), by induction. Read contrapositively: **a lock is left only at a reading step whose rule read differs from the share-readers' (a reader of the beyond present and reading otherwise), or at a step at which the share falls under the rule in force** (the loss entering the share against those the rule favours), or by a change of law. `ClosedCapture.lock_outlives_loss` is the case with no reader ever present and a share selection not reading the beyond.
- A3. *The loop closed.* With `NotReadmitted` and the joint selection raising the share under a favouring rule (`Raises` on `A × B`: the loss, if it enters the share, falls only on those the rule disfavours), from a locked step with no reader present: no reader is present, the course is locked and neither share nor rule falls at every later step. With `B = Nat` and the loss accruing, it passes every bound.

**B. The race: readers removed by the loss they read (`windowRead`, `B = Nat`, `Accrues`).**

- B1. Where `K ≤ N` (the loss removes its readers before they read it), `windowRead hA hL N K = joinRead hA` at every configuration, whatever `hL`: the course is closed capture's, and from a locked start it is locked at every step while the loss passes every bound (`ClosedCapture.lock_outlives_loss`, by identity of the readings).
- B2. Past `K` the course is the share's own loop from the configuration it has reached (`ClosedCapture.course_past` with `join_course`), whatever the removed readers read (two `hL` give one course past `K`). So a reading of the loss that turned the rule in force while its readers stood holds past their removal only as RuleCapture's laws hold from the configuration at the removal: locked one way, locked the other, or alternating (`RuleCapture.Alternating`).
- B3. `K` unbounded is the case where the readers' presence does not hang on the loss: then `windowRead` reads `hL` from `N` on, as `Thinned.lossPool` does past its bound (Thinned's laws apply; nothing new stated).

**C. On whom the loss falls (counts; MA3's convention).**

- C1. `bear λ 0 (shaped a s p c) = shaped a s p (c + λ)` and `bear 0 λ (shaped a s p c) = shaped a (s + λ) p c`. So, by `RuleShaping.favours_iff`, the rule after shaping with the loss borne by the shapers favours them exactly where `c + λ ≤ s`; borne by the others, exactly where `c ≤ s + λ`.
- C2. With the loss borne by the others only (`onShapers = 0`), the joint selection raises the share under every favouring rule (`Raises` on `CarrierCounts × Nat`), so A3 applies: the lock outlives the loss with no reader of it in the pool. A loss entering the share does not by itself open the loop: falling on those the rule disfavours, it enters in the lock's direction. (Refines T7's list of ways out, "a loss entering it".)
- C3. With the loss borne by the shapers, at a step where the rule in force with the loss borne strictly disfavours them (`g.carrier < g.other + onShapers b`), the shapers' share falls strictly (`RuleShaping.falls_strictly`): exit (b) of A2, with no reader of the beyond.

**Witnesses (computed).**

- `Window`: carriers two to one under `hi` (4:1), the share-readers' rule the threshold reading `threshold hi lo`, read at every step, the loss one a step from zero, the readers of the loss reading `lo` from `N = 0` until removed at `K`. `K = 0`: never read, locked at every step (B1). `K = 1`: the rule in force is `lo` at step 1, and the course is locked in the carriers' favour again from step 2 for good (the turn undone). `K = 2`: from step 2 the rule alternates and is locked neither way (as `RuleCapture.Alternating`). `K = 3`: locked the other way from step 4 for good. Same readers, same reading, same loss: the window's length alone decides.
- `Borne`: same start, the share-readers' threshold reading, no reader of the beyond at any step; the loss borne by the carriers at `4b` (added to the others' count) turns the rule in force against them at a computed step; borne by the others, the course is locked at every step (C2).
- Exit (a) with a pool independent of the course: `ClosedCapture.Beyond.open_turned` (existing).

## What registers a removal: J2's three candidates placed

1. *A pool independent of the course*: a reader of the beyond present at every configuration, its weight not read off the course: `ClosedCapture.turned_by_loss` — the loss past its bound turns the course whatever the share.
2. *A removal returning to the selecting line's own continuation*: exit (b), the loss borne by those the rule favours (C3; MA3's lever with the loss added to the cost, C1).
3. *A reader whose continuation does not hang on its reading*: B3; if its weight is read off the share (drawn from the selected), Thinned's counts at the reading decide (`Thinned.kept_iff`, `turned_iff`; MA4b's window).
4. Added: *readmission*, an admission not made through the pool (`NotReadmitted` fails; PoolCourse's exit; K1's variation at descent).

So three regimes of who reads the beyond, on one axis — weight fixed (1), weight read off the share (3), weight read off the loss itself (K2's new case) — and one exit through the share (2).

## Which law, which dynamics

- Case of: RuleCapture's one-step lock law (`turn_locked`), read on the configuration with the pool's presence as a coordinate; past the removal, closed capture's law of what the loop does not read (`join_course`, `course_past`; ultimately `Law.part_identifiesAlike_iff_step`).
- Joins: capture (02 §9: RuleCapture, ClosedCapture, Thinned, ReadInTime, RuleShaping); the drain beyond couplings (ZB's bound: the loss lies beyond the shapers' coupling closure, and here it reaches the readers who would couple it into the rule); persisting's filter and instrumental convergence's self-preservation half (07 §4.9: the lock as the rule's line kept, its readers of the beyond not kept); J2's selection removing its readers (now with selection by share); PoolCourse (admission).

## Not shown

That actual pools are read off courses so; that readers of the beyond are removed by what they read; the readers' own lines (J2 models lines; here removal is the reading leaving the pool); how fast a loss grows; noise; an optimizer shaping its own rule (AJ's plan: "no law here states that join"); any ranking of a closed or an open loop.


## Kept failures

- **The clock design (this note above, first version).** The readers of the loss were removed at a bound `K` of a loss that grew one a step whatever the selection did, and the witness was a family over `K` (`K = 0` kept, `1` undone, `2` alternating, `3` turned). Fable's cold reading (10 November 2026, finding 1, high): the readers are then removed by the step count, not by anything the selection does, so the loop the brief asks for is not shown; AJ's gap is moved to `K`, not filled. Replaced by a loss drawn off the course (below). The clock family is not built.
- **A2 worded as "the exits, exactly"** (Fable, finding 2, high): the contrapositive gives necessity somewhere in a stretch, not the step of leaving, and `Borne` shows the fall and the leaving four steps apart. Now: "a lock is left only along a stretch containing …".
- **B3 "K unbounded"** is not a value of `K`; the never-removed case is `Thinned.lossPool`, now tied by a lemma (`window_standing_thinned`), not by a value.

## Revision after the first cold reading (Fable, 10 November 2026)

Findings taken: 1 (endogenous drain), 2 (A2's wording), 3 (K = 3's step), 6 (the pooled window: `windowRead` is generic, and `window_standing_thinned` shows that with MA2's pools it is `Thinned.lossPool` while the readers stand), 7 (A3 renamed "closed, it stays closed", premises listed), 8 (a law reading toward the selection favouring the removal: `window_order_kept`), 9 (the `Borne` steps stated), 10 (`NotReadmitted` is an analogue of PoolCourse's admission, a separate premise; "refines T7" reworded; no trichotomy claimed), 11 (presence drops how many and which lines; said). Finding 4 (generalize `Alternating`) is moot: the clock family is not built. Finding 5 (A2's proof route): kept as designed, with the reason. `turn_locked` is applied with `S := Bool` and the share order pulled back along `false ↦ x`, `true ↦ y`; its `Raises` premise then quantifies over the two points only and holds by the step's own `P.le x y`, and its `ReadsShare` premise is `hA`'s, which is monotone everywhere by hypothesis; the actual reading `h` enters only through its agreement with `hA` at the step. So `turn_locked` stays the reason for the one-step law and RuleCapture is not edited.

The revised model:

- **The loss drawn by the course** (`fB (x, b) g`, `Accrues`): in the witness one a step and forty more at a step at which the shapers outnumber the others sixteen to one, so a strong lock draws more on the beyond.
- **The loop law** (`window_order_kept`): with the readers reading the loss from when they stand (`N = 0`), never more favourably than the share-readers, the selection, the share-readers' reading and the drain monotone, two courses keep their order in share, loss and rule, with the readers' bound reversed. By `RuleCapture.order_kept` on the configuration with the bound carried (`withBound`, `boundRead`, `boundOrder`, `bound_course`). So the higher the share, the more is drawn and the sooner the readers are gone; the sooner they are gone, the higher the share.
- **The witness** (`Drained`): the same readers (reading `lo` while the loss is below 4), the same start eight to one: under the loss one a step the course is turned for good from step 4; under the drain the readers are drawn out after two readings and the lock returns for good from step 3. From two to one, never sixteen to one, the drained course is turned for good from step 4. The course from eight to one is at no step below the one from two to one (the loop law).
- `Borne`: borne by the carriers at four a unit, the share falls from step 1 while the rule in force favours them (the bear-rule `⟨4, 5⟩` strictly disfavours them), the threshold reading reads `lo` at step 4 and it is in force at step 5; borne by the others, locked at every step.
