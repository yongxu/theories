import Becoming.U4Scratch

/-!
# Scratch for U4, lever 1: re-pairing (not a module of the package)

OU's owner asked which of lever 1's laws hold for every admissible pairing and which need one
pairing chosen. Counts do not fix unit lines (U1), so a law about lines counts only where it holds
whatever lines the counts admit.

* **Not invariant: one-to-one continuation.** The split-and-merge model's units and a one-to-one model of the
  same units have the same counts, nothing arising or ceasing in either, and only the second admits
  the census pairing (`same_counts_other_lines`). That a unit model continues one to one is a choice
  among the models the counts admit: a premise, not a law read on counts.
* **Invariant: balance as the existence of a one-to-one model.** Each condition's balance across a
  step holds exactly where some unit model continuing one to one counts to it
  (`balances_at_iff_census`). Both sides are statements about the counts, so the law holds whatever
  lines are chosen; one direction is the census (`balances_at_of_census`), the other builds the model
  (`census_model`, from `census_counts`).
-/

namespace Becoming
namespace U4Scratch

/-! ## The same counts, other lines -/

/-- One unit continuing as one, three times over. -/
def oneToOne (g f : Nat) : Bool :=
  (Nat.beq g 0 && Nat.beq f 3) || (Nat.beq g 1 && Nat.beq f 4) || (Nat.beq g 2 && Nat.beq f 5)

/-- **The census pairing is not fixed by the counts.** Two unit models of three units before and
three after, with nothing arising or ceasing in either: one continues one to one and admits the census
pairing, the other splits one unit and merges two and admits none. -/
theorem same_counts_other_lines :
    arising oneToOne [0, 1, 2] [3, 4, 5] = arising splitAndMerge [0, 1, 2] [3, 4, 5] ∧
      ceasing oneToOne [0, 1, 2] [3, 4, 5] = ceasing splitAndMerge [0, 1, 2] [3, 4, 5] ∧
      «对» (fun x y => oneToOne x y = true ∨ x = y) [0, 1, 2] [3, 4, 5] ∧
      ¬ «对» (fun x y => splitAndMerge x y = true ∨ x = y) [0, 1, 2] [3, 4, 5] :=
  ⟨rfl, rfl, .cons (b₁ := []) (Or.inl rfl) (.cons (b₁ := []) (Or.inl rfl)
    (.cons (b₁ := []) (Or.inl rfl) .nil)), split_and_merge.2.2.2⟩

/-! ## A one-to-one model for every balanced count -/

/-- The whole numbers from `s`, `k` of them. -/
def upto (s : Nat) : Nat → List Nat
  | 0 => []
  | k + 1 => s :: upto (s + 1) k

theorem length_upto (s : Nat) : ∀ k, (upto s k).length = k
  | 0 => rfl
  | k + 1 => congrArg (· + 1) (length_upto (s + 1) k)

theorem mem_upto {x : Nat} : ∀ {s k : Nat}, x ∈ upto s k → s ≤ x ∧ x < s + k
  | _, 0, m => nomatch m
  | s, k + 1, m => by
    cases m with
    | head => exact ⟨Nat.le_refl _, Nat.lt_succ_of_le (Nat.le_add_right _ k)⟩
    | tail _ m' =>
      have h := mem_upto m'
      have e : s + 1 + k = s + (k + 1) := Nat.succ_add s k
      exact ⟨Nat.le_of_succ_le h.1, e ▸ h.2⟩

theorem distinct_upto : ∀ s k, Distinct (upto s k)
  | _, 0 => trivial
  | s, k + 1 => ⟨fun m => Nat.lt_irrefl s (mem_upto m).1, distinct_upto (s + 1) k⟩

theorem any_true_of_mem {α : Type} {p : α → Bool} : ∀ {l : List α} {x : α}, x ∈ l → p x = true →
    l.any p = true
  | h :: t, _, .head _, px => by
    show (p h || t.any p) = true
    rw [px]; rfl
  | h :: t, _, .tail _ m, px => by
    show (p h || t.any p) = true
    rw [any_true_of_mem m px]
    cases p h <;> rfl

theorem any_false_of {α : Type} {p : α → Bool} : ∀ l : List α, (∀ x, x ∈ l → p x = false) →
    l.any p = false
  | [], _ => rfl
  | h :: t, all => by
    show (p h || t.any p) = false
    rw [all h (.head t), any_false_of t (fun x m => all x (.tail h m))]
    rfl

