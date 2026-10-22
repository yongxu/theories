/-! ## A coupling saturated by what it has carried -/

namespace Saturation

/-- What the couplings of `d` into `c` pass at step `t`, with strengths `k` and levels `l`: what
the formations present outside the part give `c` from the levels of `d` up to `t`. -/
def passingAt (part : F → Bool) (k : Nat → F → C → Nat → C → Nat) (present : Nat → List F)
    (l : Nat → C → Nat) (t : Nat) (d c : C) : Nat :=
  total (present t) fun h => bif part h then 0 else
    total (steps 0 (t + 1)) fun s => k t h c s d * l s d

/-- **What has passed through a coupling.** With the strengths of `d` into `c` at each step those of
`sat a`, `a` the amount already passed through the coupling, the amount passed from the levels `l`
of `d` into `c` across the steps before `t`. -/
def passed (part : F → Bool) (sat : Nat → Nat → F → C → Nat → C → Nat) (present : Nat → List F)
    (l : Nat → C → Nat) (d c : C) : Nat → Nat
  | 0 => 0
  | t + 1 => passed part sat present l d c t +
      passingAt part (sat (passed part sat present l d c t)) present l t d c

/-- **Strengths saturated by what has passed.** At each step the strength of each reading of `d`
into `c` is that of `sat` at the amount already passed through that coupling. -/
def strengths (part : F → Bool) (sat : Nat → Nat → F → C → Nat → C → Nat)
    (present : Nat → List F) : (Nat → C → Nat) → Nat → F → C → Nat → C → Nat :=
  fun l t h c s d => sat (passed part sat present l d c t) t h c s d

/-- The strengths of `d` into `c` do not rise as more has passed. -/
def Antitone (sat : Nat → Nat → F → C → Nat → C → Nat) (d c : C) : Prop :=
  ∀ a a', a ≤ a' → ∀ t h s, sat a' t h c s d ≤ sat a t h c s d

/-- The strengths of `d` into `c` are zero once `A` has passed. -/
def ZeroFrom (sat : Nat → Nat → F → C → Nat → C → Nat) (d c : C) (A : Nat) : Prop :=
  ∀ a, A ≤ a → ∀ t h s, sat a t h c s d = 0

/-- Strengths `f a` times the strengths `k`: `f` is how the coupling responds to what has passed. -/
def scaled (f : Nat → Nat) (k : Nat → F → C → Nat → C → Nat) : Nat → Nat → F → C → Nat → C → Nat :=
  fun a t h c s d => f a * k t h c s d

variable {cs : List C} {part : F → Bool} {σ : Nat → F → C → Nat} {present : Nat → List F}
  {sat : Nat → Nat → F → C → Nat → C → Nat} {l : Nat → C → Nat} {d c : C}

/-- Strengths that do not rise as more passes and are zero at `A` are zero from `A` on. -/
theorem Antitone.zeroFrom {A : Nat} (antitone : Antitone sat d c)
    (zero : ∀ t h s, sat A t h c s d = 0) : ZeroFrom sat d c A :=
  fun a le t h s => Nat.eq_zero_of_le_zero
    (Nat.le_trans (antitone A a le t h s) (Nat.le_of_eq (zero t h s)))

