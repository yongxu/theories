import Becoming.Horizon
import Becoming.Population
import Becoming.Admission
import Becoming.LawAlongRun

/-!
# What can be reached: widening it, and what only narrows

07's open item asks for a comparison of a range whose widening keeps widening with one merely
wider now. One candidate is what a course keeps reachable. Here it is read on any process, through
what each configuration admits (`adm : S → X → Prop`: a frame's realized claims, or what a
dependence admits at a configuration, `Dependence.AdmitsAt`, which read along a run is what the
run's web admits at its own levels, `Dependence.admitsAt_iff_admits_along`), the courses from a
configuration being the runs starting there.

* **Widening what can be reached is an order.** A course's range includes another's where what
  the other admits at an offset from its start it admits there (`Run.RangeIncludes`). A
  configuration covers another where every course from the other is included by a course from it
  (`Reaching.Covers`), and widens what can be reached over it where it covers it and some course
  from it is included by none from the other (`Reaching.Widens`). Covering is a preorder and
  widening what can be reached is irreflexive and transitive, with no premise
  (`Reaching.Covers.refl`, `Reaching.Covers.trans`, `Reaching.Widens.irrefl`,
  `Reaching.Widens.trans`). Where any two courses from one configuration agree, it is the strict
  part of range inclusion of the two courses (`Reaching.widens_iff_of_unique`), which range widening gives
  (`Reaching.widens_of_rangeWidens`).
* **The whole possible only narrows; the possible within a horizon moves with the actual.** What
  some configuration reachable from a configuration admits is its whole possible
  (`Reaching.Possible`). Along every course nothing is added to it (`Run.possible_narrows`,
  `Run.possible_narrows_add`, `Run.possible_from_start`), and every course from a configuration
  reachable from another is a tail of a course from the other, built by prefixing, with no choice
  (`Run.tail_of_reach`). The possible within `k` steps of a later configuration lies within the
  possible within `k + 1` steps of the earlier one (`Run.possibleWithin_moves`), and widening what
  can be reached, read from each configuration's own start, can rise along a course while the whole
  possible narrows (`Rise.rises`).
* **Keeping the adjacent possible widening needs an unlisted whole possible.** A course keeps the
  possible within `k` widening where at every step the possible within `k` of the next
  configuration includes the present one's and exceeds it (`Reaching.KeepsWidening`). Such a
  course gathers, for every `n`, `n` distinct members of it (`Reaching.KeepsWidening.gathers`), so
  no course keeps it widening where a list holds the whole possible from its start
  (`Reaching.not_keepsWidening_of_listed`). On a climb the possible within every horizon keeps
  widening (`Climb.keeps`), and no list holds the whole possible from its start
  (`Climb.not_listed`).
* **Options and realized courses rank a pair oppositely.** With a realized course from each
  configuration, one configuration's realized course widens another's while the other widens what
  can be reached over it through a course not realized (`Options.disagree`), so no strict partial
  order contains both (`Options.no_order_contains_both`). Realized widening, or keeping the same
  realized range and widening what can be reached (`Reaching.Lexical`), is a strict partial order
  containing realized widening and never reversing it (`Reaching.Lexical.irrefl`,
  `Reaching.Lexical.trans`, `Reaching.Lexical.of_rangeWidens`, `Reaching.Lexical.not_reversed`),
  and it separates two configurations with the same realized range, one keeping an unrealized
  alternative, which realized widening leaves unranked (`Options.tie`).
* **The possible does not certify what can be reached together.** Two configurations with the
  same whole possible, and the same possible within every horizon, differ in what can be reached:
  from one a course keeps two formations together at every step; from the other every course keeps
  them together only at its start and one of them after it (`Joint.same_possible`,
  `Joint.same_possibleWithin`, `Joint.widens`).

Each law is near-definitional or a witness, stated for every process or on a process of a few
configurations; no choice enters, and runs are built, never chosen. What the report does not
catch lies in the modelling: discrete steps; courses compared at the same offsets from their
starts; what each configuration admits given by a reading; one fixed process; the realized course
a premise.
-/

namespace Becoming

open Generative

universe u v

variable {S : Type u} {A : Type v} {X : Type}

/-! ## Ranges of courses -/

section Ranges

variable {P : Process S A}

/-- A course's range includes another's: what the other admits at an offset from its start, it
admits at that offset. -/
def Run.RangeIncludes (adm : S → X → Prop) (r r' : Run P) : Prop :=
  ∀ t x, adm (r'.state t) x → adm (r.state t) x

/-- A course's range exceeds another's: at some offset it admits what the other does not. -/
def Run.RangeExceeds (adm : S → X → Prop) (r r' : Run P) : Prop :=
  ∃ t x, adm (r.state t) x ∧ ¬ adm (r'.state t) x

/-- Range widening of courses: including and exceeding. -/
def Run.RangeWidens (adm : S → X → Prop) (r r' : Run P) : Prop :=
  r.RangeIncludes adm r' ∧ r.RangeExceeds adm r'

variable {adm : S → X → Prop}

theorem Run.RangeIncludes.refl (r : Run P) : r.RangeIncludes adm r :=
  fun _ _ admitted => admitted

theorem Run.RangeIncludes.trans {r r' r'' : Run P} (first : r.RangeIncludes adm r')
    (second : r'.RangeIncludes adm r'') : r.RangeIncludes adm r'' :=
  fun t x admitted => first t x (second t x admitted)

/-- What exceeds is not included. -/
theorem Run.RangeExceeds.not_included {r r' : Run P} (exceeds : r.RangeExceeds adm r') :
    ¬ r'.RangeIncludes adm r :=
  fun includes => match exceeds with
    | ⟨t, x, yes, no⟩ => no (includes t x yes)

theorem Run.RangeWidens.irrefl (r : Run P) : ¬ r.RangeWidens adm r :=
  fun widens => widens.2.not_included (Run.RangeIncludes.refl r)

theorem Run.RangeWidens.trans {r r' r'' : Run P} (first : r.RangeWidens adm r')
    (second : r'.RangeWidens adm r'') : r.RangeWidens adm r'' :=
  match first, second with
  | ⟨includes, t, x, yes, no⟩, ⟨includes', _⟩ =>
    ⟨includes.trans includes', t, x, yes, fun admitted => no (includes' t x admitted)⟩

end Ranges

/-! ## What can be reached -/

namespace Reaching

/-- `s` covers `s'`: every course from `s'` is included by some course from `s`. -/
def Covers (P : Process S A) (adm : S → X → Prop) (s s' : S) : Prop :=
  ∀ r' : Run P, r'.state 0 = s' → ∃ r : Run P, r.state 0 = s ∧ r.RangeIncludes adm r'

/-- **Widening what can be reached**: `s` covers `s'`, and some course from `s` is included by no
course from `s'`. -/
def Widens (P : Process S A) (adm : S → X → Prop) (s s' : S) : Prop :=
  Covers P adm s s' ∧
    ∃ r : Run P, r.state 0 = s ∧ ∀ r' : Run P, r'.state 0 = s' → ¬ r'.RangeIncludes adm r

/-- The whole possible from `s`: what some configuration reachable from `s` admits. -/
def Possible (P : Process S A) (adm : S → X → Prop) (s : S) (x : X) : Prop :=
  ∃ t, Reach P s t ∧ adm t x

/-- The possible within `k` steps of `s`: what some configuration reached from `s` in at most `k`
steps admits. With `k = 1` it is the adjacent possible with the present. -/
def PossibleWithin (P : Process S A) (adm : S → X → Prop) (k : Nat) (s : S) (x : X) : Prop :=
  ∃ t as, as.length ≤ k ∧ Trace P s as t ∧ adm t x

/-- A course keeps the possible within `k` widening: at every step the possible within `k` of the
next configuration includes the present one's and exceeds it. -/
def KeepsWidening (P : Process S A) (adm : S → X → Prop) (k : Nat) (r : Run P) : Prop :=
  ∀ n, (∀ x, PossibleWithin P adm k (r.state n) x → PossibleWithin P adm k (r.state (n + 1)) x) ∧
    ∃ x, PossibleWithin P adm k (r.state (n + 1)) x ∧ ¬ PossibleWithin P adm k (r.state n) x

variable {P : Process S A} {adm : S → X → Prop} {s s' s'' : S}

theorem Covers.refl (s : S) : Covers P adm s s :=
  fun r' start => ⟨r', start, Run.RangeIncludes.refl r'⟩

theorem Covers.trans (first : Covers P adm s s') (second : Covers P adm s' s'') :
    Covers P adm s s'' :=
  fun r'' start'' => match second r'' start'' with
    | ⟨r', start', includes'⟩ => match first r' start' with
      | ⟨r, start, includes⟩ => ⟨r, start, includes.trans includes'⟩

theorem Widens.covers (widens : Widens P adm s s') : Covers P adm s s' :=
  widens.1

theorem Widens.irrefl (s : S) : ¬ Widens P adm s s :=
  fun ⟨_, r, start, unmatched⟩ => unmatched r start (Run.RangeIncludes.refl r)

theorem Widens.trans_covers (first : Widens P adm s s') (second : Covers P adm s' s'') :
    Widens P adm s s'' :=
  match first with
  | ⟨covers, r, start, unmatched⟩ =>
    ⟨covers.trans second, r, start, fun r'' start'' includes'' =>
      match second r'' start'' with
      | ⟨r', start', includes'⟩ => unmatched r' start' (includes'.trans includes'')⟩

theorem Covers.trans_widens (first : Covers P adm s s') (second : Widens P adm s' s'') :
    Widens P adm s s'' :=
  match second with
  | ⟨covers, r', start', unmatched⟩ => match first r' start' with
    | ⟨r, start, includes⟩ =>
      ⟨first.trans covers, r, start, fun r'' start'' includes'' =>
        unmatched r'' start'' (includes''.trans includes)⟩

/-- **Widening what can be reached is transitive.** -/
theorem Widens.trans (first : Widens P adm s s') (second : Widens P adm s' s'') :
    Widens P adm s s'' :=
  first.trans_covers second.covers

/-- **Where any two courses from one configuration agree, widening what can be reached is the strict
part of range inclusion of the two courses.** -/
theorem widens_iff_of_unique
    (unique : ∀ q q' : Run P, q.state 0 = q'.state 0 → ∀ t, q.state t = q'.state t)
    {r r' : Run P} (start : r.state 0 = s) (start' : r'.state 0 = s') :
    Widens P adm s s' ↔ r.RangeIncludes adm r' ∧ ¬ r'.RangeIncludes adm r :=
  ⟨fun ⟨covers, q, qstart, unmatched⟩ => match covers r' start' with
    | ⟨q', q'start, includes⟩ =>
      ⟨fun t x admitted => Eq.subst (motive := fun y => adm y x)
          (unique q' r (q'start.trans start.symm) t) (includes t x admitted),
       fun includes' => unmatched r' start' fun t x admitted =>
          includes' t x (Eq.subst (motive := fun y => adm y x)
            (unique q r (qstart.trans start.symm) t) admitted)⟩,
   fun ⟨includes, notIncluded⟩ =>
    ⟨fun q' q'start => ⟨r, start, fun t x admitted => includes t x
        (Eq.subst (motive := fun y => adm y x) (unique q' r' (q'start.trans start'.symm) t)
          admitted)⟩,
     r, start, fun q' q'start includes' => notIncluded fun t x admitted =>
        Eq.subst (motive := fun y => adm y x) (unique q' r' (q'start.trans start'.symm) t)
          (includes' t x admitted)⟩⟩

/-- Where any two courses from one configuration agree, range widening of the courses is widening
what can be reached. -/
theorem widens_of_rangeWidens
    (unique : ∀ q q' : Run P, q.state 0 = q'.state 0 → ∀ t, q.state t = q'.state t)
    {r r' : Run P} (start : r.state 0 = s) (start' : r'.state 0 = s')
    (widens : r.RangeWidens adm r') : Widens P adm s s' :=
  (widens_iff_of_unique unique start start').mpr ⟨widens.1, widens.2.not_included⟩

/-- What is possible from a reachable configuration is possible from the first. -/
theorem Possible.of_reach (reach : Reach P s s') {x : X} (possible : Possible P adm s' x) :
    Possible P adm s x :=
  match possible with
  | ⟨t, reach', admitted⟩ => ⟨t, reach.trans reach', admitted⟩

theorem PossibleWithin.possible {k : Nat} {x : X} (within : PossibleWithin P adm k s x) :
    Possible P adm s x :=
  match within with
  | ⟨t, as, _, trace, admitted⟩ => ⟨t, ⟨as, trace⟩, admitted⟩

theorem PossibleWithin.mono {k k' : Nat} (le : k ≤ k') {x : X}
    (within : PossibleWithin P adm k s x) : PossibleWithin P adm k' s x :=
  match within with
  | ⟨t, as, length, trace, admitted⟩ => ⟨t, as, Nat.le_trans length le, trace, admitted⟩

/-- What a configuration admits is possible within every horizon from it. -/
theorem PossibleWithin.present {k : Nat} {x : X} (admitted : adm s x) :
    PossibleWithin P adm k s x :=
  ⟨s, [], Nat.zero_le k, .nil s, admitted⟩

end Reaching

/-! ## The whole possible only narrows -/

namespace Run

variable {P : Process S A} {adm : S → X → Prop}

/-- **Nothing is added to the whole possible along a course**: what is possible from the next
configuration is possible from the present one. -/
theorem possible_narrows (r : Run P) (n : Nat) {x : X} :
    Reaching.Possible P adm (r.state (n + 1)) x → Reaching.Possible P adm (r.state n) x :=
  Reaching.Possible.of_reach (Reach.of_step (r.step n))

theorem possible_narrows_add (r : Run P) (m : Nat) : ∀ k {x : X},
    Reaching.Possible P adm (r.state (m + k)) x → Reaching.Possible P adm (r.state m) x
  | 0, _, possible => possible
  | k + 1, _, possible => r.possible_narrows_add m k (r.possible_narrows (m + k) possible)

theorem possible_from_start (r : Run P) : ∀ n {x : X},
    Reaching.Possible P adm (r.state n) x → Reaching.Possible P adm (r.state 0) x
  | 0, _, possible => possible
  | n + 1, _, possible => r.possible_from_start n (r.possible_narrows n possible)

/-- **The possible within a horizon moves with the actual**: what is possible within `k` steps of
the next configuration is possible within `k + 1` steps of the present one. -/
theorem possibleWithin_moves (r : Run P) (n : Nat) {k : Nat} {x : X} :
    Reaching.PossibleWithin P adm k (r.state (n + 1)) x →
      Reaching.PossibleWithin P adm (k + 1) (r.state n) x :=
  fun ⟨t, as, length, trace, admitted⟩ =>
    ⟨t, r.act n :: as, Nat.succ_le_succ length, .cons (r.step n) trace, admitted⟩

/-- A trace into a course's start gives a course of which it is a tail, by prefixing. -/
theorem tail_of_trace (r' : Run P) : ∀ (as : List A) (s : S), Trace P s as (r'.state 0) →
    ∃ r : Run P, ∃ k, r.state 0 = s ∧ ∀ t, r.state (t + k) = r'.state t
  | [], _, .nil _ => ⟨r', 0, rfl, fun _ => rfl⟩
  | a :: as, s, .cons step rest => match tail_of_trace r' as _ rest with
    | ⟨q, k, start, tail⟩ =>
      ⟨Run.cons s a q (Eq.subst (motive := fun y => P.step s a y) start.symm step), k + 1, rfl,
        fun t => tail t⟩

/-- **Every course from a reachable configuration is a tail of a course from the first**, built by
prefixing, with no choice. -/
theorem tail_of_reach {s s' : S} (reach : Reach P s s') (r' : Run P) (start : r'.state 0 = s') :
    ∃ r : Run P, ∃ k, r.state 0 = s ∧ ∀ t, r.state (t + k) = r'.state t :=
  match reach with
  | ⟨as, trace⟩ => tail_of_trace r' as s (Eq.subst (motive := fun y => Trace P s as y) start.symm trace)

end Run

/-! ## Keeping the adjacent possible widening -/

namespace Reaching

variable {P : Process S A} {adm : S → X → Prop}

/-- A course keeping the possible within `k` widening gathers, for every `n`, `n` distinct members
of the possible within `k` of its configuration at `n`. -/
theorem KeepsWidening.gathers {k : Nat} {r : Run P} (keeps : KeepsWidening P adm k r) :
    ∀ n, ∃ xs : List X, xs.length = n ∧ Distinct xs ∧
      ∀ x, x ∈ xs → PossibleWithin P adm k (r.state n) x
  | 0 => ⟨[], rfl, trivial, fun _ mem => nomatch mem⟩
  | n + 1 => match KeepsWidening.gathers keeps n, keeps n with
    | ⟨xs, length, distinct, all⟩, ⟨grows, x, new, before⟩ =>
      ⟨x :: xs, congrArg Nat.succ length, ⟨fun mem => before (all x mem), distinct⟩,
       fun y mem => match mem_cons_cases mem with
        | .inl same =>
          Eq.subst (motive := fun z => PossibleWithin P adm k (r.state (n + 1)) z) same.symm new
        | .inr rest => grows y (all y rest)⟩

/-- **No course keeps the adjacent possible widening where a list holds the whole possible from
its start.** -/
theorem not_keepsWidening_of_listed {k : Nat} {r : Run P}
    (listed : ∃ xs : List X, ∀ x, Possible P adm (r.state 0) x → x ∈ xs) :
    ¬ KeepsWidening P adm k r :=
  fun keeps => match listed with
  | ⟨ys, holds⟩ => match keeps.gathers (ys.length + 1) with
    | ⟨_, length, distinct, all⟩ =>
      Nat.not_succ_le_self ys.length (Eq.subst (motive := fun n => n ≤ ys.length) length
        (length_le_of_sub distinct fun x mem =>
          holds x (r.possible_from_start _ (all x mem).possible)))

/-! ## Options and realized courses -/

/-- **The lexical order**: realized widening, or keeping the same realized range and widening what
can be reached, with `course` giving the realized course from each configuration. -/
def Lexical (P : Process S A) (adm : S → X → Prop) (course : S → Run P) (s s' : S) : Prop :=
  (course s).RangeWidens adm (course s') ∨
    ((course s).RangeIncludes adm (course s') ∧ (course s').RangeIncludes adm (course s) ∧
      Widens P adm s s')

variable {course : S → Run P}

theorem Lexical.irrefl (s : S) : ¬ Lexical P adm course s s
  | .inl widens => Run.RangeWidens.irrefl _ widens
  | .inr ⟨_, _, widens⟩ => Widens.irrefl s widens

theorem Lexical.trans {s s' s'' : S} :
    Lexical P adm course s s' → Lexical P adm course s' s'' → Lexical P adm course s s''
  | .inl widens, .inl widens' => .inl (widens.trans widens')
  | .inl ⟨includes, t, x, yes, no⟩, .inr ⟨includes', _, _⟩ =>
    .inl ⟨includes.trans includes', t, x, yes, fun admitted => no (includes' t x admitted)⟩
  | .inr ⟨includes, _, _⟩, .inl ⟨includes', t, x, yes, no⟩ =>
    .inl ⟨includes.trans includes', t, x, includes t x yes, no⟩
  | .inr ⟨includes, back, widens⟩, .inr ⟨includes', back', widens'⟩ =>
    .inr ⟨includes.trans includes', back'.trans back, widens.trans widens'⟩

/-- The lexical order contains realized widening. -/
theorem Lexical.of_rangeWidens {s s' : S} (widens : (course s).RangeWidens adm (course s')) :
    Lexical P adm course s s' :=
  .inl widens

/-- **The lexical order never reverses realized widening.** -/
theorem Lexical.not_reversed {s s' : S} (widens : (course s).RangeWidens adm (course s')) :
    ¬ Lexical P adm course s' s
  | .inl widens' => widens.2.not_included widens'.1
  | .inr ⟨includes, _, _⟩ => widens.2.not_included includes

end Reaching

/-! ## The World reading -/

/-- **Read along a run, what a dependence admits at a configuration** (`Dependence.AdmitsAt`: each
condition a formation requires there stands at its need) **is what the run's web admits at the
run's own levels.** -/
theorem Dependence.admitsAt_iff_admits_along {F C : Type} (K : Dependence S F C) {P : Process S A}
    (r : Run P) (t : Nat) (f : F) :
    K.AdmitsAt (r.state t) f ↔ (K.along r).Admits ((K.along r).level t) t f :=
  Iff.rfl

/-! ## Witnesses -/

namespace Rise

/-- Every step leads to `true`. -/
def process : Process Bool Unit := ⟨fun _ _ t => t = true⟩

/-- `false` admits `0`; `true` admits `0` and `1`. -/
def adm : Bool → Nat → Prop
  | false, x => x = 0
  | true, x => x ≤ 1

/-- Staying at `true`. -/
def stay : Run process := ⟨fun _ => true, fun _ => (), fun _ => rfl⟩

/-- From `false` to `true`, then staying. -/
def course : Run process := ⟨fun | 0 => false | _ + 1 => true, fun _ => (), fun _ => rfl⟩

theorem adm_le : ∀ {s : Bool} {x : Nat}, adm s x → x ≤ 1
  | false, _, zero => Eq.subst (motive := fun z => z ≤ 1) zero.symm (Nat.zero_le 1)
  | true, _, le => le

/-- **Widening what can be reached, read from each configuration's own start, can rise along a
course**, while the whole possible narrows. -/
theorem rises :
    Reaching.Widens process adm (course.state 1) (course.state 0) ∧
      ∀ x, Reaching.Possible process adm (course.state 1) x →
        Reaching.Possible process adm (course.state 0) x :=
  ⟨⟨fun _ _ => ⟨stay, rfl, fun _ _ admitted => adm_le admitted⟩, stay, rfl,
    fun r' start includes =>
      have one : adm (r'.state 0) 1 := includes 0 1 (Nat.le_refl 1)
      have zero : (1 : Nat) = 0 := Eq.subst (motive := fun y => adm y 1) start one
      Nat.noConfusion zero⟩,
   fun _ => course.possible_narrows 0⟩

end Rise

namespace Climb

/-- Each step climbs one. -/
def process : Process Nat Unit := ⟨fun n _ m => m = n + 1⟩

/-- `n` admits the formations up to `n`. -/
def adm (n x : Nat) : Prop := x ≤ n

/-- The climb from zero. -/
def course : Run process := ⟨fun t => t, fun _ => (), fun _ => rfl⟩

/-- `j` units. -/
def units : Nat → List Unit
  | 0 => []
  | j + 1 => () :: units j

theorem units_length : ∀ j, (units j).length = j
  | 0 => rfl
  | j + 1 => congrArg Nat.succ (units_length j)

/-- `j` steps from `n` reach `n + j`. -/
theorem trace_units : ∀ j n, Trace process n (units j) (n + j)
  | 0, n => .nil n
  | j + 1, n => .cons rfl (Eq.subst (motive := fun y => Trace process (n + 1) (units j) y)
      (Nat.succ_add n j) (trace_units j (n + 1)))

/-- A trace from `n` ends at `n` plus its length. -/
theorem trace_end : ∀ {n : Nat} {as : List Unit} {m : Nat}, Trace process n as m → m = n + as.length
  | _, _, _, .nil _ => rfl
  | n, _ :: as, _, .cons step rest =>
    (trace_end rest).trans (Eq.subst (motive := fun y => y + as.length = n + (as.length + 1))
      step.symm (Nat.succ_add n as.length))

theorem within_le {k n x : Nat} : Reaching.PossibleWithin process adm k n x → x ≤ n + k :=
  fun ⟨_, _, length, trace, admitted⟩ =>
    Nat.le_trans admitted (Eq.subst (motive := fun y => y ≤ n + k) (trace_end trace).symm
      (Nat.add_le_add_left length n))

theorem within_of_le {k n x : Nat} (le : x ≤ n + k) : Reaching.PossibleWithin process adm k n x :=
  ⟨n + k, units k, Eq.subst (motive := fun y => y ≤ k) (units_length k).symm (Nat.le_refl k),
    trace_units k n, le⟩

/-- **On the climb the possible within every horizon keeps widening.** -/
theorem keeps (k : Nat) : Reaching.KeepsWidening process adm k course := fun n =>
  ⟨fun _ within => within_of_le (Nat.le_trans (within_le within)
      (Nat.add_le_add_right (Nat.le_succ n) k)),
   n + k + 1, within_of_le (Nat.le_of_eq (Nat.succ_add n k).symm),
   fun within => Nat.not_succ_le_self (n + k) (within_le within)⟩

/-- No list holds the whole possible from the climb's start. -/
theorem not_listed :
    ¬ ∃ xs : List Nat, ∀ x, Reaching.Possible process adm (course.state 0) x → x ∈ xs :=
  fun listed => Reaching.not_keepsWidening_of_listed listed (keeps 1)

end Climb

namespace Options

/-- The configurations: `e t` on the course from E; `k` and `single`, two starts; `real t`, the
branch realized from both; `wide t`, the branch from `k` not realized. -/
inductive Config
  | e (t : Nat)
  | k
  | single
  | real (t : Nat)
  | wide (t : Nat)

def process : Process Config Unit := ⟨fun s _ c => match s with
  | .e t => c = .e (t + 1)
  | .k => c = .real 1 ∨ c = .wide 1
  | .single => c = .real 1
  | .real t => c = .real (t + 1)
  | .wide t => c = .wide (t + 1)⟩

/-- E, `k` and `single` admit formations `0` and `1`; the realized branch admits `0`; the wide
branch admits the formations up to `t + 1` at `wide t`. -/
def adm : Config → Nat → Prop
  | .e _, x => x ≤ 1
  | .k, x => x ≤ 1
  | .single, x => x ≤ 1
  | .real _, x => x = 0
  | .wide t, x => x ≤ t + 1

/-- From `k` along the realized branch. -/
def realized : Run process :=
  ⟨fun | 0 => .k | t + 1 => .real (t + 1), fun _ => (), fun | 0 => .inl rfl | _ + 1 => rfl⟩

/-- From `k` along the wide branch. -/
def unrealized : Run process :=
  ⟨fun | 0 => .k | t + 1 => .wide (t + 1), fun _ => (), fun | 0 => .inr rfl | _ + 1 => rfl⟩

/-- From `single`, the one course. -/
def fromSingle : Run process :=
  ⟨fun | 0 => .single | t + 1 => .real (t + 1), fun _ => (), fun | 0 => rfl | _ + 1 => rfl⟩

/-- The realized course from each configuration. -/
def course : Config → Run process
  | .e t => ⟨fun n => .e (t + n), fun _ => (), fun _ => rfl⟩
  | .k => realized
  | .single => fromSingle
  | .real t => ⟨fun n => .real (t + n), fun _ => (), fun _ => rfl⟩
  | .wide t => ⟨fun n => .wide (t + n), fun _ => (), fun _ => rfl⟩

/-- Each realized course starts at its configuration. -/
theorem course_start : ∀ c, (course c).state 0 = c
  | .e _ => rfl
  | .k => rfl
  | .single => rfl
  | .real _ => rfl
  | .wide _ => rfl

/-- The course from E is the only one. -/
theorem fromE_states : ∀ (r : Run process), r.state 0 = .e 0 → ∀ t, r.state t = .e t
  | _, start, 0 => start
  | r, start, t + 1 =>
    Eq.mp (congrArg (fun c => process.step c (r.act t) (r.state (t + 1))) (fromE_states r start t))
      (r.step t)

/-- The course from `single` is the only one. -/
theorem fromSingle_states : ∀ (r : Run process), r.state 0 = .single →
    ∀ t, r.state t = fromSingle.state t
  | _, start, 0 => start
  | r, start, t + 1 =>
    have step := Eq.mp (congrArg (fun c => process.step c (r.act t) (r.state (t + 1)))
      (fromSingle_states r start t)) (r.step t)
    match t, step with
    | 0, step => step
    | _ + 1, step => step

theorem realized_le : ∀ t {x : Nat}, adm (realized.state t) x → x ≤ 1
  | 0, _, le => le
  | _ + 1, _, zero => Eq.subst (motive := fun z => z ≤ 1) zero.symm (Nat.zero_le 1)

theorem unrealized_of_le : ∀ t {x : Nat}, x ≤ 1 → adm (unrealized.state t) x
  | 0, _, le => le
  | t + 1, _, le => Nat.le_trans le (Nat.succ_le_succ (Nat.zero_le (t + 1)))

/-- **E's realized course widens `k`'s, while `k` widens what can be reached over E** through its
course not realized. -/
theorem disagree :
    (course (.e 0)).RangeWidens adm (course .k) ∧ Reaching.Widens process adm .k (.e 0) :=
  ⟨⟨fun t _ admitted => realized_le t admitted, 1, 1, Nat.le_refl 1,
     fun zero => Nat.noConfusion (zero : (1 : Nat) = 0)⟩,
   fun r' start => ⟨unrealized, rfl, fun t x admitted => unrealized_of_le t
      (Eq.subst (motive := fun c => adm c x) (fromE_states r' start t) admitted)⟩,
   unrealized, rfl, fun r' start includes =>
    Nat.not_succ_le_self 1 (Eq.subst (motive := fun c => adm c 2) (fromE_states r' start 1)
      (includes 1 2 (Nat.le_refl 2)))⟩

/-- **No strict partial order contains both realized widening and widening what can be reached.** -/
theorem no_order_contains_both {R : Config → Config → Prop} (irrefl : ∀ a, ¬ R a a)
    (trans : ∀ {a b c}, R a b → R b c → R a c)
    (realizedWidening : ∀ {a b}, (course a).RangeWidens adm (course b) → R a b)
    (reaching : ∀ {a b}, Reaching.Widens process adm a b → R a b) : False :=
  irrefl _ (trans (realizedWidening disagree.1) (reaching disagree.2))

theorem same_realized : ∀ t {x : Nat}, adm (realized.state t) x ↔ adm (fromSingle.state t) x
  | 0, _ => Iff.rfl
  | _ + 1, _ => Iff.rfl

/-- **The tie**: `k` and `single` have the same realized range, so realized widening ranks neither
above the other, while `k` widens what can be reached over `single` and the lexical order ranks it
above. -/
theorem tie :
    (course .k).RangeIncludes adm (course .single) ∧ (course .single).RangeIncludes adm (course .k) ∧
      ¬ (course .k).RangeWidens adm (course .single) ∧ ¬ (course .single).RangeWidens adm (course .k) ∧
      Reaching.Widens process adm .k .single ∧ Reaching.Lexical process adm course .k .single :=
  have includes : (course .k).RangeIncludes adm (course .single) :=
    fun t _ admitted => (same_realized t).mpr admitted
  have back : (course .single).RangeIncludes adm (course .k) :=
    fun t _ admitted => (same_realized t).mp admitted
  have widens : Reaching.Widens process adm .k .single :=
    ⟨fun r' start => ⟨realized, rfl, fun t x admitted => (same_realized t).mpr
        (Eq.subst (motive := fun c => adm c x) (fromSingle_states r' start t) admitted)⟩,
     unrealized, rfl, fun r' start includes' =>
      Nat.noConfusion (Eq.subst (motive := fun c => adm c 2) (fromSingle_states r' start 1)
        (includes' 1 2 (Nat.le_refl 2)) : (2 : Nat) = 0)⟩
  ⟨includes, back, fun w => w.2.not_included back, fun w => w.2.not_included includes, widens,
   .inr ⟨includes, back, widens⟩⟩

end Options

namespace Joint

/-- The configurations: `both`, staying; `split`, with a step to `zero` and a step to `one`. -/
inductive Config
  | both
  | split
  | zero
  | one

def process : Process Config Unit := ⟨fun s _ c => match s with
  | .both => c = .both
  | .split => c = .zero ∨ c = .one
  | .zero => c = .zero
  | .one => c = .one⟩

/-- `both` and `split` admit formations `0` and `1`; `zero` admits `0`; `one` admits `1`. -/
def adm : Config → Nat → Prop
  | .both, x => x ≤ 1
  | .split, x => x ≤ 1
  | .zero, x => x = 0
  | .one, x => x = 1

theorem adm_le : ∀ {c : Config} {x : Nat}, adm c x → x ≤ 1
  | .both, _, le => le
  | .split, _, le => le
  | .zero, _, zero => Eq.subst (motive := fun z => z ≤ 1) zero.symm (Nat.zero_le 1)
  | .one, _, one => Eq.subst (motive := fun z => z ≤ 1) one.symm (Nat.le_refl 1)

/-- Staying at `both`. -/
def loop : Run process := ⟨fun _ => .both, fun _ => (), fun _ => rfl⟩

theorem possible_le {c : Config} {x : Nat} : Reaching.Possible process adm c x → x ≤ 1 :=
  fun ⟨_, _, admitted⟩ => adm_le admitted

/-- **The same whole possible.** -/
theorem same_possible {x : Nat} :
    Reaching.Possible process adm .both x ↔ Reaching.Possible process adm .split x :=
  ⟨fun possible => ⟨.split, Reach.refl _ _, possible_le possible⟩,
   fun possible => ⟨.both, Reach.refl _ _, possible_le possible⟩⟩

/-- **The same possible within every horizon.** -/
theorem same_possibleWithin (k : Nat) {x : Nat} :
    Reaching.PossibleWithin process adm k .both x ↔ Reaching.PossibleWithin process adm k .split x :=
  ⟨fun within => Reaching.PossibleWithin.present (possible_le within.possible),
   fun within => Reaching.PossibleWithin.present (possible_le within.possible)⟩

/-- **Different reach**: `both` widens what can be reached over `split`, since after its start every
course from `split` keeps one of the two formations only. -/
theorem widens : Reaching.Widens process adm .both .split :=
  ⟨fun _ _ => ⟨loop, rfl, fun _ _ admitted => adm_le admitted⟩, loop, rfl,
   fun r' start includes =>
    have step : r'.state 1 = .zero ∨ r'.state 1 = .one :=
      Eq.mp (congrArg (fun c => process.step c (r'.act 0) (r'.state 1)) start) (r'.step 0)
    match step with
    | .inl zero => Nat.noConfusion
        (Eq.subst (motive := fun c => adm c 1) zero (includes 1 1 (Nat.le_refl 1)) : (1 : Nat) = 0)
    | .inr one => Nat.noConfusion
        (Eq.subst (motive := fun c => adm c 0) one (includes 1 0 (Nat.zero_le 1)) : (0 : Nat) = 1)⟩

end Joint

end Becoming
