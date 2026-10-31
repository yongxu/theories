import Becoming.GrammarLaws

/-!
# A response common over a reading (共应), on the root

A judgment through the couplings is a common response over the class alike through them (03 §3).
This module states that form on the grammar, for every carrier, every reading and every
requirement, with no choice and no decision. The situations are the grammar's occurrences; a reading
is a relation `E` on them, which situations it does not tell apart; the requirement is a region
`G a` for each act `a`, the situations where `a` is acceptable and can be done. The act is an index
outside `«际»`. Nothing here says which requirement is right: it is supplied, and fixed before the
outcome. It adds one definition and changes no definition of an earlier module.

| name | reading |
|---|---|
| `«共应»` | a response common over `E` within `G`: a region `J a` for each act, inside `G a`, closed under `E`, every situation in some `J a` |

What holds at every situation alike under the reading is the grammar's `«承»` along the converse of
the reading: `«承» («逆» E) P s` is `∀ s', E s s' → P s'`.

* **What holds at every situation alike.** It lies inside the region where the reading is
  reflexive (`«自反则承在内»`), and inside every region exactly then (`«承皆在内当且仅当自反»`); it
  is closed under the reading where the reading is transitive (`«传递则承闭»`), and for every region
  exactly then (`«承皆闭当且仅当传递»`); it holds every region inside the requirement closed under
  the reading, with no hypothesis (`«闭在内则在承»`). Read along the reading's closure (`«所闭»`) it is
  inside and closed for every reading (`«所闭之承在内»`, `«所闭之承闭»`).
* **When a common response exists.** For every reading, a response common over it within the
  requirement exists exactly where every situation has an act whose region holds at every situation
  within its closure under the reading (`«共应当且仅当所闭之承遍»`); for a reflexive and transitive
  reading, along the reading itself (`«序则共应当且仅当承遍»`). The closure is needed: a reading that
  is not reflexive (`«共应之例».NotReflexive`) and one that is not transitive (`«共应之例».NotTransitive`)
  each give every situation such an act along the reading while no common response exists.
* **Finer readings, and none.** A response common over a reading is common over every reading inside
  it (`«共应之细»`); under staying the same (`«静»`) a common response exists exactly where the
  requirement covers every situation (`«静之共应当且仅当遍»`).
* **A rule gives one.** A rule from what a map reads, meeting the requirement at every situation,
  gives a response common over the map's sameness (`«则之共应»`), with no choice. The converse, a
  rule from a common response, needs choice over the readings and is stated where its cases are,
  beside `GuardHorizon.uniform_policy_iff_fiber_feasible`; its calibration is
  `Viability.plans_iff_choice` (03 §9).
* **One act per situation: the lumping law.** Where the requirement gives exactly one act at each
  situation, a response common over a map's sameness exists exactly where situations the map does not
  tell apart have the same act (`«定应共应当且仅当同读同应»`). On the carrier holding situations and
  acts apart, that is the response relation going alike across the map's sameness
  (`«应际同行当且仅当同读同应»`), so by the lumping law it is the image of the response relation along
  the map having a fixed successor (`«定应共应当且仅当像定后»`, through `«像定后当且仅当同行»`).
  `Learning.Lumped` is this condition at an act map. Each hypothesis does work: with a situation that
  has no act the image is determined and no response exists (`«共应之例».NotCovering`); with two acts at
  one situation a response exists and the acts differ (`«共应之例».NotOne`).
