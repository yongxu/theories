import Becoming.Roles
import Becoming.Witnesses

/-!
# Reserve: activity beyond support, standing beyond activity

`Dependent` lets a formation be active only where the conditions it then depends on
support it, and `Embodied` lets a relatum stand as a condition only while it is active.
Both exclude what is held: buffers, reserves, lag and dormancy. This module states what
a reserve carries, and what generation bears where activity and standing are out of
step.

* **A reserve.** A reserve is an amount for each formation that does not rise across a
  step at which the formation is unsupported, and falls across each such step at which
  it is active (`Web.Carries`). `Dependent` is exactly the zero reserve
  (`carries_zero`): relaxing it means a positive reserve, not activity outside
  dependence.
* **A reserve can be a held condition.** In a balanced flow, a condition that nothing
  gives to while its holder is unsupported, and that is taken from, by whatever takes
  part, while the holder is active there, carries the holder, its standing being the
  reserve (`Flow.carries_of_held`). Where the holder itself takes part and takes from
  it, as a fox burns its fat, the reserve is the holder's own use
  (`Flow.carries_of_own`). Where no held condition is represented, the reserve is
  supplied: no condition of the seeds' webs carries them (`Seed.no_held`,
  `Viable.no_held`).
* **Lag as dependence moved.** An active formation whose dependences fail has a positive
  reserve (`Carries.pos`). Where a held condition carries the formations, the unfolding
  can be read with each unsupported dependence moved onto the held condition at need
  one, keeping levels, activity and drawing, and so read it is `Dependent` by
  construction (`Web.redirect`, `Web.redirect_dependent`, and
  `Famine.transformed_dependent`). This re-describes the reserve and adds no fact about
  the unfolding. The two readings differ in which events undermine: the fox's event at
  step one undermines as published and not when its dependence is moved onto its fat
  (`Famine.living_differs`), so the choice of reading bears on the stepwise valuation.
* **A reserve defers the end and does not escape it.** A formation unsupported from some
  step on is not active at arbitrarily late steps (`Carries.active_not_recurring`), and over any
  stretch at most as often as its reserve at the start (`Carries.lasts`, `Carries.lasts_within`).
  So after a loss without return with the dependence unchanged
  (`Carries.consumed_lasts`), and after the end of an embodied relatum it depends on at a
  positive need (`Carries.coextinct_lasts`), a formation is active beyond its support at
  most as often as its reserve: lagged ending and lagged coextinction. Dormancy defers
  the end the same way: unsupported, a formation does not arise at arbitrarily late steps
  (`Carries.arising_not_recurring`), and a reserve that decays while dormant, as a seed's
  viability, bounds the time as well (`Web.Decays`, `Carries.ends_within`). With such a
  reserve, coextinction runs down a chain of dependence of any length: each relatum of the
  chain has ended once the reserves of the links before it have passed, each read where
  the link before it ended (`Carries.chain_ends`, `Web.chainEnd`); with the zero reserve
  this is coextinction at once (`chainEnd_zero`). A food chain is finite, and so is every
  chain in a web whose dependences climb a bounded rank (`Web.no_unending_chain`); an
  unending chain is the case of every length. Without decay, with excluded middle as a
  hypothesis, each relatum of the chain still ends, at a step for which no bound is given
  (`Carries.chain_ends_of_em`). That step does not follow in general without omniscience:
  if every formation never supported, with a carried reserve and decided activity, had a
  step after which it is never active, even where it is active at most once, `LPO` would
  hold (`Web.lpo_of_ending`, `Once`). The bounds are attained, with their
  premises, by a seed waking twice in the dark on its reserve (`Seed`), by a seed waking
  once before its viability is spent (`Viable`), by a fox outliving the hare by its fat
  (`Famine`), by a chain in which each relatum outlives the one it depends on by one step
  (`Cascade`) and by that chain cut to three relata (`ShortCascade`).
* **Standing beyond activity.** Generation bears replenishment where a relatum comes to
  stand (`Becoming.Flow`, `Becoming.Dissipation`); an embodied relatum comes to stand as
  it arises (`Becoming.Roles`). A relatum that stands while it is active, and did not
  stand at some earlier step, came to stand across some step in between, perhaps long
  before it is active (`came_to_stand`): a seed is given its standing while dormant and
  arises later with nothing given to it (`Provisioned`). Waking from dormancy is arising
  without coming to stand, and nothing need be given to it, though the relatum stands as
  a condition throughout (`Sleeper`).

A reserve, like `Dependent`, is a premise supplied by the representation; which
condition a formation holds is supplied by the application, and where one is held,
which reading of the dependence is used is a correspondence premise bearing on the
valuation. That what is held is finite is the physical content. No ethical predicate,
ranking or axiom occurs.
* **Dormancy over a stretch, and final ending.** The decay and ending laws need their premises only
  over the stretch (`decays_by_on`, `ends_within_on`; the from-`S` forms their cases). An ending
  that is final stays whatever support returns (`ended_for_good`), so a return later than the
  reserve finds none (`late_return_finds_none`), while a reserve spanning the gap bridges it
  (`Bridged.bridged`).
-/

namespace Becoming

variable {F C : Type}

namespace Web

variable (W : Web F C)

/-- A reserve `r` *carries* activity beyond support: across a step at which a formation is
not supported, its reserve does not rise, and it falls if the formation is active there. -/
def Carries (r : Nat → F → Nat) : Prop :=
  ∀ t f, ¬ W.Supported t f → r (t + 1) f ≤ r t f ∧ (W.active t f → r (t + 1) f < r t f)

/-- A reserve `r` *decays* when it falls across every step at which its formation is not
supported and it is positive, whether or not the formation is active there: a seed's
viability. -/
def Decays (r : Nat → F → Nat) : Prop :=
  ∀ t f, ¬ W.Supported t f → 0 < r t f → r (t + 1) f < r t f

/-- A reserve `r` carries `f` across the step from `t`: if `f` is not supported there, its
reserve does not rise, and it falls if `f` is active there. `Carries` is this at every step
and formation. -/
def CarriesAcross (r : Nat → F → Nat) (t : Nat) (f : F) : Prop :=
  ¬ W.Supported t f → r (t + 1) f ≤ r t f ∧ (W.active t f → r (t + 1) f < r t f)

/-- And decays across it: if `f` is not supported there and its reserve is positive, the
reserve falls. `Decays` is this at every step and formation. -/
def DecaysAcross (r : Nat → F → Nat) (t : Nat) (f : F) : Prop :=
  ¬ W.Supported t f → 0 < r t f → r (t + 1) f < r t f

variable {W} {r : Nat → F → Nat}

/-- At one step and formation, the zero reserve carries it exactly when it is active there
only while supported. -/
theorem carries_zero_across {t : Nat} {f : F} :
    W.CarriesAcross (fun _ _ => 0) t f ↔ (W.active t f → W.Supported t f) :=
  ⟨fun carries active c depends => Nat.ge_of_not_lt fun short => Nat.lt_irrefl 0
      ((carries fun supported => Nat.not_le_of_gt short (supported c depends)).2 active),
   fun dependent unsupported =>
      ⟨Nat.le_refl 0, fun active => absurd (dependent active) unsupported⟩⟩

/-- `Dependent` is exactly the zero reserve. -/
theorem carries_zero : W.Carries (fun _ _ => 0) ↔ W.Dependent :=
  ⟨fun carries t f => carries_zero_across.mp (carries t f),
   fun dependent t f => carries_zero_across.mpr (dependent t f)⟩

/-- Carried across the step, an active formation whose dependences fail there has a positive
reserve. -/
theorem CarriesAcross.pos {t : Nat} {f : F} (carries : W.CarriesAcross r t f)
    (active : W.active t f) (unsupported : ¬ W.Supported t f) : 0 < r t f :=
  Nat.lt_of_le_of_lt (Nat.zero_le _) ((carries unsupported).2 active)

/-- An active formation whose dependences fail has a positive reserve. -/
theorem Carries.pos (carries : W.Carries r) {t : Nat} {f : F} (active : W.active t f)
    (unsupported : ¬ W.Supported t f) : 0 < r t f :=
  CarriesAcross.pos (carries t f) active unsupported

/-- Carried and unsupported from step `T` on, a formation is not active at arbitrarily late steps:
only that formation and those steps are used. -/
theorem active_not_recurring_from {f : F} {T : Nat} (carries : ∀ t, T ≤ t → W.CarriesAcross r t f)
    (unsupported : ∀ t, T ≤ t → ¬ W.Supported t f) : ¬ ∀ N, ∃ t, N ≤ t ∧ W.active t f :=
  fun recurs => falls_not_recurring (fun t => r t f) T
    (fun t later => (carries t later (unsupported t later)).1)
    fun N => match recurs (N + T) with
      | ⟨t, later, active⟩ =>
        have from_ := Nat.le_trans (Nat.le_add_left T N) later
        ⟨t, Nat.le_trans (Nat.le_add_right N T) later,
          (carries t from_ (unsupported t from_)).2 active⟩

