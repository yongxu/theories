import Becoming.CensusCounts
import Becoming.Standing

/-!
# Census binding: the laws of counting where the premises bind, where the counts exist

`Becoming.CensusCounts` states the laws of counting under the premises, each selection,
enclosure and finite worlds over counted censuses: the counts of a census taken as relations
(`World.CountsOf`), with no decision procedure for activity and for every property of the counts
(`World.CountsHold`). This module does the same for the laws where the selected premises bind
(`World.binding_counting` and its family in `Becoming.Counting`), which quantify over worlds
`[∀ t x, Decidable (w.web.active t x)]` and hold for pointwise properties only.

* **What binding leaves in the counts** is stated in `Becoming.Counting`, with the counted
  soundness of each law there: where something is active at a step a counted census counts
  something there (`World.CountsOf.active_pos`), where embodiment binds something arises in every
  counted census (`World.binds_arising_counted`), and the instances leaving something active and
  something arising across a step at which something is active
  (`World.CountsOf.acts_of_binding`, `World.CountsOf.joint_of_binding`). Under the eight premises
  something arising is no law (`World.binds_adds_counted`).
* **The laws where every premise binds**: the tally, nothing arising across a step at which
  nothing is active, and something arising (`World.binding_counting_counted`); in finite worlds
  and in worlds enclosed from some step on, with a change bound from the first step
  (`World.finite_binding_counting_counted`, `World.enclosed_binding_counting_counted`).
* **The laws where the premises of each selection bind**, with the three that binding adds:
  something active, something arising, and something arising across a step at which something is
  active, each where the selection gives it (`World.binding_counting_under_counted`), in finite
  worlds (`World.finite_binding_counting_under_counted`; with the census selected, every property
  is a law vacuously, `World.finite_binding_census_counted`) and under enclosure
  (`World.enclosed_binding_counting_under_counted`); and the equivalences saying where each of the
  three is a law (`…_activity_iff_counted`, `…_arising_iff_counted`, `…_joint_iff_counted`).
* **The rest of the family.** The premises leave counting free, already under every premise but
  embodiment or but balance (`World.counting_free_parts_counted`); balance and embodiment bind
  the counts together, and neither does alone (`World.counting_binds_jointly_counted`); worlds
  enclosed from some step on and finite worlds have the same laws under the eight
  (`World.enclosed_iff_finite_counting_counted`), and under a selection exactly where it bounds
  change and binds counting (`World.enclosed_iff_finite_counting_under_counted`); read on what
  stands, the laws under each selection are those of counted censuses
  (`World.standing_iff_counting_counted`).

Each law is for every property of the counts and with no decidedness. Each is a census table
(`World.table_holds`, `Becoming.CensusTable`) whose counted soundness and witness lemma
are those of the decided law in `Becoming.Counting` (`World.binding_counting_sound`,
`World.binding_counting_witnessed` and their family), so the counted and the decided form come
from one proof. Each equivalence saying where a law is one (`…_activity_iff_counted`,
`…_arising_iff_counted`, `…_joint_iff_counted`) is the counted law, the decided law with a proof
that its property is pointwise, and the decided equivalence, composed; finite and enclosed worlds
agree under a selection, for every property and for pointwise ones, by one tally lemma
(`World.enclosed_iff_finite_tally`). Where a procedure decides activity, these laws give the
decided ones (`World.CountsHold.marks`). The decided statements stay, with their scope.
-/

namespace Becoming

namespace World

variable {w : World}

/-- Under the eight premises something arising is no law of counting, where the counts exist:
the empty tally is counted. -/
theorem binds_adds_counted :
    ¬ ∀ w : World, w.Premised → w.CountsHold fun _ _ a => ∃ t, 0 < a t :=
  fun law => match (premised_counting_counted (Q := fun _ _ a => ∃ t, 0 < a t)).mpr law
      (fun _ => 0) (fun _ => 0) (fun _ => 0) (fun _ => ⟨0, rfl, rfl⟩) (fun _ no => no) with
    | ⟨_, no⟩ => Nat.lt_irrefl 0 no

