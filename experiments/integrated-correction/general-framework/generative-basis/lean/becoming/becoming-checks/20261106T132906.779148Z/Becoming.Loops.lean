import Becoming.Propagation

/-!
# Loops: how a carried difference grows

`Becoming.Propagation` (P115) measures how strongly an exchange is coupled to a level and shows that
the carried amount, the course the coupling strengths generate from the starting gaps, is the most
difference that can arrive. It leaves open "a general theory of loops, with the strength around
every loop and its runaway, beyond the witnesses". This module gives that theory, within the theory without axiom and
with no premise beyond the strengths each statement names: how the carried amount is calculated
order by order, as a sum over routes; how accurate a calculation cut at a finite order is; and that
a loop upstream, and only a loop, makes a difference run away.

* **Orders.** The carried amount of order `j` (`carriedWithin`) is what routes of at most `j`
  responses carry: each order is what the strengths make of the order below (`carriedFrom`), the
  carried amount's own step taken on the order below. The orders rise (`carriedWithin_mono`) to the
  carried amount (`carriedWithin_le_carried`), and the order `j` is exact up to step `j`
  (`carriedWithin_exact`), as each step adds at most one response.
* **Where no loop lies upstream, a finite order is exact.** The level of `d` is coupled into `c`
  (`Couples`) where at some step a formation present, outside the part, exchanges with `c` with
  positive strength on a level of `d`. A chain of couplings (`Coupled`) leads from one condition to
  another; a loop (`OnLoop`) leads from a condition back to it; `e` lies upstream of `c`
  (`Upstream`) where a chain leads from `e` to `c`. Where no chain of `j + 1` couplings ends at
  `c`, the order `j` is exact at `c` at every step (`carriedWithin_exact_of_not_coupledInto`). With
  every condition listed, a chain as long as the list passes some condition twice
  (`loop_of_coupledInto`), so where no loop lies upstream of `c`, the order one less than the
  number of listed conditions is exact at `c` at every step (`carriedWithin_exact_of_no_loop`).
* **Where a loop lies upstream, no finite order is.** Where the couplings hold at every step
  (`CouplesAlways`), as stationary strengths do (`couplesAlways_of_stationary`), what has reached a
  loop upstream of `c` keeps arriving there by longer routes, so every order leaves something out
  (`carriedWithin_lt_of_loop`): a finite order is exact from every starting gap exactly where no
  loop lies upstream (`finite_order_iff_no_loop`, `finite_order_iff_no_loop_stationary`). The
  couplings must hold at every step: a loop coupled at the first step only leaves order one exact
  (`Loops.Once.not_always`).
* **The strength around a loop.** Along a chain with strengths at least `w`, what has reached its
  start, times the product of the strengths, arrives at its end (`carried_along`). Around a loop it
  returns multiplied, every time around, by at least one plus the product of the strengths around
  it (`carried_around`), so after `R` times around by that factor to the power `R`
  (`carried_runaway`). With stationary strengths and the same formations at every step, every loop
  at least doubles what reaches it, every time around (`carried_doubles_around`), and what reaches a
  loop upstream of `c` arrives at `c` so doubled (`carried_doubles_into`). Strengths are natural
  numbers, so a positive strength is at least one; with strengths below one the doubling does not
  follow.
* **How much the orders carry, and the accuracy of a cut.** With the part giving no gap after the
  start, starting gaps at most `D` and the strengths into each condition (`inflow`) summing to at
  most `M` at each step: the order `j` carries at most `D` times the sum, over orders `i ≤ j`, of
  the ways to place `i` responses among the `t` steps (`Loops.binom`) times `M ^ i`
  (`carriedWithin_le_withinBound`, `Loops.withinBound_eq`), a polynomial in `t` of degree `j`; the
  carried amount is at most `D * (1 + M) ^ t` (`carried_le_geomBound`, `Loops.geomBound_eq`); and a
  cut at order `j` misses at most the rest of that sum (`carried_le_carriedWithin_add`,
  `Loops.missBound_add_withinBound`). One condition returning its level to itself with strength
  `M`, a self-loop, attains all three (`Loops.SelfLoop.attained`), so no smaller bound follows from
  `D` and `M` alone.
* **Polynomial exactly where no loop lies upstream.** Where no loop lies upstream of `c`, the
  carried amount is at most a polynomial in the steps of degree one less than the number of listed
  conditions (`carried_le_polynomial`). A doubling outgrows every polynomial
  (`Loops.not_poly_of_doubling`), so with stationary strengths and the same formations at every
  step the carried amount at `c` is bounded by a polynomial from every starting gap exactly where no
  loop lies upstream of `c` (`polynomial_iff_no_loop`).
* **For every law.** By `most_difference_arrives`, these are statements about every law of what has
  stood with the strengths and every two balanced flows of it. Where no loop lies upstream, the
  most difference that can arrive is what the finite order carries (`most_difference_within`), and
  every gap is at most the polynomial (`gap_le_polynomial`). With stationary strengths and the same
  formations at every step, the most difference that can arrive is bounded by a polynomial exactly
  where no loop lies upstream (`gap_polynomial_iff_no_loop`).

**Readings (decided by Ren on 16 October 2026).** Ren took the first in the AI's wording, called the
second right with its qualifiers, and took the third in a refined form, for now.
- On 12 October Ren compared the theory with quantum dynamics and "Fermi's diagrams": "there are so
  many patterns and loops but we can still find a way to to integrate so we can still calculate
  this effects but how how accurate can we do that uh what is the limitation do we have losses".
  Ren meant Feynman diagrams, and the match is structural, not physical. The integration Ren asked
  about, for laws that are not determined, is the sum over histories with its four losses
  (`Becoming.Weighted`). The orders here are the same structural kind, organized by the number of
  responses as Feynman diagrams are by their vertices, `Loops.binom t i` counting the time
  orderings of `i` responses. The two are not yet joined. A cut at order `j` misses at most the
  rest of the sum, and this is attained: it is the limit of accuracy for what the strengths and the
  starting gaps alone allow. Where no loop lies upstream there is no loss at a finite order. Where a
  loop lies upstream, coupled at every step, every finite order loses something, and what reaches
  the loop grows at least geometrically.
- Only a loop makes a difference run away. Running away means growing faster than every
  polynomial, and it is of the most difference that can arrive, not of what every law does.
  Without a loop a held difference keeps arriving but grows at most polynomially
  (`Propagation.Chain` is of degree one); with a loop that couples at every step it grows at least
  geometrically (`Propagation.Loop` is the self-loop of strength one). So the most difference that
  can arrive grows faster than every polynomial only through a loop, and through every loop that
  couples at every step; couplings that hold only at some steps are open here.
