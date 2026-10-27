import Becoming.ReachableRanges

/-!
# UE10 review probes, part 1: laws

Probes of the draft `Becoming.ReachableRanges` (review REVIEW-UE10.md). Each probe names the finding
it supports. Nothing here is proposed for landing as written.
-/

namespace Becoming

namespace ProbeUE10

open Generative

universe u v

section Laws

variable {S : Type u} {A : Type v} {X : Type} {P : Process S A} {adm : S → X → Prop}

/-- Every configuration of a run can be had from its start (as `Onward.reach_of_run`). -/
theorem reach_of_run (r : Run P) (n : Nat) : Reach P (r.state 0) (r.state n) :=
  Eq.subst (motive := fun m => Reach P (r.state 0) (r.state m)) (Nat.zero_add n) (r.reach 0 n)

/-! ## B1. Covering carries the whole possible where reachable configurations start courses -/

/-- **Probe B1.** Where every configuration reachable from `s'` starts a course, a configuration
covering `s'` has everything possible from `s'` possible from it. -/
theorem covers_possible {s s' : S} (covers : Reaching.Covers P adm s s')
    (runs : ∀ t, Reach P s' t → ∃ q : Run P, q.state 0 = t) {x : X}
    (possible : Reaching.Possible P adm s' x) : Reaching.Possible P adm s x :=
  match possible with
  | ⟨t, ⟨as, trace⟩, admitted⟩ =>
    match runs t ⟨as, trace⟩ with
    | ⟨q, qstart⟩ =>
      match Run.tail_of_trace q as s'
          (Eq.subst (motive := fun y => Trace P s' as y) qstart.symm trace) with
      | ⟨r', k, start', tail⟩ =>
        match covers r' start' with
        | ⟨r, start, includes⟩ =>
          have here : r'.state (0 + k) = t := (tail 0).trans qstart
          ⟨r.state (0 + k), Eq.subst (motive := fun y => Reach P y (r.state (0 + k))) start
              (reach_of_run r (0 + k)),
           includes (0 + k) x (Eq.subst (motive := fun y => adm y x) here.symm admitted)⟩

/-- **Probe B1, along a course.** Where the next configuration covers the present one and every
configuration reachable from the present one starts a course, the whole possible is unchanged
across the step: it neither grows (`Run.possible_narrows`) nor narrows. -/
theorem possible_unchanged_of_covers_next (r : Run P) (n : Nat)
    (covers : Reaching.Covers P adm (r.state (n + 1)) (r.state n))
    (runs : ∀ t, Reach P (r.state n) t → ∃ q : Run P, q.state 0 = t) (x : X) :
    Reaching.Possible P adm (r.state (n + 1)) x ↔ Reaching.Possible P adm (r.state n) x :=
  ⟨r.possible_narrows n, covers_possible covers runs⟩

end Laws

/-! ## B2. A dead end: widening what can be reached against the whole possible -/

namespace DeadEnd

/-- `true` stays; `false` has no step. -/
def process : Process Bool Unit := ⟨fun s _ t => s = true ∧ t = true⟩

/-- `true` admits nothing; `false` admits every formation. -/
def adm : Bool → Nat → Prop
  | true, _ => False
  | false, _ => True

def stay : Run process := ⟨fun _ => true, fun _ => (), fun _ => ⟨rfl, rfl⟩⟩

theorem no_course (r : Run process) (start : r.state 0 = false) : False :=
  Bool.noConfusion (start.symm.trans (r.step 0).1)

theorem from_true {t : Bool} (reach : Reach process true t) : t = true :=
  Invariant.reach (P := process) (I := fun y => y = true) (fun _ _ _ step _ => step.2) reach rfl

/-- **Probe B2.** `true`, admitting nothing on its one course, widens what can be reached over the
dead end `false`, which admits every formation: everything is possible from `false` and nothing from
`true`. -/
theorem widens_reversed :
    Reaching.Widens process adm true false ∧ (∀ x, Reaching.Possible process adm false x) ∧
      ∀ x, ¬ Reaching.Possible process adm true x :=
  ⟨⟨fun r' start' => (no_course r' start').elim, stay, rfl,
     fun r' start' _ => no_course r' start'⟩,
   fun _ => ⟨false, Reach.refl _ _, trivial⟩,
   fun x ⟨_, reach, admitted⟩ =>
     (Eq.subst (motive := fun y => adm y x) (from_true reach) admitted : adm true x)⟩

end DeadEnd

section Laws

variable {S : Type u} {A : Type v} {X : Type} {P : Process S A} {adm : S → X → Prop}

/-! ## B3. Rising read from each configuration's start is the course against its own delay -/

/-- A run from its second configuration on. -/
def shift (r : Run P) : Run P := ⟨fun t => r.state (t + 1), fun t => r.act (t + 1), fun t => r.step (t + 1)⟩

/-- **Probe B3.** Where any two courses from one configuration agree, the next configuration of a
course widens what can be reached over the present one exactly where the course's admissions at each
step are kept at the next and not conversely: the course compared with itself one step late. -/
theorem widens_next_iff_rising
    (unique : ∀ q q' : Run P, q.state 0 = q'.state 0 → ∀ t, q.state t = q'.state t) (r : Run P) :
    Reaching.Widens P adm (r.state 1) (r.state 0) ↔
      (∀ t x, adm (r.state t) x → adm (r.state (t + 1)) x) ∧
        ¬ ∀ t x, adm (r.state (t + 1)) x → adm (r.state t) x :=
  Reaching.widens_iff_of_unique unique (r := shift r) (r' := r) rfl rfl

/-- Every run of a law (`Law.process`) is determined by its start. -/
theorem law_unique {next : S → S} :
    ∀ q q' : Run (Law.process next), q.state 0 = q'.state 0 → ∀ t, q.state t = q'.state t :=
  fun q q' start => fun t => Nat.rec (motive := fun t => q.state t = q'.state t) start
    (fun t same => (q.step t).trans ((congrArg next same).trans (q'.step t).symm)) t

/-- `Rise.process` is the law sending everything to `true`. -/
theorem rise_is_law : Rise.process = Law.process (fun _ => true) := rfl

/-! ## B4. The iff holds where each configuration has a greatest course -/

/-- **Probe B4.** Where `r` includes every course from `s` and `r'` every course from `s'`,
widening what can be reached is the strict part of range inclusion of `r` and `r'`. No uniqueness. -/
theorem widens_iff_of_greatest {s s' : S} {r r' : Run P} (start : r.state 0 = s)
    (start' : r'.state 0 = s') (greatest : ∀ q : Run P, q.state 0 = s → r.RangeIncludes adm q)
    (greatest' : ∀ q : Run P, q.state 0 = s' → r'.RangeIncludes adm q) :
    Reaching.Widens P adm s s' ↔ r.RangeIncludes adm r' ∧ ¬ r'.RangeIncludes adm r :=
  ⟨fun ⟨covers, q, qstart, unmatched⟩ => match covers r' start' with
    | ⟨q', q'start, includes⟩ =>
      ⟨(greatest q' q'start).trans includes,
       fun back => unmatched r' start' (back.trans (greatest q qstart))⟩,
   fun ⟨includes, notBack⟩ =>
    ⟨fun q' q'start => ⟨r, start, includes.trans (greatest' q' q'start)⟩,
     r, start, fun q' q'start includes' => notBack ((greatest' q' q'start).trans includes')⟩⟩

/-- **Probe B4.** Range widening gives widening what can be reached where only the second course
includes every course from its start. -/
theorem widens_of_rangeWidens_greatest {s s' : S} {r r' : Run P} (start : r.state 0 = s)
    (greatest' : ∀ q : Run P, q.state 0 = s' → r'.RangeIncludes adm q)
    (widens : r.RangeWidens adm r') : Reaching.Widens P adm s s' :=
  ⟨fun q' q'start => ⟨r, start, widens.1.trans (greatest' q' q'start)⟩,
   r, start, fun q' q'start includes' =>
     widens.2.not_included ((greatest' q' q'start).trans includes')⟩

/-- Uniqueness gives a greatest course. -/
theorem greatest_of_unique
    (unique : ∀ q q' : Run P, q.state 0 = q'.state 0 → ∀ t, q.state t = q'.state t)
    {s : S} {r : Run P} (start : r.state 0 = s) :
    ∀ q : Run P, q.state 0 = s → r.RangeIncludes adm q :=
  fun q qstart t x admitted =>
    Eq.subst (motive := fun y => adm y x) (unique q r (qstart.trans start.symm) t) admitted

end Laws

/-! A fork with a greatest course and two courses apart: `fork` steps to `big` or `small`. -/

namespace Fork

inductive Config
  | fork
  | big
  | small

def process : Process Config Unit := ⟨fun s _ c => match s with
  | .fork => c = .big ∨ c = .small
  | .big => c = .big
  | .small => c = .small⟩

def adm : Config → Nat → Prop
  | .fork, x => x = 0
  | .big, x => x ≤ 1
  | .small, x => x = 0

def toBig : Run process := ⟨fun | 0 => .fork | _ + 1 => .big, fun _ => (), fun | 0 => .inl rfl | _ + 1 => rfl⟩
def toSmall : Run process := ⟨fun | 0 => .fork | _ + 1 => .small, fun _ => (), fun | 0 => .inr rfl | _ + 1 => rfl⟩

theorem small_le : ∀ (c : Config) {x : Nat}, adm c x → (c = .small ∨ c = .fork) → x = 0
  | .small, _, zero, _ => zero
  | .fork, _, zero, _ => zero
  | .big, _, _, .inl same => Config.noConfusion same
  | .big, _, _, .inr same => Config.noConfusion same

theorem le_one : ∀ (c : Config) {x : Nat}, adm c x → x ≤ 1
  | .small, _, zero => Eq.subst (motive := fun z => z ≤ 1) zero.symm (Nat.zero_le 1)
  | .fork, _, zero => Eq.subst (motive := fun z => z ≤ 1) zero.symm (Nat.zero_le 1)
  | .big, _, le => le

/-- After the fork, a course is at `big` or at `small`. -/
theorem after : ∀ (q : Run process), q.state 0 = .fork → ∀ t, q.state (t + 1) = .big ∨ q.state (t + 1) = .small
  | q, start, 0 => Eq.mp (congrArg (fun c => process.step c (q.act 0) (q.state 1)) start) (q.step 0)
  | q, start, t + 1 => match after q start t with
    | .inl big => .inl (Eq.mp (congrArg (fun c => process.step c (q.act (t + 1)) (q.state (t + 2))) big)
        (q.step (t + 1)))
    | .inr small => .inr (Eq.mp (congrArg (fun c => process.step c (q.act (t + 1)) (q.state (t + 2))) small)
        (q.step (t + 1)))

/-- **Probe B4 witness.** `toBig` includes every course from `fork`, while two courses from `fork`
differ: the greatest-course form applies where uniqueness fails. -/
theorem greatest_not_unique :
    (∀ q : Run process, q.state 0 = .fork → toBig.RangeIncludes adm q) ∧
      ¬ ∀ q q' : Run process, q.state 0 = q'.state 0 → ∀ t, q.state t = q'.state t :=
  ⟨fun q start t x admitted => match t with
    | 0 => Eq.subst (motive := fun c => adm c x) start admitted
    | t + 1 => le_one (q.state (t + 1)) admitted,
   fun unique => Config.noConfusion (unique toBig toSmall rfl 1)⟩

end Fork

section Laws

variable {S : Type u} {A : Type v} {X : Type} {P : Process S A} {adm : S → X → Prop}

/-! ## B5. Widening what can be reached is one-way against covering -/

/-- **Probe B5.** What widens what can be reached over another is not covered by it. -/
theorem widens_not_covered {s s' : S} (widens : Reaching.Widens P adm s s') :
    ¬ Reaching.Covers P adm s' s :=
  fun back => match widens with
  | ⟨_, r, start, unmatched⟩ => match back r start with
    | ⟨r', start', includes⟩ => unmatched r' start' includes

/-! ## B6. Law 3 in 07's form, for any chain of predicates -/

/-- 07's form of keeping widening, for a chain of predicates: nothing held is lost from any step to
a later one, and after every step something not held there is held later. -/
def ChainKeepsWidening (Q : Nat → X → Prop) : Prop :=
  (∀ n d x, Q n x → Q (n + d) x) ∧ ∀ n, ∃ d x, Q (n + d) x ∧ ¬ Q n x

theorem ChainKeepsWidening.gathers {Q : Nat → X → Prop} (keeps : ChainKeepsWidening Q) :
    ∀ n, ∃ xs : List X, ∃ m, xs.length = n ∧ Distinct xs ∧ ∀ x, x ∈ xs → Q m x
  | 0 => ⟨[], 0, rfl, trivial, fun _ mem => nomatch mem⟩
  | n + 1 => match ChainKeepsWidening.gathers keeps n with
    | ⟨xs, m, length, distinct, all⟩ => match keeps.2 m with
      | ⟨d, x, new, before⟩ =>
        ⟨x :: xs, m + d, congrArg Nat.succ length, ⟨fun mem => before (all x mem), distinct⟩,
         fun y mem => match mem_cons_cases mem with
          | .inl same => Eq.subst (motive := fun z => Q (m + d) z) same.symm new
          | .inr rest => keeps.1 m d y (all y rest)⟩

/-- **Probe B6.** No chain keeping widening in 07's form is held by a list. -/
theorem ChainKeepsWidening.not_listed {Q : Nat → X → Prop} (keeps : ChainKeepsWidening Q) :
    ¬ ∃ ys : List X, ∀ n x, Q n x → x ∈ ys :=
  fun ⟨ys, holds⟩ => match keeps.gathers (ys.length + 1) with
  | ⟨_, m, length, distinct, all⟩ =>
    Nat.not_succ_le_self ys.length (Eq.subst (motive := fun n => n ≤ ys.length) length
      (length_le_of_sub distinct fun x mem => holds m x (all x mem)))

/-- The module's per-step form gives 07's form. -/
theorem chain_of_keepsWidening {k : Nat} {r : Run P} (keeps : Reaching.KeepsWidening P adm k r) :
    ChainKeepsWidening (fun n => Reaching.PossibleWithin P adm k (r.state n)) :=
  ⟨fun n d x within => Nat.rec (motive := fun d => Reaching.PossibleWithin P adm k (r.state (n + d)) x)
      within (fun d held => (keeps (n + d)).1 x held) d,
   fun n => match (keeps n).2 with
    | ⟨x, new, before⟩ => ⟨1, x, new, before⟩⟩

/-- **Probe B6.** Law 3 with the weaker hypothesis: a list holding what is possible within `k` along
the course, not the whole possible from its start. -/
theorem not_keepsWidening_of_listed_along {k : Nat} {r : Run P}
    (listed : ∃ ys : List X, ∀ n x, Reaching.PossibleWithin P adm k (r.state n) x → x ∈ ys) :
    ¬ Reaching.KeepsWidening P adm k r :=
  fun keeps => (chain_of_keepsWidening keeps).not_listed listed

/-- The module's hypothesis gives the weaker one. -/
theorem listed_along_of_listed {k : Nat} {r : Run P}
    (listed : ∃ ys : List X, ∀ x, Reaching.Possible P adm (r.state 0) x → x ∈ ys) :
    ∃ ys : List X, ∀ n x, Reaching.PossibleWithin P adm k (r.state n) x → x ∈ ys :=
  match listed with
  | ⟨ys, holds⟩ => ⟨ys, fun n x within => holds x (r.possible_from_start n within.possible)⟩

end Laws

/-- Half, rounded down, by two-step recursion. -/
def half : Nat → Nat
  | 0 => 0
  | 1 => 0
  | n + 2 => half n + 1

theorem half_le_succ : ∀ n, half n ≤ half (n + 1)
  | 0 => Nat.le_refl 0
  | 1 => Nat.zero_le 1
  | n + 2 => Nat.succ_le_succ (half_le_succ n)

theorem half_le_add (n : Nat) : ∀ d, half n ≤ half (n + d)
  | 0 => Nat.le_refl _
  | d + 1 => Nat.le_trans (half_le_add n d) (half_le_succ (n + d))

/-- **Probe B6 witness.** 07's form does not give the per-step form: `x ≤ half n` gains a member at
every other step only. -/
theorem every_other_step :
    ChainKeepsWidening (fun n (x : Nat) => x ≤ half n) ∧
      ¬ ∀ n, ∃ x : Nat, x ≤ half (n + 1) ∧ ¬ x ≤ half n :=
  ⟨⟨fun n d _ le => Nat.le_trans le (half_le_add n d),
    fun n => ⟨2, half n + 1, Nat.le_refl _, Nat.not_succ_le_self (half n)⟩⟩,
   fun every => match every 0 with
    | ⟨_, le, no⟩ => no le⟩

/-! ## B7. Law 3's converse fails -/

/-- A number beyond every member of a list. -/
def beyond : List Nat → Nat
  | [] => 0
  | a :: as => a + beyond as + 1

theorem lt_beyond : ∀ {xs : List Nat} {x : Nat}, x ∈ xs → x < beyond xs
  | a :: as, _, .head _ => Nat.lt_succ_of_le (Nat.le_add_right a (beyond as))
  | a :: as, _, .tail _ mem => Nat.lt_succ_of_le (Nat.le_trans (Nat.le_of_lt (lt_beyond mem))
      (Nat.le_add_left (beyond as) a))

namespace Static

/-- One configuration, staying, admitting every formation. -/
def process : Process Unit Unit := ⟨fun _ _ _ => True⟩

def adm (_ : Unit) (_ : Nat) : Prop := True

/-- **Probe B7.** No list holds the whole possible, and no course keeps the possible within any
horizon widening: law 3's converse fails. -/
theorem converse_fails (k : Nat) :
    (¬ ∃ xs : List Nat, ∀ x, Reaching.Possible process adm () x → x ∈ xs) ∧
      ∀ r : Run process, ¬ Reaching.KeepsWidening process adm k r :=
  ⟨fun ⟨xs, holds⟩ => Nat.lt_irrefl _ (lt_beyond (holds (beyond xs) ⟨(), Reach.refl _ _, trivial⟩)),
   fun _ keeps => match (keeps 0).2 with
    | ⟨_, new, before⟩ => before new⟩

end Static

section Laws

variable {S : Type u} {A : Type v} {X : Type} {P : Process S A} {adm : S → X → Prop}

/-! ## B8. Range inclusion on the grammar, and on a web with fixed conditions -/

/-- What a course admits, as a relation of the grammar on (offset, formation) pairs, as
`Web.admitted`. -/
def admittedAlong (adm : S → X → Prop) (r : Run P) : «际» (Nat × X) :=
  fun p q => p = q ∧ adm (r.state p.1) p.2

/-- **Probe B8.** Range inclusion is the grammar's inclusion (`«则»`) of what the courses admit. -/
theorem rangeIncludes_iff {r r' : Run P} :
    r.RangeIncludes adm r' ↔ «则» (admittedAlong adm r') (admittedAlong adm r) :=
  ⟨fun includes _ _ ⟨e, admits⟩ => ⟨e, includes _ _ admits⟩,
   fun inside t x admits => (inside (t, x) (t, x) ⟨rfl, admits⟩).2⟩

/-- **Probe B8.** Range exceeding is the grammar's (`«逾»`). -/
theorem rangeExceeds_iff {r r' : Run P} :
    r.RangeExceeds adm r' ↔ «逾» (admittedAlong adm r) (admittedAlong adm r') :=
  ⟨fun ⟨t, x, admits, not⟩ => ⟨(t, x), (t, x), ⟨rfl, admits⟩, fun ⟨_, admitted⟩ => not admitted⟩,
   fun ⟨p, _, ⟨e, admits⟩, not⟩ => ⟨p.1, p.2, admits, fun admitted => not ⟨e, admitted⟩⟩⟩

/-- **Probe B8.** With fixed conditions, range inclusion of two courses is 07's inclusion
(`Web.Includes`) of their levels on the web of either. -/
theorem rangeIncludes_conditions_iff {F C : Type} (K : Conditions S F C) (r r' : Run P) :
    r.RangeIncludes K.dependence.AdmitsAt r' ↔
      (K.dependence.along r).Includes (K.dependence.along r).level (K.dependence.along r').level :=
  Iff.rfl

/-- **Probe B8.** With fixed conditions, range widening of two courses is 07's widening
(`Web.Widens`). -/
theorem rangeWidens_conditions_iff {F C : Type} (K : Conditions S F C) (r r' : Run P) :
    r.RangeWidens K.dependence.AdmitsAt r' ↔
      (K.dependence.along r).Widens (K.dependence.along r).level (K.dependence.along r').level :=
  Iff.rfl

/-! ## B9. Covering is dominance for every upward-closed criterion -/

/-- **Probe B9.** `s` covers `s'` exactly where every criterion on ranges closed upward under
inclusion that some course from `s'` meets, some course from `s` meets (dominance of menus,
the lower or Hoare ordering of the families of ranges). -/
theorem covers_iff_criteria {s s' : S} :
    Reaching.Covers P adm s s' ↔
      ∀ V : (Nat → X → Prop) → Prop, (∀ ρ σ, (∀ t x, ρ t x → σ t x) → V ρ → V σ) →
        (∃ r' : Run P, r'.state 0 = s' ∧ V (fun t x => adm (r'.state t) x)) →
          ∃ r : Run P, r.state 0 = s ∧ V (fun t x => adm (r.state t) x) :=
  ⟨fun covers _ up ⟨r', start', met⟩ => match covers r' start' with
    | ⟨r, start, includes⟩ => ⟨r, start, up _ _ includes met⟩,
   fun criteria r' start' => criteria (fun ρ => ∀ t x, adm (r'.state t) x → ρ t x)
     (fun _ _ sub held t x admitted => sub t x (held t x admitted))
     ⟨r', start', fun _ _ admitted => admitted⟩⟩


/-! ## B10. Read with a lag of one step, nothing rises along a course -/

/-- `s` covers `s'` with lag `d`: every course from `s'` is included, `d` steps later, by a course
from `s` (UE9's lag, `Web.IncludesLater`, read on courses). -/
def CoversLater (P : Process S A) (adm : S → X → Prop) (d : Nat) (s s' : S) : Prop :=
  ∀ r' : Run P, r'.state 0 = s' → ∃ r : Run P, r.state 0 = s ∧ ∀ t x, adm (r'.state t) x → adm (r.state (t + d)) x

/-- **Probe B10.** Along every course, each configuration covers the next with lag one, by
prefixing (`Run.cons`): what the later configuration's courses admit, the earlier one's admit one
step later. So `Rise.rises` is the same-offset reading. -/
theorem coversLater_next (r : Run P) (n : Nat) : CoversLater P adm 1 (r.state n) (r.state (n + 1)) :=
  fun q start => ⟨Run.cons (r.state n) (r.act n) q
      (Eq.subst (motive := fun y => P.step (r.state n) (r.act n) y) start.symm (r.step n)),
    rfl, fun _ _ admitted => admitted⟩

/-! ## B11. On a law the possible within a horizon is the course's own admissions over a window -/

/-- The `k` actions of a run from `n` are `k`. -/
theorem window_length' (r : Run P) : ∀ k n, (r.window n k).length = k
  | 0, _ => rfl
  | k + 1, n => congrArg Nat.succ (window_length' r k (n + 1))

/-- On a law, a trace from a course's configuration at `n` ends at the course's configuration that
many steps on. -/
theorem law_trace_end {next : S → S} (r : Run (Law.process next)) :
    ∀ (as : List Unit) (n : Nat) {t : S}, Trace (Law.process next) (r.state n) as t →
      t = r.state (n + as.length)
  | [], _, _, .nil _ => rfl
  | _ :: as, n, _, .cons step rest =>
    (law_trace_end r as (n + 1)
      (Eq.subst (motive := fun y => Trace (Law.process next) y as _)
        (step.trans (r.step n).symm) rest)).trans
      (congrArg r.state (Nat.succ_add n as.length))

/-- **Probe B11.** On a law, the possible within `k` of a course's configuration at `n` is what the
course itself admits at some step from `n` to `n + k`: no alternative enters. -/
theorem law_possibleWithin_iff {next : S → S} {adm : S → X → Prop} (r : Run (Law.process next))
    (k n : Nat) (x : X) :
    Reaching.PossibleWithin (Law.process next) adm k (r.state n) x ↔
      ∃ j, j ≤ k ∧ adm (r.state (n + j)) x :=
  ⟨fun ⟨_, as, length, trace, admitted⟩ => ⟨as.length, length,
      Eq.subst (motive := fun y => adm y x) (law_trace_end r as n trace) admitted⟩,
   fun ⟨j, le, admitted⟩ => ⟨r.state (n + j), r.window n j,
      Eq.subst (motive := fun m => m ≤ k) (window_length' r j n).symm le,
      r.window_trace j n, admitted⟩⟩

/-! ## B12. Covering needs being at least as wide now -/

/-- **Probe B12.** A configuration covering another admits now everything the other admits now,
where the other starts a course. -/
theorem covers_now {s s' : S} (covers : Reaching.Covers P adm s s') {r' : Run P}
    (start' : r'.state 0 = s') {x : X} (admitted : adm s' x) : adm s x :=
  match covers r' start' with
  | ⟨_, start, includes⟩ => Eq.subst (motive := fun y => adm y x) start
      (includes 0 x (Eq.subst (motive := fun y => adm y x) start'.symm admitted))

/-- **Probe B12.** So neither widening what can be reached nor the lexical order ranks a
configuration above one admitting now what it does not: a range that keeps widening is never
ranked above one wider now. -/
theorem not_above_wider_now {course : S → Run P} {s s' : S} (start : (course s).state 0 = s)
    (start' : (course s').state 0 = s') {x : X} (now : adm s' x) (notNow : ¬ adm s x) :
    ¬ Reaching.Widens P adm s s' ∧ ¬ Reaching.Lexical P adm course s s' :=
  have included : (course s).RangeIncludes adm (course s') → False := fun includes =>
    notNow (Eq.subst (motive := fun y => adm y x) start
      (includes 0 x (Eq.subst (motive := fun y => adm y x) start'.symm now)))
  ⟨fun widens => notNow (covers_now widens.1 start' now),
   fun | .inl widens => included widens.1
       | .inr ⟨includes, _, _⟩ => included includes⟩

end Laws

/-- `Climb.process` is the law of the successor. -/
theorem climb_is_law : Climb.process = Law.process (fun n => n + 1) := rfl

end ProbeUE10

end Becoming