theorem keep_none {U : Type} {p : U → Bool} : ∀ l : List U, (∀ x, x ∈ l → p x = false) → keep p l = []
  | [], _ => rfl
  | x :: l, none' => by
    show cond (p x) (x :: keep p l) (keep p l) = []
    rw [none' x (.head l)]
    exact keep_none l (fun y m => none' y (.tail x m))

/-- Continuing as itself, below `d`. -/
def stays (d g f : Nat) : Bool := Nat.beq g f && Nat.blt g d

theorem stays_self {d g : Nat} (below : g < d) : stays d g g = true := by
  show (Nat.beq g g && Nat.ble (g + 1) d) = true
  rw [beq_self g, Nat.ble_eq_true_of_le below]
  rfl

theorem stays_off {d g f : Nat} (above : d ≤ f) : stays d g f = false := by
  cases h : Nat.beq g f with
  | false => show (Nat.beq g f && Nat.blt g d) = false; rw [h]; rfl
  | true =>
    cases Nat.eq_of_beq_eq_true h
    show (Nat.beq g g && Nat.ble (g + 1) d) = false
    rw [Naturals.ble_false_of_lt (Nat.lt_succ_of_le above)]
    cases Nat.beq g g <;> rfl

theorem stays_same {d g f : Nat} (h : stays d g f = true) : g = f :=
  Nat.eq_of_beq_eq_true (and_true_cases h).1

theorem mem_left {α : Type} {x : α} {l m : List α} (h : x ∈ l) : x ∈ l ++ m :=
  ListTests.mem_append_iff.mpr (.inl h)

theorem mem_right {α : Type} {x : α} {l m : List α} (h : x ∈ m) : x ∈ l ++ m :=
  ListTests.mem_append_iff.mpr (.inr h)

/-- **A one-to-one model with given counts.** Before the step stand `d + out` units; `d` of them
continue as themselves, `out` cease, and `into` arise; nothing splits or merges. -/
theorem census_model (d out into : Nat) :
    Distinct (upto 0 d ++ upto d out) ∧ Distinct (upto 0 d ++ upto (d + out) into) ∧
      «定后» (fun x y => stays d x y = true) ∧ «定前» (fun x y => stays d x y = true) ∧
      (upto 0 d ++ upto d out).length = d + out ∧ (upto 0 d ++ upto (d + out) into).length = d + into ∧
      (arising (stays d) (upto 0 d ++ upto d out) (upto 0 d ++ upto (d + out) into)).length = into ∧
      (ceasing (stays d) (upto 0 d ++ upto d out) (upto 0 d ++ upto (d + out) into)).length = out := by
  have below : ∀ x, x ∈ upto 0 d → x < d := fun x m => (Nat.zero_add d) ▸ (mem_upto m).2
  have dB : Distinct (upto 0 d ++ upto d out) :=
    distinct_append (distinct_upto 0 d) (distinct_upto d out)
      fun x m m' => Nat.lt_irrefl x (Nat.lt_of_lt_of_le (below x m) (mem_upto m').1)
  have dA : Distinct (upto 0 d ++ upto (d + out) into) :=
    distinct_append (distinct_upto 0 d) (distinct_upto (d + out) into)
      fun x m m' => Nat.lt_irrefl x (Nat.lt_of_lt_of_le (below x m)
        (Nat.le_trans (Nat.le_add_right d out) (mem_upto m').1))
  refine ⟨dB, dA, «定后之逐点».mpr fun x y z r r' => (stays_same r).symm.trans (stays_same r'),
    «定前之逐点».mpr fun x y z r r' => (stays_same r).trans (stays_same r').symm,
    (ListTests.length_append _ _).trans (by rw [length_upto, length_upto]),
    (ListTests.length_append _ _).trans (by rw [length_upto, length_upto]),
    ?_, ?_⟩
  · show (keep _ (upto 0 d ++ upto (d + out) into)).length = into
    rw [keep_append, keep_none (upto 0 d) (fun f m => by
        show (!((upto 0 d ++ upto d out).any fun g => stays d g f)) = false
        rw [any_true_of_mem (p := fun g => stays d g f) (mem_left m) (stays_self (below f m))]; rfl),
      keep_all (upto (d + out) into) (fun f m => by
        show (!((upto 0 d ++ upto d out).any fun g => stays d g f)) = true
        rw [any_false_of (p := fun g => stays d g f) _
          (fun g _ => stays_off (Nat.le_trans (Nat.le_add_right d out) (mem_upto m).1))]
        rfl)]
    exact length_upto (d + out) into
  · show (keep _ (upto 0 d ++ upto d out)).length = out
    rw [keep_append, keep_none (upto 0 d) (fun g m => by
        show (!((upto 0 d ++ upto (d + out) into).any (stays d g))) = false
        rw [any_true_of_mem (p := stays d g) (mem_left m) (stays_self (below g m))]; rfl),
      keep_all (upto d out) (fun g m => by
        show (!((upto 0 d ++ upto (d + out) into).any (stays d g))) = true
        rw [any_false_of (p := stays d g) _ (fun f _ => by
          show (Nat.beq g f && Nat.ble (g + 1) d) = false
          rw [Naturals.ble_false_of_lt (Nat.lt_succ_of_le (mem_upto m).1)]
          cases Nat.beq g f <;> rfl)]
        rfl)]
    exact length_upto d out

