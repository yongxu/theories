import Becoming.Contacts

/-!
# Contact courses: revision rules as processes, and encodings along a run of channels

`Becoming.Contacts` states what a lumping through addressed contacts selects and how a rule
forming the next plan from the present plan and the failed address answers failures: a rule that
does not read the failure (`Contacts.Blind`) answers every failure exactly where its plans contact
every address, and with finitely many addresses a blind rule can answer every failure. It also
states that an installed encoding stays right across a change of channel exactly where the new
channel agrees with the old at the encoded inputs. A revision rule is a law of change whose moves
are the reports of failure (`Assurance.ofMap`); a channel is a configuration, and a change of
channel a step of a run. This module states those laws of the rule's process and of runs of
channels.

* **A blind rule's process answers every failure exactly where every step reporting no failure
  lands on a plan contacting every address** (`blind_answers_steps_iff`). With two addresses, the
  rule contacting both is blind on its process, every step landing where the step reporting no
  failure lands, and every step reporting a failure lands on a plan contacting the failed address
  (`finite_blind_answers_steps`).
* **Along a run of channels, an encoding installed at the start stays right at a date exactly
  where the channel then agrees with the first at the encoded inputs** (`run_stays_iff`).

No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

open Generative Assurance

universe v

namespace ContactCourses

section Rules

variable {I : Type}

/-- **A blind rule's process answers every failure exactly where every step reporting no failure
lands on a plan contacting every address.** Every step of the rule's process reporting a failure
at `i` lands on a plan contacting `i` exactly where every step reporting no failure lands on a plan
contacting every address. -/
theorem blind_answers_steps_iff {ρ : List I → Option I → List I} (blind : Contacts.Blind ρ) :
    (∀ D i D', (ofMap ρ).step D (some i) D' → i ∈ D') ↔
      ∀ D i D', (ofMap ρ).step D none D' → i ∈ D' :=
  have answers : (∀ D i D', (ofMap ρ).step D (some i) D' → i ∈ D') ↔ Contacts.Answers ρ :=
    ⟨fun each D i => each D i _ rfl,
     fun answered D i _ step => Eq.subst (motive := fun X => i ∈ X) step.symm (answered D i)⟩
  answers.trans ((Contacts.blind_answers_iff blind).trans
    ⟨fun each D i _ step => Eq.subst (motive := fun X => i ∈ X) step.symm (each D i),
     fun each D i => each D i _ rfl⟩)

/-- **With two addresses a blind rule's process can answer every failure.** In the process of the
rule contacting both addresses, every step lands where the step reporting no failure lands, and
every step reporting a failure lands on a plan contacting the failed address. -/
theorem finite_blind_answers_steps :
    (∀ D r D', (ofMap (fun (_ : List Bool) (_ : Option Bool) => [false, true])).step D r D' →
        (ofMap (fun (_ : List Bool) (_ : Option Bool) => [false, true])).step D none D') ∧
      ∀ D i D', (ofMap (fun (_ : List Bool) (_ : Option Bool) => [false, true])).step D (some i) D' →
        i ∈ D' :=
  ⟨fun D r _ step => step.trans (Contacts.finite_blind_answers.1 D r),
   fun D i _ step => Eq.subst (motive := fun X => i ∈ X) step.symm
     (Contacts.finite_blind_answers.2 D i)⟩

end Rules

/-- **Along a run of channels, an encoding installed at the start stays right at a date exactly
where the channel then agrees with the first at the encoded inputs.** -/
theorem run_stays_iff {X : Type} {A : Type v} {P : Process (X → Bool) A} (r : Run P)
    {e : Bool → X} (works : ∀ b, r.state 0 (e b) = b) (n : Nat) :
    (∀ b, r.state n (e b) = b) ↔ ∀ b, r.state n (e b) = r.state 0 (e b) :=
  References.stays_iff works

end ContactCourses

end Becoming
