import Becoming.Clearing

/-!
# Interdependence: what returns along dependence

On 10 October 2026 Ren asked to aim first for the route under the continuation condition, which
`Becoming.Significance` states, and then to try the route without axiom. The AI had put that
route as follows, and Ren quoted it:

> No axiom. The theory only describes, and “should” is what a center does once its represented
> boundary matches what it actually depends on. The theory then explains recognition and
> motivation but claims no warrant beyond them.

The AI had also named two mechanisms needing no premise: “selection between wholes: wholes whose
parts sustain them outlast others” and “constraint: a part that degrades its whole removes its
own supply”. Ren answered that a whole realizing, understanding and updating itself is “also
under the selection rules and constraints in theory”, and that how this happens in practice
“needs more thoughts”. This module states, with no premise beyond the representation, what a
formation's continuation depends on, how far the constraint reaches, and how retaining within a
bound compares with inclusion. Where this route meets the continuation condition is stated in
`Becoming.BoundedSignificance`, after `Becoming.Significance`; this module neither imports nor
assumes the condition.

* **What a continuation depends on.** The continuation of a formation is fed by another at a
  step when the other gives to a condition it requires (`Flow.FedBy`), and fed from it when
  that happens at some step (`Flow.FedFrom`). A region of formations is closed under feeding
  when whatever feeds a member is a member (`Flow.FedClosed`), and a formation lies within
  another's feeding closure when it lies in every region closed under feeding that holds the
  other (`Flow.WithinFeeding`): by definition the frame's one closure (`ClosedUnder`,
  `WithinClosure`, `Becoming.Frame`) under being fed. So the closure holds its formation and
  every feeder, is transitive, and is itself closed under feeding, by the laws of that closure
  (`Flow.WithinFeeding.refl`, `Flow.WithinFeeding.of_fedBy`, `Flow.WithinFeeding.trans`,
  `Flow.fedClosed_within`), and what lies beyond it gives nothing, at any step, to a condition a
  member then requires, since nothing within a closure bears the relation to what lies beyond
  it (`Flow.beyond_gives_nothing`, through `WithinClosure.not_rel`).
* **Consumption ends with its feeders.** Under balance, with only active formations giving and
  activity needing support, let a formation take from a condition at every step at which it is
  active, while nothing supported gives to the condition. Then it is active for at most as many
  consecutive steps as the condition's level at the start
  (`Flow.Balances.unfed_consumption_ends`), so it does not continue
  (`Flow.Balances.unfed_consumption_not_continuing`). Where everything feeding a formation is
  unsupported, nothing supported gives to a condition it requires
  (`Flow.unfed_of_feeders_unsupported`), so its consumption ends with its feeders
  (`Flow.Balances.consumption_ends_with_feeders`).
* **An ending returns through a feeder.** In `Overshoot` each of two formations feeds the
  other's condition, so the feeding closure of either is the whole
  (`Overshoot.closure_whole`). At the first step one of them takes from both conditions. It is
  within renewal over the one condition it requires and keeps its own support across the step,
  while its draw undermines the other's dependence. The other is unsupported from the second
  step on, the first is active for at most one step more, and from the third step on nothing
  is supported (`Overshoot.ends_through_feeder`). Where each takes only from its own condition,
  both continue at every step (`Overshoot.steady_continues`). A formation can keep its own
  support across a step and still end through a feeder: what its continuation depends on
  reaches the continuation of its feeders.
* **What lies beyond the closure need not return.** In `Clearing` the region along dependence
  of `Becoming.Clearing` is each formation's feeding closure
  (`Clearing.dependenceRegion_iff`): the clearer with the source that feeds its resource, and
  the source and the dweller each alone. The dweller lies beyond the clearer's closure
  (`Clearing.dweller_beyond`). Everything within that closure is supported at every step and
  the clearer is active throughout, while the dweller ends (`Clearing.closure_supported`).