- Which loops a world has is part of its situation (Ren, 16 October: "the situation makes it
  true"): loops form and dissolve within the unfolding, and the theorems take them as they stand
  at each step. The strengths are supplied, as in `Becoming.Propagation`. This reading is taken for
  now, open to revision once a theorem states how loops form within the unfolding, for example
  where a formation's drawing comes to respond to the level its drawing lowers, where this meets
  `Becoming.Runaway`.
  On 16 October, with the loop-formation theorem of `Becoming.Closing`, Ren took the reading as
  revised: loops form within the unfolding by closing, at the step at which some exchange comes
  to respond to a level downstream of the condition it gives to, and dissolve where their
  couplings stop (`Becoming.Remainder`); where the strengths are read off the course, which loops
  form and when is read off the unfolding.

What is not derived: the strengths themselves; the growth where couplings come and go, a loop
upstream then not leaving every order inexact (`Loops.Once.not_always`); how fast a runaway is
beyond the product of the strengths around a loop; laws reading infinitely many conditions; real
amounts and continuous time, where the sum over orders becomes a series and its convergence a
further question. The representation commits
to discrete steps and natural amounts. No ethical predicate, ranking or axiom occurs.

**Classical sources.** The orders are the truncated path-sum expansion of the carried amount, the
discrete-time form of a Neumann series `Σ K^j` of the coupling strengths; that a finite order is
exact exactly where no loop lies upstream is the fact that the adjacency of a directed graph is
nilpotent exactly where the graph has no cycle; the polynomial bound by binomial counts and the
geometric bound `(1 + M) ^ t` are the standard bounds of such a series. What is the spine's own is
that these are stated for every law of what has stood, through `most_difference_arrives`, with
natural amounts and no decision beyond what each theorem names.
-/

namespace Becoming

variable {F C : Type}

namespace Loops

/-- Every number is zero or positive. -/
theorem zero_or_pos : ∀ n : Nat, n = 0 ∨ 0 < n
  | 0 => .inl rfl
  | n + 1 => .inr (Nat.succ_pos n)

/-- A number is not below itself less one: `n + 1` is not at most `n`. -/
theorem ble_succ_self : ∀ n : Nat, Nat.ble (n + 1) n = false
  | 0 => rfl
  | n + 1 => ble_succ_self n

/-- `v` up to `n`, then `c`. -/
def extend (v : Nat → C) (n : Nat) (c : C) : Nat → C :=
  fun i => bif Nat.ble i n then v i else c

theorem extend_below {v : Nat → C} {n : Nat} {c : C} {i : Nat} (le : i ≤ n) :
    extend v n c i = v i :=
  congrArg (fun b => cond b (v i) c) (Nat.ble_eq_true_of_le le)

theorem extend_next (v : Nat → C) (n : Nat) (c : C) : extend v n c (n + 1) = c :=
  congrArg (fun b => cond b (v (n + 1)) c) (ble_succ_self n)

/-- What accrues from `δ` when `g t c` is added across each step `t`. -/
def accrue (δ : C → Nat) (g : Nat → C → Nat) : Nat → C → Nat
  | 0, c => δ c
  | t + 1, c => accrue δ g t c + g t c

/-- A total at most another member by member, and below it at one member, is below it. -/
theorem total_lt {α : Type} {f g : α → Nat} :
    ∀ {as : List α} {a : α}, (∀ b, b ∈ as → f b ≤ g b) → a ∈ as → f a < g a →
      total as f < total as g
  | _ :: as, _, le, .head _, lt =>
    Nat.lt_of_lt_of_le (Nat.add_lt_add_right lt _)
      (Nat.add_le_add_left (total_le as fun b mem => le b (.tail _ mem)) _)
  | b :: _, _, le, .tail _ mem, lt =>
    Nat.lt_of_le_of_lt (Nat.add_le_add_right (le b (.head _)) _)
      (Nat.add_lt_add_left (total_lt (fun b' m => le b' (.tail _ m)) mem lt) _)

/-- A total of a quantity times a constant is the total times the constant. -/
theorem total_mul_const {α : Type} (q : α → Nat) (g : Nat) (as : List α) :
    total as (fun a => q a * g) = total as q * g :=
  (total_congr (fun a => Nat.mul_comm (q a) g) as).trans
    ((total_mul g q as).trans (Nat.mul_comm g (total as q)))

/-- One at least times the multiplier. -/
theorem le_mul_of_pos {m : Nat} (pos : 0 < m) (n : Nat) : n ≤ m * n :=
  Nat.le_trans (Nat.le_of_eq (Nat.one_mul n).symm) (Nat.mul_le_mul_right n pos)

/-- Regrouping a product of three. -/
theorem mul_swap (a b c : Nat) : a * b * c = b * (a * c) :=
  (congrArg (· * c) (Nat.mul_comm a b)).trans (mul_assoc_nat b a c)

/-- One plus a number, times another. -/
theorem one_add_mul (m x : Nat) : (1 + m) * x = x + m * x :=
  (add_mul_split 1 m x).trans (congrArg (· + m * x) (Nat.one_mul x))

end Loops

/-! ## The orders of the carried amount -/

section Orders

variable {cs : List C} {part : F → Bool} {σ : Nat → F → C → Nat}
  {k : Nat → F → C → Nat → C → Nat} {present : Nat → List F} {δ : C → Nat}

/-- **What the strengths carry from given levels.** From the starting gaps `δ`, across each step,
the part's gaps and what the strengths make of the levels `l` up to the step: the carrying law
reading `l` in place of its own levels. -/
def carriedFrom (cs : List C) (part : F → Bool) (σ : Nat → F → C → Nat)
    (k : Nat → F → C → Nat → C → Nat) (present : Nat → List F) (δ : C → Nat)
    (l : Nat → C → Nat) : Nat → C → Nat :=
  Loops.accrue δ fun t c => total (present t) fun h => carriedGive cs part σ k t h c l

/-- **The orders of the carried amount.** What routes of at most `j` responses carry: with none,
the starting gaps and the part's gaps, held; each further order reading the one before. -/
def carriedWithin (cs : List C) (part : F → Bool) (σ : Nat → F → C → Nat)
    (k : Nat → F → C → Nat → C → Nat) (present : Nat → List F) (δ : C → Nat) :
    Nat → Nat → C → Nat
  | 0 => carriedFrom cs part σ k present δ fun _ _ => 0
  | j + 1 => carriedFrom cs part σ k present δ (carriedWithin cs part σ k present δ j)

/-- What a formation of the part gives is its gap. -/
theorem carriedGive_of_part {t : Nat} {h : F} {c : C} {l : Nat → C → Nat}
    (inPart : part h = true) : carriedGive cs part σ k t h c l = σ t h c :=
  congrArg (fun b => cond b (σ t h c) _) inPart

/-- What a formation outside the part gives is what its strengths make of the levels. -/
theorem carriedGive_of_rest {t : Nat} {h : F} {c : C} {l : Nat → C → Nat}
    (out : part h = false) :
    carriedGive cs part σ k t h c l =
      total (steps 0 (t + 1)) fun s => total cs fun d => k t h c s d * l s d :=
  congrArg (fun b => cond b (σ t h c) _) out

/-- Higher levels give at least as much. -/
theorem carriedGive_mono {t : Nat} {h : F} {c : C} {l l' : Nat → C → Nat}
    (le : ∀ s d, s ≤ t → d ∈ cs → l s d ≤ l' s d) :
    carriedGive cs part σ k t h c l ≤ carriedGive cs part σ k t h c l' :=
  match hp : part h with
  | true => Nat.le_of_eq ((carriedGive_of_part hp).trans (carriedGive_of_part hp).symm)
  | false =>
    Nat.le_trans (Nat.le_of_eq (carriedGive_of_rest hp))
      (Nat.le_trans (total_le _ fun s mem => total_le _ fun d dMem =>
          Nat.mul_le_mul_left _ (le s d (Propagation.le_of_mem_steps_upto mem) dMem))
        (Nat.le_of_eq (carriedGive_of_rest hp).symm))

/-- Levels that agree wherever a positive strength reads them give alike. -/
theorem carriedGive_congr {t : Nat} {h : F} {c : C} {l l' : Nat → C → Nat}
    (same : ∀ s d, s ≤ t → d ∈ cs → part h = false → 0 < k t h c s d → l s d = l' s d) :
    carriedGive cs part σ k t h c l = carriedGive cs part σ k t h c l' :=
  match hp : part h with
  | true => (carriedGive_of_part hp).trans (carriedGive_of_part hp).symm
  | false =>
    (carriedGive_of_rest hp).trans
      ((total_congr_on fun s sMem => total_congr_on fun d dMem =>
          match Loops.zero_or_pos (k t h c s d) with
          | .inl zero =>
            (congrArg (· * l s d) zero).trans ((Nat.zero_mul _).trans
              ((Nat.zero_mul (l' s d)).symm.trans (congrArg (· * l' s d) zero.symm)))
          | .inr pos =>
            congrArg (k t h c s d * ·)
              (same s d (Propagation.le_of_mem_steps_upto sMem) dMem hp pos)).trans
        (carriedGive_of_rest hp).symm)

/-- Across each step, what is carried from `l` grows by what the formations present give from it. -/
theorem carriedFrom_succ (l : Nat → C → Nat) (t : Nat) (c : C) :
    carriedFrom cs part σ k present δ l (t + 1) c =
      carriedFrom cs part σ k present δ l t c +
        total (present t) fun h => carriedGive cs part σ k t h c l := rfl

/-- **The carried amount carries itself.** Read from its own levels, the carrying law gives back the
carried amount. -/
theorem carriedFrom_carried :
    ∀ t c, carriedFrom cs part σ k present δ (carried cs part σ k present δ) t c =
      carried cs part σ k present δ t c
  | 0, _ => rfl
  | t + 1, c => (congrArg (· + _) (carriedFrom_carried t c)).trans (carried_succ t c).symm

/-- Carried from higher levels, at least as much. -/
theorem carriedFrom_mono {l l' : Nat → C → Nat} (le : ∀ s d, d ∈ cs → l s d ≤ l' s d) :
    ∀ t c, carriedFrom cs part σ k present δ l t c ≤ carriedFrom cs part σ k present δ l' t c
  | 0, _ => Nat.le_refl _
  | t + 1, c => Nat.add_le_add (carriedFrom_mono le t c)
      (total_le _ fun _ _ => carriedGive_mono fun s d _ dMem => le s d dMem)

/-- What is carried to a step reads the levels only before it. -/
theorem carriedFrom_congr {l l' : Nat → C → Nat} :
    ∀ t, (∀ s d, s < t → d ∈ cs → l s d = l' s d) → ∀ c,
      carriedFrom cs part σ k present δ l t c = carriedFrom cs part σ k present δ l' t c
  | 0, _, _ => rfl
  | t + 1, same, c =>
    Naturals.add_congr
      (carriedFrom_congr t (fun s d lt dMem => same s d (Nat.lt_succ_of_lt lt) dMem) c)
      (total_congr_on fun _ _ => carriedGive_congr fun s d le dMem _ _ =>
        same s d (Nat.lt_succ_of_le le) dMem)

/-- Where every formation present gives alike from `l` as from the carried amount, what is carried
from `l` is the carried amount. -/
theorem carriedFrom_eq_carried {l : Nat → C → Nat} {c : C}
    (alike : ∀ t h, h ∈ present t → carriedGive cs part σ k t h c l =
      carriedGive cs part σ k t h c (carried cs part σ k present δ)) :
    ∀ t, carriedFrom cs part σ k present δ l t c = carried cs part σ k present δ t c
  | 0 => rfl
  | t + 1 =>
    (Naturals.add_congr (carriedFrom_eq_carried alike t) (total_congr_on (alike t))).trans
      (carried_succ t c).symm

/-- **Every order is at most the carried amount.** -/
theorem carriedWithin_le_carried :
    ∀ j t c, carriedWithin cs part σ k present δ j t c ≤ carried cs part σ k present δ t c
  | 0, t, c => Nat.le_trans (carriedFrom_mono (fun _ _ _ => Nat.zero_le _) t c)
      (Nat.le_of_eq (carriedFrom_carried t c))
  | j + 1, t, c => Nat.le_trans
      (carriedFrom_mono (fun s d _ => carriedWithin_le_carried j s d) t c)
      (Nat.le_of_eq (carriedFrom_carried t c))

/-- **The orders rise.** -/
theorem carriedWithin_le_succ :
    ∀ j t c, carriedWithin cs part σ k present δ j t c ≤
      carriedWithin cs part σ k present δ (j + 1) t c
  | 0, t, c => carriedFrom_mono (fun _ _ _ => Nat.zero_le _) t c
  | j + 1, t, c => carriedFrom_mono (fun s d _ => carriedWithin_le_succ j s d) t c

/-- A higher order carries at least as much. -/
theorem carriedWithin_mono {j j' : Nat} (le : j ≤ j') (t : Nat) (c : C) :
    carriedWithin cs part σ k present δ j t c ≤ carriedWithin cs part σ k present δ j' t c := by
  induction le with
  | refl => exact Nat.le_refl _
  | step _ ih => exact Nat.le_trans ih (carriedWithin_le_succ _ t c)

/-- **Each order is exact up to its own step.** Every route to step `t` has at most `t` responses,
so routes of at most `j` responses carry everything to every step up to `j`. -/
theorem carriedWithin_exact :
    ∀ j t, t ≤ j → ∀ c, carriedWithin cs part σ k present δ j t c =
      carried cs part σ k present δ t c
  | 0, t, le, c => by
    have zero : t = 0 := Nat.eq_zero_of_le_zero le
    subst zero
    rfl
  | j + 1, t, le, c =>
    (carriedFrom_congr t (fun s d lt _ =>
        carriedWithin_exact j s (Nat.le_of_lt_succ (Nat.lt_of_lt_of_le lt le)) d) c).trans
      (carriedFrom_carried t c)

/-- The carried amount at a step is what routes of at most that many responses carry. -/
theorem carried_eq_carriedWithin (t : Nat) (c : C) :
    carried cs part σ k present δ t c = carriedWithin cs part σ k present δ t t c :=
  (carriedWithin_exact t t (Nat.le_refl t) c).symm

end Orders

/-! ## Couplings, chains and loops -/

section Chains

variable {cs : List C} {part : F → Bool} {σ : Nat → F → C → Nat}
  {k : Nat → F → C → Nat → C → Nat} {present : Nat → List F} {δ : C → Nat}

/-- **Coupled.** The level of `d` is coupled into `c`: at some step a formation present there,
outside the part, exchanges with `c` with positive strength on a level of `d` up to that step. -/
def Couples (cs : List C) (part : F → Bool) (k : Nat → F → C → Nat → C → Nat)
    (present : Nat → List F) (d c : C) : Prop :=
  ∃ t h s, h ∈ present t ∧ part h = false ∧ s ≤ t ∧ d ∈ cs ∧ 0 < k t h c s d

/-- **A chain of couplings.** Along `v`, each of the first `j` conditions is coupled into the next.
-/
def Coupled (cs : List C) (part : F → Bool) (k : Nat → F → C → Nat → C → Nat)
    (present : Nat → List F) (v : Nat → C) (j : Nat) : Prop :=
  ∀ i, i < j → Couples cs part k present (v i) (v (i + 1))

/-- A chain of `j` couplings ends at `c`. -/
def CoupledInto (cs : List C) (part : F → Bool) (k : Nat → F → C → Nat → C → Nat)
    (present : Nat → List F) (j : Nat) (c : C) : Prop :=
  ∃ v : Nat → C, v j = c ∧ Coupled cs part k present v j

/-- **On a loop.** A chain of one coupling or more leads from `e` back to `e`. -/
def OnLoop (cs : List C) (part : F → Bool) (k : Nat → F → C → Nat → C → Nat)
    (present : Nat → List F) (e : C) : Prop :=
  ∃ (v : Nat → C) (m : Nat), 0 < m ∧ v 0 = e ∧ v m = e ∧ Coupled cs part k present v m

/-- **Upstream.** A chain of couplings leads from `e` to `c`. -/
def Upstream (cs : List C) (part : F → Bool) (k : Nat → F → C → Nat → C → Nat)
    (present : Nat → List F) (e c : C) : Prop :=
  ∃ (v : Nat → C) (j : Nat), v 0 = e ∧ v j = c ∧ Coupled cs part k present v j

/-- A chain lengthened by one coupling at its end. -/
theorem Coupled.extend {v v' : Nat → C} {j : Nat} (chain : Coupled cs part k present v j)
    (agree : ∀ i, i ≤ j → v' i = v i) (last : Couples cs part k present (v j) (v' (j + 1))) :
    Coupled cs part k present v' (j + 1) := by
  intro i lt
  cases Nat.lt_or_ge i j with
  | inl before =>
    rw [agree i (Nat.le_of_lt before), agree (i + 1) before]
    exact chain i before
  | inr after =>
    have same : i = j := Nat.le_antisymm (Nat.le_of_lt_succ lt) after
    subst same
    rw [agree i (Nat.le_refl i)]
    exact last

/-- No coupling at all ends at each condition. -/
theorem coupledInto_zero (c : C) : CoupledInto cs part k present 0 c :=
  ⟨fun _ => c, rfl, fun i lt => absurd lt (Nat.not_lt_zero i)⟩

/-- A chain ending at `d`, with `d` coupled into `c`, makes a longer chain ending at `c`. -/
theorem CoupledInto.succ {j : Nat} {d c : C} (into : CoupledInto cs part k present j d)
    (couples : Couples cs part k present d c) : CoupledInto cs part k present (j + 1) c :=
  match into with
  | ⟨v, ends, chain⟩ =>
    ⟨Loops.extend v j c, Loops.extend_next v j c,
      Coupled.extend chain (fun _ le => Loops.extend_below le) (by
        rw [Loops.extend_next, ends]
        exact couples)⟩

/-- The last `i` couplings of a longer chain end where it ends. -/
theorem CoupledInto.shorten {i j : Nat} {c : C} (into : CoupledInto cs part k present j c)
    (le : i ≤ j) : CoupledInto cs part k present i c :=
  match into, le_dest le with
  | ⟨v, ends, chain⟩, ⟨r, split⟩ =>
    ⟨fun l => v (r + l),
      (congrArg v ((Nat.add_comm r i).trans split.symm)).trans ends,
      fun l lt => chain (r + l)
        (Nat.lt_of_lt_of_le (Nat.add_lt_add_left lt r)
          (Nat.le_of_eq ((Nat.add_comm r i).trans split.symm)))⟩

/-- **A chain as long as the list passes a loop.** With every condition listed, a chain of as many
couplings as there are listed conditions passes a condition twice: that condition lies on a loop,
upstream of where the chain ends. -/
theorem loop_of_coupledInto (every : ∀ c, c ∈ cs) {c : C} :
    CoupledInto cs part k present cs.length c →
      ∃ e, OnLoop cs part k present e ∧ Upstream cs part k present e c
  | ⟨v, ends, chain⟩ =>
    match revisits_within cs v (fun n _ => every (v n)) with
    | ⟨i, _, lt, le, same⟩ =>
      match gap_of_lt lt, le_dest (Nat.le_of_lt (Nat.lt_of_lt_of_le lt le)) with
      | ⟨m, around⟩, ⟨r, rest⟩ =>
        ⟨v i,
          ⟨fun l => v (i + l), m + 1, Nat.succ_pos m, rfl,
            (congrArg v around.symm).trans same.symm,
            fun l lt' => chain (i + l)
              (Nat.lt_of_lt_of_le (Nat.add_lt_add_left lt' i)
                (Nat.le_trans (Nat.le_of_eq around.symm) le))⟩,
          ⟨fun l => v (i + l), r, rfl, (congrArg v rest.symm).trans ends,
            fun l lt' => chain (i + l)
              (Nat.lt_of_lt_of_le (Nat.add_lt_add_left lt' i) (Nat.le_of_eq rest.symm))⟩⟩

/-- **Where no chain of `j + 1` couplings ends at a condition, order `j` is exact there.** Routes
of at most `j` responses carry everything to `c` at every step. -/
theorem carriedWithin_exact_of_not_coupledInto :
    ∀ j c, ¬ CoupledInto cs part k present (j + 1) c →
      ∀ t, carriedWithin cs part σ k present δ j t c = carried cs part σ k present δ t c
  | 0, _, noChain, t =>
    carriedFrom_eq_carried (fun t h mem => carriedGive_congr fun s d le dMem out pos =>
      absurd ((coupledInto_zero d).succ ⟨t, h, s, mem, out, le, dMem, pos⟩) noChain) t
  | j + 1, _, noChain, t =>
    carriedFrom_eq_carried (fun t h mem => carriedGive_congr fun s d le dMem out pos =>
      carriedWithin_exact_of_not_coupledInto j d
        (fun into => noChain (into.succ ⟨t, h, s, mem, out, le, dMem, pos⟩)) s) t

/-- **Where no loop lies upstream, a finite order is exact.** With every condition listed and no
loop upstream of `c`, routes of at most `n` responses carry everything to `c` at every step,
wherever `n + 1` is at least the number of listed conditions. -/
theorem carriedWithin_exact_of_no_loop (every : ∀ c, c ∈ cs) {c : C}
    (noLoop : ∀ e, Upstream cs part k present e c → ¬ OnLoop cs part k present e) {n : Nat}
    (long : cs.length ≤ n + 1) (t : Nat) :
    carriedWithin cs part σ k present δ n t c = carried cs part σ k present δ t c :=
  carriedWithin_exact_of_not_coupledInto n c (fun into =>
    match loop_of_coupledInto every (into.shorten long) with
    | ⟨e, onLoop, up⟩ => noLoop e up onLoop) t

end Chains

/-! ## Couplings that hold at every step: what a loop leaves out of every order -/

section Always

variable {cs : List C} {part : F → Bool} {σ : Nat → F → C → Nat}
  {k : Nat → F → C → Nat → C → Nat} {present : Nat → List F} {δ : C → Nat}

/-- **Coupled at every step.** At every step a formation present, outside the part, exchanges with
`c` with positive strength on the current level of `d`. -/
def CouplesAlways (cs : List C) (part : F → Bool) (k : Nat → F → C → Nat → C → Nat)
    (present : Nat → List F) (d c : C) : Prop :=
  ∀ t, ∃ h, h ∈ present t ∧ part h = false ∧ d ∈ cs ∧ 0 < k t h c t d

/-- A chain whose couplings hold at every step. -/
def CoupledAlways (cs : List C) (part : F → Bool) (k : Nat → F → C → Nat → C → Nat)
    (present : Nat → List F) (v : Nat → C) (j : Nat) : Prop :=
  ∀ i, i < j → CouplesAlways cs part k present (v i) (v (i + 1))

/-- What the orders below `j` carry: nothing below order `0`, order `j` below order `j + 1`. -/
def orderBelow (cs : List C) (part : F → Bool) (σ : Nat → F → C → Nat)
    (k : Nat → F → C → Nat → C → Nat) (present : Nat → List F) (δ : C → Nat) :
    Nat → Nat → C → Nat
  | 0 => fun _ _ => 0
  | j + 1 => carriedWithin cs part σ k present δ j

/-- Each order is carried from the orders below it. -/
theorem carriedWithin_eq_carriedFrom :
    ∀ j t c, carriedWithin cs part σ k present δ j t c =
      carriedFrom cs part σ k present δ (orderBelow cs part σ k present δ j) t c
  | 0, _, _ => rfl
  | _ + 1, _, _ => rfl

theorem orderBelow_le_carried :
    ∀ j s d, orderBelow cs part σ k present δ j s d ≤ carried cs part σ k present δ s d
  | 0, _, _ => Nat.zero_le _
  | j + 1, s, d => carriedWithin_le_carried j s d

theorem orderBelow_mono : ∀ {j j' : Nat}, j ≤ j' → ∀ s d,
    orderBelow cs part σ k present δ j s d ≤ orderBelow cs part σ k present δ j' s d
  | 0, _, _, _, _ => Nat.zero_le _
  | j + 1, 0, le, _, _ => absurd le (Nat.not_succ_le_zero j)
  | _ + 1, _ + 1, le, s, d => carriedWithin_mono (Nat.le_of_succ_le_succ le) s d

/-- **A coupling carries what lower orders miss.** Where `l` is at most the carried amount and
below it at the level of `d` at step `s`, and at `s` the current level of `d` is coupled into `c`,
what is carried from `l` to `c` across the step is below the carried amount. -/
theorem carriedFrom_lt {l : Nat → C → Nat} {s : Nat} {d c : C}
    (le : ∀ s d, d ∈ cs → l s d ≤ carried cs part σ k present δ s d)
    (lt : l s d < carried cs part σ k present δ s d)
    (couples : ∃ h, h ∈ present s ∧ part h = false ∧ d ∈ cs ∧ 0 < k s h c s d) :
    carriedFrom cs part σ k present δ l (s + 1) c < carried cs part σ k present δ (s + 1) c :=
  match couples with
  | ⟨h, mem, out, dMem, pos⟩ =>
    have each : ∀ h', h' ∈ present s → carriedGive cs part σ k s h' c l ≤
        carriedGive cs part σ k s h' c (carried cs part σ k present δ) :=
      fun _ _ => carriedGive_mono fun s' d' _ dMem' => le s' d' dMem'
    have strict : carriedGive cs part σ k s h c l <
        carriedGive cs part σ k s h c (carried cs part σ k present δ) := by
      rw [carriedGive_of_rest out, carriedGive_of_rest out]
      exact Loops.total_lt
        (fun s' _ => total_le _ fun d' dMem' => Nat.mul_le_mul_left _ (le s' d' dMem'))
        (Propagation.mem_steps_upto (Nat.le_refl s))
        (Loops.total_lt (fun d' dMem' => Nat.mul_le_mul_left _ (le s d' dMem')) dMem
          (Naturals.mul_lt_mul_of_pos pos lt))
    calc carriedFrom cs part σ k present δ l (s + 1) c
        = carriedFrom cs part σ k present δ l s c +
            total (present s) (fun h => carriedGive cs part σ k s h c l) :=
          carriedFrom_succ l s c
      _ ≤ carried cs part σ k present δ s c +
            total (present s) (fun h => carriedGive cs part σ k s h c l) :=
          Nat.add_le_add_right (Nat.le_trans (carriedFrom_mono le s c)
            (Nat.le_of_eq (carriedFrom_carried s c))) _
      _ < carried cs part σ k present δ s c +
            total (present s)
              (fun h => carriedGive cs part σ k s h c (carried cs part σ k present δ)) :=
          Nat.add_lt_add_left (Loops.total_lt each mem strict) _
      _ = carried cs part σ k present δ (s + 1) c := (carried_succ s c).symm

/-- **A coupling raises the order missed.** Where the orders below `j` miss something at `d` at step
`s`, and at `s` the current level of `d` is coupled into `c`, the orders below `j + 1` miss
something at `c` at step `s + 1`. -/
theorem orderBelow_lt_succ {j s : Nat} {d c : C}
    (lt : orderBelow cs part σ k present δ j s d < carried cs part σ k present δ s d)
    (couples : ∃ h, h ∈ present s ∧ part h = false ∧ d ∈ cs ∧ 0 < k s h c s d) :
    orderBelow cs part σ k present δ (j + 1) (s + 1) c <
      carried cs part σ k present δ (s + 1) c :=
  Nat.lt_of_le_of_lt (Nat.le_of_eq (carriedWithin_eq_carriedFrom j (s + 1) c))
    (carriedFrom_lt (fun s d _ => orderBelow_le_carried j s d) lt couples)

/-- What the orders below `j` miss stays missed. -/
theorem orderBelow_lt_later : ∀ {j t : Nat} {c : C},
    orderBelow cs part σ k present δ j t c < carried cs part σ k present δ t c →
      orderBelow cs part σ k present δ j (t + 1) c < carried cs part σ k present δ (t + 1) c
  | 0, t, c, lt => Nat.lt_of_lt_of_le lt (carried_le_succ t c)
  | j + 1, t, c, lt =>
    calc carriedWithin cs part σ k present δ j (t + 1) c
        = carriedWithin cs part σ k present δ j t c +
            total (present t) (fun h =>
              carriedGive cs part σ k t h c (orderBelow cs part σ k present δ j)) :=
          (carriedWithin_eq_carriedFrom j (t + 1) c).trans
            (congrArg (· + _) (carriedWithin_eq_carriedFrom j t c).symm)
      _ < carried cs part σ k present δ t c +
            total (present t)
              (fun h => carriedGive cs part σ k t h c (carried cs part σ k present δ)) :=
          Nat.lt_of_lt_of_le (Nat.add_lt_add_right lt _) (Nat.add_le_add_left
            (total_le _ fun _ _ => carriedGive_mono fun s d _ _ => orderBelow_le_carried j s d) _)
      _ = carried cs part σ k present δ (t + 1) c := (carried_succ t c).symm

/-- **Along a chain the order missed rises by one per coupling.** -/
theorem orderBelow_lt_along {v : Nat → C} {j s : Nat}
    (lt : orderBelow cs part σ k present δ j s (v 0) < carried cs part σ k present δ s (v 0)) :
    ∀ {p : Nat}, CoupledAlways cs part k present v p →
      orderBelow cs part σ k present δ (j + p) (s + p) (v p) <
        carried cs part σ k present δ (s + p) (v p)
  | 0, _ => lt
  | p + 1, chain =>
    orderBelow_lt_succ (orderBelow_lt_along lt fun i lt' => chain i (Nat.lt_succ_of_lt lt'))
      (chain p (Nat.lt_succ_self p) (s + p))

/-- **Around a loop the order missed rises by the loop's length every time around.** -/
theorem orderBelow_lt_around {v : Nat → C} {m : Nat} {e : C} (start : v 0 = e) (back : v m = e)
    (loop : CoupledAlways cs part k present v m) {j s : Nat}
    (lt : orderBelow cs part σ k present δ j s e < carried cs part σ k present δ s e) :
    ∀ R, ∃ t, orderBelow cs part σ k present δ (j + m * R) t e <
      carried cs part σ k present δ t e
  | 0 => ⟨s, lt⟩
  | R + 1 =>
    match orderBelow_lt_around start back loop lt R with
    | ⟨t, lt'⟩ =>
      have once := orderBelow_lt_along (v := v) (j := j + m * R) (s := t)
        (Eq.subst (motive := fun x => orderBelow cs part σ k present δ (j + m * R) t x <
          carried cs part σ k present δ t x) start.symm lt') loop
      ⟨t + m, Eq.subst (motive := fun x => orderBelow cs part σ k present δ x (t + m) e <
          carried cs part σ k present δ (t + m) e) (Nat.add_assoc j (m * R) m)
        (Eq.subst (motive := fun x => orderBelow cs part σ k present δ (j + m * R + m) (t + m) x <
          carried cs part σ k present δ (t + m) x) back once)⟩

/-- **A fed loop leaves every order inexact.** Where a loop whose couplings hold at every step
carries something at some step, and a chain whose couplings hold at every step leads from it to
`c`, every order misses something at `c` at some step. -/
theorem carriedWithin_lt_of_loop {e c : C} {s : Nat} (fed : 0 < carried cs part σ k present δ s e)
    {v : Nat → C} {m : Nat} (pos : 0 < m) (start : v 0 = e) (back : v m = e)
    (loop : CoupledAlways cs part k present v m) {u : Nat → C} {q : Nat} (from_ : u 0 = e)
    (to : u q = c) (path : CoupledAlways cs part k present u q) (J : Nat) :
    ∃ t, carriedWithin cs part σ k present δ J t c < carried cs part σ k present δ t c :=
  match orderBelow_lt_around start back loop (j := 0) fed (J + 1) with
  | ⟨t, missed⟩ =>
    have along := orderBelow_lt_along (v := u) (j := 0 + m * (J + 1)) (s := t)
      (Eq.subst (motive := fun x => orderBelow cs part σ k present δ (0 + m * (J + 1)) t x <
        carried cs part σ k present δ t x) from_.symm missed) path
    have arrived := Eq.subst (motive := fun x =>
        orderBelow cs part σ k present δ (0 + m * (J + 1) + q) (t + q) x <
          carried cs part σ k present δ (t + q) x) to along
    have many : J + 1 ≤ 0 + m * (J + 1) + q :=
      Nat.le_trans (Loops.le_mul_of_pos pos (J + 1))
        (Nat.le_trans (Nat.le_of_eq (Nat.zero_add _).symm) (Nat.le_add_right _ q))
    ⟨t + q, Nat.lt_of_le_of_lt (orderBelow_mono many (t + q) c) arrived⟩

/-- **A finite order is exact exactly where no loop lies upstream.** With every condition listed and
every coupling holding at every step, routes of some bounded number of responses carry everything
to `c` at every step, from every starting gap, exactly where no loop lies upstream of `c`; the
number of listed conditions then suffices. -/
theorem finite_order_iff_no_loop (every : ∀ c, c ∈ cs)
    (always : ∀ d c, Couples cs part k present d c → CouplesAlways cs part k present d c)
    (c : C) :
    (∀ δ : C → Nat, ∃ j, ∀ t,
        carriedWithin cs part σ k present δ j t c = carried cs part σ k present δ t c) ↔
      ∀ e, Upstream cs part k present e c → ¬ OnLoop cs part k present e :=
  ⟨fun finite _ up onLoop =>
    match finite (fun _ => 1), up, onLoop with
    | ⟨j, exact⟩, ⟨_, _, from_, to, path⟩, ⟨_, _, pos, start, back, loop⟩ =>
      match carriedWithin_lt_of_loop (δ := fun _ => 1) (s := 0) (Nat.succ_pos 0) pos start back
          (fun i lt => always _ _ (loop i lt)) from_ to (fun i lt => always _ _ (path i lt)) j with
      | ⟨t, lt⟩ => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le lt (Nat.le_of_eq (exact t).symm)),
   fun noLoop _ => ⟨cs.length, carriedWithin_exact_of_no_loop every noLoop (Nat.le_succ _)⟩⟩

end Always

/-! ## The strength around a loop -/

section Around

variable {cs : List C} {part : F → Bool} {σ : Nat → F → C → Nat}
  {k : Nat → F → C → Nat → C → Nat} {present : Nat → List F} {δ : C → Nat}

/-- **Coupled with strengths.** At every step the current level of each `v i`, for `i < j`, is
coupled into `v (i + 1)` with strength at least `w i`. -/
def CoupledWith (cs : List C) (part : F → Bool) (k : Nat → F → C → Nat → C → Nat)
    (present : Nat → List F) (v : Nat → C) (w : Nat → Nat) (j : Nat) : Prop :=
  ∀ i, i < j → ∀ t, ∃ h, h ∈ present t ∧ part h = false ∧ v i ∈ cs ∧
    w i ≤ k t h (v (i + 1)) t (v i)

/-- The product of the first `j` strengths. -/
def Loops.product (w : Nat → Nat) : Nat → Nat
  | 0 => 1
  | j + 1 => Loops.product w j * w j

/-- The carried amount never falls over a stretch. -/
theorem carried_le_add (t : Nat) (c : C) :
    ∀ r, carried cs part σ k present δ t c ≤ carried cs part σ k present δ (t + r) c
  | 0 => Nat.le_refl _
  | r + 1 => Nat.le_trans (carried_le_add t c r) (carried_le_succ (t + r) c)

/-- The carried amount never falls from an earlier step to a later one. -/
theorem carried_mono_steps {s t : Nat} (le : s ≤ t) (c : C) :
    carried cs part σ k present δ s c ≤ carried cs part σ k present δ t c :=
  match le_dest le with
  | ⟨r, split⟩ => Nat.le_trans (carried_le_add s c r)
      (Nat.le_of_eq (congrArg (fun x => carried cs part σ k present δ x c) split.symm))

/-- **One coupling across one step.** Where at step `t` the current level of `d` is coupled into
`c` with strength at least `w`, the carried amount at `c` grows across the step by at least `w`
times the carried amount at `d`. -/
theorem carried_step_ge {t : Nat} {d c : C} {w : Nat}
    (couples : ∃ h, h ∈ present t ∧ part h = false ∧ d ∈ cs ∧ w ≤ k t h c t d) :
    carried cs part σ k present δ t c + w * carried cs part σ k present δ t d ≤
      carried cs part σ k present δ (t + 1) c :=
  match couples with
  | ⟨h, mem, out, dMem, strong⟩ =>
    Nat.le_trans (Nat.add_le_add_left (
      calc w * carried cs part σ k present δ t d
          ≤ k t h c t d * carried cs part σ k present δ t d := Nat.mul_le_mul_right _ strong
        _ ≤ total cs (fun d' => k t h c t d' * carried cs part σ k present δ t d') :=
          le_total_of_mem (q := fun d' => k t h c t d' * carried cs part σ k present δ t d') dMem
        _ ≤ total (steps 0 (t + 1))
              (fun s => total cs fun d' => k t h c s d' * carried cs part σ k present δ s d') :=
          le_total_of_mem (q := fun s => total cs fun d' =>
              k t h c s d' * carried cs part σ k present δ s d')
            (Propagation.mem_steps_upto (Nat.le_refl t))
        _ = carriedGive cs part σ k t h c (carried cs part σ k present δ) :=
          (carriedGive_of_rest out).symm
        _ ≤ total (present t)
              (fun h => carriedGive cs part σ k t h c (carried cs part σ k present δ)) :=
          le_total_of_mem (q := fun h => carriedGive cs part σ k t h c
            (carried cs part σ k present δ)) mem) _)
      (Nat.le_of_eq (carried_succ t c).symm)

/-- **Along a chain of strengths.** The carried amount at the chain's start, times the product of
its strengths, arrives at its end within as many steps as it has couplings. -/
theorem carried_along {v : Nat → C} {w : Nat → Nat} :
    ∀ {p : Nat}, CoupledWith cs part k present v w p → ∀ t,
      Loops.product w p * carried cs part σ k present δ t (v 0) ≤
        carried cs part σ k present δ (t + p) (v p)
  | 0, _, _ => Nat.le_of_eq (Nat.one_mul _)
  | p + 1, chain, t =>
    calc Loops.product w (p + 1) * carried cs part σ k present δ t (v 0)
        = w p * (Loops.product w p * carried cs part σ k present δ t (v 0)) :=
          Loops.mul_swap _ _ _
      _ ≤ w p * carried cs part σ k present δ (t + p) (v p) :=
          Nat.mul_le_mul_left _
            (carried_along (fun i lt => chain i (Nat.lt_succ_of_lt lt)) t)
      _ ≤ carried cs part σ k present δ (t + p) (v (p + 1)) +
            w p * carried cs part σ k present δ (t + p) (v p) := Nat.le_add_left _ _
      _ ≤ carried cs part σ k present δ (t + p + 1) (v (p + 1)) :=
          carried_step_ge (chain p (Nat.lt_succ_self p) (t + p))

/-- **The strength around a loop.** Where at every step each condition of a loop of `m + 1`
couplings is coupled into the next with strength at least `w`, what has reached the loop is
carried back to it multiplied, every time around, by at least one plus the product of its
strengths. -/
theorem carried_around {v : Nat → C} {w : Nat → Nat} {m : Nat} {e : C} (start : v 0 = e)
    (back : v (m + 1) = e) (loop : CoupledWith cs part k present v w (m + 1)) (t : Nat) :
    (1 + Loops.product w (m + 1)) * carried cs part σ k present δ t e ≤
      carried cs part σ k present δ (t + (m + 1)) e :=
  have chain := carried_along (σ := σ) (δ := δ)
    (fun i lt => loop i (Nat.lt_succ_of_lt lt)) t
  have last := carried_step_ge (σ := σ) (δ := δ) (loop m (Nat.lt_succ_self m) (t + m))
  calc (1 + Loops.product w (m + 1)) * carried cs part σ k present δ t e
      = carried cs part σ k present δ t e +
          w m * (Loops.product w m * carried cs part σ k present δ t e) :=
        (Loops.one_add_mul _ _).trans (congrArg (_ + ·) (Loops.mul_swap _ _ _))
    _ ≤ carried cs part σ k present δ (t + m) (v (m + 1)) +
          w m * carried cs part σ k present δ (t + m) (v m) :=
        Nat.add_le_add
          (Nat.le_trans (carried_le_add t e m) (Nat.le_of_eq (congrArg _ back.symm)))
          (Nat.mul_le_mul_left _ (Nat.le_trans (Nat.le_of_eq (congrArg (fun x =>
            Loops.product w m * carried cs part σ k present δ t x) start.symm)) chain))
    _ ≤ carried cs part σ k present δ (t + m + 1) (v (m + 1)) := last
    _ = carried cs part σ k present δ (t + (m + 1)) e := congrArg _ back

/-- **Runaway around a loop.** Every time around, at least the factor one plus the product of the
loop's strengths: after `R` times around, the carried amount at the loop is at least that factor to
the power `R` times what had reached it. -/
theorem carried_runaway {v : Nat → C} {w : Nat → Nat} {m : Nat} {e : C} (start : v 0 = e)
    (back : v (m + 1) = e) (loop : CoupledWith cs part k present v w (m + 1)) (t : Nat) :
    ∀ R, (1 + Loops.product w (m + 1)) ^ R * carried cs part σ k present δ t e ≤
      carried cs part σ k present δ (t + (m + 1) * R) e
  | 0 => Nat.le_of_eq (Nat.one_mul _)
  | R + 1 =>
    calc (1 + Loops.product w (m + 1)) ^ (R + 1) * carried cs part σ k present δ t e
        = (1 + Loops.product w (m + 1)) *
            ((1 + Loops.product w (m + 1)) ^ R * carried cs part σ k present δ t e) :=
          Loops.mul_swap _ _ _
      _ ≤ (1 + Loops.product w (m + 1)) *
            carried cs part σ k present δ (t + (m + 1) * R) e :=
          Nat.mul_le_mul_left _ (carried_runaway start back loop t R)
      _ ≤ carried cs part σ k present δ (t + (m + 1) * R + (m + 1)) e :=
          carried_around start back loop _
      _ = carried cs part σ k present δ (t + (m + 1) * (R + 1)) e :=
          congrArg (fun x => carried cs part σ k present δ x e) (Nat.add_assoc _ _ _)

end Around

/-! ## How much the orders carry: bounds with no loop, and the accuracy of a cut -/

namespace Loops

/-- What routes of at most `j` responses can carry, at most, over `t` steps, with starting gaps at
most `D` and the strengths into each condition summing to at most `M` at each step. -/
def withinBound (M D : Nat) : Nat → Nat → Nat
  | 0, _ => D
  | _ + 1, 0 => D
  | j + 1, t + 1 => withinBound M D (j + 1) t + M * withinBound M D j t

/-- The most the strengths can carry over `t` steps: `D`, multiplied by `1 + M` at each step. -/
def geomBound (M D : Nat) : Nat → Nat
  | 0 => D
  | t + 1 => geomBound M D t + M * geomBound M D t

/-- The most a cut at order `j` can miss over `t` steps. -/
def missBound (M D : Nat) (j t : Nat) : Nat :=
  match t, j with
  | 0, _ => 0
  | t + 1, 0 => missBound M D 0 t + M * geomBound M D t
  | t + 1, j + 1 => missBound M D (j + 1) t + M * missBound M D j t

theorem withinBound_zero (M D : Nat) : ∀ t, withinBound M D 0 t = D
  | 0 => rfl
  | _ + 1 => rfl

theorem withinBound_le_succ (M D : Nat) : ∀ j t, withinBound M D j t ≤ withinBound M D j (t + 1)
  | 0, t => Nat.le_of_eq ((withinBound_zero M D t).trans (withinBound_zero M D (t + 1)).symm)
  | _ + 1, _ => Nat.le_add_right _ _

theorem withinBound_mono (M D j : Nat) {s t : Nat} (le : s ≤ t) :
    withinBound M D j s ≤ withinBound M D j t := by
  induction le with
  | refl => exact Nat.le_refl _
  | step _ ih => exact Nat.le_trans ih (withinBound_le_succ M D j _)

theorem geomBound_mono (M D : Nat) {s t : Nat} (le : s ≤ t) :
    geomBound M D s ≤ geomBound M D t := by
  induction le with
  | refl => exact Nat.le_refl _
  | step _ ih => exact Nat.le_trans ih (Nat.le_add_right _ _)

theorem missBound_le_succ (M D : Nat) : ∀ j t, missBound M D j t ≤ missBound M D j (t + 1)
  | 0, _ => Nat.le_add_right _ _
  | _ + 1, _ => Nat.le_add_right _ _

theorem missBound_mono (M D j : Nat) {s t : Nat} (le : s ≤ t) :
    missBound M D j s ≤ missBound M D j t := by
  induction le with
  | refl => exact Nat.le_refl _
  | step _ ih => exact Nat.le_trans ih (missBound_le_succ M D j _)

/-- **What a cut misses and what it keeps make up the whole.** -/
theorem missBound_add_withinBound (M D : Nat) :
    ∀ j t, missBound M D j t + withinBound M D j t = geomBound M D t
  | 0, 0 => Nat.zero_add D
  | _ + 1, 0 => Nat.zero_add D
  | 0, t + 1 =>
    (congrArg (_ + ·) (withinBound_zero M D (t + 1))).trans ((Nat.add_right_comm _ _ _).trans
      (congrArg (· + M * geomBound M D t)
        ((congrArg (_ + ·) (withinBound_zero M D t).symm).trans
          (missBound_add_withinBound M D 0 t))))
  | j + 1, t + 1 =>
    (Nat.add_add_add_comm _ _ _ _).trans (Naturals.add_congr
      (missBound_add_withinBound M D (j + 1) t)
      ((Nat.mul_add M _ _).symm.trans (congrArg (M * ·) (missBound_add_withinBound M D j t))))

/-- The most the strengths can carry is `D` times `(1 + M)` to the power of the steps. -/
theorem geomBound_eq (M D : Nat) : ∀ t, geomBound M D t = D * (1 + M) ^ t
  | 0 => (Nat.mul_one D).symm
  | t + 1 =>
    (one_add_mul M (geomBound M D t)).symm.trans
      ((congrArg ((1 + M) * ·) (geomBound_eq M D t)).trans
        ((Nat.mul_comm _ _).trans (mul_assoc_nat D _ _)))

/-- **The binomial counts.** `binom n i` counts the ways to place `i` responses among `n` steps. -/
def binom (n i : Nat) : Nat :=
  match i, n with
  | 0, _ => 1
  | _ + 1, 0 => 0
  | i + 1, n + 1 => binom n i + binom n (i + 1)

/-- The sum over orders up to `j` of the ways to place them among `t` steps, times `M` to each
order. -/
def orderSum (M j t : Nat) : Nat := total (steps 0 (j + 1)) fun i => binom t i * M ^ i

theorem binom_zero : ∀ n, binom n 0 = 1
  | 0 => rfl
  | _ + 1 => rfl

theorem orderSum_zero (M t : Nat) : orderSum M 0 t = 1 :=
  congrArg (· * M ^ 0 + 0) (binom_zero t)

/-- One more power of `M`, taken out. -/
theorem pow_step (b M i : Nat) : b * M ^ (i + 1) = M * (b * M ^ i) :=
  (mul_assoc_nat b (M ^ i) M).symm.trans (Nat.mul_comm _ _)

/-- The order sum split at its first term. -/
theorem orderSum_succ (M j t : Nat) :
    orderSum M (j + 1) t = 1 + total (steps 0 (j + 1)) fun i => binom t (i + 1) * M ^ (i + 1) :=
  (congrArg (binom t 0 * M ^ 0 + ·) (total_steps_succ _ 0 (j + 1))).trans
    (congrArg (· * M ^ 0 + _) (binom_zero t))

theorem orderSum_start (M : Nat) : ∀ j, orderSum M j 0 = 1
  | 0 => rfl
  | j + 1 => (orderSum_succ M j 0).trans (congrArg (1 + ·)
      ((total_congr (fun i => Nat.zero_mul (M ^ (i + 1))) _).trans (total_zero _)))

/-- **Pascal's rule for the orders.** One step more adds `M` times the orders below. -/
theorem orderSum_step (M j t : Nat) :
    orderSum M (j + 1) (t + 1) = orderSum M (j + 1) t + M * orderSum M j t :=
  (orderSum_succ M j (t + 1)).trans
    ((congrArg (1 + ·)
      ((total_congr (fun i => (add_mul_split (binom t i) (binom t (i + 1)) (M ^ (i + 1))).trans
          (Nat.add_comm _ _)) _).trans
        ((total_add _ _ _).trans (congrArg (_ + ·)
          ((total_congr (fun i => pow_step (binom t i) M i) _).trans
            (total_mul M _ _)))))).trans
      ((Nat.add_assoc _ _ _).symm.trans (congrArg (· + _) (orderSum_succ M j t).symm)))

/-- **The bound is a polynomial.** What `j` orders can carry over `t` steps is at most `D` times the
sum over orders `i ≤ j` of the ways to place them among the steps times `M ^ i`: a polynomial in `t`
of degree `j`. -/
theorem withinBound_eq (M D : Nat) : ∀ j t, withinBound M D j t = D * orderSum M j t
  | 0, t => (withinBound_zero M D t).trans
      ((Nat.mul_one D).symm.trans (congrArg (D * ·) (orderSum_zero M t).symm))
  | j + 1, 0 => (Nat.mul_one D).symm.trans (congrArg (D * ·) (orderSum_start M (j + 1)).symm)
  | j + 1, t + 1 =>
    (Naturals.add_congr (withinBound_eq M D (j + 1) t)
        (congrArg (M * ·) (withinBound_eq M D j t))).trans
      ((congrArg (_ + ·) ((mul_assoc_nat M D _).symm.trans
          ((congrArg (· * _) (Nat.mul_comm M D)).trans (mul_assoc_nat D M _)))).trans
        ((Nat.mul_add D _ _).symm.trans (congrArg (D * ·) (orderSum_step M j t).symm)))

end Loops

section Bounds

variable {cs : List C} {part : F → Bool}
  {k : Nat → F → C → Nat → C → Nat} {present : Nat → List F} {δ : C → Nat}

/-- **The strength into a condition.** Across the step from `t`, the total strength with which the
formations present outside the part exchange with `c`, over every level up to the step and every
listed condition. -/
def inflow (cs : List C) (part : F → Bool) (k : Nat → F → C → Nat → C → Nat)
    (present : Nat → List F) (t : Nat) (c : C) : Nat :=
  total (present t) fun h => bif part h then 0 else
    total (steps 0 (t + 1)) fun s => total cs fun d => k t h c s d

/-- With the part giving no gap, what the formations present give from levels within `X` of other
levels is within the strength into the condition times `X` of what they give from those. -/
theorem total_give_le_add {t : Nat} {c : C} {l l' : Nat → C → Nat} {X : Nat}
    (bound : ∀ s d, s ≤ t → d ∈ cs → l s d ≤ l' s d + X) :
    (total (present t) fun h => carriedGive cs part (fun _ _ _ => 0) k t h c l) ≤
      (total (present t) fun h => carriedGive cs part (fun _ _ _ => 0) k t h c l') +
        inflow cs part k present t c * X :=
  Nat.le_trans
    (total_le _ fun h _ =>
      show carriedGive cs part (fun _ _ _ => 0) k t h c l ≤
          carriedGive cs part (fun _ _ _ => 0) k t h c l' +
            (bif part h then 0 else
              total (steps 0 (t + 1)) fun s => total cs fun d => k t h c s d) * X from
      match hp : part h with
      | true => Nat.le_trans (Nat.le_of_eq (carriedGive_of_part hp)) (Nat.zero_le _)
      | false =>
        calc carriedGive cs part (fun _ _ _ => 0) k t h c l
            = total (steps 0 (t + 1)) (fun s => total cs fun d => k t h c s d * l s d) :=
              carriedGive_of_rest hp
          _ ≤ total (steps 0 (t + 1))
                (fun s => total cs fun d => k t h c s d * l' s d + k t h c s d * X) :=
              total_le _ fun s mem => total_le _ fun d dMem =>
                Nat.le_trans (Nat.mul_le_mul_left _
                    (bound s d (Propagation.le_of_mem_steps_upto mem) dMem))
                  (Nat.le_of_eq (Nat.mul_add _ _ _))
          _ = total (steps 0 (t + 1)) (fun s => total cs fun d => k t h c s d * l' s d) +
                (total (steps 0 (t + 1)) fun s => total cs fun d => k t h c s d) * X :=
              ((total_congr (fun _ => total_add _ _ cs) _).trans (total_add _ _ _)).trans
                (congrArg (_ + ·) ((total_congr
                  (fun s => Loops.total_mul_const (fun d => k t h c s d) X cs) _).trans
                  (Loops.total_mul_const _ X _)))
          _ = carriedGive cs part (fun _ _ _ => 0) k t h c l' +
                (total (steps 0 (t + 1)) fun s => total cs fun d => k t h c s d) * X :=
              congrArg (· + _) (carriedGive_of_rest hp).symm)
    (Nat.le_of_eq ((total_add _ _ _).trans (congrArg (_ + ·) (Loops.total_mul_const _ X _))))

/-- With the part giving no gap, what the formations present give from levels at most `X` is at
most the strength into the condition times `X`. -/
theorem total_give_le_inflow {t : Nat} {c : C} {l : Nat → C → Nat} {X : Nat}
    (bound : ∀ s d, s ≤ t → d ∈ cs → l s d ≤ X) :
    (total (present t) fun h => carriedGive cs part (fun _ _ _ => 0) k t h c l) ≤
      inflow cs part k present t c * X :=
  Nat.le_trans
    (total_give_le_add (l' := fun _ _ => 0) fun s d le dMem =>
      Nat.le_trans (bound s d le dMem) (Nat.le_of_eq (Nat.zero_add X).symm))
    (Nat.le_of_eq ((congrArg (· + _) (total_eq_zero fun h _ =>
      match hp : part h with
      | true => carriedGive_of_part hp
      | false => (carriedGive_of_rest hp).trans (total_eq_zero fun _ _ =>
          total_eq_zero fun _ _ => Nat.mul_zero _))).trans (Nat.zero_add _)))

/-- With the part giving no gap, the routes of no response carry only the starting gaps. -/
theorem carriedWithin_zero_quiet :
    ∀ t c, carriedWithin cs part (fun _ _ _ => 0) k present δ 0 t c = δ c
  | 0, _ => rfl
  | t + 1, c =>
    (congrArg (· + _) (carriedWithin_zero_quiet t c)).trans
      ((congrArg (δ c + ·) (total_eq_zero fun h _ =>
        match hp : part h with
        | true => carriedGive_of_part hp
        | false => (carriedGive_of_rest hp).trans (total_eq_zero fun _ _ =>
            total_eq_zero fun _ _ => Nat.mul_zero _))).trans (Nat.add_zero _))

/-- **What the orders carry is a polynomial at most.** With the part giving no gap, starting gaps at
most `D` and the strengths into each condition summing to at most `M` at each step, what routes of
at most `j` responses carry over `t` steps is at most `D` times the sum over orders `i ≤ j` of the
ways to place them among the steps times `M ^ i` (`Loops.withinBound_eq`). -/
theorem carriedWithin_le_withinBound {M D : Nat} (start : ∀ c, δ c ≤ D)
    (into : ∀ t c, inflow cs part k present t c ≤ M) :
    ∀ j t c, carriedWithin cs part (fun _ _ _ => 0) k present δ j t c ≤
      Loops.withinBound M D j t := by
  intro j
  induction j with
  | zero =>
    intro t c
    exact Nat.le_trans (Nat.le_of_eq (carriedWithin_zero_quiet t c))
      (Nat.le_trans (start c) (Nat.le_of_eq (Loops.withinBound_zero M D t).symm))
  | succ j ih =>
    intro t
    induction t with
    | zero => intro c; exact start c
    | succ t iht =>
      intro c
      exact Nat.add_le_add (iht c)
        (Nat.le_trans (total_give_le_inflow fun s d le _ =>
            Nat.le_trans (ih s d) (Loops.withinBound_mono M D j le))
          (Nat.mul_le_mul_right _ (into t c)))

/-- **At most geometric.** With the part giving no gap, starting gaps at most `D` and the strengths
into each condition summing to at most `M` at each step, the carried amount over `t` steps is at
most `D * (1 + M) ^ t` (`Loops.geomBound_eq`). -/
theorem carried_le_geomBound {M D : Nat} (start : ∀ c, δ c ≤ D)
    (into : ∀ t c, inflow cs part k present t c ≤ M) :
    ∀ t c, carried cs part (fun _ _ _ => 0) k present δ t c ≤ Loops.geomBound M D t := by
  intro t
  induction t with
  | zero => intro c; exact start c
  | succ t ih =>
    intro c
    exact Nat.le_trans (Nat.le_of_eq (carried_succ t c)) (Nat.add_le_add (ih c)
      (Nat.le_trans (total_give_le_inflow fun s d le _ =>
          Nat.le_trans (carried_mono_steps le d) (ih d))
        (Nat.mul_le_mul_right _ (into t c))))

/-- **The accuracy of a cut.** With the part giving no gap, starting gaps at most `D` and the
strengths into each condition summing to at most `M` at each step, cutting the expansion at order
`j` misses at most `Loops.missBound M D j t`: `D * (1 + M) ^ t` less what `j` orders can carry at
most (`Loops.missBound_add_withinBound`, `Loops.geomBound_eq`). -/
theorem carried_le_carriedWithin_add {M D : Nat} (start : ∀ c, δ c ≤ D)
    (into : ∀ t c, inflow cs part k present t c ≤ M) :
    ∀ j t c, carried cs part (fun _ _ _ => 0) k present δ t c ≤
      carriedWithin cs part (fun _ _ _ => 0) k present δ j t c + Loops.missBound M D j t := by
  intro j
  induction j with
  | zero =>
    intro t
    induction t with
    | zero => intro c; exact Nat.le_add_right _ _
    | succ t iht =>
      intro c
      calc carried cs part (fun _ _ _ => 0) k present δ (t + 1) c
          = carried cs part (fun _ _ _ => 0) k present δ t c +
              total (present t) (fun h => carriedGive cs part (fun _ _ _ => 0) k t h c
                (carried cs part (fun _ _ _ => 0) k present δ)) := carried_succ t c
        _ ≤ (carriedWithin cs part (fun _ _ _ => 0) k present δ 0 t c +
              Loops.missBound M D 0 t) + M * Loops.geomBound M D t :=
            Nat.add_le_add (iht c) (Nat.le_trans (total_give_le_inflow fun s d le _ =>
                Nat.le_trans (carried_mono_steps le d) (carried_le_geomBound start into t d))
              (Nat.mul_le_mul_right _ (into t c)))
        _ = carriedWithin cs part (fun _ _ _ => 0) k present δ 0 (t + 1) c +
              Loops.missBound M D 0 (t + 1) :=
            (Nat.add_assoc _ _ _).trans (congrArg (· + _)
              ((carriedWithin_zero_quiet t c).trans (carriedWithin_zero_quiet (t + 1) c).symm))
  | succ j ih =>
    intro t
    induction t with
    | zero => intro c; exact Nat.le_add_right _ _
    | succ t iht =>
      intro c
      calc carried cs part (fun _ _ _ => 0) k present δ (t + 1) c
          = carried cs part (fun _ _ _ => 0) k present δ t c +
              total (present t) (fun h => carriedGive cs part (fun _ _ _ => 0) k t h c
                (carried cs part (fun _ _ _ => 0) k present δ)) := carried_succ t c
        _ ≤ (carriedWithin cs part (fun _ _ _ => 0) k present δ (j + 1) t c +
              Loops.missBound M D (j + 1) t) +
            ((total (present t) fun h => carriedGive cs part (fun _ _ _ => 0) k t h c
                (carriedWithin cs part (fun _ _ _ => 0) k present δ j)) +
              inflow cs part k present t c * Loops.missBound M D j t) :=
            Nat.add_le_add (iht c) (total_give_le_add fun s d le _ =>
              Nat.le_trans (ih s d) (Nat.add_le_add_left (Loops.missBound_mono M D j le) _))
        _ ≤ (carriedWithin cs part (fun _ _ _ => 0) k present δ (j + 1) t c +
              Loops.missBound M D (j + 1) t) +
            ((total (present t) fun h => carriedGive cs part (fun _ _ _ => 0) k t h c
                (carriedWithin cs part (fun _ _ _ => 0) k present δ j)) +
              M * Loops.missBound M D j t) :=
            Nat.add_le_add_left (Nat.add_le_add_left (Nat.mul_le_mul_right _ (into t c)) _) _
        _ = (carriedWithin cs part (fun _ _ _ => 0) k present δ (j + 1) t c +
              total (present t) fun h => carriedGive cs part (fun _ _ _ => 0) k t h c
                (carriedWithin cs part (fun _ _ _ => 0) k present δ j)) +
            (Loops.missBound M D (j + 1) t + M * Loops.missBound M D j t) :=
            Nat.add_add_add_comm _ _ _ _

/-- **Where no loop lies upstream, the carried amount is at most a polynomial.** With every
condition listed, no loop upstream of `c`, the part giving no gap, starting gaps at most `D` and the
strengths into each condition summing to at most `M` at each step, the carried amount at `c` over
`t` steps is at most `D` times the sum, over orders `i ≤ n`, of the ways to place `i` responses
among the steps times `M ^ i`, wherever `n + 1` is at least the number of listed conditions: a
polynomial in `t` of degree `n`. -/
theorem carried_le_polynomial (every : ∀ c, c ∈ cs) {c : C}
    (noLoop : ∀ e, Upstream cs part k present e c → ¬ OnLoop cs part k present e) {n : Nat}
    (long : cs.length ≤ n + 1) {M D : Nat} (start : ∀ c, δ c ≤ D)
    (into : ∀ t c, inflow cs part k present t c ≤ M) (t : Nat) :
    carried cs part (fun _ _ _ => 0) k present δ t c ≤ D * Loops.orderSum M n t :=
  Nat.le_trans (Nat.le_of_eq (carriedWithin_exact_of_no_loop every noLoop long t).symm)
    (Nat.le_trans (carriedWithin_le_withinBound start into n t c)
      (Nat.le_of_eq (Loops.withinBound_eq M D n t)))

end Bounds

/-! ## A self-loop: the bounds are attained -/

namespace Loops.SelfLoop

/-- One formation, outside the part, giving the one condition `M` times its current level. -/
def strengths (M : Nat) : Nat → Unit → Unit → Nat → Unit → Nat :=
  fun t _ _ s _ => bif Nat.beq s t then M else 0

/-- What the self-loop gives across the step from `t`, read from levels `l`. -/
theorem give (M t : Nat) (l : Nat → Unit → Nat) :
    (total [()] fun h =>
        carriedGive [()] (fun _ => false) (fun _ _ _ => 0) (strengths M) t h () l) = M * l t () :=
  show total (steps 0 (t + 1)) (fun s => (bif Nat.beq s t then M else 0) * l s () + 0) + 0 =
      M * l t () from
  (Nat.add_zero _).trans ((Propagation.total_steps_at (fun s ne =>
      match hb : Nat.beq s t with
      | true => absurd (Nat.eq_of_beq_eq_true hb) ne
      | false => (congrArg (fun b => (bif b then M else 0) * l s () + 0) hb).trans
          ((Nat.add_zero _).trans (Nat.zero_mul _)))).trans
    ((Nat.add_zero _).trans (congrArg (fun b => (bif b then M else 0) * l t ()) (beq_self t))))

/-- The strengths into the one condition sum to `M` at every step. -/
theorem inflow_eq (M t : Nat) :
    inflow [()] (fun _ => false) (strengths M) (fun _ => [()]) t () = M :=
  show total (steps 0 (t + 1)) (fun s => (bif Nat.beq s t then M else 0) + 0) + 0 = M from
  (Nat.add_zero _).trans ((Propagation.total_steps_at (fun s ne =>
      match hb : Nat.beq s t with
      | true => absurd (Nat.eq_of_beq_eq_true hb) ne
      | false => (congrArg (fun b => (bif b then M else 0) + 0) hb))).trans
    ((Nat.add_zero _).trans (congrArg (fun b => bif b then M else 0) (beq_self t))))

/-- The self-loop carries `D` multiplied by `1 + M` at each step. -/
theorem carried_eq (M D : Nat) : ∀ t,
    carried [()] (fun _ => false) (fun _ _ _ => 0) (strengths M) (fun _ => [()]) (fun _ => D) t () =
      geomBound M D t
  | 0 => rfl
  | t + 1 => (carried_succ t ()).trans (Naturals.add_congr (carried_eq M D t)
      ((give M t _).trans (congrArg (M * ·) (carried_eq M D t))))

/-- Its orders carry exactly the bound of what `j` orders can carry. -/
theorem carriedWithin_eq (M D : Nat) : ∀ j t,
    carriedWithin [()] (fun _ => false) (fun _ _ _ => 0) (strengths M) (fun _ => [()])
      (fun _ => D) j t () = withinBound M D j t
  | 0, t => (carriedWithin_zero_quiet t ()).trans (withinBound_zero M D t).symm
  | _ + 1, 0 => rfl
  | j + 1, t + 1 => Naturals.add_congr (carriedWithin_eq M D (j + 1) t)
      ((give M t _).trans (congrArg (M * ·) (carriedWithin_eq M D j t)))

/-- **The accuracy of a cut is attained.** For the self-loop, with starting gap `D` and strength
`M`, a cut at order `j` misses exactly `Loops.missBound M D j t`. -/
theorem attained (M D j t : Nat) :
    carried [()] (fun _ => false) (fun _ _ _ => 0) (strengths M) (fun _ => [()]) (fun _ => D) t () =
      carriedWithin [()] (fun _ => false) (fun _ _ _ => 0) (strengths M) (fun _ => [()])
        (fun _ => D) j t () + missBound M D j t :=
  (carried_eq M D t).trans ((missBound_add_withinBound M D j t).symm.trans
    ((Nat.add_comm _ _).trans (congrArg (· + _) (carriedWithin_eq M D j t).symm)))

end Loops.SelfLoop

/-! ## A loop coupled once: the couplings must hold at every step -/

namespace Loops.Once

/-- One formation, outside the part, giving the one condition its level, at the first step only. -/
def strengths : Nat → Unit → Unit → Nat → Unit → Nat :=
  fun t _ _ s _ => bif Nat.beq t 0 && Nat.beq s 0 then 1 else 0

/-- At the first step it gives the level there. -/
theorem give_zero (l : Nat → Unit → Nat) :
    (total [()] fun h =>
        carriedGive [()] (fun _ => false) (fun _ _ _ => 0) strengths 0 h () l) = l 0 () :=
  show ((1 * l 0 () + 0) + 0) + 0 = l 0 () from
  (Nat.add_zero _).trans ((Nat.add_zero _).trans ((Nat.add_zero _).trans (Nat.one_mul _)))

/-- After the first step it gives nothing. -/
theorem give_succ (t : Nat) (l : Nat → Unit → Nat) :
    (total [()] fun h =>
        carriedGive [()] (fun _ => false) (fun _ _ _ => 0) strengths (t + 1) h () l) = 0 :=
  show total (steps 0 (t + 2)) (fun s => (0 * l s () + 0) + 0) + 0 = 0 from
  (Nat.add_zero _).trans (total_eq_zero fun s _ =>
    (Nat.add_zero _).trans ((Nat.add_zero _).trans (Nat.zero_mul (l s ()))))

/-- The condition lies on a loop. -/
theorem onLoop : OnLoop [()] (fun _ => false) strengths (fun _ => [()]) () :=
  ⟨fun _ => (), 1, Nat.succ_pos 0, rfl, rfl,
    fun _ _ => ⟨0, (), 0, .head _, rfl, Nat.le_refl 0, .head _, Nat.succ_pos 0⟩⟩

/-- Order one is exact at every step, from every starting gap. -/
theorem exact (δ : Unit → Nat) : ∀ t,
    carriedWithin [()] (fun _ => false) (fun _ _ _ => 0) strengths (fun _ => [()]) δ 1 t () =
      carried [()] (fun _ => false) (fun _ _ _ => 0) strengths (fun _ => [()]) δ t ()
  | 0 => rfl
  | 1 =>
    have within := give_zero
      (carriedWithin [()] (fun _ => false) (fun _ _ _ => 0) strengths (fun _ => [()]) δ 0)
    have whole := give_zero
      (carried [()] (fun _ => false) (fun _ _ _ => 0) strengths (fun _ => [()]) δ)
    (Naturals.add_congr rfl (within.trans whole.symm)).trans
      (carried_succ (cs := [()]) (part := fun _ => false) (σ := fun _ _ _ => 0) (k := strengths)
        (present := fun _ => [()]) (δ := δ) 0 ()).symm
  | t + 2 =>
    have within := give_succ t
      (carriedWithin [()] (fun _ => false) (fun _ _ _ => 0) strengths (fun _ => [()]) δ 0)
    have whole := give_succ t
      (carried [()] (fun _ => false) (fun _ _ _ => 0) strengths (fun _ => [()]) δ)
    (Naturals.add_congr (exact δ (t + 1)) (within.trans whole.symm)).trans
      (carried_succ (cs := [()]) (part := fun _ => false) (σ := fun _ _ _ => 0) (k := strengths)
        (present := fun _ => [()]) (δ := δ) (t + 1) ()).symm

/-- **A loop upstream need not leave every order inexact.** The condition lies on a loop, upstream
of itself, yet a finite order is exact there from every starting gap: the loop is coupled at the
first step only. So `finite_order_iff_no_loop` needs its couplings at every step. -/
theorem not_always :
    OnLoop [()] (fun _ => false) strengths (fun _ => [()]) () ∧
      ∀ δ : Unit → Nat, ∃ j, ∀ t,
        carriedWithin [()] (fun _ => false) (fun _ _ _ => 0) strengths (fun _ => [()]) δ j t () =
          carried [()] (fun _ => false) (fun _ _ _ => 0) strengths (fun _ => [()]) δ t () :=
  ⟨onLoop, fun δ => ⟨1, exact δ⟩⟩

end Loops.Once

/-! ## Stationary strengths -/

section Stationary

variable {cs : List C} {part : F → Bool} {σ : Nat → F → C → Nat} {δ : C → Nat}

/-- **Stationary strengths.** Each formation gives each condition `K h c d` times the current level
of `d`, the same at every step. -/
def stationary (K : F → C → C → Nat) : Nat → F → C → Nat → C → Nat :=
  fun t h c s d => bif Nat.beq s t then K h c d else 0

/-- What a stationary strength is at the current level. -/
theorem stationary_now (K : F → C → C → Nat) (t : Nat) (h : F) (c d : C) :
    stationary K t h c t d = K h c d :=
  congrArg (fun b => bif b then K h c d else 0) (beq_self t)

/-- **A stationary coupling holds at every step.** -/
theorem couplesAlways_of_stationary {K : F → C → C → Nat} {hs : List F} {d c : C}
    (couples : Couples cs part (stationary K) (fun _ => hs) d c) :
    CouplesAlways cs part (stationary K) (fun _ => hs) d c :=
  match couples with
  | ⟨t, h, s, mem, out, _, dMem, pos⟩ =>
    have strong : 0 < K h c d :=
      match hb : Nat.beq s t with
      | true => Nat.lt_of_lt_of_le pos
          (Nat.le_of_eq (congrArg (fun b => bif b then K h c d else 0) hb))
      | false => absurd (Nat.lt_of_lt_of_le pos
          (Nat.le_of_eq (congrArg (fun b => bif b then K h c d else 0) hb))) (Nat.lt_irrefl 0)
    fun t' => ⟨h, mem, out, dMem,
      Nat.lt_of_lt_of_le strong (Nat.le_of_eq (stationary_now K t' h c d).symm)⟩

/-- **With stationary strengths, a finite order is exact exactly where no loop lies upstream.** With
every condition listed and the same formations at every step, routes of some bounded number of
responses carry everything to `c` from every starting gap exactly where no loop lies upstream of
`c`. -/
theorem finite_order_iff_no_loop_stationary (every : ∀ c, c ∈ cs) (K : F → C → C → Nat)
    (hs : List F) (c : C) :
    (∀ δ : C → Nat, ∃ j, ∀ t, carriedWithin cs part σ (stationary K) (fun _ => hs) δ j t c =
        carried cs part σ (stationary K) (fun _ => hs) δ t c) ↔
      ∀ e, Upstream cs part (stationary K) (fun _ => hs) e c →
        ¬ OnLoop cs part (stationary K) (fun _ => hs) e :=
  finite_order_iff_no_loop every (fun _ _ => couplesAlways_of_stationary) c

/-- The product of ones is one. -/
theorem Loops.product_ones : ∀ j, Loops.product (fun _ => 1) j = 1
  | 0 => rfl
  | j + 1 => (Nat.mul_one _).trans (Loops.product_ones j)

/-- **Every loop of positive stationary strengths at least doubles what reaches it, every time
around.** -/
theorem carried_doubles_around {K : F → C → C → Nat} {hs : List F} {v : Nat → C} {m : Nat}
    {e : C} (start : v 0 = e) (back : v (m + 1) = e)
    (loop : ∀ i, i < m + 1 → ∃ h, h ∈ hs ∧ part h = false ∧ v i ∈ cs ∧ 0 < K h (v (i + 1)) (v i))
    (t R : Nat) :
    2 ^ R * carried cs part σ (stationary K) (fun _ => hs) δ t e ≤
      carried cs part σ (stationary K) (fun _ => hs) δ (t + (m + 1) * R) e :=
  Nat.le_trans (Nat.le_of_eq (congrArg (fun x => x ^ R * _)
      (congrArg (1 + ·) (Loops.product_ones (m + 1))).symm))
    (carried_runaway start back (fun i lt t' => match loop i lt with
      | ⟨h, mem, out, vMem, pos⟩ =>
        ⟨h, mem, out, vMem, Nat.le_trans pos (Nat.le_of_eq (stationary_now K t' h _ _).symm)⟩) t R)

end Stationary

/-! ## Exponentials outgrow polynomials -/

namespace Loops

theorem pow_mul_nat (b a : Nat) : ∀ n, (b ^ a) ^ n = b ^ (a * n)
  | 0 => rfl
  | n + 1 => (congrArg (· * b ^ a) (pow_mul_nat b a n)).trans (Naturals.pow_add b (a * n) a).symm

theorem pow_le_pow_base {a b : Nat} (le : a ≤ b) : ∀ n, a ^ n ≤ b ^ n
  | 0 => Nat.le_refl 1
  | n + 1 => Nat.mul_le_mul (pow_le_pow_base le n) le

theorem pow_le_pow_exp {b : Nat} (pos : 0 < b) {x y : Nat} (le : x ≤ y) : b ^ x ≤ b ^ y := by
  induction le with
  | refl => exact Nat.le_refl _
  | step _ ih => exact Nat.le_trans ih (Nat.le_trans (Nat.le_of_eq (Nat.mul_one _).symm)
      (Nat.mul_le_mul_left _ pos))

/-- Twice a power of two is the next power. -/
theorem two_pow_succ (a : Nat) : 2 ^ (a + 1) = 2 ^ a + 2 ^ a :=
  (Nat.mul_succ (2 ^ a) 1).trans (congrArg (· + 2 ^ a) (Nat.mul_one _))

theorem odd_lt_two_pow : ∀ a, 2 * (a + 3) + 1 < 2 ^ (a + 3)
  | 0 => by decide
  | a + 1 =>
    Nat.lt_of_lt_of_le (Nat.add_lt_add_right (odd_lt_two_pow a) 2)
      (Nat.le_trans (Nat.add_le_add_left (Nat.le_trans (by decide : 2 ≤ 2 ^ 3)
          (pow_le_pow_exp (Nat.succ_pos 1) (Nat.le_add_left 3 a))) _)
        (Nat.le_of_eq ((two_pow_succ (a + 3)).symm)))

theorem sq_lt_two_pow : ∀ a, (a + 5) * (a + 5) < 2 ^ (a + 5)
  | 0 => by decide
  | a + 1 =>
    have twice : (a + 5) + (a + 6) = 2 * (a + 5) + 1 :=
      (show (a + 5) + (a + 6) = (a + 5) + (a + 5) + 1 from rfl).trans (congrArg (· + 1)
        ((Nat.mul_comm 2 (a + 5)).trans ((Nat.mul_succ (a + 5) 1).trans
          (congrArg (· + (a + 5)) (Nat.mul_one _)))).symm)
    have expand : (a + 6) * (a + 6) = (a + 5) * (a + 5) + (2 * (a + 5) + 1) :=
      (add_mul_split (a + 5) 1 (a + 6)).trans ((Naturals.add_congr (Nat.mul_succ _ _)
        (Nat.one_mul _)).trans ((Nat.add_assoc _ _ _).trans (congrArg (_ + ·) twice)))
    Nat.lt_of_le_of_lt (Nat.le_of_eq expand)
      (Nat.lt_of_lt_of_le (Nat.add_lt_add (sq_lt_two_pow a) (odd_lt_two_pow (a + 2)))
        (Nat.le_of_eq (two_pow_succ (a + 5)).symm))

/-- **Every line is outgrown by the powers of two.** -/
theorem linear_lt_two_pow (c d : Nat) : ∃ a, c * a + d < 2 ^ a :=
  ⟨c + d + 5, Nat.lt_of_le_of_lt
    (Nat.le_trans (Nat.add_le_add_left (Nat.le_trans (Nat.le_of_eq (Nat.mul_one d).symm)
        (Nat.mul_le_mul_left d (Nat.succ_le_succ (Nat.zero_le _)))) _)
      (Nat.le_trans (Nat.le_of_eq (add_mul_split c d _).symm)
        (Nat.mul_le_mul_right _ (Nat.le_add_right (c + d) 5))))
    (sq_lt_two_pow (c + d))⟩

/-- **Every polynomial is outgrown by the powers of two.** -/
theorem poly_lt_two_pow (K n : Nat) : ∃ R, K * (R + 1) ^ n < 2 ^ R :=
  match linear_lt_two_pow n K with
  | ⟨a, below⟩ =>
    match le_dest (Nat.succ_le_of_lt (Naturals.two_pow_pos a)) with
    | ⟨R, split⟩ =>
      have top : R + 1 = 2 ^ a := (Nat.add_comm R 1).trans split.symm
      ⟨R, calc K * (R + 1) ^ n
          = K * 2 ^ (a * n) := congrArg (K * ·) ((congrArg (· ^ n) top).trans (pow_mul_nat 2 a n))
        _ < 2 ^ K * 2 ^ (a * n) := Nat.mul_lt_mul_of_pos_right (Naturals.lt_two_pow K) (Naturals.two_pow_pos _)
        _ = 2 ^ (K + a * n) := (Naturals.pow_add 2 K (a * n)).symm
        _ ≤ 2 ^ R := pow_le_pow_exp (Nat.succ_pos 1) (Nat.le_of_lt_succ (Nat.lt_of_lt_of_le
            (Nat.lt_of_le_of_lt (Nat.le_of_eq ((Nat.add_comm K _).trans
              (congrArg (· + K) (Nat.mul_comm a n)))) below) (Nat.le_of_eq top.symm)))⟩

/-- **No polynomial bounds a doubling.** A quantity that at least doubles at the steps
`t₀ + (m + 1) * R`, starting from at least one, is bounded by no `A * (t + 1) ^ n`. -/
theorem not_poly_of_doubling {f : Nat → Nat} {t₀ m : Nat}
    (doubling : ∀ R, 2 ^ R ≤ f (t₀ + (m + 1) * R)) (A n : Nat) :
    ¬ ∀ t, f t ≤ A * (t + 1) ^ n := fun bound =>
  match poly_lt_two_pow (A * (t₀ + m + 2) ^ n) n with
  | ⟨R, below⟩ =>
    have stretch : t₀ + (m + 1) * R + 1 ≤ (t₀ + m + 2) * (R + 1) :=
      Nat.le_trans (Nat.le_trans (Nat.add_le_add_right (Nat.add_le_add_left
          (Nat.mul_le_mul_right R (Nat.le_trans (Nat.le_add_left (m + 1) t₀)
            (Nat.le_succ _))) _) 1)
        (Nat.le_of_eq ((Nat.add_right_comm _ _ _).trans (Nat.add_comm _ _))))
        (Nat.le_trans (Nat.add_le_add_left (Nat.le_trans (Nat.le_succ (t₀ + 1))
            (Nat.le_trans (Nat.add_le_add_right (Nat.le_add_right t₀ m) 2) (Nat.le_refl _))) _)
          (Nat.le_of_eq (Nat.mul_succ _ _).symm))
    Nat.lt_irrefl _ (Nat.lt_of_lt_of_le below (Nat.le_trans (doubling R)
      (Nat.le_trans (bound _) (Nat.le_trans (Nat.mul_le_mul_left A (pow_le_pow_base stretch n))
        (Nat.le_of_eq ((congrArg (A * ·) (Naturals.mul_pow_eq _ _ n)).trans
          (mul_assoc_nat _ _ _).symm))))))

/-- A binomial count is at most a power. -/
theorem binom_le_pow : ∀ t i, binom t i ≤ (t + 1) ^ i
  | t, 0 => Nat.le_of_eq ((binom_zero t).trans rfl)
  | 0, _ + 1 => Nat.zero_le _
  | t + 1, i + 1 =>
    Nat.le_trans (Nat.add_le_add (binom_le_pow t i) (binom_le_pow t (i + 1)))
      (Nat.le_trans (Nat.le_of_eq (Nat.add_comm _ _))
        (Nat.le_trans (Nat.add_le_add (Nat.mul_le_mul_right (t + 1)
            (pow_le_pow_base (Nat.le_succ (t + 1)) i))
          (pow_le_pow_base (Nat.le_succ (t + 1)) i))
          (Nat.le_of_eq (Nat.mul_succ _ _).symm)))

/-- The orders up to `n` are at most `n + 1` times a power of `t + 1` of degree `n`. -/
theorem orderSum_le_poly (M n t : Nat) :
    orderSum M n t ≤ (n + 1) * (1 + M) ^ n * (t + 1) ^ n :=
  Nat.le_trans (total_le _ fun i mem =>
      have le : i ≤ n := Nat.le_of_lt_succ (Nat.lt_of_lt_of_le
        (between_of_mem_steps mem).2 (Nat.le_of_eq (Nat.zero_add _)))
      Nat.le_trans (Nat.mul_le_mul (Nat.le_trans (binom_le_pow t i)
          (pow_le_pow_exp (Nat.succ_pos t) le))
        (Nat.le_trans (pow_le_pow_base (Nat.le_add_left M 1) i)
          (pow_le_pow_exp (Nat.lt_of_lt_of_le (Nat.succ_pos 0) (Nat.le_add_right 1 M)) le)))
        (Nat.le_of_eq (Nat.mul_comm _ _)))
    (Nat.le_of_eq ((total_congr (fun _ => (Nat.mul_one _).symm) _).trans
      ((total_mul _ _ _).trans ((congrArg (_ * ·) (total_ones _)).trans
        ((congrArg (_ * ·) (steps_length 0 (n + 1))).trans
          ((Nat.mul_comm _ _).trans (mul_assoc_nat _ _ _).symm))))))

end Loops

section Growth

variable {cs : List C} {part : F → Bool} {σ : Nat → F → C → Nat} {δ : C → Nat}

/-- The stationary strength into `c`: over the formations outside the part, every listed
condition. -/
def inflowStationary (cs : List C) (part : F → Bool) (K : F → C → C → Nat) (hs : List F)
    (c : C) : Nat :=
  total hs fun h => bif part h then 0 else total cs fun d => K h c d

/-- With stationary strengths the strength into a condition is the same at every step. -/
theorem inflow_stationary (K : F → C → C → Nat) (hs : List F) (t : Nat) (c : C) :
    inflow cs part (stationary K) (fun _ => hs) t c = inflowStationary cs part K hs c :=
  total_congr_on fun h _ =>
    match part h with
    | true => rfl
    | false =>
      (total_swap _ cs _).trans (total_congr_on fun d _ =>
        (Propagation.total_steps_at (q := fun s => stationary K t h c s d) (fun s ne =>
          match hb : Nat.beq s t with
          | true => absurd (Nat.eq_of_beq_eq_true hb) ne
          | false => congrArg (fun b => bif b then K h c d else 0) hb)).trans
          (stationary_now K t h c d))

/-- A stationary coupling is a positive strength of a formation present at every step. -/
theorem strength_of_couples {K : F → C → C → Nat} {hs : List F} {d c : C}
    (couples : Couples cs part (stationary K) (fun _ => hs) d c) :
    ∃ h, h ∈ hs ∧ part h = false ∧ d ∈ cs ∧ 0 < K h c d :=
  match couplesAlways_of_stationary couples 0 with
  | ⟨h, mem, out, dMem, pos⟩ =>
    ⟨h, mem, out, dMem, Nat.lt_of_lt_of_le pos (Nat.le_of_eq (stationary_now K 0 h c d))⟩

/-- **Along a chain of stationary couplings.** What has reached the chain's start has reached its
end, at least, after as many steps as it has couplings. -/
theorem carried_along_stationary {K : F → C → C → Nat} {hs : List F} {u : Nat → C} {q : Nat}
    (path : Coupled cs part (stationary K) (fun _ => hs) u q) (t : Nat) :
    carried cs part σ (stationary K) (fun _ => hs) δ t (u 0) ≤
      carried cs part σ (stationary K) (fun _ => hs) δ (t + q) (u q) :=
  Nat.le_trans (Nat.le_of_eq ((Nat.one_mul _).symm.trans
      (congrArg (· * _) (Loops.product_ones q).symm)))
    (carried_along (w := fun _ => 1) (fun i lt t' =>
      match couplesAlways_of_stationary (path i lt) t' with
      | ⟨h, mem, out, uMem, pos⟩ => ⟨h, mem, out, uMem, pos⟩) t)

/-- **A loop upstream doubles what arrives.** With stationary strengths, where a loop lies upstream
of `c`, what has reached the loop arrives at `c`, at least doubled every time around. -/
theorem carried_doubles_into {K : F → C → C → Nat} {hs : List F} {e c : C}
    (up : Upstream cs part (stationary K) (fun _ => hs) e c)
    (onLoop : OnLoop cs part (stationary K) (fun _ => hs) e) :
    ∃ q m, ∀ t R, 2 ^ R * carried cs part σ (stationary K) (fun _ => hs) δ t e ≤
      carried cs part σ (stationary K) (fun _ => hs) δ (t + (m + 1) * R + q) c :=
  match up, onLoop with
  | _, ⟨_, 0, pos, _, _, _⟩ => absurd pos (Nat.lt_irrefl 0)
  | ⟨_, q, from_, to, path⟩, ⟨_, m + 1, _, start, back, loop⟩ =>
    ⟨q, m, fun t R => Nat.le_trans (carried_doubles_around start back
        (fun i lt => strength_of_couples (loop i lt)) t R)
      (Nat.le_trans (Nat.le_of_eq (congrArg (carried cs part σ (stationary K) (fun _ => hs) δ
          (t + (m + 1) * R)) from_.symm))
        (Nat.le_trans (carried_along_stationary path (t + (m + 1) * R))
          (Nat.le_of_eq (congrArg (carried cs part σ (stationary K) (fun _ => hs) δ
            (t + (m + 1) * R + q)) to))))⟩

/-- **A difference runs away exactly through a loop.** With stationary strengths, every condition
listed and the part giving no gap after the start, the carried amount at `c` is bounded by a
polynomial in the steps, from every starting gap, exactly where no loop lies upstream of `c`; where
one does, it at least doubles every time around the loop (`carried_doubles_around`). So the most
difference that can arrive at `c` grows polynomially or runs away, as the couplings upstream of it
close a loop or not (`most_difference_arrives`). -/
theorem polynomial_iff_no_loop (every : ∀ c, c ∈ cs) (K : F → C → C → Nat) (hs : List F)
    (c : C) :
    (∀ δ : C → Nat, ∃ A n, ∀ t,
        carried cs part (fun _ _ _ => 0) (stationary K) (fun _ => hs) δ t c ≤ A * (t + 1) ^ n) ↔
      ∀ e, Upstream cs part (stationary K) (fun _ => hs) e c →
        ¬ OnLoop cs part (stationary K) (fun _ => hs) e :=
  ⟨fun bounded _ up onLoop =>
    match bounded (fun _ => 1),
      carried_doubles_into (σ := fun _ _ _ => 0) (δ := fun _ => 1) up onLoop with
    | ⟨A, n, bound⟩, ⟨q, m, doubles⟩ =>
      Loops.not_poly_of_doubling
        (f := fun t =>
          carried cs part (fun _ _ _ => 0) (stationary K) (fun _ => hs) (fun _ => 1) t c)
        (t₀ := q) (m := m) (fun R =>
          Nat.le_trans (Nat.le_of_eq (Nat.mul_one _).symm) (Nat.le_trans (doubles 0 R)
            (Nat.le_of_eq (congrArg (fun x =>
                carried cs part (fun _ _ _ => 0) (stationary K) (fun _ => hs) (fun _ => 1) x c)
              ((congrArg (· + q) (Nat.zero_add _)).trans (Nat.add_comm _ _)))))) A n bound,
   fun noLoop δ =>
    ⟨total cs δ * ((cs.length + 1) * (1 + total cs (inflowStationary cs part K hs)) ^ cs.length),
      cs.length, fun t =>
        Nat.le_trans (carried_le_polynomial every noLoop (Nat.le_succ _)
            (fun c => le_total_of_mem (every c))
            (fun t c => Nat.le_trans (Nat.le_of_eq (inflow_stationary K hs t c))
              (le_total_of_mem (q := inflowStationary cs part K hs) (every c))) t)
          (Nat.le_trans (Nat.mul_le_mul_left _ (Loops.orderSum_le_poly _ _ t))
            (Nat.le_of_eq (mul_assoc_nat _ _ _).symm))⟩⟩

end Growth

/-! ## For every law with the strengths -/

section EveryLaw

variable [DecidableEq C] {cs : List C} {part : F → Bool} {σ : Nat → F → C → Nat}
  {k : Nat → F → C → Nat → C → Nat} {present : Nat → List F} {δ : C → Nat}

/-- **Where no loop lies upstream, the most difference that can arrive is what a finite order
carries.** With each condition listed once and no loop upstream of `c`: for every law of what has
stood with the coupling strengths `k`, and every two balanced flows of it as in
`most_difference_arrives`, a gap at `c` at `T` is at most `a` exactly where what routes of at most
`n` responses carry there is at most `a`, wherever `n + 1` is at least the number of conditions. -/
theorem most_difference_within (every : ∀ c, c ∈ cs) (distinct : Distinct cs) {c : C}
    (noLoop : ∀ e, Upstream cs part k present e c → ¬ OnLoop cs part k present e) {n : Nat}
    (long : cs.length ≤ n + 1) (T a : Nat) :
    (∀ (law : ExchangeLaw F C) (L L' : Flow F C) (W W' : Web F C), law.Nonanticipating →
      L.Balances W → L'.Balances W' → (∀ t, L.present t = present t) →
      (∀ t, L'.present t = present t) → L.Follows law part W.level → L'.Follows law part W'.level →
      (∀ t h c s d, part h = false → s ≤ t → law.RespondsWithin t h c s d (k t h c s d)) →
      (∀ t h c, part h = true → L.exchangeGap L' t h c ≤ σ t h c) →
      (∀ c, gap (W.level 0 c) (W'.level 0 c) ≤ δ c) →
      gap (W.level T c) (W'.level T c) ≤ a) ↔
      carriedWithin cs part σ k present δ n T c ≤ a :=
  (most_difference_arrives every distinct T c a).trans
    ⟨fun le => Nat.le_trans
        (Nat.le_of_eq (carriedWithin_exact_of_no_loop every noLoop long T)) le,
     fun le => Nat.le_trans
        (Nat.le_of_eq (carriedWithin_exact_of_no_loop every noLoop long T).symm) le⟩

/-- **Where no loop lies upstream, every gap is at most a polynomial.** With every condition listed
and no loop upstream of `c`: in two balanced flows of a law of what has stood with the coupling
strengths `k`, the part acting alike in both, starting within gaps at most `D` and the strengths
into each condition summing to at most `M` at each step, the gap at `c` over `t` steps is at most
`D` times the sum, over orders `i ≤ n`, of the ways to place `i` responses among the steps times
`M ^ i`, wherever `n + 1` is at least the number of conditions. -/
theorem gap_le_polynomial (every : ∀ c, c ∈ cs) {c : C}
    (noLoop : ∀ e, Upstream cs part k present e c → ¬ OnLoop cs part k present e) {n : Nat}
    (long : cs.length ≤ n + 1) {M D : Nat} (bounded : ∀ c, δ c ≤ D)
    (into : ∀ t c, inflow cs part k present t c ≤ M) {law : ExchangeLaw F C}
    {L L' : Flow F C} {W W' : Web F C} (na : law.Nonanticipating)
    (balances : L.Balances W) (balances' : L'.Balances W')
    (onL : ∀ t, L.present t = present t) (onL' : ∀ t, L'.present t = present t)
    (follows : L.Follows law part W.level) (follows' : L'.Follows law part W'.level)
    (strengths : ∀ t h c s d, part h = false → s ≤ t → law.RespondsWithin t h c s d (k t h c s d))
    (acts : ∀ t h c, part h = true → L.exchangeGap L' t h c ≤ 0)
    (start : ∀ c, gap (W.level 0 c) (W'.level 0 c) ≤ δ c) (t : Nat) :
    gap (W.level t c) (W'.level t c) ≤ D * Loops.orderSum M n t :=
  Nat.le_trans
    (gap_le_carried (σ := fun _ _ _ => 0) na every balances balances' onL onL' follows follows'
      strengths acts start t c)
    (carried_le_polynomial every noLoop long bounded into t)

/-- **The most difference that can arrive runs away exactly through a loop.** With stationary
strengths and each condition listed once: over every law of what has stood coupled with these
strengths, and every two balanced flows of it with the formations `hs` at every step and the part
acting alike in both, the gap at `c` is bounded by a polynomial in the steps, from every bound on
the starting gaps, exactly where no loop lies upstream of `c`. -/
theorem gap_polynomial_iff_no_loop (every : ∀ c, c ∈ cs) (distinct : Distinct cs)
    (K : F → C → C → Nat) (hs : List F) (c : C) :
    (∀ δ : C → Nat, ∃ A n, ∀ t, ∀ (law : ExchangeLaw F C) (L L' : Flow F C) (W W' : Web F C),
      law.Nonanticipating → L.Balances W → L'.Balances W' → (∀ t, L.present t = hs) →
      (∀ t, L'.present t = hs) → L.Follows law part W.level → L'.Follows law part W'.level →
      (∀ t h c s d, part h = false → s ≤ t →
        law.RespondsWithin t h c s d (stationary K t h c s d)) →
      (∀ t h c, part h = true → L.exchangeGap L' t h c ≤ 0) →
      (∀ c, gap (W.level 0 c) (W'.level 0 c) ≤ δ c) →
      gap (W.level t c) (W'.level t c) ≤ A * (t + 1) ^ n) ↔
      ∀ e, Upstream cs part (stationary K) (fun _ => hs) e c →
        ¬ OnLoop cs part (stationary K) (fun _ => hs) e :=
  Iff.trans (b := ∀ δ : C → Nat, ∃ A n, ∀ t,
      carried cs part (fun _ _ _ => 0) (stationary K) (fun _ => hs) δ t c ≤ A * (t + 1) ^ n)
    ⟨fun bounded δ => match bounded δ with
      | ⟨A, n, bound⟩ => ⟨A, n, fun t =>
          (most_difference_arrives (σ := fun _ _ _ => 0) (k := stationary K)
            (present := fun _ => hs) every distinct t c _).1 (bound t)⟩,
     fun bounded δ => match bounded δ with
      | ⟨A, n, bound⟩ => ⟨A, n, fun t =>
          (most_difference_arrives (σ := fun _ _ _ => 0) (k := stationary K)
            (present := fun _ => hs) every distinct t c _).2 (bound t)⟩⟩
    (polynomial_iff_no_loop every K hs c)

end EveryLaw

end Becoming
