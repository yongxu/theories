import Becoming.World
import Becoming.Reordering

/-!
# Interleavings: the step index read off the relata's own courses

The spine counts steps `0, 1, 2, …` shared by every relatum. `Becoming.Order` and
`Becoming.OrderNormal` showed, for a world given with that index, that the laws need only the
order of joined exchanges. This module starts from the other side, with no shared index: exchanges
act locally, each reading and changing only the relata it touches (`LocalLaw`), and what is given
is each relatum's own course, the exchanges it takes part in, in order. A shared index is an
interleaving of those courses: a list of exchanges whose course at every relatum is that
relatum's own (`ownCourse`, `Interleaves`). No premise beyond what each theorem names.

* **The interleaving carries nothing the relata do not.** Two lists of exchanges giving every
  relatum the same own course reach the same configuration from the same start
  (`run_of_courses`), and so do two traces of the exchange process (`LocalLaw.process`,
  `trace_of_courses`, `trace_of_interleavings`). The proof moves the first exchange of one list
  forward in the other past exchanges sharing no relatum with it (`split_heads`, `run_move`), which
  commute (`act_comm`, `trace_swap`).
* **The index is built, not assumed.** With the relata listed and exchanges told apart, a
  scheduler takes, at each stage, an exchange heading the course of every relatum it touches
  (`ready`, `pick`), and drops it from those courses (`pop`). It completes, within as many stages
  as the courses have exchanges, exactly where some interleaving exists (`schedule_iff`), that is
  exactly where some trace takes every relatum through its given course (`traced_iff`): what it
  returns is an interleaving (`schedule_interleaves`), and where one exists every ready exchange
  can be taken first (`pop_interleaves`), so it is never stuck (`schedule_some`).
* **Exactly where the index is fixed by the relations.** With the relata listed, the own courses
  fix the interleaving (equal own courses, equal lists) exactly where every exchange touches some
  relatum and every two exchanges are the same or share a relatum (`unique_iff`, and on the traces
  from any configuration `traced_unique_iff`). Two exchanges sharing no relatum have the same own
  courses in either order (`swap_courses`).
* **The world an interleaving builds.** From a local law on whole-number standings, the relata
  listed and a list of exchanges, `world` is a `World` of the spine (`World.of`): at step `t` each
  relatum stands where the first `t` exchanges leave it (`runUpTo`, `world_level`), is active where
  the exchange at `t` touches it, and takes or gives to itself what the step changes, so with every
  relatum listed once each step balances (`world_balances`); the activity is the touch, decided
  (`touchAt`, `world_active_iff`). Two interleavings of the same own
  courses give every relatum the same course of standings, the standings after each of its own
  exchanges in order (`standings_of_courses`, `standings_of_interleavings`), and the same standing
  from both lengths on (`world_final`). Exchanging two adjacent exchanges sharing no relatum leaves
  the world alike at every step but the one between them (`world_swap`); at that step each relatum
  either of them touches stands, in one world, where it stands one step later or earlier in the
  other, and one neither touches stands alike (`world_swap_between`).
* **Any two interleavings, step by step.** A relatum's standing at step `t` is its standing after
  the own exchanges the first `t` exchanges hold (`ownCount`, `standingAfter`, `runUpTo_own`,
  `world_own`). So in two interleavings of the same courses a relatum stands alike at any two
  steps, one in each world, at which it has taken equally many of its own exchanges
  (`runUpTo_of_own`, `world_of_own`). The index map for a relatum sends a step of one list to the
  least step of the other at which the relatum has taken as many (`firstAt`, `ownCount_firstAt`,
  `firstAt_least`, `indexMap`, `ownCount_index`), and the worlds agree through it
  (`runUpTo_index`, `world_index`); where the relatum takes an exchange at step `t` of one list,
  the map sends `t + 1` to the step after the one at which it takes the same exchange in the other
  (`exchangeAt_own`, `firstAt_succ_step`, `index_matches`). Every property of a standing that a
  relatum has at some step, or at every step, of one world it has at some step, or at every step,
  of the other (`world_reads_alike`).
* **One renumbering of all the steps.** Where every exchange of two interleavings of the same
  courses touches some relatum (`Touching`), the lists have one length (`length_of_courses`) and
  the `k`-th taking of an exchange in one is the `k`-th in the other at every relatum it touches
  (`occurrence_matches`, `step_of_ownCount`). `renumber` sends each step to the step of the
  other list taking the same exchange so (`renumber_spec`, `renumber_exchange`,
  `renumber_count`); on the steps of every relatum the exchange touches it is that relatum's
  index map, one step back (`renumber_index`). It is undone by the renumbering the other way at
  every step (`renumber_renumber`), takes the steps below the length among themselves and fixes
  every step from it on (`renumber_lt`, `renumber_beyond`), so it `Reindexes` the steps
  (`renumber_reindexes`). Through it the worlds agree: activity at every relatum
  (`world_renumber_active`), the exchange itself, present relata and what each takes and gives
  (`world_renumber_flow`, `Flow.SameExchange`), and the standing of every relatum the exchange
  touches before it and after it (`runUpTo_renumber`, `world_renumber_level`), so every relation
  reading those relata at one step, however many, reads alike (`reads_renumber`,
  `world_renumber_reads`). A relation reading relata that the step's exchange does not touch is
  not so read: in `Pair.apart_differs` one relatum stands below another at a step of one world
  and at no step of the other. An exchange touching no relatum is matched by none
  (`Pair.idle_unmatched`).
* **The correspondence with `Becoming.Reordering`.** The renumbering keeps the order of
  exchanges sharing a relatum (`renumber_keeps`: `Keeps` for the footprint of the touches,
  `touchAt`), and the footprint moves with it (`touchAt_renumber`). The footprint of the touches
  contains the exchanges exactly where no relatum is touched at a step after one not touching it
  (`touch_contains_iff`; `Pair.touch_not_contains`): the world's activity is the touch of the
  exchange across a step, so it changes across every step after which a relatum's taking part
  begins. The footprint around each step, the relata the exchange at the step or at the next
  touches (`touchAround`), contains them (`around_contains`), but joins every two consecutive
  exchanges (`around_joined`), so the only renumbering keeping its order fixes every step
  (`keeps_consecutive`, `around_keeps_identity`): Reordering's commutations relate the world of
  an interleaving to no other interleaving's, and the relation between them is the renumbering.
  What holds of the premises of Reordering's `converse` is gathered on the worlds in
  `world_renumber_correspondence`.

Reading (the AI's, D43): the shared index of steps is a reading of the relations, not
their ground. What each relatum undergoes, and in what order, is its own course; a global index
adds only an order between exchanges that share no relatum, and that order changes no
configuration. The index is derived from the relations exactly where every two exchanges share a
relatum; elsewhere it is a commitment of the representation, a choice among interleavings that
the relations leave open and the configurations do not read. With the index map, what a world
says of a relatum is read through the relatum's own steps, and that reading is the same for
every interleaving: the choice of interleaving moves where on the shared index a standing falls,
not which standings a relatum passes through or in what order. With the renumbering, what a
world says at one step of the relata that step's exchange touches is the same for every
interleaving, however many relata it reads; what it says at one step of relata no exchange there
connects is a reading of the chosen interleaving.

Not shown: courses without end (the courses here are finite lists); exchanges that read relata
they do not change, in a footprint of their own (here what an exchange reads and what it may
change are one footprint); a reading of activity as a state of a relatum between steps, under
which Reordering's commutations could relate two interleavings' worlds (here activity is taking
part in the exchange across a step). No ethical predicate, ranking or axiom occurs.
* **Shared relata need not commute.** Two exchanges sharing their relatum, taken in two orders from
  one configuration, can reach different configurations (`Shared.order_matters`): the condition of
  `act_comm` cannot be dropped.
-/

namespace Becoming

open Generative

namespace Interleavings

section Lists

variable {α : Type}

theorem cons_ne_nil {a : α} {l : List α} : a :: l ≠ [] :=
  fun same => nomatch same

theorem cons_heads {a b : α} {l m : List α} (same : a :: l = b :: m) : a = b :=
  (List.cons.inj same).1

theorem cons_tails {a b : α} {l m : List α} (same : a :: l = b :: m) : l = m :=
  (List.cons.inj same).2

theorem bool_absurd {P : Prop} {b : Bool} (yes : b = true) (no : b = false) : P :=
  Bool.noConfusion (yes.symm.trans no)

/-- The first member of a list where a test holds, if any: before it the test fails. -/
theorem split_first (p : α → Bool) : ∀ L : List α,
    (∀ f, f ∈ L → p f = false) ∨
      ∃ A f B, L = A ++ f :: B ∧ (∀ a, a ∈ A → p a = false) ∧ p f = true
  | [] => .inl fun _ mem => nomatch mem
  | g :: L => by
    cases here : p g with
    | true => exact .inr ⟨[], g, L, rfl, fun _ mem => (nomatch mem), here⟩
    | false =>
      match split_first p L with
      | .inl absent =>
        exact .inl fun f mem => match mem_cons_cases mem with
          | .inl same => by rw [same]; exact here
          | .inr rest => absent f rest
      | .inr ⟨A, f, B, split, before, found⟩ =>
        exact .inr ⟨g :: A, f, B, by rw [split]; rfl, fun a mem => match mem_cons_cases mem with
          | .inl same => by rw [same]; exact here
          | .inr rest => before a rest, found⟩

theorem length_tail_le : ∀ l : List α, l.tail.length ≤ l.length
  | [] => Nat.le_refl 0
  | _ :: m => Nat.le_succ m.length

end Lists

/-- Exchanges acting locally on relata: each exchange touches some relata, leaves every other
relatum's state as it was (`keeps`), and changes a relatum it touches as the states of the relata
it touches determine (`reads`). -/
structure LocalLaw (X E σ : Type) where
  touches : E → X → Bool
  act : E → (X → σ) → (X → σ)
  keeps : ∀ e s x, touches e x = false → act e s x = s x
  reads : ∀ e s s' x, (∀ y, touches e y = true → s y = s' y) → touches e x = true →
    act e s x = act e s' x

variable {X E σ : Type}

namespace LocalLaw

variable (law : LocalLaw X E σ)

/-- The configuration reached by taking the exchanges of a list in turn. -/
def run : List E → (X → σ) → (X → σ)
  | [], s => s
  | e :: es, s => run es (law.act e s)

/-- A relatum's own course in a list of exchanges: the exchanges touching it, in order. -/
def ownCourse (x : X) : List E → List E
  | [] => []
  | e :: es => match law.touches e x with
    | true => e :: ownCourse x es
    | false => ownCourse x es

/-- Two exchanges share no relatum. -/
def Apart (e f : E) : Prop :=
  ∀ x, law.touches e x = true → law.touches f x = false

/-- The process of exchanges: a step by `e` reaches the configuration `e` makes, relatum by
relatum. -/
def process : Process (X → σ) E :=
  ⟨fun s e s' => ∀ x, s' x = law.act e s x⟩

/-- A list interleaves given courses where every relatum's own course in it is its given one. -/
def Interleaves (c : X → List E) (L : List E) : Prop :=
  ∀ x, law.ownCourse x L = c x

/-- Whether two exchanges share one of the listed relata. -/
def shares : List X → E → E → Bool
  | [], _, _ => false
  | x :: xs, e, f => (law.touches e x && law.touches f x) || shares xs e f

/-- Every exchange touches some relatum, and every two exchanges are the same or share one. -/
def Connected : Prop :=
  (∀ e, ∃ x, law.touches e x = true) ∧
    ∀ e f, e = f ∨ ∃ x, law.touches e x = true ∧ law.touches f x = true

variable {law}

/-! ## Own courses -/

theorem ownCourse_true {x : X} {e : E} (es : List E) (touch : law.touches e x = true) :
    law.ownCourse x (e :: es) = e :: law.ownCourse x es := by
  show (match law.touches e x with
    | true => e :: law.ownCourse x es
    | false => law.ownCourse x es) = _
  rw [touch]

theorem ownCourse_false {x : X} {e : E} (es : List E) (touch : law.touches e x = false) :
    law.ownCourse x (e :: es) = law.ownCourse x es := by
  show (match law.touches e x with
    | true => e :: law.ownCourse x es
    | false => law.ownCourse x es) = _
  rw [touch]

theorem ownCourse_append (x : X) : ∀ A B : List E,
    law.ownCourse x (A ++ B) = law.ownCourse x A ++ law.ownCourse x B
  | [], _ => rfl
  | a :: A, B => by
    show law.ownCourse x (a :: (A ++ B)) = law.ownCourse x (a :: A) ++ law.ownCourse x B
    cases touch : law.touches a x with
    | true =>
      rw [ownCourse_true _ touch, ownCourse_true _ touch, ownCourse_append x A B]
      rfl
    | false =>
      rw [ownCourse_false _ touch, ownCourse_false _ touch, ownCourse_append x A B]

theorem ownCourse_untouched {x : X} : ∀ {A : List E}, (∀ a, a ∈ A → law.touches a x = false) →
    law.ownCourse x A = []
  | [], _ => rfl
  | a :: A, absent => by
    rw [ownCourse_false _ (absent a (.head A))]
    exact ownCourse_untouched fun b mem => absent b (.tail a mem)

/-! ## Running -/

