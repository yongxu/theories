#!/usr/bin/env python3
"""EV6: state the joint count and gated renewal of Becoming.Continuation over a family of conditions read as one,
and derive the one-condition laws as the family of one condition (board rule 9); add the witness Coupled.
usage: python3 -B edit_continuation.py FILE   (edits FILE in place; each edit must match exactly once)"""
import sys
from pathlib import Path

p = Path(sys.argv[1])
text = p.read_text()


def once(old, new):
    global text
    assert text.count(old) == 1, ('edit does not match once', old[:100], text.count(old))
    text = text.replace(old, new)


# --- the joint count over a family ---
once('''/-- With balance at the condition across the step, a step of joint excess lowers the level
by at least one. -/
theorem excess_lowers_at {t : Nat} {c : C} (balances : L.BalancesOn W [c] t)
    (excess : L.given t c < L.taken t c) : W.level (t + 1) c + 1 ≤ W.level t c :=
  le_of_add_le_add_right (L.given t c)
    (Nat.le_trans
      (Nat.le_of_eq ((Nat.add_assoc _ 1 _).trans
        (congrArg (W.level (t + 1) c + ·) (Nat.add_comm 1 (L.given t c)))))
      (Nat.le_trans
        (Nat.add_le_add_left (show L.given t c + 1 ≤ L.taken t c from excess) _)
        (Nat.le_of_eq (balances c (.head [])))))
''', '''/-- With balance on a family across the step, a step at which the family's uptake exceeds its
replenishment lowers the family's stock by at least one: joint excess of the family read as
one. -/
theorem family_excess_lowers_at {t : Nat} {ds : List C} (balances : L.BalancesOn W ds t)
    (excess : L.replenishment ds t < L.uptake ds t) : W.stock ds (t + 1) + 1 ≤ W.stock ds t :=
  le_of_add_le_add_right (L.replenishment ds t)
    (Nat.le_trans
      (Nat.le_of_eq ((Nat.add_assoc _ 1 _).trans
        (congrArg (W.stock ds (t + 1) + ·) (Nat.add_comm 1 (L.replenishment ds t)))))
      (Nat.le_trans
        (Nat.add_le_add_left (show L.replenishment ds t + 1 ≤ L.uptake ds t from excess) _)
        (Nat.le_of_eq balances.over)))

/-- With balance at the condition across the step, a step of joint excess lowers the level
by at least one: the family of one condition. -/
theorem excess_lowers_at {t : Nat} {c : C} (balances : L.BalancesOn W [c] t)
    (excess : L.given t c < L.taken t c) : W.level (t + 1) c + 1 ≤ W.level t c :=
  family_excess_lowers_at balances excess
''')

once('''/-- With balance at the condition across each of the `n` steps, `n` consecutive steps of
joint excess lower the level by at least `n`. -/
theorem excess_bounded_at {c : C} {T : Nat} :
    ∀ n, (∀ k, k < n → L.BalancesOn W [c] (T + k)) →
      (∀ k, k < n → L.given (T + k) c < L.taken (T + k) c) →
      W.level (T + n) c + n ≤ W.level T c
  | 0, _, _ => Nat.le_refl _
  | n + 1, balances, excess =>
    Nat.le_trans (Nat.le_of_eq (Nat.add_right_comm (W.level (T + n + 1) c) n 1))
      (Nat.le_trans
        (Nat.add_le_add_right (excess_lowers_at (balances n (Nat.lt_succ_self n))
          (excess n (Nat.lt_succ_self n))) n)
        (excess_bounded_at n (fun k below => balances k (Nat.lt_succ_of_lt below))
          fun k below => excess k (Nat.lt_succ_of_lt below)))
''', '''/-- With balance on a family across each of the `n` steps, `n` consecutive steps of excess of
the family's uptake over its replenishment lower its stock by at least `n`. -/
theorem family_excess_bounded_at {ds : List C} {T : Nat} :
    ∀ n, (∀ k, k < n → L.BalancesOn W ds (T + k)) →
      (∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k)) →
      W.stock ds (T + n) + n ≤ W.stock ds T
  | 0, _, _ => Nat.le_refl _
  | n + 1, balances, excess =>
    Nat.le_trans (Nat.le_of_eq (Nat.add_right_comm (W.stock ds (T + n + 1)) n 1))
      (Nat.le_trans
        (Nat.add_le_add_right (family_excess_lowers_at (balances n (Nat.lt_succ_self n))
          (excess n (Nat.lt_succ_self n))) n)
        (family_excess_bounded_at n (fun k below => balances k (Nat.lt_succ_of_lt below))
          fun k below => excess k (Nat.lt_succ_of_lt below)))

/-- Excess of a family cannot last: over `n` consecutive steps of excess of the family's
uptake over its replenishment from `T`, its stock falls by at least `n`. -/
theorem family_excess_bounded (balances : L.Balances W) {ds : List C} {T : Nat} :
    ∀ n, (∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k)) →
      W.stock ds (T + n) + n ≤ W.stock ds T :=
  fun n => family_excess_bounded_at n fun k _ => balances.on ds (T + k)

/-- With balance at the condition across each of the `n` steps, `n` consecutive steps of
joint excess lower the level by at least `n`: the family of one condition. -/
theorem excess_bounded_at {c : C} {T : Nat} (n : Nat)
    (balances : ∀ k, k < n → L.BalancesOn W [c] (T + k))
    (excess : ∀ k, k < n → L.given (T + k) c < L.taken (T + k) c) :
    W.level (T + n) c + n ≤ W.level T c :=
  family_excess_bounded_at n balances excess
''')

