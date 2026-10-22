import Becoming.Prelude

/-!
# Fault envelopes: what a certificate over a roster of domains warrants

A roster lists the domains whose reports are counted; a fault envelope lists the sets of domains
that may fail together, as supplied by an analysis of shared causes (`Envelope`). A certificate
holds where the envelope is not empty and, for every admitted fault set, some domain outside it
supports (`certificate`). The envelope is separated where every two admitted fault sets leave a
domain outside both (`separated`).

* **Soundness.** An accepted certificate has, for each admitted fault set, a supporting domain
  outside it (`certificate_witness`), so whatever every faithful domain outside the actual fault
  set warrants holds wherever the actual fault set is admitted (`certificate_sound`).
* **Availability is separation.** Where the envelope is separated and every domain outside the
  actual fault set supports, the certificate holds (`certificate_available`); support held only
  inside one admitted fault set is rejected (`support_inside_fault_rejected`); two admitted sets
  that cover the roster can make every faithful support insufficient (`covering_faults_reject`);
  and the certificate is available for every admitted fault set exactly where the envelope is
  separated (`availability_iff_separated`).
* **No warrant from multiplicity or from an empty model.** Listing the roster twice warrants
  nothing more (`duplicated_roster_same`); an empty envelope certifies nothing
  (`empty_envelope_rejects`); an envelope admitting the whole roster certifies nothing
  (`total_fault_rejects`); and a stronger envelope, covering each fault set of a weaker one,
  accepts only what the weaker one accepts (`stronger_envelope_no_new_acceptance`).
* **Named envelopes.** One fault among three domains is separated (`one_fault_separation`), as is
  a correlated pair among four (`correlated_four_separation`); a correlated pair among three can
  block availability (`correlated_three_blocks`).

The roster, the envelope and the faithfulness of domains outside the actual fault set are
supplied; this is not Byzantine agreement, a proof of legitimate initial authority or a
cryptographic implementation. This states the certificate laws of `FaultTolerantCorrection`
(8 October) in the core (board item F3C, 18 October 2026). No premise; every declaration has an
empty axiom report.
* **Copied witnesses warrant nothing more.** Where each added witness copies one on the roster,
  supporting as it supports and inside every fault set it is inside, the certificate is unchanged
  (`copied_roster_same`; `duplicated_roster_same`, the roster listed twice, its case).
-/

namespace Becoming

open ListTests

namespace FaultEnvelopes

/-- A domain of the roster. -/
abbrev Domain := Nat
/-- An envelope: the sets of domains admitted to fail together. -/
abbrev Envelope := List (List Domain)

/-- A certificate: the envelope is not empty, and for every admitted fault set some domain of
the roster outside it supports. -/
def certificate (roster : List Domain) (faults : Envelope) (supports : Domain → Bool) : Bool :=
  !faults.isEmpty && faults.all (fun bad => roster.any (fun d => supports d && !(bad.contains d)))

/-- Every two admitted fault sets leave a domain of the roster outside both. -/
def separated (roster : List Domain) (faults : Envelope) : Prop :=
  ∀ a, a ∈ faults → ∀ b, b ∈ faults → ∃ d, d ∈ roster ∧ ¬ d ∈ a ∧ ¬ d ∈ b

/-- One domain's term: it supports and lies outside the fault set. -/
theorem supports_outside_iff {supports : Domain → Bool} {bad : List Domain} {d : Domain} :
    (supports d && !(bad.contains d)) = true ↔ supports d = true ∧ ¬ d ∈ bad :=
  and_true_iff.trans ⟨fun ⟨s, o⟩ => ⟨s, contains_false_iff.mp (not_true_iff.mp o)⟩,
    fun ⟨s, o⟩ => ⟨s, not_true_iff.mpr (contains_false_iff.mpr o)⟩⟩

/-- **What a certificate says.** -/
theorem certificate_iff {roster : List Domain} {faults : Envelope} {supports : Domain → Bool} :
    certificate roster faults supports = true ↔
      faults ≠ [] ∧ ∀ bad, bad ∈ faults → ∃ d, d ∈ roster ∧ supports d = true ∧ ¬ d ∈ bad :=
  and_true_iff.trans ⟨fun ⟨n, all⟩ => ⟨not_isEmpty_true_iff.mp n, fun bad m =>
      match any_true_iff.mp (all_true_iff.mp all bad m) with
      | ⟨d, md, sd⟩ => ⟨d, md, supports_outside_iff.mp sd⟩⟩,
    fun ⟨n, all⟩ => ⟨not_isEmpty_true_iff.mpr n, all_true_iff.mpr fun bad m =>
      match all bad m with
      | ⟨d, md, sd⟩ => any_true_iff.mpr ⟨d, md, supports_outside_iff.mpr sd⟩⟩⟩

/-! ## Soundness -/

