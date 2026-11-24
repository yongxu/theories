import Becoming.Prelude
import GenerativeCore

/-!
# Relational Spans, Oplax History Comparisons, Beck–Chevalley Criteria, and Generic Trace Transport (`Becoming.RelSpan` / `Becoming.OplaxHistory` Parts 0–2)

AI-written (`Wave U6`, 24 November 2026; factored into `Becoming.RelSpan` in `Wave 3` Track A3, 25 November 2026). Every declaration compiles from Lean's prelude alone with an empty axiom report (`0` axioms, `0` `propext`, `0` `Classical.choice`, `0` `Quot.sound`, `0` `sorry`, `0` `private` declarations, `0` unnamed `instance`s, and `0` economic metaphors).

This module houses the lower-level `Span(F)` comparison, all-`n` bracketing coherence, macro refinement functoriality, same-square Beck–Chevalley equivalence (`chi_bijective_iff_bc_all`), emergent and `C₂`-orbit relational obstructions (`EmergentCrossSeamWitness`, `C2RelativeLossWitness`) under `Becoming.OplaxHistory.*` for full API compatibility, together with `Becoming.RelSpan.mapTrace` for generic action-relabeled forward `Trace` transport.

What is not shown: whether any empirical system realizes a `SpanFunctor` or satisfies Beck–Chevalley (`AGENTS.md` Rule 2). No ethical premise or ranking occurs.
-/

namespace Becoming

namespace OplaxHistory

/-! ## Part 0: Constructive Data Carriers and Bijection Helpers (Prelude-Only, 0 Axioms) -/

/-- Constructive bijection between two types without `propext` or `Classical.choice`. -/
structure Bij (A B : Type) where
  toFun : A → B
  invFun : B → A
  left_inv : ∀ a, invFun (toFun a) = a
  right_inv : ∀ b, toFun (invFun b) = b

/-- Identity constructive bijection. -/
def Bij.refl (A : Type) : Bij A A where
  toFun a := a
  invFun a := a
  left_inv _ := rfl
  right_inv _ := rfl

/-- Composition of constructive bijections. -/
def Bij.trans {A B C : Type} (f : Bij A B) (g : Bij B C) : Bij A C where
  toFun a := g.toFun (f.toFun a)
  invFun c := f.invFun (g.invFun c)
  left_inv a := (congrArg f.invFun (g.left_inv (f.toFun a))).trans (f.left_inv a)
  right_inv c := (congrArg g.toFun (f.right_inv (g.invFun c))).trans (g.right_inv c)

/-- Symmetry of constructive bijections. -/
def Bij.symm {A B : Type} (f : Bij A B) : Bij B A where
  toFun := f.invFun
  invFun := f.toFun
  left_inv := f.right_inv
  right_inv := f.left_inv

/-- Injectivity predicate. -/
def Inj {A B : Type} (f : A → B) : Prop :=
  ∀ a₁ a₂, f a₁ = f a₂ → a₁ = a₂

/-- Surjectivity predicate. -/
def Surj {A B : Type} (f : A → B) : Prop :=
  ∀ b, ∃ a, f a = b

/-- Intuitionistic bijectivity predicate (`Inj f ∧ Surj f`), needing zero choice or `propext`. -/
def IsBijective {A B : Type} (f : A → B) : Prop :=
  Inj f ∧ Surj f

theorem isBijective_of_bij {A B : Type} (b : Bij A B) : IsBijective b.toFun :=
  ⟨fun a₁ a₂ eq => (b.left_inv a₁).symm.trans ((congrArg b.invFun eq).trans (b.left_inv a₂)),
   fun y => ⟨b.invFun y, b.right_inv y⟩⟩

/-- Boolean power of two (`2 ^ n`) computed recursively without extra axioms. -/
def powTwo : Nat → Nat
  | 0 => 1
  | n + 1 => powTwo n + powTwo n

theorem powTwo_pos : ∀ n : Nat, 0 < powTwo n
  | 0 => Nat.zero_lt_one
  | n + 1 => Nat.add_pos_left (powTwo_pos n) (powTwo n)

/-- Dependent `Eq.rec` injectivity on equal indices without `propext` or `HEq`. -/
theorem eqRec_inj {α : Type} (T : α → Type) {a b : α} (h : a = b) {x y : T a}
    (e : (h ▸ x : T b) = (h ▸ y : T b)) : x = y := by
  cases h
  exact e

/-! ## Part 1: Relational Spans, General Functor Oplax Comparison (`S1`, `S2`, `S5`), & Macro Refinement -/

/-- A relational span `A ← W → B` over arbitrary carrier types. -/
structure RelSpan (A B : Type) where
  W : Type
  left : W → A
  right : W → B

/-- A morphism of relational spans fixing endpoints `A` and `B`. -/
structure SpanHom {A B : Type} (H K : RelSpan A B) where
  map : H.W → K.W
  left_eq : ∀ w, K.left (map w) = H.left w
  right_eq : ∀ w, K.right (map w) = H.right w

/-- Identity span morphism. -/
def SpanHom.id {A B : Type} (H : RelSpan A B) : SpanHom H H where
  map w := w
  left_eq _ := rfl
  right_eq _ := rfl

/-- Composition of span morphisms. -/
def SpanHom.comp {A B : Type} {H K L : RelSpan A B}
    (g : SpanHom K L) (f : SpanHom H K) : SpanHom H L where
  map w := g.map (f.map w)
  left_eq w := (g.left_eq (f.map w)).trans (f.left_eq w)
  right_eq w := (g.right_eq (f.map w)).trans (f.right_eq w)

/-- Pointwise equality on span morphisms (avoids `funext`). -/
def SpanHomEq {A B : Type} {H K : RelSpan A B} (f g : SpanHom H K) : Prop :=
  ∀ w, f.map w = g.map w

/-- Identity span on a carrier type `D`. -/
def idSpan (D : Type) : RelSpan D D where
  W := D
  left d := d
  right d := d

/-- Pullback element for two composable maps `r : W₁ → D` and `l : W₂ → D`. -/
structure PullbackElem {W₁ W₂ D : Type} (r : W₁ → D) (l : W₂ → D) where
  fst : W₁
  snd : W₂
  mid : r fst = l snd

/-- Zero-axiom equality of two `PullbackElem`s from equal components (avoids `.injEq` / `propext`). -/
theorem PullbackElem.ext {W₁ W₂ D : Type} {r : W₁ → D} {l : W₂ → D}
    {p q : PullbackElem r l} (h1 : p.fst = q.fst) (h2 : p.snd = q.snd) : p = q := by
  cases p with
  | mk a₁ b₁ m₁ =>
    cases q with
    | mk a₂ b₂ m₂ =>
      change a₁ = a₂ at h1
      change b₁ = b₂ at h2
      subst h1
      subst h2
      rfl

/-- Pullback composition `H ⋆ K` of two spans `A ← W₁ → D` and `D ← W₂ → C`. -/
def compSpan {A D C : Type} (H : RelSpan A D) (K : RelSpan D C) : RelSpan A C where
  W := PullbackElem H.right K.left
  left p := H.left p.fst
  right p := K.right p.snd

/-- Pullback-induced morphism between composite spans from compatible step morphisms. -/
def compSpanHom {A D C : Type} {H H' : RelSpan A D} {K K' : RelSpan D C}
    (a : SpanHom H H') (b : SpanHom K K') :
    SpanHom (compSpan H K) (compSpan H' K') where
  map p :=
    ⟨a.map p.fst, b.map p.snd,
      (a.right_eq p.fst).trans (p.mid.trans (b.left_eq p.snd).symm)⟩
  left_eq p := a.left_eq p.fst
  right_eq p := b.right_eq p.snd

/-- Left unitor `idSpan A ⋆ H → H` for relational spans. -/
def unitLeftHom {A B : Type} (H : RelSpan A B) : SpanHom (compSpan (idSpan A) H) H where
  map p := p.snd
  left_eq p := p.mid.symm
  right_eq _ := rfl

/-- Right unitor `H ⋆ idSpan B → H`. -/
def unitRightHom {A B : Type} (H : RelSpan A B) : SpanHom (compSpan H (idSpan B)) H where
  map p := p.fst
  left_eq _ := rfl
  right_eq p := p.mid