# --- gated renewal over a family ---
once('''section Gated

variable {L : Flow F C} {W : Web F C}

/-- Once below `m`, below `m` over the next `n` steps, where across each of them the
condition is balanced on and whatever gives to it depends on it at a need of at least `m`
and is supported. -/
theorem stays_below_at {c : C} {m T : Nat} (below : W.level T c < m) :
    ∀ n, (∀ k, k < n → L.BalancesOn W [c] (T + k)) →
      (∀ k f, k < n → f ∈ L.present (T + k) → 0 < L.give (T + k) f c →
        W.requires (T + k) f c ∧ m ≤ W.need (T + k) f c) →
      (∀ k, k < n → L.GiversSupported W (T + k) c) →
      W.level (T + n) c < m
  | 0, _, _, _ => below
  | n + 1, balances, gated, givers =>
    have before := stays_below_at below n (fun k lt => balances k (Nat.lt_succ_of_lt lt))
      (fun k f lt => gated k f (Nat.lt_succ_of_lt lt))
      fun k lt => givers k (Nat.lt_succ_of_lt lt)
    have none : L.given (T + n) c = 0 := total_eq_zero fun f present =>
      eq_zero_of_not_pos fun gives => match gated n f (Nat.lt_succ_self n) present gives with
        | ⟨depends, high⟩ =>
          Nat.lt_irrefl m (Nat.lt_of_le_of_lt (Nat.le_trans high
            (givers n (Nat.lt_succ_self n) f present gives c depends)) before)
    Nat.lt_of_le_of_lt
      (Nat.le_trans (Nat.le_add_right _ (L.taken (T + n) c))
        (Nat.le_of_eq (((balances n (Nat.lt_succ_self n)) c (.head [])).trans
          (congrArg (W.level (T + n) c + ·) none))))
      before
''', '''section Gated

variable {L : Flow F C} {W : Web F C}

/-- What holds of a condition holds of every member of the family of that condition alone. -/
theorem of_single {P : C → Prop} {c : C} (holds : P c) : ∀ d, d ∈ [c] → P d
  | _, .head _ => holds
  | _, .tail _ no => nomatch no

/-- A gate on one condition is the coupled gate on the family of that condition alone: a giver
to a member depends on some member at a need of at least `m`. -/
theorem gate_single {t m : Nat} {f : F} {c : C}
    (gate : 0 < L.give t f c → W.requires t f c ∧ m ≤ W.need t f c) :
    ∀ d, d ∈ [c] → 0 < L.give t f d → ∃ e, e ∈ [c] ∧ W.requires t f e ∧ m ≤ W.need t f e :=
  of_single (P := fun d => 0 < L.give t f d → ∃ e, e ∈ [c] ∧ W.requires t f e ∧ m ≤ W.need t f e)
    fun gives => ⟨c, .head [], gate gives⟩

/-- Once a family's stock is below `m`, below `m` over the next `n` steps, where across each of
them the family is balanced on, whatever gives to a member of it depends on some member at a
need of at least `m` (the coupled gate), and whatever gives to a member is supported. A giver's
need is at most the level of the member it depends on, which is at most the stock. -/
theorem family_stays_below_at {ds : List C} {m T : Nat} (below : W.stock ds T < m) :
    ∀ n, (∀ k, k < n → L.BalancesOn W ds (T + k)) →
      (∀ k f, k < n → f ∈ L.present (T + k) → ∀ d, d ∈ ds → 0 < L.give (T + k) f d →
        ∃ e, e ∈ ds ∧ W.requires (T + k) f e ∧ m ≤ W.need (T + k) f e) →
      (∀ k, k < n → ∀ d, d ∈ ds → L.GiversSupported W (T + k) d) →
      W.stock ds (T + n) < m
  | 0, _, _, _ => below
  | n + 1, balances, gated, givers =>
    have before := family_stays_below_at below n (fun k lt => balances k (Nat.lt_succ_of_lt lt))
      (fun k f lt => gated k f (Nat.lt_succ_of_lt lt))
      fun k lt => givers k (Nat.lt_succ_of_lt lt)
    have none : L.replenishment ds (T + n) = 0 := total_eq_zero fun d mem =>
      total_eq_zero fun f present => eq_zero_of_not_pos fun gives =>
        match gated n f (Nat.lt_succ_self n) present d mem gives with
        | ⟨e, inside, depends, high⟩ =>
          Nat.lt_irrefl m (Nat.lt_of_le_of_lt (Nat.le_trans high (Nat.le_trans
            (givers n (Nat.lt_succ_self n) d mem f present gives e depends)
            (le_total_of_mem (q := W.level (T + n)) inside))) before)
    Nat.lt_of_le_of_lt
      (Nat.le_trans (Nat.le_add_right _ (L.uptake ds (T + n)))
        (Nat.le_of_eq ((balances n (Nat.lt_succ_self n)).over.trans
          (congrArg (W.stock ds (T + n) + ·) none))))
      before

/-- Once below `m`, below `m` over the next `n` steps, where across each of them the
condition is balanced on and whatever gives to it depends on it at a need of at least `m`
and is supported: the family of one condition. -/
theorem stays_below_at {c : C} {m T : Nat} (below : W.level T c < m) (n : Nat)
    (balances : ∀ k, k < n → L.BalancesOn W [c] (T + k))
    (gated : ∀ k f, k < n → f ∈ L.present (T + k) → 0 < L.give (T + k) f c →
      W.requires (T + k) f c ∧ m ≤ W.need (T + k) f c)
    (givers : ∀ k, k < n → L.GiversSupported W (T + k) c) :
    W.level (T + n) c < m :=
  family_stays_below_at (ds := [c]) below n balances
    (fun k f lt present => gate_single (gated k f lt present))
    fun k lt => of_single (givers k lt)
''')

