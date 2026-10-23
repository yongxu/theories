import Becoming.Prelude

/-!
# Amounts: rest over amounts that may be dense

The rest family of the spine (`falls_not_recurring`, `falls_stop_unrefuted` and the laws of
families, standing and worlds that reach their conclusion through them) counts amounts in whole
numbers. This module states the step on which those laws turn for any amounts, and the spine's
laws are its whole-number instance: `Becoming.Renewal` proves `falls_not_recurring` from
`Amounts.rests`, `Becoming.Space` proves `falls_stop_unrefuted` from `Amounts.rests_unrefuted`, and
`Becoming.Dissipation` and `Becoming.Openness` prove the family laws and the stopping of change from
`Amounts.family_rests_of_archimedean`, `Amounts.losses_within` and `Amounts.rests_unrefuted`. It
imports only `Becoming.Prelude`, so it lies below every module that reads a level.

* **Amounts.** An addition, associative and commutative with nothing as its unit, and an order
  that addition keeps and that cancels, with nothing least (`Amounts`). Nothing more is asked:
  no amount need be a whole number, and between two amounts there may be a third. The order is a
  preorder, so two representations of one amount are each within the other and no quotient is
  taken.
* **The loss law.** Where across each step from `T` on the amount after the step, with the
  step's loss, is within the amount before, the losses since `T`, added, are within the amount
  at `T` (`Amounts.losses_within`). No least loss is named: in any amounts the losses of a
  falling stock are summable, so a fall at every step does not exhaust the stock unless the
  losses do not shrink.
* **The approach to rest, with no least loss.** Under the same premise, for any `k` steps from `T`
  on each losing at least `ε`, `k` copies of `ε` are within the amount at `T`
  (`Amounts.large_losses_within`); so where `m` copies are not, fewer than `m` steps lose at least
  `ε` (`Amounts.few_large_losses`). In Archimedean amounts this holds for every `ε` above nothing:
  a closed amount comes arbitrarily near rest, and steps losing at least `ε` do not recur
  (`Amounts.few_large_losses_of_archimedean`, `Amounts.approaches_rest`). The Archimedean
  property is the structural premise, and nothing else is asked. In whole numbers, where every
  loss above nothing is at least one, approach is rest: no more steps lose anything than the stock
  at `T` counts (`Amounts.whole_losing_steps`).
* **The least-loss law of rest.** Where an amount does not rise from `T` on and falls by at least
  `ε` across each step at which `P` holds, and `m` copies of `ε` are not within the amount at
  `T`, steps at which `P` holds do not recur (`Amounts.rests`); with every premise read as far
  as can be refuted, it is not the case that after every step from `T` on a later such step stays
  unrefuted (`Amounts.rests_unrefuted`). The two premises are the least loss `ε` and the bound of
  the stock by finitely many least losses. In Archimedean amounts the bound holds for every `ε`
  above nothing, so a least loss alone brings rest (`Amounts.rests_of_archimedean`).
* **A family at rest.** Read a family's stock, uptake and replenishment as amounts: where from
  `T` on the stock after a step with the uptake is within the stock before with the
  replenishment, the replenishment is within the uptake, at each step at which `P` holds the
  replenishment with `ε` is within the uptake, and the stock at `T` lies within fewer than `m`
  copies of `ε`, steps at which `P` holds do not recur (`Amounts.family_rests`, from
  `Amounts.family_still` and `Amounts.family_loses`; in Archimedean amounts
  `Amounts.family_rests_of_archimedean`).
* **More needs replenishment without bound.** Balanced, a family whose uptake from some step on
  exceeds every multiple of a least take above nothing is replenished beyond every multiple of it,
  in Archimedean amounts (`Amounts.replenishment_unbounded`); `Flow.More.replenishment_unbounded_from`
  is the whole-number instance.
* **Whole numbers are the instance.** In whole-number amounts (`Amounts.whole`, Archimedean,
  `Amounts.whole_archimedean`) the least loss is one and every stock lies within its own count of
  ones, plus one (`Amounts.whole_within`).
* **Rest by balance.** In whole numbers the stretch balance of the prelude bounds how long a count
  can lose: balanced across each step of a stretch and losing at least one more than it gains at
  each, it falls by at least the stretch's length (`Amounts.falls_by_stretch`); where whether a step
  is marked is decided and each marked step loses at least one more than it gains, an unmarked step
  comes within what stood at the start (`Amounts.unmarked_within`); and two balanced counts compare
  by their exchanges (`Amounts.le_by_exchange`). The ending of courses above their renewal
  (`Optimum.ends_within`), the comparison of weighted draws (`Optimum.Next.drawable_le_of_gains`), the
  rest of a law's run with a bounded mark (`LastChange.still_within`), the fall below a
  regime's point of no return (`RegimeMargin.Adjusted.orbit_bound`) and the rest of a coupled web
  (`RegimeMargin.Coupled.Indexed.rests_by`) are its cases.

