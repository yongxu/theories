import Becoming.GuardHorizon

/-! Review 2 (correctness and axioms): proposed additions, written while the machine's load was
above the build threshold, so NOT built. Build with
`python3 -B scratch_build.py <this TREE> Becoming.ReviewCorrectness`. -/

namespace Becoming

universe u v

/-- `ungiven_reading_not_uniform`'s instance has choice over the readings ... -/
theorem ungiven_choice_holds : Viability.ChoiceOver Unit Empty :=
  fun _ each => match each () with | ⟨a, _⟩ => nomatch a

/-- ... and its one reading is given by no configuration: `given` is the hypothesis failing. -/
theorem ungiven_not_given : ¬ ∀ o : Unit, ∃ s : Empty, (fun _ : Empty => ()) s = o :=
  fun given => match given () with | ⟨s, _⟩ => nomatch s

namespace OneCarrierWitness

/-- Situations and acts on one carrier, the requirement as a relation on it: act `a` at `s`
exactly where `a = s` (`statewise_not_uniform`'s example). -/
def R : «际» Bool := fun s a => a = s

/-- The image along the constant reading has a fixed successor. -/
theorem fixed : «定后» («像» (fun _ : Bool => ()) R) :=
  fun x y _ => match x, y with | (), () => rfl

/-- And no response common over the reading's sameness exists. -/
theorem none :
    ¬ ∃ J, «共应» (fun s s' : Bool => (fun _ => ()) s = (fun _ => ()) s') (fun a s => R s a) J :=
  fun ⟨_, inside, covers, closed⟩ => match covers true with
    | ⟨a, holds⟩ =>
      have first : a = true := inside a true holds
      have other : a = false := inside a false (closed a true false holds rfl)
      Bool.noConfusion (first.symm.trans other)

end OneCarrierWitness

/-- Under `«一»`, on an inhabited carrier, a common response exists exactly where one act meets
the requirement everywhere: the form through which `ReadingLoop.PairwiseShared.none_for_all`
would give `«共应之例».PairsNotCommon.none` instead of a parallel witness. -/
theorem «一之共应当且仅当一应遍» {α : Type u} {A : Type v} (s₀ : α) (G : A → α → Prop) :
    (∃ J, «共应» «一» G J) ↔ ∃ a, ∀ s, G a s :=
  ⟨fun ⟨_, inside, covers, closed⟩ => match covers s₀ with
     | ⟨a, holds⟩ => ⟨a, fun s => inside a s (closed a s₀ s holds True.intro)⟩,
   fun ⟨a, all⟩ => ⟨fun b _ => b = a, fun _ s same => same ▸ all s, fun _ => ⟨a, rfl⟩,
     fun _ _ _ same _ => same⟩⟩

end Becoming
