import Becoming.Ideals
import Becoming.HistoryIdeals
import IdealWarrant
import CompletionRole
import HistoryIdeals

/-!
# The completion package's ideals as instances of the core's laws of ideals

`IdealWarrant`, `CompletionRole` and `HistoryIdeals` (7 October 2026) proved, with `Std` and
classical reasoning, what the core states in `Becoming.Ideals` and `Becoming.HistoryIdeals` with
an empty axiom report. Here the three are read as instances of the core.

**IdealWarrant.** A poset's order is the core's order of stretches (`order`; antisymmetry is not
used), and its ideals are the core's ideals (`toCore`, `ofCore`, the round trips definitional). On
these readings, with no axiom:
* finite refutability is the core's `Refutable` (`finiteRefutable_iff_refutable`), Scott closure
  its `ScottClosed` (`scottClosed_iff_closed`), admission lying `Within` a set (`admits_iff`), the
  content and the hull the core's (`content_iff`, `scottHull_iff_hull`), and respecting a set of
  prohibitions avoiding it (`respects_iff_avoids`);
* W1's equivalence of Scott closure and lower bases is the core's `closed_iff_lower`
  (`scottClosed_iff_lower_basis_by_core`), W2's hull is below every Scott-closed class holding the
  class by `hull_least` (`hull_least_by_core`), and W2a's characterization is `avoids_iff_within`
  (`respects_iff_admits_avoiding_by_core`).
With classical reasoning supplying the stability that `Refutable.closed` needs and the element
that `ScottClosed.refutable_iff` asks for, W1's equivalence of finite refutability and Scott closure
follows (`finiteRefutable_iff_scottClosed_by_core`); the core shows that, asked of every order
and class, each of the two steps is exactly double-negation elimination
(`Ideals.refutable_closed_iff`, `Ideals.closed_refutable_iff`). Where the package states an
equality of predicates or of ideals, the core's two inclusions give it with extensionality
(`lower_basis_unique_by_core`, `hull_unique_by_core`, `respects_unique_by_core`,
`lift_restrict_by_core`).

**CompletionRole.** The package's extension of a monotone map is the core's extension
(`extend_eq`, definitional), and its basis roles are the core's compact bases
(`basisRole_compactBasis`). The supplied antisymmetry of the target poset turns the core's
equivalences into the package's equalities: the extension agrees with the map on finite histories
(`extend_principal_by_core`, no axiom), and the free extension and its uniqueness, A2
(`unique_continuous_extension_by_core`), the positive readings, A2a
(`positive_reading_membership_by_core`), the basis representation, A3
(`unique_basis_representation_by_core`), and the compactness of exactly the finite histories
(`compact_iff_principal_by_core`) follow. A2 and A2a take no classical or extensionality step of
their own: A2's report names `propext` and `Quot.sound` because the package proves its ideal
poset antisymmetric by extensionality, and A2a's names `propext` because the package's poset of
propositions is antisymmetric by `propext`. A3 and compactness use extensionality for their
equalities of ideals.

**HistoryIdeals.** The package's words are the core's words (`toList`, `ofList`), its prefix
order the core's (`prefix_iff`), its traces the core's initial words (`initial_toList_iff`), and
its ideals of words the core's (`listIdeal`, `wordIdeal`); a history's ideal is the core's ideal
of the history (`history_listIdeal`). The order of finite and infinite histories is the core's
`history_le_iff` (`history_order_iff_by_core`). A4's classification is the core's
`classification`, with the decision of settling and the picking of words taken classically
(`ideal_classification_by_core`); the core shows that this decision, asked of the cut histories,
is the limited principle of omniscience (`HistoryIdeals.cut_decided_iff_lpo`). The finite
histories with the infinite histories of a property are not finitely refutable where some
sequence lies outside the property, by `finiteOr_not_refutable`
(`propertyClass_not_refutable_by_core`); W5's recurrence and W6's outputs of an enumeration are
the cases (`recurrence_ideal_not_refutable_by_core`, `represented_ideal_not_refutable_by_core`).
Admission by a prefix-closed language is the core's `history_within_iff`
(`history_admitted_iff_by_core`). The package proves its words equal by extensionality
(`word_ext`), so statements about its word order name `propext` and `Quot.sound`, as do the
translations through Lean's list library.

The three modules' definitions and statements are unchanged. No ethical predicate occurs.
-/

namespace Becoming.IdealsCorrespondence

universe u v

/-! ## IdealWarrant -/

section Warrant

variable {α : Type u}

/-- A poset's order, read as the core's order of stretches; antisymmetry is not used. -/
def order (P : CompletionWarrant.Poset α) : Ideals.Preorder α where
  le := P.le
  refl := P.refl
  trans := P.trans

variable {P : CompletionWarrant.Poset α}

/-- An ideal of the poset, read as an ideal of the core. -/
def toCore (I : CompletionWarrant.Ideal P) : Ideals.Ideal (order P) where
  mem := I.mem
  nonempty := I.nonempty
  lower := I.lower
  directed := I.directed

/-- An ideal of the core, read as an ideal of the poset. -/
def ofCore (I : Ideals.Ideal (order P)) : CompletionWarrant.Ideal P where
  mem := I.mem
  nonempty := I.nonempty
  lower := I.lower
  directed := I.directed

/-- A class of the poset's ideals, read on the core's ideals. -/
def coreClass (C : CompletionWarrant.Ideal P → Prop) : Ideals.Ideal (order P) → Prop :=
  fun J => C (ofCore J)

theorem ofCore_toCore (I : CompletionWarrant.Ideal P) : ofCore (toCore I) = I := rfl

theorem toCore_ofCore (I : Ideals.Ideal (order P)) : toCore (ofCore I) = I := rfl

theorem toCore_principal (p : α) :
    toCore (CompletionWarrant.principal P p) = Ideals.principal (order P) p := rfl

theorem le_iff {I J : CompletionWarrant.Ideal P} :
    CompletionWarrant.Ideal.LE I J ↔ Ideals.Ideal.LE (toCore I) (toCore J) :=
  Iff.rfl

theorem lowerBasis_iff {Q : α → Prop} :
    CompletionWarrant.LowerBasis P Q ↔ Ideals.Lower (order P) Q :=
  Iff.rfl

theorem admits_iff {Q : α → Prop} {I : CompletionWarrant.Ideal P} :
    CompletionWarrant.Admits P Q I ↔ Ideals.Within (order P) Q (toCore I) :=
  Iff.rfl

theorem content_iff {C : CompletionWarrant.Ideal P → Prop} {p : α} :
    CompletionWarrant.Content P C p ↔ Ideals.Content (coreClass C) p :=
  ⟨fun ⟨I, hI, hp⟩ => ⟨toCore I, hI, hp⟩, fun ⟨I, hI, hp⟩ => ⟨ofCore I, hI, hp⟩⟩

/-- **Finite refutability is the core's refutability.** -/
theorem finiteRefutable_iff_refutable {C : CompletionWarrant.Ideal P → Prop} :
    CompletionWarrant.FiniteRefutable P C ↔ Ideals.Refutable (coreClass C) :=
  ⟨fun refutable I outside => match refutable (ofCore I) outside with
    | ⟨p, hp, blocked⟩ => ⟨p, hp, fun J hJ => blocked (ofCore J) hJ⟩,
   fun refutable I outside => match refutable (toCore I) outside with
    | ⟨p, hp, blocked⟩ => ⟨p, hp, fun J hJ => blocked (toCore J) hJ⟩⟩

/-- **The Scott hull is the core's hull.** -/
theorem scottHull_iff_hull {C : CompletionWarrant.Ideal P → Prop} {I : CompletionWarrant.Ideal P} :
    CompletionWarrant.ScottHull P C I ↔ Ideals.Hull (coreClass C) (toCore I) :=
  ⟨fun h p hp => content_iff.mp (h p hp), fun h p hp => content_iff.mpr (h p hp)⟩

theorem respects_iff_avoids {F : α → Prop} {I : CompletionWarrant.Ideal P} :
    CompletionWarrant.Respects P F I ↔ Ideals.Avoids F (toCore I) :=
  Iff.rfl