* **Not from situations one at a time, nor from pairs.** Every situation having an act does not give a
  common response (`«共应之例».EachNotCommon`, `GuardHorizon.statewise_not_uniform`'s form), and every
  two situations sharing an act does not either (`«共应之例».PairsNotCommon`,
  `ReadingLoop.PairwiseShared`'s form).

Modelling choices: a reading is a relation on situations, supplied (03 §1 derives one from couplings);
the requirement is supplied, the acts an index outside the grammar's relations; the one-carrier
encoding is used only for the lumping law, with situations and acts apart in a sum.
-/

namespace Becoming

universe u v w

section CommonResponse

variable {α : Type u} {A : Type v}

/-- **A response common over a reading, within a requirement (共应).** `J a` is the region where
the response gives act `a`: inside the requirement's region for `a`, closed under the reading, and
every situation in the region of some act. -/
def «共应» (E : «际» α) (G : A → α → Prop) (J : A → α → Prop) : Prop :=
  (∀ a s, J a s → G a s) ∧ (∀ s, ∃ a, J a s) ∧ ∀ a, «闭» E (J a)

/-! ## What holds at every situation alike under the reading -/

/-- What holds at every situation a reflexive reading relates to `s` holds at `s`. -/
theorem «自反则承在内» {E : «际» α} (refl : ∀ s, E s s) {P : α → Prop} {s : α}
    (held : «承» («逆» E) P s) : P s :=
  held s (refl s)

/-- **What holds at every situation alike lies inside every region exactly where the reading is
reflexive.** -/
theorem «承皆在内当且仅当自反» (E : «际» α) :
    (∀ (P : α → Prop) (s : α), «承» («逆» E) P s → P s) ↔ ∀ s, E s s :=
  ⟨fun inside s => inside (E s) s (fun _ related => related),
   fun refl _ _ held => «自反则承在内» refl held⟩

/-- What holds at every situation a transitive reading relates is closed under it. -/
theorem «传递则承闭» {E : «际» α} (trans : ∀ x y z, E x y → E y z → E x z) (P : α → Prop) :
    «闭» E («承» («逆» E) P) :=
  fun x y held related z further => held z (trans x y z related further)

/-- **What holds at every situation alike is closed for every region exactly where the reading is
transitive.** -/
theorem «承皆闭当且仅当传递» (E : «际» α) :
    (∀ P : α → Prop, «闭» E («承» («逆» E) P)) ↔ ∀ x y z, E x y → E y z → E x z :=
  ⟨fun closed x y z related further =>
     closed (E x) x y (fun _ held => held) related z further,
   fun trans P => «传递则承闭» trans P⟩

/-- **A region inside the requirement and closed under the reading lies within what holds at every
situation alike.** No hypothesis on the reading. -/
theorem «闭在内则在承» {E : «际» α} {P Q : α → Prop} (inside : ∀ s, Q s → P s)
    (closed : «闭» E Q) {s : α} (holds : Q s) : «承» («逆» E) P s :=
  fun s' related => inside s' (closed s s' holds related)

/-- Along the reading's closure, what holds at every situation alike lies inside the region. -/
theorem «所闭之承在内» (E : «际» α) {P : α → Prop} {s : α}
    (held : «承» («逆» («所闭» E)) P s) : P s :=
  held s («所闭之自反» E s)

/-- Along the reading's closure, what holds at every situation alike is closed under the reading. -/
theorem «所闭之承闭» (E : «际» α) (P : α → Prop) : «闭» E («承» («逆» («所闭» E)) P) :=
  fun _ _ held related z within => held z («所闭之传递» («缘在所闭» related) within)

/-! ## When a common response exists -/

/-- **A common response exists exactly where every situation has an act holding throughout its
closure under the reading.** For every reading and requirement; no choice, no decision. -/
theorem «共应当且仅当所闭之承遍» (E : «际» α) (G : A → α → Prop) :
    (∃ J, «共应» E G J) ↔ ∀ s, ∃ a, «承» («逆» («所闭» E)) (G a) s :=
  ⟨fun ⟨_, inside, covers, closed⟩ s =>
     match covers s with
     | ⟨a, holds⟩ => ⟨a, fun s' within => inside a s' («闭含所闭» (closed a) holds within)⟩,
   fun each => ⟨fun a => «承» («逆» («所闭» E)) (G a),
     fun _ _ held => «所闭之承在内» E held,
     each,
     fun a => «所闭之承闭» E (G a)⟩⟩

/-- **For a reflexive and transitive reading, along the reading itself.** -/
theorem «序则共应当且仅当承遍» {E : «际» α} (refl : ∀ s, E s s)
    (trans : ∀ x y z, E x y → E y z → E x z) (G : A → α → Prop) :
    (∃ J, «共应» E G J) ↔ ∀ s, ∃ a, «承» («逆» E) (G a) s :=
  ⟨fun ⟨_, inside, covers, closed⟩ s =>
     match covers s with
     | ⟨a, holds⟩ => ⟨a, «闭在内则在承» (inside a) (closed a) holds⟩,
   fun each => ⟨fun a => «承» («逆» E) (G a),
     fun _ _ held => «自反则承在内» refl held,
     each,
     fun a => «传递则承闭» trans (G a)⟩⟩

/-! ## Finer readings, and none -/

/-- **A response common over a reading is common over every reading inside it.** -/
theorem «共应之细» {E E' : «际» α} (finer : «则» E' E) {G J : A → α → Prop}
    (common : «共应» E G J) : «共应» E' G J :=
  ⟨common.1, common.2.1, fun a x y holds related => common.2.2 a x y holds (finer x y related)⟩

/-- **Under staying the same, a common response exists exactly where the requirement covers every
situation.** -/
theorem «静之共应当且仅当遍» (G : A → α → Prop) :
    (∃ J, «共应» «静» G J) ↔ ∀ s, ∃ a, G a s :=
  ⟨fun ⟨_, inside, covers, _⟩ s =>
     match covers s with
     | ⟨a, holds⟩ => ⟨a, inside a s holds⟩,
   fun each => ⟨G, fun _ _ g => g, each,
     fun _ x y g same => (show x = y from same) ▸ g⟩⟩

/-! ## A rule gives a common response -/

/-- **A rule from what a map reads, meeting the requirement at every situation, gives a response
common over the map's sameness.** No choice. -/
theorem «则之共应» {O : Type w} (read : α → O) (G : A → α → Prop) (rule : O → A)
    (meets : ∀ s, G (rule (read s)) s) :
    «共应» (fun s s' => read s = read s') G (fun a s => rule (read s) = a) :=
  ⟨fun _ s gives => gives ▸ meets s,
   fun s => ⟨rule (read s), rfl⟩,
   fun _ _ _ gives same => (congrArg rule same).symm.trans gives⟩

end CommonResponse

/-! ## One act per situation: the lumping law -/

section OneAct

variable {S : Type u} {A : Type v} {O : Type w}

/-- The response relation on situations and acts kept apart: a situation bears it to an act exactly
where the act is in the requirement there. -/
def «应际» (G : A → S → Prop) : «际» (S ⊕ A) :=
  fun x y => Sum.elim (fun s => Sum.elim (fun _ => False) (fun a => G a s) y) (fun _ => False) x

/-- A map's reading of situations, keeping acts as they are. -/
def «读应» (read : S → O) : S ⊕ A → O ⊕ A :=
  Sum.elim (fun s => Sum.inl (read s)) Sum.inr

/-- **The response relation goes alike across what the map reads exactly where situations read
alike have the same act.** No hypothesis on the requirement. -/
theorem «应际同行当且仅当同读同应» (read : S → O) (G : A → S → Prop) :
    «同行» («应际» G) (fun x y => «读应» (A := A) read x = «读应» read y) ↔
      ∀ s s' a a', read s = read s' → G a s → G a' s' → a = a' :=
  ⟨fun alike s s' a a' same g g' =>
     Sum.inr.inj («同行之逐点».mp alike (Sum.inl s) (Sum.inl s') (congrArg Sum.inl same)
       (Sum.inr a) (Sum.inr a') g g'),
   fun lumped => «同行之逐点».mpr fun x x' same y y' r r' =>
     match x, x', y, y', same, r, r' with
     | Sum.inl s, Sum.inl s', Sum.inr a, Sum.inr a', same, r, r' =>
       congrArg Sum.inr (lumped s s' a a' (Sum.inl.inj same) r r')
     | Sum.inl _, _, Sum.inl _, _, _, r, _ => False.elim r
     | Sum.inr _, _, _, _, _, r, _ => False.elim r
     | Sum.inl _, Sum.inl _, Sum.inr _, Sum.inl _, _, _, r' => False.elim r'
     | Sum.inl _, Sum.inr _, Sum.inr _, _, _, _, r' => False.elim r'⟩

/-- **With exactly one act at each situation, a response common over the map's sameness exists
exactly where situations read alike have the same act.** -/
theorem «定应共应当且仅当同读同应» (read : S → O) (G : A → S → Prop)
    (covers : ∀ s, ∃ a, G a s) (one : ∀ s a a', G a s → G a' s → a = a') :
    (∃ J, «共应» (fun s s' => read s = read s') G J) ↔
      ∀ s s' a a', read s = read s' → G a s → G a' s' → a = a' :=
  ⟨fun ⟨_, inside, has, closed⟩ s s' a a' same g g' =>
     match has s with
     | ⟨b, holds⟩ =>
       (one s a b g (inside b s holds)).trans
         (one s' a' b g' (inside b s' (closed b s s' holds same))).symm,
   fun lumped => ⟨G, fun _ _ g => g, covers,
     fun a x y g same =>
       match covers y with
       | ⟨b, g'⟩ => (lumped x y a b same g g').symm ▸ g'⟩⟩

/-- **With exactly one act at each situation, a common response over the map's sameness exists
exactly where the image of the response relation along the map has a fixed successor**: the lumping
law (`«像定后当且仅当同行»`) read at a response. -/
theorem «定应共应当且仅当像定后» (read : S → O) (G : A → S → Prop)
    (covers : ∀ s, ∃ a, G a s) (one : ∀ s a a', G a s → G a' s → a = a') :
    (∃ J, «共应» (fun s s' => read s = read s') G J) ↔ «定后» («像» («读应» read) («应际» G)) :=
  («定应共应当且仅当同读同应» read G covers one).trans
    ((«应际同行当且仅当同读同应» read G).symm.trans «像定后当且仅当同行».symm)

end OneAct

/-! ## Witnesses -/

namespace «共应之例»

/-! A reading that is not reflexive: on one situation, nothing related, nothing acceptable. -/
namespace NotReflexive

def E : «际» Unit := fun _ _ => False
def G : Unit → Unit → Prop := fun _ _ => False

/-- Every situation has an act holding at every situation the reading relates to it. -/
theorem held_each : ∀ s, ∃ a, «承» («逆» E) (G a) s :=
  fun _ => ⟨(), fun _ related => False.elim related⟩

/-- No common response exists. -/
theorem none : ¬ ∃ J, «共应» E G J :=
  fun ⟨_, inside, covers, _⟩ => match covers () with
    | ⟨a, holds⟩ => inside a () holds

end NotReflexive

/-! A reading that is not transitive: the path of four situations, each related to itself and its
neighbours; the first needs `true`, the last `false`. -/
namespace NotTransitive

inductive Point where
  | p0
  | p1
  | p2
  | p3

def E : «际» Point
  | .p0, .p0 => True
  | .p0, .p1 => True
  | .p0, .p2 => False
  | .p0, .p3 => False
  | .p1, .p0 => True
  | .p1, .p1 => True
  | .p1, .p2 => True
  | .p1, .p3 => False
  | .p2, .p0 => False
  | .p2, .p1 => True
  | .p2, .p2 => True
  | .p2, .p3 => True
  | .p3, .p0 => False
  | .p3, .p1 => False
  | .p3, .p2 => True
  | .p3, .p3 => True

def G (a : Bool) : Point → Prop
  | .p0 => a = true
  | .p1 => True
  | .p2 => True
  | .p3 => a = false

/-- Every situation has an act holding at every situation the reading relates to it. -/
theorem held_each : ∀ s, ∃ a, «承» («逆» E) (G a) s
  | .p0 => ⟨true, fun b related => match b, related with
      | .p0, _ => rfl
      | .p1, _ => True.intro
      | .p2, related => False.elim related
      | .p3, related => False.elim related⟩
  | .p1 => ⟨true, fun b related => match b, related with
      | .p0, _ => rfl
      | .p1, _ => True.intro
      | .p2, _ => True.intro
      | .p3, related => False.elim related⟩
  | .p2 => ⟨false, fun b related => match b, related with
      | .p0, related => False.elim related
      | .p1, _ => True.intro
      | .p2, _ => True.intro
      | .p3, _ => rfl⟩
  | .p3 => ⟨false, fun b related => match b, related with
      | .p0, related => False.elim related
      | .p1, related => False.elim related
      | .p2, _ => True.intro
      | .p3, _ => rfl⟩

/-- No common response exists. -/
theorem none : ¬ ∃ J, «共应» E G J :=
  fun ⟨J, inside, covers, closed⟩ =>
    match covers .p0 with
    | ⟨a, holds⟩ =>
      have at3 : J a .p3 :=
        closed a .p2 .p3 (closed a .p1 .p2 (closed a .p0 .p1 holds True.intro) True.intro)
          True.intro
      have first : a = true := inside a .p0 holds
      have last : a = false := inside a .p3 at3
      Bool.noConfusion (first.symm.trans last)

end NotTransitive

/-! An act at each situation, and no common response: two situations read alike, each needing its
own act (`GuardHorizon.statewise_not_uniform`'s form). -/
namespace EachNotCommon

def G (a s : Bool) : Prop := a = s

theorem each : ∀ s, ∃ a, G a s := fun s => ⟨s, rfl⟩

theorem none : ¬ ∃ J, «共应» «一» G J :=
  fun ⟨_, inside, covers, closed⟩ =>
    match covers true with
    | ⟨a, holds⟩ =>
      have first : a = true := inside a true holds
      have other : a = false := inside a false (closed a true false holds True.intro)
      Bool.noConfusion (first.symm.trans other)

end EachNotCommon

/-! Every two situations share an act, and no act serves all three
(`ReadingLoop.PairwiseShared`'s form). -/
namespace PairsNotCommon

inductive Point where
  | p
  | q
  | r

/-- An act is acceptable at a situation where it is not the act that situation names. -/
def G : Point → Point → Prop
  | .p, .p => False
  | .q, .q => False
  | .r, .r => False
  | .p, .q => True
  | .p, .r => True
  | .q, .p => True
  | .q, .r => True
  | .r, .p => True
  | .r, .q => True

theorem pairs : ∀ s s' : Point, ∃ a, G a s ∧ G a s'
  | .p, .p => ⟨.q, True.intro, True.intro⟩
  | .p, .q => ⟨.r, True.intro, True.intro⟩
  | .p, .r => ⟨.q, True.intro, True.intro⟩
  | .q, .p => ⟨.r, True.intro, True.intro⟩
  | .q, .q => ⟨.p, True.intro, True.intro⟩
  | .q, .r => ⟨.p, True.intro, True.intro⟩
  | .r, .p => ⟨.q, True.intro, True.intro⟩
  | .r, .q => ⟨.p, True.intro, True.intro⟩
  | .r, .r => ⟨.p, True.intro, True.intro⟩

theorem none : ¬ ∃ J, «共应» «一» G J :=
  fun ⟨_, inside, covers, closed⟩ =>
    match covers .p with
    | ⟨.p, holds⟩ => inside .p .p holds
    | ⟨.q, holds⟩ => inside .q .q (closed .q .p .q holds True.intro)
    | ⟨.r, holds⟩ => inside .r .r (closed .r .p .r holds True.intro)

end PairsNotCommon

/-! With a situation that has no act, the image is determined and no common response exists. -/
namespace NotCovering

def G : Unit → Unit → Prop := fun _ _ => False

theorem fixed : «定后» («像» («读应» (A := Unit) (fun _ : Unit => ())) («应际» G)) :=
  fun _ _ ⟨_, ⟨x, u, _, r, _⟩, _⟩ =>
    match x, u, r with
    | Sum.inl _, Sum.inr _, r => False.elim r
    | Sum.inl _, Sum.inl _, r => False.elim r
    | Sum.inr _, _, r => False.elim r

theorem none : ¬ ∃ J, «共应» (fun s s' : Unit => (fun _ => ()) s = (fun _ => ()) s') G J :=
  fun ⟨_, inside, covers, _⟩ => match covers () with
    | ⟨a, holds⟩ => inside a () holds

end NotCovering

/-! With two acts at one situation, a common response exists while situations read alike have
different acts. -/
namespace NotOne

def G : Bool → Unit → Prop := fun _ _ => True

theorem common : ∃ J, «共应» (fun s s' : Unit => (fun _ => ()) s = (fun _ => ()) s') G J :=
  ⟨G, fun _ _ g => g, fun _ => ⟨true, True.intro⟩, fun _ _ _ g _ => g⟩

theorem differ : ¬ ∀ s s' : Unit, ∀ a a' : Bool, (fun _ => ()) s = (fun _ => ()) s' →
    G a s → G a' s' → a = a' :=
  fun lumped => Bool.noConfusion (lumped () () true false rfl True.intro True.intro)

end NotOne

end «共应之例»

end Becoming