* **Retaining within a bound.** One level path retains what has significance along another, for
  significance bounded by a region, exactly as inclusion does wherever every formation the other
  path admits lies in the region or is admitted by the first
  (`Web.retains_bounded_iff_includes`). Where the route meets the continuation condition
  (significance bounded by the whole is the condition, `bounded_whole`; within a feeding closure
  that is the whole the verdict is the condition's, `Flow.within_closure_iff_retains`; in
  `Clearing` the two part, `Clearing.within_closure_yet_loses`) is stated in
  `Becoming.BoundedSignificance`.

**AI reading, adopted on Ren's delegation of 15 October 2026 (DELEGATED-CHOICES D17).**
- The feeding closure reads “what it actually depends on”. It is reached without axiom. How a
  center comes to represent it is not modelled. P40 also read it as Ren's “the system that one
  is in”; `Becoming.Feedback` withdraws that reading and offers the reach closure.
- A center that wants its continuation and represents its closure has its own reason to retain
  what lies within it, since a loss there can return to it, as in `Overshoot`. This explains
  motivation. It is not a warrant.
- The constraint runs along feeding: a loss returns to a center through its feeders, and what
  lies beyond the closure supplies nothing within it. Selection between wholes keeps the wholes
  that continue: it removes the whole of `Overshoot`, which ends, and keeps that of `Clearing`,
  where the clearer continues while the dweller ends. Neither mechanism reaches a loss that
  returns to no one.
- So this route reaches Ren's self with what it depends on. It reaches the whole only where the
  whole is one feeding closure. What the continuation condition adds is significance for continuations whose loss
  returns to no one, such as the dweller's.
- Ren wrote that the whole can realize itself, “like us, we recognize that "we" are the
  universe/ecosystem that realizes its own existence”. A center whose represented boundary is
  the whole holds the continuation condition's significance (`bounded_whole`, in
  `Becoming.BoundedSignificance`). This route asks for a boundary
  that matches actual dependence, so it reaches that significance only where the dependence
  reaches the whole.

What is not derived:
- that a center wants its continuation, or that it represents its feeding closure;
- that a loss within the closure does return: feeders may be redundant, and stock and timing
  decide when an ending arrives;
- any warrant, which the route does not claim. Living significance follows from the continuation condition of
  `Becoming.Significance` and, folded by Ren on 11 October 2026, is no longer an axiom.

The comparisons by withheld levels keep the rest of the exchange fixed, so an ending that
returns through the dynamics is shown on the actual flow, against a separate reference flow.
The representation commits to discrete steps and natural quantities.
-/

namespace Becoming

variable {F C Pos : Type}

/-! ## The feeding closure -/

namespace Flow

variable (L : Flow F C) (W : Web F C)

/-- `g`'s continuation is fed from `h` at some step. -/
def FedFrom (g h : F) : Prop :=
  ∃ t, L.FedBy W (g, t) (h, t)

/-- A region of formations is closed under feeding: whatever feeds the continuation of a
member at some step is a member. The frame's closedness under being fed at some step. -/
def FedClosed (region : F → Prop) : Prop :=
  ClosedUnder (L.FedFrom W) region

/-- `g` lies within the feeding closure of `f`: the frame's closure under being fed at some
step, every region closed under feeding that holds `f` holding `g`. -/
def WithinFeeding (f g : F) : Prop :=
  WithinClosure (L.FedFrom W) f g

variable {L W}

/-- A formation lies within its own feeding closure. -/
theorem WithinFeeding.refl (f : F) : L.WithinFeeding W f f :=
  WithinClosure.refl f

/-- The feeding closure is transitive. -/
theorem WithinFeeding.trans {f g h : F} (first : L.WithinFeeding W f g)
    (second : L.WithinFeeding W g h) : L.WithinFeeding W f h :=
  WithinClosure.trans first second

/-- What feeds a formation's continuation at some step lies within its feeding closure. -/
theorem WithinFeeding.of_fedBy {e e' : F × Nat} (fed : L.FedBy W e e') :
    L.WithinFeeding W e.1 e'.1 :=
  match fed with
  | ⟨same, c, requires, present, gives⟩ =>
    WithinClosure.of_rel ⟨e'.2, rfl, c, same ▸ requires, present, gives⟩

