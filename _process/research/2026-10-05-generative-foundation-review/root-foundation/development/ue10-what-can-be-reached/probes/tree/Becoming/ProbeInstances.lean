import Becoming.ReachableRanges
import Becoming.Extension
import Becoming.Bundles

/-!
# UE10 review probes, part 3: instances of landed definitions

Probes of the draft `Becoming.ReachableRanges` (review REVIEW-UE10.md): covering is
`CarriesProfiles` (`Becoming.Bundles`) on the frame of courses, widening what can be reached is
`Extension` (`Becoming.Extension`) on the frame of reachable ranges, the lexical order lies inside
`Lexical.Above` (`Becoming.Lexical`), and `Joint` gives the law form of
`Regimes.no_comparison_through_marginals` through `Comparison.separates`. Nothing here is proposed
for landing as written. `Extension`, `Bundles` and `Lexical` are stated at `Type`, so the probe is.
-/

namespace Becoming

namespace ProbeUE10

open Generative Lexical

section Instances

variable {S : Type} {A : Type} {X : Type} {P : Process S A} {adm : S → X → Prop}

/-- The courses of a process as configurations of a frame with no moves, each realizing what it
admits at each offset. -/
def coursesFrame (P : Process S A) (adm : S → X → Prop) : Frame (Run P) Unit (Nat × X) :=
  ⟨Witnesses.halted _ _, fun r p => adm (r.state p.1) p.2⟩