/-- **An accepted certificate has, for each admitted fault set, a supporting domain outside
it.** -/
theorem certificate_witness (roster : List Domain) (faults : Envelope)
    (supports : Domain → Bool) (accepted : certificate roster faults supports = true)
    (bad : List Domain) (admitted : bad ∈ faults) :
    ∃ d, d ∈ roster ∧ supports d = true ∧ ¬ d ∈ bad :=
  (certificate_iff.mp accepted).2 bad admitted

/-- **What every faithful domain outside the actual fault set warrants holds wherever the
certificate is accepted and the actual fault set admitted.** -/
theorem certificate_sound (roster : List Domain) (faults : Envelope)
    (supports : Domain → Bool) (bad : List Domain) (admitted : bad ∈ faults)
    (P : Prop) (reliable : ∀ d, d ∈ roster → ¬ d ∈ bad → supports d = true → P)
    (accepted : certificate roster faults supports = true) : P :=
  match certificate_witness roster faults supports accepted bad admitted with
  | ⟨d, member, support, outside⟩ => reliable d member outside support

/-! ## Availability is separation -/

/-- **Where the envelope is separated and every domain outside the actual fault set supports,
the certificate holds.** -/
theorem certificate_available (roster : List Domain) (faults : Envelope)
    (bad : List Domain) (admitted : bad ∈ faults)
    (apart : separated roster faults) (supports : Domain → Bool)
    (responsive : ∀ d, d ∈ roster → ¬ d ∈ bad → supports d = true) :
    certificate roster faults supports = true :=
  certificate_iff.mpr ⟨fun e => absurd (e ▸ admitted) not_mem_nil, fun other m =>
    match apart bad admitted other m with
    | ⟨d, member, notBad, notOther⟩ => ⟨d, member, responsive d member notBad, notOther⟩⟩

/-- **Support held only inside one admitted fault set is rejected.** -/
theorem support_inside_fault_rejected (roster : List Domain) (faults : Envelope)
    (supports : Domain → Bool) (bad : List Domain) (admitted : bad ∈ faults)
    (contained : ∀ d, d ∈ roster → supports d = true → d ∈ bad) :
    certificate roster faults supports = false :=
  false_iff_not.mpr fun accepted =>
    match certificate_witness roster faults supports accepted bad admitted with
    | ⟨d, member, support, outside⟩ => outside (contained d member support)

/-- **Two admitted fault sets that cover the roster make the support of the domains outside the
actual one insufficient.** -/
theorem covering_faults_reject (roster : List Domain) (faults : Envelope)
    (actual possible : List Domain) (admitted : possible ∈ faults)
    (cover : ∀ d, d ∈ roster → d ∈ actual ∨ d ∈ possible) :
    certificate roster faults (fun d => !(actual.contains d)) = false :=
  support_inside_fault_rejected roster faults _ possible admitted fun d member supports =>
    (cover d member).resolve_left (contains_false_iff.mp (not_true_iff.mp supports))

/-- **The certificate is available for every admitted fault set exactly where the envelope is
separated.** -/
theorem availability_iff_separated (roster : List Domain) (faults : Envelope) :
    (∀ actual, actual ∈ faults → certificate roster faults (fun d => !(actual.contains d)) = true) ↔
      separated roster faults :=
  ⟨fun available a aIn b bIn =>
    match certificate_witness roster faults _ (available a aIn) b bIn with
    | ⟨d, member, support, notB⟩ =>
      ⟨d, member, contains_false_iff.mp (not_true_iff.mp support), notB⟩,
   fun apart actual actualIn =>
    certificate_available roster faults actual actualIn apart _
      (fun _ _ outside => not_true_iff.mpr (contains_false_iff.mpr outside))⟩

/-! ## No warrant from multiplicity or from an empty model -/

theorem any_append {α : Type} {p : α → Bool} :
    ∀ (l m : List α), (l ++ m).any p = (l.any p || m.any p)
  | [], _ => rfl
  | a :: l, m => (congrArg (p a || ·) (any_append l m)).trans (Bool.or_assoc (p a) _ _).symm

theorem or_self (b : Bool) : (b || b) = b := match b with | true => rfl | false => rfl

theorem all_congr {α : Type} {p q : α → Bool} :
    ∀ {l : List α}, (∀ x, x ∈ l → p x = q x) → l.all p = l.all q
  | [], _ => rfl
  | a :: l, same => by
    show (p a && l.all p) = (q a && l.all q)
    rw [same a (.head l), all_congr fun x m => same x (.tail a m)]

/-- An added test true only where a test already true is, adds nothing to their disjunction. -/
theorem or_absorbed {a b : Bool} (absorbed : a = true → b = true) : (a || b) = b :=
  match a, b with
  | false, _ => rfl
  | true, true => rfl
  | true, false => absurd (absorbed rfl) (fun h => Bool.noConfusion h)

