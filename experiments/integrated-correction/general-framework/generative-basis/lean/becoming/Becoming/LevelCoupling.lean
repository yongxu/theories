import Becoming.Observation

/-!
# Level coupling: where a level couples into a formation

The naming study of 17-18 October (N1, study §6.2) adopted "couples into" for what
`Web.CoupledInto` names, in two grains: by threshold (`Web.DependsOn`) and by level (`obs`).
Ren agreed and asked for the instance check: "Claim and prove the instance check of coupling by
level against Observation/Loops (study §6.2), still no renames." `obs` is a supplied relation,
while a coupling of `Becoming.Loops` is a positive strength of an exchange law and a route of
`Becoming.Observation` is a reading of one. This module states, with no premise beyond what each
theorem names, how the three meet. No name is changed.

* **A response is a coupling of every strength array.** Across the step from `t`, `h`'s exchange
  with `c` responds to the level of `d` at `s` when two histories differing at most in that
  level give a positive exchange gap (`ExchangeLaw.RespondsTo`). Strength zero is exactly no
  response (`ExchangeLaw.respondsWithin_zero_iff`); a response forces every strength of the law
  for that level to be positive (`ExchangeLaw.RespondsTo.strength_pos`), so it is a coupling of
  `Becoming.Loops` for every strength array of the law (`ExchangeLaw.RespondsTo.couples`) and a
  route of length one (`ExchangeLaw.RespondsTo.upstream`).
* **Only what couples into a formation responds.** For a law reading, for each formation outside
  the part, only what couples into it (`ExchangeLaw.Through`): a level that couples into it
  neither by threshold nor by level is coupled with strength zero (`ExchangeLaw.Through.respondsWithin_uncoupled`), so a
  response comes from a condition that couples into it (`ExchangeLaw.Through.couples_of_respondsTo`),
  and is a route of reading in every schedule covering what couples into it
  (`ExchangeLaw.Through.reads_of_respondsTo`, `ExchangeLaw.Through.couples_readCouplings`) and a
  route of the law's strengths restricted to that schedule
  (`ExchangeLaw.Through.upstream_restrictInto`).
* **By threshold, only a crossing passes.** A change of one level that leaves its need met
  alike is a response by level (`ExchangeLaw.RespondsByLevel`). Where the condition does not
  couple into the formation by level, no law reading through its couplings responds to it by level
  (`ExchangeLaw.Through.not_respondsByLevel`): through the threshold only a crossing passes.
* **By threshold, a crossing passes.** A response to a condition that does not couple into the
  formation by level is a crossing of its need (`ExchangeLaw.Through.crosses_of_unobserved`). Where the formation
  requires at a step exactly that one condition, with a positive need, a law reading through its
  couplings responds to a crossing there, at every condition (`thresholdLaw`,
  `thresholdLaw_through`, `thresholdLaw_respondsByCrossing`, `crossing_passes`). The 18 October
  continuation (N3) added this half.
* **Among several conditions, a crossing passes through the conjunction.** A response to a
  condition that does not couple into the formation by level changes its admission at that step, at or before the
  step of the exchange (`ExchangeLaw.Through.admission_changes_of_unobserved`), so it happens only
  where the formation's other requirements there are met (`ExchangeLaw.Through.others_met_of_unobserved`).
  A response by a crossing needs a positive requirement (`ExchangeLaw.RespondsByCrossing.requires_pos`).
  Where the formation's admission at the step is decided, a crossing of a condition passes, through
  a law reading only that decision, into every later exchange and at every condition, exactly where
  the formation requires the condition there with a positive need (`admissionLaw`,
  `admissionLaw_through`, `admissionLaw_respondsByCrossing`, `crossing_passes_iff`); a listed
  support decides admission (`admitsDecidableOfSupport`, `crossing_passes_of_support`). The second
  18 October continuation (N4) added this.
* **By level, the level passes.** Where the condition couples into it by level, a law reading
  through its couplings responds to it by level at every step and condition (`levelLaw`,
  `levelLaw_through`, `levelLaw_respondsByLevel`). So coupling by level (`obs`) is exactly where a level can couple
  into a formation within its threshold (`not_not_obs_iff_respondsByLevel`).
* **What dependence alone carries of a level.** Read activity needing support off the law at a
  step: a formation not admitted by the levels there exchanges nothing across it
  (`ExchangeLaw.NeedsSupportAt`, as reading requirement as response gives it). Under a law reading
  through dependence alone (`thresholdOnly`), such a formation takes and gives no less where the
  levels at the step stand no lower, the history before alike (`ExchangeLaw.Through.rises_at_step`).
  So a response carried by a family of them rises with the levels at the step
  (`ExchangeLaw.Through.carried_rises`), and falls only where some level at the step falls
  (`ExchangeLaw.Through.carried_fall_needs_fall`). Conversely, a response rising with one level up
  to a bound is carried by units at thresholds, unit `j + 1` depending on the level at need `j + 1`
  and giving the rise there (`Layers.carry`, `Layers.law_through`, `Layers.law_needsSupport`). So a
  response to one level at the step is carried by dependence alone exactly where it rises with that
  level (`carried_iff_rising`). Supplying what a level lacks of a positive amount (`supplyLaw`)
  passes by level (`supplyLaw_through`) and is carried by no family through dependence alone
  (`supply_not_carried`).
* **With a complement at a fixed total, every response is carried.** Where `d` and a condition `e`
  stand at the step at a fixed total `N` (a closed pair: `e` holds what `d` does not), unit `j`,
  depending on `d` at need `j` and on `e` at need `N - j`, is admitted exactly at `d`'s level
  (`Complement.admitted_iff`), so the units carry every response to `d`'s level
  (`Complement.carry`, `Complement.law_through`, `Complement.law_needsSupport`), supplying a deficit
  among them (`supply_carried_by_complement`).

