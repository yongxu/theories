-- Review check for PF2's 07 §4.6 Open item (REVIEW-PF2.md), outside the package: the definition of
-- constancy up to the net's end copied from Becoming.GrammarPath. Checked 25 October 2026 with Lean 4.29.1
-- (`lean review_pf2_open_item.lean` from the package folder); every #print axioms reports none.

/-! Review check for PF2's Open item (not for the repository): two blocks given by a two-valued tag, and a
three-block net where the two-block condition holds but constancy up to the net's end fails. -/

def «际» (α : Type) := α → α → Prop

def «至终有常» {α : Type} (R E : «际» α) : Prop :=
  ∀ u u', E u u' → ∀ v, R u v → (∃ v', R u' v' ∧ E v v') ∨ ∀ w, ¬ R u' w

theorem bool_other : ∀ {a b c : Bool}, ¬ a = c → ¬ b = c → b = a
  | true, true, _, _, _ => rfl
  | false, false, _, _, _ => rfl
  | true, false, true, h, _ => absurd rfl h
  | true, false, false, _, h => absurd rfl h
  | false, true, true, _, h => absurd rfl h
  | false, true, false, h, _ => absurd rfl h

/-- With two blocks given by a tag, constancy up to the net's end is: something inside follows every
alike step that goes on where the member conditions something inside, and something outside where it
conditions something outside. -/
theorem two_blocks {α : Type} (R : «际» α) (t : α → Bool) :
    «至终有常» R (fun x y => t x = t y) ↔
      (∀ u u', t u = t u' → ∀ v, R u v → t u = t v → (∃ x, R u' x ∧ t u' = t x) ∨ ∀ w, ¬ R u' w) ∧
      (∀ u u', t u = t u' → ∀ v, R u v → ¬ t u = t v → (∃ x, R u' x ∧ ¬ t u' = t x) ∨ ∀ w, ¬ R u' w) :=
  ⟨fun constant =>
    ⟨fun u u' h v r inside => match constant u u' h v r with
      | .inl ⟨x, rx, vx⟩ => .inl ⟨x, rx, Eq.trans (Eq.symm h) (Eq.trans inside vx)⟩
      | .inr stops => .inr stops,
     fun u u' h v r outside => match constant u u' h v r with
      | .inl ⟨x, rx, vx⟩ => .inl ⟨x, rx, fun ux => outside (Eq.trans h (Eq.trans ux (Eq.symm vx)))⟩
      | .inr stops => .inr stops⟩,
   fun ⟨ins, outs⟩ u u' h v r => match decEq (t u) (t v) with
    | isTrue inside => match ins u u' h v r inside with
      | .inl ⟨x, rx, ux⟩ => .inl ⟨x, rx, Eq.trans (Eq.symm inside) (Eq.trans h ux)⟩
      | .inr stops => .inr stops
    | isFalse outside => match outs u u' h v r outside with
      | .inl ⟨x, rx, ux⟩ =>
        .inl ⟨x, rx, bool_other (fun e => ux (Eq.trans (Eq.symm h) (Eq.symm e)))
          (fun e => outside (Eq.symm e))⟩
      | .inr stops => .inr stops⟩

namespace ThreeBlocks

inductive Occ | m | c | b | d

def step : «际» Occ
  | .m, .b => True
  | .c, .d => True
  | .m, .m => False | .m, .c => False | .m, .d => False
  | .c, .m => False | .c, .c => False | .c, .b => False
  | .b, _ => False
  | .d, _ => False

def block : Occ → Nat
  | .m => 0 | .c => 0 | .b => 1 | .d => 2

def alike : «际» Occ := fun x y => block x = block y

/-- Something outside follows every alike step that goes on, and nothing inside is conditioned. -/
theorem outside_follows : ∀ u u', alike u u' → ∀ v, step u v → ¬ alike u v →
    (∃ x, step u' x ∧ ¬ alike u' x) ∨ ∀ w, ¬ step u' w
  | .m, .m, _, .b, _, _ => .inl ⟨.b, trivial, fun e => Nat.noConfusion e⟩
  | .m, .c, _, .b, _, _ => .inl ⟨.d, trivial, fun e => Nat.noConfusion e⟩
  | .c, .m, _, .d, _, _ => .inl ⟨.b, trivial, fun e => Nat.noConfusion e⟩
  | .c, .c, _, .d, _, _ => .inl ⟨.d, trivial, fun e => Nat.noConfusion e⟩
  | .m, .b, e, _, _, _ => Nat.noConfusion e
  | .m, .d, e, _, _, _ => Nat.noConfusion e
  | .c, .b, e, _, _, _ => Nat.noConfusion e
  | .c, .d, e, _, _, _ => Nat.noConfusion e
  | .m, _, _, .m, r, _ => False.elim r
  | .m, _, _, .c, r, _ => False.elim r
  | .m, _, _, .d, r, _ => False.elim r
  | .c, _, _, .m, r, _ => False.elim r
  | .c, _, _, .c, r, _ => False.elim r
  | .c, _, _, .b, r, _ => False.elim r
  | .b, _, _, _, r, _ => False.elim r
  | .d, _, _, _, r, _ => False.elim r

theorem nothing_inside : ∀ u v, step u v → ¬ alike u v
  | .m, .b, _ => fun e => Nat.noConfusion e
  | .c, .d, _ => fun e => Nat.noConfusion e
  | .m, .m, r | .m, .c, r | .m, .d, r | .c, .m, r | .c, .c, r | .c, .b, r => False.elim r
  | .b, _, r | .d, _, r => False.elim r

theorem not_constant_to_end : ¬ «至终有常» step alike := fun constant =>
  match constant .m .c rfl .b trivial with
  | .inl ⟨x, r, e⟩ => match x, r, e with
    | .d, _, e => Nat.noConfusion (Nat.succ.inj e)
  | .inr stops => stops .d trivial

end ThreeBlocks

#print axioms two_blocks
#print axioms ThreeBlocks.outside_follows
#print axioms ThreeBlocks.nothing_inside
#print axioms ThreeBlocks.not_constant_to_end
