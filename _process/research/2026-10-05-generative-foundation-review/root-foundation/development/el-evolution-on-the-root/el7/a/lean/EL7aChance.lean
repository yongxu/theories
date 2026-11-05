import Becoming.PairSelection
import Becoming.Typicality

/-!
# EL7 (a), scratch: errors by chance end every pair keeping mutual withholding

Scratch for the EL7 investigation (a); not part of the package and not landed. The pair's run of
`PairSelection`, its errors one-way (an intended giving turns into withholding), read with
errors drawn from a course of `Typicality`, each error weighing `p` and each step without one `q`.

* A law *keeps mutual withholding* where, after two steps at which both formations withheld, it
  withholds (`KeepsWithheld`): answering, the window of two, waiting on both and withholding do;
  agreement, sparing and the alternator do not.
* Where both formations err at two consecutive steps, every pair of such laws withholds at every
  step from the first of them on, whatever the errors after (`burst_absorbs`).
* Errors read from a course of `4 k` values, two steps per block of four (`errorsOf`): where a
  formation still gives at step `2 k`, no block is all errors (`still_gives_free`).
* So the courses of `4 k` values under which the pair still gives at step `2 k` weigh at most
  `S ^ k`, out of `T ^ k`, with `T = (p + q) ^ 4` the four values' whole weight and `S` that of
  the blocks not all errors, `S < T` where `0 < p` (`absorbed_share`): a share falling
  geometrically. The deterministic window absorbs every error pattern spaced at two
  (`WindowedWaiting.gives_unless_errs`); that errors by chance leave such patterns a vanishing
  share is by hand, not proved here.
-/

namespace Becoming
namespace EL7a

open PairSelection WindowedWaiting WindowedWaiting.Pair

/-! ## A burst of errors ends a pair keeping mutual withholding -/

/-- A law keeps mutual withholding: after two steps at which both formations withheld, it
withholds. -/
def KeepsWithheld (f : PairLaw) : Prop := f (false, false) (false, false) = false

theorem keeps_answering : KeepsWithheld answering := rfl
theorem keeps_windowed : KeepsWithheld windowed := rfl
theorem keeps_withholding : KeepsWithheld withholding := rfl
theorem keeps_waitingBoth : KeepsWithheld waitingBoth := rfl

/-- Agreement, sparing and the alternator give after mutual withholding. -/
theorem not_keeps_agreeing : ¬ KeepsWithheld agreeing := fun h => Bool.noConfusion h
theorem not_keeps_sparing : ¬ KeepsWithheld sparing := fun h => Bool.noConfusion h
theorem not_keeps_alternating : ¬ KeepsWithheld alternating := fun h => Bool.noConfusion h

/-- A formation erring at a step withholds there, whatever the laws. -/
theorem err_withholds {f g : PairLaw} {e : Errors} {t : Nat} :
    ∀ a : Pair, e (t + 1) a = true → gives f g e a (t + 1) = false
  | first, h => by
    show (f ((course f g e).state t).2.1 ((course f g e).state t).2.2 &&
      !e (((course f g e).state t).1 + 1) first) = false
    rw [time f g e t, h]
    exact and_not_true _
  | second, h => by
    show (g ((course f g e).state t).2.2 ((course f g e).state t).2.1 &&
      !e (((course f g e).state t).1 + 1) second) = false
    rw [time f g e t, h]
    exact and_not_true _

/-- Where both formations withheld at their last two steps, laws keeping mutual withholding keep it. -/
theorem dead_stays {f g : PairLaw} (wf : KeepsWithheld f) (wg : KeepsWithheld g) (e : Errors) (x : State)
    (h1 : x.2.1 = (false, false)) (h2 : x.2.2 = (false, false)) :
    (step f g e x).2.1 = (false, false) ∧ (step f g e x).2.2 = (false, false) := by
  show (f x.2.1 x.2.2 && !e (x.1 + 1) first, x.2.1.1) = (false, false) ∧
    (g x.2.2 x.2.1 && !e (x.1 + 1) second, x.2.2.1) = (false, false)
  rw [h1, h2, wf, wg]
  exact ⟨rfl, rfl⟩

