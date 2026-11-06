import Becoming.Sampling

/-!
# Stuttering: steps at which nothing happens

The spine counts steps `0, 1, 2, …`. This module and `Becoming.Reordering` ask how much of what
the laws state is carried by the step numbers and how much by the order in which things change,
making the two moves converse to `Becoming.Sampling`'s strictly increasing reading. Here steps
at which nothing happens are inserted (a stuttering, read with the same `sample`);
`Becoming.Reordering` takes two exchanges across consecutive steps in the other order, and
`Becoming.IdleRemoval` removes idle steps again.

* **Stutterings.** `Stutter ρ`: `ρ 0 = 0`, each step idle (`ρ (n + 1) = ρ n`) or moving by one,
  and every step reached. Read through `ρ`, an idle step holds no fine step (`span_idle`) and a
  moving step the one fine step read (`span_moves`).
  - At an idle step nothing takes part: balance, dissipation and closure hold on every family,
    and running down on a family holding what stands (`Flow.sample_idle_balancesOn`,
    `Flow.sample_idle_dissipatesOn`, `Flow.sample_idle_closedAt`, `Flow.sample_idle_runsDownOn`).
    At a moving step each holds exactly where it holds across the step read
    (`Flow.sample_moves_balancesOn_iff`, `Flow.sample_moves_dissipatesOn_iff`,
    `Flow.sample_moves_closedAt_iff`, `Flow.sample_moves_runsDownOn_iff`).
  - So a world read through a stuttering meets the premises exactly where it meets them
    (`World.stutter_premises_iff`): balance (each relatum listed once at each step), dissipation,
    only active relata giving, only active relata taking, activity needing support, embodiment
    and bounded transmission. Unlike a coarser reading (`Strobe.acting_taking_step_relative`,
    `Delay.transmitting_step_relative`), no condition on how activity is held is needed: each
    step of the reading holds at most one fine step.
  - Over any stretch the totals are those of the stretch read (`stutter_total`): what is taken
    and given (`Flow.stutter_taken`, `Flow.stutter_given`, each relatum listed once); the rises
    and falls of an amount and the steps at which it rises and falls (`stutter_risen`,
    `stutter_fallen`, `stutter_rise_count`, `stutter_fall_count`), so the terms of `over_stretch`;
    and, where it is decided, the members of a finite family coming to be and ceasing to be
    (`stutter_comings`, `stutter_ceasings`).
  - Arising, ceasing and change of standing recur read through a stuttering exactly where they
    recur (`World.stutter_arisingRecurs_iff`, `World.stutter_ceasingRecurs_iff`,
    `World.stutter_change_recurs_iff`, from `stutter_recurs_iff`). A census survives
    (`World.sample_counted`) and returns where a step of the reading is given for each step
    (`World.stutter_counted_of_section`).
* **What a stuttering changes: what is counted per step.** With idle steps at arbitrarily late
  steps no flow is more without end (`Flow.sample_not_more`): the expansion is more without end
  and, every step read twice, it is not (`Expansion.more_step_relative`). A reserve carrying a
  relatum active beyond support falls at every step, so does not carry across an idle step
  (`Web.sample_idle_not_carries`): a world carried by a reserve of one needs a reserve of two
  when every step is read twice (`Lapse.reserve_step_relative`).

Reading (the AI's, adopted on Ren's delegation of 15 October 2026, DELEGATED-CHOICES D30): for the
laws of one step, the totals and counts over a stretch, and recurrence, the step index carries
nothing beyond the order of change; an idle step makes no difference. What is counted per step,
rates and how long a reserve carries, is relative to the unit of the reading, as coarser steps
were (`Becoming.Sampling`).

Not shown: invariance of the predicates of the condition of chapter §6.15; continuous time. No
ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

/-! ## Arithmetic -/

/-- Where two sums agree, the excess of a part of one over a part of the other is the excess
of the other's remaining part over the first's: `x + y = a + b` gives `x - a = b - y`. -/
theorem excess_of_sum {x y a b : Nat} (sum : x + y = a + b) : excess x a = excess b y :=
  (excess_add_right x a y).symm.trans
    ((congrArg (fun k => excess k (a + y)) sum).trans
      ((congrArg (fun k => excess k (a + y)) (Nat.add_comm a b)).trans
        ((congrArg (fun k => excess (b + a) k) (Nat.add_comm a y)).trans
          (excess_add_right b y a))))

/-! ## Stutterings -/

/-- A stuttering: a reading of steps that starts at the first step, at each of its steps either
reads again the step it read, an *idle* step, or reads the next one, a *moving* step, and reads
every step. -/
def Stutter (ρ : Nat → Nat) : Prop :=
  ρ 0 = 0 ∧ (∀ n, ρ (n + 1) = ρ n ∨ ρ (n + 1) = ρ n + 1) ∧ ∀ s, ∃ n, ρ n = s

namespace Stutter

variable {ρ : Nat → Nat}

/-- A reading whose steps idle or move never reads an earlier step later. -/
theorem le_succ (moving : ∀ n, ρ (n + 1) = ρ n ∨ ρ (n + 1) = ρ n + 1) (n : Nat) :
    ρ n ≤ ρ (n + 1) :=
  match moving n with
  | .inl idle => Nat.le_of_eq idle.symm
  | .inr moves => Nat.le_trans (Nat.le_succ _) (Nat.le_of_eq moves.symm)

theorem mono (moving : ∀ n, ρ (n + 1) = ρ n ∨ ρ (n + 1) = ρ n + 1) :
    ∀ {n m : Nat}, n ≤ m → ρ n ≤ ρ m
  | _, _, .refl => Nat.le_refl _
  | _, m + 1, .step le => Nat.le_trans (mono moving le) (le_succ moving m)

/-- Where a reading's steps idle or move, it moves from below a step to above it across a moving
step reading it. -/
theorem crossing (moving : ∀ n, ρ (n + 1) = ρ n ∨ ρ (n + 1) = ρ n + 1) {s : Nat}
    (start : ρ 0 ≤ s) : ∀ m, s < ρ m → ∃ n, n < m ∧ ρ n = s ∧ ρ (n + 1) = s + 1
  | 0, above => absurd start (Nat.not_le_of_gt above)
  | m + 1, above => match moving m with
    | .inl idle => match crossing moving start m (Nat.lt_of_lt_of_le above (Nat.le_of_eq idle)) with
      | ⟨n, below, here, next⟩ => ⟨n, Nat.lt_succ_of_lt below, here, next⟩
    | .inr moves => match Nat.lt_or_ge s (ρ m) with
      | .inl lt => match crossing moving start m lt with
        | ⟨n, below, here, next⟩ => ⟨n, Nat.lt_succ_of_lt below, here, next⟩
      | .inr ge =>
        have same : ρ m = s := Nat.le_antisymm ge
          (Nat.le_of_lt_succ (Nat.lt_of_lt_of_le above (Nat.le_of_eq moves)))
        ⟨m, Nat.lt_succ_self m, same, moves.trans (congrArg (· + 1) same)⟩