once('''/-- At one step, a formation depending on a condition below its need is not active there,
where it is active only while supported. -/
theorem ends_below_at {c : C} {m t : Nat} {g : F}
    (dependent : W.active t g → W.Supported t g) (below : W.level t c < m)
    (depends : W.requires t g c) (high : m ≤ W.need t g c) : ¬ W.active t g :=
  fun active => Nat.lt_irrefl m (Nat.lt_of_le_of_lt
    (Nat.le_trans high (dependent active c depends)) below)
''', '''/-- At one step, a formation depending, at a need of at least `m`, on a member of a family whose
stock is below `m` is not active there, where it is active only while supported. -/
theorem family_ends_below_at {ds : List C} {m t : Nat} {g : F} {e : C}
    (dependent : W.active t g → W.Supported t g) (below : W.stock ds t < m) (inside : e ∈ ds)
    (depends : W.requires t g e) (high : m ≤ W.need t g e) : ¬ W.active t g :=
  fun active => Nat.lt_irrefl m (Nat.lt_of_le_of_lt (Nat.le_trans high
    (Nat.le_trans (dependent active e depends) (le_total_of_mem (q := W.level t) inside))) below)

/-- At one step, a formation depending on a condition below its need is not active there,
where it is active only while supported: the family of one condition. -/
theorem ends_below_at {c : C} {m t : Nat} {g : F}
    (dependent : W.active t g → W.Supported t g) (below : W.level t c < m)
    (depends : W.requires t g c) (high : m ≤ W.need t g c) : ¬ W.active t g :=
  family_ends_below_at (ds := [c]) dependent below (.head []) depends high
''')

