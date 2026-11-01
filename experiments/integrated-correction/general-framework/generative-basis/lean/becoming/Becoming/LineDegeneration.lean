import Becoming.KeepingWidening

/-!
# Degeneration on the base, constructively (基上之尽)

`Becoming.MapInstances` reads the old base on the map: occurrences `(t, f)`, 缘 one step of a
continuation `R` (`Web.continuationStep R`), the pattern read as activity (`Web.activityClass W`).
There, a line from an active occurrence along which nothing reached at some step `N` is active does
not go on (`Web.not_endless_of_gone`), and, where going on is decided at the points of the line, it
reaches an end (有终, `Web.degenerates_of_gone`, whose name is older than the distinction). This
module shows that such a line, with no decision, ends on every branch (尽): the pattern degenerates
(退化). It does so at every class finer than activity, so the activity grain and the kind grain of
`Becoming.KeepingWidening` (`Web.kindClass W Q`, activity together with one kind `Q`) are both
instances.

Results.

* **Ending at a step ends the line before it.** Along any class `E`, where everything the line from
  `x` reaches at a step `N` not before `x` ends on every branch, `x` ends on every branch
  (`Web.ends_of_ends_at`). The proof is by induction on the steps left, `N − y.1`: a continuation
  lies one step later (`continuationStep`). No excluded middle enters, and no premise that each
  occurrence has one continuation: the line may branch, and every branch is followed.
* **The constructive degeneration law, at every class finer than activity.** Let `E` be a class
  included in activity (`«则» E W.activityClass`). From an active occurrence `x`, where every
  occurrence the line under `E` reaches at a step `N` not before `x` is inactive, the line ends on
  every branch: the pattern read at `E` degenerates (`Web.every_branch_ends_of_gone`). What the line
  under `E` reaches lies on the line under activity (`Web.reached_coarser`, by `«粗化»` and
  `«及之单调»`), so it is active (`Web.active_along_finer`); nothing is reached at `N`, and
  `Web.ends_of_ends_at` applies vacuously there. What carries the law is the uniform horizon:
  where nothing the line reaches lies at step `N`, it ends on every branch at any class, by
  `Web.ends_of_ends_at` applied vacuously, with no activity at all; the law states that horizon
  through activity, and a class within activity is what lets it. Its two instances: activity itself,
  with exactly
  the premises of `Web.not_endless_of_gone` (`Web.activity_every_branch_ends_of_gone`), and the
  kind class, for every kind relation `Q` and every continuation `R`, the lineage continuation
  `Web.withinKind W Q passes` included (`Web.kind_every_branch_ends_of_gone`). The name keeps the
  law apart from the landed `Web.degenerates_of_gone`, which concludes only an end (有终).
* **The three regimes degenerate, through one step each.** Each regime of `Becoming.MapInstances`
  makes an occurrence at its step inactive, stated once, pointwise (`Web.consumed_held_gone`,
  `Web.family_excess_gone`, `Web.stopped_gone`). From that step, under exactly the hypotheses of
  `Web.consumed_held_not_endless`, `Web.family_excess_not_endless` and `Web.stopped_not_endless`,
  the line degenerates (`Web.consumed_held_degenerates`, `Web.family_excess_degenerates`,
  `Web.stopped_degenerates`). The landed laws that the line does not go on then follow from
  degeneration through `«尽则非不穷»`; `Web.Restated` derives each of them so, with the landed
  statement, as a demonstration of the placement below them in `Becoming.MapInstances`
  (`Web.Restated.not_endless_of_gone`, `Web.Restated.consumed_held_not_endless`,
  `Web.Restated.family_excess_not_endless`, `Web.Restated.stopped_not_endless`), and
  `Web.degenerates_of_gone` as the law together with the decision
  (`Web.Restated.degenerates_of_gone`).
  These restate landed laws and are no result.