That each premise is needed (dyadic and layered amounts) and what rest has to do with return
(`Law.loss_needs_merge`) are stated in `Becoming.LeastLoss`. The representation commits to
discrete steps. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

/-- Amounts with their laws: an addition, associative and commutative with nothing as its
unit, and an order that addition keeps and that cancels, with nothing least. No amount is
required to be a whole number, and between two amounts there may be a third. The order is a
preorder: two representations of one amount (`1/2` and `2/4` in `Dyadic`) are each within the
other, so no quotient is taken. -/
structure Amounts (A : Type) where
  zero : A
  add : A → A → A
  le : A → A → Prop
  le_refl : ∀ a, le a a
  le_trans : ∀ {a b c : A}, le a b → le b c → le a c
  add_assoc : ∀ a b c, add (add a b) c = add a (add b c)
  add_comm : ∀ a b, add a b = add b a
  zero_add : ∀ a, add zero a = a
  add_le_add_right : ∀ {a b : A} (c : A), le a b → le (add a c) (add b c)
  le_of_add_le_add_right : ∀ {a b : A} (c : A), le (add a c) (add b c) → le a b
  zero_le : ∀ a, le zero a

namespace Amounts

variable {A : Type} (M : Amounts A)

/-- `n` copies of `a`, added. -/
def times : Nat → A → A
  | 0, _ => M.zero
  | n + 1, a => M.add (times n a) a

/-- The losses `d` of the `n` steps from `S`, added. -/
def sum (d : Nat → A) (S : Nat) : Nat → A
  | 0 => M.zero
  | n + 1 => M.add (sum d S n) (d (S + n))

/-- The amounts are Archimedean: every amount above nothing, taken often enough, is within no
given amount. -/
def Archimedean : Prop :=
  ∀ a e : A, ¬ M.le e M.zero → ∃ m, ¬ M.le (M.times m e) a

variable {M}

theorem add_zero (a : A) : M.add a M.zero = a :=
  (M.add_comm a M.zero).trans (M.zero_add a)

theorem le_of_eq {a b : A} (same : a = b) : M.le a b :=
  same ▸ M.le_refl a

theorem add_le_add_left {a b : A} (c : A) (le : M.le a b) : M.le (M.add c a) (M.add c b) := by
  rw [M.add_comm c a, M.add_comm c b]
  exact M.add_le_add_right c le

theorem le_add_right (a b : A) : M.le a (M.add a b) := by
  have h := add_le_add_left a (M.zero_le b)
  rw [add_zero] at h
  exact h

theorem le_add_left (a b : A) : M.le a (M.add b a) := by
  rw [M.add_comm b a]
  exact le_add_right a b

theorem add_swap (x y z : A) : M.add x (M.add y z) = M.add (M.add x z) y := by
  rw [M.add_comm y z, M.add_assoc]

/-- Copies of a larger amount are larger. -/
theorem times_le {a b : A} (le : M.le a b) : ∀ m, M.le (M.times m a) (M.times m b)
  | 0 => M.le_refl _
  | m + 1 => M.le_trans (M.add_le_add_right a (times_le le m)) (add_le_add_left _ le)

/-- An amount not rising across any step from `T` on, as far as can be refuted, is not refuted
to be within its value at any earlier step from `T` on. -/
theorem still_le {s : Nat → A} {T : Nat} (still : ∀ t, T ≤ t → ¬¬ M.le (s (t + 1)) (s t)) :
    ∀ k u, T ≤ u → ¬¬ M.le (s (u + k)) (s u)
  | 0, _, _ => fun no => no (M.le_refl _)
  | k + 1, u, from_ => fun no => still_le still k u from_ fun earlier =>
      still (u + k) (Nat.le_trans from_ (Nat.le_add_right u k)) fun step =>
        no (M.le_trans step earlier)

/-- The loss law. Where, across each of the `n` steps from `T`, the amount after the step
together with the step's loss `d` is within the amount before, the losses of those steps, added,
are within the amount at `T`, with what remains. No least loss and no unit are named. -/
theorem losses_within {s d : Nat → A} {T : Nat} :
    ∀ n, (∀ t, T ≤ t → t < T + n → M.le (M.add (s (t + 1)) (d t)) (s t)) →
      M.le (M.add (s (T + n)) (M.sum d T n)) (s T)
  | 0, _ => le_of_eq (add_zero (s T))
  | n + 1, falls => M.le_trans (le_of_eq (add_swap _ _ _))
      (M.le_trans
        (M.add_le_add_right _ (falls (T + n) (Nat.le_add_right T n) (Nat.lt_succ_self (T + n))))
        (losses_within n fun t from_ below => falls t from_ (Nat.lt_succ_of_lt below)))

