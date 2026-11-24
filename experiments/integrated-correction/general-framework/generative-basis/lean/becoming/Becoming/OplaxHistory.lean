import Becoming.CausalAbstraction
import Becoming.OpenComposition
import Becoming.PolyComposition
import Becoming.CoreHelpers
import Becoming.GrammarLaws

/-!
# Oplax History Comparisons, Exact Beck–Chevalley Criteria, and Guarded Interchange (`Becoming.OplaxHistory`)

AI-written (`Wave U6`, 24 November 2026). Every declaration compiles from Lean's prelude alone with
an empty axiom report (`0` axioms, `0` `propext`, `0` `Classical.choice`, `0` `Quot.sound`, `0`
`sorry`, `0` `private` declarations, `0` unnamed `instance`s, and `0` economic metaphors).

This module formalizes the oplax span semantics and observational distortion bridges of
`WenHeHua v9.0` inside `Becoming`'s `0`-axiom core and connects them to closed-loop viability,
causal abstraction, guarded double interchange, and serialized concurrent reconfiguration:

* **Part 1 — General Functor Oplax Span Comparison (`S1`, `S2`, `S5`, `formal/67 D1`):**
  Constructive relational spans `RelSpan`, pullback composition `compSpan`, functor comparison
  `chi : F(W ×_D V) → FW ×_{FD} FV`, endpoint preservation, naturality, unit/associativity
  coherence, universal all-finite-`n` binary bracketing coherence (`bracketTree_coherence_all_n`),
  functoriality of continuous-block macro refinement (`macro_refinement_functorial`), and two-layer
  explanation factorization (`chi_comp_functor`).
* **Part 2 — Same-Square Beck–Chevalley Equivalence (`S4`) & Dual Distortion Witnesses:**
  Exact equivalence between `chi` bijectivity (`IsBijective`), `F`-image pullback preservation, and
  fiberwise Beck–Chevalley bijectivity over all set families (`chi_bijective_iff_bc_all`), with an
  explicit empty-family vacuity trap (`bc_empty_family_trivial_counterexample`), plus constructive
  non-surjective emergence (`EmergentCrossSeamWitness`: `0 → 1` and `2 → 4`) and non-injective
  `C₂`-orbit relational collapse (`C2RelativeLossWitness`: `2 → 1` and `powTwo n → 1`).
* **Part 3 — Bridges into `Becoming` Closed-Loop Dynamics & Guarded Interchange:**
  Identification of `n`-step `Process`/`Trace` histories with iterated pullback chains
  (`trace_equiv_flatChain`), elimination of spurious macro histories under `ExactCausalAbs.Lifts` vs
  breakdown on `CausalGoodhartWitness`, `FiberViabilitySplit` refutation of macro soundness realized
  on a coupled 2-agent alignment system (`C2CoupledAlignmentWitness`), symmetric-monoidal
  coproduct distribution (`coprod_pullback_iso`, strong on `⊕` vs oplax on `⋆`), `BC`-guarded
  interchange upgrading, 3D concurrent reconfiguration guards bridged to
  `PolyComposition.SerialReconfigProcess`, and a `GrammarLaws.«像定后当且仅当同行»` bridge.

What is not shown: whether any empirical system satisfies exact lifting, `BC`, or disjoint
resource invariants (`AGENTS.md` Rule 2). No ethical premise or ranking occurs.
-/

namespace Becoming

namespace OplaxHistory

open Generative Assurance

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

/-! ## Part 3: Bridges into `Becoming` Closed-Loop Dynamics, Causal Abstraction, & Guarded Interchange -/

/-- A single transition step of `P : Process S A` packaged as witness of a span `S ← StepSpan P → S`. -/
structure ProcessStepWitness {S A : Type} (P : Process S A) where
  src : S
  act : A
  dst : S
  step : P.step src act dst

/-- Transition relation of `P : Process S A` as a relational span `S ← W → S`. -/
def processStepSpan {S A : Type} (P : Process S A) : RelSpan S S where
  W := ProcessStepWitness P
  left w := w.src
  right w := w.dst

/-- Time-homogeneous `n`-fold pullback chain of an endorelational span `H : RelSpan S S`
(zero index casts, exact `Trace` correspondence). -/
def constFlatSpan {S : Type} (H : RelSpan S S) : Nat → RelSpan S S
  | 0 => idSpan S
  | n + 1 => compSpan H (constFlatSpan H n)