theorem avoidingBasis_iff {F : α → Prop} {p : α} :
    CompletionWarrant.AvoidingBasis P F p ↔ ∀ b, F b → ¬ (order P).le b p :=
  ⟨fun h b hb hbp => h ⟨b, hb, hbp⟩, fun h ⟨b, hb, hbp⟩ => h b hb hbp⟩

theorem directedFamily_iff {D : CompletionWarrant.Ideal P → Prop} :
    CompletionWarrant.DirectedFamily P D ↔
      Ideals.Directed (Ideals.idealOrder (order P)) (coreClass D) :=
  ⟨fun hd => ⟨match hd.nonempty with | ⟨I, hI⟩ => ⟨toCore I, hI⟩,
     fun hI hJ => match hd.directed hI hJ with
       | ⟨K, hK, hIK, hJK⟩ => ⟨toCore K, hK, hIK, hJK⟩⟩,
   fun hd => ⟨match hd.nonempty with | ⟨I, hI⟩ => ⟨ofCore I, hI⟩,
     fun {I J} hI hJ => match hd.directed (a := toCore I) (b := toCore J) hI hJ with
       | ⟨K, hK, hIK, hJK⟩ => ⟨ofCore K, hK, hIK, hJK⟩⟩⟩

/-- The union of a directed family is the core's union. -/
theorem familyUnion_same (D : CompletionWarrant.Ideal P → Prop)
    (hd : CompletionWarrant.DirectedFamily P D) :
    Ideals.Ideal.Same (toCore (CompletionWarrant.familyUnion P D hd))
      (Ideals.union (coreClass D) (directedFamily_iff.mp hd)) :=
  fun _ => ⟨fun ⟨I, hI, hp⟩ => ⟨toCore I, hI, hp⟩, fun ⟨I, hI, hp⟩ => ⟨ofCore I, hI, hp⟩⟩

/-- **Scott closure is the core's closure.** The unions are carried by the closure's lower
part, since the two unions hold the same elements. -/
theorem scottClosed_iff_closed {C : CompletionWarrant.Ideal P → Prop} :
    CompletionWarrant.ScottClosed P C ↔ Ideals.ScottClosed (coreClass C) :=
  ⟨fun hc => ⟨fun hI hJI => hc.lower hI hJI,
     fun D hd hD => hc.lower
       (hc.directedClosed (fun I => D (toCore I)) (directedFamily_iff.mpr hd)
         fun I hI => hD (toCore I) hI)
       fun _ ⟨J, hJ, hp⟩ => ⟨ofCore J, hJ, hp⟩⟩,
   fun hc => ⟨fun {I J} hI hJI => hc.lower (I := toCore I) (J := toCore J) hI hJI,
     fun D hd hD => hc.lower (J := toCore (CompletionWarrant.familyUnion P D hd))
       (hc.unions (coreClass D) (directedFamily_iff.mp hd) fun I hI => hD (ofCore I) hI)
       (familyUnion_same D hd).le⟩⟩

/-- Classical reasoning supplies the stability that the core's `Refutable.closed` needs. -/
theorem closed_of_finiteRefutable {C : CompletionWarrant.Ideal P → Prop}
    (hc : CompletionWarrant.FiniteRefutable P C) : Ideals.ScottClosed (coreClass C) :=
  (finiteRefutable_iff_refutable.mp hc).closed fun _ notNot => Classical.byContradiction notNot

/-- **W1 (1 → 2) from the core**: a finitely refutable class is Scott-closed
(`Refutable.closed`, with stability from classical reasoning). -/
theorem refutable_scottClosed_by_core (C : CompletionWarrant.Ideal P → Prop)
    (hc : CompletionWarrant.FiniteRefutable P C) : CompletionWarrant.ScottClosed P C :=
  scottClosed_iff_closed.mpr (closed_of_finiteRefutable hc)

/-- **W1 (2 → 1) from the core**: a Scott-closed class is finitely refutable
(`ScottClosed.refutable_iff`, the element outside found classically). -/
theorem scottClosed_refutable_by_core (C : CompletionWarrant.Ideal P → Prop)
    (hc : CompletionWarrant.ScottClosed P C) : CompletionWarrant.FiniteRefutable P C := by
  have closed := scottClosed_iff_closed.mp hc
  refine finiteRefutable_iff_refutable.mpr (closed.refutable_iff.mpr fun I outside => ?_)
  apply Classical.byContradiction
  intro none_
  apply outside
  apply (Ideals.closed_iff_within_principal closed I).mpr
  intro p hp
  exact Classical.byContradiction fun notHeld => none_ ⟨p, hp, notHeld⟩

/-- **W1, equivalence 1 ↔ 2, from the core.** -/
theorem finiteRefutable_iff_scottClosed_by_core (C : CompletionWarrant.Ideal P → Prop) :
    CompletionWarrant.FiniteRefutable P C ↔ CompletionWarrant.ScottClosed P C :=
  ⟨refutable_scottClosed_by_core C, scottClosed_refutable_by_core C⟩

/-- **W1, equivalence 2 ↔ 3, from the core, with no axiom** (`closed_iff_lower`). -/
theorem scottClosed_iff_lower_basis_by_core (C : CompletionWarrant.Ideal P → Prop) :
    CompletionWarrant.ScottClosed P C ↔ ∃ Q : α → Prop, CompletionWarrant.LowerBasis P Q ∧
      ∀ I, C I ↔ CompletionWarrant.Admits P Q I :=
  scottClosed_iff_closed.trans ((Ideals.closed_iff_lower (coreClass C)).trans
    ⟨fun ⟨Q, hQ, h⟩ => ⟨Q, hQ, fun I => h (toCore I)⟩,
     fun ⟨Q, hQ, h⟩ => ⟨Q, hQ, fun I => h (ofCore I)⟩⟩)

/-- **W1, equivalence 1 ↔ 3, from the core.** -/
theorem finiteRefutable_iff_lower_basis_by_core (C : CompletionWarrant.Ideal P → Prop) :
    CompletionWarrant.FiniteRefutable P C ↔ ∃ Q : α → Prop, CompletionWarrant.LowerBasis P Q ∧
      ∀ I, C I ↔ CompletionWarrant.Admits P Q I :=
  (finiteRefutable_iff_scottClosed_by_core C).trans (scottClosed_iff_lower_basis_by_core C)

/-- W1's lower basis is unique: the core gives it pointwise (`lower_unique_of_two`); the
equality of predicates is extensionality. -/
theorem lower_basis_unique_by_core (C : CompletionWarrant.Ideal P → Prop) (Q R : α → Prop)
    (hq : CompletionWarrant.LowerBasis P Q) (hr : CompletionWarrant.LowerBasis P R)
    (heq : ∀ I, C I ↔ CompletionWarrant.Admits P Q I)
    (her : ∀ I, C I ↔ CompletionWarrant.Admits P R I) : Q = R :=
  funext fun p => propext (Ideals.lower_unique_of_two (C := coreClass C) hq hr
    (fun I => heq (ofCore I)) (fun I => her (ofCore I)) p)

/-- The lower basis is the content (`lower_iff_content`). -/
theorem basis_eq_content_by_core (C : CompletionWarrant.Ideal P → Prop) (Q : α → Prop)
    (hq : CompletionWarrant.LowerBasis P Q) (heq : ∀ I, C I ↔ CompletionWarrant.Admits P Q I) :
    Q = CompletionWarrant.Content P C :=
  funext fun p => propext ((Ideals.lower_iff_content (C := coreClass C) hq
    (fun I => heq (ofCore I)) p).trans content_iff.symm)

/-- The finite histories a Scott-closed class holds are its content (`principal_iff_content`). -/
theorem permitted_eq_content_by_core (C : CompletionWarrant.Ideal P → Prop)
    (hc : CompletionWarrant.ScottClosed P C) :
    CompletionWarrant.Permitted P C = CompletionWarrant.Content P C :=
  funext fun p => propext ((Ideals.principal_iff_content (scottClosed_iff_closed.mp hc) p).trans
    content_iff.symm)