/-- **Where both formations err at steps `t + 1` and `t + 2`, a pair of laws keeping mutual
withholding withholds at every step from `t + 1` on**, whatever the errors after. -/
theorem burst_absorbs {f g : PairLaw} (wf : KeepsWithheld f) (wg : KeepsWithheld g) {e : Errors} {t : Nat}
    (b1 : e (t + 1) first = true) (b2 : e (t + 1) second = true)
    (b3 : e (t + 2) first = true) (b4 : e (t + 2) second = true) :
    ∀ k, gives f g e first (t + 1 + k) = false ∧ gives f g e second (t + 1 + k) = false :=
  have dead : ∀ k, ((course f g e).state (t + 1 + (k + 1))).2.1 = (false, false) ∧
      ((course f g e).state (t + 1 + (k + 1))).2.2 = (false, false) := fun k => by
    induction k with
    | zero =>
      show (gives f g e first (t + 1 + 1), gives f g e first (t + 1)) = (false, false) ∧
        (gives f g e second (t + 1 + 1), gives f g e second (t + 1)) = (false, false)
      rw [err_withholds (t := t + 1) first b3, err_withholds first b1,
        err_withholds (t := t + 1) second b4, err_withholds second b2]
      exact ⟨rfl, rfl⟩
    | succ k ih => exact dead_stays wf wg e _ ih.1 ih.2
  fun k => match k with
  | 0 => ⟨err_withholds first b1, err_withholds second b2⟩
  | k + 1 => ⟨congrArg (fun l : Lags => l.1) (dead k).1, congrArg (fun l : Lags => l.1) (dead k).2⟩

theorem burst_absorbs_from {f g : PairLaw} (wf : KeepsWithheld f) (wg : KeepsWithheld g) {e : Errors}
    {t : Nat} (b1 : e (t + 1) first = true) (b2 : e (t + 1) second = true)
    (b3 : e (t + 2) first = true) (b4 : e (t + 2) second = true) {m : Nat} (le : t + 1 ≤ m) :
    ∀ a, gives f g e a m = false :=
  match le_dest le with
  | ⟨k, eq⟩ => fun a => match a with
    | first => eq ▸ (burst_absorbs wf wg b1 b2 b3 b4 k).1
    | second => eq ▸ (burst_absorbs wf wg b1 b2 b3 b4 k).2

/-! ## Errors read from a course -/

/-- One block's errors: the first formation's at steps `1` and `2`, then the second's; later
steps are read from the rest. -/
def blockErrors (b0 b1 c0 c1 : Bool) (rest : Nat → Pair → Bool) : Nat → Pair → Bool
  | 0, _ => false
  | 1, first => b0
  | 1, second => c0
  | 2, first => b1
  | 2, second => c1
  | t + 3, a => rest (t + 1) a

/-- Errors read from a course of values, two steps per block of four: the first formation's
errors at steps `2 j + 1` and `2 j + 2`, then the second's. -/
def errorsOf : List Bool → Nat → Pair → Bool
  | b0 :: b1 :: c0 :: c1 :: w => blockErrors b0 b1 c0 c1 (errorsOf w)
  | [] => fun _ _ => false
  | [_] => fun _ _ => false
  | [_, _] => fun _ _ => false
  | [_, _, _] => fun _ _ => false

/-- No block of four values is all errors. -/
def burstFree : List Bool → Bool
  | b0 :: b1 :: c0 :: c1 :: w => !(b0 && b1 && c0 && c1) && burstFree w
  | [] => true
  | [_] => true
  | [_, _] => true
  | [_, _, _] => true