/-- A stuttering reads each step at a moving step. -/
theorem crosses (stutter : Stutter ρ) (s : Nat) : ∃ n, ρ n = s ∧ ρ (n + 1) = s + 1 :=
  match stutter.2.2 (s + 1) with
  | ⟨m, reads⟩ => match crossing stutter.2.1 (Nat.le_trans (Nat.le_of_eq stutter.1) (Nat.zero_le s)) m
      (Nat.lt_of_lt_of_le (Nat.lt_succ_self s) (Nat.le_of_eq reads.symm)) with
    | ⟨n, _, here, next⟩ => ⟨n, here, next⟩

/-- A moving step reading `t`. -/
theorem moving (stutter : Stutter ρ) (t : Nat) : ∃ n, ρ n = t ∧ ρ (n + 1) = ρ n + 1 :=
  match stutter.crosses t with
  | ⟨n, here, next⟩ => ⟨n, here, next.trans (congrArg (· + 1) here.symm)⟩

/-- A stuttering reads no step later than its own. -/
theorem le_self (stutter : Stutter ρ) : ∀ n, ρ n ≤ n
  | 0 => Nat.le_of_eq stutter.1
  | n + 1 => match stutter.2.1 n with
    | .inl idle => Nat.le_trans (Nat.le_of_eq idle) (Nat.le_trans (le_self stutter n) (Nat.le_succ n))
    | .inr moves => Nat.le_trans (Nat.le_of_eq moves) (Nat.succ_le_succ (le_self stutter n))

end Stutter

/-- At an idle step the coarse step holds no fine step. -/
theorem span_idle {ρ : Nat → Nat} {n : Nat} (idle : ρ (n + 1) = ρ n) : span ρ n = [] :=
  show steps (ρ n) (ρ (n + 1) - ρ n) = [] from
  (congrArg (fun k => steps (ρ n) (k - ρ n)) idle).trans
    (congrArg (steps (ρ n)) (Nat.sub_self (ρ n)))

/-- At a moving step the coarse step holds the one fine step read. -/
theorem span_moves {ρ : Nat → Nat} {n : Nat} (moves : ρ (n + 1) = ρ n + 1) :
    span ρ n = [ρ n] :=
  show steps (ρ n) (ρ (n + 1) - ρ n) = [ρ n] from
  (congrArg (fun k => steps (ρ n) (k - ρ n)) moves).trans
    (congrArg (steps (ρ n)) (succ_sub_self (ρ n)))

/-! ## One change read through a stuttering -/

section Change

variable {ρ : Nat → Nat} {n : Nat}

/-- Nothing comes to be across an idle step. -/
theorem not_comesToBe_idle {p : Nat → Prop} (idle : ρ (n + 1) = ρ n) :
    ¬ ComesToBe (fun k => p (ρ k)) n :=
  fun ⟨absent, held⟩ => absent (Eq.subst (motive := p) idle held)

/-- Nothing ceases to be across an idle step. -/
theorem not_ceasesToBe_idle {p : Nat → Prop} (idle : ρ (n + 1) = ρ n) :
    ¬ CeasesToBe (fun k => p (ρ k)) n :=
  fun ⟨held, absent⟩ => absent (Eq.subst (motive := p) idle.symm held)

/-- Across a moving step something comes to be exactly where it comes to be across the step
read. -/
theorem comesToBe_moves {p : Nat → Prop} (moves : ρ (n + 1) = ρ n + 1) :
    ComesToBe (fun k => p (ρ k)) n ↔ ComesToBe p (ρ n) :=
  ⟨fun ⟨absent, held⟩ => ⟨absent, Eq.subst (motive := p) moves held⟩,
   fun ⟨absent, held⟩ => ⟨absent, Eq.subst (motive := p) moves.symm held⟩⟩

/-- And ceases to be exactly where it ceases to be across the step read. -/
theorem ceasesToBe_moves {p : Nat → Prop} (moves : ρ (n + 1) = ρ n + 1) :
    CeasesToBe (fun k => p (ρ k)) n ↔ CeasesToBe p (ρ n) :=
  ⟨fun ⟨held, absent⟩ => ⟨held, fun yes => absent (Eq.subst (motive := p) moves.symm yes)⟩,
   fun ⟨held, absent⟩ => ⟨held, fun yes => absent (Eq.subst (motive := p) moves yes)⟩⟩

/-- An amount rises by nothing across an idle step. -/
theorem rise_idle (q : Nat → Nat) (idle : ρ (n + 1) = ρ n) : rise (fun k => q (ρ k)) n = 0 :=
  (congrArg (fun k => excess (q k) (q (ρ n))) idle).trans (excess_self _)

/-- And falls by nothing. -/
theorem fall_idle (q : Nat → Nat) (idle : ρ (n + 1) = ρ n) : fall (fun k => q (ρ k)) n = 0 :=
  (congrArg (fun k => excess (q (ρ n)) (q k)) idle).trans (excess_self _)

/-- Across a moving step it rises as across the step read. -/
theorem rise_moves (q : Nat → Nat) (moves : ρ (n + 1) = ρ n + 1) :
    rise (fun k => q (ρ k)) n = rise q (ρ n) :=
  congrArg (fun k => excess (q k) (q (ρ n))) moves

/-- And falls as across the step read. -/
theorem fall_moves (q : Nat → Nat) (moves : ρ (n + 1) = ρ n + 1) :
    fall (fun k => q (ρ k)) n = fall q (ρ n) :=
  congrArg (fun k => excess (q (ρ n)) (q k)) moves

end Change

/-! ## Totals over a stretch read through a stuttering -/

section Totals

variable {ρ : Nat → Nat}

