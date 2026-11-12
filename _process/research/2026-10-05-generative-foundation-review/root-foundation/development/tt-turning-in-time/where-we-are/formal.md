AI-written, 12 November 2026

# The formal structure: the root, the parts, and whether the loop is one theorem

*Read from the Lean package: definitions, statements and module headers, not proofs. Nothing was built or run. What I say from memory of a literature is marked, and unchecked.*

## In short

1. The root is a language (relations on one set, with a sameness) and its logic, not axioms with content. Its theorems hold of every relation, so they cannot say what any particular system does. Everything in the package already follows from no axioms; the content sits in the models' definitions and each theorem's hypotheses. In that sense, the only one available here, "everything derives from a minimal root" is already true. That is why it feels empty.
2. The package holds nine distinct models. Most are joined by real lemmas. The lock and the stock are joined by words: by a search of identifiers in the code bodies, no lock module names a `Flow`, `Web` or `World` term, and none of the six later modules said to touch both names a lock term.
3. No single model proves the central loop. The nearest, `PoolFromCourse`, proves three links and assumes the fourth (`Accrues`: the loss grows by at least one every step, for ever). A finite stock in a closed whole cannot meet that, so as written the two sides do not fit. The join can be built: composition, not new mathematics, yielding one condition.

## Part A

### 1. What the root is

`Grammar.lean` (75 theorems) takes a set, a relation `R` ("x is a condition of y") and an equivalence relation `E` (a class: sameness in one respect). In ordinary terms: a transition system, that is a directed graph, seen through a partition.

- Continuation is `R ∩ E`.
- Constancy (`«有常»`) is, for a class, bisimulation: alike now and alike in all each can become (Park, Milner).
- The core (`«核»`) is the greatest bisimulation inside `E`; the "root theorem" (`«根»`) says such a greatest one exists.
- 生生 is a greatest fixed point: the largest family each member of which renews into a member. 息 is the least fixed point of the dual: what must stop. They exclude each other (`«生生不息»`).

`GrammarLaws.lean` (217 theorems) adds elementary lemmas: reach is the least region closed under the steps; paired lists have equal counts; on a finite set a map merges nothing exactly where every point returns; a falling whole number stops falling; a part carries a law of its own exactly where the step keeps sameness under the projection (a quotient; lumpability); strict inclusion is a strict order.

It is correct, constructive, and textbook. Every statement holds for every set and relation. So a root theorem is true of every graph, and a statement false of some graph (a threshold, a lock, a drain) can never be one. "Derived from the root" can only mean a root lemma applied to a relation built from a model, the model's hypotheses carried along. 08 §6 is headed "Expressible is not derived". More bluntly: the grammar is the logic, not the theory.

"A minimal root", in four senses:

- *Axioms.* Achieved trivially: there are none. The price: 61 predicates assumed somewhere and concluded nowhere by name (08 §7).
- *A universal language.* Without pairing, the relational calculus is three-variable logic (08 §6) and cannot count. Lean is the language in use.
- *One parametrised model.* Not there. Achievable for the centre (§3), not for all 117 declarations.
- *One pattern the models instance.* Achievable, half proved (Part B).

### 2. The real modules

| | Carrier and data | Modules |
|---|---|---|
| G | a relation and a class on one set | `Grammar`, `GrammarLaws` |
| P | a labelled step relation; a `Law` (a map); a `Run` | `Frame`, `Laws` |
| W | a sequence of records over ℕ: levels, activity, needs, takes, gives | `World`, `Flow`, `DrawnBeyond` |
| O | outcomes `C → ℕ`, an eligible set, an order rising on a family | `Optimum` |
| S | one level under a standing draw, `x ↦ (x−H) + g(x−H)` | `RegimeMargin` |
| D | cohorts with offspring lists | `SelectionTerm`, `SelectionLevels` |
| L | a two-level map on share × rule, two preorders; the loss an extra counter | `Pace`, `RuleCapture`, `ClosedCapture`, `RuleShaping`, `PoolFromCourse` |
| N | two hand-built nets: a reader, or a rule, rebuilt from a level | `ReaderRebuilding`, `RuleRebuilding` |
| C | orders on courses; widening | `Weightings`, `PersistingChoices` |

What joins them:

