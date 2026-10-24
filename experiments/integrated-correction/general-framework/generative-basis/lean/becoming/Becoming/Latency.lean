import Becoming.TimedResponse

/-!
# Latency: what a reader can come to know of an act, step by step

`Becoming.TimedResponse` states that no answer a reader gives through its couplings differs
between the courses with and without an act before a potential route of exchanges has carried the
difference into a condition coupled into it (`TimedResponse.answer_alike_before`), and that what
reaches it lies within its responsive reach (`TimedResponse.reachedBy_within_response`). This
module counts routes by their links and states how fast what a reader can come to know grows.

* **Routes counted by links.** A condition lies within one link of the source where a source
  formation exchanges with it, and within `n + 1` where a formation coupled into a condition within
  `n` links exchanges with it (`TimedResponse.Linked`); every such condition lies within at least
  one link (`Linked.one_le`).
* **One link a step.** Where every source step is at `S` or later, a potential route reaches a
  condition at step `t` only within `t − S` links (`TimedResponse.Spread.linked`): each link takes
  a step. So whatever reaches a reader by `T` came through a condition coupled into it within
  `T − S` links (`TimedResponse.reachedBy_linked`), and where no condition coupled into the reader
  lies so near, nothing reaches it by `T` (`TimedResponse.not_reached_of_far`).
* **What a reader can know by a step.** Under `TimedResponse`'s deadline premises (balance before
  the deadline in both courses, the same formations present, common initial levels, and every
  formation other than a source exchanging alike wherever it is alike through its couplings), no
  answer the reader gives through its couplings differs by `T` unless a condition coupled into it
  lies within `T − S` links of the source (`TimedResponse.answer_alike_far`). The region a reader
  can represent from what it reads is drawn along coupling links (with
  `TimedResponse.reachedBy_within_response`) and grows by at most one link a step.
* **The bound is attained** (`Relay`). A source signals into a first condition at step 1, a relay
  coupled into it passes the signal into a second condition at step 2, and a reader is coupled into
  the second. Every condition coupled into the reader lies at least two links away
  (`Relay.reader_far`), so nothing reaches it by step 2 (`Relay.not_reached_at_two`); it is reached
  by step 3 (`Relay.reached_at_three`), and its answer is alike at step 2 and differs at step 3
  (`Relay.answers_two_and_three`).