* **Witnesses.** The hypotheses of each law hold together, from an active start. For the three
  regimes the line also takes a step before it degenerates, each stated by a «续» lemma:
  - the regime of consumption, in a web of one formation active at steps `0` and `1`, depending at
    need one on a condition whose level falls from one to zero after step `1`, read along every
    continuation (`Map.Depleted.degenerates`; the line takes its step from `0` to `1`,
    `Map.Depleted.continues`);
  - the regime of a whole drawing beyond renewal, in `Coupled` of `Becoming.Continuation`, the taker
    and the renewer of a patch read as one family, read along every continuation
    (`Map.coupled_degenerates`; the taker's line takes its step from `0` to `1`,
    `Map.coupled_continues`);
  - the regime of passing that stops, in the stopped relay of `Becoming.PatternPassing`, at every
    stopping step `T` (`Map.stopped_relay_degenerates`; the first carrier's line takes its step
    from `0` to `1`, `Map.stopped_relay_continues`);
  - the law at the activity and the kind grain, in `Map.Undecided` below, at every proposition and
    every kind relation (`Map.Undecided.degenerates`, `Map.Undecided.kind_degenerates`); there the
    line takes its step exactly where the proposition holds (`Map.Undecided.first_continues` one
    way, `Map.Undecided.first_has_next_iff` both), and at a proposition that fails it takes none.
  In the witnesses of consumption and of a whole drawing the dependence premise (`held`) is shown
  at every occurrence, reached or not; the stopped relay has no such premise, its inactivity at
  `T + d` coming from passing, brevity and stopping alone. In all three the web's activity is
  given, not derived from the regime: the witnesses show that the full premise sets can hold
  together on an active start, not that a regime is what ends the line.
* **Ending on every branch and reaching an end.** Ending on every branch reaches an end up to double
  negation (`Map.not_not_end_of_ends`), and reaches an end where going on is decided at the points
  of the line (`Map.end_of_ends_decided`). Both are stated on the grammar, at any carrier and
  relations. The decision cannot be dropped. On the grammar: on two points, with one step from
  `false` to `true` taken exactly where a proposition `P` holds, under the one, the line from
  `false` ends on every branch, while an end decides `P` (`Map.StepWhere.ends`,
  `Map.StepWhere.has_next_iff`, `Map.StepWhere.end_decides`); so that every line ending on every
  branch reaches an end, at every carrier and relation, is exactly excluded middle
  (`Map.end_of_ends_iff_excluded_middle`, whose forward direction uses this witness alone). On the
  base: in a web with one occurrence active at step `0`, one at step `1` and none from step `2`,
  continued exactly where `P` holds, the premise of the law holds and the pattern degenerates,
  while an end decides `P` (`Map.Undecided.degenerates`, `Map.Undecided.end_decides`); so that
  every line meeting the law's premise reaches an end, at every web and continuation, is exactly
  excluded middle (`Map.end_of_gone_iff_excluded_middle`): the decision premise of
  `Web.degenerates_of_gone` is as strong as excluded middle, and what the base gives without it is
  degeneration.

How this calibration differs from the two landed ones of `Becoming.GrammarMap`. There
`«不穷有终之定当且仅当排中»` asks every point to be placed as never ending or reaching an end, and
`«延尽之定当且仅当排中»` asks every point to be placed as going on along some branch or ending on every
branch: both ask which region a point lies in, and what is undecided is whether a course goes on
without end. Here the region is already known: the points asked about end on every branch, and in
`Map.end_of_gone_iff_excluded_middle` they do so by a step `N` given in advance, for every branch.
What is asked is where an end lies. All three are equivalent to excluded middle, hence to each
other. What the need says about the unfolding: a line known to end on every branch, within a known
horizon, does not thereby show a point at which it ends; showing one is deciding, at the points of
the line, whether a step continues it. In `Map.Undecided` the horizon is step `2`, two steps after
the start, and the start is continued exactly where `P` holds (`Map.Undecided.first_has_next_iff`),
its continuation ending (`Map.Undecided.last_ends`): nothing infinite is undecided, only whether one
relation holds (whether step `0` is continued). On the grammar the same holds of one step on two
points (`Map.StepWhere`). On the base, constructively, degeneration is the region a known horizon
gives; reaching an end is the further step that decided continuation supplies.

Placement. This module is a core leaf: no existing module changed, so the core holds no statement
twice except the labelled restatements of `Web.Restated`, which are no result. Moves are proposed,
each on its owner's yes, and change no statement: the part stated on the grammar alone
(`Map.not_not_end_of_ends`, `Map.end_of_ends_decided`, the witness `Map.StepWhere`, as
`Becoming.GrammarMap`'s `Map.short` gated by `P`, and the calibration
`Map.end_of_ends_iff_excluded_middle`) into `Becoming.GrammarMap`, beside `«尽则非不穷»` and
`«延尽之定当且仅当排中»`; the laws needing nothing of `Becoming.KeepingWidening` into
`Becoming.MapInstances`, where the landed `Web.not_endless_of_gone`, `Web.degenerates_of_gone` and
the three laws that a regime's line does not go on would be re-derived in place from degeneration
and `Web.Restated` dropped; the kind instance `Web.kind_every_branch_ends_of_gone` and
`Map.Undecided.kind_degenerates` after `Web.kindClass_within` in `Becoming.KeepingWidening`, which
imports `Becoming.MapInstances`. The moves touch the root's map modules, which the rebuild of
the conditional laws (board item OU7) also changes, so they would come after it.

