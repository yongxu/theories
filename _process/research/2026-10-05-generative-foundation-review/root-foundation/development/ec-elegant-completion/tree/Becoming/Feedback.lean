import Becoming.Interdependence
import Becoming.Witnesses

/-!
# Feedback and reach: what a formation's feedback carries, and what a part reaches

On 10 October 2026 Ren stated the long-term objectives: “I want to push the frontier as strong
as possible, in terms of human knowledge, or have the full truth set(still need situational
awareness), the universal ethics”, and asked to “pursue the strongest claims and complete
proof”. Earlier that day Ren had ordered the levels at which harm is judged: “i think it should
be the whole, and a weaker version is within the system that one is in, then the self”. This
module states, with no premise beyond the representation, how far a formation's own feedback
reaches, how far a part's exchange reaches, and that the comparison of the levels with and
without a part is decided within what the part reaches. The module neither imports nor assumes
the continuation condition of `Becoming.Significance`: the theorems named below that read
significance under it (`Flow.feeding_unrestricted_of_common`, `Flow.bounded_system_whole`,
`Clearing.system_whole`, `Clearing.reach_counts_dweller`, `Trophic.mediated_uncoupled`,
`Trophic.responsive_mixed`, `Trophic.mixed_part`) are stated in `Becoming.BoundedSignificance`.

* **Closures.** Every level below is the one closure of `Becoming.Frame` under a relation
  (`ClosedUnder`, `WithinClosure`, with its laws there): what is reached from the formation
  along the relation, the seed–edge closure of `Becoming.EdgeClosure` from one seed
  (`withinClosure_iff_closure` there), certified by a finite computation
  (`closure_iff_certified`), and separated from another formation's by a closed region holding
  one and not the other (`not_within_of_closed`). These moved to the frame unchanged, with their
  names (board item EC1, 21 October 2026).
* **Five levels.** The feeding closure of `Becoming.Interdependence` is, by definition, the
  closure under being fed at some step (`Flow.WithinFeeding`, `Flow.FedFrom`). A formation is affected by another when the other
  exchanges with a condition it depends on (`Flow.AffectedBy`). The closure under being affected
  is the influence closure, what can affect the formation (`Flow.WithinInfluence`); the closure
  under affecting is the reach closure, what the formation's exchange can affect, link by link
  (`Flow.Affects`, `Flow.WithinReach`). Two formations share a condition when both take part in
  it, by depending on it or exchanging with it (`Flow.Shares`), and the closure under sharing is
  the system (`Flow.WithinSystem`), a class (`Flow.WithinSystem.symm`). Each formation lies within
  its feeding closure, which lies within its influence closure; the influence and reach closures
  lie within the system (`Flow.withinInfluence_of_withinFeeding`,
  `Flow.withinSystem_of_withinInfluence`, `Flow.withinSystem_of_withinReach`). Each inclusion can
  be strict, and the influence and reach closures point in opposite directions. In `Clearing` the
  source lies within the clearer's feeding closure and beyond its reach closure, and the dweller
  beyond its influence closure and within its reach closure (`Clearing.levels`,
  `Clearing.reach_middle`); the dweller's reach closure holds only the dweller
  (`Clearing.reach_centred`). In `Trophic`, a trophic cascade, wolves lie beyond a forest's feeding
  closure and within its influence closure, affecting it through the deer, and a formation far off
  lies beyond the forest's system (`Trophic.mediates`).
* **One common condition makes the system the whole.** Where every formation takes part in one
  condition, every system is the whole (`Flow.system_whole_of_common`), as in `Clearing`
  (`Clearing.clearer_system`, `Clearing.system_whole`). Formations that depend on one condition
  share a system even where nothing exchanges with it and neither affects the other
  (`Static.shares_unaffected`). Where every formation depends on one condition and exchanges with
  it, every reach closure is the whole (`Flow.reach_whole_of_common`). Where at one step every
  formation requires one condition and gives to it, every feeding closure is the whole, and
  significance bounded by it, the route without axiom of `Becoming.Interdependence`, is the continuation condition
  (`Flow.feeding_whole_of_common`, `Flow.feeding_unrestricted_of_common`).
* **Levels follow their exchanges.** Two balanced flows that start a condition alike, and take
  from it and give to it alike, keep it alike (`Flow.Balances.levels_agree`). So a formation's
  support follows only the exchanges with what it depends on (`Flow.Balances.support_agrees`).
  What a part does shows on a condition exactly through its net exchange with it
  (`Flow.Balances.agrees_iff_even`). The levels with and without the part agree where none of
  its members exchanges with the condition (`Flow.Balances.agrees_of_quiet`); where they differ
  at a step, some member exchanged with it at an earlier step
  (`Flow.Balances.exchanges_before_of_differs`).
* **What feedback carries.** Nothing beyond a formation's influence closure exchanges with a
  condition that a member of the closure depends on (`Flow.beyond_influence`). Where every member
  of a part lies beyond the closure, each formation within it is supported with the part exactly
  where the levels without the part admit it (`Flow.Balances.uncoupled_beyond_influence`). In
  `Clearing` the clearer's support is the same at every step whether or not it clears the
  habitat, while the dweller ends (`Clearing.uncoupled`). The influence closure is an upper
  bound: with the rest of the exchange fixed, a formation's support follows only the parts that
  reach it directly (`Flow.Balances.admits_unreached`).
* **What a part reaches.** A part reaches a formation when a member exchanges with a condition
  the formation depends on (`Flow.Reaches`), and reaches it before a step when a member exchanged,
  at an earlier step, with a condition the formation requires at that step (`Flow.ReachesBefore`).
  Whatever a part has not reached before a step is admitted alike with and without it there
  (`Flow.Balances.admits_unreached_before`, `Flow.Balances.admits_unreached`). An exchange that
  comes after the dependence affects without effect (`Late.affected_without_effect`). What a part
  whose members lie within a region closed under affecting reaches lies within the region
  (`Flow.reaches_within_closed`); the reach closure and the system are such regions
  (`Flow.reaches_withinReach`, `Flow.withinSystem_closed`), and a formation's own part has its
  members within its reach closure (`Flow.own_within_reach`). What lies within a system reaches
  only within it, and what lies beyond reaches nothing within it
  (`Flow.reaches_withinSystem`, `Flow.unreached_within_system`).
* **The comparison is decided within what the part reaches.** Two significances that agree, from
  a standpoint, at each step on what the part has reached before it compare the levels with and
  without the part alike (`Flow.Balances.comparison_local`). For any significance that covers
  what the part has reached before each step, the levels with and without the part retain what
  has significance along each other exactly as they include each other, both ways, and neither
  adds a continuation with significance exactly where neither exceeds the other: the continuation condition's
  comparisons (`Flow.Balances.comparison_within_reach`). Where significance is decidable, adding
  is exceeding (`Flow.Balances.adds_iff_exceeds_of_decidable`); for every significance, exceeding
  gives adding up to double negation (`Flow.Balances.not_not_adds_of_exceeds`). So significance
  bounded by a region closed under affecting compares every part within it as inclusion does
  (`Flow.Balances.closed_comparison`), and the reach closure is the least such region holding a
  center. In `Clearing` the clearer's part reaches the dweller (`Clearing.reaches_dweller`).
  Significance bounded by each reach closure is not the continuation condition, yet from the clearer's standpoint
  the part loses the dweller, as under the continuation condition (`Clearing.reach_counts_dweller`); bounded by
  each influence closure, the part retains (`Clearing.system_counts_dweller`).
* **Any two flows.** The comparison of any two balanced flows that start alike is decided within
  what their difference reaches before each step (`Flow.DiffersBefore`,
  `Flow.Balances.comparison_within_difference`). With the rest of the exchange fixed the
  difference is a part's exchange; where others respond, it holds their responses as well. The
  wolves' part does not reach the forest, while the difference from the flow in which the deer
  respond reaches it (`Trophic.difference_reaches_forest`).
* **Where the comparison stops.** Covering is enough and not needed: a part can reach beyond a
  formation's influence closure and change no admission there (`Margin.reach_without_misjudgment`).
  A part with a member beyond a system can be misjudged by significance bounded by that system
  (`Trophic.mixed_part`). The comparison by withheld levels holds the rest of the exchange fixed,
  so effects through others' responses do not show in it. With the deer's browsing held as it
  is, the wolves' part narrows, closing the deer (`Trophic.mediated_uncoupled`); against the
  flow in which the deer respond, the same taking is mixed (`Trophic.responsive_mixed`). Where a
  part gives what others take, the levels without it may not exist, and there is no comparison by
  withheld levels (`Clearing.no_levels_without_source`).

**AI reading, adopted on Ren's delegation of 15 October 2026 (DELEGATED-CHOICES D20).**
- The influence closure reads what a formation's own feedback can carry, once effects pass
  through the support and activity of others. With the rest of the exchange fixed, only the parts
  that reach it show.
- Feedback and a part's exchange point in opposite directions. A formation's feedback carries at
  most its influence closure, what can affect it, while its own part reaches into its reach
  closure, what it can affect. A center that values only what its feedback carries compares its
  own part as the continuation condition does wherever the part reaches only within that closure
  (`Flow.Balances.comparison_local`). Where the part reaches beyond it, the center can misjudge it,
  as the clearer does; reaching beyond does not by itself make it misjudge (`Margin`). This reads
  Ren's “still need situational awareness”, which Ren attached to “the full truth set”: to
  compare its own part, a center must know what the part reaches beyond its feedback.
- The system bounds every effect, but it does not read Ren's intermediate “system that one is
  in”: wherever one condition is taken part in by everything it is the whole, and systems
  partition the formations, with no nesting and no center. For that reading the reach closure is
  offered: what a center's exchange affects, link by link. It is centred and nests, lies within
  the system, and in `Clearing` lies strictly between the clearer and the whole. It points forward
  and need not hold what the center depends on. P40 read the feeding closure as the system one is
  in; that reading is withdrawn.
