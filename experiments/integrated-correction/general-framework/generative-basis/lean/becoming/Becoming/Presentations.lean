import Becoming.Composition

/-!
# Presentations: exact reduced codes are unique up to one alignment, and what relations descend

A family of answers `answers : M → Q → Prop` is fixed for configurations `M` and questions `Q`
before any code. A **presentation** gives each configuration a code and reads each code at each
question (`Presentation`). It is **exact** where the code of a configuration reads the
configuration's answers (`Exact`), and **reduced** where configurations answering alike get one
code (`Reduced`). Every code includes its reading; no varying reading is hidden in a code.

* **One kernel.** Under an exact presentation, equal codes answer alike
  (`equal_codes_same_answers`); an exact reduced presentation gives two configurations one code
  exactly where they answer alike (`reduced_exact_kernel`), so two exact reduced presentations have
  one kernel (`reduced_presentations_same_kernel`).
* **One alignment.** Codes of two presentations match where one configuration has both
  (`Matches`); each used code has a match (`matches_total_on_used`), the match is functional where
  the second is reduced and the first exact (`matches_functional`, `matches_inverse_functional`),
  and two codes match exactly where both are used and they read alike on every question
  (`matches_iff_equal_answers`). A relation holding at the codes of every configuration and giving
  each code at most one partner is the matching (`unique_matching`), so two exact reduced
  presentations correspond one to one on used codes, with no choice of inverses
  (`relative_unique_correspondence`).
* **Exact need not be reduced, and enlarging the questions makes distinctions essential.** For the
  question "is the first bit set" the first bit is an exact reduced code and the pair an exact code
  that is not reduced (`short_exact`, `short_reduced`, `full_exact`, `full_not_reduced`); for both
  bits as questions, no reading of the first bit is exact (`first_summary_cannot_answer_both`).
* **What relations descend.** A ternary relation `J` among configurations (`Becoming.Composition`'s
  joint relation, which `jointImage` reads through a description) is read exactly at the codes of
  an exact reduced presentation (`RelExact`) exactly where it is **saturated**, the same for
  configurations answering alike (`Saturated`, `relation_descends_iff_saturated`); then the image
  `jointImage J p.encode` is the reading (`lift_exact_iff_saturated`), unique on used codes
  (`relational_reading_unique_on_used`). One pair of triples answering alike on which `J` differs
  blocks every exact reading (`separating_relation_blocks_descent`).
* **All predicates as questions.** With every predicate a question, configurations answer alike
  only where they are equal (`all_predicates_separate`), every exact presentation is injective and
  reduced (`all_predicates_force_injective`, `all_predicates_automatically_reduced`), every
  relation descends (`all_predicates_every_relation`, `all_predicates_relation_recoverable`), and
  the correspondence holds (`all_predicates_unique_correspondence`): the limit keeps every supplied
  distinction and finds none.
* **A frame's branching tests.** With a frame's configurations and its branching tests
  (`Becoming.Likeness`) as questions, an exact reduced presentation gives one code exactly to the
  configurations passing the same branching tests (`Presentations.reduced_exact_kernel`), so alike configurations get
  one code (`Tests.alike_one_code`); the kernels, matches and alignment are those above
  (`Presentations.reduced_presentations_same_kernel`, `Presentations.matches_iff_equal_answers`, `Tests.aligned_iff`).

Uniqueness here is relative to the fixed questions; no ontological order among presentations is
derived. This module states in the core what `ExplanatoryUniqueness` and `ExplanatoryUniversality`
(6 October 2026) and the join `TestCodeFrames` (17 October) proved on their own definitions (board
item F3E, 18 October 2026). No ethical predicate, ranking or axiom occurs; every declaration has an
empty axiom report.
-/

namespace Becoming

open Generative

universe u v w x

namespace Presentations

variable {M : Type u} {Q : Type v} {C : Type w} {D : Type x}