/-- **Where every premise binds, where the counts exist**, the laws of counting under the eight
are the tally, that nothing arises across a step at which nothing is active, and that something
arises: for every property, with no decidedness. -/
theorem binding_counting_counted {Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop} :
    (∀ n c a, Tally n c a → (∀ t, 0 < a t → 0 < n t) → (∃ t, 0 < a t) → Q n c a) ↔
      ∀ w : World, w.Premised → w.Binds → w.CountsHold Q :=
  census_table_holds₂ binding_counting_sound binding_counting_witnessed

/-- **The laws of counting where the premises of each selection bind, where the counts exist**:
those of `World.counting_under_counted` and three more, something active where activity needing
support, only active relata giving or only active relata taking is selected; something arising
where embodiment is; and something arising across a step at which something is active where
embodiment, only active relata giving and bounded transmission are. For every property, with no
decidedness. -/
theorem binding_counting_under_counted (S : Premise → Bool)
    {Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop} :
    (∀ n c a, Tally n c a → (BindsCounting S → ∀ t, 0 < a t → 0 < n t) →
      (S .dependent = true ∨ S .acting = true ∨ S .taking = true → ∃ t, 0 < n t) →
      (S .embodied = true → ∃ t, 0 < a t) →
      (S .embodied = true → S .acting = true → S .transmitting = true →
        ∃ t, 0 < n t ∧ 0 < a t) → Q n c a) ↔
      ∀ w : World, w.Meets S → (∀ p, S p = true → p.Binds w) → w.CountsHold Q :=
  have table := table_holds (Q := Q) (binding_counting_under_sound S)
    (binding_counting_under_witnessed S)
  ⟨fun law w meets binds => table.mp (fun n c a tally ⟨quiet, acts, arises, joint⟩ =>
      law n c a tally quiet acts arises joint) w ⟨meets, binds⟩,
   fun law n c a tally quiet acts arises joint => table.mpr (fun w ⟨meets, binds⟩ =>
      law w meets binds) n c a tally ⟨quiet, acts, arises, joint⟩⟩

/-- So, where the counts exist, binding adds that something is active exactly where activity
needing support, only active relata giving, only active relata taking or embodiment is
selected. -/
theorem binding_activity_iff_counted (S : Premise → Bool) :
    (∀ w : World, w.Meets S → (∀ p, S p = true → p.Binds w) →
      w.CountsHold fun n _ _ => ∃ t, 0 < n t) ↔
      S .dependent = true ∨ S .acting = true ∨ S .taking = true ∨ S .embodied = true :=
  ((binding_counting_under_counted S).symm.trans
    (binding_counting_under S
      (fun same ⟨t, pos⟩ => ⟨t, Nat.lt_of_lt_of_le pos (Nat.le_of_eq (same t).1)⟩))).trans
    (binding_activity_iff S)

/-- Where the counts exist, binding adds that something arises exactly where embodiment is
selected. -/
theorem binding_arising_iff_counted (S : Premise → Bool) :
    (∀ w : World, w.Meets S → (∀ p, S p = true → p.Binds w) →
      w.CountsHold fun _ _ a => ∃ t, 0 < a t) ↔ S .embodied = true :=
  ((binding_counting_under_counted S).symm.trans
    (binding_counting_under S
      (fun same ⟨t, pos⟩ => ⟨t, Nat.lt_of_lt_of_le pos (Nat.le_of_eq (same t).2.2)⟩))).trans
    (binding_arising_iff S)

/-- And, where the counts exist, that something arises across a step at which something is
active exactly where embodiment is selected and either the selection binds counting or only
active relata giving and bounded transmission are selected. -/
theorem binding_joint_iff_counted (S : Premise → Bool) :
    (∀ w : World, w.Meets S → (∀ p, S p = true → p.Binds w) →
      w.CountsHold fun n _ a => ∃ t, 0 < n t ∧ 0 < a t) ↔
      S .embodied = true ∧ (BindsCounting S ∨ S .acting = true ∧ S .transmitting = true) :=
  ((binding_counting_under_counted S).symm.trans
    (binding_counting_under S
      (fun same ⟨t, active, arising⟩ => ⟨t,
        Nat.lt_of_lt_of_le active (Nat.le_of_eq (same t).1),
        Nat.lt_of_lt_of_le arising (Nat.le_of_eq (same t).2.2)⟩))).trans
    (binding_joint_iff S)