/-- Unsupported from step `T` on, a formation is not active at arbitrarily late steps. -/
theorem Carries.active_not_recurring (carries : W.Carries r) {f : F} {T : Nat}
    (unsupported : ∀ t, T ≤ t → ¬ W.Supported t f) : ¬ ∀ N, ∃ t, N ≤ t ∧ W.active t f :=
  active_not_recurring_from (fun t _ => carries t f) unsupported

/-- Carried across an unsupported step, the reserve falls by at least one if the formation is
active. -/
theorem CarriesAcross.step {t : Nat} {f : F} [Decidable (W.active t f)]
    (carries : W.CarriesAcross r t f) (unsupported : ¬ W.Supported t f) :
    r (t + 1) f + mark (W.active t f) ≤ r t f :=
  mark_cases (q := fun m => r (t + 1) f + m ≤ r t f) (carries unsupported).2
    fun _ => (carries unsupported).1

/-- Across an unsupported step, the reserve falls by at least one if the formation is
active. -/
theorem Carries.step (carries : W.Carries r) {t : Nat} {f : F} [Decidable (W.active t f)]
    (unsupported : ¬ W.Supported t f) : r (t + 1) f + mark (W.active t f) ≤ r t f :=
  CarriesAcross.step (carries t f) unsupported

/-- Carried and unsupported across each step of a stretch, a formation is active over it at
most as often as its reserve at the start. Nothing is asked of other steps or formations. -/
theorem lasts_on {f : F} [∀ t, Decidable (W.active t f)] :
    ∀ S N, (∀ t, S ≤ t → t < S + N → W.CarriesAcross r t f) →
      (∀ t, S ≤ t → t < S + N → ¬ W.Supported t f) →
      r (S + N) f + total (steps S N) (fun t => mark (W.active t f)) ≤ r S f
  | _, 0, _, _ => Nat.le_refl _
  | S, N + 1, carries, unsupported =>
    have shift : ∀ t, t < S + 1 + N → t < S + (N + 1) := fun _ below =>
      Nat.lt_of_lt_of_le below (Nat.le_of_eq (Nat.add_right_comm S 1 N))
    have first : S < S + (N + 1) :=
      Nat.lt_of_lt_of_le (Nat.lt_succ_self S) (Nat.succ_le_succ (Nat.le_add_right S N))
    have later := lasts_on (S + 1) N
      (fun t after below => carries t (Nat.le_of_succ_le after) (shift t below))
      (fun t after below => unsupported t (Nat.le_of_succ_le after) (shift t below))
    Nat.le_trans
      (Nat.le_of_eq ((Nat.add_left_comm _ _ _).trans (congrArg
        (fun n => mark (W.active S f) + (r n f + total (steps (S + 1) N) fun t =>
          mark (W.active t f)))
        (Nat.add_right_comm S 1 N).symm)))
      (Nat.le_trans (Nat.add_le_add_left later _)
        (Nat.le_trans (Nat.le_of_eq (Nat.add_comm _ _))
          ((carries S (Nat.le_refl S) first).step (unsupported S (Nat.le_refl S) first))))

/-- Unsupported from step `S` on, a formation is active over any stretch of steps from
`S` at most as often as its reserve at `S`. -/
theorem Carries.lasts (carries : W.Carries r) {f : F} [∀ t, Decidable (W.active t f)] :
    ∀ S N, (∀ t, S ≤ t → ¬ W.Supported t f) →
      r (S + N) f + total (steps S N) (fun t => mark (W.active t f)) ≤ r S f :=
  fun S N unsupported => lasts_on S N (fun t _ _ => carries t f)
    fun t from_ _ => unsupported t from_

/-- With a reserve of capacity `k`, a formation unsupported from some step on is active
over any later stretch at most `k` times. -/
theorem Carries.lasts_within (carries : W.Carries r) {f : F} [∀ t, Decidable (W.active t f)]
    {k : Nat} (capacity : ∀ t, r t f ≤ k) (S N : Nat)
    (unsupported : ∀ t, S ≤ t → ¬ W.Supported t f) :
    total (steps S N) (fun t => mark (W.active t f)) ≤ k :=
  Nat.le_trans (Nat.le_trans (Nat.le_add_left _ _) (carries.lasts S N unsupported))
    (capacity S)

/-- Carried and unsupported from step `T` on, a formation does not arise at arbitrarily late
steps. -/
theorem arising_not_recurring_from {f : F} {T : Nat} (carries : ∀ t, T ≤ t → W.CarriesAcross r t f)
    (unsupported : ∀ t, T ≤ t → ¬ W.Supported t f) : ¬ ∀ N, ∃ t, N ≤ t ∧ W.Arises t f :=
  fun arising => active_not_recurring_from carries unsupported fun N => match arising N with
    | ⟨t, later, arises⟩ => ⟨t + 1, Nat.le_succ_of_le later, arises.2⟩

/-- Unsupported from step `T` on, a formation does not arise at arbitrarily late steps: dormancy
defers the end and does not escape it. -/
theorem Carries.arising_not_recurring (carries : W.Carries r) {f : F} {T : Nat}
    (unsupported : ∀ t, T ≤ t → ¬ W.Supported t f) : ¬ ∀ N, ∃ t, N ≤ t ∧ W.Arises t f :=
  arising_not_recurring_from (fun t _ => carries t f) unsupported

/-- **Bounded dormancy over a stretch.** Carried, decaying and unsupported across each of the `n`
steps from `S`, a reserve has, after them, fallen by `n` or been spent. Only that formation and
those steps are used. -/
theorem decays_by_on {f : F} {S : Nat} : ∀ n,
    (∀ t, S ≤ t → t < S + n → W.CarriesAcross r t f) →
    (∀ t, S ≤ t → t < S + n → W.DecaysAcross r t f) →
    (∀ t, S ≤ t → t < S + n → ¬ W.Supported t f) →
    r (S + n) f + n ≤ r S f ∨ r (S + n) f = 0
  | 0, _, _, _ => .inl (Nat.le_refl _)
  | n + 1, carries, decays, unsupported =>
    have from_ := Nat.le_add_right S n
    have last : S + n < S + (n + 1) := Nat.lt_succ_self (S + n)
    have step := carries (S + n) from_ last (unsupported (S + n) from_ last)
    have spent (empty : r (S + n) f = 0) : r (S + n + 1) f = 0 :=
      Nat.le_antisymm (Nat.le_trans step.1 (Nat.le_of_eq empty)) (Nat.zero_le _)
    match decays_by_on n (fun t a b => carries t a (Nat.lt_succ_of_lt b))
        (fun t a b => decays t a (Nat.lt_succ_of_lt b))
        (fun t a b => unsupported t a (Nat.lt_succ_of_lt b)),
      Nat.eq_zero_or_pos (r (S + n) f) with
    | .inr empty, _ => .inr (spent empty)
    | .inl _, .inl empty => .inr (spent empty)
    | .inl fell, .inr left => .inl (Nat.le_trans
        (Nat.le_of_eq (Nat.add_right_comm (r (S + n + 1) f) 1 n).symm)
        (Nat.le_trans (Nat.add_le_add_right (Nat.succ_le_of_lt
          (decays (S + n) from_ last (unsupported (S + n) from_ last) left)) n) fell))

/-- Carried, decaying and unsupported from step `S` on, a reserve has, after `n` steps,
fallen by `n` or been spent: only that formation and those steps are used. -/
theorem decays_by_from {f : F} {S : Nat} (carries : ∀ t, S ≤ t → W.CarriesAcross r t f)
    (decays : ∀ t, S ≤ t → W.DecaysAcross r t f) (unsupported : ∀ t, S ≤ t → ¬ W.Supported t f) :
    ∀ n, r (S + n) f + n ≤ r S f ∨ r (S + n) f = 0 :=
  fun n => decays_by_on n (fun t a _ => carries t a) (fun t a _ => decays t a)
    (fun t a _ => unsupported t a)

/-- Unsupported from step `S` on, a carried reserve that decays has, after `n` steps, fallen
by `n` or been spent. -/
theorem Carries.decays_by (carries : W.Carries r) (decays : W.Decays r) {f : F} {S : Nat}
    (unsupported : ∀ t, S ≤ t → ¬ W.Supported t f) :
    ∀ n, r (S + n) f + n ≤ r S f ∨ r (S + n) f = 0 :=
  decays_by_from (fun t _ => carries t f) (fun t _ => decays t f) unsupported

