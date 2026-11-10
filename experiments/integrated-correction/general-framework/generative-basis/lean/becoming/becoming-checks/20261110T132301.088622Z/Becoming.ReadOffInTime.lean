import Becoming.BeyondCoupling
import Becoming.ConditionInTime
import Becoming.Propagation
import Becoming.RegimeMargin

/-!
# ReadOffInTime: when a selection read off continuation reads a loss (读于不返之前)

Route (b)'s round K, piece K3 (Ren, 9 November 2026: "ok - 这一类请平行化认真完成，非常重要",
`sources/15-codex-theory-conversations/2026-11-09-route-b-ethics-forms.md`; 10 November: the
dynamics to be made "connected, mapped, and 'unified'"). `Becoming.BeyondCoupling` reads selection
off continuation over the whole run, and its second stated limit is that reading in time is not
stated. Generative alignment's second condition asks for a reading of what lies beyond the share
before the loss passes its point of no return, and MA2's timing law (`ClosedCapture.Thinned`) and
MA4b (`Becoming.ReadInTime`) take the step at which the others read the loss as supplied. This
module says when a difference reaches a selection read off continuation, what a loss's point of no
return is on the same courses, and when the one comes before the other. It joins dynamics already
on the map: J3's relation in time (`Becoming.ConditionInTime`), TimedResponse's potential route and
deadline law (`Becoming.TimedResponse`, `Becoming.Latency`), the coupling and margin of
`Becoming.Propagation` and 02 §5, and the regime's exact point (`RegimeMargin.ends_iff_below`).

* **When a selection read off continuation can first read** (near-definitional). A selection read
  off a group's continuations up to a step is one through its couplings by threshold only up to
  that step (`Web.SelectsThroughAll thresholdOnly`, `Web.alikeThroughAll_thresholdOnly_iff`); Bound's
  `Web.ReadOffContinuations` is its whole-run form, not stated here. The first step apart of two
  courses is the step at which some member is first admitted under one and not the other
  (`Web.FirstApart`). Before it no such selection, read up to an earlier step, tells them apart
  (`Web.FirstApart.alike_before`); at it one does (`Web.FirstApart.separates`); it is one step
  (`Web.FirstApart.unique`), and it exists where admission alike is decided at each step and fails
  at some (`Web.firstApart_of_apart`, by `first_of_decided`). So it is the earliest any selection
  read off the group's continuations can tell the courses apart, not the step at which a given one
  does: a family of selections, one for each step, tells them apart at its own first step
  (`Web.TellsApartAt`), never earlier than the first step apart (`Web.TellsApartAt.not_before`).
* **The route is the relation in time** (substantive, short). J3's affecting before
  (`Flow.AffectsBefore`), with coupling by level added (`Flow.AffectsBeforeBy`; by threshold only
  it is J3's, `Flow.affectsBeforeBy_thresholdOnly`) and read through either of two courses
  (`Flow.AffectsBeforeEither`, `Flow.StepInTimeEither`, `Flow.WithinTimeEither`; through one
  course by threshold only, J3's `Flow.StepInTime` and `Flow.WithinTime`:
  `Flow.stepInTimeEither_self`, `Flow.withinTimeEither_self`). A source's closure in time meets a
  formation by a step where an occurrence within the closure in time of a source occurrence affects
  the formation's occurrence at a step up to it (`Flow.ReachedInTime`). Whatever TimedResponse's
  potential route has carried into a condition by a step was carried by an exchange, earlier, of
  an occurrence within the closure in time of a source occurrence (`TimedResponse.Spread.withinTime`),
  so what a route has reached, the closure in time has met (`TimedResponse.ReachedBy.reachedInTime`);
  where the source goes on from step to step, the converse holds
  (`TimedResponse.reachedBy_of_reachedInTime`), so the two dated relations are one
  (`TimedResponse.reachedBy_iff_reachedInTime`; in one course by threshold only, in J3's terms,
  `TimedResponse.reachedBy_self_iff`). The presence premise covers only the steps before the
  deadline. Forgetting the steps, the closure in time lies within the coupling closure drawn
  through both courses, the closure of Bound's law (`Flow.WithinTimeEither.coupled`,
  `Flow.ReachedInTime.withinCoupling`).
