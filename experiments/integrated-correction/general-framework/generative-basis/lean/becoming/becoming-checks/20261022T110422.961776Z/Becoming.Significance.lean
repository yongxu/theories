import Becoming.Clearing
import Becoming.Metaethics

/-!
# Significance: the continuation condition, the condition of chapter §6.15 (not asserted)

On 16 October 2026 Ren folded what was Part II into the theory without axiom as one conditional section after the
generative space (chapter §6.15): the theory does not assert the continuation condition below and states what
follows with it as a condition.

On 10 October 2026 Ren proposed what is now the continuation condition: “for anything, its continuation into the future has
significance(doesn't have to be positive, we could argue as long as not harm), or continuation
into the future needs to create more significance(being generative)”. Ren chose to state the
strongest claim without axiom first and to add this condition after it, with living significance as the target
theorem. Ren also wrote that a center and its boundary exist only within cognitive structure and
dynamics, formed within the same system, so there is no question of whose continuation matters
that would need an axiom, and that “not harm” is “a phase transition with a clear boundary”.
This module states the continuation condition on the spine and what follows from it with the results of the theory without axiom.
What the bullets below name without the condition, retaining and adding (`Web.Retains`,
`Web.Adds`), the margin theorems, the stepwise classes and `Preemption`, is stated in
`Becoming.Retaining`, and the witness `Clearing` in `Becoming.Clearing` (R31, 20 October 2026);
this module states what holds under the condition.

* **The continuation condition.** A significance says, for a standpoint, a step and a formation, whether from
  the standpoint the formation's continuation at the step has significance. The continuation condition is that
  nothing restricts it (`Unrestricted`): boundary neutrality (`Neutral`) for the significance
  of continuation, over anything, at every step, from every standpoint. A rival keeps the same
  rule inside each standpoint's region (`bounded_rival`).
* **Living significance follows.** Consider any reading in which a claim's significance from a standpoint is
  the significance of some formation's continuation at some step. Under the continuation condition living significance holds at
  the level of claims, and so do S0 at every standpoint, both neutralities, and a seed wherever
  something lives (`Valuation.premises_of_unrestricted`). No connection is used. The stepwise
  reading, the reading of relations and the whole-run reading are such readings
  (`Web.significant_of_unrestricted`, `Conditions.significant_of_unrestricted`). The step is
  immediate, an instantiation: `Unrestricted sig` says that `sig` holds of every standpoint,
  step and formation, and living significance is the continuation condition restricted to living claims, and the continuation condition is stronger, for it
  covers events that are not living and formations not yet formed. On the level paths of a web
  (`Web.paths`), living significance holds with unindexed significance, and so does C, with “better” read as
  retaining and adding what has significance (`Web.paths_livingSignificance_comparison`).
* **What has significance is what can form.** From a standpoint, one level path *retains* what
  has significance along another when it admits every continuation with significance that the
  other admits (`Web.Retains`). It *adds* when it admits one that the other does not
  (`Web.Adds`). Under the continuation condition retaining is inclusion and adding is exceeding
  (`Web.retains_iff_includes`, `Web.adds_iff_exceeds`), from every standpoint alike
  (`Web.retains_agree`). So the four cases of a part in `Becoming.Admission` are the four cases
  of significance.
* **Not harm is an exact boundary.** The levels with a part retain what has significance
  without it exactly when the part's net draw stays within the margin for every continuation
  with significance that the levels without it admit
  (`Flow.Balances.retains_iff_within_margin`). The part loses a continuation with significance
  exactly where its net draw exceeds the margin (`Flow.Balances.loses_iff_beyond_margin`). It
  adds one exactly where its net exchange brings within the margin a formation that the levels
  without it do not admit (`Flow.Balances.adds_iff_within_margin`). Each holds with balance
  only at the conditions of the continuations compared, across the steps before each
  (`Flow.retains_iff_within_margin_at`, `Flow.loses_iff_beyond_margin_at`,
  `Flow.adds_iff_within_margin_at`).
* **No ending is licensed.** A level path that retains what has significance along another
  ends none of it (`Web.Retains.not_added`). Under the continuation condition the conveyor's part is unordered,
  each path adding what the other lacks (`Transfer.unordered`), so ordering it needs a measure,
  a further premise. The giver's part retains and adds (`Restoring.Inflow.retains_adds`).
* **What has not yet formed counts.** In `Preemption` a drawer takes a condition's unit before
  any dependence on it forms. Its event is active and not undermining, so it is living on the
  stepwise reading. Yet its part narrows what can form: a formation requiring the condition from
  the next step on is admitted at every step without the part and at no later step with it.
  Under the continuation condition the part loses a continuation with significance
  (`Preemption.not_undermining_yet_loses`). The stepwise reading counts only dependences that
  have been met; retaining also counts what can still form.
* **The stepwise classes and loss.** Levels below a need are exceeded by every level path that
  admits the formation there (`Web.exceeded_of_below`). So an undermining event, through
  dependences on its condition that hold across its step at no smaller need, leaves the levels
  exceeded by every level path that meets those dependences after the step
  (`Web.UnderminingOn.exceeded`): the levels with a part do not include such levels without it,
  and keeping what can form excludes undermining there (`Web.Includes.not_undermining`). From a
  standpoint at which those continuations have significance, nothing is retained along the other
  path (`Web.UnderminingOn.not_retains`), and under the continuation condition from every
  standpoint (`Web.UnderminingOn.not_retains_unrestricted`). The converse fails: the preempting
  drawer's event is within renewal and not undermining, and its part does not keep what can form
  (`Preemption.within_renewal_yet_loses`). Undermining, where the levels without the part meet the
  dependences, is a sign of loss; neither renewal nor its absence of undermining is a sign of
  keeping, and loss itself is exactly a net draw beyond the margin
  (`Flow.Balances.loses_iff_beyond_margin`). Over the run the class does decide, in one direction:
  where only active formations take, and only from what they draw on, a part whose draws fall on
  conditions renewed over the run keeps what can form (`Flow.Balances.includes_of_renewed`, in
  `Becoming.Retaining`), and a consuming part narrows where it opens nothing and the levels without
  it meet the consumed dependence (`Flow.Balances.narrows_of_consumed`); the preempting drawer is
  within renewal at its step and consuming over the run (`Preemption.renewingAt_consuming_narrows`).
* **The whole first.** Where fewer continuations have significance, more is retained
  (`Web.Retains.of_fewer`). Significance bounded by a region retains what is admitted within
  the region (`Web.retains_bounded_iff`). Under the continuation condition, what retains in the whole retains
  within every region, a system's or a self's (`Web.Retains.within`). What holds within a
  system holds within every region inside it (`Web.AdmitsWithin.narrow`).

  The converse fails. In `Clearing`, let each formation's significance stop at what its
  continuation depends on. From the clearer's standpoint, its part retains what has
  significance at every step; from the dweller's standpoint, it loses the dweller
  (`Clearing.centers_disagree`). Under the continuation condition the part loses the dweller from every
  standpoint. Meanwhile, the levels without the part admit every formation at every step, and
  the clearer is supported throughout, so withholding the part ends nothing
  (`Clearing.clearer_loses_dweller`).
* **The generative space, with no axiom.** With balance at the conditions each formation
  requires, across the steps before it, the levels with a part widen those without it exactly
  when its net draw stays within the margin for everything the levels without it admit and
  its net exchange brings one more formation within the margin
  (`Flow.widens_iff_within_margin_at`; in a balanced flow,
  `Flow.Balances.widens_iff_within_margin`). On level paths, an extension in which every
  claim counts as living is exactly a widening, so C holds for every reading of `living`
  with “better” read as widening, with no axiom (`Web.paths_extension_iff_widens`,
  `Web.paths_comparison_widens`, in `Becoming.Extension`). This holds by definition: `Comparison` unfolds to `Extension`,
  so the normative content of C lies in calling widening better, which is not shown here. With the continuation condition supplied, widening is retaining and
  adding, keeping the same is retaining both ways, and being mixed is adding both ways
  (`Web.widens_iff_retains_adds`, `Web.keeps_iff_retains`, `Web.mixed_iff_adds`): the
  reduction to possibilities loses nothing, and the rules above need no axiom (Ren, 11
  October 2026: “as long as the derivation of the rules doesn't rely on axiom, don't use
  one”).
* **The dynamics do not decide significance.** Where nothing has significance, every level path retains every
  other and none adds, and living significance fails at any event that lives; where everything
  has significance it holds (`Web.significance_undetermined`, which evaluates these two constant
  significances). That no law of the dynamics constrains significance holds because significance
  is not a field of `World`, `Web` or `Flow`, a fact about the representation, not a theorem here.
  This does not show that the continuation condition is needed.

Significance here is not graded, and, as Ren wrote, it need not be positive. A part does no
harm when the levels with it retain what has significance without it, and it is generative when
it also adds.

**AI reading, adopted on Ren's delegation of 15 October 2026 (DELEGATED-CHOICES D16).**
- `Unrestricted` reads Ren's axiom. The formation index reads “anything”, a formation's
  continuation at a step reads “its continuation into the future”, and the standpoint index
  reads “has significance” unqualified, with no center privileged.
- Retaining reads “as long as not harm”. Adding reads “create more significance” and Ren's
  “more possibilities of becoming”.
- Ren wrote that the self “can not justify itself without some sort of "belief"”. This reads
  onto `bounded_rival` and `Web.significance_undetermined`: a significance bounded by a region
  is supplied, as the continuation condition is, and the dynamics decides neither.
- Living significance is a theorem of this condition and, since Ren folded it on 11 October 2026, no longer an axiom.

What is not derived:
- the step from significance to a reason (A), the lifting (L), and practical judgment (J1–J4);
- the measure that would order a mixed part;
- the level at which formations are individuated, members or lineages, which fixes what counts
  as a loss;
- which reading of `living` living significance names. The stepwise reading counts participation in a fall
  below a need met. Retaining counts the part's difference against the levels without it,
  possibilities included, and the two differ (`Preemption`).
- the normative warrant of the continuation condition itself.

Recognition and motivation belong to the later attempt without axiom. The representation
commits to discrete steps, natural quantities and a decided part.

`Conditions.significant_of_unrestricted` and the paths of a web (`Web.paths` and its comparison
theorems) are in `Becoming.ValuationFrames` (board item W).
* **Rivals of a formed boundary, and a rule bounded in time.** A rule holding exactly within a
  region accepts the continuation condition's rule there and is not it where something lies outside
  (`rival_of_outside`; `bounded_rival` its case); a rule bounded in time (`boundedInTime`) is such a
  rival (`bounded_in_time_rival`). In the clearer's witness, caring for the first two steps only,
  the clearer's part loses nothing, while under the continuation condition it loses the dweller
  (`Clearing.time_bounded_permits`).
-/

namespace Becoming

variable {F C Pos : Type}

/-! ## The continuation condition and its rivals -/

/-- No standpoint, step or formation restricts significance: from every standpoint, the
continuation of anything has significance at every step. This is boundary neutrality
(`Neutral`) for the significance of continuation. -/
def Unrestricted (sig : Pos → Nat → F → Prop) : Prop :=
  Neutral fun i : Pos × Nat × F => sig i.1 i.2.1 i.2.2

/-- **A rule accepted inside a formed boundary is a rival wherever something lies outside it.** The
rule holding exactly within a region of standpoints, steps and formations accepts the continuation
condition's rule within the region, and where some point lies outside it, it is not the
continuation condition. -/
theorem rival_of_outside (region : Pos × Nat × F → Prop) :
    Within region region ∧ ((∃ i, ¬ region i) → ¬ Unrestricted (fun p t f => region (p, t, f))) :=
  ⟨fun _ inside => inside, fun ⟨i, outside⟩ all => outside (all i)⟩

/-- A bounded significance is the continuation condition's rule accepted inside a formed boundary. Where some
formation lies outside some standpoint's region, it is not the continuation condition. This is all
the theorem proves; that such a rival is consistent with every law of the dynamics holds only
because significance is not a field of the representation. -/
theorem bounded_rival {region : Pos → F → Prop} :
    Within (fun i : Pos × Nat × F => region i.1 i.2.2) (fun i => bounded region i.1 i.2.1 i.2.2) ∧
      ((∃ p f, ¬ region p f) → ¬ Unrestricted (bounded region)) :=
  ⟨(rival_of_outside (fun i : Pos × Nat × F => region i.1 i.2.2)).1,
   fun ⟨p, f, outside⟩ => (rival_of_outside (fun i : Pos × Nat × F => region i.1 i.2.2)).2
     ⟨(p, 0, f), outside⟩⟩

/-- The significance bounded in time: only continuations at steps up to `T` have significance. -/
def boundedInTime (T : Nat) : Pos → Nat → F → Prop :=
  fun _ t _ => t ≤ T

/-- **A rule bounded in time is a rival.** It accepts the continuation condition's rule within its
time bound, and with any standpoint and formation it is not the continuation condition: the step
after the bound is outside it. -/
theorem bounded_in_time_rival (T : Nat) :
    Within (fun i : Pos × Nat × F => i.2.1 ≤ T) (fun i => boundedInTime T i.1 i.2.1 i.2.2) ∧
      (Pos → F → ¬ Unrestricted (boundedInTime (Pos := Pos) (F := F) T)) :=
  ⟨(rival_of_outside (fun i : Pos × Nat × F => i.2.1 ≤ T)).1,
   fun p f => (rival_of_outside (fun i : Pos × Nat × F => i.2.1 ≤ T)).2
     ⟨(p, T + 1, f), Nat.not_succ_le_self T⟩⟩

/-! ## Retaining under the continuation condition -/

namespace Web

variable {W : Web F C}

/-- Under the continuation condition, retaining is inclusion: what has significance is what can form. -/
theorem retains_iff_includes {sig : Pos → Nat → F → Prop} (unrestricted : Unrestricted sig)
    (p : Pos) {l l' : Nat → C → Nat} : W.Retains sig p l l' ↔ W.Includes l l' :=
  ⟨fun retains t f => retains t f (unrestricted (p, t, f)), fun includes => includes.retains sig p⟩

/-- Under the continuation condition, adding is exceeding. -/
theorem adds_iff_exceeds {sig : Pos → Nat → F → Prop} (unrestricted : Unrestricted sig)
    (p : Pos) {l l' : Nat → C → Nat} : W.Adds sig p l l' ↔ W.Exceeds l l' :=
  ⟨Adds.exceeds, fun ⟨t, f, admits, not⟩ => ⟨t, f, unrestricted (p, t, f), admits, not⟩⟩

/-- Under the continuation condition no standpoint is privileged: every standpoint retains alike. -/
theorem retains_agree {sig : Pos → Nat → F → Prop} (unrestricted : Unrestricted sig)
    (p q : Pos) {l l' : Nat → C → Nat} : W.Retains sig p l l' ↔ W.Retains sig q l l' :=
  (retains_iff_includes unrestricted p).trans (retains_iff_includes unrestricted q).symm

/-- The case of the continuation condition. With the continuation condition supplied, retaining and adding what has significance
is widening what can form: the reduction to possibilities loses nothing. -/
theorem widens_iff_retains_adds {sig : Pos → Nat → F → Prop} (unrestricted : Unrestricted sig)
    (p : Pos) {l l' : Nat → C → Nat} : W.Widens l l' ↔ W.Retains sig p l l' ∧ W.Adds sig p l l' :=
  ⟨fun ⟨includes, exceeds⟩ => ⟨(retains_iff_includes unrestricted p).mpr includes,
     (adds_iff_exceeds unrestricted p).mpr exceeds⟩,
   fun ⟨retains, adds⟩ => ⟨(retains_iff_includes unrestricted p).mp retains, adds.exceeds⟩⟩

/-- The case of the continuation condition. With the continuation condition supplied, keeping what can form the same is retaining
what has significance both ways. -/
theorem keeps_iff_retains {sig : Pos → Nat → F → Prop} (unrestricted : Unrestricted sig)
    (p : Pos) {l l' : Nat → C → Nat} : W.Keeps l l' ↔ W.Retains sig p l l' ∧ W.Retains sig p l' l :=
  ⟨fun ⟨first, second⟩ => ⟨(retains_iff_includes unrestricted p).mpr first,
     (retains_iff_includes unrestricted p).mpr second⟩,
   fun ⟨first, second⟩ => ⟨(retains_iff_includes unrestricted p).mp first,
     (retains_iff_includes unrestricted p).mp second⟩⟩

/-- The case of the continuation condition. With the continuation condition supplied, being mixed is each adding what has
significance that the other lacks. -/
theorem mixed_iff_adds {sig : Pos → Nat → F → Prop} (unrestricted : Unrestricted sig)
    (p : Pos) {l l' : Nat → C → Nat} : W.Mixed l l' ↔ W.Adds sig p l l' ∧ W.Adds sig p l' l :=
  ⟨fun ⟨first, second⟩ => ⟨(adds_iff_exceeds unrestricted p).mpr first,
     (adds_iff_exceeds unrestricted p).mpr second⟩,
   fun ⟨first, second⟩ => ⟨first.exceeds, second.exceeds⟩⟩

/-- The whole first. Under the continuation condition, what retains from a standpoint retains from it within every
region, a system's or a self's: the whole's judgment decides every narrower one. -/
theorem Retains.within {sig : Pos → Nat → F → Prop} (unrestricted : Unrestricted sig) {p : Pos}
    {l l' : Nat → C → Nat} (retains : W.Retains sig p l l') (region : Pos → F → Prop) :
    W.Retains (bounded region) p l l' :=
  retains.of_fewer fun p t f _ => unrestricted (p, t, f)

/-- **Under the continuation condition an undermining event loses from every standpoint.** -/
theorem UnderminingOn.not_retains_unrestricted {l : Nat → C → Nat} {t : Nat} {f : F} {c : C}
    (undermining : W.UnderminingOn t f c)
    (holds : ∀ g, W.requires t g c → W.requires (t + 1) g c ∧ W.need t g c ≤ W.need (t + 1) g c)
    (admits : ∀ g, W.requires t g c → W.Admits (l (t + 1)) (t + 1) g)
    {sig : Pos → Nat → F → Prop} (unrestricted : Unrestricted sig) (p : Pos) :
    ¬ W.Retains sig p W.level l :=
  undermining.not_retains holds admits fun g _ => unrestricted (p, t + 1, g)

end Web

/-! ## Living significance and the premise card follow -/

/-- Under the continuation condition, living significance holds at the level of claims on every reading in which a claim's
significance from a standpoint is the significance of some formation's continuation at some
step. With it hold S0 at every standpoint, both neutralities, and a seed wherever something
lives. No connection is used. -/
theorem Valuation.premises_of_unrestricted {Q : Type} {V : Valuation Pos Q}
    {sig : Pos → Nat → F → Prop} (unrestricted : Unrestricted sig) (formation : Q → F)
    (step : Q → Nat) (reads : ∀ p c, sig p (step c) (formation c) → V.sig p c) :
    V.Significant ∧ (∀ p, V.SelfSignificance p) ∧ Neutral V.transmits ∧ Neutral V.shares ∧
      ∀ c, V.living c → Pos → V.Seed :=
  have all : V.Significant := fun p c _ => reads p c (unrestricted (p, step c, formation c))
  ⟨all, fun p c _ alive => all p c alive, fun ⟨p, _, d⟩ _ _ alive => all p d alive,
   fun ⟨_, q, c⟩ alive _ => all q c alive, fun c alive p => ⟨p, c, alive, all p c alive⟩⟩

/-- Read stepwise, and read through relations, living significance follows from the continuation condition: an event's or a
relation's significance from a standpoint is that of its formation's continuation at its step. -/
theorem Web.significant_of_unrestricted (W : Web F C) {sig : Pos → Nat → F → Prop}
    (unrestricted : Unrestricted sig) (own : Pos → F × Nat → Prop)
    (own' : Pos → F × C × Nat → Prop) :
    (W.valuation own fun p e => sig p e.2 e.1).Significant ∧
      (W.relations own' fun p e => sig p e.2.2 e.1).Significant :=
  ⟨fun p e _ => unrestricted (p, e.2, e.1), fun p e _ => unrestricted (p, e.2.2, e.1)⟩

/-- The two constant significances. Where nothing has significance, every level path retains every other
and none adds, and living significance fails at any event that lives; where everything has significance living significance holds.
So the represented dynamics do not entail living significance. This does not show that the
continuation condition is needed. -/
theorem Web.significance_undetermined (W : Web F C) (own : Pos → F × Nat → Prop) (p : Pos)
    {e : F × Nat} (alive : W.active e.2 e.1 ∧ ¬ W.UnderminingAt e.2 e.1) :
    (∀ l l' : Nat → C → Nat, W.Retains (fun _ _ _ => False) p l l' ∧
        ¬ W.Adds (fun _ _ _ => False) p l l') ∧
      (W.valuation own fun _ _ => True).Significant ∧
      ¬ (W.valuation own fun _ _ => False).Significant :=
  ⟨fun _ _ => ⟨fun _ _ no => (nomatch no), fun ⟨_, _, no, _⟩ => no⟩,
   fun _ _ _ => trivial, fun all => all p e alive⟩

/-! ## Witnesses -/

namespace Clearing

/-- The continuation condition counts what the clearer's part ends. Under it, from every standpoint, the clearer's part
loses the dweller, so the levels with it do not retain what has significance without it. The
levels without it retain what has significance with it, and the clearer is supported at every
step and admitted without its part: withholding the part ends nothing. -/
theorem clearer_loses_dweller {l : Nat → Place → Nat} (without : flow.WithheldLevels clearerPart web l)
    {sig : Pos → Nat → Formation → Prop} (unrestricted : Unrestricted sig) (p : Pos) :
    web.Adds sig p l web.level ∧ ¬ web.Retains sig p web.level l ∧
      web.Retains sig p l web.level ∧
      ∀ t, web.Supported t .clearer ∧ web.Admits (l t) t .clearer :=
  have adds : web.Adds sig p l web.level :=
    ⟨2, .dweller, unrestricted (p, 2, .dweller), admitted_without without 2, unsupported_with 0⟩
  ⟨adds, fun retains => retains.not_added adds,
   fun t f _ _ => admitted_all_without without t f,
   fun t => ⟨dependent t .clearer trivial, admitted_all_without without t .clearer⟩⟩

/-- At the first two steps the levels with the clearer's part admit every formation. -/
theorem admits_early : ∀ t, t ≤ 1 → ∀ f, web.Admits (web.level t) t f
  | _, _, .clearer, .resource, _ => Nat.le_refl 1
  | 0, _, .dweller, .habitat, _ => Nat.le_succ 1
  | 1, _, .dweller, .habitat, _ => Nat.le_refl 1
  | _ + 2, late, .dweller, .habitat, _ => absurd (Nat.le_of_succ_le_succ late) (Nat.not_succ_le_zero _)
  | _, _, .source, _, no => nomatch no
  | _, _, .clearer, .habitat, no => nomatch no
  | _, _, .clearer, .fuel _, no => nomatch no
  | _, _, .dweller, .resource, no => nomatch no
  | _, _, .dweller, .fuel _, no => nomatch no

/-- **Caring for this generation only, the clearer's part loses nothing; caring for every
generation, it loses the dweller.** Under the significance bounded at the second step, from every
standpoint the levels with the clearer's part retain what has significance along any levels;
under the continuation condition they do not retain what has significance without the part. -/
theorem time_bounded_permits {l : Nat → Place → Nat} (without : flow.WithheldLevels clearerPart web l)
    {sig : Pos → Nat → Formation → Prop} (unrestricted : Unrestricted sig) (p : Pos) :
    web.Retains (boundedInTime 1) p web.level l ∧ ¬ web.Retains sig p web.level l :=
  ⟨fun t f early _ => admits_early t early f, (clearer_loses_dweller without unrestricted p).2.1⟩

end Clearing

namespace Transfer

/-- Under the continuation condition the conveyor's part is unordered: each level path adds a continuation with
significance that the other lacks, so neither retains the other. Ordering it needs a measure. -/
theorem unordered {l : Nat → Bool → Nat} (without : flow.WithheldLevels conveyorPart web l)
    {sig : Pos → Nat → Formation → Prop} (unrestricted : Unrestricted sig) (p : Pos) :
    web.Adds sig p web.level l ∧ web.Adds sig p l web.level ∧
      ¬ web.Retains sig p web.level l ∧ ¬ web.Retains sig p l web.level :=
  match mixed without with
  | ⟨gains, loses, _⟩ =>
    have adds := (Web.adds_iff_exceeds unrestricted p).mpr gains
    have lost := (Web.adds_iff_exceeds unrestricted p).mpr loses
    ⟨adds, lost, fun retains => retains.not_added lost, fun retains => retains.not_added adds⟩

end Transfer

namespace Restoring.Inflow

/-- Under the continuation condition the giver's part retains and adds: the levels with it retain what has
significance without it and add a continuation with significance. -/
theorem retains_adds {l : Nat → Unit → Nat} (without : flow.WithheldLevels giverPart web l)
    {sig : Pos → Nat → Bool → Prop} (unrestricted : Unrestricted sig) (p : Pos) :
    web.Retains sig p web.level l ∧ web.Adds sig p web.level l :=
  match widens without with
  | ⟨includes, exceeds, _⟩ =>
    ⟨includes.retains sig p, (Web.adds_iff_exceeds unrestricted p).mpr exceeds⟩

end Restoring.Inflow

namespace Preemption

/-- Living, yet closing a possibility. The flow balances, only active formations give, and only
active formations take, and only from what they draw on; activity needs support. The drawer's
event at the first step is active and not undermining, since no dependence on the condition has
formed. Yet `false` is admitted at every step without the drawer's part and supported at no step
after the first with it: the part narrows what can form. Under the continuation condition it loses a continuation
with significance from every standpoint, so the levels with it do not retain what has
significance without it. -/
theorem not_undermining_yet_loses {l : Nat → Unit → Nat}
    (without : flow.WithheldLevels drawerPart web l) {sig : Pos → Nat → Bool → Prop}
    (unrestricted : Unrestricted sig) (p : Pos) :
    flow.Balances web ∧ flow.Acting web ∧ flow.Taking web ∧ web.Dependent ∧
      (web.active 0 true ∧ ¬ web.UnderminingAt 0 true) ∧
      (∀ t, web.Admits (l t) t false ∧ ¬ web.Supported (t + 1) false) ∧
      web.Includes l web.level ∧ web.Adds sig p l web.level ∧ ¬ web.Retains sig p web.level l :=
  have balances : flow.Balances web := fun t () => match t with
    | 0 => rfl
    | _ + 1 => rfl
  have each : ∀ t, web.Admits (l t) t false ∧ ¬ web.Supported (t + 1) false := fun t =>
    ⟨fun () _ => Nat.le_of_eq (without.unique withheld t ()).symm,
     fun supported => Nat.not_succ_le_zero 0 (supported () (Nat.succ_pos t))⟩
  have adds : web.Adds sig p l web.level :=
    ⟨1, false, unrestricted (p, 1, false), (each 1).1, (each 0).2⟩
  ⟨balances, fun _ _ _ _ gives => absurd gives (Nat.lt_irrefl 0),
   fun t x _ _ takes => match t, x, takes with
    | 0, true, _ => ⟨rfl, trivial⟩
    | 0, false, takes => absurd takes (Nat.lt_irrefl 0)
    | _ + 1, _, takes => absurd takes (Nat.lt_irrefl 0),
   fun _ x active _ requires => match x, active, requires with
    | true, _, no => (nomatch no)
    | false, no, _ => (nomatch no),
   ⟨rfl, fun ⟨(), _, g, requires, _⟩ => match g, requires with
    | true, no => no
    | false, no => Nat.lt_irrefl 0 no⟩,
   each, balances.opens_nothing without fun t _ => match t with
    | 0 => Nat.zero_le _
    | _ + 1 => Nat.zero_le _, adds,
   fun retains => retains.not_added adds⟩

end Preemption

end Becoming