/-- At each recurrence of `P`, the amount loses at least `ε` more: where it does not rise from `T`
on and falls by at least `ε` across each step at which `P` holds, each as far as can be refuted,
and `P` is not refuted to hold after every step from `T` on, then for every `m` it is not refuted
that at some step from `T` on the amount, with `m` copies of `ε`, is within its value at `T`. -/
theorem loses_times {s : Nat → A} {ε : A} {P : Nat → Prop} {T : Nat}
    (still : ∀ t, T ≤ t → ¬¬ M.le (s (t + 1)) (s t))
    (loses : ∀ t, T ≤ t → P t → ¬¬ M.le (M.add (s (t + 1)) ε) (s t))
    (recurs : ∀ N, T ≤ N → ¬¬ ∃ t, N ≤ t ∧ P t) :
    ∀ m, ¬¬ ∃ u, T ≤ u ∧ M.le (M.add (s u) (M.times m ε)) (s T)
  | 0 => fun no => no ⟨T, Nat.le_refl T, le_of_eq (add_zero (s T))⟩
  | m + 1 => fun no => loses_times still loses recurs m fun ⟨u, from_, within⟩ =>
      recurs u from_ fun ⟨t, later, holds⟩ => match Nat.le.dest later with
        | ⟨k, same⟩ =>
          have from_t : T ≤ t := Nat.le_trans from_ later
          still_le still k u from_ fun down =>
            loses t from_t holds fun step =>
              no ⟨t + 1, Nat.le_succ_of_le from_t,
                M.le_trans (le_of_eq (add_swap (s (t + 1)) (M.times m ε) ε))
                  (M.le_trans (M.add_le_add_right _ step)
                    (M.le_trans
                      (M.add_le_add_right _
                        (Eq.subst (motive := fun x => M.le (s x) (s u)) same down))
                      within))⟩

/-- **The least-loss law of rest.** Where an amount does not rise from `T` on, falls by at least
`ε` across each step at which `P` holds, each as far as can be refuted, and `m` copies of `ε` are
not within its value at `T`, it is not the case that after every step from `T` on a later step at
which `P` holds stays unrefuted. Two premises carry the conclusion: the least loss `ε` at each
step at which `P` holds, and the amount at `T` lying within fewer than `m` least losses. -/
theorem rests_unrefuted {s : Nat → A} {ε : A} {P : Nat → Prop} {T m : Nat}
    (still : ∀ t, T ≤ t → ¬¬ M.le (s (t + 1)) (s t))
    (loses : ∀ t, T ≤ t → P t → ¬¬ M.le (M.add (s (t + 1)) ε) (s t))
    (within : ¬ M.le (M.times m ε) (s T)) :
    ¬ ∀ N, T ≤ N → ¬¬ ∃ t, N ≤ t ∧ P t :=
  fun recurs => loses_times still loses recurs m fun ⟨u, _, le⟩ =>
    within (M.le_trans (le_add_left (M.times m ε) (s u)) le)

/-- So, with the premises holding outright, steps at which `P` holds do not recur. -/
theorem rests {s : Nat → A} {ε : A} {P : Nat → Prop} {T m : Nat}
    (still : ∀ t, T ≤ t → M.le (s (t + 1)) (s t))
    (loses : ∀ t, T ≤ t → P t → M.le (M.add (s (t + 1)) ε) (s t))
    (within : ¬ M.le (M.times m ε) (s T)) :
    ¬ ∀ N, ∃ t, N ≤ t ∧ P t :=
  fun recurs => rests_unrefuted (fun t later no => no (still t later))
    (fun t later holds no => no (loses t later holds)) within fun N _ no => no (recurs N)

/-- In Archimedean amounts every amount lies within finitely many copies of a least loss above
nothing, so the least loss alone brings rest. -/
theorem rests_of_archimedean (archimedean : M.Archimedean) {s : Nat → A} {ε : A}
    {P : Nat → Prop} {T : Nat} (positive : ¬ M.le ε M.zero)
    (still : ∀ t, T ≤ t → M.le (s (t + 1)) (s t))
    (loses : ∀ t, T ≤ t → P t → M.le (M.add (s (t + 1)) ε) (s t)) :
    ¬ ∀ N, ∃ t, N ≤ t ∧ P t :=
  match archimedean (s T) ε positive with
  | ⟨_, within⟩ => rests still loses within

