import Becoming.Prelude

/-!
# PredicateIteration: finite bounds on repeated steps on predicates

`Iteration.iter Φ V₀ n` is the predicate `V₀` after the step `Φ` has been applied `n` times.
For a step that preserves inclusion (`Iteration.MonotoneStep`) and whose value at the start lies
inside the start, each iterate lies inside the one before (`Iteration.iter_pred`). If a list
holds every state of the start, the iterate at the list's length lies inside the next
(`Iteration.iter_persists`), and it is the largest class inside the start that lies inside its
own step (`Iteration.iter_largest`). If the start is the step applied to the predicate true
everywhere and a list of length n + 1 holds every state, iterate n lies inside iterate n + 1
(`Iteration.iter_persists_from_all`). Given a member x of a list, `remove_mem` gives a list one
shorter such that each member of the original equals x or is on the shorter list.

For a monotone step whose start lies inside its own first step, each iterate lies inside the
next (`Iteration.iter_succ`). Let G be that y is in the iterate at a list's length. If the step
commutes with implication to G (`Iteration.CommutesWithImplication`) and the list holds every
state at which membership in the start implies G, then y in any iterate is in the iterate at the
list's length (`Iteration.iter_within_length`). Without the commuting premise this cannot be had
with nothing decided: asked of every monotone step on a one-state type from the empty start, it
decides every proposition (`Iteration.singleton_rise_needs_em`, in `Becoming.RisingIteration`).

For a monotone step, a family whose start and successor clauses agree pointwise with those of
iteration agrees pointwise with every iterate (`Iteration.iter_iff_stages`), so a notion defined
by recursion on the number of steps can be identified with an iterate.
At the type of predicates, `Iteration.iter` has the equations of `Law.orbit`
(`Becoming.Recurrence`) and equals it at each step (`Tolerance.iter_eq_orbit`); it is defined here
so that modules which do not import `Becoming.Recurrence` can use it.

The two lemmas on lists are `remove_mem` and `gather_listed`. The falling bound has one induction
on the list of remaining places (`Iteration.extend_at_places`).
-/

namespace Becoming

universe u

variable {X : Type u} in
/-- If x is on a list, some list is one shorter and each member of the original equals x or is on
it. -/
theorem remove_mem : ∀ {l : List X} {x : X}, x ∈ l →
    ∃ l' : List X, l'.length + 1 = l.length ∧ ∀ y, y ∈ l → y = x ∨ y ∈ l'
  | [], _, mem => nomatch mem
  | a :: t, _, mem => match mem_cons_cases mem with
    | .inl same => ⟨t, rfl, fun _ mem' => match mem_cons_cases mem' with
      | .inl here => .inl (here.trans same.symm)
      | .inr later => .inr later⟩
    | .inr later => match remove_mem later with
      | ⟨t', shorter, rest⟩ => ⟨a :: t', congrArg (· + 1) shorter, fun y mem' =>
        match mem_cons_cases mem' with
        | .inl here => .inr (Eq.subst (motive := fun w => w ∈ a :: t') here.symm (.head t'))
        | .inr later' => match rest y later' with
          | .inl same => .inl same
          | .inr kept => .inr (.tail a kept)⟩

variable {A : Type u} in
/-- If `(D a → G) → G` holds for every listed member a, and having D at every listed member
implies G, then G holds. `not_not_all` of `Becoming.Prelude` is this at `G = False`. -/
theorem gather_listed {D : A → Prop} {G : Prop} : ∀ (members : List A),
    (∀ a, a ∈ members → (D a → G) → G) → ((∀ a, a ∈ members → D a) → G) → G
  | [], _, finish => finish fun _ mem => nomatch mem
  | a :: rest, each, finish => each a (.head _) fun head =>
    gather_listed rest (fun b mem => each b (.tail a mem)) fun tail =>
      finish fun b mem => match mem_cons_cases mem with
        | .inl rfl => head
        | .inr later => tail b later

namespace Iteration

variable {S : Type u}

/-! ## Steps from a predicate into itself -/

section Falling
/-- The zeroth iterate is the start, and iterate n + 1 is the step applied to iterate n. -/
def iter (Φ : (S → Prop) → S → Prop) (V₀ : S → Prop) : Nat → S → Prop
  | 0 => V₀
  | n + 1 => Φ (iter Φ V₀ n)

