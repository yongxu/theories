import Becoming.Locality
import Becoming.Premises
import Becoming.Witnesses

/-!
# Sampling: the laws of one step at coarser steps

One commitment of the spine's representation is discrete steps. Ren's order is to finish
coarser steps first, then continuous time. This module settles the first: read a world at
strictly increasing times `σ`, each coarse step being the stretch of fine steps from `σ s` to
just before `σ (s + 1)`, and ask which of the local conditions of `Becoming.Locality` hold
across a coarse step where they hold across the fine steps inside it. The laws themselves
hold of every world, so of a world read at coarser steps; what has to be shown is whether
their conditions compose. Each condition is stated at one coarse step, with its hypotheses on
the fine steps of that coarse step only. The move is to localize; the global readings of
the premises are corollaries.

* **What composes, at one coarse step.**
  - Balance on a family composes (`Flow.BalancesOn.sample`), where each relatum is listed
    once at the fine steps inside (the coarse tally counts a relatum once, the fine tallies
    as often as it is listed): across the coarse step a condition's change is what the fine
    steps take and give, composed (`balance_over_stretch_on`, `Flow.sample_taken_on`,
    `Flow.sample_given_on`).
  - Dissipation on a family composes, with no condition on listing
    (`Flow.DissipatesOn.sample`): the coarse inequality is the sum of the fine ones.
  - Closure is exact: a family is closed across a coarse step exactly when it is closed
    across each fine step inside (`Flow.sample_closedAt_iff`), since amounts are natural
    numbers and a sum vanishes termwise.
  - Running down composes where the family holds what stands at the two coarse ends only,
    not at the steps between (`Flow.RunsDownOn.sample`); a family running down across every
    fine step runs down across the coarse step (`Flow.RunsDownOn.sample_of_fine`).
* **The laws at the coarse step.** So the law of one exchange holds across the coarse step
  with the fine conditions: some standing changes across it exactly when the family's
  total at its end is below its total at its start (`Flow.sample_changes_iff`); and with
  balance at the fine steps, a condition comes to stand across the coarse step exactly when
  it stood at nothing and the fine steps gave it more than they took, and ceases to stand
  exactly when it stood and the fine steps took all it had with all they gave
  (`Flow.sample_comesToStand_iff`, `Flow.sample_ceasesToStand_iff`).
* **What does not compose back.** Balance and dissipation at the coarse step do not give them
  at the fine steps: fine imbalances can cancel (`Cancelling.coarse_not_fine`), and a fine
  step giving without loss can be outweighed by a later one (`Averaging.coarse_not_fine`).
* **What is step-relative.** Only active relata giving, and only active relata taking, do
  not compose: in the strobe a relatum is on at the second fine step of each coarse step,
  gives and takes there, and is off at both sampling times
  (`Strobe.acting_taking_step_relative`). They compose for one relatum where it is active at
  the first fine step whenever it is active inside (`Flow.sample_acting_on`,
  `Flow.sample_taking_on`), as when each coarse step is one fine step (`Web.held_of_unit`)
  or activity is constant on the intervals (`Web.held_of_constant`). Bounded transmission of
  dependences does not compose either: a gift made inside a coarse step, before the receiver
  comes to stand, is read as a descent across the coarse step
  (`Delay.transmitting_step_relative`).
* **The web.** A web read at the times `σ` (`Web.sample`) shows the fine web at those times,
  so what is stated of one step, activity needing support, embodiment and a census, is
  stated of the sampled fine step (`Web.sample_dependent`, `Web.sample_embodied`,
  `Web.sample_census`, `Web.sample_standingCensus`). Where activity is decided, arising or
  ceasing across a coarse step is arising or ceasing across a fine step inside it
  (`Web.sample_arises`, `Web.sample_ceases`), so recurring at the coarse steps is recurring
  at the fine ones, not conversely (`Strobe.converse_fails`).
* **Corollaries.** The global readings follow: balance (given listing once), dissipation,
  activity needing support, embodiment and a census survive the reading
  (`Flow.sample_balances`, `Flow.sample_dissipative`, `World.sample_survives`), and a
  finite world read at a coarser step rests, with no decision procedure
  (`World.sample_rests_unrefuted`).

Not shown: continuous time, which comes after; that a becoming given with no step at all can
be represented by discrete steps; and that listing once can be dropped for balance. The
sampling times are strictly increasing; irregular and unbounded intervals are allowed, but
the fine steps between samples are taken as given, so refining below them is not treated.
It is a reading at a coarser step, not a refinement of the unit of amounts
(`Becoming.Resolution`). No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

/-! ## Sampling times -/

/-- Sampling times: strictly increasing step numbers, the coarse step `s` being read as
the stretch from the fine step `σ s` to just before `σ (s + 1)`. -/
def Strict (σ : Nat → Nat) : Prop :=
  ∀ s, σ s < σ (s + 1)

/-- A strictly increasing sampling reaches at least as late as the step number. -/
theorem Strict.le_self {σ : Nat → Nat} (strict : Strict σ) : ∀ s, s ≤ σ s
  | 0 => Nat.zero_le _
  | s + 1 => Nat.succ_le_of_lt (Nat.lt_of_le_of_lt (strict.le_self s) (strict s))

/-- A strictly increasing sampling orders its times strictly. -/
theorem Strict.lt {σ : Nat → Nat} (strict : Strict σ) {a : Nat} :
    ∀ {b : Nat}, a < b → σ a < σ b
  | 0, lt => absurd lt (Nat.not_lt_zero a)
  | b + 1, lt => match Nat.lt_or_ge a b with
    | .inl below => Nat.lt_trans (strict.lt below) (strict b)
    | .inr above => Eq.subst (motive := fun x => σ x < σ (b + 1))
        (Nat.le_antisymm (Nat.le_of_lt_succ lt) above).symm (strict b)

