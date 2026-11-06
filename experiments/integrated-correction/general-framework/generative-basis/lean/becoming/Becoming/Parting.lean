import Becoming.Distinguishing
import Becoming.Lasting

/-!
# Parting: what a prefix fixes where the course branches

`Becoming.Identification` states what a bounded prefix fixes under a determined law: the
course through a map of a world of `N` configurations is fixed by its prefix before `N + N - 1`,
and no earlier step serves every such world. A process of the spine fixes only which steps are
admissible, and from one configuration its runs can go different ways. This module states,
with no premise beyond what each law names, what a prefix fixes along the runs of any process.

* **At a parting no extrapolation is right on both.** Two runs part at a step where their
  courses through the map are the same before it and differ at it (`PartAt`). Their prefixes
  before the step are one prefix, so no extrapolation, whatever it is given, the process
  included, is right at that step on both (`not_right_on_both`). An extrapolation right at every
  step from `T` on, on every run from a configuration, leaves no two of those runs parting at
  any step from `T` on (`not_parting_of_right`). With the values through the map decided, no two
  runs from a configuration part exactly where all of them have one course through the map
  (`unparted_iff`).
* **Where runs do not part, the bound carries.** Not parting is kept along runs: from every
  configuration a run from an unparted configuration reaches, no two runs part either
  (`Unparted.along`, by joining runs at a step, `joinAt`). So on a run from a configuration
  from which no two runs part, held by a list of `N` configurations, the course through the map
  has at most `N` states (`course_statesBelow`), and the extrapolation by the least bound of
  `Becoming.Identification`, given nothing, is right at every step from `N + N - 1` on
  (`leastBound_right`). No extrapolation is right at step `N + N - 2` on every such run for `N ≥ 2`
  (`rest_earliest_runs`): the step is exact for processes as for laws. A determined process
  with one move parts nowhere (`unparted_of_determined`), so the determined case is the
  instance; a process can branch and part nowhere where its branching does not show through the
  map (`free_unparted_const`).
* **Where runs part only before a step, the bound carries from there.** If no two runs from a
  configuration part at any step from `T` on, the values through the map decided, then no two
  runs part from where a run from it is at `T` (`unparted_at_of_late`). Held by a list of `N`
  configurations, its course through the map then has at most `T + N` states (`late_statesBelow`,
  through `statesBelow_shift`). The extrapolation by the least bound is right at every step from
  `2(T + N) - 1` on (`late_right`).
* **Where no two runs part, an extrapolation built from the process is right.** Take a process
  with listed moves and configurations, decided steps and decided values through the map. The
  extrapolation built from the process, its listed moves and configurations and the start
  (`fromProcess`) reads off the prefix the configurations a run from `s` can be at
  (`candidates`). It keeps the first from which a path as long as the list of configurations is
  open (`live`, `firstLive`), and such a path goes on without end (`live_persists`, `liveRun`):
  `live` is `Lasting.Continues` decided (`live_iff_continues`), and where a list of `N` holds
  every configuration a course of `N` steps makes its start unbounded, with no decidability and
  no selection (`continues_persists`, `unbounded_of_continues`), where `Lasting`'s lifting for
  finite branching holds up to double negation.
  It proposes that configuration's value through the map. It is right at step `t` on every run
  from `s` exactly where no two runs from `s` part at `t` (`world_right_iff`). So some
  extrapolation is right there exactly where none part (`some_right_iff`): with
  `not_right_on_both`, at each step a parting is exactly what neither the prefix nor the process
  settles.
* **Where runs part, nothing bounds the course.** Under free branching, every configuration
  may follow every configuration (`free`), every course is the course of a run through a map
  (`freeRun`). So after every prefix two runs of two configurations part, each with that prefix
  (`free_parts_after`): no prefix shows that a world will not part. For every extrapolation and
  every prefix, a run of free branching on two values has that prefix and the extrapolation is not
  right at the next step (`free_open`); for every extrapolation, one run is never right at any
  step (`free_never_right`); and a run of free branching on two configurations has a course
  through the map with no bound on its states (`free_unbounded`).

So with a bound on configurations a prefix fixes the course through the map exactly as far as the
runs do not part, from `N + N - 1` on; where they part, neither the prefix nor the law fixes
which way the run goes. Ren, 16 October 2026: "we are describing what everything obeys, but at
every moment, the actual change depends on the situation", and "the situation makes it true".
Read so, a law that branches leaves open what the situation fixes: with the situation as the
move, the law is determined (`Becoming.Situations`). Ren took this reading on 16 October 2026.

**Classical sources.** That for every extrapolation some course is missed at every step
(`free_never_right`) is Gold's (1967) diagonal against identifying every sequence in the limit;
the bound `N + N - 1` and its exactness carry over Moore's (1956) bound for distinguishing
experiments, through `Becoming.Identification`, from determined laws to runs that do not part.
-/

namespace Becoming

open Generative

universe u v w

namespace Parting

section Runs

variable {S : Type u} {A : Type v} {P : Process S A}

/-- The run from step `k` on: `Run.onward` of `Becoming.Branching`, kept under this name
(`after_eq_onward`). -/
def after (r : Run P) (k : Nat) : Run P :=
  r.onward k

/-- `after` is `Run.onward`, by definition. -/
theorem after_eq_onward (r : Run P) (k : Nat) : after r k = r.onward k :=
  rfl

/-- A run preceded by one admissible step into its start. -/
def before (s : S) (a : A) (r : Run P) (into : P.step s a (r.state 0)) : Run P :=
  ⟨fun | 0 => s | t + 1 => r.state t, fun | 0 => a | t + 1 => r.act t,
    fun | 0 => into | t + 1 => r.step t⟩

