import Becoming.GrammarLaws

/-!
# A response common over a reading (共应), on the root

A judgment through the couplings is a common response over the class alike through them (03 §3).
This module states that form on the grammar, for every carrier, every reading and every
requirement, with no choice and no decision. The situations are the grammar's occurrences; a reading
is a relation `E` on them, which situations it does not tell apart; the requirement is a region
`G a` for each act `a`, the situations where `a` is acceptable and can be done. The act is an index
outside `«际»`. Nothing here says which requirement is right: it is supplied, and fixed before the
outcome. It adds three definitions, `«共应»` and, for the lumping law's encoding, `«应际»` and
`«读应»`, and changes no definition of an earlier module.

| name | reading |
|---|---|
| `«共应»` | a response common over `E` within `G`: a region `J a` for each act, inside `G a`, closed under `E`, every situation in some `J a` (the regions may overlap) |
| `«应际»` | the response relation on situations and acts kept apart (`S ⊕ A`) |
| `«读应»` | a map's reading of situations on that carrier, acts kept as they are |

What holds at every situation alike under the reading is the grammar's `«承»` along the converse of
the reading: `«承» («逆» E) P s` is `∀ s', E s s' → P s'`.

* **The kernel.** Along the reading's closure (`«所闭»`), what holds at every situation alike is the
  largest region inside `P` closed under the reading (`«所闭之承最大»`): it lies inside `P`
  (`«所闭之承在内»`), is closed (`«所闭之承闭»`), and holds every region inside `P` closed under the
  reading (`«闭在内则在所闭之承»`), for every relation. At a process's steps it is the viability
  kernel, the largest certificate (`Viability.kernel_iff_held`). Along the reading itself, without
  the closure, it lies inside every region exactly where the reading is reflexive
  (`«诸承在内当且仅当自反»`), is closed for every region exactly where it is transitive
  (`«诸承闭当且仅当传递»`), and holds every region inside `P` closed under the reading with no
  hypothesis (`«闭在内则在承»`).
* **When a common response exists.** For every reading, a response common over it within the
  requirement exists exactly where the acts' kernels cover the situations: every situation has an act
  whose region holds at every situation within its closure under the reading
  (`«共应当且仅当所闭之承遍»`); for a reflexive and transitive reading, along the reading itself
  (`«自反传递则共应当且仅当承遍»`). The regions of a common response may overlap, so it is a closed
  admissible relation from situations to acts, not a rule; one act fixed for each class is a rule,
  which needs choice. The closure is needed: a reading that is not reflexive, though transitive
  (`«共应之例».NotReflexive`), and one that is not transitive, though reflexive and symmetric
  (`«共应之例».NotTransitive`), each give every situation such an act along the reading while no
  common response exists.
* **Finer readings, none, and all.** A response common over a reading is common over every reading
  inside it (`«共应之细»`); under staying the same (`«静»`) a common response exists exactly where the
  requirement covers every situation (`«静之共应当且仅当遍»`); under the reading that tells nothing
  apart (`«一»`), on an inhabited carrier, exactly where one act meets the requirement everywhere
  (`«一之共应当且仅当一应遍»`).
* **A rule gives one.** A rule from what a map reads, meeting the requirement at every situation,
  gives a response common over the map's sameness (`«依读而应则共应»`), with no choice. The converse,
  a rule from a common response, is not proved here: it asks for one act chosen for each reading,
  which GuardHorizon has with choice over the readings as a hypothesis
  (`GuardHorizon.uniform_policy_iff_fiber_feasible`); that such choice cannot be dropped is proved
  for plans (`Viability.plans_iff_choice`, 03 §9), not for this rule.
* **One act per situation: the lumping law.** Where the requirement gives exactly one act at each
  situation, a response common over a map's sameness exists exactly where situations the map does not
  tell apart have the same act (`«遍定应共应当且仅当同读同应»`). On the carrier holding situations and
  acts apart, that is the response relation going alike across the map's sameness
  (`«应际同行当且仅当同读同应»`), so by the lumping law it is the image of the response relation along
  the map having a fixed successor (`«遍定应共应当且仅当像定后»`, through `«像定后当且仅当同行»`).
  With an act map, the condition is that situations read alike get the same act
  (`«映应共应当且仅当同读同应»`), which is `Learning.Lumped` of the map and the act map, unfolded.
  Each hypothesis does work: with a situation that has no act the image is determined and no response
  exists (`«共应之例».NotCovering`); with two acts at one situation a response exists and the acts
  differ (`«共应之例».NotOne`); with situations and acts on one carrier the image is determined and
  no response exists (`«共应之例».OneCarrier`), so the sum carrier is needed.
