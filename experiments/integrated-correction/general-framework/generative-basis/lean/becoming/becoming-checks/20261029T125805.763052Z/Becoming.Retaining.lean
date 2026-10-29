import Becoming.Regions
import Becoming.KeptOnward

/-!
# Retaining: what one level path keeps of another

Retaining and adding, for any significance, with no condition on it: what `Becoming.Significance`
compares under the continuation condition, stated where it needs nothing.

* **Retaining and adding.** From a standpoint, one level path *retains* what has significance
  along another when it admits every continuation with significance that the other admits
  (`Web.Retains`), and *adds* when it admits one the other does not (`Web.Adds`). Retaining is
  reflexive and transitive and ends nothing the other path holds (`Web.Retains.refl`,
  `Web.Retains.trans`, `Web.Retains.not_added`); inclusion retains for every significance
  (`Web.Includes.retains`) and adding exceeds (`Web.Adds.exceeds`). Where fewer continuations
  have significance, more is retained (`Web.Retains.of_fewer`); significance bounded by a region
  (`bounded`) retains what is admitted within the region (`Web.retains_bounded_iff`).
* **The stepwise classes and loss.** Levels below a need are exceeded by every level path that
  admits the formation there (`Web.exceeded_of_below`), so an undermining event leaves the levels
  exceeded (`Web.UnderminingOn.exceeded`), keeping what can form excludes undermining
  (`Web.Includes.not_undermining`), and from a standpoint at which the continuations met have
  significance nothing is retained (`Web.UnderminingOn.not_retains`).
* **Not harm is an exact boundary.** The levels with a part retain what has significance without
  it exactly when the part's net draw stays within the margin for every continuation with
  significance that the levels without it admit (`Flow.retains_iff_within_margin_at`; in a
  balanced flow `Flow.Balances.retains_iff_within_margin`); the part loses a continuation exactly
  beyond the margin and adds one exactly where its net exchange brings a formation within it
  (`Flow.loses_iff_beyond_margin_at`, `Flow.adds_iff_within_margin_at` and their balanced
  forms). The levels with a part widen those without it exactly when the draw stays within the
  margin and the exchange brings one more formation within it
  (`Flow.widens_iff_within_margin_at`, `Flow.Balances.widens_iff_within_margin`).
* **What has not yet formed counts.** In `Preemption` a drawer takes a condition's unit before
  any dependence on it forms: its event is within renewal and not undermining, yet the part does
  not keep what can form (`Preemption.within_renewal_yet_loses`).
* **The run classes and widening** (R34, 20 October 2026). In a balanced flow where only active
  formations take, and only from what they draw on, a part each of whose draws falls on a
  condition renewed over the run keeps what can form: the levels with it include those without it
  (`Flow.Balances.includes_of_renewed`), so it does not narrow
  (`Flow.Balances.not_narrows_of_renewed`); a part of formations renewing over the run is a case
  (`Flow.Balances.includes_of_renewingIn`). A consuming part narrows where it gives no more than it
  takes and the levels without it meet the consumed dependence after the loss
  (`Flow.Balances.narrows_of_consumed`). Each premise marks a boundary: `Preemption`'s drawer is
  within renewal at its step (the stepwise class) and consuming over the run, and its part narrows
  (`Preemption.renewingAt_consuming_narrows`), so the stepwise class does not decide; and a part
  can be consuming over the run, drawing on a condition it never takes from, and keep what can form
  the same (`Untaken.consuming_keeps`), so the consuming class alone does not narrow.

Every declaration moved here unchanged, with its name, from `Becoming.Significance` in R31
(20 October 2026); none takes the continuation condition, which `Becoming.Significance` states and
under which retaining is inclusion. No condition, ranking or axiom occurs.
-/

namespace Becoming

variable {F C Pos : Type}

/-- Significance kept inside each standpoint's region: from `p`, the continuation of `f` has
significance exactly when `f` lies in `p`'s region. -/
def bounded (region : Pos → F → Prop) : Pos → Nat → F → Prop :=
  fun p _ f => region p f

/-! ## Retaining and adding what has significance -/

namespace Web

variable (W : Web F C)