The landed name `Web.degenerates_of_gone` states a wrong meaning: it concludes an end (有终), and
degeneration (退化) is ending on every branch (尽). A rename at placement, to `Web.end_of_gone`, is
proposed to the owner of `Becoming.MapInstances`, after that rebuild, and is that owner's call; until then this module
names its law `Web.every_branch_ends_of_gone` so the two stay apart.

Modelling choices: discrete steps (a continuation advances the step by one), formations a fixed
index type, activity Prop-valued, continuations and kinds Prop-valued relations, natural-number
levels and needs (the regimes of consumption and of a whole drawing), natural-number amounts of a
family's stock, uptake and replenishment (the second regime), and a uniform horizon: one step `N`
at which every branch is gone. Every declaration has an empty axiom report.
-/

namespace Becoming

universe u

namespace Map

variable {α : Type u}

/-- **Ending on every branch reaches an end, up to double negation.** -/
theorem not_not_end_of_ends {R L : «际» α} {x : α} (h : «尽» R L x) : ¬ ¬ «有终» R L x := by
  induction h with
  | mk _ ih =>
    intro none
    exact none ⟨_, .inl rfl, fun ⟨y, c⟩ =>
      ih y c fun ⟨w, hw, ends⟩ => none ⟨w, «所及之传递» (.inr (.one c)) hw, ends⟩⟩

/-- **Ending on every branch reaches an end where going on is decided** at the points of the
line. -/
theorem end_of_ends_decided {R L : «际» α} {x : α} (h : «尽» R L x) :
    (∀ y, «所及» R L x y → «有后» R L y ∨ ¬ «有后» R L y) → «有终» R L x := by
  induction h with
  | mk _ ih =>
    intro decided
    exact match decided _ (.inl rfl) with
      | .inr ends => ⟨_, .inl rfl, ends⟩
      | .inl ⟨y, c⟩ =>
        match ih y c (fun z hz => decided z («所及之传递» (.inr (.one c)) hz)) with
        | ⟨w, hw, ends⟩ => ⟨w, «所及之传递» (.inr (.one c)) hw, ends⟩

/-! ## Reaching an end needs the decision, on the grammar -/

namespace StepWhere

/-- On two points, one step from `false` to `true`, taken exactly where `P` holds, and nothing
else. -/
def relation (P : Prop) : «际» Bool := fun x y => x = false ∧ y = true ∧ P

/-- Witness lemma: under the one (`«一»`), the line from `false` ends on every branch, at every
proposition: a step from `false` reaches `true`, and nothing steps from `true`. -/
theorem ends (P : Prop) : «尽» (relation P) «一» false :=
  .mk fun _ c => .mk fun _ c' => Bool.noConfusion (c.1.2.1.symm.trans c'.1.1)

/-- Witness lemma: `false` has a continuation exactly where `P` holds. -/
theorem has_next_iff (P : Prop) : «有后» (relation P) «一» false ↔ P :=
  ⟨fun ⟨_, c⟩ => c.1.2.2, fun p => ⟨true, ⟨rfl, rfl, p⟩, trivial⟩⟩

/-- Witness lemma: **reaching an end from `false` decides `P`.** -/
theorem end_decides {P : Prop} (h : «有终» (relation P) «一» false) : P ∨ ¬ P :=
  match h with
  | ⟨_, .inl same, ends⟩ =>
    .inr fun p => ends (Eq.subst (motive := fun z => «有后» (relation P) «一» z) same
      ((has_next_iff P).mpr p))
  | ⟨_, .inr (.one c), _⟩ => .inl c.1.2.2
  | ⟨_, .inr (.more c _), _⟩ => .inl c.1.2.2

end StepWhere

/-- **That every line ending on every branch reaches an end is exactly excluded middle**, at every
carrier and relation. A calibration on the grammar: the forward direction is witnessed by
`Map.StepWhere` alone. -/
theorem end_of_ends_iff_excluded_middle :
    (∀ (β : Type) (R L : «际» β) (x : β), «尽» R L x → «有终» R L x) ↔ ∀ P : Prop, P ∨ ¬ P :=
  ⟨fun h P => StepWhere.end_decides (h _ _ _ _ (StepWhere.ends P)),
   fun em _ _ _ _ ends => end_of_ends_decided ends fun _ _ => em _⟩

end Map

variable {F C : Type}

namespace Web

variable {W : Web F C} {R : Nat → F → F → Prop}

/-! ## Ending on every branch, by the steps left -/

