/-!
# Prelude: numbers, truth values, lists and options

The lemmas on Lean's own types that the layers use, each stated once and each with an empty axiom
report; several of the prelude's own versions use `propext`. Nothing here reads a world, a frame
or a law: the module imports only Init, and every module of the core reaches it through
`Becoming.Frame`.

* **Natural numbers.** Cancellation, subtraction and the order (`add_right_cancel`,
  `add_sub_of_le`, `le_dest`, `exists_add_of_le`, `sub_eq_zero_of_le`, `add_sub_turn`), products
  (`mul_assoc_nat`, `mul_turn`, `add_mul_split`) and equality tests (`beq_self`) in the root
  namespace, and the lemmas of `Naturals`.
* **Truth values, lists and options** (`ListTests`): how `&&`, `||`, `!`, `==`, `all`, `any`,
  `contains`, `filter`, `map`, `flatMap`, `find?` and the operations on options evaluate, as
  statements about membership and truth.
* **Lists** in the root namespace: membership in a joined list and a cons
  (`mem_append_cases`, `mem_cons_cases`, `mem_append_of_left`, `mem_append_of_right`,
  `mem_middle`), the length and members of a mapped list (`length_map`, `preimage_of_mem_map`,
  `map_comp_eq`, `map_eq_of`, `map_eq_singleton`), and equal truth values (`bool_eq_of_iff`).
* **Balance over a stretch.** A count balanced across each step of a stretch, what it gains
  against what it loses, is balanced over the stretch (`balance_over_stretch_on`,
  `balance_over_stretch`), and the same with an inequality at each step (`le_over_stretch`,
  `ge_over_stretch`): the one stretch balance, of which a flow's levels, an amount's rises and falls,
  a course and what it draws, and a census's counts are cases (board item EC2).

Each statement here was proved in the modules that used it, often more than once; R31 (20 October
2026) states each once (the table and the copies it replaced are in the R31 kit,
`development/r31-support/dedup-table.json`).
-/

namespace Becoming

universe u v

/-! ## Natural numbers -/

/-- What is at least `a` is `a` and some more. -/
theorem le_dest {a b : Nat} (le : a ≤ b) : ∃ m, b = a + m := by
  induction le with
  | refl => exact ⟨0, rfl⟩
  | step _ earlier => exact match earlier with
    | ⟨m, same⟩ => ⟨m + 1, congrArg Nat.succ same⟩

/-- As `Nat.le_of_add_le_add_right`, with an empty axiom report. -/
theorem le_of_add_le_add_right : ∀ {a b : Nat} (k : Nat), a + k ≤ b + k → a ≤ b
  | _, _, 0, h => h
  | _, _, k + 1, h => le_of_add_le_add_right k (Nat.le_of_succ_le_succ h)

/-- As `Nat.add_right_cancel`, with an empty axiom report. -/
theorem add_right_cancel : ∀ {a b : Nat} (k : Nat), a + k = b + k → a = b
  | _, _, 0, h => h
  | _, _, k + 1, h => add_right_cancel k (Nat.succ.inj h)

/-- What each of two numbers has beyond the other, added to the other, gives the same. -/
theorem add_sub_turn : ∀ x y : Nat, y + (x - y) = x + (y - x)
  | 0, y => (congrArg (y + ·) (Nat.zero_sub y)).trans (Nat.zero_add y).symm
  | x + 1, 0 => (Nat.zero_add (x + 1)).trans (congrArg (x + 1 + ·) (Nat.zero_sub (x + 1))).symm
  | x + 1, y + 1 => (congrArg (y + 1 + ·) (Nat.succ_sub_succ x y)).trans
      ((Nat.add_right_comm y 1 (x - y)).trans ((congrArg (· + 1) (add_sub_turn x y)).trans
        ((Nat.add_right_comm x (y - x) 1).trans
          (congrArg (x + 1 + ·) (Nat.succ_sub_succ y x).symm))))

/-- The turn of `add_sub_turn`, with the same added on both sides. -/
theorem add_sub_turn_add (x y u : Nat) : y + (x - y + u) = x + (y - x + u) :=
  (Nat.add_assoc y (x - y) u).symm.trans ((congrArg (· + u) (add_sub_turn x y)).trans
    (Nat.add_assoc x (y - x) u))

/-- As `Nat.add_sub_of_le`, with an empty axiom report. -/
theorem add_sub_of_le : ∀ {m k : Nat}, m ≤ k → m + (k - m) = k
  | 0, k, _ => Nat.zero_add k
  | _ + 1, 0, le => absurd le (Nat.not_succ_le_zero _)
  | m + 1, k + 1, le => (congrArg (m + 1 + ·) (Nat.succ_sub_succ k m)).trans
      ((Nat.add_right_comm m 1 (k - m)).trans
        (congrArg (· + 1) (add_sub_of_le (Nat.le_of_succ_le_succ le))))

/-- As `Nat.sub_eq_zero_of_le`, with an empty axiom report. -/
theorem sub_eq_zero_of_le : ∀ {n m : Nat}, n ≤ m → n - m = 0
  | 0, m, _ => Nat.zero_sub m
  | _ + 1, 0, le => absurd le (Nat.not_succ_le_zero _)
  | n + 1, m + 1, le => (Nat.succ_sub_succ n m).trans (sub_eq_zero_of_le (Nat.le_of_succ_le_succ le))

/-- One more than a number, less it, is one. -/
theorem succ_sub_self : ∀ a : Nat, a + 1 - a = 1
  | 0 => rfl
  | a + 1 => (Nat.succ_sub_succ (a + 1) a).trans (succ_sub_self a)

/-- What is at least `c` is something more than `c`. -/
theorem exists_add_of_le : ∀ {c n : Nat}, c ≤ n → ∃ k, n = k + c
  | _, _, .refl => ⟨0, (Nat.zero_add _).symm⟩
  | _, _, .step le => match exists_add_of_le le with
    | ⟨k, sum⟩ => ⟨k + 1, (congrArg (· + 1) sum).trans (Nat.succ_add k _).symm⟩

/-- Multiplication of natural numbers associates, proved by recursion; the prelude's
`Nat.mul_assoc` uses `propext`. -/
theorem mul_assoc_nat : ∀ a b c : Nat, a * b * c = a * (b * c)
  | _, _, 0 => rfl
  | a, b, c + 1 => (Nat.mul_succ (a * b) c).trans ((congrArg (· + a * b) (mul_assoc_nat a b c)).trans
      ((Nat.mul_add a (b * c) b).symm.trans (congrArg (a * ·) (Nat.mul_succ b c).symm)))