/-- From standpoint `p`, the level path `l` retains what has significance along `l'`: it admits
every continuation with significance that `l'` admits. -/
def Retains (sig : Pos → Nat → F → Prop) (p : Pos) (l l' : Nat → C → Nat) : Prop :=
  ∀ t f, sig p t f → W.Admits (l' t) t f → W.Admits (l t) t f

/-- From standpoint `p`, the level path `l` adds a continuation with significance that `l'` does
not admit. -/
def Adds (sig : Pos → Nat → F → Prop) (p : Pos) (l l' : Nat → C → Nat) : Prop :=
  ∃ t f, sig p t f ∧ W.Admits (l t) t f ∧ ¬ W.Admits (l' t) t f

variable {W}

/-- Retaining is reflexive. -/
theorem Retains.refl (sig : Pos → Nat → F → Prop) (p : Pos) (l : Nat → C → Nat) :
    W.Retains sig p l l :=
  fun _ _ _ admits => admits

/-- Retaining is transitive. -/
theorem Retains.trans {sig : Pos → Nat → F → Prop} {p : Pos} {l l' l'' : Nat → C → Nat}
    (first : W.Retains sig p l l') (second : W.Retains sig p l' l'') : W.Retains sig p l l'' :=
  fun t f significant admits => first t f significant (second t f significant admits)

/-- Comparison by retaining licenses no ending: a level path that retains what has significance
along another ends none of it, so the other adds nothing to it. -/
theorem Retains.not_added {sig : Pos → Nat → F → Prop} {p : Pos} {l l' : Nat → C → Nat}
    (retains : W.Retains sig p l l') : ¬ W.Adds sig p l' l
  | ⟨t, f, significant, admitted, ended⟩ => ended (retains t f significant admitted)

/-- Inclusion retains, whatever has significance. -/
theorem Includes.retains {l l' : Nat → C → Nat} (includes : W.Includes l l')
    (sig : Pos → Nat → F → Prop) (p : Pos) : W.Retains sig p l l' :=
  fun t f _ admits => includes t f admits

/-- Adding exceeds, whatever has significance. -/
theorem Adds.exceeds {sig : Pos → Nat → F → Prop} {p : Pos} {l l' : Nat → C → Nat} :
    W.Adds sig p l l' → W.Exceeds l l'
  | ⟨t, f, _, admits, not⟩ => ⟨t, f, admits, not⟩

/-- Where fewer continuations have significance, more is retained. -/
theorem Retains.of_fewer {sig sig' : Pos → Nat → F → Prop}
    (fewer : ∀ p t f, sig' p t f → sig p t f) {p : Pos} {l l' : Nat → C → Nat}
    (retains : W.Retains sig p l l') : W.Retains sig' p l l' :=
  fun t f significant admits => retains t f (fewer p t f significant) admits

/-- Significance bounded by a region retains exactly what is admitted within the region at every
step. -/
theorem retains_bounded_iff {region : Pos → F → Prop} {p : Pos} {l l' : Nat → C → Nat} :
    W.Retains (bounded region) p l l' ↔ ∀ t, W.AdmitsWithin (region p) (l t) (l' t) t :=
  ⟨fun retains t f inside => retains t f inside, fun within t f inside => within t f inside⟩

/-! ## The stepwise classes and loss

Undermining, a stepwise class of a formation's event, and the order on what can form read the
same levels. Where the levels fall below a need, every level path admitting the formation there
exceeds them. So an undermining event, through dependences that hold across its step at no smaller
need, leaves the levels short of what every level path meeting those dependences after the step
admits; the levels with a part that undermines do not include the levels without it wherever
these meet the dependences. An event within renewal gives no such guarantee in the other direction
(`Preemption.within_renewal_yet_loses`). -/

/-- **Levels below a need are exceeded by every path admitting the formation there.** -/
theorem exceeded_of_below {l : Nat → C → Nat} {s : Nat} {g : F} {c : C} (requires : W.requires s g c)
    (below : W.level s c < W.need s g c) (admits : W.Admits (l s) s g) : W.Exceeds l W.level :=
  ⟨s, g, admits, fun admitted => Nat.not_le_of_gt below (admitted c requires)⟩

/-- **An undermining event leaves the levels exceeded.** Where every dependence on the condition
holds across the step at no smaller need, and a level path admits after the step every formation
depending on the condition before it, that path exceeds the levels. -/
theorem UnderminingOn.exceeded {l : Nat → C → Nat} {t : Nat} {f : F} {c : C}
    (undermining : W.UnderminingOn t f c)
    (holds : ∀ g, W.requires t g c → W.requires (t + 1) g c ∧ W.need t g c ≤ W.need (t + 1) g c)
    (admits : ∀ g, W.requires t g c → W.Admits (l (t + 1)) (t + 1) g) : W.Exceeds l W.level :=
  match undermining with
  | ⟨_, g, depends, _, below⟩ =>
    exceeded_of_below (holds g depends).1
      (Nat.lt_of_lt_of_le below (holds g depends).2) (admits g depends)

/-- **Keeping what can form excludes undermining where the other path meets the dependences.** The
levels include a level path admitting after a step every formation depending on a condition before
it, through dependences that hold across the step at no smaller need, only if no event at the step
undermines that condition. -/
theorem Includes.not_undermining {l : Nat → C → Nat} (includes : W.Includes W.level l) {t : Nat}
    {f : F} {c : C}
    (holds : ∀ g, W.requires t g c → W.requires (t + 1) g c ∧ W.need t g c ≤ W.need (t + 1) g c)
    (admits : ∀ g, W.requires t g c → W.Admits (l (t + 1)) (t + 1) g) : ¬ W.UnderminingOn t f c :=
  fun undermining => includes.not_exceeded (undermining.exceeded holds admits)

/-- **An undermining event loses what has significance.** Under the same hypotheses, from a
standpoint at which the continuation after the step of every formation depending on the condition
has significance, the levels do not retain what has significance along the other path. -/
theorem UnderminingOn.not_retains {l : Nat → C → Nat} {t : Nat} {f : F} {c : C}
    (undermining : W.UnderminingOn t f c)
    (holds : ∀ g, W.requires t g c → W.requires (t + 1) g c ∧ W.need t g c ≤ W.need (t + 1) g c)
    (admits : ∀ g, W.requires t g c → W.Admits (l (t + 1)) (t + 1) g)
    {sig : Pos → Nat → F → Prop} {p : Pos} (significant : ∀ g, W.requires t g c → sig p (t + 1) g) :
    ¬ W.Retains sig p W.level l :=
  match undermining with
  | ⟨_, g, depends, _, below⟩ => fun retains =>
    Nat.not_le_of_gt (Nat.lt_of_lt_of_le below (holds g depends).2)
      (retains (t + 1) g (significant g depends) (admits g depends) c (holds g depends).1)

/-- **Never arising from an inactive start is never being active.** A formation not active at the
start that arises across no step is active at no step: not being active is a region every step
keeps (`kept_onward`). -/
theorem inactive_of_not_arising {f : F} (start : ¬ W.active 0 f) (never : ∀ t, ¬ W.Arises t f) :
    ∀ t, ¬ W.active t f :=
  fun t => kept_onward (I := fun n => ¬ W.active n f)
    (fun n inactive active => never n ⟨inactive, active⟩) start (Nat.zero_le t)

end Web

/-! ## Not harm is an exact boundary -/

namespace Flow

variable {L : Flow F C} {part : F → Bool} {W : Web F C}

/-- From standpoint `p`, with balance only at the conditions required by the continuations with
significance that the levels without the part admit, across the steps before each: the levels with
the part retain what has significance without it exactly when, for each such continuation, the
part's net draw on each condition the formation requires stays within the margin. -/
theorem retains_iff_within_margin_at {l : Nat → C → Nat} (without : L.WithheldLevels part W l)
    {sig : Pos → Nat → F → Prop} {p : Pos}
    (balances : ∀ t f, sig p t f → W.Admits (l t) t f → ∀ c, W.requires t f c → ∀ s, s < t →
      L.BalancesOn W [c] s) :
    W.Retains sig p W.level l ↔ ∀ t f, sig p t f → W.Admits (l t) t f → ∀ c, W.requires t f c →
      W.need t f c + total (steps 0 t) (fun s => L.partTaken part s c) ≤
        l t c + total (steps 0 t) (fun s => L.partGiven part s c) :=
  ⟨fun retains t f significant admits =>
      (supported_iff_within_margin_at without (balances t f significant admits)).mp
        (retains t f significant admits),
   fun within t f significant admits =>
      (supported_iff_within_margin_at without (balances t f significant admits)).mpr
        (within t f significant admits)⟩

/-- From standpoint `p`, with balance as in `retains_iff_within_margin_at`: a part loses a
continuation with significance exactly where the levels without it admit the formation and not
every condition it requires keeps its need, with the part's net draw, within the margin. -/
theorem loses_iff_beyond_margin_at {l : Nat → C → Nat} (without : L.WithheldLevels part W l)
    {sig : Pos → Nat → F → Prop} {p : Pos}
    (balances : ∀ t f, sig p t f → W.Admits (l t) t f → ∀ c, W.requires t f c → ∀ s, s < t →
      L.BalancesOn W [c] s) :
    W.Adds sig p l W.level ↔ ∃ t f, sig p t f ∧ W.Admits (l t) t f ∧ ¬ ∀ c, W.requires t f c →
      W.need t f c + total (steps 0 t) (fun s => L.partTaken part s c) ≤
        l t c + total (steps 0 t) (fun s => L.partGiven part s c) :=
  ⟨fun ⟨t, f, significant, admits, lost⟩ => ⟨t, f, significant, admits, fun within =>
      lost ((supported_iff_within_margin_at without (balances t f significant admits)).mpr
        within)⟩,
   fun ⟨t, f, significant, admits, beyond⟩ => ⟨t, f, significant, admits, fun supported =>
      beyond ((supported_iff_within_margin_at without (balances t f significant admits)).mp
        supported)⟩⟩

/-- From standpoint `p`, with balance only at the conditions required by the continuations with
significance that the levels without the part do not admit, across the steps before each: a part
adds a continuation with significance exactly where the levels without it do not admit the
formation and, with the part's net exchange, its need is met within the margin on every condition
it requires. -/
theorem adds_iff_within_margin_at {l : Nat → C → Nat} (without : L.WithheldLevels part W l)
    {sig : Pos → Nat → F → Prop} {p : Pos}
    (balances : ∀ t f, sig p t f → ¬ W.Admits (l t) t f → ∀ c, W.requires t f c → ∀ s, s < t →
      L.BalancesOn W [c] s) :
    W.Adds sig p W.level l ↔ ∃ t f, sig p t f ∧ (∀ c, W.requires t f c →
      W.need t f c + total (steps 0 t) (fun s => L.partTaken part s c) ≤
        l t c + total (steps 0 t) (fun s => L.partGiven part s c)) ∧ ¬ W.Admits (l t) t f :=
  ⟨fun ⟨t, f, significant, supported, fresh⟩ => ⟨t, f, significant,
      (supported_iff_within_margin_at without (balances t f significant fresh)).mp supported,
      fresh⟩,
   fun ⟨t, f, significant, within, fresh⟩ => ⟨t, f, significant,
      (supported_iff_within_margin_at without (balances t f significant fresh)).mpr within,
      fresh⟩⟩

/-- From standpoint `p`, the levels with a part retain what has significance without it exactly
when, at every step, for every continuation with significance that the levels without it admit,
the part's net draw on each condition the formation requires stays within the margin. -/
theorem Balances.retains_iff_within_margin (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {sig : Pos → Nat → F → Prop} {p : Pos} :
    W.Retains sig p W.level l ↔ ∀ t f, sig p t f → W.Admits (l t) t f → ∀ c, W.requires t f c →
      W.need t f c + total (steps 0 t) (fun s => L.partTaken part s c) ≤
        l t c + total (steps 0 t) (fun s => L.partGiven part s c) :=
  retains_iff_within_margin_at without fun _ _ _ _ c _ s _ => balances.on [c] s

/-- From standpoint `p`, a part loses a continuation with significance exactly where the levels
without it admit the formation and not every condition it requires keeps its need, with the
part's net draw, within the margin. -/
theorem Balances.loses_iff_beyond_margin (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {sig : Pos → Nat → F → Prop} {p : Pos} :
    W.Adds sig p l W.level ↔ ∃ t f, sig p t f ∧ W.Admits (l t) t f ∧ ¬ ∀ c, W.requires t f c →
      W.need t f c + total (steps 0 t) (fun s => L.partTaken part s c) ≤
        l t c + total (steps 0 t) (fun s => L.partGiven part s c) :=
  loses_iff_beyond_margin_at without fun _ _ _ _ c _ s _ => balances.on [c] s

/-- From standpoint `p`, a part adds a continuation with significance exactly where the levels
without it do not admit the formation and, with the part's net exchange, its need is met within
the margin on every condition it requires. -/
theorem Balances.adds_iff_within_margin (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {sig : Pos → Nat → F → Prop} {p : Pos} :
    W.Adds sig p W.level l ↔ ∃ t f, sig p t f ∧ (∀ c, W.requires t f c →
      W.need t f c + total (steps 0 t) (fun s => L.partTaken part s c) ≤
        l t c + total (steps 0 t) (fun s => L.partGiven part s c)) ∧ ¬ W.Admits (l t) t f :=
  adds_iff_within_margin_at without fun _ _ _ _ c _ s _ => balances.on [c] s

/-- The exact boundary of the generative space, with no axiom, and balance only where it is used:
at the conditions each formation requires, across the steps before it. The levels with a part
widen those without it exactly when the part's net draw stays within the margin for every
formation the levels without it admit, and, at some step, its net exchange brings within the
margin a formation the levels without it do not admit. -/
theorem widens_iff_within_margin_at {l : Nat → C → Nat} (without : L.WithheldLevels part W l)
    (balances : ∀ t f c, W.requires t f c → ∀ s, s < t → L.BalancesOn W [c] s) :
    W.Widens W.level l ↔
      (∀ t f, W.Admits (l t) t f → ∀ c, W.requires t f c →
        W.need t f c + total (steps 0 t) (fun s => L.partTaken part s c) ≤
          l t c + total (steps 0 t) (fun s => L.partGiven part s c)) ∧
      ∃ t f, (∀ c, W.requires t f c →
        W.need t f c + total (steps 0 t) (fun s => L.partTaken part s c) ≤
          l t c + total (steps 0 t) (fun s => L.partGiven part s c)) ∧ ¬ W.Admits (l t) t f :=
  ⟨fun ⟨includes, t, f, admits, not⟩ =>
    ⟨fun t f admitted => (supported_iff_within_margin_at without (balances t f)).mp
        (includes t f admitted),
     t, f, (supported_iff_within_margin_at without (balances t f)).mp admits, not⟩,
   fun ⟨within, t, f, brought, not⟩ =>
    ⟨fun t f admitted => (supported_iff_within_margin_at without (balances t f)).mpr
        (within t f admitted),
     t, f, (supported_iff_within_margin_at without (balances t f)).mpr brought, not⟩⟩

/-- In a balanced flow, the exact boundary of the generative space (`widens_iff_within_margin_at`). -/
theorem Balances.widens_iff_within_margin (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) :
    W.Widens W.level l ↔
      (∀ t f, W.Admits (l t) t f → ∀ c, W.requires t f c →
        W.need t f c + total (steps 0 t) (fun s => L.partTaken part s c) ≤
          l t c + total (steps 0 t) (fun s => L.partGiven part s c)) ∧
      ∃ t f, (∀ c, W.requires t f c →
        W.need t f c + total (steps 0 t) (fun s => L.partTaken part s c) ≤
          l t c + total (steps 0 t) (fun s => L.partGiven part s c)) ∧ ¬ W.Admits (l t) t f :=
  widens_iff_within_margin_at without fun _ _ c _ s _ => balances.on [c] s

/-! ## The run classes and widening

A formation's class over a run (renewing, consuming) and a part's place in the order on what can
form (keeping, widening, narrowing) read the same levels. Where only active formations take, and
only from what they draw on, a part takes from a condition only where a member draws on it. So a
part all of whose members' draws fall on conditions renewed over the whole run closes nothing:
on a condition it never took from the levels with it stand at least as high as those without it,
and on a condition it took from every dependence is met at every step. A consuming part narrows
where it opens nothing and the levels without it meet the consumed dependence after the loss. The
stepwise class is not enough: `Preemption`'s drawer is within renewal at its step and consuming
over the run, and its part narrows (`Preemption.renewingAt_consuming_narrows`). Nor is the
consuming class: a part can draw on a consumed condition without taking from it and change
nothing that can form (`Untaken.consuming_keeps`). -/

/-- **A part whose draws fall on renewed conditions keeps what can form.** In a balanced flow where
only active formations take, and only from what they draw on, let every condition a member of the
part draws on at some step be renewed over the run (every dependence on it kept at every step).
Then the levels with the part include those without it. -/
theorem Balances.includes_of_renewed (balances : L.Balances W) (taking : L.Taking W)
    {l : Nat → C → Nat} (without : L.WithheldLevels part W l)
    (renewed : ∀ t f c, part f = true → W.draws t f c → W.Renewed c) : W.Includes W.level l :=
  fun t g admits c requires =>
    match Nat.eq_zero_or_pos (total (steps 0 t) fun s => L.partTaken part s c) with
    | .inl untaken =>
      Nat.le_trans (admits c requires) (Nat.le_trans
        (Nat.le_add_right (l t c) (total (steps 0 t) fun s => L.partGiven part s c))
        (Nat.le_of_eq ((balances.withheld without t c).symm.trans
          ((congrArg (W.level t c + ·) untaken).trans (Nat.add_zero _)))))
    | .inr taken =>
      match total_pos (steps 0 t) taken with
      | ⟨s, _, takenAt⟩ =>
        match total_pos (L.present s) takenAt with
        | ⟨f, present, positive⟩ =>
          have drawn : part f = true → W.draws s f c := fun member =>
            (taking s f c present (Nat.lt_of_lt_of_le positive (Nat.le_of_eq
              (show (if part f then L.take s f c else 0) = L.take s f c from
                match part f, member with
                | true, _ => rfl)))).2
          match hp : part f with
          | true => (renewed s f c hp (drawn hp) t g requires).1
          | false => absurd (Nat.lt_of_lt_of_le positive (Nat.le_of_eq
              (show (if part f then L.take s f c else 0) = 0 from
                match part f, hp with
                | false, _ => rfl))) (Nat.lt_irrefl 0)

/-- **So such a part does not narrow**: the levels without it do not widen those with it. -/
theorem Balances.not_narrows_of_renewed (balances : L.Balances W) (taking : L.Taking W)
    {l : Nat → C → Nat} (without : L.WithheldLevels part W l)
    (renewed : ∀ t f c, part f = true → W.draws t f c → W.Renewed c) : ¬ W.Widens l W.level :=
  fun widens => (balances.includes_of_renewed taking without renewed).not_exceeded widens.2

/-- **A part of renewing formations keeps what can form.** Where every member renews over the run
every condition it takes part in (`Web.RenewingIn`), the levels with the part include those
without it. -/
theorem Balances.includes_of_renewingIn (balances : L.Balances W) (taking : L.Taking W)
    {l : Nat → C → Nat} (without : L.WithheldLevels part W l)
    (renewing : ∀ f, part f = true → W.RenewingIn f) : W.Includes W.level l :=
  balances.includes_of_renewed taking without fun t f c member drawn =>
    renewing f member t c (Or.inr drawn)

/-- **A consuming part narrows where it opens nothing and the levels without it meet the consumed
dependence.** Let a dependence held at `T` be met at no step after it (as in `Web.Consumed`), let
the part give each condition at every step no more than it takes, and let the levels without the
part admit at a later step `t` the formation whose dependence it was, that dependence held there
at no smaller need. Then the levels without the part widen those with it. -/
theorem Balances.narrows_of_consumed (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l)
    (keeps : ∀ t c, L.partGiven part t c ≤ L.partTaken part t c) {g : F} {c : C} {T t : Nat}
    (below : ∀ t, T < t → W.level t c < W.need T g c) (later : T < t)
    (holds : W.requires t g c ∧ W.need T g c ≤ W.need t g c) (admits : W.Admits (l t) t g) :
    W.Widens l W.level :=
  ⟨balances.opens_nothing without keeps,
   Web.exceeded_of_below holds.1 (Nat.lt_of_lt_of_le (below t later) holds.2) admits⟩

/-! ### The class of arising

A part's members take and give only while active, so a part's place in the order on what can form
begins where a member is active: at the start or by arising. A part none of whose members is
active at the start and none of which arises over the run changes nothing that can form; where a
member arises, the arising decides nothing, since the arisen member can then narrow what can form
(`ArisingDrawer.arises_narrows`) or widen it (`ArisingGiver.arises_widens`) under the same
premises. -/

/-- **A part never active changes nothing that can form.** In a balanced flow where only active
formations take and give, a part none of whose members is active at any step takes and gives
nothing, so the levels with and without it admit alike. -/
theorem Balances.keeps_of_inactive (balances : L.Balances W) (taking : L.Taking W)
    (acting : L.Acting W) {l : Nat → C → Nat} (without : L.WithheldLevels part W l)
    (inactive : ∀ t f, part f = true → ¬ W.active t f) : W.Keeps W.level l :=
  have none : ∀ (q : Nat → F → C → Nat), (∀ t f c, f ∈ L.present t → 0 < q t f c → W.active t f) →
      ∀ t c, total (L.present t) (fun f => if part f then q t f c else 0) = 0 :=
    fun q only t c =>
      let rec zero : ∀ fs : List F, (∀ f, f ∈ fs → f ∈ L.present t) →
          total fs (fun f => if part f then q t f c else 0) = 0
        | [], _ => rfl
        | f :: fs, within =>
          have head : (if part f then q t f c else 0) = 0 :=
            match hp : part f with
            | true => match Nat.eq_zero_or_pos (q t f c) with
              | .inl zero => zero
              | .inr positive => absurd (only t f c (within f (.head _)) positive) (inactive t f hp)
            | false => rfl
          (congrArg (· + _) head).trans ((Nat.zero_add _).trans
            (zero fs fun g mem => within g (.tail f mem)))
      zero (L.present t) fun _ mem => mem
  have even : ∀ t c, L.partTaken part t c = L.partGiven part t c := fun t c =>
    (none L.take (fun t f c present positive => (taking t f c present positive).1) t c).trans
      (none L.give acting t c).symm
  balances.changes_nothing without even

/-- **A part that never arises changes nothing that can form.** In a balanced flow where only
active formations take and give, a part none of whose members is active at the start and none of
which arises across any step keeps the levels with and without it admitting alike. -/
theorem Balances.keeps_of_not_arising (balances : L.Balances W) (taking : L.Taking W)
    (acting : L.Acting W) {l : Nat → C → Nat} (without : L.WithheldLevels part W l)
    (start : ∀ f, part f = true → ¬ W.active 0 f)
    (never : ∀ t f, part f = true → ¬ W.Arises t f) : W.Keeps W.level l :=
  balances.keeps_of_inactive taking acting without fun t f member =>
    Web.inactive_of_not_arising (start f member) (fun s => never s f member) t

end Flow

/-! ## Witnesses -/

/-! A drawer takes a condition's unit before any dependence on it forms. -/

namespace Preemption

/-- Across the first step the drawer `true` takes the condition's one unit; nothing gives. -/
def flow : Flow Bool Unit where
  present t := match t with
    | 0 => [true]
    | _ + 1 => []
  take t x _ := match t, x with
    | 0, true => 1
    | 0, false => 0
    | _ + 1, _ => 0
  give _ _ _ := 0

/-- The drawer requires nothing and is active at the first step. `false` requires the condition
at need one from the second step on and is never active. -/
def web : Web Bool Unit where
  level t _ := unitDrop t
  active t x := match x with
    | true => t = 0
    | false => False
  requires t x _ := match x with
    | true => False
    | false => 0 < t
  need _ _ _ := 1
  draws t x _ := match t, x with
    | 0, true => True
    | 0, false => False
    | _ + 1, _ => False

/-- The drawer's part. -/
def drawerPart : Bool → Bool
  | true => true
  | false => false

/-- Without the drawer's part the condition stays at one. -/
theorem withheld : flow.WithheldLevels drawerPart web fun _ _ => 1 :=
  ⟨fun t () => match t with
    | 0 => rfl
    | _ + 1 => rfl,
   fun () => rfl⟩

/-- **Within renewal, yet closing a possibility.** The drawer's event at the first step is within
renewal, since no dependence on the condition has formed for the step to keep, and is not
undermining; yet the levels with the drawer's part do not include those without it. So no event's
being within renewal or not undermining shows that a part keeps what can form: the stepwise
classes count only dependences that have formed. -/
theorem within_renewal_yet_loses {l : Nat → Unit → Nat}
    (without : flow.WithheldLevels drawerPart web l) :
    web.RenewingAt 0 true ∧ ¬ web.UnderminingAt 0 true ∧ ¬ web.Includes web.level l :=
  ⟨⟨rfl, fun _ _ g requires => match g, requires with
    | true, no => (nomatch no)
    | false, no => absurd no (Nat.lt_irrefl 0)⟩,
   fun ⟨(), _, g, requires, _⟩ => match g, requires with
    | true, no => no
    | false, no => Nat.lt_irrefl 0 no,
   fun includes => Nat.not_succ_le_zero 0
     (includes 1 false (fun () _ => Nat.le_of_eq (without.unique withheld 1 ()).symm) ()
       (Nat.succ_pos 0))⟩

/-- **Within renewal at its step, consuming over the run, and narrowing.** The drawer's event at
the first step is within renewal (the stepwise class), the drawer is consuming over the run (the
dependence of `false` on the condition, held from the second step, is met at no later step), it
does not renew over the run, and the levels without its part widen those with it. So the stepwise
class and the run class overlap at this event, and the run class is the one that tells the part's
place in the order on what can form (`Flow.Balances.includes_of_renewingIn`). -/
theorem renewingAt_consuming_narrows {l : Nat → Unit → Nat}
    (without : flow.WithheldLevels drawerPart web l) :
    web.RenewingAt 0 true ∧ web.ConsumingIn true ∧ ¬ web.RenewingIn true ∧ web.Widens l web.level :=
  have balances : flow.Balances web := fun t () => match t with
    | 0 => rfl
    | _ + 1 => rfl
  ⟨(within_renewal_yet_loses without).1,
   ⟨0, (), trivial, false, 1, Nat.zero_lt_one, fun t later => match t, later with
     | _ + 2, _ => Nat.zero_lt_one⟩,
   fun renewing => Nat.not_succ_le_zero 0 ((renewing 0 () (Or.inr trivial) 1 false Nat.zero_lt_one).1),
   ⟨balances.opens_nothing without fun t _ => match t with
      | 0 => Nat.zero_le _
      | _ + 1 => Nat.zero_le _,
    1, false, fun () _ => Nat.le_of_eq (without.unique withheld 1 ()).symm,
    fun supported => Nat.not_succ_le_zero 0 (supported () Nat.zero_lt_one)⟩⟩

end Preemption

/-! A part that draws on a condition it never takes from, where the condition never meets the
dependence on it. -/

namespace Untaken

/-- Nothing takes or gives. -/
def flow : Flow Unit Unit where
  present _ := [()]
  take _ _ _ := 0
  give _ _ _ := 0

/-- The condition stays at zero; the one formation requires it at need one and draws on it. -/
def web : Web Unit Unit where
  level _ _ := 0
  active _ _ := False
  requires _ _ _ := True
  need _ _ _ := 1
  draws _ _ _ := True

/-- The formation's part. -/
def part : Unit → Bool := fun _ => true

/-- **Consuming, yet keeping what can form.** The formation is consuming over the run, since the
condition it draws on meets the dependence on it at no step; the flow balances and only active
formations take; and the levels with and without its part keep what can form the same. The
consumption is not the part's: the part takes nothing. -/
theorem consuming_keeps {l : Nat → Unit → Nat} (without : flow.WithheldLevels part web l) :
    flow.Balances web ∧ flow.Taking web ∧ web.ConsumingIn () ∧ web.Keeps web.level l :=
  have same : ∀ t, l t () = 0 := fun t =>
    without.unique (l' := fun _ _ => 0) ⟨fun _ () => rfl, fun () => rfl⟩ t ()
  ⟨fun _ () => rfl, fun _ _ _ _ takes => absurd takes (Nat.lt_irrefl 0),
   ⟨0, (), trivial, (), 0, trivial, fun _ _ => Nat.zero_lt_one⟩,
   fun t _ admits () requires => Nat.le_trans (admits () requires) (Nat.le_of_eq (same t)),
   fun t _ admits () requires => Nat.le_trans (admits () requires) (Nat.le_of_eq (same t).symm)⟩

end Untaken


/-! A member that arises across the first step and then takes a condition's one unit before any
dependence on it forms. -/

namespace ArisingDrawer

/-- Across the second step the drawer `true` takes the condition's one unit; nothing gives. -/
def flow : Flow Bool Unit where
  present t := match t with
    | 0 => []
    | 1 => [true]
    | _ + 2 => []
  take t x _ := match t, x with
    | 0, _ => 0
    | 1, true => 1
    | 1, false => 0
    | _ + 2, _ => 0
  give _ _ _ := 0

/-- The drawer requires nothing and is active at the second step only. `false` requires the
condition at need one from the third step on and is never active. -/
def web : Web Bool Unit where
  level t _ := match t with
    | 0 => 1
    | 1 => 1
    | _ + 2 => 0
  active t x := match x with
    | true => t = 1
    | false => False
  requires t x _ := match x with
    | true => False
    | false => 1 < t
  need _ _ _ := 1
  draws t x _ := match t, x with
    | 0, _ => False
    | 1, true => True
    | 1, false => False
    | _ + 2, _ => False

/-- The drawer's part. -/
def part : Bool → Bool := fun x => x

/-- Without the drawer's part the condition stays at one. -/
theorem withheld : flow.WithheldLevels part web fun _ _ => 1 :=
  ⟨fun t () => match t with
    | 0 => rfl
    | 1 => rfl
    | _ + 2 => rfl,
   fun () => rfl⟩

/-- **Arising, then narrowing.** The flow balances, only active formations take, and only from what
they draw on, and only active formations give; the drawer is not active at the start and arises
across the first step; and the levels without its part widen those with it. -/
theorem arises_narrows {l : Nat → Unit → Nat} (without : flow.WithheldLevels part web l) :
    flow.Balances web ∧ flow.Taking web ∧ flow.Acting web ∧ ¬ web.active 0 true ∧
      web.Arises 0 true ∧ web.Widens l web.level :=
  have balances : flow.Balances web := fun t () => match t with
    | 0 => rfl
    | 1 => rfl
    | _ + 2 => rfl
  ⟨balances,
   fun t x () _ positive => match t, x with
    | 0, _ => absurd positive (Nat.lt_irrefl 0)
    | 1, true => ⟨rfl, trivial⟩
    | 1, false => absurd positive (Nat.lt_irrefl 0)
    | _ + 2, _ => absurd positive (Nat.lt_irrefl 0),
   fun _ _ () _ positive => absurd positive (Nat.lt_irrefl 0),
   fun no => Nat.noConfusion (show (0 : Nat) = 1 from no),
   ⟨fun no => Nat.noConfusion (show (0 : Nat) = 1 from no), rfl⟩,
   ⟨balances.opens_nothing without fun t () => match t with
      | 0 => Nat.zero_le _
      | 1 => Nat.zero_le _
      | _ + 2 => Nat.zero_le _,
    2, false, fun () _ => Nat.le_of_eq (without.unique withheld 2 ()).symm,
    fun supported => Nat.not_succ_le_zero 0 (supported () (Nat.lt_succ_self 1))⟩⟩

end ArisingDrawer

/-! A member that arises across the first step and then gives a condition one unit a later
dependence needs. -/

namespace ArisingGiver

/-- Across the second step the giver `true` gives the condition one unit; nothing takes. -/
def flow : Flow Bool Unit where
  present t := match t with
    | 0 => []
    | 1 => [true]
    | _ + 2 => []
  take _ _ _ := 0
  give t x _ := match t, x with
    | 0, _ => 0
    | 1, true => 1
    | 1, false => 0
    | _ + 2, _ => 0

/-- The giver requires nothing and is active at the second step only. `false` requires the
condition at need one from the third step on and is never active. -/
def web : Web Bool Unit where
  level t _ := match t with
    | 0 => 0
    | 1 => 0
    | _ + 2 => 1
  active t x := match x with
    | true => t = 1
    | false => False
  requires t x _ := match x with
    | true => False
    | false => 1 < t
  need _ _ _ := 1
  draws _ _ _ := False

/-- The giver's part. -/
def part : Bool → Bool := fun x => x

/-- Without the giver's part the condition stays at zero. -/
theorem withheld : flow.WithheldLevels part web fun _ _ => 0 :=
  ⟨fun t () => match t with
    | 0 => rfl
    | 1 => rfl
    | _ + 2 => rfl,
   fun () => rfl⟩

/-- **Arising, then widening.** The flow balances, only active formations take, and only from what
they draw on, and only active formations give; the giver is not active at the start and arises
across the first step; and the levels with its part widen those without it. -/
theorem arises_widens {l : Nat → Unit → Nat} (without : flow.WithheldLevels part web l) :
    flow.Balances web ∧ flow.Taking web ∧ flow.Acting web ∧ ¬ web.active 0 true ∧
      web.Arises 0 true ∧ web.Widens web.level l :=
  have balances : flow.Balances web := fun t () => match t with
    | 0 => rfl
    | 1 => rfl
    | _ + 2 => rfl
  ⟨balances,
   fun _ _ () _ positive => absurd positive (Nat.lt_irrefl 0),
   fun t x () _ positive => match t, x with
    | 0, _ => absurd positive (Nat.lt_irrefl 0)
    | 1, true => rfl
    | 1, false => absurd positive (Nat.lt_irrefl 0)
    | _ + 2, _ => absurd positive (Nat.lt_irrefl 0),
   fun no => Nat.noConfusion (show (0 : Nat) = 1 from no),
   ⟨fun no => Nat.noConfusion (show (0 : Nat) = 1 from no), rfl⟩,
   ⟨balances.closes_nothing without fun t () => match t with
      | 0 => Nat.zero_le _
      | 1 => Nat.zero_le _
      | _ + 2 => Nat.zero_le _,
    2, false, fun () _ => Nat.le_refl 1,
    fun admits => Nat.not_succ_le_zero 0
      (Nat.le_trans (admits () (Nat.lt_succ_self 1)) (Nat.le_of_eq (without.unique withheld 2 ())))⟩⟩

end ArisingGiver

end Becoming