/-- **Bounded dormancy over a stretch**: carried, decaying and unsupported across the steps from
`S` up to `S + n`, a formation whose reserve at `S` is at most `n` is not active at `S + n`, and its
reserve is spent there. -/
theorem ends_within_on {f : F} {S n : Nat} (carries : ∀ t, S ≤ t → t ≤ S + n → W.CarriesAcross r t f)
    (decays : ∀ t, S ≤ t → t < S + n → W.DecaysAcross r t f)
    (unsupported : ∀ t, S ≤ t → t ≤ S + n → ¬ W.Supported t f) (spent : r S f ≤ n) :
    ¬ W.active (S + n) f ∧ r (S + n) f = 0 :=
  have gone : r (S + n) f = 0 :=
    match decays_by_on n (fun t a b => carries t a (Nat.le_of_lt b)) decays
        (fun t a b => unsupported t a (Nat.le_of_lt b)) with
    | .inl fell => Nat.eq_zero_of_le_zero (le_of_add_le_add_right n
        (Nat.le_trans fell (Nat.le_trans spent (Nat.le_of_eq (Nat.zero_add n).symm))))
    | .inr empty => empty
  ⟨fun active => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le
      ((carries (S + n) (Nat.le_add_right S n) (Nat.le_refl _)).pos active
        (unsupported (S + n) (Nat.le_add_right S n) (Nat.le_refl _)))
      (Nat.le_of_eq gone)),
   gone⟩

/-- Bounded dormancy, from step `S` on: carried, decaying and unsupported from `S` on, a
formation is not active once as many steps have passed as its reserve at `S`. -/
theorem ends_within_from {f : F} {S : Nat} (carries : ∀ t, S ≤ t → W.CarriesAcross r t f)
    (decays : ∀ t, S ≤ t → W.DecaysAcross r t f) (unsupported : ∀ t, S ≤ t → ¬ W.Supported t f)
    {n : Nat} (spent : r S f ≤ n) : ¬ W.active (S + n) f :=
  (ends_within_on (fun t a _ => carries t a) (fun t a _ => decays t a)
    (fun t a _ => unsupported t a) spent).1

/-- **An ending that is final stays.** Where, from `U` on, a formation inactive with its reserve
spent does not arise and its reserve does not rise, a formation inactive at `U` with its reserve
spent is inactive at every later step, whatever support comes back. -/
theorem ended_for_good {f : F} {U : Nat} (inactive : ¬ W.active U f) (spent : r U f = 0)
    (final : ∀ t, U ≤ t → ¬ W.active t f → r t f = 0 → ¬ W.Arises t f ∧ r (t + 1) f = 0) :
    ∀ k, ¬ W.active (U + k) f ∧ r (U + k) f = 0
  | 0 => ⟨inactive, spent⟩
  | k + 1 => match ended_for_good inactive spent final k with
    | ⟨before, empty⟩ => match final (U + k) (Nat.le_add_right U k) before empty with
      | ⟨stays, kept⟩ => ⟨fun after => stays ⟨before, after⟩, kept⟩

/-- **A return later than the reserve finds no one.** Carried, decaying and unsupported across the
steps from `S` to `S + n`, with a reserve at `S` of at most `n`, and an ending that is final from
`S + n` on, the formation is inactive at every step from `S + n` on: support restored after the
reserve is spent restores nothing. -/
theorem late_return_finds_none {f : F} {S n : Nat}
    (carries : ∀ t, S ≤ t → t ≤ S + n → W.CarriesAcross r t f)
    (decays : ∀ t, S ≤ t → t < S + n → W.DecaysAcross r t f)
    (unsupported : ∀ t, S ≤ t → t ≤ S + n → ¬ W.Supported t f) (spent : r S f ≤ n)
    (final : ∀ t, S + n ≤ t → ¬ W.active t f → r t f = 0 → ¬ W.Arises t f ∧ r (t + 1) f = 0) :
    ∀ k, ¬ W.active (S + n + k) f :=
  match ends_within_on carries decays unsupported spent with
  | ⟨inactive, gone⟩ => fun k => (ended_for_good inactive gone final k).1

/-- Bounded dormancy: unsupported from step `S` on, a formation whose carried reserve decays
is not active once as many steps have passed as its reserve at `S`. -/
theorem Carries.ends_within (carries : W.Carries r) (decays : W.Decays r) {f : F} {S : Nat}
    (unsupported : ∀ t, S ≤ t → ¬ W.Supported t f) {n : Nat} (spent : r S f ≤ n) :
    ¬ W.active (S + n) f :=
  ends_within_from (fun t _ => carries t f) (fun t _ => decays t f) unsupported spent

/-- After a loss without return with the dependence unchanged, a formation is not supported
at any later step. -/
theorem unsupported_after_loss {T : Nat} {g : F} {c : C}
    (fixed : ∀ t, T < t → W.requires t g c ∧ W.need T g c ≤ W.need t g c)
    (below : ∀ t, T < t → W.level t c < W.need T g c) : ∀ t, T < t → ¬ W.Supported t g :=
  fun t later supported => Nat.not_le_of_gt (below t later)
    (Nat.le_trans (fixed t later).2 (supported c (fixed t later).1))

/-- Lagged ending: after a loss without return with the dependence unchanged, a formation
with a reserve is not active at arbitrarily late steps, and over any stretch at most as often
as its reserve after the loss (`Carries.lasts`). Under `Dependent`, the zero reserve, it is not
active at all (`consumed_ends_when_fixed`). -/
theorem Carries.consumed_lasts (carries : W.Carries r) {T : Nat} {g : F} {c : C}
    (fixed : ∀ t, T < t → W.requires t g c ∧ W.need T g c ≤ W.need t g c)
    (below : ∀ t, T < t → W.level t c < W.need T g c) : ¬ ∀ N, ∃ t, N ≤ t ∧ W.active t g :=
  active_not_recurring_from (T := T + 1) (fun t _ => carries t g)
    (unsupported_after_loss fixed below)

end Web

/-! ## A reserve can be a held condition -/

namespace Flow

variable {L : Flow F C} {W : Web F C}

/-- With balance at the held condition across the step, where nothing gives to it while its
holder is unsupported there, and it is taken from while the holder is active there, it
carries the holder across that step. -/
theorem carriesAcross_of_held {t : Nat} {f : F} (hold : F → C)
    (balances : L.BalancesOn W [hold f] t)
    (unreplenished : ¬ W.Supported t f → L.given t (hold f) = 0)
    (drawn : ¬ W.Supported t f → W.active t f → 0 < L.taken t (hold f)) :
    W.CarriesAcross (fun t f => W.level t (hold f)) t f :=
  fun unsupported =>
    have balance : W.level (t + 1) (hold f) + L.taken t (hold f) = W.level t (hold f) :=
      (balances (hold f) (.head [])).trans
        (congrArg (W.level t (hold f) + ·) (unreplenished unsupported))
    ⟨Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq balance),
     fun active => Nat.lt_of_lt_of_le
       (Nat.lt_add_of_pos_right (drawn unsupported active)) (Nat.le_of_eq balance)⟩

/-- In a balanced flow, a condition that nothing gives to while its holder is unsupported,
and that is taken from, by whatever takes part, while the holder is active there, carries
the holder: its standing is the holder's reserve. -/
theorem carries_of_held (balances : L.Balances W) (hold : F → C)
    (unreplenished : ∀ t f, ¬ W.Supported t f → L.given t (hold f) = 0)
    (drawn : ∀ t f, ¬ W.Supported t f → W.active t f → 0 < L.taken t (hold f)) :
    W.Carries fun t f => W.level t (hold f) :=
  fun t f => carriesAcross_of_held hold (balances.on [hold f] t) (unreplenished t f) (drawn t f)

/-- Where the holder itself takes part and takes from what it holds at each step at which
it is unsupported and active, the held condition carries it: the holder's own use. -/
theorem carries_of_own (balances : L.Balances W) (hold : F → C)
    (unreplenished : ∀ t f, ¬ W.Supported t f → L.given t (hold f) = 0)
    (takes : ∀ t f, ¬ W.Supported t f → W.active t f →
      f ∈ L.present t ∧ 0 < L.take t f (hold f)) :
    W.Carries fun t f => W.level t (hold f) :=
  carries_of_held balances hold unreplenished fun t f unsupported active =>
    total_pos_of_mem (takes t f unsupported active).1 (takes t f unsupported active).2

end Flow

/-! ## Dependence moved onto the held condition -/

