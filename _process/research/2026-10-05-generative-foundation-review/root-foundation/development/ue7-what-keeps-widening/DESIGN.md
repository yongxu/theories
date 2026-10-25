# UE7: what keeps widening, and what it needs (design note)

26 October 2026, revised the same day after the [independent review](REVIEW-UE7.md). AI-authored design note for board item UE7 (item 7 of the [UE plan](../ue-unified-explanation/PLAN.md), after [UE4](../ue4-second-order/DESIGN.md)). It states five laws exactly on the package's definitions, with their premises, proof routes, constructive needs and neighbours, and grades each against the neighbours. Four were designed before the kit; the fifth, the exclusion along passing of support, came from the review. What the Lean proves is stated in [NOTE.md](NOTE.md), and the names and witnesses below are the revised kit's. This note changes no chapter, record or board row. It stays disjoint from UE6, which searches UE0's eight ranked candidates: none of those is used here.

**Verdict in one paragraph.** All five laws are stateable on existing definitions and true, and all five are restatements or near-definitional:
- (1) and (2) are the theory's own gain and renewal laws read for a course that keeps widening. In neighbouring fields they are thermodynamic openness with finite recurrence, and maintenance scaling (break-even investment, microbial maintenance, depreciating knowledge, the Malthusian bound).
- (3) is near-definitional: the bounded-lifespan fact that a parent alive now was born within one lifespan.
- (4) unfolds the map's definitions together with the pattern-passing law already in the core.
- (5) is the theory's biogenesis: under the World premises whatever is supported descends, along passing of support, from what was supported.

Where a law forbids what a framework as stated leaves open, the framework's own variants or neighbours supply the missing conservation or upkeep. This holds for the TAP equation, assembly theory, and Jones's semi-endogenous model without depreciation. These are restatements, not third parts: no premise card or Lean instance is built. **None is a result no neighbouring field states.**

What the work adds:
- the joining: one set of definitions for widening, gain, renewal, support and the map;
- two fixes UE4 asked for: the form of *opened by the opened*, which replaces UE4's as a change of class, and the count lemma, which needs no decision at all;
- the general laws, moved below the landed ones (board rule 9);
- a partial answer to 02's open item, items (a)–(d) of law 4. With law 5 it narrows the item: on each reading used, 全生成 and keeping widening cannot hold together.

None of the five compares two courses, so the second-order direction of 生生 (a range whose widening keeps widening, against one merely wider now) stays uncaptured.