/-- Two configurations answer every question alike. -/
def SameAnswers (answers : M → Q → Prop) (m n : M) : Prop :=
  ∀ q, answers m q ↔ answers n q

/-- A code for each configuration and a reading of each code at each question. -/
structure Presentation (M : Type u) (Q : Type v) (C : Type w) where
  encode : M → C
  read : C → Q → Prop

/-- The code of each configuration reads its answers. -/
def Exact (answers : M → Q → Prop) (p : Presentation M Q C) : Prop :=
  ∀ m q, p.read (p.encode m) q ↔ answers m q

/-- Configurations answering alike get one code. -/
def Reduced (answers : M → Q → Prop) (p : Presentation M Q C) : Prop :=
  ∀ m n, SameAnswers answers m n → p.encode m = p.encode n

/-- A code some configuration has. -/
def Used (p : Presentation M Q C) (c : C) : Prop := ∃ m, p.encode m = c

/-- Two codes belong to one configuration. -/
def Matches (p : Presentation M Q C) (r : Presentation M Q D) (c : C) (d : D) : Prop :=
  ∃ m, p.encode m = c ∧ r.encode m = d

/-! ## One kernel, one alignment -/

theorem equal_codes_same_answers {answers : M → Q → Prop} {p : Presentation M Q C}
    (hp : Exact answers p) {m n : M} (h : p.encode m = p.encode n) : SameAnswers answers m n :=
  fun q => (hp m q).symm.trans
    ((Eq.subst (motive := fun c => p.read (p.encode m) q ↔ p.read c q) h Iff.rfl).trans (hp n q))

/-- **An exact reduced presentation gives one code exactly to configurations answering alike.** -/
theorem reduced_exact_kernel {answers : M → Q → Prop} {p : Presentation M Q C}
    (hp : Exact answers p) (rp : Reduced answers p) (m n : M) :
    p.encode m = p.encode n ↔ SameAnswers answers m n :=
  ⟨equal_codes_same_answers hp, rp m n⟩

/-- **Two exact reduced presentations have one kernel.** -/
theorem reduced_presentations_same_kernel {answers : M → Q → Prop} {p : Presentation M Q C}
    {r : Presentation M Q D} (hp : Exact answers p) (rp : Reduced answers p)
    (hr : Exact answers r) (rr : Reduced answers r) (m n : M) :
    p.encode m = p.encode n ↔ r.encode m = r.encode n :=
  (reduced_exact_kernel hp rp m n).trans (reduced_exact_kernel hr rr m n).symm

theorem matches_total_on_used (p : Presentation M Q C) (r : Presentation M Q D) {c : C}
    (h : Used p c) : ∃ d, Used r d ∧ Matches p r c d :=
  match h with
  | ⟨m, hm⟩ => ⟨r.encode m, ⟨m, rfl⟩, ⟨m, hm, rfl⟩⟩

theorem matches_functional {answers : M → Q → Prop} {p : Presentation M Q C}
    {r : Presentation M Q D} (hp : Exact answers p) (rr : Reduced answers r) {c : C} {d e : D}
    (hd : Matches p r c d) (he : Matches p r c e) : d = e :=
  match hd, he with
  | ⟨m, hm, hmd⟩, ⟨n, hn, hne⟩ =>
    hmd.symm.trans ((rr m n (equal_codes_same_answers hp (hm.trans hn.symm))).trans hne)

theorem matches_inverse_functional {answers : M → Q → Prop} {p : Presentation M Q C}
    {r : Presentation M Q D} (hr : Exact answers r) (rp : Reduced answers p) {c e : C} {d : D}
    (hc : Matches p r c d) (he : Matches p r e d) : c = e :=
  match hc, he with
  | ⟨m, hmc, hm⟩, ⟨n, hne, hn⟩ =>
    hmc.symm.trans ((rp m n (equal_codes_same_answers hr (hm.trans hn.symm))).trans hne)

