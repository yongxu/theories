import Becoming.Continuation
import Becoming.Admission
import Becoming.Witnesses
import Becoming.JointPlans

/-!
# Exclusion: what taking all that is given excludes, and the joint course that keeps all

`Becoming.Continuation` derives that where renewal is given only by formations depending on what
they renew, joint excess ends the renewal and every formation depending on the condition
(`Flow.joint_excess_ends`). Its witnesses show a renewer with two takers all ending
(`Exceeding.all_end`) and the same renewer with one taker all continuing (`Alone.all_continue`).
This module states, with no axiom and no premise beyond what each law names, what the ending of
another serves.

* **Full taking alongside another taker.** A formation *takes all that is given* to a condition
  across a step where it takes part and takes from the condition at least all that the step gives
  to it (`Flow.TakesAll`). Wherever another formation takes from the condition too, the joint
  taking then exceeds what is given (`Flow.excess_of_takesAll`). So where renewal depends on what
  it renews, a formation taking all that is given at each of `n` steps alongside another taker,
  from a level below `n + m`, ends every formation depending on the condition at a need of at
  least `m`, itself included (`Flow.full_taking_ends_at`, `Flow.full_taking_ends`, from
  `Flow.joint_excess_ends_at`).
* **The rest outruns the renewal.** Where a part (the rest) takes from a condition jointly more
  than a step gives to it, the joint taking exceeds what is given, whatever any formation outside
  the part takes (`Flow.outrun_excess`, from `Flow.rest_le_taken`); `Flow.excess_of_takesAll` is
  its case of a full taker and one other. Where renewal depends on what it renews, `n` such steps
  from a level below `n + m` leave the level below `m` from `T + n` on and end every formation
  depending on the condition at a need of at least `m`, whatever a member outside the part takes
  (`Flow.outrun_below`, `Flow.outrun_ends`). With need one, two flows in which the rest outruns
  from a level at most `n` agree on the condition from `T + n` on, so every score reading it only
  from then on scores them alike, however a member's act differs between them
  (`Flow.outrun_reading_alike`): a member's restraint is invisible to a reading after the rest's
  end, and its own take is then the only difference such a score can reward.
* **Competitive exclusion.** A full taker that continues, depending on the condition at such a
  need, leaves no other formation taking from it at each of the `W.level T c + 1` steps from any
  `T` (`Flow.continuing_excludes`). A formation active only while it takes from the condition is
  then not active at each of them (`Flow.continuing_excludes_active`); where its activity does not
  resume once it stops, it is inactive from `T + W.level T c` on (`Flow.continuing_ends_taker`).
  A formation that continues alongside another taker does not take all that is given at each of
  them (`Flow.alongside_not_all`).
* **The joint course keeps the level.** Taking jointly within what is given at every step, the
  level never falls below where it started (`Flow.level_kept`); where the formations depend on
  that condition alone, at needs it met at the start, every formation is supported at every step
  (`Flow.supported_of_within`).
* **Three courses of `Exceeding`'s members.** The renewer gives two units across each step, and
  each taker depends on the condition at need one. Where both take two at every step, all end
  from step two (`Exceeding.all_end`). In `Excluding` the first takes all that is given, the
  second takes at the first step only and then ends, and the renewer and the first are active at
  every step; the second's ending also follows from the law (`Excluding.ends_by_law`). In
  `Sharing` each takes one, jointly within what is given, all three are supported and active at
  every step, and neither takes all that is given (`Excluding.three_courses`); the second lives by
  taking there and continues, so the law needs its premise of full taking
  (`Sharing.full_taking_needed`).
* **Admission does not see the exclusion.** The levels of `Excluding` and of `Sharing` admit
  every member at every step, and each level path includes the other (`Web.Includes`), while the
  second ends in one course and continues in the other (`Excluding.admission_alike`). The
  exclusion acts through the taking, not through the levels the second needs, so a comparison of
  level paths by what they admit does not separate the two courses.

