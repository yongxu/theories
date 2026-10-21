import Becoming.BoundedSignificance
import Becoming.Frequency
import Becoming.Capture
import Becoming.Response

/-!
# MutualDependence: formations whose continuations depend on one another, and the pace it gives

`Becoming.Feedback` states four closures of a formation: its feeding closure (what feeds its
continuation, at some remove), its influence closure (what can affect it, at some remove), its reach
closure (what it can affect) and its system (what shares a condition with it, at some remove). This
module reads a web in which those closures are the whole, and states what that gives, with no premise
beyond the hypotheses each statement names.

* **Three readings, each stronger than the last.** A flow *shares conditions throughout* where every
  system is the whole (`Flow.SharesThroughout`). It is *mutually dependent* where every influence
  closure is the whole (`Flow.MutuallyDependent`): every formation's continuation can be affected, at
  some remove, by every other. It is *mutually fed* where every feeding closure is the whole
  (`Flow.MutuallyFed`): every formation's continuation is fed, at some remove, by every other.
  Mutual feeding gives mutual dependence (`Flow.MutuallyFed.mutuallyDependent`), which gives sharing
  conditions throughout (`Flow.MutuallyDependent.sharesThroughout`). Neither converse holds: in
  `Clearing` every system is the whole while the dweller lies beyond the clearer's influence closure
  (`Clearing.shares_not_mutual`); in `Drawing`, a balanced pair each taking from the condition the
  other depends on and nothing given, each can affect the other and neither feeds the other
  (`Drawing.mutual_not_fed`). `Overshoot` is mutually fed (`Overshoot.closure_whole`).
* **Mutual dependence read both ways.** `g` lies within `f`'s influence closure exactly where `f`
  lies within `g`'s reach closure (`WithinClosure.converse`, an instance of
  `WithinClosure.converse` of `Becoming.Response`), so a flow is mutually dependent exactly where every reach closure is the
  whole (`Flow.mutuallyDependent_iff_reach`): what each can affect and what can affect each are both
  everything: whatever a formation affects can, at some remove, affect it back. One condition that every formation depends on and
  exchanges with makes a flow mutually dependent (`Flow.mutuallyDependent_of_common`), and one that
  every formation requires and gives to at a step makes it mutually fed (`Flow.feeding_whole_of_common`).
* **Each reading makes its bounded significance the continuation condition.** Significance bounded
  by each center's system, influence closure or feeding closure is the continuation condition
  wherever the flow shares conditions throughout, is mutually dependent or is mutually fed
  (`Flow.SharesThroughout.unrestricted`, `Flow.MutuallyDependent.unrestricted`,
  `Flow.MutuallyFed.unrestricted`): the last generalizes `Flow.feeding_unrestricted_of_common` from
  one common condition to any web of mutual feeding.
* **Couplings at every step around a loop: exponential both ways.** Along couplings that hold at every
  step a chain leads one coupling a step (`CoupledAlways.chainInTime`), so a loop of `m + 1` such
  couplings returns what reached a condition every `m + 1` steps (`roundTrip_of_coupledAlways`). Each
  return at least doubles it (`carried_roundTrip`): after `R` turns the most difference that can
  arrive at the condition is at least `2 ^ R` times what had reached it (`carried_pow_around`), and
  at every condition downstream along such couplings likewise (`carried_pow_downstream`). With the
  part giving no gap after the start, starting gaps at most `D` and the strengths into each condition
  at most `M`, it is at most `D * (1 + M) ^ t` (`carried_le_pow_always`), whatever the couplings.
  Where every listed condition is coupled at every step into every listed condition
  (`CoupledThroughout`), the lower bound holds from every condition to every condition
  (`CoupledThroughout.exponential`).
* **The pace of a selection.** Where, at every generation, each carrier of a target leaves at least
  `a` offspring and each other parent at most `b`, the carriers' offspring are carriers of the next
  generation and the others' next generation is among the others' offspring (transmission, a
  premise), the carriers grow at least as `a ^ n` (`carriers_grow`), the others at most as `b ^ n`
  (`others_bounded`), and the carriers stand to the others at least `(a / b) ^ n` times as they stood
  at the start (`share_ratio_pow`).