/-- Associator `(H ⋆ K) ⋆ L → H ⋆ (K ⋆ L)` for span composition. -/
def assocHom {A B C E : Type} (H : RelSpan A B) (K : RelSpan B C) (L : RelSpan C E) :
    SpanHom (compSpan (compSpan H K) L) (compSpan H (compSpan K L)) where
  map p := ⟨p.fst.fst, ⟨p.fst.snd, p.snd, p.mid⟩, p.fst.mid⟩
  left_eq _ := rfl
  right_eq _ := rfl

/-- A functor on types acting constructively and respecting pointwise congruence (zero `funext`). -/
structure SpanFunctor where
  obj : Type → Type
  map : {X Y : Type} → (X → Y) → obj X → obj Y
  map_id : ∀ {X : Type} (x : obj X), map (fun a => a) x = x
  map_comp : ∀ {X Y Z : Type} (g : Y → Z) (f : X → Y) (x : obj X),
    map (fun a => g (f a)) x = map g (map f x)
  map_congr : ∀ {X Y : Type} {f g : X → Y}, (∀ a, f a = g a) → ∀ x, map f x = map g x

/-- Identity `SpanFunctor`. -/
def SpanFunctor.id : SpanFunctor where
  obj X := X
  map f x := f x
  map_id _ := rfl
  map_comp _ _ _ := rfl
  map_congr h x := h x

/-- Composition `G ∘ F` of two `SpanFunctor`s. -/
def SpanFunctor.comp (G F : SpanFunctor) : SpanFunctor where
  obj X := G.obj (F.obj X)
  map f := G.map (F.map f)
  map_id x := (G.map_congr (fun y => F.map_id y) x).trans (G.map_id x)
  map_comp g f x :=
    (G.map_congr (fun y => F.map_comp g f y) x).trans (G.map_comp (F.map g) (F.map f) x)
  map_congr h x := G.map_congr (fun y => F.map_congr h y) x

/-- Action of a `SpanFunctor` on a relational span (`Span(F)`). -/
def SpanFunctor.onSpan (F : SpanFunctor) {A B : Type} (H : RelSpan A B) :
    RelSpan (F.obj A) (F.obj B) where
  W := F.obj H.W
  left := F.map H.left
  right := F.map H.right

/-- Action of a `SpanFunctor` on a span morphism. -/
def SpanFunctor.onHom (F : SpanFunctor) {A B : Type} {H K : RelSpan A B} (f : SpanHom H K) :
    SpanHom (F.onSpan H) (F.onSpan K) where
  map := F.map f.map
  left_eq x := (F.map_comp K.left f.map x).symm.trans (F.map_congr f.left_eq x)
  right_eq x := (F.map_comp K.right f.map x).symm.trans (F.map_congr f.right_eq x)

/-- **Canonical Oplax Span Comparison (`chi` / `κ`, `v9 S1`)**:
For any functor `F` and composable spans `H : RelSpan A D`, `K : RelSpan D C`,
`chi F H K : F(W ×_D V) → FW ×_{FD} FV`. -/
def chi (F : SpanFunctor) {A D C : Type} (H : RelSpan A D) (K : RelSpan D C) :
    SpanHom (F.onSpan (compSpan H K)) (compSpan (F.onSpan H) (F.onSpan K)) where
  map u :=
    ⟨F.map PullbackElem.fst u, F.map PullbackElem.snd u,
      (F.map_comp H.right PullbackElem.fst u).symm.trans
        ((F.map_congr (fun z => z.mid) u).trans
          (F.map_comp K.left PullbackElem.snd u))⟩
  left_eq u := (F.map_comp H.left PullbackElem.fst u).symm
  right_eq u := (F.map_comp K.right PullbackElem.snd u).symm

theorem chi_left (F : SpanFunctor) {A D C : Type} (H : RelSpan A D) (K : RelSpan D C)
    (u : F.obj (PullbackElem H.right K.left)) :
    (compSpan (F.onSpan H) (F.onSpan K)).left ((chi F H K).map u) =
      (F.onSpan (compSpan H K)).left u :=
  (chi F H K).left_eq u

theorem chi_right (F : SpanFunctor) {A D C : Type} (H : RelSpan A D) (K : RelSpan D C)
    (u : F.obj (PullbackElem H.right K.left)) :
    (compSpan (F.onSpan H) (F.onSpan K)).right ((chi F H K).map u) =
      (F.onSpan (compSpan H K)).right u :=
  (chi F H K).right_eq u

/-- **Naturality of `chi` (`v9 S1` Proof 2).** -/
theorem chi_natural (F : SpanFunctor) {A D C : Type}
    {H H' : RelSpan A D} {K K' : RelSpan D C}
    (a : SpanHom H H') (b : SpanHom K K') :
    SpanHomEq (SpanHom.comp (chi F H' K') (F.onHom (compSpanHom a b)))
      (SpanHom.comp (compSpanHom (F.onHom a) (F.onHom b)) (chi F H K)) := by
  intro u
  refine PullbackElem.ext ?_ ?_
  · exact (F.map_comp PullbackElem.fst (compSpanHom a b).map u).symm.trans
      (F.map_comp a.map PullbackElem.fst u)
  · exact (F.map_comp PullbackElem.snd (compSpanHom a b).map u).symm.trans
      (F.map_comp b.map PullbackElem.snd u)

/-- Canonical identification `F.onSpan (idSpan A) → idSpan (F.obj A)` using `F.map_id`. -/
def idLiftHom (F : SpanFunctor) (A : Type) : SpanHom (F.onSpan (idSpan A)) (idSpan (F.obj A)) where
  map x := x
  left_eq x := (F.map_id x).symm
  right_eq x := (F.map_id x).symm

/-- **Left and Right Unit Coherence of `chi` (`v9 S1` Proof 4).** -/
theorem chi_unit_left (F : SpanFunctor) {A B : Type} (H : RelSpan A B) :
    SpanHomEq
      (SpanHom.comp (unitLeftHom (F.onSpan H))
        (SpanHom.comp (compSpanHom (idLiftHom F A) (SpanHom.id (F.onSpan H)))
          (chi F (idSpan A) H)))
      (F.onHom (unitLeftHom H)) :=
  fun _ => rfl

theorem chi_unit_right (F : SpanFunctor) {A B : Type} (H : RelSpan A B) :
    SpanHomEq
      (SpanHom.comp (unitRightHom (F.onSpan H))
        (SpanHom.comp (compSpanHom (SpanHom.id (F.onSpan H)) (idLiftHom F B))
          (chi F H (idSpan B))))
      (F.onHom (unitRightHom H)) :=
  fun _ => rfl

/-- **Ternary Associativity Coherence of `chi` (`v9 S1` Proof 3).** -/
theorem chi_assoc_coherence (F : SpanFunctor) {A B C E : Type}
    (H : RelSpan A B) (K : RelSpan B C) (L : RelSpan C E) :
    SpanHomEq
      (SpanHom.comp (assocHom (F.onSpan H) (F.onSpan K) (F.onSpan L))
        (SpanHom.comp (compSpanHom (chi F H K) (SpanHom.id (F.onSpan L)))
          (chi F (compSpan H K) L)))
      (SpanHom.comp
        (compSpanHom (SpanHom.id (F.onSpan H)) (chi F K L))
        (SpanHom.comp (chi F H (compSpan K L))
          (F.onHom (assocHom H K L)))) := by
  intro u
  have h1 : F.map PullbackElem.fst (F.map PullbackElem.fst u) =
      F.map PullbackElem.fst (F.map (assocHom H K L).map u) :=
    (F.map_comp PullbackElem.fst PullbackElem.fst u).symm.trans
      (F.map_comp PullbackElem.fst (assocHom H K L).map u)
  have a1 : F.map PullbackElem.snd (F.map PullbackElem.fst u) =
      F.map (fun z : PullbackElem (compSpan H K).right L.left => z.fst.snd) u :=
    (F.map_comp PullbackElem.snd PullbackElem.fst u).symm
  have a2 : F.map (fun z : PullbackElem (compSpan H K).right L.left => z.fst.snd) u =
      F.map (fun q : PullbackElem H.right (compSpan K L).left => q.snd.fst)
        (F.map (assocHom H K L).map u) :=
    F.map_comp (fun q : PullbackElem H.right (compSpan K L).left => q.snd.fst) (assocHom H K L).map u
  have a3 : F.map (fun q : PullbackElem H.right (compSpan K L).left => q.snd.fst)
        (F.map (assocHom H K L).map u) =
      F.map (@PullbackElem.fst _ _ _ K.right L.left)
        (F.map (@PullbackElem.snd _ _ _ H.right (compSpan K L).left)
          (F.map (assocHom H K L).map u)) :=
    F.map_comp (@PullbackElem.fst _ _ _ K.right L.left)
      (@PullbackElem.snd _ _ _ H.right (compSpan K L).left)
      (F.map (assocHom H K L).map u)
  have h2 : F.map PullbackElem.snd (F.map PullbackElem.fst u) =
      F.map PullbackElem.fst (F.map PullbackElem.snd (F.map (assocHom H K L).map u)) :=
    a1.trans (a2.trans a3)
  have b1 : F.map PullbackElem.snd u =
      F.map (fun q : PullbackElem H.right (compSpan K L).left => q.snd.snd)
        (F.map (assocHom H K L).map u) :=
    F.map_comp (fun q : PullbackElem H.right (compSpan K L).left => q.snd.snd) (assocHom H K L).map u
  have b2 : F.map (fun q : PullbackElem H.right (compSpan K L).left => q.snd.snd)
        (F.map (assocHom H K L).map u) =
      F.map (@PullbackElem.snd _ _ _ K.right L.left)
        (F.map (@PullbackElem.snd _ _ _ H.right (compSpan K L).left)
          (F.map (assocHom H K L).map u)) :=
    F.map_comp (@PullbackElem.snd _ _ _ K.right L.left)
      (@PullbackElem.snd _ _ _ H.right (compSpan K L).left)
      (F.map (assocHom H K L).map u)
  have h3 : F.map PullbackElem.snd u =
      F.map PullbackElem.snd (F.map PullbackElem.snd (F.map (assocHom H K L).map u)) :=
    b1.trans b2
  exact PullbackElem.ext h1 (PullbackElem.ext h2 h3)