/-- What passes at a step reads the levels up to it only. -/
theorem passingAt_congr {k : Nat → F → C → Nat → C → Nat} {l' : Nat → C → Nat} {t : Nat}
    (agree : ∀ s, s ≤ t → l s d = l' s d) :
    passingAt part k present l t d c = passingAt part k present l' t d c :=
  total_congr (fun h => congrArg (cond (part h) 0)
    (total_congr_on fun s mem => congrArg (k t h c s d * ·)
      (agree s (Propagation.le_of_mem_steps_upto mem)))) _

/-- What has passed before `t` reads the levels before `t` only. -/
theorem passed_congr {l' : Nat → C → Nat} : ∀ {t : Nat}, (∀ s, s < t → l s d = l' s d) →
    passed part sat present l d c t = passed part sat present l' d c t
  | 0, _ => rfl
  | t + 1, agree =>
    have before : passed part sat present l d c t = passed part sat present l' d c t :=
      passed_congr fun s lt => agree s (Nat.lt_succ_of_lt lt)
    Naturals.add_congr before
      ((congrArg (fun a => passingAt part (sat a) present l t d c) before).trans
        (passingAt_congr fun s le => agree s (Nat.lt_succ_of_le le)))

/-- **The saturated strengths read the levels before.** What has passed before a step reads the
levels before it, so the strengths at each step read the levels up to it (`ReadsBefore`). -/
theorem readsBefore : ReadsBefore (strengths part sat present) :=
  fun t _ _ agree h c s d =>
    congrArg (fun a => sat a t h c s d) (passed_congr fun s' lt => agree s' (Nat.le_of_lt lt) d)

/-- What has passed never falls. -/
theorem passed_le_succ (t : Nat) :
    passed part sat present l d c t ≤ passed part sat present l d c (t + 1) :=
  Nat.le_add_right _ _

theorem passed_le_add (t : Nat) :
    ∀ k, passed part sat present l d c t ≤ passed part sat present l d c (t + k)
  | 0 => Nat.le_refl _
  | k + 1 => Nat.le_trans (passed_le_add t k) (passed_le_succ (t + k))

theorem passed_mono {t t' : Nat} (le : t ≤ t') :
    passed part sat present l d c t ≤ passed part sat present l d c t' :=
  match Nat.le.dest le with
  | ⟨k, same⟩ =>
    Eq.subst (motive := fun x => passed part sat present l d c t ≤ passed part sat present l d c x)
      same (passed_le_add t k)

/-- Where the strengths at the amount passed are zero, nothing passes. -/
theorem passingAt_zero {a t : Nat} (zero : ∀ h s, sat a t h c s d = 0) :
    passingAt part (sat a) present l t d c = 0 :=
  total_eq_zero fun h _ => by
    cases part h with
    | true => rfl
    | false =>
      exact total_eq_zero fun s _ => (congrArg (· * l s d) (zero h s)).trans (Nat.zero_mul _)

/-- At least one passes where a formation present outside the part reads the level of `d` at the
step itself with positive strength, and that level is positive. -/
theorem one_le_passingAt {k : Nat → F → C → Nat → C → Nat} {t : Nat} {h : F}
    (mem : h ∈ present t) (out : part h = false) (strong : 0 < k t h c t d) (stands : 0 < l t d) :
    1 ≤ passingAt part k present l t d c :=
  total_pos_of_mem (q := fun h => bif part h then 0 else
      total (steps 0 (t + 1)) fun s => k t h c s d * l s d) mem
    (Eq.subst (motive := fun b => 0 < bif b then 0 else
        total (steps 0 (t + 1)) fun s => k t h c s d * l s d) out.symm
      (total_pos_of_mem (Propagation.mem_steps_upto (Nat.le_refl t)) (Nat.mul_pos strong stands)))

/-- **Where the strength reaches zero, the coupling stops.** Where the strengths of `d` into `c` are
zero once `A` has passed, and `A` has passed by step `N`, no coupling of `d` into `c` acts from `N`
on: the coupling stops by `N` (`StopsBy`). -/
theorem stops {A N : Nat} (zero : ZeroFrom sat d c A)
    (reached : A ≤ passed part sat present l d c N) :
    StopsBy cs part (strengths part sat present l) present d c N :=
  fun u s ⟨h, _, _, le, _, pos⟩ => match Nat.lt_or_ge u N with
  | .inl early => Nat.lt_of_le_of_lt le early
  | .inr late => absurd pos (Nat.not_lt_of_le (Nat.le_of_eq
      (zero _ (Nat.le_trans reached (passed_mono late)) u h s)))

/-- So it does not recur (`StopsBy.not_recurs`). -/
theorem not_recurs {A N : Nat} (zero : ZeroFrom sat d c A)
    (reached : A ≤ passed part sat present l d c N) :
    ¬ CouplingRecurs cs part (strengths part sat present l) present d c :=
  (stops zero reached).not_recurs

/-- **Where every coupling has saturated, a finite order is exact.** Where by step `N` every coupling
has passed an amount from which its strengths are zero, order `N` is exact at every condition and
step from every start (`exact_of_reading_before`). -/
theorem exact {N : Nat}
    (all : ∀ d e, ∃ A, ZeroFrom sat d e A ∧ A ≤ passed part sat present l d e N)
    (δ : C → Nat) (t : Nat) (e : C) :
    carriedWithin cs part σ (strengths part sat present l) present δ N t e =
      carried cs part σ (strengths part sat present l) present δ t e :=
  exact_of_reading_before (fun u s d e at_ => match all d e with
    | ⟨_, zero, reached⟩ => stops zero reached u s at_) δ t e

/-- **Once saturated, nothing more passes.** Where the strengths are zero once `A` has passed and `A`
has passed by step `N`, what has passed by `N` is all that ever passes. -/
theorem passed_from {A N : Nat} (zero : ZeroFrom sat d c A)
    (reached : A ≤ passed part sat present l d c N) :
    ∀ k, passed part sat present l d c (N + k) = passed part sat present l d c N
  | 0 => rfl
  | k + 1 =>
    ((congrArg (passed part sat present l d c (N + k) + ·)
        (passingAt_zero fun h s => zero _ (Nat.le_trans reached (passed_le_add N k)) (N + k) h s)).trans
      (Nat.add_zero _)).trans (passed_from zero reached k)

/-- **What passes in all is bounded.** Where the strengths are zero once `A`, positive, has passed,
and no step passes more than `m`, what has passed is below `A + m` at every step. -/
theorem passed_lt {A m : Nat} (zero : ZeroFrom sat d c A) (pos : 0 < A)
    (most : ∀ t, passingAt part (sat (passed part sat present l d c t)) present l t d c ≤ m) :
    ∀ t, passed part sat present l d c t < A + m
  | 0 => Nat.lt_of_lt_of_le pos (Nat.le_add_right A m)
  | t + 1 => match Nat.lt_or_ge (passed part sat present l d c t) A with
    | .inl below => Nat.add_lt_add_of_lt_of_le below (most t)
    | .inr reached => Nat.lt_of_le_of_lt (Nat.le_of_eq
        ((congrArg (passed part sat present l d c t + ·)
          (passingAt_zero fun h s => zero _ reached t h s)).trans (Nat.add_zero _)))
        (passed_lt zero pos most t)

/-- **A coupling that acts until saturated climbs.** Let `P a` say the coupling is saturated once `a`
has passed, decided at every amount and kept as more passes. Where, at every step, a coupling not
yet saturated reads the level of `d` at the step itself through some formation present outside the
part with positive strength, and that level stands, at least one more passes at each step until
the coupling is saturated: by step `t`, `t` has passed or it is saturated. -/
theorem climbs {P : Nat → Prop} (decided : ∀ a, P a ∨ ¬ P a)
    (kept : ∀ a a', a ≤ a' → P a → P a')
    (acts : ∀ t a, ¬ P a → ∃ h, h ∈ present t ∧ part h = false ∧ 0 < sat a t h c t d)
    (stands : ∀ t, 0 < l t d) :
    ∀ t, t ≤ passed part sat present l d c t ∨ P (passed part sat present l d c t)
  | 0 => .inl (Nat.zero_le _)
  | t + 1 => match climbs decided kept acts stands t with
    | .inr saturated => .inr (kept _ _ (passed_le_succ t) saturated)
    | .inl upTo => match decided (passed part sat present l d c t) with
      | .inl saturated => .inr (kept _ _ (passed_le_succ t) saturated)
      | .inr open_ => match acts t _ open_ with
        | ⟨_, mem, out, strong⟩ => .inl (Nat.add_le_add upTo (one_le_passingAt mem out strong (stands t)))

/-- **A coupling that acts while unsaturated stops by its threshold.** Where the strengths of `d` into
`c` are zero once `A` has passed, while less has passed some formation present outside the part
reads the level of `d` at each step with positive strength, and that level stands at every step, `A`
has passed by step `A`, and the coupling stops by step `A`. -/
theorem stops_by {A : Nat} (zero : ZeroFrom sat d c A)
    (acts : ∀ t a, a < A → ∃ h, h ∈ present t ∧ part h = false ∧ 0 < sat a t h c t d)
    (stands : ∀ t, 0 < l t d) :
    A ≤ passed part sat present l d c A ∧
      StopsBy cs part (strengths part sat present l) present d c A :=
  have reached : A ≤ passed part sat present l d c A :=
    match climbs (P := (A ≤ ·)) (fun a => match Nat.lt_or_ge a A with
        | .inl below => .inr (Nat.not_le_of_gt below)
        | .inr reached => .inl reached)
      (fun _ _ le reached => Nat.le_trans reached le)
      (fun t a open_ => acts t a (Nat.gt_of_not_le open_)) stands A with
    | .inl reached => reached
    | .inr reached => reached
  ⟨reached, stops zero reached⟩

variable {f : Nat → Nat} {k : Nat → F → C → Nat → C → Nat}

/-- **Where the response reaches zero, the coupling stops by that amount as a step.** Let the
strengths of `d` into `c` be `f a` times `k`, `a` what has passed and `f` not rising as it grows; let
`k` read the level of `d` into `c` at each step through some formation present outside the part,
and the level of `d` stand at every step. Where `f` is zero at `A`, the coupling stops by step `A`:
by then `A` has passed, or the response is already zero. -/
theorem stops_by_zero {A : Nat} (antitone : ∀ a a', a ≤ a' → f a' ≤ f a)
    (acts : ∀ t, ∃ h, h ∈ present t ∧ part h = false ∧ 0 < k t h c t d)
    (stands : ∀ t, 0 < l t d) (zero : f A = 0) :
    StopsBy cs part (strengths part (scaled f k) present l) present d c A :=
  have climbed := climbs (sat := scaled f k) (P := (f · = 0))
    (fun a => match Nat.eq_zero_or_pos (f a) with
      | .inl zero => .inl zero
      | .inr pos => .inr fun zero => Nat.lt_irrefl 0 (Eq.subst (motive := (0 < ·)) zero pos))
    (fun a a' le zero => Nat.eq_zero_of_le_zero (Nat.le_trans (antitone a a' le) (Nat.le_of_eq zero)))
    (fun t a open_ => match acts t with
      | ⟨h, mem, out, strong⟩ => ⟨h, mem, out, Nat.mul_pos (match Nat.eq_zero_or_pos (f a) with
          | .inl zero => absurd zero open_
          | .inr pos => pos) strong⟩) stands A
  have spent : f (passed part (scaled f k) present l d c A) = 0 := match climbed with
    | .inl reached => Nat.eq_zero_of_le_zero (Nat.le_trans (antitone _ _ reached) (Nat.le_of_eq zero))
    | .inr zero => zero
  stops (A := passed part (scaled f k) present l d c A)
    (Antitone.zeroFrom (fun a a' le t h s => Nat.mul_le_mul_right (k t h c s d) (antitone a a' le))
      fun t h s => (congrArg (· * k t h c s d) spent).trans (Nat.zero_mul _))
    (Nat.le_refl _)

/-- **A coupling stops exactly where its response reaches zero.** With the premises of
`Saturation.stops_by_zero` and `d` listed, the coupling stops by some step exactly where `f` is
zero at some amount: if it stops, the strength at the stopping step is zero. -/
theorem stops_iff (antitone : ∀ a a', a ≤ a' → f a' ≤ f a) (listed : d ∈ cs)
    (acts : ∀ t, ∃ h, h ∈ present t ∧ part h = false ∧ 0 < k t h c t d)
    (stands : ∀ t, 0 < l t d) :
    (∃ N, StopsBy cs part (strengths part (scaled f k) present l) present d c N) ↔
      ∃ A, f A = 0 :=
  ⟨fun ⟨N, stopped⟩ => match Nat.eq_zero_or_pos (f (passed part (scaled f k) present l d c N)) with
    | .inl zero => ⟨_, zero⟩
    | .inr pos => match acts N with
      | ⟨h, mem, out, strong⟩ => absurd (stopped N N ⟨h, mem, out, Nat.le_refl N, listed,
          Nat.mul_pos pos strong⟩) (Nat.lt_irrefl N),
   fun ⟨A, zero⟩ => ⟨A, stops_by_zero antitone acts stands zero⟩⟩

/-- **Saturation that never reaches zero does not stop the coupling.** With the response at least one
at every amount, the coupling of `d` into `c` recurs, and at least one more passes at every step. -/
theorem floored (floor : ∀ a, 0 < f a) (listed : d ∈ cs)
    (acts : ∀ t, ∃ h, h ∈ present t ∧ part h = false ∧ 0 < k t h c t d)
    (stands : ∀ t, 0 < l t d) :
    CouplingRecurs cs part (strengths part (scaled f k) present l) present d c ∧
      ∀ t, t ≤ passed part (scaled f k) present l d c t :=
  ⟨fun N => match acts N with
    | ⟨h, mem, out, strong⟩ =>
      ⟨N, N, Nat.le_refl N, h, mem, out, Nat.le_refl N, listed, Nat.mul_pos (floor _) strong⟩,
   fun t => match climbs (sat := scaled f k) (P := fun _ => False) (fun _ => .inr id)
       (fun _ _ _ no => no)
       (fun t a _ => match acts t with
        | ⟨h, mem, out, strong⟩ => ⟨h, mem, out, Nat.mul_pos (floor a) strong⟩) stands t with
    | .inl climbed => climbed
    | .inr no => no.elim⟩

/-- **A floored self-coupling leaves every finite order inexact.** A condition coupled into itself
with a response at least one at every amount, acting at each step from a level that stands, is a
loop of a recurring coupling: chains in time order of every length end at it, so no finite order is
exact there at every step (`unbounded_of_recurring_loop`). Where the response reaches zero instead,
the coupling stops and a finite order is exact (`Saturation.exact`). -/
theorem floored_inexact (floor : ∀ a, 0 < f a) (listed : c ∈ cs)
    (acts : ∀ t, ∃ h, h ∈ present t ∧ part h = false ∧ 0 < k t h c t c)
    (stands : ∀ t, 0 < l t c) :
    ¬ ∃ J, ∀ t, ¬ CoupledIntoBy cs part (strengths part (scaled f k) present l) present (J + 1) t c :=
  unbounded_of_recurring_loop (v := fun _ => c) (m := 1) (Nat.succ_pos 0) rfl rfl
    (fun _ _ => (floored floor listed acts stands).1) (u := fun _ => c) (q := 0) rfl rfl
    (fun _ lt => absurd lt (Nat.not_lt_zero _))

/-! ### In the formed course -/

/-- A formation's gift splits into the part's gap and what each coupling of a listed condition
passes. -/
theorem carriedGive_split (k : Nat → F → C → Nat → C → Nat) (l : Nat → C → Nat) (t : Nat) (h : F)
    (e : C) :
    carriedGive cs part σ k t h e l = (bif part h then σ t h e else 0) +
      total cs fun d => bif part h then 0 else total (steps 0 (t + 1)) fun s => k t h e s d * l s d := by
  unfold carriedGive
  cases part h with
  | true => exact (Nat.add_zero _).symm.trans (congrArg (σ t h e + ·) (total_zero cs).symm)
  | false =>
    exact (total_swap (fun s d => k t h e s d * l s d) cs (steps 0 (t + 1))).trans
      (Nat.zero_add _).symm

/-- What the formations present give `e` is the part's gaps and what passes through each coupling of
a listed condition into `e`. -/
theorem total_carriedGive (k : Nat → F → C → Nat → C → Nat) (l : Nat → C → Nat) (t : Nat) (e : C) :
    total (present t) (fun h => carriedGive cs part σ k t h e l) =
      total (present t) (fun h => bif part h then σ t h e else 0) +
        total cs fun d => passingAt part k present l t d e :=
  (total_congr (fun h => carriedGive_split k l t h e) (present t)).trans
    ((total_add _ _ (present t)).trans (congrArg (_ + ·)
      (total_swap (fun h d => bif part h then 0 else
        total (steps 0 (t + 1)) fun s => k t h e s d * l s d) cs (present t))))

variable {δ : C → Nat}

/-- **What the formed course gains is what passes.** Under the carrying law with strengths saturated
by what has passed, the course at `e` grows across each step by the part's gaps and what passes
through each coupling of a listed condition into `e`: what has passed is what the course carries
through the coupling. -/
theorem course_succ (t : Nat) (e : C) :
    formedCourse cs part σ (strengths part sat present) present δ (t + 1) e =
      formedCourse cs part σ (strengths part sat present) present δ t e +
        total (present t) (fun h => bif part h then σ t h e else 0) +
        total cs fun d => passingAt part
          (sat (passed part sat present (formedCourse cs part σ (strengths part sat present) present δ)
            d e t)) present (formedCourse cs part σ (strengths part sat present) present δ) t d e :=
  (formedCourse_succ readsBefore t e).trans
    ((congrArg (_ + ·) (total_carriedGive _ _ t e)).trans (Nat.add_assoc _ _ _).symm)

/-- The formed course never falls, so a level standing at the start stands at every step. -/
theorem course_stands (start : 0 < δ d) :
    ∀ t, 0 < formedCourse cs part σ (strengths part sat present) present δ t d
  | 0 => start
  | t + 1 => Nat.lt_of_lt_of_le (course_stands start t)
      (Nat.le_trans (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_add_right _ _))
        (Nat.le_of_eq (course_succ t d).symm))

/-- **In the formed course, a coupling saturated by what it carries stops by its threshold.** Under
the carrying law with strengths saturated by what has passed, where the strengths of `d` into `c`
are zero once `A` has passed, act while less has passed, and `d` stands at the start, the coupling
stops by step `A`, and from then on nothing more passes through it. -/
theorem course_stops_by {A : Nat} (zero : ZeroFrom sat d c A)
    (acts : ∀ t a, a < A → ∃ h, h ∈ present t ∧ part h = false ∧ 0 < sat a t h c t d)
    (start : 0 < δ d) :
    StopsBy cs part (strengths part sat present
        (formedCourse cs part σ (strengths part sat present) present δ)) present d c A ∧
      ¬ CouplingRecurs cs part (strengths part sat present
        (formedCourse cs part σ (strengths part sat present) present δ)) present d c ∧
      ∀ k, passed part sat present (formedCourse cs part σ (strengths part sat present) present δ)
          d c (A + k) =
        passed part sat present (formedCourse cs part σ (strengths part sat present) present δ) d c A :=
  match stops_by zero acts (course_stands start) with
  | ⟨reached, stopped⟩ => ⟨stopped, not_recurs zero reached, passed_from zero reached⟩

/-- **In the formed course, a coupling stops exactly where its response reaches zero.** Under the
carrying law with strengths `f a` times `k`, `a` what has passed and `f` not rising, `k` reading the
level of `d`, listed, into `c` at each step through some formation present outside the part, and `d`
standing at the start, the coupling stops by some step exactly where `f` is zero at some amount
(`Saturation.stops_iff`). -/
theorem course_stops_iff (antitone : ∀ a a', a ≤ a' → f a' ≤ f a) (listed : d ∈ cs)
    (acts : ∀ t, ∃ h, h ∈ present t ∧ part h = false ∧ 0 < k t h c t d) (start : 0 < δ d) :
    (∃ N, StopsBy cs part (strengths part (scaled f k) present
        (formedCourse cs part σ (strengths part (scaled f k) present) present δ)) present d c N) ↔
      ∃ A, f A = 0 :=
  stops_iff antitone listed acts (course_stands start)

/-- **A response wearing down by what passes stops the coupling by its threshold.** In the formed
course with strengths `A - a` times `k`, `a` what has passed, `k` reading the level of `d` into `c`
at each step through some formation present outside the part, and `d` standing at the start, the
coupling stops by step `A` (`Saturation.stops_by_zero`). -/
theorem wearing_stops {A : Nat} {k : Nat → F → C → Nat → C → Nat}
    (acts : ∀ t, ∃ h, h ∈ present t ∧ part h = false ∧ 0 < k t h c t d) (start : 0 < δ d) :
    StopsBy cs part (strengths part (scaled (A - ·) k) present
      (formedCourse cs part σ (strengths part (scaled (A - ·) k) present) present δ)) present d c A :=
  stops_by_zero (fun a _ le => match le_dest le with
      | ⟨j, same⟩ => Eq.subst (motive := fun y => A - y ≤ A - a) same.symm
          (Nat.le_trans (Nat.le_of_eq (Naturals.sub_sub A a j).symm) (Nat.sub_le (A - a) j)))
    acts (course_stands start) (Nat.sub_self A)

end Saturation
