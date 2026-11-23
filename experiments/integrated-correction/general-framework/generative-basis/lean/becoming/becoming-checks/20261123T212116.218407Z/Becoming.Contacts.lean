import Becoming.Revision

/-!
# Contacts: lumping through addressed contacts, its revision, and reference pairs

General laws of which the contact plans of `Becoming.ReferencePlan` and
`Becoming.ContinuingRevision` are instances. A plan reads signals at a finite list of
addresses (its contacts); two signals are alike where they agree at every contact. Nothing is
assumed beyond decidable equality of addresses.

* **What a plan lumps.** The lumping through a plan is the shared agreement on data
  (`Learning.Training.AgreeOn`), the data being the contacts. For any decided data, the
  selection of a signal's value at an address is through agreement on the data exactly where
  the address is in the data (`through_data_iff`), and a change of data keeps every old
  selection exactly where it retains the old data (`keeps_data_iff`, `survive_data_iff`). For
  plans: a selection at an address is through the plan exactly where the plan contacts it
  (`through_at_iff`). A change of plan keeps every old selection exactly where it retains every
  old contact (`keeps_iff_retains`, `selections_survive_iff`, by `Learning.Training.keeps_through_iff`); a retired
  contact loses its selection (`retired_loses`), an added one gains it (`Contacts.retired_loses`). Along
  every trace whose steps retain contacts, all selections are kept (`trace_keeps_of_retains`).
* **Revision that reads its consequences.** A rule forming the next plan from the present plan
  and the address at which the last activity failed answers every failure, in the sense that
  the next plan contacts the failed address, exactly where its output contains that address
  (`answers_iff`). A rule that does not read the failure (`Blind`) answers every failure
  exactly where its plan contacts every address (`blind_answers_iff`); where no list holds
  every address (`Unlisted`, as for `Nat`), every rule not reading the failure leaves, at every plan, some
  failure unanswered (`blind_misses`). With finitely many addresses the converse fails
  (`finite_blind_answers`).
* **Reference pairs.** Two reference responses of a two-valued channel, used as the encoding
  `pick`, drive it to both targets exactly when they differ (`drives_iff`). An installed
  encoding stays right across a change of channel exactly where the new channel agrees with
  the old at the encoded inputs (`stays_iff`); an inverted channel fails at every target
  (`inverted_fails`).

No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

open Generative

universe u v

namespace Contacts

variable {I : Type} [DecidableEq I]

/-- Two signals agree at every contacted address: the shared `Learning.Training.AgreeOn`, the
data being the contacts. -/
abbrev AgreeOn {V : Type} (plan : List I) : (I → V) → (I → V) → Prop :=
  Learning.Training.AgreeOn (fun i => i ∈ plan)

/-- Membership in a list, decided with no premise. -/
theorem mem_or_not (i : I) : ∀ l : List I, i ∈ l ∨ i ∉ l :=
  fun l => @Decidable.em (i ∈ l) (decideMem i l)

/-- The signal that is `true` at `i` alone. -/
def spot (i : I) : I → Bool := fun j => if j = i then true else false

theorem spot_self (i : I) : spot i i = true := if_pos rfl

theorem spot_other {i j : I} (ne : j ≠ i) : spot i j = false := if_neg ne

/-! ### Registration through data, any decided data -/

/-- Where `i` is not in the data, the silent signal and the signal at `i` alone agree on it. -/
theorem agree_spot {D : I → Prop} {i : I} (absent : ¬ D i) :
    Learning.Training.AgreeOn D (fun _ => false) (spot i) :=
  fun j m => (spot_other (j := j) fun (e : j = i) => absent (e ▸ m)).symm

/-- **What a lumping through data selects.** The value at `i` is selected through agreement
on decided data exactly where `i` is in the data. -/
theorem through_data_iff {D : I → Prop} (decided : ∀ i, D i ∨ ¬ D i) {i : I} :
    Learning.Training.Through (Learning.Training.AgreeOn D) (fun x : I → Bool => x i = true) ↔ D i :=
  ⟨fun through => match decided i with
    | .inl m => m
    | .inr absent => absurd ((through _ _ (agree_spot absent)).mpr (spot_self i))
        fun h => Bool.noConfusion h,
   fun m _ _ h => ⟨fun hx => (h _ m).symm.trans hx, fun hy => (h _ m).trans hy⟩⟩

