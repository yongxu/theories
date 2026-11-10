import Becoming.PoolResponse
import Becoming.Witnesses

/-!
# Rejoining: where the courses with and without an act come back together

`Becoming.PoolResponse` (M3) shows that coupling bounds what a pool's acts respond to and fixes
nothing within the bound, and that a response reaches an actor's own act only through the actor's
coupling closure, as in `Loop`, where the response ends the actor's support. This module states,
with no premise beyond the hypotheses each statement names, what a response can do to the
difference an act makes: when the course with the act and the course without it, having parted at
a condition, rejoin there, what rejoining takes, and through whom.

The difference at a condition `c` at step `t` is whether the two webs' levels of `c` at `t` differ.
The courses rejoin at `c` where the levels, having differed, agree again. The course without the
act is a comparison, not a standard: nothing here says that rejoining it is better than keeping
or widening the difference. Whether any of these supports the generation of life in the whole is
a question the laws below do not decide; it goes through an order over courses and the condition of
the chapter's §6.15.

* **A difference changes only through a different exchange.** Two balanced flows that take the same
  total from a condition and give it the same total across a step keep its levels as alike, or as
  unlike, after the step as before (`Flow.level_alike_succ_iff`), so over steps at which they
  exchange alike with it the difference stays as it was (`Flow.level_alike_iff_of_alike`). So a
  difference that opens or closes over some steps does so across a step at which the two flows
  exchange with the condition differently (`Flow.exchange_apart_of_change`,
  `Flow.exchange_apart_of_closes`, `Flow.exchange_apart_of_opens`), and with the same formations
  present, some formation present exchanges with it differently there
  (`Flow.formation_apart_of_exchange_apart`).
* **Rejoining makes up the gap exactly.** Over steps, each flow's level of `c` at the end, with what
  it took from `c`, is its level at the start, with what it gave (`Flow.level_steps`). So where the
  courses rejoin, the levels at the start and what the two flows exchanged with `c` make up the
  gap exactly (`Flow.gap_made_up`).
* **Whatever closes the difference couples the two courses apart.** Where the rest follows a law of
  exchange reading through the coupling of each formation outside a part, a formation outside the
  part that exchanges differently in the two courses couples them apart
  (`Flow.closer_couples_apart`). So where the part acts alike after the act, a difference that
  changes after it, closing or opening, changes through a formation outside the part, present,
  exchanging with the condition differently and coupling the two courses apart
  (`Flow.changes_through_coupling_apart`, `Flow.closes_through_coupling_apart`). Rejoining is a
  response: it needs a formation whose coupling carries the difference, through the condition
  itself or through another that the act also changed.
* **Beyond the responsive reach, a difference stays.** Under the hypotheses of
  `Flow.alike_beyond_response`, where nothing within the part's responsive reach exchanges with
  `c` from a step on, the difference at `c` stays at every later step as it was at that step
  (`Flow.stays_beyond_response`).
* **Witness.** In `Replenishing`, an actor takes one unit from the condition at the first step,
  and a responder that couples into the condition, following a law that gives one unit where the
  level stands below where it started, gives it back at the next (`Replenishing.through`,
  `Replenishing.follows`, `Replenishing.balances`). The difference opens at step 1 and is closed
  from step 2 on (`Replenishing.closes`); what the responder gives back is what the act took
  (`Replenishing.made_up`); and the responder couples the two courses apart up to step 1, as
  the general law requires (`Replenishing.rejoined`). In `Loop`, the response returns to the
  actor through its closure and ends its support instead (`Loop.response_returns`): closing a
  difference and widening one share the structure of a loop through another's coupling and
  response, and differ in what the response does to the difference.

What is not derived: which law a formation follows, or that it reads through coupling; that a
response closes a difference rather than widening it, which the laws above leave to the law
followed (`ExchangeLaw.response_not_fixed_by_coupling`); which of keeping, closing or widening a
difference supports the generation of life in the whole; a difference carried at many conditions,
and the order in which they close; how a formation's law comes to give back what it couples apart.
No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

variable {F C : Type}

/-! ## A difference changes only through a different exchange -/

namespace Flow

