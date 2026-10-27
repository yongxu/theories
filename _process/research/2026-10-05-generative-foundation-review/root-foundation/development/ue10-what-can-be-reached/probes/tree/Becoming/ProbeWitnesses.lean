import Becoming.ProbeLaws

/-!
# UE10 review probes, part 2: witnesses, duplicates and a calibration

Probes of the draft `Becoming.ReachableRanges` (review REVIEW-UE10.md). Each probe names the finding
it supports. Nothing here is proposed for landing as written.
-/

namespace Becoming

namespace ProbeUE10

open Generative

universe u v

/-! ## W1. Covering is linear-time: when an alternative closes is not seen -/

namespace Timing

/-- `late` steps to `mid`, which chooses `a` or `b`; `early` chooses at once, through `ma` or `mb`. -/
inductive Config
  | late
  | mid
  | early
  | ma
  | mb
  | a
  | b

def process : Process Config Unit := ⟨fun s _ c => match s with
  | .late => c = .mid
  | .mid => c = .a ∨ c = .b
  | .early => c = .ma ∨ c = .mb
  | .ma => c = .a
  | .mb => c = .b
  | .a => c = .a
  | .b => c = .b⟩

/-- `a` admits `1`, `b` admits `2`, every other configuration admits `0`. -/
def adm : Config → Nat → Prop
  | .late, x => x = 0
  | .mid, x => x = 0
  | .early, x => x = 0
  | .ma, x => x = 0
  | .mb, x => x = 0
  | .a, x => x = 1
  | .b, x => x = 2

def lateA : Run process :=
  ⟨fun | 0 => .late | 1 => .mid | _ + 2 => .a, fun _ => (), fun | 0 => rfl | 1 => .inl rfl | _ + 2 => rfl⟩
def lateB : Run process :=
  ⟨fun | 0 => .late | 1 => .mid | _ + 2 => .b, fun _ => (), fun | 0 => rfl | 1 => .inr rfl | _ + 2 => rfl⟩
def earlyA : Run process :=
  ⟨fun | 0 => .early | 1 => .ma | _ + 2 => .a, fun _ => (), fun | 0 => .inl rfl | 1 => rfl | _ + 2 => rfl⟩
def earlyB : Run process :=
  ⟨fun | 0 => .early | 1 => .mb | _ + 2 => .b, fun _ => (), fun | 0 => .inr rfl | 1 => rfl | _ + 2 => rfl⟩

theorem stepped {r : Run process} {t : Nat} {c : Config} (at_t : r.state t = c) :
    process.step c (r.act t) (r.state (t + 1)) :=
  Eq.mp (congrArg (fun y => process.step y (r.act t) (r.state (t + 1))) at_t) (r.step t)

/-- A course at `a` from step two stays there; so at `b`. -/
theorem at_a {r : Run process} (two : r.state 2 = .a) : ∀ d, r.state (d + 2) = .a
  | 0 => two
  | d + 1 => (stepped (at_a two d) : r.state (d + 2 + 1) = .a)

theorem at_b {r : Run process} (two : r.state 2 = .b) : ∀ d, r.state (d + 2) = .b
  | 0 => two
  | d + 1 => (stepped (at_b two d) : r.state (d + 2 + 1) = .b)

/-- After two steps, a course from `early` is at `a` for good or at `b` for good. -/
theorem from_early (r : Run process) (start : r.state 0 = .early) :
    (r.state 1 = .ma ∧ ∀ d, r.state (d + 2) = .a) ∨ (r.state 1 = .mb ∧ ∀ d, r.state (d + 2) = .b) :=
  match (stepped start : r.state 1 = .ma ∨ r.state 1 = .mb) with
  | .inl ma => .inl ⟨ma, at_a (stepped ma : r.state 2 = .a)⟩
  | .inr mb => .inr ⟨mb, at_b (stepped mb : r.state 2 = .b)⟩

theorem from_late (r : Run process) (start : r.state 0 = .late) :
    r.state 1 = .mid ∧ ((∀ d, r.state (d + 2) = .a) ∨ ∀ d, r.state (d + 2) = .b) :=
  have mid : r.state 1 = .mid := stepped start
  ⟨mid, match (stepped mid : r.state 2 = .a ∨ r.state 2 = .b) with
    | .inl a => .inl (at_a a)
    | .inr b => .inr (at_b b)⟩