/-- The feeding closure of a formation is closed under feeding. -/
theorem fedClosed_within (f : F) : L.FedClosed W (L.WithinFeeding W f) :=
  closedUnder_withinClosure f

/-- What lies beyond a formation's feeding closure gives nothing, at any step, to a condition
that a member of the closure then requires. -/
theorem beyond_gives_nothing {f g h : F} (within : L.WithinFeeding W f g)
    (beyond : ¬ L.WithinFeeding W f h) {t : Nat} {c : C} (requires : W.requires t g c)
    (present : h ∈ L.present t) : L.give t h c = 0 :=
  eq_zero_of_not_pos fun gives =>
    WithinClosure.not_rel within beyond ⟨t, rfl, c, requires, present, gives⟩

/-! ## Consumption without a feeder ends -/

/-- Unfed consumption ends, over the steps it is used at: with balance at `c` across each of
`n` steps from `T`, whatever gives to `c` there supported, `g` taking from `c` at each step
from `T` at which it is active and nothing supported giving to `c` while `g` is active, `g`
is active for `n` consecutive steps from `T` only where `n` is at most the level of `c` at
`T`. -/
theorem unfed_consumption_ends_at {c : C} {g : F} {T : Nat}
    (unfed : ∀ t f, T ≤ t → W.active t g → f ∈ L.present t → W.Supported t f →
      L.give t f c = 0)
    (consumes : ∀ t, T ≤ t → W.active t g → g ∈ L.present t ∧ 0 < L.take t g c) :
    ∀ n, (∀ k, k < n → L.BalancesOn W [c] (T + k)) →
      (∀ k, k < n → L.GiversSupported W (T + k) c) →
      (∀ k, k < n → W.active (T + k) g) → n ≤ W.level T c :=
  fun n balances givers active =>
    Nat.le_trans (Nat.le_add_left n (W.level (T + n) c))
      (excess_bounded_at (c := c) (T := T) n balances fun k below =>
        have later : T ≤ T + k := Nat.le_add_right T k
        have live : W.active (T + k) g := active k below
        have none : L.given (T + k) c = 0 := total_eq_zero fun f present =>
          eq_zero_of_not_pos fun gives =>
            Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le gives (Nat.le_of_eq
              (unfed (T + k) f later live present (givers k below f present gives))))
        have consuming := consumes (T + k) later live
        Nat.lt_of_lt_of_le (Nat.lt_of_le_of_lt (Nat.le_of_eq none) consuming.2)
          (le_total_of_mem (q := fun f => L.take (T + k) f c) consuming.1))

/-- Unfed consumption ends. Under balance, with only active formations giving and activity
needing support, let `g` take from `c` at every step from `T` at which it is active, while
nothing supported gives to `c`. Then `g` is active for at most as many consecutive steps from
`T` as the level of `c` at `T`. -/
theorem Balances.unfed_consumption_ends (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) {c : C} {g : F} {T : Nat}
    (unfed : ∀ t f, T ≤ t → W.active t g → f ∈ L.present t → W.Supported t f →
      L.give t f c = 0)
    (consumes : ∀ t, T ≤ t → W.active t g → g ∈ L.present t ∧ 0 < L.take t g c) :
    ∀ n, (∀ k, k < n → W.active (T + k) g) → n ≤ W.level T c :=
  fun n => unfed_consumption_ends_at unfed consumes n (fun k _ => balances.on [c] (T + k))
    fun k _ => acting.giversSupported dependent (T + k) c

/-- So unfed consumption does not continue: `g` is not active at every step from `T`. -/
theorem Balances.unfed_consumption_not_continuing (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) {c : C} {g : F} {T : Nat}
    (unfed : ∀ t f, T ≤ t → W.active t g → f ∈ L.present t → W.Supported t f →
      L.give t f c = 0)
    (consumes : ∀ t, T ≤ t → W.active t g → g ∈ L.present t ∧ 0 < L.take t g c) :
    ¬ ∀ k, W.active (T + k) g :=
  fun always => Nat.not_succ_le_self (W.level T c)
    (balances.unfed_consumption_ends acting dependent unfed consumes (W.level T c + 1)
      fun k _ => always k)

