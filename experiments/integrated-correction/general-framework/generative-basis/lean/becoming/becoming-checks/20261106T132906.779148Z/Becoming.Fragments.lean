import Becoming.Presentations

/-!
# Fragments: courses of a process joined where one ends and the next begins

A fragment of a process is a start, a course of moves and a finish (`Fragment`); it is a trace of
the process where the course takes the start to the finish (`Fragment.Traced`). Two traced
fragments join where the first finishes where the second starts, into the fragment of their
courses one after the other (`Fragment.Joint`, `Fragment.Joined`). Joining is functional,
associative, and keeps fragments traced; the fragment that stays at a configuration (`idle`) leaves
every fragment it joins unchanged.

Read through what it joins with, a fragment is its two ends. Asked whether it joins after or
before the fragment that stays at a configuration (`Probe`, `probes`), two traced fragments answer
alike exactly where they start and finish alike (`same_probes_iff_ends`), and these answers recover
joining exactly (`joint_iff_probes`); a presentation reading them exactly recovers joining from
codes alone (`readJoint_iff`). What lies between the ends is not read: two one-move loops by
different moves answer every probe alike (`probes_miss_course`). The process that moves once
(`once`) shows that the ends carry what remains: its passage cannot join itself
(`passage_not_self_joint`), and the two configurations it stays at are told apart
(`idle_ends_apart`).

Every declaration's axiom report is empty. Ported from `Generative.ExplanatoryJoining` (bridge
fold F3E, 18 October 2026); the port is a restatement on the core, not a new result. The
periphery's `budgetProcess` and `spend` are `once` and `passage` here.
-/

universe u v w

namespace Becoming

open Generative
open Becoming.Presentations

/-- A start, a course of moves and a finish. -/
structure Fragment (S : Type u) (A : Type v) where
  start : S
  word : List A
  finish : S

namespace Fragment

variable {S : Type u} {A : Type v} {C : Type w}

/-- A fragment is a trace of a process where its course takes its start to its finish. -/
def Traced (P : Process S A) (f : Fragment S A) : Prop := Trace P f.start f.word f.finish

/-- The fragment staying at a configuration. -/
def idle (s : S) : Fragment S A := ⟨s, [], s⟩

/-- Two fragments one after the other. -/
def merge (f g : Fragment S A) : Fragment S A := ⟨f.start, f.word ++ g.word, g.finish⟩

/-- Two traced fragments join where the first finishes where the second starts. -/
def Joint (P : Process S A) (f g : Fragment S A) : Prop :=
  Traced P f ∧ Traced P g ∧ f.finish = g.start

/-- Two fragments join into a third: they join, and the third is the two one after the other. -/
def Joined (P : Process S A) (f g h : Fragment S A) : Prop := Joint P f g ∧ merge f g = h

/-- The fragment staying at a configuration is traced. -/
theorem idle_traced (P : Process S A) (s : S) : Traced P (idle s : Fragment S A) := .nil s

/-- Two fragments join exactly where they join into something. -/
theorem joint_iff_joined (P : Process S A) (f g : Fragment S A) :
    Joint P f g ↔ ∃ h, Joined P f g h :=
  ⟨fun joint => ⟨merge f g, joint, rfl⟩, fun ⟨_, joined⟩ => joined.1⟩

/-- **Joining is functional.** -/
theorem joined_functional {P : Process S A} {f g h k : Fragment S A} (first : Joined P f g h)
    (second : Joined P f g k) : h = k :=
  first.2.symm.trans second.2

/-- **Two joining fragments, one after the other, are traced.** -/
theorem merge_traced {P : Process S A} {f g : Fragment S A} (joint : Joint P f g) :
    Traced P (merge f g) :=
  trace_append_iff.mpr ⟨f.finish, joint.1,
    Eq.subst (motive := fun s => Trace P s g.word g.finish) joint.2.2.symm joint.2.1⟩

/-- What two fragments join into is traced. -/
theorem joined_traced {P : Process S A} {f g h : Fragment S A} (joined : Joined P f g h) :
    Traced P h :=
  Eq.subst (motive := Traced P) joined.2 (merge_traced joined.1)

/-- **Putting fragments one after the other does not depend on the grouping.** -/
theorem merge_assoc (f g h : Fragment S A) : merge (merge f g) h = merge f (merge g h) :=
  congrArg (fun w => (⟨f.start, w, h.finish⟩ : Fragment S A))
    (ListTests.append_assoc f.word g.word h.word)

/-- A pair joined is joint with what the second joins with. -/
theorem joint_chain_left {P : Process S A} {f g h : Fragment S A} (first : Joint P f g)
    (second : Joint P g h) : Joint P (merge f g) h :=
  ⟨merge_traced first, second.2.1, second.2.2⟩

