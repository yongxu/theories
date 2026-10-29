import Becoming.GrammarLaws

/-!
# A region every step keeps holds from where it holds on

`kept_onward`: a region of the steps of time that every step keeps, holding at step `a`, holds at
every later step. It is the grammar's closure at the successor relation, and nothing else: the
steps from `a` to `b` are a line (`«线则所闭»`: every place of a line lies within the closure from
its first place), and a region closed under a relation holds whatever lies within the closure
from a place where it holds (`«闭含所闭»`). So an induction over steps that keeps a region is a
case of closure, as `Becoming.Pace`'s `stays` is (board items EC6b, OU3f). No process and no run
is needed; the successor law's run (`Law.run Nat.succ`, with `Law.succ_orbit`, in
`Becoming.Recurrence`) gives the same law through `Invariant.reach`.

**Where it belongs.** Its home is beside `«线则所闭»` in `Becoming.GrammarLaws`, among the line
laws. It is stated here, importing only `Becoming.GrammarLaws`, so that adding it rebuilds only
the modules that use it, not every module above the grammar; it moves there at the next full
rebuild of the package.
-/

namespace Becoming

/-- **A region every step keeps holds from where it holds on.** A region of the steps of time
that every step keeps, holding at step `a`, holds at every later step `b`: the steps from `a` to
`b` are a line under the successor (`«线则所闭»`), and a closed region holds what lies within the
closure from where it holds (`«闭含所闭»`). -/
theorem kept_onward {I : Nat → Prop} (keeps : ∀ n, I n → I (n + 1)) {a b : Nat} (holds : I a)
    (later : a ≤ b) : I b :=
  match le_dest later with
  | ⟨k, at_⟩ => Eq.subst (motive := I) at_.symm
      («闭含所闭» (R := fun x y => y = x + 1)
        (fun x _ held stepped => Eq.subst (motive := I) stepped.symm (keeps x held)) holds
        («线则所闭» (g := fun i => a + i) (N := k) (fun _ _ => rfl) k (Nat.le_refl k)))

end Becoming
