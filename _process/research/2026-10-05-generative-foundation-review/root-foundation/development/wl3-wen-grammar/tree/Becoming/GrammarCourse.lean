import Becoming.Arising
import Becoming.IdentificationRuns
import Becoming.Unrolling

/-!
# 文 in the grammar: a course read through a map as continuation relative to a class

`Becoming.Grammar` states continuation relative to a class for every carrier and relation: `«续» R E`
is 缘 (`R`) met with a class (`E`), `«有常» R E` says that `E` is constant under `R`, and the core
`«核» R E` is the greatest symmetric constant relation inside `E` (`«根»`). The 文 line (chapter
WENLI-AND-BECOMING) reads a run's states through a map step by step: two configurations are 文同
where their courses through the map agree at every step (`Law.SameFuture`), two moments of one
course are one state where everything after them agrees (`SameAhead`), and the same course is the
coarsest relation keeping the map's values that the law keeps (`Law.sameFuture_coarsest`). This
module states that these are one structure. No definition of `Becoming.Grammar` changes.

* **A law in the grammar.** A determined law's step is 缘 (`Law.step`: `s` conditions the
  configuration after it), and a map's values give a class (`sameValue`). A relation is constant
  under the step exactly where the law keeps it (`Law.constant_iff_keeps`), and a class keeps the
  values and carries the law exactly where it lies in the value class and is constant
  (`Law.keepsAndCarries_iff`).
* **文同 is the core.** The core of the value class under the law's step is the same course
  through the map (`Law.core_is_sameFuture`), and so likeness by bisimulation in the frame by the
  map (`Law.alike_iff_core`). So `Law.sameFuture_coarsest` is the root theorem
  `«根»` read on a law, and the coarsest class of WL2 is the core: a class keeping the values and
  carrying the law is coarser than every such relation exactly where it is the core
  (`Law.coarsest_iff_core`, from the grammar law `contains_core_iff`).
* **Positions on a 文.** Under the value class a configuration's line ends exactly where the value
  changes at the next step (`Law.ends_iff_changes`); every line runs along the orbit
  (`Law.line_on_orbit`); the line never ends exactly where the course is constant from there
  (`Law.unending_iff`); and a step continues under the core exactly where the line under the
  value class never ends (`Law.continues_in_core_iff`), for every law and every type of values.
  The value class is constant exactly where it is its own core, the values then being their own
  law (`Law.constant_iff_core`), and then a course that keeps its value for one step keeps it for
  good (`Law.stays_of_constant`, through `«有常则续不尽»`).
* **The states of a 文 are the core along the moments.** The moments with the step to the next
  are the step of the successor law (`Steps.next_is_step`); two moments are one state exactly where
  they lie in one class of the core of the course's value class (`SameAhead.is_core`), and a
  state goes on as itself because the core is constant (`SameAhead.next_by_root`). Along a law's
  course the core on moments is the core on configurations (`course_core_iff`). A course with a
  new value at every moment has no continuation under its core (`SameAhead.no_continuation`), the
  文 form of the flame (`«以核为判据则火无续»`).
* **The bounded laws through the core.** With at most `N` states the core is read off `N + N - 1`
  steps (`core_iff_below`; for a law on a listed world, `Law.core_iff_below`), and at most `N`
  states is at most `N` classes of the core, each met before `N` (`statesBelow_iff_core`). Two 文
  are taken as one net on the sum of their moments (`TwoCourses.next`, `TwoCourses.value`): their moments lie
  in one class of the core exactly where the courses agree from there (`TwoCourses.core_iff`); with at
  most `N` and `N'` states this is agreement before `N + N' - 1` (`TwoCourses.core_iff_bounded`), and
  that length is exact (`TwoCourses.core_exact`).
* **Learnability through the core.** A feature is learnable through a map exactly where
  configurations in one class of the reading's core have features that agree from some step on
  (`Law.learnable_iff_core`); a feature whose class contains the reading's core is learnable
  (`Law.learnable_of_core_within`), and that is exactly where the reading's core lies in the
  feature's core (`core_within_core_iff`).

