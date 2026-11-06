import Becoming.LocalUnits

/-!
# Joining contexts: a fragment read through what it can be joined into

A context of a joining is a finite arrangement of joinings around a hole: partners joined on the
left or on the right, innermost first (`Joining.Context`). It is a course of moves of the
joining's frame (`Context.course`), and it realizes what that course reaches from what fills the
hole (`Context.Realizes`). No success predicate is supplied: a context is possible for a
fragment where it realizes something (`Context.Possible`), and two fragments agree on contexts
where the same contexts are possible for each (`ContextSame`).

* Agreeing on contexts is passing the same tests of the joining's frame
  (`ContextSame.iff_sameTests`), so it is an equivalence.
* Contexts compose (`Context.realizes_splice`); where joining is functional, a context realizes
  at most one fragment (`Context.realizes_functional`), and after it the possible contexts are
  those possible for what it realized (`Context.possible_splice_of_realizes`).
* Fragments agreeing on contexts join alike (`ContextSame.composable_iff`), and where joining is
  functional, what they join into, or what one context realizes from them, agrees on contexts
  (`ContextSame.joined`, `ContextSame.realized`).
* A relation compatible with the joining (`Joining.Compatible`) carries every context
  (`Compatible.realizes`) and so relates only fragments agreeing on contexts; where joining is
  functional, agreeing on contexts is itself compatible, so it is the largest compatible relation
  (`contextSame_iff_compatible`).

Every declaration's axiom report is empty. Ported from `Generative.ExplanatoryJoiningContexts`
(bridge fold F3E, 18 October 2026); the port is a restatement on the core's joinings, not a new
result. The periphery's recursive `Realizes` is the trace of the context's course
(`Context.realizes_hole`, `Context.realizes_left`, `Context.realizes_right`).
-/

universe u u' v

namespace Becoming

open Generative

namespace Joining

variable {F : Type u}

/-- A context: a hole, or a context with a partner joined on its left or on its right. -/
inductive Context (F : Type u) where
  | hole
  | left (a : F) (c : Context F)
  | right (c : Context F) (a : F)

/-- The course of moves a context takes, innermost first. -/
def Context.course : Context F → List (Move F)
  | .hole => []
  | .left a c => c.course ++ [.withLeft a]
  | .right c a => c.course ++ [.withRight a]

/-- A context realizes what its course reaches in the joining's frame from what fills the hole. -/
def Context.Realizes (J : Joining F) (c : Context F) (x y : F) : Prop := Trace J.frame.P x c.course y

/-- A context is possible for a fragment where it realizes something from it. -/
def Context.Possible (J : Joining F) (c : Context F) (x : F) : Prop := ∃ y, c.Realizes J x y

/-- Two fragments agree on contexts: the same contexts are possible for each. -/
def ContextSame (J : Joining F) (x y : F) : Prop := ∀ c : Context F, c.Possible J x ↔ c.Possible J y

/-- One context in the hole of another. -/
def Context.splice : Context F → Context F → Context F
  | .hole, inner => inner
  | .left a c, inner => .left a (c.splice inner)
  | .right c a, inner => .right (c.splice inner) a

/-- The hole realizes what fills it. -/
theorem Context.realizes_hole (J : Joining F) (x y : F) : Context.hole.Realizes J x y ↔ y = x :=
  ⟨fun path => (trace_nil_iff.mp path).symm, fun same => trace_nil_iff.mpr same.symm⟩

/-- A partner joined on the left of a context. -/
theorem Context.realizes_left (J : Joining F) (a : F) (c : Context F) (x y : F) :
    (Context.left a c).Realizes J x y ↔ ∃ m, c.Realizes J x m ∧ J a m y :=
  ⟨fun path => match trace_append_iff.mp path with
    | ⟨m, inner, last⟩ => ⟨m, inner, (trace_singleton_iff (P := J.frame.P)).mp last⟩,
   fun ⟨m, inner, joined⟩ => trace_append_iff.mpr ⟨m, inner, trace_singleton_iff.mpr joined⟩⟩

/-- A partner joined on the right of a context. -/
theorem Context.realizes_right (J : Joining F) (c : Context F) (a : F) (x y : F) :
    (Context.right c a).Realizes J x y ↔ ∃ m, c.Realizes J x m ∧ J m a y :=
  ⟨fun path => match trace_append_iff.mp path with
    | ⟨m, inner, last⟩ => ⟨m, inner, (trace_singleton_iff (P := J.frame.P)).mp last⟩,
   fun ⟨m, inner, joined⟩ => trace_append_iff.mpr ⟨m, inner, trace_singleton_iff.mpr joined⟩⟩