/-- **Probe I1.** Covering is `CarriesProfiles` from the courses from `s'` to those from `s`. -/
theorem covers_iff_carries {s s' : S} :
    Reaching.Covers P adm s s' ↔
      CarriesProfiles (coursesFrame P adm) (fun r => r.state 0 = s') (coursesFrame P adm)
        (fun r => r.state 0 = s) :=
  ⟨fun covers r' start' => match covers r' start' with
    | ⟨r, start, includes⟩ => ⟨r, start, fun p admitted => includes p.1 p.2 admitted⟩,
   fun carries r' start' => match carries r' start' with
    | ⟨r, start, keeps⟩ => ⟨r, start, fun t x admitted => keeps (t, x) admitted⟩⟩

/-- **Probe I1.** Covering is preserving every bundle of (offset, formation) admissions that some
course realizes together (`carries_iff_preserves`). -/
theorem covers_iff_preserves {s s' : S} :
    Reaching.Covers P adm s s' ↔
      PreservesBundles (coursesFrame P adm) (fun r => r.state 0 = s') (coursesFrame P adm)
        (fun r => r.state 0 = s) :=
  covers_iff_carries.trans carries_iff_preserves

/-- The ranges some course from `s` includes. -/
def reachableRanges (P : Process S A) (adm : S → X → Prop) (s : S) (ρ : Nat → X → Prop) : Prop :=
  ∃ r : Run P, r.state 0 = s ∧ ∀ t x, ρ t x → adm (r.state t) x

/-- The configurations of a process, each realizing the ranges some course from it includes. -/
def reachFrame (P : Process S A) (adm : S → X → Prop) : Frame S A (Nat → X → Prop) :=
  ⟨P, reachableRanges P adm⟩

/-- **Probe I2.** Covering is inclusion of the reachable ranges. -/
theorem covers_iff_included {s s' : S} :
    Reaching.Covers P adm s s' ↔ Included (reachableRanges P adm s') (reachableRanges P adm s) :=
  ⟨fun covers _ ⟨r', start', sub⟩ => match covers r' start' with
    | ⟨r, start, includes⟩ => ⟨r, start, fun t x held => includes t x (sub t x held)⟩,
   fun included r' start' => match included _ ⟨r', start', fun _ _ admitted => admitted⟩ with
    | ⟨r, start, includes⟩ => ⟨r, start, includes⟩⟩

/-- **Probe I2.** Widening what can be reached is generative extension (`Extension`, every claim
living) of the reachable ranges, both ways, with no premise. -/
theorem widens_iff_extension {s s' : S} :
    Reaching.Widens P adm s s' ↔ Extension (reachFrame P adm) (fun _ => True) s' s :=
  ⟨fun ⟨covers, r, start, unmatched⟩ =>
     ⟨covers_iff_included.mp covers, fun t x => adm (r.state t) x, trivial,
      ⟨r, start, fun _ _ admitted => admitted⟩,
      fun ⟨r', start', includes⟩ => unmatched r' start' includes⟩,
   fun ⟨kept, _, _, ⟨r, start, sub⟩, notBefore⟩ =>
     ⟨covers_iff_included.mpr kept, r, start, fun r' start' includes =>
       notBefore ⟨r', start', fun t x held => includes t x (sub t x held)⟩⟩⟩

/-- What the chosen course from a configuration admits, as claims on (offset, formation) pairs. -/
def realizedClaims (course : S → Run P) (adm : S → X → Prop) (s : S) (p : Nat × X) : Prop :=
  adm ((course s).state p.1) p.2

/-- **Probe I3.** The module's lexical order lies inside the two-tier lexical order
(`Lexical.Above`) of the realized claims, then the reachable ranges. The converse needs the
inclusions decided. -/
theorem lexical_above {course : S → Run P} {s s' : S}
    (lexical : Reaching.Lexical P adm course s s') :
    Above (realizedClaims course adm) (reachableRanges P adm) s s' :=
  match lexical with
  | .inl ⟨includes, t, x, yes, no⟩ =>
    .inl ⟨fun p held => includes p.1 p.2 held, fun back => no (back (t, x) yes)⟩
  | .inr ⟨includes, back, widens⟩ =>
    match widens_iff_extension.mp widens with
    | ⟨kept, ρ, _, now, before⟩ =>
      .inr ⟨fun p held => includes p.1 p.2 held, fun p held => back p.1 p.2 held,
        kept, fun again => before (again ρ now)⟩

/-- The frame realizing, at each configuration, what its chosen course admits at each offset. -/
def realizedFrame (P : Process S A) (adm : S → X → Prop) (course : S → Run P) :
    Frame S A (Nat × X) :=
  ⟨P, realizedClaims course adm⟩

end Instances

/-- **Probe I5.** On `Options`, no strict partial order satisfies C both on the realized courses
(`realizedFrame`) and on the reachable ranges (C◇, `reachFrame`): the lexical premise, in C's own
form. -/
theorem options_no_comparison_both {Better : Options.Config → Options.Config → Prop}
    (irrefl : ∀ a, ¬ Better a a) (trans : ∀ {a b c}, Better a b → Better b c → Better a c)
    (realized : Comparison (realizedFrame Options.process Options.adm Options.course) (fun _ => True)
      Better)
    (reachable : Comparison (reachFrame Options.process Options.adm) (fun _ => True) Better) :
    False :=
  match Options.disagree with
  | ⟨⟨includes, t, x, yes, no⟩, widens⟩ =>
    irrefl _ (trans
      (realized .k (.e 0) ⟨fun p held => includes p.1 p.2 held, (t, x), trivial, yes, no⟩)
      (reachable (.e 0) .k (widens_iff_extension.mp widens)))

/-- **Probe I4.** On `Joint`, no comparison read off a description that the possible within every
horizon determines, comparing no description with itself, satisfies C read on the reachable ranges:
the law form of `Regimes.no_comparison_through_marginals`, through `Comparison.separates`. -/
theorem joint_no_comparison_through_possible {D : Type} (π : Joint.Config → D)
    (determines : ∀ a b, (∀ k x, Reaching.PossibleWithin Joint.process Joint.adm k a x ↔
      Reaching.PossibleWithin Joint.process Joint.adm k b x) → π a = π b)
    (compare : D → D → Prop) (irreflexive : ∀ d, ¬ compare d d) :
    ¬ Comparison (reachFrame Joint.process Joint.adm) (fun _ => True) (fun s t => compare (π s) (π t)) :=
  fun comparison => Comparison.separates irreflexive comparison (widens_iff_extension.mp Joint.widens)
    (determines _ _ fun k _ => (Joint.same_possibleWithin k).symm)

end ProbeUE10

end Becoming