/-- An exchange taken on agreeing configurations gives agreeing configurations. -/
theorem act_agree (e : E) {s s' : X → σ} (same : ∀ x, s x = s' x) :
    ∀ x, law.act e s x = law.act e s' x := by
  intro x
  cases touch : law.touches e x with
  | false => rw [law.keeps e s x touch, law.keeps e s' x touch]; exact same x
  | true => exact law.reads e s s' x (fun y _ => same y) touch

theorem run_agree : ∀ (L : List E) {s s' : X → σ}, (∀ x, s x = s' x) →
    ∀ x, law.run L s x = law.run L s' x
  | [], _, _, same => same
  | e :: L, _, _, same => run_agree L (act_agree e same)

theorem Apart.symm {e f : E} (apart : law.Apart e f) : law.Apart f e := by
  intro x touch
  cases other : law.touches e x with
  | false => rfl
  | true => exact bool_absurd touch (apart x other)

/-- **Exchanges sharing no relatum commute.** -/
theorem act_comm {e f : E} (apart : law.Apart e f) (s : X → σ) :
    ∀ x, law.act f (law.act e s) x = law.act e (law.act f s) x := by
  intro x
  cases touchE : law.touches e x with
  | true =>
    rw [law.keeps f _ x (apart x touchE)]
    exact (law.reads e (law.act f s) s x
      (fun y touchY => law.keeps f s y (apart y touchY)) touchE).symm
  | false =>
    cases touchF : law.touches f x with
    | false =>
      rw [law.keeps f _ x touchF, law.keeps e s x touchE, law.keeps e _ x touchE,
        law.keeps f s x touchF]
    | true =>
      rw [law.keeps e _ x touchE]
      exact law.reads f (law.act e s) s x
        (fun y touchY => law.keeps e s y (apart.symm y touchY)) touchF

/-- **Moving an exchange forward past exchanges sharing no relatum with it** reaches the same
configuration. -/
theorem run_move {e : E} (B : List E) : ∀ (A : List E), (∀ a, a ∈ A → law.Apart e a) →
    ∀ s x, law.run (A ++ e :: B) s x = law.run (e :: (A ++ B)) s x
  | [], _, _, _ => rfl
  | a :: A, apart, s, x => by
    show law.run (A ++ e :: B) (law.act a s) x = law.run (A ++ B) (law.act a (law.act e s)) x
    rw [run_move B A (fun b mem => apart b (.tail a mem)) (law.act a s) x]
    exact run_agree (A ++ B) (fun y => (act_comm (apart a (.head A)) s y).symm) x

/-- A list of exchanges touching no relatum leaves every relatum as it was. -/
theorem run_idle : ∀ {L : List E}, (∀ x, law.ownCourse x L = []) →
    ∀ s x, law.run L s x = s x
  | [], _, _, _ => rfl
  | e :: L, idle, s, x => by
    have untouched : ∀ y, law.touches e y = false := by
      intro y
      cases touch : law.touches e y with
      | false => rfl
      | true => exact absurd ((ownCourse_true L touch).symm.trans (idle y)) cons_ne_nil
    have rest : ∀ y, law.ownCourse y L = [] := fun y =>
      (ownCourse_false L (untouched y)).symm.trans (idle y)
    show law.run L (law.act e s) x = s x
    rw [run_agree L (fun y => law.keeps e s y (untouched y)) x]
    exact run_idle rest s x

/-! ## Listed relata -/

theorem shares_of_mem {e f : E} {x : X} (touchE : law.touches e x = true)
    (touchF : law.touches f x = true) : ∀ {xs : List X}, x ∈ xs → law.shares xs e f = true
  | y :: xs, mem => by
    show (law.touches e y && law.touches f y || law.shares xs e f) = true
    match mem_cons_cases mem with
    | .inl same =>
      rw [← same, touchE, touchF]
      rfl
    | .inr rest =>
      rw [shares_of_mem touchE touchF rest]
      cases (law.touches e y && law.touches f y) <;> rfl

theorem exists_of_shares {e f : E} : ∀ {xs : List X}, law.shares xs e f = true →
    ∃ x, law.touches e x = true ∧ law.touches f x = true
  | [], yes => Bool.noConfusion yes
  | x :: xs, yes => by
    have h : (law.touches e x && law.touches f x || law.shares xs e f) = true := yes
    cases touchE : law.touches e x with
    | false =>
      rw [touchE] at h
      exact exists_of_shares h
    | true =>
      cases touchF : law.touches f x with
      | true => exact ⟨x, touchE, touchF⟩
      | false =>
        rw [touchE, touchF] at h
        exact exists_of_shares h

theorem apart_of_shares {xs : List X} (listed : ∀ x, x ∈ xs) {e f : E}
    (no : law.shares xs e f = false) : law.Apart e f := by
  intro x touchE
  cases touchF : law.touches f x with
  | false => rfl
  | true => exact bool_absurd (shares_of_mem touchE touchF (listed x)) no

theorem untouched_of_shares {xs : List X} (listed : ∀ x, x ∈ xs) {e : E}
    (no : law.shares xs e e = false) (x : X) : law.touches e x = false := by
  cases touch : law.touches e x with
  | false => rfl
  | true => exact bool_absurd (shares_of_mem touch touch (listed x)) no

/-- **Where `e` heads the own course of every relatum it touches in `M`**, and touches one, `M` is
`A ++ e :: B` with every exchange of `A` sharing no relatum with `e`: `e` is first in `M` at every
relatum it touches, and at every other relatum `M` and `A ++ B` have the same own course. -/
theorem split_heads {xs : List X} (listed : ∀ x, x ∈ xs) {e : E} {x₀ : X}
    (touch : law.touches e x₀ = true) {M : List E}
    (headsAt : ∀ x, law.touches e x = true → ∃ m, law.ownCourse x M = e :: m) :
    ∃ A B, M = A ++ e :: B ∧ (∀ a, a ∈ A → law.Apart e a) ∧
      (∀ x, law.touches e x = true → law.ownCourse x M = e :: law.ownCourse x (A ++ B)) ∧
      (∀ x, law.touches e x = false → law.ownCourse x M = law.ownCourse x (A ++ B)) := by
  match split_first (law.shares xs e) M with
  | .inl absent =>
    match headsAt x₀ touch with
    | ⟨m, h⟩ =>
      have empty : law.ownCourse x₀ M = [] :=
        ownCourse_untouched fun f mem => apart_of_shares listed (absent f mem) x₀ touch
      exact absurd (h.symm.trans empty) cons_ne_nil
  | .inr ⟨A, f, B, split, before, found⟩ =>
    have apartA : ∀ a, a ∈ A → law.Apart e a := fun a mem => apart_of_shares listed (before a mem)
    match exists_of_shares found with
    | ⟨x₁, touchE, touchF⟩ =>
      match headsAt x₁ touchE with
      | ⟨m, h⟩ =>
        have h' : f :: law.ownCourse x₁ B = e :: m := by
          rw [split, ownCourse_append, ownCourse_untouched (fun a mem => apartA a mem x₁ touchE),
            ownCourse_true B touchF] at h
          exact h
        have heads : e = f := (cons_heads h').symm
        subst heads
        refine ⟨A, B, split, apartA, fun x touchX => ?_, fun x touchX => ?_⟩
        · rw [split, ownCourse_append, ownCourse_append,
            ownCourse_untouched (fun a mem => apartA a mem x touchX), ownCourse_true B touchX]
          rfl
        · rw [split, ownCourse_append, ownCourse_append, ownCourse_false B touchX]

/-! ## The interleaving carries nothing the relata do not -/

/-- **Equal own courses, equal configurations.** With the relata listed, two lists of exchanges
giving every relatum the same own course reach the same configuration from the same start. -/
theorem run_of_courses {xs : List X} (listed : ∀ x, x ∈ xs) : ∀ (L M : List E),
    (∀ x, law.ownCourse x L = law.ownCourse x M) → ∀ s x, law.run L s x = law.run M s x
  | [], M, same, s, x => (run_idle (fun y => (same y).symm) s x).symm
  | e :: L, M, same, s, x => by
    cases hit : law.shares xs e e with
    | false =>
      have untouched := untouched_of_shares listed hit
      have rest : ∀ y, law.ownCourse y L = law.ownCourse y M := fun y =>
        (ownCourse_false L (untouched y)).symm.trans (same y)
      show law.run L (law.act e s) x = law.run M s x
      rw [run_agree L (fun y => law.keeps e s y (untouched y)) x]
      exact run_of_courses listed L M rest s x
    | true =>
      match exists_of_shares hit with
      | ⟨x₀, touch, _⟩ =>
        match split_heads listed touch (M := M)
          (fun y touchY => ⟨law.ownCourse y L, ((same y).symm.trans (ownCourse_true L touchY))⟩)
        with
        | ⟨A, B, split, apartA, onTouched, onOther⟩ =>
          have rest : ∀ y, law.ownCourse y L = law.ownCourse y (A ++ B) := fun y => by
            cases touchY : law.touches e y with
            | true =>
              have h := (ownCourse_true L touchY).symm.trans ((same y).trans (onTouched y touchY))
              exact cons_tails h
            | false =>
              exact (ownCourse_false L touchY).symm.trans ((same y).trans (onOther y touchY))
          rw [split, run_move B A apartA s x]
          exact run_of_courses listed L (A ++ B) rest (law.act e s) x

/-! ## The exchange process -/

theorem trace_run : ∀ {s t : X → σ} {L : List E}, Trace law.process s L t →
    ∀ x, t x = law.run L s x
  | _, _, [], .nil _, _ => rfl
  | s, _, e :: L, .cons step rest, x => by
    show _ = law.run L (law.act e s) x
    rw [trace_run rest x]
    exact run_agree L step x

theorem run_trace : ∀ (s : X → σ) (L : List E), Trace law.process s L (law.run L s)
  | s, [] => .nil s
  | s, e :: L => .cons (fun _ => rfl) (run_trace (law.act e s) L)

/-- **The traces of the exchange process carry nothing the relata's own courses do not**: two
traces from one configuration whose lists give every relatum the same own course end at the same
configuration. -/
theorem trace_of_courses {xs : List X} (listed : ∀ x, x ∈ xs) {s t t' : X → σ} {L M : List E}
    (first : Trace law.process s L t) (second : Trace law.process s M t')
    (same : ∀ x, law.ownCourse x L = law.ownCourse x M) : ∀ x, t x = t' x := fun x =>
  (trace_run first x).trans ((run_of_courses listed L M same s x).trans (trace_run second x).symm)

/-- **Two traces interleaving the same courses end at the same configuration**: which interleaving is
taken changes nothing the configurations read. -/
theorem trace_of_interleavings {xs : List X} (listed : ∀ x, x ∈ xs) {c : X → List E}
    {s t t' : X → σ} {L M : List E} (first : Trace law.process s L t)
    (second : Trace law.process s M t') (inL : law.Interleaves c L) (inM : law.Interleaves c M) :
    ∀ x, t x = t' x :=
  trace_of_courses listed first second fun y => (inL y).trans (inM y).symm

/-! ## Two exchanges sharing no relatum -/

theorem swap_courses {e f : E} (apart : law.Apart e f) (x : X) :
    law.ownCourse x [e, f] = law.ownCourse x [f, e] := by
  cases touchE : law.touches e x with
  | true =>
    rw [ownCourse_true _ touchE, ownCourse_false _ (apart x touchE),
      ownCourse_false _ (apart x touchE), ownCourse_true _ touchE]
  | false =>
    rw [ownCourse_false _ touchE]
    cases touchF : law.touches f x with
    | true => rw [ownCourse_true _ touchF, ownCourse_true _ touchF, ownCourse_false _ touchE]
    | false => rw [ownCourse_false _ touchF, ownCourse_false _ touchF, ownCourse_false _ touchE]

/-- **Two exchanges sharing no relatum, taken in either order, end at the same configuration.** -/
theorem trace_swap {xs : List X} (listed : ∀ x, x ∈ xs) {e f : E} (apart : law.Apart e f)
    {s t t' : X → σ} (first : Trace law.process s [e, f] t) (second : Trace law.process s [f, e] t') :
    ∀ x, t x = t' x :=
  trace_of_courses listed first second (swap_courses apart)

/-! ## Exactly where the own courses fix the interleaving -/

theorem eq_of_courses (connected : law.Connected) : ∀ (L M : List E),
    (∀ x, law.ownCourse x L = law.ownCourse x M) → L = M
  | [], [], _ => rfl
  | [], f :: _, same => match connected.1 f with
    | ⟨x, touch⟩ => absurd ((same x).trans (ownCourse_true _ touch)).symm cons_ne_nil
  | e :: _, [], same => match connected.1 e with
    | ⟨x, touch⟩ => absurd ((ownCourse_true _ touch).symm.trans (same x)) cons_ne_nil
  | e :: L, f :: M, same => by
    have heads : e = f := match connected.2 e f with
      | .inl same' => same'
      | .inr ⟨x, touchE, touchF⟩ => by
        have h := same x
        rw [ownCourse_true L touchE, ownCourse_true M touchF] at h
        exact cons_heads h
    subst heads
    have rest : ∀ x, law.ownCourse x L = law.ownCourse x M := fun x => by
      have h := same x
      cases touch : law.touches e x with
      | true =>
        rw [ownCourse_true L touch, ownCourse_true M touch] at h
        exact cons_tails h
      | false =>
        rw [ownCourse_false L touch, ownCourse_false M touch] at h
        exact h
    rw [eq_of_courses connected L M rest]

/-- **The own courses fix the interleaving exactly where every exchange touches a relatum and every
two exchanges are the same or share one**, with the relata listed. -/
theorem unique_iff {xs : List X} (listed : ∀ x, x ∈ xs) :
    (∀ L M : List E, (∀ x, law.ownCourse x L = law.ownCourse x M) → L = M) ↔ law.Connected := by
  constructor
  · intro unique
    constructor
    · intro e
      cases hit : law.shares xs e e with
      | true => match exists_of_shares hit with
        | ⟨x, touch, _⟩ => exact ⟨x, touch⟩
      | false =>
        exact absurd (unique [e] [] fun y => ownCourse_false []
          (untouched_of_shares listed hit y)) cons_ne_nil
    · intro e f
      cases both : law.shares xs e f with
      | true => exact .inr (exists_of_shares both)
      | false => exact .inl (cons_heads (unique [e, f] [f, e]
          (swap_courses (apart_of_shares listed both))))
  · exact eq_of_courses

/-- **The same, read on the traces of the exchange process** from any one configuration. -/
theorem traced_unique_iff {xs : List X} (listed : ∀ x, x ∈ xs) (s : X → σ) :
    (∀ (L M : List E) (t t' : X → σ), Trace law.process s L t → Trace law.process s M t' →
      (∀ x, law.ownCourse x L = law.ownCourse x M) → L = M) ↔ law.Connected := by
  refine Iff.trans ⟨fun unique L M same => ?_, fun unique L M _ _ _ _ same => unique L M same⟩
    (unique_iff listed)
  exact unique L M _ _ (run_trace s L) (run_trace s M) same

/-! ## Building the index -/

section Schedule

variable [DecidableEq E]

variable (law) in
/-- Whether `e` heads the course of every listed relatum it touches. -/
def ready (c : X → List E) : List X → E → Bool
  | [], _ => true
  | x :: xs, e => (!law.touches e x || heads (c x) e) && ready c xs e
where
  /-- Whether `e` heads a course. -/
  heads : List E → E → Bool
    | [], _ => false
    | a :: _, e => decide (a = e)

variable (law) in
/-- `e` dropped from the courses of the relata it touches. -/
def pop (e : E) (c : X → List E) : X → List E := fun x =>
  match law.touches e x with
  | true => (c x).tail
  | false => c x

variable (law) in
/-- A ready exchange heading the course of a listed relatum it touches, the first such in the
listing, if any. -/
def pick (c : X → List E) (all : List X) : List X → Option E
  | [] => none
  | x :: xs => match c x with
    | [] => pick c all xs
    | e :: _ => match law.touches e x && law.ready c all e with
      | true => some e
      | false => pick c all xs

/-- Whether every listed course is empty. -/
def done (c : X → List E) : List X → Bool
  | [] => true
  | x :: xs => match c x with
    | [] => done c xs
    | _ :: _ => false

/-- The total length of the listed courses. -/
def total (c : X → List E) : List X → Nat
  | [] => 0
  | x :: xs => (c x).length + total c xs

variable (law) in
/-- **The scheduler**: while some course remains, take a ready exchange and drop it. -/
def schedule (xs : List X) : Nat → (X → List E) → Option (List E)
  | 0, c => match done c xs with
    | true => some []
    | false => none
  | n + 1, c => match done c xs with
    | true => some []
    | false => match law.pick c xs xs with
      | none => none
      | some e => (schedule xs n (law.pop e c)).map (e :: ·)

theorem heads_eq : ∀ {l : List E} {e : E}, ready.heads l e = true → ∃ m, l = e :: m
  | [], _, yes => Bool.noConfusion yes
  | _ :: m, _, yes => ⟨m, congrArg (· :: m) (of_decide_eq_true yes)⟩

theorem heads_cons (e : E) (m : List E) : ready.heads (e :: m) e = true :=
  decide_eq_true rfl

theorem ready_heads {c : X → List E} {e : E} : ∀ {xs : List X}, law.ready c xs e = true →
    ∀ x, x ∈ xs → law.touches e x = true → ready.heads (c x) e = true
  | y :: xs, yes, x, mem, touch => by
    have h : ((!law.touches e y || ready.heads (c y) e) && law.ready c xs e) = true := yes
    cases first : (!law.touches e y || ready.heads (c y) e) with
    | false => rw [first] at h; exact Bool.noConfusion h
    | true =>
      rw [first] at h
      match mem_cons_cases mem with
      | .inl same =>
        rw [same] at touch ⊢
        rw [touch] at first
        exact first
      | .inr rest => exact ready_heads h x rest touch

theorem ready_of_heads {c : X → List E} {e : E} : ∀ {xs : List X},
    (∀ x, x ∈ xs → law.touches e x = true → ready.heads (c x) e = true) →
      law.ready c xs e = true
  | [], _ => rfl
  | y :: xs, all => by
    show ((!law.touches e y || ready.heads (c y) e) && law.ready c xs e) = true
    rw [ready_of_heads (fun x mem => all x (.tail y mem))]
    cases touch : law.touches e y with
    | false => rfl
    | true => rw [all y (.head xs) touch]; rfl

omit [DecidableEq E] in
theorem pop_true {e : E} {c : X → List E} {x : X} (touch : law.touches e x = true) :
    law.pop e c x = (c x).tail := by
  show (match law.touches e x with
    | true => (c x).tail
    | false => c x) = _
  rw [touch]

omit [DecidableEq E] in
theorem pop_false {e : E} {c : X → List E} {x : X} (touch : law.touches e x = false) :
    law.pop e c x = c x := by
  show (match law.touches e x with
    | true => (c x).tail
    | false => c x) = _
  rw [touch]

omit [DecidableEq E] in
theorem done_nil {c : X → List E} : ∀ {xs : List X}, done c xs = true → ∀ x, x ∈ xs → c x = []
  | y :: xs, yes, x, mem => by
    have h : (match c y with | [] => done c xs | _ :: _ => false) = true := yes
    match hy : c y with
    | [] =>
      rw [hy] at h
      match mem_cons_cases mem with
      | .inl same => rw [same]; exact hy
      | .inr rest => exact done_nil h x rest
    | _ :: _ =>
      rw [hy] at h
      exact Bool.noConfusion h

omit [DecidableEq E] in
theorem not_done {c : X → List E} : ∀ {xs : List X}, done c xs = false →
    ∃ x e m, x ∈ xs ∧ c x = e :: m
  | [], no => Bool.noConfusion no
  | y :: xs, no => by
    have h : (match c y with | [] => done c xs | _ :: _ => false) = false := no
    match hy : c y with
    | [] =>
      rw [hy] at h
      match not_done h with
      | ⟨x, e, m, mem, hx⟩ => exact ⟨x, e, m, .tail y mem, hx⟩
    | a :: m => exact ⟨y, a, m, .head xs, hy⟩

theorem pick_cons (c : X → List E) (all : List X) (y : X) (xs : List X) :
    law.pick c all (y :: xs) = (match c y with
      | [] => law.pick c all xs
      | e :: _ => match law.touches e y && law.ready c all e with
        | true => some e
        | false => law.pick c all xs) := rfl

theorem pick_nil_head {c : X → List E} {all : List X} {y : X} (xs : List X) (hy : c y = []) :
    law.pick c all (y :: xs) = law.pick c all xs := by
  rw [pick_cons, hy]

theorem pick_cons_head {c : X → List E} {all : List X} {y : X} (xs : List X) {a : E} {m : List E}
    (hy : c y = a :: m) :
    law.pick c all (y :: xs) = (match law.touches a y && law.ready c all a with
      | true => some a
      | false => law.pick c all xs) := by
  rw [pick_cons, hy]

theorem pick_spec {c : X → List E} {all : List X} {e : E} : ∀ {xs : List X},
    law.pick c all xs = some e →
      ∃ x m, x ∈ xs ∧ c x = e :: m ∧ law.touches e x = true ∧ law.ready c all e = true
  | [], no => nomatch no
  | y :: xs, found => by
    match hy : c y with
    | [] =>
      rw [pick_nil_head xs hy] at found
      match pick_spec found with
      | ⟨x, m, mem, hx, touch, isReady⟩ => exact ⟨x, m, .tail y mem, hx, touch, isReady⟩
    | a :: m =>
      rw [pick_cons_head xs hy] at found
      cases test : (law.touches a y && law.ready c all a) with
      | true =>
        rw [test] at found
        change some a = some e at found
        have same : a = e := Option.some.inj found
        subst same
        cases touch : law.touches a y with
        | false => rw [touch] at test; exact Bool.noConfusion test
        | true =>
          rw [touch] at test
          exact ⟨y, m, .head xs, hy, touch, test⟩
      | false =>
        rw [test] at found
        change law.pick c all xs = some e at found
        match pick_spec found with
        | ⟨x, m', mem, hx, touch, isReady⟩ => exact ⟨x, m', .tail y mem, hx, touch, isReady⟩

theorem pick_some {c : X → List E} {all : List X} {e : E} {x : X} {m : List E}
    (touch : law.touches e x = true) (isReady : law.ready c all e = true) (hx : c x = e :: m) :
    ∀ {xs : List X}, x ∈ xs → ∃ e', law.pick c all xs = some e'
  | y :: xs, mem => by
    match hy : c y with
    | [] =>
      rw [pick_nil_head xs hy]
      match mem_cons_cases mem with
      | .inl same => rw [same] at hx; exact nomatch (hy.symm.trans hx)
      | .inr rest => exact pick_some touch isReady hx rest
    | a :: m' =>
      rw [pick_cons_head xs hy]
      cases test : (law.touches a y && law.ready c all a) with
      | true => exact ⟨a, rfl⟩
      | false =>
        change ∃ e', law.pick c all xs = some e'
        match mem_cons_cases mem with
        | .inl same =>
          rw [same] at hx touch
          have heads : a = e := cons_heads (hy.symm.trans hx)
          rw [heads, touch, isReady] at test
          exact Bool.noConfusion test
        | .inr rest => exact pick_some touch isReady hx rest

theorem schedule_zero (xs : List X) (c : X → List E) :
    law.schedule xs 0 c = (match done c xs with
      | true => some []
      | false => none) := rfl

theorem schedule_succ (xs : List X) (n : Nat) (c : X → List E) :
    law.schedule xs (n + 1) c = (match done c xs with
      | true => some []
      | false => match law.pick c xs xs with
        | none => none
        | some e => (law.schedule xs n (law.pop e c)).map (e :: ·)) := rfl

/-- **What the scheduler returns interleaves the courses**, the relata listed. -/
theorem schedule_interleaves {xs : List X} (listed : ∀ x, x ∈ xs) : ∀ (n : Nat) (c : X → List E)
    (L : List E), law.schedule xs n c = some L → law.Interleaves c L
  | 0, c, L, result => by
    rw [schedule_zero] at result
    cases fin : done c xs with
    | true =>
      rw [fin] at result
      change some [] = some L at result
      have same : [] = L := Option.some.inj result
      subst same
      exact fun x => (done_nil fin x (listed x)).symm
    | false =>
      rw [fin] at result
      exact nomatch result
  | n + 1, c, L, result => by
    rw [schedule_succ] at result
    cases fin : done c xs with
    | true =>
      rw [fin] at result
      change some [] = some L at result
      have same : [] = L := Option.some.inj result
      subst same
      exact fun x => (done_nil fin x (listed x)).symm
    | false =>
      rw [fin] at result
      change (match law.pick c xs xs with
        | none => none
        | some e => (law.schedule xs n (law.pop e c)).map (e :: ·)) = some L at result
      cases found : law.pick c xs xs with
      | none =>
        rw [found] at result
        exact nomatch result
      | some e =>
        rw [found] at result
        change (law.schedule xs n (law.pop e c)).map (e :: ·) = some L at result
        match hrest : law.schedule xs n (law.pop e c) with
        | none =>
          rw [hrest] at result
          exact nomatch result
        | some L' =>
          rw [hrest] at result
          change some (e :: L') = some L at result
          have same : e :: L' = L := Option.some.inj result
          subst same
          have rest := schedule_interleaves listed n (law.pop e c) L' hrest
          match pick_spec found with
          | ⟨_, _, _, _, _, isReady⟩ =>
            intro x
            cases touch : law.touches e x with
            | true =>
              rw [ownCourse_true L' touch, rest x, pop_true touch]
              match heads_eq (ready_heads isReady x (listed x) touch) with
              | ⟨m, hx⟩ => rw [hx]; rfl
            | false =>
              rw [ownCourse_false L' touch, rest x, pop_false touch]

/-- **Where some list interleaves the courses, every ready exchange can be taken first**: the
courses with it dropped are interleaved by the list with it moved out. -/
theorem pop_interleaves {xs : List X} (listed : ∀ x, x ∈ xs) {c : X → List E} {L : List E}
    (inter : law.Interleaves c L) {e : E} {x₀ : X} (touch : law.touches e x₀ = true)
    (isReady : law.ready c xs e = true) :
    ∃ A B, L = A ++ e :: B ∧ law.Interleaves (law.pop e c) (A ++ B) := by
  match split_heads listed touch (M := L) (fun x touchX =>
      match heads_eq (ready_heads isReady x (listed x) touchX) with
      | ⟨m, hx⟩ => ⟨m, (inter x).trans hx⟩) with
  | ⟨A, B, split, _, onTouched, onOther⟩ =>
    refine ⟨A, B, split, fun x => ?_⟩
    cases touchX : law.touches e x with
    | true =>
      rw [pop_true touchX, ← inter x, onTouched x touchX]
      rfl
    | false =>
      rw [pop_false touchX, ← inter x, onOther x touchX]

omit [DecidableEq E] in
theorem total_le {c c' : X → List E} (le : ∀ x, (c x).length ≤ (c' x).length) :
    ∀ xs : List X, total c xs ≤ total c' xs
  | [] => Nat.le_refl 0
  | x :: xs => Nat.add_le_add (le x) (total_le le xs)

omit [DecidableEq E] in
theorem total_lt {c c' : X → List E} (le : ∀ x, (c x).length ≤ (c' x).length) {x₀ : X}
    (lt : (c x₀).length + 1 ≤ (c' x₀).length) : ∀ {xs : List X}, x₀ ∈ xs →
      total c xs + 1 ≤ total c' xs
  | y :: xs, mem => by
    show (c y).length + total c xs + 1 ≤ (c' y).length + total c' xs
    match mem_cons_cases mem with
    | .inl same =>
      rw [Nat.add_right_comm]
      rw [same] at lt
      exact Nat.add_le_add lt (total_le le xs)
    | .inr rest =>
      rw [Nat.add_assoc]
      exact Nat.add_le_add (le y) (total_lt le lt rest)

omit [DecidableEq E] in
theorem total_pos {c : X → List E} {x : X} {e : E} {m : List E} (hx : c x = e :: m) :
    ∀ {xs : List X}, x ∈ xs → 1 ≤ total c xs
  | y :: xs, mem => by
    show 1 ≤ (c y).length + total c xs
    match mem_cons_cases mem with
    | .inl same =>
      rw [← same, hx]
      exact Nat.le_trans (Nat.succ_le_succ (Nat.zero_le m.length)) (Nat.le_add_right _ _)
    | .inr rest => exact Nat.le_trans (total_pos hx rest) (Nat.le_add_left _ _)

omit [DecidableEq E] in
theorem total_pop {xs : List X} {e : E} {c : X → List E} {x₀ : X} {m₀ : List E}
    (touch : law.touches e x₀ = true) (hx : c x₀ = e :: m₀) (mem : x₀ ∈ xs) :
    total (law.pop e c) xs + 1 ≤ total c xs := by
  refine total_lt (fun x => ?_) ?_ mem
  · cases touchX : law.touches e x with
    | true => rw [pop_true touchX]; exact length_tail_le (c x)
    | false => rw [pop_false touchX]; exact Nat.le_refl _
  · rw [pop_true touch, hx]
    exact Nat.le_refl _

/-- **Where some list interleaves the courses, the scheduler completes** with enough steps. -/
theorem schedule_some {xs : List X} (listed : ∀ x, x ∈ xs) : ∀ (n : Nat) (c : X → List E)
    (L : List E), law.Interleaves c L → total c xs ≤ n → ∃ L', law.schedule xs n c = some L'
  | n, c, L, inter, bound => by
    cases fin : done c xs with
    | true =>
      match n with
      | 0 => exact ⟨[], by rw [schedule_zero, fin]⟩
      | _ + 1 => exact ⟨[], by rw [schedule_succ, fin]⟩
    | false =>
      match not_done fin with
      | ⟨x, e, m, mem, hx⟩ =>
        match n with
        | 0 => exact absurd (Nat.le_trans (total_pos hx mem) bound) (Nat.not_succ_le_zero 0)
        | n + 1 =>
          -- an exchange ready in `c`: the first exchange of `L` touching a relatum
          have ready_exists : ∃ g x₁ m₁, law.touches g x₁ = true ∧ c x₁ = g :: m₁ ∧
              law.ready c xs g = true := by
            match split_first (fun a => law.shares xs a a) L with
            | .inl absent =>
              have empty : law.ownCourse x L = [] :=
                ownCourse_untouched fun a mem' => untouched_of_shares listed (absent a mem') x
              have h := (inter x).symm.trans empty
              rw [hx] at h
              exact absurd h cons_ne_nil
            | .inr ⟨A, g, B, split, before, found⟩ =>
              have untouchedA : ∀ a, a ∈ A → ∀ y, law.touches a y = false := fun a mem' y =>
                untouched_of_shares listed (before a mem') y
              have headsG : ∀ y, law.touches g y = true → c y = g :: law.ownCourse y B := by
                intro y touchY
                rw [← inter y, split, ownCourse_append,
                  ownCourse_untouched (fun a mem' => untouchedA a mem' y), ownCourse_true B touchY]
                rfl
              match exists_of_shares found with
              | ⟨x₁, touch₁, _⟩ =>
                exact ⟨g, x₁, law.ownCourse x₁ B, touch₁, headsG x₁ touch₁,
                  ready_of_heads fun y _ touchY => by
                    rw [headsG y touchY]
                    exact heads_cons g _⟩
          match ready_exists with
          | ⟨g, x₁, m₁, touch₁, hx₁, readyG⟩ =>
            match pick_some touch₁ readyG hx₁ (listed x₁) with
            | ⟨e', found⟩ =>
              match pick_spec found with
              | ⟨x', m', mem', hx', touch', ready'⟩ =>
                match pop_interleaves listed inter touch' ready' with
                | ⟨A, B, _, inter'⟩ =>
                  have bound' : total (law.pop e' c) xs ≤ n :=
                    Nat.le_of_succ_le_succ (Nat.le_trans (total_pop touch' hx' mem') bound)
                  match schedule_some listed n (law.pop e' c) (A ++ B) inter' bound' with
                  | ⟨L', result⟩ =>
                    exact ⟨e' :: L', by
                      rw [schedule_succ, fin]
                      change (match law.pick c xs xs with
                        | none => none
                        | some e => (law.schedule xs n (law.pop e c)).map (e :: ·)) = _
                      rw [found]
                      change (law.schedule xs n (law.pop e' c)).map (e' :: ·) = _
                      rw [result]
                      rfl⟩

/-- **An interleaving of given courses exists exactly where the scheduler completes**, run with as
many steps as the courses have exchanges in all; the relata listed and exchanges told apart. -/
theorem schedule_iff {xs : List X} (listed : ∀ x, x ∈ xs) (c : X → List E) :
    (∃ L, law.Interleaves c L) ↔ ∃ L, law.schedule xs (total c xs) c = some L :=
  ⟨fun ⟨L, inter⟩ => schedule_some listed _ c L inter (Nat.le_refl _),
   fun ⟨L, result⟩ => ⟨L, schedule_interleaves listed _ c L result⟩⟩

/-- **A trace of the exchange process taking every relatum through its given course exists exactly
where the scheduler completes**, from any configuration. -/
theorem traced_iff {xs : List X} (listed : ∀ x, x ∈ xs) (c : X → List E) (s : X → σ) :
    (∃ L t, law.Interleaves c L ∧ Trace law.process s L t) ↔
      ∃ L, law.schedule xs (total c xs) c = some L :=
  Iff.trans ⟨fun ⟨L, _, inter, _⟩ => ⟨L, inter⟩, fun ⟨L, inter⟩ => ⟨L, _, inter, run_trace s L⟩⟩
    (schedule_iff listed c)

end Schedule


/-! ## Each relatum's course of standings -/

variable (law) in
/-- What a relatum stands at after each exchange of its own course, in order. -/
def standings (x : X) : List E → (X → σ) → List σ
  | [], _ => []
  | e :: es, s => match law.touches e x with
    | true => law.act e s x :: standings x es (law.act e s)
    | false => standings x es (law.act e s)

theorem standings_true {x : X} {e : E} (es : List E) (s : X → σ) (touch : law.touches e x = true) :
    law.standings x (e :: es) s = law.act e s x :: law.standings x es (law.act e s) := by
  show (match law.touches e x with
    | true => law.act e s x :: law.standings x es (law.act e s)
    | false => law.standings x es (law.act e s)) = _
  rw [touch]

theorem standings_false {x : X} {e : E} (es : List E) (s : X → σ)
    (touch : law.touches e x = false) :
    law.standings x (e :: es) s = law.standings x es (law.act e s) := by
  show (match law.touches e x with
    | true => law.act e s x :: law.standings x es (law.act e s)
    | false => law.standings x es (law.act e s)) = _
  rw [touch]

/-- Agreeing configurations give every relatum the same course of standings. -/
theorem standings_agree (x : X) : ∀ (L : List E) {s s' : X → σ}, (∀ y, s y = s' y) →
    law.standings x L s = law.standings x L s'
  | [], _, _, _ => rfl
  | e :: L, s, s', same => by
    cases touch : law.touches e x with
    | true =>
      rw [standings_true L s touch, standings_true L s' touch, act_agree e same x,
        standings_agree x L (act_agree e same)]
    | false =>
      rw [standings_false L s touch, standings_false L s' touch,
        standings_agree x L (act_agree e same)]

/-- **Moving an exchange forward past exchanges sharing no relatum with it** leaves every relatum's
course of standings as it was. -/
theorem standings_move (x : X) {e : E} (B : List E) : ∀ (A : List E), (∀ a, a ∈ A → law.Apart e a) →
    ∀ s, law.standings x (A ++ e :: B) s = law.standings x (e :: (A ++ B)) s
  | [], _, _ => rfl
  | a :: A, apart, s => by
    have apartA : law.Apart e a := apart a (.head A)
    have rest := standings_move x B A (fun b mem => apart b (.tail a mem)) (law.act a s)
    have tail : law.standings x (A ++ B) (law.act e (law.act a s)) =
        law.standings x (A ++ B) (law.act a (law.act e s)) :=
      standings_agree x (A ++ B) (fun y => (act_comm apartA s y).symm)
    show law.standings x (a :: (A ++ e :: B)) s = law.standings x (e :: a :: (A ++ B)) s
    cases touchA : law.touches a x with
    | true =>
      have touchE : law.touches e x = false := apartA.symm x touchA
      rw [standings_true (A ++ e :: B) s touchA, rest, standings_false (A ++ B) (law.act a s) touchE,
        standings_false (a :: (A ++ B)) s touchE, standings_true (A ++ B) (law.act e s) touchA, tail,
        law.reads a (law.act e s) s x (fun y touchY => law.keeps e s y (apartA.symm y touchY))
          touchA]
    | false =>
      rw [standings_false (A ++ e :: B) s touchA, rest]
      cases touchE : law.touches e x with
      | true =>
        rw [standings_true (A ++ B) (law.act a s) touchE, standings_true (a :: (A ++ B)) s touchE,
          standings_false (A ++ B) (law.act e s) touchA, tail,
          law.reads e (law.act a s) s x (fun y touchY => law.keeps a s y (apartA y touchY)) touchE]
      | false =>
        rw [standings_false (A ++ B) (law.act a s) touchE, standings_false (a :: (A ++ B)) s touchE,
          standings_false (A ++ B) (law.act e s) touchA, tail]

/-- A list of exchanges touching no relatum gives no relatum a standing. -/
theorem standings_idle (x : X) : ∀ {L : List E}, (∀ y, law.ownCourse y L = []) →
    ∀ s, law.standings x L s = []
  | [], _, _ => rfl
  | e :: L, idle, s => by
    have untouched : ∀ y, law.touches e y = false := by
      intro y
      cases touch : law.touches e y with
      | false => rfl
      | true => exact absurd ((ownCourse_true L touch).symm.trans (idle y)) cons_ne_nil
    rw [standings_false L s (untouched x)]
    exact standings_idle x (fun y => (ownCourse_false L (untouched y)).symm.trans (idle y)) _

/-- **Equal own courses, equal courses of standings.** With the relata listed, two lists of
exchanges giving every relatum the same own course give every relatum, from the same start, the
same standings after each of its own exchanges, in the same order. -/
theorem standings_of_courses {xs : List X} (listed : ∀ x, x ∈ xs) : ∀ (L M : List E),
    (∀ x, law.ownCourse x L = law.ownCourse x M) → ∀ s x, law.standings x L s = law.standings x M s
  | [], M, same, s, x => (standings_idle x (fun y => (same y).symm) s).symm
  | e :: L, M, same, s, x => by
    cases hit : law.shares xs e e with
    | false =>
      have untouched := untouched_of_shares listed hit
      have rest : ∀ y, law.ownCourse y L = law.ownCourse y M := fun y =>
        (ownCourse_false L (untouched y)).symm.trans (same y)
      rw [standings_false L s (untouched x),
        standings_agree x L (fun y => law.keeps e s y (untouched y))]
      exact standings_of_courses listed L M rest s x
    | true =>
      match exists_of_shares hit with
      | ⟨x₀, touch, _⟩ =>
        match split_heads listed touch (M := M)
          (fun y touchY => ⟨law.ownCourse y L, ((same y).symm.trans (ownCourse_true L touchY))⟩)
        with
        | ⟨A, B, split, apartA, onTouched, onOther⟩ =>
          have rest : ∀ y, law.ownCourse y L = law.ownCourse y (A ++ B) := fun y => by
            cases touchY : law.touches e y with
            | true =>
              have h := (ownCourse_true L touchY).symm.trans ((same y).trans (onTouched y touchY))
              exact cons_tails h
            | false =>
              exact (ownCourse_false L touchY).symm.trans ((same y).trans (onOther y touchY))
          rw [split, standings_move x B A apartA s]
          cases touchX : law.touches e x with
          | true =>
            rw [standings_true L s touchX, standings_true (A ++ B) s touchX,
              standings_of_courses listed L (A ++ B) rest (law.act e s) x]
          | false =>
            rw [standings_false L s touchX, standings_false (A ++ B) s touchX]
            exact standings_of_courses listed L (A ++ B) rest (law.act e s) x

/-- **Two interleavings of the same courses give every relatum the same course of standings.** -/
theorem standings_of_interleavings {xs : List X} (listed : ∀ x, x ∈ xs) {c : X → List E}
    {L M : List E} (inL : law.Interleaves c L) (inM : law.Interleaves c M) (s : X → σ) (x : X) :
    law.standings x L s = law.standings x M s :=
  standings_of_courses listed L M (fun y => (inL y).trans (inM y).symm) s x

/-! ## The world an interleaving builds -/

/-- The exchange at step `t` of a list, if the list has one there. -/
def exchangeAt : List E → Nat → Option E
  | [], _ => none
  | e :: _, 0 => some e
  | _ :: L, t + 1 => exchangeAt L t

variable (law) in
/-- The configuration after the first `t` exchanges of a list. -/
def runUpTo : List E → (X → σ) → Nat → (X → σ)
  | [], s, _ => s
  | _ :: _, s, 0 => s
  | e :: L, s, t + 1 => runUpTo L (law.act e s) t

/-- Across step `t`, the configuration changes by the exchange at `t`, if any. -/
theorem runUpTo_succ : ∀ (L : List E) (s : X → σ) (t : Nat),
    law.runUpTo L s (t + 1) = match exchangeAt L t with
      | none => law.runUpTo L s t
      | some e => law.act e (law.runUpTo L s t)
  | [], _, _ => rfl
  | [_], _, 0 => rfl
  | _ :: _ :: _, _, 0 => rfl
  | _ :: L, _, t + 1 => runUpTo_succ L _ t

/-- From the list's length on, the configuration is the one the whole list reaches. -/
theorem runUpTo_whole : ∀ (L : List E) (s : X → σ) (t : Nat), L.length ≤ t →
    law.runUpTo L s t = law.run L s
  | [], _, _, _ => rfl
  | _ :: _, _, 0, le => absurd le (Nat.not_succ_le_zero _)
  | _ :: L, _, t + 1, le => runUpTo_whole L _ t (Nat.le_of_succ_le_succ le)

/-- Up to a list's length, appending more changes nothing. -/
theorem runUpTo_append_le : ∀ (A R : List E) (s : X → σ) (t : Nat), t ≤ A.length →
    law.runUpTo (A ++ R) s t = law.runUpTo A s t
  | [], [], _, _, _ => rfl
  | [], _ :: _, _, 0, _ => rfl
  | [], _ :: _, _, _ + 1, le => absurd le (Nat.not_succ_le_zero _)
  | _ :: _, _, _, 0, _ => rfl
  | _ :: A, R, _, t + 1, le => runUpTo_append_le A R _ t (Nat.le_of_succ_le_succ le)

/-- After a list, the configuration is the rest's from where the list ends. -/
theorem runUpTo_append : ∀ (A R : List E) (s : X → σ) (t : Nat),
    law.runUpTo (A ++ R) s (A.length + t) = law.runUpTo R (law.run A s) t
  | [], _, _, _ => (congrArg (law.runUpTo _ _) (Nat.zero_add _))
  | _ :: A, R, s, t =>
    (congrArg (law.runUpTo _ s) (Nat.succ_add A.length t)).trans (runUpTo_append A R _ t)

/-- Agreeing configurations agree after the first `t` exchanges. -/
theorem runUpTo_agree : ∀ (L : List E) {s s' : X → σ}, (∀ y, s y = s' y) → ∀ t y,
    law.runUpTo L s t y = law.runUpTo L s' t y
  | [], _, _, same, _, y => same y
  | _ :: _, _, _, same, 0, y => same y
  | e :: L, _, _, same, t + 1, y => runUpTo_agree L (act_agree e same) t y

/-! ## Each relatum's own steps: the index map between interleavings

A relatum's standing at step `t` of a list is its standing after the own exchanges the first `t`
exchanges hold (`ownCount`), read off its course of standings (`standingAfter`, `runUpTo_own`).
Two interleavings of the same courses give every relatum the same course of standings, so a
relatum stands alike at any two steps, one in each, at which it has taken equally many of its own
exchanges (`runUpTo_of_own`). The index map sends a step of one list to the least step of the
other at which the relatum has taken as many (`firstAt`, `indexMap`, `runUpTo_index`), and at a
step where the relatum takes an exchange it sends the step after to the step after the one at
which it takes the same exchange in the other (`index_matches`). -/

variable (law) in
/-- How many of a relatum's own exchanges the first `t` exchanges of a list hold. -/
def ownCount (x : X) : List E → Nat → Nat
  | [], _ => 0
  | _ :: _, 0 => 0
  | e :: L, t + 1 => match law.touches e x with
    | true => ownCount x L t + 1
    | false => ownCount x L t

/-- What stands after `n` own exchanges, read off the start `d` and the standings after each:
`d` after none, the `n`-th standing after `n`, the last past the end. -/
def afterOwn (d : σ) : List σ → Nat → σ
  | [], _ => d
  | _ :: _, 0 => d
  | a :: as, n + 1 => afterOwn a as n

variable (law) in
/-- **What a relatum stands at after `n` of its own exchanges** in a list, from a start. -/
def standingAfter (x : X) (L : List E) (s : X → σ) (n : Nat) : σ :=
  afterOwn (s x) (law.standings x L s) n

theorem ownCount_true {x : X} {e : E} (L : List E) (t : Nat) (touch : law.touches e x = true) :
    law.ownCount x (e :: L) (t + 1) = law.ownCount x L t + 1 := by
  show (match law.touches e x with
    | true => law.ownCount x L t + 1
    | false => law.ownCount x L t) = _
  rw [touch]

theorem ownCount_false {x : X} {e : E} (L : List E) (t : Nat) (touch : law.touches e x = false) :
    law.ownCount x (e :: L) (t + 1) = law.ownCount x L t := by
  show (match law.touches e x with
    | true => law.ownCount x L t + 1
    | false => law.ownCount x L t) = _
  rw [touch]

theorem ownCount_zero (x : X) : ∀ L : List E, law.ownCount x L 0 = 0
  | [] => rfl
  | _ :: _ => rfl

theorem afterOwn_zero (d : σ) : ∀ ss : List σ, afterOwn d ss 0 = d
  | [] => rfl
  | _ :: _ => rfl

/-- **A relatum's standing at a step is its standing after its own exchanges so far.** At step `t`
of a list, a relatum stands where it stands after the own exchanges the first `t` exchanges hold. -/
theorem runUpTo_own (x : X) : ∀ (L : List E) (s : X → σ) (t : Nat),
    law.runUpTo L s t x = law.standingAfter x L s (law.ownCount x L t)
  | [], _, _ => rfl
  | e :: L, s, 0 => (afterOwn_zero (s x) (law.standings x (e :: L) s)).symm
  | e :: L, s, t + 1 => by
    show law.runUpTo L (law.act e s) t x = _
    rw [runUpTo_own x L (law.act e s) t]
    cases touch : law.touches e x with
    | true =>
      rw [ownCount_true L t touch]
      show _ = afterOwn (s x) (law.standings x (e :: L) s) (law.ownCount x L t + 1)
      rw [standings_true L s touch]
      rfl
    | false =>
      rw [ownCount_false L t touch]
      show afterOwn (law.act e s x) (law.standings x L (law.act e s)) (law.ownCount x L t) =
        afterOwn (s x) (law.standings x (e :: L) s) (law.ownCount x L t)
      rw [standings_false L s touch, law.keeps e s x touch]

/-- **Two interleavings of the same courses read alike through a relatum's own steps**: after `n`
of its own exchanges a relatum stands alike in both. -/
theorem standingAfter_of_interleavings {xs : List X} (listed : ∀ x, x ∈ xs) {c : X → List E}
    {L M : List E} (inL : law.Interleaves c L) (inM : law.Interleaves c M) (s : X → σ) (x : X)
    (n : Nat) : law.standingAfter x L s n = law.standingAfter x M s n :=
  congrArg (fun ss => afterOwn (s x) ss n) (standings_of_interleavings listed inL inM s x)

/-- **Step by step.** In two interleavings of the same courses, a relatum stands at step `t` of
one where it stands at step `t'` of the other, wherever it has taken equally many of its own
exchanges by then. -/
theorem runUpTo_of_own {xs : List X} (listed : ∀ x, x ∈ xs) {c : X → List E} {L M : List E}
    (inL : law.Interleaves c L) (inM : law.Interleaves c M) (s : X → σ) (x : X) {t t' : Nat}
    (same : law.ownCount x L t = law.ownCount x M t') :
    law.runUpTo L s t x = law.runUpTo M s t' x :=
  (runUpTo_own x L s t).trans
    ((standingAfter_of_interleavings listed inL inM s x _).trans
      ((congrArg (law.standingAfter x M s) same).trans (runUpTo_own x M s t').symm))

/-- The own exchanges the first `t` exchanges hold are at most the relatum's own course. -/
theorem ownCount_le (x : X) : ∀ (L : List E) (t : Nat),
    law.ownCount x L t ≤ (law.ownCourse x L).length
  | [], _ => Nat.zero_le _
  | _ :: _, 0 => Nat.zero_le _
  | e :: L, t + 1 => by
    cases touch : law.touches e x with
    | true =>
      rw [ownCount_true L t touch, ownCourse_true L touch]
      exact Nat.succ_le_succ (ownCount_le x L t)
    | false =>
      rw [ownCount_false L t touch, ownCourse_false L touch]
      exact ownCount_le x L t

variable (law) in
/-- **The least step of a list at which a relatum has taken `n` of its own exchanges.** -/
def firstAt (x : X) : List E → Nat → Nat
  | [], _ => 0
  | _ :: _, 0 => 0
  | e :: M, n + 1 => match law.touches e x with
    | true => firstAt x M n + 1
    | false => firstAt x M (n + 1) + 1

theorem firstAt_true {x : X} {e : E} (M : List E) (n : Nat) (touch : law.touches e x = true) :
    law.firstAt x (e :: M) (n + 1) = law.firstAt x M n + 1 := by
  show (match law.touches e x with
    | true => law.firstAt x M n + 1
    | false => law.firstAt x M (n + 1) + 1) = _
  rw [touch]

theorem firstAt_false {x : X} {e : E} (M : List E) (n : Nat) (touch : law.touches e x = false) :
    law.firstAt x (e :: M) (n + 1) = law.firstAt x M (n + 1) + 1 := by
  show (match law.touches e x with
    | true => law.firstAt x M n + 1
    | false => law.firstAt x M (n + 1) + 1) = _
  rw [touch]

/-- By `firstAt x M n` the relatum has taken `n` of its own exchanges, where its course has `n`. -/
theorem ownCount_firstAt (x : X) : ∀ (M : List E) (n : Nat), n ≤ (law.ownCourse x M).length →
    law.ownCount x M (law.firstAt x M n) = n
  | [], _, le => (Nat.eq_zero_of_le_zero le).symm
  | _ :: _, 0, _ => rfl
  | e :: M, n + 1, le => by
    cases touch : law.touches e x with
    | true =>
      rw [ownCourse_true M touch] at le
      rw [firstAt_true M n touch, ownCount_true M _ touch,
        ownCount_firstAt x M n (Nat.le_of_succ_le_succ le)]
    | false =>
      rw [ownCourse_false M touch] at le
      rw [firstAt_false M n touch, ownCount_false M _ touch, ownCount_firstAt x M (n + 1) le]

/-- And no earlier step has: `firstAt` is the least such step. -/
theorem firstAt_least (x : X) : ∀ (M : List E) (n t : Nat), law.ownCount x M t = n →
    law.firstAt x M n ≤ t
  | [], _, _, _ => Nat.zero_le _
  | _ :: _, 0, _, _ => Nat.zero_le _
  | _ :: _, _ + 1, 0, same => Nat.noConfusion same
  | e :: M, n + 1, t + 1, same => by
    cases touch : law.touches e x with
    | true =>
      rw [ownCount_true M t touch] at same
      rw [firstAt_true M n touch]
      exact Nat.succ_le_succ (firstAt_least x M n t (Nat.succ.inj same))
    | false =>
      rw [ownCount_false M t touch] at same
      rw [firstAt_false M n touch]
      exact Nat.succ_le_succ (firstAt_least x M (n + 1) t same)

variable (law) in
/-- **The index map for a relatum**: a step of `L` goes to the least step of `M` at which the
relatum has taken as many of its own exchanges. -/
def indexMap (x : X) (L M : List E) (t : Nat) : Nat :=
  law.firstAt x M (law.ownCount x L t)

/-- Interleavings of the same courses give a relatum own courses of one length. -/
theorem length_of_interleavings {c : X → List E} {L M : List E} (inL : law.Interleaves c L)
    (inM : law.Interleaves c M) (x : X) :
    (law.ownCourse x L).length = (law.ownCourse x M).length :=
  congrArg List.length ((inL x).trans (inM x).symm)

/-- **The index map matches own steps**: at the mapped step the relatum has taken as many of its
own exchanges as at the step mapped. -/
theorem ownCount_index {c : X → List E} {L M : List E} (inL : law.Interleaves c L)
    (inM : law.Interleaves c M) (x : X) (t : Nat) :
    law.ownCount x M (law.indexMap x L M t) = law.ownCount x L t :=
  ownCount_firstAt x M _
    (Nat.le_trans (ownCount_le x L t) (Nat.le_of_eq (length_of_interleavings inL inM x)))

/-- **The configurations of two interleavings agree through the index map**: a relatum stands at
step `t` of one where it stands at the mapped step of the other. -/
theorem runUpTo_index {xs : List X} (listed : ∀ x, x ∈ xs) {c : X → List E} {L M : List E}
    (inL : law.Interleaves c L) (inM : law.Interleaves c M) (s : X → σ) (x : X) (t : Nat) :
    law.runUpTo L s t x = law.runUpTo M s (law.indexMap x L M t) x :=
  runUpTo_of_own listed inL inM s x (ownCount_index inL inM x t).symm

/-- A list has an exchange only at a step before its length. -/
theorem exchangeAt_lt : ∀ {l : List E} {n : Nat} {e : E}, exchangeAt l n = some e → n < l.length
  | [], _, _, h => nomatch h
  | _ :: _, 0, _, _ => Nat.succ_pos _
  | _ :: _, _ + 1, _, h => Nat.succ_lt_succ (exchangeAt_lt h)

/-- At a step where a relatum takes an exchange, the exchange is its own exchange numbered by the
own exchanges before, and the step adds one to them. -/
theorem exchangeAt_own (x : X) : ∀ (L : List E) (t : Nat) {e : E}, exchangeAt L t = some e →
    law.touches e x = true →
    exchangeAt (law.ownCourse x L) (law.ownCount x L t) = some e ∧
      law.ownCount x L (t + 1) = law.ownCount x L t + 1
  | [], _, _, at_t, _ => nomatch at_t
  | a :: L, 0, e, at_t, touch => by
    have same : a = e := Option.some.inj at_t
    subst same
    rw [ownCourse_true L touch, ownCount_true L 0 touch, ownCount_zero x L, ownCount_zero x (a :: L)]
    exact ⟨rfl, rfl⟩
  | a :: L, t + 1, e, at_t, touch => by
    have inner := exchangeAt_own x L t at_t touch
    cases touchA : law.touches a x with
    | true =>
      rw [ownCourse_true L touchA, ownCount_true L t touchA, ownCount_true L (t + 1) touchA,
        inner.2]
      exact ⟨inner.1, rfl⟩
    | false =>
      rw [ownCourse_false L touchA, ownCount_false L t touchA, ownCount_false L (t + 1) touchA]
      exact inner

/-- The least step after which a relatum has taken `n + 1` of its own exchanges follows the step at
which it takes its own exchange numbered `n`. -/
theorem firstAt_succ_step (x : X) : ∀ (M : List E) (n : Nat), n < (law.ownCourse x M).length →
    ∃ p e, law.firstAt x M (n + 1) = p + 1 ∧ exchangeAt M p = some e ∧ law.touches e x = true ∧
      exchangeAt (law.ownCourse x M) n = some e
  | [], _, lt => absurd lt (Nat.not_lt_zero _)
  | a :: M, n, lt => by
    cases touch : law.touches a x with
    | true =>
      rw [ownCourse_true M touch] at lt
      rw [firstAt_true M n touch, ownCourse_true M touch]
      match n with
      | 0 => exact ⟨0, a, by cases M <;> rfl, rfl, touch, rfl⟩
      | n + 1 =>
        match firstAt_succ_step x M n (Nat.lt_of_succ_lt_succ lt) with
        | ⟨p, e, first, at_p, touchE, own⟩ => exact ⟨p + 1, e, by rw [first], at_p, touchE, own⟩
    | false =>
      rw [ownCourse_false M touch] at lt
      rw [firstAt_false M n touch, ownCourse_false M touch]
      match firstAt_succ_step x M n lt with
      | ⟨p, e, first, at_p, touchE, own⟩ => exact ⟨p + 1, e, by rw [first], at_p, touchE, own⟩

/-- **The index map matches each relatum's exchanges.** In two interleavings of the same courses,
where a relatum takes an exchange at step `t` of one, the index map sends `t + 1` to the step after
the one at which it takes the same exchange in the other. -/
theorem index_matches {c : X → List E} {L M : List E} (inL : law.Interleaves c L)
    (inM : law.Interleaves c M) (x : X) {t : Nat} {e : E} (at_t : exchangeAt L t = some e)
    (touch : law.touches e x = true) :
    ∃ p, law.indexMap x L M (t + 1) = p + 1 ∧ exchangeAt M p = some e := by
  have own := exchangeAt_own x L t at_t touch
  have courses : law.ownCourse x L = law.ownCourse x M := (inL x).trans (inM x).symm
  have below : law.ownCount x L t < (law.ownCourse x M).length := by
    rw [← courses]
    exact exchangeAt_lt own.1
  match firstAt_succ_step x M _ below with
  | ⟨p, e', first, at_p, _, ownM⟩ =>
    have same : e' = e := Option.some.inj (ownM.symm.trans
      ((congrArg (fun l => exchangeAt l (law.ownCount x L t)) courses).symm.trans own.1))
    subst same
    exact ⟨p, by unfold indexMap; rw [own.2]; exact first, at_p⟩

variable (law) in
/-- **Whether the exchange at step `t` of a list touches a relatum**, decided: no exchange there
touches none. -/
def touchAt (L : List E) (t : Nat) (x : X) : Bool :=
  match exchangeAt L t with
  | none => false
  | some e => law.touches e x

variable (law) in
/-- The relata of a list that an exchange touches. -/
def touchedIn (e : E) : List X → List X
  | [] => []
  | x :: xs => match law.touches e x with
    | true => x :: touchedIn e xs
    | false => touchedIn e xs

variable [DecidableEq X]

/-- What each relatum present takes from itself across a step from `l` to `l'`: its fall. -/
def fall (l l' : X → Nat) (f c : X) : Nat := if f = c then l c - l' c else 0

/-- What each relatum present gives to itself across a step from `l` to `l'`: its rise. -/
def rise (l l' : X → Nat) (f c : X) : Nat := if f = c then l' c - l c else 0

/-- The world an interleaving builds, from a local law on whole-number standings, the relata
listed, a list of exchanges and a start. Its relata are the relata; at step `t` each stands at
what the first `t` exchanges make of the start, and is active where the exchange at `t` touches
it, decided (`touchAt`, `world_active_iff`); its move at `t` has present the listed relata the
exchange touches, each taking from itself its fall and giving to itself its rise. Nothing is
required, needed or drawn. -/
def world (law : LocalLaw X E Nat) (xs : List X) (L : List E) (s : X → Nat) : World :=
  World.of X
    ⟨fun t => match exchangeAt L t with
      | none => []
      | some e => law.touchedIn e xs,
     fun t => fall (law.runUpTo L s t) (law.runUpTo L s (t + 1)),
     fun t => rise (law.runUpTo L s t) (law.runUpTo L s (t + 1))⟩
    ⟨fun t => law.runUpTo L s t,
     fun t x => law.touchAt L t x = true,
     fun _ _ _ => False, fun _ _ _ => 0, fun _ _ _ => False⟩

variable {law' : LocalLaw X E Nat}

/-- **The world's standing at step `t` is what the first `t` exchanges make of the start.** -/
theorem world_level (xs : List X) (L : List E) (s : X → Nat) (t : Nat) :
    (world law' xs L s).web.level t = law'.runUpTo L s t :=
  rfl

omit [DecidableEq X] in
theorem total_zero_of : ∀ (l : List X) (q : X → Nat), (∀ f, f ∈ l → q f = 0) → Becoming.total l q = 0
  | [], _, _ => rfl
  | f :: l, q, zero => by
    show q f + Becoming.total l q = 0
    rw [zero f (.head l), total_zero_of l q fun g mem => zero g (.tail f mem)]

/-- Over a list with no repeats, a quantity that is nothing but at `c` totals to its value at `c`
where `c` is in the list. -/
theorem total_single {c : X} {v : Nat} : ∀ {l : List X}, List.Pairwise (fun a b => a ≠ b) l →
    c ∈ l → Becoming.total l (fun f => if f = c then v else 0) = v
  | f :: l, .cons apart rest, mem => by
    show (if f = c then v else 0) + Becoming.total l (fun f => if f = c then v else 0) = v
    match mem_cons_cases mem with
    | .inl same =>
      subst same
      rw [if_pos rfl, total_zero_of l _ fun g memG => if_neg (fun same => apart g memG same.symm),
        Nat.add_zero]
    | .inr later =>
      have other : f ≠ c := fun same => apart c later same
      rw [if_neg other, total_single rest later, Nat.zero_add]

/-- A quantity that is nothing but at `c` totals to nothing over a list without `c`. -/
theorem total_absent {c : X} {v : Nat} : ∀ {l : List X}, ¬ c ∈ l →
    Becoming.total l (fun f => if f = c then v else 0) = 0
  | [], _ => rfl
  | f :: l, out => by
    show (if f = c then v else 0) + Becoming.total l (fun f => if f = c then v else 0) = 0
    rw [if_neg (fun (same : f = c) => out (by subst same; exact .head l)), total_absent (fun mem => out (.tail f mem))]

omit [DecidableEq X] in
theorem touchedIn_mem {e : E} {c : X} : ∀ {xs : List X}, c ∈ xs → law.touches e c = true →
    c ∈ law.touchedIn e xs
  | x :: xs, mem, touch => by
    show c ∈ (match law.touches e x with
      | true => x :: law.touchedIn e xs
      | false => law.touchedIn e xs)
    match mem_cons_cases mem with
    | .inl same =>
      subst same
      rw [touch]
      exact .head _
    | .inr later =>
      cases law.touches e x with
      | true => exact .tail x (touchedIn_mem later touch)
      | false => exact touchedIn_mem later touch

omit [DecidableEq X] in
theorem touchedIn_not_mem {e : E} {c : X} (untouched : law.touches e c = false) :
    ∀ {xs : List X}, ¬ c ∈ law.touchedIn e xs
  | [], mem => nomatch mem
  | x :: xs, mem => by
    have h : c ∈ (match law.touches e x with
      | true => x :: law.touchedIn e xs
      | false => law.touchedIn e xs) := mem
    cases touchX : law.touches e x with
    | true =>
      rw [touchX] at h
      match mem_cons_cases h with
      | .inl same => exact Bool.noConfusion ((same ▸ untouched).symm.trans touchX)
      | .inr later => exact touchedIn_not_mem untouched later
    | false =>
      rw [touchX] at h
      exact touchedIn_not_mem untouched h

omit [DecidableEq X] in
theorem touchedIn_mem_of {e : E} {c : X} : ∀ {xs : List X}, c ∈ law.touchedIn e xs → c ∈ xs
  | x :: xs, mem => by
    have h : c ∈ (match law.touches e x with
      | true => x :: law.touchedIn e xs
      | false => law.touchedIn e xs) := mem
    cases touchX : law.touches e x with
    | true =>
      rw [touchX] at h
      match mem_cons_cases h with
      | .inl same => exact same ▸ .head xs
      | .inr later => exact .tail x (touchedIn_mem_of later)
    | false =>
      rw [touchX] at h
      exact .tail x (touchedIn_mem_of h)

omit [DecidableEq X] in
theorem touchedIn_pairwise {e : E} : ∀ {xs : List X}, List.Pairwise (fun a b => a ≠ b) xs →
    List.Pairwise (fun a b => a ≠ b) (law.touchedIn e xs)
  | [], _ => .nil
  | x :: xs, .cons apart rest => by
    show List.Pairwise _ (match law.touches e x with
      | true => x :: law.touchedIn e xs
      | false => law.touchedIn e xs)
    cases law.touches e x with
    | true => exact .cons (fun b mem => apart b (touchedIn_mem_of mem)) (touchedIn_pairwise rest)
    | false => exact touchedIn_pairwise rest

/-- **The world balances.** With every relatum listed once, at every step each relatum's standing
after the step, with what it took, is its standing before, with what it gave. -/
theorem world_balances {xs : List X} (listed : ∀ x, x ∈ xs)
    (once : List.Pairwise (fun a b => a ≠ b) xs) (L : List E) (s : X → Nat) (t : Nat) (c : X) :
    (world law' xs L s).web.level (t + 1) c + ((world law' xs L s).move t).taken c =
      (world law' xs L s).web.level t c + ((world law' xs L s).move t).given c := by
  show law'.runUpTo L s (t + 1) c +
      Becoming.total (match exchangeAt L t with
        | none => []
        | some e => law'.touchedIn e xs)
        (fun f => fall (law'.runUpTo L s t) (law'.runUpTo L s (t + 1)) f c) =
    law'.runUpTo L s t c +
      Becoming.total (match exchangeAt L t with
        | none => []
        | some e => law'.touchedIn e xs)
        (fun f => rise (law'.runUpTo L s t) (law'.runUpTo L s (t + 1)) f c)
  have step := runUpTo_succ (law := law') L s t
  cases at_t : exchangeAt L t with
  | none =>
    rw [at_t] at step
    show law'.runUpTo L s (t + 1) c + 0 = law'.runUpTo L s t c + 0
    rw [step]
  | some e =>
    rw [at_t] at step
    have step : law'.runUpTo L s (t + 1) = law'.act e (law'.runUpTo L s t) := step
    show law'.runUpTo L s (t + 1) c +
        Becoming.total (law'.touchedIn e xs)
          (fun f => if f = c then law'.runUpTo L s t c - law'.runUpTo L s (t + 1) c else 0) =
      law'.runUpTo L s t c +
        Becoming.total (law'.touchedIn e xs)
          (fun f => if f = c then law'.runUpTo L s (t + 1) c - law'.runUpTo L s t c else 0)
    cases touch : law'.touches e c with
    | true =>
      rw [total_single (touchedIn_pairwise (law := law') (e := e) once)
          (touchedIn_mem (law := law') (listed c) touch),
        total_single (touchedIn_pairwise (law := law') (e := e) once)
          (touchedIn_mem (law := law') (listed c) touch)]
      exact add_sub_turn _ _
    | false =>
      rw [total_absent (touchedIn_not_mem (law := law') (xs := xs) touch),
        total_absent (touchedIn_not_mem (law := law') (xs := xs) touch), step,
        law'.keeps e _ c touch]

/-- **Which interleaving is taken does not change where the world ends.** With the relata listed,
the worlds of two lists giving every relatum the same own course stand alike at every step from both
lengths on. -/
theorem world_final {xs xs' : List X} (listed : ∀ x, x ∈ xs) {L M : List E}
    (same : ∀ x, law'.ownCourse x L = law'.ownCourse x M) (s : X → Nat) {t : Nat}
    (afterL : L.length ≤ t) (afterM : M.length ≤ t) (x : X) :
    (world law' xs' L s).web.level t x = (world law' xs' M s).web.level t x :=
  (congrArg (· x) (runUpTo_whole (law := law') L s t afterL)).trans
    ((run_of_courses listed L M same s x).trans
      (congrArg (· x) (runUpTo_whole (law := law') M s t afterM)).symm)

/-- **Two exchanges sharing no relatum, taken in either order: the worlds stand alike at every step
but the one between them.** -/
theorem world_swap {xs : List X} (A B : List E) {e f : E} (apart : law'.Apart e f) (s : X → Nat)
    {t : Nat} (other : t ≠ A.length + 1) (x : X) :
    (world law' xs (A ++ e :: f :: B) s).web.level t x =
      (world law' xs (A ++ f :: e :: B) s).web.level t x := by
  show law'.runUpTo (A ++ e :: f :: B) s t x = law'.runUpTo (A ++ f :: e :: B) s t x
  cases Nat.lt_or_ge (A.length + 1) t with
  | inl late =>
    match le_dest late with
    | ⟨j, eq⟩ =>
      have at_t : t = A.length + (j + 2) :=
        eq.trans ((Nat.add_assoc A.length 2 j).trans (congrArg (A.length + ·) (Nat.add_comm 2 j)))
      rw [at_t, runUpTo_append (law := law'), runUpTo_append (law := law')]
      exact runUpTo_agree (law := law') B (fun y => act_comm apart (law'.run A s) y) j x
  | inr early =>
    cases Nat.lt_or_ge t (A.length + 1) with
    | inl before =>
      rw [runUpTo_append_le (law := law') A _ s t (Nat.le_of_lt_succ before),
        runUpTo_append_le (law := law') A _ s t (Nat.le_of_lt_succ before)]
    | inr after => exact absurd (Nat.le_antisymm early after) other

/-- **At the step between them, each relatum stands in one world where it stands in the other a
step before or after**: one the first exchange touches stands, in the world taking it first, where
it stands after both in the other, and in the other where it stood before both; and the same with
the two exchanged; one neither touches stands alike. -/
theorem world_swap_between {xs : List X} (A B : List E) {e f : E} (apart : law'.Apart e f)
    (s : X → Nat) (x : X) :
    (law'.touches e x = true →
      (world law' xs (A ++ e :: f :: B) s).web.level (A.length + 1) x =
          (world law' xs (A ++ f :: e :: B) s).web.level (A.length + 2) x ∧
        (world law' xs (A ++ f :: e :: B) s).web.level (A.length + 1) x =
          (world law' xs (A ++ e :: f :: B) s).web.level A.length x) ∧
    (law'.touches f x = true →
      (world law' xs (A ++ f :: e :: B) s).web.level (A.length + 1) x =
          (world law' xs (A ++ e :: f :: B) s).web.level (A.length + 2) x ∧
        (world law' xs (A ++ e :: f :: B) s).web.level (A.length + 1) x =
          (world law' xs (A ++ f :: e :: B) s).web.level A.length x) ∧
    (law'.touches e x = false → law'.touches f x = false →
      (world law' xs (A ++ e :: f :: B) s).web.level (A.length + 1) x =
        (world law' xs (A ++ f :: e :: B) s).web.level (A.length + 1) x) := by
  have at1 : ∀ (g h : E), law'.runUpTo (A ++ g :: h :: B) s (A.length + 1) =
      law'.act g (law'.run A s) := fun g h =>
    (runUpTo_append (law := law') A _ s 1).trans rfl
  have at2 : ∀ (g h : E), law'.runUpTo (A ++ g :: h :: B) s (A.length + 2) =
      law'.runUpTo B (law'.act h (law'.act g (law'.run A s))) 0 := fun g h =>
    (runUpTo_append (law := law') A _ s 2).trans rfl
  have at0 : ∀ (g h : E), law'.runUpTo (A ++ g :: h :: B) s A.length = law'.run A s := fun g h =>
    ((congrArg (law'.runUpTo _ s) (Nat.add_zero A.length).symm).trans
      (runUpTo_append (law := law') A _ s 0)).trans rfl
  have zero : ∀ (r : X → Nat), law'.runUpTo B r 0 = r := fun r => by
    cases B with
    | nil => rfl
    | cons _ _ => rfl
  refine ⟨fun touchE => ⟨?_, ?_⟩, fun touchF => ⟨?_, ?_⟩, fun touchE touchF => ?_⟩
  · show law'.runUpTo (A ++ e :: f :: B) s (A.length + 1) x =
      law'.runUpTo (A ++ f :: e :: B) s (A.length + 2) x
    rw [at1, at2, zero]
    exact (law'.reads e (law'.act f (law'.run A s)) (law'.run A s) x
      (fun y touchY => law'.keeps f _ y (apart y touchY)) touchE).symm
  · show law'.runUpTo (A ++ f :: e :: B) s (A.length + 1) x =
      law'.runUpTo (A ++ e :: f :: B) s A.length x
    rw [at1, at0]
    exact law'.keeps f _ x (apart x touchE)
  · show law'.runUpTo (A ++ f :: e :: B) s (A.length + 1) x =
      law'.runUpTo (A ++ e :: f :: B) s (A.length + 2) x
    rw [at1, at2, zero]
    exact (law'.reads f (law'.act e (law'.run A s)) (law'.run A s) x
      (fun y touchY => law'.keeps e _ y (apart.symm y touchY)) touchF).symm
  · show law'.runUpTo (A ++ e :: f :: B) s (A.length + 1) x =
      law'.runUpTo (A ++ f :: e :: B) s A.length x
    rw [at1, at0]
    exact law'.keeps e _ x (apart.symm x touchF)
  · show law'.runUpTo (A ++ e :: f :: B) s (A.length + 1) x =
      law'.runUpTo (A ++ f :: e :: B) s (A.length + 1) x
    rw [at1, at1, law'.keeps e _ x touchE, law'.keeps f _ x touchF]

/-! ## The worlds of any two interleavings, step by step -/

/-- **The world's standing, read through a relatum's own steps**: at step `t` a relatum stands
where it stands after the own exchanges the first `t` exchanges hold. -/
theorem world_own (xs : List X) (L : List E) (s : X → Nat) (t : Nat) (x : X) :
    (world law' xs L s).web.level t x = law'.standingAfter x L s (law'.ownCount x L t) :=
  runUpTo_own x L s t

/-- **The worlds of two interleavings of the same courses, step by step.** With the relata listed,
a relatum stands at step `t` of the one world where it stands, in the other, at the step the index
map gives: the least step at which it has taken as many of its own exchanges. -/
theorem world_index {xs xs' : List X} (listed : ∀ x, x ∈ xs) {c : X → List E} {L M : List E}
    (inL : law'.Interleaves c L) (inM : law'.Interleaves c M) (s : X → Nat) (x : X) (t : Nat) :
    (world law' xs' L s).web.level t x = (world law' xs' M s).web.level (law'.indexMap x L M t) x :=
  runUpTo_index listed inL inM s x t

/-- **And at any two steps at which it has taken equally many of its own exchanges.** -/
theorem world_of_own {xs xs' : List X} (listed : ∀ x, x ∈ xs) {c : X → List E} {L M : List E}
    (inL : law'.Interleaves c L) (inM : law'.Interleaves c M) (s : X → Nat) (x : X) {t t' : Nat}
    (same : law'.ownCount x L t = law'.ownCount x M t') :
    (world law' xs' L s).web.level t x = (world law' xs' M s).web.level t' x :=
  runUpTo_of_own listed inL inM s x same

/-- **What is read through a relatum's own steps is the same for every interleaving.** For every
property of a standing, a relatum has it at some step of one world exactly where it has it at some
step of the other, and at every step of one exactly where at every step of the other. -/
theorem world_reads_alike {xs xs' : List X} (listed : ∀ x, x ∈ xs) {c : X → List E}
    {L M : List E} (inL : law'.Interleaves c L) (inM : law'.Interleaves c M) (s : X → Nat) (x : X)
    (P : Nat → Prop) :
    ((∃ t, P ((world law' xs' L s).web.level t x)) ↔
        ∃ t, P ((world law' xs' M s).web.level t x)) ∧
      ((∀ t, P ((world law' xs' L s).web.level t x)) ↔
        ∀ t, P ((world law' xs' M s).web.level t x)) :=
  ⟨⟨fun ⟨t, holds⟩ => ⟨law'.indexMap x L M t,
      Eq.mp (congrArg P (world_index (xs' := xs') listed inL inM s x t)) holds⟩,
    fun ⟨t, holds⟩ => ⟨law'.indexMap x M L t,
      Eq.mp (congrArg P (world_index (xs' := xs') listed inM inL s x t)) holds⟩⟩,
   ⟨fun all t => Eq.mp (congrArg P (world_index (xs' := xs') listed inM inL s x t).symm)
      (all (law'.indexMap x M L t)),
    fun all t => Eq.mp (congrArg P (world_index (xs' := xs') listed inL inM s x t).symm)
      (all (law'.indexMap x L M t))⟩⟩

/-! ## One renumbering of all the steps

Two interleavings of the same courses, every exchange of each touching some relatum (`Touching`),
take each exchange the same number of times, and the `k`-th taking of an exchange in one is the
`k`-th in the other at every relatum it touches: where `L` has an exchange at step `t`, `M` has
it at a step at which each relatum it touches has taken as many of its own exchanges
(`occurrence_matches`), and only at one (`step_of_ownCount`). `renumber` sends `t` there, read
off the first listed relatum the exchange touches; every relatum it touches gives the same step
(`renumber_spec`, `renumber_index`: the index map of each such relatum sends `t + 1` to the step
after). The renumbering is one of all the steps: it is undone by the renumbering the other way
(`renumber_renumber`), takes the steps below the length among themselves (`renumber_lt`,
`length_of_courses`, `renumber_reindexes`: `Reindexes` of `Becoming.Reordering`) and fixes
every step from the length on (`renumber_beyond`). -/

section Renumbering

omit [DecidableEq X]

/-- A list holds each exchange it has at a step. -/
theorem exchangeAt_mem : ∀ {L : List E} {t : Nat} {e : E}, exchangeAt L t = some e → e ∈ L
  | [], _, _, h => nomatch h
  | a :: L, 0, e, h => by
    have same : a = e := Option.some.inj h
    subst same
    exact .head L
  | a :: L, t + 1, _, h => .tail a (exchangeAt_mem (L := L) (t := t) h)

/-- Before a list's length, appending more leaves the exchange at a step as it was. -/
theorem exchangeAt_append_lt : ∀ (A R : List E) {k : Nat}, k < A.length →
    exchangeAt (A ++ R) k = exchangeAt A k
  | [], _, _, lt => absurd lt (Nat.not_lt_zero _)
  | _ :: _, _, 0, _ => rfl
  | _ :: A, R, _ + 1, lt => exchangeAt_append_lt A R (Nat.lt_of_succ_lt_succ lt)

/-- After a list, the exchange at a step is the rest's. -/
theorem exchangeAt_append : ∀ (A R : List E) (k : Nat),
    exchangeAt (A ++ R) (A.length + k) = exchangeAt R k
  | [], _, k => congrArg (exchangeAt _) (Nat.zero_add k)
  | _ :: A, R, k =>
    (congrArg (exchangeAt _) (Nat.succ_add A.length k)).trans (exchangeAt_append A R k)

/-- From a list's length on, a list has no exchange. -/
theorem exchangeAt_beyond : ∀ (L : List E) {t : Nat}, L.length ≤ t → exchangeAt L t = none
  | [], _, _ => rfl
  | _ :: _, 0, le => absurd le (Nat.not_succ_le_zero _)
  | _ :: L, _ + 1, le => exchangeAt_beyond L (Nat.le_of_succ_le_succ le)

/-- Where a list has no exchange, the step is at least its length. -/
theorem exchangeAt_none : ∀ {L : List E} {t : Nat}, exchangeAt L t = none → L.length ≤ t
  | [], _, _ => Nat.zero_le _
  | _ :: _, 0, h => nomatch h
  | _ :: L, t + 1, h => Nat.succ_le_succ (exchangeAt_none (L := L) (t := t) h)

/-- Before its length, a list has an exchange at every step. -/
theorem exchangeAt_some : ∀ (L : List E) {t : Nat}, t < L.length → ∃ e, exchangeAt L t = some e
  | [], _, lt => absurd lt (Nat.not_lt_zero _)
  | a :: _, 0, _ => ⟨a, rfl⟩
  | _ :: L, _ + 1, lt => exchangeAt_some L (Nat.lt_of_succ_lt_succ lt)

/-- An exchange put into a list lengthens it by one. -/
theorem length_insert : ∀ (A B : List E) (a : E), (A ++ a :: B).length = (A ++ B).length + 1
  | [], _, _ => rfl
  | _ :: A, B, a => congrArg (· + 1) (length_insert A B a)

/-- Up to a list's length, appending more leaves the own exchanges counted as they were. -/
theorem ownCount_append_le (x : X) : ∀ (A R : List E) (k : Nat), k ≤ A.length →
    law.ownCount x (A ++ R) k = law.ownCount x A k
  | [], [], _, _ => rfl
  | [], _ :: _, 0, _ => rfl
  | [], _ :: _, _ + 1, le => absurd le (Nat.not_succ_le_zero _)
  | _ :: _, _, 0, _ => rfl
  | a :: A, R, k + 1, le => by
    show law.ownCount x (a :: (A ++ R)) (k + 1) = law.ownCount x (a :: A) (k + 1)
    cases touch : law.touches a x with
    | true =>
      rw [ownCount_true _ _ touch, ownCount_true _ _ touch,
        ownCount_append_le x A R k (Nat.le_of_succ_le_succ le)]
    | false =>
      rw [ownCount_false _ _ touch, ownCount_false _ _ touch,
        ownCount_append_le x A R k (Nat.le_of_succ_le_succ le)]

/-- After a list, the own exchanges counted are the list's and the rest's. -/
theorem ownCount_append (x : X) : ∀ (A R : List E) (k : Nat),
    law.ownCount x (A ++ R) (A.length + k) = law.ownCount x A A.length + law.ownCount x R k
  | [], R, k => by
    show law.ownCount x R (0 + k) = 0 + law.ownCount x R k
    rw [Nat.zero_add, Nat.zero_add]
  | a :: A, R, k => by
    show law.ownCount x (a :: (A ++ R)) (A.length + 1 + k) =
      law.ownCount x (a :: A) (A.length + 1) + law.ownCount x R k
    rw [Nat.add_right_comm A.length 1 k]
    cases touch : law.touches a x with
    | true =>
      rw [ownCount_true _ _ touch, ownCount_true _ _ touch, ownCount_append x A R k]
      exact Nat.add_right_comm _ _ _
    | false =>
      rw [ownCount_false _ _ touch, ownCount_false _ _ touch, ownCount_append x A R k]

/-- A list none of whose exchanges touches a relatum counts none of its own. -/
theorem ownCount_untouched (x : X) {A : List E} (absent : ∀ a, a ∈ A → law.touches a x = false)
    (k : Nat) : law.ownCount x A k = 0 :=
  Nat.eq_zero_of_le_zero (Nat.le_trans (ownCount_le x A k)
    (Nat.le_of_eq (congrArg List.length (ownCourse_untouched absent))))

/-- The own exchanges counted never fall along the steps. -/
theorem ownCount_mono (x : X) : ∀ (L : List E) {t t' : Nat}, t ≤ t' →
    law.ownCount x L t ≤ law.ownCount x L t'
  | [], _, _, _ => Nat.le_refl 0
  | _ :: _, 0, _, _ => Nat.zero_le _
  | _ :: _, _ + 1, 0, le => absurd le (Nat.not_succ_le_zero _)
  | e :: L, t + 1, t' + 1, le => by
    cases touch : law.touches e x with
    | true =>
      rw [ownCount_true L t touch, ownCount_true L t' touch]
      exact Nat.succ_le_succ (ownCount_mono x L (Nat.le_of_succ_le_succ le))
    | false =>
      rw [ownCount_false L t touch, ownCount_false L t' touch]
      exact ownCount_mono x L (Nat.le_of_succ_le_succ le)

/-- **A relatum's own exchanges fall at distinct steps**: two steps at which it takes an exchange,
having taken equally many before, are one. -/
theorem step_of_ownCount (x : X) (L : List E) {t t' : Nat} {e e' : E}
    (at_t : exchangeAt L t = some e) (touch : law.touches e x = true)
    (at_t' : exchangeAt L t' = some e') (touch' : law.touches e' x = true)
    (same : law.ownCount x L t = law.ownCount x L t') : t = t' :=
  have later : ∀ {a b : Nat} {f : E}, exchangeAt L a = some f → law.touches f x = true →
      law.ownCount x L a = law.ownCount x L b → ¬ a < b := fun at_a touchF eq lt => by
    have h := ownCount_mono (law := law) x L (Nat.succ_le_of_lt lt)
    rw [(exchangeAt_own x L _ at_a touchF).2, ← eq] at h
    exact Nat.not_succ_le_self _ h
  match Nat.lt_or_ge t t' with
  | .inl lt => absurd lt (later at_t touch same)
  | .inr ge => match Nat.lt_or_ge t' t with
    | .inl lt => absurd lt (later at_t' touch' same.symm)
    | .inr ge' => Nat.le_antisymm ge' ge

/-- **The least step after the `n`-th own exchange.** Where a relatum takes an exchange at step `p`,
the least step at which it has taken one more than before `p` is `p + 1`. -/
theorem firstAt_after (x : X) (M : List E) {p : Nat} {e : E} (at_p : exchangeAt M p = some e)
    (touch : law.touches e x = true) :
    law.firstAt x M (law.ownCount x M p + 1) = p + 1 :=
  have step := (exchangeAt_own x M p at_p touch).2
  have hq : law.ownCount x M (law.firstAt x M (law.ownCount x M p + 1)) = law.ownCount x M p + 1 :=
    ownCount_firstAt x M _ (Nat.le_trans (Nat.le_of_eq step.symm) (ownCount_le x M (p + 1)))
  Nat.le_antisymm (firstAt_least x M _ (p + 1) step)
    (match Nat.lt_or_ge p (law.firstAt x M (law.ownCount x M p + 1)) with
    | .inl lt => lt
    | .inr ge => absurd (Nat.le_trans (Nat.le_of_eq hq.symm) (ownCount_mono (law := law) x M ge))
        (Nat.not_succ_le_self _))

/-- **Each taking of an exchange is matched across two lists with the same own courses.** With the
relata listed, where `L` has at step `t` an exchange touching some relatum, `M` has the same
exchange at a step at which every relatum it touches has taken as many of its own exchanges as at
`t` in `L`. -/
theorem occurrence_matches {xs : List X} (listed : ∀ x, x ∈ xs) : ∀ (L M : List E),
    (∀ x, law.ownCourse x L = law.ownCourse x M) → ∀ (t : Nat) {e : E},
    exchangeAt L t = some e → (∃ x, law.touches e x = true) →
    ∃ p, exchangeAt M p = some e ∧
      ∀ x, law.touches e x = true → law.ownCount x M p = law.ownCount x L t
  | [], _, _, _, _, at_t, _ => nomatch at_t
  | a :: L, M, same, t, e, at_t, ⟨x₀, touch₀⟩ => by
    cases hit : law.shares xs a a with
    | false =>
      have untouched := untouched_of_shares listed hit
      have rest : ∀ y, law.ownCourse y L = law.ownCourse y M := fun y =>
        (ownCourse_false L (untouched y)).symm.trans (same y)
      match t, at_t with
      | 0, at_0 =>
        have heads : a = e := Option.some.inj at_0
        subst heads
        exact bool_absurd touch₀ (untouched x₀)
      | t + 1, at_t =>
        match occurrence_matches listed L M rest t at_t ⟨x₀, touch₀⟩ with
        | ⟨p, at_p, counts⟩ =>
          exact ⟨p, at_p, fun x touch =>
            (counts x touch).trans (ownCount_false L t (untouched x)).symm⟩
    | true =>
      match exists_of_shares hit with
      | ⟨_, touchA, _⟩ =>
        match split_heads listed touchA (M := M)
          (fun y touchY => ⟨law.ownCourse y L, (same y).symm.trans (ownCourse_true L touchY)⟩)
        with
        | ⟨A, B, split, apartA, onTouched, onOther⟩ =>
          have rest : ∀ y, law.ownCourse y L = law.ownCourse y (A ++ B) := fun y => by
            cases touchY : law.touches a y with
            | true =>
              exact cons_tails
                ((ownCourse_true L touchY).symm.trans ((same y).trans (onTouched y touchY)))
            | false =>
              exact (ownCourse_false L touchY).symm.trans ((same y).trans (onOther y touchY))
          subst split
          match t, at_t with
          | 0, at_0 =>
            have heads : a = e := Option.some.inj at_0
            subst heads
            refine ⟨A.length, ?_, fun x touch => ?_⟩
            · exact (congrArg (exchangeAt _) (Nat.add_zero A.length).symm).trans
                (exchangeAt_append A _ 0)
            · rw [ownCount_append_le x A _ A.length (Nat.le_refl _)]
              exact ownCount_untouched x (fun b mem => apartA b mem x touch) A.length
          | t + 1, at_t =>
            match occurrence_matches listed L (A ++ B) rest t at_t ⟨x₀, touch₀⟩ with
            | ⟨q, at_q, counts⟩ =>
              match Nat.lt_or_ge q A.length with
              | .inl before =>
                have inA : exchangeAt A q = some e :=
                  (exchangeAt_append_lt A B before).symm.trans at_q
                refine ⟨q, (exchangeAt_append_lt A _ before).trans inA, fun x touch => ?_⟩
                have away : law.touches a x = false :=
                  (apartA e (exchangeAt_mem inA)).symm x touch
                rw [ownCount_append_le x A _ q (Nat.le_of_lt before), ownCount_false L t away,
                  ← counts x touch, ownCount_append_le x A B q (Nat.le_of_lt before)]
              | .inr after =>
                match le_dest after with
                | ⟨k, eq⟩ =>
                  subst eq
                  refine ⟨A.length + (k + 1), ?_, fun x touch => ?_⟩
                  · exact (exchangeAt_append A _ (k + 1)).trans
                      ((exchangeAt_append A B k).symm.trans at_q)
                  · cases touchX : law.touches a x with
                    | true =>
                      rw [ownCount_append x A _ (k + 1), ownCount_true B k touchX,
                        ownCount_true L t touchX, ← counts x touch, ownCount_append x A B k]
                      exact (Nat.add_assoc _ _ _).symm
                    | false =>
                      rw [ownCount_append x A _ (k + 1), ownCount_false B k touchX,
                        ownCount_false L t touchX, ← counts x touch, ownCount_append x A B k]

variable (law) in
/-- **Every exchange of a list touches some relatum.** -/
def Touching (L : List E) : Prop :=
  ∀ t e, exchangeAt L t = some e → ∃ x, law.touches e x = true

theorem Touching.tail {a : E} {L : List E} (touching : law.Touching (a :: L)) : law.Touching L :=
  fun t e at_t => touching (t + 1) e at_t

theorem Touching.remove {A B : List E} {a : E} (touching : law.Touching (A ++ a :: B)) :
    law.Touching (A ++ B) :=
  fun q f at_q => match Nat.lt_or_ge q A.length with
  | .inl before => touching q f ((exchangeAt_append_lt A _ before).trans
      ((exchangeAt_append_lt A B before).symm.trans at_q))
  | .inr after => match le_dest after with
    | ⟨k, eq⟩ => touching (A.length + (k + 1)) f ((exchangeAt_append A _ (k + 1)).trans
        ((exchangeAt_append A B k).symm.trans ((congrArg (exchangeAt (A ++ B)) eq).symm.trans at_q)))

/-- **Two lists with the same own courses, every exchange touching a relatum, have one length.** -/
theorem length_of_courses {xs : List X} (listed : ∀ x, x ∈ xs) : ∀ (L M : List E),
    law.Touching L → law.Touching M → (∀ x, law.ownCourse x L = law.ownCourse x M) →
    L.length = M.length
  | [], [], _, _, _ => rfl
  | [], f :: _, _, touchM, same => match touchM 0 f rfl with
    | ⟨x, touch⟩ => absurd ((same x).trans (ownCourse_true _ touch)).symm cons_ne_nil
  | a :: L, M, touchL, touchM, same => match touchL 0 a rfl with
    | ⟨_, touch₀⟩ =>
      match split_heads listed touch₀ (M := M)
        (fun y touchY => ⟨law.ownCourse y L, (same y).symm.trans (ownCourse_true L touchY)⟩) with
      | ⟨A, B, split, _, onTouched, onOther⟩ => by
        have rest : ∀ y, law.ownCourse y L = law.ownCourse y (A ++ B) := fun y => by
          cases touchY : law.touches a y with
          | true =>
            exact cons_tails
              ((ownCourse_true L touchY).symm.trans ((same y).trans (onTouched y touchY)))
          | false =>
            exact (ownCourse_false L touchY).symm.trans ((same y).trans (onOther y touchY))
        subst split
        exact (congrArg (· + 1) (length_of_courses listed L (A ++ B) touchL.tail touchM.remove
          rest)).trans (length_insert A B a).symm

/-- Every relatum among those of a listing an exchange touches is touched by it. -/
theorem touches_of_touchedIn {e : E} {c : X} : ∀ {xs : List X}, c ∈ law.touchedIn e xs →
    law.touches e c = true
  | [], mem => nomatch mem
  | x :: xs, mem => by
    have h : c ∈ (match law.touches e x with
      | true => x :: law.touchedIn e xs
      | false => law.touchedIn e xs) := mem
    cases touchX : law.touches e x with
    | true =>
      rw [touchX] at h
      match mem_cons_cases h with
      | .inl same => rw [same]; exact touchX
      | .inr later => exact touches_of_touchedIn later
    | false =>
      rw [touchX] at h
      exact touches_of_touchedIn h

variable (law) in
/-- **One renumbering of all the steps.** A step of `L` holding an exchange goes to the step of `M`
at which the first listed relatum the exchange touches takes the same own exchange: one less than
that relatum's index map at the step after. Every other step stays. -/
def renumber (xs : List X) (L M : List E) (t : Nat) : Nat :=
  match exchangeAt L t with
  | none => t
  | some e => match law.touchedIn e xs with
    | [] => t
    | x :: _ => law.indexMap x L M (t + 1) - 1

theorem renumber_none {xs : List X} {L M : List E} {t : Nat} (idle : exchangeAt L t = none) :
    law.renumber xs L M t = t := by
  show (match exchangeAt L t with
    | none => t
    | some e => match law.touchedIn e xs with
      | [] => t
      | x :: _ => law.indexMap x L M (t + 1) - 1) = t
  rw [idle]

theorem renumber_lead {xs : List X} {L M : List E} {t : Nat} {e : E} {x : X} {rest : List X}
    (at_t : exchangeAt L t = some e) (lead : law.touchedIn e xs = x :: rest) :
    law.renumber xs L M t = law.indexMap x L M (t + 1) - 1 := by
  show (match exchangeAt L t with
    | none => t
    | some e => match law.touchedIn e xs with
      | [] => t
      | x :: _ => law.indexMap x L M (t + 1) - 1) = _
  rw [at_t]
  show (match law.touchedIn e xs with
    | [] => t
    | x :: _ => law.indexMap x L M (t + 1) - 1) = _
  rw [lead]

/-- **Where the renumbering sends a step holding an exchange.** With the relata listed and the own
courses the same, where `L` has at step `t` an exchange touching some relatum, `M` has that exchange
at the renumbered step; there every relatum it touches has taken as many of its own exchanges as at
`t` in `L`, and that relatum's index map sends `t + 1` to the step after. -/
theorem renumber_spec {xs : List X} (listed : ∀ x, x ∈ xs) {L M : List E}
    (same : ∀ x, law.ownCourse x L = law.ownCourse x M) {t : Nat} {e : E}
    (at_t : exchangeAt L t = some e) (touching : ∃ x, law.touches e x = true) :
    exchangeAt M (law.renumber xs L M t) = some e ∧
      ∀ x, law.touches e x = true →
        law.ownCount x M (law.renumber xs L M t) = law.ownCount x L t ∧
        law.indexMap x L M (t + 1) = law.renumber xs L M t + 1 :=
  match occurrence_matches listed L M same t at_t touching with
  | ⟨p, at_p, counts⟩ =>
    have index : ∀ x, law.touches e x = true → law.indexMap x L M (t + 1) = p + 1 :=
      fun x touch => by
        show law.firstAt x M (law.ownCount x L (t + 1)) = p + 1
        rw [(exchangeAt_own x L t at_t touch).2, ← counts x touch]
        exact firstAt_after x M at_p touch
    have lands : law.renumber xs L M t = p := match touching with
      | ⟨x₀, touch₀⟩ =>
        match h : law.touchedIn e xs with
        | [] => by
          have mem := touchedIn_mem (listed x₀) touch₀
          rw [h] at mem
          exact nomatch mem
        | y :: rest =>
          have touchY : law.touches e y = true :=
            touches_of_touchedIn (show y ∈ law.touchedIn e xs by rw [h]; exact .head rest)
          (renumber_lead (M := M) at_t h).trans (congrArg (· - 1) (index y touchY))
    ⟨(congrArg (exchangeAt M) lands).trans at_p, fun x touch =>
      ⟨(congrArg (law.ownCount x M) lands).trans (counts x touch),
       (index x touch).trans (congrArg (· + 1) lands.symm)⟩⟩

/-- **The renumbering takes each exchange where the other list has it.** With the relata listed,
for two interleavings of the same courses every exchange of each touching a relatum, the exchange
at the renumbered step of `M` is the exchange at step `t` of `L`, at every step. -/
theorem renumber_exchange {xs : List X} (listed : ∀ x, x ∈ xs) {c : X → List E} {L M : List E}
    (inL : law.Interleaves c L) (inM : law.Interleaves c M) (touchL : law.Touching L)
    (touchM : law.Touching M) (t : Nat) :
    exchangeAt M (law.renumber xs L M t) = exchangeAt L t :=
  match h : exchangeAt L t with
  | none =>
    (congrArg (exchangeAt M) (renumber_none h)).trans (exchangeAt_beyond M (Nat.le_trans
      (Nat.le_of_eq (length_of_courses listed L M touchL touchM
        (fun y => (inL y).trans (inM y).symm)).symm) (exchangeAt_none h)))
  | some e => (renumber_spec listed (fun y => (inL y).trans (inM y).symm) h (touchL t e h)).1

/-- **The own exchanges match through the renumbering**: where the exchange at step `t` of `L`
touches a relatum, the relatum has taken as many of its own exchanges at the renumbered step of
`M`. -/
theorem renumber_count {xs : List X} (listed : ∀ x, x ∈ xs) {c : X → List E} {L M : List E}
    (inL : law.Interleaves c L) (inM : law.Interleaves c M) {t : Nat} {e : E}
    (at_t : exchangeAt L t = some e) {x : X} (touch : law.touches e x = true) :
    law.ownCount x M (law.renumber xs L M t) = law.ownCount x L t :=
  ((renumber_spec listed (fun y => (inL y).trans (inM y).symm) at_t ⟨x, touch⟩).2 x touch).1

/-- **On each relatum's steps the renumbering is its index map**: where the exchange at step `t`
of `L` touches a relatum, the relatum's index map sends `t + 1` to the step after the renumbered
step. -/
theorem renumber_index {xs : List X} (listed : ∀ x, x ∈ xs) {c : X → List E} {L M : List E}
    (inL : law.Interleaves c L) (inM : law.Interleaves c M) {t : Nat} {e : E}
    (at_t : exchangeAt L t = some e) {x : X} (touch : law.touches e x = true) :
    law.indexMap x L M (t + 1) = law.renumber xs L M t + 1 :=
  ((renumber_spec listed (fun y => (inL y).trans (inM y).symm) at_t ⟨x, touch⟩).2 x touch).2

/-- **The renumbering the other way undoes it**, at every step. -/
theorem renumber_renumber {xs : List X} (listed : ∀ x, x ∈ xs) {c : X → List E} {L M : List E}
    (inL : law.Interleaves c L) (inM : law.Interleaves c M) (touchL : law.Touching L)
    (touchM : law.Touching M) (t : Nat) :
    law.renumber xs M L (law.renumber xs L M t) = t :=
  match h : exchangeAt L t with
  | none =>
    have none' : exchangeAt M t = none := exchangeAt_beyond M (Nat.le_trans
      (Nat.le_of_eq (length_of_courses listed L M touchL touchM
        (fun y => (inL y).trans (inM y).symm)).symm) (exchangeAt_none h))
    (congrArg (law.renumber xs M L) (renumber_none h)).trans (renumber_none none')
  | some e =>
    match touchL t e h with
    | ⟨x₀, touch₀⟩ =>
      have fwd := renumber_spec listed (fun y => (inL y).trans (inM y).symm) h ⟨x₀, touch₀⟩
      have back := renumber_spec listed (fun y => (inM y).trans (inL y).symm) fwd.1 ⟨x₀, touch₀⟩
      step_of_ownCount x₀ L back.1 touch₀ h touch₀ ((back.2 x₀ touch₀).1.trans (fwd.2 x₀ touch₀).1)

/-- From the length on, the renumbering fixes every step. -/
theorem renumber_beyond {xs : List X} {L M : List E} {t : Nat} (after : L.length ≤ t) :
    law.renumber xs L M t = t :=
  renumber_none (exchangeAt_beyond L after)

/-- Below the length, the renumbering stays below the other list's length. -/
theorem renumber_lt {xs : List X} (listed : ∀ x, x ∈ xs) {c : X → List E} {L M : List E}
    (inL : law.Interleaves c L) (inM : law.Interleaves c M) (touchL : law.Touching L)
    (touchM : law.Touching M) {t : Nat} (below : t < L.length) :
    law.renumber xs L M t < M.length :=
  match exchangeAt_some L below with
  | ⟨_, at_t⟩ => exchangeAt_lt ((renumber_exchange listed inL inM touchL touchM t).trans at_t)

/-- **The renumbering is one of all the steps below the length**: with the renumbering the other
way it `Reindexes` them (`Becoming.Reordering`). -/
theorem renumber_reindexes {xs : List X} (listed : ∀ x, x ∈ xs) {c : X → List E} {L M : List E}
    (inL : law.Interleaves c L) (inM : law.Interleaves c M) (touchL : law.Touching L)
    (touchM : law.Touching M) :
    Reindexes 0 L.length (law.renumber xs L M) (law.renumber xs M L) :=
  have lengths := length_of_courses listed L M touchL touchM (fun y => (inL y).trans (inM y).symm)
  fun i _ below =>
    have belowL : i < L.length := Nat.lt_of_lt_of_le below (Nat.le_of_eq (Nat.zero_add _))
    have belowM : i < M.length := Nat.lt_of_lt_of_le belowL (Nat.le_of_eq lengths)
    ⟨⟨Nat.zero_le _, Nat.lt_of_lt_of_le (renumber_lt listed inL inM touchL touchM belowL)
        (Nat.le_of_eq (lengths.symm.trans (Nat.zero_add _).symm)),
      renumber_renumber listed inL inM touchL touchM i⟩,
     ⟨Nat.zero_le _, Nat.lt_of_lt_of_le (renumber_lt listed inM inL touchM touchL belowM)
        (Nat.le_of_eq (Nat.zero_add _).symm),
      renumber_renumber listed inM inL touchM touchL i⟩⟩

/-! ### Agreement through the renumbering -/

theorem touchAt_some {L : List E} {t : Nat} {e : E} (at_t : exchangeAt L t = some e) (x : X) :
    law.touchAt L t x = law.touches e x := by
  show (match exchangeAt L t with
    | none => false
    | some e => law.touches e x) = _
  rw [at_t]

theorem touchAt_none {L : List E} {t : Nat} (idle : exchangeAt L t = none) (x : X) :
    law.touchAt L t x = false := by
  show (match exchangeAt L t with
    | none => false
    | some e => law.touches e x) = _
  rw [idle]

/-- **The decided touch is the touch of the exchange at the step.** -/
theorem touchAt_iff {L : List E} {t : Nat} {x : X} :
    law.touchAt L t x = true ↔ ∃ e, exchangeAt L t = some e ∧ law.touches e x = true :=
  ⟨fun yes => match h : exchangeAt L t with
    | none => bool_absurd yes (touchAt_none h x)
    | some e => ⟨e, rfl, (touchAt_some h x).symm.trans yes⟩,
   fun ⟨_, at_t, touch⟩ => (touchAt_some at_t x).trans touch⟩

/-- **The footprint moves with the renumbering**: the renumbered step of `M` touches what step `t`
of `L` touches. -/
theorem touchAt_renumber {xs : List X} (listed : ∀ x, x ∈ xs) {c : X → List E} {L M : List E}
    (inL : law.Interleaves c L) (inM : law.Interleaves c M) (touchL : law.Touching L)
    (touchM : law.Touching M) (t : Nat) (x : X) :
    law.touchAt M (law.renumber xs L M t) x = law.touchAt L t x := by
  show (match exchangeAt M (law.renumber xs L M t) with
    | none => false
    | some e => law.touches e x) = (match exchangeAt L t with
    | none => false
    | some e => law.touches e x)
  rw [renumber_exchange listed inL inM touchL touchM t]

/-- A relatum the exchange at a step does not touch stands across it as before. -/
theorem runUpTo_untouched (L : List E) (s : X → σ) {t : Nat} {x : X}
    (no : law.touchAt L t x = false) : law.runUpTo L s (t + 1) x = law.runUpTo L s t x := by
  have step := runUpTo_succ (law := law) L s t
  cases at_t : exchangeAt L t with
  | none =>
    rw [at_t] at step
    exact congrArg (· x) step
  | some e =>
    rw [at_t] at step
    have step : law.runUpTo L s (t + 1) = law.act e (law.runUpTo L s t) := step
    exact (congrArg (· x) step).trans (law.keeps e _ x ((touchAt_some at_t x).symm.trans no))

/-- **What the exchange touches stands alike through the renumbering**, before and after it: where
the exchange at step `t` of `L` touches a relatum, the relatum stands at `t` and `t + 1` of `L`
where it stands at the renumbered step of `M` and the step after. -/
theorem runUpTo_renumber {xs : List X} (listed : ∀ x, x ∈ xs) {c : X → List E} {L M : List E}
    (inL : law.Interleaves c L) (inM : law.Interleaves c M) (s : X → σ) {t : Nat} {e : E}
    (at_t : exchangeAt L t = some e) {x : X} (touch : law.touches e x = true) :
    law.runUpTo L s t x = law.runUpTo M s (law.renumber xs L M t) x ∧
      law.runUpTo L s (t + 1) x = law.runUpTo M s (law.renumber xs L M t + 1) x :=
  have spec := renumber_spec listed (fun y => (inL y).trans (inM y).symm) at_t ⟨x, touch⟩
  have counts := (spec.2 x touch).1
  ⟨runUpTo_of_own listed inL inM s x counts.symm,
   runUpTo_of_own listed inL inM s x ((exchangeAt_own x L t at_t touch).2.trans
     ((congrArg (· + 1) counts.symm).trans
       (exchangeAt_own x M _ spec.1 touch).2.symm))⟩

/-- **A relation reading the relata an exchange touches reads alike through the renumbering**,
before the exchange and after it, however many relata it reads. -/
theorem reads_renumber {xs : List X} (listed : ∀ x, x ∈ xs) {c : X → List E} {L M : List E}
    (inL : law.Interleaves c L) (inM : law.Interleaves c M) (s : X → σ) {t : Nat} {e : E}
    (at_t : exchangeAt L t = some e) (R : (X → σ) → Prop)
    (reads : ∀ l l', (∀ y, law.touches e y = true → l y = l' y) → R l → R l') :
    (R (law.runUpTo L s t) ↔ R (law.runUpTo M s (law.renumber xs L M t))) ∧
      (R (law.runUpTo L s (t + 1)) ↔ R (law.runUpTo M s (law.renumber xs L M t + 1))) :=
  ⟨⟨reads _ _ fun _ touch => (runUpTo_renumber listed inL inM s at_t touch).1,
    reads _ _ fun _ touch => (runUpTo_renumber listed inL inM s at_t touch).1.symm⟩,
   ⟨reads _ _ fun _ touch => (runUpTo_renumber listed inL inM s at_t touch).2,
    reads _ _ fun _ touch => (runUpTo_renumber listed inL inM s at_t touch).2.symm⟩⟩

/-- **Each relatum's standing changes alike through the renumbering**: either the relatum stands
alike before and after the step in both, or it stands across the step as before in both. -/
theorem change_renumber {xs : List X} (listed : ∀ x, x ∈ xs) {c : X → List E} {L M : List E}
    (inL : law.Interleaves c L) (inM : law.Interleaves c M) (touchL : law.Touching L)
    (touchM : law.Touching M) (s : X → σ) (t : Nat) (x : X) :
    (law.runUpTo M s (law.renumber xs L M t) x = law.runUpTo L s t x ∧
        law.runUpTo M s (law.renumber xs L M t + 1) x = law.runUpTo L s (t + 1) x) ∨
      (law.runUpTo L s (t + 1) x = law.runUpTo L s t x ∧
        law.runUpTo M s (law.renumber xs L M t + 1) x =
          law.runUpTo M s (law.renumber xs L M t) x) :=
  match h : law.touchAt L t x with
  | true => match touchAt_iff.1 h with
    | ⟨_, at_t, touch⟩ =>
      .inl ⟨(runUpTo_renumber listed inL inM s at_t touch).1.symm,
        (runUpTo_renumber listed inL inM s at_t touch).2.symm⟩
  | false =>
    .inr ⟨runUpTo_untouched L s h, runUpTo_untouched M s
      ((touchAt_renumber listed inL inM touchL touchM t x).trans h)⟩

end Renumbering

/-! ### The worlds of two interleavings through the renumbering -/

/-- **The world's activity is the decided touch**: a relatum is active at step `t` exactly where the
exchange at `t` touches it. -/
theorem world_active_iff (xs : List X) (L : List E) (s : X → Nat) (t : Nat) (x : X) :
    (world law' xs L s).web.active t x ↔ ∃ e, exchangeAt L t = some e ∧ law'.touches e x = true :=
  touchAt_iff

/-- **Activity agrees through the renumbering**, for every relatum at every step: a relatum is
active at step `t` of one world exactly where it is active at the renumbered step of the other. -/
theorem world_renumber_active {xs xs' : List X} (listed : ∀ x, x ∈ xs) {c : X → List E}
    {L M : List E} (inL : law'.Interleaves c L) (inM : law'.Interleaves c M)
    (touchL : law'.Touching L) (touchM : law'.Touching M) (s : X → Nat) (t : Nat) (x : X) :
    (world law' xs' L s).web.active t x =
      (world law' xs' M s).web.active (law'.renumber xs L M t) x :=
  congrArg (· = true) (touchAt_renumber listed inL inM touchL touchM t x).symm

/-- **Levels agree through the renumbering** on what the step's exchange touches, before it and
after it; on those steps the step after is the relatum's index map (`world_index`). -/
theorem world_renumber_level {xs xs' : List X} (listed : ∀ x, x ∈ xs) {c : X → List E}
    {L M : List E} (inL : law'.Interleaves c L) (inM : law'.Interleaves c M) (s : X → Nat)
    {t : Nat} {e : E} (at_t : exchangeAt L t = some e) {x : X} (touch : law'.touches e x = true) :
    (world law' xs' L s).web.level t x =
        (world law' xs' M s).web.level (law'.renumber xs L M t) x ∧
      (world law' xs' L s).web.level (t + 1) x =
        (world law' xs' M s).web.level (law'.renumber xs L M t + 1) x ∧
      law'.indexMap x L M (t + 1) = law'.renumber xs L M t + 1 :=
  ⟨(runUpTo_renumber listed inL inM s at_t touch).1, (runUpTo_renumber listed inL inM s at_t touch).2,
   renumber_index listed inL inM at_t touch⟩

/-- **Every relation read at one step on what its exchange touches reads alike through the
renumbering**, however many relata it reads. -/
theorem world_renumber_reads {xs xs' : List X} (listed : ∀ x, x ∈ xs) {c : X → List E}
    {L M : List E} (inL : law'.Interleaves c L) (inM : law'.Interleaves c M) (s : X → Nat)
    {t : Nat} {e : E} (at_t : exchangeAt L t = some e) (R : (X → Nat) → Prop)
    (reads : ∀ l l', (∀ y, law'.touches e y = true → l y = l' y) → R l → R l') :
    (R ((world law' xs' L s).web.level t) ↔
        R ((world law' xs' M s).web.level (law'.renumber xs L M t))) ∧
      (R ((world law' xs' L s).web.level (t + 1)) ↔
        R ((world law' xs' M s).web.level (law'.renumber xs L M t + 1))) :=
  reads_renumber listed inL inM s at_t R reads

theorem fall_of_change {l l' m m' : X → Nat} {c : X} (same : m c - m' c = l c - l' c) (f : X) :
    fall m m' f c = fall l l' f c := by
  show (if f = c then m c - m' c else 0) = (if f = c then l c - l' c else 0)
  rw [same]

theorem rise_of_change {l l' m m' : X → Nat} {c : X} (same : m' c - m c = l' c - l c) (f : X) :
    rise m m' f c = rise l l' f c := by
  show (if f = c then m' c - m c else 0) = (if f = c then l' c - l c else 0)
  rw [same]

/-- **The renumbered step takes the same exchange**: the same relata present, each taking and
giving the same (`Flow.SameExchange` of `Becoming.Reordering`), at every step. -/
theorem world_renumber_flow {xs xs' : List X} (listed : ∀ x, x ∈ xs) {c : X → List E}
    {L M : List E} (inL : law'.Interleaves c L) (inM : law'.Interleaves c M)
    (touchL : law'.Touching L) (touchM : law'.Touching M) (s : X → Nat) (t : Nat) :
    (world law' xs' L s).flow.SameExchange t (world law' xs' M s).flow (law'.renumber xs L M t) :=
  have both : ∀ c', (law'.runUpTo M s (law'.renumber xs L M t) c' -
        law'.runUpTo M s (law'.renumber xs L M t + 1) c' =
        law'.runUpTo L s t c' - law'.runUpTo L s (t + 1) c') ∧
      (law'.runUpTo M s (law'.renumber xs L M t + 1) c' -
        law'.runUpTo M s (law'.renumber xs L M t) c' =
        law'.runUpTo L s (t + 1) c' - law'.runUpTo L s t c') := fun c' =>
    match change_renumber listed inL inM touchL touchM s t c' with
    | .inl ⟨before, after⟩ => by rw [before, after]; exact ⟨rfl, rfl⟩
    | .inr ⟨stillL, stillM⟩ => by rw [stillL, stillM, Nat.sub_self, Nat.sub_self]; exact ⟨rfl, rfl⟩
  ⟨by
    show (match exchangeAt M (law'.renumber xs L M t) with
      | none => []
      | some e => law'.touchedIn e xs') = (match exchangeAt L t with
      | none => []
      | some e => law'.touchedIn e xs')
    rw [renumber_exchange listed inL inM touchL touchM t],
   fun f c' => ⟨fall_of_change (X := X) (both c').1 f, rise_of_change (X := X) (both c').2 f⟩⟩

/-! ### The correspondence with `Becoming.Reordering` -/

/-- The world an interleaving builds, with a footprint. -/
def footprinted (law : LocalLaw X E Nat) (xs : List X) (L : List E) (s : X → Nat)
    (touch : Nat → X → Bool) : Footprinted X :=
  ⟨(world law xs L s).flow, (world law xs L s).web, touch⟩

variable (law) in
/-- **The footprint around a step**: the relata the exchange at the step or at the next touches. -/
def touchAround (L : List E) (t : Nat) (x : X) : Bool :=
  law.touchAt L t x || law.touchAt L (t + 1) x

omit [DecidableEq X] in
theorem bool_or_false_left : ∀ {a b : Bool}, (a || b) = false → a = false
  | false, _, _ => rfl
  | true, _, h => Bool.noConfusion h

omit [DecidableEq X] in
theorem bool_or_false_right : ∀ {a b : Bool}, (a || b) = false → b = false
  | _, false, _ => rfl
  | false, true, h => Bool.noConfusion h
  | true, true, h => Bool.noConfusion h

omit [DecidableEq X] in
theorem bool_or_of_left : ∀ {a : Bool} (b : Bool), a = true → (a || b) = true
  | true, _, _ => rfl

omit [DecidableEq X] in
theorem bool_or_of_right : ∀ (a : Bool) {b : Bool}, b = true → (a || b) = true
  | false, true, _ => rfl
  | true, true, _ => rfl

/-- A relatum untouched at a step and at the next takes no part in the step and is unmoved
across it, activity included. -/
theorem untouched_unmoved {xs : List X} {L : List E} {s : X → Nat} {touch : Nat → X → Bool}
    {n : Nat} {x : X} (here : law'.touchAt L n x = false)
    (next : law'.touchAt L (n + 1) x = false) :
    ¬ x ∈ (footprinted law' xs L s touch).flow.present n ∧
      (footprinted law' xs L s touch).web.Unmoved n x := by
  refine ⟨fun mem => ?_, runUpTo_untouched L s here,
    congrArg (· = true) (next.trans here.symm), fun _ => ⟨rfl, rfl, rfl⟩⟩
  have mem : x ∈ (match exchangeAt L n with
    | none => []
    | some e => law'.touchedIn e xs) := mem
  cases at_n : exchangeAt L n with
  | none =>
    rw [at_n] at mem
    exact nomatch mem
  | some e =>
    rw [at_n] at mem
    exact touchedIn_not_mem ((touchAt_some at_n x).symm.trans here) mem

/-- **The footprint of the touches contains the exchanges exactly where no relatum is touched at a
step after one that does not touch it.** The world marks a relatum active at the steps whose
exchange touches it, so across a step not touching a relatum its activity changes wherever the
next step touches it, and `Contains` asks it unmoved. -/
theorem touch_contains_iff (xs : List X) (L : List E) (s : X → Nat) :
    (footprinted law' xs L s (law'.touchAt L)).Contains ↔
      ∀ n x, law'.touchAt L n x = false → law'.touchAt L (n + 1) x = false :=
  ⟨fun contains n x no => match h : law'.touchAt L (n + 1) x with
    | false => rfl
    | true => bool_absurd (cast (contains n x no).2.2.1 h) no,
   fun later _ _ no => untouched_unmoved no (later _ _ no)⟩

/-- **The footprint around each step contains the exchanges**, activity included. -/
theorem around_contains (xs : List X) (L : List E) (s : X → Nat) :
    (footprinted law' xs L s (law'.touchAround L)).Contains :=
  fun _ _ no => untouched_unmoved (bool_or_false_left no) (bool_or_false_right no)

/-- **Around each step, every two consecutive exchanges are joined**: the footprint around a step
and around the next both hold what the next exchange touches. -/
theorem around_joined (xs : List X) {L : List E} (s : X → Nat) (touchL : law'.Touching L)
    {t : Nat} (below : t + 1 < L.length) :
    (footprinted law' xs L s (law'.touchAround L)).Joined t (t + 1) :=
  match exchangeAt_some L below with
  | ⟨e, at_next⟩ => match touchL (t + 1) e at_next with
    | ⟨x, touch⟩ =>
      have next : law'.touchAt L (t + 1) x = true := (touchAt_some at_next x).trans touch
      .inl ⟨x, bool_or_of_right _ next, bool_or_of_left _ next⟩

omit [DecidableEq X] in
/-- **Where every two consecutive steps of a stretch from `0` are joined, the only renumbering
keeping the order is none**: it fixes every step of the stretch. -/
theorem keeps_consecutive {r : Footprinted X} {m : Nat} {π ρ : Nat → Nat}
    (joined : ∀ i, i + 1 < m → r.Joined i (i + 1)) (reindex : Reindexes 0 m π ρ)
    (keeps : r.Keeps 0 m π) : ∀ i, i < m → π i = i :=
  have toZero : ∀ {i : Nat}, i < m → i < 0 + m := fun lt =>
    Nat.lt_of_lt_of_le lt (Nat.le_of_eq (Nat.zero_add m).symm)
  have inc : ∀ i, i + 1 < m → π i < π (i + 1) := fun i lt =>
    keeps i (i + 1) (Nat.zero_le _) (toZero lt) (Nat.lt_succ_self i) (joined i lt)
  have range : ∀ i, i < m → π i < m := fun i lt =>
    Nat.lt_of_lt_of_le (reindex i (Nat.zero_le _) (toZero lt)).1.2.1
      (Nat.le_of_eq (Nat.zero_add m))
  have lower : ∀ i, i < m → i ≤ π i := fun i => Nat.rec (motive := fun i => i < m → i ≤ π i)
    (fun _ => Nat.zero_le _)
    (fun i earlier lt => Nat.succ_le_of_lt (Nat.lt_of_le_of_lt
      (earlier (Nat.lt_trans (Nat.lt_succ_self i) lt)) (inc i lt))) i
  have upper : ∀ k i, i + k < m → π i + k < m := fun k => Nat.rec
    (motive := fun k => ∀ i, i + k < m → π i + k < m) (fun i lt => range i lt)
    (fun k earlier i lt =>
      have lt' : i + 1 + k < m := Nat.lt_of_le_of_lt (Nat.le_of_eq (Nat.add_right_comm i 1 k)) lt
      have step : π i + 1 ≤ π (i + 1) :=
        inc i (Nat.lt_of_le_of_lt (Nat.add_le_add_left (Nat.succ_le_succ (Nat.zero_le k)) i) lt)
      Nat.lt_of_le_of_lt (Nat.le_trans (Nat.le_of_eq (Nat.add_right_comm (π i) 1 k).symm)
        (Nat.add_le_add_right step k)) (earlier (i + 1) lt')) k
  fun i lt => match le_dest (Nat.succ_le_of_lt lt) with
    | ⟨k, eq⟩ =>
      have bound : π i + k < i + 1 + k :=
        Nat.lt_of_lt_of_le (upper k i (Nat.lt_of_lt_of_le (Nat.add_lt_add_right
          (Nat.lt_succ_self i) k) (Nat.le_of_eq eq.symm))) (Nat.le_of_eq eq)
      Nat.le_antisymm (Nat.le_of_lt_succ (Nat.lt_of_add_lt_add_right bound)) (lower i lt)

/-- **Around each step, the only renumbering of the steps keeping the order is none**: for a list
every exchange of which touches a relatum, a renumbering of the steps below its length keeping the
order of the footprint around each step fixes every step. -/
theorem around_keeps_identity (xs : List X) {L : List E} (s : X → Nat) (touchL : law'.Touching L)
    {π ρ : Nat → Nat} (reindex : Reindexes 0 L.length π ρ)
    (keeps : (footprinted law' xs L s (law'.touchAround L)).Keeps 0 L.length π) :
    ∀ i, i < L.length → π i = i :=
  keeps_consecutive (fun _ below => around_joined xs s touchL below) reindex keeps

/-- **The renumbering keeps the order of exchanges sharing a relatum**: it `Keeps` the order of the
footprint of the touches, in which two exchanges are joined exactly where they touch a relatum in
common (the world requiring nothing). -/
theorem renumber_keeps {xs xs' : List X} (listed : ∀ x, x ∈ xs) {c : X → List E} {L M : List E}
    (inL : law'.Interleaves c L) (inM : law'.Interleaves c M) (s : X → Nat) :
    (footprinted law' xs' L s (law'.touchAt L)).Keeps 0 L.length (law'.renumber xs L M) :=
  fun i j _ _ lt joined => match joined with
  | .inl ⟨x, ti, tj⟩ => match touchAt_iff.1 ti, touchAt_iff.1 tj with
    | ⟨_, at_i, touchI⟩, ⟨_, at_j, touchJ⟩ =>
      have countI := renumber_count listed inL inM at_i touchI
      have countJ := renumber_count listed inL inM at_j touchJ
      have more : law'.ownCount x L i + 1 ≤ law'.ownCount x L j :=
        Nat.le_trans (Nat.le_of_eq (exchangeAt_own x L i at_i touchI).2.symm)
          (ownCount_mono (law := law') x L (Nat.succ_le_of_lt lt))
      match Nat.lt_or_ge (law'.renumber xs L M i) (law'.renumber xs L M j) with
      | .inl done => done
      | .inr ge => absurd (Nat.le_trans more (Nat.le_trans (Nat.le_of_eq countJ.symm)
          (Nat.le_trans (ownCount_mono (law := law') x M ge) (Nat.le_of_eq countI))))
          (Nat.not_succ_le_self _)
  | .inr (.inl ⟨_, _, _, _, requires⟩) => match requires with
    | .inl no => (no : False).elim
    | .inr no => (no : False).elim
  | .inr (.inr ⟨_, _, _, _, requires⟩) => match requires with
    | .inl no => (no : False).elim
    | .inr no => (no : False).elim

/-- **The correspondence with `Becoming.Reordering`, on the worlds.** For two interleavings of the
same courses, every exchange of each touching a relatum, the renumbering and the renumbering the
other way `Reindexes` the steps below the length, and the renumbering fixes every step from it on;
it keeps the order of the footprint of the touches; the renumbered step of the other world takes
the same exchange; and it touches what the step touches. These are the premises of Reordering's
`converse` that hold here; its premise `Contains` holds of the footprint of the touches exactly as
`touch_contains_iff` states. -/
theorem world_renumber_correspondence {xs xs' : List X} (listed : ∀ x, x ∈ xs) {c : X → List E}
    {L M : List E} (inL : law'.Interleaves c L) (inM : law'.Interleaves c M)
    (touchL : law'.Touching L) (touchM : law'.Touching M) (s : X → Nat) :
    Reindexes 0 L.length (law'.renumber xs L M) (law'.renumber xs M L) ∧
      (∀ t, L.length ≤ t → law'.renumber xs L M t = t) ∧
      (footprinted law' xs' L s (law'.touchAt L)).Keeps 0 L.length (law'.renumber xs L M) ∧
      (∀ t, (footprinted law' xs' L s (law'.touchAt L)).flow.SameExchange t
        (footprinted law' xs' M s (law'.touchAt M)).flow (law'.renumber xs L M t)) ∧
      ∀ t x, (footprinted law' xs' M s (law'.touchAt M)).touch (law'.renumber xs L M t) x =
        (footprinted law' xs' L s (law'.touchAt L)).touch t x :=
  ⟨renumber_reindexes listed inL inM touchL touchM, fun _ after => renumber_beyond after,
   renumber_keeps listed inL inM s, world_renumber_flow listed inL inM touchL touchM s,
   touchAt_renumber listed inL inM touchL touchM⟩

end LocalLaw

/-! ## Witnesses -/

namespace Pair

/-- Two relata, `false` and `true`; exchange `0` touches `false`, exchange `1` touches `true`, and
every other exchange touches neither. -/
def touches : Nat → Bool → Bool
  | 0, x => !x
  | n + 1, x => match n with
    | 0 => x
    | _ + 1 => false

/-- An exchange raises each relatum it touches by one. -/
def act (e : Nat) (s : Bool → Nat) (x : Bool) : Nat :=
  match touches e x with
  | true => s x + 1
  | false => s x

theorem keeps (e : Nat) (s : Bool → Nat) (x : Bool) (no : touches e x = false) :
    act e s x = s x := by
  show (match touches e x with
    | true => s x + 1
    | false => s x) = s x
  rw [no]

theorem reads (e : Nat) (s s' : Bool → Nat) (x : Bool)
    (same : ∀ y, touches e y = true → s y = s' y) (touch : touches e x = true) :
    act e s x = act e s' x := by
  show (match touches e x with
    | true => s x + 1
    | false => s x) = (match touches e x with
    | true => s' x + 1
    | false => s' x)
  rw [touch, same x touch]

/-- The local law of the pair. -/
def law : LocalLaw Bool Nat Nat := ⟨touches, act, keeps, reads⟩

/-- Both relata start at nothing. -/
def start : Bool → Nat := fun _ => 0

/-- **What two relata no exchange connects stand at, read at one step, is not the same for every
interleaving.** `[0, 1]` and `[1, 0]` interleave the same courses and the renumbering exchanges
their two steps; at step `1` of the first world `true` stands below `false`, and at no step of
the second does. -/
theorem apart_differs :
    law.Interleaves (fun x => law.ownCourse x [0, 1]) [1, 0] ∧
      law.renumber [false, true] [0, 1] [1, 0] 0 = 1 ∧
      law.renumber [false, true] [0, 1] [1, 0] 1 = 0 ∧
      (LocalLaw.world law [false, true] [0, 1] start).web.level 1 true <
        (LocalLaw.world law [false, true] [0, 1] start).web.level 1 false ∧
      ¬ ∃ t, (LocalLaw.world law [false, true] [1, 0] start).web.level t true <
        (LocalLaw.world law [false, true] [1, 0] start).web.level t false :=
  ⟨fun x => match x with
    | false => rfl
    | true => rfl,
   rfl, rfl, Nat.lt_succ_self 0,
   fun ⟨t, lt⟩ => match t, lt with
    | 0, lt => Nat.lt_irrefl 0 lt
    | 1, lt => Nat.not_succ_le_zero 1 lt
    | _ + 2, lt => Nat.lt_irrefl 1 lt⟩

/-- **The footprint of the touches does not contain the exchanges of `[0, 1]`**: `true` is
untouched at step `0` and touched at step `1`, so its activity changes across a step not
touching it. -/
theorem touch_not_contains :
    ¬ (LocalLaw.footprinted law [false, true] [0, 1] start (law.touchAt [0, 1])).Contains :=
  fun contains => Bool.noConfusion
    ((LocalLaw.touch_contains_iff [false, true] [0, 1] start).1 contains 0 true rfl)

/-- **An exchange touching no relatum is matched by none**: `[2]` and `[]` give every relatum the
same own course, while `[2]` has an exchange at step `0` that `[]` has at no step. -/
theorem idle_unmatched :
    (∀ x, law.ownCourse x [2] = law.ownCourse x []) ∧ LocalLaw.exchangeAt [2] 0 = some 2 ∧
      ¬ ∃ p, LocalLaw.exchangeAt ([] : List Nat) p = some 2 :=
  ⟨fun x => match x with
    | false => rfl
    | true => rfl,
   rfl, fun ⟨_, h⟩ => nomatch h⟩

end Pair

/-! ## Exchanges sharing a relatum need not commute -/

namespace Shared

/-- One relatum and two exchanges touching it: the first adds one to its amount, the second
doubles it. -/
def law : LocalLaw Unit Bool Nat where
  touches _ _ := true
  act e s _ := match e with
    | true => s () + 1
    | false => 2 * s ()
  keeps _ _ _ no := nomatch no
  reads e _ _ _ same _ := match e with
    | true => congrArg (· + 1) (same () rfl)
    | false => congrArg (2 * ·) (same () rfl)

/-- **The condition of `act_comm` cannot be dropped.** The two exchanges share their relatum,
and taken in the two orders from the same configuration they reach different configurations:
adding then doubling gives two, doubling then adding gives one. -/
theorem order_matters :
    ¬ law.Apart true false ∧ law.run [true, false] (fun _ => 0) () = 2 ∧
      law.run [false, true] (fun _ => 0) () = 1 :=
  ⟨fun apart => (nomatch apart () rfl), rfl, rfl⟩

end Shared

end Interleavings

end Becoming