/-- Canonical `n`-step `chi` on `constFlatSpan` under an object projection `F : SpanFunctor`. -/
def chiConstFlat (F : SpanFunctor) {S : Type} (H : RelSpan S S) :
    ∀ n : Nat, SpanHom (F.onSpan (constFlatSpan H n)) (constFlatSpan (F.onSpan H) n)
  | 0 =>
    { map := fun x => x
      left_eq := fun x => (F.map_id x).symm
      right_eq := fun x => (F.map_id x).symm }
  | n + 1 =>
    SpanHom.comp (compSpanHom (SpanHom.id (F.onSpan H)) (chiConstFlat F H n))
      (chi F H (constFlatSpan H n))

/-- Extract a concrete `Trace P` witness (`Prop`-valued) from any witness in
`(constFlatSpan (processStepSpan P) n).W`. -/
theorem flatSpanToTrace {S A : Type} (P : Process S A) :
    ∀ {n : Nat} (x : (constFlatSpan (processStepSpan P) n).W),
      ∃ w : List A, w.length = n ∧
        Trace P
          ((constFlatSpan (processStepSpan P) n).left x)
          w
          ((constFlatSpan (processStepSpan P) n).right x)
  | 0, s => ⟨[], rfl, .nil s⟩
  | n + 1, p => by
    obtain ⟨w, hw, htr⟩ := flatSpanToTrace P p.snd
    exact ⟨p.fst.act :: w, congrArg Nat.succ hw, .cons (p.mid ▸ p.fst.step) htr⟩