/-- Admission is finitely refutable (`within_closed` and `ScottClosed.refutable_iff`, the element
outside found classically). -/
theorem admits_refutable_by_core (Q : α → Prop) :
    CompletionWarrant.FiniteRefutable P (CompletionWarrant.Admits P Q) :=
  finiteRefutable_iff_refutable.mpr ((Ideals.within_closed (P := order P) Q).refutable_iff.mpr
    fun _ outside => Classical.byContradiction fun none_ => outside fun p hp =>
      Classical.byContradiction fun notQ => none_ ⟨p, hp, fun h => notQ (h p ((order P).refl p))⟩)

/-- **W2 from the core, with no axiom**: the hull is below every Scott-closed class holding the
class (`hull_least`). -/
theorem hull_least_by_core (C E : CompletionWarrant.Ideal P → Prop)
    (he : CompletionWarrant.ScottClosed P E) (hce : ∀ I, C I → E I) :
    ∀ I, CompletionWarrant.ScottHull P C I → E I :=
  fun _ hI => Ideals.hull_least (scottClosed_iff_closed.mp he) (fun J hJ => hce (ofCore J) hJ)
    (scottHull_iff_hull.mp hI)

/-- W2's hull has the class's content (`hull_content`); the equality is extensionality. -/
theorem hull_preserves_content_by_core (C : CompletionWarrant.Ideal P → Prop) :
    CompletionWarrant.Content P (CompletionWarrant.ScottHull P C) = CompletionWarrant.Content P C :=
  funext fun p => propext
    ⟨fun ⟨I, hI, hp⟩ => content_iff.mpr
       ((Ideals.hull_content (coreClass C) p).mp ⟨toCore I, scottHull_iff_hull.mp hI, hp⟩),
     fun h => match content_iff.mp h with
       | ⟨J, hJ, hp⟩ => ⟨ofCore J, scottHull_iff_hull.mpr (Ideals.AdheresBy.of hJ), hp⟩⟩

/-- W2's hull is the only Scott-closed class holding the class and below every such class
(`hull_unique`); the equality is extensionality. -/
theorem hull_unique_by_core (C H : CompletionWarrant.Ideal P → Prop)
    (hh : CompletionWarrant.ScottClosed P H) (hcontains : ∀ I, C I → H I)
    (hleast : ∀ E, CompletionWarrant.ScottClosed P E → (∀ I, C I → E I) → ∀ I, H I → E I) :
    H = CompletionWarrant.ScottHull P C :=
  funext fun I => propext ((Ideals.hull_unique (C := coreClass C) (H := coreClass H)
      (scottClosed_iff_closed.mp hh) (fun J hJ => hcontains (ofCore J) hJ)
      (fun E hE sub J hJ => hleast (fun I => E (toCore I)) (scottClosed_iff_closed.mpr hE)
        (fun I hI => sub (toCore I) hI) (ofCore J) hJ) (toCore I)).trans
    scottHull_iff_hull.symm)

/-- **W2a from the core, with no axiom**: respecting `F` is lying within the stretches above no
element of `F` (`avoids_iff_within`). -/
theorem respects_iff_admits_avoiding_by_core (F : α → Prop) (I : CompletionWarrant.Ideal P) :
    CompletionWarrant.Respects P F I ↔
      CompletionWarrant.Admits P (CompletionWarrant.AvoidingBasis P F) I :=
  (Ideals.avoids_iff_within F (toCore I)).trans
    ⟨fun h p hp => avoidingBasis_iff.mpr (h p hp), fun h p hp => avoidingBasis_iff.mp (h p hp)⟩

theorem respects_scottClosed_by_core (F : α → Prop) :
    CompletionWarrant.ScottClosed P (CompletionWarrant.Respects P F) :=
  scottClosed_iff_closed.mpr (Ideals.avoids_closed (P := order P) F)

/-- W2a's uniqueness (`avoids_unique`, with stability from classical reasoning); the equality
is extensionality. -/
theorem respects_unique_by_core (F : α → Prop) (C : CompletionWarrant.Ideal P → Prop)
    (hc : CompletionWarrant.FiniteRefutable P C)
    (hprincipal : ∀ p, C (CompletionWarrant.principal P p) ↔ CompletionWarrant.AvoidingBasis P F p) :
    C = CompletionWarrant.Respects P F :=
  funext fun I => propext (Ideals.avoids_unique (C := coreClass C) (closed_of_finiteRefutable hc)
    (fun p => (hprincipal p).trans avoidingBasis_iff) (toCore I))

/-- The classification fixes admission once the principal classification is fixed
(`closed_iff_within_principal`); the equality is extensionality. -/
theorem refutable_eq_admits_by_core (C : CompletionWarrant.Ideal P → Prop) (Q : α → Prop)
    (hc : CompletionWarrant.FiniteRefutable P C)
    (hq : ∀ p, C (CompletionWarrant.principal P p) ↔ Q p) : C = CompletionWarrant.Admits P Q :=
  funext fun I => propext ((Ideals.closed_iff_within_principal (closed_of_finiteRefutable hc)
      (toCore I)).trans
    ⟨fun h p hp => (hq p).mp (h p hp), fun h p hp => (hq p).mpr (h p hp)⟩)

/-- Two finite contents of a hull's ideal are extended jointly in the class (`hull_joint`). -/
theorem hull_joint_content_by_core (C : CompletionWarrant.Ideal P → Prop)
    (I : CompletionWarrant.Ideal P) (hi : CompletionWarrant.ScottHull P C I) {p q : α}
    (hp : I.mem p) (hq : I.mem q) : ∃ J, C J ∧ ∃ r, J.mem r ∧ P.le p r ∧ P.le q r :=
  match Ideals.hull_joint (scottHull_iff_hull.mp hi) hp hq with
  | ⟨J, hJ, r, hr, hpr, hqr⟩ => ⟨ofCore J, hJ, r, hr, hpr, hqr⟩

theorem empty_finiteRefutable_by_core :
    CompletionWarrant.FiniteRefutable P (fun _ => False) :=
  finiteRefutable_iff_refutable.mpr Ideals.false_refutable

theorem empty_scottClosed_by_core : CompletionWarrant.ScottClosed P (fun _ => False) :=
  scottClosed_iff_closed.mpr Ideals.false_closed

theorem admits_empty_by_core (I : CompletionWarrant.Ideal P) :
    ¬ CompletionWarrant.Admits P (fun _ => False) I :=
  Ideals.within_false (I := toCore I)

/-- The order a lower subset inherits is the core's restriction. -/
theorem lowerPoset_order (Q : α → Prop) :
    order (CompletionWarrant.lowerPoset P Q) = (order P).restrict Q :=
  rfl

theorem lift_admits_by_core (Q : α → Prop) (hq : CompletionWarrant.LowerBasis P Q)
    (J : CompletionWarrant.Ideal (CompletionWarrant.lowerPoset P Q)) :
    CompletionWarrant.Admits P Q (CompletionWarrant.liftIdeal P Q hq J) :=
  Ideals.lift_within (P := order P) hq (toCore J)

theorem lift_order_iff_by_core (Q : α → Prop) (hq : CompletionWarrant.LowerBasis P Q)
    (J K : CompletionWarrant.Ideal (CompletionWarrant.lowerPoset P Q)) :
    CompletionWarrant.Ideal.LE (CompletionWarrant.liftIdeal P Q hq J)
        (CompletionWarrant.liftIdeal P Q hq K) ↔ CompletionWarrant.Ideal.LE J K :=
  Ideals.lift_le_iff (P := order P) hq (toCore J) (toCore K)

/-- The lift and the restriction are inverse (`lift_restrict`, `restrict_lift`); the equalities
are extensionality. -/
theorem lift_restrict_by_core (Q : α → Prop) (hq : CompletionWarrant.LowerBasis P Q)
    (I : CompletionWarrant.Ideal P) (hi : CompletionWarrant.Admits P Q I) :
    CompletionWarrant.liftIdeal P Q hq (CompletionWarrant.restrictIdeal P Q I hi) = I :=
  CompletionWarrant.Ideal.ext (Ideals.lift_restrict (P := order P) (Q := Q) hq (toCore I) hi)

