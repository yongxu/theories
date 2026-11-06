import Becoming.Counterfactual

/-!
# Sensitivity: the least coupling with any number of conditions

`Becoming.Counterfactual` shows that every coupling a law of exchange reads through holds,
with what the formation depends on, every condition its exchange is sensitive to, in the form
that its not holding it is refuted (`¬ ¬`, `ExchangeLaw.Through.couples_of_sensitive`), and,
with finitely many conditions, listed with equality decided, that a law of what has stood reads
through the coupling of what it is sensitive to (`ExchangeLaw.Nonanticipating.through_sensitive`):
sensitivity is the least coupling, least up to that double negation. It leaves open whether
sensitivity remains the least coupling with infinitely many conditions, or a counterexample.
This module answers within the theory without axiom, with no premise beyond what each law names: sensitivity is the
least coupling, in the same double-negation form, wherever a law reads finitely many
conditions under each history, with any number of conditions; with infinitely many, the condition
cannot be dropped where vanishing is decided (a hypothesis, `decides`, which gives `LPO`), and
without such a decision every counterexample gives a principle of omniscience (`WLPO`), so none is
given constructively.

* **Reading finitely many conditions.** At a step, for a formation and under a history, a law
  reads within a list of conditions where every history agreeing with it on them up to the step
  gives alike (`ExchangeLaw.ReadsWithin`); it reads finitely many conditions where at every step,
  for every formation and under every history, it reads within some list
  (`ExchangeLaw.ReadsFinitely`), the list possibly depending on the history. Such a law reads what
  has stood (`ExchangeLaw.ReadsFinitely.nonanticipating`). With finitely many conditions every
  law of what has stood reads finitely many (`ExchangeLaw.Nonanticipating.readsWithin_of_every`,
  `ExchangeLaw.Nonanticipating.readsFinitely_of_every`); with infinitely many, a law can read
  finitely many under each history and within no one list under all of them
  (`Pointer.readsFinitely`, `Pointer.no_list`).
* **Sensitivity is the least coupling, with any number of conditions.** A law of what has
  stood gives alike under two histories agreeing on what it is sensitive to, wherever it reads
  within a list under one of them (`alike_of_sensitive_agree_within`): the listed conditions are
  changed one at a time, as in `Becoming.Counterfactual`. So a law reading finitely many
  conditions reads through every coupling by level that holds what it is sensitive to
  (`ExchangeLaw.ReadsFinitely.through_of_observed`), through what it is sensitive to
  (`ExchangeLaw.ReadsFinitely.through_sensitive`), and sensitivity is the least coupling it
  reads through (`ExchangeLaw.ReadsFinitely.least_coupling`, with
  `ExchangeLaw.Through.couples_of_sensitive`): least in that every coupling it reads through
  holds each condition it is sensitive to up to double negation (`¬ ¬ W.CoupledInto obs h c`), not
  as a positive inclusion. The comparison as the dynamics give holds for
  such laws with any number of conditions, the coupling being their sensitivity
  (`comparison_through_sensitivity_of_readsFinitely`). The case of finitely many conditions in
  `Becoming.Counterfactual` is the instance with one list holding every condition
  (`ExchangeLaw.Nonanticipating.readsFinitely_of_every`).
* **What depends on the whole depends on some part.** At a step at which a law is insensitive to
  every condition, it gives alike under two histories wherever it reads within a list under one
  of them (`alike_of_insensitiveAt_within`); a law reading finitely many conditions and sensitive
  to none gives alike under every two histories (`ExchangeLaw.ReadsFinitely.alike_of_insensitive`).
* **The tail.** With infinitely many conditions the condition cannot be dropped given a decision
  of vanishing, which gives LPO (`lpo_of_vanish_decided`); any law that drops it gives WLPO
  (`wlpo_of_not_through_sensitive`). Given a decision,
  for every sequence of levels, of whether it vanishes from some condition on (`VanishFrom`), the
  law exchanging the indicator of that at step `0` (`vanishIndicator`, `tailLaw`) reads what has
  stood (`tailLaw_nonanticipating`) and through the coupling of the conditions from any one on
  (`tailLaw_reads_from`, `tailLaw_through_from`), is insensitive at every step to every condition
  (`tailLaw_insensitive`) and so sensitive to none (`tailLaw_not_sensitive`), and still differs
  between two histories (`tailLaw_differs`). It does not read through what it is sensitive to
  (`tailLaw_not_through_sensitive`; for a web in which it depends on nothing,
  `tailLaw_not_through`), nor finitely many conditions (`tailLaw_not_readsFinitely`), and the
  couplings it reads through have no least one (`tailLaw_no_least_coupling`).