theorem mul_turn (a b c : Nat) : a * (b * c) = b * (a * c) :=
  (mul_assoc_nat a b c).symm.trans ((congrArg (· * c) (Nat.mul_comm a b)).trans (mul_assoc_nat b a c))

theorem add_mul_split (a b : Nat) : ∀ c, (a + b) * c = a * c + b * c
  | 0 => rfl
  | c + 1 => (congrArg (· + (a + b)) (add_mul_split a b c)).trans (Nat.add_add_add_comm _ _ _ _)

theorem beq_self : ∀ n : Nat, Nat.beq n n = true
  | 0 => rfl
  | n + 1 => beq_self n

namespace Naturals

theorem succ_sub_succ (n m : Nat) : (n + 1) - (m + 1) = n - m := Nat.succ_sub_succ n m

theorem add_sub_cancel (a : Nat) : ∀ c : Nat, a + c - c = a
  | 0 => rfl
  | c + 1 => (succ_sub_succ (a + c) c).trans (add_sub_cancel a c)

theorem add_sub_cancel_left (c a : Nat) : c + a - c = a :=
  (congrArg (· - c) (Nat.add_comm c a)).trans (add_sub_cancel a c)

theorem sub_add_cancel : ∀ {a c : Nat}, c ≤ a → a - c + c = a
  | _, 0, _ => rfl
  | 0, _ + 1, h => absurd h (Nat.not_succ_le_zero _)
  | a + 1, c + 1, h =>
    (congrArg (· + (c + 1)) (succ_sub_succ a c)).trans
      (congrArg (· + 1) (sub_add_cancel (Nat.le_of_succ_le_succ h)))

theorem add_sub_of_le {a c : Nat} (h : c ≤ a) : c + (a - c) = a :=
  (Nat.add_comm c (a - c)).trans (sub_add_cancel h)

theorem sub_sub (n a : Nat) : ∀ b : Nat, n - a - b = n - (a + b)
  | 0 => rfl
  | b + 1 => congrArg Nat.pred (sub_sub n a b)

theorem le_of_add_le_left {a b c : Nat} (h : a + b ≤ c) : b ≤ c :=
  Nat.le_trans (Nat.le_add_left b a) h

theorem le_of_add_le_right {a b c : Nat} (h : a + b ≤ c) : a ≤ c :=
  Nat.le_trans (Nat.le_add_right a b) h

theorem add_right_cancel {a b : Nat} : ∀ {k : Nat}, a + k = b + k → a = b
  | 0, same => same
  | k + 1, same => add_right_cancel (k := k) (Nat.succ.inj same)

theorem add_left_cancel {a b k : Nat} (same : k + a = k + b) : a = b :=
  add_right_cancel ((Nat.add_comm a k).trans (same.trans (Nat.add_comm k b)))

theorem le_of_add_le_add_right {a b : Nat} : ∀ {k : Nat}, a + k ≤ b + k → a ≤ b
  | 0, h => h
  | k + 1, h => le_of_add_le_add_right (k := k) (Nat.le_of_succ_le_succ h)

theorem le_of_add_le_add_left {a b k : Nat} (h : k + a ≤ k + b) : a ≤ b :=
  le_of_add_le_add_right ((Nat.add_comm a k) ▸ (Nat.add_comm b k) ▸ h)

theorem le_sub_of_add_le {a b n : Nat} (h : a + b ≤ n) : b ≤ n - a :=
  le_of_add_le_add_left (k := a)
    (Nat.le_trans h (Nat.le_of_eq (add_sub_of_le (le_of_add_le_right h)).symm))

theorem add_le_of_le_sub {a b n : Nat} (within : a ≤ n) (h : b ≤ n - a) : a + b ≤ n :=
  Nat.le_trans (Nat.add_le_add_left h a) (Nat.le_of_eq (add_sub_of_le within))

/-- What is left after drawing, plus what was drawn, is what there was. -/
theorem sub_add_add {r d c : Nat} (within : c ≤ r) : r - c + (d + c) = r + d :=
  ((Nat.add_assoc (r - c) d c).symm.trans (Nat.add_right_comm (r - c) d c)).trans
    (congrArg (· + d) (sub_add_cancel within))

theorem lt_irrefl (n : Nat) : ¬ n < n := Nat.lt_irrefl n

theorem ne_of_lt {a b : Nat} (h : a < b) : a ≠ b := fun e => lt_irrefl b (e ▸ h)

theorem succ_ne_self (n : Nat) : n + 1 ≠ n := fun e => lt_irrefl n (Nat.lt_of_lt_of_le (Nat.lt_succ_self n) (Nat.le_of_eq e))