/-- Embed any `Trace P s w s'` with `w.length = n` into `(constFlatSpan (processStepSpan P) n).W`. -/
theorem traceToFlatSpan {S A : Type} {P : Process S A} :
    ∀ {n : Nat} {s s' : S} {w : List A}, w.length = n →
      Trace P s w s' →
      ∃ x : (constFlatSpan (processStepSpan P) n).W,
        (constFlatSpan (processStepSpan P) n).left x = s ∧
        (constFlatSpan (processStepSpan P) n).right x = s'
  | 0, s, _, [], _, tr =>
    ⟨s, rfl, trace_nil_iff.mp tr⟩
  | 0, _, _, _ :: _, hw, _ => absurd hw Nat.noConfusion
  | n + 1, s, s', a :: ws, hw, tr => by
    obtain ⟨m, hst, htail⟩ := trace_cons_iff.mp tr
    obtain ⟨rest, hl, hr⟩ := traceToFlatSpan (Nat.succ.inj hw) htail
    exact ⟨⟨⟨s, a, m, hst⟩, rest, hl.symm⟩, rfl, hr⟩

/-- **Exact `Trace`–`PullbackChain` Identification (`trace_equiv_flatChain`):**
Finite closed-loop trajectories of length `n` on `P : Process S A` correspond constructively to
iterated pullback witnesses in `constFlatSpan (processStepSpan P) n`. -/
theorem trace_equiv_flatChain {S A : Type} (P : Process S A) (n : Nat) (s s' : S) :
    (∃ x : (constFlatSpan (processStepSpan P) n).W,
      (constFlatSpan (processStepSpan P) n).left x = s ∧
      (constFlatSpan (processStepSpan P) n).right x = s') ↔
    (∃ w : List A, w.length = n ∧ Trace P s w s') := by
  constructor
  · intro ⟨x, hl, hr⟩
    obtain ⟨w, hw, tr⟩ := flatSpanToTrace P x
    exact ⟨w, hw, hl ▸ hr ▸ tr⟩
  · intro ⟨w, hw, tr⟩
    obtain ⟨x, hl, hr⟩ := traceToFlatSpan hw tr
    exact ⟨x, hl, hr⟩

/-- Constructive chain projection paired with its exact left/right endpoint invariants. -/
def exactAbsChainWithEnds {S A I Q B J : Type}
    {C₁ : CausalSystem S A I} {C₂ : CausalSystem Q B J}
    {π : S → Q} {φ : A → B} {ω : I → J}
    (abs : ExactCausalAbs C₁ C₂ π φ ω) (i : I) :
    ∀ (n : Nat) (x : (constFlatSpan (processStepSpan (C₁.proc i)) n).W),
      { y : (constFlatSpan (processStepSpan (C₂.proc (ω i))) n).W //
        (constFlatSpan (processStepSpan (C₂.proc (ω i))) n).left y =
          π ((constFlatSpan (processStepSpan (C₁.proc i)) n).left x) ∧
        (constFlatSpan (processStepSpan (C₂.proc (ω i))) n).right y =
          π ((constFlatSpan (processStepSpan (C₁.proc i)) n).right x) }
  | 0, x => ⟨π x, rfl, rfl⟩
  | n + 1, p =>
    let tail := exactAbsChainWithEnds abs i n p.snd
    ⟨⟨⟨π p.fst.src, φ p.fst.act, π p.fst.dst, abs.factors i _ _ _ p.fst.step⟩,
      tail.1, (congrArg π p.mid).trans tail.2.1.symm⟩,
     rfl, tail.2.2⟩

/-- Trace-level state-projection comparison induced by `ExactCausalAbs`: projects concrete
`n`-step trajectories to macro `n`-step trajectories. -/
def exactAbsChainMap {S A I Q B J : Type}
    {C₁ : CausalSystem S A I} {C₂ : CausalSystem Q B J}
    {π : S → Q} {φ : A → B} {ω : I → J}
    (abs : ExactCausalAbs C₁ C₂ π φ ω) (i : I) (n : Nat)
    (x : (constFlatSpan (processStepSpan (C₁.proc i)) n).W) :
    (constFlatSpan (processStepSpan (C₂.proc (ω i))) n).W :=
  (exactAbsChainWithEnds abs i n x).1

theorem exactAbsChainMap_endpoints {S A I Q B J : Type}
    {C₁ : CausalSystem S A I} {C₂ : CausalSystem Q B J}
    {π : S → Q} {φ : A → B} {ω : I → J}
    (abs : ExactCausalAbs C₁ C₂ π φ ω) (i : I) (n : Nat)
    (x : (constFlatSpan (processStepSpan (C₁.proc i)) n).W) :
    (constFlatSpan (processStepSpan (C₂.proc (ω i))) n).left (exactAbsChainMap abs i n x) =
      π ((constFlatSpan (processStepSpan (C₁.proc i)) n).left x) ∧
    (constFlatSpan (processStepSpan (C₂.proc (ω i))) n).right (exactAbsChainMap abs i n x) =
      π ((constFlatSpan (processStepSpan (C₁.proc i)) n).right x) :=
  (exactAbsChainWithEnds abs i n x).2

/-- **Exact Lifting Eliminates Spurious Macro Trajectories:**
If `abs : ExactCausalAbs C₁ C₂ π φ ω` satisfies `abs.Lifts`, then every macro `n`-step trajectory
from `π s` lifts to an actual concrete trajectory in `constFlatSpan (processStepSpan (C₁.proc i)) n`
with matching endpoint projection (`Surj` on macro chains rooted at `π s`). -/
theorem exactCausal_lifts_implies_chi_surjective {S A I Q B J : Type}
    {C₁ : CausalSystem S A I} {C₂ : CausalSystem Q B J}
    {π : S → Q} {φ : A → B} {ω : I → J}
    (abs : ExactCausalAbs C₁ C₂ π φ ω) (lifts : abs.Lifts) (i : I) (n : Nat) :
    ∀ (s : S) (y : (constFlatSpan (processStepSpan (C₂.proc (ω i))) n).W),
      (constFlatSpan (processStepSpan (C₂.proc (ω i))) n).left y = π s →
      ∃ x : (constFlatSpan (processStepSpan (C₁.proc i)) n).W,
        (constFlatSpan (processStepSpan (C₁.proc i)) n).left x = s ∧
        (constFlatSpan (processStepSpan (C₂.proc (ω i))) n).right
          (exactAbsChainMap abs i n x) =
        (constFlatSpan (processStepSpan (C₂.proc (ω i))) n).right y := by
  induction n with
  | zero =>
    intro s y hy
    refine ⟨s, rfl, hy.symm⟩
  | succ m ih =>
    intro s y hy
    let hy0 : y.fst.src = π s := hy
    obtain ⟨a, m₁, _, hstep₁, hm₁⟩ := lifts i s y.fst.act y.fst.dst (hy0 ▸ y.fst.step)
    have hySnd : (constFlatSpan (processStepSpan (C₂.proc (ω i))) m).left y.snd = π m₁ :=
      y.mid.symm.trans hm₁.symm
    obtain ⟨xTail, hxLeft, hxRight⟩ := ih m₁ y.snd hySnd
    refine ⟨⟨⟨s, a, m₁, hstep₁⟩, xTail, hxLeft.symm⟩, rfl, hxRight⟩

/-- **Non-Surjective Macro History Counterexample on `CausalGoodhartWitness`:**
Under interventional `boost` (`true`), the macro proxy sustains `guardQ` forever from `π s₀ = .two`,
yielding a 3-step viable macro trace; yet NO concrete 3-step `micro` boost trace from `s₀` stays
viable (`micro_boost_proxy_collapses`), refuting surjectivity of viable-history abstraction. -/
theorem causalGoodhart_chi_non_surjective :
    ∃ (w : List Unit) (q₃ : CausalGoodhartWitness.Level),
      Trace (CausalGoodhartWitness.macroSys.proc true)
        (CausalGoodhartWitness.π CausalGoodhartWitness.s₀) w q₃ ∧
      CausalGoodhartWitness.guardQ q₃ ∧
      ¬ ∃ s₃, Trace (CausalGoodhartWitness.micro.proc true) CausalGoodhartWitness.s₀ w s₃ ∧
        CausalGoodhartWitness.guardQ (CausalGoodhartWitness.π s₃) := by
  obtain ⟨s₃, tr₃, hbadQ⟩ := CausalGoodhartWitness.micro_boost_proxy_collapses
  have hdet : ∀ s s', Trace (CausalGoodhartWitness.micro.proc true) CausalGoodhartWitness.s₀
      [(), (), ()] s → Trace (CausalGoodhartWitness.micro.proc true) CausalGoodhartWitness.s₀
      [(), (), ()] s' → s = s' := by
    intro s s' t₁ t₂
    match t₁, t₂ with
    | .cons h1 (.cons h2 (.cons h3 (.nil _))),
      .cons g1 (.cons g2 (.cons g3 (.nil _))) =>
      have h1' : _ = CausalGoodhartWitness.stepMicro true CausalGoodhartWitness.s₀ := h1
      have g1' : _ = CausalGoodhartWitness.stepMicro true CausalGoodhartWitness.s₀ := g1
      have e1 : _ = _ := h1'.trans g1'.symm
      rw [e1] at h2
      have h2' : _ = _ := h2
      have g2' : _ = _ := g2
      have e2 : _ = _ := h2'.trans g2'.symm
      rw [e2] at h3
      have h3' : _ = _ := h3
      have g3' : _ = _ := g3
      exact h3'.trans g3'.symm
  have hk := CausalGoodhartWitness.macro_boost_kernel.1
  have hq3 : CausalGoodhartWitness.guardQ .three := fun e => CausalGoodhartWitness.Level.noConfusion e
  have trQ : Trace (CausalGoodhartWitness.macroSys.proc true)
      (CausalGoodhartWitness.π CausalGoodhartWitness.s₀) [(), (), ()] .three :=
    .cons rfl (.cons rfl (.cons rfl (.nil _)))
  refine ⟨[(), (), ()], .three, trQ, hq3, ?_⟩
  intro ⟨s', tr', hgood'⟩
  have hseq := hdet s' s₃ tr' tr₃
  rw [hseq] at hgood'
  exact hbadQ hgood'

/-! ### Non-Injective `FiberViabilitySplit` & Coupled 2-Agent Alignment Witness -/

/-- **Fiber Viability Split:** Two microscopic histories collapse under `chi : U → V` yet disagree on
a viability kernel `K : U → Prop`. -/
def FiberViabilitySplit {U V : Type} (chiMap : U → V) (K : U → Prop) : Prop :=
  ∃ u₁ u₂ : U, chiMap u₁ = chiMap u₂ ∧ K u₁ ∧ ¬ K u₂

/-- Any macro viability predicate `Kq : V → Prop` over a `FiberViabilitySplit` either misses the
viable history `u₁` (`¬ (K u₁ → Kq (chi u₁))`) or certifies the collapsing one `u₂` (`¬ (Kq (chi u₂) → K u₂)`). -/
theorem fiberSplit_refutes_macro_viability_soundness {U V : Type}
    {chiMap : U → V} {K : U → Prop}
    (hsplit : FiberViabilitySplit chiMap K) (Kq : V → Prop) :
    ¬ ((∀ u, K u → Kq (chiMap u)) ∧ (∀ u, Kq (chiMap u) → K u)) := by
  intro ⟨hcomp, hsound⟩
  obtain ⟨u₁, u₂, heq, hk1, hnk2⟩ := hsplit
  exact hnk2 (hsound u₂ (heq ▸ hcomp u₁ hk1))

/- **Coupled 2-Agent `C₂` Alignment Witness (`C2CoupledAlignmentWitness`):**
Two boolean agents share a substrate stock `z : Nat` (`State := (Bool × Bool) × Nat`).
In-phase policies (`b₁ == b₂`) match substrate renewal (`z ↦ z`), keeping `1 ≤ z` eternally in
`Viability.Kernel`; anti-phase policies (`b₁ != b₂`) overdraw (`z ↦ z - 1`), crashing at step 1!
Component-wise `C₂` symmetry (`(b₁, b₂) ↦ ()`) erases relative phase (`FiberViabilitySplit` holds). -/
namespace C2CoupledAlignmentWitness

def CoupledState : Type := (Bool × Bool) × Nat

def stepFn (s : CoupledState) (_ : Unit) : CoupledState :=
  ((s.1.1, s.1.2), if s.1.1 == s.1.2 then s.2 else s.2 - 1)

def proc : Process CoupledState Unit :=
  Assurance.ofMap stepFn

def guardS (s : CoupledState) : Prop :=
  1 ≤ s.2

/-- Component-wise `C₂`-orbit projection erases individual flip orientation, keeping only `stock`. -/
def c2ProjMicro (s : CoupledState) : Nat :=
  s.2

def uInPhase : CoupledState := ((true, true), 1)
def uAntiPhase : CoupledState := ((true, false), 1)

theorem uInPhase_kernel : Viability.Kernel proc guardS uInPhase := by
  let cert : Viability.Certificate proc guardS (fun s => s = uInPhase) :=
    ⟨fun s hs => hs ▸ Nat.le_refl 1,
     fun s _ s' hstep hs => by
       have heq : s' = stepFn s () := hstep
       rw [hs] at heq
       exact heq⟩
  exact cert.kernel rfl

theorem uAntiPhase_not_kernel : ¬ Viability.Kernel proc guardS uAntiPhase := by
  intro hk
  have hr : Reach proc uAntiPhase ((true, false), 0) := ⟨[()], .cons rfl (.nil _)⟩
  exact Nat.not_succ_le_zero 0 (hk ((true, false), 0) hr)

/-- **Witnessed `FiberViabilitySplit` on Coupled 2-Agent System (`2 → 1` alignment collapse):**
`(true, true, 1)` and `(true, false, 1)` have identical component-wise projections `c2ProjMicro = 1`,
yet one stays eternally viable while the other immediately depletes! -/
theorem c2_coupled_fiber_split :
    FiberViabilitySplit c2ProjMicro (Viability.Kernel proc guardS) :=
  ⟨uInPhase, uAntiPhase, rfl, uInPhase_kernel, uAntiPhase_not_kernel⟩

theorem c2_coupled_no_macro_soundness (Kq : Nat → Prop) :
    ¬ ((∀ s, Viability.Kernel proc guardS s → Kq (c2ProjMicro s)) ∧
       (∀ s, Kq (c2ProjMicro s) → Viability.Kernel proc guardS s)) :=
  fiberSplit_refutes_macro_viability_soundness c2_coupled_fiber_split Kq

end C2CoupledAlignmentWitness

/-! ### Symmetric Monoidal Coproduct Distribution (`⊕`) & `BC`-Guarded Interchange (`v9 formal/66 §B1–B4`) -/

/-- Labeled disjoint union of two relational spans (`H ⊕ H'`). -/
def coprodSpan {A A' B B' : Type} (H : RelSpan A B) (H' : RelSpan A' B') :
    RelSpan (Sum A A') (Sum B B') where
  W := Sum H.W H'.W
  left := Sum.elim (fun w => .inl (H.left w)) (fun w => .inr (H'.left w))
  right := Sum.elim (fun w => .inl (H.right w)) (fun w => .inr (H'.right w))

/-- Constructive distributivity isomorphism (`v9 formal/66 B1–B2`):
`(H ⋆ K) ⊕ (H' ⋆ K') ≃ (H ⊕ H') ⋆ (K ⊕ K')`. -/
def coprod_pullback_iso {A D C A' D' C' : Type}
    (H : RelSpan A D) (K : RelSpan D C) (H' : RelSpan A' D') (K' : RelSpan D' C') :
    Bij (Sum (PullbackElem H.right K.left) (PullbackElem H'.right K'.left))
      (PullbackElem (coprodSpan H H').right (coprodSpan K K').left) where
  toFun
    | .inl p => ⟨.inl p.fst, .inl p.snd, congrArg Sum.inl p.mid⟩
    | .inr q => ⟨.inr q.fst, .inr q.snd, congrArg Sum.inr q.mid⟩
  invFun
    | ⟨.inl w, .inl v, hm⟩ => .inl ⟨w, v, Sum.inl.inj hm⟩
    | ⟨.inr w, .inr v, hm⟩ => .inr ⟨w, v, Sum.inr.inj hm⟩
    | ⟨.inl _, .inr _, hm⟩ => False.elim (by cases hm)
    | ⟨.inr _, .inl _, hm⟩ => False.elim (by cases hm)
  left_inv
    | .inl _ => rfl
    | .inr _ => rfl
  right_inv p := by
    obtain ⟨a, b, m⟩ := p
    cases a <;> cases b
    · rfl
    · exact False.elim (by cases m)
    · exact False.elim (by cases m)
    · rfl

/-- Functorial `⊕`-compatibility (`v9 formal/66 B3–B4`):
For any functor `F` preserving finite `Sum` via `qSum : F(X ⊕ Y) ≃ FX ⊕ FY` respecting injections,
`F` is **strong on disjoint parallel `⊕`** while **oplax on sequential time `⋆`**, and the two
comparisons agree on `(W ⊕ W') ×_{D ⊕ D'} (V ⊕ V')`. -/
structure SumPreservingFunctor where
  toFunctor : SpanFunctor
  sumBij : ∀ (X Y : Type), Bij (toFunctor.obj (Sum X Y)) (Sum (toFunctor.obj X) (toFunctor.obj Y))
  sum_inl : ∀ {X Y : Type} (u : toFunctor.obj X),
    (sumBij X Y).toFun (toFunctor.map Sum.inl u) = Sum.inl u
  sum_inr : ∀ {X Y : Type} (v : toFunctor.obj Y),
    (sumBij X Y).toFun (toFunctor.map Sum.inr v) = Sum.inr v

/-- **Strong-`⊕` vs Oplax-`⋆` Compatibility Theorem (`v9 formal/66 B4`):**
Evaluating `chi` on a copair `(H ⊕ H') ⋆ (K ⊕ K')` after canonical injection agrees projectionwise
across `sumBij` with injecting each component's `chi` on `(H ⋆ K)` and `(H' ⋆ K')`. -/
theorem coprod_strong_vs_time_oplax (S : SumPreservingFunctor)
    {A D C A' D' C' : Type}
    (H : RelSpan A D) (K : RelSpan D C) (H' : RelSpan A' D') (K' : RelSpan D' C') :
    (∀ u : S.toFunctor.obj (PullbackElem H.right K.left),
      (S.sumBij H.W H'.W).toFun
        ((chi S.toFunctor (coprodSpan H H') (coprodSpan K K')).map
          (S.toFunctor.map (coprod_pullback_iso H K H' K').toFun
            (S.toFunctor.map Sum.inl u))).fst =
        Sum.inl ((chi S.toFunctor H K).map u).fst ∧
      (S.sumBij K.W K'.W).toFun
        ((chi S.toFunctor (coprodSpan H H') (coprodSpan K K')).map
          (S.toFunctor.map (coprod_pullback_iso H K H' K').toFun
            (S.toFunctor.map Sum.inl u))).snd =
        Sum.inl ((chi S.toFunctor H K).map u).snd) ∧
    (∀ v : S.toFunctor.obj (PullbackElem H'.right K'.left),
      (S.sumBij H.W H'.W).toFun
        ((chi S.toFunctor (coprodSpan H H') (coprodSpan K K')).map
          (S.toFunctor.map (coprod_pullback_iso H K H' K').toFun
            (S.toFunctor.map Sum.inr v))).fst =
        Sum.inr ((chi S.toFunctor H' K').map v).fst ∧
      (S.sumBij K.W K'.W).toFun
        ((chi S.toFunctor (coprodSpan H H') (coprodSpan K K')).map
          (S.toFunctor.map (coprod_pullback_iso H K H' K').toFun
            (S.toFunctor.map Sum.inr v))).snd =
        Sum.inr ((chi S.toFunctor H' K').map v).snd) := by
  let iso := (coprod_pullback_iso H K H' K').toFun
  let F := S.toFunctor
  constructor
  · intro u
    constructor
    · have h1 : F.map (@PullbackElem.fst _ _ _ (coprodSpan H H').right (coprodSpan K K').left)
          (F.map iso (F.map (@Sum.inl _ (PullbackElem H'.right K'.left)) u)) =
          F.map (fun z => (iso (Sum.inl z)).fst) u :=
        (F.map_comp _ iso _).symm.trans (F.map_comp _ Sum.inl u).symm
      have h2 : F.map (fun z : PullbackElem H.right K.left => (iso (Sum.inl z)).fst) u =
          F.map (fun z : PullbackElem H.right K.left => (Sum.inl z.fst : Sum H.W H'.W)) u :=
        F.map_congr (fun _ => rfl) u
      have h3 : F.map (fun z : PullbackElem H.right K.left => (Sum.inl z.fst : Sum H.W H'.W)) u =
          F.map (@Sum.inl H.W H'.W) (F.map PullbackElem.fst u) :=
        F.map_comp (@Sum.inl H.W H'.W) PullbackElem.fst u
      exact (congrArg (S.sumBij H.W H'.W).toFun (h1.trans (h2.trans h3))).trans
        (S.sum_inl (F.map PullbackElem.fst u))
    · have h1 : F.map (@PullbackElem.snd _ _ _ (coprodSpan H H').right (coprodSpan K K').left)
          (F.map iso (F.map (@Sum.inl _ (PullbackElem H'.right K'.left)) u)) =
          F.map (fun z => (iso (Sum.inl z)).snd) u :=
        (F.map_comp _ iso _).symm.trans (F.map_comp _ Sum.inl u).symm
      have h2 : F.map (fun z : PullbackElem H.right K.left => (iso (Sum.inl z)).snd) u =
          F.map (fun z : PullbackElem H.right K.left => (Sum.inl z.snd : Sum K.W K'.W)) u :=
        F.map_congr (fun _ => rfl) u
      have h3 : F.map (fun z : PullbackElem H.right K.left => (Sum.inl z.snd : Sum K.W K'.W)) u =
          F.map (@Sum.inl K.W K'.W) (F.map PullbackElem.snd u) :=
        F.map_comp (@Sum.inl K.W K'.W) PullbackElem.snd u
      exact (congrArg (S.sumBij K.W K'.W).toFun (h1.trans (h2.trans h3))).trans
        (S.sum_inl (F.map PullbackElem.snd u))
  · intro v
    constructor
    · have h1 : F.map (@PullbackElem.fst _ _ _ (coprodSpan H H').right (coprodSpan K K').left)
          (F.map iso (F.map (@Sum.inr (PullbackElem H.right K.left) _) v)) =
          F.map (fun z => (iso (Sum.inr z)).fst) v :=
        (F.map_comp _ iso _).symm.trans (F.map_comp _ Sum.inr v).symm
      have h2 : F.map (fun z : PullbackElem H'.right K'.left => (iso (Sum.inr z)).fst) v =
          F.map (fun z : PullbackElem H'.right K'.left => (Sum.inr z.fst : Sum H.W H'.W)) v :=
        F.map_congr (fun _ => rfl) v
      have h3 : F.map (fun z : PullbackElem H'.right K'.left => (Sum.inr z.fst : Sum H.W H'.W)) v =
          F.map (@Sum.inr H.W H'.W) (F.map PullbackElem.fst v) :=
        F.map_comp (@Sum.inr H.W H'.W) PullbackElem.fst v
      exact (congrArg (S.sumBij H.W H'.W).toFun (h1.trans (h2.trans h3))).trans
        (S.sum_inr (F.map PullbackElem.fst v))
    · have h1 : F.map (@PullbackElem.snd _ _ _ (coprodSpan H H').right (coprodSpan K K').left)
          (F.map iso (F.map (@Sum.inr (PullbackElem H.right K.left) _) v)) =
          F.map (fun z => (iso (Sum.inr z)).snd) v :=
        (F.map_comp _ iso _).symm.trans (F.map_comp _ Sum.inr v).symm
      have h2 : F.map (fun z : PullbackElem H'.right K'.left => (iso (Sum.inr z)).snd) v =
          F.map (fun z : PullbackElem H'.right K'.left => (Sum.inr z.snd : Sum K.W K'.W)) v :=
        F.map_congr (fun _ => rfl) v
      have h3 : F.map (fun z : PullbackElem H'.right K'.left => (Sum.inr z.snd : Sum K.W K'.W)) v =
          F.map (@Sum.inr K.W K'.W) (F.map PullbackElem.snd v) :=
        F.map_comp (@Sum.inr K.W K'.W) PullbackElem.snd v
      exact (congrArg (S.sumBij K.W K'.W).toFun (h1.trans (h2.trans h3))).trans
        (S.sum_inr (F.map PullbackElem.snd v))

/-! ### BC-Guarded Interchange & 3D Concurrent Reconfiguration Guards (`PolyComposition.SerialReconfigProcess`) -/

/-- **Guarded Interchange Theorem (`guarded_interchange_upgrades_iff_bc`):**
Assembly/aggregation `F` upgrades its lax time comparison `chi F H K` to a two-sided isomorphism
(`HasInverse` / `IsBijective`) iff `FImageIsPullback F H K` iff `β_E` is bijective for ALL families `E`. -/
theorem guarded_interchange_upgrades_iff_bc (F : SpanFunctor) {A D C : Type}
    (H : RelSpan A D) (K : RelSpan D C) :
    (IsBijective (chi F H K).map ↔ FImageIsPullback F H K) ∧
    (IsBijective (chi F H K).map ↔ ∀ (E : F.obj H.W → Type) (v : F.obj K.W),
      IsBijective (bcMap F H K E v)) :=
  ⟨chi_bijective_iff_pullback F H K, chi_bijective_iff_bc_all F H K⟩

/-- **Shared-Reserve Breakdown vs Serialized Concurrent 3D Reconfiguration (`reserve_disjoint_vs_serial_reconfig`):**
1. When two concurrent mode transitions do NOT share coupled substrate limits (disjoint independent
   coproduct `⊕`), concurrent reconfiguration distributes cleanly across time (`coprod_pullback_iso`);
2. Under shared coupled substrate draw (`PolyComposition.ConcurrentSerialWitness`), unserialized
   concurrent updates crash `4 -> 3 -> 1 -> 0` violating `Viability.Kernel`, whereas `csProc`
   (`SerialReconfigProcess`) rejects stale-epoch concurrent proposals (`reconfigure_stales_epoch`)
   and certifies closed-loop `Viability.Kernel` persistence. -/
theorem reserve_disjoint_vs_serial_reconfig :
    (∀ {A D C A' D' C' : Type}
      (H : RelSpan A D) (K : RelSpan D C) (H' : RelSpan A' D') (K' : RelSpan D' C'),
      IsBijective (coprod_pullback_iso H K H' K').toFun) ∧
    (PolyComposition.ConcurrentSerialWitness.csProc.step
      PolyComposition.ConcurrentSerialWitness.st₀
      (.reconfigA PolyComposition.ConcurrentSerialWitness.reqA)
      PolyComposition.ConcurrentSerialWitness.stA ∧
     Viability.Kernel PolyComposition.ConcurrentSerialWitness.csProc
       PolyComposition.ConcurrentSerialWitness.csGuard
       PolyComposition.ConcurrentSerialWitness.stA) ∧
    (PolyComposition.ConcurrentSerialWitness.csProc.step
      PolyComposition.ConcurrentSerialWitness.st₀
      (.reconfigB PolyComposition.ConcurrentSerialWitness.reqB)
      PolyComposition.ConcurrentSerialWitness.stB ∧
     Viability.Kernel PolyComposition.ConcurrentSerialWitness.csProc
       PolyComposition.ConcurrentSerialWitness.csGuard
       PolyComposition.ConcurrentSerialWitness.stB) ∧
    ((PolyComposition.ConcurrentSerialWitness.concurrentOrbit 0).1 () = 4 ∧
     (PolyComposition.ConcurrentSerialWitness.concurrentOrbit 1).1 () = 3 ∧
     (PolyComposition.ConcurrentSerialWitness.concurrentOrbit 2).1 () = 1 ∧
     (PolyComposition.ConcurrentSerialWitness.concurrentOrbit 3).1 () = 0 ∧
     ¬ Viability.Kernel PolyComposition.ConcurrentSerialWitness.concurrentUnguardedProcess
       (fun st => 3 ≤ st.1 ())
       (PolyComposition.ConcurrentSerialWitness.concurrentOrbit 0)) ∧
    (Transactions.fresh PolyComposition.ConcurrentSerialWitness.w₁.installation
      PolyComposition.ConcurrentSerialWitness.reqB.req = false ∧
     Reconfiguration.reconfigure
       PolyComposition.ConcurrentSerialWitness.reqB'.opened
       PolyComposition.ConcurrentSerialWitness.reqB'.amount
       PolyComposition.ConcurrentSerialWitness.reqB'.depth
       PolyComposition.ConcurrentSerialWitness.reqB'.candidate
       PolyComposition.ConcurrentSerialWitness.w₁ = none ∧
     (∀ st', ¬ PolyComposition.ConcurrentSerialWitness.csProc.step
       PolyComposition.ConcurrentSerialWitness.stA
       (.reconfigB PolyComposition.ConcurrentSerialWitness.reqB') st') ∧
     Viability.Kernel PolyComposition.ConcurrentSerialWitness.csProc
       PolyComposition.ConcurrentSerialWitness.csGuard
       PolyComposition.ConcurrentSerialWitness.st₀) :=
  ⟨fun H K H' K' => isBijective_of_bij (coprod_pullback_iso H K H' K'),
   PolyComposition.ConcurrentSerialWitness.concurrent_serial_dichotomy⟩

/-- **Grammar Bridge (`span_step_grammar_lumping`, via `Becoming.«像定后当且仅当同行»`):**
For any process `P : Process S A` whose step relation is `R s s' := ∃ a, P.step s a s'`,
the projected step image `«像» π R` is right-deterministic (`«定后» («像» π R)`) IF AND ONLY IF
`R` goes alike with projection equivalence `fun s s' => π s = π s'` (`«同行»`). -/
theorem span_step_grammar_lumping {S Q A : Type} (P : Process S A) (π : S → Q) :
    «定后» («像» π (fun s s' => ∃ a, P.step s a s')) ↔
      «同行» (fun s s' => ∃ a, P.step s a s') (fun s s' : S => π s = π s') :=
  «像定后当且仅当同行»

end OplaxHistory

end Becoming