/-- **In finite worlds in which every premise but the census binds, where the counts exist**,
the laws of counting under the eight are those of finite worlds and that something arises: for
every property, with no decidedness. -/
theorem finite_binding_counting_counted {Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop} :
    (∀ n c a, Tally n c a → (∀ t, 0 < a t → 0 < n t) → (∃ B, ChangeBound 0 B n c a) →
      (∃ t, 0 < a t) → Q n c a) ↔
      ∀ w : World, w.Premised → w.Finite → (∀ p : Premise, p ≠ .counted → p.Binds w) →
        w.CountsHold Q :=
  have table := table_holds (Q := Q) finite_binding_counting_sound
    finite_binding_counting_witnessed
  ⟨fun law w premised finite binds => table.mp (fun n c a tally ⟨company, bound, arises⟩ =>
      law n c a tally company bound arises) w ⟨premised, finite, binds⟩,
   fun law n c a tally company bound arises => table.mpr (fun w ⟨premised, finite, binds⟩ =>
      law w premised finite binds) n c a tally ⟨company, bound, arises⟩⟩

/-- **Under enclosure from some step on, where every premise binds, where the counts exist**,
the laws of counting are those under enclosure and that something arises: for every property,
with no decidedness. -/
theorem enclosed_binding_counting_counted {Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop} :
    (∀ n c a, Tally n c a → (∀ t, 0 < a t → 0 < n t) → (∃ B, ChangeBound 0 B n c a) →
      (∃ t, 0 < a t) → Q n c a) ↔
      ∀ w : World, w.Premised → (∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) → w.Binds →
        w.CountsHold Q :=
  have table := table_holds (Q := Q) enclosed_binding_counting_sound
    enclosed_binding_counting_witnessed
  ⟨fun law w premised enclosed binds => table.mp (fun n c a tally ⟨company, bound, arises⟩ =>
      law n c a tally company bound arises) w ⟨premised, enclosed, binds⟩,
   fun law n c a tally company bound arises => table.mpr (fun w ⟨premised, enclosed, binds⟩ =>
      law w premised enclosed binds) n c a tally ⟨company, bound, arises⟩⟩

/-- No finite world binds the census, so under each selection with the census every property
of the counts is a law in finite worlds where the selected premises bind. -/
theorem finite_binding_census_counted {S : Premise → Bool} (counted : S .counted = true)
    {Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop} :
    ∀ w : World, w.Meets S → w.Finite → (∀ p, S p = true → p.Binds w) → w.CountsHold Q :=
  fun _ _ finite binds => absurd finite (binds _ counted)

/-- **The laws of counting in finite worlds where the premises of each selection without the
census bind, where the counts exist**: those of `World.finite_counting_under_counted` and the
three that binding adds, the last where embodiment and bounded transmission are selected with
only active relata giving or with both only active relata taking and dissipation. For every
property, with no decidedness. -/
theorem finite_binding_counting_under_counted (S : Premise → Bool) (uncounted : S .counted = false)
    {Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop} :
    (∀ n c a, Tally n c a → (∃ M, ∀ t, n t ≤ M) →
      (BindsCounting S ∨ BoundsChange S → ∀ t, 0 < a t → 0 < n t) →
      (BoundsChange S → ∃ B, ChangeBound 0 B n c a) →
      (S .dependent = true ∨ S .acting = true ∨ S .taking = true → ∃ t, 0 < n t) →
      (S .embodied = true → ∃ t, 0 < a t) →
      (S .embodied = true → S .acting = true ∨ S .taking = true ∧ S .dissipative = true →
        S .transmitting = true → ∃ t, 0 < n t ∧ 0 < a t) → Q n c a) ↔
      ∀ w : World, w.Meets S → w.Finite → (∀ p, S p = true → p.Binds w) → w.CountsHold Q :=
  have table := table_holds (Q := Q) (finite_binding_counting_under_sound S)
    (finite_binding_counting_under_witnessed S uncounted)
  ⟨fun law w meets finite binds => table.mp (fun n c a tally ⟨bounded, quiet, bounds, acts, arises, joint⟩ =>
      law n c a tally bounded quiet bounds acts arises joint) w ⟨meets, finite, binds⟩,
   fun law n c a tally bounded quiet bounds acts arises joint => table.mpr (fun w ⟨meets, finite, binds⟩ =>
      law w meets finite binds) n c a tally ⟨bounded, quiet, bounds, acts, arises, joint⟩⟩