/-- A step is monotone if whenever one predicate lies inside another, the step of the first lies
inside the step of the second. -/
abbrev MonotoneStep (Φ : (S → Prop) → S → Prop) :=
  ∀ {X Y : S → Prop}, (∀ z, X z → Y z) → ∀ y, Φ X y → Φ Y y

/-- For a monotone step, any family with the same start and successor clauses as iteration
agrees with the iterates at every level. -/
theorem iter_iff_stages {T : Type u} {Φ : (T → Prop) → T → Prop} {start : T → Prop}
    {stage : Nat → T → Prop} (mono : MonotoneStep Φ) (zero : ∀ z, start z ↔ stage 0 z)
    (next : ∀ n z, Φ (stage n) z ↔ stage (n + 1) z) :
    ∀ n z, iter Φ start n z ↔ stage n z
  | 0 => zero
  | n + 1 => fun z => Iff.trans
    ⟨mono (fun t => (iter_iff_stages mono zero next n t).mp) z,
     mono (fun t => (iter_iff_stages mono zero next n t).mpr) z⟩ (next n z)

variable {Φ : (S → Prop) → S → Prop} {V₀ : S → Prop}
  (mono : MonotoneStep Φ) (start : ∀ y, Φ V₀ y → V₀ y)

include mono start

/-- If a monotone step takes the start into itself, each iterate lies in the preceding one. -/
theorem iter_pred : ∀ n y, iter Φ V₀ (n + 1) y → iter Φ V₀ n y
  | 0 => start
  | n + 1 => mono (iter_pred n)

omit start in
/-- For a monotone step, any class containing the start and closed under the step contains every
iterate. Order-dual of `postfixed_in_iter`. -/
theorem prefixed_above_iter {K : S → Prop} (above : ∀ y, V₀ y → K y)
    (pre : ∀ y, Φ K y → K y) : ∀ n y, iter Φ V₀ n y → K y
  | 0 => above
  | n + 1 => fun y h => pre y (mono (prefixed_above_iter above pre n) y h)

/-- If a monotone step takes the start into itself, every iterate lies in the start. -/
theorem iter_within : ∀ n y, iter Φ V₀ n y → V₀ y :=
  prefixed_above_iter mono (fun _ h => h) start

/-- Suppose a monotone step takes the start into itself and a list has length n. If every state in
the start is on the list or in iterate n + 1, every state in iterate n is in iterate n + 1. -/
theorem extend_at_places : ∀ (n : Nat) (left : List S), left.length = n →
    (∀ z, V₀ z → z ∈ left ∨ iter Φ V₀ (n + 1) z) → ∀ y, iter Φ V₀ n y → iter Φ V₀ (n + 1) y
  | 0, _, len, cover, y, kept =>
    (cover y kept).elim (fun mem => nomatch (nil_of_length_zero len ▸ mem : y ∈ ([] : List S))) id
  | n + 1, _, len, cover, y, kept =>
    match cover y (iter_within mono start _ y kept) with
    | .inr enough => enough
    | .inl mem => match remove_mem mem with
      | ⟨rest, size, place⟩ =>
        have shorter := Nat.succ.inj (size.trans len)
        have nextCover (z : S) (inside : V₀ z) : z ∈ rest ∨ iter Φ V₀ (n + 1) z :=
          match cover z inside with
          | .inr earlier => .inr (iter_pred mono start _ z earlier)
          | .inl listed => match place z listed with
            | .inl same => .inr (same.symm ▸ kept)
            | .inr unused => .inl unused
        mono (extend_at_places n rest shorter nextCover) y kept

/-- If a monotone step takes the start into itself and all starting states are listed,
any state in the iterate at the list length belongs to the next iterate. -/
theorem iter_persists {all : List S} (within : ∀ x, V₀ x → x ∈ all) {y : S} :
    iter Φ V₀ all.length y → iter Φ V₀ (all.length + 1) y :=
  extend_at_places mono start all.length all rfl (fun z h => .inl (within z h)) y

/-- If a monotone step takes the start into itself and all starting states are listed,
the iterate at the list length lies inside the step applied to that iterate. -/
theorem iter_postfixed {all : List S} (within : ∀ x, V₀ x → x ∈ all) :
    ∀ y, iter Φ V₀ all.length y → Φ (iter Φ V₀ all.length) y :=
  fun _ => iter_persists mono start within