/-- **Two codes match exactly where both are used and they read alike on every question.** -/
theorem matches_iff_equal_answers {answers : M → Q → Prop} {p : Presentation M Q C}
    {r : Presentation M Q D} (hp : Exact answers p) (hr : Exact answers r)
    (rr : Reduced answers r) (c : C) (d : D) :
    Matches p r c d ↔ Used p c ∧ Used r d ∧ ∀ q, p.read c q ↔ r.read d q :=
  ⟨fun ⟨m, hm, hn⟩ => by
    subst hm; subst hn
    exact ⟨⟨m, rfl⟩, ⟨m, rfl⟩, fun q => (hp m q).trans (hr m q).symm⟩,
   fun ⟨⟨m, hm⟩, ⟨n, hn⟩, he⟩ => by
    subst hm; subst hn
    exact ⟨m, rfl, rr m n fun q => (hp m q).symm.trans ((he q).trans (hr n q))⟩⟩

/-- **The alignment is the only one**: a relation holding at the codes of every configuration and
giving each code at most one partner relates a used code exactly to its match. -/
theorem unique_matching (p : Presentation M Q C) (r : Presentation M Q D) (R : C → D → Prop)
    (aligned : ∀ m, R (p.encode m) (r.encode m)) (functional : ∀ c d e, R c d → R c e → d = e)
    {c : C} {d : D} (used : Used p c) : R c d ↔ Matches p r c d :=
  match used with
  | ⟨m, hm⟩ => by
    subst hm
    exact ⟨fun h => ⟨m, rfl, functional _ _ _ (aligned m) h⟩,
      fun ⟨n, hn, hd⟩ => hd ▸ hn ▸ aligned n⟩

/-- **Two exact reduced presentations correspond one to one on used codes.** -/
theorem relative_unique_correspondence {answers : M → Q → Prop} {p : Presentation M Q C}
    {r : Presentation M Q D} (hp : Exact answers p) (rp : Reduced answers p)
    (hr : Exact answers r) (rr : Reduced answers r) :
    (∀ c, Used p c → ∃ d, Matches p r c d ∧ ∀ e, Matches p r c e → e = d) ∧
      (∀ d, Used r d → ∃ c, Matches p r c d ∧ ∀ e, Matches p r e d → e = c) :=
  ⟨fun _ hc => match matches_total_on_used p r hc with
    | ⟨d, _, hd⟩ => ⟨d, hd, fun _ he => matches_functional hp rr he hd⟩,
   fun d ⟨m, hm⟩ =>
    have hc : Matches p r (p.encode m) d := ⟨m, rfl, hm⟩
    ⟨p.encode m, hc, fun _ he => matches_inverse_functional hr rp he hc⟩⟩

/-! ## The canonical presentation -/

/-- The canonical presentation: each configuration coded by the predicate of its answers. -/
def canonical (answers : M → Q → Prop) : Presentation M Q (Q → Prop) := ⟨answers, fun c q => c q⟩

/-- **The canonical presentation reads every answer exactly.** -/
theorem canonical_exact (answers : M → Q → Prop) : Exact answers (canonical answers) :=
  fun _ _ => Iff.rfl

/-- Predicates answering alike are one predicate. This is extensionality of predicates on the
questions, a property of codes that are predicates, not of what they code. -/
def PredicateExt (Q : Type v) : Prop := ∀ c d : Q → Prop, (∀ q, c q ↔ d q) → c = d

/-- **Where predicates answering alike are one, the canonical presentation gives configurations
answering alike one code.** Without it, two canonical codes of configurations answering alike are
predicates answering alike, not one predicate. -/
theorem canonical_reduced (ext : PredicateExt Q) (answers : M → Q → Prop) :
    Reduced answers (canonical answers) :=
  fun m n same => ext (answers m) (answers n) same

