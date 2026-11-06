import Becoming.Likeness

/-!
# Joining: fragments that join, read through what they join with

A joining relates two fragments to what they join into: in several ways, in one, or in none
(`Joining`). Nothing is assumed of it. It is read here in three ways, each as a frame of the
spine, so that likeness, branching tests and open maps apply to it unchanged.

**Read through partners** (`Joining.frame`), a fragment moves, with a partner on one side, to
what the two join into. A description gives fragments codes, and the joining read through it
joins codes where fragments with those codes join (`Joining.image`). The law: a description
lifts the joining, every joining of codes coming from a joining of the fragments themselves,
exactly where having one code is a bisimulation of the partner frame (`Joining.lifts_iff`); no
premise. Where it lifts, every finite tree of joinings lifts with its own leaves
(`Joining.tree_lifts`) and every branching test survives the description
(`Joining.holds_image_iff`). Two descriptions with one kernel that is a bisimulation are aligned
one to one on the codes they use, and the alignment carries one reading of the joining onto the
other (`Joining.common_structure`). Where the kernel is given as passing the same branching tests,
identifying it with likeness needs each pair to join into listed fragments and excluded middle,
given as the hypothesis `em : ∀ p : Prop, Decided p` (`Joining.FiniteOutcomes.common_structure`).
For a functional joining the frame is determined, and passing the same tests already is likeness,
with no decision (`Joining.common_operation`).

**Read through roles** (`Joining.roleFrame`), fragments and occurrences of joining are places: a
fragment enters an occurrence by the role it holds there, and an occurrence is left by a role.
An open map of joinings keeps the joining and lifts each occurrence at a fixed role
(`Joining.OpenMap`); these are exactly the open maps of the role frames (`Joining.openMap_iff`),
so they keep likeness and every branching test of roles. Two joinings with alike roots, from which
every fragment is reached, have a common refinement: the joining of their alike pairs, whose two
projections are open and cover both (`Joining.common_refinement`), with no finiteness and no
decision. Two open maps from one joining factor through it, and the factor is unique at every
fragment (`Joining.universal_factor`). Reading through roles loses something: where every
fragment takes every role, all fragments are alike in their roles, the map onto the joining of
one fragment with itself is open, and yet a fragment may be unable to join itself
(`Joining.RoleTotal.open_not_pairLifting`, `Joining.RoleTotal.collapse`).

**Read through retained references** (`Joining.retainedFrame`), a configuration keeps every
fragment formed; a move names two of its slots and appends what they join into. Alike
configurations of equally many slots match every course of formation, keeping where they started
and keeping the slots aligned (`Joining.retained_history_matches`). Here a fragment that joins
with itself and one that does not are told apart by one test, and every description exact for
these tests gives them different codes (`Joining.retained_apart`, `Joining.retained_codes_apart`).

`Joining.Once` is the witness: an idle start, an idle finish and one passage between them, which
cannot join itself. Through roles the passage is alike to the idle start; through retained
references the two are apart.

Excluded middle enters only as a named hypothesis, and only to identify passing the same branching
tests with likeness (through `alike_of_sameBranchingTests_of_em` of `Becoming.Likeness`). The
uniqueness of the factor is stated at every fragment rather than as an equality of functions.
The readings of these results are the AI's, adopted on Ren's delegation of 15 October 2026
(DELEGATED-CHOICES D33). No ethical predicate is used.

The associativity of appending, `ListTests.append_assoc`, is in `Becoming.Prelude`, so the modules
using it do not import the frame (board item W).
-/

namespace Becoming

open Generative

universe u v w u' v'

/-- A joining: fragments `x` and `y` join into `z`, in several ways, in one or in none. -/
abbrev Joining (F : Type u) : Type u := F → F → F → Prop