/-- Balanced and dissipated on, a family's stock does not rise: the replenishment cancels. -/
theorem family_still {s u r : Nat → A} {T : Nat}
    (balances : ∀ t, T ≤ t → M.le (M.add (s (t + 1)) (u t)) (M.add (s t) (r t)))
    (dissipates : ∀ t, T ≤ t → M.le (r t) (u t)) :
    ∀ t, T ≤ t → M.le (s (t + 1)) (s t) :=
  fun t later => M.le_of_add_le_add_right (r t)
    (M.le_trans (add_le_add_left _ (dissipates t later)) (balances t later))

/-- Balanced, a family whose replenishment with `ε` is within its uptake at a step falls by at
least `ε` across it. -/
theorem family_loses {s u r : Nat → A} {ε : A} {P : Nat → Prop} {T : Nat}
    (balances : ∀ t, T ≤ t → M.le (M.add (s (t + 1)) (u t)) (M.add (s t) (r t)))
    (least : ∀ t, T ≤ t → P t → M.le (M.add (r t) ε) (u t)) :
    ∀ t, T ≤ t → P t → M.le (M.add (s (t + 1)) ε) (s t) :=
  fun t later holds => M.le_of_add_le_add_right (r t)
    (M.le_trans (le_of_eq (M.add_assoc _ _ _))
      (M.le_trans
        (add_le_add_left _ (M.le_trans (le_of_eq (M.add_comm ε (r t))) (least t later holds)))
        (balances t later)))

/-- **A family at rest, in any amounts.** Read a family's stock `s`, its uptake `u` and its
replenishment `r` across each step as amounts. Where from `T` on the stock after the step with the
uptake is within the stock before with the replenishment (balance), the replenishment is within
the uptake (dissipation), at each step at which `P` holds the replenishment with a least loss `ε`
is within the uptake, and the stock at `T` lies within fewer than `m` least losses, steps at which
`P` holds do not recur. -/
theorem family_rests {s u r : Nat → A} {ε : A} {P : Nat → Prop} {T m : Nat}
    (balances : ∀ t, T ≤ t → M.le (M.add (s (t + 1)) (u t)) (M.add (s t) (r t)))
    (dissipates : ∀ t, T ≤ t → M.le (r t) (u t))
    (least : ∀ t, T ≤ t → P t → M.le (M.add (r t) ε) (u t))
    (within : ¬ M.le (M.times m ε) (s T)) :
    ¬ ∀ N, ∃ t, N ≤ t ∧ P t :=
  rests (family_still balances dissipates) (family_loses balances least) within

/-- In Archimedean amounts, a family balanced and dissipated on with a least loss above nothing
comes to rest. -/
theorem family_rests_of_archimedean (archimedean : M.Archimedean) {s u r : Nat → A} {ε : A}
    {P : Nat → Prop} {T : Nat} (positive : ¬ M.le ε M.zero)
    (balances : ∀ t, T ≤ t → M.le (M.add (s (t + 1)) (u t)) (M.add (s t) (r t)))
    (dissipates : ∀ t, T ≤ t → M.le (r t) (u t))
    (least : ∀ t, T ≤ t → P t → M.le (M.add (r t) ε) (u t)) :
    ¬ ∀ N, ∃ t, N ≤ t ∧ P t :=
  rests_of_archimedean archimedean positive (family_still balances dissipates)
    (family_loses balances least)

/-- **More without end needs replenishment beyond every multiple of a least take.** Read a family's
stock, uptake and replenishment as amounts, balanced from `T₀` on: where for every number `m`, from
some step on, the uptake is at least `m` least takes `ε` above nothing (as when at least `m`
formations take at least `ε` each), no bound within finitely many least takes holds of the
replenishment from `T₀` on. In Archimedean amounts the family would otherwise fall by at least
`ε` at every step from some step on and come to rest (`Amounts.family_rests_of_archimedean`). In
whole numbers the least take is one and every bound is within its own count of ones, so the bound
is any bound (`Flow.More.replenishment_unbounded_from`). -/
theorem replenishment_unbounded (archimedean : M.Archimedean) {s u r : Nat → A} {ε : A}
    {T₀ : Nat} (positive : ¬ M.le ε M.zero)
    (balances : ∀ t, T₀ ≤ t → M.le (M.add (s (t + 1)) (u t)) (M.add (s t) (r t)))
    (more : ∀ m, ∃ T, ∀ t, T ≤ t → M.le (M.times m ε) (u t)) (b : Nat) :
    ¬ ∀ t, T₀ ≤ t → M.le (r t) (M.times b ε) :=
  fun bounded => match more (b + 1) with
  | ⟨T₁, many⟩ =>
    have least : ∀ t, T₁ + T₀ ≤ t → M.le (M.add (r t) ε) (u t) := fun t later =>
      M.le_trans (M.add_le_add_right ε (bounded t (Nat.le_trans (Nat.le_add_left T₀ T₁) later)))
        (many t (Nat.le_trans (Nat.le_add_right T₁ T₀) later))
    family_rests_of_archimedean archimedean (T := T₁ + T₀) (P := fun _ => True) positive
      (fun t later => balances t (Nat.le_trans (Nat.le_add_left T₀ T₁) later))
      (fun t later => M.le_trans (le_add_right (r t) ε) (least t later))
      (fun t later _ => least t later)
      (fun N => ⟨N + (T₁ + T₀), Nat.le_add_right N _, trivial⟩)