/-- **A change of data keeps the old lumping exactly where it retains the old data.** -/
theorem keeps_data_iff {S : Type u} {D : S → I → Prop} (s t : S)
    (decided : ∀ i, D t i ∨ ¬ D t i) :
    Registration.Keeps (fun s => Learning.Training.AgreeOn (V := Bool) (D s)) s t ↔
      ∀ i, D s i → D t i :=
  ⟨fun keeps i m => match decided i with
    | .inl m' => m'
    | .inr absent =>
      absurd ((keeps _ _ (agree_spot absent)) i m) fun h => Bool.noConfusion (h.trans (spot_self i)),
   fun retains _ _ h i m => h i (retains i m)⟩

/-- **Every old selection survives exactly where the old data are retained.** -/
theorem survive_data_iff {S : Type u} {D : S → I → Prop} (s t : S)
    (decided : ∀ i, D t i ∨ ¬ D t i) :
    (∀ select, Learning.Training.Through (Learning.Training.AgreeOn (V := Bool) (D s)) select →
      Learning.Training.Through (Learning.Training.AgreeOn (D t)) select) ↔ ∀ i, D s i → D t i :=
  (Learning.Training.keeps_through_iff (old := Learning.Training.AgreeOn (V := Bool) (D s))
    (new := Learning.Training.AgreeOn (D t)) (fun _ _ _ => rfl) (fun _ _ h i m => (h i m).symm)
    (fun _ _ _ h k i m => (h i m).trans (k i m))).trans (keeps_data_iff s t decided)

/-! ### Contact plans: the data held by a list -/

omit [DecidableEq I] in
theorem AgreeOn.refl {V : Type} (plan : List I) (x : I → V) : AgreeOn plan x x := fun _ _ => rfl

theorem through_at_iff {plan : List I} {i : I} :
    Learning.Training.Through (AgreeOn plan) (fun x : I → Bool => x i = true) ↔ i ∈ plan :=
  through_data_iff (fun j => mem_or_not j plan)

theorem keeps_iff_retains {S : Type u} (plan : S → List I) (s t : S) :
    Registration.Keeps (fun s => AgreeOn (V := Bool) (plan s)) s t ↔ ∀ i, i ∈ plan s → i ∈ plan t :=
  keeps_data_iff (D := fun s i => i ∈ plan s) s t (fun j => mem_or_not j (plan t))

theorem selections_survive_iff {S : Type u} (plan : S → List I) (s t : S) :
    (∀ select, Learning.Training.Through (AgreeOn (V := Bool) (plan s)) select →
      Learning.Training.Through (AgreeOn (plan t)) select) ↔ ∀ i, i ∈ plan s → i ∈ plan t :=
  survive_data_iff (D := fun s i => i ∈ plan s) s t (fun j => mem_or_not j (plan t))

