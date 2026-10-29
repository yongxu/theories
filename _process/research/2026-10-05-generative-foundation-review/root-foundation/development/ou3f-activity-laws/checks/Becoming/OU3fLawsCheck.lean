import Becoming.Identity

/-! Reviewer's check, not for landing: OU3f's B1 and B2, the converse law, and a bridge from
`Web.Lineage` to `«迭»` of the continuation restricted to active steps from `M`. -/

namespace Becoming
namespace OU3fLawsCheck

universe u

section Laws

variable {α : Type u}

/-- B1 in `«迭之接»`'s order: its exact converse, with no arithmetic. -/
theorem split_rev {R : «际» α} : ∀ (m : Nat) {n : Nat} {x z : α},
    «迭» R (n + m) x z → ∃ y, «迭» R m x y ∧ «迭» R n y z
  | 0, _, x, _, steps => ⟨x, rfl, steps⟩
  | m + 1, _, _, _, ⟨w, r, rest⟩ => match split_rev m rest with
    | ⟨y, first, second⟩ => ⟨y, ⟨w, r, first⟩, second⟩

/-- B1 as the audit states it (`m + n`, first `m`). -/
theorem split {R : «际» α} (m n : Nat) {x z : α} (steps : «迭» R (m + n) x z) :
    ∃ y, «迭» R m x y ∧ «迭» R n y z :=
  split_rev m (Eq.subst (motive := fun k => «迭» R k x z) (Nat.add_comm m n) steps)

/-- `n` steps lie within the closure. -/
theorem steps_within {R : «际» α} : ∀ (n : Nat) {x y : α}, «迭» R n x y → «所闭» R x y
  | 0, x, _, e => Eq.subst (motive := fun v => «所闭» R x v) e («所闭之自反» R x)
  | n + 1, _, _, ⟨_, r, rest⟩ => «所闭之传递» («缘在所闭» r) (steps_within n rest)

/-- B2, bounded: where whatever is reached in fewer than `n` steps has, as far as can be
refuted, a successor, `n` steps exist as far as can be refuted. -/
theorem far_bounded {R : «际» α} {x : α} : ∀ (n : Nat),
    (∀ k y, k < n → «迭» R k x y → ¬¬ ∃ z, R y z) → ¬¬ ∃ y, «迭» R n x y
  | 0, _ => fun none => none ⟨x, rfl⟩
  | n + 1, more => fun none =>
    far_bounded n (fun k y below steps => more k y (Nat.lt_succ_of_lt below) steps)
      fun ⟨y, steps⟩ => more n y (Nat.lt_succ_self n) steps
        fun ⟨z, r⟩ => none ⟨z, («迭之末步» n).mpr ⟨y, steps, r⟩⟩

/-- B2 as the audit states it, from the bounded form. -/
theorem far {R : «际» α} {x : α} (more : ∀ y, «所闭» R x y → ¬¬ ∃ z, R y z) :
    ∀ n, ¬¬ ∃ y, «迭» R n x y :=
  fun n => far_bounded n fun k y _ steps => more y (steps_within k steps)

/-- Steps read backward are steps of the converse. -/
theorem steps_converse {R : «际» α} : ∀ (n : Nat) {x y : α}, «迭» («逆» R) n x y ↔ «迭» R n y x
  | 0, _, _ => ⟨Eq.symm, Eq.symm⟩
  | n + 1, _, _ => ⟨fun ⟨w, r, rest⟩ => («迭之末步» n).mpr ⟨w, (steps_converse n).mp rest, r⟩,
      fun steps => match («迭之末步» n).mp steps with
        | ⟨w, first, r⟩ => ⟨w, r, (steps_converse n).mpr first⟩⟩

end Laws

section Lineage

open Generative

variable {F C : Type} {W : Web F C} {R : Nat → F → F → Prop}

/-- The active continuation step, restricted to active sources at or after `M`. -/
def stepFrom (W : Web F C) (R : Nat → F → F → Prop) (M : Nat) : «际» (Nat × F) :=
  fun x y => «续» (Web.continuationStep R) W.activityClass x y ∧ M ≤ x.1 ∧ W.active x.1 x.2

theorem pair_eq {x y : Nat × F} (h₁ : x.1 = y.1) (h₂ : x.2 = y.2) : x = y :=
  match x, y, h₁, h₂ with
  | (_, _), (_, _), rfl, rfl => rfl