/-! ### The approach to rest: no least loss -/

/-- An amount that does not rise across any step from `T` on is, at every later step, within its
value at every earlier step from `T` on. -/
theorem still_within {s : Nat → A} {T : Nat} (still : ∀ t, T ≤ t → M.le (s (t + 1)) (s t)) :
    ∀ k u, T ≤ u → M.le (s (u + k)) (s u)
  | 0, _, _ => M.le_refl _
  | k + 1, u, from_ => M.le_trans (still (u + k) (Nat.le_trans from_ (Nat.le_add_right u k)))
      (still_within still k u from_)

/-- An amount that, with each step's loss, is within its value before the step does not rise. -/
theorem still_of_falls {s d : Nat → A} {T : Nat}
    (falls : ∀ t, T ≤ t → M.le (M.add (s (t + 1)) (d t)) (s t)) :
    ∀ t, T ≤ t → M.le (s (t + 1)) (s t) :=
  fun t later => M.le_trans (le_add_right _ (d t)) (falls t later)

/-- Along `k` steps `f 0 < f 1 < ⋯` from `T` on, each losing at least `ε`, the amount after the
last of them, with `k` copies of `ε`, is within the amount at `T`. -/
theorem large_losses_from {s d : Nat → A} {ε : A} {T : Nat}
    (falls : ∀ t, T ≤ t → M.le (M.add (s (t + 1)) (d t)) (s t))
    {f : Nat → Nat} (start : T ≤ f 0) (rising : ∀ i, f i < f (i + 1)) :
    ∀ k, (∀ i, i < k → M.le ε (d (f i))) →
      ∃ u, T ≤ u ∧ u ≤ f k ∧ M.le (M.add (s u) (M.times k ε)) (s T)
  | 0, _ => ⟨T, Nat.le_refl T, start, le_of_eq (add_zero (s T))⟩
  | k + 1, large =>
    match large_losses_from falls start rising k
        (fun i below => large i (Nat.lt_succ_of_lt below)) with
    | ⟨u, from_, below, within⟩ =>
      match Nat.le.dest below with
      | ⟨j, same⟩ =>
        have from_f : T ≤ f k := Nat.le_trans from_ below
        have down : M.le (s (f k)) (s u) :=
          Eq.subst (motive := fun x => M.le (s x) (s u)) same
            (still_within (still_of_falls falls) j u from_)
        ⟨f k + 1, Nat.le_succ_of_le from_f, rising k,
          M.le_trans (le_of_eq (add_swap (s (f k + 1)) (M.times k ε) ε))
            (M.le_trans
              (M.add_le_add_right _
                (M.le_trans (add_le_add_left _ (large k (Nat.lt_succ_self k)))
                  (falls (f k) from_f)))
              (M.le_trans (M.add_le_add_right _ down) within))⟩

/-- **The approach to rest, counted.** Where across each step from `T` on the amount after the
step, with the step's loss, is within the amount before, then for any `k` steps
`f 0 < f 1 < ⋯` from `T` on, each losing at least `ε`, `k` copies of `ε` are within the amount
at `T`. No least loss is asked: `ε` is any amount, and the law bounds how many steps lose at
least `ε`. -/
theorem large_losses_within {s d : Nat → A} {ε : A} {T : Nat}
    (falls : ∀ t, T ≤ t → M.le (M.add (s (t + 1)) (d t)) (s t))
    {f : Nat → Nat} (start : T ≤ f 0) (rising : ∀ i, f i < f (i + 1)) (k : Nat)
    (large : ∀ i, i < k → M.le ε (d (f i))) :
    M.le (M.times k ε) (s T) :=
  match large_losses_from falls start rising k large with
  | ⟨u, _, _, within⟩ => M.le_trans (le_add_left (M.times k ε) (s u)) within