/-- A bisimulation stays one under a relation holding at the same pairs. -/
theorem Bisimulation.of_iff {S : Type u} {S' : Type u'} {A : Type v} {C : Type w}
    {F : Frame S A C} {G : Frame S' A C} {B B' : S → S' → Prop}
    (bisim : Bisimulation F G B) (same : ∀ s s', B s s' ↔ B' s s') : Bisimulation F G B' :=
  fun s s' related => match bisim s s' ((same s s').mpr related) with
    | ⟨claims, forth, back⟩ =>
      ⟨claims,
       fun a t step => match forth a t step with
         | ⟨t', step', joined⟩ => ⟨t', step', (same t t').mp joined⟩,
       fun a t' step' => match back a t' step' with
         | ⟨t, step, joined⟩ => ⟨t, step, (same t t').mp joined⟩⟩

/-! ## Two descriptions with one kernel -/

section Aligned

variable {F : Type u} {K : Type u'} {K' : Type v'}

/-- A code some fragment has under the description. -/
def Used (π : F → K) (k : K) : Prop := ∃ x, π x = k

/-- Codes of two descriptions aligned by a fragment that has both. -/
def Aligned (π : F → K) (ρ : F → K') (k : K) (k' : K') : Prop := ∃ x, π x = k ∧ ρ x = k'

/-- Where the second description identifies whatever the first does, a code of the first is
aligned with at most one code of the second. -/
theorem Aligned.functional {π : F → K} {ρ : F → K'} (keeps : ∀ x y, π x = π y → ρ x = ρ y)
    {k : K} {k₁ k₂ : K'} : Aligned π ρ k k₁ → Aligned π ρ k k₂ → k₁ = k₂
  | ⟨x, at_x, to_x⟩, ⟨y, at_y, to_y⟩ => to_x.symm.trans ((keeps x y (at_x.trans at_y.symm)).trans to_y)

/-- **Descriptions with one kernel are aligned one to one on the codes they use.** Each used code
of either is aligned with exactly one code of the other. -/
theorem aligned_one_to_one {π : F → K} {ρ : F → K'} (same : ∀ x y, π x = π y ↔ ρ x = ρ y) :
    (∀ k, Used π k → ∃ k', Aligned π ρ k k' ∧ ∀ k'', Aligned π ρ k k'' → k'' = k') ∧
      (∀ k', Used ρ k' → ∃ k, Aligned π ρ k k' ∧ ∀ k₀, Aligned π ρ k₀ k' → k₀ = k) :=
  ⟨fun _ ⟨x, at_x⟩ =>
    ⟨ρ x, ⟨x, at_x, rfl⟩, fun _ other =>
      Aligned.functional (fun y z => (same y z).mp) other ⟨x, at_x, rfl⟩⟩,
   fun _ ⟨x, at_x⟩ =>
    ⟨π x, ⟨x, rfl, at_x⟩, fun _ ⟨y, at_y, to_y⟩ =>
      at_y.symm.trans ((same y x).mpr (to_y.trans at_x.symm))⟩⟩

end Aligned

/-! ## Open maps of frames -/

section OpenMaps

variable {S : Type u} {S' : Type u'} {S'' : Type v'} {A : Type v} {C : Type w}

/-- An open map of frames: a map of configurations whose graph is a bisimulation (a functional
bisimulation, or p-morphism). -/
def OpenMap (F : Frame S A C) (G : Frame S' A C) (f : S → S') : Prop :=
  Bisimulation F G fun s s' => f s = s'

/-- **A map is open exactly where it keeps the claims, carries every step to a step, and every
step from an image lifts to a step onto it.** -/
theorem openMap_iff {F : Frame S A C} {G : Frame S' A C} {f : S → S'} :
    OpenMap F G f ↔ (∀ s c, F.realized s c ↔ G.realized (f s) c) ∧
      (∀ s a t, F.P.step s a t → G.P.step (f s) a (f t)) ∧
      (∀ s a t', G.P.step (f s) a t' → ∃ t, F.P.step s a t ∧ f t = t') :=
  ⟨fun opens =>
    ⟨fun s => (opens s (f s) rfl).1,
     fun s a t step => match (opens s (f s) rfl).2.1 a t step with
       | ⟨_, step', same⟩ => Eq.subst (motive := fun x => G.P.step (f s) a x) same.symm step',
     fun s a t' step' => (opens s (f s) rfl).2.2 a t' step'⟩,
   fun ⟨claims, forth, back⟩ s _ same => by
    subst same
    exact ⟨claims s, fun a t step => ⟨f t, forth s a t step, rfl⟩, fun a t' step' => back s a t' step'⟩⟩

/-- A configuration is alike to its image under an open map. -/
theorem OpenMap.alike {F : Frame S A C} {G : Frame S' A C} {f : S → S'} (opens : OpenMap F G f)
    (s : S) : Alike F G s (f s) :=
  ⟨_, opens, rfl⟩

/-- **An open map keeps and reflects likeness.** -/
theorem OpenMap.alike_iff {F : Frame S A C} {G : Frame S' A C} {f : S → S'} (opens : OpenMap F G f)
    {s s' : S} : Alike F F s s' ↔ Alike G G (f s) (f s') :=
  ⟨fun alike => (opens.alike s).symm.trans (alike.trans (opens.alike s')),
   fun alike => (opens.alike s).trans (alike.trans (opens.alike s').symm)⟩

/-- Open maps compose. -/
theorem OpenMap.comp {F : Frame S A C} {G : Frame S' A C} {H : Frame S'' A C} {f : S → S'}
    {g : S' → S''} (first : OpenMap F G f) (second : OpenMap G H g) :
    OpenMap F H fun s => g (f s) :=
  match openMap_iff.mp first, openMap_iff.mp second with
  | ⟨claims, forth, back⟩, ⟨claims', forth', back'⟩ =>
    openMap_iff.mpr
      ⟨fun s c => (claims s c).trans (claims' (f s) c),
       fun s a t step => forth' (f s) a (f t) (forth s a t step),
       fun s a t'' step'' => match back' (f s) a t'' step'' with
         | ⟨t', step', at_t'⟩ => match back s a t' step' with
           | ⟨t, step, at_t⟩ => ⟨t, step, (congrArg g at_t).trans at_t'⟩⟩

end OpenMaps

namespace Joining

variable {F : Type u} {G : Type v} {K : Type u'} {K' : Type v'}

/-! ## The frame of a joining -/

/-- A move of a fragment within a joining: joining a partner on its left or on its right. -/
inductive Move (F : Type u) where
  | withLeft (p : F)
  | withRight (p : F)

/-- Joining by a move: `x` joined with `p` on its left is `J p x z`, on its right `J x p z`. -/
def Move.Joins (J : Joining F) : F → Move F → F → Prop
  | x, .withLeft p, z => J p x z
  | x, .withRight p, z => J x p z

/-- The partner of a move read through a description. -/
def Move.map (π : F → K) : Move F → Move K
  | .withLeft p => .withLeft (π p)
  | .withRight p => .withRight (π p)

/-- The frame of a joining: from a fragment, joining a partner on either side is a move and the
fragments joined into are its outcomes. Nothing is claimed beside the joining. -/
def frame (J : Joining F) : Frame F (Move F) Empty :=
  ⟨⟨Move.Joins J⟩, fun _ c => nomatch c⟩

/-- A relation compatible with a joining: related fragments joined with one partner on one side
give related results, either way. -/
def Compatible (J : Joining F) (B : F → F → Prop) : Prop :=
  ∀ x y, B x y → ∀ p,
    (∀ z, J p x z → ∃ w, J p y w ∧ B z w) ∧ (∀ w, J p y w → ∃ z, J p x z ∧ B z w) ∧
    (∀ z, J x p z → ∃ w, J y p w ∧ B z w) ∧ (∀ w, J y p w → ∃ z, J x p z ∧ B z w)

/-- **The bisimulations of a joining's frame are the relations compatible with the joining.** -/
theorem bisimulation_iff_compatible {J : Joining F} {B : F → F → Prop} :
    Bisimulation J.frame J.frame B ↔ J.Compatible B :=
  ⟨fun bisim x y related p =>
    ⟨fun z joined => (bisim x y related).2.1 (.withLeft p) z joined,
     fun w joined => (bisim x y related).2.2 (.withLeft p) w joined,
     fun z joined => (bisim x y related).2.1 (.withRight p) z joined,
     fun w joined => (bisim x y related).2.2 (.withRight p) w joined⟩,
   fun compatible x y related =>
    ⟨fun c => (nomatch c),
     fun m z joined => match m, joined with
       | .withLeft p, joined => (compatible x y related p).1 z joined
       | .withRight p, joined => (compatible x y related p).2.2.1 z joined,
     fun m w joined => match m, joined with
       | .withLeft p, joined => (compatible x y related p).2.1 w joined
       | .withRight p, joined => (compatible x y related p).2.2.2 w joined⟩⟩

/-- **Both inputs of a joining can be replaced by related ones.** Under a bisimulation of the
joining's frame, a joining of `a` and `b` into `z` is matched by a joining of fragments related to
them into a fragment related to `z` through one intermediate result. -/
theorem substitute {J : Joining F} {B : F → F → Prop} (bisim : Bisimulation J.frame J.frame B)
    {a a' b b' z : F} (ha : B a a') (hb : B b b') (joined : J a b z) :
    ∃ w z', J a' b' z' ∧ B z w ∧ B w z' :=
  match (bisim a a' ha).2.1 (.withRight b) z joined with
  | ⟨w, joined', zw⟩ => match (bisim b b' hb).2.1 (.withLeft a') w joined' with
    | ⟨z', joined'', wz'⟩ => ⟨w, z', joined'', zw, wz'⟩

/-- **Alike fragments join alike.** A joining of `a` and `b` into `z` is matched, for any fragments
alike to them, by a joining into a fragment alike to `z`. No premise. -/
theorem alike_substitute {J : Joining F} {a a' b b' z : F} (ha : Alike J.frame J.frame a a')
    (hb : Alike J.frame J.frame b b') (joined : J a b z) :
    ∃ z', J a' b' z' ∧ Alike J.frame J.frame z z' :=
  match ha.step (a := .withRight b) joined with
  | ⟨_, joined', zw⟩ => match hb.step (a := .withLeft a') joined' with
    | ⟨z', joined'', wz'⟩ => ⟨z', joined'', zw.trans wz'⟩

/-! ## A joining read through a description -/

/-- The joining read through a description: codes `a` and `b` join into `c` where fragments with
those codes join into one with code `c`. -/
def image (J : Joining F) (π : F → K) : Joining K :=
  fun a b c => ∃ x y z, π x = a ∧ π y = b ∧ π z = c ∧ J x y z

/-- A joining of fragments is a joining of their codes. -/
theorem image_of (J : Joining F) (π : F → K) {x y z : F} (joined : J x y z) :
    J.image π (π x) (π y) (π z) :=
  ⟨x, y, z, rfl, rfl, rfl, joined⟩

/-- The description lifts the joining: every joining of the codes of `x` and `y` comes from a
joining of `x` and `y` themselves. -/
def Lifts (J : Joining F) (π : F → K) : Prop :=
  ∀ x y c, J.image π (π x) (π y) c → ∃ z, J x y z ∧ π z = c

/-- **A description lifts a joining exactly where fragments with one code relate alike**: the
relation of having one code is a bisimulation of the joining's frame. No premise. -/
theorem lifts_iff {J : Joining F} {π : F → K} :
    J.Lifts π ↔ Bisimulation J.frame J.frame (fun x y => π x = π y) :=
  ⟨fun lifts x y same =>
    ⟨fun c => (nomatch c),
     fun m z joined => match m, joined with
       | .withLeft p, joined => match lifts p y (π z) ⟨p, x, z, rfl, same, rfl, joined⟩ with
         | ⟨w, joined', code⟩ => ⟨w, joined', code.symm⟩
       | .withRight p, joined => match lifts y p (π z) ⟨x, p, z, same, rfl, rfl, joined⟩ with
         | ⟨w, joined', code⟩ => ⟨w, joined', code.symm⟩,
     fun m w joined => match m, joined with
       | .withLeft p, joined => match lifts p x (π w) ⟨p, y, w, rfl, same.symm, rfl, joined⟩ with
         | ⟨z, joined', code⟩ => ⟨z, joined', code⟩
       | .withRight p, joined => match lifts x p (π w) ⟨y, p, w, same.symm, rfl, rfl, joined⟩ with
         | ⟨z, joined', code⟩ => ⟨z, joined', code⟩⟩,
   fun bisim _ _ _ ⟨_, _, _, at_a, at_b, at_d, joined⟩ =>
    match substitute bisim at_a at_b joined with
    | ⟨_, z, joined', dw, wz⟩ => ⟨z, joined', (dw.trans wz).symm.trans at_d⟩⟩

/-- **Where a description lifts a joining, a joining of codes is exactly the code of a joining of
any fragments having them.** -/
theorem image_iff {J : Joining F} {π : F → K} (lifts : J.Lifts π) (x y : F) (c : K) :
    J.image π (π x) (π y) c ↔ ∃ z, J x y z ∧ π z = c :=
  ⟨lifts x y c, fun ⟨z, joined, code⟩ => ⟨x, y, z, rfl, rfl, code, joined⟩⟩

/-- A description that makes sense of a joining's frame lifts the joining. -/
theorem lifts_of_identifiesAlike {J : Joining F} {π : F → K}
    (sense : IdentifiesAlike J.frame π) : J.Lifts π :=
  lifts_iff.mpr (identifiesAlike_iff.mp sense).1

/-- **Where codes are passing the same branching tests, a description lifts the joining exactly
where passing the same branching tests is a bisimulation of the joining's frame.** -/
theorem lifts_iff_sameBranchingTests {J : Joining F} {π : F → K}
    (kernel : ∀ x y, π x = π y ↔ SameBranchingTests J.frame J.frame x y) :
    J.Lifts π ↔ Bisimulation J.frame J.frame (SameBranchingTests J.frame J.frame) :=
  ⟨fun lifts => (lifts_iff.mp lifts).of_iff kernel,
   fun bisim => lifts_iff.mpr (bisim.of_iff fun x y => (kernel x y).symm)⟩

/-- Where codes are aligned by fragments described both ways and the descriptions have one
kernel, the two readings of the joining agree. -/
theorem aligned_image_iff {J : Joining F} {π : F → K} {ρ : F → K'}
    (same : ∀ x y, π x = π y ↔ ρ x = ρ y) {a b c : K} {a' b' c' : K'}
    (ha : Aligned π ρ a a') (hb : Aligned π ρ b b') (hc : Aligned π ρ c c') :
    J.image π a b c ↔ J.image ρ a' b' c' :=
  match ha, hb, hc with
  | ⟨x₀, at_x, to_x⟩, ⟨y₀, at_y, to_y⟩, ⟨z₀, at_z, to_z⟩ =>
    ⟨fun ⟨x, y, z, cx, cy, cz, joined⟩ =>
      ⟨x, y, z, ((same x x₀).mp (cx.trans at_x.symm)).trans to_x,
        ((same y y₀).mp (cy.trans at_y.symm)).trans to_y,
        ((same z z₀).mp (cz.trans at_z.symm)).trans to_z, joined⟩,
     fun ⟨x, y, z, cx, cy, cz, joined⟩ =>
      ⟨x, y, z, ((same x x₀).mpr (cx.trans to_x.symm)).trans at_x,
        ((same y y₀).mpr (cy.trans to_y.symm)).trans at_y,
        ((same z z₀).mpr (cz.trans to_z.symm)).trans at_z, joined⟩⟩

/-- **The common structure of two descriptions with one kernel that relates alike.** Each lifts
the joining, they are aligned one to one on their used codes, and the alignment carries the one
reading of the joining onto the other. No premise beyond the two named. -/
theorem common_structure {J : Joining F} {π : F → K} {ρ : F → K'}
    (bisim : Bisimulation J.frame J.frame (fun x y => π x = π y))
    (same : ∀ x y, π x = π y ↔ ρ x = ρ y) :
    (∀ x y c, J.image π (π x) (π y) c ↔ ∃ z, J x y z ∧ π z = c) ∧
    (∀ x y c, J.image ρ (ρ x) (ρ y) c ↔ ∃ z, J x y z ∧ ρ z = c) ∧
    (∀ k, Used π k → ∃ k', Aligned π ρ k k' ∧ ∀ k'', Aligned π ρ k k'' → k'' = k') ∧
    (∀ k', Used ρ k' → ∃ k, Aligned π ρ k k' ∧ ∀ k₀, Aligned π ρ k₀ k' → k₀ = k) ∧
    (∀ a b c a' b' c', Aligned π ρ a a' → Aligned π ρ b b' → Aligned π ρ c c' →
      (J.image π a b c ↔ J.image ρ a' b' c')) :=
  ⟨image_iff (lifts_iff.mpr bisim),
   image_iff (lifts_iff.mpr (bisim.of_iff same)),
   (aligned_one_to_one same).1, (aligned_one_to_one same).2,
   fun _ _ _ _ _ _ ha hb hc => aligned_image_iff same ha hb hc⟩

/-- Two descriptions that make sense of a joining's frame have the common structure. -/
theorem common_structure_of_identifiesAlike {J : Joining F} {π : F → K} {ρ : F → K'}
    (sense : IdentifiesAlike J.frame π) (sense' : IdentifiesAlike J.frame ρ) :
    (∀ x y c, J.image π (π x) (π y) c ↔ ∃ z, J x y z ∧ π z = c) ∧
    (∀ x y c, J.image ρ (ρ x) (ρ y) c ↔ ∃ z, J x y z ∧ ρ z = c) ∧
    (∀ k, Used π k → ∃ k', Aligned π ρ k k' ∧ ∀ k'', Aligned π ρ k k'' → k'' = k') ∧
    (∀ k', Used ρ k' → ∃ k, Aligned π ρ k k' ∧ ∀ k₀, Aligned π ρ k₀ k' → k₀ = k) ∧
    (∀ a b c a' b' c', Aligned π ρ a a' → Aligned π ρ b b' → Aligned π ρ c c' →
      (J.image π a b c ↔ J.image ρ a' b' c')) :=
  common_structure (identifiesAlike_iff.mp sense).1 (IdentifiesAlike.unique sense sense')

/-! ## Branching tests and likeness where each pair joins into listed fragments -/

/-- Each pair of fragments joins into a listed set of fragments. -/
def FiniteOutcomes (J : Joining F) : Prop := ∀ x y, ∃ zs : List F, ∀ z, J x y z ↔ z ∈ zs

/-- Where each pair joins into listed fragments, each move of the joining's frame has listed
outcomes. -/
theorem FiniteOutcomes.outcomes {J : Joining F} (finite : J.FiniteOutcomes) :
    ∀ x m, ∃ l : List F, ∀ z, J.frame.P.step x m z ↔ z ∈ l
  | x, .withLeft p => finite p x
  | x, .withRight p => finite x p

/-- **Under excluded middle, fragments of a joining whose pairs join into listed fragments are
alike exactly where they pass the same branching tests** (`alike_iff_sameBranchingTests_of_em` of
`Becoming.Likeness`). -/
theorem FiniteOutcomes.alike_iff_sameBranchingTests (em : ∀ p : Prop, Decided p)
    {J : Joining F} (finite : J.FiniteOutcomes) {x y : F} :
    Alike J.frame J.frame x y ↔ SameBranchingTests J.frame J.frame x y :=
  ⟨Alike.sameBranchingTests, alike_of_sameBranchingTests_of_em em finite.outcomes finite.outcomes⟩

/-- Under excluded middle, a description whose codes are passing the same branching tests makes
sense of the frame of a joining whose pairs join into listed fragments. -/
theorem FiniteOutcomes.identifiesAlike (em : ∀ p : Prop, Decided p) {J : Joining F}
    (finite : J.FiniteOutcomes) {π : F → K}
    (kernel : ∀ x y, π x = π y ↔ SameBranchingTests J.frame J.frame x y) :
    IdentifiesAlike J.frame π :=
  fun x y => (kernel x y).trans (finite.alike_iff_sameBranchingTests em).symm

/-- **The common structure of two descriptions whose codes are passing the same branching tests,
for a joining whose pairs join into listed fragments, under excluded middle.** Each lifts the
joining, they are aligned one to one on their used codes, and the alignment carries one reading of
the joining onto the other. The joining may have several outcomes. -/
theorem FiniteOutcomes.common_structure (em : ∀ p : Prop, Decided p) {J : Joining F}
    (finite : J.FiniteOutcomes) {π : F → K} {ρ : F → K'}
    (kernel : ∀ x y, π x = π y ↔ SameBranchingTests J.frame J.frame x y)
    (kernel' : ∀ x y, ρ x = ρ y ↔ SameBranchingTests J.frame J.frame x y) :
    (∀ x y c, J.image π (π x) (π y) c ↔ ∃ z, J x y z ∧ π z = c) ∧
    (∀ x y c, J.image ρ (ρ x) (ρ y) c ↔ ∃ z, J x y z ∧ ρ z = c) ∧
    (∀ k, Used π k → ∃ k', Aligned π ρ k k' ∧ ∀ k'', Aligned π ρ k k'' → k'' = k') ∧
    (∀ k', Used ρ k' → ∃ k, Aligned π ρ k k' ∧ ∀ k₀, Aligned π ρ k₀ k' → k₀ = k) ∧
    (∀ a b c a' b' c', Aligned π ρ a a' → Aligned π ρ b b' → Aligned π ρ c c' →
      (J.image π a b c ↔ J.image ρ a' b' c')) :=
  common_structure_of_identifiesAlike (finite.identifiesAlike em kernel)
    (finite.identifiesAlike em kernel')

/-! ## Joining at most one way -/

/-- A joining is functional where two fragments join into at most one. -/
def Functional (J : Joining F) : Prop := ∀ a b c d, J a b c → J a b d → c = d

/-- The frame of a functional joining is determined. -/
theorem Functional.determined {J : Joining F} (fn : J.Functional) : Determined J.frame.P :=
  fun x m z z' joined joined' => match m, joined, joined' with
    | .withLeft p, joined, joined' => fn p x z z' joined joined'
    | .withRight p, joined, joined' => fn x p z z' joined joined'

/-- **A description lifting a functional joining reads a functional joining.** -/
theorem Lifts.functional {J : Joining F} {π : F → K} (lifts : J.Lifts π) (fn : J.Functional) :
    (J.image π).Functional := by
  intro a b c d first second
  obtain ⟨x, y, z, at_x, at_y, at_z, joined⟩ := first
  subst at_x
  subst at_y
  obtain ⟨z', joined', at_z'⟩ := lifts x y d second
  exact at_z.symm.trans ((congrArg π (fn x y z z' joined joined')).trans at_z')

/-- **Two descriptions of a functional joining whose codes are passing the same tests.** For a
functional joining, codes identifying exactly the fragments that pass the same tests (courses of
joinings open from each) read functional joinings, are aligned one to one on their used codes,
and the alignment carries one reading onto the other. No premise beyond the three named. -/
theorem common_operation {J : Joining F} {π : F → K} {ρ : F → K'} (fn : J.Functional)
    (sense : ∀ x y, π x = π y ↔ SameTests J.frame J.frame x y)
    (sense' : ∀ x y, ρ x = ρ y ↔ SameTests J.frame J.frame x y) :
    (J.image π).Functional ∧ (J.image ρ).Functional ∧
    (∀ k, Used π k → ∃ k', Aligned π ρ k k' ∧ ∀ k'', Aligned π ρ k k'' → k'' = k') ∧
    (∀ k', Used ρ k' → ∃ k, Aligned π ρ k k' ∧ ∀ k₀, Aligned π ρ k₀ k' → k₀ = k) ∧
    (∀ a b c a' b' c', Aligned π ρ a a' → Aligned π ρ b b' → Aligned π ρ c c' →
      (J.image π a b c ↔ J.image ρ a' b' c')) :=
  have identifies : IdentifiesAlike J.frame π := fun x y =>
    (sense x y).trans (Determined.alike_iff_sameTests fn.determined).symm
  have identifies' : IdentifiesAlike J.frame ρ := fun x y =>
    (sense' x y).trans (Determined.alike_iff_sameTests fn.determined).symm
  match common_structure_of_identifiesAlike identifies identifies' with
  | ⟨_, _, forth, back, carries⟩ =>
    ⟨(lifts_of_identifiesAlike identifies).functional fn,
     (lifts_of_identifiesAlike identifies').functional fn, forth, back, carries⟩

/-! ## Branching tests read through a description -/

/-- A branching test with its partners read through a description. -/
def mapPartners {C : Type w} (π : F → K) : BranchingTest (Move F) C → BranchingTest (Move K) C
  | .top => .top
  | .claim c => .claim c
  | .not φ => .not (mapPartners π φ)
  | .both φ ψ => .both (mapPartners π φ) (mapPartners π ψ)
  | .can m φ => .can (m.map π) (mapPartners π φ)

/-- **Where a description lifts a joining, every branching test survives it**: a test with its
partners read through the description holds at a fragment's code in the joining read through the
description exactly where the test holds at the fragment. -/
theorem holds_image_iff {J : Joining F} {π : F → K} (lifts : J.Lifts π) :
    ∀ (φ : BranchingTest (Move F) Empty) (x : F),
      BranchingTest.Holds (J.image π).frame (π x) (mapPartners π φ) ↔
        BranchingTest.Holds J.frame x φ
  | .top, _ => Iff.rfl
  | .claim c, _ => nomatch c
  | .not φ, x =>
    ⟨fun fails holds => fails ((holds_image_iff lifts φ x).mpr holds),
     fun fails holds => fails ((holds_image_iff lifts φ x).mp holds)⟩
  | .both φ ψ, x =>
    ⟨fun ⟨first, second⟩ => ⟨(holds_image_iff lifts φ x).mp first, (holds_image_iff lifts ψ x).mp second⟩,
     fun ⟨first, second⟩ =>
      ⟨(holds_image_iff lifts φ x).mpr first, (holds_image_iff lifts ψ x).mpr second⟩⟩
  | .can (.withLeft p) φ, x =>
    ⟨fun ⟨c, joined, holds⟩ => match lifts p x c joined with
      | ⟨z, joined', code⟩ => ⟨z, joined', (holds_image_iff lifts φ z).mp
          (Eq.subst (motive := fun k => BranchingTest.Holds (J.image π).frame k (mapPartners π φ))
            code.symm holds)⟩,
     fun ⟨z, joined, holds⟩ => ⟨π z, image_of J π joined, (holds_image_iff lifts φ z).mpr holds⟩⟩
  | .can (.withRight p) φ, x =>
    ⟨fun ⟨c, joined, holds⟩ => match lifts x p c joined with
      | ⟨z, joined', code⟩ => ⟨z, joined', (holds_image_iff lifts φ z).mp
          (Eq.subst (motive := fun k => BranchingTest.Holds (J.image π).frame k (mapPartners π φ))
            code.symm holds)⟩,
     fun ⟨z, joined, holds⟩ => ⟨π z, image_of J π joined, (holds_image_iff lifts φ z).mpr holds⟩⟩

/-! ## Finite joining trees -/

/-- A finite binary arrangement of joinings with given fragments at its leaves. -/
inductive Tree (F : Type u) where
  | leaf (x : F)
  | join (l r : Tree F)

/-- A tree with its leaves read through a description. -/
def Tree.map (π : F → K) : Tree F → Tree K
  | .leaf x => .leaf (π x)
  | .join l r => .join (l.map π) (r.map π)

/-- What a tree can join into: a leaf is its fragment; a join joins what its two sides join into. -/
def Tree.Realizes (J : Joining F) : Tree F → F → Prop
  | .leaf x, z => z = x
  | .join l r, z => ∃ x y, l.Realizes J x ∧ r.Realizes J y ∧ J x y z

/-- **Where a description lifts a joining, every finite joining tree lifts**: the tree with its
leaves read through the description joins into a code exactly where the tree with its own leaves
joins into a fragment with that code. The leaves stay the given fragments throughout. -/
theorem tree_lifts {J : Joining F} {π : F → K} (lifts : J.Lifts π) :
    ∀ (t : Tree F) (c : K), (t.map π).Realizes (J.image π) c ↔ ∃ z, t.Realizes J z ∧ π z = c
  | .leaf x, c => ⟨fun at_c => ⟨x, rfl, at_c.symm⟩, fun ⟨_, at_z, code⟩ => code.symm.trans (congrArg π at_z)⟩
  | .join l r, c =>
    ⟨fun ⟨a, b, left, right, joined⟩ => match (tree_lifts lifts l a).mp left, (tree_lifts lifts r b).mp right with
      | ⟨x, left', at_x⟩, ⟨y, right', at_y⟩ => by
        subst at_x
        subst at_y
        exact match lifts x y c joined with
          | ⟨z, joined', code⟩ => ⟨z, ⟨x, y, left', right', joined'⟩, code⟩,
     fun ⟨z, ⟨x, y, left, right, joined⟩, code⟩ =>
      ⟨π x, π y, (tree_lifts lifts l (π x)).mpr ⟨x, left, rfl⟩,
        (tree_lifts lifts r (π y)).mpr ⟨y, right, rfl⟩, ⟨x, y, z, rfl, rfl, code, joined⟩⟩⟩

/-! ## The joining read through roles -/

/-- The three places of a joining: the two joined and the one joined into. -/
inductive Role where
  | first
  | second
  | result

/-- One joining that takes place: two fragments and one they join into. -/
structure Occurrence (J : Joining F) where
  first : F
  second : F
  result : F
  formed : J first second result

/-- The fragment holding a role in an occurrence. -/
def Occurrence.at {J : Joining F} (e : Occurrence J) : Role → F
  | .first => e.first
  | .second => e.second
  | .result => e.result

/-- Occurrences holding the same fragments in every role are one. -/
theorem Occurrence.ext_at {J : Joining F} :
    ∀ {d e : Occurrence J}, (∀ i, d.at i = e.at i) → d = e
  | ⟨a, b, c, _⟩, ⟨a', b', c', _⟩, same => by
    have first : a = a' := same .first
    have second : b = b' := same .second
    have result : c = c' := same .result
    subst first
    subst second
    subst result
    rfl

/-- A move in the reading through roles: entering an occurrence in a role, or leaving one by a
role. -/
inductive RoleMove where
  | enter (r : Role)
  | leave (r : Role)

/-- A step in the reading through roles: a fragment enters an occurrence in a role it holds
there, and an occurrence leaves by a role to the fragment holding it. -/
def Incident (J : Joining F) : F ⊕ Occurrence J → RoleMove → F ⊕ Occurrence J → Prop
  | .inl x, .enter r, .inr e => e.at r = x
  | .inr e, .leave r, .inl x => x = e.at r
  | .inl _, .enter _, .inl _ => False
  | .inl _, .leave _, _ => False
  | .inr _, .enter _, _ => False
  | .inr _, .leave _, .inr _ => False

/-- The joining read through roles: fragments and occurrences, related only by which fragment
holds which role in which occurrence. No fragment is named to another; nothing is claimed. -/
def roleFrame (J : Joining F) : Frame (F ⊕ Occurrence J) RoleMove Empty :=
  ⟨⟨Incident J⟩, fun _ c => nomatch c⟩

/-- A fragment and an occurrence are never alike: the occurrence can leave by a role. -/
theorem fragment_not_alike_occurrence {J : Joining F} {K : Joining G} (x : F) (f : Occurrence K) :
    ¬ Alike J.roleFrame K.roleFrame (.inl x) (.inr f) :=
  fun alike => match alike.symm.step (a := .leave .first) (t := .inl (f.at .first)) rfl with
    | ⟨.inl _, step, _⟩ => nomatch step
    | ⟨.inr _, step, _⟩ => nomatch step

/-- Alike occurrences hold alike fragments in every role. -/
theorem slots_alike {J : Joining F} {K : Joining G} {e : Occurrence J} {f : Occurrence K}
    (alike : Alike J.roleFrame K.roleFrame (.inr e) (.inr f)) (i : Role) :
    Alike J.roleFrame K.roleFrame (.inl (e.at i)) (.inl (f.at i)) :=
  match alike.step (a := .leave i) (t := .inl (e.at i)) rfl with
  | ⟨.inl _, at_i, joined⟩ => Eq.subst (motive := fun y => Alike J.roleFrame K.roleFrame
      (.inl (e.at i)) (.inl y)) (at_i : _ = f.at i) joined
  | ⟨.inr _, step, _⟩ => nomatch step

/-- **An occurrence at a fragment is matched, at any alike fragment, by an occurrence holding alike
fragments in every role.** No premise. -/
theorem match_incident {J : Joining F} {K : Joining G} {x : F} {y : G}
    (alike : Alike J.roleFrame K.roleFrame (.inl x) (.inl y)) (e : Occurrence J) (r : Role)
    (at_r : e.at r = x) :
    ∃ f : Occurrence K, f.at r = y ∧ ∀ i, Alike J.roleFrame K.roleFrame (.inl (e.at i)) (.inl (f.at i)) :=
  match alike.step (a := .enter r) (t := .inr e) at_r with
  | ⟨.inr f, at_f, joined⟩ => ⟨f, at_f, slots_alike joined⟩
  | ⟨.inl _, step, _⟩ => nomatch step

/-! ### Open maps of joinings -/

/-- A map keeping a joining: fragments joined into one are mapped to fragments joined into its
image. -/
def Keeps (J : Joining F) (K : Joining G) (p : F → G) : Prop :=
  ∀ a b c, J a b c → K (p a) (p b) (p c)

/-- An open map of joinings: it keeps the joining, and every occurrence of `K` holding the image
of `x` in a role lifts to an occurrence of `J` holding `x` in that role and mapped onto it role by
role. -/
def OpenMap (J : Joining F) (K : Joining G) (p : F → G) : Prop :=
  J.Keeps K p ∧ ∀ x (e : Occurrence K) r, e.at r = p x →
    ∃ d : Occurrence J, d.at r = x ∧ ∀ i, p (d.at i) = e.at i

/-- An occurrence read through a map keeping the joining. -/
def Occurrence.map {J : Joining F} {K : Joining G} {p : F → G} (keeps : J.Keeps K p)
    (d : Occurrence J) : Occurrence K :=
  ⟨p d.first, p d.second, p d.result, keeps _ _ _ d.formed⟩

theorem Occurrence.map_at {J : Joining F} {K : Joining G} {p : F → G} (keeps : J.Keeps K p)
    (d : Occurrence J) : ∀ i, (d.map keeps).at i = p (d.at i)
  | .first => rfl
  | .second => rfl
  | .result => rfl

/-- Fragments and occurrences read through a map keeping the joining. -/
def placeMap {J : Joining F} {K : Joining G} {p : F → G} (keeps : J.Keeps K p) :
    F ⊕ Occurrence J → G ⊕ Occurrence K
  | .inl x => .inl (p x)
  | .inr d => .inr (d.map keeps)

/-- **An open map of joinings is exactly a map keeping the joining whose reading through roles is
an open map of frames.** -/
theorem openMap_iff {J : Joining F} {K : Joining G} {p : F → G} :
    J.OpenMap K p ↔ ∃ keeps : J.Keeps K p, Becoming.OpenMap J.roleFrame K.roleFrame (placeMap keeps) :=
  ⟨fun ⟨keeps, lifting⟩ =>
    ⟨keeps, Becoming.openMap_iff.mpr
      ⟨fun _ c => (nomatch c),
       fun s m t step => match s, m, t, step with
         | .inl _, .enter r, .inr d, at_r => (d.map_at keeps r).trans (congrArg p at_r)
         | .inr d, .leave r, .inl _, at_r => (congrArg p at_r).trans (d.map_at keeps r).symm
         | .inl _, .enter _, .inl _, step => nomatch step
         | .inl _, .leave _, .inl _, step => nomatch step
         | .inl _, .leave _, .inr _, step => nomatch step
         | .inr _, .enter _, .inl _, step => nomatch step
         | .inr _, .enter _, .inr _, step => nomatch step
         | .inr _, .leave _, .inr _, step => (nomatch step),
       fun s m t' step' => match s, m, t', step' with
         | .inl x, .enter r, .inr e, at_r => match lifting x e r at_r with
           | ⟨d, at_d, mapped⟩ => ⟨.inr d, at_d, congrArg Sum.inr (Occurrence.ext_at fun i =>
               (d.map_at keeps i).trans (mapped i))⟩
         | .inr d, .leave r, .inl _, at_r =>
           ⟨.inl (d.at r), rfl, congrArg Sum.inl ((d.map_at keeps r).symm.trans at_r.symm)⟩
         | .inl _, .enter _, .inl _, step => nomatch step
         | .inl _, .leave _, .inl _, step => nomatch step
         | .inl _, .leave _, .inr _, step => nomatch step
         | .inr _, .enter _, .inl _, step => nomatch step
         | .inr _, .enter _, .inr _, step => nomatch step
         | .inr _, .leave _, .inr _, step => nomatch step⟩⟩,
   fun ⟨keeps, opens⟩ =>
    ⟨keeps, fun x e r at_r => match (Becoming.openMap_iff.mp opens).2.2 (.inl x) (.enter r) (.inr e) at_r with
      | ⟨.inr d, at_d, same⟩ => ⟨d, at_d, fun i => (d.map_at keeps i).symm.trans
          (congrArg (fun q => Occurrence.at q i) (Sum.inr.inj same))⟩
      | ⟨.inl _, step, _⟩ => nomatch step⟩⟩

/-- **A fragment is alike in its roles to its image under an open map of joinings.** -/
theorem OpenMap.alike {J : Joining F} {K : Joining G} {p : F → G} (opens : J.OpenMap K p) (x : F) :
    Alike J.roleFrame K.roleFrame (.inl x) (.inl (p x)) :=
  match openMap_iff.mp opens with
  | ⟨_, opens'⟩ => opens'.alike (.inl x)

/-- **An open map of joinings keeps every branching test of roles**: a fragment and its image pass
the same ones. -/
theorem OpenMap.sameBranchingTests {J : Joining F} {K : Joining G} {p : F → G} (opens : J.OpenMap K p)
    (x : F) : SameBranchingTests J.roleFrame K.roleFrame (.inl x) (.inl (p x)) :=
  (opens.alike x).sameBranchingTests

/-- The identity is an open map of joinings. -/
theorem openMap_id (J : Joining F) : J.OpenMap J fun x => x :=
  ⟨fun _ _ _ joined => joined, fun _ e _ at_r => ⟨e, at_r, fun _ => rfl⟩⟩

/-! ### The common refinement of two joinings -/

/-- Pairs of fragments of two joinings alike in their roles. -/
abbrev Matched (J : Joining F) (K : Joining G) :=
  { q : F × G // Alike J.roleFrame K.roleFrame (.inl q.1) (.inl q.2) }

/-- Two joinings joined pair by pair on their matched fragments. -/
def span (J : Joining F) (K : Joining G) : Joining (Matched J K) :=
  fun a b c => J a.val.1 b.val.1 c.val.1 ∧ K a.val.2 b.val.2 c.val.2

/-- Two occurrences holding alike fragments in every role, as one occurrence of the span. -/
def pairOccurrence {J : Joining F} {K : Joining G} (e : Occurrence J) (f : Occurrence K)
    (slots : ∀ i, Alike J.roleFrame K.roleFrame (.inl (e.at i)) (.inl (f.at i))) :
    Occurrence (J.span K) :=
  ⟨⟨(e.first, f.first), slots .first⟩, ⟨(e.second, f.second), slots .second⟩,
    ⟨(e.result, f.result), slots .result⟩, ⟨e.formed, f.formed⟩⟩

theorem pairOccurrence_at {J : Joining F} {K : Joining G} (e : Occurrence J) (f : Occurrence K)
    (slots : ∀ i, Alike J.roleFrame K.roleFrame (.inl (e.at i)) (.inl (f.at i))) :
    ∀ i, (pairOccurrence e f slots).at i = ⟨(e.at i, f.at i), slots i⟩
  | .first => rfl
  | .second => rfl
  | .result => rfl

/-- **The first projection of the span is open.** No premise. -/
theorem span_first_open (J : Joining F) (K : Joining G) :
    (J.span K).OpenMap J fun q => q.val.1 :=
  ⟨fun _ _ _ joined => joined.1, fun q e r at_r => match match_incident q.property e r at_r with
    | ⟨f, at_f, slots⟩ => ⟨pairOccurrence e f slots,
        (pairOccurrence_at e f slots r).trans (Subtype.ext (Prod.ext at_r at_f)),
        fun i => congrArg (fun q : Matched J K => q.val.1) (pairOccurrence_at e f slots i)⟩⟩

/-- **The second projection of the span is open.** No premise. -/
theorem span_second_open (J : Joining F) (K : Joining G) :
    (J.span K).OpenMap K fun q => q.val.2 :=
  ⟨fun _ _ _ joined => joined.2, fun q f r at_r => match match_incident q.property.symm f r at_r with
    | ⟨e, at_e, slots⟩ => ⟨pairOccurrence e f (fun i => (slots i).symm),
        (pairOccurrence_at e f _ r).trans (Subtype.ext (Prod.ext at_e at_r)),
        fun i => congrArg (fun q : Matched J K => q.val.2) (pairOccurrence_at e f _ i)⟩⟩

/-- Every fragment reaches, through roles, from where its joining is connected. -/
def ConnectedFrom (J : Joining F) (x : F) : Prop :=
  ∀ a, Reach J.roleFrame.P (.inl x) (.inl a)

/-- **Alike roots cover what they connect**: every fragment connected to a root is alike in its
roles to some fragment of a joining with a root alike to it. -/
theorem covers {J : Joining F} {K : Joining G} {x : F} {y : G}
    (alike : Alike J.roleFrame K.roleFrame (.inl x) (.inl y)) (connected : J.ConnectedFrom x)
    (a : F) : ∃ b, Alike J.roleFrame K.roleFrame (.inl a) (.inl b) :=
  match connected a with
  | ⟨_, path⟩ => match alike.trace path with
    | ⟨.inl b, _, joined⟩ => ⟨b, joined⟩
    | ⟨.inr f, _, joined⟩ => absurd joined (fragment_not_alike_occurrence a f)

/-- **Two joinings with alike connecting roots have a common refinement**: the span of their
matched fragments, whose projections are open maps of joinings and cover both. No finiteness and
no decision is used. -/
theorem common_refinement {J : Joining F} {K : Joining G} {x : F} {y : G}
    (alike : Alike J.roleFrame K.roleFrame (.inl x) (.inl y)) (connected : J.ConnectedFrom x)
    (connected' : K.ConnectedFrom y) :
    (J.span K).OpenMap J (fun q => q.val.1) ∧ (J.span K).OpenMap K (fun q => q.val.2) ∧
      (∀ a, ∃ q : Matched J K, q.val.1 = a) ∧ (∀ b, ∃ q : Matched J K, q.val.2 = b) :=
  ⟨span_first_open J K, span_second_open J K,
   fun a => match covers alike connected a with
     | ⟨b, joined⟩ => ⟨⟨(a, b), joined⟩, rfl⟩,
   fun b => match covers alike.symm connected' b with
     | ⟨a, joined⟩ => ⟨⟨(a, b), joined.symm⟩, rfl⟩⟩

/-- The map into the span given by two open maps from one joining. -/
def factor {H : Type w} {L : Joining H} {J : Joining F} {K : Joining G} {p : H → F} {q : H → G}
    (hp : L.OpenMap J p) (hq : L.OpenMap K q) (z : H) : Matched J K :=
  ⟨(p z, q z), (hp.alike z).symm.trans (hq.alike z)⟩

/-- **Two open maps from one joining factor through the span, uniquely.** The factor keeps the
joining and commutes with both projections, and any map into the span commuting with them agrees
with it at every fragment. The factor is not claimed open. -/
theorem universal_factor {H : Type w} {L : Joining H} {J : Joining F} {K : Joining G}
    {p : H → F} {q : H → G} (hp : L.OpenMap J p) (hq : L.OpenMap K q) :
    (∀ z, (factor hp hq z).val.1 = p z ∧ (factor hp hq z).val.2 = q z) ∧
      L.Keeps (J.span K) (factor hp hq) ∧
      ∀ g : H → Matched J K, (∀ z, (g z).val.1 = p z ∧ (g z).val.2 = q z) →
        ∀ z, g z = factor hp hq z :=
  ⟨fun _ => ⟨rfl, rfl⟩, fun _ _ _ joined => ⟨hp.1 _ _ _ joined, hq.1 _ _ _ joined⟩,
   fun _ same z => Subtype.ext (Prod.ext (same z).1 (same z).2)⟩

/-! ### Where every fragment takes every role -/

/-- Every fragment holds every role in some occurrence. -/
def RoleTotal (J : Joining F) : Prop := ∀ x r, ∃ e : Occurrence J, e.at r = x

/-- The joining of one fragment with itself. -/
def coarse : Joining Unit := fun _ _ _ => True

/-- **A joining in which every fragment takes every role has an open map onto the one-fragment
joining.** -/
theorem RoleTotal.openMap {J : Joining F} (total : J.RoleTotal) : J.OpenMap coarse fun _ => () :=
  ⟨fun _ _ _ _ => True.intro, fun x _ r _ => match total x r with
    | ⟨d, at_d⟩ => ⟨d, at_d, fun _ => rfl⟩⟩

/-- **Read through roles, all fragments of joinings in which every fragment takes every role are
alike.** -/
theorem RoleTotal.alike {J : Joining F} {K : Joining G} (total : J.RoleTotal) (total' : K.RoleTotal)
    (x : F) (y : G) : Alike J.roleFrame K.roleFrame (.inl x) (.inl y) :=
  (total.openMap.alike x).trans (total'.openMap.alike y).symm

/-- A map lifts pairs where every joining of the images of `x` and `y` is the image of a joining of
`x` and `y`. -/
def PairLifting (J : Joining F) (K : Joining G) (p : F → G) : Prop :=
  ∀ x y z, K (p x) (p y) z → ∃ w, J x y w ∧ p w = z

/-- A fragment joins with itself. -/
def SelfJoinable (J : Joining F) (x : F) : Prop := ∃ z, J x x z

/-- Where some fragment cannot join itself, the map onto the one-fragment joining does not lift
pairs. -/
theorem not_pairLifting_coarse {J : Joining F} {x : F} (alone : ¬ J.SelfJoinable x) :
    ¬ J.PairLifting coarse fun _ => () :=
  fun lifting => match lifting x x () True.intro with
    | ⟨w, joined, _⟩ => alone ⟨w, joined⟩

/-- **Reading through roles loses joining at a fixed pair.** Where every fragment takes every
role and some fragment cannot join itself, the map onto the one-fragment joining is open, so every
fragment passes the branching tests of roles the one fragment passes, and it does not lift pairs. -/
theorem RoleTotal.open_not_pairLifting {J : Joining F} (total : J.RoleTotal) {x : F}
    (alone : ¬ J.SelfJoinable x) :
    J.OpenMap coarse (fun _ => ()) ∧
      (∀ y, SameBranchingTests J.roleFrame coarse.roleFrame (.inl y) (.inl ())) ∧
      ¬ J.PairLifting coarse fun _ => () :=
  ⟨total.openMap, fun y => (total.openMap.alike y).sameBranchingTests, not_pairLifting_coarse alone⟩

/-- **Where every fragment takes every role, one code is exact for roles and hides a failure to
join.** All fragments are alike in their roles, so the description giving every fragment one code
identifies exactly the fragments alike in their roles; the one-fragment joining joins its fragment
with itself, while a fragment that cannot join itself has that one code. -/
theorem RoleTotal.collapse {J : Joining F} (total : J.RoleTotal) {x : F} (alone : ¬ J.SelfJoinable x) :
    (∀ y z, (fun _ => ()) y = (fun _ => ()) z ↔ Alike J.roleFrame J.roleFrame (.inl y) (.inl z)) ∧
      coarse.SelfJoinable () ∧ ¬ J.SelfJoinable x :=
  ⟨fun y z => ⟨fun _ => total.alike total y z, fun _ => rfl⟩, ⟨(), True.intro⟩, alone⟩

/-! ### Branching tests of roles where each fragment holds each role in listed occurrences -/

theorem exists_of_mem_map {α : Type u} {β : Type v} {g : α → β} {b : β} :
    ∀ {l : List α}, b ∈ l.map g → ∃ a, a ∈ l ∧ g a = b
  | [], mem => by
    have absent : List.Mem b [] := mem
    cases absent
  | a :: l, mem => by
    have mem' : List.Mem b (g a :: l.map g) := mem
    cases mem' with
    | head => exact ⟨a, List.Mem.head l, rfl⟩
    | tail _ rest =>
      obtain ⟨a', mem'', same⟩ := exists_of_mem_map rest
      exact ⟨a', List.Mem.tail a mem'', same⟩

/-- Each fragment holds each role in a listed set of occurrences. -/
def LocallyFinite (J : Joining F) : Prop :=
  ∀ x r, ∃ es : List (Occurrence J), ∀ e, e.at r = x ↔ e ∈ es

/-- Where each fragment holds each role in listed occurrences, each move of the reading through
roles has listed outcomes. -/
theorem LocallyFinite.outcomes {J : Joining F} (finite : J.LocallyFinite) :
    ∀ s m, ∃ l : List (F ⊕ Occurrence J), ∀ t, J.roleFrame.P.step s m t ↔ t ∈ l
  | .inl x, .enter r => match finite x r with
    | ⟨es, listed⟩ => ⟨es.map Sum.inr, fun t => match t with
      | .inl _ => ⟨fun step => (nomatch step), fun mem => match exists_of_mem_map mem with
          | ⟨_, _, same⟩ => nomatch same⟩
      | .inr e => ⟨fun at_r => ListTests.mem_map_of (f := Sum.inr) ((listed e).mp at_r),
          fun mem => match exists_of_mem_map mem with
          | ⟨_, mem', same⟩ => (listed e).mpr
              (Eq.subst (motive := fun d => d ∈ es) (Sum.inr.inj same) mem')⟩⟩
  | .inl _, .leave _ => ⟨[], fun t => match t with
      | .inl _ => ⟨fun step => (nomatch step), fun mem => nomatch mem⟩
      | .inr _ => ⟨fun step => (nomatch step), fun mem => nomatch mem⟩⟩
  | .inr _, .enter _ => ⟨[], fun t => match t with
      | .inl _ => ⟨fun step => (nomatch step), fun mem => nomatch mem⟩
      | .inr _ => ⟨fun step => (nomatch step), fun mem => nomatch mem⟩⟩
  | .inr e, .leave r => ⟨[.inl (e.at r)], fun t => match t with
      | .inl _ => ⟨fun at_r => by subst at_r; exact List.Mem.head [], fun mem =>
          Sum.inl.inj (CrossSituational.mem_singleton mem)⟩
      | .inr _ => ⟨fun step => (nomatch step), fun mem => nomatch CrossSituational.mem_singleton mem⟩⟩

/-- **Under excluded middle, where each fragment holds each role in listed occurrences, places are
alike in their roles exactly where they pass the same branching tests.** -/
theorem LocallyFinite.alike_iff (em : ∀ p : Prop, Decided p) {J : Joining F} {K : Joining G}
    (finite : J.LocallyFinite) (finite' : K.LocallyFinite) {s : F ⊕ Occurrence J}
    {t : G ⊕ Occurrence K} :
    Alike J.roleFrame K.roleFrame s t ↔ SameBranchingTests J.roleFrame K.roleFrame s t :=
  ⟨Alike.sameBranchingTests, alike_of_sameBranchingTests_of_em em finite.outcomes finite'.outcomes⟩

/-- **The common refinement where roots pass the same branching tests of roles**, each fragment
holding each role in listed occurrences, under excluded middle. -/
theorem common_refinement_of_em (em : ∀ p : Prop, Decided p) {J : Joining F} {K : Joining G}
    (finite : J.LocallyFinite) (finite' : K.LocallyFinite) {x : F} {y : G}
    (same : SameBranchingTests J.roleFrame K.roleFrame (.inl x) (.inl y))
    (connected : J.ConnectedFrom x) (connected' : K.ConnectedFrom y) :
    (J.span K).OpenMap J (fun q => q.val.1) ∧ (J.span K).OpenMap K (fun q => q.val.2) ∧
      (∀ a, ∃ q : Matched J K, q.val.1 = a) ∧ (∀ b, ∃ q : Matched J K, q.val.2 = b) :=
  common_refinement ((LocallyFinite.alike_iff em finite finite').mpr same) connected connected'

/-! ### The joining read through retained references -/

/-- The joining read through retained references: a configuration keeps every fragment formed, a
move names two of its slots, and its outcome appends a fragment the two join into. -/
def retainedFrame (J : Joining F) : Frame (List F) (Nat × Nat) Empty :=
  ⟨⟨fun xs ij ys => ∃ a b z, Copying.nth xs ij.1 = some a ∧ Copying.nth xs ij.2 = some b ∧ J a b z ∧
      ys = xs ++ [z]⟩, fun _ c => nomatch c⟩

/-- **A retained configuration keeps what it had**: along every course it is extended, by one
fragment for each move. -/
theorem retained_extends {J : Joining F} {xs ys : List F} {cmds : List (Nat × Nat)}
    (path : Trace J.retainedFrame.P xs cmds ys) : ∃ added, ys = xs ++ added ∧ added.length = cmds.length := by
  induction path with
  | nil xs => exact ⟨[], (ListTests.append_nil xs).symm, rfl⟩
  | cons step _ ih =>
    obtain ⟨_, _, z, _, _, _, formed⟩ := step
    obtain ⟨added, extended, counted⟩ := ih
    subst formed
    exact ⟨z :: added, extended.trans (ListTests.append_assoc _ [z] added), congrArg Nat.succ counted⟩

/-- **Alike retained configurations of equally many slots match every course of formation**: the
matched course takes the same moves, ends alike, keeps the configuration it started from and keeps
the slots aligned. No premise beyond the two named. -/
theorem retained_history_matches {J : Joining F} {K : Joining G} {xs : List F} {ys : List G}
    (alike : Alike J.retainedFrame K.retainedFrame xs ys) (slots : xs.length = ys.length)
    {cmds : List (Nat × Nat)} {finish : List F} (path : Trace J.retainedFrame.P xs cmds finish) :
    ∃ finish', Trace K.retainedFrame.P ys cmds finish' ∧
      Alike J.retainedFrame K.retainedFrame finish finish' ∧ finish.length = finish'.length ∧
      ∃ added, finish' = ys ++ added :=
  match alike.trace path with
  | ⟨finish', path', joined⟩ =>
    match retained_extends path, retained_extends path' with
    | ⟨added, extended, counted⟩, ⟨added', extended', counted'⟩ =>
      ⟨finish', path', joined,
       (congrArg List.length extended).trans ((ListTests.length_append xs added).trans
         ((congrArg (· + added.length) slots).trans ((congrArg (ys.length + ·) (counted.trans counted'.symm)).trans
           ((ListTests.length_append ys added').symm.trans (congrArg List.length extended').symm)))),
       added', extended'⟩

/-- **The self-joining test**: a configuration of one fragment can join its only slot with itself
exactly where the fragment joins with itself. -/
theorem retained_self_iff {J : Joining F} {x : F} :
    BranchingTest.Holds J.retainedFrame [x] (.can (0, 0) .top) ↔ J.SelfJoinable x :=
  ⟨fun ⟨_, ⟨_, _, z, at_a, at_b, joined, _⟩, _⟩ => by
    cases Option.some.inj at_a
    cases Option.some.inj at_b
    exact ⟨z, joined⟩,
   fun ⟨z, joined⟩ => ⟨[x] ++ [z], ⟨x, x, z, rfl, rfl, joined, rfl⟩, True.intro⟩⟩

/-- **Retained references keep the difference roles lose**: a fragment that joins with itself and
one that does not are, as configurations of one slot, told apart by a branching test. -/
theorem retained_apart {J : Joining F} {K : Joining G} {x : F} {y : G} (self : J.SelfJoinable x)
    (alone : ¬ K.SelfJoinable y) :
    ¬ SameBranchingTests J.retainedFrame K.retainedFrame [x] [y] :=
  fun same => alone (retained_self_iff.mp ((same _).mp (retained_self_iff.mpr self)))

/-- **Every exact account of the retained tests keeps the difference**: a description whose equal
codes pass the same branching tests gives a fragment that joins with itself and one that does not,
as configurations of one slot, different codes. -/
theorem retained_codes_apart {J : Joining F} {π : List F → K}
    (exact : ∀ xs ys, π xs = π ys → SameBranchingTests J.retainedFrame J.retainedFrame xs ys)
    {x y : F} (self : J.SelfJoinable x) (alone : ¬ J.SelfJoinable y) : π [x] ≠ π [y] :=
  fun same => retained_apart self alone (exact _ _ same)

/-- Where each pair joins into listed fragments, each move of the reading through retained
references has listed outcomes. -/
theorem FiniteOutcomes.retained_outcomes {J : Joining F} (finite : J.FiniteOutcomes) :
    ∀ xs ij, ∃ l : List (List F), ∀ ys, J.retainedFrame.P.step xs ij ys ↔ ys ∈ l
  | xs, (i, j) => match at_i : Copying.nth xs i, at_j : Copying.nth xs j with
    | some a, some b => match finite a b with
      | ⟨zs, listed⟩ => ⟨zs.map (fun z => xs ++ [z]), fun _ =>
        ⟨fun ⟨_, _, z, at_a, at_b, joined, formed⟩ => by
          cases Option.some.inj (at_i.symm.trans at_a)
          cases Option.some.inj (at_j.symm.trans at_b)
          subst formed
          exact ListTests.mem_map_of (f := fun z => xs ++ [z]) ((listed z).mp joined),
         fun mem => match exists_of_mem_map mem with
          | ⟨z, mem', formed⟩ => ⟨a, b, z, at_i, at_j, (listed z).mpr mem', formed.symm⟩⟩⟩
    | none, _ => ⟨[], fun _ => ⟨fun ⟨_, _, _, at_a, _⟩ => (nomatch at_i.symm.trans at_a),
        fun mem => nomatch mem⟩⟩
    | some _, none => ⟨[], fun _ => ⟨fun ⟨_, _, _, _, at_b, _⟩ => (nomatch at_j.symm.trans at_b),
        fun mem => nomatch mem⟩⟩

/-- **Under excluded middle, retained configurations of joinings whose pairs join into listed
fragments are alike exactly where they pass the same branching tests.** -/
theorem FiniteOutcomes.retained_alike_iff (em : ∀ p : Prop, Decided p) {J : Joining F}
    {K : Joining G} (finite : J.FiniteOutcomes) (finite' : K.FiniteOutcomes) {xs : List F}
    {ys : List G} :
    Alike J.retainedFrame K.retainedFrame xs ys ↔ SameBranchingTests J.retainedFrame K.retainedFrame xs ys :=
  ⟨Alike.sameBranchingTests,
   alike_of_sameBranchingTests_of_em em finite.retained_outcomes finite'.retained_outcomes⟩

/-- **Retained configurations passing the same branching tests match every course of formation**,
each pair joining into listed fragments, under excluded middle. -/
theorem retained_history_matches_of_em (em : ∀ p : Prop, Decided p) {J : Joining F}
    {K : Joining G} (finite : J.FiniteOutcomes) (finite' : K.FiniteOutcomes) {xs : List F}
    {ys : List G} (same : SameBranchingTests J.retainedFrame K.retainedFrame xs ys)
    (slots : xs.length = ys.length) {cmds : List (Nat × Nat)} {finish : List F}
    (path : Trace J.retainedFrame.P xs cmds finish) :
    ∃ finish', Trace K.retainedFrame.P ys cmds finish' ∧
      SameBranchingTests J.retainedFrame K.retainedFrame finish finish' ∧
      finish.length = finish'.length ∧ ∃ added, finish' = ys ++ added :=
  match retained_history_matches ((FiniteOutcomes.retained_alike_iff em finite finite').mpr same)
      slots path with
  | ⟨finish', path', joined, counted, added, extended⟩ =>
    ⟨finish', path', joined.sameBranchingTests, counted, added, extended⟩

/-! ### A step taken once -/

namespace Once

/-- The fragments of a process that can make one passage and no more: idle at the start, idle at
the finish, and the passage. -/
inductive Piece where
  | start
  | finish
  | passage

/-- Idle fragments join with themselves; the passage follows the idle start and precedes the idle
finish. -/
inductive Joins : Piece → Piece → Piece → Prop where
  | start : Joins .start .start .start
  | finish : Joins .finish .finish .finish
  | enter : Joins .start .passage .passage
  | leave : Joins .passage .finish .passage

/-- The joining of the fragments of one passage. -/
def joining : Joining Piece := Joins

/-- Every fragment takes every role. -/
theorem roleTotal : joining.RoleTotal
  | .start, .first => ⟨⟨.start, .start, .start, .start⟩, rfl⟩
  | .start, .second => ⟨⟨.start, .start, .start, .start⟩, rfl⟩
  | .start, .result => ⟨⟨.start, .start, .start, .start⟩, rfl⟩
  | .finish, .first => ⟨⟨.finish, .finish, .finish, .finish⟩, rfl⟩
  | .finish, .second => ⟨⟨.finish, .finish, .finish, .finish⟩, rfl⟩
  | .finish, .result => ⟨⟨.finish, .finish, .finish, .finish⟩, rfl⟩
  | .passage, .first => ⟨⟨.passage, .finish, .passage, .leave⟩, rfl⟩
  | .passage, .second => ⟨⟨.start, .passage, .passage, .enter⟩, rfl⟩
  | .passage, .result => ⟨⟨.start, .passage, .passage, .enter⟩, rfl⟩

/-- The idle start joins with itself. -/
theorem start_self : joining.SelfJoinable .start := ⟨.start, .start⟩

/-- The passage cannot join with itself: it is made once. -/
theorem passage_alone : ¬ joining.SelfJoinable .passage :=
  fun ⟨_, joined⟩ => nomatch joined

/-- **Read through roles, the passage is alike to the idle start.** -/
theorem roles_alike : Alike joining.roleFrame joining.roleFrame (.inl .passage) (.inl .start) :=
  roleTotal.alike roleTotal _ _

/-- The map onto the one-fragment joining is open, keeps every branching test of roles, and does
not lift the pair of the passage with itself. -/
theorem open_not_pairLifting :
    joining.OpenMap coarse (fun _ => ()) ∧
      (∀ y, SameBranchingTests joining.roleFrame coarse.roleFrame (.inl y) (.inl ())) ∧
      ¬ joining.PairLifting coarse fun _ => () :=
  roleTotal.open_not_pairLifting passage_alone

/-- **Read through retained references, the passage and the idle start are apart**, and every
exact account of the retained tests gives them different codes. -/
theorem retained_apart :
    ¬ SameBranchingTests joining.retainedFrame joining.retainedFrame [.start] [.passage] ∧
      ∀ {K : Type u} (π : List Piece → K),
        (∀ xs ys, π xs = π ys → SameBranchingTests joining.retainedFrame joining.retainedFrame xs ys) →
        π [.start] ≠ π [.passage] :=
  ⟨Joining.retained_apart start_self passage_alone,
   fun _ exact => retained_codes_apart exact start_self passage_alone⟩

end Once

end Joining

end Becoming
