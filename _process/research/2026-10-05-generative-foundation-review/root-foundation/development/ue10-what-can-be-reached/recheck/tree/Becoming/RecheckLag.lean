import Becoming.ReachableRanges

/-!
# UE10 re-check probes, part 1: the lagged order

Probes of the revised `Becoming.ReachableRanges` (re-check RECHECK-UE10.md). Not proposed for
landing as written.

* R1–R4: along a course, the lag part of `Reaching.WidensOrLater` (covering with some lag, covered
  back with none) never ranks a successor above its predecessor, so the lagged order ranks a
  successor above its predecessor exactly where same-offset widening does; `Rise` is UE9's
  `Delayed.widens_not_withLag` read on courses.
* R5: the lagged order never ranks a configuration above one covering it.
* R6: containing the strict part of covering on every process gives Markov's principle.
* R7, R8: on determined witnesses where a climb keeps widening and another configuration admits
  now what the climb does not, the lagged order can be silent both ways, and same-offset widening
  can rank the other above the climb.
* R9: the lagged order and its laws hold at `S : Type u`, proved directly.
* R10: C on the frame of reachable ranges does not decide `WiderNow`'s pair.
-/

namespace Becoming

namespace RecheckUE10

open Generative

universe u v

/-! ## R1–R5. The lag along a course -/

section Along

variable {S : Type u} {A : Type v} {X : Type} {P : Process S A} {adm : S → X → Prop}

