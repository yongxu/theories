import Becoming.Inquiry

/-!
# Learning a rule by narrowing a belief through observation

A belief over candidate rules (`Rule Q := Q → Bool`) is narrowed by observations of one history:
observing value `b` at question `q` keeps exactly the believed rules giving `b` there. That is
`After` on the pure observation of a rule's value (`narrowed`, `revise_is_after`), and the list
procedure `learn` computes it (`mem_learn_iff`). A belief settles `q` at `b` where it holds some
rule and every rule it holds gives `b` (`Settles`); the answer procedure answers exactly what the
learned list's belief settles (`answer_iff`), it is safe, and it is the greatest safe answer. The
candidates, the acquisition law and the questions are supplied; nothing here defines
understanding or authority by a successful test, and no field exposes the actual rule to the answer
procedure.

* **Narrowing keeps exactly the fitting rules** (`mem_learn`, `narrowed_iff_fits`): the actual
  rule, where it is a candidate and the observations are faithful to it, is kept
  (`actual_retained`), and a dropped candidate contradicts some observation
  (`counterevidence_of_dropped`). Repeating an observation narrows nothing more (`revise_revise`).
* **Safe and greatest.** The answer is safe for every kept rule (`answer_safe`); every safe answer
  agrees with it where it asserts (`safe_definite_requires_agreement`, `answer_maximal`), so a safe
  greatest answer is the answer at every question (`unique_maximal_safe`; with function
  extensionality named, equal as functions, `unique_maximal_safe_of_ext`).
* **Faithful acquisition answers correctly** (`acquired_evidence_faithful`,
  `acquired_answers_correct`). Re-encoding transports answers and learning where decoding inverts
  encoding (`answer_transport`, `learning_transport`), and a wrong re-encoding does not.
* **Four rules on two cases.** Every rule on two cases agrees at every case with one of four
  candidates (`repertoire_complete`; is one of them with function extensionality named,
  `repertoire_complete_of_ext`), so whatever faithful observation settles is the actual value
  (`full_repertoire_correct`). One observed case is settled and the other is not; contrasting
  observations settle both; what is settled is not the last report; repeating one case settles
  nothing new; a candidate class lacking the actual rule can settle wrongly; contradictory
  observations settle nothing.

Ported from `StandardsBridge` with the joins `RuleNarrowingProcesses` and
`RuleNarrowingProcessesInherited` and the bridge's `revise_is_after` (F3J, 18 October 2026). The
periphery's classical `eliminated_rule_has_counterevidence` is constructive here: the observations
are listed and Boolean values are decided. Every declaration has an empty axiom report.
-/

namespace Becoming

open Generative Generative.InquirySufficiency

namespace Narrowing

/-! ## Rules, observations and the list procedure -/

/-- An observation: a question and the value observed there. -/
abbrev Observation (Q : Type) := Q × Bool

/-- A candidate rule: a value at each question. -/
abbrev Rule (Q : Type) := Q → Bool

variable {Q : Type}

/-- A rule fits a list of observations where it gives each observed value. -/
def Fits (h : Rule Q) (evidence : List (Observation Q)) : Prop :=
  ∀ o, o ∈ evidence → h o.1 = o.2

/-- Revising candidates by one observation keeps those giving the observed value. -/
def revise (hs : List (Rule Q)) (o : Observation Q) : List (Rule Q) :=
  hs.filter (fun h => h o.1 == o.2)

/-- Learning revises by each observation in turn. -/
def learn : List (Rule Q) → List (Observation Q) → List (Rule Q)
  | hs, [] => hs
  | hs, o :: os => learn (revise hs o) os

/-- The answer: abstain on no candidate and on conflict, else the common value. -/
def answer (hs : List (Rule Q)) (q : Q) : Option Bool :=
  match hs with
  | [] => none
  | h :: tail => if tail.all (fun g => g q == h q) then some (h q) else none

/-- An answer is safe for candidates where every definite answer is each candidate's value. -/
def Safe (hs : List (Rule Q)) (a : Q → Option Bool) : Prop :=
  ∀ h, h ∈ hs → ∀ q b, a q = some b → b = h q

/-- An answer is greatest where it asserts whatever any safe answer asserts. -/
def Maximal (hs : List (Rule Q)) (a : Q → Option Bool) : Prop :=
  ∀ other, Safe hs other → ∀ q b, other q = some b → a q = some b

