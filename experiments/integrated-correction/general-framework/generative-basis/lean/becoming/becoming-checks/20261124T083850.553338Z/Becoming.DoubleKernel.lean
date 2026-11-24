import Becoming.OplaxHistory
import Becoming.CoreHelpers

/-!
# Strict Double-Category & Relative 3D Kernel, Plus Guarded Oplax Double Syntax (`Becoming.DoubleKernel`)

AI-written (`Wave U6`, 24 November 2026). Every declaration compiles from Lean's prelude alone with
an empty axiom report (`0` axioms, `0` `propext`, `0` `Classical.choice`, `0` `Quot.sound`, `0`
`sorry`, `0` `private` declarations, `0` unnamed `instance`s, and `0` forbidden market words).

This module formalizes the strict 2D/3D syntax-certificate kernel of `WenHeHua v9.0` (`formal/59`
`T1`–`T5`, `Cor 4.0`, `Lem 6`, `T7`–`T9`) alongside our guarded oplax double syntax interpreting
directly into `Becoming.OplaxHistory`:

* **Part 1 — Strict 2D Bidirectional Signature, Typed Paths, Frames, & `T1`:**
  `DoubleSig`, typed object-carrying paths `TypedPath` (`nil` carries its object so empty paths on
  distinct objects stay distinct), `Frame` with matching corner objects, the 5-constructor term syntax
  `SqTerm` (`gen`, `idH`, `idV`, `compH`, `compV`), `HasFrame`, and unique framing `hasFrame_unique` (`T1`).
* **Part 2 — Explicit 10-Rule Equality Certificates (`T2`, `T4`, `T5`, `Cor 4.0`):**
  Constructive certificate calculus `EqCert` closing all 10 explicit strict double-category equations
  (`assocH`, `idH_l`, `idH_r`, `assocV`, `idV_l`, `idV_r`, `interchange`, `idH_compV`, `idV_compH`,
  `idH_idV`) under equivalence and contexts; frame preservation `eqCert_preserves_frame` (`T2`);
  quotient-free `StrictDoubleCat` semantics; model-independent soundness `eqCert_sound` (`T5`);
  initiality uniqueness `free_double_eval_unique` (`T4`); and generator-tally separation
  `distinct_same_frame_gens_not_cert_eq` (`Cor 4.0`).
* **Part 3 — Conservative Relative 3D Extension (`Lem 6`, `T8`, `T9`):**
  2-cell-framed directed 3D generators `Cell3Gen`, 3D terms `Cell3Term` (`gen3`, `id3`, `compR`,
  `compH3`, `compV3`, `transport` along `EqCert`), 3-cell equality calculus `Eq3Cert`, endpoint
  preservation `cell3_eq_preserves_endpoints` (`Lem 6`), base conservativity `conservative_over_base_2d`
  (`T9`), an explicit irreversible 3D witness `strict_2d_3d_noncollapse_witness` proved via a
  monotone 2-cell tally invariant, and `StrictTripleCat` soundness (`T8`).
* **Part 4 — Guarded Oplax Double Syntax into `Becoming.OplaxHistory`:**
  `GuardedExpr` and `GuardedProof` (`⊕` parallel distribution `parSeqDist`, `SumPreservingFunctor`
  compatibility `parStrongInj`, one-way oplax `chiStep`, and `BC`-guarded `chiInv`), sound evaluation
  `evalGuardedProof_sound` into `Becoming.OplaxHistory`, and `strict_vs_guarded_separation_witness`
  showing why unguarded interchange fails on `EmergentCrossSeamWitness` and `C2RelativeLossWitness`
  while guarded upgrades hold iff `BC` / `FImageIsPullback` holds.

What is not shown: a quadratic decision procedure for free 2D equivalence (`Delpeuch 2020`); checking
`EqCert` verifies supplied derivations and rejects uncertified terms without deciding non-equivalence
except via semantic refutation models (`Cor 4.0`). No empirical applicability claim is made (`Rule 2`).
-/

namespace Becoming

namespace DoubleKernel

/-- Zero-axiom binary congruence helper (prelude lacks `congrArg2`). -/
theorem congrArg2 {α β γ : Type} (f : α → β → γ) {a₁ a₂ : α} {b₁ b₂ : β}
    (ha : a₁ = a₂) (hb : b₁ = b₂) : f a₁ b₁ = f a₂ b₂ := by
  cases ha
  cases hb
  rfl

/-! ## Part 1: Strict 2D Bidirectional Signatures, Typed Paths, Frames, & `T1` -/

/-- Typed path in a directed graph `(src, tgt : Edge → Obj)` from object `x` to `y`.
The empty path `nil x` carries its endpoint `x` so empty paths on distinct objects never collapse. -/
inductive TypedPath {Obj Edge : Type} (src tgt : Edge → Obj) : Obj → Obj → Type where
  | nil (x : Obj) : TypedPath src tgt x x
  | cons {x y z : Obj} (e : Edge) (hs : src e = x) (ht : tgt e = y)
      (rest : TypedPath src tgt y z) : TypedPath src tgt x z

/-- Associative path concatenation `f ; g` in left-to-right order. -/
def pathComp {Obj Edge : Type} {src tgt : Edge → Obj} {x y z : Obj} :
    TypedPath src tgt x y → TypedPath src tgt y z → TypedPath src tgt x z
  | .nil _, q => q
  | .cons e hs ht r, q => .cons e hs ht (pathComp r q)

theorem pathComp_nil_l {Obj Edge : Type} {src tgt : Edge → Obj} {x y : Obj}
    (p : TypedPath src tgt x y) : pathComp (.nil x) p = p :=
  rfl

theorem pathComp_nil_r {Obj Edge : Type} {src tgt : Edge → Obj} {x y : Obj} :
    ∀ (p : TypedPath src tgt x y), pathComp p (.nil y) = p
  | .nil _ => rfl
  | .cons e hs ht r => congrArg (TypedPath.cons e hs ht) (pathComp_nil_r r)

theorem pathComp_assoc {Obj Edge : Type} {src tgt : Edge → Obj} {w x y z : Obj} :
    ∀ (p : TypedPath src tgt w x) (q : TypedPath src tgt x y) (r : TypedPath src tgt y z),
      pathComp (pathComp p q) r = pathComp p (pathComp q r)
  | .nil _, _, _ => rfl
  | .cons e hs ht s, q, r => congrArg (TypedPath.cons e hs ht) (pathComp_assoc s q r)

/-- Compatible 4-boundary frame `(tl, tr, bl, br; top, bot, left, right)`. -/
structure Frame {Obj HEdge VEdge : Type}
    (hSrc hTgt : HEdge → Obj) (vSrc vTgt : VEdge → Obj) where
  tl : Obj
  tr : Obj
  bl : Obj
  br : Obj
  top : TypedPath hSrc hTgt tl tr
  bot : TypedPath hSrc hTgt bl br
  left : TypedPath vSrc vTgt tl bl
  right : TypedPath vSrc vTgt tr br

/-- Extract transported `top`, `bot`, `left`, `right` equalities from `f₁ = f₂` without `.injEq`. -/
theorem frame_eq_components {Obj HEdge VEdge : Type}
    {hSrc hTgt : HEdge → Obj} {vSrc vTgt : VEdge → Obj}
    {f₁ f₂ : Frame hSrc hTgt vSrc vTgt} (h : f₁ = f₂) :
    ∃ (htl : f₁.tl = f₂.tl) (htr : f₁.tr = f₂.tr)
      (hbl : f₁.bl = f₂.bl) (hbr : f₁.br = f₂.br),
      (htl ▸ htr ▸ f₁.top) = f₂.top ∧
      (hbl ▸ hbr ▸ f₁.bot) = f₂.bot ∧
      (htl ▸ hbl ▸ f₁.left) = f₂.left ∧
      (htr ▸ hbr ▸ f₁.right) = f₂.right := by
  cases h
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

/-- Construct `f₁ = f₂` from corner equalities and transported path equalities (0 `.injEq`, 0 axioms). -/
theorem frame_ext {Obj HEdge VEdge : Type}
    {hSrc hTgt : HEdge → Obj} {vSrc vTgt : VEdge → Obj}
    (f₁ f₂ : Frame hSrc hTgt vSrc vTgt)
    (htl : f₁.tl = f₂.tl) (htr : f₁.tr = f₂.tr)
    (hbl : f₁.bl = f₂.bl) (hbr : f₁.br = f₂.br)
    (htop : (htl ▸ htr ▸ f₁.top) = f₂.top)
    (hbot : (hbl ▸ hbr ▸ f₁.bot) = f₂.bot)
    (hleft : (htl ▸ hbl ▸ f₁.left) = f₂.left)
    (hright : (htr ▸ hbr ▸ f₁.right) = f₂.right) :
    f₁ = f₂ := by
  cases f₁ with
  | mk tl₁ tr₁ bl₁ br₁ top₁ bot₁ left₁ right₁ =>
    cases f₂ with
    | mk tl₂ tr₂ bl₂ br₂ top₂ bot₂ left₂ right₂ =>
      change tl₁ = tl₂ at htl
      change tr₁ = tr₂ at htr
      change bl₁ = bl₂ at hbl
      change br₁ = br₂ at hbr
      subst htl
      subst htr
      subst hbl
      subst hbr
      change top₁ = top₂ at htop
      change bot₁ = bot₂ at hbot
      change left₁ = left₂ at hleft
      change right₁ = right₂ at hright
      subst htop
      subst hbot
      subst hleft
      subst hright
      rfl

/-- Bidirectional 2D signature `Σ = (O, H, V, A; ∂)`. -/
structure DoubleSig where
  Obj : Type
  HGen : Type
  VGen : Type
  SqGen : Type
  hSrc : HGen → Obj
  hTgt : HGen → Obj
  vSrc : VGen → Obj
  vTgt : VGen → Obj
  sqFrame : SqGen → Frame hSrc hTgt vSrc vTgt

/-- Five-constructor square terms `P ::= a | I_h(u) | I_v(f) | P ⊙_h Q | P ⊙_v Q`. -/
inductive SqTerm (G : DoubleSig) : Type where
  | gen (a : G.SqGen) : SqTerm G
  | idH {a c : G.Obj} (u : TypedPath G.vSrc G.vTgt a c) : SqTerm G
  | idV {a b : G.Obj} (f : TypedPath G.hSrc G.hTgt a b) : SqTerm G
  | compH (P Q : SqTerm G) : SqTerm G
  | compV (P Q : SqTerm G) : SqTerm G

/-- Inductive framing relation enforcing exact typed boundary equality on `⊙_h` and `⊙_v`. -/
inductive HasFrame (G : DoubleSig) : SqTerm G → Frame G.hSrc G.hTgt G.vSrc G.vTgt → Prop where
  | gen (a : G.SqGen) : HasFrame G (.gen a) (G.sqFrame a)
  | idH {a c : G.Obj} (u : TypedPath G.vSrc G.vTgt a c) :
      HasFrame G (.idH u) ⟨a, a, c, c, .nil a, .nil c, u, u⟩
  | idV {a b : G.Obj} (f : TypedPath G.hSrc G.hTgt a b) :
      HasFrame G (.idV f) ⟨a, b, a, b, f, f, .nil a, .nil b⟩
  | compH {P Q : SqTerm G} {a b c d e f : G.Obj}
      {tP : TypedPath G.hSrc G.hTgt a b} {bP : TypedPath G.hSrc G.hTgt c d}
      {tQ : TypedPath G.hSrc G.hTgt b e} {bQ : TypedPath G.hSrc G.hTgt d f}
      {l : TypedPath G.vSrc G.vTgt a c} {m : TypedPath G.vSrc G.vTgt b d}
      {r : TypedPath G.vSrc G.vTgt e f}
      (hP : HasFrame G P ⟨a, b, c, d, tP, bP, l, m⟩)
      (hQ : HasFrame G Q ⟨b, e, d, f, tQ, bQ, m, r⟩) :
      HasFrame G (.compH P Q) ⟨a, e, c, f, pathComp tP tQ, pathComp bP bQ, l, r⟩
  | compV {P Q : SqTerm G} {a b c d e f : G.Obj}
      {t : TypedPath G.hSrc G.hTgt a b} {m : TypedPath G.hSrc G.hTgt c d}
      {botQ : TypedPath G.hSrc G.hTgt e f}
      {lP : TypedPath G.vSrc G.vTgt a c} {rP : TypedPath G.vSrc G.vTgt b d}
      {lQ : TypedPath G.vSrc G.vTgt c e} {rQ : TypedPath G.vSrc G.vTgt d f}
      (hP : HasFrame G P ⟨a, b, c, d, t, m, lP, rP⟩)
      (hQ : HasFrame G Q ⟨c, d, e, f, m, botQ, lQ, rQ⟩) :
      HasFrame G (.compV P Q) ⟨a, b, e, f, t, botQ, pathComp lP lQ, pathComp rP rQ⟩

/-- Helper unifying `pathComp` along equal intermediate endpoints without `.injEq`. -/
theorem pathComp_subst {Obj Edge : Type} {src tgt : Edge → Obj}
    {x₁ y₁ z₁ x₂ y₂ z₂ : Obj}
    (hx : x₁ = x₂) (hy : y₁ = y₂) (hz : z₁ = z₂)
    {p₁ : TypedPath src tgt x₁ y₁} {p₂ : TypedPath src tgt x₂ y₂}
    {q₁ : TypedPath src tgt y₁ z₁} {q₂ : TypedPath src tgt y₂ z₂}
    (hp : (hx ▸ hy ▸ p₁) = p₂) (hq : (hy ▸ hz ▸ q₁) = q₂) :
    (hx ▸ hz ▸ pathComp p₁ q₁) = pathComp p₂ q₂ := by
  cases hx
  cases hy
  cases hz
  cases hp
  cases hq
  rfl

/-- **Theorem 1 (`v9 formal/59` Prop 1 / `T1`):**
Every well-formed `SqTerm G` has a unique compatible 4-boundary `Frame`. -/
theorem hasFrame_unique {G : DoubleSig} :
    ∀ {P : SqTerm G} {φ₁ φ₂ : Frame G.hSrc G.hTgt G.vSrc G.vTgt},
      HasFrame G P φ₁ → HasFrame G P φ₂ → φ₁ = φ₂
  | .gen _, _, _, h1, h2 => by
    cases h1
    cases h2
    rfl
  | .idH _, _, _, h1, h2 => by
    cases h1
    cases h2
    rfl
  | .idV _, _, _, h1, h2 => by
    cases h1
    cases h2
    rfl
  | .compH P Q, _, _, h1, h2 => by
    cases h1 with
    | compH hP1 hQ1 =>
      cases h2 with
      | compH hP2 hQ2 =>
        obtain ⟨htl1, htr1, hbl1, hbr1, htop1, hbot1, hleft1, hright1⟩ :=
          frame_eq_components (hasFrame_unique hP1 hP2)
        obtain ⟨htl2, htr2, hbl2, hbr2, htop2, hbot2, hleft2, hright2⟩ :=
          frame_eq_components (hasFrame_unique hQ1 hQ2)
        exact frame_ext _ _ htl1 htr2 hbl1 hbr2
          (pathComp_subst htl1 htr1 htr2 htop1 htop2)
          (pathComp_subst hbl1 hbr1 hbr2 hbot1 hbot2)
          hleft1 hright2
  | .compV P Q, _, _, h1, h2 => by
    cases h1 with
    | compV hP1 hQ1 =>
      cases h2 with
      | compV hP2 hQ2 =>
        obtain ⟨htl1, htr1, hbl1, hbr1, htop1, hbot1, hleft1, hright1⟩ :=
          frame_eq_components (hasFrame_unique hP1 hP2)
        obtain ⟨htl2, htr2, hbl2, hbr2, htop2, hbot2, hleft2, hright2⟩ :=
          frame_eq_components (hasFrame_unique hQ1 hQ2)
        exact frame_ext _ _ htl1 htr1 hbl2 hbr2
          htop1 hbot2
          (pathComp_subst htl1 hbl1 hbl2 hleft1 hleft2)
          (pathComp_subst htr1 hbr1 hbr2 hright1 hright2)

/-! ## Part 2: 10-Rule Equality Certificates (`T2`, `T4`, `T5`, `Cor 4.0`) -/