namespace Web

variable (W : Web F C) [∀ t f, Decidable (W.Supported t f)]

/-- The unfolding read with each formation's dependence, at each step at which it is not
supported, moved onto the condition it holds, at need one. -/
def redirect (hold : F → C) : Web F C :=
  { W with
    requires := fun t f c => if W.Supported t f then W.requires t f c else c = hold f
    need := fun t f c => if W.Supported t f then W.need t f c else 1 }

variable {W}

/-- Levels, activity and drawing are those of the unfolding. -/
theorem redirect_same (hold : F → C) :
    (W.redirect hold).level = W.level ∧ (W.redirect hold).active = W.active ∧
      (W.redirect hold).draws = W.draws :=
  ⟨rfl, rfl, rfl⟩

/-- Where a held condition carries a formation across a step, the redirected reading supports
it there while it is active: only that step and formation are used. -/
theorem redirect_supported_at {hold : F → C} {t : Nat} {f : F}
    (carries : W.CarriesAcross (fun t f => W.level t (hold f)) t f) (active : W.active t f) :
    (W.redirect hold).Supported t f :=
  fun c depends =>
    if supported : W.Supported t f then
      Nat.le_trans (Nat.le_of_eq (if_pos supported :
          (W.redirect hold).need t f c = W.need t f c))
        (supported c (Eq.mp (if_pos supported :
          (W.redirect hold).requires t f c = W.requires t f c) depends))
    else
      Nat.le_trans (Nat.le_of_eq (if_neg supported : (W.redirect hold).need t f c = 1))
        (Eq.subst (motive := fun y => 1 ≤ W.level t y)
          (Eq.mp (if_neg supported : (W.redirect hold).requires t f c = (c = hold f))
            depends).symm
          (carries.pos active supported))

/-- Wherever a held condition carries the formations, the redirected reading is
`Dependent` by construction: lag is dependence moved onto the held condition. -/
theorem redirect_dependent {hold : F → C} (carries : W.Carries fun t f => W.level t (hold f)) :
    (W.redirect hold).Dependent :=
  fun t f active => redirect_supported_at (carries t f) active

end Web

/-! ## One kind of relatum -/

namespace Web

variable {X : Type} {W : Web X X}

/-- After an embodied relatum ends, a formation depending on it at a positive need is not
supported. -/
theorem unsupported_after_end {y g : X} (embodied : W.Embodied y) {T : Nat}
    (bears : ∀ t, T ≤ t → W.requires t g y ∧ 0 < W.need t g y)
    (ended : ∀ t, T ≤ t → ¬ W.active t y) : ∀ t, T ≤ t → ¬ W.Supported t g :=
  fun t later supported => ended t later ((embodied t).mpr
    (Nat.lt_of_lt_of_le (bears t later).2 (supported y (bears t later).1)))

/-- Lagged coextinction: after an embodied relatum ends, a formation depending on it at a
positive need, with a reserve, is not active at arbitrarily late steps, and over any stretch at
most as often as its reserve when the relatum ended (`Carries.lasts`). Under `Dependent` it ends
with it (`coextinct`). -/
theorem Carries.coextinct_lasts {r : Nat → X → Nat} (carries : W.Carries r) {y g : X}
    (embodied : W.Embodied y) {T : Nat}
    (bears : ∀ t, T ≤ t → W.requires t g y ∧ 0 < W.need t g y)
    (ended : ∀ t, T ≤ t → ¬ W.active t y) : ¬ ∀ N, ∃ t, N ≤ t ∧ W.active t g :=
  active_not_recurring_from (fun t _ => carries t g) (unsupported_after_end embodied bears ended)

/-- When each link of a chain has ended: the first at `T`, each later one once its reserve,
read when the link before it has ended, has passed. -/
def chainEnd (r : Nat → X → Nat) (chain : Nat → X) (T : Nat) : Nat → Nat
  | 0 => T
  | k + 1 => chainEnd r chain T k + r (chainEnd r chain T k) (chain (k + 1))

theorem chainEnd_ge (r : Nat → X → Nat) (chain : Nat → X) (T : Nat) :
    ∀ k, T ≤ chainEnd r chain T k
  | 0 => Nat.le_refl T
  | k + 1 => Nat.le_trans (chainEnd_ge r chain T k) (Nat.le_add_right _ _)

/-- With the zero reserve every link has ended when the first has: `Carries.chain_ends`
is then coextinction at once along the chain, as `coextinct`. -/
theorem chainEnd_zero (chain : Nat → X) (T : Nat) :
    ∀ k, chainEnd (fun _ _ => 0) chain T k = T
  | 0 => rfl
  | k + 1 => chainEnd_zero chain T k

/-- Coextinction along a chain, carried and decaying at its links only: as
`Carries.chain_ends`, with the reserve carrying and decaying the links after the first from
step `T` on, and nothing asked of other formations. -/
theorem chain_ends_from {r : Nat → X → Nat} {chain : Nat → X} {n : Nat} {T : Nat}
    (carries : ∀ k t, k < n → T ≤ t → W.CarriesAcross r t (chain (k + 1)))
    (decays : ∀ k t, k < n → T ≤ t → W.DecaysAcross r t (chain (k + 1)))
    (embodied : ∀ k, k < n → W.Embodied (chain k))
    (bears : ∀ k t, k < n → T ≤ t →
      W.requires t (chain (k + 1)) (chain k) ∧ 0 < W.need t (chain (k + 1)) (chain k))
    (ended : ∀ t, T ≤ t → ¬ W.active t (chain 0)) :
    ∀ k, k ≤ n → ∀ t, chainEnd r chain T k ≤ t → ¬ W.active t (chain k)
  | 0, _ => ended
  | k + 1, within => fun _ later active =>
    have start := chainEnd_ge r chain T k
    have unsupported := unsupported_after_end (embodied k within)
      (fun s from_ => bears k s within (Nat.le_trans start from_))
      (chain_ends_from carries decays embodied bears ended k (Nat.le_of_succ_le within))
    match le_dest later with
    | ⟨m, same⟩ => ends_within_from (fun t from_ => carries k t within (Nat.le_trans start from_))
        (fun t from_ => decays k t within (Nat.le_trans start from_)) unsupported
        (Nat.le_add_right _ m)
        (Eq.subst (motive := fun s => W.active s (chain (k + 1)))
          (same.trans (Nat.add_assoc _ _ m)) active)

/-- Coextinction along a chain: where, in a chain of `n` links, each relatum depends at a
positive need on the one before it from step `T` on, the relata depended on are embodied,
the reserve decays, and the first has ended from `T`, each relatum up to the `n`th has
ended once the reserves of the links before it have passed (`chainEnd`). Each link
outlasts the one before it by at most its reserve at that one's end. A food chain is such
a chain; an unending chain is the case of every `n`. -/
theorem Carries.chain_ends {r : Nat → X → Nat} (carries : W.Carries r) (decays : W.Decays r)
    {chain : Nat → X} {n : Nat} (embodied : ∀ k, k < n → W.Embodied (chain k)) {T : Nat}
    (bears : ∀ k t, k < n → T ≤ t →
      W.requires t (chain (k + 1)) (chain k) ∧ 0 < W.need t (chain (k + 1)) (chain k))
    (ended : ∀ t, T ≤ t → ¬ W.active t (chain 0)) :
    ∀ k, k ≤ n → ∀ t, chainEnd r chain T k ≤ t → ¬ W.active t (chain k) :=
  chain_ends_from (fun k t _ _ => carries t (chain (k + 1))) (fun k t _ _ => decays t (chain (k + 1)))
    embodied bears ended

/-- Coextinction along a chain without decay, carried at its links only: as
`Carries.chain_ends_of_em`, with the reserve carrying the links after the first from step `T`
on, and nothing asked of other formations. -/
theorem chain_ends_of_em_from (em : ∀ P : Prop, P ∨ ¬ P) {r : Nat → X → Nat}
    {chain : Nat → X} {n : Nat} {T : Nat}
    (carries : ∀ k t, k < n → T ≤ t → W.CarriesAcross r t (chain (k + 1)))
    (embodied : ∀ k, k < n → W.Embodied (chain k))
    (bears : ∀ k t, k < n → T ≤ t →
      W.requires t (chain (k + 1)) (chain k) ∧ 0 < W.need t (chain (k + 1)) (chain k))
    (ended : ∀ t, T ≤ t → ¬ W.active t (chain 0)) :
    ∀ k, k ≤ n → ∃ E, T ≤ E ∧ ∀ t, E ≤ t → ¬ W.active t (chain k)
  | 0, _ => ⟨T, Nat.le_refl T, ended⟩
  | k + 1, within => match chain_ends_of_em_from em carries embodied bears ended k
      (Nat.le_of_succ_le within) with
    | ⟨E, from_T, gone⟩ =>
      match exists_not_of_em em (active_not_recurring_from (T := E)
          (fun t from_ => carries k t within (Nat.le_trans from_T from_))
          (unsupported_after_end (embodied k within)
            (fun s from_ => bears k s within (Nat.le_trans from_T from_)) gone)) with
      | ⟨N, quiet⟩ => ⟨E + N, Nat.le_trans from_T (Nat.le_add_right E N),
          fun t later active => quiet ⟨t, Nat.le_trans (Nat.le_add_left N E) later, active⟩⟩