So the first's continuation does not require the second's ending: it continues in `Excluding`
and in `Sharing`, and both courses meet every dependence of its continuation. Taking all that is
given does require it: alongside a full taker that continues, a formation living by taking from
the condition ends where its activity does not resume. The witnesses stipulate the activity, as
those of `Becoming.Continuation` do, and show it consistent with balance, support and dependence;
the general laws derive the ending. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

/-- A member of `x :: l` other than `x` is a member of `l`. -/
theorem mem_of_mem_cons_ne {α : Type} {x : α} {l : List α} : ∀ {b : α}, b ∈ x :: l → b ≠ x → b ∈ l
  | _, .head _, apart => absurd rfl apart
  | _, .tail _ mem, _ => mem

/-- Two members apart count together at most the total. -/
theorem add_le_total_of_mem {α : Type} {q : α → Nat} :
    ∀ {as : List α} {a b : α}, a ≠ b → a ∈ as → b ∈ as → q a + q b ≤ total as q
  | _ :: _, _, _, apart, .head _, memB =>
    Nat.add_le_add_left (le_total_of_mem (mem_of_mem_cons_ne memB fun same => apart same.symm)) _
  | x :: _, _, b, apart, .tail _ memA, memB =>
    match b, memB, apart with
    | _, .head _, _ =>
      Nat.le_trans (Nat.le_of_eq (Nat.add_comm _ (q x))) (Nat.add_le_add_left (le_total_of_mem memA) (q x))
    | _, .tail _ memB', apart' =>
      Nat.le_trans (add_le_total_of_mem apart' memA memB') (Nat.le_add_left _ (q x))

namespace Web

variable {F C : Type} {W : Web F C}

/-- Where a formation's activity does not resume after `T` once it stops, activity at `T + s`
means activity at every step from `T` to it. -/
theorem active_before {g : F} {T j : Nat} (lasting : ∀ i, W.active (T + i + 1) g → W.active (T + i) g) :
    ∀ {s : Nat}, j ≤ s → W.active (T + s) g → W.active (T + j) g := by
  intro s le
  induction le with
  | refl => exact fun active => active
  | step _ earlier => exact fun active => earlier (lasting _ active)

end Web

namespace Flow

variable {F C : Type} {L : Flow F C} {W : Web F C}

/-- `f` *takes all that is given* to `c` across the step from `t`: it takes part, and it takes
from `c` at least all that the step gives to `c`. -/
def TakesAll (L : Flow F C) (t : Nat) (f : F) (c : C) : Prop :=
  f ∈ L.present t ∧ L.given t c ≤ L.take t f c

/-! ### The rest outruns the renewal -/

/-- **What a part takes, the step takes.** Over a list without repetition of formations, each
taking part where it takes from `c`, the part's joint take is at most what the step takes. -/
theorem rest_le_taken {t : Nat} {c : C} {rest : List F} (distinct : Distinct rest)
    (present : ∀ f, f ∈ rest → 0 < L.take t f c → f ∈ L.present t) :
    total rest (fun f => L.take t f c) ≤ L.taken t c :=
  total_le_of_support distinct present

/-- **The rest outruns the renewal, whatever any other formation takes.** Where a part (the rest)
takes from `c` across a step jointly more than the step gives to it, the joint taking exceeds what
is given, with no premise on what any formation outside the part takes. -/
theorem outrun_excess {t : Nat} {c : C} {rest : List F} (distinct : Distinct rest)
    (present : ∀ f, f ∈ rest → 0 < L.take t f c → f ∈ L.present t)
    (outruns : L.given t c < total rest fun f => L.take t f c) : L.given t c < L.taken t c :=
  Nat.lt_of_lt_of_le outruns (rest_le_taken distinct present)