* **A draw that exceeds everything drawn before.** Under balance, with nothing given to a condition
  across a stretch, what stands plus what has been drawn is the starting stock
  (`Flow.Balances.level_add_drawn`). Where each step's draw exceeds everything drawn before it, as a
  draw that doubles does, more than half the starting stock stands at every step of the stretch
  (`Flow.Balances.half_stands`), and such a draw lasting `n` steps needs a stock of at least
  `2 ^ n - 1` (`Flow.Balances.doubling_needs`). In `DoublingDraw` a stock of `7` meets draws of `1`, `2`
  and `4`: `4` of `7` stands at the third step, and nothing after it (`DoublingDraw.half_then_none`).

**Readings (the AI's, decided by their place in one account, D45).**
- "Highly entangled" reads as mutual dependence: every continuation can be affected, at some remove,
  by every other. Sharing conditions throughout is weaker (one can share a condition with what never
  affects one), and mutual feeding stronger. `Drawing` shows that mutual dependence is not mutual
  benefit: a race in which each draws on what the other depends on is mutually dependent.
- "Heavily coupled" reads as coupling strength; where the couplings that carry the dependence act at
  every step around a loop, the most difference that can arrive grows exponentially, with base at
  most `1 + M`. "Exponential pace" reads as this growth, and in a selection as the share ratio growing
  as `(a / b) ^ n`.
- "Very little time to react" reads through `half_stands`: under a draw that keeps exceeding
  everything drawn before, more than half the stock stands at every step it is still met, so what
  stands gives no warning; `Web.break_not_bounded` says nothing coupled in by threshold bounds the
  distance to the break.

What is not derived: that any actual web is mutually dependent; that a dependence acts as a coupling
by level with positive strength at every step, which is where the formation-level readings and the
condition-level laws meet; that amounts, not differences, grow exponentially under the first law
(the lower bounds hold of the carried amount, attained under a law that creates amounts); the
transmission premise of the selection; and how fast any actual draw grows. No ethical predicate,
ranking or axiom occurs; the continuation condition appears only as the conclusion `Unrestricted`
of the three bounded readings.
-/

namespace Becoming

variable {F C : Type}

namespace Flow

/-- **Sharing conditions throughout.** Every formation lies within every formation's system. -/
def SharesThroughout (L : Flow F C) (W : Web F C) : Prop :=
  ∀ f g, L.WithinSystem W f g

/-- **Mutual dependence.** Every formation lies within every formation's influence closure: every
formation's continuation can be affected, at some remove, by every other. -/
def MutuallyDependent (L : Flow F C) (W : Web F C) : Prop :=
  ∀ f g, L.WithinInfluence W f g

/-- **Mutual feeding.** Every formation lies within every formation's feeding closure: every
formation's continuation is fed, at some remove, by every other. -/
def MutuallyFed (L : Flow F C) (W : Web F C) : Prop :=
  ∀ f g, L.WithinFeeding W f g

variable {L : Flow F C} {W : Web F C}

/-- **Mutual dependence read forward.** A flow is mutually dependent exactly where every reach
closure is the whole. -/
theorem mutuallyDependent_iff_reach : L.MutuallyDependent W ↔ ∀ f g, L.WithinReach W f g :=
  ⟨fun dependent f g => WithinClosure.converse.mpr (dependent g f),
   fun reach f g => WithinClosure.converse.mp (reach g f)⟩

/-- Mutual feeding gives mutual dependence. -/
theorem MutuallyFed.mutuallyDependent (fed : L.MutuallyFed W) : L.MutuallyDependent W :=
  fun f g => withinInfluence_of_withinFeeding (fed f g)

/-- Mutual dependence gives sharing conditions throughout. -/
theorem MutuallyDependent.sharesThroughout (dependent : L.MutuallyDependent W) :
    L.SharesThroughout W :=
  fun f g => withinSystem_of_withinInfluence (dependent f g)

/-- One condition that every formation depends on and exchanges with makes a flow mutually
dependent. -/
theorem mutuallyDependent_of_common {c : C} (common : ∀ g, W.DependsOn g c ∧ L.Exchanges g c) :
    L.MutuallyDependent W :=
  mutuallyDependent_iff_reach.mpr (reach_whole_of_common common)

/-- **Sharing conditions throughout, bounded significance is the continuation condition.**
Significance bounded by each center's system is the continuation condition. -/
theorem SharesThroughout.unrestricted {Pos : Type} (shares : L.SharesThroughout W)
    (center : Pos → F) : Unrestricted (bounded fun q => L.WithinSystem W (center q)) :=
  fun i => shares (center i.1) i.2.2

/-- **Mutually dependent, bounded significance is the continuation condition.** Significance bounded
by each center's influence closure, what can affect its continuation, is the continuation
condition. -/
theorem MutuallyDependent.unrestricted {Pos : Type} (dependent : L.MutuallyDependent W)
    (center : Pos → F) : Unrestricted (bounded fun q => L.WithinInfluence W (center q)) :=
  fun i => dependent (center i.1) i.2.2

/-- **Mutually fed, bounded significance is the continuation condition.** Significance bounded by
each center's feeding closure, what feeds its continuation at some remove, is the continuation
condition: `feeding_unrestricted_of_common` for any web of mutual feeding, with no common
condition. -/
theorem MutuallyFed.unrestricted {Pos : Type} (fed : L.MutuallyFed W) (center : Pos → F) :
    Unrestricted (bounded fun q => L.WithinFeeding W (center q)) :=
  fun i => fed (center i.1) i.2.2

end Flow

/-! ## The readings apart -/

namespace Clearing

/-- **Sharing conditions throughout is not mutual dependence.** In `Clearing` every system is the
whole, while the dweller lies beyond the clearer's influence closure. -/
theorem shares_not_mutual : flow.SharesThroughout web ∧ ¬ flow.MutuallyDependent web :=
  ⟨system_whole.1, fun dependent => levels.2.1 (dependent .clearer .dweller)⟩

end Clearing

namespace Overshoot

end Overshoot

/-! ### Drawing on what the other depends on

Two formations, each requiring its own condition. Across the first step each takes one unit from the
other's condition; nothing gives. -/

namespace Drawing

/-- Each takes one unit from the other's condition across the first step. -/
def flow : Flow Bool Bool where
  present _ := [true, false]
  take t f c := match t, f, c with
    | 0, true, true => 0
    | 0, true, false => 1
    | 0, false, true => 1
    | 0, false, false => 0
    | _ + 1, _, _ => 0
  give _ _ _ := 0

/-- Each requires its own condition at need one; both stand at one and fall to nothing. -/
def web : Web Bool Bool where
  level t _ := match t with
    | 0 => 1
    | _ + 1 => 0
  active t _ := t = 0
  requires _ f c := f = c
  need _ _ _ := 1
  draws _ f c := f ≠ c

/-- The flow balances. -/
theorem balances : flow.Balances web
  | 0, true => rfl
  | 0, false => rfl
  | _ + 1, true => rfl
  | _ + 1, false => rfl

/-- Each is affected by the other: the other takes from the condition it requires. -/
theorem affected : flow.AffectedBy web true false ∧ flow.AffectedBy web false true :=
  ⟨⟨true, ⟨0, rfl⟩, 0, .tail _ (.head _), .inl Nat.zero_lt_one⟩,
   ⟨false, ⟨0, rfl⟩, 0, .head _, .inl Nat.zero_lt_one⟩⟩

/-- The pair is mutually dependent. -/
theorem mutuallyDependent : flow.MutuallyDependent web
  | true, true => WithinClosure.refl _
  | false, false => WithinClosure.refl _
  | true, false => WithinClosure.of_rel affected.1
  | false, true => WithinClosure.of_rel affected.2

/-- **Mutual dependence is not mutual feeding.** The pair balances and is mutually dependent, and
neither lies within the other's feeding closure: nothing gives. -/
theorem mutual_not_fed :
    flow.Balances web ∧ flow.MutuallyDependent web ∧
      ¬ flow.WithinFeeding web true false ∧ ¬ flow.WithinFeeding web false true :=
  ⟨balances, mutuallyDependent,
   fun within => Bool.noConfusion (within (fun x => x = true)
     (fun _ _ _ ⟨_, _, _, _, _, gives⟩ => absurd gives (Nat.lt_irrefl 0)) rfl),
   fun within => Bool.noConfusion (within (fun x => x = false)
     (fun _ _ _ ⟨_, _, _, _, _, gives⟩ => absurd gives (Nat.lt_irrefl 0)) rfl)⟩

end Drawing

/-! ## Couplings at every step around a loop -/

section Around

variable {cs : List C} {part : F → Bool} {σ : Nat → F → C → Nat}
  {k : Nat → F → C → Nat → C → Nat} {present : Nat → List F} {δ : C → Nat}

/-- **One coupling a step.** Along couplings holding at every step, a chain of `p` of them leads in
time order from step `T` by step `T + p`. -/
theorem CoupledAlways.chainInTime {v : Nat → C} {j : Nat}
    (always : CoupledAlways cs part k present v j) (T : Nat) :
    ∀ p, p ≤ j → ChainInTime cs part k present v T p (T + p)
  | 0, _ => Nat.le_refl T
  | p + 1, le =>
    match always p (Nat.lt_of_succ_le le) (T + p) with
    | ⟨h, mem, out, inside, pos⟩ =>
      ⟨T + p, T + p, Nat.lt_succ_self (T + p), ⟨h, mem, out, Nat.le_refl _, inside, pos⟩,
       CoupledAlways.chainInTime always T p (Nat.le_of_succ_le le)⟩

/-- **A loop of couplings at every step returns at every turn.** Around a loop of `m + 1` couplings
holding at every step, what has reached its condition from step `T` on returns to it by `T + m + 1`. -/
theorem roundTrip_of_coupledAlways {e : C} {v : Nat → C} {m : Nat} (start : v 0 = e)
    (back : v (m + 1) = e) (loop : CoupledAlways cs part k present v (m + 1)) (T : Nat) :
    RoundTrip cs part k present e T (T + (m + 1)) :=
  ⟨v, m, start, back, loop.chainInTime T (m + 1) (Nat.le_refl _)⟩

/-- **Exponential around the loop.** Around a loop of `m + 1` couplings holding at every step, after
`R` turns the carried amount at its condition, the most difference that can arrive there, is at
least `2 ^ R` times what had reached it. -/
theorem carried_pow_around {e : C} {v : Nat → C} {m : Nat} (start : v 0 = e)
    (back : v (m + 1) = e) (loop : CoupledAlways cs part k present v (m + 1)) (T R : Nat) :
    2 ^ R * carried cs part σ k present δ T e ≤
      carried cs part σ k present δ (T + (m + 1) * R) e :=
  carried_roundTrip (T := fun i => T + (m + 1) * i) R fun i _ =>
    Eq.subst (motive := fun x => RoundTrip cs part k present e (T + (m + 1) * i) x)
      (Nat.add_assoc T ((m + 1) * i) (m + 1)) (roundTrip_of_coupledAlways start back loop _)

/-- **Exponential downstream.** Where, besides, a chain of `q` couplings holding at every step leads
from the loop's condition `e` to `c`, the carried amount at `c` at step `T + (m + 1) * R + q` is at
least `2 ^ R` times what had reached `e` by `T`. -/
theorem carried_pow_downstream {e c : C} {v u : Nat → C} {m q : Nat} (start : v 0 = e)
    (back : v (m + 1) = e) (loop : CoupledAlways cs part k present v (m + 1))
    (from_ : u 0 = e) (to : u q = c) (path : CoupledAlways cs part k present u q) (T R : Nat) :
    2 ^ R * carried cs part σ k present δ T e ≤
      carried cs part σ k present δ (T + (m + 1) * R + q) c :=
  Nat.le_trans (carried_pow_around start back loop T R)
    (Eq.subst (motive := fun x => carried cs part σ k present δ (T + (m + 1) * R) e ≤
        carried cs part σ k present δ (T + (m + 1) * R + q) x) to
      (Eq.subst (motive := fun x => carried cs part σ k present δ (T + (m + 1) * R) x ≤
          carried cs part σ k present δ (T + (m + 1) * R + q) (u q)) from_
        (carried_along_in_time (path.chainInTime (T + (m + 1) * R) q (Nat.le_refl q)))))

/-- **At most exponential.** With the part giving no gap after the start, starting gaps at most `D`
and the strengths into each condition at most `M` at each step, the carried amount at step `t` is at
most `D * (1 + M) ^ t`, whatever the couplings. -/
theorem carried_le_pow_always {M D : Nat} (start : ∀ c, δ c ≤ D)
    (into : ∀ t c, inflow cs part k present t c ≤ M) (t : Nat) (c : C) :
    carried cs part (fun _ _ _ => 0) k present δ t c ≤ D * (1 + M) ^ t :=
  Eq.subst (motive := fun n => carried cs part (fun _ _ _ => 0) k present δ t c ≤ D * (1 + M) ^ n)
    (Frequency.count_always t)
    (carried_le_count (on := fun _ => true) start into (fun _ _ no => Bool.noConfusion no) t c)

/-- **Exponential both ways.** With the part giving no gap after the start, starting gaps at most
`D` and the strengths into each condition at most `M`, around a loop of `m + 1` couplings holding at
every step the carried amount at its condition after `R` turns from `T` is at least `2 ^ R` times
what had reached it by `T` and at most `D * (1 + M) ^ (T + (m + 1) * R)`. -/
theorem exponential_around {M D : Nat} (bounded : ∀ c, δ c ≤ D)
    (into : ∀ t c, inflow cs part k present t c ≤ M) {e : C} {v : Nat → C} {m : Nat}
    (start : v 0 = e) (back : v (m + 1) = e) (loop : CoupledAlways cs part k present v (m + 1))
    (T R : Nat) :
    2 ^ R * carried cs part (fun _ _ _ => 0) k present δ T e ≤
        carried cs part (fun _ _ _ => 0) k present δ (T + (m + 1) * R) e ∧
      carried cs part (fun _ _ _ => 0) k present δ (T + (m + 1) * R) e ≤
        D * (1 + M) ^ (T + (m + 1) * R) :=
  ⟨carried_pow_around start back loop T R, carried_le_pow_always bounded into _ e⟩

/-- **Coupled throughout.** Every listed condition is coupled into every listed condition at every
step, through a chain of one coupling or more. -/
def CoupledThroughout (cs : List C) (part : F → Bool) (k : Nat → F → C → Nat → C → Nat)
    (present : Nat → List F) : Prop :=
  ∀ d c, d ∈ cs → c ∈ cs → ∃ (v : Nat → C) (j : Nat),
    v 0 = d ∧ v (j + 1) = c ∧ CoupledAlways cs part k present v (j + 1)

/-- **Coupled throughout, exponential everywhere.** For every two listed conditions `e` and `c` there
are a turn length `m + 1` and a delay `q` such that, from every step `T`, after `R` turns the carried
amount at `c` is at least `2 ^ R` times what had reached `e` by `T`. -/
theorem CoupledThroughout.exponential (throughout : CoupledThroughout cs part k present) {e c : C}
    (atE : e ∈ cs) (atC : c ∈ cs) :
    ∃ m q, ∀ T R, 2 ^ R * carried cs part σ k present δ T e ≤
      carried cs part σ k present δ (T + (m + 1) * R + q) c :=
  match throughout e e atE atE, throughout e c atE atC with
  | ⟨_, m, start, back, loop⟩, ⟨_, j, from_, to, path⟩ =>
    ⟨m, j + 1, fun T R => carried_pow_downstream start back loop from_ to path T R⟩

end Around

/-! ## The pace of a selection -/

section Generations

variable {α : Type}

/-- **Carriers grow at least as `a ^ n`.** Where at every generation each carrier leaves at least `a`
offspring and the carriers' offspring are carriers of the next, the carriers after `n` generations are
at least `a ^ n` times those at the start. -/
theorem carriers_grow {kids : α → List α} {ms : Nat → List α} {a : Nat}
    (carriers : ∀ n p, p ∈ ms n → a ≤ (kids p).length)
    (transmits : ∀ n, offspringCount (ms n) kids ≤ (ms (n + 1)).length) :
    ∀ n, (ms 0).length * a ^ n ≤ (ms n).length
  | 0 => Nat.le_of_eq (Nat.mul_one _)
  | n + 1 =>
    Nat.le_trans (Nat.le_of_eq (mul_assoc_nat _ _ _).symm)
      (Nat.le_trans (Nat.mul_le_mul_right a (carriers_grow carriers transmits n))
        (Nat.le_trans (le_offspringCount (carriers n)) (transmits n)))

/-- **Others grow at most as `b ^ n`.** Where at every generation each other parent leaves at most
`b` offspring and the others of the next generation are among their offspring, the others after `n`
generations are at most `b ^ n` times those at the start. -/
theorem others_bounded {kids : α → List α} {es : Nat → List α} {b : Nat}
    (others : ∀ n p, p ∈ es n → (kids p).length ≤ b)
    (only : ∀ n, (es (n + 1)).length ≤ offspringCount (es n) kids) :
    ∀ n, (es n).length ≤ (es 0).length * b ^ n
  | 0 => Nat.le_of_eq (Nat.mul_one _).symm
  | n + 1 =>
    Nat.le_trans (only n)
      (Nat.le_trans (offspringCount_le (others n))
        (Nat.le_trans (Nat.mul_le_mul_right b (others_bounded others only n))
          (Nat.le_of_eq (mul_assoc_nat _ _ _))))

/-- **The share ratio grows at least as `(a / b) ^ n`.** Under both, the carriers after `n`
generations stand to the others at least `(a / b) ^ n` times as they stood at the start:
`(ms 0).length * a ^ n * (es n).length ≤ (ms n).length * ((es 0).length * b ^ n)`. -/
theorem share_ratio_pow {kids : α → List α} {ms es : Nat → List α} {a b : Nat}
    (carriers : ∀ n p, p ∈ ms n → a ≤ (kids p).length)
    (transmits : ∀ n, offspringCount (ms n) kids ≤ (ms (n + 1)).length)
    (others : ∀ n p, p ∈ es n → (kids p).length ≤ b)
    (only : ∀ n, (es (n + 1)).length ≤ offspringCount (es n) kids) (n : Nat) :
    (ms 0).length * a ^ n * (es n).length ≤ (ms n).length * ((es 0).length * b ^ n) :=
  Nat.mul_le_mul (carriers_grow carriers transmits n) (others_bounded others only n)

end Generations

/-! ## A draw that exceeds everything drawn before -/

/-- What a sequence of draws has drawn before step `j`. -/
def drawnBefore (draw : Nat → Nat) : Nat → Nat
  | 0 => 0
  | j + 1 => drawnBefore draw j + draw j

/-- **A draw exceeding everything before it doubles what has been drawn.** Where each draw before
step `n` exceeds everything drawn before it, two to the `j` is at most what has been drawn before
`j`, plus one, for every `j` up to `n`. -/
theorem pow_le_drawnBefore {draw : Nat → Nat} {n : Nat}
    (exceeds : ∀ j, j < n → drawnBefore draw j < draw j) :
    ∀ j, j ≤ n → 2 ^ j ≤ drawnBefore draw j + 1
  | 0, _ => Nat.le_refl 1
  | j + 1, le =>
    have ih := pow_le_drawnBefore exceeds j (Nat.le_of_succ_le le)
    Nat.le_trans (Nat.le_of_eq (Nat.mul_two (2 ^ j)))
      (Nat.le_trans (Nat.add_le_add ih ih)
        (Nat.le_trans (Nat.add_le_add_left (exceeds j (Nat.lt_of_succ_le le)) _)
          (Nat.le_of_eq (Nat.add_right_comm (drawnBefore draw j) 1 (draw j)))))

namespace Flow

variable {L : Flow F C} {W : Web F C}

/-- **What stands and what has been drawn.** Under balance, with nothing given to `c` across the
steps from `T` before `T + n`, what stands at `T + j` and what was taken from `c` across the steps
from `T` before it add up to what stood at `T`, for every `j` up to `n`. -/
theorem Balances.level_add_drawn (balances : L.Balances W) {c : C} {T n : Nat}
    (unfed : ∀ i, i < n → L.given (T + i) c = 0) :
    ∀ j, j ≤ n → W.level (T + j) c + drawnBefore (fun i => L.taken (T + i) c) j = W.level T c
  | 0, _ => rfl
  | j + 1, le =>
    have step : W.level (T + j + 1) c + L.taken (T + j) c = W.level (T + j) c :=
      (balances (T + j) c).trans (congrArg (W.level (T + j) c + ·) (unfed j (Nat.lt_of_succ_le le)))
    ((congrArg (W.level (T + j + 1) c + ·)
        (Nat.add_comm (drawnBefore (fun i => L.taken (T + i) c) j) (L.taken (T + j) c))).trans
      (Nat.add_assoc _ _ _).symm).trans
      ((congrArg (· + drawnBefore (fun i => L.taken (T + i) c) j) step).trans
        (Balances.level_add_drawn balances unfed j (Nat.le_of_succ_le le)))

/-- **Within the stock.** Under the same premises, everything taken across the `n` steps is at most
what stood at `T`. -/
theorem Balances.drawn_within (balances : L.Balances W) {c : C} {T n : Nat}
    (unfed : ∀ i, i < n → L.given (T + i) c = 0) :
    drawnBefore (fun i => L.taken (T + i) c) n ≤ W.level T c :=
  Nat.le_trans (Nat.le_add_left _ _) (Nat.le_of_eq (balances.level_add_drawn unfed n (Nat.le_refl n)))

/-- **More than half stands.** Under balance, with nothing given to `c` across the steps from `T`
before `T + n`, where each of those steps takes from `c` more than everything taken from it since
`T`, more than half of what stood at `T` stands at each of them. -/
theorem Balances.half_stands (balances : L.Balances W) {c : C} {T n : Nat}
    (unfed : ∀ i, i < n → L.given (T + i) c = 0)
    (exceeds : ∀ j, j < n → drawnBefore (fun i => L.taken (T + i) c) j < L.taken (T + j) c) :
    ∀ j, j < n → W.level T c < W.level (T + j) c + W.level (T + j) c :=
  fun j lt =>
    have step : W.level (T + j + 1) c + L.taken (T + j) c = W.level (T + j) c :=
      (balances (T + j) c).trans (congrArg (W.level (T + j) c + ·) (unfed j lt))
    have met : L.taken (T + j) c ≤ W.level (T + j) c :=
      Nat.le_trans (Nat.le_add_left _ _) (Nat.le_of_eq step)
    Nat.lt_of_le_of_lt (Nat.le_of_eq (balances.level_add_drawn unfed j (Nat.le_of_lt lt)).symm)
      (Nat.add_lt_add_left (Nat.lt_of_lt_of_le (exceeds j lt) met) _)

/-- **A doubling draw needs a doubled stock.** Under the same premises, the `n` steps need what
stood at `T` to be at least `2 ^ n - 1`. -/
theorem Balances.doubling_needs (balances : L.Balances W) {c : C} {T n : Nat}
    (unfed : ∀ i, i < n → L.given (T + i) c = 0)
    (exceeds : ∀ j, j < n → drawnBefore (fun i => L.taken (T + i) c) j < L.taken (T + j) c) :
    2 ^ n ≤ W.level T c + 1 :=
  Nat.le_trans (pow_le_drawnBefore exceeds n (Nat.le_refl n))
    (Nat.add_le_add_right (balances.drawn_within unfed) 1)

end Flow

/-! ### A doubling draw on a stock of seven

One formation takes `1`, `2` and `4` from one condition standing at `7`; nothing gives. -/

namespace DoublingDraw

/-- Draws of one, two and four, then nothing. -/
def flow : Flow Unit Unit where
  present _ := [()]
  take t _ _ := match t with
    | 0 => 1
    | 1 => 2
    | 2 => 4
    | _ + 3 => 0
  give _ _ _ := 0

/-- The condition stands at seven, six, four, then nothing. -/
def web : Web Unit Unit where
  level t _ := match t with
    | 0 => 7
    | 1 => 6
    | 2 => 4
    | _ + 3 => 0
  active _ _ := True
  requires _ _ _ := True
  need _ _ _ := 0
  draws _ _ _ := True

/-- The flow balances. -/
theorem balances : flow.Balances web
  | 0, () => rfl
  | 1, () => rfl
  | 2, () => rfl
  | _ + 3, () => rfl

/-- Each draw exceeds everything drawn before it. -/
theorem exceeds : ∀ j, j < 3 →
    drawnBefore (fun i => flow.taken (0 + i) ()) j < flow.taken (0 + j) ()
  | 0, _ => Nat.zero_lt_one
  | 1, _ => Nat.lt_succ_self 1
  | 2, _ => Nat.lt_succ_self 3
  | _ + 3, lt => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 3 _))

/-- **Half, then none.** Four of the seven stand at the third step, more than half, and nothing
stands after it; the stock is `2 ^ 3 - 1`, so `doubling_needs` is attained. -/
theorem half_then_none :
    flow.Balances web ∧ web.level 0 () < web.level 2 () + web.level 2 () ∧ web.level 3 () = 0 ∧
      2 ^ 3 = web.level 0 () + 1 :=
  ⟨balances, Flow.Balances.half_stands balances (fun _ _ => rfl) exceeds 2 (Nat.lt_succ_self 2),
   rfl, rfl⟩

end DoublingDraw

end Becoming