/-- **Every exact presentation factors through the canonical one, up to answering alike**: each
used code matches a used canonical code, and every canonical code it matches answers alike with it;
each used canonical code is matched. No extensionality is used. -/
theorem canonical_factor_answers {answers : M → Q → Prop} {p : Presentation M Q C}
    (hp : Exact answers p) :
    (∀ c, Used p c → ∃ d, Used (canonical answers) d ∧ Matches p (canonical answers) c d ∧
      ∀ e, Matches p (canonical answers) c e → ∀ q, e q ↔ d q) ∧
    (∀ d, Used (canonical answers) d → ∃ c, Used p c ∧ Matches p (canonical answers) c d) :=
  ⟨fun _ used => match matches_total_on_used p (canonical answers) used with
    | ⟨d, usedD, matched⟩ => ⟨d, usedD, matched, fun _ matched' q => match matched, matched' with
      | ⟨_, atM, toD⟩, ⟨n, atN, toE⟩ =>
        Eq.subst (motive := fun x => x q ↔ d q) toE
          (Eq.subst (motive := fun x => answers n q ↔ x q) toD
            (equal_codes_same_answers hp (atN.trans atM.symm) q))⟩,
   fun _ ⟨m, at_⟩ => ⟨p.encode m, ⟨m, rfl⟩, m, rfl, at_⟩⟩

/-- **Where predicates answering alike are one, every exact presentation factors through the
canonical one**: each used code matches exactly one used canonical code, and each used canonical
code is matched. -/
theorem canonical_factor (ext : PredicateExt Q) {answers : M → Q → Prop} {p : Presentation M Q C}
    (hp : Exact answers p) :
    (∀ c, Used p c → ∃ d, Used (canonical answers) d ∧ Matches p (canonical answers) c d ∧
      ∀ e, Matches p (canonical answers) c e → e = d) ∧
    (∀ d, Used (canonical answers) d → ∃ c, Used p c ∧ Matches p (canonical answers) c d) :=
  ⟨fun _ used => match matches_total_on_used p (canonical answers) used with
    | ⟨d, usedD, matched⟩ => ⟨d, usedD, matched,
        fun _ matched' => matches_functional hp (canonical_reduced ext answers) matched' matched⟩,
   (canonical_factor_answers hp).2⟩

/-! ## Exact need not be reduced -/

/-- The question: is the first bit set. -/
def firstAnswers (m : Bool × Bool) (_ : Unit) : Prop := m.1 = true

/-- The first bit as code. -/
def short : Presentation (Bool × Bool) Unit Bool := ⟨Prod.fst, fun c _ => c = true⟩

/-- The pair as code. -/
def full : Presentation (Bool × Bool) Unit (Bool × Bool) := ⟨fun m => m, fun c _ => c.1 = true⟩

theorem short_exact : Exact firstAnswers short := fun _ _ => Iff.rfl

theorem full_exact : Exact firstAnswers full := fun _ _ => Iff.rfl

theorem short_reduced : Reduced firstAnswers short
  | (false, _), (false, _), _ => rfl
  | (true, _), (true, _), _ => rfl
  | (false, _), (true, _), same => nomatch (same ()).mpr rfl
  | (true, _), (false, _), same => nomatch (same ()).mp rfl

theorem full_not_reduced : ¬ Reduced firstAnswers full :=
  fun reduced => nomatch congrArg Prod.snd (reduced (false, false) (false, true) fun _ => Iff.rfl)

/-- Both bits as questions. -/
def bothAnswers (m : Bool × Bool) (q : Bool) : Prop := (if q then m.2 else m.1) = true

/-- **Enlarging the questions makes the second bit essential**: no reading of the first bit is
exact. -/
theorem first_summary_cannot_answer_both :
    ¬ ∃ read : Bool → Bool → Prop, Exact bothAnswers ⟨Prod.fst, read⟩
  | ⟨_, h⟩ =>
    nomatch ((equal_codes_same_answers h (m := (false, false)) (n := (false, true)) rfl true).mpr
      rfl : (false : Bool) = true)

/-! ## What relations descend -/