- **G–P: a representation theorem, both ways** (`moveRel_mk`, `steps_edgeProcess`; 01 §8.1).
- **P–W: by type.** A `World` is a `Run` of the process that admits every step: a bare sequence with fields, not a system with a law. Its eight premises are predicates on sequences (`World.independent` measures free fields; 01 §8.2).
- **W–O, W–S, W–D, W–C: bridge lemmas** (`Web.optimum_broken_iff`; `FourReaders.stopped_is_regime`; `SelectionTerm.Flow.*`; `Web.widens_iff`).
- **D–L: one bridge lemma** (`CarrierCounts.share_not_lower_counts`). **L–P: by definition** (`paced` is a `Law.run`); the lumping law is really used (`ClosedCapture.identifiesAlike_iff_unread`).
- **L–W: a shared word.** "Share" has the bridge above. "Loss" (a counter in L) and "level beyond" (a stock in W) have none.
- **N–everything: a shared word.** Both import only `GrammarLaws`; `RuleRebuilding` lists "a bridge to `Flow`" as not proved.
- **The six later modules** (`BeyondCoupling`, `ReadOffInTime`, `ReadingsSpread`, `FromTheDynamics`, `PersistingChoices`, `ConditionInTime`) all live on W. `ReadOffInTime` calls its link to L's reading step a reading. `ReadingsSpread`'s "lock" (readings closed under revision) is not L's `Locked`. Only `ChoiceCountCapture` and `PairSelection` name terms of both sides, side by side.

### 3. The loop

| Link | Nearest statement | On | How it stands |
|---|---|---|---|
| a rule reset from its own picks holds | `RuleCapture.locked_stays`, `uniform_locks` | L | theorem, given `Raises`, `ReadsShare` |
| its picks draw down what it does not read | `ClosedCapture.lock_outlives_loss` | L | the drawdown is the hypothesis `Accrues`; that the lock ignores it is the theorem |
| | `Flow.Balances.beyond_falls_exactly`, `Optimum.least_of_room` | W, O | theorems; no rule, no lock |
| what could read the loss stands on it and is removed | `PoolFromCourse.window_never_read` | L | "stands" is the definition `loss < K`; removal before reading is the hypothesis `K ≤ N` |
| | `ReadingsPersist.RemovesItsReaders` | W | a definition and a witness; "not the meta-attractor itself" |
| then judged only by its own picks, for good | `PoolFromCourse.window_locked_after_removal` | L | theorem |

So: no. The published map's first path says the same (steps 3 and 4).

A further problem. `Accrues` makes the loss pass every bound; a stock drawn down with no inflow bounds its own loss. And L's selection multiplies counts; read as populations, W allows that only with replenishment without bound (`More.replenishment_unbounded`). L is an open-growth model, W a conservation model. One model must choose.

**The smallest single model.** State `(a, x, g)`: share, stock, rule.

- `a' = f(a, g)`, with `Raises`.
- `x' = (x − H(a,g)) + ρ(x − H(a,g))`: `RegimeMargin`'s step, the draw `H` rising with share and rule, the giving-back `ρ` bounded.
- At reading steps `g' = hL(a, x)` where `m ≤ x ≤ v`, else `hA(a)`: `m` is the level the stock's readers need in order to stand, `v` the level at which its fall first shows to them.

**Closing (aim).** From a locked start whose draw comes to exceed `ρ`: if `v < m`, the stock is below its point of no return within a stated number of steps and stays there; the readers are gone from a stated step; the lock holds throughout; from then the course is the share's own loop. Four links, no `Accrues`.

**Corollary.** A reader that reads the stock only through its own going on has `v < m` by definition (on W, `Web.too_late_of_own`). So judging by who is still standing closes the loop with no further premise.