/-- Constructive equality certificate tree on well-framed 2D terms (`v9 formal/59 §3` & `§5`):
equivalence (`refl`, `symm`, `trans`), directional contexts (`congH`, `congV`), and all 10 explicit
strict double-category structural laws (`assocH`, `idH_l`, `idH_r`, `assocV`, `idV_l`, `idV_r`,
`interchange`, `idH_compV`, `idV_compH`, `idH_idV`). Every rule checks exact boundary compatibility. -/
inductive EqCert (G : DoubleSig) : SqTerm G → SqTerm G → Prop where
  | refl {P : SqTerm G} {φ : Frame G.hSrc G.hTgt G.vSrc G.vTgt} (hP : HasFrame G P φ) :
      EqCert G P P
  | symm {P Q : SqTerm G} (h : EqCert G P Q) : EqCert G Q P
  | trans {P Q R : SqTerm G} (h1 : EqCert G P Q) (h2 : EqCert G Q R) : EqCert G P R
  | congH {P₁ P₂ Q₁ Q₂ : SqTerm G} {a b c d e f : G.Obj}
      {tP : TypedPath G.hSrc G.hTgt a b} {bP : TypedPath G.hSrc G.hTgt c d}
      {tQ : TypedPath G.hSrc G.hTgt b e} {bQ : TypedPath G.hSrc G.hTgt d f}
      {l : TypedPath G.vSrc G.vTgt a c} {m : TypedPath G.vSrc G.vTgt b d}
      {r : TypedPath G.vSrc G.vTgt e f}
      (hP : EqCert G P₁ P₂) (hQ : EqCert G Q₁ Q₂)
      (hFP : HasFrame G P₁ ⟨a, b, c, d, tP, bP, l, m⟩)
      (hFQ : HasFrame G Q₁ ⟨b, e, d, f, tQ, bQ, m, r⟩) :
      EqCert G (.compH P₁ Q₁) (.compH P₂ Q₂)
  | congV {P₁ P₂ Q₁ Q₂ : SqTerm G} {a b c d e f : G.Obj}
      {t : TypedPath G.hSrc G.hTgt a b} {m : TypedPath G.hSrc G.hTgt c d}
      {botQ : TypedPath G.hSrc G.hTgt e f}
      {lP : TypedPath G.vSrc G.vTgt a c} {rP : TypedPath G.vSrc G.vTgt b d}
      {lQ : TypedPath G.vSrc G.vTgt c e} {rQ : TypedPath G.vSrc G.vTgt d f}
      (hP : EqCert G P₁ P₂) (hQ : EqCert G Q₁ Q₂)
      (hFP : HasFrame G P₁ ⟨a, b, c, d, t, m, lP, rP⟩)
      (hFQ : HasFrame G Q₁ ⟨c, d, e, f, m, botQ, lQ, rQ⟩) :
      EqCert G (.compV P₁ Q₁) (.compV P₂ Q₂)
  -- (1) Horizontal associativity
  | assocH {P Q R : SqTerm G} {a b c d e f g₁ h₁ : G.Obj}
      {tP : TypedPath G.hSrc G.hTgt a b} {bP : TypedPath G.hSrc G.hTgt c d}
      {tQ : TypedPath G.hSrc G.hTgt b e} {bQ : TypedPath G.hSrc G.hTgt d f}
      {tR : TypedPath G.hSrc G.hTgt e g₁} {bR : TypedPath G.hSrc G.hTgt f h₁}
      {v₀ : TypedPath G.vSrc G.vTgt a c} {v₁ : TypedPath G.vSrc G.vTgt b d}
      {v₂ : TypedPath G.vSrc G.vTgt e f} {v₃ : TypedPath G.vSrc G.vTgt g₁ h₁}
      (hP : HasFrame G P ⟨a, b, c, d, tP, bP, v₀, v₁⟩)
      (hQ : HasFrame G Q ⟨b, e, d, f, tQ, bQ, v₁, v₂⟩)
      (hR : HasFrame G R ⟨e, g₁, f, h₁, tR, bR, v₂, v₃⟩) :
      EqCert G (.compH (.compH P Q) R) (.compH P (.compH Q R))
  -- (2) Left horizontal unit
  | idH_l {P : SqTerm G} {a b c d : G.Obj}
      {t : TypedPath G.hSrc G.hTgt a b} {bot : TypedPath G.hSrc G.hTgt c d}
      {l : TypedPath G.vSrc G.vTgt a c} {r : TypedPath G.vSrc G.vTgt b d}
      (hP : HasFrame G P ⟨a, b, c, d, t, bot, l, r⟩) :
      EqCert G (.compH (.idH l) P) P
  -- (3) Right horizontal unit
  | idH_r {P : SqTerm G} {a b c d : G.Obj}
      {t : TypedPath G.hSrc G.hTgt a b} {bot : TypedPath G.hSrc G.hTgt c d}
      {l : TypedPath G.vSrc G.vTgt a c} {r : TypedPath G.vSrc G.vTgt b d}
      (hP : HasFrame G P ⟨a, b, c, d, t, bot, l, r⟩) :
      EqCert G (.compH P (.idH r)) P
  -- (4) Vertical associativity
  | assocV {P Q R : SqTerm G} {a b c d e f g₁ h₁ : G.Obj}
      {h₀ : TypedPath G.hSrc G.hTgt a b} {h₁p : TypedPath G.hSrc G.hTgt c d}
      {h₂ : TypedPath G.hSrc G.hTgt e f} {h₃ : TypedPath G.hSrc G.hTgt g₁ h₁}
      {lP : TypedPath G.vSrc G.vTgt a c} {rP : TypedPath G.vSrc G.vTgt b d}
      {lQ : TypedPath G.vSrc G.vTgt c e} {rQ : TypedPath G.vSrc G.vTgt d f}
      {lR : TypedPath G.vSrc G.vTgt e g₁} {rR : TypedPath G.vSrc G.vTgt f h₁}
      (hP : HasFrame G P ⟨a, b, c, d, h₀, h₁p, lP, rP⟩)
      (hQ : HasFrame G Q ⟨c, d, e, f, h₁p, h₂, lQ, rQ⟩)
      (hR : HasFrame G R ⟨e, f, g₁, h₁, h₂, h₃, lR, rR⟩) :
      EqCert G (.compV (.compV P Q) R) (.compV P (.compV Q R))
  -- (5) Left (top) vertical unit
  | idV_l {P : SqTerm G} {a b c d : G.Obj}
      {t : TypedPath G.hSrc G.hTgt a b} {bot : TypedPath G.hSrc G.hTgt c d}
      {l : TypedPath G.vSrc G.vTgt a c} {r : TypedPath G.vSrc G.vTgt b d}
      (hP : HasFrame G P ⟨a, b, c, d, t, bot, l, r⟩) :
      EqCert G (.compV (.idV t) P) P
  -- (6) Right (bottom) vertical unit
  | idV_r {P : SqTerm G} {a b c d : G.Obj}
      {t : TypedPath G.hSrc G.hTgt a b} {bot : TypedPath G.hSrc G.hTgt c d}
      {l : TypedPath G.vSrc G.vTgt a c} {r : TypedPath G.vSrc G.vTgt b d}
      (hP : HasFrame G P ⟨a, b, c, d, t, bot, l, r⟩) :
      EqCert G (.compV P (.idV bot)) P
  -- (7) Middle-four interchange with exact 4 internal matching interfaces
  | interchange {P Q R S : SqTerm G} {o₀₀ o₀₁ o₀₂ o₁₀ o₁₁ o₁₂ o₂₀ o₂₁ o₂₂ : G.Obj}
      {tP : TypedPath G.hSrc G.hTgt o₀₀ o₀₁} {tQ : TypedPath G.hSrc G.hTgt o₀₁ o₀₂}
      {mPR : TypedPath G.hSrc G.hTgt o₁₀ o₁₁} {mQS : TypedPath G.hSrc G.hTgt o₁₁ o₁₂}
      {bR : TypedPath G.hSrc G.hTgt o₂₀ o₂₁} {bS : TypedPath G.hSrc G.hTgt o₂₁ o₂₂}
      {lP : TypedPath G.vSrc G.vTgt o₀₀ o₁₀} {mPQ : TypedPath G.vSrc G.vTgt o₀₁ o₁₁}
      {rQ : TypedPath G.vSrc G.vTgt o₀₂ o₁₂} {lR : TypedPath G.vSrc G.vTgt o₁₀ o₂₀}
      {mRS : TypedPath G.vSrc G.vTgt o₁₁ o₂₁} {rS : TypedPath G.vSrc G.vTgt o₁₂ o₂₂}
      (hP : HasFrame G P ⟨o₀₀, o₀₁, o₁₀, o₁₁, tP, mPR, lP, mPQ⟩)
      (hQ : HasFrame G Q ⟨o₀₁, o₀₂, o₁₁, o₁₂, tQ, mQS, mPQ, rQ⟩)
      (hR : HasFrame G R ⟨o₁₀, o₁₁, o₂₀, o₂₁, mPR, bR, lR, mRS⟩)
      (hS : HasFrame G S ⟨o₁₁, o₁₂, o₂₁, o₂₂, mQS, bS, mRS, rS⟩) :
      EqCert G (.compV (.compH P Q) (.compH R S)) (.compH (.compV P R) (.compV Q S))
  -- (8) Vertical functoriality of `idH`
  | idH_compV {a c e : G.Obj} (u : TypedPath G.vSrc G.vTgt a c) (v : TypedPath G.vSrc G.vTgt c e) :
      EqCert G (.idH (pathComp u v)) (.compV (.idH u) (.idH v))
  -- (9) Horizontal functoriality of `idV`
  | idV_compH {a b e : G.Obj} (f : TypedPath G.hSrc G.hTgt a b) (g : TypedPath G.hSrc G.hTgt b e) :
      EqCert G (.idV (pathComp f g)) (.compH (.idV f) (.idV g))
  -- (10) Compatibility of empty horizontal and vertical identity cells at an object `x`
  | idH_idV (x : G.Obj) :
      EqCert G (.idH (.nil x)) (.idV (.nil x))

/-- **Theorem 2 (`v9 formal/59` Prop 2 / `T2`):**
Every derivable `EqCert G P Q` relates well-framed terms with the EXACT SAME `Frame`. -/
theorem eqCert_preserves_frame {G : DoubleSig} :
    ∀ {P Q : SqTerm G}, EqCert G P Q →
      ∃ φ : Frame G.hSrc G.hTgt G.vSrc G.vTgt, HasFrame G P φ ∧ HasFrame G Q φ
  | _, _, .refl hP => ⟨_, hP, hP⟩
  | _, _, .symm h =>
    let ⟨φ, hp, hq⟩ := eqCert_preserves_frame h
    ⟨φ, hq, hp⟩
  | _, _, .trans h1 h2 =>
    let ⟨φ, hp, hq1⟩ := eqCert_preserves_frame h1
    let ⟨_, hq2, hr⟩ := eqCert_preserves_frame h2
    let heq := hasFrame_unique hq1 hq2
    ⟨φ, hp, heq ▸ hr⟩
  | _, _, .congH hP hQ hFP hFQ =>
    let ⟨_, hP1, hP2⟩ := eqCert_preserves_frame hP
    let ⟨_, hQ1, hQ2⟩ := eqCert_preserves_frame hQ
    let hP2' : HasFrame G _ _ := hasFrame_unique hP1 hFP ▸ hP2
    let hQ2' : HasFrame G _ _ := hasFrame_unique hQ1 hFQ ▸ hQ2
    ⟨_, .compH hFP hFQ, .compH hP2' hQ2'⟩
  | _, _, .congV hP hQ hFP hFQ =>
    let ⟨_, hP1, hP2⟩ := eqCert_preserves_frame hP
    let ⟨_, hQ1, hQ2⟩ := eqCert_preserves_frame hQ
    let hP2' : HasFrame G _ _ := hasFrame_unique hP1 hFP ▸ hP2
    let hQ2' : HasFrame G _ _ := hasFrame_unique hQ1 hFQ ▸ hQ2
    ⟨_, .compV hFP hFQ, .compV hP2' hQ2'⟩
  | _, _, .assocH (tP := tP) (bP := bP) (tQ := tQ) (bQ := bQ) (tR := tR) (bR := bR) hP hQ hR =>
    let hL := HasFrame.compH (.compH hP hQ) hR
    let hRhs0 := HasFrame.compH hP (.compH hQ hR)
    have ht : pathComp (pathComp tP tQ) tR = pathComp tP (pathComp tQ tR) := pathComp_assoc tP tQ tR
    have hb : pathComp (pathComp bP bQ) bR = pathComp bP (pathComp bQ bR) := pathComp_assoc bP bQ bR
    let hRhs : HasFrame G _ ⟨_, _, _, _, pathComp (pathComp tP tQ) tR, pathComp (pathComp bP bQ) bR, _, _⟩ :=
      ht ▸ hb ▸ hRhs0
    ⟨_, hL, hRhs⟩
  | _, _, .idH_l (l := l) hP =>
    ⟨_, .compH (.idH l) hP, hP⟩
  | _, _, .idH_r (t := t) (bot := bot) (r := r) hP =>
    have ht : pathComp t (.nil _) = t := pathComp_nil_r t
    have hb : pathComp bot (.nil _) = bot := pathComp_nil_r bot
    ⟨_, ht ▸ hb ▸ (.compH hP (.idH r)), hP⟩
  | _, _, .assocV (lP := lP) (rP := rP) (lQ := lQ) (rQ := rQ) (lR := lR) (rR := rR) hP hQ hR =>
    let hL := HasFrame.compV (.compV hP hQ) hR
    let hRhs0 := HasFrame.compV hP (.compV hQ hR)
    have hl : pathComp (pathComp lP lQ) lR = pathComp lP (pathComp lQ lR) := pathComp_assoc lP lQ lR
    have hr : pathComp (pathComp rP rQ) rR = pathComp rP (pathComp rQ rR) := pathComp_assoc rP rQ rR
    let hRhs : HasFrame G _ ⟨_, _, _, _, _, _, pathComp (pathComp lP lQ) lR, pathComp (pathComp rP rQ) rR⟩ :=
      hl ▸ hr ▸ hRhs0
    ⟨_, hL, hRhs⟩
  | _, _, .idV_l (t := t) hP =>
    ⟨_, .compV (.idV t) hP, hP⟩
  | _, _, .idV_r (l := l) (r := r) (bot := bot) hP =>
    have hl : pathComp l (.nil _) = l := pathComp_nil_r l
    have hr : pathComp r (.nil _) = r := pathComp_nil_r r
    ⟨_, hl ▸ hr ▸ (.compV hP (.idV bot)), hP⟩
  | _, _, .interchange hP hQ hR hS =>
    ⟨_, .compV (.compH hP hQ) (.compH hR hS), .compH (.compV hP hR) (.compV hQ hS)⟩
  | _, _, .idH_compV (a := a) (e := e) u v =>
    ⟨⟨a, a, e, e, .nil a, .nil e, pathComp u v, pathComp u v⟩,
     .idH (pathComp u v), .compV (.idH u) (.idH v)⟩
  | _, _, .idV_compH (a := a) (e := e) f g =>
    ⟨⟨a, e, a, e, pathComp f g, pathComp f g, .nil a, .nil e⟩,
     .idV (pathComp f g), .compH (.idV f) (.idV g)⟩
  | _, _, .idH_idV x =>
    ⟨⟨x, x, x, x, .nil x, .nil x, .nil x, .nil x⟩, .idH (.nil x), .idV (.nil x)⟩

theorem eqCert_frame_eq {G : DoubleSig} {P Q : SqTerm G} {φ₁ φ₂ : Frame G.hSrc G.hTgt G.vSrc G.vTgt}
    (hcert : EqCert G P Q) (hP : HasFrame G P φ₁) (hQ : HasFrame G Q φ₂) : φ₁ = φ₂ := by
  obtain ⟨φ, hp, hq⟩ := eqCert_preserves_frame hcert
  exact (hasFrame_unique hP hp).trans (hasFrame_unique hq hQ)

/-- Semantic strict double category (`DblCat`) represented on flat arrow/square carriers with guarded
boundary compatibility laws (zero dependent casts, zero `Quot`, zero `funext`). -/
structure StrictDoubleCat where
  Obj : Type
  H : Type
  V : Type
  Sq : Type
  hSrc : H → Obj
  hTgt : H → Obj
  vSrc : V → Obj
  vTgt : V → Obj
  hId : Obj → H
  vId : Obj → V
  hComp : H → H → H
  vComp : V → V → V
  top : Sq → H
  bot : Sq → H
  left : Sq → V
  right : Sq → V
  sqIdH : V → Sq
  sqIdV : H → Sq
  sqCompH : Sq → Sq → Sq
  sqCompV : Sq → Sq → Sq
  -- Boundary axioms for edges & units
  hId_src : ∀ x, hSrc (hId x) = x
  hId_tgt : ∀ x, hTgt (hId x) = x
  vId_src : ∀ x, vSrc (vId x) = x
  vId_tgt : ∀ x, vTgt (vId x) = x
  hComp_src : ∀ f g, hTgt f = hSrc g → hSrc (hComp f g) = hSrc f
  hComp_tgt : ∀ f g, hTgt f = hSrc g → hTgt (hComp f g) = hTgt g
  vComp_src : ∀ u v, vTgt u = vSrc v → vSrc (vComp u v) = vSrc u
  vComp_tgt : ∀ u v, vTgt u = vSrc v → vTgt (vComp u v) = vTgt v
  hAssoc : ∀ f g k, hTgt f = hSrc g → hTgt g = hSrc k →
    hComp (hComp f g) k = hComp f (hComp g k)
  hId_l : ∀ f, hComp (hId (hSrc f)) f = f
  hId_r : ∀ f, hComp f (hId (hTgt f)) = f
  vAssoc : ∀ u v w, vTgt u = vSrc v → vTgt v = vSrc w →
    vComp (vComp u v) w = vComp u (vComp v w)
  vId_l : ∀ u, vComp (vId (vSrc u)) u = u
  vId_r : ∀ u, vComp u (vId (vTgt u)) = u
  -- Square corner & operation boundaries
  sq_tl : ∀ p, hSrc (top p) = vSrc (left p)
  sq_tr : ∀ p, hTgt (top p) = vSrc (right p)
  sq_bl : ∀ p, hSrc (bot p) = vTgt (left p)
  sq_br : ∀ p, hTgt (bot p) = vTgt (right p)
  sqIdH_top : ∀ u, top (sqIdH u) = hId (vSrc u)
  sqIdH_bot : ∀ u, bot (sqIdH u) = hId (vTgt u)
  sqIdH_left : ∀ u, left (sqIdH u) = u
  sqIdH_right : ∀ u, right (sqIdH u) = u
  sqIdV_top : ∀ f, top (sqIdV f) = f
  sqIdV_bot : ∀ f, bot (sqIdV f) = f
  sqIdV_left : ∀ f, left (sqIdV f) = vId (hSrc f)
  sqIdV_right : ∀ f, right (sqIdV f) = vId (hTgt f)
  sqCompH_top : ∀ p q, right p = left q → top (sqCompH p q) = hComp (top p) (top q)
  sqCompH_bot : ∀ p q, right p = left q → bot (sqCompH p q) = hComp (bot p) (bot q)
  sqCompH_left : ∀ p q, right p = left q → left (sqCompH p q) = left p
  sqCompH_right : ∀ p q, right p = left q → right (sqCompH p q) = right q
  sqCompV_top : ∀ p q, bot p = top q → top (sqCompV p q) = top p
  sqCompV_bot : ∀ p q, bot p = top q → bot (sqCompV p q) = bot q
  sqCompV_left : ∀ p q, bot p = top q → left (sqCompV p q) = vComp (left p) (left q)
  sqCompV_right : ∀ p q, bot p = top q → right (sqCompV p q) = vComp (right p) (right q)
  -- The 10 strict double-category equations
  sqAssocH : ∀ p q r, right p = left q → right q = left r →
    sqCompH (sqCompH p q) r = sqCompH p (sqCompH q r)
  sqIdH_l : ∀ p, sqCompH (sqIdH (left p)) p = p
  sqIdH_r : ∀ p, sqCompH p (sqIdH (right p)) = p
  sqAssocV : ∀ p q r, bot p = top q → bot q = top r →
    sqCompV (sqCompV p q) r = sqCompV p (sqCompV q r)
  sqIdV_l : ∀ p, sqCompV (sqIdV (top p)) p = p
  sqIdV_r : ∀ p, sqCompV p (sqIdV (bot p)) = p
  sqInterchange : ∀ p q r s,
    right p = left q → right r = left s → bot p = top r → bot q = top s →
    sqCompV (sqCompH p q) (sqCompH r s) = sqCompH (sqCompV p r) (sqCompV q s)
  sqIdH_compV : ∀ u v, vTgt u = vSrc v → sqIdH (vComp u v) = sqCompV (sqIdH u) (sqIdH v)
  sqIdV_compH : ∀ f g, hTgt f = hSrc g → sqIdV (hComp f g) = sqCompH (sqIdV f) (sqIdV g)
  sqIdH_idV : ∀ x, sqIdH (vId x) = sqIdV (hId x)

