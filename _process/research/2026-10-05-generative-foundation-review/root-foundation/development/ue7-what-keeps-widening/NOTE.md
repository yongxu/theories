# UE7: what keeps widening, and what it needs (note on the Lean)

26 October 2026. An AI-authored note for board item UE7, written after the [design note](DESIGN.md). It states what the kit's Lean proves, the premises, how each law corresponds to its neighbours, the grades, and what stays open. No chapter, record, board row or landed module is changed, and nothing is committed. Marks: **[AI reading]** is an interpretation by the AI, not a theorem; "the first law" is the package's name for `Flow.Gainless` (nothing comes from nothing); "upkeep" names the premise `Flow.TakesWhileSupported` in prose only.

## 1. Status

- **Module.** [`tree/Becoming/SustainedWidening.lean`](tree/Becoming/SustainedWidening.lean), `Becoming.SustainedWidening`: a new leaf of the pure core. It imports `Becoming.EventualWideningInstances`, `Becoming.Gain` and `Becoming.MapInstances`, all package modules; the scratch build counts 77 modules in its import closure, itself included.
- **Build.** A scratch build (`scratch_build.py`, output in [scratch.log](scratch.log)) gives **118 theorems in 144 declarations, and every axiom report is empty**: no `propext`, `Quot.sound` or `Classical.choice`. There are no warnings or errors. As the brief asked, the core checker (`check_becoming.py`) was not run, so its environment audit, controls and prelude-only compile wait for a landing.
- **Names.** No name collides with a declaration of any package module (the aggregator imports them all), and no name contains a word of exchange (the checker's `MARKET_WORDS`). The witnesses reuse UE4's namespaces (`ClosedCycle`, `OpeningChain`, `Saturated`, `OwnCondition`) and add `Ladder`, `Loosening` and `Source`. `Becoming.Lasting.Ladder` is a different, namespaced name.
- **Shared definitions.** OU3b's scratch tree reworks Admission and Flow under rule 9. It keeps the definitions this module unfolds (`Flow.Balances`, `Flow.taken`, `Flow.given`) unchanged, so a rebuild after OU3b lands is expected to pass. That rebuild has not been run.

## 2. What the Lean proves

Notation: `W : Web F C`, `L : Flow F C`, `cs : List C`.
- *Keeping widening by name on the actual levels* is `W.KeepsWidening Web.itself W.level T`.
- `req` stands for `∀ t f, T ≤ t → W.Supported t f → W.RequiresWithin cs f`. Every formation supported from `T` on requires, at every step and at one need, only members of `cs`.
- Each statement below is quoted from the module, with implicit arguments left out.

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
- `Web.exceeds_of_distinct_configs` is the pigeonhole for a list of steps. If the configurations of `cs` at the steps are pairwise distinct, and the list is longer than the number of configurations within `K`, then some listed step has stock above `K`.
- `Web.KeepsWidening.distinct_configs` gives, for every `n`, `n` steps from `T`, all at most some `S`, with pairwise distinct configurations.
- `Web.exceeds_of_firsts_of_distinct_configs` derives the landed `Web.exceeds_of_firsts`, with its statement, from the list form (rule 9).

**Constructive need.** None. No sequence is chosen. The only decisions are on the order of numbers, at finitely many listed steps (`search` with `Nat.decLe`).

**Witnesses.** `Ladder.frontier_witness` meets the premises together, under the first law and balance; its family `[0]` is open at every step. Each witness below meets every premise but one, and the conclusion fails:

| Premise dropped | Witness | What fails |
|---|---|---|
| nothing lost | `ClosedCycle.bounded_while_opening` | stock 1 throughout; never given from beyond |
| a finite family | `OpeningChain.fixed_but_unbounded` | no finite family's stock passes its length |
| fixed needs | `Loosening.bounded_while_widening` | stock 1 throughout |
| the first law | `Source.from_nothing` | a finite, balanced world keeps widening with its family closed and never given from beyond, so `whole_not_keepsWidening` fails too |

**A modelling dependence** [AI reading, argued, not proved in Lean]. `passes_every_bound` uses the fact that a finite family has finitely many configurations within a bound. That holds for natural-number amounts. With amounts in a dense order it fails: needs approaching a limit from below would support ever more formations at a bounded stock. A rise of some required condition at arbitrarily late steps does not depend on this. Neither does the family-of-one form of the second half, since every newly supported formation needs a required condition to have risen since its last unsupported step.

### 2.2 Law 2, renewers multiply

```lean
def Flow.TakesWhileSupported (L : Flow F C) (W : Web F C) (cs : List C) (T : Nat) : Prop :=
  ∀ t f, T ≤ t → W.Supported t f → f ∈ L.present t ∧ 0 < total cs (L.take t f)
theorem length_le_count {q : α → Nat} : ∀ {xs ps : List α}, Distinct xs →
    (∀ a, a ∈ xs → a ∈ ps ∧ 0 < q a) → xs.length ≤ count ps q
theorem Web.KeepsWidening.more (keeps : W.KeepsWidening itself W.level T)
    (takes : L.TakesWhileSupported W cs T) : L.More cs
theorem Web.KeepsWidening.replenishment_unbounded (keeps) (takes)
    (balances : ∀ t, T₀ ≤ t → L.BalancesOn W cs t) (R : Nat) :
    ¬ ∀ t, T₀ ≤ t → L.replenishment cs t ≤ R
theorem Web.KeepsWidening.renewers_unbounded (keeps) (takes) (balances)
    (capacity : L.Capacity cs g) (M : Nat) : ¬ ∀ t, T₀ ≤ t → L.renewers cs t ≤ M
```

**Steps.** For every `K`, `KeepsWidening.gathers` gives `K` distinct formations admitted together. Nothing lost keeps them supported, upkeep makes them takers, and `length_le_count` gives `K ≤ L.takers cs t`. That is `Flow.More cs`, and the landed `Flow.More.replenishment_unbounded_from` and `Flow.More.renewers_unbounded_from` conclude. Law 2 does not need `cs` to hold the formations' requirements: `cs` is any family they take from.

**Constructive need.** None. `length_le_count` needs neither a decision of equality nor a double negation, because the distinctness of the first list supplies the inequality `mem_remove` asks for. UE4 expected it to need one or the other.

**Witnesses.** `Ladder.upkept_witness` meets the premises together, and the first law as well. By the law itself, its renewers of `[0]` are bounded from no step on. Each witness below meets every premise but one and has at most one renewer a step:

| Premise dropped | Witness | How the premise fails |
|---|---|---|
| upkeep | `Ladder.upkeep_needed` | only the carrier takes part |
| capacity | `Ladder.capacity_needed` | the carrier gives all that is taken, and one more |
| balance | `Ladder.balance_needed` | nothing gives, so there are no renewers |
| nothing lost | `ClosedCycle.renewers_bounded_while_opening` | the cycle keeps opening, but does not keep widening |

### 2.3 Law 3, the uniform form of support passing on

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
- `Flow.gain_given_by_recent_gainer` takes the premises everywhere: `L.Balances W`, `L.Acting W`, `W.Dependent`, requirements never loosening, and brevity at every step.
- `Flow.gain_given_by_recent_gainer_decided` gives the same conclusion positively. It needs `decided : ∀ t g, Decidable (W.Supported t g)`, the gainer's requirements at the step listed in some `cs`, and those requirements decided.
- `Flow.support_passes_on_of_recent` derives the landed `Flow.support_passes_on`, with its statement, from the global form (rule 9). It needs no subtraction.

**Definition and its laws.** `Flow.OpenedByOpenedWithin L W K` has two parts: gains of support recur, and for every `S` the conclusion above holds of every gain across the step from `S + K`.
- Brief supports give it: `Flow.openedByOpenedWithin_of_brief`.
- It is monotone in the bound: `.succ`, `.add`, `.mono`.
- It gives the lagged fixed-origin form: gains from `T + K` on are given by gainers from `T` on (`.lagged`).
- The provisional `Flow.OpenedByOpened` at every origin gives it with bound one: `Flow.openedByOpenedWithin_of_opened`.

**Constructive need.** There are two double negations, each locating something:
- which required condition rose, from `GainsSupport.rises`;
- at which step of the window the giver gained support, from `comes_within_not_not`.

The decided form shows exactly what removes them. It decides support at each of the finitely many steps of the window, and decides membership of a listed family. No omniscience principle enters.

**Witnesses.**
- *Premises together:* `ClosedCycle.opened_within`, brief with `K = 1`.
- *Brevity dropped:* `OpeningChain.brevity_needed`. The single giver meets every other premise, its supports last, and it is opened by the opened within no `K`.
- *Brevity is sufficient, not necessary:* `OpeningChain.carriers_within`. The relay, whose supports last, is opened by the opened within one.
- *The fixed origin is too strict:* `OpeningChain.within_not_fixed_origin`. In the lagged relay, formation `t` gives at step `t + 1`, so every gain is given by the formation that gained support two steps before. It balances, only active formations give, and it is opened by the opened within two, but at no origin in the form of `Flow.OpenedByOpened`. The gain just after the origin is given by a formation that gained just before it.

### 2.4 Law 4, the map law

```lean
def Web.admitting (W : Web F C) (l : Nat → C → Nat) : Web F C :=
  ⟨W.level, fun t f => W.Admits (l t) t f, W.requires, W.need, W.draws⟩
theorem Web.includesAcrossFrom_iff_endless :
    W.IncludesAcrossFrom R l T ↔ ∀ S f, T ≤ S → W.Admits (l S) S f →
      «不穷» (continuationStep R) (W.admitting l).activityClass (S, f)
theorem Web.KeepsWidening.kept_by_name (keeps : W.KeepsWidening itself l T) (from_ : T ≤ S)
    (admitted : W.Admits (l S) S f) :
    «全守» (continuationStep itself) (W.admitting l).activityClass (W.admitting l).carrierClass (S, f) ∧
      ¬ «全生成» (continuationStep itself) (W.admitting l).activityClass (W.admitting l).carrierClass (S, f)
def Flow.Opens (L : Flow F C) (W : Web F C) (t : Nat) (g f : F) : Prop :=
  g ∈ L.present t ∧ W.Supported t g ∧ W.GainsSupport t f ∧
    ∃ c, W.requires t f c ∧ W.Rises t c ∧ 0 < L.give t g c
theorem Flow.opening_carries_iff (supported : W.Supported t g) :
    «传» (continuationStep (passingContinuation (L.Opens W))) (W.admitting W.level).activityClass
      (W.admitting W.level).carrierClass (t, g) (t + 1, f) ↔ L.Opens W t g f
theorem Flow.generates_of_brief (brief : ∀ t g, ¬ ∀ i, i ≤ K → W.Supported (t + i) g)
    (start : W.Supported x.1 x.2)
    (endless : «不穷» (continuationStep (passingContinuation (L.Opens W)))
      (W.admitting W.level).activityClass x) :
    «全生成» (continuationStep (passingContinuation (L.Opens W)))
      (W.admitting W.level).activityClass (W.admitting W.level).carrierClass x
```

**Further results.**
- `Web.kept_of_includes_by_name` gives the kept-by-name conclusion from nothing lost alone.
- `Flow.gain_carried` shows that every gain of support is a carrying renewal from a supported occurrence, up to double negation, under the local premises of law 3 without brevity.
- `Flow.generates_of_includes_brief` combines nothing lost along "carry on, or open" with brief supports: every occurrence supported from `T` on is then 全生成.
- The lemmas are `Web.Linked.steps_le`, `.same_of_at`, `.one_step`, `Web.linked_of_reached` and `Flow.opens_or_carried_on`. The last gives each successor with its case, carrying on or opening, and decides nothing.

**Constructive need.** None, except the double negation that `gain_carried` inherits from law 3.

**Witnesses.**
- `ClosedCycle.generation_without_widening`: the premises together. The cycle is 全生成 at every supported occurrence, while nothing is ever opened along its continuation and, by name, it keeps widening from no step.
- `Saturated.lasting_kept`: brevity dropped. Every line never ends and keeps, and none is 全生成.
- `OwnCondition.rising_kept`: a course keeping widening by name is kept.

## 3. Correspondence to the neighbours

The neighbours were checked in the [design note](DESIGN.md#6-the-neighbours-checked) by reading pages on 26 October; no file was installed. One fetch saved a PDF automatically outside the repository. It was not opened, and nothing here depends on it.

| Neighbour | Its statement | Lean counterpart | How they correspond | Grade |
|---|---|---|---|---|
| Open systems (Prigogine; Schrödinger) | sustained organization needs throughput | `from_rest_or_open`, `open_late` | conserved quantity ↔ levels of `cs` under `Gainless`; organization kept ↔ formations kept supported at fixed needs; throughput ↔ net giving by the rest, or exchange across the family's boundary | restatement |
| Finite Poincaré recurrence | a bounded closed system returns | `whole_not_keepsWidening` | finite, closed, balanced world ↔ bounded closed system; the theory's `Flow.whole_recurs_of_rest_idle` is the recurrence, and keeping widening is excluded there | restatement |
| Open-ended evolution (Bedau and others 2000; Adams and others 2017) | unbounded evolution measured against an isolated system's recurrence | `whole_not_keepsWidening` | unbounded kept widening with fixed finite requirements is impossible in a finite, balanced world under the first law | restatement |
| TAP equation (Cortês, Kauffman, Liddle and Smolin) | with `μ = 0` kept types grow combinatorially; no resource term | `passes_every_bound`, `from_rest_or_open` | type ↔ formation with fixed needs on finitely many conserved stocks; unbounded kept growth then needs the stocks to pass every bound, fed from beyond | third part carried by premises TAP lacks (conservation, thresholds), known in thermodynamics |
| Assembly theory (Sharma and others 2023) | selection measured by assembly steps and copy numbers; no balance of building blocks | as for TAP | as for TAP | as for TAP |
| Autocatalytic sets (Hordijk and Steel) | self-sustaining sets are food-generated | `from_rest_or_open` | food set ↔ what is given from beyond; the law asks it for growth, not only persistence | restatement |
| Semi-endogenous growth (Jones 1995) | sustained exponential growth of ideas needs growing researchers, given `φ < 1` | `renewers_unbounded` | ideas kept ↔ formations kept supported; researchers ↔ renewers of the shared family; productivity per researcher ↔ `Capacity cs g`; upkeep ↔ `TakesWhileSupported`. Without upkeep a constant number of researchers still gives unbounded `A`; the law forbids that only under upkeep | third part carried by a premise the model lacks; known with depreciation |
| Depreciation (Caballero and Jaffe 1993); burden of knowledge (B. F. Jones 2009); Pirt 1965; the Malthusian bound | maintaining a stock needs intake in proportion to it | `KeepsWidening.more`, `replenishment_unbounded` | maintained stock ↔ takers kept supported; intake ↔ replenishment | restatement |
| Bloom and others 2020 | research productivity falls | `renewers_unbounded` | [AI reading] upkeep of an accumulating range is one mechanism for the pattern | an alternative mechanism, not a forbidden course |
| Demography with a maximal lifespan; `Web.begins_within` | parents alive now were born within one lifespan; a lasting pattern of brief carriers has carriers that begin | `gain_given_by_recent_gainer(_at)`, `generates_of_brief` | giving ↔ parenting; gaining support ↔ birth; brevity `K` ↔ maximal lifespan | near-definitional |

## 4. Grades

1. **The gain bridge:** a restatement. It reads `Flow.newly_supported_from_rest_or_open` for a course keeping widening, with lists of steps in place of sequences of first supports.
2. **Renewers multiply:** a restatement. It reads `Flow.More.renewers_unbounded_from` for keeping widening; what is new is that a range keeping widening by name under upkeep is more without end.
3. **The uniform form:** near-definitional (`Flow.gains_from_supported` with brevity). Its value is the fixed form of *opened by the opened*.
4. **The map law:** near-definitional. It unfolds the map's definitions beside `Web.begins_within`, and answers 02's open item in the sense stated:
   - widening's first half, nothing lost, is the 不穷 that 全生成 and 全守 share;
   - by name it falls in 全守;
   - along openings with brief supports it falls in 全生成.

## 5. Is any law a result no neighbouring field states?

No, for four reasons:
- Each law follows in a few steps from a law the theory already has, joined to UE4's keeping widening or to the map. Those laws are `Flow.newly_supported_from_rest_or_open`, `Flow.More.renewers_unbounded_from`, `Flow.gains_from_supported` and `Web.begins_within`.
- Each course a law forbids is one a specialist in thermodynamics, growth theory, microbiology or demography would foresee.
- The third parts found are carried by premises the frameworks lack and are stated elsewhere. Against TAP and assembly theory the premises are conservation and thresholds; against Jones 1995 the premise is upkeep. This is the shape UE0 found for every third part.
- None of the laws compares two courses, so none reaches the second-order direction of 生生.

For UE's objective the item therefore adds joining, not reach. It also adds two fixes UE4 asked for:
- the form of *opened by the opened*, with the lagged relay showing that the provisional form is too strict;
- a count lemma that needs no decision.

And it gives a precise answer to 02's open item. A candidate would have to come from what none of these laws touches: a comparison of two courses that never reverses widening and settles the lag, or growth by kinds not given in advance.

## 6. What stays open

- **The second-order comparison.** No law compares two courses, and the lag (`LagWitness.lag`) stays unsettled.
- **Growth by kinds not given in advance; self-changing conditions.** The grammar cannot yet state these.
- **Law 1 under other premises:** requirements that tighten rather than stay fixed, amounts in a dense order (see the modelling dependence in §2.1), and keeping widening along a continuation other than names.
- **The forward law UE4 proposed:** that opened by the opened gives 生成 along some branch. It needs finitely many gainers at each step and an infinite pigeonhole (weak König's lemma) to choose the branch. It is not attempted.
- **`exceeds_of_new` from the list form.** This derivation is not done; only that of `exceeds_of_firsts` is.
- **Review and rebuild.** The kit still needs an independent review and a person's reading before any landing, and a rebuild against head after OU3b lands.

## 7. Proposals (not done)

**Rule 9 moves.** Each statement would land below the landed lemma it generalizes, with that lemma proved from it:
- `Web.exceeds_of_distinct_configs` would land in Novelty, beside `exceeds_of_new`; Population, which supplies `length_le_of_sub`, lies below Novelty. `Web.exceeds_of_firsts` (Gain) is derived from it here with its statement; `exceeds_of_new` would follow the same way.
- `Flow.gain_given_by_recent_gainer_at`, with its global and decided forms, would land in Admission, below `support_passes_on`. `support_passes_on` is derived here with its statement. Admission is among the modules OU3b's rule 9 reworks, so OU3b's owner and the integrator decide the order.
- `length_le_count` would land beside `count_le_of_sub` (Population). It uses `sign_pos`, which lies above Population (Dissipation) and would move down beside `sign` (Flow).
- `upto_length_self`, `upto_mem_lt` and `upto_distinct` restate `Undecided.upto_length`, `FinerTraces.lt_of_mem_upto` and `SituationTraces.distinct_upto`, which lie outside this module's imports. One statement of each, beside `mem_upto` in Prelude, would serve all four modules.

**Definition replacement.** `Flow.OpenedByOpenedWithin` would replace the provisional `Flow.OpenedByOpened` (EventualWideningInstances, UE4), whose docstring says its first law would fix its form. The evidence is in the Lean:
- the uniform law gives exactly the new form (`openedByOpenedWithin_of_brief`);
- the old form excludes the lagged relay (`within_not_fixed_origin`);
- the old form at every origin gives the new one (`openedByOpenedWithin_of_opened`), and the new one gives the lagged old form (`lagged`).

UE4's witnesses would then be restated for the new form: `relay_within` and `oneGiver_not_within` are proved here, and the restatement of `Saturated.reverses` is not attempted. A record's text and 07's home section would change with the definition. That is the integrator's decision.

## 8. Readings [AI reading]

- A finite family whose kept widening goes on is fed from beyond, by the rest or across its boundary: sustained widening is a throughput phenomenon, as open-systems thermodynamics says.
- Under upkeep, a range keeping widening needs ever more renewers. This is one mechanism by which research productivity could fall with ideas no harder to find; the burden-of-knowledge literature proposes a close cousin.
- Where every support is brief, every balanced flow with recurring gains is opened by the opened (`openedByOpenedWithin_of_brief`). So the property tells carriers apart only where some support lasts, as with the single giver.
- Widening's first half, nothing lost, is the 不穷 that 全生成 and 全守 share. By name it falls in 全守, and along openings with brief supports in 全生成. Generation and widening are independent both ways (the cycle; the rising course). No ranking by generation is proposed, and none is shown to reverse widening.