* **The reading not before the route** (composition with TimedResponse's deadline law). Under that
  law's premises up to `D` (balance, the same formations present, a common start, every formation
  other than a source exchanging alike wherever it is alike through its couplings, by the
  responders' coupling `obs`), where the closure in time of no source occurrence meets a member by
  `D`, every selection read off the group's continuations up to `D` selects the two courses alike
  (`Web.selectsAlike_unreached`); so at the first step apart it is not the case that the closure
  meets no member (`Web.FirstApart.not_unreached`). Bound's law reads the same blindness over the
  whole run. The listener of `FourReaders` attains the bound; Latency's `Relay` is the same shape on a
  reader's answer.
* **How strongly: the gap against the margin** (arithmetic). Where one course admits a member, the
  other does wherever, on every condition the member then requires, the gap between the two levels
  is within the member's margin under the first, its level less its need
  (`Web.admits_of_gap_within_margin`); where the loss leaves each such condition no higher, exactly
  (`Web.admits_iff_gap_within_margin`). 02 §5's margin is this distance read under the withheld
  levels. So a difference that has arrived is read off a member's continuation only once its gap
  crosses the member's margin. Composed with `Propagation.gap_le_carried`, which bounds each gap by
  what the strengths carry, it would not be read while the carried amount stays within the margins;
  that composition is not written here (`Web.too_late_within_margin` takes the gaps as a premise). The route says when a difference can arrive at all, the margin
  when what arrives is read.
* **The point of no return, on courses** (near-definitional). A course is recoverable at a step
  where some course among the feasible ones, agreeing with it at every step up to then
  (`AgreeUpTo`), keeps what is asked (`Recoverable`); the feasible courses are a premise, read as
  the courses the part can still take. Recoverability is down-closed (`Recoverable.earlier`). The
  point of no return is the first step at which a course is not recoverable (`NoReturnAt`): before
  it and only before it the course is recoverable (`NoReturnAt.recoverable_iff`), it is one step
  (`NoReturnAt.unique`), it exists where recoverability is decided at each step and fails at some
  (`noReturnAt_of_past`), and, where it is not step 0, at the step before it the courses part, a
  feasible course agreeing so far keeping and every feasible one agreeing up to the point losing
  (`NoReturnAt.parts`): 02 §2's juncture
  read on courses, not `Branching.Juncture`, which is stated on a process.
* **Read in time** (near-definitional, and compositions). Readable in time: the first step apart
  comes at a step at which the losing course is still recoverable (`Web.ReadableInTime`); a family
  of selections reads in time where it tells the courses apart at such a step (`Web.ReadsInTime`),
  and, read off the continuations at every step and a first step apart being given, they are then
  readable in time (`Web.ReadsInTime.readable`). Readable in time exactly where
  the first step apart comes before the point of no return (`Web.readableInTime_iff`). Too late,
  for the earliest reading and for every family read off the group's continuations: where every
  member is admitted alike at every step up to a step at which the losing course is past return
  (`Web.too_late_of_alike`); where, under the deadline premises, the closure in time meets no
  member by then (`Web.too_late_of_unreached`); where the other course admits every member and every gap stays
  within the members' margins until then (`Web.too_late_within_margin`); and where the group reads
  only what is lost, what is kept including every member's admission at every step and the other
  course admitting every member throughout, the loss is read only once it has happened, past its
  point (`Web.too_late_of_own`).
* **Witnesses: four readers of one loss** (`FourReaders`). A habitat of 4 is a regime of 02 §5: a
  dweller draws one unit a step while it stands at 1 or above, and a renewer gives one while the
  habitat stands at 2 or above. A clearer draws one more a step and can stop at any step (four courses, each
  balanced: `FourReaders.balances`). Once the clearer stops, the habitat follows the regime's step
  under the dweller's draw (`FourReaders.stopped_is_regime`), whose point is exact at 2
  (`FourReaders.regime_point`, `RegimeMargin.ends_iff_below`). The cleared course is recoverable,
  some course agreeing so far keeping the dweller, exactly while its level is at the regime's point
  or above (`FourReaders.recoverable_iff_regime`), so its point of no return is step 3
  (`FourReaders.noReturn`), while the dweller still stands at step 3 and ends at step 4. Against the
  course that spares the habitat, a gauge needing the habitat at 3 is first apart at step 2, before
  the point: readable in time (`FourReaders.near_inTime`); a gauge needing it at 2 at step 3, at
  the point: not readable in time, while the dweller still stands (`FourReaders.mid_atThePoint`); the dweller's own continuation at step 4,
  past it: coupling the dweller in, as Bound's blindness lifts, reads its loss too late
  (`FourReaders.dweller_late`). A listener at the end of two relays is met by the closure in time at
  step 3 and not by step 2 (`FourReaders.listener_reached`, `FourReaders.listener_not_reached`),
  and is first apart at step 3, at the point (`FourReaders.listener_late`). The relays and the
  listener each stand exactly at their need under the spared course (by `need` and `levels`, not a
  stated theorem), so with no margin; read so, its first step apart comes when the route arrives.

Premises: the courses, the feasible ones and what is kept are supplied; every law names its
premises. In the witness the feasible courses are the clearer's four stopping courses, supplied as
flows, not generated by a stated law of exchange; the dweller, renewer and relays exchange by what
their levels then stand at. Which way a reading turns a course is not stated: a selection that
tells the courses apart in time can select for the loss as well as against it (`Clearing.read_not_
direction`). Readings, not proved: MA2's and MA4b's reading step is here the first step apart of a
selection read off the others' continuations, and MA4b's deadline bounds what is here the point of
no return; their models differ from this one. No ethical premise, and no Lean axiom is used.
-/

namespace Becoming

variable {F C : Type}

/-! ## When a selection read off continuation can first read -/

namespace Web

variable (W : Web F C)

/-- **The first step apart**: the step at which some member of the group is first admitted under one
course and not the other. -/
def FirstApart (group : F → Prop) (l l' : Nat → C → Nat) (T : Nat) : Prop :=
  (∃ g, group g ∧ ¬ (W.Admits (l T) T g ↔ W.Admits (l' T) T g)) ∧
    ∀ g, group g → ∀ t, t < T → (W.Admits (l t) t g ↔ W.Admits (l' t) t g)

/-- **A family of selections tells two courses apart at a step**: the one for that step selects
them differently, and the one for every earlier step alike. -/
def TellsApartAt (sel : Nat → (Nat → C → Nat) → Prop) (l l' : Nat → C → Nat) (T : Nat) : Prop :=
  ¬ (sel T l ↔ sel T l') ∧ ∀ s, s < T → (sel s l ↔ sel s l')

variable {W} {group : F → Prop} {l l' : Nat → C → Nat} {T : Nat}
  {select : (Nat → C → Nat) → Prop}

/-- **Alike through a group's couplings by threshold only is alike in its continuations**: every
member admitted alike at every step up to `T`. -/
theorem alikeThroughAll_thresholdOnly_iff :
    W.AlikeThroughAll thresholdOnly group l l' T ↔
      ∀ g, group g → ∀ t, t ≤ T → (W.Admits (l t) t g ↔ W.Admits (l' t) t g) :=
  ⟨fun alike g member t le => (alike g member t le).1,
   fun same g member t le => ⟨same g member t le, fun _ no => False.elim no⟩⟩

/-- **Before the first step apart, nothing read off the continuations up to an earlier step tells
the courses apart.** -/
theorem FirstApart.alike_before (first : W.FirstApart group l l' T) {s : Nat} (before : s < T)
    (reads : W.SelectsThroughAll thresholdOnly group s select) : select l ↔ select l' :=
  reads l l' (alikeThroughAll_thresholdOnly_iff.mpr fun g member t le =>
    first.2 g member t (Nat.lt_of_le_of_lt le before))

/-- **At the first step apart, a selection read off the continuations up to it tells the courses
apart.** -/
theorem FirstApart.separates (first : W.FirstApart group l l' T) :
    ∃ select, W.SelectsThroughAll thresholdOnly group T select ∧ select l ∧ ¬ select l' :=
  separates_all fun alike => match first.1 with
    | ⟨g, member, differ⟩ => differ (alikeThroughAll_thresholdOnly_iff.mp alike g member T
        (Nat.le_refl T))

/-- The first step apart is one step. -/
theorem FirstApart.unique {T' : Nat} (first : W.FirstApart group l l' T)
    (first' : W.FirstApart group l l' T') : T = T' :=
  match Nat.lt_or_ge T T' with
  | .inl lt => match first.1 with
    | ⟨g, member, differ⟩ => absurd (first'.2 g member T lt) differ
  | .inr ge => match Nat.lt_or_eq_of_le ge with
    | .inl lt => match first'.1 with
      | ⟨g, member, differ⟩ => absurd (first.2 g member T' lt) differ
    | .inr same => same.symm

/-- **No family read off the continuations tells the courses apart before the first step apart.** -/
theorem TellsApartAt.not_before {sel : Nat → (Nat → C → Nat) → Prop} {T₀ : Nat}
    (reads : ∀ s, W.SelectsThroughAll thresholdOnly group s (sel s))
    (first : W.FirstApart group l l' T₀) (tells : TellsApartAt sel l l' T) : T₀ ≤ T :=
  match Nat.lt_or_ge T T₀ with
  | .inl lt => absurd (first.alike_before lt (reads T)) tells.1
  | .inr ge => ge

end Web

/-- **A first failing step, where each step is decided.** Where at every step `P` or `Q` holds,
by any step either `P` holds throughout, or some step by then has `Q` with `P` at every step before
it. -/
theorem first_of_decided {P Q : Nat → Prop} (decided : ∀ t, P t ∨ Q t) :
    ∀ n, (∀ t, t ≤ n → P t) ∨ ∃ m, m ≤ n ∧ Q m ∧ ∀ t, t < m → P t
  | 0 => match decided 0 with
    | .inl holds => .inl fun t le => match t, le with
      | 0, _ => holds
      | _ + 1, le => absurd le (Nat.not_succ_le_zero _)
    | .inr fails => .inr ⟨0, Nat.le_refl 0, fails, fun _ lt => absurd lt (Nat.not_lt_zero _)⟩
  | n + 1 => match first_of_decided decided n with
    | .inr ⟨m, le, fails, before⟩ => .inr ⟨m, Nat.le_succ_of_le le, fails, before⟩
    | .inl all => match decided (n + 1) with
      | .inl holds => .inl fun t le => match Nat.lt_or_eq_of_le le with
        | .inl lt => all t (Nat.le_of_lt_succ lt)
        | .inr same => Eq.subst (motive := P) same.symm holds
      | .inr fails => .inr ⟨n + 1, Nat.le_refl _, fails,
          fun t lt => all t (Nat.le_of_lt_succ lt)⟩

namespace Web

variable {W : Web F C} {group : F → Prop} {l l' : Nat → C → Nat}

/-- **The first step apart exists where admission alike is decided at each step.** Where at every
step every member is admitted alike or some member is not, and some member is admitted differently
at `n`, a first step apart comes at or before `n`. -/
theorem firstApart_of_apart
    (decided : ∀ t, (∀ g, group g → (W.Admits (l t) t g ↔ W.Admits (l' t) t g)) ∨
      ∃ g, group g ∧ ¬ (W.Admits (l t) t g ↔ W.Admits (l' t) t g))
    {n : Nat} {g : F} (member : group g) (differ : ¬ (W.Admits (l n) n g ↔ W.Admits (l' n) n g)) :
    ∃ T, T ≤ n ∧ W.FirstApart group l l' T :=
  match first_of_decided decided n with
  | .inl all => absurd (all n (Nat.le_refl n) g member) differ
  | .inr ⟨m, le, apart, before⟩ => ⟨m, le, apart, fun g member t lt => before t lt g member⟩

end Web

/-! ## The route is the relation in time -/

namespace Flow

/-- **Affecting before, with coupling by level** (J3's `Flow.AffectsBefore` with `obs` added):
`(s, h)` affects `(t, g)` where `s < t` and, taking part at `s`, `h` exchanges with a condition
coupled into `g` at `t`, by what `g` then requires or by level. -/
def AffectsBeforeBy (L : Flow F C) (W : Web F C) (obs : F → C → Prop) (x y : Nat × F) : Prop :=
  x.1 < y.1 ∧ ∃ c, TimedResponse.CoupledIntoAt W obs y.2 y.1 c ∧ x.2 ∈ L.present x.1 ∧
    (0 < L.take x.1 x.2 c ∨ 0 < L.give x.1 x.2 c)

/-- Affecting before, read through either of two courses. -/
def AffectsBeforeEither (L L' : Flow F C) (W : Web F C) (obs : F → C → Prop) (x y : Nat × F) :
    Prop :=
  L.AffectsBeforeBy W obs x y ∨ L'.AffectsBeforeBy W obs x y

/-- **A step in time read through either of two courses**: a formation goes on to its next step,
or an occurrence affects a later one in either course. -/
def StepInTimeEither (L L' : Flow F C) (W : Web F C) (obs : F → C → Prop) (x y : Nat × F) :
    Prop :=
  (y.1 = x.1 + 1 ∧ y.2 = x.2) ∨ AffectsBeforeEither L L' W obs x y

/-- `y` lies within `x`'s closure in time, read through either course. -/
def WithinTimeEither (L L' : Flow F C) (W : Web F C) (obs : F → C → Prop) (x y : Nat × F) :
    Prop :=
  WithinClosure (StepInTimeEither L L' W obs) x y

/-- **The closure in time of a source meets `g` by `T`**: an occurrence within the closure in
time of a source occurrence affects `g`'s occurrence at a step up to `T`. -/
def ReachedInTime (L L' : Flow F C) (W : Web F C) (obs : F → C → Prop)
    (source : Nat → F → Prop) (g : F) (T : Nat) : Prop :=
  ∃ x z u, source x.1 x.2 ∧ WithinTimeEither L L' W obs x z ∧
    AffectsBeforeEither L L' W obs z (u, g) ∧ u ≤ T

variable {L L' : Flow F C} {W : Web F C} {obs : F → C → Prop} {source : Nat → F → Prop}

/-- By threshold only, affecting before is J3's. -/
theorem affectsBeforeBy_thresholdOnly {x y : Nat × F} :
    L.AffectsBeforeBy W thresholdOnly x y ↔ L.AffectsBefore W x y :=
  ⟨fun ⟨before, c, coupled, present, exchanges⟩ =>
     ⟨before, c, coupled.elim id fun no => False.elim no, present, exchanges⟩,
   fun ⟨before, c, requires, present, exchanges⟩ => ⟨before, c, .inl requires, present, exchanges⟩⟩

/-- **Through one course, by threshold only, the step in time is J3's.** -/
theorem stepInTimeEither_self {x y : Nat × F} :
    StepInTimeEither L L W thresholdOnly x y ↔ L.StepInTime W x y :=
  ⟨fun step => match step with
     | .inl next => .inl next
     | .inr (.inl affects) => .inr (affectsBeforeBy_thresholdOnly.mp affects)
     | .inr (.inr affects) => .inr (affectsBeforeBy_thresholdOnly.mp affects),
   fun step => match step with
     | .inl next => .inl next
     | .inr affects => .inr (.inl (affectsBeforeBy_thresholdOnly.mpr affects))⟩

/-- **Through one course, by threshold only, the closure in time is J3's** (`Flow.WithinTime`). -/
theorem withinTimeEither_self {x y : Nat × F} :
    WithinTimeEither L L W thresholdOnly x y ↔ L.WithinTime W x y :=
  ⟨WithinClosure.mono fun _ _ step => stepInTimeEither_self.mp step,
   WithinClosure.mono fun _ _ step => stepInTimeEither_self.mpr step⟩

/-- A formation's continuation from a step lies within its closure in time at every later step. -/
theorem withinTimeEither_onward (u : Nat) (g : F) :
    ∀ k, WithinTimeEither L L' W obs (u, g) (u + k, g)
  | 0 => WithinClosure.refl _
  | k + 1 => WithinClosure.trans (withinTimeEither_onward u g k)
      (WithinClosure.of_rel (.inl ⟨rfl, rfl⟩))

/-- What is reached in time stays reached at every later step. -/
theorem WithinTimeEither.later {x : Nat × F} {u u' : Nat} {g : F}
    (within : WithinTimeEither L L' W obs x (u, g)) (le : u ≤ u') :
    WithinTimeEither L L' W obs x (u', g) :=
  match Nat.le.dest le with
  | ⟨k, at_⟩ => Eq.subst (motive := fun r => WithinTimeEither L L' W obs x (r, g)) at_
      (WithinClosure.trans within (withinTimeEither_onward u g k))

/-- Affecting before, read through either course, is being affected through what couples in,
drawn through either course, read backward. -/
theorem AffectsBeforeEither.coupledFrom {x y : Nat × F}
    (affects : AffectsBeforeEither L L' W obs x y) : L.CoupledFromEither W L' obs y.2 x.2 :=
  match affects with
  | .inl ⟨_, c, coupled, mem, exchanges⟩ =>
    .inl ⟨c, coupled.elim (fun requires => .inl ⟨y.1, requires⟩) .inr, x.1, mem, exchanges⟩
  | .inr ⟨_, c, coupled, mem, exchanges⟩ =>
    .inr ⟨c, coupled.elim (fun requires => .inl ⟨y.1, requires⟩) .inr, x.1, mem, exchanges⟩

/-- **Forgetting the steps, the closure in time lies within the coupling closure** drawn through
both courses, read backward: what can carry a difference to `y` in time lies within `y`'s
coupling closure, the closure of Bound's law. -/
theorem WithinTimeEither.coupled {x y : Nat × F} (within : WithinTimeEither L L' W obs x y) :
    WithinClosure (L.CoupledFromEither W L' obs) y.2 x.2 :=
  within (fun z => WithinClosure (L.CoupledFromEither W L' obs) z.2 x.2)
    (fun _ _ inside step => match step with
      | .inl ⟨_, same⟩ => Eq.subst (motive := fun h => WithinClosure (L.CoupledFromEither W L' obs)
          h x.2) same.symm inside
      | .inr affects => WithinClosure.trans (WithinClosure.of_rel affects.coupledFrom) inside)
    (WithinClosure.refl _)

/-- **What the closure in time meets has a source within its coupling closure.** -/
theorem ReachedInTime.withinCoupling {g : F} {T : Nat}
    (reached : ReachedInTime L L' W obs source g T) :
    ∃ x : Nat × F, source x.1 x.2 ∧ WithinClosure (L.CoupledFromEither W L' obs) g x.2 :=
  match reached with
  | ⟨x, _, _, src, within, affects, _⟩ =>
    ⟨x, src, WithinClosure.trans (WithinClosure.of_rel affects.coupledFrom) within.coupled⟩

/-- An exchange at `s` with a condition coupled into `g` at a later `u` is affecting before, read
through either course, where the two courses have the same formations present at `s`. -/
theorem affectsBeforeEither_of_touches {s u : Nat} {h g : F} {d : C}
    (present : L.present s = L'.present s) (before : s < u)
    (coupled : TimedResponse.CoupledIntoAt W obs g u d)
    (touch : TimedResponse.TouchesAt L L' s h d) : AffectsBeforeEither L L' W obs (s, h) (u, g) :=
  have there : h ∈ L'.present s := Eq.subst (motive := fun as => h ∈ as) present touch.1
  match touch.2 with
  | .inl pos => .inl ⟨before, d, coupled, touch.1, .inl pos⟩
  | .inr (.inl pos) => .inl ⟨before, d, coupled, touch.1, .inr pos⟩
  | .inr (.inr (.inl pos)) => .inr ⟨before, d, coupled, there, .inl pos⟩
  | .inr (.inr (.inr pos)) => .inr ⟨before, d, coupled, there, .inr pos⟩

/-- Affecting before, read through either course, is an exchange touching a condition coupled into
the later occurrence, where the two courses have the same formations present at the earlier
step. -/
theorem AffectsBeforeEither.touches {x y : Nat × F} (present : L.present x.1 = L'.present x.1)
    (affects : AffectsBeforeEither L L' W obs x y) :
    ∃ c, x.1 < y.1 ∧ TimedResponse.CoupledIntoAt W obs y.2 y.1 c ∧
      TimedResponse.TouchesAt L L' x.1 x.2 c :=
  match affects with
  | .inl ⟨before, c, coupled, mem, exchanges⟩ => ⟨c, before, coupled, mem, match exchanges with
      | .inl pos => .inl pos
      | .inr pos => .inr (.inl pos)⟩
  | .inr ⟨before, c, coupled, mem, exchanges⟩ =>
    ⟨c, before, coupled, Eq.subst (motive := fun as => x.2 ∈ as) present.symm mem,
     match exchanges with
     | .inl pos => .inr (.inr (.inl pos))
     | .inr pos => .inr (.inr (.inr pos))⟩

end Flow

namespace TimedResponse

variable {L L' : Flow F C} {W : Web F C} {obs : F → C → Prop} {source : Nat → F → Prop}

/-- A route that has reached a condition by a step reaches it at every later step. -/
theorem Spread.onward {a : Nat} {c : C} (spread : Spread L L' W obs source a c) :
    ∀ k, Spread L L' W obs source (a + k) c
  | 0 => spread
  | k + 1 => .hold (Spread.onward spread k)

/-- A route that has reached a condition by a step reaches it at every later step. -/
theorem Spread.later {a b : Nat} {c : C} (spread : Spread L L' W obs source a c) (le : a ≤ b) :
    Spread L L' W obs source b c :=
  match Nat.le.dest le with
  | ⟨k, at_⟩ => Eq.subst (motive := fun r => Spread L L' W obs source r c) at_ (spread.onward k)

/-- **A potential route lies on the relation in time.** Where the two courses have the same
formations present before `t`, whatever a route has carried into a condition by `t` was carried
there by an exchange, at an earlier step, of an occurrence within the closure in time, read through
either course, of a source occurrence. -/
theorem Spread.withinTime {t : Nat} {c : C} (spread : Spread L L' W obs source t c) :
    (∀ s, s < t → L.present s = L'.present s) →
    ∃ x s h, source x.1 x.2 ∧ s < t ∧ Flow.WithinTimeEither L L' W obs x (s, h) ∧
      TouchesAt L L' s h c := by
  induction spread with
  | hold _ ih =>
    intro present
    rcases ih (fun s lt => present s (Nat.lt_succ_of_lt lt)) with ⟨x, s, h, src, lt, within, touch⟩
    exact ⟨x, s, h, src, Nat.lt_succ_of_lt lt, within, touch⟩
  | @input t h c src touch =>
    intro _
    exact ⟨(t, h), t, h, src, Nat.lt_succ_self t, WithinClosure.refl _, touch⟩
  | @response s t h c d _ le coupled touch ih =>
    intro present
    rcases ih (fun r lt => present r (Nat.lt_succ_of_le (Nat.le_trans (Nat.le_of_lt lt) le)))
      with ⟨x, s', h', src, lt, within, touch'⟩
    exact ⟨x, t, h, src, Nat.lt_succ_self t,
      Flow.WithinTimeEither.later (WithinClosure.trans within
        (WithinClosure.of_rel (.inr (Flow.affectsBeforeEither_of_touches
          (present s' (Nat.lt_succ_of_le (Nat.le_trans (Nat.le_of_lt lt) le))) lt coupled
          touch')))) le,
      touch⟩

/-- **What has reached a reader lies on the relation in time**: where the two courses have the same
formations present before `T`, the closure in time of a source occurrence meets the reader by
`T`. -/
theorem ReachedBy.reachedInTime {g : F} {T : Nat}
    (present : ∀ t, t < T → L.present t = L'.present t)
    (reached : ReachedBy L L' W obs source g T) : Flow.ReachedInTime L L' W obs source g T :=
  match reached with
  | ⟨s, _, le, coupled, spread⟩ =>
    match spread.withinTime (fun r lt => present r (Nat.lt_of_lt_of_le lt le)) with
    | ⟨x, s', h, src, lt, within, touch⟩ =>
      ⟨x, (s', h), s, src, within,
       Flow.affectsBeforeEither_of_touches (present s' (Nat.lt_of_lt_of_le lt le)) lt coupled touch,
       le⟩

/-- An occurrence is a source occurrence, or its formation is coupled at or before its step into a
condition a route has reached. -/
def SourceOrReached (L L' : Flow F C) (W : Web F C) (obs : F → C → Prop)
    (source : Nat → F → Prop) (y : Nat × F) : Prop :=
  source y.1 y.2 ∨ ∃ s d, s ≤ y.1 ∧ CoupledIntoAt W obs y.2 s d ∧ Spread L L' W obs source s d

/-- An occurrence that is a source occurrence or has been reached, affecting a later one, reaches
it, where the two courses have the same formations present at its step. -/
theorem SourceOrReached.affects {a b : Nat × F} (present : L.present a.1 = L'.present a.1)
    (inside : SourceOrReached L L' W obs source a)
    (affects : Flow.AffectsBeforeEither L L' W obs a b) :
    ∃ s d, s ≤ b.1 ∧ CoupledIntoAt W obs b.2 s d ∧ Spread L L' W obs source s d :=
  match affects.touches present with
  | ⟨c, before, coupled, touch⟩ =>
    have next : Spread L L' W obs source (a.1 + 1) c := match inside with
      | .inl src => .input src touch
      | .inr ⟨_, _, le, coupled', spread⟩ => .response spread le coupled' touch
    ⟨b.1, c, Nat.le_refl _, coupled, next.later (Nat.succ_le_of_lt before)⟩

/-- **Where the source goes on, the relation in time reaches what the route reaches**, the two
courses having the same formations present before `T`. -/
theorem reachedBy_of_reachedInTime {T : Nat} (present : ∀ t, t < T → L.present t = L'.present t)
    (onward : ∀ t h, source t h → source (t + 1) h) {g : F}
    (reached : Flow.ReachedInTime L L' W obs source g T) : ReachedBy L L' W obs source g T :=
  match reached with
  | ⟨_, z, u, src, within, affects, le⟩ =>
    have inside : z.1 ≤ T → SourceOrReached L L' W obs source z :=
      within (fun y => y.1 ≤ T → SourceOrReached L L' W obs source y)
        (fun a b inside step late => match step with
          | .inl ⟨next, same⟩ =>
            have early : a.1 ≤ T := Nat.le_trans (Nat.le_succ a.1)
              (Eq.subst (motive := fun r => r ≤ T) next late)
            match inside early with
            | .inl src' => .inl (Eq.subst (motive := fun t => source t b.2) next.symm
                (Eq.subst (motive := fun h => source (a.1 + 1) h) same.symm (onward a.1 a.2 src')))
            | .inr ⟨s, d, le', coupled, spread⟩ => .inr ⟨s, d,
                Eq.subst (motive := fun t => s ≤ t) next.symm (Nat.le_succ_of_le le'),
                Eq.subst (motive := fun h => CoupledIntoAt W obs h s d) same.symm coupled, spread⟩
          | .inr affects' =>
            have before : a.1 < b.1 := match affects' with
              | .inl a' => a'.1
              | .inr a' => a'.1
            .inr ((inside (Nat.le_of_lt (Nat.lt_of_lt_of_le before late))).affects
              (present a.1 (Nat.lt_of_lt_of_le before late)) affects'))
        (fun _ => .inl src)
    have before : z.1 < u := match affects with
      | .inl a' => a'.1
      | .inr a' => a'.1
    match (inside (Nat.le_of_lt (Nat.lt_of_lt_of_le before le))).affects
        (present z.1 (Nat.lt_of_lt_of_le before le)) affects with
    | ⟨s, d, le', coupled, spread⟩ => ⟨s, d, Nat.le_trans le' le, coupled, spread⟩

/-- **The potential route is the relation in time.** With the same formations present in the two
courses before `T` and a source that goes on (a source occurrence's formation is a source at the
next step), a route has reached `g` by `T` exactly where the closure in time of a source occurrence,
read through either course with coupling by level, meets `g` by `T`. -/
theorem reachedBy_iff_reachedInTime {T : Nat} (present : ∀ t, t < T → L.present t = L'.present t)
    (onward : ∀ t h, source t h → source (t + 1) h) {g : F} :
    ReachedBy L L' W obs source g T ↔ Flow.ReachedInTime L L' W obs source g T :=
  ⟨ReachedBy.reachedInTime present, reachedBy_of_reachedInTime present onward⟩

/-- **In one course, by threshold only, in J3's terms.** Where the source goes on, a route has
reached `g` by `T` exactly where an occurrence within the closure in time (`Flow.WithinTime`) of a
source occurrence affects `g`'s occurrence at a step up to `T` (`Flow.AffectsBefore`). -/
theorem reachedBy_self_iff (onward : ∀ t h, source t h → source (t + 1) h) {g : F} {T : Nat} :
    ReachedBy L L W thresholdOnly source g T ↔
      ∃ x z u, source x.1 x.2 ∧ L.WithinTime W x z ∧ L.AffectsBefore W z (u, g) ∧ u ≤ T :=
  (reachedBy_iff_reachedInTime (fun _ _ => rfl) onward).trans
    ⟨fun ⟨x, z, u, src, within, affects, le⟩ =>
       ⟨x, z, u, src, Flow.withinTimeEither_self.mp within,
        match affects with
        | .inl a => Flow.affectsBeforeBy_thresholdOnly.mp a
        | .inr a => Flow.affectsBeforeBy_thresholdOnly.mp a, le⟩,
     fun ⟨x, z, u, src, within, affects, le⟩ =>
       ⟨x, z, u, src, Flow.withinTimeEither_self.mpr within,
        .inl (Flow.affectsBeforeBy_thresholdOnly.mpr affects), le⟩⟩

end TimedResponse

/-! ## The reading not before the route -/

namespace Web

variable {L L' : Flow F C} {W W' : Web F C} {obs : F → C → Prop} {source : Nat → F → Prop}
  {group : F → Prop} {D : Nat} {select : (Nat → C → Nat) → Prop}

/-- **No selection read off continuation reads a difference before the relation in time carries it
to the group.** Two courses, balanced before `D`, with the same formations present before `D` and
a common start, every formation other than a source exchanging alike wherever it is alike through
its couplings by `obs` (TimedResponse's deadline premises; `obs` is the responders' coupling, not
the selection's). Where the closure in time of no source occurrence, read through either course,
meets a member by `D`, every selection read off the group's continuations up to `D` selects the two
courses alike. -/
theorem selectsAlike_unreached
    (balanced : ∀ t, t < D → ∀ c, W.level (t+1) c + L.taken t c = W.level t c + L.given t c)
    (balanced' : ∀ t, t < D → ∀ c, W'.level (t+1) c + L'.taken t c = W'.level t c + L'.given t c)
    (present : ∀ t, t < D → L.present t = L'.present t)
    (start : ∀ c, W.level 0 c = W'.level 0 c)
    (responds : ∀ t, t < D → ∀ h, ¬ source t h → W.AlikeThroughUpTo obs h W.level W'.level t →
      ∀ c, L.take t h c = L'.take t h c ∧ L.give t h c = L'.give t h c)
    (far : ∀ g, group g → ¬ Flow.ReachedInTime L L' W obs source g D)
    (reads : W.SelectsThroughAll thresholdOnly group D select) : select W.level ↔ select W'.level :=
  reads _ _ (alikeThroughAll_thresholdOnly_iff.mpr fun g member t le =>
    (TimedResponse.coupling_alike_before balanced balanced' present start responds
      (fun reached => far g member (reached.reachedInTime present)) t le).1)

/-- **The first step apart comes no earlier than the relation in time meets the group.** Under the
same premises up to the first step apart, it is not the case that the closure in time of no source
occurrence meets any member by then. -/
theorem FirstApart.not_unreached {T : Nat}
    (balanced : ∀ t, t < T → ∀ c, W.level (t+1) c + L.taken t c = W.level t c + L.given t c)
    (balanced' : ∀ t, t < T → ∀ c, W'.level (t+1) c + L'.taken t c = W'.level t c + L'.given t c)
    (present : ∀ t, t < T → L.present t = L'.present t)
    (start : ∀ c, W.level 0 c = W'.level 0 c)
    (responds : ∀ t, t < T → ∀ h, ¬ source t h → W.AlikeThroughUpTo obs h W.level W'.level t →
      ∀ c, L.take t h c = L'.take t h c ∧ L.give t h c = L'.give t h c)
    (first : W.FirstApart group W.level W'.level T) :
    ¬ ∀ g, group g → ¬ Flow.ReachedInTime L L' W obs source g T :=
  fun far => match first.separates with
  | ⟨_, reads, holds, fails⟩ => fails ((selectsAlike_unreached balanced balanced'
      present start responds far reads).mp holds)

end Web

/-! ## How strongly: the gap against the margin -/

namespace Web

variable {W : Web F C} {l l' : Nat → C → Nat} {g : F} {t : Nat}

/-- **A gap within the margin leaves admission as it is.** Where the levels `l'` admit `g` at `t`,
and on every condition `g` then requires the gap between the two levels is within `g`'s margin
under `l'` (its level less its need), the levels `l` admit `g` at `t`. -/
theorem admits_of_gap_within_margin (admitted : W.Admits (l' t) t g)
    (within : ∀ c, W.requires t g c → gap (l t c) (l' t c) ≤ l' t c - W.need t g c) :
    W.Admits (l t) t g :=
  fun c requires =>
    have reach : l' t c ≤ l t c + (l' t c - W.need t g c) := (gap_le_iff.mp (within c requires)).2
    le_of_add_le_add_right _ (Nat.le_trans
      (Nat.le_of_eq (Naturals.add_sub_of_le (admitted c requires))) reach)

/-- **A loss is read off a member's continuation exactly where the gap crosses its margin.** Where
`l` lowers every condition `g` requires at `t` from `l'`, and `l'` admits `g` there, `l` admits `g`
at `t` exactly where every such gap is within `g`'s margin under `l'`. -/
theorem admits_iff_gap_within_margin (lower : ∀ c, W.requires t g c → l t c ≤ l' t c)
    (admitted : W.Admits (l' t) t g) :
    W.Admits (l t) t g ↔
      ∀ c, W.requires t g c → gap (l t c) (l' t c) ≤ l' t c - W.need t g c :=
  ⟨fun admits c requires =>
     have zero : l t c - l' t c = 0 := sub_eq_zero_of_le (lower c requires)
     Nat.le_trans (Nat.le_of_eq ((congrArg (· + (l' t c - l t c)) zero).trans (Nat.zero_add _)))
       (match le_dest (admits c requires) with
        | ⟨j, same⟩ => Eq.subst (motive := fun y => l' t c - y ≤ l' t c - W.need t g c) same.symm
            (Nat.le_trans (Nat.le_of_eq (Naturals.sub_sub (l' t c) (W.need t g c) j).symm)
              (Nat.sub_le _ j))),
   admits_of_gap_within_margin admitted⟩

end Web

/-! ## The point of no return, on courses -/

section NoReturn

variable {C : Type}

/-- **Recoverable at a step**: some course among the feasible ones, agreeing with `l` at every step
up to `N`, keeps what `keeps` asks of a course. -/
def Recoverable (feasible keeps : (Nat → C → Nat) → Prop) (l : Nat → C → Nat) (N : Nat) : Prop :=
  ∃ l', feasible l' ∧ AgreeUpTo l' l N ∧ keeps l'

/-- **The point of no return of a course**: the first step at which it is not recoverable. -/
def NoReturnAt (feasible keeps : (Nat → C → Nat) → Prop) (l : Nat → C → Nat) (N : Nat) : Prop :=
  ¬ Recoverable feasible keeps l N ∧ ∀ n, n < N → Recoverable feasible keeps l n

variable {feasible keeps : (Nat → C → Nat) → Prop} {l : Nat → C → Nat} {N : Nat}

/-- Recoverable at a step is recoverable at every earlier step. -/
theorem Recoverable.earlier (rec : Recoverable feasible keeps l N) {n : Nat} (le : n ≤ N) :
    Recoverable feasible keeps l n :=
  match rec with
  | ⟨l', fe, agree, keep⟩ => ⟨l', fe, fun s le' => agree s (Nat.le_trans le' le), keep⟩

/-- **Before the point, and only before it, the course is recoverable.** -/
theorem NoReturnAt.recoverable_iff (point : NoReturnAt feasible keeps l N) {n : Nat} :
    Recoverable feasible keeps l n ↔ n < N :=
  ⟨fun rec => match Nat.lt_or_ge n N with
     | .inl lt => lt
     | .inr ge => absurd (rec.earlier ge) point.1,
   point.2 n⟩

/-- The point of no return is one step. -/
theorem NoReturnAt.unique {N' : Nat} (point : NoReturnAt feasible keeps l N)
    (point' : NoReturnAt feasible keeps l N') : N = N' :=
  match Nat.lt_or_ge N N' with
  | .inl lt => absurd (point'.2 N lt) point.1
  | .inr ge => match Nat.lt_or_eq_of_le ge with
    | .inl lt => absurd (point.2 N' lt) point'.1
    | .inr same => same.symm

/-- **At the step before the point the courses part**: a feasible course agreeing with `l` up to
that step keeps, and every feasible course agreeing with `l` up to the point does not. -/
theorem NoReturnAt.parts (point : NoReturnAt feasible keeps l (N + 1)) :
    (∃ l', feasible l' ∧ AgreeUpTo l' l N ∧ keeps l') ∧
      ∀ l', feasible l' → AgreeUpTo l' l (N + 1) → ¬ keeps l' :=
  ⟨point.2 N (Nat.lt_succ_self N), fun l' fe agree keep => point.1 ⟨l', fe, agree, keep⟩⟩

/-- **A point of no return exists where recoverability is decided at each step and fails at
some.** -/
theorem noReturnAt_of_past (decided : ∀ n, Recoverable feasible keeps l n ∨
      ¬ Recoverable feasible keeps l n) {n : Nat} (past : ¬ Recoverable feasible keeps l n) :
    ∃ N, N ≤ n ∧ NoReturnAt feasible keeps l N :=
  match first_of_decided decided n with
  | .inl all => absurd (all n (Nat.le_refl n)) past
  | .inr ⟨m, le, fails, before⟩ => ⟨m, le, fails, before⟩

end NoReturn

/-! ## Read in time -/

namespace Web

/-- **Readable in time**: the first step at which a selection read off the group's continuations
can tell the losing course `l` from `l'` is a step at which `l` is still recoverable. -/
def ReadableInTime (W : Web F C) (group : F → Prop) (feasible keeps : (Nat → C → Nat) → Prop)
    (l l' : Nat → C → Nat) : Prop :=
  ∃ T, W.FirstApart group l l' T ∧ Recoverable feasible keeps l T

/-- **A family of selections reads in time**: it tells the losing course `l` from `l'` apart at a
step at which `l` is still recoverable. -/
def ReadsInTime (sel : Nat → (Nat → C → Nat) → Prop) (feasible keeps : (Nat → C → Nat) → Prop)
    (l l' : Nat → C → Nat) : Prop :=
  ∃ T, TellsApartAt sel l l' T ∧ Recoverable feasible keeps l T

variable {W W' : Web F C} {group : F → Prop} {feasible keeps : (Nat → C → Nat) → Prop}
  {l l' : Nat → C → Nat} {T N D : Nat} {sel : Nat → (Nat → C → Nat) → Prop}

/-- **Readable in time exactly where the first step apart comes before the point of no return.** -/
theorem readableInTime_iff (first : W.FirstApart group l l' T)
    (point : NoReturnAt feasible keeps l N) : W.ReadableInTime group feasible keeps l l' ↔ T < N :=
  ⟨fun ⟨_, first', rec⟩ => point.recoverable_iff.mp
     (Eq.subst (motive := fun r => Recoverable feasible keeps l r) (first'.unique first) rec),
   fun lt => ⟨T, first, point.recoverable_iff.mpr lt⟩⟩

/-- **A family read off the continuations that reads in time makes the courses readable in time**:
it reads no earlier than the first step apart. -/
theorem ReadsInTime.readable (reads : ∀ s, W.SelectsThroughAll thresholdOnly group s (sel s))
    (first : W.FirstApart group l l' T) (inTime : ReadsInTime sel feasible keeps l l') :
    W.ReadableInTime group feasible keeps l l' :=
  match inTime with
  | ⟨_, tells, rec⟩ => ⟨T, first, rec.earlier (tells.not_before reads first)⟩

/-- **Too late where nothing is read until the point.** Where every member is admitted alike at
every step up to `D` and the losing course is past return at `D`, the courses are not readable in
time, and no family of selections read off the group's continuations reads them in time. -/
theorem too_late_of_alike
    (alike : ∀ g, group g → ∀ t, t ≤ D → (W.Admits (l t) t g ↔ W.Admits (l' t) t g))
    (past : ¬ Recoverable feasible keeps l D) :
    ¬ W.ReadableInTime group feasible keeps l l' ∧
      ∀ sel, (∀ s, W.SelectsThroughAll thresholdOnly group s (sel s)) →
        ¬ ReadsInTime sel feasible keeps l l' :=
  ⟨fun ⟨T, first, rec⟩ => match Nat.lt_or_ge D T with
     | .inl lt => past (rec.earlier (Nat.le_of_lt lt))
     | .inr ge => match first.1 with
       | ⟨g, member, differ⟩ => differ (alike g member T ge),
   fun _ reads ⟨T, tells, rec⟩ => match Nat.lt_or_ge D T with
     | .inl lt => past (rec.earlier (Nat.le_of_lt lt))
     | .inr ge => tells.1 (reads T l l' (alikeThroughAll_thresholdOnly_iff.mpr
         fun g member t le => alike g member t (Nat.le_trans le ge)))⟩

variable {L L' : Flow F C} {obs : F → C → Prop} {source : Nat → F → Prop}

/-- **Too late where the route arrives no earlier than the point.** Under TimedResponse's deadline
premises up to `D`, where the closure in time of no source occurrence, read through either course,
meets a member by `D`, and the losing course is past return at `D`, the courses are not readable in
time, and no family of selections read off the group's continuations reads them in time. -/
theorem too_late_of_unreached
    (balanced : ∀ t, t < D → ∀ c, W.level (t+1) c + L.taken t c = W.level t c + L.given t c)
    (balanced' : ∀ t, t < D → ∀ c, W'.level (t+1) c + L'.taken t c = W'.level t c + L'.given t c)
    (present : ∀ t, t < D → L.present t = L'.present t)
    (start : ∀ c, W.level 0 c = W'.level 0 c)
    (responds : ∀ t, t < D → ∀ h, ¬ source t h → W.AlikeThroughUpTo obs h W.level W'.level t →
      ∀ c, L.take t h c = L'.take t h c ∧ L.give t h c = L'.give t h c)
    (far : ∀ g, group g → ¬ Flow.ReachedInTime L L' W obs source g D)
    (past : ¬ Recoverable feasible keeps W.level D) :
    ¬ W.ReadableInTime group feasible keeps W.level W'.level ∧
      ∀ sel, (∀ s, W.SelectsThroughAll thresholdOnly group s (sel s)) →
        ¬ ReadsInTime sel feasible keeps W.level W'.level :=
  too_late_of_alike (fun g member t le =>
    (TimedResponse.coupling_alike_before balanced balanced' present start responds
      (fun reached => far g member (reached.reachedInTime present)) t le).1) past

/-- **Too late where what arrives stays within the margins until the point.** Where at every step
up to `D` the levels `l'` admit every member and every gap on what it requires is within its
margin under `l'`, and the losing course is past return at `D`, the courses are not readable in
time, and no family of selections read off the group's continuations reads them in time. -/
theorem too_late_within_margin
    (within : ∀ g, group g → ∀ t, t ≤ D → W.Admits (l' t) t g ∧
      ∀ c, W.requires t g c → gap (l t c) (l' t c) ≤ l' t c - W.need t g c)
    (past : ¬ Recoverable feasible keeps l D) :
    ¬ W.ReadableInTime group feasible keeps l l' ∧
      ∀ sel, (∀ s, W.SelectsThroughAll thresholdOnly group s (sel s)) →
        ¬ ReadsInTime sel feasible keeps l l' :=
  too_late_of_alike (fun g member t le =>
    match within g member t le with
    | ⟨admitted, gaps⟩ => ⟨fun _ => admitted, fun _ => admits_of_gap_within_margin admitted gaps⟩)
    past

/-- Levels alike on every condition admit alike. -/
theorem admits_congr {a b : C → Nat} {t : Nat} {g : F} (same : ∀ c, a c = b c) :
    W.Admits a t g ↔ W.Admits b t g :=
  ⟨fun admits c requires => Nat.le_trans (admits c requires) (Nat.le_of_eq (same c)),
   fun admits c requires => Nat.le_trans (admits c requires) (Nat.le_of_eq (same c).symm)⟩

/-- **Read off the continuations of what is lost, the loss is read only once it has happened, past
its point of no return.** Where what is kept includes every member's admission at every step, and
`l'` admits every member at every step, the courses are not readable in time by the group's
continuations, and no family of selections read off them reads them in time: wherever a member's
admission first differs, the losing course has already lost what is kept, and so has every course
agreeing with it so far. -/
theorem too_late_of_own
    (within : ∀ m, keeps m → ∀ g, group g → ∀ t, W.Admits (m t) t g)
    (kept' : ∀ g, group g → ∀ t, W.Admits (l' t) t g) :
    ¬ W.ReadableInTime group feasible keeps l l' ∧
      ∀ sel, (∀ s, W.SelectsThroughAll thresholdOnly group s (sel s)) →
        ¬ ReadsInTime sel feasible keeps l l' :=
  have alikeUpTo : ∀ T, Recoverable feasible keeps l T → ∀ g, group g → ∀ t, t ≤ T →
      (W.Admits (l t) t g ↔ W.Admits (l' t) t g) := fun _ ⟨m, _, agree, keep⟩ g member t le =>
    ⟨fun _ => kept' g member t,
     fun _ => (admits_congr (agree t le)).mp (within m keep g member t)⟩
  ⟨fun ⟨T, first, rec⟩ => match first.1 with
     | ⟨g, member, differ⟩ => differ (alikeUpTo T rec g member T (Nat.le_refl T)),
   fun _ reads ⟨T, tells, rec⟩ =>
     tells.1 (reads T l l' (alikeThroughAll_thresholdOnly_iff.mpr (alikeUpTo T rec)))⟩

end Web

/-! ## Witnesses: four readers of one loss -/

namespace FourReaders

/-- A clearer, a dweller, a renewer, two gauges, two relays and a listener. -/
inductive Formation
  | clearer
  | dweller
  | renewer
  | near
  | mid
  | relay
  | relay'
  | listener

/-- The habitat, and the two conditions the relays pass a signal through. -/
inductive Place
  | habitat
  | news
  | news'

/-- The clearer's four courses: it stops before step 0, 1 or 2, or never. -/
inductive Stop
  | s0
  | s1
  | s2
  | never

/-- The habitat along each course. -/
def habitat : Stop → Nat → Nat
  | .s0, _ => 4
  | .s1, 0 => 4
  | .s1, _ + 1 => 3
  | .s2, 0 => 4
  | .s2, 1 => 3
  | .s2, _ + 2 => 2
  | .never, 0 => 4
  | .never, 1 => 3
  | .never, 2 => 2
  | .never, 3 => 1
  | .never, _ + 4 => 0

/-- News once the habitat has fallen below 4 at step 1: it stands at 1 until step 2. -/
def newsFalls : Nat → Nat
  | 0 => 1
  | 1 => 1
  | _ + 2 => 0

/-- The second news once news has fallen: it stands at 1 until step 3. -/
def news'Falls : Nat → Nat
  | 0 => 1
  | 1 => 1
  | 2 => 1
  | _ + 3 => 0

/-- What the first relay passes on, along each course. -/
def news : Stop → Nat → Nat
  | .s0, _ => 1
  | .s1, t => newsFalls t
  | .s2, t => newsFalls t
  | .never, t => newsFalls t

/-- What the second relay passes on, along each course. -/
def news' : Stop → Nat → Nat
  | .s0, _ => 1
  | .s1, t => news'Falls t
  | .s2, t => news'Falls t
  | .never, t => news'Falls t

/-- The levels along each course. -/
def levels (k : Stop) (t : Nat) (c : Place) : Nat :=
  match c with
  | .habitat => habitat k t
  | .news => news k t
  | .news' => news' k t

/-- The clearer means to clear across the step from `t`: never, before step 1, before step 2, or
at every step. -/
def means : Stop → Nat → Bool
  | .s0, _ => false
  | .s1, t => decide (t < 1)
  | .s2, t => decide (t < 2)
  | .never, _ => true

/-- Each course's exchange. The clearer draws one unit of the habitat while it means to and the
habitat stands at 2 or above; the dweller draws one while the habitat stands at 1 or above, and the
renewer gives one while it stands at 2 or above. The first relay gives one unit of news while the
habitat stands at 4; the second takes one of news and gives one of the second news while news stands
at 1 or above; the listener takes one of the second news while it stands at 1 or above. -/
def flow (k : Stop) : Flow Formation Place where
  present _ := [.clearer, .dweller, .renewer, .near, .mid, .relay, .relay', .listener]
  take t f c := match f, c with
    | .clearer, .habitat => if (means k t && decide (2 ≤ habitat k t)) = true then 1 else 0
    | .clearer, .news => 0
    | .clearer, .news' => 0
    | .dweller, .habitat => if 1 ≤ habitat k t then 1 else 0
    | .dweller, .news => 0
    | .dweller, .news' => 0
    | .renewer, _ => 0
    | .near, _ => 0
    | .mid, _ => 0
    | .relay, _ => 0
    | .relay', .habitat => 0
    | .relay', .news => if 1 ≤ news k t then 1 else 0
    | .relay', .news' => 0
    | .listener, .habitat => 0
    | .listener, .news => 0
    | .listener, .news' => if 1 ≤ news' k t then 1 else 0
  give t f c := match f, c with
    | .clearer, _ => 0
    | .dweller, _ => 0
    | .renewer, .habitat => if 2 ≤ habitat k t then 1 else 0
    | .renewer, .news => 0
    | .renewer, .news' => 0
    | .near, _ => 0
    | .mid, _ => 0
    | .relay, .habitat => 0
    | .relay, .news => if 4 ≤ habitat k t then 1 else 0
    | .relay, .news' => 0
    | .relay', .habitat => 0
    | .relay', .news => 0
    | .relay', .news' => if 1 ≤ news k t then 1 else 0
    | .listener, _ => 0

/-- What each formation requires: the dweller and the two gauges the habitat, the first relay the
habitat, the second relay news, the listener the second news. -/
def requires : Formation → Place → Prop
  | .clearer, _ => False
  | .dweller, .habitat => True
  | .dweller, .news => False
  | .dweller, .news' => False
  | .renewer, _ => False
  | .near, .habitat => True
  | .near, .news => False
  | .near, .news' => False
  | .mid, .habitat => True
  | .mid, .news => False
  | .mid, .news' => False
  | .relay, .habitat => True
  | .relay, .news => False
  | .relay, .news' => False
  | .relay', .habitat => False
  | .relay', .news => True
  | .relay', .news' => False
  | .listener, .habitat => False
  | .listener, .news => False
  | .listener, .news' => True

/-- Needs: the near gauge 3, the mid gauge 2, the first relay 4, every other need 1. -/
def need : Formation → Place → Nat
  | .clearer, _ => 1
  | .dweller, _ => 1
  | .renewer, _ => 1
  | .near, .habitat => 3
  | .near, .news => 1
  | .near, .news' => 1
  | .mid, .habitat => 2
  | .mid, .news => 1
  | .mid, .news' => 1
  | .relay, .habitat => 4
  | .relay, .news => 1
  | .relay, .news' => 1
  | .relay', _ => 1
  | .listener, _ => 1

/-- Each course's web. -/
def web (k : Stop) : Web Formation Place where
  level := levels k
  active _ _ := True
  requires _ f c := requires f c
  need _ f c := need f c
  draws _ f c := requires f c

/-- **Every course balances.** -/
theorem balances : ∀ k, (flow k).Balances (web k) := by
  intro k t c
  cases k <;> rcases t with _ | _ | _ | _ | t <;> cases c <;> rfl

/-- A formation requiring one condition is admitted exactly where that condition stands at its
need. -/
theorem admits_one {k : Stop} {t : Nat} {g : Formation} {c : Place} (l : Place → Nat)
    (only : ∀ c', requires g c' → c' = c) (req : requires g c) :
    (web k).Admits l t g ↔ need g c ≤ l c :=
  ⟨fun admits => admits c req,
   fun le c' r => Eq.subst (motive := fun d => need g d ≤ l d) (only c' r).symm le⟩

theorem only_habitat_near : ∀ c', requires .near c' → c' = .habitat
  | .habitat, _ => rfl
  | .news, r => False.elim r
  | .news', r => False.elim r

theorem only_habitat_mid : ∀ c', requires .mid c' → c' = .habitat
  | .habitat, _ => rfl
  | .news, r => False.elim r
  | .news', r => False.elim r

theorem only_habitat_dweller : ∀ c', requires .dweller c' → c' = .habitat
  | .habitat, _ => rfl
  | .news, r => False.elim r
  | .news', r => False.elim r

theorem only_news'_listener : ∀ c', requires .listener c' → c' = .news'
  | .habitat, r => False.elim r
  | .news, r => False.elim r
  | .news', _ => rfl

/-- The courses the clearer can take. -/
def Feasible (l : Nat → Place → Nat) : Prop :=
  ∃ k, ∀ t c, l t c = levels k t c

/-- The dweller is admitted at every step. -/
def DwellerKept (l : Nat → Place → Nat) : Prop :=
  ∀ t, (web .never).Admits (l t) t .dweller

/-- **The cleared course is recoverable exactly up to step 2**: stopping before step 2 agrees with
it so far and keeps the dweller; from step 3 every course agreeing with it is the cleared one, which
loses the dweller at step 4. -/
theorem recoverable_iff {N : Nat} :
    Recoverable Feasible DwellerKept (levels .never) N ↔ N ≤ 2 :=
  ⟨fun ⟨l', ⟨k, same⟩, agree, kept⟩ => match Nat.lt_or_ge 2 N with
     | .inr le => le
     | .inl lt =>
       have three : 3 ≤ N := lt
       match k with
       | .s0 => absurd ((same 1 .habitat).symm.trans (agree 1 (Nat.le_trans (by decide) three)
           .habitat)) (by decide)
       | .s1 => absurd ((same 2 .habitat).symm.trans (agree 2 (Nat.le_trans (by decide) three)
           .habitat)) (by decide)
       | .s2 => absurd ((same 3 .habitat).symm.trans (agree 3 three .habitat)) (by decide)
       | .never => absurd (Nat.le_trans
           ((admits_one (k := .never) (l' 4) only_habitat_dweller trivial).mp (kept 4))
           (Nat.le_of_eq (same 4 .habitat))) (by decide),
   fun le => ⟨levels .s2, ⟨.s2, fun _ _ => rfl⟩,
     fun s le' c => match s, c, Nat.le_trans le' le with
       | 0, .habitat, _ => rfl
       | 0, .news, _ => rfl
       | 0, .news', _ => rfl
       | 1, .habitat, _ => rfl
       | 1, .news, _ => rfl
       | 1, .news', _ => rfl
       | 2, .habitat, _ => rfl
       | 2, .news, _ => rfl
       | 2, .news', _ => rfl
       | n + 3, _, two => absurd (Nat.lt_succ_of_le two) (Nat.not_lt_of_le (Nat.le_add_left 3 n)),
     fun t => (admits_one (k := .never) _ only_habitat_dweller trivial).mpr (match t with
       | 0 => (by decide : 1 ≤ 4)
       | 1 => (by decide : 1 ≤ 3)
       | _ + 2 => (by decide : 1 ≤ 2))⟩⟩

/-- **The cleared course's point of no return is step 3**, while the dweller is still admitted at
step 3 and not at step 4. -/
theorem noReturn :
    NoReturnAt Feasible DwellerKept (levels .never) 3 ∧
      (web .never).Admits (levels .never 3) 3 .dweller ∧
      ¬ (web .never).Admits (levels .never 4) 4 .dweller :=
  ⟨⟨fun rec => absurd (recoverable_iff.mp rec) (by decide),
    fun _ lt => recoverable_iff.mpr (Nat.le_of_lt_succ lt)⟩,
   (admits_one (k := .never) _ only_habitat_dweller trivial).mpr (by decide : 1 ≤ 1),
   fun admits => absurd ((admits_one (k := .never) _ only_habitat_dweller trivial).mp admits)
     (by decide)⟩

/-! ### The regime -/

/-- The renewer's giving, read off what the dweller's draw leaves: one unit where at least one is
left. -/
def giving (z : Nat) : Nat := if 1 ≤ z then 1 else 0

theorem giving_le_one : ∀ z, giving z ≤ 1
  | 0 => Nat.zero_le 1
  | _ + 1 => Nat.le_refl 1

/-- **The regime's point is exact at 2** (`RegimeMargin.ends_iff_below`, with the dweller's draw
`H = 1` and giving meeting it from `y = 1`): from a level up to 4 the habitat, left to the dweller
and the renewer, ends exactly where it starts below 2. -/
theorem regime_point {x : Nat} (high : x ≤ 4) :
    (∃ n, (Law.run (RegimeMargin.step giving 1) x).state n = 0) ↔ x < 2 :=
  RegimeMargin.ends_iff_below (y := 1) (hi := 4) (Nat.zero_lt_succ 1)
    (fun z lt => match z, lt with
      | 0, _ => Nat.zero_lt_one
      | _ + 1, lt => absurd (Nat.le_of_succ_le_succ lt) (Nat.not_succ_le_zero _))
    rfl
    (fun z le _ => match z, le with
      | 0, le => absurd le (Nat.not_succ_le_zero 0)
      | _ + 1, _ => Nat.le_refl 1)
    (fun x high => match x, high with
      | 0, _ => Nat.zero_le 4
      | z + 1, high => Nat.le_trans (Nat.add_le_add_left (giving_le_one z) z) high)
    high

/-- A level the step leaves as it is stays for ever. -/
theorem orbit_of_fixed {f : Nat → Nat} {x : Nat} (fixed : f x = x) : ∀ n, Law.orbit f x n = x
  | 0 => rfl
  | n + 1 => (congrArg f (orbit_of_fixed fixed n)).trans fixed

/-- From 1 the regime ends at the next step and stays at nothing. -/
theorem orbit_one : ∀ n, Law.orbit (RegimeMargin.step giving 1) 1 (n + 1) = 0
  | 0 => rfl
  | n + 1 => (congrArg (RegimeMargin.step giving 1) (orbit_one n)).trans rfl

/-- The step at which each course stops clearing. -/
def stopAt : Stop → Nat
  | .s0 => 0
  | .s1 => 1
  | .s2 => 2
  | .never => 3

/-- **Once the clearer stops, the habitat is the regime's run** under the dweller's draw, from its
level then. -/
theorem stopped_is_regime : ∀ k n, habitat k (n + stopAt k) =
    (Law.run (RegimeMargin.step giving 1) (habitat k (stopAt k))).state n
  | .s0, n => (orbit_of_fixed (f := RegimeMargin.step giving 1) (x := 4) rfl n).symm
  | .s1, n => (orbit_of_fixed (f := RegimeMargin.step giving 1) (x := 3) rfl n).symm
  | .s2, n => (orbit_of_fixed (f := RegimeMargin.step giving 1) (x := 2) rfl n).symm
  | .never, 0 => rfl
  | .never, n + 1 => (orbit_one n).symm

/-- The cleared habitat stands at most at 4. -/
theorem habitat_le_four : ∀ N, habitat .never N ≤ 4
  | 0 => Nat.le_refl 4
  | 1 => by decide
  | 2 => by decide
  | 3 => by decide
  | _ + 4 => Nat.zero_le 4

/-- The cleared habitat stands at the regime's point or above exactly up to step 2. -/
theorem at_point_iff : ∀ N, 2 ≤ habitat .never N ↔ N ≤ 2
  | 0 => ⟨fun _ => by decide, fun _ => by decide⟩
  | 1 => ⟨fun _ => by decide, fun _ => by decide⟩
  | 2 => ⟨fun _ => by decide, fun _ => by decide⟩
  | 3 => ⟨fun h => absurd h (by decide), fun h => absurd h (by decide)⟩
  | n + 4 => ⟨fun h => absurd h (Nat.not_succ_le_zero 1),
      fun h => absurd (Nat.le_trans (Nat.le_add_left 4 n) h) (by decide)⟩

/-- **The point of no return is the regime's.** The cleared course is recoverable at a step exactly
where the regime, left to the dweller's draw from the cleared level then, does not end: some course
agreeing with it so far keeps the dweller exactly while its level stands at the regime's exact
point or above. -/
theorem recoverable_iff_regime {N : Nat} :
    Recoverable Feasible DwellerKept (levels .never) N ↔
      ¬ ∃ n, (Law.run (RegimeMargin.step giving 1) (habitat .never N)).state n = 0 :=
  have point := regime_point (habitat_le_four N)
  recoverable_iff.trans ((at_point_iff N).symm.trans
    ⟨fun le ends => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le (point.mp ends) le),
     fun kept => match Nat.lt_or_ge (habitat .never N) 2 with
       | .inl lt => absurd (point.mpr lt) kept
       | .inr ge => ge⟩)

/-! ### Four readers -/

/-- **The near gauge is first apart at step 2.** -/
theorem near_firstApart :
    (web .never).FirstApart (· = .near) (levels .never) (levels .s0) 2 :=
  have adm := fun (l : Place → Nat) => admits_one (k := .never) (t := 0) l only_habitat_near trivial
  ⟨⟨.near, rfl, fun same => absurd ((admits_one (k := .never) (t := 2) _ only_habitat_near
      trivial).mp (same.mpr ((admits_one (k := .never) (t := 2) _ only_habitat_near
      trivial).mpr (by decide : 3 ≤ 4)))) (by decide : ¬ 3 ≤ 2)⟩,
   fun g member t lt => Eq.subst (motive := fun h =>
       ((web .never).Admits (levels .never t) t h ↔ (web .never).Admits (levels .s0 t) t h))
     member.symm (match t, lt with
      | 0, _ => ⟨fun _ => (admits_one _ only_habitat_near trivial).mpr (by decide : 3 ≤ 4),
          fun _ => (admits_one _ only_habitat_near trivial).mpr (by decide : 3 ≤ 4)⟩
      | 1, _ => ⟨fun _ => (admits_one _ only_habitat_near trivial).mpr (by decide : 3 ≤ 4),
          fun _ => (admits_one _ only_habitat_near trivial).mpr (by decide : 3 ≤ 3)⟩
      | n + 2, lt => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 2 n)))⟩

/-- **The mid gauge is first apart at step 3.** -/
theorem mid_firstApart :
    (web .never).FirstApart (· = .mid) (levels .never) (levels .s0) 3 :=
  ⟨⟨.mid, rfl, fun same => absurd ((admits_one (k := .never) (t := 3) _ only_habitat_mid
      trivial).mp (same.mpr ((admits_one (k := .never) (t := 3) _ only_habitat_mid
      trivial).mpr (by decide : 2 ≤ 4)))) (by decide : ¬ 2 ≤ 1)⟩,
   fun g member t lt => Eq.subst (motive := fun h =>
       ((web .never).Admits (levels .never t) t h ↔ (web .never).Admits (levels .s0 t) t h))
     member.symm (match t, lt with
      | 0, _ => ⟨fun _ => (admits_one _ only_habitat_mid trivial).mpr (by decide : 2 ≤ 4),
          fun _ => (admits_one _ only_habitat_mid trivial).mpr (by decide : 2 ≤ 4)⟩
      | 1, _ => ⟨fun _ => (admits_one _ only_habitat_mid trivial).mpr (by decide : 2 ≤ 4),
          fun _ => (admits_one _ only_habitat_mid trivial).mpr (by decide : 2 ≤ 3)⟩
      | 2, _ => ⟨fun _ => (admits_one _ only_habitat_mid trivial).mpr (by decide : 2 ≤ 4),
          fun _ => (admits_one _ only_habitat_mid trivial).mpr (by decide : 2 ≤ 2)⟩
      | n + 3, lt => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 3 n)))⟩

/-- **The dweller's own continuation is first apart at step 4.** -/
theorem dweller_firstApart :
    (web .never).FirstApart (· = .dweller) (levels .never) (levels .s0) 4 :=
  ⟨⟨.dweller, rfl, fun same => absurd ((admits_one (k := .never) (t := 4) _ only_habitat_dweller
      trivial).mp (same.mpr ((admits_one (k := .never) (t := 4) _ only_habitat_dweller
      trivial).mpr (by decide : 1 ≤ 4)))) (by decide : ¬ 1 ≤ 0)⟩,
   fun g member t lt => Eq.subst (motive := fun h =>
       ((web .never).Admits (levels .never t) t h ↔ (web .never).Admits (levels .s0 t) t h))
     member.symm (match t, lt with
      | 0, _ => ⟨fun _ => (admits_one _ only_habitat_dweller trivial).mpr (by decide : 1 ≤ 4),
          fun _ => (admits_one _ only_habitat_dweller trivial).mpr (by decide : 1 ≤ 4)⟩
      | 1, _ => ⟨fun _ => (admits_one _ only_habitat_dweller trivial).mpr (by decide : 1 ≤ 4),
          fun _ => (admits_one _ only_habitat_dweller trivial).mpr (by decide : 1 ≤ 3)⟩
      | 2, _ => ⟨fun _ => (admits_one _ only_habitat_dweller trivial).mpr (by decide : 1 ≤ 4),
          fun _ => (admits_one _ only_habitat_dweller trivial).mpr (by decide : 1 ≤ 2)⟩
      | 3, _ => ⟨fun _ => (admits_one _ only_habitat_dweller trivial).mpr (by decide : 1 ≤ 4),
          fun _ => (admits_one _ only_habitat_dweller trivial).mpr (by decide : 1 ≤ 1)⟩
      | n + 4, lt => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 4 n)))⟩

/-- **The listener is first apart at step 3.** -/
theorem listener_firstApart :
    (web .never).FirstApart (· = .listener) (levels .never) (levels .s0) 3 :=
  ⟨⟨.listener, rfl, fun same => absurd ((admits_one (k := .never) (t := 3) _ only_news'_listener
      trivial).mp (same.mpr ((admits_one (k := .never) (t := 3) _ only_news'_listener
      trivial).mpr (by decide : 1 ≤ 1)))) (by decide : ¬ 1 ≤ 0)⟩,
   fun g member t lt => Eq.subst (motive := fun h =>
       ((web .never).Admits (levels .never t) t h ↔ (web .never).Admits (levels .s0 t) t h))
     member.symm (match t, lt with
      | 0, _ => ⟨fun _ => (admits_one _ only_news'_listener trivial).mpr (by decide : 1 ≤ 1),
          fun _ => (admits_one _ only_news'_listener trivial).mpr (by decide : 1 ≤ 1)⟩
      | 1, _ => ⟨fun _ => (admits_one _ only_news'_listener trivial).mpr (by decide : 1 ≤ 1),
          fun _ => (admits_one _ only_news'_listener trivial).mpr (by decide : 1 ≤ 1)⟩
      | 2, _ => ⟨fun _ => (admits_one _ only_news'_listener trivial).mpr (by decide : 1 ≤ 1),
          fun _ => (admits_one _ only_news'_listener trivial).mpr (by decide : 1 ≤ 1)⟩
      | n + 3, lt => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 3 n)))⟩

/-- **The near gauge can read the loss in time**: first apart at step 2, before the point of no
return. Its margin under the spared course is 1, and the gap reaches 2 at step 2. -/
theorem near_inTime :
    (web .never).ReadableInTime (· = .near) Feasible DwellerKept (levels .never) (levels .s0) ∧
      gap (habitat .never 1) 4 ≤ 4 - 3 ∧ ¬ gap (habitat .never 2) 4 ≤ 4 - 3 :=
  ⟨(Web.readableInTime_iff near_firstApart noReturn.1).mpr (by decide), Nat.le_refl 1,
   Nat.not_succ_le_self 1⟩

/-- **The mid gauge is first apart at the point, not readable in time, while the dweller still
stands.** -/
theorem mid_atThePoint :
    ¬ (web .never).ReadableInTime (· = .mid) Feasible DwellerKept (levels .never) (levels .s0) ∧
      (web .never).Admits (levels .never 3) 3 .dweller :=
  ⟨fun inTime => absurd ((Web.readableInTime_iff mid_firstApart noReturn.1).mp inTime)
     (Nat.lt_irrefl 3), noReturn.2.1⟩

/-- **The dweller's own continuation is first apart past the point.** Coupling the dweller in, the
way Bound's blindness lifts (`Clearing.turned_by_dweller_read`), tells the courses apart only at
step 4. -/
theorem dweller_late :
    ¬ (web .never).ReadableInTime (· = .dweller) Feasible DwellerKept (levels .never)
      (levels .s0) ∧ (web .never).FirstApart (· = .dweller) (levels .never) (levels .s0) 4 :=
  ⟨(Web.too_late_of_own (fun _ keep g member t => Eq.subst (motive := fun h =>
      (web .never).Admits _ t h) member.symm (keep t))
    (fun g member t => Eq.subst (motive := fun h => (web .never).Admits (levels .s0 t) t h)
      member.symm ((admits_one (k := .never) _ only_habitat_dweller trivial).mpr
        (by decide : 1 ≤ 4)))).1, dweller_firstApart⟩

/-- The clearer's occurrences are the source. -/
def source (_ : Nat) (h : Formation) : Prop := h = .clearer

theorem mem_clearer (t : Nat) : Formation.clearer ∈ (flow .never).present t := .head _
theorem mem_relay (t : Nat) : Formation.relay ∈ (flow .s0).present t :=
  .tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.head _)))))
theorem mem_relay' (t : Nat) : Formation.relay' ∈ (flow .s0).present t :=
  .tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.head _))))))

/-- **The closure in time meets the near gauge at step 1**: the clearer's draw at step 0 bears on
what it requires at step 1. -/
theorem near_reached :
    Flow.ReachedInTime (flow .never) (flow .s0) (web .never) thresholdOnly source .near 1 :=
  ⟨(0, .clearer), (0, .clearer), 1, rfl, WithinClosure.refl _,
   .inl ⟨Nat.zero_lt_one, .habitat, .inl trivial, mem_clearer 0, .inl Nat.zero_lt_one⟩,
   Nat.le_refl 1⟩

/-- **The closure in time meets the listener by step 3**: the clearer's draw at step 0 bears on
the first relay at step 1, whose giving at step 1 in the spared course bears on the second relay at
step 2, whose giving at step 2 bears on the listener at step 3. -/
theorem listener_reached :
    Flow.ReachedInTime (flow .never) (flow .s0) (web .never) thresholdOnly source .listener 3 :=
  ⟨(0, .clearer), (2, .relay'), 3, rfl,
   WithinClosure.trans
     (WithinClosure.of_rel (.inr (.inl ⟨Nat.zero_lt_one, .habitat, .inl trivial, mem_clearer 0,
       .inl Nat.zero_lt_one⟩)) : Flow.WithinTimeEither (flow .never) (flow .s0) (web .never)
         thresholdOnly (0, .clearer) (1, .relay))
     (WithinClosure.of_rel (.inr (.inr ⟨Nat.lt_succ_self 1, .news, .inl trivial, mem_relay 1,
       .inr Nat.zero_lt_one⟩)) : Flow.WithinTimeEither (flow .never) (flow .s0) (web .never)
         thresholdOnly (1, .relay) (2, .relay')),
   .inr ⟨Nat.lt_succ_self 2, .news', .inl trivial, mem_relay' 2, .inr Nat.zero_lt_one⟩,
   Nat.le_refl 3⟩

/-- Only the relays exchange with news. -/
theorem exchanges_news {k : Stop} {t : Nat} :
    ∀ f, (0 < (flow k).take t f .news ∨ 0 < (flow k).give t f .news) →
      f = .relay ∨ f = .relay'
  | .relay, _ => .inl rfl
  | .relay', _ => .inr rfl
  | .clearer, .inl pos => absurd pos (Nat.lt_irrefl 0)
  | .clearer, .inr pos => absurd pos (Nat.lt_irrefl 0)
  | .dweller, .inl pos => absurd pos (Nat.lt_irrefl 0)
  | .dweller, .inr pos => absurd pos (Nat.lt_irrefl 0)
  | .renewer, .inl pos => absurd pos (Nat.lt_irrefl 0)
  | .renewer, .inr pos => absurd pos (Nat.lt_irrefl 0)
  | .near, .inl pos => absurd pos (Nat.lt_irrefl 0)
  | .near, .inr pos => absurd pos (Nat.lt_irrefl 0)
  | .mid, .inl pos => absurd pos (Nat.lt_irrefl 0)
  | .mid, .inr pos => absurd pos (Nat.lt_irrefl 0)
  | .listener, .inl pos => absurd pos (Nat.lt_irrefl 0)
  | .listener, .inr pos => absurd pos (Nat.lt_irrefl 0)

/-- Only the second relay and the listener exchange with the second news. -/
theorem exchanges_news' {k : Stop} {t : Nat} :
    ∀ f, (0 < (flow k).take t f .news' ∨ 0 < (flow k).give t f .news') →
      f = .relay' ∨ f = .listener
  | .relay', _ => .inl rfl
  | .listener, _ => .inr rfl
  | .clearer, .inl pos => absurd pos (Nat.lt_irrefl 0)
  | .clearer, .inr pos => absurd pos (Nat.lt_irrefl 0)
  | .dweller, .inl pos => absurd pos (Nat.lt_irrefl 0)
  | .dweller, .inr pos => absurd pos (Nat.lt_irrefl 0)
  | .renewer, .inl pos => absurd pos (Nat.lt_irrefl 0)
  | .renewer, .inr pos => absurd pos (Nat.lt_irrefl 0)
  | .near, .inl pos => absurd pos (Nat.lt_irrefl 0)
  | .near, .inr pos => absurd pos (Nat.lt_irrefl 0)
  | .mid, .inl pos => absurd pos (Nat.lt_irrefl 0)
  | .mid, .inr pos => absurd pos (Nat.lt_irrefl 0)
  | .relay, .inl pos => absurd pos (Nat.lt_irrefl 0)
  | .relay, .inr pos => absurd pos (Nat.lt_irrefl 0)

/-- What is coupled, by threshold only, into the second relay is news, and into the listener the
second news. -/
theorem coupled_relay' {s : Nat} {c : Place}
    (coupled : TimedResponse.CoupledIntoAt (web .never) thresholdOnly .relay' s c) : c = .news :=
  match c, coupled with
  | .news, _ => rfl
  | .habitat, .inl r => False.elim r
  | .habitat, .inr no => False.elim no
  | .news', .inl r => False.elim r
  | .news', .inr no => False.elim no

theorem coupled_listener {s : Nat} {c : Place}
    (coupled : TimedResponse.CoupledIntoAt (web .never) thresholdOnly .listener s c) :
    c = .news' :=
  match c, coupled with
  | .news', _ => rfl
  | .habitat, .inl r => False.elim r
  | .habitat, .inr no => False.elim no
  | .news, .inl r => False.elim r
  | .news, .inr no => False.elim no

/-- No occurrence of the first relay before step 1, of the second before step 2, of the listener
before step 3. -/
def Early (y : Nat × Formation) : Prop :=
  (y.2 = .relay → 1 ≤ y.1) ∧ (y.2 = .relay' → 2 ≤ y.1) ∧ (y.2 = .listener → 3 ≤ y.1)

/-- An affecting step read through either course is an exchange, in one course, with a condition
coupled into the later occurrence. -/
theorem affects_exchange {a b : Nat × Formation}
    (affects : Flow.AffectsBeforeEither (flow .never) (flow .s0) (web .never) thresholdOnly a b) :
    ∃ c k, a.1 < b.1 ∧ TimedResponse.CoupledIntoAt (web .never) thresholdOnly b.2 b.1 c ∧
      (0 < (flow k).take a.1 a.2 c ∨ 0 < (flow k).give a.1 a.2 c) :=
  match affects with
  | .inl ⟨before, c, coupled, _, exchanges⟩ => ⟨c, .never, before, coupled, exchanges⟩
  | .inr ⟨before, c, coupled, _, exchanges⟩ => ⟨c, .s0, before, coupled, exchanges⟩

/-- **The closure in time keeps to its schedule**: from the clearer's occurrences, the first relay
is met no earlier than step 1, the second no earlier than step 2, the listener no earlier than
step 3. -/
theorem early_step {a b : Nat × Formation} (inside : Early a)
    (step : Flow.StepInTimeEither (flow .never) (flow .s0) (web .never) thresholdOnly a b) :
    Early b :=
  match step with
  | .inl ⟨next, same⟩ =>
    have later : ∀ m, m ≤ a.1 → m ≤ b.1 := fun _ le =>
      Eq.subst (motive := fun r => _ ≤ r) next.symm (Nat.le_succ_of_le le)
    ⟨fun hb => later 1 (inside.1 (same.symm.trans hb)),
     fun hb => later 2 (inside.2.1 (same.symm.trans hb)),
     fun hb => later 3 (inside.2.2 (same.symm.trans hb))⟩
  | .inr affects => match affects_exchange affects with
    | ⟨c, _, before, coupled, exchanges⟩ =>
      ⟨fun _ => Nat.succ_le_of_lt (Nat.lt_of_le_of_lt (Nat.zero_le _) before),
       fun hb =>
         have news : c = .news := coupled_relay' (Eq.subst (motive := fun h =>
           TimedResponse.CoupledIntoAt (web .never) thresholdOnly h b.1 c) hb coupled)
         match exchanges_news a.2 (Eq.subst (motive := fun d =>
             0 < (flow _).take a.1 a.2 d ∨ 0 < (flow _).give a.1 a.2 d) news exchanges) with
         | .inl relay => Nat.succ_le_of_lt (Nat.lt_of_le_of_lt (inside.1 relay) before)
         | .inr relay' => Nat.le_trans (Nat.le_succ 2)
             (Nat.succ_le_of_lt (Nat.lt_of_le_of_lt (inside.2.1 relay') before)),
       fun hb =>
         have news' : c = .news' := coupled_listener (Eq.subst (motive := fun h =>
           TimedResponse.CoupledIntoAt (web .never) thresholdOnly h b.1 c) hb coupled)
         match exchanges_news' a.2 (Eq.subst (motive := fun d =>
             0 < (flow _).take a.1 a.2 d ∨ 0 < (flow _).give a.1 a.2 d) news' exchanges) with
         | .inl relay' => Nat.succ_le_of_lt (Nat.lt_of_le_of_lt (inside.2.1 relay') before)
         | .inr listener => Nat.le_trans (Nat.le_succ 3)
             (Nat.succ_le_of_lt (Nat.lt_of_le_of_lt (inside.2.2 listener) before))⟩

/-- **The closure in time does not meet the listener by step 2.** -/
theorem listener_not_reached :
    ¬ Flow.ReachedInTime (flow .never) (flow .s0) (web .never) thresholdOnly source .listener 2 :=
  fun ⟨x, z, _, src, within, affects, le⟩ =>
    have base : Early x := ⟨fun hx => Formation.noConfusion (src.symm.trans hx),
      fun hx => Formation.noConfusion (src.symm.trans hx),
      fun hx => Formation.noConfusion (src.symm.trans hx)⟩
    have early := early_step (within Early (fun _ _ inside step => early_step inside step) base)
      (.inr affects)
    absurd (Nat.le_trans (early.2.2 rfl) le) (by decide)

/-- **The listener is first apart at the point, not readable in time.** The closure in time meets
the listener at step 3 and not by step 2, and it is first apart at step 3, the point of no return.
The relays and the listener each stand exactly at their need under the spared course (by `need` and
`levels`, not a stated theorem), so with no margin: read so, its first step apart comes when the
route arrives. -/
theorem listener_late :
    ¬ (web .never).ReadableInTime (· = .listener) Feasible DwellerKept (levels .never)
      (levels .s0) ∧
      Flow.ReachedInTime (flow .never) (flow .s0) (web .never) thresholdOnly source .listener 3 ∧
      ¬ Flow.ReachedInTime (flow .never) (flow .s0) (web .never) thresholdOnly source .listener 2 :=
  ⟨fun inTime => absurd ((Web.readableInTime_iff listener_firstApart noReturn.1).mp inTime)
     (Nat.lt_irrefl 3), listener_reached, listener_not_reached⟩

end FourReaders

end Becoming