/-- The lag part of the lagged order: covering with some lag and covered back with none. -/
def LagPart (P : Process S A) (adm : S → X → Prop) (s s' : S) : Prop :=
  (∃ d, Reaching.CoversLater P adm d s s') ∧ ¬ ∃ d, Reaching.CoversLater P adm d s' s

/-- **R2.** The lag part never ranks a configuration of a course above its predecessor: the
predecessor covers it with lag one (`Run.coversLater_next`). -/
theorem lagPart_not_next (r : Run P) (n : Nat) :
    ¬ LagPart P adm (r.state (n + 1)) (r.state n) :=
  fun ⟨_, notBack⟩ => notBack ⟨1, r.coversLater_next n⟩

/-- **R2b.** Where the successor covers its predecessor, the lag part ranks neither above the
other. -/
theorem lagPart_neither_of_covers (r : Run P) (n : Nat)
    (covers : Reaching.Covers P adm (r.state (n + 1)) (r.state n)) :
    ¬ LagPart P adm (r.state (n + 1)) (r.state n) ∧ ¬ LagPart P adm (r.state n) (r.state (n + 1)) :=
  ⟨lagPart_not_next r n, fun ⟨_, notBack⟩ => notBack ⟨0, Reaching.CoversLater.zero.mpr covers⟩⟩

end Along

section AlongType

variable {S : Type} {A : Type v} {X : Type} {P : Process S A} {adm : S → X → Prop}

/-- **R3.** Along a course the lagged order ranks a successor above its predecessor exactly where
same-offset widening does: the lag adds nothing there. -/
theorem widensOrLater_next_iff (r : Run P) (n : Nat) :
    Reaching.WidensOrLater P adm (r.state (n + 1)) (r.state n) ↔
      Reaching.Widens P adm (r.state (n + 1)) (r.state n) :=
  ⟨fun | .inl widens => widens
       | .inr lag => (lagPart_not_next r n lag).elim,
   .inl⟩

/-- **R5.** The lagged order never ranks a configuration above one covering it. -/
theorem widensOrLater_not_covered {s s' : S} (above : Reaching.WidensOrLater P adm s s') :
    ¬ Reaching.Covers P adm s' s :=
  match above with
  | .inl widens => Reaching.widens_not_covered widens
  | .inr ⟨_, notBack⟩ => fun covers => notBack ⟨0, Reaching.CoversLater.zero.mpr covers⟩

end AlongType

/-- **R1.** The lagged order ranks `Rise`'s rising step, the later configuration above the earlier,
and not conversely. -/
theorem rise_ranked :
    Reaching.WidensOrLater Rise.process Rise.adm (Rise.course.state 1) (Rise.course.state 0) ∧
      ¬ Reaching.WidensOrLater Rise.process Rise.adm (Rise.course.state 0) (Rise.course.state 1) :=
  ⟨.inl Rise.rises, Reaching.WidensOrLater.not_reversed Rise.rises⟩

/-- **R4.** UE9's `Delayed.widens_not_withLag` read on courses: the rising step widens what can be
reached and the lag part does not rank it. -/
theorem rise_widens_not_lagPart :
    Reaching.Widens Rise.process Rise.adm (Rise.course.state 1) (Rise.course.state 0) ∧
      ¬ LagPart Rise.process Rise.adm (Rise.course.state 1) (Rise.course.state 0) :=
  ⟨Rise.rises, lagPart_not_next Rise.course 0⟩

/-! ## R6. Containing the strict part of covering gives Markov's principle -/

namespace StrictCovering

/-- `src` steps to any `c n`, which steps to `e`; `tgt` steps to `m`, then to `f`; `e` and `f`
stay. -/
inductive Config
  | src
  | c (n : Nat)
  | e
  | tgt
  | m
  | f

def process : Process Config Unit := ⟨fun s _ t => match s with
  | .src => ∃ n, t = .c n
  | .c _ => t = .e
  | .e => t = .e
  | .tgt => t = .m
  | .m => t = .f
  | .f => t = .f⟩

/-- `c n` admits the one formation where `α n` is `true`; `e` and `f` admit it; the rest nothing. -/
def adm (α : Nat → Bool) : Config → Unit → Prop
  | .src, _ => False
  | .c n, _ => α n = true
  | .e, _ => True
  | .tgt, _ => False
  | .m, _ => False
  | .f, _ => True

def via (n : Nat) : Run process :=
  ⟨fun | 0 => .src | 1 => .c n | _ + 2 => .e, fun _ => (), fun | 0 => ⟨n, rfl⟩ | 1 => rfl | _ + 2 => rfl⟩

def target : Run process :=
  ⟨fun | 0 => .tgt | 1 => .m | _ + 2 => .f, fun _ => (), fun | 0 => rfl | 1 => rfl | _ + 2 => rfl⟩

theorem stepped {r : Run process} {t : Nat} {c : Config} (at_t : r.state t = c) :
    process.step c (r.act t) (r.state (t + 1)) :=
  Eq.mp (congrArg (fun y => process.step y (r.act t) (r.state (t + 1))) at_t) (r.step t)

theorem stays_e {r : Run process} (two : r.state 2 = .e) : ∀ d, r.state (d + 2) = .e
  | 0 => two
  | d + 1 => (stepped (stays_e two d) : r.state (d + 2 + 1) = .e)

theorem stays_f {r : Run process} (two : r.state 2 = .f) : ∀ d, r.state (d + 2) = .f
  | 0 => two
  | d + 1 => (stepped (stays_f two d) : r.state (d + 2 + 1) = .f)

theorem from_src (r : Run process) (start : r.state 0 = .src) :
    (∃ n, r.state 1 = .c n) ∧ ∀ d, r.state (d + 2) = .e :=
  match (stepped start : ∃ n, r.state 1 = .c n) with
  | ⟨n, one⟩ => ⟨⟨n, one⟩, stays_e (stepped one : r.state 2 = .e)⟩

theorem from_tgt (r : Run process) (start : r.state 0 = .tgt) :
    r.state 1 = .m ∧ ∀ d, r.state (d + 2) = .f :=
  have one : r.state 1 = .m := stepped start
  ⟨one, stays_f (stepped one : r.state 2 = .f)⟩

theorem moved {α : Nat → Bool} {r : Run process} {n : Nat} {c : Config} (at_n : r.state n = c)
    {x : Unit} (admitted : adm α (r.state n) x) : adm α c x :=
  Eq.subst (motive := fun y => adm α y x) at_n admitted

theorem true_or_false : ∀ b : Bool, b = true ∨ b = false
  | true => .inl rfl
  | false => .inr rfl

/-- `src` covers `tgt`, whatever `α` is. -/
theorem covers (α : Nat → Bool) : Reaching.Covers process (adm α) .src .tgt :=
  fun r' start' => ⟨via 0, rfl, fun t x admitted => match t with
    | 0 => (moved start' admitted : adm α .tgt x).elim
    | 1 => (moved (from_tgt r' start').1 admitted : adm α .m x).elim
    | _ + 2 => trivial⟩

/-- `tgt` covers `src` only where `α` is never `true`. -/
theorem not_back (α : Nat → Bool) (notAll : ¬ ∀ n, α n = false) :
    ¬ Reaching.Covers process (adm α) .tgt .src :=
  fun back => notAll fun n => match back (via n) rfl with
    | ⟨r', start', includes⟩ => match true_or_false (α n) with
      | .inl yes => (moved (from_tgt r' start').1 (includes 1 () yes) : adm α .m ()).elim
      | .inr no => no

/-- `tgt` covers `src` with lag one, whatever `α` is. -/
theorem lagged_back (α : Nat → Bool) : Reaching.CoversLater process (adm α) 1 .tgt .src :=
  fun _ start => ⟨target, rfl, fun t x admitted => match t with
    | 0 => (moved start admitted : adm α .src x).elim
    | _ + 1 => trivial⟩

/-- `src` widens what can be reached over `tgt` only with a witness that `α` is somewhere `true`. -/
theorem widens_gives (α : Nat → Bool) (widens : Reaching.Widens process (adm α) .src .tgt) :
    ∃ n, α n = true :=
  match widens with
  | ⟨_, r, start, unmatched⟩ => match (from_src r start).1 with
    | ⟨n, one⟩ => ⟨n, match true_or_false (α n) with
      | .inl yes => yes
      | .inr no => (unmatched target rfl fun t x admitted => match t with
          | 0 => (moved start admitted : adm α .src x).elim
          | 1 => (Bool.noConfusion (no.symm.trans (moved one admitted : adm α (.c n) x)) : False).elim
          | _ + 2 => trivial).elim⟩

/-- **R6.** If on every process the lagged order contained the strict part of covering, Markov's
principle would hold: it contains widening what can be reached, the strict part's constructive
form, and the two agree only where a search succeeds. -/
theorem markov_of_strict_in_lagged
    (contains : ∀ (S A X : Type) (P : Process S A) (adm : S → X → Prop) (s s' : S),
      Reaching.Covers P adm s s' → ¬ Reaching.Covers P adm s' s → Reaching.WidensOrLater P adm s s') :
    Markov :=
  fun α notAll => match contains _ _ _ process (adm α) .src .tgt (covers α) (not_back α notAll) with
    | .inl widens => widens_gives α widens
    | .inr ⟨_, notBack⟩ => (notBack ⟨1, lagged_back α⟩).elim

end StrictCovering

/-! ## R7. A pair the lagged order leaves unranked -/

namespace TwoSided

/-- On `WiderNow`'s process: `none` admits the first formation of the left side and every
formation of the right side; `some n` admits the left formations up to `n`. -/
def adm : Option Nat → Sum Nat Nat → Prop
  | none, .inl i => i = 0
  | none, .inr _ => True
  | some n, .inl i => i ≤ n
  | some _, .inr _ => False

/-- **R7.** What the climb from `some 0` admits keeps widening in 07's form, `none` admits now what
the climb does not, and the lagged order ranks neither above the other: with a lag it does not
decide every pair of a range keeping widening and one wider now. -/
theorem silent :
    Reaching.KeepsWidening (fun n => adm ((WiderNow.course (some 0)).state n)) ∧
      adm none (.inr 0) ∧ ¬ adm (some 0) (.inr 0) ∧
      ¬ Reaching.WidensOrLater WiderNow.process adm (some 0) none ∧
      ¬ Reaching.WidensOrLater WiderNow.process adm none (some 0) :=
  ⟨⟨fun n d x admitted => match x, admitted with
      | .inl _, le => Nat.le_trans le (Nat.add_le_add_left (Nat.le_add_right n d) 0)
      | .inr _, no => no.elim,
    fun n => ⟨1, .inl (0 + n + 1), Nat.le_refl _, Nat.not_succ_le_self (0 + n)⟩⟩,
   trivial, id,
   fun
    | .inl widens => widens.1.now (r' := WiderNow.course none) rfl (x := .inr 0) trivial
    | .inr ⟨⟨_, later⟩, _⟩ => match later (WiderNow.course none) rfl with
      | ⟨r, start, includes⟩ =>
        (Eq.subst (motive := fun c => adm c (.inr 0))
          (Law.runs_agree r (WiderNow.course (some 0)) start _) (includes 0 (.inr 0) trivial) :
          adm (some _) (.inr 0)),
   fun
    | .inl widens => match widens.1 (WiderNow.course (some 0)) rfl with
      | ⟨r, start, includes⟩ => Nat.noConfusion
          (Eq.subst (motive := fun c => adm c (.inl 1))
            (Law.runs_agree r (WiderNow.course none) start 1) (includes 1 (.inl 1) (Nat.le_refl 1)) :
            (1 : Nat) = 0)
    | .inr ⟨⟨_, later⟩, _⟩ => match later (WiderNow.course (some 0)) rfl with
      | ⟨r, start, includes⟩ => Nat.noConfusion
          (Eq.subst (motive := fun c => adm c (.inl 1))
            (Law.runs_agree r (WiderNow.course none) start _) (includes 1 (.inl 1) (Nat.le_refl 1)) :
            (1 : Nat) = 0)⟩

end TwoSided

/-! ## R8. Same-offset widening can rank the configuration wider now above the climb -/

namespace AllNow

/-- On `WiderNow`'s process: `none` admits every formation; `some n` the formations up to `n`. -/
def adm : Option Nat → Nat → Prop
  | none, _ => True
  | some n, x => x ≤ n

/-- **R8.** On a determined process where what a climb admits keeps widening and another
configuration admits now what the climb does not, same-offset widening need not be silent: here
`none` widens what can be reached over the climb, and the lagged order ranks `none` above it and
not conversely. -/
theorem not_silent :
    Reaching.KeepsWidening (fun n => adm ((WiderNow.course (some 0)).state n)) ∧
      adm none 1 ∧ ¬ adm (some 0) 1 ∧
      Reaching.Widens WiderNow.process adm none (some 0) ∧
      Reaching.WidensOrLater WiderNow.process adm none (some 0) ∧
      ¬ Reaching.WidensOrLater WiderNow.process adm (some 0) none :=
  have widens : Reaching.Widens WiderNow.process adm none (some 0) :=
    ⟨fun _ _ => ⟨WiderNow.course none, rfl, fun _ _ _ => trivial⟩, WiderNow.course none, rfl,
     fun _ start' includes => Nat.not_succ_le_self 0
       (Eq.subst (motive := fun c => adm c 1) start' (includes 0 1 trivial) : adm (some 0) 1)⟩
  ⟨⟨fun n d _ le => Nat.le_trans le (Nat.add_le_add_left (Nat.le_add_right n d) 0),
    fun n => ⟨1, 0 + n + 1, Nat.le_refl _, Nat.not_succ_le_self (0 + n)⟩⟩,
   trivial, Nat.not_succ_le_self 0, widens, .inl widens,
   Reaching.WidensOrLater.not_reversed widens⟩

end AllNow

/-! ## R9. The lagged order needs no `S : Type` -/

section Universe

variable {S : Type u} {A : Type v} {X : Type} {P : Process S A} {adm : S → X → Prop}

/-- The lagged order, at configurations of any universe. -/
def WidensOrLaterAt (P : Process S A) (adm : S → X → Prop) (s s' : S) : Prop :=
  Reaching.Widens P adm s s' ∨ LagPart P adm s s'

theorem WidensOrLaterAt.irrefl (s : S) : ¬ WidensOrLaterAt P adm s s
  | .inl widens => Reaching.Widens.irrefl s widens
  | .inr ⟨later, notBack⟩ => notBack later

/-- **R9.** Transitive at any universe, proved directly as `strictJoin_trans` is. -/
theorem WidensOrLaterAt.trans {s s' s'' : S} :
    WidensOrLaterAt P adm s s' → WidensOrLaterAt P adm s' s'' → WidensOrLaterAt P adm s s''
  | .inl first, .inl second => .inl (first.trans second)
  | .inl first, .inr ⟨⟨e, later⟩, notBack⟩ =>
    .inr ⟨⟨e + 0, (Reaching.CoversLater.zero.mpr first.1).trans later⟩,
      fun ⟨d, back⟩ => notBack ⟨0 + d, back.trans (Reaching.CoversLater.zero.mpr first.1)⟩⟩
  | .inr ⟨⟨d, later⟩, notBack⟩, .inl second =>
    .inr ⟨⟨0 + d, later.trans (Reaching.CoversLater.zero.mpr second.1)⟩,
      fun ⟨e, back⟩ => notBack ⟨e + 0, (Reaching.CoversLater.zero.mpr second.1).trans back⟩⟩
  | .inr ⟨⟨d, later⟩, notBack⟩, .inr ⟨⟨e, later'⟩, _⟩ =>
    .inr ⟨⟨e + d, later.trans later'⟩, fun ⟨f, back⟩ => notBack ⟨f + e, later'.trans back⟩⟩

theorem WidensOrLaterAt.not_reversed {s s' : S} (widens : Reaching.Widens P adm s s') :
    ¬ WidensOrLaterAt P adm s' s
  | .inl back => Reaching.widens_not_covered widens back.1
  | .inr ⟨_, notBack⟩ => notBack ⟨0, Reaching.CoversLater.zero.mpr widens.1⟩

end Universe

/-- At `S : Type` it is the module's `Reaching.WidensOrLater`, by definition. -/
theorem widensOrLaterAt_iff {S : Type} {A : Type v} {X : Type} {P : Process S A}
    {adm : S → X → Prop} {s s' : S} :
    WidensOrLaterAt P adm s s' ↔ Reaching.WidensOrLater P adm s s' :=
  Iff.rfl

/-! ## R10. C on the frame of reachable ranges does not decide `WiderNow`'s pair -/

/-- A strict partial order. -/
def StrictOrder {α : Type} (R : α → α → Prop) : Prop :=
  (∀ a, ¬ R a a) ∧ ∀ {a b c}, R a b → R b c → R a c

/-- **R10.** Two strict partial orders both satisfy C on `WiderNow`'s frame of reachable ranges
(`Better a b`: `b` is better): widening what can be reached and the lagged order, each read with
`b` above `a`. The first does not rank the climb above `none`, the second does. So C there leaves
the pair undecided, and the lag's verdict is a premise beyond C. -/
theorem lag_beyond_C :
    StrictOrder (fun a b => Reaching.Widens WiderNow.process WiderNow.adm b a) ∧
      Comparison (Reaching.reachFrame WiderNow.process WiderNow.adm) (fun _ => True)
        (fun a b => Reaching.Widens WiderNow.process WiderNow.adm b a) ∧
      StrictOrder (fun a b => Reaching.WidensOrLater WiderNow.process WiderNow.adm b a) ∧
      Comparison (Reaching.reachFrame WiderNow.process WiderNow.adm) (fun _ => True)
        (fun a b => Reaching.WidensOrLater WiderNow.process WiderNow.adm b a) ∧
      ¬ Reaching.Widens WiderNow.process WiderNow.adm (some 0) none ∧
      Reaching.WidensOrLater WiderNow.process WiderNow.adm (some 0) none :=
  ⟨⟨fun a => Reaching.Widens.irrefl a, fun first second => second.trans first⟩,
   fun _ _ extension => Reaching.widens_iff_extension.mpr extension,
   ⟨fun a => Reaching.WidensOrLater.irrefl a,
    fun first second => Reaching.WidensOrLater.trans second first⟩,
   fun _ _ extension => .inl (Reaching.widens_iff_extension.mpr extension),
   WiderNow.silent.2.2.2.1, WiderNow.decided.1⟩

end RecheckUE10

end Becoming
