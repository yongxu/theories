import Becoming.Prelude

/-!
# Shared arithmetic, boolean, division, and subtraction helpers (`Becoming.CoreHelpers`)

Pure `Init` + `Becoming.Prelude` utility layer consolidating duplicated `Nat`/`Bool`/list-max/
division/subtraction helpers across Wave 1–2 `Becoming` modules. Every declaration compiles from
Lean's prelude alone with an empty axiom report (`0` axioms, `0` `sorry`).

AI-written (Lean Unification Wave U2, 24 November 2026).
-/

namespace Becoming

namespace CoreHelpers

universe u

/-! ## Decidable `Nat` minimum, maximum, and `Bool` helpers -/

/-- Decidable `Nat` maximum without core `Max` typeclass axioms. -/
def natMax (a b : Nat) : Nat := if a ≤ b then b else a

theorem le_natMax_left (a b : Nat) : a ≤ natMax a b :=
  match Nat.decLe a b with
  | isTrue le => Nat.le_trans le (Nat.le_of_eq (if_pos le).symm)
  | isFalse notLe => Nat.le_of_eq (if_neg notLe).symm

theorem le_natMax_right (a b : Nat) : b ≤ natMax a b :=
  match Nat.decLe a b with
  | isTrue le => Nat.le_of_eq (if_pos le).symm
  | isFalse notLe => Nat.le_trans (Nat.le_of_lt (Nat.gt_of_not_le notLe))
      (Nat.le_of_eq (if_neg notLe).symm)

theorem natMax_le {a b c : Nat} (ha : a ≤ c) (hb : b ≤ c) : natMax a b ≤ c :=
  match Nat.decLe a b with
  | isTrue le => Nat.le_trans (Nat.le_of_eq (if_pos le)) hb
  | isFalse notLe => Nat.le_trans (Nat.le_of_eq (if_neg notLe)) ha

theorem natMax_comm (a b : Nat) : natMax a b = natMax b a :=
  Nat.le_antisymm
    (natMax_le (le_natMax_right b a) (le_natMax_left b a))
    (natMax_le (le_natMax_right a b) (le_natMax_left a b))

theorem natMax_assoc (a b c : Nat) : natMax (natMax a b) c = natMax a (natMax b c) :=
  Nat.le_antisymm
    (natMax_le
      (natMax_le (le_natMax_left a (natMax b c))
        (Nat.le_trans (le_natMax_left b c) (le_natMax_right a (natMax b c))))
      (Nat.le_trans (le_natMax_right b c) (le_natMax_right a (natMax b c))))
    (natMax_le
      (Nat.le_trans (le_natMax_left a b) (le_natMax_left (natMax a b) c))
      (natMax_le (Nat.le_trans (le_natMax_right a b) (le_natMax_left (natMax a b) c))
        (le_natMax_right (natMax a b) c)))

theorem natMax_zero_zero : natMax 0 0 = 0 := rfl

theorem natMax_add_le (a b c d : Nat) :
    natMax (a + c) (b + d) ≤ natMax a b + natMax c d :=
  natMax_le
    (Nat.add_le_add (le_natMax_left a b) (le_natMax_left c d))
    (Nat.add_le_add (le_natMax_right a b) (le_natMax_right c d))

theorem natMax_add_max_le (a b c d : Nat) :
    natMax (a + c) (b + d) ≤ natMax a b + natMax c d :=
  natMax_add_le a b c d

/-- Folded maximum of a `Nat`-valued function over a list. -/
def foldNatMax {α : Type} (agents : List α) (f : α → Nat) : Nat :=
  agents.foldr (fun i acc => natMax (f i) acc) 0

theorem le_foldNatMax_of_mem {α : Type} {f : α → Nat} :
    ∀ {agents : List α} {i : α}, i ∈ agents → f i ≤ foldNatMax agents f
  | [], _, mem => absurd mem ListTests.not_mem_nil
  | _ :: _, _, .head _ => le_natMax_left _ _
  | _ :: _, _, .tail _ mem => Nat.le_trans (le_foldNatMax_of_mem mem) (le_natMax_right _ _)