/-- Where `g` requires `c` while active and everything feeding its continuation from `T` on is
unsupported, nothing supported gives to `c` while `g` is active. -/
theorem unfed_of_feeders_unsupported {c : C} {g : F} {T : Nat}
    (requires : ∀ t, T ≤ t → W.active t g → W.requires t g c)
    (unsupported : ∀ t f, T ≤ t → L.FedBy W (g, t) (f, t) → ¬ W.Supported t f) :
    ∀ t f, T ≤ t → W.active t g → f ∈ L.present t → W.Supported t f →
      L.give t f c = 0 :=
  fun t f later live present supported => eq_zero_of_not_pos fun gives =>
    unsupported t f later ⟨rfl, c, requires t later live, present, gives⟩ supported

/-- Consumption ends with its feeders, over the steps it is used at: as
`unfed_consumption_ends_at`, with everything feeding `g`'s continuation from `T` on
unsupported in place of nothing supported giving to `c`. -/
theorem consumption_ends_with_feeders_at {c : C} {g : F} {T : Nat}
    (requires : ∀ t, T ≤ t → W.active t g → W.requires t g c)
    (unsupported : ∀ t f, T ≤ t → L.FedBy W (g, t) (f, t) → ¬ W.Supported t f)
    (consumes : ∀ t, T ≤ t → W.active t g → g ∈ L.present t ∧ 0 < L.take t g c) :
    ∀ n, (∀ k, k < n → L.BalancesOn W [c] (T + k)) →
      (∀ k, k < n → L.GiversSupported W (T + k) c) →
      (∀ k, k < n → W.active (T + k) g) → n ≤ W.level T c :=
  unfed_consumption_ends_at (unfed_of_feeders_unsupported requires unsupported) consumes

/-- Consumption ends with its feeders. Under balance, with only active formations giving and
activity needing support, let `g` require and take `c` at every step from `T` at which it is
active, while everything feeding its continuation from `T` on is unsupported. Then `g` is
active for at most as many consecutive steps from `T` as the level of `c` at `T`. -/
theorem Balances.consumption_ends_with_feeders (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) {c : C} {g : F} {T : Nat}
    (requires : ∀ t, T ≤ t → W.active t g → W.requires t g c)
    (unsupported : ∀ t f, T ≤ t → L.FedBy W (g, t) (f, t) → ¬ W.Supported t f)
    (consumes : ∀ t, T ≤ t → W.active t g → g ∈ L.present t ∧ 0 < L.take t g c) :
    ∀ n, (∀ k, k < n → W.active (T + k) g) → n ≤ W.level T c :=
  balances.unfed_consumption_ends acting dependent
    (unfed_of_feeders_unsupported requires unsupported) consumes

end Flow

/-! ## Retaining within a bound -/

namespace Web

variable {W : Web F C}