/-- **Balanced counts split into staying, ceasing, arising and passing.** Where a level after a step
with what is taken is the level before with what is given, some units stay, some cease, some arise,
and as many pass through on both sides. -/
theorem census_counts (n m G T : Nat) (bal : m + T = n + G) :
    ∃ d out into passing, d + out = n ∧ d + into = m ∧ into + passing = G ∧ out + passing = T := by
  cases Nat.lt_or_ge n T with
  | inr le =>
    refine ⟨n - T, T, G, 0, Naturals.sub_add_cancel le, ?_, rfl, rfl⟩
    apply Naturals.add_right_cancel (k := T)
    calc n - T + G + T = n - T + T + G := by
          rw [Nat.add_assoc, Nat.add_comm G T, ← Nat.add_assoc]
      _ = n + G := by rw [Naturals.sub_add_cancel le]
      _ = m + T := bal.symm
  | inl lt =>
    have le : n ≤ T := Nat.le_of_lt lt
    refine ⟨0, n, m, T - n, Nat.zero_add n, Nat.zero_add m, ?_, add_sub_of_le le⟩
    apply Naturals.add_right_cancel (k := n)
    calc m + (T - n) + n = m + T := by rw [Nat.add_assoc, Naturals.sub_add_cancel le]
      _ = n + G := bal
      _ = G + n := Nat.add_comm n G

/-- **Balance as the existence of a one-to-one model, the same whatever lines are chosen.** A flow
balances at a condition across a step exactly where some unit model continuing one to one counts to
it: the levels count its units, and what is given and taken counts those arising and ceasing, with as
many more passing through on both sides. -/
theorem balances_at_iff_census {F C : Type} {L : Flow F C} {W : Web F C} {t : Nat} {c : C} :
    W.level (t + 1) c + L.taken t c = W.level t c + L.given t c ↔
      ∃ (before after : List Nat) (k : Nat → Nat → Bool) (passing : Nat),
        Distinct before ∧ Distinct after ∧ «定后» (fun x y => k x y = true) ∧
          «定前» (fun x y => k x y = true) ∧ W.level t c = before.length ∧
          W.level (t + 1) c = after.length ∧
          L.given t c = (arising k before after).length + passing ∧
          L.taken t c = (ceasing k before after).length + passing := by
  constructor
  · intro bal
    match census_counts _ _ _ _ bal with
    | ⟨d, out, into, passing, hn, hm, hG, hT⟩ =>
      have model := census_model d out into
      refine ⟨_, _, stays d, passing, model.1, model.2.1, model.2.2.1, model.2.2.2.1,
        (model.2.2.2.2.1.trans hn).symm, (model.2.2.2.2.2.1.trans hm).symm, ?_, ?_⟩
      · rw [model.2.2.2.2.2.2.1]; exact hG.symm
      · rw [model.2.2.2.2.2.2.2]; exact hT.symm
  · intro ⟨before, after, k, passing, dB, dA, fixedAfter, fixedBefore, stands, stood, given, taken⟩
    exact balances_at_of_census k before after dB dA
      (fun g f f' _ _ _ r r' => «定后之逐点».mp fixedAfter g f f' r r')
      (fun g g' f _ _ _ r r' => «定前之逐点».mp fixedBefore g g' f r r')
      passing stands stood given taken

end U4Scratch
end Becoming