/-- **Multi-Layer Explanation Factorization (`v9 S5`):**
`κ^{G∘F}_{H,K} = κ^G_{FH,FK} ∘ G(κ^F_{H,K})`. -/
theorem chi_comp_functor (G F : SpanFunctor) {A D C : Type}
    (H : RelSpan A D) (K : RelSpan D C) :
    SpanHomEq (chi (SpanFunctor.comp G F) H K)
      (SpanHom.comp (chi G (F.onSpan H) (F.onSpan K)) (G.onHom (chi F H K))) := by
  intro u
  refine PullbackElem.ext ?_ ?_
  · exact G.map_comp PullbackElem.fst (chi F H K).map u
  · exact G.map_comp PullbackElem.snd (chi F H K).map u

/-! ### All-Finite-`n` Flat Chains, Binary Bracketing Coherence (`S2`), & Macro Refinement (`formal/67 D1`) -/

/-- Cast the right endpoint of a `RelSpan` along a type equality without altering its vertex `W`. -/
def RelSpan.castRight {A B B' : Type} (h : B = B') (H : RelSpan A B) : RelSpan A B' where
  W := H.W
  left := H.left
  right w := h ▸ H.right w

/-- Transport helper commuting `F.map` past an index cast on `D` without axioms. -/
theorem map_castRight {F : SpanFunctor} {D : Nat → Type} {X : Type} {a b : Nat}
    (h : a = b) (g : X → D a) (u : F.obj X) :
    (congrArg (fun j => F.obj (D j)) h ▸ F.map g u) =
      F.map (fun x => (congrArg D h ▸ g x : D b)) u := by
  cases h
  rfl

/-- Flat right-associated `n`-step pullback chain starting at index `i`. -/
def flatSpan (D : Nat → Type) (steps : ∀ j, RelSpan (D j) (D (j + 1))) :
    (i n : Nat) → RelSpan (D i) (D (i + n))
  | i, 0 => idSpan (D i)
  | i, n + 1 =>
    (compSpan (steps i) (flatSpan D steps (i + 1) n)).castRight
      (congrArg D (Nat.add_right_comm i 1 n))

/-- Project the `k`-th step witness from an `n`-step `flatSpan` element (`k < n`). -/
def flatProj {D : Nat → Type} {steps : ∀ j, RelSpan (D j) (D (j + 1))} :
    ∀ {i n k : Nat} (_hlt : k < n), (flatSpan D steps i n).W → (steps (i + k)).W
  | _, 0, _, hlt, _ => absurd hlt (Nat.not_lt_zero _)
  | _, _ + 1, 0, _, p => p.fst
  | i, _ + 1, k + 1, hlt, p =>
    congrArg (fun idx => (steps idx).W) (Nat.add_right_comm i 1 k) ▸
      flatProj (Nat.lt_of_succ_lt_succ hlt) p.snd

/-- Inverse transport on `(steps _).W` for `congrArg` casts without axioms. -/
theorem stepCast_inj {D : Nat → Type} {steps : ∀ j, RelSpan (D j) (D (j + 1))}
    {a b : Nat} (h : a = b) {u v : (steps a).W}
    (e : (congrArg (fun idx => (steps idx).W) h ▸ u : (steps b).W) =
         (congrArg (fun idx => (steps idx).W) h ▸ v : (steps b).W)) : u = v := by
  cases h
  exact e

/-- **Universal Uniqueness of Iterated Flat Pullbacks (`v9 S2` joint-monicity):**
Two elements of `flatSpan` with equal start points and identical step projections are equal. -/
theorem flatSpan_proj_unique {D : Nat → Type} {steps : ∀ j, RelSpan (D j) (D (j + 1))}
    {i n : Nat} {x y : (flatSpan D steps i n).W} :
    (flatSpan D steps i n).left x = (flatSpan D steps i n).left y →
    (∀ k (hlt : k < n), flatProj hlt x = flatProj hlt y) →
    x = y := by
  induction n generalizing i with
  | zero =>
    intro hleft _
    exact hleft
  | succ m ih =>
    intro _ hproj
    refine PullbackElem.ext (hproj 0 (Nat.zero_lt_succ m)) ?_
    apply ih
    · exact x.mid.symm.trans ((congrArg (steps i).right (hproj 0 (Nat.zero_lt_succ m))).trans y.mid)
    · intro k hk
      exact stepCast_inj (Nat.add_right_comm i 1 k)
        (hproj (k + 1) (Nat.succ_lt_succ hk))

/-- Canonical `n`-step oplax comparison `κ_n : F(W₁ × ⋯ × Wₙ) → FW₁ × ⋯ × FWₙ` (`v9 S2`). -/
def chiFlat (F : SpanFunctor) (D : Nat → Type) (steps : ∀ j, RelSpan (D j) (D (j + 1))) :
    ∀ (i n : Nat),
      SpanHom (F.onSpan (flatSpan D steps i n))
        (flatSpan (fun j => F.obj (D j)) (fun j => F.onSpan (steps j)) i n)
  | i, 0 =>
    { map := fun x => x
      left_eq := fun x => (F.map_id x).symm
      right_eq := fun x => (F.map_id x).symm }
  | i, n + 1 =>
    let tail := chiFlat F D steps (i + 1) n
    let raw := SpanHom.comp (compSpanHom (SpanHom.id (F.onSpan (steps i))) tail)
      (chi F (steps i) (flatSpan D steps (i + 1) n))
    { map := raw.map
      left_eq := raw.left_eq
      right_eq u := by
        have hr : (compSpan (F.onSpan (steps i))
              (flatSpan (fun j => F.obj (D j)) (fun j => F.onSpan (steps j)) (i + 1) n)).right
              (raw.map u) =
            F.map (compSpan (steps i) (flatSpan D steps (i + 1) n)).right u := raw.right_eq u
        show (congrArg (fun j => F.obj (D j)) (Nat.add_right_comm i 1 n) ▸
            (compSpan (F.onSpan (steps i))
              (flatSpan (fun j => F.obj (D j)) (fun j => F.onSpan (steps j)) (i + 1) n)).right
              (raw.map u)) =
          F.map (fun p => congrArg D (Nat.add_right_comm i 1 n) ▸
            (compSpan (steps i) (flatSpan D steps (i + 1) n)).right p) u
        rw [hr]
        exact map_castRight (Nat.add_right_comm i 1 n)
          (compSpan (steps i) (flatSpan D steps (i + 1) n)).right u }