once('''/-- Joint excess ends gated renewal, at the steps it uses: with balance at the condition
across the first `n + k` steps from `T`, whatever gives to it there depending on it at a need
of at least `m` and supported, `n` steps of joint excess from `T` starting below `n + m`
leave a formation depending on it at a need of at least `m` inactive at step `T + n + k`,
where it is active only while supported. -/
theorem joint_excess_ends_at {c : C} {m T n k : Nat} {g : F}
    (balances : ∀ j, j < n + k → L.BalancesOn W [c] (T + j))
    (gated : ∀ j f, j < n + k → f ∈ L.present (T + j) → 0 < L.give (T + j) f c →
      W.requires (T + j) f c ∧ m ≤ W.need (T + j) f c)
    (givers : ∀ j, j < n + k → L.GiversSupported W (T + j) c)
    (excess : ∀ j, j < n → L.given (T + j) c < L.taken (T + j) c)
    (start : W.level T c < n + m)
    (dependent : W.active (T + n + k) g → W.Supported (T + n + k) g) :
    W.requires (T + n + k) g c → m ≤ W.need (T + n + k) g c → ¬ W.active (T + n + k) g :=
  have early : ∀ j, j < n → j < n + k := fun _ below => Nat.lt_of_lt_of_le below (Nat.le_add_right n k)
  have shift : ∀ j, j < k → n + j < n + k := fun _ below => Nat.add_lt_add_left below n
  have low : W.level (T + n) c < m := Nat.lt_of_add_lt_add_left (n := n)
    (Nat.lt_of_le_of_lt
      (Nat.le_trans (Nat.le_of_eq (Nat.add_comm n _))
        (excess_bounded_at n (fun j below => balances j (early j below)) excess))
      start)
  ends_below_at dependent (stays_below_at (T := T + n) low k
    (fun j below => Eq.subst (motive := fun s => L.BalancesOn W [c] s) (Nat.add_assoc T n j).symm
      (balances (n + j) (shift j below)))
    (fun j f below => Eq.subst (motive := fun s => f ∈ L.present s → 0 < L.give s f c →
        W.requires s f c ∧ m ≤ W.need s f c) (Nat.add_assoc T n j).symm
      (gated (n + j) f (shift j below)))
    fun j below => Eq.subst (motive := fun s => L.GiversSupported W s c)
      (Nat.add_assoc T n j).symm (givers (n + j) (shift j below)))
''', '''/-- Excess of a family ends renewal gated on the family, at the steps it uses: with balance on
the family across the first `n + k` steps from `T`, whatever gives to a member there depending
on some member at a need of at least `m` (the coupled gate) and supported, `n` steps of excess of
the family's uptake over its replenishment from `T`, starting from a stock below `n + m`, leave a
formation depending on any member at a need of at least `m` inactive at step `T + n + k`, where
it is active only while supported. -/
theorem family_excess_ends_at {ds : List C} {m T n k : Nat} {g : F} {e : C}
    (balances : ∀ j, j < n + k → L.BalancesOn W ds (T + j))
    (gated : ∀ j f, j < n + k → f ∈ L.present (T + j) → ∀ d, d ∈ ds → 0 < L.give (T + j) f d →
      ∃ e, e ∈ ds ∧ W.requires (T + j) f e ∧ m ≤ W.need (T + j) f e)
    (givers : ∀ j, j < n + k → ∀ d, d ∈ ds → L.GiversSupported W (T + j) d)
    (excess : ∀ j, j < n → L.replenishment ds (T + j) < L.uptake ds (T + j))
    (start : W.stock ds T < n + m)
    (dependent : W.active (T + n + k) g → W.Supported (T + n + k) g) (inside : e ∈ ds) :
    W.requires (T + n + k) g e → m ≤ W.need (T + n + k) g e → ¬ W.active (T + n + k) g :=
  have early : ∀ j, j < n → j < n + k := fun _ below => Nat.lt_of_lt_of_le below (Nat.le_add_right n k)
  have shift : ∀ j, j < k → n + j < n + k := fun _ below => Nat.add_lt_add_left below n
  have low : W.stock ds (T + n) < m := Nat.lt_of_add_lt_add_left (n := n)
    (Nat.lt_of_le_of_lt
      (Nat.le_trans (Nat.le_of_eq (Nat.add_comm n _))
        (family_excess_bounded_at n (fun j below => balances j (early j below)) excess))
      start)
  family_ends_below_at dependent (family_stays_below_at (T := T + n) low k
    (fun j below => Eq.subst (motive := fun s => L.BalancesOn W ds s) (Nat.add_assoc T n j).symm
      (balances (n + j) (shift j below)))
    (fun j f below => Eq.subst (motive := fun s => f ∈ L.present s → ∀ d, d ∈ ds →
        0 < L.give s f d → ∃ e, e ∈ ds ∧ W.requires s f e ∧ m ≤ W.need s f e)
      (Nat.add_assoc T n j).symm (gated (n + j) f (shift j below)))
    fun j below => Eq.subst (motive := fun s => ∀ d, d ∈ ds → L.GiversSupported W s d)
      (Nat.add_assoc T n j).symm (givers (n + j) (shift j below))) inside

/-- Joint excess ends gated renewal, at the steps it uses: with balance at the condition
across the first `n + k` steps from `T`, whatever gives to it there depending on it at a need
of at least `m` and supported, `n` steps of joint excess from `T` starting below `n + m`
leave a formation depending on it at a need of at least `m` inactive at step `T + n + k`,
where it is active only while supported: the family of one condition. -/
theorem joint_excess_ends_at {c : C} {m T n k : Nat} {g : F}
    (balances : ∀ j, j < n + k → L.BalancesOn W [c] (T + j))
    (gated : ∀ j f, j < n + k → f ∈ L.present (T + j) → 0 < L.give (T + j) f c →
      W.requires (T + j) f c ∧ m ≤ W.need (T + j) f c)
    (givers : ∀ j, j < n + k → L.GiversSupported W (T + j) c)
    (excess : ∀ j, j < n → L.given (T + j) c < L.taken (T + j) c)
    (start : W.level T c < n + m)
    (dependent : W.active (T + n + k) g → W.Supported (T + n + k) g) :
    W.requires (T + n + k) g c → m ≤ W.need (T + n + k) g c → ¬ W.active (T + n + k) g :=
  family_excess_ends_at (ds := [c]) balances
    (fun j f below present => gate_single (gated j f below present))
    (fun j below => of_single (givers j below)) excess start dependent (.head [])
''')