| # | Law, in one line | Premises | Constructive need | Nearest neighbour | Grade |
|---|---|---|---|---|---|
| 1 | Take a course keeping widening by name on the actual levels, every admitted formation's requirements fixed within a finite family. It passes every bound on the family's stock. Under the first law the family is given from beyond (by the rest, or across its boundary) at arbitrarily late steps, and with balance as well it is not closed at arbitrarily late steps. In a finite balanced world under the first law no such course exists | keeping widening by name; requirements fixed within `cs`; for the second half, the first law and `cs` without repetition; balance for the corollaries | none: finite lists of steps, and a search over a finite list with decided order on numbers | thermodynamic openness (Prigogine); finite Poincaré recurrence; open-ended evolution relative to recurrence (Adams and others 2017) | restatement; TAP and assembly theory omit the conservation their variants supply |
| 2 | Upkeep: every formation supported from `T` on takes part and takes at least a unit a step from `cs`. Under upkeep a course keeping widening by name makes more takers without end. So, with `cs` balanced, its replenishment is bounded from no step on, and with a bounded capacity per entry, so are its renewers. Takers and renewers are entries of the present list | keeping widening by name; upkeep; balance on `cs` from a step; capacity per entry | none: the count lemma (distinct takers bound the count from below) needs neither decided equality nor double negation | break-even investment (Solow 1956); Pirt's maintenance; knowledge depreciation; the Malthusian bound | restatement; Jones 1995 as stated omits the depreciation its neighbours supply |
| 3 | Where every support lasts at most `K` steps, under the World premises, every gain of support at step `S + K` is given, on a required condition that rises, by a supported formation that itself gained support in `[S, S + K)`. This cannot be refuted, and it holds positively with support decided and the gainer's requirements listed and decided | as stated | double negation without decisions; decided support (and listed, decided requirements) for the positive form | bounded lifespans in demography; the core's pattern passing | near-definitional; fixes the form of *opened by the opened* |
| 4 | Along a continuation from `T`, nothing admitted is lost exactly where the line of the admitted pattern from every admitted occurrence never ends (不穷). By name, nothing lost gives 全守, and nothing is 全生成 by name. Along "carry on, or pass support", the carrying renewals of the supported pattern are exactly the passings of support, and every gain is one, up to double negation. Where support is brief, every supported line that never ends is 全生成, and 全生成 is 生成 | as stated | none, except the double negation of (3)'s first step for "every gain is one" | the core's `Web.begins_within` (a lasting pattern of brief carriers needs carriers that begin); demography | near-definitional; answers part of 02's open item |
| 5 | Under the World premises, whatever is supported at a step is, up to double negation, linked along "carry on, or pass support" to something supported at any earlier step. So along every continuation containing it, the levels exceed from no step to a later one, and nothing keeps opening or keeps widening | the World premises | one double negation (from (3)'s first step), with the case split on support inside it | biogenesis ("every cell from a cell"); the core's `Web.ByPassing.trace` | near-definitional |

## 0. The question in the account's terms

UE4 formalized the long run of widening and keeping widening (`Web.KeepsWidening`: from `T` on, along a continuation, nothing admitted is lost and something keeps being opened). It named the next step: a first law tying keeping widening, or what carries it, to the World's premises ([UE4 §3.1, §3.3](../ue4-second-order/DESIGN.md#31-candidate-a-the-long-run-eventual-widening-keeping-widening); [record, Next](../../../../../../theories/becoming/results/records/eventual-widening.md#next--下一步)). The UE plan asks such a law to be a result no neighbouring field states, since the [UE0 audit](../ue0-third-parts/AUDIT.md) found the theory farther than each framework alone and not farther than the sciences together. "Farther" means forbidding more.

Every law here is a property of one course or one flow and what it needs. None compares two courses, so none is the second-order comparison 07 leaves open. Each is a first law in UE4's sense: it ties keeping widening (1, 2, 5), or what carries a widening (3, 4), to balance, the first law, upkeep or brevity. No ethical predicate, ranking or axiom enters, and no law ranks keeping widening, being opened by the opened, or generation above anything.

Ranking by keeping widening, or by being opened by the opened, runs against widening wholesale (`OwnCondition.not_monotone`; `Saturated.reverses`, restated for the recency form as `Saturated.reverses_within`). On each reading used here, 全生成 and keeping widening cannot hold together. By name nothing is 全生成, and along passing of support, under the World premises, nothing keeps widening (law 5). The pairing "generation without widening, widening without generation" holds only across two readings: the closed cycle along passing of support, and the rising course by name. No ranking by generation is proposed.

## 1. What exists

- `Web.KeepsWidening W R l T`, `Web.IncludesAcrossFrom` and `Web.KeepsOpening` ([EventualWidening.lean](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/EventualWidening.lean)), with two laws:
  - `Web.KeepsWidening.gathers`: by name, for every `n`, `n` distinct formations admitted together at some step from `T`;
  - `Web.KeepsWidening.not_listed`: no such course by name over a listed type.
- `Flow.OpenedByOpened L W T`, provisional ([EventualWideningInstances.lean](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/EventualWideningInstances.lean)), with the witnesses:
  - `OpeningChain`: a relay and a single giver on one web;
  - `ClosedCycle`: a unit passed around two formations;
  - `Saturated`, `OwnCondition`, and `MergedWitness`, a merge continuation.
- Gain ([Gain.lean](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Gain.lean)):
  - `Web.RequiresWithin cs f`: what `f` requires is fixed at every step, at one need, within `cs`;
  - `Web.supported_of_config`, `Web.newAt_of_first`, `Web.exceeds_of_firsts`;
  - `Flow.rise_from_rest_or_open`: under the first law `Flow.Gainless`, a family without repetition that rises is given net by the rest, `(L.withImbalance W).NetGiver cs t none`, or is open, `¬ L.ClosedAt cs t`;
  - `Flow.newly_supported_from_rest_or_open`, `Flow.whole_rise_from_rest`.
- Novelty: `Web.exceeds_of_new`, `Web.unbounded_of_new`, `upto_or_fails`.
- Flow ([Flow.lean](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Flow.lean)):
  - `Flow.More cs`, `Flow.takers`, `Flow.renewers`, `Flow.Capacity`;
  - `Flow.More.replenishment_unbounded_from`, `Flow.More.renewers_unbounded_from`;
  - from Population, `count`, `count_le_of_sub` (an upper bound only) and `length_le_of_sub`.
- Admission ([Admission.lean](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Admission.lean), as OU3b left it):
  - `Web.GainsSupport`, `Web.Unloosened`;
  - `Flow.gains_from_supported(_at)`, `Flow.rise_given_by_supported_at`, `Flow.comes_within_not_not`;
  - `Flow.support_passes_on`: at arbitrarily late steps, up to double negation, some gain is given by a formation that gained support after any given step.
- The map ([GrammarMap.lean](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarMap.lean), [MapInstances.lean](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/MapInstances.lean)):
  - on the grammar, `«传»`, `«不穷»`, `«全生成»`, `«全守»`, `«生成»`;
  - on the World, with occurrences `(t, f)` as carrier: `Web.continuationStep R`, `Web.activityClass`, `Web.carrierClass`, `Web.carries_iff`, `Web.itself_keeps`, `Web.itself_not_generation` and `Web.passingContinuation`.
- Pattern passing ([PatternPassing.lean](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/PatternPassing.lean)):
  - `Web.begins_within`: a lasting pattern of brief carriers has a carrier beginning within every `d` steps;
  - `Web.ByPassing.trace`: under the passing premise, a carrier is traced back through passings.
- `Thresholds.le_of_not_not`: an order of numbers not refuted holds.

## 2. Law 1: the gain bridge

**Statement** (World; `W : Web F C`, `L : Flow F C`, `cs : List C`).
- *Keeping widening by name on the actual levels*: `W.KeepsWidening Web.itself W.level T`. On the actual levels admission is support (`Web.supported_iff_admits`, `Iff.rfl`).
- *Requirements fixed within a finite family*: `req : ∀ t f, T ≤ t → W.Supported t f → W.RequiresWithin cs f`. Only formations admitted from `T` on are constrained.
- *Passes every bound*: `∀ K M, ∃ t, M ≤ t ∧ K < W.stock cs t` (`Web.KeepsWidening.passes_every_bound`). So the stock rises at arbitrarily late steps (`Web.KeepsWidening.rises_late`).
- *Given from beyond*: with `gainless : L.Gainless` and `Distinct cs`, `∀ M, ∃ t, M ≤ t ∧ ((L.withImbalance W).NetGiver cs t none ∨ ¬ L.ClosedAt cs t)` (`Web.KeepsWidening.from_rest_or_open`). The flow need not balance: the rest is counted.
- *Corollaries.*
  - With balance on the family from a step as well, the rest gives nothing net, so the family is not closed at arbitrarily late steps (`Web.KeepsWidening.open_late`).
  - In a finite world (a list without repetition holding every condition), under balance and the first law, no course keeps widening by name with requirements fixed (`Flow.whole_not_keepsWidening`). The whole's stock never rises (`Flow.whole_rise_from_rest`), and the bridge says it must pass every bound.

**Route.** Through finite lists of steps, with no sequence chosen:
1. *Below, in Novelty.* A list of steps whose configurations of `cs` are pairwise distinct, longer than the number of configurations of `cs` totalling at most `K`, holds a step at which the stock exceeds `K` (`Web.exceeds_of_distinct_configs`, from `search` over the list, `config_within` and `length_le_of_sub`). It is the pigeonhole inside `Web.exceeds_of_firsts` and `Web.exceeds_of_new`, stated for a list of steps; both are re-proved from it in place. Beside it, such lists of every length from every step on give a stock exceeding every bound at arbitrarily late steps (`Web.unbounded_of_distinct_configs`). `Web.unbounded_of_new` and `Web.rises_late_of_firsts` are re-proved from it, and the bridge uses it too.
2. *The list.* For every `n`, keeping widening gives `n` steps from `T`, all at most some `S`, with pairwise distinct configurations (`Web.KeepsWidening.distinct_configs`, by induction on `n`). At the step:
   - keeping opening at `S` gives `U ≥ S` and `g` supported at `U`, not at `S`;
   - nothing lost makes `g` unsupported at every earlier listed step `s`, or it would be supported at `S`;
   - `Web.supported_of_config` with `req` then makes the configuration at `U` differ from each listed one.
3. *The conclusions.* Apply 1 to lists from `T + M` (`KeepsWidening.later`); `rises_between` gives the late rise; `Flow.rise_from_rest_or_open` gives the first law's half.

**Constructive need.** None. Keeping opening supplies each new step and formation positively; the only decision is the order of numbers on finitely many listed steps. UE4 expected this ("a proof through finite lists of formations would need neither a choice of witnesses nor decided support").

**What each premise does** (each witness meets the other premises and fails the conclusion):
- *Nothing lost.* The cycle keeps opening by name with requirements fixed within `[false, true]`, a list without repetition, under the first law and balance, while the family is closed and its stock is 1 at every step (`ClosedCycle.bounded_while_opening`).
- *A finite family.* The rising web, each formation `n` requiring its own condition `n`, keeps widening by name with fixed requirements, and no finite family's stock passes its length (`OpeningChain.fixed_but_unbounded`).
- *Fixed needs.* Needs that loosen (formation `n` needs two before step `n`, one from it on) admit ever more formations at a stock of one (`Loosening.bounded_while_widening`).
- *The first law.* A balanced one-condition world fed from nothing keeps widening by name with fixed requirements while its family is closed and never given from beyond (`Source.from_nothing`).

The witness of the premises together is `Ladder` (`Ladder.frontier_witness`):
- condition `0` stands at `t + 1` at step `t`;
- formation `some n` requires `n + 1` of it and is supported from step `n` on;
- a carrier `none`, requiring nothing, is active throughout;
- each condition `c + 1` holds one unit up to step `c`.

Under the frontier flow the carrier alone takes part: it takes the unit standing at condition `t + 1` and gives it to condition `0`. The flow balances and meets the first law, the course keeps widening by name with requirements fixed within `[0]`, and `[0]` is open at every step. The frontier of fresh conditions is what the bridge says must exist.

**Neighbours and grade.**
- *The theory's own laws.* The bridge is `Flow.newly_supported_from_rest_or_open` read for a course keeping widening, with sequences of first supports replaced by lists. A joining lemma.
- *Thermodynamics and dynamical systems.* That a bounded closed system recurs (finite Poincaré recurrence), and that sustained organization needs throughput (Schrödinger; Prigogine's dissipative structures), are the bridge's content. UE0 row 11 grades the theory's "fed from beyond" a restatement of these.
- *Open-ended evolution.* Adams, Zenil, Davies and Walker (2017) define unbounded evolution against the Poincaré recurrence time of an isolated system. Bedau and others (2000) list "determine what is inevitable in the open-ended evolution of life" as open problem 6. The finite-world corollary says one such thing in the theory's terms: no unbounded kept widening, under fixed finite requirements, in a finite balanced world under the first law. Known.
- *The adjacent possible.* The TAP equation, `M_{t+1} = M_t (1 − μ) + Σ_{i ≥ 2} α_i C(M_t, i)` (Cortês, Kauffman, Liddle and Smolin, arXiv 2204.14115, checked), has no resource, maintenance or conservation term in its Eq. 1. With `μ = 0` (nothing lost) it lets kept types grow without bound in any world. Where each type is a formation with fixed thresholds on finitely many conserved stocks, the bridge forbids that growth unless the stocks are fed from beyond. The paper itself discusses a logistic variant that limits innovation (its §5.3), so the framework's own family supplies the limit: a restatement.
- *Assembly theory* (Sharma and others, *Nature* 2023). No balance of building blocks is stated, but the paper notes mass constraints on what is produced, qualitatively. A restatement.
- *Autocatalytic sets.* A RAF set (Hordijk and Steel) is food-generated by definition: every reactant is produced from a food set supplied from outside. The dynamics of RAF sets and of autocatalytic cores, including their growth and division in compartments, are studied (W. Hordijk and M. Steel 2012; V. Vasas and others 2012). The bridge's "fed from beyond" is their food requirement read for a course keeping widening. A restatement, more firmly.

**Grade: restatement.** It forbids nothing a physicist or an open-endedness theorist would not foresee.

## 3. Law 2: renewers multiply

**Statement.**
- *Upkeep*: `L.TakesWhileSupported W cs T := ∀ t f, T ≤ t → W.Supported t f → f ∈ L.present t ∧ 0 < total cs (L.take t f)`. Every formation supported from `T` on takes part and takes at least a unit a step from `cs`.
- *Law*: `W.KeepsWidening Web.itself W.level T → L.TakesWhileSupported W cs T → L.More cs` (`Web.KeepsWidening.more`).
  - With `∀ t, T₀ ≤ t → L.BalancesOn W cs t`, the replenishment of `cs` is bounded from no step on (`Web.KeepsWidening.replenishment_unbounded`).
  - With `L.Capacity cs g` as well, so are its renewers: `∀ M, ¬ ∀ t, T₀ ≤ t → L.renewers cs t ≤ M` (`Web.KeepsWidening.renewers_unbounded`).
- *Entries.* Takers and renewers count entries of the present list (`Flow.count` totals `sign` over `present t`), so a formation listed `m` times counts `m` times, and `Capacity` bounds each entry. The law speaks of formations where the present list has no repetition.

**Route.**
1. `KeepsWidening.gathers` gives, for every `K`, `K` distinct formations admitted together at some `S ≥ T`.
2. Nothing lost keeps them supported at every `t ≥ S`, and upkeep makes them takers at `t`.
3. The count lemma gives `K ≤ L.takers cs t`. That is `Flow.More cs`.
4. `Flow.More.replenishment_unbounded_from` and `Flow.More.renewers_unbounded_from` conclude.

**The count lemma.** `length_le_count : Distinct xs → (∀ a, a ∈ xs → a ∈ ps ∧ 0 < q a) → xs.length ≤ count ps q`, now in Population, the lower bound beside `count_le_of_sub`. UE4 expected it to need decided equality of formations or a double negation. It needs neither. By induction on `xs`, split `ps` at the head of `xs` (`List.append_of_mem`). The rest of `xs` lies in the two pieces because its members differ from the head (`mem_remove`, whose premise `¬ b = a` the distinctness of `xs` supplies positively). A case split on the quantity takes the place of `sign_pos`, which lies above Population. The landed `length_le_of_sub` is its case `q := fun _ => 1`.

**Constructive need.** None.

**What each premise does** (each witness meets the other premises and has at most one renewer a step):
- *Upkeep.* Under the frontier flow only the carrier takes part (`Ladder.upkeep_needed`).
- *Capacity.* The carrier gives all that is taken from condition `0`, and one more (`Ladder.capacity_needed`).
- *Balance.* Nothing gives, so nothing renews (`Ladder.balance_needed`).
- *Nothing lost.* The cycle keeps opening by name under upkeep with capacity one (`ClosedCycle.renewers_bounded_while_opening`).

The witness of the premises together meets the first law as well (`Ladder.upkept_witness`). Under upkeep every supported formation takes part, takes a unit from condition `0` and gives it back, and the carrier also brings the unit standing at condition `t + 1`. Each entry gives at most two, no formation is listed twice, and the renewers of `[0]` are bounded from no step on. The first plan, a source formation giving from nothing, broke the first law. Law 1 says a witness meeting it must feed the family from beyond, as the ladder's frontier does.

**Neighbours and grade.**
- *The theory's own law.* `Flow.More.renewers_unbounded` (more takers without end needs renewers without bound) read for keeping widening. The new step is that a range keeping widening by name under upkeep *is* more without end.
- *Maintenance and depreciation.* Law 2's renewers give what kept formations take. They are the counterpart of the input that offsets depreciation, not of research producing ideas: upkeep ↔ depreciation or maintenance, renewers ↔ the input that offsets it.
  - In economics the closest neighbour is break-even investment (Solow 1956): keeping capital per worker takes investment in proportion to it.
  - In microbiology it is Pirt's maintenance coefficient (1965), which makes the substrate needed scale with the biomass maintained.
  - In population ecology it is the Malthusian bound UE0 names.
  - Knowledge obsolescence is measured by Caballero and Jaffe (1993). The burden of knowledge (B. F. Jones 2009, *Review of Economic Studies* 76) is an upkeep-like mechanism: accumulated knowledge raises what each new innovator must carry.
- *Semi-endogenous growth.* Jones (1995, *JPE*, "R&D-based models of economic growth") replaces Romer's scale effects with an idea production function `Ȧ = δ L_A^λ A^φ`, `φ < 1`: sustained exponential growth needs a growing number of researchers. Bloom, Jones, Van Reenen and Webb (2020, *AER*) find research productivity falling wherever they look; the researchers needed for Moore's law are more than 18 times those of the early 1970s.
  - Law 2 is not Jones's result. In Jones's model with a constant number of researchers, `A` still grows without bound (`A^{1−φ}` grows linearly), more and more slowly: ideas, once found, are kept for free. Jones 1995 is the model that leaves the course open without depreciation.
  - With knowledge depreciating at rate `d`, `Ȧ = δ L_A^λ A^φ − d A`, and a constant `L_A` gives a finite steady state `A* = (δ L_A^λ / d)^{1/(1−φ)}`. So unbounded `A` needs unbounded `L_A`, as break-even investment says (an argument from the model).
  - The model's neighbours supply the upkeep it omits.
- *The adjacent possible, TAP and assembly theory* speak of types or objects, not of renewers, so law 2's forbidden statement is not on their topic (UE0's first test).

**Grade: restatement.** [AI reading] Law 2 offers one mechanism, upkeep of an accumulating range, by which Bloom and others' falling research productivity could arise with ideas no harder to find. The burden-of-knowledge literature already proposes a close cousin.

## 4. Law 3: the uniform form of support passing on

**Statement** (local form, every hypothesis at one step), in Admission:

```lean
theorem Flow.gain_given_by_recent_gainer_at {S K : Nat} {f : F}
    (balances : ∀ c, W.requires (S + K) f c → L.BalancesOn W [c] (S + K))
    (givers : ∀ c, W.requires (S + K) f c → L.GiversSupported W (S + K) c)
    (unloosened : W.Unloosened (S + K) f)
    (brief : ∀ g, ¬ ∀ i, i ≤ K → W.Supported (S + i) g)
    (gains : W.GainsSupport (S + K) f) :
    ¬ ¬ ∃ c g u, W.requires (S + K) f c ∧ W.Rises (S + K) c ∧ g ∈ L.present (S + K) ∧
      0 < L.give (S + K) g c ∧ W.Supported (S + K) g ∧ S ≤ u ∧ u < S + K ∧ W.GainsSupport u g
```

The global form takes the World premises and brevity everywhere (`Flow.gain_given_by_recent_gainer`). Subtraction never appears: the gain is at `S + K` and the window is `[S, S + K)`.

**Route.**
1. *The first step, below.* `Flow.gain_given_by_supported_at`: a gain of support is, up to double negation, given on a rising required condition by a supported formation taking part. It comes from `GainsSupport.rises` and `rise_given_by_supported_at`. The landed `Flow.gains_from_supported_at` is re-proved from it.
2. *The window.* Brevity at `S` with `comes_within_not_not` gives, up to double negation, the step in the window at which the giver gained support.
3. *The landed corollary.* `Flow.support_passes_on` is re-proved from the global form in place (rule 9). Take a gain at `t ≥ N + (T + 1) + K`, write `t = (N + (T + 1) + m) + K`, and use the window ending at `t`, with no subtraction.

**Constructive need.** There are two double negations, each locating something:
- the required condition that rose (a search over every condition);
- the step at which the giver gained support (deciding support at each step of the window).

With support decided and the gainer's requirements at the step listed and decided, the law is positive (`Flow.gain_given_by_recent_gainer_decided`, by `decideSome`, `upto_or_fails` and `came_between`). That form uses `upto_or_fails` of Novelty, which Admission does not import, so it stays in the leaf, above Novelty.

**What it fixes.** UE4's `Flow.OpenedByOpened L W T` asks every gain after `T` to be given by a formation that gained support after `T`. The uniform law gives something else:
- *A recency bound, not a fixed origin.* A gain right after `T` may be given by a formation that gained support before `T` and is still supported. What brevity forces is that a gain at `S + K` is given by one that gained in `[S, S + K)`.
  - Definition: `Flow.OpenedByOpenedWithin L W K`. Gains recur, and for every `S`, every gain at `S + K` is, up to double negation, given on a required rising condition by a supported formation that gained support in `[S, S + K)`.
  - *Its exemption:* gains before step `K` are not constrained, which exempts the founders. Formation 0 of the relay and of the lagged relay never gained support, so every form must exempt something. UE4's exempts gains up to its origin, and this one exempts gains before step `K`.
  - *Its empty case:* within 0 holds of no flow (`Flow.not_within_zero`).
- *The double negation inside*, or support decided.

**Relations proved.**
- Brevity with the World premises and recurring gains gives `OpenedByOpenedWithin K` (`Flow.openedByOpenedWithin_of_brief`).
- It is monotone in `K` (`Flow.OpenedByOpenedWithin.mono`).
- It gives the lagged form of the old definition: gains from `T + K` on are given by gainers from `T` on (`Flow.OpenedByOpenedWithin.lagged`).
- The old definition at every `T` gives it with `K = 1` (`Flow.openedByOpenedWithin_of_opened`).

**Witnesses.**
- The closed cycle meets brevity with `K = 1` (`ClosedCycle.opened_within`).
- The relay meets `OpenedByOpenedWithin 1` without brevity, so brevity is sufficient, not necessary (`OpeningChain.carriers_within`).
- The single giver meets every other premise and is opened by the opened within no `K`; the premise dropped is brevity (`OpeningChain.brevity_needed`).

**A change of class.** The landed uses read the old definition at one origin: the relay, the cycle and `Saturated.reverses`, at origin 0. At a single origin neither form gives the other (`OpeningChain.forms_independent`):
- *The late single giver.* Formation 0 takes part at step 0 and formation 1 at every later step, each giving the unit that steps the rising course. It is opened by the opened in the old form at origin 0, since formation 1 gained support across the step from 0. In the new form it is opened by the opened within no bound.
- *The lagged relay.* Formation `t` gives at step `t + 1`; for `t ≥ 1`, that is two steps after it gained support. From step 2 on, each gain is given by the formation that gained support two steps before. The gains at steps 0 and 1 are given by formation 0, which never gained support, and within two leaves gains before step 2 unconstrained. It is opened by the opened within two, and at no origin in the old form (`OpeningChain.within_not_fixed_origin`).

The new form drops a giver that gained support once after the origin and carries every later gain. It admits givers that gained support within `K` steps, whatever the origin. [AI reading] The late giver is the stronger reason: the old form would count one lasting carrier as opened by the opened, against the purpose 07 §2 gives the property.

UE4's witnesses are restated for the new form: `OwnCondition.not_within`, `OpeningChain.relay_within`, `oneGiver_not_within`, `carriers_within`, `Saturated.still_not_within`, `Saturated.reverses_within`, `ClosedCycle.opened_within` and `cycle_within`. A two-parameter form, with a start `T` beside the bound `K`, is not adopted, since every use reads it at `T = 0` (NOTE §2.3).

**A consequence for UE4's candidate C** [AI reading]. Where every support is brief, every balanced flow with recurring gains is opened by the opened. So the property distinguishes carriers only where some support lasts, as the single giver's does: what UE4's `OpeningChain.carried` separates is a lasting carrier from brief ones.

**Neighbours and grade.** In a population with a maximal lifespan `ω`, every parent alive at `t` was born after `t − ω`. That is the law with "giving" for "parenting", plus the theory's own law that support comes from the supported. The core's `Web.begins_within` is the same fact for patterns. **Grade: near-definitional.** Its value is the fixed form.

## 5. Law 4: the map law, and law 5: the exclusion along passing of support

02's open item asks "whether a capture loop (§9) is 生成 at some pair of classes, and a law relating the map's 生成 to widening what can form" ([02 Open](../../../../../../theories/becoming/chapters/02-MAP.md#open)). 生成 is the some-branch region, which 02 §1 does not read on the World, and "widening what can form" is 07 §2's comparison of two level paths. UE4 proposed reaching the item through gains of support ([UE4 §3.3](../ue4-second-order/DESIGN.md#33-candidate-c-what-carries-a-widening-openings-that-were-opened)).

The proposal there took the passing relation alone as 缘. That makes every step a carrying renewal by construction, since no formation passes support to itself, so its 全生成 is "a passing tree that never ends": a definition rather than a law. The version below keeps "carrying on" as a step of the continuation, so that renewal and keeping can differ. What it reaches is narrower than the item: the strong forms, and the nothing-lost half of keeping widening, a property of one course.

**The reading.** Carrier: occurrences `(t, f)`. For levels `l`, the web read through what `l` admits (`Web.admitting W l`: active where admitted) gives two classes:
- the coarse class "admitted or not" (`(W.admitting l).activityClass`);
- the fine class "admitted alike and the same formation" (`(W.admitting l).carrierClass`).

缘 is one step of a continuation `R` (`Web.continuationStep R`). On the actual levels activity is support, so the generation read is that of the admitted, or supported, pattern. The World theorems of 02 §1 read the web's own activity, which under `Dependent` implies support, not the converse.

**Statements of law 4.**
1. *Nothing lost is the admitted pattern never ending*: `W.IncludesAcrossFrom R l T ↔ ∀ S f, T ≤ S → W.Admits (l S) S f → «不穷» (continuationStep R) (W.admitting l).activityClass (S, f)` (`Web.includesAcrossFrom_iff_endless`).
   - Forward: an admitted occurrence reached is admitted and late, and inclusion across one step gives it an admitted successor.
   - Back: a line that never ends reaches an admitted occurrence at every later step (`reaches_onward`), and a line is a link chain.
2. *By name*: nothing lost gives 全守 at every admitted occurrence from `T`, and nothing is 全生成 by name (`Web.kept_of_includes_by_name`, from 1, `Web.itself_keeps` and `Web.itself_not_generation`). A course keeping widening by name is a case, through its first half.
3. *Passings of support as carrying renewals*: `L.PassesSupport W t g f` holds when `g` takes part and is supported, gives on a condition `f` requires that rises, and `f` gains support across the step. Along "carry on, or pass support" (`Web.passingContinuation (L.PassesSupport W)`) on the actual levels, from a supported occurrence, a carrying renewal into `(t + 1, f)` is exactly `L.PassesSupport W t g f` (`Flow.passesSupport_carries_iff`, from `Web.carries_iff`).
4. *Every gain is one*: under balance and active giving at the step, activity needing support and unloosened requirements, every gain of support is, up to double negation, the end of a carrying renewal from a supported occurrence (`Flow.gain_carried`, from law 3's first step).
5. *Brief supports make lasting lines 全生成*: where no formation is supported at `K + 1` consecutive steps, every supported occurrence whose line along "carry on, or pass support" never ends is 全生成 (`Flow.generation_of_brief`). With 1: a range losing nothing along "carry on, or pass support" from `T`, its supports brief, is 全生成 at every supported occurrence from `T` (`Flow.generation_of_includes_brief`).
6. *全生成 is 生成*, on the grammar (`«全生成则生成»`): the points the line reaches form a branch. Wherever the map reads 全生成 on the World it reads 生成. Reading 生成 where 全生成 fails is untouched.

**Route.**
- Statement 1 unfolds link chains as lines (`Web.linked_iff_line` and its proof's pattern).
- Statement 3 is `carries_iff` with the fine class.
- Statement 5 follows successors, each existing by 不穷, for at most `K` steps. Each step carries the formation on or passes support to another, and `K` carrying-on steps would keep one formation supported at `K + 1` consecutive steps.

**Law 5, the exclusion.** Under the World premises, whatever is supported at `S + k` is, up to double negation, linked along "carry on, or pass support" to something supported at `S` (`Flow.descends_along_passings`).
- *Route.* By induction on `k`, with the case split on support at the previous step taken inside the double negation. A formation still supported is carried on. One that gained support had support passed to it by a supported formation, by statement 4. The chain extends by `Web.Linked.snoc`.
- *Consequences.* Along every continuation containing "carry on, or pass support", the levels exceed from no step to a later one (`Flow.not_exceedsAcross_along_passings`). Nothing keeps opening (`Flow.not_keepsOpening_along_passings`) or keeps widening (`Flow.not_keepsWidening_along_passings`) there.
- *What it says for 02's item.* On each reading used, 全生成 and keeping widening cannot hold together. By name nothing is 全生成, and along passing of support, under the World premises, nothing keeps widening.
- *The reading it leaves.* A reading on which the two hold together would have to leave out some step of "carry on, or pass support", as `MergedWitness`'s merge continuation leaves out carrying on as itself. None is constructed.

**Constructive need.** None for statements 1, 2, 3, 5 and 6. Statement 4 and law 5 inherit the double negation of law 3's first step.

**Witnesses.**
- *The closed cycle.* Its supports are brief and nothing is lost along "carry on, or pass support", so it is 全生成, and so 生成, at every supported occurrence. Along that continuation its levels exceed from no step to a later one, the instance of law 5, and by name it keeps widening at no step: generation without widening (`ClosedCycle.generation_without_widening`, `ClosedCycle.generates`, `ClosedCycle.not_opening_along`).
- *`Saturated`.* Nothing is lost, every support lasts, and nothing gains support: 全守 everywhere and 全生成 nowhere, so brevity cannot be dropped from statement 5 (`Saturated.lasting_kept`).
- *`OwnCondition.rising`.* It keeps widening by name, so it is kept and not 全生成 (`OwnCondition.rising_kept`).

**Neighbours and grade.**
- Statement 5 is `Web.begins_within` read at the map's grain, with gains of support as the carriers that begin: a lasting pattern of brief carriers needs carriers that begin. In demography, a population of mortal members persists only through births (UE0 §2.1).
- Statements 1, 2 and 6 are unfoldings.
- Law 5 is the theory's biogenesis, close to `Web.ByPassing.trace`, with the World premises supplying each passing.

**Grade: near-definitional, both.** Law 4 answers part of 02's open item:
- (a) nothing lost is the 不穷 of the admitted pattern;
- (b) by name it gives 全守;
- (c) along passing of support, carrying renewals are passings and every gain is one;
- (d) brief supports make every supported endless line 全生成.

With law 5 the item narrows to a law relating 生成 (some branch, read on the World) to widening what can form. On the two readings so far, 全生成 and keeping widening cannot hold together. Neither law forbids anything observable beyond what `Web.begins_within` and the descent of support forbid.

## 6. The neighbours checked

Web searches on 26 October (pages read, nothing downloaded or installed) checked:
- Jones 1995, Bloom and others 2020 and B. F. Jones 2009;
- the TAP equation's form and its lack of any resource term;
- Adams and others 2017, Bedau and others 2000 (problem 6), and Taylor and others 2016;
- Hordijk and Steel's RAF definition, and Pirt 1965.

The independent review checked further pages, including the TAP paper's logistic variant (its §5.3), assembly theory's remarks on mass, Pirt's bibliographic record and work on RAF dynamics. This revision takes its corrections without fetching anything. The rest is from prior knowledge and the UE4 and UE0 notes.

| Neighbour | What it states | Law it bears on | What the law adds or forbids | Grade there |
|---|---|---|---|---|
| Break-even investment (Solow 1956); Pirt 1965; knowledge depreciation; the burden of knowledge (B. F. Jones 2009); the Malthusian bound | maintaining a stock needs input in proportion to it | 2 | the same, in the theory's terms: upkeep ↔ depreciation or maintenance, renewers ↔ the input that offsets it | restatement |
| Semi-endogenous growth (Jones 1995) | sustained exponential growth of ideas needs growing researchers, given `φ < 1` | 2 | unbounded kept growth at any rate needs unbounded renewers, given upkeep | restatement: the model as stated omits depreciation, which its neighbours supply |
| Bloom and others 2020 | research productivity falls; researchers rise | 2 | an upkeep mechanism for the same pattern [AI reading] | none: an alternative mechanism, not a forbidden course |
| Open-ended evolution (Bedau and others 2000; Taylor and others 2016; Adams and others 2017) | open-endedness is varied (York); unbounded evolution is measured against an isolated system's recurrence | 1 | no unbounded kept widening under fixed finite requirements in a finite balanced world under the first law | restatement |
| Autocatalytic sets (Hordijk and Steel; Hordijk and Steel 2012; Vasas and others 2012) | self-sustaining sets are food-generated; their dynamics, growth and division are studied | 1 | feeding from beyond, read for a course keeping widening | restatement, more firmly |
| The adjacent possible; TAP (Cortês and others) | the possible grows combinatorially; Eq. 1 has no resource term | 1 | kept types with fixed thresholds on finitely many conserved stocks cannot grow without bound unless fed from beyond | restatement: the paper's logistic variant limits innovation (§5.3) |
| Assembly theory (Sharma and others 2023) | selection measured by assembly steps and copy numbers | 1 | as for TAP | restatement: mass constraints are noted, qualitatively |
| Finite Poincaré recurrence | a bounded closed system recurs | 1 | the finite-world corollary | restatement |
| Prigogine; Schrödinger | organization needs throughput | 1 | fed from beyond | restatement |
| Demography; pattern passing (`Web.begins_within`) | parents are recent births; a lasting pattern of brief carriers renews | 3, 4 | the uniform law; brief supports make lasting lines 全生成 | near-definitional |
| Biogenesis; `Web.ByPassing.trace` | the living descends from the living | 5 | under the World premises, nothing keeps opening along passing of support | near-definitional |

## 7. Is any law a result no neighbouring field states?

No. Each law follows in a few steps from a law the theory already has, joined to UE4's keeping widening or to the map: `Flow.newly_supported_from_rest_or_open`, `Flow.More.renewers_unbounded`, `Flow.gains_from_supported` with brevity, `Web.begins_within`, and the descent of support through `gain_carried`. Each forbidden course is one a specialist in thermodynamics, growth theory, microbiology, demography or biology would foresee.

Where a law forbids what a framework as stated leaves open (TAP's equation, assembly theory, Jones 1995 without depreciation), the framework's own variants or neighbours supply the missing conservation or upkeep. UE0 graded "the sources' own exclusion, under a stronger premise" as no third part (its row 11), and these are the same. A third part in the UE plan's sense would need the framework's premises on the premise card and a Lean instance, and neither is built.

For UE's objective this item therefore adds joining, not reach: the second-order direction's first laws are restatements, as UE0's other rows were. A result no neighbouring field states would have to come from what none of these laws touches:
- a comparison of two courses that never reverses widening and decides the lag;
- growth by kinds not given in advance, which the grammar cannot yet state.

## 8. The kit

One new leaf module of the pure core, `Becoming.KeepingWidening` (renamed from `Becoming.SustainedWidening`: "keeping widening" is the property's word). It imports `Becoming.EventualWideningInstances`, `Becoming.Gain`, `Becoming.MapInstances` and `Becoming.Thresholds`. It holds every law not moved below, the witnesses of the premises together and the premise-dropped witnesses listed above: 126 theorems in 154 declarations, every axiom report empty. The exact statements are in the NOTE.

**Names.** The names take the core's vocabulary: renewers, takers, gains of support, and passing of support (`Flow.PassesSupport`, "carry on, or pass support"). "Opening" keeps the core's sense (`KeepsOpening`, `ExceedsAcross`). "Upkeep" names the premise in prose only.

**Rule 9, done in modified copies of landed modules.** The copies sit in the kit's tree, with one patch each in `patches/`. Statements are unchanged: all 281 declarations of the four modules print identically.
- *Population*: `length_le_count`, from which `length_le_of_sub` is re-proved.
- *Novelty*:
  - `Web.exceeds_of_distinct_configs` and `Web.unbounded_of_distinct_configs`, with the helper `Web.distinct_configs_of_apart`;
  - re-proved from them: `exceeds_of_new` and `unbounded_of_new` in Novelty, and `exceeds_of_firsts` and `rises_late_of_firsts` in Gain.
- *Admission*:
  - `Flow.gain_given_by_supported_at`, from which `gains_from_supported_at` is re-proved;
  - `Flow.gain_given_by_recent_gainer_at` and its global form, from which `support_passes_on` is re-proved.
- *The kit's restatements are gone.* `Thresholds.le_of_not_not` is imported, and the list laws use `steps` instead of `Undecided.upto`.

**Why a leaf.** It joins EventualWidening with Gain, Flow and MapInstances, which no landed module joins. `Flow.OpenedByOpenedWithin` is proposed to replace the provisional `Flow.OpenedByOpened`, whose docstring says its first law would fix its form; the landed definition is not edited.

## 9. What stays open

- The second-order comparison itself: none of the laws compares two courses, and the lag (`LagWitness.lag`) stays undecided.
- 02's open item, narrowed as in §5, with:
  - 生成 on the World where 全生成 fails;
  - any law on the opening half of keeping widening or on the widening order, beyond the exclusion;
  - the capture loop.
- Growth by kinds not given in advance; self-changing conditions.
- Law 1 with requirements that tighten rather than stay fixed.
- The forward law UE4 proposed, that opened by the opened gives 生成 along some branch. It needs finitely many gainers at each step and a classical infinite pigeonhole (or weak König's lemma) to choose the branch.
- A person's reading before any landing, and the landing decisions listed in NOTE §7.3.

## Literature

Checked on the web on 26 October, pages read:
- C. I. Jones, "R&D-based models of economic growth", *Journal of Political Economy* 103 (1995), 759–784.
- N. Bloom, C. I. Jones, J. Van Reenen and M. Webb, "Are ideas getting harder to find?", *American Economic Review* 110(4) (2020), 1104–1144.
- B. F. Jones, "The burden of knowledge and the 'death of the Renaissance man': is innovation getting harder?", *Review of Economic Studies* 76(1) (2009), 283–317.
- M. Cortês, S. A. Kauffman, A. R. Liddle and L. Smolin, "The TAP equation: evaluating combinatorial innovation in biocosmology", arXiv 2204.14115 (v4, 2025).
- B. Adams, H. Zenil, P. C. W. Davies and S. I. Walker, "Formal definitions of unbounded evolution and innovation reveal universal mechanisms for open-ended evolution in dynamical systems", *Scientific Reports* 7 (2017), 997.
- M. A. Bedau and others, "Open problems in artificial life", *Artificial Life* 6(4) (2000), 363–376.
- T. Taylor and others, "Open-ended evolution: perspectives from the OEE workshop in York", *Artificial Life* 22(3) (2016), 408–423.
- W. Hordijk and M. Steel, RAF sets (reflexively autocatalytic and food-generated), *Journal of Theoretical Biology* 227 (2004) and after.
- S. J. Pirt, "The maintenance energy of bacteria in growing cultures", *Proceedings of the Royal Society of London B* 163 (991) (1965), 224–231.

Cited from the independent review (its checked sources include work on RAF dynamics); not re-read here:
- W. Hordijk and M. Steel, "Autocatalytic sets extended: dynamics, inhibition, and a generalization", *Journal of Systems Chemistry* 3 (2012), 5.
- V. Vasas and others, "Evolution before genes", *Biology Direct* 7 (2012), 1.
- R. M. Solow, "A contribution to the theory of economic growth", *Quarterly Journal of Economics* 70 (1956).

From prior knowledge, not re-read here:
- Kauffman, *Investigations* (2000);
- Sharma, Czégel, Lachmann, Kempes, Walker and Cronin, "Assembly theory explains and quantifies selection and evolution", *Nature* 622 (2023);
- Prigogine and Nicolis, *Self-Organization in Nonequilibrium Systems* (1977);
- Schrödinger, *What Is Life?* (1944);
- Caballero and Jaffe, "How high are the giants' shoulders", *NBER Macroeconomics Annual* (1993).