/-- Everything the line reaches `d` steps before `N` ends on every branch, where everything it
reaches at `N` does. -/
theorem ends_before {E : «际» (Nat × F)} {x : Nat × F} {N : Nat}
    (at_N : ∀ y, «所及» (continuationStep R) E x y → y.1 = N → «尽» (continuationStep R) E y) :
    ∀ d y, «所及» (continuationStep R) E x y → y.1 + d = N → «尽» (continuationStep R) E y
  | 0, y, hy, at_ => at_N y hy at_
  | d + 1, y, hy, at_ => .mk fun z c =>
    ends_before at_N d z («所及之传递» hy (.inr (.one c)))
      ((congrArg (· + d) c.1.1).trans ((Nat.succ_add y.1 d).trans at_))

/-- **Ending at a step ends the line before it.** Along any class, where everything the line from
`x` reaches at a step `N` not before `x` ends on every branch, `x` ends on every branch. -/
theorem ends_of_ends_at {E : «际» (Nat × F)} {x : Nat × F} {N : Nat} (le : x.1 ≤ N)
    (at_N : ∀ y, «所及» (continuationStep R) E x y → y.1 = N → «尽» (continuationStep R) E y) :
    «尽» (continuationStep R) E x :=
  match le_dest le with
  | ⟨k, at_⟩ => ends_before at_N k x (.inl rfl) at_.symm

/-! ## The constructive degeneration law -/

/-- What the line reaches under a finer class it reaches under a coarser one. -/
theorem reached_coarser {E E' : «际» (Nat × F)} (inside : «则» E E') {x y : Nat × F}
    (reached : «所及» (continuationStep R) E x y) : «所及» (continuationStep R) E' x y :=
  match reached with
  | .inl same => .inl same
  | .inr line => .inr («及之单调» («粗化» (continuationStep R) inside) x y line)

/-- What the line under a class finer than activity reaches from an active occurrence is active. -/
theorem active_along_finer {E : «际» (Nat × F)} (inside : «则» E W.activityClass) {x y : Nat × F}
    (start : W.active x.1 x.2) (reached : «所及» (continuationStep R) E x y) : W.active y.1 y.2 :=
  active_along_line start (reached_coarser inside reached)

/-- **A line along which nothing reached at a step is active ends on every branch**, at every class
finer than activity: no decision of going on and no premise that the line does not branch. -/
theorem every_branch_ends_of_gone {E : «际» (Nat × F)} (inside : «则» E W.activityClass)
    {x : Nat × F} {N : Nat} (start : W.active x.1 x.2) (le : x.1 ≤ N)
    (gone : ∀ y, «所及» (continuationStep R) E x y → y.1 = N → ¬ W.active y.1 y.2) :
    «退化» (continuationStep R) E x :=
  ends_of_ends_at le fun y hy at_ => absurd (active_along_finer inside start hy) (gone y hy at_)

/-- **At the activity grain**, under exactly the premises of `Web.not_endless_of_gone`. -/
theorem activity_every_branch_ends_of_gone {x : Nat × F} {N : Nat} (start : W.active x.1 x.2)
    (le : x.1 ≤ N)
    (gone : ∀ y, «所及» (continuationStep R) W.activityClass x y → y.1 = N →
      ¬ W.active y.1 y.2) :
    «退化» (continuationStep R) W.activityClass x :=
  every_branch_ends_of_gone («则之自反» W.activityClass) start le gone

/-- **At the kind grain**: for every kind relation `Q` and every continuation, the lineage
continuation `Web.withinKind W Q passes` included. -/
theorem kind_every_branch_ends_of_gone {Q : F → F → Prop} {x : Nat × F} {N : Nat}
    (start : W.active x.1 x.2) (le : x.1 ≤ N)
    (gone : ∀ y, «所及» (continuationStep R) (W.kindClass Q) x y → y.1 = N →
      ¬ W.active y.1 y.2) :
    «退化» (continuationStep R) (W.kindClass Q) x :=
  every_branch_ends_of_gone kindClass_within start le gone

/-! ## The three regimes: one gone step each -/

/-- **Consumption makes an occurrence at the later step inactive** where it holds the dependence
at no lower need. -/
theorem consumed_held_gone (dependent : W.Dependent) {c : C} {g : F} {T N : Nat}
    (below : ∀ s, T < s → W.level s c < W.need T g c) (after : T < N) {y : Nat × F}
    (at_ : y.1 = N) (held : W.requires N y.2 c ∧ W.need T g c ≤ W.need N y.2 c) :
    ¬ W.active y.1 y.2 :=
  fun active =>
    have now : W.active N y.2 := Eq.subst (motive := fun s => W.active s y.2) at_ active
    Nat.not_le_of_gt (below N after) (Nat.le_trans held.2 (dependent N y.2 now c held.1))

