import Becoming.HeldPossible

/-!
# UE11 review probe: an adaptive witness

`RisingRule`: a system changing its own rule (`adaptive`), the rule rising by one at every move
and the state staying; a configuration admits what lies at most its rule. With the rule held no
move is taken, so the possible with the rule held is what is admitted now; along the course it
keeps widening, in 07's form, while from every configuration of the course every formation is
possible. It shows only that the premise of `Run.adaptive_rule_changes_of_keepsWidening` can be
met; it is degenerate, the held possible growing with no held move. Evidence for the review, not
proposed for landing as written.
-/

namespace Becoming.ProbeUE11

open Generative

namespace RisingRule

/-- The state stays and the rule rises by one at every move. -/
def process : Process (Nat × Nat) Unit := adaptive (fun _ x _ => x) (fun g _ => g + 1)

/-- A configuration admits what lies at most its rule. -/
def adm (s : Nat × Nat) (y : Nat) : Prop := y ≤ s.2

/-- The rule the same. -/
def Same (s t : Nat × Nat) : Prop := t.2 = s.2

/-- The course from state `0` and rule `0`. -/
def course : Run process := ⟨fun k => (0, k), fun _ => (), fun _ => rfl⟩

/-- With the rule held, a configuration reaches only itself. -/
theorem held_stays : ∀ {as : List Unit} {s t : Nat × Nat}, Trace (keeping process Same) s as t →
    t = s
  | [], _, _, .nil _ => rfl
  | _ :: _, s, _, .cons kept _ =>
    absurd (Nat.le_of_eq ((congrArg Prod.snd kept.1).symm.trans kept.2)) (Nat.not_succ_le_self s.2)

/-- **With the rule held, the possible at step `k` is what lies at most `k`.** -/
theorem held_iff (k y : Nat) :
    Reaching.PossibleHeld process Same adm (course.state k) y ↔ y ≤ k :=
  ⟨fun ⟨_, ⟨_, trace⟩, admitted⟩ =>
     Eq.subst (motive := fun z => adm z y) (held_stays trace) admitted,
   fun le => ⟨course.state k, Reach.refl _ _, le⟩⟩

/-- **With the rule held, the possible keeps widening along the course.** -/
theorem held_keeps_widening :
    Reaching.KeepsWidening (fun k => Reaching.PossibleHeld process Same adm (course.state k)) :=
  ⟨fun n d y held => (held_iff (n + d) y).mpr
     (Nat.le_trans ((held_iff n y).mp held) (Nat.le_add_right n d)),
   fun n => ⟨1, n + 1, (held_iff (n + 1) (n + 1)).mpr (Nat.le_refl _),
     fun held => Nat.not_succ_le_self n ((held_iff n (n + 1)).mp held)⟩⟩

/-- **From every configuration of the course every formation is possible.** -/
theorem whole_every (k y : Nat) : Reaching.Possible process adm (course.state k) y :=
  ⟨course.state (k + y), course.reach k y, Nat.le_add_left y k⟩

end RisingRule

end Becoming.ProbeUE11