/-! ## Lists and Booleans -/

theorem beq_true_iff : ∀ x b : Bool, (x == b) = true ↔ x = b
  | false, false => ⟨fun _ => rfl, fun _ => rfl⟩
  | true, true => ⟨fun _ => rfl, fun _ => rfl⟩
  | false, true => ⟨fun h => (nomatch h), fun h => (nomatch h)⟩
  | true, false => ⟨fun h => (nomatch h), fun h => (nomatch h)⟩

theorem mem_filter {α : Type} (p : α → Bool) (x : α) :
    ∀ l : List α, x ∈ l.filter p ↔ x ∈ l ∧ p x = true
  | [] => ⟨fun h => (nomatch h), fun ⟨h, _⟩ => (nomatch h)⟩
  | a :: l => by
    have ih := mem_filter p x l
    unfold List.filter
    cases hp : p a with
    | true =>
      refine ⟨fun h => ?_, fun ⟨m, px⟩ => ?_⟩
      · cases h with
        | head => exact ⟨.head _, hp⟩
        | tail _ h => exact ⟨.tail _ (ih.mp h).1, (ih.mp h).2⟩
      · cases m with
        | head => exact .head _
        | tail _ m => exact .tail _ (ih.mpr ⟨m, px⟩)
    | false =>
      refine ⟨fun h => ⟨.tail _ (ih.mp h).1, (ih.mp h).2⟩, fun ⟨m, px⟩ => ?_⟩
      cases m with
      | head => exact absurd (hp.symm.trans px) Bool.false_ne_true
      | tail _ m => exact ih.mpr ⟨m, px⟩

theorem filter_cons_true {α : Type} {p : α → Bool} {a : α} (l : List α) (hp : p a = true) :
    (a :: l).filter p = a :: l.filter p := by
  show (match p a with
    | true => a :: l.filter p
    | false => l.filter p) = a :: l.filter p
  rw [hp]

theorem filter_cons_false {α : Type} {p : α → Bool} {a : α} (l : List α) (hp : p a = false) :
    (a :: l).filter p = l.filter p := by
  show (match p a with
    | true => a :: l.filter p
    | false => l.filter p) = l.filter p
  rw [hp]

/-- Filtering twice by one predicate filters once. -/
theorem filter_filter_self {α : Type} (p : α → Bool) : ∀ l : List α,
    (l.filter p).filter p = l.filter p
  | [] => rfl
  | a :: l => match hp : p a with
    | true => (congrArg (List.filter p) (filter_cons_true l hp)).trans
        (((filter_cons_true _ hp).trans (congrArg (a :: ·) (filter_filter_self p l))).trans
          (filter_cons_true l hp).symm)
    | false => (congrArg (List.filter p) (filter_cons_false l hp)).trans
        ((filter_filter_self p l).trans (filter_cons_false l hp).symm)

/-- Filtering a mapped list filters by the composed predicate, then maps. -/
theorem filter_map_comm {α β : Type} (f : α → β) (p : β → Bool) : ∀ l : List α,
    (l.map f).filter p = (l.filter (fun x => p (f x))).map f
  | [] => rfl
  | a :: l => by
    show List.filter p (f a :: l.map f) = List.map f (List.filter (fun x => p (f x)) (a :: l))
    unfold List.filter
    cases hp : p (f a) with
    | true => exact congrArg (f a :: ·) (filter_map_comm f p l)
    | false => exact filter_map_comm f p l

/-- `all` over a mapped list is `all` of the composed predicate. -/
theorem all_map {α β : Type} (f : α → β) (p : β → Bool) : ∀ l : List α,
    (l.map f).all p = l.all (fun x => p (f x))
  | [] => rfl
  | a :: l => congrArg (fun c => p (f a) && c) (all_map f p l)

/-! ## Narrowing as `After` on a pure observation -/

/-- The pure observation: the configuration stays as it is. -/
def observe {S A : Type} : Process S A := ⟨fun s _ t => t = s⟩

theorem after_observe_iff {S A : Type} {k : Nat} (obs : S → A → Fin k) (B : S → Prop) (q : A)
    (o : Fin k) (t : S) :
    After observe (fun s q _ => obs s q) B q o t ↔ B t ∧ obs t q = o :=
  ⟨fun ⟨_, believed, same, read⟩ => match same with
    | rfl => ⟨believed, read⟩,
   fun ⟨believed, read⟩ => ⟨t, believed, rfl, read⟩⟩

