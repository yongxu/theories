import Becoming.Prelude
/-!
# Integers: the arithmetic of the core's integer models, constructively

The core's integer models (the amplitude and density numerators of `Becoming.Dephasing`, the
summaries of `Becoming.JointPhase`) need the ring laws of `Int`. Lean's prelude proves most of
them with `propext`, so the core cannot cite them. This module proves the ones those models use
with empty axiom reports.

* **Through difference pairs.** Every integer is read as a pair of naturals (`pair`), its
  positive and its negative part; two pairs are alike (`Same`) when they differ by the same
  amount. Alike pairs are pairs of equal integers (`eq_of_same`), alike pairs add to alike pairs
  (`Same.add`), and the pair of a sum, a difference of naturals and a negative are the sum, the
  difference and the swap of pairs (`pair_add`, `pair_subNatNat`, `pair_neg`). So associativity of
  addition, negation of a sum and the cancellation of a negative follow from the laws of
  naturals (`add_assoc`, `neg_add`, `add_right_neg`, `add_left_cancel`).
* **By cases.** Commutativity of addition and multiplication, the zero and sign laws of
  multiplication and doubling (`add_comm`, `mul_comm`, `zero_mul`, `mul_neg`, `neg_mul`,
  `neg_mul_neg`, `two_mul`).
* **Rearrangements** used by the models: `add_left_comm`, `add_right_comm`, `add_add_add_comm`.

No premise; every declaration has an empty axiom report.
-/

namespace Becoming

namespace Integers

/-! ## Naturals -/

/-- Where `n - m` is `0`, `m` is `n` and the rest. -/
theorem nat_sub_add_of_sub_zero : ∀ (m n : Nat), n - m = 0 → m - n + n = m
  | 0, n, gone => by
    have zero : n = 0 := (Nat.sub_zero n).symm.trans gone
    subst zero; rfl
  | _ + 1, 0, _ => rfl
  | m + 1, n + 1, gone =>
    have rest : m - n + n = m :=
      nat_sub_add_of_sub_zero m n ((Nat.succ_sub_succ n m).symm.trans gone)
    (Nat.succ_sub_succ m n).symm ▸ congrArg Nat.succ rest

/-- Where `n - m` is `k + 1`, `n` is `m` and `k + 1` more. -/
theorem nat_eq_add_of_sub_succ : ∀ (m n k : Nat), n - m = k + 1 → n = m + (k + 1)
  | 0, n, k, more => (Nat.sub_zero n ▸ more : n = k + 1).trans (Nat.zero_add (k + 1)).symm
  | _ + 1, 0, _, more => absurd ((Nat.zero_sub _).symm.trans more) (fun h => Nat.noConfusion h)
  | m + 1, n + 1, k, more =>
    have rest : n = m + (k + 1) :=
      nat_eq_add_of_sub_succ m n k ((Nat.succ_sub_succ n m).symm.trans more)
    (congrArg Nat.succ rest).trans (Nat.succ_add m (k + 1)).symm

/-- `a + b + (c + d) = a + d + (c + b)`. -/
theorem nat_rearrange (a b c d : Nat) : a + b + (c + d) = a + d + (c + b) := by
  rw [Nat.add_add_add_comm a b c d, Nat.add_add_add_comm a d c b, Nat.add_comm b d]

/-! ## Difference pairs -/

/-- An integer as its positive and negative part. -/
def pair : Int → Nat × Nat
  | .ofNat m => (m, 0)
  | .negSucc n => (0, n + 1)

/-- Two pairs differ by the same amount. -/
def Same (x y : Nat × Nat) : Prop := x.1 + y.2 = y.1 + x.2

/-- Componentwise sum of pairs. -/
def plus (x y : Nat × Nat) : Nat × Nat := (x.1 + y.1, x.2 + y.2)

/-- The swapped pair. -/
def swap (x : Nat × Nat) : Nat × Nat := (x.2, x.1)

theorem Same.refl (x : Nat × Nat) : Same x x := rfl

theorem Same.symm {x y : Nat × Nat} (same : Same x y) : Same y x := Eq.symm same

theorem Same.trans {x y z : Nat × Nat} (xy : Same x y) (yz : Same y z) : Same x z :=
  have both : x.1 + z.2 + (y.1 + y.2) = z.1 + x.2 + (y.1 + y.2) :=
    calc x.1 + z.2 + (y.1 + y.2) = x.1 + y.2 + (y.1 + z.2) := nat_rearrange _ _ _ _
      _ = y.1 + x.2 + (z.1 + y.2) := by rw [xy, yz]
      _ = z.1 + x.2 + (y.1 + y.2) := by
          rw [Nat.add_add_add_comm y.1 x.2 z.1 y.2, Nat.add_add_add_comm z.1 x.2 y.1 y.2,
            Nat.add_comm y.1 z.1]
  add_right_cancel _ both