/-- Coextinction along a chain without decay: with excluded middle as a hypothesis, where,
in a chain of `n` links, each relatum depends at a positive need on the one before it from
step `T` on, the relata depended on are embodied and the first has ended from `T`, each
relatum up to the `n`th has ended from some step. No bound is given: a dormant link can
wake arbitrarily late (`Seed`). -/
theorem Carries.chain_ends_of_em (em : ∀ P : Prop, P ∨ ¬ P) {r : Nat → X → Nat}
    (carries : W.Carries r) {chain : Nat → X} {n : Nat}
    (embodied : ∀ k, k < n → W.Embodied (chain k)) {T : Nat}
    (bears : ∀ k t, k < n → T ≤ t →
      W.requires t (chain (k + 1)) (chain k) ∧ 0 < W.need t (chain (k + 1)) (chain k))
    (ended : ∀ t, T ≤ t → ¬ W.active t (chain 0)) :
    ∀ k, k ≤ n → ∃ E, T ≤ E ∧ ∀ t, E ≤ t → ¬ W.active t (chain k) :=
  chain_ends_of_em_from em (fun k t _ _ => carries t (chain (k + 1))) embodied bears ended

theorem climbs {ρ : X → Nat} {chain : Nat → X}
    (up : ∀ k, ρ (chain k) < ρ (chain (k + 1))) : ∀ k, k ≤ ρ (chain k)
  | 0 => Nat.zero_le _
  | k + 1 => Nat.lt_of_le_of_lt (climbs up k) (up k)

/-- Where every dependence climbs a rank bounded by `K`, as in every finite web without a
cycle of dependence, no chain of dependence goes on without end: chains there are finite,
as a food chain is. -/
theorem no_unending_chain {ρ : X → Nat} {K : Nat}
    (ranked : ∀ t g c, W.requires t g c → ρ c < ρ g ∧ ρ g ≤ K) {chain : Nat → X} {T : Nat}
    (bears : ∀ k t, T ≤ t →
      W.requires t (chain (k + 1)) (chain k) ∧ 0 < W.need t (chain (k + 1)) (chain k)) :
    False :=
  Nat.not_succ_le_self K (Nat.le_trans
    (climbs (fun k => (ranked T _ _ (bears k T (Nat.le_refl T)).1).1) (K + 1))
    (ranked T _ _ (bears K T (Nat.le_refl T)).1).2)

/-- A relatum standing while it is active, without standing at `T` and active at a later
`t`, came to stand across some step between them. -/
theorem came_to_stand {x : X} (stands : ∀ t, W.active t x → 0 < W.level t x) {T t : Nat}
    (le : T ≤ t) (absent : ¬ 0 < W.level T x) (active : W.active t x) :
    ¬ ∀ s, T ≤ s → s < t → ¬ W.ComesToStand s x :=
  arises_at_a_step (p := fun s => 0 < W.level s x) le absent (stands t active)

end Web

/-! ## Witnesses -/

namespace Seed

/-- Awake at steps one and three. -/
def wake : Nat → Nat := Witnesses.profile [0, 1, 0, 1] 0

/-- Two units until the seed first wakes, one until it wakes again, then none. -/
def reserve : Nat → Nat := Witnesses.profile [2, 2, 1, 1] 0

/-- A seed in the dark, depending on light at need one, awake at steps one and three. -/
def web : Web Unit Unit where
  level _ _ := 0
  active t _ := 0 < wake t
  requires _ _ _ := True
  need _ _ _ := 1
  draws _ _ _ := False

instance decAwake (t : Nat) : Decidable (web.active t ()) := Nat.decLt 0 (wake t)

/-- The seed is never supported. -/
theorem dark (t : Nat) : ¬ web.Supported t () :=
  fun supported => Nat.not_succ_le_zero 0 (supported () trivial)

/-- The reserve carries the seed. -/
theorem carries : web.Carries fun t _ => reserve t
  | 0, (), _ => ⟨Nat.le_refl 2, fun awake => absurd awake (Nat.lt_irrefl 0)⟩
  | 1, (), _ => ⟨Nat.le_succ 1, fun _ => Nat.lt_succ_self 1⟩
  | 2, (), _ => ⟨Nat.le_refl 1, fun awake => absurd awake (Nat.lt_irrefl 0)⟩
  | 3, (), _ => ⟨Nat.zero_le 1, fun _ => Nat.zero_lt_one⟩
  | _ + 4, (), _ => ⟨Nat.le_refl 0, fun awake => absurd awake (Nat.lt_irrefl 0)⟩

/-- Dormant and awake by turns in the dark, the seed arises twice and then never: it is not
`Dependent`, its reserve carries it, and it is awake exactly as often as its reserve at
the start. -/
theorem seed : ¬ web.Dependent ∧ web.Carries (fun t _ => reserve t) ∧
    web.Arises 0 () ∧ web.Arises 2 () ∧ (∀ t, ¬ web.active (t + 4) ()) ∧
    total (steps 0 4) (fun t => mark (web.active t ())) = reserve 0 :=
  ⟨fun dependent => dark 1 (dependent 1 () Nat.zero_lt_one), carries,
   ⟨Nat.lt_irrefl 0, Nat.zero_lt_one⟩, ⟨Nat.lt_irrefl 0, Nat.zero_lt_one⟩,
   fun _ awake => Nat.lt_irrefl 0 awake, rfl⟩

/-- The seed's reserve does not decay: it keeps both units while the seed is dormant at
step zero. -/
theorem not_decays : ¬ web.Decays fun t _ => reserve t :=
  fun decays => Nat.lt_irrefl 2 (decays 0 () (dark 0) (Nat.succ_pos 1))

/-- The reserve is supplied, not held: every level of the web is zero, and the seed is
active and unsupported at step one, so no condition of the web carries it. -/
theorem no_held (hold : Unit → Unit) : ¬ web.Carries fun t f => web.level t (hold f) :=
  fun carries => Nat.lt_irrefl 0 (carries.pos (t := 1) (f := ()) Nat.zero_lt_one (dark 1))

end Seed

namespace Viable

/-- Viability: three units, falling by one at every step until none is left. -/
def viability : Nat → Nat := Witnesses.profile [3, 2, 1] 0

/-- A seed in the dark, depending on light at need one, awake only at step two. -/
def web : Web Unit Unit where
  level _ _ := 0
  active t _ := t = 2
  requires _ _ _ := True
  need _ _ _ := 1
  draws _ _ _ := False

/-- The seed is never supported. -/
theorem dark (t : Nat) : ¬ web.Supported t () :=
  fun supported => Nat.not_succ_le_zero 0 (supported () trivial)

/-- Its viability carries it. -/
theorem carries : web.Carries fun t _ => viability t
  | 0, (), _ => ⟨Nat.le_succ 2, fun _ => Nat.lt_succ_self 2⟩
  | 1, (), _ => ⟨Nat.le_succ 1, fun _ => Nat.lt_succ_self 1⟩
  | 2, (), _ => ⟨Nat.zero_le 1, fun _ => Nat.zero_lt_one⟩
  | _ + 3, (), _ => ⟨Nat.le_refl 0, fun awake => absurd awake (Nat.ne_of_gt
      (Nat.lt_of_lt_of_le (Nat.lt_succ_self 2) (Nat.le_add_left 3 _)))⟩

/-- Its viability decays. -/
theorem decays : web.Decays fun t _ => viability t
  | 0, (), _, _ => Nat.lt_succ_self 2
  | 1, (), _, _ => Nat.lt_succ_self 1
  | 2, (), _, _ => Nat.zero_lt_one
  | _ + 3, (), _, positive => absurd positive (Nat.lt_irrefl 0)