/-- Where some block is all errors, both formations err at its two steps. -/
theorem burst_of_not_free : ∀ w : List Bool, burstFree w = false →
    ∃ j, 4 * j + 4 ≤ w.length ∧
      ∀ a, errorsOf w (2 * j + 1) a = true ∧ errorsOf w (2 * j + 2) a = true
  | [], h => Bool.noConfusion h
  | [_], h => Bool.noConfusion h
  | [_, _], h => Bool.noConfusion h
  | [_, _, _], h => Bool.noConfusion h
  | b0 :: b1 :: c0 :: c1 :: w, h => by
    have later : burstFree w = false → ∃ j, 4 * j + 4 ≤ (b0 :: b1 :: c0 :: c1 :: w).length ∧
        ∀ a, errorsOf (b0 :: b1 :: c0 :: c1 :: w) (2 * j + 1) a = true ∧
          errorsOf (b0 :: b1 :: c0 :: c1 :: w) (2 * j + 2) a = true := fun hw =>
      match burst_of_not_free w hw with
      | ⟨j, le, burst⟩ => ⟨j + 1, Nat.add_le_add_right le 4, burst⟩
    cases b0 <;> cases b1 <;> cases c0 <;> cases c1 <;>
      first
      | exact later h
      | exact ⟨0, Nat.le_add_left 4 w.length, fun a => match a with
          | first => ⟨rfl, rfl⟩
          | second => ⟨rfl, rfl⟩⟩

/-- **Where a formation still gives at step `2 k`, errors read from a course of `4 k` values, no
block of the course is all errors**, for every pair of laws keeping mutual withholding. -/
theorem still_gives_free {f g : PairLaw} (wf : KeepsWithheld f) (wg : KeepsWithheld g) {k : Nat}
    {w : List Bool} (len : w.length = 4 * k) {a : Pair}
    (gave : gives f g (errorsOf w) a (2 * k) = true) : burstFree w = true :=
  match hb : burstFree w with
  | true => rfl
  | false => match burst_of_not_free w hb with
    | ⟨j, le, burst⟩ =>
      have jk : j + 1 ≤ k := match Nat.lt_or_ge k (j + 1) with
        | .inr ge => ge
        | .inl lt => absurd (Nat.le_trans le (Nat.le_trans (Nat.le_of_eq len)
            (Nat.mul_le_mul_left 4 (Nat.le_of_lt_succ lt))))
            (fun h => Nat.lt_irrefl (4 * j) (Nat.lt_of_lt_of_le (Nat.lt_succ_self (4 * j))
              (Nat.le_trans (Nat.le_add_right (4 * j + 1) 3) h)))
      have reach : 2 * j + 1 ≤ 2 * k :=
        Nat.le_of_succ_le (Nat.mul_le_mul_left 2 jk)
      Bool.noConfusion ((burst_absorbs_from wf wg (burst first).1 (burst second).1
        (burst first).2 (burst second).2 reach a).symm.trans gave)

/-! ## Counting the courses -/

theorem weight_append (p q : Nat) : ∀ u w : List Bool,
    Typicality.weight p q (u ++ w) = Typicality.weight p q u * Typicality.weight p q w
  | [], _ => (Nat.one_mul _).symm
  | true :: u, w => (congrArg (p * ·) (weight_append p q u w)).trans (mul_assoc_nat _ _ _).symm
  | false :: u, w => (congrArg (q * ·) (weight_append p q u w)).trans (mul_assoc_nat _ _ _).symm

/-- The courses of `n + m` values, read as `m` values before the courses of `n`. -/
theorem total_courses_split (n : Nat) : ∀ (m : Nat) (F : List Bool → Nat),
    total (Typicality.courses (n + m)) F = total (Typicality.courses n) (fun w => total (Typicality.courses m) (fun u => F (u ++ w)))
  | 0, F => Typicality.total_congr (fun w => (Nat.add_zero (F w)).symm) (Typicality.courses n)
  | m + 1, F => by
    show total (Typicality.extend (Typicality.courses (n + m))) F = _
    rw [Typicality.total_extend, total_courses_split n m]
    exact Typicality.total_congr
      (fun w => (Typicality.total_extend (fun u => F (u ++ w)) (Typicality.courses m)).symm) (Typicality.courses n)

/-- What a course weighs where no block is all errors, and nothing elsewhere. -/
def survive (p q : Nat) (w : List Bool) : Nat := cond (burstFree w) (Typicality.weight p q w) 0

theorem cond_and_mul : ∀ (X Y : Bool) (x y : Nat),
    cond (X && Y) (x * y) 0 = cond (X && true) x 0 * cond Y y 0
  | true, true, _, _ => rfl
  | true, false, x, _ => (Nat.mul_zero x).symm
  | false, _, _, _ => (Nat.zero_mul _).symm