What does not join: the grammar has no counting, no lists and no "from some step on", so the
prefix (往, `Learning.prefixOf`), the bound `N + N - 1` as a number, the extrapolations of
`Becoming.Learnable` and `Becoming.Unrolling`, and learnability's eventual agreement are stated
beside the core, not in the grammar's own terms. Equality of values is the model's commitment, as
equality on the carrier is in the grammar. Every declaration has an empty axiom report.
-/

namespace Becoming

universe u v w

section Values

variable {S : Type u} {R : Type v}

/-- The class of a map's values: two configurations alike in their value through the map. -/
def sameValue (o : S → R) : «际» S := fun s s' => o s = o s'

theorem sameValue_class (o : S → R) : «类» (sameValue o) :=
  ⟨fun _ => rfl, Eq.symm, Eq.trans⟩

end Values

section General

variable {α : Type u}

/-- **A core lies in another class's core exactly where it lies in that class.** -/
theorem core_within_core_iff {R E E' : «际» α} :
    «则» («核» R E) («核» R E') ↔ «则» («核» R E) E' :=
  ⟨fun h x y k => («根» R E').1 x y (h x y k),
   fun h => («根» R E').2.2.2 («核» R E) h («根» R E).2.2.1 («根» R E).2.1⟩

/-- **A symmetric constant relation inside a class contains the core exactly where it is the
core.** -/
theorem contains_core_iff {R E S : «际» α} (inside : «则» S E) (symm : «则» S («逆» S))
    (constant : «有常» R S) : «则» («核» R E) S ↔ «谓» S («核» R E) :=
  ⟨fun h x y => ⟨(«根» R E).2.2.2 S inside symm constant x y, h x y⟩,
   fun h x y k => (h x y).mpr k⟩

end General

namespace Law

variable {S : Type u} {R : Type v} {V : Type w}

/-- A determined law's step read as 缘: `s` is a condition of `t` when `t` is the configuration
after `s`. -/
def step (next : S → S) : «际» S := fun s t => t = next s

/-- A configuration has a successor in a line under `E` exactly when it is alike with the
configuration after it. -/
theorem step_hasSucc_iff {next : S → S} {E : «际» S} {s : S} :
    «有后» (step next) E s ↔ E s (next s) :=
  ⟨fun ⟨_, h, e⟩ => by cases h; exact e, fun e => ⟨next s, rfl, e⟩⟩

/-- **A relation is constant under a law's step exactly where the law keeps it.** -/
theorem constant_iff_keeps {next : S → S} {E : «际» S} :
    «有常» (step next) E ↔ KeepsRelation next E :=
  ⟨fun c x y e => match («有常之逐点» (step next) E).mp c x y e (next x) rfl with
      | ⟨_, h, e'⟩ => by cases h; exact e',
   fun keeps => («有常之逐点» (step next) E).mpr fun u u' e v h =>
      ⟨next u', rfl, by cases h; exact keeps u u' e⟩⟩

/-- A kept relation holds at every step of the orbits from related configurations. -/
theorem kept_along {next : S → S} {E : «际» S} (keeps : KeepsRelation next E) {s s' : S}
    (h : E s s') : ∀ n, E (orbit next s n) (orbit next s' n)
  | 0 => h
  | n + 1 => keeps _ _ (kept_along keeps h n)

/-- **文同 is the core (核) of the class of the map's values under the law's step.** Two
configurations lie in one class of the core exactly where their courses through the map agree at
every step. -/
theorem core_is_sameFuture {next : S → S} {o : S → R} :
    «谓» («核» (step next) (sameValue o)) (SameFuture next o) :=
  fun s s' =>
    ⟨fun ⟨E, inside, _, constant, related⟩ =>
      sameFuture_coarsest.2.2 E (fun a b h => inside a b h) (constant_iff_keeps.mp constant) s s'
        related,
     fun same => ⟨SameFuture next o, fun _ _ h => h 0, fun _ _ h n => (h n).symm,
      constant_iff_keeps.mpr sameFuture_coarsest.2.1, same⟩⟩

/-- **Under a determined law, likeness by bisimulation is the core.** Two configurations are alike
in the frame by the map exactly where they lie in one class of the core of the value class: the
correspondence of constancy with bisimulation that `Becoming.Grammar` names, made exact here. -/
theorem alike_iff_core {next : S → S} {o : S → R} {s s' : S} :
    Alike (frameBy next o) (frameBy next o) s s' ↔ «核» (step next) (sameValue o) s s' :=
  alike_iff_sameFuture.trans (core_is_sameFuture s s').symm

/-- **A class keeps the map's values and carries the law exactly where it lies in the value class
and is constant under the law's step.** -/
theorem keepsAndCarries_iff {K : Type w} {next : S → S} {o : S → R} {π : S → K} :
    KeepsAndCarries next o π ↔
      «则» (sameValue π) (sameValue o) ∧ «有常» (step next) (sameValue π) :=
  ⟨fun ⟨keeps, alike⟩ => ⟨keeps, constant_iff_keeps.mpr (Learning.goAlike_iff_lumped.mp alike)⟩,
   fun ⟨keeps, constant⟩ =>
    ⟨keeps, Learning.goAlike_iff_lumped.mpr (constant_iff_keeps.mp constant)⟩⟩

/-- **The coarsest class is the core.** A class keeping the values and carrying the law contains
the core exactly where it is the core: WL2's coarsest class (`coarsest_iff`) read in the grammar. -/
theorem coarsest_iff_core {K : Type w} {next : S → S} {o : S → R} {π : S → K}
    (lawful : KeepsAndCarries next o π) :
    «则» («核» (step next) (sameValue o)) (sameValue π) ↔
      «谓» (sameValue π) («核» (step next) (sameValue o)) :=
  contains_core_iff (keepsAndCarries_iff.mp lawful).1 (fun _ _ h => h.symm)
    (keepsAndCarries_iff.mp lawful).2

/-- Under the value class a configuration's line ends (亡) exactly where the value changes at the
next step. -/
theorem ends_iff_changes {next : S → S} {o : S → R} {s : S} :
    «亡» (step next) (sameValue o) s ↔ ¬ o s = o (next s) :=
  ⟨fun h e => h (step_hasSucc_iff.mpr e), fun h hs => h (step_hasSucc_iff.mp hs)⟩

/-- Every line (相续) along a law's step runs along the orbit. -/
theorem line_on_orbit {next : S → S} {E : «际» S} {s y : S} (line : «相续» (step next) E s y) :
    ∃ n, y = orbit next s (n + 1) := by
  induction line with
  | one c => exact ⟨0, c.1⟩
  | @more x y₀ z c _ ih =>
    match ih with
    | ⟨n, h⟩ =>
      exact ⟨n + 1, (h.trans (congrArg (fun w => orbit next w (n + 1)) c.1)).trans
        (orbit_shift next x (n + 1)).symm⟩

/-- The line from a configuration under the value class reaches every later configuration of its
orbit while the value has not changed. -/
theorem reached_while_same {next : S → S} {o : S → R} {s : S}
    (never : «不穷» (step next) (sameValue o) s) :
    ∀ n, (s = orbit next s n ∨ «相续» (step next) (sameValue o) s (orbit next s n)) ∧
      o (orbit next s n) = o s
  | 0 => ⟨.inl rfl, rfl⟩
  | n + 1 =>
    match reached_while_same never n with
    | ⟨reach, same⟩ =>
      have e : o (orbit next s n) = o (orbit next s (n + 1)) :=
        step_hasSucc_iff.mp (never _ reach)
      have c : «续» (step next) (sameValue o) (orbit next s n) (orbit next s (n + 1)) := ⟨rfl, e⟩
      ⟨match reach with
        | .inl at_s =>
          .inr (Eq.subst (motive := fun w => «相续» (step next) (sameValue o) w (orbit next s (n + 1)))
            at_s.symm (.one c))
        | .inr line => .inr («及之传递» line (.one c)),
       e.symm.trans same⟩

/-- **The line never ends (不穷) exactly where the course is constant from there.** -/
theorem unending_iff {next : S → S} {o : S → R} {s : S} :
    «不穷» (step next) (sameValue o) s ↔ ∀ n, o (orbit next s n) = o s :=
  ⟨fun never n => (reached_while_same never n).2,
   fun const y reach =>
    have at_orbit : ∃ m, y = orbit next s m :=
      match reach with
      | .inl at_s => ⟨0, at_s.symm⟩
      | .inr line => match line_on_orbit line with
        | ⟨n, h⟩ => ⟨n + 1, h⟩
    match at_orbit with
    | ⟨m, h⟩ => by
      cases h
      exact step_hasSucc_iff.mpr ((const m).trans (const (m + 1)).symm)⟩

/-- **Continuing under the core is never ending under the class.** For every law and every type
of values, a configuration continues to the next under the core of the value class exactly where
the line under the value class never ends from it. -/
theorem continues_in_core_iff {next : S → S} {o : S → R} {s : S} :
    «续» (step next) («核» (step next) (sameValue o)) s (next s) ↔
      «不穷» (step next) (sameValue o) s :=
  ⟨fun ⟨_, core⟩ =>
    have same := (core_is_sameFuture s (next s)).mp core
    have const : ∀ n, o (orbit next s n) = o s := fun n => Nat.rec (motive := fun n =>
        o (orbit next s n) = o s) rfl
      (fun n ih => (congrArg o (orbit_shift next s n)).trans ((same n).symm.trans ih)) n
    unending_iff.mpr const,
   fun never =>
    have const := unending_iff.mp never
    ⟨rfl, (core_is_sameFuture s (next s)).mpr fun n =>
      (const n).trans ((congrArg o (orbit_shift next s n)).symm.trans (const (n + 1))).symm⟩⟩

/-- **The value class is constant exactly where it is its own core**: the values are then their
own law, and the same course is the same value now. -/
theorem constant_iff_core {next : S → S} {o : S → R} :
    «有常» (step next) (sameValue o) ↔ «谓» (sameValue o) («核» (step next) (sameValue o)) :=
  ⟨fun c x y => ⟨(«类有常当且仅当含于核» (step next) (sameValue_class o)).mp c x y,
     («根» (step next) (sameValue o)).1 x y⟩,
   fun h => («类有常当且仅当含于核» (step next) (sameValue_class o)).mpr fun x y e => (h x y).mp e⟩

/-- **Where the values are their own law, a course that keeps its value for one step keeps it for
good** (`«有常则续不尽»` on a 文). -/
theorem stays_of_constant {next : S → S} {o : S → R} (constant : «有常» (step next) (sameValue o))
    {s : S} (still : o s = o (next s)) : ∀ n, o (orbit next s n) = o s :=
  unending_iff.mp (continues_in_core_iff.mp ⟨rfl, (constant_iff_core.mp constant s (next s)).mp still⟩)

/-- **For a law on a listed world the core is read off `N + N - 1` steps**, `N` the list's
length. -/
theorem core_iff_below {next : S → S} {o : S → R} {l : List S} (closed : ∀ s, s ∈ l → next s ∈ l)
    {s s' : S} (mem : s ∈ l) (mem' : s' ∈ l) :
    «核» (step next) (sameValue o) s s' ↔
      ∀ n, n < l.length + l.length - 1 → o (orbit next s n) = o (orbit next s' n) :=
  (core_is_sameFuture s s').trans (sameFuture_iff_below closed mem mem')

section Learnability

variable {S : Type} {R : Type v} {V : Type w} [DecidableEq R]

/-- **Learnable exactly where the reading's core makes features agree from some step on.** In a
world a list holds, some extrapolation from prefixes through the map predicts the feature at every
configuration exactly where configurations in one class of the core of the map's value class have
features that agree from some step on. -/
theorem learnable_iff_core {next : S → S} {reg : S → R} {val : S → V} {l : List S}
    (world : ∀ s, s ∈ l) :
    (∃ pred : List R → Option V, ∀ s, Learnable.Predicts next reg val pred s) ↔
      ∀ s s', «核» (step next) (sameValue reg) s s' →
        ∃ T, ∀ t, T ≤ t → sameValue val (orbit next s t) (orbit next s' t) :=
  have exactly : (∃ pred : List R → Option V, ∀ s, Learnable.Predicts next reg val pred s) ↔
      ∀ s s', SameFuture next reg s s' →
        ∃ T, ∀ t, T ≤ t → val (orbit next s t) = val (orbit next s' t) :=
    Learnable.learnable_iff world
  ⟨fun learnable s s' core => exactly.mp learnable s s' ((core_is_sameFuture s s').mp core),
   fun agree => exactly.mpr fun s s' same => agree s s' ((core_is_sameFuture s s').mpr same)⟩

/-- **A feature whose class contains the reading's core is learnable**, the features agreeing at
every step. -/
theorem learnable_of_core_within {next : S → S} {reg : S → R} {val : S → V} {l : List S}
    (world : ∀ s, s ∈ l) (within : «则» («核» (step next) (sameValue reg)) (sameValue val)) :
    ∃ pred : List R → Option V, ∀ s, Learnable.Predicts next reg val pred s :=
  (learnable_iff_core world).mpr fun _ _ core => ⟨0, fun t _ =>
    within _ _ (kept_along (constant_iff_keeps.mp («根» (step next) (sameValue reg)).2.1) core t)⟩

end Learnability

end Law

/-! ## The moments of a 文 -/

section Moments

variable {S : Type u} {R : Type v} {O : Type w}

/-- The steps of one course are the step of the successor law. -/
theorem Steps.next_is_step : «谓» Steps.next (Law.step Nat.succ) := fun _ _ => Iff.rfl

/-- **Two moments of a 文 are one state exactly where they lie in one class of the core of its
value class along the steps.** -/
theorem SameAhead.is_core {o : Nat → O} : «谓» («核» Steps.next (sameValue o)) (SameAhead o) :=
  fun t t' => (Law.core_is_sameFuture (next := Nat.succ) (o := o) t t').trans
    ⟨fun h n => (congrArg o (Law.succ_orbit t n)).symm.trans
        ((h n).trans (congrArg o (Law.succ_orbit t' n))),
     fun h n => (congrArg o (Law.succ_orbit t n)).trans
        ((h n).trans (congrArg o (Law.succ_orbit t' n)).symm)⟩

/-- A state read off a 文 goes on as itself because the core is constant (`«根»`): `SameAhead.next`
derived through the grammar. -/
theorem SameAhead.next_by_root {o : Nat → O} {t t' : Nat} (h : SameAhead o t t') :
    SameAhead o (t + 1) (t' + 1) :=
  match («有常之逐点» Steps.next _).mp («根» Steps.next (sameValue o)).2.1 t t'
      ((SameAhead.is_core t t').mpr h) (t + 1) rfl with
  | ⟨_, hv, core⟩ => by cases hv; exact (SameAhead.is_core (t + 1) (t' + 1)).mp core

/-- **Along a law's course the core on moments is the core on configurations.** -/
theorem course_core_iff {next : S → S} {o : S → R} {s : S} {t t' : Nat} :
    «核» Steps.next (sameValue (Learnable.course next o s)) t t' ↔
      «核» (Law.step next) (sameValue o) (Law.orbit next s t) (Law.orbit next s t') :=
  (SameAhead.is_core t t').trans (sameAhead_orbit_iff.trans (Law.core_is_sameFuture _ _).symm)

/-- **A 文 with a new value at every moment has no continuation under its core**: each moment is
its own state, as no two moments of the flame lie in one class of its core. -/
theorem SameAhead.no_continuation {o : Nat → O} (new : ∀ t t', o t = o t' → t = t') (t t' : Nat) :
    ¬ «续» Steps.next («核» Steps.next (sameValue o)) t t' :=
  fun ⟨step, core⟩ => by
    cases step
    exact Nat.ne_of_lt (Nat.lt_succ_self t) (SameAhead.new_each new ((SameAhead.is_core t (t + 1)).mp core))

/-- **With at most `N` states the core of a 文 is read off `N + N - 1` steps.** -/
theorem core_iff_below {o : Nat → O} {N : Nat} (bound : StatesBelow o N) {t t' : Nat} :
    «核» Steps.next (sameValue o) t t' ↔ ∀ n, n < N + N - 1 → o (t + n) = o (t' + n) :=
  (SameAhead.is_core t t').trans (Identification.sameAhead_iff_below bound)

/-- **At most `N` states is at most `N` classes of the core**, each met before `N`. -/
theorem statesBelow_iff_core {o : Nat → O} {N : Nat} :
    StatesBelow o N ↔ ∀ t, ∃ i, i < N ∧ «核» Steps.next (sameValue o) t i :=
  ⟨fun bound t => match bound t with
    | ⟨i, lt, same⟩ => ⟨i, lt, (SameAhead.is_core t i).mpr same⟩,
   fun cores t => match cores t with
    | ⟨i, lt, core⟩ => ⟨i, lt, (SameAhead.is_core t i).mp core⟩⟩

end Moments

/-! ## Two 文 as one net -/

namespace TwoCourses

variable {O : Type w}

/-- The moments of two courses side by side, each going to its own next moment. -/
def next : Nat ⊕ Nat → Nat ⊕ Nat
  | .inl n => .inl (n + 1)
  | .inr n => .inr (n + 1)

/-- The value at a moment of either course. -/
def value (o o' : Nat → O) : Nat ⊕ Nat → O
  | .inl n => o n
  | .inr n => o' n

theorem orbit_inl (t : Nat) : ∀ n, Law.orbit next (.inl t) n = .inl (t + n)
  | 0 => rfl
  | n + 1 => congrArg next (orbit_inl t n)

theorem orbit_inr (t : Nat) : ∀ n, Law.orbit next (.inr t) n = .inr (t + n)
  | 0 => rfl
  | n + 1 => congrArg next (orbit_inr t n)

/-- **Two moments of two 文 lie in one class of the core exactly where the courses agree from
there.** -/
theorem core_iff {o o' : Nat → O} {t t' : Nat} :
    «核» (Law.step next) (sameValue (value o o')) (.inl t) (.inr t') ↔
      ∀ n, o (t + n) = o' (t' + n) :=
  (Law.core_is_sameFuture _ _).trans
    ⟨fun h n => (congrArg (value o o') (orbit_inl t n)).symm.trans
        ((h n).trans (congrArg (value o o') (orbit_inr t' n))),
     fun h n => (congrArg (value o o') (orbit_inl t n)).trans
        ((h n).trans (congrArg (value o o') (orbit_inr t' n)).symm)⟩

/-- **Two bounded 文 are fixed by their agreement before `N + N' - 1`, through the core.** -/
theorem core_iff_bounded {o o' : Nat → O} {N N' : Nat} (bound : StatesBelow o N)
    (bound' : StatesBelow o' N') {t t' : Nat} :
    «核» (Law.step next) (sameValue (value o o')) (.inl t) (.inr t') ↔
      ∀ n, n < N + N' - 1 → o (t + n) = o' (t' + n) :=
  core_iff.trans ⟨fun h n _ => h n,
    Identification.bounded_agree (Identification.statesBelow_shift bound t)
      (Identification.statesBelow_shift bound' t')⟩

/-- **The length `N + N' - 1` is exact, through the core.** Given two values, for all `M` and `M'`
a 文 with at most `M + 1` states and one with at most `M' + 1` agree before `M + M'` while their
first moments lie in different classes of the core. -/
theorem core_exact {x y : O} (two : x ≠ y) (M M' : Nat) :
    ∃ o o' : Nat → O, StatesBelow o (M + 1) ∧ StatesBelow o' (M' + 1) ∧
      (∀ n, n < M + M' → o n = o' n) ∧
      ¬ «核» (Law.step next) (sameValue (value o o')) (.inl 0) (.inr 0) :=
  match Identification.bounded_agree_exact two M M' with
  | ⟨o, o', b, b', prefixes, differ⟩ =>
    ⟨o, o', b, b', Identification.prefix_eq_iff.mp prefixes, fun core =>
      differ ((congrArg o (Nat.zero_add (M + M')).symm).trans
        ((core_iff.mp core (M + M')).trans (congrArg o' (Nat.zero_add (M + M')))))⟩

end TwoCourses

end Becoming