- Ren's weaker version then reads: significance that covers what a center reaches gives the
  axiom's comparison on every part within that reach whose levels without it exist, with the rest
  of the exchange fixed. Ren also wrote that “at this moment in time, the whole earth has become a
  highly entangled system”. Where a center's reach is the whole, as where every formation depends
  on one condition and exchanges with it (`Flow.reach_whole_of_common`), the weaker version
  coincides with the continuation condition. That condition is one shared condition; it does not measure
  coupling.

What is not derived:
- that a formation knows its reach closure, or wants anything;
- significance itself, which stays supplied (`Web.significance_undetermined`);
- the adding comparisons in positive form for every significance: they hold where significance
  is decidable, and otherwise up to double negation (`Flow.Balances.not_not_adds_of_exceeds`);
- how others would respond: a comparison in which they respond needs the second flow supplied.

The comparisons by withheld levels keep the rest of the exchange fixed, and a part is a decided
family of formations; one act of a formation is compared through a second flow, as in
`Clearing.uncoupled`. The representation commits to discrete steps and natural quantities.
-/

namespace Becoming

variable {F C : Type}

/-- `g` depends on `c` at some step. -/
def Web.DependsOn (W : Web F C) (g : F) (c : C) : Prop :=
  ∃ t, W.requires t g c

/-! ## Levels: feeding, influence, reach and the system -/

namespace Flow

variable (L : Flow F C) (W : Web F C)

/-- `h` exchanges with `c`: at some step it takes part and takes from or gives to `c`. -/
def Exchanges (h : F) (c : C) : Prop :=
  ∃ t, h ∈ L.present t ∧ (0 < L.take t h c ∨ 0 < L.give t h c)

/-- `g`'s continuation is affected by `h`: `h` exchanges with a condition `g` depends on. -/
def AffectedBy (g h : F) : Prop :=
  ∃ c, W.DependsOn g c ∧ L.Exchanges h c

/-- `g` lies within `f`'s influence closure: the closure under being affected. -/
def WithinInfluence (f g : F) : Prop :=
  WithinClosure (L.AffectedBy W) f g

/-- `g` takes part in `c`: it depends on `c` or exchanges with it. -/
def TakesPart (g : F) (c : C) : Prop :=
  W.DependsOn g c ∨ L.Exchanges g c

/-- `g` and `h` take part in a common condition. -/
def Shares (g h : F) : Prop :=
  ∃ c, L.TakesPart W g c ∧ L.TakesPart W h c

/-- `g` lies within `f`'s system: the closure under taking part in a common condition. -/
def WithinSystem (f g : F) : Prop :=
  WithinClosure (L.Shares W) f g

/-- The part reaches `g`: a member of the part exchanges with a condition `g` depends on. -/
def Reaches (part : F → Bool) (g : F) : Prop :=
  ∃ h, part h = true ∧ L.AffectedBy W g h

/-- `f` affects `g`: `f` exchanges with a condition `g` depends on. -/
def Affects (f g : F) : Prop :=
  L.AffectedBy W g f

/-- `g` lies within `f`'s reach closure: the closure under affecting. -/
def WithinReach (f g : F) : Prop :=
  WithinClosure (L.Affects W) f g

/-- The part reaches `g` before `t`: at a step before `t` a member exchanged with a condition `g`
requires at `t`. -/
def ReachesBefore (part : F → Bool) (t : Nat) (g : F) : Prop :=
  ∃ h c s, part h = true ∧ W.requires t g c ∧ s < t ∧ h ∈ L.present s ∧
    (0 < L.take s h c ∨ 0 < L.give s h c)

variable {L W}

/-- Feeding affects. -/
theorem affectedBy_of_fedFrom {g h : F} : L.FedFrom W g h → L.AffectedBy W g h
  | ⟨t, _, c, requires, present, gives⟩ => ⟨c, ⟨t, requires⟩, t, present, .inr gives⟩

/-- What affects shares a condition. -/
theorem shares_of_affectedBy {g h : F} : L.AffectedBy W g h → L.Shares W g h
  | ⟨c, depends, exchanges⟩ => ⟨c, .inl depends, .inr exchanges⟩

/-- The feeding closure lies within the influence closure. -/
theorem withinInfluence_of_withinFeeding {f g : F} (within : L.WithinFeeding W f g) :
    L.WithinInfluence W f g :=
  WithinClosure.mono (fun _ _ => affectedBy_of_fedFrom) within

/-- The influence closure lies within the system. -/
theorem withinSystem_of_withinInfluence {f g : F} (within : L.WithinInfluence W f g) :
    L.WithinSystem W f g :=
  WithinClosure.mono (fun _ _ => shares_of_affectedBy) within

/-- Sharing a condition is symmetric. -/
theorem shares_symm {g h : F} : L.Shares W g h → L.Shares W h g
  | ⟨c, first, second⟩ => ⟨c, second, first⟩

/-- Systems are classes: `f` lies within the system of whatever lies within its own. -/
theorem WithinSystem.symm {f g : F} (within : L.WithinSystem W f g) : L.WithinSystem W g f :=
  WithinClosure.symm (fun _ _ => shares_symm) within

/-- The reach closure lies within the system. -/
theorem withinSystem_of_withinReach {f g : F} (within : L.WithinReach W f g) :
    L.WithinSystem W f g :=
  WithinClosure.mono (fun _ _ affects => shares_symm (shares_of_affectedBy affects)) within

/-- What a part reaches before a step, it reaches. -/
theorem ReachesBefore.reaches {part : F → Bool} {t : Nat} {g : F}
    (reached : L.ReachesBefore W part t g) : L.Reaches W part g :=
  match reached with
  | ⟨h, c, s, member, requires, _, present, exchanges⟩ =>
    ⟨h, member, c, ⟨t, requires⟩, s, present, exchanges⟩

/-- One common condition makes the system the whole: where every formation takes part in one
condition, every formation lies within every formation's system. -/
theorem system_whole_of_common {c : C} (common : ∀ g, L.TakesPart W g c) :
    ∀ f g, L.WithinSystem W f g :=
  fun f g => WithinClosure.of_rel ⟨c, common f, common g⟩

/-- A common condition that every formation depends on and exchanges with makes every reach
closure the whole. -/
theorem reach_whole_of_common {c : C} (common : ∀ g, W.DependsOn g c ∧ L.Exchanges g c) :
    ∀ f g, L.WithinReach W f g :=
  fun f g => WithinClosure.of_rel ⟨c, (common g).1, (common f).2⟩

/-- A common condition that feeds makes the feeding closure the whole: where at one step every
formation takes part, requires one condition and gives to it, every formation lies within every
formation's feeding closure. -/
theorem feeding_whole_of_common {t : Nat} {c : C}
    (common : ∀ g, g ∈ L.present t ∧ W.requires t g c ∧ 0 < L.give t g c) :
    ∀ f g, L.WithinFeeding W f g :=
  fun f g => WithinClosure.of_rel ⟨t, rfl, c, (common f).2.1, (common g).1, (common g).2.2⟩

/-- What lies beyond a formation's influence closure never exchanges with a condition that a
member of the closure depends on. -/
theorem beyond_influence {f g h : F} (within : L.WithinInfluence W f g)
    (beyond : ¬ L.WithinInfluence W f h) {c : C} (depends : W.DependsOn g c) :
    ¬ L.Exchanges h c :=
  fun exchanges => WithinClosure.not_rel within beyond ⟨c, depends, exchanges⟩

/-! ## Levels follow their exchanges -/