/-- What survives multiplies over a block of four values and the rest. -/
theorem survive_four (p q : Nat) (w : List Bool) (b0 b1 c0 c1 : Bool) :
    survive p q ([b0, b1, c0, c1] ++ w) = survive p q [b0, b1, c0, c1] * survive p q w :=
  (congrArg (fun x => cond (!(b0 && b1 && c0 && c1) && burstFree w) x 0)
    (weight_append p q [b0, b1, c0, c1] w)).trans (cond_and_mul _ _ _ _)

theorem nil_of_mem_zero {u : List Bool} (m : u ∈ Typicality.courses 0) : u = [] :=
  have listed : u ∈ ([[]] : List (List Bool)) := m
  match listed with
  | .head _ => rfl
  | .tail _ inside => nomatch inside

/-- A course of four values is four values. -/
theorem shape_of_mem_four {u : List Bool} (mu : u ∈ Typicality.courses 4) :
    ∃ b0 b1 c0 c1 : Bool, u = [b0, b1, c0, c1] :=
  match Typicality.of_mem_extend (ws := Typicality.courses 3) mu with
  | ⟨b0, _, e0, m1⟩ => match Typicality.of_mem_extend (ws := Typicality.courses 2) m1 with
    | ⟨b1, _, e1, m2⟩ => match Typicality.of_mem_extend (ws := Typicality.courses 1) m2 with
      | ⟨c0, _, e2, m3⟩ => match Typicality.of_mem_extend (ws := Typicality.courses 0) m3 with
        | ⟨c1, _, e3, m4⟩ =>
          ⟨b0, b1, c0, c1, e0.trans (congrArg (b0 :: ·) (e1.trans (congrArg (b1 :: ·)
            (e2.trans (congrArg (c0 :: ·) (e3.trans (congrArg (c1 :: ·) (nil_of_mem_zero m4))))))))⟩

/-- Weights multiplying block by block total, over `k` blocks, the `k`-th power of a block's. -/
theorem total_blocks {F G : List Bool → Nat} (one : F [] = 1)
    (mul : ∀ u w, u ∈ Typicality.courses 4 → F (u ++ w) = G u * F w) :
    ∀ k, total (Typicality.courses (4 * k)) F = total (Typicality.courses 4) G ^ k
  | 0 => (Nat.add_zero _).trans one
  | k + 1 =>
    (total_courses_split (4 * k) 4 F).trans
      ((Typicality.total_congr (g := fun w => total (Typicality.courses 4) G * F w)
        (fun w => (SelectionLevels.total_eq_of_mem
          (fun u mu => mul u w mu)).trans
          (Typicality.total_mul_right (F w) G (Typicality.courses 4)))
        (Typicality.courses (4 * k))).trans
        ((Typicality.total_mul _ F _).trans
          ((congrArg (total (Typicality.courses 4) G * ·) (total_blocks one mul k)).trans
            ((Nat.mul_comm _ _).trans (Nat.pow_succ _ _).symm))))

/-- Where an error weighs something, the blocks not all errors weigh less than all blocks. -/
theorem block_lt (p q : Nat) (pos : 0 < p) :
    total (Typicality.courses 4) (survive p q) < total (Typicality.courses 4) (Typicality.weight p q) :=
  have le : ∀ w, survive p q w ≤ Typicality.weight p q w := fun w => by
    show cond (burstFree w) (Typicality.weight p q w) 0 ≤ Typicality.weight p q w
    cases burstFree w with
    | true => exact Nat.le_refl _
    | false => exact Nat.zero_le _
  have W : 0 < Typicality.weight p q [true, true, true, true] :=
    Nat.mul_pos pos (Nat.mul_pos pos (Nat.mul_pos pos (Nat.mul_pos pos (Nat.succ_pos 0))))
  show survive p q [true, true, true, true] + total (Typicality.courses 4).tail (survive p q) <
    Typicality.weight p q [true, true, true, true] + total (Typicality.courses 4).tail (Typicality.weight p q) from
  Nat.lt_of_lt_of_le (Nat.add_lt_add_right W _)
    (Nat.add_le_add_left (Typicality.total_le le _) _)