omit start in
/-- For a monotone step, a class inside the start that the step preserves lies in every iterate. -/
theorem postfixed_in_iter {K : S → Prop} (inside : ∀ y, K y → V₀ y)
    (post : ∀ y, K y → Φ K y) : ∀ n y, K y → iter Φ V₀ n y
  | 0 => inside
  | n + 1 => fun y h => mono (postfixed_in_iter inside post n) y (post y h)

/-- If a monotone step takes the start into itself and all starting states are listed,
a state lies in the iterate at the list length exactly when it lies in every iterate. -/
theorem iter_iff_all {all : List S} (within : ∀ x, V₀ x → x ∈ all) {y : S} :
    iter Φ V₀ all.length y ↔ ∀ n, iter Φ V₀ n y :=
  ⟨fun h n => postfixed_in_iter mono (iter_within mono start _)
      (iter_postfixed mono start within) n y h,
   fun h => h all.length⟩

/-- If a monotone step takes the start into itself and all starting states are listed,
the iterate at the list length is the largest class inside the start that the step preserves. -/
theorem iter_largest {all : List S} (within : ∀ x, V₀ x → x ∈ all) :
    let L := iter Φ V₀ all.length
    (∀ y, L y → V₀ y) ∧ (∀ y, L y → Φ L y) ∧
      ∀ K : S → Prop, (∀ y, K y → V₀ y) → (∀ y, K y → Φ K y) → ∀ y, K y → L y :=
  ⟨iter_within mono start _, iter_postfixed mono start within,
   fun _ inside post => postfixed_in_iter mono inside post _⟩

omit start in
/-- For a monotone step, if the start agrees pointwise with one step from U, iterate n agrees with
iterate n + 1 from U. -/
theorem iter_shift {U : S → Prop} (first : ∀ y, V₀ y ↔ Φ U y) :
    ∀ n y, iter Φ V₀ n y ↔ iter Φ U (n + 1) y :=
  iter_iff_stages (stage := fun n => iter Φ U (n + 1)) mono first (fun _ _ => Iff.rfl)

omit start in
/-- Suppose a monotone step applied to the predicate true everywhere agrees pointwise with the
start. If a list of length n + 1 holds every state, each state in iterate n is in iterate n + 1. -/
theorem iter_persists_from_all {all : List S} (every : ∀ x, x ∈ all)
    (first : ∀ y, V₀ y ↔ Φ (fun _ => True) y) {n : Nat} (len : all.length = n + 1) {y : S} :
    iter Φ V₀ n y → iter Φ V₀ (n + 1) y :=
  have next : iter Φ (fun _ => True) (n + 1) y → iter Φ (fun _ => True) (n + 1 + 1) y :=
    len ▸ iter_persists mono (fun _ _ => trivial) (fun x _ => every x) (y := y)
  fun kept => (iter_shift mono first (n + 1) y).mpr (next ((iter_shift mono first n y).mp kept))

/-- If a monotone step takes the start into itself and all starting states are listed, absence from
the iterate one past the list length implies absence from the iterate at the list length. -/
theorem not_iter_of_not_succ {all : List S} (within : ∀ x, V₀ x → x ∈ all) {y : S} :
    ¬ iter Φ V₀ (all.length + 1) y → ¬ iter Φ V₀ all.length y :=
  fun fails kept => fails (iter_persists mono start within kept)
end Falling

/-! ## Steps on implications to a proposition -/

section Implications
variable {Ψ : (S → Prop) → S → Prop} {W₀ : S → Prop} {G : Prop}

/-- Take as input to Ψ the states t where X t implies G. The implication step holds at z
when membership of z in that output implies G. -/
def givesStep (Ψ : (S → Prop) → S → Prop) (G : Prop) (X : S → Prop) (z : S) : Prop :=
  Ψ (fun t => X t → G) z → G

/-- If Ψ is monotone, its step on implications to G is monotone. -/
theorem gives_mono (mono : MonotoneStep Ψ) : MonotoneStep (givesStep Ψ G) :=
  fun sub z h k => h (mono (fun t f x => f (sub t x)) z k)

/-- For a predicate W, consider the states t where (W t → G) → G. The step commutes with G
if, for every W and z, membership of z in the step of this class suffices for G whenever membership
of z in the step of W suffices for G. -/
def CommutesWithImplication (Ψ : (S → Prop) → S → Prop) (G : Prop) : Prop :=
  ∀ (W : S → Prop) z, Ψ (fun t => (W t → G) → G) z → (Ψ W z → G) → G