* **Not from situations one at a time, nor from pairs.** Every situation having an act does not give a
  common response (`«共应之例».EachNotCommon`, the example of `GuardHorizon.statewise_not_uniform`),
  and every two situations sharing an act does not either (`«共应之例».PairsNotCommon`, the example of
  `ReadingLoop.PairwiseShared` and `AssurancePlans.Routes`).

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
every situation in the region of some act. The regions may overlap: a situation may have several
acts, and one act fixed for each class is a rule, which needs choice. -/
def «共应» (E : «际» α) (G : A → α → Prop) (J : A → α → Prop) : Prop :=
  (∀ a s, J a s → G a s) ∧ (∀ s, ∃ a, J a s) ∧ ∀ a, «闭» E (J a)

/-! ## What holds at every situation alike under the reading -/

/-- What holds at every situation a reflexive reading relates to `s` holds at `s`. -/
theorem «自反则承在内» {E : «际» α} (refl : ∀ s, E s s) {P : α → Prop} {s : α}
    (held : «承» («逆» E) P s) : P s :=
  held s (refl s)

/-- **What holds at every situation alike lies inside every region exactly where the reading is
reflexive.** -/
theorem «诸承在内当且仅当自反» (E : «际» α) :
    (∀ (P : α → Prop) (s : α), «承» («逆» E) P s → P s) ↔ ∀ s, E s s :=
  ⟨fun inside s => inside (E s) s (fun _ related => related),
   fun refl _ _ held => «自反则承在内» refl held⟩

/-- What holds at every situation a transitive reading relates is closed under it. -/
theorem «传递则承闭» {E : «际» α} (trans : ∀ x y z, E x y → E y z → E x z) (P : α → Prop) :
    «闭» E («承» («逆» E) P) :=
  fun x y held related z further => held z (trans x y z related further)

/-- **What holds at every situation alike is closed for every region exactly where the reading is
transitive.** -/
theorem «诸承闭当且仅当传递» (E : «际» α) :
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

/-- A region inside `P` and closed under the reading lies within what holds throughout the
reading's closure. No hypothesis on the reading. -/
theorem «闭在内则在所闭之承» {E : «际» α} {P Q : α → Prop} (inside : ∀ s, Q s → P s)
    (closed : «闭» E Q) {s : α} (holds : Q s) : «承» («逆» («所闭» E)) P s :=
  fun s' within => inside s' («闭含所闭» closed holds within)

/-- **The kernel.** What holds throughout the reading's closure is the largest region inside `P`
closed under the reading: inside, closed, and holding every other such region. For every relation;
at a process's steps it is the invariance kernel. -/
theorem «所闭之承最大» (E : «际» α) (P : α → Prop) :
    (∀ s, «承» («逆» («所闭» E)) P s → P s) ∧ «闭» E («承» («逆» («所闭» E)) P) ∧
      ∀ Q : α → Prop, (∀ s, Q s → P s) → «闭» E Q → ∀ s, Q s → «承» («逆» («所闭» E)) P s :=
  ⟨fun _ held => «所闭之承在内» E held, «所闭之承闭» E P,
   fun _ inside closed _ holds => «闭在内则在所闭之承» inside closed holds⟩

/-! ## When a common response exists -/

/-- **A common response exists exactly where the acts' kernels cover the situations**: every
situation has an act holding throughout its closure under the reading. For every reading and
requirement; no choice, no decision. -/
theorem «共应当且仅当所闭之承遍» (E : «际» α) (G : A → α → Prop) :
    (∃ J, «共应» E G J) ↔ ∀ s, ∃ a, «承» («逆» («所闭» E)) (G a) s :=
  ⟨fun ⟨_, inside, covers, closed⟩ s =>
     match covers s with
     | ⟨a, holds⟩ => ⟨a, «闭在内则在所闭之承» (inside a) (closed a) holds⟩,
   fun each => ⟨fun a => «承» («逆» («所闭» E)) (G a),
     fun _ _ held => «所闭之承在内» E held,
     each,
     fun a => «所闭之承闭» E (G a)⟩⟩