/-- So, where the counts exist, in finite worlds where the premises of a selection without the
census bind, something is active exactly where activity needing support, only active relata
giving, only active relata taking or embodiment is selected. -/
theorem finite_binding_activity_iff_counted (S : Premise → Bool) (uncounted : S .counted = false) :
    (∀ w : World, w.Meets S → w.Finite → (∀ p, S p = true → p.Binds w) →
      w.CountsHold fun n _ _ => ∃ t, 0 < n t) ↔
      S .dependent = true ∨ S .acting = true ∨ S .taking = true ∨ S .embodied = true :=
  ((finite_binding_counting_under_counted S uncounted).symm.trans
    (finite_binding_counting_under S uncounted
      (fun same ⟨t, pos⟩ => ⟨t, Nat.lt_of_lt_of_le pos (Nat.le_of_eq (same t).1)⟩))).trans
    (finite_binding_activity_iff S uncounted)

/-- Where the counts exist, in such finite worlds something arises exactly where embodiment is
selected. -/
theorem finite_binding_arising_iff_counted (S : Premise → Bool) (uncounted : S .counted = false) :
    (∀ w : World, w.Meets S → w.Finite → (∀ p, S p = true → p.Binds w) →
      w.CountsHold fun _ _ a => ∃ t, 0 < a t) ↔ S .embodied = true :=
  ((finite_binding_counting_under_counted S uncounted).symm.trans
    (finite_binding_counting_under S uncounted
      (fun same ⟨t, pos⟩ => ⟨t, Nat.lt_of_lt_of_le pos (Nat.le_of_eq (same t).2.2)⟩))).trans
    (finite_binding_arising_iff S uncounted)

/-- And, where the counts exist, that something arises across a step at which something is
active exactly where embodiment is selected and either the selection binds counting or bounds
change, or bounded transmission is selected with only active relata giving or with both only
active relata taking and dissipation. -/
theorem finite_binding_joint_iff_counted (S : Premise → Bool) (uncounted : S .counted = false) :
    (∀ w : World, w.Meets S → w.Finite → (∀ p, S p = true → p.Binds w) →
      w.CountsHold fun n _ a => ∃ t, 0 < n t ∧ 0 < a t) ↔
      S .embodied = true ∧ (BindsCounting S ∨ BoundsChange S ∨
        (S .acting = true ∨ S .taking = true ∧ S .dissipative = true) ∧
          S .transmitting = true) :=
  ((finite_binding_counting_under_counted S uncounted).symm.trans
    (finite_binding_counting_under S uncounted
      (fun same ⟨t, active, arising⟩ => ⟨t,
        Nat.lt_of_lt_of_le active (Nat.le_of_eq (same t).1),
        Nat.lt_of_lt_of_le arising (Nat.le_of_eq (same t).2.2)⟩))).trans
    (finite_binding_joint_iff S uncounted)

/-- **The laws of counting under enclosure from some step on, where the premises of each
selection bind, where the counts exist**: those of `World.enclosed_counting_under_counted` and
the three of `World.binding_counting_under_counted`, each on its own. For every property, with
no decidedness. -/
theorem enclosed_binding_counting_under_counted (S : Premise → Bool)
    {Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop} :
    (∀ n c a, Tally n c a → (BindsCounting S → ∀ t, 0 < a t → 0 < n t) →
      (BoundsChange S → ∃ T B, ChangeBound T B n c a ∧ ∀ t, T ≤ t → 0 < a t → 0 < n t) →
      (S .dependent = true ∨ S .acting = true ∨ S .taking = true → ∃ t, 0 < n t) →
      (S .embodied = true → ∃ t, 0 < a t) →
      (S .embodied = true → S .acting = true → S .transmitting = true →
        ∃ t, 0 < n t ∧ 0 < a t) → Q n c a) ↔
      ∀ w : World, w.Meets S → (∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) →
        (∀ p, S p = true → p.Binds w) → w.CountsHold Q :=
  have table := table_holds (Q := Q) (enclosed_binding_counting_under_sound S)
    (enclosed_binding_counting_under_witnessed S)
  ⟨fun law w meets enclosed binds => table.mp (fun n c a tally ⟨quiet, bounded, acts, arises, joint⟩ =>
      law n c a tally quiet bounded acts arises joint) w ⟨meets, enclosed, binds⟩,
   fun law n c a tally quiet bounded acts arises joint => table.mpr (fun w ⟨meets, enclosed, binds⟩ =>
      law w meets enclosed binds) n c a tally ⟨quiet, bounded, acts, arises, joint⟩⟩