/-- So where `m` copies of `ε` are not within the amount at `T`, no `m` steps from `T` on each
lose at least `ε`: fewer than `m` do. -/
theorem few_large_losses {s d : Nat → A} {ε : A} {T m : Nat}
    (falls : ∀ t, T ≤ t → M.le (M.add (s (t + 1)) (d t)) (s t))
    (within : ¬ M.le (M.times m ε) (s T)) :
    ¬ ∃ f : Nat → Nat, T ≤ f 0 ∧ (∀ i, f i < f (i + 1)) ∧ ∀ i, i < m → M.le ε (d (f i)) :=
  fun ⟨_, start, rising, large⟩ => within (large_losses_within falls start rising m large)

/-- **The approach to rest.** In Archimedean amounts, an amount that, with each step's loss, is
within its value before the step comes arbitrarily near rest: for every `ε` above nothing there is
a count `m` such that no `m` steps from `T` on each lose at least `ε`. Only the Archimedean
property of the amounts is asked, no least loss. -/
theorem few_large_losses_of_archimedean (archimedean : M.Archimedean) {s d : Nat → A} {ε : A}
    {T : Nat} (falls : ∀ t, T ≤ t → M.le (M.add (s (t + 1)) (d t)) (s t))
    (positive : ¬ M.le ε M.zero) :
    ∃ m, ¬ ∃ f : Nat → Nat, T ≤ f 0 ∧ (∀ i, f i < f (i + 1)) ∧ ∀ i, i < m → M.le ε (d (f i)) :=
  match archimedean (s T) ε positive with
  | ⟨m, within⟩ => ⟨m, few_large_losses falls within⟩

/-- So, in Archimedean amounts, steps losing at least a given `ε` above nothing do not recur. -/
theorem approaches_rest (archimedean : M.Archimedean) {s d : Nat → A} {ε : A} {T : Nat}
    (falls : ∀ t, T ≤ t → M.le (M.add (s (t + 1)) (d t)) (s t))
    (positive : ¬ M.le ε M.zero) :
    ¬ ∀ N, ∃ t, N ≤ t ∧ M.le ε (d t) :=
  rests_of_archimedean archimedean positive (still_of_falls falls)
    (fun t later large => M.le_trans (add_le_add_left _ large) (falls t later))

end Amounts

/-! ## Whole-number amounts: the spine's case -/

/-- Whole-number amounts, the spine's. -/
def Amounts.whole : Amounts Nat where
  zero := 0
  add := (· + ·)
  le := (· ≤ ·)
  le_refl := Nat.le_refl
  le_trans := Nat.le_trans
  add_assoc := Nat.add_assoc
  add_comm := Nat.add_comm
  zero_add := Nat.zero_add
  add_le_add_right := fun c le => Nat.add_le_add_right le c
  le_of_add_le_add_right := fun _ le => Naturals.le_of_add_le_add_right le
  zero_le := Nat.zero_le

namespace Amounts

theorem whole_times_one : ∀ n, Amounts.whole.times n 1 = n
  | 0 => rfl
  | n + 1 => congrArg (· + 1) (whole_times_one n)

/-- In whole numbers every stock lies within its own count of least losses of one, plus one. -/
theorem whole_within (a : Nat) : ¬ Amounts.whole.le (Amounts.whole.times (a + 1) 1) a :=
  fun le => Nat.not_succ_le_self a (Eq.subst (motive := fun x => x ≤ a) (whole_times_one (a + 1)) le)

/-- Whole-number amounts are Archimedean. -/
theorem whole_archimedean : Amounts.whole.Archimedean :=
  fun a e positive =>
    have one : 1 ≤ e := Nat.pos_of_ne_zero fun zero => positive (Nat.le_of_eq zero)
    ⟨a + 1, fun le => whole_within a (Nat.le_trans (times_le (M := Amounts.whole) one (a + 1)) le)⟩


/-- In whole numbers the approach to rest is rest: from `T` on, no more steps lose anything than
the amount at `T` counts. -/
theorem whole_losing_steps {s d : Nat → Nat} {T : Nat}
    (falls : ∀ t, T ≤ t → s (t + 1) + d t ≤ s t) {f : Nat → Nat} (start : T ≤ f 0)
    (rising : ∀ i, f i < f (i + 1)) (k : Nat) (losing : ∀ i, i < k → 1 ≤ d (f i)) : k ≤ s T :=
  Eq.subst (motive := fun x => x ≤ s T) (whole_times_one k)
    (large_losses_within (M := Amounts.whole) (ε := 1) falls start rising k losing)

end Amounts

/-! ## Rest by balance, in whole numbers