/-- For significance bounded by a region, `l` retains what has significance along `l'` from `p`
exactly as inclusion does wherever every formation `l'` admits lies in `p`'s region or is
admitted by `l`. -/
theorem retains_bounded_iff_includes {region : Pos → F → Prop} {p : Pos}
    {l l' : Nat → C → Nat}
    (covers : ∀ t f, W.Admits (l' t) t f → region p f ∨ W.Admits (l t) t f) :
    W.Retains (bounded region) p l l' ↔ W.Includes l l' :=
  ⟨fun retains t f admits => match covers t f admits with
    | .inl inside => retains t f inside admits
    | .inr kept => kept,
   fun includes => includes.retains (bounded region) p⟩

end Web

/-! ## Witnesses -/

/-! Two formations feed each other's condition; at the first step one takes from both. -/

namespace Overshoot

/-- Each formation's condition is named by the formation. Across the first step `true` takes
one unit from each condition and gives one to `false`'s, and `false` takes one from its own and
gives one to `true`'s. Across the second step `true` takes one from its own. Then nothing
moves. -/
def flow : Flow Bool Bool where
  present _ := [true, false]
  take t f c := match t, f, c with
    | 0, true, true => 1
    | 0, true, false => 1
    | 0, false, true => 0
    | 0, false, false => 1
    | 1, true, true => 1
    | 1, true, false => 0
    | 1, false, true => 0
    | 1, false, false => 0
    | _ + 2, _, _ => 0
  give t f c := match t, f, c with
    | 0, true, true => 0
    | 0, true, false => 1
    | 0, false, true => 1
    | 0, false, false => 0
    | _ + 1, _, _ => 0

/-- Each formation requires its own condition at need one. Both conditions stand at one at the
start; `false`'s falls to nothing across the first step and `true`'s across the second. `true`
is active at the first two steps and `false` at the first. -/
def web : Web Bool Bool where
  level t c := match t, c with
    | 0, true => 1
    | 0, false => 1
    | 1, true => 1
    | 1, false => 0
    | _ + 2, _ => 0
  active t f := match t, f with
    | 0, true => True
    | 0, false => True
    | 1, true => True
    | 1, false => False
    | _ + 2, _ => False
  requires _ f c := match f, c with
    | true, true => True
    | true, false => False
    | false, true => False
    | false, false => True
  need _ _ _ := 1
  draws t f c := match t, f, c with
    | 0, true, true => True
    | 0, true, false => True
    | 0, false, true => False
    | 0, false, false => True
    | 1, true, true => True
    | 1, true, false => False
    | 1, false, true => False
    | 1, false, false => False
    | _ + 2, _, _ => False

theorem balances : flow.Balances web
  | 0, true => rfl
  | 0, false => rfl
  | 1, true => rfl
  | 1, false => rfl
  | _ + 2, true => rfl
  | _ + 2, false => rfl

theorem acting : flow.Acting web
  | 0, true, _, _, _ => trivial
  | 0, false, _, _, _ => trivial
  | _ + 1, _, _, _, gives => absurd gives (Nat.lt_irrefl 0)

theorem taking : flow.Taking web
  | 0, true, true, _, _ => ⟨trivial, trivial⟩
  | 0, true, false, _, _ => ⟨trivial, trivial⟩
  | 0, false, true, _, takes => absurd takes (Nat.lt_irrefl 0)
  | 0, false, false, _, _ => ⟨trivial, trivial⟩
  | 1, true, true, _, _ => ⟨trivial, trivial⟩
  | 1, true, false, _, takes => absurd takes (Nat.lt_irrefl 0)
  | 1, false, true, _, takes => absurd takes (Nat.lt_irrefl 0)
  | 1, false, false, _, takes => absurd takes (Nat.lt_irrefl 0)
  | _ + 2, _, _, _, takes => absurd takes (Nat.lt_irrefl 0)

theorem dependent : web.Dependent
  | 0, true, _, true, _ => Nat.le_refl 1
  | 0, true, _, false, no => nomatch no
  | 0, false, _, true, no => nomatch no
  | 0, false, _, false, _ => Nat.le_refl 1
  | 1, true, _, true, _ => Nat.le_refl 1
  | 1, true, _, false, no => nomatch no
  | 1, false, dead, _, _ => nomatch dead
  | _ + 2, _, dead, _, _ => nomatch dead

/-- Each feeds the other's condition at the first step, so the feeding closure of either is
the whole. -/
theorem closure_whole : ∀ f g, flow.WithinFeeding web f g
  | true, true => Flow.WithinFeeding.refl true
  | false, false => Flow.WithinFeeding.refl false
  | true, false => Flow.WithinFeeding.of_fedBy (e := (true, 0)) (e' := (false, 0))
      ⟨rfl, true, trivial, .tail _ (.head _), Nat.zero_lt_one⟩
  | false, true => Flow.WithinFeeding.of_fedBy (e := (false, 0)) (e' := (true, 0))
      ⟨rfl, false, trivial, .head _, Nat.zero_lt_one⟩

/-- An ending returns through a feeder. The flow balances, only active formations give, and
only active formations take, and only from what they draw on; activity needs support. At the
first step `true` is within renewal over the one condition it requires and keeps its own
support across the step, while its draw undermines `false`'s dependence, and `false` feeds
`true`'s condition. `false` is unsupported from the second step on, so from the second step
`true` is active for at most one step, and from the third step on nothing is supported. -/
theorem ends_through_feeder :
    flow.Balances web ∧ flow.Acting web ∧ flow.Taking web ∧ web.Dependent ∧
      web.RenewingOver (web.requires 0 true) 0 true ∧ web.Supported 1 true ∧
      web.UnderminingAt 0 true ∧
      flow.FedBy web (true, 0) (false, 0) ∧
      (∀ t, 1 ≤ t → ¬ web.Supported t false) ∧
      (∀ n, (∀ k, k < n → web.active (1 + k) true) → n ≤ 1) ∧
      ∀ t f, 2 ≤ t → ¬ web.Supported t f :=
  ⟨balances, acting, taking, dependent,
   ⟨trivial, fun c inside _ g requires => match c, inside, g, requires with
    | true, _, true, _ => ⟨Nat.le_refl 1, Nat.le_refl 1⟩
    | true, _, false, no => nomatch no
    | false, no, _, _ => nomatch no⟩,
   fun c requires => match c, requires with
    | true, _ => Nat.le_refl 1
    | false, no => (nomatch no),
   ⟨false, trivial, false, trivial, ⟨0, Nat.le_refl 0, fun _ _ _ => trivial, Nat.le_refl 1,
     Nat.zero_lt_one⟩, Nat.zero_lt_one⟩,
   ⟨rfl, true, trivial, .tail _ (.head _), Nat.zero_lt_one⟩,
   fun t later supported => match t, later, supported with
    | 0, below, _ => Nat.not_succ_le_zero 0 below
    | 1, _, supported => Nat.not_succ_le_zero 0 (supported false trivial)
    | _ + 2, _, supported => Nat.not_succ_le_zero 0 (supported false trivial),
   balances.consumption_ends_with_feeders acting dependent (c := true)
    (fun _ _ _ => trivial)
    (fun t _ later fed _ => match t, later, fed with
      | 0, below, _ => Nat.not_succ_le_zero 0 below
      | _ + 1, _, ⟨_, _, _, _, gives⟩ => absurd gives (Nat.lt_irrefl 0))
    (fun t later live => match t, later, live with
      | 0, below, _ => absurd below (Nat.not_succ_le_zero 0)
      | 1, _, _ => ⟨.head _, Nat.zero_lt_one⟩
      | _ + 2, _, dead => nomatch dead),
   fun t f later supported => match t, f, later, supported with
    | 0, _, below, _ => Nat.not_succ_le_zero 1 below
    | 1, _, below, _ => Nat.not_succ_le_zero 0 (Nat.le_of_succ_le_succ below)
    | _ + 2, true, _, supported => Nat.not_succ_le_zero 0 (supported true trivial)
    | _ + 2, false, _, supported => Nat.not_succ_le_zero 0 (supported false trivial)⟩

/-- Taking only from its own condition, each formation takes one unit of it and gives one to
the other's at every step. -/
def steadyFlow : Flow Bool Bool where
  present _ := [true, false]
  take _ f c := match f, c with
    | true, true => 1
    | true, false => 0
    | false, true => 0
    | false, false => 1
  give _ f c := match f, c with
    | true, true => 0
    | true, false => 1
    | false, true => 1
    | false, false => 0

/-- The same dependences, with both conditions standing at one and both formations active
throughout. -/
def steadyWeb : Web Bool Bool where
  level _ _ := 1
  active _ _ := True
  requires := web.requires
  need _ _ _ := 1
  draws _ f c := match f, c with
    | true, true => True
    | true, false => False
    | false, true => False
    | false, false => True

/-- Taking only from its own condition, both continue. The flow balances, only active
formations give, and only active formations take, and only from what they draw on; both
formations are active and supported at every step. -/
theorem steady_continues :
    steadyFlow.Balances steadyWeb ∧ steadyFlow.Acting steadyWeb ∧
      steadyFlow.Taking steadyWeb ∧ steadyWeb.Dependent ∧
      ∀ t f, steadyWeb.active t f ∧ steadyWeb.Supported t f :=
  have supported : ∀ t f, steadyWeb.Supported t f := fun _ _ _ _ => Nat.le_refl 1
  ⟨fun _ c => match c with
    | true => rfl
    | false => rfl,
   fun _ _ _ _ _ => trivial,
   fun _ f c _ takes => match f, c, takes with
    | true, true, _ => ⟨trivial, trivial⟩
    | true, false, takes => absurd takes (Nat.lt_irrefl 0)
    | false, true, takes => absurd takes (Nat.lt_irrefl 0)
    | false, false, _ => ⟨trivial, trivial⟩,
   fun t f _ => supported t f,
   fun t f => ⟨trivial, supported t f⟩⟩

end Overshoot

namespace Clearing

/-- The region along dependence is closed under feeding. -/
theorem fedClosed : flow.FedClosed web alongDependence :=
  fun _ h _ ⟨_, fed⟩ => match h, fedBy_source fed with
    | .source, _ => trivial
    | .clearer, ⟨_, no⟩ => Formation.noConfusion no
    | .dweller, ⟨_, no⟩ => Formation.noConfusion no

/-- Each formation's region along its dependence is closed under feeding. -/
theorem dependenceRegion_closed : ∀ p, flow.FedClosed web (dependenceRegion p)
  | .clearer => fedClosed
  | .source => fun _ _ inside ⟨_, fed⟩ =>
      Formation.noConfusion ((fedBy_source fed).1.symm.trans inside)
  | .dweller => fun _ _ inside ⟨_, fed⟩ =>
      Formation.noConfusion ((fedBy_source fed).1.symm.trans inside)

/-- Each formation lies in its own region along its dependence. -/
theorem dependenceRegion_self : ∀ p, dependenceRegion p p
  | .clearer => trivial
  | .source => rfl
  | .dweller => rfl

/-- Each formation's region along its dependence is its feeding closure: the clearer with the
source that feeds its resource, and the source and the dweller, which nothing feeds, each
alone. -/
theorem dependenceRegion_iff (p f : Formation) :
    dependenceRegion p f ↔ flow.WithinFeeding web p f :=
  ⟨fun inside => match p, f, inside with
    | .clearer, .source, _ =>
      Flow.WithinFeeding.of_fedBy (L := flow) (W := web) (e := (.clearer, 0))
        (e' := (.source, 0)) ⟨rfl, .resource, trivial, .head _, Nat.zero_lt_one⟩
    | .clearer, .clearer, _ => Flow.WithinFeeding.refl _
    | .clearer, .dweller, no => nomatch no
    | .source, .source, _ => Flow.WithinFeeding.refl _
    | .source, .clearer, no => Formation.noConfusion no
    | .source, .dweller, no => Formation.noConfusion no
    | .dweller, .dweller, _ => Flow.WithinFeeding.refl _
    | .dweller, .source, no => Formation.noConfusion no
    | .dweller, .clearer, no => Formation.noConfusion no,
   fun within =>
     within (dependenceRegion p) (dependenceRegion_closed p) (dependenceRegion_self p)⟩

/-- The dweller lies beyond the clearer's feeding closure. -/
theorem dweller_beyond : ¬ flow.WithinFeeding web .clearer .dweller :=
  fun within => within alongDependence fedClosed trivial

/-- What lies beyond the closure need not return. Everything within the clearer's feeding
closure is supported at every step and the clearer is active at every step, while the dweller,
beyond the closure, is unsupported from the third step on. -/
theorem closure_supported :
    (∀ t f, flow.WithinFeeding web .clearer f → web.Supported t f) ∧
      (∀ t, web.active t .clearer) ∧ (∀ n, ¬ web.Supported (n + 2) .dweller) ∧
      ¬ flow.WithinFeeding web .clearer .dweller :=
  ⟨fun t f within => match f, within alongDependence fedClosed trivial with
    | .source, _ => fun _ no => nomatch no
    | .clearer, _ => dependent t .clearer trivial
    | .dweller, no => (nomatch no),
   fun _ => trivial, unsupported_with, dweller_beyond⟩

end Clearing

end Becoming