/-- **For a reflexive and transitive reading, along the reading itself.** -/
theorem «自反传递则共应当且仅当承遍» {E : «际» α} (refl : ∀ s, E s s)
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

/-- **Under the reading that tells nothing apart, on an inhabited carrier, a common response exists
exactly where one act meets the requirement everywhere.** -/
theorem «一之共应当且仅当一应遍» (s₀ : α) (G : A → α → Prop) :
    (∃ J, «共应» «一» G J) ↔ ∃ a, ∀ s, G a s :=
  ⟨fun ⟨_, inside, covers, closed⟩ => match covers s₀ with
     | ⟨a, holds⟩ => ⟨a, fun s => inside a s (closed a s₀ s holds True.intro)⟩,
   fun ⟨a, all⟩ => ⟨fun b _ => b = a, fun _ s same => same ▸ all s, fun _ => ⟨a, rfl⟩,
     fun _ _ _ same _ => same⟩⟩

/-! ## A rule gives a common response -/

/-- **A rule from what a map reads, meeting the requirement at every situation, gives a response
common over the map's sameness.** No choice. -/
theorem «依读而应则共应» {O : Type w} (read : α → O) (G : A → α → Prop) (rule : O → A)
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
theorem «遍定应共应当且仅当同读同应» (read : S → O) (G : A → S → Prop)
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
theorem «遍定应共应当且仅当像定后» (read : S → O) (G : A → S → Prop)
    (covers : ∀ s, ∃ a, G a s) (one : ∀ s a a', G a s → G a' s → a = a') :
    (∃ J, «共应» (fun s s' => read s = read s') G J) ↔ «定后» («像» («读应» read) («应际» G)) :=
  («遍定应共应当且仅当同读同应» read G covers one).trans
    ((«应际同行当且仅当同读同应» read G).symm.trans «像定后当且仅当同行».symm)

/-- **With an act map, a response common over a map's sameness exists exactly where situations the
map does not tell apart get the same act**: `Learning.Lumped` of the map and the act map, stated
unfolded. -/
theorem «映应共应当且仅当同读同应» (read : S → O) (act : S → A) :
    (∃ J, «共应» (fun s s' => read s = read s') (fun a s => act s = a) J) ↔
      ∀ s s', read s = read s' → act s = act s' :=
  («遍定应共应当且仅当同读同应» read (fun a s => act s = a) (fun s => ⟨act s, rfl⟩)
      (fun _ _ _ g g' => g.symm.trans g')).trans
    ⟨fun lumped s s' same => lumped s s' (act s) (act s') same rfl rfl,
     fun lumped s s' _ _ same g g' => g.symm.trans ((lumped s s' same).trans g')⟩

end OneAct

/-! ## Witnesses -/

namespace «共应之例»

/-! A reading that is not reflexive, though transitive: on one situation, nothing related, nothing
acceptable. -/
namespace NotReflexive

def E : «际» Unit := fun _ _ => False
def G : Unit → Unit → Prop := fun _ _ => False

/-- The reading is transitive: only reflexivity fails. -/
theorem trans : ∀ x y z, E x y → E y z → E x z := fun _ _ _ related _ => related

/-- Every situation has an act holding at every situation the reading relates to it. -/
theorem held_each : ∀ s, ∃ a, «承» («逆» E) (G a) s :=
  fun _ => ⟨(), fun _ related => False.elim related⟩

/-- No common response exists. -/
theorem none : ¬ ∃ J, «共应» E G J :=
  fun ⟨_, inside, covers, _⟩ => match covers () with
    | ⟨a, holds⟩ => inside a () holds

end NotReflexive

/-! A reading that is not transitive, though reflexive and symmetric: the path of four situations,
each related to itself and its neighbours; the first needs `true`, the last `false`. -/
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

/-- The reading is reflexive: only transitivity fails. -/
theorem refl : ∀ s, E s s
  | .p0 => True.intro
  | .p1 => True.intro
  | .p2 => True.intro
  | .p3 => True.intro

/-- The reading is symmetric. -/
theorem symm : ∀ x y, E x y → E y x
  | .p0, .p0, _ => True.intro
  | .p0, .p1, _ => True.intro
  | .p0, .p2, related => False.elim related
  | .p0, .p3, related => False.elim related
  | .p1, .p0, _ => True.intro
  | .p1, .p1, _ => True.intro
  | .p1, .p2, _ => True.intro
  | .p1, .p3, related => False.elim related
  | .p2, .p0, related => False.elim related
  | .p2, .p1, _ => True.intro
  | .p2, .p2, _ => True.intro
  | .p2, .p3, _ => True.intro
  | .p3, .p0, related => False.elim related
  | .p3, .p1, related => False.elim related
  | .p3, .p2, _ => True.intro
  | .p3, .p3, _ => True.intro

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
own act (the example of `GuardHorizon.statewise_not_uniform`). -/
namespace EachNotCommon

def G (a s : Bool) : Prop := a = s

theorem each : ∀ s, ∃ a, G a s := fun s => ⟨s, rfl⟩

theorem none : ¬ ∃ J, «共应» «一» G J :=
  fun common => match («一之共应当且仅当一应遍» true G).mp common with
    | ⟨_, all⟩ => Bool.noConfusion ((all true).symm.trans (all false))

end EachNotCommon

/-! Every two situations share an act, and no act serves all three (the example of
`ReadingLoop.PairwiseShared` and `AssurancePlans.Routes`). -/
namespace PairsNotCommon

inductive Point where
  | p
  | q
  | r

/-- An act is acceptable at a situation where it is not the act that situation names. -/
abbrev G (a s : Point) : Prop := a ≠ s

theorem pairs : ∀ s s' : Point, ∃ a, G a s ∧ G a s'
  | .p, .p => ⟨.q, (fun h => nomatch h), (fun h => nomatch h)⟩
  | .p, .q => ⟨.r, (fun h => nomatch h), (fun h => nomatch h)⟩
  | .p, .r => ⟨.q, (fun h => nomatch h), (fun h => nomatch h)⟩
  | .q, .p => ⟨.r, (fun h => nomatch h), (fun h => nomatch h)⟩
  | .q, .q => ⟨.p, (fun h => nomatch h), (fun h => nomatch h)⟩
  | .q, .r => ⟨.p, (fun h => nomatch h), (fun h => nomatch h)⟩
  | .r, .p => ⟨.q, (fun h => nomatch h), (fun h => nomatch h)⟩
  | .r, .q => ⟨.p, (fun h => nomatch h), (fun h => nomatch h)⟩
  | .r, .r => ⟨.p, (fun h => nomatch h), (fun h => nomatch h)⟩

theorem none : ¬ ∃ J, «共应» «一» G J :=
  fun common => match («一之共应当且仅当一应遍» Point.p G).mp common with
    | ⟨a, all⟩ => all a rfl

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

/-! With situations and acts on one carrier, the image along the reading is determined and no
common response exists: the lumping law needs situations and acts apart. -/
namespace OneCarrier

/-- The requirement as a relation on one carrier: act `a` at `s` exactly where `a = s`. -/
def R : «际» Bool := fun s a => a = s

/-- The image along the constant reading has a fixed successor. -/
theorem fixed : «定后» («像» (fun _ : Bool => ()) R) :=
  fun x y _ => match x, y with | (), () => rfl

/-- No response common over the reading's sameness exists. -/
theorem none :
    ¬ ∃ J, «共应» (fun s s' : Bool => (fun _ => ()) s = (fun _ => ()) s') (fun a s => R s a) J :=
  fun ⟨_, inside, covers, closed⟩ => match covers true with
    | ⟨a, holds⟩ =>
      have first : a = true := inside a true holds
      have other : a = false := inside a false (closed a true false holds rfl)
      Bool.noConfusion (first.symm.trans other)

end OneCarrier

end «共应之例»

end Becoming
