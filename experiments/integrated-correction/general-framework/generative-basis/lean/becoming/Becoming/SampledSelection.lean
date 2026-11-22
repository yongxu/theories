import Becoming.Sampling
import Becoming.Selection

/-!
# Sampled selection: a selection through couplings, read at a coarser step

AI-written, 23 November 2026 (board row GR).

`Becoming.Sampling` reads a web and a flow at strictly increasing times and asks of the laws of one
step what holds across a coarse step where it holds across the fine steps inside it, what does not
come back, and what is relative to the step. `Becoming.Selection` states what a selection through a
formation's couplings can tell apart, and that it is blind beyond the coupling closure
(`Flow.unselected_beyond_coupling`). Neither module imports the other. This module asks
`Sampling`'s question of that selection, with no premise beyond those each statement names.
`atTimes σ l` is a level history read at the times `σ`.

* **A selection at the coarser step is a selection at the finer.** Being alike through the
  couplings at a coarse step is being alike through them at the fine step it reads
  (`Web.sample_alikeThrough_iff`, by definition), so histories alike through the couplings up to
  a fine step `σ t` are alike through them at the coarser steps up to `t`, the reading strict
  (`Web.AlikeThroughUpTo.sample`), and a selection through the couplings of the web read at a
  strict `σ`, up to `t`, taken back along the reading, is a selection through the couplings of
  the web up to `σ t` (`Web.SelectsThrough.of_sample`). What every
  selection at the coarser steps selects alike is what is alike through the couplings at the
  steps read (`Web.sample_selects_alike_iff`): this is `Web.selects_alike_iff` at the sampled web
  and says nothing more.
* **What couples in at the coarser step.** A condition coupled into a formation on the sampled
  web is coupled into it (`Web.sample_coupledInto`), and an exchange across a coarse step is an
  exchange at a fine step (`Flow.sample_exchanges`); so the coupling closure read at the coarser
  steps lies within the coupling closure (`Flow.sample_withinCoupling`). Exchange is not lost:
  with the reading strict and starting at step 0, an exchange at a fine step is an exchange
  across the coarse step that holds it (`Flow.exchanges_sample`, with `Strict.covers`). Coupling
  by level does not change with the step. So, with the reading strict and starting at step 0,
  the closure is smaller at the coarser steps only through a requirement that holds at no step
  read: where every dependence is a dependence at some step read, the coupling closure lies
  within the closure read at the coarser steps (`Flow.withinCoupling_sample`), and with
  `Flow.sample_withinCoupling` the two are one. `Strobe.coarse_quiet` shows the like of activity.
* **Withholding a part commutes with the reading.** The levels without a part, read at the
  coarser steps, are the levels without it of the flow read there, where the reading is strict
  and starts at step 0 and each relatum is listed once at every fine step
  (`Flow.WithheldLevels.sample`, from `Flow.BalancesOn.sample` of `Becoming.Sampling` and
  `Flow.sample_withhold_taken`, `Flow.sample_withhold_given`). This lemma is what the module adds
  to the two it joins.
* **Blind beyond the coupling closure read at the coarser step.** With those three premises, the
  levels without a part given at the fine steps, and balance at the fine steps on what couples in
  at the coarser: every selection through the couplings read at the coarser steps, of a formation
  within the closure read there, selects the sampled levels with and without a part beyond that
  closure alike (`Flow.sample_unselected_beyond_coupling`). It is
  `Flow.unselected_beyond_coupling` at the sampled flow and web, its premises carried over by the
  lemma above and by `Flow.BalancesOn.sample`. For a part beyond the coupling closure the same
  conclusion already follows from `Web.SelectsThrough.of_sample` with the law at the fine steps
  and its premises, the reading strict. What this law adds is the parts within the coupling
  closure and beyond the closure read at the coarser steps (no fewer parts lie beyond that
  closure than beyond the closure, and in `Missed` one more does), and balance asked on no more
  conditions.