theorem restrict_lift_by_core (Q : α → Prop) (hq : CompletionWarrant.LowerBasis P Q)
    (J : CompletionWarrant.Ideal (CompletionWarrant.lowerPoset P Q)) :
    CompletionWarrant.restrictIdeal P Q (CompletionWarrant.liftIdeal P Q hq J)
        (CompletionWarrant.lift_admits P Q hq J) = J :=
  CompletionWarrant.Ideal.ext (Ideals.restrict_lift (P := order P) hq (toCore J))

theorem empty_lower_no_ideal_by_core
    (J : CompletionWarrant.Ideal (CompletionWarrant.lowerPoset P fun _ => False)) : False :=
  Ideals.restrict_false_none (P := order P) (toCore J)

end Warrant

/-! ## CompletionRole -/

section Role

variable {α : Type u} {β : Type v} {P : CompletionWarrant.Poset α} {Q : CompletionWarrant.Poset β}

theorem directed_iff {S : β → Prop} : CompletionRole.Directed Q S ↔ Ideals.Directed (order Q) S :=
  ⟨fun h => ⟨h.nonempty, fun ha hb => h.directed _ ha _ hb⟩,
   fun h => ⟨h.nonempty, fun _ ha _ hb => h.directed ha hb⟩⟩

/-- A directed-complete poset, read as the core's directed-complete order. -/
def toComplete (D : CompletionRole.Dcpo Q) : Ideals.DirectedComplete (order Q) where
  sup S h := D.sup S (directed_iff.mpr h)
  upper S h := D.upper S (directed_iff.mpr h)
  least S h := D.least S (directed_iff.mpr h)

theorem monotone_iff {f : α → β} :
    CompletionRole.Monotone P Q f ↔ Ideals.Monotone (order P) (order Q) f :=
  Iff.rfl

theorem compact_iff {D : CompletionRole.Dcpo Q} {k : β} :
    CompletionRole.Compact D k ↔ Ideals.Compact (toComplete D) k :=
  ⟨fun h S hS => h S (directed_iff.mpr hS), fun h S hS => h S (directed_iff.mp hS)⟩

/-- **The package's extension of a monotone map is the core's extension.** -/
theorem extend_eq (D : CompletionRole.Dcpo Q) (f : α → β) (hf : CompletionRole.Monotone P Q f)
    (I : CompletionWarrant.Ideal P) :
    CompletionRole.extend D f hf I = Ideals.extend (P := order P) (toComplete D) f hf (toCore I) :=
  rfl

/-- The extension agrees with the map on finite histories (`extend_principal`, with the target's
antisymmetry). -/
theorem extend_principal_by_core (D : CompletionRole.Dcpo Q) (f : α → β)
    (hf : CompletionRole.Monotone P Q f) (p : α) :
    CompletionRole.extend D f hf (CompletionWarrant.principal P p) = f p :=
  Q.antisymm (Ideals.extend_principal (P := order P) (toComplete D) f hf p).1
    (Ideals.extend_principal (P := order P) (toComplete D) f hf p).2

/-- A directed family of the package's ideals, read on the core's. -/
theorem idealDirected_iff {S : CompletionWarrant.Ideal P → Prop} :
    CompletionRole.Directed (CompletionRole.idealPoset P) S ↔
      Ideals.Directed (Ideals.idealOrder (order P)) (coreClass S) :=
  ⟨fun h => directedFamily_iff.mp (CompletionRole.toDirectedFamily h),
   fun h => CompletionRole.fromDirectedFamily (directedFamily_iff.mpr h)⟩