/-- **A whole drawing beyond renewal makes an occurrence at the step the excess reaches inactive**
where it depends on a member of the family at a need of at least `m`. -/
theorem family_excess_gone {L : Flow F C} (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) {ds : List C} {m : Nat}
    (gated : ∀ t f, f ∈ L.present t → ∀ d, d ∈ ds → 0 < L.give t f d →
      ∃ e, e ∈ ds ∧ W.requires t f e ∧ m ≤ W.need t f e)
    {T n : Nat} (excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k))
    (stock : W.stock ds T < n + m) {y : Nat × F} (at_ : y.1 = T + n)
    (held : ∃ e, e ∈ ds ∧ W.requires (T + n) y.2 e ∧ m ≤ W.need (T + n) y.2 e) :
    ¬ W.active y.1 y.2 :=
  match held with
  | ⟨e, inside, depends, high⟩ =>
    Eq.subst (motive := fun s => ¬ W.active s y.2) at_.symm
      (Becoming.Flow.family_excess_ends balances acting dependent gated excess stock 0 y.2 e
        inside depends high)

/-- **Passing that stops makes every occurrence at step `T + d` inactive**, `d` the span for which
carriers are brief and `T` the step from which nothing passes. -/
theorem stopped_gone {V : Web F C} {passes : Nat → F → F → Prop} (byPassing : V.ByPassing passes)
    {d T : Nat} (brief : ∀ a, V.Brief d a) (stopped : ∀ t, T ≤ t → ¬ V.PassesAt passes t)
    {y : Nat × F} (at_ : y.1 = T + d) : ¬ V.active y.1 y.2 :=
  fun active => byPassing.ends_within brief stopped (Nat.le_of_eq at_.symm) ⟨y.2, active⟩

/-! ## The three regimes degenerate -/

/-- **Consumption of what the line depends on degenerates it**, under the hypotheses of
`Web.consumed_held_not_endless`. -/
theorem consumed_held_degenerates (dependent : W.Dependent) {c : C} {g : F} {T N : Nat}
    (below : ∀ s, T < s → W.level s c < W.need T g c) (after : T < N)
    {x : Nat × F} (start : W.active x.1 x.2) (le : x.1 ≤ N)
    (held : ∀ y, «所及» (continuationStep R) W.activityClass x y → y.1 = N →
      W.requires N y.2 c ∧ W.need T g c ≤ W.need N y.2 c) :
    «退化» (continuationStep R) W.activityClass x :=
  activity_every_branch_ends_of_gone start le fun y hy at_ =>
    consumed_held_gone dependent below after at_ (held y hy at_)

/-- **A whole drawing beyond renewal degenerates the lines that depend on it**, under the
hypotheses of `Web.family_excess_not_endless`. -/
theorem family_excess_degenerates {L : Flow F C} (balances : L.Balances W)
    (acting : L.Acting W) (dependent : W.Dependent) {ds : List C} {m : Nat}
    (gated : ∀ t f, f ∈ L.present t → ∀ d, d ∈ ds → 0 < L.give t f d →
      ∃ e, e ∈ ds ∧ W.requires t f e ∧ m ≤ W.need t f e)
    {T n : Nat} (excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k))
    (stock : W.stock ds T < n + m) {x : Nat × F} (start : W.active x.1 x.2) (le : x.1 ≤ T + n)
    (held : ∀ y, «所及» (continuationStep R) W.activityClass x y → y.1 = T + n →
      ∃ e, e ∈ ds ∧ W.requires (T + n) y.2 e ∧ m ≤ W.need (T + n) y.2 e) :
    «退化» (continuationStep R) W.activityClass x :=
  activity_every_branch_ends_of_gone start le fun y hy at_ =>
    family_excess_gone balances acting dependent gated excess stock at_ (held y hy at_)

/-- **Passing that stops degenerates the pattern's line**, under the hypotheses of
`Web.stopped_not_endless`. -/
theorem stopped_degenerates {V : Web F C} {passes : Nat → F → F → Prop}
    (byPassing : V.ByPassing passes) {d T : Nat} (brief : ∀ a, V.Brief d a)
    (stopped : ∀ t, T ≤ t → ¬ V.PassesAt passes t) {x : Nat × F} (start : V.active x.1 x.2)
    (le : x.1 ≤ T + d) :
    «退化» (continuationStep (passingContinuation passes)) V.activityClass x :=
  activity_every_branch_ends_of_gone start le fun _ _ at_ =>
    stopped_gone byPassing brief stopped at_

/-! ## The landed laws, restated through degeneration (no result) -/

namespace Restated