Premises: the deadline premises of `TimedResponse` where stated, and that every source step is at
`S` or later. Discrete steps; a step carries a difference across one link at most because an
exchange at `t` first affects levels at `t + 1` (`TimedResponse`'s reading). No Lean axiom is used.
-/

namespace Becoming
namespace TimedResponse

variable {F C : Type}

/-- **A condition within `n` coupling links of the source.** -/
inductive Linked (L L' : Flow F C) (W : Web F C) (obs : F → C → Prop)
    (source : Nat → F → Prop) : Nat → C → Prop
  | input {t h c} : source t h → TouchesAt L L' t h c → Linked L L' W obs source 1 c
  | response {n s t h c d} : Linked L L' W obs source n d → CoupledIntoAt W obs h s d →
      TouchesAt L L' t h c → Linked L L' W obs source (n + 1) c

variable {L L' : Flow F C} {W W' : Web F C} {obs : F → C → Prop} {source : Nat → F → Prop}
  {S : Nat}

theorem Linked.one_le {n : Nat} {c : C} (linked : Linked L L' W obs source n c) : 1 ≤ n :=
  match linked with
  | .input _ _ => Nat.le_refl 1
  | .response _ _ _ => Nat.succ_le_succ (Nat.zero_le _)

/-- **One link a step.** Where every source step is at `S` or later, a potential route reaches a
condition at step `t` only within `t − S` links. -/
theorem Spread.linked (late : ∀ t h, source t h → S ≤ t) {t : Nat} {c : C}
    (spread : Spread L L' W obs source t c) :
    ∃ n, Linked L L' W obs source n c ∧ S + n ≤ t := by
  induction spread with
  | hold _ ih =>
      match ih with
      | ⟨n, linked, le⟩ => exact ⟨n, linked, Nat.le_succ_of_le le⟩
  | input src touch => exact ⟨1, .input src touch, Nat.succ_le_succ (late _ _ src)⟩
  | response _ earlier reg touch ih =>
      match ih with
      | ⟨n, linked, le⟩ =>
          exact ⟨n + 1, .response linked reg touch, Nat.succ_le_succ (Nat.le_trans le earlier)⟩

/-- Whatever reaches a reader by `T` came through a condition coupled into it within `T − S`
links. -/
theorem reachedBy_linked (late : ∀ t h, source t h → S ≤ t) {g : F} {T : Nat}
    (reached : ReachedBy L L' W obs source g T) :
    ∃ n s c, CoupledIntoAt W obs g s c ∧ Linked L L' W obs source n c ∧ S + n ≤ T :=
  match reached with
  | ⟨s, c, before, reg, spread⟩ =>
      match spread.linked late with
      | ⟨n, linked, le⟩ => ⟨n, s, c, reg, linked, Nat.le_trans le before⟩

/-- Where no condition coupled into the reader lies within `T − S` links, nothing reaches it by
`T`. -/
theorem not_reached_of_far (late : ∀ t h, source t h → S ≤ t) {g : F} {T : Nat}
    (far : ∀ n s c, s ≤ T → CoupledIntoAt W obs g s c → Linked L L' W obs source n c →
      T < S + n) :
    ¬ ReachedBy L L' W obs source g T :=
  fun ⟨s, c, before, reg, spread⟩ =>
    match spread.linked late with
    | ⟨n, linked, le⟩ =>
        Nat.lt_irrefl T (Nat.lt_of_lt_of_le (far n s c before reg linked) (Nat.le_trans le before))

/-- **What a reader can know by a step.** Under the deadline premises, no answer the reader gives
through its couplings differs by `D` unless a condition coupled into it lies within `D − S` links
of the source. -/
theorem answer_alike_far {D : Nat}
    (balanced : ∀ t, t < D → ∀ c,
      W.level (t+1) c + L.taken t c = W.level t c + L.given t c)
    (balanced' : ∀ t, t < D → ∀ c,
      W'.level (t+1) c + L'.taken t c = W'.level t c + L'.given t c)
    (present : ∀ t, t < D → L.present t = L'.present t)
    (start : ∀ c, W.level 0 c = W'.level 0 c)
    (responds : ∀ t, t < D → ∀ h, ¬ source t h →
      W.AlikeThroughUpTo obs h W.level W'.level t →
      ∀ c, L.take t h c = L'.take t h c ∧ L.give t h c = L'.give t h c)
    (late : ∀ t h, source t h → S ≤ t) {A : Type} {g : F}
    (read : (Nat → C → Nat) → A)
    (through : ∀ l l', W.AlikeThroughUpTo obs g l l' D → read l = read l')
    (far : ∀ n s c, s ≤ D → CoupledIntoAt W obs g s c → Linked L L' W obs source n c →
      D < S + n) :
    read W.level = read W'.level :=
  answer_alike_before balanced balanced' present start responds read through
    (not_reached_of_far late far)

/-! ## The bound is attained: a relay -/

namespace Relay

/-- A source, a relay and a reader. -/
inductive Node
  | source
  | relay
  | reader

/-- Two conditions: the first the source signals into, the second the relay passes it into. -/
inductive Spot
  | first
  | second

/-- The relay is coupled by level into the first condition, the reader into the second. -/
def reads : Node → Spot → Prop
  | .source, .first => False
  | .source, .second => False
  | .relay, .first => True
  | .relay, .second => False
  | .reader, .first => False
  | .reader, .second => True

/-- What the source gives at step 1 and the relay at step 2, with and without the signal. -/
def giveAt (signal : Bool) (t : Nat) : Node → Spot → Nat
  | .source, .first => if t = 1 then (if signal then 1 else 0) else 0
  | .source, .second => 0
  | .relay, .first => 0
  | .relay, .second => if t = 2 then (if signal then 1 else 0) else 0
  | .reader, .first => 0
  | .reader, .second => 0

def flow (signal : Bool) : Flow Node Spot where
  present := fun _ => [.source, .relay, .reader]
  take := fun _ _ _ => 0
  give := fun t h c => giveAt signal t h c

def web (signal : Bool) : Web Node Spot where
  level := fun t c => match c with
    | .first => if 2 ≤ t then (if signal then 1 else 0) else 0
    | .second => if 3 ≤ t then (if signal then 1 else 0) else 0
  active := fun _ _ => True
  requires := fun _ _ _ => False
  need := fun _ _ _ => 0
  draws := fun _ _ _ => False

def sourceAt (t : Nat) (h : Node) : Prop := t = 1 ∧ h = .source

theorem late : ∀ t h, sourceAt t h → 1 ≤ t :=
  fun _ _ src => src.1 ▸ Nat.le_refl 1

/-- The source exchanges with the second condition at no step, in either course. -/
theorem source_not_second {t : Nat} :
    ¬ TouchesAt (flow false) (flow true) t .source .second :=
  fun touch => match touch.2 with
    | .inl pos => Nat.lt_irrefl 0 pos
    | .inr (.inl pos) => Nat.lt_irrefl 0 pos
    | .inr (.inr (.inl pos)) => Nat.lt_irrefl 0 pos
    | .inr (.inr (.inr pos)) => Nat.lt_irrefl 0 pos

/-- **Every condition coupled into the reader lies at least two links away.** -/
theorem reader_far : ∀ n s c, s ≤ 2 → CoupledIntoAt (web false) reads .reader s c →
    Linked (flow false) (flow true) (web false) reads sourceAt n c → 2 < 1 + n :=
  fun n s c _ reg linked =>
    match c, reg, linked with
    | .first, .inl required, _ => (required : False).elim
    | .first, .inr observed, _ => (observed : False).elim
    | .second, _, .input src touch => by
        rcases src with ⟨_, rfl⟩
        exact absurd touch source_not_second
    | .second, _, .response previous _ _ =>
        Nat.succ_le_succ (Nat.add_le_add_left previous.one_le 1)

theorem not_reached_at_two :
    ¬ ReachedBy (flow false) (flow true) (web false) reads sourceAt .reader 2 :=
  not_reached_of_far late reader_far

theorem reached_at_three :
    ReachedBy (flow false) (flow true) (web false) reads sourceAt .reader 3 :=
  ⟨3, .second, Nat.le_refl 3, .inr trivial,
    .response (s := 2) (t := 2) (h := .relay) (d := .first)
      (.input (t := 1) (h := .source) ⟨rfl, rfl⟩
        ⟨.head _, .inr (.inr (.inr (by decide)))⟩)
      (Nat.le_refl 2) (Or.inr (show reads .relay .first from trivial))
      ⟨.tail _ (.head _), .inr (.inr (.inr (by decide)))⟩⟩

/-- The reader reads the second condition. -/
def readAt (t : Nat) (l : Nat → Spot → Nat) : Bool := decide (0 < l t .second)

/-- **The reader's answer is alike at step 2 and differs at step 3.** -/
theorem answers_two_and_three :
    readAt 2 (web false).level = readAt 2 (web true).level ∧
      readAt 3 (web false).level ≠ readAt 3 (web true).level :=
  ⟨rfl, Bool.noConfusion⟩

end Relay

end TimedResponse
end Becoming