/-- Raw path evaluator into `M.H` parameterized by object & generator maps (shared by `SigInterp`). -/
def evalHPathRaw {G : DoubleSig} {M : StrictDoubleCat}
    (onObj : G.Obj → M.Obj) (onHGen : G.HGen → M.H) :
    {x y : G.Obj} → TypedPath G.hSrc G.hTgt x y → M.H
  | _, _, .nil k => M.hId (onObj k)
  | _, _, .cons e _ _ rest => M.hComp (onHGen e) (evalHPathRaw onObj onHGen rest)

/-- Raw vertical path evaluator into `M.V` parameterized by object & generator maps. -/
def evalVPathRaw {G : DoubleSig} {M : StrictDoubleCat}
    (onObj : G.Obj → M.Obj) (onVGen : G.VGen → M.V) :
    {x y : G.Obj} → TypedPath G.vSrc G.vTgt x y → M.V
  | _, _, .nil k => M.vId (onObj k)
  | _, _, .cons e _ _ rest => M.vComp (onVGen e) (evalVPathRaw onObj onVGen rest)

/-- Signature interpretation `j : Σ → M` into a `StrictDoubleCat` respecting boundaries. -/
structure SigInterp (G : DoubleSig) (M : StrictDoubleCat) where
  onObj : G.Obj → M.Obj
  onHGen : G.HGen → M.H
  onVGen : G.VGen → M.V
  onSqGen : G.SqGen → M.Sq
  hSrc_eq : ∀ e, M.hSrc (onHGen e) = onObj (G.hSrc e)
  hTgt_eq : ∀ e, M.hTgt (onHGen e) = onObj (G.hTgt e)
  vSrc_eq : ∀ e, M.vSrc (onVGen e) = onObj (G.vSrc e)
  vTgt_eq : ∀ e, M.vTgt (onVGen e) = onObj (G.vTgt e)
  sqTop_eq : ∀ a, M.top (onSqGen a) = evalHPathRaw onObj onHGen (G.sqFrame a).top
  sqBot_eq : ∀ a, M.bot (onSqGen a) = evalHPathRaw onObj onHGen (G.sqFrame a).bot
  sqLeft_eq : ∀ a, M.left (onSqGen a) = evalVPathRaw onObj onVGen (G.sqFrame a).left
  sqRight_eq : ∀ a, M.right (onSqGen a) = evalVPathRaw onObj onVGen (G.sqFrame a).right

/-- Free horizontal path evaluation into `M.H`. -/
def evalHPath {G : DoubleSig} {M : StrictDoubleCat} (I : SigInterp G M) :
    {x y : G.Obj} → TypedPath G.hSrc G.hTgt x y → M.H :=
  evalHPathRaw I.onObj I.onHGen

/-- Free vertical path evaluation into `M.V`. -/
def evalVPath {G : DoubleSig} {M : StrictDoubleCat} (I : SigInterp G M) :
    {x y : G.Obj} → TypedPath G.vSrc G.vTgt x y → M.V :=
  evalVPathRaw I.onObj I.onVGen

theorem evalHPath_endpoints {G : DoubleSig} {M : StrictDoubleCat} (I : SigInterp G M) :
    ∀ {x y : G.Obj} (p : TypedPath G.hSrc G.hTgt x y),
      M.hSrc (evalHPath I p) = I.onObj x ∧ M.hTgt (evalHPath I p) = I.onObj y
  | _, _, .nil _ => ⟨M.hId_src _, M.hId_tgt _⟩
  | _, _, .cons e hs ht rest =>
    let ih := evalHPath_endpoints I rest
    have hmid : M.hTgt (I.onHGen e) = M.hSrc (evalHPath I rest) :=
      (I.hTgt_eq e).trans ((congrArg I.onObj ht).trans ih.1.symm)
    ⟨(M.hComp_src _ _ hmid).trans ((I.hSrc_eq e).trans (congrArg I.onObj hs)),
     (M.hComp_tgt _ _ hmid).trans ih.2⟩

theorem evalVPath_endpoints {G : DoubleSig} {M : StrictDoubleCat} (I : SigInterp G M) :
    ∀ {x y : G.Obj} (u : TypedPath G.vSrc G.vTgt x y),
      M.vSrc (evalVPath I u) = I.onObj x ∧ M.vTgt (evalVPath I u) = I.onObj y
  | _, _, .nil _ => ⟨M.vId_src _, M.vId_tgt _⟩
  | _, _, .cons e hs ht rest =>
    let ih := evalVPath_endpoints I rest
    have hmid : M.vTgt (I.onVGen e) = M.vSrc (evalVPath I rest) :=
      (I.vTgt_eq e).trans ((congrArg I.onObj ht).trans ih.1.symm)
    ⟨(M.vComp_src _ _ hmid).trans ((I.vSrc_eq e).trans (congrArg I.onObj hs)),
     (M.vComp_tgt _ _ hmid).trans ih.2⟩

theorem evalHPath_comp {G : DoubleSig} {M : StrictDoubleCat} (I : SigInterp G M) :
    ∀ {x y z : G.Obj} (p : TypedPath G.hSrc G.hTgt x y) (q : TypedPath G.hSrc G.hTgt y z),
      evalHPath I (pathComp p q) = M.hComp (evalHPath I p) (evalHPath I q)
  | x, _, _, .nil _, q => by
    dsimp only [pathComp, evalHPath, evalHPathRaw]
    have hsrc : M.hSrc (evalHPath I q) = I.onObj x := (evalHPath_endpoints I q).1
    rw [← hsrc]
    exact (M.hId_l (evalHPath I q)).symm
  | x, y, z, .cons e hs ht rest, q => by
    dsimp only [pathComp, evalHPath, evalHPathRaw]
    have ih := evalHPath_comp I rest q
    change M.hComp (I.onHGen e) (evalHPath I (pathComp rest q)) =
      M.hComp (M.hComp (I.onHGen e) (evalHPath I rest)) (evalHPath I q)
    rw [ih]
    have hm1 : M.hTgt (I.onHGen e) = M.hSrc (evalHPath I rest) :=
      (I.hTgt_eq e).trans ((congrArg I.onObj ht).trans (evalHPath_endpoints I rest).1.symm)
    have hm2 : M.hTgt (evalHPath I rest) = M.hSrc (evalHPath I q) :=
      (evalHPath_endpoints I rest).2.trans (evalHPath_endpoints I q).1.symm
    exact (M.hAssoc _ _ _ hm1 hm2).symm

theorem evalVPath_comp {G : DoubleSig} {M : StrictDoubleCat} (I : SigInterp G M) :
    ∀ {x y z : G.Obj} (u : TypedPath G.vSrc G.vTgt x y) (v : TypedPath G.vSrc G.vTgt y z),
      evalVPath I (pathComp u v) = M.vComp (evalVPath I u) (evalVPath I v)
  | x, _, _, .nil _, v => by
    dsimp only [pathComp, evalVPath, evalVPathRaw]
    have hsrc : M.vSrc (evalVPath I v) = I.onObj x := (evalVPath_endpoints I v).1
    rw [← hsrc]
    exact (M.vId_l (evalVPath I v)).symm
  | x, y, z, .cons e hs ht rest, v => by
    dsimp only [pathComp, evalVPath, evalVPathRaw]
    have ih := evalVPath_comp I rest v
    change M.vComp (I.onVGen e) (evalVPath I (pathComp rest v)) =
      M.vComp (M.vComp (I.onVGen e) (evalVPath I rest)) (evalVPath I v)
    rw [ih]
    have hm1 : M.vTgt (I.onVGen e) = M.vSrc (evalVPath I rest) :=
      (I.vTgt_eq e).trans ((congrArg I.onObj ht).trans (evalVPath_endpoints I rest).1.symm)
    have hm2 : M.vTgt (evalVPath I rest) = M.vSrc (evalVPath I v) :=
      (evalVPath_endpoints I rest).2.trans (evalVPath_endpoints I v).1.symm
    exact (M.vAssoc _ _ _ hm1 hm2).symm

/-- Free recursive evaluation `⟦·⟧ : SqTerm G → M.Sq`. -/
def evalSqTerm {G : DoubleSig} {M : StrictDoubleCat} (I : SigInterp G M) : SqTerm G → M.Sq
  | .gen a => I.onSqGen a
  | .idH u => M.sqIdH (evalVPath I u)
  | .idV f => M.sqIdV (evalHPath I f)
  | .compH P Q => M.sqCompH (evalSqTerm I P) (evalSqTerm I Q)
  | .compV P Q => M.sqCompV (evalSqTerm I P) (evalSqTerm I Q)

theorem evalSqTerm_frame {G : DoubleSig} {M : StrictDoubleCat} (I : SigInterp G M) :
    ∀ {P : SqTerm G} {φ : Frame G.hSrc G.hTgt G.vSrc G.vTgt},
      HasFrame G P φ →
      M.top (evalSqTerm I P) = evalHPath I φ.top ∧
      M.bot (evalSqTerm I P) = evalHPath I φ.bot ∧
      M.left (evalSqTerm I P) = evalVPath I φ.left ∧
      M.right (evalSqTerm I P) = evalVPath I φ.right
  | .gen a, _, h => by
    cases h
    exact ⟨I.sqTop_eq a, I.sqBot_eq a, I.sqLeft_eq a, I.sqRight_eq a⟩
  | .idH u, _, h => by
    cases h
    have he := evalVPath_endpoints I u
    exact ⟨(M.sqIdH_top _).trans (congrArg M.hId he.1),
           (M.sqIdH_bot _).trans (congrArg M.hId he.2),
           M.sqIdH_left _, M.sqIdH_right _⟩
  | .idV f, _, h => by
    cases h
    have he := evalHPath_endpoints I f
    exact ⟨M.sqIdV_top _, M.sqIdV_bot _,
           (M.sqIdV_left _).trans (congrArg M.vId he.1),
           (M.sqIdV_right _).trans (congrArg M.vId he.2)⟩
  | .compH P Q, _, h => by
    cases h with
    | compH hP hQ =>
      have ihP := evalSqTerm_frame I hP
      have ihQ := evalSqTerm_frame I hQ
      have hmid : M.right (evalSqTerm I P) = M.left (evalSqTerm I Q) := ihP.2.2.2.trans ihQ.2.2.1.symm
      exact ⟨(M.sqCompH_top _ _ hmid).trans
               ((congrArg2 M.hComp ihP.1 ihQ.1).trans (evalHPath_comp I _ _).symm),
             (M.sqCompH_bot _ _ hmid).trans
               ((congrArg2 M.hComp ihP.2.1 ihQ.2.1).trans (evalHPath_comp I _ _).symm),
             (M.sqCompH_left _ _ hmid).trans ihP.2.2.1,
             (M.sqCompH_right _ _ hmid).trans ihQ.2.2.2⟩
  | .compV P Q, _, h => by
    cases h with
    | compV hP hQ =>
      have ihP := evalSqTerm_frame I hP
      have ihQ := evalSqTerm_frame I hQ
      have hmid : M.bot (evalSqTerm I P) = M.top (evalSqTerm I Q) := ihP.2.1.trans ihQ.1.symm
      exact ⟨(M.sqCompV_top _ _ hmid).trans ihP.1,
             (M.sqCompV_bot _ _ hmid).trans ihQ.2.1,
             (M.sqCompV_left _ _ hmid).trans
               ((congrArg2 M.vComp ihP.2.2.1 ihQ.2.2.1).trans (evalVPath_comp I _ _).symm),
             (M.sqCompV_right _ _ hmid).trans
               ((congrArg2 M.vComp ihP.2.2.2 ihQ.2.2.2).trans (evalVPath_comp I _ _).symm)⟩

/-- **Theorem 5 (`v9 formal/59` Thm 5 / `T5` — Model-Independent Soundness):**
Every derivable certificate `EqCert G P Q` satisfies `⟦P⟧ = ⟦Q⟧` in EVERY `StrictDoubleCat`. -/
theorem eqCert_sound {G : DoubleSig} {M : StrictDoubleCat} (I : SigInterp G M) :
    ∀ {P Q : SqTerm G}, EqCert G P Q → evalSqTerm I P = evalSqTerm I Q
  | _, _, .refl _ => rfl
  | _, _, .symm h => (eqCert_sound I h).symm
  | _, _, .trans h1 h2 => (eqCert_sound I h1).trans (eqCert_sound I h2)
  | _, _, .congH hP hQ _ _ => congrArg2 M.sqCompH (eqCert_sound I hP) (eqCert_sound I hQ)
  | _, _, .congV hP hQ _ _ => congrArg2 M.sqCompV (eqCert_sound I hP) (eqCert_sound I hQ)
  | _, _, .assocH hP hQ hR =>
    let eP := evalSqTerm_frame I hP
    let eQ := evalSqTerm_frame I hQ
    let eR := evalSqTerm_frame I hR
    M.sqAssocH _ _ _ (eP.2.2.2.trans eQ.2.2.1.symm) (eQ.2.2.2.trans eR.2.2.1.symm)
  | _, _, .idH_l (P := P) hP => by
    have eP := (evalSqTerm_frame I hP).2.2.1
    dsimp only at eP
    dsimp only [evalSqTerm]
    rw [← eP]
    exact M.sqIdH_l (evalSqTerm I P)
  | _, _, .idH_r (P := P) hP => by
    have eP := (evalSqTerm_frame I hP).2.2.2
    dsimp only at eP
    dsimp only [evalSqTerm]
    rw [← eP]
    exact M.sqIdH_r (evalSqTerm I P)
  | _, _, .assocV hP hQ hR =>
    let eP := evalSqTerm_frame I hP
    let eQ := evalSqTerm_frame I hQ
    let eR := evalSqTerm_frame I hR
    M.sqAssocV _ _ _ (eP.2.1.trans eQ.1.symm) (eQ.2.1.trans eR.1.symm)
  | _, _, .idV_l (P := P) hP => by
    have eP := (evalSqTerm_frame I hP).1
    dsimp only at eP
    dsimp only [evalSqTerm]
    rw [← eP]
    exact M.sqIdV_l (evalSqTerm I P)
  | _, _, .idV_r (P := P) hP => by
    have eP := (evalSqTerm_frame I hP).2.1
    dsimp only at eP
    dsimp only [evalSqTerm]
    rw [← eP]
    exact M.sqIdV_r (evalSqTerm I P)
  | _, _, .interchange hP hQ hR hS =>
    let eP := evalSqTerm_frame I hP
    let eQ := evalSqTerm_frame I hQ
    let eR := evalSqTerm_frame I hR
    let eS := evalSqTerm_frame I hS
    M.sqInterchange _ _ _ _
      (eP.2.2.2.trans eQ.2.2.1.symm)
      (eR.2.2.2.trans eS.2.2.1.symm)
      (eP.2.1.trans eR.1.symm)
      (eQ.2.1.trans eS.1.symm)
  | _, _, .idH_compV u v => by
    dsimp only [evalSqTerm]
    rw [evalVPath_comp]
    exact M.sqIdH_compV _ _ ((evalVPath_endpoints I u).2.trans (evalVPath_endpoints I v).1.symm)
  | _, _, .idV_compH f g => by
    dsimp only [evalSqTerm]
    rw [evalHPath_comp]
    exact M.sqIdV_compH _ _ ((evalHPath_endpoints I f).2.trans (evalHPath_endpoints I g).1.symm)
  | _, _, .idH_idV x => M.sqIdH_idV (I.onObj x)

/-- Structure-preserving evaluator from `SqTerm G` into a strict double category `M`. -/
structure FunctorialSqEval {G : DoubleSig} {M : StrictDoubleCat} (I : SigInterp G M) where
  eval : SqTerm G → M.Sq
  eval_gen : ∀ a, eval (.gen a) = I.onSqGen a
  eval_idH : ∀ {a c : G.Obj} (u : TypedPath G.vSrc G.vTgt a c),
    eval (.idH u) = M.sqIdH (evalVPath I u)
  eval_idV : ∀ {a b : G.Obj} (f : TypedPath G.hSrc G.hTgt a b),
    eval (.idV f) = M.sqIdV (evalHPath I f)
  eval_compH : ∀ P Q, eval (.compH P Q) = M.sqCompH (eval P) (eval Q)
  eval_compV : ∀ P Q, eval (.compV P Q) = M.sqCompV (eval P) (eval Q)