The stretch balance of the prelude (`balance_over_stretch_on`) bounds how long a count can lose: a
count balanced across each step, what it gains against what it loses, that loses at least one more
than it gains at each step of a stretch falls across the stretch by at least its length
(`Amounts.falls_by_stretch`). So where whether a step is marked is decided, and the count loses at
least one more than it gains at each marked step, a step that is not marked comes within what stood
at the start (`Amounts.unmarked_within`): marked steps cannot outrun the count. And two balanced
counts compare by their exchanges alone (`Amounts.le_by_exchange`). These are the one law on which
the spine's courses end (`Optimum.ends_within`), its weighted draws compare
(`Optimum.Next.drawable_le_of_gains`), a law's run with a bounded mark comes to rest
(`LastChange.still_within`), and a regime's condition and a coupled web end and rest
(`RegimeMargin.Adjusted.ends_below`, `RegimeMargin.Coupled.Indexed.ends_after`,
`RegimeMargin.Coupled.Indexed.rests_by`); each was proved by its own induction before (board item
EC6, 23 October 2026). -/

namespace Amounts

/-- Over a stretch at each step of which `x` exceeds `y`, the total of `y` with one for each step is
within the total of `x`. -/
theorem total_steps_lose {x y : Nat → Nat} :
    ∀ S n, (∀ t, S ≤ t → t < S + n → y t + 1 ≤ x t) →
      total (steps S n) y + n ≤ total (steps S n) x
  | _, 0, _ => Nat.le_refl 0
  | S, n + 1, loses =>
    have rest : total (steps (S + 1) n) y + n ≤ total (steps (S + 1) n) x :=
      total_steps_lose (S + 1) n fun t from_ below =>
        loses t (Nat.le_of_succ_le from_)
          (Nat.lt_of_lt_of_le below (Nat.le_of_eq (Nat.add_right_comm S 1 n)))
    have first : y S + 1 ≤ x S :=
      loses S (Nat.le_refl S) (Nat.lt_add_of_pos_right (Nat.succ_pos n))
    Nat.le_trans
      (Nat.le_of_eq ((Nat.add_assoc (y S) (total (steps (S + 1) n) y) (n + 1)).trans
        ((congrArg (y S + ·) (Nat.add_comm 1 (total (steps (S + 1) n) y + n)).symm).trans
          (Nat.add_assoc (y S) 1 (total (steps (S + 1) n) y + n)).symm)))
      (Nat.add_le_add first rest)

/-- Over a stretch at each step of which `f` is at most `g`, the total of `f` is within the total of
`g`. -/
theorem total_steps_le {f g : Nat → Nat} :
    ∀ S n, (∀ t, S ≤ t → t < S + n → f t ≤ g t) → total (steps S n) f ≤ total (steps S n) g
  | _, 0, _ => Nat.le_refl 0
  | S, n + 1, le => Nat.add_le_add
      (le S (Nat.le_refl S) (Nat.lt_add_of_pos_right (Nat.succ_pos n)))
      (total_steps_le (S + 1) n fun t from_ below => le t (Nat.le_of_succ_le from_)
        (Nat.lt_of_lt_of_le below (Nat.le_of_eq (Nat.add_right_comm S 1 n))))

/-- The total over a stretch of two counts added is their totals added. -/
theorem total_steps_add (f g : Nat → Nat) :
    ∀ S n, total (steps S n) (fun t => f t + g t) = total (steps S n) f + total (steps S n) g
  | _, 0 => rfl
  | S, n + 1 => (congrArg (f S + g S + ·) (total_steps_add f g (S + 1) n)).trans
      (Nat.add_add_add_comm (f S) (g S) _ _)

/-- **Rest by balance.** A count balanced across each step of a stretch, what it gains against what
it loses, that at each step of the stretch loses at least one more than it gains, falls across the
stretch by at least its length: at the end, with the stretch's length, it is within what stood at
the start. The stretch balance is the reason: what stands at the end with everything lost is what
stood at the start with everything gained, and everything lost exceeds everything gained by at least
one for each step. -/
theorem falls_by_stretch {q x y : Nat → Nat} (S n : Nat)
    (across : ∀ t, S ≤ t → t < S + n → q (t + 1) + x t = q t + y t)
    (loses : ∀ t, S ≤ t → t < S + n → y t + 1 ≤ x t) :
    q (S + n) + n ≤ q S :=
  Naturals.le_of_add_le_add_right (k := total (steps S n) y)
    (Nat.le_trans
      (Nat.le_of_eq ((Nat.add_right_comm (q (S + n)) n (total (steps S n) y)).trans
        (Nat.add_assoc (q (S + n)) (total (steps S n) y) n)))
      (Nat.le_trans (Nat.add_le_add_left (total_steps_lose S n loses) (q (S + n)))
        (Nat.le_of_eq (balance_over_stretch_on S n across))))