/-- Restates the landed `Web.not_endless_of_gone` through degeneration; no result. -/
theorem not_endless_of_gone {x : Nat × F} {N : Nat} (start : W.active x.1 x.2) (le : x.1 ≤ N)
    (gone : ∀ y, «所及» (continuationStep R) W.activityClass x y → y.1 = N →
      ¬ W.active y.1 y.2) :
    ¬ «不穷» (continuationStep R) W.activityClass x :=
  «尽则非不穷» (activity_every_branch_ends_of_gone start le gone)

/-- Restates the landed `Web.degenerates_of_gone` (an end, 有终, where going on is decided) as the
degeneration law with the decision; no result. -/
theorem degenerates_of_gone {x : Nat × F} {N : Nat} (start : W.active x.1 x.2) (le : x.1 ≤ N)
    (gone : ∀ y, «所及» (continuationStep R) W.activityClass x y → y.1 = N →
      ¬ W.active y.1 y.2)
    (decided : ∀ y, «所及» (continuationStep R) W.activityClass x y →
      «有后» (continuationStep R) W.activityClass y ∨
        ¬ «有后» (continuationStep R) W.activityClass y) :
    «有终» (continuationStep R) W.activityClass x :=
  Map.end_of_ends_decided (activity_every_branch_ends_of_gone start le gone) decided

/-- Restates the landed `Web.consumed_held_not_endless` through degeneration; no result. -/
theorem consumed_held_not_endless (dependent : W.Dependent) {c : C} {g : F} {T N : Nat}
    (below : ∀ s, T < s → W.level s c < W.need T g c) (after : T < N)
    {x : Nat × F} (start : W.active x.1 x.2) (le : x.1 ≤ N)
    (held : ∀ y, «所及» (continuationStep R) W.activityClass x y → y.1 = N →
      W.requires N y.2 c ∧ W.need T g c ≤ W.need N y.2 c) :
    ¬ «不穷» (continuationStep R) W.activityClass x :=
  «尽则非不穷» (consumed_held_degenerates dependent below after start le held)

/-- Restates the landed `Web.family_excess_not_endless` through degeneration; no result. -/
theorem family_excess_not_endless {L : Flow F C} (balances : L.Balances W)
    (acting : L.Acting W) (dependent : W.Dependent) {ds : List C} {m : Nat}
    (gated : ∀ t f, f ∈ L.present t → ∀ d, d ∈ ds → 0 < L.give t f d →
      ∃ e, e ∈ ds ∧ W.requires t f e ∧ m ≤ W.need t f e)
    {T n : Nat} (excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k))
    (stock : W.stock ds T < n + m) {x : Nat × F} (start : W.active x.1 x.2) (le : x.1 ≤ T + n)
    (held : ∀ y, «所及» (continuationStep R) W.activityClass x y → y.1 = T + n →
      ∃ e, e ∈ ds ∧ W.requires (T + n) y.2 e ∧ m ≤ W.need (T + n) y.2 e) :
    ¬ «不穷» (continuationStep R) W.activityClass x :=
  «尽则非不穷» (family_excess_degenerates balances acting dependent gated excess stock start le held)

/-- Restates the landed `Web.stopped_not_endless` through degeneration; no result. -/
theorem stopped_not_endless {V : Web F C} {passes : Nat → F → F → Prop}
    (byPassing : V.ByPassing passes) {d T : Nat} (brief : ∀ a, V.Brief d a)
    (stopped : ∀ t, T ≤ t → ¬ V.PassesAt passes t) {x : Nat × F} (start : V.active x.1 x.2)
    (le : x.1 ≤ T + d) :
    ¬ «不穷» (continuationStep (passingContinuation passes)) V.activityClass x :=
  «尽则非不穷» (stopped_degenerates byPassing brief stopped start le)

end Restated

end Web

/-! ## Witnesses of the regimes -/

namespace Map

namespace Depleted

/-- One formation, active at steps `0` and `1`, depending at need one on one condition, whose level
is one at steps `0` and `1` and zero after. -/
def web : Web Unit Unit where
  level t _ := match t with
    | 0 => 1
    | 1 => 1
    | _ + 2 => 0
  active t _ := t ≤ 1
  requires _ _ _ := True
  need _ _ _ := 1
  draws _ _ _ := True

/-- Activity needs support. -/
theorem dependent : web.Dependent :=
  fun t _ active _ _ => match t, active with
    | 0, _ => Nat.le_refl 1
    | 1, _ => Nat.le_refl 1
    | n + 2, late => absurd late (Nat.not_le_of_gt (Nat.le_add_left 2 n))

/-- After step `1` the level is below the need at step `1`. -/
theorem below : ∀ s, 1 < s → web.level s () < web.need 1 () ()
  | 0, early => absurd early (Nat.not_lt_zero 1)
  | 1, early => absurd early (Nat.lt_irrefl 1)
  | _ + 2, _ => Nat.zero_lt_one