/-- **Theorem 4 (`v9 formal/59` Thm 4 / `T4` — Free / Initial Property Uniqueness):**
Every structure-preserving extension of `I : SigInterp G M` coincides with `evalSqTerm I` on all
well-framed square terms. -/
theorem free_double_eval_unique {G : DoubleSig} {M : StrictDoubleCat} {I : SigInterp G M}
    (E : FunctorialSqEval I) :
    ∀ {P : SqTerm G} {φ : Frame G.hSrc G.hTgt G.vSrc G.vTgt},
      HasFrame G P φ → E.eval P = evalSqTerm I P
  | .gen a, _, _ => E.eval_gen a
  | .idH u, _, _ => E.eval_idH u
  | .idV f, _, _ => E.eval_idV f
  | .compH P Q, _, h => by
    cases h with
    | compH hP hQ =>
      exact (E.eval_compH P Q).trans
        (congrArg2 M.sqCompH (free_double_eval_unique E hP) (free_double_eval_unique E hQ))
  | .compV P Q, _, h => by
    cases h with
    | compV hP hQ =>
      exact (E.eval_compV P Q).trans
        (congrArg2 M.sqCompV (free_double_eval_unique E hP) (free_double_eval_unique E hQ))

/-- Single-object commutative-`Nat` strict double category (`CountModel` for `Cor 4.0`). -/
def natTallyDoubleCat : StrictDoubleCat where
  Obj := Unit
  H := Unit
  V := Unit
  Sq := Nat
  hSrc _ := ()
  hTgt _ := ()
  vSrc _ := ()
  vTgt _ := ()
  hId _ := ()
  vId _ := ()
  hComp _ _ := ()
  vComp _ _ := ()
  top _ := ()
  bot _ := ()
  left _ := ()
  right _ := ()
  sqIdH _ := 0
  sqIdV _ := 0
  sqCompH a b := a + b
  sqCompV a b := a + b
  hId_src _ := rfl
  hId_tgt _ := rfl
  vId_src _ := rfl
  vId_tgt _ := rfl
  hComp_src _ _ _ := rfl
  hComp_tgt _ _ _ := rfl
  vComp_src _ _ _ := rfl
  vComp_tgt _ _ _ := rfl
  hAssoc _ _ _ _ _ := rfl
  hId_l _ := rfl
  hId_r _ := rfl
  vAssoc _ _ _ _ _ := rfl
  vId_l _ := rfl
  vId_r _ := rfl
  sq_tl _ := rfl
  sq_tr _ := rfl
  sq_bl _ := rfl
  sq_br _ := rfl
  sqIdH_top _ := rfl
  sqIdH_bot _ := rfl
  sqIdH_left _ := rfl
  sqIdH_right _ := rfl
  sqIdV_top _ := rfl
  sqIdV_bot _ := rfl
  sqIdV_left _ := rfl
  sqIdV_right _ := rfl
  sqCompH_top _ _ _ := rfl
  sqCompH_bot _ _ _ := rfl
  sqCompH_left _ _ _ := rfl
  sqCompH_right _ _ _ := rfl
  sqCompV_top _ _ _ := rfl
  sqCompV_bot _ _ _ := rfl
  sqCompV_left _ _ _ := rfl
  sqCompV_right _ _ _ := rfl
  sqAssocH a b c _ _ := Nat.add_assoc a b c
  sqIdH_l a := Nat.zero_add a
  sqIdH_r a := Nat.add_zero a
  sqAssocV a b c _ _ := Nat.add_assoc a b c
  sqIdV_l a := Nat.zero_add a
  sqIdV_r a := Nat.add_zero a
  sqInterchange a b c d _ _ _ _ :=
    (Nat.add_assoc (a + b) c d).symm.trans
      ((congrArg (· + d) ((Nat.add_assoc a b c).trans
        ((congrArg (a + ·) (Nat.add_comm b c)).trans (Nat.add_assoc a c b).symm))).trans
        (Nat.add_assoc (a + c) b d))
  sqIdH_compV _ _ _ := rfl
  sqIdV_compH _ _ _ := rfl
  sqIdH_idV _ := rfl

/-- Generator-weighting interpretation `weight : G.SqGen → Nat` into `natTallyDoubleCat`. -/
def weightInterp (G : DoubleSig) (w : G.SqGen → Nat) : SigInterp G natTallyDoubleCat where
  onObj _ := ()
  onHGen _ := ()
  onVGen _ := ()
  onSqGen := w
  hSrc_eq _ := rfl
  hTgt_eq _ := rfl
  vSrc_eq _ := rfl
  vTgt_eq _ := rfl
  sqTop_eq _ := rfl
  sqBot_eq _ := rfl
  sqLeft_eq _ := rfl
  sqRight_eq _ := rfl

/-- Syntactic recursive weight tally on `SqTerm G`. -/
def termWeight (G : DoubleSig) (w : G.SqGen → Nat) : SqTerm G → Nat
  | .gen a => w a
  | .idH _ => 0
  | .idV _ => 0
  | .compH P Q => termWeight G w P + termWeight G w Q
  | .compV P Q => termWeight G w P + termWeight G w Q

theorem evalSqTerm_weight_eq {G : DoubleSig} (w : G.SqGen → Nat) :
    ∀ P : SqTerm G, evalSqTerm (weightInterp G w) P = termWeight G w P
  | .gen _ => rfl
  | .idH _ => rfl
  | .idV _ => rfl
  | .compH P Q => congrArg2 (· + ·) (evalSqTerm_weight_eq w P) (evalSqTerm_weight_eq w Q)
  | .compV P Q => congrArg2 (· + ·) (evalSqTerm_weight_eq w P) (evalSqTerm_weight_eq w Q)

theorem eqCert_preserves_weight {G : DoubleSig} (w : G.SqGen → Nat) {P Q : SqTerm G}
    (h : EqCert G P Q) : termWeight G w P = termWeight G w Q :=
  (evalSqTerm_weight_eq w P).symm.trans ((eqCert_sound (weightInterp G w) h).trans (evalSqTerm_weight_eq w Q))

/-- **Corollary 4.0 (`v9 formal/59 §4`):**
If a computable generator weight `w : G.SqGen → Nat` separates two terms `P, Q`, then NO
equality certificate `EqCert G P Q` exists; in particular, two separated generators with the
EXACT SAME 4-boundary frame are never conflated by the 10 structural axioms. -/
theorem distinct_same_frame_gens_not_cert_eq {G : DoubleSig} (w : G.SqGen → Nat)
    {P Q : SqTerm G} (hdiff : termWeight G w P ≠ termWeight G w Q) :
    ¬ EqCert G P Q :=
  fun h => hdiff (eqCert_preserves_weight w h)

/-! ## Part 3: Conservative Relative 3D Extension (`Lem 6`, `T7`–`T9`) -/

/-- Relative 3D extension `(D_Σ, G₃)` adding directed 3-cells between parallel 2D terms. -/
structure Double3Sig extends DoubleSig where
  Cell3Gen : Type
  c3Src : Cell3Gen → SqTerm toDoubleSig
  c3Tgt : Cell3Gen → SqTerm toDoubleSig
  c3Frame : Cell3Gen → Frame hSrc hTgt vSrc vTgt
  c3SrcFrame : ∀ ρ, HasFrame toDoubleSig (c3Src ρ) (c3Frame ρ)
  c3TgtFrame : ∀ ρ, HasFrame toDoubleSig (c3Tgt ρ) (c3Frame ρ)

/-- Primitive 3-cell terms (`v9 formal/59 §7.1`): `gen3`, `id3`, `compR`, `compH3`, `compV3`, plus
`transport` along base 2D certificates `EqCert` (`D₂ = T₂ / ≡₂`). -/
inductive Cell3Term (G : Double3Sig) : Type where
  | gen3 (ρ : G.Cell3Gen) : Cell3Term G
  | id3 (P : SqTerm G.toDoubleSig) : Cell3Term G
  | compR (Γ Δ : Cell3Term G) : Cell3Term G
  | compH3 (Γ Δ : Cell3Term G) : Cell3Term G
  | compV3 (Γ Δ : Cell3Term G) : Cell3Term G
  | transport (Γ : Cell3Term G) (P' Q' : SqTerm G.toDoubleSig) : Cell3Term G