once('''    excess start (dependent (T + n + k) g)

end Gated
''', '''    excess start (dependent (T + n + k) g)

/-- Excess of a family ends renewal gated on the family: where every formation giving to a
member of the family depends on some member at a need of at least `m` (the coupled gate), only
active formations give and activity needs support, `n` consecutive steps of excess of the
family's uptake over its replenishment from `T`, starting from a stock below `n + m`, leave the
stock below `m` from `T + n` on, nothing gives to any member again, and every formation
depending on any member at a need of at least `m` is inactive from then on. The members need
not run into excess one by one: a member read alone can be renewed within what is taken from it
while its renewer draws the family down through another member. -/
theorem family_excess_ends (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) {ds : List C} {m : Nat}
    (gated : ∀ t f, f ∈ L.present t → ∀ d, d ∈ ds → 0 < L.give t f d →
      ∃ e, e ∈ ds ∧ W.requires t f e ∧ m ≤ W.need t f e)
    {T n : Nat} (excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k))
    (start : W.stock ds T < n + m) :
    ∀ k g e, e ∈ ds → W.requires (T + n + k) g e → m ≤ W.need (T + n + k) g e →
      ¬ W.active (T + n + k) g :=
  fun k g _ inside => family_excess_ends_at (fun j _ => balances.on ds (T + j))
    (fun j f _ => gated (T + j) f) (fun j _ d _ => acting.giversSupported dependent (T + j) d)
    excess start (dependent (T + n + k) g) inside

end Gated
''')

