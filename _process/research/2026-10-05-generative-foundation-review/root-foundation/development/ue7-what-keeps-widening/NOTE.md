# UE7: what keeps widening, and what it needs (note on the Lean)

26 October 2026, revised the same day after the [independent review](REVIEW-UE7.md). An AI-authored note for board item UE7, written after the [design note](DESIGN.md). It states what the kit's Lean proves, the premises, how each law corresponds to its neighbours, the grades, and what stays open. No chapter, record, board row or landed module is changed, and nothing is committed.

Marks and terms:
- **[AI reading]** is an interpretation by the AI, not a theorem.
- "The first law" is the package's name for `Flow.Gainless` (nothing comes from nothing).
- "Upkeep" names the premise `Flow.TakesWhileSupported`, in prose only.
- "The World premises" are balance (`Flow.Balances`), only active formations giving (`Flow.Acting`), activity needing support (`Web.Dependent`) and requirements never loosening (`Web.Unloosened` at every step and formation).
- "Carry on, or pass support" is the continuation `Web.passingContinuation (L.PassesSupport W)`: each formation continues as itself, or as a formation it passes support to.

## 1. Status

- **Module.** [`tree/Becoming/KeepingWidening.lean`](tree/Becoming/KeepingWidening.lean), `Becoming.KeepingWidening`, a new leaf of the pure core. It was `Becoming.SustainedWidening`; the item and the property say "keeping widening" (S10). It imports four package modules: `Becoming.EventualWideningInstances`, `Becoming.Gain`, `Becoming.MapInstances` and `Becoming.Thresholds`. Its import closure has 88 modules, itself included; every other one is in the checker's CORE or FOUNDATION list.
- **Modified copies of landed modules (board rule 9).** [`Population`](tree/Becoming/Population.lean), [`Novelty`](tree/Becoming/Novelty.lean), [`Gain`](tree/Becoming/Gain.lean) and [`Admission`](tree/Becoming/Admission.lean) are copies of main at `5d4941161`, changed only as §7.2 lists. Each copy's base is the file's last commit:

  | Module | Base commit | Base blob |
  |---|---|---|
  | Population | `df26acbc8` | `7f0112e8…` |
  | Novelty | `e936f8ee6` | `61dfc732…` |
  | Gain | `866370911` | `9d7017fe…` |
  | Admission | `c99e2af06` (OU3b's landing) | `045fc401…` |

  OU3b landed while this revision was under way. The Admission copy, first made from `58b0bca50`, was merged three-way onto OU3b's Admission with no conflict: OU3b's hunks lie near lines 55, 334 and 364, the kit's near 180 and 220. OU3b did not touch the other three files.
- **Build.** A scratch build of the whole kit tree against main at `5d4941161` gives these counts ([scratch.log](scratch.log) holds its output and the audits' own lines):

  | Module | Theorems | Declarations | Before |
  |---|---|---|---|
  | `Becoming.KeepingWidening` (new) | 126 | 154 | 118 in 144 (the reviewed kit) |
  | `Becoming.Population` | 122 | 147 | 121 in 146 (main) |
  | `Becoming.Novelty` | 22 | 23 | 19 in 20 (main) |
  | `Becoming.Gain` | 29 | 34 | 29 in 34 (main) |
  | `Becoming.Admission` | 56 | 84 | 53 in 81 (main) |

  **All 442 axiom reports are empty**: no `propext`, `Quot.sound` or `Classical.choice`. There is no warning or error. In the new module and in the changed hunks:
  - every proof is a term;
  - the only decisions are `Nat.decLe`, `Nat.decLt` and supplied `Decidable` hypotheses;
  - there is no `sorry`, `axiom`, `opaque`, `unsafe`, `native_decide` or `set_option`.

  As the brief asked, the core checker (`check_becoming.py`) was not run. Its environment audit, its controls and its prelude-only compile wait for a landing.
- **Statements unchanged.** [UE7Check.lean.txt](UE7Check.lean.txt) prints every declaration of main's Population, Novelty, Gain and Admission, 281 in all, with `pp.all`. It was compiled against main and against the kit's copies, and the two outputs are byte-identical (sha256 `42e30a06…708d37cc`). [UE7-statements.txt](UE7-statements.txt) gives the seven re-proved statements as printed. No definition in the four modules changes.
- **Patches.** [patches/](patches/) holds one patch per modified module. Each is a `git diff --no-index --full-index` from the module's base blob to the kit copy, so `git apply --3way` can merge it onto a main that has moved.

  | Patch | Hunks | Lines |
  |---|---|---|
  | Population | 1 | +33 −3 |
  | Novelty | 2 | +82 −21 |
  | Gain | 2 | +30 −17 |
  | Admission | 2 | +73 −18 |

  Each patch re-applies byte-identically to its base, and `git apply --check` passes on the checkout at `5d4941161`.
- **Names.** No declaration name in the five modules collides with one in any other package module. This was checked by parsing every module's namespaces and declarations; the root module imports them all. No name contains a word of exchange (the checker's `MARKET_WORDS`).
  - The witnesses reuse UE4's namespaces (`ClosedCycle`, `OpeningChain`, `Saturated`, `OwnCondition`) and add `Ladder`, `Loosening` and `Source`.
  - A passing of support takes the core's passing vocabulary (`Flow.PassesSupport`, I2), and "opening" keeps the core's sense (`KeepsOpening`, `ExceedsAcross`).
  - The laws concluding 全生成 take the word of the landed `Web.itself_not_generation`: `Flow.generation_of_brief` and `Flow.generation_of_includes_brief`, formerly `generates_of_…`.

## 2. What the Lean proves

Notation: `W : Web F C`, `L : Flow F C`, `cs : List C`.
- *Keeping widening by name on the actual levels* is `W.KeepsWidening Web.itself W.level T`.
- `req` stands for `∀ t f, T ≤ t → W.Supported t f → W.RequiresWithin cs f`: every formation supported from `T` on requires, at every step and at one need, only members of `cs`.
- Each statement below is quoted from the kit, with implicit arguments left out.

### 2.1 Law 1, the gain bridge

```lean
theorem Web.KeepsWidening.passes_every_bound (keeps : W.KeepsWidening itself W.level T)
    (req : ∀ t f, T ≤ t → W.Supported t f → W.RequiresWithin cs f) (K M : Nat) :
    ∃ t, M ≤ t ∧ K < W.stock cs t
theorem Web.KeepsWidening.rises_late (keeps) (req) (M : Nat) :
    ∃ t, M ≤ t ∧ W.stock cs t < W.stock cs (t + 1)
theorem Web.KeepsWidening.from_rest_or_open (keeps) (req) (gainless : L.Gainless)
    (distinct : Distinct cs) (M : Nat) :
    ∃ t, M ≤ t ∧ ((L.withImbalance W).NetGiver cs t none ∨ ¬ L.ClosedAt cs t)
theorem Web.KeepsWidening.open_late (keeps) (req) (gainless) (distinct)
    (balances : ∀ t, T₀ ≤ t → L.BalancesOn W cs t) (M : Nat) : ∃ t, M ≤ t ∧ ¬ L.ClosedAt cs t
theorem Flow.whole_not_keepsWidening (every : ∀ c, c ∈ all) (distinct : Distinct all)
    (gainless : L.Gainless) (balances : ∀ t, T₀ ≤ t → L.BalancesOn W all t)
    (req : ∀ t f, T ≤ t → W.Supported t f → W.RequiresWithin all f) :
    ¬ W.KeepsWidening Web.itself W.level T
```

**Steps.**
- In Novelty, `Web.exceeds_of_distinct_configs` is the pigeonhole for a list of steps: if the configurations of `cs` at the listed steps are pairwise distinct, and the list is longer than the number of configurations within `K`, some listed step has stock above `K`. Beside it, `Web.unbounded_of_distinct_configs`: a family with such lists of every length, from every step on, exceeds every bound at arbitrarily late steps.
- `Web.KeepsWidening.distinct_configs` gives, for every `n`, `n` steps from `T`, all at most some `S`, with pairwise distinct configurations. So `passes_every_bound` is a case of `unbounded_of_distinct_configs`.

**Constructive need.** None. No sequence is chosen. The only decisions are on the order of numbers, at finitely many listed steps (`search` with `Nat.decLe`).

**Witnesses.** `Ladder.frontier_witness` meets the premises together, under the first law and balance; its family `[0]` is open at every step. Each witness below meets every premise but one, and the conclusion fails:

| Premise dropped | Witness | What fails |
|---|---|---|
| nothing lost | `ClosedCycle.bounded_while_opening` | stock 1 throughout; never given from beyond |
| a finite family | `OpeningChain.fixed_but_unbounded` | no finite family's stock passes its length |
| fixed needs | `Loosening.bounded_while_widening` | stock 1 throughout |
| the first law | `Source.from_nothing` | a finite, balanced world keeps widening with its family closed and never given from beyond, so `whole_not_keepsWidening` fails too |

**A modelling dependence** [AI reading, argued, not proved in Lean]. `passes_every_bound` uses the fact that a finite family has finitely many configurations within a bound, which holds for natural-number amounts.
- With amounts in a dense order it fails: needs approaching a limit from below would support ever more formations at a bounded stock.
- A rise of some required condition at arbitrarily late steps does not depend on this. Neither does the family-of-one form of the second half, since every newly supported formation needs a required condition to have risen since its last unsupported step.

### 2.2 Law 2, renewers multiply

```lean
def Flow.TakesWhileSupported (L : Flow F C) (W : Web F C) (cs : List C) (T : Nat) : Prop :=
  ∀ t f, T ≤ t → W.Supported t f → f ∈ L.present t ∧ 0 < total cs (L.take t f)
theorem length_le_count {q : α → Nat} : ∀ {xs ps : List α}, Distinct xs →
    (∀ a, a ∈ xs → a ∈ ps ∧ 0 < q a) → xs.length ≤ count ps q        -- in Population
theorem Web.KeepsWidening.more (keeps : W.KeepsWidening itself W.level T)
    (takes : L.TakesWhileSupported W cs T) : L.More cs
theorem Web.KeepsWidening.replenishment_unbounded (keeps) (takes)
    (balances : ∀ t, T₀ ≤ t → L.BalancesOn W cs t) (R : Nat) :
    ¬ ∀ t, T₀ ≤ t → L.replenishment cs t ≤ R
theorem Web.KeepsWidening.renewers_unbounded (keeps) (takes) (balances)
    (capacity : L.Capacity cs g) (M : Nat) : ¬ ∀ t, T₀ ≤ t → L.renewers cs t ≤ M
```

**Steps.**
1. For every `K`, `KeepsWidening.gathers` gives `K` distinct formations admitted together.
2. Nothing lost keeps them supported, and upkeep makes them takers.
3. `length_le_count` gives `K ≤ L.takers cs t`. That is `Flow.More cs`.
4. The landed `Flow.More.replenishment_unbounded_from` and `Flow.More.renewers_unbounded_from` conclude.

Law 2 does not need `cs` to hold the formations' requirements: `cs` is any family they take from.

**Entries, not formations** (I4). Takers and renewers count entries of the present list: `Flow.count` totals `sign` over `present t`. So a formation listed `m` times counts `m` times, and `Capacity` bounds each entry. The law says that the entries giving to the family are bounded from no step on. It says the same of formations only where the present list has no repetition. No witness here lists a formation twice.

**Constructive need.** None. `length_le_count` needs neither a decision of equality nor a double negation: the distinctness of the first list supplies the inequality `mem_remove` asks for. UE4 expected it to need one or the other.

**Witnesses.** `Ladder.upkept_witness` meets the premises together, and the first law as well. By the law itself, its renewers of `[0]` are bounded from no step on. Each witness below meets every premise but one and has at most one renewer a step:

| Premise dropped | Witness | How the premise fails |
|---|---|---|
| upkeep | `Ladder.upkeep_needed` | only the carrier takes part |
| capacity | `Ladder.capacity_needed` | the carrier gives all that is taken, and one more |
| balance | `Ladder.balance_needed` | nothing gives, so there are no renewers |
| nothing lost | `ClosedCycle.renewers_bounded_while_opening` | the cycle keeps opening, but does not keep widening |

### 2.3 Law 3, the uniform form of support passing on, and opened by the opened

The first step is stated once, in Admission (S1):

```lean
theorem Flow.gain_given_by_supported_at
    (balances : ∀ c, W.requires t f c → L.BalancesOn W [c] t)
    (givers : ∀ c, W.requires t f c → L.GiversSupported W t c) (gains : W.GainsSupport t f)
    (unloosened : W.Unloosened t f) :
    ¬ ¬ ∃ c g, W.requires t f c ∧ W.Rises t c ∧ g ∈ L.present t ∧ 0 < L.give t g c ∧
      W.Supported t g
```

The landed `Flow.gains_from_supported_at` is re-proved from it with its statement unchanged. The uniform law follows, also in Admission:

```lean
theorem Flow.gain_given_by_recent_gainer_at
    (balances : ∀ c, W.requires (S + K) f c → L.BalancesOn W [c] (S + K))
    (givers : ∀ c, W.requires (S + K) f c → L.GiversSupported W (S + K) c)
    (unloosened : W.Unloosened (S + K) f)
    (brief : ∀ g, ¬ ∀ i, i ≤ K → W.Supported (S + i) g)
    (gains : W.GainsSupport (S + K) f) :
    ¬ ¬ ∃ c g u, W.requires (S + K) f c ∧ W.Rises (S + K) c ∧ g ∈ L.present (S + K) ∧
      0 < L.give (S + K) g c ∧ W.Supported (S + K) g ∧ S ≤ u ∧ u < S + K ∧ W.GainsSupport u g
```

**Variants.**
- `Flow.gain_given_by_recent_gainer` (Admission) takes the World premises and brevity at every step. The landed `Flow.support_passes_on` is re-proved from it, with its statement unchanged and with no subtraction.
- `Flow.gain_given_by_recent_gainer_decided` (the leaf) gives the same conclusion positively. It needs `decided : ∀ t g, Decidable (W.Supported t g)`, the gainer's requirements at the step listed in some `cs`, and those requirements decided. It uses `upto_or_fails` of Novelty, which Admission does not import, so it stays above Novelty (E2).

**Definition.**

```lean
def Flow.OpenedByOpenedWithin (L : Flow F C) (W : Web F C) (K : Nat) : Prop :=
  (∀ N, ∃ t f, N ≤ t ∧ W.GainsSupport t f) ∧
    ∀ S f, W.GainsSupport (S + K) f → ¬ ¬ ∃ c g u, W.requires (S + K) f c ∧ W.Rises (S + K) c ∧
      g ∈ L.present (S + K) ∧ 0 < L.give (S + K) g c ∧ W.Supported (S + K) g ∧ S ≤ u ∧
      u < S + K ∧ W.GainsSupport u g
```

**Its exemption and its empty case** (I3). Gains before step `K` are not constrained; there, formations supported from the start, which never gained support, may give. Within `0` holds of no flow (`Flow.not_within_zero`). Every form must exempt founders: formation 0 of the relay and of the lagged relay never gained support. UE4's form exempts gains up to its origin, and this one exempts gains before step `K`, so the bound does two jobs.

**Its laws.**
- Brief supports give it (`Flow.openedByOpenedWithin_of_brief`).
- It is monotone in the bound (`.succ`, `.add`, `.mono`).
- It gives the lagged form of a fixed origin: gains from `T + K` on are given by gainers from `T` on (`.lagged`).
- UE4's `Flow.OpenedByOpened` at every origin gives it with bound one (`Flow.openedByOpenedWithin_of_opened`).
- Where nothing is supported from some step on, it holds within no bound (`Flow.OpenedByOpenedWithin.not_of_unsupported`, UE4's `not_of_unsupported` restated with the same proof).

**A change of class, not a relaxation** (O3). `openedByOpenedWithin_of_opened` needs UE4's form at every origin. The landed uses read that form at one origin (`relay_opened`, `ClosedCycle.opened` and `Saturated.reverses`, at origin 0) or at none ("from no step"). At a single origin, UE4's form does not give the recency form, and the recency form does not give UE4's (`OpeningChain.forms_independent`):
- **The late single giver** (`OpeningChain.lateGiver`). On `OpeningChain.web`, formation 0 takes part at step 0 and formation 1 at every later step, each giving the unit that steps the rising course. It balances, and only active formations give. It is opened by the opened in UE4's form at origin 0, since formation 1 gained support across the step from 0 (`lateGiver_opened`). In the recency form it is opened by the opened within no bound (`lateGiver_not_within`).
- **The lagged relay** goes the other way: within two, and at no origin in UE4's form (`OpeningChain.within_not_fixed_origin`). From step 2 on, each gain is given by the formation that gained support two steps before. The gains at steps 0 and 1 are given by formation 0, which never gained support, and within two leaves gains before step 2 unconstrained (E1).

The recency form drops a giver that gained support once after the origin and carries every later gain. It admits givers that gained support within `K` steps, whatever the origin.

**[AI reading]** The late giver is the stronger reason for the replacement. UE4's form counts one lasting carrier as opened by the opened whenever that carrier began after the origin. That defeats the purpose 07 §2 gives the property: the relay opened by the opened, the single giver not. The recency form excludes the late giver at every bound.

**Constructive need.** There are two double negations, each locating something:
- which required condition rose, from `GainsSupport.rises`, in `gain_given_by_supported_at`;
- at which step of the window the giver gained support, from `comes_within_not_not`.

The decided form shows exactly what removes them. It decides support at each of the finitely many steps of the window, and membership of a listed family. No omniscience principle enters.

**Witnesses.**
- *Premises together:* `ClosedCycle.opened_within`, brief with `K = 1`.
- *Brevity dropped:* `OpeningChain.brevity_needed`. The single giver meets every other premise, its supports last, and it is opened by the opened within no `K`.
- *Brevity is sufficient, not necessary:* `OpeningChain.carriers_within`. The relay, whose supports last, is opened by the opened within one.
- *The forms are independent:* the late giver and the lagged relay, above.
- *UE4's witnesses restated for the recency form* (each with the same proof idea):

  | UE4 | Restated |
  |---|---|
  | `OwnCondition.not_opened` | `OwnCondition.not_within` |
  | `OpeningChain.relay_opened` | `OpeningChain.relay_within` |
  | `OpeningChain.oneGiver_not_opened` | `OpeningChain.oneGiver_not_within` |
  | `OpeningChain.carried` | `OpeningChain.carriers_within` |
  | `Saturated.still_not_opened` | `Saturated.still_not_within` |
  | `Saturated.reverses` | `Saturated.reverses_within` |
  | `ClosedCycle.opened` | `ClosedCycle.opened_within` |
  | `ClosedCycle.cycle` | `ClosedCycle.cycle_within` |

`Saturated.reverses` is not at risk: `reverses_within` is proved from `relay_within`, `still_not_within` and the landed `level_rising`, `level_full` and `full_widens_rising`.

**A two-parameter form (S6), not adopted.** The review suggests `OpenedByOpenedWithinFrom L W T K`: gains across steps from `T + K` on are given by gainers within the `K` steps before. It would separate "from when" from "how recent" and parallel `KeepsWidening _ _ T`. Every use reads the form at `T = 0`: brief supports, the cycle, the relay, the lagged relay, the late giver and the restated witnesses. The one-parameter form already exempts exactly the gains before step `K`, now stated, and `.lagged` gives the "from `T`" reading as a consequence. A second parameter would put an argument no use sets on every law and witness, and keeping both forms would add a second definition. If a use needs a late start (a flow opened by the opened only after a founding stretch), the two-parameter form can be defined then, with this one as its `T = 0` case.

### 2.4 Law 4, the map law

```lean
def Web.admitting (W : Web F C) (l : Nat → C → Nat) : Web F C :=
  ⟨W.level, fun t f => W.Admits (l t) t f, W.requires, W.need, W.draws⟩
theorem Web.includesAcrossFrom_iff_endless :
    W.IncludesAcrossFrom R l T ↔ ∀ S f, T ≤ S → W.Admits (l S) S f →
      «不穷» (continuationStep R) (W.admitting l).activityClass (S, f)
theorem Web.kept_of_includes_by_name (includes : W.IncludesAcrossFrom itself l T)
    (from_ : T ≤ S) (admitted : W.Admits (l S) S f) :
    «全守» (continuationStep itself) (W.admitting l).activityClass (W.admitting l).carrierClass (S, f) ∧
      ¬ «全生成» (continuationStep itself) (W.admitting l).activityClass (W.admitting l).carrierClass (S, f)
def Flow.PassesSupport (L : Flow F C) (W : Web F C) (t : Nat) (g f : F) : Prop :=
  g ∈ L.present t ∧ W.Supported t g ∧ W.GainsSupport t f ∧
    ∃ c, W.requires t f c ∧ W.Rises t c ∧ 0 < L.give t g c
theorem Flow.passesSupport_carries_iff (supported : W.Supported t g) :
    «传» (continuationStep (passingContinuation (L.PassesSupport W))) (W.admitting W.level).activityClass
      (W.admitting W.level).carrierClass (t, g) (t + 1, f) ↔ L.PassesSupport W t g f
theorem Flow.generation_of_brief (brief : ∀ t g, ¬ ∀ i, i ≤ K → W.Supported (t + i) g)
    (start : W.Supported x.1 x.2)
    (endless : «不穷» (continuationStep (passingContinuation (L.PassesSupport W)))
      (W.admitting W.level).activityClass x) :
    «全生成» (continuationStep (passingContinuation (L.PassesSupport W)))
      (W.admitting W.level).activityClass (W.admitting W.level).carrierClass x
theorem «全生成则生成» {R L E : «际» α} {x : α} (h : «全生成» R L E x) : «生成» R L E x
```

**What it answers** (O1). It answers part of 02's open item:
- (a) Along a continuation from `T`, nothing lost is exactly this: from every occurrence admitted from `T` on, the admitted pattern's line never ends (不穷). This is `includesAcrossFrom_iff_endless`, an exact equivalence.
- (b) By name, nothing lost gives 全守, and nothing is 全生成 by name (`kept_of_includes_by_name`, I7). A course keeping widening by name is a case, through its first half; `KeepsWidening.kept_by_name` is dropped.
- (c) Along "carry on, or pass support", a carrying renewal from a supported occurrence is exactly a passing of support (`passesSupport_carries_iff`). Every gain is one, up to double negation (`Flow.gain_carried`, from Admission's `gain_given_by_supported_at`).
- (d) Brief supports make every supported endless line 全生成, without the World premises (`generation_of_brief`). With (a), a range losing nothing along "carry on, or pass support" from `T`, its supports brief, is 全生成 at every occurrence supported from `T` on (`generation_of_includes_brief`).

**全生成 is 生成** (S9). On the grammar, the points the line from `x` reaches form a branch (`«全生成则生成»`, five lines). So wherever the map reads 全生成 on the World it reads 生成, and the cycle is 生成 at every supported occurrence (`ClosedCycle.generates`). 02's first open item, reading the some-branch regions on the World where the strong forms fail, is untouched.

**The class read** (I8). Law 4 is stated on `W.admitting l`, whose activity is admission by `l`; on the actual levels, that is support. The generation in law 4 is therefore that of the admitted (supported) pattern. The World theorems of 02 §1 read the web's own activity, and under `Dependent` activity implies support, not the converse.

**Further lemmas.** `Web.Linked.steps_le`, `.same_of_at`, `.one_step`, `Web.linked_of_reached`, and `Flow.passes_or_carried_on`. The last gives each successor with its case, carrying on or passing support, and decides nothing.

**Constructive need.** None, except the double negation that `gain_carried` inherits from law 3's first step.

**Witnesses.**
- `ClosedCycle.generation_without_widening`, the premises together. The cycle is 全生成 at every supported occurrence. Along "carry on, or pass support" its levels exceed from no step to a later one, and by name it keeps widening from no step. `ClosedCycle.generates` adds 生成.
- `Saturated.lasting_kept`, brevity dropped. Every line never ends and keeps, and none is 全生成.
- `OwnCondition.rising_kept`: by name, the rising course is kept, and it is not 全生成, as nothing is by name.

### 2.5 Law 5, the exclusion along passing of support (S8)

```lean
theorem Web.Linked.snoc : Linked R s f t g → R t g h → Linked R s f (t + 1) h
theorem Flow.descends_along_passings (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) (unloosened : ∀ t f, W.Unloosened t f) (S : Nat) :
    ∀ k g, W.Supported (S + k) g →
      ¬ ¬ ∃ f, Web.Linked (Web.passingContinuation (L.PassesSupport W)) S f (S + k) g ∧
        W.Supported S f
theorem Flow.not_exceedsAcross_along_passings (balances) (acting) (dependent) (unloosened)
    (contains : ∀ t g f, Web.passingContinuation (L.PassesSupport W) t g f → R t g f)
    (le : S ≤ U) : ¬ W.ExceedsAcross R W.level S U
theorem Flow.not_keepsOpening_along_passings (balances) (acting) (dependent) (unloosened)
    (contains) (T : Nat) : ¬ W.KeepsOpening R W.level T
theorem Flow.not_keepsWidening_along_passings (balances) (acting) (dependent) (unloosened)
    (contains) (T : Nat) : ¬ W.KeepsWidening R W.level T
```

**Steps.** By induction on `k`, a formation supported at `S + k + 1` was supported at `S + k`, and is carried on; or it gained support, and then (`gain_carried`) a supported formation passed support to it, up to double negation. Either way the chain from `S` extends by one step (`Linked.snoc`). The case split on support at `S + k` is taken inside a double negation, so nothing is decided. With the chain, a formation admitted at `U` is linked to one admitted at `S`, which is what exceeding denies. `ExceedsAcross.anti` carries the result to every continuation containing passing of support. This is the stronger form the review asks for: no `ExceedsAcross S U` for any `S ≤ U`, not only "keeps opening from no step".

**Instance** (I1). `ClosedCycle.not_opening_along` (`S ≤ U → ¬ web.ExceedsAcross (passingContinuation (flow.PassesSupport web)) web.level S U`) is the law's instance, and `generation_without_widening` states it.

**What it says for 02's item.** On each reading the kit uses, 全生成 and keeping widening cannot hold together:
- **By name**, nothing is ever 全生成 (`Web.itself_not_generation`, landed).
- **Along "carry on, or pass support"**, under the World premises, nothing keeps opening or keeps widening, from any step, and the same holds along every continuation containing it.

"Generation and widening are independent both ways" held only by comparing two readings: the cycle is 全生成 along passing of support, and the rising course keeps widening by name. A reading on which the two hold together would have to leave out some step of "carry on, or pass support", as the merge continuation of `MergedWitness` leaves out carrying on as itself; none is constructed.

**Constructive need.** One double negation, from `gain_carried`, and the excluded middle on support taken inside it.

## 3. Correspondence to the neighbours

The neighbours were checked in the [design note](DESIGN.md#6-the-neighbours-checked) by reading pages on 26 October; no file was installed. The review checked further pages (its list is in [REVIEW-UE7.md](REVIEW-UE7.md)), including the TAP paper's logistic variant and assembly theory's remarks on mass. This revision fetched nothing.

| Neighbour | Its statement | Lean counterpart | How they correspond | Grade |
|---|---|---|---|---|
| Open systems (Prigogine; Schrödinger) | sustained organization needs throughput | `from_rest_or_open`, `open_late` | conserved quantity ↔ levels of `cs` under `Gainless`; organization kept ↔ formations kept supported at fixed needs; throughput ↔ net giving by the rest, or exchange across the family's boundary | restatement |
| Finite Poincaré recurrence | a bounded closed system returns | `whole_not_keepsWidening` | finite, closed, balanced world ↔ bounded closed system; the theory's `Flow.whole_recurs_of_rest_idle` is the recurrence, and keeping widening is excluded there | restatement |
| Open-ended evolution (Bedau and others 2000; Adams and others 2017) | unbounded evolution measured against an isolated system's recurrence | `whole_not_keepsWidening` | unbounded kept widening with fixed finite requirements is impossible in a finite, balanced world under the first law | restatement |
| TAP equation (Cortês, Kauffman, Liddle and Smolin) | with `μ = 0` kept types grow combinatorially; its Eq. 1 has no resource term | `passes_every_bound`, `from_rest_or_open` | type ↔ formation with fixed needs on finitely many conserved stocks; unbounded kept growth then needs the stocks to pass every bound, fed from beyond | restatement: the framework as stated omits conservation, which its own variants supply (the paper's logistic variant limits innovation, §5.3) |
| Assembly theory (Sharma and others 2023) | selection measured by assembly steps and copy numbers | as for TAP | as for TAP | restatement: no balance term is stated, but the paper notes mass constraints on what is produced, qualitatively |
| Autocatalytic sets (Hordijk and Steel) | self-sustaining sets are food-generated; their dynamics, growth and division are studied (Hordijk and Steel 2012; Vasas and others 2012) | `from_rest_or_open` | food set ↔ what is given from beyond | restatement, more firmly |
| Maintenance and depreciation: break-even investment (Solow 1956); Pirt's maintenance coefficient (1965); knowledge depreciation (Caballero and Jaffe 1993); the burden of knowledge (B. F. Jones 2009); the Malthusian bound | maintaining a stock needs input in proportion to it | `KeepsWidening.more`, `replenishment_unbounded`, `renewers_unbounded` | upkeep ↔ depreciation or maintenance; renewers ↔ the input that offsets it; maintained stock ↔ takers kept supported; intake ↔ replenishment; capacity per renewer ↔ bounded input per unit | restatement |
| Semi-endogenous growth (Jones 1995) | sustained exponential growth of ideas needs growing researchers, given `φ < 1` | `renewers_unbounded` | the model that leaves the course open without depreciation: with constant researchers `A` grows without bound; with depreciation the model forbids it, as break-even investment does | restatement: the model as stated omits upkeep, which its neighbours supply |
| Bloom and others 2020 | research productivity falls | `renewers_unbounded` | [AI reading] upkeep of an accumulating range is one mechanism for the pattern | an alternative mechanism, not a forbidden course |
| Demography with a maximal lifespan; `Web.begins_within` | parents alive now were born within one lifespan; a lasting pattern of brief carriers has carriers that begin | `gain_given_by_recent_gainer(_at)`, `generation_of_brief` | giving ↔ parenting; gaining support ↔ birth; brevity `K` ↔ maximal lifespan | near-definitional |
| Biogenesis ("every cell from a cell"); `Web.ByPassing.trace` | the living descends from the living | `descends_along_passings`, `not_exceedsAcross_along_passings` | supported ↔ alive; passing of support ↔ descent | near-definitional |

No row is a third part in the UE plan's sense, which asks for the framework's premises on the premise card and an instance or equivalence theorem in Lean. Neither is built here (O2).

## 4. Grades

1. **The gain bridge:** a restatement. It reads `Flow.newly_supported_from_rest_or_open` for a course keeping widening, with lists of steps in place of sequences of first supports.
2. **Renewers multiply:** a restatement. It reads `Flow.More.renewers_unbounded_from` for keeping widening; what is new is that a range keeping widening by name under upkeep is more without end.
3. **The uniform form:** near-definitional (`Flow.gains_from_supported` with brevity). Its value is the fixed form of *opened by the opened*.
4. **The map law:** near-definitional. It unfolds the map's definitions beside `Web.begins_within`, and answers part of 02's open item, (a)–(d) of §2.4.
5. **The exclusion law:** near-definitional, the theory's biogenesis. It follows the gains of support back step by step, close to `Web.ByPassing.trace`, with the World premises supplying each passing up to double negation.

## 5. Is any law a result no neighbouring field states?

No, for four reasons:
- Each law follows in a few steps from a law the theory already has, joined to UE4's keeping widening or to the map. Those laws are `Flow.newly_supported_from_rest_or_open`, `Flow.More.renewers_unbounded_from`, `Flow.gains_from_supported` and `Web.begins_within`.
- Each course a law forbids is one a specialist in thermodynamics, growth theory, microbiology or demography would foresee.
- Where a law forbids what a framework as stated leaves open (TAP's equation, assembly theory, Jones 1995 without depreciation), the framework's own variants or neighbours supply the missing conservation or upkeep. UE0 graded "the sources' own exclusion, under a stronger premise" as no third part (its row 11), and the same holds here.
- None of the laws compares two courses, so none reaches the second-order direction of 生生.

For UE's objective the item therefore adds joining, not reach. It also adds:
- the form of *opened by the opened*, with the independence of the two forms (the late giver, the lagged relay) as the reason for a change of class;
- a count lemma that needs no decision;
- the exclusion law, which narrows 02's open item;
- the general laws below the landed ones (rule 9), from which seven landed laws are re-proved.

It answers part of 02's open item, (a)–(d), and narrows the rest. A result no neighbouring field states would have to come from what none of these laws touches: a comparison of two courses that never reverses widening and settles the lag, or growth by kinds not given in advance.

## 6. What stays open

- **The second-order comparison.** No law compares two courses, and the lag (`LagWitness.lag`) stays unsettled.
- **02's open item, narrowed:** a law relating 生成 (some branch, read on the World) to widening what can form. On the two readings so far, names and passing of support under the World premises, 全生成 and keeping widening cannot hold together. Open with it:
  - 生成 on the World where 全生成 fails;
  - any law on the opening half of keeping widening or on the widening order, beyond the exclusion;
  - the capture loop;
  - a reading on which 全生成 and keeping widening hold together.
- **Growth by kinds not given in advance; self-changing conditions.** The grammar cannot yet state these.
- **Law 1 under other premises:** requirements that tighten rather than stay fixed, and amounts in a dense order (see the modelling dependence in §2.1).
- **The forward law UE4 proposed:** that opened by the opened gives 生成 along some branch. It needs finitely many gainers at each step and an infinite pigeonhole (weak König's lemma) to choose the branch. It is not attempted.
- **Landing.** A person's reading, and the decisions of §7.3.

## 7. The review's findings, and landing

### 7.1 Each finding

| Finding | Taken | Where, or why not |
|---|---|---|
| E1 the lagged relay's first gains | yes | docstrings of `laggedRelay` ("for `t ≥ 1`, two steps after it gained support") and `laggedRelay_within`; §2.3; DESIGN §4 |
| E2 the decided form | yes, second option | stays in the leaf, above Novelty; `upto_or_fails` not moved (OU3b was reworking Recurrence) |
| O1 02's open item | yes | "answers part", (a)–(d), the narrowed item (§6), "independent both ways" removed, the exclusion law added (§2.5) |
| O2 third parts | yes | restatement grades for TAP, assembly theory and Jones 1995 (§3, DESIGN) |
| O3 too strict | yes | change of class, the late giver added, "too strict" dropped (§2.3) |
| O4 derivations beside landed laws | yes | the moves made in the copies; the kit's two derivations deleted |
| I1 "nothing is ever opened" | yes, stronger form | `Flow.not_exceedsAcross_along_passings`; `ClosedCycle.not_opening_along` is its instance |
| I2 `Flow.Opens` | yes | `PassesSupport`, `passesSupport_carries_iff`, `passes_or_carried_on`, and the cycle's lemmas (`passesSupport_next`, `linked_along_passings(_to)`, `includes_along_passings`) |
| I3 exemption and empty case | yes | definition docstring, `Flow.not_within_zero`, §2.3 |
| I4 entries with repetition | yes, as a caveat | docstrings, §2.2; no `Distinct (L.present t)` hypothesis, since the law about entries is the stronger |
| I5 RAF dynamics | yes | Hordijk and Steel 2012; Vasas and others 2012 (§3, DESIGN) |
| I6 Jones mapping | yes | upkeep ↔ depreciation or maintenance, renewers ↔ the input offsetting it; Solow 1956; Pirt's bibliographic details |
| I7 "disjoint" | yes | wording, and only `kept_of_includes_by_name` kept |
| I8 the class read | yes | module docstring, §2.4 |
| S1 one first step | yes | `Flow.gain_given_by_supported_at` in Admission |
| S2 one unboundedness law | yes | `Web.unbounded_of_distinct_configs` in Novelty |
| S3 restatements | yes | `Thresholds.le_of_not_not` imported; the `upto_*` facts no longer needed (the list laws use `steps`) |
| S4 counting | yes | `length_le_count` in Population; `length_le_of_sub` re-proved from it |
| S5 the leaf's reason | yes, for landing | §7.3 |
| S6 two-parameter form | no | §2.3: every use is at `T = 0`; definable later with this as its case |
| S7 records and homes | yes, as proposals | §7.3 |
| S8 the exclusion law | yes, stronger form | §2.5 |
| S9 全生成 to 生成 | yes | `«全生成则生成»`, five lines on the grammar |
| S10 the module's name | yes | `Becoming.KeepingWidening` |

### 7.2 The moves (board rule 9)

Each general law now lies below the landed laws it generalizes, and those laws are re-proved from it in place, statements unchanged:

| Module | Added | Re-proved from it |
|---|---|---|
| Population | `length_le_count`, with a case split in place of `sign_pos`, so nothing moves down from Dissipation | `length_le_of_sub` |
| Novelty | `Web.exceeds_of_distinct_configs`, `Web.unbounded_of_distinct_configs`, `Web.distinct_configs_of_apart` | `Web.exceeds_of_new`, `Web.unbounded_of_new`; the module docstring names the list laws |
| Gain | nothing | `Web.exceeds_of_firsts`, `Web.rises_late_of_firsts`; the module docstring says both are cases of Novelty's list form |
| Admission | `Flow.gain_given_by_supported_at`, `Flow.gain_given_by_recent_gainer_at`, `Flow.gain_given_by_recent_gainer` | `Flow.gains_from_supported_at`, `Flow.support_passes_on` |

The leaf derives its own laws from the same ones:
- `KeepsWidening.passes_every_bound` from `unbounded_of_distinct_configs`;
- `gain_carried` from `gain_given_by_supported_at`;
- the definition's laws from `gain_given_by_recent_gainer`.

The kit's restatements are gone: `le_of_double_negation`, `upto_mem_lt`, `upto_length_self` and `upto_distinct`. The list laws use `steps` with Population's `steps_length`, `steps_within` and `steps_distinct` and Change's `steps_mem`, so nothing needs to land in Prelude. Admission's module docstring is unchanged, to keep its hunks away from OU3b's; a landing may add a line for the three new laws.

### 7.3 What landing needs (decisions for the owner and the integrator)

- **Order.** Apply the four patches with `git apply --3way` (Population, Novelty, Gain, Admission), add `Becoming/KeepingWidening.lean`, register it in the root module and the checker's CORE list, then run the checker. The modules above Population, Novelty, Gain and Admission rebuild; their statements are unchanged.
- **The leaf's reason (S5).** It joins EventualWidening with Gain, Flow and MapInstances, which no landed module joins, and imports Thresholds for `Thresholds.le_of_not_not`. The board row and the package README row should say so.
- **Homes** (S8, S9). `Web.Linked.snoc` restates nothing landed and could land in ContinuedClasses beside `Linked.mono`. `«全生成则生成»` could land in GrammarMap beside `«不穷则延»`. Both are kept in the leaf here, since moving them would rebuild everything above those modules. That is the integrator's choice.
- **Records (S7), proposals.**
  - One record for the item, homed in 07 §2 after r-eventual-widening, can hold laws 1, 2, 4 and 5 with their witnesses.
  - Law 3's general form extends the support-passed-on record (02) rather than starting a new one, since the landed law is now its corollary.
  - 02's Open item is narrowed as in §6.
- **The definition change.** `Flow.OpenedByOpenedWithin` would replace UE4's `Flow.OpenedByOpened` (EventualWideningInstances), whose docstring says its first law would fix its form. The landed definition is not edited: it stays as a superseded candidate. The owner of EventualWideningInstances decides. The review's section "What the replacement changes" lists what follows; the main points:
  - UE4's record, law 7, takes the new definition and its laws, states the exemption and `K ≥ 1`, and drops "provisionally". The old form is kept as a superseded candidate, with the lagged relay and the late giver as the reasons.
  - Laws 8, 11, 12 and 13 move to the restated witnesses of §2.3.
  - "Does not show" and "Next" change with UE7. The gain bridge and the givers law are now proved, as restatements, not "candidates no neighbouring field states".
  - 07 §2 r-eventual-widening changes "(every later gain given by a formation that gained support before)" to "(every gain from step `K` on given by a formation that gained support within the `K` steps before)", and drops "provisional".
  - 07's Open item "The second-order direction of 生生" narrows to the comparison itself.
  - The root module's description, the README's L1 row and the generated indexes follow.
- **Wording outside the kit.** The board row and the commit message of `71ec77fa0` carry the overclaims of O1–O3 ("answers 02's open item", the third parts, "too strict"). The board row should change at landing; the commit message stays as history.

## 8. What the record may claim, and what it should not

**It may claim:**
1. **Law 1, a restatement (open systems; finite recurrence).** Take a course keeping widening by name on the actual levels, in which every formation supported from `T` on requires, at every step and at one need, only conditions of a finite list. Then:
   - its stock on that list passes every bound, and rises, at arbitrarily late steps;
   - under the first law, with the list without repetition, at arbitrarily late steps the list is given net by the rest or is not closed;
   - with balance on the list from a step as well, it is not closed at arbitrarily late steps.

   Moreover, a finite, closed world, balanced on all its conditions under the first law, has no course keeping widening by name with its requirements so fixed. All this uses whole-number amounts.
2. **Law 2, a restatement (maintenance scaling: depreciation, Pirt, break-even investment).** Under upkeep, a course keeping widening by name has more takers without end. With balance on the family from a step, its replenishment is bounded from no step on. With bounded giving per entry, its renewers are too. Renewers are entries of the present list, which are formations where the list has no repetition.
3. **Law 3, near-definitional.** The local, global and decided forms, and their one first step. The two double negations locate which condition rose and at which step of the window the giver gained support. Decided support and a listed family remove them, and no omniscience principle enters. The landed `support_passes_on` and `gains_from_supported_at` are corollaries.
4. **Law 4, near-definitional.** Items (a)–(d) of §2.4, and that 全生成 gives 生成 on the grammar. It answers part of 02's open item, and the generation it reads is that of the admitted (supported) pattern.
5. **Law 5, near-definitional (biogenesis).** Under the World premises, along every continuation containing passing of support, the levels exceed from no step to a later one, so nothing keeps opening or keeps widening there. On the two readings so far, 全生成 and keeping widening cannot hold together.
6. **The witnesses,** each premise shown needed as listed, with the lagged relay's first two gains given by formation 0.
7. **If adopted, the recency form of opened by the opened.** This covers its laws, its exemption before step `K` (within 0 holds of no flow), the independence of the two forms (the lagged relay and the late giver), and the restated UE4 witnesses.
8. **Rule 9.** The general laws stand below the landed laws they generalize (Population, Novelty, Admission). Seven landed laws are re-proved from them, all 281 statements of the four modules printed unchanged.
9. **Constructivity.** No choice anywhere; the count lemma needs no decision; every axiom report is empty.
10. **Standing.** None of the five is a result no neighbouring field states, none compares two courses, and the second-order direction of 生生 stays uncaptured.

**It should not claim:**
- that 02's open item is answered, or that there is a law relating 生成 to widening what can form;
- that generation and widening are "independent both ways", without adding that on each reading used they cannot hold together;
- that 生成 is read on the World beyond what 全生成 gives;
- third parts against TAP, assembly theory or Jones 1995;
- that the provisional form was merely too strict;
- that every gain of the lagged relay is given by a formation that gained support two steps before;
- that RAF theory has no growth laws;
- that renewers count formations, without the caveat on repetition;
- UE4's "a candidate no neighbouring field states" for the gain bridge or the givers law.

The review's two conditional items are now settled. The stronger statement about the cycle is proved: along passing of support its levels exceed from no step to a later one. The moves are made, so no derivation sits beside a landed law.

## 9. Readings [AI reading]

- A finite family whose kept widening goes on is fed from beyond, by the rest or across its boundary: keeping widening is a throughput phenomenon, as open-systems thermodynamics says.
- Under upkeep, a range keeping widening needs ever more renewers. This is one mechanism by which research productivity could fall with ideas no harder to find; the burden-of-knowledge literature proposes a close cousin.
- Where every support is brief, every balanced flow with recurring gains is opened by the opened (`openedByOpenedWithin_of_brief`). So the property tells carriers apart only where some support lasts, as with the single giver.
- Under the World premises nothing is new along lineage: this is the theory's form of "every cell from a cell". A course keeps widening by name only because names leave lineage out. That is a lead for what the second-order direction should count as novel.
- No ranking by generation is proposed. On each reading used, 全生成 and keeping widening cannot hold together, so a ranking by one would not order the other.