* **The case** `Missed`. A selector requires one condition at step 1 only, is coupled by level to
  a second and gives that second one unit across the second step; a part takes the first
  condition's one unit across the first step and exchanges nothing with the second; the reading
  is at the even steps. The part lies
  within the selector's coupling closure and beyond the closure read at the even steps
  (`Missed.within_fine_beyond_coarse`). A selection through the selector's couplings separates
  the levels with and without the part (`Missed.fine_separates`); no selection through them read
  at the even steps separates the sampled levels (`Missed.coarse_blind`, by the law above),
  though selections through them up to the first step read already tell histories apart
  (`Missed.coarse_reads`), those levels differ at a step read, and a selection at the even steps under coupling by level to every condition separates
  them (`Missed.coarse_differs`).

What this is and is not. The selector's requirement in `Missed` is put at a step the reading
skips; the case shows that this can be, as `Strobe` shows it of activity, and does not show that
any actual reading skips what a selector requires. That a selection is through a selector's
couplings is supplied, as in `Becoming.Selection`. Nothing here is about the lock, the pace of a
rule or a turn in time: a second part on the lock's two-level course read at stretches was
withdrawn before it was built, its statements being `RuleCapture.locked_stays` and `turn_locked`
re-indexed along a stretch that is not read. Not shown: the converse of
`Flow.sample_unselected_beyond_coupling`; a reading that does not start at step 0; scores, and
what a group's or a pool's selections reach at a coarser step. The module is a leaf. No ethical predicate, ranking or axiom
occurs; every declaration has an empty axiom report.
-/

namespace Becoming

variable {F C : Type}

/-- A level history read at the times `σ`. -/
def atTimes (σ : Nat → Nat) (l : Nat → C → Nat) : Nat → C → Nat :=
  fun s => l (σ s)

/-- A strictly increasing sampling keeps the order of its times. -/
theorem Strict.le {σ : Nat → Nat} (strict : Strict σ) {a b : Nat} (le : a ≤ b) : σ a ≤ σ b :=
  match Nat.lt_or_ge a b with
  | .inl lt => Nat.le_of_lt (strict.lt lt)
  | .inr ge => Nat.le_of_eq (congrArg σ (Nat.le_antisymm le ge))

/-- With the reading strict and starting at step 0, every fine step lies in some coarse step. -/
theorem Strict.covers {σ : Nat → Nat} (strict : Strict σ) (zero : σ 0 = 0) :
    ∀ j, ∃ s, σ s ≤ j ∧ j < σ (s + 1)
  | 0 => ⟨0, Nat.le_of_eq zero, Nat.lt_of_le_of_lt (Nat.le_of_eq zero.symm) (strict 0)⟩
  | j + 1 => match Strict.covers strict zero j with
    | ⟨s, le, lt⟩ => match Nat.lt_or_ge (j + 1) (σ (s + 1)) with
      | .inl below => ⟨s, Nat.le_succ_of_le le, below⟩
      | .inr above => ⟨s + 1, above, Nat.lt_of_le_of_lt (Nat.succ_le_of_lt lt) (strict (s + 1))⟩

namespace Web