/-- Inductive 2D endpoint judgement `Γ : P ⟹ Q` (`D₂`-compatible `compR` modulo `EqCert`, matching 4-boundaries). -/
inductive HasEndpoints3 (G : Double3Sig) :
    Cell3Term G → SqTerm G.toDoubleSig → SqTerm G.toDoubleSig → Prop where
  | gen3 (ρ : G.Cell3Gen) : HasEndpoints3 G (.gen3 ρ) (G.c3Src ρ) (G.c3Tgt ρ)
  | id3 {P : SqTerm G.toDoubleSig} {φ : Frame G.hSrc G.hTgt G.vSrc G.vTgt}
      (hP : HasFrame G.toDoubleSig P φ) :
      HasEndpoints3 G (.id3 P) P P
  | compR {Γ Δ : Cell3Term G} {P Q Q' R : SqTerm G.toDoubleSig}
      (hΓ : HasEndpoints3 G Γ P Q)
      (hmid : EqCert G.toDoubleSig Q Q')
      (hΔ : HasEndpoints3 G Δ Q' R) :
      HasEndpoints3 G (.compR Γ Δ) P R
  | compH3 {Γ Δ : Cell3Term G} {P₁ P₂ Q₁ Q₂ : SqTerm G.toDoubleSig}
      {a b c d e f : G.Obj}
      {tP : TypedPath G.hSrc G.hTgt a b} {bP : TypedPath G.hSrc G.hTgt c d}
      {tQ : TypedPath G.hSrc G.hTgt b e} {bQ : TypedPath G.hSrc G.hTgt d f}
      {l : TypedPath G.vSrc G.vTgt a c} {m : TypedPath G.vSrc G.vTgt b d}
      {r : TypedPath G.vSrc G.vTgt e f}
      (hΓ : HasEndpoints3 G Γ P₁ Q₁) (hΔ : HasEndpoints3 G Δ P₂ Q₂)
      (hFP : HasFrame G.toDoubleSig P₁ ⟨a, b, c, d, tP, bP, l, m⟩)
      (hFQ : HasFrame G.toDoubleSig P₂ ⟨b, e, d, f, tQ, bQ, m, r⟩) :
      HasEndpoints3 G (.compH3 Γ Δ) (.compH P₁ P₂) (.compH Q₁ Q₂)
  | compV3 {Γ Δ : Cell3Term G} {P₁ P₂ Q₁ Q₂ : SqTerm G.toDoubleSig}
      {a b c d e f : G.Obj}
      {t : TypedPath G.hSrc G.hTgt a b} {m : TypedPath G.hSrc G.hTgt c d}
      {botQ : TypedPath G.hSrc G.hTgt e f}
      {lP : TypedPath G.vSrc G.vTgt a c} {rP : TypedPath G.vSrc G.vTgt b d}
      {lQ : TypedPath G.vSrc G.vTgt c e} {rQ : TypedPath G.vSrc G.vTgt d f}
      (hΓ : HasEndpoints3 G Γ P₁ Q₁) (hΔ : HasEndpoints3 G Δ P₂ Q₂)
      (hFP : HasFrame G.toDoubleSig P₁ ⟨a, b, c, d, t, m, lP, rP⟩)
      (hFQ : HasFrame G.toDoubleSig P₂ ⟨c, d, e, f, m, botQ, lQ, rQ⟩) :
      HasEndpoints3 G (.compV3 Γ Δ) (.compV P₁ P₂) (.compV Q₁ Q₂)
  | transport {Γ : Cell3Term G} {P Q P' Q' : SqTerm G.toDoubleSig}
      (hΓ : HasEndpoints3 G Γ P Q)
      (hP : EqCert G.toDoubleSig P P') (hQ : EqCert G.toDoubleSig Q Q') :
      HasEndpoints3 G (.transport Γ P' Q') P' Q'

/-- Any valid 3D cell connects two well-framed 2D squares sharing the EXACT SAME 4-boundary frame. -/
theorem hasEndpoints3_common_frame {G : Double3Sig} :
    ∀ {Γ : Cell3Term G} {P Q : SqTerm G.toDoubleSig},
      HasEndpoints3 G Γ P Q →
      ∃ φ : Frame G.hSrc G.hTgt G.vSrc G.vTgt,
        HasFrame G.toDoubleSig P φ ∧ HasFrame G.toDoubleSig Q φ
  | _, _, _, .gen3 ρ => ⟨G.c3Frame ρ, G.c3SrcFrame ρ, G.c3TgtFrame ρ⟩
  | _, _, _, .id3 hP => ⟨_, hP, hP⟩
  | _, _, _, .compR hΓ hmid hΔ =>
    let ⟨φ, hP, hQ1⟩ := hasEndpoints3_common_frame hΓ
    let ⟨_, hQ2, hR⟩ := hasEndpoints3_common_frame hΔ
    let heq := eqCert_frame_eq hmid hQ1 hQ2
    ⟨φ, hP, heq ▸ hR⟩
  | _, _, _, .compH3 hΓ hΔ hFP hFQ =>
    let ⟨_, hP1, hQ1⟩ := hasEndpoints3_common_frame hΓ
    let ⟨_, hP2, hQ2⟩ := hasEndpoints3_common_frame hΔ
    let hQ1' := hasFrame_unique hP1 hFP ▸ hQ1
    let hQ2' := hasFrame_unique hP2 hFQ ▸ hQ2
    ⟨_, .compH hFP hFQ, .compH hQ1' hQ2'⟩
  | _, _, _, .compV3 hΓ hΔ hFP hFQ =>
    let ⟨_, hP1, hQ1⟩ := hasEndpoints3_common_frame hΓ
    let ⟨_, hP2, hQ2⟩ := hasEndpoints3_common_frame hΔ
    let hQ1' := hasFrame_unique hP1 hFP ▸ hQ1
    let hQ2' := hasFrame_unique hP2 hFQ ▸ hQ2
    ⟨_, .compV hFP hFQ, .compV hQ1' hQ2'⟩
  | _, _, _, .transport hΓ hP hQ =>
    let ⟨φ, hP0, hQ0⟩ := hasEndpoints3_common_frame hΓ
    let ⟨_, hp1, hp2⟩ := eqCert_preserves_frame hP
    let ⟨_, hq1, hq2⟩ := eqCert_preserves_frame hQ
    ⟨φ, hasFrame_unique hP0 hp1 ▸ hp2, hasFrame_unique hQ0 hq1 ▸ hq2⟩

/-- Unique 2D endpoints `(P, Q)` modulo `EqCert G.toDoubleSig` for every well-typed `Cell3Term`. -/
theorem hasEndpoints3_unique_mod_2d {G : Double3Sig} :
    ∀ {Γ : Cell3Term G} {P₁ Q₁ P₂ Q₂ : SqTerm G.toDoubleSig},
      HasEndpoints3 G Γ P₁ Q₁ → HasEndpoints3 G Γ P₂ Q₂ →
      EqCert G.toDoubleSig P₁ P₂ ∧ EqCert G.toDoubleSig Q₁ Q₂
  | .gen3 _, _, _, _, _, h1, h2 => by
    cases h1 with
    | gen3 => cases h2 with
      | gen3 => exact ⟨.refl (G.c3SrcFrame _), .refl (G.c3TgtFrame _)⟩
  | .id3 _, _, _, _, _, h1, h2 => by
    cases h1 with
    | id3 hP => cases h2 with
      | id3 => exact ⟨.refl hP, .refl hP⟩
  | .compR _ _, _, _, _, _, h1, h2 => by
    cases h1 with
    | compR hΓ1 _ hΔ1 => cases h2 with
      | compR hΓ2 _ hΔ2 =>
        exact ⟨(hasEndpoints3_unique_mod_2d hΓ1 hΓ2).1,
               (hasEndpoints3_unique_mod_2d hΔ1 hΔ2).2⟩
  | .compH3 _ _, _, _, _, _, h1, h2 => by
    cases h1 with
    | compH3 hΓ1 hΔ1 hFP1 hFQ1 => cases h2 with
      | compH3 hΓ2 hΔ2 _ _ =>
        obtain ⟨ihGP, ihGQ⟩ := hasEndpoints3_unique_mod_2d hΓ1 hΓ2
        obtain ⟨ihDP, ihDQ⟩ := hasEndpoints3_unique_mod_2d hΔ1 hΔ2
        obtain ⟨_, hP10, hQ1⟩ := hasEndpoints3_common_frame hΓ1
        obtain ⟨_, hP20, hQ2⟩ := hasEndpoints3_common_frame hΔ1
        exact ⟨.congH ihGP ihDP hFP1 hFQ1,
               .congH ihGQ ihDQ (hasFrame_unique hP10 hFP1 ▸ hQ1) (hasFrame_unique hP20 hFQ1 ▸ hQ2)⟩
  | .compV3 _ _, _, _, _, _, h1, h2 => by
    cases h1 with
    | compV3 hΓ1 hΔ1 hFP1 hFQ1 => cases h2 with
      | compV3 hΓ2 hΔ2 _ _ =>
        obtain ⟨ihGP, ihGQ⟩ := hasEndpoints3_unique_mod_2d hΓ1 hΓ2
        obtain ⟨ihDP, ihDQ⟩ := hasEndpoints3_unique_mod_2d hΔ1 hΔ2
        obtain ⟨_, hP10, hQ1⟩ := hasEndpoints3_common_frame hΓ1
        obtain ⟨_, hP20, hQ2⟩ := hasEndpoints3_common_frame hΔ1
        exact ⟨.congV ihGP ihDP hFP1 hFQ1,
               .congV ihGQ ihDQ (hasFrame_unique hP10 hFP1 ▸ hQ1) (hasFrame_unique hP20 hFQ1 ▸ hQ2)⟩
  | .transport _ _ _, _, _, _, _, h1, h2 => by
    cases h1 with
    | transport _ hP1 hQ1 => cases h2 with
      | transport _ _ _ =>
        obtain ⟨_, _, hp2⟩ := eqCert_preserves_frame hP1
        obtain ⟨_, _, hq2⟩ := eqCert_preserves_frame hQ1
        exact ⟨.refl hp2, .refl hq2⟩

/-- Equality certificates `≡₃` over 3-cell terms (`v9 formal/59 §7.2` (A), (B), (C), congruence, and
`transport` coherence). Notice every equation preserves 2D source & target modulo `EqCert`. -/
inductive Eq3Cert (G : Double3Sig) : Cell3Term G → Cell3Term G → Prop where
  | refl {Γ : Cell3Term G} {P Q : SqTerm G.toDoubleSig} (h : HasEndpoints3 G Γ P Q) :
      Eq3Cert G Γ Γ
  | symm {Γ Δ : Cell3Term G} (h : Eq3Cert G Γ Δ) : Eq3Cert G Δ Γ
  | trans {Γ Δ Ξ : Cell3Term G} (h1 : Eq3Cert G Γ Δ) (h2 : Eq3Cert G Δ Ξ) : Eq3Cert G Γ Ξ
  | transport_base {Γ : Cell3Term G} {P Q P' Q' : SqTerm G.toDoubleSig}
      (hΓ : HasEndpoints3 G Γ P Q)
      (hP : EqCert G.toDoubleSig P P') (hQ : EqCert G.toDoubleSig Q Q') :
      Eq3Cert G Γ (.transport Γ P' Q')
  | assocR {Γ Δ Ξ : Cell3Term G} {P Q₁ Q₂ R₁ R₂ S : SqTerm G.toDoubleSig}
      (hΓ : HasEndpoints3 G Γ P Q₁) (hm1 : EqCert G.toDoubleSig Q₁ Q₂)
      (hΔ : HasEndpoints3 G Δ Q₂ R₁) (hm2 : EqCert G.toDoubleSig R₁ R₂)
      (hΞ : HasEndpoints3 G Ξ R₂ S) :
      Eq3Cert G (.compR (.compR Γ Δ) Ξ) (.compR Γ (.compR Δ Ξ))
  | idR_l {Γ : Cell3Term G} {P Q : SqTerm G.toDoubleSig} (hΓ : HasEndpoints3 G Γ P Q) :
      Eq3Cert G (.compR (.id3 P) Γ) Γ
  | idR_r {Γ : Cell3Term G} {P Q : SqTerm G.toDoubleSig} (hΓ : HasEndpoints3 G Γ P Q) :
      Eq3Cert G (.compR Γ (.id3 Q)) Γ
  | assocH3 {Γ Δ Ξ : Cell3Term G} {P₁ P₂ P₃ Q₁ Q₂ Q₃ : SqTerm G.toDoubleSig}
      (h123 : HasEndpoints3 G (.compH3 (.compH3 Γ Δ) Ξ) (.compH (.compH P₁ P₂) P₃) (.compH (.compH Q₁ Q₂) Q₃))
      (h23 : HasEndpoints3 G (.compH3 Γ (.compH3 Δ Ξ)) (.compH P₁ (.compH P₂ P₃)) (.compH Q₁ (.compH Q₂ Q₃))) :
      Eq3Cert G (.compH3 (.compH3 Γ Δ) Ξ) (.compH3 Γ (.compH3 Δ Ξ))
  | idH3_l {Γ : Cell3Term G} {P Q : SqTerm G.toDoubleSig} {a b c d : G.Obj}
      {t : TypedPath G.hSrc G.hTgt a b} {bot : TypedPath G.hSrc G.hTgt c d}
      {l : TypedPath G.vSrc G.vTgt a c} {r : TypedPath G.vSrc G.vTgt b d}
      (hΓ : HasEndpoints3 G Γ P Q) (hFP : HasFrame G.toDoubleSig P ⟨a, b, c, d, t, bot, l, r⟩) :
      Eq3Cert G (.compH3 (.id3 (.idH l)) Γ) Γ
  | idH3_r {Γ : Cell3Term G} {P Q : SqTerm G.toDoubleSig} {a b c d : G.Obj}
      {t : TypedPath G.hSrc G.hTgt a b} {bot : TypedPath G.hSrc G.hTgt c d}
      {l : TypedPath G.vSrc G.vTgt a c} {r : TypedPath G.vSrc G.vTgt b d}
      (hΓ : HasEndpoints3 G Γ P Q) (hFP : HasFrame G.toDoubleSig P ⟨a, b, c, d, t, bot, l, r⟩) :
      Eq3Cert G (.compH3 Γ (.id3 (.idH r))) Γ
  | assocV3 {Γ Δ Ξ : Cell3Term G} {P₁ P₂ P₃ Q₁ Q₂ Q₃ : SqTerm G.toDoubleSig}
      (h123 : HasEndpoints3 G (.compV3 (.compV3 Γ Δ) Ξ) (.compV (.compV P₁ P₂) P₃) (.compV (.compV Q₁ Q₂) Q₃))
      (h23 : HasEndpoints3 G (.compV3 Γ (.compV3 Δ Ξ)) (.compV P₁ (.compV P₂ P₃)) (.compV Q₁ (.compV Q₂ Q₃))) :
      Eq3Cert G (.compV3 (.compV3 Γ Δ) Ξ) (.compV3 Γ (.compV3 Δ Ξ))
  | idV3_l {Γ : Cell3Term G} {P Q : SqTerm G.toDoubleSig} {a b c d : G.Obj}
      {t : TypedPath G.hSrc G.hTgt a b} {bot : TypedPath G.hSrc G.hTgt c d}
      {l : TypedPath G.vSrc G.vTgt a c} {r : TypedPath G.vSrc G.vTgt b d}
      (hΓ : HasEndpoints3 G Γ P Q) (hFP : HasFrame G.toDoubleSig P ⟨a, b, c, d, t, bot, l, r⟩) :
      Eq3Cert G (.compV3 (.id3 (.idV t)) Γ) Γ
  | idV3_r {Γ : Cell3Term G} {P Q : SqTerm G.toDoubleSig} {a b c d : G.Obj}
      {t : TypedPath G.hSrc G.hTgt a b} {bot : TypedPath G.hSrc G.hTgt c d}
      {l : TypedPath G.vSrc G.vTgt a c} {r : TypedPath G.vSrc G.vTgt b d}
      (hΓ : HasEndpoints3 G Γ P Q) (hFP : HasFrame G.toDoubleSig P ⟨a, b, c, d, t, bot, l, r⟩) :
      Eq3Cert G (.compV3 Γ (.id3 (.idV bot))) Γ
  | interchange_hv {Γ Δ Ξ Ω : Cell3Term G}
      {P₁ Q₁ P₂ Q₂ P₃ Q₃ P₄ Q₄ : SqTerm G.toDoubleSig}
      (hL : HasEndpoints3 G (.compV3 (.compH3 Γ Δ) (.compH3 Ξ Ω))
        (.compV (.compH P₁ P₂) (.compH P₃ P₄)) (.compV (.compH Q₁ Q₂) (.compH Q₃ Q₄)))
      (hR : HasEndpoints3 G (.compH3 (.compV3 Γ Ξ) (.compV3 Δ Ω))
        (.compH (.compV P₁ P₃) (.compV P₂ P₄)) (.compH (.compV Q₁ Q₃) (.compV Q₂ Q₄)))
      (eP : EqCert G.toDoubleSig
        (.compV (.compH P₁ P₂) (.compH P₃ P₄)) (.compH (.compV P₁ P₃) (.compV P₂ P₄)))
      (eQ : EqCert G.toDoubleSig
        (.compV (.compH Q₁ Q₂) (.compH Q₃ Q₄)) (.compH (.compV Q₁ Q₃) (.compV Q₂ Q₄))) :
      Eq3Cert G (.compV3 (.compH3 Γ Δ) (.compH3 Ξ Ω)) (.compH3 (.compV3 Γ Ξ) (.compV3 Δ Ω))
  | interchange_hr {Γ Δ Ξ Ω : Cell3Term G} {P₁ P₂ R₁ R₂ : SqTerm G.toDoubleSig}
      (hL : HasEndpoints3 G (.compH3 (.compR Γ Δ) (.compR Ξ Ω)) (.compH P₁ P₂) (.compH R₁ R₂))
      (hR : HasEndpoints3 G (.compR (.compH3 Γ Ξ) (.compH3 Δ Ω)) (.compH P₁ P₂) (.compH R₁ R₂)) :
      Eq3Cert G (.compH3 (.compR Γ Δ) (.compR Ξ Ω)) (.compR (.compH3 Γ Ξ) (.compH3 Δ Ω))
  | interchange_vr {Γ Δ Ξ Ω : Cell3Term G} {P₁ P₂ R₁ R₂ : SqTerm G.toDoubleSig}
      (hL : HasEndpoints3 G (.compV3 (.compR Γ Δ) (.compR Ξ Ω)) (.compV P₁ P₂) (.compV R₁ R₂))
      (hR : HasEndpoints3 G (.compR (.compV3 Γ Ξ) (.compV3 Δ Ω)) (.compV P₁ P₂) (.compV R₁ R₂)) :
      Eq3Cert G (.compV3 (.compR Γ Δ) (.compR Ξ Ω)) (.compR (.compV3 Γ Ξ) (.compV3 Δ Ω))
  | id3_compH {P Q : SqTerm G.toDoubleSig} {a b c d e f : G.Obj}
      {tP : TypedPath G.hSrc G.hTgt a b} {bP : TypedPath G.hSrc G.hTgt c d}
      {tQ : TypedPath G.hSrc G.hTgt b e} {bQ : TypedPath G.hSrc G.hTgt d f}
      {l : TypedPath G.vSrc G.vTgt a c} {m : TypedPath G.vSrc G.vTgt b d}
      {r : TypedPath G.vSrc G.vTgt e f}
      (hP : HasFrame G.toDoubleSig P ⟨a, b, c, d, tP, bP, l, m⟩)
      (hQ : HasFrame G.toDoubleSig Q ⟨b, e, d, f, tQ, bQ, m, r⟩) :
      Eq3Cert G (.id3 (.compH P Q)) (.compH3 (.id3 P) (.id3 Q))
  | id3_compV {P Q : SqTerm G.toDoubleSig} {a b c d e f : G.Obj}
      {t : TypedPath G.hSrc G.hTgt a b} {m : TypedPath G.hSrc G.hTgt c d}
      {botQ : TypedPath G.hSrc G.hTgt e f}
      {lP : TypedPath G.vSrc G.vTgt a c} {rP : TypedPath G.vSrc G.vTgt b d}
      {lQ : TypedPath G.vSrc G.vTgt c e} {rQ : TypedPath G.vSrc G.vTgt d f}
      (hP : HasFrame G.toDoubleSig P ⟨a, b, c, d, t, m, lP, rP⟩)
      (hQ : HasFrame G.toDoubleSig Q ⟨c, d, e, f, m, botQ, lQ, rQ⟩) :
      Eq3Cert G (.id3 (.compV P Q)) (.compV3 (.id3 P) (.id3 Q))
  | congR {Γ₁ Γ₂ Δ₁ Δ₂ : Cell3Term G} {P Q Q' R : SqTerm G.toDoubleSig}
      (hΓ : Eq3Cert G Γ₁ Γ₂) (hΔ : Eq3Cert G Δ₁ Δ₂)
      (h1 : HasEndpoints3 G Γ₁ P Q) (hmid : EqCert G.toDoubleSig Q Q') (h2 : HasEndpoints3 G Δ₁ Q' R) :
      Eq3Cert G (.compR Γ₁ Δ₁) (.compR Γ₂ Δ₂)
  | congH3 {Γ₁ Γ₂ Δ₁ Δ₂ : Cell3Term G} {P₁ P₂ Q₁ Q₂ : SqTerm G.toDoubleSig}
      {a b c d e f : G.Obj}
      {tP : TypedPath G.hSrc G.hTgt a b} {bP : TypedPath G.hSrc G.hTgt c d}
      {tQ : TypedPath G.hSrc G.hTgt b e} {bQ : TypedPath G.hSrc G.hTgt d f}
      {l : TypedPath G.vSrc G.vTgt a c} {m : TypedPath G.vSrc G.vTgt b d}
      {r : TypedPath G.vSrc G.vTgt e f}
      (hΓ : Eq3Cert G Γ₁ Γ₂) (hΔ : Eq3Cert G Δ₁ Δ₂)
      (h1 : HasEndpoints3 G Γ₁ P₁ Q₁) (h2 : HasEndpoints3 G Δ₁ P₂ Q₂)
      (hFP : HasFrame G.toDoubleSig P₁ ⟨a, b, c, d, tP, bP, l, m⟩)
      (hFQ : HasFrame G.toDoubleSig P₂ ⟨b, e, d, f, tQ, bQ, m, r⟩) :
      Eq3Cert G (.compH3 Γ₁ Δ₁) (.compH3 Γ₂ Δ₂)
  | congV3 {Γ₁ Γ₂ Δ₁ Δ₂ : Cell3Term G} {P₁ P₂ Q₁ Q₂ : SqTerm G.toDoubleSig}
      {a b c d e f : G.Obj}
      {t : TypedPath G.hSrc G.hTgt a b} {m : TypedPath G.hSrc G.hTgt c d}
      {botQ : TypedPath G.hSrc G.hTgt e f}
      {lP : TypedPath G.vSrc G.vTgt a c} {rP : TypedPath G.vSrc G.vTgt b d}
      {lQ : TypedPath G.vSrc G.vTgt c e} {rQ : TypedPath G.vSrc G.vTgt d f}
      (hΓ : Eq3Cert G Γ₁ Γ₂) (hΔ : Eq3Cert G Δ₁ Δ₂)
      (h1 : HasEndpoints3 G Γ₁ P₁ Q₁) (h2 : HasEndpoints3 G Δ₁ P₂ Q₂)
      (hFP : HasFrame G.toDoubleSig P₁ ⟨a, b, c, d, t, m, lP, rP⟩)
      (hFQ : HasFrame G.toDoubleSig P₂ ⟨c, d, e, f, m, botQ, lQ, rQ⟩) :
      Eq3Cert G (.compV3 Γ₁ Δ₁) (.compV3 Γ₂ Δ₂)

theorem eqCert_assocH_of_frame {G : DoubleSig} {P₁ P₂ P₃ : SqTerm G}
    {φ : Frame G.hSrc G.hTgt G.vSrc G.vTgt}
    (h : HasFrame G (.compH (.compH P₁ P₂) P₃) φ) :
    EqCert G (.compH (.compH P₁ P₂) P₃) (.compH P₁ (.compH P₂ P₃)) := by
  cases h with
  | compH h12 h3 =>
    cases h12 with
    | compH h1 h2 => exact .assocH h1 h2 h3

theorem eqCert_assocV_of_frame {G : DoubleSig} {P₁ P₂ P₃ : SqTerm G}
    {φ : Frame G.hSrc G.hTgt G.vSrc G.vTgt}
    (h : HasFrame G (.compV (.compV P₁ P₂) P₃) φ) :
    EqCert G (.compV (.compV P₁ P₂) P₃) (.compV P₁ (.compV P₂ P₃)) := by
  cases h with
  | compV h12 h3 =>
    cases h12 with
    | compV h1 h2 => exact .assocV h1 h2 h3

/-- **Lemma 6 (`v9 formal/59` Lem 6):**
Every derivable `Eq3Cert G Γ Δ` connects 3-cells with equal 2D sources and targets modulo `EqCert`. -/
theorem cell3_eq_preserves_endpoints {G : Double3Sig} :
    ∀ {Γ Δ : Cell3Term G}, Eq3Cert G Γ Δ →
      ∃ P₁ Q₁ P₂ Q₂ : SqTerm G.toDoubleSig,
        HasEndpoints3 G Γ P₁ Q₁ ∧ HasEndpoints3 G Δ P₂ Q₂ ∧
        EqCert G.toDoubleSig P₁ P₂ ∧ EqCert G.toDoubleSig Q₁ Q₂
  | _, _, .refl h =>
    let ⟨_, hP, hQ⟩ := hasEndpoints3_common_frame h
    ⟨_, _, _, _, h, h, .refl hP, .refl hQ⟩
  | _, _, .symm h =>
    let ⟨P₁, Q₁, P₂, Q₂, h1, h2, eP, eQ⟩ := cell3_eq_preserves_endpoints h
    ⟨P₂, Q₂, P₁, Q₁, h2, h1, .symm eP, .symm eQ⟩
  | _, _, .trans h1 h2 =>
    let ⟨P₁, Q₁, P₂, Q₂, g1, g2a, eP1, eQ1⟩ := cell3_eq_preserves_endpoints h1
    let ⟨_, _, P₃, Q₃, g2b, g3, eP2, eQ2⟩ := cell3_eq_preserves_endpoints h2
    let ⟨mP, mQ⟩ := hasEndpoints3_unique_mod_2d g2a g2b
    ⟨P₁, Q₁, P₃, Q₃, g1, g3, .trans eP1 (.trans mP eP2), .trans eQ1 (.trans mQ eQ2)⟩
  | _, _, .transport_base hΓ hP hQ =>
    ⟨_, _, _, _, hΓ, .transport hΓ hP hQ, hP, hQ⟩
  | _, _, .assocR hΓ hm1 hΔ hm2 hΞ =>
    let ⟨_, hP, _⟩ := hasEndpoints3_common_frame hΓ
    let ⟨_, _, hS⟩ := hasEndpoints3_common_frame hΞ
    ⟨_, _, _, _, .compR (.compR hΓ hm1 hΔ) hm2 hΞ, .compR hΓ hm1 (.compR hΔ hm2 hΞ), .refl hP, .refl hS⟩
  | _, _, .idR_l hΓ =>
    let ⟨_, hP, hQ⟩ := hasEndpoints3_common_frame hΓ
    ⟨_, _, _, _, .compR (.id3 hP) (.refl hP) hΓ, hΓ, .refl hP, .refl hQ⟩
  | _, _, .idR_r hΓ =>
    let ⟨_, hP, hQ⟩ := hasEndpoints3_common_frame hΓ
    ⟨_, _, _, _, .compR hΓ (.refl hQ) (.id3 hQ), hΓ, .refl hP, .refl hQ⟩
  | _, _, .assocH3 h123 h23 =>
    let ⟨_, hLP, hLQ⟩ := hasEndpoints3_common_frame h123
    ⟨_, _, _, _, h123, h23, eqCert_assocH_of_frame hLP, eqCert_assocH_of_frame hLQ⟩
  | _, _, .idH3_l (l := l) hΓ hFP =>
    let ⟨_, hP, hQ⟩ := hasEndpoints3_common_frame hΓ
    let hQ' := hasFrame_unique hP hFP ▸ hQ
    let hl : HasFrame G.toDoubleSig (.idH l) ⟨_, _, _, _, .nil _, .nil _, l, l⟩ := .idH l
    ⟨_, _, _, _, .compH3 (.id3 hl) hΓ hl hFP, hΓ, .idH_l hFP, .idH_l hQ'⟩
  | _, _, .idH3_r (r := r) hΓ hFP =>
    let ⟨_, hP, hQ⟩ := hasEndpoints3_common_frame hΓ
    let hQ' := hasFrame_unique hP hFP ▸ hQ
    let hr : HasFrame G.toDoubleSig (.idH r) ⟨_, _, _, _, .nil _, .nil _, r, r⟩ := .idH r
    ⟨_, _, _, _, .compH3 hΓ (.id3 hr) hFP hr, hΓ, .idH_r hFP, .idH_r hQ'⟩
  | _, _, .assocV3 h123 h23 =>
    let ⟨_, hLP, hLQ⟩ := hasEndpoints3_common_frame h123
    ⟨_, _, _, _, h123, h23, eqCert_assocV_of_frame hLP, eqCert_assocV_of_frame hLQ⟩
  | _, _, .idV3_l (t := t) hΓ hFP =>
    let ⟨_, hP, hQ⟩ := hasEndpoints3_common_frame hΓ
    let hQ' := hasFrame_unique hP hFP ▸ hQ
    let ht : HasFrame G.toDoubleSig (.idV t) ⟨_, _, _, _, t, t, .nil _, .nil _⟩ := .idV t
    ⟨_, _, _, _, .compV3 (.id3 ht) hΓ ht hFP, hΓ, .idV_l hFP, .idV_l hQ'⟩
  | _, _, .idV3_r (bot := bot) hΓ hFP =>
    let ⟨_, hP, hQ⟩ := hasEndpoints3_common_frame hΓ
    let hQ' := hasFrame_unique hP hFP ▸ hQ
    let hb : HasFrame G.toDoubleSig (.idV bot) ⟨_, _, _, _, bot, bot, .nil _, .nil _⟩ := .idV bot
    ⟨_, _, _, _, .compV3 hΓ (.id3 hb) hFP hb, hΓ, .idV_r hFP, .idV_r hQ'⟩
  | _, _, .interchange_hv hL hR eP eQ =>
    ⟨_, _, _, _, hL, hR, eP, eQ⟩
  | _, _, .interchange_hr hL hR =>
    let ⟨_, hLP, hLQ⟩ := hasEndpoints3_common_frame hL
    ⟨_, _, _, _, hL, hR, .refl hLP, .refl hLQ⟩
  | _, _, .interchange_vr hL hR =>
    let ⟨_, hLP, hLQ⟩ := hasEndpoints3_common_frame hL
    ⟨_, _, _, _, hL, hR, .refl hLP, .refl hLQ⟩
  | _, _, .id3_compH hP hQ =>
    let hF := HasFrame.compH hP hQ
    ⟨_, _, _, _, .id3 hF, .compH3 (.id3 hP) (.id3 hQ) hP hQ, .refl hF, .refl hF⟩
  | _, _, .id3_compV hP hQ =>
    let hF := HasFrame.compV hP hQ
    ⟨_, _, _, _, .id3 hF, .compV3 (.id3 hP) (.id3 hQ) hP hQ, .refl hF, .refl hF⟩
  | _, _, .congR hΓ hΔ h1 hmid h2 => by
    obtain ⟨_, _, _, _, hG1, hG2, eGP, eGQ⟩ := cell3_eq_preserves_endpoints hΓ
    obtain ⟨_, _, _, _, hD1, hD2, eDP, eDQ⟩ := cell3_eq_preserves_endpoints hΔ
    let ⟨mP, mQ1⟩ := hasEndpoints3_unique_mod_2d h1 hG1
    let ⟨mQ2, mR⟩ := hasEndpoints3_unique_mod_2d h2 hD1
    let hmid2 : EqCert G.toDoubleSig _ _ :=
      .trans (.symm (.trans mQ1 eGQ)) (.trans hmid (.trans mQ2 eDP))
    exact ⟨_, _, _, _, .compR h1 hmid h2, .compR hG2 hmid2 hD2,
      .trans mP eGP, .trans mR eDQ⟩
  | _, _, .congH3 hΓ hΔ h1 h2 hFP hFQ => by
    obtain ⟨_, _, _, _, hG1, hG2, eGP, eGQ⟩ := cell3_eq_preserves_endpoints hΓ
    obtain ⟨_, _, _, _, hD1, hD2, eDP, eDQ⟩ := cell3_eq_preserves_endpoints hΔ
    let ⟨mP1, mQ1⟩ := hasEndpoints3_unique_mod_2d h1 hG1
    let ⟨mP2, mQ2⟩ := hasEndpoints3_unique_mod_2d h2 hD1
    let eP1 := EqCert.trans mP1 eGP
    let eP2 := EqCert.trans mP2 eDP
    let eQ1 := EqCert.trans mQ1 eGQ
    let eQ2 := EqCert.trans mQ2 eDQ
    obtain ⟨_, _, hGP2⟩ := eqCert_preserves_frame eP1
    obtain ⟨_, _, hDP2⟩ := eqCert_preserves_frame eP2
    obtain ⟨_, hP10, hQ10⟩ := hasEndpoints3_common_frame h1
    obtain ⟨_, hP20, hQ20⟩ := hasEndpoints3_common_frame h2
    have hFP2 : HasFrame G.toDoubleSig _ _ := eqCert_frame_eq eP1 hFP hGP2 ▸ hGP2
    have hFQ2 : HasFrame G.toDoubleSig _ _ := eqCert_frame_eq eP2 hFQ hDP2 ▸ hDP2
    exact ⟨_, _, _, _, .compH3 h1 h2 hFP hFQ, .compH3 hG2 hD2 hFP2 hFQ2,
      .congH eP1 eP2 hFP hFQ,
      .congH eQ1 eQ2 (hasFrame_unique hP10 hFP ▸ hQ10) (hasFrame_unique hP20 hFQ ▸ hQ20)⟩
  | _, _, .congV3 hΓ hΔ h1 h2 hFP hFQ => by
    obtain ⟨_, _, _, _, hG1, hG2, eGP, eGQ⟩ := cell3_eq_preserves_endpoints hΓ
    obtain ⟨_, _, _, _, hD1, hD2, eDP, eDQ⟩ := cell3_eq_preserves_endpoints hΔ
    let ⟨mP1, mQ1⟩ := hasEndpoints3_unique_mod_2d h1 hG1
    let ⟨mP2, mQ2⟩ := hasEndpoints3_unique_mod_2d h2 hD1
    let eP1 := EqCert.trans mP1 eGP
    let eP2 := EqCert.trans mP2 eDP
    let eQ1 := EqCert.trans mQ1 eGQ
    let eQ2 := EqCert.trans mQ2 eDQ
    obtain ⟨_, _, hGP2⟩ := eqCert_preserves_frame eP1
    obtain ⟨_, _, hDP2⟩ := eqCert_preserves_frame eP2
    obtain ⟨_, hP10, hQ10⟩ := hasEndpoints3_common_frame h1
    obtain ⟨_, hP20, hQ20⟩ := hasEndpoints3_common_frame h2
    have hFP2 : HasFrame G.toDoubleSig _ _ := eqCert_frame_eq eP1 hFP hGP2 ▸ hGP2
    have hFQ2 : HasFrame G.toDoubleSig _ _ := eqCert_frame_eq eP2 hFQ hDP2 ▸ hDP2
    exact ⟨_, _, _, _, .compV3 h1 h2 hFP hFQ, .compV3 hG2 hD2 hFP2 hFQ2,
      .congV eP1 eP2 hFP hFQ,
      .congV eQ1 eQ2 (hasFrame_unique hP10 hFP ▸ hQ10) (hasFrame_unique hP20 hFQ ▸ hQ20)⟩

/-- **Theorem 9 (`v9 formal/59` Thm 9 / `T9` — Low-Dimensional Conservativity):**
Adjoining directed 3-cell generators `G₃` and 3D equations `Eq3Cert` NEVER equates previously
distinct base 2D terms: if the 3D identity embeddings satisfy `Eq3Cert G (.id3 P) (.id3 Q)`, then
already `EqCert G.toDoubleSig P Q` holds in the 2D base! -/
theorem conservative_over_base_2d {G : Double3Sig} {P Q : SqTerm G.toDoubleSig}
    (h : Eq3Cert G (.id3 P) (.id3 Q)) : EqCert G.toDoubleSig P Q := by
  obtain ⟨P₁, _, P₂, _, h1, h2, eP, _⟩ := cell3_eq_preserves_endpoints h
  cases h1 with
  | id3 hFP =>
    cases h2 with
    | id3 hFQ =>
      exact eP

/-- Monotonicity invariant for any generator weight `w : G.SqGen → Nat` under 3D derivations
when every primitive 3-cell satisfies `termWeight (c3Src ρ) ≤ termWeight (c3Tgt ρ)`. -/
theorem hasEndpoints3_weight_mono {G : Double3Sig} (w : G.SqGen → Nat)
    (hgen : ∀ ρ, termWeight G.toDoubleSig w (G.c3Src ρ) ≤ termWeight G.toDoubleSig w (G.c3Tgt ρ)) :
    ∀ {Γ : Cell3Term G} {P Q : SqTerm G.toDoubleSig},
      HasEndpoints3 G Γ P Q → termWeight G.toDoubleSig w P ≤ termWeight G.toDoubleSig w Q
  | _, _, _, .gen3 ρ => hgen ρ
  | _, _, _, .id3 _ => Nat.le_refl _
  | _, _, _, .compR hΓ hmid hΔ =>
    let e := eqCert_preserves_weight w hmid
    Nat.le_trans (hasEndpoints3_weight_mono w hgen hΓ)
      (e ▸ hasEndpoints3_weight_mono w hgen hΔ)
  | _, _, _, .compH3 hΓ hΔ _ _ =>
    Nat.add_le_add (hasEndpoints3_weight_mono w hgen hΓ) (hasEndpoints3_weight_mono w hgen hΔ)
  | _, _, _, .compV3 hΓ hΔ _ _ =>
    Nat.add_le_add (hasEndpoints3_weight_mono w hgen hΓ) (hasEndpoints3_weight_mono w hgen hΔ)
  | _, _, _, .transport hΓ hP hQ =>
    let eP := eqCert_preserves_weight w hP
    let eQ := eqCert_preserves_weight w hQ
    eP ▸ eQ ▸ hasEndpoints3_weight_mono w hgen hΓ

/-- Base 2-generator signature with 1 object and trivial empty edge loops. -/
def directedNonCollapse2Sig : DoubleSig where
  Obj := Unit
  HGen := Unit
  VGen := Unit
  SqGen := Bool
  hSrc _ := ()
  hTgt _ := ()
  vSrc _ := ()
  vTgt _ := ()
  sqFrame _ := ⟨(), (), (), (), .nil (), .nil (), .nil (), .nil ()⟩

/-- Concrete 1-object, parallel 2-generator, directed 3-cell signature: `ρ : gen false ⟹ gen true`. -/
def directedNonCollapse3Sig : Double3Sig :=
  { directedNonCollapse2Sig with
    Cell3Gen := Unit
    c3Src := fun _ => .gen false
    c3Tgt := fun _ => .gen true
    c3Frame := fun _ => directedNonCollapse2Sig.sqFrame false
    c3SrcFrame := fun _ => HasFrame.gen (G := directedNonCollapse2Sig) false
    c3TgtFrame := fun _ => HasFrame.gen (G := directedNonCollapse2Sig) true }

/-- **Constructive 2D/3D Separation & Non-Reversibility Witness:**
On `directedNonCollapse3Sig`, `.gen3 ()` witnesses a valid directed 3-cell `gen false ⟹ gen true`,
while: (1) `¬ EqCert (.gen false) (.gen true)` (no 2D structural equality), and (2) NO derived 3-cell
exists in the reverse direction (`¬ HasEndpoints3 Γ (.gen true) (.gen false)`). -/
theorem strict_2d_3d_noncollapse_witness :
    HasEndpoints3 directedNonCollapse3Sig (.gen3 (G := directedNonCollapse3Sig) ())
      (.gen (G := directedNonCollapse2Sig) false) (.gen (G := directedNonCollapse2Sig) true) ∧
    ¬ EqCert directedNonCollapse2Sig (.gen false) (.gen true) ∧
    ∀ Γ : Cell3Term directedNonCollapse3Sig,
      ¬ HasEndpoints3 directedNonCollapse3Sig Γ (.gen true) (.gen false) := by
  let w : directedNonCollapse2Sig.SqGen → Nat := fun g =>
    match (g : Bool) with | false => 0 | true => 1
  have hgen : ∀ ρ : directedNonCollapse3Sig.Cell3Gen,
      termWeight directedNonCollapse2Sig w (directedNonCollapse3Sig.c3Src ρ) ≤
        termWeight directedNonCollapse2Sig w (directedNonCollapse3Sig.c3Tgt ρ) := by
    intro _
    exact Nat.zero_le 1
  refine ⟨HasEndpoints3.gen3 (G := directedNonCollapse3Sig) (),
    distinct_same_frame_gens_not_cert_eq (G := directedNonCollapse2Sig) w (by decide), ?_⟩
  intro Γ hrev
  have hle := hasEndpoints3_weight_mono (G := directedNonCollapse3Sig) w hgen hrev
  exact absurd hle (Nat.not_succ_le_zero 0)

/-- Degenerate-edge strict triple category `K ∈ Cat(DblCat)` extending `StrictDoubleCat` with 3-cells
along the third direction (`c3Src`, `c3Tgt`, `c3Id`, `c3CompR`, `c3CompH`, `c3CompV`). -/
structure StrictTripleCat extends StrictDoubleCat where
  Cell3 : Type
  c3Src : Cell3 → Sq
  c3Tgt : Cell3 → Sq
  c3Id : Sq → Cell3
  c3CompR : Cell3 → Cell3 → Cell3
  c3CompH : Cell3 → Cell3 → Cell3
  c3CompV : Cell3 → Cell3 → Cell3
  c3Id_src : ∀ p, c3Src (c3Id p) = p
  c3Id_tgt : ∀ p, c3Tgt (c3Id p) = p
  c3CompR_src : ∀ g d, c3Tgt g = c3Src d → c3Src (c3CompR g d) = c3Src g
  c3CompR_tgt : ∀ g d, c3Tgt g = c3Src d → c3Tgt (c3CompR g d) = c3Tgt d
  c3CompH_src : ∀ g d, right (c3Src g) = left (c3Src d) → c3Src (c3CompH g d) = sqCompH (c3Src g) (c3Src d)
  c3CompH_tgt : ∀ g d, right (c3Src g) = left (c3Src d) → c3Tgt (c3CompH g d) = sqCompH (c3Tgt g) (c3Tgt d)
  c3CompV_src : ∀ g d, bot (c3Src g) = top (c3Src d) → c3Src (c3CompV g d) = sqCompV (c3Src g) (c3Src d)
  c3CompV_tgt : ∀ g d, bot (c3Src g) = top (c3Src d) → c3Tgt (c3CompV g d) = sqCompV (c3Tgt g) (c3Tgt d)
  c3AssocR : ∀ g d x, c3Tgt g = c3Src d → c3Tgt d = c3Src x →
    c3CompR (c3CompR g d) x = c3CompR g (c3CompR d x)
  c3IdR_l : ∀ g, c3CompR (c3Id (c3Src g)) g = g
  c3IdR_r : ∀ g, c3CompR g (c3Id (c3Tgt g)) = g
  c3AssocH : ∀ g d x,
    right (c3Src g) = left (c3Src d) → right (c3Src d) = left (c3Src x) →
    c3CompH (c3CompH g d) x = c3CompH g (c3CompH d x)
  c3IdH_l : ∀ g, c3CompH (c3Id (sqIdH (left (c3Src g)))) g = g
  c3IdH_r : ∀ g, c3CompH g (c3Id (sqIdH (right (c3Src g)))) = g
  c3AssocV : ∀ g d x,
    bot (c3Src g) = top (c3Src d) → bot (c3Src d) = top (c3Src x) →
    c3CompV (c3CompV g d) x = c3CompV g (c3CompV d x)
  c3IdV_l : ∀ g, c3CompV (c3Id (sqIdV (top (c3Src g)))) g = g
  c3IdV_r : ∀ g, c3CompV g (c3Id (sqIdV (bot (c3Src g)))) = g
  c3Interchange_hv : ∀ g d x w,
    right (c3Src g) = left (c3Src d) → right (c3Src x) = left (c3Src w) →
    bot (c3Src g) = top (c3Src x) → bot (c3Src d) = top (c3Src w) →
    c3CompV (c3CompH g d) (c3CompH x w) = c3CompH (c3CompV g x) (c3CompV d w)
  c3Interchange_hr : ∀ g d x w,
    c3Tgt g = c3Src d → c3Tgt x = c3Src w →
    right (c3Src g) = left (c3Src x) → right (c3Src d) = left (c3Src w) →
    c3CompH (c3CompR g d) (c3CompR x w) = c3CompR (c3CompH g x) (c3CompH d w)
  c3Interchange_vr : ∀ g d x w,
    c3Tgt g = c3Src d → c3Tgt x = c3Src w →
    bot (c3Src g) = top (c3Src x) → bot (c3Src d) = top (c3Src w) →
    c3CompV (c3CompR g d) (c3CompR x w) = c3CompR (c3CompV g x) (c3CompV d w)
  c3Id_compH : ∀ p q, right p = left q → c3Id (sqCompH p q) = c3CompH (c3Id p) (c3Id q)
  c3Id_compV : ∀ p q, bot p = top q → c3Id (sqCompV p q) = c3CompV (c3Id p) (c3Id q)

/-- Interpretation of a 3D signature `(G, G₃)` into `StrictTripleCat` extending a 2D `SigInterp`. -/
structure Sig3Interp (G : Double3Sig) (K : StrictTripleCat) where
  base : SigInterp G.toDoubleSig K.toStrictDoubleCat
  onCell3Gen : G.Cell3Gen → K.Cell3
  cell3Src_eq : ∀ ρ, K.c3Src (onCell3Gen ρ) = evalSqTerm base (G.c3Src ρ)
  cell3Tgt_eq : ∀ ρ, K.c3Tgt (onCell3Gen ρ) = evalSqTerm base (G.c3Tgt ρ)

/-- Free 3-cell recursive evaluator `Cell3Term G → K.Cell3`. -/
def evalCell3Term {G : Double3Sig} {K : StrictTripleCat} (I : Sig3Interp G K) : Cell3Term G → K.Cell3
  | .gen3 ρ => I.onCell3Gen ρ
  | .id3 P => K.c3Id (evalSqTerm I.base P)
  | .compR Γ Δ => K.c3CompR (evalCell3Term I Γ) (evalCell3Term I Δ)
  | .compH3 Γ Δ => K.c3CompH (evalCell3Term I Γ) (evalCell3Term I Δ)
  | .compV3 Γ Δ => K.c3CompV (evalCell3Term I Γ) (evalCell3Term I Δ)
  | .transport Γ _ _ => evalCell3Term I Γ

theorem evalCell3Term_endpoints {G : Double3Sig} {K : StrictTripleCat} (I : Sig3Interp G K) :
    ∀ {Γ : Cell3Term G} {P Q : SqTerm G.toDoubleSig},
      HasEndpoints3 G Γ P Q →
      K.c3Src (evalCell3Term I Γ) = evalSqTerm I.base P ∧
      K.c3Tgt (evalCell3Term I Γ) = evalSqTerm I.base Q
  | _, _, _, .gen3 ρ => ⟨I.cell3Src_eq ρ, I.cell3Tgt_eq ρ⟩
  | _, _, _, .id3 _ => ⟨K.c3Id_src _, K.c3Id_tgt _⟩
  | _, _, _, .compR hΓ hmid hΔ =>
    let eΓ := evalCell3Term_endpoints I hΓ
    let eΔ := evalCell3Term_endpoints I hΔ
    let hlink : K.c3Tgt (evalCell3Term I _) = K.c3Src (evalCell3Term I _) :=
      eΓ.2.trans ((eqCert_sound I.base hmid).trans eΔ.1.symm)
    ⟨(K.c3CompR_src _ _ hlink).trans eΓ.1, (K.c3CompR_tgt _ _ hlink).trans eΔ.2⟩
  | _, _, _, .compH3 hΓ hΔ hFP hFQ =>
    let eΓ := evalCell3Term_endpoints I hΓ
    let eΔ := evalCell3Term_endpoints I hΔ
    let eP1 := evalSqTerm_frame I.base hFP
    let eP2 := evalSqTerm_frame I.base hFQ
    let hlink : K.right (K.c3Src (evalCell3Term I _)) = K.left (K.c3Src (evalCell3Term I _)) := by
      rw [eΓ.1, eΔ.1]
      exact eP1.2.2.2.trans eP2.2.2.1.symm
    ⟨(K.c3CompH_src _ _ hlink).trans (congrArg2 K.sqCompH eΓ.1 eΔ.1),
     (K.c3CompH_tgt _ _ hlink).trans (congrArg2 K.sqCompH eΓ.2 eΔ.2)⟩
  | _, _, _, .compV3 hΓ hΔ hFP hFQ =>
    let eΓ := evalCell3Term_endpoints I hΓ
    let eΔ := evalCell3Term_endpoints I hΔ
    let eP1 := evalSqTerm_frame I.base hFP
    let eP2 := evalSqTerm_frame I.base hFQ
    let hlink : K.bot (K.c3Src (evalCell3Term I _)) = K.top (K.c3Src (evalCell3Term I _)) := by
      rw [eΓ.1, eΔ.1]
      exact eP1.2.1.trans eP2.1.symm
    ⟨(K.c3CompV_src _ _ hlink).trans (congrArg2 K.sqCompV eΓ.1 eΔ.1),
     (K.c3CompV_tgt _ _ hlink).trans (congrArg2 K.sqCompV eΓ.2 eΔ.2)⟩
  | _, _, _, .transport hΓ hP hQ =>
    let eΓ := evalCell3Term_endpoints I hΓ
    ⟨eΓ.1.trans (eqCert_sound I.base hP), eΓ.2.trans (eqCert_sound I.base hQ)⟩

theorem evalCell3Term_compH3_compat {G : Double3Sig} {K : StrictTripleCat} (I : Sig3Interp G K)
    {Γ Δ : Cell3Term G} {P₁ P₂ Q₁ Q₂ : SqTerm G.toDoubleSig}
    (h : HasEndpoints3 G (.compH3 Γ Δ) (.compH P₁ P₂) (.compH Q₁ Q₂)) :
    K.right (K.c3Src (evalCell3Term I Γ)) = K.left (K.c3Src (evalCell3Term I Δ)) := by
  cases h with
  | compH3 hΓ hΔ hFP hFQ =>
    rw [(evalCell3Term_endpoints I hΓ).1, (evalCell3Term_endpoints I hΔ).1]
    exact (evalSqTerm_frame I.base hFP).2.2.2.trans (evalSqTerm_frame I.base hFQ).2.2.1.symm

theorem evalCell3Term_compV3_compat {G : Double3Sig} {K : StrictTripleCat} (I : Sig3Interp G K)
    {Γ Δ : Cell3Term G} {P₁ P₂ Q₁ Q₂ : SqTerm G.toDoubleSig}
    (h : HasEndpoints3 G (.compV3 Γ Δ) (.compV P₁ P₂) (.compV Q₁ Q₂)) :
    K.bot (K.c3Src (evalCell3Term I Γ)) = K.top (K.c3Src (evalCell3Term I Δ)) := by
  cases h with
  | compV3 hΓ hΔ hFP hFQ =>
    rw [(evalCell3Term_endpoints I hΓ).1, (evalCell3Term_endpoints I hΔ).1]
    exact (evalSqTerm_frame I.base hFP).2.1.trans (evalSqTerm_frame I.base hFQ).1.symm

theorem evalCell3Term_compR_compat {G : Double3Sig} {K : StrictTripleCat} (I : Sig3Interp G K)
    {Γ Δ : Cell3Term G} {P Q Q' R : SqTerm G.toDoubleSig}
    (hΓ : HasEndpoints3 G Γ P Q) (hm : EqCert G.toDoubleSig Q Q') (hΔ : HasEndpoints3 G Δ Q' R) :
    K.c3Tgt (evalCell3Term I Γ) = K.c3Src (evalCell3Term I Δ) :=
  (evalCell3Term_endpoints I hΓ).2.trans
    ((eqCert_sound I.base hm).trans (evalCell3Term_endpoints I hΔ).1.symm)

/-- **Theorem 8 (`v9 formal/59` Thm 8 / `T8` — Relative 3D Soundness):**
Every derivable `Eq3Cert G Γ Δ` evaluates equal in EVERY `StrictTripleCat` extending `I.base`. -/
theorem free_3d_eval_sound {G : Double3Sig} {K : StrictTripleCat} (I : Sig3Interp G K) :
    ∀ {Γ Δ : Cell3Term G}, Eq3Cert G Γ Δ → evalCell3Term I Γ = evalCell3Term I Δ
  | _, _, .refl _ => rfl
  | _, _, .symm h => (free_3d_eval_sound I h).symm
  | _, _, .trans h1 h2 => (free_3d_eval_sound I h1).trans (free_3d_eval_sound I h2)
  | _, _, .transport_base _ _ _ => rfl
  | _, _, .assocR hΓ hm1 hΔ hm2 hΞ =>
    K.c3AssocR _ _ _
      (evalCell3Term_compR_compat I hΓ hm1 hΔ)
      (evalCell3Term_compR_compat I hΔ hm2 hΞ)
  | _, _, .idR_l hΓ => by
    dsimp only [evalCell3Term]
    rw [← (evalCell3Term_endpoints I hΓ).1]
    exact K.c3IdR_l _
  | _, _, .idR_r hΓ => by
    dsimp only [evalCell3Term]
    rw [← (evalCell3Term_endpoints I hΓ).2]
    exact K.c3IdR_r _
  | _, _, .assocH3 h123 h23 => by
    cases h123 with
    | compH3 h12 _ _ _ =>
      cases h12 with
      | compH3 h1 h2 hF1 hF2 =>
        cases h23 with
        | compH3 _ h23sub _ _ =>
          cases h23sub with
          | compH3 h2' h3 hF2' hF3 =>
            dsimp only [evalCell3Term]
            refine K.c3AssocH _ _ _ ?_ ?_
            · rw [(evalCell3Term_endpoints I h1).1, (evalCell3Term_endpoints I h2).1]
              exact (evalSqTerm_frame I.base hF1).2.2.2.trans (evalSqTerm_frame I.base hF2).2.2.1.symm
            · rw [(evalCell3Term_endpoints I h2').1, (evalCell3Term_endpoints I h3).1]
              exact (evalSqTerm_frame I.base hF2').2.2.2.trans (evalSqTerm_frame I.base hF3).2.2.1.symm
  | _, _, .idH3_l hΓ hFP => by
    have hl := (evalSqTerm_frame I.base hFP).2.2.1
    dsimp only at hl
    dsimp only [evalCell3Term, evalSqTerm]
    rw [← hl, ← (evalCell3Term_endpoints I hΓ).1]
    exact K.c3IdH_l _
  | _, _, .idH3_r hΓ hFP => by
    have hr := (evalSqTerm_frame I.base hFP).2.2.2
    dsimp only at hr
    dsimp only [evalCell3Term, evalSqTerm]
    rw [← hr, ← (evalCell3Term_endpoints I hΓ).1]
    exact K.c3IdH_r _
  | _, _, .assocV3 h123 h23 => by
    cases h123 with
    | compV3 h12 _ _ _ =>
      cases h12 with
      | compV3 h1 h2 hF1 hF2 =>
        cases h23 with
        | compV3 _ h23sub _ _ =>
          cases h23sub with
          | compV3 h2' h3 hF2' hF3 =>
            dsimp only [evalCell3Term]
            refine K.c3AssocV _ _ _ ?_ ?_
            · rw [(evalCell3Term_endpoints I h1).1, (evalCell3Term_endpoints I h2).1]
              exact (evalSqTerm_frame I.base hF1).2.1.trans (evalSqTerm_frame I.base hF2).1.symm
            · rw [(evalCell3Term_endpoints I h2').1, (evalCell3Term_endpoints I h3).1]
              exact (evalSqTerm_frame I.base hF2').2.1.trans (evalSqTerm_frame I.base hF3).1.symm
  | _, _, .idV3_l hΓ hFP => by
    have ht := (evalSqTerm_frame I.base hFP).1
    dsimp only at ht
    dsimp only [evalCell3Term, evalSqTerm]
    rw [← ht, ← (evalCell3Term_endpoints I hΓ).1]
    exact K.c3IdV_l _
  | _, _, .idV3_r hΓ hFP => by
    have hb := (evalSqTerm_frame I.base hFP).2.1
    dsimp only at hb
    dsimp only [evalCell3Term, evalSqTerm]
    rw [← hb, ← (evalCell3Term_endpoints I hΓ).1]
    exact K.c3IdV_r _
  | _, _, .interchange_hv hL hR _ _ => by
    cases hL with
    | compV3 hTop hBot _ _ =>
      cases hTop with
      | compH3 h1 h2 hF1 hF2 =>
        cases hBot with
        | compH3 h3 h4 hF3 hF4 =>
          cases hR with
          | compH3 hLeft hRight _ _ =>
            cases hLeft with
            | compV3 h1' h3' hF1' hF3' =>
              cases hRight with
              | compV3 h2' h4' hF2' hF4' =>
                dsimp only [evalCell3Term]
                refine K.c3Interchange_hv _ _ _ _ ?_ ?_ ?_ ?_
                · rw [(evalCell3Term_endpoints I h1).1, (evalCell3Term_endpoints I h2).1]
                  exact (evalSqTerm_frame I.base hF1).2.2.2.trans (evalSqTerm_frame I.base hF2).2.2.1.symm
                · rw [(evalCell3Term_endpoints I h3).1, (evalCell3Term_endpoints I h4).1]
                  exact (evalSqTerm_frame I.base hF3).2.2.2.trans (evalSqTerm_frame I.base hF4).2.2.1.symm
                · rw [(evalCell3Term_endpoints I h1').1, (evalCell3Term_endpoints I h3').1]
                  exact (evalSqTerm_frame I.base hF1').2.1.trans (evalSqTerm_frame I.base hF3').1.symm
                · rw [(evalCell3Term_endpoints I h2').1, (evalCell3Term_endpoints I h4').1]
                  exact (evalSqTerm_frame I.base hF2').2.1.trans (evalSqTerm_frame I.base hF4').1.symm
  | _, _, .interchange_hr hL hR => by
    cases hL with
    | compH3 hLeftR hRightR _ _ =>
      cases hLeftR with
      | compR hΓ hm1 hΔ =>
        cases hRightR with
        | compR hΞ hm2 hΩ =>
          cases hR with
          | compR hH1 _ hH2 =>
            cases hH1 with
            | compH3 hΓ' hΞ' hFΓ hFΞ =>
              cases hH2 with
              | compH3 hΔ' hΩ' hFΔ hFΩ =>
                dsimp only [evalCell3Term]
                refine K.c3Interchange_hr _ _ _ _
                  (evalCell3Term_compR_compat I hΓ hm1 hΔ)
                  (evalCell3Term_compR_compat I hΞ hm2 hΩ) ?_ ?_
                · rw [(evalCell3Term_endpoints I hΓ').1, (evalCell3Term_endpoints I hΞ').1]
                  exact (evalSqTerm_frame I.base hFΓ).2.2.2.trans (evalSqTerm_frame I.base hFΞ).2.2.1.symm
                · rw [(evalCell3Term_endpoints I hΔ').1, (evalCell3Term_endpoints I hΩ').1]
                  exact (evalSqTerm_frame I.base hFΔ).2.2.2.trans (evalSqTerm_frame I.base hFΩ).2.2.1.symm
  | _, _, .interchange_vr hL hR => by
    cases hL with
    | compV3 hTopR hBotR _ _ =>
      cases hTopR with
      | compR hΓ hm1 hΔ =>
        cases hBotR with
        | compR hΞ hm2 hΩ =>
          cases hR with
          | compR hV1 _ hV2 =>
            cases hV1 with
            | compV3 hΓ' hΞ' hFΓ hFΞ =>
              cases hV2 with
              | compV3 hΔ' hΩ' hFΔ hFΩ =>
                dsimp only [evalCell3Term]
                refine K.c3Interchange_vr _ _ _ _
                  (evalCell3Term_compR_compat I hΓ hm1 hΔ)
                  (evalCell3Term_compR_compat I hΞ hm2 hΩ) ?_ ?_
                · rw [(evalCell3Term_endpoints I hΓ').1, (evalCell3Term_endpoints I hΞ').1]
                  exact (evalSqTerm_frame I.base hFΓ).2.1.trans (evalSqTerm_frame I.base hFΞ).1.symm
                · rw [(evalCell3Term_endpoints I hΔ').1, (evalCell3Term_endpoints I hΩ').1]
                  exact (evalSqTerm_frame I.base hFΔ).2.1.trans (evalSqTerm_frame I.base hFΩ).1.symm
  | _, _, .id3_compH hP hQ =>
    K.c3Id_compH _ _ ((evalSqTerm_frame I.base hP).2.2.2.trans (evalSqTerm_frame I.base hQ).2.2.1.symm)
  | _, _, .id3_compV hP hQ =>
    K.c3Id_compV _ _ ((evalSqTerm_frame I.base hP).2.1.trans (evalSqTerm_frame I.base hQ).1.symm)
  | _, _, .congR hΓ hΔ _ _ _ => congrArg2 K.c3CompR (free_3d_eval_sound I hΓ) (free_3d_eval_sound I hΔ)
  | _, _, .congH3 hΓ hΔ _ _ _ _ => congrArg2 K.c3CompH (free_3d_eval_sound I hΓ) (free_3d_eval_sound I hΔ)
  | _, _, .congV3 hΓ hΔ _ _ _ _ => congrArg2 K.c3CompV (free_3d_eval_sound I hΓ) (free_3d_eval_sound I hΔ)

/-! ## Part 4: Guarded Oplax Double Syntax Interpreting into `Becoming.OplaxHistory` -/

/-- Guarded oplax syntax pairing sequential pullback composition (`seq` `⋆`), strong disjoint
parallel coproduct (`par` `⊕`), and sum-preserving macro assembly (`assemble` `Q`). -/
inductive GuardedExpr : Type → Type → Type 1 where
  | atom {A B : Type} (H : OplaxHistory.RelSpan A B) : GuardedExpr A B
  | idExpr (A : Type) : GuardedExpr A A
  | seq {A D C : Type} (e₁ : GuardedExpr A D) (e₂ : GuardedExpr D C) : GuardedExpr A C
  | par {A A' B B' : Type} (e₁ : GuardedExpr A B) (e₂ : GuardedExpr A' B') :
      GuardedExpr (Sum A A') (Sum B B')
  | assemble (S : OplaxHistory.SumPreservingFunctor) {A B : Type} (e : GuardedExpr A B) :
      GuardedExpr (S.toFunctor.obj A) (S.toFunctor.obj B)

/-- Evaluate a `GuardedExpr A B` cleanly into a concrete `OplaxHistory.RelSpan A B`. -/
def evalGuardedExpr : {A B : Type} → GuardedExpr A B → OplaxHistory.RelSpan A B
  | _, _, .atom H => H
  | _, _, .idExpr A => OplaxHistory.idSpan A
  | _, _, .seq e₁ e₂ => OplaxHistory.compSpan (evalGuardedExpr e₁) (evalGuardedExpr e₂)
  | _, _, .par e₁ e₂ => OplaxHistory.coprodSpan (evalGuardedExpr e₁) (evalGuardedExpr e₂)
  | _, _, .assemble S e => S.toFunctor.onSpan (evalGuardedExpr e)

/-- Constructive guarded derivation terms (`GuardedProof e₁ e₂`):
* Disjoint parallel `⊕` vs sequential `⋆` is ALWAYS two-sided (`parSeqDistLR` / `parSeqDistRL`);
* Macro assembly over sequential history `Q(H ⋆ K) → Q(H) ⋆ Q(K)` is DIRECTED (`chiStep`);
* Reversing `chiStep` (`chiInv`) is forbidden unless supplied with an explicit `Bij` + `hb` witness
  certifying `FImageIsPullback` and fiberwise Beck–Chevalley bijectivity (`guarded_interchange_upgrades_iff_bc`). -/
inductive GuardedProof : {A B : Type} → GuardedExpr A B → GuardedExpr A B → Type 1 where
  | refl {A B : Type} (e : GuardedExpr A B) : GuardedProof e e
  | trans {A B : Type} {e₁ e₂ e₃ : GuardedExpr A B}
      (p : GuardedProof e₁ e₂) (q : GuardedProof e₂ e₃) : GuardedProof e₁ e₃
  | seqCong {A D C : Type} {e₁ e₁' : GuardedExpr A D} {e₂ e₂' : GuardedExpr D C}
      (p : GuardedProof e₁ e₁') (q : GuardedProof e₂ e₂') :
      GuardedProof (.seq e₁ e₂) (.seq e₁' e₂')
  | parCong {A A' B B' : Type} {e₁ e₁' : GuardedExpr A B} {e₂ e₂' : GuardedExpr A' B'}
      (p : GuardedProof e₁ e₁') (q : GuardedProof e₂ e₂') :
      GuardedProof (.par e₁ e₂) (.par e₁' e₂')
  | assembleCong (S : OplaxHistory.SumPreservingFunctor) {A B : Type} {e₁ e₂ : GuardedExpr A B}
      (p : GuardedProof e₁ e₂) : GuardedProof (.assemble S e₁) (.assemble S e₂)
  | parSeqDistLR {A D C A' D' C' : Type}
      (e₁ : GuardedExpr A D) (e₂ : GuardedExpr D C)
      (e₁' : GuardedExpr A' D') (e₂' : GuardedExpr D' C') :
      GuardedProof (.par (.seq e₁ e₂) (.seq e₁' e₂')) (.seq (.par e₁ e₁') (.par e₂ e₂'))
  | parSeqDistRL {A D C A' D' C' : Type}
      (e₁ : GuardedExpr A D) (e₂ : GuardedExpr D C)
      (e₁' : GuardedExpr A' D') (e₂' : GuardedExpr D' C') :
      GuardedProof (.seq (.par e₁ e₁') (.par e₂ e₂')) (.par (.seq e₁ e₂) (.seq e₁' e₂'))
  | chiStep (S : OplaxHistory.SumPreservingFunctor) {A D C : Type}
      (e₁ : GuardedExpr A D) (e₂ : GuardedExpr D C) :
      GuardedProof (.assemble S (.seq e₁ e₂)) (.seq (.assemble S e₁) (.assemble S e₂))
  | chiInv (S : OplaxHistory.SumPreservingFunctor) {A D C : Type}
      (e₁ : GuardedExpr A D) (e₂ : GuardedExpr D C)
      (b : OplaxHistory.Bij
        (S.toFunctor.obj (OplaxHistory.PullbackElem (evalGuardedExpr e₁).right (evalGuardedExpr e₂).left))
        (OplaxHistory.PullbackElem
          (S.toFunctor.map (evalGuardedExpr e₁).right)
          (S.toFunctor.map (evalGuardedExpr e₂).left)))
      (hb : ∀ u, b.toFun u = (OplaxHistory.chi S.toFunctor (evalGuardedExpr e₁) (evalGuardedExpr e₂)).map u) :
      GuardedProof (.seq (.assemble S e₁) (.assemble S e₂)) (.assemble S (.seq e₁ e₂))

/-- Helper: `(H ⋆ K) ⊕ (H' ⋆ K') → (H ⊕ H') ⋆ (K ⊕ K')` as a `SpanHom`. -/
def parSeqDistHomLR {A D C A' D' C' : Type}
    (H : OplaxHistory.RelSpan A D) (K : OplaxHistory.RelSpan D C)
    (H' : OplaxHistory.RelSpan A' D') (K' : OplaxHistory.RelSpan D' C') :
    OplaxHistory.SpanHom
      (OplaxHistory.coprodSpan (OplaxHistory.compSpan H K) (OplaxHistory.compSpan H' K'))
      (OplaxHistory.compSpan (OplaxHistory.coprodSpan H H') (OplaxHistory.coprodSpan K K')) where
  map := (OplaxHistory.coprod_pullback_iso H K H' K').toFun
  left_eq
    | .inl _ => rfl
    | .inr _ => rfl
  right_eq
    | .inl _ => rfl
    | .inr _ => rfl

/-- Helper: `(H ⊕ H') ⋆ (K ⊕ K') → (H ⋆ K) ⊕ (H' ⋆ K')` as a `SpanHom`. -/
def parSeqDistHomRL {A D C A' D' C' : Type}
    (H : OplaxHistory.RelSpan A D) (K : OplaxHistory.RelSpan D C)
    (H' : OplaxHistory.RelSpan A' D') (K' : OplaxHistory.RelSpan D' C') :
    OplaxHistory.SpanHom
      (OplaxHistory.compSpan (OplaxHistory.coprodSpan H H') (OplaxHistory.coprodSpan K K'))
      (OplaxHistory.coprodSpan (OplaxHistory.compSpan H K) (OplaxHistory.compSpan H' K')) where
  map := (OplaxHistory.coprod_pullback_iso H K H' K').invFun
  left_eq p := by
    obtain ⟨a, b, m⟩ := p
    cases a <;> cases b
    · rfl
    · exact False.elim (by cases m)
    · exact False.elim (by cases m)
    · rfl
  right_eq p := by
    obtain ⟨a, b, m⟩ := p
    cases a <;> cases b
    · rfl
    · exact False.elim (by cases m)
    · exact False.elim (by cases m)
    · rfl

/-- Helper lifting `coprodSpan` morphisms cleanly. -/
def parSpanHom {A A' B B' : Type} {H₁ H₂ : OplaxHistory.RelSpan A B}
    {H₁' H₂' : OplaxHistory.RelSpan A' B'}
    (a : OplaxHistory.SpanHom H₁ H₂) (b : OplaxHistory.SpanHom H₁' H₂') :
    OplaxHistory.SpanHom (OplaxHistory.coprodSpan H₁ H₁') (OplaxHistory.coprodSpan H₂ H₂') where
  map
    | .inl w => .inl (a.map w)
    | .inr w => .inr (b.map w)
  left_eq
    | .inl w => congrArg Sum.inl (a.left_eq w)
    | .inr w => congrArg Sum.inr (b.left_eq w)
  right_eq
    | .inl w => congrArg Sum.inl (a.right_eq w)
    | .inr w => congrArg Sum.inr (b.right_eq w)

/-- Guarded inverse comparison `SpanHom` from explicit `Bij` + `hb` witness. -/
def chiInvSpanHom (F : OplaxHistory.SpanFunctor) {A D C : Type}
    (H : OplaxHistory.RelSpan A D) (K : OplaxHistory.RelSpan D C)
    (b : OplaxHistory.Bij
      (F.obj (OplaxHistory.PullbackElem H.right K.left))
      (OplaxHistory.PullbackElem (F.map H.right) (F.map K.left)))
    (hb : ∀ u, b.toFun u = (OplaxHistory.chi F H K).map u) :
    OplaxHistory.SpanHom (OplaxHistory.compSpan (F.onSpan H) (F.onSpan K))
      (F.onSpan (OplaxHistory.compSpan H K)) where
  map := b.invFun
  left_eq x := by
    let u := b.invFun x
    have hbu : (OplaxHistory.chi F H K).map u = x := (hb u).symm.trans (b.right_inv x)
    exact (OplaxHistory.chi_left F H K u).symm.trans
      (congrArg (OplaxHistory.compSpan (F.onSpan H) (F.onSpan K)).left hbu)
  right_eq x := by
    let u := b.invFun x
    have hbu : (OplaxHistory.chi F H K).map u = x := (hb u).symm.trans (b.right_inv x)
    exact (OplaxHistory.chi_right F H K u).symm.trans
      (congrArg (OplaxHistory.compSpan (F.onSpan H) (F.onSpan K)).right hbu)

/-- **Sound Interpretation into `Becoming.OplaxHistory` (`guarded_oplax_sound`):**
Every guarded derivation `GuardedProof e₁ e₂` evaluates to an endpoint-preserving `SpanHom`. -/
def evalGuardedProof {A B : Type} : {e₁ e₂ : GuardedExpr A B} →
    GuardedProof e₁ e₂ → OplaxHistory.SpanHom (evalGuardedExpr e₁) (evalGuardedExpr e₂)
  | _, _, .refl e => OplaxHistory.SpanHom.id (evalGuardedExpr e)
  | _, _, .trans p q => OplaxHistory.SpanHom.comp (evalGuardedProof q) (evalGuardedProof p)
  | _, _, .seqCong p q => OplaxHistory.compSpanHom (evalGuardedProof p) (evalGuardedProof q)
  | _, _, .parCong p q => parSpanHom (evalGuardedProof p) (evalGuardedProof q)
  | _, _, .assembleCong S p => S.toFunctor.onHom (evalGuardedProof p)
  | _, _, .parSeqDistLR e₁ e₂ e₁' e₂' =>
      parSeqDistHomLR (evalGuardedExpr e₁) (evalGuardedExpr e₂) (evalGuardedExpr e₁') (evalGuardedExpr e₂')
  | _, _, .parSeqDistRL e₁ e₂ e₁' e₂' =>
      parSeqDistHomRL (evalGuardedExpr e₁) (evalGuardedExpr e₂) (evalGuardedExpr e₁') (evalGuardedExpr e₂')
  | _, _, .chiStep S e₁ e₂ => OplaxHistory.chi S.toFunctor (evalGuardedExpr e₁) (evalGuardedExpr e₂)
  | _, _, .chiInv S e₁ e₂ b hb =>
      chiInvSpanHom S.toFunctor (evalGuardedExpr e₁) (evalGuardedExpr e₂) b hb

/-- **Guarded-Oplax Soundness & `chiInv` BC Certification (`guarded_oplax_sound`):**
1. Disjoint `parSeqDistLR` / `parSeqDistRL` form an exact two-sided inverse pair;
2. Every `chiInv S e₁ e₂ b hb` guard certifies BOTH `FImageIsPullback S.toFunctor H K` AND
   fiberwise Beck–Chevalley bijectivity `∀ E v, IsBijective (bcMap ...)` via `guarded_interchange_upgrades_iff_bc`. -/
theorem guarded_oplax_sound {A B : Type} {e₁ e₂ : GuardedExpr A B} (p : GuardedProof e₁ e₂) :
    (∀ w, ((evalGuardedExpr e₂).left ((evalGuardedProof p).map w) = (evalGuardedExpr e₁).left w) ∧
          ((evalGuardedExpr e₂).right ((evalGuardedProof p).map w) = (evalGuardedExpr e₁).right w)) ∧
    (∀ {X Y Z : Type} (H : OplaxHistory.RelSpan X Y) (K : OplaxHistory.RelSpan Y Z)
      (S : OplaxHistory.SumPreservingFunctor)
      (b : OplaxHistory.Bij
        (S.toFunctor.obj (OplaxHistory.PullbackElem H.right K.left))
        (OplaxHistory.PullbackElem (S.toFunctor.map H.right) (S.toFunctor.map K.left))),
      (∀ u, b.toFun u = (OplaxHistory.chi S.toFunctor H K).map u) →
      OplaxHistory.FImageIsPullback S.toFunctor H K ∧
      ∀ (E : S.toFunctor.obj H.W → Type) (v : S.toFunctor.obj K.W),
        OplaxHistory.IsBijective (OplaxHistory.bcMap S.toFunctor H K E v)) := by
  constructor
  · intro w
    exact ⟨(evalGuardedProof p).left_eq w, (evalGuardedProof p).right_eq w⟩
  · intro X Y Z H K S b hb
    have hbij : OplaxHistory.IsBijective (OplaxHistory.chi S.toFunctor H K).map := by
      have hbIso := OplaxHistory.isBijective_of_bij b
      refine ⟨fun u₁ u₂ heq => hbIso.1 u₁ u₂ ((hb u₁).trans (heq.trans (hb u₂).symm)),
              fun y => ?_⟩
      obtain ⟨u, hu⟩ := hbIso.2 y
      exact ⟨u, (hb u).symm.trans hu⟩
    have hg := OplaxHistory.guarded_interchange_upgrades_iff_bc S.toFunctor H K
    exact ⟨hg.1.mp hbij, hg.2.mp hbij⟩

/-- **Strict-vs-Guarded Separation Witness (`strict_vs_guarded_separation_witness`):**
Unifying our `EmergentCrossSeamWitness`, `C2RelativeLossWitness`, and `guarded_interchange_upgrades_iff_bc`:
1. Emergent cross-seam history creation refutes surjectivity (`0 → 1`) of `χ` on `EmergentCrossSeamWitness`;
2. `C₂` phase-orbit collapse refutes injectivity (`2 → 1`) of `χ` on `C2RelativeLossWitness`;
3. `Empty`-family BC holds vacuously everywhere despite both failures (`bc_empty_family_trivial_counterexample`);
4. Any `chi` upgrade to a two-sided isomorphism requires & certifies full `FImageIsPullback` and
   all-family Beck–Chevalley (`chi_bijective_iff_pullback` / `chi_bijective_iff_bc_all`), so
   unguarded strict interchange fails where `GuardedProof` stays sound. -/
theorem strict_vs_guarded_separation_witness :
    (¬ OplaxHistory.Surj OplaxHistory.EmergentCrossSeamWitness.chiZeroToOne ∧
     OplaxHistory.Inj OplaxHistory.EmergentCrossSeamWitness.chiZeroToOne ∧
     ¬ OplaxHistory.Surj OplaxHistory.EmergentCrossSeamWitness.chiTwoToFour) ∧
    (¬ OplaxHistory.Inj OplaxHistory.C2RelativeLossWitness.c2ChiTwoToOne ∧
     OplaxHistory.Surj OplaxHistory.C2RelativeLossWitness.c2ChiTwoToOne) ∧
    (∀ (F : OplaxHistory.SpanFunctor) {A D C : Type}
      (H : OplaxHistory.RelSpan A D) (K : OplaxHistory.RelSpan D C) (v : F.obj K.W),
      OplaxHistory.IsBijective (OplaxHistory.bcMap F H K (fun _ => Empty) v)) ∧
    (∀ (F : OplaxHistory.SpanFunctor) {A D C : Type}
      (H : OplaxHistory.RelSpan A D) (K : OplaxHistory.RelSpan D C),
      (OplaxHistory.IsBijective (OplaxHistory.chi F H K).map ↔ OplaxHistory.FImageIsPullback F H K) ∧
      (OplaxHistory.IsBijective (OplaxHistory.chi F H K).map ↔
        ∀ (E : F.obj H.W → Type) (v : F.obj K.W), OplaxHistory.IsBijective (OplaxHistory.bcMap F H K E v))) :=
  ⟨⟨OplaxHistory.EmergentCrossSeamWitness.chiZeroToOne_not_surjective,
    fun e => Empty.elim e,
    OplaxHistory.EmergentCrossSeamWitness.chiTwoToFour_not_surjective⟩,
   OplaxHistory.C2RelativeLossWitness.c2_chi_two_to_one,
   fun F {_ _ _} H K v => OplaxHistory.bc_empty_family_trivial_counterexample F H K v,
   fun F {_ _ _} H K => OplaxHistory.guarded_interchange_upgrades_iff_bc F H K⟩

end DoubleKernel

end Becoming