/-- Whether each step of a stretch is marked being decided, either some step of it is unmarked or
every step of it is marked. -/
theorem unmarked_or_marked {P : Nat → Prop} (decide : ∀ t, P t ∨ ¬ P t) (S : Nat) :
    ∀ n, (∃ N, S ≤ N ∧ N < S + n ∧ ¬ P N) ∨ ∀ t, S ≤ t → t < S + n → P t
  | 0 => .inr fun _ from_ below => absurd (Nat.lt_of_le_of_lt from_ below) (Nat.lt_irrefl S)
  | n + 1 => match unmarked_or_marked decide S n with
    | .inl ⟨N, from_, below, unmarked⟩ =>
      .inl ⟨N, from_, Nat.lt_of_lt_of_le below (Nat.le_succ (S + n)), unmarked⟩
    | .inr marked => match decide (S + n) with
      | .inr unmarked => .inl ⟨S + n, Nat.le_add_right S n, Nat.lt_succ_self (S + n), unmarked⟩
      | .inl last => .inr fun t from_ below => match Nat.lt_or_ge t (S + n) with
        | .inl earlier => marked t from_ earlier
        | .inr late => Eq.subst (motive := P)
            (Nat.le_antisymm (Nat.le_of_lt_succ below) late).symm last

/-- **Rest by balance, decided.** Where whether a step is marked is decided, a count balanced across
each step from `S` on, losing at least one more than it gains at each marked step, has an unmarked
step from `S` on within what stood at `S`: the marked steps from `S` on cannot outrun the count. -/
theorem unmarked_within {q x y : Nat → Nat} {P : Nat → Prop} (decide : ∀ t, P t ∨ ¬ P t)
    (S : Nat) (across : ∀ t, S ≤ t → q (t + 1) + x t = q t + y t)
    (loses : ∀ t, S ≤ t → P t → y t + 1 ≤ x t) :
    ∃ N, S ≤ N ∧ N ≤ S + q S ∧ ¬ P N :=
  match unmarked_or_marked decide S (q S + 1) with
  | .inl ⟨N, from_, below, unmarked⟩ => ⟨N, from_, Nat.le_of_lt_succ below, unmarked⟩
  | .inr marked => absurd
      (falls_by_stretch (q := q) S (q S + 1) (fun t from_ _ => across t from_)
        fun t from_ below => loses t from_ (marked t from_ below))
      (Nat.not_le_of_gt (Nat.lt_of_lt_of_le (Nat.lt_succ_self (q S)) (Nat.le_add_left _ _)))

/-- **Balanced counts compare by their exchanges.** Two counts, each balanced across every step of a
stretch, the first starting within the second: where at each step the first's gain with the
second's loss is within the second's gain with the first's loss, the first ends the stretch within
the second. The two stretch balances are the reason, and nothing about the counts between. -/
theorem le_by_exchange {q x y q' x' y' : Nat → Nat} (S n : Nat)
    (across : ∀ t, S ≤ t → t < S + n → q (t + 1) + x t = q t + y t)
    (across' : ∀ t, S ≤ t → t < S + n → q' (t + 1) + x' t = q' t + y' t)
    (start : q S ≤ q' S)
    (exchange : ∀ t, S ≤ t → t < S + n → y t + x' t ≤ y' t + x t) :
    q (S + n) ≤ q' (S + n) :=
  have ex : total (steps S n) y + total (steps S n) x' ≤
      total (steps S n) y' + total (steps S n) x :=
    Nat.le_trans (Nat.le_of_eq (total_steps_add y x' S n).symm)
      (Nat.le_trans (total_steps_le S n exchange) (Nat.le_of_eq (total_steps_add y' x S n)))
  Naturals.le_of_add_le_add_right (k := total (steps S n) x + total (steps S n) x')
    (calc q (S + n) + (total (steps S n) x + total (steps S n) x')
        = q S + (total (steps S n) y + total (steps S n) x') :=
          (Nat.add_assoc _ _ _).symm.trans
            ((congrArg (· + total (steps S n) x') (balance_over_stretch_on S n across)).trans
              (Nat.add_assoc _ _ _))
      _ ≤ q S + (total (steps S n) y' + total (steps S n) x) := Nat.add_le_add_left ex _
      _ ≤ q' S + (total (steps S n) y' + total (steps S n) x) := Nat.add_le_add_right start _
      _ = q' (S + n) + (total (steps S n) x' + total (steps S n) x) :=
          (Nat.add_assoc _ _ _).symm.trans
            ((congrArg (· + total (steps S n) x) (balance_over_stretch_on S n across').symm).trans
              (Nat.add_assoc _ _ _))
      _ = q' (S + n) + (total (steps S n) x + total (steps S n) x') :=
          congrArg (q' (S + n) + ·) (Nat.add_comm _ _))

end Amounts

end Becoming
