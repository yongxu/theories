import Becoming.Grammar

/-!
# Testing within the net (验)

The one-unfolding plan's 验 (`PLAN.md` §4.4) in the grammar of `Becoming.Grammar`: two occurrences
are told apart by the relations they stand in, within the same net, with no intervener outside it.
The core of a class (`«核»`) is approximated by stages (`«层»`): stage `0` is the class, and stage
`k + 1` asks that each step from either end be matched, at stage `k`, by a step from the other.

* **One direction is a theorem** (`«可分则不在核»`): what some finite stage tells apart is not in
  the core. The core lies in every stage (`«核在每层之内»`).
* **The other direction is a calibration**, not stated here: that what no finite stage tells apart
  lies in the core is the Hennessy–Milner direction, which needs finitely many successors and, in
  its limit form, implies LLPO (`one-unfolding-root/review-checks/HM.lean`, a periphery check).
* **A wider net tells apart what a narrower one does not** (`«恒温与平衡»`): a room in balance with its
  surroundings and a room held by a thermostat are in one core class while no window opens; with the
  window's opening in the net, a first stage tells them apart. The window is part of the net read,
  not an act from outside it. As 《荀子·正名》 has it, 「验之所缘以同异」.

Every declaration has an empty axiom report.
-/

namespace Becoming

universe u

section Stages

variable {α : Type u}

/-- The stages (层) of the core of `E` under `R`: stage `0` is `E`; at stage `k + 1` two
occurrences are alike at stage `k` and each step from either is matched, at stage `k`, by a step
from the other. -/
def «层» (R E : «际» α) : Nat → «际» α
  | 0 => E
  | k + 1 => fun x y => «层» R E k x y ∧
      (∀ v, R x v → ∃ v', R y v' ∧ «层» R E k v v') ∧
      (∀ v', R y v' → ∃ v, R x v ∧ «层» R E k v v')

/-- The core lies in every stage. -/
theorem «核在每层之内» (R E : «际» α) : ∀ k, «则» («核» R E) («层» R E k)
  | 0 => fun _ _ h => («根» R E).1 _ _ h
  | k + 1 => fun x y h =>
    ⟨«核在每层之内» R E k x y h,
     fun v hv => match («有常之逐点» R («核» R E)).mp («根» R E).2.1 x y h v hv with
       | ⟨v', hv', hk⟩ => ⟨v', hv', «核在每层之内» R E k v v' hk⟩,
     fun v' hv' => match («有常之逐点» R («核» R E)).mp («根» R E).2.1 y x
         ((«根» R E).2.2.1 x y h) v' hv' with
       | ⟨v, hv, hk⟩ => ⟨v, hv, «核在每层之内» R E k v v' ((«根» R E).2.2.1 v' v hk)⟩⟩

/-- **What a finite stage tells apart is not in the core (可分则不在核).** -/
theorem «可分则不在核» {R E : «际» α} {x y : α} (h : ∃ k, ¬ «层» R E k x y) : ¬ «核» R E x y :=
  fun hk => match h with
    | ⟨k, hn⟩ => hn («核在每层之内» R E k x y hk)

end Stages

/-! ## A room in balance and a room held: told apart by a wider net -/

/-- Four occurrences: the room in balance, warm (`balanced`); the room held by a thermostat, warm
(`held`); a cold room (`cold`); the held room, still warm after the window opens (`kept`). -/
inductive Room | balanced | held | cold | kept

namespace Room

/-- While no window opens, each warm room goes on as it is. -/
def closed : «际» Room
  | balanced, y => Room.casesOn (motive := fun _ => Prop) y True False False False
  | held, y => Room.casesOn (motive := fun _ => Prop) y False True False False
  | cold, _ => False
  | kept, _ => False

/-- With the window's opening in the net: the balanced room may also cool, and the held room may
also be kept warm by its thermostat. -/
def opened : «际» Room
  | balanced, y => Room.casesOn (motive := fun _ => Prop) y True False True False
  | held, y => Room.casesOn (motive := fun _ => Prop) y False True False True
  | cold, _ => False
  | kept, _ => False

/-- Whether a room is warm. -/
def warm : Room → Bool
  | balanced => true
  | held => true
  | cold => false
  | kept => true

/-- The class "warm or not". -/
def alike : «际» Room := fun x y => warm x = warm y

/-- The relation pairing the two warm rooms, each with itself and with the other. -/
def same : «际» Room
  | balanced, y => Room.casesOn (motive := fun _ => Prop) y True True False False
  | held, y => Room.casesOn (motive := fun _ => Prop) y True True False False
  | cold, _ => False
  | kept, _ => False

theorem same_alike : «则» same alike := by
  intro x y h
  cases x <;> cases y
  all_goals first | rfl | exact False.elim h

theorem same_symm : «则» same («逆» same) := by
  intro x y h
  cases x <;> cases y
  all_goals first | trivial | exact False.elim h

theorem same_constant : «有常» closed same := by
  apply («有常之逐点» closed same).mpr
  intro u u' h v hv
  cases u <;> cases u' <;> cases v
  all_goals first
    | exact False.elim h
    | exact False.elim hv
    | exact ⟨balanced, trivial, trivial⟩
    | exact ⟨held, trivial, trivial⟩

end Room

/-- **A wider net tells apart what a narrower one does not (恒温与平衡).** While no window opens, the
balanced room and the held room are in one core class of "warm or not"; with the window's opening
in the net, the balanced room's cooling has no warm match from the held room, so the first stage
tells them apart and they are not in one core class. -/
theorem «恒温与平衡» :
    «核» Room.closed Room.alike Room.balanced Room.held ∧
      ¬ «核» Room.opened Room.alike Room.balanced Room.held := by
  refine ⟨⟨Room.same, Room.same_alike, Room.same_symm, Room.same_constant, trivial⟩, ?_⟩
  refine «可分则不在核» ⟨1, fun ⟨_, forth, _⟩ => ?_⟩
  match forth Room.cold trivial with
  | ⟨v', hv', hk⟩ =>
    cases v' with
    | balanced => exact False.elim hv'
    | held => exact Bool.noConfusion hk
    | cold => exact False.elim hv'
    | kept => exact Bool.noConfusion hk

end Becoming