/-- No successor is zero (the prelude's `Nat.succ_ne_zero` depends on `propext`). -/
theorem succ_ne_zero (n : Nat) : n + 1 ≠ 0 :=
  fun same => Nat.noConfusion same

/-- Twice a number is the number added to itself. -/
theorem two_mul (n : Nat) : 2 * n = n + n :=
  (Nat.succ_mul 1 n).trans (congrArg (· + n) (Nat.one_mul n))

/-- A power of a sum of exponents is the product of the powers. -/
theorem pow_add (b x : Nat) : ∀ y, b ^ (x + y) = b ^ x * b ^ y
  | 0 => (Nat.mul_one _).symm
  | y + 1 => (congrArg (· * b) (pow_add b x y)).trans (mul_assoc_nat _ _ _)

/-- The last two factors of a product exchange. -/
theorem mul_right_comm (a b c : Nat) : a * b * c = a * c * b :=
  (mul_assoc_nat a b c).trans ((congrArg (a * ·) (Nat.mul_comm b c)).trans (mul_assoc_nat a c b).symm)

/-- The middle factors of two products exchange. -/
theorem mul_mul_mul_comm (a b c d : Nat) : a * b * (c * d) = a * c * (b * d) :=
  (mul_assoc_nat a b (c * d)).trans ((congrArg (a * ·) (mul_turn b c d)).trans
    (mul_assoc_nat a c (b * d)).symm)

/-- Two equal summands give equal sums. -/
theorem add_congr {a b c d : Nat} (ab : a = b) (cd : c = d) : a + c = b + d :=
  (congrArg (· + c) ab).trans (congrArg (b + ·) cd)

/-- Below a number, the test of being at most another fails. -/
theorem ble_false_of_lt : ∀ {a b : Nat}, b < a → Nat.ble a b = false
  | 0, _, lt => absurd lt (Nat.not_lt_zero _)
  | _ + 1, 0, _ => rfl
  | a + 1, b + 1, lt => @ble_false_of_lt a b (Nat.lt_of_succ_lt_succ lt)

end Naturals

/-! ## Truth values, lists and options -/

namespace ListTests

variable {α : Type u} {β : Type v}

/-! ## Truth values -/

theorem and_true_iff : ∀ {a b : Bool}, (a && b) = true ↔ a = true ∧ b = true
  | true, true => ⟨fun _ => ⟨rfl, rfl⟩, fun _ => rfl⟩
  | true, false => ⟨fun h => Bool.noConfusion h, fun h => Bool.noConfusion h.2⟩
  | false, _ => ⟨fun h => Bool.noConfusion h, fun h => Bool.noConfusion h.1⟩

theorem or_true_iff : ∀ {a b : Bool}, (a || b) = true ↔ a = true ∨ b = true
  | true, _ => ⟨fun _ => .inl rfl, fun _ => rfl⟩
  | false, true => ⟨fun _ => .inr rfl, fun _ => rfl⟩
  | false, false => ⟨fun h => Bool.noConfusion h,
      fun h => h.elim (fun e => Bool.noConfusion e) (fun e => Bool.noConfusion e)⟩

theorem not_true_iff : ∀ {a : Bool}, (!a) = true ↔ a = false
  | true => ⟨fun h => Bool.noConfusion h, fun h => Bool.noConfusion h⟩
  | false => ⟨fun _ => rfl, fun _ => rfl⟩

theorem false_iff_not : ∀ {b : Bool}, b = false ↔ ¬ b = true
  | true => ⟨fun e => Bool.noConfusion e, fun n => absurd rfl n⟩
  | false => ⟨fun _ e => Bool.noConfusion e, fun _ => rfl⟩

theorem and_left {a b : Bool} (h : (a && b) = true) : a = true := (and_true_iff.mp h).1

theorem and_right {a b : Bool} (h : (a && b) = true) : b = true := (and_true_iff.mp h).2

/-- A decided proposition is true exactly where it holds. -/
theorem decide_true_iff {p : Prop} [Decidable p] : decide p = true ↔ p :=
  ⟨of_decide_eq_true, decide_eq_true⟩

theorem beq_false_iff [DecidableEq α] {a b : α} : (a == b) = false ↔ a ≠ b :=
  false_iff_not.trans ⟨fun n e => n (ListTests.decide_true_iff.mpr e), fun n e => n (ListTests.decide_true_iff.mp e)⟩

/-! ## Membership -/

theorem mem_cons_iff {a b : α} {l : List α} : a ∈ b :: l ↔ a = b ∨ a ∈ l :=
  ⟨fun m => match m with
    | .head _ => .inl rfl
    | .tail _ m => .inr m,
   fun h => h.elim (fun e => e ▸ .head l) (fun m => .tail b m)⟩

theorem not_mem_nil {a : α} : ¬ a ∈ ([] : List α) := fun m => nomatch m

theorem mem_singleton_iff {a b : α} : a ∈ [b] ↔ a = b :=
  mem_cons_iff.trans ⟨fun h => h.elim id (fun m => absurd m not_mem_nil), .inl⟩

theorem mem_append_iff {a : α} : ∀ {l m : List α}, a ∈ l ++ m ↔ a ∈ l ∨ a ∈ m
  | [], _ => ⟨.inr, fun h => h.elim (fun m => absurd m not_mem_nil) id⟩
  | _ :: _, _ =>
    mem_cons_iff.trans (Iff.trans (or_congr Iff.rfl mem_append_iff)
      ⟨fun h => h.elim (fun e => .inl (mem_cons_iff.mpr (.inl e)))
          (fun h => h.elim (fun x => .inl (mem_cons_iff.mpr (.inr x))) .inr),
       fun h => h.elim (fun x => (mem_cons_iff.mp x).elim .inl (fun y => .inr (.inl y)))
          (fun y => .inr (.inr y))⟩)

/-! ## `all`, `any` and `contains` -/

theorem all_true_iff {p : α → Bool} : ∀ {l : List α}, l.all p = true ↔ ∀ x, x ∈ l → p x = true
  | [] => ⟨fun _ _ m => absurd m not_mem_nil, fun _ => rfl⟩
  | a :: l =>
    and_true_iff.trans ⟨fun ⟨pa, rest⟩ x m => (mem_cons_iff.mp m).elim (fun e => e ▸ pa)
        (fun m => all_true_iff.mp rest x m),
      fun all => ⟨all a (.head l), all_true_iff.mpr fun x m => all x (.tail a m)⟩⟩

theorem any_true_iff {p : α → Bool} : ∀ {l : List α}, l.any p = true ↔ ∃ x, x ∈ l ∧ p x = true
  | [] => ⟨fun h => Bool.noConfusion h, fun ⟨_, m, _⟩ => absurd m not_mem_nil⟩
  | a :: l =>
    or_true_iff.trans ⟨fun h => h.elim (fun pa => ⟨a, .head l, pa⟩)
        (fun rest => match any_true_iff.mp rest with | ⟨x, m, px⟩ => ⟨x, .tail a m, px⟩),
      fun ⟨x, m, px⟩ => (mem_cons_iff.mp m).elim (fun e => .inl (e ▸ px))
        (fun m => .inr (any_true_iff.mpr ⟨x, m, px⟩))⟩

theorem all_mem {p : α → Bool} {l : List α} (h : l.all p = true) {x : α} (m : x ∈ l) :
    p x = true := all_true_iff.mp h x m

theorem contains_true_iff [DecidableEq α] {a : α} : ∀ {l : List α}, l.contains a = true ↔ a ∈ l
  | [] => ⟨fun h => Bool.noConfusion h, fun m => absurd m not_mem_nil⟩
  | b :: l => by
    show (match a == b with | true => true | false => List.elem a l) = true ↔ a ∈ b :: l
    cases h : (a == b) with
    | true => exact ⟨fun _ => mem_cons_iff.mpr (.inl (ListTests.decide_true_iff.mp h)), fun _ => rfl⟩
    | false => exact ⟨fun e => .tail b (contains_true_iff.mp e),
        fun m => (mem_cons_iff.mp m).elim (fun e => absurd e (beq_false_iff.mp h))
          contains_true_iff.mpr⟩

theorem contains_false_iff [DecidableEq α] {a : α} {l : List α} :
    l.contains a = false ↔ ¬ a ∈ l :=
  false_iff_not.trans ⟨fun n m => n (contains_true_iff.mpr m), fun n e => n (contains_true_iff.mp e)⟩

theorem isEmpty_false_iff : ∀ {l : List α}, l.isEmpty = false ↔ l ≠ []
  | [] => ⟨fun h => Bool.noConfusion h, fun n => absurd rfl n⟩
  | _ :: _ => ⟨fun _ e => (nomatch e), fun _ => rfl⟩

theorem not_isEmpty_true_iff {l : List α} : (!l.isEmpty) = true ↔ l ≠ [] :=
  not_true_iff.trans isEmpty_false_iff

/-! ## `filter`, `map` and `flatMap` -/

theorem mem_filter_iff {p : α → Bool} {x : α} :
    ∀ {l : List α}, x ∈ l.filter p ↔ x ∈ l ∧ p x = true
  | [] => ⟨fun m => absurd m not_mem_nil, fun h => absurd h.1 not_mem_nil⟩
  | a :: l => by
    show x ∈ (match p a with | true => a :: l.filter p | false => l.filter p) ↔ _
    cases h : p a with
    | true => exact ⟨fun m => (mem_cons_iff.mp m).elim (fun e => ⟨e ▸ .head l, e ▸ h⟩)
          (fun m => ⟨.tail a (mem_filter_iff.mp m).1, (mem_filter_iff.mp m).2⟩),
        fun ⟨m, px⟩ => (mem_cons_iff.mp m).elim (fun e => e ▸ .head _)
          (fun m => .tail a (mem_filter_iff.mpr ⟨m, px⟩))⟩
    | false => exact ⟨fun m => ⟨.tail a (mem_filter_iff.mp m).1, (mem_filter_iff.mp m).2⟩,
        fun ⟨m, px⟩ => (mem_cons_iff.mp m).elim
          (fun e => Bool.noConfusion (h.symm.trans (e ▸ px)))
          (fun m => mem_filter_iff.mpr ⟨m, px⟩)⟩

/-- A filter every member of which passes keeps the list. -/
theorem filter_of_all {p : α → Bool} : ∀ {l : List α}, (∀ x, x ∈ l → p x = true) → l.filter p = l
  | [], _ => rfl
  | a :: l, all => by
    show (match p a with | true => a :: l.filter p | false => l.filter p) = a :: l
    rw [all a (.head l)]
    exact congrArg (a :: ·) (filter_of_all fun x m => all x (.tail a m))

theorem mem_map_iff {f : α → β} {y : β} : ∀ {l : List α}, y ∈ l.map f ↔ ∃ x, x ∈ l ∧ f x = y
  | [] => ⟨fun m => absurd m not_mem_nil, fun ⟨_, m, _⟩ => absurd m not_mem_nil⟩
  | a :: l => mem_cons_iff.trans ⟨fun h => h.elim (fun e => ⟨a, .head l, e.symm⟩)
      (fun m => match mem_map_iff.mp m with | ⟨x, m, e⟩ => ⟨x, .tail a m, e⟩),
    fun ⟨x, m, e⟩ => (mem_cons_iff.mp m).elim (fun same => .inl (e ▸ same ▸ rfl))
      (fun m => .inr (mem_map_iff.mpr ⟨x, m, e⟩))⟩

theorem mem_map_of {f : α → β} {x : α} {l : List α} (m : x ∈ l) : f x ∈ l.map f :=
  mem_map_iff.mpr ⟨x, m, rfl⟩

theorem mem_flatten_iff {y : β} : ∀ {ls : List (List β)}, y ∈ ls.flatten ↔ ∃ l, l ∈ ls ∧ y ∈ l
  | [] => ⟨fun m => absurd m not_mem_nil, fun ⟨_, m, _⟩ => absurd m not_mem_nil⟩
  | l :: ls => mem_append_iff.trans ⟨fun h => h.elim (fun m => ⟨l, .head ls, m⟩)
      (fun m => match mem_flatten_iff.mp m with | ⟨l', m', y'⟩ => ⟨l', .tail l m', y'⟩),
    fun ⟨l', m', y'⟩ => (mem_cons_iff.mp m').elim (fun e => .inl (e ▸ y'))
      (fun m' => .inr (mem_flatten_iff.mpr ⟨l', m', y'⟩))⟩

theorem mem_flatMap_iff {f : α → List β} {y : β} {l : List α} :
    y ∈ l.flatMap f ↔ ∃ x, x ∈ l ∧ y ∈ f x :=
  mem_flatten_iff.trans ⟨fun ⟨_, m, y'⟩ => match mem_map_iff.mp m with
      | ⟨x, mx, e⟩ => ⟨x, mx, e ▸ y'⟩,
    fun ⟨x, mx, y'⟩ => ⟨f x, mem_map_of mx, y'⟩⟩

theorem length_append : ∀ (l m : List α), (l ++ m).length = l.length + m.length
  | [], m => (Nat.zero_add m.length).symm
  | _ :: l, m => (congrArg (· + 1) (length_append l m)).trans (Nat.succ_add l.length m.length).symm

/-! ## `find?` -/

theorem find_some {p : α → Bool} : ∀ {l : List α} {a : α}, l.find? p = some a → p a = true
  | [], _, h => nomatch h
  | b :: l, _, h => by
    revert h
    show (match p b with | true => some b | false => l.find? p) = _ → _
    cases hb : p b with
    | true => exact fun h => (Option.some.inj h) ▸ hb
    | false => exact find_some

theorem mem_of_find_some {p : α → Bool} : ∀ {l : List α} {a : α}, l.find? p = some a → a ∈ l
  | [], _, h => nomatch h
  | b :: l, _, h => by
    revert h
    show (match p b with | true => some b | false => l.find? p) = _ → _
    cases p b with
    | true => exact fun h => (Option.some.inj h) ▸ .head l
    | false => exact fun h => .tail b (mem_of_find_some h)

theorem find_none_iff {p : α → Bool} : ∀ {l : List α}, l.find? p = none ↔ ∀ x, x ∈ l → p x = false
  | [] => ⟨fun _ _ m => absurd m not_mem_nil, fun _ => rfl⟩
  | b :: l => by
    show (match p b with | true => some b | false => l.find? p) = none ↔ _
    cases hb : p b with
    | true => exact ⟨fun h => (nomatch h), fun all => Bool.noConfusion (hb.symm.trans (all b (.head l)))⟩
    | false => exact ⟨fun h x m => (mem_cons_iff.mp m).elim (fun e => e ▸ hb)
          (fun m => find_none_iff.mp h x m),
        fun all => find_none_iff.mpr fun x m => all x (.tail b m)⟩

theorem find_isSome_iff {p : α → Bool} {l : List α} :
    (l.find? p).isSome = true ↔ ∃ x, x ∈ l ∧ p x = true :=
  match h : l.find? p with
  | some a => ⟨fun _ => ⟨a, mem_of_find_some h, find_some h⟩, fun _ => rfl⟩
  | none => ⟨fun e => Bool.noConfusion e, fun ⟨x, m, px⟩ =>
      Bool.noConfusion ((find_none_iff.mp h x m).symm.trans px)⟩

/-! ## Options -/

theorem bind_eq_some {γ δ : Type} {o : Option γ} {f : γ → Option δ} {b : δ} :
    (o >>= f) = some b ↔ ∃ a, o = some a ∧ f a = some b :=
  match o with
  | none => ⟨fun h => (nomatch h), fun ⟨_, h, _⟩ => nomatch h⟩
  | some a => ⟨fun h => ⟨a, rfl, h⟩, fun ⟨_, h, h'⟩ => (Option.some.inj h) ▸ h'⟩

theorem map_eq_some {f : α → β} {b : β} : ∀ {o : Option α}, o.map f = some b ↔ ∃ a, o = some a ∧ f a = b
  | none => ⟨fun h => (nomatch h), fun ⟨_, h, _⟩ => nomatch h⟩
  | some a => ⟨fun h => ⟨a, rfl, Option.some.inj h⟩,
      fun ⟨_, h, e⟩ => congrArg some ((Option.some.inj h) ▸ e)⟩

theorem option_any_true_iff {f : α → Bool} : ∀ {o : Option α}, o.any f = true ↔ ∃ a, o = some a ∧ f a = true
  | none => ⟨fun h => Bool.noConfusion h, fun ⟨_, h, _⟩ => nomatch h⟩
  | some a => ⟨fun h => ⟨a, rfl, h⟩, fun ⟨_, h, h'⟩ => (Option.some.inj h) ▸ h'⟩

theorem isSome_iff {o : Option α} : o.isSome = true ↔ ∃ a, o = some a :=
  match o with
  | some a => ⟨fun _ => ⟨a, rfl⟩, fun _ => rfl⟩
  | none => ⟨fun h => Bool.noConfusion h, fun ⟨_, h⟩ => nomatch h⟩

theorem none_ne_some {a : α} : (none : Option α) ≠ some a := fun e => nomatch e

/-! ## Negation, disjunction and the two truth values -/

/-- No truth value is its negation. -/
theorem not_ne_self : ∀ b : Bool, (!b) ≠ b
  | true => fun same => Bool.noConfusion same
  | false => fun same => Bool.noConfusion same

/-- No truth value is its negation, read the other way. -/
theorem ne_not : ∀ b : Bool, b ≠ !b
  | false => fun same => nomatch same
  | true => fun same => nomatch same

theorem not_not : ∀ b : Bool, (!!b) = b
  | false => rfl
  | true => rfl

theorem false_of_not : ∀ {b : Bool}, (!b) = true → b = false
  | false, _ => rfl
  | true, yes => Bool.noConfusion yes

theorem false_of_not_true : ∀ {b : Bool}, ¬ b = true → b = false
  | false, _ => rfl
  | true, no => absurd rfl no

theorem not_eq_true_of_false : ∀ {b : Bool}, b = false → (!b) = true
  | false, _ => rfl
  | true, no => Bool.noConfusion no

theorem or_cases : ∀ {a b : Bool}, (a || b) = true → a = true ∨ b = true
  | true, _, _ => .inl rfl
  | false, _, yes => .inr yes

theorem or_left : ∀ {a : Bool} (b : Bool), a = true → (a || b) = true
  | true, _, _ => rfl
  | false, _, no => nomatch no

theorem or_right : ∀ (a : Bool) {b : Bool}, b = true → (a || b) = true
  | true, _, _ => rfl
  | false, _, yes => yes

/-- Each truth value is listed in `[true, false]`. -/
theorem mem_bools : ∀ b : Bool, b ∈ [true, false]
  | true => .head _
  | false => .tail _ (.head _)

/-! ## Joining lists -/

theorem append_nil : ∀ l : List α, l ++ [] = l
  | [] => rfl
  | x :: xs => congrArg (x :: ·) (append_nil xs)

theorem append_assoc : ∀ l m n : List α, l ++ m ++ n = l ++ (m ++ n)
  | [], _, _ => rfl
  | a :: l, m, n => congrArg (List.cons a) (append_assoc l m n)

end ListTests

/-! ## Lists in the root namespace -/

section Lists

variable {α β γ : Type}

/-- Two Booleans true exactly together are equal. -/
theorem bool_eq_of_iff : ∀ {a b : Bool}, (a = true ↔ b = true) → a = b
  | true, true, _ => rfl
  | false, false, _ => rfl
  | true, false, same => Bool.noConfusion (same.mp rfl)
  | false, true, same => Bool.noConfusion (same.mpr rfl)

theorem bool_and_true {b c : Bool} (hb : b = true) (hc : c = true) : (b && c) = true := by
  subst hb
  subst hc
  rfl

theorem bool_of_and_true {b c : Bool} (both : (b && c) = true) : b = true ∧ c = true := by
  cases b <;> cases c <;> cases both <;> exact ⟨rfl, rfl⟩

theorem mem_cons_cases {a b : α} {q : List α} : b ∈ a :: q → b = a ∨ b ∈ q
  | .head _ => .inl rfl
  | .tail _ mem => .inr mem

/-- Membership in two lists joined is membership in one of them. -/
theorem mem_append_cases {a : α} : ∀ {l m : List α}, a ∈ l ++ m → a ∈ l ∨ a ∈ m
  | [], _, mem => .inr mem
  | b :: l, _, mem => match mem_cons_cases mem with
    | .inl same => .inl (Eq.subst (motive := fun x => x ∈ b :: l) same.symm (.head l))
    | .inr mem => match mem_append_cases mem with
      | .inl inside => .inl (.tail b inside)
      | .inr outside => .inr outside

theorem mem_append_of_left {α : Type} {a : α} : ∀ {l : List α} (m : List α), a ∈ l → a ∈ l ++ m
  | _ :: _, _, .head _ => .head _
  | _ :: _, m, .tail _ mem => .tail _ (mem_append_of_left m mem)

theorem mem_append_of_right {α : Type} {a : α} : ∀ (l : List α) {m : List α}, a ∈ m → a ∈ l ++ m
  | [], _, mem => mem
  | _ :: l, _, mem => .tail _ (mem_append_of_right l mem)

/-- `a` stands in the middle of a list. -/
theorem mem_middle {a : α} {q : List α} : ∀ p : List α, a ∈ p ++ a :: q
  | [] => .head q
  | x :: p => .tail x (mem_middle p)

theorem length_map (g : α → β) : ∀ l : List α, (l.map g).length = l.length
  | [] => rfl
  | _ :: l => congrArg Nat.succ (length_map g l)

theorem map_comp_eq (g : α → β) (h : β → γ) :
    ∀ l : List α, (l.map g).map h = l.map fun a => h (g a)
  | [] => rfl
  | a :: l => congrArg (h (g a) :: ·) (map_comp_eq g h l)

/-- Maps agreeing at every point agree on every list, with no function extensionality. -/
theorem map_eq_of {g h : α → β} (same : ∀ a, g a = h a) : ∀ l : List α, l.map g = l.map h
  | [] => rfl
  | a :: l => show g a :: l.map g = h a :: l.map h from
      congr (congrArg List.cons (same a)) (map_eq_of same l)

theorem map_eq_singleton {g : α → β} {b : β} :
    ∀ {l : List α}, l.map g = [b] → ∃ a, l = [a] ∧ g a = b
  | [], same => by cases same
  | [a], same => ⟨a, rfl, by injection same⟩
  | _ :: _ :: _, same => by injection same with _ rest; cases rest

/-- A member of a mapped list is the image of a member. -/
theorem preimage_of_mem_map {α β : Type} {g : α → β} {b : β} :
    ∀ {l : List α}, b ∈ l.map g → ∃ a, a ∈ l ∧ g a = b
  | a :: _, .head _ => ⟨a, .head _, rfl⟩
  | a :: _, .tail _ mem => match preimage_of_mem_map mem with
    | ⟨a', inner, same⟩ => ⟨a', .tail a inner, same⟩

end Lists

/-! ## Statements stated once (R32)

Each of these was stated, in the same words, in two or more modules of the run; it is stated here once, under the name kept. -/

namespace ChanceFloors

theorem or_true (b : Bool) : (b || true) = true := match b with | true => rfl | false => rfl

end ChanceFloors

/-- Cancelling the same number added first. -/
theorem le_of_add_le_add_left_core {S a b : Nat} (le : S + a ≤ S + b) : a ≤ b :=
  le_of_add_le_add_right S (Nat.le_trans (Nat.le_of_eq (Nat.add_comm a S))
    (Nat.le_trans le (Nat.le_of_eq (Nat.add_comm S b))))

namespace CrossSituational

theorem mem_singleton {m e : M} (mem : m ∈ [e]) : m = e := by
  cases mem with
  | head => rfl
  | tail _ rest => exact nomatch rest

end CrossSituational

theorem cond_le_one : ∀ b : Bool, cond b 1 0 ≤ 1 := by decide

theorem mem_appended_left {α : Type u} {a : α} :
    ∀ {l : List α} (l' : List α), a ∈ l → a ∈ l ++ l'
  | _ :: _, _, .head _ => .head _
  | _ :: _, l', .tail _ mem => .tail _ (mem_appended_left l' mem)

namespace Hexagram

theorem and_false_of_true : ∀ {x y : Bool}, (x && y) = false → x = true → y = false
  | true, false, _, _ => rfl
  | true, true, h, _ => Bool.noConfusion h
  | false, _, _, h => Bool.noConfusion h

end Hexagram

namespace Integers

theorem zero_add : ∀ a : Int, 0 + a = a
  | .ofNat n => congrArg Int.ofNat (Nat.zero_add n)
  | .negSucc n => Int.subNatNat_of_sub_eq_succ (Nat.sub_zero (n + 1))

theorem zero_mul : ∀ a : Int, 0 * a = 0
  | .ofNat n => congrArg Int.ofNat (Nat.zero_mul n)
  | .negSucc n => congrArg Int.negOfNat (Nat.zero_mul (n + 1))

end Integers

theorem mem_mapped {α : Type u} {β : Type v} (g : α → β) {a : α} :
    ∀ {l : List α}, a ∈ l → g a ∈ l.map g
  | _ :: _, .head _ => .head _
  | _ :: _, .tail _ mem => .tail _ (mem_mapped g mem)

namespace SupportGated

/-- What exceeds leaves a positive remainder. -/
theorem sub_pos_of_lt : ∀ {d c : Nat}, d < c → 0 < c - d
  | _, 0, less => absurd less (Nat.not_lt_zero _)
  | 0, c + 1, _ => Nat.succ_pos c
  | d + 1, c + 1, less => Nat.lt_of_lt_of_le (sub_pos_of_lt (Nat.lt_of_succ_lt_succ less))
      (Nat.le_of_eq (Nat.succ_sub_succ c d).symm)

end SupportGated

namespace TreeSearch

theorem append_nil {α : Type} : ∀ (a : List α), a ++ [] = a
  | [] => rfl
  | x :: a => congrArg (x :: ·) (append_nil a)

end TreeSearch

/-! ## Definitions stated once (R37)

Each of these was defined or proved with the same body in two or more core modules, or is a
definition that the statements stated once below name; it is stated here once, under the name kept
(twentieth review, B6). `Distinct` and `distinct_append` are stated in every universe, so that one
statement serves the copies stated for lists of any type. -/

section Once

variable {α : Type u} {β : Type v}

/-- A list in which no member occurs twice. -/
def Distinct : List α → Prop
  | [] => True
  | a :: as => ¬ a ∈ as ∧ Distinct as

/-- Two lists without repetition and with no member in common join without repetition. -/
theorem distinct_append : ∀ {l m : List α}, Distinct l → Distinct m →
    (∀ a, a ∈ l → ¬ a ∈ m) → Distinct (l ++ m)
  | [], _, _, distinct, _ => distinct
  | a :: l, _, ⟨fresh, distinctL⟩, distinctM, apart =>
    ⟨fun mem => match ListTests.mem_append_iff.mp mem with
      | .inl inside => fresh inside
      | .inr outside => apart a (.head l) outside,
     distinct_append distinctL distinctM fun b mem => apart b (.tail a mem)⟩

/-- Members of a list pairwise apart under a relation: no member is related to a later one. -/
def DistinctUnder (R : α → α → Prop) : List α → Prop
  | [] => True
  | x :: s => (∀ y, y ∈ s → ¬ R x y) ∧ DistinctUnder R s

namespace Copying

/-- The member at index `i`, if any. -/
def nth : List β → Nat → Option β
  | [], _ => none
  | x :: _, 0 => some x
  | _ :: xs, i + 1 => nth xs i

end Copying

namespace Law

/-- The member at index `i`, `d` past the end. -/
def memberAt (d : α) : List α → Nat → α
  | [], _ => d
  | x :: _, 0 => x
  | _ :: r, i + 1 => memberAt d r i

end Law

namespace Settling

/-- The sequence that starts with `a` and continues as `h`. -/
def consAct (a : α) (h : Nat → α) : Nat → α
  | 0 => a
  | k + 1 => h k

end Settling

end Once

/-- The total of a quantity over a finite list. -/
def total {α : Type} : List α → (α → Nat) → Nat
  | [], _ => 0
  | a :: as, q => q a + total as q

/-- The steps `T`, `T + 1`, …, `T + N - 1`. -/
def steps : Nat → Nat → List Nat
  | _, 0 => []
  | T, N + 1 => T :: steps (T + 1) N

/-- Whether a count is not zero. -/
def nonzero : Nat → Bool
  | 0 => false
  | _ + 1 => true

namespace Undecided

/-- The numbers below `n`, from `n - 1` down. -/
def upto : Nat → List Nat
  | 0 => []
  | n + 1 => n :: upto n

end Undecided

section OnceLists

variable {α β : Type}

/-- In a list without repetition, a member standing in the middle stands nowhere else. -/
theorem not_mem_of_middle {a : α} : ∀ {p q : List α}, Distinct (p ++ a :: q) → ¬ a ∈ p ++ q
  | [], _, ⟨fresh, _⟩, mem => fresh mem
  | _ :: p, q, ⟨fresh, distinct⟩, mem => match mem_cons_cases mem with
    | .inl ax => fresh (Eq.subst (motive := fun y => y ∈ p ++ a :: q) ax (mem_middle p))
    | .inr mem => not_mem_of_middle distinct mem

/-- Mapping a list one to one on its members keeps it without repetition. -/
theorem distinct_map_on {β : Type} {g : α → β} :
    ∀ {l : List α}, (∀ a b, a ∈ l → b ∈ l → g a = g b → a = b) → Distinct l →
      Distinct (l.map g)
  | [], _, _ => trivial
  | a :: l, inj, ⟨fresh, distinct⟩ =>
    ⟨fun mem => match preimage_of_mem_map mem with
      | ⟨b, listed, same⟩ => fresh (Eq.subst (motive := (· ∈ l))
          (inj b a (.tail a listed) (.head l) same) listed),
     distinct_map_on (fun x y first second => inj x y (.tail a first) (.tail a second))
       distinct⟩

end OnceLists

/-- Shifting a stretch of steps by one is shifting the quantity. -/
theorem total_steps_succ (q : Nat → Nat) :
    ∀ T n, total (steps (T + 1) n) q = total (steps T n) fun i => q (i + 1)
  | _, 0 => rfl
  | T, n + 1 => congrArg (q (T + 1) + ·) (total_steps_succ q (T + 1) n)

/-- The total over a stretch of `a + b` steps is the total over its first `a` steps with the
total over the `b` after them. -/
theorem total_steps_add (q : Nat → Nat) : ∀ (S a b : Nat),
    total (steps S (a + b)) q = total (steps S a) q + total (steps (S + a) b) q
  | S, 0, b => (congrArg (fun k => total (steps S k) q) (Nat.zero_add b)).trans
      (Nat.zero_add _).symm
  | S, a + 1, b =>
    (congrArg (fun k => total (steps S k) q) (Nat.succ_add a b)).trans
      ((congrArg (q S + ·) (total_steps_add q (S + 1) a b)).trans
        ((Nat.add_assoc _ _ _).symm.trans
          (congrArg (fun k => total (steps S (a + 1)) q + total (steps k b) q)
            (Nat.add_right_comm S 1 a))))

/-- A member of a stretch of steps lies between its ends. -/
theorem between_of_mem_steps : ∀ {T N j : Nat}, j ∈ steps T N → T ≤ j ∧ j < T + N
  | _, 0, _, mem => nomatch mem
  | T, N + 1, _, mem => match mem_cons_cases mem with
    | .inl same => ⟨Nat.le_of_eq same.symm,
        Eq.subst (motive := fun x => x < T + (N + 1)) same.symm
          (Nat.lt_add_of_pos_right (Nat.succ_pos N))⟩
    | .inr mem => match between_of_mem_steps mem with
      | ⟨le, lt⟩ => ⟨Nat.le_of_succ_le le,
          Nat.lt_of_lt_of_le lt (Nat.le_of_eq (Nat.add_right_comm T 1 N))⟩

/-! ## Balance over a stretch

A count balanced across each step, what it gains against what it loses, is balanced over any
stretch. This is the one stretch balance of the spine: the levels of a flow (`Flow.accumulates_on`,
`Regulation.accumulates_at`), an amount's rises and falls (`Change.over_stretch`), a course and what
it draws (`Optimum.level_add_drawn_of_within`) and the counts of a census are its cases. Moved
unchanged, with their names, from `Becoming.Change` and `Becoming.Population` (board item EC2,
21 October 2026). -/

/-- A count balanced across each step of a stretch, what it gains against what it loses, is
balanced over the stretch: at the end with everything lost, it is the count at the start with
everything gained. Nothing is asked of the steps outside the stretch. -/
theorem balance_over_stretch_on {q x y : Nat → Nat} :
    ∀ S n, (∀ t, S ≤ t → t < S + n → q (t + 1) + x t = q t + y t) →
      q (S + n) + total (steps S n) x = q S + total (steps S n) y
  | _, 0, _ => rfl
  | S, n + 1, across => calc
      q (S + (n + 1)) + (x S + total (steps (S + 1) n) x)
          = x S + (q (S + 1 + n) + total (steps (S + 1) n) x) :=
        (congrArg (· + _) (congrArg q (Nat.add_right_comm S 1 n).symm)).trans
          (Nat.add_left_comm _ _ _)
      _ = x S + (q (S + 1) + total (steps (S + 1) n) y) :=
        congrArg (x S + ·) (balance_over_stretch_on (S + 1) n fun t from_ below =>
          across t (Nat.le_of_succ_le from_)
            (Nat.lt_of_lt_of_le below (Nat.le_of_eq (Nat.add_right_comm S 1 n))))
      _ = (q (S + 1) + x S) + total (steps (S + 1) n) y :=
        (Nat.add_left_comm _ _ _).trans (Nat.add_assoc _ _ _).symm
      _ = (q S + y S) + total (steps (S + 1) n) y :=
        congrArg (· + _) (across S (Nat.le_refl S) (Nat.lt_add_of_pos_right (Nat.succ_pos n)))
      _ = q S + (y S + total (steps (S + 1) n) y) := Nat.add_assoc _ _ _

/-- A count balanced across each step, what it gains against what it loses, is balanced
over any stretch: at the end with everything lost, it is the count at the start with
everything gained. -/
theorem balance_over_stretch {q x y : Nat → Nat} (across : ∀ t, q (t + 1) + x t = q t + y t)
    (S : Nat) : ∀ n, q (S + n) + total (steps S n) x = q S + total (steps S n) y :=
  fun n => balance_over_stretch_on S n fun t _ _ => across t

/-- A count that, at each step, ends with what it loses at most where it started with what
it gains does so over any stretch. -/
theorem le_over_stretch {q x y : Nat → Nat} (across : ∀ t, q (t + 1) + x t ≤ q t + y t)
    (S : Nat) : ∀ n, q (S + n) + total (steps S n) x ≤ q S + total (steps S n) y
  | 0 => Nat.le_refl _
  | n + 1 => calc
      q (S + (n + 1)) + (x S + total (steps (S + 1) n) x)
          = x S + (q (S + 1 + n) + total (steps (S + 1) n) x) :=
        (congrArg (· + _) (congrArg q (Nat.add_right_comm S 1 n).symm)).trans
          (Nat.add_left_comm _ _ _)
      _ ≤ x S + (q (S + 1) + total (steps (S + 1) n) y) :=
        Nat.add_le_add_left (le_over_stretch across (S + 1) n) (x S)
      _ = (q (S + 1) + x S) + total (steps (S + 1) n) y :=
        (Nat.add_left_comm _ _ _).trans (Nat.add_assoc _ _ _).symm
      _ ≤ (q S + y S) + total (steps (S + 1) n) y := Nat.add_le_add_right (across S) _
      _ = q S + (y S + total (steps (S + 1) n) y) := Nat.add_assoc _ _ _

/-- A count that, at each step, starts with what it gains at most where it ends with what
it loses does so over any stretch. -/
theorem ge_over_stretch {q x y : Nat → Nat} (across : ∀ t, q t + y t ≤ q (t + 1) + x t)
    (S : Nat) : ∀ n, q S + total (steps S n) y ≤ q (S + n) + total (steps S n) x
  | 0 => Nat.le_refl _
  | n + 1 => calc
      q S + (y S + total (steps (S + 1) n) y)
          = (q S + y S) + total (steps (S + 1) n) y := (Nat.add_assoc _ _ _).symm
      _ ≤ (q (S + 1) + x S) + total (steps (S + 1) n) y := Nat.add_le_add_right (across S) _
      _ = x S + (q (S + 1) + total (steps (S + 1) n) y) :=
        (Nat.add_assoc _ _ _).trans (Nat.add_left_comm _ _ _)
      _ ≤ x S + (q (S + 1 + n) + total (steps (S + 1) n) x) :=
        Nat.add_le_add_left (ge_over_stretch across (S + 1) n) (x S)
      _ = q (S + (n + 1)) + (x S + total (steps (S + 1) n) x) :=
        (Nat.add_left_comm _ _ _).trans
          (congrArg (· + _) (congrArg q (Nat.add_right_comm S 1 n)))

namespace RouteTraces

/-- A count at most another that is not zero leaves the other not zero. -/
theorem nonzero_of_le : ∀ {a b : Nat}, a ≤ b → nonzero a = true → nonzero b = true
  | 0, _, _, pos => Bool.noConfusion pos
  | _ + 1, 0, le, _ => absurd le (Nat.not_succ_le_zero _)
  | _ + 1, _ + 1, _, _ => rfl

end RouteTraces

/-- The numbers from `K` down to zero. -/
def downFrom : Nat → List Nat
  | 0 => [0]
  | K + 1 => (K + 1) :: downFrom K

theorem mem_downFrom : ∀ {k K : Nat}, k ≤ K → k ∈ downFrom K
  | _, 0, le => Eq.subst (motive := fun k => k ∈ downFrom 0) (Nat.eq_zero_of_le_zero le).symm
      (.head _)
  | _, K + 1, le => match Nat.eq_or_lt_of_le le with
    | .inl same => Eq.subst (motive := fun x => x ∈ downFrom (K + 1)) same.symm (.head _)
    | .inr lt => .tail _ (mem_downFrom (Nat.le_of_lt_succ lt))

theorem le_of_mem_downFrom : ∀ {K k : Nat}, k ∈ downFrom K → k ≤ K
  | 0, _, .head _ => Nat.le_refl 0
  | 0, _, .tail _ no => nomatch no
  | _ + 1, _, .head _ => Nat.le_refl _
  | _ + 1, _, .tail _ mem => Nat.le_succ_of_le (le_of_mem_downFrom mem)

namespace Undecided

theorem mem_upto : ∀ {n i : Nat}, i < n → i ∈ upto n
  | 0, _, lt => absurd lt (Nat.not_lt_zero _)
  | n + 1, i, lt => match Nat.lt_or_ge i n with
    | .inl lt' => .tail n (mem_upto lt')
    | .inr ge => Eq.subst (motive := fun x => x ∈ n :: upto n)
        (Nat.le_antisymm (Nat.le_of_lt_succ lt) ge).symm (List.Mem.head (upto n))

end Undecided

end Becoming