/-- Two balanced flows that start a condition at the same level, and take from it and give to
it the same totals across every step, keep it at the same level at every step. -/
theorem Balances.levels_agree {L' : Flow F C} {W' : Web F C} (balances : L.Balances W)
    (balances' : L'.Balances W') {c : C} (start : W.level 0 c = W'.level 0 c)
    (taken : ∀ t, L.taken t c = L'.taken t c) (given : ∀ t, L.given t c = L'.given t c) :
    ∀ t, W.level t c = W'.level t c
  | 0 => start
  | t + 1 => add_right_cancel (L.taken t c)
      ((balances t c).trans
        ((congrArg (· + L.given t c)
            (Balances.levels_agree balances balances' start taken given t)).trans
          ((congrArg (W'.level t c + ·) (given t)).trans
            ((balances' t c).symm.trans (congrArg (W'.level (t + 1) c + ·) (taken t).symm)))))

/-- A formation's support follows only the exchanges with what it depends on. Let two
balanced flows, on webs that agree on what `g` requires and needs, start alike and take and
give alike on every condition `g` depends on. Then `g` is supported alike at every step,
whatever else the two flows do. -/
theorem Balances.support_agrees {L' : Flow F C} {W' : Web F C} (balances : L.Balances W)
    (balances' : L'.Balances W') {g : F}
    (requires : ∀ t c, W.requires t g c ↔ W'.requires t g c)
    (need : ∀ t c, W.need t g c = W'.need t g c)
    (start : ∀ c, W.DependsOn g c → W.level 0 c = W'.level 0 c)
    (taken : ∀ t c, W.DependsOn g c → L.taken t c = L'.taken t c)
    (given : ∀ t c, W.DependsOn g c → L.given t c = L'.given t c) (t : Nat) :
    W.Supported t g ↔ W'.Supported t g :=
  have same : ∀ c, W.requires t g c → W.level t c = W'.level t c := fun c depends =>
    balances.levels_agree balances' (start c ⟨t, depends⟩) (fun s => taken s c ⟨t, depends⟩)
      (fun s => given s c ⟨t, depends⟩) t
  ⟨fun supported c depends' =>
     have depends := (requires t c).mpr depends'
     Nat.le_trans (Nat.le_of_eq (need t c).symm)
       (Nat.le_trans (supported c depends) (Nat.le_of_eq (same c depends))),
   fun supported c depends =>
     Nat.le_trans (Nat.le_of_eq (need t c))
       (Nat.le_trans (supported c ((requires t c).mp depends))
         (Nat.le_of_eq (same c depends).symm))⟩

/-! ## What a part reaches -/

variable {part : F → Bool}

/-- What a part does shows on a condition exactly through its net exchange with it: the
levels with and without the part agree at a step exactly when, before it, the part has given
the condition what it has taken from it. -/
theorem Balances.agrees_iff_even (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) (t : Nat) (c : C) :
    W.level t c = l t c ↔ total (steps 0 t) (fun s => L.partTaken part s c) =
      total (steps 0 t) (fun s => L.partGiven part s c) :=
  ⟨fun same => add_right_cancel (W.level t c)
      ((Nat.add_comm _ _).trans ((balances.withheld without t c).trans
        ((congrArg (· + total (steps 0 t) fun s => L.partGiven part s c) same.symm).trans
          (Nat.add_comm _ _)))),
   fun even => add_right_cancel (total (steps 0 t) fun s => L.partTaken part s c)
      ((balances.withheld without t c).trans (congrArg (l t c + ·) even.symm))⟩

/-- Withholding a part that gives a condition nothing never lowers it: the levels without such a
part are at least those with it. -/
theorem Balances.le_withheld (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {c : C} (none : ∀ s, L.partGiven part s c = 0)
    (t : Nat) : W.level t c ≤ l t c :=
  Nat.le_trans (Nat.le_add_right (W.level t c) (total (steps 0 t) fun s => L.partTaken part s c))
    (Nat.le_of_eq ((balances.withheld without t c).trans
      ((congrArg (l t c + ·) ((total_congr none (steps 0 t)).trans (total_zero (steps 0 t)))).trans
        (Nat.add_zero _))))

/-- Withholding a part that only takes shows as gain or nothing: whatever is supported with a
part that gives nothing to what it requires is admitted by the levels without it. -/
theorem Balances.admits_without_taker (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {t : Nat} {g : F}
    (none : ∀ c, W.requires t g c → ∀ s, L.partGiven part s c = 0)
    (supported : W.Supported t g) : W.Admits (l t) t g :=
  fun c depends => Nat.le_trans (supported c depends)
    (balances.le_withheld without (none c depends) t)

/-- A member's exchange outside a part vanishes from the part's totals. -/
theorem ite_part_zero {f : F} {q : Nat} (zero : part f = true → q = 0) :
    (if part f then q else 0) = 0 :=
  match part f, zero with
  | true, zero => zero rfl
  | false, _ => rfl

/-- What is positive in a part's totals belongs to a member. -/
theorem part_of_ite_pos {f : F} {q : Nat} (pos : 0 < if part f then q else 0) :
    part f = true ∧ 0 < q :=
  match part f, pos with
  | true, pos => ⟨rfl, pos⟩
  | false, pos => absurd pos (Nat.lt_irrefl 0)

/-- A part changes no level of a condition that none of its members exchanges with. -/
theorem Balances.agrees_of_quiet (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {c : C}
    (quiet : ∀ h, part h = true → ¬ L.Exchanges h c) (t : Nat) : W.level t c = l t c :=
  have taken : ∀ s, L.partTaken part s c = 0 := fun s =>
    total_eq_zero fun h present => ite_part_zero fun member =>
      eq_zero_of_not_pos fun takes => quiet h member ⟨s, present, .inl takes⟩
  have given : ∀ s, L.partGiven part s c = 0 := fun s =>
    total_eq_zero fun h present => ite_part_zero fun member =>
      eq_zero_of_not_pos fun gives => quiet h member ⟨s, present, .inr gives⟩
  (balances.agrees_iff_even without t c).mpr
    (((total_congr taken (steps 0 t)).trans (total_zero (steps 0 t))).trans
      ((total_congr given (steps 0 t)).trans (total_zero (steps 0 t))).symm)

/-- Where the levels with and without a part differ on a condition at a step, some member of the
part exchanged with the condition at an earlier step. -/
theorem Balances.exchanges_before_of_differs (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {t : Nat} {c : C} (differs : ¬ W.level t c = l t c) :
    ∃ h s, part h = true ∧ s < t ∧ h ∈ L.present s ∧ (0 < L.take s h c ∨ 0 < L.give s h c) :=
  match Nat.decLt 0 (total (steps 0 t) fun s => L.partTaken part s c) with
  | isTrue taken => match total_pos _ taken with
    | ⟨s, mem, pos⟩ => match total_pos _ pos with
      | ⟨h, present, pos'⟩ => match part_of_ite_pos pos' with
        | ⟨member, takes⟩ => ⟨h, s, member,
            Nat.lt_of_lt_of_le (steps_within mem) (Nat.le_of_eq (Nat.zero_add t)), present,
            .inl takes⟩
  | isFalse untaken => match Nat.decLt 0 (total (steps 0 t) fun s => L.partGiven part s c) with
    | isTrue given => match total_pos _ given with
      | ⟨s, mem, pos⟩ => match total_pos _ pos with
        | ⟨h, present, pos'⟩ => match part_of_ite_pos pos' with
          | ⟨member, gives⟩ => ⟨h, s, member,
              Nat.lt_of_lt_of_le (steps_within mem) (Nat.le_of_eq (Nat.zero_add t)), present,
              .inr gives⟩
    | isFalse ungiven => absurd ((balances.agrees_iff_even without t c).mpr
        ((eq_zero_of_not_pos untaken).trans (eq_zero_of_not_pos ungiven).symm)) differs

/-- Where the levels with and without a part differ on a condition at a step, some member of the
part exchanges with the condition. -/
theorem Balances.exchanges_of_differs (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {t : Nat} {c : C} (differs : ¬ W.level t c = l t c) :
    ∃ h, part h = true ∧ L.Exchanges h c :=
  match balances.exchanges_before_of_differs without differs with
  | ⟨h, s, member, _, present, exchanges⟩ => ⟨h, member, s, present, exchanges⟩

/-- At each condition a formation requires at a step, the levels with and without a part agree
there, or the part reaches the formation before that step. -/
theorem Balances.agrees_or_reaches_before (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {t : Nat} {g : F} {c : C}
    (requires : W.requires t g c) : W.level t c = l t c ∨ L.ReachesBefore W part t g :=
  match Nat.decEq (W.level t c) (l t c) with
  | isTrue same => .inl same
  | isFalse differs => match balances.exchanges_before_of_differs without differs with
    | ⟨h, s, member, before, present, exchanges⟩ =>
      .inr ⟨h, c, s, member, requires, before, present, exchanges⟩

/-- At each condition a formation requires, the levels with and without a part agree, or the
part reaches the formation. -/
theorem Balances.agrees_or_reaches (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {t : Nat} {g : F} {c : C}
    (requires : W.requires t g c) : W.level t c = l t c ∨ L.Reaches W part g :=
  match balances.agrees_or_reaches_before without requires with
  | .inl same => .inl same
  | .inr reached => .inr reached.reaches

/-- What a part has not reached before a step is admitted alike with and without it at that
step. -/
theorem Balances.admits_unreached_before (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {t : Nat} {g : F}
    (unreached : ¬ L.ReachesBefore W part t g) : W.Supported t g ↔ W.Admits (l t) t g :=
  have same : ∀ c, W.requires t g c → W.level t c = l t c := fun _ requires =>
    match balances.agrees_or_reaches_before without requires with
    | .inl same => same
    | .inr reached => absurd reached unreached
  ⟨fun supported c requires =>
     Nat.le_trans (supported c requires) (Nat.le_of_eq (same c requires)),
   fun admits c requires =>
     Nat.le_trans (admits c requires) (Nat.le_of_eq (same c requires).symm)⟩

/-- What a part does not reach is admitted alike with and without it, at every step. -/
theorem Balances.admits_unreached (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {g : F} (unreached : ¬ L.Reaches W part g)
    (t : Nat) : W.Supported t g ↔ W.Admits (l t) t g :=
  balances.admits_unreached_before without fun reached => unreached reached.reaches

/-- A part whose members all lie beyond `f`'s influence closure reaches nothing within it. -/
theorem unreached_within_influence {f : F}
    (beyond : ∀ h, part h = true → ¬ L.WithinInfluence W f h) {g : F}
    (within : L.WithinInfluence W f g) : ¬ L.Reaches W part g
  | ⟨h, member, affected⟩ => beyond h member (within.trans (WithinClosure.of_rel affected))

/-- Feedback carries nothing from beyond the influence closure. Where every member of a part lies
beyond `f`'s influence closure, each formation within the closure is supported with the part
exactly where the levels without it admit it, at every step: whatever the part ends beyond the
closure shows nowhere within it. -/
theorem Balances.uncoupled_beyond_influence (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {f : F}
    (beyond : ∀ h, part h = true → ¬ L.WithinInfluence W f h) :
    ∀ t g, L.WithinInfluence W f g → (W.Supported t g ↔ W.Admits (l t) t g) :=
  fun t _ within => balances.admits_unreached without (unreached_within_influence beyond within) t

/-! ## The comparison with and without a part is decided within what it reaches -/

variable {Pos : Type}

/-- What holds of one significance along the levels with and without a part holds of another
that, from `p`, has no more significance where the part has reached: retaining carries over. -/
theorem Balances.retains_transfer (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {sig sig' : Pos → Nat → F → Prop} {p : Pos}
    (fewer : ∀ t g, L.ReachesBefore W part t g → sig' p t g → sig p t g) :
    (W.Retains sig p W.level l → W.Retains sig' p W.level l) ∧
      (W.Retains sig p l W.level → W.Retains sig' p l W.level) :=
  ⟨fun retains t g significant admits c requires =>
     match balances.agrees_or_reaches_before without requires with
     | .inl same => Nat.le_trans (admits c requires) (Nat.le_of_eq same.symm)
     | .inr reached => retains t g (fewer t g reached significant) admits c requires,
   fun retains t g significant admits c requires =>
     match balances.agrees_or_reaches_before without requires with
     | .inl same => Nat.le_trans (admits c requires) (Nat.le_of_eq same)
     | .inr reached => retains t g (fewer t g reached significant) admits c requires⟩

/-- Not adding carries over the same way. -/
theorem Balances.not_adds_transfer (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {sig sig' : Pos → Nat → F → Prop} {p : Pos}
    (fewer : ∀ t g, L.ReachesBefore W part t g → sig' p t g → sig p t g) :
    (¬ W.Adds sig p W.level l → ¬ W.Adds sig' p W.level l) ∧
      (¬ W.Adds sig p l W.level → ¬ W.Adds sig' p l W.level) :=
  ⟨fun none ⟨t, g, significant, admits, not⟩ => not fun c requires =>
     match balances.agrees_or_reaches_before without requires with
     | .inl same => Nat.le_trans (admits c requires) (Nat.le_of_eq same)
     | .inr reached => absurd ⟨t, g, fewer t g reached significant, admits, not⟩ none,
   fun none ⟨t, g, significant, admits, not⟩ => not fun c requires =>
     match balances.agrees_or_reaches_before without requires with
     | .inl same => Nat.le_trans (admits c requires) (Nat.le_of_eq same.symm)
     | .inr reached => absurd ⟨t, g, fewer t g reached significant, admits, not⟩ none⟩

/-- **The comparison is local.** Two significances that agree, from `p`, at each step on everything
the part has reached before it compare the levels with and without the part alike: each retains
along them, both ways, exactly where the other does, and adds exactly where the other does. -/
theorem Balances.comparison_local (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {sig sig' : Pos → Nat → F → Prop} {p : Pos}
    (agree : ∀ t g, L.ReachesBefore W part t g → (sig p t g ↔ sig' p t g)) :
    (W.Retains sig p W.level l ↔ W.Retains sig' p W.level l) ∧
      (W.Retains sig p l W.level ↔ W.Retains sig' p l W.level) ∧
      (¬ W.Adds sig p W.level l ↔ ¬ W.Adds sig' p W.level l) ∧
      (¬ W.Adds sig p l W.level ↔ ¬ W.Adds sig' p l W.level) :=
  have forth := fun t g reached => (agree t g reached).mpr
  have back := fun t g reached => (agree t g reached).mp
  ⟨⟨(balances.retains_transfer without forth).1, (balances.retains_transfer without back).1⟩,
   ⟨(balances.retains_transfer without forth).2, (balances.retains_transfer without back).2⟩,
   ⟨(balances.not_adds_transfer without forth).1, (balances.not_adds_transfer without back).1⟩,
   ⟨(balances.not_adds_transfer without forth).2, (balances.not_adds_transfer without back).2⟩⟩

/-- **The comparison is decided within what the part reaches.** For any significance that, from
`p`, covers at each step the continuation of everything the part has reached before it, the
levels with the part retain what has significance along the levels without it exactly when they
include them, and the reverse, and neither adds a continuation with significance exactly when
neither exceeds the other. These are the comparisons the continuation condition gives
(`Web.retains_iff_includes`, `Web.adds_iff_exceeds` of `Becoming.Significance`); here they follow
from `comparison_local` with the significance that holds of everything, with no condition. -/
theorem Balances.comparison_within_reach (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {sig : Pos → Nat → F → Prop} {p : Pos}
    (covers : ∀ t g, L.ReachesBefore W part t g → sig p t g) :
    (W.Retains sig p W.level l ↔ W.Includes W.level l) ∧
      (W.Retains sig p l W.level ↔ W.Includes l W.level) ∧
      (¬ W.Adds sig p W.level l ↔ ¬ W.Exceeds W.level l) ∧
      (¬ W.Adds sig p l W.level ↔ ¬ W.Exceeds l W.level) :=
  have same := balances.comparison_local without (sig' := fun _ _ _ => True)
    fun t g reached => ⟨fun _ => trivial, fun _ => covers t g reached⟩
  have all : ∀ m m' : Nat → C → Nat,
      W.Retains (fun (_ : Pos) (_ : Nat) (_ : F) => True) p m m' ↔ W.Includes m m' :=
    fun _ _ => ⟨fun retains t f => retains t f trivial, fun includes => includes.retains _ p⟩
  ⟨same.1.trans (all _ _), same.2.1.trans (all _ _),
   same.2.2.1.trans ⟨fun none ⟨t, g, admits, not⟩ => none ⟨t, g, trivial, admits, not⟩,
     fun none adds => none adds.exceeds⟩,
   same.2.2.2.trans ⟨fun none ⟨t, g, admits, not⟩ => none ⟨t, g, trivial, admits, not⟩,
     fun none adds => none adds.exceeds⟩⟩

/-- With significance decidable, the adding comparisons hold in positive form: for a significance
covering, from `p`, what the part has reached before each step, the levels with and without it
add a continuation with significance exactly where they exceed each other. -/
theorem Balances.adds_iff_exceeds_of_decidable (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {sig : Pos → Nat → F → Prop} {p : Pos}
    (covers : ∀ t g, L.ReachesBefore W part t g → sig p t g)
    (decided : ∀ t g, Decidable (sig p t g)) :
    (W.Adds sig p W.level l ↔ W.Exceeds W.level l) ∧
      (W.Adds sig p l W.level ↔ W.Exceeds l W.level) :=
  ⟨⟨Web.Adds.exceeds, fun ⟨t, g, admits, not⟩ => match decided t g with
      | isTrue significant => ⟨t, g, significant, admits, not⟩
      | isFalse lacks => absurd ((balances.admits_unreached_before without
          fun reached => lacks (covers t g reached)).mp admits) not⟩,
   ⟨Web.Adds.exceeds, fun ⟨t, g, admits, not⟩ => match decided t g with
      | isTrue significant => ⟨t, g, significant, admits, not⟩
      | isFalse lacks => absurd ((balances.admits_unreached_before without
          fun reached => lacks (covers t g reached)).mpr admits) not⟩⟩

/-- For every significance, the adding comparisons hold up to double negation: for a significance
covering, from `p`, what the part has reached before each step, where the levels with and without
the part exceed each other, it is not the case that they add no continuation with
significance. -/
theorem Balances.not_not_adds_of_exceeds (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {sig : Pos → Nat → F → Prop} {p : Pos}
    (covers : ∀ t g, L.ReachesBefore W part t g → sig p t g) :
    (W.Exceeds W.level l → ¬ ¬ W.Adds sig p W.level l) ∧
      (W.Exceeds l W.level → ¬ ¬ W.Adds sig p l W.level) :=
  have same := balances.comparison_within_reach without covers
  ⟨fun exceeds none => same.2.2.1.mp none exceeds,
   fun exceeds none => same.2.2.2.mp none exceeds⟩

/-- The difference between two flows reaches `g` before `t`: `g` requires at `t` a condition
whose totals under the two flows differed at an earlier step. -/
def DiffersBefore (L L' : Flow F C) (W : Web F C) (t : Nat) (g : F) : Prop :=
  ∃ c s, W.requires t g c ∧ s < t ∧
    (¬ L.taken s c = L'.taken s c ∨ ¬ L.given s c = L'.given s c)

/-- Where the levels of two balanced flows from one start differ at a step, their totals on that
condition differed at an earlier step. -/
theorem Balances.differs_before {L' : Flow F C} {W' : Web F C} (balances : L.Balances W)
    (balances' : L'.Balances W') (start : ∀ c, W.level 0 c = W'.level 0 c) {c : C} :
    ∀ t, ¬ W.level t c = W'.level t c →
      ∃ s, s < t ∧ (¬ L.taken s c = L'.taken s c ∨ ¬ L.given s c = L'.given s c)
  | 0, differs => absurd (start c) differs
  | t + 1, differs => match Nat.decEq (W.level t c) (W'.level t c) with
    | isFalse earlier => match Balances.differs_before balances balances' start t earlier with
      | ⟨s, before, exchanges⟩ => ⟨s, Nat.lt_succ_of_lt before, exchanges⟩
    | isTrue same => match Nat.decEq (L.taken t c) (L'.taken t c),
        Nat.decEq (L.given t c) (L'.given t c) with
      | isFalse taken, _ => ⟨t, Nat.lt_succ_self t, .inl taken⟩
      | isTrue _, isFalse given => ⟨t, Nat.lt_succ_self t, .inr given⟩
      | isTrue taken, isTrue given => absurd (add_right_cancel (L'.taken t c)
          ((congrArg (W.level (t + 1) c + ·) taken.symm).trans ((balances t c).trans
            ((congrArg (· + L.given t c) same).trans ((congrArg (W'.level t c + ·) given).trans
              (balances' t c).symm))))) differs

/-- **The comparison between two flows is decided within what their difference reaches.** Let
two balanced flows start alike. For any significance that covers, from `p`, each formation the
difference between the flows reaches before each step, the levels of the one retain what has
significance along the levels of the other exactly when they include them, and the reverse, and
neither adds a continuation with significance exactly where neither exceeds the other. With the
rest of the exchange fixed the difference is a part's exchange (`comparison_within_reach`); where
others respond, it holds their responses as well. -/
theorem Balances.comparison_within_difference {L' : Flow F C} {W' : Web F C}
    (balances : L.Balances W) (balances' : L'.Balances W')
    (start : ∀ c, W.level 0 c = W'.level 0 c) {sig : Pos → Nat → F → Prop} {p : Pos}
    (covers : ∀ t g, DiffersBefore L L' W t g → sig p t g) :
    (W.Retains sig p W.level W'.level ↔ W.Includes W.level W'.level) ∧
      (W.Retains sig p W'.level W.level ↔ W.Includes W'.level W.level) ∧
      (¬ W.Adds sig p W.level W'.level ↔ ¬ W.Exceeds W.level W'.level) ∧
      (¬ W.Adds sig p W'.level W.level ↔ ¬ W.Exceeds W'.level W.level) :=
  have agrees : ∀ t g c, W.requires t g c →
      W.level t c = W'.level t c ∨ DiffersBefore L L' W t g := fun t _ c requires =>
    match Nat.decEq (W.level t c) (W'.level t c) with
    | isTrue same => .inl same
    | isFalse differs => match balances.differs_before balances' start t differs with
      | ⟨s, before, exchanges⟩ => .inr ⟨c, s, requires, before, exchanges⟩
  ⟨⟨fun retains t g admits c requires => match agrees t g c requires with
      | .inl same => Nat.le_trans (admits c requires) (Nat.le_of_eq same.symm)
      | .inr reached => retains t g (covers t g reached) admits c requires,
    fun includes => includes.retains sig p⟩,
   ⟨fun retains t g admits c requires => match agrees t g c requires with
      | .inl same => Nat.le_trans (admits c requires) (Nat.le_of_eq same)
      | .inr reached => retains t g (covers t g reached) admits c requires,
    fun includes => includes.retains sig p⟩,
   ⟨fun none ⟨t, g, admits, not⟩ => not fun c requires => match agrees t g c requires with
      | .inl same => Nat.le_trans (admits c requires) (Nat.le_of_eq same)
      | .inr reached => absurd ⟨t, g, covers t g reached, admits, not⟩ none,
    fun none adds => none adds.exceeds⟩,
   ⟨fun none ⟨t, g, admits, not⟩ => not fun c requires => match agrees t g c requires with
      | .inl same => Nat.le_trans (admits c requires) (Nat.le_of_eq same.symm)
      | .inr reached => absurd ⟨t, g, covers t g reached, admits, not⟩ none,
    fun none adds => none adds.exceeds⟩⟩

/-- What a part whose members lie within a region closed under affecting reaches lies within
it. -/
theorem reaches_within_closed {region : F → Prop} (closed : ClosedUnder (L.Affects W) region)
    (members : ∀ h, part h = true → region h) {g : F} : L.Reaches W part g → region g
  | ⟨h, member, affected⟩ => closed h g (members h member) affected

/-- What a part whose members lie within `f`'s reach closure reaches lies within it. -/
theorem reaches_withinReach {f : F} (members : ∀ h, part h = true → L.WithinReach W f h)
    {g : F} : L.Reaches W part g → L.WithinReach W f g :=
  reaches_within_closed (closedUnder_withinClosure f) members

/-- What a part whose members lie within `f`'s system reaches lies within it. -/
theorem reaches_withinSystem {f : F} (members : ∀ h, part h = true → L.WithinSystem W f h)
    {g : F} : L.Reaches W part g → L.WithinSystem W f g
  | ⟨h, member, c, depends, exchanges⟩ =>
    (members h member).trans (WithinClosure.of_rel ⟨c, .inr exchanges, .inl depends⟩)

/-- A part whose members all lie beyond `f`'s system reaches nothing within it. -/
theorem unreached_within_system {f : F}
    (beyond : ∀ h, part h = true → ¬ L.WithinSystem W f h) {g : F}
    (within : L.WithinSystem W f g) : ¬ L.Reaches W part g
  | ⟨h, member, affected⟩ =>
    beyond h member (within.trans (WithinClosure.of_rel (shares_of_affectedBy affected)))

/-- A formation's own part has its members within its reach closure. -/
theorem own_within_reach {f : F} (own : ∀ h, part h = true → h = f) :
    ∀ h, part h = true → L.WithinReach W f h :=
  fun h member => Eq.subst (motive := fun x => L.WithinReach W f x) (own h member).symm
    (WithinClosure.refl f)

/-- A formation's own part has its members within its system. -/
theorem own_within_system {f : F} (own : ∀ h, part h = true → h = f) :
    ∀ h, part h = true → L.WithinSystem W f h :=
  fun h member => withinSystem_of_withinReach (own_within_reach own h member)

/-- The system is closed under affecting. -/
theorem withinSystem_closed (f : F) : ClosedUnder (L.Affects W) (L.WithinSystem W f) :=
  fun _ _ within affects =>
    within.trans (WithinClosure.of_rel (shares_symm (shares_of_affectedBy affects)))

/-- Significance bounded by a region closed under affecting compares as inclusion does. Let
standpoint `p`'s region be closed under affecting and hold every member of a part. Then, from `p`,
significance bounded by the regions retains along the levels with and without the part exactly
as they include each other, both ways, and neither adds exactly where neither exceeds the other.
The reach closure is the least such region holding a center (`closedUnder_withinClosure`), and the
system is one (`withinSystem_closed`). -/
theorem Balances.closed_comparison (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {region : Pos → F → Prop} {p : Pos}
    (closed : ClosedUnder (L.Affects W) (region p)) (members : ∀ h, part h = true → region p h) :
    (W.Retains (bounded region) p W.level l ↔ W.Includes W.level l) ∧
      (W.Retains (bounded region) p l W.level ↔ W.Includes l W.level) ∧
      (¬ W.Adds (bounded region) p W.level l ↔ ¬ W.Exceeds W.level l) ∧
      (¬ W.Adds (bounded region) p l W.level ↔ ¬ W.Exceeds l W.level) :=
  balances.comparison_within_reach without fun _ _ reached =>
    reaches_within_closed closed members reached.reaches

end Flow

/-! ## Witnesses -/

/-! A trophic cascade: wolves affect a forest through deer, without feeding it. -/

namespace Trophic

/-- A sun, a forest, deer, wolves, and a formation far off. -/
inductive Formation where
  | sun
  | forest
  | deer
  | wolves
  | far

/-- The forest's growth, the deer's herd, and the far formation's den. -/
inductive Place where
  | growth
  | herd
  | den

/-- Everything takes part at every step. -/
def members : List Formation := [.sun, .forest, .deer, .wolves, .far]

/-- With the wolves, the deer browse two units of the growth across the first step only. -/
def browse : Nat → Nat := Witnesses.profile [2] 0

/-- The wolves take the herd's one unit across the first step. -/
def hunt : Nat → Nat := Witnesses.profile [1] 0

/-- The growth stands at two, falls to one across the first step, and then rises by one at each
step. -/
def growthLevel : Nat → Nat
  | 0 => 2
  | t + 1 => t + 1

/-- The herd stands at one until the wolves take it. -/
def herdLevel : Nat → Nat := Witnesses.profile [1] 0

/-- With the wolves, the deer are active at the first step only. -/
def deerLive : Nat → Prop := Witnesses.profile [True] False

/-- With the wolves: across every step the sun gives the growth one unit; across the first step
the deer take two units of the growth and the wolves take the herd's one unit. -/
def flow : Flow Formation Place where
  present _ := members
  take t f c := match f, c with
    | .sun, _ => 0
    | .forest, _ => 0
    | .deer, .growth => browse t
    | .deer, .herd => 0
    | .deer, .den => 0
    | .wolves, .growth => 0
    | .wolves, .herd => hunt t
    | .wolves, .den => 0
    | .far, _ => 0
  give _ f c := match f, c with
    | .sun, .growth => 1
    | .sun, .herd => 0
    | .sun, .den => 0
    | .forest, _ => 0
    | .deer, _ => 0
    | .wolves, _ => 0
    | .far, _ => 0

/-- The forest requires the growth, the deer the herd, and the far formation its den, each at
need one; the den stays at one. The deer draw on the growth and the wolves on the herd. -/
def web : Web Formation Place where
  level t c := match c with
    | .growth => growthLevel t
    | .herd => herdLevel t
    | .den => 1
  active t f := match f with
    | .sun => True
    | .forest => True
    | .deer => deerLive t
    | .wolves => True
    | .far => True
  requires _ f c := match f, c with
    | .sun, _ => False
    | .forest, .growth => True
    | .forest, .herd => False
    | .forest, .den => False
    | .deer, .growth => False
    | .deer, .herd => True
    | .deer, .den => False
    | .wolves, _ => False
    | .far, .growth => False
    | .far, .herd => False
    | .far, .den => True
  need _ _ _ := 1
  draws _ f c := match f, c with
    | .sun, _ => False
    | .forest, _ => False
    | .deer, .growth => True
    | .deer, .herd => False
    | .deer, .den => False
    | .wolves, .growth => False
    | .wolves, .herd => True
    | .wolves, .den => False
    | .far, _ => False

/-- Without the wolves' taking, the deer browse two units of the growth across each of the first
two steps and one across each later step. -/
def responsiveBrowse : Nat → Nat := Witnesses.profile [2, 2] 1

/-- The growth then falls from two to nothing over the first two steps and stays there. -/
def responsiveGrowth : Nat → Nat := Witnesses.profile [2, 1] 0

/-- The forest is then active at the first two steps only. -/
def forestLive : Nat → Prop := Witnesses.profile [True, True] False

/-- The flow in which the deer respond to the wolves' absence: the deer browse as
`responsiveBrowse` gives; the sun gives as before. -/
def responsiveFlow : Flow Formation Place where
  present _ := members
  take t f c := match f, c with
    | .sun, _ => 0
    | .forest, _ => 0
    | .deer, .growth => responsiveBrowse t
    | .deer, .herd => 0
    | .deer, .den => 0
    | .wolves, _ => 0
    | .far, _ => 0
  give := flow.give

/-- The herd stays at one; the forest is active at the first two steps only, everything else
throughout. -/
def responsiveWeb : Web Formation Place where
  level t c := match c with
    | .growth => responsiveGrowth t
    | .herd => 1
    | .den => 1
  active t f := match f with
    | .sun => True
    | .forest => forestLive t
    | .deer => True
    | .wolves => True
    | .far => True
  requires := web.requires
  need := web.need
  draws := web.draws

theorem balances : flow.Balances web
  | 0, .growth => rfl
  | _ + 1, .growth => rfl
  | 0, .herd => rfl
  | _ + 1, .herd => rfl
  | _, .den => rfl

theorem acting : flow.Acting web
  | _, .sun, _, _, _ => trivial
  | _, .forest, _, _, _ => trivial
  | _, .deer, _, _, gives => absurd gives (Nat.lt_irrefl 0)
  | _, .wolves, _, _, _ => trivial
  | _, .far, _, _, _ => trivial

theorem taking : flow.Taking web
  | _, .sun, _, _, takes => absurd takes (Nat.lt_irrefl 0)
  | _, .forest, _, _, takes => absurd takes (Nat.lt_irrefl 0)
  | 0, .deer, .growth, _, _ => ⟨trivial, trivial⟩
  | _ + 1, .deer, .growth, _, takes => absurd takes (Nat.lt_irrefl 0)
  | _, .deer, .herd, _, takes => absurd takes (Nat.lt_irrefl 0)
  | _, .deer, .den, _, takes => absurd takes (Nat.lt_irrefl 0)
  | _, .wolves, .growth, _, takes => absurd takes (Nat.lt_irrefl 0)
  | 0, .wolves, .herd, _, _ => ⟨trivial, trivial⟩
  | _ + 1, .wolves, .herd, _, takes => absurd takes (Nat.lt_irrefl 0)
  | _, .wolves, .den, _, takes => absurd takes (Nat.lt_irrefl 0)
  | _, .far, _, _, takes => absurd takes (Nat.lt_irrefl 0)

theorem dependent : web.Dependent
  | _, .sun, _, _, no => nomatch no
  | 0, .forest, _, .growth, _ => Nat.succ_le_succ (Nat.zero_le 1)
  | _ + 1, .forest, _, .growth, _ => Nat.succ_le_succ (Nat.zero_le _)
  | _, .forest, _, .herd, no => nomatch no
  | _, .forest, _, .den, no => nomatch no
  | 0, .deer, _, .growth, no => nomatch no
  | 0, .deer, _, .herd, _ => Nat.le_refl 1
  | 0, .deer, _, .den, no => nomatch no
  | _ + 1, .deer, dead, _, _ => nomatch dead
  | _, .wolves, _, _, no => nomatch no
  | _, .far, _, .growth, no => nomatch no
  | _, .far, _, .herd, no => nomatch no
  | _, .far, _, .den, _ => Nat.le_refl 1

theorem responsive_balances : responsiveFlow.Balances responsiveWeb
  | 0, .growth => rfl
  | 1, .growth => rfl
  | _ + 2, .growth => rfl
  | _, .herd => rfl
  | _, .den => rfl

theorem responsive_acting : responsiveFlow.Acting responsiveWeb
  | _, .sun, _, _, _ => trivial
  | _, .forest, _, _, gives => absurd gives (Nat.lt_irrefl 0)
  | _, .deer, _, _, _ => trivial
  | _, .wolves, _, _, _ => trivial
  | _, .far, _, _, _ => trivial

theorem responsive_taking : responsiveFlow.Taking responsiveWeb
  | _, .sun, _, _, takes => absurd takes (Nat.lt_irrefl 0)
  | _, .forest, _, _, takes => absurd takes (Nat.lt_irrefl 0)
  | _, .deer, .growth, _, _ => ⟨trivial, trivial⟩
  | _, .deer, .herd, _, takes => absurd takes (Nat.lt_irrefl 0)
  | _, .deer, .den, _, takes => absurd takes (Nat.lt_irrefl 0)
  | _, .wolves, _, _, takes => absurd takes (Nat.lt_irrefl 0)
  | _, .far, _, _, takes => absurd takes (Nat.lt_irrefl 0)

theorem responsive_dependent : responsiveWeb.Dependent
  | _, .sun, _, _, no => nomatch no
  | 0, .forest, _, .growth, _ => Nat.succ_le_succ (Nat.zero_le 1)
  | 0, .forest, _, .herd, no => nomatch no
  | 0, .forest, _, .den, no => nomatch no
  | 1, .forest, _, .growth, _ => Nat.le_refl 1
  | 1, .forest, _, .herd, no => nomatch no
  | 1, .forest, _, .den, no => nomatch no
  | _ + 2, .forest, dead, _, _ => nomatch dead
  | _, .deer, _, .growth, no => nomatch no
  | _, .deer, _, .herd, _ => Nat.le_refl 1
  | _, .deer, _, .den, no => nomatch no
  | _, .wolves, _, _, no => nomatch no
  | _, .far, _, .growth, no => nomatch no
  | _, .far, _, .herd, no => nomatch no
  | _, .far, _, .den, _ => Nat.le_refl 1

/-- The forest and the sun: nothing else gives to a condition either of them requires. -/
def fed : Formation → Prop
  | .sun => True
  | .forest => True
  | .deer => False
  | .wolves => False
  | .far => False

theorem fed_closed : flow.FedClosed web fed
  | .sun, _, _, ⟨_, _, _, no, _, _⟩ => nomatch no
  | .forest, .sun, _, _ => trivial
  | .forest, .forest, _, ⟨_, _, _, _, _, gives⟩ => absurd gives (Nat.lt_irrefl 0)
  | .forest, .deer, _, ⟨_, _, _, _, _, gives⟩ => absurd gives (Nat.lt_irrefl 0)
  | .forest, .wolves, _, ⟨_, _, _, _, _, gives⟩ => absurd gives (Nat.lt_irrefl 0)
  | .forest, .far, _, ⟨_, _, _, _, _, gives⟩ => absurd gives (Nat.lt_irrefl 0)
  | .deer, _, no, _ => nomatch no
  | .wolves, _, no, _ => nomatch no
  | .far, _, no, _ => nomatch no

/-- Everything but the far formation. -/
def near : Formation → Prop
  | .sun => True
  | .forest => True
  | .deer => True
  | .wolves => True
  | .far => False

/-- The far formation takes part in its den only. -/
theorem den_of_far {c : Place} : flow.TakesPart web .far c → c = .den
  | .inl ⟨_, depends⟩ => match c, depends with
    | .growth, no => nomatch no
    | .herd, no => nomatch no
    | .den, _ => rfl
  | .inr ⟨_, _, .inl takes⟩ => absurd takes (Nat.lt_irrefl 0)
  | .inr ⟨_, _, .inr gives⟩ => absurd gives (Nat.lt_irrefl 0)

/-- Only the far formation takes part in the den. -/
theorem far_of_den {g : Formation} : flow.TakesPart web g .den → g = .far
  | .inl ⟨_, depends⟩ => match g, depends with
    | .sun, no => nomatch no
    | .forest, no => nomatch no
    | .deer, no => nomatch no
    | .wolves, no => nomatch no
    | .far, _ => rfl
  | .inr ⟨_, _, exchanges⟩ => match g, exchanges with
    | .sun, .inl takes => absurd takes (Nat.lt_irrefl 0)
    | .sun, .inr gives => absurd gives (Nat.lt_irrefl 0)
    | .forest, .inl takes => absurd takes (Nat.lt_irrefl 0)
    | .forest, .inr gives => absurd gives (Nat.lt_irrefl 0)
    | .deer, .inl takes => absurd takes (Nat.lt_irrefl 0)
    | .deer, .inr gives => absurd gives (Nat.lt_irrefl 0)
    | .wolves, .inl takes => absurd takes (Nat.lt_irrefl 0)
    | .wolves, .inr gives => absurd gives (Nat.lt_irrefl 0)
    | .far, _ => rfl

/-- Nothing near shares a condition with the far formation. -/
theorem near_closed : ClosedUnder (flow.Shares web) near
  | _, .sun, _, _ => trivial
  | _, .forest, _, _ => trivial
  | _, .deer, _, _ => trivial
  | _, .wolves, _, _ => trivial
  | g, .far, inside, ⟨_, part, partFar⟩ =>
    Eq.subst (motive := near)
      (far_of_den (Eq.subst (motive := fun c => flow.TakesPart web g c) (den_of_far partFar) part))
      inside

/-- The wolves affect the forest without feeding it. In both flows the flow balances, only active
formations give, only active formations take and only from what they draw on, and activity needs
support; the sun gives the growth one unit at every step, and the deer take from the growth at
every step at which they are active. With the wolves taking the herd at the first step, the deer
are active at the first step only and the forest is active and supported at every step. Without
the wolves' taking, the deer stay active and the forest is unsupported from the third step on.
The wolves give nothing to any condition at any step: they lie beyond the forest's feeding
closure and within its influence closure. The far formation lies within the whole and beyond the
forest's system. -/
theorem mediates :
    flow.Balances web ∧ flow.Acting web ∧ flow.Taking web ∧ web.Dependent ∧
      responsiveFlow.Balances responsiveWeb ∧ responsiveFlow.Acting responsiveWeb ∧
      responsiveFlow.Taking responsiveWeb ∧ responsiveWeb.Dependent ∧
      (∀ t, flow.give t .sun .growth = 1 ∧ responsiveFlow.give t .sun .growth = 1) ∧
      (∀ t, web.active t .deer → 0 < flow.take t .deer .growth) ∧
      (∀ t, responsiveWeb.active t .deer → 0 < responsiveFlow.take t .deer .growth) ∧
      (∀ t, web.active t .forest ∧ web.Supported t .forest) ∧
      (∀ n, ¬ responsiveWeb.Supported (n + 2) .forest) ∧
      (∀ t c, flow.give t .wolves c = 0) ∧
      ¬ flow.WithinFeeding web .forest .wolves ∧ flow.WithinInfluence web .forest .wolves ∧
      ¬ flow.WithinSystem web .forest .far :=
  have deerTake : ∀ t, web.active t .deer → 0 < flow.take t .deer .growth
    | 0, _ => Nat.succ_pos 1
    | _ + 1, dead => (nomatch dead)
  have deerTake' : ∀ t, responsiveWeb.active t .deer → 0 < responsiveFlow.take t .deer .growth
    | 0, _ => Nat.succ_pos 1
    | 1, _ => Nat.succ_pos 1
    | _ + 2, _ => Nat.succ_pos 0
  have browsed : flow.AffectedBy web .forest .deer :=
    ⟨.growth, ⟨0, trivial⟩, 0, .tail _ (.tail _ (.head _)), .inl (Nat.succ_pos 1)⟩
  have hunted : flow.AffectedBy web .deer .wolves :=
    ⟨.herd, ⟨0, trivial⟩, 0, .tail _ (.tail _ (.tail _ (.head _))), .inl Nat.zero_lt_one⟩
  ⟨balances, acting, taking, dependent, responsive_balances, responsive_acting, responsive_taking,
   responsive_dependent, fun _ => ⟨rfl, rfl⟩, deerTake, deerTake',
   fun t => ⟨trivial, dependent t .forest trivial⟩,
   fun _ supported => Nat.not_succ_le_zero 0 (supported .growth trivial),
   fun _ _ => rfl,
   fun within => within fed fed_closed trivial,
   (WithinClosure.of_rel browsed).trans (WithinClosure.of_rel hunted),
   fun within => within near near_closed trivial⟩

/-- The wolves' part. -/
def wolvesPart : Formation → Bool
  | .sun => false
  | .forest => false
  | .deer => false
  | .wolves => true
  | .far => false

/-- The levels without the wolves' part: the herd stays at one, and the growth and the den are as
with it. -/
def withoutWolves (t : Nat) : Place → Nat
  | .growth => growthLevel t
  | .herd => 1
  | .den => 1

theorem wolves_withheld : flow.WithheldLevels wolvesPart web withoutWolves :=
  ⟨fun t c => match t, c with
    | 0, .growth => rfl
    | _ + 1, .growth => rfl
    | _, .herd => rfl
    | _, .den => rfl,
   fun c => match c with
    | .growth => rfl
    | .herd => rfl
    | .den => rfl⟩

/-- The deer are admitted at the first step without the wolves' part and not with it. -/
theorem deer_without_wolves {l : Nat → Place → Nat}
    (without : flow.WithheldLevels wolvesPart web l) :
    web.Admits (l 1) 1 .deer ∧ ¬ web.Admits (web.level 1) 1 .deer :=
  ⟨fun c requires => match c, requires with
    | .growth, no => nomatch no
    | .herd, _ => Nat.le_of_eq (without.unique wolves_withheld 1 .herd).symm
    | .den, no => (nomatch no),
   fun admits => Nat.not_succ_le_zero 0 (admits .herd trivial)⟩

/-- The wolves' part does not reach the forest: the wolves exchange with the herd only, which the
forest does not depend on. -/
theorem wolves_unreached : ¬ flow.Reaches web wolvesPart .forest :=
  fun ⟨h, member, c, ⟨_, requires⟩, _, _, exchanges⟩ =>
    match h, member, c, requires, exchanges with
    | .sun, no, _, _, _ => nomatch no
    | .forest, no, _, _, _ => nomatch no
    | .deer, no, _, _, _ => nomatch no
    | .wolves, _, .growth, _, .inl takes => absurd takes (Nat.lt_irrefl 0)
    | .wolves, _, .growth, _, .inr gives => absurd gives (Nat.lt_irrefl 0)
    | .wolves, _, .herd, no, _ => nomatch no
    | .wolves, _, .den, no, _ => nomatch no
    | .far, no, _, _, _ => nomatch no

/-- The two comparisons reach differently. The wolves' part does not reach the forest, while the
difference between the flow with the wolves and the flow in which the deer respond reaches the
forest before the third step: the deer's browsing of the growth differs at the second. -/
theorem difference_reaches_forest :
    ¬ flow.Reaches web wolvesPart .forest ∧ flow.DiffersBefore responsiveFlow web 2 .forest :=
  ⟨wolves_unreached, .growth, 1, trivial, Nat.lt_succ_self 1,
   .inl fun same => Nat.noConfusion same⟩

/-- A part joining the far formation and the wolves. -/
def farWolvesPart : Formation → Bool
  | .sun => false
  | .forest => false
  | .deer => false
  | .wolves => true
  | .far => true

theorem farWolves_withheld : flow.WithheldLevels farWolvesPart web withoutWolves :=
  ⟨fun t c => match t, c with
    | 0, .growth => rfl
    | _ + 1, .growth => rfl
    | _, .herd => rfl
    | _, .den => rfl,
   fun c => match c with
    | .growth => rfl
    | .herd => rfl
    | .den => rfl⟩

/-- The far formation's system holds only itself. -/
theorem far_system {g : Formation} (within : flow.WithinSystem web .far g) : g = .far :=
  within (fun x => x = .far) (fun _ y inside ⟨_, part, part'⟩ =>
    far_of_den (Eq.subst (motive := fun c => flow.TakesPart web y c)
      (den_of_far (Eq.subst (motive := fun x => flow.TakesPart web x _) inside part)) part')) rfl

end Trophic

/-! Two formations depend on one condition that nothing exchanges with. -/

namespace Static

/-- Nothing takes part in any exchange. -/
def flow : Flow Bool Unit where
  present _ := []
  take _ _ _ := 0
  give _ _ _ := 0

/-- Both formations depend on the one condition at need one, and it stays at one. -/
def web : Web Bool Unit where
  level _ _ := 1
  active _ _ := True
  requires _ _ _ := True
  need _ _ _ := 1
  draws _ _ _ := False

/-- Sharing without affecting. The flow balances and activity needs support. The two formations
depend on one condition, so they share a system, while nothing exchanges with it, so neither
affects the other and neither lies within the other's influence closure. -/
theorem shares_unaffected :
    flow.Balances web ∧ web.Dependent ∧ flow.WithinSystem web true false ∧
      ¬ flow.AffectedBy web true false ∧ ¬ flow.WithinInfluence web true false :=
  ⟨fun _ _ => rfl, fun _ _ _ _ _ => Nat.le_refl 1,
   WithinClosure.of_rel ⟨(), .inl ⟨0, trivial⟩, .inl ⟨0, trivial⟩⟩,
   fun ⟨_, _, _, member, _⟩ => (nomatch member),
   fun within => Bool.noConfusion (within (fun x => x = true)
     (fun _ _ _ ⟨_, _, _, member, _⟩ => nomatch member) rfl)⟩

end Static

namespace Clearing

open Frontier (unburnt burning)

/-- The clearer and its source are closed under being affected: only they exchange with the
resource, and the source depends on nothing. -/
theorem alongDependence_closed : ClosedUnder (flow.AffectedBy web) alongDependence
  | .clearer, .source, _, _ => trivial
  | .clearer, .clearer, _, _ => trivial
  | .clearer, .dweller, _, ⟨.resource, _, _, _, .inl takes⟩ => absurd takes (Nat.lt_irrefl 0)
  | .clearer, .dweller, _, ⟨.resource, _, _, _, .inr gives⟩ => absurd gives (Nat.lt_irrefl 0)
  | .clearer, .dweller, _, ⟨.habitat, ⟨_, no⟩, _⟩ => nomatch no
  | .clearer, .dweller, _, ⟨.fuel _, ⟨_, no⟩, _⟩ => nomatch no
  | .source, _, _, ⟨_, ⟨_, no⟩, _⟩ => nomatch no
  | .dweller, _, no, _ => nomatch no

/-- The clearer's three levels. Its source lies within its feeding closure; the dweller lies
beyond its influence closure and within its system, through the habitat the clearer takes from
and the dweller depends on. -/
theorem levels :
    flow.WithinFeeding web .clearer .source ∧ ¬ flow.WithinInfluence web .clearer .dweller ∧
      flow.WithinSystem web .clearer .dweller :=
  ⟨(dependenceRegion_iff .clearer .source).mp trivial,
   fun within => within alongDependence alongDependence_closed trivial,
   WithinClosure.of_rel
     ⟨.habitat, .inr ⟨0, .tail _ (.head _), .inl Nat.zero_lt_one⟩, .inl ⟨0, trivial⟩⟩⟩

/-- Every formation lies within the clearer's system: the source gives to the resource the clearer
depends on, and the dweller depends on the habitat the clearer takes from. -/
theorem clearer_system : ∀ g, flow.WithinSystem web .clearer g
  | .source =>
    WithinClosure.of_rel ⟨.resource, .inl ⟨0, trivial⟩, .inr ⟨0, .head _, .inr Nat.zero_lt_one⟩⟩
  | .clearer => WithinClosure.refl _
  | .dweller => levels.2.2

/-- The clearer spares the habitat: the same flow, except that it takes nothing from the
habitat. -/
def sparedFlow : Flow Formation Place where
  present := flow.present
  take t f c := match f, c with
    | .clearer, .habitat => 0
    | .source, c => flow.take t .source c
    | .clearer, .resource => 1
    | .clearer, .fuel _ => 0
    | .dweller, _ => 0
  give := flow.give

/-- With the habitat spared it stays at two, and the dweller is active throughout. -/
def sparedWeb : Web Formation Place where
  level t c := match c with
    | .resource => 1
    | .habitat => 2
    | .fuel n => 2 * unburnt n t
  active _ f := match f with
    | .source => True
    | .clearer => True
    | .dweller => True
  requires := web.requires
  need := web.need
  draws := web.draws

theorem spared_balances : sparedFlow.Balances sparedWeb
  | _, .resource => rfl
  | _, .habitat => rfl
  | t, .fuel n => show 2 * unburnt n (t + 1) + (2 * burning n t + 0) = 2 * unburnt n t from
      (Nat.left_distrib 2 _ _).symm.trans (congrArg (2 * ·) (Frontier.burns n t))

theorem spared_dependent : sparedWeb.Dependent
  | _, .clearer, _, .resource, _ => Nat.le_refl 1
  | _, .dweller, _, .habitat, _ => Nat.succ_le_succ (Nat.zero_le 1)
  | _, .source, _, _, no => nomatch no
  | _, .clearer, _, .habitat, no => nomatch no
  | _, .clearer, _, .fuel _, no => nomatch no
  | _, .dweller, _, .resource, no => nomatch no
  | _, .dweller, _, .fuel _, no => nomatch no

/-- The clearer depends on its resource only. -/
theorem resource_of_clearer {c : Place} : web.DependsOn .clearer c → c = .resource
  | ⟨_, depends⟩ => match c, depends with
    | .resource, _ => rfl
    | .habitat, no => nomatch no
    | .fuel _, no => nomatch no

/-- What the clearer's own support carries does not show whether its clearing ends the
dweller. Both flows balance and in both activity needs support. The clearer's support is the
same at every step in both, as the general theorem gives, since the two flows exchange alike with
its resource; it is active and supported throughout. With the habitat spared the dweller is
active and supported at every step; with the habitat cleared it is inactive from the third step
on. -/
theorem uncoupled :
    sparedFlow.Balances sparedWeb ∧ sparedWeb.Dependent ∧
      (∀ t, web.Supported t .clearer ↔ sparedWeb.Supported t .clearer) ∧
      (∀ t, web.active t .clearer ∧ web.Supported t .clearer) ∧
      (∀ t, sparedWeb.active t .dweller ∧ sparedWeb.Supported t .dweller) ∧
      ∀ n, ¬ web.active (n + 2) .dweller :=
  ⟨spared_balances, spared_dependent,
   balances.support_agrees spared_balances (fun _ _ => Iff.rfl) (fun _ _ => rfl)
    (fun c depends => match c, resource_of_clearer depends with
      | _, rfl => rfl)
    (fun _ c depends => match c, resource_of_clearer depends with
      | _, rfl => rfl)
    (fun _ c depends => match c, resource_of_clearer depends with
      | _, rfl => rfl),
   fun t => ⟨trivial, dependent t .clearer trivial⟩,
   fun t => ⟨trivial, spared_dependent t .dweller trivial⟩,
   fun _ dead => dead⟩

/-- The clearer's part reaches the dweller: the clearer takes from the habitat the dweller
depends on. -/
theorem reaches_dweller : flow.Reaches web clearerPart .dweller :=
  ⟨.clearer, rfl, .habitat, ⟨0, trivial⟩, 0, .tail _ (.head _), .inl Nat.zero_lt_one⟩

/-- Significance bounded by the system counts the dweller; bounded by the influence closure it
does not. From the clearer's own standpoint, with each formation's significance bounded by its
system, the clearer's part loses the dweller and so does not retain what has significance;
bounded by each formation's influence closure, it retains. -/
theorem system_counts_dweller {l : Nat → Place → Nat}
    (without : flow.WithheldLevels clearerPart web l) :
    web.Adds (bounded (flow.WithinSystem web)) .clearer l web.level ∧
      ¬ web.Retains (bounded (flow.WithinSystem web)) .clearer web.level l ∧
      web.Retains (bounded (flow.WithinInfluence web)) .clearer web.level l :=
  have adds : web.Adds (bounded (flow.WithinSystem web)) .clearer l web.level :=
    ⟨2, .dweller, levels.2.2, admitted_without without 2, unsupported_with 0⟩
  ⟨adds, fun retains => retains.not_added adds,
   Web.retains_bounded_iff.mpr fun t => ((loses_beyond without).1 t).2.2.narrow
     fun _ within => within alongDependence alongDependence_closed trivial⟩

/-- The clearer and the dweller. -/
def clearerReach : Formation → Prop
  | .source => False
  | .clearer => True
  | .dweller => True

/-- Nothing the clearer or the dweller affects lies outside them. -/
theorem clearerReach_closed : ClosedUnder (flow.Affects web) clearerReach
  | .source, _, no, _ => nomatch no
  | .clearer, .source, _, ⟨_, ⟨_, no⟩, _⟩ => nomatch no
  | .clearer, .clearer, _, _ => trivial
  | .clearer, .dweller, _, _ => trivial
  | .dweller, _, _, ⟨_, _, _, _, .inl takes⟩ => absurd takes (Nat.lt_irrefl 0)
  | .dweller, _, _, ⟨_, _, _, _, .inr gives⟩ => absurd gives (Nat.lt_irrefl 0)

/-- The clearer's reach closure is a middle level. It holds the dweller, which lies beyond the
clearer's influence closure, and not the source, which lies within the clearer's influence
closure and its system. -/
theorem reach_middle :
    flow.WithinReach web .clearer .dweller ∧ ¬ flow.WithinReach web .clearer .source ∧
      flow.WithinInfluence web .clearer .source ∧ ¬ flow.WithinInfluence web .clearer .dweller ∧
      flow.WithinSystem web .clearer .source :=
  ⟨WithinClosure.of_rel ⟨.habitat, ⟨0, trivial⟩, 0, .tail _ (.head _), .inl Nat.zero_lt_one⟩,
   fun within => within clearerReach clearerReach_closed trivial,
   WithinClosure.of_rel ⟨.resource, ⟨0, trivial⟩, 0, .head _, .inr Nat.zero_lt_one⟩,
   levels.2.1, clearer_system .source⟩

/-- The reach closure is centred, not a class: the dweller, which exchanges with nothing, has only
itself within its reach closure, while the clearer's holds the dweller. -/
theorem reach_centred : ¬ flow.WithinReach web .dweller .clearer :=
  fun within => Formation.noConfusion (within (fun x => x = .dweller)
    (fun x _ inside ⟨_, _, _, _, exchanges⟩ => match x, inside, exchanges with
      | _, rfl, .inl takes => absurd takes (Nat.lt_irrefl 0)
      | _, rfl, .inr gives => absurd gives (Nat.lt_irrefl 0)) rfl)

/-- The clearer's part is its own. -/
theorem clearer_own : ∀ h, clearerPart h = true → h = .clearer
  | .source, no => nomatch no
  | .clearer, _ => rfl
  | .dweller, no => nomatch no

/-- The source's part. -/
def sourcePart : Formation → Bool
  | .source => true
  | .clearer => false
  | .dweller => false

/-- A comparison need not exist. With the rest of the exchange fixed the clearer keeps taking one
unit of the resource at every step, so no levels balance the flow without the source's part:
there is no withheld comparison of that part. -/
theorem no_levels_without_source : ¬ ∃ l, flow.WithheldLevels sourcePart web l :=
  fun ⟨l, step, start⟩ =>
    have first : l 1 .resource + 1 = l 0 .resource + 0 := step 0 .resource
    have second : l 2 .resource + 1 = l 1 .resource + 0 := step 1 .resource
    have one : l 1 .resource = 0 :=
      add_right_cancel 1 (first.trans (congrArg (· + 0) (start .resource)))
    Nat.noConfusion (second.trans (congrArg (· + 0) one))

end Clearing

/-! A part reaching beyond a formation's influence closure without being misjudged. -/

namespace Margin

/-- `true` takes one unit of the condition across the first step; `false` depends on it. -/
def flow : Flow Bool Unit where
  present _ := [true]
  take t f _ := match t, f with
    | 0, true => 1
    | 0, false => 0
    | _ + 1, _ => 0
  give _ _ _ := 0

/-- The condition stands at three and then at two; `false` needs one. -/
def web : Web Bool Unit where
  level t _ := match t with
    | 0 => 3
    | _ + 1 => 2
  active _ _ := True
  requires _ f _ := match f with
    | true => False
    | false => True
  need _ _ _ := 1
  draws _ _ _ := True

/-- The part of `true`. -/
def takerPart : Bool → Bool
  | true => true
  | false => false

theorem balances : flow.Balances web
  | 0, () => rfl
  | _ + 1, () => rfl

theorem withheld : flow.WithheldLevels takerPart web fun _ _ => 3 :=
  ⟨fun t () => match t with
    | 0 => rfl
    | _ + 1 => rfl,
   fun () => rfl⟩

/-- Covering what a part reaches is enough for the continuation condition's comparison, and not needed. The taker's
part reaches `false`, which lies beyond the taker's influence closure, yet the levels with and
without the part include each other, so every significance retains both ways: significance
stopping at the taker's influence closure judges the part as the continuation condition does. -/
theorem reach_without_misjudgment {l : Nat → Unit → Nat}
    (without : flow.WithheldLevels takerPart web l) :
    flow.Reaches web takerPart false ∧ ¬ flow.WithinInfluence web true false ∧
      web.Includes web.level l ∧ web.Includes l web.level :=
  ⟨⟨true, rfl, (), ⟨0, trivial⟩, 0, .head _, .inl Nat.zero_lt_one⟩,
   fun within => Bool.noConfusion (within (fun x => x = true)
     (fun x _ inside ⟨_, ⟨_, depends⟩, _⟩ => match x, inside, depends with
       | _, rfl, no => nomatch no) rfl),
   fun t f _ c requires => match f, c, requires with
    | true, _, no => nomatch no
    | false, (), _ => match t with
      | 0 => Nat.succ_le_succ (Nat.zero_le 2)
      | _ + 1 => Nat.succ_le_succ (Nat.zero_le 1),
   balances.opens_nothing without fun _ _ => Nat.zero_le _⟩

end Margin

/-! Affected without effect: the exchange comes after the dependence. -/

namespace Late

/-- `false` takes one unit across the second step only. -/
def flow : Flow Bool Unit where
  present _ := [false]
  take t f _ := match t, f with
    | 0, _ => 0
    | 1, true => 0
    | 1, false => 1
    | _ + 2, _ => 0
  give _ _ _ := 0

/-- `true` requires the condition at the first step only. -/
def web : Web Bool Unit where
  level t _ := match t with
    | 0 => 2
    | 1 => 2
    | _ + 2 => 1
  active _ _ := True
  requires t f _ := match f with
    | true => t = 0
    | false => False
  need _ _ _ := 1
  draws _ _ _ := True

/-- The part of `false`. -/
def latePart : Bool → Bool
  | true => false
  | false => true

theorem balances : flow.Balances web
  | 0, () => rfl
  | 1, () => rfl
  | _ + 2, () => rfl

theorem withheld : flow.WithheldLevels latePart web fun _ _ => 2 :=
  ⟨fun t () => match t with
    | 0 => rfl
    | 1 => rfl
    | _ + 2 => rfl,
   fun () => rfl⟩

/-- Affected without effect. `true` is affected by `false`, and `false`'s part reaches it, yet
at no step has the part reached `true` before it: the exchange comes after the only step at which
`true` depends on the condition. So `true` is supported and admitted without the part at every
step, which the comparison ordered in time gives and the one without order does not. -/
theorem affected_without_effect {l : Nat → Unit → Nat}
    (without : flow.WithheldLevels latePart web l) :
    flow.AffectedBy web true false ∧ flow.Reaches web latePart true ∧
      (∀ t, ¬ flow.ReachesBefore web latePart t true) ∧
      ∀ t, web.Supported t true ∧ web.Admits (l t) t true :=
  have affected : flow.AffectedBy web true false :=
    ⟨(), ⟨0, rfl⟩, 1, .head _, .inl Nat.zero_lt_one⟩
  have unreached : ∀ t, ¬ flow.ReachesBefore web latePart t true :=
    fun t ⟨_, (), s, _, requires, before, _, _⟩ =>
      Nat.not_lt_zero s (Eq.subst (motive := fun x => s < x) (show t = 0 from requires) before)
  have supported : ∀ t, web.Supported t true
    | 0 => fun () _ => Nat.succ_le_succ (Nat.zero_le 1)
    | _ + 1 => fun () no => Nat.noConfusion no
  ⟨affected, ⟨false, rfl, affected⟩, unreached, fun t =>
   ⟨supported t, (balances.admits_unreached_before without (unreached t)).mp (supported t)⟩⟩

end Late

end Becoming