* **Every counterexample gives omniscience.** Where, for a law of what has stood whose conditions
  are numbered by the natural numbers, two histories agree up to a step on every condition it is
  sensitive to and still give differently there, the weak limited principle of omniscience holds
  (`wlpo_of_not_through_sensitive`, `WLPO`): every Boolean sequence is `false` throughout or not.
  So does every law that at some step is insensitive to every condition and still differs there,
  reading what has stood or not (`wlpo_of_insensitive_differs`). The proofs mix the two histories
  along the sequence, condition by condition, the second taking over from its first `true`
  (`seenBy`, `alike_of_agree_from_sensitive`, `alike_of_agree_from`), and compare two numbers
  (`mixed_decides`). The limited principle of `Becoming.Change` gives `WLPO` (`WLPO.of_lpo`); no
  constructive proof does. So, with the conditions numbered, no counterexample to the least
  coupling can be given without a principle of omniscience, and with the decision of
  vanishing one is given; that decision gives the limited principle itself
  (`lpo_of_vanish_decided`, through `seenBy_exists`).

**Readings (the AI's, adopted on Ren's delegation of 15 October 2026, DELEGATED-CHOICES D37; 识
itself stays Ren's reading).**
- What a formation's exchange is sensitive to is what couples into it, with any number of
  conditions, wherever the law reads finitely many conditions under each history: read as 识,
  what couples into a formation is exactly what its own exchange can be changed by, one condition
  at a time, and no list needs supplying.
- What depends on the whole depends on some part. A law that no single condition can change,
  and that reads finitely many conditions, cannot be changed at all. A whole that depends on no
  part of it is a tail, like whether levels vanish eventually or a long-run average: it differs
  between histories that differ in infinitely many conditions and in no one of them, and giving
  one takes a decision about the infinite that no construction makes.
- The tail is the counterpart, without probability, of the tail events of Kolmogorov's zero–one
  law. That every law the core can exhibit reads finitely many conditions would be Brouwer's
  continuity principle, which refutes `WLPO`; the core neither states nor refutes it.

What is not derived: that every law of what has stood reads finitely many conditions (a
continuity principle, independent of the core); where exactly between `WLPO` and the decision of
vanishing, which gives `LPO`, the existence of a law of the whole and no part lies; a measure of
how much a formation's exchange depends on a condition, or of how much difference arrives
(sensitivity here is yes or no); sensitivity read in time, step by step; what a counterexample
gives where the conditions are not numbered by the natural numbers. The equality of conditions
is decided where conditions are mixed (`DecidableEq`), as in `Becoming.Counterfactual`, and the
tail law takes its decision of vanishing as a hypothesis. No ethical predicate, ranking or axiom
occurs.

**Classical sources.** `LPO` is the limited principle of omniscience of Bishop (1967,
*Foundations of Constructive Analysis*) and `WLPO` its weak form (Bridges and Richman 1987,
*Varieties of Constructive Mathematics*); calibrating a statement by the principle it gives is
constructive reverse mathematics in Ishihara's sense, and that a discontinuous function gives
`WLPO` is Ishihara's: a counterexample to the least coupling is such a discontinuity, a law
changed by no condition that still differs. The mixing of two histories along a Boolean sequence
is the standard way such a statement yields `WLPO`. The calibration here is of the core's own
statements; the principles are defined, never assumed.
-/

namespace Becoming

variable {F C : Type}

/-! ## Reading finitely many conditions -/

namespace ExchangeLaw

variable (law : ExchangeLaw F C)

/-- At `t`, for `h`, under `l`, the law reads within the conditions of `cs`: every history
agreeing with `l` on them up to `t` gives alike with `l`. -/
def ReadsWithin (t : Nat) (h : F) (l : Nat → C → Nat) (cs : List C) : Prop :=
  ∀ l', (∀ s, s ≤ t → ∀ c, c ∈ cs → l s c = l' s c) → law.GivesAlike t h l l'

/-- The law reads finitely many conditions: at every step, for every formation and under every
history, it reads within some list of conditions, the list possibly depending on the history. -/
def ReadsFinitely : Prop :=
  ∀ t h l, ∃ cs : List C, law.ReadsWithin t h l cs

end ExchangeLaw

section Finitely

variable {law : ExchangeLaw F C}

/-- **A law reading finitely many conditions reads what has stood.** -/
theorem ExchangeLaw.ReadsFinitely.nonanticipating (fin : law.ReadsFinitely) :
    law.Nonanticipating :=
  fun t h l l' agree =>
    match fin t h l with
    | ⟨_, within⟩ => within l' fun s le c _ => agree s le c

/-- With a list holding every condition, a law of what has stood reads within it. -/
theorem ExchangeLaw.Nonanticipating.readsWithin_of_every (na : law.Nonanticipating)
    {cs : List C} (every : ∀ c, c ∈ cs) (t : Nat) (h : F) (l : Nat → C → Nat) :
    law.ReadsWithin t h l cs :=
  fun l' agree => na t h l l' fun s le c => agree s le c (every c)

/-- **With finitely many conditions, every law of what has stood reads finitely many.** -/
theorem ExchangeLaw.Nonanticipating.readsFinitely_of_every (na : law.Nonanticipating)
    {cs : List C} (every : ∀ c, c ∈ cs) : law.ReadsFinitely :=
  fun t h l => ⟨cs, na.readsWithin_of_every every t h l⟩

end Finitely