/-- **Where the rest outruns a gated renewal, the condition falls below the need for good,
whatever a member takes.** Where renewal depends on what it renews, a part taking from `c` jointly
more than is given at each of `n` steps from `T`, from a level below `n + m`, leaves the level
below `m` at every step from `T + n` on. Nothing is asked of what any formation outside the part
takes: it may take nothing at every step. -/
theorem outrun_below (balances : L.Balances W) (acting : L.Acting W) (dependent : W.Dependent)
    {c : C} {m : Nat}
    (gated : ∀ t e, e ∈ L.present t → 0 < L.give t e c → W.requires t e c ∧ m ≤ W.need t e c)
    {T n : Nat} {rest : List F} (distinct : Distinct rest)
    (present : ∀ j f, j < n → f ∈ rest → 0 < L.take (T + j) f c → f ∈ L.present (T + j))
    (outruns : ∀ j, j < n → L.given (T + j) c < total rest fun f => L.take (T + j) f c)
    (start : W.level T c < n + m) : ∀ k, W.level (T + n + k) c < m :=
  stays_below balances acting dependent gated
    (Nat.lt_of_add_lt_add_left (n := n)
      (Nat.lt_of_le_of_lt
        (Nat.le_trans (Nat.le_of_eq (Nat.add_comm n _))
          (excess_bounded_at n (fun j _ => balances.on [c] (T + j))
            fun j below => outrun_excess distinct (present j · below) (outruns j below)))
        start))

/-- **Where the rest outruns a gated renewal, every dependent ends, whatever a member takes.**
Under the premises of `outrun_below`, every formation depending on `c` at a need of at least `m`
is inactive from `T + n` on, the member and the rest included. -/
theorem outrun_ends (balances : L.Balances W) (acting : L.Acting W) (dependent : W.Dependent)
    {c : C} {m : Nat}
    (gated : ∀ t e, e ∈ L.present t → 0 < L.give t e c → W.requires t e c ∧ m ≤ W.need t e c)
    {T n : Nat} {rest : List F} (distinct : Distinct rest)
    (present : ∀ j f, j < n → f ∈ rest → 0 < L.take (T + j) f c → f ∈ L.present (T + j))
    (outruns : ∀ j, j < n → L.given (T + j) c < total rest fun f => L.take (T + j) f c)
    (start : W.level T c < n + m) :
    ∀ k h, W.requires (T + n + k) h c → m ≤ W.need (T + n + k) h c → ¬ W.active (T + n + k) h :=
  fun k h requires high => ends_below_at (dependent (T + n + k) h)
    (outrun_below balances acting dependent gated distinct present outruns start k) requires high