/-- Sampling a sampling is a sampling. -/
theorem Strict.comp {σ τ : Nat → Nat} (strict : Strict σ) (strict' : Strict τ) :
    Strict fun s => σ (τ s) :=
  fun s => strict.lt (strict' s)

/-- The fine steps `σ s`, `σ s + 1`, …, `σ (s + 1) - 1` read as one coarse step. -/
def span (σ : Nat → Nat) (s : Nat) : List Nat :=
  steps (σ s) (σ (s + 1) - σ s)

theorem mem_span {σ : Nat → Nat} (strict : Strict σ) {s j : Nat} (mem : j ∈ span σ s) :
    σ s ≤ j ∧ j < σ (s + 1) :=
  match between_of_mem_steps mem with
  | ⟨le, lt⟩ => ⟨le, Nat.lt_of_lt_of_le lt
      (Nat.le_of_eq (add_sub_of_le (Nat.le_of_lt (strict s))))⟩

theorem span_mem {σ : Nat → Nat} (strict : Strict σ) {s j : Nat} (le : σ s ≤ j)
    (lt : j < σ (s + 1)) : j ∈ span σ s :=
  steps_of_within le (Nat.lt_of_lt_of_le lt
    (Nat.le_of_eq (add_sub_of_le (Nat.le_of_lt (strict s))).symm))

/-- The last fine step of a coarse step lies in it, and the step after it is the next
sampling time. -/
theorem last_of_span {σ : Nat → Nat} (strict : Strict σ) (s : Nat) :
    ∃ j, j ∈ span σ s ∧ j + 1 = σ (s + 1) :=
  match le_dest (strict s) with
  | ⟨m, same⟩ => ⟨σ s + m, span_mem strict (Nat.le_add_right _ _)
      (Nat.lt_of_lt_of_le (Nat.lt_succ_self _)
        (Nat.le_of_eq ((Nat.add_right_comm (σ s) m 1).trans same.symm))),
    (Nat.add_right_comm (σ s) m 1).trans same.symm⟩

/-! ## Reading a web at coarser steps -/

variable {F C : Type}

namespace Web

/-- A web read at the times `σ`: the coarse step `s` shows what the fine step `σ s` shows. -/
def sample (W : Web F C) (σ : Nat → Nat) : Web F C :=
  ⟨fun s => W.level (σ s), fun s => W.active (σ s), fun s => W.requires (σ s),
    fun s => W.need (σ s), fun s => W.draws (σ s)⟩

variable {W : Web F C} (σ : Nat → Nat)

/-- Sampling a sampling is sampling at the composed times. -/
theorem sample_sample (τ : Nat → Nat) : (W.sample σ).sample τ = W.sample fun s => σ (τ s) :=
  rfl

/-- Activity needing support survives sampling: a coarse step shows a fine step. -/
theorem sample_dependent (dependent : W.Dependent) : (W.sample σ).Dependent :=
  fun s f active => dependent (σ s) f active

/-- A relatum standing exactly while active does so at the sampled steps. -/
theorem sample_embodied {X : Type} {W : Web X X} {x : X} (embodied : W.Embodied x) :
    (W.sample σ).Embodied x :=
  fun s => embodied (σ s)

/-- A census of the active relata gives a census of the sampled web: list the relata active
at the sampling times. -/
theorem sample_census {alive : Nat → List F} (census : W.Census alive) :
    (W.sample σ).Census fun s => alive (σ s) :=
  fun s => census (σ s)

/-- A census of what stands gives a census of what stands at the sampling times. -/
theorem sample_standingCensus {stand : Nat → List C} (census : W.StandingCensus stand) :
    (W.sample σ).StandingCensus fun s => stand (σ s) :=
  fun s => census (σ s)

end Web

/-- What fails at one step and holds at a later one arose across some step between them,
where the property is decided. Along the successor from `T` to `t`, the property's not arising
is transitive, and it does arise from `T` to `t`, so a step where it arises lies on the line
(`«两端分则中有标»`), its place read back as order (`Map.step_reached_le`). -/
theorem arises_within {p : Nat → Prop} [∀ n, Decidable (p n)] {T : Nat} :
    ∀ {t : Nat}, T ≤ t → ¬ p T → p t → ∃ u, T ≤ u ∧ u < t ∧ ¬ p u ∧ p (u + 1) :=
  fun le absent held => match Map.step_reaches_of_le le with
  | .inl same => absurd held (same ▸ absent)
  | .inr line =>
    match «两端分则中有标» (K := fun x y => ¬ (¬ p x ∧ p y)) (fun _ _ _ => (Decidable.em _).symm)
      (fun k₁ k₂ ⟨no, yes⟩ => k₂ ⟨fun m => k₁ ⟨no, m⟩, yes⟩) line (fun k => k ⟨absent, held⟩) with
    | ⟨u, _, ⟨next, _⟩, ⟨no, yes⟩, from_, to⟩ => ⟨u, Map.step_reached_le from_,
      show u + 1 ≤ _ from next ▸ Map.step_reached_le to, no, next ▸ yes⟩

/-- What holds at one step and fails at a later one ceased across some step between them,
where the property is decided: its failing arose there (`arises_within`). -/
theorem ceases_within {p : Nat → Prop} [∀ n, Decidable (p n)] {T : Nat} :
    ∀ {t : Nat}, T ≤ t → p T → ¬ p t → ∃ u, T ≤ u ∧ u < t ∧ p u ∧ ¬ p (u + 1) :=
  fun le held gone => match arises_within (p := fun n => ¬ p n) le (fun no => no held) gone with
  | ⟨u, from_, below, no, yes⟩ => ⟨u, from_, below, Decidable.of_not_not no, yes⟩

namespace Web

variable {W : Web F C} {σ : Nat → Nat}

/-- A relatum arising across a coarse step arises across some fine step inside it, where
activity is decided. -/
theorem sample_arises [∀ t x, Decidable (W.active t x)] (strict : Strict σ) {s : Nat} {x : F}
    (arises : (W.sample σ).Arises s x) :
    ∃ t, σ s ≤ t ∧ t < σ (s + 1) ∧ W.Arises t x :=
  match arises_within (p := fun t => W.active t x) (Nat.le_of_lt (strict s)) arises.1 arises.2 with
  | ⟨u, from_, below, no, yes⟩ => ⟨u, from_, below, no, yes⟩

/-- A relatum ceasing across a coarse step ceases across some fine step inside it, where
activity is decided. -/
theorem sample_ceases [∀ t x, Decidable (W.active t x)] (strict : Strict σ) {s : Nat} {x : F}
    (ceases : (W.sample σ).Ceases s x) :
    ∃ t, σ s ≤ t ∧ t < σ (s + 1) ∧ W.Ceases t x :=
  match ceases_within (p := fun t => W.active t x) (Nat.le_of_lt (strict s)) ceases.1 ceases.2 with
  | ⟨u, from_, below, yes, no⟩ => ⟨u, from_, below, yes, no⟩

/-- Arising at arbitrarily late coarse steps is arising at arbitrarily late fine steps. -/
theorem sample_unceasing [∀ t x, Decidable (W.active t x)] (strict : Strict σ)
    (unceasing : (W.sample σ).Unceasing) : W.Unceasing :=
  fun N => match unceasing N with
  | ⟨s, x, later, arises⟩ => match sample_arises strict arises with
    | ⟨t, from_, _, arising⟩ =>
      ⟨t, x, Nat.le_trans later (Nat.le_trans (strict.le_self s) from_), arising⟩

/-- Ceasing at arbitrarily late coarse steps is ceasing at arbitrarily late fine steps. -/
theorem sample_ceasing [∀ t x, Decidable (W.active t x)] (strict : Strict σ)
    (ceasing : ∀ N, ∃ s x, N ≤ s ∧ (W.sample σ).Ceases s x) :
    ∀ N, ∃ t x, N ≤ t ∧ W.Ceases t x :=
  fun N => match ceasing N with
  | ⟨s, x, later, ceases⟩ => match sample_ceases strict ceases with
    | ⟨t, from_, _, ceasing⟩ =>
      ⟨t, x, Nat.le_trans later (Nat.le_trans (strict.le_self s) from_), ceasing⟩

end Web

/-! ## Flickering inside the sampling interval -/

namespace Strobe

/-- Off at the first step, and switched at every step. -/
def flick : Nat → Bool
  | 0 => false
  | t + 1 => !flick t

/-- The times `0, 2, 4, …`: two fine steps to each coarse step. -/
def twice (s : Nat) : Nat :=
  2 * s

theorem twice_strict : Strict twice :=
  fun _ => Nat.lt_add_of_pos_right (Nat.succ_pos 1)

/-- At the even steps it is off. -/
theorem flick_even : ∀ s, flick (twice s) = false
  | 0 => rfl
  | s + 1 => (congrArg (fun b => !(!b)) (flick_even s)).trans rfl

/-- At the odd steps it is on. -/
theorem flick_odd (s : Nat) : flick (twice s + 1) = true :=
  (congrArg (fun b => !b) (flick_even s)).trans rfl

/-- One relatum, active exactly while switched on, with no dependences and nothing
standing. -/
def web : Web Unit Unit where
  level _ _ := 0
  active t _ := flick t = true
  requires _ _ _ := False
  need _ _ _ := 0
  draws t _ _ := flick t = true

instance active_decided : ∀ t x, Decidable (web.active t x) :=
  fun t _ => inferInstanceAs (Decidable (flick t = true))

/-- It arises at every even step and ceases at every odd one. -/
theorem fine_arises (s : Nat) : web.Arises (twice s) () :=
  ⟨fun on => Bool.noConfusion ((flick_even s).symm.trans on), flick_odd s⟩

theorem fine_ceases (s : Nat) : web.Ceases (twice s + 1) () :=
  ⟨flick_odd s, fun on => Bool.noConfusion ((on.symm.trans (flick_even (s + 1))))⟩

/-- Read at the even steps, it is never active, so nothing arises or ceases. -/
theorem coarse_quiet (s : Nat) : ¬ (web.sample twice).active s () :=
  fun on => Bool.noConfusion ((flick_even s).symm.trans on)

/-- Arising recurring at the fine steps does not give arising at the coarse steps: activity
that flickers inside every sampling interval shows nothing at the sampling times. The
converse of `Web.sample_unceasing` and of `Web.sample_ceasing` fails. -/
theorem converse_fails :
    web.Unceasing ∧ (∀ N, ∃ t x, N ≤ t ∧ web.Ceases t x) ∧
    ¬ (web.sample twice).Unceasing ∧ ¬ (∀ N, ∃ s x, N ≤ s ∧ (web.sample twice).Ceases s x) :=
  ⟨fun N => ⟨twice N, (), twice_strict.le_self N, fine_arises N⟩,
   fun N => ⟨twice N + 1, (), Nat.le_trans (twice_strict.le_self N) (Nat.le_succ _),
     fine_ceases N⟩,
   fun unceasing => match unceasing 0 with
     | ⟨_, _, _, arises⟩ => coarse_quiet _ arises.2,
   fun ceasing => match ceasing 0 with
     | ⟨_, _, _, ceases⟩ => coarse_quiet _ ceases.1⟩

end Strobe

/-! ## Reading a flow at coarser steps

A coarse step holds several fine steps. A relatum takes part in the coarse step when it
takes part in some fine step of it, and takes and gives there what it takes and gives
across the fine steps it takes part in. -/

section Gates

variable {α : Type}

/-- A quantity, kept where a decision holds and zero where it fails. -/
def gateBy {p : Prop} : Decidable p → Nat → Nat
  | .isTrue _, x => x
  | .isFalse _, _ => 0

/-- A quantity of a relatum, kept at the steps it takes part in. -/
def gate [DecidableEq α] (a : α) (l : List α) (x : Nat) : Nat :=
  gateBy (decideMem a l) x

theorem gateBy_of {p : Prop} (h : p) : ∀ (d : Decidable p) (x : Nat), gateBy d x = x
  | .isTrue _, _ => rfl
  | .isFalse no, _ => absurd h no

theorem gateBy_of_not {p : Prop} (h : ¬ p) : ∀ (d : Decidable p) (x : Nat), gateBy d x = 0
  | .isTrue yes, _ => absurd yes h
  | .isFalse _, _ => rfl

theorem gateBy_zero {p : Prop} {x : Nat} (zero : p → x = 0) : ∀ d : Decidable p, gateBy d x = 0
  | .isTrue yes => zero yes
  | .isFalse _ => rfl

theorem gate_mem [DecidableEq α] {a : α} {l : List α} (mem : a ∈ l) (x : Nat) :
    gate a l x = x :=
  gateBy_of mem _ x

theorem mem_of_gateBy_pos {p : Prop} {x : Nat} : ∀ d : Decidable p, 0 < gateBy d x → p
  | .isTrue yes, _ => yes
  | .isFalse _, positive => absurd positive (Nat.lt_irrefl 0)

/-- A positive quantity kept at a relatum is one of a step it takes part in. -/
theorem mem_of_gate_pos [DecidableEq α] {a : α} {l : List α} {x : Nat}
    (positive : 0 < gate a l x) : a ∈ l :=
  mem_of_gateBy_pos (decideMem a l) positive

/-- Totals commute with keeping. -/
theorem total_gateBy {p : Prop} {β : Type} (d : Decidable p) (cs : List β) (q : β → Nat) :
    total cs (fun c => gateBy d (q c)) = gateBy d (total cs q) :=
  match d with
  | .isTrue _ => rfl
  | .isFalse _ => total_zero cs

/-- A total over a list without repetition of a quantity kept at the members of a list
without repetition inside it is the total over that list. -/
theorem total_gate [DecidableEq α] {U P : List α} (distinctU : Distinct U)
    (distinctP : Distinct P) (inside : ∀ a, a ∈ P → a ∈ U) (q : α → Nat) :
    total U (fun a => gate a P (q a)) = total P q :=
  have same : total P (fun a => gate a P (q a)) = total P q :=
    total_congr_on fun a mem => gate_mem mem (q a)
  Nat.le_antisymm
    (Nat.le_trans
      (total_le_of_support distinctU fun _ _ positive => mem_of_gate_pos positive)
      (Nat.le_of_eq same))
    (Nat.le_trans (Nat.le_of_eq same.symm)
      (total_le_of_support distinctP fun a mem _ => inside a mem))

end Gates

section Mentions

variable {α : Type}

theorem mem_insertNew {a x : α} {l : List α} :
    ∀ d : Decidable (a ∈ l), x ∈ insertNew a l d → x = a ∨ x ∈ l
  | .isTrue _, mem => .inr mem
  | .isFalse _, mem => mem_cons_cases mem

/-- Whatever is adjoined to a list was on one of the two. -/
theorem mem_adjoin [DecidableEq α] {l : List α} {x : α} :
    ∀ ds : List α, x ∈ adjoin ds l → x ∈ ds ∨ x ∈ l
  | [], mem => .inr mem
  | a :: ds, mem => match mem_insertNew (decideMem a (adjoin ds l)) mem with
    | .inl same => .inl (Eq.subst (motive := fun y => y ∈ a :: ds) same.symm (.head ds))
    | .inr mem => match mem_adjoin ds mem with
      | .inl held => .inl (.tail a held)
      | .inr held => .inr held

end Mentions

variable {F C : Type}

namespace Flow

variable [DecidableEq F] (L : Flow F C)

/-- The relata taking part in some fine step of a list of steps, each once. -/
def unionPresent : List Nat → List F
  | [] => []
  | j :: js => adjoin (L.present j) (unionPresent js)

/-- The union lists each relatum once, and exactly those taking part in a listed step. -/
theorem unionPresent_spec : ∀ js : List Nat, Distinct (L.unionPresent js) ∧
    (∀ j, j ∈ js → ∀ f, f ∈ L.present j → f ∈ L.unionPresent js) ∧
    (∀ f, f ∈ L.unionPresent js → ∃ j, j ∈ js ∧ f ∈ L.present j)
  | [] => ⟨trivial, (fun _ no => nomatch no), (fun _ no => nomatch no)⟩
  | j :: js => match adjoin_spec (unionPresent_spec js).1 (L.present j) with
    | ⟨distinct, left, right⟩ =>
      ⟨distinct,
       fun k mem f held => match mem_cons_cases mem with
         | .inl same => Eq.subst (motive := fun x => f ∈ L.present x → f ∈ L.unionPresent (j :: js))
             same.symm (left f) held
         | .inr mem => right f ((unionPresent_spec js).2.1 k mem f held),
       fun f mem => match mem_adjoin (L.present j) mem with
         | .inl held => ⟨j, .head js, held⟩
         | .inr held => match (unionPresent_spec js).2.2 f held with
           | ⟨k, mem, held⟩ => ⟨k, .tail j mem, held⟩⟩

/-- The flow read at the times `σ`: across the coarse step `s` the relata taking part in some
fine step of it take part, and each takes and gives what it takes and gives across the fine
steps it takes part in. -/
def sample (σ : Nat → Nat) : Flow F C where
  present s := L.unionPresent (span σ s)
  take s f c := total (span σ s) fun j => gate f (L.present j) (L.take j f c)
  give s f c := total (span σ s) fun j => gate f (L.present j) (L.give j f c)

/-- Each relatum is listed once at every step. -/
def Once : Prop :=
  ∀ t, Distinct (L.present t)

variable {L} (σ : Nat → Nat)

/-- The sampled flow lists each relatum once. -/
theorem sample_once : (L.sample σ).Once :=
  fun s => (L.unionPresent_spec (span σ s)).1

/-- What the coarse step takes from a condition is what the fine steps in it take, where
each relatum is listed once at the fine steps inside. -/
theorem sample_taken_on {s : Nat} (once : ∀ j, j ∈ span σ s → Distinct (L.present j))
    (c : C) : (L.sample σ).taken s c = total (span σ s) fun j => L.taken j c :=
  (total_swap (fun f j => gate f (L.present j) (L.take j f c)) (span σ s)
    ((L.unionPresent (span σ s)))).trans
    (total_congr_on fun j mem =>
      total_gate (L.unionPresent_spec (span σ s)).1 (once j mem)
        ((L.unionPresent_spec (span σ s)).2.1 j mem) (fun f => L.take j f c))

/-- What the coarse step gives a condition is what the fine steps in it give, where each
relatum is listed once at the fine steps inside. -/
theorem sample_given_on {s : Nat} (once : ∀ j, j ∈ span σ s → Distinct (L.present j))
    (c : C) : (L.sample σ).given s c = total (span σ s) fun j => L.given j c :=
  (total_swap (fun f j => gate f (L.present j) (L.give j f c)) (span σ s)
    ((L.unionPresent (span σ s)))).trans
    (total_congr_on fun j mem =>
      total_gate (L.unionPresent_spec (span σ s)).1 (once j mem)
        ((L.unionPresent_spec (span σ s)).2.1 j mem) (fun f => L.give j f c))

theorem sample_taken (once : L.Once) (s : Nat) (c : C) :
    (L.sample σ).taken s c = total (span σ s) fun j => L.taken j c :=
  sample_taken_on σ (fun j _ => once j) c

theorem sample_given (once : L.Once) (s : Nat) (c : C) :
    (L.sample σ).given s c = total (span σ s) fun j => L.given j c :=
  sample_given_on σ (fun j _ => once j) c

variable {W : Web F C}

/-- Balance on a family composes: balanced on it across each fine step of a coarse step,
each relatum listed once at those steps, the flow read at the coarse step balances on it
across the coarse step, the change of a member being what the fine steps take and give,
composed. Without listing once the coarse tally would count a relatum once and the fine
tallies more. -/
theorem BalancesOn.sample {cs : List C} {s : Nat} (strict : Strict σ)
    (once : ∀ j, j ∈ span σ s → Distinct (L.present j))
    (balances : ∀ j, j ∈ span σ s → L.BalancesOn W cs j) :
    (L.sample σ).BalancesOn (W.sample σ) cs s :=
  fun c mem =>
    have stretch := balance_over_stretch_on (q := fun t => W.level t c)
      (x := fun j => L.taken j c) (y := fun j => L.given j c) (σ s) (σ (s + 1) - σ s)
      fun t from_ below => balances t (steps_of_within from_ below) c mem
    have ends : W.level (σ (s + 1)) c + total (span σ s) (fun j => L.taken j c) =
        W.level (σ s) c + total (span σ s) (fun j => L.given j c) :=
      Eq.subst (motive := fun n => W.level n c + total (span σ s) (fun j => L.taken j c) =
        W.level (σ s) c + total (span σ s) (fun j => L.given j c))
        (add_sub_of_le (Nat.le_of_lt (strict s))) stretch
    (congrArg (W.level (σ (s + 1)) c + ·) (sample_taken_on σ once c)).trans
      (ends.trans (congrArg (W.level (σ s) c + ·) (sample_given_on σ once c).symm))

/-- So balance survives sampling, each relatum listed once at every fine step. -/
theorem sample_balances (strict : Strict σ) (once : L.Once) (balances : L.Balances W) :
    (L.sample σ).Balances (W.sample σ) :=
  balances_iff_on.mpr fun _ _ =>
    BalancesOn.sample σ strict (fun j _ => once j) fun j _ => balances.on _ j


/-- A sum is positive at most where one of its parts is. -/
theorem sign_add_le : ∀ a b : Nat, sign (a + b) ≤ sign a + sign b
  | 0, b => Nat.le_of_eq ((congrArg sign (Nat.zero_add b)).trans (Nat.zero_add (sign b)).symm)
  | _ + 1, _ => Nat.le_trans (sign_le_one _) (Nat.le_add_right 1 _)

/-- Dissipating at each member of a list is dissipating on the total over it. -/
theorem total_dissipates {γ : Type} {g k : γ → Nat} :
    ∀ I : List γ, (∀ j, j ∈ I → g j + sign (k j) ≤ k j) →
      total I g + sign (total I k) ≤ total I k
  | [], _ => Nat.le_refl 0
  | j :: I, each =>
    have rest := total_dissipates I fun i mem => each i (.tail j mem)
    Nat.le_trans
      (Nat.add_le_add_left (sign_add_le (k j) (total I k)) (g j + total I g))
      (Nat.le_trans
        (Nat.le_of_eq (Nat.add_add_add_comm (g j) (total I g) (sign (k j)) (sign (total I k))))
        (Nat.add_le_add (each j (.head I)) rest))

theorem gateBy_dissipates {p : Prop} {g k : Nat} (inside : p → g + sign k ≤ k) :
    ∀ d : Decidable p, gateBy d g + sign (gateBy d k) ≤ gateBy d k
  | .isTrue yes => inside yes
  | .isFalse _ => Nat.le_refl 0

theorem eq_zero_of_le_zero {n : Nat} (le : n ≤ 0) : n = 0 :=
  Nat.le_antisymm le (Nat.zero_le n)

/-- A positive total of quantities kept at the steps a relatum takes part in has a step it
takes part in at which the quantity is positive. -/
theorem pos_of_gated {P : Nat → List F} {q : Nat → Nat} {f : F} {I : List Nat}
    (positive : 0 < total I fun j => gate f (P j) (q j)) :
    ∃ j, j ∈ I ∧ f ∈ P j ∧ 0 < q j :=
  match total_pos I positive with
  | ⟨j, mem, pos⟩ => have taking := mem_of_gate_pos pos
    ⟨j, mem, taking, Eq.subst (motive := fun n => 0 < n) (gate_mem taking _) pos⟩

/-- A family closed at a coarse step is closed at each fine step in it: the amounts are
natural numbers, so a sum vanishes termwise. -/
theorem sample_closed {cs : List C} {s : Nat} (closed : (L.sample σ).ClosedAt cs s) :
    ∀ j, j ∈ span σ s → L.ClosedAt cs j :=
  fun j mem f held c outside =>
    match closed f ((L.unionPresent_spec (span σ s)).2.1 j mem f held) c outside with
    | ⟨taken, given⟩ =>
      ⟨eq_zero_of_le_zero (Nat.le_trans
        (Nat.le_of_eq (gate_mem held (L.take j f c)).symm)
        (Nat.le_trans (le_total_of_mem (q := fun j => gate f (L.present j) (L.take j f c)) mem)
          (Nat.le_of_eq taken))),
       eq_zero_of_le_zero (Nat.le_trans
        (Nat.le_of_eq (gate_mem held (L.give j f c)).symm)
        (Nat.le_trans (le_total_of_mem (q := fun j => gate f (L.present j) (L.give j f c)) mem)
          (Nat.le_of_eq given)))⟩

/-- Closure is exact at a coarse step: a family is closed across it exactly when it is closed
across each fine step inside. -/
theorem sample_closedAt_iff {cs : List C} {s : Nat} :
    (L.sample σ).ClosedAt cs s ↔ ∀ j, j ∈ span σ s → L.ClosedAt cs j :=
  ⟨sample_closed σ, fun closed f _ c outside =>
    ⟨(total_congr_on (g := fun _ => 0) fun j mem =>
        gateBy_zero (fun held => (closed j mem f held c outside).1)
          (decideMem f (L.present j))).trans (total_zero _),
     (total_congr_on (g := fun _ => 0) fun j mem =>
        gateBy_zero (fun held => (closed j mem f held c outside).2)
          (decideMem f (L.present j))).trans (total_zero _)⟩⟩

/-- What a relatum takes from a family across a coarse step is what it takes across the fine
steps it takes part in. -/
theorem sample_take_total (cs : List C) (s : Nat) (f : F) :
    total cs ((L.sample σ).take s f) =
      total (span σ s) fun j => gate f (L.present j) (total cs (L.take j f)) :=
  (total_swap (fun c j => gate f (L.present j) (L.take j f c)) (span σ s) cs).trans
    (total_congr (fun j => total_gateBy (decideMem f (L.present j)) cs (L.take j f)) (span σ s))

/-- What a relatum gives to a family across a coarse step is what it gives across the fine
steps it takes part in. -/
theorem sample_give_total (cs : List C) (s : Nat) (f : F) :
    total cs ((L.sample σ).give s f) =
      total (span σ s) fun j => gate f (L.present j) (total cs (L.give j f)) :=
  (total_swap (fun c j => gate f (L.present j) (L.give j f c)) (span σ s) cs).trans
    (total_congr (fun j => total_gateBy (decideMem f (L.present j)) cs (L.give j f)) (span σ s))

/-- Dissipation on a family composes: dissipated on across each fine step of a coarse step,
the family is dissipated on across the coarse step, the coarse inequality being the sum of
the fine ones, a positive total at most the sum of the parts. No condition on listing is
needed. -/
theorem DissipatesOn.sample {cs : List C} {s : Nat}
    (dissipates : ∀ j, j ∈ span σ s → L.DissipatesOn cs j) :
    (L.sample σ).DissipatesOn cs s :=
  fun f _ =>
    Nat.le_trans
      (Nat.le_of_eq (congr (congrArg (· + ·) (sample_give_total σ cs s f))
        (congrArg sign (sample_take_total σ cs s f))))
      (Nat.le_trans
        (total_dissipates (span σ s) fun j mem =>
          gateBy_dissipates (fun held => dissipates j mem f held)
            (decideMem f (L.present j)))
        (Nat.le_of_eq (sample_take_total σ cs s f).symm))

/-- So dissipation survives sampling: a family closed across a coarse step is closed across
each fine step in it, so dissipated on there. -/
theorem sample_dissipative (dissipative : L.Dissipative) : (L.sample σ).Dissipative :=
  fun cs _ distinct closed =>
    DissipatesOn.sample σ fun j mem => dissipative cs j distinct (sample_closed σ closed j mem)

/-- Running down composes: a family without repetition holding what stands at the two ends of
a coarse step, balanced and dissipated on across each fine step inside, each relatum listed
once there, runs down across the coarse step. What stands at the fine steps between is not
asked. -/
theorem RunsDownOn.sample {es : List C} {s : Nat} (strict : Strict σ)
    (once : ∀ j, j ∈ span σ s → Distinct (L.present j)) (distinct : Distinct es)
    (before : ∀ c, 0 < W.level (σ s) c → c ∈ es)
    (after : ∀ c, 0 < W.level (σ (s + 1)) c → c ∈ es)
    (balances : ∀ j, j ∈ span σ s → L.BalancesOn W es j)
    (dissipates : ∀ j, j ∈ span σ s → L.DissipatesOn es j) :
    (L.sample σ).RunsDownOn (W.sample σ) es s :=
  ⟨distinct, before, after, BalancesOn.sample σ strict once balances,
   DissipatesOn.sample σ dissipates⟩

/-- So a family running down across every fine step of a coarse step runs down across it. -/
theorem RunsDownOn.sample_of_fine {es : List C} {s : Nat} (strict : Strict σ)
    (once : ∀ j, j ∈ span σ s → Distinct (L.present j))
    (runs : ∀ j, j ∈ span σ s → L.RunsDownOn W es j) :
    (L.sample σ).RunsDownOn (W.sample σ) es s :=
  have first : σ s ∈ span σ s := span_mem strict (Nat.le_refl _) (strict s)
  match last_of_span strict s with
  | ⟨j, mem, next⟩ =>
    RunsDownOn.sample σ strict once (runs _ first).1 (runs _ first).2.1
      (fun c stands => (runs j mem).2.2.1 c
        (Eq.subst (motive := fun n => 0 < W.level n c) next.symm stands))
      (fun j mem => (runs j mem).2.2.2.1) fun j mem => (runs j mem).2.2.2.2

/-- The law of one exchange at a coarse step: with the fine conditions of `RunsDownOn.sample`,
some condition's standing changes across the coarse step exactly when the family's total at
its end is below its total at its start. -/
theorem sample_changes_iff {es : List C} {s : Nat} (strict : Strict σ)
    (once : ∀ j, j ∈ span σ s → Distinct (L.present j)) (distinct : Distinct es)
    (before : ∀ c, 0 < W.level (σ s) c → c ∈ es)
    (after : ∀ c, 0 < W.level (σ (s + 1)) c → c ∈ es)
    (balances : ∀ j, j ∈ span σ s → L.BalancesOn W es j)
    (dissipates : ∀ j, j ∈ span σ s → L.DissipatesOn es j) :
    (∃ c, (W.sample σ).Rises s c ∨ (W.sample σ).Falls s c) ↔
      W.stock es (σ (s + 1)) < W.stock es (σ s) :=
  (RunsDownOn.sample σ strict once distinct before after balances dissipates).changes_iff

/-- Coming to stand at a coarse step: with balance at the fine steps inside, each relatum
listed once there, a condition comes to stand across the coarse step exactly when it stood at
nothing and the fine steps gave it more than they took from it. -/
theorem sample_comesToStand_iff {cs : List C} {s : Nat} {c : C} (strict : Strict σ)
    (once : ∀ j, j ∈ span σ s → Distinct (L.present j))
    (balances : ∀ j, j ∈ span σ s → L.BalancesOn W cs j) (mem : c ∈ cs) :
    (W.sample σ).ComesToStand s c ↔ W.level (σ s) c = 0 ∧
      (total (span σ s) fun j => L.taken j c) < total (span σ s) fun j => L.given j c :=
  ((BalancesOn.sample σ strict once balances).comesToStand_iff mem).trans
    ⟨fun ⟨zero, more⟩ => ⟨zero, Nat.lt_of_le_of_lt (Nat.le_of_eq (sample_taken_on σ once c).symm)
        (Nat.lt_of_lt_of_le more (Nat.le_of_eq (sample_given_on σ once c)))⟩,
     fun ⟨zero, more⟩ => ⟨zero, Nat.lt_of_le_of_lt (Nat.le_of_eq (sample_taken_on σ once c))
        (Nat.lt_of_lt_of_le more (Nat.le_of_eq (sample_given_on σ once c).symm))⟩⟩

/-- Ceasing to stand at a coarse step: with balance at the fine steps inside, each relatum
listed once there, a condition ceases to stand across the coarse step exactly when it stood
and the fine steps took from it all it had with all they gave it. -/
theorem sample_ceasesToStand_iff {cs : List C} {s : Nat} {c : C} (strict : Strict σ)
    (once : ∀ j, j ∈ span σ s → Distinct (L.present j))
    (balances : ∀ j, j ∈ span σ s → L.BalancesOn W cs j) (mem : c ∈ cs) :
    (W.sample σ).CeasesToStand s c ↔ 0 < W.level (σ s) c ∧
      (total (span σ s) fun j => L.taken j c) =
        W.level (σ s) c + total (span σ s) fun j => L.given j c :=
  ((BalancesOn.sample σ strict once balances).ceasesToStand_iff mem).trans
    ⟨fun ⟨stands, all⟩ => ⟨stands, (sample_taken_on σ once c).symm.trans
        (all.trans (congrArg (W.level (σ s) c + ·) (sample_given_on σ once c)))⟩,
     fun ⟨stands, all⟩ => ⟨stands, (sample_taken_on σ once c).trans
        (all.trans (congrArg (W.level (σ s) c + ·) (sample_given_on σ once c).symm))⟩⟩

end Flow


namespace Web

variable (W : Web F C) (σ : Nat → Nat)

/-- Activity is *held* by the sampling when a relatum active inside a coarse step is already
active at its first fine step: activity is constant on the intervals, or at least starts
with them. -/
def Held : Prop :=
  ∀ s j x, σ s ≤ j → j < σ (s + 1) → W.active j x → W.active (σ s) x

/-- Drawing is held by the sampling when a relatum drawing on a condition inside a coarse
step already draws on it at its first fine step. -/
def DrawingHeld : Prop :=
  ∀ s j f c, σ s ≤ j → j < σ (s + 1) → W.draws j f c → W.draws (σ s) f c

variable {W σ}

/-- With one fine step to each coarse step, activity and drawing are held. -/
theorem held_of_unit (unit : ∀ s, σ (s + 1) = σ s + 1) :
    W.Held σ ∧ W.DrawingHeld σ :=
  ⟨fun s j x from_ below active =>
    Eq.subst (motive := fun n => W.active n x)
      (Nat.le_antisymm (Nat.le_of_lt_succ (Eq.subst (motive := fun n => j < n) (unit s) below))
        from_) active,
   fun s j f c from_ below draws =>
    Eq.subst (motive := fun n => W.draws n f c)
      (Nat.le_antisymm (Nat.le_of_lt_succ (Eq.subst (motive := fun n => j < n) (unit s) below))
        from_) draws⟩

/-- Activity constant on every interval is held. -/
theorem held_of_constant (constant : ∀ s j x, σ s ≤ j → j < σ (s + 1) →
    (W.active j x ↔ W.active (σ s) x)) : W.Held σ :=
  fun s j x from_ below => (constant s j x from_ below).mp

end Web

namespace Flow

variable [DecidableEq F] {L : Flow F C} {W : Web F C} {σ : Nat → Nat}

/-- Only active relata giving, for one relatum and condition at one coarse step: where the
relatum gives only while active at the fine steps inside, and is active at the first fine step
whenever it is active inside, it gives across the coarse step only while active. -/
theorem sample_acting_on {s : Nat} {f : F} {c : C} (strict : Strict σ)
    (acting : ∀ j, j ∈ span σ s → f ∈ L.present j → 0 < L.give j f c → W.active j f)
    (held : ∀ j, σ s ≤ j → j < σ (s + 1) → W.active j f → W.active (σ s) f) :
    0 < (L.sample σ).give s f c → (W.sample σ).active s f :=
  fun gives => match pos_of_gated gives with
  | ⟨j, mem, present, positive⟩ =>
    held j (mem_span strict mem).1 (mem_span strict mem).2 (acting j mem present positive)

/-- Only active relata taking, and only from what they draw on, for one relatum and
condition at one coarse step, likewise. -/
theorem sample_taking_on {s : Nat} {f : F} {c : C} (strict : Strict σ)
    (taking : ∀ j, j ∈ span σ s → f ∈ L.present j → 0 < L.take j f c →
      W.active j f ∧ W.draws j f c)
    (held : ∀ j, σ s ≤ j → j < σ (s + 1) → W.active j f → W.active (σ s) f)
    (drawing : ∀ j, σ s ≤ j → j < σ (s + 1) → W.draws j f c → W.draws (σ s) f c) :
    0 < (L.sample σ).take s f c → (W.sample σ).active s f ∧ (W.sample σ).draws s f c :=
  fun takes => match pos_of_gated takes with
  | ⟨j, mem, present, positive⟩ =>
    ⟨held j (mem_span strict mem).1 (mem_span strict mem).2
        (taking j mem present positive).1,
     drawing j (mem_span strict mem).1 (mem_span strict mem).2
        (taking j mem present positive).2⟩

/-- Where activity is held by the sampling, only active relata give at the coarse steps if
they do at the fine ones. -/
theorem sample_acting (strict : Strict σ) (held : W.Held σ) (acting : L.Acting W) :
    (L.sample σ).Acting (W.sample σ) :=
  fun _ _ _ _ => sample_acting_on strict (fun j _ present positive => acting j _ _ present positive)
    fun j from_ below => held _ j _ from_ below

/-- Where activity and drawing are held by the sampling, only active relata take, and only
from what they draw on, at the coarse steps if they do so at the fine ones. -/
theorem sample_taking (strict : Strict σ) (held : W.Held σ) (drawing : W.DrawingHeld σ)
    (taking : L.Taking W) : (L.sample σ).Taking (W.sample σ) :=
  fun _ _ _ _ => sample_taking_on strict (fun j _ present positive => taking j _ _ present positive)
    (fun j from_ below => held _ j _ from_ below) fun j from_ below => drawing _ j _ _ from_ below

end Flow

/-! ## Worlds read at coarser steps -/

namespace World

variable (w : World) [DecidableEq w.Relatum] (σ : Nat → Nat)

/-- A world read at the times `σ`: the same relata, with the flow and web read at the
sampling times. -/
def sample : World :=
  World.of w.Relatum (w.flow.sample σ) (w.web.sample σ)

variable {w σ}

theorem sample_dependent (dependent : w.Dependent) : (w.sample σ).Dependent :=
  Web.sample_dependent σ dependent

theorem sample_balanced (strict : Strict σ) (once : w.flow.Once) (balanced : w.Balanced) :
    (w.sample σ).Balanced :=
  Flow.sample_balances (F := w.Relatum) σ strict once balanced

theorem sample_dissipative (dissipative : w.Dissipative) : (w.sample σ).Dissipative :=
  Flow.sample_dissipative (F := w.Relatum) σ dissipative

theorem sample_embodied (embodied : w.Embodied) : (w.sample σ).Embodied :=
  fun x => Web.sample_embodied σ (embodied x)

theorem sample_counted (counted : w.Counted) : (w.sample σ).Counted :=
  match counted with
  | ⟨alive, census⟩ => ⟨fun s => alive (σ s), Web.sample_census σ census⟩

theorem sample_finite (finite : w.Finite) : (w.sample σ).Finite :=
  finite

/-- What survives reading a world at coarser steps: activity needing support, balance
(each relatum being listed once at every step), dissipation, embodiment and a census. -/
theorem sample_survives (strict : Strict σ) (once : w.flow.Once) :
    (w.Dependent → (w.sample σ).Dependent) ∧ (w.Balanced → (w.sample σ).Balanced) ∧
    (w.Dissipative → (w.sample σ).Dissipative) ∧ (w.Embodied → (w.sample σ).Embodied) ∧
    (w.Counted → (w.sample σ).Counted) :=
  ⟨sample_dependent, sample_balanced strict once, sample_dissipative, sample_embodied,
   sample_counted⟩

/-- The laws of a world hold at every step size: of a finite world read at coarser steps, whose
flow balances and dissipates and whose arisings are embodied, that it rests from some coarse step
on cannot be refuted, with no decision procedure (`World.rests_unrefuted`). -/
theorem sample_rests_unrefuted (strict : Strict σ)
    (finite : w.Finite) (once : w.flow.Once) (balanced : w.Balanced)
    (dissipative : w.Dissipative) (embodied : w.Embodied) :
    ¬ ¬ ∃ N, (w.sample σ).RestsFrom N :=
  rests_unrefuted (sample_finite finite)
    (sample_balanced strict once balanced) (sample_dissipative dissipative)
    (sample_embodied embodied).arising

end World


/-! ## Acting and taking are step-relative -/

namespace Strobe

/-- One for on, zero for off. -/
def bit : Bool → Nat
  | true => 1
  | false => 0

theorem on_of_bit {b : Bool} (positive : 0 < bit b) : b = true :=
  match b, positive with
  | true, _ => rfl
  | false, positive => absurd positive (Nat.lt_irrefl 0)

/-- The relatum takes and gives a unit across each step at which it is on, and nothing at
the others. -/
def flow : Flow Unit Unit where
  present _ := [()]
  take t _ _ := bit (flick t)
  give t _ _ := bit (flick t)

/-- The strobe: one relatum, on at the odd steps. -/
def world : World :=
  World.of Unit flow web

instance relatum_decided : DecidableEq world.Relatum :=
  fun a b => match a, b with
  | (), () => .isTrue rfl

/-- The list of the active relata at a step: the relatum while it is on. -/
def alive : Bool → List Unit
  | true => [()]
  | false => []

theorem alive_listed : ∀ b : Bool, Distinct (alive b) ∧ ∀ a : Unit, (b = true ↔ a ∈ alive b)
  | true => ⟨⟨(fun no => nomatch no), trivial⟩, fun _ => ⟨fun _ => .head [], fun _ => rfl⟩⟩
  | false => ⟨trivial, fun _ => ⟨fun on => Bool.noConfusion on, fun no => nomatch no⟩⟩

theorem once : world.flow.Once :=
  fun _ => ⟨(fun no => nomatch no), trivial⟩

/-- At the fine steps the strobe meets activity needing support, balance, a census, only
active relata giving and only active relata taking, and only from what they draw on. -/
theorem fine :
    world.Dependent ∧ world.Balanced ∧ world.Counted ∧ world.Acting ∧ world.Taking :=
  ⟨fun _ _ _ _ req => False.elim req,
   fun _ _ => rfl,
   ⟨fun t => alive (flick t), fun t => alive_listed (flick t)⟩,
   fun _ _ _ _ positive => on_of_bit positive,
   fun _ _ _ _ positive => ⟨on_of_bit positive, on_of_bit positive⟩⟩

/-- The relatum takes part in the first step of every coarse step and gives and takes a unit
across its second, at which it is on. -/
theorem coarse_gives (s : Nat) :
    () ∈ (world.sample twice).flow.present s ∧ 0 < (world.sample twice).flow.give s () () ∧
    0 < (world.sample twice).flow.take s () () :=
  have mem : twice s + 1 ∈ span twice s :=
    span_mem twice_strict (Nat.le_succ _) (Nat.lt_succ_self (twice s + 1))
  have on : 0 < bit (flick (twice s + 1)) :=
    Eq.subst (motive := fun b => 0 < bit b) (flick_odd s).symm Nat.zero_lt_one
  have kept : 0 < gate () [()] (bit (flick (twice s + 1))) :=
    Eq.subst (motive := fun n => 0 < n) (gate_mem (.head []) _).symm on
  ⟨(flow.unionPresent_spec (span twice s)).2.1 _ mem () (.head []),
   total_pos_of_mem (q := fun j => gate () [()] (bit (flick j))) mem kept,
   total_pos_of_mem (q := fun j => gate () [()] (bit (flick j))) mem kept⟩

/-- Reading the strobe at its even steps, a relatum gives and takes while inactive at both
sampling times: only active relata giving, and only active relata taking, are not preserved
by sampling. Activity needing support, balance and a census are. -/
theorem acting_taking_step_relative :
    ¬ (world.sample twice).Acting ∧ ¬ (world.sample twice).Taking :=
  ⟨fun acting => Bool.noConfusion
      ((flick_even 0).symm.trans (acting 0 () () (coarse_gives 0).1 (coarse_gives 0).2.1)),
   fun taking => Bool.noConfusion
      ((flick_even 0).symm.trans (taking 0 () () (coarse_gives 0).1 (coarse_gives 0).2.2).1)⟩

end Strobe


/-! ## Transmission is step-relative -/

namespace Delay

/-- One at the first step, zero after it. -/
def first : Nat → Nat := Witnesses.profile [1] 0

/-- Nothing at the first two steps, one from the third. -/
def lately : Nat → Nat := Witnesses.profile [0, 0] 1

/-- The second relatum stands from the third step on; at the third step it depends on the
first. Nothing is ever active and nothing is drawn on. -/
def web : Web Bool Bool where
  level t y := match y with
    | false => lately t
    | true => 0
  active _ _ := False
  requires t y c := t = 2 ∧ y = false ∧ c = true
  need _ _ _ := 0
  draws _ _ _ := False

/-- At the first step the first relatum gives to the second; nothing is ever taken. -/
def flow : Flow Bool Bool where
  present _ := [true]
  take _ _ _ := 0
  give t y x := match y, x with
    | true, false => first t
    | true, true => 0
    | false, _ => 0

/-- A world in which the gift precedes the standing. -/
def world : World :=
  World.of Bool flow web

instance relatum_decided : DecidableEq world.Relatum :=
  inferInstanceAs (DecidableEq Bool)

/-- The relatum that stands from the third step on comes to stand across the second, and
nothing is given across the second: nothing descends from anything. -/
theorem no_descent {t : Nat} {x g : Bool} : ¬ flow.DescendsAt web t x g :=
  fun ⟨_, positive, comes⟩ => match g, x, t, positive, comes with
    | true, false, 0, _, comes => absurd comes.2 (Nat.lt_irrefl 0)
    | true, false, _ + 1, positive, _ => absurd positive (Nat.lt_irrefl 0)
    | true, true, _, positive, _ => absurd positive (Nat.lt_irrefl 0)
    | false, _, _, positive, _ => absurd positive (Nat.lt_irrefl 0)

/-- With no descent at the fine steps, transmission holds of every dependence, vacuously. -/
theorem fine_transmitting : world.Transmitting :=
  ⟨0, fun _ _ _ _ descends _ => absurd descends no_descent⟩

/-- Read at the even steps, the second relatum comes to stand across the first coarse step
and the first relatum gave to it within that step. -/
theorem coarse_descends :
    (world.sample Strobe.twice).flow.DescendsAt (world.sample Strobe.twice).web 0 false true :=
  have mem : 0 ∈ span Strobe.twice 0 :=
    span_mem Strobe.twice_strict (Nat.le_refl _) (Nat.zero_lt_two)
  have kept : 0 < gate true [true] (flow.give 0 true false) :=
    Eq.subst (motive := fun n => 0 < n) (gate_mem (.head []) _).symm Nat.zero_lt_one
  ⟨(flow.unionPresent_spec (span Strobe.twice 0)).2.1 0 mem true (.head []),
   total_pos_of_mem (q := fun j => gate true [true] (flow.give j true false)) mem kept,
   Nat.lt_irrefl 0, Nat.zero_lt_one⟩

/-- Bounded transmission of dependences is not preserved by sampling: the gift is made
inside the coarse step, but not across the step at which the receiver comes to stand, so
the coarse step reads a descent the fine steps do not have, and the receiver's dependence is
not one of its giver's. -/
theorem transmitting_step_relative : world.Transmitting ∧ ¬ (world.sample Strobe.twice).Transmitting :=
  ⟨fine_transmitting, fun ⟨_, transmits⟩ =>
    have inherited := (transmits true 0 false true coarse_descends ⟨rfl, rfl, rfl⟩).1
    Nat.noConfusion inherited.1⟩

end Delay


/-! ## Balance and dissipation do not compose back -/

namespace Cancelling

/-- One relatum taking part throughout; across the first step it gives the one condition a
unit, across the second it takes a unit, and the condition stands at nothing throughout. -/
def flow : Flow Unit Unit where
  present _ := [()]
  take t _ _ := match t with
    | 1 => 1
    | _ => 0
  give t _ _ := match t with
    | 0 => 1
    | _ => 0

def web : Web Unit Unit where
  level _ _ := 0
  active _ _ := False
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- Balance at the coarse step does not give balance at the fine steps inside: across the
first coarse step the gift and the taking cancel, while neither fine step balances. -/
theorem coarse_not_fine :
    (flow.sample Strobe.twice).BalancesOn (web.sample Strobe.twice) [()] 0 ∧
      ¬ flow.BalancesOn web [()] 0 ∧ ¬ flow.BalancesOn web [()] 1 :=
  ⟨fun _ _ => rfl,
   fun balances => Nat.not_succ_le_zero 0 (Nat.le_of_eq (balances () (.head [])).symm),
   fun balances => Nat.not_succ_le_zero 0 (Nat.le_of_eq (balances () (.head [])))⟩

end Cancelling

namespace Averaging

/-- One relatum taking part throughout; across the first step it gives the one condition a
unit and takes a unit from it, across the second it takes five units. -/
def flow : Flow Unit Unit where
  present _ := [()]
  take t _ _ := match t with
    | 0 => 1
    | 1 => 5
    | _ => 0
  give t _ _ := match t with
    | 0 => 1
    | _ => 0

/-- Dissipation at the coarse step does not give dissipation at the fine steps inside: across
the first fine step the relatum gives back all it takes, which the second step's taking
outweighs across the coarse step. -/
theorem coarse_not_fine :
    (flow.sample Strobe.twice).DissipatesOn [()] 0 ∧ ¬ flow.DissipatesOn [()] 0 :=
  ⟨fun _ _ => Nat.le_add_right 2 4,
   fun dissipates => Nat.not_succ_le_self 1 (dissipates () (.head []))⟩

end Averaging

end Becoming

section ExchangeFlows

/-!
## Exchange flows: uniform descent, and what a sampled flow keeps of an absent relatum

`Becoming.Evolution` states the counting form of Price's equation and the selection bound it gives
on a flow (`Flow.selection_within`), and that the parents' amounts weighted by their offspring are,
where every parent has `k` offspring, `k` times the parents' total (`selected_uniform`).
`Becoming.Sampling` reads a flow at coarser times (`Flow.sample`), keeping each relatum's exchanges
at the fine steps it takes part in through a gate that is zero where the decision fails
(`gateBy_of_not`). This section states both of flows.

* **Uniform descent.** Where only active formations give and activity needs support, and every
  parent of a family depending on a condition leaves `k` descendants across the step, `k` times the
  parents' total need is at most `k` times the condition's level once for each parent
  (`selected_le_uniform`), and the descendants' total of any amount with what transmission lowered
  is at most that with what transmission raised (`selection_within_uniform`).
* **An absent relatum in a sampled flow.** A relatum taking part in no fine step of a coarse step
  takes nothing and gives nothing across it in the sampled flow (`sample_take_absent`,
  `sample_give_absent`).

No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

namespace ExchangeFlows

/-! ### Uniform descent -/

section Descent

variable {X : Type} {L : Flow X X} {W : Web X X}

/-- **Uniform descent bounds the parents' need.** Where only active formations give, activity
needs support, and each of a family of parents depending on `c` leaves `k` descendants across the
step from `t`, `k` times the parents' total need on `c` is at most `k` times the level of `c`
counted once for each parent. -/
theorem selected_le_uniform (acting : L.Acting W) (dependent : W.Dependent) {t : Nat} {c : X}
    {ps : List X} {kids : X → List X} (descend : ∀ p k, p ∈ ps → k ∈ kids p → L.DescendsAt W t k p)
    (depends : ∀ p, p ∈ ps → W.requires t p c) {k : Nat} (uniform : ∀ p, (kids p).length = k) :
    k * total ps (fun p => W.need t p c) ≤ k * (ps.length * W.level t c) :=
  Nat.le_trans (Nat.le_of_eq (selected_uniform ps kids _ k uniform).symm)
    (Nat.le_trans (Flow.selected_le acting dependent descend depends)
      (Nat.le_of_eq ((selected_uniform ps kids _ k uniform).trans
        (congrArg (k * ·) (total_const (W.level t c) ps)))))

/-- **Uniform descent bounds what the descendants carry.** Under the same premises, the
descendants' total of any amount, with what transmission lowered from the parents' needs, is at
most `k` times the level of `c` counted once for each parent, with what transmission raised. -/
theorem selection_within_uniform (acting : L.Acting W) (dependent : W.Dependent) {t : Nat}
    {c : X} {ps : List X} {kids : X → List X}
    (descend : ∀ p k, p ∈ ps → k ∈ kids p → L.DescendsAt W t k p)
    (depends : ∀ p, p ∈ ps → W.requires t p c) {k : Nat} (uniform : ∀ p, (kids p).length = k)
    (b : X → Nat) :
    offspring ps kids b + lowered ps kids (fun p => W.need t p c) b ≤
      k * (ps.length * W.level t c) + raised ps kids (fun p => W.need t p c) b :=
  Nat.le_trans (Flow.selection_within acting dependent descend depends b)
    (Nat.le_of_eq (congrArg (· + raised ps kids (fun p => W.need t p c) b)
      ((selected_uniform ps kids _ k uniform).trans
        (congrArg (k * ·) (total_const (W.level t c) ps)))))

end Descent

/-! ### An absent relatum in a sampled flow -/

section Sampled

variable {F C : Type} [DecidableEq F]

/-- **An absent relatum takes nothing in the sampled flow.** A relatum taking part in no fine step
of the coarse step `s` takes nothing from any condition across it. -/
theorem sample_take_absent (L : Flow F C) (σ : Nat → Nat) {s : Nat} {f : F}
    (absent : ∀ j, j ∈ span σ s → ¬ f ∈ L.present j) (c : C) : (L.sample σ).take s f c = 0 :=
  (total_congr_on fun j mem => gateBy_of_not (absent j mem) _ _).trans (total_zero _)

/-- **An absent relatum gives nothing in the sampled flow.** -/
theorem sample_give_absent (L : Flow F C) (σ : Nat → Nat) {s : Nat} {f : F}
    (absent : ∀ j, j ∈ span σ s → ¬ f ∈ L.present j) (c : C) : (L.sample σ).give s f c = 0 :=
  (total_congr_on fun j mem => gateBy_of_not (absent j mem) _ _).trans (total_zero _)

end Sampled

end ExchangeFlows

end Becoming

end ExchangeFlows