/-- The two flows exchange alike with `c` across the step from `t`: they take the same total from
it and give it the same total. -/
def ExchangeAlikeWith (L L' : Flow F C) (t : Nat) (c : C) : Prop :=
  L.taken t c = L'.taken t c ∧ L.given t c = L'.given t c

variable {L L' : Flow F C} {W W' : Web F C} {c : C}

/-- Across a step at which two balanced flows exchange alike with `c`, its levels are alike after
the step exactly when they were alike before it. -/
theorem level_alike_succ_iff {t : Nat} (bal : L.BalancesOn W [c] t)
    (bal' : L'.BalancesOn W' [c] t) (alike : ExchangeAlikeWith L L' t c) :
    W.level (t + 1) c = W'.level (t + 1) c ↔ W.level t c = W'.level t c :=
  have e := bal c (.head [])
  have e' : W'.level (t + 1) c + L.taken t c = W'.level t c + L.given t c := by
    rw [And.left alike, And.right alike]; exact bal' c (.head [])
  ⟨fun after => add_right_cancel _ (e.symm.trans ((congrArg (· + L.taken t c) after).trans e')),
   fun before => add_right_cancel _ (e.trans ((congrArg (· + L.given t c) before).trans e'.symm))⟩

/-- Over steps at which two balanced flows exchange alike with `c`, the difference at `c` stays
as it was. -/
theorem level_alike_iff_of_alike (bal : ∀ t, L.BalancesOn W [c] t)
    (bal' : ∀ t, L'.BalancesOn W' [c] t) {s : Nat} :
    ∀ N, (∀ t, s ≤ t → t < s + N → ExchangeAlikeWith L L' t c) →
      (W.level (s + N) c = W'.level (s + N) c ↔ W.level s c = W'.level s c)
  | 0, _ => Iff.rfl
  | N + 1, alike =>
    (level_alike_succ_iff (bal (s + N)) (bal' (s + N))
      (alike (s + N) (Nat.le_add_right s N) (Nat.lt_succ_self (s + N)))).trans
      (level_alike_iff_of_alike bal bal' N fun t le lt => alike t le (Nat.lt_succ_of_lt lt))

/-- So a difference at `c` that opens or closes over some steps does so across a step at which the
two flows exchange with `c` differently. -/
theorem exchange_apart_of_change (bal : ∀ t, L.BalancesOn W [c] t)
    (bal' : ∀ t, L'.BalancesOn W' [c] t) {s : Nat} :
    ∀ N, ¬ (W.level (s + N) c = W'.level (s + N) c ↔ W.level s c = W'.level s c) →
      ∃ t, s ≤ t ∧ t < s + N ∧ ¬ ExchangeAlikeWith L L' t c
  | 0, change => absurd Iff.rfl change
  | N + 1, change =>
    match Nat.decEq (L.taken (s + N) c) (L'.taken (s + N) c),
        Nat.decEq (L.given (s + N) c) (L'.given (s + N) c) with
    | isTrue taken, isTrue given =>
      match exchange_apart_of_change bal bal' N
          (fun same => change ((level_alike_succ_iff (bal (s + N)) (bal' (s + N))
            (And.intro taken given)).trans same)) with
      | ⟨t, le, lt, apart⟩ => ⟨t, le, Nat.lt_succ_of_lt lt, apart⟩
    | isFalse taken, _ =>
      ⟨s + N, Nat.le_add_right s N, Nat.lt_succ_self (s + N), fun alike => taken (And.left alike)⟩
    | isTrue _, isFalse given =>
      ⟨s + N, Nat.le_add_right s N, Nat.lt_succ_self (s + N), fun alike => given (And.right alike)⟩

/-- A difference that closes closes across a step at which the two flows exchange with the
condition differently. -/
theorem exchange_apart_of_closes (bal : ∀ t, L.BalancesOn W [c] t)
    (bal' : ∀ t, L'.BalancesOn W' [c] t) {s N : Nat} (apart : W.level s c ≠ W'.level s c)
    (closed : W.level (s + N) c = W'.level (s + N) c) :
    ∃ t, s ≤ t ∧ t < s + N ∧ ¬ ExchangeAlikeWith L L' t c :=
  exchange_apart_of_change bal bal' N fun same => apart (same.mp closed)

/-- A difference that opens opens across a step at which the two flows exchange with the
condition differently. -/
theorem exchange_apart_of_opens (bal : ∀ t, L.BalancesOn W [c] t)
    (bal' : ∀ t, L'.BalancesOn W' [c] t) {s N : Nat} (alike : W.level s c = W'.level s c)
    (opened : W.level (s + N) c ≠ W'.level (s + N) c) :
    ∃ t, s ≤ t ∧ t < s + N ∧ ¬ ExchangeAlikeWith L L' t c :=
  exchange_apart_of_change bal bal' N fun same => opened (same.mpr alike)

end Flow

/-- Two totals over one list that differ differ at some member of the list. -/
theorem exists_apart_of_total_ne {α : Type} {p q : α → Nat} :
    ∀ {as : List α}, total as p ≠ total as q → ∃ a, a ∈ as ∧ p a ≠ q a
  | [], ne => (ne rfl).elim
  | a :: as, ne =>
    match Nat.decEq (p a) (q a) with
    | isFalse apart => ⟨a, .head as, apart⟩
    | isTrue same =>
      match exists_apart_of_total_ne (as := as)
          (fun rest => ne ((congrArg (· + total as p) same).trans (congrArg (q a + ·) rest))) with
      | ⟨b, mem, apart⟩ => ⟨b, .tail a mem, apart⟩

namespace Flow

variable {L L' : Flow F C} {W W' : Web F C} {c : C}

/-- With the same formations present, where the two flows exchange with `c` differently across a
step, some formation present takes from it or gives to it differently. -/
theorem formation_apart_of_exchange_apart {t : Nat} (present : L.present t = L'.present t)
    (apart : ¬ ExchangeAlikeWith L L' t c) :
    ∃ h, h ∈ L.present t ∧ (L.take t h c ≠ L'.take t h c ∨ L.give t h c ≠ L'.give t h c) :=
  match Nat.decEq (L.taken t c) (L'.taken t c), Nat.decEq (L.given t c) (L'.given t c) with
  | isTrue taken, isTrue given => absurd (And.intro taken given) apart
  | isFalse taken, _ =>
    match exists_apart_of_total_ne (as := L.present t) (p := fun f => L.take t f c)
        (q := fun f => L'.take t f c)
        (fun same => taken (same.trans (congrArg (fun fs => total fs fun f => L'.take t f c)
          present))) with
    | ⟨h, mem, differs⟩ => ⟨h, mem, .inl differs⟩
  | isTrue _, isFalse given =>
    match exists_apart_of_total_ne (as := L.present t) (p := fun f => L.give t f c)
        (q := fun f => L'.give t f c)
        (fun same => given (same.trans (congrArg (fun fs => total fs fun f => L'.give t f c)
          present))) with
    | ⟨h, mem, differs⟩ => ⟨h, mem, .inr differs⟩

/-! ## Closing makes up the gap exactly -/

/-- Over the steps from `s`, a balanced flow's level of `c` at the end, with what it took from
`c`, is its level at the start, with what it gave. -/
theorem level_steps (bal : ∀ t, L.BalancesOn W [c] t) :
    ∀ s N, W.level (s + N) c + total (steps s N) (fun t => L.taken t c) =
      W.level s c + total (steps s N) (fun t => L.given t c)
  | _, 0 => rfl
  | s, N + 1 =>
    have ih := level_steps bal (s + 1) N
    have shift : s + 1 + N = s + (N + 1) := Nat.succ_add s N
    have step := bal s c (.head [])
    calc W.level (s + (N + 1)) c + (L.taken s c + total (steps (s + 1) N) (fun t => L.taken t c))
        = (W.level (s + 1 + N) c + total (steps (s + 1) N) (fun t => L.taken t c)) +
            L.taken s c := by
          rw [shift, Nat.add_comm (L.taken s c), Nat.add_assoc]
      _ = (W.level (s + 1) c + L.taken s c) +
            total (steps (s + 1) N) (fun t => L.given t c) := by
          rw [ih, Nat.add_right_comm]
      _ = W.level s c + (L.given s c + total (steps (s + 1) N) (fun t => L.given t c)) := by
          rw [step, Nat.add_assoc]

/-- Where the difference at `c` closes over the steps from `s`, the levels at `s` and what the two
flows exchanged with `c` over those steps make up the gap exactly. -/
theorem gap_made_up (bal : ∀ t, L.BalancesOn W [c] t) (bal' : ∀ t, L'.BalancesOn W' [c] t)
    {s N : Nat} (closed : W.level (s + N) c = W'.level (s + N) c) :
    W.level s c + total (steps s N) (fun t => L.given t c) +
        total (steps s N) (fun t => L'.taken t c) =
      W'.level s c + total (steps s N) (fun t => L'.given t c) +
        total (steps s N) (fun t => L.taken t c) := by
  rw [← level_steps bal s N, ← level_steps bal' s N, closed, Nat.add_right_comm]

/-! ## The closer couples the two courses apart -/

variable {law : ExchangeLaw F C} {obs : F → C → Prop} {part : F → Bool}

/-- Where the rest follows a law reading through the coupling of each formation outside a part, a
formation outside the part that takes from or gives to `c` differently in the two courses across the
step from `t` couples them apart up to `t`. -/
theorem closer_couples_apart (through : law.Through W obs part)
    (follows : L.Follows law part W.level) (follows' : L'.Follows law part W'.level)
    {t : Nat} {h : F} (outside : part h = false)
    (apart : L.take t h c ≠ L'.take t h c ∨ L.give t h c ≠ L'.give t h c) :
    ¬ W.AlikeThroughUpTo obs h W.level W'.level t :=
  fun alike =>
    have gives := through h outside t W.level W'.level alike c
    apart.elim
      (fun taken => taken ((follows h outside t c).1.trans
        (gives.1.trans (follows' h outside t c).1.symm)))
      (fun given => given ((follows h outside t c).2.trans
        (gives.2.trans (follows' h outside t c).2.symm)))

/-- So where the part acts alike with `c` from step `s` on, a difference at `c` that changes over
the steps from `s` changes through a formation outside the part, present, exchanging with `c`
differently and coupling the two courses apart. -/
theorem changes_through_coupling_apart (bal : ∀ t, L.BalancesOn W [c] t)
    (bal' : ∀ t, L'.BalancesOn W' [c] t) (present : ∀ t, L.present t = L'.present t)
    (through : law.Through W obs part)
    (follows : L.Follows law part W.level) (follows' : L'.Follows law part W'.level) {s N : Nat}
    (after : ∀ t, s ≤ t → ∀ h, part h = true →
      L.take t h c = L'.take t h c ∧ L.give t h c = L'.give t h c)
    (change : ¬ (W.level (s + N) c = W'.level (s + N) c ↔ W.level s c = W'.level s c)) :
    ∃ t h, s ≤ t ∧ t < s + N ∧ h ∈ L.present t ∧ part h = false ∧
      (L.take t h c ≠ L'.take t h c ∨ L.give t h c ≠ L'.give t h c) ∧
      ¬ W.AlikeThroughUpTo obs h W.level W'.level t :=
  match exchange_apart_of_change bal bal' N change with
  | ⟨t, le, lt, apart⟩ =>
    match formation_apart_of_exchange_apart (present t) apart with
    | ⟨h, mem, differs⟩ =>
      match hp : part h with
      | false => ⟨t, h, le, lt, mem, hp, differs, closer_couples_apart through follows follows' hp
          differs⟩
      | true =>
        absurd (after t le h hp)
          fun same => differs.elim (fun taken => taken same.1) (fun given => given same.2)

/-- In particular, a difference that closes closes through such a formation. -/
theorem closes_through_coupling_apart (bal : ∀ t, L.BalancesOn W [c] t)
    (bal' : ∀ t, L'.BalancesOn W' [c] t) (present : ∀ t, L.present t = L'.present t)
    (through : law.Through W obs part)
    (follows : L.Follows law part W.level) (follows' : L'.Follows law part W'.level) {s N : Nat}
    (after : ∀ t, s ≤ t → ∀ h, part h = true →
      L.take t h c = L'.take t h c ∧ L.give t h c = L'.give t h c)
    (apart : W.level s c ≠ W'.level s c) (closed : W.level (s + N) c = W'.level (s + N) c) :
    ∃ t h, s ≤ t ∧ t < s + N ∧ h ∈ L.present t ∧ part h = false ∧
      (L.take t h c ≠ L'.take t h c ∨ L.give t h c ≠ L'.give t h c) ∧
      ¬ W.AlikeThroughUpTo obs h W.level W'.level t :=
  changes_through_coupling_apart bal bal' present through follows follows' after
    fun same => apart (same.mp closed)

/-! ## Beyond the responsive reach, a difference stays -/

/-- Under the hypotheses of `Flow.alike_beyond_response`, where nothing within the part's
responsive reach takes from or gives to `c` from step `s` on, in either flow, the difference at `c`
at every later step is what it was at `s`. -/
theorem stays_beyond_response
    (balanced : ∀ t g c, ¬ L.WithinResponse L' W obs part g → W.CoupledInto obs g c →
      L.BalancesOn W [c] t)
    (balanced' : ∀ t g c, ¬ L.WithinResponse L' W obs part g → W.CoupledInto obs g c →
      L'.BalancesOn W' [c] t)
    (present : ∀ t, L.present t = L'.present t)
    (start : ∀ g, ¬ L.WithinResponse L' W obs part g → ∀ c, W.CoupledInto obs g c →
      W.level 0 c = W'.level 0 c)
    (responds : L.RespondsThroughCoupling L' W W' obs part)
    (bal : ∀ t, L.BalancesOn W [c] t) (bal' : ∀ t, L'.BalancesOn W' [c] t) {s : Nat}
    (quiet : ∀ t, s ≤ t → ∀ h, L.WithinResponse L' W obs part h →
      L.take t h c = 0 ∧ L.give t h c = 0 ∧ L'.take t h c = 0 ∧ L'.give t h c = 0) :
    ∀ N, W.level (s + N) c = W'.level (s + N) c ↔ W.level s c = W'.level s c :=
  have each : ∀ t, s ≤ t → ∀ h, L.take t h c = L'.take t h c ∧ L.give t h c = L'.give t h c :=
    fun t le h =>
      match Nat.decEq (L.take t h c) (L'.take t h c), Nat.decEq (L.give t h c) (L'.give t h c) with
      | isTrue taken, isTrue given => ⟨taken, given⟩
      | isFalse taken, _ =>
        absurd (exchange_alike_beyond_response balanced balanced' present start responds t h
            (fun within => match quiet t le h within with
              | ⟨zero, _, zero', _⟩ => taken (zero.trans zero'.symm)) c).1 taken
      | isTrue _, isFalse given =>
        absurd (exchange_alike_beyond_response balanced balanced' present start responds t h
            (fun within => match quiet t le h within with
              | ⟨_, zero, _, zero'⟩ => given (zero.trans zero'.symm)) c).2 given
  fun N => level_alike_iff_of_alike bal bal' N fun t le _ =>
    And.intro
      ((total_congr (fun h => (each t le h).1) (L.present t)).trans
        (congrArg (fun fs => total fs fun f => L'.take t f c) (present t)))
      ((total_congr (fun h => (each t le h).2) (L.present t)).trans
        (congrArg (fun fs => total fs fun f => L'.give t f c) (present t)))

end Flow

/-! ## Witness: a responder gives back what the act took -/

namespace Replenishing

/-- The two formations. -/
inductive Member where
  | actor
  | responder

/-- The one condition. -/
inductive Cond where
  | held

open Member Cond

/-- The level of the condition with the act: the act lowers it by one across the first step, and
the responder raises it back across the second. -/
def lowered : Nat → Nat := Witnesses.profile [2, 1] 2

/-- What the act takes across each step: one unit across the first. -/
def took : Nat → Nat := Witnesses.profile [1] 0

/-- What the responder gives across each step, with the act: one unit across the second. -/
def gave : Nat → Nat := Witnesses.profile [0, 1] 0

/-- The level of the condition, with the act (`true`) or without it. -/
def level : Bool → Nat → Cond → Nat
  | true, t, _ => lowered t
  | false, _, _ => 2

/-- The web with or without the act. Only the levels are read. -/
def web (act : Bool) : Web Member Cond where
  level := level act
  active := fun _ _ => True
  requires := fun _ _ _ => False
  need := fun _ _ _ => 0
  draws := fun _ _ _ => False

/-- The flow with or without the act: with it, the actor takes one unit across the first step and
the responder gives one unit across the second. -/
def flow (act : Bool) : Flow Member Cond where
  present := fun _ => [actor, responder]
  take := fun t m _ => match act, m with
    | true, actor => took t
    | true, responder => 0
    | false, _ => 0
  give := fun t m _ => match act, m with
    | true, responder => gave t
    | true, actor => 0
    | false, _ => 0

/-- The actor is the acting part. -/
def part : Member → Bool
  | actor => true
  | responder => false

/-- The responder couples into the condition; the actor couples into nothing. -/
def obs : Member → Cond → Prop
  | actor, _ => False
  | responder, _ => True

/-- The responder's law: give one unit where the level stands below where it started. -/
def law : ExchangeLaw Member Cond where
  take := fun _ _ _ _ => 0
  give := fun t m l c => match m with
    | actor => 0
    | responder => if l t c < l 0 c then 1 else 0

/-- Both flows balance. -/
theorem balances (act : Bool) : (flow act).Balances (web act) := by
  intro t c
  cases act <;> cases c
  · rfl
  · match t with
    | 0 => rfl
    | 1 => rfl
    | _ + 2 => rfl

/-- The responder's law reads through its coupling. -/
theorem through : law.Through (web true) obs part := by
  intro h outside t l l' alike c
  cases h with
  | actor => exact nomatch (outside : true = false)
  | responder =>
    cases c
    have now := And.right (alike t (Nat.le_refl t)) held trivial
    have first := And.right (alike 0 (Nat.zero_le t)) held trivial
    exact ⟨rfl, show (if l t held < l 0 held then 1 else 0) =
      (if l' t held < l' 0 held then 1 else 0) by rw [now, first]⟩

/-- Both flows follow the responder's law under their own levels. -/
theorem follows (act : Bool) : (flow act).Follows law part (web act).level := by
  intro h outside t c
  cases h with
  | actor => exact nomatch (outside : true = false)
  | responder =>
    cases c
    cases act
    · exact ⟨rfl, rfl⟩
    · match t with
      | 0 => exact ⟨rfl, rfl⟩
      | 1 => exact ⟨rfl, rfl⟩
      | _ + 2 => exact ⟨rfl, rfl⟩

/-- The difference opens at step 1 and is closed from step 2 on. -/
theorem closes :
    (web true).level 1 held ≠ (web false).level 1 held ∧
      ∀ t, 2 ≤ t → (web true).level t held = (web false).level t held :=
  ⟨by decide,
   fun t le => match t, le with
    | 0, le => absurd le (by decide)
    | 1, le => absurd le (by decide)
    | _ + 2, _ => rfl⟩

/-- What the responder gives back is what the act took. -/
theorem made_up : (flow true).give 1 responder held = (flow true).take 0 actor held := rfl

/-- The responder closes the difference: it gives differently across the step from 1, is outside
the acting part, and couples the two courses apart up to step 1, as the general law requires. -/
theorem rejoined :
    (flow true).give 1 responder held ≠ (flow false).give 1 responder held ∧
      ¬ (web true).AlikeThroughUpTo obs responder (web true).level (web false).level 1 :=
  have differs : (flow true).give 1 responder held ≠ (flow false).give 1 responder held := by
    decide
  ⟨differs, Flow.closer_couples_apart through (follows true) (follows false) rfl (.inr differs)⟩

/-- The instance meets `Flow.closes_through_coupling_apart`: the difference at step 1 closes by
step 2 through the responder. -/
theorem closes_through :
    ∃ t h, 1 ≤ t ∧ t < 1 + 1 ∧ h ∈ (flow true).present t ∧ part h = false ∧
      ((flow true).take t h held ≠ (flow false).take t h held ∨
        (flow true).give t h held ≠ (flow false).give t h held) ∧
      ¬ (web true).AlikeThroughUpTo obs h (web true).level (web false).level t :=
  Flow.closes_through_coupling_apart (fun t => (balances true).on [held] t)
    (fun t => (balances false).on [held] t) (fun _ => rfl) through (follows true)
    (follows false)
    (fun t le h member => match h, member with
      | responder, member => nomatch (member : false = true)
      | actor, _ => match t, le with
        | 0, le => absurd le (by decide)
        | 1, _ => ⟨rfl, rfl⟩
        | _ + 2, _ => ⟨rfl, rfl⟩)
    closes.1 (closes.2 2 (Nat.le_refl 2))

end Replenishing

end Becoming