**The way back (aim).** The rule turns for good and the stock recovers exactly where three things hold in order. The fall shows while the readers stand (`v ≥ m`). At that reading and the next the readers outweigh: the reverse of `ReadInTime.kept_iff`'s `carrier·c + other·c ≤ carrier·hi + other·lo'`. And the stock is still above the point of no return under the *reduced* draw (`RegimeMargin.ends_iff_below`). The interesting condition is a race: the stock's slack above `v`, over the net drain, against the steps the share needs to reach critical mass. Fail the third and `Drained.strong_undone` becomes a law: the rule turns, the readers are lost anyway, the lock returns.

I expect both true. The proofs are regions kept by an order-preserving step plus counting steps to a first crossing, as in `window_order_kept`: composition, not new mathematics. From memory, unchecked: the nearest published models are game–environment feedback (Weitz and others 2016), resource and population (Brander and Taylor 1998) and lock-in (Arthur 1989). I have not seen a sensor worn away by what it senses stated with an exact order of three times. A modest claim, but the work's own.

### 4. The 36 and the 99

A fact about the content, and a sign the yardstick is wrong. Root theorems hold of every graph; the central results concern systems with amounts, thresholds and orders. "Distance from the root" measures how much of a proof reuses generic lemmas: library hygiene. Fifty of the 99 (32 with balance, 18 on amounts) are far only because the grammar has no numbers. The 36 are premises, counting identities, laws of single models and definitions (`ec6-no-master-law/AUDIT.md`): nothing to close.

The measure also misstates weight: lumping gets 2 rows, closure 42. Yet lumping is the one idea present at the root (`«核»`), in what a selection reaches, in learnability and in closed capture.

Measure instead: for each pair of models, whether a map between them is proved; for each link of the loop, whether it is a theorem on one model.

## Part B

**(i) The five laws as root.** Broken as stated. They are the proof methods of discrete mathematics (induction, counting, pigeonhole and descent, quotient, inclusion), on which any large library about discrete systems rests. They miss two the centre uses: a step that keeps an order (`RuleCapture.order_kept`, every lock law) and an extremum under a constraint (`Optimum.least_iff`). And they concern three objects: a transition system (closure, runs, lumping), a conserved amount (balance), a family of subsets (widening). *Survives:* an index of methods.

**(ii) Closure of processes and constraints at two grains.** Survives, made exact. The object: a fast state stepped by a rule, the rule rebuilt from what it reads of the state: `x' = f(x,g)`, `g' = h(π(x), g)`. This is `Pace.paced` with a projection `π`. "Closure" is a region the step keeps (`Locked`). Forming is entering it (`uniform_locks`); persisting, staying (`locked_stays`); changing, drift inside (`locked_rises`); ending, an unread coordinate coming to bear (`Borne.shapers_left`, `RegimeMargin.ends_below`). *Fits:* the lock, shaping, the reading loop, both N nets, and the root's 生生, also a family that keeps reproducing itself. *Does not fit:* the drain at an optimum (one step, nothing rebuilt), Price's identity, conservation, and the ranking results, which compare courses. "The parts are one closure seen at different constraints" is today a reading; it becomes a claim when each named model is proved an instance.

**(iii) Three coordinates of a return.** Survives as the quantity of (ii), not a rival. Exact object: the gain round a loop whose edges carry an amount, a delay and an endpoint. `RuleShaping` has all three: `favours_iff` (`c ≤ s`: how much), `stretch_iff` (how soon), `grouped_rises_iff` (to what). *Does not fit:* the lock's invariance, lumping, the drain. It organises thresholds, not laws.

**A better candidate, half proved already.** One idea runs from root to centre: *a part that carries its own law*. At the root it is the core. In `ClosedCapture` the loop is a quotient of the whole exactly where nothing beyond the share is read, and then nothing in the unread remainder moves it. A selection's reach and learnability rest on the same law. In one sentence: **a selection is a quotient of the world that runs by itself; what it leaves out cannot move it, and it can still use that up.** (ii) adds that the quotient rebuilds its own rule; (iii), when that pays.

**What I would build, in order.**

1. The stock in place of `Accrues`: the model above, the closing theorem, the corollary.
2. The way back, with its three-part condition.
3. Instance theorems: `ReaderRebuilding`'s member rebuilt from the level, `RuleRebuilding`'s `.members`, the reading loop and `ChoiceCountCapture` as cases of the one structure, or why each is not.
4. A map from a balanced `World` with descent onto the model, settling open against closed.

What this lets the work claim: the loop as one theorem with one stated condition, where the map now has an assumption and built examples; a prediction ordering three measurable times, which a frozen test can fail; and, to "are they separate parts?", a list of proved instances and named exceptions.

## Verdict

Sound, but carried out in a way that hides it. The mistake was measuring unity against the grammar: weeks went to lifting statements onto a language that cannot hold their content, while the two halves of the central loop were never put in one model. The Lean is honest throughout ("near-definitional", "not derived", "a reading"). The front pages keep the honesty and lose the shape.

Most needed, in order:

1. Prove the loop on one model with a stock. Until then the centre is an assembly.
2. Stop counting distance from the grammar. Say plainly: the root is a language and its logic; the theory is one structure and its instances; evolution's identities and the orders on courses are neighbours, each joined by a named lemma.
3. Prove or refute the instance claims. Each is small; each failure is something the map needs.