/-- Whether a formation still gives at step `2 k`, errors read from the course. -/
def stillGives (f g : PairLaw) (k : Nat) (w : List Bool) : Bool :=
  gives f g (errorsOf w) first (2 * k) || gives f g (errorsOf w) second (2 * k)

/-- **Errors by chance end every pair keeping mutual withholding.** For every pair of laws
keeping mutual withholding, the courses of `4 k` values under which a formation still gives at step `2 k` weigh at most
`S ^ k`, out of the whole weight `T ^ k`, where `T = (p + q) ^ 4` is what four values weigh and
`S` what the blocks of four not all errors weigh; where an error weighs something, `S < T`. -/
theorem absorbed_share {f g : PairLaw} (wf : KeepsWithheld f) (wg : KeepsWithheld g) (p q k : Nat) :
    total (Typicality.courses (4 * k)) (fun w => cond (stillGives f g k w) (Typicality.weight p q w) 0) ≤
        total (Typicality.courses 4) (survive p q) ^ k ∧
      total (Typicality.courses (4 * k)) (Typicality.weight p q) = total (Typicality.courses 4) (Typicality.weight p q) ^ k ∧
      total (Typicality.courses 4) (Typicality.weight p q) = (p + q) ^ 4 ∧
      (0 < p → total (Typicality.courses 4) (survive p q) < total (Typicality.courses 4) (Typicality.weight p q)) :=
  ⟨Nat.le_trans (Becoming.total_le (Typicality.courses (4 * k)) fun w mw => by
      show cond (gives f g (errorsOf w) first (2 * k) || gives f g (errorsOf w) second (2 * k))
        (Typicality.weight p q w) 0 ≤ survive p q w
      cases h1 : gives f g (errorsOf w) first (2 * k) with
      | true =>
        show Typicality.weight p q w ≤ cond (burstFree w) (Typicality.weight p q w) 0
        rw [still_gives_free wf wg (Typicality.mem_courses_iff.mp mw) h1]
        exact Nat.le_refl _
      | false =>
        cases h2 : gives f g (errorsOf w) second (2 * k) with
        | true =>
          show Typicality.weight p q w ≤ cond (burstFree w) (Typicality.weight p q w) 0
          rw [still_gives_free wf wg (Typicality.mem_courses_iff.mp mw) h2]
          exact Nat.le_refl _
        | false => exact Nat.zero_le _)
    (Nat.le_of_eq (total_blocks (F := survive p q) rfl (fun u w mu =>
      match u, shape_of_mem_four mu with
      | _, ⟨b0, b1, c0, c1, rfl⟩ => survive_four p q w b0 b1 c0 c1) k)),
   total_blocks (F := Typicality.weight p q) rfl (fun u w _ => weight_append p q u w) k,
   Typicality.total_weight p q 4,
   block_lt p q⟩

/-- The premise is met: the window of two, answering and waiting on both, in any pairing. -/
example (p q k : Nat) := absorbed_share keeps_windowed keeps_answering p q k

/-- A witness, each value weighing one: of the sixteen courses of four values, the window pair
still gives at step `2` under twelve, the four with both formations erring at step `2` ending
it there; the bound is fifteen. -/
theorem window_witness :
    total (Typicality.courses 4) (fun w => cond (stillGives windowed windowed 1 w)
        (Typicality.weight 1 1 w) 0) = 12 ∧
      total (Typicality.courses 4) (survive 1 1) = 15 := by
  decide

end EL7a
end Becoming

#print axioms Becoming.EL7a.window_witness
#print axioms Becoming.EL7a.burst_absorbs
#print axioms Becoming.EL7a.burst_absorbs_from
#print axioms Becoming.EL7a.burst_of_not_free
#print axioms Becoming.EL7a.still_gives_free
#print axioms Becoming.EL7a.total_courses_split
#print axioms Becoming.EL7a.total_blocks
#print axioms Becoming.EL7a.block_lt
#print axioms Becoming.EL7a.absorbed_share
#print axioms Becoming.EL7a.not_keeps_agreeing
#print axioms Becoming.EL7a.survive_four
#print axioms Becoming.EL7a.shape_of_mem_four
#print axioms Becoming.EL7a.weight_append