/-! ## Sensitivity is the least coupling, with any number of conditions -/

section Least

variable {law : ExchangeLaw F C} [DecidableEq C]

/-- **A law of what has stood reads through what it is sensitive to, wherever it reads within a
list.** Two histories agreeing up to `t` on every condition the law is sensitive to give alike at
`t`, where under one of them the law reads within some list: the listed conditions are changed
one at a time. Any number of conditions. -/
theorem alike_of_sensitive_agree_within (na : law.Nonanticipating) {t : Nat} {h : F}
    {l l' : Nat → C → Nat} {cs : List C} (within : law.ReadsWithin t h l' cs)
    (agree : ∀ c, law.Sensitive h c → ∀ s, s ≤ t → l s c = l' s c) : law.GivesAlike t h l l' :=
  fun d =>
    have chain := mixIn_alike na agree cs d
    have last := within (mixIn l l' cs) (fun s _ _ mem => (mixIn_listed l l' mem s).symm) d
    ⟨chain.1.trans last.1.symm, chain.2.trans last.2.symm⟩

/-- **A law reading finitely many conditions reads through every coupling by level that holds
what it is sensitive to**, with any number of conditions. -/
theorem ExchangeLaw.ReadsFinitely.through_of_observed (fin : law.ReadsFinitely) {W : Web F C}
    {obs : F → C → Prop} {part : F → Bool}
    (observed : ∀ h, part h = false → ∀ c, law.Sensitive h c → ¬ ¬ obs h c) :
    law.Through W obs part :=
  fun h out t _ l' alike =>
    match fin t h l' with
    | ⟨_, within⟩ =>
      alike_of_sensitive_agree_within fin.nonanticipating within fun c sensitive s le =>
        nat_eq_of_not_not fun differ =>
          observed h out c sensitive fun seen => differ ((alike s le).2 c seen)

/-- **A law reading finitely many conditions reads through what it is sensitive to**, with any
number of conditions. -/
theorem ExchangeLaw.ReadsFinitely.through_sensitive (fin : law.ReadsFinitely) (W : Web F C)
    (part : F → Bool) : law.Through W law.Sensitive part :=
  fin.through_of_observed fun _ _ _ sensitive unseen => unseen sensitive

/-- **Sensitivity is the least coupling, with any number of conditions.** A law reading
finitely many conditions reads through what it is sensitive to, and every coupling it reads
through holds, with what the formation depends on, every condition it is sensitive to, up to
double negation: that it does not hold one is refuted (`¬ ¬`). -/
theorem ExchangeLaw.ReadsFinitely.least_coupling (fin : law.ReadsFinitely) (W : Web F C)
    (part : F → Bool) :
    law.Through W law.Sensitive part ∧
      ∀ obs : F → C → Prop, law.Through W obs part →
        ∀ h, part h = false → ∀ c, law.Sensitive h c → ¬ ¬ W.CoupledInto obs h c :=
  ⟨fin.through_sensitive W part,
   fun _ through _ out _ sensitive => through.couples_of_sensitive out sensitive⟩