/-- The course of a context spliced into another: the inner course, then the outer. -/
theorem Context.course_splice (inner : Context F) :
    ∀ outer : Context F, (outer.splice inner).course = inner.course ++ outer.course
  | .hole => (ListTests.append_nil inner.course).symm
  | .left a c => (congrArg (fun l => l ++ [Move.withLeft a]) (Context.course_splice inner c)).trans
      (ListTests.append_assoc inner.course c.course [.withLeft a])
  | .right c a => (congrArg (fun l => l ++ [Move.withRight a]) (Context.course_splice inner c)).trans
      (ListTests.append_assoc inner.course c.course [.withRight a])

/-- **Contexts compose**: a spliced context realizes what the outer realizes from what the inner
realizes. -/
theorem Context.realizes_splice (J : Joining F) (outer inner : Context F) (x z : F) :
    (outer.splice inner).Realizes J x z ↔ ∃ y, inner.Realizes J x y ∧ outer.Realizes J y z :=
  (Eq.subst (motive := fun l => Trace J.frame.P x l z ↔ Trace J.frame.P x (inner.course ++ outer.course) z)
    (Context.course_splice inner outer).symm Iff.rfl).trans trace_append_iff

/-- A spliced context is possible exactly where the outer is possible after what the inner
realizes. -/
theorem Context.possible_splice (J : Joining F) (outer inner : Context F) (x : F) :
    (outer.splice inner).Possible J x ↔ ∃ y, inner.Realizes J x y ∧ outer.Possible J y :=
  ⟨fun ⟨z, realized⟩ => match (Context.realizes_splice J outer inner x z).mp realized with
    | ⟨y, first, second⟩ => ⟨y, first, z, second⟩,
   fun ⟨y, first, z, second⟩ => ⟨z, (Context.realizes_splice J outer inner x z).mpr ⟨y, first, second⟩⟩⟩

/-- **Where joining is functional, a context realizes at most one fragment.** -/
theorem Context.realizes_functional {J : Joining F} (fn : J.Functional) (c : Context F) {x y z : F}
    (first : c.Realizes J x y) (second : c.Realizes J x z) : y = z :=
  Trace.determined_end fn.determined first second