/-- The extension is continuous (`extend_continuous`, with the target's antisymmetry). -/
theorem extend_continuous_by_core (D : CompletionRole.Dcpo Q) (f : α → β)
    (hf : CompletionRole.Monotone P Q f) :
    CompletionRole.Continuous (CompletionRole.idealDcpo P) D (CompletionRole.extend D f hf) := by
  have mono : Ideals.Monotone (order (CompletionRole.idealPoset P)) (order Q)
      (CompletionRole.extend D f hf) :=
    fun I J h => Ideals.extend_monotone (P := order P) (toComplete D) f hf (toCore I) (toCore J) h
  refine ⟨mono, fun S hS => ?_⟩
  have hd := idealDirected_iff.mp hS
  have cont := (Ideals.extend_continuous (P := order P) (toComplete D) f hf).preserves
    (coreClass S) hd
  have same := familyUnion_same S (CompletionRole.toDirectedFamily hS)
  have left : (order Q).Equiv
      (Ideals.extend (P := order P) (toComplete D) f hf
        (toCore ((CompletionRole.idealDcpo P).sup S hS)))
      (Ideals.extend (P := order P) (toComplete D) f hf (Ideals.union (coreClass S) hd)) :=
    ⟨Ideals.extend_monotone (P := order P) (toComplete D) f hf _ _ same.le,
     Ideals.extend_monotone (P := order P) (toComplete D) f hf _ _ same.ge⟩
  have right := Ideals.sup_congr (toComplete D)
    (Ideals.image_directed (Ideals.extend_monotone (P := order P) (toComplete D) f hf) hd)
    (Ideals.image_directed mono (directed_iff.mp hS))
    (fun b => ⟨fun ⟨J, hJ, e⟩ => ⟨ofCore J, hJ, e⟩, fun ⟨I, hI, e⟩ => ⟨toCore I, hI, e⟩⟩)
  have total := left.trans (cont.trans right)
  exact Q.antisymm total.1 total.2

/-- Every continuous map agreeing with the map on finite histories is the extension
(`extend_unique`, with the target's antisymmetry). -/
theorem extend_unique_by_core (D : CompletionRole.Dcpo Q) (f : α → β)
    (hf : CompletionRole.Monotone P Q f) (g : CompletionWarrant.Ideal P → β)
    (hg : CompletionRole.Continuous (CompletionRole.idealDcpo P) D g)
    (he : ∀ p, g (CompletionWarrant.principal P p) = f p) (I : CompletionWarrant.Ideal P) :
    g I = CompletionRole.extend D f hf I := by
  have mono : Ideals.Monotone (Ideals.idealOrder (order P)) (order Q) (fun J => g (ofCore J)) :=
    fun J K h => hg.monotone (ofCore J) (ofCore K) h
  have cont : Ideals.Continuous (Ideals.idealComplete (order P)) (toComplete D)
      (fun J => g (ofCore J)) := by
    refine ⟨mono, fun S hS => ?_⟩
    have hS' : CompletionRole.Directed (CompletionRole.idealPoset P) (fun I => S (toCore I)) :=
      idealDirected_iff.mpr hS
    have pres := hg.preserves (fun I => S (toCore I)) hS'
    have same : Ideals.Ideal.Same (Ideals.union S hS)
        (toCore ((CompletionRole.idealDcpo P).sup (fun I => S (toCore I)) hS')) :=
      fun _ => ⟨fun ⟨J, hJ, hp⟩ => ⟨ofCore J, hJ, hp⟩, fun ⟨I, hI, hp⟩ => ⟨toCore I, hI, hp⟩⟩
    have left : (order Q).Equiv (g (ofCore (Ideals.union S hS)))
        (g ((CompletionRole.idealDcpo P).sup (fun I => S (toCore I)) hS')) :=
      ⟨hg.monotone _ _ same.le, hg.monotone _ _ same.ge⟩
    rw [pres] at left
    have right := Ideals.sup_congr (toComplete D)
      (directed_iff.mp (CompletionRole.image_directed hg.monotone hS'))
      (Ideals.image_directed mono hS)
      (fun b => ⟨fun ⟨I, hI, e⟩ => ⟨toCore I, hI, e⟩, fun ⟨J, hJ, e⟩ => ⟨ofCore J, hJ, e⟩⟩)
    exact left.trans right
  have principal : ∀ p, (order Q).Equiv (g (ofCore (Ideals.principal (order P) p))) (f p) :=
    fun p => by
      show (order Q).Equiv (g (CompletionWarrant.principal P p)) (f p)
      rw [he p]
      exact Ideals.Preorder.Equiv.refl _ _
  have unique := Ideals.extend_unique (P := order P) (toComplete D) f hf (fun J => g (ofCore J)) cont
    principal (toCore I)
  exact Q.antisymm unique.1 unique.2

/-- **A2 from the core**: a monotone map extends uniquely to a continuous map of ideals
(`unique_continuous_extension`, with the target's antisymmetry). -/
theorem unique_continuous_extension_by_core (D : CompletionRole.Dcpo Q) (f : α → β)
    (hf : CompletionRole.Monotone P Q f) :
    ∃ g : CompletionWarrant.Ideal P → β, CompletionRole.Continuous (CompletionRole.idealDcpo P) D g ∧
      (∀ p, g (CompletionWarrant.principal P p) = f p) ∧
      ∀ h, CompletionRole.Continuous (CompletionRole.idealDcpo P) D h →
        (∀ p, h (CompletionWarrant.principal P p) = f p) → ∀ I, h I = g I :=
  ⟨CompletionRole.extend D f hf, extend_continuous_by_core D f hf, extend_principal_by_core D f hf,
   fun h hh he I => extend_unique_by_core D f hf h hh he I⟩

/-- Compactness in the package's ideal completion is the core's. -/
theorem idealCompact_iff (I : CompletionWarrant.Ideal P) :
    CompletionRole.Compact (CompletionRole.idealDcpo P) I ↔
      Ideals.Compact (Ideals.idealComplete (order P)) (toCore I) :=
  ⟨fun h S hS hI => match h (fun J => S (toCore J)) (idealDirected_iff.mpr hS)
      (fun p hp => match hI p hp with | ⟨K, hK, hpK⟩ => ⟨ofCore K, hK, hpK⟩) with
    | ⟨J, hJ, hIJ⟩ => ⟨toCore J, hJ, hIJ⟩,
   fun h S hS hI => match h (coreClass S) (idealDirected_iff.mp hS)
      (fun p hp => match hI p hp with | ⟨K, hK, hpK⟩ => ⟨toCore K, hK, hpK⟩) with
    | ⟨J, hJ, hIJ⟩ => ⟨ofCore J, hJ, hIJ⟩⟩

/-- An ideal is compact exactly where it is a finite history (`compact_iff_principal`); the
equality of ideals is extensionality. -/
theorem compact_iff_principal_by_core (I : CompletionWarrant.Ideal P) :
    CompletionRole.Compact (CompletionRole.idealDcpo P) I ↔ ∃ p, I = CompletionWarrant.principal P p :=
  (idealCompact_iff I).trans ((Ideals.compact_iff_principal (toCore I)).trans
    ⟨fun ⟨p, same⟩ => ⟨p, CompletionWarrant.Ideal.ext same⟩,
     fun ⟨p, e⟩ => ⟨p, by subst e; exact Ideals.Ideal.Same.refl _⟩⟩)

/-- A basis role of the package is the core's compact basis. -/
theorem basisRole_compactBasis {D : CompletionRole.Dcpo Q} {e : α → β}
    (R : CompletionRole.BasisRole P Q D e) : Ideals.CompactBasis (order P) (toComplete D) e :=
  ⟨R.embedding, fun p => compact_iff.mp (R.compact p), fun x => directed_iff.mp (R.approximants x),
   fun x => Eq.subst (motive := fun y => Q.le x y) (R.generates x).symm (Q.refl x)⟩

/-- An order isomorphism of the package, read as the core's order equivalence. -/
def isoEquivalence (G : CompletionRole.OrderIso (CompletionRole.idealPoset P) Q) :
    Ideals.OrderEquivalence (Ideals.idealOrder (order P)) (order Q) where
  forward J := G.forward (ofCore J)
  backward y := toCore (G.backward y)
  forward_monotone J K h := G.forward_mono (ofCore J) (ofCore K) h
  backward_monotone x y h := G.backward_mono x y h
  backward_forward J := Eq.subst (motive := fun K => (Ideals.idealOrder (order P)).Equiv (toCore K) J)
    (G.backward_forward (ofCore J)).symm (Ideals.Preorder.Equiv.refl _ J)
  forward_backward y := Eq.subst (motive := fun z => (order Q).Equiv z y)
    (G.forward_backward y).symm (Ideals.Preorder.Equiv.refl _ y)

/-- **A3 from the core**: the completion of a basis role, unique in both directions
(`CompactBasis.equivalence`, `equivalence_unique`, `equivalence_backward_unique`); the target's
antisymmetry turns the core's equivalences into equalities, and the equalities of ideals are
extensionality. -/
theorem unique_basis_representation_by_core {D : CompletionRole.Dcpo Q} {e : α → β}
    (R : CompletionRole.BasisRole P Q D e) :
    ∃ F : CompletionRole.OrderIso (CompletionRole.idealPoset P) Q,
      (∀ p, F.forward (CompletionWarrant.principal P p) = e p) ∧
      ∀ G : CompletionRole.OrderIso (CompletionRole.idealPoset P) Q,
        (∀ p, G.forward (CompletionWarrant.principal P p) = e p) →
        (∀ I, G.forward I = F.forward I) ∧ (∀ x, G.backward x = F.backward x) := by
  have B := basisRole_compactBasis R
  let F : CompletionRole.OrderIso (CompletionRole.idealPoset P) Q :=
    { forward := fun I => B.equivalence.forward (toCore I)
      backward := fun x => ofCore (B.equivalence.backward x)
      forward_mono := fun I J h => B.equivalence.forward_monotone (toCore I) (toCore J) h
      backward_mono := fun x y h => B.equivalence.backward_monotone x y h
      backward_forward := fun I => CompletionWarrant.Ideal.ext (B.below_extend (toCore I))
      forward_backward := fun x => Q.antisymm (B.extend_below x).1 (B.extend_below x).2 }
  refine ⟨F, fun p => Q.antisymm (B.equivalence_principal p).1 (B.equivalence_principal p).2,
    fun G hG => ?_⟩
  have hG' : ∀ p, (order Q).Equiv ((isoEquivalence G).forward (Ideals.principal (order P) p)) (e p) :=
    fun p => Eq.subst (motive := fun z => (order Q).Equiv z (e p)) (hG p).symm
      (Ideals.Preorder.Equiv.refl _ (e p))
  exact ⟨fun I => Q.antisymm (B.equivalence_unique (isoEquivalence G) hG' (toCore I)).1
      (B.equivalence_unique (isoEquivalence G) hG' (toCore I)).2,
    fun x => CompletionWarrant.Ideal.ext (B.equivalence_backward_unique (isoEquivalence G) hG' x)⟩

/-- **A2a from the core**: the positive reading "extends `p`" extends to ideals as "holds `p`"
(`extend_above_iff`). -/
theorem positive_reading_membership_by_core (p : α) (I : CompletionWarrant.Ideal P) :
    CompletionRole.extend CompletionRole.truthDcpo (fun q => P.le p q)
        (CompletionRole.positive_reading_monotone P p) I ↔ I.mem p :=
  Ideals.extend_above_iff (order P) p (toCore I)

/-- The positive readings separate ideals (`above_readings_separate`); the equality is
extensionality. -/
theorem positive_readings_separate_by_core (I J : CompletionWarrant.Ideal P)
    (h : ∀ p, CompletionRole.extend CompletionRole.truthDcpo (fun q => P.le p q)
        (CompletionRole.positive_reading_monotone P p) I ↔
      CompletionRole.extend CompletionRole.truthDcpo (fun q => P.le p q)
        (CompletionRole.positive_reading_monotone P p) J) : I = J :=
  CompletionWarrant.Ideal.ext (Ideals.above_readings_separate (toCore I) (toCore J) h)

end Role

/-! ## HistoryIdeals -/

section Histories

variable {A : Type u}

/-- A word of the package, read as the core's word of its letters. -/
def toList (w : CompletionWarrant.HistoryIdeals.Word A) : List A := List.ofFn w.letter

/-- A core word, read as a word of the package. -/
def ofList (l : List A) : CompletionWarrant.HistoryIdeals.Word A := ⟨l.length, fun i => l[i.val]⟩

theorem toList_length (w : CompletionWarrant.HistoryIdeals.Word A) : (toList w).length = w.length :=
  List.length_ofFn

theorem toList_ofList (l : List A) : toList (ofList l) = l :=
  List.ofFn_getElem

theorem getElem_toList (w : CompletionWarrant.HistoryIdeals.Word A) (i : Nat)
    (h : i < (toList w).length) (h' : i < w.length) : (toList w)[i] = w.letter ⟨i, h'⟩ :=
  List.getElem_ofFn h

/-- **The package's prefix order is the core's.** -/
theorem prefix_iff {v w : CompletionWarrant.HistoryIdeals.Word A} :
    CompletionWarrant.HistoryIdeals.Prefix v w ↔
      (HistoryIdeals.prefixOrder A).le (toList v) (toList w) := by
  show _ ↔ List.IsPrefix (toList v) (toList w)
  rw [List.prefix_iff_getElem]
  constructor
  · intro h
    refine ⟨by rw [toList_length, toList_length]; exact h.1, fun i hi => ?_⟩
    have hv : i < v.length := by rw [← toList_length v]; exact hi
    rw [getElem_toList v i hi hv, getElem_toList w i _ (Nat.lt_of_lt_of_le hv h.1)]
    exact h.2 i hv _
  · intro ⟨le, h⟩
    have le' : v.length ≤ w.length := by rw [← toList_length v, ← toList_length w]; exact le
    refine ⟨le', fun i hv hw => ?_⟩
    have hi : i < (toList v).length := by rw [toList_length]; exact hv
    have each := h i hi
    rw [getElem_toList v i hi hv, getElem_toList w i _ hw] at each
    exact each

theorem ofList_toList_prefix (w : CompletionWarrant.HistoryIdeals.Word A) :
    CompletionWarrant.HistoryIdeals.Prefix (ofList (toList w)) w :=
  prefix_iff.mpr (by rw [toList_ofList]; exact (HistoryIdeals.prefixOrder A).refl _)

theorem prefix_ofList_toList (w : CompletionWarrant.HistoryIdeals.Word A) :
    CompletionWarrant.HistoryIdeals.Prefix w (ofList (toList w)) :=
  prefix_iff.mpr (by rw [toList_ofList]; exact (HistoryIdeals.prefixOrder A).refl _)

theorem ofList_prefix_iff {l l' : List A} :
    CompletionWarrant.HistoryIdeals.Prefix (ofList l) (ofList l') ↔
      (HistoryIdeals.prefixOrder A).le l l' := by
  rw [prefix_iff, toList_ofList, toList_ofList]

theorem le_toList_of_prefix {l : List A} {w : CompletionWarrant.HistoryIdeals.Word A}
    (h : CompletionWarrant.HistoryIdeals.Prefix (ofList l) w) :
    (HistoryIdeals.prefixOrder A).le l (toList w) := by
  have le := prefix_iff.mp h
  rwa [toList_ofList] at le

theorem prefix_of_le_toList {l : List A} {w : CompletionWarrant.HistoryIdeals.Word A}
    (h : (HistoryIdeals.prefixOrder A).le l (toList w)) :
    CompletionWarrant.HistoryIdeals.Prefix (ofList l) w :=
  prefix_iff.mpr (by rw [toList_ofList]; exact h)

theorem prefix_ofList_of_le {w : CompletionWarrant.HistoryIdeals.Word A} {l : List A}
    (h : (HistoryIdeals.prefixOrder A).le (toList w) l) :
    CompletionWarrant.HistoryIdeals.Prefix w (ofList l) :=
  prefix_iff.mpr (by rw [toList_ofList]; exact h)

theorem le_of_prefix_ofList {w : CompletionWarrant.HistoryIdeals.Word A} {l : List A}
    (h : CompletionWarrant.HistoryIdeals.Prefix w (ofList l)) :
    (HistoryIdeals.prefixOrder A).le (toList w) l := by
  have le := prefix_iff.mp h
  rwa [toList_ofList] at le

theorem letter_eq_getElem : ∀ (l : List A) (n : Nat) (h : n < l.length),
    HistoryIdeals.letter l n h = l[n]
  | [], _, h => absurd h (Nat.not_lt_zero _)
  | _ :: _, 0, _ => rfl
  | _ :: l, n + 1, h => letter_eq_getElem l n (Nat.lt_of_succ_lt_succ h)

/-- **The package's traces are the core's initial words.** -/
theorem initial_toList_iff (w : CompletionWarrant.HistoryIdeals.Word A) (a : Nat → A) :
    HistoryIdeals.Initial (toList w) a ↔ CompletionWarrant.HistoryIdeals.PrefixTrace w a := by
  rw [HistoryIdeals.initial_iff_letter]
  constructor
  · intro h i hi
    have hl : i < (toList w).length := by rw [toList_length]; exact hi
    have each := h i hl
    rw [letter_eq_getElem, getElem_toList w i hl hi] at each
    exact each
  · intro h n hn
    have hw : n < w.length := by rw [← toList_length w]; exact hn
    rw [letter_eq_getElem, getElem_toList w n hn hw]
    exact h n hw

/-- An ideal of the package's words, read as an ideal of the core's words. -/
def listIdeal (I : CompletionWarrant.Ideal (CompletionWarrant.HistoryIdeals.wordPoset (A := A))) :
    Ideals.Ideal (HistoryIdeals.prefixOrder A) where
  mem l := I.mem (ofList l)
  nonempty := match I.nonempty with
    | ⟨w, hw⟩ => ⟨toList w, I.lower (ofList_toList_prefix w) hw⟩
  lower h hl := I.lower (ofList_prefix_iff.mpr h) hl
  directed := fun hl hl' => match I.directed hl hl' with
    | ⟨r, hr, hlr, hlr'⟩ => ⟨toList r, I.lower (ofList_toList_prefix r) hr,
        le_toList_of_prefix hlr, le_toList_of_prefix hlr'⟩

/-- An ideal of the core's words, read as an ideal of the package's words. -/
def wordIdeal (J : Ideals.Ideal (HistoryIdeals.prefixOrder A)) :
    CompletionWarrant.Ideal (CompletionWarrant.HistoryIdeals.wordPoset (A := A)) where
  mem w := J.mem (toList w)
  nonempty := match J.nonempty with
    | ⟨l, hl⟩ => ⟨ofList l, by show J.mem (toList (ofList l)); rw [toList_ofList]; exact hl⟩
  lower h hw := J.lower (prefix_iff.mp h) hw
  directed := fun hv hw => match J.directed hv hw with
    | ⟨r, hr, hvr, hwr⟩ => ⟨ofList r, by show J.mem (toList (ofList r)); rw [toList_ofList]; exact hr,
        prefix_ofList_of_le hvr, prefix_ofList_of_le hwr⟩

theorem listIdeal_mem_toList
    {I : CompletionWarrant.Ideal (CompletionWarrant.HistoryIdeals.wordPoset (A := A))}
    {w : CompletionWarrant.HistoryIdeals.Word A} : (listIdeal I).mem (toList w) ↔ I.mem w :=
  ⟨fun h => I.lower (prefix_ofList_toList w) h, fun h => I.lower (ofList_toList_prefix w) h⟩

theorem wordIdeal_mem_ofList {J : Ideals.Ideal (HistoryIdeals.prefixOrder A)} {l : List A} :
    (wordIdeal J).mem (ofList l) ↔ J.mem l := by
  show J.mem (toList (ofList l)) ↔ J.mem l
  rw [toList_ofList]

theorem le_iff_listIdeal
    {I J : CompletionWarrant.Ideal (CompletionWarrant.HistoryIdeals.wordPoset (A := A))} :
    CompletionWarrant.Ideal.LE I J ↔ Ideals.Ideal.LE (listIdeal I) (listIdeal J) :=
  ⟨fun h _ hl => h _ hl, fun h _ hw => listIdeal_mem_toList.mp (h _ (listIdeal_mem_toList.mpr hw))⟩

/-- A history of the package, read as a history of the core. -/
def ofHistory : CompletionWarrant.HistoryIdeals.History A → HistoryIdeals.History A
  | .finite w => .finite (toList w)
  | .infinite a => .infinite a

theorem principal_listIdeal (w : CompletionWarrant.HistoryIdeals.Word A) :
    Ideals.Ideal.Same
      (listIdeal (CompletionWarrant.principal CompletionWarrant.HistoryIdeals.wordPoset w))
      (Ideals.principal (HistoryIdeals.prefixOrder A) (toList w)) :=
  fun _ => ⟨le_toList_of_prefix, prefix_of_le_toList⟩

theorem trace_listIdeal (a : Nat → A) :
    Ideals.Ideal.Same (listIdeal (CompletionWarrant.HistoryIdeals.traceIdeal a))
      (HistoryIdeals.traceIdeal a) := by
  intro l
  show CompletionWarrant.HistoryIdeals.PrefixTrace (ofList l) a ↔ HistoryIdeals.Initial l a
  rw [← initial_toList_iff, toList_ofList]

/-- **A history's ideal of the package is the core's ideal of the history.** -/
theorem history_listIdeal : ∀ h : CompletionWarrant.HistoryIdeals.History A,
    Ideals.Ideal.Same (listIdeal (CompletionWarrant.HistoryIdeals.historyIdeal h))
      (HistoryIdeals.historyIdeal (ofHistory h))
  | .finite w => principal_listIdeal w
  | .infinite a => trace_listIdeal a

/-- A bounded ideal of words has a longest word, found by deciding at each length whether a word
of that length is present (classical). -/
theorem settles_of_bounded (I : Ideals.Ideal (HistoryIdeals.prefixOrder A)) :
    ∀ n, (∀ w, I.mem w → w.length ≤ n) → HistoryIdeals.HasLongest I
  | 0, bound => match I.nonempty with
    | ⟨w, hw⟩ => ⟨w, hw, fun v hv => Nat.le_trans (bound v hv) (Nat.zero_le _)⟩
  | n + 1, bound => by
    classical
    by_cases top : ∃ w, I.mem w ∧ w.length = n + 1
    · obtain ⟨w, hw, len⟩ := top
      exact ⟨w, hw, fun v hv => by rw [len]; exact bound v hv⟩
    · exact settles_of_bounded I n fun w hw =>
        Nat.le_of_lt_succ (Nat.lt_of_le_of_ne (bound w hw) fun e => top ⟨w, hw, e⟩)

/-- Classically, an ideal of words settles, or goes on with a word of each length picked. -/
theorem decided_classical (I : Ideals.Ideal (HistoryIdeals.prefixOrder A)) :
    HistoryIdeals.HasLongest I ∨
      ∃ pick : Nat → List A, (∀ n, I.mem (pick n)) ∧ ∀ n, n < (pick n).length := by
  classical
  by_cases goes : HistoryIdeals.GoesOn I
  · exact .inr ⟨fun n => Classical.choose (goes n), fun n => (Classical.choose_spec (goes n)).1,
      fun n => (Classical.choose_spec (goes n)).2⟩
  · refine .inl ?_
    have bounded : ∃ n, ∀ w, I.mem w → w.length ≤ n := by
      apply Classical.byContradiction
      intro none_
      apply goes
      intro n
      apply Classical.byContradiction
      intro noLonger
      exact none_ ⟨n, fun w hw => Nat.le_of_not_lt fun lt => noLonger ⟨w, hw, lt⟩⟩
    obtain ⟨n, bound⟩ := bounded
    exact settles_of_bounded I n bound

/-- **A4 from the core**: every ideal of words is a finite or an infinite history
(`HistoryIdeals.classification`); settling is decided and the words picked classically, and the
equalities of ideals are extensionality. -/
theorem ideal_classification_by_core
    (I : CompletionWarrant.Ideal (CompletionWarrant.HistoryIdeals.wordPoset (A := A))) :
    (∃ w, I = CompletionWarrant.principal CompletionWarrant.HistoryIdeals.wordPoset w) ∨
      ∃ a, I = CompletionWarrant.HistoryIdeals.traceIdeal a :=
  match HistoryIdeals.classification (decided_classical (listIdeal I)) with
  | ⟨.finite l, same⟩ => .inl ⟨ofList l, CompletionWarrant.Ideal.ext fun w =>
      listIdeal_mem_toList.symm.trans ((same (toList w)).trans
        ⟨prefix_ofList_of_le, le_of_prefix_ofList⟩)⟩
  | ⟨.infinite a, same⟩ => .inr ⟨a, CompletionWarrant.Ideal.ext fun w =>
      listIdeal_mem_toList.symm.trans ((same (toList w)).trans (initial_toList_iff w a))⟩

theorem historyPrefix_iff : ∀ h k : CompletionWarrant.HistoryIdeals.History A,
    HistoryIdeals.HistoryPrefix (ofHistory h) (ofHistory k) ↔
      CompletionWarrant.HistoryIdeals.HistoryPrefix h k
  | .finite _, .finite _ => prefix_iff.symm
  | .finite w, .infinite a => initial_toList_iff w a
  | .infinite _, .finite _ => Iff.rfl
  | .infinite _, .infinite _ => ⟨funext, fun e _ => congrFun e _⟩

/-- **The four comparisons of finite and infinite histories, from the core**
(`HistoryIdeals.history_le_iff`); the equality of two sequences is extensionality. -/
theorem history_order_iff_by_core (h k : CompletionWarrant.HistoryIdeals.History A) :
    CompletionWarrant.Ideal.LE (CompletionWarrant.HistoryIdeals.historyIdeal h)
        (CompletionWarrant.HistoryIdeals.historyIdeal k) ↔
      CompletionWarrant.HistoryIdeals.HistoryPrefix h k :=
  le_iff_listIdeal.trans
    ((⟨fun le => Ideals.Ideal.LE.trans (history_listIdeal h).ge
          (Ideals.Ideal.LE.trans le (history_listIdeal k).le),
       fun le => Ideals.Ideal.LE.trans (history_listIdeal h).le
          (Ideals.Ideal.LE.trans le (history_listIdeal k).ge)⟩ :
        Ideals.Ideal.LE (listIdeal (CompletionWarrant.HistoryIdeals.historyIdeal h))
            (listIdeal (CompletionWarrant.HistoryIdeals.historyIdeal k)) ↔
          Ideals.Ideal.LE (HistoryIdeals.historyIdeal (ofHistory h))
            (HistoryIdeals.historyIdeal (ofHistory k))).trans
      ((HistoryIdeals.history_le_iff (ofHistory h) (ofHistory k)).trans (historyPrefix_iff h k)))

theorem historyIdeal_injective_by_core {h k : CompletionWarrant.HistoryIdeals.History A}
    (heq : CompletionWarrant.HistoryIdeals.historyIdeal h =
      CompletionWarrant.HistoryIdeals.historyIdeal k) : h = k := by
  have forth := (history_order_iff_by_core h k).mp fun _ hw => heq ▸ hw
  have back := (history_order_iff_by_core k h).mp fun _ hw => heq.symm ▸ hw
  cases h with
  | finite v =>
    cases k with
    | finite w =>
      exact congrArg CompletionWarrant.HistoryIdeals.History.finite
        ((CompletionWarrant.HistoryIdeals.wordPoset (A := A)).antisymm forth back)
    | infinite _ => exact back.elim
  | infinite a =>
    cases k with
    | finite _ => exact forth.elim
    | infinite b => exact congrArg CompletionWarrant.HistoryIdeals.History.infinite forth

/-- Refutability carries from the package's words to the core's, for classes that agree through
`wordIdeal`. -/
theorem refutable_of_wordIdeal
    {C : CompletionWarrant.Ideal (CompletionWarrant.HistoryIdeals.wordPoset (A := A)) → Prop}
    {C' : Ideals.Ideal (HistoryIdeals.prefixOrder A) → Prop} (agree : ∀ J, C (wordIdeal J) ↔ C' J)
    (refutable : CompletionWarrant.FiniteRefutable CompletionWarrant.HistoryIdeals.wordPoset C) :
    Ideals.Refutable C' :=
  fun J outside => match refutable (wordIdeal J) fun h => outside ((agree J).mp h) with
    | ⟨w, hw, blocked⟩ => ⟨toList w, hw, fun J' inside hJ' => blocked (wordIdeal J') ((agree J').mpr inside) hJ'⟩

theorem finiteOnly_wordIdeal_iff (J : Ideals.Ideal (HistoryIdeals.prefixOrder A)) :
    CompletionWarrant.HistoryIdeals.FiniteOnly (wordIdeal J) ↔
      ∃ l, Ideals.Ideal.Same J (Ideals.principal (HistoryIdeals.prefixOrder A) l) :=
  ⟨fun ⟨w, e⟩ => ⟨toList w, fun _ => wordIdeal_mem_ofList.symm.trans
      (by rw [e]; exact ⟨le_toList_of_prefix, prefix_of_le_toList⟩)⟩,
   fun ⟨l, same⟩ => ⟨ofList l, CompletionWarrant.Ideal.ext fun w =>
      (same (toList w)).trans ⟨prefix_ofList_of_le, le_of_prefix_ofList⟩⟩⟩

theorem trace_wordIdeal_iff (J : Ideals.Ideal (HistoryIdeals.prefixOrder A)) (a : Nat → A) :
    wordIdeal J = CompletionWarrant.HistoryIdeals.traceIdeal a ↔
      Ideals.Ideal.Same J (HistoryIdeals.traceIdeal a) :=
  ⟨fun e l => wordIdeal_mem_ofList.symm.trans (by rw [e]; exact trace_listIdeal a l),
   fun same => CompletionWarrant.Ideal.ext fun w => (same (toList w)).trans (initial_toList_iff w a)⟩

/-- The package's finite histories with the infinite histories of `K` are the core's. -/
theorem propertyClass_wordIdeal_iff (K : (Nat → A) → Prop)
    (J : Ideals.Ideal (HistoryIdeals.prefixOrder A)) :
    CompletionWarrant.HistoryIdeals.PropertyClass K (wordIdeal J) ↔ HistoryIdeals.FiniteOr K J :=
  ⟨fun
    | .inl finite => .inl ((finiteOnly_wordIdeal_iff J).mp finite)
    | .inr ⟨a, ha, e⟩ => .inr ⟨a, ha, (trace_wordIdeal_iff J a).mp e⟩,
   fun
    | .inl finite => .inl ((finiteOnly_wordIdeal_iff J).mpr finite)
    | .inr ⟨a, ha, same⟩ => .inr ⟨a, ha, (trace_wordIdeal_iff J a).mpr same⟩⟩

/-- **A sequence outside `K` shows that the finite histories with the infinite histories of `K`
are not finitely refutable, from the core** (`HistoryIdeals.finiteOr_not_refutable`); the
equality of two sequences is extensionality. -/
theorem propertyClass_not_refutable_by_core (K : (Nat → A) → Prop) (a : Nat → A) (ha : ¬ K a) :
    ¬ CompletionWarrant.FiniteRefutable CompletionWarrant.HistoryIdeals.wordPoset
      (CompletionWarrant.HistoryIdeals.PropertyClass K) :=
  fun refutable => HistoryIdeals.finiteOr_not_refutable K a
    (fun _ same hb => ha (by rw [funext same]; exact hb))
    (refutable_of_wordIdeal (propertyClass_wordIdeal_iff K) refutable)

theorem finiteOnly_not_refutable_by_core (a : Nat → A) :
    ¬ CompletionWarrant.FiniteRefutable CompletionWarrant.HistoryIdeals.wordPoset
      (CompletionWarrant.HistoryIdeals.FiniteOnly (A := A)) :=
  fun refutable => HistoryIdeals.finiteOr_not_refutable (fun _ => False) a (fun _ _ h => h)
    (refutable_of_wordIdeal (C' := HistoryIdeals.FiniteOr fun _ => False)
      (fun J => (finiteOnly_wordIdeal_iff J).trans
        ⟨.inl, fun | .inl h => h | .inr ⟨_, h, _⟩ => h.elim⟩) refutable)

/-- W5's class of recurrence is not finitely refutable, from the core's
`finiteOr_recurs_not_refutable`, which is `Sequences.recurs_not_refutable` among histories. -/
theorem recurrence_ideal_not_refutable_by_core :
    ¬ CompletionWarrant.FiniteRefutable CompletionWarrant.HistoryIdeals.wordPoset
      (CompletionWarrant.HistoryIdeals.PropertyClass CompletionWarrant.PrefixSafety.Recurs) :=
  fun refutable => HistoryIdeals.finiteOr_recurs_not_refutable
    (refutable_of_wordIdeal (propertyClass_wordIdeal_iff _) refutable)

/-- W6's class of the outputs of an enumeration is not finitely refutable: the core's
`finiteOr_not_refutable` at `PrefixSafety`'s diagonal sequence. -/
theorem represented_ideal_not_refutable_by_core (E : Nat → Option (Nat → Bool)) :
    ¬ CompletionWarrant.FiniteRefutable CompletionWarrant.HistoryIdeals.wordPoset
      (CompletionWarrant.HistoryIdeals.PropertyClass (CompletionWarrant.PrefixSafety.Represented E)) :=
  propertyClass_not_refutable_by_core _ (CompletionWarrant.PrefixSafety.diagonal E)
    (CompletionWarrant.PrefixSafety.diagonal_not_represented E)

theorem tracePrefix_prefix_initialWord (a : Nat → A) (n : Nat) :
    CompletionWarrant.HistoryIdeals.Prefix (CompletionWarrant.HistoryIdeals.tracePrefix a n)
      (ofList (HistoryIdeals.initialWord a n)) :=
  prefix_ofList_of_le (HistoryIdeals.initial_le_of_length
    ((initial_toList_iff _ a).mpr fun _ _ => rfl) (HistoryIdeals.initialWord_initial a n)
    (by rw [toList_length, HistoryIdeals.initialWord_length]; exact Nat.le_refl n))

theorem initialWord_prefix_tracePrefix (a : Nat → A) (n : Nat) :
    CompletionWarrant.HistoryIdeals.Prefix (ofList (HistoryIdeals.initialWord a n))
      (CompletionWarrant.HistoryIdeals.tracePrefix a n) :=
  prefix_of_le_toList (HistoryIdeals.initial_le_of_length (HistoryIdeals.initialWord_initial a n)
    ((initial_toList_iff _ a).mpr fun _ _ => rfl)
    (by rw [toList_length, HistoryIdeals.initialWord_length]; exact Nat.le_refl n))

/-- **A history lies within a prefix-closed language of the package exactly where its word, or
each of its initial words, is in it, from the core** (`HistoryIdeals.history_within_iff`). -/
theorem history_admitted_iff_by_core (H : CompletionWarrant.HistoryIdeals.Word A → Prop)
    (hH : CompletionWarrant.LowerBasis CompletionWarrant.HistoryIdeals.wordPoset H)
    (h : CompletionWarrant.HistoryIdeals.History A) :
    CompletionWarrant.Admits CompletionWarrant.HistoryIdeals.wordPoset H
        (CompletionWarrant.HistoryIdeals.historyIdeal h) ↔
      CompletionWarrant.HistoryIdeals.Admitted H h := by
  have closed : HistoryLanguages.PrefixClosed fun l => H (ofList l) :=
    (HistoryIdeals.prefixClosed_iff_lower _).mpr fun le hl => hH (ofList_prefix_iff.mpr le) hl
  have admits : CompletionWarrant.Admits CompletionWarrant.HistoryIdeals.wordPoset H
        (CompletionWarrant.HistoryIdeals.historyIdeal h) ↔
      Ideals.Within (HistoryIdeals.prefixOrder A) (fun l => H (ofList l))
        (HistoryIdeals.historyIdeal (ofHistory h)) :=
    ⟨fun adm l hl => adm _ ((history_listIdeal h l).mpr hl),
     fun within w hw => hH (prefix_ofList_toList w)
       (within _ ((history_listIdeal h _).mp (listIdeal_mem_toList.mpr hw)))⟩
  refine admits.trans ((HistoryIdeals.history_within_iff closed (ofHistory h)).trans ?_)
  cases h with
  | finite w => exact ⟨hH (prefix_ofList_toList w), hH (ofList_toList_prefix w)⟩
  | infinite a =>
    exact ⟨fun hn n => hH (tracePrefix_prefix_initialWord a n) (hn n),
      fun hn n => hH (initialWord_prefix_tracePrefix a n) (hn n)⟩

end Histories

end Becoming.IdealsCorrespondence
