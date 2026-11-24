import Init

/-!
# BecomingSpec Extensions: Oplax Fiberwise Beck–Chevalley & Missing-Lift Targets

AI-written (Track S1, 2026-11-24). `import Init` ONLY, 0 axioms, 0 `.injEq`.
Separates `allFibers` Beck–Chevalley from empty-family vacuity (`E := Empty`) and states
`missingLift` obstructions (`0 → 1`, `2 → 4`, `2 → 1`).
-/

set_option genInjectivity false

namespace BecomingSpec.Extensions

def Inj {A B : Type} (f : A → B) : Prop := ∀ a₁ a₂, f a₁ = f a₂ → a₁ = a₂
def Surj {A B : Type} (f : A → B) : Prop := ∀ b, ∃ a, f a = b
def IsBijective {A B : Type} (f : A → B) : Prop := Inj f ∧ Surj f

structure Span (A B : Type) where
  W : Type
  left : W → A
  right : W → B

structure Pullback {W₁ W₂ D : Type} (r : W₁ → D) (l : W₂ → D) where
  fst : W₁
  snd : W₂
  mid : r fst = l snd

structure Functor where
  obj : Type → Type
  map : {X Y : Type} → (X → Y) → obj X → obj Y
  map_id : ∀ {X : Type} (x : obj X), map (fun a => a) x = x
  map_comp : ∀ {X Y Z : Type} (g : Y → Z) (f : X → Y) (x : obj X),
    map (fun a => g (f a)) x = map g (map f x)
  map_congr : ∀ {X Y : Type} {f g : X → Y}, (∀ a, f a = g a) → ∀ x, map f x = map g x

def chi (F : Functor) {A D C : Type} (H : Span A D) (K : Span D C)
    (u : F.obj (Pullback H.right K.left)) : Pullback (F.map H.right) (F.map K.left) :=
  ⟨F.map Pullback.fst u, F.map Pullback.snd u,
    (F.map_comp H.right Pullback.fst u).symm.trans
      ((F.map_congr (fun z => z.mid) u).trans (F.map_comp K.left Pullback.snd u))⟩

structure BCLeft (F : Functor) {A D C : Type} (H : Span A D) (K : Span D C)
    (E : F.obj H.W → Type) (v : F.obj K.W) where
  u : F.obj (Pullback H.right K.left)
  eqV : F.map Pullback.snd u = v
  val : E (F.map Pullback.fst u)

structure BCRight (F : Functor) {A D C : Type} (H : Span A D) (K : Span D C)
    (E : F.obj H.W → Type) (v : F.obj K.W) where
  w : F.obj H.W
  eqMid : F.map H.right w = F.map K.left v
  val : E w

def bcMap (F : Functor) {A D C : Type} (H : Span A D) (K : Span D C)
    (E : F.obj H.W → Type) (v : F.obj K.W) : BCLeft F H K E v → BCRight F H K E v
  | ⟨u, eqV, val⟩ =>
    ⟨F.map Pullback.fst u, ((chi F H K u).mid).trans (congrArg (F.map K.left) eqV), val⟩

def allFibersTarget : Prop :=
  ∀ (F : Functor) {A D C : Type} (H : Span A D) (K : Span D C),
    (IsBijective (chi F H K) ↔ ∀ (E : F.obj H.W → Type) (v : F.obj K.W), IsBijective (bcMap F H K E v)) ∧
    (∀ v, IsBijective (bcMap F H K (fun _ => Empty) v))

def missingLiftTarget : Prop :=
  (¬ Surj (Empty.elim : Empty → Pullback (fun _ : Unit => ()) (fun _ : Unit => ()))) ∧
  (¬ Surj (fun b : Bool => (b, b))) ∧
  ∃ (U V : Type) (proj : U → V) (K : U → Prop),
    (∃ u₁ u₂ : U, proj u₁ = proj u₂ ∧ K u₁ ∧ ¬ K u₂) ∧
    ∀ Kq : V → Prop, ¬ ((∀ u, K u → Kq (proj u)) ∧ (∀ u, Kq (proj u) → K u))

end BecomingSpec.Extensions