/-- Dormant in the dark on a decaying reserve of three, the seed wakes at step two and never
after: it is not `Dependent`, and it is inactive from the step its viability is spent, so
the bound of `Carries.ends_within` is attained. -/
theorem viable : ¬ web.Dependent ∧ web.Carries (fun t _ => viability t) ∧
    web.Decays (fun t _ => viability t) ∧ web.Arises 1 () ∧ ∀ t, ¬ web.active (t + 3) () :=
  ⟨fun dependent => dark 2 (dependent 2 () rfl), carries, decays,
   ⟨fun awake => Nat.succ_ne_self 1 awake.symm, rfl⟩,
   fun t awake => Nat.ne_of_gt (Nat.lt_of_lt_of_le (Nat.lt_succ_self 2) (Nat.le_add_left 3 t))
     awake⟩

/-- Its viability is supplied, not held: no condition of the web, all at zero, carries the
seed, active and unsupported at step two. -/
theorem no_held (hold : Unit → Unit) : ¬ web.Carries fun t f => web.level t (hold f) :=
  fun carries => Nat.lt_irrefl 0 (carries.pos (t := 2) (f := ()) rfl (dark 2))

end Viable

namespace Famine

/-- A hare, a fox, and the fox's fat. -/
inductive Relatum where
  | hare
  | fox
  | fat

/-- The hare stands at step zero only. -/
def hare : Nat → Nat := Witnesses.profile [1] 0

/-- The fat stands at two units through step one, at one at step two, then at none. -/
def fat : Nat → Nat := Witnesses.profile [2, 2, 1] 0

/-- The fox eats the hare across step zero. -/
def eats : Nat → Nat := Witnesses.profile [1] 0

/-- The fox burns a unit of fat across steps one and two. -/
def burns : Nat → Nat := Witnesses.profile [0, 1, 1] 0

/-- The fox takes part through step two. -/
def present : Nat → List Relatum
  | 0 => [.fox]
  | 1 => [.fox]
  | 2 => [.fox]
  | _ => []

/-- The hare is active exactly while it stands; the fox, through step two, depends on the
hare at need one and draws on the hare and its fat; the fat is never active. -/
def web : Web Relatum Relatum where
  level t x := match x with
    | .hare => hare t
    | .fox => 0
    | .fat => fat t
  active t x := match x with
    | .hare => 0 < hare t
    | .fox => t < 3
    | .fat => False
  requires _ g y := g = .fox ∧ y = .hare
  need _ _ _ := 1
  draws _ g y := g = .fox ∧ (y = .hare ∨ y = .fat)

/-- The fox eats the hare, then burns its fat. -/
def flow : Flow Relatum Relatum where
  present := present
  take t g y := match g, y with
    | .fox, .hare => eats t
    | .fox, .fat => burns t
    | .fox, .fox => 0
    | .hare, _ => 0
    | .fat, _ => 0
  give _ _ _ := 0

/-- Each relatum holds itself, except the fox, which holds its fat. -/
def hold : Relatum → Relatum
  | .hare => .hare
  | .fox => .fat
  | .fat => .fat

theorem balances : flow.Balances web
  | 0, .hare | 0, .fox | 0, .fat => rfl
  | 1, .hare | 1, .fox | 1, .fat => rfl
  | 2, .hare | 2, .fox | 2, .fat => rfl
  | _ + 3, .hare | _ + 3, .fox | _ + 3, .fat => rfl

/-- Only the fox depends on anything. -/
theorem supported_of_ne_fox {t : Nat} : (x : Relatum) → ¬ x = .fox → web.Supported t x
  | .hare, _ => fun _ depends => nomatch depends.1
  | .fat, _ => fun _ depends => nomatch depends.1
  | .fox, ne => absurd rfl ne

/-- The fox is supported at step zero, while the hare stands. -/
theorem fed : web.Supported 0 .fox :=
  fun _ depends => Eq.subst (motive := fun y => 1 ≤ web.level 0 y) depends.2.symm
    (Nat.le_refl 1)

/-- The fat carries the fox: the flow balances, nothing gives to the fat, and the fox takes
part and burns it at each unsupported active step. -/
theorem carries : web.Carries fun t x => web.level t (hold x) :=
  Flow.carries_of_own balances hold (fun _ _ _ => total_zero _) fun t x unsupported active =>
    match x, t, unsupported, active with
    | .hare, _, unsupported, _ =>
      absurd (supported_of_ne_fox .hare fun same => nomatch same) unsupported
    | .fat, _, unsupported, _ =>
      absurd (supported_of_ne_fox .fat fun same => nomatch same) unsupported
    | .fox, 0, unsupported, _ => absurd fed unsupported
    | .fox, 1, _, _ => ⟨.head [], Nat.zero_lt_one⟩
    | .fox, 2, _, _ => ⟨.head [], Nat.zero_lt_one⟩
    | .fox, _ + 3, _, active => absurd active (Nat.not_lt_of_le (Nat.le_add_left 3 _))

/-- The hare is embodied. -/
theorem hare_embodied : web.Embodied .hare :=
  fun _ => Iff.rfl

/-- What the fox depends on: the hare at step zero, its fat after. -/
def source : Nat → Relatum
  | 0 => .hare
  | _ => .fat

/-- The same unfolding read with the fox's dependence transformed onto its fat once the
hare is gone. -/
def transformed : Web Relatum Relatum :=
  { web with requires := fun t g y => g = .fox ∧ y = source t }

/-- Read so, activity needs support, as `Web.redirect_dependent` gives wherever a held
condition carries the formations. -/
theorem transformed_dependent : transformed.Dependent
  | 0, .fox, _ => fun _ depends => Eq.subst (motive := fun y => 1 ≤ transformed.level 0 y)
      depends.2.symm (Nat.le_refl 1)
  | 1, .fox, _ => fun _ depends => Eq.subst (motive := fun y => 1 ≤ transformed.level 1 y)
      depends.2.symm (Nat.le_succ 1)
  | 2, .fox, _ => fun _ depends => Eq.subst (motive := fun y => 1 ≤ transformed.level 2 y)
      depends.2.symm (Nat.le_refl 1)
  | _ + 3, .fox, active => absurd active (Nat.not_lt_of_le (Nat.le_add_left 3 _))
  | _, .hare, _ => fun _ depends => nomatch depends.1
  | _, .fat, _ => fun _ depends => nomatch depends.1

instance decActive (t : Nat) : Decidable (web.active t .fox) := Nat.decLt t 3

/-- As published, the fox's event at step one undermines: it draws on the hare, its
dependence on which it met at step zero, and the hare is below need after the step. -/
theorem undermines_one : web.UnderminingAt 1 .fox :=
  ⟨.hare, ⟨rfl, .inl rfl⟩, .fox, ⟨rfl, rfl⟩,
   ⟨0, Nat.zero_le 1, fun _ _ _ => ⟨rfl, rfl⟩, Nat.le_refl 1, Nat.zero_lt_one⟩,
   Nat.zero_lt_one⟩

/-- With its dependence moved onto its fat, the same event does not undermine: the fat
stands at one after the step, which meets the need. -/
theorem transformed_not_undermining : ¬ transformed.UnderminingAt 1 .fox :=
  fun ⟨_, _, _, ⟨_, same⟩, _, below⟩ =>
    Nat.lt_irrefl 1 (Eq.subst (motive := fun y => transformed.level 2 y < 1) same below)

/-- The two readings differ in which events are living in the stepwise reading (active
and not undermining): the fox is active at step one under both, and its event there
undermines only as published. -/
theorem living_differs :
    (web.active 1 .fox ∧ web.UnderminingAt 1 .fox) ∧
    (transformed.active 1 .fox ∧ ¬ transformed.UnderminingAt 1 .fox) :=
  ⟨⟨Nat.lt_succ_of_lt (Nat.lt_succ_self 1), undermines_one⟩,
   ⟨Nat.lt_succ_of_lt (Nat.lt_succ_self 1), transformed_not_undermining⟩⟩

/-- Lagged coextinction: the fox depends on the embodied hare, which ends after step zero.
The fox is not `Dependent`; its fat carries it, and it outlives the hare by exactly the
two units of its fat. Read with its dependence moved onto the fat, with the same levels,
activity, drawing and flow, it is `Dependent`. -/
theorem famine : ¬ web.Dependent ∧ web.Carries (fun t x => web.level t (hold x)) ∧
    web.Embodied .hare ∧ (∀ t, 1 ≤ t → ¬ web.active t .hare) ∧
    (∀ t, 1 ≤ t → web.requires t .fox .hare ∧ 0 < web.need t .fox .hare) ∧
    web.active 2 .fox ∧ (∀ t, 3 ≤ t → ¬ web.active t .fox) ∧
    total (steps 1 2) (fun t => mark (web.active t .fox)) = web.level 1 (hold .fox) ∧
    transformed.Dependent :=
  ⟨fun dependent => Nat.not_succ_le_zero 0
      (dependent 1 .fox (Nat.le_succ 2) .hare ⟨rfl, rfl⟩),
   carries, hare_embodied,
   fun t later => match t, later with
     | 0, later => absurd later (Nat.not_succ_le_zero 0)
     | _ + 1, _ => Nat.lt_irrefl 0,
   fun _ _ => ⟨⟨rfl, rfl⟩, Nat.zero_lt_one⟩,
   Nat.lt_succ_self 2,
   fun _ later => Nat.not_lt_of_le later, rfl, transformed_dependent⟩