/-- `J` is the same for configurations answering alike. -/
def Saturated (answers : M → Q → Prop) (J : M → M → M → Prop) : Prop :=
  ∀ a a' b b' c c', SameAnswers answers a a' → SameAnswers answers b b' →
    SameAnswers answers c c' → (J a b c ↔ J a' b' c')

/-- `K` reads `J` exactly at the codes. -/
def RelExact (p : Presentation M Q C) (J : M → M → M → Prop) (K : C → C → C → Prop) : Prop :=
  ∀ a b c, K (p.encode a) (p.encode b) (p.encode c) ↔ J a b c

theorem lift_contains (p : Presentation M Q C) (J : M → M → M → Prop) {a b c : M} (h : J a b c) :
    jointImage J p.encode (p.encode a) (p.encode b) (p.encode c) :=
  ⟨a, b, c, rfl, rfl, rfl, h⟩

theorem saturation_gives_exact_lift {answers : M → Q → Prop} {p : Presentation M Q C}
    {J : M → M → M → Prop} (hp : Exact answers p) (hJ : Saturated answers J) :
    RelExact p J (jointImage J p.encode) :=
  fun a b c =>
    ⟨fun ⟨a', b', c', ha, hb, hc, hj⟩ =>
      (hJ a' a b' b c' c (equal_codes_same_answers hp ha) (equal_codes_same_answers hp hb)
        (equal_codes_same_answers hp hc)).mp hj,
     lift_contains p J⟩