# --- the witness: a patch renewed by a neighbour's formation ---
once('''namespace Alone
''', '''namespace Coupled

/-- A patch and its neighbour. -/
inductive Condition where
  | patch
  | neighbour

/-- A taker on the patch and a renewer of it drawing on the neighbour. -/
inductive Formation where
  | taker
  | renewer

open Condition Formation

/-- The two read as one. -/
def pair : List Condition := [patch, neighbour]

/-- Both take part across the first two steps, the taker alone across the third, then
neither. -/
def present : Nat → List Formation
  | 0 => [taker, renewer]
  | 1 => [taker, renewer]
  | 2 => [taker]
  | _ + 3 => []

/-- The taker takes one unit from the patch; the renewer takes one unit from the neighbour and
gives one to the patch. -/
def flow : Flow Formation Condition where
  present := present
  take _ f c := match f, c with
    | taker, patch => 1
    | taker, neighbour => 0
    | renewer, patch => 0
    | renewer, neighbour => 1
  give _ f c := match f, c with
    | taker, patch => 0
    | taker, neighbour => 0
    | renewer, patch => 1
    | renewer, neighbour => 0

/-- The patch stands at one while renewed and while the taker last takes, the neighbour at two,
then one; the taker depends on the patch and the renewer on the neighbour, each at need one;
the taker is active over three steps, the renewer over two. -/
def web : Web Formation Condition where
  level t c := match c with
    | patch => Witnesses.profile [1, 1, 1] 0 t
    | neighbour => Witnesses.profile [2, 1] 0 t
  active t f := match f with
    | taker => Witnesses.profile [True, True, True] False t
    | renewer => Witnesses.profile [True, True] False t
  requires _ f c := match f, c with
    | taker, patch => True
    | taker, neighbour => False
    | renewer, patch => False
    | renewer, neighbour => True
  need _ _ _ := 1
  draws _ f c := match f, c with
    | taker, patch => True
    | taker, neighbour => False
    | renewer, patch => False
    | renewer, neighbour => True

theorem balances : flow.Balances web
  | 0, patch => rfl
  | 0, neighbour => rfl
  | 1, patch => rfl
  | 1, neighbour => rfl
  | 2, patch => rfl
  | 2, neighbour => rfl
  | _ + 3, patch => rfl
  | _ + 3, neighbour => rfl

theorem acting : flow.Acting web
  | 0, taker, _, _, _ => trivial
  | 0, renewer, _, _, _ => trivial
  | 1, taker, _, _, _ => trivial
  | 1, renewer, _, _, _ => trivial
  | 2, taker, _, _, _ => trivial
  | 2, renewer, _, no, _ => nomatch no
  | _ + 3, _, _, no, _ => nomatch no

theorem dependent : web.Dependent
  | 0, taker, _, patch, _ => Nat.le_refl 1
  | 0, taker, _, neighbour, no => nomatch no
  | 0, renewer, _, patch, no => nomatch no
  | 0, renewer, _, neighbour, _ => Nat.le_succ 1
  | 1, taker, _, patch, _ => Nat.le_refl 1
  | 1, taker, _, neighbour, no => nomatch no
  | 1, renewer, _, patch, no => nomatch no
  | 1, renewer, _, neighbour, _ => Nat.le_refl 1
  | 2, taker, _, patch, _ => Nat.le_refl 1
  | 2, taker, _, neighbour, no => nomatch no
  | 2, renewer, dead, _, _ => nomatch dead
  | _ + 3, taker, dead, _, _ => nomatch dead
  | _ + 3, renewer, dead, _, _ => nomatch dead

/-- Read alone, the patch shows no joint excess while it is renewed: across the first two steps
the taker takes what the renewer gives. -/
theorem alone_within : ∀ t, t < 2 → flow.WithinJoint t patch
  | 0, _ => Nat.le_refl 1
  | 1, _ => Nat.le_refl 1
  | _ + 2, late => absurd late (Nat.not_lt_of_le (Nat.le_add_left 2 _))

/-- Nor is its renewal gated on it: the renewer gives to the patch without depending on it. -/
theorem alone_ungated : ¬ ∀ t f, f ∈ flow.present t → 0 < flow.give t f patch →
    web.requires t f patch ∧ 1 ≤ web.need t f patch :=
  fun gated => (gated 0 renewer (.tail _ (.head _)) Nat.zero_lt_one).1

/-- Read as one, the pair's renewal is gated on it: the one giver, the renewer, depends on the
neighbour. -/
theorem gated : ∀ t f, f ∈ flow.present t → ∀ d, d ∈ pair → 0 < flow.give t f d →
    ∃ e, e ∈ pair ∧ web.requires t f e ∧ 1 ≤ web.need t f e
  | _, renewer, _, patch, _, _ => ⟨neighbour, .tail _ (.head _), trivial, Nat.le_refl 1⟩
  | _, taker, _, patch, _, gives => absurd gives (Nat.lt_irrefl 0)
  | _, taker, _, neighbour, _, gives => absurd gives (Nat.lt_irrefl 0)
  | _, renewer, _, neighbour, _, gives => absurd gives (Nat.lt_irrefl 0)

/-- And the pair's uptake exceeds its replenishment at each of the three steps. -/
theorem excess : ∀ k, k < 3 → flow.replenishment pair (0 + k) < flow.uptake pair (0 + k)
  | 0, _ => Nat.lt_succ_self 1
  | 1, _ => Nat.lt_succ_self 1
  | 2, _ => Nat.zero_lt_one
  | _ + 3, late => absurd late (Nat.not_lt_of_le (Nat.le_add_left 3 _))

/-- So the excess of the pair read as one ends the renewal and both formations: from step three
on nothing is active. The stipulated activity says so; derived here through the law of renewal
gated on a family, the witness shows the law's hypotheses hold with that ending, where the law
of one condition read alone does not apply to the patch. -/
theorem all_end (k : Nat) : ∀ f, ¬ web.active (3 + k) f
  | taker => Flow.family_excess_ends balances acting dependent gated excess
      (show 1 + (2 + 0) < 3 + 1 from Nat.lt_succ_self 3) k taker patch (.head _) trivial
      (Nat.le_refl 1)
  | renewer => Flow.family_excess_ends balances acting dependent gated excess
      (show 1 + (2 + 0) < 3 + 1 from Nat.lt_succ_self 3) k renewer neighbour (.tail _ (.head _))
      trivial (Nat.le_refl 1)

end Coupled

namespace Alone
''')
p.write_text(text)
print('edited', p)