/-- A quantity of each step, read through a reading whose steps idle or move: nothing at the
idle steps, the quantity of the step read at the moving ones. Over any stretch it totals what
the quantity totals over the stretch read. -/
theorem stutter_total (moving : ∀ n, ρ (n + 1) = ρ n ∨ ρ (n + 1) = ρ n + 1) {g g' : Nat → Nat}
    (idle : ∀ n, ρ (n + 1) = ρ n → g' n = 0) (moves : ∀ n, ρ (n + 1) = ρ n + 1 → g' n = g (ρ n))
    (N : Nat) : ∀ m d, ρ N + d = ρ (N + m) →
      total (steps N m) g' = total (steps (ρ N) d) g
  | 0, 0, _ => rfl
  | 0, d + 1, reads => absurd (Nat.le_of_eq reads)
      (Nat.not_le_of_gt (Nat.lt_add_of_pos_right (Nat.succ_pos d)))
  | m + 1, d, reads => match moving (N + m) with
    | .inl still =>
      (steps_last g' N m).trans
        ((congrArg (total (steps N m) g' + ·) (idle (N + m) still)).trans
          (stutter_total moving idle moves N m d (reads.trans still)))
    | .inr next => match d, reads with
      | 0, reads => absurd (Nat.le_of_eq reads.symm)
          (Nat.not_le_of_gt (Nat.lt_of_le_of_lt (Stutter.mono moving (Nat.le_add_right N m))
            (Nat.lt_of_lt_of_le (Nat.lt_succ_self _) (Nat.le_of_eq next.symm))))
      | d + 1, reads =>
        have earlier : ρ N + d = ρ (N + m) := Nat.succ.inj (reads.trans next)
        (steps_last g' N m).trans
          ((congrArg (total (steps N m) g' + ·) (moves (N + m) next)).trans
            ((congrArg (· + g (ρ (N + m))) (stutter_total moving idle moves N m d earlier)).trans
              ((congrArg (fun k => total (steps (ρ N) d) g + g k) earlier).symm.trans
                (steps_last g (ρ N) d).symm)))

end Totals


/-! ## A flow and a web read through a stuttering

A stuttering read with `Becoming.Sampling`'s `sample`: at an idle step the coarse step holds no
fine step, so nothing takes part and the web shows the same step on both sides of it; at a
moving step it holds the one fine step read. -/

variable {F C : Type}

namespace Flow

section Nil

variable {L : Flow F C} {ρ : Nat → Nat} {n : Nat}

/-- Where nothing takes part, nothing is taken. -/
theorem taken_nil {t : Nat} (none : L.present t = []) (c : C) : L.taken t c = 0 :=
  congrArg (fun l => total l fun f => L.take t f c) none

/-- Where nothing takes part, nothing is given. -/
theorem given_nil {t : Nat} (none : L.present t = []) (c : C) : L.given t c = 0 :=
  congrArg (fun l => total l fun f => L.give t f c) none

/-- At a moving step the one fine step read is the only one, so listing once there is listing
once at every fine step of it. -/
theorem once_of_moves (moves : ρ (n + 1) = ρ n + 1) (once : Distinct (L.present (ρ n))) :
    ∀ j, j ∈ span ρ n → Distinct (L.present j) :=
  fun j mem => match mem_cons_cases (Eq.subst (motive := fun l => j ∈ l) (span_moves moves) mem) with
    | .inl same => Eq.subst (motive := fun k => Distinct (L.present k)) same.symm once
    | .inr no => nomatch no

end Nil

variable [DecidableEq F] {L : Flow F C} {W : Web F C} {ρ : Nat → Nat} {n : Nat}

/-- At an idle step nothing takes part. -/
theorem sample_idle_present (idle : ρ (n + 1) = ρ n) : (L.sample ρ).present n = [] :=
  congrArg L.unionPresent (span_idle idle)

/-- At an idle step nothing is taken. -/
theorem sample_idle_take (idle : ρ (n + 1) = ρ n) (f : F) (c : C) :
    (L.sample ρ).take n f c = 0 :=
  congrArg (fun l => total l fun j => gate f (L.present j) (L.take j f c)) (span_idle idle)

/-- At an idle step nothing is given. -/
theorem sample_idle_give (idle : ρ (n + 1) = ρ n) (f : F) (c : C) :
    (L.sample ρ).give n f c = 0 :=
  congrArg (fun l => total l fun j => gate f (L.present j) (L.give j f c)) (span_idle idle)

/-- At a moving step the relata taking part are those taking part in the step read. -/
theorem sample_moves_mem (moves : ρ (n + 1) = ρ n + 1) {f : F} :
    f ∈ (L.sample ρ).present n ↔ f ∈ L.present (ρ n) :=
  have same : (L.sample ρ).present n = L.unionPresent [ρ n] :=
    congrArg L.unionPresent (span_moves moves)
  ⟨fun mem => match (L.unionPresent_spec [ρ n]).2.2 f
      (Eq.subst (motive := fun l => f ∈ l) same mem) with
     | ⟨_, here, held⟩ => match mem_cons_cases here with
       | .inl same' => Eq.subst (motive := fun k => f ∈ L.present k) same' held
       | .inr no => (nomatch no),
   fun held => Eq.subst (motive := fun l => f ∈ l) same.symm
     ((L.unionPresent_spec [ρ n]).2.1 (ρ n) (.head []) f held)⟩

/-- And each takes what it takes across the step read. -/
theorem sample_moves_take (moves : ρ (n + 1) = ρ n + 1) {f : F} (held : f ∈ L.present (ρ n))
    (c : C) : (L.sample ρ).take n f c = L.take (ρ n) f c :=
  (congrArg (fun l => total l fun j => gate f (L.present j) (L.take j f c))
    (span_moves moves)).trans ((Nat.add_zero _).trans (gate_mem held _))

/-- And gives what it gives across the step read. -/
theorem sample_moves_give (moves : ρ (n + 1) = ρ n + 1) {f : F} (held : f ∈ L.present (ρ n))
    (c : C) : (L.sample ρ).give n f c = L.give (ρ n) f c :=
  (congrArg (fun l => total l fun j => gate f (L.present j) (L.give j f c))
    (span_moves moves)).trans ((Nat.add_zero _).trans (gate_mem held _))

/-- Each relatum listed once at the step read, what is taken from a condition across a moving
step is what is taken from it across the step read. -/
theorem sample_moves_taken (moves : ρ (n + 1) = ρ n + 1) (once : Distinct (L.present (ρ n)))
    (c : C) : (L.sample ρ).taken n c = L.taken (ρ n) c :=
  (sample_taken_on ρ (once_of_moves moves once) c).trans
    ((congrArg (fun l => total l fun j => L.taken j c) (span_moves moves)).trans (Nat.add_zero _))

/-- And what is given to it is what is given to it across the step read. -/
theorem sample_moves_given (moves : ρ (n + 1) = ρ n + 1) (once : Distinct (L.present (ρ n)))
    (c : C) : (L.sample ρ).given n c = L.given (ρ n) c :=
  (sample_given_on ρ (once_of_moves moves once) c).trans
    ((congrArg (fun l => total l fun j => L.given j c) (span_moves moves)).trans (Nat.add_zero _))

/-! ### The laws of one step at an idle step -/

/-- Balance holds on every family across an idle step. -/
theorem sample_idle_balancesOn (idle : ρ (n + 1) = ρ n) (cs : List C) :
    (L.sample ρ).BalancesOn (W.sample ρ) cs n :=
  fun c _ => (congrArg (· + (L.sample ρ).taken n c) (congrArg (fun k => W.level k c) idle)).trans
    (congrArg (W.level (ρ n) c + ·) ((taken_nil (sample_idle_present idle) c).trans
      (given_nil (sample_idle_present idle) c).symm))

/-- Every family is dissipated on across an idle step. -/
theorem sample_idle_dissipatesOn (idle : ρ (n + 1) = ρ n) (cs : List C) :
    (L.sample ρ).DissipatesOn cs n :=
  fun f mem => absurd (Eq.subst (motive := fun l => f ∈ l) (sample_idle_present idle) mem)
    fun no => nomatch no

/-- Every family is closed across an idle step. -/
theorem sample_idle_closedAt (idle : ρ (n + 1) = ρ n) (cs : List C) :
    (L.sample ρ).ClosedAt cs n :=
  fun f mem => absurd (Eq.subst (motive := fun l => f ∈ l) (sample_idle_present idle) mem)
    fun no => nomatch no

/-- So every idle step is enclosed. -/
theorem sample_idle_enclosed (idle : ρ (n + 1) = ρ n) : (L.sample ρ).Enclosed n :=
  ⟨[], trivial, sample_idle_closedAt idle []⟩

/-- A family without repetition holding what stands at the step read runs down across an idle
step. -/
theorem sample_idle_runsDownOn (idle : ρ (n + 1) = ρ n) {es : List C} (distinct : Distinct es)
    (holds : ∀ c, 0 < W.level (ρ n) c → c ∈ es) : (L.sample ρ).RunsDownOn (W.sample ρ) es n :=
  ⟨distinct, holds,
   fun c stands => holds c (Eq.subst (motive := fun k => 0 < W.level k c) idle stands),
   sample_idle_balancesOn idle es, sample_idle_dissipatesOn idle es⟩

/-! ### The laws of one step at a moving step -/

/-- Balance at a moving step is balance at the step read, each relatum listed once there. -/
theorem sample_moves_balancesOn_iff (moves : ρ (n + 1) = ρ n + 1)
    (once : Distinct (L.present (ρ n))) {cs : List C} :
    (L.sample ρ).BalancesOn (W.sample ρ) cs n ↔ L.BalancesOn W cs (ρ n) :=
  have ends : ∀ c, W.level (ρ (n + 1)) c + (L.sample ρ).taken n c =
      W.level (ρ n + 1) c + L.taken (ρ n) c := fun c =>
    congr (congrArg (· + ·) (congrArg (fun k => W.level k c) moves)) (sample_moves_taken moves once c)
  ⟨fun balances c mem => (ends c).symm.trans ((balances c mem).trans
      (congrArg (W.level (ρ n) c + ·) (sample_moves_given moves once c))),
   fun balances c mem => (ends c).trans ((balances c mem).trans
      (congrArg (W.level (ρ n) c + ·) (sample_moves_given moves once c)).symm)⟩

/-- Dissipation at a moving step is dissipation at the step read. -/
theorem sample_moves_dissipatesOn_iff (moves : ρ (n + 1) = ρ n + 1) {cs : List C} :
    (L.sample ρ).DissipatesOn cs n ↔ L.DissipatesOn cs (ρ n) :=
  have take : ∀ f, f ∈ L.present (ρ n) →
      total cs ((L.sample ρ).take n f) = total cs (L.take (ρ n) f) :=
    fun _ held => total_congr (fun c => sample_moves_take moves held c) cs
  have give : ∀ f, f ∈ L.present (ρ n) →
      total cs ((L.sample ρ).give n f) = total cs (L.give (ρ n) f) :=
    fun _ held => total_congr (fun c => sample_moves_give moves held c) cs
  ⟨fun dissipates f held => Nat.le_trans
      (Nat.le_of_eq (congr (congrArg (· + ·) (give f held)) (congrArg sign (take f held))).symm)
      (Nat.le_trans (dissipates f ((sample_moves_mem moves).mpr held))
        (Nat.le_of_eq (take f held))),
   fun dissipates f mem =>
     have held := (sample_moves_mem moves).mp mem
     Nat.le_trans
      (Nat.le_of_eq (congr (congrArg (· + ·) (give f held)) (congrArg sign (take f held))))
      (Nat.le_trans (dissipates f held) (Nat.le_of_eq (take f held).symm))⟩

/-- Closure at a moving step is closure at the step read. -/
theorem sample_moves_closedAt_iff (moves : ρ (n + 1) = ρ n + 1) {cs : List C} :
    (L.sample ρ).ClosedAt cs n ↔ L.ClosedAt cs (ρ n) :=
  (sample_closedAt_iff ρ).trans
    ⟨fun closed => closed (ρ n)
        (Eq.subst (motive := fun l => ρ n ∈ l) (span_moves moves).symm (.head [])),
     fun closed j mem =>
      match mem_cons_cases (Eq.subst (motive := fun l => j ∈ l) (span_moves moves) mem) with
      | .inl same => Eq.subst (motive := fun k => L.ClosedAt cs k) same.symm closed
      | .inr no => nomatch no⟩

/-- Running down at a moving step is running down at the step read, each relatum listed once
there. -/
theorem sample_moves_runsDownOn_iff (moves : ρ (n + 1) = ρ n + 1)
    (once : Distinct (L.present (ρ n))) {es : List C} :
    (L.sample ρ).RunsDownOn (W.sample ρ) es n ↔ L.RunsDownOn W es (ρ n) :=
  ⟨fun ⟨distinct, before, after, balances, dissipates⟩ => ⟨distinct, before,
     fun c stands => after c (Eq.subst (motive := fun k => 0 < W.level k c) moves.symm stands),
     (sample_moves_balancesOn_iff moves once).mp balances,
     (sample_moves_dissipatesOn_iff moves).mp dissipates⟩,
   fun ⟨distinct, before, after, balances, dissipates⟩ => ⟨distinct, before,
     fun c stands => after c (Eq.subst (motive := fun k => 0 < W.level k c) moves stands),
     (sample_moves_balancesOn_iff moves once).mpr balances,
     (sample_moves_dissipatesOn_iff moves).mpr dissipates⟩⟩

/-- Only active relata giving, at a moving step, is the same at the step read. -/
theorem sample_moves_acting_iff (moves : ρ (n + 1) = ρ n + 1) :
    (∀ f c, f ∈ (L.sample ρ).present n → 0 < (L.sample ρ).give n f c → W.active (ρ n) f) ↔
      ∀ f c, f ∈ L.present (ρ n) → 0 < L.give (ρ n) f c → W.active (ρ n) f :=
  ⟨fun acting f c held gives => acting f c ((sample_moves_mem moves).mpr held)
      (Nat.lt_of_lt_of_le gives (Nat.le_of_eq (sample_moves_give moves held c).symm)),
   fun acting f c mem gives =>
     have held := (sample_moves_mem moves).mp mem
     acting f c held (Nat.lt_of_lt_of_le gives (Nat.le_of_eq (sample_moves_give moves held c)))⟩

/-- Only active relata taking, and only from what they draw on, likewise. -/
theorem sample_moves_taking_iff (moves : ρ (n + 1) = ρ n + 1) :
    (∀ f c, f ∈ (L.sample ρ).present n → 0 < (L.sample ρ).take n f c →
        W.active (ρ n) f ∧ W.draws (ρ n) f c) ↔
      ∀ f c, f ∈ L.present (ρ n) → 0 < L.take (ρ n) f c → W.active (ρ n) f ∧ W.draws (ρ n) f c :=
  ⟨fun taking f c held takes => taking f c ((sample_moves_mem moves).mpr held)
      (Nat.lt_of_lt_of_le takes (Nat.le_of_eq (sample_moves_take moves held c).symm)),
   fun taking f c mem takes =>
     have held := (sample_moves_mem moves).mp mem
     taking f c held (Nat.lt_of_lt_of_le takes (Nat.le_of_eq (sample_moves_take moves held c)))⟩

/-! ### The laws of a flow read through a stuttering -/

/-- Balance survives a stuttering, and returns from it, each relatum listed once. -/
theorem stutter_balances_iff (stutter : Stutter ρ) (once : L.Once) :
    (L.sample ρ).Balances (W.sample ρ) ↔ L.Balances W :=
  ⟨fun balances => balances_iff_on.mpr fun cs t => match stutter.moving t with
     | ⟨n, here, moves⟩ => Eq.subst (motive := fun k => L.BalancesOn W cs k) here
        ((sample_moves_balancesOn_iff moves (once (ρ n))).mp (balances.on cs n)),
   fun balances => balances_iff_on.mpr fun cs n => match stutter.2.1 n with
     | .inl idle => sample_idle_balancesOn idle cs
     | .inr moves => (sample_moves_balancesOn_iff moves (once (ρ n))).mpr (balances.on cs (ρ n))⟩

/-- Dissipation survives a stuttering and returns from it. -/
theorem stutter_dissipative_iff (stutter : Stutter ρ) :
    (L.sample ρ).Dissipative ↔ L.Dissipative :=
  ⟨fun dissipative cs t distinct closed => match stutter.moving t with
     | ⟨n, here, moves⟩ => Eq.subst (motive := fun k => L.DissipatesOn cs k) here
        ((sample_moves_dissipatesOn_iff moves).mp (dissipative cs n distinct
          ((sample_moves_closedAt_iff moves).mpr
            (Eq.subst (motive := fun k => L.ClosedAt cs k) here.symm closed)))),
   sample_dissipative ρ⟩

/-- Only active relata giving survives a stuttering and returns from it: no condition on how
activity is held is needed, since every step of the reading holds at most one fine step. -/
theorem stutter_acting_iff (stutter : Stutter ρ) :
    (L.sample ρ).Acting (W.sample ρ) ↔ L.Acting W :=
  ⟨fun acting t f c held gives => match stutter.moving t with
     | ⟨n, here, moves⟩ => Eq.subst (motive := fun k => W.active k f) here
        ((sample_moves_acting_iff moves).mp (acting n) f c
          (Eq.subst (motive := fun k => f ∈ L.present k) here.symm held)
          (Eq.subst (motive := fun k => 0 < L.give k f c) here.symm gives)),
   fun acting n f c mem gives => match stutter.2.1 n with
     | .inl idle => absurd (Nat.lt_of_lt_of_le gives (Nat.le_of_eq (sample_idle_give idle f c)))
        (Nat.lt_irrefl 0)
     | .inr moves => (sample_moves_acting_iff moves).mpr (acting (ρ n)) f c mem gives⟩

/-- Only active relata taking, and only from what they draw on, survives a stuttering and
returns from it. -/
theorem stutter_taking_iff (stutter : Stutter ρ) :
    (L.sample ρ).Taking (W.sample ρ) ↔ L.Taking W :=
  ⟨fun taking t f c held takes => match stutter.moving t with
     | ⟨n, here, moves⟩ => Eq.subst (motive := fun k => W.active k f ∧ W.draws k f c) here
        ((sample_moves_taking_iff moves).mp (taking n) f c
          (Eq.subst (motive := fun k => f ∈ L.present k) here.symm held)
          (Eq.subst (motive := fun k => 0 < L.take k f c) here.symm takes)),
   fun taking n f c mem takes => match stutter.2.1 n with
     | .inl idle => absurd (Nat.lt_of_lt_of_le takes (Nat.le_of_eq (sample_idle_take idle f c)))
        (Nat.lt_irrefl 0)
     | .inr moves => (sample_moves_taking_iff moves).mpr (taking (ρ n)) f c mem takes⟩

/-! ### What a stretch takes and gives -/

/-- Over any stretch, what is taken from a condition read through a stuttering totals what is
taken from it over the stretch read, each relatum listed once. -/
theorem stutter_taken (moving : ∀ n, ρ (n + 1) = ρ n ∨ ρ (n + 1) = ρ n + 1) (once : L.Once)
    (c : C) (N m d : Nat) (reads : ρ N + d = ρ (N + m)) :
    total (steps N m) (fun n => (L.sample ρ).taken n c) =
      total (steps (ρ N) d) (fun t => L.taken t c) :=
  stutter_total moving (fun _ idle => taken_nil (sample_idle_present idle) c)
    (fun n moves => sample_moves_taken moves (once (ρ n)) c) N m d reads

/-- And what is given to it totals what is given to it over the stretch read. -/
theorem stutter_given (moving : ∀ n, ρ (n + 1) = ρ n ∨ ρ (n + 1) = ρ n + 1) (once : L.Once)
    (c : C) (N m d : Nat) (reads : ρ N + d = ρ (N + m)) :
    total (steps N m) (fun n => (L.sample ρ).given n c) =
      total (steps (ρ N) d) (fun t => L.given t c) :=
  stutter_total moving (fun _ idle => given_nil (sample_idle_present idle) c)
    (fun n moves => sample_moves_given moves (once (ρ n)) c) N m d reads

end Flow


/-! ## Recurrence, totals and counts read through a stuttering -/

section Stretches

variable {ρ : Nat → Nat}

/-- An event read through a stuttering, absent at the idle steps and occurring at a moving step
exactly where it occurs at the step read, recurs exactly where it recurs. -/
theorem stutter_recurs_iff (stutter : Stutter ρ) {E E' : Nat → Prop}
    (idle : ∀ n, ρ (n + 1) = ρ n → ¬ E' n) (moves : ∀ n, ρ (n + 1) = ρ n + 1 → (E' n ↔ E (ρ n))) :
    (∀ N, ∃ n, N ≤ n ∧ E' n) ↔ ∀ N, ∃ t, N ≤ t ∧ E t :=
  ⟨fun recurs N => match stutter.2.2 N with
     | ⟨m, reads⟩ => match recurs m with
       | ⟨n, later, event⟩ => match stutter.2.1 n with
         | .inl still => absurd event (idle n still)
         | .inr next => ⟨ρ n, Nat.le_trans (Nat.le_of_eq reads.symm) (Stutter.mono stutter.2.1 later),
             (moves n next).mp event⟩,
   fun recurs N => match recurs N with
     | ⟨t, later, event⟩ => match stutter.moving t with
       | ⟨n, here, next⟩ => ⟨n, Nat.le_trans later (Nat.le_trans (Nat.le_of_eq here.symm)
            (stutter.le_self n)),
          (moves n next).mpr (Eq.subst (motive := E) here.symm event)⟩⟩

variable (moving : ∀ n, ρ (n + 1) = ρ n ∨ ρ (n + 1) = ρ n + 1)
include moving

/-- Over any stretch, an amount read through a stuttering rises in all what it rises in all over
the stretch read. -/
theorem stutter_risen (q : Nat → Nat) (N m d : Nat) (reads : ρ N + d = ρ (N + m)) :
    total (steps N m) (rise fun k => q (ρ k)) = total (steps (ρ N) d) (rise q) :=
  stutter_total moving (fun _ idle => rise_idle q idle) (fun _ moves => rise_moves q moves) N m d reads

/-- And falls in all what it falls in all over the stretch read. -/
theorem stutter_fallen (q : Nat → Nat) (N m d : Nat) (reads : ρ N + d = ρ (N + m)) :
    total (steps N m) (fall fun k => q (ρ k)) = total (steps (ρ N) d) (fall q) :=
  stutter_total moving (fun _ idle => fall_idle q idle) (fun _ moves => fall_moves q moves) N m d reads

/-- The steps at which it rises number those of the stretch read. -/
theorem stutter_rise_count (q : Nat → Nat) (N m d : Nat) (reads : ρ N + d = ρ (N + m)) :
    count (steps N m) (rise fun k => q (ρ k)) = count (steps (ρ N) d) (rise q) :=
  stutter_total (g := fun t => sign (rise q t)) (g' := fun k => sign (rise (fun k => q (ρ k)) k))
    moving (fun _ idle => congrArg sign (rise_idle q idle))
    (fun _ moves => congrArg sign (rise_moves q moves)) N m d reads

/-- And the steps at which it falls. -/
theorem stutter_fall_count (q : Nat → Nat) (N m d : Nat) (reads : ρ N + d = ρ (N + m)) :
    count (steps N m) (fall fun k => q (ρ k)) = count (steps (ρ N) d) (fall q) :=
  stutter_total (g := fun t => sign (fall q t)) (g' := fun k => sign (fall (fun k => q (ρ k)) k))
    moving (fun _ idle => congrArg sign (fall_idle q idle))
    (fun _ moves => congrArg sign (fall_moves q moves)) N m d reads

variable {α : Type} {as : List α} {p : α → Nat → Prop} [∀ a t, Decidable (p a t)]

/-- Over any stretch, the members of a finite family coming to be, read through a stuttering,
number those coming to be over the stretch read. -/
theorem stutter_comings (N m d : Nat) (reads : ρ N + d = ρ (N + m)) :
    total (steps N m) (comings as fun a k => p a (ρ k)) = total (steps (ρ N) d) (comings as p) :=
  stutter_total moving
    (fun _ idle => (total_congr (fun _ => mark_zero (not_comesToBe_idle idle)) as).trans
      (total_zero as))
    (fun _ moves => total_congr (fun _ => mark_iff (comesToBe_moves moves)) as) N m d reads

/-- And those ceasing to be number those ceasing to be over the stretch read. -/
theorem stutter_ceasings (N m d : Nat) (reads : ρ N + d = ρ (N + m)) :
    total (steps N m) (ceasings as fun a k => p a (ρ k)) = total (steps (ρ N) d) (ceasings as p) :=
  stutter_total moving
    (fun _ idle => (total_congr (fun _ => mark_zero (not_ceasesToBe_idle idle)) as).trans
      (total_zero as))
    (fun _ moves => total_congr (fun _ => mark_iff (ceasesToBe_moves moves)) as) N m d reads

end Stretches

/-! ## A web read through a stuttering -/

namespace Web

variable {W : Web F C} {ρ : Nat → Nat}

/-- Activity needing support survives a stuttering and returns from it. -/
theorem stutter_dependent_iff (stutter : Stutter ρ) : (W.sample ρ).Dependent ↔ W.Dependent :=
  ⟨fun dependent t f active => match stutter.2.2 t with
     | ⟨n, here⟩ => Eq.subst (motive := fun k => W.Supported k f) here
        (dependent n f (Eq.subst (motive := fun k => W.active k f) here.symm active)),
   sample_dependent ρ⟩

/-- A relatum standing exactly while active does so read through a stuttering, and
conversely. -/
theorem stutter_embodied_iff {X : Type} {W : Web X X} (stutter : Stutter ρ) {x : X} :
    (W.sample ρ).Embodied x ↔ W.Embodied x :=
  ⟨fun embodied t => match stutter.2.2 t with
     | ⟨n, here⟩ => Eq.subst (motive := fun k => (W.active k x ↔ 0 < W.level k x)) here
        (embodied n),
   fun embodied n => embodied (ρ n)⟩

end Web

/-! ## Descent read through a stuttering -/

namespace Flow

variable {X : Type} [DecidableEq X] {L : Flow X X} {W : Web X X} {ρ : Nat → Nat} {n : Nat}

/-- Nothing descends across an idle step. -/
theorem sample_idle_not_descends (idle : ρ (n + 1) = ρ n) {x g : X} :
    ¬ (L.sample ρ).DescendsAt (W.sample ρ) n x g :=
  fun ⟨_, gives, _⟩ => absurd (Nat.lt_of_lt_of_le gives (Nat.le_of_eq (sample_idle_give idle g x)))
    (Nat.lt_irrefl 0)

/-- Across a moving step a relatum descends exactly where it descends across the step read. -/
theorem sample_moves_descends_iff (moves : ρ (n + 1) = ρ n + 1) {x g : X} :
    (L.sample ρ).DescendsAt (W.sample ρ) n x g ↔ L.DescendsAt W (ρ n) x g :=
  ⟨fun ⟨mem, gives, comes⟩ =>
     have held := (sample_moves_mem moves).mp mem
     ⟨held, Nat.lt_of_lt_of_le gives (Nat.le_of_eq (sample_moves_give moves held x)),
      (comesToBe_moves (p := fun k => 0 < W.level k x) moves).mp comes⟩,
   fun ⟨held, gives, comes⟩ =>
     ⟨(sample_moves_mem moves).mpr held,
      Nat.lt_of_lt_of_le gives (Nat.le_of_eq (sample_moves_give moves held x).symm),
      (comesToBe_moves (p := fun k => 0 < W.level k x) moves).mpr comes⟩⟩

/-- Transmission within a bound survives a stuttering and returns from it, with the same
bound. The coarse steps of `Becoming.Sampling`'s `Delay` read a descent the fine steps lack
because one coarse step holds the gift and the coming to stand; a stuttering never puts two
fine steps in one. -/
theorem stutter_transmitsWithin_iff (stutter : Stutter ρ) {c : X} {δ : Nat} :
    (L.sample ρ).TransmitsWithin (W.sample ρ) c δ ↔ L.TransmitsWithin W c δ :=
  ⟨fun transmits t x g descends depends => match stutter.moving t with
     | ⟨n, here, moves⟩ =>
       have after : ρ (n + 1) = t + 1 := moves.trans (congrArg (· + 1) here)
       have inherited := transmits n x g
         ((sample_moves_descends_iff moves).mpr
           (Eq.subst (motive := fun k => L.DescendsAt W k x g) here.symm descends))
         (Eq.subst (motive := fun k => W.requires k x c) after.symm depends)
       ⟨Eq.subst (motive := fun k => W.requires k g c) here inherited.1,
        Eq.subst (motive := fun k => W.need k x c ≤ W.need t g c + δ) after
          (Eq.subst (motive := fun k => W.need (ρ (n + 1)) x c ≤ W.need k g c + δ) here
            inherited.2)⟩,
   fun transmits n x g descends depends => match stutter.2.1 n with
     | .inl idle => absurd descends (sample_idle_not_descends idle)
     | .inr moves =>
       have inherited := transmits (ρ n) x g ((sample_moves_descends_iff moves).mp descends)
         (Eq.subst (motive := fun k => W.requires k x c) moves depends)
       ⟨inherited.1, Eq.subst (motive := fun k => W.need k x c ≤ W.need (ρ n) g c + δ) moves.symm
          inherited.2⟩⟩

end Flow


/-! ## Worlds read through a stuttering -/

/-- Recurring at some relatum is recurring of there being one. -/
theorem recurs_shape {α : Type} {P : Nat → α → Prop} :
    (∀ N, ∃ t x, N ≤ t ∧ P t x) ↔ ∀ N, ∃ t, N ≤ t ∧ ∃ x, P t x :=
  ⟨fun recurs N => match recurs N with | ⟨t, x, later, p⟩ => ⟨t, later, x, p⟩,
   fun recurs N => match recurs N with | ⟨t, later, x, p⟩ => ⟨t, x, later, p⟩⟩

namespace World

variable {w : World} [DecidableEq w.Relatum] {ρ : Nat → Nat}

/-- Inserting idle steps leaves the premises as they were, and so does removing them: read
through a stuttering, a world meets balance (each relatum listed once at each step),
dissipation, only active relata giving, only active relata taking, activity needing support,
embodiment and bounded transmission exactly where it meets them. -/
theorem stutter_premises_iff (stutter : Stutter ρ) (once : w.flow.Once) :
    ((w.sample ρ).Balanced ↔ w.Balanced) ∧ ((w.sample ρ).Dissipative ↔ w.Dissipative) ∧
    ((w.sample ρ).Acting ↔ w.Acting) ∧ ((w.sample ρ).Taking ↔ w.Taking) ∧
    ((w.sample ρ).Dependent ↔ w.Dependent) ∧ ((w.sample ρ).Embodied ↔ w.Embodied) ∧
    ((w.sample ρ).Transmitting ↔ w.Transmitting) :=
  ⟨Flow.stutter_balances_iff (F := w.Relatum) (W := w.web) stutter once,
   Flow.stutter_dissipative_iff (F := w.Relatum) stutter,
   Flow.stutter_acting_iff (F := w.Relatum) (W := w.web) stutter,
   Flow.stutter_taking_iff (F := w.Relatum) (W := w.web) stutter,
   Web.stutter_dependent_iff (W := w.web) stutter,
   ⟨fun embodied x => (Web.stutter_embodied_iff stutter).mp (embodied x),
    fun embodied x => (Web.stutter_embodied_iff stutter).mpr (embodied x)⟩,
   ⟨fun ⟨δ, transmits⟩ => ⟨δ, fun c =>
      (Flow.stutter_transmitsWithin_iff (X := w.Relatum) stutter).mp (transmits c)⟩,
    fun ⟨δ, transmits⟩ => ⟨δ, fun c =>
      (Flow.stutter_transmitsWithin_iff (X := w.Relatum) stutter).mpr (transmits c)⟩⟩⟩

/-- And returns from it where each step is read at a step given for it. -/
theorem stutter_counted_of_section {σ : Nat → Nat} (section_ : ∀ s, ρ (σ s) = s)
    (counted : (w.sample ρ).Counted) : w.Counted :=
  match counted with
  | ⟨alive, census⟩ => ⟨fun s => alive (σ s), fun s =>
      Eq.subst (motive := fun k => Distinct (alive (σ s)) ∧ ∀ x, w.web.active k x ↔ x ∈ alive (σ s))
        (section_ s) (census (σ s))⟩

/-- Arising recurs read through a stuttering exactly where it recurs. -/
theorem stutter_arisingRecurs_iff (stutter : Stutter ρ) :
    (w.sample ρ).ArisingRecurs ↔ w.ArisingRecurs :=
  recurs_shape.trans ((stutter_recurs_iff stutter (E := fun t => ∃ x, w.web.Arises t x)
    (fun _ idle ⟨x, arises⟩ => not_comesToBe_idle (p := fun k => w.web.active k x) idle arises)
    (fun _ moves => ⟨fun ⟨x, arises⟩ => ⟨x, (comesToBe_moves (p := fun k => w.web.active k x)
        moves).mp arises⟩,
      fun ⟨x, arises⟩ => ⟨x, (comesToBe_moves (p := fun k => w.web.active k x) moves).mpr
        arises⟩⟩)).trans recurs_shape.symm)

/-- Ceasing recurs read through a stuttering exactly where it recurs. -/
theorem stutter_ceasingRecurs_iff (stutter : Stutter ρ) :
    (w.sample ρ).CeasingRecurs ↔ w.CeasingRecurs :=
  recurs_shape.trans ((stutter_recurs_iff stutter (E := fun t => ∃ x, w.web.Ceases t x)
    (fun _ idle ⟨x, ceases⟩ => not_ceasesToBe_idle (p := fun k => w.web.active k x) idle ceases)
    (fun _ moves => ⟨fun ⟨x, ceases⟩ => ⟨x, (ceasesToBe_moves (p := fun k => w.web.active k x)
        moves).mp ceases⟩,
      fun ⟨x, ceases⟩ => ⟨x, (ceasesToBe_moves (p := fun k => w.web.active k x) moves).mpr
        ceases⟩⟩)).trans recurs_shape.symm)

/-- Some standing changes at arbitrarily late steps read through a stuttering exactly where it
does. -/
theorem stutter_change_recurs_iff (stutter : Stutter ρ) :
    (∀ N, ∃ t, N ≤ t ∧ ∃ c, (w.sample ρ).web.Rises t c ∨ (w.sample ρ).web.Falls t c) ↔
      ∀ N, ∃ t, N ≤ t ∧ ∃ c, w.web.Rises t c ∨ w.web.Falls t c :=
  have flat : ∀ n : Nat, ρ (n + 1) = ρ n → ∀ c : w.Relatum,
      ¬ ((w.sample ρ).web.Rises n c ∨ (w.sample ρ).web.Falls n c) := fun _ idle c changes =>
    match changes with
    | .inl rises => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le (excess_pos.mpr rises)
        (Nat.le_of_eq (rise_idle (fun k => w.web.level k c) idle)))
    | .inr falls => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le (excess_pos.mpr falls)
        (Nat.le_of_eq (fall_idle (fun k => w.web.level k c) idle)))
  have moved : ∀ n : Nat, ρ (n + 1) = ρ n + 1 → ∀ c : w.Relatum,
      (((w.sample ρ).web.Rises n c ∨ (w.sample ρ).web.Falls n c) ↔
        (w.web.Rises (ρ n) c ∨ w.web.Falls (ρ n) c)) := fun n moves c =>
    have up : (w.sample ρ).web.Rises n c ↔ w.web.Rises (ρ n) c :=
      excess_pos.symm.trans ((Iff.of_eq (congrArg (0 < ·)
        (rise_moves (fun k => w.web.level k c) moves))).trans excess_pos)
    have down : (w.sample ρ).web.Falls n c ↔ w.web.Falls (ρ n) c :=
      excess_pos.symm.trans ((Iff.of_eq (congrArg (0 < ·)
        (fall_moves (fun k => w.web.level k c) moves))).trans excess_pos)
    ⟨fun changes => match changes with
      | .inl rises => .inl (up.mp rises)
      | .inr falls => .inr (down.mp falls),
     fun changes => match changes with
      | .inl rises => .inl (up.mpr rises)
      | .inr falls => .inr (down.mpr falls)⟩
  stutter_recurs_iff stutter (fun n idle ⟨c, changes⟩ => flat n idle c changes)
    fun n moves => ⟨fun ⟨c, changes⟩ => ⟨c, (moved n moves c).mp changes⟩,
      fun ⟨c, changes⟩ => ⟨c, (moved n moves c).mpr changes⟩⟩

end World

/-! ## What a stuttering changes: rates and durations -/

namespace Flow

variable [DecidableEq F] {L : Flow F C} {ρ : Nat → Nat} {n : Nat}

/-- Nothing takes across an idle step. -/
theorem sample_idle_takers (idle : ρ (n + 1) = ρ n) (cs : List C) : (L.sample ρ).takers cs n = 0 :=
  congrArg (fun l => count l fun f => total cs ((L.sample ρ).take n f)) (sample_idle_present idle)

/-- Rates are counted per step. Read through a reading with idle steps at arbitrarily late
steps, no flow is more without end: at an idle step nothing takes. -/
theorem sample_not_more (idles : ∀ N, ∃ n, N ≤ n ∧ ρ (n + 1) = ρ n) (cs : List C) :
    ¬ (L.sample ρ).More cs :=
  fun more => match more 1 with
  | ⟨T, many⟩ => match idles T with
    | ⟨n, later, idle⟩ => Nat.not_succ_le_zero 0
        (Nat.le_trans (many n later) (Nat.le_of_eq (sample_idle_takers idle cs)))

end Flow

namespace Web

variable {W : Web F C} {ρ : Nat → Nat} {n : Nat}

/-- Durations are counted per step. A reserve read through a stuttering does not carry across
an idle step at which a relatum is active beyond support: nothing changes there, the reserve
included, while carrying asks it to fall. -/
theorem sample_idle_not_carries (idle : ρ (n + 1) = ρ n) {f : F}
    (unsupported : ¬ W.Supported (ρ n) f) (active : W.active (ρ n) f) (r : Nat → F → Nat) :
    ¬ (W.sample ρ).Carries fun k => r (ρ k) :=
  fun carries => Nat.lt_irrefl (r (ρ n) f)
    (Eq.subst (motive := fun k => r k f < r (ρ n) f) idle ((carries n f unsupported).2 active))

end Web

/-! ### The halving: every step read twice -/

namespace Order.Halving

/-- `Pulse.half` reads every step twice, `0, 0, 1, 1, 2, 2, …`: a stuttering idle at every
even step. -/
theorem steps_ : ∀ n, Pulse.half (n + 1) = Pulse.half n ∨ Pulse.half (n + 1) = Pulse.half n + 1
  | 0 => .inl rfl
  | 1 => .inr rfl
  | n + 2 => match steps_ n with
    | .inl idle => .inl (congrArg (· + 1) idle)
    | .inr moves => .inr (congrArg (· + 1) moves)

theorem stutter : Stutter Pulse.half :=
  ⟨rfl, steps_, fun s => ⟨2 * s, Pulse.half_even s⟩⟩

/-- Idle at every even step, so at arbitrarily late steps. -/
theorem idles (N : Nat) : ∃ n, N ≤ n ∧ Pulse.half (n + 1) = Pulse.half n :=
  ⟨2 * N, Nat.le_trans (Nat.le_add_right N N) (Nat.le_of_eq (Nat.two_mul N).symm),
   (Pulse.half_odd N).trans (Pulse.half_even N).symm⟩

end Order.Halving

namespace Expansion

instance kind_decided : DecidableEq Kind := fun a b => match a, b with
  | .renewer, .renewer => .isTrue rfl
  | .grower, .grower => .isTrue rfl
  | .renewer, .grower => .isFalse fun same => Kind.noConfusion same
  | .grower, .renewer => .isFalse fun same => Kind.noConfusion same

/-- More without end is not kept by inserting idle steps: the expansion is more without end,
and read with every step taken twice it is not. -/
theorem more_step_relative : flow.More [()] ∧ ¬ (flow.sample Pulse.half).More [()] :=
  ⟨more.2.2.2.2.2.2, Flow.sample_not_more Order.Halving.idles [()]⟩

end Expansion

namespace Lapse

/-- One relatum active at the first step only, depending at need one on a condition standing
at nothing: never supported. -/
def web : Web Unit Unit where
  level _ _ := 0
  active t _ := t = 0
  requires _ _ _ := True
  need _ _ _ := 1
  draws _ _ _ := False

/-- A reserve of one at the first step, none after. -/
def reserve : Nat → Unit → Nat
  | 0, _ => 1
  | _ + 1, _ => 0

theorem unsupported (t : Nat) : ¬ web.Supported t () :=
  fun supported => Nat.not_succ_le_zero 0 (supported () trivial)

/-- A reserve of one carries it. -/
theorem carried : web.Carries reserve
  | 0, (), _ => ⟨Nat.zero_le 1, fun _ => Nat.zero_lt_one⟩
  | _ + 1, (), _ => ⟨Nat.le_refl 0, fun active => Nat.noConfusion active⟩

/-- Read with every step taken twice, it is active beyond support at two steps, so every reserve
carrying it stands at two or more at the start: how long a reserve carries is counted in
steps. -/
theorem stuttered_reserve (r : Nat → Unit → Nat) (carries : (web.sample Pulse.half).Carries r) :
    2 ≤ r 0 () :=
  have first : r 1 () < r 0 () := (carries 0 () (unsupported 0)).2 rfl
  have second : r 2 () < r 1 () := (carries 1 () (unsupported 0)).2 rfl
  Nat.succ_le_of_lt (Nat.lt_of_le_of_lt
    (Nat.succ_le_of_lt (Nat.lt_of_le_of_lt (Nat.zero_le _) second)) first)

/-- So the reserve law is step-relative: the world is carried by a reserve of one, the world read
with every step taken twice by none below two. -/
theorem reserve_step_relative :
    web.Carries reserve ∧ reserve 0 () = 1 ∧
      ∀ r, (web.sample Pulse.half).Carries r → 2 ≤ r 0 () :=
  ⟨carried, rfl, stuttered_reserve⟩

end Lapse

end Becoming