/-- `chiFlat` projects directly onto `F.map (flatProj hlt)` at every index `k < n`. -/
theorem chiFlat_proj (F : SpanFunctor) (D : Nat → Type) (steps : ∀ j, RelSpan (D j) (D (j + 1))) :
    ∀ {i n k : Nat} (hlt : k < n) (u : F.obj (flatSpan D steps i n).W),
      flatProj hlt ((chiFlat F D steps i n).map u) = F.map (flatProj hlt) u
  | _, 0, _, hlt, _ => absurd hlt (Nat.not_lt_zero _)
  | _, _ + 1, 0, _, _ => rfl
  | i, n + 1, k + 1, hlt, u => by
    have hk : k < n := Nat.lt_of_succ_lt_succ hlt
    have ih := chiFlat_proj F D steps hk (F.map PullbackElem.snd u)
    dsimp only [flatProj, chiFlat, SpanHom.comp]
    have hidx := Nat.add_right_comm i 1 k
    have hm1 : flatProj hk ((chiFlat F D steps (i + 1) n).map (F.map PullbackElem.snd u)) =
        F.map (fun p : PullbackElem (steps i).right (flatSpan D steps (i + 1) n).left =>
          flatProj hk p.snd) u :=
      ih.trans (F.map_comp (flatProj hk) PullbackElem.snd u).symm
    have hswap : ∀ {a b : Nat} (h : a = b)
        (g : (flatSpan D steps i (n + 1)).W → (steps a).W)
        (y : F.obj (flatSpan D steps i (n + 1)).W),
        (congrArg (fun idx => F.obj (steps idx).W) h ▸ F.map g y : F.obj (steps b).W) =
          F.map (fun p => (congrArg (fun idx => (steps idx).W) h ▸ g p : (steps b).W)) y := by
      intro a b h g y
      cases h
      rfl
    have heq := hswap hidx
      (fun p : PullbackElem (steps i).right (flatSpan D steps (i + 1) n).left => flatProj hk p.snd) u
    exact (congrArg (fun z => (congrArg (fun idx => (F.onSpan (steps idx)).W) hidx ▸ z)) hm1).trans
      heq

/-- Binary bracketing tree over `[i, i + len]` with arbitrary associative groupings & empty units. -/
inductive BracketTree (D : Nat → Type) (steps : ∀ j, RelSpan (D j) (D (j + 1))) :
    Nat → Nat → Type where
  | empty (i : Nat) : BracketTree D steps i 0
  | leaf (i : Nat) : BracketTree D steps i 1
  | split {i a b : Nat} :
      BracketTree D steps i a → BracketTree D steps (i + a) b →
      BracketTree D steps i (a + b)

/-- Evaluate a `BracketTree` directly via span composition `compSpan`. -/
def BracketTree.eval {D : Nat → Type} {steps : ∀ j, RelSpan (D j) (D (j + 1))} :
    ∀ {i n : Nat}, BracketTree D steps i n → RelSpan (D i) (D (i + n))
  | _, _, .empty i => idSpan (D i)
  | _, _, .leaf i => steps i
  | i, _, .split (a := a) (b := b) tL tR =>
    (compSpan tL.eval tR.eval).castRight (congrArg D (Nat.add_assoc i a b))

/-- Transport a `BracketTree` along `F.onSpan`. -/
def BracketTree.mapF (F : SpanFunctor) {D : Nat → Type} {steps : ∀ j, RelSpan (D j) (D (j + 1))} :
    ∀ {i n : Nat}, BracketTree D steps i n →
      BracketTree (fun j => F.obj (D j)) (fun j => F.onSpan (steps j)) i n
  | _, _, .empty i => .empty i
  | _, _, .leaf i => .leaf i
  | _, _, .split tL tR => .split (tL.mapF F) (tR.mapF F)

/-- Canonical oplax comparison along any binary bracketing tree `t`. -/
def BracketTree.chiEval (F : SpanFunctor) {D : Nat → Type} {steps : ∀ j, RelSpan (D j) (D (j + 1))} :
    ∀ {i n : Nat} (t : BracketTree D steps i n),
      SpanHom (F.onSpan t.eval) (t.mapF F).eval
  | _, _, .empty i =>
    { map := fun x => x
      left_eq := fun x => (F.map_id x).symm
      right_eq := fun x => (F.map_id x).symm }
  | _, _, .leaf i =>
    { map := fun x => x
      left_eq := fun _ => rfl
      right_eq := fun _ => rfl }
  | i, _, .split (a := a) (b := b) tL tR =>
    let raw := SpanHom.comp (compSpanHom (tL.chiEval F) (tR.chiEval F)) (chi F tL.eval tR.eval)
    ({ map := fun (u : F.obj (compSpan tL.eval tR.eval).W) => raw.map u
       left_eq := fun (u : F.obj (compSpan tL.eval tR.eval).W) => raw.left_eq u
       right_eq := fun (u : F.obj (compSpan tL.eval tR.eval).W) => by
         have hr : (compSpan (tL.mapF F).eval (tR.mapF F).eval).right (raw.map u) =
             F.map (compSpan tL.eval tR.eval).right u := raw.right_eq u
         change (congrArg (fun j => F.obj (D j)) (Nat.add_assoc i a b) ▸
             (compSpan (tL.mapF F).eval (tR.mapF F).eval).right (raw.map u)) =
           F.map (fun p : (compSpan tL.eval tR.eval).W =>
             congrArg D (Nat.add_assoc i a b) ▸ (compSpan tL.eval tR.eval).right p) u
         rw [hr]
         exact map_castRight (Nat.add_assoc i a b) (compSpan tL.eval tR.eval).right u } :
      SpanHom (F.onSpan ((compSpan tL.eval tR.eval).castRight (congrArg D (Nat.add_assoc i a b))))
        ((compSpan (tL.mapF F).eval (tR.mapF F).eval).castRight
          (congrArg (fun j => F.obj (D j)) (Nat.add_assoc i a b))))

/-- Step-by-step witness projection from any binary bracketing tree `t` (`k < n`). -/
def BracketTree.proj {D : Nat → Type} {steps : ∀ j, RelSpan (D j) (D (j + 1))} :
    ∀ {i n k : Nat} (t : BracketTree D steps i n) (_hlt : k < n),
      t.eval.W → (steps (i + k)).W
  | _, _, _, .empty _, hlt, _ => absurd hlt (Nat.not_lt_zero _)
  | _, _, 0, .leaf _, _, w => w
  | _, _, _ + 1, .leaf _, hlt, _ => absurd (Nat.lt_of_succ_lt_succ hlt) (Nat.not_lt_zero _)
  | i, _, k, .split (a := a) (b := b) tL tR, hlt, p =>
    match Nat.decLt k a with
    | .isTrue hk => BracketTree.proj tL hk p.fst
    | .isFalse hnlt =>
      let hge : a ≤ k := Nat.le_of_not_lt hnlt
      let hk' : k - a < b := Nat.lt_of_add_lt_add_left (add_sub_of_le hge ▸ hlt)
      let heq : i + a + (k - a) = i + k :=
        (Nat.add_assoc i a (k - a)).trans (congrArg (i + ·) (add_sub_of_le hge))
      congrArg (fun idx => (steps idx).W) heq ▸ BracketTree.proj tR hk' p.snd