/-- A course including another offset by offset, given at the first two offsets and after. -/
theorem includes_of {r q : Run process} (zero : ∀ x, adm (r.state 0) x → adm (q.state 0) x)
    (one : ∀ x, adm (r.state 1) x → adm (q.state 1) x)
    (rest : ∀ d x, adm (r.state (d + 2)) x → adm (q.state (d + 2)) x) : q.RangeIncludes adm r :=
  fun t x admitted => match t with
  | 0 => zero x admitted
  | 1 => one x admitted
  | d + 2 => rest d x admitted

/-- Moving what a configuration admits along an equation. -/
theorem moved {r : Run process} {n : Nat} {c : Config} (at_n : r.state n = c) {x : Nat}
    (admitted : adm (r.state n) x) : adm c x :=
  Eq.subst (motive := fun y => adm y x) at_n admitted

/-- **Probe W1.** `late` and `early` cover each other, so neither widens what can be reached over the
other; yet after one step every course from `late` can still reach both `a` and `b`, and no course
from `early` can. -/
theorem timing_unseen :
    Reaching.Covers process adm .late .early ∧ Reaching.Covers process adm .early .late ∧
      ¬ Reaching.Widens process adm .late .early ∧ ¬ Reaching.Widens process adm .early .late ∧
      (∀ r : Run process, r.state 0 = .late → Reach process (r.state 1) .a ∧ Reach process (r.state 1) .b) ∧
      (∀ r : Run process, r.state 0 = .early →
        ¬ (Reach process (r.state 1) .a ∧ Reach process (r.state 1) .b)) :=
  have lateCovers : Reaching.Covers process adm .late .early := fun r' start' =>
    match from_early r' start' with
    | .inl ⟨ma, rest⟩ => ⟨lateA, rfl, includes_of
        (fun _ h => (moved start' h : adm .early _)) (fun _ h => (moved ma h : adm .ma _))
        (fun d _ h => match d with
          | 0 => (moved (rest 0) h : adm .a _)
          | _ + 1 => (moved (rest _) h : adm .a _))⟩
    | .inr ⟨mb, rest⟩ => ⟨lateB, rfl, includes_of
        (fun _ h => (moved start' h : adm .early _)) (fun _ h => (moved mb h : adm .mb _))
        (fun d _ h => match d with
          | 0 => (moved (rest 0) h : adm .b _)
          | _ + 1 => (moved (rest _) h : adm .b _))⟩
  have earlyCovers : Reaching.Covers process adm .early .late := fun r' start' =>
    match from_late r' start' with
    | ⟨mid, .inl rest⟩ => ⟨earlyA, rfl, includes_of
        (fun _ h => (moved start' h : adm .late _)) (fun _ h => (moved mid h : adm .mid _))
        (fun d _ h => match d with
          | 0 => (moved (rest 0) h : adm .a _)
          | _ + 1 => (moved (rest _) h : adm .a _))⟩
    | ⟨mid, .inr rest⟩ => ⟨earlyB, rfl, includes_of
        (fun _ h => (moved start' h : adm .late _)) (fun _ h => (moved mid h : adm .mid _))
        (fun d _ h => match d with
          | 0 => (moved (rest 0) h : adm .b _)
          | _ + 1 => (moved (rest _) h : adm .b _))⟩
  ⟨lateCovers, earlyCovers,
   fun widens => widens_not_covered widens earlyCovers,
   fun widens => widens_not_covered widens lateCovers,
   fun r start => match from_late r start with
    | ⟨mid, _⟩ => Eq.mpr (congrArg (fun c => Reach process c .a ∧ Reach process c .b) mid)
        ⟨Reach.of_step (a := ()) (.inl rfl), Reach.of_step (a := ()) (.inr rfl)⟩,
   fun r start ⟨toA, toB⟩ => match from_early r start with
    | .inl ⟨ma, _⟩ =>
      have closed : ∀ c, Reach process .ma c → c = .ma ∨ c = .a := fun _ reach =>
        Invariant.reach (P := process) (I := fun y => y = .ma ∨ y = .a)
          (fun s _ _ step held => match s, held, step with
            | .ma, _, step => .inr step
            | .a, _, step => .inr step
            | .late, .inl e, _ => Config.noConfusion e
            | .late, .inr e, _ => Config.noConfusion e
            | .mid, .inl e, _ => Config.noConfusion e
            | .mid, .inr e, _ => Config.noConfusion e
            | .early, .inl e, _ => Config.noConfusion e
            | .early, .inr e, _ => Config.noConfusion e
            | .mb, .inl e, _ => Config.noConfusion e
            | .mb, .inr e, _ => Config.noConfusion e
            | .b, .inl e, _ => Config.noConfusion e
            | .b, .inr e, _ => Config.noConfusion e) reach (.inl rfl)
      match closed .b (Eq.mp (congrArg (fun c => Reach process c .b) ma) toB) with
      | .inl e => Config.noConfusion e
      | .inr e => Config.noConfusion e
    | .inr ⟨mb, _⟩ =>
      have closed : ∀ c, Reach process .mb c → c = .mb ∨ c = .b := fun _ reach =>
        Invariant.reach (P := process) (I := fun y => y = .mb ∨ y = .b)
          (fun s _ _ step held => match s, held, step with
            | .mb, _, step => .inr step
            | .b, _, step => .inr step
            | .late, .inl e, _ => Config.noConfusion e
            | .late, .inr e, _ => Config.noConfusion e
            | .mid, .inl e, _ => Config.noConfusion e
            | .mid, .inr e, _ => Config.noConfusion e
            | .early, .inl e, _ => Config.noConfusion e
            | .early, .inr e, _ => Config.noConfusion e
            | .ma, .inl e, _ => Config.noConfusion e
            | .ma, .inr e, _ => Config.noConfusion e
            | .a, .inl e, _ => Config.noConfusion e
            | .a, .inr e, _ => Config.noConfusion e) reach (.inl rfl)
      match closed .a (Eq.mp (congrArg (fun c => Reach process c .a) mb) toA) with
      | .inl e => Config.noConfusion e
      | .inr e => Config.noConfusion e⟩


/-- A simulation: related configurations admit alike or more on the right, and every step on the left
is matched on the right into related configurations. -/
def Simulation (R : Config → Config → Prop) : Prop :=
  ∀ s s', R s s' → (∀ x, adm s x → adm s' x) ∧ ∀ t, process.step s () t → ∃ t', process.step s' () t' ∧ R t t'

/-- **Probe W1, branching time.** No simulation relates `late` to `early`: `early` cannot match
`late`'s later choice, though the two cover each other. -/
theorem early_not_simulating_late {R : Config → Config → Prop} (simulation : Simulation R)
    (related : R .late .early) : False :=
  match (simulation _ _ related).2 .mid rfl with
  | ⟨.ma, _, toMa⟩ => match (simulation _ _ toMa).2 .b (.inr rfl) with
    | ⟨.a, _, toA⟩ => Nat.not_succ_le_self 1 (Nat.le_of_eq ((simulation _ _ toA).1 2 rfl : (2 : Nat) = 1))
    | ⟨.late, e, _⟩ => Config.noConfusion e
    | ⟨.mid, e, _⟩ => Config.noConfusion e
    | ⟨.early, e, _⟩ => Config.noConfusion e
    | ⟨.ma, e, _⟩ => Config.noConfusion e
    | ⟨.mb, e, _⟩ => Config.noConfusion e
    | ⟨.b, e, _⟩ => Config.noConfusion e
  | ⟨.mb, _, toMb⟩ => match (simulation _ _ toMb).2 .a (.inl rfl) with
    | ⟨.b, _, toB⟩ => Nat.not_succ_le_self 1 (Nat.le_of_eq ((simulation _ _ toB).1 1 rfl : (1 : Nat) = 2).symm)
    | ⟨.late, e, _⟩ => Config.noConfusion e
    | ⟨.mid, e, _⟩ => Config.noConfusion e
    | ⟨.early, e, _⟩ => Config.noConfusion e
    | ⟨.ma, e, _⟩ => Config.noConfusion e
    | ⟨.mb, e, _⟩ => Config.noConfusion e
    | ⟨.a, e, _⟩ => Config.noConfusion e
  | ⟨.late, step, _⟩ => match step with | .inl e => Config.noConfusion e | .inr e => Config.noConfusion e
  | ⟨.mid, step, _⟩ => match step with | .inl e => Config.noConfusion e | .inr e => Config.noConfusion e
  | ⟨.early, step, _⟩ => match step with | .inl e => Config.noConfusion e | .inr e => Config.noConfusion e
  | ⟨.a, step, _⟩ => match step with | .inl e => Config.noConfusion e | .inr e => Config.noConfusion e
  | ⟨.b, step, _⟩ => match step with | .inl e => Config.noConfusion e | .inr e => Config.noConfusion e

/-- The simulation relating `early` to `late`. -/
def lateOverEarly : Config → Config → Prop
  | .late, _ => False
  | .mid, _ => False
  | .early, c => c = .late
  | .ma, c => c = .mid
  | .mb, c => c = .mid
  | .a, c => c = .a
  | .b, c => c = .b

/-- **Probe W1, branching time.** `late` simulates `early`. -/
theorem late_simulates_early : Simulation lateOverEarly ∧ lateOverEarly .early .late :=
  ⟨fun s s' related => match s, s', related with
    | .early, _, rfl => ⟨fun _ h => h, fun t step => ⟨.mid, rfl, match t, step with
        | .ma, _ => rfl
        | .mb, _ => rfl
        | .late, .inl e => Config.noConfusion e
        | .late, .inr e => Config.noConfusion e
        | .mid, .inl e => Config.noConfusion e
        | .mid, .inr e => Config.noConfusion e
        | .early, .inl e => Config.noConfusion e
        | .early, .inr e => Config.noConfusion e
        | .a, .inl e => Config.noConfusion e
        | .a, .inr e => Config.noConfusion e
        | .b, .inl e => Config.noConfusion e
        | .b, .inr e => Config.noConfusion e⟩⟩
    | .ma, _, rfl => ⟨fun _ h => h, fun _ step => ⟨.a, .inl rfl,
        Eq.subst (motive := fun c => lateOverEarly c .a) step.symm rfl⟩⟩
    | .mb, _, rfl => ⟨fun _ h => h, fun _ step => ⟨.b, .inr rfl,
        Eq.subst (motive := fun c => lateOverEarly c .b) step.symm rfl⟩⟩
    | .a, _, rfl => ⟨fun _ h => h, fun _ step => ⟨.a, rfl,
        Eq.subst (motive := fun c => lateOverEarly c .a) step.symm rfl⟩⟩
    | .b, _, rfl => ⟨fun _ h => h, fun _ step => ⟨.b, rfl,
        Eq.subst (motive := fun c => lateOverEarly c .b) step.symm rfl⟩⟩,
   rfl⟩

end Timing

/-! ## W2. Silent where 07's question is posed -/

namespace Silent

def next : Option Nat → Option Nat
  | none => none
  | some n => some (n + 1)

/-- `none` stays; `some n` climbs. -/
def process : Process (Option Nat) Unit := Law.process next

/-- `none` admits `0` and `1` at every step; `some n` admits the formations up to `n`. -/
def adm : Option Nat → Nat → Prop
  | none, x => x ≤ 1
  | some n, x => x ≤ n

def course : Option Nat → Run process
  | none => ⟨fun _ => none, fun _ => (), fun _ => rfl⟩
  | some n => ⟨fun t => some (n + t), fun _ => (), fun _ => rfl⟩

/-- **Probe W2.** The climb from `some 0` widens its own range at every step; `none` is wider at the
start and the two are mixed. Neither widens what can be reached over the other, and the lexical
order ranks neither above the other. -/
theorem silent :
    (∀ t, (∀ x, adm ((course (some 0)).state t) x → adm ((course (some 0)).state (t + 1)) x) ∧
        ∃ x, adm ((course (some 0)).state (t + 1)) x ∧ ¬ adm ((course (some 0)).state t) x) ∧
      (course none).RangeExceeds adm (course (some 0)) ∧ (course (some 0)).RangeExceeds adm (course none) ∧
      ¬ Reaching.Widens process adm (some 0) none ∧ ¬ Reaching.Widens process adm none (some 0) ∧
      ¬ Reaching.Lexical process adm course (some 0) none ∧
      ¬ Reaching.Lexical process adm course none (some 0) :=
  have notUp : ¬ (course (some 0)).RangeIncludes adm (course none) := fun includes =>
    Nat.not_succ_le_self 0 (includes 0 1 (Nat.le_refl 1))
  have notDown : ¬ (course none).RangeIncludes adm (course (some 0)) := fun includes =>
    Nat.not_succ_le_self 1 (includes 2 2 (Nat.le_refl 2))
  ⟨fun t => ⟨fun _ le => Nat.le_trans le (Nat.le_succ (0 + t)),
     0 + t + 1, Nat.le_refl _, Nat.not_succ_le_self (0 + t)⟩,
   ⟨0, 1, Nat.le_refl 1, Nat.not_succ_le_self 0⟩,
   ⟨2, 2, Nat.le_refl 2, Nat.not_succ_le_self 1⟩,
   fun widens => match widens.1 (course none) rfl with
    | ⟨_, start, includes⟩ => Nat.not_succ_le_self 0
        (Eq.subst (motive := fun c => adm c 1) start (includes 0 1 (Nat.le_refl 1))),
   fun widens => match widens.1 (course (some 0)) rfl with
    | ⟨r, start, includes⟩ => Nat.not_succ_le_self 1
        (Eq.subst (motive := fun c => adm c 2) (law_unique r (course none) start 2)
          (includes 2 2 (Nat.le_refl 2))),
   fun | .inl widens => notUp widens.1 | .inr ⟨includes, _, _⟩ => notUp includes,
   fun | .inl widens => notDown widens.1 | .inr ⟨includes, _, _⟩ => notDown includes⟩

/-- **Probe W2, with a lag.** Covering with a lag (probe B10's `CoversLater`) decides the pair for
the climb: the climb covers `none` one step later, and `none` covers the climb at no lag. -/
theorem lag_decides :
    CoversLater process adm 1 (some 0) none ∧ ¬ ∃ d, CoversLater process adm d none (some 0) :=
  ⟨fun r' start' => ⟨course (some 0), rfl, fun t x admitted =>
      Nat.le_trans (Eq.subst (motive := fun c => adm c x) (law_unique r' (course none) start' t) admitted)
        (Nat.succ_le_succ (Nat.zero_le (0 + t)))⟩,
   fun ⟨d, covers⟩ => match covers (course (some 0)) rfl with
    | ⟨r, start, includes⟩ => Nat.not_succ_le_self 1
        (Eq.subst (motive := fun c => adm c 2) (law_unique r (course none) start (2 + d))
          (includes 2 2 (Nat.le_refl 2)))⟩

end Silent

/-! ## W3. The design's form of law 1 is Markov's principle -/

namespace Calibration

/-- DESIGN.md §3, law 1: where any two courses from one configuration agree, widening what can be
reached gives exceeding of the two courses (the forward half of its iff). -/
def DesignForm : Prop :=
  ∀ (S A X : Type) (P : Process S A) (adm : S → X → Prop),
    (∀ q q' : Run P, q.state 0 = q'.state 0 → ∀ t, q.state t = q'.state t) →
      ∀ r r' : Run P, Reaching.Widens P adm (r.state 0) (r'.state 0) → r.RangeExceeds adm r'

def next (x : Bool × Nat) : Bool × Nat := (x.1, x.2 + 1)

def top : Run (Law.process next) := ⟨fun t => (true, t), fun _ => (), fun _ => rfl⟩
def low : Run (Law.process next) := ⟨fun t => (false, t), fun _ => (), fun _ => rfl⟩

/-- Side `true` admits the one formation at every step; side `false` where the sequence is `false`. -/
def adm (s : Nat → Bool) (x : Bool × Nat) (_ : Unit) : Prop := x.1 = true ∨ s x.2 = false

theorem true_of_ne : ∀ {b : Bool}, ¬ b = false → b = true
  | true, _ => rfl
  | false, no => absurd rfl no

/-- **Probe W3.** The design's form gives Markov's principle: the module's form, with the negation
of inclusion in place of exceeding, is the constructive statement. -/
theorem markov_of_designForm (design : DesignForm) : Markov :=
  fun s notAll =>
    have widens : Reaching.Widens (Law.process next) (adm s) (top.state 0) (low.state 0) :=
      ⟨fun _ _ => ⟨top, rfl, fun _ _ _ => .inl rfl⟩, top, rfl, fun r' start' includes =>
        notAll fun n => match includes n () (.inl rfl) with
          | .inl e => Bool.noConfusion
              ((congrArg Prod.fst (law_unique r' low start' n)).symm.trans e)
          | .inr e => Eq.subst (motive := fun x : Bool × Nat => s x.2 = false)
              (law_unique r' low start' n) e⟩
    match design _ _ _ (Law.process next) (adm s) law_unique top low widens with
    | ⟨t, _, _, no⟩ => ⟨t, true_of_ne fun e => no (.inr e)⟩

end Calibration

/-! ## W4. The possible within a horizon is `WithinMoves` of one formation -/

section Duplicates

variable {S : Type u} {A : Type v} {X : Type} {P : Process S A} {adm : S → X → Prop}

/-- **Probe W4.** `Reaching.PossibleWithin` is `WithinMoves` (`Becoming.Labelled`) of the bundle
holding one formation. -/
theorem possibleWithin_iff_withinMoves {k : Nat} {s : S} {x : X} :
    Reaching.PossibleWithin P adm k s x ↔ WithinMoves P adm s k (fun c => c = x) :=
  ⟨fun ⟨t, as, length, trace, admitted⟩ =>
     ⟨as, t, trace, length, fun _ same => Eq.subst (motive := fun y => adm t y) same.symm admitted⟩,
   fun ⟨as, t, trace, length, holds⟩ => ⟨t, as, length, trace, holds x rfl⟩⟩

/-- **Probe W4.** `Run.possibleWithin_moves` is `WithinMoves.before` at a step of the run. -/
theorem possibleWithin_moves' (r : Run P) (n : Nat) {k : Nat} {x : X}
    (within : Reaching.PossibleWithin P adm k (r.state (n + 1)) x) :
    Reaching.PossibleWithin P adm (k + 1) (r.state n) x :=
  possibleWithin_iff_withinMoves.mpr (WithinMoves.before (r.step n) (possibleWithin_iff_withinMoves.mp within))

/-- **Probe W4.** The whole possible is realizability of one formation within some bound
(`withinMoves_iff_reach`). -/
theorem possible_iff_withinMoves {s : S} {x : X} :
    Reaching.Possible P adm s x ↔ ∃ n, WithinMoves P adm s n (fun c => c = x) :=
  ⟨fun ⟨t, reach, admitted⟩ => withinMoves_iff_reach.mpr
     ⟨t, reach, fun _ same => Eq.subst (motive := fun y => adm t y) same.symm admitted⟩,
   fun within => match withinMoves_iff_reach.mp within with
    | ⟨t, reach, holds⟩ => ⟨t, reach, holds x rfl⟩⟩

/-- **Probe W4.** `Reaching.Possible.of_reach` is `together_after_reach` of one formation. -/
theorem possible_of_reach' {s s' : S} (reach : Reach P s s') {x : X}
    (possible : Reaching.Possible P adm s' x) : Reaching.Possible P adm s x :=
  possible_iff_withinMoves.mpr (together_after_reach reach (possible_iff_withinMoves.mp possible))

/-- **Probe W4.** A step losing a possibility is not undone (as `lost_together_not_returns`). -/
theorem narrowing_not_returns (r : Run P) (n : Nat) {x : X}
    (before : Reaching.Possible P adm (r.state n) x)
    (after : ¬ Reaching.Possible P adm (r.state (n + 1)) x) :
    ¬ Reach P (r.state (n + 1)) (r.state n) :=
  fun back => after (Reaching.Possible.of_reach back before)

end Duplicates

/-- **Probe W4, on `Joint`.** `both` and `split` realize the same bundles together within every
bound: the stronger form of `Joint.same_possibleWithin`, with whole bundles at one configuration. -/
theorem joint_same_bundles (n : Nat) (bundle : Nat → Prop) :
    WithinMoves Joint.process Joint.adm .both n bundle ↔
      WithinMoves Joint.process Joint.adm .split n bundle :=
  ⟨fun ⟨_, _, _, _, holds⟩ => ⟨[], .split, .nil _, Nat.zero_le n, fun c held => Joint.adm_le (holds c held)⟩,
   fun ⟨_, _, _, _, holds⟩ => ⟨[], .both, .nil _, Nat.zero_le n, fun c held => Joint.adm_le (holds c held)⟩⟩

/-! ## W5. The lexical order on courses, with no course chosen for every configuration -/

section LexicalRuns

variable {S : Type u} {A : Type v} {X : Type} {P : Process S A} {adm : S → X → Prop}

/-- Range widening of two courses, or the same range and widening what can be reached from their
starts. -/
def LexicalRuns (P : Process S A) (adm : S → X → Prop) (r r' : Run P) : Prop :=
  r.RangeWidens adm r' ∨
    (r.RangeIncludes adm r' ∧ r'.RangeIncludes adm r ∧ Reaching.Widens P adm (r.state 0) (r'.state 0))

theorem LexicalRuns.irrefl (r : Run P) : ¬ LexicalRuns P adm r r
  | .inl widens => Run.RangeWidens.irrefl r widens
  | .inr ⟨_, _, widens⟩ => Reaching.Widens.irrefl _ widens

theorem LexicalRuns.trans {r r' r'' : Run P} :
    LexicalRuns P adm r r' → LexicalRuns P adm r' r'' → LexicalRuns P adm r r''
  | .inl widens, .inl widens' => .inl (widens.trans widens')
  | .inl ⟨includes, t, x, yes, no⟩, .inr ⟨includes', _, _⟩ =>
    .inl ⟨includes.trans includes', t, x, yes, fun admitted => no (includes' t x admitted)⟩
  | .inr ⟨includes, _, _⟩, .inl ⟨includes', t, x, yes, no⟩ =>
    .inl ⟨includes.trans includes', t, x, includes t x yes, no⟩
  | .inr ⟨includes, back, widens⟩, .inr ⟨includes', back', widens'⟩ =>
    .inr ⟨includes.trans includes', back'.trans back, widens.trans widens'⟩

theorem widens_congr {s₁ s₂ s₁' s₂' : S} (e : s₁ = s₂) (e' : s₁' = s₂')
    (widens : Reaching.Widens P adm s₁ s₁') : Reaching.Widens P adm s₂ s₂' :=
  Eq.subst (motive := fun y => Reaching.Widens P adm s₂ y) e'
    (Eq.subst (motive := fun y => Reaching.Widens P adm y s₁') e widens)

/-- **Probe W5.** Where each chosen course starts at its configuration, the module's lexical order is
the order on the chosen courses. -/
theorem lexical_iff_runs {course : S → Run P} {s s' : S} (start : (course s).state 0 = s)
    (start' : (course s').state 0 = s') :
    Reaching.Lexical P adm course s s' ↔ LexicalRuns P adm (course s) (course s') :=
  ⟨fun | .inl widens => .inl widens
       | .inr ⟨includes, back, widens⟩ => .inr ⟨includes, back, widens_congr start.symm start'.symm widens⟩,
   fun | .inl widens => .inl widens
       | .inr ⟨includes, back, widens⟩ => .inr ⟨includes, back, widens_congr start start' widens⟩⟩

end LexicalRuns

/-! ## W6. On `Rise` the whole possible is unchanged across the rising step -/

/-- **Probe W6.** On `Rise` every configuration starts a course, so by probe B1 the whole possible
is the same from both configurations of the rising step: nothing narrows there. -/
theorem rise_possible_unchanged (x : Nat) :
    Reaching.Possible Rise.process Rise.adm (Rise.course.state 1) x ↔
      Reaching.Possible Rise.process Rise.adm (Rise.course.state 0) x :=
  possible_unchanged_of_covers_next Rise.course 0 Rise.rises.1.1
    (fun t _ => match t with
      | true => ⟨Rise.stay, rfl⟩
      | false => ⟨Rise.course, rfl⟩) x

/-- **Probe W6.** On `Rise` the possible within every horizon beyond the present is the same from
both configurations of the rising step: only what each admits now rises. -/
theorem rise_within_same (k x : Nat) :
    Reaching.PossibleWithin Rise.process Rise.adm (k + 1) (Rise.course.state 0) x ↔
      Reaching.PossibleWithin Rise.process Rise.adm (k + 1) (Rise.course.state 1) x :=
  ⟨fun ⟨_, _, _, _, admitted⟩ =>
     Reaching.PossibleWithin.present (Rise.adm_le admitted : Rise.adm true x),
   fun ⟨_, _, _, _, admitted⟩ =>
     ⟨true, [()], Nat.succ_le_succ (Nat.zero_le k), .cons rfl (.nil true),
      (Rise.adm_le admitted : Rise.adm true x)⟩⟩

end ProbeUE10

end Becoming