end Famine

namespace Cascade

/-- One through step `x`, then nothing. -/
def upto : Nat → Nat → Nat
  | 0, _ => 1
  | _ + 1, 0 => 0
  | t + 1, x + 1 => upto t x

theorem upto_pos : ∀ {t x : Nat}, 0 < upto t x ↔ t ≤ x
  | 0, _ => ⟨fun _ => Nat.zero_le _, fun _ => Nat.zero_lt_one⟩
  | _ + 1, 0 => ⟨fun pos => absurd pos (Nat.lt_irrefl 0),
      fun le => absurd le (Nat.not_succ_le_zero _)⟩
  | t + 1, x + 1 => (upto_pos (t := t) (x := x)).trans
      ⟨Nat.succ_le_succ, Nat.le_of_succ_le_succ⟩

theorem upto_le_one : ∀ t x, upto t x ≤ 1
  | 0, _ => Nat.le_refl 1
  | _ + 1, 0 => Nat.zero_le 1
  | t + 1, x + 1 => upto_le_one t x

theorem upto_after : ∀ x, upto (x + 1) x = 0
  | 0 => rfl
  | x + 1 => upto_after x

theorem upto_self : ∀ x, upto x x = 1
  | 0 => rfl
  | x + 1 => upto_self x

/-- Relatum `x` is active through step `x`, standing at one while active; relatum `x + 1`
depends on relatum `x` at need one. -/
def web : Web Nat Nat where
  level t x := upto t x
  active t x := t ≤ x
  requires _ x c := x = c + 1
  need _ _ _ := 1
  draws _ _ _ := False

theorem embodied (x : Nat) : web.Embodied x :=
  fun _ => upto_pos.symm

/-- Relatum `x + 1` is supported exactly through step `x`; relatum `0` depends on nothing. -/
theorem supported_of_le {t x : Nat} (le : t ≤ x) : web.Supported t (x + 1) :=
  fun _ same => match Nat.succ.inj same with
    | rfl => upto_pos.mpr le

theorem unsupported_late {t x : Nat} (unsupported : ¬ web.Supported t x) : x ≤ t :=
  match x with
  | 0 => Nat.zero_le t
  | _ + 1 => Nat.gt_of_not_le fun le => unsupported (supported_of_le le)

/-- The reserve: one through step `x`. -/
def reserve (t x : Nat) : Nat := upto t x

/-- At an unsupported step at which relatum `x` is active, the step is `x`, its last. -/
theorem falls {t x : Nat} (unsupported : ¬ web.Supported t x) (active : t ≤ x) :
    reserve (t + 1) x < reserve t x :=
  match Nat.le_antisymm active (unsupported_late unsupported) with
  | rfl => Nat.lt_of_lt_of_le (Nat.lt_of_le_of_lt (Nat.le_of_eq (upto_after t))
      Nat.zero_lt_one) (Nat.le_of_eq (upto_self t).symm)

theorem never_rises : ∀ t x, reserve (t + 1) x ≤ reserve t x
  | 0, _ => upto_le_one _ _
  | _ + 1, 0 => Nat.le_refl 0
  | t + 1, x + 1 => never_rises t x

theorem carries : web.Carries reserve :=
  fun _ _ unsupported => ⟨never_rises _ _, falls unsupported⟩

theorem decays : web.Decays reserve :=
  fun _ _ unsupported positive => falls unsupported (upto_pos.mp positive)

theorem ends (k : Nat) : Web.chainEnd reserve (fun k => k) 1 k = k + 1 :=
  match k with
  | 0 => rfl
  | k + 1 => (congrArg (fun e => e + reserve e (k + 1)) (ends k)).trans
      (congrArg (k + 1 + ·) (upto_self (k + 1)))

/-- The bound of `Carries.chain_ends` is attained: relatum `0` ends after step zero, each
relatum depends on the one before it and outlasts it by its reserve of one, and relatum
`k` is still active at step `k`, the last step before `chainEnd`. Without the reserve the
chain would end at once: relatum `1` is active at step one unsupported. -/
theorem cascade : web.Carries reserve ∧ web.Decays reserve ∧ (∀ x, web.Embodied x) ∧
    (∀ k t, 1 ≤ t → web.requires t (k + 1) k ∧ 0 < web.need t (k + 1) k) ∧
    (∀ t, 1 ≤ t → ¬ web.active t 0) ∧ ¬ web.Dependent ∧
    ∀ k, Web.chainEnd reserve (fun k => k) 1 k = k + 1 ∧ web.active k k :=
  ⟨carries, decays, embodied, fun _ _ _ => ⟨rfl, Nat.zero_lt_one⟩,
   fun _ later active => Nat.not_succ_le_zero 0 (Nat.le_trans later active),
   fun dependent => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le Nat.zero_lt_one
     (dependent 1 1 (Nat.le_refl 1) 0 rfl)),
   fun k => ⟨ends k, Nat.le_refl k⟩⟩

end Cascade

namespace ShortCascade

/-- `Cascade` cut to three relata: relatum `x + 1` depends on relatum `x` only for
`x + 1 ≤ 2`. -/
def web : Web Nat Nat where
  level t x := Cascade.upto t x
  active t x := t ≤ x
  requires _ x c := x = c + 1 ∧ x ≤ 2
  need _ _ _ := 1
  draws _ _ _ := False

theorem unsupported {t x : Nat} (no : ¬ web.Supported t x) : ¬ Cascade.web.Supported t x :=
  fun supported => no fun c requires => supported c requires.1

theorem carries : web.Carries Cascade.reserve :=
  fun t x no => Cascade.carries t x (unsupported no)

theorem decays : web.Decays Cascade.reserve :=
  fun t x no => Cascade.decays t x (unsupported no)

theorem ranked : ∀ t g c, web.requires t g c → c < g ∧ g ≤ 2 :=
  fun _ _ c requires =>
    ⟨Eq.subst (motive := fun g => c < g) requires.1.symm (Nat.lt_succ_self c), requires.2⟩

end ShortCascade

/-- The finite form covers finite chains. In `Cascade` cut to three relata, relatum `2` is
not active from step `chainEnd 2 = 3` on, and the bound is attained: it is active at step
`2`. No unending chain of dependence runs through this web (`Web.no_unending_chain`). -/
theorem short_cascade :
    ShortCascade.web.Carries Cascade.reserve ∧ ShortCascade.web.Decays Cascade.reserve ∧
    (∀ t, Web.chainEnd Cascade.reserve (fun k => k) 1 2 ≤ t → ¬ ShortCascade.web.active t 2) ∧
    Web.chainEnd Cascade.reserve (fun k => k) 1 2 = 2 + 1 ∧ ShortCascade.web.active 2 2 ∧
    ∀ (chain : Nat → Nat) (T : Nat), ¬ ∀ k t, T ≤ t →
      ShortCascade.web.requires t (chain (k + 1)) (chain k) ∧
        0 < ShortCascade.web.need t (chain (k + 1)) (chain k) :=
  ⟨ShortCascade.carries, ShortCascade.decays,
   ShortCascade.carries.chain_ends ShortCascade.decays (chain := fun k => k) (n := 2)
     (fun k _ => Cascade.embodied k) (fun _ _ lt _ => ⟨⟨rfl, lt⟩, Nat.zero_lt_one⟩)
     (fun _ later active => Nat.not_succ_le_zero 0 (Nat.le_trans later active))
     2 (Nat.le_refl 2),
   Cascade.ends 2, Nat.le_refl 2,
   fun _ _ bears => Web.no_unending_chain (ρ := fun x => x) (K := 2) ShortCascade.ranked bears⟩

namespace Once

/-- One for `true`, zero for `false`. -/
def ind : Bool → Nat
  | true => 1
  | false => 0

theorem ind_and_le : ∀ b c : Bool, ind (b && c) ≤ ind b
  | true, true => Nat.le_refl 1
  | true, false => Nat.zero_le 1
  | false, _ => Nat.le_refl 0

theorem ind_fall : ∀ b c : Bool, b = true → c = true → ind (b && !c) < ind b
  | true, true, _, _ => Nat.zero_lt_one
  | false, _, no, _ => nomatch no
  | true, false, _, no => nomatch no