**Reading (the AI's).** `obs` is not a second kind of relation beside the couplings of
`Becoming.Loops` and the readings of `Becoming.Observation`: it marks where a level can couple
into a formation by level, as `Web.DependsOn` marks where it can couple by threshold (a crossing
of the need), and every coupling a response forces lies within them. "Coupled by level" names this exactly; what can
couple in bounds what responds, and a law's actual responses are its couplings. The double negation of the last
equivalence is the constructive form: the converse shows that a level coupling is not left out.
Whether `obs` derives from dependence is exact at the step of the exchange: dependence alone carries
what rises with a level and nothing that falls with it, a fall being carried only through a level
that falls as it does. A complement at a fixed total, where the amount of the level goes, is such a
level, and through it every response is carried. So observing a level is depending on it and on
where its amount goes, wherever the two stand at a fixed total; where nothing holds what the level
does not, a response falling with it needs coupling by level.

What is not derived: which law the rest follows, or whether a level coupled by level is in fact
responded to (a law reading through the couplings may ignore what couples in); a crossing
passing where the formation's admission at the step is not decided (the decision is the
witness's one input, and a law that responds reads no more than it); a strength's size beyond
being positive; which responses to levels at earlier steps dependence alone carries (a crossing
passes, above, and the units at the step do not cover them); responses to several levels at once;
a complement where the total is not fixed, by loss or by exchange beyond the pair. The
representation commits to discrete steps and natural amounts. No ethical predicate, ranking or
axiom occurs.
-/

namespace Becoming

variable {F C : Type}

namespace ExchangeLaw

variable (law : ExchangeLaw F C)

/-- **The exchange responds to a level.** Across the step from `t`, `h`'s exchange with `c`
responds to the level of `d` at step `s`: two histories differing at most in that level give a
positive exchange gap. -/
def RespondsTo (t : Nat) (h : F) (c : C) (s : Nat) (d : C) : Prop :=
  ∃ l l' : Nat → C → Nat, (∀ s' e, ¬ (s' = s ∧ e = d) → l s' e = l' s' e) ∧
    0 < law.exchangeGap t h c l l'

/-- **The exchange responds to a level by level.** As `RespondsTo`, by a change of the level that
leaves `h`'s need for `d` at `s` met alike in `W`. -/
def RespondsByLevel (W : Web F C) (t : Nat) (h : F) (c : C) (s : Nat) (d : C) : Prop :=
  ∃ l l' : Nat → C → Nat, (∀ s' e, ¬ (s' = s ∧ e = d) → l s' e = l' s' e) ∧
    (W.requires s h d → (W.need s h d ≤ l s d ↔ W.need s h d ≤ l' s d)) ∧
    0 < law.exchangeGap t h c l l'

end ExchangeLaw

/-! ## A response is a coupling of every strength array -/

section Response

variable {law : ExchangeLaw F C} {t s : Nat} {h : F} {c d : C}

/-- A response by level is a response. -/
theorem ExchangeLaw.RespondsByLevel.respondsTo {W : Web F C}
    (responds : law.RespondsByLevel W t h c s d) : law.RespondsTo t h c s d :=
  let ⟨l, l', off, _, pos⟩ := responds
  ⟨l, l', off, pos⟩

/-- **Strength zero is exactly no response.** -/
theorem ExchangeLaw.respondsWithin_zero_iff :
    law.RespondsWithin t h c s d 0 ↔ ¬ law.RespondsTo t h c s d :=
  ⟨fun within ⟨l, l', off, pos⟩ =>
    Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le pos
      (Nat.le_trans (within l l' off) (Nat.le_of_eq (Nat.zero_mul _)))),
   fun none l l' off =>
    Nat.le_trans (Nat.ge_of_not_lt fun pos => none ⟨l, l', off, pos⟩)
      (Nat.le_of_eq (Nat.zero_mul _).symm)⟩

/-- **A response forces a positive strength.** Every strength of the law for a level its
exchange responds to is positive. -/
theorem ExchangeLaw.RespondsTo.strength_pos (responds : law.RespondsTo t h c s d) {k : Nat}
    (within : law.RespondsWithin t h c s d k) : 0 < k :=
  match k, within with
  | 0, within => absurd responds (ExchangeLaw.respondsWithin_zero_iff.mp within)
  | _ + 1, _ => Nat.succ_pos _

variable {cs : List C} {part : F → Bool} {present : Nat → List F}
  {k : Nat → F → C → Nat → C → Nat}

/-- **A response is a coupling of every strength array.** For every strength array of the law, a
response of a formation present outside the part, to a listed level up to the step, couples that
level into the condition in the sense of `Becoming.Loops`. -/
theorem ExchangeLaw.RespondsTo.couples
    (strengths : ∀ t h c s d, part h = false → s ≤ t → law.RespondsWithin t h c s d (k t h c s d))
    (responds : law.RespondsTo t h c s d) (mem : h ∈ present t) (out : part h = false)
    (le : s ≤ t) (listed : d ∈ cs) : Couples cs part k present d c :=
  ⟨t, h, s, mem, out, le, listed, responds.strength_pos (strengths t h c s d out le)⟩

/-- A response is a route of length one. -/
theorem ExchangeLaw.RespondsTo.upstream
    (strengths : ∀ t h c s d, part h = false → s ≤ t → law.RespondsWithin t h c s d (k t h c s d))
    (responds : law.RespondsTo t h c s d) (mem : h ∈ present t) (out : part h = false)
    (le : s ≤ t) (listed : d ∈ cs) : Upstream cs part k present d c :=
  Upstream.single (responds.couples strengths mem out le listed)

end Response

/-! ## Only what couples into a formation responds -/

section Through

variable {law : ExchangeLaw F C} {W : Web F C} {obs : F → C → Prop} {part : F → Bool}
  {t s : Nat} {h : F} {c d : C}

/-- **A level that does not couple in is coupled with strength zero.** For a law reading through
the couplings, a level that couples into a formation outside the part neither by threshold nor by
level is
coupled into its exchange with every condition, at every step, with strength zero. -/
theorem ExchangeLaw.Through.respondsWithin_uncoupled (through : law.Through W obs part)
    (out : part h = false) (uncoupled : ¬ W.CoupledInto obs h d) :
    law.RespondsWithin t h c s d 0 :=
  ExchangeLaw.respondsWithin_zero_iff.mpr fun ⟨l, l', off, pos⟩ =>
    have apart : ∀ e, W.CoupledInto obs h e → ∀ s', ¬ (s' = s ∧ e = d) := fun _ registers _ both =>
      uncoupled (both.2 ▸ registers)
    have alike := through h out t l l' fun s' _ =>
      ⟨⟨fun admits e requires =>
          (off s' e (apart e (Or.inl ⟨s', requires⟩) s')) ▸ admits e requires,
        fun admits e requires =>
          (off s' e (apart e (Or.inl ⟨s', requires⟩) s')).symm ▸ admits e requires⟩,
       fun e seen => off s' e (apart e (Or.inr seen) s')⟩
    Nat.lt_irrefl 0 ((ExchangeLaw.exchangeGap_of_alike alike c) ▸ pos)

/-- **A response comes from what couples into the formation.** -/
theorem ExchangeLaw.Through.couples_of_respondsTo (through : law.Through W obs part)
    (out : part h = false) (responds : law.RespondsTo t h c s d) : ¬ ¬ W.CoupledInto obs h d :=
  fun uncoupled =>
    ExchangeLaw.respondsWithin_zero_iff.mp (through.respondsWithin_uncoupled out uncoupled)
      responds

/-- **A response is read in every schedule covering what couples in.** -/
theorem ExchangeLaw.Through.reads_of_respondsTo {reads : Nat → F → C → Bool}
    (through : law.Through W obs part)
    (cover : ∀ t h d, part h = false → W.CoupledInto obs h d → reads t h d = true)
    (out : part h = false) (responds : law.RespondsTo t h c s d) : reads t h d = true :=
  match unread : reads t h d with
  | true => rfl
  | false => absurd responds (ExchangeLaw.respondsWithin_zero_iff.mp
      ((through.readsAt cover).respondsWithin_unread out unread c s))

/-- **A response is a route of reading.** For a law reading through the couplings and a schedule
covering it, a response of a formation present outside the part, to a listed level up to the
step, is a coupling of the routes of reading of `Becoming.Observation`. -/
theorem ExchangeLaw.Through.couples_readCouplings {reads : Nat → F → C → Bool} {cs : List C}
    {present : Nat → List F} (through : law.Through W obs part)
    (cover : ∀ t h d, part h = false → W.CoupledInto obs h d → reads t h d = true)
    (responds : law.RespondsTo t h c s d) (mem : h ∈ present t) (out : part h = false)
    (le : s ≤ t) (listed : d ∈ cs) :
    Couples cs part (readCouplings fun t h _ _ d => reads t h d) present d c :=
  ⟨t, h, s, mem, out, le, listed,
   show 0 < cond (reads t h d) 1 0 from
     (through.reads_of_respondsTo cover out responds) ▸ Nat.one_pos⟩

/-- **A response is a route of the strengths restricted to what is read.** For a law reading
through the couplings, a schedule covering it and any strength array of the law, a response of a
formation present outside the part, to a listed level up to the step, is a route of length one of
the strengths restricted to the schedule. -/
theorem ExchangeLaw.Through.upstream_restrictInto {reads : Nat → F → C → Bool} {cs : List C}
    {present : Nat → List F} {k : Nat → F → C → Nat → C → Nat} (through : law.Through W obs part)
    (cover : ∀ t h d, part h = false → W.CoupledInto obs h d → reads t h d = true)
    (strengths : ∀ t h c s d, part h = false → s ≤ t → law.RespondsWithin t h c s d (k t h c s d))
    (responds : law.RespondsTo t h c s d) (mem : h ∈ present t) (out : part h = false)
    (le : s ≤ t) (listed : d ∈ cs) :
    Upstream cs part (restrictInto (fun t h _ _ d => reads t h d) k) present d c :=
  responds.upstream ((through.readsInto cover).restrict strengths) mem out le listed

/-- Histories with equal levels at a step are alike there through the couplings. -/
theorem Web.alikeThrough_of_levels {g : F} {l l' : Nat → C → Nat} {s' : Nat}
    (same : ∀ e, l s' e = l' s' e) : W.AlikeThrough obs g l l' s' :=
  ⟨⟨fun admits e requires => (same e) ▸ admits e requires,
    fun admits e requires => (same e).symm ▸ admits e requires⟩,
   fun e _ => same e⟩

/-- **By threshold, only a crossing passes.** For a law reading through the couplings, a formation
outside the part into which a condition does not couple by level is not responded to by level: a change of that
level leaving its need met alike changes nothing it exchanges. -/
theorem ExchangeLaw.Through.not_respondsByLevel [DecidableEq C] (through : law.Through W obs part)
    (out : part h = false) (unobserved : ¬ obs h d) : ¬ law.RespondsByLevel W t h c s d :=
  fun ⟨l, l', off, threshold, pos⟩ =>
    have alike := through h out t l l' fun s' _ =>
      match Nat.decEq s' s with
      | isTrue same => by
          subst same
          exact Web.alike_of_threshold unobserved
            (fun e _ other => off _ e fun both => other both.2) threshold
      | isFalse other => Web.alikeThrough_of_levels fun e => off s' e fun both => other both.1
    Nat.lt_irrefl 0 ((ExchangeLaw.exchangeGap_of_alike alike c) ▸ pos)

end Through

/-! ## By level, the level passes -/

section Witness

variable {W : Web F C} {obs : F → C → Prop} {part : F → Bool} {d : C}

/-- **A law taking the level that couples in by level.** Each marked formation takes from every condition the
level of `d` at the step; nothing else is exchanged. -/
def levelLaw (mark : F → Bool) (d : C) : ExchangeLaw F C :=
  ⟨fun t h l _ => bif mark h then l t d else 0, fun _ _ _ _ => 0⟩

/-- **The law taking a level coupled by level reads through the couplings.** -/
theorem levelLaw_through {mark : F → Bool} (marked : ∀ h, mark h = true → obs h d) :
    (levelLaw mark d).Through W obs part :=
  fun h _ t l l' alike _ => by
    refine ⟨?_, rfl⟩
    show cond (mark h) (l t d) 0 = cond (mark h) (l' t d) 0
    cases m : mark h with
    | true => exact (alike t (Nat.le_refl t)).2 d (marked h m)
    | false => rfl

/-- Two histories: every level at `n`, and the level of `d` at `t` one higher in the second. -/
def raisedAt [DecidableEq C] (n t : Nat) (d : C) : Nat → C → Nat :=
  fun s e => if s = t ∧ e = d then n + 1 else n

/-- **The law taking a level coupled by level responds to it by level** at every step and condition,
for every marked formation. -/
theorem levelLaw_respondsByLevel [DecidableEq C] {mark : F → Bool} {h : F} (marked : mark h = true)
    (t : Nat) (c : C) : (levelLaw mark d).RespondsByLevel W t h c t d :=
  ⟨fun _ _ => W.need t h d, raisedAt (W.need t h d) t d,
   fun _ _ apart => (if_neg apart).symm,
   fun _ => ⟨fun _ => Nat.le_trans (Nat.le_succ _) (Nat.le_of_eq (if_pos ⟨rfl, rfl⟩).symm),
     fun _ => Nat.le_refl _⟩,
   have before : cond (mark h) (W.need t h d) 0 = W.need t h d :=
     congrArg (fun b => cond b (W.need t h d) 0) marked
   have after : cond (mark h) (raisedAt (W.need t h d) t d t d) 0 = W.need t h d + 1 :=
     (congrArg (fun b => cond b (raisedAt (W.need t h d) t d t d) 0) marked).trans
       (if_pos ⟨rfl, rfl⟩)
   have one : gap (W.need t h d) (W.need t h d + 1) = 1 :=
     (gap_comm _ _).trans (gap_add_self _ 1)
   Nat.lt_of_lt_of_le Nat.one_pos (Nat.le_trans
     (Nat.le_of_eq (one.symm.trans (congr (congrArg gap before) after).symm))
     (Nat.le_add_right _ (gap 0 0)))⟩

/-- **Coupling by level is exactly where a level can couple into a formation within its threshold.**
For a formation outside the part: it is not refuted that the condition couples into it by level
exactly where it is not refuted that some law reading through its couplings responds to the condition by
level. -/
theorem not_not_obs_iff_respondsByLevel [DecidableEq C] [DecidableEq F] {h : F}
    (out : part h = false) :
    ¬ ¬ obs h d ↔
      ¬ ¬ ∃ law : ExchangeLaw F C, law.Through W obs part ∧
        ∃ t c s, law.RespondsByLevel W t h c s d :=
  ⟨fun nn none => nn fun observed =>
    none ⟨levelLaw (fun h' => decide (h' = h)) d,
      levelLaw_through fun _ m => (of_decide_eq_true m) ▸ observed,
      0, d, 0, levelLaw_respondsByLevel (mark := fun h' => decide (h' = h)) (decide_eq_true rfl) 0 d⟩,
   fun nn unobserved => nn fun ⟨_, through, _, _, _, responds⟩ =>
    through.not_respondsByLevel out unobserved responds⟩

end Witness

/-! ## By threshold, a crossing passes -/

namespace ExchangeLaw

variable (law : ExchangeLaw F C)

/-- **The exchange responds to a crossing.** As `RespondsTo`, by a change of the level of `d` at
`s` across `h`'s need for it in `W`: the need is met under the first history and not under the
second. -/
def RespondsByCrossing (W : Web F C) (t : Nat) (h : F) (c : C) (s : Nat) (d : C) : Prop :=
  ∃ l l' : Nat → C → Nat, (∀ s' e, ¬ (s' = s ∧ e = d) → l s' e = l' s' e) ∧
    W.requires s h d ∧ W.need s h d ≤ l s d ∧ ¬ W.need s h d ≤ l' s d ∧
    0 < law.exchangeGap t h c l l'

end ExchangeLaw

section Crossing

variable {law : ExchangeLaw F C} {W : Web F C} {obs : F → C → Prop} {part : F → Bool}
  {t s : Nat} {h : F} {c d : C}

/-- A response by a crossing is a response. -/
theorem ExchangeLaw.RespondsByCrossing.respondsTo (responds : law.RespondsByCrossing W t h c s d) :
    law.RespondsTo t h c s d :=
  let ⟨l, l', off, _, _, _, pos⟩ := responds
  ⟨l, l', off, pos⟩

/-- **A response to a condition not coupled in by level is a crossing.** For a law reading through
the couplings and a formation outside the part into which `d` does not couple by level: wherever two histories
differing at most in the level of `d` at `s` give a positive exchange gap, the formation is not
refuted to require `d` at `s`, and the two levels do not meet its need alike. -/
theorem ExchangeLaw.Through.crosses_of_unobserved [DecidableEq C] (through : law.Through W obs part)
    (out : part h = false) (unobserved : ¬ obs h d) {l l' : Nat → C → Nat}
    (off : ∀ s' e, ¬ (s' = s ∧ e = d) → l s' e = l' s' e) (pos : 0 < law.exchangeGap t h c l l') :
    ¬ ¬ W.requires s h d ∧ ¬ (W.need s h d ≤ l s d ↔ W.need s h d ≤ l' s d) :=
  ⟨fun none => through.not_respondsByLevel out unobserved
      ⟨l, l', off, fun requires => absurd requires none, pos⟩,
   fun alike => through.not_respondsByLevel out unobserved ⟨l, l', off, fun _ => alike, pos⟩⟩

/-- Two numbers below the same bound compare alike with it. -/
theorem ble_eq_of_iff {a b b' : Nat} (iff : a ≤ b ↔ a ≤ b') : Nat.ble a b = Nat.ble a b' :=
  match hb : Nat.ble a b, hb' : Nat.ble a b' with
  | true, true => rfl
  | false, false => rfl
  | true, false =>
    Bool.noConfusion ((Nat.ble_eq_true_of_le (iff.mp (Nat.le_of_ble_eq_true hb))).symm.trans hb')
  | false, true =>
    Bool.noConfusion ((Nat.ble_eq_true_of_le (iff.mpr (Nat.le_of_ble_eq_true hb'))).symm.trans hb)

/-- Where a formation requires at a step exactly the one condition `d`, the levels admit it
exactly where they meet its need for `d`. -/
theorem Web.admits_iff_of_sole {l : C → Nat} {t : Nat} (sole : ∀ e, W.requires t h e ↔ e = d) :
    W.Admits l t h ↔ W.need t h d ≤ l d :=
  ⟨fun admits => admits d ((sole d).mpr rfl),
   fun met e requires => ((sole e).mp requires) ▸ met⟩

/-- **A law taking a crossing of the need.** Each marked formation takes, across the step from
`T` only, one unit from every condition where the level of `d` at `T` meets its need, and nothing
otherwise; nothing else is exchanged. -/
def thresholdLaw (W : Web F C) (mark : F → Bool) (d : C) (T : Nat) : ExchangeLaw F C :=
  ⟨fun t h l _ => bif mark h then
      (bif Nat.beq t T then (bif Nat.ble (W.need t h d) (l t d) then 1 else 0) else 0) else 0,
   fun _ _ _ _ => 0⟩

/-- **The law taking a crossing reads through the couplings** where every marked formation
requires at `T` exactly the one condition `d`. -/
theorem thresholdLaw_through {mark : F → Bool} {T : Nat}
    (sole : ∀ h, mark h = true → ∀ e, W.requires T h e ↔ e = d) :
    (thresholdLaw W mark d T).Through W obs part :=
  fun h _ t l l' alike _ => by
    refine ⟨?_, rfl⟩
    show cond (mark h) (cond (Nat.beq t T) (cond (Nat.ble (W.need t h d) (l t d)) 1 0) 0) 0 =
      cond (mark h) (cond (Nat.beq t T) (cond (Nat.ble (W.need t h d) (l' t d)) 1 0) 0) 0
    cases m : mark h with
    | false => rfl
    | true =>
      cases q : Nat.beq t T with
      | false => rfl
      | true =>
        have same : t = T := Nat.eq_of_beq_eq_true q
        subst same
        have admits := (alike t (Nat.le_refl t)).1
        have iff : W.need t h d ≤ l t d ↔ W.need t h d ≤ l' t d :=
          ⟨fun met => (Web.admits_iff_of_sole (sole h m)).mp
              (admits.mp ((Web.admits_iff_of_sole (sole h m)).mpr met)),
           fun met => (Web.admits_iff_of_sole (sole h m)).mp
              (admits.mpr ((Web.admits_iff_of_sole (sole h m)).mpr met))⟩
        exact congrArg (fun b => cond b 1 0) (ble_eq_of_iff iff)

/-- The levels at the need, and the level of `d` at `t` lowered to nothing in the second. -/
def loweredAt [DecidableEq C] (n t : Nat) (d : C) : Nat → C → Nat :=
  fun s e => if s = t ∧ e = d then 0 else n

/-- **The law taking a crossing responds to it** at every condition, for every marked formation
requiring `d` at `t` with a positive need. -/
theorem thresholdLaw_respondsByCrossing [DecidableEq C] {mark : F → Bool} (marked : mark h = true)
    (requires : W.requires t h d) (positive : 0 < W.need t h d) (c : C) :
    (thresholdLaw W mark d t).RespondsByCrossing W t h c t d :=
  have unmet : ¬ W.need t h d ≤ loweredAt (W.need t h d) t d t d := fun le =>
    Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le positive (Nat.le_trans le (Nat.le_of_eq (if_pos ⟨rfl, rfl⟩))))
  have below : Nat.ble (W.need t h d) (loweredAt (W.need t h d) t d t d) = false :=
    match hb : Nat.ble (W.need t h d) (loweredAt (W.need t h d) t d t d) with
    | true => absurd (Nat.le_of_ble_eq_true hb) unmet
    | false => rfl
  have before : cond (mark h)
      (cond (Nat.beq t t) (cond (Nat.ble (W.need t h d) (W.need t h d)) 1 0) 0) 0 = 1 :=
    (congrArg (fun b => cond b
      (cond (Nat.beq t t) (cond (Nat.ble (W.need t h d) (W.need t h d)) 1 0) 0) 0) marked).trans
      ((congrArg (fun b => cond b (cond (Nat.ble (W.need t h d) (W.need t h d)) 1 0) 0)
        (beq_self t)).trans
        (congrArg (fun b => cond b 1 0) (Nat.ble_eq_true_of_le (Nat.le_refl _))))
  have after : cond (mark h) (cond (Nat.beq t t)
      (cond (Nat.ble (W.need t h d) (loweredAt (W.need t h d) t d t d)) 1 0) 0) 0 = 0 :=
    (congrArg (fun b => cond b (cond (Nat.beq t t)
      (cond (Nat.ble (W.need t h d) (loweredAt (W.need t h d) t d t d)) 1 0) 0) 0) marked).trans
      ((congrArg (fun b => cond b
        (cond (Nat.ble (W.need t h d) (loweredAt (W.need t h d) t d t d)) 1 0) 0) (beq_self t)).trans
        (congrArg (fun b => cond b 1 0) below))
  ⟨fun _ _ => W.need t h d, loweredAt (W.need t h d) t d,
   fun _ _ apart => (if_neg apart).symm, requires, Nat.le_refl _, unmet,
   Nat.lt_of_lt_of_le Nat.one_pos (Nat.le_trans
     (Nat.le_of_eq ((gap_zero 1).symm.trans (congr (congrArg gap before) after).symm))
     (Nat.le_add_right _ (gap 0 0)))⟩

/-- **By threshold, a crossing passes.** For a formation outside the part requiring at `t`
exactly the one condition `d`, with a positive need: some law reading through its couplings
responds to a crossing of its need at `t`, at every condition. Conversely, where `d` does not
couple into the formation by level, a response of any law reading through the couplings to `d` is a crossing
(`ExchangeLaw.Through.crosses_of_unobserved`). -/
theorem crossing_passes [DecidableEq C] [DecidableEq F]
    (sole : ∀ e, W.requires t h e ↔ e = d) (positive : 0 < W.need t h d) :
    ∃ law : ExchangeLaw F C, law.Through W obs part ∧ ∀ c, law.RespondsByCrossing W t h c t d :=
  ⟨thresholdLaw W (fun h' => decide (h' = h)) d t,
   thresholdLaw_through fun _ m => (of_decide_eq_true m) ▸ sole,
   fun c => thresholdLaw_respondsByCrossing (mark := fun h' => decide (h' = h))
     (decide_eq_true rfl) ((sole d).mpr rfl) positive c⟩

end Crossing

/-! ## A crossing among several conditions -/

section Gate

variable {law : ExchangeLaw F C} {W : Web F C} {obs : F → C → Prop} {part : F → Bool}
  {t s : Nat} {h : F} {c d : C}

/-- **A response to a condition not coupled in by level changes admission.** For a law reading through
the couplings and a formation outside the part into which `d` does not couple by level: wherever two histories
differing at most in the level of `d` at `s` give a positive exchange gap, `s` is at most the
step of the exchange, and the two histories do not admit the formation alike at `s`. -/
theorem ExchangeLaw.Through.admission_changes_of_unobserved (through : law.Through W obs part)
    (out : part h = false) (unobserved : ¬ obs h d) {l l' : Nat → C → Nat}
    (off : ∀ s' e, ¬ (s' = s ∧ e = d) → l s' e = l' s' e) (pos : 0 < law.exchangeGap t h c l l') :
    s ≤ t ∧ ¬ (W.Admits (l s) s h ↔ W.Admits (l' s) s h) :=
  have none : (s ≤ t → (W.Admits (l s) s h ↔ W.Admits (l' s) s h)) → False := fun iff =>
    have alike := through h out t l l' fun s' le =>
      match Nat.decEq s' s with
      | isTrue same => by
          subst same
          exact ⟨iff le, fun e seen => off _ e fun both => unobserved (both.2 ▸ seen)⟩
      | isFalse other => Web.alikeThrough_of_levels fun e => off s' e fun both => other both.1
    Nat.lt_irrefl 0 ((ExchangeLaw.exchangeGap_of_alike alike c) ▸ pos)
  ⟨match Nat.decLe s t with
    | isTrue le => le
    | isFalse late => (none fun le => absurd le late).elim,
   fun iff => none fun _ => iff⟩

/-- **A crossing passes only where the other requirements are met.** Under the same conditions,
it is not refuted that every other condition the formation requires at `s` meets its need there
under the first history, and so under the second: a response to `d` alone changes admission only
where the rest of the conjunction holds. -/
theorem ExchangeLaw.Through.others_met_of_unobserved (through : law.Through W obs part)
    (out : part h = false) (unobserved : ¬ obs h d) {l l' : Nat → C → Nat}
    (off : ∀ s' e, ¬ (s' = s ∧ e = d) → l s' e = l' s' e) (pos : 0 < law.exchangeGap t h c l l') :
    ¬ ¬ ∀ e, W.requires s h e → ¬ e = d → W.need s h e ≤ l s e :=
  fun unmet => (through.admission_changes_of_unobserved out unobserved off pos).2
    ⟨fun admits => absurd (fun e requires _ => admits e requires) unmet,
     fun admits => absurd (fun e requires other => Nat.le_trans (admits e requires)
       (Nat.le_of_eq (off s e fun both => other both.2).symm)) unmet⟩

/-- **A response by a crossing needs a positive requirement.** The formation requires the
condition at the step of the level, with a positive need. -/
theorem ExchangeLaw.RespondsByCrossing.requires_pos (responds : law.RespondsByCrossing W t h c s d) :
    W.requires s h d ∧ 0 < W.need s h d :=
  let ⟨_, l', _, requires, _, unmet, _⟩ := responds
  ⟨requires, Nat.lt_of_le_of_lt (Nat.zero_le (l' s d)) (Nat.gt_of_not_le unmet)⟩

/-- Two decided propositions that are equivalent are decided alike. -/
theorem decide_eq_of_iff {p q : Prop} (dp : Decidable p) (dq : Decidable q) (iff : p ↔ q) :
    @decide p dp = @decide q dq :=
  match dp, dq with
  | isTrue _, isTrue _ => rfl
  | isFalse _, isFalse _ => rfl
  | isTrue yes, isFalse no => absurd (iff.mp yes) no
  | isFalse no, isTrue yes => absurd (iff.mpr yes) no

/-- **A law taking a decided admission.** The formation `g` takes, across every step from `T`
on, one unit from every condition where the levels at `T` admit it, and nothing otherwise;
nothing else is exchanged. Its only input is the decision of `g`'s admission at `T`. -/
def admissionLaw [DecidableEq F] (W : Web F C) (g : F) (T : Nat)
    (dec : ∀ l : C → Nat, Decidable (W.Admits l T g)) : ExchangeLaw F C :=
  ⟨fun t h l _ => bif decide (h = g) then
      (bif Nat.ble T t then (bif @decide _ (dec (l T)) then 1 else 0) else 0) else 0,
   fun _ _ _ _ => 0⟩

/-- **The law taking a decided admission reads through the couplings.** -/
theorem admissionLaw_through [DecidableEq F] {g : F} {T : Nat}
    (dec : ∀ l : C → Nat, Decidable (W.Admits l T g)) :
    (admissionLaw W g T dec).Through W obs part :=
  fun h _ t l l' alike _ => by
    refine ⟨?_, rfl⟩
    show cond (decide (h = g)) (cond (Nat.ble T t) (cond (@decide _ (dec (l T))) 1 0) 0) 0 =
      cond (decide (h = g)) (cond (Nat.ble T t) (cond (@decide _ (dec (l' T))) 1 0) 0) 0
    cases m : decide (h = g) with
    | false => rfl
    | true =>
      cases q : Nat.ble T t with
      | false => rfl
      | true =>
        have same : h = g := of_decide_eq_true m
        subst same
        exact congrArg (fun b => cond b 1 0)
          (decide_eq_of_iff (dec (l T)) (dec (l' T)) (alike T (Nat.le_of_ble_eq_true q)).1)

/-- The levels at each need of `g`, and the level of `d` at `T` lowered to nothing in the
second. -/
def needLoweredAt [DecidableEq C] (W : Web F C) (g : F) (T : Nat) (d : C) : Nat → C → Nat :=
  fun s e => if s = T ∧ e = d then 0 else W.need s g e

/-- **The law taking a decided admission responds to a crossing** of every condition `g`
requires at `T` with a positive need, across every step from `T` on, at every condition. -/
theorem admissionLaw_respondsByCrossing [DecidableEq C] [DecidableEq F] {g : F} {T : Nat}
    (dec : ∀ l : C → Nat, Decidable (W.Admits l T g)) (requires : W.requires T g d)
    (positive : 0 < W.need T g d) (late : T ≤ t) (c : C) :
    (admissionLaw W g T dec).RespondsByCrossing W t g c T d :=
  have unmet : ¬ W.need T g d ≤ needLoweredAt W g T d T d := fun le =>
    Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le positive (Nat.le_trans le (Nat.le_of_eq (if_pos ⟨rfl, rfl⟩))))
  have admitted : W.Admits (fun e => W.need T g e) T g := fun _ _ => Nat.le_refl _
  have refused : ¬ W.Admits (needLoweredAt W g T d T) T g := fun admits => unmet (admits d requires)
  have before : (admissionLaw W g T dec).take t g (fun s e => W.need s g e) c = 1 := by
    show cond (decide (g = g))
      (cond (Nat.ble T t) (cond (@decide _ (dec (fun e => W.need T g e))) 1 0) 0) 0 = 1
    cases m : decide (g = g) with
    | false => exact absurd rfl (of_decide_eq_false m)
    | true =>
      cases q : Nat.ble T t with
      | false => exact Bool.noConfusion ((Nat.ble_eq_true_of_le late).symm.trans q)
      | true =>
        cases r : @decide _ (dec (fun e => W.need T g e)) with
        | false => exact absurd admitted (of_decide_eq_false r)
        | true => rfl
  have after : (admissionLaw W g T dec).take t g (needLoweredAt W g T d) c = 0 := by
    show cond (decide (g = g))
      (cond (Nat.ble T t) (cond (@decide _ (dec (needLoweredAt W g T d T))) 1 0) 0) 0 = 0
    cases m : decide (g = g) with
    | false => rfl
    | true =>
      cases q : Nat.ble T t with
      | false => rfl
      | true =>
        cases r : @decide _ (dec (needLoweredAt W g T d T)) with
        | false => rfl
        | true => exact absurd (of_decide_eq_true r) refused
  ⟨fun s e => W.need s g e, needLoweredAt W g T d,
   fun _ _ apart => (if_neg apart).symm, requires, Nat.le_refl _, unmet,
   Nat.lt_of_lt_of_le Nat.one_pos (Nat.le_trans
     (Nat.le_of_eq ((gap_zero 1).symm.trans (congr (congrArg gap before) after).symm))
     (Nat.le_add_right _ (gap 0 0)))⟩

/-- **Among several conditions, a crossing passes exactly where it is required.** For a
formation whose admission at `T` is decided: some law reading through the couplings responds to a
crossing of the level of `d` at `T`, across every step from `T` on and at every condition, exactly
where the formation requires `d` at `T` with a positive need. -/
theorem crossing_passes_iff [DecidableEq C] [DecidableEq F] {g : F} {T : Nat}
    (dec : ∀ l : C → Nat, Decidable (W.Admits l T g)) :
    (W.requires T g d ∧ 0 < W.need T g d) ↔
      ∃ law : ExchangeLaw F C, law.Through W obs part ∧
        ∀ t, T ≤ t → ∀ c, law.RespondsByCrossing W t g c T d :=
  ⟨fun ⟨requires, positive⟩ => ⟨admissionLaw W g T dec, admissionLaw_through dec,
     fun _ late c => admissionLaw_respondsByCrossing dec requires positive late c⟩,
   fun ⟨_, _, responds⟩ => (responds T (Nat.le_refl T) d).requires_pos⟩

/-- Whether levels meet a formation's need at a step for every listed condition, decided by going
through the list. -/
def metAllDec (W : Web F C) (T : Nat) (g : F) (l : C → Nat) :
    (es : List C) → Decidable (∀ e, List.Mem e es → W.need T g e ≤ l e)
  | [] => isTrue fun _ mem => nomatch mem
  | a :: es =>
    match Nat.decLe (W.need T g a) (l a), metAllDec W T g l es with
    | isTrue met, isTrue rest => isTrue fun e mem => match e, mem with
      | _, .head _ => met
      | e, .tail _ mem => rest e mem
    | isFalse unmet, _ => isFalse fun all => unmet (all a (.head _))
    | isTrue _, isFalse unmet => isFalse fun all => unmet fun e mem => all e (.tail _ mem)

/-- **A listed support decides admission.** Where the conditions a formation requires at a step
are exactly those of a list, whether levels admit it there is decided. -/
def admitsDecidableOfSupport {g : F} {T : Nat} (es : List C)
    (support : ∀ e, W.requires T g e ↔ List.Mem e es) (l : C → Nat) : Decidable (W.Admits l T g) :=
  match metAllDec W T g l es with
  | isTrue all => isTrue fun e requires => all e ((support e).mp requires)
  | isFalse unmet => isFalse fun admits => unmet fun e mem => admits e ((support e).mpr mem)

/-- **With a listed support, a crossing passes exactly where it is required.** -/
theorem crossing_passes_of_support [DecidableEq C] [DecidableEq F] {g : F} {T : Nat} (es : List C)
    (support : ∀ e, W.requires T g e ↔ List.Mem e es) :
    (W.requires T g d ∧ 0 < W.need T g d) ↔
      ∃ law : ExchangeLaw F C, law.Through W obs part ∧
        ∀ t, T ≤ t → ∀ c, law.RespondsByCrossing W t g c T d :=
  crossing_passes_iff (admitsDecidableOfSupport es support)

end Gate

/-! ## What dependence alone carries of a level

Coupling by threshold alone is `thresholdOnly`: no level couples into any formation by level. A law
reading through it gives a formation alike wherever the levels admit it alike at every step so far.
This section states exactly what such laws carry of a level at the step of the exchange: what rises
with it, and, read with a complement at a fixed total, everything. -/

section Carried

variable {law : ExchangeLaw F C} {W : Web F C} {part : F → Bool} {t : Nat} {h : F}

/-- **Under the law, `h`'s exchange at `t` needs support**: under every history whose levels at `t`
do not admit `h`, `h` takes nothing and gives nothing across the step from `t`. Activity needing
support (`Web.Dependent`), read off the law at one step, as the reading of requirement as response
gives it (`ExchangeRelation.readWeb_dependent`). -/
def ExchangeLaw.NeedsSupportAt (law : ExchangeLaw F C) (W : Web F C) (t : Nat) (h : F) : Prop :=
  ∀ l : Nat → C → Nat, ¬ W.Admits (l t) t h → ∀ c, law.take t h l c = 0 ∧ law.give t h l c = 0

/-- `l'` stands no lower than `l` at `t`, the two alike before `t`. -/
def NoLowerAt (t : Nat) (l l' : Nat → C → Nat) : Prop :=
  (∀ s, s < t → ∀ e, l s e = l' s e) ∧ ∀ e, l t e ≤ l' t e

/-- **Through dependence alone, a response rises with the levels at its step.** For a law reading
through dependence alone, under which a formation outside the part exchanges across the step from
`t` only where it is supported: where the levels at `t` stand no lower, the history before alike, it
takes from and gives to every condition no less. -/
theorem ExchangeLaw.Through.rises_at_step (through : law.Through W thresholdOnly part)
    (out : part h = false) (needs : law.NeedsSupportAt W t h) {l l' : Nat → C → Nat}
    (noLower : NoLowerAt t l l') (c : C) :
    law.take t h l c ≤ law.take t h l' c ∧ law.give t h l c ≤ law.give t h l' c :=
  Decidable.of_not_not fun no =>
    (fun em : ¬ ¬ (W.Admits (l t) t h ∨ ¬ W.Admits (l t) t h) => em fun decided =>
      match decided with
      | .inl admitted =>
        have alike := through h out t l l' fun s le =>
          match Nat.lt_or_eq_of_le le with
          | .inl before => Web.alikeThrough_of_levels (noLower.1 s before)
          | .inr same => Eq.subst (motive := fun x => W.AlikeThrough thresholdOnly h l l' x)
              same.symm
              ⟨⟨fun _ => Web.Admits.mono noLower.2 admitted, fun _ => admitted⟩,
               fun _ never => False.elim never⟩
        no ⟨Nat.le_of_eq (alike c).1, Nat.le_of_eq (alike c).2⟩
      | .inr unadmitted =>
        no ⟨Nat.le_trans (Nat.le_of_eq (needs l unadmitted c).1) (Nat.zero_le _),
            Nat.le_trans (Nat.le_of_eq (needs l unadmitted c).2) (Nat.zero_le _)⟩)
    fun n => n (.inr fun a => n (.inl a))

/-- A family of formations carries a response of giving into `c` at `t` over the histories
`within`: under each of them, what its members give to `c` across the step from `t` totals the
response. -/
def ExchangeLaw.CarriesGiving (law : ExchangeLaw F C) (us : List F) (t : Nat) (c : C)
    (within : (Nat → C → Nat) → Prop) (response : (Nat → C → Nat) → Nat) : Prop :=
  ∀ l, within l → total us (fun u => law.give t u l c) = response l

/-- **What dependence alone carries rises.** A response carried by a family of formations outside
the part, each exchanging only where supported, under a law reading through dependence alone, is no
lower where the levels at the step stand no lower. -/
theorem ExchangeLaw.Through.carried_rises (through : law.Through W thresholdOnly part)
    {us : List F} (out : ∀ u, u ∈ us → part u = false)
    (needs : ∀ u, u ∈ us → law.NeedsSupportAt W t u) {c : C}
    {within : (Nat → C → Nat) → Prop} {response : (Nat → C → Nat) → Nat}
    (carries : law.CarriesGiving us t c within response) {l l' : Nat → C → Nat}
    (inside : within l) (inside' : within l') (noLower : NoLowerAt t l l') :
    response l ≤ response l' :=
  Nat.le_trans (Nat.le_of_eq (carries l inside).symm)
    (Nat.le_trans
      (total_le us fun u mem => (through.rises_at_step (out u mem) (needs u mem) noLower c).2)
      (Nat.le_of_eq (carries l' inside')))

/-- **Through dependence alone, a response falls only where a level falls.** Where a family carried
as in `carried_rises` gives less under one history than under another alike before the step, some
condition stands lower at the step under the first: what supplies a fall of one level reads, by
threshold, a level that falls with it. -/
theorem ExchangeLaw.Through.carried_fall_needs_fall (through : law.Through W thresholdOnly part)
    {us : List F} (out : ∀ u, u ∈ us → part u = false)
    (needs : ∀ u, u ∈ us → law.NeedsSupportAt W t u) {c : C}
    {within : (Nat → C → Nat) → Prop} {response : (Nat → C → Nat) → Nat}
    (carries : law.CarriesGiving us t c within response) {l l' : Nat → C → Nat}
    (inside : within l) (inside' : within l') (before : ∀ s, s < t → ∀ e, l s e = l' s e)
    (falls : response l' < response l) : ¬ ∀ e, l t e ≤ l' t e :=
  fun noLower => Nat.not_le_of_gt falls
    (through.carried_rises out needs carries inside inside' ⟨before, noLower⟩)

end Carried

/-! ## Totals over the first steps -/

section Totals

/-- Where a quantity is nothing at each of the first `n` numbers, its total over them is nothing. -/
theorem total_steps_nothing {q : Nat → Nat} :
    ∀ n, (∀ j, j < n → q j = 0) → total (steps 0 n) q = 0
  | 0, _ => rfl
  | n + 1, nothing =>
    (total_steps_add q 0 n 1).trans
      ((congrArg (· + (q (0 + n) + 0)) (total_steps_nothing n fun j lt =>
          nothing j (Nat.lt_trans lt (Nat.lt_succ_self n)))).trans
        ((congrArg (fun k => 0 + (q k + 0)) (Nat.zero_add n)).trans
          (congrArg (fun k => 0 + (k + 0)) (nothing n (Nat.lt_succ_self n)))))

/-- Where a quantity is nothing at each of the first `n` numbers but `x`, one of them, its total over
them is its value at `x`. -/
theorem total_steps_only {q : Nat → Nat} {x : Nat} :
    ∀ n, (∀ j, j < n → j ≠ x → q j = 0) → x < n → total (steps 0 n) q = q x
  | 0, _, lt => absurd lt (Nat.not_lt_zero x)
  | n + 1, others, lt =>
    have last : total (steps 0 (n + 1)) q = total (steps 0 n) q + q n :=
      (total_steps_add q 0 n 1).trans
        (congrArg (fun k => total (steps 0 n) q + (q k + 0)) (Nat.zero_add n))
    match Nat.decLt x n with
    | isTrue before =>
      last.trans ((congrArg (· + q n) (total_steps_only n (fun j lt' => others j
          (Nat.lt_trans lt' (Nat.lt_succ_self n))) before)).trans
        (congrArg (q x + ·) (others n (Nat.lt_succ_self n)
          fun same => Nat.lt_irrefl n (Eq.subst (motive := fun k => k < n) same.symm before))))
    | isFalse notBefore =>
      have same : x = n := Nat.le_antisymm (Nat.le_of_lt_succ lt) (Nat.ge_of_not_lt notBefore)
      last.trans ((congrArg (· + q n) (total_steps_nothing n fun j lt' => others j
          (Nat.lt_trans lt' (Nat.lt_succ_self n))
          fun is => Nat.lt_irrefl n (Eq.subst (motive := fun k => k < n) (is.trans same) lt'))).trans
        ((Nat.zero_add (q n)).trans (congrArg q same.symm)))

end Totals

/-! ## A rising response, carried by units at thresholds -/

namespace Layers

variable {d : C}

/-- The web of the units of a response to the level of `d`: unit `j + 1` requires `d` at need
`j + 1` at every step; unit `0` requires nothing. -/
def web (d : C) : Web Nat C :=
  ⟨fun _ _ => 0, fun _ _ => True, fun _ j c => 0 < j ∧ c = d, fun _ j _ => j, fun _ _ _ => False⟩

/-- The units of a response `r` to the level of `d`, `r x c` being what the response gives `c` where
`d` stands at `x`: unit `0` gives `r 0`, and unit `j + 1`, where `d` stands at `j + 1` or more, gives
the rise `r (j + 1) - r j`. Nothing is taken. -/
def law (d : C) (r : Nat → C → Nat) : ExchangeLaw Nat C :=
  ⟨fun _ _ _ _ => 0, fun t j l c => match j with
    | 0 => r 0 c
    | j + 1 => bif Nat.ble (j + 1) (l t d) then r (j + 1) c - r j c else 0⟩

/-- Unit `j + 1` is admitted exactly where `d` stands at `j + 1` or more. -/
theorem admits_iff {l : C → Nat} {t j : Nat} : (web d).Admits l t (j + 1) ↔ j + 1 ≤ l d :=
  ⟨fun admits => admits d ⟨Nat.succ_pos j, rfl⟩,
   fun le _ required => Eq.subst (motive := fun x => j + 1 ≤ l x) required.2.symm le⟩

/-- **The units read through dependence alone.** -/
theorem law_through (r : Nat → C → Nat) (part : Nat → Bool) :
    (law d r).Through (web d) thresholdOnly part :=
  fun j _ t _ _ alike c => ⟨rfl, match j, alike with
    | 0, _ => rfl
    | j + 1, alike => congrArg (fun b => cond b (r (j + 1) c - r j c) 0)
        (ble_eq_of_iff (admits_iff.symm.trans ((alike t (Nat.le_refl t)).1.trans admits_iff)))⟩

/-- **Each unit exchanges only where supported.** -/
theorem law_needsSupport (r : Nat → C → Nat) (t j : Nat) : (law d r).NeedsSupportAt (web d) t j :=
  fun l unadmitted c => ⟨rfl, match j, unadmitted with
    | 0, unadmitted => absurd (fun _ required => absurd required.1 (Nat.lt_irrefl 0)) unadmitted
    | j + 1, unadmitted =>
      have unmet : Nat.ble (j + 1) (l t d) = false :=
        match met : Nat.ble (j + 1) (l t d) with
        | true => absurd (admits_iff.mpr (Nat.le_of_ble_eq_true met)) unadmitted
        | false => rfl
      congrArg (fun b => cond b (r (j + 1) c - r j c) 0) unmet⟩

/-- Each unit at a threshold couples into the condition by threshold. -/
theorem dependsOn (j : Nat) : (web d).DependsOn (j + 1) d :=
  ⟨0, Nat.succ_pos j, rfl⟩

/-- The rises below a level, from what the response gives at nothing, add up to what it gives at
that level. -/
theorem rises_add {q : Nat → Nat} {x : Nat} :
    ∀ n, n ≤ x → (∀ i, i < n → q i ≤ q (i + 1)) →
      q 0 + total (steps 0 n) (fun i => cond (Nat.ble (i + 1) x) (q (i + 1) - q i) 0) = q n
  | 0, _, _ => rfl
  | n + 1, le, rising =>
    have step : cond (Nat.ble (n + 1) x) (q (n + 1) - q n) 0 = q (n + 1) - q n :=
      congrArg (fun b => cond b (q (n + 1) - q n) 0) (Nat.ble_eq_true_of_le le)
    (congrArg (q 0 + ·) ((total_steps_add _ 0 n 1).trans
        (congrArg (fun k => total (steps 0 n)
            (fun i => cond (Nat.ble (i + 1) x) (q (i + 1) - q i) 0) +
            (cond (Nat.ble (k + 1) x) (q (k + 1) - q k) 0 + 0)) (Nat.zero_add n)))).trans
      ((Nat.add_assoc _ _ _).symm.trans
        ((congrArg (· + (cond (Nat.ble (n + 1) x) (q (n + 1) - q n) 0 + 0))
            (rises_add n (Nat.le_trans (Nat.le_succ n) le) fun i lt =>
              rising i (Nat.lt_trans lt (Nat.lt_succ_self n)))).trans
          ((congrArg (q n + ·) ((Nat.add_zero _).trans step)).trans
            (Naturals.add_sub_of_le (rising n (Nat.lt_succ_self n))))))

/-- Above the level, no rise is added. -/
theorem rises_stop {q : Nat → Nat} {x : Nat} :
    ∀ k, total (steps 0 (x + k)) (fun i => cond (Nat.ble (i + 1) x) (q (i + 1) - q i) 0) =
      total (steps 0 x) (fun i => cond (Nat.ble (i + 1) x) (q (i + 1) - q i) 0)
  | 0 => rfl
  | k + 1 =>
    have above : Nat.ble (x + k + 1) x = false :=
      match met : Nat.ble (x + k + 1) x with
      | true => absurd (Nat.le_of_ble_eq_true met)
          (Nat.not_le_of_gt (Nat.lt_of_le_of_lt (Nat.le_add_right x k) (Nat.lt_succ_self _)))
      | false => rfl
    (total_steps_add _ 0 (x + k) 1).trans
      ((congrArg (fun m => total (steps 0 (x + k))
          (fun i => cond (Nat.ble (i + 1) x) (q (i + 1) - q i) 0) +
          (cond (Nat.ble (m + 1) x) (q (m + 1) - q m) 0 + 0)) (Nat.zero_add (x + k))).trans
        ((congrArg (fun b => total (steps 0 (x + k))
            (fun i => cond (Nat.ble (i + 1) x) (q (i + 1) - q i) 0) +
            (cond b (q (x + k + 1) - q (x + k)) 0 + 0)) above).trans
          (rises_stop k)))

/-- **A rising response is carried by units at thresholds.** Where what a response gives `c` rises
with the level of `d` up to a bound, its units, one at each threshold below the bound, give `c` in
total what it gives at every level of `d` up to the bound. -/
theorem carry {r : Nat → C → Nat} {c : C} {N : Nat} (rising : ∀ x, x < N → r x c ≤ r (x + 1) c)
    (t : Nat) : (law d r).CarriesGiving (steps 0 (N + 1)) t c (fun l => l t d ≤ N)
      (fun l => r (l t d) c) :=
  fun l within =>
    have shifted : total (steps 1 N) (fun j => (law d r).give t j l c) =
        total (steps 0 N) (fun i => cond (Nat.ble (i + 1) (l t d)) (r (i + 1) c - r i c) 0) :=
      total_steps_succ (fun j => (law d r).give t j l c) 0 N
    have stops : total (steps 0 N)
          (fun i => cond (Nat.ble (i + 1) (l t d)) (r (i + 1) c - r i c) 0) =
        total (steps 0 (l t d))
          (fun i => cond (Nat.ble (i + 1) (l t d)) (r (i + 1) c - r i c) 0) :=
      (congrArg (fun m => total (steps 0 m)
          (fun i => cond (Nat.ble (i + 1) (l t d)) (r (i + 1) c - r i c) 0))
          (Naturals.add_sub_of_le within).symm).trans
        (rises_stop (q := fun i => r i c) (x := l t d) (N - l t d))
    (congrArg (r 0 c + ·) (shifted.trans stops)).trans
      (rises_add (q := fun x => r x c) (l t d) (Nat.le_refl _) fun i lt =>
        rising i (Nat.lt_of_lt_of_le lt within))

end Layers

/-! ## Exactly what dependence alone carries of one level -/

section Exactly

variable [DecidableEq C]

/-- The history standing at `x` at `d` at the step `t`, and at nothing elsewhere. -/
def onlyAt (t : Nat) (d : C) (x : Nat) : Nat → C → Nat :=
  fun s e => if s = t ∧ e = d then x else 0

theorem onlyAt_self (t : Nat) (d : C) (x : Nat) : onlyAt t d x t d = x :=
  if_pos ⟨rfl, rfl⟩

/-- Standing higher at `d` at the step alone stands no lower there. -/
theorem onlyAt_noLower (t : Nat) (d : C) (x : Nat) : NoLowerAt t (onlyAt t d x) (onlyAt t d (x + 1)) :=
  ⟨fun s before e =>
    have other : ¬ (s = t ∧ e = d) := fun both => Nat.lt_irrefl t (Eq.subst (motive := (· < t)) both.1 before)
    (if_neg other).trans (if_neg other).symm,
   fun e => match decEq e d with
    | isTrue same => Nat.le_trans (Nat.le_of_eq (if_pos ⟨rfl, same⟩))
        (Nat.le_trans (Nat.le_succ x) (Nat.le_of_eq (if_pos ⟨rfl, same⟩).symm))
    | isFalse other => Nat.le_of_eq ((if_neg fun both => other both.2).trans
        (if_neg fun both => other both.2).symm)⟩

/-- **Dependence alone carries of a level exactly what rises with it.** A response giving `c` an
amount fixed by the level of `d` at the step, up to a bound, is carried by some family of formations
each exchanging only where supported, under a law reading through dependence alone, exactly where it
rises with that level up to the bound. -/
theorem carried_iff_rising (d c : C) (r : Nat → Nat) (t N : Nat) :
    (∃ (law : ExchangeLaw Nat C) (W : Web Nat C) (us : List Nat),
        law.Through W thresholdOnly (fun _ => false) ∧
        (∀ u, u ∈ us → law.NeedsSupportAt W t u) ∧
        law.CarriesGiving us t c (fun l => l t d ≤ N) (fun l => r (l t d))) ↔
      ∀ x, x < N → r x ≤ r (x + 1) :=
  ⟨fun ⟨_, _, _, through, needs, carries⟩ x lt =>
    have rises := through.carried_rises (fun _ _ => rfl) needs carries
      (Nat.le_trans (Nat.le_of_eq (onlyAt_self t d x)) (Nat.le_of_lt lt))
      (Nat.le_trans (Nat.le_of_eq (onlyAt_self t d (x + 1))) lt) (onlyAt_noLower t d x)
    Nat.le_trans (Nat.le_of_eq (congrArg r (onlyAt_self t d x)).symm)
      (Nat.le_trans rises (Nat.le_of_eq (congrArg r (onlyAt_self t d (x + 1))))),
   fun rising => ⟨Layers.law d fun x _ => r x, Layers.web d, steps 0 (N + 1),
     Layers.law_through _ _, fun u _ => Layers.law_needsSupport _ t u,
     Layers.carry (r := fun x _ => r x) rising t⟩⟩

end Exactly

/-! ## With a complement at a fixed total, every response is carried -/

/-- Booleans true alike are equal. -/
theorem eq_of_true_iff {p q : Bool} (iff : p = true ↔ q = true) : p = q :=
  match p, q, iff with
  | true, true, _ => rfl
  | false, false, _ => rfl
  | true, false, iff => Bool.noConfusion (iff.mp rfl)
  | false, true, iff => Bool.noConfusion (iff.mpr rfl)

/-- Two comparisons both hold exactly where their joint test is true. -/
theorem ble_and_iff {a b m n : Nat} : (Nat.ble a b && Nat.ble m n) = true ↔ a ≤ b ∧ m ≤ n :=
  ⟨fun holds => match hb : Nat.ble a b, hn : Nat.ble m n, holds with
     | true, true, _ => ⟨Nat.le_of_ble_eq_true hb, Nat.le_of_ble_eq_true hn⟩
     | false, _, holds => Bool.noConfusion holds
     | true, false, holds => Bool.noConfusion holds,
   fun ⟨first, second⟩ =>
     (congrArg (· && Nat.ble m n) (Nat.ble_eq_true_of_le first)).trans
       (Nat.ble_eq_true_of_le second)⟩

namespace Complement

variable [DecidableEq C] {d e : C} {N : Nat}

/-- The web of the units of a response to the level of `d`, read with its complement `e` at the
total `N`: unit `j` requires `d` at need `j` and `e` at need `N - j`, at every step. -/
def web (d e : C) (N : Nat) : Web Nat C :=
  ⟨fun _ _ => 0, fun _ _ => True, fun _ _ c => c = d ∨ c = e,
   fun _ j c => if c = d then j else N - j, fun _ _ _ => False⟩

/-- Unit `j` gives each condition `c` the amount `r j c` where `d` stands at `j` or more and `e` at
`N - j` or more, and nothing otherwise. Nothing is taken. -/
def law (d e : C) (N : Nat) (r : Nat → C → Nat) : ExchangeLaw Nat C :=
  ⟨fun _ _ _ _ => 0,
   fun t j l c => bif Nat.ble j (l t d) && Nat.ble (N - j) (l t e) then r j c else 0⟩

/-- Unit `j` is admitted exactly where `d` stands at `j` or more and `e` at `N - j` or more. -/
theorem admits_iff (apart : e ≠ d) {l : C → Nat} {t j : Nat} :
    (web d e N).Admits l t j ↔ j ≤ l d ∧ N - j ≤ l e :=
  ⟨fun admits => ⟨Nat.le_trans (Nat.le_of_eq (if_pos rfl).symm) (admits d (.inl rfl)),
     Nat.le_trans (Nat.le_of_eq (if_neg apart).symm) (admits e (.inr rfl))⟩,
   fun ⟨first, second⟩ _ required => match required with
     | .inl same => Eq.subst (motive := fun x => (web d e N).need t j x ≤ l x) same.symm
         (Nat.le_trans (Nat.le_of_eq (if_pos rfl)) first)
     | .inr same => Eq.subst (motive := fun x => (web d e N).need t j x ≤ l x) same.symm
         (Nat.le_trans (Nat.le_of_eq (if_neg apart)) second)⟩

/-- **The units read through dependence alone.** -/
theorem law_through (apart : e ≠ d) (r : Nat → C → Nat) (part : Nat → Bool) :
    (law d e N r).Through (web d e N) thresholdOnly part :=
  fun _ _ t _ _ alike c => ⟨rfl, congrArg (fun b => cond b (r _ c) 0)
    (eq_of_true_iff (ble_and_iff.trans ((admits_iff apart).symm.trans
      ((alike t (Nat.le_refl t)).1.trans ((admits_iff apart).trans ble_and_iff.symm)))))⟩

/-- **Each unit exchanges only where supported.** -/
theorem law_needsSupport (apart : e ≠ d) (r : Nat → C → Nat) (t j : Nat) :
    (law d e N r).NeedsSupportAt (web d e N) t j :=
  fun l unadmitted c => ⟨rfl,
    have unmet : (Nat.ble j (l t d) && Nat.ble (N - j) (l t e)) = false :=
      match met : (Nat.ble j (l t d) && Nat.ble (N - j) (l t e)) with
      | true => absurd ((admits_iff apart).mpr (ble_and_iff.mp met)) unadmitted
      | false => rfl
    congrArg (fun b => cond b (r j c) 0) unmet⟩

/-- Each unit couples into the condition and its complement by threshold. -/
theorem dependsOn (j : Nat) : (web d e N).DependsOn j d ∧ (web d e N).DependsOn j e :=
  ⟨⟨0, .inl rfl⟩, ⟨0, .inr rfl⟩⟩

/-- At a fixed total, a unit up to the total is admitted exactly at the level of `d`. -/
theorem admitted_iff {x y j : Nat} (total : x + y = N) (within : j ≤ N) :
    (j ≤ x ∧ N - j ≤ y) ↔ j = x :=
  ⟨fun ⟨below, rest⟩ => Nat.le_antisymm below (Nat.ge_of_not_lt fun lower =>
      Nat.lt_irrefl N (Nat.lt_of_le_of_lt
        (Nat.le_trans (Nat.le_of_eq ((Naturals.add_sub_of_le within).symm))
          (Nat.add_le_add_left rest j))
        (Nat.lt_of_lt_of_le (Nat.add_lt_add_right lower y) (Nat.le_of_eq total)))),
   fun same => ⟨Nat.le_of_eq same, Eq.subst (motive := fun k => N - k ≤ y) same.symm
     (Nat.le_of_eq ((congrArg (· - x) total.symm).trans (Naturals.add_sub_cancel_left x y)))⟩⟩

omit [DecidableEq C] in
/-- **With a complement at a fixed total, every response is carried.** Where `d` and `e` stand at
the step at a total `N`, the units read with the complement, one for each level up to `N`, give each
condition in total what any response `r` gives it at the level of `d`. -/
theorem carry (r : Nat → C → Nat) (t : Nat) (c : C) :
    (law d e N r).CarriesGiving (steps 0 (N + 1)) t c (fun l => l t d + l t e = N)
      (fun l => r (l t d) c) :=
  fun l total => total_steps_only (N + 1)
    (fun j lt other =>
      have unmet : (Nat.ble j (l t d) && Nat.ble (N - j) (l t e)) = false :=
        match met : (Nat.ble j (l t d) && Nat.ble (N - j) (l t e)) with
        | true => absurd ((admitted_iff total (Nat.le_of_lt_succ lt)).mp (ble_and_iff.mp met)) other
        | false => rfl
      congrArg (fun b => cond b (r j c) 0) unmet)
    (Nat.lt_succ_of_le (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq total))) |>.trans
    (congrArg (fun b => cond b (r (l t d) c) 0)
      (ble_and_iff.mpr ((admitted_iff total (Nat.le_trans (Nat.le_add_right _ _)
        (Nat.le_of_eq total))).mpr rfl)))

end Complement

/-! ## Supplying a deficit -/

section Supply

/-- **Supplying a deficit.** Each marked formation gives every condition what the level of `d` at
the step lacks of `k`. -/
def supplyLaw (mark : F → Bool) (d : C) (k : Nat) : ExchangeLaw F C :=
  ⟨fun _ _ _ _ => 0, fun t h l _ => bif mark h then k - l t d else 0⟩

/-- **By level, supplying a deficit passes.** The law supplying the deficit of a level coupled into
each marked formation by level reads through the couplings. -/
theorem supplyLaw_through {W : Web F C} {obs : F → C → Prop} {part : F → Bool} {mark : F → Bool}
    {d : C} {k : Nat} (marked : ∀ h, mark h = true → obs h d) :
    (supplyLaw mark d k).Through W obs part :=
  fun h _ t l l' alike _ => by
    refine ⟨rfl, ?_⟩
    show cond (mark h) (k - l t d) 0 = cond (mark h) (k - l' t d) 0
    cases m : mark h with
    | true => exact congrArg (k - ·) ((alike t (Nat.le_refl t)).2 d (marked h m))
    | false => rfl

/-- **By dependence alone, supplying a deficit is carried by nothing.** No family of formations
each exchanging only where supported, under a law reading through dependence alone, carries, over
the levels of `d` up to a positive bound, a response supplying what `d` lacks of a positive `k`. -/
theorem supply_not_carried [DecidableEq C] (d c : C) {k N : Nat} (positive : 0 < k) (bound : 0 < N)
    (t : Nat) :
    ¬ ∃ (law : ExchangeLaw Nat C) (W : Web Nat C) (us : List Nat),
        law.Through W thresholdOnly (fun _ => false) ∧
        (∀ u, u ∈ us → law.NeedsSupportAt W t u) ∧
        law.CarriesGiving us t c (fun l => l t d ≤ N) (fun l => k - l t d) :=
  fun carried =>
    have rising := (carried_iff_rising d c (fun x => k - x) t N).mp carried 0 bound
    Nat.lt_irrefl (k - 1) (Nat.lt_of_lt_of_le (Nat.sub_lt positive Nat.one_pos)
      (Nat.le_trans (Nat.le_of_eq (Nat.sub_zero k).symm) rising))

/-- **With the complement, supplying a deficit is carried by dependence alone.** Where `d` and `e`
stand at a fixed total, the units read with the complement carry the response supplying what `d`
lacks of `k`, each unit depending on `d` and on `e`. -/
theorem supply_carried_by_complement [DecidableEq C] {d e : C} (apart : e ≠ d) (N k t : Nat)
    (c : C) :
    (Complement.law d e N fun x _ => k - x).Through (Complement.web d e N) thresholdOnly
        (fun _ => false) ∧
      (∀ j, (Complement.law d e N fun x _ => k - x).NeedsSupportAt (Complement.web d e N) t j) ∧
      (Complement.law d e N fun x _ => k - x).CarriesGiving (steps 0 (N + 1)) t c
        (fun l => l t d + l t e = N) (fun l => k - l t d) :=
  ⟨Complement.law_through apart _ _, Complement.law_needsSupport apart _ t,
   Complement.carry _ t c⟩

end Supply

end Becoming