theorem Same.add {x x' y y' : Nat × Nat} (xs : Same x x') (ys : Same y y') :
    Same (plus x y) (plus x' y') :=
  show x.1 + y.1 + (x'.2 + y'.2) = x'.1 + y'.1 + (x.2 + y.2) by
    rw [Nat.add_add_add_comm, xs, ys, Nat.add_add_add_comm]

theorem Same.swap {x y : Nat × Nat} (same : Same x y) : Same (swap x) (swap y) :=
  show x.2 + y.1 = y.2 + x.1 by rw [Nat.add_comm x.2, Nat.add_comm y.2]; exact Eq.symm same

theorem Same.of_eq {x y : Nat × Nat} (same : x = y) : Same x y := same ▸ Same.refl x

/-- **Alike pairs are pairs of equal integers.** -/
theorem eq_of_same : ∀ {a b : Int}, Same (pair a) (pair b) → a = b
  | .ofNat _, .ofNat _, same => congrArg Int.ofNat same
  | .ofNat _, .negSucc _, same => Nat.noConfusion same
  | .negSucc _, .ofNat _, same => Nat.noConfusion same
  | .negSucc m, .negSucc n, same =>
    congrArg Int.negSucc (Nat.succ.inj
      ((Nat.zero_add (n + 1)).symm.trans (Eq.trans same (Nat.zero_add (m + 1)))).symm)

/-- **The pair of a difference of naturals is alike the two naturals.** -/
theorem pair_subNatNat (m n : Nat) : Same (pair (Int.subNatNat m n)) (m, n) :=
  match d : n - m with
  | 0 =>
    (Int.subNatNat_of_sub_eq_zero d).symm ▸
      (show m - n + n = m + 0 from nat_sub_add_of_sub_zero m n d)
  | k + 1 =>
    (Int.subNatNat_of_sub_eq_succ d).symm ▸
      (show 0 + n = m + (k + 1) from (Nat.zero_add n).trans (nat_eq_add_of_sub_succ m n k d))

/-- **The pair of a sum is alike the sum of the pairs.** -/
theorem pair_add : ∀ a b : Int, Same (pair (a + b)) (plus (pair a) (pair b))
  | .ofNat _, .ofNat _ => rfl
  | .ofNat m, .negSucc n =>
    (pair_subNatNat m (n + 1)).trans (Same.of_eq (by
      show (m, n + 1) = (m + 0, 0 + (n + 1)); rw [Nat.zero_add]; rfl))
  | .negSucc m, .ofNat n =>
    (pair_subNatNat n (m + 1)).trans (Same.of_eq (by
      show (n, m + 1) = (0 + n, m + 1 + 0); rw [Nat.zero_add]))
  | .negSucc m, .negSucc n =>
    show 0 + (m + 1 + (n + 1)) = 0 + 0 + (Nat.succ (m + n) + 1) by
      rw [Nat.succ_add m (n + 1)]; exact rfl

/-- **The pair of a negative is the swapped pair.** -/
theorem pair_neg : ∀ a : Int, pair (-a) = swap (pair a)
  | .ofNat 0 => rfl
  | .ofNat (_ + 1) => rfl
  | .negSucc _ => rfl

/-! ## Laws of addition -/

theorem add_comm : ∀ a b : Int, a + b = b + a
  | .ofNat m, .ofNat n => congrArg Int.ofNat (Nat.add_comm m n)
  | .ofNat _, .negSucc _ => rfl
  | .negSucc _, .ofNat _ => rfl
  | .negSucc m, .negSucc n => congrArg (fun k => Int.negSucc (Nat.succ k)) (Nat.add_comm m n)

theorem add_assoc (a b c : Int) : a + b + c = a + (b + c) :=
  eq_of_same
    ((pair_add (a + b) c).trans
      (((pair_add a b).add (Same.refl (pair c))).trans
        ((Same.of_eq (show plus (plus (pair a) (pair b)) (pair c) =
            plus (pair a) (plus (pair b) (pair c)) by
          show ((pair a).1 + (pair b).1 + (pair c).1, (pair a).2 + (pair b).2 + (pair c).2) =
            ((pair a).1 + ((pair b).1 + (pair c).1), (pair a).2 + ((pair b).2 + (pair c).2))
          rw [Nat.add_assoc, Nat.add_assoc])).trans
          (((Same.refl (pair a)).add (pair_add b c).symm).trans (pair_add a (b + c)).symm))))