/-- **All-Finite-`n` Binary Bracketing Coherence Theorem (`v9 S2`):**
For EVERY finite length `n`, ANY bracketing tree `t : BracketTree D steps i n`, step projection
through `(chiEval F t)` agrees with `F.map (t.proj hlt)` at every index `k < n`. -/
theorem bracketTree_coherence_all_n (F : SpanFunctor) {D : Nat → Type}
    {steps : ∀ j, RelSpan (D j) (D (j + 1))} :
    ∀ {i n k : Nat} (t : BracketTree D steps i n) (hlt : k < n) (u : F.obj t.eval.W),
      (t.mapF F).proj hlt ((t.chiEval F).map u) = F.map (t.proj hlt) u
  | _, _, _, .empty _, hlt, _ => absurd hlt (Nat.not_lt_zero _)
  | _, _, 0, .leaf _, _, u => (F.map_id u).symm
  | _, _, _ + 1, .leaf _, hlt, _ => absurd (Nat.lt_of_succ_lt_succ hlt) (Nat.not_lt_zero _)
  | i, _, k, .split (a := a) (b := b) tL tR, hlt, u => by
    dsimp only [BracketTree.mapF, BracketTree.proj, BracketTree.chiEval]
    cases hcmp : Nat.decLt k a with
    | isTrue hk =>
      let u' : F.obj (PullbackElem tL.eval.right tR.eval.left) := u
      have ih := bracketTree_coherence_all_n F tL hk (F.map PullbackElem.fst u')
      exact ih.trans (F.map_comp (BracketTree.proj tL hk) PullbackElem.fst u').symm
    | isFalse hnlt =>
      let u' : F.obj (PullbackElem tL.eval.right tR.eval.left) := u
      have hge : a ≤ k := Nat.le_of_not_lt hnlt
      have hk' : k - a < b := Nat.lt_of_add_lt_add_left (add_sub_of_le hge ▸ hlt)
      have heq : i + a + (k - a) = i + k :=
        (Nat.add_assoc i a (k - a)).trans (congrArg (i + ·) (add_sub_of_le hge))
      have ih := bracketTree_coherence_all_n F tR hk' (F.map PullbackElem.snd u')
      have hsub : (tR.mapF F).proj hk' ((tR.chiEval F).map (F.map PullbackElem.snd u')) =
          F.map (fun p : PullbackElem tL.eval.right tR.eval.left =>
            BracketTree.proj tR hk' p.snd) u' :=
        ih.trans (F.map_comp (BracketTree.proj tR hk') PullbackElem.snd u').symm
      have hcast : ∀ {x y : Nat} (h : x = y)
          (g : PullbackElem tL.eval.right tR.eval.left → (steps x).W)
          (v : F.obj (PullbackElem tL.eval.right tR.eval.left)),
          (congrArg (fun idx => F.obj (steps idx).W) h ▸ F.map g v : F.obj (steps y).W) =
            F.map (fun p => (congrArg (fun idx => (steps idx).W) h ▸ g p : (steps y).W)) v := by
        intro x y h g v
        cases h
        rfl
      exact (congrArg (fun z => (congrArg (fun idx => (F.onSpan (steps idx)).W) heq ▸ z)) hsub).trans
        (hcast heq (fun p => BracketTree.proj tR hk' p.snd) u')

/-- Sum of block lengths in a partition list. -/
def sumBlockLens : List Nat → Nat
  | [] => 0
  | b :: bs => b + sumBlockLens bs

/-- Starting index of the `k`-th block in a partition list. -/
def blockStart (i : Nat) : List Nat → Nat → Nat
  | [], _ => i
  | _, 0 => i
  | b :: bs, k + 1 => blockStart (i + b) bs k

/-- Length of the `k`-th block in a partition list. -/
def blockLenAt : List Nat → Nat → Nat
  | [], _ => 0
  | b :: _, 0 => b
  | _ :: bs, k + 1 => blockLenAt bs k

/-- Assemble a sequence of contiguous block lengths `bs` via pullback on `F`-aggregated endpoints (`M_Π`). -/
def evalPartition (F : SpanFunctor) (D : Nat → Type) (steps : ∀ j, RelSpan (D j) (D (j + 1))) :
    (i : Nat) → (bs : List Nat) → RelSpan (F.obj (D i)) (F.obj (D (i + sumBlockLens bs)))
  | i, [] => idSpan (F.obj (D i))
  | i, b :: bs =>
    (compSpan (F.onSpan (flatSpan D steps i b))
      (evalPartition F D steps (i + b) bs)).castRight
      (congrArg (fun j => F.obj (D j)) (Nat.add_assoc i b (sumBlockLens bs)))

/-- Final-block pullback projection `M_Π(w) → QP_B` (`formal/67 §D3` cross-review fix). -/
def partBlockProj (F : SpanFunctor) {D : Nat → Type} {steps : ∀ j, RelSpan (D j) (D (j + 1))} :
    ∀ {i k : Nat} {bs : List Nat} (_hk : k < bs.length),
      (evalPartition F D steps i bs).W →
      F.obj (flatSpan D steps (blockStart i bs k) (blockLenAt bs k)).W
  | _, _, [], hk, _ => absurd hk (Nat.not_lt_zero _)
  | i, 0, b :: bs, _, p =>
    let q : PullbackElem (F.onSpan (flatSpan D steps i b)).right
        (evalPartition F D steps (i + b) bs).left := p
    q.fst
  | i, k + 1, b :: bs, hk, p =>
    let q : PullbackElem (F.onSpan (flatSpan D steps i b)).right
        (evalPartition F D steps (i + b) bs).left := p
    partBlockProj F (k := k) (bs := bs) (Nat.lt_of_succ_lt_succ hk) q.snd

/-- **Joint-Monicity of `evalPartition` on Final Block Pullbacks (`v9 formal/67 D1`).** -/
theorem evalPartition_proj_unique (F : SpanFunctor) {D : Nat → Type}
    {steps : ∀ j, RelSpan (D j) (D (j + 1))} :
    ∀ {i : Nat} {bs : List Nat} {x y : (evalPartition F D steps i bs).W},
      (evalPartition F D steps i bs).left x = (evalPartition F D steps i bs).left y →
      (∀ k (hk : k < bs.length), partBlockProj F hk x = partBlockProj F hk y) →
      x = y
  | i, [], x, y, hleft, _ => by
    dsimp only [evalPartition, idSpan] at hleft x y
    exact hleft
  | i, b :: bs, x, y, _, hproj => by
    let x' : PullbackElem (F.onSpan (flatSpan D steps i b)).right
        (evalPartition F D steps (i + b) bs).left := x
    let y' : PullbackElem (F.onSpan (flatSpan D steps i b)).right
        (evalPartition F D steps (i + b) bs).left := y
    have h0 : x'.fst = y'.fst := hproj 0 (Nat.zero_lt_succ bs.length)
    have hsnd : x'.snd = y'.snd := by
      refine evalPartition_proj_unique F ?_ ?_
      · exact x'.mid.symm.trans ((congrArg (F.onSpan (flatSpan D steps i b)).right h0).trans y'.mid)
      · intro k hk
        exact hproj (k + 1) (Nat.succ_lt_succ hk)
    exact PullbackElem.ext h0 hsnd

/-- **Macro Refinement Functoriality (`v9 formal/67 D1`):**
Any two multi-step refinement paths between partitions whose projections onto every final block `QP_B`
agree yield the EXACT same span morphism into `evalPartition F D steps i bs₃`. -/
theorem macro_refinement_functorial (F : SpanFunctor) {D : Nat → Type}
    {steps : ∀ j, RelSpan (D j) (D (j + 1))}
    {i : Nat} {bs₁ bs₂ bs₃ : List Nat}
    {h12 : sumBlockLens bs₁ = sumBlockLens bs₂} {h23 : sumBlockLens bs₂ = sumBlockLens bs₃}
    (r12 : SpanHom (evalPartition F D steps i bs₁)
      ((evalPartition F D steps i bs₂).castRight
        (congrArg (fun j => F.obj (D j)) (congrArg (i + ·) h12.symm))))
    (r23 : SpanHom (evalPartition F D steps i bs₂)
      ((evalPartition F D steps i bs₃).castRight
        (congrArg (fun j => F.obj (D j)) (congrArg (i + ·) h23.symm))))
    (r13 : SpanHom (evalPartition F D steps i bs₁)
      ((evalPartition F D steps i bs₃).castRight
        (congrArg (fun j => F.obj (D j)) (congrArg (i + ·) (h12.trans h23).symm))))
    (hblock : ∀ x k (hk : k < bs₃.length),
      partBlockProj F hk (r23.map (r12.map x)) = partBlockProj F hk (r13.map x)) :
    ∀ x, r23.map (r12.map x) = r13.map x := by
  intro x
  refine evalPartition_proj_unique F ?_ (hblock x)
  exact (r23.left_eq (r12.map x)).trans ((r12.left_eq x).trans (r13.left_eq x).symm)

/-! ## Part 2: Same-Square Beck–Chevalley Equivalence (`S4`) & Dual Distortion Witnesses (`6.1–6.3`) -/

/-- Fiber element over `v : F.obj K.W` on the left side of Beck–Chevalley: `Σ_{Fq} (Fp)* E`. -/
structure BCLeft (F : SpanFunctor) {A D C : Type} (H : RelSpan A D) (K : RelSpan D C)
    (E : F.obj H.W → Type) (v : F.obj K.W) where
  u : F.obj (PullbackElem H.right K.left)
  eqV : F.map PullbackElem.snd u = v
  val : E (F.map PullbackElem.fst u)

/-- Fiber element over `v : F.obj K.W` on the right side of Beck–Chevalley: `(Fs)* Σ_{Fr} E`. -/
structure BCRight (F : SpanFunctor) {A D C : Type} (H : RelSpan A D) (K : RelSpan D C)
    (E : F.obj H.W → Type) (v : F.obj K.W) where
  w : F.obj H.W
  eqMid : F.map H.right w = F.map K.left v
  val : E w

theorem BCLeft.ext_sameU {F : SpanFunctor} {A D C : Type} {H : RelSpan A D} {K : RelSpan D C}
    {E : F.obj H.W → Type} {v : F.obj K.W}
    {u : F.obj (PullbackElem H.right K.left)}
    {eq₁ eq₂ : F.map PullbackElem.snd u = v}
    {val₁ val₂ : E (F.map PullbackElem.fst u)}
    (hval : val₁ = val₂) :
    (BCLeft.mk u eq₁ val₁ : BCLeft F H K E v) = BCLeft.mk u eq₂ val₂ := by
  subst hval
  rfl

/-- Dependent helper extracting equality of fiber values from `bcMap` image equality when `u₁ = u₂`. -/
theorem bcRight_val_eq_of_eq {F : SpanFunctor} {A D C : Type} {H : RelSpan A D} {K : RelSpan D C}
    {E : F.obj H.W → Type} {v : F.obj K.W}
    {w₁ w₂ : F.obj H.W} (hw : w₁ = w₂)
    {eq₁ : F.map H.right w₁ = F.map K.left v} {eq₂ : F.map H.right w₂ = F.map K.left v}
    {val₁ : E w₁} {val₂ : E w₂}
    (heq : (BCRight.mk w₁ eq₁ val₁ : BCRight F H K E v) = BCRight.mk w₂ eq₂ val₂) :
    (congrArg E hw ▸ val₁ : E w₂) = val₂ := by
  cases heq
  rfl

/-- Helper constructing `BCLeft.mk u₁ ... = BCLeft.mk u₂ ...` when `u₁ = u₂`. -/
theorem bcLeft_mk_ext {F : SpanFunctor} {A D C : Type} {H : RelSpan A D} {K : RelSpan D C}
    {E : F.obj H.W → Type} {v : F.obj K.W}
    {u₁ u₂ : F.obj (PullbackElem H.right K.left)} (hu : u₁ = u₂)
    {eq₁ : F.map PullbackElem.snd u₁ = v} {eq₂ : F.map PullbackElem.snd u₂ = v}
    {val₁ : E (F.map PullbackElem.fst u₁)} {val₂ : E (F.map PullbackElem.fst u₂)}
    (hval : (congrArg (fun z => E (F.map PullbackElem.fst z)) hu ▸ val₁ : E (F.map PullbackElem.fst u₂)) = val₂) :
    (BCLeft.mk u₁ eq₁ val₁ : BCLeft F H K E v) = BCLeft.mk u₂ eq₂ val₂ := by
  cases hu
  cases hval
  rfl

/-- Helper constructing `BCRight.mk w₁ ... = BCRight.mk w₂ ...` when `w₁ = w₂`. -/
theorem bcRight_mk_ext {F : SpanFunctor} {A D C : Type} {H : RelSpan A D} {K : RelSpan D C}
    {E : F.obj H.W → Type} {v : F.obj K.W}
    {w₁ w₂ : F.obj H.W} (hw : w₁ = w₂)
    {eq₁ : F.map H.right w₁ = F.map K.left v} {eq₂ : F.map H.right w₂ = F.map K.left v}
    {val₁ : E w₁} {val₂ : E w₂}
    (hval : (congrArg E hw ▸ val₁ : E w₂) = val₂) :
    (BCRight.mk w₁ eq₁ val₁ : BCRight F H K E v) = BCRight.mk w₂ eq₂ val₂ := by
  cases hw
  cases hval
  rfl

/-- Explicit fiberwise Beck–Chevalley map `β_E(v) : (u, e) ↦ (Fp(u), e)` on the `F`-image square (`v9 S4`). -/
def bcMap (F : SpanFunctor) {A D C : Type} (H : RelSpan A D) (K : RelSpan D C)
    (E : F.obj H.W → Type) (v : F.obj K.W) :
    BCLeft F H K E v → BCRight F H K E v
  | ⟨u, eqV, val⟩ =>
    ⟨F.map PullbackElem.fst u,
      ((chi F H K).map u).mid.trans (congrArg (F.map K.left) eqV),
      val⟩

/-- Pullback universal property on the `F`-image square: every compatible `(w, v)` lifts uniquely. -/
def FImageIsPullback (F : SpanFunctor) {A D C : Type} (H : RelSpan A D) (K : RelSpan D C) : Prop :=
  ∀ (w : F.obj H.W) (v : F.obj K.W), F.map H.right w = F.map K.left v →
    ∃ u : F.obj (PullbackElem H.right K.left),
      (F.map PullbackElem.fst u = w ∧ F.map PullbackElem.snd u = v) ∧
      (∀ u', F.map PullbackElem.fst u' = w → F.map PullbackElem.snd u' = v → u' = u)

/-- **Exact Equivalence: `IsBijective (chi F H K) ↔ FImageIsPullback F H K` (`v9 S4` 1 ↔ 2, 0 axioms).** -/
theorem chi_bijective_iff_pullback (F : SpanFunctor) {A D C : Type}
    (H : RelSpan A D) (K : RelSpan D C) :
    IsBijective (chi F H K).map ↔ FImageIsPullback F H K := by
  constructor
  · intro ⟨hinj, hsurj⟩ w v hmid
    obtain ⟨u, hu⟩ := hsurj ⟨w, v, hmid⟩
    refine ⟨u, ⟨congrArg PullbackElem.fst hu, congrArg PullbackElem.snd hu⟩, ?_⟩
    intro u' hfst hsnd
    exact hinj u' u ((PullbackElem.ext hfst hsnd).trans hu.symm)
  · intro hpb
    refine ⟨?_, ?_⟩
    · intro u₁ u₂ heq
      have hmid : F.map H.right (F.map PullbackElem.fst u₂) =
          F.map K.left (F.map PullbackElem.snd u₂) := ((chi F H K).map u₂).mid
      obtain ⟨u, _, huniq⟩ := hpb (F.map PullbackElem.fst u₂) (F.map PullbackElem.snd u₂) hmid
      exact (huniq u₁ (congrArg PullbackElem.fst heq) (congrArg PullbackElem.snd heq)).trans
        (huniq u₂ rfl rfl).symm
    · intro ⟨w, v, hmid⟩
      obtain ⟨u, ⟨hfst, hsnd⟩, _⟩ := hpb w v hmid
      exact ⟨u, PullbackElem.ext hfst hsnd⟩

/-- **Exact Equivalence: `IsBijective (chi F H K) ↔ ∀ E v, IsBijective (bcMap F H K E v)` (`v9 S4` 1 ↔ 3).** -/
theorem chi_bijective_iff_bc_all (F : SpanFunctor) {A D C : Type}
    (H : RelSpan A D) (K : RelSpan D C) :
    IsBijective (chi F H K).map ↔ ∀ (E : F.obj H.W → Type) (v : F.obj K.W),
      IsBijective (bcMap F H K E v) := by
  constructor
  · intro ⟨hinj, hsurj⟩ E v
    constructor
    · intro ⟨u₁, eq₁, val₁⟩ ⟨u₂, eq₂, val₂⟩ heq
      have hw : F.map PullbackElem.fst u₁ = F.map PullbackElem.fst u₂ := congrArg BCRight.w heq
      have hu : u₁ = u₂ := hinj u₁ u₂ (PullbackElem.ext hw (eq₁.trans eq₂.symm))
      cases hu
      have hval : val₁ = val₂ := bcRight_val_eq_of_eq rfl heq
      exact bcLeft_mk_ext rfl hval
    · intro ⟨w, eqMid, val⟩
      obtain ⟨u, hu⟩ := hsurj ⟨w, v, eqMid⟩
      have hfst : F.map PullbackElem.fst u = w := congrArg PullbackElem.fst hu
      have hsnd : F.map PullbackElem.snd u = v := congrArg PullbackElem.snd hu
      refine ⟨⟨u, hsnd, hfst.symm ▸ val⟩, ?_⟩
      exact bcRight_mk_ext hfst (by cases hfst; rfl)
  · intro hbc
    have hUnit := hbc (fun _ => Unit)
    constructor
    · intro u₁ u₂ heq
      have ⟨hinjU, _⟩ := hUnit (F.map PullbackElem.snd u₂)
      have eqSnd : F.map PullbackElem.snd u₁ = F.map PullbackElem.snd u₂ :=
        congrArg PullbackElem.snd heq
      have hbcEq : bcMap F H K (fun _ => Unit) (F.map PullbackElem.snd u₂) ⟨u₁, eqSnd, ()⟩ =
          bcMap F H K (fun _ => Unit) (F.map PullbackElem.snd u₂) ⟨u₂, rfl, ()⟩ :=
        bcRight_mk_ext (congrArg PullbackElem.fst heq) rfl
      exact congrArg BCLeft.u (hinjU ⟨u₁, eqSnd, ()⟩ ⟨u₂, rfl, ()⟩ hbcEq)
    · intro ⟨w, v, hmid⟩
      have ⟨_, hsurjU⟩ := hUnit v
      obtain ⟨⟨u, hsnd, _⟩, heq⟩ := hsurjU ⟨w, hmid, ()⟩
      exact ⟨u, PullbackElem.ext (congrArg BCRight.w heq) hsnd⟩

/-- Dependent cancellation for substituting inverse equalities in `E`. -/
theorem eqRec_symm_cancel {α : Type} (E : α → Type) {a b : α} (h : a = b) (x : E b) :
    (congrArg E h ▸ (h.symm ▸ x : E a) : E b) = x := by
  cases h
  rfl

/-- Fiberwise Beck–Chevalley bijectivity (`IsBijective (bcMap F H K E v)`) follows unconditionally
from ANY explicit `Bij` matching `(chi F H K).map` with zero axioms or UIP on `F.obj H.W`.
(Note: lifting to a constructive `Bij` on dependent fibers `BCLeft/BCRight` without UIP would
additionally require half-adjoint triangle coherence on `b.left_inv` / `b.right_inv`.) -/
theorem bc_isBijective_of_chi_bij (F : SpanFunctor) {A D C : Type} (H : RelSpan A D) (K : RelSpan D C)
    (b : Bij (F.obj (PullbackElem H.right K.left)) (PullbackElem (F.map H.right) (F.map K.left)))
    (hb : ∀ u, b.toFun u = (chi F H K).map u)
    (E : F.obj H.W → Type) (v : F.obj K.W) :
    IsBijective (bcMap F H K E v) := by
  have hbij : IsBijective (chi F H K).map := by
    have hbIso := isBijective_of_bij b
    constructor
    · intro u₁ u₂ heq
      exact hbIso.1 u₁ u₂ ((hb u₁).trans (heq.trans (hb u₂).symm))
    · intro y
      obtain ⟨u, hu⟩ := hbIso.2 y
      exact ⟨u, (hb u).symm.trans hu⟩
  exact (chi_bijective_iff_bc_all F H K).mp hbij E v

/-- **Empty-Family Vacuity Counterexample (`v9 formal/61 §2`):**
Choosing the empty set family `E _ := Empty` makes `bcMap` trivially bijective for EVERY functor and
pair `(H, K)` — even when `chi` radically collapses `2 → 1` or misses targets `0 → 1`! -/
theorem bc_empty_family_trivial_counterexample (F : SpanFunctor) {A D C : Type}
    (H : RelSpan A D) (K : RelSpan D C) (v : F.obj K.W) :
    IsBijective (bcMap F H K (fun _ => Empty) v) :=
  ⟨fun a => Empty.elim a.val, fun b => Empty.elim b.val⟩

/- Constructive cross-side emergent global witness (`0 → 1` & `2 → 4`, `v9 §6.1`). -/
namespace EmergentCrossSeamWitness

/-- A 2-piece + 1-seam finite diagram object `D_L ← D_S → D_R`. -/
structure SeamObj where
  L : Type
  R : Type
  S : Type
  lMap : S → L
  rMap : S → R

/-- Morphism of 2-piece + 1-seam diagrams. -/
structure SeamHom (X Y : SeamObj) where
  fL : X.L → Y.L
  fR : X.R → Y.R
  fS : X.S → Y.S
  commL : ∀ s, Y.lMap (fS s) = fL (X.lMap s)
  commR : ∀ s, Y.rMap (fS s) = fR (X.rMap s)

/-- Pullback of two composable seam diagrams `W → D ← V`. -/
def seamPullback {W V D : SeamObj} (rW : SeamHom W D) (lV : SeamHom V D) : SeamObj where
  L := PullbackElem rW.fL lV.fL
  R := PullbackElem rW.fR lV.fR
  S := PullbackElem rW.fS lV.fS
  lMap s :=
    ⟨W.lMap s.fst, V.lMap s.snd,
      (rW.commL s.fst).symm.trans ((congrArg D.lMap s.mid).trans (lV.commL s.snd))⟩
  rMap s :=
    ⟨W.rMap s.fst, V.rMap s.snd,
      (rW.commR s.fst).symm.trans ((congrArg D.rMap s.mid).trans (lV.commR s.snd))⟩

/-- Universal colimit (pushout) specification on a `SeamObj`. -/
structure PushoutSpec (X : SeamObj) (Q : Type) where
  inl : X.L → Q
  inr : X.R → Q
  glue : ∀ s : X.S, inl (X.lMap s) = inr (X.rMap s)

/-- Trivial middle state `D`: single left, single seam, single right glued to `Unit`. -/
def midD : SeamObj where
  L := Unit; R := Unit; S := Unit; lMap _ := (); rMap _ := ()

/-- Step 1 witness `W`: left active (`Unit`), right empty (`Empty`), seam empty (`Empty`). -/
def stepW : SeamObj where
  L := Unit; R := Empty; S := Empty; lMap := Empty.elim; rMap := Empty.elim

/-- Step 2 witness `V`: left empty (`Empty`), right active (`Unit`), seam empty (`Empty`). -/
def stepV : SeamObj where
  L := Empty; R := Unit; S := Empty; lMap := Empty.elim; rMap := Empty.elim

def rW : SeamHom stepW midD where
  fL _ := (); fR := Empty.elim; fS := Empty.elim
  commL s := Empty.elim s
  commR s := Empty.elim s

def lV : SeamHom stepV midD where
  fL := Empty.elim; fR _ := (); fS := Empty.elim
  commL s := Empty.elim s
  commR s := Empty.elim s

/-- Exact pushouts for `midD`, `stepW`, `stepV`, and local pullback `seamPullback rW lV`. -/
def qMid : PushoutSpec midD Unit where inl _ := (); inr _ := (); glue _ := rfl
def qW : PushoutSpec stepW Unit where inl _ := (); inr := Empty.elim; glue s := Empty.elim s
def qV : PushoutSpec stepV Unit where inl := Empty.elim; inr _ := (); glue s := Empty.elim s
def qLoc : PushoutSpec (seamPullback rW lV) Empty where
  inl p := Empty.elim p.snd; inr p := Empty.elim p.fst; glue s := Empty.elim s.fst

/-- Comparison `χ₀ : Empty → Unit ×_{Unit} Unit` (`0 → 1`). -/
def chiZeroToOne : Empty → PullbackElem (fun _ : Unit => ()) (fun _ : Unit => ()) :=
  Empty.elim

/-- **Non-Surjectivity Witness (`0 → 1`):** cross-side gluing yields a global witness with NO local preimage! -/
theorem chiZeroToOne_not_surjective : ¬ Surj chiZeroToOne := by
  intro hsurj
  obtain ⟨e, _⟩ := hsurj ⟨(), (), rfl⟩
  exact Empty.elim e

/-- Independent two-side witness (`2 → 4`, `v8 / v9 §6`): diagonal local vs mixed global. -/
def chiTwoToFour : Bool → Bool × Bool
  | false => (false, false)
  | true => (true, true)

theorem chiTwoToFour_not_surjective : ¬ Surj chiTwoToFour := by
  intro hsurj
  obtain ⟨b, hb⟩ := hsurj (false, true)
  cases b with
  | false => exact Bool.noConfusion (congrArg Prod.snd hb)
  | true => exact Bool.noConfusion (congrArg Prod.fst hb)

end EmergentCrossSeamWitness

/- Group-action relational collapse witness (`C₂` orbit `2 → 1` and `2^n → 1`, `v9 §6.3`). -/
namespace C2RelativeLossWitness

/-- Diagonal `C₂` action on a pair `(b₁, b₂) : Bool × Bool`. -/
def diagFlip (p : Bool × Bool) : Bool × Bool :=
  (!p.1, !p.2)

theorem diagFlip_invol (p : Bool × Bool) : diagFlip (diagFlip p) = p := by
  obtain ⟨a, b⟩ := p
  cases a <;> cases b <;> rfl

/-- Canonical `C₂` orbit on `Bool × Bool`: `true` iff in-phase (`b₁ == b₂`), `false` iff anti-phase. -/
def pairOrbit : Bool × Bool → Bool
  | (b₁, b₂) => b₁ == b₂

theorem pairOrbit_invariant (p : Bool × Bool) : pairOrbit (diagFlip p) = pairOrbit p := by
  obtain ⟨a, b⟩ := p
  cases a <;> cases b <;> rfl

/-- Universal orbit completeness: any `diagFlip`-invariant map `f` factors through `pairOrbit`. -/
theorem pairOrbit_universal {Y : Type} (f : Bool × Bool → Y)
    (hinv : ∀ p, f (diagFlip p) = f p) (p q : Bool × Bool) (horb : pairOrbit p = pairOrbit q) :
    f p = f q := by
  obtain ⟨p₁, p₂⟩ := p
  obtain ⟨q₁, q₂⟩ := q
  cases p₁ <;> cases p₂ <;> cases q₁ <;> cases q₂ <;>
    first | rfl | exact absurd horb Bool.noConfusion | exact (hinv _).symm | exact hinv _

/-- Canonical `C₂` orbit on a single `Bool` under `b ↦ !b` collapses `2 → 1` (`Unit`). -/
def singleOrbit : Bool → Unit := fun _ => ()

/-- The `2 → 1` comparison from joint `C₂`-orbits (`Bool`: same vs opposite) to component-wise orbits (`Unit`). -/
def c2ChiTwoToOne : Bool → Unit := fun _ => ()

/-- **Non-Injectivity Witness (`2 → 1`):** `C₂` relative phase (`true` = same, `false` = opposite)
is erased by component-wise abstraction (`¬ Inj c2ChiTwoToOne`), while `Surj` still holds! -/
theorem c2_chi_two_to_one : ¬ Inj c2ChiTwoToOne ∧ Surj c2ChiTwoToOne :=
  ⟨fun hinj => Bool.noConfusion (hinj true false rfl), fun _ => ⟨true, rfl⟩⟩

theorem sub_lt_of_ge_lt_double {a m : Nat} (hle : a ≤ m) (hlt : m < a + a) : m - a < a := by
  obtain ⟨r, rfl⟩ := le_dest hle
  rw [Naturals.add_sub_cancel_left a r]
  exact Nat.lt_of_add_lt_add_left hlt

/-- Recursive enumeration of distinct `(Nat → Bool)` representatives agreeing beyond `n`,
indexed directly by an integer `m < powTwo n`. -/
def nthBits : Nat → Nat → Nat → Bool
  | 0, _, _ => false
  | n + 1, m, k =>
    if m < powTwo n then
      if k = n then false else nthBits n m k
    else
      if k = n then true else nthBits n (m - powTwo n) k

theorem nthBits_above : ∀ (n m k : Nat), n ≤ k → nthBits n m k = false
  | 0, _, _, _ => rfl
  | n + 1, m, k, hge => by
    dsimp only [nthBits]
    have hne : k ≠ n := fun eq => Nat.not_lt_of_ge hge (eq ▸ Nat.lt_succ_self n)
    cases hlt : Nat.decLt m (powTwo n) with
    | isTrue ht =>
      rw [if_pos ht, if_neg hne]
      exact nthBits_above n m k (Nat.le_of_lt (Nat.lt_of_succ_le hge))
    | isFalse hf =>
      rw [if_neg hf, if_neg hne]
      exact nthBits_above n (m - powTwo n) k (Nat.le_of_lt (Nat.lt_of_succ_le hge))

theorem nthBits_inj : ∀ {n m₁ m₂ : Nat}, m₁ < powTwo n → m₂ < powTwo n →
    (∀ k, k < n → nthBits n m₁ k = nthBits n m₂ k) → m₁ = m₂
  | 0, 0, 0, _, _, _ => rfl
  | 0, _ + 1, _, hm1, _, _ => absurd (Nat.lt_of_succ_lt_succ hm1) (Nat.not_lt_zero _)
  | 0, _, _ + 1, _, hm2, _ => absurd (Nat.lt_of_succ_lt_succ hm2) (Nat.not_lt_zero _)
  | n + 1, m₁, m₂, hm1, hm2, hagree => by
    have htop := hagree n (Nat.lt_succ_self n)
    dsimp only [nthBits] at htop
    cases hm₁ : Nat.decLt m₁ (powTwo n) with
    | isTrue ht1 =>
      cases hm₂ : Nat.decLt m₂ (powTwo n) with
      | isTrue ht2 =>
        exact nthBits_inj ht1 ht2 fun k hk => by
          have hkne : k ≠ n := Nat.ne_of_lt hk
          have hk1 := hagree k (Nat.lt_trans hk (Nat.lt_succ_self n))
          dsimp only [nthBits] at hk1
          rw [if_pos ht1, if_neg hkne, if_pos ht2, if_neg hkne] at hk1
          exact hk1
      | isFalse hf2 =>
        exfalso
        rw [if_pos ht1, if_pos rfl, if_neg hf2, if_pos rfl] at htop
        exact Bool.noConfusion htop
    | isFalse hf1 =>
      cases hm₂ : Nat.decLt m₂ (powTwo n) with
      | isTrue ht2 =>
        exfalso
        rw [if_neg hf1, if_pos rfl, if_pos ht2, if_pos rfl] at htop
        exact Bool.noConfusion htop
      | isFalse hf2 =>
        have hle1 : powTwo n ≤ m₁ := Nat.le_of_not_lt hf1
        have hle2 : powTwo n ≤ m₂ := Nat.le_of_not_lt hf2
        have hsub : m₁ - powTwo n = m₂ - powTwo n :=
          nthBits_inj (sub_lt_of_ge_lt_double hle1 hm1) (sub_lt_of_ge_lt_double hle2 hm2)
            fun k hk => by
              have hkne : k ≠ n := Nat.ne_of_lt hk
              have hk1 := hagree k (Nat.lt_trans hk (Nat.lt_succ_self n))
              dsimp only [nthBits] at hk1
              rw [if_neg hf1, if_neg hkne, if_neg hf2, if_neg hkne] at hk1
              exact hk1
        exact (add_sub_of_le hle1).symm.trans
          ((congrArg (powTwo n + ·) hsub).trans (add_sub_of_le hle2))

/-- Component-wise orbit projection collapses all `powTwo n` relative-phase orbits onto `()`. -/
def c2ChainChi (_n : Nat) : (Nat → Bool) → Unit := fun _ => ()

/-- **Arbitrary-Depth Relational Collapse (`v9 §6.3` `2^n → 1`):**
For every `n : Nat`, there exist `powTwo n` distinct local `(n + 1)`-step `C₂` phase histories
that map to the EXACT same global component-wise collapsed history. -/
theorem c2_n_step_collapse (n : Nat) :
    ∀ m₁ m₂, m₁ < powTwo n → m₂ < powTwo n →
      c2ChainChi n (nthBits n m₁) = c2ChainChi n (nthBits n m₂) ∧
      ((∀ k, k < n → nthBits n m₁ k = nthBits n m₂ k) → m₁ = m₂) :=
  fun _ _ _ _ => ⟨rfl, nthBits_inj ‹_› ‹_›⟩

end C2RelativeLossWitness

end OplaxHistory

namespace RelSpan

open Generative

universe u v u₁ v₁

/-- Generic forward transport of a `Generative.Trace` along state and action label maps. -/
theorem mapTrace
    {S : Type u} {A : Type v} {Q : Type u₁} {B : Type v₁}
    {P : Process S A} {R : Process Q B} {π : S → Q} {φ : A → B}
    {s t : S} {w : List A} (tr : Trace P s w t)
    (step : ∀ x a y, P.step x a y → R.step (π x) (φ a) (π y)) :
    Trace R (π s) (w.map φ) (π t) := by
  induction tr with
  | nil s => exact .nil (π s)
  | cons hs _ ih => exact .cons (step _ _ _ hs) ih

end RelSpan

end Becoming