variable (mono : MonotoneStep Ψ) (start : ∀ y, W₀ y → Ψ W₀ y) (comm : CommutesWithImplication Ψ G)
local notation "I" => iter Ψ W₀

include mono comm in
/-- Suppose the step is monotone and the step commutes with G. Membership of z in iterate n
from W₀ implies G exactly when z belongs to iterate n of the implication step from the states
where W₀ implies G. -/
theorem imp_iff_iter_gives : ∀ n z, (I n z → G) ↔ iter (givesStep Ψ G) (fun x => W₀ x → G) n z :=
  fun n z => (iter_iff_stages (stage := fun m t => I m t → G) (gives_mono mono) (fun _ => Iff.rfl)
    (fun _ t => ⟨fun f h => f (mono (fun _ w k => k w) t h), fun h k => comm _ t k h⟩) n z).symm

include mono start
/-- If Ψ is monotone and W₀ lies inside Ψ W₀, each iterate from W₀ lies in the next. -/
theorem iter_succ : ∀ n z, I n z → I (n + 1) z
  | 0 => start
  | n + 1 => mono (iter_succ n)

/-- If W₀ lies inside Ψ W₀ and Ψ is monotone, the implication step takes the states
where W₀ implies G into that same predicate. -/
theorem gives_start (z : S) : givesStep Ψ G (fun t => W₀ t → G) z → (W₀ z → G) :=
  fun h w => h (mono (fun _ x k => k x) z (start z w))

variable {all : List S} {y : S}

include comm in
/-- Suppose the step is monotone, the start lies inside its own step, and the step commutes
with G. If a list of length n holds every x where W₀ x implies G, and membership of y in iterate n
from W₀ implies G, then membership of y in iterate n + 1 from W₀ also implies G. -/
theorem iter_gives_persists (within : ∀ x, (W₀ x → G) → x ∈ all) :
    (I all.length y → G) → I (all.length + 1) y → G :=
  fun h => (imp_iff_iter_gives mono comm _ y).mpr (iter_persists (gives_mono mono)
    (gives_start mono start) within ((imp_iff_iter_gives mono comm _ y).mp h))

/-- Let n be the list length and G mean that y belongs to iterate n from W₀. Suppose the step
is monotone, the start lies inside its own step, and the step commutes with G. If the list holds
every x where W₀ x implies G, membership of y in iterate n + 1 from W₀ implies G. -/
theorem iter_shortens (comm : CommutesWithImplication Ψ (I all.length y))
    (within : ∀ x, (W₀ x → I all.length y) → x ∈ all) : I (all.length + 1) y → I all.length y :=
  iter_gives_persists mono start comm within id

/-- Let n be the list length and G mean that y belongs to iterate n from W₀. Suppose the step
is monotone, the start lies inside its own step, and the step commutes with G. If the list holds
every x where W₀ x implies G, membership of y in any iterate from W₀ implies G. -/
theorem iter_within_length (comm : CommutesWithImplication Ψ (I all.length y))
    (within : ∀ x, (W₀ x → I all.length y) → x ∈ all) : ∀ n, I n y → I all.length y :=
  fun n => (imp_iff_iter_gives mono comm n y).mpr ((iter_iff_all (gives_mono mono)
    (gives_start mono start) within).mp ((imp_iff_iter_gives mono comm _ y).mp id) n)

/-- Let a list of length n + 1 hold every state, and let G mean that y belongs to iterate n
from W₀. Suppose the step is monotone, the start lies inside its own step, and the step commutes
with G. If the states where W₀ implies G are exactly those in one implication step from all states,
membership of y in any iterate from W₀ implies G. -/
theorem iter_within_pred_length {n : Nat} (every : ∀ x, x ∈ all) (len : all.length = n + 1)
    (comm : CommutesWithImplication Ψ (I n y))
    (first : ∀ z, (W₀ z → I n y) ↔ givesStep Ψ (I n y) (fun _ => True) z) :
    ∀ m, I m y → I n y :=
  fun m => (imp_iff_iter_gives mono comm m y).mpr
    (postfixed_in_iter (gives_mono mono) (iter_within (gives_mono mono) (gives_start mono start) n)
      (fun _ => iter_persists_from_all (gives_mono mono) every first len)
      m y ((imp_iff_iter_gives mono comm n y).mp id))
end Implications

end Iteration

end Becoming