/-- The bridge, for every `k`, `0` included. -/
theorem lineage_iff_steps {M : Nat} {g : F} : ∀ (k : Nat) {h : F},
    W.Lineage R M g k h ↔ «迭» (stepFrom W R M) k (M, g) (M + k, h)
  | 0, _ => ⟨fun same => congrArg (Prod.mk M) same.symm, fun e => (congrArg Prod.snd e).symm⟩
  | k + 1, h => ⟨fun ⟨h₀, lineage, active₀, cont, active⟩ =>
      («迭之末步» k).mpr ⟨(M + k, h₀), (lineage_iff_steps k).mp lineage,
        ⟨⟨⟨rfl, cont⟩, ⟨fun _ => active, fun _ => active₀⟩⟩, Nat.le_add_right M k, active₀⟩⟩,
    fun steps => match («迭之末步» k).mp steps with
      | ⟨y, first, ⟨⟨⟨next, cont⟩, alike⟩, _, active₀⟩⟩ =>
        have same : M + k = y.1 := Nat.succ.inj next
        ⟨y.2, (lineage_iff_steps k).mpr
            (Eq.subst (motive := fun v => «迭» (stepFrom W R M) k (M, g) (v, y.2)) same.symm first),
          Eq.subst (motive := fun s => W.active s y.2) same.symm active₀,
          Eq.subst (motive := fun s => R s y.2 h) same.symm cont,
          alike.mp active₀⟩⟩

/-- `Web.Lineage.unique` from `«迭之定»`: the restricted step has a fixed successor. -/
theorem unique {M : Nat} {g : F}
    (noSplit : ∀ s, M ≤ s → ∀ g f f', W.active s g → R s g f → R s g f' →
      W.active (s + 1) f → W.active (s + 1) f' → f = f')
    {k : Nat} {h h' : F} (l : W.Lineage R M g k h) (l' : W.Lineage R M g k h') : h = h' :=
  congrArg Prod.snd («迭之定» (R := stepFrom W R M)
    («定后之逐点».mpr fun x y z ⟨⟨⟨ny, ry⟩, ay⟩, le, ax⟩ ⟨⟨⟨nz, rz⟩, az⟩, _, _⟩ =>
      pair_eq (ny.trans nz.symm) (noSplit x.1 le x.2 y.2 z.2 ax ry rz
        (Eq.subst (motive := fun s => W.active s y.2) ny (ay.mp ax))
        (Eq.subst (motive := fun s => W.active s z.2) nz (az.mp ax))))
    k ((lineage_iff_steps k).mp l) ((lineage_iff_steps k).mp l'))

/-- `Web.Lineage.origin` from `«迭之定前»`: the restricted step merges nothing. -/
theorem origin {M : Nat}
    (noMerge : ∀ s, M ≤ s → ∀ g g' f, W.active s g → W.active s g' → R s g f → R s g' f →
      W.active (s + 1) f → g = g')
    {k : Nat} {g g' h : F} (l : W.Lineage R M g k h) (l' : W.Lineage R M g' k h) : g = g' :=
  congrArg Prod.snd («迭之定前» (R := stepFrom W R M)
    («定前之逐点».mpr fun x y z ⟨⟨⟨nx, rx⟩, ax⟩, le, actx⟩ ⟨⟨⟨ny, ry⟩, _⟩, _, acty⟩ =>
      have same : x.1 = y.1 := Nat.succ.inj (nx.symm.trans ny)
      pair_eq same (noMerge x.1 le x.2 y.2 z.2 actx
        (Eq.subst (motive := fun s => W.active s y.2) same.symm acty) rx
        (Eq.subst (motive := fun s => R s y.2 z.2) same.symm ry)
        (Eq.subst (motive := fun s => W.active s z.2) nx (ax.mp actx))))
    k ((lineage_iff_steps k).mp l) ((lineage_iff_steps k).mp l'))

/-- The statements are the real ones. -/
example {M : Nat} {g : F} (noSplit : ∀ s, M ≤ s → ∀ g f f', W.active s g → R s g f → R s g f' →
      W.active (s + 1) f → W.active (s + 1) f' → f = f') {k : Nat} {h h' : F} :
    W.Lineage R M g k h → W.Lineage R M g k h' → h = h' :=
  fun l l' => Web.Lineage.unique noSplit l l'

end Lineage

end OU3fLawsCheck
end Becoming
