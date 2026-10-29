import Becoming.Clock
import Becoming.PatternPassing
import Becoming.Persistence

/-! Review check (OU3f closure, 29 October 2026): other inductions over steps in the six modules that
keep a region, each re-proved by `kept_onward` with the statement of the original, checked equal
by `example` against the original's type. Compiled against `tree-new/.build`; output in
`family.out`. -/

namespace Becoming

namespace Web

variable {F C : Type} {V : Web F C} {passes : Nat → F → F → Prop}

/-- `ByPassing.trace` (PatternPassing) by closure: the region at `n` is "every formation carrying the
pattern at `S + n` carried it at `S`, or some carrier passed it across one of the `n` steps". -/
theorem ByPassing.trace_byClosure (by_passing : V.ByPassing passes) {S : Nat} :
    ∀ {k : Nat} {a : F}, V.active (S + k) a →
      V.active S a ∨ ∃ j, j < k ∧ V.PassesAt passes (S + j) :=
  fun {k} {x} => kept_onward
    (I := fun n => ∀ x, V.active (S + n) x → V.active S x ∨ ∃ j, j < n ∧ V.PassesAt passes (S + j))
    (a := 0)
    (fun n held x active => match by_passing (S + n) x active with
      | .inl before => match held x before with
        | .inl start => .inl start
        | .inr ⟨j, below, passing⟩ => .inr ⟨j, Nat.lt_succ_of_lt below, passing⟩
      | .inr ⟨b, carrier, given⟩ => .inr ⟨n, Nat.lt_succ_self n, b, x, carrier, given, active⟩)
    (fun _ active => .inl active) (Nat.zero_le k) x

example (by_passing : V.ByPassing passes) {S : Nat} :
    @ByPassing.trace F C V passes by_passing S = @ByPassing.trace_byClosure F C V passes by_passing S :=
  rfl

end Web

/-- `Reidentify.old_still` (Persistence) by closure: naming alike at step `n` as at the first is a
region every step keeps. -/
theorem Reidentify.old_still_byClosure {F F' : Type} {σ : Reidentify F F'}
    (still : ∀ t x, σ.old (t + 1) x = σ.old t x) : ∀ t x, σ.old t x = σ.old 0 x :=
  fun t => kept_onward (I := fun n => ∀ x, σ.old n x = σ.old 0 x)
    (fun n held x => (still n x).trans (held x)) (fun _ => rfl) (Nat.zero_le t)

example {F F' : Type} {σ : Reidentify F F'} (still : ∀ t x, σ.old (t + 1) x = σ.old t x) :
    @Reidentify.old_still F F' σ still = Reidentify.old_still_byClosure still :=
  rfl

#print axioms Web.ByPassing.trace_byClosure
#print axioms Reidentify.old_still_byClosure

namespace Web

variable {F C : Type} {V : Web F C} {passes : Nat → F → F → Prop}

/-- `ByPassing.line_back` (PatternPassing) by closure: the region at `n` is "every formation
carrying the pattern at `S + (n + 1)` lies on the pattern's line from one carrying it at `S`";
its base is the original's case `0`, its step the original's successor case. -/
theorem ByPassing.line_back_byClosure (byPassing : V.ByPassing passes) {S : Nat} :
    ∀ {k : Nat} {a : F}, V.active (S + (k + 1)) a →
      ∃ b, V.active S b ∧
        «相续» (continuationStep (passingContinuation passes)) V.activityClass (S, b)
          (S + (k + 1), a) :=
  fun {k} {x} => kept_onward
    (I := fun n => ∀ x, V.active (S + (n + 1)) x → ∃ b, V.active S b ∧
        «相续» (continuationStep (passingContinuation passes)) V.activityClass (S, b)
          (S + (n + 1), x))
    (a := 0)
    (fun n held x after => match byPassing (S + (n + 1)) x after with
      | .inl before => match held x before with
        | ⟨b, start, line⟩ => ⟨b, start, «及之传递» line
            (.one ⟨⟨rfl, .inl rfl⟩, ⟨fun _ => after, fun _ => before⟩⟩)⟩
      | .inr ⟨_, carrier, given⟩ => match held _ carrier with
        | ⟨b, start, line⟩ => ⟨b, start, «及之传递» line
            (.one ⟨⟨rfl, .inr given⟩, ⟨fun _ => after, fun _ => carrier⟩⟩)⟩)
    (fun x after => match byPassing S x after with
      | .inl before => ⟨x, before, .one ⟨⟨rfl, .inl rfl⟩, ⟨fun _ => after, fun _ => before⟩⟩⟩
      | .inr ⟨b, carrier, given⟩ =>
        ⟨b, carrier, .one ⟨⟨rfl, .inr given⟩, ⟨fun _ => after, fun _ => carrier⟩⟩⟩)
    (Nat.zero_le k) x

example (byPassing : V.ByPassing passes) {S : Nat} :
    @ByPassing.line_back F C V passes byPassing S =
      @ByPassing.line_back_byClosure F C V passes byPassing S :=
  rfl

end Web

#print axioms Web.ByPassing.line_back_byClosure

end Becoming