/-- Every step is a continuation. -/
def every : Nat → Unit → Unit → Prop := fun _ _ _ => True

/-- **The line takes its step**: the occurrence at step `0` is continued by the one at step `1`. -/
theorem continues :
    «续» (Web.continuationStep every) web.activityClass (0, ()) (1, ()) :=
  ⟨⟨rfl, trivial⟩, ⟨fun _ => Nat.le_refl 1, fun _ => Nat.zero_le 1⟩⟩

/-- **The premises of `Web.consumed_held_degenerates` hold together, and the line degenerates.** -/
theorem degenerates : «退化» (Web.continuationStep every) web.activityClass (0, ()) :=
  Web.consumed_held_degenerates (c := ()) (g := ()) (T := 1) (N := 2) dependent below
    (Nat.lt_succ_self 1) (Nat.zero_le 1) (Nat.zero_le 2) fun _ _ _ => ⟨trivial, Nat.le_refl 1⟩

end Depleted

/-- **The premises of `Web.family_excess_degenerates` hold together** in `Coupled`: the taker's
line, along every continuation, degenerates. -/
theorem coupled_degenerates :
    «退化» (Web.continuationStep (fun _ _ _ => True)) Coupled.web.activityClass
      (0, Coupled.Formation.taker) :=
  Web.family_excess_degenerates (T := 0) (n := 3) Coupled.balances Coupled.acting Coupled.dependent
    Coupled.gated Coupled.excess (show 1 + (2 + 0) < 3 + 1 from Nat.lt_succ_self 3) trivial
    (Nat.zero_le 3) fun y _ _ => match y with
      | (_, .taker) => ⟨.patch, .head _, trivial, Nat.le_refl 1⟩
      | (_, .renewer) => ⟨.neighbour, .tail _ (.head _), trivial, Nat.le_refl 1⟩

/-- **The taker's line takes its step**: in `Coupled`, along every continuation, the taker at step
`0` is continued by the taker at step `1`. -/
theorem coupled_continues :
    «续» (Web.continuationStep (fun _ _ _ => True)) Coupled.web.activityClass
      (0, Coupled.Formation.taker) (1, Coupled.Formation.taker) :=
  ⟨⟨rfl, trivial⟩, ⟨fun _ => trivial, fun _ => trivial⟩⟩

/-- **The premises of `Web.stopped_degenerates` hold together** in the relay stopped at `T`: the
first carrier's line degenerates. -/
theorem stopped_relay_degenerates (T : Nat) :
    «退化» (Web.continuationStep (Web.passingContinuation (PatternRelay.passesUntil T)))
      (PatternRelay.stopped T).activityClass (0, 0) :=
  Web.stopped_degenerates (d := 2) (T := T) (PatternRelay.stopped_by_passing T)
    (PatternRelay.stopped_brief T) (PatternRelay.stopped_quiet T) ⟨Nat.zero_le T, .inl rfl⟩
    (Nat.zero_le (T + 2))

/-- **The first carrier's line takes its step**: in the relay stopped at `T`, the first carrier at
step `0` is continued by itself at step `1`. -/
theorem stopped_relay_continues (T : Nat) :
    «续» (Web.continuationStep (Web.passingContinuation (PatternRelay.passesUntil T)))
      (PatternRelay.stopped T).activityClass (0, 0) (1, 0) :=
  ⟨⟨rfl, .inl rfl⟩, ⟨fun _ => ⟨Nat.zero_le T, .inr rfl⟩, fun _ => ⟨Nat.zero_le T, .inl rfl⟩⟩⟩

/-! ## Reaching an end needs the decision -/

namespace Undecided

/-- One occurrence at step `0` (`false`), one at step `1` (`true`), nothing active from step `2`. -/
def web : Web Bool Unit where
  level _ _ := 0
  active t f := (t = 0 ∧ f = false) ∨ (t = 1 ∧ f = true)
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- Every step is continued exactly where `P` holds. -/
def continuation (P : Prop) : Nat → Bool → Bool → Prop := fun _ _ _ => P

/-- Nothing is active at step `2`. -/
theorem inactive_two (f : Bool) : ¬ web.active 2 f :=
  fun now => match now with
    | .inl ⟨e, _⟩ => Nat.noConfusion e
    | .inr ⟨e, _⟩ => Nat.noConfusion (Nat.succ.inj e)

/-- The occurrence at step `1` ends: nothing continues it. -/
theorem last_ends (P : Prop) :
    «亡» (Web.continuationStep (continuation P)) web.activityClass (1, true) :=
  fun ⟨(_, f), ⟨next, _⟩, alike⟩ =>
    inactive_two f
      (Eq.subst (motive := fun s' => web.active s' f) next (alike.mp (.inr ⟨rfl, rfl⟩)))