/-- **The comparison as the dynamics give, with any number of conditions.** As
`comparison_through_sensitivity`, for a law reading finitely many conditions in place of finitely
many conditions. -/
theorem comparison_through_sensitivity_of_readsFinitely {L L' : Flow F C} {W W' : Web F C}
    {part : F → Bool} {Pos : Type} (fin : law.ReadsFinitely)
    (balances : L.Balances W) (balances' : L'.Balances W')
    (present : ∀ t, L.present t = L'.present t) (start : ∀ c, W.level 0 c = W'.level 0 c)
    (follows : L.Follows law part W.level) (follows' : L'.Follows law part W'.level)
    {sig : Pos → Nat → F → Prop} {p : Pos}
    (covers : ∀ t g, ¬ ¬ L.WithinResponse L' W law.Sensitive part g → sig p t g) :
    (W.Retains sig p W.level W'.level ↔ W.Includes W.level W'.level) ∧
      (W.Retains sig p W'.level W.level ↔ W.Includes W'.level W.level) ∧
      (¬ W.Adds sig p W.level W'.level ↔ ¬ W.Exceeds W.level W'.level) ∧
      (¬ W.Adds sig p W'.level W.level ↔ ¬ W.Exceeds W'.level W.level) :=
  comparison_of_courses (fin.through_sensitive W part) balances balances' present start
    follows follows' covers

/-- Changing listed conditions, to each of which the law is insensitive at `t`, changes nothing it
gives at `t`. -/
theorem mixIn_alike_of_insensitiveAt {t : Nat} {h : F}
    (insensitive : ∀ c, law.InsensitiveAt t h c) (l l' : Nat → C → Nat) :
    ∀ ds, law.GivesAlike t h l (mixIn l l' ds)
  | [] => fun _ => ⟨rfl, rfl⟩
  | c :: ds => fun d =>
    have before := mixIn_alike_of_insensitiveAt insensitive l l' ds d
    have across := insensitive c (mixIn l l' ds) (mixIn (mixIn l l' ds) l' [c])
      (fun _ _ _ differ => (if_neg differ).symm) d
    ⟨before.1.trans across.1, before.2.trans across.2⟩

/-- **What depends on the whole depends on some part.** At a step at which the law is insensitive
to every condition, it gives alike under two histories wherever it reads within a list under one
of them. Any number of conditions; nothing is decided of sensitivity. -/
theorem alike_of_insensitiveAt_within {t : Nat} {h : F} {l l' : Nat → C → Nat} {cs : List C}
    (insensitive : ∀ c, law.InsensitiveAt t h c) (within : law.ReadsWithin t h l' cs) :
    law.GivesAlike t h l l' :=
  fun d =>
    have chain := mixIn_alike_of_insensitiveAt insensitive l l' cs d
    have last := within (mixIn l l' cs) (fun s _ _ mem => (mixIn_listed l l' mem s).symm) d
    ⟨chain.1.trans last.1.symm, chain.2.trans last.2.symm⟩

/-- **A law reading finitely many conditions and sensitive to none gives alike under every two
histories.** -/
theorem ExchangeLaw.ReadsFinitely.alike_of_insensitive (fin : law.ReadsFinitely) {h : F}
    (nothing : ∀ c, ¬ law.Sensitive h c) (t : Nat) (l l' : Nat → C → Nat) :
    law.GivesAlike t h l l' :=
  match fin t h l' with
  | ⟨_, within⟩ =>
    alike_of_sensitive_agree_within fin.nonanticipating within fun c sensitive =>
      absurd sensitive (nothing c)

end Least

/-! ## The tail -/

/-- The levels `α` vanish from some condition on. -/
def VanishFrom (α : Nat → Nat) : Prop :=
  ∃ n, ∀ m, n ≤ m → α m = 0

/-- Levels agreeing from some condition on vanish from some condition on together. -/
theorem VanishFrom.of_agree {α β : Nat → Nat} (n : Nat) (agree : ∀ m, n ≤ m → α m = β m) :
    VanishFrom α → VanishFrom β
  | ⟨k, zero⟩ => ⟨n + k, fun m le =>
      (agree m (Nat.le_trans (Nat.le_add_right n k) le)).symm.trans
        (zero m (Nat.le_trans (Nat.le_add_left k n) le))⟩

/-- The indicator of vanishing, given a decision of it: `1` where the levels vanish from some
condition on, else `0`. -/
def vanishIndicator (decides : ∀ α : Nat → Nat, Decidable (VanishFrom α)) (α : Nat → Nat) : Nat :=
  @ite Nat (VanishFrom α) (decides α) 1 0

section Tail

variable (decides : ∀ α : Nat → Nat, Decidable (VanishFrom α))

theorem vanishIndicator_eq_one {α : Nat → Nat} (vanishes : VanishFrom α) :
    vanishIndicator decides α = 1 :=
  @if_pos (VanishFrom α) (decides α) vanishes Nat 1 0

theorem vanishIndicator_eq_zero {α : Nat → Nat} (stays : ¬ VanishFrom α) :
    vanishIndicator decides α = 0 :=
  @if_neg (VanishFrom α) (decides α) stays Nat 1 0

/-- **The indicator of vanishing changes with no condition.** Levels agreeing from some condition
on have one indicator. -/
theorem vanishIndicator_eq_of_agree {α β : Nat → Nat} (n : Nat) (agree : ∀ m, n ≤ m → α m = β m) :
    vanishIndicator decides α = vanishIndicator decides β :=
  match decides α with
  | isTrue vanishes =>
    (vanishIndicator_eq_one decides vanishes).trans
      (vanishIndicator_eq_one decides (VanishFrom.of_agree n agree vanishes)).symm
  | isFalse stays =>
    (vanishIndicator_eq_zero decides stays).trans
      (vanishIndicator_eq_zero decides fun vanishes =>
        stays (VanishFrom.of_agree n (fun m le => (agree m le).symm) vanishes)).symm

/-- Levels all `0` vanish. -/
theorem vanishIndicator_zeros : vanishIndicator decides (fun _ => 0) = 1 :=
  vanishIndicator_eq_one decides ⟨0, fun _ _ => rfl⟩

/-- Levels all `1` do not. -/
theorem vanishIndicator_ones : vanishIndicator decides (fun _ => 1) = 0 :=
  vanishIndicator_eq_zero decides fun ⟨n, zero⟩ => Nat.noConfusion (zero n (Nat.le_refl n))

/-- **The tail law**: one formation exchanges with every condition, across every step, the indicator
of vanishing of the levels at step `0`, and gives nothing. -/
def tailLaw : ExchangeLaw Unit Nat :=
  ⟨fun _ _ l _ => vanishIndicator decides (l 0), fun _ _ _ _ => 0⟩

/-- The tail law reads what has stood. -/
theorem tailLaw_nonanticipating : (tailLaw decides).Nonanticipating :=
  fun t _ _ _ agree _ =>
    ⟨vanishIndicator_eq_of_agree decides 0 fun m _ => agree 0 (Nat.zero_le t) m, rfl⟩

/-- **The tail law reads through the conditions from any one on.** Two histories agreeing up to
`t` on the conditions from `n` on give alike at `t`, whatever `n`. -/
theorem tailLaw_reads_from (n : Nat) {t : Nat} {l l' : Nat → Nat → Nat}
    (agree : ∀ s, s ≤ t → ∀ m, n ≤ m → l s m = l' s m) : (tailLaw decides).GivesAlike t () l l' :=
  fun _ => ⟨vanishIndicator_eq_of_agree decides n fun m le => agree 0 (Nat.zero_le t) m le, rfl⟩

/-- **The tail law is insensitive to every condition at every step.** -/
theorem tailLaw_insensitive (t c : Nat) : (tailLaw decides).InsensitiveAt t () c :=
  fun _ _ off =>
    tailLaw_reads_from decides (c + 1) fun s le m above => off s le m (Nat.ne_of_gt above)

/-- So it is sensitive to no condition. -/
theorem tailLaw_not_sensitive (c : Nat) : ¬ (tailLaw decides).Sensitive () c :=
  fun ⟨t, notInsensitive⟩ => notInsensitive (tailLaw_insensitive decides t c)

/-- **Yet it differs between two histories**: all levels `0` and all levels `1`. -/
theorem tailLaw_differs (t c : Nat) :
    (tailLaw decides).take t () (fun _ _ => 0) c ≠ (tailLaw decides).take t () (fun _ _ => 1) c :=
  fun same => Nat.noConfusion
    ((vanishIndicator_zeros decides).symm.trans (same.trans (vanishIndicator_ones decides)))

/-- **The tail law does not read through what it is sensitive to.** -/
theorem tailLaw_not_through_sensitive :
    ¬ ∀ t l l', (∀ c, (tailLaw decides).Sensitive () c → ∀ s, s ≤ t → l s c = l' s c) →
      (tailLaw decides).GivesAlike t () l l' :=
  fun reads => tailLaw_differs decides 0 0
    (reads 0 (fun _ _ => 0) (fun _ _ => 1)
      (fun c sensitive => absurd sensitive (tailLaw_not_sensitive decides c)) 0).1

/-- For a web in which the formation depends on nothing, the tail law does not read through what
it is sensitive to: on such a web, reading through it is reading the histories alike where they
agree on what it is sensitive to (`tailLaw_not_through_sensitive`). -/
theorem tailLaw_not_through {W : Web Unit Nat} (free : ∀ t c, ¬ W.requires t () c) :
    ¬ (tailLaw decides).Through W (tailLaw decides).Sensitive (fun _ => false) :=
  fun through => tailLaw_not_through_sensitive decides fun t l l' agree =>
    through () rfl t l l' fun s le =>
      ⟨⟨fun _ c requires => absurd requires (free s c),
        fun _ c requires => absurd requires (free s c)⟩,
       fun c sensitive => agree c sensitive s le⟩

/-- **The tail law reads through the coupling of the conditions from any one on.** -/
theorem tailLaw_through_from {W : Web Unit Nat} (n : Nat) :
    (tailLaw decides).Through W (fun _ c => n ≤ c) (fun _ => false) :=
  fun _ _ _ _ _ alike => tailLaw_reads_from decides n fun s le m above => (alike s le).2 m above

/-- **The couplings the tail law reads through have no least one.** For a web in which the
formation depends on nothing, no coupling the tail law reads through lies within every
coupling it reads through: it would hold no condition, the conditions from each one on being
read through, and the tail law does not read through the coupling of nothing. -/
theorem tailLaw_no_least_coupling {W : Web Unit Nat} (free : ∀ t c, ¬ W.requires t () c) :
    ¬ ∃ obs : Unit → Nat → Prop, (tailLaw decides).Through W obs (fun _ => false) ∧
      ∀ obs' : Unit → Nat → Prop, (tailLaw decides).Through W obs' (fun _ => false) →
        ∀ c, obs () c → obs' () c :=
  fun ⟨_, through, least⟩ =>
    tailLaw_differs decides 0 0
      (through () rfl 0 (fun _ _ => 0) (fun _ _ => 1) (fun s _ =>
        ⟨⟨fun _ c requires => absurd requires (free s c),
          fun _ c requires => absurd requires (free s c)⟩,
         fun c seen => absurd (least _ (tailLaw_through_from decides (c + 1)) c seen)
           (Nat.not_succ_le_self c)⟩) 0).1

/-- **The tail law does not read finitely many conditions.** -/
theorem tailLaw_not_readsFinitely : ¬ (tailLaw decides).ReadsFinitely :=
  fun fin => tailLaw_differs decides 0 0
    ((fin.alike_of_insensitive (tailLaw_not_sensitive decides) 0 (fun _ _ => 0)
      (fun _ _ => 1)) 0).1

end Tail

/-! ## A law of the whole and no part gives omniscience -/

/-- The weak limited principle of omniscience: every Boolean sequence is `false` throughout or
not. The limited principle (`LPO`) gives it; it has no constructive proof. -/
def WLPO : Prop :=
  ∀ s : Nat → Bool, (∀ n, s n = false) ∨ ¬ ∀ n, s n = false

/-- The limited principle of omniscience gives the weak one. -/
theorem WLPO.of_lpo (lpo : LPO) : WLPO :=
  fun s =>
    match lpo s with
    | .inl ⟨n, yes⟩ => .inr fun all => Bool.noConfusion ((all n).symm.trans yes)
    | .inr all => .inl all

/-- Whether `s` has a `true` at some position up to `m`. -/
def seenBy (s : Nat → Bool) : Nat → Bool
  | 0 => s 0
  | m + 1 => seenBy s m || s (m + 1)

/-- A sequence `false` throughout has no `true` up to any position. -/
theorem seenBy_false {s : Nat → Bool} (all : ∀ n, s n = false) : ∀ m, seenBy s m = false
  | 0 => all 0
  | m + 1 =>
    ((congrArg (fun b => b || s (m + 1)) (seenBy_false all m)).trans (all (m + 1)) : _)

theorem seenBy_at {s : Nat → Bool} : ∀ {k : Nat}, s k = true → seenBy s k = true
  | 0, yes => yes
  | k + 1, yes =>
    ((congrArg (fun b => seenBy s k || b) yes).trans (ChanceFloors.or_true (seenBy s k)) : _)

theorem seenBy_from {s : Nat → Bool} {k : Nat} (yes : s k = true) :
    ∀ d, seenBy s (k + d) = true
  | 0 => seenBy_at yes
  | d + 1 => (congrArg (fun b => b || s (k + d + 1)) (seenBy_from yes d) : _)

/-- A `true` at `k` is seen at every position from `k` on. -/
theorem seenBy_true {s : Nat → Bool} {k m : Nat} (yes : s k = true) (le : k ≤ m) :
    seenBy s m = true :=
  match Nat.le.dest le with
  | ⟨d, eq⟩ => eq ▸ seenBy_from yes d

/-- **At a step at which a law is insensitive to every condition, histories agreeing from some
condition on give alike**, the conditions below being changed one at a time. -/
theorem alike_of_agree_from {law : ExchangeLaw F Nat} {t : Nat} {h : F}
    (insensitive : ∀ c, law.InsensitiveAt t h c) :
    ∀ (k : Nat) {X Y : Nat → Nat → Nat}, (∀ r, r ≤ t → ∀ e, k ≤ e → X r e = Y r e) →
      law.GivesAlike t h X Y
  | 0, X, Y, agree => insensitive 0 X Y fun r le e _ => agree r le e (Nat.zero_le e)
  | k + 1, X, Y, agree =>
    have next : ∀ r, r ≤ t → ∀ e, k ≤ e → (if e = k then Y r e else X r e) = Y r e :=
      fun r le e above =>
        match Nat.decEq e k with
        | isTrue same => if_pos same
        | isFalse differ =>
          (if_neg differ).trans
            (agree r le e (Nat.lt_of_le_of_ne above fun same => differ same.symm))
    fun d =>
      have one := insensitive k X (fun r e => if e = k then Y r e else X r e)
        (fun _ _ _ differ => (if_neg differ).symm) d
      have rest :=
        alike_of_agree_from insensitive k (X := fun r e => if e = k then Y r e else X r e) next d
      ⟨one.1.trans rest.1, one.2.trans rest.2⟩

/-- **A mixed history decides the sequence.** Where a history gives alike with the first of two
histories when a Boolean sequence is `false` throughout, and with the second when it has a `true`,
and the two histories give differently with a condition, the sequence is `false` throughout or
not: whether the history gives alike with the first is a comparison of numbers. -/
theorem mixed_decides {law : ExchangeLaw F C} {t : Nat} {h : F} {l l' γ : Nat → C → Nat} {c : C}
    (differs : ¬ (law.take t h l c = law.take t h l' c ∧ law.give t h l c = law.give t h l' c))
    {s : Nat → Bool} (toFirst : (∀ n, s n = false) → law.GivesAlike t h γ l)
    (toSecond : ∀ n, s n = true → law.GivesAlike t h γ l') :
    (∀ n, s n = false) ∨ ¬ ∀ n, s n = false :=
  match Nat.decEq (law.take t h γ c) (law.take t h l c),
    Nat.decEq (law.give t h γ c) (law.give t h l c) with
  | isTrue sameTake, isTrue sameGive => .inl fun n =>
    match hs : s n with
    | false => rfl
    | true =>
      absurd ⟨sameTake.symm.trans (toSecond n hs c).1, sameGive.symm.trans (toSecond n hs c).2⟩
        differs
  | isFalse differTake, _ => .inr fun all => differTake (toFirst all c).1
  | isTrue _, isFalse differGive => .inr fun all => differGive (toFirst all c).2

/-- **A law of the whole and no part gives the weak limited principle of omniscience.** Where a
law whose conditions are numbered by the natural numbers is, at a step, insensitive to every
condition and still differs there between two histories, every Boolean sequence is `false`
throughout or not: the two histories are mixed along the sequence, the second taking over from
its first `true`. The law need not read what has stood. -/
theorem wlpo_of_insensitive_differs {law : ExchangeLaw F Nat} {t : Nat} {h : F}
    (insensitive : ∀ c, law.InsensitiveAt t h c) {l l' : Nat → Nat → Nat} {c : Nat}
    (differs : ¬ (law.take t h l c = law.take t h l' c ∧ law.give t h l c = law.give t h l' c)) :
    WLPO :=
  fun s => mixed_decides (γ := fun r m => bif seenBy s m then l' r m else l r m) differs
    (fun all => alike_of_agree_from insensitive 0 fun r _ e _ =>
      (congrArg (fun b => bif b then l' r e else l r e) (seenBy_false all e) : _))
    (fun n yes => alike_of_agree_from insensitive n fun r _ e above =>
      (congrArg (fun b => bif b then l' r e else l r e) (seenBy_true yes above) : _))

namespace Sensitivity

theorem cond_either (b : Bool) (x y : Nat) :
    (bif b then y else x) = x ∨ (bif b then y else x) = y :=
  match b with
  | true => .inr rfl
  | false => .inl rfl

end Sensitivity

/-- **Histories agreeing on what a law of what has stood is sensitive to give alike from a mix.**
A history whose levels are, condition by condition, those of one of two histories agreeing on
what the law is sensitive to, and those of the second from condition `k` on, gives alike with
the second, the conditions below `k` being changed one at a time. -/
theorem alike_of_agree_from_sensitive {law : ExchangeLaw F Nat} (na : law.Nonanticipating)
    {t : Nat} {h : F} {l l' : Nat → Nat → Nat}
    (agree : ∀ c, law.Sensitive h c → ∀ s, s ≤ t → l s c = l' s c) :
    ∀ (k : Nat) {X : Nat → Nat → Nat}, (∀ r, r ≤ t → ∀ e, X r e = l r e ∨ X r e = l' r e) →
      (∀ r, r ≤ t → ∀ e, k ≤ e → X r e = l' r e) → law.GivesAlike t h X l'
  | 0, X, _, from0 => na t h X l' fun r le e => from0 r le e (Nat.zero_le e)
  | k + 1, X, either, fromNext =>
    have swap := swap_alike na (c := k) (fun s le => either s le k) (agree k)
    have either' : ∀ r, r ≤ t → ∀ e,
        mixIn X l' [k] r e = l r e ∨ mixIn X l' [k] r e = l' r e :=
      fun r le e =>
        match Nat.decEq e k with
        | isTrue same => .inr (if_pos same)
        | isFalse differ =>
          match either r le e with
          | .inl first => .inl ((if_neg differ).trans first)
          | .inr second => .inr ((if_neg differ).trans second)
    have fromK : ∀ r, r ≤ t → ∀ e, k ≤ e → mixIn X l' [k] r e = l' r e :=
      fun r le e above =>
        match Nat.decEq e k with
        | isTrue same => if_pos same
        | isFalse differ =>
          (if_neg differ).trans
            (fromNext r le e (Nat.lt_of_le_of_ne above fun same => differ same.symm))
    have rest := alike_of_agree_from_sensitive na agree k either' fromK
    fun d => ⟨(swap d).1.trans (rest d).1, (swap d).2.trans (rest d).2⟩

/-- **Every counterexample to the least coupling gives the weak limited principle of
omniscience.** Where, for a law of what has stood whose conditions are numbered by the natural
numbers, two histories agree up to `t` on every condition it is sensitive to and still give
differently there, every Boolean sequence is `false` throughout or not. -/
theorem wlpo_of_not_through_sensitive {law : ExchangeLaw F Nat} (na : law.Nonanticipating)
    {t : Nat} {h : F} {l l' : Nat → Nat → Nat}
    (agree : ∀ c, law.Sensitive h c → ∀ s, s ≤ t → l s c = l' s c) {c : Nat}
    (differs : ¬ (law.take t h l c = law.take t h l' c ∧ law.give t h l c = law.give t h l' c)) :
    WLPO :=
  fun s => mixed_decides (γ := fun r m => bif seenBy s m then l' r m else l r m) differs
    (fun all => na t h _ l fun r _ e =>
      (congrArg (fun b => bif b then l' r e else l r e) (seenBy_false all e) : _))
    (fun n yes => alike_of_agree_from_sensitive na agree n
      (fun r _ e => Sensitivity.cond_either (seenBy s e) (l r e) (l' r e))
      fun r _ e above =>
        (congrArg (fun b => bif b then l' r e else l r e) (seenBy_true yes above) : _))

/-- A `true` seen up to some position is at some position. -/
theorem seenBy_exists {s : Nat → Bool} : ∀ {m : Nat}, seenBy s m = true → ∃ k, s k = true
  | 0, yes => ⟨0, yes⟩
  | m + 1, yes =>
    match seen : seenBy s m with
    | true => seenBy_exists seen
    | false => ⟨m + 1, ((congrArg (fun b => b || s (m + 1)) seen).symm.trans yes : _)⟩

/-- **The decision of vanishing gives the limited principle of omniscience.** Levels `1` before
the first `true` of a Boolean sequence and `0` from it on vanish from some condition on exactly
where the sequence has a `true`. So the tail law, a counterexample to the least coupling, takes
at least `LPO`. -/
theorem lpo_of_vanish_decided (decides : ∀ α : Nat → Nat, Decidable (VanishFrom α)) : LPO :=
  fun s =>
    match decides (fun m => bif seenBy s m then 0 else 1) with
    | isTrue ⟨n, zero⟩ =>
      .inl (seenBy_exists (m := n)
        (match seen : seenBy s n with
         | true => rfl
         | false =>
           Nat.noConfusion
             ((congrArg (fun b => bif b then 0 else 1) seen).symm.trans
               (zero n (Nat.le_refl n)) : 1 = 0)))
    | isFalse stays =>
      .inr fun n =>
        match yes : s n with
        | false => rfl
        | true =>
          absurd ⟨n, fun _ le =>
            ((congrArg (fun b => bif b then 0 else 1) (seenBy_true yes le)) : _)⟩ stays

/-! ## Witness: finitely many conditions under each history, no list under all -/

namespace Pointer

/-- One formation exchanges with every condition the level, at step `0`, of the condition that
condition `0`'s level names. -/
def law : ExchangeLaw Unit Nat :=
  ⟨fun _ _ l _ => l 0 (l 0 0), fun _ _ _ _ => 0⟩

/-- Under each history it reads within two conditions: `0` and the one `0`'s level names. -/
theorem readsWithin (t : Nat) (l : Nat → Nat → Nat) : law.ReadsWithin t () l [0, l 0 0] :=
  fun l' agree _ =>
    have zero : l 0 0 = l' 0 0 := agree 0 (Nat.zero_le t) 0 (.head _)
    have named : l 0 (l 0 0) = l' 0 (l 0 0) := agree 0 (Nat.zero_le t) (l 0 0) (.tail _ (.head _))
    ⟨named.trans (congrArg (l' 0) zero), rfl⟩

/-- **It reads finitely many conditions.** -/
theorem readsFinitely : law.ReadsFinitely :=
  fun t _ l => ⟨[0, l 0 0], readsWithin t l⟩

/-- A number beyond every member of a list. -/
def beyond : List Nat → Nat
  | [] => 1
  | c :: cs => c + beyond cs + 1

theorem lt_beyond : ∀ (cs : List Nat) {c : Nat}, c ∈ cs → c < beyond cs
  | c' :: cs, _, mem =>
    match mem with
    | .head _ => Nat.lt_succ_of_le (Nat.le_add_right _ _)
    | .tail _ rest =>
      Nat.lt_succ_of_le
        (Nat.le_trans (Nat.le_of_lt (lt_beyond cs rest)) (Nat.le_add_left (beyond cs) c'))

theorem beyond_ne_zero : ∀ cs : List Nat, beyond cs ≠ 0
  | [] => fun same => Nat.noConfusion same
  | _ :: _ => fun same => Nat.noConfusion same

/-- The history in which condition `0` names `m` and every other condition stands at `0`. -/
def naming (m : Nat) : Nat → Nat → Nat :=
  fun _ e => if e = 0 then m else 0

/-- The same, with condition `m` at `1`. -/
def namingOne (m : Nat) : Nat → Nat → Nat :=
  fun _ e => if e = 0 then m else if e = m then 1 else 0

/-- **It reads within no one list under every history.** -/
theorem no_list : ¬ ∃ cs : List Nat, ∀ t l, law.ReadsWithin t () l cs :=
  fun ⟨cs, within⟩ =>
    have far : beyond cs ≠ 0 := beyond_ne_zero cs
    have agree : ∀ s, s ≤ 0 → ∀ c, c ∈ cs →
        naming (beyond cs) s c = namingOne (beyond cs) s c :=
      fun _ _ c mem =>
        match Nat.decEq c 0 with
        | isTrue zero => (if_pos zero).trans (if_pos zero).symm
        | isFalse other =>
          (if_neg other).trans
            ((if_neg other).trans (if_neg (Nat.ne_of_lt (lt_beyond cs mem)))).symm
    have first : law.take 0 () (naming (beyond cs)) 0 = 0 :=
      (congrArg (naming (beyond cs) 0) (if_pos rfl : naming (beyond cs) 0 0 = beyond cs)).trans
        (if_neg far)
    have second : law.take 0 () (namingOne (beyond cs)) 0 = 1 :=
      (congrArg (namingOne (beyond cs) 0)
          (if_pos rfl : namingOne (beyond cs) 0 0 = beyond cs)).trans
        ((if_neg far).trans (if_pos rfl))
    Nat.noConfusion
      (first.symm.trans ((within 0 (naming (beyond cs)) (namingOne (beyond cs)) agree 0).1.trans
        second))

end Pointer

end Becoming