/-- Booleans as two observation outcomes. -/
def encode : Bool → Fin 2
  | false => ⟨0, Nat.zero_lt_succ 1⟩
  | true => ⟨1, Nat.succ_lt_succ (Nat.zero_lt_succ 0)⟩

theorem encode_inj : ∀ {a b : Bool}, encode a = encode b → a = b
  | false, false, _ => rfl
  | true, true, _ => rfl
  | false, true, h => Nat.noConfusion (congrArg Fin.val h)
  | true, false, h => Nat.noConfusion (congrArg Fin.val h)

/-- The pure observation of a rule at a question reads its value. -/
def sense : Rule Q → Q → Rule Q → Fin 2 :=
  fun g q _ => encode (g q)

/-- **One revision keeps exactly the candidates giving the observed value.** -/
theorem mem_revise (h : Rule Q) (hs : List (Rule Q)) (o : Observation Q) :
    h ∈ revise hs o ↔ h ∈ hs ∧ h o.1 = o.2 :=
  (mem_filter _ h hs).trans
    ⟨fun ⟨m, e⟩ => ⟨m, (beq_true_iff _ _).mp e⟩, fun ⟨m, e⟩ => ⟨m, (beq_true_iff _ _).mpr e⟩⟩

/-- **Revising a list of rules by one observation is `After` on the pure observation.** -/
theorem revise_is_after (hs : List (Rule Q)) (q : Q) (b : Bool) (h : Rule Q) :
    h ∈ revise hs (q, b) ↔ After observe sense (· ∈ hs) q (encode b) h :=
  (mem_revise h hs (q, b)).trans <|
    (Iff.intro (fun ⟨m, e⟩ => ⟨m, congrArg encode e⟩) (fun ⟨m, e⟩ => ⟨m, encode_inj e⟩)).trans
    (after_observe_iff (fun (g : Rule Q) q => encode (g q)) _ q _ h).symm

/-- **One narrowing.** After observing `b` at `q`, the belief in a list holds exactly the rules of
the list giving `b` at `q`. -/
theorem narrow_once_iff (hs : List (Rule Q)) (q : Q) (b : Bool) (h : Rule Q) :
    After observe sense (· ∈ hs) q (encode b) h ↔ h ∈ hs ∧ h q = b :=
  (revise_is_after hs q b h).symm.trans (mem_revise h hs (q, b))

/-- The belief after a list of observations: narrowed by `After` on the pure observation at each
observed question and value in turn. -/
def narrowed : (Rule Q → Prop) → List (Observation Q) → Rule Q → Prop
  | B, [] => B
  | B, o :: os => narrowed (After observe sense B o.1 (encode o.2)) os

theorem after_congr {B B' : Rule Q → Prop} (same : ∀ h, B h ↔ B' h) (q : Q) (o : Fin 2)
    (h : Rule Q) : After observe sense B q o h ↔ After observe sense B' q o h :=
  ⟨fun ⟨g, held, st, read⟩ => ⟨g, (same g).mp held, st, read⟩,
   fun ⟨g, held, st, read⟩ => ⟨g, (same g).mpr held, st, read⟩⟩