variable (s : Nat → Bool)

/-- One formation, never supported, active exactly at the first `true` of `s`. -/
def web : Web Unit Unit where
  level _ _ := 0
  active t _ := clear s t = true ∧ s t = true
  requires _ _ _ := True
  need _ _ _ := 1
  draws _ _ _ := False

/-- One until the first `true` has passed. -/
def reserve (t : Nat) (_ : Unit) : Nat :=
  ind (clear s t)

theorem unsupported (t : Nat) : ¬ (web s).Supported t () :=
  fun supported => Nat.not_succ_le_zero 0 (supported () trivial)

theorem carries : (web s).Carries (reserve s) :=
  fun t _ _ => ⟨ind_and_le (clear s t) (!s t),
    fun active => ind_fall (clear s t) (s t) active.1 active.2⟩

/-- Its activity is decided. -/
def decided (t : Nat) : Decidable ((web s).active t ()) :=
  (instDecidableAnd : Decidable (clear s t = true ∧ s t = true))

/-- It is active at most once. -/
theorem once {t u : Nat} (at_t : (web s).active t ()) (at_u : (web s).active u ()) : t = u :=
  Clear.first_unique s at_t.1 at_t.2 at_u.1 at_u.2

end Once

/-- A step after which a formation is never active needs omniscience. `active_not_recurring`
gives only that a formation unsupported from some step on is not active at arbitrarily late
steps. If every formation never supported, with a carried reserve and decided activity,
had a step after which it is never active, `LPO` would hold, even where activity holds at
most once (`Once`). So without decay, `chain_ends_of_em` takes excluded middle (the twelfth
review's probe). -/
theorem Web.lpo_of_ending
    (ending : ∀ (W : Web Unit Unit) (r : Nat → Unit → Nat), (∀ t, Decidable (W.active t ())) →
      W.Carries r → (∀ t, ¬ W.Supported t ()) → ∃ E, ∀ t, E ≤ t → ¬ W.active t ()) :
    LPO := fun s =>
  match ending (Once.web s) (Once.reserve s) (Once.decided s) (Once.carries s)
      (Once.unsupported s) with
  | ⟨E, quiet⟩ => match Clear.or_first s E with
    | .inr ⟨m, _, _, yes⟩ => .inl ⟨m, yes⟩
    | .inl c => .inr fun n => Clear.false_of_not (s n) fun yes =>
      match Clear.first_of_true s yes with
      | ⟨m, cm, ym⟩ => match Nat.lt_or_ge m E with
        | .inl lt => Clear.not_both (Clear.false_before s c lt) ym
        | .inr ge => quiet m ge ⟨cm, ym⟩

namespace Sleeper

/-- One relatum standing at one throughout, awake at odd steps. -/
def web : Web Unit Unit where
  level _ _ := 1
  active t _ := 0 < Shuttle.stands false t
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- Nothing takes part. -/
def flow : Flow Unit Unit := Witnesses.emptyFlow Unit Unit

/-- Waking from dormancy is arising without coming to stand: the relatum stands as a
condition throughout and while active, the flow, in which nothing takes part, balances
and is dissipative, activity needs support, and generation is unceasing with nothing
given. The relatum is not embodied, since it stands while dormant, and never comes to
stand. -/
theorem sleeper : flow.Balances web ∧ flow.Dissipative ∧ web.Dependent ∧ web.Unceasing ∧
    (∀ t, web.active t () → 0 < web.level t ()) ∧ ¬ web.Embodied () ∧
    ∀ t, ¬ web.ComesToStand t () :=
  ⟨fun _ _ => rfl, fun _ _ _ _ _ present => (nomatch present),
   fun _ _ _ _ depends => (nomatch depends),
   fun N => match Shuttle.recurs false N with
    | ⟨t, later, arises⟩ => ⟨t, (), later, arises⟩,
   fun _ _ => Nat.zero_lt_one,
   fun embodied => Nat.lt_irrefl 0 ((embodied 0).mpr Nat.zero_lt_one),
   fun _ comes => comes.1 Nat.zero_lt_one⟩

end Sleeper

namespace Provisioned

/-- A parent and a seed. -/
inductive Relatum where
  | parent
  | seed

/-- Active from step two on. -/
def late : Nat → Nat := Witnesses.profile [0, 0] 1

/-- The seed stands from step one and is active from step two; the parent is always
active. Nothing depends on or draws on anything. -/
def web : Web Relatum Relatum where
  level t x := match x with
    | .parent => 0
    | .seed => SourceSeed.sprout t
  active t x := match x with
    | .parent => True
    | .seed => 0 < late t
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- One unit at step zero. -/
def provision : Nat → Nat := Witnesses.profile [1] 0

/-- The parent gives the seed one unit across step zero. -/
def flow : Flow Relatum Relatum where
  present _ := [.parent]
  take _ _ _ := 0
  give t g y := match g, y with
    | .parent, .seed => provision t
    | .parent, .parent => 0
    | .seed, _ => 0

theorem balances : flow.Balances web
  | 0, .parent | 0, .seed => rfl
  | _ + 1, .parent | _ + 1, .seed => rfl

/-- Only the parent gives, and it is always active. -/
theorem acting : flow.Acting web
  | _, .parent, _, _, _ => trivial
  | _, .seed, _, _, gives => absurd gives (Nat.lt_irrefl 0)

/-- Provisioning: the seed comes to stand across step zero, given its standing by the
parent while it is dormant, and arises across step one with nothing given to it. It
stands while active, and is not embodied. -/
theorem provisioned : flow.Balances web ∧ flow.Acting web ∧
    web.ComesToStand 0 .seed ∧ web.level 1 .seed ≤ flow.given 0 .seed ∧
    web.Arises 1 .seed ∧ flow.given 1 .seed = 0 ∧
    (∀ t, web.active t .seed → 0 < web.level t .seed) ∧ ¬ web.Embodied .seed :=
  ⟨balances, acting, ⟨Nat.lt_irrefl 0, Nat.zero_lt_one⟩, Nat.le_refl 1,
   ⟨Nat.lt_irrefl 0, Nat.zero_lt_one⟩, rfl,
   fun t active => match t, active with
     | 0, active => absurd active (Nat.lt_irrefl 0)
     | 1, active => absurd active (Nat.lt_irrefl 0)
     | _ + 2, _ => Nat.zero_lt_one,
   fun embodied => Nat.lt_irrefl 0 ((embodied 1).mpr Nat.zero_lt_one)⟩

end Provisioned

namespace Bridged

/-- No support at the first three steps, then support: the condition stands at one from step
three on. -/
def standing : Nat → Nat := Witnesses.profile [0, 0, 0] 1

/-- A reserve of three, spent a unit a step while unsupported. -/
def reserve : Nat → Nat := Witnesses.profile [3, 2, 1] 0

/-- One formation, active at every step, depending on one condition at need one. -/
def web : Web Unit Unit where
  level t _ := standing t
  active _ _ := True
  requires _ _ _ := True
  need _ _ _ := 1
  draws _ _ _ := False

/-- **A reserve spanning the gap bridges it.** Unsupported at the first three steps and supported
from step three on, the formation is active at every step: a reserve of three, falling by one at
each unsupported step, carries it across. -/
theorem bridged :
    (∀ t, web.CarriesAcross (fun t _ => reserve t) t ()) ∧ (∀ t, t < 3 → ¬ web.Supported t ()) ∧
      (∀ t, 3 ≤ t → web.Supported t ()) ∧ ∀ t, web.active t () :=
  ⟨fun t unsupported => match t, unsupported with
    | 0, _ => ⟨Nat.le_succ 2, fun _ => Nat.lt_succ_self 2⟩
    | 1, _ => ⟨Nat.le_succ 1, fun _ => Nat.lt_succ_self 1⟩
    | 2, _ => ⟨Nat.le_succ 0, fun _ => Nat.lt_succ_self 0⟩
    | _ + 3, unsupported => absurd (fun _ _ => Nat.le_refl 1) unsupported,
   fun t below supported => match t, below with
    | 0, _ => absurd (supported () trivial) (Nat.not_succ_le_zero 0)
    | 1, _ => absurd (supported () trivial) (Nat.not_succ_le_zero 0)
    | 2, _ => absurd (supported () trivial) (Nat.not_succ_le_zero 0)
    | _ + 3, late => absurd late (Nat.not_lt_of_le (Nat.le_add_left 3 _)),
   fun t late _ _ => match t, late with
    | _ + 3, _ => Nat.le_refl 1,
   fun _ => trivial⟩

end Bridged

end Becoming