# --- the module doc ---
text = p.read_text()
once('''  Conversely a step of joint net giving raises the level by at least one (`net_give_raises_at`),''',
'''  The same count holds of a family of conditions read as one: a step at which the family's
  uptake exceeds its replenishment lowers its stock by at least one
  (`family_excess_lowers_at`), and `n` such steps lower it by at least `n`
  (`family_excess_bounded`); the laws of one condition are the family of that condition alone.
  Conversely a step of joint net giving raises the level by at least one (`net_give_raises_at`),''')
once('''  In `Exceeding` a renewer and two takers, each taking within what the step gives, all end
  after two steps (`Exceeding.all_end`); with one taker the same renewer keeps the level
  and all continue (`Alone.all_continue`).''',
'''  In `Exceeding` a renewer and two takers, each taking within what the step gives, all end
  after two steps (`Exceeding.all_end`); with one taker the same renewer keeps the level
  and all continue (`Alone.all_continue`).
* **Conditions coupled into one family.** The gate need not be on each condition: where
  whatever gives to a member of a family depends on some member at a need of at least `m`
  (the coupled gate), a stock below `m` stays below `m`, since a giver's need is at most the
  level of the member it depends on, which is at most the stock (`family_stays_below_at`);
  so `n` steps of excess of the family's uptake over its replenishment from a stock below
  `n + m` leave every formation depending on any member at a need of at least `m` inactive
  from then on (`family_excess_ends`). The laws of one condition (`stays_below_at`,
  `ends_below_at`, `joint_excess_ends_at`) are this law for the family of that condition
  alone. In `Coupled` a taker on a patch is renewed by a formation drawing on a neighbour:
  read alone, the patch shows no joint excess while it is renewed and its renewal is not
  gated on it, so the law of one condition does not apply to it (`Coupled.alone_within`,
  `Coupled.alone_ungated`); read as one, the pair's renewal is gated on it, its uptake
  exceeds its replenishment at every step, and both formations end (`Coupled.gated`,
  `Coupled.excess`, `Coupled.all_end`).''')
p.write_text(text)
print('doc edited', p)