/-- So, where the counts exist, in worlds enclosed from some step on where the premises of a
selection bind, something is active exactly where activity needing support, only active relata
giving, only active relata taking or embodiment is selected. -/
theorem enclosed_binding_activity_iff_counted (S : Premise → Bool) :
    (∀ w : World, w.Meets S → (∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) →
      (∀ p, S p = true → p.Binds w) → w.CountsHold fun n _ _ => ∃ t, 0 < n t) ↔
      S .dependent = true ∨ S .acting = true ∨ S .taking = true ∨ S .embodied = true :=
  ((enclosed_binding_counting_under_counted S).symm.trans
    (enclosed_binding_counting_under S
      (fun same ⟨t, pos⟩ => ⟨t, Nat.lt_of_lt_of_le pos (Nat.le_of_eq (same t).1)⟩))).trans
    (enclosed_binding_activity_iff S)

/-- Where the counts exist, in such worlds something arises exactly where embodiment is
selected. -/
theorem enclosed_binding_arising_iff_counted (S : Premise → Bool) :
    (∀ w : World, w.Meets S → (∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) →
      (∀ p, S p = true → p.Binds w) → w.CountsHold fun _ _ a => ∃ t, 0 < a t) ↔
      S .embodied = true :=
  ((enclosed_binding_counting_under_counted S).symm.trans
    (enclosed_binding_counting_under S
      (fun same ⟨t, pos⟩ => ⟨t, Nat.lt_of_lt_of_le pos (Nat.le_of_eq (same t).2.2)⟩))).trans
    (enclosed_binding_arising_iff S)

/-- And, where the counts exist, that something arises across a step at which something is
active exactly where embodiment is selected and either the selection binds counting or selects
only active relata giving and bounded transmission, as where nothing is enclosed. -/
theorem enclosed_binding_joint_iff_counted (S : Premise → Bool) :
    (∀ w : World, w.Meets S → (∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) →
      (∀ p, S p = true → p.Binds w) → w.CountsHold fun n _ a => ∃ t, 0 < n t ∧ 0 < a t) ↔
      S .embodied = true ∧ (BindsCounting S ∨ S .acting = true ∧ S .transmitting = true) :=
  ((enclosed_binding_counting_under_counted S).symm.trans
    (enclosed_binding_counting_under S
      (fun same ⟨t, active, arising⟩ => ⟨t,
        Nat.lt_of_lt_of_le active (Nat.le_of_eq (same t).1),
        Nat.lt_of_lt_of_le arising (Nat.le_of_eq (same t).2.2)⟩))).trans
    (enclosed_binding_joint_iff S)

