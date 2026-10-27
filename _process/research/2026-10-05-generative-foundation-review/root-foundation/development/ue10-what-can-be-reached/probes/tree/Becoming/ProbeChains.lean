import Becoming.ProbeLaws
import Becoming.EventualWidening

/-!
# UE10 review probes, part 4: law 3 stated once, on chains

Probes of the draft `Becoming.ReachableRanges` (review REVIEW-UE10.md). The chain form of keeping
widening (`ProbeUE10.ChainKeepsWidening`, 07's form for any chain of predicates) has both the
draft's law 3 (`ProbeUE10.not_keepsWidening_of_listed_along`, probe B6) and the landed
`Web.KeepsWidening.not_listed` (`Becoming.EventualWidening`) as instances. Nothing here is proposed
for landing as written.
-/

namespace Becoming

namespace ProbeUE10

open Web

/-- **Probe B6, on the web.** Keeping widening by name from `T` (`Web.KeepsWidening itself`) is the
chain form for what the levels admit from `T` on. -/
theorem chain_of_web_keepsWidening {F C : Type} {W : Web F C} {l : Nat → C → Nat} {T : Nat}
    (keeps : W.KeepsWidening itself l T) :
    ChainKeepsWidening (fun n f => W.Admits (l (T + n)) (T + n) f) :=
  ⟨fun n d f admitted =>
     Eq.subst (motive := fun m => W.Admits (l m) m f) (Nat.add_assoc T n d)
       ((includesAcross_itself_iff (Nat.le_add_right (T + n) d)).mp
         (keeps.1 (T + n) (T + n + d) (Nat.le_add_right T n) (Nat.le_add_right (T + n) d)) f admitted),
   fun n => match keeps.2 (T + n) (Nat.le_add_right T n) with
    | ⟨_, later, exceeds⟩ => match exists_steps_between later, (exceedsAcross_itself_iff later).mp exceeds with
      | ⟨d, apart⟩, ⟨g, admitted, before⟩ =>
        ⟨d, g, Eq.subst (motive := fun m => W.Admits (l m) m g) (apart.trans (Nat.add_assoc T n d))
          admitted, before⟩⟩

/-- **Probe B6, on the web.** `Web.KeepsWidening.not_listed` from the chain law. -/
theorem web_not_listed_of_chain {F C : Type} {W : Web F C} {l : Nat → C → Nat} {fs : List F}
    (every : ∀ f, f ∈ fs) {T : Nat} : ¬ W.KeepsWidening itself l T :=
  fun keeps => (chain_of_web_keepsWidening keeps).not_listed ⟨fs, fun _ f _ => every f⟩

end ProbeUE10

end Becoming