/-- A retired contact loses its selection. -/
theorem retired_loses {D D' : List I} {i : I} (held : i ∈ D) (retired : i ∉ D') :
    Learning.Training.Through (AgreeOn D) (fun x : I → Bool => x i = true) ∧
      ¬ Learning.Training.Through (AgreeOn D') (fun x : I → Bool => x i = true) :=
  ⟨through_at_iff.mpr held, fun h => retired (through_at_iff.mp h)⟩

/-- Along every trace whose steps retain contacts, every selection is kept. -/
theorem trace_keeps_of_retains {S : Type u} {A : Type v} {P : Process S A} {plan : S → List I}
    (retains : ∀ s a t, P.step s a t → ∀ i, i ∈ plan s → i ∈ plan t)
    {s t : S} {as : List A} (path : Trace P s as t) :
    ∀ select, Learning.Training.Through (AgreeOn (V := Bool) (plan s)) select →
      Learning.Training.Through (AgreeOn (plan t)) select :=
  (selections_survive_iff plan s t).mpr
    ((keeps_iff_retains plan s t).mp
      (Registration.trace_keeps (fun s a t step => (keeps_iff_retains plan s t).mpr
        (retains s a t step)) path))

/-! ## Revision that reads its consequences -/

/-- The next plan contacts every failed address. -/
def Answers (ρ : List I → Option I → List I) : Prop := ∀ D i, i ∈ ρ D (some i)

/-- **A revision rule answers every failure exactly where its output contains the failed
address.** -/
theorem answers_iff (ρ : List I → Option I → List I) :
    (∀ D i, Learning.Training.Through (AgreeOn (ρ D (some i))) (fun x : I → Bool => x i = true)) ↔
      Answers ρ :=
  ⟨fun h D i => through_at_iff.mp (h D i), fun h D i => through_at_iff.mpr (h D i)⟩

/-- The rule does not read what the last activity acquired. -/
def Blind (ρ : List I → Option I → List I) : Prop := ∀ D r, ρ D r = ρ D none

omit [DecidableEq I] in
/-- A rule not reading the failure answers every failure exactly where its plans contact every address. -/
theorem blind_answers_iff {ρ : List I → Option I → List I} (blind : Blind ρ) :
    Answers ρ ↔ ∀ D i, i ∈ ρ D none :=
  ⟨fun h D i => blind D (some i) ▸ h D i, fun h D i => (blind D (some i)).symm ▸ h D i⟩

/-- No list holds every address. -/
def Unlisted (I : Type) : Prop := ∀ l : List I, ∃ i, i ∉ l

/-- **A rule not reading its consequences leaves, at every plan, some failure unanswered**, where no
list holds every address. -/
theorem blind_misses {ρ : List I → Option I → List I} (blind : Blind ρ) (unlisted : Unlisted I)
    (D : List I) :
    ∃ i, ¬ Learning.Training.Through (AgreeOn (ρ D (some i))) (fun x : I → Bool => x i = true) :=
  match unlisted (ρ D none) with
  | ⟨i, absent⟩ => ⟨i, fun through => absent (blind D (some i) ▸ through_at_iff.mp through)⟩

/-- Every list of numbers is bounded strictly above. -/
theorem nat_bound : ∀ l : List Nat, ∃ b, ∀ m, m ∈ l → m < b
  | [] => ⟨0, fun _ h => nomatch h⟩
  | n :: l => match nat_bound l with
    | ⟨b, below⟩ => ⟨b + n + 1, fun m h => match h with
      | .head _ => Nat.lt_succ_of_le (Nat.le_add_left _ b)
      | .tail _ h => Nat.lt_of_lt_of_le (below m h)
          (Nat.le_trans (Nat.le_add_right b n) (Nat.le_succ _))⟩

theorem nat_unlisted : Unlisted Nat := fun l =>
  match nat_bound l with
  | ⟨b, below⟩ => ⟨b, fun h => Nat.lt_irrefl b (below b h)⟩

/-- With finitely many addresses a rule not reading the failure can answer every failure. -/
theorem finite_blind_answers :
    Blind (I := Bool) (fun _ _ => [false, true]) ∧ Answers (I := Bool) (fun _ _ => [false, true]) :=
  ⟨fun _ _ => rfl, fun _ i => match i with
    | false => List.Mem.head _
    | true => List.Mem.tail _ (List.Mem.head _)⟩

end Contacts

/-! ## Reference pairs -/

namespace References

variable {X : Type}

/-- The encoding a reference pair supplies: use `x` where its response is the target. -/
def pick (c : X → Bool) (x y : X) (b : Bool) : X := if c x = b then x else y

theorem bool_other : ∀ {p q r : Bool}, p ≠ q → p ≠ r → q = r
  | false, false, _, h, _ => absurd rfl h
  | true, true, _, h, _ => absurd rfl h
  | false, true, false, _, h => absurd rfl h
  | false, true, true, _, _ => rfl
  | true, false, true, _, h => absurd rfl h
  | true, false, false, _, _ => rfl

/-- **Two reference responses drive a two-valued channel to both targets exactly when they
differ.** -/
theorem drives_iff (c : X → Bool) (x y : X) : (∀ b, c (pick c x y b) = b) ↔ c x ≠ c y :=
  ⟨fun drives same =>
    have each : ∀ b, c (pick c x y b) = c x := fun b =>
      match decEq (c x) b with
      | isTrue e => congrArg c (if_pos e)
      | isFalse n => (congrArg c (if_neg n)).trans same.symm
    Bool.noConfusion ((drives false).symm.trans
      ((each false).trans ((each true).symm.trans (drives true)))),
   fun apart b => match decEq (c x) b with
    | isTrue e => (congrArg c (if_pos e)).trans e
    | isFalse n => (congrArg c (if_neg n)).trans (bool_other apart n)⟩

/-- **An installed encoding stays right across a change of channel exactly where the new
channel agrees with the old at the encoded inputs.** -/
theorem stays_iff {c c' : X → Bool} {e : Bool → X} (works : ∀ b, c (e b) = b) :
    (∀ b, c' (e b) = b) ↔ ∀ b, c' (e b) = c (e b) :=
  ⟨fun h b => (h b).trans (works b).symm, fun h b => (h b).trans (works b)⟩

/-- An inverted channel fails an installed encoding at every target. -/
theorem inverted_fails {c : X → Bool} {e : Bool → X} (works : ∀ b, c (e b) = b) (b : Bool) :
    (fun x => !(c x)) (e b) ≠ b := fun h =>
  have flipped : (!b) = b := (congrArg (fun z => !z) (works b)).symm.trans h
  match b, flipped with
  | false, h => Bool.noConfusion h
  | true, h => Bool.noConfusion h

end References

end Becoming