/-- **The premises leave counting free, where the counts exist**: a property of the counts holds
of every tally exactly when it holds of every counted census of every world meeting every
premise but embodiment, and of every world meeting every premise but balance. For every
property, with no decidedness. -/
theorem counting_free_parts_counted {Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop} :
    ((∀ n c a, Tally n c a → Q n c a) ↔
      ∀ w : World, w.Dependent → w.Balanced → w.Acting → w.Taking → w.Dissipative →
        w.Transmitting → w.CountsHold Q) ∧
    ((∀ n c a, Tally n c a → Q n c a) ↔
      ∀ w : World, w.Dependent → w.Acting → w.Taking → w.Dissipative → w.Embodied →
        w.Transmitting → w.CountsHold Q) :=
  ⟨⟨fun law w _ _ _ _ _ _ => counting_free_counted.mp law w, fun law n c a tally =>
      match queue_premised n c with
      | ⟨dependent, balanced, acting, taking, dissipative, _, transmitting⟩ =>
        law (queue n c) dependent balanced acting taking dissipative transmitting _ n c a
          Queue.listed (queue_countsOf tally)⟩,
   ⟨fun law w _ _ _ _ _ _ => counting_free_counted.mp law w, fun law n c a tally =>
      match embodiedQueue_premised n c with
      | ⟨dependent, acting, taking, dissipative, embodied, _, transmitting⟩ =>
        law (embodiedQueue n c) dependent acting taking dissipative embodied transmitting _ n c a
          Queue.listed (embodiedQueue_countsOf tally)⟩⟩

/-- **Together, balance and embodiment bind the counts, where the counts exist.** Where the flow
balances, only active relata give and whatever arises is embodied, nothing arises across a step
at which nothing is active, in every counted census. One relatum arising from none is counted by a
queue meeting every premise but embodiment, and by one meeting every premise but balance. -/
theorem counting_binds_jointly_counted :
    (∀ w : World, w.Balanced → w.Acting → w.ArisingEmbodied →
      w.CountsHold fun n _ a => ∀ t, 0 < a t → 0 < n t) ∧
    ¬ (queue Queue.lone fun _ => 0).CountsHold (fun n _ a => ∀ t, 0 < a t → 0 < n t) ∧
    ¬ (embodiedQueue Queue.lone fun _ => 0).CountsHold
      (fun n _ a => ∀ t, 0 < a t → 0 < n t) :=
  ⟨fun _ balanced acting embodied _ _ _ _ census counted _ =>
    counted.company fun _ _ comes => active_of_coming_jointly balanced acting embodied census comes,
   fun marks => Nat.lt_irrefl 0
    (marks _ _ _ _ Queue.listed (queue_countsOf Queue.lone_tally) 0 Nat.zero_lt_one),
   fun marks => Nat.lt_irrefl 0
    (marks _ _ _ _ Queue.listed (embodiedQueue_countsOf Queue.lone_tally) 0 Nat.zero_lt_one)⟩

/-- So, where the counts exist, under the eight premises worlds enclosed from some step on and
finite worlds have the same laws of counting. -/
theorem enclosed_iff_finite_counting_counted
    {Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop} :
    (∀ w : World, w.Premised → (∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) → w.CountsHold Q) ↔
      ∀ w : World, w.Premised → w.Finite → w.CountsHold Q :=
  enclosed_counting_counted.symm.trans finite_counting_counted

/-- Where the counts exist, finite worlds and worlds enclosed from some step on have the same laws
of counting under a selection exactly when it bounds change and binds counting. -/
theorem enclosed_iff_finite_counting_under_counted (S : Premise → Bool) :
    (∀ Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop,
      ((∀ w : World, w.Meets S → (∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) → w.CountsHold Q) ↔
        ∀ w : World, w.Meets S → w.Finite → w.CountsHold Q)) ↔
      BoundsChange S ∧ BindsCounting S :=
  Iff.trans ⟨fun law Q _ => (enclosed_counting_under_counted S (Q := Q)).trans
      ((law Q).trans (finite_counting_under_counted S).symm),
    fun law Q => (enclosed_counting_under_counted S (Q := Q)).symm.trans
      ((law Q trivial).trans (finite_counting_under_counted S))⟩
    (enclosed_iff_finite_tally S (Props := fun _ => True) fun _ _ => trivial)

/-- **Read on what stands, where the counts exist**: under each selection, a pointwise property
holds of what stands in every world meeting it exactly when it holds of every counted census of
every world meeting it. The pointwise condition belongs to the reading on what stands; the
counted side needs none. -/
theorem standing_iff_counting_counted (S : Premise → Bool)
    {Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop} (pointwise : Pointwise Q) :
    (∀ w : World, w.Meets S → w.StandingMarksHold Q) ↔ ∀ w : World, w.Meets S → w.CountsHold Q :=
  (standing_counting_under S pointwise).symm.trans (counting_under_counted S)

end World

end Becoming