/-- **Joining runs at a step.** The run `r` up to step `k`, then the run `r'` from where `r` is
at `k`; it begins where `r` begins. -/
def joinAt : (k : Nat) → (r r' : Run P) → r'.state 0 = r.state k →
    {q : Run P // q.state 0 = r.state 0}
  | 0, _, r', meet => ⟨r', meet⟩
  | k + 1, r, r', meet =>
    let q := joinAt k (after r 1) r' (meet.trans (congrArg r.state (Nat.add_comm k 1)))
    ⟨before (r.state 0) (r.act 0) q.1
      (Eq.subst (motive := fun x => P.step (r.state 0) (r.act 0) x) q.2.symm (r.step 0)), rfl⟩

/-- Up to step `k` the joined run is `r`. -/
theorem joinAt_before : ∀ (k : Nat) (r r' : Run P) (meet : r'.state 0 = r.state k) (n : Nat),
    n ≤ k → (joinAt k r r' meet).1.state n = r.state n
  | 0, _, _, meet, 0, _ => meet
  | 0, _, _, _, _ + 1, le => absurd le (Nat.not_succ_le_zero _)
  | _ + 1, _, _, _, 0, _ => rfl
  | k + 1, r, r', meet, n + 1, le =>
    (joinAt_before k (after r 1) r' (meet.trans (congrArg r.state (Nat.add_comm k 1))) n
      (Nat.le_of_succ_le_succ le)).trans (congrArg r.state (Nat.add_comm 1 n))

/-- From step `k` on the joined run is `r'`. -/
theorem joinAt_after : ∀ (k : Nat) (r r' : Run P) (meet : r'.state 0 = r.state k) (n : Nat),
    (joinAt k r r' meet).1.state (k + n) = r'.state n
  | 0, _, r', _, n => congrArg r'.state (Nat.zero_add n)
  | k + 1, r, r', meet, n =>
    (congrArg (joinAt (k + 1) r r' meet).1.state (Nat.succ_add k n)).trans
      (joinAt_after k (after r 1) r' (meet.trans (congrArg r.state (Nat.add_comm k 1))) n)

end Runs

/-! ## At a parting no extrapolation is right on both -/

section Part

variable {S : Type u} {A : Type v} {R : Type w} {P : Process S A}

/-- The course of a run through the map. -/
def course (reg : S → R) (r : Run P) : Nat → R := fun n => reg (r.state n)

/-- Two runs part at step `t`: through the map they are the same before `t` and differ at `t`. -/
def PartAt (reg : S → R) (r r' : Run P) (t : Nat) : Prop :=
  (∀ n, n < t → reg (r.state n) = reg (r'.state n)) ∧ reg (r.state t) ≠ reg (r'.state t)

/-- No two runs from `s` part: every two runs from `s` have one course through the map. -/
def Unparted (P : Process S A) (reg : S → R) (s : S) : Prop :=
  ∀ r r' : Run P, r.state 0 = s → r'.state 0 = s → ∀ n, reg (r.state n) = reg (r'.state n)

/-- The extrapolation `pred`, from the prefix before `t` of `r`'s course through the map,
proposes the value through the map at `t`. -/
def RightAt (pred : List R → Option R) (reg : S → R) (r : Run P) (t : Nat) : Prop :=
  pred (Learning.prefixOf (course reg r) t) = some (reg (r.state t))

/-- **At a parting no extrapolation is right on both.** The two prefixes before the step are one
prefix, whatever the extrapolation is given. -/
theorem not_right_on_both (pred : List R → Option R) {reg : S → R} {r r' : Run P} {t : Nat}
    (part : PartAt reg r r' t) : ¬ (RightAt pred reg r t ∧ RightAt pred reg r' t) :=
  fun ⟨right, right'⟩ =>
    have same : Learning.prefixOf (course reg r) t = Learning.prefixOf (course reg r') t :=
      Learning.prefix_congr part.1
    part.2 (Option.some.inj (right.symm.trans ((congrArg pred same).trans right')))

/-- An extrapolation right at every step from `T` on, on every run from `s`, leaves no two of those
runs parting at any step from `T` on. -/
theorem not_parting_of_right {pred : List R → Option R} {reg : S → R} {s : S} {T : Nat}
    (right : ∀ r : Run P, r.state 0 = s → ∀ t, T ≤ t → RightAt pred reg r t)
    (r r' : Run P) (start : r.state 0 = s) (start' : r'.state 0 = s) {t : Nat} (late : T ≤ t) :
    ¬ PartAt reg r r' t :=
  fun part => not_right_on_both pred part ⟨right r start t late, right r' start' t late⟩

/-- **No two runs from a configuration part exactly where all of them have one course through
the map.** -/
theorem unparted_iff [DecidableEq R] {reg : S → R} {s : S} :
    Unparted P reg s ↔
      ∀ r r' : Run P, r.state 0 = s → r'.state 0 = s → ∀ t, ¬ PartAt reg r r' t :=
  ⟨fun unparted r r' start start' t part => part.2 (unparted r r' start start' t),
   fun none r r' start start' =>
     Identification.below_all fun m agree =>
       match decEq (reg (r.state m)) (reg (r'.state m)) with
       | isTrue same => same
       | isFalse differ => absurd ⟨agree, differ⟩ (none r r' start start' m)⟩

end Part

/-! ## Where runs do not part, the bound carries -/

section Carries

variable {S : Type u} {A : Type v} {R : Type w} {P : Process S A}

/-- **Not parting is kept along runs.** From every configuration that a run from an unparted
configuration reaches, no two runs part either. -/
theorem Unparted.along {reg : S → R} {s : S} (unparted : Unparted P reg s) {r : Run P}
    (start : r.state 0 = s) (k : Nat) : Unparted P reg (r.state k) :=
  fun q q' from_q from_q' n =>
    have agree := unparted (joinAt k r q from_q).1 (joinAt k r q' from_q').1
      ((joinAt k r q from_q).2.trans start) ((joinAt k r q' from_q').2.trans start) (k + n)
    ((congrArg reg (joinAt_after k r q from_q n)).symm.trans agree).trans
      (congrArg reg (joinAt_after k r q' from_q' n))

/-- **Where runs do not part, the course has at most as many states as there are
configurations.** On a run from a configuration from which no two runs part, held by a list,
the course through the map has at most as many states as the list has members. -/
theorem course_statesBelow {reg : S → R} {s : S} (unparted : Unparted P reg s) {r : Run P}
    (start : r.state 0 = s) {l : List S} (held : ∀ n, r.state n ∈ l) :
    StatesBelow (course reg r) l.length :=
  match revisits_within l r.state (fun n _ => held n) with
  | ⟨i, j, lt, within, same⟩ =>
    have ahead : SameAhead (course reg r) i j :=
      unparted.along start i (after r i) (after r j) rfl same.symm
    Identification.statesBelow_mono (statesBelow_of_same lt ahead) within

/-- **An extrapolation given nothing rests from `N + N - 1` on.** On a run from a
configuration from which no two runs part, held by a list of `N` configurations, the
extrapolation by the least bound is
right at every step from `N + N - 1` on. -/
theorem leastBound_right [DecidableEq R] {reg : S → R} {s : S} (unparted : Unparted P reg s)
    {r : Run P} (start : r.state 0 = s) {l : List S} (held : ∀ n, r.state n ∈ l) {t : Nat}
    (late : l.length + l.length - 1 ≤ t) : RightAt Identification.leastBound reg r t :=
  Identification.leastBound_exact (course_statesBelow unparted start held) late

/-- Two runs of a determined process with one move from one configuration are one course of
configurations. -/
theorem states_agree {P : Process S Unit} (determined : Determined P) {r r' : Run P}
    (start : r.state 0 = r'.state 0) : ∀ n, r.state n = r'.state n
  | 0 => start
  | n + 1 =>
    determined (r.state n) () (r.state (n + 1)) (r'.state (n + 1)) (r.step n)
      (Eq.subst (motive := fun x => P.step x () (r'.state (n + 1)))
        (states_agree determined start n).symm (r'.step n))

/-- **A determined process with one move parts nowhere.** -/
theorem unparted_of_determined {P : Process S Unit} (determined : Determined P) (reg : S → R)
    (s : S) : Unparted P reg s :=
  fun _ _ start start' n => congrArg reg (states_agree determined (start.trans start'.symm) n)

/-- **The step is exact for processes.** Given two values, no extrapolation is right at step
`N + N - 2` on every run, from a configuration from which no two runs part, of every process of
`N = M + 2` configurations. -/
theorem rest_earliest_runs {x y : R} (two : x ≠ y) (pred : List R → Option R) (M : Nat) :
    ¬ ∀ (P : Process (Fin (M + 2)) Unit) (reg : Fin (M + 2) → R) (r : Run P),
      Unparted P reg (r.state 0) → RightAt pred reg r (M + M + 2) :=
  fun all => Identification.rest_earliest two pred M fun _ bound =>
    match Law.realized_within bound with
    | ⟨next, reg, s, reads⟩ =>
      have right := all (Law.process next) reg
        ⟨Law.orbit next s, fun _ => (), fun _ => rfl⟩
        (unparted_of_determined (show Determined (Law.process next) from
          fun s _ t t' (first : t = next s) (second : t' = next s) => first.trans second.symm)
          reg _)
      (congrArg pred (Learning.prefix_congr fun n _ => (reads n).symm)).trans
        (right.trans (congrArg some (reads (M + M + 2))))

end Carries

/-! ## Where runs part only before a step -/

section Late

variable {S : Type u} {A : Type v} {R : Type w} {P : Process S A}

/-- **Not parting from `T` on leaves the configuration at `T` unparted.** If no two runs from `s`
part at any step from `T` on, no two runs from where a run from `s` is at `T` part. -/
theorem unparted_at_of_late [DecidableEq R] {reg : S → R} {s : S} {T : Nat}
    (late : ∀ r r' : Run P, r.state 0 = s → r'.state 0 = s → ∀ t, T ≤ t → ¬ PartAt reg r r' t)
    {r : Run P} (start : r.state 0 = s) : Unparted P reg (r.state T) :=
  fun q q' from_q from_q' n =>
    have agree : ∀ m, reg ((joinAt T r q from_q).1.state m) = reg ((joinAt T r q' from_q').1.state m) :=
      Identification.below_all fun m before =>
        match decEq (reg ((joinAt T r q from_q).1.state m))
            (reg ((joinAt T r q' from_q').1.state m)) with
        | isTrue same => same
        | isFalse differ =>
          match Nat.lt_or_ge m T with
          | .inl early => absurd (congrArg reg
              ((joinAt_before T r q from_q m (Nat.le_of_lt early)).trans
                (joinAt_before T r q' from_q' m (Nat.le_of_lt early)).symm)) differ
          | .inr ge => absurd ⟨before, differ⟩ (late (joinAt T r q from_q).1 (joinAt T r q' from_q').1
              ((joinAt T r q from_q).2.trans start) ((joinAt T r q' from_q').2.trans start) m ge)
    ((congrArg reg (joinAt_after T r q from_q n)).symm.trans (agree (T + n))).trans
      (congrArg reg (joinAt_after T r q' from_q' n))

/-- A course whose part from `T` on has at most `N` states has at most `T + N`. -/
theorem statesBelow_shift {O : Type w} {o : Nat → O} {T N : Nat}
    (below : StatesBelow (fun n => o (T + n)) N) : StatesBelow o (T + N) :=
  match Identification.statesBelow_iff_lasso.mp below with
  | ⟨i, q, within, lasso⟩ =>
    have bound : T + i + q + 1 ≤ T + N := by
      rw [Nat.add_assoc T i q, Nat.add_assoc T (i + q) 1]
      exact Nat.add_le_add_left within T
    Identification.statesBelow_iff_lasso.mpr ⟨T + i, q, bound, fun u ge =>
      match le_dest ge with
      | ⟨d, at_u⟩ => by
        have ahead : T + i + d + (q + 1) = T + (i + d + (q + 1)) := by
          rw [Nat.add_assoc T i d, Nat.add_assoc T (i + d)]
        rw [at_u, ahead, Nat.add_assoc T i d]
        exact lasso (i + d) (Nat.le_add_right i d)⟩

/-- **Where runs part only before `T`, the course has at most `T + N` states.** On a run from a
configuration from which no two runs part at any step from `T` on, held by a list of `N`
configurations. -/
theorem late_statesBelow [DecidableEq R] {reg : S → R} {s : S} {T : Nat}
    (late : ∀ r r' : Run P, r.state 0 = s → r'.state 0 = s → ∀ t, T ≤ t → ¬ PartAt reg r r' t)
    {r : Run P} (start : r.state 0 = s) {l : List S} (held : ∀ n, r.state n ∈ l) :
    StatesBelow (course reg r) (T + l.length) :=
  statesBelow_shift (course_statesBelow (unparted_at_of_late late start) (r := after r T) rfl
    fun n => held (T + n))

/-- **The rest step where runs part only before `T`.** The extrapolation by the least bound,
given nothing, is right at every step from `2(T + N) - 1` on, on every run from a configuration from
which no two runs part at any step from `T` on, held by a list of `N` configurations. -/
theorem late_right [DecidableEq R] {reg : S → R} {s : S} {T : Nat}
    (late : ∀ r r' : Run P, r.state 0 = s → r'.state 0 = s → ∀ t, T ≤ t → ¬ PartAt reg r r' t)
    {r : Run P} (start : r.state 0 = s) {l : List S} (held : ∀ n, r.state n ∈ l) {t : Nat}
    (from_late : (T + l.length) + (T + l.length) - 1 ≤ t) :
    RightAt Identification.leastBound reg r t :=
  Identification.leastBound_exact (late_statesBelow late start held) from_late

end Late

/-! ## Where runs do not part, an extrapolation built from the process is right -/

section World

/-- Whether some member of a list passes a test. -/
def anyOf {α : Type _} : List α → (α → Bool) → Bool
  | [], _ => false
  | x :: l, p => p x || anyOf l p

theorem anyOf_true {α : Type _} {p : α → Bool} : ∀ {l : List α}, anyOf l p = true →
    ∃ x, x ∈ l ∧ p x = true
  | [], nothing => Bool.noConfusion nothing
  | x :: l, holds => by
    cases here : p x with
    | true => exact ⟨x, .head _, here⟩
    | false =>
      have rest : anyOf l p = true := by
        have joined : (p x || anyOf l p) = true := holds
        rw [here] at joined
        exact joined
      obtain ⟨y, mem, passes⟩ := anyOf_true rest
      exact ⟨y, .tail _ mem, passes⟩

theorem anyOf_of_mem {α : Type _} {p : α → Bool} {x : α} :
    ∀ {l : List α}, x ∈ l → p x = true → anyOf l p = true
  | _ :: _, .head _, passes => show (p x || _) = true by rw [passes]; rfl
  | y :: _, .tail _ mem, passes => show (p y || _) = true by
      rw [anyOf_of_mem mem passes]
      cases p y <;> rfl

/-- The members of a list that pass a test. -/
def keepIf {α : Type _} (p : α → Bool) : List α → List α
  | [] => []
  | x :: l => cond (p x) (x :: keepIf p l) (keepIf p l)

theorem mem_keepIf {α : Type _} {p : α → Bool} {x : α} : ∀ {l : List α},
    x ∈ keepIf p l ↔ x ∈ l ∧ p x = true
  | [] => ⟨fun mem => (nomatch mem), fun ⟨mem, _⟩ => (nomatch mem)⟩
  | y :: l => by
    cases here : p y with
    | true =>
      show x ∈ cond (p y) (y :: keepIf p l) (keepIf p l) ↔ _
      rw [here]
      exact ⟨fun mem => match mem_cons_cases mem with
          | .inl same => ⟨.head _ |> Eq.subst (motive := fun z => z ∈ y :: l) same.symm,
              same ▸ here⟩
          | .inr inside => ⟨.tail _ (mem_keepIf.mp inside).1, (mem_keepIf.mp inside).2⟩,
        fun ⟨mem, passes⟩ => match mem_cons_cases mem with
          | .inl same => same ▸ .head _
          | .inr inside => .tail _ (mem_keepIf.mpr ⟨inside, passes⟩)⟩
    | false =>
      show x ∈ cond (p y) (y :: keepIf p l) (keepIf p l) ↔ _
      rw [here]
      exact ⟨fun mem => ⟨.tail _ (mem_keepIf.mp mem).1, (mem_keepIf.mp mem).2⟩,
        fun ⟨mem, passes⟩ => match mem_cons_cases mem with
          | .inl same => absurd (here ▸ same ▸ passes : false = true) Bool.false_ne_true
          | .inr inside => mem_keepIf.mpr ⟨inside, passes⟩⟩

/-- A member of a list that passes a test, found where one exists. -/
def choose {α : Type _} (p : α → Bool) : (l : List α) → (∃ x, x ∈ l ∧ p x = true) →
    {x : α // p x = true}
  | [], found => False.elim (match found with | ⟨_, mem, _⟩ => nomatch mem)
  | x :: l, found =>
    if passes : p x = true then ⟨x, passes⟩
    else choose p l (match found with
      | ⟨y, mem, passes'⟩ => match mem_cons_cases mem with
        | .inl same => absurd (same ▸ passes') passes
        | .inr inside => ⟨y, inside, passes'⟩)

section Continuing

variable {S : Type u} {A : Type v} {P : Process S A}

theorem path_of_continues : ∀ (m : Nat) (y : S), Lasting.Continues P m y →
    ∃ g : Nat → S, g 0 = y ∧ ∀ k, k < m → ∃ a, P.step (g k) a (g (k + 1))
  | 0, y, _ => ⟨fun _ => y, rfl, fun k lt => absurd lt (Nat.not_lt_zero k)⟩
  | m + 1, y, ⟨a, z, step, rest⟩ => match path_of_continues m z rest with
    | ⟨g, start, steps⟩ => ⟨fun | 0 => y | k + 1 => g k, rfl, fun
        | 0, _ => ⟨a, Eq.subst (motive := fun x => P.step y a x) start.symm step⟩
        | k + 1, lt => steps k (Nat.lt_of_succ_lt_succ lt)⟩

/-- Along a path that returns to an earlier configuration, courses of every length start at each
configuration before the return. -/
theorem continues_cycle {g : Nat → S} {i j : Nat}
    (steps : ∀ k, k < j → ∃ a, P.step (g k) a (g (k + 1))) (lt : i < j) (same : g i = g j) :
    ∀ m k, k < j → Lasting.Continues P m (g k)
  | 0, _, _ => trivial
  | m + 1, k, below => match steps k below with
    | ⟨a, step⟩ => ⟨a, g (k + 1), step,
        match Nat.lt_or_ge (k + 1) j with
        | .inl below' => continues_cycle steps lt same m (k + 1) below'
        | .inr ge =>
          Eq.subst (motive := fun x => Lasting.Continues P m x)
            (same.trans (congrArg g (Nat.le_antisymm below ge)).symm)
            (continues_cycle steps lt same m i lt)⟩

/-- **Where a list holds every configuration, a course as long as the list goes on.** From where
a course of `N` steps starts, `N` configurations listed, a step leads to where one starts: the
course repeats a configuration and can go round. No decidability is used. -/
theorem continues_persists {all : List S} (every : ∀ x, x ∈ all) {y : S}
    (continues : Lasting.Continues P all.length y) :
    ∃ a z, P.step y a z ∧ Lasting.Continues P all.length z :=
  match path_of_continues all.length y continues with
  | ⟨g, start, steps⟩ => match revisits_within all g (fun n _ => every (g n)) with
    | ⟨i, _, lt, within, same⟩ =>
      Eq.subst (motive := fun x => Lasting.Continues P (all.length + 1) x) start
        (continues_cycle (fun k below => steps k (Nat.lt_of_lt_of_le below within)) lt same
          (all.length + 1) 0 (Nat.lt_of_le_of_lt (Nat.zero_le i) lt))

theorem continues_any {all : List S} (every : ∀ x, x ∈ all) :
    ∀ (n : Nat) (y : S), Lasting.Continues P all.length y → Lasting.Continues P n y
  | 0, _, _ => trivial
  | n + 1, _, continues => match continues_persists every continues with
    | ⟨a, z, step, rest⟩ => ⟨a, z, step, continues_any every n z rest⟩

/-- **Where a list of `N` holds every configuration, a course of `N` steps from `s` makes `s`
unbounded**: courses of every length start there. With no decidability and no selection, where
`Lasting`'s lifting for finite branching holds up to double negation. -/
theorem unbounded_of_continues {all : List S} (every : ∀ x, x ∈ all) {y : S}
    (continues : Lasting.Continues P all.length y) : Lasting.Unbounded P y :=
  fun n => continues_any every n y continues

end Continuing

variable {S : Type u} {A : Type v} {R : Type w} (P : Process S A)
  [∀ x a y, Decidable (P.step x a y)] (moves : List A) (all : List S)

/-- From `y` a path of `m` steps is open. -/
def live : Nat → S → Bool
  | 0, _ => true
  | m + 1, y => anyOf moves fun a => anyOf all fun z => decide (P.step y a z) && live m z

variable {P moves all}

theorem live_succ_iff (every_move : ∀ a, a ∈ moves) (every : ∀ x, x ∈ all) {m : Nat} {y : S} :
    live P moves all (m + 1) y = true ↔ ∃ a z, P.step y a z ∧ live P moves all m z = true :=
  ⟨fun open_ => match anyOf_true open_ with
    | ⟨a, _, inner⟩ => match anyOf_true inner with
      | ⟨z, _, both⟩ => ⟨a, z, of_decide_eq_true (bool_of_and_true both).1, (bool_of_and_true both).2⟩,
   fun ⟨a, z, step, rest⟩ =>
     show anyOf moves (fun a => anyOf all fun z => decide (P.step y a z) && live P moves all m z) =
       true from
     anyOf_of_mem (every_move a) (anyOf_of_mem (every z) (bool_and_true (decide_eq_true step) rest))⟩

theorem live_of_run (every_move : ∀ a, a ∈ moves) (every : ∀ x, x ∈ all) (r : Run P) :
    ∀ m n, live P moves all m (r.state n) = true
  | 0, _ => rfl
  | m + 1, n => (live_succ_iff every_move every).mpr
      ⟨r.act n, r.state (n + 1), r.step n, live_of_run every_move every r m (n + 1)⟩

/-- **The Boolean depth is `Lasting.Continues`.** With listed moves and configurations, a path of
`m` steps is open from `y` exactly where some course of `m` steps starts at `y`. -/
theorem live_iff_continues (every_move : ∀ a, a ∈ moves) (every : ∀ x, x ∈ all) :
    ∀ (m : Nat) (y : S), live P moves all m y = true ↔ Lasting.Continues P m y
  | 0, _ => ⟨fun _ => trivial, fun _ => rfl⟩
  | m + 1, _ => (live_succ_iff every_move every).trans
      ⟨fun ⟨a, z, step, rest⟩ => ⟨a, z, step, (live_iff_continues every_move every m z).mp rest⟩,
       fun ⟨a, z, step, rest⟩ => ⟨a, z, step, (live_iff_continues every_move every m z).mpr rest⟩⟩

/-- **A path as long as there are configurations goes on.** From where a path of `N` steps is
open, `N` configurations listed, a step leads to where a path of `N` steps is open
(`continues_persists`). -/
theorem live_persists (every_move : ∀ a, a ∈ moves) (every : ∀ x, x ∈ all) {y : S}
    (open_ : live P moves all all.length y = true) :
    ∃ a z, P.step y a z ∧ live P moves all all.length z = true :=
  match continues_persists every ((live_iff_continues every_move every _ y).mp open_) with
  | ⟨a, z, step, rest⟩ => ⟨a, z, step, (live_iff_continues every_move every _ z).mpr rest⟩

/-- One step from where a path of `N` steps is open, to where one is open. -/
def advance (every_move : ∀ a, a ∈ moves) (every : ∀ x, x ∈ all)
    (y : {x : S // live P moves all all.length x = true}) :
    {p : A × {x : S // live P moves all all.length x = true} // P.step y.1 p.1 p.2.1} :=
  let a := choose (fun a => anyOf all fun z => decide (P.step y.1 a z) && live P moves all all.length z)
    moves (match live_persists every_move every y.2 with
      | ⟨a, z, step, rest⟩ => ⟨a, every_move a,
          anyOf_of_mem (p := fun z => decide (P.step y.1 a z) && live P moves all all.length z)
            (every z) (bool_and_true (decide_eq_true step) rest)⟩)
  let z := choose (fun z => decide (P.step y.1 a.1 z) && live P moves all all.length z) all
    (anyOf_true a.2)
  ⟨(a.1, ⟨z.1, (bool_of_and_true z.2).2⟩), of_decide_eq_true (bool_of_and_true z.2).1⟩

/-- The configurations reached by advancing `n` times. -/
def advanced (every_move : ∀ a, a ∈ moves) (every : ∀ x, x ∈ all)
    (y : {x : S // live P moves all all.length x = true}) :
    Nat → {x : S // live P moves all all.length x = true}
  | 0 => y
  | n + 1 => (advance every_move every (advanced every_move every y n)).1.2

/-- **A run from where a path of `N` steps is open.** -/
def liveRun (every_move : ∀ a, a ∈ moves) (every : ∀ x, x ∈ all)
    (y : {x : S // live P moves all all.length x = true}) : Run P :=
  ⟨fun n => (advanced every_move every y n).1,
   fun n => (advance every_move every (advanced every_move every y n)).1.1,
   fun n => (advance every_move every (advanced every_move every y n)).2⟩

variable [DecidableEq R] (reg : S → R) (s : S)

variable (P moves all) in
/-- The configurations a run from `s` can be at, given the prefix before: those reached from
one the prefix allows, with the value through the map the prefix says. -/
def candidates : List R → List S
  | [] => [s]
  | v :: record => keepIf (fun y => anyOf (candidates record) fun x =>
      decide (reg x = v) && anyOf moves fun a => decide (P.step x a y)) all

variable (P moves all) in
/-- The first of a list from where a path of `N` steps is open. -/
def firstLive : List S → Option S
  | [] => none
  | y :: l => cond (live P moves all all.length y) (some y) (firstLive l)

theorem firstLive_spec : ∀ {l : List S} {y : S}, firstLive P moves all l = some y →
    y ∈ l ∧ live P moves all all.length y = true
  | [], _, nothing => nomatch nothing
  | x :: l, y, found => by
    cases here : live P moves all all.length x with
    | true =>
      have same : some x = some y := by
        have found' : cond (live P moves all all.length x) (some x) (firstLive P moves all l) =
          some y := found
        rw [here] at found'
        exact found'
      exact ⟨Option.some.inj same ▸ .head _, Option.some.inj same ▸ here⟩
    | false =>
      have rest : firstLive P moves all l = some y := by
        have found' : cond (live P moves all all.length x) (some x) (firstLive P moves all l) =
          some y := found
        rw [here] at found'
        exact found'
      exact ⟨.tail _ (firstLive_spec rest).1, (firstLive_spec rest).2⟩

theorem firstLive_found : ∀ {l : List S} {y : S}, y ∈ l → live P moves all all.length y = true →
    ∃ z, firstLive P moves all l = some z
  | x :: l, y, mem, open_ => by
    cases here : live P moves all all.length x with
    | true => exact ⟨x, show cond _ _ _ = _ by rw [here]; rfl⟩
    | false =>
      have rest : ∃ z, firstLive P moves all l = some z :=
        match mem_cons_cases mem with
        | .inl same => absurd
            ((Eq.subst (motive := fun w => live P moves all all.length w = true) same open_).symm.trans
              here) Bool.noConfusion
        | .inr inside => firstLive_found inside open_
      match rest with
      | ⟨z, found⟩ => exact ⟨z, show cond _ _ _ = _ by rw [here]; exact found⟩

variable (P moves all) in
/-- **The extrapolation built from the process** (its listed moves and configurations, the map
and the start `s`): from the prefix, the configurations a run from `s` can be at; of these, the
first from which the run can go on; its value through the map. -/
def fromProcess (record : List R) : Option R :=
  (firstLive P moves all (candidates P moves all reg s record)).map reg

theorem run_in_candidates (every_move : ∀ a, a ∈ moves) (every : ∀ x, x ∈ all) (r : Run P)
    (start : r.state 0 = s) :
    ∀ t, r.state t ∈ candidates P moves all reg s (Learning.prefixOf (course reg r) t)
  | 0 => Eq.subst (motive := fun x => x ∈ [s]) start.symm (.head _)
  | t + 1 => mem_keepIf.mpr ⟨every _, anyOf_of_mem (run_in_candidates every_move every r start t)
      (bool_and_true (decide_eq_true rfl) (anyOf_of_mem (every_move (r.act t)) (decide_eq_true (r.step t))))⟩

theorem candidates_run : ∀ (record : List R) (y : S),
    y ∈ candidates P moves all reg s record → ∀ q : Run P, q.state 0 = y →
      ∃ r' : Run P, r'.state 0 = s ∧ Learning.prefixOf (course reg r') record.length = record ∧
        ∀ n, r'.state (record.length + n) = q.state n
  | [], y, mem, q, start =>
    have at_s : y = s := match mem_cons_cases mem with
      | .inl same => same
      | .inr inside => nomatch inside
    ⟨q, start.trans at_s, rfl, fun n => congrArg q.state (Nat.zero_add n)⟩
  | v :: record, y, mem, q, start =>
    match anyOf_true (mem_keepIf.mp mem).2 with
    | ⟨x, inside, both⟩ => match anyOf_true (bool_of_and_true both).2 with
      | ⟨a, _, moved⟩ =>
        have into : P.step x a (q.state 0) :=
          Eq.subst (motive := fun z => P.step x a z) start.symm (of_decide_eq_true moved)
        match candidates_run record x inside (before x a q into) rfl with
        | ⟨r', start', recorded, follows⟩ =>
          ⟨r', start',
           show course reg r' record.length :: Learning.prefixOf (course reg r') record.length =
               v :: record by
             rw [recorded]
             exact congrArg (· :: record)
               ((congrArg reg (follows 0)).trans (of_decide_eq_true (bool_of_and_true both).1)),
           fun n => (congrArg r'.state ((Nat.add_assoc _ _ _).trans
             (congrArg _ (Nat.add_comm 1 n)))).trans (follows (n + 1))⟩

/-- **Where no two runs part, the extrapolation built from the process is right.** For a process
with listed moves and configurations and decided steps, it is right at step `t`
on every run from `s` where no two runs from `s` part at `t`. -/
theorem world_right (every_move : ∀ a, a ∈ moves) (every : ∀ x, x ∈ all) {t : Nat}
    (unparted : ∀ r r' : Run P, r.state 0 = s → r'.state 0 = s → ¬ PartAt reg r r' t)
    (r : Run P) (start : r.state 0 = s) : RightAt (fromProcess P moves all reg s) reg r t :=
  match firstLive_found (run_in_candidates reg s every_move every r start t)
      (live_of_run every_move every r all.length t) with
  | ⟨y, found⟩ => match firstLive_spec found with
    | ⟨inside, open_⟩ =>
      match candidates_run reg s _ y inside (liveRun every_move every ⟨y, open_⟩) rfl with
      | ⟨r', start', recorded, follows⟩ =>
        have length : (Learning.prefixOf (course reg r) t).length = t := Learning.prefix_length _ t
        have agree : ∀ n, n < t → reg (r.state n) = reg (r'.state n) :=
          Identification.prefix_eq_iff.mp
            (Eq.subst (motive := fun k => Learning.prefixOf (course reg r') k = _) length recorded).symm
        have at_t : r'.state t = y :=
          Eq.subst (motive := fun k => r'.state (k + 0) = y) length (follows 0)
        have same : reg y = reg (r.state t) :=
          match decEq (reg y) (reg (r.state t)) with
          | isTrue same => same
          | isFalse differ => absurd ⟨agree, fun e => differ ((congrArg reg at_t).symm.trans e.symm)⟩
              (unparted r r' start start')
        show (firstLive P moves all _).map reg = some (reg (r.state t)) by
          rw [found]
          exact congrArg some same

/-- **The extrapolation built from the process is right at a step on every run exactly where no
two runs part there.** For a process with listed moves and configurations and decided steps. -/
theorem world_right_iff (every_move : ∀ a, a ∈ moves) (every : ∀ x, x ∈ all) (t : Nat) :
    (∀ r : Run P, r.state 0 = s → RightAt (fromProcess P moves all reg s) reg r t) ↔
      ∀ r r' : Run P, r.state 0 = s → r'.state 0 = s → ¬ PartAt reg r r' t :=
  ⟨fun right _ _ start start' part => not_right_on_both _ part ⟨right _ start, right _ start'⟩,
   fun unparted => world_right reg s every_move every unparted⟩

/-- **Some extrapolation is right at a step on every run exactly where no two runs part there,
and the extrapolation built from the process is one.** -/
theorem some_right_iff (every_move : ∀ a, a ∈ moves) (every : ∀ x, x ∈ all) (t : Nat) :
    (∃ pred : List R → Option R, ∀ r : Run P, r.state 0 = s → RightAt pred reg r t) ↔
      ∀ r r' : Run P, r.state 0 = s → r'.state 0 = s → ¬ PartAt reg r r' t :=
  ⟨fun ⟨pred, right⟩ _ _ start start' part =>
     not_right_on_both pred part ⟨right _ start, right _ start'⟩,
   fun unparted => ⟨_, world_right reg s every_move every unparted⟩⟩

end World

/-! ## Where runs part, nothing bounds the course -/

section Free

variable {V : Type w}

/-- **Free branching**: every configuration may follow every configuration. `Becoming.Courses`
reads `Courses.anyChange`, the process in which every change is admitted, as this
(`Courses.anyChange_eq_free`). -/
def free (V : Type w) : Process V Unit := ⟨fun _ _ _ => True⟩

/-- Every course is the course of a run of free branching, through the identity map. -/
def freeRun (o : Nat → V) : Run (free V) := ⟨o, fun _ => (), fun _ => trivial⟩

theorem freeRun_course (o : Nat → V) : course id (freeRun o) = o := rfl

/-- **Free branching parts nowhere where the map does not show it.** -/
theorem free_unparted_const {R : Type u} (x : R) (s : V) :
    Unparted (free V) (fun _ => x) s :=
  fun _ _ _ _ _ => rfl

/-- **No prefix shows that a world will not part.** Given two values, after every prefix two
runs of free branching, each with that prefix, part. -/
theorem free_parts_after {x y : V} (two : x ≠ y) (o : Nat → V) (t : Nat) :
    ∃ r r' : Run (free V), Learning.prefixOf (course id r) t = Learning.prefixOf o t ∧
      Learning.prefixOf (course id r') t = Learning.prefixOf o t ∧ PartAt id r r' t :=
  ⟨freeRun (Learning.holdFrom o t x), freeRun (Learning.holdFrom o t y),
   Learning.prefix_congr fun _ early => Learning.holdFrom_before o x early,
   Learning.prefix_congr fun _ early => Learning.holdFrom_before o y early,
   fun _ early => (Learning.holdFrom_before o x early).trans
     (Learning.holdFrom_before o y early).symm,
   fun same => two ((Learning.holdFrom_after o x (Nat.le_refl t)).symm.trans
     (same.trans (Learning.holdFrom_after o y (Nat.le_refl t))))⟩

/-- **After every prefix, every extrapolation can miss.** Given two values, for every
extrapolation and every prefix, a run of free branching has that prefix and the extrapolation is
not right at the next step. -/
theorem free_open [DecidableEq V] {x y : V} (two : x ≠ y) (pred : List V → Option V)
    (o : Nat → V) (t : Nat) :
    ∃ r : Run (free V), Learning.prefixOf (course id r) t = Learning.prefixOf o t ∧
      ¬ RightAt pred id r t :=
  match free_parts_after two o t with
  | ⟨r, r', same, same', part⟩ =>
    match decEq (pred (Learning.prefixOf (course id r) t)) (some (r.state t)) with
    | isFalse wrong => ⟨r, same, wrong⟩
    | isTrue right => ⟨r', same', fun right' => not_right_on_both pred part ⟨right, right'⟩⟩

/-- **Every extrapolation has a run of free branching on which it is never right.** -/
theorem free_never_right (pred : List Bool → Option Bool) :
    ∃ r : Run (free Bool), ∀ t, ¬ RightAt pred id r t :=
  ⟨freeRun (Learning.diagonal pred (fun b => !b) false), fun _ right =>
    match Learning.diagonal_misses pred ListTests.not_ne_self false right with
    | ⟨_, made, differs⟩ => differs (Option.some.inj (made.symm.trans right))⟩

/-- Free branching on two values is held by a list of two configurations. -/
theorem free_held (r : Run (free Bool)) (n : Nat) : r.state n ∈ [true, false] :=
  match r.state n with
  | true => List.Mem.head _
  | false => List.Mem.tail _ (List.Mem.head _)

/-- **Where runs part, two configurations bound nothing.** A run of free branching on two
configurations has a course through the map with no bound on its states. -/
theorem free_unbounded :
    ∃ r : Run (free Bool), ∀ N, ¬ StatesBelow (course id r) N :=
  ⟨freeRun (Learning.diagonal (Learning.byElimination Learning.lassos) (fun b => !b) false),
   fun _ bound => match Identification.statesBelow_iff_lasso.mp bound with
     | ⟨_, _, _, lasso⟩ => Learning.diagonal_not_lasso ListTests.not_ne_self false lasso⟩

end Free

end Parting

end Becoming