theorem foldNatMax_le_of_all {α : Type} {f : α → Nat} {M : Nat} :
    ∀ {agents : List α}, (∀ i, i ∈ agents → f i ≤ M) → foldNatMax agents f ≤ M
  | [], _ => Nat.zero_le M
  | _ :: _, all => natMax_le (all _ (.head _))
      (foldNatMax_le_of_all fun i mem => all i (.tail _ mem))

theorem foldNatMax_eq_zero {α : Type} {f : α → Nat} :
    ∀ {agents : List α}, (∀ i, i ∈ agents → f i = 0) → foldNatMax agents f = 0
  | [], _ => rfl
  | _ :: _, zero =>
    Nat.le_antisymm
      (natMax_le (Nat.le_of_eq (zero _ (.head _)))
        (Nat.le_of_eq (foldNatMax_eq_zero fun i mem => zero i (.tail _ mem))))
      (Nat.zero_le _)

theorem foldNatMax_succ_le {α : Type} {f : α → Nat} {M : Nat} (pos : 0 < M) :
    ∀ {agents : List α}, (∀ i, i ∈ agents → f i + 1 ≤ M) → foldNatMax agents f + 1 ≤ M
  | [], _ => pos
  | a :: rest, all =>
    have ih := foldNatMax_succ_le pos fun i mem => all i (.tail _ mem)
    have ha := all a (.head _)
    show natMax (f a) (foldNatMax rest f) + 1 ≤ M from
      match Nat.decLe (f a) (foldNatMax rest f) with
      | isTrue le =>
        Nat.le_trans (Nat.le_of_eq (congrArg (· + 1) (if_pos le : natMax (f a) (foldNatMax rest f) = _))) ih
      | isFalse notLe =>
        Nat.le_trans (Nat.le_of_eq (congrArg (· + 1) (if_neg notLe : natMax (f a) (foldNatMax rest f) = _))) ha

/-- Decidable `Nat` minimum without core `Min` typeclass axioms. -/
def natMin (a b : Nat) : Nat := if a ≤ b then a else b

theorem natMin_le_left (a b : Nat) : natMin a b ≤ a :=
  match Nat.decLe a b with
  | isTrue le => Nat.le_of_eq (if_pos le)
  | isFalse notLe => Nat.le_trans (Nat.le_of_eq (if_neg notLe))
      (Nat.le_of_lt (Nat.gt_of_not_le notLe))

theorem natMin_le_right (a b : Nat) : natMin a b ≤ b :=
  match Nat.decLe a b with
  | isTrue le => Nat.le_trans (Nat.le_of_eq (if_pos le)) le
  | isFalse notLe => Nat.le_of_eq (if_neg notLe)

theorem le_natMin {a b c : Nat} (ha : c ≤ a) (hb : c ≤ b) : c ≤ natMin a b :=
  match Nat.decLe a b with
  | isTrue le => Nat.le_trans ha (Nat.le_of_eq (if_pos le).symm)
  | isFalse notLe => Nat.le_trans hb (Nat.le_of_eq (if_neg notLe).symm)

theorem natMin_eq_left {a b : Nat} (le : a ≤ b) : natMin a b = a :=
  if_pos le

theorem natMin_eq_right {a b : Nat} (le : b ≤ a) : natMin a b = b :=
  match Nat.decLe a b with
  | isTrue ab => (if_pos ab).trans (Nat.le_antisymm ab le)
  | isFalse notLe => if_neg notLe

theorem sub_natMin_right (x d : Nat) : x - natMin d x = x - d :=
  match Nat.decLe d x with
  | isTrue dx => congrArg (x - ·) (natMin_eq_left dx)
  | isFalse notDx =>
    have xd : x ≤ d := Nat.le_of_lt (Nat.gt_of_not_le notDx)
    (congrArg (x - ·) (natMin_eq_right xd)).trans
      ((sub_eq_zero_of_le (Nat.le_refl x)).trans (sub_eq_zero_of_le xd).symm)

theorem natBlt_true_iff {a b : Nat} : Nat.blt a b = true ↔ a < b :=
  ⟨fun h => Nat.le_of_ble_eq_true h, fun lt => Nat.ble_eq_true_of_le lt⟩

theorem natBlt_false_iff {a b : Nat} : Nat.blt a b = false ↔ b ≤ a :=
  ⟨fun h => (Nat.lt_or_ge a b).elim (fun lt => Bool.noConfusion ((natBlt_true_iff.mpr lt).symm.trans h)) id,
   fun le => Naturals.ble_false_of_lt (Nat.lt_succ_of_le le)⟩