theorem add_zero (a : Int) : a + 0 = a := Int.add_zero a

theorem neg_add (a b : Int) : -(a + b) = -a + -b :=
  eq_of_same
    ((Same.of_eq (pair_neg (a + b))).trans
      ((pair_add a b).swap.trans
        ((Same.of_eq (show swap (plus (pair a) (pair b)) = plus (swap (pair a)) (swap (pair b))
            from rfl)).trans
          ((Same.of_eq (by rw [pair_neg a, pair_neg b])).trans (pair_add (-a) (-b)).symm))))

theorem add_right_neg (a : Int) : a + -a = 0 :=
  eq_of_same
    ((pair_add a (-a)).trans
      ((Same.of_eq (congrArg (plus (pair a)) (pair_neg a))).trans
        (show (pair a).1 + (pair a).2 + 0 = 0 + ((pair a).2 + (pair a).1) by
          rw [Nat.add_zero, Nat.zero_add, Nat.add_comm])))

theorem add_left_neg (a : Int) : -a + a = 0 := (add_comm (-a) a).trans (add_right_neg a)

theorem add_left_cancel {a b c : Int} (same : a + b = a + c) : b = c :=
  calc b = -a + a + b := by rw [add_left_neg, zero_add]
    _ = -a + (a + b) := add_assoc (-a) a b
    _ = -a + (a + c) := by rw [same]
    _ = -a + a + c := (add_assoc (-a) a c).symm
    _ = c := by rw [add_left_neg, zero_add]

theorem add_right_cancel {a b c : Int} (same : a + c = b + c) : a = b :=
  add_left_cancel ((add_comm c a).trans (same.trans (add_comm b c)))

theorem add_left_comm (a b c : Int) : a + (b + c) = b + (a + c) := by
  rw [← add_assoc, add_comm a b, add_assoc]

theorem add_right_comm (a b c : Int) : a + b + c = a + c + b := by
  rw [add_assoc, add_comm b c, ← add_assoc]

theorem add_add_add_comm (a b c d : Int) : a + b + (c + d) = a + c + (b + d) := by
  rw [add_assoc, add_left_comm b c d, ← add_assoc]

theorem sub_zero (a : Int) : a - 0 = a := Int.add_zero a

theorem neg_neg (a : Int) : - -a = a := Int.neg_neg a

/-! ## Laws of multiplication -/

theorem negOfNat_neg : ∀ n : Nat, -(Int.negOfNat n) = Int.ofNat n
  | 0 => rfl
  | _ + 1 => rfl

theorem mul_comm : ∀ a b : Int, a * b = b * a
  | .ofNat m, .ofNat n => congrArg Int.ofNat (Nat.mul_comm m n)
  | .ofNat m, .negSucc n => congrArg Int.negOfNat (Nat.mul_comm m (n + 1))
  | .negSucc m, .ofNat n => congrArg Int.negOfNat (Nat.mul_comm (m + 1) n)
  | .negSucc m, .negSucc n => congrArg Int.ofNat (Nat.mul_comm (m + 1) (n + 1))

theorem mul_zero (a : Int) : a * 0 = 0 := Int.mul_zero a

theorem mul_neg : ∀ a b : Int, a * -b = -(a * b)
  | a, .ofNat 0 => (mul_zero a).trans (congrArg Neg.neg (mul_zero a)).symm
  | .ofNat _, .ofNat (_ + 1) => rfl
  | .negSucc m, .ofNat (n + 1) => (negOfNat_neg ((m + 1) * (n + 1))).symm
  | .ofNat m, .negSucc n => (negOfNat_neg (m * (n + 1))).symm
  | .negSucc _, .negSucc _ => rfl

theorem neg_mul (a b : Int) : -a * b = -(a * b) := by
  rw [mul_comm (-a) b, mul_neg, mul_comm]

theorem neg_mul_neg (a b : Int) : -a * -b = a * b := by
  rw [neg_mul, mul_neg, neg_neg]

theorem two_mul (a : Int) : 2 * a = a + a :=
  match a with
  | .ofNat n => congrArg Int.ofNat (Nat.two_mul n)
  | .negSucc n =>
    show Int.negOfNat (2 * (n + 1)) = Int.negSucc (Nat.succ (n + n)) by
      rw [Nat.two_mul, Nat.add_succ, Nat.add_right_comm n 1 n]; rfl

end Integers

end Becoming