/-- **Witnesses copying witnesses on the roster warrant nothing more.** Where each added witness
supports as some witness on the roster does and lies in exactly the admitted fault sets it lies
in, the certificate over the longer roster is the certificate over the roster: a witness whose
report and failures go with another's is no second check. -/
theorem copied_roster_same {roster extra : List Domain} {faults : Envelope} {supports : Domain → Bool}
    (copies : ∀ e, e ∈ extra → ∃ d, d ∈ roster ∧ supports e = supports d ∧
      ∀ bad, bad ∈ faults → (e ∈ bad ↔ d ∈ bad)) :
    certificate (extra ++ roster) faults supports = certificate roster faults supports :=
  congrArg (!faults.isEmpty && ·) (all_congr fun bad inside => (any_append extra roster).trans
    (or_absorbed fun some => match any_true_iff.mp some with
      | ⟨e, member, holds⟩ => match copies e member, supports_outside_iff.mp holds with
        | ⟨d, onRoster, same, alike⟩, ⟨supported, outside⟩ =>
          any_true_iff.mpr ⟨d, onRoster, supports_outside_iff.mpr
            ⟨same ▸ supported, fun within => outside ((alike bad inside).mpr within)⟩⟩))

/-- **Listing the roster twice warrants nothing more**: each witness listed again copies itself. -/
theorem duplicated_roster_same (roster : List Domain) (faults : Envelope)
    (supports : Domain → Bool) :
    certificate (roster ++ roster) faults supports = certificate roster faults supports :=
  copied_roster_same fun e member => ⟨e, member, rfl, fun _ _ => Iff.rfl⟩

/-- **An empty envelope certifies nothing.** -/
theorem empty_envelope_rejects (roster : List Domain) (supports : Domain → Bool) :
    certificate roster [] supports = false := rfl

/-- **An envelope admitting the whole roster certifies nothing.** -/
theorem total_fault_rejects (roster : List Domain) (faults : Envelope)
    (supports : Domain → Bool) (admitted : roster ∈ faults) :
    certificate roster faults supports = false :=
  support_inside_fault_rejected roster faults supports roster admitted fun _ m _ => m

/-- **A stronger envelope, covering each fault set of a weaker one, accepts only what the weaker
one accepts.** -/
theorem stronger_envelope_no_new_acceptance
    (roster : List Domain) (old new : Envelope) (supports : Domain → Bool)
    (nonempty : old ≠ [])
    (covers : ∀ b, b ∈ old → ∃ c, c ∈ new ∧ ∀ d, d ∈ b → d ∈ c)
    (accepted : certificate roster new supports = true) :
    certificate roster old supports = true :=
  certificate_iff.mpr ⟨nonempty, fun b hb =>
    match covers b hb with
    | ⟨c, hc, cover⟩ => match certificate_witness roster new supports accepted c hc with
      | ⟨d, member, support, outside⟩ => ⟨d, member, support, fun inB => outside (cover d inB)⟩⟩

/-! ## Named envelopes -/

/-- Three domains. -/
def roster3 : List Domain := [0, 1, 2]
/-- One fault at a time among three. -/
def singleFault : Envelope := [[0], [1], [2]]
/-- Domains 0 and 1 fail together; or domain 2. -/
def correlated3 : Envelope := [[0, 1], [2]]
/-- Four domains. -/
def roster4 : List Domain := [0, 1, 2, 3]
/-- Domains 0 and 1 fail together; or 2; or 3. -/
def correlated4 : Envelope := [[0, 1], [2], [3]]

/-- Separation, decided over the listed envelope. -/
def separatedTest (roster : List Domain) (faults : Envelope) : Bool :=
  faults.all fun a => faults.all fun b => roster.any fun d => !(a.contains d) && !(b.contains d)

theorem separated_of_test {roster : List Domain} {faults : Envelope}
    (h : separatedTest roster faults = true) : separated roster faults :=
  fun a am b bm => match any_true_iff.mp (all_true_iff.mp (all_true_iff.mp h a am) b bm) with
    | ⟨d, md, both⟩ => ⟨d, md, contains_false_iff.mp (not_true_iff.mp (and_true_iff.mp both).1),
        contains_false_iff.mp (not_true_iff.mp (and_true_iff.mp both).2)⟩

/-- **One fault among three domains is separated.** -/
theorem one_fault_separation : separated roster3 singleFault := separated_of_test (by decide)

/-- **A correlated pair among four domains is separated.** -/
theorem correlated_four_separation : separated roster4 correlated4 := separated_of_test (by decide)

/-- **A correlated pair among three can block availability.** -/
theorem correlated_three_blocks : certificate roster3 correlated3 (fun d => d == 2) = false := by
  decide

end FaultEnvelopes

end Becoming