/-- Where `P` holds, the occurrence at step `0` is continued by the one at step `1`. -/
theorem first_continues {P : Prop} (p : P) :
    «续» (Web.continuationStep (continuation P)) web.activityClass (0, false) (1, true) :=
  ⟨⟨rfl, p⟩, ⟨fun _ => .inr ⟨rfl, rfl⟩, fun _ => .inl ⟨rfl, rfl⟩⟩⟩

/-- Witness lemma: the occurrence at step `0` has a continuation exactly where `P` holds. -/
theorem first_has_next_iff (P : Prop) :
    «有后» (Web.continuationStep (continuation P)) web.activityClass (0, false) ↔ P :=
  ⟨fun ⟨_, c⟩ => c.1.2, fun p => ⟨(1, true), first_continues p⟩⟩

/-- **The premise of the degeneration law holds at the activity grain, and the pattern
degenerates.** -/
theorem degenerates (P : Prop) :
    (∀ y, «所及» (Web.continuationStep (continuation P)) web.activityClass (0, false) y →
        y.1 = 2 → ¬ web.active y.1 y.2) ∧
      «退化» (Web.continuationStep (continuation P)) web.activityClass (0, false) :=
  have gone : ∀ y, «所及» (Web.continuationStep (continuation P)) web.activityClass (0, false) y →
      y.1 = 2 → ¬ web.active y.1 y.2 := fun y _ at_ =>
    Eq.subst (motive := fun s => ¬ web.active s y.2) at_.symm (inactive_two y.2)
  ⟨gone, Web.activity_every_branch_ends_of_gone (.inl ⟨rfl, rfl⟩) (Nat.zero_le 2) gone⟩

/-- **The premise of the degeneration law holds at the kind grain**, for every kind relation, and
the pattern read at the kind degenerates. -/
theorem kind_degenerates (P : Prop) (Q : Bool → Bool → Prop) :
    (∀ y, «所及» (Web.continuationStep (continuation P)) (web.kindClass Q) (0, false) y →
        y.1 = 2 → ¬ web.active y.1 y.2) ∧
      «退化» (Web.continuationStep (continuation P)) (web.kindClass Q) (0, false) :=
  have gone : ∀ y, «所及» (Web.continuationStep (continuation P)) (web.kindClass Q) (0, false) y →
      y.1 = 2 → ¬ web.active y.1 y.2 := fun y _ at_ =>
    Eq.subst (motive := fun s => ¬ web.active s y.2) at_.symm (inactive_two y.2)
  ⟨gone, Web.kind_every_branch_ends_of_gone (.inl ⟨rfl, rfl⟩) (Nat.zero_le 2) gone⟩

/-- **Reaching an end decides `P`.** -/
theorem end_decides {P : Prop}
    (h : «有终» (Web.continuationStep (continuation P)) web.activityClass (0, false)) : P ∨ ¬ P :=
  match h with
  | ⟨_, .inl same, ends⟩ =>
    .inr fun p => ends (Eq.subst
      (motive := fun z => «有后» (Web.continuationStep (continuation P)) web.activityClass z) same
      ((first_has_next_iff P).mpr p))
  | ⟨_, .inr (.one c), _⟩ => .inl c.1.2
  | ⟨_, .inr (.more c _), _⟩ => .inl c.1.2

end Undecided

/-- **That every line meeting the degeneration law's premise reaches an end is exactly excluded
middle**, at every web and continuation: the decision premise of `Web.degenerates_of_gone` is as
strong as excluded middle. -/
theorem end_of_gone_iff_excluded_middle :
    (∀ (F' C' : Type) (V : Web F' C') (R : Nat → F' → F' → Prop) (x : Nat × F') (N : Nat),
        V.active x.1 x.2 → x.1 ≤ N →
        (∀ y, «所及» (Web.continuationStep R) V.activityClass x y → y.1 = N → ¬ V.active y.1 y.2) →
        «有终» (Web.continuationStep R) V.activityClass x) ↔
      ∀ P : Prop, P ∨ ¬ P :=
  ⟨fun h P => Undecided.end_decides
      (h _ _ Undecided.web (Undecided.continuation P) (0, false) 2 (.inl ⟨rfl, rfl⟩)
        (Nat.zero_le 2) (Undecided.degenerates P).1),
   fun em _ _ _ _ _ _ start le gone =>
    end_of_ends_decided (Web.activity_every_branch_ends_of_gone start le gone) fun _ _ => em _⟩

end Map

end Becoming