/-- **A member's act is invisible to every reading after the rest's end** (need one). Two flows,
in each of which renewal depends on what it renews at a need of one and a part takes from `c`
jointly more than is given at each of `n` steps from `T`, from a level at most `n` there: the two
levels of `c` agree at every step from `T + n` on (both nothing), so every score of level histories
that reads `c` only from `T + n` on scores the two alike. The member's act may differ between the
flows in any way, and so may the rest's; only the rest's outrunning is asked. -/
theorem outrun_reading_alike {L' : Flow F C} {W' : Web F C}
    (balances : L.Balances W) (acting : L.Acting W) (dependent : W.Dependent)
    (balances' : L'.Balances W') (acting' : L'.Acting W') (dependent' : W'.Dependent) {c : C}
    (gated : ∀ t e, e ∈ L.present t → 0 < L.give t e c → W.requires t e c ∧ 1 ≤ W.need t e c)
    (gated' : ∀ t e, e ∈ L'.present t → 0 < L'.give t e c → W'.requires t e c ∧ 1 ≤ W'.need t e c)
    {T n : Nat} {rest rest' : List F} (distinct : Distinct rest) (distinct' : Distinct rest')
    (present : ∀ j f, j < n → f ∈ rest → 0 < L.take (T + j) f c → f ∈ L.present (T + j))
    (present' : ∀ j f, j < n → f ∈ rest' → 0 < L'.take (T + j) f c → f ∈ L'.present (T + j))
    (outruns : ∀ j, j < n → L.given (T + j) c < total rest fun f => L.take (T + j) f c)
    (outruns' : ∀ j, j < n → L'.given (T + j) c < total rest' fun f => L'.take (T + j) f c)
    (start : W.level T c < n + 1) (start' : W'.level T c < n + 1)
    {score : (Nat → C → Nat) → Nat}
    (reads : ∀ l l', (∀ k, l (T + n + k) c = l' (T + n + k) c) → score l = score l') :
    score W.level = score W'.level :=
  reads _ _ fun k =>
    (Nat.eq_zero_of_le_zero (Nat.le_of_lt_succ
      (outrun_below balances acting dependent gated distinct present outruns start k))).trans
    (Nat.eq_zero_of_le_zero (Nat.le_of_lt_succ
      (outrun_below balances' acting' dependent' gated' distinct' present' outruns' start' k))).symm

/-- **Alongside a formation taking all that is given, any other taker makes the joint taking
exceed what is given.** -/
theorem excess_of_takesAll {t : Nat} {f g : F} {c : C} (apart : f ≠ g) (all : L.TakesAll t f c)
    (present : g ∈ L.present t) (takes : 0 < L.take t g c) : L.given t c < L.taken t c :=
  have single : ∀ {e : F}, e ∈ [g] → e = g := fun mem => match mem with
    | .head _ => rfl
    | .tail _ nm => nomatch nm
  outrun_excess (rest := [f, g])
    ⟨fun mem => apart (single mem), (⟨fun mem => (nomatch mem), trivial⟩ : Distinct [g])⟩
    (fun _ mem _ => match mem with
      | .head _ => all.1
      | .tail _ other => (single other) ▸ present)
    (Nat.lt_of_lt_of_le (Nat.lt_of_le_of_lt all.2 (Nat.lt_add_of_pos_right takes))
      (Nat.le_of_eq (congrArg (L.take t f c + ·) (Nat.add_zero _).symm)))

/-- **Full taking alongside another taker ends every dependent, at the steps it uses.** With
balance at the condition across the first `n + k` steps from `T`, whatever gives to it there
depending on it at a need of at least `m` and supported: where `f` takes all that is given to `c`
at each of `n` steps from `T` and another formation takes from it at each of them, starting below
`n + m`, a formation depending on `c` at a need of at least `m` is inactive at `T + n + k`, where
it is active only while supported; `f` among them. -/
theorem full_taking_ends_at {c : C} {m T n k : Nat} {f g h : F} (apart : f ≠ g)
    (balances : ∀ j, j < n + k → L.BalancesOn W [c] (T + j))
    (gated : ∀ j e, j < n + k → e ∈ L.present (T + j) → 0 < L.give (T + j) e c →
      W.requires (T + j) e c ∧ m ≤ W.need (T + j) e c)
    (givers : ∀ j, j < n + k → L.GiversSupported W (T + j) c)
    (all : ∀ j, j < n → L.TakesAll (T + j) f c)
    (other : ∀ j, j < n → g ∈ L.present (T + j) ∧ 0 < L.take (T + j) g c)
    (start : W.level T c < n + m)
    (dependent : W.active (T + n + k) h → W.Supported (T + n + k) h) :
    W.requires (T + n + k) h c → m ≤ W.need (T + n + k) h c → ¬ W.active (T + n + k) h :=
  joint_excess_ends_at balances gated givers
    (fun j below => excess_of_takesAll apart (all j below) (other j below).1 (other j below).2) start
    dependent

/-- **Full taking alongside another taker ends every dependent.** Where renewal depends on what
it renews: if `f` takes all that is given to `c` at each of `n` steps from `T` and another
formation takes from it at each of them, starting below `n + m`, every formation depending on `c`
at a need of at least `m` is inactive from `T + n` on, `f` included. -/
theorem full_taking_ends (balances : L.Balances W) (acting : L.Acting W) (dependent : W.Dependent)
    {c : C} {m : Nat}
    (gated : ∀ t e, e ∈ L.present t → 0 < L.give t e c → W.requires t e c ∧ m ≤ W.need t e c)
    {T n : Nat} {f g : F} (apart : f ≠ g) (all : ∀ j, j < n → L.TakesAll (T + j) f c)
    (other : ∀ j, j < n → g ∈ L.present (T + j) ∧ 0 < L.take (T + j) g c)
    (start : W.level T c < n + m) :
    ∀ k h, W.requires (T + n + k) h c → m ≤ W.need (T + n + k) h c → ¬ W.active (T + n + k) h :=
  joint_excess_ends balances acting dependent gated
    (fun j below => excess_of_takesAll apart (all j below) (other j below).1 (other j below).2) start

/-- **Competitive exclusion: a full taker that continues leaves no other taking alongside it.**
Where renewal depends on what it renews and `f` takes all that is given to `c` at every step,
depends on it at a need of at least `m` and is active at every step, no other formation takes
from `c` at each of the `W.level T c + 1` steps from any `T`. -/
theorem continuing_excludes (balances : L.Balances W) (acting : L.Acting W) (dependent : W.Dependent)
    {c : C} {m : Nat}
    (gated : ∀ t e, e ∈ L.present t → 0 < L.give t e c → W.requires t e c ∧ m ≤ W.need t e c)
    {f g : F} (apart : f ≠ g) (all : ∀ t, L.TakesAll t f c)
    (needs : ∀ t, W.requires t f c ∧ m ≤ W.need t f c) (continues : ∀ t, W.active t f) (T : Nat) :
    ¬ ∀ j, j < W.level T c + 1 → g ∈ L.present (T + j) ∧ 0 < L.take (T + j) g c :=
  fun other => full_taking_ends balances acting dependent gated apart (fun j _ => all (T + j)) other
    (Nat.lt_of_lt_of_le (Nat.lt_succ_self _) (Nat.le_add_right _ m)) 0 f (needs _).1 (needs _).2
    (continues _)

/-- **A formation living by taking does not stay active alongside a full taker that continues.**
Under the premises of `continuing_excludes`, a formation active only while it takes from `c` is
not active at each of the `W.level T c + 1` steps from any `T`. -/
theorem continuing_excludes_active (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) {c : C} {m : Nat}
    (gated : ∀ t e, e ∈ L.present t → 0 < L.give t e c → W.requires t e c ∧ m ≤ W.need t e c)
    {f g : F} (apart : f ≠ g) (all : ∀ t, L.TakesAll t f c)
    (needs : ∀ t, W.requires t f c ∧ m ≤ W.need t f c) (continues : ∀ t, W.active t f)
    (lives : ∀ t, W.active t g → g ∈ L.present t ∧ 0 < L.take t g c) (T : Nat) :
    ¬ ∀ j, j < W.level T c + 1 → W.active (T + j) g :=
  fun active => continuing_excludes balances acting dependent gated apart all needs continues T
    (fun j below => lives _ (active j below))

/-- **Alongside a full taker that continues, a formation living by taking ends.** Under the
premises of `continuing_excludes`, a formation active only while it takes from `c`, whose activity
does not resume after `T` once it stops, is inactive from `T + W.level T c` on. -/
theorem continuing_ends_taker (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) {c : C} {m : Nat}
    (gated : ∀ t e, e ∈ L.present t → 0 < L.give t e c → W.requires t e c ∧ m ≤ W.need t e c)
    {f g : F} (apart : f ≠ g) (all : ∀ t, L.TakesAll t f c)
    (needs : ∀ t, W.requires t f c ∧ m ≤ W.need t f c) (continues : ∀ t, W.active t f)
    (lives : ∀ t, W.active t g → g ∈ L.present t ∧ 0 < L.take t g c) {T : Nat}
    (lasting : ∀ j, W.active (T + j + 1) g → W.active (T + j) g) :
    ∀ k, ¬ W.active (T + (W.level T c + k)) g :=
  fun k active => continuing_excludes_active balances acting dependent gated apart all needs
    continues lives T fun _ below =>
      Web.active_before lasting (Nat.le_trans (Nat.le_of_lt_succ below) (Nat.le_add_right _ k)) active

/-- **Continuing alongside another taker is not taking all that is given.** Where renewal depends
on what it renews and another formation takes from `c` at every step, a formation depending on
`c` at a need of at least `m` and active at every step does not take all that is given at each
of the `W.level T c + 1` steps from any `T`. -/
theorem alongside_not_all (balances : L.Balances W) (acting : L.Acting W) (dependent : W.Dependent)
    {c : C} {m : Nat}
    (gated : ∀ t e, e ∈ L.present t → 0 < L.give t e c → W.requires t e c ∧ m ≤ W.need t e c)
    {f g : F} (apart : f ≠ g) (other : ∀ t, g ∈ L.present t ∧ 0 < L.take t g c)
    (needs : ∀ t, W.requires t f c ∧ m ≤ W.need t f c) (continues : ∀ t, W.active t f) (T : Nat) :
    ¬ ∀ j, j < W.level T c + 1 → L.TakesAll (T + j) f c :=
  fun all => full_taking_ends balances acting dependent gated apart all (fun j _ => other (T + j))
    (Nat.lt_of_lt_of_le (Nat.lt_succ_self _) (Nat.le_add_right _ m)) 0 f (needs _).1 (needs _).2
    (continues _)

/-- **The joint course keeps the level.** Taking jointly within what is given at every step, the
level never falls below where it started. -/
theorem level_kept (balances : L.Balances W) {c : C} (within : ∀ t, L.WithinJoint t c) :
    ∀ t, W.level 0 c ≤ W.level t c
  | 0 => Nat.le_refl _
  | t + 1 => Nat.le_trans (level_kept balances within t) (joint_keeps balances (within t))

/-- A list with no member twice is a list without repetition. -/
theorem distinct_of_nodup {α : Type} : ∀ {l : List α}, l.Nodup → Distinct l
  | [], _ => trivial
  | a :: _, .cons fresh rest => ⟨fun mem => fresh a mem rfl, distinct_of_nodup rest⟩

/-- **Division by exclusive footprints keeps the joint draw within what is given.** Where what the
formations take from `c` across the step is what the leaves of a plan draw on, the plan realized
at a whole each of whose parts' footprints lies within its whole's and shares nothing with the
other part's, and the root's footprint lies within a list of units no longer than what is given
to `c`, the joint draw is within what is given. -/
theorem withinJoint_of_plan {S R : Type} {footprint : S → R → Prop} {J : S → S → S → Prop}
    (within : PartsWithin footprint J) (apart : PartsApart footprint J) (p : JointPlan (List R))
    {s : S} (realizes : JointPlan.Realizes J (Supports footprint) s p) {avail : List R}
    (root : ∀ a, footprint s a → a ∈ avail) {t : Nat} {c : C}
    (drawn : L.taken t c = p.draws.length) (given : avail.length ≤ L.given t c) : L.WithinJoint t c :=
  match JointPlan.supports_of_realizes within apart p s realizes with
  | ⟨distinct, inside⟩ => Nat.le_trans (Nat.le_of_eq drawn)
      (Nat.le_trans (length_le_of_sub (distinct_of_nodup distinct) fun a mem => root a (inside a mem))
        given)

/-- **So the level stands.** Under balance, where at every step the joint draw on `c` is such a
division, the level of `c` never falls below its start: 群分 keeps what it shares. -/
theorem level_kept_of_plans (balances : L.Balances W) {S R : Type} {footprint : S → R → Prop}
    {J : S → S → S → Prop} (within : PartsWithin footprint J) (apart : PartsApart footprint J)
    {c : C} (plans : ∀ t, ∃ (p : JointPlan (List R)) (s : S) (avail : List R),
      JointPlan.Realizes J (Supports footprint) s p ∧ (∀ a, footprint s a → a ∈ avail) ∧
      L.taken t c = p.draws.length ∧ avail.length ≤ L.given t c) :
    ∀ t, W.level 0 c ≤ W.level t c :=
  level_kept balances fun t => match plans t with
    | ⟨p, _, _, realizes, root, drawn, given⟩ =>
      withinJoint_of_plan within apart p realizes root drawn given

/-- **The joint course keeps every formation supported** where the formations depend on that
condition alone, at needs it met at the start. -/
theorem supported_of_within (balances : L.Balances W) {c : C} (within : ∀ t, L.WithinJoint t c)
    (only : ∀ t e d, W.requires t e d → d = c)
    (low : ∀ t e, W.requires t e c → W.need t e c ≤ W.level 0 c) : ∀ t e, W.Supported t e :=
  fun t e d requires => match d, only t e d requires, requires with
    | _, rfl, requires => Nat.le_trans (low t e requires) (level_kept balances within t)

end Flow

/-! ## Three courses of `Exceeding`'s members -/

namespace Excluding

open Exceeding (Member)

def level : Nat → Nat := Witnesses.profile [4] 2

def present : Nat → List Member
  | 0 => [.renewer, .first, .second]
  | _ + 1 => [.renewer, .first]

/-- The renewer gives two units across each step, and each taker takes two while it takes part;
the second takes part at the first step only. -/
def flow : Flow Member Unit := Witnesses.relay present 2 2 2

/-- Each depends on the condition at need one, the renewer included; the second is active at
the first step only. -/
def web : Web Member Unit := Witnesses.relayWeb level fun t f => match f with
  | .renewer => True
  | .first => True
  | .second => t = 0

theorem balances : flow.Balances web
  | 0, () => rfl
  | _ + 1, () => rfl

theorem acting : flow.Acting web
  | _, .renewer, _, _, _ => trivial
  | _, .first, _, _, gives => absurd gives (Nat.lt_irrefl 0)
  | _, .second, _, _, gives => absurd gives (Nat.lt_irrefl 0)

theorem level_two : ∀ t, 2 ≤ level t
  | 0 => Nat.succ_le_succ (Nat.succ_le_succ (Nat.zero_le 2))
  | _ + 1 => Nat.le_refl 2

theorem dependent : web.Dependent :=
  fun t _ _ _ _ => Nat.le_trans (Nat.le_succ 1) (level_two t)

theorem gated : ∀ t f, f ∈ flow.present t → 0 < flow.give t f () →
    web.requires t f () ∧ 1 ≤ web.need t f () :=
  fun _ _ _ _ => ⟨trivial, Nat.le_refl 1⟩

/-- The first takes all that is given at every step. -/
theorem takes_all : ∀ t, flow.TakesAll t .first ()
  | 0 => ⟨.tail _ (.head _), Nat.le_refl 2⟩
  | _ + 1 => ⟨.tail _ (.head _), Nat.le_refl 2⟩

/-- The renewer and the first are active at every step; the second takes at the first step and
then ends. -/
theorem continues :
    ∀ t, web.active t .renewer ∧ web.active t .first ∧ ¬ web.active (t + 1) .second :=
  fun _ => ⟨trivial, trivial, fun zero => Nat.noConfusion zero⟩

/-- The second takes part and takes at the first step, as in `Exceeding`, which agrees with this
course at that step. -/
theorem first_step : web.active 0 .second ∧ .second ∈ flow.present 0 ∧ 0 < flow.take 0 .second () ∧
    present 0 = Exceeding.present 0 ∧ level 0 = Exceeding.level 0 ∧ level 1 = Exceeding.level 1 :=
  ⟨rfl, .tail _ (.tail _ (.head _)), Nat.zero_lt_succ 1, rfl, rfl, rfl⟩

/-- The second is active only while it takes from the condition. -/
theorem second_lives : ∀ t, web.active t .second → .second ∈ flow.present t ∧ 0 < flow.take t .second ()
  | 0, _ => ⟨.tail _ (.tail _ (.head _)), Nat.zero_lt_succ 1⟩
  | _ + 1, active => absurd active fun zero => Nat.noConfusion zero

/-- The second's activity does not resume once it stops. -/
theorem second_lasting : ∀ j, web.active (0 + j + 1) .second → web.active (0 + j) .second :=
  fun _ zero => Nat.noConfusion zero

/-- **The second's ending also follows from the law**: alongside the first, which takes all that
is given and continues, the second, living by taking, is inactive from step four on. -/
theorem ends_by_law : ∀ k, ¬ web.active (0 + (web.level 0 () + k)) .second :=
  Flow.continuing_ends_taker (f := .first) (g := .second) balances acting dependent gated
    (fun same => nomatch same) takes_all
    (fun _ => ⟨trivial, Nat.le_refl 1⟩) (fun t => (continues t).2.1) second_lives second_lasting

end Excluding

namespace Sharing

open Exceeding (Member)

/-- The renewer gives two units across each step, and each taker takes one. -/
def flow : Flow Member Unit where
  present _ := [.renewer, .first, .second]
  take _ f _ := match f with
    | .renewer => 0
    | .first => 1
    | .second => 1
  give _ f _ := match f with
    | .renewer => 2
    | .first => 0
    | .second => 0

/-- Each depends on the condition at need one, and all three are active at every step. -/
def web : Web Member Unit where
  level _ _ := 4
  active _ _ := True
  requires _ _ _ := True
  need _ _ _ := 1
  draws _ f _ := match f with
    | .renewer => False
    | .first => True
    | .second => True

theorem balances : flow.Balances web := fun _ _ => rfl

theorem within : ∀ t, flow.WithinJoint t () := fun _ => Nat.le_refl 2

/-- Support is derived from the joint course: the level is kept, and every need was met at the
start. -/
theorem dependent : web.Dependent :=
  fun t f _ => Flow.supported_of_within balances within (fun _ _ _ _ => rfl)
    (fun _ _ _ => Nat.succ_le_succ (Nat.zero_le 3)) t f

/-- Neither taker takes all that is given. -/
theorem neither_all : ∀ t, ¬ flow.TakesAll t .first () ∧ ¬ flow.TakesAll t .second () :=
  fun _ => ⟨fun all => Nat.not_succ_le_self 1 all.2, fun all => Nat.not_succ_le_self 1 all.2⟩

/-- **The law needs its premise of full taking.** Here the second is active only while it takes
from the condition, its activity never stops, and the first and the second are active at every
step. -/
theorem full_taking_needed :
    (∀ t, web.active t .second → .second ∈ flow.present t ∧ 0 < flow.take t .second ()) ∧
    (∀ t, web.active t .first ∧ web.active t .second) :=
  ⟨fun _ _ => ⟨.tail _ (.tail _ (.head _)), Nat.zero_lt_succ 0⟩, fun _ => ⟨trivial, trivial⟩⟩

end Sharing

namespace Excluding

/-- At every step the levels of `Excluding` admit every member. -/
theorem admits_all : ∀ t f, web.Admits (web.level t) t f :=
  fun t _ _ _ => Nat.le_trans (Nat.le_succ 1) (level_two t)

/-- **Admission does not see the exclusion.** The level paths of `Excluding` and of `Sharing` each
include the other: at every step both admit every member, the second included. Yet the second is
inactive in `Excluding` from step one, and active at every step in `Sharing`. -/
theorem admission_alike :
    web.Includes Sharing.web.level web.level ∧ web.Includes web.level Sharing.web.level ∧
    (∀ t f, web.Admits (web.level t) t f) ∧ ¬ web.active 1 .second ∧
    (∀ t, Sharing.web.active t .second) :=
  ⟨fun _ _ _ _ _ => Nat.succ_le_succ (Nat.zero_le 3), fun t f _ => admits_all t f, admits_all,
   fun zero => Nat.noConfusion zero, fun _ => trivial⟩

/-- **Three courses of the same members.** Where both takers take two at every step they take
part, all end from step two (`Exceeding`). Where the first takes all that is given and the second
ends after the first step, the renewer and the first are active at every step (`Excluding`).
Where each takes one, the joint taking is within what is given, all three are supported and
active at every step, and neither takes all that is given (`Sharing`). -/
theorem three_courses :
    (∀ n f, ¬ Exceeding.web.active (2 + n) f) ∧
    (flow.Balances web ∧ web.Dependent ∧
      ∀ t, flow.TakesAll t .first () ∧ web.active t .renewer ∧ web.active t .first ∧
        ¬ web.active (t + 1) .second) ∧
    (Sharing.flow.Balances Sharing.web ∧ Sharing.web.Dependent ∧
      ∀ t, Sharing.flow.WithinJoint t () ∧ (∀ f, Sharing.web.active t f) ∧
        ¬ Sharing.flow.TakesAll t .first ()) :=
  ⟨Exceeding.all_end, ⟨balances, dependent, fun t => ⟨takes_all t, continues t⟩⟩,
   ⟨Sharing.balances, Sharing.dependent, fun t => ⟨Sharing.within t, fun _ => trivial,
     (Sharing.neither_all t).1⟩⟩⟩

end Excluding

end Becoming