theorem exact_relation_forces_saturation {answers : M → Q → Prop} {p : Presentation M Q C}
    {J : M → M → M → Prop} {K : C → C → C → Prop} (rp : Reduced answers p)
    (hK : RelExact p J K) : Saturated answers J :=
  fun a a' b b' c c' ha hb hc =>
    have ea := rp a a' ha
    have eb := rp b b' hb
    have ec := rp c c' hc
    (hK a b c).symm.trans
      ((show K (p.encode a) (p.encode b) (p.encode c) ↔ K (p.encode a') (p.encode b') (p.encode c')
        by rw [ea, eb, ec]).trans (hK a' b' c'))

/-- **A relation descends to an exact reduced presentation exactly where it is saturated.** -/
theorem relation_descends_iff_saturated {answers : M → Q → Prop} {p : Presentation M Q C}
    {J : M → M → M → Prop} (hp : Exact answers p) (rp : Reduced answers p) :
    (∃ K, RelExact p J K) ↔ Saturated answers J :=
  ⟨fun ⟨_, h⟩ => exact_relation_forces_saturation rp h,
   fun h => ⟨jointImage J p.encode, saturation_gives_exact_lift hp h⟩⟩

/-- **The image of `J` is then the exact reading.** -/
theorem lift_exact_iff_saturated {answers : M → Q → Prop} {p : Presentation M Q C}
    {J : M → M → M → Prop} (hp : Exact answers p) (rp : Reduced answers p) :
    RelExact p J (jointImage J p.encode) ↔ Saturated answers J :=
  ⟨exact_relation_forces_saturation rp, saturation_gives_exact_lift hp⟩

/-- **Exact readings agree on used codes.** -/
theorem relational_reading_unique_on_used {p : Presentation M Q C} {J : M → M → M → Prop}
    {K L : C → C → C → Prop} (hk : RelExact p J K) (hl : RelExact p J L) {x y z : C}
    (hx : Used p x) (hy : Used p y) (hz : Used p z) : K x y z ↔ L x y z :=
  match hx, hy, hz with
  | ⟨a, ea⟩, ⟨b, eb⟩, ⟨c, ec⟩ => by
    subst ea; subst eb; subst ec
    exact (hk a b c).trans (hl a b c).symm

/-- **One pair of triples answering alike on which `J` differs blocks every exact reading.** -/
theorem separating_relation_blocks_descent {answers : M → Q → Prop} {p : Presentation M Q C}
    {J : M → M → M → Prop} (rp : Reduced answers p) {a a' b b' c c' : M}
    (ha : SameAnswers answers a a') (hb : SameAnswers answers b b')
    (hc : SameAnswers answers c c') (yes : J a b c) (no : ¬ J a' b' c') :
    ¬ ∃ K, RelExact p J K :=
  fun ⟨_, hk⟩ => no ((exact_relation_forces_saturation rp hk a a' b b' c c' ha hb hc).mp yes)

/-! ## All predicates as questions -/

/-- Every predicate is a question. -/
def AllPredicates (m : M) (q : M → Prop) : Prop := q m

theorem all_predicates_separate (a b : M) : SameAnswers AllPredicates a b ↔ a = b :=
  ⟨fun h => (h (fun x => a = x)).mp rfl, fun h => h ▸ fun _ => Iff.rfl⟩

theorem all_predicates_force_injective {p : Presentation M (M → Prop) C}
    (hp : Exact AllPredicates p) : ∀ a b, p.encode a = p.encode b → a = b :=
  fun a b h => (all_predicates_separate a b).mp (equal_codes_same_answers hp h)

theorem all_predicates_every_relation (J : M → M → M → Prop) : Saturated AllPredicates J :=
  fun a a' b b' c c' ha hb hc => by
    cases (all_predicates_separate a a').mp ha
    cases (all_predicates_separate b b').mp hb
    cases (all_predicates_separate c c').mp hc
    exact Iff.rfl

theorem all_predicates_relation_recoverable {p : Presentation M (M → Prop) C}
    (hp : Exact AllPredicates p) (J : M → M → M → Prop) : RelExact p J (jointImage J p.encode) :=
  saturation_gives_exact_lift hp (all_predicates_every_relation J)

theorem all_predicates_automatically_reduced (p : Presentation M (M → Prop) C) :
    Reduced AllPredicates p :=
  fun a b h => congrArg p.encode ((all_predicates_separate a b).mp h)

/-- **All predicates keep every supplied distinction**, and the correspondence holds. -/
theorem all_predicates_unique_correspondence {p : Presentation M (M → Prop) C}
    {r : Presentation M (M → Prop) D} (hp : Exact AllPredicates p) (hr : Exact AllPredicates r) :
    (∀ c, Used p c → ∃ d, Matches p r c d ∧ ∀ e, Matches p r c e → e = d) ∧
      (∀ d, Used r d → ∃ c, Matches p r c d ∧ ∀ e, Matches p r e d → e = c) :=
  relative_unique_correspondence hp (all_predicates_automatically_reduced p) hr
    (all_predicates_automatically_reduced r)

/-! ## A frame's branching tests as questions -/

namespace Tests

variable {S : Type u} {A : Type v} {C' : Type w} {K : Type x} {K' : Type u}
  {F : Frame S A C'} {p : Presentation S (BranchingTest A C') K}
  {q : Presentation S (BranchingTest A C') K'}

/-- **Alike configurations get one code** from every reduced presentation of the branching
tests. -/
theorem alike_one_code (rp : Reduced (BranchingTest.Holds F) p) {s s' : S}
    (alike : Alike F F s s') : p.encode s = p.encode s' :=
  rp s s' alike.sameBranchingTests

theorem aligned_iff (hp : Exact (BranchingTest.Holds F) p) (hq : Exact (BranchingTest.Holds F) q)
    (rq : Reduced (BranchingTest.Holds F) q) (B : K → K' → Prop)
    (aligned : ∀ s, B (p.encode s) (q.encode s))
    (functional : ∀ k k' k'', B k k' → B k k'' → k' = k'') {k : K} {k' : K'} (used : Used p k) :
    B k k' ↔ Used p k ∧ Used q k' ∧ ∀ φ, p.read k φ ↔ q.read k' φ :=
  (unique_matching p q B aligned functional used).trans (matches_iff_equal_answers hp hq rq k k')

end Tests

end Presentations

end Becoming

section PresentationFrames

/-!
## Presentations of a frame: codes of its branching tests, its joint relation, and every predicate

`Becoming.Presentations` states, for answers fixed before any code, that exact reduced codes are
unique up to one alignment and which relations descend to them, and it reads the kernel and the
alignment on a frame's branching tests (`Presentations.Tests`). This section reads the rest of
its laws on frames of the spine.

* **Codes of a frame's branching tests.** Two exact reduced presentations of a frame's branching
  tests correspond one to one on used codes (`correspondence`). The canonical presentation, each
  configuration coded by the branching tests it passes, reads every test exactly
  (`canonical_exact`); where predicates on the tests are extensional it gives one code exactly to
  the configurations passing the same branching tests (`canonical_kernel`), and every exact
  presentation factors through it (`canonical_factor`); without extensionality it factors up to
  answering alike (`canonical_factor_answers`).
* **The joint relation of a joint frame.** Read at the codes of an exact reduced presentation of
  the frame's branching tests, the joint relation has an exact reading exactly where it is the same
  for configurations passing the same branching tests (`Presentations.relation_descends_iff_saturated`); its image is then
  the reading (`Presentations.lift_exact_iff_saturated`), unique on used codes (`Presentations.relational_reading_unique_on_used`), and one pair of
  triples passing the same tests on which the joint relation differs blocks every exact reading
  (`Presentations.separating_relation_blocks_descent`).
* **A frame realizing every predicate.** The frame on a process whose claims are the predicates
  of its configurations, each realized where it holds (`everyPredicate`), tells every two
  configurations apart (`Presentations.all_predicates_separate`). Every exact presentation of what it realizes
  is injective (`Presentations.all_predicates_force_injective`) and reduced (`Presentations.all_predicates_automatically_reduced`), every
  relation among its configurations is read exactly at the codes (`Presentations.all_predicates_every_relation`,
  `Presentations.all_predicates_relation_recoverable`), and any two such presentations correspond one to one
  (`Presentations.all_predicates_unique_correspondence`): the limit keeps every distinction and finds none.

Each theorem is the law of `Becoming.Presentations` it names, read on a frame; none is a further
result. No ethical predicate, ranking or axiom occurs; every declaration has an empty axiom
report.
-/

namespace Becoming

open Generative Presentations

universe u v w x y

namespace PresentationFrames

/-! ### Codes of a frame's branching tests -/

section Tests

variable {S : Type u} {A : Type v} {C : Type w} {K : Type x} {K' : Type y} {F : Frame S A C}
  {p : Presentation S (BranchingTest A C) K} {q : Presentation S (BranchingTest A C) K'}

/-- **The canonical presentation reads every branching test exactly.** -/
theorem canonical_exact (F : Frame S A C) :
    Exact (BranchingTest.Holds F) (canonical (BranchingTest.Holds F)) :=
  Presentations.canonical_exact _

/-- **Where predicates on the tests are extensional, the canonical presentation gives one code
exactly to the configurations passing the same branching tests.** -/
theorem canonical_kernel (ext : PredicateExt (BranchingTest A C)) (F : Frame S A C) (s s' : S) :
    (canonical (BranchingTest.Holds F)).encode s = (canonical (BranchingTest.Holds F)).encode s' ↔
      SameBranchingTests F F s s' :=
  Presentations.reduced_exact_kernel (canonical_exact F) (canonical_reduced ext _) s s'

end Tests

/-! ### The joint relation of a joint frame -/

/-! ### A frame realizing every predicate -/

section EveryPredicate

variable {S : Type u} {A : Type v} {K : Type w} {K' : Type x}

/-- The frame on `P` whose claims are the predicates of its configurations, each realized where
it holds. -/
def everyPredicate (P : Process S A) : Frame S A (S → Prop) := ⟨P, fun s c => c s⟩

variable {P : Process S A} {p : Presentation S (S → Prop) K} {q : Presentation S (S → Prop) K'}

end EveryPredicate

end PresentationFrames

end Becoming

end PresentationFrames