/-- A fragment is joint with a pair joined, where it is joint with the pair's first. -/
theorem joint_chain_right {P : Process S A} {f g h : Fragment S A} (first : Joint P f g)
    (second : Joint P g h) : Joint P f (merge g h) :=
  ⟨first.1, merge_traced second, first.2.2⟩

/-- **Joining is associative.** -/
theorem joined_assoc (P : Process S A) (f g h k : Fragment S A) :
    (∃ m, Joined P f g m ∧ Joined P m h k) ↔ (∃ n, Joined P g h n ∧ Joined P f n k) :=
  ⟨fun ⟨_, ⟨first, made⟩, ⟨second, made'⟩⟩ =>
    have second' : Joint P (merge f g) h := Eq.subst (motive := fun x => Joint P x h) made.symm second
    have inner : Joint P g h := ⟨first.2.1, second'.2.1, second'.2.2⟩
    ⟨merge g h, ⟨inner, rfl⟩, joint_chain_right first inner,
      (merge_assoc f g h).symm.trans
        (Eq.subst (motive := fun x => merge x h = k) made.symm made')⟩,
   fun ⟨_, ⟨first, made⟩, ⟨second, made'⟩⟩ =>
    have second' : Joint P f (merge g h) := Eq.subst (motive := fun x => Joint P f x) made.symm second
    have outer : Joint P f g := ⟨second'.1, first.1, second'.2.2⟩
    ⟨merge f g, ⟨outer, rfl⟩, joint_chain_left outer first,
      (merge_assoc f g h).trans
        (Eq.subst (motive := fun x => merge f x = k) made.symm made')⟩⟩

/-- The fragment staying at `s` joins before a fragment exactly where that fragment is traced and
starts at `s`. -/
theorem idle_joint_left (P : Process S A) (f : Fragment S A) (s : S) :
    Joint P (idle s) f ↔ Traced P f ∧ s = f.start :=
  ⟨fun joint => ⟨joint.2.1, joint.2.2⟩, fun ⟨traced, at_⟩ => ⟨idle_traced P s, traced, at_⟩⟩

/-- The fragment staying at `s` joins after a fragment exactly where that fragment is traced and
finishes at `s`. -/
theorem idle_joint_right (P : Process S A) (f : Fragment S A) (s : S) :
    Joint P f (idle s) ↔ Traced P f ∧ f.finish = s :=
  ⟨fun joint => ⟨joint.1, joint.2.2⟩, fun ⟨traced, at_⟩ => ⟨traced, idle_traced P s, at_⟩⟩

/-- **Staying at its start before a traced fragment leaves it unchanged.** -/
theorem joined_idle_left {P : Process S A} {f : Fragment S A} (traced : Traced P f) :
    Joined P (idle f.start) f f :=
  ⟨⟨idle_traced P _, traced, rfl⟩, rfl⟩

/-- **Staying at its finish after a traced fragment leaves it unchanged.** -/
theorem joined_idle_right {P : Process S A} {f : Fragment S A} (traced : Traced P f) :
    Joined P f (idle f.finish) f :=
  ⟨⟨traced, idle_traced P _, rfl⟩,
   congrArg (fun w => (⟨f.start, w, f.finish⟩ : Fragment S A)) (ListTests.append_nil f.word)⟩

/-- A probe: whether a fragment joins after, or before, the fragment staying at a configuration. -/
inductive Probe (S : Type u) where
  | before (s : S)
  | after (s : S)

/-- How a fragment answers each probe. -/
def probes (P : Process S A) (f : Fragment S A) : Probe S → Prop
  | .before s => Joint P (idle s) f
  | .after s => Joint P f (idle s)

/-- **Two traced fragments answer the probes alike exactly where they start alike and finish
alike.** -/
theorem same_probes_iff_ends {P : Process S A} {f g : Fragment S A} (traced : Traced P f)
    (traced' : Traced P g) :
    SameAnswers (probes P) f g ↔ f.start = g.start ∧ f.finish = g.finish :=
  ⟨fun same =>
    ⟨((idle_joint_left P g f.start).mp
        ((same (.before f.start)).mp ((idle_joint_left P f f.start).mpr ⟨traced, rfl⟩))).2,
     (((idle_joint_right P g f.finish).mp
        ((same (.after f.finish)).mp ((idle_joint_right P f f.finish).mpr ⟨traced, rfl⟩))).2).symm⟩,
   fun ⟨starts, finishes⟩ q => match q with
    | .before _ => ⟨fun joint => (idle_joint_left P g _).mpr ⟨traced', joint.2.2.trans starts⟩,
        fun joint => (idle_joint_left P f _).mpr ⟨traced, joint.2.2.trans starts.symm⟩⟩
    | .after _ => ⟨fun joint => (idle_joint_right P g _).mpr ⟨traced', finishes.symm.trans joint.2.2⟩,
        fun joint => (idle_joint_right P f _).mpr ⟨traced, finishes.trans joint.2.2⟩⟩⟩

/-- **The probes recover joining**: two fragments join exactly where, at some configuration, the
first joins before staying there and the second after. -/
theorem joint_iff_probes (P : Process S A) (f g : Fragment S A) :
    Joint P f g ↔ ∃ s, probes P f (.after s) ∧ probes P g (.before s) :=
  ⟨fun joint => ⟨f.finish, (idle_joint_right P f _).mpr ⟨joint.1, rfl⟩,
      (idle_joint_left P g _).mpr ⟨joint.2.1, joint.2.2⟩⟩,
   fun ⟨_, first, second⟩ => ⟨first.1, second.2.1, first.2.2.trans second.2.2⟩⟩

/-- **Codes reading the probes exactly keep the ends**: traced fragments given one code start
alike and finish alike. -/
theorem exact_codes_keep_ends {P : Process S A} {p : Presentation (Fragment S A) (Probe S) C}
    (exact : Exact (probes P) p) {f g : Fragment S A} (traced : Traced P f) (traced' : Traced P g)
    (equal : p.encode f = p.encode g) : f.start = g.start ∧ f.finish = g.finish :=
  (same_probes_iff_ends traced traced').mp (equal_codes_same_answers exact equal)

/-- Joining read from codes: some configuration the first code joins before staying at and the
second after. -/
def readJoint (p : Presentation (Fragment S A) (Probe S) C) (a b : C) : Prop :=
  ∃ s, p.read a (.after s) ∧ p.read b (.before s)

/-- **A presentation reading the probes exactly recovers joining from codes alone.** -/
theorem readJoint_iff {P : Process S A} {p : Presentation (Fragment S A) (Probe S) C}
    (exact : Exact (probes P) p) (f g : Fragment S A) :
    readJoint p (p.encode f) (p.encode g) ↔ Joint P f g :=
  ⟨fun ⟨s, first, second⟩ =>
    (joint_iff_probes P f g).mpr ⟨s, (exact f _).mp first, (exact g _).mp second⟩,
   fun joint => match (joint_iff_probes P f g).mp joint with
    | ⟨s, first, second⟩ => ⟨s, (exact f _).mpr first, (exact g _).mpr second⟩⟩

/-- **Fragments answering the probes alike join alike.** -/
theorem joint_iff_of_same_probes {P : Process S A} {f f' g g' : Fragment S A}
    (traced : Traced P f) (traced' : Traced P f') (tracedG : Traced P g) (tracedG' : Traced P g')
    (same : SameAnswers (probes P) f f') (sameG : SameAnswers (probes P) g g') :
    Joint P f g ↔ Joint P f' g' :=
  match (same_probes_iff_ends traced traced').mp same, (same_probes_iff_ends tracedG tracedG').mp sameG with
  | ⟨_, finishes⟩, ⟨starts, _⟩ =>
    ⟨fun joint => ⟨traced', tracedG', finishes.symm.trans (joint.2.2.trans starts)⟩,
     fun joint => ⟨traced, tracedG, finishes.trans (joint.2.2.trans starts.symm)⟩⟩

/-! ## The process that moves once -/

/-- The process that moves once, from `false` to `true`. -/
def once : Process Bool Unit where
  step s _ t := s = false ∧ t = true

/-- Its one passage. -/
def passage : Fragment Bool Unit := ⟨false, [()], true⟩

theorem passage_traced : Traced once passage :=
  trace_singleton_iff.mpr ⟨rfl, rfl⟩

/-- **The passage cannot join itself**: it finishes where it does not start. -/
theorem passage_not_self_joint : ¬ Joint once passage passage :=
  fun joint => Bool.noConfusion joint.2.2

/-- **The probes tell apart the two configurations the process can stay at.** -/
theorem idle_ends_apart : ¬ SameAnswers (probes once) (idle false) (idle true) :=
  fun same => Bool.noConfusion
    ((same_probes_iff_ends (idle_traced once false) (idle_traced once true)).mp same).1

/-! ## What lies between the ends -/

/-- The process with one configuration, moving by either move. -/
def loops : Process Unit Bool where
  step _ _ _ := True

/-- The one-move loop by a move. -/
def loop (a : Bool) : Fragment Unit Bool := ⟨(), [a], ()⟩

theorem loop_traced (a : Bool) : Traced loops (loop a) := trace_singleton_iff.mpr True.intro

/-- **The probes miss the course between the ends**: the loops by the two moves answer every
probe alike, and their courses differ. -/
theorem probes_miss_course :
    SameAnswers (probes loops) (loop false) (loop true) ∧ (loop false).word ≠ (loop true).word :=
  ⟨(same_probes_iff_ends (loop_traced false) (loop_traced true)).mpr ⟨rfl, rfl⟩,
   fun same => Bool.noConfusion (List.cons.inj same).1⟩

end Fragment

end Becoming