/-- **Where joining is functional, after a context the possible contexts are those possible for
what it realized.** -/
theorem Context.possible_splice_of_realizes {J : Joining F} (fn : J.Functional) {inner : Context F}
    {x y : F} (realized : inner.Realizes J x y) (outer : Context F) :
    (outer.splice inner).Possible J x ↔ outer.Possible J y :=
  (Context.possible_splice J outer inner x).trans
    ⟨fun ⟨_, realized', possible⟩ => Eq.subst (motive := outer.Possible J)
        (Context.realizes_functional fn inner realized' realized) possible,
     fun possible => ⟨y, realized, possible⟩⟩

/-- Every fragment agrees on contexts with itself. -/
theorem ContextSame.refl (J : Joining F) (x : F) : ContextSame J x x := fun _ => Iff.rfl

theorem ContextSame.symm {J : Joining F} {x y : F} (same : ContextSame J x y) : ContextSame J y x :=
  fun c => (same c).symm

theorem ContextSame.trans {J : Joining F} {x y z : F} (same : ContextSame J x y)
    (same' : ContextSame J y z) : ContextSame J x z :=
  fun c => (same c).trans (same' c)

/-- The context joining a partner on the right is possible exactly where the two join. -/
theorem Context.possible_right (J : Joining F) (a b : F) :
    (Context.right .hole b).Possible J a ↔ J.Composable a b :=
  ⟨fun ⟨z, realized⟩ => match (Context.realizes_right J .hole b a z).mp realized with
    | ⟨_, at_, joined⟩ => ⟨z, Eq.subst (motive := fun m => J m b z) (trace_nil_iff.mp at_).symm joined⟩,
   fun ⟨z, joined⟩ => ⟨z, (Context.realizes_right J .hole b a z).mpr ⟨a, .nil a, joined⟩⟩⟩

/-- The context joining a partner on the left is possible exactly where the two join. -/
theorem Context.possible_left (J : Joining F) (a b : F) :
    (Context.left a .hole).Possible J b ↔ J.Composable a b :=
  ⟨fun ⟨z, realized⟩ => match (Context.realizes_left J a .hole b z).mp realized with
    | ⟨_, at_, joined⟩ => ⟨z, Eq.subst (motive := fun m => J a m z) (trace_nil_iff.mp at_).symm joined⟩,
   fun ⟨z, joined⟩ => ⟨z, (Context.realizes_left J a .hole b z).mpr ⟨b, .nil b, joined⟩⟩⟩

/-- **Fragments agreeing on contexts join alike.** -/
theorem ContextSame.composable_iff {J : Joining F} {a a' b b' : F} (same : ContextSame J a a')
    (same' : ContextSame J b b') : J.Composable a b ↔ J.Composable a' b' :=
  (Context.possible_right J a b).symm.trans ((same (.right .hole b)).trans
    ((Context.possible_right J a' b).trans ((Context.possible_left J a' b).symm.trans
      ((same' (.left a' .hole)).trans (Context.possible_left J a' b')))))

/-- **Where joining is functional, what one context realizes from fragments agreeing on contexts
agrees on contexts.** -/
theorem ContextSame.realized {J : Joining F} (fn : J.Functional) {a b x y : F}
    (same : ContextSame J a b) (c : Context F) (realized : c.Realizes J a x)
    (realized' : c.Realizes J b y) : ContextSame J x y :=
  fun outer => (Context.possible_splice_of_realizes fn realized outer).symm.trans
    ((same (outer.splice c)).trans (Context.possible_splice_of_realizes fn realized' outer))

/-- **Where joining is functional, what fragments agreeing on contexts join into agrees on
contexts.** -/
theorem ContextSame.joined {J : Joining F} (fn : J.Functional) {a a' b b' z z' : F}
    (same : ContextSame J a a') (same' : ContextSame J b b') (joined : J a b z) (joined' : J a' b' z') :
    ContextSame J z z' :=
  match (ContextSame.composable_iff same (ContextSame.refl J b)).mp ⟨z, joined⟩ with
  | ⟨m, middle⟩ =>
    (ContextSame.realized fn same (.right .hole b)
        ((Context.realizes_right J .hole b a z).mpr ⟨a, .nil a, joined⟩)
        ((Context.realizes_right J .hole b a' m).mpr ⟨a', .nil a', middle⟩)).trans
      (ContextSame.realized fn same' (.left a' .hole)
        ((Context.realizes_left J a' .hole b m).mpr ⟨b, .nil b, middle⟩)
        ((Context.realizes_left J a' .hole b' z').mpr ⟨b', .nil b', joined'⟩))

/-- **A relation compatible with the joining carries every context**, both ways. -/
theorem Compatible.realizes {J : Joining F} {B : F → F → Prop} (compatible : J.Compatible B)
    (c : Context F) {x y : F} (related : B x y) :
    (∀ z, c.Realizes J x z → ∃ w, c.Realizes J y w ∧ B z w) ∧
      (∀ w, c.Realizes J y w → ∃ z, c.Realizes J x z ∧ B z w) :=
  have bisim := bisimulation_iff_compatible.mpr compatible
  ⟨fun _ path => bisim.trace path related,
   fun _ path' => match bisim.converse.trace path' related with
    | ⟨z, path, joined⟩ => ⟨z, path, joined⟩⟩

/-- **A relation compatible with the joining relates only fragments agreeing on contexts.** -/
theorem Compatible.contextSame {J : Joining F} {B : F → F → Prop} (compatible : J.Compatible B)
    {x y : F} (related : B x y) : ContextSame J x y :=
  fun c => match Compatible.realizes compatible c related with
  | ⟨forth, back⟩ =>
    ⟨fun ⟨z, realized⟩ => match forth z realized with | ⟨w, realized', _⟩ => ⟨w, realized'⟩,
     fun ⟨w, realized'⟩ => match back w realized' with | ⟨z, realized, _⟩ => ⟨z, realized⟩⟩

/-- **Where joining is functional, agreeing on contexts is compatible with the joining.** -/
theorem ContextSame.compatible {J : Joining F} (fn : J.Functional) : J.Compatible (ContextSame J) :=
  fun _ _ same a =>
    ⟨fun z joined => match (ContextSame.composable_iff (ContextSame.refl J a) same).mp ⟨z, joined⟩ with
      | ⟨w, joined'⟩ => ⟨w, joined', ContextSame.joined fn (ContextSame.refl J a) same joined joined'⟩,
     fun w joined' => match (ContextSame.composable_iff (ContextSame.refl J a) same).mpr ⟨w, joined'⟩ with
      | ⟨z, joined⟩ => ⟨z, joined, ContextSame.joined fn (ContextSame.refl J a) same joined joined'⟩,
     fun z joined => match (ContextSame.composable_iff same (ContextSame.refl J a)).mp ⟨z, joined⟩ with
      | ⟨w, joined'⟩ => ⟨w, joined', ContextSame.joined fn same (ContextSame.refl J a) joined joined'⟩,
     fun w joined' => match (ContextSame.composable_iff same (ContextSame.refl J a)).mpr ⟨w, joined'⟩ with
      | ⟨z, joined⟩ => ⟨z, joined, ContextSame.joined fn same (ContextSame.refl J a) joined joined'⟩⟩

/-- **Where joining is functional, fragments agree on contexts exactly where some relation
compatible with the joining relates them.** -/
theorem contextSame_iff_compatible {J : Joining F} (fn : J.Functional) (x y : F) :
    ContextSame J x y ↔ ∃ B : F → F → Prop, J.Compatible B ∧ B x y :=
  ⟨fun same => ⟨ContextSame J, ContextSame.compatible fn, same⟩,
   fun ⟨_, compatible, related⟩ => Compatible.contextSame compatible related⟩

/-- The context taking a course of moves after a context. -/
def Context.extend : Context F → List (Move F) → Context F
  | c, [] => c
  | c, .withLeft a :: rest => Context.extend (.left a c) rest
  | c, .withRight a :: rest => Context.extend (.right c a) rest

/-- The context taking a course after `c` realizes what the course reaches from what `c`
realizes. -/
theorem Context.realizes_extend (J : Joining F) :
    ∀ (as : List (Move F)) (c : Context F) (x y : F),
      (c.extend as).Realizes J x y ↔ ∃ m, c.Realizes J x m ∧ Trace J.frame.P m as y
  | [], _, _, y => ⟨fun realized => ⟨y, realized, .nil y⟩,
      fun ⟨_, realized, path⟩ => Eq.subst (motive := fun w => Context.Realizes J _ _ w)
        (trace_nil_iff.mp path) realized⟩
  | .withLeft a :: rest, c, x, y =>
    ⟨fun realized => match (Context.realizes_extend J rest (.left a c) x y).mp realized with
      | ⟨_, outer, path⟩ => match (Context.realizes_left J a c x _).mp outer with
        | ⟨n, inner, joined⟩ => ⟨n, inner, .cons joined path⟩,
     fun ⟨n, inner, path⟩ => match trace_cons_iff.mp path with
      | ⟨m, joined, rest'⟩ => (Context.realizes_extend J rest (.left a c) x y).mpr
          ⟨m, (Context.realizes_left J a c x m).mpr ⟨n, inner, joined⟩, rest'⟩⟩
  | .withRight a :: rest, c, x, y =>
    ⟨fun realized => match (Context.realizes_extend J rest (.right c a) x y).mp realized with
      | ⟨_, outer, path⟩ => match (Context.realizes_right J c a x _).mp outer with
        | ⟨n, inner, joined⟩ => ⟨n, inner, .cons joined path⟩,
     fun ⟨n, inner, path⟩ => match trace_cons_iff.mp path with
      | ⟨m, joined, rest'⟩ => (Context.realizes_extend J rest (.right c a) x y).mpr
          ⟨m, (Context.realizes_right J c a x m).mpr ⟨n, inner, joined⟩, rest'⟩⟩

/-- **Agreeing on contexts is passing the same tests of the joining's frame**: the same courses of
joinings are open from each. -/
theorem ContextSame.iff_sameTests {J : Joining F} {x y : F} :
    ContextSame J x y ↔ SameTests J.frame J.frame x y :=
  have open_ (z : F) (as : List (Move F)) :
      (Context.hole.extend as).Possible J z ↔ ∃ t, Trace J.frame.P z as t :=
    ⟨fun ⟨t, realized⟩ => match (Context.realizes_extend J as .hole z t).mp realized with
      | ⟨_, at_, path⟩ => ⟨t, Eq.subst (motive := fun w => Trace J.frame.P w as t)
          (trace_nil_iff.mp at_).symm path⟩,
     fun ⟨t, path⟩ => ⟨t, (Context.realizes_extend J as .hole z t).mpr ⟨z, .nil z, path⟩⟩⟩
  ⟨fun same => ⟨fun as => (open_ x as).symm.trans ((same (Context.hole.extend as)).trans (open_ y as)),
      fun _ c => (nomatch c)⟩,
   fun same c => same.1 c.course⟩

end Joining

end Becoming