theorem natBeq_true_iff {a b : Nat} : Nat.beq a b = true ↔ a = b :=
  ⟨Nat.eq_of_beq_eq_true, fun same => same ▸ beq_self a⟩

theorem bool_or_false_left (b : Bool) : (false || b) = b := rfl

theorem bool_or_true_right (a : Bool) : (a || true) = true := by
  cases a <;> rfl

theorem bool_or_assoc (a b c : Bool) : ((a || b) || c) = (a || (b || c)) := by
  cases a <;> cases b <;> cases c <;> rfl

/-! ## `ite`/`dite` and Euclidean `div`/`mod` helpers -/

theorem ite_pos' {c : Prop} [h : Decidable c] (hc : c) {α : Sort u} {t e : α} :
    (if c then t else e) = t :=
  match h with
  | isTrue _ => rfl
  | isFalse hn => absurd hc hn

theorem ite_neg' {c : Prop} [h : Decidable c] (hc : ¬ c) {α : Sort u} {t e : α} :
    (if c then t else e) = e :=
  match h with
  | isTrue ht => absurd ht hc
  | isFalse _ => rfl

theorem dite_pos' {c : Prop} [h : Decidable c] (hc : c) {α : Sort u} {t : c → α} {e : ¬ c → α} :
    (if hc' : c then t hc' else e hc') = t hc :=
  match h with
  | isTrue _ => rfl
  | isFalse hn => absurd hc hn

theorem dite_neg' {c : Prop} [h : Decidable c] (hc : ¬ c) {α : Sort u} {t : c → α} {e : ¬ c → α} :
    (if hc' : c then t hc' else e hc') = e hc :=
  match h with
  | isTrue ht => absurd ht hc
  | isFalse _ => rfl

theorem div_go_irrel (y : Nat) (hy : 0 < y) :
    ∀ (f₁ : Nat) {f₂ x : Nat} (h₁ : x < f₁) (h₂ : x < f₂),
      Nat.div.go y hy f₁ x h₁ = Nat.div.go y hy f₂ x h₂
  | 0, _, _, h₁, _ => absurd h₁ (Nat.not_lt_zero _)
  | f₁ + 1, 0, _, _, h₂ => absurd h₂ (Nat.not_lt_zero _)
  | f₁ + 1, f₂ + 1, x, h₁, h₂ => by
    rw [Nat.div.go.eq_1, Nat.div.go.eq_1]
    split
    · exact congrArg (· + 1) (div_go_irrel y hy f₁ _ _)
    · rfl

theorem mod_go_irrel (y : Nat) (hy : 0 < y) :
    ∀ (f₁ : Nat) {f₂ x : Nat} (h₁ : x < f₁) (h₂ : x < f₂),
      Nat.modCore.go y hy f₁ x h₁ = Nat.modCore.go y hy f₂ x h₂
  | 0, _, _, h₁, _ => absurd h₁ (Nat.not_lt_zero _)
  | f₁ + 1, 0, _, _, h₂ => absurd h₂ (Nat.not_lt_zero _)
  | f₁ + 1, f₂ + 1, x, h₁, h₂ => by
    rw [Nat.modCore.go.eq_1, Nat.modCore.go.eq_1]
    split
    · exact mod_go_irrel y hy f₁ _ _
    · rfl

theorem div_add_self (y : Nat) (hy : 0 < y) (x : Nat) : (x + y) / y = x / y + 1 := by
  change (x + y).div y = x.div y + 1
  rw [Nat.div.eq_1 (x + y) y, Nat.div.eq_1 x y]
  split
  · rw [Nat.div.go.eq_1]
    have hle : y ≤ x + y := Nat.le_add_left y x
    split
    · have aux : ∀ {z} (eq : z = x) (hz : z < x + y),
          Nat.div.go y hy (x + y) z hz = Nat.div.go y hy x.succ x (Nat.lt_succ_self x) := by
        intro z eq hz
        cases eq
        exact div_go_irrel y hy (x + y) hz (Nat.lt_succ_self x)
      exact congrArg (· + 1) (aux (Naturals.add_sub_cancel x y) _)
    · exact absurd hle ‹_›
  · exact absurd hy ‹_›

theorem mod_add_self (y : Nat) (hy : 0 < y) (x : Nat) : (x + y) % y = x % y := by
  change (x + y).mod y = x.mod y
  cases y with
  | zero => exact absurd hy (Nat.lt_irrefl 0)
  | succ y' =>
    have hxy : x + y'.succ = (x + y').succ := rfl
    rw [hxy, Nat.mod.eq_2]
    have hle : y'.succ ≤ (x + y').succ := Nat.le_add_left y'.succ x
    rw [ite_pos' hle, Nat.modCore.eq_1, dite_pos' hy, Nat.modCore.go.eq_1, dite_pos' hle]
    have aux : ∀ {z} (eq : z = x) (hz : z < (x + y').succ),
        Nat.modCore.go y'.succ hy (x + y').succ z hz =
          Nat.modCore.go y'.succ hy x.succ x (Nat.lt_succ_self x) := by
      intro z eq hz
      cases eq
      exact mod_go_irrel y'.succ hy (x + y').succ hz (Nat.lt_succ_self x)
    have hsub : (x + y').succ - y'.succ = x := Naturals.add_sub_cancel x y'.succ
    rw [aux hsub _]
    cases x with
    | zero =>
      rw [Nat.mod.eq_1, Nat.modCore.go.eq_1]
      exact dite_neg' (Nat.not_le_of_gt hy)
    | succ x' =>
      rw [Nat.mod.eq_2]
      split
      · rw [Nat.modCore.eq_1, dite_pos' hy]
      · rw [Nat.modCore.go.eq_1]
        exact dite_neg' ‹_›

theorem div_eq_zero_of_lt {r y : Nat} (hy : 0 < y) (hlt : r < y) : r / y = 0 := by
  change r.div y = 0
  rw [Nat.div.eq_1 r y, dite_pos' hy, Nat.div.go.eq_1]
  exact dite_neg' (Nat.not_le_of_gt hlt)

theorem mod_eq_self_of_lt {r y : Nat} (hy : 0 < y) (hlt : r < y) : r % y = r := by
  change r.mod y = r
  cases r with
  | zero => rfl
  | succ r' =>
    cases y with
    | zero => exact absurd hy (Nat.lt_irrefl 0)
    | succ y' =>
      rw [Nat.mod.eq_2, ite_neg' (Nat.not_le_of_gt hlt)]

theorem div_mul_add_rem {y : Nat} (hy : 0 < y) {r : Nat} (hlt : r < y) :
    ∀ q : Nat, (q * y + r) / y = q
  | 0 =>
    (congrArg (fun k => (k + r) / y) (Nat.zero_mul y)).trans
      ((congrArg (· / y) (Nat.zero_add r)).trans (div_eq_zero_of_lt hy hlt))
  | q + 1 => by
    have eq1 : (q + 1) * y + r = (q * y + r) + y :=
      (congrArg (· + r) (Nat.succ_mul q y)).trans (Nat.add_right_comm (q * y) y r)
    rw [eq1, div_add_self y hy (q * y + r), div_mul_add_rem hy hlt q]

theorem div_mod_decomp_bound (y : Nat) (hy : 0 < y) :
    ∀ n a : Nat, a < n → a = (a / y) * y + a % y ∧ a % y < y
  | 0, _, lt => absurd lt (Nat.not_lt_zero _)
  | n + 1, a, lt =>
    match Nat.lt_or_ge a y with
    | .inl ay => by
      refine ⟨?_, ?_⟩
      · rw [div_eq_zero_of_lt hy ay, mod_eq_self_of_lt hy ay, Nat.zero_mul, Nat.zero_add]
      · rw [mod_eq_self_of_lt hy ay]; exact ay
    | .inr ya => by
      have sub_lt : a - y < n := by
        have hpos : a - y + 1 ≤ a := by
          have h1 : 1 ≤ y := hy
          calc a - y + 1 ≤ a - y + y := Nat.add_le_add_left h1 _
            _ = a := Naturals.sub_add_cancel ya
        exact Nat.le_trans hpos (Nat.le_of_succ_le_succ lt)
      obtain ⟨eq, rem⟩ := div_mod_decomp_bound y hy n (a - y) sub_lt
      have ha : a = (a - y) + y := (Naturals.sub_add_cancel ya).symm
      have hdiv : a / y = (a - y) / y + 1 :=
        (congrArg (· / y) ha).trans (div_add_self y hy (a - y))
      have hmod : a % y = (a - y) % y :=
        (congrArg (· % y) ha).trans (mod_add_self y hy (a - y))
      refine ⟨?_, ?_⟩
      · calc a = (a - y) + y := ha
          _ = ((a - y) / y * y + (a - y) % y) + y := congrArg (· + y) eq
          _ = ((a - y) / y * y + y) + (a - y) % y := Nat.add_right_comm _ _ _
          _ = ((a - y) / y + 1) * y + (a - y) % y :=
              congrArg (· + (a - y) % y) (Nat.succ_mul ((a - y) / y) y).symm
          _ = (a / y) * y + a % y := by rw [← hdiv, ← hmod]
      · rw [hmod]
        exact rem

theorem div_mod_decomp {y : Nat} (hy : 0 < y) (a : Nat) :
    a = (a / y) * y + a % y ∧ a % y < y :=
  div_mod_decomp_bound y hy (a + 1) a (Nat.lt_succ_self a)

theorem lt_ceil_div_iff {b : Nat} (hb : 0 < b) :
    ∀ k a : Nat, k * b < a ↔ k < (a + b - 1) / b
  | 0, 0 => by
    have hsub : b - 1 < b := by
      cases b with
      | zero => exact absurd hb (Nat.lt_irrefl 0)
      | succ b' => exact Nat.lt_succ_self b'
    rw [Nat.zero_mul, Nat.zero_add, div_eq_zero_of_lt hb hsub]
  | 0, a' + 1 => by
    have eq1 : a' + 1 + b - 1 = a' + b := by
      calc a' + 1 + b - 1 = (a' + b + 1) - 1 := congrArg (· - 1) (Nat.add_right_comm a' 1 b)
        _ = a' + b := Naturals.add_sub_cancel (a' + b) 1
    rw [Nat.zero_mul, eq1, div_add_self b hb a']
    exact ⟨fun _ => Nat.succ_pos _, fun _ => Nat.succ_pos _⟩
  | k + 1, a =>
    match Nat.lt_or_ge a b with
    | .inl ab => by
      have notLhs : ¬ (k + 1) * b < a :=
        Nat.not_lt_of_le (Nat.le_trans (Nat.le_of_lt ab)
          (Nat.le_trans (Nat.le_add_left b (k * b)) (Nat.le_of_eq (Nat.succ_mul k b).symm)))
      have notRhs : ¬ k + 1 < (a + b - 1) / b := by
        cases a with
        | zero =>
          have hsub : b - 1 < b := by
            cases b with
            | zero => exact absurd hb (Nat.lt_irrefl 0)
            | succ b' => exact Nat.lt_succ_self b'
          rw [Nat.zero_add, div_eq_zero_of_lt hb hsub]
          exact Nat.not_lt_zero _
        | succ a' =>
          have eq1 : a' + 1 + b - 1 = a' + b := by
            calc a' + 1 + b - 1 = (a' + b + 1) - 1 := congrArg (· - 1) (Nat.add_right_comm a' 1 b)
              _ = a' + b := Naturals.add_sub_cancel (a' + b) 1
          have ha' : a' < b := Nat.lt_trans (Nat.lt_succ_self a') ab
          rw [eq1, div_add_self b hb a', div_eq_zero_of_lt hb ha', Nat.zero_add]
          exact Nat.not_lt_of_le (Nat.succ_le_succ (Nat.zero_le k))
      exact ⟨fun lt => absurd lt notLhs, fun lt => absurd lt notRhs⟩
    | .inr ba => by
      let a' := a - b
      have ha : a = a' + b := (Naturals.sub_add_cancel ba).symm
      have eq1 : a + b - 1 = (a' + b - 1) + b := by
        rw [ha]
        cases b with
        | zero => exact absurd hb (Nat.lt_irrefl 0)
        | succ b' =>
          have lhs : a' + (b' + 1) + (b' + 1) - 1 = a' + (b' + 1) + b' := rfl
          have rhs : a' + (b' + 1) - 1 + (b' + 1) = (a' + b') + (b' + 1) := rfl
          rw [lhs, rhs]
          calc a' + (b' + 1) + b' = a' + ((b' + 1) + b') := Nat.add_assoc _ _ _
            _ = a' + (b' + (b' + 1)) := congrArg (a' + ·) (Nat.add_comm (b' + 1) b')
            _ = (a' + b') + (b' + 1) := (Nat.add_assoc _ _ _).symm
      have hdiv : (a + b - 1) / b = (a' + b - 1) / b + 1 :=
        eq1 ▸ div_add_self b hb (a' + b - 1)
      have ih := lt_ceil_div_iff hb k a'
      have lhsIff : (k + 1) * b < a ↔ k * b < a' := by
        rw [ha, Nat.succ_mul, Nat.add_comm (k * b) b, Nat.add_comm a' b]
        exact Naturals.add_lt_add_left_iff
      have rhsIff : k + 1 < (a + b - 1) / b ↔ k < (a' + b - 1) / b := by
        rw [hdiv]
        exact ⟨fun lt => Nat.lt_of_succ_lt_succ lt, fun lt => Nat.succ_lt_succ lt⟩
      exact lhsIff.trans (ih.trans rhsIff.symm)

/-! ## `Nat` subtraction and saturation helpers -/

theorem le_pred_of_succ_le {a b : Nat} (h : a + 1 ≤ b) : a ≤ b - 1 :=
  match b, h with
  | _ + 1, h => Nat.le_of_succ_le_succ h

theorem le_sub_add_nat (a b : Nat) : a ≤ (a - b) + b :=
  match Nat.le_total a b with
  | .inl le => Nat.le_trans le (Nat.le_add_left b (a - b))
  | .inr ge => Nat.le_of_eq (Naturals.sub_add_cancel ge).symm

theorem le_add_sub_self_nat (a b : Nat) : a ≤ b + (a - b) :=
  (Nat.add_comm (a - b) b).symm ▸ le_sub_add_nat a b

theorem sub_le_add_sub_nat (a b c : Nat) : a - c ≤ (a - b) + (b - c) :=
  Naturals.sub_le_of_le_add
    (Nat.le_trans (le_sub_add_nat a b)
      (Nat.le_trans (Nat.add_le_add_left (le_sub_add_nat b c) (a - b))
        (Nat.le_of_eq ((Nat.add_assoc (a - b) (b - c) c).symm.trans
          (Nat.add_comm ((a - b) + (b - c)) c)))))

theorem sub_eq_sub_succ_add_one : ∀ {T t : Nat}, t < T → T - t = (T - (t + 1)) + 1
  | 0, _, lt => absurd lt (Nat.not_lt_zero _)
  | _ + 1, 0, _ => rfl
  | T + 1, t + 1, lt =>
    (Nat.succ_sub_succ T t).trans
      ((sub_eq_sub_succ_add_one (Nat.lt_of_succ_lt_succ lt)).trans
        (congrArg (· + 1) (Nat.succ_sub_succ T (t + 1)).symm))

theorem sub_sub_mid {m u v : Nat} (hv : v ≤ m) (le : u ≤ v) : (m - u) - (m - v) = v - u := by
  apply add_right_cancel (m - v)
  rw [Naturals.sub_add_cancel (Naturals.sub_antitone m le)]
  apply add_right_cancel u
  calc m - u + u
      = m := Naturals.sub_add_cancel (Nat.le_trans le hv)
    _ = m - v + v := (Naturals.sub_add_cancel hv).symm
    _ = m - v + (v - u + u) := congrArg (m - v + ·) (Naturals.sub_add_cancel le).symm
    _ = m - v + (v - u) + u := (Nat.add_assoc _ _ _).symm
    _ = (v - u + (m - v)) + u := congrArg (· + u) (Nat.add_comm _ _)

theorem add_sub_mid {m x y : Nat} (hx : x ≤ m) : (m + y) - (m - x) = x + y := by
  rw [show m + y = (m - x) + (x + y) by
    rw [← Nat.add_assoc, Naturals.sub_add_cancel hx]]
  exact Naturals.add_sub_cancel_left (m - x) (x + y)

end CoreHelpers

end Becoming