variable {W : Web F C} {obs : F → C → Prop} {g : F} {l l' : Nat → C → Nat}
  {select : (Nat → C → Nat) → Prop} (σ : Nat → Nat)

/-- Alike through the couplings at a coarse step is alike through them at the fine step read. -/
theorem sample_alikeThrough_iff (s : Nat) :
    (W.sample σ).AlikeThrough obs g (atTimes σ l) (atTimes σ l') s ↔
      W.AlikeThrough obs g l l' (σ s) :=
  Iff.rfl

variable {σ}

/-- Histories alike through the couplings up to a fine step read are alike through them, read at
the coarser steps, up to the coarse step that reads it, where the reading is strict. -/
theorem AlikeThroughUpTo.sample (strict : Strict σ) {t : Nat}
    (alike : W.AlikeThroughUpTo obs g l l' (σ t)) :
    (W.sample σ).AlikeThroughUpTo obs g (atTimes σ l) (atTimes σ l') t :=
  fun s le => alike (σ s) (strict.le le)

/-- **A selection at the coarser step is a selection at the finer.** A selection through `g`'s
couplings on the web read at strictly increasing times `σ`, up to the coarse step `t`, taken back
along the reading, is a selection through `g`'s couplings on the web up to the fine step `σ t`. -/
theorem SelectsThrough.of_sample (strict : Strict σ) {t : Nat}
    (through : (W.sample σ).SelectsThrough obs g t select) :
    W.SelectsThrough obs g (σ t) fun l => select (atTimes σ l) :=
  fun _ _ alike => through _ _ (AlikeThroughUpTo.sample strict alike)

/-- What every selection through `g`'s couplings at the coarser steps selects alike: the histories
alike through them at the steps read. It is `selects_alike_iff` at the sampled web. -/
theorem sample_selects_alike_iff {t : Nat} :
    (∀ select, (W.sample σ).SelectsThrough obs g t select →
        (select (atTimes σ l) ↔ select (atTimes σ l'))) ↔
      ∀ s, s ≤ t → W.AlikeThrough obs g l l' (σ s) :=
  selects_alike_iff

/-- A dependence read at the coarser steps is a dependence. -/
theorem sample_dependsOn {c : C} (depends : (W.sample σ).DependsOn g c) : W.DependsOn g c :=
  match depends with
  | ⟨s, requires⟩ => ⟨σ s, requires⟩

/-- What couples in at the coarser steps couples in. -/
theorem sample_coupledInto {c : C} (coupled : (W.sample σ).CoupledInto obs g c) :
    W.CoupledInto obs g c :=
  coupled.elim (fun depends => .inl (sample_dependsOn depends)) .inr

end Web

namespace Flow

variable [DecidableEq F] {L : Flow F C} {W : Web F C} {obs : F → C → Prop} {part : F → Bool}
  {select : (Nat → C → Nat) → Prop} {σ : Nat → Nat}

/-- An exchange across a coarse step is an exchange at a fine step. -/
theorem sample_exchanges {h : F} {c : C} (exchanges : (L.sample σ).Exchanges h c) :
    L.Exchanges h c :=
  match exchanges with
  | ⟨_, _, .inl positive⟩ => match pos_of_gated positive with
    | ⟨j, _, mem, pos⟩ => ⟨j, mem, .inl pos⟩
  | ⟨_, _, .inr positive⟩ => match pos_of_gated positive with
    | ⟨j, _, mem, pos⟩ => ⟨j, mem, .inr pos⟩

/-- **Exchange is not lost at the coarser step.** With the reading strict and starting at step 0,
an exchange at a fine step is an exchange across the coarse step that holds it. -/
theorem exchanges_sample (strict : Strict σ) (zero : σ 0 = 0) {h : F} {c : C}
    (exchanges : L.Exchanges h c) : (L.sample σ).Exchanges h c :=
  match exchanges with
  | ⟨j, mem, either⟩ => match Strict.covers strict zero j with
    | ⟨s, le, lt⟩ =>
      have inside : j ∈ span σ s := span_mem strict le lt
      ⟨s, (L.unionPresent_spec (span σ s)).2.1 j inside h mem,
        either.elim
          (fun pos => .inl (total_pos_of_mem (q := fun j => gate h (L.present j) (L.take j h c))
            inside (Nat.lt_of_lt_of_le pos (Nat.le_of_eq (gate_mem mem _).symm))))
          (fun pos => .inr (total_pos_of_mem (q := fun j => gate h (L.present j) (L.give j h c))
            inside (Nat.lt_of_lt_of_le pos (Nat.le_of_eq (gate_mem mem _).symm))))⟩

/-- **The coupling closure read at the coarser steps lies within the coupling closure.** -/
theorem sample_withinCoupling {f g : F}
    (within : (L.sample σ).WithinCoupling (W.sample σ) obs f g) : L.WithinCoupling W obs f g :=
  WithinClosure.mono (fun _ _ from_ => match from_ with
    | ⟨c, coupled, exchanges⟩ => ⟨c, Web.sample_coupledInto coupled, sample_exchanges exchanges⟩)
    within

/-- **The closure is smaller at the coarser steps only through a requirement that holds at no
step read.** With the reading strict and starting at step 0, where every dependence is a dependence
at some step read, the coupling closure lies within the coupling closure read at the coarser
steps; with `sample_withinCoupling` the two are then one. -/
theorem withinCoupling_sample (strict : Strict σ) (zero : σ 0 = 0)
    (read : ∀ g c, W.DependsOn g c → (W.sample σ).DependsOn g c) {f g : F}
    (within : L.WithinCoupling W obs f g) :
    (L.sample σ).WithinCoupling (W.sample σ) obs f g :=
  WithinClosure.mono (fun g _ from_ => match from_ with
    | ⟨c, coupled, exchanges⟩ =>
      ⟨c, coupled.elim (fun depends => .inl (read g c depends)) .inr,
        exchanges_sample strict zero exchanges⟩)
    within

/-- Withholding a part changes no list of who takes part. -/
theorem unionPresent_withhold (part : F → Bool) :
    ∀ js : List Nat, (L.withhold part).unionPresent js = L.unionPresent js
  | [] => rfl
  | j :: js => congrArg (adjoin (L.present j)) (unionPresent_withhold part js)

/-- Withheld and then gated over a stretch is gated over the stretch and then withheld. -/
theorem withheld_gated (f : F) (P : Nat → List F) (q : Nat → Nat) (I : List Nat) :
    ∀ b : Bool, (if b then 0 else total I fun j => gate f (P j) (q j)) =
      total I fun j => gate f (P j) (if b then 0 else q j)
  | false => rfl
  | true => ((total_congr_on fun j _ => gateBy_zero (fun _ => rfl) (decideMem f (P j))).trans
      (total_zero I)).symm

/-- What the sampled flow with a part withheld takes is what the flow with the part withheld,
sampled, takes. -/
theorem sample_withhold_taken (part : F → Bool) (σ : Nat → Nat) (s : Nat) (c : C) :
    ((L.sample σ).withhold part).taken s c = ((L.withhold part).sample σ).taken s c :=
  (total_congr_on fun f _ =>
      withheld_gated f L.present (fun j => L.take j f c) (span σ s) (part f)).trans
    (congrArg (fun fs => total fs fun f => total (span σ s) fun j =>
        gate f (L.present j) (if part f then 0 else L.take j f c))
      (unionPresent_withhold part (span σ s)).symm)

/-- The same of what is given. -/
theorem sample_withhold_given (part : F → Bool) (σ : Nat → Nat) (s : Nat) (c : C) :
    ((L.sample σ).withhold part).given s c = ((L.withhold part).sample σ).given s c :=
  (total_congr_on fun f _ =>
      withheld_gated f L.present (fun j => L.give j f c) (span σ s) (part f)).trans
    (congrArg (fun fs => total fs fun f => total (span σ s) fun j =>
        gate f (L.present j) (if part f then 0 else L.give j f c))
      (unionPresent_withhold part (span σ s)).symm)

/-- **The levels without a part, read at the coarser steps, are the levels without it of the
flow read there**, where the reading is strict and starts at step 0 and each relatum is listed once
at every fine step. -/
theorem WithheldLevels.sample {l : Nat → C → Nat} (strict : Strict σ) (zero : σ 0 = 0)
    (once : L.Once) (without : L.WithheldLevels part W l) :
    (L.sample σ).WithheldLevels part (W.sample σ) (atTimes σ l) :=
  ⟨fun s c =>
    have balances := BalancesOn.sample (L := L.withhold part)
      (W := ⟨l, W.active, W.requires, W.need, W.draws⟩) σ (cs := [c]) (s := s) strict
      (fun j _ => once j) (fun j _ c' _ => without.1 j c') c (.head _)
    (congrArg (l (σ (s + 1)) c + ·) (sample_withhold_taken part σ s c)).trans
      (balances.trans (congrArg (l (σ s) c + ·) (sample_withhold_given part σ s c).symm)),
   fun c => (congrArg (fun n => l n c) zero).trans
      ((without.2 c).trans (congrArg (fun n => W.level n c) zero).symm)⟩

/-- **Blind beyond the coupling closure read at the coarser step.** The reading strict and starting
at step 0, each relatum listed once at every fine step, `l` the levels without a part, and the flow
balancing at every fine step on each condition coupled, on the web read at `σ`, into a formation
within `f`'s coupling closure read at `σ`: where every member of the part lies beyond that closure,
every selection through the couplings read at `σ` of a formation within it selects the sampled
levels with and without the part alike. It is `unselected_beyond_coupling` at the sampled flow and
web, with `WithheldLevels.sample` and `BalancesOn.sample` carrying its premises over. -/
theorem sample_unselected_beyond_coupling {l : Nat → C → Nat} (strict : Strict σ)
    (zero : σ 0 = 0) (once : L.Once) (without : L.WithheldLevels part W l) {f : F}
    (balanced : ∀ t g c, (L.sample σ).WithinCoupling (W.sample σ) obs f g →
      (W.sample σ).CoupledInto obs g c → L.BalancesOn W [c] t)
    (beyond : ∀ h, part h = true → ¬ (L.sample σ).WithinCoupling (W.sample σ) obs f h) {g : F}
    (within : (L.sample σ).WithinCoupling (W.sample σ) obs f g) {t : Nat}
    (through : (W.sample σ).SelectsThrough obs g t select) :
    select (atTimes σ W.level) ↔ select (atTimes σ l) :=
  unselected_beyond_coupling (WithheldLevels.sample strict zero once without)
    (fun _ g c within coupled => BalancesOn.sample σ strict (fun j _ => once j)
      fun j _ => balanced j g c within coupled)
    beyond within through

end Flow

/-! ## A part within the closure at the fine steps that no selection through the selector's
couplings at the coarser steps registers -/

namespace Missed

open Strobe

/-- Two conditions. The selector `false` requires the first (`false`) at step 1 only, at a need of
one; one stands on it at the start and nothing after. On the second (`true`) one stands at steps
0 and 1 and two from step 2 on. -/
def web : Web Bool Bool where
  level t c := match c with
    | true => match t with
      | 0 => 1
      | t + 1 => match t with
        | 0 => 1
        | _ + 1 => 2
    | false => match t with
      | 0 => 1
      | _ + 1 => 0
  active _ _ := True
  requires t f c := f = false ∧ c = false ∧ t = 1
  need _ _ _ := 1
  draws _ _ _ := False

/-- The part `true` takes the first condition's one unit across the first step; the selector gives
one unit to the second condition across the second step. -/
def flow : Flow Bool Bool where
  present t := match t with
    | 0 => [true]
    | t + 1 => match t with
      | 0 => [false]
      | _ + 1 => []
  take t f c := match t with
    | 0 => match c with
      | false => bit f
      | true => 0
    | _ + 1 => 0
  give t f c := match t with
    | 0 => 0
    | t + 1 => match t with
      | 0 => match c with
        | true => bit (!f)
        | false => 0
      | _ + 1 => 0

/-- The part. -/
def part : Bool → Bool := id

/-- Without the part one stands on the first condition at every step, and the second stands as
it does with the part. -/
def kept : Nat → Bool → Nat := fun t c => match c with
  | true => web.level t true
  | false => 1

/-- The selector is coupled by level to the second condition. -/
def byLevel (f c : Bool) : Prop := f = false ∧ c = true

/-- Every condition coupled by level. -/
def all : Bool → Bool → Prop := fun _ _ => True

theorem once : flow.Once
  | 0 => ⟨fun no => (nomatch no), trivial⟩
  | t + 1 => match t with
    | 0 => ⟨fun no => (nomatch no), trivial⟩
    | _ + 1 => trivial

theorem without : flow.WithheldLevels part web kept :=
  ⟨fun t c => match t with
    | 0 => match c with
      | true => rfl
      | false => rfl
    | t + 1 => match t with
      | 0 => match c with
        | true => rfl
        | false => rfl
      | _ + 1 => match c with
        | true => rfl
        | false => rfl, fun c => match c with
    | true => rfl
    | false => rfl⟩

theorem balances (t : Nat) (c : Bool) :
    web.level (t + 1) c + flow.taken t c = web.level t c + flow.given t c :=
  match t with
  | 0 => match c with
    | true => rfl
    | false => rfl
  | t + 1 => match t with
    | 0 => match c with
      | true => rfl
      | false => rfl
    | _ + 1 => match c with
      | true => rfl
      | false => rfl

/-- No step read is step 1. -/
theorem twice_ne_one (s : Nat) : twice s ≠ 1 :=
  fun no => Bool.noConfusion
    (show true = false from (congrArg flick no).symm.trans (flick_even s))

/-- Only the selector exchanges with the second condition. -/
theorem second_exchanged {h : Bool} : flow.Exchanges h true → h = false
  | ⟨0, _, .inl positive⟩ => absurd positive (Nat.lt_irrefl 0)
  | ⟨0, _, .inr positive⟩ => absurd positive (Nat.lt_irrefl 0)
  | ⟨1, mem, _⟩ => match (show h ∈ [false] from mem) with
    | .head _ => rfl
  | ⟨_ + 2, mem, _⟩ => nomatch (show h ∈ [] from mem)

/-- Read at the even steps, only the second condition couples into the selector. -/
theorem coarse_coupled {c : Bool} (coupled : (web.sample twice).CoupledInto byLevel false c) :
    c = true :=
  coupled.elim (fun depends => match depends with
    | ⟨s, _, _, one⟩ => absurd one (twice_ne_one s)) fun level => level.2

/-- **The part lies within the selector's coupling closure at the fine steps and beyond it at the
coarser.** -/
theorem within_fine_beyond_coarse :
    flow.WithinCoupling web byLevel false true ∧
      ¬ (flow.sample twice).WithinCoupling (web.sample twice) byLevel false true :=
  ⟨WithinClosure.of_rel ⟨false, .inl ⟨1, rfl, rfl, rfl⟩, 0, .head _, .inl (Nat.succ_pos 0)⟩,
   not_within_of_closed (region := fun f => f = false)
     (fun x _ holds from_ => match x, holds, from_ with
       | _, rfl, ⟨c, coupled, exchanges⟩ => match c, coarse_coupled coupled, exchanges with
         | _, rfl, exchanges => second_exchanged (Flow.sample_exchanges exchanges))
     rfl (fun no => nomatch no)⟩

/-- **A selection through the selector's couplings at the fine steps separates the levels with and
without the part.** -/
theorem fine_separates :
    ∃ select, web.SelectsThrough byLevel false (twice 1) select ∧
      select web.level ∧ ¬ select kept :=
  Web.separates fun alike =>
    absurd (((alike 1 (Nat.le_succ 1)).1).mpr (fun c requires => match c, requires.2.1 with
        | _, rfl => Nat.le_refl 1) false ⟨rfl, rfl, rfl⟩)
      (by decide)

/-- **No selection through them at the coarser steps does**, by the blindness law at the coarser
step. -/
theorem coarse_blind (t : Nat) (select : (Nat → Bool → Nat) → Prop)
    (through : (web.sample twice).SelectsThrough byLevel false t select) :
    select (atTimes twice web.level) ↔ select (atTimes twice kept) :=
  Flow.sample_unselected_beyond_coupling twice_strict rfl once without
    (fun t _ _ _ _ => fun c _ => balances t c)
    (fun h isPart => match h, isPart with
      | true, _ => within_fine_beyond_coarse.2)
    (WithinClosure.refl false) through

/-- **The selections it is blind with are not constant**: a selection through the selector's
couplings at the coarser steps separates two histories that differ on the second condition. -/
theorem coarse_reads :
    ∃ select, (web.sample twice).SelectsThrough byLevel false 0 select ∧
      select (fun _ _ => 0) ∧ ¬ select (fun _ _ => 1) :=
  Web.separates fun alike => absurd ((alike 0 (Nat.le_refl 0)).2 true ⟨rfl, rfl⟩) (by decide)

/-- **The sampled levels differ, and a selection at the coarser steps under coupling by level to
every condition separates them.** -/
theorem coarse_differs :
    atTimes twice web.level 1 false ≠ atTimes twice kept 1 false ∧
      ∃ select, (web.sample twice).SelectsThrough all false 1 select ∧
        select (atTimes twice web.level) ∧ ¬ select (atTimes twice kept) :=
  ⟨by decide,
   Web.separates fun alike => absurd ((alike 1 (Nat.le_refl 1)).2 false trivial) (by decide)⟩

end Missed

end Becoming