theorem narrowed_congr : ∀ (e : List (Observation Q)) {B B' : Rule Q → Prop},
    (∀ h, B h ↔ B' h) → ∀ h, narrowed B e h ↔ narrowed B' e h
  | [], _, _, same => same
  | o :: os, _, _, same => narrowed_congr os (after_congr same o.1 (encode o.2))

/-- **The learned list holds exactly the rules of the narrowed belief.** -/
theorem mem_learn_iff : ∀ (e : List (Observation Q)) (hs : List (Rule Q)) (h : Rule Q),
    h ∈ learn hs e ↔ narrowed (· ∈ hs) e h
  | [], _, _ => Iff.rfl
  | o :: os, hs, h => (mem_learn_iff os (revise hs o) h).trans
      (narrowed_congr os (fun g => revise_is_after hs o.1 o.2 g) h)

/-- **Learning keeps exactly the candidates fitting every observation.** -/
theorem mem_learn : ∀ (h : Rule Q) (hs : List (Rule Q)) (e : List (Observation Q)),
    h ∈ learn hs e ↔ h ∈ hs ∧ Fits h e
  | _, _, [] => ⟨fun m => ⟨m, fun _ none => nomatch none⟩, fun ⟨m, _⟩ => m⟩
  | h, hs, o :: os => (mem_learn h (revise hs o) os).trans
      ⟨fun ⟨m, fits⟩ => match (mem_revise h hs o).mp m with
        | ⟨kept, now⟩ => ⟨kept, fun x n => match n with
          | .head _ => now
          | .tail _ n => fits x n⟩,
       fun ⟨kept, fits⟩ => ⟨(mem_revise h hs o).mpr ⟨kept, fits o (.head _)⟩,
         fun x n => fits x (.tail _ n)⟩⟩

/-- **The narrowed belief holds exactly the believed rules fitting every observation.** -/
theorem narrowed_iff_fits (hs : List (Rule Q)) (e : List (Observation Q)) (h : Rule Q) :
    narrowed (· ∈ hs) e h ↔ h ∈ hs ∧ Fits h e :=
  (mem_learn_iff e hs h).symm.trans (mem_learn h hs e)

/-- **The actual rule, a candidate faithful to the observations, is kept.** -/
theorem actual_retained (actual : Rule Q) (hs : List (Rule Q)) (e : List (Observation Q))
    (included : actual ∈ hs) (faithful : Fits actual e) : actual ∈ learn hs e :=
  (mem_learn actual hs e).mpr ⟨included, faithful⟩

/-- A rule fitting no list of observations contradicts one of them. -/
theorem counterevidence_of_not_fits (h : Rule Q) : ∀ e : List (Observation Q),
    ¬ Fits h e → ∃ o, o ∈ e ∧ h o.1 ≠ o.2
  | [], no => absurd (fun _ none => nomatch none) no
  | o :: os, no =>
    match hb : (h o.1 == o.2) with
    | true =>
      have now := (beq_true_iff _ _).mp hb
      match counterevidence_of_not_fits h os (fun fits => no fun x n => match n with
          | .head _ => now
          | .tail _ n => fits x n) with
      | ⟨x, n, ne⟩ => ⟨x, .tail _ n, ne⟩
    | false => ⟨o, .head _, fun eq => Bool.noConfusion (hb.symm.trans ((beq_true_iff _ _).mpr eq))⟩

/-- **An eliminated candidate contradicts some observation.** -/
theorem counterevidence_of_eliminated (h : Rule Q) (hs : List (Rule Q))
    (e : List (Observation Q)) (included : h ∈ hs) (removed : h ∉ learn hs e) :
    ∃ o, o ∈ e ∧ h o.1 ≠ o.2 :=
  counterevidence_of_not_fits h e fun fits => removed ((mem_learn h hs e).mpr ⟨included, fits⟩)

/-- **A rule the belief held and the narrowing dropped contradicts some observation.** -/
theorem counterevidence_of_dropped {hs : List (Rule Q)} {e : List (Observation Q)} {h : Rule Q}
    (held : h ∈ hs) (dropped : ¬ narrowed (· ∈ hs) e h) : ∃ o, o ∈ e ∧ h o.1 ≠ o.2 :=
  counterevidence_of_eliminated h hs e held fun m => dropped ((mem_learn_iff e hs h).mp m)

/-- **Repeating an observation changes no candidate.** -/
theorem revise_revise (hs : List (Rule Q)) (o : Observation Q) :
    revise (revise hs o) o = revise hs o :=
  filter_filter_self _ hs

/-- **Observing the same thing twice narrows as observing it once.** -/
theorem repeated_observation_idle (hs : List (Rule Q)) (o : Observation Q) (h : Rule Q) :
    narrowed (· ∈ hs) [o, o] h ↔ narrowed (· ∈ hs) [o] h :=
  (mem_learn_iff [o, o] hs h).symm.trans
    ((Eq.subst (motive := fun l => h ∈ learn (revise hs o) [o] ↔ h ∈ l) (revise_revise hs o)
        Iff.rfl).trans (mem_learn_iff [o] hs h))

/-! ## Settling and the answer -/

/-- A belief settles question `q` at `b`: it holds some rule, and every rule it holds gives `b`. -/
def Settles (B : Rule Q → Prop) (q : Q) (b : Bool) : Prop :=
  InhabitedBelief B ∧ ∀ h, B h → h q = b

/-- The answer procedure on a list with first rule `h`. -/
def onCons (h : Rule Q) (q : Q) (c : Bool) : Option Bool :=
  if c = true then some (h q) else none

/-- **What the answer procedure answers, the list's belief settles.** -/
theorem answer_some : ∀ {hs : List (Rule Q)} {q : Q} {b : Bool},
    answer hs q = some b → Settles (· ∈ hs) q b
  | [], _, _, ans => absurd (ans : none = some _) (fun e => nomatch e)
  | h :: tail, q, b, ans =>
    match hc : tail.all (fun g => g q == h q) with
    | true =>
      have same : h q = b :=
        Option.some.inj ((congrArg (onCons h q) hc).symm.trans ans : some (h q) = some b)
      ⟨⟨h, .head _⟩, fun g m => match m with
        | .head _ => same
        | .tail _ m => ((beq_true_iff _ _).mp (ListTests.all_sound _ hc g m)).trans same⟩
    | false => absurd ((congrArg (onCons h q) hc).symm.trans ans : none = some b) (fun e => nomatch e)

/-- **Where the answer procedure abstains, the list's belief settles nothing.** -/
theorem answer_none : ∀ {hs : List (Rule Q)} {q : Q} {b : Bool},
    answer hs q = none → ¬ Settles (· ∈ hs) q b
  | [], _, _, _, ⟨⟨_, m⟩, _⟩ => nomatch m
  | h :: tail, q, _, ans, ⟨_, every⟩ =>
    have all : tail.all (fun g => g q == h q) = true :=
      ListTests.all_complete _ (fun g m => (beq_true_iff _ _).mpr
        ((every g (.tail _ m)).trans (every h (.head _)).symm))
    absurd ((congrArg (onCons h q) all).symm.trans ans : some (h q) = none) (fun e => nomatch e)

/-- **What the list's belief settles, the answer procedure answers.** -/
theorem answer_of_settles : ∀ {hs : List (Rule Q)} {q : Q} {b : Bool},
    Settles (· ∈ hs) q b → answer hs q = some b
  | [], _, _, ⟨⟨_, m⟩, _⟩ => nomatch m
  | h :: tail, q, _, ⟨_, every⟩ =>
    have all : tail.all (fun g => g q == h q) = true :=
      ListTests.all_complete _ (fun g m => (beq_true_iff _ _).mpr
        ((every g (.tail _ m)).trans (every h (.head _)).symm))
    ((congrArg (onCons h q) all).trans (congrArg some (every h (.head _))) :
      onCons h q (tail.all (fun g => g q == h q)) = some _)

/-- **The answer asserts `b` exactly where some candidate remains and every candidate gives
`b`.** -/
theorem answer_iff (hs : List (Rule Q)) (q : Q) (b : Bool) :
    answer hs q = some b ↔ hs ≠ [] ∧ ∀ h, h ∈ hs → h q = b :=
  ⟨fun ans => match answer_some ans with
    | ⟨⟨_, m⟩, every⟩ =>
      ⟨(fun empty => nomatch (Eq.subst (motive := fun l => _ ∈ l) empty m)), every⟩,
   fun ⟨nonempty, every⟩ => answer_of_settles (match hs, nonempty, every with
    | [], no, _ => absurd rfl no
    | h :: _, _, every => ⟨⟨h, .head _⟩, every⟩)⟩

/-- The learned list's belief settles exactly what the narrowed belief settles. -/
theorem settles_learn_iff {hs : List (Rule Q)} {e : List (Observation Q)} {q : Q} {b : Bool} :
    Settles (· ∈ learn hs e) q b ↔ Settles (narrowed (· ∈ hs) e) q b :=
  ⟨fun ⟨⟨h, m⟩, every⟩ => ⟨⟨h, (mem_learn_iff e hs h).mp m⟩,
      fun g n => every g ((mem_learn_iff e hs g).mpr n)⟩,
   fun ⟨⟨h, m⟩, every⟩ => ⟨⟨h, (mem_learn_iff e hs h).mpr m⟩,
      fun g n => every g ((mem_learn_iff e hs g).mp n)⟩⟩

/-- **The answer is safe.** -/
theorem answer_safe (hs : List (Rule Q)) : Safe hs (answer hs) :=
  fun h held q b ans => ((answer_iff hs q b).mp ans).2 h held |>.symm

/-- **A safe definite answer, with some candidate left, is the answer.** -/
theorem safe_definite_requires_agreement (hs : List (Rule Q)) (a : Q → Option Bool)
    (safe : Safe hs a) (nonempty : hs ≠ []) (q : Q) (b : Bool) (asserts : a q = some b) :
    answer hs q = some b :=
  (answer_iff hs q b).mpr ⟨nonempty, fun h held => (safe h held q b asserts).symm⟩

/-- **The answer is the greatest safe answer.** -/
theorem answer_maximal (hs : List (Rule Q)) (nonempty : hs ≠ []) : Maximal hs (answer hs) :=
  fun a safe q b asserts => safe_definite_requires_agreement hs a safe nonempty q b asserts

/-- **A safe greatest answer is the answer at every question.** -/
theorem unique_maximal_safe (hs : List (Rule Q)) (nonempty : hs ≠ []) (a : Q → Option Bool)
    (safe : Safe hs a) (maximal : Maximal hs a) : ∀ q, a q = answer hs q :=
  fun q => match ha : a q, hb : answer hs q with
  | some b, _ => (safe_definite_requires_agreement hs a safe nonempty q b ha).symm.trans hb
  | none, none => rfl
  | none, some b => ha.symm.trans (maximal (answer hs) (answer_safe hs) q b hb)

/-- With function extensionality named, a safe greatest answer is the answer. -/
theorem unique_maximal_safe_of_ext
    (ext : ∀ f g : Q → Option Bool, (∀ q, f q = g q) → f = g) (hs : List (Rule Q))
    (nonempty : hs ≠ []) (a : Q → Option Bool) (safe : Safe hs a) (maximal : Maximal hs a) :
    a = answer hs :=
  ext _ _ (unique_maximal_safe hs nonempty a safe maximal)

/-- **Where the actual rule is a kept candidate, what the answer asserts is its value.** -/
theorem known_rule_makes_answer_correct (actual : Rule Q) (hs : List (Rule Q))
    (e : List (Observation Q)) (included : actual ∈ hs) (faithful : Fits actual e) (q : Q)
    (b : Bool) (asserts : answer (learn hs e) q = some b) : b = actual q :=
  answer_safe _ actual (actual_retained actual hs e included faithful) q b asserts

/-! ## Acquisition and transport -/

/-- Acquisition observes the actual rule at supplied questions, within its support. -/
def acquire (actual : Rule Q) : Nat → List Q → List (Observation Q)
  | 0, _ => []
  | _ + 1, [] => []
  | fuel + 1, q :: qs => (q, actual q) :: acquire actual fuel qs

/-- **Acquired evidence is faithful to the actual rule.** -/
theorem acquired_evidence_faithful (actual : Rule Q) : ∀ (fuel : Nat) (qs : List Q),
    Fits actual (acquire actual fuel qs)
  | 0, _ => fun _ none => nomatch none
  | _ + 1, [] => fun _ none => nomatch none
  | fuel + 1, q :: qs => fun o n =>
    match o, (n : o ∈ (q, actual q) :: acquire actual fuel qs) with
    | _, .head _ => rfl
    | _, .tail _ n => acquired_evidence_faithful actual fuel qs _ n

/-- **From a list containing the actual rule, acquired answers are correct.** -/
theorem acquired_answers_correct (actual : Rule Q) (hs : List (Rule Q)) (included : actual ∈ hs)
    (fuel : Nat) (qs : List Q) (q : Q) (b : Bool)
    (asserts : answer (learn hs (acquire actual fuel qs)) q = some b) : b = actual q :=
  known_rule_makes_answer_correct actual hs _ included (acquired_evidence_faithful actual fuel qs)
    q b asserts

/-- A rule read through a supplied decoding of another question type. -/
def transport {R : Type} (decode : R → Q) (h : Rule Q) : Rule R := fun r => h (decode r)

/-- **Transported rules answer at a token as the rules answer at its decoding.** -/
theorem answer_transport {R : Type} (hs : List (Rule Q)) (decode : R → Q) (r : R) :
    answer (hs.map (transport decode)) r = answer hs (decode r) :=
  match hs with
  | [] => rfl
  | h :: tail =>
    congrArg (fun c => if c = true then some (h (decode r)) else none)
      (all_map (transport decode) (fun g => g r == h (decode r)) tail)

/-- **Learning transported rules from re-encoded observations transports what is learned**, where
decoding inverts encoding. -/
theorem learning_transport {R : Type} (encode' : Q → R) (decode : R → Q)
    (faithful : ∀ q, decode (encode' q) = q) : ∀ (hs : List (Rule Q)) (e : List (Observation Q)),
    learn (hs.map (transport decode)) (e.map (fun o => (encode' o.1, o.2))) =
      (learn hs e).map (transport decode)
  | _, [] => rfl
  | hs, o :: os =>
    have step : revise (hs.map (transport decode)) (encode' o.1, o.2) =
        (revise hs o).map (transport decode) :=
      (filter_map_comm (transport decode) (fun g => g (encode' o.1) == o.2) hs).trans
        (Eq.subst (motive := fun x =>
            (hs.filter (fun h => h (decode (encode' o.1)) == o.2)).map (transport decode) =
              (hs.filter (fun h => h x == o.2)).map (transport decode))
          (faithful o.1) rfl)
    show learn (revise (hs.map (transport decode)) (encode' o.1, o.2))
        (os.map (fun (x : Observation Q) => (encode' x.1, x.2))) =
      (learn (revise hs o) os).map (transport decode) from
    (congrArg (fun l => learn l (os.map (fun (x : Observation Q) => (encode' x.1, x.2)))) step).trans
      (learning_transport encode' decode faithful (revise hs o) os)

/-- **The same reading under the narrowed belief**: narrowing transported rules by re-encoded
observations holds exactly the transports of what the original narrowing keeps. -/
theorem narrowing_transport {R : Type} (hs : List (Rule Q)) (e : List (Observation Q))
    (encode' : Q → R) (decode : R → Q) (faithful : ∀ q, decode (encode' q) = q) (g : Rule R) :
    narrowed (· ∈ hs.map (transport decode)) (e.map (fun o => (encode' o.1, o.2))) g ↔
      g ∈ (learn hs e).map (transport decode) :=
  (mem_learn_iff _ _ g).symm.trans
    (Eq.subst (motive := fun l => g ∈ learn (hs.map (transport decode))
        (e.map (fun o => (encode' o.1, o.2))) ↔ g ∈ l)
      (learning_transport encode' decode faithful hs e) Iff.rfl)

/-- **A wrong re-encoding breaks transfer.** -/
theorem wrong_reencoding_breaks_transfer :
    answer ([(id : Rule Bool)].map (transport (fun b => !b))) true ≠ answer [id] true := by
  decide

/-! ## Four rules on two cases -/

/-- The four rules on two cases. -/
def repertoire : List (Rule Bool) := [id, fun b => !b, fun _ => true, fun _ => false]

/-- **Every rule on two cases agrees everywhere with one of the four.** -/
theorem repertoire_complete (h : Rule Bool) : ∃ g, g ∈ repertoire ∧ ∀ b, g b = h b :=
  match hf : h false, ht : h true with
  | false, false => ⟨fun _ => false, .tail _ (.tail _ (.tail _ (.head _))), fun
      | false => hf.symm
      | true => ht.symm⟩
  | false, true => ⟨id, .head _, fun
      | false => hf.symm
      | true => ht.symm⟩
  | true, false => ⟨fun b => !b, .tail _ (.head _), fun
      | false => hf.symm
      | true => ht.symm⟩
  | true, true => ⟨fun _ => true, .tail _ (.tail _ (.head _)), fun
      | false => hf.symm
      | true => ht.symm⟩

/-- With function extensionality named, every rule on two cases is one of the four. -/
theorem repertoire_complete_of_ext (ext : ∀ f g : Rule Bool, (∀ b, f b = g b) → f = g)
    (h : Rule Bool) : h ∈ repertoire :=
  match repertoire_complete h with
  | ⟨g, m, same⟩ => Eq.subst (motive := fun x => x ∈ repertoire) (ext g h same) m

/-- **From the four rules, what faithful acquisition answers is the actual value.** -/
theorem full_repertoire_correct (actual : Rule Bool) (fuel : Nat) (qs : List Bool) (q b : Bool)
    (asserts : answer (learn repertoire (acquire actual fuel qs)) q = some b) : b = actual q :=
  match repertoire_complete actual with
  | ⟨g, m, same⟩ =>
    have fits : Fits g (acquire actual fuel qs) := fun o n =>
      (same o.1).trans (acquired_evidence_faithful actual fuel qs o n)
    (known_rule_makes_answer_correct g repertoire _ m fits q b asserts).trans (same q)

/-- **What faithful observation of the actual rule settles is its value.** -/
theorem full_repertoire_settles_actual (actual : Rule Bool) (fuel : Nat) (qs : List Bool)
    {q b : Bool}
    (settled : Settles (narrowed (· ∈ repertoire) (acquire actual fuel qs)) q b) : b = actual q :=
  full_repertoire_correct actual fuel qs q b (answer_of_settles (settles_learn_iff.mpr settled))

/-- One observation of the identity at `true`. -/
def oneSample : List (Observation Bool) := acquire id 1 [true, false]

/-- Observations of the identity at `true` and at `false`. -/
def twoSamples : List (Observation Bool) := acquire id 2 [true, false]

theorem before_acquisition_abstains : answer repertoire true = none := by decide

theorem one_sample_leaves_other_case_unsettled :
    answer (learn repertoire oneSample) true = some true ∧
      answer (learn repertoire oneSample) false = none := by decide

theorem contrasting_acquisition_settles_both :
    answer (learn repertoire twoSamples) true = some true ∧
      answer (learn repertoire twoSamples) false = some false := by decide

theorem learned_response_differs_from_last_report :
    twoSamples.getLast? = some (false, false) ∧
      answer (learn repertoire twoSamples) true = some true := by decide

theorem repeated_same_case_does_not_settle_other :
    answer (learn repertoire (acquire id 2 [true, true])) false = none := by decide

theorem insufficient_support_retains_ambiguity :
    answer (learn repertoire (acquire id 1 [true, false])) false = none := by decide

theorem wrong_model_class_can_be_confidently_wrong :
    answer (learn ([fun _ => true] : List (Rule Bool)) (acquire id 1 [true])) false = some true ∧
      (id : Rule Bool) false = false := by decide

theorem inconsistent_evidence_yields_no_answer :
    answer (learn repertoire [(true, true), (true, false)]) false = none := by decide

/-- **One observed case is settled; the other is not.** -/
theorem one_sample_settles_one :
    Settles (narrowed (· ∈ repertoire) oneSample) true true ∧
      ∀ b, ¬ Settles (narrowed (· ∈ repertoire) oneSample) false b :=
  match one_sample_leaves_other_case_unsettled with
  | ⟨settled, unsettled⟩ =>
    ⟨settles_learn_iff.mp (answer_some settled),
     fun _ s => answer_none unsettled (settles_learn_iff.mpr s)⟩

/-- **Contrasting observations settle both cases.** -/
theorem contrasting_settles_both :
    Settles (narrowed (· ∈ repertoire) twoSamples) true true ∧
      Settles (narrowed (· ∈ repertoire) twoSamples) false false :=
  match contrasting_acquisition_settles_both with
  | ⟨first, second⟩ =>
    ⟨settles_learn_iff.mp (answer_some first), settles_learn_iff.mp (answer_some second)⟩

/-- **What is settled is not the last report.** -/
theorem settled_differs_from_last :
    twoSamples.getLast? = some (false, false) ∧
      Settles (narrowed (· ∈ repertoire) twoSamples) true true :=
  match learned_response_differs_from_last_report with
  | ⟨last, settled⟩ => ⟨last, settles_learn_iff.mp (answer_some settled)⟩

/-- **Repeating one case does not settle the other.** -/
theorem repeated_case_leaves_other :
    ∀ b, ¬ Settles (narrowed (· ∈ repertoire) (acquire id 2 [true, true])) false b :=
  fun _ s => answer_none repeated_same_case_does_not_settle_other (settles_learn_iff.mpr s)

/-- **Contradictory observations settle nothing.** -/
theorem contradiction_settles_nothing :
    ∀ b, ¬ Settles (narrowed (· ∈ repertoire) [(true, true), (true, false)]) false b :=
  fun _ s => answer_none inconsistent_evidence_yields_no_answer (settles_learn_iff.mpr s)

/-- **A candidate class lacking the actual rule can settle wrongly.** -/
theorem narrow_class_settles_wrongly :
    Settles (narrowed (· ∈ ([fun _ => true] : List (Rule Bool))) (acquire id 1 [true])) false true ∧
      (id : Rule Bool) false = false :=
  match wrong_model_class_can_be_confidently_wrong with
  | ⟨wrong, actual⟩ => ⟨settles_learn_iff.mp (answer_some wrong), actual⟩

end Narrowing

end Becoming
